From: "K.Kodama" <kdm@kobe-kosen.ac.jp>
Subject: aha152x.c
Date: Wed, 25 Dec 2002 21:02:20 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021225.210220.126145666.kdm@kobe-kosen.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: fischer@norbit.de, linux-scsi@vger.kernel.org

Hi,
This is only reporting.

[1.] One line summary of the problem:    
"aha152x_cs" makes kernel freeze.

[2.] Full description of the problem/report:

I have some problem with "aha152x_cs" in kernel 2.4.19 and 2.4.20.
May be, there is non-alignment between aha152x.c and the kernel.

* With kernel 2.4.19:
When Adaptec PCMCIA card is inserted, the following message occur.

Unable to handle kernel NULL pointer dereference at virtual address 0000001b
 ....
And, kernel panic, later.

* With kernel 2.4.20:
When Adaptec PCMCIA card is inserted, I have no problem.
When physically eject, kernel freeze.
Logically eject using "cardctl eject" has no problem.

[3.] Keywords (i.e., modules, networking, kernel):

drivers, scsi, aha152x.c

[4.] Kernel version (from /proc/version):

2.4.19 and 2.4.20

Linux version 2.4.19 (root@guppy) (gcc version 2.95.3 20010315 (release))
Linux version 2.4.20 (root@guppy) (gcc version 2.95.3 20010315 (release))


[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)

With Linux version 2.4.19. When insert Adaptec PCMCIA card.

aha152x: processing commandline: ok
aha152x: BIOS test: passed, detected 1 controller(s)
aha152x: resetting bus...
aha152x0: vital data: rev=1, io=0x340 (0x340/0x340), irq=3, scsiid=7, reconnect=enabled, parity=enab
led, synchronous=disabled, delay=100, extended translation=disabled
aha152x0: trying software interrupt, ok.
scsi0 : Adaptec 152x SCSI driver; $Revision: 2.5 $
  Vendor: IOMEGA    Model: ZIP 100           Rev: J.02
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi removable disk sda at scsi0, channel 0, id 5, lun 0
SCSI device sda: 196608 512-byte hdwr sectors (101 MB)
sda: Write Protect is off
 sda:<1>Unable to handle kernel NULL pointer dereference at virtual address 0000001b
 printing eip:
f88ce6e7
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<f88ce6e7>]    Not tainted
EFLAGS: 00010002
eax: 00000000   ebx: f3907200   ecx: c0003000   edx: f39df200
esi: f67e6400   edi: f3907200   ebp: f5fd9cb8   esp: f5fd9ca0
ds: 0018   es: 0018   ss: 0018
Process modprobe (pid: 6221, stackpage=f5fd9000)
Stack: 00000293 f6174414 f3907200 ea8f89e0 00000002 f6068000 f5fd9ce8 f88ce7f6 
       f3907200 00000000 00000000 00000000 f88b8a78 f3907200 f6174414 f88bbfdd 
       f390726c f3907200 f67e6400 f88b853f f3907200 f88b8a78 f3907200 f6174414 
Call Trace:    [<f88ce7f6>] [<f88b8a78>] [<f88bbfdd>] [<f88b853f>] [<f88b8a78>]
  [<f88bee2f>] [<f88d8660>] [<c0192614>] [<c0118a74>] [<c0133242>] [<c01239f5>]
  [<c0123a34>] [<c0125aa2>] [<c014d3e2>] [<c01347bc>] [<c014d6ca>] [<c014d8b6>]
  [<c0114da3>] [<c0134a7e>] [<c014d214>] [<c0114da3>] [<f88d7379>] [<c014d377>]
  [<f88d8660>] [<c014d2b6>] [<f88d79b9>] [<f88d86a8>] [<f88d8660>] [<f88b9c54>]
  [<f88b9c8a>] [<f88d8660>] [<f88b9d8c>] [<f88d8660>] [<f88d7ee6>] [<f88d8660>]
  [<c01158ed>] [<f88d6060>] [<c010853f>] [<c021002b>]

Code: 0f b6 50 1b 8b 14 95 3c 64 2a c0 2b 82 a0 00 00 00 69 c0 a3 
 <3>(scsi0:5:0) cannot abort running or disconnected command
Unable to handle kernel NULL pointer dereference at virtual address 0000001b
 printing eip:
f88ce6e7
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<f88ce6e7>]    Not tainted
EFLAGS: 00010002
eax: 00000000   ebx: f3907200   ecx: c0003000   edx: f6bf7620
esi: f67e6400   edi: f5fc9f78   ebp: f5fc9ef8   esp: f5fc9ee0
ds: 0018   es: 0018   ss: 0018
Process scsi_eh_0 (pid: 6220, stackpage=f5fc9000)
Stack: 00000292 f5fc9f64 f5fc9f78 f5fc9f68 00000282 00000003 f5fc9f28 f88ce7f6 
       f3907200 00000000 00000000 00000000 f88bc180 f3907200 f5fc9f64 f88bbfdd 
       f390726c f3907200 f3907200 f88bc677 f3907200 f88bc180 f3907200 f5fc9fac 
Call Trace:    [<f88ce7f6>] [<f88bc180>] [<f88bbfdd>] [<f88bc677>] [<f88bc180>]
  [<f88bc296>] [<f88bce29>] [<f88bd3b6>] [<c0106ec8>]

Code: 0f b6 50 1b 8b 14 95 3c 64 2a c0 2b 82 a0 00 00 00 69 c0 a3 
 

With Linux version 2.4.20. When "cardctl eject".

aha152x: processing commandline: ok
aha152x: BIOS test: passed, detected 1 controller(s)
aha152x: resetting bus...
aha152x0: vital data: rev=1, io=0x340 (0x340/0x340), irq=3, scsiid=7, reconnect=enabled, parity=enabled, synchronous=disabled, delay=100, extended translation=disabled
aha152x0: trying software interrupt, ok.
scsi0 : Adaptec 152x SCSI driver; $Revision: 2.5 $
  Vendor: IOMEGA    Model: ZIP 100           Rev: J.02
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi removable disk sda at scsi0, channel 0, id 5, lun 0
SCSI device sda: 196608 512-byte hdwr sectors (101 MB)
sda: Write Protect is off
 sda: sda1
scsi : 0 hosts left.
Trying to free nonexistent resource <00000340-0000035f>


With Linux version 2.4.20. When phisically eject.
I could not get any message because of system freeze.


[6.] A small shell script or example program which triggers the problem (if possible)

None.

[7.] Environment

IBM ThinkPad X30.
Following data is with kernel 2.4.20, inserted Adaptec PCMCIA card.

[7.1.] Software (add the output of the ver_linux script here)
linux-2.4.20,  pcmcia-cs-3.2.0.

# . ver_linux 
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux guppy 2.4.20 #5 2002年12月25日 (水) 19:31:56 JST i686 unknown
 
Gnu C                  2.95.3
Gnu make               3.79.1
util-linux             2.11a
mount                  2.11a
modutils               2.4.19
e2fsprogs              1.28
reiserfsprogs          3.x.1b
pcmcia-cs              3.2.0
PPP                    2.4.1
Linux C Library        2.5.so*
Dynamic linker (ldd)   2.2.5
Procps                 2.0.7
Net-tools              1.54
Kbd                    1.04
Sh-utils               2.0
Modules Loaded         ds i82365 pcmcia_core

[7.2.] Processor information (from /proc/cpuinfo):
a# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Mobile Intel(R) Pentium(R) III CPU - M  1200MHz
stepping        : 4
cpu MHz         : 1196.032
cache size      : 32 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 2385.51


[7.3.] Module information (from /proc/modules):
# cat /proc/modules
sd_mod                  9964   0 (autoclean)
aha152x_cs             32002   0
scsi_mod               82536   2 [sd_mod aha152x_cs]
ds                      6632   2 [aha152x_cs]
i82365                 22512   2
pcmcia_core            43040   0 [aha152x_cs ds i82365]

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
a# cat /proc/ioports
0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : Intel Corp. 82801CAM IDE U100
01f0-01f7 : Intel Corp. 82801CAM IDE U100
  01f0-01f7 : ide0
0340-035f : aha152x
0376-0376 : Intel Corp. 82801CAM IDE U100
03c0-03df : vga+
03f6-03f6 : Intel Corp. 82801CAM IDE U100
  03f6-03f6 : ide0
0cf8-0cff : PCI conf1
1800-181f : Intel Corp. 82801CA/CAM USB (Hub #1)
  1800-181f : usb-uhci
1820-183f : Intel Corp. 82801CA/CAM USB (Hub #2)
  1820-183f : usb-uhci
1840-185f : Intel Corp. 82801CA/CAM USB (Hub #3)
  1840-185f : usb-uhci
1860-186f : Intel Corp. 82801CAM IDE U100
  1860-1867 : ide0
  1868-186f : ide1
1880-189f : Intel Corp. 82801CA/CAM SMBus
18c0-18ff : Intel Corp. 82801CA/CAM AC'97 Audio
1c00-1cff : Intel Corp. 82801CA/CAM AC'97 Audio
2000-207f : Intel Corp. 82801CA/CAM AC'97 Modem
2400-24ff : Intel Corp. 82801CA/CAM AC'97 Modem
7000-703f : Intel Corp. 82801CAM (ICH3) PRO/100 VE (LOM) Ethernet Controller
  7000-703f : eepro100

a# cat /proc/iomem
00000000-0009efff : System RAM
0009f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000ce000-000cefff : Extension ROM
000cf000-000cffff : Extension ROM
000dc000-000dffff : pnp 0d
000e0000-000effff : Extension ROM
000f0000-000fffff : System ROM
00100000-3f75ffff : System RAM
  00100000-0021c06f : Kernel code
  0021c070-00296a63 : Kernel data
3f760000-3f779fff : ACPI Tables
3f77a000-3f77bfff : ACPI Non-volatile Storage
3f77c000-3fffffff : reserved
40000000-400003ff : Intel Corp. 82801CAM IDE U100
50000000-50000fff : Ricoh Co Ltd RL5c476 II
  50000000-50000fff : i82365
50100000-50100fff : Ricoh Co Ltd RL5c476 II (#2)
  50100000-50100fff : i82365
a0000000-a0000fff : card services
d0000000-d007ffff : Intel Corp. 82830 CGC [Chipset Graphics Controller]
d0080000-d00fffff : Intel Corp. 82830 CGC [Chipset Graphics Controller] (#2)
d0200000-d0200fff : Intel Corp. 82801CAM (ICH3) PRO/100 VE (LOM) Ethernet Controller
  d0200000-d0200fff : eepro100
d0201000-d02017ff : Ricoh Co Ltd R5C552 IEEE 1394 Controller
e0000000-e7ffffff : Intel Corp. 82830 CGC [Chipset Graphics Controller]
e8000000-efffffff : Intel Corp. 82830 CGC [Chipset Graphics Controller] (#2)
ff000000-ff07ffff : pnp 0c
ff800000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corp. 82830 830 Chipset Host Bridge (rev 04)
	Subsystem: IBM: Unknown device 021d
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at <unassigned> (32-bit, prefetchable)
	Capabilities: [40] #09 [2105]

00:02.0 VGA compatible controller: Intel Corp. 82830 CGC [Chipset Graphics Controller] (rev 04) (prog-if 00 [VGA])
	Subsystem: IBM: Unknown device 0513
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corp. 82830 CGC [Chipset Graphics Controller]
	Subsystem: IBM: Unknown device 0513
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at d0080000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corp. 82801CA/CAM USB (Hub #1) (rev 02) (prog-if 00 [UHCI])
	Subsystem: IBM: Unknown device 0220
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 4: I/O ports at 1800 [size=32]

00:1d.1 USB Controller: Intel Corp. 82801CA/CAM USB (Hub #2) (rev 02) (prog-if 00 [UHCI])
	Subsystem: IBM: Unknown device 0220
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at 1820 [size=32]

00:1d.2 USB Controller: Intel Corp. 82801CA/CAM USB (Hub #3) (rev 02) (prog-if 00 [UHCI])
	Subsystem: IBM: Unknown device 0220
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 4: I/O ports at 1840 [size=32]

00:1e.0 PCI bridge: Intel Corp. 82801BAM/CAM PCI Bridge (rev 42) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=07, sec-latency=64
	I/O behind bridge: 00003000-00007fff
	Memory behind bridge: d0200000-dfffffff
	Prefetchable memory behind bridge: f0000000-f7ffffff
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corp. 82801CAM ISA Bridge (LPC) (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corp. 82801CAM IDE U100 (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: IBM: Unknown device 0220
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374
	Region 4: I/O ports at 1860 [size=16]
	Region 5: Memory at 40000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corp. 82801CA/CAM SMBus (rev 02)
	Subsystem: IBM: Unknown device 0220
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at 1880 [size=32]

00:1f.5 Multimedia audio controller: Intel Corp. 82801CA/CAM AC'97 Audio (rev 02)
	Subsystem: IBM: Unknown device 051c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 0: I/O ports at 1c00 [size=256]
	Region 1: I/O ports at 18c0 [size=64]

00:1f.6 Modem: Intel Corp. 82801CA/CAM AC'97 Modem (rev 02) (prog-if 00 [Generic])
	Subsystem: IBM: Unknown device 0223
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 0: I/O ports at 2400 [size=256]
	Region 1: I/O ports at 2000 [size=128]

01:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev a8)
	Subsystem: IBM: Unknown device 0185
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 50000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=02, subordinate=04, sec-latency=176
	Memory window 0: 00000000-00000000 (prefetchable)
	Memory window 1: 00000000-00000000 (prefetchable)
	I/O window 0: 00000000-00000003
	I/O window 1: 00000000-00000003
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

01:00.1 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev a8)
	Subsystem: IBM: Unknown device 0185
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at 50100000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=05, subordinate=07, sec-latency=176
	Memory window 0: 00000000-00000000 (prefetchable)
	Memory window 1: 00000000-00000000 (prefetchable)
	I/O window 0: 00000000-00000003
	I/O window 1: 00000000-00000003
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

01:00.2 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (prog-if 10 [OHCI])
	Subsystem: IBM: Unknown device 0511
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at d0201000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

01:08.0 Ethernet controller: Intel Corp. 82801CAM (ICH3) Chipset Ethernet Controller (rev 42)
	Subsystem: IBM EtherExpress PRO/100 VE
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 66 (2000ns min, 14000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d0200000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at 7000 [size=64]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

[7.6.] SCSI information (from /proc/scsi/scsi)
# cat /proc/scsi/scsi
Attached devices: 
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: IOMEGA   Model: ZIP 100          Rev: J.02
  Type:   Direct-Access                    ANSI SCSI revision: 02

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you think to be relevant):

# scsi_info /dev/sda
SCSI_ID="0,5,0"
MODEL="IOMEGA ZIP 100"
FW_REV="J.02"

# cardmgr -V
cardmgr version 3.2.0

# cardctl -V
cardctl version 3.2.0

# cardctl status
Socket 0:
  5V 16-bit PC Card
  function 0: [ready]
Socket 1:
  no card

# cardctl config
Socket 0:
  Vcc 5.0V  Vpp1 0.0V  Vpp2 0.0V
  interface type is "memory and I/O"
  irq 3 [exclusive] [level]
  function 0:
    config base 0x2000
      option 0x49
    io 0x0340-0x035f [auto]
Socket 1:
  not configured

# cardctl ident
Socket 0:
  product info: "Adaptec, Inc.", "APA-1460 SCSI Host Adapter", "Version 0.01"
  manfid: 0x012f, 0x0002
Socket 1:
  no product info available

[X.] Other notes, patches, fixes, workarounds:

--
Kouji KODAMA, kdm@kobe-kosen.ac.jp
