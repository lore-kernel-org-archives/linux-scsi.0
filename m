From: Eddie <stunnel@attglobal.net>
Subject: Should I be Worried: sda: p1 size .... limited to end of disk
Date: Sat, 10 Oct 2009 12:45:42 -0700
Message-ID: <4AD0E466.2070904@attglobal.net>
Reply-To: stunnel@attglobal.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kcout01.prserv.net ([12.154.55.31]:60822 "EHLO
	kcout01.prserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbZJJTq3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Oct 2009 15:46:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

After the fun and games with my other LSI MegaRAID card, I'm a glutton 
for punishment.

I'm building another system, which this time, has an LSI MegaRAID SATA 
300-8X controller in it.  This appears to be working perfectly, and a 
lot faster than my other card, with the exception of this warning 
message during boot:

sda: p1 size 2930304132 limited to end of disk

Is this something I should be worried about, and how does it come 
about.  I built a new RAID 5, Logical device, on the card, which the LSI 
utility says is 1430511MB in size.

Here's the relevant output from DMESG:

scsi 4:1:0:0: Direct-Access     MegaRAID LD 0 RAID5 1430G 815C PQ: 0 ANSI: 2
sd 4:1:0:0: [sda] 2929686528 512-byte hardware sectors: (1.49 TB/1.36 TiB)
sd 4:1:0:0: [sda] Write Protect is off
sd 4:1:0:0: [sda] Mode Sense: 00 00 00 00
sd 4:1:0:0: [sda] Asking for cache data failed
sd 4:1:0:0: [sda] Assuming drive cache: write through
sd 4:1:0:0: [sda] 2929686528 512-byte hardware sectors: (1.49 TB/1.36 TiB)
sd 4:1:0:0: [sda] Write Protect is off
sd 4:1:0:0: [sda] Mode Sense: 00 00 00 00
sd 4:1:0:0: [sda] Asking for cache data failed
sd 4:1:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sda: p1 size 2930304132 limited to end of disk
sd 4:1:0:0: [sda] Attached SCSI disk
sd 4:1:0:0: Attached scsi generic sg1 type 0

And /proc/partions:

major minor  #blocks  name

   3        0   20044080 hda
   3        1    9727326 hda1
   3        2    9727357 hda2
   3        4     586372 hda4
   8        0 1464843264 sda
   8        1 1464843232 sda1
 253        0  314572800 dm-0
 253        1  157286400 dm-1
 253        2  209715200 dm-2
 253        3  104857600 dm-3
 253        4  104857600 dm-4
 253        5  262144000 dm-5


And fdisk:

Disk /dev/sda: 1499.9 GB, 1499999502336 bytes
255 heads, 63 sectors/track, 182364 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0003d809

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      182403  1465152066   8e  Linux LVM

So, where is the discrepancy creeping in.

Also, I see this in DMESG:

sd 4:1:0:0: [sda] Assuming drive cache: write through

But, as this card has a battery backup, I have it set to "Write Back" in 
the configuration.  So, what mode is it really operating in.

Cheers,
Eddie

