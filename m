From: "Ranjeet Shetye" <rshetye@hotmail.com>
Subject: Regression in 2.6.15 w.r.t Promise SATA 300 TX2Plus support
Date: Wed, 01 Feb 2006 19:08:07 +0000
Message-ID: <BAY103-F13D9836EE19BC1F5788BAEAB0B0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay103-f13.bay103.hotmail.com ([65.54.174.23]:6045 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S1422879AbWBATII
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Feb 2006 14:08:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


hi,

I have a Promise SATA 300 TX2plus card in my linux server (2 SATA ports, 1 
PATA port).

The 2.6.14 (archck7) kernel would not recognize the card, so I used lspci to 
find the device ID and I made the following change to sata_promise.c

--- drivers/scsi/sata_promise.c.ORIG    2005-12-28 22:38:27.000000000 -0800
+++ drivers/scsi/sata_promise.c 2005-12-28 22:33:24.000000000 -0800
@@ -209,6 +209,8 @@
          board_2037x },
        { PCI_VENDOR_ID_PROMISE, 0x3574, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
          board_2037x },
+       { PCI_VENDOR_ID_PROMISE, 0x3d73, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+         board_2037x },
        { PCI_VENDOR_ID_PROMISE, 0x3d75, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
          board_2037x },

After this change, the kernel started recognizing the card, and I could 
access the drives that I had attached to this machine viz. one SATA hard 
disk (sda) and one PATA hard disk (sdb).

# fdisk -l

Disk /dev/sda: 320.0 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1       38913   312568641   83  Linux

Disk /dev/sdb: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       24321   195358401   83  Linux


With the 2.6.15 kernel (archck2, vanilla), I don't need to add the device ID 
to the file
sata_promise.c cos it already contains it. The kernel still locates the card 
correctly,
but I have access only to the SATA disk. I don't have access to the PATA 
disk. I looked
at the newer sata_promise.c and I could see that some PATA functionality has 
been removed so I thought it best to post a message. I googled for answers 
but didn't find any. If this issue has already been resolved, or PATA on 
TX2plus should be accesssed using some other config option, a link would be 
appreciated. I am not on the mailing list, so please include my email in 
your replies.

Let me know if you need any other information.

thanks,
Ranjeet.

PS: I've attached the grepped output from the dmesgs for the 2 kernel 
versions.

# cat dmesg.2.6.14.txt | grep -i -e sda -e sdb -e scsi -e sata
SCSI subsystem initialized
scsi: <fdomain> Detection failed (no card)
Emulex LightPulse Fibre Channel SCSI driver 8.0.30
Failed initialization of WD-7000 SCSI card!
ipr: IBM Power RAID SCSI Device Driver version: 2.0.14 (May 2, 2005)
sata_promise version 1.02
sata_promise PATA port found
ata1: SATA max UDMA/133 cmd 0xE081A200 ctl 0xE081A238 bmdma 0x0 irq 11
ata2: SATA max UDMA/133 cmd 0xE081A280 ctl 0xE081A2B8 bmdma 0x0 irq 11
scsi2 : sata_promise
scsi3 : sata_promise
scsi4 : sata_promise
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
SCSI device sda: drive cache: write back
sda: sda1
Attached scsi disk sda at scsi3, channel 0, id 0, lun 0
SCSI device sdb: 390721968 512-byte hdwr sectors (200050 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 390721968 512-byte hdwr sectors (200050 MB)
SCSI device sdb: drive cache: write back
sdb: sdb1
Attached scsi disk sdb at scsi4, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi3, channel 0, id 0, lun 0,  type 0
Attached scsi generic sg1 at scsi4, channel 0, id 0, lun 0,  type 0
SCSI Media Changer driver v0.25
I2O SCSI Peripheral OSM v1.282
ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
ReiserFS: sdb1: using ordered data mode
ReiserFS: sdb1: journal params: device sdb1, size 8192, journal first block 
18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdb1: checking transaction log (sdb1)
ReiserFS: sdb1: Using r5 hash to sort names
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 
18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names

# cat dmesg.2.6.15.txt | grep -i -e sda -e sdb -e scsi -e sata
SCSI subsystem initialized
scsi: <fdomain> Detection failed (no card)
Emulex LightPulse Fibre Channel SCSI driver 8.1.0
Failed initialization of WD-7000 SCSI card!
ipr: IBM Power RAID SCSI Device Driver version: 2.1.0 (October 31, 2005)
sata_promise 0000:00:10.0: version 1.03
ata1: SATA max UDMA/133 cmd 0xE081A200 ctl 0xE081A238 bmdma 0x0 irq 11
ata2: SATA max UDMA/133 cmd 0xE081A280 ctl 0xE081A2B8 bmdma 0x0 irq 11
scsi2 : sata_promise
scsi3 : sata_promise
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
SCSI device sda: drive cache: write back
sda: sda1
sd 3:0:0:0: Attached scsi disk sda
sd 3:0:0:0: Attached scsi generic sg0 type 0
SCSI Media Changer driver v0.25
I2O SCSI Peripheral OSM v1.282
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 
18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names


