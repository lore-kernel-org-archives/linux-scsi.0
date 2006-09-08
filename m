From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Data read/write slows down other programs dramatically (2.6.18-rc2)
Date: Thu, 7 Sep 2006 21:16:25 -0600
Message-ID: <8202f4270609072016x4bc549cdlf58d305d62b9c4d9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:59202 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1752058AbWIHDQ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 23:16:26 -0400
Received: by py-out-1112.google.com with SMTP id n25so582038pyg
        for <linux-scsi@vger.kernel.org>; Thu, 07 Sep 2006 20:16:26 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I use ATA pass through via sg ioctl interface for data read/write.
Linux 2.6.18-rc2 with Jeff Garzik's git libata patch was used.
Hardware is ARM IOP80321 with PCI-X. Host adapters: sata Sil3124 and
pata Sil680. Physical RAM on the target is 64MB.

The following problem was observed occasionally: the test program uses
99% of cpu and other programs slowed down dramatically: telnet session
was very slow to respond,  ip connection was almost time out...  It
seems the slowness was related to the dmesg traces below (just an
observation which may not be true). Has anyone seen similar problem
before? Is there any place in sg/scsi/libata code I should look closely?

Thanks,
Fajun
---------
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata1: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata1: (irq_stat 0x01100010, PHY RDY changed)
ata1: waiting for device to spin up (8 secs)
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 1465149168 512-byte hdwr sectors (750156 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0xd0000 action 0x2 frozen
ata2: (irq_stat 0x01900090, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0xd0000 action 0x2 frozen
ata2: (irq_stat 0x01900090, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata1: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata1: (irq_stat 0x01100010, PHY RDY changed)
ata1: waiting for device to spin up (8 secs)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 1465149168 512-byte hdwr sectors (750156 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x40d0000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: waiting for device to spin up (8 secs)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 1465149168 512-byte hdwr sectors (750156 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
ata2: exception Emask 0x10 SAct 0x0 SErr 0x80000 action 0x2 frozen
ata2: (irq_stat 0x01100010, PHY RDY changed)
ata2: soft resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: failed to recover some devices, retrying in 5 secs
ata1: exception Emask 0x10 SAct 0x0 SErr 0x80000 action 0x2 frozen
ata1: (irq_stat 0x01100010, PHY RDY changed)
ata1: soft resetting port
ata1: SATA link down (SStatus 0 SControl 300)
ata1: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2: failed to recover some devices, retrying in 5 secs
ata1: hard resetting port
ata1: SATA link down (SStatus 0 SControl 300)
ata1: failed to recover some devices, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 300)
ata2.00: disabled
sd 1:0:0:0: rejecting I/O to offline device
ata2: EH complete
ata2.00: detaching (SCSI 1:0:0:0)
ata1: hard resetting port
ata1: SATA link down (SStatus 0 SControl 300)
ata1.00: disabled
ata1: EH complete
ata1.00: detaching (SCSI 0:0:0:0)
