From: Steven Dake <sdake@mvista.com>
Subject: Re: A modern RAID solution?
Date: Mon, 28 Oct 2002 11:17:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DBD7F44.3000804@mvista.com>
References: <20021027153048.GA5642@angle.setup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alexy Khrabrov <braver@pobox.com>
Cc: linux-scsi@vger.kernel.org

Alexy,

As a previous RAID card engineer, I can definately say if your system is 
fast you won't see much improvement from an I/O card based RAID adaptor 
for either RAID 0 or RAID 1.  Keep in mind that the OS must still send 
messages to each adaptor over the PCI bus so the data transferred is 
nearly the same and with SCSI command qeueing each disk can accept 
multiple commands at once.  RAID 5 will see improvement because the I/O 
processors have special hardware to do 8 or 16 parallel XOR 
calculations.  Also generally I/O processors on the RAID cards run at 
much slower speeds then the 2 ghz standard PC these days.  One advantage 
of a hardware raid card is that is can accept more commands in an I/O 
queue (reducing read/write response time but improving performance). 
 There aren't alot of applications where this is useful unless you do 
alot of writing and not much reading or the raid card implements a 
special i/o channel for reads (which none do that I am aware of).

The adaptec "host raid 0/1" means that the host machine (your pc) is 
responsible for the striping or mirroring.  The adaptec adaptor just 
provides "bios mapping" to the disk layout specified by the design so 
the device can be booted.  This is equivalent to the MD driver except 
the MD driver is probably more optimized then Adaptec's driver if they 
have one for linux.  This is also how the "IDE RAID" cards work just 
providing BIOS mapping so int13s i/os match the layout of the disks.

Alexy Khrabrov wrote:

>Now that I got all those drives spinning, I'm eager to try out 
>a RAID array.  I reckon it's a better way to hedge against disk
>failures than backups on tape -- even 20/40 GB dds4 or DLT is
>not enough those days, and loading/rotating is tedious.
>
>I heard an opinion that software RAID on Linux with SCSI is
>"almost" as good as a hardware controller.  What is the experience
>here?  Also, since I'm running LVM throughout, including the root
>partition, does RAID coexist well with LVM?
>
>But if I go the way of the hardware controller, is it better
>to get a separate one, or one of those new cards from Adaptec
>which say they have a Host RAID 0/1 or some such?
>
>I'm looking at a 3 drives RAID to begin with, perhaps 4.
>
>  
>

