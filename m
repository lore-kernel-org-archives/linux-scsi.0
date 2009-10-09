From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: MVSAS 1669:mvs_abort_task:rc= 5
Date: Fri, 9 Oct 2009 11:41:52 -0600
Message-ID: <200910091141.52303.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gX3zKjTcxl9dw6G"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:14792 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZJIRmf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2009 13:42:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

--Boundary-00=_gX3zKjTcxl9dw6G
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I've been trying to get an AOC-SASLP-MV8 card (pcie x4 2 port SAS card) to 
work with linux for the past month or so. I've recently just RMAed my first 
card, and tested the new one under linux, and I see the same problems.

The very first time I made a new array off the controller, formated (with xfs) 
and mounted the volume, it seemed to work. ioozone even seemed to run for a 
while. Sadly after a few minutes I got a stream of mvs_abort_task messages in 
dmesg, and any accesses to the volume, or any disks connected to the 
controller lock up.

After that I updated my 2.6.31 kernel to 2.6.32-rc3-git2 off of kernel.org, 
and the volume fails to mount with the same mvs_abort_task messages.

I've attached my dmesg log from both attempts. dmesg1 is the first attempt, 
dmesg2 is the second attempt on the newer kernel.

I would really appreciate some help with this.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca

--Boundary-00=_gX3zKjTcxl9dw6G
Content-Type: text/plain;
  charset="UTF-8";
  name="test-data.dmesg1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="test-data.dmesg1"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-git4 (root@natasha) (gcc version 4.3.4 (Debian 4.3.4-2) ) #6 SMP PREEMPT Tue Sep 15 09:16:41 MDT 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.31-git4 root=UUID=272a1709-267d-4134-a6b4-e8d3884dca37 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfde0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfde0000 - 00000000cfde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfde3000 - 00000000cfdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfdf0000 - 00000000cfe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 0000CFE00000 mask FFFFFFE00000 uncachable
[    0.000000]   4 base 000100000000 mask FFFFE0000000 write-back
[    0.000000]   5 base 000120000000 mask FFFFF0000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cfe00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfde0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfde0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfc00000 page 2M
[    0.000000]  00cfc00000 - 00cfde0000 page 4k
[    0.000000] kernel direct mapping tables up to cfde0000 @ 8000-b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ a000-c000
[    0.000000] RAMDISK: 376ee000 - 37fef4bf
[    0.000000] ACPI: RSDP 00000000000f7550 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfde3000 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cfde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cfde30c0 0731E (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000cfde0000 00040
[    0.000000] ACPI: SSDT 00000000cfdea4c0 0088C (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 00000000cfdead80 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cfdeadc0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: TAMG 00000000cfdeae00 0030A (v01 GBT    GBT   B0 5455312E BG 53450101)
[    0.000000] ACPI: APIC 00000000cfdea400 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [000000000000b000 - 0000000000012fff]
[    0.000000]   bootmap [0000000000013000 -  0000000000038fff] pages 26
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001641f14]    TEXT DATA BSS ==> [0001000000 - 0001641f14]
[    0.000000]   #3 [00376ee000 - 0037fef4bf]          RAMDISK ==> [00376ee000 - 0037fef4bf]
[    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 - 0000100000]
[    0.000000]   #5 [0001642000 - 0001642106]              BRK ==> [0001642000 - 0001642106]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f5b40] f5b40
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000cfde0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1047933
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 105 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833048 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfde0000 - 00000000cfde3000
[    0.000000] PM: Registered nosave memory: 00000000cfde3000 - 00000000cfdf0000
[    0.000000] PM: Registered nosave memory: 00000000cfdf0000 - 00000000cfe00000
[    0.000000] PM: Registered nosave memory: 00000000cfe00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cfe00000 (gap: cfe00000:10200000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages at ffff880028022000, static data 90528 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030804
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.31-git4 root=UUID=272a1709-267d-4134-a6b4-e8d3884dca37 ro
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 8d2c000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 4050428k/4980736k available (3034k kernel code, 789004k absent, 141304k reserved, 1662k data, 592k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2611.759 MHz processor.
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000]   alloc irq_desc for 24 on node 0
[    0.000000]   alloc kstat_irqs on node 0
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.001999] Calibrating delay loop (skipped), value calculated using timer frequency.. 5223.51 BogoMIPS (lpj=2611755)
[    0.001999] Security Framework initialized
[    0.001999] SELinux:  Disabled at boot.
[    0.001999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002836] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003436] Mount-cache hash table entries: 256
[    0.003599] Initializing cgroup subsys ns
[    0.003654] Initializing cgroup subsys cpuacct
[    0.003710] Initializing cgroup subsys devices
[    0.003765] Initializing cgroup subsys freezer
[    0.003820] Initializing cgroup subsys net_cls
[    0.003893] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003951] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004002] CPU 0/0x0 -> Node 0
[    0.004057] tseg: 00cfe00000
[    0.004059] CPU: Physical Processor ID: 0
[    0.004112] CPU: Processor Core ID: 0
[    0.004167] mce: CPU supports 6 MCE banks
[    0.004227] using C1E aware idle routine
[    0.004281] Performance Counters: AMD PMU driver.
[    0.004378] ... version:                 0
[    0.004432] ... bit width:               48
[    0.004486] ... generic counters:        4
[    0.004540] ... value mask:              0000ffffffffffff
[    0.004595] ... max period:              00007fffffffffff
[    0.004651] ... fixed-purpose counters:  0
[    0.004704] ... counter mask:            000000000000000f
[    0.005314] ACPI: Core revision 20090521
[    0.014065] Setting APIC routing to flat
[    0.015412] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025475] CPU0: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.025996] System has AMD C1E enabled
[    0.025996] Switch to broadcast mode on CPU0
[    0.026132] Booting processor 1 APIC 0x1 ip 0x6000
[    0.001999] Initializing CPU#1
[    0.001999] Calibrating delay using timer specific routine.. 5223.74 BogoMIPS (lpj=2611872)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 1/0x1 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 1
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.097746] CPU1: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.098084] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.099004] Switch to broadcast mode on CPU1
[    0.099058] Booting processor 2 APIC 0x2 ip 0x6000
[    0.001999] Initializing CPU#2
[    0.001999] Calibrating delay using timer specific routine.. 5223.78 BogoMIPS (lpj=2611894)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 2/0x2 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 2
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.170713] CPU2: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.171077] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.171994] Switch to broadcast mode on CPU2
[    0.172052] Booting processor 3 APIC 0x3 ip 0x6000
[    0.001999] Initializing CPU#3
[    0.001999] Calibrating delay using timer specific routine.. 5223.78 BogoMIPS (lpj=2611890)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU 3/0x3 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 3
[    0.001999] mce: CPU supports 6 MCE banks
[    0.001999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.243690] CPU3: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.244066] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.244984] Brought up 4 CPUs
[    0.244983] Switch to broadcast mode on CPU3
[    0.245091] Total of 4 processors activated (20894.82 BogoMIPS).
[    0.245253] CPU0 attaching sched-domain:
[    0.245256]  domain 0: span 0-3 level MC
[    0.245258]   groups: 0 1 2 3
[    0.245262]   domain 1: span 0-3 level NODE
[    0.245264]    groups: 0-3 (cpu_power = 4096)
[    0.245268] CPU1 attaching sched-domain:
[    0.245270]  domain 0: span 0-3 level MC
[    0.245271]   groups: 1 2 3 0
[    0.245275]   domain 1: span 0-3 level NODE
[    0.245277]    groups: 0-3 (cpu_power = 4096)
[    0.245281] CPU2 attaching sched-domain:
[    0.245282]  domain 0: span 0-3 level MC
[    0.245284]   groups: 2 3 0 1
[    0.245287]   domain 1: span 0-3 level NODE
[    0.245289]    groups: 0-3 (cpu_power = 4096)
[    0.245293] CPU3 attaching sched-domain:
[    0.245294]  domain 0: span 0-3 level MC
[    0.245296]   groups: 3 0 1 2
[    0.245299]   domain 1: span 0-3 level NODE
[    0.245301]    groups: 0-3 (cpu_power = 4096)
[    0.246073] Booting paravirtualized kernel on bare hardware
[    0.246159] regulator: core version 0.5
[    0.246159] NET: Registered protocol family 16
[    0.246159] node 0 link 0: io port [a000, ffff]
[    0.246159] TOM: 00000000d0000000 aka 3328M
[    0.246964] Fam 10h mmconf [e0000000, e00fffff]
[    0.246966] node 0 link 0: mmio [a0000, bffff]
[    0.246968] node 0 link 0: mmio [d0000000, dfffffff]
[    0.246971] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.246973] node 0 link 0: mmio [e0000000, e05fffff] ==> [e0100000, e05fffff]
[    0.246976] TOM2: 0000000130000000 aka 4864M
[    0.247031] bus: [00,05] on node 0 link 0
[    0.247033] bus: 00 index 0 io port: [0, ffff]
[    0.247035] bus: 00 index 1 mmio: [a0000, bffff]
[    0.247036] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.247038] bus: 00 index 3 mmio: [e0600000, ffffffff]
[    0.247040] bus: 00 index 4 mmio: [e0100000, e05fffff]
[    0.247041] bus: 00 index 5 mmio: [130000000, fcffffffff]
[    0.247050] ACPI: bus type pci registered
[    0.247113] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.247113] PCI: MCFG area at e0000000 reserved in E820
[    0.258554] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.258610] PCI: Using configuration type 1 for base access
[    0.260076] bio: create slab <bio-0> at 0
[    0.261087] ACPI: EC: Look up EC in DSDT
[    0.267635] ACPI: Interpreter enabled
[    0.267693] ACPI: (supports S0 S3 S4 S5)
[    0.267929] ACPI: Using IOAPIC for interrupt routing
[    0.273193] ACPI: No dock devices found.
[    0.274051] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.274177] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.274177] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.274177] pci 0000:00:02.0: PME# disabled
[    0.274177] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.274221] pci 0000:00:07.0: PME# disabled
[    0.274302] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.274358] pci 0000:00:09.0: PME# disabled
[    0.274438] pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
[    0.274495] pci 0000:00:0b.0: PME# disabled
[    0.274592] pci 0000:00:11.0: reg 10 io port: [0xff00-0xff07]
[    0.274599] pci 0000:00:11.0: reg 14 io port: [0xfe00-0xfe03]
[    0.274605] pci 0000:00:11.0: reg 18 io port: [0xfd00-0xfd07]
[    0.274611] pci 0000:00:11.0: reg 1c io port: [0xfc00-0xfc03]
[    0.274617] pci 0000:00:11.0: reg 20 io port: [0xfb00-0xfb0f]
[    0.274624] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
[    0.274673] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
[    0.274724] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.274743] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe02c000-0xfe02c0ff]
[    0.274743] pci 0000:00:12.2: supports D1 D2
[    0.274743] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.274743] pci 0000:00:12.2: PME# disabled
[    0.274743] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.274743] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.274743] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.274743] pci 0000:00:13.2: supports D1 D2
[    0.274743] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.274743] pci 0000:00:13.2: PME# disabled
[    0.274743] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.274743] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.274743] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.274743] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.274743] pci 0000:00:14.1: reg 20 io port: [0xfa00-0xfa0f]
[    0.274743] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
[    0.274743] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.274770] pci 0000:00:14.2: PME# disabled
[    0.274919] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe028000-0xfe028fff]
[    0.275055] pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.275063] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.275071] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.275076] pci 0000:01:00.0: reg 24 io port: [0xcf00-0xcf7f]
[    0.275081] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275145] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.275148] pci 0000:00:02.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    0.275151] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.275183] pci 0000:02:00.0: reg 10 io port: [0xbe00-0xbeff]
[    0.275197] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdbff000-0xfdbfffff]
[    0.275207] pci 0000:02:00.0: reg 20 64bit mmio: [0xfdbf8000-0xfdbfbfff]
[    0.275213] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275239] pci 0000:02:00.0: supports D1 D2
[    0.275241] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275300] pci 0000:02:00.0: PME# disabled
[    0.275408] pci 0000:00:07.0: bridge io port: [0xb000-0xbfff]
[    0.275410] pci 0000:00:07.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
[    0.275414] pci 0000:00:07.0: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
[    0.275446] pci 0000:03:00.0: reg 10 io port: [0xee00-0xeeff]
[    0.275459] pci 0000:03:00.0: reg 18 64bit mmio: [0xfdfff000-0xfdffffff]
[    0.275469] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdff8000-0xfdffbfff]
[    0.275475] pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.275502] pci 0000:03:00.0: supports D1 D2
[    0.275504] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275562] pci 0000:03:00.0: PME# disabled
[    0.275670] pci 0000:00:09.0: bridge io port: [0xe000-0xefff]
[    0.275672] pci 0000:00:09.0: bridge 32bit mmio: [0xfd800000-0xfd8fffff]
[    0.275676] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.275711] pci 0000:04:00.0: reg 18 io port: [0xdf00-0xdf7f]
[    0.275723] pci 0000:04:00.0: reg 20 64bit mmio: [0xfdef0000-0xfdefffff]
[    0.275728] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x03ffff]
[    0.275749] pci 0000:04:00.0: supports D1
[    0.275751] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.275808] pci 0000:04:00.0: PME# disabled
[    0.275908] pci 0000:00:0b.0: bridge io port: [0xd000-0xdfff]
[    0.275911] pci 0000:00:0b.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.275914] pci 0000:00:0b.0: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
[    0.275987] pci 0000:05:0e.0: reg 10 32bit mmio: [0xfdaff000-0xfdaff7ff]
[    0.275995] pci 0000:05:0e.0: reg 14 32bit mmio: [0xfdaf8000-0xfdafbfff]
[    0.276050] pci 0000:05:0e.0: supports D1 D2
[    0.276052] pci 0000:05:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.276111] pci 0000:05:0e.0: PME# disabled
[    0.276197] pci 0000:00:14.4: transparent bridge
[    0.276254] pci 0000:00:14.4: bridge io port: [0xa000-0xafff]
[    0.276258] pci 0000:00:14.4: bridge 32bit mmio: [0xfda00000-0xfdafffff]
[    0.276262] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfd900000-0xfd9fffff]
[    0.276278] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.276525] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.276598] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.276651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.276696] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.276741] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEB._PRT]
[    0.298023] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.298618] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.298749] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.299033] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.299625] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.301212] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.301804] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.302377] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.303061] usbcore: registered new interface driver usbfs
[    0.303061] usbcore: registered new interface driver hub
[    0.303067] usbcore: registered new device driver usb
[    0.303067] PCI: Using ACPI for IRQ routing
[    0.303067] pci 0000:00:00.0: BAR 3: address space collision on of device [0xe0000000-0xffffffff]
[    0.303084] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.303232] PCI-DMA: Disabling AGP.
[    0.303969] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.304012] PCI-DMA: using GART IOMMU.
[    0.304067] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.305739] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.306005] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.308986] hpet: hpet2 irq 24 for MSI
[    0.312720] pnp: PnP ACPI init
[    0.312786] ACPI: bus type pnp registered
[    0.316541] pnp 00:0d: mem resource (0xd6c00-0xd7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.316611] pnp 00:0d: mem resource (0xf0000-0xf7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.316680] pnp 00:0d: mem resource (0xf8000-0xfbfff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.316749] pnp 00:0d: mem resource (0xfc000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.316823] pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.316892] pnp 00:0d: mem resource (0x100000-0xcfddffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.317064] pnp: PnP ACPI: found 14 devices
[    0.317119] ACPI: ACPI bus type pnp unregistered
[    0.317181] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.317238] system 00:01: ioport range 0x220-0x225 has been reserved
[    0.317295] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.317355] system 00:02: ioport range 0x4100-0x411f has been reserved
[    0.317412] system 00:02: ioport range 0x228-0x22f has been reserved
[    0.317469] system 00:02: ioport range 0x40b-0x40b has been reserved
[    0.317526] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[    0.317583] system 00:02: ioport range 0xc00-0xc01 has been reserved
[    0.317640] system 00:02: ioport range 0xc14-0xc14 has been reserved
[    0.317697] system 00:02: ioport range 0xc50-0xc52 has been reserved
[    0.317755] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[    0.317812] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[    0.317874] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[    0.317932] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[    0.317989] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[    0.318046] system 00:02: ioport range 0x4000-0x40fe has been reserved
[    0.318103] system 00:02: ioport range 0x4210-0x4217 has been reserved
[    0.318160] system 00:02: ioport range 0xb00-0xb0f has been reserved
[    0.318217] system 00:02: ioport range 0xb10-0xb1f has been reserved
[    0.318274] system 00:02: ioport range 0xb20-0xb3f has been reserved
[    0.318336] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.318396] system 00:0d: iomem range 0xcfde0000-0xcfdfffff could not be reserved
[    0.318463] system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
[    0.318521] system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.318588] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.318646] system 00:0d: iomem range 0xfff80000-0xfffeffff has been reserved
[    0.323709] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.323766] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.323827] pci 0000:00:02.0:   MEM window: 0xf8000000-0xfbffffff
[    0.323884] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.323952] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.324012] pci 0000:00:07.0:   IO window: 0xb000-0xbfff
[    0.324069] pci 0000:00:07.0:   MEM window: 0xfdc00000-0xfdcfffff
[    0.324126] pci 0000:00:07.0:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
[    0.324194] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.324250] pci 0000:00:09.0:   IO window: 0xe000-0xefff
[    0.324307] pci 0000:00:09.0:   MEM window: 0xfd800000-0xfd8fffff
[    0.324364] pci 0000:00:09.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.324431] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    0.324487] pci 0000:00:0b.0:   IO window: 0xd000-0xdfff
[    0.324544] pci 0000:00:0b.0:   MEM window: 0xfde00000-0xfdefffff
[    0.324600] pci 0000:00:0b.0:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
[    0.324668] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.324725] pci 0000:00:14.4:   IO window: 0xa000-0xafff
[    0.324783] pci 0000:00:14.4:   MEM window: 0xfda00000-0xfdafffff
[    0.324845] pci 0000:00:14.4:   PREFETCH window: 0xfd900000-0xfd9fffff
[    0.324908]   alloc irq_desc for 18 on node 0
[    0.324910]   alloc kstat_irqs on node 0
[    0.324919] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.324977] pci 0000:00:02.0: setting latency timer to 64
[    0.324981]   alloc irq_desc for 19 on node 0
[    0.324983]   alloc kstat_irqs on node 0
[    0.324989] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.325047] pci 0000:00:07.0: setting latency timer to 64
[    0.325052]   alloc irq_desc for 17 on node 0
[    0.325053]   alloc kstat_irqs on node 0
[    0.325059] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.325117] pci 0000:00:09.0: setting latency timer to 64
[    0.325121] pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.325178] pci 0000:00:0b.0: setting latency timer to 64
[    0.325185] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.325187] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.325189] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.325191] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]
[    0.325193] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.325196] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.325198] pci_bus 0000:02: resource 1 mem: [0xfdc00000-0xfdcfffff]
[    0.325200] pci_bus 0000:02: resource 2 pref mem [0xfdb00000-0xfdbfffff]
[    0.325202] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.325204] pci_bus 0000:03: resource 1 mem: [0xfd800000-0xfd8fffff]
[    0.325205] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.325208] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.325209] pci_bus 0000:04: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.325211] pci_bus 0000:04: resource 2 pref mem [0xfdd00000-0xfddfffff]
[    0.325214] pci_bus 0000:05: resource 0 io:  [0xa000-0xafff]
[    0.325215] pci_bus 0000:05: resource 1 mem: [0xfda00000-0xfdafffff]
[    0.325217] pci_bus 0000:05: resource 2 pref mem [0xfd900000-0xfd9fffff]
[    0.325219] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.325221] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.325291] NET: Registered protocol family 2
[    0.325490] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.326482] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.328708] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.329049] TCP: Hash tables configured (established 524288 bind 65536)
[    0.329106] TCP reno registered
[    0.329272] NET: Registered protocol family 1
[    0.329372] Trying to unpack rootfs image as initramfs...
[    0.488674] Freeing initrd memory: 9221k freed
[    0.492379] audit: initializing netlink socket (disabled)
[    0.492444] type=2000 audit(1255103185.491:1): initialized
[    0.492787] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.493012] VFS: Disk quotas dquot_6.5.2
[    0.493098] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.493199] msgmni has been set to 7929
[    0.493441] alg: No test for stdrng (krng)
[    0.493547] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.493614] io scheduler noop registered
[    0.493668] io scheduler anticipatory registered
[    0.493722] io scheduler deadline registered
[    0.493796] io scheduler cfq registered (default)
[    0.512928] Switched to high resolution mode on CPU 3
[    0.512931] Switched to high resolution mode on CPU 1
[    0.512932] Switched to high resolution mode on CPU 2
[    0.513119] Switched to high resolution mode on CPU 0
[    0.600310] pci 0000:01:00.0: Boot video device
[    0.600459]   alloc irq_desc for 25 on node 0
[    0.600461]   alloc kstat_irqs on node 0
[    0.600469] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.600473] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.600626]   alloc irq_desc for 26 on node 0
[    0.600628]   alloc kstat_irqs on node 0
[    0.600632] pcieport-driver 0000:00:07.0: irq 26 for MSI/MSI-X
[    0.600636] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    0.600761]   alloc irq_desc for 27 on node 0
[    0.600762]   alloc kstat_irqs on node 0
[    0.600767] pcieport-driver 0000:00:09.0: irq 27 for MSI/MSI-X
[    0.600771] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.600902]   alloc irq_desc for 28 on node 0
[    0.600904]   alloc kstat_irqs on node 0
[    0.600908] pcieport-driver 0000:00:0b.0: irq 28 for MSI/MSI-X
[    0.600912] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    0.603709] Linux agpgart interface v0.103
[    0.608082] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.608281] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.608699] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.610260] brd: module loaded
[    0.610380] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.610596] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.610652] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.610804] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.611015] mice: PS/2 mouse device common for all mice
[    0.611122] rtc_cmos 00:05: RTC can wake from S4
[    0.611226] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.611315] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.611403] cpuidle: using governor ladder
[    0.611458] cpuidle: using governor menu
[    0.611514] No iBFT detected.
[    0.611852] TCP cubic registered
[    0.611967] NET: Registered protocol family 10
[    0.612441] lo: Disabled Privacy Extensions
[    0.612760] Mobile IPv6
[    0.612814] NET: Registered protocol family 17
[    0.613009] registered taskstats version 1
[    0.613221] rtc_cmos 00:05: setting system clock to 2009-10-09 15:46:26 UTC (1255103186)
[    0.613329] Freeing unused kernel memory: 592k freed
[    0.613520] Write protecting the kernel read-only data: 4108k
[    0.653320] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.721859] Floppy drive(s): fd0 is 1.44M
[    0.739054] FDC 0 is a post-1991 82077
[    0.748060] SCSI subsystem initialized
[    0.779359] libata version 3.00 loaded.
[    0.784660] ahci 0000:00:11.0: version 3.0
[    0.784676]   alloc irq_desc for 22 on node 0
[    0.784678]   alloc kstat_irqs on node 0
[    0.784689] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.784882] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.784950] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.785681] scsi0 : ahci
[    0.785835] scsi1 : ahci
[    0.785928] scsi2 : ahci
[    0.786028] scsi3 : ahci
[    0.786118] scsi4 : ahci
[    0.786206] scsi5 : ahci
[    0.786366] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    0.786434] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    0.786501] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 22
[    0.786569] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    0.786636] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    0.786703] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    0.789058] Uniform Multi-Platform E-IDE driver
[    0.790332] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.791328] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.791416] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.791541] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.791629] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    0.791710] ehci_hcd 0000:00:12.2: debug port 1
[    0.791785] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    0.792352] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.798026] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.798105] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.798167] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.798237] usb usb1: Product: EHCI Host Controller
[    0.798297] usb usb1: Manufacturer: Linux 2.6.31-git4 ehci_hcd
[    0.798353] usb usb1: SerialNumber: 0000:00:12.2
[    0.798458] usb usb1: configuration #1 chosen from 1 choice
[    0.798537] hub 1-0:1.0: USB hub found
[    0.798596] hub 1-0:1.0: 6 ports detected
[    0.798723] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.798793] r8169 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.798898] r8169 0000:02:00.0: setting latency timer to 64
[    0.798928]   alloc irq_desc for 29 on node 0
[    0.798930]   alloc kstat_irqs on node 0
[    0.798941] r8169 0000:02:00.0: irq 29 for MSI/MSI-X
[    0.799456] eth0: RTL8168d/8111d at 0xffffc90000676000, 00:24:1d:18:f8:b2, XID 081000c0 IRQ 29
[    0.803223]   alloc irq_desc for 16 on node 0
[    0.803225]   alloc kstat_irqs on node 0
[    0.803235] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.803306] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.803397] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 2
[    0.803495] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    0.803557] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.803620] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.803695] r8169 0000:03:00.0: setting latency timer to 64
[    0.803724]   alloc irq_desc for 30 on node 0
[    0.803725]   alloc kstat_irqs on node 0
[    0.803733] r8169 0000:03:00.0: irq 30 for MSI/MSI-X
[    0.804244] eth1: RTL8168d/8111d at 0xffffc9000063e000, 00:24:1d:18:f8:f3, XID 081000c0 IRQ 30
[    0.858156] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.858216] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.858281] usb usb2: Product: OHCI Host Controller
[    0.858336] usb usb2: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    0.858392] usb usb2: SerialNumber: 0000:00:12.0
[    0.858494] usb usb2: configuration #1 chosen from 1 choice
[    0.858572] hub 2-0:1.0: USB hub found
[    0.858632] hub 2-0:1.0: 3 ports detected
[    0.858793] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.858863] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.858942] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[    0.859032] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    0.859113] ehci_hcd 0000:00:13.2: debug port 1
[    0.859190] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    0.865113] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.865184] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.865241] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.865311] usb usb3: Product: EHCI Host Controller
[    0.865366] usb usb3: Manufacturer: Linux 2.6.31-git4 ehci_hcd
[    0.865421] usb usb3: SerialNumber: 0000:00:13.2
[    0.865511] usb usb3: configuration #1 chosen from 1 choice
[    0.865586] hub 3-0:1.0: USB hub found
[    0.865645] hub 3-0:1.0: 6 ports detected
[    0.865916] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.865982] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.866074] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.866155] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    0.921134] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.921192] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.921257] usb usb4: Product: OHCI Host Controller
[    0.921318] usb usb4: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    0.921374] usb usb4: SerialNumber: 0000:00:12.1
[    0.921462] usb usb4: configuration #1 chosen from 1 choice
[    0.921536] hub 4-0:1.0: USB hub found
[    0.921596] hub 4-0:1.0: 3 ports detected
[    0.921744] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.921811] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.921894] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.921985] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    0.977149] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.977210] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.977275] usb usb5: Product: OHCI Host Controller
[    0.977330] usb usb5: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    0.977386] usb usb5: SerialNumber: 0000:00:13.0
[    0.977474] usb usb5: configuration #1 chosen from 1 choice
[    0.977547] hub 5-0:1.0: USB hub found
[    0.977607] hub 5-0:1.0: 3 ports detected
[    0.977755] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.977820] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.977900] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.977980] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    1.033148] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.033209] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.033275] usb usb6: Product: OHCI Host Controller
[    1.033330] usb usb6: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    1.033386] usb usb6: SerialNumber: 0000:00:13.1
[    1.033473] usb usb6: configuration #1 chosen from 1 choice
[    1.033553] hub 6-0:1.0: USB hub found
[    1.033612] hub 6-0:1.0: 3 ports detected
[    1.033770] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.033837] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.033918] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    1.033998] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    1.089153] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.089212] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.089282] usb usb7: Product: OHCI Host Controller
[    1.089341] usb usb7: Manufacturer: Linux 2.6.31-git4 ohci_hcd
[    1.089396] usb usb7: SerialNumber: 0000:00:14.5
[    1.089494] usb usb7: configuration #1 chosen from 1 choice
[    1.089569] hub 7-0:1.0: USB hub found
[    1.089630] hub 7-0:1.0: 2 ports detected
[    1.093339] ata5: SATA link down (SStatus 0 SControl 300)
[    1.093357] ata4: SATA link down (SStatus 0 SControl 300)
[    1.095880] ata6: SATA link down (SStatus 0 SControl 300)
[    1.246140] ata1: softreset failed (device not ready)
[    1.246198] ata1: applying SB600 PMP SRST workaround and retrying
[    1.250540] ata2: softreset failed (device not ready)
[    1.250602] ata2: applying SB600 PMP SRST workaround and retrying
[    1.287121] usb 2-3: new low speed USB device using ohci_hcd and address 2
[    1.403141] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.403168] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.403831] ata1.00: ATA-7: OCZ-VERTEX v1.10, 1370, max UDMA/133
[    1.403890] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.404718] ata1.00: configured for UDMA/133
[    1.415203] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX v1.10 1370 PQ: 0 ANSI: 5
[    1.430494] ata2.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    1.430551] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.437295] usb 2-3: New USB device found, idVendor=046d, idProduct=c01d
[    1.437353] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.437415] usb 2-3: Product: USB-PS/2 Optical Mouse
[    1.437475] usb 2-3: Manufacturer: Logitech
[    1.437586] usb 2-3: configuration #1 chosen from 1 choice
[    1.470145] ata2.00: configured for UDMA/133
[    1.481188] scsi 1:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    1.663122] ata3: softreset failed (device not ready)
[    1.663182] ata3: applying SB600 PMP SRST workaround and retrying
[    1.816140] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.817402] ata3.00: ATAPI: PIONEER DVD-RW  DVR-212D, 1.21, max UDMA/66
[    1.819117] ata3.00: configured for UDMA/66
[    1.836289] scsi 2:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-212D 1.21 PQ: 0 ANSI: 5
[    1.843129] usbcore: registered new interface driver hiddev
[    1.847788] mvsas 0000:04:00.0: mvsas: driver version 0.8.2
[    1.847858] mvsas 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.847918] mvsas 0000:04:00.0: setting latency timer to 64
[    1.848419] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb2/2-3/2-3:1.0/input/input2
[    1.848533] generic-usb 0003:046D:C01D.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.0-3/input0
[    1.848624] usbcore: registered new interface driver usbhid
[    1.848682] usbhid: v2.6:USB HID core driver
[    1.853150] firewire_ohci 0000:05:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.853296] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    1.853566] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    1.853632] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.853714] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    1.853775]     ide0: BM-DMA at 0xfa00-0xfa07
[    1.853843] atiixp 0000:00:14.1: simplex device: DMA disabled
[    1.853899] ide1: DMA disabled
[    1.853961] Probing IDE interface ide0...
[    1.854329] sd 0:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    1.854350] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.854411] sd 1:0:0:0: [sdb] Write Protect is off
[    1.854413] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.854428] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.854523]  sdb:
[    1.854656] sd 0:0:0:0: [sda] Write Protect is off
[    1.854762] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.854777] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.854929]  sda: sda2
[    1.855781] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.870551]  sdb1 sdb2 sdb3 sdb4
[    1.897112] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.910121] firewire_ohci: Added fw-ohci device 0000:05:0e.0, OHCI version 1.10
[    1.917557] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    1.917617] Uniform CD-ROM driver Revision: 3.20
[    1.917745] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.921951] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.922029] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.922103] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    2.372161] Probing IDE interface ide1...
[    2.375165] ide1: no devices on the port
[    2.375267] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.375412] ide1 at 0x170-0x177,0x376 on irq 15
[    2.409180] firewire_core: created device fw0: GUID 001a9c2c0000241d, S400
[    6.231147] drivers/scsi/mvsas/mv_sas.c 1214:port 0 attach dev info is 20004
[    6.231151] drivers/scsi/mvsas/mv_sas.c 1216:port 0 attach sas addr is 0
[    6.432142] drivers/scsi/mvsas/mv_sas.c 1214:port 1 attach dev info is 0
[    6.432145] drivers/scsi/mvsas/mv_sas.c 1216:port 1 attach sas addr is 1
[    6.633125] drivers/scsi/mvsas/mv_sas.c 1214:port 2 attach dev info is 2000000
[    6.633133] drivers/scsi/mvsas/mv_sas.c 1216:port 2 attach sas addr is 2
[    6.834160] drivers/scsi/mvsas/mv_sas.c 1214:port 3 attach dev info is 2000000
[    6.834162] drivers/scsi/mvsas/mv_sas.c 1216:port 3 attach sas addr is 3
[    6.935122] drivers/scsi/mvsas/mv_sas.c 1214:port 4 attach dev info is 0
[    6.935124] drivers/scsi/mvsas/mv_sas.c 1216:port 4 attach sas addr is 0
[    7.036124] drivers/scsi/mvsas/mv_sas.c 1214:port 5 attach dev info is 0
[    7.036126] drivers/scsi/mvsas/mv_sas.c 1216:port 5 attach sas addr is 0
[    7.137134] drivers/scsi/mvsas/mv_sas.c 1214:port 6 attach dev info is 0
[    7.137136] drivers/scsi/mvsas/mv_sas.c 1216:port 6 attach sas addr is 0
[    7.338143] drivers/scsi/mvsas/mv_sas.c 1214:port 7 attach dev info is 0
[    7.338145] drivers/scsi/mvsas/mv_sas.c 1216:port 7 attach sas addr is 7
[    7.338150] scsi6 : mvsas
[    7.338546] drivers/scsi/mvsas/mv_sas.c 380:phy 0 byte dmaded.
[    7.338550] drivers/scsi/mvsas/mv_sas.c 380:phy 1 byte dmaded.
[    7.338553] drivers/scsi/mvsas/mv_sas.c 380:phy 2 byte dmaded.
[    7.338555] drivers/scsi/mvsas/mv_sas.c 380:phy 3 byte dmaded.
[    7.338558] drivers/scsi/mvsas/mv_sas.c 380:phy 7 byte dmaded.
[    7.339998] drivers/scsi/mvsas/mv_sas.c 1365:found dev[0:5] is gone.
[    7.367233] ata7.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    7.367292] ata7.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.407675] device-mapper: uevent: version 1.0.3
[    7.407778] ata7.00: configured for UDMA/133
[    7.407880] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    7.407892] scsi 6:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    7.408837] drivers/scsi/mvsas/mv_sas.c 1365:found dev[1:5] is gone.
[    7.410467] ata8.00: ATA-8: ST31000523AS, CC35, max UDMA/133
[    7.410526] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.412150] ata8.00: configured for UDMA/133
[    7.412246] scsi 6:0:1:0: Direct-Access     ATA      ST31000523AS     CC35 PQ: 0 ANSI: 5
[    7.413309] drivers/scsi/mvsas/mv_sas.c 1365:found dev[2:5] is gone.
[    7.440486] ata9.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    7.440544] ata9.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.474618] kjournald starting.  Commit interval 5 seconds
[    7.474681] EXT3-fs: mounted filesystem with ordered data mode.
[    7.480250] ata9.00: configured for UDMA/133
[    7.480361] scsi 6:0:2:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    7.481417] drivers/scsi/mvsas/mv_sas.c 1365:found dev[3:5] is gone.
[    7.508612] ata10.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    7.508671] ata10.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.548354] ata10.00: configured for UDMA/133
[    7.548454] scsi 6:0:3:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    7.549597] drivers/scsi/mvsas/mv_sas.c 1365:found dev[4:5] is gone.
[    7.576709] ata11.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    7.576767] ata11.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.616371] ata11.00: configured for UDMA/133
[    7.616484] scsi 6:0:4:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    7.632026] udev: starting version 146
[    7.666064] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    7.666135] ACPI: Power Button [PWRF]
[    7.666241] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[    7.666309] ACPI: Power Button [PWRB]
[    7.671040] processor LNXCPU:00: registered as cooling_device0
[    7.671134] processor LNXCPU:01: registered as cooling_device1
[    7.671223] processor LNXCPU:02: registered as cooling_device2
[    7.671308] processor LNXCPU:03: registered as cooling_device3
[    7.675682] ACPI: WMI: Mapper loaded
[    7.680946] parport_pc 00:0a: reported by Plug and Play ACPI
[    7.681057] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    7.707580] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    7.709487] EDAC MC: Ver: 2.1.0 Sep 15 2009
[    7.710297] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[    7.710367] ACPI: Device needs an ACPI driver
[    7.710735] piix4_smbus: probe of 0000:00:14.0 failed with error -16
[    7.717732] EDAC amd64_edac:  Ver: 3.2.0 Sep 15 2009
[    7.717913] EDAC amd64: This node reports that Memory ECC is currently disabled.
[    7.717983] EDAC amd64: bit 0x400000 in register F3x44 of the MISC_CONTROL device (0000:00:18.3) should be enabled
[    7.718070] EDAC amd64: WARNING: ECC is NOT currently enabled by the BIOS. Module will NOT be loaded.
[    7.718071]     Either Enable ECC in the BIOS, or use the 'ecc_enable_override' parameter.
[    7.718072]     Might be a BIOS bug, if BIOS says ECC is enabled
[    7.718073]     Use of the override can cause unknown side effects.
[    7.718339] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    7.771744] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.813481] hda_codec: ALC889A: BIOS auto-probing.
[    7.815121] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input6
[    7.979181] Adding 8385920k swap on /dev/sdb4.  Priority:-1 extents:1 across:8385920k 
[    8.004544] EXT3 FS on sda2, internal journal
[    8.024904] loop: module loaded
[    8.037740] it87: Found IT8720F chip at 0x228, revision 5
[    8.037804] it87: in3 is VCC (+5V)
[    8.347238] sd 6:0:0:0: Attached scsi generic sg3 type 0
[    8.347385] sd 6:0:1:0: Attached scsi generic sg4 type 0
[    8.347527] sd 6:0:2:0: Attached scsi generic sg5 type 0
[    8.347668] sd 6:0:3:0: Attached scsi generic sg6 type 0
[    8.347809] sd 6:0:4:0: Attached scsi generic sg7 type 0
[    8.348206] sd 6:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.348305] sd 6:0:0:0: [sdc] Write Protect is off
[    8.349210] sd 6:0:1:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.349240] sd 6:0:1:0: [sdd] Write Protect is off
[    8.349242] sd 6:0:1:0: [sdd] Mode Sense: 00 3a 00 00
[    8.349257] sd 6:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.349360]  sdd:
[    8.349410] sd 6:0:2:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.349437] sd 6:0:2:0: [sde] Write Protect is off
[    8.349439] sd 6:0:2:0: [sde] Mode Sense: 00 3a 00 00
[    8.349453] sd 6:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.349528]  sde:
[    8.349568] sd 6:0:3:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.349595] sd 6:0:3:0: [sdf] Write Protect is off
[    8.349597] sd 6:0:3:0: [sdf] Mode Sense: 00 3a 00 00
[    8.349611] sd 6:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.349682]  sdf:
[    8.349723] sd 6:0:4:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    8.349750] sd 6:0:4:0: [sdg] Write Protect is off
[    8.349752] sd 6:0:4:0: [sdg] Mode Sense: 00 3a 00 00
[    8.349766] sd 6:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.349839]  sdg:
[    8.353618] sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    8.353685] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.353868]  sdc: sde1
[    8.354568] sd 6:0:2:0: [sde] Attached SCSI disk
[    8.359595]  sdd1
[    8.359870] sd 6:0:1:0: [sdd] Attached SCSI disk
[    8.361505]  sdf1 sdf2 sdf3 sdf4 < sdc1
[    8.364206] sd 6:0:0:0: [sdc] Attached SCSI disk
[    8.367277]  sdg1
[    8.367541] sd 6:0:4:0: [sdg] Attached SCSI disk
[    8.372247]  sdf5 sdf6
[    8.386534] kjournald starting.  Commit interval 5 seconds
[    8.386900] EXT3 FS on sdb3, internal journal
[    8.387000] EXT3-fs: mounted filesystem with ordered data mode.
[    8.401321]  sdf7 >
[    8.420020] sd 6:0:3:0: [sdf] Attached SCSI disk
[    8.688189] Bridge firewalling registered
[    8.690742] device eth0 entered promiscuous mode
[    8.691857] r8169: eth0: link down
[    8.691919] r8169: eth0: link down
[    8.692456] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.773119] br0: no IPv6 routers present
[   78.193964] RPC: Registered udp transport module.
[   78.194029] RPC: Registered tcp transport module.
[   78.205108] Slow work thread pool: Starting up
[   78.205300] Slow work thread pool: Ready
[   78.205389] FS-Cache: Loaded
[   78.221245] FS-Cache: Netfs 'nfs' registered for caching
[   78.234474] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   78.602077] kvm: Nested Virtualization enabled
[   78.602140] kvm: Nested Paging enabled
[   78.638145] powernow-k8: Found 1 AMD Phenom(tm) II X4 810 Processor processors (4 cpu cores) (version 2.20.00)
[   78.638182] powernow-k8:    0 : pstate 0 (2600 MHz)
[   78.638184] powernow-k8:    1 : pstate 1 (1900 MHz)
[   78.638185] powernow-k8:    2 : pstate 2 (1400 MHz)
[   78.638187] powernow-k8:    3 : pstate 3 (800 MHz)
[   80.422243] CE: hpet increasing min_delta_ns to 15000 nsec
[   80.654350] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   80.654358] vboxdrv: Successfully done.
[   80.654363] vboxdrv: Found 4 processor cores.
[   80.654486] VBoxDrv: dbg - g_abExecMemory=ffffffffa04b38e0
[   80.654680] vboxdrv: fAsync=0 offMin=0x78a offMax=0xaad4
[   80.654838] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   80.654914] vboxdrv: Successfully loaded version 3.0.8 (interface 0x000e0000).
[   80.869190] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa064f620
[   80.876672] VBoxNetAdp: dbg - g_abExecMemory=ffffffffa06661e0
[   82.581970] svc: failed to register lockdv1 RPC service (errno 97).
[   82.583916] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   82.588079] NFSD: starting 90-second grace period
[   82.611836] nvidia: module license 'NVIDIA' taints kernel.
[   82.611846] Disabling lock debugging due to kernel taint
[   82.670113] process `upsagentd' is using obsolete setsockopt SO_BSDCOMPAT
[   82.869005] nvidia 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   82.869051] nvidia 0000:01:00.0: setting latency timer to 64
[   82.869519] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  190.32  Wed Sep  2 02:23:20 PDT 2009
[   82.994455] CE: hpet increasing min_delta_ns to 22500 nsec
[   82.994554] CE: hpet increasing min_delta_ns to 33750 nsec
[   82.994644] CE: hpet increasing min_delta_ns to 50624 nsec
[   83.137500] lo: Disabled Privacy Extensions
[  127.195163] device eth0 left promiscuous mode
[  127.195174] br0: port 1(eth0) entering disabled state
[  127.403611] device eth0 entered promiscuous mode
[  127.408070] r8169: eth0: link down
[  127.408543] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  136.484315] r8169: eth0: link up
[  136.485790] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  136.486541] br0: port 1(eth0) entering learning state
[  138.374167] br0: no IPv6 routers present
[  146.574168] eth0: no IPv6 routers present
[  151.486173] br0: port 1(eth0) entering forwarding state
[  450.706602] md: nonpersistent superblock ...
[  450.706612] md: bind<sdc>
[  450.706661] md: nonpersistent superblock ...
[  450.706666] md: bind<sdd>
[  450.706707] md: nonpersistent superblock ...
[  450.706712] md: bind<sde>
[  450.706751] md: nonpersistent superblock ...
[  450.706756] md: bind<sdf>
[  450.706800] md: nonpersistent superblock ...
[  450.706805] md: bind<sdg>
[  450.711518] md: raid0 personality registered for level 0
[  450.713200] raid0: looking at sdg
[  450.713209] raid0:   comparing sdg(1953524736)
[  450.713215]  with sdg(1953524736)
[  450.713219] raid0:   END
[  450.713222] raid0:   ==> UNIQUE
[  450.713226] raid0: 1 zones
[  450.713230] raid0: looking at sdf
[  450.713235] raid0:   comparing sdf(1953524736)
[  450.713239]  with sdg(1953524736)
[  450.713243] raid0:   EQUAL
[  450.713246] raid0: looking at sde
[  450.713250] raid0:   comparing sde(1953524736)
[  450.713255]  with sdg(1953524736)
[  450.713258] raid0:   EQUAL
[  450.713262] raid0: looking at sdd
[  450.713266] raid0:   comparing sdd(1953524736)
[  450.713270]  with sdg(1953524736)
[  450.713274] raid0:   EQUAL
[  450.713278] raid0: looking at sdc
[  450.713282] raid0:   comparing sdc(1953524736)
[  450.713286]  with sdg(1953524736)
[  450.713290] raid0:   EQUAL
[  450.713294] raid0: FINAL 1 zones
[  450.713302] raid0: done.
[  450.713306] raid0 : md_size is 9767623680 sectors.
[  450.713314] ******* md0 configuration *********
[  450.713320] zone0=[sdc/sdd/sde/sdf/sdg/]
[  450.713351]         zone offset=0kb device offset=0kb size=4883811840kb
[  450.713359] **********************************
[  450.713361] 
[  450.713408] md0: detected capacity change from 0 to 5001023324160
[  450.717296]  md0: unknown partition table
[  554.733043] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[  554.734832] SGI XFS Quota Management subsystem
[  554.735217] XFS: unknown mount option [errors-remount-ro].
[  572.959263] Filesystem "md0": Disabling barriers, trial barrier write failed
[  572.984146] XFS mounting filesystem md0
[  573.232159] Ending clean XFS mount for filesystem: md0
[ 1113.704178] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1113.704187] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1113.704204] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1113.704210] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1113.704222] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1113.704228] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1113.704238] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1113.704243] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1113.704256] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1113.704261] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1144.704187] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1144.704196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1144.704213] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1144.704218] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1144.704231] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1144.704236] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1144.704246] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1144.704251] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1144.704264] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1144.704269] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1175.704199] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1175.704208] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1175.704226] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1175.704232] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1175.704243] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1175.704249] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1175.704258] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1175.704264] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1175.704276] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1175.704281] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1206.704199] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1206.704208] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1206.704224] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1206.704229] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1206.704241] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1206.704246] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1206.704256] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1206.704261] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1206.704274] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1206.704279] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1237.704183] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1237.704192] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1237.704210] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1237.704216] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1237.704228] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1237.704233] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1237.704243] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1237.704248] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1237.704260] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1237.704266] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1268.704204] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1268.704214] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1268.704231] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1268.704237] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1268.704249] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1268.704254] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1268.704264] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1268.704269] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1268.704281] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1268.704287] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1268.704313] sd 6:0:0:0: [sdc] Unhandled error code
[ 1268.704320] sd 6:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1268.704328] sd 6:0:0:0: [sdc] CDB: Read(10): 28 00 32 f1 3a 00 00 04 00 00
[ 1268.704350] end_request: I/O error, dev sdc, sector 854669824
[ 1268.704400] sd 6:0:3:0: [sdf] Unhandled error code
[ 1268.704405] sd 6:0:3:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1268.704412] sd 6:0:3:0: [sdf] CDB: Read(10): 28 00 32 f1 3a 00 00 02 00 00
[ 1268.704431] end_request: I/O error, dev sdf, sector 854669824
[ 1268.704460] sd 6:0:3:0: [sdf] Unhandled error code
[ 1268.704464] sd 6:0:3:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1268.704471] sd 6:0:3:0: [sdf] CDB: Read(10): 28 00 32 f1 36 00 00 04 00 00
[ 1268.704490] end_request: I/O error, dev sdf, sector 854668800
[ 1268.704526] sd 6:0:1:0: [sdd] Unhandled error code
[ 1268.704530] sd 6:0:1:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1268.704537] sd 6:0:1:0: [sdd] CDB: Read(10): 28 00 32 f1 3a 00 00 04 00 00
[ 1268.704556] end_request: I/O error, dev sdd, sector 854669824
[ 1268.704594] sd 6:0:4:0: [sdg] Unhandled error code
[ 1268.704598] sd 6:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1268.704605] sd 6:0:4:0: [sdg] CDB: Read(10): 28 00 32 f1 38 00 00 04 00 00
[ 1268.704624] end_request: I/O error, dev sdg, sector 854669312
[ 1268.704659] sd 6:0:4:0: [sdg] Unhandled error code
[ 1268.704664] sd 6:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1268.704671] sd 6:0:4:0: [sdg] CDB: Read(10): 28 00 32 f1 34 a0 00 03 60 00
[ 1268.704689] end_request: I/O error, dev sdg, sector 854668448
[ 1268.704727] sd 6:0:2:0: [sde] Unhandled error code
[ 1268.704732] sd 6:0:2:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1268.704740] sd 6:0:2:0: [sde] CDB: Write(10): 2a 00 3a 3d 0e 00 00 02 00 00
[ 1268.704760] end_request: I/O error, dev sde, sector 977079808
[ 1268.704782] sd 6:0:2:0: [sde] Unhandled error code
[ 1268.704787] sd 6:0:2:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1268.704794] sd 6:0:2:0: [sde] CDB: Read(10): 28 00 32 f1 3a 00 00 02 a0 00
[ 1268.704814] end_request: I/O error, dev sde, sector 854669824
[ 1268.704882] I/O error in filesystem ("md0") meta-data dev md0 block 0x123314a00       ("xlog_iodone") error 5 buf count 262144
[ 1268.704895] xfs_force_shutdown(md0,0x2) called from line 1043 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0fece9e
[ 1268.704915] Filesystem "md0": Log I/O Error Detected.  Shutting down filesystem: md0
[ 1268.704922] Please umount the filesystem, and rectify the problem(s)
[ 1293.238175] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1299.698199] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1299.698209] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1323.238181] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1329.704150] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1329.704159] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1353.238080] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1360.704186] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1360.704196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1383.238179] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1391.704079] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1391.704088] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1413.239062] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1422.701188] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1422.701198] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1443.240061] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1453.701586] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[ 1453.701596] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[ 1453.701619] sd 6:0:4:0: [sdg] Unhandled error code
[ 1453.701626] sd 6:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 1453.701635] sd 6:0:4:0: [sdg] CDB: Read(10): 28 00 32 f1 34 a0 00 00 08 00
[ 1453.701658] end_request: I/O error, dev sdg, sector 854668448
[ 1473.240912] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1503.243021] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1533.244205] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1563.244081] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1593.244188] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1623.244188] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1653.244202] Filesystem "md0": xfs_log_force: error 5 returned.
[ 1683.244192] Filesystem "md0": xfs_log_force: error 5 returned.

--Boundary-00=_gX3zKjTcxl9dw6G
Content-Type: text/plain;
  charset="UTF-8";
  name="test-data.dmesg2"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="test-data.dmesg2"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-rc3-git2 (moose@natasha) (gcc version 4.3.4 (Debian 4.3.4-5) ) #1 SMP PREEMPT Fri Oct 9 10:55:36 MDT 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-rc3-git2 root=UUID=272a1709-267d-4134-a6b4-e8d3884dca37 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfde0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfde0000 - 00000000cfde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfde3000 - 00000000cfdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfdf0000 - 00000000cfe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 0000CFE00000 mask FFFFFFE00000 uncachable
[    0.000000]   4 base 000100000000 mask FFFFE0000000 write-back
[    0.000000]   5 base 000120000000 mask FFFFF0000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cfe00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcfde0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfde0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfc00000 page 2M
[    0.000000]  00cfc00000 - 00cfde0000 page 4k
[    0.000000] kernel direct mapping tables up to cfde0000 @ 8000-b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ a000-c000
[    0.000000] RAMDISK: 376bd000 - 37fefe01
[    0.000000] ACPI: RSDP 00000000000f7550 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfde3000 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cfde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cfde30c0 0731E (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000cfde0000 00040
[    0.000000] ACPI: SSDT 00000000cfdea4c0 0088C (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 00000000cfdead80 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cfdeadc0 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: TAMG 00000000cfdeae00 0030A (v01 GBT    GBT   B0 5455312E BG?? 53450101)
[    0.000000] ACPI: APIC 00000000cfdea400 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [000000000000b000 - 0000000000012fff]
[    0.000000]   bootmap [0000000000013000 -  0000000000038fff] pages 26
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000166cc14]    TEXT DATA BSS ==> [0001000000 - 000166cc14]
[    0.000000]   #3 [00376bd000 - 0037fefe01]          RAMDISK ==> [00376bd000 - 0037fefe01]
[    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 - 0000100000]
[    0.000000]   #5 [000166d000 - 000166d106]              BRK ==> [000166d000 - 000166d106]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f5b40] f5b40
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000cfde0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1047933
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 105 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833048 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfde0000 - 00000000cfde3000
[    0.000000] PM: Registered nosave memory: 00000000cfde3000 - 00000000cfdf0000
[    0.000000] PM: Registered nosave memory: 00000000cfdf0000 - 00000000cfe00000
[    0.000000] PM: Registered nosave memory: 00000000cfe00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cfe00000 (gap: cfe00000:10200000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880028200000 s90648 r8192 d24040 u524288
[    0.000000] pcpu-alloc: s90648 r8192 d24040 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030804
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-rc3-git2 root=UUID=272a1709-267d-4134-a6b4-e8d3884dca37 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 8d2c000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 4050052k/4980736k available (3107k kernel code, 789004k absent, 141680k reserved, 1712k data, 612k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000]   alloc irq_desc for 24 on node 0
[    0.000000]   alloc kstat_irqs on node 0
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2612.394 MHz processor.
[    0.003004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5224.78 BogoMIPS (lpj=2612390)
[    0.003182] Security Framework initialized
[    0.003239] SELinux:  Disabled at boot.
[    0.003599] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.005072] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.005626] Mount-cache hash table entries: 256
[    0.005788] Initializing cgroup subsys ns
[    0.005843] Initializing cgroup subsys cpuacct
[    0.005900] Initializing cgroup subsys devices
[    0.005955] Initializing cgroup subsys freezer
[    0.006002] Initializing cgroup subsys net_cls
[    0.006082] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.006139] CPU: L2 Cache: 512K (64 bytes/line)
[    0.006195] CPU 0/0x0 -> Node 0
[    0.006249] tseg: 00cfe00000
[    0.006250] CPU: Physical Processor ID: 0
[    0.006304] CPU: Processor Core ID: 0
[    0.006359] mce: CPU supports 6 MCE banks
[    0.006420] using C1E aware idle routine
[    0.006474] Performance Events: AMD PMU driver.
[    0.006571] ... version:                0
[    0.006625] ... bit width:              48
[    0.006679] ... generic registers:      4
[    0.006733] ... value mask:             0000ffffffffffff
[    0.006789] ... max period:             00007fffffffffff
[    0.006844] ... fixed-purpose events:   0
[    0.006898] ... event mask:             000000000000000f
[    0.007503] ACPI: Core revision 20090903
[    0.016064] Setting APIC routing to flat
[    0.016604] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.026939] CPU0: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.027995] System has AMD C1E enabled
[    0.027995] Switch to broadcast mode on CPU0
[    0.028013] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003999] Initializing CPU#1
[    0.003999] Calibrating delay using timer specific routine.. 5223.74 BogoMIPS (lpj=2611871)
[    0.003999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003999] CPU 1/0x1 -> Node 0
[    0.003999] CPU: Physical Processor ID: 0
[    0.003999] CPU: Processor Core ID: 1
[    0.003999] mce: CPU supports 6 MCE banks
[    0.099082] CPU1: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.099660] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.100003] Switch to broadcast mode on CPU1
[    0.102997] Booting processor 2 APIC 0x2 ip 0x6000
[    0.003999] Initializing CPU#2
[    0.003999] Calibrating delay using timer specific routine.. 5223.78 BogoMIPS (lpj=2611892)
[    0.003999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003999] CPU 2/0x2 -> Node 0
[    0.003999] CPU: Physical Processor ID: 0
[    0.003999] CPU: Processor Core ID: 2
[    0.003999] mce: CPU supports 6 MCE banks
[    0.174070] CPU2: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.174648] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.174992] Switch to broadcast mode on CPU2
[    0.178013] Booting processor 3 APIC 0x3 ip 0x6000
[    0.003999] Initializing CPU#3
[    0.003999] Calibrating delay using timer specific routine.. 5223.75 BogoMIPS (lpj=2611878)
[    0.003999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003999] CPU 3/0x3 -> Node 0
[    0.003999] CPU: Physical Processor ID: 0
[    0.003999] CPU: Processor Core ID: 3
[    0.003999] mce: CPU supports 6 MCE banks
[    0.249005] CPU3: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.249586] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.249995] Brought up 4 CPUs
[    0.249993] Switch to broadcast mode on CPU3
[    0.250102] Total of 4 processors activated (20896.06 BogoMIPS).
[    0.251973] CPU0 attaching sched-domain:
[    0.251975]  domain 0: span 0-3 level MC
[    0.251977]   groups: 0 1 2 3
[    0.251983] CPU1 attaching sched-domain:
[    0.251984]  domain 0: span 0-3 level MC
[    0.251986]   groups: 1 2 3 0
[    0.251991] CPU2 attaching sched-domain:
[    0.251992]  domain 0: span 0-3 level MC
[    0.251994]   groups: 2 3 0 1
[    0.251998] CPU3 attaching sched-domain:
[    0.251999]  domain 0: span 0-3 level MC
[    0.252001]   groups: 3 0 1 2
[    0.256022] devtmpfs: initialized
[    0.256423] regulator: core version 0.5
[    0.256552] NET: Registered protocol family 16
[    0.256837] node 0 link 0: io port [a000, ffff]
[    0.256840] TOM: 00000000d0000000 aka 3328M
[    0.256963] Fam 10h mmconf [e0000000, e00fffff]
[    0.256965] node 0 link 0: mmio [a0000, bffff]
[    0.256968] node 0 link 0: mmio [d0000000, dfffffff]
[    0.256970] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.256972] node 0 link 0: mmio [e0000000, e05fffff] ==> [e0100000, e05fffff]
[    0.256976] TOM2: 0000000130000000 aka 4864M
[    0.257031] bus: [00,05] on node 0 link 0
[    0.257033] bus: 00 index 0 io port: [0, ffff]
[    0.257035] bus: 00 index 1 mmio: [a0000, bffff]
[    0.257037] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.257038] bus: 00 index 3 mmio: [e0600000, ffffffff]
[    0.257040] bus: 00 index 4 mmio: [e0100000, e05fffff]
[    0.257042] bus: 00 index 5 mmio: [130000000, fcffffffff]
[    0.257052] ACPI: bus type pci registered
[    0.257208] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.257266] PCI: MCFG area at e0000000 reserved in E820
[    0.263709] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.263765] PCI: Using configuration type 1 for base access
[    0.269062] bio: create slab <bio-0> at 0
[    0.273448] ACPI: EC: Look up EC in DSDT
[    0.281278] ACPI: Interpreter enabled
[    0.281335] ACPI: (supports S0 S3 S4 S5)
[    0.281574] ACPI: Using IOAPIC for interrupt routing
[    0.287154] ACPI: No dock devices found.
[    0.287305] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.288003] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.288021] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.288079] pci 0000:00:02.0: PME# disabled
[    0.288165] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.288222] pci 0000:00:07.0: PME# disabled
[    0.288304] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.288362] pci 0000:00:09.0: PME# disabled
[    0.288444] pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
[    0.288500] pci 0000:00:0b.0: PME# disabled
[    0.288598] pci 0000:00:11.0: reg 10 io port: [0xff00-0xff07]
[    0.288604] pci 0000:00:11.0: reg 14 io port: [0xfe00-0xfe03]
[    0.288610] pci 0000:00:11.0: reg 18 io port: [0xfd00-0xfd07]
[    0.288616] pci 0000:00:11.0: reg 1c io port: [0xfc00-0xfc03]
[    0.288622] pci 0000:00:11.0: reg 20 io port: [0xfb00-0xfb0f]
[    0.288629] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
[    0.288677] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
[    0.298982] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.311996] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe02c000-0xfe02c0ff]
[    0.312056] pci 0000:00:12.2: supports D1 D2
[    0.312058] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.312116] pci 0000:00:12.2: PME# disabled
[    0.312199] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.325027] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.338043] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.338104] pci 0000:00:13.2: supports D1 D2
[    0.338105] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.338164] pci 0000:00:13.2: PME# disabled
[    0.338324] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.338330] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.338336] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.338342] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.338349] pci 0000:00:14.1: reg 20 io port: [0xfa00-0xfa0f]
[    0.338409] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
[    0.338449] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.338507] pci 0000:00:14.2: PME# disabled
[    0.338658] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe028000-0xfe028fff]
[    0.350105] pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.350113] pci 0000:01:00.0: reg 14 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.350121] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.350125] pci 0000:01:00.0: reg 24 io port: [0xcf00-0xcf7f]
[    0.350130] pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.350195] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.350197] pci 0000:00:02.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    0.350201] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.350232] pci 0000:02:00.0: reg 10 io port: [0xbe00-0xbeff]
[    0.350245] pci 0000:02:00.0: reg 18 64bit mmio pref: [0xfdbff000-0xfdbfffff]
[    0.350255] pci 0000:02:00.0: reg 20 64bit mmio pref: [0xfdbf8000-0xfdbfbfff]
[    0.350261] pci 0000:02:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.350288] pci 0000:02:00.0: supports D1 D2
[    0.350289] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.350348] pci 0000:02:00.0: PME# disabled
[    0.350456] pci 0000:00:07.0: bridge io port: [0xb000-0xbfff]
[    0.350458] pci 0000:00:07.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
[    0.350462] pci 0000:00:07.0: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
[    0.350493] pci 0000:03:00.0: reg 10 io port: [0xee00-0xeeff]
[    0.350507] pci 0000:03:00.0: reg 18 64bit mmio pref: [0xfdfff000-0xfdffffff]
[    0.350517] pci 0000:03:00.0: reg 20 64bit mmio pref: [0xfdff8000-0xfdffbfff]
[    0.350522] pci 0000:03:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.350549] pci 0000:03:00.0: supports D1 D2
[    0.350550] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.350609] pci 0000:03:00.0: PME# disabled
[    0.350717] pci 0000:00:09.0: bridge io port: [0xe000-0xefff]
[    0.350719] pci 0000:00:09.0: bridge 32bit mmio: [0xfd800000-0xfd8fffff]
[    0.350722] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.350757] pci 0000:04:00.0: reg 18 io port: [0xdf00-0xdf7f]
[    0.350769] pci 0000:04:00.0: reg 20 64bit mmio: [0xfdef0000-0xfdefffff]
[    0.350774] pci 0000:04:00.0: reg 30 32bit mmio pref: [0x000000-0x03ffff]
[    0.350795] pci 0000:04:00.0: supports D1
[    0.350797] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.350854] pci 0000:04:00.0: PME# disabled
[    0.351047] pci 0000:00:0b.0: bridge io port: [0xd000-0xdfff]
[    0.351050] pci 0000:00:0b.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.351053] pci 0000:00:0b.0: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
[    0.351116] pci 0000:05:0e.0: reg 10 32bit mmio: [0xfdaff000-0xfdaff7ff]
[    0.351125] pci 0000:05:0e.0: reg 14 32bit mmio: [0xfdaf8000-0xfdafbfff]
[    0.351179] pci 0000:05:0e.0: supports D1 D2
[    0.351181] pci 0000:05:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.351240] pci 0000:05:0e.0: PME# disabled
[    0.351326] pci 0000:00:14.4: transparent bridge
[    0.351383] pci 0000:00:14.4: bridge io port: [0xa000-0xafff]
[    0.351387] pci 0000:00:14.4: bridge 32bit mmio: [0xfda00000-0xfdafffff]
[    0.351391] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfd900000-0xfd9fffff]
[    0.351406] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.351678] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.351759] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.351817] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.351867] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.351918] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEB._PRT]
[    0.377315] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.377359] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.377958] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.378559] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.379183] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.379782] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.380388] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.381019] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.382562] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.382562] vgaarb: loaded
[    0.382562] usbcore: registered new interface driver usbfs
[    0.383014] usbcore: registered new interface driver hub
[    0.383073] usbcore: registered new device driver usb
[    0.383076] PCI: Using ACPI for IRQ routing
[    0.383076] pci 0000:00:00.0: BAR 3: address space collision on of device [0xe0000000-0xffffffff]
[    0.383131] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.383283] PCI-DMA: Disabling AGP.
[    0.384011] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.384058] PCI-DMA: using GART IOMMU.
[    0.384114] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.384979] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.384979] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.387043] hpet: hpet2 irq 24 for MSI
[    0.390009] Switching to clocksource tsc
[    0.391077] pnp: PnP ACPI init
[    0.391144] ACPI: bus type pnp registered
[    0.394071] pnp 00:0d: mem resource (0xd6c00-0xd7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.394141] pnp 00:0d: mem resource (0xf0000-0xf7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.394210] pnp 00:0d: mem resource (0xf8000-0xfbfff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.394279] pnp 00:0d: mem resource (0xfc000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.394348] pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.394416] pnp 00:0d: mem resource (0x100000-0xcfddffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.394611] pnp: PnP ACPI: found 14 devices
[    0.394666] ACPI: ACPI bus type pnp unregistered
[    0.394727] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.394799] system 00:01: ioport range 0x220-0x225 has been reserved
[    0.394856] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.394915] system 00:02: ioport range 0x4100-0x411f has been reserved
[    0.394972] system 00:02: ioport range 0x228-0x22f has been reserved
[    0.395029] system 00:02: ioport range 0x40b-0x40b has been reserved
[    0.395086] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[    0.395143] system 00:02: ioport range 0xc00-0xc01 has been reserved
[    0.395200] system 00:02: ioport range 0xc14-0xc14 has been reserved
[    0.395257] system 00:02: ioport range 0xc50-0xc52 has been reserved
[    0.395314] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[    0.395371] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[    0.395427] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[    0.395484] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[    0.395541] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[    0.395598] system 00:02: ioport range 0x4000-0x40fe has been reserved
[    0.395655] system 00:02: ioport range 0x4210-0x4217 has been reserved
[    0.395712] system 00:02: ioport range 0xb00-0xb0f has been reserved
[    0.395779] system 00:02: ioport range 0xb10-0xb1f has been reserved
[    0.395836] system 00:02: ioport range 0xb20-0xb3f has been reserved
[    0.395900] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.395961] system 00:0d: iomem range 0xcfde0000-0xcfdfffff could not be reserved
[    0.396027] system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
[    0.396085] system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.396152] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.396209] system 00:0d: iomem range 0xfff80000-0xfffeffff has been reserved
[    0.401318] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.401375] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.401432] pci 0000:00:02.0:   MEM window: 0xf8000000-0xfbffffff
[    0.401489] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.401557] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.401614] pci 0000:00:07.0:   IO window: 0xb000-0xbfff
[    0.401670] pci 0000:00:07.0:   MEM window: 0xfdc00000-0xfdcfffff
[    0.401735] pci 0000:00:07.0:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
[    0.401805] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.401862] pci 0000:00:09.0:   IO window: 0xe000-0xefff
[    0.401918] pci 0000:00:09.0:   MEM window: 0xfd800000-0xfd8fffff
[    0.401975] pci 0000:00:09.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.402043] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    0.402099] pci 0000:00:0b.0:   IO window: 0xd000-0xdfff
[    0.402156] pci 0000:00:0b.0:   MEM window: 0xfde00000-0xfdefffff
[    0.402212] pci 0000:00:0b.0:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
[    0.402280] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.402337] pci 0000:00:14.4:   IO window: 0xa000-0xafff
[    0.402395] pci 0000:00:14.4:   MEM window: 0xfda00000-0xfdafffff
[    0.402454] pci 0000:00:14.4:   PREFETCH window: 0xfd900000-0xfd9fffff
[    0.402517]   alloc irq_desc for 18 on node 0
[    0.402518]   alloc kstat_irqs on node 0
[    0.402527] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.402585] pci 0000:00:02.0: setting latency timer to 64
[    0.402590]   alloc irq_desc for 19 on node 0
[    0.402591]   alloc kstat_irqs on node 0
[    0.402598] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.402655] pci 0000:00:07.0: setting latency timer to 64
[    0.402660]   alloc irq_desc for 17 on node 0
[    0.402661]   alloc kstat_irqs on node 0
[    0.402668] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.402726] pci 0000:00:09.0: setting latency timer to 64
[    0.402749] pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.402807] pci 0000:00:0b.0: setting latency timer to 64
[    0.402814] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.402816] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.402818] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.402820] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]
[    0.402822] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.402824] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.402826] pci_bus 0000:02: resource 1 mem: [0xfdc00000-0xfdcfffff]
[    0.402828] pci_bus 0000:02: resource 2 pref mem [0xfdb00000-0xfdbfffff]
[    0.402830] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.402832] pci_bus 0000:03: resource 1 mem: [0xfd800000-0xfd8fffff]
[    0.402834] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.402836] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.402837] pci_bus 0000:04: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.402839] pci_bus 0000:04: resource 2 pref mem [0xfdd00000-0xfddfffff]
[    0.402841] pci_bus 0000:05: resource 0 io:  [0xa000-0xafff]
[    0.402843] pci_bus 0000:05: resource 1 mem: [0xfda00000-0xfdafffff]
[    0.402845] pci_bus 0000:05: resource 2 pref mem [0xfd900000-0xfd9fffff]
[    0.402847] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.402849] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.402914] NET: Registered protocol family 2
[    0.403124] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.404221] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.406453] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.406794] TCP: Hash tables configured (established 524288 bind 65536)
[    0.406852] TCP reno registered
[    0.407020] NET: Registered protocol family 1
[    0.407123] Trying to unpack rootfs image as initramfs...
[    0.570521] Freeing initrd memory: 9419k freed
[    0.574288] audit: initializing netlink socket (disabled)
[    0.574355] type=2000 audit(1255108530.573:1): initialized
[    0.574658] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.574934] VFS: Disk quotas dquot_6.5.2
[    0.575017] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.575125] msgmni has been set to 7928
[    0.575378] alg: No test for stdrng (krng)
[    0.575483] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.575550] io scheduler noop registered
[    0.579883] io scheduler anticipatory registered
[    0.579937] io scheduler deadline registered
[    0.580010] io scheduler cfq registered (default)
[    0.580107] pci 0000:01:00.0: Boot video device
[    0.580265]   alloc irq_desc for 25 on node 0
[    0.580267]   alloc kstat_irqs on node 0
[    0.580275] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.580280] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.580412]   alloc irq_desc for 26 on node 0
[    0.580414]   alloc kstat_irqs on node 0
[    0.580418] pcieport-driver 0000:00:07.0: irq 26 for MSI/MSI-X
[    0.580422] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    0.580536]   alloc irq_desc for 27 on node 0
[    0.580537]   alloc kstat_irqs on node 0
[    0.580542] pcieport-driver 0000:00:09.0: irq 27 for MSI/MSI-X
[    0.580546] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.580660]   alloc irq_desc for 28 on node 0
[    0.580662]   alloc kstat_irqs on node 0
[    0.580666] pcieport-driver 0000:00:0b.0: irq 28 for MSI/MSI-X
[    0.580670] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    0.583608] Linux agpgart interface v0.103
[    0.583664] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.583841] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.584272] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.585921] brd: module loaded
[    0.586033] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.586244] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.586300] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.586452] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.586717] mice: PS/2 mouse device common for all mice
[    0.586802] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.586879] rtc_cmos 00:05: RTC can wake from S4
[    0.586976] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.587062] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.587142] cpuidle: using governor ladder
[    0.587197] cpuidle: using governor menu
[    0.587255] No iBFT detected.
[    0.587592] TCP cubic registered
[    0.587710] NET: Registered protocol family 10
[    0.588153] lo: Disabled Privacy Extensions
[    0.588449] Mobile IPv6
[    0.588503] NET: Registered protocol family 17
[    0.588677] registered taskstats version 1
[    0.589099] rtc_cmos 00:05: setting system clock to 2009-10-09 17:15:31 UTC (1255108531)
[    0.589205] Freeing unused kernel memory: 612k freed
[    0.589407] Write protecting the kernel read-only data: 4224k
[    0.596152] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.683893] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.683979] r8169 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.684079] r8169 0000:02:00.0: setting latency timer to 64
[    0.684110]   alloc irq_desc for 29 on node 0
[    0.684113]   alloc kstat_irqs on node 0
[    0.684125] r8169 0000:02:00.0: irq 29 for MSI/MSI-X
[    0.684613] eth0: RTL8168d/8111d at 0xffffc90000666000, 00:24:1d:18:f8:b2, XID 081000c0 IRQ 29
[    0.702070] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.702833] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    0.702906] ACPI: Power Button [PWRB]
[    0.703025] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.703093] ACPI: Power Button [PWRF]
[    0.709712] Uniform Multi-Platform E-IDE driver
[    0.710809] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.710899] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.711022] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.711114] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    0.711192] ehci_hcd 0000:00:12.2: debug port 1
[    0.711273] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    0.713114] SCSI subsystem initialized
[    0.716694] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.716774] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.716832] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.716899] usb usb1: Product: EHCI Host Controller
[    0.716955] usb usb1: Manufacturer: Linux 2.6.32-rc3-git2 ehci_hcd
[    0.717012] usb usb1: SerialNumber: 0000:00:12.2
[    0.717131] usb usb1: configuration #1 chosen from 1 choice
[    0.717210] hub 1-0:1.0: USB hub found
[    0.717271] hub 1-0:1.0: 6 ports detected
[    0.723713] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.723806] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.723918] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.724007] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    0.724084] ehci_hcd 0000:00:13.2: debug port 1
[    0.724165] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    0.724648] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.727698] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.727772] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.727865] r8169 0000:03:00.0: setting latency timer to 64
[    0.727897]   alloc irq_desc for 30 on node 0
[    0.727899]   alloc kstat_irqs on node 0
[    0.727910] r8169 0000:03:00.0: irq 30 for MSI/MSI-X
[    0.728419] eth1: RTL8168d/8111d at 0xffffc9000064e000, 00:24:1d:18:f8:f3, XID 081000c0 IRQ 30
[    0.732172] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.732246] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.732303] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.732369] usb usb2: Product: EHCI Host Controller
[    0.732424] usb usb2: Manufacturer: Linux 2.6.32-rc3-git2 ehci_hcd
[    0.732480] usb usb2: SerialNumber: 0000:00:13.2
[    0.732595] usb usb2: configuration #1 chosen from 1 choice
[    0.732679] hub 2-0:1.0: USB hub found
[    0.732739] hub 2-0:1.0: 6 ports detected
[    0.732870]   alloc irq_desc for 22 on node 0
[    0.732872]   alloc kstat_irqs on node 0
[    0.732881] firewire_ohci 0000:05:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.733799]   alloc irq_desc for 16 on node 0
[    0.733801]   alloc kstat_irqs on node 0
[    0.733810] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.733881] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.733976] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.734077] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    0.736418] libata version 3.00 loaded.
[    0.737284] Floppy drive(s): fd0 is 1.44M
[    0.742671] mvsas 0000:04:00.0: mvsas: driver version 0.8.2
[    0.742737] mvsas 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.742797] mvsas 0000:04:00.0: setting latency timer to 64
[    0.744063] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    0.751650] FDC 0 is a post-1991 82077
[    0.788794] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.788853] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.788919] usb usb3: Product: OHCI Host Controller
[    0.788974] usb usb3: Manufacturer: Linux 2.6.32-rc3-git2 ohci_hcd
[    0.789030] usb usb3: SerialNumber: 0000:00:12.0
[    0.789153] usb usb3: configuration #1 chosen from 1 choice
[    0.789231] hub 3-0:1.0: USB hub found
[    0.789292] hub 3-0:1.0: 3 ports detected
[    0.789473] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    0.789538] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.789618] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    0.789684]     ide0: BM-DMA at 0xfa00-0xfa07
[    0.789752] atiixp 0000:00:14.1: simplex device: DMA disabled
[    0.789808] ide1: DMA disabled
[    0.789870] Probing IDE interface ide0...
[    0.791660] firewire_ohci: Added fw-ohci device 0000:05:0e.0, OHCI version 1.10
[    1.217122] usb 3-3: new low speed USB device using ohci_hcd and address 2
[    1.292081] firewire_core: created device fw0: GUID 001a9c2c0000241d, S400
[    1.313134] Probing IDE interface ide1...
[    1.316143] ide1: no devices on the port
[    1.316269] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.316414] ide1 at 0x170-0x177,0x376 on irq 15
[    1.317261] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.317346] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.317461] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    1.317547] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    1.367804] usb 3-3: New USB device found, idVendor=046d, idProduct=c01d
[    1.367863] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.367921] usb 3-3: Product: USB-PS/2 Optical Mouse
[    1.367976] usb 3-3: Manufacturer: Logitech
[    1.368141] usb 3-3: configuration #1 chosen from 1 choice
[    1.372068] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.372126] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.372191] usb usb4: Product: OHCI Host Controller
[    1.372246] usb usb4: Manufacturer: Linux 2.6.32-rc3-git2 ohci_hcd
[    1.372303] usb usb4: SerialNumber: 0000:00:12.1
[    1.372433] usb usb4: configuration #1 chosen from 1 choice
[    1.372526] hub 4-0:1.0: USB hub found
[    1.372587] hub 4-0:1.0: 3 ports detected
[    1.372784] ahci 0000:00:11.0: version 3.0
[    1.372793] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.372960] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.373037] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    1.373407] scsi1 : ahci
[    1.373592] scsi2 : ahci
[    1.373704] scsi3 : ahci
[    1.373814] scsi4 : ahci
[    1.373922] scsi5 : ahci
[    1.374047] scsi6 : ahci
[    1.374219] ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed
[    1.374277] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    1.374344] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed
[    1.374419] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    1.374485] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    1.374552] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    1.375310] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.375382] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.375500] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.375596] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    1.430140] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.430198] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.430266] usb usb5: Product: OHCI Host Controller
[    1.430325] usb usb5: Manufacturer: Linux 2.6.32-rc3-git2 ohci_hcd
[    1.430381] usb usb5: SerialNumber: 0000:00:13.0
[    1.430506] usb usb5: configuration #1 chosen from 1 choice
[    1.430598] hub 5-0:1.0: USB hub found
[    1.434963] hub 5-0:1.0: 3 ports detected
[    1.436109] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.436177] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.436281] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    1.436361] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    1.491149] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.491209] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.491275] usb usb6: Product: OHCI Host Controller
[    1.491330] usb usb6: Manufacturer: Linux 2.6.32-rc3-git2 ohci_hcd
[    1.491387] usb usb6: SerialNumber: 0000:00:13.1
[    1.491505] usb usb6: configuration #1 chosen from 1 choice
[    1.491596] hub 6-0:1.0: USB hub found
[    1.491656] hub 6-0:1.0: 3 ports detected
[    1.492122] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.492195] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.492298] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    1.492379] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    1.547140] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.547199] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.547264] usb usb7: Product: OHCI Host Controller
[    1.547319] usb usb7: Manufacturer: Linux 2.6.32-rc3-git2 ohci_hcd
[    1.547376] usb usb7: SerialNumber: 0000:00:14.5
[    1.547497] usb usb7: configuration #1 chosen from 1 choice
[    1.547588] hub 7-0:1.0: USB hub found
[    1.547648] hub 7-0:1.0: 2 ports detected
[    1.679158] ata6: SATA link down (SStatus 0 SControl 300)
[    1.681129] ata5: SATA link down (SStatus 0 SControl 300)
[    1.682123] ata4: SATA link down (SStatus 0 SControl 300)
[    1.832088] ata2: softreset failed (device not ready)
[    1.832145] ata2: applying SB600 PMP SRST workaround and retrying
[    1.985133] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.012374] ata2.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    2.012436] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.052206] ata2.00: configured for UDMA/133
[    2.251101] ata3: softreset failed (device not ready)
[    2.251108] ata1: softreset failed (device not ready)
[    2.251111] ata1: applying SB600 PMP SRST workaround and retrying
[    2.251281] ata3: applying SB600 PMP SRST workaround and retrying
[    2.404124] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.404127] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.404834] ata1.00: ATA-7: OCZ-VERTEX v1.10, 1370, max UDMA/133
[    2.404893] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.405345] ata3.00: ATAPI: PIONEER DVD-RW  DVR-212D, 1.21, max UDMA/66
[    2.405416] ata1.00: configured for UDMA/133
[    2.407111] ata3.00: configured for UDMA/66
[    2.416181] scsi 1:0:0:0: Direct-Access     ATA      OCZ-VERTEX v1.10 1370 PQ: 0 ANSI: 5
[    2.416421] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    2.423933] scsi 3:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-212D 1.21 PQ: 0 ANSI: 5
[    2.428100] sd 1:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    2.428152] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.428183] sd 2:0:0:0: [sdb] Write Protect is off
[    2.428185] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.428200] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.428324]  sdb:
[    2.428436] sd 1:0:0:0: [sda] Write Protect is off
[    2.428541] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.428557] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.428724]  sda: sda2
[    2.429324] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.438431]  sdb1 sdb2 sdb3 sdb4
[    2.464934] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.467052] usbcore: registered new interface driver hiddev
[    2.473792] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.0/input/input4
[    2.473912] generic-usb 0003:046D:C01D.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.0-3/input0
[    2.473999] usbcore: registered new interface driver usbhid
[    2.474059] usbhid: v2.6:USB HID core driver
[    2.487186] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    2.487244] Uniform CD-ROM driver Revision: 3.20
[    2.487452] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.490172] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.490280] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.490361] sr 3:0:0:0: Attached scsi generic sg2 type 5
[    5.124153] drivers/scsi/mvsas/mv_sas.c 1214:port 0 attach dev info is 0
[    5.124156] drivers/scsi/mvsas/mv_sas.c 1216:port 0 attach sas addr is 0
[    5.325142] drivers/scsi/mvsas/mv_sas.c 1214:port 1 attach dev info is 0
[    5.325145] drivers/scsi/mvsas/mv_sas.c 1216:port 1 attach sas addr is 1
[    5.526132] drivers/scsi/mvsas/mv_sas.c 1214:port 2 attach dev info is 2000000
[    5.526134] drivers/scsi/mvsas/mv_sas.c 1216:port 2 attach sas addr is 2
[    5.727131] drivers/scsi/mvsas/mv_sas.c 1214:port 3 attach dev info is 2000000
[    5.727133] drivers/scsi/mvsas/mv_sas.c 1216:port 3 attach sas addr is 3
[    5.828106] drivers/scsi/mvsas/mv_sas.c 1214:port 4 attach dev info is 0
[    5.828108] drivers/scsi/mvsas/mv_sas.c 1216:port 4 attach sas addr is 0
[    5.929109] drivers/scsi/mvsas/mv_sas.c 1214:port 5 attach dev info is 0
[    5.929111] drivers/scsi/mvsas/mv_sas.c 1216:port 5 attach sas addr is 0
[    6.030102] drivers/scsi/mvsas/mv_sas.c 1214:port 6 attach dev info is 0
[    6.030104] drivers/scsi/mvsas/mv_sas.c 1216:port 6 attach sas addr is 0
[    6.231112] drivers/scsi/mvsas/mv_sas.c 1214:port 7 attach dev info is 0
[    6.231114] drivers/scsi/mvsas/mv_sas.c 1216:port 7 attach sas addr is 7
[    6.231119] scsi0 : mvsas
[    6.231530] drivers/scsi/mvsas/mv_sas.c 380:phy 0 byte dmaded.
[    6.231533] drivers/scsi/mvsas/mv_sas.c 380:phy 1 byte dmaded.
[    6.231536] drivers/scsi/mvsas/mv_sas.c 380:phy 2 byte dmaded.
[    6.231538] drivers/scsi/mvsas/mv_sas.c 380:phy 3 byte dmaded.
[    6.231540] drivers/scsi/mvsas/mv_sas.c 380:phy 7 byte dmaded.
[    6.232850] drivers/scsi/mvsas/mv_sas.c 1365:found dev[0:5] is gone.
[    6.260393] ata7.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    6.260452] ata7.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.284789] device-mapper: uevent: version 1.0.3
[    6.284951] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    6.300081] ata7.00: configured for UDMA/133
[    6.300109] kjournald starting.  Commit interval 5 seconds
[    6.300121] EXT3-fs: mounted filesystem with ordered data mode.
[    6.300287] scsi 0:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    6.301316] drivers/scsi/mvsas/mv_sas.c 1365:found dev[1:5] is gone.
[    6.302775] ata8.00: ATA-8: ST31000523AS, CC35, max UDMA/133
[    6.302841] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.304161] ata8.00: configured for UDMA/133
[    6.304251] scsi 0:0:1:0: Direct-Access     ATA      ST31000523AS     CC35 PQ: 0 ANSI: 5
[    6.306722] drivers/scsi/mvsas/mv_sas.c 1365:found dev[2:5] is gone.
[    6.333837] ata9.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    6.333896] ata9.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.373625] ata9.00: configured for UDMA/133
[    6.373717] scsi 0:0:2:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    6.374786] drivers/scsi/mvsas/mv_sas.c 1365:found dev[3:5] is gone.
[    6.401912] ata10.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    6.401971] ata10.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.441462] ata10.00: configured for UDMA/133
[    6.441562] scsi 0:0:3:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    6.442681] drivers/scsi/mvsas/mv_sas.c 1365:found dev[4:5] is gone.
[    6.459715] udev: starting version 146
[    6.469810] ata11.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    6.469868] ata11.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.486720] processor LNXCPU:00: registered as cooling_device0
[    6.486824] processor LNXCPU:01: registered as cooling_device1
[    6.486910] processor LNXCPU:02: registered as cooling_device2
[    6.486995] processor LNXCPU:03: registered as cooling_device3
[    6.497868] parport_pc 00:0a: reported by Plug and Play ACPI
[    6.497981] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.509334] ata11.00: configured for UDMA/133
[    6.509461] scsi 0:0:4:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    6.534342] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    6.539646] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[    6.539718] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.542188] EDAC MC: Ver: 2.1.0 Oct  9 2009
[    6.551565] EDAC amd64_edac:  Ver: 3.2.0 Oct  9 2009
[    6.552590] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
[    6.552671] EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
[    6.552673]  Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
[    6.552674]  Also, use of the override can cause unknown side effects.
[    6.552879] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    6.610870] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.649906] hda_codec: ALC889A: BIOS auto-probing.
[    6.651400] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input6
[    6.864370] Adding 8385920k swap on /dev/sdb4.  Priority:-1 extents:1 across:8385920k 
[    6.889282] EXT3 FS on sda2, internal journal
[    6.908799] loop: module loaded
[    6.920222] it87: Found IT8720F chip at 0x228, revision 5
[    6.920297] it87: in3 is VCC (+5V)
[    7.233160] sd 0:0:0:0: Attached scsi generic sg3 type 0
[    7.233331] sd 0:0:1:0: Attached scsi generic sg4 type 0
[    7.233337] sd 0:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.233365] sd 0:0:0:0: [sdc] Write Protect is off
[    7.233368] sd 0:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    7.233382] sd 0:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.233495] sd 0:0:1:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.233510]  sdc:
[    7.233538] sd 0:0:1:0: [sdd] Write Protect is off
[    7.233540] sd 0:0:1:0: [sdd] Mode Sense: 00 3a 00 00
[    7.233554] sd 0:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.233667]  sdd:
[    7.238431] sd 0:0:2:0: Attached scsi generic sg5 type 0
[    7.238638] sd 0:0:2:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.238758] sd 0:0:2:0: [sde] Write Protect is off
[    7.238820] sd 0:0:2:0: [sde] Mode Sense: 00 3a 00 00
[    7.238836] sd 0:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.238993]  sde:
[    7.239144] sd 0:0:3:0: Attached scsi generic sg6 type 0
[    7.239478] sd 0:0:4:0: Attached scsi generic sg7 type 0
[    7.239890] sd 0:0:3:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.239986] sd 0:0:3:0: [sdf] Write Protect is off
[    7.240045] sd 0:0:3:0: [sdf] Mode Sense: 00 3a 00 00
[    7.240061] sd 0:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.240230]  sdf:
[    7.240316] sd 0:0:4:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.240458] sd 0:0:4:0: [sdg] Write Protect is off
[    7.240514] sd 0:0:4:0: [sdg] Mode Sense: 00 3a 00 00
[    7.240528] sd 0:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.241170]  sdg: unknown partition table
[    7.247573] sd 0:0:0:0: [sdc] Attached SCSI disk
[    7.249636]  unknown partition table
[    7.249929] sd 0:0:1:0: [sdd] Attached SCSI disk
[    7.250842]  unknown partition table
[    7.251435]  unknown partition table
[    7.251457] sd 0:0:2:0: [sde] Attached SCSI disk
[    7.252071] sd 0:0:4:0: [sdg] Attached SCSI disk
[    7.252522]  unknown partition table
[    7.252810] sd 0:0:3:0: [sdf] Attached SCSI disk
[    7.257043] kjournald starting.  Commit interval 5 seconds
[    7.257536] EXT3 FS on sdb3, internal journal
[    7.257639] EXT3-fs: mounted filesystem with ordered data mode.
[    7.486947] Bridge firewalling registered
[    7.489667] device eth0 entered promiscuous mode
[    7.491909] r8169: eth0: link down
[    7.491972] r8169: eth0: link down
[    7.492464] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.485017] br0: no IPv6 routers present
[   78.172371] RPC: Registered udp transport module.
[   78.172441] RPC: Registered tcp transport module.
[   78.172496] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   78.183319] Slow work thread pool: Starting up
[   78.183433] Slow work thread pool: Ready
[   78.183513] FS-Cache: Loaded
[   78.201219] FS-Cache: Netfs 'nfs' registered for caching
[   78.213988] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   78.554225] kvm: Nested Virtualization enabled
[   78.554281] kvm: Nested Paging enabled
[   78.592703] powernow-k8: Found 1 AMD Phenom(tm) II X4 810 Processor processors (4 cpu cores) (version 2.20.00)
[   78.592741] powernow-k8:    0 : pstate 0 (2600 MHz)
[   78.592743] powernow-k8:    1 : pstate 1 (1900 MHz)
[   78.592745] powernow-k8:    2 : pstate 2 (1400 MHz)
[   78.592746] powernow-k8:    3 : pstate 3 (800 MHz)
[   82.103590] process `upsagentd' is using obsolete setsockopt SO_BSDCOMPAT
[   82.475158] lo: Disabled Privacy Extensions
[   92.987633] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[  121.264073] device eth0 left promiscuous mode
[  121.264083] br0: port 1(eth0) entering disabled state
[  121.413369] device eth0 entered promiscuous mode
[  121.414370] r8169: eth0: link down
[  121.414808] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  131.674052] br0: no IPv6 routers present
[  192.256720] device eth0 left promiscuous mode
[  192.256731] br0: port 1(eth0) entering disabled state
[  192.455432] device eth0 entered promiscuous mode
[  192.458515] r8169: eth0: link down
[  192.459894] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  202.761139] br0: no IPv6 routers present
[  220.690305] CE: hpet increasing min_delta_ns to 15000 nsec
[  286.341818] device eth0 left promiscuous mode
[  286.341830] br0: port 1(eth0) entering disabled state
[  286.511184] device eth0 entered promiscuous mode
[  286.512254] r8169: eth0: link down
[  286.512702] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  296.613530] br0: no IPv6 routers present
[  338.939342] device eth0 left promiscuous mode
[  338.939348] br0: port 1(eth0) entering disabled state
[  339.130661] device eth1 entered promiscuous mode
[  339.134564] r8169: eth1: link down
[  339.134572] r8169: eth1: link down
[  339.135013] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  349.482281] br0: no IPv6 routers present
[  388.155110] device eth1 left promiscuous mode
[  388.155121] br0: port 1(eth1) entering disabled state
[  410.211499] device eth1 entered promiscuous mode
[  410.215368] r8169: eth1: link down
[  410.216852] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  420.879170] br0: no IPv6 routers present
[  434.448677] device eth1 left promiscuous mode
[  434.448688] br0: port 1(eth1) entering disabled state
[  451.676874] device eth0 entered promiscuous mode
[  451.677994] r8169: eth0: link up
[  451.678004] r8169: eth0: link up
[  451.683438] br0: port 1(eth0) entering learning state
[  462.264154] br0: no IPv6 routers present
[  462.655175] eth0: no IPv6 routers present
[  466.683163] br0: port 1(eth0) entering forwarding state
[  472.254038] svc: failed to register lockdv1 RPC service (errno 97).
[  693.557737] md: nonpersistent superblock ...
[  693.557748] md: bind<sdc>
[  693.557798] md: nonpersistent superblock ...
[  693.557805] md: bind<sdd>
[  693.557899] md: nonpersistent superblock ...
[  693.557906] md: bind<sde>
[  693.557952] md: nonpersistent superblock ...
[  693.557958] md: bind<sdf>
[  693.557997] md: nonpersistent superblock ...
[  693.558003] md: bind<sdg>
[  693.563692] md: raid0 personality registered for level 0
[  693.564013] raid0: looking at sdg
[  693.564022] raid0:   comparing sdg(1953524736)
[  693.564027]  with sdg(1953524736)
[  693.564032] raid0:   END
[  693.564035] raid0:   ==> UNIQUE
[  693.564039] raid0: 1 zones
[  693.564044] raid0: looking at sdf
[  693.564048] raid0:   comparing sdf(1953524736)
[  693.564053]  with sdg(1953524736)
[  693.564056] raid0:   EQUAL
[  693.564060] raid0: looking at sde
[  693.564064] raid0:   comparing sde(1953524736)
[  693.564068]  with sdg(1953524736)
[  693.564072] raid0:   EQUAL
[  693.564075] raid0: looking at sdd
[  693.564079] raid0:   comparing sdd(1953524736)
[  693.564083]  with sdg(1953524736)
[  693.564087] raid0:   EQUAL
[  693.564090] raid0: looking at sdc
[  693.564094] raid0:   comparing sdc(1953524736)
[  693.564099]  with sdg(1953524736)
[  693.564102] raid0:   EQUAL
[  693.564106] raid0: FINAL 1 zones
[  693.564113] raid0: done.
[  693.564117] raid0 : md_size is 9767623680 sectors.
[  693.564122] ******* md0 configuration *********
[  693.564126] zone0=[sdc/sdd/sde/sdf/sdg/]
[  693.564140]         zone offset=0kb device offset=0kb size=4883811840kb
[  693.564144] **********************************
[  693.564147] 
[  693.564178] md0: detected capacity change from 0 to 5001023324160
[  693.568346]  md0: unknown partition table
[  700.335997] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[  700.346528] SGI XFS Quota Management subsystem
[  700.347214] Filesystem "md0": Disabling barriers, trial barrier write failed
[  700.347647] XFS mounting filesystem md0
[  730.695553] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  730.695562] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  730.695579] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  730.695585] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  730.695593] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  730.695599] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  730.695607] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  730.695612] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  730.695620] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  730.695625] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  761.695183] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  761.695193] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  761.695210] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  761.695216] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  761.695225] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  761.695231] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  761.695240] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  761.695245] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  761.695261] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  761.695267] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  792.695233] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  792.695243] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  792.695260] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  792.695266] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  792.695274] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  792.695279] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  792.695287] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  792.695292] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  792.695300] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  792.695305] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  823.695392] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  823.695395] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  823.695402] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  823.695404] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  823.695406] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  823.695408] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  823.695411] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  823.695413] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  823.695416] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  823.695417] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  840.574235] INFO: task mount:4459 blocked for more than 120 seconds.
[  840.574243] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  840.574250] mount         D 0000000000000000     0  4459   3005 0x00000000
[  840.574278]  ffff88012fb717e0 0000000000000082 0000000000000000 ffff8800b4e4b000
[  840.574303]  0000005100000002 ffff8800ce28c000 00000000000108a0 ffff8800ce28dfd8
[  840.574325]  ffff88012d6cd860 ffff88012d6cdb68 000000032b874000 ffffffffa00b44fc
[  840.574347] Call Trace:
[  840.574395]  [<ffffffffa00b44fc>] ? __ata_scsi_queuecmd+0x185/0x1dc [libata]
[  840.574424]  [<ffffffff81305f56>] ? _spin_lock_irq+0x15/0x31
[  840.574442]  [<ffffffff81304eee>] ? schedule_timeout+0x1e/0xb8
[  840.574458]  [<ffffffff81179f84>] ? blk_peek_request+0x1a6/0x1ba
[  840.574484]  [<ffffffffa002cbcf>] ? scsi_dispatch_cmd+0x1cf/0x23c [scsi_mod]
[  840.574500]  [<ffffffff813042d1>] ? wait_for_common+0xcf/0x13d
[  840.574515]  [<ffffffff81045db6>] ? default_wake_function+0x0/0x9
[  840.574529]  [<ffffffff81305f56>] ? _spin_lock_irq+0x15/0x31
[  840.574581]  [<ffffffffa04a2773>] ? xfs_buf_iowait+0x27/0x30 [xfs]
[  840.574627]  [<ffffffffa0492879>] ? xlog_bread_noalign+0xb1/0xd8 [xfs]
[  840.574674]  [<ffffffffa04928c2>] ? xlog_bread+0x22/0x4a [xfs]
[  840.574721]  [<ffffffffa0494a28>] ? xlog_find_verify_log_record+0x7a/0x1b1 [xfs]
[  840.574768]  [<ffffffffa04928d9>] ? xlog_bread+0x39/0x4a [xfs]
[  840.574815]  [<ffffffffa0494cd8>] ? xlog_find_zeroed+0x179/0x1b6 [xfs]
[  840.574865]  [<ffffffffa0494d38>] ? xlog_find_head+0x23/0x2bc [xfs]
[  840.574881]  [<ffffffff81049ce9>] ? check_preempt_wakeup+0x1ee/0x234
[  840.574896]  [<ffffffff81017298>] ? native_sched_clock+0x34/0x5e
[  840.574944]  [<ffffffffa0495381>] ? xlog_find_tail+0x27/0x30e [xfs]
[  840.574992]  [<ffffffffa049567d>] ? xlog_recover+0x15/0x84 [xfs]
[  840.575044]  [<ffffffffa0490f54>] ? xfs_log_mount+0xd4/0x131 [xfs]
[  840.575091]  [<ffffffffa049797b>] ? xfs_mountfs+0x2d9/0x5c7 [xfs]
[  840.575136]  [<ffffffffa04a075f>] ? kmem_zalloc+0xd/0x28 [xfs]
[  840.575183]  [<ffffffffa0498654>] ? xfs_mru_cache_create+0x111/0x14c [xfs]
[  840.575228]  [<ffffffffa04a96e0>] ? xfs_fs_fill_super+0x206/0x365 [xfs]
[  840.575244]  [<ffffffff810f0795>] ? get_sb_bdev+0x125/0x16d
[  840.575300]  [<ffffffffa04a94da>] ? xfs_fs_fill_super+0x0/0x365 [xfs]
[  840.575316]  [<ffffffff810f03ad>] ? vfs_kern_mount+0x99/0x14a
[  840.575331]  [<ffffffff810f04b1>] ? do_kern_mount+0x43/0xe1
[  840.575346]  [<ffffffff81104987>] ? do_mount+0x743/0x7ab
[  840.575361]  [<ffffffff81104a6f>] ? sys_mount+0x80/0xbd
[  840.575375]  [<ffffffff81010ac2>] ? system_call_fastpath+0x16/0x1b
[  854.695189] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  854.695199] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  854.695215] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  854.695221] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  854.695229] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  854.695235] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  854.695243] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  854.695249] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  854.695256] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  854.695262] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  885.695193] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  885.695202] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  885.695219] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  885.695225] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  885.695233] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  885.695239] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  885.695247] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  885.695252] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  885.695260] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
[  885.695265] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
[  885.695289] sd 0:0:0:0: [sdc] Unhandled error code
[  885.695296] sd 0:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  885.695304] sd 0:0:0:0: [sdc] CDB: Read(10): 28 00 3a 3d 0c 00 00 04 00 00
[  885.695326] end_request: I/O error, dev sdc, sector 977079296
[  885.695360] sd 0:0:1:0: [sdd] Unhandled error code
[  885.695365] sd 0:0:1:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  885.695372] sd 0:0:1:0: [sdd] CDB: Read(10): 28 00 3a 3d 0e 00 00 02 00 00
[  885.695407] end_request: I/O error, dev sdd, sector 977079808
[  885.695427] sd 0:0:2:0: [sde] Unhandled error code
[  885.695440] sd 0:0:2:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  885.695454] sd 0:0:2:0: [sde] CDB: Read(10): 28 00 3a 3d 0c 00 00 02 00 00
[  885.695500] end_request: I/O error, dev sde, sector 977079296
[  885.695524] sd 0:0:3:0: [sdf] Unhandled error code
[  885.695532] sd 0:0:3:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  885.695544] sd 0:0:3:0: [sdf] CDB: Read(10): 28 00 3a 3d 0c 00 00 02 00 00
[  885.695590] end_request: I/O error, dev sdf, sector 977079296
[  885.695614] sd 0:0:4:0: [sdg] Unhandled error code
[  885.695622] sd 0:0:4:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  885.695635] sd 0:0:4:0: [sdg] CDB: Read(10): 28 00 3a 3d 0a 00 00 04 00 00
[  885.695684] end_request: I/O error, dev sdg, sector 977078784
[  885.695805] I/O error in filesystem ("md0") meta-data dev md0 block 0x123313a00       ("xlog_bread") error 5 buf count 2097152
[  885.696108] XFS: empty log check failed
[  885.696115] XFS: log mount/recovery failed: error 5
[  885.696670] XFS: log mount failed

--Boundary-00=_gX3zKjTcxl9dw6G--
