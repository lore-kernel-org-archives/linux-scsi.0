From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Thu, 30 Oct 2008 01:53:51 -0700 (PDT)
Message-ID: <20081030085351.6BB6711D108@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbYJ3Ixy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 04:53:54 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9U8rpPU025149
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 01:53:52 -0700
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-10-30 01:53 -------
Reply-To: akpm@linux-foundation.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 30 Oct 2008 01:17:37 -0700 (PDT) bugme-daemon@bugzilla.kernel.org
wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11898
> 
>            Summary: mke2fs hang on AIC79 device.
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.28-rc1/rc2
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: alex.shi@intel.com
> 
> 
> Latest working kernel version:2.6.27
> Earliest failing kernel version:2.6.28-rc1
> Distribution:RHEL 4.91
> Hardware Environment:AIC79xx
> Software Environment: 
> Problem Description:
> 
> Steps to reproduce: mke2fs /dev/sdx 
> 
> 
> [root@linux-b03 ~]#  mke2fs /dev/sdb1
> mke2fs 1.39 (29-May-2006)
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> 3842720 inodes, 7679996 blocks
> 383999 blocks (5.00%) reserved for the super user
> First data block=0
> Maximum filesystem blocks=4294967296
> 235 block groups
> 32768 blocks per group, 32768 fragments per group
> 16352 inodes per group
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
>         4096000
> 
> Writing inode tables: done
> Writing superblocks and filesystem accounting information:
> 
> ..... hang .... 

Can you please work out where it hung?  Enable the softlockup detector,
nmi watchdog, try to get a sysrq-w or sysrq-t trace, etc?

Thanks.


> lspci : 
> 
> 
> 04:02.0 SCSI storage controller: Adaptec AIC-7902B U320 (rev 10)
>         Subsystem: Super Micro Computer Inc Unknown device 8080
>         Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 16
>         I/O ports at 2400 [disabled] [size=256]
>         Memory at c8200000 (64-bit, non-prefetchable) [size=8K]
>         I/O ports at 2000 [disabled] [size=256]
>         [virtual] Expansion ROM at c2000000 [disabled] [size=512K]
>         Capabilities: <access denied>
> 
> 04:02.1 SCSI storage controller: Adaptec AIC-7902B U320 (rev 10)
>         Subsystem: Super Micro Computer Inc Unknown device 8080
>         Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 17
>         I/O ports at 2c00 [disabled] [size=256]
>         Memory at c8202000 (64-bit, non-prefetchable) [size=8K]
>         I/O ports at 2800 [disabled] [size=256]
>         [virtual] Expansion ROM at c2080000 [disabled] [size=512K]
>         Capabilities: <access denied>
> 
> dmesg: 
> 
> 8D0, 0014 (r0 PTLTD )
> ACPI: RSDT BFF631DD, 003C (r1 PTLTD    RSDT    6040000  LTP        0)
> ACPI: FACP BFF68E10, 0074 (r1 INTEL  TUMWATER  6040000 PTL         3)
> ACPI: DSDT BFF64ACF, 4341 (r1  Intel BLAKFORD  6040000 MSFT  100000E)
> ACPI: FACS BFF69FC0, 0040
> ACPI: APIC BFF68E84, 00C8 (r1 PTLTD      APIC    6040000  LTP        0)
> ACPI: MCFG BFF68F4C, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
> ACPI: BOOT BFF68F88, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
> ACPI: SPCR BFF68FB0, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
> ACPI: SSDT BFF63219, 13EC (r1  PmRef    CpuPm     3000 INTL 20050228)
> ACPI: Local APIC address 0xfee00000
> (7 early reservations) ==> bootmem [0000000000 - 0140000000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
>   #2 [0000200000 - 00006cabc8]    TEXT DATA BSS ==> [0000200000 - 00006cabc8]
>   #3 [0037eba000 - 0037fefe92]          RAMDISK ==> [0037eba000 - 0037fefe92]
>   #4 [000009c800 - 0000100000]    BIOS reserved ==> [000009c800 - 0000100000]
>   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
>   #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
> found SMP MP-table at [ffff8800000f5900] 000f5900
>  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff]
> on node 0
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   0x00100000 -> 0x00140000
> Movable zone start PFN for each node
> early_node_map[3] active PFN ranges
>     0: 0x00000000 -> 0x0000009c
>     0: 0x00000100 -> 0x000bff60
>     0: 0x00100000 -> 0x00140000
> On node 0 totalpages: 1048316
>   DMA zone: 56 pages used for memmap
>   DMA zone: 1334 pages reserved
>   DMA zone: 2606 pages, LIFO batch:0
>   DMA32 zone: 14280 pages used for memmap
>   DMA32 zone: 767896 pages, LIFO batch:31
>   Normal zone: 3584 pages used for memmap
>   Normal zone: 258560 pages, LIFO batch:31
>   Movable zone: 0 pages used for memmap
> ACPI: PM-Timer IO Port: 0x1008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
> ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
> ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
> ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
> ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
> ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
> IOAPIC[1]: apic_id 9, version 0, address 0xfec80000, GSI 24-47
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Using ACPI (MADT) for SMP configuration information
> SMP: Allowing 8 CPUs, 0 hotplug CPUs
> Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
> PERCPU: Allocating 45056 bytes of per cpu data
> NR_CPUS: 8, nr_cpu_ids: 8, nr_node_ids 1
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029062
> Kernel command line: ro root=LABEL=/1 profile=2 console=ttyS0,38400 
> kernel profiling enabled (shift: 2)
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Fast TSC calibration using PIT
> Detected 2400.210 MHz processor.
> Console: colour VGA+ 80x25
> console [ttyS0] enabled
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Checking aperture...
> No AGP bridge found
> Calgary: detecting Calgary via BIOS EBDA area
> Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> Placing software IO TLB between 0x20000000 - 0x24000000
> Memory: 4039052k/5242880k available (2745k kernel code, 153224k reserved, 1353k
> data, 328k init)
> Calibrating delay loop (skipped), value calculated using timer frequency..
> 4800.42 BogoMIPS (lpj=9600840)
> Mount-cache hash table entries: 256
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 4096K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> CPU0: Thermal monitoring handled by SMI
> using mwait in idle threads.
> ACPI: Core revision 20080926
> Parsing all Control Methods:
> Table [DSDT](id 0001) - 421 Objects with 47 Devices 131 Methods 22 Regions
> Parsing all Control Methods:
> Table [SSDT](id 0002) - 43 Objects with 0 Devices 16 Methods 0 Regions
>  tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully acquired
> evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
> Setting APIC routing to flat
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: Intel(R) Xeon(R) CPU           X5340  @ 2.40GHz stepping 07
> Booting processor 1 APIC 0x4 ip 0x6000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 4800.39 BogoMIPS (lpj=9600793)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 4096K
> CPU: Physical Processor ID: 1
> CPU: Processor Core ID: 0
> CPU1: Thermal monitoring enabled (TM2)
> CPU1: Intel(R) Xeon(R) CPU           X5340  @ 2.40GHz stepping 07
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Booting processor 2 APIC 0x1 ip 0x6000
> Initializing CPU#2
> Calibrating delay using timer specific routine.. 4800.39 BogoMIPS (lpj=9600792)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 4096K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> CPU2: Thermal monitoring enabled (TM2)
> CPU2: Intel(R) Xeon(R) CPU           X5340  @ 2.40GHz stepping 07
> checking TSC synchronization [CPU#0 -> CPU#2]: passed.
> Booting processor 3 APIC 0x5 ip 0x6000
> Initializing CPU#3
> Calibrating delay using timer specific routine.. 4800.39 BogoMIPS (lpj=9600792)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 4096K
> CPU: Physical Processor ID: 1
> CPU: Processor Core ID: 1
> CPU3: Thermal monitoring enabled (TM2)
> CPU3: Intel(R) Xeon(R) CPU           X5340  @ 2.40GHz stepping 07
> checking TSC synchronization [CPU#0 -> CPU#3]: passed.
> Booting processor 4 APIC 0x2 ip 0x6000
> Initializing CPU#4
> Calibrating delay using timer specific routine.. 4800.36 BogoMIPS (lpj=9600737)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 4096K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 2
> CPU4: Thermal monitoring enabled (TM2)
> CPU4: Intel(R) Xeon(R) CPU           X5340  @ 2.40GHz stepping 07
> checking TSC synchronization [CPU#0 -> CPU#4]: passed.
> Booting processor 5 APIC 0x6 ip 0x6000
> Initializing CPU#5
> Calibrating delay using timer specific routine.. 4800.39 BogoMIPS (lpj=9600791)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 4096K
> CPU: Physical Processor ID: 1
> CPU: Processor Core ID: 2
> CPU5: Thermal monitoring enabled (TM2)
> CPU5: Intel(R) Xeon(R) CPU           X5340  @ 2.40GHz stepping 07
> checking TSC synchronization [CPU#0 -> CPU#5]: passed.
> Booting processor 6 APIC 0x3 ip 0x6000
> Initializing CPU#6
> Calibrating delay using timer specific routine.. 4800.36 BogoMIPS (lpj=9600728)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 4096K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 3
> CPU6: Thermal monitoring enabled (TM2)
> CPU6: Intel(R) Xeon(R) CPU           X5340  @ 2.40GHz stepping 07
> checking TSC synchronization [CPU#0 -> CPU#6]: passed.
> Booting processor 7 APIC 0x7 ip 0x6000
> Initializing CPU#7
> Calibrating delay using timer specific routine.. 4801.13 BogoMIPS (lpj=9602264)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 4096K
> CPU: Physical Processor ID: 1
> CPU: Processor Core ID: 3
> CPU7: Thermal monitoring enabled (TM2)
> CPU7: Intel(R) Xeon(R) CPU           X5340  @ 2.40GHz stepping 07
> checking TSC synchronization [CPU#0 -> CPU#7]: passed.
> Brought up 8 CPUs
> Total of 8 processors activated (38403.86 BogoMIPS).
> net_namespace: 888 bytes
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 10
> PCI: MCFG area at e0000000 reserved in E820
> PCI: Using MMCONFIG at e0000000 - e0afffff
> PCI: Using configuration type 1 for base access
> evgpeblk-0957 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int
> 0x9
> ACPI: EC: Look up EC in DSDT
> Completing Region/Field/Buffer/Package
> initialization:.........................................................................
> Initialized 17/22 Regions 0/0 Fields 35/35 Buffers 21/21 Packages (473 nodes)
> Initializing Device/Processor/Thermal objects by executing _INI methods:.
> Executed 1 _INI methods requiring 0 _STA executions (examined 57 objects)
> evgpeblk-1054 [00] ev_initialize_gpe_bloc: Found 9 Wake, Enabled 0 Runtime GPEs
> in this block
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:00.0: PME# disabled
> pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:02.0: PME# disabled
> pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:04.0: PME# disabled
> pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:06.0: PME# disabled
> pci 0000:00:08.0: reg 10 64bit mmio: [0xfe700000-0xfe7003ff]
> pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:08.0: PME# disabled
> pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.0: PME# disabled
> pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
> pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
> pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
> pci 0000:00:1d.7: reg 10 32bit mmio: [0xc8000000-0xc80003ff]
> pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> pci 0000:00:1d.7: PME# disabled
> pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
> pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
> pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
> pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
> pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
> pci 0000:00:1f.1: reg 20 io port: [0x1860-0x186f]
> pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
> pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:01:00.0: PME# disabled
> pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
> pci 0000:01:00.3: PME# disabled
> pci 0000:00:02.0: bridge io port: [0x2000-0x3fff]
> pci 0000:00:02.0: bridge 32bit mmio: [0xc8100000-0xc83fffff]
> pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:02:00.0: PME# disabled
> pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
> pci 0000:02:02.0: PME# disabled
> pci 0000:01:00.0: bridge io port: [0x2000-0x3fff]
> pci 0000:01:00.0: bridge 32bit mmio: [0xc8200000-0xc83fffff]
> pci 0000:03:00.0: PXH quirk detected; SHPC device MSI disabled
> pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:03:00.0: PME# disabled
> pci 0000:03:00.2: PXH quirk detected; SHPC device MSI disabled
> pci 0000:03:00.2: PME# supported from D0 D3hot D3cold
> pci 0000:03:00.2: PME# disabled
> pci 0000:02:00.0: bridge io port: [0x2000-0x2fff]
> pci 0000:02:00.0: bridge 32bit mmio: [0xc8200000-0xc82fffff]
> pci 0000:04:02.0: reg 10 io port: [0x2400-0x24ff]
> pci 0000:04:02.0: reg 14 64bit mmio: [0xc8200000-0xc8201fff]
> pci 0000:04:02.0: reg 1c io port: [0x2000-0x20ff]
> pci 0000:04:02.0: reg 30 32bit mmio: [0x000000-0x07ffff]
> pci 0000:04:02.1: reg 10 io port: [0x2c00-0x2cff]
> pci 0000:04:02.1: reg 14 64bit mmio: [0xc8202000-0xc8203fff]
> pci 0000:04:02.1: reg 1c io port: [0x2800-0x28ff]
> pci 0000:04:02.1: reg 30 32bit mmio: [0x000000-0x07ffff]
> pci 0000:03:00.0: bridge io port: [0x2000-0x2fff]
> pci 0000:03:00.0: bridge 32bit mmio: [0xc8200000-0xc82fffff]
> pci 0000:06:00.0: reg 10 32bit mmio: [0xc8320000-0xc833ffff]
> pci 0000:06:00.0: reg 14 32bit mmio: [0xc8300000-0xc831ffff]
> pci 0000:06:00.0: reg 18 io port: [0x3000-0x301f]
> pci 0000:06:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
> pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:06:00.0: PME# disabled
> pci 0000:06:00.1: reg 10 32bit mmio: [0xc8360000-0xc837ffff]
> pci 0000:06:00.1: reg 14 32bit mmio: [0xc8340000-0xc835ffff]
> pci 0000:06:00.1: reg 18 io port: [0x3020-0x303f]
> pci 0000:06:00.1: reg 30 32bit mmio: [0x000000-0x00ffff]
> pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
> pci 0000:06:00.1: PME# disabled
> pci 0000:02:02.0: bridge io port: [0x3000-0x3fff]
> pci 0000:02:02.0: bridge 32bit mmio: [0xc8300000-0xc83fffff]
> pci 0000:0b:01.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
> pci 0000:0b:01.0: reg 14 io port: [0x4000-0x40ff]
> pci 0000:0b:01.0: reg 18 32bit mmio: [0xc8400000-0xc840ffff]
> pci 0000:0b:01.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> pci 0000:0b:01.0: supports D1 D2
> pci 0000:00:1e.0: transparent bridge
> pci 0000:00:1e.0: bridge io port: [0x4000-0x4fff]
> pci 0000:00:1e.0: bridge 32bit mmio: [0xc8400000-0xc84fffff]
> pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
> bus 00 -> node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD0.PXH0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD0.PXH1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMD0.BPD2._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2.BMF3._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 14 15) *9
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 14 15)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
> SCSI subsystem initialized
> PCI: Using ACPI for IRQ routing
> PCI-GART: No AMD northbridge found.
> hpet clockevent registered
> HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 13 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:01: ioport range 0x4d0-0x4d1 has been reserved
> system 00:01: ioport range 0x295-0x296 has been reserved
> system 00:01: ioport range 0xca2-0xca3 has been reserved
> system 00:01: ioport range 0xca8-0xcaf has been reserved
> system 00:01: ioport range 0x1000-0x107f has been reserved
> system 00:01: ioport range 0x1180-0x11bf has been reserved
> system 00:01: ioport range 0x800-0x80f has been reserved
> system 00:01: ioport range 0xfe00-0xfe00 has been reserved
> system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
> system 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
> system 00:01: iomem range 0xfec80000-0xfec80fff has been reserved
> system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
> system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
> system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
> pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
> pci 0000:03:00.0:   IO window: 0x2000-0x2fff
> pci 0000:03:00.0:   MEM window: 0xc8200000-0xc82fffff
> pci 0000:03:00.0:   PREFETCH window: 0x000000c2000000-0x000000c20fffff
> pci 0000:03:00.2: PCI bridge, secondary bus 0000:05
> pci 0000:03:00.2:   IO window: disabled
> pci 0000:03:00.2:   MEM window: disabled
> pci 0000:03:00.2:   PREFETCH window: disabled
> pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
> pci 0000:02:00.0:   IO window: 0x2000-0x2fff
> pci 0000:02:00.0:   MEM window: 0xc8200000-0xc82fffff
> pci 0000:02:00.0:   PREFETCH window: 0x000000c2000000-0x000000c20fffff
> pci 0000:02:02.0: PCI bridge, secondary bus 0000:06
> pci 0000:02:02.0:   IO window: 0x3000-0x3fff
> pci 0000:02:02.0:   MEM window: 0xc8300000-0xc83fffff
> pci 0000:02:02.0:   PREFETCH window: 0x000000c2100000-0x000000c21fffff
> pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
> pci 0000:01:00.0:   IO window: 0x2000-0x3fff
> pci 0000:01:00.0:   MEM window: 0xc8200000-0xc83fffff
> pci 0000:01:00.0:   PREFETCH window: 0x000000c2000000-0x000000c21fffff
> pci 0000:01:00.3: PCI bridge, secondary bus 0000:07
> pci 0000:01:00.3:   IO window: disabled
> pci 0000:01:00.3:   MEM window: disabled
> pci 0000:01:00.3:   PREFETCH window: disabled
> pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
> pci 0000:00:02.0:   IO window: 0x2000-0x3fff
> pci 0000:00:02.0:   MEM window: 0xc8100000-0xc83fffff
> pci 0000:00:02.0:   PREFETCH window: 0x000000c2000000-0x000000c21fffff
> pci 0000:00:04.0: PCI bridge, secondary bus 0000:08
> pci 0000:00:04.0:   IO window: disabled
> pci 0000:00:04.0:   MEM window: disabled
> pci 0000:00:04.0:   PREFETCH window: disabled
> pci 0000:00:06.0: PCI bridge, secondary bus 0000:09
> pci 0000:00:06.0:   IO window: disabled
> pci 0000:00:06.0:   MEM window: disabled
> pci 0000:00:06.0:   PREFETCH window: disabled
> pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0a
> pci 0000:00:1c.0:   IO window: disabled
> pci 0000:00:1c.0:   MEM window: disabled
> pci 0000:00:1c.0:   PREFETCH window: disabled
> pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0b
> pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
> pci 0000:00:1e.0:   MEM window: 0xc8400000-0xc84fffff
> pci 0000:00:1e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
> pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> pci 0000:00:02.0: setting latency timer to 64
> pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> pci 0000:01:00.0: setting latency timer to 64
> pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> pci 0000:02:00.0: setting latency timer to 64
> pci 0000:03:00.0: setting latency timer to 64
> pci 0000:03:00.2: setting latency timer to 64
> pci 0000:02:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> pci 0000:02:02.0: setting latency timer to 64
> pci 0000:01:00.3: setting latency timer to 64
> pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> pci 0000:00:04.0: setting latency timer to 64
> pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> pci 0000:00:06.0: setting latency timer to 64
> pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> pci 0000:00:1c.0: setting latency timer to 64
> pci 0000:00:1e.0: setting latency timer to 64
> bus: 00 index 0 io port: [0x00-0xffff]
> bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
> bus: 01 index 0 io port: [0x2000-0x3fff]
> bus: 01 index 1 mmio: [0xc8100000-0xc83fffff]
> bus: 01 index 2 mmio: [0xc2000000-0xc21fffff]
> bus: 01 index 3 mmio: [0x0-0x0]
> bus: 02 index 0 io port: [0x2000-0x3fff]
> bus: 02 index 1 mmio: [0xc8200000-0xc83fffff]
> bus: 02 index 2 mmio: [0xc2000000-0xc21fffff]
> bus: 02 index 3 mmio: [0x0-0x0]
> bus: 03 index 0 io port: [0x2000-0x2fff]
> bus: 03 index 1 mmio: [0xc8200000-0xc82fffff]
> bus: 03 index 2 mmio: [0xc2000000-0xc20fffff]
> bus: 03 index 3 mmio: [0x0-0x0]
> bus: 04 index 0 io port: [0x2000-0x2fff]
> bus: 04 index 1 mmio: [0xc8200000-0xc82fffff]
> bus: 04 index 2 mmio: [0xc2000000-0xc20fffff]
> bus: 04 index 3 mmio: [0x0-0x0]
> bus: 05 index 0 mmio: [0x0-0x0]
> bus: 05 index 1 mmio: [0x0-0x0]
> bus: 05 index 2 mmio: [0x0-0x0]
> bus: 05 index 3 mmio: [0x0-0x0]
> bus: 06 index 0 io port: [0x3000-0x3fff]
> bus: 06 index 1 mmio: [0xc8300000-0xc83fffff]
> bus: 06 index 2 mmio: [0xc2100000-0xc21fffff]
> bus: 06 index 3 mmio: [0x0-0x0]
> bus: 07 index 0 mmio: [0x0-0x0]
> bus: 07 index 1 mmio: [0x0-0x0]
> bus: 07 index 2 mmio: [0x0-0x0]
> bus: 07 index 3 mmio: [0x0-0x0]
> bus: 08 index 0 mmio: [0x0-0x0]
> bus: 08 index 1 mmio: [0x0-0x0]
> bus: 08 index 2 mmio: [0x0-0x0]
> bus: 08 index 3 mmio: [0x0-0x0]
> bus: 09 index 0 mmio: [0x0-0x0]
> bus: 09 index 1 mmio: [0x0-0x0]
> bus: 09 index 2 mmio: [0x0-0x0]
> bus: 09 index 3 mmio: [0x0-0x0]
> bus: 0a index 0 mmio: [0x0-0x0]
> bus: 0a index 1 mmio: [0x0-0x0]
> bus: 0a index 2 mmio: [0x0-0x0]
> bus: 0a index 3 mmio: [0x0-0x0]
> bus: 0b index 0 io port: [0x4000-0x4fff]
> bus: 0b index 1 mmio: [0xc8400000-0xc84fffff]
> bus: 0b index 2 mmio: [0xd0000000-0xd7ffffff]
> bus: 0b index 3 io port: [0x00-0xffff]
> bus: 0b index 4 mmio: [0x000000-0xffffffffffffffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> TCP: Hash tables configured (established 262144 bind 65536)
> TCP reno registered
> NET: Registered protocol family 1
> checking if image is initramfs... it is
> Freeing initrd memory: 1239k freed
> Simple Boot Flag at 0x38 set to 0x1
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> msgmni has been set to 7893
> io scheduler noop registered
> io scheduler anticipatory registered (default)
> io scheduler deadline registered
> io scheduler cfq registered
> pci 0000:0b:01.0: Boot video device
> input: Power Button (FF) as /class/input/input0
> ACPI: Power Button (FF) [PWRF]
> input: Power Button (CM) as /class/input/input1
> ACPI: Power Button (CM) [PWRB]
> ACPI: SSDT BFF64605, 0200 (r1  PmRef  Cpu0Ist     3000 INTL 20050228)
> Parsing all Control Methods:
> Table [SSDT](id 00C6) - 5 Objects with 0 Devices 2 Methods 0 Regions
> processor ACPI0007:00: registered as cooling_device0
> ACPI: Processor [CPU0] (supports 8 throttling states)
> ACPI: SSDT BFF64805, 0066 (r1  PmRef  Cpu1Ist     3000 INTL 20050228)
> Parsing all Control Methods:
> Table [SSDT](id 00C9) - 3 Objects with 0 Devices 2 Methods 0 Regions
> processor ACPI0007:01: registered as cooling_device1
> ACPI: Processor [CPU1] (supports 8 throttling states)
> ACPI: SSDT BFF6486B, 0066 (r1  PmRef  Cpu2Ist     3000 INTL 20050228)
> Parsing all Control Methods:
> Table [SSDT](id 00CC) - 3 Objects with 0 Devices 2 Methods 0 Regions
> processor ACPI0007:02: registered as cooling_device2
> ACPI: Processor [CPU2] (supports 8 throttling states)
> ACPI: SSDT BFF648D1, 0066 (r1  PmRef  Cpu3Ist     3000 INTL 20050228)
> Parsing all Control Methods:
> Table [SSDT](id 00CF) - 3 Objects with 0 Devices 2 Methods 0 Regions
> processor ACPI0007:03: registered as cooling_device3
> ACPI: Processor [CPU3] (supports 8 throttling states)
> ACPI: SSDT BFF64937, 0066 (r1  PmRef  CPU4Ist     3000 INTL 20050228)
> Parsing all Control Methods:
> Table [SSDT](id 00D2) - 3 Objects with 0 Devices 2 Methods 0 Regions
> processor ACPI0007:04: registered as cooling_device4
> ACPI: Processor [CPU4] (supports 8 throttling states)
> ACPI: SSDT BFF6499D, 0066 (r1  PmRef  CPU5Ist     3000 INTL 20050228)
> Parsing all Control Methods:
> Table [SSDT](id 00D5) - 3 Objects with 0 Devices 2 Methods 0 Regions
> processor ACPI0007:05: registered as cooling_device5
> ACPI: Processor [CPU5] (supports 8 throttling states)
> ACPI: SSDT BFF64A03, 0066 (r1  PmRef  Cpu6Ist     3000 INTL 20050228)
> Parsing all Control Methods:
> Table [SSDT](id 00D8) - 3 Objects with 0 Devices 2 Methods 0 Regions
> processor ACPI0007:06: registered as cooling_device6
> ACPI: Processor [CPU6] (supports 8 throttling states)
> ACPI: SSDT BFF64A69, 0066 (r1  PmRef  Cpu7Ist     3000 INTL 20050228)
> Parsing all Control Methods:
> Table [SSDT](id 00DB) - 3 Objects with 0 Devices 2 Methods 0 Regions
> processor ACPI0007:07: registered as cooling_device7
> ACPI: Processor [CPU7] (supports 8 throttling states)
> Real Time Clock Driver v1.12ac
> intel_rng: FWH not detected
> Linux agpgart interface v0.103
> Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60
> seconds).
> Hangcheck: Using get_cycles().
> Serial: 8250/16550 driver4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a post-1991 82077
> brd: module loaded
> loop: module loaded
> Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> Copyright (c) 1999-2006 Intel Corporation.
> console [netcon0] enabled
> netconsole: network logging started
> Uniform Multi-Platform E-IDE driver
> piix 0000:00:1f.1: IDE controller (0x8086:0x269e rev 0x09)
> pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> piix 0000:00:1f.1: IDE port disabled
> piix 0000:00:1f.1: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0x1860-0x1867
> Probing IDE interface ide0...
> hdb: LITE-ON COMBO SOHC-5236V, ATAPI CD/DVD-ROM drive
> hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hdb: UDMA/44 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide_generic: please use "probe_mask=0x3f" module parameter for probing all
> legacy ISA IDE ports
> ide-gd driver 1.18
> ide-cd driver 5.00
> ide-cd: hdb: ATAPI 52X DVD-ROM CD-R/RW drive, 1536kB Cache
> Uniform CD-ROM driver Revision: 3.20
> aic79xx 0000:04:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
>         <Adaptec AIC7902 Ultra320 SCSI adapter>
>         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100MHz, 512 SCBs
> scsi 0:0:6:0: Direct-Access     HITACHI  HUS103073FL3800  SA1B PQ: 0 ANSI: 3
>  target0:0:6: asynchronous
> scsi0:A:6:0: Tagged Queuing enabled.  Depth 32
>  target0:0:6: Beginning Domain Validation
>  target0:0:6: wide asynchronous
>  target0:0:6: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW PCOMP
> (6.25 ns, offset 80)
>  target0:0:6: Ending Domain Validation
> scsi 0:0:8:0: Processor         SUPER    GEM359 REV001    1.09 PQ: 0 ANSI: 2
>  target0:0:8: asynchronous
>  target0:0:8: Beginning Domain Validation
>  target0:0:8: Ending Domain Validation
> scsi 0:0:9:0: Direct-Access     SEAGATE  ST336607LC       0007 PQ: 0 ANSI: 3
>  target0:0:9: asynchronous
> scsi0:A:9:0: Tagged Queuing enabled.  Depth 32
>  target0:0:9: Beginning Domain Validation
>  target0:0:9: wide asynchronous
>  target0:0:9: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW PCOMP
> (6.25 ns, offset 63)
>  target0:0:9: Ending Domain Validation
> aic79xx 0000:04:02.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
>         <Adaptec AIC7902 Ultra320 SCSI adapter>
>         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100MHz, 512 SCBs
> Driver 'sd' needs updating - please use bus_type methods
> sd 0:0:6:0: [sda] 143374805 512-byte hardware sectors: (73.4 GB/68.3 GiB)
> sd 0:0:6:0: [sda] Write Protect is off
> sd 0:0:6:0: [sda] Mode Sense: c3 00 10 08
> sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and
> FUA
> sd 0:0:6:0: [sda] 143374805 512-byte hardware sectors: (73.4 GB/68.3 GiB)
> sd 0:0:6:0: [sda] Write Protect is off
> sd 0:0:6:0: [sda] Mode Sense: c3 00 10 08
> sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and
> FUA
>  sda: sda1 sda2
> sd 0:0:6:0: [sda] Attached SCSI disk
> sd 0:0:9:0: [sdb] 71687372 512-byte hardware sectors: (36.7 GB/34.1 GiB)
> sd 0:0:9:0: [sdb] Write Protect is off
> sd 0:0:9:0: [sdb] Mode Sense: ab 00 10 08
> sd 0:0:9:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and
> FUA
> sd 0:0:9:0: [sdb] 71687372 512-byte hardware sectors: (36.7 GB/34.1 GiB)
> sd 0:0:9:0: [sdb] Write Protect is off
> sd 0:0:9:0: [sdb] Mode Sense: ab 00 10 08
> sd 0:0:9:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and
> FUA
>  sdb: sdb1 sdb2
> sd 0:0:9:0: [sdb] Attached SCSI disk
> PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> oprofile: using NMI interrupt.
> TCP cubic registered
> input: AT Translated Set 2 keyboard as /class/input/input2
> NET: Registered protocol family 10
> IPv6 over IPv4 tunneling driver
> NET: Registered protocol family 17
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> Freeing unused kernel memory: 328k freed
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.
> input: PS/2 Generic Mouse as /class/input/input3
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> e1000e: Copyright (c) 1999-2008 Intel Corporation.
> e1000e 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> e1000e 0000:06:00.0: setting latency timer to 64
> e1000e 0000:06:00.0: irq 95 for MSI/MSI-X
> 0000:06:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:30:48:30:61:16
> 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
> 0000:06:00.0: eth0: MAC: 4, PHY: 5, PBA No: ffffff-0ff
> e1000e 0000:06:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> e1000e 0000:06:00.1: setting latency timer to 64
> e1000e 0000:06:00.1: irq 94 for MSI/MSI-X
> 0000:06:00.1: eth1: (PCI Express:2.5GB/s:Width x4) 00:30:48:30:61:17
> 0000:06:00.1: eth1: Intel(R) PRO/1000 Network Connection
> 0000:06:00.1: eth1: MAC: 4, PHY: 5, PBA No: ffffff-0ff
> EXT3 FS on sda1, internal journal
> Adding 4096564k swap on /dev/sda2.  Priority:-1 extents:1 across:4096564k
> Adding 5123064k swap on /dev/sdb2.  Priority:-2 extents:1 across:5123064k
> platform microcode: firmware: requesting intel-ucode/06-0f-07
> platform microcode: firmware: requesting intel-ucode/06-0f-07
> platform microcode: firmware: requesting intel-ucode/06-0f-07
> platform microcode: firmware: requesting intel-ucode/06-0f-07
> platform microcode: firmware: requesting intel-ucode/06-0f-07
> platform microcode: firmware: requesting intel-ucode/06-0f-07
> platform microcode: firmware: requesting intel-ucode/06-0f-07
> platform microcode: firmware: requesting intel-ucode/06-0f-07
> Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>
> <peter.oruba@amd.com>
> Microcode Update Driver: v2.00 removed.
> warning: process `kudzu' used the deprecated sysctl system call with 1.23.
> process `sysctl' is using deprecated sysctl (syscall)
> net.ipv6.neigh.default.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms
> instead.
> e1000e 0000:06:00.0: irq 95 for MSI/MSI-X
> e1000e 0000:06:00.0: irq 95 for MSI/MSI-X
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> 0000:06:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None
> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
> eth0: no IPv6 routers present
> 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
