From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: READ CAPACITY(16) failed, failure in mpt2sas_transport_port_add
Date: Wed, 25 Jan 2012 12:27:25 +1030
Message-ID: <20120125015725.GA2938@tuon>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33146 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab2AYEvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 23:51:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I wonder if someone can tell me what's going on with this new SAS
controller. I swapped out my old Marvell based controller for a new
Intel RS25GB008 and it seems that it never detects all the disks
correctly (there are 4 attached to this controller).

Trying to pull out the relevant bits of dmesg (full version attached):

[    4.197386] mpt2sas version 10.100.00.00 loaded
[    4.197501] scsi2 : Fusion MPT SAS Host
[    4.197825] mpt2sas 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.197835] mpt2sas 0000:01:00.0: setting latency timer to 64
[    4.197840] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (8146696 kB)
[    4.197933] mpt2sas 0000:01:00.0: irq 47 for MSI/MSI-X
[    4.197938] mpt2sas 0000:01:00.0: irq 48 for MSI/MSI-X
[    4.197943] mpt2sas 0000:01:00.0: irq 49 for MSI/MSI-X
[    4.197948] mpt2sas 0000:01:00.0: irq 50 for MSI/MSI-X
[    4.197981] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 47
[    4.197983] mpt2sas0-msix1: PCI-MSI-X enabled: IRQ 48
[    4.197984] mpt2sas0-msix2: PCI-MSI-X enabled: IRQ 49
[    4.197986] mpt2sas0-msix3: PCI-MSI-X enabled: IRQ 50
[    4.197987] mpt2sas0: iomem(0x00000000dfef0000), mapped(0xffffc900122e0000), size(65536)
[    4.197989] mpt2sas0: ioport(0x000000000000de00), size(256)
[    4.440008] mpt2sas0: sending message unit reset !!
[    4.446683] mpt2sas0: message unit reset: SUCCESS
[    4.590327] mpt2sas0: Allocated physical memory: size(11195 kB)
[    4.590330] mpt2sas0: Current Controller Queue Depth(4859), Max Controller Queue Depth(5120)
[    4.590332] mpt2sas0: Scatter Gather Elements per IO(128)
[    4.790353] mpt2sas0: LSISAS2308: FWVersion(09.00.00.00), ChipRevision(0x01), BiosVersion(07.17.03.00)
[    4.790356] mpt2sas0: Intel(R) RAID Controller RS25GB008
[    4.790358] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    4.790423] mpt2sas0: sending port enable !!
[    4.792873] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b003f34c80), phys(8)
[    4.803344] mpt2sas0: port enable: SUCCESS
[    4.814391] scsi 2:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A80 PQ: 0 ANSI: 5
[    4.814397] scsi 2:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), phy(0), device_name(0x4ee250019f620672)
[    4.814400] scsi 2:0:0:0: SATA: enclosure_logical_id(0x500605b003f34c80), slot(0)
[    4.814489] scsi 2:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.814498] scsi 2:0:0:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[    4.820459] sd 2:0:0:0: [sdc] physical block alignment offset: 4096
[    4.820465] sd 2:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    4.820468] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    4.829459] scsi 2:0:1:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A80 PQ: 0 ANSI: 5
[    4.829465] scsi 2:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221101000000), phy(1), device_name(0x4ee250010e9c0673)
[    4.829468] scsi 2:0:1:0: SATA: enclosure_logical_id(0x500605b003f34c80), slot(1)
[    4.829546] scsi 2:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.829551] scsi 2:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[    4.837538] sd 2:0:1:0: [sdd] physical block alignment offset: 4096
[    4.837543] sd 2:0:1:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    4.837545] sd 2:0:1:0: [sdd] 4096-byte physical blocks
[    4.844069] scsi 2:0:2:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A80 PQ: 0 ANSI: 5
[    4.844075] scsi 2:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221102000000), phy(2), device_name(0x4ee25001c81a5bc7)
[    4.844078] scsi 2:0:2:0: SATA: enclosure_logical_id(0x500605b003f34c80), slot(2)
[    4.844153] scsi 2:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.844158] scsi 2:0:2:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[    4.851179] sd 2:0:2:0: [sde] physical block alignment offset: 4096
[    4.851184] sd 2:0:2:0: [sde] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    4.851186] sd 2:0:2:0: [sde] 4096-byte physical blocks
[    4.851459] sd 2:0:0:0: [sdc] Write Protect is off
[    4.851463] sd 2:0:0:0: [sdc] Mode Sense: 7f 00 00 08
[    4.857728] scsi 2:0:3:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A80 PQ: 0 ANSI: 5
[    4.857734] scsi 2:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221103000000), phy(3), device_name(0x4ee250010d1e0673)
[    4.857737] scsi 2:0:3:0: SATA: enclosure_logical_id(0x500605b003f34c80), slot(3)
[    4.857809] scsi 2:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.857814] scsi 2:0:3:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[    4.858145]  port-2:0: remove: sas_addr(0x4433221100000000)
[    4.858154]  port-2:0: remove: sas_addr(0x4433221100000000), phy(0)
[    4.862435] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.862589] sd 2:0:0:0: [sdc] READ CAPACITY(16) failed
[    4.862592] sd 2:0:0:0: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[    4.862594] sd 2:0:0:0: [sdc] Sense not available.
[    4.862623] sd 2:0:0:0: [sdc] READ CAPACITY failed
[    4.862626] sd 2:0:0:0: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[    4.862628] sd 2:0:0:0: [sdc] Sense not available.
[    4.862655] sd 2:0:0:0: [sdc] Asking for cache data failed
[    4.862902] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    4.863127] sdc: detected capacity change from 3000592982016 to 0
[    4.863199] sd 2:0:0:0: [sdc] READ CAPACITY(16) failed
[    4.863201] sd 2:0:0:0: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[    4.863203] sd 2:0:0:0: [sdc] Sense not available.
[    4.863222] sd 2:0:0:0: [sdc] READ CAPACITY failed
[    4.863223] sd 2:0:0:0: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[    4.863226] sd 2:0:0:0: [sdc] Sense not available.
[    4.863251] sd 2:0:0:0: [sdc] Asking for cache data failed
[    4.863477] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    4.863702] sd 2:0:0:0: [sdc] Attached SCSI disk
[    4.864690] sd 2:0:3:0: [sdf] physical block alignment offset: 4096
[    4.864695] sd 2:0:3:0: [sdf] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    4.864698] sd 2:0:3:0: [sdf] 4096-byte physical blocks
[    4.876736] sd 2:0:1:0: [sdd] Write Protect is off
[    4.876740] sd 2:0:1:0: [sdd] Mode Sense: 7f 00 00 08
[    4.885584] sd 2:0:2:0: [sde] Write Protect is off
[    4.885588] sd 2:0:2:0: [sde] Mode Sense: 7f 00 00 08
[    4.891538] sd 2:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.897125] sd 2:0:3:0: [sdf] Write Protect is off
[    4.897129] sd 2:0:3:0: [sdf] Mode Sense: 7f 00 00 08
[    4.900113] sd 2:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.910240] sd 2:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.974155]  sdf: sdf1
[    4.975438]  sdd: sdd1
[    4.983617]  sde: sde1
[    5.026685] sd 2:0:3:0: [sdf] Attached SCSI disk
[    5.032538] sd 2:0:1:0: [sdd] Attached SCSI disk
[    5.039178] sd 2:0:2:0: [sde] Attached SCSI disk
[    5.039528] mpt2sas0: removing handle(0x0009), sas_addr(0x4433221100000000)
[    5.039532] mpt2sas0: failure at drivers/scsi/mpt2sas/mpt2sas_transport.c:705/mpt2sas_transport_port_add()!

Usually if I hot-unplug and re-plug the disk in question it will be
detected properly, but next reboot I have the same problem again.

Does anything there point towards a hardware/software problem? I
notice there's a newer RS25GB008 bios available, though I'll need to
source a UEFI board in order to install it.

Thanks,
Kevin.

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mpt2sas.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.1-1-ARCH (tobias@T-POWA-LX) (gcc version 4.6.2 20111223 (prerelease) (GCC) ) #1 SMP PREEMPT Fri Jan 13 06:50:31 CET 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-linux root=UUID=5515e1a5-fb53-4e28-984b-d242814b1aaf ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bdce0000 (usable)
[    0.000000]  BIOS-e820: 00000000bdce0000 - 00000000bdce3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdce3000 - 00000000bdcf0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdcf0000 - 00000000bdd00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. G41MT-S2P/G41MT-S2P, BIOS F3 05/30/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   2 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   3 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask FC0000000 write-back
[    0.000000]   6 base 0BDD00000 mask FFFF00000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bdd00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbdce0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f5210] f5210
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdce0000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000]  00bdc00000 - 00bdce0000 page 4k
[    0.000000] kernel direct mapping tables up to bdce0000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000240000000
[    0.000000]  0100000000 - 0240000000 page 2M
[    0.000000] kernel direct mapping tables up to 240000000 @ bdcd6000-bdce0000
[    0.000000] RAMDISK: 37896000 - 37c43000
[    0.000000] ACPI: RSDP 00000000000f6c70 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000bdce3040 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000bdce30c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000bdce3180 04195 (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000bdce0000 00040
[    0.000000] ACPI: HPET 00000000bdce7480 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000bdce7500 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: TAMG 00000000bdce7540 06352 (v01 GBT    GBT   B0 5455312E BG?? 00020101)
[    0.000000] ACPI: APIC 00000000bdce7380 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000bdcee1e0 003AB (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000240000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000240000000
[    0.000000]   NODE_DATA [000000023fffb000 - 000000023fffffff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237600000-ffff88023f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00240000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bdce0
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000] On node 0 totalpages: 2088046
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 757024 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1290240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bdce0000 - 00000000bdce3000
[    0.000000] PM: Registered nosave memory: 00000000bdce3000 - 00000000bdcf0000
[    0.000000] PM: Registered nosave memory: 00000000bdcf0000 - 00000000bdd00000
[    0.000000] PM: Registered nosave memory: 00000000bdd00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bdd00000 (gap: bdd00000:22300000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88023fc00000 s82048 r8192 d24448 u524288
[    0.000000] pcpu-alloc: s82048 r8192 d24448 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2051177
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-linux root=UUID=5515e1a5-fb53-4e28-984b-d242814b1aaf ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8139660k/9437184k available (4279k kernel code, 1085000k absent, 212524k reserved, 4601k data, 728k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2666.967 MHz processor.
[    0.003337] Calibrating delay loop (skipped), value calculated using timer frequency.. 5336.18 BogoMIPS (lpj=8889890)
[    0.003340] pid_max: default: 32768 minimum: 301
[    0.003362] Security Framework initialized
[    0.003367] AppArmor: AppArmor disabled by boot time parameter
[    0.007195] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.010429] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011915] Mount-cache hash table entries: 256
[    0.012048] Initializing cgroup subsys cpuacct
[    0.012054] Initializing cgroup subsys memory
[    0.012061] Initializing cgroup subsys devices
[    0.012063] Initializing cgroup subsys freezer
[    0.012064] Initializing cgroup subsys net_cls
[    0.012066] Initializing cgroup subsys blkio
[    0.012097] CPU: Physical Processor ID: 0
[    0.012098] CPU: Processor Core ID: 0
[    0.012100] mce: CPU supports 6 MCE banks
[    0.012107] CPU0: Thermal monitoring enabled (TM2)
[    0.012111] using mwait in idle threads.
[    0.013188] ACPI: Core revision 20110623
[    0.015356] ftrace: allocating 16773 entries in 66 pages
[    0.017052] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.051280] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
[    0.053330] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.053330] ... version:                2
[    0.053330] ... bit width:              40
[    0.053330] ... generic registers:      2
[    0.053330] ... value mask:             000000ffffffffff
[    0.053330] ... max period:             000000007fffffff
[    0.053330] ... fixed-purpose events:   3
[    0.053330] ... event mask:             0000000700000003
[    0.070120] NMI watchdog enabled, takes one hw-pmu counter.
[    0.096674] Booting Node   0, Processors  #1
[    0.096677] smpboot cpu 1: start_ip = 99000
[    0.193348] NMI watchdog enabled, takes one hw-pmu counter.
[    0.213349]  #2
[    0.213351] smpboot cpu 2: start_ip = 99000
[    0.309997] NMI watchdog enabled, takes one hw-pmu counter.
[    0.329996]  #3 Ok.
[    0.329998] smpboot cpu 3: start_ip = 99000
[    0.426656] NMI watchdog enabled, takes one hw-pmu counter.
[    0.433310] Brought up 4 CPUs
[    0.433313] Total of 4 processors activated (21342.39 BogoMIPS).
[    0.436801] devtmpfs: initialized
[    0.440441] PM: Registering ACPI NVS region at bdce0000 (12288 bytes)
[    0.440661] print_constraints: dummy: 
[    0.440702] NET: Registered protocol family 16
[    0.440802] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.440805] ACPI: bus type pci registered
[    0.440862] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.440864] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.477147] PCI: Using configuration type 1 for base access
[    0.477645] bio: create slab <bio-0> at 0
[    0.477645] ACPI: Added _OSI(Module Device)
[    0.477645] ACPI: Added _OSI(Processor Device)
[    0.477645] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.477645] ACPI: Added _OSI(Processor Aggregator Device)
[    0.477645] ACPI: EC: Look up EC in DSDT
[    0.480607] ACPI Warning: Incorrect checksum in table [TAMG] - 0xE7, should be 0xE6 (20110623/tbutils-314)
[    0.480700] ACPI: SSDT 00000000bdced900 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.480834] ACPI: Dynamic OEM Table Load:
[    0.480837] ACPI: SSDT           (null) 0022A (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.480921] ACPI: SSDT 00000000bdceddc0 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.481053] ACPI: Dynamic OEM Table Load:
[    0.481056] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
[    0.481143] ACPI: SSDT 00000000bdcedf20 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.481272] ACPI: Dynamic OEM Table Load:
[    0.481275] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
[    0.481360] ACPI: SSDT 00000000bdcee080 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.481490] ACPI: Dynamic OEM Table Load:
[    0.481492] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
[    0.481584] ACPI: Interpreter enabled
[    0.481587] ACPI: (supports S0 S3 S4 S5)
[    0.481600] ACPI: Using IOAPIC for interrupt routing
[    0.484506] ACPI: No dock devices found.
[    0.484508] HEST: Table not found.
[    0.484511] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.484550] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.484640] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.484642] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.484644] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.484646] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.484648] pci_root PNP0A03:00: host bridge window [mem 0xbdd00000-0xfebfffff]
[    0.484657] pci 0000:00:00.0: [8086:2e30] type 0 class 0x000600
[    0.484688] pci 0000:00:01.0: [8086:2e31] type 1 class 0x000604
[    0.484711] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.484713] pci 0000:00:01.0: PME# disabled
[    0.484725] pci 0000:00:02.0: [8086:2e32] type 0 class 0x000300
[    0.484734] pci 0000:00:02.0: reg 10: [mem 0xdf400000-0xdf7fffff 64bit]
[    0.484740] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.484745] pci 0000:00:02.0: reg 20: [io  0xff00-0xff07]
[    0.484792] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.484804] pci 0000:00:1b.0: reg 10: [mem 0xdfff8000-0xdfffbfff 64bit]
[    0.484849] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.484852] pci 0000:00:1b.0: PME# disabled
[    0.484868] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.484913] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.484916] pci 0000:00:1c.0: PME# disabled
[    0.484934] pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
[    0.484978] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.484982] pci 0000:00:1c.2: PME# disabled
[    0.485002] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.485035] pci 0000:00:1d.0: reg 20: [io  0xfe00-0xfe1f]
[    0.485059] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.485092] pci 0000:00:1d.1: reg 20: [io  0xfd00-0xfd1f]
[    0.485116] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.485150] pci 0000:00:1d.2: reg 20: [io  0xfc00-0xfc1f]
[    0.485173] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.485207] pci 0000:00:1d.3: reg 20: [io  0xfb00-0xfb1f]
[    0.485237] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.485251] pci 0000:00:1d.7: reg 10: [mem 0xdffff000-0xdffff3ff]
[    0.485316] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.485362] pci 0000:00:1f.0: [8086:27b8] type 0 class 0x000601
[    0.485432] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 000f)
[    0.485436] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 000f)
[    0.485465] pci 0000:00:1f.2: [8086:27c0] type 0 class 0x000101
[    0.485476] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.485483] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.485489] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.485496] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.485503] pci 0000:00:1f.2: reg 20: [io  0xf800-0xf80f]
[    0.485526] pci 0000:00:1f.2: PME# supported from D3hot
[    0.485529] pci 0000:00:1f.2: PME# disabled
[    0.485541] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.485585] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.485640] pci 0000:01:00.0: [1000:0087] type 0 class 0x000107
[    0.485650] pci 0000:01:00.0: reg 10: [io  0xde00-0xdeff]
[    0.485661] pci 0000:01:00.0: reg 14: [mem 0xdfef0000-0xdfefffff 64bit]
[    0.485672] pci 0000:01:00.0: reg 1c: [mem 0xdfe80000-0xdfebffff 64bit]
[    0.485685] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x000fffff pref]
[    0.485707] pci 0000:01:00.0: supports D1 D2
[    0.485726] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.485728] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.485731] pci 0000:00:01.0:   bridge window [mem 0xdfd00000-0xdfefffff]
[    0.485789] pci 0000:02:00.0: [8086:10d3] type 0 class 0x000200
[    0.485811] pci 0000:02:00.0: reg 10: [mem 0xdfcc0000-0xdfcdffff]
[    0.485827] pci 0000:02:00.0: reg 14: [mem 0xdfc00000-0xdfc7ffff]
[    0.485843] pci 0000:02:00.0: reg 18: [io  0xcf00-0xcf1f]
[    0.485860] pci 0000:02:00.0: reg 1c: [mem 0xdfcfc000-0xdfcfffff]
[    0.485905] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0003ffff pref]
[    0.485954] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.485960] pci 0000:02:00.0: PME# disabled
[    0.485998] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.486001] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.486004] pci 0000:00:1c.0:   bridge window [mem 0xdfc00000-0xdfcfffff]
[    0.486055] pci 0000:03:00.0: [1969:1073] type 0 class 0x000200
[    0.486076] pci 0000:03:00.0: reg 10: [mem 0xdfbc0000-0xdfbfffff 64bit]
[    0.486087] pci 0000:03:00.0: reg 18: [io  0xbf00-0xbf7f]
[    0.486157] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.486162] pci 0000:03:00.0: PME# disabled
[    0.486188] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.486191] pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
[    0.486194] pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff]
[    0.486248] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.486256] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.486258] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.486260] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.486262] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.486264] pci 0000:00:1e.0:   bridge window [mem 0xbdd00000-0xfebfffff] (subtractive decode)
[    0.486279] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.486353] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.486377] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.486402] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.486443]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.486446]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.486448] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.491471] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.491508] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.491549] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
[    0.491587] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.491623] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.491659] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.491695] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.491732] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.491818] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.491818] vgaarb: loaded
[    0.491818] vgaarb: bridge control possible 0000:00:02.0
[    0.491818] PCI: Using ACPI for IRQ routing
[    0.496929] PCI: pci_cache_line_size set to 64 bytes
[    0.496983] reserve RAM buffer: 000000000009e400 - 000000000009ffff 
[    0.496985] reserve RAM buffer: 00000000bdce0000 - 00000000bfffffff 
[    0.497070] NetLabel: Initializing
[    0.497071] NetLabel:  domain hash size = 128
[    0.497073] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.497083] NetLabel:  unlabeled traffic allowed by default
[    0.497096] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.497099] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.497103] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.513371] Switching to clocksource hpet
[    0.518851] pnp: PnP ACPI init
[    0.518863] ACPI: bus type pnp registered
[    0.518923] pnp 00:00: [bus 00-ff]
[    0.518925] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.518927] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.518928] pnp 00:00: [io  0x0d00-0xffff window]
[    0.518930] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.518932] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.518934] pnp 00:00: [mem 0xbdd00000-0xfebfffff window]
[    0.518975] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.519018] pnp 00:01: [io  0x0010-0x001f]
[    0.519020] pnp 00:01: [io  0x0022-0x003f]
[    0.519021] pnp 00:01: [io  0x0044-0x005f]
[    0.519023] pnp 00:01: [io  0x0062-0x0063]
[    0.519024] pnp 00:01: [io  0x0065-0x006f]
[    0.519026] pnp 00:01: [io  0x0074-0x007f]
[    0.519027] pnp 00:01: [io  0x0091-0x0093]
[    0.519029] pnp 00:01: [io  0x00a2-0x00bf]
[    0.519030] pnp 00:01: [io  0x00e0-0x00ef]
[    0.519032] pnp 00:01: [io  0x04d0-0x04d1]
[    0.519033] pnp 00:01: [io  0x0290-0x029f]
[    0.519035] pnp 00:01: [io  0x0800-0x087f]
[    0.519036] pnp 00:01: [io  0x0290-0x0294]
[    0.519038] pnp 00:01: [io  0x0880-0x088f]
[    0.519084] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.519086] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.519088] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.519090] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.519092] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.519095] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.519105] pnp 00:02: [dma 4]
[    0.519106] pnp 00:02: [io  0x0000-0x000f]
[    0.519108] pnp 00:02: [io  0x0080-0x0090]
[    0.519109] pnp 00:02: [io  0x0094-0x009f]
[    0.519112] pnp 00:02: [io  0x00c0-0x00df]
[    0.519135] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.519171] pnp 00:03: [irq 0 disabled]
[    0.519179] pnp 00:03: [irq 8]
[    0.519180] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.519206] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.519226] pnp 00:04: [io  0x0070-0x0073]
[    0.519252] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.519259] pnp 00:05: [io  0x0061]
[    0.519284] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.519291] pnp 00:06: [io  0x00f0-0x00ff]
[    0.519296] pnp 00:06: [irq 13]
[    0.519321] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.519495] pnp 00:07: [io  0x03f8-0x03ff]
[    0.519500] pnp 00:07: [irq 4]
[    0.519551] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.519682] pnp 00:08: [io  0x0378-0x037f]
[    0.519687] pnp 00:08: [irq 7]
[    0.519730] pnp 00:08: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.519811] pnp 00:09: [io  0x0400-0x047f]
[    0.519848] system 00:09: [io  0x0400-0x047f] has been reserved
[    0.519850] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.519978] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.520038] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.520041] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.520154] pnp 00:0b: [mem 0x000d7000-0x000d7fff]
[    0.520156] pnp 00:0b: [mem 0x000f0000-0x000f7fff]
[    0.520157] pnp 00:0b: [mem 0x000f8000-0x000fbfff]
[    0.520159] pnp 00:0b: [mem 0x000fc000-0x000fffff]
[    0.520160] pnp 00:0b: [mem 0xbdce0000-0xbdceffff]
[    0.520162] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[    0.520163] pnp 00:0b: [mem 0x00100000-0xbdcdffff]
[    0.520165] pnp 00:0b: [mem 0xbdcf0000-0xbdcfffff]
[    0.520167] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.520168] pnp 00:0b: [mem 0xfed13000-0xfed1dfff]
[    0.520170] pnp 00:0b: [mem 0xfed20000-0xfed8ffff]
[    0.520171] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.520173] pnp 00:0b: [mem 0xffb00000-0xffb7ffff]
[    0.520174] pnp 00:0b: [mem 0xfff00000-0xffffffff]
[    0.520176] pnp 00:0b: [mem 0x000e0000-0x000effff]
[    0.520191] pnp 00:0b: disabling [mem 0x000d7000-0x000d7fff] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[    0.520194] pnp 00:0b: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[    0.520196] pnp 00:0b: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[    0.520199] pnp 00:0b: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[    0.520202] pnp 00:0b: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[    0.520205] pnp 00:0b: disabling [mem 0x000e0000-0x000effff] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[    0.520245] system 00:0b: [mem 0xbdce0000-0xbdceffff] could not be reserved
[    0.520247] system 00:0b: [mem 0x00100000-0xbdcdffff] could not be reserved
[    0.520250] system 00:0b: [mem 0xbdcf0000-0xbdcfffff] has been reserved
[    0.520252] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.520254] system 00:0b: [mem 0xfed13000-0xfed1dfff] has been reserved
[    0.520256] system 00:0b: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.520258] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.520261] system 00:0b: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.520263] system 00:0b: [mem 0xfff00000-0xffffffff] has been reserved
[    0.520265] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.520282] pnp 00:0c: [mem 0xffb80000-0xffbfffff]
[    0.520314] pnp 00:0c: Plug and Play ACPI device, IDs INT0800 (active)
[    0.520319] pnp: PnP ACPI: found 13 devices
[    0.520320] ACPI: ACPI bus type pnp unregistered
[    0.528892] PCI: max bus depth: 1 pci_try_num: 2
[    0.528917] pci 0000:00:01.0: BAR 15: assigned [mem 0xbdd00000-0xbddfffff pref]
[    0.528921] pci 0000:00:1c.0: BAR 15: assigned [mem 0xbde00000-0xbdefffff pref]
[    0.528924] pci 0000:00:1c.2: BAR 15: assigned [mem 0xbdf00000-0xbe0fffff 64bit pref]
[    0.528928] pci 0000:00:1c.0: BAR 15: assigned [mem 0xbe100000-0xbe3fffff pref]
[    0.528931] pci 0000:01:00.0: BAR 6: assigned [mem 0xbdd00000-0xbddfffff pref]
[    0.528933] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.528935] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.528938] pci 0000:00:01.0:   bridge window [mem 0xdfd00000-0xdfefffff]
[    0.528940] pci 0000:00:01.0:   bridge window [mem 0xbdd00000-0xbddfffff pref]
[    0.528944] pci 0000:02:00.0: BAR 6: assigned [mem 0xbe100000-0xbe13ffff pref]
[    0.528946] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.528948] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.528952] pci 0000:00:1c.0:   bridge window [mem 0xdfc00000-0xdfcfffff]
[    0.528955] pci 0000:00:1c.0:   bridge window [mem 0xbe100000-0xbe3fffff pref]
[    0.528960] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
[    0.528963] pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
[    0.528967] pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff]
[    0.528970] pci 0000:00:1c.2:   bridge window [mem 0xbdf00000-0xbe0fffff 64bit pref]
[    0.528975] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    0.528991] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.528995] pci 0000:00:01.0: setting latency timer to 64
[    0.529000] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.529003] pci 0000:00:1c.0: setting latency timer to 64
[    0.529010] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.529014] pci 0000:00:1c.2: setting latency timer to 64
[    0.529019] pci 0000:00:1e.0: setting latency timer to 64
[    0.529022] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.529024] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.529026] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.529028] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.529030] pci_bus 0000:00: resource 8 [mem 0xbdd00000-0xfebfffff]
[    0.529032] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.529034] pci_bus 0000:01: resource 1 [mem 0xdfd00000-0xdfefffff]
[    0.529036] pci_bus 0000:01: resource 2 [mem 0xbdd00000-0xbddfffff pref]
[    0.529037] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.529039] pci_bus 0000:02: resource 1 [mem 0xdfc00000-0xdfcfffff]
[    0.529041] pci_bus 0000:02: resource 2 [mem 0xbe100000-0xbe3fffff pref]
[    0.529043] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
[    0.529045] pci_bus 0000:03: resource 1 [mem 0xdfb00000-0xdfbfffff]
[    0.529047] pci_bus 0000:03: resource 2 [mem 0xbdf00000-0xbe0fffff 64bit pref]
[    0.529049] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.529051] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.529052] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.529054] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000dffff]
[    0.529056] pci_bus 0000:04: resource 8 [mem 0xbdd00000-0xfebfffff]
[    0.529084] NET: Registered protocol family 2
[    0.529267] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.530332] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.533166] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.533568] TCP: Hash tables configured (established 524288 bind 65536)
[    0.533571] TCP reno registered
[    0.533585] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.533641] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.533785] NET: Registered protocol family 1
[    0.533802] pci 0000:00:02.0: Boot video device
[    0.546711] PCI: CLS 4 bytes, default 64
[    0.546773] Unpacking initramfs...
[    0.594006] Freeing initrd memory: 3764k freed
[    0.594812] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.594815] Placing 64MB software IO TLB between ffff8800b9cd6000 - ffff8800bdcd6000
[    0.594817] software IO TLB at phys 0xb9cd6000 - 0xbdcd6000
[    0.595318] audit: initializing netlink socket (disabled)
[    0.595328] type=2000 audit(1327395304.593:1): initialized
[    0.615299] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.654338] VFS: Disk quotas dquot_6.5.2
[    0.654393] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.654472] msgmni has been set to 15905
[    0.654702] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.654757] io scheduler noop registered
[    0.654758] io scheduler deadline registered
[    0.654791] io scheduler cfq registered (default)
[    0.654879] pcieport 0000:00:01.0: setting latency timer to 64
[    0.654904] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.654944] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.654974] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.655024] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.655054] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.655170] vesafb: mode is 1920x1440x32, linelength=7680, pages=0
[    0.655171] vesafb: scrolling: redraw
[    0.655173] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.656770] vesafb: framebuffer at 0xc0000000, mapped to 0xffffc90011800000, using 10816k, total 10816k
[    0.723942] Console: switching to colour frame buffer device 240x90
[    0.790914] fb0: VESA VGA frame buffer device
[    0.790925] intel_idle: MWAIT substates: 0x20
[    0.790927] intel_idle: does not run on family 6 model 23
[    0.790950] ERST: Table is not found!
[    0.790952] GHES: HEST is not enabled!
[    0.791026] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.811509] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.020588] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.080192] Linux agpgart interface v0.103
[    1.080270] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.113901] i8042: Failed to disable AUX port, but continuing anyway... Is this a SiS?
[    1.113902] i8042: If AUX port is really absent please use the 'i8042.noaux' option
[    1.363433] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.363572] mousedev: PS/2 mouse device common for all mice
[    1.363642] rtc_cmos 00:04: RTC can wake from S4
[    1.363766] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.363787] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.363795] cpuidle: using governor ladder
[    1.363797] cpuidle: using governor menu
[    1.363990] TCP cubic registered
[    1.363993] NET: Registered protocol family 17
[    1.364000] Registering the dns_resolver key type
[    1.364168] PM: Hibernation image not present or could not be loaded.
[    1.364172] registered taskstats version 1
[    1.383140] rtc_cmos 00:04: setting system clock to 2012-01-24 08:55:05 UTC (1327395305)
[    1.383178] Initializing network drop monitor service
[    1.384355] Freeing unused kernel memory: 728k freed
[    1.384478] Write protecting the kernel read-only data: 8192k
[    1.389776] Freeing unused kernel memory: 1848k freed
[    1.392101] Freeing unused kernel memory: 696k freed
[    1.399139] udevd[48]: starting version 175
[    1.422953] usbcore: registered new interface driver usbfs
[    1.422976] usbcore: registered new interface driver hub
[    1.427438] usbcore: registered new device driver usb
[    1.432232] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.433277] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.433301] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.433304] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.433324] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.433360] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.437256] ehci_hcd 0000:00:1d.7: cache line size of 4 is not supported
[    1.437265] SCSI subsystem initialized
[    1.437272] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdffff000
[    1.441152] libata version 3.00 loaded.
[    1.450053] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.450216] hub 1-0:1.0: USB hub found
[    1.450220] hub 1-0:1.0: 8 ports detected
[    1.450310] ata_piix 0000:00:1f.2: version 2.13
[    1.450337] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.450342] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.450378] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.450666] scsi0 : ata_piix
[    1.450743] scsi1 : ata_piix
[    1.451099] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf800 irq 14
[    1.451101] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf808 irq 15
[    1.451638] uhci_hcd: USB Universal Host Controller Interface driver
[    1.451672] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.451679] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.451682] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.451690] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.451713] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fe00
[    1.451840] hub 2-0:1.0: USB hub found
[    1.451843] hub 2-0:1.0: 2 ports detected
[    1.451901] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.451906] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.451908] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.451914] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.451942] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fd00
[    1.452049] hub 3-0:1.0: USB hub found
[    1.452053] hub 3-0:1.0: 2 ports detected
[    1.452106] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.452110] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.452113] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.452119] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.452145] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fc00
[    1.452261] hub 4-0:1.0: USB hub found
[    1.452268] hub 4-0:1.0: 2 ports detected
[    1.452330] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    1.452334] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.452337] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.452343] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.452369] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000fb00
[    1.452483] hub 5-0:1.0: USB hub found
[    1.452486] hub 5-0:1.0: 2 ports detected
[    1.596683] Refined TSC clocksource calibration: 2666.615 MHz.
[    1.596688] Switching to clocksource tsc
[    1.611715] ata2.00: ATA-6: WDC WD2500JD-00GBB0, 02.05D02, max UDMA/100
[    1.611719] ata2.00: 488397168 sectors, multi 16: LBA48 
[    1.611723] ata2.00: applying bridge limits
[    1.619509] ata1.00: ATA-7: WDC WD2500YS-01SHB0, 20.06C03, max UDMA/133
[    1.619512] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.624574] ata1.00: configured for UDMA/133
[    1.624682] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500YS-01S 20.0 PQ: 0 ANSI: 5
[    1.625055] ata2.00: configured for UDMA/100
[    1.625176] scsi 1:0:0:0: Direct-Access     ATA      WDC WD2500JD-00G 02.0 PQ: 0 ANSI: 5
[    1.629489] sd 0:0:0:0: [sda] 490234752 512-byte logical blocks: (251 GB/233 GiB)
[    1.629534] sd 0:0:0:0: [sda] Write Protect is off
[    1.629537] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.629558] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.629564] sd 1:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.629616] sd 1:0:0:0: [sdb] Write Protect is off
[    1.629620] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.629644] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.633360]  sda: sda1 sda2 sda3 sda4
[    1.633683] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.648677]  sdb: sdb1 sdb2 sdb3 sdb4
[    1.649076] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.912099] md: md0 stopped.
[    1.913118] md: bind<sdb1>
[    1.913312] md: bind<sda1>
[    1.915357] md: raid1 personality registered for level 1
[    1.915579] bio: create slab <bio-1> at 1
[    1.915651] md/raid1:md0: active with 2 out of 2 mirrors
[    1.915798] created bitmap (1 pages) for device md0
[    1.915955] md0: bitmap initialized from disk: read 1/1 pages, set 0 of 3 bits
[    1.933489] md0: detected capacity change from 0 to 157274112
[    1.933994]  md0: unknown partition table
[    1.967547] md: md1 stopped.
[    1.968573] md: bind<sdb2>
[    1.968769] md: bind<sda2>
[    1.969759] md/raid1:md1: active with 2 out of 2 mirrors
[    1.969909] created bitmap (1 pages) for device md1
[    1.970057] md1: bitmap initialized from disk: read 1/1 pages, set 0 of 240 bits
[    2.009440] md1: detected capacity change from 0 to 16105005056
[    2.017601]  md1: unknown partition table
[    2.045471] md: md2 stopped.
[    2.046787] md: bind<sdb3>
[    2.046989] md: bind<sda3>
[    2.047708] md/raid1:md2: active with 2 out of 2 mirrors
[    2.047849] created bitmap (1 pages) for device md2
[    2.047999] md2: bitmap initialized from disk: read 1/1 pages, set 0 of 32 bits
[    2.065307] md2: detected capacity change from 0 to 2146422784
[    2.072142]  md2: unknown partition table
[    2.073347] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[    2.090174] md: md3 stopped.
[    2.091207] md: bind<sdb4>
[    2.091443] md: bind<sda4>
[    2.092181] md/raid1:md3: active with 2 out of 2 mirrors
[    2.092313] created bitmap (2 pages) for device md3
[    2.092486] md3: bitmap initialized from disk: read 1/1 pages, set 0 of 3452 bits
[    2.145827] md3: detected capacity change from 0 to 231646216192
[    2.147324]  md3: unknown partition table
[    2.150861] device-mapper: uevent: version 1.0.3
[    2.151094] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    2.217455] hub 5-2:1.0: USB hub found
[    2.219406] hub 5-2:1.0: 4 ports detected
[    2.498403] usb 5-2.1: new low-speed USB device number 3 using uhci_hcd
[    2.555934] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[    3.906779] udevd[252]: starting version 178
[    4.071694] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    4.097435] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.097497] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    4.097516] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    4.121316] intel_rng: FWH not detected
[    4.139224] atl1c 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.139233] atl1c 0000:03:00.0: setting latency timer to 64
[    4.146998] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    4.147000] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.147021] e1000e 0000:02:00.0: Disabling ASPM L0s 
[    4.147033] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.147050] e1000e 0000:02:00.0: setting latency timer to 64
[    4.147239] e1000e 0000:02:00.0: irq 44 for MSI/MSI-X
[    4.147244] e1000e 0000:02:00.0: irq 45 for MSI/MSI-X
[    4.147249] e1000e 0000:02:00.0: irq 46 for MSI/MSI-X
[    4.163553] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    4.163682] ACPI: Power Button [PWRB]
[    4.163743] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    4.163808] ACPI: Power Button [PWRF]
[    4.179084] IT8718 SuperIO detected.
[    4.179331] parport_pc 00:08: reported by Plug and Play ACPI
[    4.179370] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    4.186219] [drm] Initialized drm 1.1.0 20060810
[    4.194334] leds_ss4200: no LED devices found
[    4.197386] mpt2sas version 10.100.00.00 loaded
[    4.197501] scsi2 : Fusion MPT SAS Host
[    4.197825] mpt2sas 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.197835] mpt2sas 0000:01:00.0: setting latency timer to 64
[    4.197840] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (8146696 kB)
[    4.197933] mpt2sas 0000:01:00.0: irq 47 for MSI/MSI-X
[    4.197938] mpt2sas 0000:01:00.0: irq 48 for MSI/MSI-X
[    4.197943] mpt2sas 0000:01:00.0: irq 49 for MSI/MSI-X
[    4.197948] mpt2sas 0000:01:00.0: irq 50 for MSI/MSI-X
[    4.197981] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 47
[    4.197983] mpt2sas0-msix1: PCI-MSI-X enabled: IRQ 48
[    4.197984] mpt2sas0-msix2: PCI-MSI-X enabled: IRQ 49
[    4.197986] mpt2sas0-msix3: PCI-MSI-X enabled: IRQ 50
[    4.197987] mpt2sas0: iomem(0x00000000dfef0000), mapped(0xffffc900122e0000), size(65536)
[    4.197989] mpt2sas0: ioport(0x000000000000de00), size(256)
[    4.209983] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.210176] agpgart-intel 0000:00:00.0: Intel G41 Chipset
[    4.210301] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    4.212376] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    4.212735] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    4.244401] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.244405] i915 0000:00:02.0: setting latency timer to 64
[    4.251606] e1000e 0000:02:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1b:21:d5:65:e3
[    4.251609] e1000e 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    4.251622] e1000e 0000:02:00.0: eth0: MAC: 3, PHY: 8, PBA No: E46981-006
[    4.253720] atl1c 0000:03:00.0: version 1.0.1.0-NAPI
[    4.283580] mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
[    4.283582] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    4.283861] i915 0000:00:02.0: irq 51 for MSI/MSI-X
[    4.283865] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.283866] [drm] Driver supports precise vblank timestamp query.
[    4.283886] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.303700] ppdev: user-space parallel port driver
[    4.329099] iTCO_vendor_support: vendor-support=0
[    4.330082] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    4.330241] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
[    4.330367] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.407537] checking generic (c0000000 a90000) vs hw (c0000000 10000000)
[    4.407540] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
[    4.407564] Console: switching to colour dummy device 80x25
[    4.408498] fbcon: inteldrmfb (fb0) is primary device
[    4.440008] mpt2sas0: sending message unit reset !!
[    4.446683] mpt2sas0: message unit reset: SUCCESS
[    4.447175] Console: switching to colour frame buffer device 210x65
[    4.487662] input: CHICONY USB NetVista Full Width Keyboard as /devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2.1/5-2.1:1.0/input/input3
[    4.487753] generic-usb 0003:04B3:3025.0001: input,hidraw0: USB HID v1.10 Keyboard [CHICONY USB NetVista Full Width Keyboard] on usb-0000:00:1d.3-2.1/input0
[    4.487769] usbcore: registered new interface driver usbhid
[    4.487770] usbhid: USB HID core driver
[    4.491111] fb0: inteldrmfb frame buffer device
[    4.491112] drm: registered panic notifier
[    4.491160] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.590327] mpt2sas0: Allocated physical memory: size(11195 kB)
[    4.590330] mpt2sas0: Current Controller Queue Depth(4859), Max Controller Queue Depth(5120)
[    4.590332] mpt2sas0: Scatter Gather Elements per IO(128)
[    4.790353] mpt2sas0: LSISAS2308: FWVersion(09.00.00.00), ChipRevision(0x01), BiosVersion(07.17.03.00)
[    4.790356] mpt2sas0: Intel(R) RAID Controller RS25GB008
[    4.790358] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    4.790423] mpt2sas0: sending port enable !!
[    4.792873] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b003f34c80), phys(8)
[    4.803344] mpt2sas0: port enable: SUCCESS
[    4.814391] scsi 2:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A80 PQ: 0 ANSI: 5
[    4.814397] scsi 2:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), phy(0), device_name(0x4ee250019f620672)
[    4.814400] scsi 2:0:0:0: SATA: enclosure_logical_id(0x500605b003f34c80), slot(0)
[    4.814489] scsi 2:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.814498] scsi 2:0:0:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[    4.820459] sd 2:0:0:0: [sdc] physical block alignment offset: 4096
[    4.820465] sd 2:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    4.820468] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    4.829459] scsi 2:0:1:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A80 PQ: 0 ANSI: 5
[    4.829465] scsi 2:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221101000000), phy(1), device_name(0x4ee250010e9c0673)
[    4.829468] scsi 2:0:1:0: SATA: enclosure_logical_id(0x500605b003f34c80), slot(1)
[    4.829546] scsi 2:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.829551] scsi 2:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[    4.837538] sd 2:0:1:0: [sdd] physical block alignment offset: 4096
[    4.837543] sd 2:0:1:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    4.837545] sd 2:0:1:0: [sdd] 4096-byte physical blocks
[    4.844069] scsi 2:0:2:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A80 PQ: 0 ANSI: 5
[    4.844075] scsi 2:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221102000000), phy(2), device_name(0x4ee25001c81a5bc7)
[    4.844078] scsi 2:0:2:0: SATA: enclosure_logical_id(0x500605b003f34c80), slot(2)
[    4.844153] scsi 2:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.844158] scsi 2:0:2:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[    4.851179] sd 2:0:2:0: [sde] physical block alignment offset: 4096
[    4.851184] sd 2:0:2:0: [sde] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    4.851186] sd 2:0:2:0: [sde] 4096-byte physical blocks
[    4.851459] sd 2:0:0:0: [sdc] Write Protect is off
[    4.851463] sd 2:0:0:0: [sdc] Mode Sense: 7f 00 00 08
[    4.857728] scsi 2:0:3:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A80 PQ: 0 ANSI: 5
[    4.857734] scsi 2:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221103000000), phy(3), device_name(0x4ee250010d1e0673)
[    4.857737] scsi 2:0:3:0: SATA: enclosure_logical_id(0x500605b003f34c80), slot(3)
[    4.857809] scsi 2:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.857814] scsi 2:0:3:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[    4.858145]  port-2:0: remove: sas_addr(0x4433221100000000)
[    4.858154]  port-2:0: remove: sas_addr(0x4433221100000000), phy(0)
[    4.862435] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.862589] sd 2:0:0:0: [sdc] READ CAPACITY(16) failed
[    4.862592] sd 2:0:0:0: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[    4.862594] sd 2:0:0:0: [sdc] Sense not available.
[    4.862623] sd 2:0:0:0: [sdc] READ CAPACITY failed
[    4.862626] sd 2:0:0:0: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[    4.862628] sd 2:0:0:0: [sdc] Sense not available.
[    4.862655] sd 2:0:0:0: [sdc] Asking for cache data failed
[    4.862902] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    4.863127] sdc: detected capacity change from 3000592982016 to 0
[    4.863199] sd 2:0:0:0: [sdc] READ CAPACITY(16) failed
[    4.863201] sd 2:0:0:0: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[    4.863203] sd 2:0:0:0: [sdc] Sense not available.
[    4.863222] sd 2:0:0:0: [sdc] READ CAPACITY failed
[    4.863223] sd 2:0:0:0: [sdc]  Result: hostbyte=0x01 driverbyte=0x00
[    4.863226] sd 2:0:0:0: [sdc] Sense not available.
[    4.863251] sd 2:0:0:0: [sdc] Asking for cache data failed
[    4.863477] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    4.863702] sd 2:0:0:0: [sdc] Attached SCSI disk
[    4.864690] sd 2:0:3:0: [sdf] physical block alignment offset: 4096
[    4.864695] sd 2:0:3:0: [sdf] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    4.864698] sd 2:0:3:0: [sdf] 4096-byte physical blocks
[    4.876736] sd 2:0:1:0: [sdd] Write Protect is off
[    4.876740] sd 2:0:1:0: [sdd] Mode Sense: 7f 00 00 08
[    4.885584] sd 2:0:2:0: [sde] Write Protect is off
[    4.885588] sd 2:0:2:0: [sde] Mode Sense: 7f 00 00 08
[    4.891538] sd 2:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.897125] sd 2:0:3:0: [sdf] Write Protect is off
[    4.897129] sd 2:0:3:0: [sdf] Mode Sense: 7f 00 00 08
[    4.900113] sd 2:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.910240] sd 2:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.974155]  sdf: sdf1
[    4.975438]  sdd: sdd1
[    4.983617]  sde: sde1
[    5.026685] sd 2:0:3:0: [sdf] Attached SCSI disk
[    5.032538] sd 2:0:1:0: [sdd] Attached SCSI disk
[    5.039178] sd 2:0:2:0: [sde] Attached SCSI disk
[    5.039528] mpt2sas0: removing handle(0x0009), sas_addr(0x4433221100000000)
[    5.039532] mpt2sas0: failure at drivers/scsi/mpt2sas/mpt2sas_transport.c:705/mpt2sas_transport_port_add()!
[    5.121369] md: bind<sdf1>
[    5.130454] md: bind<sdd1>
[    5.132832] md: bind<sde1>
[   35.097940] EXT4-fs (md1): re-mounted. Opts: (null)

--IS0zKkzwUGydFO0o--
