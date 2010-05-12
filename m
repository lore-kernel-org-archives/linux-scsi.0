From: "Phil Reynolds" <phil-linux@tinsleyviaduct.com>
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
Date: Wed, 12 May 2010 05:59:35 +0100
Message-ID: <20100512055935.707919p7r441z54n@topdeck.tinsleyviaduct.com>
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
	<4BE964C2.1010702@turmel.org>
	<20100511182128.216144e4uzjtufbs@topdeck.tinsleyviaduct.com>
	<4BE9A1B3.3020208@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_187jj9a6milz"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from topdeck.tinsleyviaduct.com ([62.49.246.82]:41536 "EHLO
	topdeck.tinsleyviaduct.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729Ab0ELE7j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 00:59:39 -0400
In-Reply-To: <4BE9A1B3.3020208@turmel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phil Turmel <pturmel-kernel@turmel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This message is in MIME format.

--=_187jj9a6milz
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Quoting "Phil Turmel" <pturmel-kernel@turmel.org>:

> Hmmm.  If you post your dmesg, lspci, and config, I'll be happy to compare
> to my setup.  It might be something as simple as the Marvell driver loading
> first and claiming the device.

They are attached - and I think you are right about the cause.

> The Marvell driver never gets a chance to claim my device, as it is  
> disabled in
> my kernel config.  If you are using modules, you might want to  
> blacklist "sata_mv".

Tried that - no change.

> If you are using modules from an initramfs, you might need to update your
> initramfs, too.

That is possible but I am not very familiar with modifying this.

-- 
Phil Reynolds
email: phil-linux@tinsleyviaduct.com
Not subscribed to lkml - please CC replies to me

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


--=_187jj9a6milz
Content-Type: text/plain;
	charset=UTF-8;
	name="dmesg.noesata"
Content-Disposition: attachment;
	filename="dmesg.noesata"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-bpo.3-amd64 (Debian 2.6.32-9~bpo50+1) (n=
orbert@tretkowski.de) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Mon Mar=
 15 13:49:35 UTC 2010
[    0.000000] Command line: root=3D/dev/mapper/vg0-root ro quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffb0000 - 000000007ffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffbe000 - 000000007ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around i=
t.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usabl=
e) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x7ffb0 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070=
106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-000000007ffb0000
[    0.000000]  0000000000 - 0040000000 page 1G
[    0.000000]  0040000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007ffb0000 page 4k
[    0.000000] kernel direct mapping tables up to 7ffb0000 @ 10000-13000
[    0.000000] RAMDISK: 376a0000 - 37fef675
[    0.000000] ACPI: RSDP 00000000000fa220 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 000000007ffb0000 0003C (v01 112609 OEMRSDT  200911=
26 MSFT 00000097)
[    0.000000] ACPI: FACP 000000007ffb0200 00084 (v02 112609 OEMFACP  200911=
26 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000007ffb0440 0B322 (v01  P0024 P0024000 000000=
00 INTL 20051117)
[    0.000000] ACPI: FACS 000000007ffbe000 00040
[    0.000000] ACPI: APIC 000000007ffb0390 0006C (v01 112609 OEMAPIC  200911=
26 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000007ffb0400 0003C (v01 112609 OEMMCFG  200911=
26 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000007ffbe040 00071 (v01 112609 AMI_OEM  200911=
26 MSFT 00000097)
[    0.000000] ACPI: HPET 000000007ffbb770 00038 (v01 112609 OEMHPET  200911=
26 MSFT 00000097)
[    0.000000] ACPI: SSDT 000000007ffbb7b0 003FC (v01 A M I  POWERNOW 000000=
01 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007ffb0000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007ffb0000
[    0.000000]   NODE_DATA [0000000000012000 - 0000000000019fff]
[    0.000000]   bootmap [000000000001a000 -  0000000000029ff7] pages 10
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 007ffb00=
00]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000=
000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [0000=
006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001664a14]    TEXT DATA BSS =3D=3D> [0001=
000000 - 0001664a14]
[    0.000000]   #3 [00376a0000 - 0037fef675]          RAMDISK =3D=3D> [0037=
6a0000 - 0037fef675]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved =3D=3D> [0000=
09f800 - 0000100000]
[    0.000000]   #5 [0001665000 - 0001665199]              BRK =3D=3D> [0001=
665000 - 0001665199]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE =3D=3D> [0000=
010000 - 0000012000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880001c00000=
-ffff8800037fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007ffb0
[    0.000000] On node 0 totalpages: 524095
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 101 pages reserved
[    0.000000]   DMA zone: 3826 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7111 pages used for memmap
[    0.000000]   DMA32 zone: 513001 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 33, address 0xfec00000, GSI 0-2=
3
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 1 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a=
0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e=
4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 000000000010=
0000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:=
7ff00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880001800000 s89880 r8192 =
d20712 u524288
[    0.000000] pcpu-alloc: s89880 r8192 d20712 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total=
 pages: 516827
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=3D/dev/mapper/vg0-root ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 39a2000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 2050840k/2096832k available (3014k kernel code, 452k =
absent, 45540k reserved, 1836k data, 580k init)
[    0.000000] SLUB: Genslabs=3D14, HWalign=3D64, Order=3D0-3, MinObjects=3D=
0, CPUs=3D4, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000]   alloc irq_desc for 24 on node 0
[    0.000000]   alloc kstat_irqs on node 0
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu ti=
mer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2307.936 MHz processor.
[    0.008006] Calibrating delay loop (skipped), value calculated using time=
r frequency.. 4615.86 BogoMIPS (lpj=3D9231732)
[    0.008033] Security Framework initialized
[    0.008037] SELinux:  Disabled at boot.
[    0.008180] Dentry cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.008721] Inode-cache hash table entries: 131072 (order: 8, 1048576 byt=
es)
[    0.009075] Mount-cache hash table entries: 256
[    0.009207] Initializing cgroup subsys ns
[    0.009210] Initializing cgroup subsys cpuacct
[    0.009213] Initializing cgroup subsys devices
[    0.009216] Initializing cgroup subsys freezer
[    0.009217] Initializing cgroup subsys net_cls
[    0.012022] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/l=
ine)
[    0.012024] CPU: L2 Cache: 512K (64 bytes/line)
[    0.012026] CPU 0/0x0 -> Node 0
[    0.012029] tseg: 0000000000
[    0.012041] CPU: Physical Processor ID: 0
[    0.012043] CPU: Processor Core ID: 0
[    0.012045] mce: CPU supports 6 MCE banks
[    0.012054] using C1E aware idle routine
[    0.012056] Performance Events: AMD PMU driver.
[    0.012060] ... version:                0
[    0.012061] ... bit width:              48
[    0.012063] ... generic registers:      4
[    0.012064] ... value mask:             0000ffffffffffff
[    0.012066] ... max period:             00007fffffffffff
[    0.012067] ... fixed-purpose events:   0
[    0.012068] ... event mask:             000000000000000f
[    0.012756] ACPI: Core revision 20090903
[    0.028078] Setting APIC routing to flat
[    0.028379] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-=
1
[    0.070055] CPU0: AMD Phenom(tm) 8650 Triple-Core Processor stepping 03
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.012000] Initializing CPU#1
[    0.012000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/l=
ine)
[    0.012000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.012000] CPU 1/0x1 -> Node 0
[    0.012000] CPU: Physical Processor ID: 0
[    0.012000] CPU: Processor Core ID: 1
[    0.156099] CPU1: AMD Phenom(tm) 8650 Triple-Core Processor stepping 03
[    0.156106] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160056] Booting processor 2 APIC 0x2 ip 0x6000
[    0.012000] Initializing CPU#2
[    0.012000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/l=
ine)
[    0.012000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.012000] CPU 2/0x2 -> Node 0
[    0.012000] CPU: Physical Processor ID: 0
[    0.012000] CPU: Processor Core ID: 2
[    0.248039] CPU2: AMD Phenom(tm) 8650 Triple-Core Processor stepping 03
[    0.248045] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.252012] Brought up 3 CPUs
[    0.252014] Total of 3 processors activated (13847.43 BogoMIPS).
[    0.252662] CPU0 attaching sched-domain:
[    0.252664]  domain 0: span 0-2 level MC
[    0.252666]   groups: 0 1 2
[    0.252672] CPU1 attaching sched-domain:
[    0.252673]  domain 0: span 0-2 level MC
[    0.252675]   groups: 1 2 0
[    0.252679] CPU2 attaching sched-domain:
[    0.252681]  domain 0: span 0-2 level MC
[    0.252683]   groups: 2 0 1
[    0.252824] devtmpfs: initialized
[    0.256183] regulator: core version 0.5
[    0.256227] NET: Registered protocol family 16
[    0.256300] node 0 link 0: io port [1000, ffffff]
[    0.256303] TOM: 0000000080000000 aka 2048M
[    0.256304] Fam 10h mmconf [e0000000, efffffff]
[    0.256308] node 0 link 0: mmio [e0000000, efffffff] =3D=3D> none
[    0.256311] node 0 link 0: mmio [f0000000, ffffffff]
[    0.256313] node 0 link 0: mmio [a0000, bffff]
[    0.256316] node 0 link 0: mmio [80000000, dfffffff]
[    0.256318] bus: [00,07] on node 0 link 0
[    0.256320] bus: 00 index 0 io port: [0, ffff]
[    0.256322] bus: 00 index 1 mmio: [f0000000, fcffffffff]
[    0.256324] bus: 00 index 2 mmio: [a0000, bffff]
[    0.256325] bus: 00 index 3 mmio: [80000000, dfffffff]
[    0.256333] ACPI: bus type pci registered
[    0.256387] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - =
255
[    0.256389] PCI: Not using MMCONFIG.
[    0.256391] PCI: Using configuration type 1 for base access
[    0.256392] PCI: Using configuration type 1 for extended access
[    0.256440] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.256442] mtrr: probably your BIOS does not setup all CPUs.
[    0.256443] mtrr: corrected configuration.
[    0.256719] bio: create slab <bio-0> at 0
[    0.257213] ACPI: EC: Look up EC in DSDT
[    0.258940] ACPI Error (psargs-0359): [ECEN] Namespace lookup failure, AE=
_NOT_FOUND
[    0.258945] ACPI Error (psparse-0537): Method parse/execution failed [\] =
(Node ffffffff81647f50), AE_NOT_FOUND
[    0.259055] ACPI Error (dsfield-0487): [SMIC] Namespace lookup failure, A=
E_ALREADY_EXISTS
[    0.259121] ACPI: Executed 4 blocks of module-level executable AML code
[    0.268421] ACPI: Interpreter enabled
[    0.268426] ACPI: (supports S0 S1 S3 S4 S5)
[    0.268453] ACPI: Using IOAPIC for interrupt routing
[    0.268573] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - =
255
[    0.271882] PCI: MCFG area at e0000000 reserved in ACPI motherboard resou=
rces
[    0.276388] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.282361] ACPI: No dock devices found.
[    0.282521] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.282566] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.282627] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.282630] pci 0000:00:02.0: PME# disabled
[    0.282672] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.282675] pci 0000:00:06.0: PME# disabled
[    0.282713] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.282715] pci 0000:00:07.0: PME# disabled
[    0.282771] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]
[    0.282778] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]
[    0.282785] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]
[    0.282792] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]
[    0.282799] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]
[    0.282806] pci 0000:00:11.0: reg 24 32bit mmio: [0xf9fff800-0xf9fffbff]
[    0.282860] pci 0000:00:12.0: reg 10 32bit mmio: [0xf9ffe000-0xf9ffefff]
[    0.282917] pci 0000:00:12.1: reg 10 32bit mmio: [0xf9ffd000-0xf9ffdfff]
[    0.282993] pci 0000:00:12.2: reg 10 32bit mmio: [0xf9fff000-0xf9fff0ff]
[    0.283048] pci 0000:00:12.2: supports D1 D2
[    0.283049] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.283054] pci 0000:00:12.2: PME# disabled
[    0.283086] pci 0000:00:13.0: reg 10 32bit mmio: [0xf9ffc000-0xf9ffcfff]
[    0.283143] pci 0000:00:13.1: reg 10 32bit mmio: [0xf9ffb000-0xf9ffbfff]
[    0.283218] pci 0000:00:13.2: reg 10 32bit mmio: [0xf9ffa800-0xf9ffa8ff]
[    0.283272] pci 0000:00:13.2: supports D1 D2
[    0.283274] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.283278] pci 0000:00:13.2: PME# disabled
[    0.283399] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.283406] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.283413] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.283419] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.283426] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.283494] pci 0000:00:14.2: reg 10 64bit mmio: [0xf9ff4000-0xf9ff7fff]
[    0.283538] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.283543] pci 0000:00:14.2: PME# disabled
[    0.283653] pci 0000:00:14.5: reg 10 32bit mmio: [0xf9ff9000-0xf9ff9fff]
[    0.283817] pci 0000:01:00.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
[    0.283824] pci 0000:01:00.0: reg 14 64bit mmio pref: [0xc0000000-0xdffff=
fff]
[    0.283832] pci 0000:01:00.0: reg 1c 64bit mmio: [0xfa000000-0xfbffffff]
[    0.283837] pci 0000:01:00.0: reg 24 io port: [0xb800-0xb87f]
[    0.283841] pci 0000:01:00.0: reg 30 32bit mmio pref: [0xfe8e0000-0xfe8ff=
fff]
[    0.288069] pci 0000:00:02.0: bridge io port: [0xb000-0xbfff]
[    0.288072] pci 0000:00:02.0: bridge 32bit mmio: [0xfa000000-0xfe8fffff]
[    0.288076] pci 0000:00:02.0: bridge 64bit mmio pref: [0xc0000000-0xdffff=
fff]
[    0.288124] pci 0000:02:00.0: reg 10 64bit mmio: [0xfe9fc000-0xfe9fffff]
[    0.288130] pci 0000:02:00.0: reg 18 io port: [0xc800-0xc8ff]
[    0.288151] pci 0000:02:00.0: reg 30 32bit mmio pref: [0xfe9c0000-0xfe9df=
fff]
[    0.288182] pci 0000:02:00.0: supports D1 D2
[    0.288184] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.288188] pci 0000:02:00.0: PME# disabled
[    0.296086] pci 0000:00:06.0: bridge io port: [0xc000-0xcfff]
[    0.296089] pci 0000:00:06.0: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
[    0.296127] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe807]
[    0.296133] pci 0000:03:00.0: reg 14 io port: [0xe400-0xe403]
[    0.296140] pci 0000:03:00.0: reg 18 io port: [0xe000-0xe007]
[    0.296146] pci 0000:03:00.0: reg 1c io port: [0xd800-0xd803]
[    0.296153] pci 0000:03:00.0: reg 20 io port: [0xd400-0xd40f]
[    0.296159] pci 0000:03:00.0: reg 24 32bit mmio: [0xfeaffc00-0xfeafffff]
[    0.296191] pci 0000:03:00.0: supports D1
[    0.296192] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.296196] pci 0000:03:00.0: PME# disabled
[    0.296218] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You=
 can enable it with 'pcie_aspm=3Dforce'
[    0.296286] pci 0000:00:07.0: bridge io port: [0xd000-0xefff]
[    0.296289] pci 0000:00:07.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.296353] pci 0000:04:06.0: reg 10 32bit mmio pref: [0xf8fff000-0xf8fff=
fff]
[    0.296473] pci 0000:04:06.1: reg 10 32bit mmio pref: [0xf8ffe000-0xf8ffe=
fff]
[    0.296605] pci 0000:04:08.0: reg 10 32bit mmio: [0xfebff000-0xfebfffff]
[    0.296666] pci 0000:04:08.0: supports D1 D2
[    0.296668] pci 0000:04:08.0: PME# supported from D0 D1 D2 D3hot
[    0.296673] pci 0000:04:08.0: PME# disabled
[    0.296727] pci 0000:00:14.4: transparent bridge
[    0.296734] pci 0000:00:14.4: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.296739] pci 0000:00:14.4: bridge 32bit mmio pref: [0xf8f00000-0xf8fff=
fff]
[    0.296756] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.296988] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.297053] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.297109] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.297188] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.302392] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0,=
 disabled.
[    0.302496] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0,=
 disabled.
[    0.302598] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0,=
 disabled.
[    0.302698] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0,=
 disabled.
[    0.302799] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0,=
 disabled.
[    0.302900] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0,=
 disabled.
[    0.303003] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 15) *0, d=
isabled.
[    0.303103] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0,=
 disabled.
[    0.303187] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.303192] vgaarb: loaded
[    0.303242] PCI: Using ACPI for IRQ routing
[    0.303249] pci 0000:00:00.0: BAR 3: address space collision on of device=
 [0xe0000000-0xffffffff]
[    0.303303] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.303458] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.303462] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.305005] Switching to clocksource tsc
[    0.305080] pnp: PnP ACPI init
[    0.305080] ACPI: bus type pnp registered
[    0.307546] pnp 00:0a: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 B=
AR 3 (0x0-0x1fffffff), disabling
[    0.307550] pnp 00:0a: mem resource (0xc0000-0xcffff) overlaps 0000:00:00=
.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.307553] pnp 00:0a: mem resource (0xe0000-0xfffff) overlaps 0000:00:00=
.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.307556] pnp 00:0a: mem resource (0x100000-0x7fffffff) overlaps 0000:0=
0:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.307868] pnp: PnP ACPI: found 11 devices
[    0.307869] ACPI: ACPI bus type pnp unregistered
[    0.307881] system 00:06: iomem range 0xfec00000-0xfec00fff could not be =
reserved
[    0.307884] system 00:06: iomem range 0xfee00000-0xfee00fff has been rese=
rved
[    0.307889] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.307893] system 00:07: ioport range 0x40b-0x40b has been reserved
[    0.307896] system 00:07: ioport range 0x4d6-0x4d6 has been reserved
[    0.307898] system 00:07: ioport range 0xc00-0xc01 has been reserved
[    0.307901] system 00:07: ioport range 0xc14-0xc14 has been reserved
[    0.307903] system 00:07: ioport range 0xc50-0xc51 has been reserved
[    0.307906] system 00:07: ioport range 0xc52-0xc52 has been reserved
[    0.307908] system 00:07: ioport range 0xc6c-0xc6c has been reserved
[    0.307911] system 00:07: ioport range 0xc6f-0xc6f has been reserved
[    0.307913] system 00:07: ioport range 0xcd0-0xcd1 has been reserved
[    0.307916] system 00:07: ioport range 0xcd2-0xcd3 has been reserved
[    0.307918] system 00:07: ioport range 0xcd4-0xcd5 has been reserved
[    0.307921] system 00:07: ioport range 0xcd6-0xcd7 has been reserved
[    0.307923] system 00:07: ioport range 0xcd8-0xcdf has been reserved
[    0.307926] system 00:07: ioport range 0x800-0x89f has been reserved
[    0.307928] system 00:07: ioport range 0xb00-0xb3f has been reserved
[    0.307931] system 00:07: ioport range 0x900-0x90f has been reserved
[    0.307934] system 00:07: ioport range 0x910-0x91f has been reserved
[    0.307936] system 00:07: ioport range 0xfe00-0xfefe has been reserved
[    0.307939] system 00:07: iomem range 0xffb80000-0xffbfffff has been rese=
rved
[    0.307942] system 00:07: iomem range 0xfec10000-0xfec1001f has been rese=
rved
[    0.307946] system 00:08: ioport range 0xe00-0xe0f has been reserved
[    0.307949] system 00:08: ioport range 0xe80-0xe8f has been reserved
[    0.307951] system 00:08: ioport range 0xf40-0xf4f has been reserved
[    0.307954] system 00:08: ioport range 0xa30-0xa3f has been reserved
[    0.307958] system 00:09: iomem range 0xe0000000-0xefffffff has been rese=
rved
[    0.307963] system 00:0a: iomem range 0xfec00000-0xffffffff could not be =
reserved
[    0.312646] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.312650] pci 0000:00:02.0:   IO window: 0xb000-0xbfff
[    0.312653] pci 0000:00:02.0:   MEM window: 0xfa000000-0xfe8fffff
[    0.312656] pci 0000:00:02.0:   PREFETCH window: 0x000000c0000000-0x00000=
0dfffffff
[    0.312661] pci 0000:00:06.0: PCI bridge, secondary bus 0000:02
[    0.312663] pci 0000:00:06.0:   IO window: 0xc000-0xcfff
[    0.312666] pci 0000:00:06.0:   MEM window: 0xfe900000-0xfe9fffff
[    0.312669] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.312672] pci 0000:00:07.0: PCI bridge, secondary bus 0000:03
[    0.312675] pci 0000:00:07.0:   IO window: 0xd000-0xefff
[    0.312678] pci 0000:00:07.0:   MEM window: 0xfea00000-0xfeafffff
[    0.312680] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.312685] pci 0000:00:14.4: PCI bridge, secondary bus 0000:04
[    0.312686] pci 0000:00:14.4:   IO window: disabled
[    0.312692] pci 0000:00:14.4:   MEM window: 0xfeb00000-0xfebfffff
[    0.312696] pci 0000:00:14.4:   PREFETCH window: 0xf8f00000-0xf8ffffff
[    0.312708]   alloc irq_desc for 18 on node 0
[    0.312710]   alloc kstat_irqs on node 0
[    0.312715] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.312719] pci 0000:00:02.0: setting latency timer to 64
[    0.312724] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.312727] pci 0000:00:06.0: setting latency timer to 64
[    0.312732]   alloc irq_desc for 19 on node 0
[    0.312734]   alloc kstat_irqs on node 0
[    0.312737] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.312740] pci 0000:00:07.0: setting latency timer to 64
[    0.312747] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.312750] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff=
]
[    0.312752] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.312754] pci_bus 0000:01: resource 1 mem: [0xfa000000-0xfe8fffff]
[    0.312757] pci_bus 0000:01: resource 2 pref mem [0xc0000000-0xdfffffff]
[    0.312759] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.312761] pci_bus 0000:02: resource 1 mem: [0xfe900000-0xfe9fffff]
[    0.312763] pci_bus 0000:03: resource 0 io:  [0xd000-0xefff]
[    0.312765] pci_bus 0000:03: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.312768] pci_bus 0000:04: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.312770] pci_bus 0000:04: resource 2 pref mem [0xf8f00000-0xf8ffffff]
[    0.312772] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.312774] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffffffffffff=
]
[    0.312802] NET: Registered protocol family 2
[    0.312911] IP route cache hash table entries: 65536 (order: 7, 524288 by=
tes)
[    0.313575] TCP established hash table entries: 262144 (order: 10, 419430=
4 bytes)
[    0.315375] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.315824] TCP: Hash tables configured (established 262144 bind 65536)
[    0.315827] TCP reno registered
[    0.315936] NET: Registered protocol family 1
[    0.438502] pci 0000:01:00.0: Boot video device
[    0.438565] Unpacking initramfs...
[    0.685739] Freeing initrd memory: 9533k freed
[    0.690407] audit: initializing netlink socket (disabled)
[    0.690420] type=3D2000 audit(1273597665.686:1): initialized
[    0.690654] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.691810] VFS: Disk quotas dquot_6.5.2
[    0.691858] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.691927] msgmni has been set to 4024
[    0.692099] alg: No test for stdrng (krng)
[    0.692137] Block layer SCSI generic (bsg) driver version 0.4 loaded (maj=
or 253)
[    0.692140] io scheduler noop registered
[    0.692141] io scheduler anticipatory registered
[    0.692143] io scheduler deadline registered
[    0.692171] io scheduler cfq registered (default)
[    0.692279]   alloc irq_desc for 25 on node 0
[    0.692281]   alloc kstat_irqs on node 0
[    0.692290] pcieport 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.692296] pcieport 0000:00:02.0: setting latency timer to 64
[    0.692387]   alloc irq_desc for 26 on node 0
[    0.692388]   alloc kstat_irqs on node 0
[    0.692393] pcieport 0000:00:06.0: irq 26 for MSI/MSI-X
[    0.692398] pcieport 0000:00:06.0: setting latency timer to 64
[    0.692485]   alloc irq_desc for 27 on node 0
[    0.692486]   alloc kstat_irqs on node 0
[    0.692490] pcieport 0000:00:07.0: irq 27 for MSI/MSI-X
[    0.692495] pcieport 0000:00:07.0: setting latency timer to 64
[    0.693635] Linux agpgart interface v0.103
[    0.693638] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.693921] input: Macintosh mouse button emulation as /devices/virtual/i=
nput/input0
[    0.693966] PNP: No PS/2 controller found. Probing ports directly.
[    0.694336] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.694340] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.694392] mice: PS/2 mouse device common for all mice
[    0.694422] rtc_cmos 00:02: RTC can wake from S4
[    0.694450] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.694481] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.694491] cpuidle: using governor ladder
[    0.694493] cpuidle: using governor menu
[    0.694502] No iBFT detected.
[    0.694803] TCP cubic registered
[    0.694895] NET: Registered protocol family 10
[    0.695319] lo: Disabled Privacy Extensions
[    0.695575] Mobile IPv6
[    0.695577] NET: Registered protocol family 17
[    0.695639] PM: Resume from disk failed.
[    0.695643] registered taskstats version 1
[    0.696055] rtc_cmos 00:02: setting system clock to 2010-05-11 17:07:46 U=
TC (1273597666)
[    0.696098] Freeing unused kernel memory: 580k freed
[    0.696337] Write protecting the kernel read-only data: 4124k
[    0.990515] usbcore: registered new interface driver usbfs
[    0.990540] usbcore: registered new interface driver hub
[    1.005146] sky2 driver version 1.25
[    1.010650] SCSI subsystem initialized
[    1.018484] usbcore: registered new device driver usb
[    1.022470] sky2 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.022482] sky2 0000:02:00.0: setting latency timer to 64
[    1.022506] sky2 0000:02:00.0: Yukon-2 EC Ultra chip revision 3
[    1.022576]   alloc irq_desc for 28 on node 0
[    1.022578]   alloc kstat_irqs on node 0
[    1.022590] sky2 0000:02:00.0: irq 28 for MSI/MSI-X
[    1.024516] sky2 eth0: addr 00:23:54:27:14:e2
[    1.085962] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.087688] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.087690] Warning! ehci_hcd should always be loaded before uhci_hcd and=
 ohci_hcd, not after
[    1.104037]   alloc irq_desc for 16 on node 0
[    1.104040]   alloc kstat_irqs on node 0
[    1.104049] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[    1.104089] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.104122] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus n=
umber 1
[    1.104162] ohci_hcd 0000:00:12.0: irq 16, io mem 0xf9ffe000
[    1.115462] libata version 3.00 loaded.
[    1.131759] pata_marvell 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -=
> IRQ 19
[    1.131790] pata_marvell 0000:03:00.0: setting latency timer to 64
[    1.140034] scsi0 : pata_marvell
[    1.145703] scsi1 : pata_marvell
[    1.145769] ata1: PATA max UDMA/100 cmd 0xe800 ctl 0xe400 bmdma 0xd400 ir=
q 19
[    1.145772] ata2: PATA max UDMA/133 cmd 0xe000 ctl 0xd800 bmdma 0xd408 ir=
q 19
[    1.145900]   alloc irq_desc for 22 on node 0
[    1.145902]   alloc kstat_irqs on node 0
[    1.145909] firewire_ohci 0000:04:08.0: PCI INT A -> GSI 22 (level, low) =
-> IRQ 22
[    1.164069] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
[    1.164073] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seria=
lNumber=3D1
[    1.164076] usb usb1: Product: OHCI Host Controller
[    1.164078] usb usb1: Manufacturer: Linux 2.6.32-bpo.3-amd64 ohci_hcd
[    1.164079] usb usb1: SerialNumber: 0000:00:12.0
[    1.164178] usb usb1: configuration #1 chosen from 1 choice
[    1.164208] hub 1-0:1.0: USB hub found
[    1.164219] hub 1-0:1.0: 3 ports detected
[    1.168232]   alloc irq_desc for 17 on node 0
[    1.168235]   alloc kstat_irqs on node 0
[    1.168245] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IR=
Q 17
[    1.168273] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.168292] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus n=
umber 2
[    1.168323] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze wo=
rkaround
[    1.168337] ehci_hcd 0000:00:12.2: debug port 1
[    1.168366] ehci_hcd 0000:00:12.2: irq 17, io mem 0xf9fff000
[    1.180011] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.180040] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D=
0002
[    1.180042] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seria=
lNumber=3D1
[    1.180045] usb usb2: Product: EHCI Host Controller
[    1.180046] usb usb2: Manufacturer: Linux 2.6.32-bpo.3-amd64 ehci_hcd
[    1.180048] usb usb2: SerialNumber: 0000:00:12.2
[    1.180124] usb usb2: configuration #1 chosen from 1 choice
[    1.180150] hub 2-0:1.0: USB hub found
[    1.180157] hub 2-0:1.0: 6 ports detected
[    1.180294] ahci 0000:00:11.0: version 3.0
[    1.180311] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.180421] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf=
 impl SATA mode
[    1.180425] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp =
pio slum part ccc=20
[    1.180741] scsi2 : ahci
[    1.180804] scsi3 : ahci
[    1.180846] scsi4 : ahci
[    1.180889] scsi5 : ahci
[    1.180927] ata3: SATA max UDMA/133 abar m1024@0xf9fff800 port 0xf9fff900=
 irq 22
[    1.180930] ata4: SATA max UDMA/133 abar m1024@0xf9fff800 port 0xf9fff980=
 irq 22
[    1.180933] ata5: SATA max UDMA/133 abar m1024@0xf9fff800 port 0xf9fffa00=
 irq 22
[    1.180936] ata6: SATA max UDMA/133 abar m1024@0xf9fff800 port 0xf9fffa80=
 irq 22
[    1.181049] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[    1.181063] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.181075] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus n=
umber 3
[    1.181096] ohci_hcd 0000:00:12.1: irq 16, io mem 0xf9ffd000
[    1.216005] firewire_ohci: Added fw-ohci device 0000:04:08.0, OHCI versio=
n 1.0
[    1.240008] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
[    1.240010] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seria=
lNumber=3D1
[    1.240012] usb usb3: Product: OHCI Host Controller
[    1.240014] usb usb3: Manufacturer: Linux 2.6.32-bpo.3-amd64 ohci_hcd
[    1.240016] usb usb3: SerialNumber: 0000:00:12.1
[    1.240080] usb usb3: configuration #1 chosen from 1 choice
[    1.240105] hub 3-0:1.0: USB hub found
[    1.240114] hub 3-0:1.0: 3 ports detected
[    1.240189] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IR=
Q 19
[    1.240201] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.240208] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus n=
umber 4
[    1.240228] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze wo=
rkaround
[    1.240242] ehci_hcd 0000:00:13.2: debug port 1
[    1.240255] ehci_hcd 0000:00:13.2: irq 19, io mem 0xf9ffa800
[    1.252005] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.252017] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D=
0002
[    1.252019] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seria=
lNumber=3D1
[    1.252021] usb usb4: Product: EHCI Host Controller
[    1.252023] usb usb4: Manufacturer: Linux 2.6.32-bpo.3-amd64 ehci_hcd
[    1.252025] usb usb4: SerialNumber: 0000:00:13.2
[    1.252069] usb usb4: configuration #1 chosen from 1 choice
[    1.252092] hub 4-0:1.0: USB hub found
[    1.252097] hub 4-0:1.0: 6 ports detected
[    1.252171] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IR=
Q 18
[    1.252181] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.252189] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus n=
umber 5
[    1.252213] ohci_hcd 0000:00:13.0: irq 18, io mem 0xf9ffc000
[    1.323654] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
[    1.323657] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seria=
lNumber=3D1
[    1.323659] usb usb5: Product: OHCI Host Controller
[    1.323660] usb usb5: Manufacturer: Linux 2.6.32-bpo.3-amd64 ohci_hcd
[    1.323662] usb usb5: SerialNumber: 0000:00:13.0
[    1.323710] usb usb5: configuration #1 chosen from 1 choice
[    1.323733] hub 5-0:1.0: USB hub found
[    1.323741] hub 5-0:1.0: 3 ports detected
[    1.323799] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IR=
Q 18
[    1.323808] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.323815] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus n=
umber 6
[    1.323832] ohci_hcd 0000:00:13.1: irq 18, io mem 0xf9ffb000
[    1.379989] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
[    1.379992] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seria=
lNumber=3D1
[    1.380003] usb usb6: Product: OHCI Host Controller
[    1.380005] usb usb6: Manufacturer: Linux 2.6.32-bpo.3-amd64 ohci_hcd
[    1.380007] usb usb6: SerialNumber: 0000:00:13.1
[    1.380066] usb usb6: configuration #1 chosen from 1 choice
[    1.380087] hub 6-0:1.0: USB hub found
[    1.380094] hub 6-0:1.0: 3 ports detected
[    1.380160] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IR=
Q 18
[    1.380169] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.380175] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus n=
umber 7
[    1.380192] ohci_hcd 0000:00:14.5: irq 18, io mem 0xf9ff9000
[    1.440032] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=3D=
0001
[    1.440035] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seria=
lNumber=3D1
[    1.440037] usb usb7: Product: OHCI Host Controller
[    1.440038] usb usb7: Manufacturer: Linux 2.6.32-bpo.3-amd64 ohci_hcd
[    1.440040] usb usb7: SerialNumber: 0000:00:14.5
[    1.440084] usb usb7: configuration #1 chosen from 1 choice
[    1.440106] hub 7-0:1.0: USB hub found
[    1.440113] hub 7-0:1.0: 2 ports detected
[    1.492010] usb 2-1: new high speed USB device using ehci_hcd and address=
 2
[    1.630807] usb 2-1: New USB device found, idVendor=3D04b8, idProduct=3D0=
11b
[    1.630809] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Serial=
Number=3D0
[    1.630811] usb 2-1: Product: EPSON Scanner
[    1.630813] usb 2-1: Manufacturer: EPSON
[    1.630857] usb 2-1: configuration #1 chosen from 1 choice
[    1.668007] ata5: softreset failed (device not ready)
[    1.668057] ata5: applying SB600 PMP SRST workaround and retrying
[    1.668071] ata3: softreset failed (device not ready)
[    1.668118] ata3: applying SB600 PMP SRST workaround and retrying
[    1.668132] ata6: softreset failed (device not ready)
[    1.668179] ata6: applying SB600 PMP SRST workaround and retrying
[    1.668193] ata4: softreset failed (device not ready)
[    1.668239] ata4: applying SB600 PMP SRST workaround and retrying
[    1.716073] firewire_core: created device fw0: GUID 001e8c000189822a, S40=
0
[    1.740008] usb 2-3: new high speed USB device using ehci_hcd and address=
 3
[    1.832022] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.832043] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.832060] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.832076] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.832872] ata3.00: HPA detected: current 488395055, native 488397168
[    1.833055] ata3.00: ATA-7: Hitachi HDT725025VLA380, V5DOA7EA, max UDMA/1=
33
[    1.833057] ata3.00: 488395055 sectors, multi 16: LBA48 NCQ (depth 31/32)=
, AA
[    1.833099] ata5.00: ATA-7: Hitachi HDT725025VLA380, V5DOA7EA, max UDMA/1=
33
[    1.833101] ata5.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)=
, AA
[    1.834060] ata4.00: ATA-8: WDC WD5000AAKS-00UU3A0, 01.03B01, max UDMA/13=
3
[    1.834063] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)=
, AA
[    1.834256] ata3.00: configured for UDMA/133
[    1.834302] ata5.00: configured for UDMA/133
[    1.835197] ata4.00: configured for UDMA/133
[    1.848103] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDT72502 V5D=
O PQ: 0 ANSI: 5
[    1.848279] scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 01.=
0 PQ: 0 ANSI: 5
[    1.848412] scsi 4:0:0:0: Direct-Access     ATA      Hitachi HDT72502 V5D=
O PQ: 0 ANSI: 5
[    1.859739] ata6.00: ATA-8: Hitachi HDP725025GLA380, GM2OA52A, max UDMA/1=
33
[    1.859742] ata6.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)=
, AA
[    1.860707] ata6.00: configured for UDMA/133
[    1.876059] scsi 5:0:0:0: Direct-Access     ATA      Hitachi HDP72502 GM2=
O PQ: 0 ANSI: 5
[    1.885217] Uniform Multi-Platform E-IDE driver
[    1.889898] usb 2-3: New USB device found, idVendor=3D04fc, idProduct=3D0=
c25
[    1.889902] usb 2-3: New USB device strings: Mfr=3D2, Product=3D3, Serial=
Number=3D1
[    1.889904] usb 2-3: Product: USB to Serial-ATA bridge
[    1.889906] usb 2-3: Manufacturer: Sunplus Technology Co.,Ltd.
[    1.889908] usb 2-3: SerialNumber: FF9250315A0000000000005FCDFF6F
[    1.890012] usb 2-3: configuration #1 chosen from 1 choice
[    1.898055] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    1.898069] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> =
IRQ 16
[    1.898089] atiixp 0000:00:14.1: not 100% native mode: will probe irqs la=
ter
[    1.898095]     ide0: BM-DMA at 0xff00-0xff07
[    1.898102]     ide1: BM-DMA at 0xff08-0xff0f
[    1.898107] Probing IDE interface ide0...
[    1.939497] sd 2:0:0:0: [sda] 488395055 512-byte logical blocks: (250 GB/=
232 GiB)
[    1.939530] sd 2:0:0:0: [sda] Write Protect is off
[    1.939532] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.939547] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA
[    1.939672]  sda:
[    1.945810] sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/=
465 GiB)
[    1.945840] sd 3:0:0:0: [sdb] Write Protect is off
[    1.945843] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.945857] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA
[    1.945953]  sdb:
[    1.946023] sd 4:0:0:0: [sdc] 488397168 512-byte logical blocks: (250 GB/=
232 GiB)
[    1.946051] sd 4:0:0:0: [sdc] Write Protect is off
[    1.946053] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.946068] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA
[    1.946143]  sdc:
[    1.946207] sd 5:0:0:0: [sdd] 488397168 512-byte logical blocks: (250 GB/=
232 GiB)
[    1.946235] sd 5:0:0:0: [sdd] Write Protect is off
[    1.946237] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.946251] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA
[    1.946323]  sdd: sda1 sda2 sda3
[    1.948496] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.952562]  sdb1 sdb2 sdb3
[    1.952783] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.955289]  sdc1 sdc2 sdc3
[    1.955526] sd 4:0:0:0: [sdc] Attached SCSI disk
[    1.975698]  sdd1 sdd2 sdd3
[    1.975935] sd 5:0:0:0: [sdd] Attached SCSI disk
[    1.977217] Initializing USB Mass Storage driver...
[    1.977697] scsi6 : SCSI emulation for USB Mass Storage devices
[    1.977769] usbcore: registered new interface driver usb-storage
[    1.977772] USB Mass Storage support registered.
[    1.978119] usb-storage: device found at 3
[    1.978120] usb-storage: waiting for device to settle before scanning
[    2.001021] usb 4-3: new high speed USB device using ehci_hcd and address=
 2
[    2.137127] usb 4-3: New USB device found, idVendor=3D0566, idProduct=3D3=
021
[    2.137131] usb 4-3: New USB device strings: Mfr=3D10, Product=3D11, Seri=
alNumber=3D0
[    2.137134] usb 4-3: Product: USB 2.0 HUB
[    2.137135] usb 4-3: Manufacturer: GENESYS
[    2.137221] usb 4-3: configuration #1 chosen from 1 choice
[    2.137560] hub 4-3:1.0: USB hub found
[    2.138125] hub 4-3:1.0: 4 ports detected
[    2.456007] usb 6-1: new low speed USB device using ohci_hcd and address =
2
[    2.464037] Probing IDE interface ide1...
[    2.645988] usb 6-1: New USB device found, idVendor=3D046d, idProduct=3Dc=
214
[    2.645990] usb 6-1: New USB device strings: Mfr=3D1, Product=3D2, Serial=
Number=3D0
[    2.645993] usb 6-1: Product: Logitech Attack 3
[    2.645994] usb 6-1: Manufacturer: Logitech
[    2.646062] usb 6-1: configuration #1 chosen from 1 choice
[    2.671668] usbcore: registered new interface driver hiddev
[    2.720783] usb 4-3.2: new low speed USB device using ehci_hcd and addres=
s 4
[    2.817264] usb 4-3.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc404
[    2.817266] usb 4-3.2: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0
[    2.817269] usb 4-3.2: Product: Trackball
[    2.817270] usb 4-3.2: Manufacturer: Logitech
[    2.817345] usb 4-3.2: configuration #1 chosen from 1 choice
[    2.889006] usb 4-3.3: new low speed USB device using ehci_hcd and addres=
s 5
[    2.984989] usb 4-3.3: New USB device found, idVendor=3D0566, idProduct=
=3D3108
[    2.984991] usb 4-3.3: New USB device strings: Mfr=3D0, Product=3D0, Seri=
alNumber=3D0
[    2.985066] usb 4-3.3: configuration #1 chosen from 1 choice
[    3.057102] usb 4-3.4: new full speed USB device using ehci_hcd and addre=
ss 6
[    3.149584] usb 4-3.4: New USB device found, idVendor=3D0d8c, idProduct=
=3D0105
[    3.149587] usb 4-3.4: New USB device strings: Mfr=3D3, Product=3D1, Seri=
alNumber=3D0
[    3.149589] usb 4-3.4: Product: USB Multimedia Audio Device
[    3.149591] usb 4-3.4: Manufacturer: C-Media Electronics Inc.
[    3.149673] usb 4-3.4: configuration #1 chosen from 1 choice
[    3.204278] hdc: ATAPI DVD D DH16D3S, ATAPI CD/DVD-ROM drive
[    4.040005] hdd: Optiarc DVD RW AD-7240S, ATAPI CD/DVD-ROM drive
[    4.040049] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.041021] hdc: UDMA/100 mode selected
[    4.042118] hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.042381] hdd: UDMA/100 mode selected
[    4.042691] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.042746] ide1 at 0x170-0x177,0x376 on irq 15
[    4.060778] ide-cd driver 5.00
[    4.061670] ide-cd: hdc: ATAPI 48X DVD-ROM drive, 198kB Cache
[    4.061675] Uniform CD-ROM driver Revision: 3.20
[    4.074441] ide-cd: hdd: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048k=
B Cache
[    6.976201] usb-storage: device scan complete
[    6.980576] scsi 6:0:0:0: Direct-Access     ST925031 5AS                 =
  PQ: 0 ANSI: 2
[    6.983312] sd 6:0:0:0: [sde] 488397168 512-byte logical blocks: (250 GB/=
232 GiB)
[    6.985558] sd 6:0:0:0: [sde] Write Protect is off
[    6.985560] sd 6:0:0:0: [sde] Mode Sense: 38 00 00 00
[    6.985563] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    6.988806] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    6.988855]  sde: sde1
[    8.794143] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    8.794195] sd 6:0:0:0: [sde] Attached SCSI disk
[   12.680685] /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/d=
rivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
[   12.680751] generic-usb 0003:046D:C214.0001: timeout initializing reports
[   12.680827] input: Logitech Logitech Attack 3 as /devices/pci0000:00/0000=
:00:13.1/usb6/6-1/6-1:1.0/input/input1
[   12.680868] generic-usb 0003:046D:C214.0001: input,hidraw0: USB HID v1.10=
 Joystick [Logitech Logitech Attack 3] on usb-0000:00:13.1-1/input0
[   12.684618] input: Logitech Trackball as /devices/pci0000:00/0000:00:13.2=
/usb4/4-3/4-3.2/4-3.2:1.0/input/input2
[   12.684660] generic-usb 0003:046D:C404.0002: input,hidraw1: USB HID v1.10=
 Mouse [Logitech Trackball] on usb-0000:00:13.2-3.2/input0
[   12.687917] input: HID 0566:3108 as /devices/pci0000:00/0000:00:13.2/usb4=
/4-3/4-3.3/4-3.3:1.0/input/input3
[   12.687951] generic-usb 0003:0566:3108.0003: input,hidraw2: USB HID v1.10=
 Keyboard [HID 0566:3108] on usb-0000:00:13.2-3.3/input0
[   12.692349] input: HID 0566:3108 as /devices/pci0000:00/0000:00:13.2/usb4=
/4-3/4-3.3/4-3.3:1.1/input/input4
[   12.692378] generic-usb 0003:0566:3108.0004: input,hidraw3: USB HID v1.10=
 Device [HID 0566:3108] on usb-0000:00:13.2-3.3/input1
[   12.693083] input: C-Media Electronics Inc. USB Multimedia Audio Device a=
s /devices/pci0000:00/0000:00:13.2/usb4/4-3/4-3.4/4-3.4:1.3/input/input5
[   12.693135] generic-usb 0003:0D8C:0105.0005: input,hidraw4: USB HID v1.00=
 Device [C-Media Electronics Inc. USB Multimedia Audio Device] on usb-0000:0=
0:13.2-3.4/input3
[   12.693152] usbcore: registered new interface driver usbhid
[   12.693155] usbhid: v2.6:USB HID core driver
[   12.820132] md: raid1 personality registered for level 1
[   12.822930] async_tx: api initialized (async)
[   12.823538] xor: automatically using best checksumming function: generic_=
sse
[   12.840003]    generic_sse:  9552.000 MB/sec
[   12.840005] xor: using function: generic_sse (9552.000 MB/sec)
[   12.908032] raid6: int64x1   2147 MB/s
[   12.976012] raid6: int64x2   2883 MB/s
[   13.044028] raid6: int64x4   2237 MB/s
[   13.112008] raid6: int64x8   2035 MB/s
[   13.180030] raid6: sse2x1    1042 MB/s
[   13.248023] raid6: sse2x2    2155 MB/s
[   13.316005] raid6: sse2x4    5224 MB/s
[   13.316007] raid6: using algorithm sse2x4 (5224 MB/s)
[   13.320136] md: raid6 personality registered for level 6
[   13.320138] md: raid5 personality registered for level 5
[   13.320140] md: raid4 personality registered for level 4
[   13.326371] md: md0 stopped.
[   13.375167] md: bind<sdc1>
[   13.375290] md: bind<sdb1>
[   13.375395] md: bind<sdd1>
[   13.375528] md: bind<sda1>
[   13.384423] raid1: raid set md0 active with 4 out of 4 mirrors
[   13.384819] md0: bitmap initialized from disk: read 1/1 pages, set 0 bits
[   13.384821] created bitmap (12 pages) for device md0
[   13.426777] md0: detected capacity change from 0 to 98566144
[   13.427078] md: md1 stopped.
[   13.427178]  md0: unknown partition table
[   13.447879] md: bind<sdb2>
[   13.448017] md: bind<sdc2>
[   13.448128] md: bind<sdd2>
[   13.448242] md: bind<sda2>
[   13.457479] raid5: device sda2 operational as raid disk 0
[   13.457482] raid5: device sdd2 operational as raid disk 3
[   13.457484] raid5: device sdc2 operational as raid disk 2
[   13.457486] raid5: device sdb2 operational as raid disk 1
[   13.457823] raid5: allocated 4282kB for md1
[   13.458186] 0: w=3D1 pa=3D0 pr=3D4 m=3D2 a=3D2 r=3D4 op1=3D0 op2=3D0
[   13.458189] 3: w=3D2 pa=3D0 pr=3D4 m=3D2 a=3D2 r=3D4 op1=3D0 op2=3D0
[   13.458191] 2: w=3D3 pa=3D0 pr=3D4 m=3D2 a=3D2 r=3D4 op1=3D0 op2=3D0
[   13.458194] 1: w=3D4 pa=3D0 pr=3D4 m=3D2 a=3D2 r=3D4 op1=3D0 op2=3D0
[   13.458196] raid5: raid level 6 set md1 active with 4 out of 4 devices, a=
lgorithm 2
[   13.458197] RAID5 conf printout:
[   13.458199]  --- rd:4 wd:4
[   13.458201]  disk 0, o:1, dev:sda2
[   13.458202]  disk 1, o:1, dev:sdb2
[   13.458204]  disk 2, o:1, dev:sdc2
[   13.458205]  disk 3, o:1, dev:sdd2
[   13.462461] md1: bitmap initialized from disk: read 13/13 pages, set 60 b=
its
[   13.462464] created bitmap (196 pages) for device md1
[   13.486285] md1: detected capacity change from 0 to 419998990336
[   13.486557]  md1: unknown partition table
[   13.569311] device-mapper: uevent: version 1.0.3
[   13.570442] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: =
dm-devel@redhat.com
[   13.722732] PM: Starting manual resume from disk
[   13.722735] PM: Resume from partition 253:9
[   13.722737] PM: Checking hibernation image.
[   13.734113] PM: Error -22 checking image file
[   13.734115] PM: Resume from disk failed.
[   13.738673] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[   13.738678] PM: Basic memory bitmaps created
[   13.747172] PM: Basic memory bitmaps freed
[   13.792325] kjournald starting.  Commit interval 5 seconds
[   13.792334] EXT3-fs: mounted filesystem with ordered data mode.
[   15.254567] udevd version 125 started
[   15.789946] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C=
0C:00/input/input6
[   15.789959] ACPI: Power Button [PWRB]
[   15.790014] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input=
/input7
[   15.790017] ACPI: Power Button [PWRF]
[   15.868072] processor LNXCPU:00: registered as cooling_device0
[   15.868127] processor LNXCPU:01: registered as cooling_device1
[   15.868159] processor LNXCPU:02: registered as cooling_device2
[   16.088013] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with A=
CPI region SOR1 [0xb00-0xb0f]
[   16.088081] ACPI: If an ACPI driver is available for this device, you sho=
uld use it instead of the native driver
[   16.234532] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   16.372127] EDAC MC: Ver: 2.1.0 Mar 15 2010
[   16.433790] EDAC amd64_edac:  Ver: 3.2.0 Mar 15 2010
[   16.444624] EDAC amd64: This node reports that Memory ECC is currently di=
sabled, set F3x44[22] (0000:00:18.3).
[   16.444634] EDAC amd64: ECC disabled in the BIOS or no ECC capability, mo=
dule will not load.
[   16.444636]  Either enable ECC checking or force module loading by settin=
g 'ecc_enable_override'.
[   16.444637]  (Note that use of the override may cause unknown side effect=
s.)
[   16.444654] amd64_edac: probe of 0000:00:18.2 failed with error -22
[   16.740043] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[   16.864096]   alloc irq_desc for 21 on node 0
[   16.864099]   alloc kstat_irqs on node 0
[   16.864107] Bt87x 0000:04:06.1: PCI INT A -> GSI 21 (level, low) -> IRQ 2=
1
[   16.864309] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
[   17.499710] Linux video capture interface: v2.00
[   17.574346] bttv: driver version 0.9.18 loaded
[   17.574349] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   17.574416] bttv: Bt8xx card found (0).
[   17.574437] bttv 0000:04:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   17.574449] bttv0: Bt878 (rev 17) at 0000:04:06.0, irq: 21, latency: 64, =
mmio: 0xf8fff000
[   17.574487] bttv0: detected: Hauppauge WinTV [card=3D10], PCI subsystem I=
D is 0070:13eb
[   17.574489] bttv0: using: Hauppauge (bt878) [card=3D10,autodetected]
[   17.574491] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[   17.574523] bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ffffdb [ini=
t]
[   17.577012] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
[   17.615358] tveeprom 0-0050: Hauppauge model 44915, rev C124, serial# 397=
5495
[   17.615361] tveeprom 0-0050: tuner model is Philips FM1246 (idx 24, type =
1)
[   17.615364] tveeprom 0-0050: TV standards PAL(I) (eeprom 0x10)
[   17.615366] tveeprom 0-0050: audio processor is None (idx 0)
[   17.615368] tveeprom 0-0050: has radio
[   17.615369] bttv0: Hauppauge eeprom indicates model#44915
[   17.615372] bttv0: tuner type=3D1
[   17.659131] hda_codec: AD1989B: BIOS auto-probing.
[   17.659221] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2=
/input/input9
[   17.679309] usbcore: registered new interface driver snd-usb-audio
[   17.731974] bttv0: audio absent, no audio device found!
[   17.763072] tuner 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
[   17.819424] tuner-simple 0-0061: creating new instance
[   17.819428] tuner-simple 0-0061: type set to 1 (Philips PAL_I (FI1246 and=
 compatibles))
[   17.820261] bttv0: registered device video0
[   17.820282] bttv0: registered device vbi0
[   17.820302] bttv0: registered device radio0
[   17.820331] bttv0: PLL: 28636363 =3D> 35468950 .. ok
[   18.924327] EXT3 FS on dm-0, internal journal
[   19.738084] loop: module loaded
[   19.865763] QEMU Accelerator Module version 1.3.0, Copyright (c) 2005-200=
7 Fabrice Bellard
[   19.865845] KQEMU installed, max_locked_mem=3D1030476kB.
[   20.359202] md: bind<sdc3>
[   20.359316] md: bind<sdd3>
[   20.359455] md: bind<sda3>
[   20.431869] md: raid0 personality registered for level 0
[   20.431989] raid0: looking at sda3
[   20.431992] raid0:   comparing sda3(78043520)
[   20.431993]  with sda3(78043520)
[   20.431995] raid0:   END
[   20.431996] raid0:   =3D=3D> UNIQUE
[   20.431997] raid0: 1 zones
[   20.431998] raid0: looking at sdd3
[   20.432000] raid0:   comparing sdd3(78043520)
[   20.432004]  with sda3(78043520)
[   20.432005] raid0:   EQUAL
[   20.432006] raid0: looking at sdc3
[   20.432008] raid0:   comparing sdc3(78043520)
[   20.432009]  with sda3(78043520)
[   20.432010] raid0:   EQUAL
[   20.432012] raid0: FINAL 1 zones
[   20.432015] raid0: done.
[   20.432016] raid0 : md_size is 234130560 sectors.
[   20.432018] ******* md2 configuration *********
[   20.432019] zone0=3D[sda3/sdc3/sdd3/]
[   20.432023]         zone offset=3D0kb device offset=3D0kb size=3D11706528=
0kb
[   20.432024] **********************************
[   20.432025]=20
[   20.432037] md2: detected capacity change from 0 to 119874846720
[   20.432099]  md2: unknown partition table
[   20.462348] md: bind<sdb3>
[   20.462368] md: md3 stopped.
[   20.462373] md: unbind<sdb3>
[   20.472015] md: export_rdev(sdb3)
[   20.559536] md: bind<sdb3>
[   20.559648] md: bind<md2>
[   20.620836] md: linear personality registered for level -1
[   20.620966] md3: detected capacity change from 0 to 409881608192
[   20.621010]  md3: unknown partition table
[   25.826801] fuse init (API version 7.13)
[   26.245966] kjournald starting.  Commit interval 5 seconds
[   26.273232] EXT3 FS on md0, internal journal
[   26.273236] EXT3-fs: mounted filesystem with ordered data mode.
[   26.324786] kjournald starting.  Commit interval 5 seconds
[   26.387593] EXT3 FS on dm-7, internal journal
[   26.387599] EXT3-fs: mounted filesystem with ordered data mode.
[   26.435807] kjournald starting.  Commit interval 5 seconds
[   26.506517] EXT3 FS on dm-3, internal journal
[   26.506521] EXT3-fs: mounted filesystem with ordered data mode.
[   26.551493] kjournald starting.  Commit interval 5 seconds
[   26.595139] EXT3 FS on dm-4, internal journal
[   26.595143] EXT3-fs: mounted filesystem with ordered data mode.
[   26.632770] kjournald starting.  Commit interval 5 seconds
[   26.684275] EXT3 FS on dm-6, internal journal
[   26.684279] EXT3-fs: mounted filesystem with ordered data mode.
[   26.720496] kjournald starting.  Commit interval 5 seconds
[   26.771062] EXT3 FS on dm-8, internal journal
[   26.771066] EXT3-fs: mounted filesystem with ordered data mode.
[   26.812374] kjournald starting.  Commit interval 5 seconds
[   26.812591] EXT3 FS on md3, internal journal
[   26.812594] EXT3-fs: mounted filesystem with ordered data mode.
[   26.857351] kjournald starting.  Commit interval 5 seconds
[   26.903269] EXT3 FS on dm-1, internal journal
[   26.903273] EXT3-fs: mounted filesystem with ordered data mode.
[   26.940381] kjournald starting.  Commit interval 5 seconds
[   26.999810] EXT3 FS on dm-2, internal journal
[   26.999813] EXT3-fs: mounted filesystem with ordered data mode.
[   27.049183] kjournald starting.  Commit interval 5 seconds
[   27.096999] EXT3 FS on dm-5, internal journal
[   27.097002] EXT3-fs: mounted filesystem with ordered data mode.
[   28.121481] kjournald starting.  Commit interval 5 seconds
[   28.121487] EXT3-fs: mounted filesystem with ordered data mode.
[   28.179875] kjournald starting.  Commit interval 5 seconds
[   28.179880] EXT3-fs: mounted filesystem with ordered data mode.
[   28.226188] kjournald starting.  Commit interval 5 seconds
[   28.226193] EXT3-fs: mounted filesystem with ordered data mode.
[   28.303083] kjournald starting.  Commit interval 5 seconds
[   28.303088] EXT3-fs: mounted filesystem with ordered data mode.
[   28.356685] kjournald starting.  Commit interval 5 seconds
[   28.356690] EXT3-fs: mounted filesystem with ordered data mode.
[   28.385482] kjournald starting.  Commit interval 5 seconds
[   28.385486] EXT3-fs: mounted filesystem with ordered data mode.
[   28.477749] kjournald starting.  Commit interval 5 seconds
[   28.477754] EXT3-fs: mounted filesystem with ordered data mode.
[   28.557149] kjournald starting.  Commit interval 5 seconds
[   28.557154] EXT3-fs: mounted filesystem with ordered data mode.
[   28.606667] kjournald starting.  Commit interval 5 seconds
[   28.606673] EXT3-fs: mounted filesystem with ordered data mode.
[   28.659567] FAT: utf8 is not a recommended IO charset for FAT filesystems=
, filesystem will be case sensitive!
[   28.930094] Adding 7245816k swap on /dev/mapper/vg0-swap.  Priority:-1 ex=
tents:1 across:7245816k=20
[   30.257816] sky2 eth0: enabling interface
[   30.258157] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   31.941120] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control =
both
[   31.941450] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   34.289523] RPC: Registered udp transport module.
[   34.289526] RPC: Registered tcp transport module.
[   34.289528] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   34.397896] Slow work thread pool: Starting up
[   34.397933] Slow work thread pool: Ready
[   34.397982] FS-Cache: Loaded
[   34.469208] FS-Cache: Netfs 'nfs' registered for caching
[   34.512260] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   35.945850] powernow-k8: Found 1 AMD Phenom(tm) 8650 Triple-Core Processo=
r processors (3 cpu cores) (version 2.20.00)
[   35.945893] powernow-k8:    0 : pstate 0 (2300 MHz)
[   35.945895] powernow-k8:    1 : pstate 1 (1150 MHz)
[   41.956010] eth0: no IPv6 routers present
[   48.643228] lp: driver loaded but no devices found
[   48.780263] ppdev: user-space parallel port driver
[   50.909482] kvm: Nested Virtualization enabled
[   50.909488] kvm: Nested Paging enabled
[   59.264028] device eth0 entered promiscuous mode
[   59.296010] device eth0 left promiscuous mode
[   59.312522] device eth0 entered promiscuous mode
[   60.501666] cdrom: This disc doesn't have any tracks I recognize!
[   60.528027] pktcdvd: writer pktcdvd0 mapped to hdd
[   65.178191] warning: `ntpd' uses 32-bit capabilities (legacy support in u=
se)
[   70.092046] nvidia: module license 'NVIDIA' taints kernel.
[   70.092053] Disabling lock debugging due to kernel taint
[   70.868541] nvidia 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ =
18
[   70.868555] nvidia 0000:01:00.0: setting latency timer to 64
[   70.868871] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.36  Fr=
i Aug 14 17:35:21 PDT 2009
[  104.370114] kjournald starting.  Commit interval 5 seconds
[  104.372556] EXT3 FS on sde1, internal journal
[  104.372566] EXT3-fs: mounted filesystem with ordered data mode.
--=_187jj9a6milz
Content-Type: text/plain;
	charset=UTF-8;
	name="lspci.noesata"
Content-Disposition: attachment;
	filename="lspci.noesata"
Content-Transfer-Encoding: quoted-printable

00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual slot P=
CI-e_GFX and HT3 K8 part
=09Subsystem: ATI Technologies Inc RD790 Northbridge only dual slot PCI-e_GF=
X and HT3 K8 part
=09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort+ >SERR- <PERR- INTx-
=09Latency: 0
=09Region 3: Memory at <ignored> (64-bit, non-prefetchable)
=09Capabilities: [c4] HyperTransport: Slave or Primary Interface
=09=09Command: BaseUnitID=3D0 UnitCnt=3D12 MastHost- DefDir- DUL-
=09=09Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 I=
socEn- LSEn- ExtCTL- 64b-
=09=09Link Config 0: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit =
DwFcInEn- LWO=3D16bit DwFcOutEn-
=09=09Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=3D0 I=
socEn- LSEn- ExtCTL- 64b-
=09=09Link Config 1: MLWI=3D8bit DwFcIn- MLWO=3D8bit DwFcOut- LWI=3D8bit DwF=
cInEn- LWO=3D8bit DwFcOutEn-
=09=09Revision ID: 3.00
=09=09Link Frequency 0: [a]
=09=09Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
=09=09Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 8=
00MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
=09=09Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
=09=09Link Frequency 1: 200MHz
=09=09Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
=09=09Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 8=
00MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
=09=09Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- R=
E- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
=09=09Prefetchable memory behind bridge Upper: 00-00
=09=09Bus Number: 00
=09Capabilities: [40] HyperTransport: Retry Mode
=09Capabilities: [54] HyperTransport: UnitID Clumping
=09Capabilities: [9c] HyperTransport: #1a

00:02.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (external g=
fx0 port A) (prog-if 00 [Normal decode])
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx+
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Latency: 0, Cache Line Size: 64 bytes
=09Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
=09I/O behind bridge: 0000b000-0000bfff
=09Memory behind bridge: fa000000-fe8fffff
=09Prefetchable memory behind bridge: 00000000c0000000-00000000dfffffff
=09Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- <SERR- <PERR-
=09BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
=09=09PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
=09Capabilities: [50] Power Management version 3
=09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3=
cold+)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
=09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1u=
s
=09=09=09ExtTag+ RBE+ FLReset-
=09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
=09=09=09RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
=09=09=09MaxPayload 128 bytes, MaxReadReq 128 bytes
=09=09DevSta:=09CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
=09=09LnkCap:=09Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64=
ns, L1 <1us
=09=09=09ClockPM- Suprise- LLActRep+ BwNot+
=09=09LnkCtl:=09ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
=09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
=09=09LnkSta:=09Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWM=
gmt+ ABWMgmt+
=09=09RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible=
-
=09=09RootCap: CRSVisible-
=09=09RootSta: PME ReqID 0000, PMEStatus- PMEPending-
=09Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0=
 Enable+
=09=09Address: fee0700c  Data: 4161
=09Capabilities: [b0] Subsystem: ATI Technologies Inc Device 5956
=09Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
=09Capabilities: [100] Vendor Specific Information <?>
=09Capabilities: [110] Virtual Channel <?>
=09Kernel driver in use: pcieport
=09Kernel modules: shpchp

00:06.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI expres=
s gpp port C) (prog-if 00 [Normal decode])
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx+
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Latency: 0, Cache Line Size: 64 bytes
=09Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
=09I/O behind bridge: 0000c000-0000cfff
=09Memory behind bridge: fe900000-fe9fffff
=09Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
=09Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- <SERR- <PERR-
=09BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
=09=09PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
=09Capabilities: [50] Power Management version 3
=09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3=
cold+)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
=09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1u=
s
=09=09=09ExtTag+ RBE+ FLReset-
=09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
=09=09=09RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
=09=09=09MaxPayload 128 bytes, MaxReadReq 128 bytes
=09=09DevSta:=09CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
=09=09LnkCap:=09Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64n=
s, L1 <1us
=09=09=09ClockPM- Suprise- LLActRep+ BwNot+
=09=09LnkCtl:=09ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
=09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
=09=09LnkSta:=09Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BW=
Mgmt+ ABWMgmt-
=09=09RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible=
-
=09=09RootCap: CRSVisible-
=09=09RootSta: PME ReqID 0000, PMEStatus- PMEPending-
=09Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0=
 Enable+
=09=09Address: fee0700c  Data: 4169
=09Capabilities: [b0] Subsystem: ATI Technologies Inc Device 5956
=09Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
=09Capabilities: [100] Vendor Specific Information <?>
=09Capabilities: [110] Virtual Channel <?>
=09Kernel driver in use: pcieport
=09Kernel modules: shpchp

00:07.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI expres=
s gpp port D) (prog-if 00 [Normal decode])
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx+
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Latency: 0, Cache Line Size: 64 bytes
=09Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
=09I/O behind bridge: 0000d000-0000efff
=09Memory behind bridge: fea00000-feafffff
=09Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
=09Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- <SERR- <PERR-
=09BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
=09=09PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
=09Capabilities: [50] Power Management version 3
=09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3=
cold+)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
=09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1u=
s
=09=09=09ExtTag+ RBE+ FLReset-
=09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
=09=09=09RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
=09=09=09MaxPayload 128 bytes, MaxReadReq 128 bytes
=09=09DevSta:=09CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
=09=09LnkCap:=09Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64n=
s, L1 <1us
=09=09=09ClockPM- Suprise- LLActRep+ BwNot+
=09=09LnkCtl:=09ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
=09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
=09=09LnkSta:=09Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BW=
Mgmt+ ABWMgmt-
=09=09RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible=
-
=09=09RootCap: CRSVisible-
=09=09RootSta: PME ReqID 0000, PMEStatus- PMEPending-
=09Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0=
 Enable+
=09=09Address: fee0700c  Data: 4171
=09Capabilities: [b0] Subsystem: ATI Technologies Inc Device 5956
=09Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
=09Capabilities: [100] Vendor Specific Information <?>
=09Capabilities: [110] Virtual Channel <?>
=09Kernel driver in use: pcieport
=09Kernel modules: shpchp

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [A=
HCI mode] (prog-if 01 [AHCI 1.0])
=09Subsystem: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin A routed to IRQ 22
=09Region 0: I/O ports at a000 [size=3D8]
=09Region 1: I/O ports at 9000 [size=3D4]
=09Region 2: I/O ports at 8000 [size=3D8]
=09Region 3: I/O ports at 7000 [size=3D4]
=09Region 4: I/O ports at 6000 [size=3D16]
=09Region 5: Memory at f9fff800 (32-bit, non-prefetchable) [size=3D1K]
=09Capabilities: [60] Power Management version 2
=09=09Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3=
cold-)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09Capabilities: [70] SATA HBA <?>
=09Kernel driver in use: ahci
=09Kernel modules: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controlle=
r (prog-if 10 [OHCI])
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin A routed to IRQ 16
=09Region 0: Memory at f9ffe000 (32-bit, non-prefetchable) [size=3D4K]
=09Kernel driver in use: ohci_hcd
=09Kernel modules: ohci-hcd

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (pro=
g-if 10 [OHCI])
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin A routed to IRQ 16
=09Region 0: Memory at f9ffd000 (32-bit, non-prefetchable) [size=3D4K]
=09Kernel driver in use: ohci_hcd
=09Kernel modules: ohci-hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller=
 (prog-if 20 [EHCI])
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin B routed to IRQ 17
=09Region 0: Memory at f9fff000 (32-bit, non-prefetchable) [size=3D256]
=09Capabilities: [c0] Power Management version 2
=09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3=
cold-)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09=09Bridge: PM- B3+
=09Capabilities: [e4] Debug port: BAR=3D1 offset=3D00e0
=09Kernel driver in use: ehci_hcd
=09Kernel modules: ehci-hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controlle=
r (prog-if 10 [OHCI])
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin A routed to IRQ 18
=09Region 0: Memory at f9ffc000 (32-bit, non-prefetchable) [size=3D4K]
=09Kernel driver in use: ohci_hcd
=09Kernel modules: ohci-hcd

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (pro=
g-if 10 [OHCI])
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin A routed to IRQ 18
=09Region 0: Memory at f9ffb000 (32-bit, non-prefetchable) [size=3D4K]
=09Kernel driver in use: ohci_hcd
=09Kernel modules: ohci-hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller=
 (prog-if 20 [EHCI])
=09Subsystem: ATI Technologies Inc SB700/SB800 USB EHCI Controller
=09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin B routed to IRQ 19
=09Region 0: Memory at f9ffa800 (32-bit, non-prefetchable) [size=3D256]
=09Capabilities: [c0] Power Management version 2
=09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3=
cold-)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09=09Bridge: PM- B3+
=09Capabilities: [e4] Debug port: BAR=3D1 offset=3D00e0
=09Kernel driver in use: ehci_hcd
=09Kernel modules: ehci-hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx+
=09Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
=09Kernel modules: i2c-piix4

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (prog=
-if 8a [Master SecP PriP])
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 0
=09Interrupt: pin A routed to IRQ 16
=09Region 0: I/O ports at 01f0 [size=3D8]
=09Region 1: I/O ports at 03f4 [size=3D1]
=09Region 2: I/O ports at 0170 [size=3D8]
=09Region 3: I/O ports at 0374 [size=3D1]
=09Region 4: I/O ports at ff00 [size=3D16]
=09Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/1=
 Enable-
=09=09Address: 00000000  Data: 0000
=09Kernel driver in use: ATIIXP_IDE
=09Kernel modules: ata_generic, atiixp, ide-pci-generic

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin ? routed to IRQ 16
=09Region 0: Memory at f9ff4000 (64-bit, non-prefetchable) [size=3D16K]
=09Capabilities: [50] Power Management version 2
=09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+,D=
3cold+)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09Kernel driver in use: HDA Intel
=09Kernel modules: snd-hda-intel

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
=09Subsystem: ASUSTeK Computer Inc. Device 8288
=09Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 01=
 [Subtractive decode])
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64
=09Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D64
=09I/O behind bridge: 0000f000-00000fff
=09Memory behind bridge: feb00000-febfffff
=09Prefetchable memory behind bridge: f8f00000-f8ffffff
=09Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort+ <SERR- <PERR-
=09BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
=09=09PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controlle=
r (prog-if 10 [OHCI])
=09Subsystem: ATI Technologies Inc Device 4396
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64, Cache Line Size: 64 bytes
=09Interrupt: pin C routed to IRQ 18
=09Region 0: Memory at f9ff9000 (32-bit, non-prefetchable) [size=3D4K]
=09Kernel driver in use: ohci_hcd
=09Kernel modules: ohci-hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlo=
n64, Sempron] HyperTransport Configuration
=09Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Capabilities: [80] HyperTransport: Host or Secondary Interface
=09=09Command: WarmRst+ DblEnd- DevNum=3D0 ChainSide- HostHide+ Slave- <EOCE=
rr- DUL-
=09=09Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 Iso=
cEn- LSEn+ ExtCTL- 64b-
=09=09Link Config: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit Dw=
FcInEn- LWO=3D16bit DwFcOutEn-
=09=09Revision ID: 3.00
=09=09Link Frequency: [a]
=09=09Link Error: <Prot- <Ovfl- <EOC- CTLTm-
=09=09Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800=
MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
=09=09Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS-=
 UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlo=
n64, Sempron] Address Map
=09Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlo=
n64, Sempron] DRAM Controller
=09Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Kernel modules: amd64_edac_mod

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlo=
n64, Sempron] Miscellaneous Control
=09Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlo=
n64, Sempron] Link Control
=09Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: nVidia Corporation GeForce 9600 GSO (rev =
a2) (prog-if 00 [VGA controller])
=09Subsystem: XFX Pine Group Inc. Device 2382
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR- FastB2B- DisINTx-
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Latency: 0
=09Interrupt: pin A routed to IRQ 18
=09Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=3D16M]
=09Region 1: Memory at c0000000 (64-bit, prefetchable) [size=3D512M]
=09Region 3: Memory at fa000000 (64-bit, non-prefetchable) [size=3D32M]
=09Region 5: I/O ports at b800 [size=3D128]
=09[virtual] Expansion ROM at fe8e0000 [disabled] [size=3D128K]
=09Capabilities: [60] Power Management version 3
=09=09Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3=
cold-)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0=
 Enable-
=09=09Address: 0000000000000000  Data: 0000
=09Capabilities: [78] Express (v2) Endpoint, MSI 00
=09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4=
us
=09=09=09ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
=09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
=09=09=09RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
=09=09=09MaxPayload 128 bytes, MaxReadReq 512 bytes
=09=09DevSta:=09CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
=09=09LnkCap:=09Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <25=
6ns, L1 <1us
=09=09=09ClockPM- Suprise- LLActRep- BwNot-
=09=09LnkCtl:=09ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
=09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
=09=09LnkSta:=09Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWM=
gmt- ABWMgmt-
=09Capabilities: [100] Virtual Channel <?>
=09Capabilities: [128] Power Budgeting <?>
=09Capabilities: [600] Vendor Specific Information <?>
=09Kernel driver in use: nvidia
=09Kernel modules: nvidia, nvidiafb

02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gig=
abit Ethernet Controller (rev 12)
=09Subsystem: ASUSTeK Computer Inc. Device 81f8
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx+
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Latency: 0, Cache Line Size: 64 bytes
=09Interrupt: pin A routed to IRQ 28
=09Region 0: Memory at fe9fc000 (64-bit, non-prefetchable) [size=3D16K]
=09Region 2: I/O ports at c800 [size=3D256]
=09Expansion ROM at fe9c0000 [disabled] [size=3D128K]
=09Capabilities: [48] Power Management version 3
=09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3=
cold+)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
=09Capabilities: [50] Vital Product Data <?>
=09Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0=
 Enable+
=09=09Address: 00000000fee0700c  Data: 4179
=09Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
=09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1=
 unlimited
=09=09=09ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
=09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
=09=09=09RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
=09=09=09MaxPayload 128 bytes, MaxReadReq 512 bytes
=09=09DevSta:=09CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
=09=09LnkCap:=09Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2=
56ns, L1 unlimited
=09=09=09ClockPM+ Suprise- LLActRep- BwNot-
=09=09LnkCtl:=09ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
=09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
=09=09LnkSta:=09Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BW=
Mgmt- ABWMgmt-
=09Capabilities: [100] Advanced Error Reporting <?>
=09Kernel driver in use: sky2
=09Kernel modules: sky2

03:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Contro=
ller (rev b2) (prog-if 8f [Master SecP SecO PriP PriO])
=09Subsystem: Marvell Technology Group Ltd. 88SE6121 SATA II Controller
=09Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort-=
 <MAbort- >SERR- <PERR- INTx-
=09Latency: 0, Cache Line Size: 64 bytes
=09Interrupt: pin A routed to IRQ 19
=09Region 0: I/O ports at e800 [size=3D8]
=09Region 1: I/O ports at e400 [size=3D4]
=09Region 2: I/O ports at e000 [size=3D8]
=09Region 3: I/O ports at d800 [size=3D4]
=09Region 4: I/O ports at d400 [size=3D16]
=09Region 5: Memory at feaffc00 (32-bit, non-prefetchable) [size=3D1K]
=09Capabilities: [48] Power Management version 2
=09=09Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA PME(D0+,D1+,D2-,D3hot+,D3=
cold-)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
=09Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0=
 Enable-
=09=09Address: 00000000  Data: 0000
=09Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
=09=09DevCap:=09MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1=
 unlimited
=09=09=09ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
=09=09DevCtl:=09Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
=09=09=09RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
=09=09=09MaxPayload 128 bytes, MaxReadReq 512 bytes
=09=09DevSta:=09CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
=09=09LnkCap:=09Port #3, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <256n=
s, L1 unlimited
=09=09=09ClockPM- Suprise- LLActRep- BwNot-
=09=09LnkCtl:=09ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
=09=09=09ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
=09=09LnkSta:=09Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BW=
Mgmt- ABWMgmt-
=09Capabilities: [100] Advanced Error Reporting <?>
=09Kernel driver in use: pata_marvell
=09Kernel modules: ata_generic, ahci, pata_marvell, ide-pci-generic

04:06.0 Multimedia video controller: Brooktree Corporation Bt878 Video Captu=
re (rev 11)
=09Subsystem: Hauppauge computer works Inc. WinTV Series
=09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64 (4000ns min, 10000ns max)
=09Interrupt: pin A routed to IRQ 21
=09Region 0: Memory at f8fff000 (32-bit, prefetchable) [size=3D4K]
=09Capabilities: [44] Vital Product Data <?>
=09Capabilities: [4c] Power Management version 2
=09=09Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3=
cold-)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09Kernel driver in use: bttv
=09Kernel modules: bttv

04:06.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (re=
v 11)
=09Subsystem: Hauppauge computer works Inc. WinTV Series
=09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64 (1000ns min, 63750ns max)
=09Interrupt: pin A routed to IRQ 21
=09Region 0: Memory at f8ffe000 (32-bit, prefetchable) [size=3D4K]
=09Capabilities: [44] Vital Product Data <?>
=09Capabilities: [4c] Power Management version 2
=09=09Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3=
cold-)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
=09Kernel driver in use: Bt87x
=09Kernel modules: snd-bt87x

04:08.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70) (prog-if 10 [OHCI=
])
=09Subsystem: ASUSTeK Computer Inc. Device 8294
=09Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepp=
ing- SERR+ FastB2B- DisINTx-
=09Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbor=
t- <MAbort- >SERR- <PERR- INTx-
=09Latency: 64 (3000ns min, 6000ns max), Cache Line Size: 64 bytes
=09Interrupt: pin A routed to IRQ 22
=09Region 0: Memory at febff000 (32-bit, non-prefetchable) [size=3D4K]
=09Capabilities: [44] Power Management version 2
=09=09Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3=
cold-)
=09=09Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME+
=09Kernel driver in use: firewire_ohci
=09Kernel modules: firewire-ohci

--=_187jj9a6milz
Content-Type: text/plain;
	charset=UTF-8;
	name="config-2.6.32-bpo.3-amd64"
Content-Disposition: attachment;
	filename="config-2.6.32-bpo.3-amd64"
Content-Transfer-Encoding: quoted-printable

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.32
# Mon Mar 15 12:58:53 2010
#
CONFIG_64BIT=3Dy
# CONFIG_X86_32 is not set
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_OUTPUT_FORMAT=3D"elf64-x86-64"
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_RWSEM_GENERIC_SPINLOCK=3Dy
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_DEFAULT_IDLE=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=3Dy
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=3Dy
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=3Dy
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
CONFIG_HAVE_INTEL_TXT=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_X86_TRAMPOLINE=3Dy
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=3Dy

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_LOCK_KERNEL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=3Dy
CONFIG_HAVE_KERNEL_BZIP2=3Dy
CONFIG_HAVE_KERNEL_LZMA=3Dy
CONFIG_KERNEL_GZIP=3Dy
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_POSIX_MQUEUE_SYSCTL=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
CONFIG_TASKSTATS=3Dy
CONFIG_TASK_DELAY_ACCT=3Dy
CONFIG_TASK_XACCT=3Dy
CONFIG_TASK_IO_ACCOUNTING=3Dy
CONFIG_AUDIT=3Dy
CONFIG_AUDITSYSCALL=3Dy
CONFIG_AUDIT_TREE=3Dy

#
# RCU Subsystem
#
CONFIG_TREE_RCU=3Dy
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=3D64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=3D17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy
CONFIG_GROUP_SCHED=3Dy
CONFIG_FAIR_GROUP_SCHED=3Dy
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=3Dy
CONFIG_CGROUPS=3Dy
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=3Dy
CONFIG_CGROUP_FREEZER=3Dy
CONFIG_CGROUP_DEVICE=3Dy
CONFIG_CPUSETS=3Dy
CONFIG_PROC_PID_CPUSET=3Dy
CONFIG_CGROUP_CPUACCT=3Dy
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=3Dy
CONFIG_NAMESPACES=3Dy
CONFIG_UTS_NS=3Dy
CONFIG_IPC_NS=3Dy
CONFIG_USER_NS=3Dy
CONFIG_PID_NS=3Dy
CONFIG_NET_NS=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
CONFIG_RD_GZIP=3Dy
CONFIG_RD_BZIP2=3Dy
CONFIG_RD_LZMA=3Dy
CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
CONFIG_HAVE_PERF_EVENTS=3Dy

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=3Dy
CONFIG_EVENT_PROFILE=3Dy
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_PCI_QUIRKS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
CONFIG_PROFILING=3Dy
CONFIG_TRACEPOINTS=3Dy
CONFIG_OPROFILE=3Dm
CONFIG_OPROFILE_IBS=3Dy
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=3Dy
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_ATTRS=3Dy
CONFIG_HAVE_DMA_API_DEBUG=3Dy

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=3Dy
# CONFIG_SLOW_WORK_DEBUG is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
CONFIG_MODULE_FORCE_LOAD=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
CONFIG_MODVERSIONS=3Dy
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_BLK_DEV_BSG=3Dy
CONFIG_BLK_DEV_INTEGRITY=3Dy
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_AS=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"
CONFIG_PREEMPT_NOTIFIERS=3Dy
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
CONFIG_X86_X2APIC=3Dy
CONFIG_SPARSE_IRQ=3Dy
CONFIG_NUMA_IRQ_DESC=3Dy
CONFIG_X86_MPPARSE=3Dy
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
CONFIG_PARAVIRT_GUEST=3Dy
CONFIG_XEN=3Dy
CONFIG_XEN_MAX_DOMAIN_MEMORY=3D32
CONFIG_XEN_SAVE_RESTORE=3Dy
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=3Dy
CONFIG_KVM_GUEST=3Dy
CONFIG_PARAVIRT=3Dy
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=3Dy
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=3Dy
CONFIG_X86_CPU=3Dy
CONFIG_X86_L1_CACHE_BYTES=3D64
CONFIG_X86_INTERNODE_CACHE_BYTES=3D64
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
CONFIG_CPU_SUP_CENTAUR=3Dy
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
CONFIG_CALGARY_IOMMU=3Dy
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=3Dy
CONFIG_AMD_IOMMU=3Dy
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
CONFIG_IOMMU_API=3Dy
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=3D512
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=3Dy
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_INTEL=3Dy
CONFIG_X86_MCE_AMD=3Dy
CONFIG_X86_MCE_THRESHOLD=3Dy
CONFIG_X86_MCE_INJECT=3Dm
CONFIG_X86_THERMAL_VECTOR=3Dy
CONFIG_I8K=3Dm
CONFIG_MICROCODE=3Dm
CONFIG_MICROCODE_INTEL=3Dy
CONFIG_MICROCODE_AMD=3Dy
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dm
CONFIG_X86_CPUID=3Dm
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
CONFIG_NUMA=3Dy
CONFIG_K8_NUMA=3Dy
CONFIG_X86_64_ACPI_NUMA=3Dy
CONFIG_NODES_SPAN_OTHER_NODES=3Dy
CONFIG_NUMA_EMU=3Dy
CONFIG_NODES_SHIFT=3D6
CONFIG_ARCH_PROC_KCORE_TEXT=3Dy
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ARCH_MEMORY_PROBE=3Dy
CONFIG_SELECT_MEMORY_MODEL=3Dy
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_NEED_MULTIPLE_NODES=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
CONFIG_MEMORY_HOTPLUG=3Dy
CONFIG_MEMORY_HOTPLUG_SPARSE=3Dy
CONFIG_MEMORY_HOTREMOVE=3Dy
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_MIGRATION=3Dy
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
CONFIG_HAVE_MLOCK=3Dy
CONFIG_HAVE_MLOCKED_PAGE_BIT=3Dy
CONFIG_MMU_NOTIFIER=3Dy
CONFIG_KSM=3Dy
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_MEMORY_FAILURE=3Dy
CONFIG_HWPOISON_INJECT=3Dm
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=3Dy
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
CONFIG_EFI=3Dy
CONFIG_SECCOMP=3Dy
CONFIG_CC_STACKPROTECTOR=3Dy
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=3Dy
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D250
CONFIG_SCHED_HRTICK=3Dy
CONFIG_KEXEC=3Dy
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=3D0x1000000
CONFIG_RELOCATABLE=3Dy
CONFIG_PHYSICAL_ALIGN=3D0x1000000
CONFIG_HOTPLUG_CPU=3Dy
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=3Dy
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=3Dy

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=3Dy
CONFIG_PM=3Dy
CONFIG_PM_DEBUG=3Dy
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=3Dy
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=3Dy
CONFIG_PM_SLEEP=3Dy
CONFIG_SUSPEND=3Dy
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=3Dy
CONFIG_HIBERNATION_NVS=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_PM_RUNTIME=3Dy
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_POWER_METER=3Dm
CONFIG_ACPI_SYSFS_POWER=3Dy
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=3Dm
CONFIG_ACPI_BATTERY=3Dm
CONFIG_ACPI_BUTTON=3Dm
CONFIG_ACPI_VIDEO=3Dm
CONFIG_ACPI_FAN=3Dm
CONFIG_ACPI_DOCK=3Dy
CONFIG_ACPI_PROCESSOR=3Dm
CONFIG_ACPI_HOTPLUG_CPU=3Dy
CONFIG_ACPI_PROCESSOR_AGGREGATOR=3Dm
CONFIG_ACPI_THERMAL=3Dm
CONFIG_ACPI_NUMA=3Dy
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=3Dm
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dm
CONFIG_ACPI_HOTPLUG_MEMORY=3Dm
CONFIG_ACPI_SBS=3Dm
CONFIG_SFI=3Dy

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=3Dm
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dm
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=3Dm
CONFIG_X86_POWERNOW_K8=3Dm
CONFIG_X86_SPEEDSTEP_CENTRINO=3Dm
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_CPU_IDLE_GOV_MENU=3Dy

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=3Dy
CONFIG_I7300_IDLE=3Dm

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
CONFIG_DMAR=3Dy
# CONFIG_DMAR_DEFAULT_ON is not set
CONFIG_DMAR_FLOPPY_WA=3Dy
CONFIG_INTR_REMAP=3Dy
CONFIG_PCIEPORTBUS=3Dy
CONFIG_HOTPLUG_PCI_PCIE=3Dm
CONFIG_PCIEAER=3Dy
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=3Dm
CONFIG_PCIEASPM=3Dy
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
CONFIG_PCI_LEGACY=3Dy
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=3Dm
CONFIG_HT_IRQ=3Dy
CONFIG_PCI_IOV=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_K8_NB=3Dy
CONFIG_PCCARD=3Dm
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=3Dm
CONFIG_PCMCIA_LOAD_CIS=3Dy
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
CONFIG_YENTA=3Dm
CONFIG_YENTA_O2=3Dy
CONFIG_YENTA_RICOH=3Dy
CONFIG_YENTA_TI=3Dy
CONFIG_YENTA_ENE_TUNE=3Dy
CONFIG_YENTA_TOSHIBA=3Dy
CONFIG_PD6729=3Dm
CONFIG_I82092=3Dm
CONFIG_PCCARD_NONSTATIC=3Dm
CONFIG_HOTPLUG_PCI=3Dm
CONFIG_HOTPLUG_PCI_FAKE=3Dm
CONFIG_HOTPLUG_PCI_ACPI=3Dm
CONFIG_HOTPLUG_PCI_ACPI_IBM=3Dm
CONFIG_HOTPLUG_PCI_CPCI=3Dy
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=3Dm
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=3Dm
CONFIG_HOTPLUG_PCI_SHPC=3Dm

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=3Dy
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dm
CONFIG_IA32_EMULATION=3Dy
CONFIG_IA32_AOUT=3Dy
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_NET=3Dy
CONFIG_COMPAT_NETLINK_MESSAGES=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_PACKET_MMAP=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dm
CONFIG_XFRM_SUB_POLICY=3Dy
CONFIG_XFRM_MIGRATE=3Dy
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=3Dm
CONFIG_NET_KEY=3Dm
CONFIG_NET_KEY_MIGRATE=3Dy
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
CONFIG_IP_ROUTE_VERBOSE=3Dy
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE=3Dm
CONFIG_NET_IPGRE_BROADCAST=3Dy
CONFIG_IP_MROUTE=3Dy
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
CONFIG_INET_AH=3Dm
CONFIG_INET_ESP=3Dm
CONFIG_INET_IPCOMP=3Dm
CONFIG_INET_XFRM_TUNNEL=3Dm
CONFIG_INET_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_BEET=3Dm
CONFIG_INET_LRO=3Dy
CONFIG_INET_DIAG=3Dm
CONFIG_INET_TCP_DIAG=3Dm
CONFIG_TCP_CONG_ADVANCED=3Dy
CONFIG_TCP_CONG_BIC=3Dm
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_TCP_CONG_WESTWOOD=3Dm
CONFIG_TCP_CONG_HTCP=3Dm
CONFIG_TCP_CONG_HSTCP=3Dm
CONFIG_TCP_CONG_HYBLA=3Dm
CONFIG_TCP_CONG_VEGAS=3Dm
CONFIG_TCP_CONG_SCALABLE=3Dm
CONFIG_TCP_CONG_LP=3Dm
CONFIG_TCP_CONG_VENO=3Dm
CONFIG_TCP_CONG_YEAH=3Dm
CONFIG_TCP_CONG_ILLINOIS=3Dm
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=3Dy
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
CONFIG_TCP_MD5SIG=3Dy
CONFIG_IPV6=3Dy
CONFIG_IPV6_PRIVACY=3Dy
CONFIG_IPV6_ROUTER_PREF=3Dy
CONFIG_IPV6_ROUTE_INFO=3Dy
CONFIG_IPV6_OPTIMISTIC_DAD=3Dy
CONFIG_INET6_AH=3Dm
CONFIG_INET6_ESP=3Dm
CONFIG_INET6_IPCOMP=3Dm
CONFIG_IPV6_MIP6=3Dy
CONFIG_INET6_XFRM_TUNNEL=3Dm
CONFIG_INET6_TUNNEL=3Dm
CONFIG_INET6_XFRM_MODE_TRANSPORT=3Dm
CONFIG_INET6_XFRM_MODE_TUNNEL=3Dm
CONFIG_INET6_XFRM_MODE_BEET=3Dm
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=3Dm
CONFIG_IPV6_SIT=3Dm
CONFIG_IPV6_NDISC_NODETYPE=3Dy
CONFIG_IPV6_TUNNEL=3Dm
CONFIG_IPV6_MULTIPLE_TABLES=3Dy
CONFIG_IPV6_SUBTREES=3Dy
CONFIG_IPV6_MROUTE=3Dy
CONFIG_IPV6_PIMSM_V2=3Dy
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=3Dy
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dm
CONFIG_NETFILTER_NETLINK_QUEUE=3Dm
CONFIG_NETFILTER_NETLINK_LOG=3Dm
CONFIG_NF_CONNTRACK=3Dm
CONFIG_NF_CT_ACCT=3Dy
CONFIG_NF_CONNTRACK_MARK=3Dy
CONFIG_NF_CONNTRACK_SECMARK=3Dy
CONFIG_NF_CONNTRACK_EVENTS=3Dy
CONFIG_NF_CT_PROTO_DCCP=3Dm
CONFIG_NF_CT_PROTO_GRE=3Dm
CONFIG_NF_CT_PROTO_SCTP=3Dm
CONFIG_NF_CT_PROTO_UDPLITE=3Dm
CONFIG_NF_CONNTRACK_AMANDA=3Dm
CONFIG_NF_CONNTRACK_FTP=3Dm
CONFIG_NF_CONNTRACK_H323=3Dm
CONFIG_NF_CONNTRACK_IRC=3Dm
CONFIG_NF_CONNTRACK_NETBIOS_NS=3Dm
CONFIG_NF_CONNTRACK_PPTP=3Dm
CONFIG_NF_CONNTRACK_SANE=3Dm
CONFIG_NF_CONNTRACK_SIP=3Dm
CONFIG_NF_CONNTRACK_TFTP=3Dm
CONFIG_NF_CT_NETLINK=3Dm
CONFIG_NETFILTER_TPROXY=3Dm
CONFIG_NETFILTER_XTABLES=3Dm
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dm
CONFIG_NETFILTER_XT_TARGET_HL=3Dm
CONFIG_NETFILTER_XT_TARGET_LED=3Dm
CONFIG_NETFILTER_XT_TARGET_MARK=3Dm
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dm
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dm
CONFIG_NETFILTER_XT_TARGET_NOTRACK=3Dm
CONFIG_NETFILTER_XT_TARGET_RATEEST=3Dm
CONFIG_NETFILTER_XT_TARGET_TPROXY=3Dm
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dm
CONFIG_NETFILTER_XT_TARGET_SECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPMSS=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=3Dm
CONFIG_NETFILTER_XT_MATCH_CLUSTER=3Dm
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNMARK=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=3Dm
CONFIG_NETFILTER_XT_MATCH_DCCP=3Dm
CONFIG_NETFILTER_XT_MATCH_DSCP=3Dm
CONFIG_NETFILTER_XT_MATCH_ESP=3Dm
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_HELPER=3Dm
CONFIG_NETFILTER_XT_MATCH_HL=3Dm
CONFIG_NETFILTER_XT_MATCH_IPRANGE=3Dm
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_MAC=3Dm
CONFIG_NETFILTER_XT_MATCH_MARK=3Dm
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=3Dm
CONFIG_NETFILTER_XT_MATCH_OWNER=3Dm
CONFIG_NETFILTER_XT_MATCH_POLICY=3Dm
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dm
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dm
CONFIG_NETFILTER_XT_MATCH_QUOTA=3Dm
CONFIG_NETFILTER_XT_MATCH_RATEEST=3Dm
CONFIG_NETFILTER_XT_MATCH_REALM=3Dm
CONFIG_NETFILTER_XT_MATCH_RECENT=3Dm
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=3Dm
CONFIG_NETFILTER_XT_MATCH_SOCKET=3Dm
CONFIG_NETFILTER_XT_MATCH_STATE=3Dm
CONFIG_NETFILTER_XT_MATCH_STATISTIC=3Dm
CONFIG_NETFILTER_XT_MATCH_STRING=3Dm
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dm
CONFIG_NETFILTER_XT_MATCH_TIME=3Dm
CONFIG_NETFILTER_XT_MATCH_U32=3Dm
CONFIG_NETFILTER_XT_MATCH_OSF=3Dm
CONFIG_IP_VS=3Dm
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=3D12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=3Dy
CONFIG_IP_VS_PROTO_UDP=3Dy
CONFIG_IP_VS_PROTO_AH_ESP=3Dy
CONFIG_IP_VS_PROTO_ESP=3Dy
CONFIG_IP_VS_PROTO_AH=3Dy

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=3Dm
CONFIG_IP_VS_WRR=3Dm
CONFIG_IP_VS_LC=3Dm
CONFIG_IP_VS_WLC=3Dm
CONFIG_IP_VS_LBLC=3Dm
CONFIG_IP_VS_LBLCR=3Dm
CONFIG_IP_VS_DH=3Dm
CONFIG_IP_VS_SH=3Dm
CONFIG_IP_VS_SED=3Dm
CONFIG_IP_VS_NQ=3Dm

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=3Dm

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=3Dm
CONFIG_NF_CONNTRACK_IPV4=3Dm
CONFIG_NF_CONNTRACK_PROC_COMPAT=3Dy
CONFIG_IP_NF_QUEUE=3Dm
CONFIG_IP_NF_IPTABLES=3Dm
CONFIG_IP_NF_MATCH_ADDRTYPE=3Dm
CONFIG_IP_NF_MATCH_AH=3Dm
CONFIG_IP_NF_MATCH_ECN=3Dm
CONFIG_IP_NF_MATCH_TTL=3Dm
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_TARGET_REJECT=3Dm
CONFIG_IP_NF_TARGET_LOG=3Dm
CONFIG_IP_NF_TARGET_ULOG=3Dm
CONFIG_NF_NAT=3Dm
CONFIG_NF_NAT_NEEDED=3Dy
CONFIG_IP_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP_NF_TARGET_NETMAP=3Dm
CONFIG_IP_NF_TARGET_REDIRECT=3Dm
CONFIG_NF_NAT_SNMP_BASIC=3Dm
CONFIG_NF_NAT_PROTO_DCCP=3Dm
CONFIG_NF_NAT_PROTO_GRE=3Dm
CONFIG_NF_NAT_PROTO_UDPLITE=3Dm
CONFIG_NF_NAT_PROTO_SCTP=3Dm
CONFIG_NF_NAT_FTP=3Dm
CONFIG_NF_NAT_IRC=3Dm
CONFIG_NF_NAT_TFTP=3Dm
CONFIG_NF_NAT_AMANDA=3Dm
CONFIG_NF_NAT_PPTP=3Dm
CONFIG_NF_NAT_H323=3Dm
CONFIG_NF_NAT_SIP=3Dm
CONFIG_IP_NF_MANGLE=3Dm
CONFIG_IP_NF_TARGET_CLUSTERIP=3Dm
CONFIG_IP_NF_TARGET_ECN=3Dm
CONFIG_IP_NF_TARGET_TTL=3Dm
CONFIG_IP_NF_RAW=3Dm
CONFIG_IP_NF_SECURITY=3Dm
CONFIG_IP_NF_ARPTABLES=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP_NF_ARP_MANGLE=3Dm

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=3Dm
CONFIG_IP6_NF_QUEUE=3Dm
CONFIG_IP6_NF_IPTABLES=3Dm
CONFIG_IP6_NF_MATCH_AH=3Dm
CONFIG_IP6_NF_MATCH_EUI64=3Dm
CONFIG_IP6_NF_MATCH_FRAG=3Dm
CONFIG_IP6_NF_MATCH_OPTS=3Dm
CONFIG_IP6_NF_MATCH_HL=3Dm
CONFIG_IP6_NF_MATCH_IPV6HEADER=3Dm
CONFIG_IP6_NF_MATCH_MH=3Dm
CONFIG_IP6_NF_MATCH_RT=3Dm
CONFIG_IP6_NF_TARGET_HL=3Dm
CONFIG_IP6_NF_TARGET_LOG=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_IP6_NF_TARGET_REJECT=3Dm
CONFIG_IP6_NF_MANGLE=3Dm
CONFIG_IP6_NF_RAW=3Dm
CONFIG_IP6_NF_SECURITY=3Dm

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=3Dm
CONFIG_BRIDGE_NF_EBTABLES=3Dm
CONFIG_BRIDGE_EBT_BROUTE=3Dm
CONFIG_BRIDGE_EBT_T_FILTER=3Dm
CONFIG_BRIDGE_EBT_T_NAT=3Dm
CONFIG_BRIDGE_EBT_802_3=3Dm
CONFIG_BRIDGE_EBT_AMONG=3Dm
CONFIG_BRIDGE_EBT_ARP=3Dm
CONFIG_BRIDGE_EBT_IP=3Dm
CONFIG_BRIDGE_EBT_IP6=3Dm
CONFIG_BRIDGE_EBT_LIMIT=3Dm
CONFIG_BRIDGE_EBT_MARK=3Dm
CONFIG_BRIDGE_EBT_PKTTYPE=3Dm
CONFIG_BRIDGE_EBT_STP=3Dm
CONFIG_BRIDGE_EBT_VLAN=3Dm
CONFIG_BRIDGE_EBT_ARPREPLY=3Dm
CONFIG_BRIDGE_EBT_DNAT=3Dm
CONFIG_BRIDGE_EBT_MARK_T=3Dm
CONFIG_BRIDGE_EBT_REDIRECT=3Dm
CONFIG_BRIDGE_EBT_SNAT=3Dm
CONFIG_BRIDGE_EBT_LOG=3Dm
CONFIG_BRIDGE_EBT_ULOG=3Dm
CONFIG_BRIDGE_EBT_NFLOG=3Dm
CONFIG_IP_DCCP=3Dm
CONFIG_INET_DCCP_DIAG=3Dm

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=3Dy
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=3D100
CONFIG_IP_DCCP_TFRC_LIB=3Dy

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=3Dm
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=3Dy
CONFIG_RDS=3Dm
CONFIG_RDS_RDMA=3Dm
CONFIG_RDS_TCP=3Dm
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=3Dm
CONFIG_TIPC_ADVANCED=3Dy
CONFIG_TIPC_ZONES=3D3
CONFIG_TIPC_CLUSTERS=3D1
CONFIG_TIPC_NODES=3D255
CONFIG_TIPC_SLAVE_NODES=3D0
CONFIG_TIPC_PORTS=3D8191
CONFIG_TIPC_LOG=3D0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=3Dm
CONFIG_ATM_CLIP=3Dm
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=3Dm
CONFIG_ATM_MPOA=3Dm
CONFIG_ATM_BR2684=3Dm
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=3Dm
CONFIG_GARP=3Dm
CONFIG_BRIDGE=3Dm
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=3Dm
CONFIG_VLAN_8021Q_GVRP=3Dy
CONFIG_DECNET=3Dm
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=3Dy
CONFIG_LLC2=3Dm
CONFIG_IPX=3Dm
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=3Dm
CONFIG_DEV_APPLETALK=3Dm
CONFIG_IPDDP=3Dm
CONFIG_IPDDP_ENCAP=3Dy
CONFIG_IPDDP_DECAP=3Dy
CONFIG_X25=3Dm
CONFIG_LAPB=3Dm
CONFIG_ECONET=3Dm
CONFIG_ECONET_AUNUDP=3Dy
CONFIG_ECONET_NATIVE=3Dy
CONFIG_WAN_ROUTER=3Dm
CONFIG_PHONET=3Dm
CONFIG_IEEE802154=3Dm
CONFIG_NET_SCHED=3Dy

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=3Dm
CONFIG_NET_SCH_HTB=3Dm
CONFIG_NET_SCH_HFSC=3Dm
CONFIG_NET_SCH_ATM=3Dm
CONFIG_NET_SCH_PRIO=3Dm
CONFIG_NET_SCH_MULTIQ=3Dm
CONFIG_NET_SCH_RED=3Dm
CONFIG_NET_SCH_SFQ=3Dm
CONFIG_NET_SCH_TEQL=3Dm
CONFIG_NET_SCH_TBF=3Dm
CONFIG_NET_SCH_GRED=3Dm
CONFIG_NET_SCH_DSMARK=3Dm
CONFIG_NET_SCH_NETEM=3Dm
CONFIG_NET_SCH_DRR=3Dm
CONFIG_NET_SCH_INGRESS=3Dm

#
# Classification
#
CONFIG_NET_CLS=3Dy
CONFIG_NET_CLS_BASIC=3Dm
CONFIG_NET_CLS_TCINDEX=3Dm
CONFIG_NET_CLS_ROUTE4=3Dm
CONFIG_NET_CLS_ROUTE=3Dy
CONFIG_NET_CLS_FW=3Dm
CONFIG_NET_CLS_U32=3Dm
CONFIG_CLS_U32_PERF=3Dy
CONFIG_CLS_U32_MARK=3Dy
CONFIG_NET_CLS_RSVP=3Dm
CONFIG_NET_CLS_RSVP6=3Dm
CONFIG_NET_CLS_FLOW=3Dm
CONFIG_NET_CLS_CGROUP=3Dy
CONFIG_NET_EMATCH=3Dy
CONFIG_NET_EMATCH_STACK=3D32
CONFIG_NET_EMATCH_CMP=3Dm
CONFIG_NET_EMATCH_NBYTE=3Dm
CONFIG_NET_EMATCH_U32=3Dm
CONFIG_NET_EMATCH_META=3Dm
CONFIG_NET_EMATCH_TEXT=3Dm
CONFIG_NET_CLS_ACT=3Dy
CONFIG_NET_ACT_POLICE=3Dm
CONFIG_NET_ACT_GACT=3Dm
CONFIG_GACT_PROB=3Dy
CONFIG_NET_ACT_MIRRED=3Dm
CONFIG_NET_ACT_IPT=3Dm
CONFIG_NET_ACT_NAT=3Dm
CONFIG_NET_ACT_PEDIT=3Dm
CONFIG_NET_ACT_SIMP=3Dm
CONFIG_NET_ACT_SKBEDIT=3Dm
CONFIG_NET_CLS_IND=3Dy
CONFIG_NET_SCH_FIFO=3Dy
CONFIG_DCB=3Dy

#
# Network testing
#
CONFIG_NET_PKTGEN=3Dm
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=3Dy

#
# Packet Radio protocols
#
CONFIG_AX25=3Dm
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=3Dm
CONFIG_ROSE=3Dm

#
# AX.25 network device drivers
#
CONFIG_MKISS=3Dm
CONFIG_6PACK=3Dm
CONFIG_BPQETHER=3Dm
CONFIG_BAYCOM_SER_FDX=3Dm
CONFIG_BAYCOM_SER_HDX=3Dm
CONFIG_BAYCOM_PAR=3Dm
CONFIG_YAM=3Dm
CONFIG_CAN=3Dm
CONFIG_CAN_RAW=3Dm
CONFIG_CAN_BCM=3Dm

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=3Dm
CONFIG_CAN_DEV=3Dm
CONFIG_CAN_CALC_BITTIMING=3Dy
CONFIG_CAN_SJA1000=3Dm
CONFIG_CAN_SJA1000_PLATFORM=3Dm
CONFIG_CAN_EMS_PCI=3Dm
CONFIG_CAN_KVASER_PCI=3Dm

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=3Dm
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=3Dm

#
# IrDA protocols
#
CONFIG_IRLAN=3Dm
CONFIG_IRNET=3Dm
CONFIG_IRCOMM=3Dm
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
CONFIG_IRDA_FAST_RR=3Dy
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=3Dm

#
# Dongle support
#
CONFIG_DONGLE=3Dy
CONFIG_ESI_DONGLE=3Dm
CONFIG_ACTISYS_DONGLE=3Dm
CONFIG_TEKRAM_DONGLE=3Dm
CONFIG_TOIM3232_DONGLE=3Dm
CONFIG_LITELINK_DONGLE=3Dm
CONFIG_MA600_DONGLE=3Dm
CONFIG_GIRBIL_DONGLE=3Dm
CONFIG_MCP2120_DONGLE=3Dm
CONFIG_OLD_BELKIN_DONGLE=3Dm
CONFIG_ACT200L_DONGLE=3Dm
CONFIG_KINGSUN_DONGLE=3Dm
CONFIG_KSDAZZLE_DONGLE=3Dm
CONFIG_KS959_DONGLE=3Dm

#
# FIR device drivers
#
CONFIG_USB_IRDA=3Dm
CONFIG_SIGMATEL_FIR=3Dm
CONFIG_NSC_FIR=3Dm
CONFIG_WINBOND_FIR=3Dm
CONFIG_SMC_IRCC_FIR=3Dm
CONFIG_ALI_FIR=3Dm
CONFIG_VLSI_FIR=3Dm
CONFIG_VIA_FIR=3Dm
CONFIG_MCS_FIR=3Dm
CONFIG_BT=3Dm
CONFIG_BT_L2CAP=3Dm
CONFIG_BT_SCO=3Dm
CONFIG_BT_RFCOMM=3Dm
CONFIG_BT_RFCOMM_TTY=3Dy
CONFIG_BT_BNEP=3Dm
CONFIG_BT_BNEP_MC_FILTER=3Dy
CONFIG_BT_BNEP_PROTO_FILTER=3Dy
CONFIG_BT_CMTP=3Dm
CONFIG_BT_HIDP=3Dm

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=3Dm
CONFIG_BT_HCIBTSDIO=3Dm
CONFIG_BT_HCIUART=3Dm
CONFIG_BT_HCIUART_H4=3Dy
CONFIG_BT_HCIUART_BCSP=3Dy
CONFIG_BT_HCIUART_LL=3Dy
CONFIG_BT_HCIBCM203X=3Dm
CONFIG_BT_HCIBPA10X=3Dm
CONFIG_BT_HCIBFUSB=3Dm
CONFIG_BT_HCIDTL1=3Dm
CONFIG_BT_HCIBT3C=3Dm
CONFIG_BT_HCIBLUECARD=3Dm
CONFIG_BT_HCIBTUART=3Dm
CONFIG_BT_HCIVHCI=3Dm
CONFIG_BT_MRVL=3Dm
CONFIG_BT_MRVL_SDIO=3Dm
CONFIG_AF_RXRPC=3Dm
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=3Dm
CONFIG_FIB_RULES=3Dy
CONFIG_WIRELESS=3Dy
CONFIG_CFG80211=3Dm
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=3Dy
CONFIG_CFG80211_DEFAULT_PS_VALUE=3D1
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_WIRELESS_OLD_REGULATORY=3Dy
CONFIG_WIRELESS_EXT=3Dy
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_LIB80211=3Dm
CONFIG_LIB80211_CRYPT_WEP=3Dm
CONFIG_LIB80211_CRYPT_CCMP=3Dm
CONFIG_LIB80211_CRYPT_TKIP=3Dm
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=3Dm
CONFIG_MAC80211_RC_MINSTREL=3Dy
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
CONFIG_MAC80211_RC_DEFAULT=3D"minstrel"
CONFIG_MAC80211_MESH=3Dy
CONFIG_MAC80211_LEDS=3Dy
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=3Dm
CONFIG_WIMAX_DEBUG_LEVEL=3D8
CONFIG_RFKILL=3Dm
CONFIG_RFKILL_LEDS=3Dy
CONFIG_RFKILL_INPUT=3Dy
CONFIG_NET_9P=3Dm
CONFIG_NET_9P_VIRTIO=3Dm
CONFIG_NET_9P_RDMA=3Dm
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D""
CONFIG_DEVTMPFS=3Dy
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=3D""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=3Dy
CONFIG_CONNECTOR=3Dm
CONFIG_MTD=3Dm
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_CONCAT=3Dm
CONFIG_MTD_PARTITIONS=3Dy
CONFIG_MTD_REDBOOT_PARTS=3Dm
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=3D-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_AR7_PARTS=3Dm

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=3Dm
CONFIG_MTD_BLKDEVS=3Dm
CONFIG_MTD_BLOCK=3Dm
CONFIG_MTD_BLOCK_RO=3Dm
CONFIG_FTL=3Dm
CONFIG_NFTL=3Dm
CONFIG_NFTL_RW=3Dy
CONFIG_INFTL=3Dm
CONFIG_RFD_FTL=3Dm
CONFIG_SSFDC=3Dm
CONFIG_MTD_OOPS=3Dm

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=3Dm
CONFIG_MTD_JEDECPROBE=3Dm
CONFIG_MTD_GEN_PROBE=3Dm
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_2=3Dy
CONFIG_MTD_MAP_BANK_WIDTH_4=3Dy
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=3Dy
CONFIG_MTD_CFI_I2=3Dy
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=3Dm
CONFIG_MTD_CFI_AMDSTD=3Dm
CONFIG_MTD_CFI_STAA=3Dm
CONFIG_MTD_CFI_UTIL=3Dm
CONFIG_MTD_RAM=3Dm
CONFIG_MTD_ROM=3Dm
CONFIG_MTD_ABSENT=3Dm

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=3Dy
CONFIG_MTD_PHYSMAP=3Dm
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=3Dm
CONFIG_MTD_NETSC520=3Dm
CONFIG_MTD_TS5500=3Dm
CONFIG_MTD_SBC_GXX=3Dm
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=3Dm
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=3Dm
CONFIG_MTD_INTEL_VR_NOR=3Dm
CONFIG_MTD_PLATRAM=3Dm

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=3Dm
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=3Dm
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=3Dm
CONFIG_M25PXX_USE_FAST_READ=3Dy
CONFIG_MTD_SST25L=3Dm
CONFIG_MTD_SLRAM=3Dm
CONFIG_MTD_PHRAM=3Dm
CONFIG_MTD_MTDRAM=3Dm
CONFIG_MTDRAM_TOTAL_SIZE=3D4096
CONFIG_MTDRAM_ERASE_SIZE=3D128
CONFIG_MTD_BLOCK2MTD=3Dm

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=3Dm
CONFIG_MTD_DOC2001=3Dm
CONFIG_MTD_DOC2001PLUS=3Dm
CONFIG_MTD_DOCPROBE=3Dm
CONFIG_MTD_DOCECC=3Dm
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=3D0
CONFIG_MTD_NAND=3Dm
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=3Dm
CONFIG_MTD_NAND_DISKONCHIP=3Dm
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=3D0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_CAFE=3Dm
CONFIG_MTD_NAND_NANDSIM=3Dm
CONFIG_MTD_NAND_PLATFORM=3Dm
CONFIG_MTD_ALAUDA=3Dm
CONFIG_MTD_ONENAND=3Dm
CONFIG_MTD_ONENAND_VERIFY_WRITE=3Dy
CONFIG_MTD_ONENAND_GENERIC=3Dm
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=3Dy
CONFIG_MTD_ONENAND_SIM=3Dm

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=3Dm
CONFIG_MTD_QINFO_PROBE=3Dm

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=3Dm
CONFIG_MTD_UBI_WL_THRESHOLD=3D4096
CONFIG_MTD_UBI_BEB_RESERVE=3D1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=3Dm
CONFIG_PARPORT_PC=3Dm
CONFIG_PARPORT_SERIAL=3Dm
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=3Dm
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=3Dm
CONFIG_PARPORT_1284=3Dy
CONFIG_PARPORT_NOT_PC=3Dy
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
CONFIG_BLK_DEV_FD=3Dm
CONFIG_PARIDE=3Dm

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=3Dm
CONFIG_PARIDE_PCD=3Dm
CONFIG_PARIDE_PF=3Dm
CONFIG_PARIDE_PT=3Dm
CONFIG_PARIDE_PG=3Dm

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=3Dm
CONFIG_PARIDE_BPCK=3Dm
CONFIG_PARIDE_COMM=3Dm
CONFIG_PARIDE_DSTR=3Dm
CONFIG_PARIDE_FIT2=3Dm
CONFIG_PARIDE_FIT3=3Dm
CONFIG_PARIDE_EPAT=3Dm
# CONFIG_PARIDE_EPATC8 is not set
CONFIG_PARIDE_EPIA=3Dm
CONFIG_PARIDE_FRIQ=3Dm
CONFIG_PARIDE_FRPW=3Dm
CONFIG_PARIDE_KBIC=3Dm
CONFIG_PARIDE_KTTI=3Dm
CONFIG_PARIDE_ON20=3Dm
CONFIG_PARIDE_ON26=3Dm
CONFIG_BLK_CPQ_DA=3Dm
CONFIG_BLK_CPQ_CISS_DA=3Dm
CONFIG_CISS_SCSI_TAPE=3Dy
CONFIG_BLK_DEV_DAC960=3Dm
CONFIG_BLK_DEV_UMEM=3Dm
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dm
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_NBD=3Dm
CONFIG_BLK_DEV_OSD=3Dm
CONFIG_BLK_DEV_SX8=3Dm
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dm
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=3Dm
CONFIG_XEN_BLKDEV_FRONTEND=3Dm
CONFIG_VIRTIO_BLK=3Dm
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=3Dy
CONFIG_IBM_ASM=3Dm
CONFIG_PHANTOM=3Dm
CONFIG_SGI_IOC4=3Dm
CONFIG_TIFM_CORE=3Dm
CONFIG_TIFM_7XX1=3Dm
CONFIG_ICS932S401=3Dm
CONFIG_ENCLOSURE_SERVICES=3Dm
CONFIG_HP_ILO=3Dm
CONFIG_DELL_LAPTOP=3Dm
CONFIG_ISL29003=3Dm
CONFIG_C2PORT=3Dm
CONFIG_C2PORT_DURAMAR_2150=3Dm

#
# EEPROM support
#
CONFIG_EEPROM_AT24=3Dm
CONFIG_EEPROM_AT25=3Dm
CONFIG_EEPROM_LEGACY=3Dm
CONFIG_EEPROM_MAX6875=3Dm
CONFIG_EEPROM_93CX6=3Dm
CONFIG_CB710_CORE=3Dm
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=3Dy
CONFIG_HAVE_IDE=3Dy
CONFIG_IDE=3Dm

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=3Dy
CONFIG_IDE_TIMINGS=3Dy
CONFIG_IDE_ATAPI=3Dy
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=3Dm
CONFIG_IDE_GD_ATA=3Dy
CONFIG_IDE_GD_ATAPI=3Dy
CONFIG_BLK_DEV_IDECS=3Dm
CONFIG_BLK_DEV_DELKIN=3Dm
CONFIG_BLK_DEV_IDECD=3Dm
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=3Dy
CONFIG_BLK_DEV_IDETAPE=3Dm
CONFIG_BLK_DEV_IDEACPI=3Dy
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=3Dy

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dm
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=3Dm
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=3Dm
CONFIG_BLK_DEV_IDEDMA_SFF=3Dy

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=3Dy
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=3Dm
CONFIG_BLK_DEV_OPTI621=3Dm
CONFIG_BLK_DEV_RZ1000=3Dm
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
CONFIG_BLK_DEV_AEC62XX=3Dm
CONFIG_BLK_DEV_ALI15X3=3Dm
CONFIG_BLK_DEV_AMD74XX=3Dm
CONFIG_BLK_DEV_ATIIXP=3Dm
CONFIG_BLK_DEV_CMD64X=3Dm
CONFIG_BLK_DEV_TRIFLEX=3Dm
CONFIG_BLK_DEV_CS5520=3Dm
CONFIG_BLK_DEV_CS5530=3Dm
CONFIG_BLK_DEV_HPT366=3Dm
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=3Dm
CONFIG_BLK_DEV_PIIX=3Dm
CONFIG_BLK_DEV_IT8172=3Dm
CONFIG_BLK_DEV_IT8213=3Dm
CONFIG_BLK_DEV_IT821X=3Dm
CONFIG_BLK_DEV_NS87415=3Dm
CONFIG_BLK_DEV_PDC202XX_OLD=3Dm
CONFIG_BLK_DEV_PDC202XX_NEW=3Dm
CONFIG_BLK_DEV_SVWKS=3Dm
CONFIG_BLK_DEV_SIIMAGE=3Dm
CONFIG_BLK_DEV_SIS5513=3Dm
CONFIG_BLK_DEV_SLC90E66=3Dm
CONFIG_BLK_DEV_TRM290=3Dm
CONFIG_BLK_DEV_VIA82CXXX=3Dm
CONFIG_BLK_DEV_TC86C001=3Dm
CONFIG_BLK_DEV_IDEDMA=3Dy

#
# SCSI device support
#
CONFIG_RAID_ATTRS=3Dm
CONFIG_SCSI=3Dm
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dm
CONFIG_SCSI_NETLINK=3Dy
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dm
CONFIG_CHR_DEV_ST=3Dm
CONFIG_CHR_DEV_OSST=3Dm
CONFIG_BLK_DEV_SR=3Dm
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dm
CONFIG_CHR_DEV_SCH=3Dm
CONFIG_SCSI_ENCLOSURE=3Dm
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
CONFIG_SCSI_SCAN_ASYNC=3Dy
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dm
CONFIG_SCSI_FC_ATTRS=3Dm
CONFIG_SCSI_FC_TGT_ATTRS=3Dy
CONFIG_SCSI_ISCSI_ATTRS=3Dm
CONFIG_SCSI_SAS_ATTRS=3Dm
CONFIG_SCSI_SAS_LIBSAS=3Dm
CONFIG_SCSI_SAS_ATA=3Dy
CONFIG_SCSI_SAS_HOST_SMP=3Dy
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=3Dm
CONFIG_SCSI_SRP_TGT_ATTRS=3Dy
CONFIG_SCSI_LOWLEVEL=3Dy
CONFIG_ISCSI_TCP=3Dm
CONFIG_SCSI_CXGB3_ISCSI=3Dm
CONFIG_SCSI_BNX2_ISCSI=3Dm
CONFIG_BE2ISCSI=3Dm
CONFIG_BLK_DEV_3W_XXXX_RAID=3Dm
CONFIG_SCSI_3W_9XXX=3Dm
CONFIG_SCSI_3W_SAS=3Dm
CONFIG_SCSI_ACARD=3Dm
CONFIG_SCSI_AACRAID=3Dm
CONFIG_SCSI_AIC7XXX=3Dm
CONFIG_AIC7XXX_CMDS_PER_DEVICE=3D8
CONFIG_AIC7XXX_RESET_DELAY_MS=3D15000
CONFIG_AIC7XXX_DEBUG_ENABLE=3Dy
CONFIG_AIC7XXX_DEBUG_MASK=3D0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=3Dy
CONFIG_SCSI_AIC7XXX_OLD=3Dm
CONFIG_SCSI_AIC79XX=3Dm
CONFIG_AIC79XX_CMDS_PER_DEVICE=3D32
CONFIG_AIC79XX_RESET_DELAY_MS=3D15000
CONFIG_AIC79XX_DEBUG_ENABLE=3Dy
CONFIG_AIC79XX_DEBUG_MASK=3D0
CONFIG_AIC79XX_REG_PRETTY_PRINT=3Dy
CONFIG_SCSI_AIC94XX=3Dm
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=3Dm
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_DPT_I2O=3Dm
CONFIG_SCSI_ADVANSYS=3Dm
CONFIG_SCSI_ARCMSR=3Dm
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=3Dy
CONFIG_MEGARAID_MM=3Dm
CONFIG_MEGARAID_MAILBOX=3Dm
CONFIG_MEGARAID_LEGACY=3Dm
CONFIG_MEGARAID_SAS=3Dm
CONFIG_SCSI_MPT2SAS=3Dm
CONFIG_SCSI_MPT2SAS_MAX_SGE=3D128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_HPTIOP=3Dm
CONFIG_SCSI_BUSLOGIC=3Dm
CONFIG_LIBFC=3Dm
CONFIG_LIBFCOE=3Dm
CONFIG_FCOE=3Dm
CONFIG_FCOE_FNIC=3Dm
CONFIG_SCSI_DMX3191D=3Dm
CONFIG_SCSI_EATA=3Dm
CONFIG_SCSI_EATA_TAGGED_QUEUE=3Dy
CONFIG_SCSI_EATA_LINKED_COMMANDS=3Dy
CONFIG_SCSI_EATA_MAX_TAGS=3D16
CONFIG_SCSI_FUTURE_DOMAIN=3Dm
CONFIG_SCSI_GDTH=3Dm
CONFIG_SCSI_IPS=3Dm
CONFIG_SCSI_INITIO=3Dm
CONFIG_SCSI_INIA100=3Dm
CONFIG_SCSI_PPA=3Dm
CONFIG_SCSI_IMM=3Dm
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=3Dm
CONFIG_SCSI_SYM53C8XX_2=3Dm
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=3D1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=3D16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=3D64
CONFIG_SCSI_SYM53C8XX_MMIO=3Dy
CONFIG_SCSI_IPR=3Dm
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=3Dm
CONFIG_SCSI_QLA_FC=3Dm
CONFIG_SCSI_QLA_ISCSI=3Dm
CONFIG_SCSI_LPFC=3Dm
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_DC395x=3Dm
CONFIG_SCSI_DC390T=3Dm
CONFIG_SCSI_DEBUG=3Dm
CONFIG_SCSI_PMCRAID=3Dm
CONFIG_SCSI_SRP=3Dm
CONFIG_SCSI_BFA_FC=3Dm
CONFIG_SCSI_LOWLEVEL_PCMCIA=3Dy
CONFIG_PCMCIA_FDOMAIN=3Dm
CONFIG_PCMCIA_QLOGIC=3Dm
CONFIG_PCMCIA_SYM53C500=3Dm
CONFIG_SCSI_DH=3Dm
CONFIG_SCSI_DH_RDAC=3Dm
CONFIG_SCSI_DH_HP_SW=3Dm
CONFIG_SCSI_DH_EMC=3Dm
CONFIG_SCSI_DH_ALUA=3Dm
CONFIG_SCSI_OSD_INITIATOR=3Dm
CONFIG_SCSI_OSD_ULD=3Dm
CONFIG_SCSI_OSD_DPRINT_SENSE=3D1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=3Dm
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=3Dy
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_PMP=3Dy
CONFIG_SATA_AHCI=3Dm
CONFIG_SATA_SIL24=3Dm
CONFIG_ATA_SFF=3Dy
CONFIG_SATA_SVW=3Dm
CONFIG_ATA_PIIX=3Dm
CONFIG_SATA_MV=3Dm
CONFIG_SATA_NV=3Dm
CONFIG_PDC_ADMA=3Dm
CONFIG_SATA_QSTOR=3Dm
CONFIG_SATA_PROMISE=3Dm
CONFIG_SATA_SX4=3Dm
CONFIG_SATA_SIL=3Dm
CONFIG_SATA_SIS=3Dm
CONFIG_SATA_ULI=3Dm
CONFIG_SATA_VIA=3Dm
CONFIG_SATA_VITESSE=3Dm
CONFIG_SATA_INIC162X=3Dm
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
CONFIG_PATA_ARTOP=3Dm
CONFIG_PATA_ATP867X=3Dm
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=3Dm
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=3Dm
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=3Dm
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=3Dm
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS_STUB=3Dm
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_SCH=3Dm
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dm
CONFIG_MD_LINEAR=3Dm
CONFIG_MD_RAID0=3Dm
CONFIG_MD_RAID1=3Dm
CONFIG_MD_RAID10=3Dm
CONFIG_MD_RAID456=3Dm
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_RAID6_PQ=3Dm
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_MD_MULTIPATH=3Dm
CONFIG_MD_FAULTY=3Dm
CONFIG_BLK_DEV_DM=3Dm
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=3Dm
CONFIG_DM_SNAPSHOT=3Dm
CONFIG_DM_MIRROR=3Dm
CONFIG_DM_LOG_USERSPACE=3Dm
CONFIG_DM_ZERO=3Dm
CONFIG_DM_MULTIPATH=3Dm
CONFIG_DM_MULTIPATH_QL=3Dm
CONFIG_DM_MULTIPATH_ST=3Dm
CONFIG_DM_DELAY=3Dm
CONFIG_DM_UEVENT=3Dy
CONFIG_FUSION=3Dy
CONFIG_FUSION_SPI=3Dm
CONFIG_FUSION_FC=3Dm
CONFIG_FUSION_SAS=3Dm
CONFIG_FUSION_MAX_SGE=3D40
CONFIG_FUSION_CTL=3Dm
CONFIG_FUSION_LAN=3Dm
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
CONFIG_FIREWIRE=3Dm
CONFIG_FIREWIRE_OHCI=3Dm
CONFIG_FIREWIRE_OHCI_DEBUG=3Dy
CONFIG_FIREWIRE_SBP2=3Dm
CONFIG_FIREWIRE_NET=3Dm
# CONFIG_IEEE1394 is not set
CONFIG_I2O=3Dm
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=3Dy
CONFIG_I2O_EXT_ADAPTEC=3Dy
CONFIG_I2O_EXT_ADAPTEC_DMA64=3Dy
CONFIG_I2O_CONFIG=3Dm
CONFIG_I2O_CONFIG_OLD_IOCTL=3Dy
CONFIG_I2O_BUS=3Dm
CONFIG_I2O_BLOCK=3Dm
CONFIG_I2O_SCSI=3Dm
CONFIG_I2O_PROC=3Dm
CONFIG_MACINTOSH_DRIVERS=3Dy
CONFIG_MAC_EMUMOUSEBTN=3Dy
CONFIG_NETDEVICES=3Dy
CONFIG_IFB=3Dm
CONFIG_DUMMY=3Dm
CONFIG_BONDING=3Dm
CONFIG_MACVLAN=3Dm
CONFIG_EQUALIZER=3Dm
CONFIG_TUN=3Dm
CONFIG_VETH=3Dm
CONFIG_NET_SB1000=3Dm
CONFIG_ARCNET=3Dm
CONFIG_ARCNET_1201=3Dm
CONFIG_ARCNET_1051=3Dm
CONFIG_ARCNET_RAW=3Dm
CONFIG_ARCNET_CAP=3Dm
CONFIG_ARCNET_COM90xx=3Dm
CONFIG_ARCNET_COM90xxIO=3Dm
CONFIG_ARCNET_RIM_I=3Dm
CONFIG_ARCNET_COM20020=3Dm
CONFIG_ARCNET_COM20020_PCI=3Dm
CONFIG_PHYLIB=3Dm

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=3Dm
CONFIG_DAVICOM_PHY=3Dm
CONFIG_QSEMI_PHY=3Dm
CONFIG_LXT_PHY=3Dm
CONFIG_CICADA_PHY=3Dm
CONFIG_VITESSE_PHY=3Dm
CONFIG_SMSC_PHY=3Dm
CONFIG_BROADCOM_PHY=3Dm
CONFIG_ICPLUS_PHY=3Dm
CONFIG_REALTEK_PHY=3Dm
CONFIG_NATIONAL_PHY=3Dm
CONFIG_STE10XP=3Dm
CONFIG_LSI_ET1011C_PHY=3Dm
CONFIG_MDIO_BITBANG=3Dm
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dm
CONFIG_HAPPYMEAL=3Dm
CONFIG_SUNGEM=3Dm
CONFIG_CASSINI=3Dm
CONFIG_NET_VENDOR_3COM=3Dy
CONFIG_VORTEX=3Dm
CONFIG_TYPHOON=3Dm
CONFIG_ENC28J60=3Dm
# CONFIG_ENC28J60_WRITEVERIFY is not set
CONFIG_ETHOC=3Dm
CONFIG_DNET=3Dm
CONFIG_NET_TULIP=3Dy
CONFIG_DE2104X=3Dm
CONFIG_DE2104X_DSL=3D0
CONFIG_TULIP=3Dm
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=3Dy
CONFIG_TULIP_NAPI_HW_MITIGATION=3Dy
CONFIG_DE4X5=3Dm
CONFIG_WINBOND_840=3Dm
CONFIG_DM9102=3Dm
CONFIG_ULI526X=3Dm
CONFIG_PCMCIA_XIRCOM=3Dm
CONFIG_HP100=3Dm
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=3Dy
CONFIG_PCNET32=3Dm
CONFIG_AMD8111_ETH=3Dm
CONFIG_ADAPTEC_STARFIRE=3Dm
CONFIG_B44=3Dm
CONFIG_B44_PCI_AUTOSELECT=3Dy
CONFIG_B44_PCICORE_AUTOSELECT=3Dy
CONFIG_B44_PCI=3Dy
CONFIG_FORCEDETH=3Dm
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_E100=3Dm
CONFIG_FEALNX=3Dm
CONFIG_NATSEMI=3Dm
CONFIG_NE2K_PCI=3Dm
CONFIG_8139CP=3Dm
CONFIG_8139TOO=3Dm
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=3Dy
CONFIG_8139TOO_8129=3Dy
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=3Dm
CONFIG_SIS900=3Dm
CONFIG_EPIC100=3Dm
CONFIG_SMSC9420=3Dm
CONFIG_SUNDANCE=3Dm
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=3Dm
CONFIG_KS8842=3Dm
CONFIG_KS8851=3Dm
CONFIG_KS8851_MLL=3Dm
CONFIG_VIA_RHINE=3Dm
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_SC92031=3Dm
# CONFIG_NET_POCKET is not set
CONFIG_ATL2=3Dm
CONFIG_NETDEV_1000=3Dy
CONFIG_ACENIC=3Dm
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=3Dm
CONFIG_E1000=3Dm
CONFIG_E1000E=3Dm
CONFIG_IP1000=3Dm
CONFIG_IGB=3Dm
CONFIG_IGB_DCA=3Dy
CONFIG_IGBVF=3Dm
CONFIG_NS83820=3Dm
CONFIG_HAMACHI=3Dm
CONFIG_YELLOWFIN=3Dm
CONFIG_R8169=3Dm
CONFIG_R8169_VLAN=3Dy
CONFIG_SIS190=3Dm
CONFIG_SKGE=3Dm
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=3Dm
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=3Dm
CONFIG_TIGON3=3Dm
CONFIG_BNX2=3Dm
CONFIG_CNIC=3Dm
CONFIG_QLA3XXX=3Dm
CONFIG_ATL1=3Dm
CONFIG_ATL1E=3Dm
CONFIG_ATL1C=3Dm
CONFIG_JME=3Dm
CONFIG_NETDEV_10000=3Dy
CONFIG_MDIO=3Dm
CONFIG_CHELSIO_T1=3Dm
CONFIG_CHELSIO_T1_1G=3Dy
CONFIG_CHELSIO_T3_DEPENDS=3Dy
CONFIG_CHELSIO_T3=3Dm
CONFIG_ENIC=3Dm
CONFIG_IXGBE=3Dm
CONFIG_IXGBE_DCA=3Dy
CONFIG_IXGBE_DCB=3Dy
CONFIG_IXGB=3Dm
CONFIG_S2IO=3Dm
CONFIG_VXGE=3Dm
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_MYRI10GE=3Dm
CONFIG_MYRI10GE_DCA=3Dy
CONFIG_NETXEN_NIC=3Dm
CONFIG_NIU=3Dm
CONFIG_MLX4_EN=3Dm
CONFIG_MLX4_CORE=3Dm
CONFIG_MLX4_DEBUG=3Dy
CONFIG_TEHUTI=3Dm
CONFIG_BNX2X=3Dm
CONFIG_QLGE=3Dm
CONFIG_SFC=3Dm
CONFIG_SFC_MTD=3Dy
CONFIG_BE2NET=3Dm
CONFIG_TR=3Dy
CONFIG_IBMOL=3Dm
CONFIG_3C359=3Dm
CONFIG_TMS380TR=3Dm
CONFIG_TMSPCI=3Dm
CONFIG_ABYSS=3Dm
CONFIG_WLAN=3Dy
CONFIG_WLAN_PRE80211=3Dy
CONFIG_STRIP=3Dm
CONFIG_PCMCIA_WAVELAN=3Dm
CONFIG_PCMCIA_NETWAVE=3Dm
CONFIG_WLAN_80211=3Dy
CONFIG_PCMCIA_RAYCS=3Dm
CONFIG_LIBERTAS=3Dm
CONFIG_LIBERTAS_USB=3Dm
CONFIG_LIBERTAS_CS=3Dm
CONFIG_LIBERTAS_SDIO=3Dm
CONFIG_LIBERTAS_SPI=3Dm
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM=3Dm
CONFIG_LIBERTAS_THINFIRM_USB=3Dm
CONFIG_AIRO=3Dm
CONFIG_ATMEL=3Dm
CONFIG_PCI_ATMEL=3Dm
CONFIG_PCMCIA_ATMEL=3Dm
CONFIG_AT76C50X_USB=3Dm
CONFIG_AIRO_CS=3Dm
CONFIG_PCMCIA_WL3501=3Dm
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=3Dm
CONFIG_USB_NET_RNDIS_WLAN=3Dm
CONFIG_RTL8180=3Dm
CONFIG_RTL8187=3Dm
CONFIG_RTL8187_LEDS=3Dy
CONFIG_ADM8211=3Dm
CONFIG_MAC80211_HWSIM=3Dm
CONFIG_MWL8K=3Dm
CONFIG_P54_COMMON=3Dm
CONFIG_P54_USB=3Dm
CONFIG_P54_PCI=3Dm
CONFIG_P54_SPI=3Dm
CONFIG_P54_LEDS=3Dy
CONFIG_ATH_COMMON=3Dm
CONFIG_ATH5K=3Dm
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K=3Dm
# CONFIG_ATH9K_DEBUG is not set
CONFIG_AR9170_USB=3Dm
CONFIG_AR9170_LEDS=3Dy
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=3Dm
CONFIG_IPW2200_MONITOR=3Dy
CONFIG_IPW2200_RADIOTAP=3Dy
CONFIG_IPW2200_PROMISCUOUS=3Dy
CONFIG_IPW2200_QOS=3Dy
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=3Dm
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=3Dm
CONFIG_IWLWIFI_LEDS=3Dy
CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=3Dy
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=3Dm
CONFIG_IWL4965=3Dy
CONFIG_IWL5000=3Dy
CONFIG_IWL3945=3Dm
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=3Dy
CONFIG_HOSTAP=3Dm
CONFIG_HOSTAP_FIRMWARE=3Dy
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=3Dm
CONFIG_HOSTAP_PCI=3Dm
CONFIG_HOSTAP_CS=3Dm
CONFIG_B43=3Dm
CONFIG_B43_PCI_AUTOSELECT=3Dy
CONFIG_B43_PCICORE_AUTOSELECT=3Dy
CONFIG_B43_PCMCIA=3Dy
CONFIG_B43_SDIO=3Dy
CONFIG_B43_PIO=3Dy
CONFIG_B43_PHY_LP=3Dy
CONFIG_B43_LEDS=3Dy
CONFIG_B43_HWRNG=3Dy
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=3Dm
CONFIG_B43LEGACY_PCI_AUTOSELECT=3Dy
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=3Dy
CONFIG_B43LEGACY_LEDS=3Dy
CONFIG_B43LEGACY_HWRNG=3Dy
CONFIG_B43LEGACY_DEBUG=3Dy
CONFIG_B43LEGACY_DMA=3Dy
CONFIG_B43LEGACY_PIO=3Dy
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=3Dy
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_ZD1211RW=3Dm
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_RT2X00=3Dm
CONFIG_RT2400PCI=3Dm
CONFIG_RT2500PCI=3Dm
CONFIG_RT61PCI=3Dm
CONFIG_RT2500USB=3Dm
CONFIG_RT73USB=3Dm
CONFIG_RT2800USB=3Dm
CONFIG_RT2X00_LIB_PCI=3Dm
CONFIG_RT2X00_LIB_USB=3Dm
CONFIG_RT2X00_LIB=3Dm
CONFIG_RT2X00_LIB_HT=3Dy
CONFIG_RT2X00_LIB_FIRMWARE=3Dy
CONFIG_RT2X00_LIB_CRYPTO=3Dy
CONFIG_RT2X00_LIB_LEDS=3Dy
# CONFIG_RT2X00_DEBUG is not set
CONFIG_HERMES=3Dm
CONFIG_HERMES_CACHE_FW_ON_INIT=3Dy
CONFIG_PLX_HERMES=3Dm
CONFIG_TMD_HERMES=3Dm
CONFIG_NORTEL_HERMES=3Dm
CONFIG_PCI_HERMES=3Dm
CONFIG_PCMCIA_HERMES=3Dm
CONFIG_PCMCIA_SPECTRUM=3Dm
CONFIG_WL12XX=3Dm
CONFIG_WL1251=3Dm
CONFIG_WL1251_SPI=3Dm
CONFIG_WL1251_SDIO=3Dm
CONFIG_WL1271=3Dm
CONFIG_IWM=3Dm
# CONFIG_IWM_DEBUG is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=3Dm
CONFIG_WIMAX_I2400M_USB=3Dm
CONFIG_WIMAX_I2400M_SDIO=3Dm
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=3D8

#
# USB Network Adapters
#
CONFIG_USB_CATC=3Dm
CONFIG_USB_KAWETH=3Dm
CONFIG_USB_PEGASUS=3Dm
CONFIG_USB_RTL8150=3Dm
CONFIG_USB_USBNET=3Dm
CONFIG_USB_NET_AX8817X=3Dm
CONFIG_USB_NET_CDCETHER=3Dm
CONFIG_USB_NET_CDC_EEM=3Dm
CONFIG_USB_NET_DM9601=3Dm
CONFIG_USB_NET_SMSC95XX=3Dm
CONFIG_USB_NET_GL620A=3Dm
CONFIG_USB_NET_NET1080=3Dm
CONFIG_USB_NET_PLUSB=3Dm
CONFIG_USB_NET_MCS7830=3Dm
CONFIG_USB_NET_RNDIS_HOST=3Dm
CONFIG_USB_NET_CDC_SUBSET=3Dm
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_ARMLINUX=3Dy
CONFIG_USB_EPSON2888=3Dy
CONFIG_USB_KC2190=3Dy
CONFIG_USB_NET_ZAURUS=3Dm
CONFIG_USB_HSO=3Dm
CONFIG_USB_NET_INT51X1=3Dm
CONFIG_USB_CDC_PHONET=3Dm
CONFIG_NET_PCMCIA=3Dy
CONFIG_PCMCIA_3C589=3Dm
CONFIG_PCMCIA_3C574=3Dm
CONFIG_PCMCIA_FMVJ18X=3Dm
CONFIG_PCMCIA_PCNET=3Dm
CONFIG_PCMCIA_NMCLAN=3Dm
CONFIG_PCMCIA_SMC91C92=3Dm
CONFIG_PCMCIA_XIRC2PS=3Dm
CONFIG_PCMCIA_AXNET=3Dm
CONFIG_ARCNET_COM20020_CS=3Dm
CONFIG_PCMCIA_IBMTR=3Dm
CONFIG_WAN=3Dy
CONFIG_LANMEDIA=3Dm
CONFIG_HDLC=3Dm
CONFIG_HDLC_RAW=3Dm
CONFIG_HDLC_RAW_ETH=3Dm
CONFIG_HDLC_CISCO=3Dm
CONFIG_HDLC_FR=3Dm
CONFIG_HDLC_PPP=3Dm
CONFIG_HDLC_X25=3Dm
CONFIG_PCI200SYN=3Dm
CONFIG_WANXL=3Dm
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=3Dm
CONFIG_DSCC4=3Dm
CONFIG_DSCC4_PCISYNC=3Dy
CONFIG_DSCC4_PCI_RST=3Dy
CONFIG_DLCI=3Dm
CONFIG_DLCI_MAX=3D8
CONFIG_WAN_ROUTER_DRIVERS=3Dm
CONFIG_CYCLADES_SYNC=3Dm
CONFIG_CYCLOMX_X25=3Dy
CONFIG_LAPBETHER=3Dm
CONFIG_X25_ASY=3Dm
CONFIG_SBNI=3Dm
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ATM_DRIVERS=3Dy
CONFIG_ATM_DUMMY=3Dm
CONFIG_ATM_TCP=3Dm
CONFIG_ATM_LANAI=3Dm
CONFIG_ATM_ENI=3Dm
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=3Dm
CONFIG_ATM_ZATM=3Dm
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_IDT77252=3Dm
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=3Dy
CONFIG_ATM_AMBASSADOR=3Dm
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=3Dm
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=3Dm
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=3Dm
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=3D16
CONFIG_ATM_FORE200E_DEBUG=3D0
CONFIG_ATM_HE=3Dm
CONFIG_ATM_HE_USE_SUNI=3Dy
CONFIG_ATM_SOLOS=3Dm
CONFIG_IEEE802154_DRIVERS=3Dm
CONFIG_IEEE802154_FAKEHARD=3Dm
CONFIG_XEN_NETDEV_FRONTEND=3Dm
CONFIG_FDDI=3Dy
CONFIG_DEFXX=3Dm
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=3Dm
CONFIG_HIPPI=3Dy
CONFIG_ROADRUNNER=3Dm
# CONFIG_ROADRUNNER_LARGE_RINGS is not set
CONFIG_PLIP=3Dm
CONFIG_PPP=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_MPPE=3Dm
CONFIG_PPPOE=3Dm
CONFIG_PPPOATM=3Dm
CONFIG_PPPOL2TP=3Dm
CONFIG_SLIP=3Dm
CONFIG_SLIP_COMPRESSED=3Dy
CONFIG_SLHC=3Dm
CONFIG_SLIP_SMART=3Dy
CONFIG_SLIP_MODE_SLIP6=3Dy
CONFIG_NET_FC=3Dy
CONFIG_NETCONSOLE=3Dm
CONFIG_NETCONSOLE_DYNAMIC=3Dy
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy
CONFIG_VIRTIO_NET=3Dm
CONFIG_VMXNET3=3Dm
CONFIG_ISDN=3Dy
CONFIG_ISDN_I4L=3Dm
CONFIG_MISDN=3Dm
CONFIG_MISDN_DSP=3Dm
CONFIG_MISDN_L1OIP=3Dm

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=3Dm
CONFIG_MISDN_HFCMULTI=3Dm
CONFIG_MISDN_HFCUSB=3Dm
CONFIG_MISDN_AVMFRITZ=3Dm
CONFIG_MISDN_SPEEDFAX=3Dm
CONFIG_MISDN_INFINEON=3Dm
CONFIG_MISDN_W6692=3Dm
CONFIG_MISDN_NETJET=3Dm
CONFIG_MISDN_IPAC=3Dm
CONFIG_MISDN_ISAR=3Dm
CONFIG_ISDN_PPP=3Dy
CONFIG_ISDN_PPP_VJ=3Dy
CONFIG_ISDN_MPP=3Dy
CONFIG_IPPP_FILTER=3Dy
CONFIG_ISDN_PPP_BSDCOMP=3Dm
CONFIG_ISDN_AUDIO=3Dy
CONFIG_ISDN_TTY_FAX=3Dy
CONFIG_ISDN_X25=3Dy

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=3Dm

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=3Dm

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=3Dy
CONFIG_DE_AOC=3Dy
# CONFIG_HISAX_NO_SENDCOMPLETE is not set
# CONFIG_HISAX_NO_LLC is not set
# CONFIG_HISAX_NO_KEYPAD is not set
CONFIG_HISAX_1TR6=3Dy
CONFIG_HISAX_NI1=3Dy
CONFIG_HISAX_MAX_CARDS=3D8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=3Dy
CONFIG_HISAX_TELESPCI=3Dy
CONFIG_HISAX_S0BOX=3Dy
CONFIG_HISAX_FRITZPCI=3Dy
CONFIG_HISAX_AVM_A1_PCMCIA=3Dy
CONFIG_HISAX_ELSA=3Dy
CONFIG_HISAX_DIEHLDIVA=3Dy
CONFIG_HISAX_SEDLBAUER=3Dy
CONFIG_HISAX_NETJET=3Dy
CONFIG_HISAX_NETJET_U=3Dy
CONFIG_HISAX_NICCY=3Dy
CONFIG_HISAX_BKM_A4T=3Dy
CONFIG_HISAX_SCT_QUADRO=3Dy
CONFIG_HISAX_GAZEL=3Dy
CONFIG_HISAX_HFC_PCI=3Dy
CONFIG_HISAX_W6692=3Dy
CONFIG_HISAX_HFC_SX=3Dy
CONFIG_HISAX_ENTERNOW_PCI=3Dy
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=3Dm
CONFIG_HISAX_ELSA_CS=3Dm
CONFIG_HISAX_AVM_A1_CS=3Dm
CONFIG_HISAX_TELES_CS=3Dm

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=3Dm
CONFIG_HISAX_HFCUSB=3Dm
CONFIG_HISAX_HFC4S8S=3Dm
CONFIG_HISAX_FRITZ_PCIPNP=3Dm

#
# Active cards
#
CONFIG_HYSDN=3Dm
CONFIG_HYSDN_CAPI=3Dy
CONFIG_ISDN_HDLC=3Dm
CONFIG_ISDN_CAPI=3Dm
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=3Dy
CONFIG_CAPI_TRACE=3Dy
CONFIG_ISDN_CAPI_MIDDLEWARE=3Dy
CONFIG_ISDN_CAPI_CAPI20=3Dm
CONFIG_ISDN_CAPI_CAPIFS_BOOL=3Dy
CONFIG_ISDN_CAPI_CAPIFS=3Dm
CONFIG_ISDN_CAPI_CAPIDRV=3Dm

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=3Dy
CONFIG_ISDN_DRV_AVMB1_B1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=3Dy
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=3Dm
CONFIG_ISDN_DRV_AVMB1_AVM_CS=3Dm
CONFIG_ISDN_DRV_AVMB1_T1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_C4=3Dm
CONFIG_CAPI_EICON=3Dy
CONFIG_ISDN_DIVAS=3Dm
CONFIG_ISDN_DIVAS_BRIPCI=3Dy
CONFIG_ISDN_DIVAS_PRIPCI=3Dy
CONFIG_ISDN_DIVAS_DIVACAPI=3Dm
CONFIG_ISDN_DIVAS_USERIDI=3Dm
CONFIG_ISDN_DIVAS_MAINT=3Dm
CONFIG_ISDN_DRV_GIGASET=3Dm
CONFIG_GIGASET_BASE=3Dm
CONFIG_GIGASET_M105=3Dm
CONFIG_GIGASET_M101=3Dm
# CONFIG_GIGASET_DEBUG is not set
CONFIG_PHONE=3Dm
CONFIG_PHONE_IXJ=3Dm
CONFIG_PHONE_IXJ_PCMCIA=3Dm

#
# Input device support
#
CONFIG_INPUT=3Dy
CONFIG_INPUT_FF_MEMLESS=3Dm
CONFIG_INPUT_POLLDEV=3Dm

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
CONFIG_INPUT_EVDEV=3Dm
# CONFIG_INPUT_EVBUG is not set
CONFIG_XEN_KBDDEV_FRONTEND=3Dy

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ADP5588=3Dm
CONFIG_KEYBOARD_ATKBD=3Dy
CONFIG_QT2160=3Dm
CONFIG_KEYBOARD_LKKBD=3Dm
CONFIG_KEYBOARD_LM8323=3Dm
CONFIG_KEYBOARD_MAX7359=3Dm
CONFIG_KEYBOARD_NEWTON=3Dm
CONFIG_KEYBOARD_OPENCORES=3Dm
CONFIG_KEYBOARD_STOWAWAY=3Dm
CONFIG_KEYBOARD_SUNKBD=3Dm
CONFIG_KEYBOARD_XTKBD=3Dm
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dm
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
CONFIG_MOUSE_PS2_ELANTECH=3Dy
CONFIG_MOUSE_PS2_SENTELIC=3Dy
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=3Dm
CONFIG_MOUSE_APPLETOUCH=3Dm
CONFIG_MOUSE_BCM5974=3Dm
CONFIG_MOUSE_VSXXXAA=3Dm
CONFIG_MOUSE_SYNAPTICS_I2C=3Dm
CONFIG_INPUT_JOYSTICK=3Dy
CONFIG_JOYSTICK_ANALOG=3Dm
CONFIG_JOYSTICK_A3D=3Dm
CONFIG_JOYSTICK_ADI=3Dm
CONFIG_JOYSTICK_COBRA=3Dm
CONFIG_JOYSTICK_GF2K=3Dm
CONFIG_JOYSTICK_GRIP=3Dm
CONFIG_JOYSTICK_GRIP_MP=3Dm
CONFIG_JOYSTICK_GUILLEMOT=3Dm
CONFIG_JOYSTICK_INTERACT=3Dm
CONFIG_JOYSTICK_SIDEWINDER=3Dm
CONFIG_JOYSTICK_TMDC=3Dm
CONFIG_JOYSTICK_IFORCE=3Dm
CONFIG_JOYSTICK_IFORCE_USB=3Dy
CONFIG_JOYSTICK_IFORCE_232=3Dy
CONFIG_JOYSTICK_WARRIOR=3Dm
CONFIG_JOYSTICK_MAGELLAN=3Dm
CONFIG_JOYSTICK_SPACEORB=3Dm
CONFIG_JOYSTICK_SPACEBALL=3Dm
CONFIG_JOYSTICK_STINGER=3Dm
CONFIG_JOYSTICK_TWIDJOY=3Dm
CONFIG_JOYSTICK_ZHENHUA=3Dm
CONFIG_JOYSTICK_DB9=3Dm
CONFIG_JOYSTICK_GAMECON=3Dm
CONFIG_JOYSTICK_TURBOGRAFX=3Dm
CONFIG_JOYSTICK_JOYDUMP=3Dm
CONFIG_JOYSTICK_XPAD=3Dm
CONFIG_JOYSTICK_XPAD_FF=3Dy
CONFIG_JOYSTICK_XPAD_LEDS=3Dy
CONFIG_JOYSTICK_WALKERA0701=3Dm
CONFIG_INPUT_TABLET=3Dy
CONFIG_TABLET_USB_ACECAD=3Dm
CONFIG_TABLET_USB_AIPTEK=3Dm
CONFIG_TABLET_USB_GTCO=3Dm
CONFIG_TABLET_USB_KBTAB=3Dm
CONFIG_TABLET_USB_WACOM=3Dm
CONFIG_INPUT_TOUCHSCREEN=3Dy
CONFIG_TOUCHSCREEN_ADS7846=3Dm
CONFIG_TOUCHSCREEN_AD7877=3Dm
CONFIG_TOUCHSCREEN_AD7879_I2C=3Dm
CONFIG_TOUCHSCREEN_AD7879=3Dm
CONFIG_TOUCHSCREEN_EETI=3Dm
CONFIG_TOUCHSCREEN_FUJITSU=3Dm
CONFIG_TOUCHSCREEN_GUNZE=3Dm
CONFIG_TOUCHSCREEN_ELO=3Dm
CONFIG_TOUCHSCREEN_WACOM_W8001=3Dm
CONFIG_TOUCHSCREEN_MCS5000=3Dm
CONFIG_TOUCHSCREEN_MTOUCH=3Dm
CONFIG_TOUCHSCREEN_INEXIO=3Dm
CONFIG_TOUCHSCREEN_MK712=3Dm
CONFIG_TOUCHSCREEN_PENMOUNT=3Dm
CONFIG_TOUCHSCREEN_TOUCHRIGHT=3Dm
CONFIG_TOUCHSCREEN_TOUCHWIN=3Dm
CONFIG_TOUCHSCREEN_WM97XX=3Dm
CONFIG_TOUCHSCREEN_WM9705=3Dy
CONFIG_TOUCHSCREEN_WM9712=3Dy
CONFIG_TOUCHSCREEN_WM9713=3Dy
CONFIG_TOUCHSCREEN_USB_COMPOSITE=3Dm
CONFIG_TOUCHSCREEN_USB_EGALAX=3Dy
CONFIG_TOUCHSCREEN_USB_PANJIT=3Dy
CONFIG_TOUCHSCREEN_USB_3M=3Dy
CONFIG_TOUCHSCREEN_USB_ITM=3Dy
CONFIG_TOUCHSCREEN_USB_ETURBO=3Dy
CONFIG_TOUCHSCREEN_USB_GUNZE=3Dy
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=3Dy
CONFIG_TOUCHSCREEN_USB_IRTOUCH=3Dy
CONFIG_TOUCHSCREEN_USB_IDEALTEK=3Dy
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=3Dy
CONFIG_TOUCHSCREEN_USB_GOTOP=3Dy
CONFIG_TOUCHSCREEN_USB_JASTEC=3Dy
CONFIG_TOUCHSCREEN_USB_E2I=3Dy
CONFIG_TOUCHSCREEN_TOUCHIT213=3Dm
CONFIG_TOUCHSCREEN_TSC2007=3Dm
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dm
CONFIG_INPUT_APANEL=3Dm
CONFIG_INPUT_ATLAS_BTNS=3Dm
CONFIG_INPUT_ATI_REMOTE=3Dm
CONFIG_INPUT_ATI_REMOTE2=3Dm
CONFIG_INPUT_KEYSPAN_REMOTE=3Dm
CONFIG_INPUT_POWERMATE=3Dm
CONFIG_INPUT_YEALINK=3Dm
CONFIG_INPUT_CM109=3Dm
CONFIG_INPUT_UINPUT=3Dm
CONFIG_INPUT_WINBOND_CIR=3Dm
CONFIG_INPUT_PCF50633_PMU=3Dm
CONFIG_INPUT_WM831X_ON=3Dm

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dm
CONFIG_SERIO_CT82C710=3Dm
CONFIG_SERIO_PARKBD=3Dm
CONFIG_SERIO_PCIPS2=3Dm
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
CONFIG_GAMEPORT=3Dm
CONFIG_GAMEPORT_NS558=3Dm
CONFIG_GAMEPORT_L4=3Dm
CONFIG_GAMEPORT_EMU10K1=3Dm
CONFIG_GAMEPORT_FM801=3Dm

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=3Dy
CONFIG_COMPUTONE=3Dm
CONFIG_ROCKETPORT=3Dm
CONFIG_CYCLADES=3Dm
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=3Dm
CONFIG_MOXA_INTELLIO=3Dm
CONFIG_MOXA_SMARTIO=3Dm
CONFIG_ISI=3Dm
CONFIG_SYNCLINK=3Dm
CONFIG_SYNCLINKMP=3Dm
CONFIG_SYNCLINK_GT=3Dm
CONFIG_N_HDLC=3Dm
CONFIG_RISCOM8=3Dm
CONFIG_SPECIALIX=3Dm
CONFIG_STALDRV=3Dy
# CONFIG_STALLION is not set
# CONFIG_ISTALLION is not set
CONFIG_NOZOMI=3Dm

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
CONFIG_SERIAL_8250_CONSOLE=3Dy
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_CS=3Dm
CONFIG_SERIAL_8250_NR_UARTS=3D32
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_MANY_PORTS=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=3Dy

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=3Dm
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_CORE_CONSOLE=3Dy
CONFIG_SERIAL_JSM=3Dm
CONFIG_UNIX98_PTYS=3Dy
CONFIG_DEVPTS_MULTIPLE_INSTANCES=3Dy
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=3Dm
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=3Dm
CONFIG_HVC_DRIVER=3Dy
CONFIG_HVC_IRQ=3Dy
CONFIG_HVC_XEN=3Dy
CONFIG_VIRTIO_CONSOLE=3Dm
CONFIG_IPMI_HANDLER=3Dm
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=3Dm
CONFIG_IPMI_SI=3Dm
CONFIG_IPMI_WATCHDOG=3Dm
CONFIG_IPMI_POWEROFF=3Dm
CONFIG_HW_RANDOM=3Dm
CONFIG_HW_RANDOM_TIMERIOMEM=3Dm
CONFIG_HW_RANDOM_INTEL=3Dm
CONFIG_HW_RANDOM_AMD=3Dm
CONFIG_HW_RANDOM_VIA=3Dm
CONFIG_HW_RANDOM_VIRTIO=3Dm
CONFIG_NVRAM=3Dm
CONFIG_R3964=3Dm
CONFIG_APPLICOM=3Dm

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=3Dm
CONFIG_CARDMAN_4000=3Dm
CONFIG_CARDMAN_4040=3Dm
CONFIG_IPWIRELESS=3Dm
CONFIG_MWAVE=3Dm
CONFIG_PC8736x_GPIO=3Dm
CONFIG_NSC_GPIO=3Dm
CONFIG_RAW_DRIVER=3Dm
CONFIG_MAX_RAW_DEVS=3D256
CONFIG_HPET=3Dy
CONFIG_HPET_MMAP=3Dy
CONFIG_HANGCHECK_TIMER=3Dm
CONFIG_TCG_TPM=3Dm
CONFIG_TCG_TIS=3Dm
CONFIG_TCG_NSC=3Dm
CONFIG_TCG_ATMEL=3Dm
CONFIG_TCG_INFINEON=3Dm
CONFIG_TELCLOCK=3Dm
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dm
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_COMPAT=3Dy
CONFIG_I2C_CHARDEV=3Dm
CONFIG_I2C_HELPER_AUTO=3Dy
CONFIG_I2C_ALGOBIT=3Dm
CONFIG_I2C_ALGOPCA=3Dm

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=3Dm
CONFIG_I2C_ALI1563=3Dm
CONFIG_I2C_ALI15X3=3Dm
CONFIG_I2C_AMD756=3Dm
CONFIG_I2C_AMD756_S4882=3Dm
CONFIG_I2C_AMD8111=3Dm
CONFIG_I2C_I801=3Dm
CONFIG_I2C_ISCH=3Dm
CONFIG_I2C_PIIX4=3Dm
CONFIG_I2C_NFORCE2=3Dm
CONFIG_I2C_NFORCE2_S4985=3Dm
CONFIG_I2C_SIS5595=3Dm
CONFIG_I2C_SIS630=3Dm
CONFIG_I2C_SIS96X=3Dm
CONFIG_I2C_VIA=3Dm
CONFIG_I2C_VIAPRO=3Dm

#
# ACPI drivers
#
CONFIG_I2C_SCMI=3Dm

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_OCORES=3Dm
CONFIG_I2C_SIMTEC=3Dm

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=3Dm
CONFIG_I2C_PARPORT_LIGHT=3Dm
CONFIG_I2C_TAOS_EVM=3Dm
CONFIG_I2C_TINY_USB=3Dm

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=3Dm

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=3Dm
CONFIG_I2C_STUB=3Dm

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=3Dm
CONFIG_SENSORS_TSL2550=3Dm
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=3Dy
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=3Dy

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=3Dm
CONFIG_SPI_BUTTERFLY=3Dm
CONFIG_SPI_LM70_LLP=3Dm

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=3Dm

#
# PPS support
#
CONFIG_PPS=3Dm
# CONFIG_PPS_DEBUG is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
# CONFIG_GPIOLIB is not set
CONFIG_W1=3Dm
CONFIG_W1_CON=3Dy

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=3Dm
CONFIG_W1_MASTER_DS2490=3Dm
CONFIG_W1_MASTER_DS2482=3Dm

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=3Dm
CONFIG_W1_SLAVE_SMEM=3Dm
CONFIG_W1_SLAVE_DS2431=3Dm
CONFIG_W1_SLAVE_DS2433=3Dm
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=3Dm
CONFIG_W1_SLAVE_BQ27000=3Dm
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=3Dm
CONFIG_WM831X_POWER=3Dm
CONFIG_WM8350_POWER=3Dm
CONFIG_BATTERY_DS2760=3Dm
CONFIG_BATTERY_DS2782=3Dm
CONFIG_BATTERY_BQ27x00=3Dm
CONFIG_BATTERY_MAX17040=3Dm
CONFIG_CHARGER_PCF50633=3Dm
CONFIG_HWMON=3Dy
CONFIG_HWMON_VID=3Dm
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=3Dm
CONFIG_SENSORS_ABITUGURU3=3Dm
CONFIG_SENSORS_AD7414=3Dm
CONFIG_SENSORS_AD7418=3Dm
CONFIG_SENSORS_ADCXX=3Dm
CONFIG_SENSORS_ADM1021=3Dm
CONFIG_SENSORS_ADM1025=3Dm
CONFIG_SENSORS_ADM1026=3Dm
CONFIG_SENSORS_ADM1029=3Dm
CONFIG_SENSORS_ADM1031=3Dm
CONFIG_SENSORS_ADM9240=3Dm
CONFIG_SENSORS_ADT7462=3Dm
CONFIG_SENSORS_ADT7470=3Dm
CONFIG_SENSORS_ADT7473=3Dm
CONFIG_SENSORS_ADT7475=3Dm
CONFIG_SENSORS_K8TEMP=3Dm
CONFIG_SENSORS_ASB100=3Dm
CONFIG_SENSORS_ATXP1=3Dm
CONFIG_SENSORS_DS1621=3Dm
CONFIG_SENSORS_I5K_AMB=3Dm
CONFIG_SENSORS_F71805F=3Dm
CONFIG_SENSORS_F71882FG=3Dm
CONFIG_SENSORS_F75375S=3Dm
CONFIG_SENSORS_FSCHMD=3Dm
CONFIG_SENSORS_G760A=3Dm
CONFIG_SENSORS_GL518SM=3Dm
CONFIG_SENSORS_GL520SM=3Dm
CONFIG_SENSORS_CORETEMP=3Dm
CONFIG_SENSORS_IBMAEM=3Dm
CONFIG_SENSORS_IBMPEX=3Dm
CONFIG_SENSORS_IT87=3Dm
CONFIG_SENSORS_LM63=3Dm
CONFIG_SENSORS_LM70=3Dm
CONFIG_SENSORS_LM75=3Dm
CONFIG_SENSORS_LM77=3Dm
CONFIG_SENSORS_LM78=3Dm
CONFIG_SENSORS_LM80=3Dm
CONFIG_SENSORS_LM83=3Dm
CONFIG_SENSORS_LM85=3Dm
CONFIG_SENSORS_LM87=3Dm
CONFIG_SENSORS_LM90=3Dm
CONFIG_SENSORS_LM92=3Dm
CONFIG_SENSORS_LM93=3Dm
CONFIG_SENSORS_LTC4215=3Dm
CONFIG_SENSORS_LTC4245=3Dm
CONFIG_SENSORS_LM95241=3Dm
CONFIG_SENSORS_MAX1111=3Dm
CONFIG_SENSORS_MAX1619=3Dm
CONFIG_SENSORS_MAX6650=3Dm
CONFIG_SENSORS_PC87360=3Dm
CONFIG_SENSORS_PC87427=3Dm
CONFIG_SENSORS_PCF8591=3Dm
CONFIG_SENSORS_SIS5595=3Dm
CONFIG_SENSORS_DME1737=3Dm
CONFIG_SENSORS_SMSC47M1=3Dm
CONFIG_SENSORS_SMSC47M192=3Dm
CONFIG_SENSORS_SMSC47B397=3Dm
CONFIG_SENSORS_ADS7828=3Dm
CONFIG_SENSORS_THMC50=3Dm
CONFIG_SENSORS_TMP401=3Dm
CONFIG_SENSORS_TMP421=3Dm
CONFIG_SENSORS_VIA_CPUTEMP=3Dm
CONFIG_SENSORS_VIA686A=3Dm
CONFIG_SENSORS_VT1211=3Dm
CONFIG_SENSORS_VT8231=3Dm
CONFIG_SENSORS_W83781D=3Dm
CONFIG_SENSORS_W83791D=3Dm
CONFIG_SENSORS_W83792D=3Dm
CONFIG_SENSORS_W83793=3Dm
CONFIG_SENSORS_W83L785TS=3Dm
CONFIG_SENSORS_W83L786NG=3Dm
CONFIG_SENSORS_W83627HF=3Dm
CONFIG_SENSORS_W83627EHF=3Dm
CONFIG_SENSORS_WM831X=3Dm
CONFIG_SENSORS_WM8350=3Dm
CONFIG_SENSORS_HDAPS=3Dm
CONFIG_SENSORS_APPLESMC=3Dm

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=3Dm
CONFIG_SENSORS_LIS3LV02D=3Dm
CONFIG_THERMAL=3Dm
CONFIG_THERMAL_HWMON=3Dy
CONFIG_WATCHDOG=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=3Dm
CONFIG_WM831X_WATCHDOG=3Dm
CONFIG_WM8350_WATCHDOG=3Dm
CONFIG_ACQUIRE_WDT=3Dm
CONFIG_ADVANTECH_WDT=3Dm
CONFIG_ALIM1535_WDT=3Dm
CONFIG_ALIM7101_WDT=3Dm
CONFIG_SC520_WDT=3Dm
CONFIG_SBC_FITPC2_WATCHDOG=3Dm
CONFIG_EUROTECH_WDT=3Dm
CONFIG_IB700_WDT=3Dm
CONFIG_IBMASR=3Dm
CONFIG_WAFER_WDT=3Dm
CONFIG_I6300ESB_WDT=3Dm
CONFIG_ITCO_WDT=3Dm
CONFIG_ITCO_VENDOR_SUPPORT=3Dy
CONFIG_IT8712F_WDT=3Dm
CONFIG_IT87_WDT=3Dm
CONFIG_HP_WATCHDOG=3Dm
CONFIG_SC1200_WDT=3Dm
CONFIG_PC87413_WDT=3Dm
CONFIG_60XX_WDT=3Dm
CONFIG_SBC8360_WDT=3Dm
CONFIG_CPU5_WDT=3Dm
CONFIG_SMSC_SCH311X_WDT=3Dm
CONFIG_SMSC37B787_WDT=3Dm
CONFIG_W83627HF_WDT=3Dm
CONFIG_W83697HF_WDT=3Dm
CONFIG_W83697UG_WDT=3Dm
CONFIG_W83877F_WDT=3Dm
CONFIG_W83977F_WDT=3Dm
CONFIG_MACHZ_WDT=3Dm
CONFIG_SBC_EPX_C3_WATCHDOG=3Dm

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=3Dm
CONFIG_WDTPCI=3Dm

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=3Dm
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
CONFIG_SSB=3Dm
CONFIG_SSB_SPROM=3Dy
CONFIG_SSB_BLOCKIO=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
CONFIG_SSB_B43_PCI_BRIDGE=3Dy
CONFIG_SSB_PCMCIAHOST_POSSIBLE=3Dy
CONFIG_SSB_PCMCIAHOST=3Dy
CONFIG_SSB_SDIOHOST_POSSIBLE=3Dy
CONFIG_SSB_SDIOHOST=3Dy
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=3Dm
CONFIG_MFD_SM501=3Dm
CONFIG_HTC_PASIC3=3Dm
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_WM8400=3Dm
CONFIG_MFD_WM831X=3Dm
CONFIG_MFD_WM8350=3Dm
CONFIG_MFD_WM8350_I2C=3Dm
CONFIG_MFD_PCF50633=3Dm
CONFIG_MFD_MC13783=3Dm
CONFIG_PCF50633_ADC=3Dm
CONFIG_PCF50633_GPIO=3Dm
CONFIG_AB3100_CORE=3Dm
CONFIG_AB3100_OTP=3Dm
# CONFIG_EZX_PCAP is not set
CONFIG_REGULATOR=3Dy
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=3Dm
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=3Dm
CONFIG_REGULATOR_BQ24022=3Dm
CONFIG_REGULATOR_MAX1586=3Dm
CONFIG_REGULATOR_WM831X=3Dm
CONFIG_REGULATOR_WM8350=3Dm
CONFIG_REGULATOR_WM8400=3Dm
CONFIG_REGULATOR_PCF50633=3Dm
CONFIG_REGULATOR_LP3971=3Dm
CONFIG_REGULATOR_MC13783=3Dm
CONFIG_REGULATOR_AB3100=3Dm
CONFIG_REGULATOR_TPS65023=3Dm
CONFIG_REGULATOR_TPS6507X=3Dm
CONFIG_MEDIA_SUPPORT=3Dm

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=3Dm
CONFIG_VIDEO_V4L2_COMMON=3Dm
CONFIG_VIDEO_ALLOW_V4L1=3Dy
CONFIG_VIDEO_V4L1_COMPAT=3Dy
CONFIG_DVB_CORE=3Dm
CONFIG_VIDEO_MEDIA=3Dm

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=3Dm
CONFIG_VIDEO_SAA7146_VV=3Dm
CONFIG_MEDIA_ATTACH=3Dy
CONFIG_MEDIA_TUNER=3Dm
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=3Dm
CONFIG_MEDIA_TUNER_TDA8290=3Dm
CONFIG_MEDIA_TUNER_TDA827X=3Dm
CONFIG_MEDIA_TUNER_TDA18271=3Dm
CONFIG_MEDIA_TUNER_TDA9887=3Dm
CONFIG_MEDIA_TUNER_TEA5761=3Dm
CONFIG_MEDIA_TUNER_TEA5767=3Dm
CONFIG_MEDIA_TUNER_MT20XX=3Dm
CONFIG_MEDIA_TUNER_MT2060=3Dm
CONFIG_MEDIA_TUNER_MT2266=3Dm
CONFIG_MEDIA_TUNER_MT2131=3Dm
CONFIG_MEDIA_TUNER_QT1010=3Dm
CONFIG_MEDIA_TUNER_XC2028=3Dm
CONFIG_MEDIA_TUNER_XC5000=3Dm
CONFIG_MEDIA_TUNER_MXL5005S=3Dm
CONFIG_MEDIA_TUNER_MXL5007T=3Dm
CONFIG_MEDIA_TUNER_MC44S803=3Dm
CONFIG_VIDEO_V4L2=3Dm
CONFIG_VIDEO_V4L1=3Dm
CONFIG_VIDEOBUF_GEN=3Dm
CONFIG_VIDEOBUF_DMA_SG=3Dm
CONFIG_VIDEOBUF_VMALLOC=3Dm
CONFIG_VIDEOBUF_DVB=3Dm
CONFIG_VIDEO_BTCX=3Dm
CONFIG_VIDEO_IR=3Dm
CONFIG_VIDEO_TVEEPROM=3Dm
CONFIG_VIDEO_TUNER=3Dm
CONFIG_VIDEO_CAPTURE_DRIVERS=3Dy
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=3Dy
CONFIG_VIDEO_IR_I2C=3Dm
CONFIG_VIDEO_TVAUDIO=3Dm
CONFIG_VIDEO_TDA7432=3Dm
CONFIG_VIDEO_TDA9840=3Dm
CONFIG_VIDEO_TEA6415C=3Dm
CONFIG_VIDEO_TEA6420=3Dm
CONFIG_VIDEO_MSP3400=3Dm
CONFIG_VIDEO_CS5345=3Dm
CONFIG_VIDEO_CS53L32A=3Dm
CONFIG_VIDEO_M52790=3Dm
CONFIG_VIDEO_WM8775=3Dm
CONFIG_VIDEO_WM8739=3Dm
CONFIG_VIDEO_VP27SMPX=3Dm
CONFIG_VIDEO_SAA6588=3Dm
CONFIG_VIDEO_BT819=3Dm
CONFIG_VIDEO_BT856=3Dm
CONFIG_VIDEO_BT866=3Dm
CONFIG_VIDEO_KS0127=3Dm
CONFIG_VIDEO_OV7670=3Dm
CONFIG_VIDEO_MT9V011=3Dm
CONFIG_VIDEO_SAA7110=3Dm
CONFIG_VIDEO_SAA711X=3Dm
CONFIG_VIDEO_SAA717X=3Dm
CONFIG_VIDEO_TVP5150=3Dm
CONFIG_VIDEO_VPX3220=3Dm
CONFIG_VIDEO_CX25840=3Dm
CONFIG_VIDEO_CX2341X=3Dm
CONFIG_VIDEO_SAA7127=3Dm
CONFIG_VIDEO_SAA7185=3Dm
CONFIG_VIDEO_ADV7170=3Dm
CONFIG_VIDEO_ADV7175=3Dm
CONFIG_VIDEO_UPD64031A=3Dm
CONFIG_VIDEO_UPD64083=3Dm
CONFIG_VIDEO_VIVI=3Dm
CONFIG_VIDEO_BT848=3Dm
CONFIG_VIDEO_BT848_DVB=3Dy
CONFIG_VIDEO_BWQCAM=3Dm
CONFIG_VIDEO_CQCAM=3Dm
CONFIG_VIDEO_W9966=3Dm
CONFIG_VIDEO_CPIA=3Dm
CONFIG_VIDEO_CPIA_PP=3Dm
CONFIG_VIDEO_CPIA_USB=3Dm
CONFIG_VIDEO_CPIA2=3Dm
CONFIG_VIDEO_SAA5246A=3Dm
CONFIG_VIDEO_SAA5249=3Dm
CONFIG_VIDEO_STRADIS=3Dm
CONFIG_VIDEO_ZORAN=3Dm
CONFIG_VIDEO_ZORAN_DC30=3Dm
CONFIG_VIDEO_ZORAN_ZR36060=3Dm
CONFIG_VIDEO_ZORAN_BUZ=3Dm
CONFIG_VIDEO_ZORAN_DC10=3Dm
CONFIG_VIDEO_ZORAN_LML33=3Dm
CONFIG_VIDEO_ZORAN_LML33R10=3Dm
CONFIG_VIDEO_ZORAN_AVS6EYES=3Dm
CONFIG_VIDEO_MEYE=3Dm
CONFIG_VIDEO_SAA7134=3Dm
CONFIG_VIDEO_SAA7134_ALSA=3Dm
CONFIG_VIDEO_SAA7134_DVB=3Dm
CONFIG_VIDEO_MXB=3Dm
CONFIG_VIDEO_HEXIUM_ORION=3Dm
CONFIG_VIDEO_HEXIUM_GEMINI=3Dm
CONFIG_VIDEO_CX88=3Dm
CONFIG_VIDEO_CX88_ALSA=3Dm
CONFIG_VIDEO_CX88_BLACKBIRD=3Dm
CONFIG_VIDEO_CX88_DVB=3Dm
CONFIG_VIDEO_CX88_MPEG=3Dm
CONFIG_VIDEO_CX88_VP3054=3Dm
CONFIG_VIDEO_CX23885=3Dm
CONFIG_VIDEO_AU0828=3Dm
CONFIG_VIDEO_IVTV=3Dm
CONFIG_VIDEO_FB_IVTV=3Dm
CONFIG_VIDEO_CX18=3Dm
CONFIG_VIDEO_SAA7164=3Dm
CONFIG_VIDEO_CAFE_CCIC=3Dm
CONFIG_SOC_CAMERA=3Dm
CONFIG_SOC_CAMERA_MT9M001=3Dm
CONFIG_SOC_CAMERA_MT9M111=3Dm
CONFIG_SOC_CAMERA_MT9T031=3Dm
CONFIG_SOC_CAMERA_MT9V022=3Dm
CONFIG_SOC_CAMERA_TW9910=3Dm
CONFIG_SOC_CAMERA_PLATFORM=3Dm
CONFIG_SOC_CAMERA_OV772X=3Dm
CONFIG_V4L_USB_DRIVERS=3Dy
CONFIG_USB_VIDEO_CLASS=3Dm
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=3Dy
CONFIG_USB_GSPCA=3Dm
CONFIG_USB_M5602=3Dm
CONFIG_USB_STV06XX=3Dm
CONFIG_USB_GL860=3Dm
CONFIG_USB_GSPCA_CONEX=3Dm
CONFIG_USB_GSPCA_ETOMS=3Dm
CONFIG_USB_GSPCA_FINEPIX=3Dm
CONFIG_USB_GSPCA_JEILINJ=3Dm
CONFIG_USB_GSPCA_MARS=3Dm
CONFIG_USB_GSPCA_MR97310A=3Dm
CONFIG_USB_GSPCA_OV519=3Dm
CONFIG_USB_GSPCA_OV534=3Dm
CONFIG_USB_GSPCA_PAC207=3Dm
CONFIG_USB_GSPCA_PAC7311=3Dm
CONFIG_USB_GSPCA_SN9C20X=3Dm
CONFIG_USB_GSPCA_SN9C20X_EVDEV=3Dy
CONFIG_USB_GSPCA_SONIXB=3Dm
CONFIG_USB_GSPCA_SONIXJ=3Dm
CONFIG_USB_GSPCA_SPCA500=3Dm
CONFIG_USB_GSPCA_SPCA501=3Dm
CONFIG_USB_GSPCA_SPCA505=3Dm
CONFIG_USB_GSPCA_SPCA506=3Dm
CONFIG_USB_GSPCA_SPCA508=3Dm
CONFIG_USB_GSPCA_SPCA561=3Dm
CONFIG_USB_GSPCA_SQ905=3Dm
CONFIG_USB_GSPCA_SQ905C=3Dm
CONFIG_USB_GSPCA_STK014=3Dm
CONFIG_USB_GSPCA_SUNPLUS=3Dm
CONFIG_USB_GSPCA_T613=3Dm
CONFIG_USB_GSPCA_TV8532=3Dm
CONFIG_USB_GSPCA_VC032X=3Dm
CONFIG_USB_GSPCA_ZC3XX=3Dm
CONFIG_VIDEO_PVRUSB2=3Dm
CONFIG_VIDEO_PVRUSB2_SYSFS=3Dy
CONFIG_VIDEO_PVRUSB2_DVB=3Dy
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=3Dm
CONFIG_VIDEO_EM28XX=3Dm
CONFIG_VIDEO_EM28XX_ALSA=3Dm
CONFIG_VIDEO_EM28XX_DVB=3Dm
CONFIG_VIDEO_CX231XX=3Dm
CONFIG_VIDEO_CX231XX_ALSA=3Dm
CONFIG_VIDEO_CX231XX_DVB=3Dm
CONFIG_VIDEO_USBVISION=3Dm
CONFIG_VIDEO_USBVIDEO=3Dm
CONFIG_USB_VICAM=3Dm
CONFIG_USB_IBMCAM=3Dm
CONFIG_USB_KONICAWC=3Dm
# CONFIG_USB_QUICKCAM_MESSENGER is not set
CONFIG_USB_ET61X251=3Dm
CONFIG_VIDEO_OVCAMCHIP=3Dm
CONFIG_USB_W9968CF=3Dm
# CONFIG_USB_OV511 is not set
CONFIG_USB_SE401=3Dm
CONFIG_USB_SN9C102=3Dm
CONFIG_USB_STV680=3Dm
CONFIG_USB_ZC0301=3Dm
CONFIG_USB_PWC=3Dm
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=3Dy
CONFIG_USB_ZR364XX=3Dm
CONFIG_USB_STKWEBCAM=3Dm
CONFIG_USB_S2255=3Dm
CONFIG_RADIO_ADAPTERS=3Dy
CONFIG_RADIO_GEMTEK_PCI=3Dm
CONFIG_RADIO_MAXIRADIO=3Dm
CONFIG_RADIO_MAESTRO=3Dm
CONFIG_I2C_SI4713=3Dm
CONFIG_RADIO_SI4713=3Dm
CONFIG_USB_DSBR=3Dm
CONFIG_RADIO_SI470X=3Dy
CONFIG_USB_SI470X=3Dm
CONFIG_I2C_SI470X=3Dm
CONFIG_USB_MR800=3Dm
CONFIG_RADIO_TEA5764=3Dm
CONFIG_DVB_MAX_ADAPTERS=3D8
CONFIG_DVB_DYNAMIC_MINORS=3Dy
CONFIG_DVB_CAPTURE_DRIVERS=3Dy

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=3Dm
CONFIG_DVB_AV7110=3Dm
CONFIG_DVB_AV7110_OSD=3Dy
CONFIG_DVB_BUDGET_CORE=3Dm
CONFIG_DVB_BUDGET=3Dm
CONFIG_DVB_BUDGET_CI=3Dm
CONFIG_DVB_BUDGET_AV=3Dm
CONFIG_DVB_BUDGET_PATCH=3Dm

#
# Supported USB Adapters
#
CONFIG_DVB_USB=3Dm
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=3Dm
CONFIG_DVB_USB_DIBUSB_MB=3Dm
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=3Dy
CONFIG_DVB_USB_DIBUSB_MC=3Dm
CONFIG_DVB_USB_DIB0700=3Dm
CONFIG_DVB_USB_UMT_010=3Dm
CONFIG_DVB_USB_CXUSB=3Dm
CONFIG_DVB_USB_M920X=3Dm
CONFIG_DVB_USB_GL861=3Dm
CONFIG_DVB_USB_AU6610=3Dm
CONFIG_DVB_USB_DIGITV=3Dm
CONFIG_DVB_USB_VP7045=3Dm
CONFIG_DVB_USB_VP702X=3Dm
CONFIG_DVB_USB_GP8PSK=3Dm
CONFIG_DVB_USB_NOVA_T_USB2=3Dm
CONFIG_DVB_USB_TTUSB2=3Dm
CONFIG_DVB_USB_DTT200U=3Dm
CONFIG_DVB_USB_OPERA1=3Dm
CONFIG_DVB_USB_AF9005=3Dm
CONFIG_DVB_USB_AF9005_REMOTE=3Dm
CONFIG_DVB_USB_DW2102=3Dm
CONFIG_DVB_USB_CINERGY_T2=3Dm
CONFIG_DVB_USB_ANYSEE=3Dm
CONFIG_DVB_USB_DTV5100=3Dm
CONFIG_DVB_USB_AF9015=3Dm
CONFIG_DVB_USB_CE6230=3Dm
CONFIG_DVB_USB_FRIIO=3Dm
CONFIG_DVB_TTUSB_BUDGET=3Dm
CONFIG_DVB_TTUSB_DEC=3Dm
CONFIG_SMS_SIANO_MDTV=3Dm

#
# Siano module components
#
CONFIG_SMS_USB_DRV=3Dm
CONFIG_SMS_SDIO_DRV=3Dm

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=3Dm
CONFIG_DVB_B2C2_FLEXCOP_PCI=3Dm
CONFIG_DVB_B2C2_FLEXCOP_USB=3Dm
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=3Dm

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=3Dm

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=3Dm

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=3Dm

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_STB0899=3Dm
CONFIG_DVB_STB6100=3Dm
CONFIG_DVB_CX24110=3Dm
CONFIG_DVB_CX24123=3Dm
CONFIG_DVB_MT312=3Dm
CONFIG_DVB_ZL10036=3Dm
CONFIG_DVB_ZL10039=3Dm
CONFIG_DVB_S5H1420=3Dm
CONFIG_DVB_STV0288=3Dm
CONFIG_DVB_STB6000=3Dm
CONFIG_DVB_STV0299=3Dm
CONFIG_DVB_STV6110=3Dm
CONFIG_DVB_STV0900=3Dm
CONFIG_DVB_TDA8083=3Dm
CONFIG_DVB_TDA10086=3Dm
CONFIG_DVB_TDA8261=3Dm
CONFIG_DVB_VES1X93=3Dm
CONFIG_DVB_TUNER_ITD1000=3Dm
CONFIG_DVB_TUNER_CX24113=3Dm
CONFIG_DVB_TDA826X=3Dm
CONFIG_DVB_TUA6100=3Dm
CONFIG_DVB_CX24116=3Dm
CONFIG_DVB_SI21XX=3Dm
CONFIG_DVB_SP8870=3Dm
CONFIG_DVB_SP887X=3Dm
CONFIG_DVB_CX22700=3Dm
CONFIG_DVB_CX22702=3Dm
CONFIG_DVB_L64781=3Dm
CONFIG_DVB_TDA1004X=3Dm
CONFIG_DVB_NXT6000=3Dm
CONFIG_DVB_MT352=3Dm
CONFIG_DVB_ZL10353=3Dm
CONFIG_DVB_DIB3000MB=3Dm
CONFIG_DVB_DIB3000MC=3Dm
CONFIG_DVB_DIB7000M=3Dm
CONFIG_DVB_DIB7000P=3Dm
CONFIG_DVB_TDA10048=3Dm
CONFIG_DVB_AF9013=3Dm
CONFIG_DVB_VES1820=3Dm
CONFIG_DVB_TDA10021=3Dm
CONFIG_DVB_TDA10023=3Dm
CONFIG_DVB_STV0297=3Dm
CONFIG_DVB_NXT200X=3Dm
CONFIG_DVB_OR51211=3Dm
CONFIG_DVB_OR51132=3Dm
CONFIG_DVB_BCM3510=3Dm
CONFIG_DVB_LGDT330X=3Dm
CONFIG_DVB_LGDT3305=3Dm
CONFIG_DVB_S5H1409=3Dm
CONFIG_DVB_AU8522=3Dm
CONFIG_DVB_S5H1411=3Dm
CONFIG_DVB_DIB8000=3Dm
CONFIG_DVB_PLL=3Dm
CONFIG_DVB_TUNER_DIB0070=3Dm
CONFIG_DVB_LNBP21=3Dm
CONFIG_DVB_ISL6405=3Dm
CONFIG_DVB_ISL6421=3Dm
CONFIG_DVB_LGS8GXX=3Dm
CONFIG_DAB=3Dy
CONFIG_USB_DABUSB=3Dm

#
# Graphics support
#
CONFIG_AGP=3Dy
CONFIG_AGP_AMD64=3Dy
CONFIG_AGP_INTEL=3Dm
CONFIG_AGP_SIS=3Dm
CONFIG_AGP_VIA=3Dm
CONFIG_VGA_ARB=3Dy
CONFIG_DRM=3Dm
CONFIG_DRM_KMS_HELPER=3Dm
CONFIG_DRM_TTM=3Dm
CONFIG_DRM_TDFX=3Dm
CONFIG_DRM_R128=3Dm
CONFIG_DRM_RADEON=3Dm
CONFIG_DRM_I810=3Dm
CONFIG_DRM_I830=3Dm
CONFIG_DRM_I915=3Dm
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_MGA=3Dm
CONFIG_DRM_SIS=3Dm
CONFIG_DRM_VIA=3Dm
CONFIG_DRM_SAVAGE=3Dm
CONFIG_VGASTATE=3Dm
CONFIG_VIDEO_OUTPUT_CONTROL=3Dm
CONFIG_FB=3Dy
CONFIG_FIRMWARE_EDID=3Dy
CONFIG_FB_DDC=3Dm
CONFIG_FB_BOOT_VESA_SUPPORT=3Dy
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=3Dy
CONFIG_FB_SYS_COPYAREA=3Dy
CONFIG_FB_SYS_IMAGEBLIT=3Dy
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=3Dy
CONFIG_FB_DEFERRED_IO=3Dy
CONFIG_FB_HECUBA=3Dm
CONFIG_FB_SVGALIB=3Dm
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=3Dy
CONFIG_FB_MODE_HELPERS=3Dy
CONFIG_FB_TILEBLITTING=3Dy

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=3Dm
CONFIG_FB_PM2=3Dm
CONFIG_FB_PM2_FIFO_DISCONNECT=3Dy
CONFIG_FB_CYBER2000=3Dm
CONFIG_FB_ARC=3Dm
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=3Dm
CONFIG_FB_UVESA=3Dm
CONFIG_FB_VESA=3Dy
CONFIG_FB_EFI=3Dy
CONFIG_FB_N411=3Dm
CONFIG_FB_HGA=3Dm
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=3Dm
CONFIG_FB_NVIDIA=3Dm
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=3Dy
# CONFIG_FB_RIVA is not set
CONFIG_FB_LE80578=3Dm
CONFIG_FB_CARILLO_RANCH=3Dm
CONFIG_FB_MATROX=3Dm
CONFIG_FB_MATROX_MILLENIUM=3Dy
CONFIG_FB_MATROX_MYSTIQUE=3Dy
CONFIG_FB_MATROX_G=3Dy
CONFIG_FB_MATROX_I2C=3Dm
CONFIG_FB_MATROX_MAVEN=3Dm
CONFIG_FB_RADEON=3Dm
CONFIG_FB_RADEON_I2C=3Dy
CONFIG_FB_RADEON_BACKLIGHT=3Dy
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=3Dm
CONFIG_FB_ATY128_BACKLIGHT=3Dy
CONFIG_FB_ATY=3Dm
CONFIG_FB_ATY_CT=3Dy
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=3Dy
CONFIG_FB_ATY_BACKLIGHT=3Dy
CONFIG_FB_S3=3Dm
CONFIG_FB_SAVAGE=3Dm
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=3Dm
CONFIG_FB_SIS_300=3Dy
CONFIG_FB_SIS_315=3Dy
CONFIG_FB_VIA=3Dm
CONFIG_FB_NEOMAGIC=3Dm
CONFIG_FB_KYRO=3Dm
CONFIG_FB_3DFX=3Dm
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=3Dy
CONFIG_FB_VOODOO1=3Dm
CONFIG_FB_VT8623=3Dm
CONFIG_FB_TRIDENT=3Dm
CONFIG_FB_ARK=3Dm
CONFIG_FB_PM3=3Dm
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=3Dm
CONFIG_FB_VIRTUAL=3Dm
CONFIG_XEN_FBDEV_FRONTEND=3Dy
CONFIG_FB_METRONOME=3Dm
CONFIG_FB_MB862XX=3Dm
CONFIG_FB_MB862XX_PCI_GDC=3Dy
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PROGEAR=3Dm
CONFIG_BACKLIGHT_MBP_NVIDIA=3Dm
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=3Dm

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=3Dm

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=3Dy
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
# CONFIG_LOGO is not set
CONFIG_SOUND=3Dm
CONFIG_SOUND_OSS_CORE=3Dy
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=3Dm
CONFIG_SND_TIMER=3Dm
CONFIG_SND_PCM=3Dm
CONFIG_SND_HWDEP=3Dm
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_JACK=3Dy
CONFIG_SND_SEQUENCER=3Dm
CONFIG_SND_SEQ_DUMMY=3Dm
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dm
CONFIG_SND_PCM_OSS=3Dm
CONFIG_SND_PCM_OSS_PLUGINS=3Dy
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=3Dm
CONFIG_SND_SEQ_HRTIMER_DEFAULT=3Dy
CONFIG_SND_DYNAMIC_MINORS=3Dy
CONFIG_SND_SUPPORT_OLD_API=3Dy
CONFIG_SND_VERBOSE_PROCFS=3Dy
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=3Dy
CONFIG_SND_DMA_SGBUF=3Dy
CONFIG_SND_RAWMIDI_SEQ=3Dm
CONFIG_SND_OPL3_LIB_SEQ=3Dm
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=3Dm
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_OPL3_LIB=3Dm
CONFIG_SND_VX_LIB=3Dm
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_SND_DRIVERS=3Dy
CONFIG_SND_PCSP=3Dm
CONFIG_SND_DUMMY=3Dm
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
CONFIG_SND_MTS64=3Dm
CONFIG_SND_SERIAL_U16550=3Dm
CONFIG_SND_MPU401=3Dm
CONFIG_SND_PORTMAN2X4=3Dm
CONFIG_SND_AC97_POWER_SAVE=3Dy
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=3D0
CONFIG_SND_SB_COMMON=3Dm
CONFIG_SND_SB16_DSP=3Dm
CONFIG_SND_PCI=3Dy
CONFIG_SND_AD1889=3Dm
CONFIG_SND_ALS300=3Dm
CONFIG_SND_ALS4000=3Dm
CONFIG_SND_ALI5451=3Dm
CONFIG_SND_ATIIXP=3Dm
CONFIG_SND_ATIIXP_MODEM=3Dm
CONFIG_SND_AU8810=3Dm
CONFIG_SND_AU8820=3Dm
CONFIG_SND_AU8830=3Dm
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=3Dm
CONFIG_SND_BT87X=3Dm
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=3Dm
CONFIG_SND_CMIPCI=3Dm
CONFIG_SND_OXYGEN_LIB=3Dm
CONFIG_SND_OXYGEN=3Dm
CONFIG_SND_CS4281=3Dm
CONFIG_SND_CS46XX=3Dm
CONFIG_SND_CS5530=3Dm
CONFIG_SND_CS5535AUDIO=3Dm
CONFIG_SND_CTXFI=3Dm
CONFIG_SND_DARLA20=3Dm
CONFIG_SND_GINA20=3Dm
CONFIG_SND_LAYLA20=3Dm
CONFIG_SND_DARLA24=3Dm
CONFIG_SND_GINA24=3Dm
CONFIG_SND_LAYLA24=3Dm
CONFIG_SND_MONA=3Dm
CONFIG_SND_MIA=3Dm
CONFIG_SND_ECHO3G=3Dm
CONFIG_SND_INDIGO=3Dm
CONFIG_SND_INDIGOIO=3Dm
CONFIG_SND_INDIGODJ=3Dm
CONFIG_SND_INDIGOIOX=3Dm
CONFIG_SND_INDIGODJX=3Dm
CONFIG_SND_EMU10K1=3Dm
CONFIG_SND_EMU10K1X=3Dm
CONFIG_SND_ENS1370=3Dm
CONFIG_SND_ENS1371=3Dm
CONFIG_SND_ES1938=3Dm
CONFIG_SND_ES1968=3Dm
CONFIG_SND_FM801=3Dm
CONFIG_SND_FM801_TEA575X_BOOL=3Dy
CONFIG_SND_FM801_TEA575X=3Dm
CONFIG_SND_HDA_INTEL=3Dm
CONFIG_SND_HDA_HWDEP=3Dy
CONFIG_SND_HDA_RECONFIG=3Dy
CONFIG_SND_HDA_INPUT_BEEP=3Dy
CONFIG_SND_HDA_INPUT_JACK=3Dy
CONFIG_SND_HDA_PATCH_LOADER=3Dy
CONFIG_SND_HDA_CODEC_REALTEK=3Dy
CONFIG_SND_HDA_CODEC_ANALOG=3Dy
CONFIG_SND_HDA_CODEC_SIGMATEL=3Dy
CONFIG_SND_HDA_CODEC_VIA=3Dy
CONFIG_SND_HDA_CODEC_ATIHDMI=3Dy
CONFIG_SND_HDA_CODEC_NVHDMI=3Dy
CONFIG_SND_HDA_CODEC_INTELHDMI=3Dy
CONFIG_SND_HDA_ELD=3Dy
CONFIG_SND_HDA_CODEC_CIRRUS=3Dy
CONFIG_SND_HDA_CODEC_CONEXANT=3Dy
CONFIG_SND_HDA_CODEC_CA0110=3Dy
CONFIG_SND_HDA_CODEC_CMEDIA=3Dy
CONFIG_SND_HDA_CODEC_SI3054=3Dy
CONFIG_SND_HDA_GENERIC=3Dy
CONFIG_SND_HDA_POWER_SAVE=3Dy
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=3D0
CONFIG_SND_HDSP=3Dm
CONFIG_SND_HDSPM=3Dm
CONFIG_SND_HIFIER=3Dm
CONFIG_SND_ICE1712=3Dm
CONFIG_SND_ICE1724=3Dm
CONFIG_SND_INTEL8X0=3Dm
CONFIG_SND_INTEL8X0M=3Dm
CONFIG_SND_KORG1212=3Dm
CONFIG_SND_LX6464ES=3Dm
CONFIG_SND_MAESTRO3=3Dm
CONFIG_SND_MIXART=3Dm
CONFIG_SND_NM256=3Dm
CONFIG_SND_PCXHR=3Dm
CONFIG_SND_RIPTIDE=3Dm
CONFIG_SND_RME32=3Dm
CONFIG_SND_RME96=3Dm
CONFIG_SND_RME9652=3Dm
CONFIG_SND_SONICVIBES=3Dm
CONFIG_SND_TRIDENT=3Dm
CONFIG_SND_VIA82XX=3Dm
CONFIG_SND_VIA82XX_MODEM=3Dm
CONFIG_SND_VIRTUOSO=3Dm
CONFIG_SND_VX222=3Dm
CONFIG_SND_YMFPCI=3Dm
CONFIG_SND_SPI=3Dy
CONFIG_SND_USB=3Dy
CONFIG_SND_USB_AUDIO=3Dm
CONFIG_SND_USB_USX2Y=3Dm
CONFIG_SND_USB_CAIAQ=3Dm
CONFIG_SND_USB_CAIAQ_INPUT=3Dy
CONFIG_SND_USB_US122L=3Dm
CONFIG_SND_PCMCIA=3Dy
CONFIG_SND_VXPOCKET=3Dm
CONFIG_SND_PDAUDIOCF=3Dm
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dm
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dm
CONFIG_HIDRAW=3Dy

#
# USB Input Devices
#
CONFIG_USB_HID=3Dm
CONFIG_HID_PID=3Dy
CONFIG_USB_HIDDEV=3Dy

#
# Special HID drivers
#
CONFIG_HID_A4TECH=3Dm
CONFIG_HID_APPLE=3Dm
CONFIG_HID_BELKIN=3Dm
CONFIG_HID_CHERRY=3Dm
CONFIG_HID_CHICONY=3Dm
CONFIG_HID_CYPRESS=3Dm
CONFIG_HID_DRAGONRISE=3Dm
CONFIG_DRAGONRISE_FF=3Dy
CONFIG_HID_EZKEY=3Dm
CONFIG_HID_KYE=3Dm
CONFIG_HID_GYRATION=3Dm
CONFIG_HID_TWINHAN=3Dm
CONFIG_HID_KENSINGTON=3Dm
CONFIG_HID_LOGITECH=3Dm
CONFIG_LOGITECH_FF=3Dy
CONFIG_LOGIRUMBLEPAD2_FF=3Dy
CONFIG_HID_MICROSOFT=3Dm
CONFIG_HID_MONTEREY=3Dm
CONFIG_HID_NTRIG=3Dm
CONFIG_HID_PANTHERLORD=3Dm
CONFIG_PANTHERLORD_FF=3Dy
CONFIG_HID_PETALYNX=3Dm
CONFIG_HID_SAMSUNG=3Dm
CONFIG_HID_SONY=3Dm
CONFIG_HID_SUNPLUS=3Dm
CONFIG_HID_GREENASIA=3Dm
CONFIG_GREENASIA_FF=3Dy
CONFIG_HID_SMARTJOYPLUS=3Dm
CONFIG_SMARTJOYPLUS_FF=3Dy
CONFIG_HID_TOPSEED=3Dm
CONFIG_HID_THRUSTMASTER=3Dm
CONFIG_THRUSTMASTER_FF=3Dy
CONFIG_HID_WACOM=3Dm
CONFIG_HID_ZEROPLUS=3Dm
CONFIG_ZEROPLUS_FF=3Dy
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dm
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=3Dy

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=3Dy
CONFIG_USB_SUSPEND=3Dy
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=3Dm
CONFIG_USB_WUSB=3Dm
CONFIG_USB_WUSB_CBAF=3Dm
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=3Dm
CONFIG_USB_XHCI_HCD=3Dm
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=3Dm
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
CONFIG_USB_EHCI_TT_NEWSCHED=3Dy
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=3Dm
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=3Dm
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_UHCI_HCD=3Dm
CONFIG_USB_U132_HCD=3Dm
CONFIG_USB_SL811_HCD=3Dm
CONFIG_USB_SL811_CS=3Dm
CONFIG_USB_R8A66597_HCD=3Dm
CONFIG_USB_WHCI_HCD=3Dm
CONFIG_USB_HWA_HCD=3Dm

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm
CONFIG_USB_WDM=3Dm
CONFIG_USB_TMC=3Dm

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=3Dm
CONFIG_USB_STORAGE_FREECOM=3Dm
CONFIG_USB_STORAGE_ISD200=3Dm
CONFIG_USB_STORAGE_USBAT=3Dm
CONFIG_USB_STORAGE_SDDR09=3Dm
CONFIG_USB_STORAGE_SDDR55=3Dm
CONFIG_USB_STORAGE_JUMPSHOT=3Dm
CONFIG_USB_STORAGE_ALAUDA=3Dm
CONFIG_USB_STORAGE_ONETOUCH=3Dm
CONFIG_USB_STORAGE_KARMA=3Dm
CONFIG_USB_STORAGE_CYPRESS_ATACB=3Dm
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=3Dm
CONFIG_USB_MICROTEK=3Dm

#
# USB port drivers
#
CONFIG_USB_USS720=3Dm
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_EZUSB=3Dy
CONFIG_USB_SERIAL_GENERIC=3Dy
CONFIG_USB_SERIAL_AIRCABLE=3Dm
CONFIG_USB_SERIAL_ARK3116=3Dm
CONFIG_USB_SERIAL_BELKIN=3Dm
CONFIG_USB_SERIAL_CH341=3Dm
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
CONFIG_USB_SERIAL_CP210X=3Dm
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
CONFIG_USB_SERIAL_FUNSOFT=3Dm
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
CONFIG_USB_SERIAL_IUU=3Dm
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
CONFIG_USB_SERIAL_KEYSPAN=3Dm
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
CONFIG_USB_SERIAL_MOS7720=3Dm
CONFIG_USB_SERIAL_MOS7840=3Dm
CONFIG_USB_SERIAL_MOTOROLA=3Dm
CONFIG_USB_SERIAL_NAVMAN=3Dm
CONFIG_USB_SERIAL_PL2303=3Dm
CONFIG_USB_SERIAL_OTI6858=3Dm
CONFIG_USB_SERIAL_QUALCOMM=3Dm
CONFIG_USB_SERIAL_SPCP8X5=3Dm
CONFIG_USB_SERIAL_HP4X=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=3Dm
CONFIG_USB_SERIAL_SIERRAWIRELESS=3Dm
CONFIG_USB_SERIAL_SYMBOL=3Dm
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
CONFIG_USB_SERIAL_OPTION=3Dm
CONFIG_USB_SERIAL_OMNINET=3Dm
CONFIG_USB_SERIAL_OPTICON=3Dm
CONFIG_USB_SERIAL_DEBUG=3Dm

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=3Dm
CONFIG_USB_EMI26=3Dm
CONFIG_USB_ADUTUX=3Dm
CONFIG_USB_SEVSEG=3Dm
CONFIG_USB_RIO500=3Dm
CONFIG_USB_LEGOTOWER=3Dm
CONFIG_USB_LCD=3Dm
CONFIG_USB_BERRY_CHARGE=3Dm
CONFIG_USB_LED=3Dm
CONFIG_USB_CYPRESS_CY7C63=3Dm
CONFIG_USB_CYTHERM=3Dm
CONFIG_USB_IDMOUSE=3Dm
CONFIG_USB_FTDI_ELAN=3Dm
CONFIG_USB_APPLEDISPLAY=3Dm
CONFIG_USB_SISUSBVGA=3Dm
CONFIG_USB_SISUSBVGA_CON=3Dy
CONFIG_USB_LD=3Dm
CONFIG_USB_TRANCEVIBRATOR=3Dm
CONFIG_USB_IOWARRIOR=3Dm
CONFIG_USB_TEST=3Dm
CONFIG_USB_ISIGHTFW=3Dm
CONFIG_USB_VST=3Dm
CONFIG_USB_ATM=3Dm
CONFIG_USB_SPEEDTOUCH=3Dm
CONFIG_USB_CXACRU=3Dm
CONFIG_USB_UEAGLEATM=3Dm
CONFIG_USB_XUSBATM=3Dm
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=3Dy
CONFIG_NOP_USB_XCEIV=3Dm
CONFIG_UWB=3Dm
CONFIG_UWB_HWA=3Dm
CONFIG_UWB_WHCI=3Dm
CONFIG_UWB_WLP=3Dm
CONFIG_UWB_I1480U=3Dm
CONFIG_UWB_I1480U_WLP=3Dm
CONFIG_MMC=3Dm
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=3Dm
CONFIG_MMC_BLOCK_BOUNCE=3Dy
CONFIG_SDIO_UART=3Dm
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=3Dm
CONFIG_MMC_SDHCI_PCI=3Dm
CONFIG_MMC_RICOH_MMC=3Dm
CONFIG_MMC_SDHCI_PLTFM=3Dm
CONFIG_MMC_WBSD=3Dm
# CONFIG_MMC_AT91 is not set
# CONFIG_MMC_ATMELMCI is not set
CONFIG_MMC_TIFM_SD=3Dm
CONFIG_MMC_SPI=3Dm
CONFIG_MMC_SDRICOH_CS=3Dm
CONFIG_MMC_CB710=3Dm
CONFIG_MMC_VIA_SDMMC=3Dm
CONFIG_MEMSTICK=3Dm
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=3Dm

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=3Dm
CONFIG_MEMSTICK_JMICRON_38X=3Dm
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dm

#
# LED drivers
#
CONFIG_LEDS_ALIX2=3Dm
CONFIG_LEDS_PCA9532=3Dm
CONFIG_LEDS_LP3944=3Dm
CONFIG_LEDS_CLEVO_MAIL=3Dm
CONFIG_LEDS_PCA955X=3Dm
CONFIG_LEDS_WM831X_STATUS=3Dm
CONFIG_LEDS_WM8350=3Dm
CONFIG_LEDS_DAC124S085=3Dm
CONFIG_LEDS_BD2802=3Dm

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=3Dy
CONFIG_LEDS_TRIGGER_TIMER=3Dm
CONFIG_LEDS_TRIGGER_IDE_DISK=3Dy
CONFIG_LEDS_TRIGGER_HEARTBEAT=3Dm
CONFIG_LEDS_TRIGGER_BACKLIGHT=3Dm
CONFIG_LEDS_TRIGGER_DEFAULT_ON=3Dm

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=3Dy
CONFIG_A11Y_BRAILLE_CONSOLE=3Dy
CONFIG_INFINIBAND=3Dm
CONFIG_INFINIBAND_USER_MAD=3Dm
CONFIG_INFINIBAND_USER_ACCESS=3Dm
CONFIG_INFINIBAND_USER_MEM=3Dy
CONFIG_INFINIBAND_ADDR_TRANS=3Dy
CONFIG_INFINIBAND_MTHCA=3Dm
CONFIG_INFINIBAND_MTHCA_DEBUG=3Dy
CONFIG_INFINIBAND_IPATH=3Dm
CONFIG_INFINIBAND_AMSO1100=3Dm
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=3Dm
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=3Dm
CONFIG_INFINIBAND_NES=3Dm
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=3Dm
CONFIG_INFINIBAND_IPOIB_CM=3Dy
CONFIG_INFINIBAND_IPOIB_DEBUG=3Dy
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=3Dm
CONFIG_INFINIBAND_ISER=3Dm
CONFIG_EDAC=3Dy

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=3Dm
CONFIG_EDAC_MM_EDAC=3Dm
CONFIG_EDAC_AMD64=3Dm
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=3Dm
CONFIG_EDAC_I82975X=3Dm
CONFIG_EDAC_I3000=3Dm
CONFIG_EDAC_I3200=3Dm
CONFIG_EDAC_X38=3Dm
CONFIG_EDAC_I5400=3Dm
CONFIG_EDAC_I5000=3Dm
CONFIG_EDAC_I5100=3Dm
CONFIG_RTC_LIB=3Dy
CONFIG_RTC_CLASS=3Dy
CONFIG_RTC_HCTOSYS=3Dy
CONFIG_RTC_HCTOSYS_DEVICE=3D"rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=3Dy
CONFIG_RTC_INTF_PROC=3Dy
CONFIG_RTC_INTF_DEV=3Dy
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=3Dm
CONFIG_RTC_DRV_DS1374=3Dm
CONFIG_RTC_DRV_DS1672=3Dm
CONFIG_RTC_DRV_MAX6900=3Dm
CONFIG_RTC_DRV_RS5C372=3Dm
CONFIG_RTC_DRV_ISL1208=3Dm
CONFIG_RTC_DRV_X1205=3Dm
CONFIG_RTC_DRV_PCF8563=3Dm
CONFIG_RTC_DRV_PCF8583=3Dm
CONFIG_RTC_DRV_M41T80=3Dm
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_S35390A=3Dm
CONFIG_RTC_DRV_FM3130=3Dm
CONFIG_RTC_DRV_RX8581=3Dm
CONFIG_RTC_DRV_RX8025=3Dm

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=3Dm
CONFIG_RTC_DRV_DS1305=3Dm
CONFIG_RTC_DRV_DS1390=3Dm
CONFIG_RTC_DRV_MAX6902=3Dm
CONFIG_RTC_DRV_R9701=3Dm
CONFIG_RTC_DRV_RS5C348=3Dm
CONFIG_RTC_DRV_DS3234=3Dm
CONFIG_RTC_DRV_PCF2123=3Dm

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=3Dy
CONFIG_RTC_DRV_DS1286=3Dm
CONFIG_RTC_DRV_DS1511=3Dm
CONFIG_RTC_DRV_DS1553=3Dm
CONFIG_RTC_DRV_DS1742=3Dm
CONFIG_RTC_DRV_STK17TA8=3Dm
CONFIG_RTC_DRV_M48T86=3Dm
CONFIG_RTC_DRV_M48T35=3Dm
CONFIG_RTC_DRV_M48T59=3Dm
CONFIG_RTC_DRV_BQ4802=3Dm
CONFIG_RTC_DRV_V3020=3Dm
CONFIG_RTC_DRV_WM831X=3Dm
CONFIG_RTC_DRV_WM8350=3Dm
CONFIG_RTC_DRV_PCF50633=3Dm
CONFIG_RTC_DRV_AB3100=3Dm

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=3Dy

#
# DMA Devices
#
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=3Dy
CONFIG_INTEL_IOATDMA=3Dm
CONFIG_DMA_ENGINE=3Dy

#
# DMA Clients
#
CONFIG_NET_DMA=3Dy
CONFIG_ASYNC_TX_DMA=3Dy
# CONFIG_DMATEST is not set
CONFIG_DCA=3Dm
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=3Dm
CONFIG_UIO_CIF=3Dm
CONFIG_UIO_PDRV=3Dm
CONFIG_UIO_PDRV_GENIRQ=3Dm
CONFIG_UIO_SMX=3Dm
CONFIG_UIO_AEC=3Dm
CONFIG_UIO_SERCOS3=3Dm
CONFIG_UIO_PCI_GENERIC=3Dm

#
# TI VLYNQ
#
CONFIG_XEN_BALLOON=3Dy
CONFIG_XEN_SCRUB_PAGES=3Dy
CONFIG_XEN_DEV_EVTCHN=3Dm
CONFIG_XENFS=3Dm
CONFIG_XEN_COMPAT_XENFS=3Dy
CONFIG_XEN_SYS_HYPERVISOR=3Dy
CONFIG_STAGING=3Dy
# CONFIG_STAGING_EXCLUDE_BUILD is not set
CONFIG_ET131X=3Dm
# CONFIG_ET131X_DEBUG is not set
# CONFIG_SLICOSS is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_VIDEO_CX25821 is not set
CONFIG_USB_IP_COMMON=3Dm
CONFIG_USB_IP_VHCI_HCD=3Dm
CONFIG_USB_IP_HOST=3Dm
# CONFIG_W35UND is not set
CONFIG_PRISM2_USB=3Dm
# CONFIG_ECHO is not set
# CONFIG_POCH is not set
CONFIG_RT2860=3Dm
CONFIG_RT2870=3Dm
CONFIG_RT3090=3Dm
CONFIG_COMEDI=3Dm
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_PCI_DRIVERS=3Dm
CONFIG_COMEDI_PCMCIA_DRIVERS=3Dm
CONFIG_COMEDI_USB_DRIVERS=3Dm
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
# CONFIG_ALTERA_PCIE_CHDMA is not set
CONFIG_RTL8187SE=3Dm
CONFIG_RTL8192E=3Dm
# CONFIG_INPUT_MIMIO is not set
# CONFIG_TRANZPORT is not set

#
# Android
#

#
# Qualcomm MSM Camera And Video
#

#
# Camera Sensor Selection
#
# CONFIG_INPUT_GPIO is not set
# CONFIG_DST is not set
CONFIG_POHMELFS=3Dm
# CONFIG_POHMELFS_DEBUG is not set
CONFIG_POHMELFS_CRYPTO=3Dy
# CONFIG_B3DFG is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_PLAN9AUTH is not set
# CONFIG_LINE6_USB is not set
# CONFIG_DRM_RADEON_KMS is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_UDL is not set
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set

#
# RAR Register Driver
#
# CONFIG_RAR_REGISTER is not set
# CONFIG_IIO is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=3Dm
CONFIG_SPEAKUP_SYNTH_ACNTSA=3Dm
CONFIG_SPEAKUP_SYNTH_ACNTPC=3Dm
CONFIG_SPEAKUP_SYNTH_APOLLO=3Dm
CONFIG_SPEAKUP_SYNTH_AUDPTR=3Dm
CONFIG_SPEAKUP_SYNTH_BNS=3Dm
CONFIG_SPEAKUP_SYNTH_DECTLK=3Dm
CONFIG_SPEAKUP_SYNTH_DECEXT=3Dm
CONFIG_SPEAKUP_SYNTH_DTLK=3Dm
CONFIG_SPEAKUP_SYNTH_KEYPC=3Dm
CONFIG_SPEAKUP_SYNTH_LTLK=3Dm
CONFIG_SPEAKUP_SYNTH_SOFT=3Dm
CONFIG_SPEAKUP_SYNTH_SPKOUT=3Dm
CONFIG_SPEAKUP_SYNTH_TXPRT=3Dm
CONFIG_SPEAKUP_SYNTH_DUMMY=3Dm
CONFIG_X86_PLATFORM_DEVICES=3Dy
CONFIG_ACER_WMI=3Dm
CONFIG_ACERHDF=3Dm
CONFIG_ASUS_LAPTOP=3Dm
CONFIG_DELL_WMI=3Dm
CONFIG_FUJITSU_LAPTOP=3Dm
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_HP_WMI=3Dm
CONFIG_MSI_LAPTOP=3Dm
CONFIG_PANASONIC_LAPTOP=3Dm
CONFIG_COMPAL_LAPTOP=3Dm
CONFIG_SONY_LAPTOP=3Dm
CONFIG_SONYPI_COMPAT=3Dy
CONFIG_THINKPAD_ACPI=3Dm
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=3Dy
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=3Dy
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=3Dm
CONFIG_ACPI_WMI=3Dm
CONFIG_ACPI_ASUS=3Dm
CONFIG_TOPSTAR_LAPTOP=3Dm
CONFIG_ACPI_TOSHIBA=3Dm

#
# Firmware Drivers
#
CONFIG_EDD=3Dm
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
CONFIG_EFI_VARS=3Dm
CONFIG_DELL_RBU=3Dm
CONFIG_DCDBAS=3Dm
CONFIG_DMIID=3Dy
CONFIG_ISCSI_IBFT_FIND=3Dy
CONFIG_ISCSI_IBFT=3Dy

#
# File systems
#
CONFIG_EXT2_FS=3Dm
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dm
CONFIG_EXT3_DEFAULTS_TO_ORDERED=3Dy
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
CONFIG_EXT4_FS=3Dm
CONFIG_EXT4_FS_XATTR=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
CONFIG_EXT4_FS_SECURITY=3Dy
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=3Dm
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=3Dm
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=3Dm
CONFIG_REISERFS_FS=3Dm
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
CONFIG_JFS_FS=3Dm
CONFIG_JFS_POSIX_ACL=3Dy
CONFIG_JFS_SECURITY=3Dy
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_XFS_FS=3Dm
CONFIG_XFS_QUOTA=3Dy
CONFIG_XFS_POSIX_ACL=3Dy
CONFIG_XFS_RT=3Dy
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=3Dm
CONFIG_GFS2_FS_LOCKING_DLM=3Dy
CONFIG_OCFS2_FS=3Dm
CONFIG_OCFS2_FS_O2CB=3Dm
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=3Dm
CONFIG_OCFS2_FS_STATS=3Dy
CONFIG_OCFS2_DEBUG_MASKLOG=3Dy
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_OCFS2_FS_POSIX_ACL=3Dy
CONFIG_BTRFS_FS=3Dm
CONFIG_BTRFS_FS_POSIX_ACL=3Dy
CONFIG_NILFS2_FS=3Dm
CONFIG_FILE_LOCKING=3Dy
CONFIG_FSNOTIFY=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_QUOTA=3Dy
CONFIG_QUOTA_NETLINK_INTERFACE=3Dy
CONFIG_PRINT_QUOTA_WARNING=3Dy
CONFIG_QUOTA_TREE=3Dm
CONFIG_QFMT_V1=3Dm
CONFIG_QFMT_V2=3Dm
CONFIG_QUOTACTL=3Dy
CONFIG_AUTOFS_FS=3Dm
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm
CONFIG_CUSE=3Dm
CONFIG_GENERIC_ACL=3Dy

#
# Caches
#
CONFIG_FSCACHE=3Dm
CONFIG_FSCACHE_STATS=3Dy
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=3Dm
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"utf8"
CONFIG_NTFS_FS=3Dm
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=3Dy

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
CONFIG_CONFIGFS_FS=3Dm
CONFIG_MISC_FILESYSTEMS=3Dy
CONFIG_ADFS_FS=3Dm
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=3Dm
CONFIG_ECRYPT_FS=3Dm
CONFIG_HFS_FS=3Dm
CONFIG_HFSPLUS_FS=3Dm
CONFIG_BEFS_FS=3Dm
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=3Dm
CONFIG_EFS_FS=3Dm
CONFIG_JFFS2_FS=3Dm
CONFIG_JFFS2_FS_DEBUG=3D0
CONFIG_JFFS2_FS_WRITEBUFFER=3Dy
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=3Dy
CONFIG_JFFS2_FS_XATTR=3Dy
CONFIG_JFFS2_FS_POSIX_ACL=3Dy
CONFIG_JFFS2_FS_SECURITY=3Dy
CONFIG_JFFS2_COMPRESSION_OPTIONS=3Dy
CONFIG_JFFS2_ZLIB=3Dy
CONFIG_JFFS2_LZO=3Dy
CONFIG_JFFS2_RTIME=3Dy
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=3Dy
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=3Dm
CONFIG_UBIFS_FS_XATTR=3Dy
CONFIG_UBIFS_FS_ADVANCED_COMPR=3Dy
CONFIG_UBIFS_FS_LZO=3Dy
CONFIG_UBIFS_FS_ZLIB=3Dy
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_CRAMFS=3Dm
CONFIG_SQUASHFS=3Dm
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3D3
CONFIG_VXFS_FS=3Dm
CONFIG_MINIX_FS=3Dm
CONFIG_OMFS_FS=3Dm
CONFIG_HPFS_FS=3Dm
CONFIG_QNX4FS_FS=3Dm
CONFIG_ROMFS_FS=3Dm
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=3Dy
CONFIG_ROMFS_ON_BLOCK=3Dy
CONFIG_ROMFS_ON_MTD=3Dy
CONFIG_SYSV_FS=3Dm
CONFIG_UFS_FS=3Dm
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=3Dm
# CONFIG_EXOFS_DEBUG is not set
CONFIG_AUFS_FS=3Dm
CONFIG_AUFS_BRANCH_MAX_127=3Dy
# CONFIG_AUFS_BRANCH_MAX_511 is not set
# CONFIG_AUFS_BRANCH_MAX_1023 is not set
# CONFIG_AUFS_BRANCH_MAX_32767 is not set
# CONFIG_AUFS_HINOTIFY is not set
# CONFIG_AUFS_EXPORT is not set
# CONFIG_AUFS_RDU is not set
# CONFIG_AUFS_SP_IATTR is not set
# CONFIG_AUFS_SHWH is not set
# CONFIG_AUFS_BR_RAMFS is not set
# CONFIG_AUFS_BR_FUSE is not set
CONFIG_AUFS_BDEV_LOOP=3Dy
# CONFIG_AUFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dm
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
# CONFIG_NFS_V4_1 is not set
CONFIG_NFS_FSCACHE=3Dy
CONFIG_NFSD=3Dm
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
CONFIG_LOCKD=3Dm
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dm
CONFIG_NFS_ACL_SUPPORT=3Dm
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dm
CONFIG_SUNRPC_GSS=3Dm
CONFIG_SUNRPC_XPRT_RDMA=3Dm
CONFIG_RPCSEC_GSS_KRB5=3Dm
CONFIG_RPCSEC_GSS_SPKM3=3Dm
# CONFIG_SMB_FS is not set
CONFIG_CIFS=3Dm
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=3Dy
CONFIG_CIFS_UPCALL=3Dy
CONFIG_CIFS_XATTR=3Dy
CONFIG_CIFS_POSIX=3Dy
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=3Dy
CONFIG_CIFS_EXPERIMENTAL=3Dy
CONFIG_NCP_FS=3Dm
CONFIG_NCPFS_PACKET_SIGNING=3Dy
CONFIG_NCPFS_IOCTL_LOCKING=3Dy
CONFIG_NCPFS_STRONG=3Dy
CONFIG_NCPFS_NFS_NS=3Dy
CONFIG_NCPFS_OS2_NS=3Dy
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=3Dy
CONFIG_NCPFS_EXTRAS=3Dy
CONFIG_CODA_FS=3Dm
CONFIG_AFS_FS=3Dm
# CONFIG_AFS_DEBUG is not set
CONFIG_AFS_FSCACHE=3Dy
CONFIG_9P_FS=3Dm
CONFIG_9P_FSCACHE=3Dy

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
CONFIG_ACORN_PARTITION=3Dy
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=3Dy
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=3Dy
CONFIG_OSF_PARTITION=3Dy
CONFIG_AMIGA_PARTITION=3Dy
CONFIG_ATARI_PARTITION=3Dy
CONFIG_MAC_PARTITION=3Dy
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
CONFIG_MINIX_SUBPARTITION=3Dy
CONFIG_SOLARIS_X86_PARTITION=3Dy
CONFIG_UNIXWARE_DISKLABEL=3Dy
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=3Dy
CONFIG_ULTRIX_PARTITION=3Dy
CONFIG_SUN_PARTITION=3Dy
CONFIG_KARMA_PARTITION=3Dy
CONFIG_EFI_PARTITION=3Dy
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=3Dm
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dm
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dm
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_UTF8=3Dm
CONFIG_DLM=3Dm
CONFIG_DLM_DEBUG=3Dy

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_WARN_DEPRECATED=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_FRAME_WARN=3D2048
CONFIG_MAGIC_SYSRQ=3Dy
CONFIG_MAGIC_SYSRQ_DEFAULT_MASK=3D0x01b6
CONFIG_STRIP_ASM_SYMS=3Dy
CONFIG_UNUSED_SYMBOLS=3Dy
CONFIG_DEBUG_FS=3Dy
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=3Dy
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=3Dy
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=3D0
CONFIG_DETECT_HUNG_TASK=3Dy
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=3D0
CONFIG_SCHED_DEBUG=3Dy
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=3Dy
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=3Dy
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=3Dy
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=3Dy
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_NOP_TRACER=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_SYSCALL_TRACEPOINTS=3Dy
CONFIG_RING_BUFFER=3Dy
CONFIG_EVENT_TRACING=3Dy
CONFIG_CONTEXT_SWITCH_TRACER=3Dy
CONFIG_RING_BUFFER_ALLOW_SWAP=3Dy
CONFIG_TRACING=3Dy
CONFIG_GENERIC_TRACER=3Dy
CONFIG_TRACING_SUPPORT=3Dy
CONFIG_FTRACE=3Dy
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BOOT_TRACER=3Dy
CONFIG_BRANCH_PROFILE_NONE=3Dy
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=3Dy
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=3Dy
CONFIG_STRICT_DEVMEM=3Dy
CONFIG_X86_VERBOSE_BOOTUP=3Dy
CONFIG_EARLY_PRINTK=3Dy
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=3Dy
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=3Dy

#
# Security options
#
CONFIG_KEYS=3Dy
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=3Dy
CONFIG_SECURITYFS=3Dy
CONFIG_SECURITY_NETWORK=3Dy
CONFIG_SECURITY_NETWORK_XFRM=3Dy
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=3Dy
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=3D65536
CONFIG_SECURITY_SELINUX=3Dy
CONFIG_SECURITY_SELINUX_BOOTPARAM=3Dy
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=3D0
CONFIG_SECURITY_SELINUX_DISABLE=3Dy
CONFIG_SECURITY_SELINUX_DEVELOP=3Dy
CONFIG_SECURITY_SELINUX_AVC_STATS=3Dy
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=3D1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
CONFIG_XOR_BLOCKS=3Dm
CONFIG_ASYNC_CORE=3Dm
CONFIG_ASYNC_MEMCPY=3Dm
CONFIG_ASYNC_XOR=3Dm
CONFIG_ASYNC_PQ=3Dm
CONFIG_ASYNC_RAID6_RECOV=3Dm
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=3Dy
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=3Dy
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD=3Dm
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dm
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG=3Dm
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_PCOMP=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
CONFIG_CRYPTO_GF128MUL=3Dm
CONFIG_CRYPTO_NULL=3Dm
CONFIG_CRYPTO_WORKQUEUE=3Dy
CONFIG_CRYPTO_CRYPTD=3Dm
CONFIG_CRYPTO_AUTHENC=3Dm
CONFIG_CRYPTO_TEST=3Dm

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=3Dm
CONFIG_CRYPTO_GCM=3Dm
CONFIG_CRYPTO_SEQIV=3Dm

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dm
CONFIG_CRYPTO_CTR=3Dm
CONFIG_CRYPTO_CTS=3Dm
CONFIG_CRYPTO_ECB=3Dm
CONFIG_CRYPTO_LRW=3Dm
CONFIG_CRYPTO_PCBC=3Dm
CONFIG_CRYPTO_XTS=3Dm
CONFIG_CRYPTO_FPU=3Dm

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=3Dm
CONFIG_CRYPTO_XCBC=3Dm
CONFIG_CRYPTO_VMAC=3Dm

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dm
CONFIG_CRYPTO_CRC32C_INTEL=3Dm
CONFIG_CRYPTO_GHASH=3Dm
CONFIG_CRYPTO_MD4=3Dm
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_MICHAEL_MIC=3Dm
CONFIG_CRYPTO_RMD128=3Dm
CONFIG_CRYPTO_RMD160=3Dm
CONFIG_CRYPTO_RMD256=3Dm
CONFIG_CRYPTO_RMD320=3Dm
CONFIG_CRYPTO_SHA1=3Dm
CONFIG_CRYPTO_SHA256=3Dm
CONFIG_CRYPTO_SHA512=3Dm
CONFIG_CRYPTO_TGR192=3Dm
CONFIG_CRYPTO_WP512=3Dm

#
# Ciphers
#
CONFIG_CRYPTO_AES=3Dm
CONFIG_CRYPTO_AES_X86_64=3Dm
CONFIG_CRYPTO_AES_NI_INTEL=3Dm
CONFIG_CRYPTO_ANUBIS=3Dm
CONFIG_CRYPTO_ARC4=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
CONFIG_CRYPTO_CAMELLIA=3Dm
CONFIG_CRYPTO_CAST5=3Dm
CONFIG_CRYPTO_CAST6=3Dm
CONFIG_CRYPTO_DES=3Dm
CONFIG_CRYPTO_FCRYPT=3Dm
CONFIG_CRYPTO_KHAZAD=3Dm
CONFIG_CRYPTO_SALSA20=3Dm
CONFIG_CRYPTO_SALSA20_X86_64=3Dm
CONFIG_CRYPTO_SEED=3Dm
CONFIG_CRYPTO_SERPENT=3Dm
CONFIG_CRYPTO_TEA=3Dm
CONFIG_CRYPTO_TWOFISH=3Dm
CONFIG_CRYPTO_TWOFISH_COMMON=3Dm
CONFIG_CRYPTO_TWOFISH_X86_64=3Dm

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=3Dm
CONFIG_CRYPTO_ZLIB=3Dm
CONFIG_CRYPTO_LZO=3Dm

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=3Dm
CONFIG_CRYPTO_HW=3Dy
CONFIG_CRYPTO_DEV_PADLOCK=3Dm
CONFIG_CRYPTO_DEV_PADLOCK_AES=3Dm
CONFIG_CRYPTO_DEV_PADLOCK_SHA=3Dm
CONFIG_CRYPTO_DEV_HIFN_795X=3Dm
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=3Dy
CONFIG_HAVE_KVM=3Dy
CONFIG_HAVE_KVM_IRQCHIP=3Dy
CONFIG_HAVE_KVM_EVENTFD=3Dy
CONFIG_KVM_APIC_ARCHITECTURE=3Dy
CONFIG_VIRTUALIZATION=3Dy
CONFIG_KVM=3Dm
CONFIG_KVM_INTEL=3Dm
CONFIG_KVM_AMD=3Dm
CONFIG_VIRTIO=3Dm
CONFIG_VIRTIO_RING=3Dm
CONFIG_VIRTIO_PCI=3Dm
CONFIG_VIRTIO_BALLOON=3Dm
CONFIG_BINARY_PRINTF=3Dy

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_GENERIC_FIND_NEXT_BIT=3Dy
CONFIG_GENERIC_FIND_LAST_BIT=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dm
CONFIG_CRC_T10DIF=3Dm
CONFIG_CRC_ITU_T=3Dm
CONFIG_CRC32=3Dy
CONFIG_CRC7=3Dm
CONFIG_LIBCRC32C=3Dm
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dm
CONFIG_LZO_COMPRESS=3Dm
CONFIG_LZO_DECOMPRESS=3Dm
CONFIG_DECOMPRESS_GZIP=3Dy
CONFIG_DECOMPRESS_BZIP2=3Dy
CONFIG_DECOMPRESS_LZMA=3Dy
CONFIG_GENERIC_ALLOCATOR=3Dy
CONFIG_REED_SOLOMON=3Dm
CONFIG_REED_SOLOMON_DEC16=3Dy
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dm
CONFIG_TEXTSEARCH_BM=3Dm
CONFIG_TEXTSEARCH_FSM=3Dm
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CHECK_SIGNATURE=3Dy
CONFIG_NLATTR=3Dy
--=_187jj9a6milz--
