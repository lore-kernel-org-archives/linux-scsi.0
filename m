From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Subject: System reboots after insertion and removal of disks in 2.6.18 kernel
Date: Thu, 27 Mar 2008 10:46:14 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C8392667D4C7E7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pmc216-241-226-183.pmc-sierra.bc.ca ([216.241.226.183]:56710
	"EHLO pmxedge1.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750727AbYC0RpA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 13:45:00 -0400
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca (BBY1EXG02.pmc-sierra.bc.ca [216.241.231.167])
	by pmxedge1.pmc-sierra.bc.ca (8.13.4/8.12.11) with ESMTP id m2RHiki7021528
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2008 10:44:47 -0700
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <'linux-scsi@vger.kernel.org'>

Hello folks,
 
I am currently working on NAS which has sil 3114 SATA controller.There is some strange scenario reported by product validation team.When I insert the drive and remove immediately without settling down,
the system gets reset after roughly 30 seconds. Tried to capture the log from drivers but couldn't get any of the stack dump or kernel panic in due course. I am using 2.6.18 kernel and sata_sil is enabled.
Rest functionality works pretty fine. But only when I do insert and remove without time gap, the system resets. Strange thing is when I insert the disk and remove it back immediately the interrupt line asserted is only for insert and not for removal.  Sata controller is not getting interrupt for second immediate drive removal. Hence I guess that the interrupt line should be level triggered. Now based on the logs captured, I can say that in this typical case, sata controller first gets the request to handle drive insertion. It waits for some time to check the status to ensure that it is proper request and after that it again reads the line. It finds that drive is removed till that time. But actually SATA controller is not detecting the remove instance as it is not reflected in GPIO transiti
 on as well. So I get messages like COMRESET Failed and hard reset failed. This doesn't happen if I insert back the drive immediately. The system immediately recovers. 
 
Attaching the log
 
After only inserting drive:
( No issues here: )
 
?[root@NAS00180001310e ~]# Drive 2 inserted
ata2: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 NCQ (depth
0/32)
ata2.00: ata2: dev 0 multi count 0
ata2.00: configured for UDMA/100
ata2: EH complete
 Vendor: ATA       Model: WDC WD2500YS-01S  Rev: 20.0
 Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
sdd: Write Protect is off
SCSI device sdd: drive cache: write back
SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
sdd: Write Protect is off
SCSI device sdd: drive cache: write back
 sdd:
sd 1:0:0:0: Attached scsi disk sdd
sd 1:0:0:0: Attached scsi generic sg3 type 0
 
After insertion and immediate removal: Reboot:
 

?[root@NAS00180001310e ~]# Drive 2 inserted
ata2: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0x2 frozen
ata2: hard resetting port
ata2: port is slow to respond, please be patient
ata2: port failed to respond (30 secs)  ---------------------> At this state, actually the drive is removed. But not detected. 
ata2: COMRESET failed (device not ready)
ata2: hardreset failed, retrying in 5 secs
ata2: hard resetting port
ata2: SATA link down (SStatus 0 SControl 310)
ata2: EH complete
 
?
PMON2000 MIPS Initializing. Standby...
ERRORPC=bfc00004 CONFIG=0042e4bb STATUS=00400000
CPU PRID 000034c1, MaskID 00001320
Initializing caches...done (CONFIG=0042e4bb)
Switching to runtime address map...done
Setting up SDRAM controller: sdram config 0x80010000
master clock 100 Mhz, MulFundBIU 0x02, DivXSDRAM 0x02
sdram freq 0x09ef21aa hz, sdram period: 0x06 nsec
dimm0: density 256Mbit, width 16, single-sided, unbuffered, size
0x08000000
 supported CAS latency: 2.5 2, using 2.5 cycles, byte18=0x0c
 RAS to CAS delay (tRCD) 0x12 nsec, byte29=0x
 

Any pointers are really appreciated.
 
Thanks in advance,
Sagar
 
 
