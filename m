From: Ethan Weinstein <lists@stinkfoot.org>
Subject: sym53c8xx(2) problems on PPC
Date: Tue, 07 Jan 2003 23:52:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1BAE79.7030506@stinkfoot.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stinkfoot.org (e-dOuble.stinkfoot.org [192.168.1.1])
	by stinkfoot.org (Postfix) with ESMTP id AF41AC001D
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2003 23:52:09 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings.

We recently changed out this card (32-bit card, one channel):

10:14.0 SCSI storage controller: LSI Logic / Symbios Logic (formerly NCR) 53c895 
(rev 02)
         Subsystem: LSI Logic / Symbios Logic (formerly NCR): Unknown device 1020
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 16 (7500ns min, 16000ns max), cache line size 08
         Interrupt: pin A routed to IRQ 54
         Region 0: I/O ports at 0400 [size=256]
         Region 1: Memory at 80081000 (32-bit, non-prefetchable) [size=256]
         Region 2: Memory at 80084000 (32-bit, non-prefetchable) [size=4K]
         Expansion ROM at 800c0000 [disabled] [size=128K]

sym.16.20.0: setting PCI_COMMAND_PARITY...
sym0: <895> rev 0x2 on pci bus 16 device 20 function 0 irq 54
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi2 : sym-2.1.17a

For this one (64-bit PCI card, with 2 channels)

10:14.0 SCSI storage controller: LSI Logic / Symbios Logic (formerly NCR) 
53c1010 Ultra3 SCSI Adapter (rev 01)
         Subsystem: LSI Logic / Symbios Logic (formerly NCR): Unknown device 1030
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 16 (4250ns min, 4500ns max), cache line size 08
         Interrupt: pin A routed to IRQ 54
         Region 0: I/O ports at 0800 [size=256]
         Region 1: Memory at 80082000 (64-bit, non-prefetchable) [size=1K]
         Region 3: Memory at 8008a000 (64-bit, non-prefetchable) [size=8K]
         Expansion ROM at 800e0000 [disabled] [size=128K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

10:14.1 SCSI storage controller: LSI Logic / Symbios Logic (formerly NCR) 
53c1010 Ultra3 SCSI Adapter (rev 01)
         Subsystem: LSI Logic / Symbios Logic (formerly NCR): Unknown device 1030
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr+ DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+
         Latency: 16 (4250ns min, 4500ns max), cache line size 08
         Interrupt: pin B routed to IRQ 54
         Region 0: I/O ports at 0400 [size=256]
         Region 1: Memory at 80081000 (64-bit, non-prefetchable) [size=1K]
         Region 3: Memory at 80088000 (64-bit, non-prefetchable) [size=8K]
         Expansion ROM at 800c0000 [disabled] [size=128K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

sym.16.20.0: setting PCI_COMMAND_PARITY...
sym.16.20.1: setting PCI_COMMAND_PARITY...
sym0: <1010-33> rev 0x1 on pci bus 16 device 20 function 0 irq 54
sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: SCSI BUS has been reset.
sym1: <1010-33> rev 0x1 on pci bus 16 device 20 function 1 irq 54
sym1: No NVRAM, ID 7, Fast-80, SE, parity checking
sym1: SCSI BUS has been reset.
sym1: SCSI BUS mode change from SE to SE.
scsi2 : sym-2.1.17a
scsi3 : sym-2.1.17a

The old card was attached to our SEAGATE   Model: ULTRIUM06242-XXX  Rev: 1470 
for nightly backups.  The backups ran fine.
After attaching the tape drive to the new card, during the backup we get this:

sym0:6: ERROR (40:0) (0-20-0) (1f/18/0) @ (scripta ad8:10001e00).
sym0: script cmd = 10000000
sym0: regdump: da 10 c0 18 47 1f 06 0a 00 00 86 20 80 01 08 01 00 ac c7 1e 08 00 
00 00.
sym0: PCI STATUS = 0x8100
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
st0: Error 80000 (sugg. bt 0x0, driver bt 0x0, host bt 0x8).
st0: Error with sense data: Current st09:00: sense key Unit Attention
Additional sense indicates Power on,reset,or bus device reset occurred
st0: Error on write filemark.

The system is a powerpc G4 SMP @533mhz, with 1G of ram.  We're using 
kernel-2.4.20, SMP, and HIMEM enabled.  Termination and cabling are definately 
correct.  We tried the sym53c8xx module with both 32 and 40 bit DMA addressing.. 
same results.. the old card works fine, the new card causes these errors and the 
backup aborts.
We'd definately rather use the new 2 channel card, as we'd like to attach a disk 
to the other channel.. but this is preventing us from doing it.  Any ideas? I'm 
up for trying anything here to get this to work.

thanks,

Ethan Weinstein

