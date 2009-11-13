From: tmhikaru@gmail.com
Subject: Weird I/O errors with USB hard drive not remounting filesystem readonly
Date: Fri, 13 Nov 2009 00:09:07 -0500
Message-ID: <20091113050907.GA4965@roll>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:43753 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZKMFJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2009 00:09:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org

	Hi. I already tried sending this email to the lkml a couple of days
ago. (With the subject re: 2.6.31.6) As I've gotten no response, and this
has been a problem for close to a month for me now, I've tried emailing
people (and other mailing lists) that may have a better clue of what's going
on here. I don't know what is going on here, so I've emailed the block
maintainer, ext4 filesystems list, usb mailing list, and scsi mailing list.
If I've reached you in error, and I have not actually sent this email to the
correct party, please inform me whom I should have sent this to. Thank you.

	As I've had with the last few kernel releases in the 2.6.31.x
series, I'm still having a problem where I'm constantly getting seemingly
random I/O errors in dmesg output for my external usb hard drive. The thing
that worries me is that although my ext4 filesystem is configured to remount
readonly when problems occur, it is not in fact doing so. Does this mean the
error is transient, worked around, and I can ignore it, or ... what?

Specifically it is these messages I'm recieving whenever I do heavy duty
work with the drive that worries me:

sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sda, sector 79713943


Note that the sector number is never the same, and has never been the same
over a month's worth of I/O errors, but the unhandled error code result
always stays the same, though that also does not always show up.

In my attempts to determine if there's some sort of filesystem corruption
going on I haven't been able to find any problems - files that were changed
while the I/O errors seemed to be being generated are in fact perfect copies
according to md5sum.

I *really* need to know exactly what is going on here. Worst case scenario I
can think of is that the hard drive is going bad, but the symptoms don't
seem to bear that out. I need to know what the error messages - combined
with the the filesystem behavior (NOT remounting readonly) - mean.

I use the usb drive (a 250gb seagate using a rosewill external usb kit) to
backup two 120GB internal maxtors using rsync. These are all IDE hard
drives.

I would appreciate any tips on how I can determine if linux is working
around the problem silently on its own, or not.

The rest of this email includes dmesg output and various filesystem settings
I've set. Note in the dmesg output I plugged in and turned on the drive,
mounted it and poked around a bit, then unmounted it and ran my backup
script (Which e2fsck's it, mounts it, runs rsync to do the actual backup,
then unmounts it when it's done)


smartctl -H /dev/sda:
smartctl version 5.38 [i486-slackware-linux-gnu] Copyright (C) 2002-8 Bruce
Allen
Home page is http://smartmontools.sourceforge.net/

SMART Health Status: OK


fstab:

/dev/hda1        /                ext4 defaults,barrier=1               1 1
/dev/hdb1        /home/tm/stuff   ext4 defaults,user,barrier=1,noauto   0 1
/dev/sda1        /backup          ext4 defaults,barrier=1,noauto        0 0
/swap            none             swap  sw                              0 0
/dev/cdrom       /cdrom           auto        noauto,owner,ro           0 0
#/dev/fd0         /mnt/floppy      auto        noauto,owner             0 0
devpts           /dev/pts         devpts      gid=5,mode=620            0 0
proc             /proc            proc        defaults                  0 0



tune2fs -l /dev/sda1:

tune2fs 1.41.8 (11-July-2009)
Filesystem volume name:   <none>
Last mounted on:          /backup
Filesystem UUID:          f624b34a-80d4-422d-9c9e-4c3898b20d03
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Remount read-only
Filesystem OS type:       Linux
Inode count:              15269888
Block count:              61049000
Reserved block count:     0
Free blocks:              11536553
Free inodes:              14717189
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1009
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Wed Oct 14 00:19:20 2009
Last mount time:          Thu Nov 12 02:27:48 2009
Last write time:          Thu Nov 12 02:36:22 2009
Mount count:              6
Maximum mount count:      38
Last checked:             Mon Nov  9 11:59:38 2009
Check interval:           15552000 (6 months)
Next check after:         Sat May  8 12:59:38 2010
Lifetime writes:          204 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      0a63a3e0-f270-41bd-8593-5fe644a69444
Journal backup:           inode blocks


dmesg:

Linux version 2.6.31.6 (root@roll) (gcc version 4.3.3 (GCC) ) #1 Tue Nov 10
22:41:09 EST 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 00000000000ea000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
 BIOS-e820: 000000005fff0000 - 000000005fff8000 (ACPI data)
 BIOS-e820: 000000005fff8000 - 0000000060000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
DMI 2.3 present.
last_pfn = 0x5fff0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 base 040000000 mask FE0000000 write-back
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 base 0D0000000 mask FF8000000 write-combining
initial memory mapped : 0 - 01800000
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 7000-c000
ACPI: RSDP 000fa260 00014 (v00 AMI   )
ACPI: RSDT 5fff0000 0002C (v01 AMIINT SiS740XX 00001000 MSFT 0100000B)
ACPI: FACP 5fff0030 00081 (v01 AMIINT SiS740XX 00000011 MSFT 0100000B)
ACPI: DSDT 5fff0110 034D2 (v01    SiS      740 00000100 MSFT 0100000D)
ACPI: FACS 5fff8000 00040
ACPI: APIC 5fff00c0 00050 (v01 AMIINT SiS740XX 00001000 MSFT 0100000B)
ACPI: Local APIC address 0xfee00000
647MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
  node 0 low ram: 00000000 - 377fe000
  node 0 bootmap 00008000 - 0000ef00
(6 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
  #0000001000]
  #1 [0001000000 - 0001605bd8]    TEXT DATA BSS ==> [0001000000 -
  #0001605bd8]
  #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 -
  #0000100000]
  #3 [0001606000 - 000160c0dc]              BRK ==> [0001606000 -
  #000160c0dc]
  #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 -
  #0000008000]
  #5 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 -
  #000000f000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0005fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0005fff0
On node 0 totalpages: 393103
free_area_init_node: node 0, pgdat c154b660, node_mem_map c160d000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 1296 pages used for memmap
  HighMem zone: 164578 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 00000000000ea000
PM: Registered nosave memory: 00000000000ea000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 60000000 (gap: 60000000:9ec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 390031
Kernel command line: BOOT_IMAGE=Linux ro root=301 vt.default_utf8=0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0005fff0)
Memory: 1552220k/1572800k available (4017k kernel code, 19312k reserved,
1431k data, 376k init, 663496k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc1553000 - 0xc15b1000   ( 376 kB)
      .data : 0xc13ec426 - 0xc1552128   (1431 kB)
      .text : 0xc1000000 - 0xc13ec426   (4017 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:288
Fast TSC calibration using PIT
Detected 2083.004 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Calibrating delay loop (skipped), value calculated using timer frequency..
4166.00 BogoMIPS (lpj=2083004)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
mce: CPU supports 4 MCE banks
Performance Counters: AMD PMU driver.
... version:                 0
... bit width:               48
... generic counters:        4
... value mask:              0000ffffffffffff
... max period:              00007fffffffffff
... fixed-purpose counters:  0
... counter mask:            000000000000000f
CPU: AMD Athlon(tm) XP 2800+ stepping 00
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090521
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  2740.000 MB/sec
xor: using function: pIII_sse (2740.000 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=2
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:00:02.0: Enabling SiS 96x SMBus
pci 0000:00:02.1: reg 20 io port: [0xc00-0xc1f]
pci 0000:00:02.5: reg 20 io port: [0xff00-0xff0f]
pci 0000:00:03.0: reg 10 32bit mmio: [0xcfffe000-0xcfffefff]
pci 0000:00:03.1: reg 10 32bit mmio: [0xcffff000-0xcfffffff]
pci 0000:00:03.2: reg 10 32bit mmio: [0xcffdf000-0xcffdffff]
pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
pci 0000:00:03.2: PME# disabled
pci 0000:00:04.0: reg 10 io port: [0xdc00-0xdcff]
pci 0000:00:04.0: reg 14 32bit mmio: [0xcfffd000-0xcfffdfff]
pci 0000:00:04.0: reg 30 32bit mmio: [0xcffa0000-0xcffbffff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:0a.0: reg 10 io port: [0xd800-0xd8ff]
pci 0000:00:0a.0: reg 14 32bit mmio: [0xcfffcf00-0xcfffcfff]
pci 0000:00:0a.0: reg 30 32bit mmio: [0xcffe0000-0xcffeffff]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0c.0: reg 10 io port: [0xd400-0xd43f]
pci 0000:00:0c.0: supports D2
pci 0000:01:00.0: reg 10 64bit mmio: [0xb0000000-0xbfffffff]
pci 0000:01:00.0: reg 18 64bit mmio: [0xcfef0000-0xcfefffff]
pci 0000:01:00.0: reg 20 io port: [0xb800-0xb8ff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xcfec0000-0xcfedffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 64bit mmio: [0xcfee0000-0xcfeeffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
pci 0000:00:01.0: bridge 32bit mmio: [0xcfd00000-0xcfefffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xafa00000-0xcfbfffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *10 11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int32x1    898 MB/s
raid6: int32x2    914 MB/s
raid6: int32x4    722 MB/s
raid6: int32x8    640 MB/s
raid6: mmxx1     1675 MB/s
raid6: mmxx2     3050 MB/s
raid6: sse1x1    1613 MB/s
raid6: sse1x2    2609 MB/s
raid6: using algorithm sse1x2 (2609 MB/s)
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x290-0x297 has been reserved
system 00:01: ioport range 0x480-0x48f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0xc00-0xc1f has been reserved
system 00:01: ioport range 0x3f0-0x3f1 has been reserved
system 00:01: iomem range 0xfee00000-0xfeefffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xb000-0xbfff
pci 0000:00:01.0:   MEM window: 0xcfd00000-0xcfefffff
pci 0000:00:01.0:   PREFETCH window: 0xafa00000-0xcfbfffff
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
pci_bus 0000:01: resource 1 mem: [0xcfd00000-0xcfefffff]
pci_bus 0000:01: resource 2 pref mem [0xafa00000-0xcfbfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
ROMFS MTD (C) 2007 Red Hat, Inc.
msgmni has been set to 1737
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
async_tx: api initialized (async)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Switched to NOHz mode on CPU #0
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
Uniform Multi-Platform E-IDE driver
sis5513 0000:00:02.5: SiS 962/963 MuTIOL IDE UDMA133 controller
sis5513 0000:00:02.5: IDE controller (0x1039:0x5513 rev 0x00)
sis5513 0000:00:02.5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xff00-0xff07
    ide1: BM-DMA at 0xff08-0xff0f
Probing IDE interface ide0...
hda: Maxtor 6Y120L0, ATA DISK drive
hdb: Maxtor 6Y120P0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/133 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/133 mode selected
Probing IDE interface ide1...
hdc: HL-DT-STDVD-RAM GSA-H55N, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1
hdb: max request size: 128KiB
hdb: 240121728 sectors (122942 MB) w/7936KiB Cache, CHS=65535/16/63
hdb: cache flushes supported
 hdb: hdb1
ide-cd driver 5.00
ide-cd: hdc: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:
dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input1
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT4-fs (hda1): barriers enabled
kjournald2 starting: pid 1091, dev hda1:8, commit interval 5 seconds
EXT4-fs (hda1): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (hda1): mounted filesystem with ordered data mode
VFS: Mounted root (ext4 filesystem) readonly on device 3:1.
Freeing unused kernel memory: 376k freed
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
ACPI: Power Button [PWRB]
input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
ACPI: Sleep Button [SLPB]
sis900.c: v1.08.10 Apr. 2 2006
sis900 0000:00:04.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
0000:00:04.0: VIA 6103 PHY transceiver found at address 1.
0000:00:04.0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0xdc00, IRQ 19, 00:19:21:9b:5b:e7
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:03.2: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:03.2: EHCI Host Controller
ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.2: cache line size of 64 is not supported
ehci_hcd 0000:00:03.2: irq 23, io mem 0xcffdf000
8139too Fast Ethernet driver 0.9.28
ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.31.6 ehci_hcd
usb usb1: SerialNumber: 0000:00:03.2
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
8139too 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
eth1: RealTek RTL8139 at 0xd800, 00:e0:29:9b:1a:15, IRQ 18
processor LNXCPU:00: registered as cooling_device0
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 114 bytes nvram
input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input5
Linux agpgart interface v0.103
agpgart-sis 0000:00:00.0: SiS chipset [1039/0746]
agpgart-sis 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
ACPI: I/O resource 0000:00:02.1 [0xc00-0xc1f] conflicts with ACPI region
SMRG [0xc00-0xc1f]
ACPI: If an ACPI driver is available for this device, you should use it
instead of the native driver
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 20, io mem 0xcfffe000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.31.6 ohci_hcd
usb usb2: SerialNumber: 0000:00:03.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd 0000:00:03.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 21, io mem 0xcffff000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.31.6 ohci_hcd
usb usb3: SerialNumber: 0000:00:03.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ENS1371 0000:00:0c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ppdev: user-space parallel port driver
usb 3-3: new low speed USB device using ohci_hcd and address 2
usb 3-3: New USB device found, idVendor=0428, idProduct=4001
usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-3: Product: GamePad Pro USB
usb 3-3: Manufacturer: Gravis
usb 3-3: configuration #1 chosen from 1 choice
fuse init (API version 7.12)
EXT4-fs (hda1): internal journal on hda1:8
hda: UDMA/133 mode selected
hdb: UDMA/133 mode selected
hdc: UDMA/66 mode selected
usbcore: registered new interface driver hiddev
input: Gravis GamePad Pro USB  as
/devices/pci0000:00/0000:00:03.1/usb3/3-3/3-3:1.0/input/input6
generic-usb 0003:0428:4001.0001: input,hidraw0: USB HID v1.00 Gamepad
/[Gravis GamePad Pro USB ] on usb-0000:00:03.1-3/input0
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
PPP generic driver version 2.4.2
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0
uhci_hcd: USB Universal Host Controller Interface driver
input: PC Speaker as /devices/platform/pcspkr/input/input7
it87: Found IT8705F chip at 0x290, revision 3
Adding 2097144k swap on /swap.  Priority:-1 extents:3 across:2793464k
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
eth1: no IPv6 routers present
warning: quid' uses 32-bit capabilities (legacy support in use)
u32 classifier
    Actions configured
eth0: Media Link On 100mbps full-duplex
PPP BSD Compression module registered
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
eth0: no IPv6 routers present
agpgart-sis 0000:00:00.0: AGP 3.0 bridge
agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart-sis 0000:00:00.0: SiS delay workaround: giving bridge time to
recover
agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R500 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
[drm] Num pipes: 1
mtrr: MTRR 2 not used
agpgart-sis 0000:00:00.0: AGP 3.0 bridge
agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart-sis 0000:00:00.0: SiS delay workaround: giving bridge time to
recover
agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R500 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
usb 1-4: new high speed USB device using ehci_hcd and address 3
usb 1-4: New USB device found, idVendor=067b, idProduct=2506
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: Mass Storage Device
usb 1-4: Manufacturer: Prolific Technology Inc.
usb 1-4: SerialNumber: 0
usb 1-4: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
scsi 0:0:0:0: Direct-Access     ST325082 3A               3.06 PQ: 0 ANSI: 0
usb-storage: device scan complete
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 03 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda:
sd 0:0:0:0: Attached scsi generic sg0 type 0
 sda1
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI disk
EXT4-fs (sda1): barriers enabled
kjournald2 starting: pid 3390, dev sda1:8, commit interval 5 seconds
EXT4-fs (sda1): internal journal on sda1:8
EXT4-fs (sda1): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (sda1): mounted filesystem with ordered data mode
EXT4-fs: mballoc: 5780 blocks 36 reqs (13 success)
EXT4-fs: mballoc: 28 extents scanned, 2 goal hits, 26 2^N hits, 0 breaks, 0
lost
EXT4-fs: mballoc: 113 generated and it took 1911664
EXT4-fs: mballoc: 3961 preallocated, 3449 discarded
EXT4-fs (sda1): barriers enabled
kjournald2 starting: pid 3411, dev sda1:8, commit interval 5 seconds
EXT4-fs (sda1): internal journal on sda1:8
EXT4-fs (sda1): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (sda1): mounted filesystem with ordered data mode
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sda, sector 79713943
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sda, sector 79714231
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sda, sector 61431
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sda, sector 4223935
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sda, sector 8417519
EXT4-fs (hdb1): barriers enabled
kjournald2 starting: pid 3539, dev hdb1:8, commit interval 5 seconds
EXT4-fs (hdb1): internal journal on hdb1:8
EXT4-fs (hdb1): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (hdb1): mounted filesystem with ordered data mode
EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0
lost
EXT4-fs: mballoc: 0 generated and it took 0
EXT4-fs: mballoc: 0 preallocated, 0 discarded
EXT4-fs: mballoc: 452074 blocks 31860 reqs (29968 success)
EXT4-fs: mballoc: 2099 extents scanned, 263 goal hits, 2028 2^N hits, 0
breaks, 0 lost
EXT4-fs: mballoc: 1208 generated and it took 19874212
EXT4-fs: mballoc: 318579 preallocated, 48300 discarded
