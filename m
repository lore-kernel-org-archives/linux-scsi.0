From: Marc Bevand <bevand_m@epita.fr>
Subject: [PROBLEM] multiple lun with CONFIG_BLK_DEV_IDESCSI
Date: Fri, 31 Jan 2003 23:20:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030131222004.GA10394@marx.epita.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marx (marx [10.42.14.11])
	by epita.fr id h0VMK5Y08729 for linux-scsi@vger.kernel.org
	EPITA Paris France Fri, 31 Jan 2003 23:20:05 +0100 (MET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have always used the scsi emulation support provided by
CONFIG_BLK_DEV_IDESCSI, but recently I have encountered a weird
problem when replacing one of my ide dvd-rom drive.

With the old configuration (hdc: Pioneer DVD-ROM, hdd: RICOH CD-R/RW),
all was fine: hdc was mapped to sr0 (scsi0, channel 0, id 0, lun 0)
and hdd was mapped to sr1 (scsi0, channel 0, id 1, lun 0).

But since I have replaced the hdc drive by a Toshiba DVD-ROM, hdc is
mapped to sr0->sr6 (scsi0, channel 0, id 0, lun 0->6) and hdd is
mapped to sr7->sr13 (scsi0, channel 0, id 1, lun 0->6).

Multiple lun are associated to each ide device, and I have not found
any report of similar problems on the linux-scsi mailing list. Is this
a normal behaviour of the scsi emulation layer ?

PS: I have attached the two outputs of 'dmesg', for the old and new
configuration, to this mail.

-- 
Marc Bevand                          http://www.epita.fr/~bevand_m
Computer Science School EPITA - System, Network and Security Dept.

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.old"

Linux version 2.4.20 (root@alpha) (gcc version 3.0) #9 Thu Jan 30 19:29:56 CET 2003
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
 BIOS-e820: 000000000fff3000 - 0000000010000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
255MB LOWMEM available.
On node 0 totalpages: 65520
zone(0): 4096 pages.
zone(1): 61424 pages.
zone(2): 0 pages.
Kernel command line: BOOT_IMAGE=MyLin-cur ro root=302
Initializing CPU#0
Detected 598.853 MHz processor.
Console: colour VGA+ 80x50
Calibrating delay loop... 1196.03 BogoMIPS
Memory: 256128k/262080k available (1772k kernel code, 5564k reserved, 633k data, 112k init, 0k highmem)
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
Inode cache hash table entries: 16384 (order: 5, 131072 bytes)
Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
Buffer-cache hash table entries: 16384 (order: 4, 65536 bytes)
Page-cache hash table entries: 65536 (order: 6, 262144 bytes)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0081f9ff c0c1f9ff 00000000 00000000
CPU:             Common caps: 0081f9ff c0c1f9ff 00000000 00000000
CPU: AMD-K7(tm) Processor stepping 02
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
mtrr: detected mtrr type: Intel
PCI: PCI BIOS revision 2.10 entry at 0xfb470, last bus=1
PCI: Using configuration type 1
PCI: Probing PCI hardware
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16)
Starting kswapd
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
udf: registering filesystem
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: irq 7 detected
parport0: device reported incorrect length field (61, should be 62)
parport0 (addr 0): SCSI adapter, IMG VP1
parport0: Printer, EPSON Stylus COLOR 440
pty: 256 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq = 4) is a 16550A
ttyS01 at 0x02f8 (irq = 3) is a 16550A
lp0: using parport0 (polling).
Real Time Clock Driver v1.10e
Non-volatile memory driver v1.2
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD7409: IDE controller on PCI bus 00 dev 39
AMD7409: chipset revision 3
AMD7409: not 100% native mode: will probe irqs later
AMD7409: disabling single-word DMA support (revision < C4)
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
hda: MAXTOR 6L080J4, ATA DISK drive
hdb: ST380021A, ATA DISK drive
hdc: Pioneer DVD-ROM ATAPIModel DVD-104S 012, ATAPI CD/DVD-ROM drive
hdd: RICOH CD-R/RW MP7083A, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
blk: queue c039d9e4, I/O limit 4095Mb (mask 0xffffffff)
hda: 156355584 sectors (80054 MB) w/1819KiB Cache, CHS=9732/255/63, UDMA(33)
blk: queue c039db20, I/O limit 4095Mb (mask 0xffffffff)
hdb: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=9729/255/63, UDMA(33)
hdd: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hdd: set_drive_speed_status: error=0x04
Partition check:
 hda: hda1 < hda5 hda6 > hda2
 hdb: hdb1
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: loaded (max 8 devices)
via-rhine.c:v1.10-LK1.1.14  May-3-2002  Written by Donald Becker
  http://www.scyld.com/network/via-rhine.html
eth0: VIA VT6102 Rhine-II at 0xe400, 00:50:ba:2d:24:7b, IRQ 10.
eth0: MII PHY found at address 8, status 0x7809 advertising 01e1 Link 0000.
Linux agpgart interface v0.99 (c) Jeff Hartmann
agpgart: Maximum main memory to use for agp memory: 203M
agpgart: Detected AMD Irongate chipset
agpgart: AGP aperture is 128M @ 0xd8000000
[drm] Initialized tdfx 1.0.0 20010216 on minor 0
[drm] AGP 0.99 on AMD Irongate @ 0xd8000000 128MB
[drm] Initialized radeon 1.1.1 20010405 on minor 1
SCSI subsystem driver Revision: 1.00
scsi0 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: PIONEER   Model: DVD-ROM DVD-104F  Rev: 1.23
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: RICOH     Model: CD-R/RW MP7083A   Rev: 1.10
  Type:   CD-ROM                             ANSI SCSI revision: 02
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
Attached scsi CD-ROM sr1 at scsi0, channel 0, id 1, lun 0
sr0: scsi3-mmc drive: 0x/0x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.12
sr1: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
cmpci: version $Revision: 5.64 $ time 12:03:04 Nov 29 2002
es1371: version v0.30 time 12:03:05 Nov 29 2002
es1371: found chip, vendor id 0x1274 device id 0x1371 revision 0x08
es1371: found es1371 rev 8 at io 0xe800 irq 11
es1371: features: joystick 0x0
ac97_codec: AC97 Audio codec, id: CRY19(Cirrus Logic CS4297A rev A)
Linux Kernel Card Services 3.1.22
  options:  [pci] [cardbus] [pm]
usb.c: registered new driver hub
uhci.c: USB Universal Host Controller Interface driver v1.1
Initializing USB Mass Storage driver...
usb.c: registered new driver usb-storage
USB Mass Storage support registered.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP: Hash tables configured (established 16384 bind 32768)
ip_tables: (C) 2000-2002 Netfilter core team
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
IPv6 v0.8 for NET4.0
IPv6 over IPv4 tunneling driver
ds: no socket drivers loaded!
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 112k freed
blk: queue c039d9e4, I/O limit 4095Mb (mask 0xffffffff)
blk: queue c039db20, I/O limit 4095Mb (mask 0xffffffff)
Adding Swap: 514040k swap-space (priority -1)

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.new"

Linux version 2.4.20 (root@alpha) (gcc version 3.0) #9 Thu Jan 30 19:29:56 CET 2003
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
 BIOS-e820: 000000000fff3000 - 0000000010000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
255MB LOWMEM available.
On node 0 totalpages: 65520
zone(0): 4096 pages.
zone(1): 61424 pages.
zone(2): 0 pages.
Kernel command line: BOOT_IMAGE=MyLin-cur ro root=302
Initializing CPU#0
Detected 598.845 MHz processor.
Console: colour VGA+ 80x50
Calibrating delay loop... 1196.03 BogoMIPS
Memory: 256128k/262080k available (1772k kernel code, 5564k reserved, 633k data, 112k init, 0k highmem)
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
Inode cache hash table entries: 16384 (order: 5, 131072 bytes)
Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
Buffer-cache hash table entries: 16384 (order: 4, 65536 bytes)
Page-cache hash table entries: 65536 (order: 6, 262144 bytes)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0081f9ff c0c1f9ff 00000000 00000000
CPU:             Common caps: 0081f9ff c0c1f9ff 00000000 00000000
CPU: AMD-K7(tm) Processor stepping 02
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
mtrr: detected mtrr type: Intel
PCI: PCI BIOS revision 2.10 entry at 0xfb470, last bus=1
PCI: Using configuration type 1
PCI: Probing PCI hardware
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16)
Starting kswapd
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
udf: registering filesystem
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: irq 7 detected
parport0: device reported incorrect length field (61, should be 62)
parport0 (addr 0): SCSI adapter, IMG VP1
parport0: Printer, EPSON Stylus COLOR 440
pty: 256 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq = 4) is a 16550A
ttyS01 at 0x02f8 (irq = 3) is a 16550A
lp0: using parport0 (polling).
Real Time Clock Driver v1.10e
Non-volatile memory driver v1.2
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD7409: IDE controller on PCI bus 00 dev 39
AMD7409: chipset revision 3
AMD7409: not 100% native mode: will probe irqs later
AMD7409: disabling single-word DMA support (revision < C4)
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
hda: MAXTOR 6L080J4, ATA DISK drive
hdb: ST380021A, ATA DISK drive
hdc: TOSHIBA DVD-ROM SD-M1712, ATAPI CD/DVD-ROM drive
hdd: RICOH CD-R/RW MP7083A, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
blk: queue c039d9e4, I/O limit 4095Mb (mask 0xffffffff)
hda: 156355584 sectors (80054 MB) w/1819KiB Cache, CHS=9732/255/63, UDMA(33)
blk: queue c039db20, I/O limit 4095Mb (mask 0xffffffff)
hdb: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=9729/255/63, UDMA(33)
hdd: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hdd: set_drive_speed_status: error=0x04
Partition check:
 hda: hda1 < hda5 hda6 > hda2
 hdb: hdb1
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: loaded (max 8 devices)
via-rhine.c:v1.10-LK1.1.14  May-3-2002  Written by Donald Becker
  http://www.scyld.com/network/via-rhine.html
eth0: VIA VT6102 Rhine-II at 0xe400, 00:50:ba:2d:24:7b, IRQ 10.
eth0: MII PHY found at address 8, status 0x7809 advertising 01e1 Link 0000.
Linux agpgart interface v0.99 (c) Jeff Hartmann
agpgart: Maximum main memory to use for agp memory: 203M
agpgart: Detected AMD Irongate chipset
agpgart: AGP aperture is 128M @ 0xd8000000
[drm] Initialized tdfx 1.0.0 20010216 on minor 0
[drm] AGP 0.99 on AMD Irongate @ 0xd8000000 128MB
[drm] Initialized radeon 1.1.1 20010405 on minor 1
SCSI subsystem driver Revision: 1.00
scsi0 : SCSI host adapter emulation for IDE ATAPI devices
  Vendor: TOSHIBA   Model: DVD-ROM SD-M1712  Rev: 1004
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: TOSHIBA   Model: DVD-ROM SD-M1712  Rev: 1004
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: TOSHIBA   Model: DVD-ROM SD-M1712  Rev: 1004
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: TOSHIBA   Model: DVD-ROM SD-M1712  Rev: 1004
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: TOSHIBA   Model: DVD-ROM SD-M1712  Rev: 1004
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: TOSHIBA   Model: DVD-ROM SD-M1712  Rev: 1004
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: TOSHIBA   Model: DVD-ROM SD-M1712  Rev: 1004
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: RICOH     Model: CD-R/RW MP7083A   Rev: 1.10
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: RICOH     Model: CD-R/RW MP7083A   Rev: 1.10
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: RICOH     Model: CD-R/RW MP7083A   Rev: 1.10
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: RICOH     Model: CD-R/RW MP7083A   Rev: 1.10
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: RICOH     Model: CD-R/RW MP7083A   Rev: 1.10
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: RICOH     Model: CD-R/RW MP7083A   Rev: 1.10
  Type:   CD-ROM                             ANSI SCSI revision: 02
  Vendor: RICOH     Model: CD-R/RW MP7083A   Rev: 1.10
  Type:   CD-ROM                             ANSI SCSI revision: 02
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
Attached scsi CD-ROM sr1 at scsi0, channel 0, id 0, lun 1
Attached scsi CD-ROM sr2 at scsi0, channel 0, id 0, lun 2
Attached scsi CD-ROM sr3 at scsi0, channel 0, id 0, lun 3
Attached scsi CD-ROM sr4 at scsi0, channel 0, id 0, lun 4
Attached scsi CD-ROM sr5 at scsi0, channel 0, id 0, lun 5
Attached scsi CD-ROM sr6 at scsi0, channel 0, id 0, lun 6
Attached scsi CD-ROM sr7 at scsi0, channel 0, id 1, lun 0
Attached scsi CD-ROM sr8 at scsi0, channel 0, id 1, lun 1
Attached scsi CD-ROM sr9 at scsi0, channel 0, id 1, lun 2
Attached scsi CD-ROM sr10 at scsi0, channel 0, id 1, lun 3
Attached scsi CD-ROM sr11 at scsi0, channel 0, id 1, lun 4
Attached scsi CD-ROM sr12 at scsi0, channel 0, id 1, lun 5
Attached scsi CD-ROM sr13 at scsi0, channel 0, id 1, lun 6
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.12
sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr2: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr3: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr4: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr5: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr6: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
sr7: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
sr8: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
sr9: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
sr10: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
sr11: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
sr12: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
sr13: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
cmpci: version $Revision: 5.64 $ time 12:03:04 Nov 29 2002
es1371: version v0.30 time 12:03:05 Nov 29 2002
es1371: found chip, vendor id 0x1274 device id 0x1371 revision 0x08
es1371: found es1371 rev 8 at io 0xe800 irq 11
es1371: features: joystick 0x0
ac97_codec: AC97 Audio codec, id: CRY19(Cirrus Logic CS4297A rev A)
Linux Kernel Card Services 3.1.22
  options:  [pci] [cardbus] [pm]
usb.c: registered new driver hub
uhci.c: USB Universal Host Controller Interface driver v1.1
Initializing USB Mass Storage driver...
usb.c: registered new driver usb-storage
USB Mass Storage support registered.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP: Hash tables configured (established 16384 bind 32768)
ip_tables: (C) 2000-2002 Netfilter core team
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
IPv6 v0.8 for NET4.0
IPv6 over IPv4 tunneling driver
ds: no socket drivers loaded!
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 112k freed
blk: queue c039d9e4, I/O limit 4095Mb (mask 0xffffffff)
blk: queue c039db20, I/O limit 4095Mb (mask 0xffffffff)
Adding Swap: 514040k swap-space (priority -1)

--SUOF0GtieIMvvwua--
