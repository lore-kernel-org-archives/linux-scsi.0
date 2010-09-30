From: "George Spelvin" <linux@horizon.com>
Subject: 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: 30 Sep 2010 17:10:06 -0400
Message-ID: <20100930211006.27449.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jaxboe@fusionio.com, linux@horizon.com
List-Id: linux-scsi@vger.kernel.org

Supposedly 2c7d46ec192e4f2b350f67a0e185b9bce646cd6b in Linus' tree
fixes thus bug, but I can trigger it reliably by asking for a check
of a RAID-1 volume.  ("echo check > /sys/block/md6/md/sync_action")

This particular volume is a 10-way (!) RAID-1, but I suspect smaller
numbers will work.

The same BUG is triggered on a RAID-10 thread for a volume that shares
the same physical drives.  Note that a check of *that* volume (md7)
does not trigger the problem.

2.6.35 does NOT exhibit this problem.

Here are two full kernel logs, boot to crash.  There are some local patches,
but they are quite unrelated.  (Mostly PPS device changes.)


18:56:20: klogd 1.5.0#6, log source = /proc/kmsg started.
18:56:20: Linux version 2.6.36-rc6-00070-g44c064a ($USER@$HOST) (gcc version 4.4.5 (Debian 4.4.4-17) ) #308 SMP Thu Sep 30 14:14:07 EDT 2010
18:56:20: Command line: auto BOOT_IMAGE=2.6 ro root=907 libata.fua=1 tsc_khz=2500210 amd64_edac_mod.ecc_enable_override=1 acpi_enforce_resources=lax k10temp.force=1
18:56:20: BIOS-provided physical RAM map:
18:56:20:  BIOS-e820: 0000000000000000 - 0000000000093800 (usable)
18:56:20:  BIOS-e820: 0000000000093800 - 00000000000a0000 (reserved)
18:56:20:  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
18:56:20:  BIOS-e820: 0000000000100000 - 00000000dffa0000 (usable)
18:56:20:  BIOS-e820: 00000000dffc0000 - 00000000dffce000 (ACPI data)
18:56:20:  BIOS-e820: 00000000dffce000 - 00000000dfff0000 (ACPI NVS)
18:56:20:  BIOS-e820: 00000000dfff0000 - 00000000dfffe000 (reserved)
18:56:20:  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
18:56:20:  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
18:56:20: NX (Execute Disable) protection: active
18:56:20: DMI present.
18:56:20: No AGP bridge found
18:56:20: last_pfn = 0x220000 max_arch_pfn = 0x400000000
18:56:20: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
18:56:20: last_pfn = 0xdffa0 max_arch_pfn = 0x400000000
18:56:20: found SMP MP-table at [ffff8800000ff780] ff780
18:56:20: Using GB pages for direct mapping
18:56:20: init_memory_mapping: 0000000000000000-00000000dffa0000
18:56:20: init_memory_mapping: 0000000100000000-0000000220000000
18:56:20: ACPI: RSDP 00000000000f9e30 00014 (v00 ACPIAM)
18:56:20: ACPI: RSDT 00000000dffc0000 00038 (v01 011309 RSDT1044 20090113 MSFT 00000097)
18:56:20: ACPI: FACP 00000000dffc0200 00084 (v02 011309 FACP1044 20090113 MSFT 00000097)
18:56:20: ACPI: DSDT 00000000dffc0440 06E9B (v01  1ADNC 1ADNC001 00000001 INTL 20051117)
18:56:20: ACPI: FACS 00000000dffce000 00040
18:56:20: ACPI: APIC 00000000dffc0390 0006C (v01 011309 APIC1044 20090113 MSFT 00000097)
18:56:20: ACPI: MCFG 00000000dffc0400 0003C (v01 011309 OEMMCFG  20090113 MSFT 00000097)
18:56:20: ACPI: OEMB 00000000dffce040 00071 (v01 011309 OEMB1044 20090113 MSFT 00000097)
18:56:20: ACPI: HPET 00000000dffc72e0 00038 (v01 011309 OEMHPET  20090113 MSFT 00000097)
18:56:20: (11/32 early reservations) ==> bootmem [0000000000 - 0220000000]
18:56:20:   #0 [0001000000 - 0001798334]    TEXT DATA BSS ==> [0001000000 - 0001798334]
18:56:20:   #1 [0001799000 - 00017991b8]              BRK ==> [0001799000 - 00017991b8]
18:56:20:   #2 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
18:56:20:   #3 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
18:56:20:   #4 [0000093800 - 00000fd190]    BIOS reserved ==> [0000093800 - 00000fd190]
18:56:20:   #5 [00000fd334 - 00000ff780]    BIOS reserved ==> [00000fd334 - 00000ff780]
18:56:20:   #6 [00000fd190 - 00000fd334]     MP-table mpc ==> [00000fd190 - 00000fd334]
18:56:20:   #7 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
18:56:20:   #8 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
18:56:20:   #9 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
18:56:20:   #10 [000000b000 - 000004f000]          BOOTMAP ==> [000000b000 - 000004f000]
18:56:20: Zone PFN ranges:
18:56:20:   DMA      0x00000001 -> 0x00001000
18:56:20:   DMA32    0x00001000 -> 0x00100000
18:56:20:   Normal   0x00100000 -> 0x00220000
18:56:20: Movable zone start PFN for each node
18:56:20: early_node_map[3] active PFN ranges
18:56:20:     0: 0x00000001 -> 0x00000093
18:56:20:     0: 0x00000100 -> 0x000dffa0
18:56:20:     0: 0x00100000 -> 0x00220000
18:56:20: ACPI: PM-Timer IO Port: 0x808
18:56:20: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
18:56:20: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
18:56:20: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
18:56:20: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
18:56:20: ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
18:56:20: IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
18:56:20: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
18:56:20: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
18:56:20: Using ACPI (MADT) for SMP configuration information
18:56:20: ACPI: HPET id: 0x8300 base: 0xfed00000
18:56:20: SMP: Allowing 4 CPUs, 0 hotplug CPUs
18:56:20: Allocating PCI resources starting at dfffe000 (gap: dfffe000:1ff02000)
18:56:20: setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
18:56:20: PERCPU: Embedded 26 pages/cpu @ffff880028200000 s77632 r8192 d20672 u524288
18:56:20: pcpu-alloc: s77632 r8192 d20672 u524288 alloc=1*2097152
18:56:20: pcpu-alloc: [0] 0 1 2 3 
18:56:20: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2066302
18:56:20: Kernel command line: auto BOOT_IMAGE=2.6 ro root=907 libata.fua=1 tsc_khz=2500210 amd64_edac_mod.ecc_enable_override=1 acpi_enforce_resources=lax k10temp.force=1
18:56:20: PID hash table entries: 4096 (order: 3, 32768 bytes)
18:56:20: Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
18:56:20: Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
18:56:20: Checking aperture...
18:56:20: No AGP bridge found
18:56:20: Node 0: aperture @ 20000000 size 32 MB
18:56:20: Aperture pointing to e820 RAM. Ignoring.
18:56:20: Your BIOS doesn't leave a aperture memory hole
18:56:20: Please enable the IOMMU option in the BIOS setup
18:56:20: This costs you 64 MB of RAM
18:56:20: Mapping aperture over 65536 KB of RAM @ 20000000
18:56:20: Memory: 8118784k/8912896k available (4071k kernel code, 525112k absent, 269000k reserved, 2734k data, 492k init)
18:56:20: SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
18:56:20: Hierarchical RCU implementation.
18:56:20: ^IRCU-based detection of stalled CPUs is disabled.
18:56:20: ^IVerbose stalled-CPUs detection is disabled.
18:56:20: NR_IRQS:384
18:56:20: Console: colour VGA+ 80x25
18:56:20: console [tty0] enabled
18:56:20: Fast TSC calibration failed
18:56:20: TSC: Unable to calibrate against PIT
18:56:20: TSC: using HPET reference calibration
18:56:20: Using user defined TSC freq: 2500.210 MHz
18:56:20: Detected 2500.213 MHz processor.
18:56:20: Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.42 BogoMIPS (lpj=25002100)
18:56:20: pid_max: default: 32768 minimum: 301
18:56:20: Mount-cache hash table entries: 256
18:56:20: CPU: Physical Processor ID: 0
18:56:20: CPU: Processor Core ID: 0
18:56:20: mce: CPU supports 6 MCE banks
18:56:20: using C1E aware idle routine
18:56:20: Performance Events: AMD PMU driver.
18:56:20: ... version:                0
18:56:20: ... bit width:              48
18:56:20: ... generic registers:      4
18:56:20: ... value mask:             0000ffffffffffff
18:56:20: ... max period:             00007fffffffffff
18:56:20: ... fixed-purpose events:   0
18:56:20: ... event mask:             000000000000000f
18:56:20: Freeing SMP alternatives: 20k freed
18:56:20: ACPI: Core revision 20100702
18:56:20: Setting APIC routing to flat
18:56:20: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
18:56:20: CPU0: AMD Phenom(tm) 9850 Quad-Core Processor stepping 03
18:56:20: NMI watchdog enabled, takes one hw-pmu counter.
18:56:20: Booting Node   0, Processors  #1
18:56:20: NMI watchdog enabled, takes one hw-pmu counter.
18:56:20: System has AMD C1E enabled
18:56:20: Switch to broadcast mode on CPU1
18:56:20:  #2
18:56:20: NMI watchdog enabled, takes one hw-pmu counter.
18:56:20: Switch to broadcast mode on CPU2
18:56:20:  #3 Ok.
18:56:20: NMI watchdog enabled, takes one hw-pmu counter.
18:56:20: Switch to broadcast mode on CPU3
18:56:20: Brought up 4 CPUs
18:56:20: Total of 4 processors activated (20001.69 BogoMIPS).
18:56:20: Switch to broadcast mode on CPU0
18:56:20: xor: automatically using best checksumming function: generic_sse
18:56:20:    generic_sse:  9959.200 MB/sec
18:56:20: xor: using function: generic_sse (9959.200 MB/sec)
18:56:20: NET: Registered protocol family 16
18:56:20: TOM: 00000000e0000000 aka 3584M
18:56:20: TOM2: 0000000220000000 aka 8704M
18:56:20: ACPI: bus type pci registered
18:56:20: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
18:56:20: PCI: not using MMCONFIG
18:56:20: PCI: Using configuration type 1 for base access
18:56:20: PCI: Using configuration type 1 for extended access
18:56:20: bio: create slab <bio-0> at 0
18:56:20: raid6: int64x1   2443 MB/s
18:56:20: raid6: int64x2   2760 MB/s
18:56:20: raid6: int64x4   2030 MB/s
18:56:20: raid6: int64x8   1760 MB/s
18:56:20: raid6: sse2x1    3380 MB/s
18:56:20: raid6: sse2x2    5740 MB/s
18:56:20: raid6: sse2x4    6976 MB/s
18:56:20: raid6: using algorithm sse2x4 (6976 MB/s)
18:56:20: ACPI: Executed 3 blocks of module-level executable AML code
18:56:20: ACPI: Interpreter enabled
18:56:20: ACPI: (supports S0 S5)
18:56:20: ACPI: Using IOAPIC for interrupt routing
18:56:20: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
18:56:20: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
18:56:20: ACPI Warning: Incorrect checksum in table [OEMB] - 0xDD, should be 0xD4 (20100702/tbutils-314)
18:56:20: ACPI: No dock devices found.
18:56:20: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
18:56:20: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
18:56:20: pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
18:56:20: pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
18:56:20: pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
18:56:20: pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
18:56:20: pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
18:56:20: pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
18:56:20: pci 0000:00:03.0: PCI bridge to [bus 01-01]
18:56:20: pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
18:56:20: pci 0000:00:04.0: PCI bridge to [bus 02-02]
18:56:20: pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
18:56:20: pci 0000:00:05.0: PCI bridge to [bus 03-03]
18:56:20: pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
18:56:20: pci 0000:00:09.0: PCI bridge to [bus 04-04]
18:56:20: pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
18:56:20: pci 0000:00:0b.0: PCI bridge to [bus 05-05]
18:56:20: pci 0000:00:14.4: PCI bridge to [bus 06-06] (subtractive decode)
18:56:20: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 15)
18:56:20: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 10 11 12 14 15)
18:56:20: ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 7 10 11 12 14 15)
18:56:20: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11 12 14 15)
18:56:20: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
18:56:20: ACPI: PCI Interrupt Link [LNKF] (IRQs *9)
18:56:20: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 *15)
18:56:20: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *7 10 11 12 14 15)
18:56:20: HEST: Table is not found!
18:56:20: vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
18:56:20: vgaarb: loaded
18:56:20: SCSI subsystem initialized
18:56:20: usbcore: registered new interface driver usbfs
18:56:20: usbcore: registered new interface driver hub
18:56:20: usbcore: registered new device driver usb
18:56:20: PCI: Using ACPI for IRQ routing
18:56:20: pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
18:56:20: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
18:56:20: hpet0: 4 comparators, 32-bit 14.318180 MHz counter
18:56:20: Switching to clocksource tsc
18:56:20: pnp: PnP ACPI init
18:56:20: ACPI: bus type pnp registered
18:56:20: pnp 00:0e: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
18:56:20: pnp 00:0e: disabling [mem 0x000c0000-0x000cffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
18:56:20: pnp 00:0e: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
18:56:20: pnp 00:0e: disabling [mem 0x00100000-0xdfffffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
18:56:20: pnp: PnP ACPI: found 15 devices
18:56:20: ACPI: ACPI bus type pnp unregistered
18:56:20: system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
18:56:20: system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
18:56:20: system 00:09: [io  0x04d0-0x04d1] has been reserved
18:56:20: system 00:09: [io  0x040b] has been reserved
18:56:20: system 00:09: [io  0x04d6] has been reserved
18:56:20: system 00:09: [io  0x0c00-0x0c01] has been reserved
18:56:20: system 00:09: [io  0x0c14] has been reserved
18:56:20: system 00:09: [io  0x0c50-0x0c51] has been reserved
18:56:20: system 00:09: [io  0x0c52] has been reserved
18:56:20: system 00:09: [io  0x0c6c] has been reserved
18:56:20: system 00:09: [io  0x0c6f] has been reserved
18:56:20: system 00:09: [io  0x0cd0-0x0cd1] has been reserved
18:56:20: system 00:09: [io  0x0cd2-0x0cd3] has been reserved
18:56:20: system 00:09: [io  0x0cd4-0x0cd5] has been reserved
18:56:20: system 00:09: [io  0x0cd6-0x0cd7] has been reserved
18:56:20: system 00:09: [io  0x0cd8-0x0cdf] has been reserved
18:56:20: system 00:09: [io  0x0800-0x089f] has been reserved
18:56:20: system 00:09: [io  0x0b10-0x0b1f] has been reserved
18:56:20: system 00:09: [io  0x0900-0x090f] has been reserved
18:56:20: system 00:09: [io  0x0910-0x091f] has been reserved
18:56:20: system 00:09: [io  0xfe00-0xfefe] has been reserved
18:56:20: system 00:09: [mem 0xffb80000-0xffbfffff] has been reserved
18:56:20: system 00:0c: [io  0x0600-0x06df] has been reserved
18:56:20: system 00:0c: [io  0x0ae0-0x0aef] has been reserved
18:56:20: system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
18:56:20: system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
18:56:20: pci 0000:00:03.0: PCI bridge to [bus 01-01]
18:56:20: pci 0000:00:03.0:   bridge window [io  0x7000-0x7fff]
18:56:20: pci 0000:00:03.0:   bridge window [mem 0xfe600000-0xfe6fffff]
18:56:20: pci 0000:00:03.0:   bridge window [mem pref disabled]
18:56:20: pci 0000:00:04.0: PCI bridge to [bus 02-02]
18:56:20: pci 0000:00:04.0:   bridge window [io  0x8000-0x8fff]
18:56:20: pci 0000:00:04.0:   bridge window [mem 0xfe700000-0xfe7fffff]
18:56:20: pci 0000:00:04.0:   bridge window [mem pref disabled]
18:56:20: pci 0000:00:05.0: PCI bridge to [bus 03-03]
18:56:20: pci 0000:00:05.0:   bridge window [io  0x9000-0x9fff]
18:56:20: pci 0000:00:05.0:   bridge window [mem 0xfe800000-0xfe8fffff]
18:56:20: pci 0000:00:05.0:   bridge window [mem pref disabled]
18:56:20: pci 0000:00:09.0: PCI bridge to [bus 04-04]
18:56:20: pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
18:56:20: pci 0000:00:09.0:   bridge window [mem 0xfe900000-0xfe9fffff]
18:56:20: pci 0000:00:09.0:   bridge window [mem pref disabled]
18:56:20: pci 0000:00:0b.0: PCI bridge to [bus 05-05]
18:56:20: pci 0000:00:0b.0:   bridge window [io  0xb000-0xbfff]
18:56:20: pci 0000:00:0b.0:   bridge window [mem 0xfea00000-0xfeafffff]
18:56:20: pci 0000:00:0b.0:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
18:56:20: pci 0000:00:14.4: PCI bridge to [bus 06-06]
18:56:20: pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
18:56:20: pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
18:56:20: pci 0000:00:14.4:   bridge window [mem pref disabled]
18:56:20: pci 0000:00:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
18:56:20: pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
18:56:20: pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
18:56:20: pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
18:56:20: pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
18:56:20: NET: Registered protocol family 2
18:56:20: IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
18:56:20: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
18:56:20: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
18:56:20: TCP: Hash tables configured (established 262144 bind 65536)
18:56:20: TCP reno registered
18:56:20: UDP hash table entries: 4096 (order: 5, 131072 bytes)
18:56:20: UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
18:56:20: NET: Registered protocol family 1
18:56:20: RPC: Registered udp transport module.
18:56:20: RPC: Registered tcp transport module.
18:56:20: RPC: Registered tcp NFSv4.1 backchannel transport module.
18:56:20: PCI-DMA: Disabling AGP.
18:56:20: PCI-DMA: aperture base @ 20000000 size 65536 KB
18:56:20: PCI-DMA: using GART IOMMU.
18:56:20: PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
18:56:20: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
18:56:20: msgmni has been set to 15985
18:56:20: alg: No test for stdrng (krng)
18:56:20: io scheduler noop registered
18:56:20: io scheduler deadline registered
18:56:20: io scheduler cfq registered (default)
18:56:20: radeonfb 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
18:56:20: radeonfb: Found Intel x86 BIOS ROM Image
18:56:20: radeonfb: Retrieved PLL infos from BIOS
18:56:20: radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=325.00 Mhz, System=296.00 MHz
18:56:20: radeonfb: PLL min 20000 max 40000
18:56:20: i2c i2c-1: unable to read EDID block.
18:56:20: radeonfb: Monitor 1 type CRT found
18:56:20: radeonfb: EDID probed
18:56:20: radeonfb: Monitor 2 type no found
18:56:20: Console: switching to colour frame buffer device 128x48
18:56:20: radeonfb (0000:05:00.0): ATI Radeon 5b60 "[`"
18:56:20: input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
18:56:20: ACPI: Power Button [PWRB]
18:56:20: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
18:56:20: ACPI: Power Button [PWRF]
18:56:20: ACPI: duty_cycle spans bit 4
18:56:20: ACPI: processor limited to max C-state 1
18:56:20: ERST: Table is not found!
18:56:20: Linux agpgart interface v0.103
18:56:20: Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
18:56:20: Hangcheck: Using getrawmonotonic().
18:56:20: [drm] Initialized drm 1.1.0 20060810
18:56:20: [drm] radeon defaulting to userspace modesetting.
18:56:20: [drm] Initialized radeon 1.33.0 20080528 for 0000:05:00.0 on minor 0
18:56:20: Floppy drive(s): fd0 is 1.44M
18:56:20: FDC 0 is a post-1991 82077
18:56:20: brd: module loaded
18:56:20: loop: module loaded
18:56:20: Uniform Multi-Platform E-IDE driver
18:56:20: atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
18:56:20: pci 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
18:56:20: atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
18:56:20:     ide0: BM-DMA at 0xff00-0xff07
18:56:20: hdb: _NEC DVD+/-RW ND-6650A, ATAPI CD/DVD-ROM drive
18:56:20: hdb: UDMA/33 mode selected
18:56:20: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
18:56:20: ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
18:56:20: ide-gd driver 1.18
18:56:20: ide-cd driver 5.00
18:56:20: ide-cd: hdb: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
18:56:20: cdrom: Uniform CD-ROM driver Revision: 3.20
18:56:20: ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
18:56:20: ahci 0000:00:12.0: MSI K9A2 Platinum: enabling 64bit DMA
18:56:20: ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
18:56:20: ahci 0000:00:12.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
18:56:20: scsi0 : ahci
18:56:20: scsi1 : ahci
18:56:20: scsi2 : ahci
18:56:20: scsi3 : ahci
18:56:20: ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
18:56:20: ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
18:56:20: ata3: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed irq 22
18:56:20: ata4: SATA max UDMA/133 abar m1024@0xfe5ff800 port 0xfe5ffa80 irq 22
18:56:20: ahci 0000:04:00.0: PDC42819 can only drive SATA devices with this driver
18:56:20: ahci 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
18:56:20: ahci 0000:04:00.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl RAID mode
18:56:20: ahci 0000:04:00.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
18:56:20: scsi4 : ahci
18:56:20: scsi5 : ahci
18:56:20: scsi6 : ahci
18:56:20: scsi7 : ahci
18:56:20: ata5: SATA max UDMA/133 abar m8192@0xfe9fc000 port 0xfe9fc100 irq 17
18:56:20: ata6: SATA max UDMA/133 abar m8192@0xfe9fc000 port 0xfe9fc180 irq 17
18:56:20: ata7: SATA max UDMA/133 abar m8192@0xfe9fc000 port 0xfe9fc200 irq 17
18:56:20: ata8: SATA max UDMA/133 abar m8192@0xfe9fc000 port 0xfe9fc280 irq 17
18:56:20: sata_sil24 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
18:56:20: scsi8 : sata_sil24
18:56:20: scsi9 : sata_sil24
18:56:20: ata9: SATA max UDMA/100 host m128@0xfe6ffc00 port 0xfe6f8000 irq 19
18:56:20: ata10: SATA max UDMA/100 host m128@0xfe6ffc00 port 0xfe6fa000 irq 19
18:56:20: sata_sil24 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
18:56:20: scsi10 : sata_sil24
18:56:20: scsi11 : sata_sil24
18:56:20: ata11: SATA max UDMA/100 host m128@0xfe7ffc00 port 0xfe7f8000 irq 16
18:56:20: ata12: SATA max UDMA/100 host m128@0xfe7ffc00 port 0xfe7fa000 irq 16
18:56:20: tun: Universal TUN/TAP device driver, 1.6
18:56:20: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
18:56:20: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
18:56:20: r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
18:56:20: r8169 0000:03:00.0: eth0: RTL8168b/8111b at 0xffffc9000005a000, 00:50:8d:d3:a5:51, XID 18000000 IRQ 40
18:56:20: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
18:56:20: ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
18:56:20: ehci_hcd 0000:00:13.5: EHCI Host Controller
18:56:20: ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
18:56:20: ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
18:56:20: ehci_hcd 0000:00:13.5: debug port 1
18:56:20: ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe5ff000
18:56:20: ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
18:56:20: hub 1-0:1.0: USB hub found
18:56:20: hub 1-0:1.0: 10 ports detected
18:56:20: ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
18:56:20: ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
18:56:20: ohci_hcd 0000:00:13.0: OHCI Host Controller
18:56:20: ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
18:56:20: ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe5fe000
18:56:20: hub 2-0:1.0: USB hub found
18:56:20: hub 2-0:1.0: 2 ports detected
18:56:20: ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
18:56:20: ohci_hcd 0000:00:13.1: OHCI Host Controller
18:56:20: ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
18:56:20: ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe5fd000
18:56:20: hub 3-0:1.0: USB hub found
18:56:20: hub 3-0:1.0: 2 ports detected
18:56:20: ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
18:56:20: ohci_hcd 0000:00:13.2: OHCI Host Controller
18:56:20: ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
18:56:20: ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe5fc000
18:56:20: hub 4-0:1.0: USB hub found
18:56:20: hub 4-0:1.0: 2 ports detected
18:56:20: ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
18:56:20: ohci_hcd 0000:00:13.3: OHCI Host Controller
18:56:20: ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
18:56:20: ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe5fb000
18:56:20: ata8: SATA link down (SStatus 0 SControl 300)
18:56:20: ata7: SATA link down (SStatus 0 SControl 300)
18:56:20: hub 5-0:1.0: 2 ports detected
18:56:20: ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
18:56:20: ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe5fa000
18:56:20: hub 6-0:1.0: USB hub found
18:56:20: serio: i8042 KBD port at 0x60,0x64 irq 1
18:56:20: serio: i8042 AUX port at 0x60,0x64 irq 12
18:56:20: rtc_cmos 00:02: RTC can wake from S4
18:56:20: rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
18:56:20: ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [mem 0x00000b00-0x00000b0f pref disabled]
18:56:20: ACPI: This conflict may cause random problems and system instability
18:56:20: f71882fg: Found f71882fg chip at 0x600, revision 32
18:56:20: ACPI: resource f71882fg [io  0x0600-0x0607] conflicts with ACPI region HMOR [io  0x0605-0x0606 pref disabled]
18:56:20: f71882fg f71882fg.1536: Fan: 1 is in duty-cycle mode
18:56:20: f71882fg f71882fg.1536: Fan: 2 is in duty-cycle mode
18:56:20: k10temp 0000:00:18.3: unreliable CPU thermal sensor; check erratum 319
18:56:20: md: raid0 personality registered for level 0
18:56:20: md: raid10 personality registered for level 10
18:56:20: md: raid6 personality registered for level 6
18:56:20: md: raid5 personality registered for level 5
18:56:20: EDAC MC: Ver: 2.1.0 Sep 29 2010
18:56:20: EDAC amd64_edac:  Ver: 3.3.0 Sep 29 2010
18:56:20: EDAC amd64: using x4 syndromes.
18:56:20: EDAC amd64: This node reports that DRAM ECC is currently Disabled; ENABLING now
18:56:20: cpuidle: using governor ladder
18:56:20: usbcore: registered new interface driver hiddev
18:56:20: ata4: softreset failed (device not ready)
18:56:20: Mirror/redirect action on
18:56:20: Netfilter messages via NETLINK v0.30.
18:56:20: NF_TPROXY: Transparent proxy support initialized, version 4.1.0
18:56:20: TCP cubic registered
18:56:20: Initializing XFRM netlink socket
18:56:20: 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
18:56:20: All bugs added by David S. Miller <davem@redhat.com>
18:56:20: ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
18:56:20: ata5.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3EA, max UDMA/133
18:56:20: ata5.00: configured for UDMA/133
18:56:20: ata4: applying SB600 PMP SRST workaround and retrying
18:56:20: [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
18:56:20: rtc_cmos 00:02: setting system clock to 2010-09-30 18:56:05 UTC (1285872965)
18:56:20: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: ata4.00: configured for UDMA/133
18:56:20: ata1: softreset failed (device not ready)
18:56:20: ata2: applying SB600 PMP SRST workaround and retrying
18:56:20: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
18:56:20: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
18:56:20: ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
18:56:20: ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
18:56:20: ata2.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3EA, max UDMA/133
18:56:20: ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
18:56:20: ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: ata2.00: configured for UDMA/133
18:56:20: ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
18:56:20: scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDS72202 JKAO PQ: 0 ANSI: 5
18:56:20: sd 2:0:0:0: [sdc] Write Protect is off
18:56:20: sd 3:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
18:56:20: sd 3:0:0:0: [sdd] Write Protect is off
18:56:20: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
18:56:20:  sdb: sdb1 sdb2 sdb3 sdb4
18:56:20: sd 5:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
18:56:20: sd 5:0:0:0: [sdf] Write Protect is off
18:56:20:  sdd: sdd1 sdd2 sdd3 sdd4
18:56:20:  sdc: sdc1 sdc2 sdc3 sdc4
18:56:20: sd 1:0:0:0: [sdb] Attached SCSI disk
18:56:20: sd 3:0:0:0: [sdd] Attached SCSI disk
18:56:20: sd 5:0:0:0: [sdf] Attached SCSI disk
18:56:20: input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input4
18:56:20: sd 0:0:0:0: [sda] Attached SCSI disk
18:56:20: ata11.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3EA, max UDMA/133
18:56:20: ata11.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
18:56:20: ata9.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3EA, max UDMA/133
18:56:20: ata9.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
18:56:20: sd 8:0:0:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
18:56:20: sd 8:0:0:0: [sdg] Write Protect is off
18:56:20:  sdg: sdg1 sdg2 sdg3 sdg4
18:56:20: sd 8:0:0:0: [sdg] Attached SCSI disk
18:56:20: ata10.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
18:56:20: scsi 10:0:0:0: Direct-Access     ATA      Hitachi HDS72202 JKAO PQ: 0 ANSI: 5
18:56:20: sd 10:0:0:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
18:56:20:  sdi: sdi1 sdi2 sdi3 sdi4
18:56:20: sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
18:56:20: ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
18:56:20: scsi 11:0:0:0: Direct-Access     ATA      Hitachi HDS72202 JKAO PQ: 0 ANSI: 5
18:56:20: sd 11:0:0:0: [sdj] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
18:56:20: sd 11:0:0:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
18:56:20:  sdj: sdj1 sdj2 sdj3 sdj4
18:56:20: md: If you don't use raid, use raid=noautodetect
18:56:20: md: Autodetecting RAID arrays.
18:56:20: md: invalid raid superblock magic on sdf3
18:56:20: md: sdf3 does not have a valid v0.90 superblock, not importing!
18:56:20: md: invalid raid superblock magic on sdh3
18:56:20: md: sdh3 does not have a valid v0.90 superblock, not importing!
18:56:20: md: considering sdj4 ...
18:56:20: md:  adding sdj4 ...
18:56:20: md: sdj1 has different UUID to sdj4
18:56:20: md:  adding sdh4 ...
18:56:20: md:  adding sdi4 ...
18:56:20: md: sdi3 has different UUID to sdj4
18:56:20: md:  adding sdg4 ...
18:56:20: md: sdg2 has different UUID to sdj4
18:56:20: md: sda3 has different UUID to sdj4
18:56:20: md: sda2 has different UUID to sdj4
18:56:20: md: sdc3 has different UUID to sdj4
18:56:20: md: sdc2 has different UUID to sdj4
18:56:20: md: sdf2 has different UUID to sdj4
18:56:20: md: sdf1 has different UUID to sdj4
18:56:20: md: sdd2 has different UUID to sdj4
18:56:20: md: sdd1 has different UUID to sdj4
18:56:20: md: sde1 has different UUID to sdj4
18:56:20: md:  adding sdb4 ...
18:56:20: md: sdb1 has different UUID to sdj4
18:56:20: md: created md10
18:56:20: md: bind<sdd4>
18:56:20: md: bind<sdf4>
18:56:20: md: bind<sdg4>
18:56:20: md: bind<sdi4>
18:56:20: md: running: <sdj4><sdh4><sdi4><sdg4><sda4><sdc4><sdf4><sdd4><sde4><sdb4>
18:56:20: md/raid10:md10: active with 10 out of 10 devices
18:56:20: created bitmap (28 pages) for device md10
18:56:20: md10: detected capacity change from 0 to 3842060058624
18:56:20: md: considering sdj3 ...
18:56:20: md: sdj1 has different UUID to sdj3
18:56:20: md: sdh2 has different UUID to sdj3
18:56:20: md: sdi2 has different UUID to sdj3
18:56:20: md: sdi1 has different UUID to sdj3
18:56:20: md: sda3 has different UUID to sdj3
18:56:20: md: sda2 has different UUID to sdj3
18:56:20: md: sdc2 has different UUID to sdj3
18:56:20: md: sdc1 has different UUID to sdj3
18:56:20: md:  adding sdd3 ...
18:56:20: md: sdd2 has different UUID to sdj3
18:56:20: md: sde1 has different UUID to sdj3
18:56:20: md:  adding sdb3 ...
18:56:20: md: created md9
18:56:20: md: bind<sdb3>
18:56:20: md: running: <sdj3><sdd3><sdb3>
18:56:20: md/raid1:md9: active with 3 out of 3 mirrors
18:56:20: md9: detected capacity change from 0 to 8159363072
18:56:20: md:  adding sdh2 ...
18:56:20: md: sdh1 has different UUID to sdj2
18:56:20: md: sdi1 has different UUID to sdj2
18:56:20: md:  adding sdg2 ...
18:56:20: md:  adding sda2 ...
18:56:20: md: sda1 has different UUID to sdj2
18:56:20: md: sdc1 has different UUID to sdj2
18:56:20: md:  adding sdf2 ...
18:56:20: md: sdd1 has different UUID to sdj2
18:56:20: md:  adding sde2 ...
18:56:20: md: sdb1 has different UUID to sdj2
18:56:20: md: created md7
18:56:20: md: bind<sdd2>
18:56:20: md: bind<sdf2>
18:56:20: md: bind<sdg2>
18:56:20: md: bind<sdi2>
18:56:20: md: running: <sdj2><sdh2><sdi2><sdg2><sda2><sdc2><sdf2><sdd2><sde2><sdb2>
18:56:20: md/raid10:md7: active with 10 out of 10 devices
18:56:20: created bitmap (2 pages) for device md7
18:56:20: md7: detected capacity change from 0 to 140026839040
18:56:20: md: considering sdj1 ...
18:56:20: md: sdi3 has different UUID to sdj1
18:56:20: md:  adding sdi1 ...
18:56:20: md:  adding sda1 ...
18:56:20: md: bind<sdb1>
18:56:20: md: bind<sdc1>
18:56:20: md: bind<sda1>
18:56:20: md: bind<sdh1>
18:56:20: md: bind<sdj1>
18:56:20: md: running: <sdj1><sdh1><sdi1><sdg1><sda1><sdc1><sdf1><sdd1><sde1><sdb1>
18:56:20: created bitmap (1 pages) for device md6
18:56:20: md6: bitmap initialized from disk: read 1/1 pages, set 0 bits
18:56:20: md:  adding sdi3 ...
18:56:20: md:  adding sda3 ...
18:56:20: md: bind<sdc3>
18:56:20: md: bind<sda3>
18:56:20: md/raid1:md8: active with 3 out of 3 mirrors
18:56:20: md: ... autorun DONE.
18:56:20: md7: detected capacity change from 0 to 140026839040
18:56:20: EXT4-fs (md7): mounted filesystem with ordered data mode. Opts: (null)
18:56:20: VFS: Mounted root (ext4 filesystem) readonly on device 9:7.
18:56:20: Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
18:56:20: md10: detected capacity change from 0 to 3842060058624
18:56:20: md8: detected capacity change from 0 to 8159363072
18:56:20:  md10: unknown partition table
18:56:20:  md8: unknown partition table
18:56:20: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
18:56:20:  md10: unknown partition table
18:56:20: md8: detected capacity change from 0 to 8159363072
18:56:20:  md8: unknown partition table
18:56:20: md6: detected capacity change from 0 to 1194917888
18:56:20:  md9: unknown partition table
18:56:20: ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: ata3: EH complete
18:56:20: ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:56:20: ata5.00: configured for UDMA/133
18:56:20: ata4.00: configured for UDMA/133
18:56:20: ata4: EH complete
18:56:20: ata6: EH complete
18:56:20: Adding 7968124k swap on /dev/md8.  Priority:0 extents:1 across:7968124k 
18:56:20: Adding 7968124k swap on /dev/md9.  Priority:0 extents:1 across:7968124k 
18:56:20: EXT4-fs (md7): re-mounted. Opts: journal_checksum,journal_async_commit,delalloc,auto_da_alloc
18:56:20: alg: No test for cipher_null (cipher_null-generic)
18:56:20: alg: No test for compress_null (compress_null-generic)
18:56:20: r8169 0000:03:00.0: eth0: link up
18:56:50: r8169 0000:03:00.0: eth0: link up
18:57:46: md: data-check of RAID array md7
18:57:46: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
18:57:46: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
18:57:46: md: using 128k window, over a total of 136744960 blocks.
18:57:46: ata4.00: exception Emask 0x50 SAct 0x7fffffff SErr 0x680900 action 0x6 frozen
18:57:46: ata4.00: irq_stat 0x08000000, interface fatal error
18:57:46: ata4: SError: { UnrecovData HostInt 10B8B BadCRC Handshk }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:00:90:2e:00/00:00:00:00:00/40 tag 0 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:08:10:2f:00/00:00:00:00:00/40 tag 1 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:10:90:2f:00/00:00:00:00:00/40 tag 2 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:18:10:30:00/00:00:00:00:00/40 tag 3 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:20:90:30:00/00:00:00:00:00/40 tag 4 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:28:10:31:00/00:00:00:00:00/40 tag 5 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:30:90:31:00/00:00:00:00:00/40 tag 6 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:38:10:32:00/00:00:00:00:00/40 tag 7 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:40:90:32:00/00:00:00:00:00/40 tag 8 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:48:10:33:00/00:00:00:00:00/40 tag 9 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:50:90:33:00/00:00:00:00:00/40 tag 10 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:58:10:34:00/00:00:00:00:00/40 tag 11 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:60:90:34:00/00:00:00:00:00/40 tag 12 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:68:10:35:00/00:00:00:00:00/40 tag 13 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:70:10:26:00/00:00:00:00:00/40 tag 14 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:78:90:26:00/00:00:00:00:00/40 tag 15 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:80:10:27:00/00:00:00:00:00/40 tag 16 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:88:90:27:00/00:00:00:00:00/40 tag 17 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:90:10:28:00/00:00:00:00:00/40 tag 18 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:98:90:28:00/00:00:00:00:00/40 tag 19 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:a0:10:29:00/00:00:00:00:00/40 tag 20 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:a8:90:29:00/00:00:00:00:00/40 tag 21 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:b0:10:2a:00/00:00:00:00:00/40 tag 22 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:b8:90:2a:00/00:00:00:00:00/40 tag 23 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:c0:10:2b:00/00:00:00:00:00/40 tag 24 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:c8:90:2b:00/00:00:00:00:00/40 tag 25 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:d0:10:2c:00/00:00:00:00:00/40 tag 26 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:d8:90:2c:00/00:00:00:00:00/40 tag 27 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:e0:10:2d:00/00:00:00:00:00/40 tag 28 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:e8:90:2d:00/00:00:00:00:00/40 tag 29 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4.00: failed command: READ FPDMA QUEUED
18:57:46: ata4.00: cmd 60/80:f0:10:2e:00/00:00:00:00:00/40 tag 30 ncq 65536 in
18:57:46:          res 50/00:80:10:35:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:46: ata4.00: status: { DRDY }
18:57:46: ata4: hard resetting link
18:57:47: ata4: softreset failed (device not ready)
18:57:47: ata4: applying SB600 PMP SRST workaround and retrying
18:57:47: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
18:57:47: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:57:47: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:57:47: ata4.00: configured for UDMA/133
18:57:47: ata4: EH complete
18:57:50: ata4.00: exception Emask 0x50 SAct 0x1 SErr 0x680900 action 0x6 frozen
18:57:50: ata4.00: irq_stat 0x08000000, interface fatal error
18:57:50: ata4: SError: { UnrecovData HostInt 10B8B BadCRC Handshk }
18:57:50: ata4.00: failed command: READ FPDMA QUEUED
18:57:50: ata4.00: cmd 60/80:00:90:cd:06/00:00:00:00:00/40 tag 0 ncq 65536 in
18:57:50:          res 50/00:80:90:cd:06/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:50: ata4.00: status: { DRDY }
18:57:50: ata4: hard resetting link
18:57:51: ata4: softreset failed (device not ready)
18:57:51: ata4: applying SB600 PMP SRST workaround and retrying
18:57:51: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
18:57:51: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:57:51: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:57:51: ata4.00: configured for UDMA/133
18:57:51: ata4: EH complete
18:57:55: CE: hpet increased min_delta_ns to 7500 nsec
18:57:55: ata4.00: exception Emask 0x50 SAct 0x7fffffff SErr 0x680900 action 0x6 frozen
18:57:55: ata4.00: irq_stat 0x08000000, interface fatal error
18:57:55: ata4: SError: { UnrecovData HostInt 10B8B BadCRC Handshk }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:00:10:45:0b/00:00:00:00:00/40 tag 0 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:08:10:4d:0b/00:00:00:00:00/40 tag 1 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:10:90:4d:0b/00:00:00:00:00/40 tag 2 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:18:10:4e:0b/00:00:00:00:00/40 tag 3 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:20:90:4e:0b/00:00:00:00:00/40 tag 4 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:28:10:4f:0b/00:00:00:00:00/40 tag 5 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:30:90:4f:0b/00:00:00:00:00/40 tag 6 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:38:10:50:0b/00:00:00:00:00/40 tag 7 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:40:90:50:0b/00:00:00:00:00/40 tag 8 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:48:90:41:0b/00:00:00:00:00/40 tag 9 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:50:10:42:0b/00:00:00:00:00/40 tag 10 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:58:90:42:0b/00:00:00:00:00/40 tag 11 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:60:10:43:0b/00:00:00:00:00/40 tag 12 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:68:90:43:0b/00:00:00:00:00/40 tag 13 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:70:10:44:0b/00:00:00:00:00/40 tag 14 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:78:90:44:0b/00:00:00:00:00/40 tag 15 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:80:90:45:0b/00:00:00:00:00/40 tag 16 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:88:10:46:0b/00:00:00:00:00/40 tag 17 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:90:90:46:0b/00:00:00:00:00/40 tag 18 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:98:10:47:0b/00:00:00:00:00/40 tag 19 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:a0:90:47:0b/00:00:00:00:00/40 tag 20 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:a8:10:48:0b/00:00:00:00:00/40 tag 21 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:b0:90:48:0b/00:00:00:00:00/40 tag 22 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:b8:10:49:0b/00:00:00:00:00/40 tag 23 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:c0:90:49:0b/00:00:00:00:00/40 tag 24 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:c8:10:4a:0b/00:00:00:00:00/40 tag 25 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:d0:90:4a:0b/00:00:00:00:00/40 tag 26 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:d8:10:4b:0b/00:00:00:00:00/40 tag 27 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:e0:90:4b:0b/00:00:00:00:00/40 tag 28 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:e8:10:4c:0b/00:00:00:00:00/40 tag 29 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4.00: failed command: READ FPDMA QUEUED
18:57:55: ata4.00: cmd 60/80:f0:90:4c:0b/00:00:00:00:00/40 tag 30 ncq 65536 in
18:57:55:          res 50/00:80:90:50:0b/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:55: ata4.00: status: { DRDY }
18:57:55: ata4: hard resetting link
18:57:56: ata4: softreset failed (device not ready)
18:57:56: ata4: applying SB600 PMP SRST workaround and retrying
18:57:56: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
18:57:56: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:57:56: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:57:56: ata4.00: configured for UDMA/133
18:57:56: ata4: EH complete
18:57:57: ata4: limiting SATA link speed to 1.5 Gbps
18:57:57: ata4.00: exception Emask 0x50 SAct 0x2 SErr 0x680900 action 0x6 frozen
18:57:57: ata4.00: irq_stat 0x08000000, interface fatal error
18:57:57: ata4: SError: { UnrecovData HostInt 10B8B BadCRC Handshk }
18:57:57: ata4.00: failed command: READ FPDMA QUEUED
18:57:57: ata4.00: cmd 60/80:08:90:7b:0d/00:00:00:00:00/40 tag 1 ncq 65536 in
18:57:57:          res 50/00:80:90:7b:0d/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
18:57:57: ata4.00: status: { DRDY }
18:57:57: ata4: hard resetting link
18:57:58: ata4: softreset failed (device not ready)
18:57:58: ata4: applying SB600 PMP SRST workaround and retrying
18:57:58: ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
18:57:58: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:57:58: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
18:57:58: ata4.00: configured for UDMA/133
18:57:58: ata4: EH complete
18:58:28: CE: hpet increased min_delta_ns to 11250 nsec
18:58:29: CE: hpet increased min_delta_ns to 16875 nsec
19:20:03: md: md7: data-check done.
20:41:57: md: data-check of RAID array md6
20:41:57: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
20:41:57: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
20:41:57: md: using 128k window, over a total of 1166912 blocks.
20:41:57: ata1.00: WARNING: zero len r/w req
20:41:57: ------------[ cut here ]------------
20:41:57: kernel BUG at drivers/scsi/scsi_lib.c:1113!
20:41:57: invalid opcode: 0000 [#1] SMP 
20:41:57: last sysfs file: /sys/devices/virtual/block/md6/md/sync_action
20:41:57: CPU 3 
20:41:57: Modules linked in: ctr twofish_generic twofish_x86_64 twofish_common serpent xcbc sha512_generic sha256_generic crypto_null ipg 8250_pci 8250_pnp 8250 serial_core
20:41:57: 
20:41:57: Pid: 24341, comm: md6_resync Not tainted 2.6.36-rc6-00070-g44c064a #308 MS-7376/MS-7376
20:41:57: RIP: 0010:[<ffffffff812ab746>]  [<ffffffff812ab746>] scsi_setup_fs_cmnd+0x4e/0xbb
20:41:57: RSP: 0018:ffff88021d9bbad0  EFLAGS: 00010046
20:41:57: RAX: 0000000000000000 RBX: ffff88021a39fc30 RCX: ffff88021e891a58
20:41:57: RDX: 0000000000000000 RSI: ffff88021a39fc30 RDI: ffff88021f3c5c00
20:41:57: RBP: ffff88021d9bbae0 R08: 00000000000003e8 R09: ffff88021d9bbae0
20:41:57: R10: 0000000000000000 R11: ffff88021d9bbae0 R12: ffff88021f3c5c00
20:41:57: R13: ffff88021d9bbb58 R14: 0000000000000000 R15: ffff88021f3c5800
20:41:57: FS:  00007f792c4ff7c0(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
20:41:57: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
20:41:57: CR2: 00007eff23fc8000 CR3: 00000001fb00c000 CR4: 00000000000006e0
20:41:57: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
20:41:57: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
20:41:57: Process md6_resync (pid: 24341, threadinfo ffff88021d9ba000, task ffff880209c99600)
20:41:57: Stack:
20:41:57:  ffff88021a39fc30 ffff88021f3c5c00 ffff88021d9bbb40 ffffffff812b171d
20:41:57: <0> ffff88021f3da068 ffff88021f3da0b8 000000001f3da158 ffff88021e891a58
20:41:57: <0> ffff88021d9bbb40 ffff88021a39fc30 ffff88021e891a58 ffff88021d9bbb58
20:41:57: Call Trace:
20:41:57:  [<ffffffff812b171d>] sd_prep_fn+0x241/0x868
20:41:57:  [<ffffffff81160487>] blk_peek_request+0xb3/0x177
20:41:57:  [<ffffffff812aae96>] scsi_request_fn+0x84/0x424
20:41:57:  [<ffffffff8103f279>] ? del_timer+0x7f/0x89
20:41:57:  [<ffffffff81160d9c>] __generic_unplug_device+0x32/0x37
20:41:57:  [<ffffffff81160dcc>] generic_unplug_device+0x2b/0x3a
20:41:57:  [<ffffffff8115f0de>] blk_unplug+0x12/0x14
20:41:57:  [<ffffffff81306b31>] unplug_slaves+0x69/0x9f
20:41:57:  [<ffffffff81306b7f>] raid1_unplug+0x18/0x28
20:41:57:  [<ffffffff8115f0de>] blk_unplug+0x12/0x14
20:41:57:  [<ffffffff8131aa72>] md_unplug+0x1d/0x33
20:41:57:  [<ffffffff8131b3d4>] md_do_sync+0x94c/0xba6
20:41:57:  [<ffffffff8102f88f>] ? finish_task_switch+0x34/0x74
20:41:57:  [<ffffffff8131ba3a>] md_thread+0xf6/0x114
20:41:57:  [<ffffffff8131b944>] ? md_thread+0x0/0x114
20:41:57:  [<ffffffff8131b944>] ? md_thread+0x0/0x114
20:41:57:  [<ffffffff81049e4f>] kthread+0x7d/0x85
20:41:57:  [<ffffffff81002c94>] kernel_thread_helper+0x4/0x10
20:41:57:  [<ffffffff81049dd2>] ? kthread+0x0/0x85
20:41:57:  [<ffffffff81002c90>] ? kernel_thread_helper+0x0/0x10
20:41:57: Code: 85 c0 74 1d 48 8b 00 48 85 c0 74 15 48 8b 40 48 48 85 c0 74 0c 48 89 de 4c 89 e7 ff d0 85 c0 75 72 66 83 bb c0 00 00 00 00 75 04 <0f> 0b eb fe 48 8b 93 c8 00 00 00 48 85 d2 75 21 be 20 00 00 00 
20:41:57: RIP  [<ffffffff812ab746>] scsi_setup_fs_cmnd+0x4e/0xbb
20:41:57:  RSP <ffff88021d9bbad0>
20:41:57: ---[ end trace 5917ccc45c22539b ]---
20:41:57: ata1.00: WARNING: zero len r/w req


20:44:44: klogd 1.5.0#6, log source = /proc/kmsg started.
20:44:44: Linux version 2.6.36-rc6-00070-g44c064a ($USER@$HOST) (gcc version 4.4.5 (Debian 4.4.4-17) ) #308 SMP Thu Sep 30 14:14:07 EDT 2010
20:44:44: Command line: auto BOOT_IMAGE=2.6 ro root=907 libata.fua=1 tsc_khz=2500210 amd64_edac_mod.ecc_enable_override=1 acpi_enforce_resources=lax k10temp.force=1
20:44:44: BIOS-provided physical RAM map:
20:44:44:  BIOS-e820: 0000000000000000 - 0000000000093800 (usable)
20:44:44:  BIOS-e820: 0000000000093800 - 00000000000a0000 (reserved)
20:44:44:  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
20:44:44:  BIOS-e820: 0000000000100000 - 00000000dffa0000 (usable)
20:44:44:  BIOS-e820: 00000000dffc0000 - 00000000dffce000 (ACPI data)
20:44:44:  BIOS-e820: 00000000dffce000 - 00000000dfff0000 (ACPI NVS)
20:44:44:  BIOS-e820: 00000000dfff0000 - 00000000dfffe000 (reserved)
20:44:44:  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
20:44:44:  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
20:44:44: NX (Execute Disable) protection: active
20:44:44: DMI present.
20:44:45: No AGP bridge found
20:44:45: last_pfn = 0x220000 max_arch_pfn = 0x400000000
20:44:45: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
20:44:45: last_pfn = 0xdffa0 max_arch_pfn = 0x400000000
20:44:45: found SMP MP-table at [ffff8800000ff780] ff780
20:44:45: Using GB pages for direct mapping
20:44:45: init_memory_mapping: 0000000000000000-00000000dffa0000
20:44:45: init_memory_mapping: 0000000100000000-0000000220000000
20:44:45: ACPI: RSDP 00000000000f9e30 00014 (v00 ACPIAM)
20:44:45: ACPI: RSDT 00000000dffc0000 00038 (v01 011309 RSDT1044 20090113 MSFT 00000097)
20:44:45: ACPI: FACP 00000000dffc0200 00084 (v02 011309 FACP1044 20090113 MSFT 00000097)
20:44:45: ACPI: DSDT 00000000dffc0440 06E9B (v01  1ADNC 1ADNC001 00000001 INTL 20051117)
20:44:45: ACPI: FACS 00000000dffce000 00040
20:44:45: ACPI: APIC 00000000dffc0390 0006C (v01 011309 APIC1044 20090113 MSFT 00000097)
20:44:45: ACPI: MCFG 00000000dffc0400 0003C (v01 011309 OEMMCFG  20090113 MSFT 00000097)
20:44:45: ACPI: OEMB 00000000dffce040 00071 (v01 011309 OEMB1044 20090113 MSFT 00000097)
20:44:45: ACPI: HPET 00000000dffc72e0 00038 (v01 011309 OEMHPET  20090113 MSFT 00000097)
20:44:45: (11/32 early reservations) ==> bootmem [0000000000 - 0220000000]
20:44:45:   #0 [0001000000 - 0001798334]    TEXT DATA BSS ==> [0001000000 - 0001798334]
20:44:45:   #1 [0001799000 - 00017991b8]              BRK ==> [0001799000 - 00017991b8]
20:44:45:   #2 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
20:44:45:   #3 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
20:44:45:   #4 [0000093800 - 00000fd190]    BIOS reserved ==> [0000093800 - 00000fd190]
20:44:45:   #5 [00000fd334 - 00000ff780]    BIOS reserved ==> [00000fd334 - 00000ff780]
20:44:45:   #6 [00000fd190 - 00000fd334]     MP-table mpc ==> [00000fd190 - 00000fd334]
20:44:45:   #7 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
20:44:45:   #8 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
20:44:45:   #9 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
20:44:45:   #10 [000000b000 - 000004f000]          BOOTMAP ==> [000000b000 - 000004f000]
20:44:45: Zone PFN ranges:
20:44:45:   DMA      0x00000001 -> 0x00001000
20:44:45:   DMA32    0x00001000 -> 0x00100000
20:44:45:   Normal   0x00100000 -> 0x00220000
20:44:45: Movable zone start PFN for each node
20:44:45: early_node_map[3] active PFN ranges
20:44:45:     0: 0x00000001 -> 0x00000093
20:44:45:     0: 0x00000100 -> 0x000dffa0
20:44:45:     0: 0x00100000 -> 0x00220000
20:44:45: ACPI: PM-Timer IO Port: 0x808
20:44:45: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
20:44:45: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
20:44:45: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
20:44:45: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
20:44:45: ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
20:44:45: IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
20:44:45: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
20:44:45: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
20:44:45: Using ACPI (MADT) for SMP configuration information
20:44:45: ACPI: HPET id: 0x8300 base: 0xfed00000
20:44:45: SMP: Allowing 4 CPUs, 0 hotplug CPUs
20:44:45: Allocating PCI resources starting at dfffe000 (gap: dfffe000:1ff02000)
20:44:45: setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
20:44:45: PERCPU: Embedded 26 pages/cpu @ffff880028200000 s77632 r8192 d20672 u524288
20:44:45: pcpu-alloc: s77632 r8192 d20672 u524288 alloc=1*2097152
20:44:45: pcpu-alloc: [0] 0 1 2 3 
20:44:45: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2066302
20:44:45: Kernel command line: auto BOOT_IMAGE=2.6 ro root=907 libata.fua=1 tsc_khz=2500210 amd64_edac_mod.ecc_enable_override=1 acpi_enforce_resources=lax k10temp.force=1
20:44:45: PID hash table entries: 4096 (order: 3, 32768 bytes)
20:44:45: Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
20:44:45: Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
20:44:45: Checking aperture...
20:44:45: No AGP bridge found
20:44:45: Node 0: aperture @ 20000000 size 32 MB
20:44:45: Aperture pointing to e820 RAM. Ignoring.
20:44:45: Your BIOS doesn't leave a aperture memory hole
20:44:45: Please enable the IOMMU option in the BIOS setup
20:44:45: This costs you 64 MB of RAM
20:44:45: Mapping aperture over 65536 KB of RAM @ 20000000
20:44:45: Memory: 8118784k/8912896k available (4071k kernel code, 525112k absent, 269000k reserved, 2734k data, 492k init)
20:44:45: SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
20:44:45: Hierarchical RCU implementation.
20:44:45: ^IRCU-based detection of stalled CPUs is disabled.
20:44:45: ^IVerbose stalled-CPUs detection is disabled.
20:44:45: NR_IRQS:384
20:44:45: Console: colour VGA+ 80x25
20:44:45: console [tty0] enabled
20:44:45: Fast TSC calibration failed
20:44:45: TSC: Unable to calibrate against PIT
20:44:45: TSC: using HPET reference calibration
20:44:45: Using user defined TSC freq: 2500.210 MHz
20:44:45: Detected 2500.213 MHz processor.
20:44:45: Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.42 BogoMIPS (lpj=25002100)
20:44:45: pid_max: default: 32768 minimum: 301
20:44:45: Mount-cache hash table entries: 256
20:44:45: CPU: Physical Processor ID: 0
20:44:45: CPU: Processor Core ID: 0
20:44:45: mce: CPU supports 6 MCE banks
20:44:45: using C1E aware idle routine
20:44:45: Performance Events: AMD PMU driver.
20:44:45: ... version:                0
20:44:45: ... bit width:              48
20:44:45: ... generic registers:      4
20:44:45: ... value mask:             0000ffffffffffff
20:44:45: ... max period:             00007fffffffffff
20:44:45: ... fixed-purpose events:   0
20:44:45: ... event mask:             000000000000000f
20:44:45: Freeing SMP alternatives: 20k freed
20:44:45: ACPI: Core revision 20100702
20:44:45: Setting APIC routing to flat
20:44:45: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
20:44:45: CPU0: AMD Phenom(tm) 9850 Quad-Core Processor stepping 03
20:44:45: NMI watchdog enabled, takes one hw-pmu counter.
20:44:45: Booting Node   0, Processors  #1
20:44:45: NMI watchdog enabled, takes one hw-pmu counter.
20:44:45: System has AMD C1E enabled
20:44:45: Switch to broadcast mode on CPU1
20:44:45:  #2
20:44:45: NMI watchdog enabled, takes one hw-pmu counter.
20:44:45: Switch to broadcast mode on CPU2
20:44:45:  #3 Ok.
20:44:45: NMI watchdog enabled, takes one hw-pmu counter.
20:44:45: Switch to broadcast mode on CPU3
20:44:45: Brought up 4 CPUs
20:44:45: Total of 4 processors activated (20001.58 BogoMIPS).
20:44:45: Switch to broadcast mode on CPU0
20:44:45: xor: automatically using best checksumming function: generic_sse
20:44:45:    generic_sse:  9959.600 MB/sec
20:44:45: xor: using function: generic_sse (9959.600 MB/sec)
20:44:45: NET: Registered protocol family 16
20:44:45: TOM: 00000000e0000000 aka 3584M
20:44:45: TOM2: 0000000220000000 aka 8704M
20:44:45: ACPI: bus type pci registered
20:44:45: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
20:44:45: PCI: not using MMCONFIG
20:44:45: PCI: Using configuration type 1 for base access
20:44:45: PCI: Using configuration type 1 for extended access
20:44:45: bio: create slab <bio-0> at 0
20:44:45: raid6: int64x1   2443 MB/s
20:44:45: raid6: int64x2   2760 MB/s
20:44:45: raid6: int64x4   2030 MB/s
20:44:45: raid6: int64x8   1760 MB/s
20:44:45: raid6: sse2x1    3393 MB/s
20:44:45: raid6: sse2x2    5739 MB/s
20:44:45: raid6: sse2x4    7001 MB/s
20:44:45: raid6: using algorithm sse2x4 (7001 MB/s)
20:44:45: ACPI: Executed 3 blocks of module-level executable AML code
20:44:45: ACPI: Interpreter enabled
20:44:45: ACPI: (supports S0 S5)
20:44:45: ACPI: Using IOAPIC for interrupt routing
20:44:45: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
20:44:45: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
20:44:45: ACPI Warning: Incorrect checksum in table [OEMB] - 0xDD, should be 0xD4 (20100702/tbutils-314)
20:44:45: ACPI: No dock devices found.
20:44:45: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
20:44:45: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
20:44:45: pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
20:44:45: pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
20:44:45: pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
20:44:45: pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
20:44:45: pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
20:44:45: pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
20:44:45: pci 0000:00:03.0: PCI bridge to [bus 01-01]
20:44:45: pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
20:44:45: pci 0000:00:04.0: PCI bridge to [bus 02-02]
20:44:45: pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
20:44:45: pci 0000:00:05.0: PCI bridge to [bus 03-03]
20:44:45: pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
20:44:45: pci 0000:00:09.0: PCI bridge to [bus 04-04]
20:44:45: pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
20:44:45: pci 0000:00:0b.0: PCI bridge to [bus 05-05]
20:44:45: pci 0000:00:14.4: PCI bridge to [bus 06-06] (subtractive decode)
20:44:45: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 15)
20:44:45: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 10 11 12 14 15)
20:44:45: ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 7 10 11 12 14 15)
20:44:45: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11 12 14 15)
20:44:45: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
20:44:45: ACPI: PCI Interrupt Link [LNKF] (IRQs *9)
20:44:45: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 *15)
20:44:45: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *7 10 11 12 14 15)
20:44:45: HEST: Table is not found!
20:44:45: vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
20:44:45: vgaarb: loaded
20:44:45: SCSI subsystem initialized
20:44:45: usbcore: registered new interface driver usbfs
20:44:45: usbcore: registered new interface driver hub
20:44:45: usbcore: registered new device driver usb
20:44:45: PCI: Using ACPI for IRQ routing
20:44:45: pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
20:44:45: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
20:44:45: hpet0: 4 comparators, 32-bit 14.318180 MHz counter
20:44:45: Switching to clocksource tsc
20:44:45: pnp: PnP ACPI init
20:44:45: ACPI: bus type pnp registered
20:44:45: pnp 00:0e: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
20:44:45: pnp 00:0e: disabling [mem 0x000c0000-0x000cffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
20:44:45: pnp 00:0e: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
20:44:45: pnp 00:0e: disabling [mem 0x00100000-0xdfffffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
20:44:45: pnp: PnP ACPI: found 15 devices
20:44:45: ACPI: ACPI bus type pnp unregistered
20:44:45: system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
20:44:45: system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
20:44:45: system 00:09: [io  0x04d0-0x04d1] has been reserved
20:44:45: system 00:09: [io  0x040b] has been reserved
20:44:45: system 00:09: [io  0x04d6] has been reserved
20:44:45: system 00:09: [io  0x0c00-0x0c01] has been reserved
20:44:45: system 00:09: [io  0x0c14] has been reserved
20:44:45: system 00:09: [io  0x0c50-0x0c51] has been reserved
20:44:45: system 00:09: [io  0x0c52] has been reserved
20:44:45: system 00:09: [io  0x0c6c] has been reserved
20:44:45: system 00:09: [io  0x0c6f] has been reserved
20:44:45: system 00:09: [io  0x0cd0-0x0cd1] has been reserved
20:44:45: system 00:09: [io  0x0cd2-0x0cd3] has been reserved
20:44:45: system 00:09: [io  0x0cd4-0x0cd5] has been reserved
20:44:45: system 00:09: [io  0x0cd6-0x0cd7] has been reserved
20:44:45: system 00:09: [io  0x0cd8-0x0cdf] has been reserved
20:44:45: system 00:09: [io  0x0800-0x089f] has been reserved
20:44:45: system 00:09: [io  0x0b10-0x0b1f] has been reserved
20:44:45: system 00:09: [io  0x0900-0x090f] has been reserved
20:44:45: system 00:09: [io  0x0910-0x091f] has been reserved
20:44:45: system 00:09: [io  0xfe00-0xfefe] has been reserved
20:44:45: system 00:09: [mem 0xffb80000-0xffbfffff] has been reserved
20:44:45: system 00:0c: [io  0x0600-0x06df] has been reserved
20:44:45: system 00:0c: [io  0x0ae0-0x0aef] has been reserved
20:44:45: system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
20:44:45: system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
20:44:45: pci 0000:00:03.0: PCI bridge to [bus 01-01]
20:44:45: pci 0000:00:03.0:   bridge window [io  0x7000-0x7fff]
20:44:45: pci 0000:00:03.0:   bridge window [mem 0xfe600000-0xfe6fffff]
20:44:45: pci 0000:00:03.0:   bridge window [mem pref disabled]
20:44:45: pci 0000:00:04.0: PCI bridge to [bus 02-02]
20:44:45: pci 0000:00:04.0:   bridge window [io  0x8000-0x8fff]
20:44:45: pci 0000:00:04.0:   bridge window [mem 0xfe700000-0xfe7fffff]
20:44:45: pci 0000:00:04.0:   bridge window [mem pref disabled]
20:44:45: pci 0000:00:05.0: PCI bridge to [bus 03-03]
20:44:45: pci 0000:00:05.0:   bridge window [io  0x9000-0x9fff]
20:44:45: pci 0000:00:05.0:   bridge window [mem 0xfe800000-0xfe8fffff]
20:44:45: pci 0000:00:05.0:   bridge window [mem pref disabled]
20:44:45: pci 0000:00:09.0: PCI bridge to [bus 04-04]
20:44:45: pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
20:44:45: pci 0000:00:09.0:   bridge window [mem 0xfe900000-0xfe9fffff]
20:44:45: pci 0000:00:09.0:   bridge window [mem pref disabled]
20:44:45: pci 0000:00:0b.0: PCI bridge to [bus 05-05]
20:44:45: pci 0000:00:0b.0:   bridge window [io  0xb000-0xbfff]
20:44:45: pci 0000:00:0b.0:   bridge window [mem 0xfea00000-0xfeafffff]
20:44:45: pci 0000:00:0b.0:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
20:44:45: pci 0000:00:14.4: PCI bridge to [bus 06-06]
20:44:45: pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
20:44:45: pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
20:44:45: pci 0000:00:14.4:   bridge window [mem pref disabled]
20:44:45: pci 0000:00:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
20:44:45: pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
20:44:45: pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
20:44:45: pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
20:44:45: pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
20:44:45: NET: Registered protocol family 2
20:44:45: IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
20:44:45: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
20:44:45: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
20:44:45: TCP: Hash tables configured (established 262144 bind 65536)
20:44:45: TCP reno registered
20:44:45: UDP hash table entries: 4096 (order: 5, 131072 bytes)
20:44:45: UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
20:44:45: NET: Registered protocol family 1
20:44:45: RPC: Registered udp transport module.
20:44:45: RPC: Registered tcp transport module.
20:44:45: RPC: Registered tcp NFSv4.1 backchannel transport module.
20:44:45: PCI-DMA: Disabling AGP.
20:44:45: PCI-DMA: aperture base @ 20000000 size 65536 KB
20:44:45: PCI-DMA: using GART IOMMU.
20:44:45: PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
20:44:45: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
20:44:45: msgmni has been set to 15985
20:44:45: alg: No test for stdrng (krng)
20:44:45: io scheduler noop registered
20:44:45: io scheduler deadline registered
20:44:45: io scheduler cfq registered (default)
20:44:45: radeonfb 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
20:44:45: radeonfb: Found Intel x86 BIOS ROM Image
20:44:45: radeonfb: Retrieved PLL infos from BIOS
20:44:45: radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=325.00 Mhz, System=296.00 MHz
20:44:45: radeonfb: PLL min 20000 max 40000
20:44:45: i2c i2c-1: unable to read EDID block.
20:44:45: radeonfb: Monitor 1 type CRT found
20:44:45: radeonfb: EDID probed
20:44:45: radeonfb: Monitor 2 type no found
20:44:45: Console: switching to colour frame buffer device 128x48
20:44:45: radeonfb (0000:05:00.0): ATI Radeon 5b60 "[`"
20:44:45: input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
20:44:45: ACPI: Power Button [PWRB]
20:44:45: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
20:44:45: ACPI: Power Button [PWRF]
20:44:45: ACPI: duty_cycle spans bit 4
20:44:45: ACPI: processor limited to max C-state 1
20:44:45: ERST: Table is not found!
20:44:45: Linux agpgart interface v0.103
20:44:45: Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
20:44:45: Hangcheck: Using getrawmonotonic().
20:44:45: [drm] Initialized drm 1.1.0 20060810
20:44:45: [drm] radeon defaulting to userspace modesetting.
20:44:45: [drm] Initialized radeon 1.33.0 20080528 for 0000:05:00.0 on minor 0
20:44:45: Floppy drive(s): fd0 is 1.44M
20:44:45: FDC 0 is a post-1991 82077
20:44:45: brd: module loaded
20:44:45: loop: module loaded
20:44:45: Uniform Multi-Platform E-IDE driver
20:44:45: atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
20:44:45: pci 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
20:44:45: atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
20:44:45:     ide0: BM-DMA at 0xff00-0xff07
20:44:45: hdb: _NEC DVD+/-RW ND-6650A, ATAPI CD/DVD-ROM drive
20:44:45: hdb: UDMA/33 mode selected
20:44:45: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
20:44:45: ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
20:44:45: ide-gd driver 1.18
20:44:45: ide-cd driver 5.00
20:44:45: ide-cd: hdb: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
20:44:45: cdrom: Uniform CD-ROM driver Revision: 3.20
20:44:45: ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
20:44:45: ahci 0000:00:12.0: MSI K9A2 Platinum: enabling 64bit DMA
20:44:45: ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
20:44:45: ahci 0000:00:12.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
20:44:45: scsi0 : ahci
20:44:45: scsi1 : ahci
20:44:45: scsi2 : ahci
20:44:45: scsi3 : ahci
20:44:45: ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
20:44:45: ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
20:44:45: ahci 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
20:44:45: ahci 0000:04:00.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl RAID mode
20:44:45: scsi4 : ahci
20:44:45: scsi7 : ahci
20:44:45: ata8: SATA max UDMA/133 abar m8192@0xfe9fc000 port 0xfe9fc280 irq 17
20:44:45: scsi9 : sata_sil24
20:44:45: scsi10 : sata_sil24
20:44:45: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
20:44:45: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
20:44:45: ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
20:44:45: ehci_hcd 0000:00:13.5: EHCI Host Controller
20:44:45: ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
20:44:45: ehci_hcd 0000:00:13.5: debug port 1
20:44:45: hub 1-0:1.0: USB hub found
20:44:45: ohci_hcd 0000:00:13.0: OHCI Host Controller
20:44:45: ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
20:44:45: hub 2-0:1.0: USB hub found
20:44:45: hub 2-0:1.0: 2 ports detected
20:44:45: ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe5fd000
20:44:45: hub 3-0:1.0: 2 ports detected
20:44:45: ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
20:44:45: ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe5fc000
20:44:45: hub 4-0:1.0: USB hub found
20:44:45: ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
20:44:45: ata7: SATA link down (SStatus 0 SControl 300)
20:44:45: hub 5-0:1.0: USB hub found
20:44:45: ohci_hcd 0000:00:13.4: OHCI Host Controller
20:44:45: ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
20:44:45: hub 6-0:1.0: 2 ports detected
20:44:45: serio: i8042 AUX port at 0x60,0x64 irq 12
20:44:45: mice: PS/2 mouse device common for all mice
20:44:45: rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
20:44:45: ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [mem 0x00000b00-0x00000b0f pref disabled]
20:44:45: ACPI: This conflict may cause random problems and system instability
20:44:45: f71882fg: Found f71882fg chip at 0x600, revision 32
20:44:45: ACPI: resource f71882fg [io  0x0600-0x0607] conflicts with ACPI region HMOR [io  0x0605-0x0606 pref disabled]
20:44:45: f71882fg f71882fg.1536: Fan: 1 is in duty-cycle mode
20:44:45: f71882fg f71882fg.1536: Fan: 2 is in duty-cycle mode
20:44:45: f71882fg f71882fg.1536: Fan: 4 is in duty-cycle mode
20:44:45: k10temp 0000:00:18.3: unreliable CPU thermal sensor; check erratum 319
20:44:45: md: raid1 personality registered for level 1
20:44:45: md: raid10 personality registered for level 10
20:44:45: md: raid4 personality registered for level 4
20:44:45: EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
20:44:45: EDAC MC0: Giving out device to 'amd64_edac' 'Family 10h': DEV 0000:00:18.2
20:44:45: EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
20:44:45: usbcore: registered new interface driver usbhid
20:44:45: Simple TC action Loaded
20:44:45: netem: version 1.2
20:44:45: ata4: softreset failed (device not ready)
20:44:45: ata4: applying SB600 PMP SRST workaround and retrying
20:44:45: NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
20:44:45: TCP cubic registered
20:44:45: NET: Registered protocol family 15
20:44:45: 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
20:44:45: [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
20:44:45: [Firmware Bug]: powernow-k8: Try again with latest BIOS.
20:44:45: ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
20:44:45: ata6.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3EA, max UDMA/133
20:44:45: ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
20:44:45: ata6.00: configured for UDMA/133
20:44:45: registered taskstats version 1
20:44:45: ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
20:44:45: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
20:44:45: ata2: softreset failed (device not ready)
20:44:45: ata3: softreset failed (device not ready)
20:44:45: ata2: applying SB600 PMP SRST workaround and retrying
20:44:45: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
20:44:45: ata3.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3EA, max UDMA/133
20:44:45: ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
20:44:45: ata3.00: configured for UDMA/133
20:44:45: ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
20:44:45: ata1.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3EA, max UDMA/133
20:44:45: ata1.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
20:44:45: ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
20:44:45: scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDS72202 JKAO PQ: 0 ANSI: 5
20:44:45: sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
20:44:45: sd 2:0:0:0: [sdc] Write Protect is off
20:44:45: sd 4:0:0:0: [sde] Write Protect is off
20:44:45: sd 5:0:0:0: [sdf] Write Protect is off
20:44:45:  sdf: sdf1 sdf2 sdf3 sdf4
20:44:45:  sde: sde1 sde2 sde3 sde4
20:44:45:  sdc: sdc1 sdc2 sdc3 sdc4
20:44:45: sd 5:0:0:0: [sdf] Attached SCSI disk
20:44:45: sd 4:0:0:0: [sde] Attached SCSI disk
20:44:45:  sda: sda1 sda2 sda3 sda4
20:44:45: ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
20:44:45: ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
20:44:45: ata11.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
20:44:45: ata11.00: configured for UDMA/100
20:44:45: ata9.00: configured for UDMA/100
20:44:45: sd 8:0:0:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
20:44:45: sd 8:0:0:0: [sdg] Attached SCSI disk
20:44:45: ata10.00: configured for UDMA/100
20:44:45: sd 10:0:0:0: [sdi] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
20:44:45: sd 10:0:0:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
20:44:45:  sdi: sdi1 sdi2 sdi3 sdi4
20:44:45: sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
20:44:45: ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
20:44:45: ata12.00: ATA-8: Hitachi HDS722020ALA330, JKAOA3EA, max UDMA/133
20:44:45: scsi 11:0:0:0: Direct-Access     ATA      Hitachi HDS72202 JKAO PQ: 0 ANSI: 5
20:44:45: sd 11:0:0:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
20:44:45:  sdj: sdj1 sdj2 sdj3 sdj4
20:44:45: md: Waiting for all devices to be available before autodetect
20:44:45: md: If you don't use raid, use raid=noautodetect
20:44:45: md: sdf3 does not have a valid v0.90 superblock, not importing!
20:44:45: md: invalid raid superblock magic on sde3
20:44:45: md: sdg3 does not have a valid v0.90 superblock, not importing!
20:44:45: md: Scanned 40 and added 36 devices.
20:44:45: md: autorun ...
20:44:45: md: sdj3 has different UUID to sdj4
20:44:45: md: sdh2 has different UUID to sdj4
20:44:45: md: sdi3 has different UUID to sdj4
20:44:45: md: sdi2 has different UUID to sdj4
20:44:45: md: sdg2 has different UUID to sdj4
20:44:45: md: sdg1 has different UUID to sdj4
20:44:45: md: sda2 has different UUID to sdj4
20:44:45: md: sdc3 has different UUID to sdj4
20:44:45: md: sdc2 has different UUID to sdj4
20:44:45: md: sdb3 has different UUID to sdj4
20:44:45: md: sde2 has different UUID to sdj4
20:44:45: md: sdf2 has different UUID to sdj4
20:44:45: md: sdd2 has different UUID to sdj4
20:44:45: md: bind<sdf4>
20:44:45: md: bind<sde4>
20:44:45: md: bind<sdc4>
20:44:45: md: bind<sda4>
20:44:45: md: bind<sdj4>
20:44:45: created bitmap (28 pages) for device md10
20:44:45: md10: bitmap initialized from disk: read 2/2 pages, set 0 bits
20:44:45: md:  adding sdj3 ...
20:44:45: md: sdh1 has different UUID to sdj3
20:44:45: md: sdi3 has different UUID to sdj3
20:44:45: md: sdi1 has different UUID to sdj3
20:44:45: md: sdg2 has different UUID to sdj3
20:44:45: md: sda2 has different UUID to sdj3
20:44:45: md: sdc1 has different UUID to sdj3
20:44:45: md: sdb1 has different UUID to sdj3
20:44:45: md: sde2 has different UUID to sdj3
20:44:45: md: sdf1 has different UUID to sdj3
20:44:45: md:  adding sdd3 ...
20:44:45: md: bind<sdj3>
20:44:45: md9: bitmap initialized from disk: read 1/1 pages, set 0 bits
20:44:45: md: sdi1 has different UUID to sdj2
20:44:45: md: sda1 has different UUID to sdj2
20:44:45: md: sdc3 has different UUID to sdj2
20:44:45: md:  adding sdc2 ...
20:44:45: md:  adding sdb2 ...
20:44:45: md: sdf1 has different UUID to sdj2
20:44:45: md:  adding sdd2 ...
20:44:45: md: created md7
20:44:45: md: bind<sdb2>
20:44:45: md: bind<sdc2>
20:44:45: md: bind<sdi2>
20:44:45: md: running: <sdj2><sdh2><sdi2><sdg2><sda2><sdc2><sdb2><sde2><sdf2><sdd2>
20:44:45: md/raid10:md7: active with 10 out of 10 devices
20:44:45: md7: detected capacity change from 0 to 140026839040
20:44:45: md: considering sdj1 ...
20:44:45: md: sdi3 has different UUID to sdj1
20:44:45: md: sda3 has different UUID to sdj1
20:44:45: md:  adding sda1 ...
20:44:45: md:  adding sdb1 ...
20:44:45: md: created md6
20:44:45: md: bind<sdd1>
20:44:45: md: bind<sde1>
20:44:45: md: bind<sdg1>
20:44:45: md: bind<sdj1>
20:44:45: md6: bitmap initialized from disk: read 1/1 pages, set 0 bits
20:44:45: md6: detected capacity change from 0 to 1194917888
20:44:45: md:  adding sda3 ...
20:44:45: md: bind<sda3>
20:44:45: md: bind<sdi3>
20:44:45: md/raid1:md8: active with 3 out of 3 mirrors
20:44:45: created bitmap (1 pages) for device md8
20:44:45: EXT3-fs (md7): error: couldn't mount because of unsupported optional features (240)
20:44:45: EXT4-fs (md7): INFO: recovery required on readonly filesystem
20:44:45: EXT4-fs (md7): mounted filesystem with ordered data mode. Opts: (null)
20:44:45: VFS: Mounted root (ext4 filesystem) readonly on device 9:7.
20:44:45: Freeing unused kernel memory: 492k freed
20:44:45: md9: detected capacity change from 0 to 8159363072
20:44:45: md8: detected capacity change from 0 to 8159363072
20:44:45:  md9: unknown partition table
20:44:45:  md8: unknown partition table
20:44:45: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
20:44:45:  md8: unknown partition table
20:44:45:  md10: unknown partition table
20:44:45: 0000:06:03.0: ttyS1 at I/O 0xe400 (irq = 21) is a 16550A
20:44:45: md6: detected capacity change from 0 to 1194917888
20:44:45: md9: detected capacity change from 0 to 8159363072
20:44:45: ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
20:44:45: ata1.00: configured for UDMA/133
20:44:45: ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
20:44:45: ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
20:44:45: ata3: EH complete
20:44:45: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
20:44:45: ata4: EH complete
20:44:45: ata5.00: configured for UDMA/133
20:44:45: ata5: EH complete
20:44:45: ata6.00: configured for UDMA/133
20:44:45: Adding 7968124k swap on /dev/md8.  Priority:0 extents:1 across:7968124k 
20:44:45: EXT4-fs (md7): re-mounted. Opts: journal_checksum,journal_async_commit,delalloc,auto_da_alloc
20:44:45: EXT4-fs (md10): mounted filesystem with ordered data mode. Opts: journal_checksum,journal_async_commit,delalloc,auto_da_alloc
20:44:45: alg: No test for digest_null (digest_null-generic)
20:44:45: alg: No test for compress_null (compress_null-generic)
20:45:14: r8169 0000:03:00.0: eth0: link up
20:47:59: md: data-check of RAID array md6
20:47:59: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
20:47:59: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
20:47:59: md: using 128k window, over a total of 1166912 blocks.
20:47:59: ata1.00: WARNING: zero len r/w req
20:47:59: ------------[ cut here ]------------
20:47:59: kernel BUG at drivers/scsi/scsi_lib.c:1113!
20:47:59: invalid opcode: 0000 [#1] SMP 
20:47:59: last sysfs file: /sys/devices/virtual/block/md6/md/sync_action
20:47:59: CPU 2 
20:47:59: Modules linked in: ctr twofish_generic twofish_x86_64 twofish_common serpent xcbc sha512_generic sha256_generic crypto_null ipg 8250_pci 8250_pnp 8250 serial_core
20:47:59: 
20:47:59: Pid: 9537, comm: md6_resync Not tainted 2.6.36-rc6-00070-g44c064a #308 MS-7376/MS-7376
20:47:59: RIP: 0010:[<ffffffff812ab746>]  [<ffffffff812ab746>] scsi_setup_fs_cmnd+0x4e/0xbb
20:47:59: RSP: 0018:ffff880218de3ad0  EFLAGS: 00010046
20:47:59: RAX: 0000000000000000 RBX: ffff88021a8b4b88 RCX: ffff88021f3c2320
20:47:59: RDX: 0000000000000000 RSI: ffff88021a8b4b88 RDI: ffff88021f513000
20:47:59: RBP: ffff880218de3ae0 R08: 00000000000003e8 R09: ffff880218de3ae0
20:47:59: R10: 0000000000000000 R11: ffff880218de3ae0 R12: ffff88021f513000
20:47:59: R13: ffff880218de3b58 R14: 0000000000000000 R15: ffff88021f512c00
20:47:59: FS:  00007fdf8b89f700(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
20:47:59: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
20:47:59: CR2: 0000003a10c1e8f0 CR3: 000000000164a000 CR4: 00000000000006e0
20:47:59: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
20:47:59: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
20:47:59: Process md6_resync (pid: 9537, threadinfo ffff880218de2000, task ffff88021c53ac00)
20:47:59: Stack:
20:47:59:  ffff88021a8b4b88 ffff88021f513000 ffff880218de3b40 ffffffff812b171d
20:47:59: <0> ffff88021f604068 ffff88021f6040b8 000000001f604158 ffff88021f3c2320
20:47:59: <0> ffff880218de3b40 ffff88021a8b4b88 ffff88021f3c2320 ffff880218de3b58
20:47:59: Call Trace:
20:47:59:  [<ffffffff812b171d>] sd_prep_fn+0x241/0x868
20:47:59:  [<ffffffff81160487>] blk_peek_request+0xb3/0x177
20:47:59:  [<ffffffff812aae96>] scsi_request_fn+0x84/0x424
20:47:59:  [<ffffffff81160d9c>] __generic_unplug_device+0x32/0x37
20:47:59:  [<ffffffff81160dcc>] generic_unplug_device+0x2b/0x3a
20:47:59:  [<ffffffff8115f0de>] blk_unplug+0x12/0x14
20:47:59:  [<ffffffff81306b31>] unplug_slaves+0x69/0x9f
20:47:59:  [<ffffffff81306b7f>] raid1_unplug+0x18/0x28
20:47:59:  [<ffffffff8115f0de>] blk_unplug+0x12/0x14
20:47:59:  [<ffffffff8131aa72>] md_unplug+0x1d/0x33
20:47:59:  [<ffffffff8131b3d4>] md_do_sync+0x94c/0xba6
20:47:59:  [<ffffffff8102f88f>] ? finish_task_switch+0x34/0x74
20:47:59:  [<ffffffff8131ba3a>] md_thread+0xf6/0x114
20:47:59:  [<ffffffff8131b944>] ? md_thread+0x0/0x114
20:47:59:  [<ffffffff8131b944>] ? md_thread+0x0/0x114
20:47:59:  [<ffffffff81049e4f>] kthread+0x7d/0x85
20:47:59:  [<ffffffff81002c94>] kernel_thread_helper+0x4/0x10
20:47:59:  [<ffffffff81049dd2>] ? kthread+0x0/0x85
20:47:59:  [<ffffffff81002c90>] ? kernel_thread_helper+0x0/0x10
20:47:59: Code: 85 c0 74 1d 48 8b 00 48 85 c0 74 15 48 8b 40 48 48 85 c0 74 0c 48 89 de 4c 89 e7 ff d0 85 c0 75 72 66 83 bb c0 00 00 00 00 75 04 <0f> 0b eb fe 48 8b 93 c8 00 00 00 48 85 d2 75 21 be 20 00 00 00 
20:47:59: RIP  [<ffffffff812ab746>] scsi_setup_fs_cmnd+0x4e/0xbb
20:47:59:  RSP <ffff880218de3ad0>
20:47:59: ---[ end trace 1e250084e0863623 ]---
20:48:01: ------------[ cut here ]------------
20:48:01: kernel BUG at drivers/scsi/scsi_lib.c:1113!
20:48:01: invalid opcode: 0000 [#2] SMP 
20:48:01: last sysfs file: /sys/devices/virtual/block/md6/md/sync_action
20:48:01: CPU 3 
20:48:01: Modules linked in: ctr twofish_generic twofish_x86_64 twofish_common serpent xcbc sha512_generic sha256_generic crypto_null ipg 8250_pci 8250_pnp 8250 serial_core
20:48:01: 
20:48:01: Pid: 947, comm: md7_raid10 Tainted: G      D     2.6.36-rc6-00070-g44c064a #308 MS-7376/MS-7376
20:48:01: RIP: 0010:[<ffffffff812ab746>]  [<ffffffff812ab746>] scsi_setup_fs_cmnd+0x4e/0xbb
20:48:01: RSP: 0018:ffff88021f4b1930  EFLAGS: 00010046
20:48:01: RAX: 0000000000000000 RBX: ffff88021a8b4f60 RCX: 0000000000000000
20:48:01: RDX: 0000000000000000 RSI: ffff88021a8b4f60 RDI: ffff88021f3ca400
20:48:01: RBP: ffff88021f4b1940 R08: 0000000000052800 R09: 0000000000000000
20:48:01: R10: ffff88021f4b19d0 R11: ffff88021f4b19f0 R12: ffff88021f3ca400
20:48:01: R13: ffff88021f4b19b8 R14: 0000000000000000 R15: ffff88021f3cbc00
20:48:01: FS:  00007fce18ce5720(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
20:48:01: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
20:48:01: CR2: 0000003a10c6e5a0 CR3: 000000021b00c000 CR4: 00000000000006e0
20:48:01: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
20:48:01: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
20:48:01: Process md7_raid10 (pid: 947, threadinfo ffff88021f4b0000, task ffff88021f384200)
20:48:01: Stack:
20:48:01:  ffff88021a8b4f60 ffff88021f3ca400 ffff88021f4b19a0 ffffffff812b171d
20:48:01: <0> ffff88021f4b1970 ffffffff8115eb7e 000000001f597008 ffff88021e821a58
20:48:01: <0> ffff88021f4b1990 ffff88021a8b4f60 ffff88021e821a58 ffff88021f4b19b8
20:48:01: Call Trace:
20:48:01:  [<ffffffff812b171d>] sd_prep_fn+0x241/0x868
20:48:01:  [<ffffffff8115eb7e>] ? elv_rb_del+0x30/0x49
20:48:01:  [<ffffffff81160487>] blk_peek_request+0xb3/0x177
20:48:01:  [<ffffffff812aae96>] scsi_request_fn+0x84/0x424
20:48:01:  [<ffffffff8103f279>] ? del_timer+0x7f/0x89
20:48:01:  [<ffffffff81160c18>] __blk_run_queue+0x3f/0x72
20:48:01:  [<ffffffff8115e831>] elv_insert+0x80/0x1a8
20:48:01:  [<ffffffff8115e9f1>] __elv_add_request+0x98/0x9f
20:48:01:  [<ffffffff8116174e>] __make_request+0x34a/0x3cd
20:48:01:  [<ffffffff8115feda>] generic_make_request+0x19a/0x204
20:48:01:  [<ffffffff8116000b>] submit_bio+0xc7/0xd0
20:48:01:  [<ffffffff810bb519>] ? bio_clone+0x39/0x44
20:48:01:  [<ffffffff8131be2b>] md_super_write+0xab/0xba
20:48:01:  [<ffffffff81322c77>] write_page+0x161/0x2c9
20:48:01:  [<ffffffff8102ad35>] ? dequeue_task_fair+0x201/0x210
20:48:01:  [<ffffffff81322eb6>] bitmap_update_sb+0xd7/0xdc
20:48:01:  [<ffffffff8131c210>] md_update_sb+0x1f6/0x2c9
20:48:01:  [<ffffffff8131dc20>] md_check_recovery+0x1b7/0x43f
20:48:01:  [<ffffffff8130af28>] raid10d+0x34/0x804
20:48:01:  [<ffffffff8103f1ce>] ? try_to_del_timer_sync+0x83/0x8f
