From: Olaf Hering <olh@suse.de>
Subject: 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Thu, 10 Feb 2005 11:56:50 +0100
Message-ID: <20050210105650.GA1070@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I see a few refcount handling bugs in the scsi and/or usb layer.
With a vanilla kernel, plugging an usb stick in , and remove it a few
times:


usb 2-1: USB disconnect, address 4
Oops: kernel access of bad area, sig: 11 [#1]
NIP: CDD3E424 LR: CDD05398 SP: C9713F40 REGS: c9713e90 TRAP: 0300    Not tainted
MSR: 00009032 EE: 1 PR: 0 FP: 0 ME: 1 IR/DR: 11
DAR: 00000130, DSISR: 40000000
TASK = cae312c0[6674] 'scsi_eh_2' THREAD: c9712000
Last syscall: -1 
GPR00: 00010718 C9713F40 CAE312C0 00000000 CDD146D0 00000001 00000000 00009032 
GPR08: CAABF078 00000000 CB604800 C2801200 44088028 00000000 C07C67B8 00000004 
GPR16: C07D8B9A C07D69D0 CDD30000 C9713F90 C03B286C C03433D8 C9713FA8 CDD30000 
GPR24: CAABF078 00000000 C2801200 00000000 C9713FA0 CAABF078 FFFFFFF0 C1711600 
NIP [cdd3e424] bus_reset+0x64/0x134 [usb_storage]
LR [cdd05398] scsi_try_bus_reset+0x8c/0x104 [scsi_mod]
Call trace:
 [cdd05398] scsi_try_bus_reset+0x8c/0x104 [scsi_mod]
 [cdd068c4] scsi_error_handler+0x86c/0xe68 [scsi_mod]
 [c0006c2c] kernel_thread+0x44/0x60


Total memory = 192MB; using 512kB for hash table (at c0500000)
Linux version 2.6.11-rc3-bk5-200502100455-usbtest (abuild@pomegranate) (gcc version 3.3.5 20050117 (prerelease) (SUSE Linux)) #1 Thu Feb 10 05:07:02 UTC 2005
Found UniNorth memory controller & host bridge, revision: 8
Mapped at 0xfdf00000
Found a Keylargo mac-io controller, rev: 3, mapped at 0xfde80000
Processor NAP mode on idle enabled.
PowerMac motherboard: PowerBook Pismo
Found UniNorth PCI host bridge at 0xf0000000. Firmware bus number: 0->0
Found UniNorth PCI host bridge at 0xf2000000. Firmware bus number: 0->1
Found UniNorth PCI host bridge at 0xf4000000. Firmware bus number: 0->0
via-pmu: Server Mode is disabled
PMU driver 2 initialized for Core99, firmware: 0c
nvram: Checking bank 0...
nvram: gen0=172, gen1=171
nvram: Active bank is: 0
nvram: OF partition at 0x210
nvram: XP partition at 0x1220
nvram: NR partition at 0x1320
On node 0 totalpages: 49152
  DMA zone: 49152 pages, LIFO batch:12
  Normal zone: 0 pages, LIFO batch:1
  HighMem zone: 0 pages, LIFO batch:1
Built 1 zonelists
Kernel command line: root=/dev/hda12 selinux=0 elevator=as quiet 
PowerMac using OpenPIC irq controller at 0x80040000
OpenPIC Version 1.2 (4 CPUs and 64 IRQ sources) at fc62f000
OpenPIC timer frequency is 4.166666 MHz
PID hash table entries: 1024 (order: 10, 16384 bytes)
GMT Delta read from XPRAM: 60 minutes, DST: off
time_init: decrementer frequency = 24.966218 MHz
Console: colour dummy device 80x25
pmac_zilog: i2c-modem detected, id: 1
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 188000k available (2884k kernel code, 1828k data, 208k init, 0k highmem)
AGP special page: 0xcbfff000
Calibrating delay loop... 796.67 BogoMIPS (lpj=398336)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
Freeing initrd memory: 1084k freed
NET: Registered protocol family 16
PCI: Probing PCI hardware
Can't get bus-range for /pci@f2000000/cardbus@1a, assuming it starts at 0
Registering openpic with sysfs...
Linux Plug and Play Support v0.97 (c) Adam Belay
usbcore: registered new driver usbfs
usbcore: registered new driver hub
TC classifier action (bugs to netdev@oss.sgi.com cc hadi@cyberus.ca)
Thermal assist unit using timers, shrink_timer: 2000 jiffies
audit: initializing netlink socket (disabled)
audit(1108027661.271:0): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
PCI: Enabling device 0000:00:10.0 (0086 -> 0087)
aty128fb: Invalid ROM signature 0 should be 0xaa55
aty128fb: BIOS not located, guessing timings.
aty128fb: Rage128 LF M3 AGP [chip rev 0x0] 8M 128-bit SDR SGRAM (1:1)
Console: switching to colour frame buffer device 128x48
Registered "ati" backlight controller, level: 10/15
fb0: ATY Rage128 frame buffer device on Rage128 LF M3 AGP
no framebuffer address found for /pci@f0000000/ATY,RageM3pParent@10/ATY,RageM3pB
isapnp: Write Data Register 0xa79 already used
Generic RTC Driver v1.07
Macintosh non-volatile memory driver v1.1
serial8250_init: nothing to do on this board
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
ttyS0 at MMIO 0x80013020 (irq = 22) is a Z85c30 ESCC - Internal modem
ttyS1 at MMIO 0x80013000 (irq = 23) is a Z85c30 ESCC - Infrared port
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Floppy drive(s): fd0 is 2.88M
IN from bad port 3f4 at c01e2774
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 123456K size 1024 blocksize
loop: loaded (max 8 devices)
MacIO PCI driver attached to Keylargo chipset
mediabay0: Registered KeyLargo media-bay
mediabay0: powering down
mediabay0: switching to 3
mediabay0: powering up
mediabay0: enabling (kind:3)
mediabay0: waiting reset (kind:3)
mediabay0: waiting IDE reset (kind:3)
mediabay0: waiting IDE ready (kind:3)
mediabay0: up before IDE init
input: Macintosh mouse button emulation
apm_emu: APM Emulation 0.5 initialized.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
adb: starting probe task...
adb devices: [2]: 2 c3 [3]: 3 1 [7]: 7 1f
ADB keyboard at 2, handler 1
Detected ADB keyboard, type ANSI.
input: ADB keyboard on adb2:2.c3/input
input: ADB Powerbook buttons on adb7:7.1f/input
ADB mouse at 3, handler set to 4 (trackpad)
input: ADB mouse on adb3:3.01/input
adb: finished probe task...
ide0: Found Apple KeyLargo ATA-4 controller, bus ID 2, irq 19
Probing IDE interface ide0...
hda: TOSHIBA MK1016GAP, ATA DISK drive
hda: Enabling Ultra DMA 4
ide0 at 0xcd01c000-0xcd01c007,0xcd01c160 on irq 19
ide1: Found Apple KeyLargo ATA-3 controller, bus ID 1, irq 21
Probing IDE interface ide1...
ide1: Bus empty, interface released.
Registered ide1 for media bay 0
ide1: Found Apple KeyLargo ATA-3 controller, bus ID 0 (mediabay), irq 20
Probing IDE interface ide1...
hdc: LG DVD-ROM DRN-8080B, ATAPI CD/DVD-ROM drive
hdc: Enabling MultiWord DMA 2
ide1 at 0xcd01e000-0xcd01e007,0xcd01e160 on irq 20
hda: max request size: 128KiB
hda: 19640880 sectors (10056 MB), CHS=19485/16/63, UDMA(66)
hda: cache flushes not supported
 hda: [mac] hda1 hda2 hda3 hda4 hda5 hda6 hda7 hda8 hda9 hda10 hda11 hda12 hda13
hdc: ATAPI 23X DVD-ROM drive, 512kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ohci_hcd: 2004 Nov 08 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
PCI: Enabling device 0001:10:18.0 (0000 -> 0002)
ohci_hcd 0001:10:18.0: OHCI Host Controller
ohci_hcd 0001:10:18.0: irq 27, pci mem 0xa0002000
ohci_hcd 0001:10:18.0: new USB bus registered, assigned bus number 1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PCI: Enabling device 0001:10:19.0 (0000 -> 0002)
ohci_hcd 0001:10:19.0: OHCI Host Controller
ohci_hcd 0001:10:19.0: irq 28, pci mem 0xa0001000
ohci_hcd 0001:10:19.0: new USB bus registered, assigned bus number 2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
mice: PS/2 mouse device common for all mice
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
NET: Registered protocol family 1
NET: Registered protocol family 17
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
RAMDISK: Compressed image found at block 0
VFS: Mounted root (ext2 filesystem).
udev[637]: removing device node '/dev/vcs1'
udev[638]: removing device node '/dev/vcsa1'
ReiserFS: hda12: found reiserfs format "3.6" with standard journal
ReiserFS: hda12: using ordered data mode
ReiserFS: hda12: journal params: device hda12, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda12: checking transaction log (hda12)
ReiserFS: hda12: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Trying to move old root to /initrd ... failed
Unmounting old root
Trying to free ramdisk memory ... okay
Freeing unused kernel memory: 208k init 4k chrp 32k prep
Adding 130560k swap on /dev/hda11.  Priority:42 extents:1
Linux agpgart interface v0.100 (c) Dave Jones
agpgart: Detected Apple UniNorth chipset
agpgart: Maximum main memory to use for agp memory: 150M
agpgart: configuring for size idx: 4
agpgart: AGP aperture is 16M @ 0x0
Linux Kernel Card Services
  options:  [pci] [cardbus] [pm]
PCI: 0001:10:1a.0 has unsupported PM cap regs version (1)
Yenta: CardBus bridge found at 0001:10:1a.0 [0000:0000]
PCI: 0001:10:1a.0 has unsupported PM cap regs version (1)
yenta 0001:10:1a.0: Preassigned resource 2 busy, reconfiguring...
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0001:10:1a.0, mfunc 0x00000002, devctl 0x60
Yenta: ISA IRQ mask 0x0000, PCI irq 58
Socket status: 30000006
ieee1394: Initialized config rom entry `ip1394'
ohci1394: $Rev: 1223 $ Ben Collins <bcollins@debian.org>
ohci1394: fw-host0: Unexpected PCI resource length of 1000!
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]
ohci1394: fw-host0: SelfID received outside of bus reset sequence
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[003065fffeb051c8]
ieee1394: got invalid ack 252 from node 65535 (tcode 0)
sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:30:65:b0:51:c8 
PHY ID: 406212, addr: 0
eth0: Found BCM5201 PHY
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
SCSI subsystem initialized
st: Version 20041025, fixed bufsize 32768, s/g segs 256
Warning: /proc/ide/hd?/settings interface is obsolete, and will be removed soon!
ieee1394: raw1394: /dev/raw1394 device initialized
video1394: Installed video1394 module
NET: Registered protocol family 10
Disabled Privacy Extensions on device c0357410(lo)
IPv6 over IPv4 tunneling driver
PHY ID: 406212, addr: 0
eth0: Link is up at 100 Mbps, full-duplex.
eth0: Pause is disabled
i2c /dev entries driver
usb 2-1: new full speed USB device using ohci_hcd and address 2
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
  Vendor:           Model: Pen Drive 2.0     Rev: 1.01
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sda: 507904 512-byte hdwr sectors (260 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
SCSI device sda: 507904 512-byte hdwr sectors (260 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
 sda: sda1
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
usb-storage: device scan complete
usb 2-1: USB disconnect, address 2
usb 2-1: new full speed USB device using ohci_hcd and address 3
scsi1 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
  Vendor:           Model: Pen Drive 2.0     Rev: 1.01
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sda: 507904 512-byte hdwr sectors (260 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
SCSI device sda: 507904 512-byte hdwr sectors (260 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
 sda: sda1
Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi1, channel 0, id 0, lun 0,  type 0
usb-storage: device scan complete
usb 2-1: USB disconnect, address 3
usb 2-1: new full speed USB device using ohci_hcd and address 4
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
  Vendor:           Model: Pen Drive 2.0     Rev: 1.01
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sda: 507904 512-byte hdwr sectors (260 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
SCSI device sda: 507904 512-byte hdwr sectors (260 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: assuming drive cache: write through
 sda: sda1
Attached scsi removable disk sda at scsi2, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi2, channel 0, id 0, lun 0,  type 0
usb-storage: device scan complete
sda : READ CAPACITY failed.
sda : status=0, message=00, host=7, driver=00 
sda : sense not available. 
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
sda: assuming drive cache: write through
usb 2-1: USB disconnect, address 4
Oops: kernel access of bad area, sig: 11 [#1]
NIP: CDD3E424 LR: CDD05398 SP: C9713F40 REGS: c9713e90 TRAP: 0300    Not tainted
MSR: 00009032 EE: 1 PR: 0 FP: 0 ME: 1 IR/DR: 11
DAR: 00000130, DSISR: 40000000
TASK = cae312c0[6674] 'scsi_eh_2' THREAD: c9712000
Last syscall: -1 
GPR00: 00010718 C9713F40 CAE312C0 00000000 CDD146D0 00000001 00000000 00009032 
GPR08: CAABF078 00000000 CB604800 C2801200 44088028 00000000 C07C67B8 00000004 
GPR16: C07D8B9A C07D69D0 CDD30000 C9713F90 C03B286C C03433D8 C9713FA8 CDD30000 
GPR24: CAABF078 00000000 C2801200 00000000 C9713FA0 CAABF078 FFFFFFF0 C1711600 
NIP [cdd3e424] bus_reset+0x64/0x134 [usb_storage]
LR [cdd05398] scsi_try_bus_reset+0x8c/0x104 [scsi_mod]
Call trace:
 [cdd05398] scsi_try_bus_reset+0x8c/0x104 [scsi_mod]
 [cdd068c4] scsi_error_handler+0x86c/0xe68 [scsi_mod]
 [c0006c2c] kernel_thread+0x44/0x60

----- End forwarded message -----


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
