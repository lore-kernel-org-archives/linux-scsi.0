From: Salman <salman@onefishtwofishredfishbluefish.org>
Subject: PROBLEM: QLA1280 driver conflicts with SiS chipset
  motherboards 2.4.23 kernel.
Date: Mon, 08 Dec 2003 15:53:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20031208153537.01bc3a68@192.168.0.5>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from onefishtwofishredfishbluefish.org ([66.197.189.203]:55027 "EHLO
	symphony.onefishtwofishredfishbluefish.org") by vger.kernel.org
	with ESMTP id S262033AbTLHUxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2003 15:53:13 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: davidw@burst.net, salman@burst.net

The included QLA1280 drivers in the 2.4.23 kernel (stable release) appear 
to be conflicting with the SiS chipset.

The QLA1280 drivers when used on motherboards which have an SiS chipset 
freeze a system, hard whenever there's any heave disc activity such as an 
fsck being performed or a data-backup process being run.

Kernel version: 2.4.23

Oops: N/A

Problem duplication: So far I have only been able to test this on a P4 
systems as I don't have equivalent hardware for any AMD machines -- to 
duplicate the problem, reset a machine and force an fsck on boot-up. The 
process will run for a few seconds and then lock-up the machine requiring 
another reset/power-cycle.

Problem has been duplicated under RH 7.3, 8.0, 9.0.

Software:
Linux chicken.hostnoc.net 2.4.23-HN-1.3-P4-grsec #1 SMP Mon Dec 8 12:40:50 
EST 2
003 i686 i686 i386 GNU/Linux

Gnu C                  3.2
Gnu make               3.79.1
util-linux             2.11r
mount                  2.11r
modutils               2.4.18
e2fsprogs              1.27
jfsutils               1.0.17
reiserfsprogs          3.6.2
quota-tools            3.06.
PPP                    2.4.1
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 2.0.7
Net-tools              1.60
Kbd                    1.06
Sh-utils               2.0.12
Modules Loaded

Processor info:
root@chicken [/usr/src/linux-2.4.22]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 1
model name      : Intel(R) Pentium(R) 4 CPU 1.60GHz
stepping        : 2
cpu MHz         : 1614.407
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips        : 3224.37


Modules: None

Drivers and hardware:
cat /proc/ioports
0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial(auto)
0cf8-0cff : PCI conf1
9800-98ff : QLogic Corp. ISP1080 SCSI Host Adapter
   9800-98fe : qla1280
a000-a0ff : Silicon Integrated Systems [SiS] SiS900 10/100 Ethernet
   a000-a0ff : sis900
a400-a47f : Silicon Integrated Systems [SiS] Sound Controller
a800-a8ff : Silicon Integrated Systems [SiS] Sound Controller
b800-b80f : Silicon Integrated Systems [SiS] 5513 [IDE]
   b800-b807 : ide0
   b808-b80f : ide1
d000-dfff : PCI Bus #01
   d800-d87f : Silicon Integrated Systems [SiS] SiS65x/M650/740 PCI/AGP VGA 
Display Adapter
---
cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cc000-000ce7ff : Extension ROM
000f0000-000fffff : System ROM
00100000-1dffbfff : System RAM
   0024c000-00510bd5 : Kernel code
1dffc000-1dffefff : ACPI Tables
1dfff000-1dffffff : ACPI Non-volatile Storage
e5800000-e5800fff : QLogic Corp. ISP1080 SCSI Host Adapter
e6000000-e6000fff : Silicon Integrated Systems [SiS] SiS900 10/100 Ethernet
   e6000000-e6000fff : sis900
e6800000-e6800fff : Silicon Integrated Systems [SiS] USB 1.0 Controller (#2)
   e6800000-e6800fff : usb-ohci
e7000000-e7000fff : Silicon Integrated Systems [SiS] USB 1.0 Controller
   e7000000-e7000fff : usb-ohci
e7800000-e7ffffff : PCI Bus #01
   e7800000-e781ffff : Silicon Integrated Systems [SiS] SiS65x/M650/740 
PCI/AGP VGA Display Adapter
e8000000-ebffffff : Silicon Integrated Systems [SiS] 650 Host
f0000000-febfffff : PCI Bus #01
   f0000000-f7ffffff : Silicon Integrated Systems [SiS] SiS65x/M650/740 
PCI/AGP VGA Display Adapter
fec00000-fec00fff : reserved
fee00000-fee00fff : reserved
ffff0000-ffffffff : reserved

lspci output:
lspci -vvv
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 650 Host (rev 01)
         Subsystem: Asustek Computer, Inc.: Unknown device 8079
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
         Latency: 32
         Region 0: Memory at e8000000 (32-bit, non-prefetchable) [size=64M]
         Capabilities: [c0] AGP version 2.0
                 Status: RQ=31 SBA+ 64bit- FW- Rate=x1,x2,x4
                 Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] 5591/5592 AGP (prog-if 
00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 0000d000-0000dfff
         Memory behind bridge: e7800000-e7ffffff
         Prefetchable memory behind bridge: f0000000-febfffff
         BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] 85C503/5513
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:02.2 USB Controller: Silicon Integrated Systems [SiS] 7001 (rev 07) 
(prog-if 10 [OHCI])
         Subsystem: Asustek Computer, Inc.: Unknown device 807a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+
         Latency: 32 (20000ns max), cache line size 08
         Interrupt: pin D routed to IRQ 12
         Region 0: Memory at e7000000 (32-bit, non-prefetchable) [size=4K]

00:02.3 USB Controller: Silicon Integrated Systems [SiS] 7001 (rev 07) 
(prog-if 10 [OHCI])
         Subsystem: Asustek Computer, Inc.: Unknown device 807a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (20000ns max), cache line size 08
         Interrupt: pin D routed to IRQ 12
         Region 0: Memory at e6800000 (32-bit, non-prefetchable) [size=4K]

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev d0) 
(prog-if 80 [Master])
         Subsystem: Asustek Computer, Inc.: Unknown device 807a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 128
         Region 4: I/O ports at b800 [size=16]

00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS] 
SiS7012 PCI Audio Accelerator (rev a0)
         Subsystem: Asustek Computer, Inc.: Unknown device 8072
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (13000ns min, 2750ns max)
         Interrupt: pin C routed to IRQ 10
         Region 0: I/O ports at a800 [size=256]
         Region 1: I/O ports at a400 [size=128]
         Capabilities: [48] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 10/100 
Ethernet (rev 90)
         Subsystem: Asustek Computer, Inc.: Unknown device 807c
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (13000ns min, 2750ns max)
         Interrupt: pin A routed to IRQ 10
         Region 0: I/O ports at a000 [size=256]
         Region 1: Memory at e6000000 (32-bit, non-prefetchable) [size=4K]
         Expansion ROM at <unassigned> [disabled] [size=128K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.0 SCSI storage controller: QLogic Corp. ISP1080 SCSI Host Adapter 
(rev 01)
         Subsystem: QLogic Corp.: Unknown device 0005
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 32, cache line size 08
         Interrupt: pin A routed to IRQ 10
         Region 0: I/O ports at 9800 [size=256]
         Region 1: Memory at e5800000 (32-bit, non-prefetchable) [disabled] 
[size=4K]
         Expansion ROM at <unassigned> [disabled] [size=64K]
         Capabilities: [44] Power Management version 1
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]: 
Unknown device 6325 (prog-if 00 [VGA])
         Subsystem: Asustek Computer, Inc.: Unknown device 8079
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin A routed to IRQ 11
         BIST result: 00
         Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
         Region 1: Memory at e7800000 (32-bit, non-prefetchable) [size=128K]
         Region 2: I/O ports at d800 [size=128]
         Capabilities: [40] Power Management version 1
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] AGP version 2.0
                 Status: RQ=15 SBA+ 64bit- FW- Rate=x1,x2,x4
                 Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>

scsi info:
root@chicken [~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: IBM      Model: DPSS-336950N     Rev: S96H
   Type:   Direct-Access                    ANSI SCSI revision: 03


Other misc hardware info: The problem was duplicated on machines with P4 
CPUs, motherboards which had SiS chipset onboard along with a qlogic scsi 
adapater, 1-3 scsi drives, and 1-2 ide drives used for miscellaneous purposes.

Kernels on which problem was duplicated: 2.4.23 -- vanilla and with grsec 
patch.

Workaround: Replacing usr/src/linux/drivers/scsi/ql* for 2.4.23 with the 
files from 2.4.22 seems to fix the problem.

If you have any other questions or need any additional info, please contact me.

-salman


