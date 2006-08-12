From: Chris Stromsoe <cbs@cts.ucla.edu>
Subject: Symbios Logic 53C876 detected as 53C875, then doesn't work
Date: Sat, 12 Aug 2006 01:17:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608120108330.21468@potato.cts.ucla.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1.smtp.ucla.edu ([169.232.46.136]:56473 "EHLO
	smtp-1.smtp.ucla.edu") by vger.kernel.org with ESMTP
	id S932300AbWHLIRy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 04:17:54 -0400
Received: from potato.cts.ucla.edu (potato.cts.ucla.edu [128.97.128.80])
	by smtp-1.smtp.ucla.edu (8.13.6/8.13.6) with ESMTP id k7C8HscT015040
	for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2006 01:17:54 -0700
Received: from potato.cts.ucla.edu (localhost [127.0.0.1])
	by potato.cts.ucla.edu (8.13.4/8.13.4/Debian-3sarge1) with ESMTP id k7C8HsG1027390
	for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2006 01:17:54 -0700
Received: from localhost (cbs@localhost)
	by potato.cts.ucla.edu (8.13.4/8.13.4/Submit) with ESMTP id k7C8Hrk9027387
	for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2006 01:17:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have several Symbios Logic 53c875 cards that I'm trying to get working 
with 2.6.17.8 i386.  The cards are all functional under Solaris and were 
pulled from E450 within the last week.

One of the cards is not recognized at all (PCI ID 1000:0007).  The other 
cards are PCI ID 1000:000f.

Booting with with the 1000:000f cards and append="sym53c8xx.verb=2" gives 
me:

PCI: Enabling device 0000:01:02.0 (0000 -> 0003)
PCI: Setting latency timer of device 0000:01:02.0 to 64
sym0: <875> rev 0x14 at pci 0000:01:02.0 irq 0
sym0: clock multiplier found
sym0: No NVRAM, ID 7, Fast-20, HVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: initial SCNTL3/DMODE/DCNTL/CTEST3/4/5 = (hex) 07/ce/a8/01/80/24
sym0: final   SCNTL3/DMODE/DCNTL/CTEST3/4/5 = (hex) 05/46/80/01/08/24
CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
sym0: CACHE INCORRECTLY CONFIGURED.
sym0: giving up ...

PCI: Enabling device 0000:01:02.1 (0000 -> 0003)
PCI: Setting latency timer of device 0000:01:02.1 to 64
sym0: <875> rev 0x14 at pci 0000:01:02.1 irq 0
sym0: clock multiplier found
sym0: No NVRAM, ID 7, Fast-20, HVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: initial SCNTL3/DMODE/DCNTL/CTEST3/4/5 = (hex) 07/ce/a8/01/80/24
sym0: final   SCNTL3/DMODE/DCNTL/CTEST3/4/5 = (hex) 05/46/80/01/08/24
CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
sym0: CACHE INCORRECTLY CONFIGURED.
sym0: giving up ...



lspci -vvv -n shows:

0000:01:02.0 0100: 1000:000f (rev 14)
         Subsystem: 4028:0080
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR+ <PERR+
         Region 0: I/O ports at 1000 [size=256]
         Region 1: Memory at 88003000 (32-bit, non-prefetchable) [size=256]
         Region 2: Memory at 88000000 (32-bit, non-prefetchable) [size=4K]
         Region 4: Memory at <ignored> (32-bit, non-prefetchable)
         Region 5: I/O ports at 82000020 [size=16]
         Expansion ROM at 88002000 [disabled] [size=2K]

0000:01:02.1 0100: 1000:000f (rev 14)
         Subsystem: 4028:0080
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+
         Region 0: I/O ports at 1400 [size=256]
         Region 1: Memory at 88003100 (32-bit, non-prefetchable) [size=256]
         Region 2: Memory at 88001000 (32-bit, non-prefetchable) [size=4K]
         Region 4: Memory at <ignored> (32-bit, non-prefetchable)
         Region 5: I/O ports at c2000020 [size=16]
         Expansion ROM at 88002800 [disabled] [size=2K]



Any ideas?



-Chris
