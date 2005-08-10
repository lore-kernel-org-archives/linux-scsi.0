From: Mike McDonnell <mike@mikemcdonnell.org>
Subject: Bogus sysfs DEVPATH in SCSI emulation for USB Mass Storage device
Date: Wed, 10 Aug 2005 17:17:37 -0500
Message-ID: <42FA7D01.5060607@mikemcdonnell.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 207-36-117-53.ptr.primarydns.com ([207.36.117.53]:46986 "EHLO
	classicbertram.com") by vger.kernel.org with ESMTP id S932576AbVHJWRp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 18:17:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mike@mikemcdonnell.org

1. PROBLEM:

Bogus sysfs DEVPATH is generated for a USB Mass Storage device
(an Olympus D-545 digital camera emulating a Windows vfat disk).

2. FULL DESCRIPTION:

When plugging in the camera, the following trace
    was generated from "tail -f /var/log/messages":
Aug 10 16:14:32 beethoven kernel: usb 3-1: new full speed USB device 
using uhci_hcd and address 2
Aug 10 16:14:32 beethoven kernel: SCSI subsystem initialized
Aug 10 16:14:32 beethoven kernel: Initializing USB Mass Storage driver...
Aug 10 16:14:33 beethoven kernel: scsi0 : SCSI emulation for USB Mass 
Storage devices
Aug 10 16:14:33 beethoven kernel: usbcore: registered new driver usb-storage
Aug 10 16:14:33 beethoven kernel: USB Mass Storage support registered.
Aug 10 16:14:38 beethoven scsi.agent[2436]: bogus sysfs 
DEVPATH=/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host0/target0:0:0/0:0:0:0
Aug 10 16:14:38 beethoven kernel:   Vendor: OLYMPUS   Model: 
X550/D545Z/C480Z  Rev: 1.00
Aug 10 16:14:38 beethoven kernel:   Type:   Direct-Access 
        ANSI SCSI revision: 02

This result was generated on both Linux 2.6.10 and 2.6.12.
Under Linux 2.4.26, the camera is properly registered and is able to be
mounted as a vfat disk.

3. KEYWORDS: USB DEVPATH

4. KERNEL VERSION: Linux version 2.6.10

5. N/ A

6. N/ A

7. N/ A

7.1 SOFTWARE:

Linux beethoven 2.6.10 #9 Sun Apr 24 14:50:51 CDT 2005 i686 unknown 
unknown GNU/Linux

Gnu C                  3.3.4
Gnu make               3.80
binutils               2.15.90.0.3
util-linux             2.12a
mount                  2.12a
module-init-tools      3.0
e2fsprogs              1.35
jfsutils               1.1.6
reiserfsprogs          3.6.17
reiser4progs           line
xfsprogs               2.6.13
pcmcia-cs              3.2.7
quota-tools            3.12.
PPP                    2.4.2
nfs-utils              1.0.6
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Linux C++ Library      5.0.6
Procps                 3.2.1
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
Modules Loaded         bsd_comp usb_storage scsi_mod pcmcia yenta_socket 
pcmcia_core rtc

7.2 PROCESSOR:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 9
model name      : Intel(R) Pentium(R) M processor 1400MHz
stepping        : 5
cpu MHz         : 1395.697
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 sep mtrr pge mca cmov 
pat clflush dts acpi mmx fxsr sse sse2 tm pbe est tm2
bogomips        : 2760.70

7.3 MODULES

bsd_comp 5440 0 - Live 0xe0912000
usb_storage 28288 0 - Live 0xe091d000
scsi_mod 70428 1 usb_storage, Live 0xe0929000
pcmcia 17476 2 - Live 0xe090c000
yenta_socket 19200 0 - Live 0xe08f8000
pcmcia_core 45388 2 pcmcia,yenta_socket, Live 0xe08ff000
rtc 10424 0 - Live 0xe08ec000

7.3 LOADED DRIVERS AND HARDWARE INFO:

- IOPORTS:
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
0170-0177 : ide1
01f0-01f7 : ide0
02f8-02ff : serial
0300-030f : pnp 00:06
0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f6-03f6 : ide0
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
   1000-107f : motherboard
     1000-1003 : PM1a_EVT_BLK
     1004-1005 : PM1a_CNT_BLK
     1008-100b : PM_TMR
     1010-1015 : ACPI CPU throttle
     1020-1020 : PM2_CNT_BLK
     1028-102f : GPE0_BLK
1100-110f : 0000:00:1f.1
   1100-1107 : ide0
   1108-110f : ide1
1200-121f : 0000:00:1d.0
   1200-121f : uhci_hcd
1300-133f : 0000:00:1f.0
   1300-133f : motherboard
     1300-133f : pnp 00:06
1400-141f : 0000:00:1f.3
1600-161f : 0000:00:1d.1
   1600-161f : uhci_hcd
1700-171f : 0000:00:1d.2
   1700-171f : uhci_hcd
4000-40ff : PCI CardBus #03
4400-44ff : PCI CardBus #03
a000-a0ff : 0000:02:01.0
   a000-a0ff : 8139too
a100-a17f : 0000:02:00.0
c000-dfff : PCI Bus #01
   c100-c1ff : 0000:01:00.0
e000-e0ff : 0000:00:1f.5
   e000-e0ff : Intel 82801DB-ICH4
e100-e13f : 0000:00:1f.5
   e100-e13f : Intel 82801DB-ICH4
e200-e2ff : 0000:00:1f.6
   e200-e2ff : Intel 82801DB-ICH4 Modem
e300-e37f : 0000:00:1f.6
   e300-e37f : Intel 82801DB-ICH4 Modem

- IOMEM
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000e0000-000e17ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-1ffeffff : System RAM
   00100000-00397d47 : Kernel code
   00397d48-0048e2ff : Kernel data
1fff0000-1fffffbf : ACPI Tables
1fffffc0-1fffffff : ACPI Non-volatile Storage
20000000-200003ff : 0000:00:1f.1
20001000-20001fff : 0000:02:03.0
   20001000-20001fff : yenta_socket
20400000-207fffff : PCI CardBus #03
20800000-20bfffff : PCI CardBus #03
a0000000-afffffff : PCI Bus #01
   a8000000-afffffff : 0000:01:00.0
b0000000-b3ffffff : 0000:00:00.0
d0000000-d00000ff : 0000:02:01.0
   d0000000-d00000ff : 8139too
d0000800-d0000fff : 0000:02:00.0
e0000000-efffffff : PCI Bus #01
   e0010000-e001ffff : 0000:01:00.0
f0000000-f00003ff : 0000:00:1d.7
   f0000000-f00003ff : ehci_hcd
f0000400-f00005ff : 0000:00:1f.5
   f0000400-f00005ff : Intel 82801DB-ICH4
f0000600-f00006ff : 0000:00:1f.5
   f0000600-f00006ff : Intel 82801DB-ICH4
ffb80000-ffbfffff : reserved
fff80000-ffffffff : reserved

7.5 PCI INFO

00:00.0 Host bridge: Intel Corp. 82855PM Processor to I/O Controller 
(rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
         Latency: 0
         Region 0: Memory at b0000000 (32-bit, prefetchable) [size=64M]
         Capabilities: [e4] #09 [f104]
         Capabilities: [a0] AGP version 2.0
                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- 
FW- Rate=x2

00:01.0 PCI bridge: Intel Corp. 82855PM Processor to AGP Controller (rev 
03) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 128
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
         I/O behind bridge: 0000c000-0000dfff
         Memory behind bridge: e0000000-efffffff
         Prefetchable memory behind bridge: a0000000-afffffff
         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #1 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 10
         Region 4: I/O ports at 1200 [size=32]

00:1d.1 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #2 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 4: I/O ports at 1600 [size=32]

00:1d.2 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #3 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 11
         Region 4: I/O ports at 1700 [size=32]

00:1d.7 USB Controller: Intel Corp. 82801DB (ICH4) USB2 EHCI Controller 
(rev 03) (prog-if 20 [EHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin D routed to IRQ 11
         Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] #0a [2080]

00:1e.0 PCI bridge: Intel Corp. 82801BAM/CAM PCI Bridge (rev 83) 
(prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+
         Latency: 0
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
         I/O behind bridge: 0000a000-0000bfff
         Memory behind bridge: d0000000-dfffffff
         Prefetchable memory behind bridge: 90000000-9fffffff
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corp. 82801DBM LPC Interface Controller (rev 03)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:1f.1 IDE interface: Intel Corp. 82801DBM (ICH4) Ultra ATA Storage 
Controller (rev 03) (prog-if 8a [Master SecP PriP])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at <unassigned>
         Region 1: I/O ports at <unassigned>
         Region 2: I/O ports at <unassigned>
         Region 3: I/O ports at <unassigned>
         Region 4: I/O ports at 1100 [size=16]
         Region 5: Memory at 20000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corp. 82801DB/DBM (ICH4) SMBus Controller (rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin B routed to IRQ 255
         Region 4: I/O ports at 1400 [size=32]

00:1f.5 Multimedia audio controller: Intel Corp. 82801DB (ICH4) AC'97 
Audio Controller (rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0017
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 0: I/O ports at e000 [size=256]
         Region 1: I/O ports at e100 [size=64]
         Region 2: Memory at f0000400 (32-bit, non-prefetchable) [size=512]
         Region 3: Memory at f0000600 (32-bit, non-prefetchable) [size=256]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.6 Modem: Intel Corp. 82801DB (ICH4) AC'97 Modem Controller (rev 
03) (prog-if 00 [Generic])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 0: I/O ports at e200 [size=256]
         Region 1: I/O ports at e300 [size=128]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250 Lf 
[Radeon Mobility 9000 M9] (rev 01) (prog-if 00 [VGA])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 255 (2000ns min), cache line size 04
         Interrupt: pin A routed to IRQ 10
         Region 0: Memory at a8000000 (32-bit, prefetchable) [size=128M]
         Region 1: I/O ports at c100 [size=256]
         Region 2: Memory at e0010000 (32-bit, non-prefetchable) [size=64K]
         Expansion ROM at <unassigned> [disabled] [size=128K]
         Capabilities: [58] AGP version 2.0
                 Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- 
FW- Rate=<none>
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host 
Controller (rev 80) (prog-if 10 [OHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (8000ns max), cache line size 04
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at d0000800 (32-bit, non-prefetchable) [size=2K]
         Region 1: I/O ports at a100 [size=128]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (8000ns min, 16000ns max)
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at a000 [size=256]
         Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:03.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 168, cache line size 10
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at 20001000 (32-bit, non-prefetchable) [size=4K]
         Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
         Memory window 0: 20400000-207ff000 (prefetchable)
         Memory window 1: 20800000-20bff000
         I/O window 0: 00004000-000040ff
         I/O window 1: 00004400-000044ff
         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ 
PostWrite+
         16-bit legacy interface ports at 0001

7.6 SCSI INFO:  N/ A

7.7 OTHER RELEVANT:  ??????

1. PROBLEM:

Bogus sysfs DEVPATH is generated for a USB Mass Storage device
(an Olympus D-545 digital camera emulating a Windows vfat disk).

2. FULL DESCRIPTION:

When plugging in the camera, the following trace
    was generated from "tail -f /var/log/messages":
Aug 10 16:14:32 beethoven kernel: usb 3-1: new full speed USB device 
using uhci_hcd and address 2
Aug 10 16:14:32 beethoven kernel: SCSI subsystem initialized
Aug 10 16:14:32 beethoven kernel: Initializing USB Mass Storage driver...
Aug 10 16:14:33 beethoven kernel: scsi0 : SCSI emulation for USB Mass 
Storage devices
Aug 10 16:14:33 beethoven kernel: usbcore: registered new driver usb-storage
Aug 10 16:14:33 beethoven kernel: USB Mass Storage support registered.
Aug 10 16:14:38 beethoven scsi.agent[2436]: bogus sysfs 
DEVPATH=/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host0/target0:0:0/0:0:0:0
Aug 10 16:14:38 beethoven kernel:   Vendor: OLYMPUS   Model: 
X550/D545Z/C480Z  Rev: 1.00
Aug 10 16:14:38 beethoven kernel:   Type:   Direct-Access 
        ANSI SCSI revision: 02

This result was generated on both Linux 2.6.10 and 2.6.12.
Under Linux 2.4.26, the camera is properly registered and is able to be
mounted as a vfat disk.

3. KEYWORDS: USB DEVPATH

4. KERNEL VERSION: Linux version 2.6.10

5. N/ A

6. N/ A

7. N/ A

7.1 SOFTWARE:

Linux beethoven 2.6.10 #9 Sun Apr 24 14:50:51 CDT 2005 i686 unknown 
unknown GNU/Linux

Gnu C                  3.3.4
Gnu make               3.80
binutils               2.15.90.0.3
util-linux             2.12a
mount                  2.12a
module-init-tools      3.0
e2fsprogs              1.35
jfsutils               1.1.6
reiserfsprogs          3.6.17
reiser4progs           line
xfsprogs               2.6.13
pcmcia-cs              3.2.7
quota-tools            3.12.
PPP                    2.4.2
nfs-utils              1.0.6
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Linux C++ Library      5.0.6
Procps                 3.2.1
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
Modules Loaded         bsd_comp usb_storage scsi_mod pcmcia yenta_socket 
pcmcia_core rtc

7.2 PROCESSOR:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 9
model name      : Intel(R) Pentium(R) M processor 1400MHz
stepping        : 5
cpu MHz         : 1395.697
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 sep mtrr pge mca cmov 
pat clflush dts acpi mmx fxsr sse sse2 tm pbe est tm2
bogomips        : 2760.70

7.3 MODULES

bsd_comp 5440 0 - Live 0xe0912000
usb_storage 28288 0 - Live 0xe091d000
scsi_mod 70428 1 usb_storage, Live 0xe0929000
pcmcia 17476 2 - Live 0xe090c000
yenta_socket 19200 0 - Live 0xe08f8000
pcmcia_core 45388 2 pcmcia,yenta_socket, Live 0xe08ff000
rtc 10424 0 - Live 0xe08ec000

7.3 LOADED DRIVERS AND HARDWARE INFO:

- IOPORTS:
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
0170-0177 : ide1
01f0-01f7 : ide0
02f8-02ff : serial
0300-030f : pnp 00:06
0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f6-03f6 : ide0
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
   1000-107f : motherboard
     1000-1003 : PM1a_EVT_BLK
     1004-1005 : PM1a_CNT_BLK
     1008-100b : PM_TMR
     1010-1015 : ACPI CPU throttle
     1020-1020 : PM2_CNT_BLK
     1028-102f : GPE0_BLK
1100-110f : 0000:00:1f.1
   1100-1107 : ide0
   1108-110f : ide1
1200-121f : 0000:00:1d.0
   1200-121f : uhci_hcd
1300-133f : 0000:00:1f.0
   1300-133f : motherboard
     1300-133f : pnp 00:06
1400-141f : 0000:00:1f.3
1600-161f : 0000:00:1d.1
   1600-161f : uhci_hcd
1700-171f : 0000:00:1d.2
   1700-171f : uhci_hcd
4000-40ff : PCI CardBus #03
4400-44ff : PCI CardBus #03
a000-a0ff : 0000:02:01.0
   a000-a0ff : 8139too
a100-a17f : 0000:02:00.0
c000-dfff : PCI Bus #01
   c100-c1ff : 0000:01:00.0
e000-e0ff : 0000:00:1f.5
   e000-e0ff : Intel 82801DB-ICH4
e100-e13f : 0000:00:1f.5
   e100-e13f : Intel 82801DB-ICH4
e200-e2ff : 0000:00:1f.6
   e200-e2ff : Intel 82801DB-ICH4 Modem
e300-e37f : 0000:00:1f.6
   e300-e37f : Intel 82801DB-ICH4 Modem

- IOMEM
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000e0000-000e17ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-1ffeffff : System RAM
   00100000-00397d47 : Kernel code
   00397d48-0048e2ff : Kernel data
1fff0000-1fffffbf : ACPI Tables
1fffffc0-1fffffff : ACPI Non-volatile Storage
20000000-200003ff : 0000:00:1f.1
20001000-20001fff : 0000:02:03.0
   20001000-20001fff : yenta_socket
20400000-207fffff : PCI CardBus #03
20800000-20bfffff : PCI CardBus #03
a0000000-afffffff : PCI Bus #01
   a8000000-afffffff : 0000:01:00.0
b0000000-b3ffffff : 0000:00:00.0
d0000000-d00000ff : 0000:02:01.0
   d0000000-d00000ff : 8139too
d0000800-d0000fff : 0000:02:00.0
e0000000-efffffff : PCI Bus #01
   e0010000-e001ffff : 0000:01:00.0
f0000000-f00003ff : 0000:00:1d.7
   f0000000-f00003ff : ehci_hcd
f0000400-f00005ff : 0000:00:1f.5
   f0000400-f00005ff : Intel 82801DB-ICH4
f0000600-f00006ff : 0000:00:1f.5
   f0000600-f00006ff : Intel 82801DB-ICH4
ffb80000-ffbfffff : reserved
fff80000-ffffffff : reserved

7.5 PCI INFO

00:00.0 Host bridge: Intel Corp. 82855PM Processor to I/O Controller 
(rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
         Latency: 0
         Region 0: Memory at b0000000 (32-bit, prefetchable) [size=64M]
         Capabilities: [e4] #09 [f104]
         Capabilities: [a0] AGP version 2.0
                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- 
FW- Rate=x2

00:01.0 PCI bridge: Intel Corp. 82855PM Processor to AGP Controller (rev 
03) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 128
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
         I/O behind bridge: 0000c000-0000dfff
         Memory behind bridge: e0000000-efffffff
         Prefetchable memory behind bridge: a0000000-afffffff
         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #1 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 10
         Region 4: I/O ports at 1200 [size=32]

00:1d.1 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #2 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 4: I/O ports at 1600 [size=32]

00:1d.2 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #3 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 11
         Region 4: I/O ports at 1700 [size=32]

00:1d.7 USB Controller: Intel Corp. 82801DB (ICH4) USB2 EHCI Controller 
(rev 03) (prog-if 20 [EHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin D routed to IRQ 11
         Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] #0a [2080]

00:1e.0 PCI bridge: Intel Corp. 82801BAM/CAM PCI Bridge (rev 83) 
(prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+
         Latency: 0
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
         I/O behind bridge: 0000a000-0000bfff
         Memory behind bridge: d0000000-dfffffff
         Prefetchable memory behind bridge: 90000000-9fffffff
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corp. 82801DBM LPC Interface Controller (rev 03)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:1f.1 IDE interface: Intel Corp. 82801DBM (ICH4) Ultra ATA Storage 
Controller (rev 03) (prog-if 8a [Master SecP PriP])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at <unassigned>
         Region 1: I/O ports at <unassigned>
         Region 2: I/O ports at <unassigned>
         Region 3: I/O ports at <unassigned>
         Region 4: I/O ports at 1100 [size=16]
         Region 5: Memory at 20000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corp. 82801DB/DBM (ICH4) SMBus Controller (rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin B routed to IRQ 255
         Region 4: I/O ports at 1400 [size=32]

00:1f.5 Multimedia audio controller: Intel Corp. 82801DB (ICH4) AC'97 
Audio Controller (rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0017
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 0: I/O ports at e000 [size=256]
         Region 1: I/O ports at e100 [size=64]
         Region 2: Memory at f0000400 (32-bit, non-prefetchable) [size=512]
         Region 3: Memory at f0000600 (32-bit, non-prefetchable) [size=256]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.6 Modem: Intel Corp. 82801DB (ICH4) AC'97 Modem Controller (rev 
03) (prog-if 00 [Generic])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 0: I/O ports at e200 [size=256]
         Region 1: I/O ports at e300 [size=128]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250 Lf 
[Radeon Mobility 9000 M9] (rev 01) (prog-if 00 [VGA])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 255 (2000ns min), cache line size 04
         Interrupt: pin A routed to IRQ 10
         Region 0: Memory at a8000000 (32-bit, prefetchable) [size=128M]
         Region 1: I/O ports at c100 [size=256]
         Region 2: Memory at e0010000 (32-bit, non-prefetchable) [size=64K]
         Expansion ROM at <unassigned> [disabled] [size=128K]
         Capabilities: [58] AGP version 2.0
                 Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- 
FW- Rate=<none>
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host 
Controller (rev 80) (prog-if 10 [OHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (8000ns max), cache line size 04
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at d0000800 (32-bit, non-prefetchable) [size=2K]
         Region 1: I/O ports at a100 [size=128]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (8000ns min, 16000ns max)
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at a000 [size=256]
         Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:03.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 168, cache line size 10
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at 20001000 (32-bit, non-prefetchable) [size=4K]
         Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
         Memory window 0: 20400000-207ff000 (prefetchable)
         Memory window 1: 20800000-20bff000
         I/O window 0: 00004000-000040ff
         I/O window 1: 00004400-000044ff
         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ 
PostWrite+
         16-bit legacy interface ports at 0001

7.6 SCSI INFO:  N/ A

7.7 OTHER RELEVANT:  ??????

1. PROBLEM:

Bogus sysfs DEVPATH is generated for a USB Mass Storage device
(an Olympus D-545 digital camera emulating a Windows vfat disk).

2. FULL DESCRIPTION:

When plugging in the camera, the following trace
    was generated from "tail -f /var/log/messages":
Aug 10 16:14:32 beethoven kernel: usb 3-1: new full speed USB device 
using uhci_hcd and address 2
Aug 10 16:14:32 beethoven kernel: SCSI subsystem initialized
Aug 10 16:14:32 beethoven kernel: Initializing USB Mass Storage driver...
Aug 10 16:14:33 beethoven kernel: scsi0 : SCSI emulation for USB Mass 
Storage devices
Aug 10 16:14:33 beethoven kernel: usbcore: registered new driver usb-storage
Aug 10 16:14:33 beethoven kernel: USB Mass Storage support registered.
Aug 10 16:14:38 beethoven scsi.agent[2436]: bogus sysfs 
DEVPATH=/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/host0/target0:0:0/0:0:0:0
Aug 10 16:14:38 beethoven kernel:   Vendor: OLYMPUS   Model: 
X550/D545Z/C480Z  Rev: 1.00
Aug 10 16:14:38 beethoven kernel:   Type:   Direct-Access 
        ANSI SCSI revision: 02

This result was generated on both Linux 2.6.10 and 2.6.12.
Under Linux 2.4.26, the camera is properly registered and is able to be
mounted as a vfat disk.

3. KEYWORDS: USB DEVPATH

4. KERNEL VERSION: Linux version 2.6.10

5. N/ A

6. N/ A

7. N/ A

7.1 SOFTWARE:

Linux beethoven 2.6.10 #9 Sun Apr 24 14:50:51 CDT 2005 i686 unknown 
unknown GNU/Linux

Gnu C                  3.3.4
Gnu make               3.80
binutils               2.15.90.0.3
util-linux             2.12a
mount                  2.12a
module-init-tools      3.0
e2fsprogs              1.35
jfsutils               1.1.6
reiserfsprogs          3.6.17
reiser4progs           line
xfsprogs               2.6.13
pcmcia-cs              3.2.7
quota-tools            3.12.
PPP                    2.4.2
nfs-utils              1.0.6
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Linux C++ Library      5.0.6
Procps                 3.2.1
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
Modules Loaded         bsd_comp usb_storage scsi_mod pcmcia yenta_socket 
pcmcia_core rtc

7.2 PROCESSOR:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 9
model name      : Intel(R) Pentium(R) M processor 1400MHz
stepping        : 5
cpu MHz         : 1395.697
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 sep mtrr pge mca cmov 
pat clflush dts acpi mmx fxsr sse sse2 tm pbe est tm2
bogomips        : 2760.70

7.3 MODULES

bsd_comp 5440 0 - Live 0xe0912000
usb_storage 28288 0 - Live 0xe091d000
scsi_mod 70428 1 usb_storage, Live 0xe0929000
pcmcia 17476 2 - Live 0xe090c000
yenta_socket 19200 0 - Live 0xe08f8000
pcmcia_core 45388 2 pcmcia,yenta_socket, Live 0xe08ff000
rtc 10424 0 - Live 0xe08ec000

7.3 LOADED DRIVERS AND HARDWARE INFO:

- IOPORTS:
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
0170-0177 : ide1
01f0-01f7 : ide0
02f8-02ff : serial
0300-030f : pnp 00:06
0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f6-03f6 : ide0
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
   1000-107f : motherboard
     1000-1003 : PM1a_EVT_BLK
     1004-1005 : PM1a_CNT_BLK
     1008-100b : PM_TMR
     1010-1015 : ACPI CPU throttle
     1020-1020 : PM2_CNT_BLK
     1028-102f : GPE0_BLK
1100-110f : 0000:00:1f.1
   1100-1107 : ide0
   1108-110f : ide1
1200-121f : 0000:00:1d.0
   1200-121f : uhci_hcd
1300-133f : 0000:00:1f.0
   1300-133f : motherboard
     1300-133f : pnp 00:06
1400-141f : 0000:00:1f.3
1600-161f : 0000:00:1d.1
   1600-161f : uhci_hcd
1700-171f : 0000:00:1d.2
   1700-171f : uhci_hcd
4000-40ff : PCI CardBus #03
4400-44ff : PCI CardBus #03
a000-a0ff : 0000:02:01.0
   a000-a0ff : 8139too
a100-a17f : 0000:02:00.0
c000-dfff : PCI Bus #01
   c100-c1ff : 0000:01:00.0
e000-e0ff : 0000:00:1f.5
   e000-e0ff : Intel 82801DB-ICH4
e100-e13f : 0000:00:1f.5
   e100-e13f : Intel 82801DB-ICH4
e200-e2ff : 0000:00:1f.6
   e200-e2ff : Intel 82801DB-ICH4 Modem
e300-e37f : 0000:00:1f.6
   e300-e37f : Intel 82801DB-ICH4 Modem

- IOMEM
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000e0000-000e17ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-1ffeffff : System RAM
   00100000-00397d47 : Kernel code
   00397d48-0048e2ff : Kernel data
1fff0000-1fffffbf : ACPI Tables
1fffffc0-1fffffff : ACPI Non-volatile Storage
20000000-200003ff : 0000:00:1f.1
20001000-20001fff : 0000:02:03.0
   20001000-20001fff : yenta_socket
20400000-207fffff : PCI CardBus #03
20800000-20bfffff : PCI CardBus #03
a0000000-afffffff : PCI Bus #01
   a8000000-afffffff : 0000:01:00.0
b0000000-b3ffffff : 0000:00:00.0
d0000000-d00000ff : 0000:02:01.0
   d0000000-d00000ff : 8139too
d0000800-d0000fff : 0000:02:00.0
e0000000-efffffff : PCI Bus #01
   e0010000-e001ffff : 0000:01:00.0
f0000000-f00003ff : 0000:00:1d.7
   f0000000-f00003ff : ehci_hcd
f0000400-f00005ff : 0000:00:1f.5
   f0000400-f00005ff : Intel 82801DB-ICH4
f0000600-f00006ff : 0000:00:1f.5
   f0000600-f00006ff : Intel 82801DB-ICH4
ffb80000-ffbfffff : reserved
fff80000-ffffffff : reserved

7.5 PCI INFO

00:00.0 Host bridge: Intel Corp. 82855PM Processor to I/O Controller 
(rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
         Latency: 0
         Region 0: Memory at b0000000 (32-bit, prefetchable) [size=64M]
         Capabilities: [e4] #09 [f104]
         Capabilities: [a0] AGP version 2.0
                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- 
FW- Rate=x2

00:01.0 PCI bridge: Intel Corp. 82855PM Processor to AGP Controller (rev 
03) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 128
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
         I/O behind bridge: 0000c000-0000dfff
         Memory behind bridge: e0000000-efffffff
         Prefetchable memory behind bridge: a0000000-afffffff
         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #1 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 10
         Region 4: I/O ports at 1200 [size=32]

00:1d.1 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #2 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 4: I/O ports at 1600 [size=32]

00:1d.2 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #3 (rev 03) 
(prog-if 00 [UHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 11
         Region 4: I/O ports at 1700 [size=32]

00:1d.7 USB Controller: Intel Corp. 82801DB (ICH4) USB2 EHCI Controller 
(rev 03) (prog-if 20 [EHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin D routed to IRQ 11
         Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] #0a [2080]

00:1e.0 PCI bridge: Intel Corp. 82801BAM/CAM PCI Bridge (rev 83) 
(prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+
         Latency: 0
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
         I/O behind bridge: 0000a000-0000bfff
         Memory behind bridge: d0000000-dfffffff
         Prefetchable memory behind bridge: 90000000-9fffffff
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corp. 82801DBM LPC Interface Controller (rev 03)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:1f.1 IDE interface: Intel Corp. 82801DBM (ICH4) Ultra ATA Storage 
Controller (rev 03) (prog-if 8a [Master SecP PriP])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at <unassigned>
         Region 1: I/O ports at <unassigned>
         Region 2: I/O ports at <unassigned>
         Region 3: I/O ports at <unassigned>
         Region 4: I/O ports at 1100 [size=16]
         Region 5: Memory at 20000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corp. 82801DB/DBM (ICH4) SMBus Controller (rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin B routed to IRQ 255
         Region 4: I/O ports at 1400 [size=32]

00:1f.5 Multimedia audio controller: Intel Corp. 82801DB (ICH4) AC'97 
Audio Controller (rev 03)
         Subsystem: COMPAL Electronics Inc: Unknown device 0017
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 0: I/O ports at e000 [size=256]
         Region 1: I/O ports at e100 [size=64]
         Region 2: Memory at f0000400 (32-bit, non-prefetchable) [size=512]
         Region 3: Memory at f0000600 (32-bit, non-prefetchable) [size=256]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.6 Modem: Intel Corp. 82801DB (ICH4) AC'97 Modem Controller (rev 
03) (prog-if 00 [Generic])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 11
         Region 0: I/O ports at e200 [size=256]
         Region 1: I/O ports at e300 [size=128]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250 Lf 
[Radeon Mobility 9000 M9] (rev 01) (prog-if 00 [VGA])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 255 (2000ns min), cache line size 04
         Interrupt: pin A routed to IRQ 10
         Region 0: Memory at a8000000 (32-bit, prefetchable) [size=128M]
         Region 1: I/O ports at c100 [size=256]
         Region 2: Memory at e0010000 (32-bit, non-prefetchable) [size=64K]
         Expansion ROM at <unassigned> [disabled] [size=128K]
         Capabilities: [58] AGP version 2.0
                 Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- 
FW- Rate=<none>
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host 
Controller (rev 80) (prog-if 10 [OHCI])
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (8000ns max), cache line size 04
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at d0000800 (32-bit, non-prefetchable) [size=2K]
         Region 1: I/O ports at a100 [size=128]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (8000ns min, 16000ns max)
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at a000 [size=256]
         Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:03.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller
         Subsystem: COMPAL Electronics Inc: Unknown device 0012
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 168, cache line size 10
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at 20001000 (32-bit, non-prefetchable) [size=4K]
         Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
         Memory window 0: 20400000-207ff000 (prefetchable)
         Memory window 1: 20800000-20bff000
         I/O window 0: 00004000-000040ff
         I/O window 1: 00004400-000044ff
         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ 
PostWrite+
         16-bit legacy interface ports at 0001

7.6 SCSI INFO:  N/ A

7.7 OTHER RELEVANT:  ??????

