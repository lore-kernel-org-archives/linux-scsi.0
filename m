From: Joachim Feise <jfeise@ics.uci.edu>
Subject: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Thu, 19 Feb 2004 11:47:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403512B8.2060403@ics.uci.edu>
Reply-To: jfeise@ics.uci.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scanner2.ics.uci.edu ([128.195.1.36]:14027 "EHLO
	scanner2.ics.uci.edu") by vger.kernel.org with ESMTP
	id S267515AbUBSTsr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 14:48:47 -0500
Received: from ics.uci.edu (pv105234.reshsg.uci.edu [128.195.105.234])
	by scanner2.ics.uci.edu (8.12.10/8.12.10) with ESMTP id i1JJl7P3016845
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2004 11:47:07 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[1.] One line summary of the problem:
2.6.3 hangs when writing to scsi-dvd

[2.] Full description of the problem/report:

I have a DVD drive (BTC1004) connected via an IDE-SCSI bridge to
an Adaptec 29160 host adapter.
With kernel 2.6.3, I experience a complete system hang whenever I try
to record data on a DVD.
It requires a reboot.

[3.] Keywords (i.e., modules, networking, kernel):
SCSI

[4.] Kernel version (from /proc/version):
Linux version 2.6.3 (root@pv105234) (gcc version 3.2.2) #1 Wed Feb 18 04:26:46 PST 2004

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
None.

[6.] A small shell script or example program which triggers the
     problem (if possible)
growisofs -Z /dev/sr1 -R -J tmpdir/files
Where /dev/sr1 is the DVD device

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
Linux pv105234 2.6.3 #1 Wed Feb 18 04:26:46 PST 2004 i686 unknown

Gnu C                  3.2.2
Gnu make               3.80
util-linux             2.11z
mount                  2.11z
module-init-tools      0.9.13
e2fsprogs              1.32
jfsutils               1.1.1
reiserfsprogs          3.6.4
xfsprogs               2.3.5
pcmcia-cs              3.2.4
quota-tools            3.08.
PPP                    2.4.2
nfs-utils              1.0.1
Linux C Library        2.3.1
Dynamic linker (ldd)   2.3.1
Linux C++ Library      5.0.2
Procps                 3.1.6
Net-tools              1.60
Kbd                    1.08
Sh-utils               2.0
Modules Loaded         snd_seq_midi snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss
softdog ipv6 ohci_hcd ehci_hcd snd_cs46xx snd_rawmidi snd_seq_device snd_ac97_codec snd_pcm
snd_timer snd soundcore gameport snd_page_alloc i2c_core ide_scsi ppp_mppe ppp_deflate ppp_generic
slhc usb_storage

[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 6
model name      : Celeron (Mendocino)
stepping        : 0
cpu MHz         : 334.143
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr
bogomips        : 659.45

[7.3.] Module information (from /proc/modules):
snd_seq_midi 8384 0 - Live 0xd3d83000
snd_seq_oss 35104 0 - Live 0xd3dea000
snd_seq_midi_event 7744 2 snd_seq_midi,snd_seq_oss, Live 0xd3cec000
snd_seq 56592 5 snd_seq_midi,snd_seq_oss,snd_seq_midi_event, Live 0xd3dbe000
snd_pcm_oss 54564 1 - Live 0xd3dcf000
snd_mixer_oss 20096 2 snd_pcm_oss, Live 0xd3d7d000
softdog 4808 1 - Live 0xd3d35000
ipv6 258272 14 - Live 0xd3e08000
ohci_hcd 19328 0 - Live 0xd3d3c000
ehci_hcd 25888 0 - Live 0xd3d6e000
snd_cs46xx 90956 2 - Live 0xd3d88000
snd_rawmidi 25216 2 snd_seq_midi,snd_cs46xx, Live 0xd3d25000
snd_seq_device 8068 4 snd_seq_midi,snd_seq_oss,snd_seq,snd_rawmidi, Live 0xd3ce6000
snd_ac97_codec 63588 1 snd_cs46xx, Live 0xd3d5d000
snd_pcm 101856 2 snd_pcm_oss,snd_cs46xx, Live 0xd3d43000
snd_timer 26272 2 snd_seq,snd_pcm, Live 0xd3d0d000
snd 55492 12
snd_seq_midi,snd_seq_oss,snd_seq_midi_event,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_cs46xx,snd_rawmidi,snd_seq_device,snd_ac97_codec,snd_pcm,snd_timer,
Live 0xd3d16000
soundcore 10176 3 snd, Live 0xd3d00000
gameport 4736 1 snd_cs46xx, Live 0xd3ce9000
snd_page_alloc 12228 2 snd_cs46xx,snd_pcm, Live 0xd3cf7000
i2c_core 23488 0 - Live 0xd3cdf000
ide_scsi 15268 0 - Live 0xd3cda000
ppp_mppe 14304 0 - Live 0xd3cd5000
ppp_deflate 6144 0 - Live 0xd3cc1000
ppp_generic 31528 2 ppp_mppe,ppp_deflate, Live 0xd3ccc000
slhc 7296 1 ppp_generic, Live 0xd3cbe000
usb_storage 68064 0 - Live 0xd3b56000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
cat /proc/ioports
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000cb000-000d3fff : Extension ROM
000f0000-000fffff : System ROM
00100000-11ffffff : System RAM
  00100000-003c88f2 : Kernel code
  003c88f3-004db8ff : Kernel data
c056f000-c096f000 : Bigphysarea
c7900000-cf9fffff : PCI Bus #01
  c8000000-cbffffff : 0000:01:00.0
    c8000000-c8ffffff : vesafb
d0000000-d3ffffff : 0000:00:00.0
d7b00000-efcfffff : PCI Bus #01
  e0000000-e3ffffff : 0000:01:00.0
  e4000000-e7ffffff : 0000:01:00.0
  e8000000-ebffffff : 0000:01:00.0
  efc80000-efcfffff : 0000:01:00.0
efe00000-efefffff : 0000:00:09.0
  efe00000-efe02fff : CS46xx_BA1_data0
  efe10000-efe137ff : CS46xx_BA1_data1
  efe20000-efe26fff : CS46xx_BA1_pmem
  efe30000-efe300ff : CS46xx_BA1_reg
efffc000-efffcfff : 0000:00:09.0
  efffc000-efffcfff : CS46xx_BA0
efffee00-efffeeff : 0000:00:0d.0
  efffee00-efffeeff : 8139too
efffef00-efffefff : 0000:00:0f.0
  efffef00-efffefff : 8139too
effff000-efffffff : 0000:00:11.0
  effff000-efffffff : aic7xxx
ffff0000-ffffffff : reserved

 cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000cb000-000d3fff : Extension ROM
000f0000-000fffff : System ROM
00100000-11ffffff : System RAM
  00100000-003c88f2 : Kernel code
  003c88f3-004db8ff : Kernel data
c056f000-c096f000 : Bigphysarea
c7900000-cf9fffff : PCI Bus #01
  c8000000-cbffffff : 0000:01:00.0
    c8000000-c8ffffff : vesafb
d0000000-d3ffffff : 0000:00:00.0
d7b00000-efcfffff : PCI Bus #01
  e0000000-e3ffffff : 0000:01:00.0
  e4000000-e7ffffff : 0000:01:00.0
  e8000000-ebffffff : 0000:01:00.0
  efc80000-efcfffff : 0000:01:00.0
efe00000-efefffff : 0000:00:09.0
  efe00000-efe02fff : CS46xx_BA1_data0
  efe10000-efe137ff : CS46xx_BA1_data1
  efe20000-efe26fff : CS46xx_BA1_pmem
  efe30000-efe300ff : CS46xx_BA1_reg
efffc000-efffcfff : 0000:00:09.0
  efffc000-efffcfff : CS46xx_BA0
efffee00-efffeeff : 0000:00:0d.0
  efffee00-efffeeff : 8139too
efffef00-efffefff : 0000:00:0f.0
  efffef00-efffefff : 8139too
effff000-efffffff : 0000:00:11.0
  effff000-efffffff : aic7xxx
ffff0000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corp. 440LX/EX - 82443LX/EX Host bridge (rev 03)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR+
	Latency: 64
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 1.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

00:01.0 PCI bridge: Intel Corp. 440LX/EX - 82443LX/EX AGP bridge (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: d7b00000-efcfffff
	Prefetchable memory behind bridge: c7900000-cf9fffff
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:07.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 4: I/O ports at ffa0 [size=16]

00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at d800 [size=32]

00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 02)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin ? routed to IRQ 9

00:09.0 Multimedia audio controller: Cirrus Logic CS 4614/22/24 [CrystalClear SoundFusion Audio
Accelerator] (rev 01)
	Subsystem: Voyetra Technologies: Unknown device 3357
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (1000ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at efffc000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at efe00000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: D-Link System Inc DFE-538TX
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at da00 [size=256]
	Region 1: Memory at efffee00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.0 Ethernet controller: D-Link System Inc RTL8139 Ethernet (rev 10)
	Subsystem: D-Link System Inc DFE-530TX+ 10/100 Ethernet Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at dc00 [size=256]
	Region 1: Memory at efffef00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
	Subsystem: Adaptec 29160 Ultra160 SCSI Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (10000ns min, 6250ns max), cache line size 08
	Interrupt: pin A routed to IRQ 9
	BIST result: 00
	Region 0: I/O ports at de00 [disabled] [size=256]
	Region 1: Memory at effff000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at effc0000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:13.0 Class 6120: Unknown device 0002:0400 (rev de) (prog-if 11)
	Subsystem: Unknown device 0008:0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Interrupt: pin A routed to IRQ 0
	Region 2: Memory at <unassigned> (32-bit, prefetchable) [disabled]
	Region 3: Memory at <unassigned> (32-bit, prefetchable) [disabled]

01:00.0 VGA compatible controller: S3 Inc. 86C410 Savage 2000 (rev 02) (prog-if 00 [VGA])
	Subsystem: S3 Inc. 86C410 Savage 2000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 248 (3000ns min, 4000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at efc80000 (32-bit, non-prefetchable) [size=512K]
	Region 1: Memory at c8000000 (32-bit, prefetchable) [size=64M]
	Region 2: Memory at e8000000 (32-bit, non-prefetchable) [size=64M]
	Region 3: Memory at e4000000 (32-bit, non-prefetchable) [size=64M]
	Region 4: Memory at e0000000 (32-bit, non-prefetchable) [size=64M]
	Expansion ROM at efc70000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_36_WLS Rev: 020W
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: YAMAHA   Model: CRW-F1S          Rev: 1.0c
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: DVDRW    Model: IDE1004          Rev: 0048
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: NAKAMICH Model: MJ-5.16S         Rev: 1.06
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 01
  Vendor: NAKAMICH Model: MJ-5.16S         Rev: 1.06
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 02
  Vendor: NAKAMICH Model: MJ-5.16S         Rev: 1.06
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 03
  Vendor: NAKAMICH Model: MJ-5.16S         Rev: 1.06
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 04
  Vendor: NAKAMICH Model: MJ-5.16S         Rev: 1.06
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor:          Model: USB DISK         Rev: 1.17
  Type:   Direct-Access                    ANSI SCSI revision: 02

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:
It worked fine with 2.6.2.

