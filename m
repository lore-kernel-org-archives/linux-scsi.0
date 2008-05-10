From: Frank de Jong <frapex@xs4all.nl>
Subject: PROBLEM: linux-2.6.25.3, aha152x'->init suspiciously returned
  1, it should follow 0/-E convention
Date: Sat, 10 May 2008 12:30:17 +0200
Message-ID: <20080510103040.C7E891D652BF@mx.drokz.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3375 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYEJKkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 May 2008 06:40:04 -0400
Received: from mx.drokz.nl (drokz.nl [80.101.76.176])
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id m4AAWZMc078239
	for <linux-scsi@vger.kernel.org>; Sat, 10 May 2008 12:32:36 +0200 (CEST)
	(envelope-from frapex@xs4all.nl)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Juergen Fischer <fischer@norbit.de>

Hello,

Bug report follows.

[1.] One line summary of the problem:
linux-2.6.25.3, aha152x'->init suspiciously returned 1, it should 
follow 0/-E convention. The module / driver works okay. Unloading the 
module is impossible.

[2.] Full description of the problem/report:
When loading the aha152x module using modprobe aha152x, the following 
messages are being displayed (taken from dmesg):
aha152x: BIOS test: passed, 1 controller(s) configured
aha152x: resetting bus...
aha152x2: vital data: rev=1, io=0x340 (0x340/0x340), irq=9, scsiid=7, 
reconnect=enabled, parity=enabled, synchronous=enabled, delay=1000, 
extended translation=disabled
aha152x2: trying software interrupt, ok.
scsi2 : Adaptec 152x SCSI driver; $Revision: 2.7 $
(scsi2:6:0) message sent incompletely (2/6)
(scsi2:6:0) Synchronous Data Transfer Request was rejected
(scsi2:6:0) inbound message (MESSAGE REJECT)
scsi 2:0:6:0: Direct-Access     IOMEGA   ZIP 100          J.02 PQ: 0 ANSI: 2
sd 2:0:6:0: [sde] Attached SCSI removable disk
sd 2:0:6:0: Attached scsi generic sg4 type 0
sys_init_module: 'aha152x'->init suspiciously returned 1, it should 
follow 0/-E convention
sys_init_module: loading module anyway...
Pid: 2831, comm: modprobe Not tainted 2.6.25.3 #3
  [<c013fe51>] sys_init_module+0x1d1/0x1c10
  [<c0124b80>] __request_region+0x0/0x80
  [<c016a471>] sys_read+0x41/0x70
  [<c0102faa>] sysenter_past_esp+0x5f/0x85
  =======================

The module / driver works okay. Unloading the module is impossible.

[3.] Keywords (i.e., modules, networking, kernel):
aha152x, scsi, driver, linux-2.6.25.3

[4.] Kernel version (from /proc/version):
Linux version 2.6.25.3 (root@helium) (gcc version 4.2.1) #3 SMP 
PREEMPT Sat May 10 11:18:12 CEST 2008

[5.] Output of Oops.. message (if applicable) with symbolic 
information resolved (see Documentation/oops-tracing.txt)
N/A

[6.] A small shell script or example program which triggers the 
problem (if possible)
N/A (modprobe aha152x)

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here). If 
some fields are empty or look unusual you may have an old version. 
Compare to the current minimal requirements in Documentation/Changes.

Linux helium 2.6.25.3 #3 SMP PREEMPT Sat May 10 11:18:12 CEST 2008 
i686 pentium2 i386 GNU/Linux

Gnu C                  4.2.1
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.40.2
xfsprogs               2.9.3
PPP                    2.4.4
Linux C Library        2.6
Dynamic linker (ldd)   2.6
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   116
Modules Loaded         aha152x w83781d hwmon_vid tun ne 8390 bonding 
usb_storage 3c59x snd_usb_audio mii pwc compat_ioctl32 snd_usb_lib 
videodev v4l1_compat snd_rawmidi snd_seq_device snd_hwdep intel_agp 
agpgart snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd

[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 5
model name      : Pentium II (Deschutes)
stepping        : 1
cpu MHz         : 350.802
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr 
pge mca cmov pat pse36 mmx fxsr
bogomips        : 702.77
clflush size    : 32

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 5
model name      : Pentium II (Deschutes)
stepping        : 2
cpu MHz         : 350.802
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr 
pge mca cmov pat pse36 mmx fxsr
bogomips        : 701.68
clflush size    : 32

[7.3.] Module information (from /proc/modules):
aha152x 39376 0 - Live 0xfba2e000
w83781d 31272 0 - Live 0xfba25000
hwmon_vid 3360 1 w83781d, Live 0xf887e000
tun 11904 1 - Live 0xfb9f6000
ne 8676 0 - Live 0xfb9f2000
8390 10432 1 ne, Live 0xfb951000
bonding 89796 0 - Live 0xfba0e000
usb_storage 40352 1 - Live 0xfb946000
3c59x 43848 0 - Live 0xfb956000
snd_usb_audio 82912 0 - Live 0xfb916000
mii 5728 1 3c59x, Live 0xf98ef000
pwc 86464 0 - Live 0xfb92f000
compat_ioctl32 1440 1 pwc, Live 0xf98ab000
snd_usb_lib 17632 1 snd_usb_audio, Live 0xfb901000
videodev 34208 1 pwc, Live 0xfb90c000
v4l1_compat 14436 1 videodev, Live 0xf98a2000
snd_rawmidi 24896 1 snd_usb_lib, Live 0xf98f5000
snd_seq_device 8396 1 snd_rawmidi, Live 0xf98e8000
snd_hwdep 9700 1 snd_usb_audio, Live 0xf98a7000
intel_agp 26812 1 - Live 0xf98db000
agpgart 34504 1 intel_agp, Live 0xf98ae000
snd_pcm_oss 41888 0 - Live 0xf98cf000
snd_pcm 77988 2 snd_usb_audio,snd_pcm_oss, Live 0xf98ba000
snd_timer 24168 1 snd_pcm, Live 0xf9881000
snd_page_alloc 10600 1 snd_pcm, Live 0xf988e000
snd_mixer_oss 17120 1 snd_pcm_oss, Live 0xf9888000
snd 54692 8 
snd_usb_audio,snd_rawmidi,snd_seq_device,snd_hwdep,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss, 
Live 0xf9893000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
/proc/ioports:
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
0170-0177 : 0000:00:07.1
01f0-01f7 : 0000:00:07.1
   01f0-01f7 : ide0
0213-0213 : ISAPnP
0220-023f : ne
0290-0297 : w83781d
   0295-0296 : w83781d
02f8-02ff : serial
0340-035f : aha152x
0376-0376 : 0000:00:07.1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:07.1
   03f6-03f6 : ide0
03f7-03f7 : floppy DIR
03f8-03ff : serial
0778-077a : parport0
0a79-0a79 : isapnp write
0cf8-0cff : PCI conf1
4000-403f : 0000:00:07.3
5000-500f : 0000:00:07.3
c000-c01f : 0000:00:07.2
   c000-c01f : uhci_hcd
c400-c4ff : 0000:00:0b.0
c800-c87f : 0000:00:11.0
cc00-cc7f : 0000:00:12.0
d000-d007 : 0000:00:13.0
   d000-d007 : ide2
d400-d403 : 0000:00:13.0
   d402-d402 : ide2
d800-d807 : 0000:00:13.0
   d800-d807 : ide3
dc00-dc03 : 0000:00:13.0
   dc02-dc02 : ide3
e000-e00f : 0000:00:13.0
   e000-e007 : ide2
   e008-e00f : ide3
f000-f00f : 0000:00:07.1
   f000-f007 : ide0
   f008-f00f : ide1

00000000-0009ffff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000cbbff : Video ROM
000cc000-000d17ff : Adapter ROM
000d2000-000d27ff : Adapter ROM
000d3000-000d37ff : Adapter ROM
000d4000-000d67ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-37ffffff : System RAM
   00100000-0049de85 : Kernel code
   0049de86-005b3b1f : Kernel data
   005fb000-00632b2f : Kernel bss
d0000000-d7ffffff : PCI Bus #01
   d0000000-d7ffffff : 0000:01:00.0
     d0000000-d7ffffff : rivafb
d8000000-dbffffff : 0000:00:00.0
dc000000-ddffffff : PCI Bus #01
   dc000000-dcffffff : 0000:01:00.0
     dc000000-dcffffff : rivafb
df000000-df003fff : 0000:00:13.0
df004000-df00407f : 0000:00:11.0
df005000-df00507f : 0000:00:12.0
df006000-df006fff : 0000:00:0b.0
   df006000-df006fff : aic7xxx
df007000-df007fff : 0000:00:14.0
   df007000-df007fff : ohci_hcd
df008000-df008fff : 0000:00:14.1
   df008000-df008fff : ohci_hcd
df009000-df0090ff : 0000:00:14.2
   df009000-df0090ff : ehci_hcd
fec00000-fec00fff : reserved
fee00000-fee00fff : reserved
ffff0000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX 
Host bridge (rev 03)
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
         Latency: 32
         Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
         Capabilities: [a0] AGP version 1.0
                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- 
GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- 
FW- Rate=<none>

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP 
bridge (rev 03) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: dc000000-ddffffff
         Prefetchable memory behind bridge: d0000000-d7ffffff
         Secondary status: 66MHz+ FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B+

00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 
01) (prog-if 80 [Master])
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32
         Region 0: [virtual] Memory at 000001f0 (32-bit, 
non-prefetchable) [disabled] [size=8]
         Region 1: [virtual] Memory at 000003f0 (type 3, 
non-prefetchable) [disabled] [size=1]
         Region 2: [virtual] Memory at 00000170 (32-bit, 
non-prefetchable) [disabled] [size=8]
         Region 3: [virtual] Memory at 00000370 (type 3, 
non-prefetchable) [disabled] [size=1]
         Region 4: I/O ports at f000 [size=16]

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB 
(rev 01) (prog-if 00 [UHCI])
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32
         Interrupt: pin D routed to IRQ 19
         Region 4: I/O ports at c000 [size=32]

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin ? routed to IRQ 9

00:0b.0 SCSI storage controller: Adaptec AIC-7880U (rev 01)
         Subsystem: Adaptec AIC-7880P Ultra/Ultra Wide SCSI Chipset
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (2000ns min, 2000ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: I/O ports at c400 [disabled] [size=256]
         Region 1: Memory at df006000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 74)
         Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink 
for PC Management NIC
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (2500ns min, 2500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 18
         Region 0: I/O ports at c800 [size=128]
         Region 1: Memory at df004000 (32-bit, non-prefetchable) [size=128]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:12.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 74)
         Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink 
for PC Management NIC
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (2500ns min, 2500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 17
         Region 0: I/O ports at cc00 [size=128]
         Region 1: Memory at df005000 (32-bit, non-prefetchable) [size=128]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:13.0 Mass storage controller: Promise Technology, Inc. PDC20268 
(Ultra100 TX2) (rev 02) (prog-if 85)
         Subsystem: Promise Technology, Inc. Ultra100TX2
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- 
DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (1000ns min, 4500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: I/O ports at d000 [size=8]
         Region 1: I/O ports at d400 [size=4]
         Region 2: I/O ports at d800 [size=8]
         Region 3: I/O ports at dc00 [size=4]
         Region 4: I/O ports at e000 [size=16]
         Region 5: Memory at df000000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [60] Power Management version 1
                 Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:14.0 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
         Subsystem: Belkin Root Hub
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (250ns min, 10500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 19
         Region 0: Memory at df007000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:14.1 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
         Subsystem: Belkin Root Hub
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (250ns min, 10500ns max), Cache Line Size: 32 bytes
         Interrupt: pin B routed to IRQ 16
         Region 0: Memory at df008000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:14.2 USB Controller: NEC Corporation USB 2.0 (rev 02) (prog-if 20 [EHCI])
         Subsystem: Belkin Root Hub
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (4000ns min, 8500ns max), Cache Line Size: 32 bytes
         Interrupt: pin C routed to IRQ 17
         Region 0: Memory at df009000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: nVidia Corporation NV11GL [Quadro2 
MXR/EX/Go] (rev a1) (prog-if 00 [VGA])
         Subsystem: Guillemot Corporation Unknown device 7100
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- 
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (1250ns min, 250ns max)
         Interrupt: pin A routed to IRQ 0
         Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [44] AGP version 2.0
                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh- 
GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- 
FW- Rate=<none>

[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: SEAGATE  Model: SX318203LC       Rev: B902
   Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 00
   Vendor: IBM-PCCO Model: ST118202LC    !# Rev: B219
   Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 03 Lun: 00
   Vendor: IBM-PCCO Model: ST118202LC    !# Rev: B219
   Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: Maxtor 6 Model: L300R0           Rev: BAJ4
   Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi2 Channel: 00 Id: 06 Lun: 00
   Vendor: IOMEGA   Model: ZIP 100          Rev: J.02
   Type:   Direct-Access                    ANSI  SCSI revision: 02

[7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):
/proc/scsi/aha152x/2:
Adaptec 152x SCSI driver; $Revision: 2.7 $
ioports 0x0340 to 0x035f
interrupt 0x09
disconnection/reconnection enabled
parity checking enabled
synchronous transfers enabled
0 commands currently queued
synchronously operating targets (tick=50 ns):

queue status:
no not yet issued commands
no current command
no disconnected commands

waiting: busfree(msgi) SCSISEQ( ); SCSISIG(DATA OUT); INTSTAT (lo); 
SSTAT( BUSFREE PHASECHG ); SSTAT( ); SXFRCTL0( CH1 ); SIGNAL( ); 
SELID(c0), STCNT(0), SSTAT2( SEMPTY ); SFCNT (0); SCSICNT (0), 
OFFCNT(0), SSTAT4( ); DMACNTRL0( 16BIT PIO READ INTEN ); DMASTAT( DFIFOEMP )
enabled interrupts( )
statistics:
total commands:               826
disconnections:               758
busfree with check condition: 25
busfree without old command:  806
busfree without new command:  1558
busfree without done command: 1558
busfree without any action:   0
state      transitions  count        time
idle       0            0            0
unknown    0            0            0
seldo      820          820          2

[X.] Other notes, patches, fixes, workarounds:
problem does not occur with linux-2.6.24.

Regards,
Frank de Jong
The Netherlands

