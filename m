From: Bill Babcock <bill@billbabcock.com>
Subject: PROBLEM: mount of a SCSI emulated IDE cd-rom effectively crashes the system
Date: Sun, 28 Sep 2003 20:52:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309290052.h8T0qrHw002276@mekong.waveform.com>
Reply-To: "Bill Babcock" <bill@billbabcock.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from babcock.ne.client2.attbi.com ([66.31.148.89]:49801 "EHLO
	snake.waveform.com") by vger.kernel.org with ESMTP id S262743AbTI2Axz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Sep 2003 20:53:55 -0400
Received: from mekong.waveform.com (mekong [10.1.0.2])
	by snake.waveform.com (8.12.8/8.12.8) with ESMTP id h8T0rEYi004547
	for <linux-scsi@vger.kernel.org>; Sun, 28 Sep 2003 20:53:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bill@billbabcock.com

[1.] One line summary of the problem:
mount of a SCSI emulated IDE cd-rom results in system failure

[2.] Full description of the problem/report:
mount /mnt/cdrom results in the following /var/log/messages output:

Sep 28 19:11:36 mekong kernel: scsi : aborting command due to timeout : pid 397, scsi0, channel 0, id 0, lun 0 Read (10) 00 00 00 00 10 00 00 01 00 
Sep 28 19:11:36 mekong kernel: hdc: DMA interrupt recovery
Sep 28 19:11:36 mekong kernel: hdc: lost interrupt
Sep 28 19:11:36 mekong kernel: ide-scsi: The scsi wants to send us more data than expected - discarding data
Sep 28 19:11:36 mekong kernel: ide-scsi: [[ 28 0 0 0 0 10 0 0 1 0 0 0 ]
Sep 28 19:11:36 mekong kernel: ]
Sep 28 19:11:36 mekong kernel: ide-scsi: expected 2048 got 4096 limit 2048

with the set from 'hdc: lost interrupt' on repeating until I can force
the system to reboot - which I have to do as the system is basically
unusable from that moment on. Well, force actually involves a
poweroff in almost all cases. :-(

The system is a DELL Inspiron 7500, which worked fine under each
redhat release through rh9, at which point the 2.4.20-8 kernel was
installed via the distrib. I've had this problem ever since.

[3.] Keywords (i.e., modules, networking, kernel): ide-scsi, DMA, lost
interrupt

[4.] Kernel version (from /proc/version):
mekong: root > cat /proc/version
Linux version 2.4.20-20.9 (bhcompile@stripples.devel.redhat.com) (gcc version 3.2.2 20030222 (Red Hat Linux 3.2.2-5)) #1 Mon Aug 18 11:45:58 EDT 2003

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)
[6.] A small shell script or example program which triggers the
     problem (if possible)
[7.] Environment

[ somewhat pruned ]

HOSTNAME=mekong
SHELL=/bin/bash
HOST=mekong
HISTSIZE=1000
IGNOREEOF=2
GTK_RC_FILES=/etc/gtk/gtkrc:/common/home/bill/.gtkrc-1.2-gnome2
XAPPLRESDIR=/usr/local/lib/X11/app-defaults
USER=bill
GDK_USE_XFT=1
TERMCAP=
USERNAME=
PAGER=less
COLUMNS=80
INPUTRC=/etc/inputrc
XMODIFIERS=@im=none
EDITOR=emacsclient
LANG=en_US.iso885915
FIGNORE=.o:~
HOME=/common/home/bill
SHLVL=4
GNOME_DESKTOP_SESSION_ID=Default
BASH_ENV=/common/home/bill/.bashrc
LOGNAME=bill
LESS=-x4 -i -m -n
LESSOPEN=|/usr/bin/lesspipe.sh %s
DISPLAY=:0.0
G_BROKEN_FILENAMES=1
XLOG=/common/home/bill/.Xlog.mekong
XAUTHORITY=/common/home/bill/.Xauthority
_=/usr/bin/env


[7.1.] Software (add the output of the ver_linux script here)
mekong: root > sh /usr/src/linux-2.4.20-20.9/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux mekong 2.4.20-20.9 #1 Mon Aug 18 11:45:58 EDT 2003 i686 i686 i386 GNU/Linux
 
Gnu C                  3.2.2
Gnu make               3.79.1
util-linux             2.11y
mount                  2.11y
modutils               2.4.22
e2fsprogs              1.32
reiserfsprogs          3.6.4
pcmcia-cs              3.1.31
PPP                    2.4.1
isdn4k-utils           3.1pre4
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 2.0.11
Net-tools              1.60
Kbd                    1.08
Sh-utils               4.5.3
Modules Loaded         smbfs maestro soundcore binfmt_misc vmnet vmmon parport_pc lp parport serial_cs orinoco_cs orinoco hermes autofs ds yenta_socket pcmcia_core ipt_limit ipt_state ipt_multiport ipt_LOG ipt_MASQUERADE ipt_TOS ipt_REDIRECT ip_conntrack_irc ip_conntrack_ftp ip_nat_ftp iptable_nat ip_conntrack iptable_mangle ipt_REJECT iptable_filter ip_tables sr_mod ide-scsi scsi_mod ide-cd cdrom nls_iso8859-1 nls_cp437 vfat fat loop lvm-mod keybdev mousedev hid input usb-uhci usbcore ext3 jbd

[7.2.] Processor information (from /proc/cpuinfo):
mekong: root > cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Pentium III (Coppermine)
stepping	: 3
cpu MHz		: 601.371
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips	: 1199.30

[7.3.] Module information (from /proc/modules):
mekong: root > cat /proc/modules
smbfs                  44368   1 (autoclean)
maestro                34920   0 (autoclean)
soundcore               6404   2 (autoclean) [maestro]
binfmt_misc             7432   1
vmnet                  23720   3
vmmon                  28084   0 (unused)
parport_pc             19076   1 (autoclean)
lp                      8996   0 (autoclean)
parport                37056   1 (autoclean) [parport_pc lp]
serial_cs               6416   0 (unused)
orinoco_cs              5556   1
orinoco                39724   0 [orinoco_cs]
hermes                  8068   0 [orinoco_cs orinoco]
autofs                 13268   0 (autoclean) (unused)
ds                      8680   2 [serial_cs orinoco_cs]
yenta_socket           13504   2
pcmcia_core            57216   0 [serial_cs orinoco_cs ds yenta_socket]
ipt_limit               1560   2 (autoclean)
ipt_state               1080   6 (autoclean)
ipt_multiport           1176  15 (autoclean)
ipt_LOG                 4184   8
ipt_MASQUERADE          2200   0 (unused)
ipt_TOS                 1656  16
ipt_REDIRECT            1368   0 (unused)
ip_conntrack_irc        4112   0 (unused)
ip_conntrack_ftp        5296   1 (autoclean)
ip_nat_ftp              4112   0 (unused)
iptable_nat            21752   2 [ipt_MASQUERADE ipt_REDIRECT ip_nat_ftp]
ip_conntrack           27272   4 [ipt_state ipt_MASQUERADE ipt_REDIRECT ip_conntrack_irc ip_conntrack_ftp ip_nat_ftp iptable_nat]
iptable_mangle          2776   1 (autoclean)
ipt_REJECT              3992   2 (autoclean)
iptable_filter          2412   1 (autoclean)
ip_tables              15096  13 [ipt_limit ipt_state ipt_multiport ipt_LOG ipt_MASQUERADE ipt_TOS ipt_REDIRECT iptable_nat iptable_mangle ipt_REJECT iptable_filter]
sr_mod                 18136   0 (autoclean)
ide-scsi               12208   0
scsi_mod              107544   2 [sr_mod ide-scsi]
ide-cd                 35712   0
cdrom                  33728   0 [sr_mod ide-cd]
nls_iso8859-1           3516   1 (autoclean)
nls_cp437               5148   1 (autoclean)
vfat                   13004   1 (autoclean)
fat                    38808   0 (autoclean) [vfat]
loop                   12152   0 (autoclean)
lvm-mod                64000   0
keybdev                 2976   0 (unused)
mousedev                5556   0 (unused)
hid                    22244   0 (unused)
input                   5856   0 [keybdev mousedev hid]
usb-uhci               26412   0 (unused)
usbcore                79040   1 [hid usb-uhci]
ext3                   70784   3
jbd                    51924   3 [ext3]

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
mekong: root > cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000f0000-000fffff : System ROM
00100000-1ffeffff : System RAM
  00100000-00253a0b : Kernel code
  00253a0c-0034edc3 : Kernel data
1fff0000-1ffffbff : ACPI Tables
1ffffc00-1fffffff : ACPI Non-volatile Storage
20000000-20000fff : Texas Instruments PCI1225
20001000-20001fff : Texas Instruments PCI1225 (#2)
20400000-207fffff : PCI CardBus #02
20800000-20bfffff : PCI CardBus #02
20c00000-20ffffff : PCI CardBus #06
21000000-213fffff : PCI CardBus #06
a0000000-a0000fff : card services
a0001000-a0001fff : card services
e0000000-e3ffffff : Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host bridge
fc000000-fdffffff : PCI Bus #01
  fc000000-fc000fff : ATI Technologies Inc Rage Mobility P/M AGP 2x
  fd000000-fdffffff : ATI Technologies Inc Rage Mobility P/M AGP 2x
fff80000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
mekong: root > lspci -vvv
00:00.0 Host bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 64
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 1.0
		Status: RQ=31 SBA+ 64bit- FW- Rate=x2
		Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>

00:01.0 PCI bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fc000000-fdffffff
	Prefetchable memory behind bridge: fff00000-000fffff
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B+

00:04.0 CardBus bridge: Texas Instruments PCI1225 (rev 01)
	Subsystem: Dell Computer Corporation: Unknown device 009e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168, cache line size 20
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 20000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 20400000-207ff000 (prefetchable)
	Memory window 1: 20800000-20bff000
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

00:04.1 CardBus bridge: Texas Instruments PCI1225 (rev 01)
	Subsystem: Dell Computer Corporation: Unknown device 009e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 168, cache line size 20
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 20001000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
	Memory window 0: 20c00000-20fff000 (prefetchable)
	Memory window 1: 21000000-213ff000
	I/O window 0: 00004800-000048ff
	I/O window 1: 00004c00-00004cff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

00:07.0 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Region 4: I/O ports at 1080 [size=16]

00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin D routed to IRQ 5
	Region 4: I/O ports at 1060 [size=32]

00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 03)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin ? routed to IRQ 9

00:08.0 Multimedia audio controller: ESS Technology ES1978 Maestro 2E (rev 10)
	Subsystem: Dell Computer Corporation: Unknown device 009e
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at 1400 [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D2 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility P/M AGP 2x (rev 64) (prog-if 00 [VGA])
	Subsystem: Dell Computer Corporation: Unknown device 009e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 66 (2000ns min), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: I/O ports at 2000 [size=256]
	Region 2: Memory at fc000000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at <unassigned> [disabled] [size=128K]
	Capabilities: [50] AGP version 1.0
		Status: RQ=255 SBA+ 64bit- FW- Rate=x1,x2
		Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>
	Capabilities: [5c] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-


[7.6.] SCSI information (from /proc/scsi/scsi)
mekong: root > cat /proc/scsi/scsi
Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: TOSHIBA  Model: CD-ROM XM-7102B  Rev: 1408
  Type:   CD-ROM                           ANSI SCSI revision: 02


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

>From the messages log in bootup:

Sep 28 19:20:28 mekong kernel: Dell Inspiron 7500 machine detected. Disabling APM idle calls.
Sep 28 19:20:28 mekong kernel: Kernel command line: ro root=LABEL=/ hdc=ide-scsi
Sep 28 19:20:28 mekong kernel: ide_setup: hdc=ide-scsi

[ stuff the didn't seem relevant ]

Sep 28 19:20:30 mekong kernel: hdc: TOSHIBA CD-ROM XM-7102B, ATAPI CD/DVD-ROM drive
Sep 28 19:20:26 mekong sysctl: fs.file-max = 13107 
Sep 28 19:20:30 mekong kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Sep 28 19:20:26 mekong sysctl: vm.bdflush = 30 500 0 0 500 3000 60 
Sep 28 19:20:31 mekong kernel: ide1 at 0x170-0x177,0x376 on irq 15
Sep 28 19:20:26 mekong sysctl: vm.overcommit_memory = 0 
Sep 28 19:20:31 mekong kernel: hda: attached ide-disk driver.

[ stuff the didn't seem relevant ]

Sep 28 19:20:44 mekong kernel: hdc: attached ide-scsi driver.
Sep 28 19:20:44 mekong kernel: scsi0 : SCSI host adapter emulation for IDE ATAPI devices
Sep 28 19:20:44 mekong kernel:   Vendor: TOSHIBA   Model: CD-ROM XM-7102B   Rev: 1408
Sep 28 19:20:44 mekong kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Sep 28 19:20:44 mekong kernel: parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
Sep 28 19:20:44 mekong kernel: parport0: irq 7 detected
Sep 28 19:20:44 mekong kernel: Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
Sep 28 19:20:44 mekong kernel: sr0: scsi3-mmc drive: 32x/32x cd/rw xa/form2 cdda tray
Sep 28 19:20:44 mekong kernel: Uniform CD-ROM driver Revision: 3.12


I'll happily provide any other info that will be helpful.

- bill

-- 
                       b i l l   b a b c o c k
               b i l l @ b i l l b a b c o c k . c o m
                w w w . b i l l b a b c o c k . c o m
