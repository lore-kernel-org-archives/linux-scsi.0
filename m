From: Alex Krohn <alex@gossamer-threads.com>
Subject: Address or Write Phase Parity Error Detected
Date: Tue, 03 Aug 2004 09:13:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040803085706.D2A9.ALEX@gossamer-threads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gossamer.nmsrv.com ([64.69.64.21]:49091 "HELO
	gossamer-threads.com") by vger.kernel.org with SMTP id S266689AbUHCQKA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Aug 2004 12:10:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm seeing the following errors intermitently:

scsi0: Host Status: Failed(0)
DevQ(0:0:0): 0 waiting
DevQ(0:2:0): 0 waiting
scsi0: Address or Write Phase Parity Error Detected in DFF0.

followed by the card dump (included below). The drives pause for around
5 seconds, and then everything resumes ok. This is with:

Tyan S2469 Motherboard 
Onboard Adaptec AIC7902 adapter
Maxtor Atlas 15k 36gig drives

I've tried both the 2.4.26 and 2.6.7 kernels and also the latest aic79xx
drivers from:

http://people.freebsd.org/~gibbs/linux/SRC/

but still get the same problem. It seems to happen on heavy disk usage. 

The only clues I've found in the archives and online seem to indicate it
might be another pci device causing the problems, but I can't seem to
isolate what it is (this is a server with no other pci cards, and pretty
much everything disabled in the bios that isn't used). I've included
below the output of lspci -v -v in case it's helpful.

Does anybody have any ideas what might be the problem? I'd also be
willing to pay for some consulting time to help track this down. Email
me off list for info.

Here's the card dump:

scsi0: PCI error Interrupt
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x26 Mode 0x11
Card was paused
HS_MAILBOX[0x0] INTCTL[0xc0] SEQINTSTAT[0x10] SAVED_MODE[0x11]
DFFSTAT[0x23] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]
LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x1]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0xe1]

SCB Count = 48 CMDS_PENDING = 1 LASTSCB 0x11 CURRSCB 0x8 NEXTSCB 0xff80
qinstart = 13680 qinfifonext = 13680
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  8 FIFO_USE[0x1] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Total 1
Kernel Free SCB list: 10 0 17 6 28 12 25 15 7 30 23 13 26 22 20 5 29 14 16 4 40 18 11 1 3 24 31 19 2
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:

scsi0: FIFO0 Active, LONGJMP == 0x239, SCB 0x8
SEQIMODE[0x3f] SEQINTSRC[0x40] DFCNTRL[0xc] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x33] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x16] SHADDR = 0x021780000, SHCNT = 0x0
HADDR = 0x021780000, HCNT = 0x0 CCSGCTL[0x10]
scsi0: FIFO1 Free, LONGJMP == 0x8251, SCB 0xa
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x8 0x0 0x0 0x8 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
SIMODE0[0xc]
CCSCBCTL[0x4]
scsi0: REG0 == 0x60, SINDEX = 0x132, DINDEX = 0x102
scsi0: SCBPTR == 0xa, SCB_NEXT == 0x8, SCB_NEXT2 == 0x8
CDB 2a 0 2 80 8 d8
STACK: 0x13 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:0:0): 0 waiting
DevQ(0:3:0): 0 waiting
scsi0: Address or Write Phase Parity Error Detected in DFF0.

and here's the output of lspci -v -v:

00:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P] System Controller (rev 20)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 32
        Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
        Region 1: Memory at f6200000 (32-bit, prefetchable) [size=4K]
        Region 2: I/O ports at 2050 [disabled] [size=4]
        Capabilities: [a0] AGP version 2.0
                Status: RQ=15 SBA+ 64bit- FW- Rate=x1,x2
                Command: RQ=0 SBA+ AGP+ 64bit- FW- Rate=<none>

00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P] AGP Bridge (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ISA (rev 05)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-768 [Opus] IDE (rev 04) (prog-if 8a [Master SecP PriP])
        Subsystem: Advanced Micro Devices [AMD] AMD-768 [Opus] IDE
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 4: I/O ports at f000 [size=16]

00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ACPI (rev 03)
        Subsystem: Advanced Micro Devices [AMD] AMD-768 [Opus] ACPI
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:0a.0 SCSI storage controller: Adaptec: Unknown device 801f (rev 10)
        Subsystem: Adaptec: Unknown device ffff
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 72 (10000ns min, 6250ns max), cache line size 10
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 1400 [disabled] [size=256]
        Region 1: Memory at f4000000 (64-bit, non-prefetchable) [size=8K]
        Region 3: I/O ports at 1000 [disabled] [size=256]
        Expansion ROM at <unassigned> [disabled] [size=512K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [94] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=4
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
00:0a.1 SCSI storage controller: Adaptec: Unknown device 801f (rev 10)
        Subsystem: Adaptec: Unknown device ffff
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 72 (10000ns min, 6250ns max), cache line size 10
        Interrupt: pin B routed to IRQ 5
        Region 0: I/O ports at 1c00 [disabled] [size=256]
        Region 1: Memory at f4002000 (64-bit, non-prefetchable) [size=8K]
        Region 3: I/O ports at 1800 [disabled] [size=256]
        Expansion ROM at <unassigned> [disabled] [size=512K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [94] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=4
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
00:0b.0 Ethernet controller: Intel Corp.: Unknown device 100f (rev 01)
        Subsystem: Intel Corp.: Unknown device 1001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (63750ns min), cache line size 10
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at f4020000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at 2000 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [e4] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=0
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-      Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000

00:10.0 PCI bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] PCI (rev 05) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 99
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=68
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: f4100000-f5ffffff
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

02:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-768 [Opus] USB (rev 07) (prog-if 10 [OHCI])
        Subsystem: Advanced Micro Devices [AMD] AMD-768 [Opus] USB
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+
        Latency: 64 (20000ns max)
        Interrupt: pin D routed to IRQ 10
        Region 0: Memory at f4120000 (32-bit, non-prefetchable) [size=4K]

02:07.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) (prog-if 00 [VGA])
        Subsystem: ATI Technologies Inc: Unknown device 8008
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 66 (2000ns min), cache line size 10
        Region 0: Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: I/O ports at 3000 [size=256]
        Region 2: Memory at f4121000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at <unassigned> [disabled] [size=128K]
        Capabilities: [5c] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:08.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 10)
        Subsystem: Intel Corp. EtherExpress PRO/100 S Server Adapter
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 66 (2000ns min, 14000ns max), cache line size 10
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at f4122000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 3400 [size=64]
        Region 2: Memory at f4100000 (32-bit, non-prefetchable) [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

Cheers,

Alex
--
Alex Krohn <alex@gossamer-threads.com>



