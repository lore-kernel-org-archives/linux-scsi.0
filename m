From: A E Lawrence <A.E.Lawrence@lboro.ac.uk>
Subject: sym53c8xx-2: repeated, but rare, disc corruption.
Date: Sun, 19 Dec 2004 15:52:35 +0000
Message-ID: <41C5A3C3.2010906@lboro.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scamper.lut.ac.uk ([158.125.1.219]:64691 "EHLO
	scamper.lut.ac.uk") by vger.kernel.org with ESMTP id S261301AbULSPuh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Dec 2004 10:50:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

Summary
~~~~~~~

Scsi disc (containing root filesystem with 3 other partitions) corrupted 
on 3 different occasions, a little less than once per year, so extremely 
rare. This seems to correlate to changing to the sym53c8xx_2 driver, 
over a range of 2.4 and 2.6 kernels.

Hardware was originally suspected, and the original host controller 
(ASUS PCI-SC875) was replaced by a LSIU40SE.

The cables have been rerouted and visually checked several times. The 
termination configuration has also been checked.

Physical layout: two internal cables: one wide, one narrow. Two logical 
scsi buses:

Wide bus:-
   scsi0 : sym-2.1.18j
   Vendor: IBM       Model: DCAS-34330W       Rev: S61A
   sym0:6:0: tagged command queuing enabled, command queue depth 16.
   scsi(0:0:6:0): Beginning Domain Validation
   sym0:6: wide asynchronous.
   sym0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
(This is the disc which has been corrupted on several occasions).

Narrow bus:-
   scsi1 : sym-2.1.18j
   Vendor: IBM       Model: DCAS-34330        Rev: S65A
   Type:   Direct-Access                      ANSI SCSI revision: 02
   sym1:4:0: tagged command queuing enabled, command queue depth 16.
   scsi(1:0:4:0): Beginning Domain Validation
   sym1:4: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 15)
(No problems seen on this bus).

Current hardware

#lspci -v

00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] 
(rev 02)
         Subsystem: ABIT Computer Corp. KT7/KT7-RAID/KT7A/KT7A-RAID 
Mainboard
         Flags: bus master, medium devsel, latency 8
         Memory at e0000000 (32-bit, prefetchable) [size=64M]
         Capabilities: [a0] AGP version 2.0
         Capabilities: [c0] Power Management version 2

00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP] 
(prog-if 00 [Normal decode])
         Flags: bus master, 66Mhz, medium devsel, latency 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         Memory behind bridge: e6000000-e8ffffff
         Prefetchable memory behind bridge: e4000000-e5ffffff
         Capabilities: [80] Power Management version 2

00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] 
(rev 22)
         Subsystem: ABIT Computer Corp.: Unknown device 0000
         Flags: bus master, stepping, medium devsel, latency 0

00:07.1 IDE interface: VIA Technologies, Inc. VT82C586B PIPC Bus Master 
IDE (rev 10) (prog-if 8a [Master SecP PriP])
         Subsystem: VIA Technologies, Inc. VT82C586B PIPC Bus Master IDE
        Flags: bus master, medium devsel, latency 32
         I/O ports at c000 [size=16]
         Capabilities: [c0] Power Management version 2

00:07.4 Bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 30)
         Subsystem: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
         Flags: medium devsel, IRQ 11
         Capabilities: [68] Power Management version 2

00:09.0 Ethernet controller: Lite-On Communications Inc LNE100TX (rev 20)
         Subsystem: Netgear FA310TX
         Flags: bus master, medium devsel, latency 32, IRQ 11
         I/O ports at cc00 [size=256]
         Memory at ea000000 (32-bit, non-prefetchable) [size=256]
         Expansion ROM at <unassigned> [disabled] [size=256K]

00:0f.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 37)
         Subsystem: LSI Logic / Symbios Logic: Unknown device 1010
         Flags: bus master, medium devsel, latency 72, IRQ 11
         I/O ports at d000 [size=256]
         Memory at ea001000 (32-bit, non-prefetchable) [size=256]
         Memory at ea002000 (32-bit, non-prefetchable) [size=4K]
         Expansion ROM at <unassigned> [disabled] [size=64K]
         Capabilities: [40] Power Management version 1

00:0f.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 37)
         Subsystem: LSI Logic / Symbios Logic: Unknown device 1010
         Flags: bus master, medium devsel, latency 72, IRQ 10
         I/O ports at d400 [size=256]
         Memory at ea003000 (32-bit, non-prefetchable) [size=256]
         Memory at ea004000 (32-bit, non-prefetchable) [size=4K]
         Expansion ROM at <unassigned> [disabled] [size=64K]
         Capabilities: [40] Power Management version 1

00:13.0 Unknown mass storage controller: Triones Technologies, Inc. 
HPT366/368/370/370A/372 (rev 03)
         Subsystem: Triones Technologies, Inc. HPT370A
         Flags: bus master, 66Mhz, medium devsel, latency 120, IRQ 11
         I/O ports at d800 [size=8]
         I/O ports at dc00 [size=4]
         I/O ports at e000 [size=8]
         I/O ports at e400 [size=4]
         I/O ports at e800 [size=256]
         Expansion ROM at <unassigned> [disabled] [size=128K]
         Capabilities: [60] Power Management version 2

01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G400 AGP 
(rev 04) (prog-if 00 [VGA])
         Subsystem: Matrox Graphics, Inc. Millennium G400 16Mb SGRAM
         Flags: bus master, medium devsel, latency 32, IRQ 11
         Memory at e4000000 (32-bit, prefetchable) [size=32M]
         Memory at e6000000 (32-bit, non-prefetchable) [size=16K]
         Memory at e7000000 (32-bit, non-prefetchable) [size=8M]
         Expansion ROM at <unassigned> [disabled] [size=64K]
         Capabilities: [dc] Power Management version 2
         Capabilities: [f0] AGP version 2.0

2.6.9 configuration:-
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Notes
_____

1) The wide cable and the IBM DCAS-34330W  Rev: S61A are always involved 
in the failures, so a hardware or firmware problem cannot be completely 
excluded. But since this is the root file system, it may simply be the 
much higher load on this bus.

2) ABORT sequences are relatively common on this bus and always appear 
to precede a corruption. Since the log file is in /var on the root 
filesystem, those preceeding a corruption are not available. The other 
ABORT sequences often last several minutes. Here is one that lasted 21 
seconds, but that presumably is just the expected timeout sequence.
Dec  6 22:50:24 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:50:29 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:50:29 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:50:34 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:50:34 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:50:39 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:50:39 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:50:44 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:50:44 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:50:49 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:50:49 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: ABORT operation timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: DEVICE RESET operation started.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: DEVICE RESET operation 
timed-out.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: BUS RESET operation started.
Dec  6 22:51:45 conquest2 kernel: sym0: SCSI BUS reset detected.
Dec  6 22:51:45 conquest2 kernel: sym0: SCSI BUS has been reset.
Dec  6 22:51:45 conquest2 kernel: sym0:6:0: BUS RESET operation complete.

3) I realize that this report is not of much use in tracking down the 
problem (I do not have a scsi bus analyser). And I have not even set any 
debug flags so far.

4) I didn't see a bugzilla system for linux-scsi.

ael


