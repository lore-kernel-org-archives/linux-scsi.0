From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Trying to troubleshoot ornery Phison usb-storage
Date: Sat, 15 Mar 2003 16:13:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030315161354.A22207@one-eyed-alien.net>
References: <m34r65lrmq.fsf@bfnet.com> <20030314122408.B32112@one-eyed-alien.net> <m3of4dk6gq.fsf@bfnet.com> <20030314144733.D32112@one-eyed-alien.net> <m3el59k0yd.fsf@bfnet.com> <20030314175543.E32112@one-eyed-alien.net> <m37kb1jreb.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m37kb1jreb.fsf@bfnet.com>; from dave-gnus@bfnet.com on Fri, Mar 14, 2003 at 06:27:24PM -0800
List-Id: linux-scsi@vger.kernel.org
To: David Wuertele <dave-gnus@bfnet.com>
Cc: linux-scsi@vger.kernel.org, linux-usb-users@lists.sourceforge.net


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

max_scsi_luns set to 1 should be the 'correct' value.

The problem is, too much logging is getting lost somewhere.  There should
be a _lot_ more messages that start 'usb-storage:' -- I need to see those
to understand what's going on.

Matt

On Fri, Mar 14, 2003 at 06:27:24PM -0800, David Wuertele wrote:
> Matt> Could you repeat this test with:
> Matt> (a) max_scsi_luns spelled properly on the command line, and
> Matt> (b) max_scsi_luns set to 0
>=20
> D'oh!
>=20
> Here we go...  With max_scsi_luns set to 0, fdisk didn't even find a
> device:
>=20
>   # dmesg -n 8
>   # fdisk /dev/scsi/host0/bus0/target0/lun0/disc
>=20
>   Unable to open /dev/scsi/host0/bus0/target0/lun0/disc
>   #=20
>=20
> No errors were printed to console at all.  (Since it is not as
> interesting, I've appended the console output for this case to the end
> of the email, after the max_scsi_luns=3D3 case).
>=20
> Wit max_scsi_luns=3D3, I got identical results in the shell:
>=20
>   # dmesg -n 8
>   # fdisk /dev/scsi/host0/bus0/target0/lun0/disc
>=20
>   Unable to read /dev/scsi/host0/bus0/target0/lun0/disc
>   #=20
>=20
> This time, there was some console output.  I include the whole thing
> here:
>=20
> memsize environment variable not set: assuming 32MB
> CPU revision is: 00018007
> Primary instruction cache 16kb, linesize 16 bytes (4 ways)
> Primary data cache 16kb, linesize 16 bytes (4 ways)
> Linux version 2.4.18_dev-xilleon_x220 (dave@vmrh73g.localdomain) (gcc ver=
sion 2.96 20000731 (Red Hat Linux 7.1 2.96-99.1)) #24 Thu Mar 13 09:38:57 P=
ST 2003
> KGDB: Using serial line /dev/ttyS1 for session
> Determined physical RAM map:
>  memory: 00080000 @ 00000000 (ROM data)
>  memory: 00080000 @ 00080000 (reserved)
>  memory: 01f00000 @ 00100000 (usable)
> On node 0 totalpages: 8192
> zone(0): 8192 pages.
> zone(1): 0 pages.
> zone(2): 0 pages.
> Kernel command line: nfsroot=3D10.0.0.157:/nfsroot,rw,rsize=3D1024,wsize=
=3D1024 max_scsi_luns=3D3 hda=3Dnone hdb=3Dnone rw ip=3D10.0.1.3  console=
=3DttyS0,115200,n,8,1
> ide_setup: hda=3Dnone
> ide_setup: hdb=3Dnone
> Initializing IRQs
> calculating r4koff... CPU frequency 598.42 MHz
> Console: colour dummy device 80x25
> Calibrating delay loop... 598.01 BogoMIPS
> MIPS CPU counter frequency is fixed at 299209896 Hz
> Memory: 28456k/31744k available (2230k kernel code, 3288k reserved, 323k =
data, 4k init, 0k highmem)
> Dentry-cache hash table entries: 4096 (order: 3, 32768 bytes)
> Inode-cache hash table entries: 2048 (order: 2, 16384 bytes)
> Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
> Buffer-cache hash table entries: 1024 (order: 0, 4096 bytes)
> Page-cache hash table entries: 8192 (order: 3, 32768 bytes)
> Checking for 'wait' instruction...  unavailable.
> POSIX conformance testing by UNIFIX
> Autoconfig PCI channel 0x803804e8
> Scanning bus 00, I/O 0x00002000:0x00010001, Mem 0x10000000:0x18000001
> 00:08.0 Class 0200: 10ec:8139 (rev 10)
>         I/O at 0x00002000 [size=3D0x100]
>         Mem at 0x10000000 [size=3D0x100]
> 00:14.0 Class 0480: 1002:4855 (rev 02)
>         Mem at 0x08000000 [size=3D0x4000000]
>         I/O at 0x00002100 [size=3D0x100]
>         Mem at 0x10008000 [size=3D0x8000]
>         Mem at 0x1c000000 [size=3D0x2000000]
> 00:14.1 Class 0101: 1002:4856 (rev 01)
>         I/O at 0x00002200 [size=3D0x8]
>         I/O at 0x00002208 [size=3D0x4]
>         I/O at 0x00002210 [size=3D0x8]
>         I/O at 0x00002218 [size=3D0x4]
>         I/O at 0x00002220 [size=3D0x10]
> 00:14.2 Class 0c03: 1002:4857 (rev 0a)
>         Mem at 0x10010000 [size=3D0x1000]
> 00:14.5 Class 0401: 1002:4858 (rev 01)
>         Mem at 0x10011000 [size=3D0x100]
> 00:14.6 Class 0703: 1002:4859 (rev 01)
>         Mem at 0x10011100 [size=3D0x100]
> irq fixup slot 8 vendor 10ec irq 33
> Linux NET4.0 for Linux 2.4
> Based upon Swansea University Computer Society NET3.039
> Initializing RT netlink socket
> Starting kswapd
> Disabling the Out Of Memory Killer
> devfs: v1.10 (20020120) Richard Gooch (rgooch@atnf.csiro.au)
> devfs: devfs_debug: 0x0
> devfs: boot_options: 0x1
> NTFS driver v1.1.22 [Flags: R/O]
> JFFS2 version 2.1. (C) 2001, 2002 Red Hat, Inc., designed by Axis Communi=
cations AB.
> i2c-core.o: i2c core module version 2.6.2 (20011118)
> i2c-dev.o: i2c /dev entries driver module version 2.6.2 (20011118)
> i2c-proc.o version 2.6.2 (20011118)
> initialize_kbd: Keyboard failed self test
> pty: 256 Unix98 ptys configured
> rs_init() APER_PCUIPA_BASE: 200 200  deviceID: 4855 4855
> Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SERIAL=
_PCI enabled
> Testing ttyS0 (0xbe000010, 0xbe000010)...
> Testing ttyS1 (0xbe000000, 0xbe000000)...
> ttyS00 at 0xbe000010 (irq =3D 100) is a 16550A
> ttyS01 at 0xbe000000 (irq =3D 99) is a 16550A
> block: 64 slots per queue, batch=3D16
> RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
> Uniform Multi-Platform E-IDE driver Revision: 6.31
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=
=3Dxx
> X225: IDE controller on PCI bus 00 dev a1
> X225: chipset revision 1
> XILLEON 225 IDE: rev 01 IDE UDMA controller on pci00:14.1
> X225: 100% native mode on irq 3
>     ide0: BM-DMA at 0x2220-0x2227, BIOS settings: hda:DMA, hdb:DMA
> probing for hdc: present=3D0, media=3D32, probetype=3DATA
> probing for hdc: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdd: present=3D0, media=3D32, probetype=3DATA
> probing for hdd: present=3D0, media=3D32, probetype=3DATAPI
> probing for hde: present=3D0, media=3D32, probetype=3DATA
> probing for hde: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdf: present=3D0, media=3D32, probetype=3DATA
> probing for hdf: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdg: present=3D0, media=3D32, probetype=3DATA
> probing for hdg: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdh: present=3D0, media=3D32, probetype=3DATA
> probing for hdh: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdi: present=3D0, media=3D32, probetype=3DATA
> probing for hdi: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdj: present=3D0, media=3D32, probetype=3DATA
> probing for hdj: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdk: present=3D0, media=3D32, probetype=3DATA
> probing for hdk: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdl: present=3D0, media=3D32, probetype=3DATA
> probing for hdl: present=3D0, media=3D32, probetype=3DATAPI
> loop: loaded (max 8 devices)
> 8139too Fast Ethernet driver 0.9.24
> 8139too: pci dev 00:08.0 (id 10ec:8139 rev ff) is an enhanced 8139C+ chip
> 8139too: Use the "8139cp" driver for improved performance and stability.
> eth0: RealTek RTL8139 Fast Ethernet at 0xb0000000, 00:0a:97:02:0e:09, IRQ=
 33
> SCSI subsystem driver Revision: 1.00
> request_module[scsi_hostadapter]: Root fs not mounted
> XILLEON Flash mappings:=20
> Search for id:(00 00) interleave(1) type(1)
> Search for id:(00 00) interleave(1) type(1)
> Search for id:(00 00) interleave(1) type(1)
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(1) type(2)
> JEDEC: Found no Core flash device at location zero
> Boot FLASH probe failed
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(2) type(1)
> Search for id:(00 00) interleave(2) type(1)
> Search for id:(00 00) interleave(2) type(1)
> Search for id:(00 00) interleave(2) type(2)
> Search for id:(00 00) interleave(2) type(2)
> Search for id:(00 00) interleave(2) type(2)
> JEDEC: Found no User flash device at location zero
> User FLASH probe failed
> usb.c: registered new driver usbdevfs
> usb.c: registered new driver hub
> usb-ohci-pci.c: USB OHCI at membase 0xb0010000, IRQ 2
> usb-ohci-pci.c: usb-00:14.2, PCI device 1002:4857 (ATI Technologies Inc)
> usb.c: new USB bus registered, assigned bus number 1
> Product: USB OHCI Root Hub
> SerialNumber: b0010000
> hub.c: USB hub found
> hub.c: 2 ports detected
> usb.c: registered new driver hid
> hid-core.c: v1.8 Andreas Gal, Vojtech Pavlik <vojtech@suse.cz>
> hid-core.c: USB HID support drivers
> usb.c: registered new driver usblp
> printer.c: v0.8:USB Printer Device Class driver
> Initializing USB Mass Storage driver...
> usb.c: registered new driver usb-storage
> USB Mass Storage support registered.
> mice: PS/2 mouse device common for all mice
> NET4: Linux TCP/IP 1.0 for NET4.0
> IP Protocols: ICMP, UDP, TCP
> IP: routing cache hash table of 512 buckets, 4Kbytes
> TCP: Hash tables configured (established 2048 bind 2048)
> eth0: Setting half-duplex based on auto-negotiated partner ability 0000.
> IP-Config: Guessing netmask 255.0.0.0
> IP-Config: Complete:
>       device=3Deth0, addr=3D10.0.1.3, mask=3D255.0.0.0, gw=3D255.255.255.=
255,
>      host=3D10.0.1.3, domain=3D, nis-domain=3D(none),
>      bootserver=3D255.255.255.255, rootserver=3D10.0.0.157, rootpath=3D
> NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
> hub.c: USB new device connect on bus1/2, assigned device number 2
> Looking up port of RPC 100003/2 on 10.0.0.157
> Looking up port of RPC 100005/1 on 10.0.0.157
> VFS: Mounted root (nfs filesystem).
> Mounted devfs on /dev
> Freeing unused kernel memory: 4k freed
> Manufacturer: ????????????????????????
> Product: ?????????????Aa123456789
> SerialNumber: Aa1234567890
> scsi0 : SCSI emulation for USB Mass Storage devices
>   Vendor: KingByte  Model: Multi-card R/W    Rev: 0100
>   Type:   Direct-Access                      ANSI SCSI revision: 02
>   Vendor: KingByte  Model: Multi-card R/W    Rev: 0100
>   Type:   Direct-Access                      ANSI SCSI revision: 02
>   Vendor: KingByte  Model: Multi-card R/W    Rev: 0100
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
> Attached scsi removable disk sdb at scsi0, channel 0, id 0, lun 1
> Attached scsi removable disk sdc at scsi0, channel 0, id 0, lun 2
> sda : READ CAPACITY failed.
> sda : status =3D 1, message =3D 00, host =3D 0, driver =3D 08=20
> Current sd00:00: sns =3D 70  0
> Raw sense data:0x70 0x00 0x00 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x0=
0 0x00 0x00 0x00 0x00 0x00 0x00=20
> sda : block size assumed to be 512 bytes, disk size 1GB. =20
> Partition check:
>  /dev/scsi/host0/bus0/target0/lun0:<7>usb-storage: queuecommand() called
>  unknown partition table
> sdb : READ CAPACITY failed.
> sdb : status =3D 1, message =3D 00, host =3D 0, driver =3D 08=20
> Current sd00:00: sns =3D 70  0
> Raw sense data:0x70 0x00 0x00 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x0=
0 0x00 0x00 0x00 0x00 0x00 0x00=20
> sdb : block size assumed to be 512 bytes, disk size 1GB. =20
>  /dev/scsi/host0/bus0/target0/lun1:<7>usb-storage: queuecommand() called
>  unknown partition table
> sdc : READ CAPACITY failed.
> sdc : status =3D 1, message =3D 00, host =3D 0, driver =3D 08=20
> Current sd00:00: sns =3D 70  0
> Raw sense data:0x70 0x00 0x00 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x0=
0 0x00 0x00 0x00 0x00 0x00 0x00=20
> sdc : block size assumed to be 512 bytes, disk size 1GB. =20
>  /dev/scsi/host0/bus0/target0/lun2:<7>usb-storage: queuecommand() called
>  unknown partition table
> Algorithmics/MIPS FPU Emulator v1.5
> serial console detected.  Disabling virtual terminals.
> init started:  BusyBox v0.60.2 (2002.04.03-20:48+0000) multi-call binary
> 		Welcome to prototype Linux
> Mounting proc filesystem:  [  OK  ]
> Configuring kernel parameters:  [  OK  ]
> Activating swap partitions:  [  OK  ]
> Setting hostname prototype:  [  OK  ]
> Mounting local filesystems:  [  OK  ]
> Enabling swap space:  [  OK  ]
> Entering non-interactive startup
> Starting system logger: [  OK  ]
> Starting kernel logger: [  OK  ]
> Starting xinetd: [  OK  ]
> Setting clock: Fri Dec 31 19:00:33 EST 1999 [  OK  ]
>=20
> prototype login: usb-storage: queuecommand() called
> usb-storage: *** thread awakened.
> usb-storage: Skipping START_STOP command
> usb-storage: *** thread sleeping.
> usb-storage: queuecommand() called
> usb-storage: *** thread awakened.
> usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
> usb-storage: 1e 00 00 00 01 00 8b 81 f4 ff ff ff
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: -- Stall on control pipe. Clearing
> usb-storage: -- usb_clear_halt() returns 0
> usb-storage: -- Result from auto-sense is 0
> usb-storage: -- code: 0x70, key: 0x6, ASC: 0x28, ASCQ: 0x0
> usb-storage: Unit Attention: not ready to ready transition
> usb-storage: scsi cmd done, result=3D0x2
> usb-storage: *** thread sleeping.
>  I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 0
> usb-storage: queuecommand() called
> usb-storage: *** thread awakened.
> usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
> usb-storage: 1e 00 00 00 00 00 3c 80 20 f1 3c 80
> usb-storage: scsi cmd done, result=3D0x0
> usb-storage: *** thread sleeping.
> login:=20
> Login timed out after 60 secon
> prototype login:=20
>=20
>=20
> As I said before, the max_scsi_luns=3D0 case was less interesting, but I
> append the console output here anyway:
>=20
> memsize environment variable not set: assuming 32MB
> CPU revision is: 00018007
> Primary instruction cache 16kb, linesize 16 bytes (4 ways)
> Primary data cache 16kb, linesize 16 bytes (4 ways)
> Linux version 2.4.18_dev-xilleon_x220 (dave@vmrh73g.localdomain) (gcc ver=
sion 2.96 20000731 (Red Hat Linux 7.1 2.96-99.1)) #24 Thu Mar 13 09:38:57 P=
ST 2003
> KGDB: Using serial line /dev/ttyS1 for session
> Determined physical RAM map:
>  memory: 00080000 @ 00000000 (ROM data)
>  memory: 00080000 @ 00080000 (reserved)
>  memory: 01f00000 @ 00100000 (usable)
> On node 0 totalpages: 8192
> zone(0): 8192 pages.
> zone(1): 0 pages.
> zone(2): 0 pages.
> Kernel command line: nfsroot=3D10.0.0.157:/nfsroot,rw,rsize=3D1024,wsize=
=3D1024 max_scsi_luns=3D0 hda=3Dnone hdb=3Dnone rw ip=3D10.0.1.3  console=
=3DttyS0,115200,n,8,1
> ide_setup: hda=3Dnone
> ide_setup: hdb=3Dnone
> Initializing IRQs
> calculating r4koff... CPU frequency 598.42 MHz
> Console: colour dummy device 80x25
> Calibrating delay loop... 598.01 BogoMIPS
> MIPS CPU counter frequency is fixed at 299209896 Hz
> Memory: 28456k/31744k available (2230k kernel code, 3288k reserved, 323k =
data, 4k init, 0k highmem)
> Dentry-cache hash table entries: 4096 (order: 3, 32768 bytes)
> Inode-cache hash table entries: 2048 (order: 2, 16384 bytes)
> Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
> Buffer-cache hash table entries: 1024 (order: 0, 4096 bytes)
> Page-cache hash table entries: 8192 (order: 3, 32768 bytes)
> Checking for 'wait' instruction...  unavailable.
> POSIX conformance testing by UNIFIX
> Autoconfig PCI channel 0x803804e8
> Scanning bus 00, I/O 0x00002000:0x00010001, Mem 0x10000000:0x18000001
> 00:08.0 Class 0200: 10ec:8139 (rev 10)
>         I/O at 0x00002000 [size=3D0x100]
>         Mem at 0x10000000 [size=3D0x100]
> 00:14.0 Class 0480: 1002:4855 (rev 02)
>         Mem at 0x08000000 [size=3D0x4000000]
>         I/O at 0x00002100 [size=3D0x100]
>         Mem at 0x10008000 [size=3D0x8000]
>         Mem at 0x1c000000 [size=3D0x2000000]
> 00:14.1 Class 0101: 1002:4856 (rev 01)
>         I/O at 0x00002200 [size=3D0x8]
>         I/O at 0x00002208 [size=3D0x4]
>         I/O at 0x00002210 [size=3D0x8]
>         I/O at 0x00002218 [size=3D0x4]
>         I/O at 0x00002220 [size=3D0x10]
> 00:14.2 Class 0c03: 1002:4857 (rev 0a)
>         Mem at 0x10010000 [size=3D0x1000]
> 00:14.5 Class 0401: 1002:4858 (rev 01)
>         Mem at 0x10011000 [size=3D0x100]
> 00:14.6 Class 0703: 1002:4859 (rev 01)
>         Mem at 0x10011100 [size=3D0x100]
> irq fixup slot 8 vendor 10ec irq 33
> Linux NET4.0 for Linux 2.4
> Based upon Swansea University Computer Society NET3.039
> Initializing RT netlink socket
> Starting kswapd
> Disabling the Out Of Memory Killer
> devfs: v1.10 (20020120) Richard Gooch (rgooch@atnf.csiro.au)
> devfs: devfs_debug: 0x0
> devfs: boot_options: 0x1
> NTFS driver v1.1.22 [Flags: R/O]
> JFFS2 version 2.1. (C) 2001, 2002 Red Hat, Inc., designed by Axis Communi=
cations AB.
> i2c-core.o: i2c core module version 2.6.2 (20011118)
> i2c-dev.o: i2c /dev entries driver module version 2.6.2 (20011118)
> i2c-proc.o version 2.6.2 (20011118)
> initialize_kbd: Keyboard failed self test
> pty: 256 Unix98 ptys configured
> rs_init() APER_PCUIPA_BASE: 200 200  deviceID: 4855 4855
> Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SERIAL=
_PCI enabled
> Testing ttyS0 (0xbe000010, 0xbe000010)...
> Testing ttyS1 (0xbe000000, 0xbe000000)...
> ttyS00 at 0xbe000010 (irq =3D 100) is a 16550A
> ttyS01 at 0xbe000000 (irq =3D 99) is a 16550A
> block: 64 slots per queue, batch=3D16
> RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
> Uniform Multi-Platform E-IDE driver Revision: 6.31
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=
=3Dxx
> X225: IDE controller on PCI bus 00 dev a1
> X225: chipset revision 1
> XILLEON 225 IDE: rev 01 IDE UDMA controller on pci00:14.1
> X225: 100% native mode on irq 3
>     ide0: BM-DMA at 0x2220-0x2227, BIOS settings: hda:DMA, hdb:DMA
> probing for hdc: present=3D0, media=3D32, probetype=3DATA
> probing for hdc: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdd: present=3D0, media=3D32, probetype=3DATA
> probing for hdd: present=3D0, media=3D32, probetype=3DATAPI
> probing for hde: present=3D0, media=3D32, probetype=3DATA
> probing for hde: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdf: present=3D0, media=3D32, probetype=3DATA
> probing for hdf: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdg: present=3D0, media=3D32, probetype=3DATA
> probing for hdg: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdh: present=3D0, media=3D32, probetype=3DATA
> probing for hdh: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdi: present=3D0, media=3D32, probetype=3DATA
> probing for hdi: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdj: present=3D0, media=3D32, probetype=3DATA
> probing for hdj: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdk: present=3D0, media=3D32, probetype=3DATA
> probing for hdk: present=3D0, media=3D32, probetype=3DATAPI
> probing for hdl: present=3D0, media=3D32, probetype=3DATA
> probing for hdl: present=3D0, media=3D32, probetype=3DATAPI
> loop: loaded (max 8 devices)
> 8139too Fast Ethernet driver 0.9.24
> 8139too: pci dev 00:08.0 (id 10ec:8139 rev ff) is an enhanced 8139C+ chip
> 8139too: Use the "8139cp" driver for improved performance and stability.
> eth0: RealTek RTL8139 Fast Ethernet at 0xb0000000, 00:0a:97:02:0e:09, IRQ=
 33
> SCSI subsystem driver Revision: 1.00
> request_module[scsi_hostadapter]: Root fs not mounted
> XILLEON Flash mappings:=20
> Search for id:(00 00) interleave(1) type(1)
> Search for id:(00 00) interleave(1) type(1)
> Search for id:(00 00) interleave(1) type(1)
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(1) type(2)
> JEDEC: Found no Core flash device at location zero
> Boot FLASH probe failed
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(1) type(2)
> Search for id:(00 00) interleave(2) type(1)
> Search for id:(00 00) interleave(2) type(1)
> Search for id:(00 00) interleave(2) type(1)
> Search for id:(00 00) interleave(2) type(2)
> Search for id:(00 00) interleave(2) type(2)
> Search for id:(00 00) interleave(2) type(2)
> JEDEC: Found no User flash device at location zero
> User FLASH probe failed
> usb.c: registered new driver usbdevfs
> usb.c: registered new driver hub
> usb-ohci-pci.c: USB OHCI at membase 0xb0010000, IRQ 2
> usb-ohci-pci.c: usb-00:14.2, PCI device 1002:4857 (ATI Technologies Inc)
> usb.c: new USB bus registered, assigned bus number 1
> Product: USB OHCI Root Hub
> SerialNumber: b0010000
> hub.c: USB hub found
> hub.c: 2 ports detected
> usb.c: registered new driver hid
> hid-core.c: v1.8 Andreas Gal, Vojtech Pavlik <vojtech@suse.cz>
> hid-core.c: USB HID support drivers
> usb.c: registered new driver usblp
> printer.c: v0.8:USB Printer Device Class driver
> Initializing USB Mass Storage driver...
> usb.c: registered new driver usb-storage
> USB Mass Storage support registered.
> mice: PS/2 mouse device common for all mice
> NET4: Linux TCP/IP 1.0 for NET4.0
> IP Protocols: ICMP, UDP, TCP
> IP: routing cache hash table of 512 buckets, 4Kbytes
> TCP: Hash tables configured (established 2048 bind 2048)
> eth0: Setting half-duplex based on auto-negotiated partner ability 0000.
> IP-Config: Guessing netmask 255.0.0.0
> IP-Config: Complete:
>       device=3Deth0, addr=3D10.0.1.3, mask=3D255.0.0.0, gw=3D255.255.255.=
255,
>      host=3D10.0.1.3, domain=3D, nis-domain=3D(none),
>      bootserver=3D255.255.255.255, rootserver=3D10.0.0.157, rootpath=3D
> NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
> hub.c: USB new device connect on bus1/2, assigned device number 2
> Looking up port of RPC 100003/2 on 10.0.0.157
> Looking up port of RPC 100005/1 on 10.0.0.157
> VFS: Mounted root (nfs filesystem).
> Mounted devfs on /dev
> Freeing unused kernel memory: 4k freed
> Manufacturer: ????????????????????????
> Product: ?????????????Aa123456789
> SerialNumber: Aa1234567890
> scsi0 : SCSI emulation for USB Mass Storage devices
> Algorithmics/MIPS FPU Emulator v1.5
> serial console detected.  Disabling virtual terminals.
> init started:  BusyBox v0.60.2 (2002.04.03-20:48+0000) multi-call binary
> 		Welcome to prototype Linux
> Mounting proc filesystem:  [  OK  ]
> Configuring kernel parameters:  [  OK  ]
> Activating swap partitions:  [  OK  ]
> Setting hostname prototype:  [  OK  ]
> Mounting local filesystems:  [  OK  ]
> Enabling swap space:  [  OK  ]
> ^@Entering non-interactive startup
> Starting system logger: [  OK  ]
> Starting kernel logger: [  OK  ]
> Starting xinetd: [  OK  ]
> Setting clock: Fri Dec 31 19:00:18 EST 1999 [  OK  ]
>=20
> prototype login:=20
>=20
>=20
> Thanks for the help!
> Dave
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Money isn't everything, A.J.
AJ: Who convinced you of that?
G:  The Chief, at my last salary review.
					-- Mike and Greg
User Friendly, 11/3/1998

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+c8HCIjReC7bSPZARAobDAJ9eFNxAklY0o6RV7fugcn3kV6y96wCfePbh
IMWZWXn9qZyVG3Ok9v252hI=
=0X5T
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
