pragma solidity ^0.4.17;

contract Lottery {
    address public Admin;
    address[] public players;
    
    function Lottery() public {
        Admin = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }
    //Pick a winning address based on a sudo-random hash converted to initergers.
    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players));
    }
    //pickWinner() picks the winning address, Only manager can call this function. After each round the player array is reset to 0.
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(this.balance);
        players = new address[](0);
    }
    // Only manager block
    modifier restricted() {
        require(msg.sender == Admin);
        _;
    }
    //Return all the players who entered.
    function getPlayers() public view returns (address[]) {
        return players;
    }
}   
