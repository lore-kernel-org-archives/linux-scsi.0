From: BingJiun Luo <luobingjiun@gmail.com>
Subject: Why is scsi_request_fn called every 4 milliseconds?
Date: Thu, 27 Jan 2011 22:04:53 +0800
Message-ID: <AANLkTinidWkKphNbYdtmhZc4G9WOJV-R6Mkyf_Vrpf4r@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I want to measure SATA AHCI Host controller read performance.  Open
/dev/sda and using  read(int fildes, void *buf, size_t nbyte) user space
function to read 2048 times, each time 64KByets, and total 128 Mbytes.

I measured the time start from one step before write CI register inside
ahci_qc_issue() function until ahci_port_intr () is called in the interrupt
context. It takes about 1 milliseconds to complete one 256KBytes READ
DMA EXT command, and spend about 15 microseconds call to scsi_done().

However, why scsi_request_fn is called about after 4 milliseconds
to pass next IO request for Hardware to issue? It take less if the READ
DMA command with less number of sectors.

My questions are:
1. Is it the time to prepare one 256 KB READ DMA EXT command by upper
layer (Block Layer or Virtual File system Layer)? Or, It is the time to copy
data from kernel space memory to user space memory after data is read
back from Hard Drive and delay the next command pass to SCSI?

I know some architecture has not good enough performance to do memcpy
or something like that.

2. If I do not mount /dev/sda to any file system, what is the first
kernel function
called after read() function from user space? Is it located at VFS or
directly to
Block layer?

Because I want to keep track the time spend at the layer higher than SCSI.

3. When scsi_done() is called, what is the function to process this completed
command and pass the data to user space? I think there might be somewhere
inside the code to copy this data from kernel space memory address to user
space memory address.


Thank you very much in advance.


Regards,
BingJiun
