From: Olaf Hering <olh@suse.de>
Subject: 2.6.15-git12, slab corruption in ipr
Date: Tue, 17 Jan 2006 01:05:33 +0100
Message-ID: <20060117000533.GA27473@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:28045 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751307AbWAQAFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 19:05:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Brian J King <bjking1@us.ibm.com>

I tested the current Linus tree + a few SuSE patches on a p710. There is
some slab corruption.  Will check if plain Linus tree gives the same...

dmesg | grep -wiC9 slab
sda: Write Protect is off
sda: Mode Sense: cb 00 00 08
SCSI device sda: drive cache: write through
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
sda: Write Protect is off
sda: Mode Sense: cb 00 00 08
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3 sda4
sd 0:0:3:0: Attached scsi disk sda
Slab corruption: start=c000000000431000, len=4096
d80: c0 00 00 00 00 43 1d 80 c0 00 00 00 00 43 1d 80
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28G
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: drive cache: write through
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
sdb: Write Protect is off


Page orders: linear mapping = 24, others = 12
Found initrd at 0xc000000002400000:0xc0000000026e7000
Partition configured for 4 cpus.
Starting Linux PPC64 #1 SMP Mon Jan 16 21:48:18 UTC 2006
-----------------------------------------------------
ppc64_pft_size                = 0x1b
ppc64_interrupt_controller    = 0x2
platform                      = 0x101
physicalMemorySize            = 0x1e8000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0x0000000000000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
[boot]0100 MM Init
[boot]0100 MM Init Done
Linux version 2.6.15-git12-20060116214818-ppc64 (geeko@buildhost) (gcc version 4.1.0 20060109 (prerelease) (SUSE Linux)) #1 SMP Mon Jan 16 21:48:18 UTC 2006
[boot]0012 Setup Arch
Node 0 Memory: 0x0-0x1e8000000
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 7168 bytes
Using dedicated idle loop
On node 0 totalpages: 1998848
  DMA zone: 1998848 pages, LIFO batch:31
  DMA32 zone: 0 pages, LIFO batch:0
  Normal zone: 0 pages, LIFO batch:0
  HighMem zone: 0 pages, LIFO batch:0
[boot]0015 Setup Done
Built 1 zonelists
Kernel command line: root=/dev/sdd3 quiet sysrq=1 xmon=on 
[boot]0020 XICS Init
xics: no ISA interrupt controller
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 131072 bytes)
time_init: decrementer frequency = 207.051000 MHz
time_init: processor frequency   = 1656.408000 MHz
Console: colour dummy device 80x25
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
freeing bootmem node 0
Memory: 7838780k/7995392k available (4304k kernel code, 156612k reserved, 1936k data, 836k bss, 252k init)
Calibrating delay loop... 413.69 BogoMIPS (lpj=2068480)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
checking if image is initramfs... it is
Freeing initrd memory: 2972k freed
Processor 1 found.
Processor 2 found.
Processor 3 found.
Brought up 4 CPUs
Node 0 CPUs: 0-3
migration_cost=1,0
NET: Registered protocol family 16
Installing base platform functions...
All base functions installed
PCI: Probing PCI hardware
IOMMU table initialized, virtual merging enabled
mapping IO 3fe00200000 -> d000080000000000, size: 100000
mapping IO 3fe00700000 -> d000080000100000, size: 100000
PCI: Probing PCI hardware done
Registering pmac pic with sysfs...
usbcore: registered new driver usbfs
usbcore: registered new driver hub
TC classifier action (bugs to netdev@vger.kernel.org cc hadi@cyberus.ca)
IBM eBus Device Driver
probe_bus_pseries: processing c0000001e7ff9df0
RTAS daemon started
RTAS: event: 1, Type: Platform Error, Severity: 2
probe_bus_pseries: processing c0000001e7ff9fb8
probe_bus_pseries: processing c0000001e7ffa100
probe_bus_pseries: processing c0000001e7ffa268
audit: initializing netlink socket (disabled)
audit(1137455211.949:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Using unsupported 640x480 display at 401f0000000, depth=8, pitch=640
Console: switching to colour frame buffer device 80x30
fb0: Open Firmware frame buffer device on /pci@800000020000003/pci@2,2/pci@1/display@0
vio_register_driver: driver hvc_console registering
HVSI: registered 0 devices
Generic RTC Driver v1.07
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
RAMDISK driver initialized: 16 RAM disks of 123456K size 1024 blocksize
loop: loaded (max 8 devices)
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PDC20275: IDE controller at PCI slot 0000:cc:01.0
PCI: Enabling device: (0000:cc:01.0), cmd 3
PDC20275: chipset revision 1
PDC20275: 100% native mode on irq 134
    ide2: BM-DMA at 0xdec00-0xdec07, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0xdec08-0xdec0f, BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: IBM RMBO0020501, ATAPI CD/DVD-ROM drive
ide2 at 0xde400-0xde407,0xddc02 on irq 134
Probing IDE interface ide3...
Probing IDE interface ide3...
PCI: Enabling device: (0000:c8:01.2), cmd 142
ehci_hcd 0000:c8:01.2: EHCI Host Controller
ehci_hcd 0000:c8:01.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:c8:01.2: irq 133, io mem 0x400b0002000
ehci_hcd 0000:c8:01.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: 2005 April 22 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ohci_hcd 0000:c8:01.0: OHCI Host Controller
ohci_hcd 0000:c8:01.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:c8:01.0: irq 133, io mem 0x400b0001000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
hub 2-0:1.0: over-current change on port 1
ohci_hcd 0000:c8:01.1: OHCI Host Controller
ohci_hcd 0000:c8:01.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:c8:01.1: irq 133, io mem 0x400b0000000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: over-current change on port 1
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
mice: PS/2 mouse device common for all mice
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
oprofile: using ppc64/power5 performance monitoring.
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 12, 16777216 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Freeing unused kernel memory: 252k freed
SCSI subsystem initialized
ipr: IBM Power RAID SCSI Device Driver version: 2.1.1 (November 15, 2005)
ipr 0000:d0:01.0: Found IOA with IRQ: 135
ipr 0000:d0:01.0: Starting IOA initialization sequence.
ipr 0000:d0:01.0: Adapter firmware version: 020A0052
ipr 0000:d0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28G
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
sda: Write Protect is off
sda: Mode Sense: cb 00 00 08
SCSI device sda: drive cache: write through
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
sda: Write Protect is off
sda: Mode Sense: cb 00 00 08
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3 sda4
sd 0:0:3:0: Attached scsi disk sda
Slab corruption: start=c000000000431000, len=4096
d80: c0 00 00 00 00 43 1d 80 c0 00 00 00 00 43 1d 80
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28G
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: drive cache: write through
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: drive cache: write through
 sdb: sdb1
sd 0:0:4:0: Attached scsi disk sdb
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28G
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
sd 0:0:3:0: Attached scsi generic sg0 type 0
sd 0:0:4:0: Attached scsi generic sg1 type 0
sdc: Write Protect is off
sdc: Mode Sense: cb 00 00 08
SCSI device sdc: drive cache: write through
SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
sdc: Write Protect is off
sdc: Mode Sense: cb 00 00 08
SCSI device sdc: drive cache: write through
 sdc: sdc1
sd 0:0:5:0: Attached scsi disk sdc
sd 0:0:5:0: Attached scsi generic sg2 type 0
  Vendor: IBM       Model: IC35L036UCDY10-0  Rev: S28G
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdd: 71096640 512-byte hdwr sectors (36401 MB)
sdd: Write Protect is off
sdd: Mode Sense: cb 00 00 08
SCSI device sdd: drive cache: write through
SCSI device sdd: 71096640 512-byte hdwr sectors (36401 MB)
sdd: Write Protect is off
sdd: Mode Sense: cb 00 00 08
SCSI device sdd: drive cache: write through
 sdd: sdd1 sdd2 sdd3
sd 0:0:8:0: Attached scsi disk sdd
sd 0:0:8:0: Attached scsi generic sg3 type 0
  Vendor: IBM       Model: VSBPD4E2  U4SCSI  Rev: 4142
  Type:   Enclosure                          ANSI SCSI revision: 02
 0:0:15:0: Attached scsi generic sg4 type 13
scsi: unknown device type 31
  Vendor: IBM       Model: 570B001           Rev: 0150
  Type:   Unknown                            ANSI SCSI revision: 00
 0:255:255:255: Attached scsi generic sg5 type 31
ReiserFS: sdd3: found reiserfs format "3.6" with standard journal
ReiserFS: sdd3: using ordered data mode
ReiserFS: sdd3: journal params: device sdd3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdd3: checking transaction log (sdd3)
ReiserFS: sdd3: Using r5 hash to sort names
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdc1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1>
md: bind<sdc1>
md: running: <sdc1><sdb1>
md: kicking non-fresh sdc1 from array!
md: unbind<sdc1>
md: export_rdev(sdc1)
device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
dm-netlink version 0.0.2 loaded
md: raid1 personality registered for level 1
raid1: raid set md0 active with 1 out of 2 mirrors
md: ... autorun DONE.
hde: ATAPI 31X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ts: Compaq touchscreen protocol output
Intel(R) PRO/1000 Network Driver - version 6.1.16-k2-NAPI
Copyright (c) 1999-2005 Intel Corporation.
PCI: Enabling device: (0000:c0:01.0), cmd 143
Intel(R) PRO/10GbE Network Driver - version 1.0.100-k2-NAPI
Copyright (c) 1999-2005 Intel Corporation.
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
PCI: Enabling device: (0000:c0:01.1), cmd 143
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
PCI: Enabling device: (0001:d8:01.0), cmd 143
eth0: Intel(R) PRO/10GbE Network Connection
Adding 1050616k swap on /dev/sda2.  Priority:-1 extents:1 across:1050616k
Adding 2096472k swap on /dev/sdd2.  Priority:-2 extents:1 across:2096472k
ioctl32(hald-probe-inpu:3250): Unknown cmd fd(4) cmd(40084502){00} arg(ffbdb95a) on /dev/input/ts0
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
subfs 0.9
ADDRCONF(NETDEV_UP): eth1: link is not ready
ISO 9660 Extensions: RRIP_1991A
e1000: eth1: e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
