From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: scsi_scan: WARNING: at include/linux/blkdev.h:431
 blk_queue_init_tags+0x107/0x120()
Date: Fri, 2 May 2008 00:43:30 +0200 (CEST)
Message-ID: <alpine.LNX.1.00.0805020043130.1489@dragon.funnycrock.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:60159 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbYEAWni (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 18:43:38 -0400
Received: by ug-out-1314.google.com with SMTP id z38so1842013ugc.16
        for <linux-scsi@vger.kernel.org>; Thu, 01 May 2008 15:43:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>

Hi,

For your information;

I just build and booted the tip of Linus' git tree (HEAD at 
886c35fbcf6fb2eee15687efc2d64d99b6ad9a4a) and got this in dmesg during 
bootup : 

------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x107/0x120()
Modules linked in:
Pid: 432, comm: scsi_scan_0 Not tainted 2.6.25-07351-g886c35f #1
 [<c0129684>] warn_on_slowpath+0x54/0x70
 [<c017a7c3>] ? check_object+0xe3/0x1f0
 [<c0200ae9>] ? init_tag_map+0x59/0xb0
 [<c014b1e7>] ? mark_held_locks+0x47/0x80
 [<c017cbeb>] ? __kmalloc+0x6b/0x100
 [<c014b379>] ? trace_hardirqs_on+0xb9/0x150
 [<c0200ae9>] ? init_tag_map+0x59/0xb0
 [<c0200ae9>] ? init_tag_map+0x59/0xb0
 [<c0200ae9>] ? init_tag_map+0x59/0xb0
 [<c0200c34>] ? __blk_queue_init_tags+0x24/0x70
 [<c0200c45>] ? __blk_queue_init_tags+0x35/0x70
 [<c0200e57>] blk_queue_init_tags+0x107/0x120
 [<c02b5a91>] ahc_platform_set_tags+0x191/0x1d0
 [<c02b5bd3>] ahc_linux_slave_configure+0x103/0x170
 [<c02a1f65>] scsi_probe_and_add_lun+0x6e5/0x920
 [<c02a2468>] __scsi_scan_target+0xe8/0x5d0
 [<c0108e17>] ? native_sched_clock+0x87/0xd0
 [<c0148c89>] ? get_lock_stats+0x29/0x50
 [<c0148cbd>] ? put_lock_stats+0xd/0x30
 [<c014b1e7>] ? mark_held_locks+0x47/0x80
 [<c035e247>] ? mutex_lock_nested+0x1b7/0x2a0
 [<c014b379>] ? trace_hardirqs_on+0xb9/0x150
 [<c035e23a>] ? mutex_lock_nested+0x1aa/0x2a0
 [<c02a2a1a>] ? scsi_scan_host_selected+0x3a/0xf0
 [<c02a29c0>] scsi_scan_channel+0x70/0x90
 [<c02a2a9d>] scsi_scan_host_selected+0xbd/0xf0
 [<c02a2b50>] ? do_scan_async+0x0/0x140
 [<c02a2b48>] do_scsi_scan_host+0x78/0x80
 [<c02a2b64>] do_scan_async+0x14/0x140
 [<c011f6e8>] ? complete+0x48/0x60
 [<c02a2b50>] ? do_scan_async+0x0/0x140
 [<c013c8d2>] kthread+0x42/0x70
 [<c013c890>] ? kthread+0x0/0x70
 [<c0103ceb>] kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 1437783fbb683a0c ]---

Some software versions for you :

$ scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux dragon 2.6.25-07351-g886c35f #1 SMP PREEMPT Fri May 2 00:29:38 CEST 
2008 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD 
GNU/Linux

Gnu C                  4.2.3
Gnu make               3.81
binutils               2.17.50.0.17.20070615
util-linux             2.13.1
mount                  2.13.1
module-init-tools      3.4
e2fsprogs              1.40.8
jfsutils               1.1.12
reiserfsprogs          3.6.19
xfsprogs               2.9.7
pcmciautils            014
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   118
Modules Loaded         snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss 
snd_mixer_oss agpgart lp snd_emu10k1 snd_rawmidi firmware_class 
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc 
snd_util_mem via_rhine sg ehci_hcd snd_hwdep evdev k8temp


and here's the full dmesg output. Let me know if you need anything else.


Linux version 2.6.25-07351-g886c35f (juhl@dragon) (gcc version 4.2.3) #1 SMP PREEMPT Fri May 2 00:29:38 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
 BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
 BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
x86: PAT support disabled.
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at [c00ff780] 000ff780
Entering add_active_range(0, 0, 524208) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524208
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524208
On node 0 totalpages: 524208
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2303 pages used for memmap
  HighMem zone: 292529 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F9A50, 0014 (r0 ACPIAM)
ACPI: RSDT 7FFB0000, 0034 (r1 A M I  OEMRSDT   9000625 MSFT       97)
ACPI: FACP 7FFB0200, 0084 (r2 A M I  OEMFACP   9000625 MSFT       97)
ACPI: DSDT 7FFB0440, 474D (r1  939M2 939M2222      222 INTL  2002026)
ACPI: FACS 7FFC0000, 0040
ACPI: APIC 7FFB0390, 0068 (r1 A M I  OEMAPIC   9000625 MSFT       97)
ACPI: MCFG 7FFB0400, 003C (r1 A M I  OEMMCFG   9000625 MSFT       97)
ACPI: OEMB 7FFC0040, 0057 (r1 A M I  AMI_OEM   9000625 MSFT       97)
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 17, address 0xfec10000, GSI 24-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7f7c0000)
PERCPU: Allocating 341380 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520113
Kernel command line: BOOT_IMAGE=.25-07351 ro root=801
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec10000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2200.106 MHz processor.
Console: colour VGA+ 80x50
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1024 kB
 per task-struct memory footprint: 2688 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2069508k/2096832k available (2435k kernel code, 26156k reserved, 1156k data, 552k init, 1179328k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff7f000 - 0xfffff000   ( 512 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0489000 - 0xc0513000   ( 552 kB)
      .data : 0xc0360ef6 - 0xc0482190   (1156 kB)
      .text : 0xc0100000 - 0xc0360ef6   (2435 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 32 of 32 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 4403.77 BogoMIPS (lpj=2201889)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(2) -> Core 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
debug: unmapping init memory c0486000..c0489000
ACPI: Core revision 20080321
Parsing all Control Methods:
Table [DSDT](id 0001) - 571 Objects with 66 Devices 180 Methods 15 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 02
lockdep: fixing up alternatives.
Booting processor 1/1 ip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4399.38 BogoMIPS (lpj=2199694)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(2) -> Core 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86: PAT support disabled.
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (8803.16 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
khelper used greatest stack depth: 6748 bytes left
net_namespace: 272 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 3F [_GPE] 8 regs on int 0x9
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:....................................................................................................
Initialized 11/15 Regions 25/25 Fields 37/37 Buffers 27/28 Packages (580 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:...
Executed 3 _INI methods requiring 0 _STA executions (examined 70 objects)
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 0 Runtime GPEs in this block
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.1: quirk: region 0800-083f claimed by ali7101 ACPI
PCI: Transparent bridge - 0000:00:06.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HTT_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 6C, should be 64 [20080321]
ACPI: WMI: Mapper loaded
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
system 00:06: ioport range 0x480-0x48f has been reserved
system 00:06: ioport range 0x4d0-0x4d1 has been reserved
system 00:06: ioport range 0x800-0x87f could not be reserved
system 00:06: ioport range 0x400-0x40f has been reserved
system 00:07: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:07: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:07: iomem range 0xe0000000-0xefffffff has been reserved
system 00:07: iomem range 0xfec10000-0xfec10fff has been reserved
system 00:07: iomem range 0xffb00000-0xffffffff could not be reserved
system 00:0a: ioport range 0x290-0x29f has been reserved
system 00:0b: iomem range 0x0-0x9ffff could not be reserved
system 00:0b: iomem range 0xc0000-0xcffff could not be reserved
system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
system 00:0b: iomem range 0x100000-0x7fffffff could not be reserved
system 00:0b: iomem range 0x0-0xffffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
Switched to high resolution mode on CPU 0
  MEM window: 0xfc700000-0xfc7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
Switched to high resolution mode on CPU 1
  MEM window: 0xfc800000-0xfc8fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: 0xfc900000-0xfe9fffff
  PREFETCH window: 0x00000000c7e00000-0x00000000cfefffff
PCI: Bridge: 0000:00:06.0
  IO window: d000-dfff
  MEM window: 0xfea00000-0xfeafffff
  PREFETCH window: 0x0000000088000000-0x00000000880fffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 29 (level, low) -> IRQ 29
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 34 (level, low) -> IRQ 34
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Machine check exception polling timer started.
Initializing RT-Tester: OK
highmem bounce pool size: 64 pages
msgmni has been set to 1740 for ipc namespace c045fac0
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:03:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie01]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
Allocate Port Service[0000:00:02.0:pcie03]
AER service couldn't init device 0000:00:01.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:02.0:pcie01 - no _OSC support
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 21 (level, low) -> IRQ 21
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 29160N Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 May  2 2008
Advanced Linux Sound Architecture Driver Version 1.0.16.
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ processors (2 cpu cores) (version 2.20.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
Starting balanced_irq
Using IPI Shortcut mode
scsi: waiting for bus probes to complete ...
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
scsi 0:0:6:0: Direct-Access     IBM      DDYS-T36950N     S96H PQ: 0 ANSI: 3
------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x107/0x120()
Modules linked in:
Pid: 432, comm: scsi_scan_0 Not tainted 2.6.25-07351-g886c35f #1
 [<c0129684>] warn_on_slowpath+0x54/0x70
 [<c017a7c3>] ? check_object+0xe3/0x1f0
 [<c0200ae9>] ? init_tag_map+0x59/0xb0
 [<c014b1e7>] ? mark_held_locks+0x47/0x80
 [<c017cbeb>] ? __kmalloc+0x6b/0x100
 [<c014b379>] ? trace_hardirqs_on+0xb9/0x150
 [<c0200ae9>] ? init_tag_map+0x59/0xb0
 [<c0200ae9>] ? init_tag_map+0x59/0xb0
 [<c0200ae9>] ? init_tag_map+0x59/0xb0
 [<c0200c34>] ? __blk_queue_init_tags+0x24/0x70
 [<c0200c45>] ? __blk_queue_init_tags+0x35/0x70
 [<c0200e57>] blk_queue_init_tags+0x107/0x120
 [<c02b5a91>] ahc_platform_set_tags+0x191/0x1d0
 [<c02b5bd3>] ahc_linux_slave_configure+0x103/0x170
 [<c02a1f65>] scsi_probe_and_add_lun+0x6e5/0x920
 [<c02a2468>] __scsi_scan_target+0xe8/0x5d0
 [<c0108e17>] ? native_sched_clock+0x87/0xd0
 [<c0148c89>] ? get_lock_stats+0x29/0x50
 [<c0148cbd>] ? put_lock_stats+0xd/0x30
 [<c014b1e7>] ? mark_held_locks+0x47/0x80
 [<c035e247>] ? mutex_lock_nested+0x1b7/0x2a0
 [<c014b379>] ? trace_hardirqs_on+0xb9/0x150
 [<c035e23a>] ? mutex_lock_nested+0x1aa/0x2a0
 [<c02a2a1a>] ? scsi_scan_host_selected+0x3a/0xf0
 [<c02a29c0>] scsi_scan_channel+0x70/0x90
 [<c02a2a9d>] scsi_scan_host_selected+0xbd/0xf0
 [<c02a2b50>] ? do_scan_async+0x0/0x140
 [<c02a2b48>] do_scsi_scan_host+0x78/0x80
 [<c02a2b64>] do_scan_async+0x14/0x140
 [<c011f6e8>] ? complete+0x48/0x60
 [<c02a2b50>] ? do_scan_async+0x0/0x140
 [<c013c8d2>] kthread+0x42/0x70
 [<c013c890>] ? kthread+0x0/0x70
 [<c0103ceb>] kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 1437783fbb683a0c ]---
scsi0:A:6:0: Tagged Queuing enabled.  Depth 250
scsi target0:0:6: Beginning Domain Validation
scsi target0:0:6: wide asynchronous
scsi target0:0:6: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
scsi target0:0:6: Ending Domain Validation
sd 0:0:6:0: [sda] 71687340 512-byte hardware sectors (36704 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: cb 00 00 08
sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:6:0: [sda] 71687340 512-byte hardware sectors (36704 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: cb 00 00 08
sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:6:0: [sda] Attached SCSI disk
scsi_scan_0 used greatest stack depth: 5912 bytes left
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
debug: unmapping init memory c0489000..c0513000
Write protecting the kernel text: 2436k
Testing CPA: Reverting c0100000-c0361000
Testing CPA: write protecting again
Write protecting the kernel read-only data: 976k
Testing CPA: undo c0361000-c0455000
Testing CPA: write protecting again
grep used greatest stack depth: 5820 bytes left
ACPI: PCI Interrupt 0000:00:13.3[D] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:13.3: EHCI Host Controller
ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 1
sd 0:0:6:0: Attached scsi generic sg0 type 0
ehci_hcd 0000:00:13.3: debug port 1
ehci_hcd 0000:00:13.3: irq 23, io mem 0xfebff800
ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
ACPI: PCI Interrupt 0000:04:07.0[A] -> GSI 22 (level, low) -> IRQ 22
eth0: VIA Rhine II at 0xfeafec00, 00:50:ba:f2:a3:1d, IRQ 22.
eth0: MII PHY found at address 8, status 0x782d advertising 01e1 Link 45e1.
udev: renamed network interface eth0 to eth1
ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, low) -> IRQ 20
Adding 987988k swap on /dev/sda3.  Priority:-1 extents:1 across:987988k
EXT3 FS on sda1, internal journal
lp: driver loaded but no devices found
Linux agpgart interface v0.103
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
rc.S used greatest stack depth: 5616 bytes left
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
CPA self-test:
 4k 7168 large 217 gb 0 x 7385[c0000000-f7fff000] miss 0
 4k 197632 large 31 gb 0 x 197663[c0000000-f7fff000] miss 0
 4k 197632 large 31 gb 0 x 197663[c0000000-f7fff000] miss 0
ok.
sshd used greatest stack depth: 5604 bytes left



Kind regards,
  Jesper Juhl <jesper.juhl@gmail.com>


