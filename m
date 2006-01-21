From: Ed Tomlinson <edt@aei.ca>
Subject: Re: 2.6.16-rc1-mm2
Date: Sat, 21 Jan 2006 11:39:28 -0500
Message-ID: <200601211139.29019.edt@aei.ca>
References: <20060120031555.7b6d65b7.akpm@osdl.org> <43D170CB.8080802@reub.net> <200601211014.44041.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aeimail.aei.ca ([206.123.6.84]:34808 "EHLO aeimail.aei.ca")
	by vger.kernel.org with ESMTP id S932165AbWAUQkG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jan 2006 11:40:06 -0500
In-Reply-To: <200601211014.44041.edt@aei.ca>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com, jgarzik@pobox.com, linux-scsi@vger.kernel.org

On Saturday 21 January 2006 10:14, Ed Tomlinson wrote:
> Hi,
>=20
> >From my perspective 2.6.16-rc1-mm2 still needs work.  I did not try =
15-mm1 or mm2.  Both
> mm3 and mm4 had X problems in that the system would lock but the keyb=
oard was still
> active for Sysrq.  The lockups took days to occur on both mm3 and mm4=
=2E  The reiser3 problem
> made it impossible to test rc1-mm1, rc2-mm2 locked hard sometime in t=
he first 4 hours of=20
> use - this time sysrq was dead too. =20
>=20
> The system is a amd64 using x86_64 from the unofficial debian build. =
 The box is stable using
> 15-rc5-mm3 which has had uptimes of over two weeks.
>=20
> If anyone has ideas on what to backout let me know.  Failing that I w=
ill boot with a serial console
> active and see that it reports.
>=20
> Ideas,
> Ed Tomlinson

Serial console shows that its an I/O error triggering a reiserfs4 kerne=
l panic

[  559.544404] end_request: I/O error, dev sda, sector 19856555
[  559.554791] reiser4 panicked cowardly: reiser4[wget(6000)]: commit_c=
urrent_atom (fs/reiser4/txnmgr.c:1130)[zam-597]:
[  559.554794] write log failed (-5)
[  559.554795]=20
[  559.582807] Kernel panic - not syncing: reiser4[wget(6000)]: commit_=
current_atom (fs/reiser4/txnmgr.c:1130)[zam-597]:
[  559.582809] write log failed (-5)

Have some new errors started to be passed back thru the scsi / libata s=
tack?  I have had no problems
with 15-rc5-mm3 though it may just be masking an issue...

some more info on this:

lspci -vvv from 2.6.15-rc5-mm3

0000:00:0a.0 IDE interface: nVidia Corporation CK8S Serial ATA Controll=
er (v2.5) (rev a2) (prog-if 85 [Master SecO PriO])
        Subsystem: Micro-Star International Co., Ltd.: Unknown device 0=
300
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at 09f0 [size=3D8]
        Region 1: I/O ports at 0bf0 [size=3D4]
        Region 2: I/O ports at 0970 [size=3D8]
        Region 3: I/O ports at 0b70 [size=3D4]
        Region 4: I/O ports at e000 [size=3D16]
        Region 5: I/O ports at e400 [size=3D128]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1=
-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

Extract from the boot of 2.6.16-rc1-mm2

Jan 21 10:50:46 grover kernel: [   26.457745] SCSI subsystem initialize=
d
Jan 21 10:50:46 grover kernel: [   26.495088] libata version 1.20 loade=
d.
Jan 21 10:50:46 grover kernel: [   26.498691] sata_nv 0000:00:09.0: ver=
sion 0.8
Jan 21 10:50:46 grover kernel: [   26.499255] ACPI: PCI Interrupt Link =
[APSI] enabled at IRQ 23
Jan 21 10:50:46 grover kernel: [   26.518542] ACPI: PCI Interrupt 0000:=
00:09.0[A] -> Link [APSI] -> GSI 23 (level, high) -> IRQ 16
Jan 21 10:50:46 grover kernel: [   26.547990] PCI: Setting latency time=
r of device 0000:00:09.0 to 64
Jan 21 10:50:46 grover kernel: [   26.548042] ata1: SATA max UDMA/133 c=
md 0x9E0 ctl 0xBE2 bmdma 0xC800 irq 16
Jan 21 10:50:46 grover kernel: [   26.570996] ata2: SATA max UDMA/133 c=
md 0x960 ctl 0xB62 bmdma 0xC808 irq 16
Jan 21 10:50:46 grover kernel: [   26.669114] usb 2-4.1: new low speed =
USB device using ohci_hcd and address3
Jan 21 10:50:46 grover kernel: [   26.819069] usb 2-4.1: configuration =
#1 chosen from 1 choice
Jan 21 10:50:46 grover kernel: [   26.843314] ata1: SATA link up 1.5 Gb=
ps (SStatus 113)
Jan 21 10:50:46 grover kernel: [   27.017383] nv_sata: Primary device a=
dded
Jan 21 10:50:46 grover kernel: [   27.030590] nv_sata: Primary device r=
emoved
Jan 21 10:50:46 grover kernel: [   27.044365] nv_sata: Secondary device=
 removed
Jan 21 10:50:46 grover kernel: [   27.058744] ata1: dev 0 cfg 49:2f00 8=
2:7c6b 83:7f09 84:4673 85:7c69 86:3e2187:4663 88:407f
Jan 21 10:50:46 grover kernel: [   27.058749] ata1: dev 0 ATA-7, max UD=
MA/133, 490234752 sectors: LBA48
Jan 21 10:50:46 grover kernel: [   27.101015] usb 2-4.2: new full speed=
 USB device using ohci_hcd and address 4
Jan 21 10:50:46 grover kernel: [   27.125640] ata1: dev 0 configured fo=
r UDMA/133
Jan 21 10:50:46 grover kernel: [   27.151867] scsi0 : sata_nv
Jan 21 10:50:46 grover kernel: [   27.239985] usb 2-4.2: not running at=
 top speed; connect to a high speed hub
Jan 21 10:50:46 grover kernel: [   27.276984] usb 2-4.2: configuration =
#1 chosen from 1 choice
Jan 21 10:50:46 grover kernel: [   27.298013] hub 2-4.2:1.0: USB hub fo=
und
Jan 21 10:50:46 grover kernel: [   27.311966] hub 2-4.2:1.0: 4 ports de=
tected
Jan 21 10:50:46 grover kernel: [   27.395432] ata2: SATA link down (SSt=
atus 0)
Jan 21 10:50:46 grover kernel: [   27.409957] scsi1 : sata_nv
Jan 21 10:50:46 grover kernel: [   27.423656]   Vendor: ATA       Model=
: Maxtor 6L250S0    Rev: BACE
Jan 21 10:50:46 grover kernel: [   27.445172]   Type:   Direct-Access  =
                    ANSI SCSI revision: 05
Jan 21 10:50:46 grover kernel: [   27.469990] ACPI: PCI Interrupt Link =
[APSJ] enabled at IRQ 22
Jan 21 10:50:46 grover kernel: [   27.488973] ACPI: PCI Interrupt 0000:=
00:0a.0[A] -> Link [APSJ] -> GSI 22 (level, high) -> IRQ 17
Jan 21 10:50:46 grover kernel: [   27.518040] PCI: Setting latency time=
r of device 0000:00:0a.0 to 64
Jan 21 10:50:46 grover kernel: [   27.518079] ata3: SATA max UDMA/133 c=
md 0x9F0 ctl 0xBF2 bmdma 0xE000 irq 17
Jan 21 10:50:46 grover kernel: [   27.541022] ata4: SATA max UDMA/133 c=
md 0x970 ctl 0xB72 bmdma 0xE008 irq 17
Jan 21 10:50:46 grover kernel: [   27.768102] ata3: SATA link down (SSt=
atus 0)
Jan 21 10:50:46 grover kernel: [   27.782177] scsi2 : sata_nv
Jan 21 10:50:46 grover kernel: [   27.793873] usb 2-4.2.1: new full spe=
ed USB device using ohci_hcd and address 5
Jan 21 10:50:46 grover kernel: [   27.968838] usb 2-4.2.1: configuratio=
n #1 chosen from 1 choice
Jan 21 10:50:46 grover kernel: [   28.007301] ata4: SATA link down (SSt=
atus 0)
Jan 21 10:50:46 grover kernel: [   28.021888] scsi3 : sata_nv
Jan 21 10:50:46 grover kernel: [   28.031774] ACPI: PCI Interrupt Link =
[APC4] enabled at IRQ 19
Jan 21 10:50:46 grover kernel: [   28.050702] GSI 20 sharing vector 0xD=
1 and IRQ 20
Jan 21 10:50:46 grover kernel: [   28.066570] ACPI: PCI Interrupt Link =
[APCJ] enabled at IRQ 21
Jan 21 10:50:46 grover kernel: [   28.085505] ACPI: PCI Interrupt 0000:=
00:06.0[A] -> <6>ACPI: PCI Interrupt 0
000:02:0c.0[A] -> Link [APC4] -> Link [APCJ] -> GSI 21 (level, high) ->=
 IRQ 18
Jan 21 10:50:46 grover kernel: [   28.132680] GSI 19 (level, low) -> IR=
Q 20
Jan 21 10:50:46 grover kernel: [   28.145889] PCI: Via IRQ fixup for 00=
00:02:0c.0, from 10 to 4
Jan 21 10:50:46 grover kernel: [   28.164961] PCI: Setting latency time=
r of device 0000:00:06.0 to 64
Jan 21 10:50:46 grover kernel: [   28.219223] ohci1394: fw-host0: OHCI-=
1394 1.0 (PCI): IRQ=3D[20]  MMIO=3D[ea000000-ea0007ff]  Max Packet=3D[2=
048]  IR/IT contexts=3D[4/8]
Jan 21 10:50:46 grover kernel: [   28.579166] intel8x0_measure_ac97_clo=
ck: measured 56004 usecs
Jan 21 10:50:46 grover kernel: [   28.598090] intel8x0: clocking to 487=
28
Jan 21 10:50:46 grover kernel: [   29.555763] ieee1394: Host added: ID:=
BUS[0-00:1023]  GUID[0010dc00006b07c2]
Jan 21 10:50:46 grover kernel: [   32.498302] SCSI device sda: 49023475=
2 512-byte hdwr sectors (251000 MB)
Jan 21 10:50:46 grover kernel: [   32.583207] sda: Write Protect is off
Jan 21 10:50:46 grover kernel: [   32.595993] sda: Mode Sense: 00 3a 00=
 10
Jan 21 10:50:46 grover kernel: [   32.599979] SCSI device sda: drive ca=
che: write back w/ FUA
Jan 21 10:50:46 grover kernel: [   32.672741] SCSI device sda: 49023475=
2 512-byte hdwr sectors (251000 MB)
Jan 21 10:50:46 grover kernel: [   32.694879] sda: Write Protect is off
Jan 21 10:50:46 grover kernel: [   32.707334] sda: Mode Sense: 00 3a 00=
 10
Jan 21 10:50:46 grover kernel: [   32.707585] SCSI device sda: drive ca=
che: write back w/ FUA
Jan 21 10:50:46 grover kernel: [   32.726082]  sda: sda1 sda2 sda3 sda4=
 < sda5 >
Jan 21 10:50:46 grover kernel: [   32.873995] sd 0:0:0:0: Attached scsi=
 disk sda
Jan 21 10:50:46 grover kernel: [   33.541752] eth1394: eth1: IEEE-1394 =
IPv4 over 1394 Ethernet (fw-host0)
Jan 21 10:50:46 grover kernel: [   34.409131] usbcore: registered new d=
river hiddev
Jan 21 10:50:46 grover kernel: [   34.569628] input: Microsoft Microsof=
t IntelliMouse=AE Optical as /class/input/input1
Jan 21 10:50:46 grover kernel: [   34.594902] input: USB HID v1.00 Mous=
e [Microsoft Microsoft IntelliMouse=AE Optical] on usb-0000:00:02.0-4.1
Jan 21 10:50:46 grover kernel: [   34.627294] usbcore: registered new d=
river usbhid
Jan 21 10:50:46 grover kernel: [   34.642789] drivers/usb/input/hid-cor=
e.c: v2.6:USB HID core driver
Jan 21 10:50:46 grover kernel: [   34.816697] Bluetooth: Core ver 2.8
Jan 21 10:50:46 grover kernel: [   34.828192] NET: Registered protocol =
family 31
Jan 21 10:50:46 grover kernel: [   34.842990] Bluetooth: HCI device and=
 connection manager initialized
Jan 21 10:50:46 grover kernel: [   34.863934] Bluetooth: HCI socket lay=
er initialized
Jan 21 10:50:46 grover kernel: [   34.920716] Bluetooth: HCI USB driver=
 ver 2.9
Jan 21 10:50:46 grover kernel: [   34.941494] usbcore: registered new d=
river hci_usb
Jan 21 10:50:46 grover kernel: [   36.538804] Adding 979956k swap on /d=
ev/hda2.  Priority:-1 extents:1 across:979956k
Jan 21 10:50:46 grover kernel: [   36.564768] Adding 1020116k swap on /=
dev/sda2.  Priority:-2 extents:1 across:1020116k
Jan 21 10:50:46 grover kernel: [   38.361425] ieee1394: sbp2: Driver fo=
rced to serialize I/O (serialize_io=3D1)
Jan 21 10:50:46 grover kernel: [   38.384356] ieee1394: sbp2: Try seria=
lize_io=3D0 for better performance
Jan 21 10:50:46 grover kernel: [   38.552288] Driver 'w83627hf' needs u=
pdating - please use bus_type methods
Jan 21 10:50:46 grover kernel: [   38.579591] w83627hf 9191-0290: Readi=
ng VID from GPIO5
Jan 21 10:50:46 grover kernel: [   38.703929] powernow-k8: Found 1 AMD =
Athlon 64 / Opteron processors (version 1.60.0)
Jan 21 10:50:46 grover kernel: [   38.733242] powernow-k8:    0 : fid 0=
xa (1800 MHz), vid 0x2 (1500 mV)
Jan 21 10:50:46 grover kernel: [   38.754467] powernow-k8:    1 : fid 0=
x2 (1000 MHz), vid 0x12 (1100 mV)
Jan 21 10:50:46 grover kernel: [   38.776181] cpu_init done, current fi=
d 0xa, vid 0x2
Jan 21 10:50:46 grover kernel: [   38.826859] video1394: Installed vide=
o1394 module
Jan 21 10:50:46 grover kernel: [   38.863707] mice: PS/2 mouse device c=
ommon for all mice
Jan 21 10:50:46 grover kernel: [   48.737454] kjournald starting.  Comm=
it interval 5 seconds
Jan 21 10:50:46 grover kernel: [   48.766804] EXT3 FS on hda1, internal=
 journal
Jan 21 10:50:46 grover kernel: [   48.781215] EXT3-fs: mounted filesyst=
em with ordered data mode.
Jan 21 10:50:46 grover kernel: [   48.844247] ReiserFS: hda5: found rei=
serfs format "3.6" with standard journal
Jan 21 10:50:46 grover kernel: [   56.740820] ReiserFS: hda5: using ord=
ered data mode
Jan 21 10:50:46 grover kernel: [   56.787279] ReiserFS: hda5: journal p=
arams: device hda5, size 8192, journal first block 18, max trans len 10=
24, max batch 900, max commit age 30, max trans age 30
Jan 21 10:50:46 grover kernel: [   56.837125] ReiserFS: hda5: checking =
transaction log (hda5)
Jan 21 10:50:46 grover kernel: [   56.902508] ReiserFS: hda5: Using r5 =
hash to sort names
Jan 21 10:50:46 grover kernel: [   57.252649] Loading Reiser4. See www.=
namesys.com for a description of Reiser4=20

grover:/var/log# sdparm -i /dev/sda
    /dev/sda: ATA       Maxtor 6L250S0    BACE
Device identification VPD page:
  Addressed logical unit:
    id_type: vendor specific [0x0],  code_set: ASCII
 00     4c 69 6e 75 78 20 41 54  41 2d 53 43 53 49 20 73    Linux ATA-S=
CSI s
 10     69 6d 75 6c 61 74 6f 72                             imulator

grover:/var/log# smartctl -i -d ata /dev/sda
smartctl version 5.34 [x86_64-unknown-linux-gnu] Copyright (C) 2002-5 B=
ruce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     Maxtor 6L250S0
Serial Number:    L50QDF3H
=46irmware Version: BACE1G10
User Capacity:    251,000,193,024 bytes
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
Local Time is:    Sat Jan 21 11:27:21 2006 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

grover:/var/log# smartctl -H -d ata /dev/sda
smartctl version 5.34 [x86_64-unknown-linux-gnu] Copyright (C) 2002-5 B=
ruce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

---

Hope this helps and that I found the correct places to copy the info.

Ed Tomlinson





-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
