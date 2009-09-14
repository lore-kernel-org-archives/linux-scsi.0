From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 15:13:33 -0600
Message-ID: <200909141513.33381.tfjellstrom@shaw.ca>
References: <4A950FA6.4020408@redhat.com> <200909071726.56432.tfjellstrom@shaw.ca> <4AADF4E2.9030407@kernel.org>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9HrrKUgLMfchoQa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:7330 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZINVNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 17:13:34 -0400
In-Reply-To: <4AADF4E2.9030407@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

--Boundary-00=_9HrrKUgLMfchoQa
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Mon September 14 2009, Tejun Heo wrote:
> Hello,
> 
> Thomas Fjellstrom wrote:
> > I have the same issue with a single WD 2TB Green drive. Technically two,
> > but it always only gets errors from the same drive, so I was assuming it
> > was the drive. I only have to setup the raid0 array, and put some light
> > load on it for the kernel to start complaining, and eventually it just
> > kicks the drive completely with the following messages:
> >
> > sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> > end_request: I/O error, dev sdb, sector 202026972
> >
> > The drive does work fine prior to the frozen timeout errors. And I was
> > using it in windows (same raid0 config) just fine with no errors what so
> > ever.
> 
> Can you post full dmesg output?  The above doesn't tell much about ATA
> side of things.
> 
> Thanks.
> 

Sure, I've attached the full dmesg from a full test I ran today (I couldn't 
find the old log where that bit came from). I'm running 2.6.31-rc9 right now, 
and will probably update to the final 31 release soonish. The test I ran 
actually finished (dd if=/dev/sdc of=/dev/null bs=8M), whereas with earlier 
kernels it was completely failing. Of course, I was actually trying to bring 
up the md raid0 array (2x2TB), mount the filesystem, and copy the files off 
before. mdraid is probably more sensitive to the end_request errors than dd 
is.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca

--Boundary-00=_9HrrKUgLMfchoQa
Content-Type: text/plain;
  charset="UTF-8";
  name="disk.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="disk.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc9 (root@natasha) (gcc version 4.3.4 (Debian 4.3.4-2) ) #2 SMP Wed Sep 9 08:08:59 MDT 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.31-rc9 root=UUID=272a1709-267d-4134-a6b4-e8d3884dca37 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
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
[    0.000000] RAMDISK: 376f1000 - 37fefd50
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
[    0.000000]   #2 [0001000000 - 0001623dac]    TEXT DATA BSS ==> [0001000000 - 0001623dac]
[    0.000000]   #3 [00376f1000 - 0037fefd50]          RAMDISK ==> [00376f1000 - 0037fefd50]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #5 [0001624000 - 0001624106]              BRK ==> [0001624000 - 0001624106]
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
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cfde0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1047935
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3841 pages, LIFO batch:0
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
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
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
[    0.000000] PERCPU: Embedded 29 pages at ffff880028022000, static data 86368 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030809
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.31-rc9 root=UUID=272a1709-267d-4134-a6b4-e8d3884dca37 ro
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
[    0.000000] Memory: 4050584k/4980736k available (2944k kernel code, 788996k absent, 141156k reserved, 1640k data, 584k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2611.766 MHz processor.
[    0.000010] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] hpet clockevent registered
[    0.004000]   alloc irq_desc for 24 on node 0
[    0.004000]   alloc kstat_irqs on node 0
[    0.004000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 5223.52 BogoMIPS (lpj=10447048)
[    0.004169] Security Framework initialized
[    0.004225] SELinux:  Disabled at boot.
[    0.004502] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.005671] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.006221] Mount-cache hash table entries: 256
[    0.006374] Initializing cgroup subsys ns
[    0.006429] Initializing cgroup subsys cpuacct
[    0.006485] Initializing cgroup subsys devices
[    0.006539] Initializing cgroup subsys freezer
[    0.006595] Initializing cgroup subsys net_cls
[    0.006665] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.006722] CPU: L2 Cache: 512K (64 bytes/line)
[    0.006778] CPU 0/0x0 -> Node 0
[    0.006832] tseg: 00cfe00000
[    0.006833] CPU: Physical Processor ID: 0
[    0.006887] CPU: Processor Core ID: 0
[    0.006941] mce: CPU supports 6 MCE banks
[    0.007000] using C1E aware idle routine
[    0.007054] Performance Counters: AMD PMU driver.
[    0.007151] ... version:                 0
[    0.007205] ... bit width:               48
[    0.007258] ... generic counters:        4
[    0.007312] ... value mask:              0000ffffffffffff
[    0.007367] ... max period:              00007fffffffffff
[    0.007423] ... fixed-purpose counters:  0
[    0.007476] ... counter mask:            000000000000000f
[    0.008232] ACPI: Core revision 20090521
[    0.020059] Setting APIC routing to flat
[    0.020593] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.062906] CPU0: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.064001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5223.83 BogoMIPS (lpj=10447671)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.148742] CPU1: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.149373] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.152017] System has AMD C1E enabled
[    0.152067] Booting processor 2 APIC 0x2 ip 0x6000
[    0.152140] Switch to broadcast mode on CPU1
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 5223.82 BogoMIPS (lpj=10447655)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 2/0x2 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.244673] CPU2: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.245304] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.248018] Switch to broadcast mode on CPU2
[    0.248073] Booting processor 3 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 5223.83 BogoMIPS (lpj=10447677)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 3/0x3 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.340711] CPU3: AMD Phenom(tm) II X4 810 Processor stepping 02
[    0.341341] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.344022] Brought up 4 CPUs
[    0.344022] Switch to broadcast mode on CPU3
[    0.344129] Total of 4 processors activated (20895.02 BogoMIPS).
[    0.344293] CPU0 attaching sched-domain:
[    0.344295]  domain 0: span 0-3 level MC
[    0.344297]   groups: 0 1 2 3
[    0.344302] CPU1 attaching sched-domain:
[    0.344304]  domain 0: span 0-3 level MC
[    0.344305]   groups: 1 2 3 0
[    0.344309] CPU2 attaching sched-domain:
[    0.344310]  domain 0: span 0-3 level MC
[    0.344312]   groups: 2 3 0 1
[    0.344316] CPU3 attaching sched-domain:
[    0.344317]  domain 0: span 0-3 level MC
[    0.344318]   groups: 3 0 1 2
[    0.344381] Switch to broadcast mode on CPU0
[    0.344381] Booting paravirtualized kernel on bare hardware
[    0.344381] regulator: core version 0.5
[    0.344381] NET: Registered protocol family 16
[    0.344381] node 0 link 0: io port [a000, ffff]
[    0.344381] TOM: 00000000d0000000 aka 3328M
[    0.344381] Fam 10h mmconf [e0000000, e00fffff]
[    0.344381] node 0 link 0: mmio [a0000, bffff]
[    0.344381] node 0 link 0: mmio [d0000000, dfffffff]
[    0.344381] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.344381] node 0 link 0: mmio [e0000000, e05fffff] ==> [e0100000, e05fffff]
[    0.344381] TOM2: 0000000130000000 aka 4864M
[    0.344381] bus: [00,05] on node 0 link 0
[    0.344381] bus: 00 index 0 io port: [0, ffff]
[    0.344381] bus: 00 index 1 mmio: [a0000, bffff]
[    0.344381] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.344381] bus: 00 index 3 mmio: [e0600000, ffffffff]
[    0.344381] bus: 00 index 4 mmio: [e0100000, e05fffff]
[    0.344381] bus: 00 index 5 mmio: [130000000, fcffffffff]
[    0.344381] ACPI: bus type pci registered
[    0.344381] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.344381] PCI: MCFG area at e0000000 reserved in E820
[    0.351426] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.351482] PCI: Using configuration type 1 for base access
[    0.352108] bio: create slab <bio-0> at 0
[    0.352322] ACPI: EC: Look up EC in DSDT
[    0.360448] ACPI: Interpreter enabled
[    0.360505] ACPI: (supports S0 S3 S4 S5)
[    0.360739] ACPI: Using IOAPIC for interrupt routing
[    0.364369] ACPI: No dock devices found.
[    0.364369] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.364394] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.364394] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.364394] pci 0000:00:02.0: PME# disabled
[    0.364394] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.364394] pci 0000:00:07.0: PME# disabled
[    0.364394] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.364394] pci 0000:00:09.0: PME# disabled
[    0.364468] pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
[    0.364525] pci 0000:00:0b.0: PME# disabled
[    0.364620] pci 0000:00:11.0: reg 10 io port: [0xff00-0xff07]
[    0.364627] pci 0000:00:11.0: reg 14 io port: [0xfe00-0xfe03]
[    0.364633] pci 0000:00:11.0: reg 18 io port: [0xfd00-0xfd07]
[    0.364639] pci 0000:00:11.0: reg 1c io port: [0xfc00-0xfc03]
[    0.364644] pci 0000:00:11.0: reg 20 io port: [0xfb00-0xfb0f]
[    0.364651] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
[    0.364698] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
[    0.364747] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.364813] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe02c000-0xfe02c0ff]
[    0.364860] pci 0000:00:12.2: supports D1 D2
[    0.364861] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.364919] pci 0000:00:12.2: PME# disabled
[    0.365001] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.365049] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.365115] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.365162] pci 0000:00:13.2: supports D1 D2
[    0.365163] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.365221] pci 0000:00:13.2: PME# disabled
[    0.365378] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.365384] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.365390] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.365396] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.365402] pci 0000:00:14.1: reg 20 io port: [0xfa00-0xfa0f]
[    0.365461] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
[    0.365500] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.365558] pci 0000:00:14.2: PME# disabled
[    0.365706] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe028000-0xfe028fff]
[    0.365823] pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.365831] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.365838] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.365843] pci 0000:01:00.0: reg 24 io port: [0xcf00-0xcf7f]
[    0.365848] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.365910] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.365912] pci 0000:00:02.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    0.365915] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.365946] pci 0000:02:00.0: reg 10 io port: [0xbe00-0xbeff]
[    0.365959] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdbff000-0xfdbfffff]
[    0.365969] pci 0000:02:00.0: reg 20 64bit mmio: [0xfdbf8000-0xfdbfbfff]
[    0.365975] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.366001] pci 0000:02:00.0: supports D1 D2
[    0.366003] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.366061] pci 0000:02:00.0: PME# disabled
[    0.368023] pci 0000:00:07.0: bridge io port: [0xb000-0xbfff]
[    0.368025] pci 0000:00:07.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
[    0.368028] pci 0000:00:07.0: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
[    0.368059] pci 0000:03:00.0: reg 10 io port: [0xee00-0xeeff]
[    0.368072] pci 0000:03:00.0: reg 18 64bit mmio: [0xfdfff000-0xfdffffff]
[    0.368082] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdff8000-0xfdffbfff]
[    0.368088] pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.368114] pci 0000:03:00.0: supports D1 D2
[    0.368115] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.368174] pci 0000:03:00.0: PME# disabled
[    0.368279] pci 0000:00:09.0: bridge io port: [0xe000-0xefff]
[    0.368282] pci 0000:00:09.0: bridge 32bit mmio: [0xfd800000-0xfd8fffff]
[    0.368285] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.368319] pci 0000:04:00.0: reg 18 io port: [0xdf00-0xdf7f]
[    0.368331] pci 0000:04:00.0: reg 20 64bit mmio: [0xfdef0000-0xfdefffff]
[    0.368336] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x03ffff]
[    0.368357] pci 0000:04:00.0: supports D1
[    0.368358] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.368415] pci 0000:04:00.0: PME# disabled
[    0.368513] pci 0000:00:0b.0: bridge io port: [0xd000-0xdfff]
[    0.368515] pci 0000:00:0b.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.368519] pci 0000:00:0b.0: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
[    0.368580] pci 0000:05:0e.0: reg 10 32bit mmio: [0xfdaff000-0xfdaff7ff]
[    0.368588] pci 0000:05:0e.0: reg 14 32bit mmio: [0xfdaf8000-0xfdafbfff]
[    0.368642] pci 0000:05:0e.0: supports D1 D2
[    0.368643] pci 0000:05:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.368702] pci 0000:05:0e.0: PME# disabled
[    0.368787] pci 0000:00:14.4: transparent bridge
[    0.368843] pci 0000:00:14.4: bridge io port: [0xa000-0xafff]
[    0.368847] pci 0000:00:14.4: bridge 32bit mmio: [0xfda00000-0xfdafffff]
[    0.368851] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfd900000-0xfd9fffff]
[    0.368866] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.369104] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.369176] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.369228] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.369274] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.369320] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEB._PRT]
[    0.388828] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.388828] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.389253] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.389846] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.392302] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.392895] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.393488] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.394081] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.394635] usbcore: registered new interface driver usbfs
[    0.394635] usbcore: registered new interface driver hub
[    0.394635] usbcore: registered new device driver usb
[    0.394635] PCI: Using ACPI for IRQ routing
[    0.394635] pci 0000:00:00.0: BAR 3: address space collision on of device [0xe0000000-0xffffffff]
[    0.394635] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.408117] PCI-DMA: Disabling AGP.
[    0.408215] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.408215] PCI-DMA: using GART IOMMU.
[    0.408215] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.409515] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.409780] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.416029] hpet: hpet2 irq 24 for MSI
[    0.452132] pnp: PnP ACPI init
[    0.452198] ACPI: bus type pnp registered
[    0.454894] pnp 00:0d: mem resource (0xd2c00-0xd3fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.454963] pnp 00:0d: mem resource (0xf0000-0xf7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.455032] pnp 00:0d: mem resource (0xf8000-0xfbfff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.455100] pnp 00:0d: mem resource (0xfc000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.455169] pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.455237] pnp 00:0d: mem resource (0x100000-0xcfddffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.455434] pnp: PnP ACPI: found 14 devices
[    0.455488] ACPI: ACPI bus type pnp unregistered
[    0.455549] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.455606] system 00:01: ioport range 0x220-0x225 has been reserved
[    0.455663] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.455723] system 00:02: ioport range 0x4100-0x411f has been reserved
[    0.455780] system 00:02: ioport range 0x228-0x22f has been reserved
[    0.455837] system 00:02: ioport range 0x40b-0x40b has been reserved
[    0.455893] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[    0.455950] system 00:02: ioport range 0xc00-0xc01 has been reserved
[    0.456010] system 00:02: ioport range 0xc14-0xc14 has been reserved
[    0.456067] system 00:02: ioport range 0xc50-0xc52 has been reserved
[    0.456123] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[    0.456180] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[    0.456237] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[    0.456293] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[    0.456350] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[    0.456407] system 00:02: ioport range 0x4000-0x40fe has been reserved
[    0.456463] system 00:02: ioport range 0x4210-0x4217 has been reserved
[    0.456520] system 00:02: ioport range 0xb00-0xb0f has been reserved
[    0.456577] system 00:02: ioport range 0xb10-0xb1f has been reserved
[    0.456634] system 00:02: ioport range 0xb20-0xb3f has been reserved
[    0.456694] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.456754] system 00:0d: iomem range 0xcfde0000-0xcfdfffff could not be reserved
[    0.456820] system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
[    0.456878] system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.456944] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.457001] system 00:0d: iomem range 0xfff80000-0xfffeffff has been reserved
[    0.462011] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.462068] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.462124] pci 0000:00:02.0:   MEM window: 0xf8000000-0xfbffffff
[    0.462181] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.462249] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.462306] pci 0000:00:07.0:   IO window: 0xb000-0xbfff
[    0.462362] pci 0000:00:07.0:   MEM window: 0xfdc00000-0xfdcfffff
[    0.462418] pci 0000:00:07.0:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
[    0.462486] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.462542] pci 0000:00:09.0:   IO window: 0xe000-0xefff
[    0.462598] pci 0000:00:09.0:   MEM window: 0xfd800000-0xfd8fffff
[    0.462655] pci 0000:00:09.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.462722] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    0.462778] pci 0000:00:0b.0:   IO window: 0xd000-0xdfff
[    0.462834] pci 0000:00:0b.0:   MEM window: 0xfde00000-0xfdefffff
[    0.462891] pci 0000:00:0b.0:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
[    0.462958] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.463015] pci 0000:00:14.4:   IO window: 0xa000-0xafff
[    0.463073] pci 0000:00:14.4:   MEM window: 0xfda00000-0xfdafffff
[    0.463131] pci 0000:00:14.4:   PREFETCH window: 0xfd900000-0xfd9fffff
[    0.463193]   alloc irq_desc for 18 on node 0
[    0.463194]   alloc kstat_irqs on node 0
[    0.463202] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.463260] pci 0000:00:02.0: setting latency timer to 64
[    0.463263]   alloc irq_desc for 19 on node 0
[    0.463265]   alloc kstat_irqs on node 0
[    0.463271] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.463328] pci 0000:00:07.0: setting latency timer to 64
[    0.463332]   alloc irq_desc for 17 on node 0
[    0.463333]   alloc kstat_irqs on node 0
[    0.463339] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.463396] pci 0000:00:09.0: setting latency timer to 64
[    0.463400] pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.463457] pci 0000:00:0b.0: setting latency timer to 64
[    0.463463] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.463465] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.463468] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.463469] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]
[    0.463471] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.463473] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.463475] pci_bus 0000:02: resource 1 mem: [0xfdc00000-0xfdcfffff]
[    0.463477] pci_bus 0000:02: resource 2 pref mem [0xfdb00000-0xfdbfffff]
[    0.463479] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.463481] pci_bus 0000:03: resource 1 mem: [0xfd800000-0xfd8fffff]
[    0.463483] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.463484] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.463486] pci_bus 0000:04: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.463488] pci_bus 0000:04: resource 2 pref mem [0xfdd00000-0xfddfffff]
[    0.463490] pci_bus 0000:05: resource 0 io:  [0xa000-0xafff]
[    0.463492] pci_bus 0000:05: resource 1 mem: [0xfda00000-0xfdafffff]
[    0.463494] pci_bus 0000:05: resource 2 pref mem [0xfd900000-0xfd9fffff]
[    0.463496] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.463497] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.463574] NET: Registered protocol family 2
[    0.463762] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.464653] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.466866] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.467186] TCP: Hash tables configured (established 524288 bind 65536)
[    0.467244] TCP reno registered
[    0.467414] NET: Registered protocol family 1
[    0.467510] Trying to unpack rootfs image as initramfs...
[    0.503895] Switched to high resolution mode on CPU 1
[    0.503898] Switched to high resolution mode on CPU 2
[    0.503902] Switched to high resolution mode on CPU 3
[    0.504022] Switched to high resolution mode on CPU 0
[    0.622475] Freeing initrd memory: 9211k freed
[    0.626162] audit: initializing netlink socket (disabled)
[    0.626228] type=2000 audit(1252917058.625:1): initialized
[    0.626578] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.626774] VFS: Disk quotas dquot_6.5.2
[    0.626854] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.626949] msgmni has been set to 7929
[    0.627155] alg: No test for stdrng (krng)
[    0.627258] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.627325] io scheduler noop registered
[    0.627378] io scheduler anticipatory registered
[    0.627433] io scheduler deadline registered
[    0.631821] io scheduler cfq registered (default)
[    0.772136] pci 0000:01:00.0: Boot video device
[    0.772281]   alloc irq_desc for 25 on node 0
[    0.772282]   alloc kstat_irqs on node 0
[    0.772289] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.772293] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.772410]   alloc irq_desc for 26 on node 0
[    0.772411]   alloc kstat_irqs on node 0
[    0.772415] pcieport-driver 0000:00:07.0: irq 26 for MSI/MSI-X
[    0.772419] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    0.772530]   alloc irq_desc for 27 on node 0
[    0.772531]   alloc kstat_irqs on node 0
[    0.772535] pcieport-driver 0000:00:09.0: irq 27 for MSI/MSI-X
[    0.772538] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.772647]   alloc irq_desc for 28 on node 0
[    0.772649]   alloc kstat_irqs on node 0
[    0.772652] pcieport-driver 0000:00:0b.0: irq 28 for MSI/MSI-X
[    0.772656] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    0.775299] Linux agpgart interface v0.103
[    0.775354] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.775527] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.775947] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.777464] brd: module loaded
[    0.777578] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.777793] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.777849] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.778023] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.778188] mice: PS/2 mouse device common for all mice
[    0.778293] rtc_cmos 00:05: RTC can wake from S4
[    0.778385] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.778471] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.778551] cpuidle: using governor ladder
[    0.778605] cpuidle: using governor menu
[    0.778662] No iBFT detected.
[    0.778974] TCP cubic registered
[    0.779082] NET: Registered protocol family 10
[    0.779485] lo: Disabled Privacy Extensions
[    0.779768] Mobile IPv6
[    0.779821] NET: Registered protocol family 17
[    0.780180] registered taskstats version 1
[    0.780381] rtc_cmos 00:05: setting system clock to 2009-09-14 08:30:59 UTC (1252917059)
[    0.780486] Freeing unused kernel memory: 584k freed
[    0.780679] Write protecting the kernel read-only data: 4000k
[    0.802581] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.882270] Floppy drive(s): fd0 is 1.44M
[    0.889776] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.889848] r8169 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.889950] r8169 0000:02:00.0: setting latency timer to 64
[    0.889980]   alloc irq_desc for 29 on node 0
[    0.889982]   alloc kstat_irqs on node 0
[    0.889992] r8169 0000:02:00.0: irq 29 for MSI/MSI-X
[    0.890429] eth0: RTL8168d/8111d at 0xffffc90000674000, 00:24:1d:18:f8:b2, XID 281000c0 IRQ 29
[    0.894212] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.894277] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.894352] r8169 0000:03:00.0: setting latency timer to 64
[    0.894380]   alloc irq_desc for 30 on node 0
[    0.894381]   alloc kstat_irqs on node 0
[    0.894389] r8169 0000:03:00.0: irq 30 for MSI/MSI-X
[    0.894818] eth1: RTL8168d/8111d at 0xffffc90000634000, 00:24:1d:18:f8:f3, XID 281000c0 IRQ 30
[    0.900291] FDC 0 is a post-1991 82077
[    0.902177] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.902409] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.902491] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.902600] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.902692] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    0.902772] ehci_hcd 0000:00:12.2: debug port 1
[    0.902847] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    0.903960] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.912020] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.912096] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.912153] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.912219] usb usb1: Product: EHCI Host Controller
[    0.912274] usb usb1: Manufacturer: Linux 2.6.31-rc9 ehci_hcd
[    0.912329] usb usb1: SerialNumber: 0000:00:12.2
[    0.912431] usb usb1: configuration #1 chosen from 1 choice
[    0.912516] hub 1-0:1.0: USB hub found
[    0.912577] hub 1-0:1.0: 6 ports detected
[    0.912732] SCSI subsystem initialized
[    0.917597]   alloc irq_desc for 16 on node 0
[    0.917600]   alloc kstat_irqs on node 0
[    0.917610] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.917695] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.917792] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 2
[    0.917892] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    0.918433] Uniform Multi-Platform E-IDE driver
[    0.928423] libata version 3.00 loaded.
[    0.945623]   alloc irq_desc for 22 on node 0
[    0.945626]   alloc kstat_irqs on node 0
[    0.945637] firewire_ohci 0000:05:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.945779] mvsas 0000:04:00.0: mvsas: driver version 0.8.2
[    0.945839] mvsas 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.945898] mvsas 0000:04:00.0: setting latency timer to 64
[    0.947342] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    0.988854] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.988914] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.988980] usb usb2: Product: OHCI Host Controller
[    0.989038] usb usb2: Manufacturer: Linux 2.6.31-rc9 ohci_hcd
[    0.989094] usb usb2: SerialNumber: 0000:00:12.0
[    0.989229] usb usb2: configuration #1 chosen from 1 choice
[    0.989329] hub 2-0:1.0: USB hub found
[    0.989390] hub 2-0:1.0: 3 ports detected
[    0.989627] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.989704] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.989789] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[    0.989874] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    0.989953] ehci_hcd 0000:00:13.2: debug port 1
[    0.990032] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    1.000114] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.000185] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.000241] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.000307] usb usb3: Product: EHCI Host Controller
[    1.000361] usb usb3: Manufacturer: Linux 2.6.31-rc9 ehci_hcd
[    1.000417] usb usb3: SerialNumber: 0000:00:13.2
[    1.000508] usb usb3: configuration #1 chosen from 1 choice
[    1.000585] hub 3-0:1.0: USB hub found
[    1.000644] hub 3-0:1.0: 6 ports detected
[    1.000977] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    1.001043] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.001122] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    1.001183]     ide0: BM-DMA at 0xfa00-0xfa07
[    1.001250] atiixp 0000:00:14.1: simplex device: DMA disabled
[    1.001305] ide1: DMA disabled
[    1.001367] Probing IDE interface ide0...
[    1.016139] firewire_ohci: Added fw-ohci device 0000:05:0e.0, OHCI version 1.10
[    1.460142] usb 2-3: new low speed USB device using ohci_hcd and address 2
[    1.517668] firewire_core: created device fw0: GUID 001a9c2c0000241d, S400
[    1.568143] Probing IDE interface ide1...
[    1.571122] ide1: no devices on the port
[    1.571212] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.571349] ide1 at 0x170-0x177,0x376 on irq 15
[    1.571658] ahci 0000:00:11.0: version 3.0
[    1.571671] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.571847] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.571914] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    1.572436] scsi1 : ahci
[    1.572648] scsi2 : ahci
[    1.572745] scsi3 : ahci
[    1.572838] scsi4 : ahci
[    1.572928] scsi5 : ahci
[    1.573022] scsi6 : ahci
[    1.573165] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    1.573232] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    1.573299] ata3: SATA max UDMA/133 irq_stat 0x00000040, connection status changed
[    1.573366] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    1.573432] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    1.573499] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    1.573652] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.573739] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.573838] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    1.573923] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    1.629951] usb 2-3: New USB device found, idVendor=046d, idProduct=c01d
[    1.630010] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.630067] usb 2-3: Product: USB-PS/2 Optical Mouse
[    1.630122] usb 2-3: Manufacturer: Logitech
[    1.630226] usb 2-3: configuration #1 chosen from 1 choice
[    1.632036] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.632095] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.632160] usb usb4: Product: OHCI Host Controller
[    1.632215] usb usb4: Manufacturer: Linux 2.6.31-rc9 ohci_hcd
[    1.632270] usb usb4: SerialNumber: 0000:00:12.1
[    1.632368] usb usb4: configuration #1 chosen from 1 choice
[    1.632448] hub 4-0:1.0: USB hub found
[    1.632514] hub 4-0:1.0: 3 ports detected
[    1.632679] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.632748] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.632830] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.632925] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    1.692106] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.692165] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.692230] usb usb5: Product: OHCI Host Controller
[    1.692284] usb usb5: Manufacturer: Linux 2.6.31-rc9 ohci_hcd
[    1.692340] usb usb5: SerialNumber: 0000:00:13.0
[    1.692434] usb usb5: configuration #1 chosen from 1 choice
[    1.692512] hub 5-0:1.0: USB hub found
[    1.692577] hub 5-0:1.0: 3 ports detected
[    1.692716] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.692784] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.692865] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    1.692947] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    1.752089] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.752145] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.756490] usb usb6: Product: OHCI Host Controller
[    1.756544] usb usb6: Manufacturer: Linux 2.6.31-rc9 ohci_hcd
[    1.756600] usb usb6: SerialNumber: 0000:00:13.1
[    1.756694] usb usb6: configuration #1 chosen from 1 choice
[    1.756766] hub 6-0:1.0: USB hub found
[    1.756826] hub 6-0:1.0: 3 ports detected
[    1.756971] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.757040] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.757119] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    1.757198] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    1.816089] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.816145] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.816211] usb usb7: Product: OHCI Host Controller
[    1.816265] usb usb7: Manufacturer: Linux 2.6.31-rc9 ohci_hcd
[    1.816321] usb usb7: SerialNumber: 0000:00:14.5
[    1.816409] usb usb7: configuration #1 chosen from 1 choice
[    1.816480] hub 7-0:1.0: USB hub found
[    1.816543] hub 7-0:1.0: 2 ports detected
[    1.893131] ata4: SATA link down (SStatus 0 SControl 300)
[    2.056108] ata6: softreset failed (device not ready)
[    2.056113] ata1: softreset failed (device not ready)
[    2.056116] ata1: applying SB600 PMP SRST workaround and retrying
[    2.056287] ata6: applying SB600 PMP SRST workaround and retrying
[    2.056357] ata5: softreset failed (device not ready)
[    2.056412] ata5: applying SB600 PMP SRST workaround and retrying
[    2.056481] ata2: softreset failed (device not ready)
[    2.056542] ata2: applying SB600 PMP SRST workaround and retrying
[    2.220149] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.220160] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.220186] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.220215] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.220802] ata1.00: ATA-7: OCZ-VERTEX v1.10, 1370, max UDMA/133
[    2.220862] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.221498] ata1.00: configured for UDMA/133
[    2.236190] scsi 1:0:0:0: Direct-Access     ATA      OCZ-VERTEX v1.10 1370 PQ: 0 ANSI: 5
[    2.247396] ata2.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    2.247452] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.262851] ata6.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    2.262908] ata6.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.267599] ata6.00: configured for UDMA/133
[    2.269157] ata5.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    2.269214] ata5.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.275112] ata5.00: configured for UDMA/133
[    2.287189] ata2.00: configured for UDMA/133
[    2.300128] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 PQ: 0 ANSI: 5
[    2.460125] ata3: softreset failed (device not ready)
[    2.460181] ata3: applying SB600 PMP SRST workaround and retrying
[    2.624127] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.625490] ata3.00: ATAPI: PIONEER DVD-RW  DVR-212D, 1.21, max UDMA/66
[    2.627143] ata3.00: configured for UDMA/66
[    2.654687] scsi 3:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-212D 1.21 PQ: 0 ANSI: 5
[    2.654856] scsi 5:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    2.654999] scsi 6:0:0:0: Direct-Access     ATA      WDC WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    2.658652] usbcore: registered new interface driver hiddev
[    2.664193] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb2/2-3/2-3:1.0/input/input2
[    2.664301] generic-usb 0003:046D:C01D.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:12.0-3/input0
[    2.664387] usbcore: registered new interface driver usbhid
[    2.664443] usbhid: v2.6:USB HID core driver
[    2.666178] sd 1:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    2.666261] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.666271] sd 1:0:0:0: [sda] Write Protect is off
[    2.666273] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.666285] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.666356]  sda:
[    2.666391] sd 5:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.666412] sd 5:0:0:0: [sdc] Write Protect is off
[    2.666414] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.666425] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.666486]  sdc: sda2
[    2.666765] sd 2:0:0:0: [sdb] Write Protect is off
[    2.666767] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.666778] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.666958] 
[    2.667084]  sdb:
[    2.667145] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.667159] sd 6:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.667180] sd 6:0:0:0: [sdd] Write Protect is off
[    2.667181] sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.667192] sd 6:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.667251]  sdd: sdb1 sdb2 sdb3 sdb4
[    2.685935] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    2.685994] Uniform CD-ROM driver Revision: 3.20
[    2.686124] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.700049] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    2.700118] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    2.706984] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.716510] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    2.716579] ldm_parse_tocblock(): Cannot find TOCBLOCK, database may be corrupt.
[    2.735845]  [LDM] sdc1
[    2.736224] sd 5:0:0:0: [sdc] Attached SCSI disk
[    2.749709]  [LDM] sdd1
[    2.750067] sd 6:0:0:0: [sdd] Attached SCSI disk
[    2.754121] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.754198] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.754271] sr 3:0:0:0: Attached scsi generic sg2 type 5
[    2.754343] sd 5:0:0:0: Attached scsi generic sg3 type 0
[    2.754416] sd 6:0:0:0: Attached scsi generic sg4 type 0
[    5.232112] drivers/scsi/mvsas/mv_sas.c 1214:port 0 attach dev info is 0
[    5.232115] drivers/scsi/mvsas/mv_sas.c 1216:port 0 attach sas addr is 0
[    5.336121] drivers/scsi/mvsas/mv_sas.c 1214:port 1 attach dev info is 0
[    5.336123] drivers/scsi/mvsas/mv_sas.c 1216:port 1 attach sas addr is 0
[    5.440126] drivers/scsi/mvsas/mv_sas.c 1214:port 2 attach dev info is 0
[    5.440127] drivers/scsi/mvsas/mv_sas.c 1216:port 2 attach sas addr is 0
[    5.544125] drivers/scsi/mvsas/mv_sas.c 1214:port 3 attach dev info is 0
[    5.544127] drivers/scsi/mvsas/mv_sas.c 1216:port 3 attach sas addr is 0
[    5.648111] drivers/scsi/mvsas/mv_sas.c 1214:port 4 attach dev info is 0
[    5.648112] drivers/scsi/mvsas/mv_sas.c 1216:port 4 attach sas addr is 0
[    5.752107] drivers/scsi/mvsas/mv_sas.c 1214:port 5 attach dev info is 0
[    5.752109] drivers/scsi/mvsas/mv_sas.c 1216:port 5 attach sas addr is 0
[    5.856105] drivers/scsi/mvsas/mv_sas.c 1214:port 6 attach dev info is 0
[    5.856107] drivers/scsi/mvsas/mv_sas.c 1216:port 6 attach sas addr is 0
[    5.960125] drivers/scsi/mvsas/mv_sas.c 1214:port 7 attach dev info is 0
[    5.960127] drivers/scsi/mvsas/mv_sas.c 1216:port 7 attach sas addr is 0
[    5.960132] scsi0 : mvsas
[    6.017934] device-mapper: uevent: version 1.0.3
[    6.018168] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    6.033567] kjournald starting.  Commit interval 5 seconds
[    6.033572] EXT3-fs: mounted filesystem with ordered data mode.
[    6.183525] udev: starting version 141
[    6.214940] processor LNXCPU:00: registered as cooling_device0
[    6.215029] processor LNXCPU:01: registered as cooling_device1
[    6.215113] processor LNXCPU:02: registered as cooling_device2
[    6.215196] processor LNXCPU:03: registered as cooling_device3
[    6.217051] ACPI: WMI: Mapper loaded
[    6.218023] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    6.218093] ACPI: Power Button [PWRF]
[    6.218193] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[    6.218260] ACPI: Power Button [PWRB]
[    6.224685] parport_pc 00:0a: reported by Plug and Play ACPI
[    6.224792] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.266109] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[    6.266180] ACPI: Device needs an ACPI driver
[    6.266250] piix4_smbus: probe of 0000:00:14.0 failed with error -16
[    6.268207] EDAC MC: Ver: 2.1.0 Sep  9 2009
[    6.274408] EDAC amd64_edac:  Ver: 3.2.0 Sep  9 2009
[    6.276436] EDAC amd64: This node reports that Memory ECC is currently disabled.
[    6.276504] EDAC amd64: bit 0x400000 in register F3x44 of the MISC_CONTROL device (0000:00:18.3) should be enabled
[    6.276573] EDAC amd64: WARNING: ECC is NOT currently enabled by the BIOS. Module will NOT be loaded.
[    6.276574]     Either Enable ECC in the BIOS, or use the 'ecc_enable_override' parameter.
[    6.276575]     Might be a BIOS bug, if BIOS says ECC is enabled
[    6.276576]     Use of the override can cause unknown side effects.
[    6.276835] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    6.361783] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.441160] hda_codec: Unknown model for ALC889A, trying auto-probe from BIOS...
[    6.441403] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input5
[    6.642244] Adding 8385920k swap on /dev/sdb4.  Priority:-1 extents:1 across:8385920k 
[    6.662562] EXT3 FS on sda2, internal journal
[    6.680895] loop: module loaded
[    6.699068] it87: Found IT8720F chip at 0x228, revision 5
[    6.699132] it87: in3 is VCC (+5V)
[    7.024976] kjournald starting.  Commit interval 5 seconds
[    7.025418] EXT3 FS on sdb3, internal journal
[    7.025523] EXT3-fs: mounted filesystem with ordered data mode.
[    7.135226] Bridge firewalling registered
[    7.137827] device eth0 entered promiscuous mode
[    7.138843] r8169: eth0: link up
[    7.138901] r8169: eth0: link up
[    7.140606] br0: port 1(eth0) entering learning state
[   17.716140] br0: no IPv6 routers present
[   17.944120] eth0: no IPv6 routers present
[   22.140134] br0: port 1(eth0) entering forwarding state
[   35.456274] RPC: Registered udp transport module.
[   35.456340] RPC: Registered tcp transport module.
[   35.466800] Slow work thread pool: Starting up
[   35.467033] Slow work thread pool: Ready
[   35.467121] FS-Cache: Loaded
[   35.485760] FS-Cache: Netfs 'nfs' registered for caching
[   35.497079] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   35.686894] svc: failed to register lockdv1 RPC service (errno 97).
[   36.015021] kvm: Nested Paging enabled
[   36.048120] powernow-k8: Found 1 AMD Phenom(tm) II X4 810 Processor processors (4 cpu cores) (version 2.20.00)
[   36.048156] powernow-k8:    0 : pstate 0 (2600 MHz)
[   36.048157] powernow-k8:    1 : pstate 1 (1900 MHz)
[   36.048159] powernow-k8:    2 : pstate 2 (1400 MHz)
[   36.048160] powernow-k8:    3 : pstate 3 (800 MHz)
[   46.962610] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   46.966004] NFSD: starting 90-second grace period
[   47.073495] lo: Disabled Privacy Extensions
[   47.074913] process `upsagentd' is using obsolete setsockopt SO_BSDCOMPAT
[  214.276612] CE: hpet increasing min_delta_ns to 15000 nsec
[ 7089.781711] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 7089.781731] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 7089.781735]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 7089.781742] ata5.00: status: { DRDY }
[ 7089.781754] ata5: hard resetting link
[ 7090.264636] ata5: softreset failed (device not ready)
[ 7090.264646] ata5: applying SB600 PMP SRST workaround and retrying
[ 7090.429567] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 7090.441356] ata5.00: configured for UDMA/133
[ 7090.441384] ata5: EH complete
[ 7809.252040] CE: hpet increasing min_delta_ns to 22500 nsec
[ 8001.781161] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 8001.781181] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 8001.781184]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 8001.781192] ata5.00: status: { DRDY }
[ 8001.781204] ata5: hard resetting link
[ 8002.264696] ata5: softreset failed (device not ready)
[ 8002.264706] ata5: applying SB600 PMP SRST workaround and retrying
[ 8002.429687] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8002.442233] ata5.00: configured for UDMA/133
[ 8002.442261] ata5: EH complete
[ 8009.781719] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 8009.781739] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 8009.781743]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 8009.781750] ata5.00: status: { DRDY }
[ 8009.781762] ata5: hard resetting link
[ 8010.265634] ata5: softreset failed (device not ready)
[ 8010.265644] ata5: applying SB600 PMP SRST workaround and retrying
[ 8010.429655] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8010.441260] ata5.00: configured for UDMA/133
[ 8010.441285] ata5: EH complete
[ 8071.816076] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 8071.816096] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 8071.816100]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 (timeout)
[ 8071.816108] ata5.00: status: { DRDY }
[ 8071.816120] ata5: hard resetting link
[ 8072.301610] ata5: softreset failed (device not ready)
[ 8072.301620] ata5: applying SB600 PMP SRST workaround and retrying
[ 8072.465653] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8072.477309] ata5.00: configured for UDMA/133
[ 8072.477340] ata5: EH complete
[ 8079.816153] ata5.00: NCQ disabled due to excessive errors
[ 8079.816166] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 8079.816184] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 8079.816187]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 8079.816194] ata5.00: status: { DRDY }
[ 8079.816206] ata5: hard resetting link
[ 8080.301526] ata5: softreset failed (device not ready)
[ 8080.301536] ata5: applying SB600 PMP SRST workaround and retrying
[ 8080.465648] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 8080.477386] ata5.00: configured for UDMA/133
[ 8080.477409] ata5: EH complete
[ 9121.781750] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 9121.781770] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 9121.781773]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 9121.781781] ata5.00: status: { DRDY }
[ 9121.781793] ata5: hard resetting link
[ 9122.265633] ata5: softreset failed (device not ready)
[ 9122.265643] ata5: applying SB600 PMP SRST workaround and retrying
[ 9122.429644] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 9122.442072] ata5.00: configured for UDMA/133
[ 9122.442097] ata5: EH complete
[ 9129.782278] ata5: limiting SATA link speed to 1.5 Gbps
[ 9129.782290] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 9129.782308] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 9129.782311]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 9129.782318] ata5.00: status: { DRDY }
[ 9129.782330] ata5: hard resetting link
[ 9130.321162] ata5: softreset failed (device not ready)
[ 9130.321172] ata5: applying SB600 PMP SRST workaround and retrying
[ 9130.485644] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 9130.497280] ata5.00: configured for UDMA/133
[ 9130.497304] ata5: EH complete
[10465.781851] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[10465.781871] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[10465.781874]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[10465.781882] ata5.00: status: { DRDY }
[10465.781894] ata5: hard resetting link
[10466.265656] ata5: softreset failed (device not ready)
[10466.265666] ata5: applying SB600 PMP SRST workaround and retrying
[10466.429585] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10466.441756] ata5.00: configured for UDMA/133
[10466.441789] ata5: EH complete
[10941.793179] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[10941.793200] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[10941.793203]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[10941.793210] ata5.00: status: { DRDY }
[10941.793222] ata5: hard resetting link
[10942.276163] ata5: softreset failed (device not ready)
[10942.276174] ata5: applying SB600 PMP SRST workaround and retrying
[10942.441223] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10942.452976] ata5.00: configured for UDMA/133
[10942.453008] ata5: EH complete
[10949.792075] ata5.00: limiting speed to UDMA/100:PIO4
[10949.792088] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[10949.792106] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[10949.792109]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[10949.792116] ata5.00: status: { DRDY }
[10949.792128] ata5: hard resetting link
[10950.277640] ata5: softreset failed (device not ready)
[10950.277650] ata5: applying SB600 PMP SRST workaround and retrying
[10950.441151] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[10950.453294] ata5.00: configured for UDMA/100
[10950.453326] ata5: EH complete
[12271.781785] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[12271.781806] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[12271.781809]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[12271.781816] ata5.00: status: { DRDY }
[12271.781828] ata5: hard resetting link
[12272.265692] ata5: softreset failed (device not ready)
[12272.265703] ata5: applying SB600 PMP SRST workaround and retrying
[12272.428666] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[12272.441979] ata5.00: configured for UDMA/100
[12272.442005] ata5: EH complete
[12279.781569] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[12279.781590] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[12279.781593]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[12279.781601] ata5.00: status: { DRDY }
[12279.781612] ata5: hard resetting link
[12280.265637] ata5: softreset failed (device not ready)
[12280.265648] ata5: applying SB600 PMP SRST workaround and retrying
[12280.428152] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[12280.439793] ata5.00: configured for UDMA/100
[12280.439818] ata5: EH complete
[13335.780697] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[13335.780718] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[13335.780721]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[13335.780729] ata5.00: status: { DRDY }
[13335.780741] ata5: hard resetting link
[13336.264164] ata5: softreset failed (device not ready)
[13336.264175] ata5: applying SB600 PMP SRST workaround and retrying
[13336.428082] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[13336.440215] ata5.00: configured for UDMA/100
[13336.440246] ata5: EH complete
[15688.781367] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[15688.781387] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[15688.781390]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[15688.781397] ata5.00: status: { DRDY }
[15688.781409] ata5: hard resetting link
[15689.264667] ata5: softreset failed (device not ready)
[15689.264677] ata5: applying SB600 PMP SRST workaround and retrying
[15689.429174] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[15689.440882] ata5.00: configured for UDMA/100
[15689.440910] ata5: EH complete
[15696.780404] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[15696.780424] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[15696.780428]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[15696.780435] ata5.00: status: { DRDY }
[15696.780447] ata5: hard resetting link
[15697.376681] ata5: softreset failed (device not ready)
[15697.376692] ata5: applying SB600 PMP SRST workaround and retrying
[15697.541562] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[15697.554171] ata5.00: configured for UDMA/100
[15697.554197] ata5: EH complete
[16694.781727] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[16694.781747] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[16694.781751]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[16694.781758] ata5.00: status: { DRDY }
[16694.781770] ata5: hard resetting link
[16695.265197] ata5: softreset failed (device not ready)
[16695.265208] ata5: applying SB600 PMP SRST workaround and retrying
[16695.428306] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[16695.440848] ata5.00: configured for UDMA/100
[16695.440874] ata5: EH complete
[16702.781522] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[16702.781529] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[16702.781530]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[16702.781533] ata5.00: status: { DRDY }
[16702.781537] ata5: hard resetting link
[16703.264389] ata5: softreset failed (device not ready)
[16703.264399] ata5: applying SB600 PMP SRST workaround and retrying
[16703.430387] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[16703.442092] ata5.00: configured for UDMA/100
[16703.442119] ata5: EH complete
[17317.818447] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[17317.818468] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[17317.818471]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[17317.818479] ata5.00: status: { DRDY }
[17317.818491] ata5: hard resetting link
[17318.301567] ata5: softreset failed (device not ready)
[17318.301578] ata5: applying SB600 PMP SRST workaround and retrying
[17318.465688] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17318.477730] ata5.00: configured for UDMA/100
[17318.477768] ata5: EH complete
[17325.816252] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[17325.816273] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[17325.816276]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[17325.816283] ata5.00: status: { DRDY }
[17325.816295] ata5: hard resetting link
[17326.413099] ata5: softreset failed (device not ready)
[17326.413109] ata5: applying SB600 PMP SRST workaround and retrying
[17326.577169] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17326.589045] ata5.00: configured for UDMA/100
[17326.589072] ata5: EH complete
[17669.793632] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[17669.793653] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[17669.793656]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[17669.793663] ata5.00: status: { DRDY }
[17669.793675] ata5: hard resetting link
[17670.557535] ata5: softreset failed (device not ready)
[17670.557545] ata5: applying SB600 PMP SRST workaround and retrying
[17670.721646] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17670.734091] ata5.00: configured for UDMA/100
[17670.734122] ata5: EH complete
[17678.793718] ata5.00: limiting speed to UDMA/33:PIO4
[17678.793731] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[17678.793748] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[17678.793751]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[17678.793758] ata5.00: status: { DRDY }
[17678.793770] ata5: hard resetting link
[17679.277635] ata5: softreset failed (device not ready)
[17679.277645] ata5: applying SB600 PMP SRST workaround and retrying
[17679.441362] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17679.453900] ata5.00: configured for UDMA/33
[17679.453927] ata5: EH complete
[17949.781871] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[17949.781891] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[17949.781895]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[17949.781902] ata5.00: status: { DRDY }
[17949.781914] ata5: hard resetting link
[17950.266694] ata5: softreset failed (device not ready)
[17950.266705] ata5: applying SB600 PMP SRST workaround and retrying
[17950.428175] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17950.440744] ata5.00: configured for UDMA/33
[17950.440780] ata5: EH complete
[17957.781559] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[17957.781566] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[17957.781567]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[17957.781570] ata5.00: status: { DRDY }
[17957.781574] ata5: hard resetting link
[17958.321043] ata5: softreset failed (device not ready)
[17958.321053] ata5: applying SB600 PMP SRST workaround and retrying
[17958.485159] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17958.496978] ata5.00: configured for UDMA/33
[17958.497006] ata5: EH complete
[24850.780672] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[24850.780693] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[24850.780696]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[24850.780703] ata5.00: status: { DRDY }
[24850.780715] ata5: hard resetting link
[24851.264685] ata5: softreset failed (device not ready)
[24851.264695] ata5: applying SB600 PMP SRST workaround and retrying
[24851.428553] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[24851.440605] ata5.00: configured for UDMA/33
[24851.440634] ata5: EH complete
[25814.804655] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[25814.804675] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[25814.804679]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[25814.804686] ata5.00: status: { DRDY }
[25814.804698] ata5: hard resetting link
[25815.289583] ata5: softreset failed (device not ready)
[25815.289594] ata5: applying SB600 PMP SRST workaround and retrying
[25815.452425] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[25815.464619] ata5.00: configured for UDMA/33
[25815.464647] ata5: EH complete
[25830.793066] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[25830.793087] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[25830.793091]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 (timeout)
[25830.793099] ata5.00: status: { DRDY }
[25830.793111] ata5: hard resetting link
[25831.277634] ata5: softreset failed (device not ready)
[25831.277645] ata5: applying SB600 PMP SRST workaround and retrying
[25831.440651] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[25831.452987] ata5.00: configured for UDMA/33
[25831.453014] ata5: EH complete
[25970.816235] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[25970.816255] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[25970.816258]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[25970.816266] ata5.00: status: { DRDY }
[25970.816277] ata5: hard resetting link
[25971.300058] ata5: softreset failed (device not ready)
[25971.300069] ata5: applying SB600 PMP SRST workaround and retrying
[25971.464192] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[25971.475957] ata5.00: configured for UDMA/33
[25971.475995] ata5: EH complete
[28350.781651] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[28350.781671] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[28350.781675]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[28350.781682] ata5.00: status: { DRDY }
[28350.781694] ata5: hard resetting link
[28351.265634] ata5: softreset failed (device not ready)
[28351.265645] ata5: applying SB600 PMP SRST workaround and retrying
[28351.429718] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[28351.441421] ata5.00: configured for UDMA/33
[28351.441445] ata5: EH complete
[28964.793120] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[28964.793140] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[28964.793144]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[28964.793151] ata5.00: status: { DRDY }
[28964.793163] ata5: hard resetting link
[28965.276648] ata5: softreset failed (device not ready)
[28965.276659] ata5: applying SB600 PMP SRST workaround and retrying
[28965.440495] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[28965.452518] ata5.00: configured for UDMA/33
[28965.452543] ata5: EH complete
[28980.816343] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[28980.816364] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[28980.816368]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 (timeout)
[28980.816375] ata5.00: status: { DRDY }
[28980.816387] ata5: hard resetting link
[28981.300540] ata5: softreset failed (device not ready)
[28981.300551] ata5: applying SB600 PMP SRST workaround and retrying
[28981.465697] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[28981.477590] ata5.00: configured for UDMA/33
[28981.477622] ata5: EH complete
[29524.781659] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[29524.781680] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[29524.781683]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[29524.781691] ata5.00: status: { DRDY }
[29524.781703] ata5: hard resetting link
[29525.265541] ata5: softreset failed (device not ready)
[29525.265551] ata5: applying SB600 PMP SRST workaround and retrying
[29525.429661] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[29525.441658] ata5.00: configured for UDMA/33
[29525.441681] ata5: EH complete
[29540.781986] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[29540.782006] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[29540.782009]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 (timeout)
[29540.782016] ata5.00: status: { DRDY }
[29540.782028] ata5: hard resetting link
[29541.265537] ata5: softreset failed (device not ready)
[29541.265547] ata5: applying SB600 PMP SRST workaround and retrying
[29541.429586] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[29541.441953] ata5.00: configured for UDMA/33
[29541.441981] ata5: EH complete
[29594.781673] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[29594.781701] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[29594.781704]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[29594.781712] ata5.00: status: { DRDY }
[29594.781724] ata5: hard resetting link
[29595.264844] ata5: softreset failed (device not ready)
[29595.264854] ata5: applying SB600 PMP SRST workaround and retrying
[29595.429673] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[29595.441870] ata5.00: configured for UDMA/33
[29595.441896] ata5: EH complete
[29610.780196] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[29610.780216] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[29610.780219]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 (timeout)
[29610.780227] ata5.00: status: { DRDY }
[29610.780322] ata5: hard resetting link
[29611.265639] ata5: softreset failed (device not ready)
[29611.265649] ata5: applying SB600 PMP SRST workaround and retrying
[29611.428973] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[29611.441089] ata5.00: configured for UDMA/33
[29611.441116] ata5: EH complete
[30224.781660] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[30224.781680] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[30224.781684]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[30224.781699] ata5.00: status: { DRDY }
[30224.781711] ata5: hard resetting link
[30225.264347] ata5: softreset failed (device not ready)
[30225.264358] ata5: applying SB600 PMP SRST workaround and retrying
[30225.429672] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[30225.442540] ata5.00: configured for UDMA/33
[30225.442565] ata5: EH complete
[30240.781657] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[30240.781677] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[30240.781681]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 (timeout)
[30240.781688] ata5.00: status: { DRDY }
[30240.781724] ata5: hard resetting link
[30241.265197] ata5: softreset failed (device not ready)
[30241.265207] ata5: applying SB600 PMP SRST workaround and retrying
[30241.429542] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[30241.441297] ata5.00: configured for UDMA/33
[30241.441325] ata5: EH complete
[30310.781167] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[30310.781188] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[30310.781191]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[30310.781198] ata5.00: status: { DRDY }
[30310.781210] ata5: hard resetting link
[30311.264860] ata5: softreset failed (device not ready)
[30311.264871] ata5: applying SB600 PMP SRST workaround and retrying
[30311.429161] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[30311.441444] ata5.00: configured for UDMA/33
[30311.441471] ata5: EH complete
[32410.780220] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[32410.780240] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[32410.780243]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[32410.780251] ata5.00: status: { DRDY }
[32410.780262] ata5: hard resetting link
[32411.264544] ata5: softreset failed (device not ready)
[32411.264554] ata5: applying SB600 PMP SRST workaround and retrying
[32411.428072] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[32411.440112] ata5.00: configured for UDMA/33
[32411.440148] ata5: EH complete
[32452.781180] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[32452.781199] ata5.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
[32452.781202]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[32452.781209] ata5.00: status: { DRDY }
[32452.781221] ata5: hard resetting link
[32453.264154] ata5: softreset failed (device not ready)
[32453.264159] ata5: applying SB600 PMP SRST workaround and retrying
[32453.429666] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[32453.441734] ata5.00: configured for UDMA/33
[32453.441762] ata5: EH complete
[32464.106741] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[32464.106751] ata5.00: irq_stat 0x40000001
[32464.106769] ata5.00: cmd 25/00:08:00:88:e0/00:00:e8:00:00/e0 tag 0 dma 4096 in
[32464.106772]          res 41/04:00:00:88:e0/00:00:e8:00:00/e0 Emask 0x1 (device error)
[32464.106780] ata5.00: status: { DRDY ERR }
[32464.106785] ata5.00: error: { ABRT }
[32464.118623] ata5.00: configured for UDMA/33
[32464.118646] ata5: EH complete
[32473.430229] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[32473.430238] ata5.00: irq_stat 0x40000001
[32473.430257] ata5.00: cmd 25/00:08:00:88:e0/00:00:e8:00:00/e0 tag 0 dma 4096 in
[32473.430261]          res 41/04:00:00:88:e0/00:00:e8:00:00/e0 Emask 0x1 (device error)
[32473.430268] ata5.00: status: { DRDY ERR }
[32473.430273] ata5.00: error: { ABRT }
[32473.442098] ata5.00: configured for UDMA/33
[32473.442122] ata5: EH complete
[32482.753530] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[32482.753533] ata5.00: irq_stat 0x40000001
[32482.753539] ata5.00: cmd 25/00:08:00:88:e0/00:00:e8:00:00/e0 tag 0 dma 4096 in
[32482.753540]          res 41/04:00:00:88:e0/00:00:e8:00:00/e0 Emask 0x1 (device error)
[32482.753543] ata5.00: status: { DRDY ERR }
[32482.753544] ata5.00: error: { ABRT }
[32482.765387] ata5.00: configured for UDMA/33
[32482.765399] ata5: EH complete
[32492.076167] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[32492.076176] ata5.00: irq_stat 0x40000001
[32492.076195] ata5.00: cmd 25/00:08:00:88:e0/00:00:e8:00:00/e0 tag 0 dma 4096 in
[32492.076198]          res 41/04:00:00:88:e0/00:00:e8:00:00/e0 Emask 0x1 (device error)
[32492.076205] ata5.00: status: { DRDY ERR }
[32492.076210] ata5.00: error: { ABRT }
[32492.088032] ata5.00: configured for UDMA/33
[32492.088050] ata5: EH complete
[32501.394658] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[32501.394667] ata5.00: irq_stat 0x40000001
[32501.394685] ata5.00: cmd 25/00:08:00:88:e0/00:00:e8:00:00/e0 tag 0 dma 4096 in
[32501.394689]          res 41/04:00:00:88:e0/00:00:e8:00:00/e0 Emask 0x1 (device error)
[32501.394696] ata5.00: status: { DRDY ERR }
[32501.394701] ata5.00: error: { ABRT }
[32501.406494] ata5.00: configured for UDMA/33
[32501.406518] ata5: EH complete
[32510.718100] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[32510.718110] ata5.00: irq_stat 0x40000001
[32510.718128] ata5.00: cmd 25/00:08:00:88:e0/00:00:e8:00:00/e0 tag 0 dma 4096 in
[32510.718131]          res 41/04:00:00:88:e0/00:00:e8:00:00/e0 Emask 0x1 (device error)
[32510.718138] ata5.00: status: { DRDY ERR }
[32510.718143] ata5.00: error: { ABRT }
[32510.730017] ata5.00: configured for UDMA/33
[32510.730042] sd 5:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[32510.730050] sd 5:0:0:0: [sdc] Sense Key : Aborted Command [current] [descriptor]
[32510.730059] Descriptor sense data with sense descriptors (in hex):
[32510.730064]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[32510.730082]         e8 e0 88 00 
[32510.730090] sd 5:0:0:0: [sdc] Add. Sense: No additional sense information
[32510.730098] end_request: I/O error, dev sdc, sector 3907028992
[32510.730106] Buffer I/O error on device sdc, logical block 488378624
[32510.730142] ata5: EH complete
[32526.780076] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[32526.780097] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[32526.780100]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[32526.780107] ata5.00: status: { DRDY }
[32526.780119] ata5: hard resetting link
[32536.785177] ata5: softreset failed (device not ready)
[32536.785189] ata5: hard resetting link
[32546.789238] ata5: softreset failed (device not ready)
[32546.789249] ata5: hard resetting link
[32557.360064] ata5: link is slow to respond, please be patient (ready=0)
[32573.836192] ata5: softreset failed (device not ready)
[32573.836202] ata5: applying SB600 PMP SRST workaround and retrying
[32581.792026] ata5: softreset failed (device not ready)
[32581.792039] ata5: hard resetting link
[32587.000775] ata5: softreset failed (device not ready)
[32587.000784] ata5: reset failed, giving up
[32587.000790] ata5.00: disabled
[32587.000822] ata5: EH complete
[32587.000847] sd 5:0:0:0: [sdc] Unhandled error code
[32587.000852] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[32587.000860] end_request: I/O error, dev sdc, sector 3907028904
[32587.000868] Buffer I/O error on device sdc, logical block 488378613
[32587.000958] sd 5:0:0:0: [sdc] Unhandled error code
[32587.000967] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[32587.000987] end_request: I/O error, dev sdc, sector 3907028904
[32587.000995] Buffer I/O error on device sdc, logical block 488378613
[32587.001089] sd 5:0:0:0: [sdc] Unhandled error code
[32587.001093] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[32587.001100] end_request: I/O error, dev sdc, sector 3907029104
[32587.001106] Buffer I/O error on device sdc, logical block 488378638
[32587.001131] sd 5:0:0:0: [sdc] Unhandled error code
[32587.001136] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[32587.001142] end_request: I/O error, dev sdc, sector 3907029104
[32587.001147] Buffer I/O error on device sdc, logical block 488378638
[32587.001455] sd 5:0:0:0: [sdc] Unhandled error code
[32587.001460] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[32587.001467] end_request: I/O error, dev sdc, sector 512
[32587.001472] Buffer I/O error on device sdc, logical block 64
[34244.232569] sd 5:0:0:0: [sdc] Unhandled error code
[34244.232579] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[34244.232589] end_request: I/O error, dev sdc, sector 3907028904
[34244.232597] Buffer I/O error on device sdc, logical block 488378613
[34244.232645] sd 5:0:0:0: [sdc] Unhandled error code
[34244.232650] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[34244.232657] end_request: I/O error, dev sdc, sector 3907029104
[34244.232662] Buffer I/O error on device sdc, logical block 488378638
[34244.232954] sd 5:0:0:0: [sdc] Unhandled error code
[34244.232959] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[34244.232966] end_request: I/O error, dev sdc, sector 512
[34244.232972] Buffer I/O error on device sdc, logical block 64
[36044.818014] sd 5:0:0:0: [sdc] Unhandled error code
[36044.818023] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[36044.818033] end_request: I/O error, dev sdc, sector 3907028904
[36044.818040] Buffer I/O error on device sdc, logical block 488378613
[36044.818090] sd 5:0:0:0: [sdc] Unhandled error code
[36044.818095] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[36044.818102] end_request: I/O error, dev sdc, sector 3907029104
[36044.818108] Buffer I/O error on device sdc, logical block 488378638
[36044.818423] sd 5:0:0:0: [sdc] Unhandled error code
[36044.818428] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[36044.818435] end_request: I/O error, dev sdc, sector 512
[36044.818441] Buffer I/O error on device sdc, logical block 64
[37844.396933] sd 5:0:0:0: [sdc] Unhandled error code
[37844.396943] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[37844.396952] end_request: I/O error, dev sdc, sector 3907028904
[37844.396960] Buffer I/O error on device sdc, logical block 488378613
[37844.397052] sd 5:0:0:0: [sdc] Unhandled error code
[37844.397058] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[37844.397065] end_request: I/O error, dev sdc, sector 3907029104
[37844.397071] Buffer I/O error on device sdc, logical block 488378638
[37844.397398] sd 5:0:0:0: [sdc] Unhandled error code
[37844.397406] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[37844.397417] end_request: I/O error, dev sdc, sector 512
[37844.397425] Buffer I/O error on device sdc, logical block 64
[39644.622416] sd 5:0:0:0: [sdc] Unhandled error code
[39644.622420] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[39644.622423] end_request: I/O error, dev sdc, sector 3907028904
[39644.622426] Buffer I/O error on device sdc, logical block 488378613
[39644.622442] sd 5:0:0:0: [sdc] Unhandled error code
[39644.622443] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[39644.622445] end_request: I/O error, dev sdc, sector 3907029104
[39644.622447] Buffer I/O error on device sdc, logical block 488378638
[39644.622546] sd 5:0:0:0: [sdc] Unhandled error code
[39644.622547] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[39644.622549] end_request: I/O error, dev sdc, sector 512
[39644.622551] Buffer I/O error on device sdc, logical block 64
[41444.250375] sd 5:0:0:0: [sdc] Unhandled error code
[41444.250385] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[41444.250394] end_request: I/O error, dev sdc, sector 3907028904
[41444.250402] Buffer I/O error on device sdc, logical block 488378613
[41444.250451] sd 5:0:0:0: [sdc] Unhandled error code
[41444.250456] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[41444.250463] end_request: I/O error, dev sdc, sector 3907029104
[41444.250469] Buffer I/O error on device sdc, logical block 488378638
[41444.250792] sd 5:0:0:0: [sdc] Unhandled error code
[41444.250797] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[41444.250804] end_request: I/O error, dev sdc, sector 512
[41444.250809] Buffer I/O error on device sdc, logical block 64
[43244.870091] sd 5:0:0:0: [sdc] Unhandled error code
[43244.870100] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[43244.870110] end_request: I/O error, dev sdc, sector 3907028904
[43244.870118] Buffer I/O error on device sdc, logical block 488378613
[43244.870166] sd 5:0:0:0: [sdc] Unhandled error code
[43244.870171] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[43244.870178] end_request: I/O error, dev sdc, sector 3907029104
[43244.870184] Buffer I/O error on device sdc, logical block 488378638
[43244.870503] sd 5:0:0:0: [sdc] Unhandled error code
[43244.870508] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[43244.870515] end_request: I/O error, dev sdc, sector 512
[43244.870520] Buffer I/O error on device sdc, logical block 64
[45044.487645] sd 5:0:0:0: [sdc] Unhandled error code
[45044.487654] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[45044.487664] end_request: I/O error, dev sdc, sector 3907028904
[45044.487672] Buffer I/O error on device sdc, logical block 488378613
[45044.487720] sd 5:0:0:0: [sdc] Unhandled error code
[45044.487725] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[45044.487732] end_request: I/O error, dev sdc, sector 3907029104
[45044.487737] Buffer I/O error on device sdc, logical block 488378638
[45044.488020] sd 5:0:0:0: [sdc] Unhandled error code
[45044.488025] sd 5:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[45044.488032] end_request: I/O error, dev sdc, sector 512
[45044.488037] Buffer I/O error on device sdc, logical block 64

--Boundary-00=_9HrrKUgLMfchoQa--
