From: Matthew Mueller <donut@azstarnet.com>
Subject: PROBLEM: scsi cdrom panic when eject button hit during i/o errors
Date: Mon, 5 Aug 2002 00:54:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020805075438.GA761@charon.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.lan (mail@dhcp980.mc01.dsl.fastucson.net [169.197.11.212])
	by cepheus.azstarnet.com (8.9.3/8.9.3) with ESMTP id AAA14508
	for <linux-scsi@vger.kernel.org>; Mon, 5 Aug 2002 00:54:37 -0700 (MST)
Received: from donut by charon.lan with local (Exim 3.22 #1 (Debian))
	id 17bchK-0000DC-00
	for <linux-scsi@vger.kernel.org>; Mon, 05 Aug 2002 00:54:38 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 [1.] One line summary of the problem:
scsi cdrom caused kernel panic when eject button hit during i/o errors

 [2.] Full description of the problem/report:
I was testing a cdr I had just burned, and started getting a bunch of
I/O errors.  I was testing it in my teac scsi 32x cdrom drive.

Aug  4 23:42:11 charon kernel: sr0: scsi3-mmc drive: 0x/0x caddy
Aug  4 23:42:11 charon kernel: Uniform CD-ROM driver Revision: 3.12
Aug  4 23:42:11 charon kernel: sr1: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Aug  4 23:42:57 charon kernel: SCSI cdrom error : host 0 channel 0 id 1 lun 0 return code = 28000002
Aug  4 23:42:57 charon kernel: Current sd0b:00: sense key Hardware Error
Aug  4 23:42:57 charon kernel: Additional sense indicates Track following error
Aug  4 23:42:57 charon kernel:  I/O error: dev 0b:00, sector 930688
Aug  4 23:43:01 charon kernel: scsi : aborting command due to timeout : pid 11741, scsi0, channel 0, id 1, lun 0 Read (10) 00 00 03
8d 00 00 00 20 00
Aug  4 23:43:01 charon kernel: scsi0: Aborting CCB #47 to Target 1
Aug  4 23:43:01 charon kernel: scsi : aborting command due to timeout : pid 11742, scsi0, channel 0, id 1, lun 0 Read (10) 00 00 03
8d 20 00 00 20 00
Aug  4 23:43:01 charon kernel: scsi0: Aborting CCB #48 to Target 1
Aug  4 23:43:01 charon kernel: scsi0: CCB #47 to Target 1 Aborted
Aug  4 23:43:01 charon kernel: scsi0: CCB #48 to Target 1 Aborted
Aug  4 23:43:03 charon kernel: scsi0 channel 0 : resetting for second half of retries.
Aug  4 23:43:03 charon kernel: SCSI bus is being reset for host 0 channel 0.
Aug  4 23:43:03 charon kernel: scsi0: Sending Bus Device Reset CCB #52 to Target 1
Aug  4 23:43:03 charon kernel: scsi0: Bus Device Reset CCB #52 to Target 1 Completed
Aug  4 23:43:05 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8d 00 00 00 20 00
Aug  4 23:43:05 charon kernel: Info fld=0x38d00, Current sd0b:00: sense key Medium Error
Aug  4 23:43:05 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:05 charon kernel:  I/O error: dev 0b:00, sector 930816
Aug  4 23:43:08 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8d 20 00 00 20 00
Aug  4 23:43:08 charon kernel: Info fld=0x38d20, Current sd0b:00: sense key Medium Error
Aug  4 23:43:08 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:08 charon kernel:  I/O error: dev 0b:00, sector 930944
Aug  4 23:43:12 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8c e1 00 00 1f 00
Aug  4 23:43:12 charon kernel: Info fld=0x38ce1, Current sd0b:00: sense key Medium Error
Aug  4 23:43:12 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:12 charon kernel:  I/O error: dev 0b:00, sector 930692
Aug  4 23:43:14 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8c e2 00 00 1e 00
Aug  4 23:43:14 charon kernel: Info fld=0x38ce1, Current sd0b:00: sense key Medium Error
Aug  4 23:43:14 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:14 charon kernel:  I/O error: dev 0b:00, sector 930696
Aug  4 23:43:17 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8d 01 00 00 1f 00
Aug  4 23:43:17 charon kernel: Info fld=0x38d01, Current sd0b:00: sense key Medium Error
Aug  4 23:43:17 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:17 charon kernel:  I/O error: dev 0b:00, sector 930820
Aug  4 23:43:20 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8d 21 00 00 1f 00
Aug  4 23:43:20 charon kernel: Info fld=0x38d21, Current sd0b:00: sense key Medium Error
Aug  4 23:43:20 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:20 charon kernel:  I/O error: dev 0b:00, sector 930948
Aug  4 23:43:24 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8c e3 00 00 1d 00
Aug  4 23:43:24 charon kernel: Info fld=0x38ce2, Current sd0b:00: sense key Medium Error
Aug  4 23:43:24 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:24 charon kernel:  I/O error: dev 0b:00, sector 930700
Aug  4 23:43:28 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8c e4 00 00 1c 00
Aug  4 23:43:28 charon kernel: Info fld=0x38ce3, Current sd0b:00: sense key Medium Error
Aug  4 23:43:28 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:28 charon kernel:  I/O error: dev 0b:00, sector 930704
Aug  4 23:43:32 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8d 02 00 00 1e 00
Aug  4 23:43:32 charon kernel: Info fld=0x38d02, Current sd0b:00: sense key Medium Error
Aug  4 23:43:32 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:32 charon kernel:  I/O error: dev 0b:00, sector 930824
Aug  4 23:43:35 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8d 22 00 00 1e 00
Aug  4 23:43:35 charon kernel: Info fld=0x38d22, Current sd0b:00: sense key Medium Error
Aug  4 23:43:35 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:35 charon kernel:  I/O error: dev 0b:00, sector 930952
Aug  4 23:43:40 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8c e5 00 00 1b 00
Aug  4 23:43:40 charon kernel: Info fld=0x38ce4, Current sd0b:00: sense key Medium Error
Aug  4 23:43:40 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:40 charon kernel:  I/O error: dev 0b:00, sector 930708
Aug  4 23:43:45 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8c e6 00 00 1a 00
Aug  4 23:43:45 charon kernel: Info fld=0x38ce5, Current sd0b:00: sense key Medium Error
Aug  4 23:43:45 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:45 charon kernel:  I/O error: dev 0b:00, sector 930712
Aug  4 23:43:51 charon kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB: Read (10) 00 00 03 8d 03 00 00 1d 00
Aug  4 23:43:51 charon kernel: Info fld=0x38d03, Current sd0b:00: sense key Medium Error
Aug  4 23:43:51 charon kernel: Additional sense indicates Mechanical positioning error
Aug  4 23:43:51 charon kernel:  I/O error: dev 0b:00, sector 930828

Since this had been going on about a minute, I decided to try ^C and ^\ the
verification program, but it had no effect.  
At this point the system was still responsive, aside from that process.
I decided to try the old standby of ejecting the cd.  Which caused the
following errors (copied by hand, possibly not exact):
Device 0b:00 not ready
 I/O error: dev 0b:00, sector 930836
Device 0b:00 not ready
 I/O error: dev 0b:00, sector 930964
Device 0b:00 not ready
 I/O error: dev 0b:00, sector 930688
Device 0b:00 not ready
 I/O error: dev 0b:00, sector 930732
Kernel panic: scsi_free: Bad offset
In interrupt handler - not syncing

At this point the system was dead, vt switching didn't work, magic sysrq
unmount didn't work (probably because of that last error), but magic sysrq
reboot did work.

After rebooting I tested the disc in the plextor cd-rw and it tested fine.  So
I guess my cdrom drive is probably dieing (I've noticed it reads cdrs slowly
recently, but this is the first time I've gotten errors).  But it still
shouldn't have caused a panic I think :)

(Also I seem to recall linux locking cdrom drives when you mount a cd,
so its odd that it let me eject it at all)

 [3.] Keywords (i.e., modules, networking, kernel):
scsi, cdrom, kernel panic, i/o error, eject

 [4.] Kernel version (from /proc/version):
Linux version 2.4.19 (root@charon) (gcc version 2.95.4 20011002 (Debian prerelease)) #1 Sat Aug 3 15:46:55 MST 2002

 [5.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)

No oops was printed.

 [6.] A small shell script or example program which triggers the
      problem (if possible)

.. probably not possible.

 [7.] Environment
 [7.1.] Software (add the output of the ver_linux script here)
Linux charon 2.4.19 #1 Sat Aug 3 15:46:55 MST 2002 i686 unknown

Gnu C                  2.95.4
Gnu make               3.79.1
util-linux             2.11n
mount                  2.11m
modutils               2.4.15
e2fsprogs              1.25
Linux C Library        2.2.5
Dynamic linker (ldd)   2.2.5
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               2.0.11
Modules Loaded         sr_mod cdrom isofs inflate_fs snd-emu10k1 snd-pcm snd-timer snd-hwdep snd-util-mem snd-rawmidi snd-seq-device snd-ac97-codec snd soundcore serial via686a i2c-proc i2c-isa i2c-core

 [7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 4
model name      : AMD Athlon(tm) Processor
stepping        : 2
cpu MHz         : 800.045
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr syscall mmxext 3dnowext 3dnow
bogomips        : 1595.80

 [7.3.] Module information (from /proc/modules):
sr_mod                 11792   2 (autoclean)
cdrom                  28672   0 (autoclean) [sr_mod]
isofs                  25016   1 (autoclean)
inflate_fs             17892   0 (autoclean) [isofs]
snd-emu10k1            55820   0
snd-pcm                47808   0 [snd-emu10k1]
snd-timer              10152   0 [snd-pcm]
snd-hwdep               3680   0 [snd-emu10k1]
snd-util-mem            1120   0 [snd-emu10k1]
snd-rawmidi            12224   0 [snd-emu10k1]
snd-seq-device          3824   0 [snd-emu10k1 snd-rawmidi]
snd-ac97-codec         23108   0 [snd-emu10k1]
snd                    24236   0 [snd-emu10k1 snd-pcm snd-timer snd-hwdep snd-util-mem snd-rawmidi snd-seq-device snd-ac97-codec]
soundcore               3364   4 [snd]
serial                 42404   0 (autoclean)
via686a                 8192   0
i2c-proc                6288   1 [via686a]
i2c-isa                 1196   0 (unused)
i2c-core               12588   0 [via686a i2c-proc i2c-isa]

 [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
01f0-01f7 : ide0
02f8-02ff : serial(set)
0376-0376 : ide1
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial(set)
0cf8-0cff : PCI conf1
5000-500f : VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
6000-607f : VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
  6000-607f : via686a-sensors
c000-c00f : VIA Technologies, Inc. Bus Master IDE
  c000-c007 : ide0
  c008-c00f : ide1
c400-c41f : VIA Technologies, Inc. UHCI USB
  c400-c41f : usb-uhci
c800-c81f : VIA Technologies, Inc. UHCI USB (#2)
  c800-c81f : usb-uhci
cc00-cc03 : BusLogic BT-946C (BA80C30) [MultiMaster 10]
  cc00-cc03 : BusLogic BT-948
d000-d03f : Intel Corp. 82557/8/9 [Ethernet Pro 100]
  d000-d03f : eepro100
d400-d41f : Creative Labs SB Audigy
  d400-d41f : EMU10K1
d800-d807 : Creative Labs SB Audigy MIDI/Game port
dc00-dc07 : Triones Technologies, Inc. HPT366 / HPT370
  dc00-dc07 : ide2
e000-e003 : Triones Technologies, Inc. HPT366 / HPT370
  e002-e002 : ide2
e400-e407 : Triones Technologies, Inc. HPT366 / HPT370
e800-e803 : Triones Technologies, Inc. HPT366 / HPT370
ec00-ecff : Triones Technologies, Inc. HPT366 / HPT370
  ec00-ec07 : ide2
  ec08-ec0f : ide3
  ec10-ecff : HPT370

00000000-0009ffff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cc000-000cc7ff : Extension ROM
000f0000-000fffff : System ROM
00100000-17feffff : System RAM
  00100000-00224496 : Kernel code
  00224497-002762ff : Kernel data
17ff0000-17ff2fff : ACPI Non-volatile Storage
17ff3000-17ffffff : ACPI Tables
d0000000-d7ffffff : VIA Technologies, Inc. VT8363/8365 [KT133/KM133]
d8000000-dfffffff : PCI Bus #01
  d8000000-dfffffff : nVidia Corporation NV15 (GeForce2 Pro)
e0000000-e1ffffff : PCI Bus #01
  e0000000-e0ffffff : nVidia Corporation NV15 (GeForce2 Pro)
e3000000-e30fffff : Intel Corp. 82557/8/9 [Ethernet Pro 100]
e3100000-e3103fff : Creative Labs SB Audigy FireWire Port
e3104000-e3104fff : BusLogic BT-946C (BA80C30) [MultiMaster 10]
e3105000-e31057ff : Creative Labs SB Audigy FireWire Port
e3106000-e3106fff : Intel Corp. 82557/8/9 [Ethernet Pro 100]
  e3106000-e3106fff : eepro100
ffff0000-ffffffff : reserved

 [7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev 03)
	Subsystem: ABIT Computer Corp.: Unknown device a401
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Capabilities: [a0] AGP version 2.0
		Status: RQ=31 SBA+ 64bit- FW- Rate=x1,x2
		Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: e0000000-e1ffffff
	Prefetchable memory behind bridge: d8000000-dfffffff
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 40)
	Subsystem: VIA Technologies, Inc. VT82C686/A PCI to ISA Bridge
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.1 IDE interface: VIA Technologies, Inc. Bus Master IDE (rev 06) (prog-if 8a [Master SecP PriP])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Region 4: I/O ports at c000 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.2 USB Controller: VIA Technologies, Inc. UHCI USB (rev 16) (prog-if 00 [UHCI])
	Subsystem: Unknown device 0925:1234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32, cache line size 08
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at c400 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.3 USB Controller: VIA Technologies, Inc. UHCI USB (rev 16) (prog-if 00 [UHCI])
	Subsystem: Unknown device 0925:1234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32, cache line size 08
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at c800 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.4 Host bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin ? routed to IRQ 9
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 SCSI storage controller: BusLogic BT-946C (BA80C30) [MultiMaster 10] (rev 08)
	Subsystem: BusLogic BT-946C (BA80C30) [MultiMaster 10]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (2000ns min, 2000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at cc00 [size=4]
	Region 1: Memory at e3104000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at <unassigned> [disabled] [size=32K]

00:0b.0 Ethernet controller: Intel Corp. 82557 [Ethernet Pro 100] (rev 08)
	Subsystem: Intel Corp. EtherExpress PRO/100+
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (2000ns min, 14000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at e3106000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at d000 [size=64]
	Region 2: Memory at e3000000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled] [size=1M]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:0f.0 Multimedia audio controller: Creative Labs: Unknown device 0004 (rev 03)
	Subsystem: Creative Labs: Unknown device 0053
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (500ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at d400 [size=32]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.1 Input device controller: Creative Labs: Unknown device 7003 (rev 03)
	Subsystem: Creative Labs: Unknown device 0040
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Region 0: I/O ports at d800 [size=8]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.2 FireWire (IEEE 1394): Creative Labs: Unknown device 4001 (prog-if 10 [OHCI])
	Subsystem: Creative Labs: Unknown device 0010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (500ns min, 1000ns max), cache line size 08
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at e3105000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at e3100000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:13.0 Unknown mass storage controller: Triones Technologies, Inc. HPT366 / HPT370 (rev 03)
	Subsystem: Triones Technologies, Inc.: Unknown device 0001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 120 (2000ns min, 2000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at dc00 [size=8]
	Region 1: I/O ports at e000 [size=4]
	Region 2: I/O ports at e400 [size=8]
	Region 3: I/O ports at e800 [size=4]
	Region 4: I/O ports at ec00 [size=256]
	Expansion ROM at <unassigned> [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: nVidia Corporation NV15 (GeForce2 Pro) (rev a4) (prog-if 00 [VGA])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1250ns min, 250ns max)
	Interrupt: pin A routed to IRQ 12
	Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d8000000 (32-bit, prefetchable) [size=128M]
	Expansion ROM at <unassigned> [disabled] [size=64K]
	Capabilities: [60] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [44] AGP version 2.0
		Status: RQ=31 SBA- 64bit- FW+ Rate=x1,x2
		Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>

 [7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices: 
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: TEAC     Model: CD-ROM CD-532S   Rev: 1.0A
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: PLEXTOR  Model: CD-R   PX-W8432T Rev: 1.09
  Type:   CD-ROM                           ANSI SCSI revision: 02

 [7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):

The scsi card is actually a bt-948.  Here is the scsi related dmesg output:
scsi: ***** BusLogic SCSI Driver Version 2.1.15 of 17 August 1998 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi0: Configuring BusLogic Model BT-948 PCI Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0xCC00, IRQ Channel: 11/Level
scsi0:   PCI Bus: 0, Device: 8, Address: 0xE3104000, Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Fast, Wide Negotiation: Disabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
scsi0:   Error Recovery Strategy: Default, SCSI Bus Reset: Enabled
scsi0:   SCSI Bus Termination: Enabled, SCAM: Disabled
scsi0: *** BusLogic BT-948 Initialized Successfully ***
scsi0 : BusLogic BT-948
  Vendor: TEAC      Model: CD-ROM CD-532S    Rev: 1.0A
  Type:   CD-ROM                             ANSI SCSI revision: 02
scsi0: Target 1: Queue Depth 3, Synchronous at 10.0 MB/sec, offset 15
scsi1 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: PLEXTOR   Model: CD-R   PX-W8432T  Rev: 1.09
  Type:   CD-ROM                             ANSI SCSI revision: 02

 [X.] Other notes, patches, fixes, workarounds:

Please cc me in any replies.

-- 
Matthew Mueller
donut@azstarnet.com
