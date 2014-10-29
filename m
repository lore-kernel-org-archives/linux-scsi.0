From: Meelis Roos <mroos@linux.ee>
Subject: blk-mq problem on proliant DL380 G3 (cciss)
Date: Wed, 29 Oct 2014 12:47:06 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:35123 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228AbaJ2KrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 06:47:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>

I tried 3.18-rc2 with blk-mq default on on HP ProLiant DL380 G3 (with HP 
CCISS RAID controller). It fails late in the bootup with "task 
scsi_eh_1:720 blocked for more than 120 seconds." messages.

Booting with scsi_mod.use_blk_mq=0 fixes the problem.

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-dirty (mroos@dl380g3) (gcc version 4.9.1 (Debian 4.9.1-16) ) #22 SMP Tue Oct 28 22:00:58 EET 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fff9fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fffa000-0x000000007fffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.3 present.
[    0.000000] e820: last_pfn = 0x7fffa max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] total RAM covered: 2048M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 1  	lose cover RAM: 0G
[    0.000000] found SMP MP-table at [mem 0x000f4fd0-0x000f4fdf] mapped at [c00f4fd0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F4F70 000014 (v00 COMPAQ)
[    0.000000] ACPI: RSDT 0x7FFFA000 000030 (v01 COMPAQ P29      00000002 ?   0000162E)
[    0.000000] ACPI: FACP 0x7FFFA040 000074 (v01 COMPAQ P29      00000002 ?   0000162E)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140926/tbfadt-699)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1bControlBlock: 32, using default 16 (20140926/tbfadt-699)
[    0.000000] ACPI: DSDT 0x7FFFA240 003C44 (v01 COMPAQ DSDT     00000001 MSFT 0100000B)
[    0.000000] ACPI: FACS 0x7FFFA0C0 000040
[    0.000000] ACPI: APIC 0x7FFFA100 0000AC (v01 COMPAQ 00000083 00000002      00000000)
[    0.000000] ACPI: SPCR 0x7FFFA1C0 000050 (v01 COMPAQ SPCRRBSU 00000001 ?   0000162E)
[    0.000000] 1159MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x7fff9fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7fff9fff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x7fff9fff]
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x920
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec03000] gsi_base[48])
[    0.000000] IOAPIC[3]: apic_id 5, version 17, address 0xfec03000, GSI 48-63
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: 8 Processors exceeds NR_CPUS limit of 4
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x80000000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f67ba000 s28672 r0 d28672 u57344
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 522408
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc2-dirty root=/dev/cciss/c0d0p1 ro console=ttyS0,9600
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007fffa)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 2073352K/2096736K available (3591K kernel code, 302K rwdata, 1076K rodata, 372K init, 448K bss, 23384K reserved, 1187824K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc14de000 - 0xc153b000   ( 372 kB)
[    0.000000]       .data : 0xc1381fc6 - 0xc14dc900   (1386 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1381fc6   (3591 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:2304 nr_irqs:1024 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3187.464 MHz processor
[    0.012015] Calibrating delay loop (skipped), value calculated using timer frequency.. 6374.92 BogoMIPS (lpj=12749856)
[    0.020004] pid_max: default: 32768 minimum: 301
[    0.024011] ACPI: Core revision 20140926
[    0.035041] ACPI: All ACPI Tables successfully acquired
[    0.044205] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.048005] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.052297] Initializing cgroup subsys net_cls
[    0.056007] Initializing cgroup subsys blkio
[    0.060029] CPU: Physical Processor ID: 0
[    0.064003] CPU: Processor Core ID: 0
[    0.068009] mce: CPU supports 4 MCE banks
[    0.072013] CPU0: Thermal monitoring enabled (TM1)
[    0.076017] Last level iTLB entries: 4KB 64, 2MB 64, 4MB 64
[    0.076017] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 64, 1GB 0
[    0.080145] Freeing SMP alternatives memory: 20K (c153b000 - c1540000)
[    0.084119] Enabling APIC mode:  Flat.  Using 4 I/O APICs
[    0.089029] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.134041] smpboot: CPU0: Intel(R) Xeon(TM) CPU 3.20GHz (fam: 0f, model: 02, stepping: 05)
[    0.152000] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.160005] ... version:                0
[    0.164002] ... bit width:              40
[    0.168002] ... generic registers:      18
[    0.172002] ... value mask:             000000ffffffffff
[    0.176002] ... max period:             0000007fffffffff
[    0.180002] ... fixed-purpose events:   0
[    0.184002] ... event mask:             000000000003ffff
[    0.188356] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.192135] x86: Booting SMP configuration:
[    0.196003] .... node  #0, CPUs:      #1
[    0.016000] Initializing CPU#1
[    0.340182]  #2
[    0.016000] Initializing CPU#2
[    0.478260]  #3
[    0.016000] Initializing CPU#3
[    0.610097] x86: Booted up 1 node, 4 CPUs
[    0.612004] smpboot: Total of 4 processors activated (25499.78 BogoMIPS)
[    0.620148] devtmpfs: initialized
[    0.624307] NET: Registered protocol family 16
[    0.640010] cpuidle: using governor ladder
[    0.660007] cpuidle: using governor menu
[    0.664052] ACPI: bus type PCI registered
[    0.684417] PCI: PCI BIOS revision 2.10 entry at 0xf0094, last bus=9
[    0.688002] PCI: Using configuration type 1 for base access
[    0.692014] PCI: HP ProLiant DL380 detected, enabling pci=bfsort.
[    0.708240] ACPI: Added _OSI(Module Device)
[    0.756007] ACPI: Added _OSI(Processor Device)
[    0.808003] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.868006] ACPI: Added _OSI(Processor Aggregator Device)
[    0.936117] ACPI: Interpreter enabled
[    0.980013] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    1.092004] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    1.200003] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140926/hwxface-580)
[    1.312017] ACPI: (supports S0 S4 S5)
[    1.356003] ACPI: Using IOAPIC for interrupt routing
[    1.416056] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.536027] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00])
[    1.608010] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    1.688011] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.768186] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.904088] PCI host bridge to bus 0000:00
[    1.956005] pci_bus 0000:00: root bus resource [bus 00]
[    2.016004] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    2.092006] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    2.176029] pci 0000:00:0f.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    2.260006] pci 0000:00:0f.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    2.340004] pci 0000:00:0f.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    2.424005] pci 0000:00:0f.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    2.504074] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 01])
[    2.572011] acpi PNP0A03:01: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    2.656008] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    2.736352] acpi PNP0A03:01: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    2.872070] PCI host bridge to bus 0000:01
[    2.924004] pci_bus 0000:01: root bus resource [bus 01]
[    2.984004] pci_bus 0000:01: root bus resource [io  0x0000-0xffff]
[    3.060006] pci_bus 0000:01: root bus resource [mem 0x00000000-0xffffffff]
[    3.140428] ACPI: PCI Root Bridge [PCI2] (domain 0000 [bus 02])
[    3.212009] acpi PNP0A03:02: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    3.296008] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    3.372315] acpi PNP0A03:02: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    3.512063] PCI host bridge to bus 0000:02
[    3.560004] pci_bus 0000:02: root bus resource [bus 02]
[    3.624004] pci_bus 0000:02: root bus resource [io  0x0000-0xffff]
[    3.696006] pci_bus 0000:02: root bus resource [mem 0x00000000-0xffffffff]
[    3.780617] ACPI: PCI Root Bridge [PCI3] (domain 0000 [bus 03-05])
[    3.852010] acpi PNP0A03:03: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    3.936008] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    4.016152] acpi PNP0A03:03: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    4.152063] PCI host bridge to bus 0000:03
[    4.200004] pci_bus 0000:03: root bus resource [bus 03-05]
[    4.268004] pci_bus 0000:03: root bus resource [io  0x0000-0xffff]
[    4.340006] pci_bus 0000:03: root bus resource [mem 0x00000000-0xffffffff]
[    4.424206] ACPI: PCI Root Bridge [PCI4] (domain 0000 [bus 06-ff])
[    4.496009] acpi PNP0A03:04: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    4.580008] acpi PNP0A03:04: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    4.660318] acpi PNP0A03:04: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    4.796060] PCI host bridge to bus 0000:06
[    4.844004] pci_bus 0000:06: root bus resource [bus 06-ff]
[    4.912004] pci_bus 0000:06: root bus resource [io  0x0000-0xffff]
[    4.984006] pci_bus 0000:06: root bus resource [mem 0x00000000-0xffffffff]
[    5.068343] ACPI: PCI Interrupt Link [IUSB] (IRQs 4 5 *7 10 11 15)
[    5.142294] ACPI: PCI Interrupt Link [IN16] (IRQs 4 5 7 10 11 15) *3
[    5.218292] ACPI: PCI Interrupt Link [IN17] (IRQs 4 *5 7 10 11 15)
[    5.294294] ACPI: PCI Interrupt Link [IN18] (IRQs 4 5 7 10 11 *15)
[    5.368115] ACPI: PCI Interrupt Link [IN19] (IRQs 4 5 7 10 11 15) *0, disabled.
[    5.456114] ACPI: PCI Interrupt Link [IN20] (IRQs 4 5 7 10 11 15) *0, disabled.
[    5.546291] ACPI: PCI Interrupt Link [IN21] (IRQs 4 5 7 10 11 15) *0, disabled.
[    5.634294] ACPI: PCI Interrupt Link [IN22] (IRQs 4 5 7 10 11 15) *0, disabled.
[    5.722294] ACPI: PCI Interrupt Link [IN23] (IRQs 4 5 7 10 11 15) *0, disabled.
[    5.812114] ACPI: PCI Interrupt Link [IN24] (IRQs 4 5 7 10 11 15) *0, disabled.
[    5.900113] ACPI: PCI Interrupt Link [IN25] (IRQs 4 5 7 10 11 15) *0, disabled.
[    5.988113] ACPI: PCI Interrupt Link [IN26] (IRQs 4 5 7 10 11 15) *0, disabled.
[    6.076114] ACPI: PCI Interrupt Link [IN27] (IRQs 4 5 7 10 11 15) *0, disabled.
[    6.166291] ACPI: PCI Interrupt Link [IN28] (IRQs 4 5 7 10 11 15) *0, disabled.
[    6.254293] ACPI: PCI Interrupt Link [IN29] (IRQs 4 5 7 10 *11 15)
[    6.328113] ACPI: PCI Interrupt Link [IN30] (IRQs 4 5 7 *10 11 15)
[    6.404113] ACPI: PCI Interrupt Link [IN31] (IRQs 4 5 7 10 11 *15)
[    6.479435] ACPI: PCI Interrupt Link [IN32] (IRQs 4 5 7 10 11 15) *0, disabled.
[    6.568114] ACPI: PCI Interrupt Link [IN33] (IRQs 4 5 7 10 11 15) *0, disabled.
[    6.656114] ACPI: PCI Interrupt Link [IN34] (IRQs 4 5 7 10 11 15) *0, disabled.
[    6.744256] vgaarb: setting as boot device: PCI:0000:00:03.0
[    6.748005] vgaarb: device added: PCI:0000:00:03.0,decodes=io+mem,owns=io+mem,locks=none
[    6.912025] vgaarb: loaded
[    6.944030] vgaarb: bridge control possible 0000:00:03.0
[    7.008165] SCSI subsystem initialized
[    7.052106] PCI: Using ACPI for IRQ routing
[    7.104005] Switched to clocksource refined-jiffies
[    7.160117] pnp: PnP ACPI init
[    7.196187] system 00:00: [io  0x0f50-0x0f58] has been reserved
[    7.268017] system 00:00: [io  0x0408-0x040f] has been reserved
[    7.340022] system 00:00: [io  0x0900-0x0903] has been reserved
[    7.408024] system 00:00: [io  0x0910-0x0911] has been reserved
[    7.480030] system 00:00: [io  0x0920-0x0923] has been reserved
[    7.552033] system 00:00: [io  0x0930-0x0937] has been reserved
[    7.624039] system 00:00: [io  0x0940-0x0947] has been reserved
[    7.692042] system 00:00: [io  0x0950-0x0957] has been reserved
[    7.764049] system 00:00: [io  0x0c06-0x0c08] has been reserved
[    7.836051] system 00:00: [io  0x0c14] has been reserved
[    7.900057] system 00:00: [io  0x0c49-0x0c4a] has been reserved
[    7.968059] system 00:00: [io  0x0c50-0x0c52] has been reserved
[    8.040065] system 00:00: [io  0x0c6c-0x0c6f] has been reserved
[    8.112068] system 00:00: [io  0x0230-0x0233] has been reserved
[    8.180074] system 00:00: [io  0x0260-0x0267] has been reserved
[    8.252077] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    8.324083] system 00:00: [io  0x0700-0x070f] has been reserved
[    8.392085] system 00:00: [io  0x0800-0x081f] has been reserved
[    8.464091] system 00:00: [io  0x0c80-0x0c83] has been reserved
[    8.536094] system 00:00: [io  0x0cd4-0x0cd7] has been reserved
[    8.608100] system 00:00: [io  0x0cf9] could not be reserved
[    8.677296] pnp: PnP ACPI: found 5 devices
[    8.765217] Switched to clocksource acpi_pm
[    8.814227] pci 0000:00:03.0: BAR 6: assigned [mem 0x80000000-0x8001ffff pref]
[    8.900725] pci 0000:00:04.2: BAR 6: assigned [mem 0x80020000-0x8002ffff pref]
[    8.987241] pci 0000:01:03.0: BAR 6: assigned [mem 0x80030000-0x80033fff pref]
[    9.073832] NET: Registered protocol family 2
[    9.126201] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    9.210611] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    9.287775] TCP: Hash tables configured (established 8192 bind 8192)
[    9.363893] TCP: reno registered
[    9.402538] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    9.473355] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    9.549471] NET: Registered protocol family 1
[    9.601908] ACPI: PCI Interrupt Link [IUSB] enabled at IRQ 11
[    9.740226] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    9.831971] Scanning for low memory corruption every 60 seconds
[    9.903296] futex hash table entries: 1024 (order: 5, 131072 bytes)
[    9.982723] msgmni has been set to 1729
[   10.029273] bounce: pool size: 64 pages
[   10.075277] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[   10.163884] io scheduler noop registered
[   10.210856] io scheduler cfq registered (default)
[   10.267390] Serial: 8250/16550 driver, 16 ports, IRQ sharing disabled
[   10.364935] serial 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   10.461359] Non-volatile memory driver v1.3
[   10.511470] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[   10.618721] HP CISS Driver (v 3.6.26)
[   10.618932] Floppy drive(s): fd0 is 1.44M
[   10.633546] FDC 0 is a National Semiconductor PC87306
[   10.771146] cciss 0000:01:03.0: Controller reports max supported commands of 0, an obvious lie. Using 16.  Ensure that firmware is up to date.
[   10.900036] tsc: Refined TSC clocksource calibration: 3187.386 MHz
[   11.118325] cciss 0000:01:03.0: cciss0: <0xb178> at PCI 0000:01:03.0 IRQ 16 using DAC
[   11.237133]  cciss/c0d0: p1 p2 < p5 >
[   11.281604] scsi host0: cciss
[   11.317476] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[   11.415787] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.475182] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.535799] mousedev: PS/2 mouse device common for all mice
[   11.602684] rtc_cmos rtc_cmos: RTC can wake from S4
[   11.653333] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[   11.764342] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[   11.840398] rtc_cmos rtc_cmos: alarms up to one year, y3k, 114 bytes nvram
[   11.922769] hidraw: raw HID events driver (C) Jiri Kosina
[   11.987704] TCP: cubic registered
[   12.027330] NET: Registered protocol family 17
[   12.080809] Using IPI No-Shortcut mode
[   12.125749] Switched to clocksource tsc
[   12.126055] registered taskstats version 1
[   12.220637] console [netcon0] enabled
[   12.264505] netconsole: network logging started
[   12.318744] rtc_cmos rtc_cmos: setting system clock to 2014-10-29 10:25:45 UTC (1414578345)
[   12.475662] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input2
[   12.571365] EXT4-fs (cciss!c0d0p1): couldn't mount as ext3 due to feature incompatibilities
[   12.671735] EXT4-fs (cciss!c0d0p1): couldn't mount as ext2 due to feature incompatibilities
[   12.791929] EXT4-fs (cciss!c0d0p1): mounted filesystem with ordered data mode. Opts: (null)
[   12.891914] VFS: Mounted root (ext4 filesystem) readonly on device 104:1.
[   12.993454] devtmpfs: mounted
[   13.029252] Freeing unused kernel memory: 372K (c14de000 - c153b000)
[   13.105379] Write protecting the kernel text: 3592k
[   13.163741] Write protecting the kernel read-only data: 1084k
Mount failed for selinuxfs on /sys/fs/selinux:  No such file or directory
INIT: version 2.88 booting
[info] Using makefile-style concurrent boot in runlevel S.
findfs: unable to resolve 'UUID=5e6a5afe-9943-433e-a33a-935b6ae12f8b'
[....] Starting the hot[   14.344549] systemd-udevd[665]: starting version 215
plug events dispatcher: udevd[ ok .
[   14.493201] random: udevd urandom read with 92 bits of entropy available
[....] Synthesizing the initial hotplug events...[ ok done.
[....] Waiting for /dev to be fully populated...[   14.776146] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   14.864686] ACPI: Power Button [PWRF]
[   14.910437] hpwdt 0000:00:04.0: This server does not have an iLO2+ ASIC.
[   15.017624] Linux agpgart interface v0.103
[   15.067119] pps_core: LinuxPPS API ver. 1 registered
[   15.069114] scsi host1: pata_serverworks
[   15.173491] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   15.184512] scsi host2: pata_serverworks
[   15.184673] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2000 irq 14
[   15.184675] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2008 irq 15
[   15.460452] ata1.00: ATAPI: COMPAQ  CD-ROM SN-124, N104, max PIO4
[   15.476445] ata1.00: configured for PIO4
[   15.477110] scsi 1:0:0:0: CD-ROM            COMPAQ   CD-ROM SN-124    N104 PQ: 0 ANSI: 5
[   15.509169] random: nonblocking pool is initialized
[   15.772844] ACPI: bus type USB registered
[   15.821106] PTP clock support registered
[   15.821318] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   15.824062] usbcore: registered new interface driver usbfs
[   15.824098] usbcore: registered new interface driver hub
[   15.824132] usbcore: registered new device driver usb
[   15.872045] microcode: CPU0 sig=0xf25, pf=0x1, revision=0x29
[   16.204163] piix4_smbus 0000:00:0f.0: SMBus Host Controller at 0x700, revision 0
[   16.292915] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   16.300074] microcode: CPU1 sig=0xf25, pf=0x1, revision=0x29
[   16.300118] microcode: CPU2 sig=0xf25, pf=0x1, revision=0x29
[   16.296203] microcode: CPU3 sig=0xf25, pf=0x1, revision=0x29
[   16.448045] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   16.463771] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   16.463773] cdrom: Uniform CD-ROM driver Revision: 3.20
[   16.830941] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   16.905684] sr 1:0:0:0: Attached scsi generic sg0 type 5
[   16.969616] ehci-pci: EHCI PCI platform driver
[   16.969867] tg3.c:v3.137 (May 11, 2014)
[   17.069339] ohci-pci: OHCI PCI platform driver
[   17.112464] tg3 0000:02:01.0 eth0: Tigon3 [partno(NA) rev 1002] (PCIX:100MHz:64-bit) MAC address 00:0b:cd:ef:fd:b3
[   17.112468] tg3 0000:02:01.0 eth0: attached PHY is 5703 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   17.112472] tg3 0000:02:01.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   17.112475] tg3 0000:02:01.0 eth0: dma_rwctrl[769c4000] dma_mask[64-bit]
[   17.536923] ohci-pci 0000:00:0f.2: OHCI PCI host controller
[   17.603646] ohci-pci 0000:00:0f.2: new USB bus registered, assigned bus number 1
[   17.692159] ohci-pci 0000:00:0f.2: irq 11, io mem 0xf5ef0000
[   17.814149] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   17.819982] tg3 0000:02:02.0 eth1: Tigon3 [partno(NA) rev 1002] (PCIX:100MHz:64-bit) MAC address 00:0b:cd:ef:fd:b2
[   17.819987] tg3 0000:02:02.0 eth1: attached PHY is 5703 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   17.819990] tg3 0000:02:02.0 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   17.819994] tg3 0000:02:02.0 eth1: dma_rwctrl[769c4000] dma_mask[64-bit]
[   18.309763] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.396166] usb usb1: Product: OHCI PCI host controller
[   18.458656] usb usb1: Manufacturer: Linux 3.18.0-rc2-dirty ohci_hcd
[   18.533619] usb usb1: SerialNumber: 0000:00:0f.2
[   18.589129] hub 1-0:1.0: USB hub found
[   18.633978] hub 1-0:1.0: 4 ports detected
[   19.016027] usb 1-4: new low-speed USB device number 2 using ohci-pci
[   19.266705] usb 1-4: New USB device found, idVendor=03f0, idProduct=0324
[   19.346915] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   19.432278] usb 1-4: Product: HP Basic USB Keyboard
[   19.490602] usb 1-4: Manufacturer: LiteON
[   19.579899] input: LiteON HP Basic USB Keyboard as /devices/pci0000:00/0000:00:0f.2/usb1/1-4/1-4:1.0/0003:03F0:0324.0001/input/input5
[   19.723779] hid-generic 0003:03F0:0324.0001: input,hidraw0: USB HID v1.00 Keyboard [LiteON HP Basic USB Keyboard] on usb-0000:00:0f.2-4/input0
[   19.876842] usbcore: registered new interface driver usbhid
[   19.943529] usbhid: USB HID core driver
[  240.704040] INFO: task scsi_eh_1:720 blocked for more than 120 seconds.
[  240.783198]       Not tainted 3.18.0-rc2-dirty #22
[  240.840485] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.934172] scsi_eh_1       D c1264d7f     0   720      2 0x00000000
[  241.010385]  f5bdbe54 00000046 f5bdbde0 c1264d7f f5bdbe00 00001412 00000000 2be89db4
[  241.103850]  00000004 2be8b1c6 00000004 c1534000 f63bca10 c10892f5 6f223d9e 00000132
[  241.197335]  ffffffff 066087ce f5bdbe50 c10892f5 6f22478a 00000132 ffffffff 066087ce
[  241.290803] Call Trace:
[  241.320039]  [<c1264d7f>] ? put_device+0xf/0x20
[  241.374205]  [<c10892f5>] ? ktime_get+0x45/0x110
[  241.429416]  [<c10892f5>] ? ktime_get+0x45/0x110
[  241.484631]  [<c137d8ee>] schedule+0x1e/0x60
[  241.535679]  [<c137dae7>] io_schedule+0x77/0xc0
[  241.589854]  [<c11c4cd3>] bt_get+0xc3/0x140
[  241.639867]  [<c106b5c0>] ? __wake_up_sync+0x20/0x20
[  241.699240]  [<c11c51fe>] blk_mq_get_tag+0x9e/0xc0
[  241.756531]  [<c11c1e03>] __blk_mq_alloc_request+0x13/0x1c0
[  241.823185]  [<c11c30e6>] blk_mq_alloc_request+0xe6/0xf0
[  241.886715]  [<c11ba4b4>] blk_get_request+0x24/0xd0
[  241.945045]  [<c128df47>] scsi_error_handler+0x1e7/0x850
[  242.008572]  [<c128b150>] ? scsi_try_target_reset+0x70/0x70
[  242.075227]  [<c105ae8b>] ? default_wake_function+0xb/0x10
[  242.140834]  [<c106b06d>] ? __wake_up_common+0x3d/0x70
[  242.202290]  [<c106b0ba>] ? __wake_up_locked+0x1a/0x20
[  242.263742]  [<c128dd60>] ? scsi_eh_get_sense+0x2f0/0x2f0
[  242.328315]  [<c1052ab3>] kthread+0xa3/0xc0
[  242.378331]  [<c1380641>] ret_from_kernel_thread+0x21/0x30
[  242.443942]  [<c1052a10>] ? kthread_create_on_node+0x100/0x100
[  242.513713] INFO: task udevd:733 blocked for more than 120 seconds.
[  242.588678]       Not tainted 3.18.0-rc2-dirty #22
[  242.645970] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.739656] udevd           D 00000000     0   733    665 0x00000000
[  242.815873]  f5bb9c84 00000086 27bc8d00 00000000 89fee683 fce083f0 0004c6f7 450f0000
[  242.909351]  83f089f0 c6f7fae0 00000002 c1534000 f63bb160 0001c6f7 450f0000 0000a1f0
[  243.002825]  f2890000 8befe283 01a85840 89f2450f fde680f2 450f02a8 7404a8f2 f9e68306
[  243.096306] Call Trace:
[  243.125531]  [<c137d8ee>] schedule+0x1e/0x60
[  243.176585]  [<c137f7ed>] schedule_timeout+0x12d/0x190
[  243.238032]  [<c105ad0a>] ? try_to_wake_up+0x13a/0x270
[  243.299484]  [<c137e233>] wait_for_common+0x83/0x110
[  243.358858]  [<c105ae80>] ? wake_up_process+0x40/0x40
[  243.419272]  [<c137e2d2>] wait_for_completion+0x12/0x20
[  243.481761]  [<c104e1ed>] flush_work+0x9d/0x110
[  243.535935]  [<c104c720>] ? destroy_worker+0x90/0x90
[  243.595303]  [<c104eda3>] __cancel_work_timer+0x53/0xd0
[  243.657793]  [<c104ee3d>] cancel_delayed_work_sync+0xd/0x10
[  243.724447]  [<c11c8bd9>] disk_block_events+0x69/0x70
[  243.784858]  [<c1121860>] __blkdev_get+0x30/0x370
[  243.841106]  [<c1121bd1>] blkdev_get+0x31/0x2c0
[  243.895278]  [<c11212e4>] ? bd_acquire+0x24/0xb0
[  243.950488]  [<c1121edd>] blkdev_open+0x4d/0x70
[  244.004663]  [<c10f38a4>] do_dentry_open.isra.12+0x184/0x2c0
[  244.072351]  [<c1121e90>] ? blkdev_get_by_dev+0x30/0x30
[  244.134840]  [<c10f3a4c>] vfs_open+0x3c/0x50
[  244.185897]  [<c11014e1>] do_last.isra.50+0x2f1/0xca0
[  244.246308]  [<c10ffe65>] ? link_path_walk+0x1e5/0x7b0
[  244.307761]  [<c10ed281>] ? kmem_cache_alloc+0x91/0xa0
[  244.369209]  [<c10f7017>] ? get_empty_filp+0xa7/0x170
[  244.429620]  [<c1101f31>] path_openat+0xa1/0x580
[  244.484832]  [<c1102eac>] do_filp_open+0x2c/0x80
[  244.540044]  [<c110dce9>] ? __alloc_fd+0x69/0x100
[  244.596298]  [<c110276b>] ? getname_flags+0x7b/0x100
[  244.655667]  [<c10f4c3f>] do_sys_open+0x10f/0x210
[  244.711919]  [<c10f4d5d>] SyS_open+0x1d/0x20
[  244.762972]  [<c138070c>] sysenter_do_call+0x12/0x12
[  364.820037] INFO: task scsi_eh_1:720 blocked for more than 120 seconds.
[  364.899258]       Not tainted 3.18.0-rc2-dirty #22
[  364.956549] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  365.050233] scsi_eh_1       D c1264d7f     0   720      2 0x00000000
[  365.126445]  f5bdbe54 00000046 f5bdbde0 c1264d7f f5bdbe00 00001412 00000000 2be89db4
[  365.219914]  00000004 2be8b1c6 00000004 c1534000 f63bca10 c10892f5 6f223d9e 00000132
[  365.313393]  ffffffff 066087ce f5bdbe50 c10892f5 6f22478a 00000132 ffffffff 066087ce
[  365.406865] Call Trace:
[  365.436101]  [<c1264d7f>] ? put_device+0xf/0x20
[  365.490267]  [<c10892f5>] ? ktime_get+0x45/0x110
[  365.545477]  [<c10892f5>] ? ktime_get+0x45/0x110
[  365.600691]  [<c137d8ee>] schedule+0x1e/0x60
[  365.651740]  [<c137dae7>] io_schedule+0x77/0xc0
[  365.705914]  [<c11c4cd3>] bt_get+0xc3/0x140
[  365.755923]  [<c106b5c0>] ? __wake_up_sync+0x20/0x20
[  365.815294]  [<c11c51fe>] blk_mq_get_tag+0x9e/0xc0
[  365.872584]  [<c11c1e03>] __blk_mq_alloc_request+0x13/0x1c0
[  365.939232]  [<c11c30e6>] blk_mq_alloc_request+0xe6/0xf0
[  366.002765]  [<c11ba4b4>] blk_get_request+0x24/0xd0
[  366.061095]  [<c128df47>] scsi_error_handler+0x1e7/0x850
[  366.124624]  [<c128b150>] ? scsi_try_target_reset+0x70/0x70
[  366.191276]  [<c105ae8b>] ? default_wake_function+0xb/0x10
[  366.256886]  [<c106b06d>] ? __wake_up_common+0x3d/0x70
[  366.318336]  [<c106b0ba>] ? __wake_up_locked+0x1a/0x20
[  366.379782]  [<c128dd60>] ? scsi_eh_get_sense+0x2f0/0x2f0
[  366.444354]  [<c1052ab3>] kthread+0xa3/0xc0
[  366.494362]  [<c1380641>] ret_from_kernel_thread+0x21/0x30
[  366.559970]  [<c1052a10>] ? kthread_create_on_node+0x100/0x100
[  366.629738] INFO: task udevd:733 blocked for more than 120 seconds.
[  366.704701]       Not tainted 3.18.0-rc2-dirty #22
[  366.761990] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  366.855674] udevd           D 00000000     0   733    665 0x00000000
[  366.931891]  f5bb9c84 00000086 27bc8d00 00000000 89fee683 fce083f0 0004c6f7 450f0000
[  367.025366]  83f089f0 c6f7fae0 00000002 c1534000 f63bb160 0001c6f7 450f0000 0000a1f0
[  367.118836]  f2890000 8befe283 01a85840 89f2450f fde680f2 450f02a8 7404a8f2 f9e68306
[  367.212317] Call Trace:
[  367.241540]  [<c137d8ee>] schedule+0x1e/0x60
[  367.292595]  [<c137f7ed>] schedule_timeout+0x12d/0x190
[  367.354046]  [<c105ad0a>] ? try_to_wake_up+0x13a/0x270
[  367.415495]  [<c137e233>] wait_for_common+0x83/0x110
[  367.474866]  [<c105ae80>] ? wake_up_process+0x40/0x40
[  367.535278]  [<c137e2d2>] wait_for_completion+0x12/0x20
[  367.597769]  [<c104e1ed>] flush_work+0x9d/0x110
[  367.651941]  [<c104c720>] ? destroy_worker+0x90/0x90
[  367.711312]  [<c104eda3>] __cancel_work_timer+0x53/0xd0
[  367.773801]  [<c104ee3d>] cancel_delayed_work_sync+0xd/0x10
[  367.840457]  [<c11c8bd9>] disk_block_events+0x69/0x70
[  367.900867]  [<c1121860>] __blkdev_get+0x30/0x370
[  367.957114]  [<c1121bd1>] blkdev_get+0x31/0x2c0
[  368.011288]  [<c11212e4>] ? bd_acquire+0x24/0xb0
[  368.066498]  [<c1121edd>] blkdev_open+0x4d/0x70
[  368.120673]  [<c10f38a4>] do_dentry_open.isra.12+0x184/0x2c0
[  368.188362]  [<c1121e90>] ? blkdev_get_by_dev+0x30/0x30
[  368.250849]  [<c10f3a4c>] vfs_open+0x3c/0x50
[  368.301904]  [<c11014e1>] do_last.isra.50+0x2f1/0xca0
[  368.362316]  [<c10ffe65>] ? link_path_walk+0x1e5/0x7b0
[  368.423765]  [<c10ed281>] ? kmem_cache_alloc+0x91/0xa0
[  368.485215]  [<c10f7017>] ? get_empty_filp+0xa7/0x170
[  368.545625]  [<c1101f31>] path_openat+0xa1/0x580
[  368.600833]  [<c1102eac>] do_filp_open+0x2c/0x80
[  368.656048]  [<c110dce9>] ? __alloc_fd+0x69/0x100
[  368.712297]  [<c110276b>] ? getname_flags+0x7b/0x100
[  368.771663]  [<c10f4c3f>] do_sys_open+0x10f/0x210
[  368.827914]  [<c10f4d5d>] SyS_open+0x1d/0x20
[  368.878967]  [<c138070c>] sysenter_do_call+0x12/0x12
[  488.936038] INFO: task scsi_eh_1:720 blocked for more than 120 seconds.
[  489.015224]       Not tainted 3.18.0-rc2-dirty #22
[  489.072509] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  489.166195] scsi_eh_1       D c1264d7f     0   720      2 0x00000000
[  489.242410]  f5bdbe54 00000046 f5bdbde0 c1264d7f f5bdbe00 00001412 00000000 2be89db4
[  489.335882]  00000004 2be8b1c6 00000004 c1534000 f63bca10 c10892f5 6f223d9e 00000132
[  489.429367]  ffffffff 066087ce f5bdbe50 c10892f5 6f22478a 00000132 ffffffff 066087ce
[  489.522839] Call Trace:
[  489.552076]  [<c1264d7f>] ? put_device+0xf/0x20
[  489.606240]  [<c10892f5>] ? ktime_get+0x45/0x110
[  489.661454]  [<c10892f5>] ? ktime_get+0x45/0x110
[  489.716668]  [<c137d8ee>] schedule+0x1e/0x60
[  489.767726]  [<c137dae7>] io_schedule+0x77/0xc0
[  489.821904]  [<c11c4cd3>] bt_get+0xc3/0x140
[  489.871911]  [<c106b5c0>] ? __wake_up_sync+0x20/0x20
[  489.931277]  [<c11c51fe>] blk_mq_get_tag+0x9e/0xc0
[  489.988569]  [<c11c1e03>] __blk_mq_alloc_request+0x13/0x1c0
[  490.055220]  [<c11c30e6>] blk_mq_alloc_request+0xe6/0xf0
[  490.118756]  [<c11ba4b4>] blk_get_request+0x24/0xd0
[  490.177090]  [<c128df47>] scsi_error_handler+0x1e7/0x850
[  490.240621]  [<c128b150>] ? scsi_try_target_reset+0x70/0x70
[  490.307277]  [<c105ae8b>] ? default_wake_function+0xb/0x10
[  490.372884]  [<c106b06d>] ? __wake_up_common+0x3d/0x70
[  490.434342]  [<c106b0ba>] ? __wake_up_locked+0x1a/0x20
[  490.495792]  [<c128dd60>] ? scsi_eh_get_sense+0x2f0/0x2f0
[  490.560370]  [<c1052ab3>] kthread+0xa3/0xc0
[  490.610386]  [<c1380641>] ret_from_kernel_thread+0x21/0x30
[  490.676002]  [<c1052a10>] ? kthread_create_on_node+0x100/0x100
[  490.745776] INFO: task udevd:733 blocked for more than 120 seconds.
[  490.820745]       Not tainted 3.18.0-rc2-dirty #22
[  490.878043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  490.971732] udevd           D 00000000     0   733    665 0x00000000
[  491.047952]  f5bb9c84 00000086 27bc8d00 00000000 89fee683 fce083f0 0004c6f7 450f0000
[  491.141430]  83f089f0 c6f7fae0 00000002 c1534000 f63bb160 0001c6f7 450f0000 0000a1f0
[  491.234902]  f2890000 8befe283 01a85840 89f2450f fde680f2 450f02a8 7404a8f2 f9e68306
[  491.328388] Call Trace:
[  491.357614]  [<c137d8ee>] schedule+0x1e/0x60
[  491.408667]  [<c137f7ed>] schedule_timeout+0x12d/0x190
[  491.470119]  [<c105ad0a>] ? try_to_wake_up+0x13a/0x270
[  491.531574]  [<c137e233>] wait_for_common+0x83/0x110
[  491.590950]  [<c105ae80>] ? wake_up_process+0x40/0x40
[  491.651361]  [<c137e2d2>] wait_for_completion+0x12/0x20
[  491.713856]  [<c104e1ed>] flush_work+0x9d/0x110
[  491.768035]  [<c104c720>] ? destroy_worker+0x90/0x90
[  491.827413]  [<c104eda3>] __cancel_work_timer+0x53/0xd0
[  491.889901]  [<c104ee3d>] cancel_delayed_work_sync+0xd/0x10
[  491.956556]  [<c11c8bd9>] disk_block_events+0x69/0x70
[  492.016972]  [<c1121860>] __blkdev_get+0x30/0x370
[  492.073224]  [<c1121bd1>] blkdev_get+0x31/0x2c0
[  492.127401]  [<c11212e4>] ? bd_acquire+0x24/0xb0
[  492.182615]  [<c1121edd>] blkdev_open+0x4d/0x70
[  492.236794]  [<c10f38a4>] do_dentry_open.isra.12+0x184/0x2c0
[  492.304486]  [<c1121e90>] ? blkdev_get_by_dev+0x30/0x30
[  492.366979]  [<c10f3a4c>] vfs_open+0x3c/0x50
[  492.418035]  [<c11014e1>] do_last.isra.50+0x2f1/0xca0
[  492.478449]  [<c10ffe65>] ? link_path_walk+0x1e5/0x7b0
[  492.539900]  [<c10ed281>] ? kmem_cache_alloc+0x91/0xa0
[  492.601354]  [<c10f7017>] ? get_empty_filp+0xa7/0x170
[  492.661771]  [<c1101f31>] path_openat+0xa1/0x580
[  492.716981]  [<c1102eac>] do_filp_open+0x2c/0x80
[  492.772195]  [<c110dce9>] ? __alloc_fd+0x69/0x100
[  492.828450]  [<c110276b>] ? getname_flags+0x7b/0x100
[  492.887825]  [<c10f4c3f>] do_sys_open+0x10f/0x210
[  492.944078]  [<c10f4d5d>] SyS_open+0x1d/0x20
[  492.995132]  [<c138070c>] sysenter_do_call+0x12/0x12
[  613.052041] INFO: task scsi_eh_1:720 blocked for more than 120 seconds.
[  613.131208]       Not tainted 3.18.0-rc2-dirty #22
[  613.188498] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  613.282186] scsi_eh_1       D c1264d7f     0   720      2 0x00000000
[  613.358407]  f5bdbe54 00000046 f5bdbde0 c1264d7f f5bdbe00 00001412 00000000 2be89db4
[  613.451880]  00000004 2be8b1c6 00000004 c1534000 f63bca10 c10892f5 6f223d9e 00000132
[  613.545366]  ffffffff 066087ce f5bdbe50 c10892f5 6f22478a 00000132 ffffffff 066087ce
[  613.638843] Call Trace:
[  613.668077]  [<c1264d7f>] ? put_device+0xf/0x20
[  613.722247]  [<c10892f5>] ? ktime_get+0x45/0x110
[  613.777462]  [<c10892f5>] ? ktime_get+0x45/0x110
[  613.832678]  [<c137d8ee>] schedule+0x1e/0x60
[  613.883731]  [<c137dae7>] io_schedule+0x77/0xc0
[  613.937911]  [<c11c4cd3>] bt_get+0xc3/0x140
[  613.987925]  [<c106b5c0>] ? __wake_up_sync+0x20/0x20
[  614.047300]  [<c11c51fe>] blk_mq_get_tag+0x9e/0xc0
[  614.104603]  [<c11c1e03>] __blk_mq_alloc_request+0x13/0x1c0
[  614.171250]  [<c11c30e6>] blk_mq_alloc_request+0xe6/0xf0
[  614.234788]  [<c11ba4b4>] blk_get_request+0x24/0xd0
[  614.293122]  [<c128df47>] scsi_error_handler+0x1e7/0x850
[  614.356653]  [<c128b150>] ? scsi_try_target_reset+0x70/0x70
[  614.423313]  [<c105ae8b>] ? default_wake_function+0xb/0x10
[  614.488921]  [<c106b06d>] ? __wake_up_common+0x3d/0x70
[  614.550375]  [<c106b0ba>] ? __wake_up_locked+0x1a/0x20
[  614.611827]  [<c128dd60>] ? scsi_eh_get_sense+0x2f0/0x2f0
[  614.676404]  [<c1052ab3>] kthread+0xa3/0xc0
[  614.726417]  [<c1380641>] ret_from_kernel_thread+0x21/0x30
[  614.792029]  [<c1052a10>] ? kthread_create_on_node+0x100/0x100
[  614.861802] INFO: task udevd:733 blocked for more than 120 seconds.
[  614.936768]       Not tainted 3.18.0-rc2-dirty #22
[  614.994060] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  615.087750] udevd           D 00000000     0   733    665 0x00000000
[  615.163967]  f5bb9c84 00000086 27bc8d00 00000000 89fee683 fce083f0 0004c6f7 450f0000
[  615.257444]  83f089f0 c6f7fae0 00000002 c1534000 f63bb160 0001c6f7 450f0000 0000a1f0
[  615.350915]  f2890000 8befe283 01a85840 89f2450f fde680f2 450f02a8 7404a8f2 f9e68306
[  615.444402] Call Trace:
[  615.473628]  [<c137d8ee>] schedule+0x1e/0x60
[  615.524683]  [<c137f7ed>] schedule_timeout+0x12d/0x190
[  615.586135]  [<c105ad0a>] ? try_to_wake_up+0x13a/0x270
[  615.647588]  [<c137e233>] wait_for_common+0x83/0x110
[  615.706963]  [<c105ae80>] ? wake_up_process+0x40/0x40
[  615.767376]  [<c137e2d2>] wait_for_completion+0x12/0x20
[  615.829868]  [<c104e1ed>] flush_work+0x9d/0x110
[  615.884042]  [<c104c720>] ? destroy_worker+0x90/0x90
[  615.943413]  [<c104eda3>] __cancel_work_timer+0x53/0xd0
[  616.005903]  [<c104ee3d>] cancel_delayed_work_sync+0xd/0x10
[  616.072560]  [<c11c8bd9>] disk_block_events+0x69/0x70
[  616.132977]  [<c1121860>] __blkdev_get+0x30/0x370
[  616.189223]  [<c1121bd1>] blkdev_get+0x31/0x2c0
[  616.243399]  [<c11212e4>] ? bd_acquire+0x24/0xb0
[  616.298611]  [<c1121edd>] blkdev_open+0x4d/0x70
[  616.352788]  [<c10f38a4>] do_dentry_open.isra.12+0x184/0x2c0
[  616.420479]  [<c1121e90>] ? blkdev_get_by_dev+0x30/0x30
[  616.482968]  [<c10f3a4c>] vfs_open+0x3c/0x50
[  616.534023]  [<c11014e1>] do_last.isra.50+0x2f1/0xca0
[  616.594432]  [<c10ffe65>] ? link_path_walk+0x1e5/0x7b0
[  616.655889]  [<c10ed281>] ? kmem_cache_alloc+0x91/0xa0
[  616.717338]  [<c10f7017>] ? get_empty_filp+0xa7/0x170
[  616.777751]  [<c1101f31>] path_openat+0xa1/0x580
[  616.832964]  [<c1102eac>] do_filp_open+0x2c/0x80
[  616.888177]  [<c110dce9>] ? __alloc_fd+0x69/0x100
[  616.944434]  [<c110276b>] ? getname_flags+0x7b/0x100
[  617.003803]  [<c10f4c3f>] do_sys_open+0x10f/0x210
[  617.060059]  [<c10f4d5d>] SyS_open+0x1d/0x20
[  617.111119]  [<c138070c>] sysenter_do_call+0x12/0x12
[  737.168041] INFO: task scsi_eh_1:720 blocked for more than 120 seconds.
[  737.247256]       Not tainted 3.18.0-rc2-dirty #22
[  737.304550] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  737.398242] scsi_eh_1       D c1264d7f     0   720      2 0x00000000
[  737.474465]  f5bdbe54 00000046 f5bdbde0 c1264d7f f5bdbe00 00001412 00000000 2be89db4
[  737.567940]  00000004 2be8b1c6 00000004 c1534000 f63bca10 c10892f5 6f223d9e 00000132
[  737.661427]  ffffffff 066087ce f5bdbe50 c10892f5 6f22478a 00000132 ffffffff 066087ce
[  737.754901] Call Trace:
[  737.784138]  [<c1264d7f>] ? put_device+0xf/0x20
[  737.838309]  [<c10892f5>] ? ktime_get+0x45/0x110
[  737.893526]  [<c10892f5>] ? ktime_get+0x45/0x110
[  737.948742]  [<c137d8ee>] schedule+0x1e/0x60
[  737.999799]  [<c137dae7>] io_schedule+0x77/0xc0
[  738.053977]  [<c11c4cd3>] bt_get+0xc3/0x140
[  738.103995]  [<c106b5c0>] ? __wake_up_sync+0x20/0x20
[  738.163370]  [<c11c51fe>] blk_mq_get_tag+0x9e/0xc0
[  738.220667]  [<c11c1e03>] __blk_mq_alloc_request+0x13/0x1c0
[  738.287323]  [<c11c30e6>] blk_mq_alloc_request+0xe6/0xf0
[  738.350864]  [<c11ba4b4>] blk_get_request+0x24/0xd0
[  738.409198]  [<c128df47>] scsi_error_handler+0x1e7/0x850
[  738.472731]  [<c128b150>] ? scsi_try_target_reset+0x70/0x70
[  738.539389]  [<c105ae8b>] ? default_wake_function+0xb/0x10
[  738.605001]  [<c106b06d>] ? __wake_up_common+0x3d/0x70
[  738.666457]  [<c106b0ba>] ? __wake_up_locked+0x1a/0x20
[  738.727912]  [<c128dd60>] ? scsi_eh_get_sense+0x2f0/0x2f0
[  738.792487]  [<c1052ab3>] kthread+0xa3/0xc0
[  738.842504]  [<c1380641>] ret_from_kernel_thread+0x21/0x30
[  738.908120]  [<c1052a10>] ? kthread_create_on_node+0x100/0x100
[  738.977895] INFO: task udevd:733 blocked for more than 120 seconds.
[  739.052864]       Not tainted 3.18.0-rc2-dirty #22
[  739.110160] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  739.203852] udevd           D 00000000     0   733    665 0x00000000
[  739.280075]  f5bb9c84 00000086 27bc8d00 00000000 89fee683 fce083f0 0004c6f7 450f0000
[  739.373559]  83f089f0 c6f7fae0 00000002 c1534000 f63bb160 0001c6f7 450f0000 0000a1f0
[  739.467035]  f2890000 8befe283 01a85840 89f2450f fde680f2 450f02a8 7404a8f2 f9e68306
[  739.560526] Call Trace:
[  739.589753]  [<c137d8ee>] schedule+0x1e/0x60
[  739.640808]  [<c137f7ed>] schedule_timeout+0x12d/0x190
[  739.702261]  [<c105ad0a>] ? try_to_wake_up+0x13a/0x270
[  739.763718]  [<c137e233>] wait_for_common+0x83/0x110
[  739.823095]  [<c105ae80>] ? wake_up_process+0x40/0x40
[  739.883509]  [<c137e2d2>] wait_for_completion+0x12/0x20
[  739.946003]  [<c104e1ed>] flush_work+0x9d/0x110
[  740.000178]  [<c104c720>] ? destroy_worker+0x90/0x90
[  740.059554]  [<c104eda3>] __cancel_work_timer+0x53/0xd0
[  740.122047]  [<c104ee3d>] cancel_delayed_work_sync+0xd/0x10
[  740.188702]  [<c11c8bd9>] disk_block_events+0x69/0x70
[  740.249117]  [<c1121860>] __blkdev_get+0x30/0x370
[  740.305371]  [<c1121bd1>] blkdev_get+0x31/0x2c0
[  740.359550]  [<c11212e4>] ? bd_acquire+0x24/0xb0
[  740.414764]  [<c1121edd>] blkdev_open+0x4d/0x70
[  740.468944]  [<c10f38a4>] do_dentry_open.isra.12+0x184/0x2c0
[  740.536637]  [<c1121e90>] ? blkdev_get_by_dev+0x30/0x30
[  740.599128]  [<c10f3a4c>] vfs_open+0x3c/0x50
[  740.650188]  [<c11014e1>] do_last.isra.50+0x2f1/0xca0
[  740.710601]  [<c10ffe65>] ? link_path_walk+0x1e5/0x7b0
[  740.772056]  [<c10ed281>] ? kmem_cache_alloc+0x91/0xa0
[  740.833513]  [<c10f7017>] ? get_empty_filp+0xa7/0x170
[  740.893928]  [<c1101f31>] path_openat+0xa1/0x580
[  740.949146]  [<c1102eac>] do_filp_open+0x2c/0x80
[  741.004361]  [<c110dce9>] ? __alloc_fd+0x69/0x100
[  741.060618]  [<c110276b>] ? getname_flags+0x7b/0x100
[  741.119991]  [<c10f4c3f>] do_sys_open+0x10f/0x210
[  741.176246]  [<c10f4d5d>] SyS_open+0x1d/0x20
[  741.227304]  [<c138070c>] sysenter_do_call+0x12/0x12


-- 
Meelis Roos (mroos@linux.ee)
