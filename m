From: Lionel Elie Mamane <lionel@mamane.lu>
Subject: PROBLEM: Linux 2.4.19 + aic7xxx driver = crash
Date: Wed, 9 Oct 2002 15:36:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021009133617.GA18381@home.mamane.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[1.] One line summary of the problem:

     Linux 2.4.19 + aic7xxx driver =3D crash

[2.] Full description of the problem/report:

     Two different machines, with two different Adaptec SCSI
     controllers managed by the aic7xxx driver crash after uptimes of
     about 2-4 days when booted with a 2.4.19 kernel.

     The same machines had months-long uptimes with 2.2 kernels, and
     they perform well when the aic7xxx_old driver is used with a
     2.4.19 kernel. Longest uptime before reboot for other reason has
     been two weeks.

     Crash is total. Machine doesn't answer to pings anymore, magic
     SysRq key has no effect, and the software watchdog doesn't
     initiate a reboot. Screen is blank.

     I don't think it is a TCQ-related problem, for the reasons
     explained section X.

     Both machines are under low load. One is mainly a masquerading
     router / proxy serving a total of 2 machine (but only one user),
     the other a desktop machine used by only one person.

[3.] Keywords (i.e., modules, networking, kernel):

     scsi, aic7xxx

[4.] Kernel version (from /proc/version):

     2.4.19 (gcc version 2.95.4 20011002 (Debian prerelease))

[5.] Output of Oops.. message (if applicable) with symbolic information=
=20
     resolved (see Documentation/oops-tracing.txt)

     None.

[6.] A small shell script or example program which triggers the
     problem (if possible)
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

Machine "tofu":

Gnu C                  2.95.4
Gnu make               3.79.1
util-linux             2.11n
mount                  2.11n
modutils               2.4.19
e2fsprogs              1.27
Linux C Library        2.2.5
Dynamic linker (ldd)   2.2.5
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               4.5.1
Modules Loaded         sg hid parport_pc lp parport binfmt_misc snd-seq=
-midi snd-emu8000-synth snd-emux-synth snd-seq-virmidi snd-util-mem snd=
-opl3-synth snd-seq-instr snd-seq-midi-emul snd-ainstr-fm snd-seq-oss s=
nd-seq-midi-event snd-seq snd-pcm-oss snd-mixer-oss snd-sbawe snd-sb16-=
csp snd-opl3-lib snd-hwdep snd-sb16-dsp snd-sb-common snd-pcm snd-timer=
 snd-mpu401-uart snd-rawmidi snd-seq-device snd soundcore 3c59x

Machine "quorn":

Gnu C                  2.95.4
Gnu make               3.79.1
util-linux             2.11n
mount                  2.11n
modutils               2.4.15
e2fsprogs              1.27
isdn4k-utils           3.1pre4
Linux C Library        2.2.5
Dynamic linker (ldd)   2.2.5
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               2.0.11
Modules Loaded         nfs nfsd lp lockd sunrpc ppp_deflate bsd_comp pp=
p slhc ip_masq_ftp parport_pc parport nls_iso8859-1 nls_cp850

(Module information not entirely correct, because this machine has
 been reverted to a 2.2 kernel because of other problems: See my
 report in linux-isdn. Note the SCSI problems appeared before I even
 tried to use ISDN.)

[7.2.] Processor information (from /proc/cpuinfo):

tofu:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 7
model name	: Pentium III (Katmai)
stepping	: 2
cpu MHz		: 498.863
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 mmx fxsr sse
bogomips	: 996.14

quorn:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 3
model name	: Pentium II (Klamath)
stepping	: 4
cpu MHz		: 267.276
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
sep_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov mmx
bogomips	: 532.48

[7.3.] Module information (from /proc/modules):

tofu:

sg                     24316   0 (autoclean)
hid                    18948   0 (unused)
parport_pc             20904   1 (autoclean)
lp                      6916   0 (autoclean)
parport                22912   1 (autoclean) [parport_pc lp]
binfmt_misc             5532   1
snd-seq-midi            3136   0 (autoclean) (unused)
snd-emu8000-synth       8076   0 (autoclean) (unused)
snd-emux-synth         23196   0 (autoclean) [snd-emu8000-synth]
snd-seq-virmidi         2616   0 (autoclean) [snd-emux-synth]
snd-util-mem            1184   0 (autoclean) [snd-emu8000-synth snd-emu=
x-synth]
snd-opl3-synth          8292   0 (autoclean) (unused)
snd-seq-instr           4144   0 (autoclean) [snd-opl3-synth]
snd-seq-midi-emul       4352   0 (autoclean) [snd-emux-synth snd-opl3-s=
ynth]
snd-ainstr-fm           1444   0 (autoclean) [snd-opl3-synth]
snd-seq-oss            22368   0 (unused)
snd-seq-midi-event      2968   0 [snd-seq-midi snd-seq-virmidi snd-seq-=
oss]
snd-seq                36496   2 [snd-seq-midi snd-emux-synth snd-seq-v=
irmidi snd-opl3-synth snd-seq-instr snd-seq-midi-emul snd-seq-oss snd-s=
eq-midi-event]
snd-pcm-oss            35876   0
snd-mixer-oss           8796   0 [snd-pcm-oss]
snd-sbawe              15968   0 [snd-emu8000-synth]
snd-sb16-csp           15176   0 [snd-sbawe]
snd-opl3-lib            5220   0 [snd-opl3-synth snd-sbawe]
snd-hwdep               3552   0 [snd-sb16-csp snd-opl3-lib]
snd-sb16-dsp            5324   0 [snd-sbawe]
snd-sb-common           6968   0 [snd-sbawe snd-sb16-csp snd-sb16-dsp]
snd-pcm                54688   0 [snd-emu8000-synth snd-pcm-oss snd-sb1=
6-dsp]
snd-timer              10152   0 [snd-seq snd-opl3-lib snd-pcm]
snd-mpu401-uart         2512   0 [snd-sbawe snd-sb16-dsp]
snd-rawmidi            12320   0 [snd-seq-midi snd-seq-virmidi snd-mpu4=
01-uart]
snd-seq-device          3728   0 [snd-seq-midi snd-emu8000-synth snd-em=
ux-synth snd-opl3-synth snd-seq-oss snd-seq snd-sbawe snd-opl3-lib snd-=
rawmidi]
snd                    24652   0 [snd-seq-midi snd-emu8000-synth snd-em=
ux-synth snd-seq-virmidi snd-util-mem snd-opl3-synth snd-seq-instr snd-=
seq-oss snd-seq-midi-event snd-seq snd-pcm-oss snd-mixer-oss snd-sbawe =
snd-sb16-csp snd-opl3-lib snd-hwdep snd-sb16-dsp snd-sb-common snd-pcm =
snd-timer snd-mpu401-uart snd-rawmidi snd-seq-device]
soundcore               3524  11 [snd]
3c59x                  24880   1


quorn:

!!!!! Running a 2.2 kernel now!!!!! This is the output with the 2.2
kernel, but no significant change is expected

nfs                    66016   1 (autoclean)
nfsd                  180160   0 (autoclean)
lp                      5088   0 (autoclean)
lockd                  43932   1 (autoclean) [nfs nfsd]
sunrpc                 61212   1 (autoclean) [nfs nfsd lockd]
ppp_deflate            39104   0 (autoclean)
bsd_comp                3904   0 (autoclean)
ppp                    20160   2 (autoclean) [ppp_deflate bsd_comp]
slhc                    4240   0 (autoclean) [ppp]
ip_masq_ftp             3616   0
parport_pc              7328   1
parport                 7296   1 [lp parport_pc]
nls_iso8859-1           2400   0 (unused)
nls_cp850               3136   0 (unused)


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iom=
em)

tofu:

0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
0100-0107 : serial(set)
0108-010f : serial(set)
0110-0117 : serial(set)
0118-011f : serial(set)
0140-0140 : serial(multiport1)
0170-0177 : ide1
01f0-01f7 : ide0
0213-0213 : isapnp read
0220-022f : SoundBlaster
02f8-02ff : serial(set)
0300-0301 : MPU401 UART
0376-0376 : ide1
0378-037a : parport0
0388-0389 : OPL2/3 (left)
038a-038b : OPL2/3 (right)
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial(set)
0620-0623 : Emu8000-1
0a20-0a23 : Emu8000-2
0a79-0a79 : isapnp write
0cf8-0cff : PCI conf1
0e20-0e23 : Emu8000-3
1000-10ff : Adaptec AHA-3940U2x/395U2x
  1000-10fe : aic7xxx
1400-14ff : Adaptec AHA-3940U2x/395U2x (#2)
  1400-14fe : aic7xxx
1800-187f : 3Com Corporation 3c905B 100BaseTX [Cyclone]
  1800-187f : 00:0e.0
1880-189f : Intel Corp. 82371AB/EB/MB PIIX4 USB
18a0-18af : Intel Corp. 82371AB/EB/MB PIIX4 IDE
  18a0-18a7 : ide0
  18a8-18af : ide1
7000-701f : Intel Corp. 82371AB/EB/MB PIIX4 ACPI
8000-803f : Intel Corp. 82371AB/EB/MB PIIX4 ACPI
9000-9fff : PCI Bus #01
  9000-90ff : ATI Technologies Inc 3D Rage Pro AGP 1X/2X

quorn: (again, with a 2.2 kernel)

0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
02f8-02ff : serial(set)
0378-037f : parport0
03c0-03df : vga+
03f8-03ff : serial(set)
0778-077a : parport0
dc00-dc7f : eth0
e000-e07f : eth1
e400-e4fe : aic7xxx


[7.5.] PCI information ('lspci -vvv' as root)

tofu:

00:00.0 Host bridge: Intel Corp. 440BX/ZX - 82443BX/ZX Host bridge (rev=
 03)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort+ >SERR- <PERR-
	Latency: 64
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=3D256M]
	Capabilities: [a0] AGP version 1.0
		Status: RQ=3D31 SBA+ 64bit- FW- Rate=3Dx1,x2
		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>

00:01.0 PCI bridge: Intel Corp. 440BX/ZX - 82443BX/ZX AGP bridge (rev 0=
3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 128
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D64
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: d0100000-d1ffffff
	Prefetchable memory behind bridge: fff00000-000fffff
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B+

00:07.0 ISA bridge: Intel Corp. 82371AB PIIX4 ISA (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 0

00:07.1 IDE interface: Intel Corp. 82371AB PIIX4 IDE (rev 01) (prog-if =
80 [Master])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Region 4: I/O ports at 18a0 [size=3D16]

00:07.2 USB Controller: Intel Corp. 82371AB PIIX4 USB (rev 01) (prog-if=
 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin D routed to IRQ 9
	Region 4: I/O ports at 1880 [size=3D32]

00:07.3 Bridge: Intel Corp. 82371AB PIIX4 ACPI (rev 02)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Interrupt: pin ? routed to IRQ 9

00:0d.0 SCSI storage controller: Adaptec 3940U2
	Subsystem: Adaptec: Unknown device f500
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (9750ns min, 6250ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	BIST result: 00
	Region 0: I/O ports at 1000 [size=3D256]
	Region 1: Memory at d0000000 (64-bit, non-prefetchable) [size=3D4K]
	Expansion ROM at <unassigned> [disabled] [size=3D128K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0d.1 SCSI storage controller: Adaptec 3940U2
	Subsystem: Adaptec: Unknown device f500
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (9750ns min, 6250ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	BIST result: 00
	Region 0: I/O ports at 1400 [size=3D256]
	Region 1: Memory at d0001000 (64-bit, non-prefetchable) [size=3D4K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0e.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone=
] (rev 30)
	Subsystem: 3Com Corporation 3C905B Fast Etherlink XL 10/100
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 80 (2500ns min, 2500ns max), cache line size 08
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at 1800 [size=3D128]
	Region 1: Memory at d0002000 (32-bit, non-prefetchable) [size=3D128]
	Expansion ROM at <unassigned> [disabled] [size=3D128K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1+,D2+,D3hot+,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc 3D Rage Pro AGP=
 1X/2X (rev 5c) (prog-if 00 [VGA])
	Subsystem: ATI Technologies Inc: Unknown device 0084
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping+ SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 66 (2000ns min), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d1000000 (32-bit, non-prefetchable) [size=3D16M]
	Region 1: I/O ports at 9000 [size=3D256]
	Region 2: Memory at d0100000 (32-bit, non-prefetchable) [size=3D4K]
	Expansion ROM at <unassigned> [disabled] [size=3D128K]
	Capabilities: [50] AGP version 1.0
		Status: RQ=3D255 SBA+ 64bit- FW- Rate=3Dx1,x2
		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>


quorn:

00:00.0 Host bridge: Intel Corp. 440LX/EX - 82443LX/EX Host bridge (rev=
 03)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort+ >SERR- <PERR-
	Latency: 64
	Region 0: Memory at e0000000 (32-bit, prefetchable)
	Capabilities: [a0] AGP version 1.0
		Status: RQ=3D31 SBA+ 64bit- FW- Rate=3Dx1,x2
		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>

00:01.0 PCI bridge: Intel Corp. 440LX/EX - 82443LX/EX AGP bridge (rev 0=
3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: e8000000-ebffffff
	Prefetchable memory behind bridge: ec000000-ecffffff
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:07.0 ISA bridge: Intel Corp. 82371AB PIIX4 ISA (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 0

00:07.1 IDE interface: Intel Corp. 82371AB PIIX4 IDE (rev 01) (prog-if =
80 [Master])
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Region 4: I/O ports at f000 [disabled]

00:07.2 USB Controller: Intel Corp. 82371AB PIIX4 USB (rev 01) (prog-if=
 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at d000

00:07.3 Bridge: Intel Corp. 82371AB PIIX4 ACPI (rev 01)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-

00:09.0 Network controller: AVM Audiovisuelles MKTG & Computer System G=
mbH B1 ISDN (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 500ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f0003000 (32-bit, non-prefetchable)
	Region 1: I/O ports at d400
	Region 2: I/O ports at d800

00:0b.0 Ethernet controller: 3Com Corporation 3c905C-TX [Fast Etherlink=
] (rev 74)
	Subsystem: 3Com Corporation 3C905C-TX Fast Etherlink for PC Management=
 NIC
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (2500ns min, 2500ns max), cache line size 08
	Interrupt: pin A routed to IRQ 12
	Region 0: I/O ports at dc00
	Region 1: Memory at f0001000 (32-bit, non-prefetchable)
	Expansion ROM at ed000000 [disabled]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D=
3cold-)
		Status: D0 PME-Enable+ DSel=3D0 DScale=3D2 PME-

00:0d.0 Ethernet controller: 3Com Corporation 3c905C-TX [Fast Etherlink=
] (rev 74)
	Subsystem: 3Com Corporation 3C905C-TX Fast Etherlink for PC Management=
 NIC
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (2500ns min, 2500ns max), cache line size 08
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at e000
	Region 1: Memory at f0000000 (32-bit, non-prefetchable)
	Expansion ROM at ee000000 [disabled]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D=
3cold-)
		Status: D0 PME-Enable+ DSel=3D0 DScale=3D2 PME-

00:0f.0 SCSI storage controller: Adaptec AIC-7861 (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (1000ns min, 1000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 15
	Region 0: I/O ports at e400
	Region 1: Memory at f0002000 (32-bit, non-prefetchable)
	Expansion ROM at ef000000 [disabled]

01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA 2164W [Mil=
lennium II] AGP (prog-if 00 [VGA])
	Subsystem: Matrox Graphics, Inc. MGA 2164W [Millennium II] AGP
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 15
	Region 0: Memory at ec000000 (32-bit, prefetchable)
	Region 1: Memory at e8000000 (32-bit, non-prefetchable)
	Region 2: Memory at e9000000 (32-bit, non-prefetchable)
	Capabilities: [f0] AGP version 1.0
		Status: RQ=3D0 SBA- 64bit- FW- Rate=3D<none>
		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>


Note: Problems occur also when the AVM B1 card is not present in the
      machine. (It was added recently)

[7.6.] SCSI information (from /proc/scsi/scsi)

tofu:

Attached devices:=20
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: SEAGATE  Model: ST39173N         Rev: 5764
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: CWS ORB2 Model: -SI U ID 4       Rev: D33=20
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 02 Lun: 00
  Vendor: EPSON    Model: SCANNER GT-9600  Rev: 1.03
  Type:   Processor                        ANSI SCSI revision: 02


quorn:

Attached devices:=20
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: QUANTUM  Model: FIREBALL ST6.4S  Rev: 0F0C
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: PIONEER  Model: CD-ROM DR-U03S   Rev: 1.01
  Type:   CD-ROM                           ANSI SCSI revision: 02

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

       Here is what the aic7xxx_old driver (resp. a 2.2 kernel) shows
       in /proc/scsi/aic7xxx/0


tofu:

Adaptec AIC7xxx driver version: 5.2.4/5.2.0
Compile Options:
  TCQ Enabled By Default : Enabled
  AIC7XXX_PROC_STATS     : Disabled

Adapter Configuration:
           SCSI Adapter: Adaptec AHA-394X Ultra2 SCSI host adapter
                           Ultra-2 LVD/SE Wide Controller Channel A at =
PCI 0/13/0
    PCI MMAPed I/O Base: 0xd0000000
 Adapter SEEPROM Config: SEEPROM found and used.
      Adaptec SCSI BIOS: Enabled
                    IRQ: 11
                   SCBs: Active 0, Max Active 49,
                         Allocated 62, HW 32, Page 255
             Interrupts: 843026
      BIOS Control Word: 0x18a6
   Adapter Control Word: 0x1c5f
   Extended Translation: Enabled
Disconnect Enable Flags: 0xffff
     Ultra Enable Flags: 0x0000
 Tag Queue Enable Flags: 0x0002
Ordered Queue Tag Flags: 0x0002
Default Tag Queue Depth: 49
    Tagged Queue By Device array for aic7xxx host instance 0:
      {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    Actual queue depth per device for aic7xxx host instance 0:
      {1,49,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

Statistics:

(scsi0:0:1:0)
  Device using Narrow/Sync transfers at 20.0 MByte/sec, offset 15
  Transinfo settings: current(12/15/0/0), goal(10/127/0/0), user(10/127=
/1/0)
  Total transfers 842947 (601706 reads and 241241 writes)


(scsi0:0:4:0)
  Device using Wide/Sync transfers at 40.0 MByte/sec, offset 15
  Transinfo settings: current(12/15/1/0), goal(10/127/1/0), user(10/127=
/1/0)
  Total transfers 0 (0 reads and 0 writes)

and /1:

Adaptec AIC7xxx driver version: 5.2.4/5.2.0
Compile Options:
  TCQ Enabled By Default : Enabled
  AIC7XXX_PROC_STATS     : Disabled

Adapter Configuration:
           SCSI Adapter: Adaptec AHA-394X Ultra2 SCSI host adapter
                           Ultra-2 LVD/SE Wide Controller Channel B at =
PCI 0/13/1
    PCI MMAPed I/O Base: 0xd0001000
 Adapter SEEPROM Config: SEEPROM found and used.
      Adaptec SCSI BIOS: Enabled
                    IRQ: 11
                   SCBs: Active 0, Max Active 1,
                         Allocated 31, HW 32, Page 255
             Interrupts: 573
      BIOS Control Word: 0x18a6
   Adapter Control Word: 0x1c5f
   Extended Translation: Enabled
Disconnect Enable Flags: 0xffff
     Ultra Enable Flags: 0x0000
 Tag Queue Enable Flags: 0x0000
Ordered Queue Tag Flags: 0x0000
Default Tag Queue Depth: 49
    Tagged Queue By Device array for aic7xxx host instance 1:
      {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    Actual queue depth per device for aic7xxx host instance 1:
      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

Statistics:

(scsi1:0:2:0)
  Device using Narrow/Async transfers.
  Transinfo settings: current(0/0/0/0), goal(255/0/0/0), user(10/127/1/=
0)
  Total transfers 83 (83 reads and 0 writes)


quorn:

Adaptec AIC7xxx driver version: 5.1.33/3.2.4
Compile Options:
  TCQ Enabled By Default : Enabled
  AIC7XXX_PROC_STATS     : Disabled
  AIC7XXX_RESET_DELAY    : 5

Adapter Configuration:
           SCSI Adapter: Adaptec AHA-2940A Ultra SCSI host adapter
                           Ultra Narrow Controller at PCI 0/15/0
    PCI MMAPed I/O Base: 0xf0002000
 Adapter SEEPROM Config: SEEPROM found and used.
      Adaptec SCSI BIOS: Enabled
                    IRQ: 15
                   SCBs: Active 0, Max Active 24,
                         Allocated 30, HW 3, Page 255
             Interrupts: 1836144
      BIOS Control Word: 0x18b6
   Adapter Control Word: 0x0057
   Extended Translation: Enabled
Disconnect Enable Flags: 0x00ff
     Ultra Enable Flags: 0x0001
 Tag Queue Enable Flags: 0x0001
Ordered Queue Tag Flags: 0x0001
Default Tag Queue Depth: 24
    Tagged Queue By Device array for aic7xxx host instance 0:
      {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    Actual queue depth per device for aic7xxx host instance 0:
      {8,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

Statistics:

(scsi0:0:0:0)
  Device using Narrow/Sync transfers at 20.0 MByte/sec, offset 15
  Transinfo settings: current(12/15/0/0), goal(12/15/0/0), user(12/15/0=
/0)
  Total transfers 1836084 (942462 reads and 893622 writes)


(scsi0:0:2:0)
  Device using Narrow/Async transfers.
  Transinfo settings: current(0/0/0/0), goal(25/15/0/0), user(25/15/0/0=
)
  Total transfers 0 (0 reads and 0 writes)


[X.] Other notes, patches, fixes, workarounds:

This does not seem to be a TCQ-related problem, because:

 - The aic7xxx_old driver, when compiled with the depth limit the
   aic7xxx driver shows on the console after a few minutes of uptime
   does not show any problem.

I'm using the Debian version of the kernel. Here is what the
README.Debian says:

These patches were applied:

* NFS client seekdir patch
  http://www.fys.uio.no/~trondmy/src/

These modifications were also made:

* Fixed a couple of argument processing bugs in main.c (Eric Delaunay).
* Added initrd support for cramfs.
* Exported proc_get_inode.
* Fixed pegasus_set_multicast lockup.
* Fixed dead lock on shutdown in 8139too.
* Allow ECN to be compiled in but disabled.
* Don't kill page cache entries in set_blocksize.
* Added support for nm256xl+ (Mattia Monga).
* Fixed handling of HIDs with product strings bug no manufacturer.
* Check old_bbpnt in drivers/scsi/sr.c (2.5).
* Removed CONFIG_FT_ALPHA_CLOCK.
* Export est_cycle_freq (needed for removing CONFIG_FT_ALPHA_CLOCK).
* Fixed the use of return values from mem*_io in drivers/isdn/sc.
* Added missing headers in drivers/pcmcia/i82092.c.
* Fixed compile error in drivers/scsi/dpt_i2o.c on alpha.
* Removed -g from driviers/atm/Makefile.
* Extern inline -> static inline in drivers/net/hamradio/soundmodem.
* Added asm/io.h for in*/out* to drivers/net/wan/farsync.c.
* Corrected AdvWriteDWordLramNoSwap in drivers/scsi/advansys.c.
* Added check for VIA KT266 IO-APIC, version =3D=3D 2.
* Translate slashes in broken Acorn ISO9660 file systems (Darren Salt).
* ip_nat_{ftp,irc} cannot be m if ip_conntrack_{ftp,irc} is y, respecti=
vely.
* Removed volume checks in fs/isofs/inode.c.
* Removed gsem from drivers/usb/pegasus.c.
* Always call complete after unlinking an urb in drivers/usb/usb-ohci.c=
=2E
* Set hardsect size to 512 in drivers/scsi/sr.c.
* Lowed invalidate messages to priority DEBUG in fs/buffer.c.

Changes to comments and documentation:

* Fixed typos in asm/socket.h.
* Fixed a typo in Documentation/sound/VIBRA16 (Carlos Valdivia Yag=FCe)=
=2E
* Fixed a typo in Documentation/sound/OPL3-SA (Carlos Valdivia Yag=FCe)=
=2E
* Fixed comment about epochs in arch/alpha/kernel/time.c.

Non-free bits removed:

* Keyspan firmware.
* SMC Token Ring firmware, driver disabled.
* ACENIC firwmare, driver disabled.
* DGRS firmware, driver disabled.
* DAB firmware, driver disabled.

Herbert Xu <herbert@debian.org>
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
