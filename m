From: Mark Hounschell <markh@compro.net>
Subject: [BUG] Cannot boot any kernel after 2.6.27 if a 256 byte sector SCSI
 disk is attached
Date: Wed, 26 May 2010 14:34:50 -0400
Message-ID: <4BFD69CA.5090308@compro.net>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050700060101060906070602"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mark Hounschell <markh@compro.net>, Mark Hounschell <dmarkh@cfl.rr.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050700060101060906070602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

My application uses SCSI disks of 256, 512, 768, and 1024 sector sizes. It
uses the sg_io interface to talk to these devices. As of 2.6.27 if any SCSI
disk is attached that has been formatted with a 256 byte sector size, the
boot process hangs when it gets to the point of discovering USB devices.
512, 768, and 1024 sector sizes do not seem to trigger this.

I have bisected this problem to the following commit:

# git bisect good
427e59f09fdba387547106de7bab980b7fff77be is first bad commit
commit 427e59f09fdba387547106de7bab980b7fff77be
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Mar 8 18:24:17 2008 -0600

    [SCSI] make use of the residue value

    USB sometimes doesn't return an error but instead returns a residue
    value indicating part (or all) of the command wasn't completed.  So if
    the driver _done() error processing indicates the command was fully
    processed, subtract off the residue so that this USB error gets
    propagated.

    Cc: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd
c85f8cb8bd4910724f0101e41054555980727e16 M      drivers

Now, what the hell USB has to do with my SCSI disks is beyond me. I have a
feeling that this commit is just uncovering another problem. I've attached
a dmesg from a working kernel and pointed out where the boot hangs and my
SCSI disk light is on solid. Once it turns on solid the only recourse is to
recycle power to the disk. The reset button does nothing to it. In fact a
second will not even see the device because it is out to lunch. Not even a
SCSI bus reset clears what ever has happened to the disk.

This does the same thing on a 2.6.34 kernel also. Anything I can do to
help, I'm available.

Thanks and regards
Mark


--------------050700060101060906070602
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

Initializing cgroup subsys cpuset
Linux version 2.6.26.8 (root@harley) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #6 SMP PREEMPT Wed Oct 14 09:28:59 EDT 2009
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffe0000 (usable)
 BIOS-e820: 00000000cffe0000 - 00000000cffe3000 (ACPI NVS)
 BIOS-e820: 00000000cffe3000 - 00000000cfff0000 (ACPI data)
 BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3264MB HIGHMEM available.
832MB LOWMEM available.
found SMP MP-table at [c00f4f40] 000f4f40
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   212992
  HighMem    212992 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->  1048576
On node 0 totalpages: 1048576
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1632 pages used for memmap
  Normal zone: 207264 pages, LIFO batch:31
  HighMem zone: 6528 pages used for memmap
  HighMem zone: 829056 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.5 present.
ACPI: RSDP 000F8FA0, 0024 (r2 RD790 )
ACPI: RSDT CFFE3000, 0034 (r1 RD790  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP CFFE3080, 0074 (r1 RD790  AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT CFFE3100, 86E1 (r1 RD790  AWRDACPI     1000 MSFT  3000000)
ACPI: FACS CFFE0000, 0040
ACPI: HPET CFFEB8C0, 0038 (r1 RD790  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG CFFEB900, 003C (r1 RD790  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC CFFEB800, 0084 (r1 RD790  AWRDACPI 42302E31 AWRD        0)
ATI board detected. Disabling timer routing over 8254.
SB700 rev 0x3a or lower detected!
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 38788 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 4
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
Kernel command line: root=/dev/disk/by-id/ata-ST3120827AS_4MS1MCBH-part5 splash=silent noresume bigphysarea=0x4000 vmalloc=192M apm=off motr vrsx vga=0x31a
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3400.267 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3298804k/4194304k available (1761k kernel code, 107900k reserved, 734k data, 216k init, 2555776k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe15000 - 0xfffff000   (1960 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf4800000 - 0xff7fe000   ( 175 MB)
    lowmem  : 0xc0000000 - 0xf4000000   ( 832 MB)
      .init : 0xc0375000 - 0xc03ab000   ( 216 kB)
      .data : 0xc02b8532 - 0xc036fecc   ( 734 kB)
      .text : 0xc0100000 - 0xc02b8532   (1761 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 6805.29 BogoMIPS (lpj=3402647)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(4) -> Core 0
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080321
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 965 Processor stepping 02
Booting processor 1/1 ip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6801.42 BogoMIPS (lpj=3400714)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(4) -> Core 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Phenom(tm) II X4 965 Processor stepping 02
Booting processor 2/2 ip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6801.43 BogoMIPS (lpj=3400717)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 2(4) -> Core 3
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: AMD Phenom(tm) II X4 965 Processor stepping 02
Booting processor 3/3 ip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6801.43 BogoMIPS (lpj=3400717)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 3(4) -> Core 2
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: AMD Phenom(tm) II X4 965 Processor stepping 02
Brought up 4 CPUs
Total of 4 processors activated (27209.59 BogoMIPS).
net_namespace: 660 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:11.0: set SATA to AHCI mode
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0c: mem resource (0xfed00000-0xfed000ff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
pnp 00:0c: mem resource (0xffff0000-0xffffffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
pnp 00:0c: mem resource (0xfec00000-0xfec00fff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
pnp 00:0c: mem resource (0xfee00000-0xfee00fff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
pnp 00:0c: mem resource (0xfff80000-0xfffeffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: Cannot allocate resource region 3 of device 0000:00:00.0
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 2
system 00:01: ioport range 0x4100-0x411f has been reserved
system 00:01: ioport range 0x228-0x22f has been reserved
system 00:01: ioport range 0x40b-0x40b has been reserved
system 00:01: ioport range 0x4d6-0x4d6 has been reserved
system 00:01: ioport range 0xc00-0xc01 has been reserved
system 00:01: ioport range 0xc14-0xc14 has been reserved
system 00:01: ioport range 0xc50-0xc52 has been reserved
system 00:01: ioport range 0xc6c-0xc6d has been reserved
system 00:01: ioport range 0xc6f-0xc6f has been reserved
system 00:01: ioport range 0xcd0-0xcd1 has been reserved
system 00:01: ioport range 0xcd2-0xcd3 has been reserved
system 00:01: ioport range 0xcd4-0xcdf has been reserved
system 00:01: ioport range 0x4000-0x40fe has been reserved
system 00:01: ioport range 0x4210-0x4217 has been reserved
system 00:01: ioport range 0xb10-0xb1f has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x220-0x225 has been reserved
system 00:0c: iomem range 0xf0000-0xfffff could not be reserved
system 00:0c: iomem range 0x0-0x1fffff could not be reserved
system 00:0c: iomem range 0xcffe0000-0xcfffffff could not be reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0x100000-0xcffdffff could not be reserved
PCI: Bridge: 0000:00:02.0
  IO window: b000-bfff
  MEM window: 0xf7000000-0xf9ffffff
  PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
PCI: Bridge: 0000:02:00.0
  IO window: a000-afff
  MEM window: 0xfdd00000-0xfddfffff
  PREFETCH window: 0x00000000fdc00000-0x00000000fdcfffff
PCI: Bridge: 0000:00:04.0
  IO window: a000-afff
  MEM window: 0xfdd00000-0xfdefffff
  PREFETCH window: 0x00000000fdc00000-0x00000000fdcfffff
PCI: Bridge: 0000:00:09.0
  IO window: e000-efff
  MEM window: 0xfdb00000-0xfdbfffff
  PREFETCH window: 0x00000000fd800000-0x00000000fd8fffff
PCI: Bridge: 0000:07:0c.0
  IO window: c000-cfff
  MEM window: 0xfc800000-0xfd3fffff
  PREFETCH window: 0x00000000fdf00000-0x00000000fdffffff
PCI: Bridge: 0000:06:04.0
  IO window: c000-dfff
  MEM window: 0xfa800000-0xfd7fffff
  PREFETCH window: 0x00000000fdf00000-0x00000000fdffffff
PCI: Bridge: 0000:05:00.0
  IO window: c000-dfff
  MEM window: 0xfa800000-0xfd7fffff
  PREFETCH window: 0x00000000fdf00000-0x00000000fdffffff
PCI: Bridge: 0000:00:0b.0
  IO window: c000-dfff
  MEM window: 0xfa800000-0xfd7fffff
  PREFETCH window: 0x00000000fdf00000-0x00000000fdffffff
PCI: Bridge: 0000:00:14.4
  IO window: 9000-9fff
  MEM window: 0xfda00000-0xfdafffff
  PREFETCH window: 0x00000000fd900000-0x00000000fd9fffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:09.0 to 64
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:05:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 5495k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1274881740.493:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
bigphysarea: Allocated 16384 pages at 0xc3038000.
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1463
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
PCI: Setting latency timer of device 0000:00:09.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:09.0:pcie00]
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
vesafb: framebuffer at 0xd0000000, mapped to 0xf4880000, using 5120k, total 262144k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: protected mode interface info at c000:d4f0
vesafb: pmi: set display start = c00cd526, set palette = c00cd590
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.1.1.1 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
input: ImExPS/2 Logitech Wheel Mouse as /class/input/input2
Using IPI No-Shortcut mode
Freeing unused kernel memory: 216k freed
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: ACPI0007:03 is registered as cooling_device3
ACPI: Expecting a [Reference] package element, found type 0
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (28 C)
No dock devices found.
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:11.0: version 3.0
ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
ata1: softreset failed (device not ready)
ata1: failed due to HW bug, retry pmp=0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-6: ST3120827AS, 3.42, max UDMA/133
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: softreset failed (device not ready)
ata2: failed due to HW bug, retry pmp=0
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-6: ST3500320NS, SN04, max UDMA/133
ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: softreset failed (device not ready)
ata3: failed due to HW bug, retry pmp=0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-6: ST3500320NS, SN04, max UDMA/133
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: softreset failed (device not ready)
ata4: failed due to HW bug, retry pmp=0
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-6: ST3500320NS, SN04, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3120827AS      3.42 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      ST3500320NS      SN04 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      ST3500320NS      SN04 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3500320NS      SN04 PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
ata5.00: ATA-6: ST3120827AS, 3.42, max UDMA/133
ata5.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.01: ATA-6: ST3120827AS, 3.42, max UDMA/133
ata5.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/100
ata5.01: configured for UDMA/100
ata6.00: ATA-7: ST3250620A, 3.AAD, max UDMA/100
ata6.00: 488397168 sectors, multi 16: LBA48 
ata6.01: ATAPI: SONY    DVD RW DRU-180A, 1.60, max UDMA/66
ata6.00: configured for UDMA/100
ata6.01: configured for UDMA/66
scsi 4:0:0:0: Direct-Access     ATA      ST3120827AS      3.42 PQ: 0 ANSI: 5
scsi 4:0:1:0: Direct-Access     ATA      ST3120827AS      3.42 PQ: 0 ANSI: 5
scsi 5:0:0:0: Direct-Access     ATA      ST3250620A       3.AA PQ: 0 ANSI: 5
scsi 5:0:1:0: CD-ROM            SONY     DVD RW DRU-180A  1.60 PQ: 0 ANSI: 5
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 16 (level, low) -> IRQ 16
scsi6 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320LPE PCIe Ultra320 SCSI adapter>
        aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs
scsi 6:0:0:0: Direct-Access     SEAGATE  ST15150N         5055 PQ: 0 ANSI: 2
 target6:0:0: asynchronous
scsi6:A:0:0: Tagged Queuing enabled.  Depth 32
 target6:0:0: Beginning Domain Validation
 target6:0:0: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
 target6:0:0: Domain Validation skipping write tests
 target6:0:0: Ending Domain Validation
scsi 6:0:1:0: Direct-Access     IMPRIMIS 94601-15         4614 PQ: 0 ANSI: 1 CCS
 target6:0:1: asynchronous
 target6:0:1: Beginning Domain Validation
 target6:0:1: Ending Domain Validation
scsi 6:0:5:0: Sequential-Access EXABYTE  EXB8500C8CQANXR4 0730 PQ: 0 ANSI: 2
 target6:0:5: asynchronous
 target6:0:5: Beginning Domain Validation
 target6:0:5: FAST-5 SCSI 5.0 MB/s ST (200 ns, offset 11)
 target6:0:5: Domain Validation skipping write tests
 target6:0:5: Ending Domain Validation
scsi 6:0:6:0: Sequential-Access SONY     SDT-10000        0110 PQ: 0 ANSI: 2
 target6:0:6: asynchronous
 target6:0:6: Beginning Domain Validation
 target6:0:6: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
 target6:0:6: Domain Validation skipping write tests
 target6:0:6: Ending Domain Validation
ACPI: PCI Interrupt 0000:08:04.0[A] -> GSI 19 (level, low) -> IRQ 19
scsi7 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2930CU SCSI adapter>
        aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

scsi 7:0:2:0: Sequential-Access HP       88780            A674 PQ: 0 ANSI: 1 CCS
 target7:0:2: Beginning Domain Validation
 target7:0:2: Ending Domain Validation
scsi 7:0:3:0: Sequential-Access Quantum  DLT4000          D473 PQ: 0 ANSI: 2
 target7:0:3: Beginning Domain Validation
 target7:0:3: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
 target7:0:3: Domain Validation skipping write tests
 target7:0:3: Ending Domain Validation
BIOS EDD facility v0.16 2004-Jun-25, 8 devices found
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>ACPI: PCI Interrupt 0000:00:12.2[B] -> GSI 17 (level, low) -> IRQ 17
 sda1 sda2 sda3 <<6>ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
 sda5<6>ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
 sda6<7>ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
 sda7 >
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26.8 ehci_hcd
usb usb1: SerialNumber: 0000:00:12.2
ACPI: PCI Interrupt 0000:00:13.2[B] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
sd 3:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd:<6>usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
 sdd1
usb usb2: Manufacturer: Linux 2.6.26.8 ehci_hcd
sd 3:0:0:0: [sdd] Attached SCSI disk
sd 4:0:0:0: [sde] 234441648 512-byte hardware sectors (120034 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sde] 234441648 512-byte hardware sectors (120034 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1 sde2 sde3 < sde5 sde6<6>usb usb2: SerialNumber: 0000:00:13.2
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
 sde7 >
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
sd 4:0:0:0: [sde] Attached SCSI disk
sd 4:0:1:0: [sdf] 234441648 512-byte hardware sectors (120034 MB)
sd 4:0:1:0: [sdf] Write Protect is off
sd 4:0:1:0: [sdf] Mode Sense: 00 3a 00 00
sd 4:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:1:0: [sdf] 234441648 512-byte hardware sectors (120034 MB)
sd 4:0:1:0: [sdf] Write Protect is off
sd 4:0:1:0: [sdf] Mode Sense: 00 3a 00 00
sd 4:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1 sdf2 sdf3 < sdf5 sdf6 sdf7 >
sd 4:0:1:0: [sdf] Attached SCSI disk
sd 5:0:0:0: [sdg] 488397168 512-byte hardware sectors (250059 MB)
sd 5:0:0:0: [sdg] Write Protect is off
sd 5:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sdg] 488397168 512-byte hardware sectors (250059 MB)
sd 5:0:0:0: [sdg] Write Protect is off
sd 5:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
 sdg: sdg1
sd 5:0:0:0: [sdg] Attached SCSI disk
sd 6:0:0:0: [sdh] Unsupported sector size 768.
sd 6:0:0:0: [sdh] 0 512-byte hardware sectors (0 MB)
sd 6:0:0:0: [sdh] Write Protect is off
sd 6:0:0:0: [sdh] Mode Sense: ab 00 10 08
sd 6:0:0:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 6:0:0:0: [sdh] Attached SCSI disk
sd 6:0:1:0: [sdi] 3675960 256-byte hardware sectors (941 MB)
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26.8 ohci_hcd
usb usb3: SerialNumber: 0000:00:12.0
ACPI: PCI Interrupt 0000:00:12.1[A] -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.1: OHCI Host Controller
ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
sd 6:0:1:0: [sdi] Write Protect is off
sd 6:0:1:0: [sdi] Mode Sense: 5b 00 00 08
sd 6:0:1:0: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
sd 6:0:1:0: [sdi] 3675960 256-byte hardware sectors (941 MB)
sd 6:0:1:0: [sdi] Write Protect is off
sd 6:0:1:0: [sdi] Mode Sense: 5b 00 00 08
sd 6:0:1:0: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdi:<6>usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.26.8 ohci_hcd
usb usb4: SerialNumber: 0000:00:12.1
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
 unknown partition table
sd 6:0:1:0: [sdi] Attached SCSI disk
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.26.8 ohci_hcd
usb usb5: SerialNumber: 0000:00:13.0
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.26.8 ohci_hcd
usb usb6: SerialNumber: 0000:00:13.1
ACPI: PCI Interrupt 0000:00:14.5[C] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: OHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.26.8 ohci_hcd
usb usb7: SerialNumber: 0000:00:14.5

Here is where any kernel with the above commit in hangs



--------------050700060101060906070602--
