From: Meelis Roos <mroos@ut.ee>
Subject: mptscsi: BUG: unable to handle kernel NULL pointer, in
 scsi_send_eh_cmnd
Date: Tue, 10 Jul 2012 11:44:01 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1207101143030.9883@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com, support@lsi.com
List-Id: linux-scsi@vger.kernel.org

Resending with correct linux-scsi address - please rteply to this one if 
you see duplicate messages.

I am using Linux 3.4.0 with a 53c1030 and a tape library that sometimes 
barfs for yet unknown reasons. When it happens, I get a BUG with 
backtrace and this scsi channel is dead until I reboot. Seems to be 
something with either generic scsi error handling or with mpt scsi.

Full dmesg:

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.0 (mroos@kosmos) (gcc version 4.4.5 (Debian 4.4.5-8) ) #22 SMP Mon Jun 11 18:19:26 EEST 2012
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
[    0.000000]  BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005ffeb180 (usable)
[    0.000000]  BIOS-e820: 000000005ffeb180 - 000000005fff0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000005fff0000 - 0000000060000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: IBM eserver xSeries 232 -[866823G]-/, BIOS -[QAE133AUS-1.08]- 02/25/2004
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x5ffeb max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 100000000 mask F00000000 write-back
[    0.000000]   3 base 200000000 mask E00000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000060000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] found SMP MP-table at [c0099940] 99940
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] Base memory trampoline at [c0098000] 98000 size 4096
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 17fb000-1800000
[    0.000000] ACPI: RSDP 000fdf70 00014 (v00 IBM   )
[    0.000000] ACPI: RSDT 5ffeff80 0002C (v01 IBM    SERQURTZ 00001000 IBM  45444F43)
[    0.000000] ACPI: FACP 5ffeff00 00074 (v01 IBM    SERQURTZ 00001000 IBM  45444F43)
[    0.000000] ACPI: DSDT 5ffeb180 04C69 (v01 IBM    SERQURTZ 00001000 MSFT 0100000B)
[    0.000000] ACPI: FACS 5ffefe40 00040
[    0.000000] ACPI: APIC 5ffefe80 00068 (v01 IBM    SERQURTZ 00001000 IBM  45444F43)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 647MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0005ffeb
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x0005ffeb
[    0.000000] On node 0 totalpages: 393076
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3945 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1296 pages used for memmap
[    0.000000]   HighMem zone: 164573 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4e8
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 14, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 13, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 31 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ7 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 48
[    0.000000] Allocating PCI resources starting at 60000000 (gap: 60000000:9ec00000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f6bdc000 s25056 r0 d24096 u49152
[    0.000000] pcpu-alloc: s25056 r0 d24096 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 390004
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.4.0 root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0005ffeb)
[    0.000000] Memory: 1554176k/1572780k available (3132k kernel code, 18128k reserved, 1059k data, 348k init, 663476k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1419000 - 0xc1470000   ( 348 kB)
[    0.000000]       .data : 0xc130f2c4 - 0xc1418140   (1059 kB)
[    0.000000]       .text : 0xc1000000 - 0xc130f2c4   (3132 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f6408000 soft=f640a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1127.991 MHz processor.
[    0.008004] Calibrating delay loop (skipped), value calculated using timer frequency.. 2255.98 BogoMIPS (lpj=4511964)
[    0.008184] pid_max: default: 32768 minimum: 301
[    0.008358] Mount-cache hash table entries: 512
[    0.008898] Initializing cgroup subsys blkio
[    0.009051] mce: CPU supports 5 MCE banks
[    0.009221] Freeing SMP alternatives: 16k freed
[    0.009331] ACPI: Core revision 20120320
[    0.013665] Enabling APIC mode:  Flat.  Using 2 I/O APICs
[    0.014280] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.016000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.016000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.016000] ..... (found apic 0 pin 2) ...
[    0.016000] ....... failed.
[    0.016000] ...trying to set up timer as Virtual Wire IRQ...
[    0.057927] ..... works.
[    0.058013] CPU0: Intel(R) Pentium(R) III CPU family      1133MHz stepping 01
[    0.060003] Performance Events: p6 PMU driver.
[    0.060003] ... version:                0
[    0.060003] ... bit width:              32
[    0.060003] ... generic registers:      2
[    0.060003] ... value mask:             00000000ffffffff
[    0.060003] ... max period:             000000007fffffff
[    0.060003] ... fixed-purpose events:   0
[    0.060003] ... event mask:             0000000000000003
[    0.060003] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.060003] CPU 1 irqstacks, hard=f647a000 soft=f647c000
[    0.060003] Booting Node   0, Processors  #1 Ok.
[    0.012000] Initializing CPU#1
[    0.152052] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.152279] Brought up 2 CPUs
[    0.152367] Total of 2 processors activated (4511.91 BogoMIPS).
[    0.153759] NET: Registered protocol family 16
[    0.153759] ACPI: bus type pci registered
[    0.153759] PCI: PCI BIOS revision 2.10 entry at 0xfd7ec, last bus=2
[    0.153759] PCI: Using configuration type 1 for base access
[    0.160101] bio: create slab <bio-0> at 0
[    0.160225] ACPI: Added _OSI(Module Device)
[    0.160225] ACPI: Added _OSI(Processor Device)
[    0.160242] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.160334] ACPI: Added _OSI(Processor Aggregator Device)
[    0.161544] ACPI: EC: Look up EC in DSDT
[    0.166987] ACPI: Interpreter enabled
[    0.167075] ACPI: (supports S0 S5)
[    0.167203] ACPI: Using IOAPIC for interrupt routing
[    0.176151] ACPI: No dock devices found.
[    0.176257] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.179267] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00])
[    0.184980] pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df] (ignored)
[    0.184989] pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb] (ignored)
[    0.184997] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.185006] pci_root PNP0A03:00: host bridge window [mem 0xfd000000-0xffffffff] (ignored)
[    0.185014] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfcffffff] (ignored)
[    0.185022] pci_root PNP0A03:00: host bridge window [io  0x03e0-0x207f] (ignored)
[    0.185030] pci_root PNP0A03:00: host bridge window [io  0x03bc-0x03bf] (ignored)
[    0.185038] pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af] (ignored)
[    0.185045] PCI: root bus 00: using default resources
[    0.185123] PCI host bridge to bus 0000:00
[    0.185123] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.185123] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.185123] pci 0000:00:00.0: [1166:0008] type 00 class 0x060000
[    0.185123] pci 0000:00:00.1: [1166:0008] type 00 class 0x060000
[    0.185123] pci 0000:00:00.2: [1166:0006] type 00 class 0x060000
[    0.185123] pci 0000:00:00.3: [1166:0006] type 00 class 0x060000
[    0.185123] pci 0000:00:01.0: [1014:010f] type 00 class 0x068000
[    0.185123] pci 0000:00:01.0: reg 10: [mem 0xfea00000-0xfebfffff 64bit]
[    0.185123] pci 0000:00:01.0: reg 18: [io  0x2000-0x207f]
[    0.185123] pci 0000:00:01.0: reg 30: [mem 0x00000000-0x001fffff pref]
[    0.185123] pci 0000:00:06.0: [5333:8a22] type 00 class 0x030000
[    0.185123] pci 0000:00:06.0: reg 10: [mem 0xfe980000-0xfe9fffff]
[    0.185123] pci 0000:00:06.0: reg 14: [mem 0xf0000000-0xf7ffffff pref]
[    0.185123] pci 0000:00:06.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.185123] pci 0000:00:06.0: supports D1 D2
[    0.185123] pci 0000:00:0f.0: [1166:0200] type 00 class 0x060100
[    0.185123] pci 0000:00:0f.1: [1166:0211] type 00 class 0x01018a
[    0.185123] pci 0000:00:0f.1: reg 20: [io  0x0840-0x084f]
[    0.185123] pci 0000:00:0f.2: [1166:0220] type 00 class 0x0c0310
[    0.185123] pci 0000:00:0f.2: reg 10: [mem 0xfe97f000-0xfe97ffff]
[    0.185123] pci_bus 0000:00: on NUMA node 0
[    0.185123] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.185123]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x18)
[    0.192417] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 01])
[    0.196171] pci_root PNP0A03:01: host bridge window [mem 0xee000000-0xefffffff] (ignored)
[    0.196180] pci_root PNP0A03:01: host bridge window [mem 0xebf00000-0xebffffff] (ignored)
[    0.196188] pci_root PNP0A03:01: host bridge window [io  0x2080-0x22ff] (ignored)
[    0.196195] PCI: root bus 01: using default resources
[    0.196266] PCI host bridge to bus 0000:01
[    0.196266] pci_bus 0000:01: root bus resource [io  0x0000-0xffff]
[    0.196266] pci_bus 0000:01: root bus resource [mem 0x00000000-0xffffffff]
[    0.196322] pci 0000:01:02.0: [1014:01bd] type 00 class 0x010400
[    0.196349] pci 0000:01:02.0: reg 10: [mem 0xebffe000-0xebffffff pref]
[    0.196412] pci 0000:01:02.0: reg 30: [mem 0x00000000-0x00007fff pref]
[    0.196471] pci 0000:01:03.0: [1000:0030] type 00 class 0x010000
[    0.196495] pci 0000:01:03.0: reg 10: [io  0x2100-0x21ff]
[    0.196513] pci 0000:01:03.0: reg 14: [mem 0xefff0000-0xefffffff 64bit]
[    0.196531] pci 0000:01:03.0: reg 1c: [mem 0xeffe0000-0xeffeffff 64bit]
[    0.196551] pci 0000:01:03.0: reg 30: [mem 0x00000000-0x000fffff pref]
[    0.196594] pci 0000:01:03.0: supports D1 D2
[    0.196624] pci 0000:01:03.1: [1000:0030] type 00 class 0x010000
[    0.196648] pci 0000:01:03.1: reg 10: [io  0x2200-0x22ff]
[    0.196665] pci 0000:01:03.1: reg 14: [mem 0xeffd0000-0xeffdffff 64bit]
[    0.196683] pci 0000:01:03.1: reg 1c: [mem 0xeffc0000-0xeffcffff 64bit]
[    0.196703] pci 0000:01:03.1: reg 30: [mem 0x00000000-0x000fffff pref]
[    0.196746] pci 0000:01:03.1: supports D1 D2
[    0.196782] pci 0000:01:07.0: [8086:1229] type 00 class 0x020000
[    0.196801] pci 0000:01:07.0: reg 10: [mem 0xeffbf000-0xeffbffff]
[    0.196814] pci 0000:01:07.0: reg 14: [io  0x2080-0x20bf]
[    0.196827] pci 0000:01:07.0: reg 18: [mem 0xeff80000-0xeff9ffff]
[    0.196859] pci 0000:01:07.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.196887] pci 0000:01:07.0: supports D1 D2
[    0.196893] pci 0000:01:07.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.196933] pci_bus 0000:01: on NUMA node 0
[    0.196940] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
[    0.197060]  pci0000:01: Unable to request _OSC control (_OSC support mask: 0x18)
[    0.201416] ACPI: PCI Root Bridge [PCI2] (domain 0000 [bus 02])
[    0.206069] pci_root PNP0A03:02: host bridge window [mem 0xec000000-0xedffffff] (ignored)
[    0.206078] pci_root PNP0A03:02: host bridge window [mem 0xa6000000-0xebefffff] (ignored)
[    0.206086] pci_root PNP0A03:02: host bridge window [mem 0x60000000-0xa5ffffff] (ignored)
[    0.206094] pci_root PNP0A03:02: host bridge window [io  0x2300-0xffff] (ignored)
[    0.206101] PCI: root bus 02: using default resources
[    0.206179] PCI host bridge to bus 0000:02
[    0.206179] pci_bus 0000:02: root bus resource [io  0x0000-0xffff]
[    0.206179] pci_bus 0000:02: root bus resource [mem 0x00000000-0xffffffff]
[    0.206179] pci 0000:02:04.0: [105a:3d18] type 00 class 0x018000
[    0.206179] pci 0000:02:04.0: reg 10: [io  0x2300-0x237f]
[    0.206179] pci 0000:02:04.0: reg 18: [io  0x2400-0x24ff]
[    0.206179] pci 0000:02:04.0: reg 1c: [mem 0xedfff000-0xedffffff]
[    0.206179] pci 0000:02:04.0: reg 20: [mem 0xedfc0000-0xedfdffff]
[    0.206179] pci 0000:02:04.0: reg 30: [mem 0x00000000-0x00007fff pref]
[    0.206179] pci 0000:02:04.0: supports D1
[    0.206179] pci_bus 0000:02: on NUMA node 0
[    0.206179] ACPI: PCI Interrupt Routing Table [\_SB_.PCI2._PRT]
[    0.206179]  pci0000:02: Unable to request _OSC control (_OSC support mask: 0x18)
[    0.206179] ACPI: PCI Interrupt Link [LPVI] (IRQs) *0, disabled.
[    0.208054] ACPI: PCI Interrupt Link [LPUS] (IRQs *11)
[    0.208388] ACPI: PCI Interrupt Link [LP1A] (IRQs *15)
[    0.208715] ACPI: PCI Interrupt Link [LP1B] (IRQs) *0, disabled.
[    0.209062] ACPI: PCI Interrupt Link [LPE1] (IRQs *4)
[    0.209396] ACPI: PCI Interrupt Link [LP2A] (IRQs *9)
[    0.209724] ACPI: PCI Interrupt Link [LP2B] (IRQs) *0, disabled.
[    0.210066] ACPI: PCI Interrupt Link [LP3A] (IRQs *10)
[    0.210398] ACPI: PCI Interrupt Link [LP3B] (IRQs *9)
[    0.210725] ACPI: PCI Interrupt Link [LPSA] (IRQs) *0, disabled.
[    0.211062] ACPI: PCI Interrupt Link [LPSB] (IRQs) *0, disabled.
[    0.211408] ACPI: PCI Interrupt Link [LP4A] (IRQs *10)
[    0.211747] ACPI: PCI Interrupt Link [LP4B] (IRQs) *0, disabled.
[    0.212094] ACPI: PCI Interrupt Link [LP5A] (IRQs) *0, disabled.
[    0.212427] ACPI: PCI Interrupt Link [LP5B] (IRQs) *0, disabled.
[    0.212629] vgaarb: device added: PCI:0000:00:06.0,decodes=io+mem,owns=io+mem,locks=none
[    0.212629] vgaarb: loaded
[    0.212629] vgaarb: bridge control possible 0000:00:06.0
[    0.212629] SCSI subsystem initialized
[    0.212629] PCI: Using ACPI for IRQ routing
[    0.212629] PCI: pci_cache_line_size set to 32 bytes
[    0.212629] reserve RAM buffer: 0000000000099800 - 000000000009ffff 
[    0.212629] reserve RAM buffer: 000000005ffeb180 - 000000005fffffff 
[    0.212629] pnp: PnP ACPI init
[    0.212629] ACPI: bus type pnp registered
[    0.218267] pnp 00:00: [io  0x03c0-0x03df window]
[    0.218275] pnp 00:00: [io  0x03b0-0x03bb window]
[    0.218282] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.218288] pnp 00:00: [bus 00]
[    0.218293] pnp 00:00: [mem 0xfd000000-0xffffffff window]
[    0.218300] pnp 00:00: [mem 0xf0000000-0xfcffffff window]
[    0.218306] pnp 00:00: [io  0x03e0-0x207f window]
[    0.218312] pnp 00:00: [io  0x03bc-0x03bf window]
[    0.218318] pnp 00:00: [io  0x0000-0x03af window]
[    0.218422] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.218422] pnp 00:01: [io  0x002e-0x002f]
[    0.218422] pnp 00:01: [io  0x0438-0x0439]
[    0.218422] pnp 00:01: [io  0x0430-0x0437]
[    0.218422] system 00:01: [io  0x0438-0x0439] has been reserved
[    0.218422] system 00:01: [io  0x0430-0x0437] has been reserved
[    0.218422] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.218422] pnp 00:02: [io  0x0060]
[    0.218422] pnp 00:02: [io  0x0064]
[    0.218422] pnp 00:02: [irq 1]
[    0.218422] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.218422] pnp 00:03: [irq 12]
[    0.218422] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.218422] pnp 00:04: [io  0x03f0-0x03f5]
[    0.218422] pnp 00:04: [irq 6]
[    0.218422] pnp 00:04: [dma 2]
[    0.218422] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.220215] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (disabled)
[    0.220267] pnp 00:06: [io  0x02f8-0x02ff]
[    0.220279] pnp 00:06: [irq 3]
[    0.220434] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.220434] pnp 00:07: [io  0x0020-0x0021]
[    0.220434] pnp 00:07: [io  0x00a0-0x00a1]
[    0.220434] pnp 00:07: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.220434] pnp 00:08: [dma 4]
[    0.220434] pnp 00:08: [io  0x0000-0x001f]
[    0.220434] pnp 00:08: [io  0x0080-0x008f]
[    0.220434] pnp 00:08: [io  0x00c0-0x00df]
[    0.220434] pnp 00:08: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.220434] pnp 00:09: [io  0x0070-0x0073]
[    0.220434] pnp 00:09: [irq 8]
[    0.220434] pnp 00:09: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.220434] pnp 00:0a: [io  0x0061]
[    0.220434] pnp 00:0a: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.220434] pnp 00:0b: [io  0x00f0-0x00ff]
[    0.220434] pnp 00:0b: [irq 13]
[    0.220434] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.220434] pnp 00:0c: [io  0x0092]
[    0.220434] pnp 00:0c: [io  0x00ea-0x00ef]
[    0.220434] pnp 00:0c: [io  0x0374-0x0375]
[    0.220434] pnp 00:0c: [io  0x0377]
[    0.220434] pnp 00:0c: [io  0x0400-0x047f]
[    0.220434] pnp 00:0c: [io  0x0480-0x0500]
[    0.220434] pnp 00:0c: [io  0x0600]
[    0.220434] pnp 00:0c: [io  0x0932]
[    0.220434] pnp 00:0c: [io  0x0c00-0x0cfe]
[    0.220434] pnp 00:0c: [io  0x0f50-0x0f58]
[    0.220434] pnp 00:0c: [mem 0xfec00000-0xffffffff]
[    0.220434] system 00:0c: [io  0x0374-0x0375] has been reserved
[    0.220434] system 00:0c: [io  0x0377] has been reserved
[    0.220434] system 00:0c: [io  0x0400-0x047f] could not be reserved
[    0.220434] system 00:0c: [io  0x0480-0x0500] has been reserved
[    0.220434] system 00:0c: [io  0x0600] has been reserved
[    0.220508] system 00:0c: [io  0x0932] has been reserved
[    0.220602] system 00:0c: [io  0x0c00-0x0cfe] could not be reserved
[    0.220697] system 00:0c: [io  0x0f50-0x0f58] has been reserved
[    0.220793] system 00:0c: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.220889] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.224684] pnp 00:0d: [bus 01]
[    0.224691] pnp 00:0d: [mem 0xee000000-0xefffffff window]
[    0.224698] pnp 00:0d: [mem 0xebf00000-0xebffffff window]
[    0.224704] pnp 00:0d: [io  0x2080-0x22ff window]
[    0.224791] pnp 00:0d: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.226373] pnp 00:0e: [bus 02]
[    0.226380] pnp 00:0e: [mem 0xec000000-0xedffffff window]
[    0.226387] pnp 00:0e: [mem 0xa6000000-0xebefffff window]
[    0.226393] pnp 00:0e: [mem 0x60000000-0xa5ffffff window]
[    0.226399] pnp 00:0e: [io  0x2300-0xffff window]
[    0.226480] pnp 00:0e: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.226480] pnp: PnP ACPI: found 15 devices
[    0.226480] ACPI: ACPI bus type pnp unregistered
[    0.270029] Switching to clocksource acpi_pm
[    0.270123] pci 0000:00:01.0: BAR 6: assigned [mem 0x60000000-0x601fffff pref]
[    0.270123] pci 0000:00:06.0: BAR 6: assigned [mem 0x60200000-0x6020ffff pref]
[    0.270123] pci 0000:01:03.0: BAR 6: assigned [mem 0x60300000-0x603fffff pref]
[    0.270123] pci 0000:01:03.1: BAR 6: assigned [mem 0x60400000-0x604fffff pref]
[    0.270123] pci 0000:01:07.0: BAR 6: assigned [mem 0x60210000-0x6021ffff pref]
[    0.270123] pci 0000:01:02.0: BAR 6: assigned [mem 0x60220000-0x60227fff pref]
[    0.271033] pci 0000:02:04.0: BAR 6: assigned [mem 0x60228000-0x6022ffff pref]
[    0.271195] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.271202] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.271209] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    0.271215] pci_bus 0000:01: resource 5 [mem 0x00000000-0xffffffff]
[    0.271222] pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
[    0.271229] pci_bus 0000:02: resource 5 [mem 0x00000000-0xffffffff]
[    0.271409] NET: Registered protocol family 2
[    0.271902] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.272465] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.276618] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.278971] TCP: Hash tables configured (established 131072 bind 65536)
[    0.279077] TCP: reno registered
[    0.279185] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.279356] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.279821] NET: Registered protocol family 1
[    0.279989] pci 0000:00:06.0: Boot video device
[    0.280435] ACPI: PCI Interrupt Link [LPUS] enabled at IRQ 11
[    0.352096] pci 0000:01:07.0: Firmware left e100 interrupts enabled; disabling
[    0.352258] PCI: CLS mismatch (32 != 4), using 32 bytes
[    0.354895] highmem bounce pool size: 64 pages
[    0.367234] VFS: Disk quotas dquot_6.5.2
[    0.367554] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.369935] msgmni has been set to 1739
[    0.371061] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.371227] io scheduler noop registered
[    0.371327] io scheduler cfq registered (default)
[    0.371814] Serial: 8250/16550 driver, 16 ports, IRQ sharing enabled
[    0.392858] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.395289] serial 00:05: [io  0x03f8-0x03ff]
[    0.395456] serial 00:05: [io  0x03e8-0x03ef]
[    0.395597] serial 00:05: [io  0x02e8-0x02ef]
[    0.395733] serial 00:05: unable to assign resources
[    0.395823] serial: probe of 00:05 failed with error -16
[    0.416980] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.417883] Non-volatile memory driver v1.3
[    0.417978] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    0.418144] Hangcheck: Using getrawmonotonic().
[    0.418778] Floppy drive(s): fd0 is 1.44M
[    0.435003] FDC 0 is a National Semiconductor PC87306
[    0.458839] scsi0 : IBM PCI ServeRAID 7.12.05  Build 761 <ServeRAID 4Lx>
[    0.459610] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.459711] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.459825] scsi 0:0:0:0: Direct-Access     IBM      SERVERAID        1.00 PQ: 0 ANSI: 2
[    0.460143] scsi 0:0:1:0: Direct-Access     IBM      SERVERAID        1.00 PQ: 0 ANSI: 2
[    0.463328] scsi 0:0:15:0: Processor         IBM      SERVERAID        1.00 PQ: 0 ANSI: 2
[    0.499478] scsi 0:1:8:0: Processor         IBM      St  V1S2         0    PQ: 0 ANSI: 2
[    0.546968] e100 0000:01:07.0: eth0: addr 0xeffbf000, irq 28, MAC addr 00:09:6b:b0:10:c2
[    0.547425] sd 0:0:0:0: [sda] 71094272 512-byte logical blocks: (36.4 GB/33.9 GiB)
[    0.547606] sd 0:0:0:0: [sda] Assuming Write Enabled
[    0.547715] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    0.547915] sd 0:0:1:0: [sdb] 286744576 512-byte logical blocks: (146 GB/136 GiB)
[    0.548172] sd 0:0:1:0: [sdb] Assuming Write Enabled
[    0.548262] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[    0.548619] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.549235] sd 0:0:1:0: [sdb] Assuming Write Enabled
[    0.549335] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[    0.550235] sd 0:0:0:0: [sda] Assuming Write Enabled
[    0.550340] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    0.551059] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.551160] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.551572]  sda: sda1 sda2 sda3
[    0.552239] mousedev: PS/2 mouse device common for all mice
[    0.553194] sd 0:0:0:0: [sda] Assuming Write Enabled
[    0.553281] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    0.553366] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.553518] rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
[    0.553653] rtc0: alarms up to one year, 242 bytes nvram
[    0.553892] cpuidle: using governor ladder
[    0.553984] cpuidle: using governor menu
[    0.554652] TCP: cubic registered
[    0.554741] NET: Registered protocol family 17
[    0.554886] Using IPI Shortcut mode
[    0.555463] registered taskstats version 1
[    0.556136] console [netcon0] enabled
[    0.556225] netconsole: network logging started
[    0.556393] rtc_cmos 00:09: setting system clock to 2012-07-09 08:31:03 UTC (1341822663)
[    0.561638]  sdb: sdb1
[    0.562625] sd 0:0:1:0: [sdb] Assuming Write Enabled
[    0.562721] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[    0.562816] sd 0:0:1:0: [sdb] Attached SCSI disk
[    0.641483] kjournald starting.  Commit interval 5 seconds
[    0.641532] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    0.641554] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    0.641784] Freeing unused kernel memory: 348k freed
[    0.642454] Write protecting the kernel text: 3136k
[    0.642599] Write protecting the kernel read-only data: 888k
[    1.352081] Refined TSC clocksource calibration: 1127.903 MHz.
[    1.352188] Switching to clocksource tsc
[    2.336446] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.336645] ACPI: Power Button [PWRF]
[    2.376604] Linux agpgart interface v0.103
[    2.387291] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.387467] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    2.387616] scsi 0:0:15:0: Attached scsi generic sg2 type 3
[    2.387770] scsi 0:1:8:0: Attached scsi generic sg3 type 3
[    2.399295] Fusion MPT base driver 3.04.20
[    2.399396] Copyright (c) 1999-2008 LSI Corporation
[    2.426468] piix4_smbus 0000:00:0f.0: SMBus Host Controller at 0x440, revision 0
[    2.451688] microcode: CPU0 sig=0x6b1, pf=0x10, revision=0x1c
[    2.501126] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    2.504097] agpgart-serverworks 0000:00:00.0: can't determine aperture size
[    2.504200] agpgart-serverworks 0000:00:00.0: agp_backend_initialize() failed
[    2.504299] agpgart-serverworks: probe of 0000:00:00.0 failed with error -22
[    2.504406] agpgart-serverworks 0000:00:00.1: can't determine aperture size
[    2.504514] agpgart-serverworks 0000:00:00.1: agp_backend_initialize() failed
[    2.504620] agpgart-serverworks: probe of 0000:00:00.1 failed with error -22
[    2.504729] agpgart-serverworks 0000:00:00.2: ServerWorks CNB20HE is unsupported due to lack of documentation
[    2.504916] agpgart-serverworks 0000:00:00.3: ServerWorks CNB20HE is unsupported due to lack of documentation
[    2.511856] input: ibmasm RSA I remote mouse as /devices/pci0000:00/0000:00:01.0/input/input2
[    2.512301] input: ibmasm RSA I remote keyboard as /devices/pci0000:00/0000:00:01.0/input/input3
[    2.512521] ibmasm remote responding to events on RSA card 0
[    2.516125] libata version 3.00 loaded.
[    2.536974] Fusion MPT SPI Host driver 3.04.20
[    2.537064] serial8250: ttyS4 at MMIO 0x0 (irq = 16) is a 16550A
[    2.537205] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.540997] mptbase: ioc0: Initiating bringup
[    2.599458] microcode: CPU1 sig=0x6b1, pf=0x10, revision=0x1c
[    2.605128] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.643294] sata_promise 0000:02:04.0: version 2.12
[    2.645237] scsi1 : sata_promise
[    2.645603] scsi2 : sata_promise
[    2.645900] scsi3 : sata_promise
[    2.646191] scsi4 : sata_promise
[    2.646365] ata1: SATA max UDMA/133 mmio m4096@0xedfff000 ata 0xedfff380 irq 22
[    2.646531] ata2: SATA max UDMA/133 mmio m4096@0xedfff000 ata 0xedfff280 irq 22
[    2.646694] ata3: SATA max UDMA/133 mmio m4096@0xedfff000 ata 0xedfff200 irq 22
[    2.646860] ata4: SATA max UDMA/133 mmio m4096@0xedfff000 ata 0xedfff300 irq 22
[    2.764225] scsi5 : pata_serverworks
[    2.764522] scsi6 : pata_serverworks
[    2.764697] ata5: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x840 irq 14
[    2.764795] ata6: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x848 irq 15
[    2.789518] usbcore: registered new interface driver usbfs
[    2.789652] usbcore: registered new interface driver hub
[    2.791143] usbcore: registered new device driver usb
[    3.028028] ioc0: LSI53C1030 B2: Capabilities={Initiator}
[    3.120063] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.161599] ata1.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[    3.161698] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    3.228239] ata1.00: configured for UDMA/133
[    3.228651] scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    3.229128] sd 1:0:0:0: Attached scsi generic sg4 type 0
[    3.229170] sd 1:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    3.229311] sd 1:0:0:0: [sdc] Write Protect is off
[    3.229319] sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.229379] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.268084]  sdc: sdc1
[    3.268742] sd 1:0:0:0: [sdc] Attached SCSI disk
[    3.524995] scsi7 : ioc0: LSI53C1030 B2, FwRev=01013d00h, Ports=1, MaxQ=255, IRQ=20
[    3.704049] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.712367] ata2.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
[    3.712461] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    3.720388] ata2.00: configured for UDMA/133
[    3.720801] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1AG0 PQ: 0 ANSI: 5
[    3.721251] sd 2:0:0:0: Attached scsi generic sg5 type 0
[    3.721274] sd 2:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.721409] sd 2:0:0:0: [sdd] Write Protect is off
[    3.721416] sd 2:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.721475] sd 2:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.775650]  sdd: sdd1
[    3.776288] sd 2:0:0:0: [sdd] Attached SCSI disk
[    3.899028] mptbase: ioc1: Initiating bringup
[    4.200057] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.208395] ata3.00: ATA-8: SAMSUNG HD204UI, 1AQ10001, max UDMA/133
[    4.208504] ata3.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    4.216369] ata3.00: configured for UDMA/133
[    4.216509] scsi: waiting for bus probes to complete ...
[    4.376023] ioc1: LSI53C1030 B2: Capabilities={Initiator}
[    4.873010] scsi8 : ioc1: LSI53C1030 B2, FwRev=01013d00h, Ports=1, MaxQ=255, IRQ=21
[    5.758046] scsi 7:0:3:0: Sequential-Access IBM      ULTRIUM-TD3      93G0 PQ: 0 ANSI: 3
[    5.758210] scsi 7:0:3:0: Information Units disabled by blacklist
[    5.758316] scsi target7:0:3: Beginning Domain Validation
[    5.849706] scsi target7:0:3: Domain Validation skipping write tests
[    5.849814] scsi target7:0:3: Ending Domain Validation
[    5.849984] scsi target7:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[    6.449532] scsi 7:0:3:1: Medium Changer    FSC      FibreCAT TX48    D184 PQ: 0 ANSI: 4
[    6.453577] scsi 7:0:4:0: Sequential-Access IBM      ULTRIUM-TD3      93G0 PQ: 0 ANSI: 3
[    6.453755] scsi 7:0:4:0: Information Units disabled by blacklist
[    6.453870] scsi target7:0:4: Beginning Domain Validation
[    6.488409] scsi target7:0:4: Domain Validation skipping write tests
[    6.488505] scsi target7:0:4: Ending Domain Validation
[    6.488682] scsi target7:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[    8.993266] scsi 7:0:3:0: Attached scsi generic sg6 type 1
[    8.993562] scsi 7:0:3:1: Attached scsi generic sg7 type 8
[    8.993909] scsi 7:0:4:0: Attached scsi generic sg8 type 1
[    8.994360] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD204UI  1AQ1 PQ: 0 ANSI: 5
[    8.994819] sd 3:0:0:0: Attached scsi generic sg9 type 0
[    8.995068] sd 3:0:0:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.995455] sd 3:0:0:0: [sde] Write Protect is off
[    8.995546] sd 3:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    8.995606] sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.026678]  sde: sde1
[    9.027265] sd 3:0:0:0: [sde] Attached SCSI disk
[    9.468052] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.476369] ata4.00: ATA-8: SAMSUNG HD204UI, 1AQ10001, max UDMA/133
[    9.476467] ata4.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    9.484392] ata4.00: configured for UDMA/133
[    9.484806] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD204UI  1AQ1 PQ: 0 ANSI: 5
[    9.485279] sd 4:0:0:0: Attached scsi generic sg10 type 0
[    9.485336] sd 4:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    9.485475] sd 4:0:0:0: [sdf] Write Protect is off
[    9.485483] sd 4:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    9.485543] sd 4:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.515424]  sdf: sdf1
[    9.516059] sd 4:0:0:0: [sdf] Attached SCSI disk
[    9.660939] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.670312] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.670532] ohci_hcd 0000:00:0f.2: OHCI Host Controller
[    9.670643] ohci_hcd 0000:00:0f.2: new USB bus registered, assigned bus number 1
[    9.670869] ohci_hcd 0000:00:0f.2: irq 11, io mem 0xfe97f000
[    9.681825] SCSI Media Changer driver v0.25 
[    9.711715] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    9.726142] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    9.726255] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.726420] usb usb1: Product: OHCI Host Controller
[    9.726512] usb usb1: Manufacturer: Linux 3.4.0 ohci_hcd
[    9.726609] usb usb1: SerialNumber: 0000:00:0f.2
[    9.726953] hub 1-0:1.0: USB hub found
[    9.727066] hub 1-0:1.0: 4 ports detected
[    9.792888] osst :I: Tape driver with OnStream support version 0.99.4
[    9.792894] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    9.979428] ch0: type #1 (mt): 0x61+1 [medium transport]
[    9.979528] ch0: type #2 (st): 0x1+22 [storage]
[    9.979616] ch0: type #3 (ie): 0x71+1 [import/export]
[    9.979700] ch0: type #4 (dt): 0x51+2 [data transfer]
[   10.280184] ch0: dt 0x51: ch0: ID 3, LUN 0, ch0: name: IBM      ULTRIUM-TD3      93G0
[   10.589321] ch0: dt 0x52: ch0: not this SCSI bus
[   10.589428] ch0: INITIALIZE ELEMENT STATUS, may take some time ...
[   10.893115] ch0: ... finished
[   10.893217] ch 7:0:3:1: Attached scsi changer ch0
[   10.893750] st 7:0:3:0: Attached scsi tape st0
[   10.893844] st 7:0:3:0: st0: try direct i/o: yes (alignment 512 B)
[   10.897325] st 7:0:4:0: Attached scsi tape st1
[   10.897433] st 7:0:4:0: st1: try direct i/o: yes (alignment 512 B)
[   12.699756] Adding 2931856k swap on /dev/sda2.  Priority:-1 extents:1 across:2931856k 
[   33.225160] EXT3-fs (sda1): using internal journal
[   33.324050] loop: module loaded
[  206.097954] kjournald starting.  Commit interval 5 seconds
[  206.098467] EXT3-fs (sda3): using internal journal
[  206.098573] EXT3-fs (sda3): mounted filesystem with writeback data mode
[  206.180172] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[  206.226551] EXT4-fs (sdd1): mounted filesystem with ordered data mode. Opts: (null)
[  206.268279] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
[  206.494021] EXT4-fs (sde1): mounted filesystem with ordered data mode. Opts: (null)
[  206.656179] EXT4-fs (sdf1): mounted filesystem with ordered data mode. Opts: (null)
[  207.204315] e100 0000:01:07.0: eth0: NIC Link is Up 100 Mbps Full Duplex
[  207.477581] fuse init (API version 7.18)
[  208.081576] NET: Registered protocol family 10
[  210.064340] sshd (2104): /proc/2104/oom_adj is deprecated, please use /proc/2104/oom_score_adj instead.
[42002.400047] mptscsih: ioc0: attempting task abort! (sc=ccd37e60)
[42002.400202] ch 7:0:3:1: [sg7] CDB: Move medium/play audio(12): a5 00 00 61 00 51 00 08 00 00 00 00
[42002.520021] mptscsih: ioc0: task abort: FAILED (rv=2003) (sc=ccd37e60)
[42002.520112] mptscsih: ioc0: attempting target reset! (sc=ccd37e60)
[42002.520192] ch 7:0:3:1: [sg7] CDB: Move medium/play audio(12): a5 00 00 61 00 51 00 08 00 00 00 00
[42004.524035] mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
[42004.524119] mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
[42004.524270] mptbase: ioc0: Initiating recovery
[42004.524351] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[42004.524428] mptbase: ioc0: WARNING -            FAULT code = 000eh
[42012.640018] mptscsih: ioc0: WARNING - Issuing Reset from mptscsih_IssueTaskMgmt!! doorbell=0x4000000e
[42044.516021] mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
[42049.744031] mptbase: ioc0: Recovered from IOC FAULT
[42051.248025] mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
[42051.796027] mptscsih: ioc0: target reset: SUCCESS (sc=ccd37e60)
[42051.796121] BUG: unable to handle kernel NULL pointer dereference at   (null)
[42051.796211] IP: [<c122dc63>] scsi_send_eh_cmnd+0x33/0x320
[42051.796307] *pde = 00000000 
[42051.796389] Oops: 0000 [#1] SMP 
[42051.796470] Modules linked in: ipv6 fuse eeprom loop osst st ch ohci_hcd ehci_hcd usbcore pata_serverworks sata_promise mptspi libata ibmasm evdev sworks_agp pcspkr mptscsih usb_common microcode i2c_piix4 i2c_core mptbase sg agpgart scsi_transport_spi button processor
[42051.796864] 
[42051.796940] Pid: 709, comm: scsi_eh_7 Not tainted 3.4.0 #22 IBM eserver xSeries 232 -[866823G]-/
[42051.797098] EIP: 0060:[<c122dc63>] EFLAGS: 00010286 CPU: 1
[42051.797184] EIP is at scsi_send_eh_cmnd+0x33/0x320
[42051.797264] EAX: 00000000 EBX: ccd37e60 ECX: 00000006 EDX: f5d73400
[42051.797343] ESI: 00000001 EDI: 00000000 EBP: f5f8bebc ESP: f5f8be2c
[42051.797426]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[42051.797503] CR0: 8005003b CR2: 00000000 CR3: 36621000 CR4: 000007d0
[42051.797586] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[42051.797665] DR6: ffff0ff0 DR7: 00000400
[42051.797742] Process scsi_eh_7 (pid: 709, ti=f5f8a000 task=f64acf80 task.ti=f5f8a000)
[42051.797880] Stack:
[42051.797951]  f5f8bea8 00000246 f5f8be66 c1390341 0000a443 000c257b 00000006 c14c2348
[42051.798116]  00000001 c14a0fa3 00000000 0000000f 00000049 00000006 345b0001 31353032
[42051.798291]  3639372e 5d373230 00000020 f5f8be8c f814b704 f5eda000 00000000 f5fc7660
[42051.798465] Call Trace:
[42051.798561]  [<f814b704>] ? mpt_free_msg_frame+0x54/0x70 [mptbase]
[42051.798651]  [<f804e050>] ? mptscsih_IssueTaskMgmt+0x80/0x360 [mptscsih]
[42051.798732]  [<c122dff4>] scsi_eh_tur+0x34/0xa0
[42051.798811]  [<c122eab1>] scsi_eh_bus_device_reset+0xd1/0x1f0
[42051.798890]  [<c122ec0b>] scsi_eh_ready_devs+0x3b/0x100
[42051.798970]  [<c122ef40>] scsi_unjam_host+0xa0/0x1c0
[42051.799049]  [<c122f157>] scsi_error_handler+0xf7/0x140
[42051.799132]  [<c10490e6>] ? complete+0x46/0x60
[42051.799214]  [<c122f060>] ? scsi_unjam_host+0x1c0/0x1c0
[42051.799298]  [<c1040784>] kthread+0x74/0x80
[42051.799376]  [<c1040710>] ? kthread_worker_fn+0x110/0x110
[42051.799460]  [<c130e61e>] kernel_thread_helper+0x6/0xd
[42051.799539] Code: 89 c3 81 ec 84 00 00 00 65 a1 14 00 00 00 89 45 f0 31 c0 8b 43 54 89 55 8c 8b 13 89 4d 88 8b 40 68 85 c0 74 08 8b 80 4c 01 00 00 <8b> 38 8d 45 98 8b 32 89 45 98 8b 4d 8c 8d 55 a0 89 45 9c 8b 45 
[42051.799957] EIP: [<c122dc63>] scsi_send_eh_cmnd+0x33/0x320 SS:ESP 0068:f5f8be2c
[42051.800011] CR2: 0000000000000000
[42051.800320] ---[ end trace c351067a2986e126 ]---

-- 
Meelis Roos (mroos@linux.ee)
