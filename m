From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11194] megaraid_mbox kernel panic during st driver initialization
Date: Fri, 15 Aug 2008 16:46:07 -0700 (PDT)
Message-ID: <20080815234607.7183611D109@picon.linux-foundation.org>
References: <bug-11194-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761438AbYHOXqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 19:46:10 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7FNk7mZ000954
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 16:46:08 -0700
In-Reply-To: <bug-11194-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11194





------- Comment #4 from cshore@fionavar.ca  2008-08-15 16:46 -------
A capture of the boot log using a serial console

[    0.000000] Initializing cgroup subsys cpuset

[    0.000000] Initializing cgroup subsys cpu

[    0.000000] Linux version 2.6.26-1-686 (Debian 2.6.26-1snapshot.11925)
(waldi@debian.org) (gcc version 4.1.3 20070718 (prerelease) (Debian
4.1.2-14+2)) #1 SMP Thu Jul 31 01:18:34 UTC 2008

[    0.000000] BIOS-provided physical RAM map:

[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)

[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)

[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)

[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fffc000 (usable)

[    0.000000]  BIOS-e820: 000000003fffc000 - 000000003ffff000 (ACPI data)

[    0.000000]  BIOS-e820: 000000003ffff000 - 0000000040000000 (ACPI NVS)

[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)

[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)

[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)

[    0.000000] 127MB HIGHMEM available.

[    0.000000] 896MB LOWMEM available.

[    0.000000] Zone PFN ranges:

[    0.000000]   DMA             0 ->     4096

[    0.000000]   Normal       4096 ->   229376

[    0.000000]   HighMem    229376 ->   262140

[    0.000000] Movable zone start PFN for each node

[    0.000000] early_node_map[1] active PFN ranges

[    0.000000]     0:        0 ->   262140

[    0.000000] DMI 2.3 present.

[    0.000000] ACPI: RSDP 000F75E0, 0014 (r0 ASUS  )

[    0.000000] ACPI: RSDT 3FFFC000, 0030 (r1 ASUS   <P4B>    42302E31 MSFT
31313031)

[    0.000000] ACPI: FACP 3FFFC100, 0074 (r1 ASUS   <P4B>    42302E31 MSFT
31313031)

[    0.000000] ACPI: DSDT 3FFFC180, 26E6 (r1   ASUS <P4B>        1000 MSFT 
100000B)

[    0.000000] ACPI: FACS 3FFFF000, 0040

[    0.000000] ACPI: BOOT 3FFFC040, 0028 (r1 ASUS   <P4B>    42302E31 MSFT
31313031)

[    0.000000] ACPI: APIC 3FFFC080, 005A (r1 ASUS   <P4B>    42302E31 MSFT
31313031)

[    0.000000] ACPI: PM-Timer IO Port: 0xe408

[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)

[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])

[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])

[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 22 low level)

[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs

[    0.000000] Using ACPI (MADT) for SMP configuration information

[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:bec00000)

[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000

[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000f0000

[    0.000000] PM: Registered nosave memory: 00000000000f0000 -
0000000000100000

[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs

[    0.000000] PERCPU: Allocating 37960 bytes of per cpu data

[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
pages: 260092

[    0.000000] Kernel command line: root=/dev/mapper/Brennin-Root ro
rootdelay=10 console=ttyS0 console=tty0

[    0.000000] Enabling fast FPU save and restore... done.

[    0.000000] Enabling unmasked SIMD FPU exception support... done.

[    0.000000] Initializing CPU#0

[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)

[    0.000000] Detected 2018.014 MHz processor.

[    0.004000] Console: colour VGA+ 80x25

[    0.004000] console [tty0] enabled

[    0.004000] console [ttyS0] enabled

[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)

[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)

[    0.004000] Memory: 1029040k/1048560k available (1758k kernel code, 18820k
reserved, 743k data, 244k init, 131056k highmem)

[    0.004000] virtual kernel memory layout:

[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)

[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)

[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)

[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)

[    0.004000]       .init : 0xc0379000 - 0xc03b6000   ( 244 kB)

[    0.004000]       .data : 0xc02b79db - 0xc0371620   ( 743 kB)

[    0.004000]       .text : 0xc0100000 - 0xc02b79db   (1758 kB)

[    0.004000] Checking if this processor honours the WP bit even in supervisor
mode...Ok.

[    0.084216] Calibrating delay using timer specific routine.. 4041.34
BogoMIPS (lpj=8082686)

[    0.096006] Security Framework initialized

[    0.100006] SELinux:  Disabled at boot.

[    0.104006] Capability LSM initialized

[    0.108006] Mount-cache hash table entries: 512

[    0.112007] Initializing cgroup subsys ns

[    0.116007] Initializing cgroup subsys cpuacct

[    0.120021] Initializing cgroup subsys devices

[    0.128008] CPU: Trace cache: 12K uops, L1 D cache: 8K

[    0.136008] CPU: L2 cache: 512K

[    0.140008] CPU: Hyper-Threading is disabled

[    0.144009] Intel machine check architecture supported.

[    0.148009] Intel machine check reporting enabled on CPU#0.

[    0.152009] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available

[    0.156009] CPU0: Thermal monitoring enabled

[    0.160010] Checking 'hlt' instruction... OK.

[    0.182583] SMP alternatives: switching to UP code

[    0.199966] Freeing SMP alternatives: 16k freed

[    0.204012] ACPI: Core revision 20080321

[    0.212013] ENABLING IO-APIC IRQs

[    0.216013] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1

[    0.259716] CPU0: Intel(R) Pentium(R) 4 CPU 2.00GHz stepping 04

[    0.272017] Brought up 1 CPUs

[    0.276017] Total of 1 processors activated (4041.34 BogoMIPS).

[    0.280017] net_namespace: 660 bytes

[    0.284017] Booting paravirtualized kernel on bare hardware

[    0.288018] NET: Registered protocol family 16

[    0.292018] ACPI: bus type pci registered

[    0.298210] PCI: PCI BIOS revision 2.10 entry at 0xf11f0, last bus=4

[    0.304019] PCI: Using configuration type 1 for base access

[    0.308019] Setting up standard PCI resources

[    0.326670] ACPI: Interpreter enabled

[    0.332020] ACPI: (supports S0 S1 S4 S5)

[    0.347349] ACPI: Using IOAPIC for interrupt routing

[    0.361598] ACPI: PCI Root Bridge [PCI0] (0000:00)

[    0.368023] pci 0000:00:1f.0: Enabled i801 SMBus device

[    0.372023] pci 0000:00:1f.0: quirk: region e400-e47f claimed by ICH4
ACPI/GPIO/TCO

[    0.376023] pci 0000:00:1f.0: quirk: region ec00-ec3f claimed by ICH4 GPIO

[    0.380023] PCI: Transparent bridge - 0000:00:1e.0

[    0.386287] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14
15)

[    0.424026] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14
15)

[    0.461660] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14
15) *0, disabled.

[    0.510467] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14
15)

[    0.550340] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14
15) *0, disabled.

[    0.598465] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14
15)

[    0.639038] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14
15)

[    0.676031] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14
15)

[    0.713786] Linux Plug and Play Support v0.97 (c) Adam Belay

[    0.720031] pnp: PnP ACPI init

[    0.724031] ACPI: bus type pnp registered

[    0.734942] pnp: PnP ACPI: found 17 devices

[    0.740031] ACPI: ACPI bus type pnp unregistered

[    0.744031] PnPBIOS: Disabled by ACPI PNP

[    0.748032] PCI: Using ACPI for IRQ routing

[    0.752031] ACPI: RTC can wake from S4

[    0.756034] system 00:00: iomem range 0x0-0x9ffff could not be reserved

[    0.831266] system 00:00: iomem range 0xf0000-0xfffff could not be reserved

[    0.914659] system 00:00: iomem range 0x100000-0x3fffffff could not be
reserved

[    1.002214] system 00:00: iomem range 0xfec00000-0xfec000ff could not be
reserved

[    1.091840] system 00:00: iomem range 0xfee00000-0xfee00fff could not be
reserved

[    1.181481] system 00:02: ioport range 0xe400-0xe47f has been reserved

[    1.259665] system 00:02: ioport range 0xe800-0xe81f could not be reserved

[    1.342016] system 00:02: ioport range 0xec00-0xec3f has been reserved

[    1.420216] system 00:02: iomem range 0xfff80000-0xffffffff could not be
reserved

[    1.509841] system 00:02: iomem range 0xffb80000-0xffbfffff has been
reserved

[    1.595319] system 00:03: ioport range 0x4d0-0x4d1 has been reserved

[    1.671440] system 00:0e: ioport range 0x3f0-0x3f1 has been reserved

[    1.780153] PCI: Bridge: 0000:00:01.0

[    1.821991]   IO window: d000-dfff

[    1.862753]   MEM window: 0xdf000000-0xdfcfffff

[    1.917029]   PREFETCH window: 0x00000000e7f00000-0x00000000efffffff

[    1.993150] PCI: Bridge: 0000:03:00.0

[    2.037021]   IO window: disabled.

[    2.077787]   MEM window: 0xde900000-0xde9fffff

[    2.132061]   PREFETCH window: 0x00000000dff00000-0x00000000e7efffff

[    2.208178] PCI: Bridge: 0000:02:09.0

[    2.252054]   IO window: b000-bfff

[    2.292815]   MEM window: 0xde800000-0xdeffffff

[    2.347093]   PREFETCH window: 0x00000000dfe00000-0x00000000e7efffff

[    2.423209] PCI: Bridge: 0000:00:1e.0

[    2.467084]   IO window: a000-bfff

[    2.507847]   MEM window: 0xde800000-0xdeffffff

[    2.562125]   PREFETCH window: 0x00000000dfd00000-0x00000000e7efffff

[    2.638324] NET: Registered protocol family 2

[    2.690698] IP route cache hash table entries: 32768 (order: 5, 131072
bytes)

[    2.780148] TCP established hash table entries: 131072 (order: 8, 1048576
bytes)

[    2.867614] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)

[    2.950969] TCP: Hash tables configured (established 131072 bind 65536)

[    3.027554] TCP reno registered

[    3.065505] NET: Registered protocol family 1

[    3.117934] checking if image is initramfs... it is

[    5.804283] Freeing initrd memory: 6551k freed

[    5.804283] Simple Boot Flag at 0x3a set to 0x1

[    5.804283] audit: initializing netlink socket (disabled)

[    5.804283] type=2000 audit(1218842748.193:1): initialized

[    5.804283] highmem bounce pool size: 64 pages

[    5.804283] Total HugeTLB memory allocated, 0

[    5.804283] VFS: Disk quotas dquot_6.5.1

[    5.804283] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)

[    5.804283] msgmni has been set to 1767

[    5.804283] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
254)

[    5.804283] io scheduler noop registered

[    5.804283] io scheduler anticipatory registered

[    5.804283] io scheduler deadline registered

[    5.804283] io scheduler cfq registered (default)

[    5.804283] isapnp: Scanning for PnP cards...

[    5.804283] isapnp: No Plug & Play device found

[    5.804284] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing
enabled

[    5.804284] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

[    5.804284] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

[    5.804284] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

[    5.804284] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

[    5.804284] serial 0000:02:0c.0: enabling device (0000 -> 0001)

[    5.804284] ACPI: PCI Interrupt 0000:02:0c.0[A] -> GSI 20 (level, low) ->
IRQ 20

[    5.835979] 0000:02:0c.0: ttyS2 at I/O 0xa400 (irq = 20) is a 16550A

[    5.912209] brd: module loaded

[    5.948386] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64
irq 1,12

[    6.042416] serio: i8042 KBD port at 0x60,0x64 irq 1

[    6.101811] serio: i8042 AUX port at 0x60,0x64 irq 12

[    6.162531] mice: PS/2 mouse device common for all mice

[    6.224743] cpuidle: using governor ladder

[    6.275485] cpuidle: using governor menu

[    6.320577] No iBFT detected.

[    6.356754] TCP cubic registered

[    6.395368] NET: Registered protocol family 17

[    6.448565] Using IPI No-Shortcut mode

[    6.495897] registered taskstats version 1

[    6.545309] Freeing unused kernel memory: 244k freed

[    6.755503] ACPI: ACPI0007:00 is registered as cooling_device0

[    7.806895] 3c59x 0000:02:0a.0: enabling device (0004 -> 0005)

[    7.876813] ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 22 (level, low) ->
IRQ 22

[    7.965565] 3c59x: Donald Becker and others.

[    8.017577] 0000:02:0a.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001a800.

[    8.252540] SCSI subsystem initialized

[    8.299364] No dock devices found.

[    8.364258] usbcore: registered new interface driver usbfs

[    8.429991] usbcore: registered new interface driver hub

[    8.495096] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST
2006)

[    8.768116] Uniform Multi-Platform E-IDE driver

[    8.822376] ide: Assuming 33MHz system bus speed for PIO modes; override
with idebus=xx

[    8.923235] qla1280: Skipping AMI SubSys Vendor ID Chip

[    9.014238] Floppy drive(s): fd0 is 1.44M

[    9.085637] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)

[    9.168977] megaraid: probe new device 0x101e:0x1960:0x1028:0x0493: bus
4:slot 0:func 0

[    9.266901] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 21 (level, low) ->
IRQ 21

[    9.406356] FDC 0 is a post-1991 82077

[    9.451342] usbcore: registered new device driver usb

[    9.519749] USB Universal Host Controller Interface driver v3.0

[    9.590693] ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) ->
IRQ 19

[    9.679490] uhci_hcd 0000:00:1f.2: UHCI Host Controller

[    9.743702] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus
number 1

[    9.832238] uhci_hcd 0000:00:1f.2: irq 19, io base 0x00009400

[    9.901123] usb usb1: configuration #1 chosen from 1 choice

[    9.967820] hub 1-0:1.0: USB hub found

[   10.012669] hub 1-0:1.0: 2 ports detected

[   10.084118] megaraid: fw version:[199D] bios version:[3.35]

[   10.162282] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001

[   10.243624] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1

[   10.331378] usb usb1: Product: UHCI Host Controller

[   10.389878] usb usb1: Manufacturer: Linux 2.6.26-1-686 uhci_hcd

[   10.460315] usb usb1: SerialNumber: 0000:00:1f.2

[   10.519427] ACPI: PCI Interrupt 0000:00:1f.4[C] -> GSI 23 (level, low) ->
IRQ 23

[   10.608185] uhci_hcd 0000:00:1f.4: UHCI Host Controller

[   10.670794] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus
number 2

[   10.759371] uhci_hcd 0000:00:1f.4: irq 23, io base 0x00009000

[   10.828250] usb usb2: configuration #1 chosen from 1 choice

[   10.894954] hub 2-0:1.0: USB hub found

[   10.939798] hub 2-0:1.0: 2 ports detected

[   11.000525] scsi0 : LSI Logic MegaRAID driver

[   11.073602] scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices

[   11.159931] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001

[   11.240086] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1

[   11.326613] usb usb2: Product: UHCI Host Controller

[   11.384956] usb usb2: Manufacturer: Linux 2.6.26-1-686 uhci_hcd

[   11.455806] usb usb2: SerialNumber: 0000:00:1f.4

[   11.515048] ICH2: IDE controller (0x8086:0x244b rev 0x05) at  PCI slot
0000:00:1f.1

[   11.606853] ICH2: not 100% native mode: will probe irqs later

[   11.675617]     ide0: BM-DMA at 0x9800-0x9807

[   11.727765]     ide1: BM-DMA at 0x9808-0x980f

[   11.840089] usb 1-1: new full speed USB device using uhci_hcd and address 2

[   12.167295] usb 1-1: configuration #1 chosen from 1 choice

[   12.248446] hub 1-1:1.0: USB hub found

[   12.314106] hub 1-1:1.0: 5 ports detected

[   12.576193] usb 1-1: New USB device found, idVendor=049f, idProduct=f511

[   12.656441] usb 1-1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0

[   12.741911] hub 1-0:1.0: over-current change on port 2

[   12.916178] hda: ASUS DRW-1814BL, ATAPI CD/DVD-ROM drive

[   13.280500] usb 1-1.2: new full speed USB device using uhci_hcd and address
3

[   13.512003] usb 1-1.2: configuration #1 chosen from 1 choice

[   13.615209] usb 1-1.2: New USB device found, idVendor=058f, idProduct=6335

[   13.697595] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3

[   13.785286] usb 1-1.2: Product: Mass Storage Device

[   13.843686] usb 1-1.2: Manufacturer: Generic

[   13.895367] usb 1-1.2: SerialNumber: 058F011111B1

[   13.974328] Initializing USB Mass Storage driver...

[   14.084214] hda: UDMA/66 mode selected

[   14.384896] usb 1-1.3: new full speed USB device using uhci_hcd and address
4

[   14.645846] usb 1-1.3: configuration #1 chosen from 1 choice

[   14.732596] usb 1-1.3: New USB device found, idVendor=04b8, idProduct=0005

[   14.814946] usb 1-1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3

[   14.902797] usb 1-1.3: Product: USB Printer

[   14.954303] usb 1-1.3: Manufacturer: EPSON

[   15.003389] usb 1-1.3: SerialNumber: W60100203082324090

[   15.066832] scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices

[   15.148410] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

[   15.203088] ide1 at 0x170-0x177,0x376 on irq 15

[   15.344295] hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache

[   15.427378] Uniform CD-ROM driver Revision: 3.20

[   15.716642] usb 1-1.4: new full speed USB device using uhci_hcd and address
5

[   15.806142] scsi 0:1:2:0: Processor         HP       C2520A           3503
PQ: 0 ANSI: 2

[   16.040003] usb 1-1.4: configuration #1 chosen from 1 choice

[   16.171780] usb 1-1.4: New USB device found, idVendor=03f0, idProduct=3f17

[   16.254167] usb 1-1.4: New USB device strings: Mfr=1, Product=2,
SerialNumber=3

[   16.342183] usb 1-1.4: Product: HP LaserJet P1505

[   16.398476] usb 1-1.4: Manufacturer: Hewlett-Packard

[   16.458103] usb 1-1.4: SerialNumber: CA3396E

[   16.552716] scsi1 : SCSI emulation for USB Mass Storage devices

[   16.627737] usbcore: registered new interface driver usb-storage

[   16.699605] USB Mass Storage support registered.

[   16.772087] scsi 0:1:6:0: Sequential-Access SEAGATE  DAT    06408-XXX 8130
PQ: 0 ANSI: 3

[   17.980012] scsi[0]: scanning scsi channel 2 [virtual] for logical drives

[   18.986594] scsi 0:2:0:0: Direct-Access     MegaRAID LD 0 RAID5  210G 199D
PQ: 0 ANSI: 2

[   19.168224] osst :I: Tape driver with OnStream support version 0.99.4

[   19.168228] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $

[   19.325709] Driver 'osst' needs updating - please use bus_type methods

[   19.408003] scsi 0:1:2:0: Attached scsi generic sg0 type 3

[   19.473745] scsi 0:1:6:0: Attached scsi generic sg1 type 1

[   19.539381] scsi 0:2:0:0: Attached scsi generic sg2 type 0

[   19.628121] Driver 'sd' needs updating - please use bus_type methods

[   19.710133] sd 0:2:0:0: [sda] 430141440 512-byte hardware sectors (220232
MB)

[   19.814040] st: Version 20080224, fixed bufsize 32768, s/g segs 256

[   19.889138] Driver 'st' needs updating - please use bus_type methods

[   19.965493] st 0:1:6:0: Attached scsi tape st0

[   20.018721] st 0:1:6:0: st0: try direct i/o: yes (alignment 4 B)

[   20.094015] sd 0:2:0:0: [sda] Write Protect is off

[   20.153455] sd 0:2:0:0: [sda] Asking for cache data failed

[   20.219155] sd 0:2:0:0: [sda] Assuming drive cache: write through

[   20.294981] sd 0:2:0:0: [sda] 430141440 512-byte hardware sectors (220232
MB)

[   20.380048] sd 0:2:0:0: [sda] Write Protect is off

[   20.437396] sd 0:2:0:0: [sda] Asking for cache data failed

[   20.503524] sd 0:2:0:0: [sda] Assuming drive cache: write through

[   20.576451]  sda: sda1 sda2

[   20.611220] sd 0:2:0:0: [sda] Attached SCSI disk

[   21.756509] scsi 1:0:0:0: Direct-Access     SD/MMC   Card  Reader     1.00
PQ: 0 ANSI: 0

[   22.312350] sd 1:0:0:0: [sdb] 7870464 512-byte hardware sectors (4030 MB)

[   22.406709] sd 1:0:0:0: [sdb] Write Protect is off

[   22.464801] sd 1:0:0:0: [sdb] Assuming drive cache: write through

[   22.543750] sd 1:0:0:0: [sdb] 7870464 512-byte hardware sectors (4030 MB)

[   22.636717] sd 1:0:0:0: [sdb] Write Protect is off

[   22.694807] sd 1:0:0:0: [sdb] Assuming drive cache: write through

[   22.767797]  sdb: sdb1

[   22.805837] sd 1:0:0:0: [sdb] Attached SCSI removable disk

[   22.869978] sd 1:0:0:0: Attached scsi generic sg3 type 0

[   26.953605] device-mapper: uevent: version 1.0.3

[   27.011523] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:
dm-devel@redhat.com

[   61.511864] PM: Starting manual resume from disk

[   61.612817] kjournald starting.  Commit interval 5 seconds

[   61.678603] EXT3-fs: mounted filesystem with ordered data mode.

[   63.941095] udevd version 124 started

[   64.844301] st0: Block limits 1 - 16777215 bytes.

[   64.912023] BUG: unable to handle kernel NULL pointer dereference at
00000be0

[   64.999065] IP: [<f8857209>] :megaraid_mbox:megaraid_mbox_dpc+0x178/0x44a

[   65.080515] *pde = 00000000 

[   65.115797] Oops: 0000 [#1] SMP 

[   65.118076] Modules linked in: joydev evdev ext3 jbd mbcache sha256_generic
aes_i586 aes_generic cbc dm_crypt crypto_blkcipher dm_mirror dm_log dm_snapshot
dm_mod st sd_mod sg osst ide_cd_mod cdrom ide_pci_generic usb_storage piix
uhci_hcd megaraid_mbox floppy qla1280 ide_core ata_generic libata megaraid_mm
usbcore dock scsi_mod 3c59x mii thermal processor fan thermal_sys

[   65.118076] 

[   65.118076] Pid: 1447, comm: udevd Not tainted (2.6.26-1-686 #1)

[   65.118076] EIP: 0060:[<f8857209>] EFLAGS: 00010282 CPU: 0

[   65.118076] EIP is at megaraid_mbox_dpc+0x178/0x44a [megaraid_mbox]

[   65.118076] EAX: 00000000 EBX: f7804680 ECX: c0405bd8 EDX: 00000be0

[   65.118076] ESI: 00000000 EDI: 00000000 EBP: f7460108 ESP: f7b11df4

[   65.118076]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

[   65.118076] Process udevd (pid: 1447, ti=f7b10000 task=f74b6ca0
task.ti=f7b10000)

[   65.118076] Stack: f77c995e f7458000 f746c000 f7b11e10 f77f9880 f78a3300
f78a3300 f746010c 

[   65.118076]        f746010c f746010c f7458000 00000000 0000000a 00000000
c012689b 00000001 

[   65.118076]        c0369a68 c012644d 00000046 c036a400 00000000 00000015
c01264ff 000007e0 

[   65.118076] Call Trace:

[   65.118076]  [<c012689b>] tasklet_action+0x68/0xd0

[   65.118076]  [<c012644d>] __do_softirq+0x66/0xd3

[   65.118076]  [<c01264ff>] do_softirq+0x45/0x53

[   65.118076]  [<c01267b6>] irq_exit+0x35/0x67

[   65.118076]  [<c0105f53>] do_IRQ+0x52/0x63

[   65.118076]  [<c01042b7>] common_interrupt+0x23/0x28

[   65.118076]  [<c0162083>] do_wp_page+0x28a/0x49f

[   65.118076]  [<c0163feb>] handle_mm_fault+0x623/0x690

[   65.118076]  [<c017cd53>] sys_mkdirat+0xca/0xd4

[   65.118076]  [<c0115b07>] do_page_fault+0x29b/0x5b8

[   65.118076]  [<c0172a15>] filp_close+0x4d/0x53

[   65.118076]  [<c011586c>] do_page_fault+0x0/0x5b8

[   65.118076]  [<c02b6d3a>] error_code+0x72/0x78

[   65.118076]  [<c02b0000>] cacheinfo_cpu_callback+0x4f/0xa6

[   65.118076]  =======================

[   65.118076] Code: 0f b7 4d 24 0f b6 82 c4 33 00 00 d3 f8 a8 01 0f 84 83 00
00 00 8b 4c 24 10 8b 59 68 8b 03 83 e0 fc 74 10 e8 fb 9f 90 c7 8b 53 04 <f6> 04
10 1f 74 1c eb 65 83 3d 00 b5 85 f8 00 78 11 68 1d 09 00 

[   65.118076] EIP: [<f8857209>] megaraid_mbox_dpc+0x178/0x44a [megaraid_mbox]
SS:ESP 0068:f7b11df4

[   67.602238] Kernel panic - not syncing: Fatal exception in interrupt


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
