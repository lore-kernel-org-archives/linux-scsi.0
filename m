From: "Ingo Korb" <ml@akana.de>
Subject: sym53c8xx_2 hangs on 53c810 rev 02
Date: Mon, 15 Nov 2004 22:21:28 +0100
Message-ID: <41992BE8.22985.49329380@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from snowcat.de ([213.146.167.7]:46853 "EHLO snowcat.de")
	by vger.kernel.org with ESMTP id S261368AbUKOVVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 16:21:35 -0500
Received: from crystal.akana.i ([10.0.0.2])
	by snowcat.de with esmtp (TLS-1.0:RSA_ARCFOUR_SHA:16)
	(Exim 4.32)
	id 1CToI0-0007ok-GT
	for linux-scsi@vger.kernel.org; Mon, 15 Nov 2004 22:21:33 +0100
Received: from [10.0.0.4] (helo=dragon)
	by crystal.akana.i with esmtp (Exim 4.34)
	id 1CToHx-0005rZ-E0
	for linux-scsi@vger.kernel.org; Mon, 15 Nov 2004 22:21:29 +0100
Content-description: Mail message body
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

While trying to run 2.6.9 on my AlphaStation 200, I noticed that 
sym53c8xx_2 doesn't seem to like the onboard 53c810 rev. 02 (see 
bootlog below).

Some posts in the archives suggested that such problems may be caused 
by older devices that may not like the defaults used by that driver, 
but the system hangs even when the only thing connected to the 
controller is a properly terminated cable.

=== Cut ===
Linux version 2.6.9 (ingo@crystal) (gcc version 3.3.4) #1 Mon Nov 15 19:30:04 CE
T 2004
Booting on Avanti using machine vector Avanti from MILO
Major Options: LEGACY_START MAGIC_SYSRQ 
Command line: root=/dev/sda4 console=ttyS0
memcluster 0, usage 1, start        0, end      249
memcluster 1, usage 0, start      249, end    12287
memcluster 2, usage 1, start    12287, end    12288
freeing pages 249:384
freeing pages 845:12287
reserving pages 845:846
512K Bcache detected; load hit latency 14 cycles, load miss latency 48 cycles
Built 1 zonelists
Kernel command line: root=/dev/sda4 console=ttyS0
PID hash table entries: 512 (order: 9, 16384 bytes)
HWRPB cycle frequency bogus.  Estimated 100032638 Hz
Using epoch = 1980
Console: colour dummy device 80x25
Dentry cache hash table entries: 16384 (order: 4, 131072 bytes)
Inode-cache hash table entries: 8192 (order: 3, 65536 bytes)
Memory: 91616k/98296k available (2201k kernel code, 4592k reserved, 616k data, 1
28k init)
Security Scaffold v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 512 (order: 0, 8192 bytes)
NET: Registered protocol family 16
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
Initializing Cryptographic API
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
rtc: ARC console epoch (1980) detected
Real Time Clock Driver v1.12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Using anticipatory io scheduler
Floppy drive(s): fd0 is 2.88M
floppy0: no floppy controllers found
loop: loaded (max 8 devices)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
sym0: <810> rev 0x2 at pci 0000:00:06.0 irq 11
sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
sym0:0:0: ABORT operation started.
sym0:0:0: ABORT operation timed-out.
sym0:0:0: DEVICE RESET operation started.
sym0:0:0: DEVICE RESET operation timed-out.
sym0:0:0: BUS RESET operation started.
sym0:0:0: BUS RESET operation timed-out.
sym0:0:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
=== Cut ===

lspci -vvv output:

=== Cut ===
00:06.0 SCSI storage controller: LSI Logic / Symbios Logic 53c810 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 8000 [size=256]
	Region 1: Memory at 00000000012a0000 (32-bit, non-prefetchable) [size=256]

00:07.0 Non-VGA unclassified device: Intel Corp. 82378IB [SIO ISA Bridge] (rev 84)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:0b.0 Ethernet controller: Digital Equipment Corporation DECchip 21040 [Tulip] (rev 23)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 96
	Interrupt: pin A routed to IRQ 15
	Region 0: I/O ports at 8400 [size=128]
	Region 1: Memory at 00000000012a2000 (32-bit, non-prefetchable) [size=128]

00:0c.0 Unknown mass storage controller: CMD Technology Inc PCI0680 (rev 02)
	Subsystem: CMD Technology Inc PCI0680
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 0x01 (4 bytes)
	Interrupt: pin A routed to IRQ 14
	Region 0: I/O ports at 8810 [size=8]
	Region 1: I/O ports at 8820 [size=4]
	Region 2: I/O ports at 8818 [size=8]
	Region 3: I/O ports at 8824 [size=4]
	Region 4: I/O ports at 8800 [size=16]
	Region 5: Memory at 00000000012a1000 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at 0000000001200000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:0d.0 Ethernet controller: 3Com Corporation 3cSOHO100-TX Hurricane (rev 30)
	Subsystem: 3Com Corporation 3cSOHO100-TX Hurricane
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (2500ns min, 2500ns max), Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at 8480 [size=128]
	Region 1: Memory at 00000000012a3000 (32-bit, non-prefetchable) [size=128]
	Expansion ROM at 0000000001280000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
=== Cut ===

-ik


