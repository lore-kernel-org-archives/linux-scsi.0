From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14214] BUG at drivers/scsi/scsi_lib.c:1108!
Date: Thu, 1 Oct 2009 08:42:56 GMT
Message-ID: <200910010842.n918guLL005496@demeter.kernel.org>
References: <bug-14214-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43940 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZJAImw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 04:42:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n918guSD005497
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 08:42:56 GMT
In-Reply-To: <bug-14214-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14214





--- Comment #4 from Plamen Petrov <pvp-lsts@fs.ru.acad.bg>  2009-10-01 08:42:49 ---
Well, for the time period between 2.6.31-git12 and 2.6.32-rc1 I disabled
SMP support in the kernel and was able to successfully reboot both the real and
the virtual machine.

Now, after the release of 2.6.32-rc1 I installed CRUX 2.6 to be able to use
gcc 4.4, and again enabled SMP support - for now the problem is gone.

Here is some info from the virtual machine:

root@repo2:~# w
 11:41:01 up 1 day, 23 min,  1 user,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    192.168.10.174   11:40    0.00s  0.08s  0.03s w
root@repo2:~# dmesg
[    0.000000] Linux version 2.6.32-rc2-VM (root@host) (gcc version 4.4.1
(CRUX) (GCC) ) #1 SMP Wed Sep 30 10:07:27 UTC 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000336f0000 (usable)
[    0.000000]  BIOS-e820: 00000000336f0000 - 0000000033700000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.5 present.
[    0.000000] last_pfn = 0x336f0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR variable ranges disabled:
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] initial memory mapped : 0 - 02000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000336f0000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0033400000 page 2M
[    0.000000]  0033400000 - 00336f0000 page 4k
[    0.000000] kernel direct mapping tables up to 336f0000 @ 7000-c000
[    0.000000] ACPI: RSDP 000e0000 00024 (v02 VBOX  )
[    0.000000] ACPI: XSDT 336f0030 00034 (v01 VBOX   VBOXXSDT 00000001 ASL 
00000061)
[    0.000000] ACPI: FACP 336f00f0 000F4 (v04 VBOX   VBOXFACP 00000001 ASL 
00000061)
[    0.000000] ACPI: DSDT 336f0270 01A0C (v01 VBOX   VBOXBIOS 00000002 INTL
20050309)
[    0.000000] ACPI: FACS 336f01f0 00040
[    0.000000] ACPI: APIC 336f0230 00040 (v02 VBOX   VBOXAPIC 00000001 ASL 
00000061)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 822MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 336f0000
[    0.000000]   low ram: 0 - 336f0000
[    0.000000]   node 0 low ram: 00000000 - 336f0000
[    0.000000]   node 0 bootmap 00008000 - 0000e6e0
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00336f0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000
- 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000
- 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000
- 0000007000]
[    0.000000]   #3 [0001000000 - 0001bb2d04]    TEXT DATA BSS ==> [0001000000
- 0001bb2d04]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00
- 0000100000]
[    0.000000]   #5 [0001bb3000 - 0001bbb071]              BRK ==> [0001bb3000
- 0001bbb071]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000
- 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000
- 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000336f0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000336f0
[    0.000000] On node 0 totalpages: 210575
[    0.000000] free_area_init_node: node 0, pgdat c15fa980, node_mem_map
c1bbc000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 2623 pages used for memmap
[    0.000000]   Normal zone: 203953 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 33700000 (gap:
33700000:cc8c0000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @c2800000 s36248 r0 d12904
u4194304
[    0.000000] pcpu-alloc: s36248 r0 d12904 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
pages: 207900
[    0.000000] Kernel command line: panic_timeout=120 ro root=/dev/md2 vga=6
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 818412k/842688k available (4597k kernel code, 23624k
reserved, 1561k data, 476k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff6a000 - 0xfffff000   ( 596 kB)
[    0.000000]     vmalloc : 0xf3ef0000 - 0xfff68000   ( 192 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf36f0000   ( 822 MB)
[    0.000000]       .init : 0xc1604000 - 0xc167b000   ( 476 kB)
[    0.000000]       .data : 0xc147d5dc - 0xc1603d98   (1561 kB)
[    0.000000]       .text : 0xc1000000 - 0xc147d5dc   (4597 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor
mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] CPU 0 irqstacks, hard=c2800000 soft=c2801000
[    0.000000] Console: colour VGA+ 80x60
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,
Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000]
----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex |
wsem | rsem |
[    0.000000]  
--------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  | 
ok  |  ok  |
[    0.000000]  
--------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |         
   |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |         
   |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |         
   |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |         
   |  ok  |
[    0.000000]  
--------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using PMTIMER reference calibration
[    0.000000] Detected 2593.527 MHz processor.
[    0.050027] Calibrating delay loop (skipped), value calculated using timer
frequency.. 5187.05 BogoMIPS (lpj=25935270)
[    0.060108] Security Framework initialized
[    0.061025] Mount-cache hash table entries: 512
[    0.070418] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
[    0.071548] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.072393] mce: CPU supports 0 MCE banks
[    0.073271] using C1E aware idle routine
[    0.074136] Performance Events: AMD PMU driver.
[    0.075094] ... version:                0
[    0.075788] ... bit width:              48
[    0.080015] ... generic registers:      4
[    0.080803] ... value mask:             0000ffffffffffff
[    0.081668] ... max period:             00007fffffffffff
[    0.082578] ... fixed-purpose events:   0
[    0.083377] ... event mask:             000000000000000f
[    0.084260] Checking 'hlt' instruction... OK.
[    0.125744] SMP alternatives: switching to UP code
[    0.379921] Freeing SMP alternatives: 17k freed
[    0.381369] ACPI: Core revision 20090903
[    0.390672] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.508495] CPU0: AMD Athlon(tm) Processor LE-1640 stepping 03
[    0.510000] APIC calibration not consistent with PM-Timer: 101ms instead of
100ms
[    0.510000] APIC delta adjusted to PM-Timer: 6247520 (6315222)
[    0.510000] Brought up 1 CPUs
[    0.510000] Total of 1 processors activated (5187.05 BogoMIPS).
[    0.510000] xor: automatically using best checksumming function: pIII_sse
[    0.551179]    pIII_sse  :   410.800 MB/sec
[    0.552499] xor: using function: pIII_sse (410.800 MB/sec)
[    0.554004] NET: Registered protocol family 16
[    0.555567] EISA bus registered
[    0.556417] ACPI: bus type pci registered
[    0.557444] PCI: PCI BIOS revision 2.10 entry at 0xfc080, last bus=0
[    0.558391] PCI: Using configuration type 1 for base access
[    0.568573] bio: create slab <bio-0> at 0
[    0.570327] ACPI: EC: Look up EC in DSDT
[    0.584362] ACPI: Interpreter enabled
[    0.585174] ACPI: (supports S0 S5)
[    0.586171] ACPI: Using IOAPIC for interrupt routing
[    0.587451] ACPI: Enumerating devices from [\]
[    0.592578] ACPI: No dock devices found.
[    0.593480] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.595770] pci 0000:00:01.1: reg 20 io port: [0xd000-0xd00f]
[    0.596438] pci 0000:00:02.0: reg 10 32bit mmio pref:
[0xe0000000-0xe07fffff]
[    0.597097] pci 0000:00:03.0: reg 10 32bit mmio: [0xf0000000-0xf001ffff]
[    0.597201] pci 0000:00:03.0: reg 18 io port: [0xd010-0xd017]
[    0.597774] pci 0000:00:04.0: reg 10 io port: [0xd020-0xd03f]
[    0.597863] pci 0000:00:04.0: reg 14 32bit mmio: [0xf0400000-0xf07fffff]
[    0.597920] pci 0000:00:04.0: reg 18 32bit mmio pref:
[0xf0800000-0xf0803fff]
[    0.598916] pci_bus 0000:00: on NUMA node 0
[    0.598927] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.602175] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 9 10 11) *0, disabled.
[    0.610440] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 9 10 11) *0, disabled.
[    0.612597] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 9 10 *11)
[    0.614370] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 9 *10 11)
[    0.620562] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.621865] vgaarb: loaded
[    0.622856] SCSI subsystem initialized
[    0.623756] libata version 3.00 loaded.
[    0.790056] raid6: int32x1   1120 MB/s
[    0.960046] raid6: int32x2   1036 MB/s
[    1.140068] raid6: int32x4    682 MB/s
[    1.310099] raid6: int32x8    460 MB/s
[    1.480284] raid6: mmxx1     1453 MB/s
[    1.650037] raid6: mmxx2     2071 MB/s
[    1.820063] raid6: sse1x1    1219 MB/s
[    1.990057] raid6: sse1x2    1533 MB/s
[    2.160049] raid6: sse2x1    1644 MB/s
[    2.330057] raid6: sse2x2    1529 MB/s
[    2.330871] raid6: using algorithm sse2x1 (1644 MB/s)
[    2.331767] PCI: Using ACPI for IRQ routing
[    2.333238] Switching to clocksource tsc
[    2.334163] pnp: PnP ACPI init
[    2.334938] ACPI: bus type pnp registered
[    2.337208] pnp: PnP ACPI: found 6 devices
[    2.338011] ACPI: ACPI bus type pnp unregistered
[    2.379564] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    2.379571] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    2.379651] NET: Registered protocol family 2
[    2.380765] IP route cache hash table entries: 32768 (order: 5, 131072
bytes)
[    2.381835] TCP established hash table entries: 131072 (order: 8, 1048576
bytes)
[    2.385714] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    2.402001] TCP: Hash tables configured (established 131072 bind 65536)
[    2.403412] TCP reno registered
[    2.404662] NET: Registered protocol family 1
[    2.408262] platform rtc_cmos: registered platform RTC device (no PNP device
found)
[    2.411919] Slow work thread pool: Starting up
[    2.412915] Slow work thread pool: Ready
[    2.413736] fuse init (API version 7.13)
[    2.414620] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[    2.416820] SGI XFS Quota Management subsystem
[    2.417877] Btrfs loaded
[    2.418590] msgmni has been set to 1599
[    2.422029] alg: No test for stdrng (krng)
[    2.422995] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
253)
[    2.424478] io scheduler noop registered (default)
[    2.425346] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.435864] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.436630] pci 0000:00:02.0: Boot video device
[    2.437401] ACPI: AC Adapter [AC] (on-line)
[    2.438583] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.440129] ACPI: Power Button [PWRF]
[    2.441104] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    2.442594] ACPI: Sleep Button [SLPF]
[    2.443776] processor LNXCPU:00: registered as cooling_device0
[    2.475134] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds,
margin is 60 seconds).
[    2.475839] Hangcheck: Using get_cycles().
[    2.480107] brd: module loaded
[    2.483756] loop: module loaded
[    2.484980] nbd: registered device at major 43
[    2.501285] ata_piix 0000:00:01.1: version 2.13
[    2.501670] scsi0 : ata_piix
[    2.502779] scsi1 : ata_piix
[    2.503712] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xd000 irq 14
[    2.504755] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xd008 irq 15
[    2.507833] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    2.508336] Copyright (c) 1999-2006 Intel Corporation.
[    2.509269] e1000 0000:00:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.923005] e1000: 0000:00:03.0: e1000_probe: (PCI:33MHz:32-bit)
08:00:27:ab:cd:e9
[    2.925524] ata2.00: ATAPI: VBOX CD-ROM, 1.0, max UDMA/133
[    2.936559] ata1.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[    2.937575] ata1.00: 37748736 sectors, multi 128: LBA
[    2.939167] ata1.00: configured for UDMA/33
[    2.940420] scsi 0:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0 
PQ: 0 ANSI: 5
[    2.942900] sd 0:0:0:0: [sda] 37748736 512-byte logical blocks: (19.3
GB/18.0 GiB)
[    2.944755] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.945815] ata2.00: configured for UDMA/33
[    2.946980] sd 0:0:0:0: [sda] Write Protect is off
[    2.947820] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.948284] scsi 1:0:0:0: CD-ROM            VBOX     CD-ROM           1.0 
PQ: 0 ANSI: 5
[    2.949880] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    2.952043]  sda: sda1 sda2 sda3
[    2.968133] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.968993] sr0: scsi3-mmc drive: 32x/32x xa/form2 tray
[    2.971273] Uniform CD-ROM driver Revision: 3.20
[    2.972456] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.972730] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.015812] Switched to high resolution mode on CPU 0
[    3.140987] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[    3.142103] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    3.142995] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    3.144059] pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    3.145070] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    3.145969] e100: Copyright(c) 1999-2006 Intel Corporation
[    3.148586] tun: Universal TUN/TAP device driver, 1.6
[    3.149506] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.150351] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64
irq 1,12
[    3.152759] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.153700] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.155164] mice: PS/2 mouse device common for all mice
[    3.156731] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
[    3.158625] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    3.170561] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    3.171677] rtc0: alarms up to one day, 114 bytes nvram
[    3.172717] input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input3
[    3.176908] Software Watchdog Timer: 0.07 initialized. soft_noboot=0
soft_margin=60 sec (nowayout= 0)
[    3.178522] md: linear personality registered for level -1
[    3.179279] md: raid0 personality registered for level 0
[    3.179776] md: raid1 personality registered for level 1
[    3.179978] md: raid10 personality registered for level 10
[    3.181781] md: raid6 personality registered for level 6
[    3.182772] md: raid5 personality registered for level 5
[    3.183674] md: raid4 personality registered for level 4
[    3.184932] EISA: Probing bus 0 at eisa.0
[    3.185862] cpuidle: using governor ladder
[    3.186645] cpuidle: using governor menu
[    3.187430] Netfilter messages via NETLINK v0.30.
[    3.188295] nf_conntrack version 0.5.0 (12792 buckets, 51168 max)
[    3.189322] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please
use
[    3.189980] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module
option or
[    3.201326] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    3.202660] ctnetlink v0.93: registering with nfnetlink.
[    3.203713] xt_time: kernel timezone is -0000
[    3.205189] IPv4 over IPv4 tunneling driver
[    3.209077] GRE over IPv4 tunneling driver
[    3.210963] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.211552] arp_tables: (C) 2002 David S. Miller
[    3.212435] TCP cubic registered
[    3.213184] Initializing XFRM netlink socket
[    3.214082] NET: Registered protocol family 10
[    3.216148] lo: Disabled Privacy Extensions
[    3.218258] tunl0: Disabled Privacy Extensions
[    3.229953] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.244776] IPv6 over IPv4 tunneling driver
[    3.246768] sit0: Disabled Privacy Extensions
[    3.249196] ip6tnl0: Disabled Privacy Extensions
[    3.260433] NET: Registered protocol family 17
[    3.261461] NET: Registered protocol family 15
[    3.262313] Using IPI Shortcut mode
[    3.263905] rtc_cmos rtc_cmos: setting system clock to 2009-09-30 11:17:51
UTC (1254309471)
[    3.265507] md: Waiting for all devices to be available before autodetect
[    3.266546] md: If you don't use raid, use raid=noautodetect
[    3.267978] md: Autodetecting RAID arrays.
[    3.269631] md: Scanned 3 and added 3 devices.
[    3.270201] md: autorun ...
[    3.270937] md: considering sda3 ...
[    3.271718] md:  adding sda3 ...
[    3.272488] md: sda2 has different UUID to sda3
[    3.273592] md: sda1 has different UUID to sda3
[    3.274717] md: created md3
[    3.275467] md: bind<sda3>
[    3.276256] md: running: <sda3>
[    3.277467] raid1: raid set md3 active with 1 out of 2 mirrors
[    3.278450] md3: detected capacity change from 0 to 13719699456
[    3.279558] md: considering sda2 ...
[    3.287591] md:  adding sda2 ...
[    3.288414] md: sda1 has different UUID to sda2
[    3.289736] md: created md2
[    3.289998] md: bind<sda2>
[    3.290839] md: running: <sda2>
[    3.291898] raid1: raid set md2 active with 1 out of 2 mirrors
[    3.292836] md2: detected capacity change from 0 to 5387452416
[    3.293833] md: considering sda1 ...
[    3.294612] md:  adding sda1 ...
[    3.295612] md: created md1
[    3.296340] md: bind<sda1>
[    3.297123] md: running: <sda1>
[    3.298162] raid1: raid set md1 active with 1 out of 2 mirrors
[    3.299095] md1: detected capacity change from 0 to 213712896
[    3.303158] md: ... autorun DONE.
[    3.304130]  md2: unknown partition table
[    3.338739] UDF-fs: No partition found (1)
[    3.351078] XFS mounting filesystem md2
[    3.445809] Ending clean XFS mount for filesystem: md2
[    3.445967] VFS: Mounted root (xfs filesystem) readonly on device 9:2.
[    3.447109] Freeing unused kernel memory: 476k freed
[    3.449392] Write protecting the kernel text: 4600k
[    3.449981] Write protecting the kernel read-only data: 1252k
[    7.911392]  md1: unknown partition table
[    7.943337] XFS mounting filesystem md1
[    8.209035] Ending clean XFS mount for filesystem: md1
[    8.214318]  md3: unknown partition table
[    8.217045] XFS mounting filesystem md3
[    8.311276] Ending clean XFS mount for filesystem: md3
[   10.565638] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.606884] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control:
RX
[   10.616044] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.024539] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.075617] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control:
RX
[   12.084575] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.200190] eth0: no IPv6 routers present
[26985.660709]
[26985.660722] =================================
[26985.664505] [ INFO: inconsistent lock state ]
[26985.666432] 2.6.32-rc2-VM #1
[26985.668128] ---------------------------------
[26985.669984] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[26985.670099] kswapd0/239 [HC0[0]:SC0[0]:HE1:SE1] takes:
[26985.670099]  (&(&ip->i_iolock)->mr_lock){++++?+}, at: [<c11808fc>]
xfs_ilock+0x5c/0xa0
[26985.670099] {RECLAIM_FS-ON-W} state was registered at:
[26985.670099]   [<c1052a13>] mark_held_locks+0x63/0x90
[26985.670099]   [<c1052ab3>] lockdep_trace_alloc+0x73/0xa0
[26985.670099]   [<c106c8d6>] __alloc_pages_nodemask+0x56/0x530
[26985.670099]   [<c1066dd9>] __page_cache_alloc+0x19/0x20
[26985.670099]   [<c106851a>] grab_cache_page_write_begin+0x5a/0xa0
[26985.670099]   [<c10b267c>] block_write_begin+0x7c/0xe0
[26985.670099]   [<c11a1bc3>] xfs_vm_write_begin+0x43/0x50
[26985.670099]   [<c1067d47>] generic_file_buffered_write+0xe7/0x270
[26985.670099]   [<c11a94aa>] xfs_write+0x77a/0x870
[26985.670099]   [<c11a5556>] xfs_file_aio_write+0x66/0x80
[26985.670099]   [<c108e8ec>] do_sync_write+0xbc/0x100
[26985.670099]   [<c108ebaa>] vfs_write+0x9a/0x170
[26985.670099]   [<c108f3dd>] sys_write+0x3d/0x70
[26985.670099]   [<c1002f25>] syscall_call+0x7/0xb
[26985.670099] irq event stamp: 71935
[26985.670099] hardirqs last  enabled at (71935): [<c147c1e5>]
_spin_unlock_irqrestore+0x35/0x60
[26985.670099] hardirqs last disabled at (71934): [<c147c406>]
_spin_lock_irqsave+0x16/0x60
[26985.670099] softirqs last  enabled at (71732): [<c1032f32>]
__do_softirq+0xe2/0x130
[26985.670099] softirqs last disabled at (71719): [<c1005b67>]
do_softirq+0x87/0xd0
[26985.670099]
[26985.670099] other info that might help us debug this:
[26985.670099] 2 locks held by kswapd0/239:
[26985.670099]  #0:  (shrinker_rwsem){++++..}, at: [<c10714e0>]
shrink_slab+0x20/0x170
[26985.670099]  #1:  (iprune_sem){.+.+.-}, at: [<c10a1dc4>]
shrink_icache_memory+0x64/0x280
[26985.670099]
[26985.670099] stack backtrace:
[26985.670099] Pid: 239, comm: kswapd0 Not tainted 2.6.32-rc2-VM #1
[26985.670099] Call Trace:
[26985.670099]  [<c1479b70>] ? printk+0x18/0x20
[26985.670099]  [<c1051d10>] print_usage_bug+0x150/0x160
[26985.670099]  [<c1052918>] mark_lock+0x2f8/0x390
[26985.670099]  [<c10520a0>] ? check_usage_forwards+0x0/0xe0
[26985.670099]  [<c10530db>] __lock_acquire+0x1ab/0x1200
[26985.670099]  [<c105385c>] ? __lock_acquire+0x92c/0x1200
[26985.670099]  [<c1180aa9>] ? xfs_ireclaim+0x59/0xd0
[26985.670099]  [<c1054194>] lock_acquire+0x64/0x80
[26985.670099]  [<c11808fc>] ? xfs_ilock+0x5c/0xa0
[26985.670099]  [<c1045b91>] down_write_nested+0x31/0x50
[26985.670099]  [<c11808fc>] ? xfs_ilock+0x5c/0xa0
[26985.670099]  [<c11808fc>] xfs_ilock+0x5c/0xa0
[26985.670099]  [<c1180aee>] xfs_ireclaim+0x9e/0xd0
[26985.670099]  [<c11abf06>] xfs_reclaim_inode+0xa6/0x140
[26985.670099]  [<c119bbc4>] xfs_reclaim+0x84/0x90
[26985.670099]  [<c11aa4ce>] xfs_fs_destroy_inode+0x2e/0x50
[26985.670099]  [<c10ba6f8>] ? __fsnotify_inode_delete+0x8/0x10
[26985.670099]  [<c10a15bd>] ? __destroy_inode+0x1d/0x80
[26985.670099]  [<c10a163f>] destroy_inode+0x1f/0x40
[26985.670099]  [<c10a1cf7>] dispose_list+0x77/0xe0
[26985.670099]  [<c10a1f06>] shrink_icache_memory+0x1a6/0x280
[26985.670099]  [<c10715c7>] shrink_slab+0x107/0x170
[26985.670099]  [<c1073378>] kswapd+0x498/0x5e0
[26985.670099]  [<c1070d80>] ? isolate_pages_global+0x0/0x1c0
[26985.670099]  [<c10419e0>] ? autoremove_wake_function+0x0/0x40
[26985.670099]  [<c1072ee0>] ? kswapd+0x0/0x5e0
[26985.670099]  [<c104175c>] kthread+0x6c/0x80
[26985.670099]  [<c10416f0>] ? kthread+0x0/0x80
[26985.670099]  [<c1003ba7>] kernel_thread_helper+0x7/0x30
root@repo2:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid1 sda1[0]
      208704 blocks [2/1] [U_]

md2 : active raid1 sda2[0]
      5261184 blocks [2/1] [U_]

md3 : active raid1 sda3[0]
      13398144 blocks [2/1] [U_]

unused devices: <none>
root@repo2:~#

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
