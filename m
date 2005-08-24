From: Drew Winstel <raw@dslr.net>
Subject: qla2xxx: does not respond to SCSI_IOCTL_PROBE_HOST
Date: Wed, 24 Aug 2005 15:34:15 -0500
Message-ID: <1124915655.13251.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dslreports.com ([209.123.192.187]:36316 "EHLO
	mail.dslr.net") by vger.kernel.org with ESMTP id S932151AbVHXUd4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 16:33:56 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.dslr.net (Postfix) with ESMTP id C316542B7D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 16:33:48 -0400 (EDT)
Received: from mail.dslr.net ([127.0.0.1])
 by localhost (coral.dslreports.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 26285-02 for <linux-scsi@vger.kernel.org>;
 Wed, 24 Aug 2005 16:33:48 -0400 (EDT)
Received: from unknown.local.lan (68-190-22-232.dhcp.mtgm.al.charter.com [68.190.22.232])
	by mail.dslr.net (Postfix) with ESMTP id 1CD0242B7D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2005 16:33:47 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello, all.

Here's the situation.  I am running a QLogic QLA2200 (32-bit mode; lspci
output follows), and when I issue an ioctl() to call
SCSI_IOCTL_PROBE_HOST to /dev/sg0 (example code follows as well), the
ioctl() returns 0, as if to imply that there is no host present, which
is obviously not possible since the drive is attached to the HBA.  Using
an Adaptec 29160 adapter with a drive connected produces logical,
reasonable output, so I'm turning to the experts here.  Is this by
design, a bug, or just something I've horribly missed?  I have tried it
with a 2.6.11 and 2.6.12.5 kernel to no avail.
Thanks, 
Drew Winstel

Linux localhost.localdomain 2.6.12.5 #1 Mon Aug 22 14:01:04 CDT 2005
i686 athlon i386 GNU/Linux 00:00.0 Host bridge: nVidia Corporation
nForce2 AGP (different version?) (rev c1)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [40] AGP version 3.0
		Status: RQ=32 Iso- ArqSz=2 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW+ AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=x4
	Capabilities: [60] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Revision ID: 0.16

00:00.1 RAM memory: nVidia Corporation nForce2 Memory Controller 1 (rev
c1)
	Subsystem: nVidia Corporation: Unknown device 0c17
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:00.2 RAM memory: nVidia Corporation nForce2 Memory Controller 4 (rev
c1)
	Subsystem: nVidia Corporation: Unknown device 0c17
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:00.3 RAM memory: nVidia Corporation nForce2 Memory Controller 3 (rev
c1)
	Subsystem: nVidia Corporation: Unknown device 0c17
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:00.4 RAM memory: nVidia Corporation nForce2 Memory Controller 2 (rev
c1)
	Subsystem: nVidia Corporation: Unknown device 0c17
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:00.5 RAM memory: nVidia Corporation nForce2 Memory Controller 5 (rev
c1)
	Subsystem: nVidia Corporation: Unknown device 0c17
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:01.0 ISA bridge: nVidia Corporation nForce2 ISA Bridge (rev a4)
	Subsystem: Giga-byte Technology: Unknown device 0c11
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [48] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=1 UnitCnt=15 MastHost- DefDir-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC+ TXO- <CRCErr=0
		Link Config 0: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Link Control 1: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO+ <CRCErr=0
		Link Config 1: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
		Revision ID: 0.00

00:01.1 SMBus: nVidia Corporation nForce2 SMBus (MCP) (rev a2)
	Subsystem: Giga-byte Technology: Unknown device 0c11
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at ec00 [size=32]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.0 USB Controller: nVidia Corporation nForce2 USB Controller (rev
a4) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology: Unknown device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 4
	Region 0: Memory at e0002000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 USB Controller: nVidia Corporation nForce2 USB Controller (rev
a4) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology: Unknown device 5004
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at e0003000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 PCI bridge: nVidia Corporation nForce2 External PCI Bridge (rev
a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000a000-0000dfff
	Memory behind bridge: de000000-dfffffff
	Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:09.0 IDE interface: nVidia Corporation nForce2 IDE (rev a2) (prog-if
8a [Master SecP PriP])
	Subsystem: Giga-byte Technology: Unknown device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Region 4: I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1e.0 PCI bridge: nVidia Corporation nForce2 AGP (rev c1) (prog-if 00
[Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	Memory behind bridge: dc000000-ddffffff
	Prefetchable memory behind bridge: d0000000-d7ffffff
	Secondary status: 66Mhz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

01:06.0 DPIO module: Adlink Technology: Unknown device 7248 (rev 02)
	Subsystem: Adlink Technology: Unknown device 7248
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 5
	Region 1: I/O ports at a000 [size=128]
	Region 2: I/O ports at a400 [size=256]
	Region 5: I/O ports at a800 [size=256]

01:08.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
	Subsystem: Adaptec 29160 Ultra160 SCSI Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (10000ns min, 6250ns max), Cache Line Size 08
	Interrupt: pin A routed to IRQ 11
	BIST result: 00
	Region 0: I/O ports at ac00 [disabled] [size=256]
	Region 1: Memory at df008000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:09.0 SCSI storage controller: QLogic Corp. QLA2200 64-bit Fibre
Channel Adapter (rev 05)
	Subsystem: QLogic Corp. QLA2200
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size 10
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at b000 [size=256]
	Region 1: Memory at df004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
Gigabit Ethernet (rev 10)
	Subsystem: Giga-byte Technology GA-K8VT800 Pro Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (8000ns min, 16000ns max), Cache Line Size 10
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at b400 [size=256]
	Region 1: Memory at df005000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot
+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:0d.0 Unknown mass storage controller: Silicon Image, Inc. SiI 3512
[SATALink/SATARaid] Serial ATA Controller (rev 01)
	Subsystem: Silicon Image, Inc. SiI 3512 SATALink Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size 08
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at cc00 [size=8]
	Region 1: I/O ports at d000 [size=4]
	Region 2: I/O ports at d400 [size=8]
	Region 3: I/O ports at d800 [size=4]
	Region 4: I/O ports at dc00 [size=16]
	Region 5: Memory at df006000 (32-bit, non-prefetchable) [size=512]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

01:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23
IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology: Unknown device 1000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at df007000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at df000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

02:00.0 VGA compatible controller: nVidia Corporation NV34 [GeForce FX
5200] (rev a1) (prog-if 00 [VGA])
	Subsystem: LeadTek Research Inc.: Unknown device 2967
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1250ns min, 250ns max)
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [44] AGP version 3.0
		Status: RQ=32 Iso- ArqSz=0 Cal=3 SBA+ ITACoh- GART64- HTrans- 64bit-
FW+ AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>


/* Stupid test to see if this beast can execute SG_IOCTL_PROBE_HOST on a
qla2xxx*/

#include <stdio.h>
#include <scsi/sg.h>
#define SCSI_IOCTL_PROBE_HOST 0x5385

int main (void) {
  FILE *fd = fopen("/dev/sg0","r");
  char buffer[50]; /* just a simple storage */
  *buffer = (int)50;
  unsigned int fd_number = fd->_fileno;
  int retval_of_ioctl = ioctl(fd_number, SCSI_IOCTL_PROBE_HOST, buffer);
  printf("The returned value is %d, and the host name is %s.\n",
retval_of_ioctl, buffer);
  fclose(fd);
  return retval_of_ioctl;
}

