From: Eddie <stunnel@attglobal.net>
Subject: Re: Should I be Worried: sda: p1 size .... limited to end of disk
Date: Mon, 12 Oct 2009 13:04:58 -0700
Message-ID: <4AD38BEA.4090202@attglobal.net>
References: <4AD0E466.2070904@attglobal.net> <da824cf30910121204l4edd75e7pa05386732ccb7556@mail.gmail.com>
Reply-To: stunnel@attglobal.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kcout01.prserv.net ([12.154.55.31]:54824 "EHLO
	kcout01.prserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZJLUFk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2009 16:05:40 -0400
In-Reply-To: <da824cf30910121204l4edd75e7pa05386732ccb7556@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

Grant Grundler wrote:
> On Sat, Oct 10, 2009 at 12:45 PM, Eddie <stunnel@attglobal.net> wrote:
>   
>> After the fun and games with my other LSI MegaRAID card, I'm a glutton for
>> punishment.
>>
>> I'm building another system, which this time, has an LSI MegaRAID SATA
>> 300-8X controller in it.  This appears to be working perfectly, and a lot
>> faster than my other card, with the exception of this warning message during
>> boot:
>>
>> sda: p1 size 2930304132 limited to end of disk
>>     
>
> sda only has 2929686528 blocks - "p1" is somehow defined to go past
> the end of the RAID "device".
>
> I've no clue where the "2930304132" is coming from. I'd want to see
> the "raw" values the partition table.
> Seems like the partition table was written with the wrong size,
>   
The raw partition table entry is:

00 01 01 00 8E FE FF FF 3F 00 00 00 84 E4 A8 AE

Active Flag = 00
Starting Head = 01
Starting Cylinder = 0001
Partition Type = x'8E' - Linux LVM
Ending Head = x'FE' - 254
Ending Cylinder/Sector = x'FFFF' - LBA
Offset to Start = x'0000003F' - 63
# of Sectors = x'AEA8E484' - 2930304132 - Hmmmmmmm

So, that looks like the culprit.  Now, how did it happen.  I know I can, 
sort of safely, rebuild that, by running (c)fdisk and making sure I 
start the partition at exactly the same point.  But all I did the first 
time, was use cfdisk, and allocate the complete disk to the 1st primary 
partition.

>> Is this something I should be worried about, and how does it come about.  I
>> built a new RAID 5, Logical device, on the card, which the LSI utility says
>> is 1430511MB in size.
>>     
>
> 1430511*1024*2
> 2929686528
>
>   
>> Here's the relevant output from DMESG:
>>
>> scsi 4:1:0:0: Direct-Access     MegaRAID LD 0 RAID5 1430G 815C PQ: 0 ANSI: 2
>> sd 4:1:0:0: [sda] 2929686528 512-byte hardware sectors: (1.49 TB/1.36 TiB)
>> sd 4:1:0:0: [sda] Write Protect is off
>> sd 4:1:0:0: [sda] Mode Sense: 00 00 00 00
>> sd 4:1:0:0: [sda] Asking for cache data failed
>> sd 4:1:0:0: [sda] Assuming drive cache: write through
>> sd 4:1:0:0: [sda] 2929686528 512-byte hardware sectors: (1.49 TB/1.36 TiB)
>> sd 4:1:0:0: [sda] Write Protect is off
>> sd 4:1:0:0: [sda] Mode Sense: 00 00 00 00
>> sd 4:1:0:0: [sda] Asking for cache data failed
>> sd 4:1:0:0: [sda] Assuming drive cache: write through
>> sda: sda1
>> sda: p1 size 2930304132 limited to end of disk
>> sd 4:1:0:0: [sda] Attached SCSI disk
>> sd 4:1:0:0: Attached scsi generic sg1 type 0
>>
>> And /proc/partions:
>>
>> major minor  #blocks  name
>>
>>  3        0   20044080 hda
>>  3        1    9727326 hda1
>>  3        2    9727357 hda2
>>  3        4     586372 hda4
>>  8        0 1464843264 sda
>>  8        1 1464843232 sda1
>> 253        0  314572800 dm-0
>> 253        1  157286400 dm-1
>> 253        2  209715200 dm-2
>> 253        3  104857600 dm-3
>> 253        4  104857600 dm-4
>> 253        5  262144000 dm-5
>>
>>
>> And fdisk:
>>
>> Disk /dev/sda: 1499.9 GB, 1499999502336 bytes
>> 255 heads, 63 sectors/track, 182364 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0x0003d809
>>
>>  Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1               1      182403  1465152066   8e  Linux LVM
>>
>> So, where is the discrepancy creeping in.
>>     
>
> Can you print this using "Units of Blocks" instead of "Cyclinders"?
> Use "-u" parameter.
>   

fdisk -l -u /dev/sda

Disk /dev/sda: 1499.9 GB, 1499999502336 bytes
255 heads, 63 sectors/track, 182364 cylinders, total 2929686528 sectors
Units = sectors of 1 * 512 = 512 bytes
Disk identifier: 0x0003d809

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63  2930304194  1465152066   8e  Linux LVM

> hth,
> grant
>
>   
>> Also, I see this in DMESG:
>>
>> sd 4:1:0:0: [sda] Assuming drive cache: write through
>>
>> But, as this card has a battery backup, I have it set to "Write Back" in the
>> configuration.  So, what mode is it really operating in.
>>
>> Cheers,
>> Eddie
>>
>>
>>     
Cheers,
Eddie


