From: "christophe.varoqui" <christophe.varoqui@free.fr>
Subject: Re: Removing the qlogicfc driver
Date: Fri, 16 Jan 2004 23:18:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401162318.06392.christophe.varoqui@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.wanadoo.fr ([193.252.22.25]:33705 "EHLO
	mwinf0602.wanadoo.fr") by vger.kernel.org with ESMTP
	id S265877AbUAPWSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 17:18:09 -0500
Received: from 192.168.1.2 (AAmiens-106-1-4-53.w80-11.abo.wanadoo.fr [80.11.231.53])
	by mwinf0602.wanadoo.fr (SMTP Server) with ESMTP id B89B75400248
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2004 23:18:07 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I report that I can't see no LUN with the qla2xxx+qla2200 driver whereas the 
qlogicfc driver works fine (well until it BUGs :)

The LUNs are in StorageWorks EVA5000 & EMA8000 arrays.
The HBAs are 2 PCI qlogic 2200, latest bios.
Intel x86 arch.
The switchs are Brocade SilkWorm 8 ports 2 Gb/s

with qlogicfc :
xa-s03:~# multipath -v -d
600508b4000156d700012000000b0000 (0 0 1 1) /dev/sda [HSV110 (C)COMPAQ]
600508b4000156c30001200000210000 (0 0 1 2) /dev/sdb [HSV110 (C)COMPAQ]
60001fe1000bdad0000903507109004b (0 0 3 1) /dev/sdc [HSG80           ]
60001fe1000bdad000090371312100bf (0 0 3 2) /dev/sdd [HSG80           ]
60001fe1000bdad000090371312100c2 (0 0 3 3) /dev/sde [HSG80           ]
60001fe1000bdad00009037131210067 (0 0 4 1) /dev/sdf [HSG80           ]
60001fe1000bdad000090371312100b3 (0 0 4 2) /dev/sdg [HSG80           ]
60001fe1000bdad00009035071090024 (0 0 4 3) /dev/sdh [HSG80           ]
600508b4000156d700012000000b0000 (0 0 5 1) /dev/sdi [HSV110 (C)COMPAQ]
600508b4000156c30001200000210000 (0 0 5 2) /dev/sdj [HSV110 (C)COMPAQ]
600508b4000156d700012000000b0000 (1 0 1 1) /dev/sdk [HSV110 (C)COMPAQ]
600508b4000156c30001200000210000 (1 0 1 2) /dev/sdl [HSV110 (C)COMPAQ]
600508b4000156d700012000000b0000 (1 0 3 1) /dev/sdm [HSV110 (C)COMPAQ]
600508b4000156c30001200000210000 (1 0 3 2) /dev/sdn [HSV110 (C)COMPAQ]

with qla2200 beta* : nothing


Some debug info (let me know if I can provide more) :
---
kernel release :
2.6.0 + udm2 patchset (ie mm2 + devmapper stuff)

compilation cookie as reported by modinfo :
2.6.0-mm2 SMP PENTIUM4 gcc-3.3
---
kernel log :
QLogic Fibre Channel HBA Driver (f89c7000)
qla2200 0000:03:01.0: Found an ISP2200, irq 20, iobase 0xf8844000
qla2200 0000:03:01.0: Configuring PCI space...
qla2200 0000:03:01.0: Configure NVRAM parameters...
qla2200 0000:03:01.0: Verifying loaded RISC code...
qla2200 0000:03:01.0: Waiting for LIP to complete...
qla2200 0000:03:01.0: LOOP UP detected (1 Gbps).
qla2200 0000:03:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi2 : qla2xxx
qla2200 0000:03:01.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b9
  QLogic QLA22xx -
  ISP2200: PCI (66 MHz) @ 0000:03:01.0 hdma-, host#=2, fw=2.02.06 TP
qla2200 0000:06:01.0: Found an ISP2200, irq 24, iobase 0xf8846000
qla2200 0000:06:01.0: Configuring PCI space...
qla2200 0000:06:01.0: Configure NVRAM parameters...
qla2200 0000:06:01.0: Verifying loaded RISC code...
qla2200 0000:06:01.0: Waiting for LIP to complete...
qla2200 0000:06:01.0: LIP reset occured (f7f7).
qla2200 0000:06:01.0: LOOP UP detected (1 Gbps).
qla2200 0000:06:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi3 : qla2xxx
qla2200 0000:06:01.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b9
  QLogic QLA22xx -
  ISP2200: PCI (66 MHz) @ 0000:06:01.0 hdma-, host#=3, fw=2.02.06 TP
---
xa-s03:~# cat /proc/scsi/qla2xxx/2
QLogic PCI to Fibre Channel Host Adapter for QLA22xx:
        Firmware version 2.02.06 TP, Driver version 8.00.00b9
Entry address = f89c7000
ISP: ISP2200, Serial# C23881
Request Queue = 0x367c0000, Response Queue = 0x379ca000
Request Queue count = 1024, Response Queue count = 64
Total number of active commands = 0
Total number of interrupts = 29196
    Device queue depth = 0x10
Number of free request entries = 1023
Number of mailbox timeouts = 0
Number of ISP aborts = 0
Number of loop resyncs = 0
Number of retries for empty slots = 0
Number of reqs in pending_q= 0, retry_q= 0, done_q= 0, scsi_retry_q= 0
Host adapter:loop state = <READY>, flags = 0x1c83
Dpc flags = 0x0
MBX flags = 0x0
Link down Timeout = 000
Port down retry = 008
Login retry count = 008
Commands retried with dropped frame(s) = 0
Product ID = 4953 5020 2020 0001


SCSI Device Information:
scsi-qla0-adapter-node=200000e08b03896a;
scsi-qla0-adapter-port=210000e08b03896a;

SCSI LUN Information:
(Id:Lun)  * - indicates lun is not registered with the OS.
xa-s03:~#
---
lspci -vvv exerpt :
06:01.0 SCSI storage controller: QLogic Corp. QLA2200 (rev 05)
        Subsystem: QLogic Corp. QLA2200
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (16000ns min), Cache Line Size: 0x20 (128 bytes)
        Interrupt: pin A routed to IRQ 24
        Region 0: I/O ports at 5000 [size=256]
        Region 1: Memory at f7ff0000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at <unassigned> [disabled] [size=128K]
        Capabilities: [44] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


