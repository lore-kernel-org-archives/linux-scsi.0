From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10846] New: Slow write on LSISAS1068E (SAS6/iR) on kernel >= 2.6.22
Date: Mon,  2 Jun 2008 07:57:45 -0700 (PDT)
Message-ID: <bug-10846-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYFBO5t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2008 10:57:49 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m52EvjK0024847
	for <linux-scsi@vger.kernel.org>; Mon, 2 Jun 2008 07:57:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D10846

           Summary: Slow write on LSISAS1068E (SAS6/iR) on kernel >=3D =
2.6.22
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.24-16
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: dom.lalot@gmail.com


Latest working kernel version:
2.6.21.7

Earliest failing kernel version:
2.6.22.1 till 2.6.24

debian-test:/usr/src# cat /proc/version
Linux version 2.6.22.19 (root@debian-test.pr.univmed.fr) (gcc version 4=
=2E1.2
20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Fri May 30 19:53:56 CES=
T 2008


Distribution:
Ubuntu server 8.04 / Debian Lenny

Hardware Environment:
debian-test:/usr/src/linux# lspci -vvv
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller =
Hub (rev
92)
        Subsystem: Intel Corporation Unknown device 8086
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 0
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Q=
ueue=3D0/1
Enable-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsuppor=
ted-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Advanced Error Reporting

00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x=
4 Port 2
(rev 92) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D01, subordinate=3D07, sec-latenc=
y=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: d8000000-ddffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Q=
ueue=3D0/1
Enable+
                Address: feeff00c  Data: 41c9
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 2
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Advanced Error Reporting

00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x=
4 Port 3
(rev 92) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D08, subordinate=3D08, sec-latenc=
y=3D0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: de100000-de2fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Q=
ueue=3D0/1
Enable+
                Address: feeff00c  Data: 41d1
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 256 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 3
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Advanced Error Reporting

00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x=
8 Port
4-5 (rev 92) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D09, subordinate=3D09, sec-latenc=
y=3D0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: de300000-de3fffff
        Prefetchable memory behind bridge: 00000000de500000-00000000de5=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Q=
ueue=3D0/1
Enable+
                Address: feeff00c  Data: 41d9
        Capabilities: [6c] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 256 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port=
 4
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Su=
rpise-
                Slot: Number 1, PowerLimit 25.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HP=
Irq-
                Slot: AttnInd Off, PwrInd Off, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Advanced Error Reporting

00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x=
4 Port 5
(rev 92) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0a, subordinate=3D0a, sec-latenc=
y=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Q=
ueue=3D0/1
Enable+
                Address: feeff00c  Data: 41e1
        Capabilities: [6c] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 5
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtS=
ynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Su=
rpise-
                Slot: Number 2, PowerLimit 25.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HP=
Irq-
                Slot: AttnInd Off, PwrInd Off, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Advanced Error Reporting

00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x=
8 Port
6-7 (rev 92) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0b, subordinate=3D0b, sec-latenc=
y=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Q=
ueue=3D0/1
Enable+
                Address: feeff00c  Data: 41e9
        Capabilities: [6c] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port=
 6
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtS=
ynch-
                Link: Speed 2.5Gb/s, Width x4
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Su=
rpise-
                Slot: Number 3, PowerLimit 25.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HP=
Irq-
                Slot: AttnInd Off, PwrInd Off, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Advanced Error Reporting

00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x=
4 Port 7
(rev 92) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0c, subordinate=3D0c, sec-latenc=
y=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Q=
ueue=3D0/1
Enable+
                Address: feeff00c  Data: 4132
        Capabilities: [6c] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 7
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtS=
ynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Su=
rpise-
                Slot: Number 4, PowerLimit 25.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HP=
Irq-
                Slot: AttnInd Off, PwrInd Off, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Advanced Error Reporting

00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error Report=
ing
Registers (rev 92)
        Subsystem: Dell Unknown device 0208
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-

00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error Report=
ing
Registers (rev 92)
        Subsystem: Dell Unknown device 0208
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-

00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error Report=
ing
Registers (rev 92)
        Subsystem: Dell Unknown device 0208
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-

00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Reg=
isters
(rev 92)
        Subsystem: Intel Corporation Unknown device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-

00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Reg=
isters
(rev 92)
        Subsystem: Intel Corporation Unknown device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-

00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Register=
s (rev
92)
        Subsystem: Intel Corporation Unknown device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-

00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Register=
s (rev
92)
        Subsystem: Intel Corporation Unknown device 8086
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-

00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
UHCI USB
Controller #1 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 0208
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at bc80 [size=3D32]

00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
UHCI USB
Controller #2 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 0208
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at bca0 [size=3D32]

00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
UHCI USB
Controller #3 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 0208
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 20
        Region 4: I/O ports at bcc0 [size=3D32]

00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset =
EHCI
USB2 Controller (rev 09) (prog-if 20 [EHCI])
        Subsystem: Dell Unknown device 0208
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at de0ff800 (32-bit, non-prefetchable) [size=3D=
1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9) (prog-i=
f 01
[Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=3D00, secondary=3D0d, subordinate=3D0d, sec-latenc=
y=3D32
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: de400000-de4fffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000d7f=
fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Gammagraphx, Inc. Unknown device =
0000

00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
Interface Controller (rev 09)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstr=
eam Port
(rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D01, secondary=3D02, subordinate=3D06, sec-latenc=
y=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: da000000-ddffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Upstream Port IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: SlotPowerLimit 0.000000
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port=
 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. Unknown device =
0000
        Capabilities: [100] Advanced Error Reporting

01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PC=
I-X
Bridge (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D01, secondary=3D07, subordinate=3D07, sec-latenc=
y=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsuppor=
ted-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 256 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port=
 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [6c] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. Unknown device =
0000
        Capabilities: [d8] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD-
=46req=3D100MHz
                Status: Dev=3D00:00.3 64bit- 133MHz- SCD- USC- SCO- SRD=
-
                Upstream: Capacity=3D65535 CommitmentLimit=3D65535
                Downstream: Capacity=3D65535 CommitmentLimit=3D65535
        Capabilities: [100] Advanced Error Reporting

02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downs=
tream
Port E1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D02, secondary=3D03, subordinate=3D04, sec-latenc=
y=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: dc000000-ddffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 0
                Link: Latency L0s <512ns, L1 unlimited
                Link: ASPM Disabled CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Q=
ueue=3D0/0
Enable+
                Address: 00000000feeff00c  Data: 413a
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. Unknown device =
0000
        Capabilities: [100] Advanced Error Reporting

02:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downs=
tream
Port E2 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D02, secondary=3D05, subordinate=3D06, sec-latenc=
y=3D0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: da000000-dbffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, E=
xtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsuppor=
ted+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 0
                Link: Latency L0s <512ns, L1 unlimited
                Link: ASPM Disabled CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Q=
ueue=3D0/0
Enable+
                Address: 00000000feeff00c  Data: 4142
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Subsystem: Gammagraphx, Inc. Unknown device =
0000
        Capabilities: [100] Advanced Error Reporting

03:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) (=
prog-if
00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D03, secondary=3D04, subordinate=3D04, sec-latenc=
y=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: dc000000-ddffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [60] Express PCI/PCI-X Bridge IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, E=
xtTag+
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsuppor=
ted-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, P=
ort 0
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [90] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD-
=46req=3D133MHz
                Status: Dev=3D03:00.0 64bit- 133MHz- SCD- USC- SCO- SRD=
-
                Upstream: Capacity=3D0 CommitmentLimit=3D0
                Downstream: Capacity=3D0 CommitmentLimit=3D0
        Capabilities: [b0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [14c] Power Budgeting
        Capabilities: [160] Device Serial Number c0-88-3d-fe-ff-4f-1e-0=
0

04:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708S=
 Gigabit
Ethernet (rev 12)
        Subsystem: Dell Unknown device 0208
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 211
        Region 0: Memory at dc000000 (64-bit, non-prefetchable) [size=3D=
32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D8
                Status: Dev=3D04:00.0 64bit+ 133MHz+ SCD- USC- DC=3Dsim=
ple
DMMRBC=3D512 DMOST=3D8 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Q=
ueue=3D0/0
Enable+
                Address: 00000000feeff00c  Data: 417a

05:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c3) (=
prog-if
00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D05, secondary=3D06, subordinate=3D06, sec-latenc=
y=3D64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: da000000-dbffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000=
fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [60] Express PCI/PCI-X Bridge IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, E=
xtTag+
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsuppor=
ted-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, P=
ort 0
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [90] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD-
=46req=3D133MHz
                Status: Dev=3D05:00.0 64bit- 133MHz- SCD- USC- SCO- SRD=
-
                Upstream: Capacity=3D0 CommitmentLimit=3D0
                Downstream: Capacity=3D0 CommitmentLimit=3D0
        Capabilities: [b0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [14c] Power Budgeting
        Capabilities: [160] Device Serial Number c2-88-3d-fe-ff-4f-1e-0=
0

06:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708S=
 Gigabit
Ethernet (rev 12)
        Subsystem: Dell Unknown device 0208
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at da000000 (64-bit, non-prefetchable) [size=3D=
32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=3D512 OST=3D8
                Status: Dev=3D06:00.0 64bit+ 133MHz+ SCD- USC- DC=3Dsim=
ple
DMMRBC=3D512 DMOST=3D8 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Q=
ueue=3D0/0
Enable-
                Address: 8ba7fdde142ffbd8  Data: 6ddc

08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI=
-Express
=46usion-MPT SAS (rev 08)
        Subsystem: Dell Unknown device 1f0f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at ec00 [size=3D256]
        Region 1: Memory at de2ec000 (64-bit, non-prefetchable) [size=3D=
16K]
        Region 3: Memory at de2f0000 (64-bit, non-prefetchable) [size=3D=
64K]
        Expansion ROM at de100000 [disabled] [size=3D1M]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [68] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 4096 bytes, PhantFunc 0, =
ExtTag+
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsuppor=
ted-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, P=
ort 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Q=
ueue=3D0/0
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=3D1
                Vector table: BAR=3D1 offset=3D00002000
                PBA: BAR=3D1 offset=3D00003000
        Capabilities: [100] Advanced Error Reporting

09:00.0 Fibre Channel: QLogic Corp. QLA2432 Fibre Channel Adapter (rev =
03)
        Subsystem: QLogic Corp. Unknown device 015b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at d800 [size=3D256]
        Region 1: Memory at de3f8000 (64-bit, non-prefetchable) [size=3D=
16K]
        Expansion ROM at de300000 [disabled] [size=3D256K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [4c] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, =
ExtTag-
                Device: Latency L0s <4us, L1 <1us
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsuppor=
ted-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 256 bytes, MaxReadReq 2048 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 0
                Link: Latency L0s <4us, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [64] Message Signalled Interrupts: Mask- 64bit+ Q=
ueue=3D0/4
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [74] Vital Product Data
        Capabilities: [7c] MSI-X: Enable+ Mask- TabSize=3D16
                Vector table: BAR=3D1 offset=3D00002000
                PBA: BAR=3D1 offset=3D00003000
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [138] Power Budgeting

09:00.1 Fibre Channel: QLogic Corp. QLA2432 Fibre Channel Adapter (rev =
03)
        Subsystem: QLogic Corp. Unknown device 015b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at dc00 [size=3D256]
        Region 1: Memory at de3fc000 (64-bit, non-prefetchable) [size=3D=
16K]
        Expansion ROM at de500000 [disabled] [size=3D256K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [4c] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, =
ExtTag-
                Device: Latency L0s <4us, L1 <1us
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal+ Unsuppor=
ted-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 256 bytes, MaxReadReq 2048 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port=
 0
                Link: Latency L0s <4us, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [64] Message Signalled Interrupts: Mask- 64bit+ Q=
ueue=3D0/4
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [74] Vital Product Data
        Capabilities: [7c] MSI-X: Enable+ Mask- TabSize=3D16
                Vector table: BAR=3D1 offset=3D00002000
                PBA: BAR=3D1 offset=3D00003000
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [138] Power Budgeting

0d:04.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
(prog-if 00 [VGA])
        Subsystem: Dell Unknown device 0208
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err-
Stepping+ SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 6
        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=3D128=
M]
        Region 1: I/O ports at cc00 [size=3D256]
        Region 2: Memory at de4f0000 (32-bit, non-prefetchable) [size=3D=
64K]
        [virtual] Expansion ROM at de400000 [disabled] [size=3D128K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-


debian-test:/usr/src/linux-2.6.22.19/scripts# cat /proc/modules
xt_length 2048 0 - Live 0xf8dc1000
ipt_ttl 1984 0 - Live 0xf8dbf000
xt_tcpmss 2304 0 - Live 0xf8dbd000
iptable_mangle 2912 0 - Live 0xf8dbb000
iptable_filter 3104 0 - Live 0xf8db9000
xt_multiport 3200 0 - Live 0xf8daf000
xt_limit 2720 0 - Live 0xf8923000
ipt_tos 1760 0 - Live 0xf8d9c000
ipt_REJECT 4128 0 - Live 0xf8db6000
ip_tables 12420 2 iptable_mangle,iptable_filter, Live 0xf8db1000
x_tables 14564 8
xt_length,ipt_ttl,xt_tcpmss,xt_multiport,xt_limit,ipt_tos,ipt_REJECT,ip=
_tables,
Live 0xf8d90000
button 8080 0 - Live 0xf8da9000
ac 5348 0 - Live 0xf8d99000
battery 10116 0 - Live 0xf8d95000
ipmi_devintf 9096 4 - Live 0xf8bc6000
ipmi_si 39308 2 - Live 0xf8d9e000
ipmi_msghandler 35024 2 ipmi_devintf,ipmi_si, Live 0xf8c28000
ipv6 236676 22 - Live 0xf8dd7000
mptctl 23460 2 - Live 0xf8c3c000
loop 16996 0 - Live 0xf8be1000
sg 32764 0 - Live 0xf8c33000
serio_raw 6852 0 - Live 0xf8bca000
tsdev 8160 0 - Live 0xf88d6000
joydev 9696 0 - Live 0xf8bcd000
psmouse 36112 0 - Live 0xf8c14000
shpchp 31316 0 - Live 0xf8c1f000
rtc 12568 0 - Live 0xf8c0f000
pci_hotplug 29408 1 shpchp, Live 0xf8c06000
sr_mod 16548 0 - Live 0xf8bdb000
cdrom 33056 1 sr_mod, Live 0xf8bd1000
evdev 9472 0 - Live 0xf8bc2000
ext3 121704 2 - Live 0xf8be7000
jbd 55528 1 ext3, Live 0xf8950000
mbcache 8516 1 ext3, Live 0xf88db000
dm_mirror 20896 0 - Live 0xf8949000
dm_snapshot 17060 0 - Live 0xf8943000
dm_mod 52384 7 dm_mirror,dm_snapshot, Live 0xf8bb4000
ide_generic 1312 0 [permanent], Live 0xf8832000
sd_mod 27360 3 - Live 0xf893b000
usbhid 25952 0 - Live 0xf8933000
usb_storage 75328 0 - Live 0xf89da000
ide_core 112164 2 ide_generic,usb_storage, Live 0xf89bd000
mptsas 27496 2 - Live 0xf891b000
qla2xxx 144388 0 - Live 0xf895f000
mptscsih 21408 1 mptsas, Live 0xf8914000
firmware_class 9728 1 qla2xxx, Live 0xf8856000
mptbase 52768 3 mptctl,mptsas,mptscsih, Live 0xf8925000
ehci_hcd 31340 0 - Live 0xf88b6000
scsi_transport_sas 27872 1 mptsas, Live 0xf8842000
scsi_transport_fc 33924 1 qla2xxx, Live 0xf885d000
uhci_hcd 22992 0 - Live 0xf884a000
usbcore 125736 5 usbhid,usb_storage,ehci_hcd,uhci_hcd, Live 0xf88f4000
bnx2 151256 0 - Live 0xf8890000
scsi_mod 136652 10
mptctl,sg,sr_mod,sd_mod,usb_storage,mptsas,qla2xxx,mptscsih,scsi_transp=
ort_sas,scsi_transport_fc,
Live 0xf886d000
thermal 13576 0 - Live 0xf8834000
processor 31176 1 thermal, Live 0xf8839000
fan 4964 0 - Live 0xf882b000


debian-test:/usr/src/linux# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST9146802SS      Rev: S229
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: SEAGATE  Model: ST9146802SS      Rev: S229
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 01 Id: 00 Lun: 00
  Vendor: Dell     Model: VIRTUAL DISK     Rev: 1028
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor:          Model: Virtual CDROM    Rev: 1.00
  Type:   CD-ROM                           ANSI  SCSI revision: 00
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor:          Model: Virtual Floppy   Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00


Software Environment:

debian-test:/usr/src/linux-2.6.22.19/scripts# ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux debian-test.pr.univmed.fr 2.6.22.19 #1 SMP Fri May 30 19:53:56 CE=
ST 2008
i686 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
Modules Loaded         xt_length ipt_ttl xt_tcpmss iptable_mangle
iptable_filter xt_multiport xt_limit ipt_tos ipt_REJECT ip_tables x_tab=
les
button ac battery ipmi_devintf ipmi_si ipmi_msghandler ipv6 mptctl loop=
 sg
serio_raw tsdev joydev psmouse shpchp rtc pci_hotplug sr_mod cdrom evde=
v ext3
jbd mbcache dm_mirror dm_snapshot dm_mod ide_generic sd_mod usbhid usb_=
storage
ide_core mptsas qla2xxx mptscsih firmware_class mptbase ehci_hcd
scsi_transport_sas scsi_transport_fc uhci_hcd usbcore bnx2 scsi_mod the=
rmal
processor fan

debian-test:/usr/src/linux-2.6.22.19/scripts# cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03c0-03df : vga+
03f8-03ff : serial
0800-087f : pnp 00:05
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0828-082f : ACPI GPE0_BLK
  0850-0850 : ACPI PM2_CNT_BLK
0880-08bf : pnp 00:05
08c0-08df : pnp 00:05
08e0-08e3 : pnp 00:05
0900-0900 : pnp 00:05
0c00-0c7f : pnp 00:05
0ca0-0ca1 : pnp 00:05
0ca2-0ca2 : pnp 00:06
  0ca2-0ca2 : ipmi_si
0ca3-0ca3 : pnp 00:06
  0ca3-0ca3 : ipmi_si
0ca4-0caf : pnp 00:05
0cf8-0cff : PCI conf1
bc80-bc9f : 0000:00:1d.0
  bc80-bc9f : uhci_hcd
bca0-bcbf : 0000:00:1d.1
  bca0-bcbf : uhci_hcd
bcc0-bcdf : 0000:00:1d.2
  bcc0-bcdf : uhci_hcd
c000-cfff : PCI Bus #0d
  cc00-ccff : 0000:0d:04.0
d000-dfff : PCI Bus #09
  d800-d8ff : 0000:09:00.0
    d800-d8ff : qla2xxx
  dc00-dcff : 0000:09:00.1
    dc00-dcff : qla2xxx
e000-efff : PCI Bus #08
  ec00-ecff : 0000:08:00.0

debian-test:/usr/src/linux-2.6.22.19/scripts# cat /proc/iomem
00000000-0009ffff : System RAM
  00000000-00000000 : Crash kernel
000a0000-000bffff : Video RAM area
000c0000-000c8fff : Video ROM
000c9000-000c9fff : Adapter ROM
000ca000-000cbdff : Adapter ROM
000cc000-000cc1ff : Adapter ROM
000cc800-000d23ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-cfeb1fff : System RAM
  00100000-00299ee9 : Kernel code
  00299eea-00335f43 : Kernel data
cfeb2000-cfec7fff : reserved
cfec8000-cfee7bff : ACPI Tables
cfee7c00-cfffffff : reserved
d0000000-d7ffffff : PCI Bus #0d
  d0000000-d7ffffff : 0000:0d:04.0
d8000000-ddffffff : PCI Bus #01
  da000000-ddffffff : PCI Bus #02
    da000000-dbffffff : PCI Bus #05
      da000000-dbffffff : PCI Bus #06
        da000000-dbffffff : 0000:06:00.0
          da000000-dbffffff : bnx2
    dc000000-ddffffff : PCI Bus #03
      dc000000-ddffffff : PCI Bus #04
        dc000000-ddffffff : 0000:04:00.0
          dc000000-ddffffff : bnx2
de0ff800-de0ffbff : 0000:00:1d.7
  de0ff800-de0ffbff : ehci_hcd
de100000-de2fffff : PCI Bus #08
  de100000-de1fffff : 0000:08:00.0
  de2ec000-de2effff : 0000:08:00.0
  de2f0000-de2fffff : 0000:08:00.0
de300000-de3fffff : PCI Bus #09
  de300000-de33ffff : 0000:09:00.0
  de3f8000-de3fbfff : 0000:09:00.0
    de3f8000-de3fbfff : qla2xxx
  de3fc000-de3fffff : 0000:09:00.1
    de3fc000-de3fffff : qla2xxx
de400000-de4fffff : PCI Bus #0d
  de400000-de41ffff : 0000:0d:04.0
  de4f0000-de4fffff : 0000:0d:04.0
de500000-de5fffff : PCI Bus #09
  de500000-de53ffff : 0000:09:00.1
e0000000-efffffff : reserved
fe000000-ffffffff : reserved
100000000-22fffffff : System RAM



Problem Description:

Depending on the kernel version writes are fast or slow on every kernel=
 above
2.6.22 We have tested various driver versions, used utilities for firmw=
are, but
still slow writes on latest kernels. We compiled and tested more than 2=
0
kernels
We just discovered that after a quick test on new dell hardware powered=
ge m600.

Most of the current distrib are on 2.6.18, except Ubuntu and various vs=
erver or
openvz kernels for debian. We tested redhat and suse too.




Steps to reproduce:

Very easy: We also check for an untar of the kernel (5x slower)
debian-test:~# dd if=3D/dev/zero of=3D/root/test.cdrom bs=3D10k count=3D=
60000
60000+0 enregistrements lus
60000+0 enregistrements =C3=A9crits
614400000 octets (614 MB) copi=C3=A9s, 1,17602 seconde, 522 MB/s
debian-test:~# uname -a
Linux debian-test.pr.univmed.fr 2.6.19.7 #1 SMP Fri May 30 15:55:50 CES=
T 2008
i686 GNU/Linux

debian:~# dd if=3D/dev/zero of=3Dtest.cdrom  bs=3D10k count=3D60000
60000+0 records in
60000+0 records out
614400000 bytes (614 MB) copied, 7.51225 seconds, 81.8 MB/s
debian:~# uname -a
Linux debian 2.6.22-4-vserver-686 #1 SMP Tue Feb 12 22:02:04 UTC 2008 i=
686
GNU/Linux


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
