From: Andre Noll <maan@systemlinux.org>
Subject: qla2xx: NULL pointer dereference (2.6.33.1)
Date: Thu, 25 Mar 2010 21:27:22 +0100
Message-ID: <20100325202722.GO25507@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DRfr/2Y1Zz/5r+Kb"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Thomas Helle <thomas.helle@tuebingen.mpg.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--DRfr/2Y1Zz/5r+Kb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I'm seeing the following oops with the qla2xxx driver under high load:

	BUG: unable to handle kernel NULL pointer dereference at 000000000000002c
	IP: [<ffffffffa0012ae7>] __qla2x00_marker+0x97/0x400 [qla2xxx]

Prior to the oops there are a couple of

	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fdeed 2002.

messages.

The device is an older infortrend FC Raid system connected to a dual port
qlogic hba via a brocade FC switch. Workload was a simple "stress -d" and
an fsck of a file system on a different Raid which is connected to the
same hba. This workload triggers the oops within a couple of hours.

The same hardware works fine with an older 2.6.27 kernel.

Full dmesg output and .config below. Let me know if you need
more information.

Thanks
Andre

Linux version 2.6.33.1 (root@huangho2) (gcc version 4.2.4 (Ubuntu 4.2.4-1ub=
untu4)) #23 SMP Thu Mar 18 14:22:53 CET 2010
Command line:=20
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000f57f8000 (usable)
 BIOS-e820: 00000000f57f8000 - 00000000f5800000 (ACPI data)
 BIOS-e820: 00000000fdc00000 - 00000000fdc01000 (reserved)
 BIOS-e820: 00000000fdc10000 - 00000000fdc11000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
 BIOS-e820: 00000000fec20000 - 00000000fec21000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000002fffff000 (usable)
NX (Execute Disable) protection: active
DMI 2.3 present.
No AGP bridge found
last_pfn =3D 0x2fffff max_arch_pfn =3D 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-E7FFF write-back
  E8000-EFFFF uncachable
  F0000-FFFFF write-back
MTRR variable ranges enabled:
  0 base 00F5800000 mask FFFF800000 uncachable
  1 base 00F6000000 mask FFFE000000 uncachable
  2 base 00F8000000 mask FFF8000000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn =3D 0xf57f8 max_arch_pfn =3D 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000f4fa0] f4fa0
init_memory_mapping: 0000000000000000-00000000f57f8000
 0000000000 - 00f5600000 page 2M
 00f5600000 - 00f57f8000 page 4k
kernel direct mapping tables up to f57f8000 @ 8000-e000
init_memory_mapping: 0000000100000000-00000002fffff000
 0100000000 - 02ffe00000 page 2M
 02ffe00000 - 02fffff000 page 4k
kernel direct mapping tables up to 2fffff000 @ c000-1a000
ACPI: RSDP 00000000000f4f20 00024 (v02 HP    )
ACPI: XSDT 00000000f57f83e0 00044 (v01 HP     A05      00000002   =D2? 0000=
162E)
ACPI: FACP 00000000f57f8460 000F4 (v03 HP     A05      00000002   =D2? 0000=
162E)
ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20=
091214/tbfadt-607)
ACPI Warning: Invalid length for Pm1bControlBlock: 32, using default 16 (20=
091214/tbfadt-607)
ACPI: DSDT 00000000f57f8560 0422D (v01 HP         DSDT 00000001 MSFT 020000=
01)
ACPI: FACS 00000000f57f80c0 00040
ACPI: APIC 00000000f57f8100 000B8 (v01 HP     00000083 00000002      000000=
00)
ACPI: SPCR 00000000f57f81e0 00050 (v01 HP     SPCRRBSU 00000001   =D2? 0000=
162E)
ACPI: SRAT 00000000f57f8260 00150 (v01 HP     A05      00000001      000000=
00)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 1 -> APIC 0x00 -> Node 0
SRAT: PXM 2 -> APIC 0x02 -> Node 1
ACPI: [SRAT:0x00] ignored 4 entries of 8 found
SRAT: Node 0 PXM 1 0-180000000
SRAT: Node 1 PXM 2 180000000-300000000
NUMA: Using 31 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000000015000 - 0000000000019fff]
  bootmap [000000000001a000 -  0000000000049fff] pages 30
(12 early reservations) =3D=3D> bootmem [0000000000 - 0180000000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0001000000 - 00022c4df0]    TEXT DATA BSS =3D=3D> [0001000000 - 00022=
c4df0]
  #2 [00022c5000 - 00022c50d4]              BRK =3D=3D> [00022c5000 - 00022=
c50d4]
  #3 [000009f400 - 00000f4fa0]    BIOS reserved =3D=3D> [000009f400 - 00000=
f4fa0]
  #4 [00000f4fa0 - 00000f4fb0]     MP-table mpf =3D=3D> [00000f4fa0 - 00000=
f4fb0]
  #5 [00000f4fb0 - 00000f7d12]    BIOS reserved =3D=3D> [00000f4fb0 - 00000=
f7d12]
  #6 [00000f7efe - 0000100000]    BIOS reserved =3D=3D> [00000f7efe - 00001=
00000]
  #7 [00000f7d12 - 00000f7efe]     MP-table mpc =3D=3D> [00000f7d12 - 00000=
f7efe]
  #8 [0000001000 - 0000003000]       TRAMPOLINE =3D=3D> [0000001000 - 00000=
03000]
  #9 [0000003000 - 0000007000]      ACPI WAKEUP =3D=3D> [0000003000 - 00000=
07000]
  #10 [0000008000 - 000000c000]          PGTABLE =3D=3D> [0000008000 - 0000=
00c000]
  #11 [000000c000 - 0000015000]          PGTABLE =3D=3D> [000000c000 - 0000=
015000]
Bootmem setup node 1 0000000180000000-00000002fffff000
  NODE_DATA [0000000180000000 - 0000000180004fff]
  bootmap [0000000180005000 -  0000000180034fff] pages 30
(12 early reservations) =3D=3D> bootmem [0180000000 - 02fffff000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0001000000 - 00022c4df0]    TEXT DATA BSS
  #2 [00022c5000 - 00022c50d4]              BRK
  #3 [000009f400 - 00000f4fa0]    BIOS reserved
  #4 [00000f4fa0 - 00000f4fb0]     MP-table mpf
  #5 [00000f4fb0 - 00000f7d12]    BIOS reserved
  #6 [00000f7efe - 0000100000]    BIOS reserved
  #7 [00000f7d12 - 00000f7efe]     MP-table mpc
  #8 [0000001000 - 0000003000]       TRAMPOLINE
  #9 [0000003000 - 0000007000]      ACPI WAKEUP
  #10 [0000008000 - 000000c000]          PGTABLE
  #11 [000000c000 - 0000015000]          PGTABLE
 [ffffea0000000000-ffffea00053fffff] PMD -> [ffff880028600000-ffff88002d9ff=
fff] on node 0
 [ffffea0005400000-ffffea000a7fffff] PMD -> [ffff880180200000-ffff8801855ff=
fff] on node 1
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x002fffff
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000f57f8
    0: 0x00100000 -> 0x00180000
    1: 0x00180000 -> 0x002fffff
On node 0 totalpages: 1529751
  DMA zone: 56 pages used for memmap
  DMA zone: 115 pages reserved
  DMA zone: 3828 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 987184 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1572863
  Normal zone: 21504 pages used for memmap
  Normal zone: 1551359 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 5, version 17, address 0xfec10000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xfec20000] gsi_base[28])
IOAPIC[2]: apic_id 6, version 17, address 0xfec20000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xfdc00000] gsi_base[32])
IOAPIC[3]: apic_id 7, version 17, address 0xfdc00000, GSI 32-35
ACPI: IOAPIC (id[0x08] address[0xfdc10000] gsi_base[36])
IOAPIC[4]: apic_id 8, version 17, address 0xfdc10000, GSI 36-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
8 Processors exceeds NR_CPUS limit of 4
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at f5800000 (gap: f5800000:8400000)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:2
PERCPU: Embedded 27 pages/cpu @ffff880028200000 s79448 r8192 d22952 u1048576
pcpu-alloc: s79448 r8192 d22952 u1048576 alloc=3D1*2097152
pcpu-alloc: [0] 0 2 [1] 1 3=20
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 3059491
Policy zone: Normal
Kernel command line:=20
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
Memory: 12086444k/12582908k available (4353k kernel code, 172452k absent, 3=
24012k reserved, 2617k data, 3396k init)
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:384
Extended CMOS year: 2000
kmemleak: Early log buffer exceeded, please increase DEBUG_KMEMLEAK_EARLY_L=
OG_SIZE
kmemleak: Kernel memory leak detector disabled
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
=2E.. MAX_LOCKDEP_SUBCLASSES:  8
=2E.. MAX_LOCK_DEPTH:          48
=2E.. MAX_LOCKDEP_KEYS:        8191
=2E.. CLASSHASH_SIZE:          4096
=2E.. MAX_LOCKDEP_ENTRIES:     16384
=2E.. MAX_LOCKDEP_CHAINS:      32768
=2E.. CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 5855 kB
 per task-struct memory footprint: 1920 bytes
Fast TSC calibration using PIT
Detected 2205.364 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. =
4410.72 BogoMIPS (lpj=3D8821456)
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
Performance Events: AMD PMU driver.
=2E.. version:                0
=2E.. bit width:              48
=2E.. generic registers:      4
=2E.. value mask:             0000ffffffffffff
=2E.. max period:             00007fffffffffff
=2E.. fixed-purpose events:   0
=2E.. event mask:             000000000000000f
ACPI: Core revision 20091214
Setting APIC routing to flat
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D0
CPU0: AMD Opteron(tm) Processor 275 stepping 02
Testing tracer nop: PASSED
lockdep: fixing up alternatives.
Booting Node   1, Processors  #1lockdep: fixing up alternatives.
 Ok.
Booting Node   0, Processors  #2lockdep: fixing up alternatives.
 Ok.
Booting Node   1, Processors  #3 Ok.
Brought up 4 CPUs
Total of 4 processors activated (17641.58 BogoMIPS).
NET: Registered protocol family 16
node 0 link 2: io port [1000, 5fff]
node 0 link 0: io port [6000, 6fff]
TOM: 00000000f5800000 aka 3928M
node 0 link 2: mmio [f5f00000, f7efffff]
node 0 link 0: mmio [f7f00000, f7ffffff]
node 0 link 2: mmio [a0000, bffff]
node 0 link 2: mmio [fe000000, ffffffff]
node 0 link 0: mmio [f8000000, fdffffff]
TOM2: 0000000300000000 aka 12288M
bus: [00, 03] on node 0 link 2
bus: 00 index 0 io port: [0, 5fff]
bus: 00 index 1 io port: [7000, ffff]
bus: 00 index 2 mmio: [f5800000, f7efffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [300000000, fcffffffff]
bus: [04, 06] on node 0 link 0
bus: 04 index 0 io port: [6000, 6fff]
bus: 04 index 1 mmio: [f7f00000, fdffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 00000000f57fd000 0059D (v01 HP        SSDT0 00000001 MSFT 020000=
01)
ACPI: SSDT 00000000f57fd700 0059D (v01 HP        SSDT1 00000001 MSFT 020000=
01)
ACPI: SSDT 00000000f57fde00 0059D (v01 HP        SSDT2 00000001 MSFT 020000=
01)
ACPI: SSDT 00000000f57fe500 0059D (v01 HP        SSDT3 00000001 MSFT 020000=
01)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [CFG0] (0000:00)
pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=
=3Duse_crs" to use them
pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x03e0-0x0fff] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x1000-0x5fff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xf5f00000-0xf7efffff] (ignore=
d)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignore=
d)
pci 0000:00:04.1: reg 20: [io  0x2000-0x200f]
PCI: peer root bus 00 res updated from pci conf
pci 0000:01:00.0: reg 10: [mem 0xf7cf0000-0xf7cf0fff]
pci 0000:01:00.1: reg 10: [mem 0xf7ce0000-0xf7ce0fff]
pci 0000:01:02.0: reg 10: [io  0x4800-0x48ff]
pci 0000:01:02.0: reg 14: [mem 0xf7cb0000-0xf7cb01ff]
pci 0000:01:02.2: reg 10: [io  0x4000-0x40ff]
pci 0000:01:02.2: reg 14: [mem 0xf7ca0000-0xf7ca07ff]
pci 0000:01:02.2: reg 18: [mem 0xf7c90000-0xf7c91fff]
pci 0000:01:02.2: reg 1c: [mem 0xf7c00000-0xf7c7ffff]
pci 0000:01:02.2: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:01:02.2: PME# supported from D0 D3hot D3cold
pci 0000:01:02.2: PME# disabled
pci 0000:01:03.0: reg 10: [mem 0xf6000000-0xf6ffffff]
pci 0000:01:03.0: reg 14: [io  0x4400-0x44ff]
pci 0000:01:03.0: reg 18: [mem 0xf5ff0000-0xf5ff0fff]
pci 0000:01:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:03.0: supports D1 D2
pci 0000:00:03.0: PCI bridge to [bus 01-01]
pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7cfffff]
pci 0000:02:04.0: reg 10: [mem 0xf7df0000-0xf7df1fff 64bit]
pci 0000:02:04.0: reg 18: [io  0x5000-0x50ff]
pci 0000:02:04.0: reg 1c: [mem 0xf7d80000-0xf7dbffff 64bit]
pci 0000:02:04.0: reg 30: [mem 0x00000000-0x0003ffff pref]
pci 0000:02:04.0: supports D1
pci 0000:00:07.0: PCI bridge to [bus 02-02]
pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
pci 0000:00:07.0:   bridge window [mem 0xf7d00000-0xf7dfffff]
pci 0000:03:06.0: reg 10: [mem 0xf7ef0000-0xf7efffff 64bit]
pci 0000:03:06.0: PME# supported from D3hot D3cold
pci 0000:03:06.0: PME# disabled
pci 0000:03:06.1: reg 10: [mem 0xf7ee0000-0xf7eeffff 64bit]
pci 0000:03:06.1: PME# supported from D3hot D3cold
pci 0000:03:06.1: PME# disabled
pci 0000:00:08.0: PCI bridge to [bus 03-03]
pci 0000:00:08.0:   bridge window [mem 0xf7e00000-0xf7efffff]
ACPI: PCI Interrupt Routing Table [\_SB_.CFG0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI2._PRT]
ACPI: PCI Root Bridge [CFG1] (0000:04)
pci_root PNP0A03:01: ignoring host bridge windows from ACPI; boot with "pci=
=3Duse_crs" to use them
pci_root PNP0A03:01: host bridge window [io  0x6000-0x6fff] (ignored)
pci_root PNP0A03:01: host bridge window [mem 0xf7f00000-0xf7ffffff] (ignore=
d)
PCI: peer root bus 04 res updated from pci conf
pci 0000:04:09.0: PCI bridge to [bus 05-05]
pci 0000:06:09.0: reg 10: [io  0x6000-0x60ff]
pci 0000:06:09.0: reg 14: [mem 0xf7ff0000-0xf7ff0fff 64bit]
pci 0000:06:09.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:06:09.1: reg 10: [io  0x6400-0x64ff]
pci 0000:06:09.1: reg 14: [mem 0xf7fe0000-0xf7fe0fff 64bit]
pci 0000:06:09.1: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:04:0a.0: PCI bridge to [bus 06-06]
pci 0000:04:0a.0:   bridge window [io  0x6000-0x6fff]
pci 0000:04:0a.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.CFG1.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.CFG1.PCI4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 7 10 11) *15
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *5 7 10 11)
vgaarb: device added: PCI:0000:01:03.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
Switching to clocksource jiffies
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [io  0x0230-0x0233] has been reserved
system 00:01: [io  0x0260-0x0267] has been reserved
system 00:01: [io  0x04d0-0x04d1] has been reserved
system 00:01: [io  0x0800-0x081f] has been reserved
system 00:01: [io  0x0840-0x085f] has been reserved
system 00:01: [io  0x0900-0x0903] has been reserved
system 00:01: [io  0x0904-0x0907] has been reserved
system 00:01: [io  0x0908-0x090b] has been reserved
system 00:01: [io  0x090c-0x092e] has been reserved
system 00:01: [io  0x092f] has been reserved
system 00:01: [io  0x0930-0x09ff] has been reserved
system 00:01: [io  0x0c80-0x0c87] has been reserved
system 00:01: [io  0x0cf9] could not be reserved
system 00:01: [io  0x02f8-0x02ff] has been reserved
Switching to clocksource acpi_pm
pci 0000:00:03.0: BAR 9: assigned [mem 0xf5800000-0xf58fffff pref]
pci 0000:00:07.0: BAR 9: assigned [mem 0xf5900000-0xf59fffff pref]
pci 0000:01:03.0: BAR 6: assigned [mem 0xf5800000-0xf581ffff pref]
pci 0000:01:02.2: BAR 6: assigned [mem 0xf5820000-0xf582ffff pref]
pci 0000:00:03.0: PCI bridge to [bus 01-01]
pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7cfffff]
pci 0000:00:03.0:   bridge window [mem 0xf5800000-0xf58fffff pref]
pci 0000:02:04.0: BAR 6: assigned [mem 0xf5900000-0xf593ffff pref]
pci 0000:00:07.0: PCI bridge to [bus 02-02]
pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
pci 0000:00:07.0:   bridge window [mem 0xf7d00000-0xf7dfffff]
pci 0000:00:07.0:   bridge window [mem 0xf5900000-0xf59fffff pref]
pci 0000:00:08.0: PCI bridge to [bus 03-03]
pci 0000:00:08.0:   bridge window [io  disabled]
pci 0000:00:08.0:   bridge window [mem 0xf7e00000-0xf7efffff]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:04:0a.0: BAR 9: assigned [mem 0xf8000000-0xf80fffff pref]
pci 0000:04:09.0: PCI bridge to [bus 05-05]
pci 0000:04:09.0:   bridge window [io  disabled]
pci 0000:04:09.0:   bridge window [mem disabled]
pci 0000:04:09.0:   bridge window [mem pref disabled]
pci 0000:06:09.0: BAR 6: assigned [mem 0xf8000000-0xf801ffff pref]
pci 0000:06:09.1: BAR 6: assigned [mem 0xf8020000-0xf803ffff pref]
pci 0000:04:0a.0: PCI bridge to [bus 06-06]
pci 0000:04:0a.0:   bridge window [io  0x6000-0x6fff]
pci 0000:04:0a.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
pci 0000:04:0a.0:   bridge window [mem 0xf8000000-0xf80fffff pref]
pci_bus 0000:00: resource 0 [io  0x0000-0x5fff]
pci_bus 0000:00: resource 1 [io  0x7000-0xffff]
pci_bus 0000:00: resource 2 [mem 0xf5800000-0xf7efffff]
pci_bus 0000:00: resource 3 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 4 [mem 0xfe000000-0xffffffff]
pci_bus 0000:00: resource 5 [mem 0x300000000-0xfcffffffff]
pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:01: resource 1 [mem 0xf5f00000-0xf7cfffff]
pci_bus 0000:01: resource 2 [mem 0xf5800000-0xf58fffff pref]
pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:02: resource 1 [mem 0xf7d00000-0xf7dfffff]
pci_bus 0000:02: resource 2 [mem 0xf5900000-0xf59fffff pref]
pci_bus 0000:03: resource 1 [mem 0xf7e00000-0xf7efffff]
pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:04: resource 1 [mem 0xf7f00000-0xfdffffff]
pci_bus 0000:06: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:06: resource 1 [mem 0xf7f00000-0xf7ffffff]
pci_bus 0000:06: resource 2 [mem 0xf8000000-0xf80fffff pref]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 8192 (order: 8, 1048576 bytes)
UDP-Lite hash table entries: 8192 (order: 8, 1048576 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:04.3: boot interrupts on device [1022:746b] already disabled
pci 0000:00:07.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:00:08.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:01:03.0: Boot video device
pci 0000:04:09.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:04:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
PCI: CLS 64 bytes, default 64
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
platform rtc_cmos: registered platform RTC device (no PNP device found)
audit: initializing netlink socket (disabled)
type=3D2000 audit(1269453648.555:1): initialized
Testing tracer sched_switch: PASSED
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 23735
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
input: Power Button as /class/input/input0
ACPI: Power Button [PWRF]
Generic RTC Driver v1.07
AMD768 RNG detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
brd: module loaded
HP CISS Driver (v 3.6.20)
cciss 0000:02:04.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
IRQ 24/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
cciss0: <0x46> at PCI 0000:02:04.0 IRQ 24 using DAC
 cciss/c0d0: p1 p2 p3
 cciss/c0d1: p1 p2 p3
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:04.1: UDMA133 controller
amd74xx 0000:00:04.1: IDE controller (0x1022:0x7469 rev 0x03)
amd74xx 0000:00:04.1: IDE port disabled
amd74xx 0000:00:04.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x2000-0x2007
Probing IDE interface ide0...
hda: TSSTcorpCD-ROM TS-L162C, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide-gd driver 1.18
ide-cd driver 5.00
ide-cd: hda: ATAPI 24X CD-ROM drive, 96kB Cache
Uniform CD-ROM driver Revision: 3.20
Loading iSCSI transport class v2.0-870.
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:01:00.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:00.0: OHCI Host Controller
ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:01:00.0: irq 19, io mem 0xf7cf0000
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ohci_hcd 0000:01:00.1: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:00.1: OHCI Host Controller
ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:01:00.1: irq 19, io mem 0xf7ce0000
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redha=
t.com
device-mapper: multipath: version 1.1.1 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Running tests on trace events:
Testing event kfree_skb: OK
Testing event skb_copy_datagram_iovec:=20
input: AT Translated Set 2 keyboard as /class/input/input1
OK
Testing event lock_kernel: OK
Testing event unlock_kernel: OK
Testing event block_rq_abort: OK
Testing event block_rq_requeue: OK
Testing event block_rq_complete: OK
Testing event block_rq_insert: OK
Testing event block_rq_issue: OK
Testing event block_bio_bounce: OK
Testing event block_bio_complete: OK
Testing event block_bio_backmerge: OK
Testing event block_bio_frontmerge: OK
Testing event block_bio_queue: OK
Testing event block_getrq: OK
Testing event block_sleeprq: OK
Testing event block_plug: OK
Testing event block_unplug_timer: OK
Testing event block_unplug_io: OK
Testing event block_split: OK
Testing event block_remap: OK
Testing event block_rq_remap: OK
Testing event jbd2_checkpoint: OK
Testing event jbd2_start_commit: OK
Testing event jbd2_commit_locking: OK
Testing event jbd2_commit_flushing: OK
Testing event jbd2_commit_logging: OK
Testing event jbd2_end_commit: OK
Testing event jbd2_submit_inode_data: OK
Testing event jbd2_run_stats: OK
Testing event jbd2_checkpoint_stats: OK
Testing event ext4_free_inode: OK
Testing event ext4_request_inode: OK
Testing event ext4_allocate_inode: OK
Testing event ext4_write_begin: OK
Testing event ext4_da_write_begin: OK
Testing event ext4_ordered_write_end: OK
Testing event ext4_writeback_write_end: OK
Testing event ext4_journalled_write_end: OK
Testing event ext4_da_write_end: OK
Testing event ext4_writepage: OK
Testing event ext4_da_writepages: OK
Testing event ext4_da_write_pages: OK
Testing event ext4_da_writepages_result: OK
Testing event ext4_discard_blocks: OK
Testing event ext4_mb_new_inode_pa: OK
Testing event ext4_mb_new_group_pa: OK
Testing event ext4_mb_release_inode_pa: OK
Testing event ext4_mb_release_group_pa: OK
Testing event ext4_discard_preallocations: OK
Testing event ext4_mb_discard_preallocations: OK
Testing event ext4_request_blocks: OK
Testing event ext4_allocate_blocks: OK
Testing event ext4_free_blocks: OK
Testing event ext4_sync_file: OK
Testing event ext4_sync_fs: OK
Testing event ext4_alloc_da_blocks: OK
Testing event ext4_mballoc_alloc: OK
Testing event ext4_mballoc_prealloc: OK
Testing event ext4_mballoc_discard: OK
Testing event ext4_mballoc_free: OK
Testing event ext4_forget: OK
Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: OK
Testing event kfree: OK
Testing event kmem_cache_free: OK
Testing event mm_page_free_direct: OK
Testing event mm_pagevec_free: OK
Testing event mm_page_alloc: OK
Testing event mm_page_alloc_zone_locked: OK
Testing event mm_page_pcpu_drain: OK
Testing event mm_page_alloc_extfrag: OK
Testing event power_start: OK
Testing event power_frequency: OK
Testing event power_end: OK
Testing event module_load: OK
Testing event module_free: OK
Testing event module_get: OK
Testing event module_put: OK
Testing event module_request: OK
Testing event lock_acquire: OK
Testing event lock_release: OK
Testing event workqueue_insertion: OK
Testing event workqueue_execution: OK
Testing event workqueue_creation: OK
Testing event workqueue_destruction: OK
Testing event signal_generate: OK
Testing event signal_deliver: OK
Testing event signal_overflow_fail: OK
Testing event signal_lose_info: OK
Testing event timer_init: OK
Testing event timer_start: OK
Testing event timer_expire_entry: OK
Testing event timer_expire_exit: OK
Testing event timer_cancel: OK
Testing event hrtimer_init: OK
Testing event hrtimer_start: OK
Testing event hrtimer_expire_entry: OK
Testing event hrtimer_expire_exit: OK
Testing event hrtimer_cancel: OK
Testing event itimer_state: OK
Testing event itimer_expire: OK
Testing event irq_handler_entry: OK
Testing event irq_handler_exit: OK
Testing event softirq_entry: OK
Testing event softirq_exit: OK
Testing event sched_kthread_stop: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_wait_task: OK
Testing event sched_wakeup: OK
Testing event sched_wakeup_new: OK
Testing event sched_switch: OK
Testing event sched_migrate_task: OK
Testing event sched_process_free: OK
Testing event sched_process_exit: OK
Testing event sched_process_wait: OK
Testing event sched_process_fork: OK
Testing event sched_stat_wait: OK
Testing event sched_stat_sleep: OK
Testing event sched_stat_iowait: OK
Testing event sched_stat_runtime: OK
Testing event mce_record: OK
Testing event sys_enter: OK
Testing event sys_exit: OK
Running tests on trace event systems:
Testing event system skb: OK
Testing event system bkl: OK
Testing event system block: OK
Testing event system jbd2: OK
Testing event system ext4: OK
Testing event system kmem: OK
Testing event system power: OK
Testing event system module: OK
Testing event system lock: OK
Testing event system workqueue: OK
Testing event system signal: OK
Testing event system timer: OK
Testing event system irq: OK
Testing event system sched: OK
Testing event system mce: OK
Testing event system raw_syscalls: OK
Running tests on all trace events:
Testing all events: OK
Freeing unused kernel memory: 3396k freed
md: md1 stopped.
md: bind<cciss!c0d1p2>
md: bind<cciss!c0d0p2>
raid1: raid set md1 active with 2 out of 2 mirrors
md1: detected capacity change from 0 to 66002681856
 md1: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md1): mounted filesystem with writeback data mode
md: md0 stopped.
QLogic Fibre Channel HBA Driver: 8.03.01-k10
qla2xxx 0000:06:09.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
qla2xxx 0000:06:09.0: Found an ISP2312, irq 36, iobase 0xffffc90003180000
qla2xxx 0000:06:09.0: Configuring PCI space...
qla2xxx 0000:06:09.0: Configure NVRAM parameters...
md: bind<cciss!c0d1p1>
md: bind<cciss!c0d0p1>
raid1: raid set md0 active with 2 out of 2 mirrors
md0: detected capacity change from 0 to 133562368
md: md2 stopped.
 md0:
qla2xxx 0000:06:09.0: Verifying loaded RISC code...
qla2xxx 0000:06:09.0: firmware: requesting ql2300_fw.bin
tg3.c:v3.106 (January 12, 2010)
tg3 0000:03:06.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
md: bind<cciss!c0d1p3>
md: bind<cciss!c0d0p3>
raid1: raid set md2 active with 2 out of 2 mirrors
md2: detected capacity change from 0 to 6697123840
 md2:
eth0: Tigon3 [partno(N/A) rev 2100] (PCIX:133MHz:64-bit) MAC address 00:18:=
71:e4:5e:8a
eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
qla2xxx 0000:06:09.0: Allocated (412 KB) for firmware dump...
tg3 0000:03:06.1: PCI INT B -> GSI 29 (level, low) -> IRQ 29
 unknown partition table
eth1: Tigon3 [partno(N/A) rev 2100] (PCIX:133MHz:64-bit) MAC address 00:18:=
71:e4:5e:89
eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
tg3 0000:03:06.1: firmware: requesting tigon/tg3_tso.bin
scsi0 : qla2xxx
qla2xxx 0000:06:09.0: LIP reset occurred (f700).
warning: `dhclient3' uses 32-bit capabilities (legacy support in use)
qla2xxx 0000:06:09.0: LOOP UP detected (2 Gbps).
NET: Registered protocol family 17
qla2xxx 0000:06:09.0:=20
 QLogic Fibre Channel HBA Driver: 8.03.01-k10
  QLogic QLA2342 - Sun 133MHz PCI-X to 2Gb FC, Dual Channel
  ISP2312: PCI-X (133 MHz) @ 0000:06:09.0 hdma+, host#=3D0, fw=3D3.03.27 IPX
qla2xxx 0000:06:09.1: PCI INT B -> GSI 37 (level, low) -> IRQ 37
qla2xxx 0000:06:09.1: Found an ISP2312, irq 37, iobase 0xffffc90002a4a000
qla2xxx 0000:06:09.1: Configuring PCI space...
qla2xxx 0000:06:09.1: Configure NVRAM parameters...
qla2xxx 0000:06:09.1: Verifying loaded RISC code...
qla2xxx 0000:06:09.1: Allocated (412 KB) for firmware dump...
qla2xxx 0000:06:09.1: LIP reset occurred (f700).
scsi1 : qla2xxx
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
scsi 0:0:0:0: Direct-Access     transtec T6100F16R1-E     342I PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] physical block alignment offset: 4900352
sd 0:0:0:0: [sda] 15625977856 512-byte logical blocks: (8.00 TB/7.27 TiB)
sd 0:0:0:0: [sda] 8192-byte physical blocks
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 9b 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda:
scsi 0:0:2:0: Direct-Access     transtec PROVIGO 550F48        PQ: 0 ANSI: 5
sd 0:0:2:0: Attached scsi generic sg1 type 0
sd 0:0:2:0: [sdb] 19338633216 512-byte logical blocks: (9.90 TB/9.00 TiB)
sd 0:0:2:0: [sdb] Write Protect is off
sd 0:0:2:0: [sdb] Mode Sense: bf 00 10 08
scsi 0:0:2:1: Direct-Access     transtec PROVIGO 550F48        PQ: 0 ANSI: 5
sd 0:0:2:1: Attached scsi generic sg2 type 0
sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO a=
nd FUA
scsi 0:0:2:2: Direct-Access     transtec PROVIGO 550F48        PQ: 0 ANSI: 5
sd 0:0:2:2: Attached scsi generic sg3 type 0
sd 0:0:2:1: [sdc] 17404379136 512-byte logical blocks: (8.91 TB/8.10 TiB)
scsi 0:0:2:3: Direct-Access     transtec PROVIGO 550F48        PQ: 0 ANSI: 5
sd 0:0:2:2: [sdd] 19338633216 512-byte logical blocks: (9.90 TB/9.00 TiB)
sd 0:0:2:3: Attached scsi generic sg4 type 0
 sdb:
sd 0:0:2:1: [sdc] Write Protect is off
sd 0:0:2:1: [sdc] Mode Sense: bf 00 10 08
sd 0:0:2:2: [sdd] Write Protect is off
sd 0:0:2:2: [sdd] Mode Sense: bf 00 10 08
scsi 0:0:2:4: Processor         transtec PROVIGO 550F48        PQ: 0 ANSI: 5
 unknown partition table
sd 0:0:2:1: [sdc] Write cache: enabled, read cache: enabled, supports DPO a=
nd FUA
sd 0:0:2:2: [sdd] Write cache: enabled, read cache: enabled, supports DPO a=
nd FUA
scsi 0:0:2:4: Attached scsi generic sg5 type 3
 sdd: unknown partition table
 unknown partition table
sd 0:0:2:0: [sdb] Attached SCSI disk
 sdc:
sd 0:0:2:3: [sde] physical block alignment offset: 5206528
sd 0:0:2:3: [sde] 19338633216 512-byte logical blocks: (9.90 TB/9.00 TiB)
sd 0:0:2:3: [sde] 2048-byte physical blocks
 unknown partition table
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:2:2: [sdd] Attached SCSI disk
sd 0:0:2:3: [sde] Write Protect is off
sd 0:0:2:3: [sde] Mode Sense: bf 00 10 08
sd 0:0:2:3: [sde] Write cache: enabled, read cache: enabled, supports DPO a=
nd FUA
sd 0:0:2:1: [sdc] Attached SCSI disk
 sde: unknown partition table
sd 0:0:2:3: [sde] Attached SCSI disk
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
qla2xxx 0000:06:09.1: LOOP UP detected (2 Gbps).
qla2xxx 0000:06:09.1:=20
 QLogic Fibre Channel HBA Driver: 8.03.01-k10
  QLogic QLA2342 - Sun 133MHz PCI-X to 2Gb FC, Dual Channel
  ISP2312: PCI-X (133 MHz) @ 0000:06:09.1 hdma+, host#=3D1, fw=3D3.03.27 IPX
scsi 1:0:0:0: Direct-Access     ADVUNI   OXYGENRAID 416F4 347B PQ: 0 ANSI: 5
sd 1:0:0:0: Attached scsi generic sg6 type 0
sd 1:0:0:0: [sdf] 23438966784 512-byte logical blocks: (12.0 TB/10.9 TiB)
sd 1:0:0:0: [sdf] Write Protect is off
sd 1:0:0:0: [sdf] Mode Sense: 9b 00 00 08
sd 1:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sdf: unknown partition table
sd 1:0:0:0: [sdf] Attached SCSI disk
fuse init (API version 7.13)
Adding 6540152k swap on /dev/md2.  Priority:-1 extents:1 across:6540152k=20
EXT3-fs (md1): using internal journal
scsi 1:0:1:0: Direct-Access     ADVUNI   OXYGENRAID 416F4 347B PQ: 0 ANSI: 5
sd 1:0:1:0: Attached scsi generic sg7 type 0
sd 1:0:1:0: [sdg] 23438966784 512-byte logical blocks: (12.0 TB/10.9 TiB)
sd 1:0:1:0: [sdg] Write Protect is off
sd 1:0:1:0: [sdg] Mode Sense: 9b 00 00 08
sd 1:0:1:0: [sdg] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sdg: unknown partition table
sd 1:0:1:0: [sdg] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md0): using internal journal
EXT3-fs (md0): mounted filesystem with writeback data mode
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ INFO: possible recursive locking detected ]
2.6.33.1 #23
---------------------------------------------
rc.local/3214 is trying to acquire lock:
 (s_active){++++.+}, at: [<ffffffff811492d6>] sysfs_remove_dir+0x76/0xa0

but task is already holding lock:
 (s_active){++++.+}, at: [<ffffffff81149516>] sysfs_get_active_two+0x36/0x50

other info that might help us debug this:
4 locks held by rc.local/3214:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81147b95>] sysfs_write_file+0=
x45/0x160
 #1:  (s_active){++++.+}, at: [<ffffffff81149516>] sysfs_get_active_two+0x3=
6/0x50
 #2:  (s_active){++++.+}, at: [<ffffffff81149502>] sysfs_get_active_two+0x2=
2/0x50
 #3:  (&q->sysfs_lock){+.+.+.}, at: [<ffffffff81237cff>] queue_attr_store+0=
x4f/0xa0

stack backtrace:
Pid: 3214, comm: rc.local Not tainted 2.6.33.1 #23
Call Trace:
 [<ffffffff8106dac6>] validate_chain+0x1016/0x1230
 [<ffffffff8106d737>] ? validate_chain+0xc87/0x1230
 [<ffffffff8106e071>] __lock_acquire+0x391/0xaf0
 [<ffffffff8106989c>] ? lockdep_init_map+0x5c/0x580
 [<ffffffff8106e86c>] lock_acquire+0x9c/0x100
 [<ffffffff811492d6>] ? sysfs_remove_dir+0x76/0xa0
 [<ffffffff8114919e>] sysfs_addrm_finish+0xbe/0x140
 [<ffffffff811492d6>] ? sysfs_remove_dir+0x76/0xa0
 [<ffffffff811492d6>] sysfs_remove_dir+0x76/0xa0
 [<ffffffff81247b16>] kobject_del+0x16/0x40
 [<ffffffff8122e925>] __elv_unregister_queue+0x25/0x30
 [<ffffffff8122efb7>] ? elv_iosched_store+0xb7/0x240
 [<ffffffff8122efe7>] elv_iosched_store+0xe7/0x240
 [<ffffffff81237d13>] queue_attr_store+0x63/0xa0
 [<ffffffff81147c54>] sysfs_write_file+0x104/0x160
 [<ffffffff810eb4d7>] vfs_write+0xc7/0x180
 [<ffffffff810ebaf0>] sys_write+0x50/0x90
 [<ffffffff810023eb>] system_call_fastpath+0x16/0x1b
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-0): warning: mounting fs with errors, running e2fsck is recomme=
nded
EXT3-fs (dm-0): using internal journal
EXT3-fs (dm-0): recovery complete
EXT3-fs (dm-0): mounted filesystem with writeback data mode
EXT4-fs (dm-3): recovery complete
EXT4-fs (dm-3): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-1): using internal journal
EXT3-fs (dm-1): recovery complete
EXT3-fs (dm-1): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-2): warning: mounting fs with errors, running e2fsck is recomme=
nded
EXT3-fs (dm-2): using internal journal
EXT3-fs (dm-2): recovery complete
EXT3-fs (dm-2): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-0): warning: mounting fs with errors, running e2fsck is recomme=
nded
EXT3-fs (dm-0): using internal journal
EXT3-fs (dm-0): mounted filesystem with writeback data mode
qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fdeed 2002.
end_request: I/O error, dev sda, sector 0
qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 10364a 2002.
end_request: I/O error, dev sda, sector 0
qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 10882b 2002.
end_request: I/O error, dev sda, sector 0
qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 10bf74 2002.
end_request: I/O error, dev sda, sector 0
EXT4-fs (sda): mounted filesystem with ordered data mode
qla2xxx 0000:06:09.1: scsi(1:0:0): Abort command issued -- 0 10d3ba3 2003.
qla2xxx 0000:06:09.1: scsi(1:0:0): DEVICE RESET ISSUED.
BUG: unable to handle kernel NULL pointer dereference at 000000000000002c
IP: [<ffffffffa0012ae7>] __qla2x00_marker+0x97/0x400 [qla2xxx]
PGD 2f921c067 PUD 2fdedb067 PMD 0=20
Oops: 0000 [#1] SMP=20
last sysfs file: /sys/block/sdg/dev
CPU 3=20
Pid: 1721, comm: scsi_eh_1 Not tainted 2.6.33.1 #23 /ProLiant DL385 G1
RIP: 0010:[<ffffffffa0012ae7>]  [<ffffffffa0012ae7>] __qla2x00_marker+0x97/=
0x400 [qla2xxx]
RSP: 0018:ffff880179819b70  EFLAGS: 00010082
RAX: ffffc90002a4a012 RBX: ffff88017a419dc0 RCX: 0000000000000081
RDX: ffff88017a419040 RSI: 0000000000000000 RDI: ffff88017f1f5888
RBP: ffff880179819bf0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000000000fa R15: ffffc90002a4a000
FS:  0000000041ff6950(0000) GS:ffff880185900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000002c CR3: 00000002fd47d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process scsi_eh_1 (pid: 1721, threadinfo ffff880179818000, task ffff88017a4=
7f040)
Stack:
 ffff88017a419040 ffffc90002a4a012 ffffc90002a4a018 0081000000000000
<0> 0000000000000000 ffff88017a419dc0 ffff88017a419000 ffff88017a419dc0
<0> ffff88017a419000 0000000000000000 ffff880179819bf0 ffff88017a419dc0
Call Trace:
 [<ffffffffa0012eae>] qla2x00_marker+0x5e/0x90 [qla2xxx]
 [<ffffffffa00114cc>] qla2x00_lun_reset+0xfc/0x180 [qla2xxx]
 [<ffffffff8106b2ad>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa0000752>] __qla2xxx_eh_generic_reset+0x1d2/0x280 [qla2xxx]
 [<ffffffffa00113d0>] ? qla2x00_lun_reset+0x0/0x180 [qla2xxx]
 [<ffffffffa0003070>] qla2xxx_eh_device_reset+0x30/0x40 [qla2xxx]
 [<ffffffff812f4de2>] scsi_try_bus_device_reset+0x32/0x60
 [<ffffffff812f63d0>] scsi_eh_ready_devs+0x300/0x7b0
 [<ffffffff812f7050>] scsi_error_handler+0x450/0x630
 [<ffffffff812f6c00>] ? scsi_error_handler+0x0/0x630
 [<ffffffff8105c31e>] kthread+0x8e/0xa0
 [<ffffffff81003194>] kernel_thread_helper+0x4/0x10
 [<ffffffff8143dafc>] ? restore_args+0x0/0x30
 [<ffffffff8105c290>] ? kthread+0x0/0xa0
 [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10
Code: 63 f8 4c 03 ba 88 00 00 00 49 8d 57 18 49 8d 47 12 41 be fa 00 00 00 =
48 89 55 90 48 8b 55 c0 48 89 45 88 48 83 c2 40 48 89 55 80 <41> 0f b7 55 2=
c 0f b7 c2 83 f8 03 0f 8e 08 01 00 00 49 8b 4d 10=20
RIP  [<ffffffffa0012ae7>] __qla2x00_marker+0x97/0x400 [qla2xxx]
 RSP <ffff880179819b70>
CR2: 000000000000002c
---[ end trace 47e866c3bf686fd0 ]---




#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.33.1
# Thu Mar 18 14:14:02 2010
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
CONFIG_HAVE_KERNEL_LZO=3Dy
CONFIG_KERNEL_GZIP=3Dy
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_POSIX_MQUEUE_SYSCTL=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=3Dy
# CONFIG_AUDITSYSCALL is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=3Dy
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
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
CONFIG_USER_SCHED=3Dy
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=3Dy
CONFIG_SYSFS_DEPRECATED_V2=3Dy
CONFIG_RELAY=3Dy
CONFIG_NAMESPACES=3Dy
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D"initramfs.txt"
CONFIG_INITRAMFS_ROOT_UID=3D0
CONFIG_INITRAMFS_ROOT_GID=3D0
CONFIG_RD_GZIP=3Dy
CONFIG_RD_BZIP2=3Dy
CONFIG_RD_LZMA=3Dy
CONFIG_RD_LZO=3Dy
CONFIG_INITRAMFS_COMPRESSION_NONE=3Dy
# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set
# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
# CONFIG_INITRAMFS_COMPRESSION_LZMA is not set
# CONFIG_INITRAMFS_COMPRESSION_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
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
CONFIG_COMPAT_BRK=3Dy
CONFIG_SLAB=3Dy
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=3Dy
CONFIG_HAVE_OPROFILE=3Dy
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_ATTRS=3Dy
CONFIG_HAVE_DMA_API_DEBUG=3Dy
CONFIG_HAVE_HW_BREAKPOINT=3Dy
CONFIG_HAVE_USER_RETURN_NOTIFIER=3Dy

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=3Dy
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=3Dy
CONFIG_MODULE_SRCVERSION_ALL=3Dy
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=3Dy
CONFIG_X86_EXTENDED_PLATFORM=3Dy
# CONFIG_X86_VSMP is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
# CONFIG_PARAVIRT_GUEST is not set
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
CONFIG_MK8=3Dy
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
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=3Dy
CONFIG_X86_INTERNODE_CACHE_SHIFT=3D7
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
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
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=3D4
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
CONFIG_PREEMPT_NONE=3Dy
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=3Dy
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=3Dy
CONFIG_X86_MCE_THRESHOLD=3Dy
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
CONFIG_NUMA=3Dy
CONFIG_K8_NUMA=3Dy
CONFIG_X86_64_ACPI_NUMA=3Dy
CONFIG_NODES_SPAN_OTHER_NODES=3Dy
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=3D6
CONFIG_ARCH_PROC_KCORE_TEXT=3Dy
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ILLEGAL_POINTER_VALUE=3D0xdead000000000000
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D999999
CONFIG_MIGRATION=3Dy
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=3Dy
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=3Dy
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=3Dy
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=3D0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x1000000
CONFIG_HOTPLUG_CPU=3Dy
CONFIG_COMPAT_VDSO=3Dy
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=3Dy

#
# Power management and ACPI options
#
CONFIG_PM=3Dy
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=3Dy
CONFIG_PM_SLEEP=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_SUSPEND_FREEZER=3Dy
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
CONFIG_ACPI_PROCFS_POWER=3Dy
CONFIG_ACPI_SYSFS_POWER=3Dy
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_FAN=3Dy
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=3Dy
CONFIG_ACPI_HOTPLUG_CPU=3Dy
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=3Dy
CONFIG_ACPI_NUMA=3Dy
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dy
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dm
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=3Dm
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dm
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=3Dy
CONFIG_PCIEPORTBUS=3Dy
CONFIG_PCIEAER=3Dy
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=3Dy
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=3Dy
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=3Dy
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_K8_NB=3Dy
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dy
CONFIG_IA32_EMULATION=3Dy
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dm
CONFIG_PACKET_MMAP=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dm
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=3Dm
CONFIG_NET_KEY=3Dm
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=3Dy
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE=3Dm
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
CONFIG_INET_AH=3Dm
CONFIG_INET_ESP=3Dm
CONFIG_INET_IPCOMP=3Dm
CONFIG_INET_XFRM_TUNNEL=3Dm
CONFIG_INET_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dy
CONFIG_INET_XFRM_MODE_TUNNEL=3Dy
CONFIG_INET_XFRM_MODE_BEET=3Dy
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=3Dy
CONFIG_INET_TCP_DIAG=3Dy
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=3Dy
CONFIG_WIRELESS=3Dy
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
CONFIG_FIRMWARE_IN_KERNEL=3Dy
CONFIG_EXTRA_FIRMWARE=3D""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=3Dy
CONFIG_PNP_DEBUG_MESSAGES=3Dy

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=3Dy
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dm
CONFIG_BLK_DEV_CRYPTOLOOP=3Dm

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=3Dy
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=3Dy
CONFIG_IDE=3Dy

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=3Dy
CONFIG_IDE_TIMINGS=3Dy
CONFIG_IDE_ATAPI=3Dy
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=3Dy
CONFIG_IDE_GD_ATA=3Dy
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=3Dy
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=3Dy
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=3Dy

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=3Dy

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=3Dy
CONFIG_IDEPCI_PCIBUS_ORDER=3Dy
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=3Dy
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=3Dy
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=3Dy

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=3Dy
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=3Dy
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dy
CONFIG_SCSI_FC_ATTRS=3Dy
CONFIG_SCSI_ISCSI_ATTRS=3Dy
CONFIG_SCSI_SAS_ATTRS=3Dm
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=3Dy
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=3Dm
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_AUTODETECT=3Dy
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=3Dy
CONFIG_MD_RAID1=3Dy
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=3Dm
CONFIG_MD_FAULTY=3Dm
CONFIG_BLK_DEV_DM=3Dy
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=3Dy
CONFIG_DM_MIRROR=3Dy
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=3Dy
CONFIG_DM_MULTIPATH=3Dy
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=3Dy
CONFIG_FUSION_SPI=3Dm
CONFIG_FUSION_FC=3Dm
CONFIG_FUSION_SAS=3Dm
CONFIG_FUSION_MAX_SGE=3D128
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
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
CONFIG_DUMMY=3Dm
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=3Dm

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=3Dm
CONFIG_NETDEV_1000=3Dy
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=3Dm
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=3Dy
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=3Dy
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
# CONFIG_TR is not set
CONFIG_WLAN=3Dy
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

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
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=3Dm
CONFIG_USB_NET_NET1080=3Dm
CONFIG_USB_NET_PLUSB=3Dm
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=3Dm
CONFIG_USB_NET_CDC_SUBSET=3Dm
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_ARMLINUX=3Dy
CONFIG_USB_EPSON2888=3Dy
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=3Dm
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=3Dy
CONFIG_NETCONSOLE=3Dm
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=3Dy
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
CONFIG_KEYBOARD_LKKBD=3Dy
CONFIG_KEYBOARD_NEWTON=3Dy
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=3Dy
CONFIG_KEYBOARD_XTKBD=3Dy
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dm
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=3Dm
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=3Dy
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D48
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_MANY_PORTS=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=3Dy

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_JSM=3Dm
CONFIG_UNIX98_PTYS=3Dy
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=3Dy
CONFIG_HW_RANDOM_AMD=3Dy
CONFIG_HW_RANDOM_VIA=3Dy
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
CONFIG_GEN_RTC=3Dy
# CONFIG_GEN_RTC_X is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=3Dy
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=3Dy
CONFIG_AGP_AMD64=3Dy
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=3Dy
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=3Dm
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=3Dy
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dy
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dy
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=3Dy

#
# Special HID drivers
#
CONFIG_HID_A4TECH=3Dy
CONFIG_HID_APPLE=3Dy
CONFIG_HID_BELKIN=3Dy
CONFIG_HID_CHERRY=3Dy
CONFIG_HID_CHICONY=3Dy
CONFIG_HID_CYPRESS=3Dy
CONFIG_HID_DRAGONRISE=3Dy
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=3Dy
CONFIG_HID_KYE=3Dy
CONFIG_HID_GYRATION=3Dy
CONFIG_HID_TWINHAN=3Dy
CONFIG_HID_KENSINGTON=3Dy
CONFIG_HID_LOGITECH=3Dy
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=3Dy
CONFIG_HID_MONTEREY=3Dy
CONFIG_HID_NTRIG=3Dy
CONFIG_HID_PANTHERLORD=3Dy
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=3Dy
CONFIG_HID_SAMSUNG=3Dy
CONFIG_HID_SONY=3Dy
CONFIG_HID_SUNPLUS=3Dy
CONFIG_HID_GREENASIA=3Dy
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=3Dy
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=3Dy
CONFIG_HID_THRUSTMASTER=3Dy
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=3Dy
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dy
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
CONFIG_USB_DEVICE_CLASS=3Dy
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=3Dy
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_EZUSB=3Dy
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=3Dm
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=3Dm
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
CONFIG_USB_SERIAL_KEYSPAN=3Dm
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=3Dm
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=3Dm
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=3Dm
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=3Dy
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=3Dy
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dm
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dy
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
CONFIG_EXT4_FS=3Dy
CONFIG_EXT4_FS_XATTR=3Dy
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=3Dy
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=3Dy
CONFIG_JBD2_DEBUG=3Dy
CONFIG_FS_MBCACHE=3Dy
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=3Dy
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=3Dy
CONFIG_FSNOTIFY=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_QUOTA=3Dy
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=3Dy
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=3Dy
CONFIG_AUTOFS_FS=3Dm
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

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
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
CONFIG_CONFIGFS_FS=3Dm
CONFIG_MISC_FILESYSTEMS=3Dy
CONFIG_ADFS_FS=3Dm
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=3Dm
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dy
CONFIG_NFS_V3=3Dy
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=3Dy
# CONFIG_NFS_V4_1 is not set
CONFIG_NFSD=3Dy
CONFIG_NFSD_V3=3Dy
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=3Dy
CONFIG_LOCKD=3Dy
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dy
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dy
CONFIG_SUNRPC_GSS=3Dy
CONFIG_RPCSEC_GSS_KRB5=3Dy
CONFIG_RPCSEC_GSS_SPKM3=3Dy
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=3Dy
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"cp437"
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
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_FRAME_WARN=3D2048
CONFIG_MAGIC_SYSRQ=3Dy
# CONFIG_STRIP_ASM_SYMS is not set
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
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_DEBUG_KMEMLEAK=3Dy
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=3D400
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
CONFIG_DEBUG_RT_MUTEXES=3Dy
CONFIG_DEBUG_PI_LIST=3Dy
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
CONFIG_DEBUG_LOCK_ALLOC=3Dy
CONFIG_PROVE_LOCKING=3Dy
CONFIG_LOCKDEP=3Dy
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=3Dy
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=3Dy
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_INFO=3Dy
CONFIG_DEBUG_VM=3Dy
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=3Dy
CONFIG_DEBUG_MEMORY_INIT=3Dy
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
CONFIG_FRAME_POINTER=3Dy
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=3Dy
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
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
CONFIG_TRACING=3Dy
CONFIG_GENERIC_TRACER=3Dy
CONFIG_TRACING_SUPPORT=3Dy
CONFIG_FTRACE=3Dy
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_BOOT_TRACER is not set
CONFIG_BRANCH_PROFILE_NONE=3Dy
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_KSYM_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=3Dy
CONFIG_FTRACE_SELFTEST=3Dy
CONFIG_FTRACE_STARTUP_TEST=3Dy
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=3Dy
# CONFIG_KMEMCHECK is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=3Dy
CONFIG_EARLY_PRINTK=3Dy
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
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
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=3Dy
CONFIG_DEFAULT_SECURITY=3D""
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD=3Dm
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_PCOMP=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=3Dy
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=3Dm
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dy
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=3Dm
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=3Dm
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=3Dy
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dm
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=3Dy
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=3Dm
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=3Dy
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=3Dy
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=3Dy
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=3Dy
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=3Dy
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=3Dy
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=3Dy
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=3Dy
CONFIG_VIRTUALIZATION=3Dy
# CONFIG_KVM is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=3Dy

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_GENERIC_FIND_NEXT_BIT=3Dy
CONFIG_GENERIC_FIND_LAST_BIT=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dy
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=3Dm
CONFIG_CRC32=3Dy
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=3Dm
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
CONFIG_LZO_DECOMPRESS=3Dy
CONFIG_DECOMPRESS_GZIP=3Dy
CONFIG_DECOMPRESS_BZIP2=3Dy
CONFIG_DECOMPRESS_LZMA=3Dy
CONFIG_DECOMPRESS_LZO=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_NLATTR=3Dy
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--DRfr/2Y1Zz/5r+Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLq8cqWto1QDEAkw8RAt67AJsEDe5o9HbhWIc364IjEn/oSQ0JPwCfW9Y4
+KHppN1VgO7lU6Wo01TrgKo=
=shY1
-----END PGP SIGNATURE-----

--DRfr/2Y1Zz/5r+Kb--
