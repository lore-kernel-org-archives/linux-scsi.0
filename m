From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Poor write performance from Dell CERC SATA 1.5/6 controller using aacraid
Date: Tue, 7 Feb 2006 10:26:04 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F021C9FA3@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:27855 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751110AbWBGP0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 10:26:11 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>, linux-scsi@vger.kernel.org

I am getting easily 42MB/S sustained using Adaptec's 1.1.5-2400 in SLES9
using Firmware 7330 on a Dell CERC card.

Make sure you have the latest Firmware for the card and the drives.
Technical support has aacraid driver binary packaging 1.1.5-2409 on the
web site, or I can send you 1.1.5-2418 sources for you to update on your
own.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of 
> Christopher Smith
> Sent: Tuesday, February 07, 2006 1:44 AM
> To: linux-scsi@vger.kernel.org
> Subject: Poor write performance from Dell CERC SATA 1.5/6 
> controller using aacraid
> 
> 
> I've got a PE750 with one of Dell's CERC SATA RAID controllers in it. 
> It has two 250G WD drives attached in a RAID1.
> 
> My problem is that the write performance is atrocious, at 
> 10M/s, tops. 
> This is regardless of whether or not the card's write caching 
> is enabled[0].
> 
> I have tried with both FC4 (2.6.15-1.1830_FC4smp, 
> 2.6.14-1.1656_FC4smp, 
> 2.6.11-1.1369_FC4smp) and CentOS 4.2/RHEL4 (2.6.9-22.0.1.ELsmp). 
> Performance is marginally worse with older kernels, at ~8M/s 
> instead of 
> ~10M/s.
> 
> Since I have another two drives of the same type in an identical 
> machine, only using the onboard SATA controller and software 
> RAID that 
> easily pulls 30+M/s, I'm pretty sure it isn't slow drives.  So I'm 
> wondering if it's an aacraid driver bug, or if these Dell CERC cards 
> just suck.
> 
> CS
> 
> [0] Indeed, enabling the write cache makes it worse, if 
> anything, since 
> the system proceeds to dump as much data as possible to the 
> cache, then 
> basically freeze (IO-wise) while the controller dumps the 
> cache to disk, 
> then the cycle repeats.  So I get about 10s of data transfer, 
> then about 
> 15 seconds of nothing (w/ 100% iowait), then 10s of data 
> transfers, then 
> 15s nothing, etc, etc.  At least with the cache off, the 
> 10M/s is pretty 
> much constant.
> 
> 
> Bonnie++ results:
> [root@localhost bonnie++-1.03a]# uname -r
> 2.6.15-1.1830_FC4smp
> [root@localhost bonnie++-1.03a]# ./bonnie++ -d /tmp/ -u 0 -f 
> -b -s 2050
> [...]
> Version  1.03       ------Sequential Output------ --Sequential Input- 
> --Random-
>                      -Per Chr- --Block-- -Rewrite- -Per Chr- 
> --Block-- 
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
> /sec %CP
> localhost.loc 2050M            8239   3  8153   2           57685   6 
> 190.6   0
>                      ------Sequential Create------ --------Random 
> Create--------
>                      -Create-- --Read--- -Delete-- -Create-- 
> --Read--- 
> -Delete--
>                files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  
> /sec %CP 
> /sec %CP
>                   16    47   0 +++++ +++    56   0    73   0 
> +++++ +++ 
>    60   0
> localhost.localdomain,2050M,,,8239,3,8153,2,,,57685,6,190.6,0,
> 16,47,0,+++++,+++,56,0,73,0,+++++,+++, 
>  
>      60,0
> 
> lspci -vv:
> [root@localhost bonnie++-1.03a]# lspci -vv
> 00:00.0 Host bridge: Intel Corporation 82875P/E7210 Memory Controller 
> Hub (rev 02)
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>          Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- 
> DEVSEL=fast >TAbort- 
> <TAbort- <MAbort+ >SERR- <PERR-
>          Latency: 0
>          Region 0: Memory at f8000000 (32-bit, prefetchable) [size=4M]
>          Capabilities: [e4] Vendor Specific Information
> 
> 00:03.0 PCI bridge: Intel Corporation 82875P/E7210 Processor 
> to PCI to 
> CSA Bridge (rev 02) (prog-if 00 [Normal decode])
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>          Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- 
> DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 64
>          Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>          I/O behind bridge: 0000e000-0000efff
>          Memory behind bridge: fe200000-fe3fffff
>          Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>          BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 
> 00:1c.0 PCI bridge: Intel Corporation 6300ESB 64-bit PCI-X 
> Bridge (rev 
> 02) (prog-if 00 [Normal decode])
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>          Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- 
> DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 64, Cache Line Size 10
>          Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
>          Memory behind bridge: fe100000-fe1fffff
>          Prefetchable memory behind bridge: 
> 00000000f4000000-00000000f7f00000
>          Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>          BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>          Capabilities: [50] PCI-X bridge device.
>                  Secondary Status: 64bit+, 133MHz-, SCD-, USC-, SCO-, 
> SRD- Freq=0
>                  Status: Bus=0 Dev=28 Func=0 64bit+ 133MHz- 
> SCD- USC-, 
> SCO-, SRD-
>                  : Upstream: Capacity=65535, Commitment Limit=0
>                  : Downstream: Capacity=65535, Commitment Limit=0
> 
> 00:1d.0 USB Controller: Intel Corporation 6300ESB USB Universal Host 
> Controller (rev 02) (prog-if 00 [UHCI])
>          Subsystem: Dell: Unknown device 0165
>          Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 0
>          Interrupt: pin A routed to IRQ 201
>          Region 4: I/O ports at cce0 [size=32]
> 
> 00:1d.1 USB Controller: Intel Corporation 6300ESB USB Universal Host 
> Controller (rev 02) (prog-if 00 [UHCI])
>          Subsystem: Dell: Unknown device 0165
>          Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 0
>          Interrupt: pin B routed to IRQ 209
>          Region 4: I/O ports at ccc0 [size=32]
> 
> 00:1d.4 System peripheral: Intel Corporation 6300ESB Watchdog 
> Timer (rev 02)
>          Subsystem: Dell: Unknown device 0165
>          Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Region 0: Memory at fe400400 (32-bit, 
> non-prefetchable) [size=16]
> 
> 00:1d.5 PIC: Intel Corporation 6300ESB I/O Advanced Programmable 
> Interrupt Controller (rev 02) (prog-if 20 [IO(X)-APIC])
>          Subsystem: Dell: Unknown device 0165
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>          Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- 
> DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 0
>          Capabilities: [50] PCI-X non-bridge device.
>                  Command: DPERE- ERO- RBC=0 OST=0
>                  Status: Bus=0 Dev=29 Func=5 64bit+ 133MHz- 
> SCD- USC-, 
> DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
> 
> 00:1d.7 USB Controller: Intel Corporation 6300ESB USB2 Enhanced Host 
> Controller (rev 02) (prog-if 20 [EHCI])
>          Subsystem: Dell: Unknown device 0165
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>          Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 0
>          Interrupt: pin D routed to IRQ 193
>          Region 0: Memory at fe400000 (32-bit, 
> non-prefetchable) [size=1K]
>          Capabilities: [50] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Capabilities: [58] Debug port
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 
> 0a) (prog-if 
> 00 [Normal decode])
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>          Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- 
> DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 0
>          Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
>          I/O behind bridge: 0000d000-0000dfff
>          Memory behind bridge: fc000000-fdffffff
>          Prefetchable memory behind bridge: 40000000-400fffff
>          Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>          BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
> 
> 00:1f.0 ISA bridge: Intel Corporation 6300ESB LPC Interface 
> Controller 
> (rev 02)
>          Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
> ParErr+ Stepping- SERR+ FastB2B-
>          Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 0
> 
> 00:1f.2 IDE interface: Intel Corporation 6300ESB SATA Storage 
> Controller 
> (rev 02) (prog-if 8a [Master SecP PriP])
>          Subsystem: Dell: Unknown device 0165
>          Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 0
>          Interrupt: pin A routed to IRQ 0
>          Region 0: I/O ports at <unassigned>
>          Region 1: I/O ports at <unassigned>
>          Region 2: I/O ports at <unassigned>
>          Region 3: I/O ports at <unassigned>
>          Region 4: I/O ports at fea0 [size=16]
> 
> 00:1f.3 SMBus: Intel Corporation 6300ESB SMBus Controller (rev 02)
>          Subsystem: Dell: Unknown device 0165
>          Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Interrupt: pin B routed to IRQ 6
>          Region 4: I/O ports at 08c0 [size=32]
> 
> 01:01.0 Ethernet controller: Intel Corporation 82547GI 
> Gigabit Ethernet 
> Controller
>          Subsystem: Dell PowerEdge 750
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 0 (63750ns min), Cache Line Size 10
>          Interrupt: pin A routed to IRQ 177
>          Region 0: Memory at fe2e0000 (32-bit, 
> non-prefetchable) [size=128K]
>          Region 2: I/O ports at ece0 [size=32]
>          Capabilities: [dc] Power Management version 2
>                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 
> 02:01.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
>          Subsystem: Dell CERC SATA RAID 2 PCI SATA 6ch (DellCorsair)
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>          Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- 
> DEVSEL=slow >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 32 (250ns min, 250ns max), Cache Line Size 10
>          Interrupt: pin A routed to IRQ 169
>          Region 0: Memory at f4000000 (32-bit, prefetchable) 
> [size=64M]
>          Expansion ROM at fe100000 [disabled] [size=32K]
>          Capabilities: [80] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 03:02.0 Ethernet controller: Intel Corporation 82541GI/PI Gigabit 
> Ethernet Controller
>          Subsystem: Dell PowerEdge 750
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>          Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 32 (63750ns min), Cache Line Size 10
>          Interrupt: pin A routed to IRQ 185
>          Region 0: Memory at fdee0000 (32-bit, 
> non-prefetchable) [size=128K]
>          Region 2: I/O ports at dcc0 [size=64]
>          Capabilities: [dc] Power Management version 2
>                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>          Capabilities: [e4] PCI-X non-bridge device.
>                  Command: DPERE- ERO+ RBC=0 OST=0
>                  Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, 
> DC=simple, DMMRBC=2, DMOST=0, DMCRS=0, RSCEM-
> 
> 03:0e.0 VGA compatible controller: ATI Technologies Inc Rage 
> XL (rev 27) 
> (prog-if 00 [VGA])
>          Subsystem: Dell: Unknown device 0165
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ 
> ParErr- Stepping+ SERR- FastB2B-
>          Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 32 (2000ns min), Cache Line Size 10
>          Region 0: Memory at fc000000 (32-bit, 
> non-prefetchable) [size=16M]
>          Region 1: I/O ports at d800 [size=256]
>          Region 2: Memory at fdedf000 (32-bit, 
> non-prefetchable) [size=4K]
>          [virtual] Expansion ROM at 40000000 [disabled] [size=128K]
>          Capabilities: [5c] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
