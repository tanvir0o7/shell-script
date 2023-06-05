#! /bin/bash
#functions
function Banner(){ #Banner
    clear
    str=$(cat banner.txt) #taking the output of cat command as variable
    echo "$str" 
    echo
}

function MainMenu(){
    # '-e' Interprets escape sequences
    echo -e "\t[1] Inventory"
    echo -e "\t[2] Restock"
    echo -e "\t[3] Sells"
    echo -e "\t[4] Exit"
    echo 
}

function InventoryMenu(){
    echo -e "\t[1] View Inventory"
    echo -e "\t[2] Search"
    echo -e "\t[3] Discontinue"
    echo
}

function View(){
    # printf - utility/command like echo
    # %20s - 20 spaces before printing the string
    printf "|%25s|%25s|%25s|%25s|%25s(BDT)|\n" ID Product Category Quantity Price

    # Read the file
    while IFS=":" read -r id product category quantity price;do
        printf "|%25s|%25s|%25s|%25s|%25s(BDT)|\n" "$id" "$product" "$category" "$quantity" "$price"
    done < inventory.txt
    : '
        Here, the while loop is reading the file line by line.
        IFS variable indicates which character is seperating each column in the file.
        In the file, the info is stored as str:str:str:str:str format.
        So each of the string is being separated and stored in their respective variables and 
        being printed using format strings with printf utility. 
        [Line 37 to 39]
    '
    
}

function Search(){
    read -p "Search[Category (i.e Notebook)]: " category
    printf "|%25s|%25s|%25s|%25s(BDT)|\n" ID Product Quantity Price
    : "
        grep '$category' -i inventory.txt checks for products with given category
        the pipe (|) takes the output of the command above as input and reads the product info from
        the output.
    "
    grep "$category" -i inventory.txt | while IFS=":" read -r id product category quantity price;do
        printf "|%25s|%25s|%25s|%25s(BDT)|\n" "$id" "$product" "$quantity" "$price"
    done 
}

function Discontinue(){
    Banner
    View
    read -p "Enter Product ID to Remove from Inventory: " id
    sed -i "/^$id:/d" inventory.txt #/^8:/d
    echo "Product with ID $id is now Discontinued"
}

function Restock(){
    View
    read -p "Number of Products for Restocking: " num
    for ((iter = 0; iter < $num; iter++));do
        read -p "ID: " id
        read -p "Product: " product
        read -p "Category: " category
        read -p "Quantity: " quantity
        read -p "Price: " price
        printf "%s:%s:%s:%s:%s\n" "$id" "$product" "$category" "$quantity" "$price" >> inventory.txt 2>/dev/null
        echo "Successfully Restocked"
        echo "=========================================================================="
        echo
    done
}

function Sells(){
    View
     total=0
    while true; do
        read -p "Product[ID]: " id
        if (( id == 0 )); then
            echo "========================================="
            echo "Total Bill: $total"
            read -p "Paid: " paid
            echo "Change: $((total > paid ? (total - paid):(paid - total)))"
            break
        fi
        price=$(grep "$id:" inventory.txt | cut -d ':' -f 5)
        total=$((total + price))
    done

}

function main(){
    Banner
    MainMenu
    read -p ">>> " opt
    if (( opt == 1 )); # [[]] for strings, (()) for numeric conditions
        then 
            Banner
            InventoryMenu
            read -p ">>> " opt1
            if (( opt1 == 1 ));
                then
                    Banner 
                    View # Prints the contents of Inventory DB
                read -p "Press Enter to Continue"
            elif (( opt1 == 2 ));
                then 
                    Banner
                    Search
                    read -p "Press Enter to Continue"
            elif (( opt1 == 3 ));
                then 
                    Discontinue
                    read -p "Press Enter to Continue"
            fi

    elif (( opt == 2 ));
        then 
            Banner
            Restock
            read -p "Press Enter to Continue"
    
    elif (( opt == 3 ));
        then 
            Banner
            Sells
            read -p "Press Enter to Continue"
    elif (( opt == 4 ));
        then 
            exit 0 # Exists with status code 0
    else
        echo "[!] Invalid Option"
        read -p "Press Enter to Continue"
    fi
}

# Entry point
while true; do 
    main
done
