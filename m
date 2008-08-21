From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Thu, 21 Aug 2008 08:43:33 -0700
Message-ID: <20080821084333.c471b439.randy.dunlap@oracle.com>
References: <48AD02B2.7020004@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A778835116209D3@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__21_Aug_2008_08_43_33_-0700_nZXE3aArB87C=Un5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:53061 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYHUPnh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 11:43:37 -0400
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778835116209D3@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>

This is a multi-part message in MIME format.

--Multipart=_Thu__21_Aug_2008_08_43_33_-0700_nZXE3aArB87C=Un5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 21 Aug 2008 14:26:06 +0000 Miller, Mike (OS Dev) wrote:

> 
> 
> > -----Original Message-----
> > From: rdunlap [mailto:randy.dunlap@oracle.com]
> > Sent: Thursday, August 21, 2008 12:53 AM
> > To: lkml; scsi; Miller, Mike (OS Dev)
> > Subject: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
> >
> > on x86_64, 4 proc, 8 GB RAM:
> >
> > calling  cciss_init+0x0/0x2e [cciss]
> > HP CISS Driver (v 3.6.20)
> > ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54 cciss
> > 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high)
> > -> IRQ 54
> > cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 503 using DAC
> > BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000248
> > IP: [<ffffffffa001bb68>] do_cciss_intr+0x627/0xa6c [cciss]
> > PGD 17e422067 PUD 17e423067 PMD 0
> > Oops: 0002 [1] SMP
> > CPU 2
> > Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
> > Pid: 0, comm: swapper Not tainted 2.6.27-rc3-git7 #1
> > RIP: 0010:[<ffffffffa001bb68>]  [<ffffffffa001bb68>]
> > do_cciss_intr+0x627/0xa6c [cciss]
> > RSP: 0018:ffff88027f66fee8  EFLAGS: 00010007
> > RAX: 0000000000000000 RBX: ffff88007f840270 RCX: 000000000000000c
> > RDX: 0000000000000000 RSI: ffff88027e5c0000 RDI: ffff88027e5c0000
> > RBP: ffff88027f66ff18 R08: 0000000000000000 R09: ffff88017fa95e88
> > R10: 0000000000000000 R11: ffff88027f66ff48 R12: ffff88027e5c0000
> > R13: 0000000000000000 R14: 00000000000001f7 R15: 0000000000000086
> > FS:  0000000000680850(0000) GS:ffff88017fc02c80(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 0000000000000248 CR3: 000000017e425000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > 0000000000000400 Process swapper (pid: 0, threadinfo
> > ffff88017fa94000, task ffff88027f63d340)
> > Stack:  ffff88027f66fee0 ffff88017e9b4800 0000000000000000
> > 0000000000000000
> >  00000000000001f7 0000000000000000 ffff88027f66ff48
> > ffffffff8026757e  ffffffff80719000 00000000000001f7
> > ffff88017e9b4800 ffffffff80719050 Call Trace:
> >  <IRQ>  [<ffffffff8026757e>] handle_IRQ_event+0x27/0x57
> > [<ffffffff80268d08>] handle_edge_irq+0xed/0x12e
> > [<ffffffff8020eaab>] do_IRQ+0xf6/0x167  [<ffffffff8020c471>]
> > ret_from_intr+0x0/0xa  <EOI>  [<ffffffff802122b1>] ?
> > default_idle+0x2b/0x40  [<ffffffff802124bf>] ?
> > c1e_idle+0xd4/0xdb  [<ffffffff8055677d>] ?
> > atomic_notifier_call_chain+0xf/0x11
> >  [<ffffffff8020ac6c>] ? cpu_idle+0x71/0x8f
> > [<ffffffff8054e752>] ? start_secondary+0x157/0x15c
> >
> >
> > Code: 8b 83 48 02 00 00 48 39 d8 74 37 49 39 9c 24 c0 00 01
> > 00 75 08 49 89 84 24 c0 00 01 00 48 8b 83 40 02 00 00 48 8b
> > 93 48 02 00 00 <48> 89 90 48 02 00 00 48 8b 93 48 02 00 00 48
> > 89 82 40 02 00 00 RIP  [<ffffffffa001bb68>]
> > do_cciss_intr+0x627/0xa6c [cciss]  RSP <ffff88027f66fee8>
> > CR2: 0000000000000248
> > ---[ end trace 902dc79a9e72d3ed ]---
> >
> 
> Randy,
> Sorry I haven't replied sooner. I saw your earlier mail, just been busy breaking stuff internally. Did this happen during driver init or runtime?

Hi Mike,

It's very much during driver init.

Full boot log and .config are attached.

Andrew:  I'll rerun the test ASAP.  Machine is busy atm.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

--Multipart=_Thu__21_Aug_2008_08_43_33_-0700_nZXE3aArB87C=Un5
Content-Type: text/x-log;
 name="netcon-4883.log"
Content-Disposition: attachment;
 filename="netcon-4883.log"
Content-Transfer-Encoding: quoted-printable

Linux version 2.6.27-rc3-git7 (root@ca-ostest293.us.oracle.com) (gcc versio=
n 4.1.1 20070105 (Red Hat 4.1.1-52)) #1 SMP Wed Aug 20 16:45:40 PDT 2008
Command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=3D5488=
3@139.185.50.77/eth0,54883@139.185.50.76/00:18:FE:34:1C:3D debug ignore_log=
level initcall_debug 3 kex
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
 BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
 BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000027ffff000 (usable)
debug: ignoring loglevel setting.
last_pfn =3D 0x27ffff max_arch_pfn =3D 0x3ffffffff
last_pfn =3D 0x7fe50 max_arch_pfn =3D 0x3ffffffff
init_memory_mapping
 0000000000 - 007fe00000 page 2M
 007fe00000 - 007fe50000 page 4k
kernel direct mapping tables up to 7fe50000 @ 8000-c000
last_map_addr: 7fe50000 end: 7fe50000
init_memory_mapping
 0100000000 - 027fe00000 page 2M
 027fe00000 - 027ffff000 page 4k
kernel direct mapping tables up to 27ffff000 @ a000-16000
last_map_addr: 27ffff000 end: 27ffff000
RAMDISK: 7fd05000 - 7fe4f87e
DMI 2.3 present.
ACPI: RSDP 000F4F00, 0024 (r2 HP    )
ACPI: XSDT 7FE50780, 005C (r1 HP     A08             2   =D2=04     162E)
ACPI: FACP 7FE50800, 00F4 (r3 HP     A08             2   =D2=04     162E)
ACPI: DSDT 7FE50900, 3F75 (r1 HP         DSDT        1 INTL 20030228)
ACPI: FACS 7FE50100, 0040
ACPI: SPCR 7FE50140, 0050 (r1 HP     SPCRRBSU        1   =D2=04     162E)
ACPI: MCFG 7FE501C0, 003C (r1 HP     ProLiant        1             0)
ACPI: HPET 7FE50200, 0038 (r1 HP     A08             2   =D2=04     162E)
ACPI: SPMI 7FE50240, 0040 (r5 HP     ProLiant        1   =D2=04     162E)
ACPI: APIC 7FE50280, 00DE (r1 HP     00000083        2             0)
ACPI: SRAT 7FE50380, 0110 (r1 AMD    HAMMER          1 AMD         1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-180000000
SRAT: Node 1 PXM 1 180000000-280000000
NUMA: Allocated memnodemap from 11000 - 16080
NUMA: Using 20 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [0000000000017000 -  0000000000046fff] pages 30
(8 early reservations) =3D=3D> bootmem [0000000000 - 0180000000]
  #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0000000000 - 00000=
01000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [0000006000 - 00000=
08000]
  #2 [0000200000 - 000086c4d0]    TEXT DATA BSS =3D=3D> [0000200000 - 00008=
6c4d0]
  #3 [007fd05000 - 007fe4f87e]          RAMDISK =3D=3D> [007fd05000 - 007fe=
4f87e]
  #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000009f400 - 00001=
00000]
  #5 [0000008000 - 000000a000]          PGTABLE =3D=3D> [0000008000 - 00000=
0a000]
  #6 [000000a000 - 0000011000]          PGTABLE =3D=3D> [000000a000 - 00000=
11000]
  #7 [0000011000 - 0000016080]       MEMNODEMAP =3D=3D> [0000011000 - 00000=
16080]
Bootmem setup node 1 0000000180000000-000000027ffff000
  NODE_DATA [0000000180000000 - 0000000180003fff]
  bootmap [0000000180004000 -  0000000180023fff] pages 20
(8 early reservations) =3D=3D> bootmem [0180000000 - 027ffff000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0000200000 - 000086c4d0]    TEXT DATA BSS
  #3 [007fd05000 - 007fe4f87e]          RAMDISK
  #4 [000009f400 - 0000100000]    BIOS reserved
  #5 [0000008000 - 000000a000]          PGTABLE
  #6 [000000a000 - 0000011000]          PGTABLE
  #7 [0000011000 - 0000016080]       MEMNODEMAP
found SMP MP-table at [ffff8800000f4f80] 000f4f80
 [ffffe20000000000-ffffe200053fffff] PMD -> [ffff880028200000-ffff88002b9ff=
fff] on node 0
 [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff880180200000-ffff8801839ff=
fff] on node 1
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0027ffff
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0007fe50
    0: 0x00100000 -> 0x00180000
    1: 0x00180000 -> 0x0027ffff
On node 0 totalpages: 1048046
  DMA zone: 2183 pages, LIFO batch:0
  DMA32 zone: 505480 pages, LIFO batch:31
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048575
  Normal zone: 1034239 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xf7df0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xf7df0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfdef0000] gsi_base[38])
IOAPIC[1]: apic_id 9, version 0, address 0xfdef0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10228201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 000000007fe50000 - 000000007fe58000
PM: Registered nosave memory: 000000007fe58000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
PERCPU: Allocating 47784 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 2
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 2059022
Policy zone: Normal
Kernel command line: root=3DLABEL=3D/ selinux=3D0 console=3Dtty0 netconsole=
=3D54883@139.185.50.77/eth0,54883@139.185.50.76/00:18:FE:34:1C:3D debug ign=
ore_loglevel initcall_debug 3 kex
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Detected 1004.627 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Node 0: aperture @ c000000 size 64 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Memory: 8197672k/10485756k available (3436k kernel code, 188812k reserved, =
1715k data, 396k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D2
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. =
2009.25 BogoMIPS (lpj=3D4018508)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080609
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Using local APIC timer interrupts.
APIC timer calibration result 12557859
Detected 12.557 MHz APIC timer.
calling  migration_init+0x0/0x5b
initcall migration_init+0x0/0x5b returned 1 after 0 msecs
initcall migration_init+0x0/0x5b returned with error code 1=20
calling  spawn_ksoftirqd+0x0/0x58
initcall spawn_ksoftirqd+0x0/0x58 returned 0 after 0 msecs
calling  init_call_single_data+0x0/0x47
initcall init_call_single_data+0x0/0x47 returned 0 after 0 msecs
calling  spawn_softlockup_task+0x0/0x74
initcall spawn_softlockup_task+0x0/0x74 returned 0 after 0 msecs
calling  relay_init+0x0/0x14
initcall relay_init+0x0/0x14 returned 0 after 0 msecs
Booting processor 1/2 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2009.34 BogoMIPS (lpj=3D40=
18684)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 2009.42 BogoMIPS (lpj=3D40=
18850)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 2009.36 BogoMIPS (lpj=3D40=
18726)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (8037.38 BogoMIPS).
khelper used greatest stack depth: 6008 bytes left
calling  init_cpufreq_transition_notifier_list+0x0/0x1b
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 =
msecs
calling  net_ns_init+0x0/0x15d
net_namespace: 592 bytes
initcall net_ns_init+0x0/0x15d returned 0 after 0 msecs
calling  cpufreq_tsc+0x0/0x16
initcall cpufreq_tsc+0x0/0x16 returned 0 after 0 msecs
calling  init_smp_flush+0x0/0x41
initcall init_smp_flush+0x0/0x41 returned 0 after 0 msecs
calling  sysctl_init+0x0/0x16
initcall sysctl_init+0x0/0x16 returned 0 after 0 msecs
calling  ksysfs_init+0x0/0xbb
initcall ksysfs_init+0x0/0xbb returned 0 after 0 msecs
calling  init_jiffies_clocksource+0x0/0x12
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 msecs
calling  pm_init+0x0/0x34
initcall pm_init+0x0/0x34 returned 0 after 0 msecs
calling  pm_disk_init+0x0/0x19
initcall pm_disk_init+0x0/0x19 returned 0 after 0 msecs
calling  swsusp_header_init+0x0/0x2c
initcall swsusp_header_init+0x0/0x2c returned 0 after 0 msecs
calling  filelock_init+0x0/0x2e
initcall filelock_init+0x0/0x2e returned 0 after 0 msecs
calling  init_misc_binfmt+0x0/0x3f
initcall init_misc_binfmt+0x0/0x3f returned 0 after 0 msecs
calling  init_script_binfmt+0x0/0x12
initcall init_script_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_elf_binfmt+0x0/0x12
initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  init_compat_elf_binfmt+0x0/0x12
initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  debugfs_init+0x0/0x51
initcall debugfs_init+0x0/0x51 returned 0 after 0 msecs
calling  random32_init+0x0/0xcc
initcall random32_init+0x0/0xcc returned 0 after 0 msecs
calling  cpufreq_core_init+0x0/0x76
initcall cpufreq_core_init+0x0/0x76 returned 0 after 0 msecs
calling  cpuidle_init+0x0/0x40
initcall cpuidle_init+0x0/0x40 returned 0 after 0 msecs
calling  sock_init+0x0/0x59
initcall sock_init+0x0/0x59 returned 0 after 0 msecs
calling  netpoll_init+0x0/0x31
initcall netpoll_init+0x0/0x31 returned 0 after 0 msecs
calling  netlink_proto_init+0x0/0x14d
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x14d returned 0 after 3 msecs
calling  bdi_class_init+0x0/0x41
initcall bdi_class_init+0x0/0x41 returned 0 after 0 msecs
calling  kobject_uevent_init+0x0/0x45
initcall kobject_uevent_init+0x0/0x45 returned 0 after 0 msecs
calling  pcibus_class_init+0x0/0x19
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 msecs
calling  pci_driver_init+0x0/0x12
initcall pci_driver_init+0x0/0x12 returned 0 after 0 msecs
calling  backlight_class_init+0x0/0x4d
initcall backlight_class_init+0x0/0x4d returned 0 after 0 msecs
calling  tty_class_init+0x0/0x31
initcall tty_class_init+0x0/0x31 returned 0 after 0 msecs
calling  vtconsole_class_init+0x0/0xc3
initcall vtconsole_class_init+0x0/0xc3 returned 0 after 0 msecs
calling  register_node_type+0x0/0x6b
initcall register_node_type+0x0/0x6b returned 0 after 0 msecs
calling  enable_pci_io_ecs+0x0/0x2e
initcall enable_pci_io_ecs+0x0/0x2e returned 0 after 0 msecs
calling  early_fill_mp_bus_info+0x0/0x7ed
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00,3f] on node 0 link 1
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [90000000, fddfffff]
bus: 00 index 2 mmio: [80000000, 83ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [280000000, fcffffffff]
bus: [40,ff] on node 1 link 2
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [fde00000, fdffffff]
bus: 40 index 2 mmio: [84000000, 8fffffff]
initcall early_fill_mp_bus_info+0x0/0x7ed returned 0 after 3 msecs
calling  arch_kdebugfs_init+0x0/0x24
initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 msecs
calling  mtrr_if_init+0x0/0x77
initcall mtrr_if_init+0x0/0x77 returned 0 after 0 msecs
calling  ffh_cstate_init+0x0/0x31
initcall ffh_cstate_init+0x0/0x31 returned -1 after 0 msecs
initcall ffh_cstate_init+0x0/0x31 returned with error code -1=20
calling  acpi_pci_init+0x0/0x57
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x57 returned 0 after 0 msecs
calling  init_acpi_device_notify+0x0/0x4b
initcall init_acpi_device_notify+0x0/0x4b returned 0 after 0 msecs
calling  dmi_id_init+0x0/0x2f0
initcall dmi_id_init+0x0/0x2f0 returned 0 after 0 msecs
calling  pci_arch_init+0x0/0x4e
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
PCI: HP ProLiant BL685c G1 detected, enabling pci=3Dbfsort.
initcall pci_arch_init+0x0/0x4e returned 0 after 3 msecs
calling  topology_init+0x0/0x73
initcall topology_init+0x0/0x73 returned 0 after 0 msecs
calling  mtrr_init_finialize+0x0/0x3d
initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 msecs
calling  param_sysfs_init+0x0/0x1e7
initcall param_sysfs_init+0x0/0x1e7 returned 0 after 3 msecs
calling  pm_sysrq_init+0x0/0x19
initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 msecs
calling  readahead_init+0x0/0x38
initcall readahead_init+0x0/0x38 returned 0 after 0 msecs
calling  init_bio+0x0/0xc5
initcall init_bio+0x0/0xc5 returned 0 after 0 msecs
calling  blk_settings_init+0x0/0x2a
initcall blk_settings_init+0x0/0x2a returned 0 after 0 msecs
calling  blk_ioc_init+0x0/0x2a
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 msecs
calling  genhd_device_init+0x0/0x55
initcall genhd_device_init+0x0/0x55 returned 0 after 0 msecs
calling  pci_slot_init+0x0/0x45
initcall pci_slot_init+0x0/0x45 returned 0 after 0 msecs
calling  fbmem_init+0x0/0x91
initcall fbmem_init+0x0/0x91 returned 0 after 0 msecs
calling  acpi_init+0x0/0x21d
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 7FE58000, 04F0 (r2 HP     PNOWSSDT        2 HP          1)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 80000000 segment 0 buses 0 - 255
PCI: MCFG area at 80000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at 80000000 - 8fffffff
initcall acpi_init+0x0/0x21d returned 0 after 22 msecs
calling  acpi_scan_init+0x0/0x11e
initcall acpi_scan_init+0x0/0x11e returned 0 after 7 msecs
calling  acpi_ec_init+0x0/0x61
initcall acpi_ec_init+0x0/0x61 returned 0 after 0 msecs
calling  acpi_pci_root_init+0x0/0x28
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:01:03.0: supports D1
pci 0000:01:03.0: supports D2
pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
pci 0000:01:04.0: PME# disabled
pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
pci 0000:01:04.2: PME# disabled
pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
pci 0000:01:04.4: PME# disabled
pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
pci 0000:01:04.6: PME# disabled
pci 0000:00:09.0: transparent bridge
PCI: bridge 0000:00:09.0 io port: [1000, 2fff]
PCI: bridge 0000:00:09.0 32bit mmio: [f7e00000, f7ffffff]
PCI: bridge 0000:00:09.0 32bit mmio pref: [e8000000, efffffff]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
PCI: bridge 0000:00:0b.0 32bit mmio: [f8000000, f9ffffff]
PCI: bridge 0000:00:0b.0 64bit mmio pref: [90000000, 900fffff]
pci 0000:03:00.0: PME# supported from D3hot D3cold
pci 0000:03:00.0: PME# disabled
PCI: bridge 0000:02:00.0 32bit mmio: [f8000000, f9ffffff]
PCI: bridge 0000:02:00.0 64bit mmio pref: [90000000, 900fffff]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
PCI: bridge 0000:00:0c.0 32bit mmio: [fa000000, fbffffff]
PCI: bridge 0000:00:0c.0 64bit mmio pref: [90100000, 901fffff]
pci 0000:05:00.0: PME# supported from D3hot D3cold
pci 0000:05:00.0: PME# disabled
PCI: bridge 0000:04:00.0 32bit mmio: [fa000000, fbffffff]
PCI: bridge 0000:04:00.0 64bit mmio pref: [90100000, 901fffff]
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
PCI: bridge 0000:00:0d.0 32bit mmio: [fdc00000, fdcfffff]
PCI: bridge 0000:00:0d.0 64bit mmio pref: [90200000, 902fffff]
pci 0000:07:04.0: PME# supported from D3hot D3cold
pci 0000:07:04.0: PME# disabled
pci 0000:07:04.1: PME# supported from D3hot D3cold
pci 0000:07:04.1: PME# disabled
PCI: bridge 0000:06:00.0 32bit mmio: [fdc00000, fdcfffff]
PCI: bridge 0000:06:00.0 64bit mmio pref: [90200000, 902fffff]
PCI: bridge 0000:00:0e.0 io port: [3000, 3fff]
PCI: bridge 0000:00:0e.0 32bit mmio: [fdd00000, fddfffff]
PCI: bridge 0000:00:0e.0 64bit mmio pref: [90300000, 903fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1.NB01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2.NC1B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE3.NC2B._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0c.0: PME# disabled
pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0d.0: PME# disabled
pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0e.0: PME# disabled
pci 0000:41:00.0: PME# supported from D0 D3hot D3cold
pci 0000:41:00.0: PME# disabled
PCI: bridge 0000:40:0c.0 io port: [4000, 4fff]
PCI: bridge 0000:40:0c.0 32bit mmio: [fdf00000, fdffffff]
PCI: bridge 0000:40:0c.0 64bit mmio pref: [90400000, 904fffff]
pci 0000:42:08.0: supports D1
PCI: bridge 0000:41:00.0 io port: [4000, 4fff]
PCI: bridge 0000:41:00.0 32bit mmio: [fdf00000, fdffffff]
PCI: bridge 0000:41:00.0 64bit mmio pref: [90400000, 904fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2.SASB._PRT]
initcall acpi_pci_root_init+0x0/0x28 returned 0 after 30 msecs
calling  acpi_pci_link_init+0x0/0x48
ACPI: PCI Interrupt Link [LNKW] (IRQs *16)
ACPI: PCI Interrupt Link [LNKX] (IRQs *17)
ACPI: PCI Interrupt Link [LNKY] (IRQs *18)
ACPI: PCI Interrupt Link [LNKZ] (IRQs *19)
ACPI: PCI Interrupt Link [LNU0] (IRQs *22)
ACPI: PCI Interrupt Link [LNU2] (IRQs *23)
ACPI: PCI Interrupt Link [LNKA] (IRQs *54)
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
initcall acpi_pci_link_init+0x0/0x48 returned 0 after 7 msecs
calling  acpi_power_init+0x0/0x77
initcall acpi_power_init+0x0/0x77 returned 0 after 0 msecs
calling  acpi_system_init+0x0/0x260
initcall acpi_system_init+0x0/0x260 returned 0 after 0 msecs
calling  acpi_cm_sbs_init+0x0/0x8
initcall acpi_cm_sbs_init+0x0/0x8 returned 0 after 0 msecs
calling  pnp_init+0x0/0x20
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall pnp_init+0x0/0x20 returned 0 after 0 msecs
calling  pnpacpi_init+0x0/0x8c
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8c returned 0 after 7 msecs
calling  misc_init+0x0/0x9f
initcall misc_init+0x0/0x9f returned 0 after 0 msecs
calling  cn_init+0x0/0xee
initcall cn_init+0x0/0xee returned 0 after 0 msecs
calling  phy_init+0x0/0x31
initcall phy_init+0x0/0x31 returned 0 after 0 msecs
calling  init_scsi+0x0/0x91
SCSI subsystem initialized
initcall init_scsi+0x0/0x91 returned 0 after 0 msecs
calling  usb_init+0x0/0x122
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x122 returned 0 after 0 msecs
calling  serio_init+0x0/0x89
initcall serio_init+0x0/0x89 returned 0 after 0 msecs
calling  input_init+0x0/0x10e
initcall input_init+0x0/0x10e returned 0 after 0 msecs
calling  rtc_init+0x0/0x71
initcall rtc_init+0x0/0x71 returned 0 after 0 msecs
calling  i2c_init+0x0/0x66
initcall i2c_init+0x0/0x66 returned 0 after 0 msecs
calling  power_supply_class_init+0x0/0x38
initcall power_supply_class_init+0x0/0x38 returned 0 after 0 msecs
calling  hwmon_init+0x0/0x42
initcall hwmon_init+0x0/0x42 returned 0 after 0 msecs
calling  thermal_init+0x0/0x58
initcall thermal_init+0x0/0x58 returned 0 after 0 msecs
calling  pci_subsys_init+0x0/0x12c
PCI: Using ACPI for IRQ routing
pci 0000:40:0c.0: BAR 9: can't allocate resource
pci 0000:41:00.0: BAR 9: can't allocate resource
initcall pci_subsys_init+0x0/0x12c returned 0 after 0 msecs
calling  proto_init+0x0/0x2e
initcall proto_init+0x0/0x2e returned 0 after 0 msecs
calling  net_dev_init+0x0/0x146
initcall net_dev_init+0x0/0x146 returned 0 after 0 msecs
calling  neigh_init+0x0/0x71
initcall neigh_init+0x0/0x71 returned 0 after 0 msecs
calling  fib_rules_init+0x0/0xa6
initcall fib_rules_init+0x0/0xa6 returned 0 after 0 msecs
calling  genl_init+0x0/0xd9
initcall genl_init+0x0/0xd9 returned 0 after 15 msecs
calling  sysctl_init+0x0/0x49
initcall sysctl_init+0x0/0x49 returned 0 after 0 msecs
calling  pci_iommu_init+0x0/0x12
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
initcall pci_iommu_init+0x0/0x12 returned 0 after 3 msecs
calling  hpet_late_init+0x0/0x114
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
initcall hpet_late_init+0x0/0x114 returned 0 after 0 msecs
calling  clocksource_done_booting+0x0/0x12
initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 msecs
calling  init_pipe_fs+0x0/0x4c
initcall init_pipe_fs+0x0/0x4c returned 0 after 0 msecs
calling  init_mnt_writers+0x0/0x47
initcall init_mnt_writers+0x0/0x47 returned 0 after 0 msecs
calling  eventpoll_init+0x0/0x85
initcall eventpoll_init+0x0/0x85 returned 0 after 0 msecs
calling  anon_inode_init+0x0/0x115
initcall anon_inode_init+0x0/0x115 returned 0 after 0 msecs
calling  acpi_rtc_init+0x0/0xf4
initcall acpi_rtc_init+0x0/0xf4 returned 0 after 0 msecs
calling  acpi_event_init+0x0/0x80
initcall acpi_event_init+0x0/0x80 returned 0 after 13 msecs
calling  pnp_system_init+0x0/0x12
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x73f has been reserved
system 00:01: ioport range 0x800-0x8fe has been reserved
system 00:01: ioport range 0x900-0x9fe has been reserved
system 00:01: ioport range 0x9ff-0x9ff has been reserved
system 00:01: ioport range 0xa00-0xafe has been reserved
system 00:01: ioport range 0xaff-0xaff has been reserved
system 00:01: ioport range 0xb00-0xbfe has been reserved
system 00:01: ioport range 0xbff-0xbff has been reserved
system 00:01: ioport range 0xc80-0xc83 has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0xca0-0xca1 has been reserved
system 00:01: ioport range 0xca4-0xca5 has been reserved
system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
system 00:01: ioport range 0x3f8-0x3ff has been reserved
system 00:01: iomem range 0x80000000-0x8fffffff could not be reserved
system 00:01: iomem range 0xf7df0000-0xf7df0fff has been reserved
system 00:01: iomem range 0xfdef0000-0xfdef0fff has been reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 8 msecs
calling  chr_dev_init+0x0/0xa1
initcall chr_dev_init+0x0/0xa1 returned 0 after 0 msecs
calling  firmware_class_init+0x0/0x79
initcall firmware_class_init+0x0/0x79 returned 0 after 0 msecs
calling  loopback_init+0x0/0x12
initcall loopback_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_performance_init+0x0/0x12
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_userspace_init+0x0/0x12
initcall cpufreq_gov_userspace_init+0x0/0x12 returned 0 after 0 msecs
calling  init_acpi_pm_clocksource+0x0/0xa4
initcall init_acpi_pm_clocksource+0x0/0xa4 returned 0 after 0 msecs
calling  ssb_modinit+0x0/0x4a
initcall ssb_modinit+0x0/0x4a returned 0 after 0 msecs
calling  pcibios_assign_resources+0x0/0x87
pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
pci 0000:00:09.0:   IO window: 0x1000-0x2fff
pci 0000:00:09.0:   MEM window: 0xf7e00000-0xf7ffffff
pci 0000:00:09.0:   PREFETCH window: 0x000000e8000000-0x000000efffffff
pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
pci 0000:02:00.0:   IO window: disabled
pci 0000:02:00.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:02:00.0:   PREFETCH window: 0x00000090000000-0x000000900fffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:0b.0:   PREFETCH window: 0x00000090000000-0x000000900fffff
pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
pci 0000:04:00.0:   IO window: disabled
pci 0000:04:00.0:   MEM window: 0xfa000000-0xfbffffff
pci 0000:04:00.0:   PREFETCH window: 0x00000090100000-0x000000901fffff
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:0c.0:   PREFETCH window: 0x00000090100000-0x000000901fffff
pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
pci 0000:06:00.0:   IO window: disabled
pci 0000:06:00.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:06:00.0:   PREFETCH window: 0x00000090200000-0x000000902fffff
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:06
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:0d.0:   PREFETCH window: 0x00000090200000-0x000000902fffff
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:08
pci 0000:00:0e.0:   IO window: 0x3000-0x3fff
pci 0000:00:0e.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:0e.0:   PREFETCH window: 0x00000090300000-0x000000903fffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:04:00.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:06:00.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:42:04.0: PCI bridge, secondary bus 0000:43
pci 0000:42:04.0:   IO window: disabled
pci 0000:42:04.0:   MEM window: disabled
pci 0000:42:04.0:   PREFETCH window: disabled
pci 0000:41:00.0: PCI bridge, secondary bus 0000:42
pci 0000:41:00.0:   IO window: 0x4000-0x4fff
pci 0000:41:00.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:41:00.0:   PREFETCH window: 0x00000084000000-0x000000840fffff
pci 0000:40:0c.0: PCI bridge, secondary bus 0000:41
pci 0000:40:0c.0:   IO window: 0x4000-0x4fff
pci 0000:40:0c.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:40:0c.0:   PREFETCH window: 0x00000084000000-0x000000840fffff
pci 0000:40:0d.0: PCI bridge, secondary bus 0000:44
pci 0000:40:0d.0:   IO window: disabled
pci 0000:40:0d.0:   MEM window: disabled
pci 0000:40:0d.0:   PREFETCH window: disabled
pci 0000:40:0e.0: PCI bridge, secondary bus 0000:47
pci 0000:40:0e.0:   IO window: disabled
pci 0000:40:0e.0:   MEM window: disabled
pci 0000:40:0e.0:   PREFETCH window: disabled
pci 0000:40:0c.0: setting latency timer to 64
pci 0000:41:00.0: setting latency timer to 64
pci 0000:40:0d.0: setting latency timer to 64
pci 0000:40:0e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [90000000, fddfffff]
bus: 00 index 2 mmio: [80000000, 83ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [280000000, fcffffffff]
bus: 01 index 0 io port: [1000, 2fff]
bus: 01 index 1 mmio: [f7e00000, f7ffffff]
bus: 01 index 2 mmio: [e8000000, efffffff]
bus: 01 index 3 io port: [0, 3fff]
bus: 01 index 4 mmio: [90000000, fddfffff]
bus: 01 index 5 mmio: [80000000, 83ffffff]
bus: 01 index 6 mmio: [a0000, bffff]
bus: 01 index 7 mmio: [fe000000, ffffffff]
bus: 01 index 8 mmio: [280000000, fcffffffff]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [f8000000, f9ffffff]
bus: 02 index 2 mmio: [90000000, 900fffff]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [f8000000, f9ffffff]
bus: 03 index 2 mmio: [90000000, 900fffff]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [fa000000, fbffffff]
bus: 04 index 2 mmio: [90100000, 901fffff]
bus: 04 index 3 mmio: [0, 0]
bus: 05 index 0 mmio: [0, 0]
bus: 05 index 1 mmio: [fa000000, fbffffff]
bus: 05 index 2 mmio: [90100000, 901fffff]
bus: 05 index 3 mmio: [0, 0]
bus: 06 index 0 mmio: [0, 0]
bus: 06 index 1 mmio: [fdc00000, fdcfffff]
bus: 06 index 2 mmio: [90200000, 902fffff]
bus: 06 index 3 mmio: [0, 0]
bus: 07 index 0 mmio: [0, 0]
bus: 07 index 1 mmio: [fdc00000, fdcfffff]
bus: 07 index 2 mmio: [90200000, 902fffff]
bus: 07 index 3 mmio: [0, 0]
bus: 08 index 0 io port: [3000, 3fff]
bus: 08 index 1 mmio: [fdd00000, fddfffff]
bus: 08 index 2 mmio: [90300000, 903fffff]
bus: 08 index 3 mmio: [0, 0]
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [fde00000, fdffffff]
bus: 40 index 2 mmio: [84000000, 8fffffff]
bus: 41 index 0 io port: [4000, 4fff]
bus: 41 index 1 mmio: [fdf00000, fdffffff]
bus: 41 index 2 mmio: [84000000, 840fffff]
bus: 41 index 3 mmio: [0, 0]
bus: 42 index 0 io port: [4000, 4fff]
bus: 42 index 1 mmio: [fdf00000, fdffffff]
bus: 42 index 2 mmio: [84000000, 840fffff]
bus: 42 index 3 mmio: [0, 0]
bus: 43 index 0 mmio: [0, 0]
bus: 43 index 1 mmio: [0, 0]
bus: 43 index 2 mmio: [0, 0]
bus: 43 index 3 mmio: [0, 0]
bus: 44 index 0 mmio: [0, 0]
bus: 44 index 1 mmio: [0, 0]
bus: 44 index 2 mmio: [0, 0]
bus: 44 index 3 mmio: [0, 0]
bus: 47 index 0 mmio: [0, 0]
bus: 47 index 1 mmio: [0, 0]
bus: 47 index 2 mmio: [0, 0]
bus: 47 index 3 mmio: [0, 0]
initcall pcibios_assign_resources+0x0/0x87 returned 0 after 23 msecs
calling  inet_init+0x0/0x204
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x204 returned 0 after 66 msecs
calling  af_unix_init+0x0/0x55
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 0 msecs
calling  populate_rootfs+0x0/0xea
checking if image is initramfs... it is
Freeing initrd memory: 1322k freed
initcall populate_rootfs+0x0/0xea returned 0 after 187 msecs
calling  i8259A_init_sysfs+0x0/0x22
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 0 msecs
calling  vsyscall_init+0x0/0x6c
initcall vsyscall_init+0x0/0x6c returned 0 after 0 msecs
calling  sbf_init+0x0/0xd7
initcall sbf_init+0x0/0xd7 returned 0 after 0 msecs
calling  i8237A_init_sysfs+0x0/0x22
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 0 msecs
calling  add_rtc_cmos+0x0/0x1d
initcall add_rtc_cmos+0x0/0x1d returned 0 after 0 msecs
calling  cache_sysfs_init+0x0/0x54
initcall cache_sysfs_init+0x0/0x54 returned 0 after 1 msecs
calling  mce_init_device+0x0/0x75
initcall mce_init_device+0x0/0x75 returned 0 after 0 msecs
calling  periodic_mcheck_init+0x0/0x3f
initcall periodic_mcheck_init+0x0/0x3f returned 0 after 0 msecs
calling  thermal_throttle_init_device+0x0/0x7a
initcall thermal_throttle_init_device+0x0/0x7a returned 0 after 0 msecs
calling  threshold_init_device+0x0/0x40
initcall threshold_init_device+0x0/0x40 returned 0 after 0 msecs
calling  msr_init+0x0/0xe7
initcall msr_init+0x0/0xe7 returned 0 after 0 msecs
calling  cpuid_init+0x0/0xe7
initcall cpuid_init+0x0/0xe7 returned 0 after 0 msecs
calling  microcode_init+0x0/0xb9
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
microcode: CPU0 not a capable Intel processor
microcode: CPU1 not a capable Intel processor
microcode: CPU2 not a capable Intel processor
microcode: CPU3 not a capable Intel processor
initcall microcode_init+0x0/0xb9 returned 0 after 1 msecs
calling  init_lapic_sysfs+0x0/0x2d
initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 msecs
calling  ioapic_init_sysfs+0x0/0x99
initcall ioapic_init_sysfs+0x0/0x99 returned 0 after 0 msecs
calling  add_pcspkr+0x0/0x43
initcall add_pcspkr+0x0/0x43 returned 0 after 0 msecs
calling  uv_ptc_init+0x0/0x75
initcall uv_ptc_init+0x0/0x75 returned 0 after 0 msecs
calling  uv_bau_init+0x0/0x5a0
initcall uv_bau_init+0x0/0x5a0 returned 0 after 0 msecs
calling  audit_classes_init+0x0/0xaf
initcall audit_classes_init+0x0/0xaf returned 0 after 0 msecs
calling  init_vdso_vars+0x0/0x1f2
initcall init_vdso_vars+0x0/0x1f2 returned 0 after 0 msecs
calling  ia32_binfmt_init+0x0/0x14
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 msecs
calling  sysenter_setup+0x0/0x2cc
initcall sysenter_setup+0x0/0x2cc returned 0 after 0 msecs
calling  init_aout_binfmt+0x0/0x12
initcall init_aout_binfmt+0x0/0x12 returned 0 after 0 msecs
calling  ioresources_init+0x0/0x3c
initcall ioresources_init+0x0/0x3c returned 0 after 0 msecs
calling  uid_cache_init+0x0/0x69
initcall uid_cache_init+0x0/0x69 returned 0 after 0 msecs
calling  init_posix_timers+0x0/0xb6
initcall init_posix_timers+0x0/0xb6 returned 0 after 0 msecs
calling  init_posix_cpu_timers+0x0/0xd4
initcall init_posix_cpu_timers+0x0/0xd4 returned 0 after 0 msecs
calling  nsproxy_cache_init+0x0/0x2d
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 msecs
calling  create_proc_profile+0x0/0x2bb
initcall create_proc_profile+0x0/0x2bb returned 0 after 0 msecs
calling  timekeeping_init_device+0x0/0x22
initcall timekeeping_init_device+0x0/0x22 returned 0 after 0 msecs
calling  init_clocksource_sysfs+0x0/0x50
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 0 msecs
calling  init_timer_list_procfs+0x0/0x2c
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 msecs
calling  init_tstats_procfs+0x0/0x2c
initcall init_tstats_procfs+0x0/0x2c returned 0 after 0 msecs
calling  futex_init+0x0/0x63
initcall futex_init+0x0/0x63 returned 0 after 0 msecs
calling  proc_dma_init+0x0/0x22
initcall proc_dma_init+0x0/0x22 returned 0 after 0 msecs
calling  percpu_modinit+0x0/0x6f
initcall percpu_modinit+0x0/0x6f returned 0 after 0 msecs
calling  kallsyms_init+0x0/0x25
initcall kallsyms_init+0x0/0x25 returned 0 after 0 msecs
calling  snapshot_device_init+0x0/0x12
initcall snapshot_device_init+0x0/0x12 returned 0 after 0 msecs
calling  crash_save_vmcoreinfo_init+0x0/0x42b
initcall crash_save_vmcoreinfo_init+0x0/0x42b returned 0 after 0 msecs
calling  crash_notes_memory_init+0x0/0x3d
initcall crash_notes_memory_init+0x0/0x3d returned 0 after 0 msecs
calling  ikconfig_init+0x0/0x39
initcall ikconfig_init+0x0/0x39 returned 0 after 0 msecs
calling  audit_init+0x0/0x14d
audit: initializing netlink socket (disabled)
type=3D2000 audit(1219250820.851:1): initialized
initcall audit_init+0x0/0x14d returned 0 after 0 msecs
calling  audit_tree_init+0x0/0x49
initcall audit_tree_init+0x0/0x49 returned 0 after 0 msecs
calling  init_kprobes+0x0/0x127
initcall init_kprobes+0x0/0x127 returned 0 after 5 msecs
calling  utsname_sysctl_init+0x0/0x14
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 msecs
calling  init_per_zone_pages_min+0x0/0x53
initcall init_per_zone_pages_min+0x0/0x53 returned 0 after 0 msecs
calling  pdflush_init+0x0/0x1d
initcall pdflush_init+0x0/0x1d returned 0 after 0 msecs
calling  kswapd_init+0x0/0x64
initcall kswapd_init+0x0/0x64 returned 0 after 0 msecs
calling  setup_vmstat+0x0/0x41
initcall setup_vmstat+0x0/0x41 returned 0 after 0 msecs
calling  mm_sysfs_init+0x0/0x29
initcall mm_sysfs_init+0x0/0x29 returned 0 after 0 msecs
calling  procswaps_init+0x0/0x22
initcall procswaps_init+0x0/0x22 returned 0 after 0 msecs
calling  hugetlb_init+0x0/0x2ba
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x2ba returned 0 after 0 msecs
calling  init_tmpfs+0x0/0xda
initcall init_tmpfs+0x0/0xda returned 0 after 0 msecs
calling  slab_sysfs_init+0x0/0xf0
initcall slab_sysfs_init+0x0/0xf0 returned 0 after 5 msecs
calling  fasync_init+0x0/0x2a
initcall fasync_init+0x0/0x2a returned 0 after 0 msecs
calling  aio_setup+0x0/0x6e
initcall aio_setup+0x0/0x6e returned 0 after 0 msecs
calling  inotify_setup+0x0/0x12
initcall inotify_setup+0x0/0x12 returned 0 after 0 msecs
calling  inotify_user_setup+0x0/0xb8
initcall inotify_user_setup+0x0/0xb8 returned 0 after 0 msecs
calling  init_sys32_ioctl+0x0/0x85
initcall init_sys32_ioctl+0x0/0x85 returned 0 after 0 msecs
calling  init_mbcache+0x0/0x14
initcall init_mbcache+0x0/0x14 returned 0 after 0 msecs
calling  dnotify_init+0x0/0x2a
initcall dnotify_init+0x0/0x2a returned 0 after 0 msecs
calling  vmcore_init+0x0/0x894
initcall vmcore_init+0x0/0x894 returned 0 after 0 msecs
calling  configfs_init+0x0/0xb3
initcall configfs_init+0x0/0xb3 returned 0 after 0 msecs
calling  init_devpts_fs+0x0/0x3f
initcall init_devpts_fs+0x0/0x3f returned 0 after 0 msecs
calling  init_ext3_fs+0x0/0x6a
initcall init_ext3_fs+0x0/0x6a returned 0 after 0 msecs
calling  journal_init+0x0/0x99
initcall journal_init+0x0/0x99 returned 0 after 0 msecs
calling  init_ext2_fs+0x0/0x6a
initcall init_ext2_fs+0x0/0x6a returned 0 after 0 msecs
calling  init_ramfs_fs+0x0/0x12
initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_hugetlbfs_fs+0x0/0x98
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 0 msecs
calling  init_fat_fs+0x0/0x4f
initcall init_fat_fs+0x0/0x4f returned 0 after 0 msecs
calling  init_msdos_fs+0x0/0x12
initcall init_msdos_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_vfat_fs+0x0/0x12
initcall init_vfat_fs+0x0/0x12 returned 0 after 0 msecs
calling  init_iso9660_fs+0x0/0x6c
initcall init_iso9660_fs+0x0/0x6c returned 0 after 0 msecs
calling  init_nfs_fs+0x0/0x10e
initcall init_nfs_fs+0x0/0x10e returned 0 after 0 msecs
calling  init_nfsd+0x0/0xbb
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall init_nfsd+0x0/0xbb returned 0 after 0 msecs
calling  init_nlm+0x0/0x22
initcall init_nlm+0x0/0x22 returned 0 after 0 msecs
calling  init_nls_cp437+0x0/0x12
initcall init_nls_cp437+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_cp850+0x0/0x12
initcall init_nls_cp850+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_ascii+0x0/0x12
initcall init_nls_ascii+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_1+0x0/0x12
initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_iso8859_15+0x0/0x12
initcall init_nls_iso8859_15+0x0/0x12 returned 0 after 0 msecs
calling  init_nls_utf8+0x0/0x25
initcall init_nls_utf8+0x0/0x25 returned 0 after 0 msecs
calling  ipc_init+0x0/0x23
msgmni has been set to 16013
initcall ipc_init+0x0/0x23 returned 0 after 0 msecs
calling  ipc_sysctl_init+0x0/0x14
initcall ipc_sysctl_init+0x0/0x14 returned 0 after 0 msecs
calling  init_mqueue_fs+0x0/0xc6
initcall init_mqueue_fs+0x0/0xc6 returned 0 after 0 msecs
calling  crypto_algapi_init+0x0/0xd
initcall crypto_algapi_init+0x0/0xd returned 0 after 0 msecs
calling  blkcipher_module_init+0x0/0x2a
initcall blkcipher_module_init+0x0/0x2a returned 0 after 0 msecs
calling  cryptomgr_init+0x0/0x12
initcall cryptomgr_init+0x0/0x12 returned 0 after 0 msecs
calling  hmac_module_init+0x0/0x12
initcall hmac_module_init+0x0/0x12 returned 0 after 0 msecs
calling  md5_mod_init+0x0/0x12
initcall md5_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  sha1_generic_mod_init+0x0/0x12
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  crypto_cbc_module_init+0x0/0x12
initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 msecs
calling  des_generic_mod_init+0x0/0x3f
initcall des_generic_mod_init+0x0/0x3f returned 0 after 0 msecs
calling  cast5_mod_init+0x0/0x12
initcall cast5_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  deflate_mod_init+0x0/0x12
initcall deflate_mod_init+0x0/0x12 returned 0 after 0 msecs
calling  crc32c_mod_init+0x0/0x3f
initcall crc32c_mod_init+0x0/0x3f returned 0 after 0 msecs
calling  crypto_authenc_module_init+0x0/0x12
initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 0 msecs
calling  bsg_init+0x0/0x126
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
initcall bsg_init+0x0/0x126 returned 0 after 0 msecs
calling  noop_init+0x0/0x14
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 0 msecs
calling  as_init+0x0/0x14
io scheduler anticipatory registered
initcall as_init+0x0/0x14 returned 0 after 0 msecs
calling  deadline_init+0x0/0x14
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 0 msecs
calling  cfq_init+0x0/0x9d
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x9d returned 0 after 0 msecs
calling  percpu_counter_startup+0x0/0x14
initcall percpu_counter_startup+0x0/0x14 returned 0 after 0 msecs
calling  pci_init+0x0/0x35
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:03.0: Boot video device
pci 0000:01:04.4: HCRESET not completed yet!
pci 0000:40:00.0: Enabling HT MSI Mapping
pci 0000:40:0c.0: Enabling HT MSI Mapping
pci 0000:40:0c.0: Found enabled HT MSI Mapping
pci 0000:40:0d.0: Enabling HT MSI Mapping
pci 0000:40:0d.0: Found enabled HT MSI Mapping
pci 0000:40:0e.0: Enabling HT MSI Mapping
pci 0000:40:0e.0: Found enabled HT MSI Mapping
initcall pci_init+0x0/0x35 returned 0 after 3 msecs
calling  pci_proc_init+0x0/0x6a
initcall pci_proc_init+0x0/0x6a returned 0 after 0 msecs
calling  pcie_portdrv_init+0x0/0x4c
pcieport-driver 0000:00:0b.0: setting latency timer to 64
pcieport-driver 0000:00:0b.0: found MSI capability
pci_express 0000:00:0b.0:pcie00: allocate port service
pci_express 0000:00:0b.0:pcie01: allocate port service
pci_express 0000:00:0b.0:pcie03: allocate port service
pcieport-driver 0000:00:0c.0: setting latency timer to 64
pcieport-driver 0000:00:0c.0: found MSI capability
pci_express 0000:00:0c.0:pcie00: allocate port service
pci_express 0000:00:0c.0:pcie01: allocate port service
pci_express 0000:00:0c.0:pcie03: allocate port service
pcieport-driver 0000:00:0d.0: setting latency timer to 64
pcieport-driver 0000:00:0d.0: found MSI capability
pci_express 0000:00:0d.0:pcie00: allocate port service
pci_express 0000:00:0d.0:pcie01: allocate port service
pci_express 0000:00:0d.0:pcie03: allocate port service
pcieport-driver 0000:00:0e.0: setting latency timer to 64
pcieport-driver 0000:00:0e.0: found MSI capability
pci_express 0000:00:0e.0:pcie00: allocate port service
pci_express 0000:00:0e.0:pcie01: allocate port service
pci_express 0000:00:0e.0:pcie03: allocate port service
pcieport-driver 0000:40:0c.0: setting latency timer to 64
pcieport-driver 0000:40:0c.0: found MSI capability
pci_express 0000:40:0c.0:pcie00: allocate port service
pci_express 0000:40:0c.0:pcie01: allocate port service
pci_express 0000:40:0c.0:pcie03: allocate port service
pcieport-driver 0000:40:0d.0: setting latency timer to 64
pcieport-driver 0000:40:0d.0: found MSI capability
pci_express 0000:40:0d.0:pcie00: allocate port service
pci_express 0000:40:0d.0:pcie01: allocate port service
pci_express 0000:40:0d.0:pcie03: allocate port service
pcieport-driver 0000:40:0e.0: setting latency timer to 64
pcieport-driver 0000:40:0e.0: found MSI capability
pci_express 0000:40:0e.0:pcie00: allocate port service
pci_express 0000:40:0e.0:pcie01: allocate port service
pci_express 0000:40:0e.0:pcie03: allocate port service
initcall pcie_portdrv_init+0x0/0x4c returned 0 after 9 msecs
calling  fb_console_init+0x0/0x12b
initcall fb_console_init+0x0/0x12b returned 0 after 0 msecs
calling  rivafb_init+0x0/0x1a5
initcall rivafb_init+0x0/0x1a5 returned 0 after 0 msecs
calling  nvidiafb_init+0x0/0x2b6
initcall nvidiafb_init+0x0/0x2b6 returned 0 after 0 msecs
calling  vt8623fb_init+0x0/0x5f
initcall vt8623fb_init+0x0/0x5f returned 0 after 0 msecs
calling  vesafb_init+0x0/0x235
initcall vesafb_init+0x0/0x235 returned 0 after 0 msecs
calling  acpi_reserve_resources+0x0/0xeb
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 0 msecs
calling  acpi_ac_init+0x0/0x45
initcall acpi_ac_init+0x0/0x45 returned 0 after 0 msecs
calling  acpi_button_init+0x0/0x5e
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
initcall acpi_button_init+0x0/0x5e returned 0 after 0 msecs
calling  acpi_fan_init+0x0/0x5e
initcall acpi_fan_init+0x0/0x5e returned 0 after 0 msecs
calling  irqrouter_init_sysfs+0x0/0x38
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 0 msecs
calling  acpi_processor_init+0x0/0x10b
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
processor ACPI0007:02: registered as cooling_device2
processor ACPI0007:03: registered as cooling_device3
initcall acpi_processor_init+0x0/0x10b returned 0 after 1 msecs
calling  acpi_container_init+0x0/0x42
initcall acpi_container_init+0x0/0x42 returned 0 after 1 msecs
calling  acpi_thermal_init+0x0/0x83
initcall acpi_thermal_init+0x0/0x83 returned 0 after 0 msecs
calling  rand_initialize+0x0/0x2c
initcall rand_initialize+0x0/0x2c returned 0 after 0 msecs
calling  tty_init+0x0/0x1cd
initcall tty_init+0x0/0x1cd returned 0 after 22 msecs
calling  pty_init+0x0/0x26f
initcall pty_init+0x0/0x26f returned 0 after 0 msecs
calling  raw_init+0x0/0xdd
initcall raw_init+0x0/0xdd returned 0 after 0 msecs
calling  hpet_init+0x0/0x6a
hpet_resources: 0xfed00000 is busy
initcall hpet_init+0x0/0x6a returned 0 after 0 msecs
calling  nvram_init+0x0/0x8a
Non-volatile memory driver v1.2
initcall nvram_init+0x0/0x8a returned 0 after 0 msecs
calling  mod_init+0x0/0x1f8
initcall mod_init+0x0/0x1f8 returned -19 after 0 msecs
calling  mod_init+0x0/0xba
initcall mod_init+0x0/0xba returned -19 after 0 msecs
calling  agp_init+0x0/0x26
Linux agpgart interface v0.103
initcall agp_init+0x0/0x26 returned 0 after 0 msecs
calling  agp_intel_init+0x0/0x29
initcall agp_intel_init+0x0/0x29 returned 0 after 0 msecs
calling  agp_via_init+0x0/0x29
initcall agp_via_init+0x0/0x29 returned 0 after 0 msecs
calling  ipmi_init_msghandler_mod+0x0/0xd
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 0 msecs
calling  init_ipmi_devintf+0x0/0x101
ipmi device interface
initcall init_ipmi_devintf+0x0/0x101 returned 0 after 0 msecs
calling  init_ipmi_si+0x0/0x78a
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, sl=
ave address 0x20, irq 0
Clocksource tsc unstable (delta =3D 637358161795 ns)
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
IPMI kcs interface initialized
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slav=
e address 0x0, irq 0
ipmi_si: duplicate interface
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
ipmi_si 0000:01:04.6: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IR=
Q 16
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf7ef0000, =
slave address 0x0, irq 16
  Using irq 16
ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: =
0x11)
IPMI kcs interface initialized
initcall init_ipmi_si+0x0/0x78a returned 0 after 192 msecs
calling  ipmi_wdog_init+0x0/0x12e
IPMI Watchdog: driver initialized
initcall ipmi_wdog_init+0x0/0x12e returned 0 after 6 msecs
calling  ipmi_poweroff_init+0x0/0x8d
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
IPMI poweroff: ATCA Detect mfg 0xB prod 0x0
IPMI poweroff: Unable to find a poweroff function that will work, giving up
IPMI poweroff: ATCA Detect mfg 0xB prod 0x0
IPMI poweroff: Unable to find a poweroff function that will work, giving up
initcall ipmi_poweroff_init+0x0/0x8d returned 0 after 44 msecs
calling  hangcheck_init+0x0/0x8a
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 6=
0 seconds).
Hangcheck: Using get_cycles().
initcall hangcheck_init+0x0/0x8a returned 0 after 5 msecs
calling  drm_core_init+0x0/0xf9
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0xf9 returned 0 after 0 msecs
calling  r128_init+0x0/0x1e
initcall r128_init+0x0/0x1e returned 0 after 0 msecs
calling  radeon_init+0x0/0x1e
ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 18
pci 0000:01:03.0: PCI INT A -> Link[LNKY] -> GSI 18 (level, high) -> IRQ 18
[drm] Initialized radeon 1.29.0 20080528 on minor 0
initcall radeon_init+0x0/0x1e returned 0 after 2 msecs
calling  via_init+0x0/0x23
initcall via_init+0x0/0x23 returned 0 after 0 msecs
calling  cn_proc_init+0x0/0x3d
initcall cn_proc_init+0x0/0x3d returned 0 after 0 msecs
calling  serial8250_init+0x0/0x131
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
initcall serial8250_init+0x0/0x131 returned 0 after 1 msecs
calling  serial8250_pnp_init+0x0/0x12
00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
initcall serial8250_pnp_init+0x0/0x12 returned 0 after 0 msecs
calling  serial8250_pci_init+0x0/0x1b
initcall serial8250_pci_init+0x0/0x1b returned 0 after 0 msecs
calling  topology_sysfs_init+0x0/0x40
initcall topology_sysfs_init+0x0/0x40 returned 0 after 0 msecs
calling  floppy_init+0x0/0xf14
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
initcall floppy_init+0x0/0xf14 returned -19 after 2876 msecs
calling  brd_init+0x0/0x167
brd: module loaded
initcall brd_init+0x0/0x167 returned 0 after 3 msecs
calling  bnx2_init+0x0/0x1b
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.8.0 (Aug 14, 2008)
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
bnx2 0000:03:00.0: PCI INT A -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem f8000000, IRQ 17, node addr 00:18:fe:35:26:f6
bnx2 0000:05:00.0: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz fo=
und at mem fa000000, IRQ 16, node addr 00:18:fe:35:26:f4
initcall bnx2_init+0x0/0x1b returned 0 after 47 msecs
calling  net_olddevs_init+0x0/0xa0
initcall net_olddevs_init+0x0/0xa0 returned 0 after 0 msecs
calling  b44_init+0x0/0x63
initcall b44_init+0x0/0x63 returned 0 after 0 msecs
calling  tun_init+0x0/0xa0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
initcall tun_init+0x0/0xa0 returned 0 after 0 msecs
calling  init_netconsole+0x0/0x1bc
netconsole: local port 54883
netconsole: local IP 139.185.50.77
netconsole: interface eth0
netconsole: remote port 54883
netconsole: remote IP 139.185.50.76
netconsole: remote ethernet address 00:18:fe:34:1c:3d
netconsole: device eth0 not up yet, forcing it
bnx2: eth0: using MSI
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
bnx2: eth0 NIC SerDes Link is Up, 1000 Mbps full duplex
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1bc returned 0 after 4179 msecs
calling  scsi_tgt_init+0x0/0x7f
initcall scsi_tgt_init+0x0/0x7f returned 0 after 0 msecs
calling  raid_init+0x0/0x12
initcall raid_init+0x0/0x12 returned 0 after 0 msecs
calling  spi_transport_init+0x0/0x2e
initcall spi_transport_init+0x0/0x2e returned 0 after 0 msecs
calling  fc_transport_init+0x0/0x4c
initcall fc_transport_init+0x0/0x4c returned 0 after 0 msecs
calling  iscsi_transport_init+0x0/0x148
Loading iSCSI transport class v2.0-870.
initcall iscsi_transport_init+0x0/0x148 returned 0 after 0 msecs
calling  sas_transport_init+0x0/0xbb
initcall sas_transport_init+0x0/0xbb returned 0 after 0 msecs
calling  sas_class_init+0x0/0x31
initcall sas_class_init+0x0/0x31 returned 0 after 0 msecs
calling  init_sd+0x0/0x10a
Driver 'sd' needs updating - please use bus_type methods
initcall init_sd+0x0/0x10a returned 0 after 0 msecs
calling  init_sg+0x0/0x15a
initcall init_sg+0x0/0x15a returned 0 after 0 msecs
calling  mon_init+0x0/0x103
initcall mon_init+0x0/0x103 returned 0 after 0 msecs
calling  i8042_init+0x0/0x3bd
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x3bd returned 0 after 7 msecs
calling  serport_init+0x0/0x34
initcall serport_init+0x0/0x34 returned 0 after 0 msecs
calling  serio_raw_init+0x0/0x1b
initcall serio_raw_init+0x0/0x1b returned 0 after 0 msecs
calling  mousedev_init+0x0/0x61
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x61 returned 0 after 0 msecs
calling  evdev_init+0x0/0x12
initcall evdev_init+0x0/0x12 returned 0 after 13 msecs
calling  atkbd_init+0x0/0x27
initcall atkbd_init+0x0/0x27 returned 0 after 0 msecs
calling  psmouse_init+0x0/0x6d
initcall psmouse_init+0x0/0x6d returned 0 after 58 msecs
calling  pcspkr_init+0x0/0x12
input: PC Speaker as /class/input/input1
initcall pcspkr_init+0x0/0x12 returned 0 after 31 msecs
calling  uinput_init+0x0/0x12
initcall uinput_init+0x0/0x12 returned 0 after 0 msecs
calling  cmos_init+0x0/0x30
initcall cmos_init+0x0/0x30 returned 0 after 0 msecs
calling  i2c_dev_init+0x0/0xa6
i2c /dev entries driver
initcall i2c_dev_init+0x0/0xa6 returned 0 after 0 msecs
calling  amd756_init+0x0/0x1b
initcall amd756_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_amd8111_init+0x0/0x1b
initcall i2c_amd8111_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_i801_init+0x0/0x1b
initcall i2c_i801_init+0x0/0x1b returned 0 after 0 msecs
calling  nforce2_init+0x0/0x1b
initcall nforce2_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_piix4_init+0x0/0x1b
initcall i2c_piix4_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_vt586b_init+0x0/0x1b
initcall i2c_vt586b_init+0x0/0x1b returned 0 after 0 msecs
calling  i2c_vt596_init+0x0/0x1b
initcall i2c_vt596_init+0x0/0x1b returned 0 after 0 msecs
calling  coretemp_init+0x0/0x15b
initcall coretemp_init+0x0/0x15b returned -19 after 0 msecs
calling  k8temp_init+0x0/0x1b
initcall k8temp_init+0x0/0x1b returned 0 after 0 msecs
calling  sm_via686a_init+0x0/0x1b
initcall sm_via686a_init+0x0/0x1b returned 0 after 0 msecs
calling  vt1211_init+0x0/0x14e
initcall vt1211_init+0x0/0x14e returned -19 after 0 msecs
calling  sm_vt8231_init+0x0/0x1b
initcall sm_vt8231_init+0x0/0x1b returned 0 after 0 msecs
calling  watchdog_init+0x0/0xb4
SoftDog: cannot register miscdev on minor=3D130 (err=3D-16)
initcall watchdog_init+0x0/0xb4 returned -16 after 0 msecs
initcall watchdog_init+0x0/0xb4 returned with error code -16=20
calling  edac_init+0x0/0x9d
EDAC MC: Ver: 2.1.0 Aug 20 2008
initcall edac_init+0x0/0x9d returned 0 after 0 msecs
calling  i5000_init+0x0/0x41
initcall i5000_init+0x0/0x41 returned 0 after 0 msecs
calling  e752x_init+0x0/0x41
initcall e752x_init+0x0/0x41 returned 0 after 0 msecs
calling  i82975x_init+0x0/0xa0
initcall i82975x_init+0x0/0xa0 returned -19 after 0 msecs
calling  cpufreq_stats_init+0x0/0x86
initcall cpufreq_stats_init+0x0/0x86 returned 0 after 0 msecs
calling  cpufreq_gov_powersave_init+0x0/0x12
initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 0 msecs
calling  cpufreq_gov_dbs_init+0x0/0x46
initcall cpufreq_gov_dbs_init+0x0/0x46 returned 0 after 0 msecs
calling  cpufreq_gov_dbs_init+0x0/0x12
initcall cpufreq_gov_dbs_init+0x0/0x12 returned 0 after 0 msecs
calling  init_ladder+0x0/0x12
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 0 msecs
calling  hid_init+0x0/0x8
initcall hid_init+0x0/0x8 returned 0 after 0 msecs
calling  hid_init+0x0/0x61
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
initcall hid_init+0x0/0x61 returned 0 after 0 msecs
calling  sysctl_core_init+0x0/0x25
initcall sysctl_core_init+0x0/0x25 returned 0 after 0 msecs
calling  flow_cache_init+0x0/0x1b3
initcall flow_cache_init+0x0/0x1b3 returned 0 after 0 msecs
calling  sysctl_ipv4_init+0x0/0x4e
initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 0 msecs
calling  ipip_init+0x0/0x71
IPv4 over IPv4 tunneling driver
initcall ipip_init+0x0/0x71 returned 0 after 0 msecs
calling  ipgre_init+0x0/0x71
GRE over IPv4 tunneling driver
initcall ipgre_init+0x0/0x71 returned 0 after 0 msecs
calling  init_syncookies+0x0/0x19
initcall init_syncookies+0x0/0x19 returned 0 after 0 msecs
calling  ah4_init+0x0/0x68
initcall ah4_init+0x0/0x68 returned 0 after 0 msecs
calling  esp4_init+0x0/0x68
initcall esp4_init+0x0/0x68 returned 0 after 0 msecs
calling  ipcomp4_init+0x0/0x68
initcall ipcomp4_init+0x0/0x68 returned 0 after 0 msecs
calling  ipip_init+0x0/0x68
initcall ipip_init+0x0/0x68 returned 0 after 0 msecs
calling  xfrm4_beet_init+0x0/0x17
initcall xfrm4_beet_init+0x0/0x17 returned 0 after 0 msecs
calling  tunnel4_init+0x0/0x32
initcall tunnel4_init+0x0/0x32 returned 0 after 0 msecs
calling  xfrm4_transport_init+0x0/0x17
initcall xfrm4_transport_init+0x0/0x17 returned 0 after 0 msecs
calling  xfrm4_mode_tunnel_init+0x0/0x17
initcall xfrm4_mode_tunnel_init+0x0/0x17 returned 0 after 0 msecs
calling  inet_diag_init+0x0/0x69
initcall inet_diag_init+0x0/0x69 returned 0 after 0 msecs
calling  tcp_diag_init+0x0/0x12
initcall tcp_diag_init+0x0/0x12 returned 0 after 0 msecs
calling  bictcp_register+0x0/0x12
TCP bic registered
initcall bictcp_register+0x0/0x12 returned 0 after 0 msecs
calling  xfrm_user_init+0x0/0x58
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x58 returned 0 after 0 msecs
calling  packet_init+0x0/0x47
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 0 msecs
calling  ipsec_pfkey_init+0x0/0x8c
NET: Registered protocol family 15
initcall ipsec_pfkey_init+0x0/0x8c returned 0 after 0 msecs
calling  init_sunrpc+0x0/0x5d
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
initcall init_sunrpc+0x0/0x5d returned 0 after 0 msecs
calling  init_rpcsec_gss+0x0/0x38
initcall init_rpcsec_gss+0x0/0x38 returned 0 after 0 msecs
calling  init_kerberos_module+0x0/0x2f
initcall init_kerberos_module+0x0/0x2f returned 0 after 0 msecs
calling  init_spkm3_module+0x0/0x2f
initcall init_spkm3_module+0x0/0x2f returned 0 after 0 msecs
calling  powernowk8_init+0x0/0x84
powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 8218 processors (4=
 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
initcall powernowk8_init+0x0/0x84 returned 0 after 3 msecs
calling  acpi_cpufreq_init+0x0/0x8f
initcall acpi_cpufreq_init+0x0/0x8f returned -16 after 0 msecs
initcall acpi_cpufreq_init+0x0/0x8f returned with error code -16=20
calling  centrino_init+0x0/0x36
initcall centrino_init+0x0/0x36 returned -19 after 0 msecs
calling  cpufreq_p4_init+0x0/0x63
initcall cpufreq_p4_init+0x0/0x63 returned -19 after 0 msecs
calling  hpet_insert_resource+0x0/0x23
initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 msecs
calling  update_mp_table+0x0/0x492
initcall update_mp_table+0x0/0x492 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x40
initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x38
initcall init_lapic_nmi_sysfs+0x0/0x38 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x4f
initcall ioapic_insert_resources+0x0/0x4f returned 0 after 0 msecs
calling  check_early_ioremap_leak+0x0/0x42
initcall check_early_ioremap_leak+0x0/0x42 returned 0 after 0 msecs
calling  pat_memtype_list_init+0x0/0x29
initcall pat_memtype_list_init+0x0/0x29 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x23
initcall init_oops_id+0x0/0x23 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x3a
initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0x61
initcall pm_qos_power_init+0x0/0x61 returned 0 after 0 msecs
calling  software_resume+0x0/0x13f
initcall software_resume+0x0/0x13f returned -2 after 0 msecs
initcall software_resume+0x0/0x13f returned with error code -2=20
calling  debugfs_kprobe_init+0x0/0x89
initcall debugfs_kprobe_init+0x0/0x89 returned 0 after 0 msecs
calling  taskstats_init+0x0/0x95
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 0 msecs
calling  random32_reseed+0x0/0x8d
initcall random32_reseed+0x0/0x8d returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x4c
initcall pci_sysfs_init+0x0/0x4c returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xa5
initcall acpi_wakeup_device_init+0x0/0xa5 returned 0 after 0 msecs
calling  acpi_sleep_proc_init+0x0/0x55
initcall acpi_sleep_proc_init+0x0/0x55 returned 0 after 0 msecs
calling  seqgen_init+0x0/0xf
initcall seqgen_init+0x0/0xf returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0xe5
initcall scsi_complete_async_scans+0x0/0xe5 returned 0 after 0 msecs
calling  rtc_hctosys+0x0/0x17b
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
initcall rtc_hctosys+0x0/0x17b returned -19 after 0 msecs
calling  edd_init+0x0/0x2f1
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
initcall edd_init+0x0/0x2f1 returned -19 after 0 msecs
calling  memmap_init+0x0/0xa3
initcall memmap_init+0x0/0xa3 returned 0 after 0 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x43
initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x12
initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 msecs
Freeing unused kernel memory: 396k freed
Write protecting the kernel read-only data: 4632k
calling  uhci_hcd_init+0x0/0xb2 [uhci_hcd]
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 17 (level, high) -> I=
RQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 1
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
initcall uhci_hcd_init+0x0/0xb2 [uhci_hcd] returned 0 after 198 msecs
insmod used greatest stack depth: 4976 bytes left
calling  ohci_hcd_mod_init+0x0/0x45 [ohci_hcd]
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 22 (level, high) -> I=
RQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xf7de0000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
initcall ohci_hcd_mod_init+0x0/0x45 [ohci_hcd] returned 0 after 151 msecs
calling  ehci_hcd_init+0x0/0x20 [ehci_hcd]
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 23 (level, high) -> I=
RQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xf7dd0000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 10 ports detected
usb 1-1: configuration #1 chosen from 1 choice
input: HP Virtual Keyboard as /class/input/input2
input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
input: HP Virtual Keyboard as /class/input/input3
input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
initcall ehci_hcd_init+0x0/0x20 [ehci_hcd] returned 0 after 162 msecs
calling  cciss_init+0x0/0x2e [cciss]
HP CISS Driver (v 3.6.20)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 54
cciss 0000:42:08.0: PCI INT A -> Link[LNKA] -> GSI 54 (level, high) -> IRQ =
54
cciss0: <0x3238> at PCI 0000:42:08.0 IRQ 503 using DAC
BUG: unable to handle kernel NULL pointer dereference at 0000000000000248
IP: [<ffffffffa001bb68>] do_cciss_intr+0x627/0xa6c [cciss]
PGD 17e422067 PUD 17e423067 PMD 0=20
Oops: 0002 [1] SMP=20
CPU 2=20
Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
Pid: 0, comm: swapper Not tainted 2.6.27-rc3-git7 #1
RIP: 0010:[<ffffffffa001bb68>]  [<ffffffffa001bb68>] do_cciss_intr+0x627/0x=
a6c [cciss]
RSP: 0018:ffff88027f66fee8  EFLAGS: 00010007
RAX: 0000000000000000 RBX: ffff88007f840270 RCX: 000000000000000c
RDX: 0000000000000000 RSI: ffff88027e5c0000 RDI: ffff88027e5c0000
RBP: ffff88027f66ff18 R08: 0000000000000000 R09: ffff88017fa95e88
R10: 0000000000000000 R11: ffff88027f66ff48 R12: ffff88027e5c0000
R13: 0000000000000000 R14: 00000000000001f7 R15: 0000000000000086
FS:  0000000000680850(0000) GS:ffff88017fc02c80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000248 CR3: 000000017e425000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88017fa94000, task ffff88027f63d340)
Stack:  ffff88027f66fee0 ffff88017e9b4800 0000000000000000 0000000000000000
 00000000000001f7 0000000000000000 ffff88027f66ff48 ffffffff8026757e
 ffffffff80719000 00000000000001f7 ffff88017e9b4800 ffffffff80719050
Call Trace:
 <IRQ>  [<ffffffff8026757e>] handle_IRQ_event+0x27/0x57
 [<ffffffff80268d08>] handle_edge_irq+0xed/0x12e
 [<ffffffff8020eaab>] do_IRQ+0xf6/0x167
 [<ffffffff8020c471>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802122b1>] ? default_idle+0x2b/0x40
 [<ffffffff802124bf>] ? c1e_idle+0xd4/0xdb
 [<ffffffff8055677d>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8020ac6c>] ? cpu_idle+0x71/0x8f
 [<ffffffff8054e752>] ? start_secondary+0x157/0x15c


Code: 8b 83 48 02 00 00 48 39 d8 74 37 49 39 9c 24 c0 00 01 00 75 08 49 89 =
84 24 c0 00 01 00 48 8b 83 40 02 00 00 48 8b 93 48 02 00 00 <48> 89 90 48 0=
2 00 00 48 8b 93 48 02 00 00 48 89 82 40 02 00 00=20
RIP  [<ffffffffa001bb68>] do_cciss_intr+0x627/0xa6c [cciss]
 RSP <ffff88027f66fee8>
CR2: 0000000000000248
---[ end trace 902dc79a9e72d3ed ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
------------[ cut here ]------------
WARNING: at kernel/smp.c:328 smp_call_function_mask+0x40/0x1cb()
Modules linked in: cciss(+) ehci_hcd ohci_hcd uhci_hcd
Pid: 0, comm: swapper Tainted: G      D   2.6.27-rc3-git7 #1

Call Trace:
 <IRQ>  [<ffffffff802353a9>] warn_on_slowpath+0x58/0x7f
 [<ffffffff80235513>] ? __call_console_drivers+0x65/0x76
 [<ffffffff8024a28b>] ? up+0x34/0x39
 [<ffffffff802359e4>] ? release_console_sem+0x182/0x18b
 [<ffffffff80251d5d>] smp_call_function_mask+0x40/0x1cb
 [<ffffffff8021d58f>] ? stop_this_cpu+0x0/0x1d
 [<ffffffff80552e9b>] ? mutex_unlock+0x9/0xb
 [<ffffffff8025b2fe>] ? crash_kexec+0xe8/0xf2
 [<ffffffff802359e4>] ? release_console_sem+0x182/0x18b
 [<ffffffff80251f03>] smp_call_function+0x1b/0x1d
 [<ffffffff8021d5f5>] native_smp_send_stop+0x22/0x30
 [<ffffffff802352a5>] panic+0xaf/0x15b
 [<ffffffff8024a63a>] ? blocking_notifier_call_chain+0xf/0x11
 [<ffffffff80237e00>] do_exit+0x78/0x84d
 [<ffffffff803db66d>] ? do_unblank_screen+0x2e/0x12a
 [<ffffffff805546de>] oops_begin+0x0/0x96
 [<ffffffff80556655>] do_page_fault+0x72e/0x7dd
 [<ffffffff8022c4d3>] ? __enqueue_entity+0x8d/0x8f
 [<ffffffff80554319>] error_exit+0x0/0x51
 [<ffffffffa001bb68>] ? do_cciss_intr+0x627/0xa6c [cciss]
 [<ffffffffa001bf42>] ? do_cciss_intr+0xa01/0xa6c [cciss]
 [<ffffffff8026757e>] handle_IRQ_event+0x27/0x57
 [<ffffffff80268d08>] handle_edge_irq+0xed/0x12e
 [<ffffffff8020eaab>] do_IRQ+0xf6/0x167
 [<ffffffff8020c471>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802122b1>] ? default_idle+0x2b/0x40
 [<ffffffff802124bf>] ? c1e_idle+0xd4/0xdb
 [<ffffffff8055677d>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8020ac6c>] ? cpu_idle+0x71/0x8f
 [<ffffffff8054e752>] ? start_secondary+0x157/0x15c

---[ end trace 902dc79a9e72d3ed ]---

--Multipart=_Thu__21_Aug_2008_08_43_33_-0700_nZXE3aArB87C=Un5
Content-Type: application/octet-stream;
 name="kconfig.~1"
Content-Disposition: attachment;
 filename="kconfig.~1"
Content-Transfer-Encoding: base64

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IDIuNi4yNy1yYzMtZ2l0NwojIFdlZCBBdWcgMjAgMTY6NDE6Mzkg
MjAwOAojCkNPTkZJR182NEJJVD15CiMgQ09ORklHX1g4Nl8zMiBpcyBub3Qgc2V0CkNPTkZJR19Y
ODZfNjQ9eQpDT05GSUdfWDg2PXkKQ09ORklHX0FSQ0hfREVGQ09ORklHPSJhcmNoL3g4Ni9jb25m
aWdzL3g4Nl82NF9kZWZjb25maWciCiMgQ09ORklHX0dFTkVSSUNfTE9DS0JSRUFLIGlzIG5vdCBz
ZXQKQ09ORklHX0dFTkVSSUNfVElNRT15CkNPTkZJR19HRU5FUklDX0NNT1NfVVBEQVRFPXkKQ09O
RklHX0NMT0NLU09VUkNFX1dBVENIRE9HPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFM9eQpD
T05GSUdfR0VORVJJQ19DTE9DS0VWRU5UU19CUk9BRENBU1Q9eQpDT05GSUdfTE9DS0RFUF9TVVBQ
T1JUPXkKQ09ORklHX1NUQUNLVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19IQVZFX0xBVEVOQ1lUT1Bf
U1VQUE9SVD15CkNPTkZJR19GQVNUX0NNUFhDSEdfTE9DQUw9eQpDT05GSUdfTU1VPXkKQ09ORklH
X1pPTkVfRE1BPXkKQ09ORklHX0dFTkVSSUNfSVNBX0RNQT15CkNPTkZJR19HRU5FUklDX0lPTUFQ
PXkKQ09ORklHX0dFTkVSSUNfQlVHPXkKQ09ORklHX0dFTkVSSUNfSFdFSUdIVD15CiMgQ09ORklH
X0dFTkVSSUNfR1BJTyBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX01BWV9IQVZFX1BDX0ZEQz15CkNP
TkZJR19SV1NFTV9HRU5FUklDX1NQSU5MT0NLPXkKIyBDT05GSUdfUldTRU1fWENIR0FERF9BTEdP
UklUSE0gaXMgbm90IHNldAojIENPTkZJR19BUkNIX0hBU19JTE9HMl9VMzIgaXMgbm90IHNldAoj
IENPTkZJR19BUkNIX0hBU19JTE9HMl9VNjQgaXMgbm90IHNldApDT05GSUdfQVJDSF9IQVNfQ1BV
X0lETEVfV0FJVD15CkNPTkZJR19HRU5FUklDX0NBTElCUkFURV9ERUxBWT15CkNPTkZJR19HRU5F
UklDX1RJTUVfVlNZU0NBTEw9eQpDT05GSUdfQVJDSF9IQVNfQ1BVX1JFTEFYPXkKQ09ORklHX0FS
Q0hfSEFTX0NBQ0hFX0xJTkVfU0laRT15CkNPTkZJR19IQVZFX1NFVFVQX1BFUl9DUFVfQVJFQT15
CkNPTkZJR19IQVZFX0NQVU1BU0tfT0ZfQ1BVX01BUD15CkNPTkZJR19BUkNIX0hJQkVSTkFUSU9O
X1BPU1NJQkxFPXkKQ09ORklHX0FSQ0hfU1VTUEVORF9QT1NTSUJMRT15CkNPTkZJR19aT05FX0RN
QTMyPXkKQ09ORklHX0FSQ0hfUE9QVUxBVEVTX05PREVfTUFQPXkKQ09ORklHX0FVRElUX0FSQ0g9
eQpDT05GSUdfQVJDSF9TVVBQT1JUU19BT1VUPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfT1BUSU1J
WkVEX0lOTElOSU5HPXkKQ09ORklHX0dFTkVSSUNfSEFSRElSUVM9eQpDT05GSUdfR0VORVJJQ19J
UlFfUFJPQkU9eQpDT05GSUdfR0VORVJJQ19QRU5ESU5HX0lSUT15CkNPTkZJR19YODZfU01QPXkK
Q09ORklHX1g4Nl82NF9TTVA9eQpDT05GSUdfWDg2X0hUPXkKQ09ORklHX1g4Nl9CSU9TX1JFQk9P
VD15CkNPTkZJR19YODZfVFJBTVBPTElORT15CiMgQ09ORklHX0tUSU1FX1NDQUxBUiBpcyBub3Qg
c2V0CkNPTkZJR19ERUZDT05GSUdfTElTVD0iL2xpYi9tb2R1bGVzLyRVTkFNRV9SRUxFQVNFLy5j
b25maWciCgojCiMgR2VuZXJhbCBzZXR1cAojCkNPTkZJR19FWFBFUklNRU5UQUw9eQpDT05GSUdf
TE9DS19LRVJORUw9eQpDT05GSUdfSU5JVF9FTlZfQVJHX0xJTUlUPTMyCkNPTkZJR19MT0NBTFZF
UlNJT049IiIKIyBDT05GSUdfTE9DQUxWRVJTSU9OX0FVVE8gaXMgbm90IHNldApDT05GSUdfU1dB
UD15CkNPTkZJR19TWVNWSVBDPXkKQ09ORklHX1NZU1ZJUENfU1lTQ1RMPXkKQ09ORklHX1BPU0lY
X01RVUVVRT15CkNPTkZJR19CU0RfUFJPQ0VTU19BQ0NUPXkKIyBDT05GSUdfQlNEX1BST0NFU1Nf
QUNDVF9WMyBpcyBub3Qgc2V0CkNPTkZJR19UQVNLU1RBVFM9eQpDT05GSUdfVEFTS19ERUxBWV9B
Q0NUPXkKQ09ORklHX1RBU0tfWEFDQ1Q9eQpDT05GSUdfVEFTS19JT19BQ0NPVU5USU5HPXkKQ09O
RklHX0FVRElUPXkKQ09ORklHX0FVRElUU1lTQ0FMTD15CkNPTkZJR19BVURJVF9UUkVFPXkKQ09O
RklHX0lLQ09ORklHPXkKQ09ORklHX0lLQ09ORklHX1BST0M9eQpDT05GSUdfTE9HX0JVRl9TSElG
VD0xOAojIENPTkZJR19DR1JPVVBTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfVU5TVEFCTEVfU0NI
RURfQ0xPQ0s9eQojIENPTkZJR19HUk9VUF9TQ0hFRCBpcyBub3Qgc2V0CkNPTkZJR19TWVNGU19E
RVBSRUNBVEVEPXkKQ09ORklHX1NZU0ZTX0RFUFJFQ0FURURfVjI9eQpDT05GSUdfUkVMQVk9eQoj
IENPTkZJR19OQU1FU1BBQ0VTIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfSU5JVFJEPXkKQ09O
RklHX0lOSVRSQU1GU19TT1VSQ0U9IiIKQ09ORklHX0NDX09QVElNSVpFX0ZPUl9TSVpFPXkKQ09O
RklHX1NZU0NUTD15CkNPTkZJR19FTUJFRERFRD15CkNPTkZJR19VSUQxNj15CkNPTkZJR19TWVND
VExfU1lTQ0FMTD15CkNPTkZJR19LQUxMU1lNUz15CiMgQ09ORklHX0tBTExTWU1TX0FMTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0tBTExTWU1TX0VYVFJBX1BBU1MgaXMgbm90IHNldApDT05GSUdfSE9U
UExVRz15CkNPTkZJR19QUklOVEs9eQpDT05GSUdfQlVHPXkKQ09ORklHX0VMRl9DT1JFPXkKQ09O
RklHX1BDU1BLUl9QTEFURk9STT15CkNPTkZJR19DT01QQVRfQlJLPXkKQ09ORklHX0JBU0VfRlVM
TD15CkNPTkZJR19GVVRFWD15CkNPTkZJR19BTk9OX0lOT0RFUz15CkNPTkZJR19FUE9MTD15CkNP
TkZJR19TSUdOQUxGRD15CkNPTkZJR19USU1FUkZEPXkKQ09ORklHX0VWRU5URkQ9eQpDT05GSUdf
U0hNRU09eQpDT05GSUdfVk1fRVZFTlRfQ09VTlRFUlM9eQpDT05GSUdfU0xVQl9ERUJVRz15CiMg
Q09ORklHX1NMQUIgaXMgbm90IHNldApDT05GSUdfU0xVQj15CiMgQ09ORklHX1NMT0IgaXMgbm90
IHNldApDT05GSUdfUFJPRklMSU5HPXkKIyBDT05GSUdfTUFSS0VSUyBpcyBub3Qgc2V0CkNPTkZJ
R19PUFJPRklMRT1tCkNPTkZJR19IQVZFX09QUk9GSUxFPXkKQ09ORklHX0tQUk9CRVM9eQpDT05G
SUdfSEFWRV9FRkZJQ0lFTlRfVU5BTElHTkVEX0FDQ0VTUz15CkNPTkZJR19LUkVUUFJPQkVTPXkK
Q09ORklHX0hBVkVfSU9SRU1BUF9QUk9UPXkKQ09ORklHX0hBVkVfS1BST0JFUz15CkNPTkZJR19I
QVZFX0tSRVRQUk9CRVM9eQojIENPTkZJR19IQVZFX0FSQ0hfVFJBQ0VIT09LIGlzIG5vdCBzZXQK
IyBDT05GSUdfSEFWRV9ETUFfQVRUUlMgaXMgbm90IHNldApDT05GSUdfVVNFX0dFTkVSSUNfU01Q
X0hFTFBFUlM9eQojIENPTkZJR19IQVZFX0NMSyBpcyBub3Qgc2V0CkNPTkZJR19QUk9DX1BBR0Vf
TU9OSVRPUj15CiMgQ09ORklHX0hBVkVfR0VORVJJQ19ETUFfQ09IRVJFTlQgaXMgbm90IHNldApD
T05GSUdfU0xBQklORk89eQpDT05GSUdfUlRfTVVURVhFUz15CiMgQ09ORklHX1RJTllfU0hNRU0g
aXMgbm90IHNldApDT05GSUdfQkFTRV9TTUFMTD0wCkNPTkZJR19NT0RVTEVTPXkKIyBDT05GSUdf
TU9EVUxFX0ZPUkNFX0xPQUQgaXMgbm90IHNldApDT05GSUdfTU9EVUxFX1VOTE9BRD15CkNPTkZJ
R19NT0RVTEVfRk9SQ0VfVU5MT0FEPXkKIyBDT05GSUdfTU9EVkVSU0lPTlMgaXMgbm90IHNldAoj
IENPTkZJR19NT0RVTEVfU1JDVkVSU0lPTl9BTEwgaXMgbm90IHNldApDT05GSUdfS01PRD15CkNP
TkZJR19TVE9QX01BQ0hJTkU9eQpDT05GSUdfQkxPQ0s9eQpDT05GSUdfQkxLX0RFVl9JT19UUkFD
RT15CkNPTkZJR19CTEtfREVWX0JTRz15CiMgQ09ORklHX0JMS19ERVZfSU5URUdSSVRZIGlzIG5v
dCBzZXQKQ09ORklHX0JMT0NLX0NPTVBBVD15CgojCiMgSU8gU2NoZWR1bGVycwojCkNPTkZJR19J
T1NDSEVEX05PT1A9eQpDT05GSUdfSU9TQ0hFRF9BUz15CkNPTkZJR19JT1NDSEVEX0RFQURMSU5F
PXkKQ09ORklHX0lPU0NIRURfQ0ZRPXkKIyBDT05GSUdfREVGQVVMVF9BUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0RFRkFVTFRfREVBRExJTkUgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9DRlE9eQoj
IENPTkZJR19ERUZBVUxUX05PT1AgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9JT1NDSEVEPSJj
ZnEiCkNPTkZJR19DTEFTU0lDX1JDVT15CgojCiMgUHJvY2Vzc29yIHR5cGUgYW5kIGZlYXR1cmVz
CiMKIyBDT05GSUdfVElDS19PTkVTSE9UIGlzIG5vdCBzZXQKIyBDT05GSUdfTk9fSFogaXMgbm90
IHNldAojIENPTkZJR19ISUdIX1JFU19USU1FUlMgaXMgbm90IHNldApDT05GSUdfR0VORVJJQ19D
TE9DS0VWRU5UU19CVUlMRD15CkNPTkZJR19TTVA9eQpDT05GSUdfWDg2X0ZJTkRfU01QX0NPTkZJ
Rz15CkNPTkZJR19YODZfTVBQQVJTRT15CkNPTkZJR19YODZfUEM9eQojIENPTkZJR19YODZfRUxB
TiBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9WT1lBR0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2
X0dFTkVSSUNBUkNIIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1ZTTVAgaXMgbm90IHNldAojIENP
TkZJR19QQVJBVklSVF9HVUVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX01FTVRFU1QgaXMgbm90IHNl
dAojIENPTkZJR19NMzg2IGlzIG5vdCBzZXQKIyBDT05GSUdfTTQ4NiBpcyBub3Qgc2V0CiMgQ09O
RklHX001ODYgaXMgbm90IHNldAojIENPTkZJR19NNTg2VFNDIGlzIG5vdCBzZXQKIyBDT05GSUdf
TTU4Nk1NWCBpcyBub3Qgc2V0CiMgQ09ORklHX002ODYgaXMgbm90IHNldAojIENPTkZJR19NUEVO
VElVTUlJIGlzIG5vdCBzZXQKIyBDT05GSUdfTVBFTlRJVU1JSUkgaXMgbm90IHNldAojIENPTkZJ
R19NUEVOVElVTU0gaXMgbm90IHNldAojIENPTkZJR19NUEVOVElVTTQgaXMgbm90IHNldAojIENP
TkZJR19NSzYgaXMgbm90IHNldAojIENPTkZJR19NSzcgaXMgbm90IHNldAojIENPTkZJR19NSzgg
aXMgbm90IHNldAojIENPTkZJR19NQ1JVU09FIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVGRklDRU9O
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJTkNISVBDNiBpcyBub3Qgc2V0CiMgQ09ORklHX01XSU5D
SElQMiBpcyBub3Qgc2V0CiMgQ09ORklHX01XSU5DSElQM0QgaXMgbm90IHNldAojIENPTkZJR19N
R0VPREVHWDEgaXMgbm90IHNldAojIENPTkZJR19NR0VPREVfTFggaXMgbm90IHNldAojIENPTkZJ
R19NQ1lSSVhJSUkgaXMgbm90IHNldAojIENPTkZJR19NVklBQzNfMiBpcyBub3Qgc2V0CiMgQ09O
RklHX01WSUFDNyBpcyBub3Qgc2V0CiMgQ09ORklHX01QU0MgaXMgbm90IHNldAojIENPTkZJR19N
Q09SRTIgaXMgbm90IHNldApDT05GSUdfR0VORVJJQ19DUFU9eQpDT05GSUdfWDg2X0NQVT15CkNP
TkZJR19YODZfTDFfQ0FDSEVfQllURVM9MTI4CkNPTkZJR19YODZfSU5URVJOT0RFX0NBQ0hFX0JZ
VEVTPTEyOApDT05GSUdfWDg2X0NNUFhDSEc9eQpDT05GSUdfWDg2X0wxX0NBQ0hFX1NISUZUPTcK
Q09ORklHX1g4Nl9XUF9XT1JLU19PSz15CkNPTkZJR19YODZfVFNDPXkKQ09ORklHX1g4Nl9DTVBY
Q0hHNjQ9eQpDT05GSUdfWDg2X0NNT1Y9eQpDT05GSUdfWDg2X01JTklNVU1fQ1BVX0ZBTUlMWT02
NApDT05GSUdfWDg2X0RFQlVHQ1RMTVNSPXkKQ09ORklHX0hQRVRfVElNRVI9eQpDT05GSUdfSFBF
VF9FTVVMQVRFX1JUQz15CkNPTkZJR19ETUk9eQpDT05GSUdfR0FSVF9JT01NVT15CiMgQ09ORklH
X0NBTEdBUllfSU9NTVUgaXMgbm90IHNldAojIENPTkZJR19BTURfSU9NTVUgaXMgbm90IHNldApD
T05GSUdfU1dJT1RMQj15CkNPTkZJR19JT01NVV9IRUxQRVI9eQojIENPTkZJR19NQVhTTVAgaXMg
bm90IHNldApDT05GSUdfTlJfQ1BVUz04CiMgQ09ORklHX1NDSEVEX1NNVCBpcyBub3Qgc2V0CkNP
TkZJR19TQ0hFRF9NQz15CiMgQ09ORklHX1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19Q
UkVFTVBUX1ZPTFVOVEFSWT15CiMgQ09ORklHX1BSRUVNUFQgaXMgbm90IHNldApDT05GSUdfWDg2
X0xPQ0FMX0FQSUM9eQpDT05GSUdfWDg2X0lPX0FQSUM9eQpDT05GSUdfWDg2X01DRT15CkNPTkZJ
R19YODZfTUNFX0lOVEVMPXkKQ09ORklHX1g4Nl9NQ0VfQU1EPXkKIyBDT05GSUdfSThLIGlzIG5v
dCBzZXQKQ09ORklHX01JQ1JPQ09ERT15CkNPTkZJR19NSUNST0NPREVfT0xEX0lOVEVSRkFDRT15
CkNPTkZJR19YODZfTVNSPXkKQ09ORklHX1g4Nl9DUFVJRD15CkNPTkZJR19OVU1BPXkKQ09ORklH
X0s4X05VTUE9eQpDT05GSUdfWDg2XzY0X0FDUElfTlVNQT15CkNPTkZJR19OT0RFU19TUEFOX09U
SEVSX05PREVTPXkKIyBDT05GSUdfTlVNQV9FTVUgaXMgbm90IHNldApDT05GSUdfTk9ERVNfU0hJ
RlQ9NgpDT05GSUdfQVJDSF9TUEFSU0VNRU1fREVGQVVMVD15CkNPTkZJR19BUkNIX1NQQVJTRU1F
TV9FTkFCTEU9eQpDT05GSUdfQVJDSF9TRUxFQ1RfTUVNT1JZX01PREVMPXkKQ09ORklHX1NFTEVD
VF9NRU1PUllfTU9ERUw9eQojIENPTkZJR19GTEFUTUVNX01BTlVBTCBpcyBub3Qgc2V0CiMgQ09O
RklHX0RJU0NPTlRJR01FTV9NQU5VQUwgaXMgbm90IHNldApDT05GSUdfU1BBUlNFTUVNX01BTlVB
TD15CkNPTkZJR19TUEFSU0VNRU09eQpDT05GSUdfTkVFRF9NVUxUSVBMRV9OT0RFUz15CkNPTkZJ
R19IQVZFX01FTU9SWV9QUkVTRU5UPXkKIyBDT05GSUdfU1BBUlNFTUVNX1NUQVRJQyBpcyBub3Qg
c2V0CkNPTkZJR19TUEFSU0VNRU1fRVhUUkVNRT15CkNPTkZJR19TUEFSU0VNRU1fVk1FTU1BUF9F
TkFCTEU9eQpDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVA9eQoKIwojIE1lbW9yeSBob3RwbHVnIGlz
IGN1cnJlbnRseSBpbmNvbXBhdGlibGUgd2l0aCBTb2Z0d2FyZSBTdXNwZW5kCiMKQ09ORklHX1BB
R0VGTEFHU19FWFRFTkRFRD15CkNPTkZJR19TUExJVF9QVExPQ0tfQ1BVUz00CkNPTkZJR19NSUdS
QVRJT049eQpDT05GSUdfUkVTT1VSQ0VTXzY0QklUPXkKQ09ORklHX1pPTkVfRE1BX0ZMQUc9MQpD
T05GSUdfQk9VTkNFPXkKQ09ORklHX1ZJUlRfVE9fQlVTPXkKQ09ORklHX01UUlI9eQojIENPTkZJ
R19NVFJSX1NBTklUSVpFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9QQVQgaXMgbm90IHNldAoj
IENPTkZJR19FRkkgaXMgbm90IHNldAojIENPTkZJR19TRUNDT01QIGlzIG5vdCBzZXQKIyBDT05G
SUdfSFpfMTAwIGlzIG5vdCBzZXQKQ09ORklHX0haXzI1MD15CiMgQ09ORklHX0haXzMwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0haXzEwMDAgaXMgbm90IHNldApDT05GSUdfSFo9MjUwCiMgQ09ORklH
X1NDSEVEX0hSVElDSyBpcyBub3Qgc2V0CkNPTkZJR19LRVhFQz15CkNPTkZJR19DUkFTSF9EVU1Q
PXkKQ09ORklHX1BIWVNJQ0FMX1NUQVJUPTB4MjAwMDAwCiMgQ09ORklHX1JFTE9DQVRBQkxFIGlz
IG5vdCBzZXQKQ09ORklHX1BIWVNJQ0FMX0FMSUdOPTB4MjAwMDAwCkNPTkZJR19IT1RQTFVHX0NQ
VT15CkNPTkZJR19DT01QQVRfVkRTTz15CkNPTkZJR19BUkNIX0VOQUJMRV9NRU1PUllfSE9UUExV
Rz15CkNPTkZJR19IQVZFX0FSQ0hfRUFSTFlfUEZOX1RPX05JRD15CgojCiMgUG93ZXIgbWFuYWdl
bWVudCBvcHRpb25zCiMKQ09ORklHX0FSQ0hfSElCRVJOQVRJT05fSEVBREVSPXkKQ09ORklHX1BN
PXkKIyBDT05GSUdfUE1fREVCVUcgaXMgbm90IHNldApDT05GSUdfUE1fU0xFRVBfU01QPXkKQ09O
RklHX1BNX1NMRUVQPXkKQ09ORklHX1NVU1BFTkQ9eQpDT05GSUdfU1VTUEVORF9GUkVFWkVSPXkK
Q09ORklHX0hJQkVSTkFUSU9OPXkKQ09ORklHX1BNX1NURF9QQVJUSVRJT049IiIKQ09ORklHX0FD
UEk9eQpDT05GSUdfQUNQSV9TTEVFUD15CkNPTkZJR19BQ1BJX1BST0NGUz15CkNPTkZJR19BQ1BJ
X1BST0NGU19QT1dFUj15CkNPTkZJR19BQ1BJX1NZU0ZTX1BPV0VSPXkKQ09ORklHX0FDUElfUFJP
Q19FVkVOVD15CkNPTkZJR19BQ1BJX0FDPXkKIyBDT05GSUdfQUNQSV9CQVRURVJZIGlzIG5vdCBz
ZXQKQ09ORklHX0FDUElfQlVUVE9OPXkKQ09ORklHX0FDUElfRkFOPXkKIyBDT05GSUdfQUNQSV9E
T0NLIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfUFJPQ0VTU09SPXkKQ09ORklHX0FDUElfSE9UUExV
R19DUFU9eQpDT05GSUdfQUNQSV9USEVSTUFMPXkKQ09ORklHX0FDUElfTlVNQT15CiMgQ09ORklH
X0FDUElfV01JIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9BU1VTIGlzIG5vdCBzZXQKIyBDT05G
SUdfQUNQSV9UT1NISUJBIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9DVVNUT01fRFNEVCBpcyBu
b3Qgc2V0CkNPTkZJR19BQ1BJX0JMQUNLTElTVF9ZRUFSPTAKIyBDT05GSUdfQUNQSV9ERUJVRyBp
cyBub3Qgc2V0CkNPTkZJR19BQ1BJX0VDPXkKIyBDT05GSUdfQUNQSV9QQ0lfU0xPVCBpcyBub3Qg
c2V0CkNPTkZJR19BQ1BJX1BPV0VSPXkKQ09ORklHX0FDUElfU1lTVEVNPXkKQ09ORklHX1g4Nl9Q
TV9USU1FUj15CkNPTkZJR19BQ1BJX0NPTlRBSU5FUj15CiMgQ09ORklHX0FDUElfU0JTIGlzIG5v
dCBzZXQKCiMKIyBDUFUgRnJlcXVlbmN5IHNjYWxpbmcKIwpDT05GSUdfQ1BVX0ZSRVE9eQpDT05G
SUdfQ1BVX0ZSRVFfVEFCTEU9eQpDT05GSUdfQ1BVX0ZSRVFfREVCVUc9eQpDT05GSUdfQ1BVX0ZS
RVFfU1RBVD15CkNPTkZJR19DUFVfRlJFUV9TVEFUX0RFVEFJTFM9eQojIENPTkZJR19DUFVfRlJF
UV9ERUZBVUxUX0dPVl9QRVJGT1JNQU5DRSBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9GUkVRX0RF
RkFVTFRfR09WX1BPV0VSU0FWRSBpcyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dP
Vl9VU0VSU1BBQ0U9eQojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9PTkRFTUFORCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX0NPTlNFUlZBVElWRSBpcyBub3Qg
c2V0CkNPTkZJR19DUFVfRlJFUV9HT1ZfUEVSRk9STUFOQ0U9eQpDT05GSUdfQ1BVX0ZSRVFfR09W
X1BPV0VSU0FWRT15CkNPTkZJR19DUFVfRlJFUV9HT1ZfVVNFUlNQQUNFPXkKQ09ORklHX0NQVV9G
UkVRX0dPVl9PTkRFTUFORD15CkNPTkZJR19DUFVfRlJFUV9HT1ZfQ09OU0VSVkFUSVZFPXkKCiMK
IyBDUFVGcmVxIHByb2Nlc3NvciBkcml2ZXJzCiMKQ09ORklHX1g4Nl9BQ1BJX0NQVUZSRVE9eQpD
T05GSUdfWDg2X1BPV0VSTk9XX0s4PXkKQ09ORklHX1g4Nl9QT1dFUk5PV19LOF9BQ1BJPXkKQ09O
RklHX1g4Nl9TUEVFRFNURVBfQ0VOVFJJTk89eQpDT05GSUdfWDg2X1A0X0NMT0NLTU9EPXkKCiMK
IyBzaGFyZWQgb3B0aW9ucwojCkNPTkZJR19YODZfQUNQSV9DUFVGUkVRX1BST0NfSU5URj15CkNP
TkZJR19YODZfU1BFRURTVEVQX0xJQj15CkNPTkZJR19DUFVfSURMRT15CkNPTkZJR19DUFVfSURM
RV9HT1ZfTEFEREVSPXkKCiMKIyBCdXMgb3B0aW9ucyAoUENJIGV0Yy4pCiMKQ09ORklHX1BDST15
CkNPTkZJR19QQ0lfRElSRUNUPXkKQ09ORklHX1BDSV9NTUNPTkZJRz15CkNPTkZJR19QQ0lfRE9N
QUlOUz15CiMgQ09ORklHX0RNQVIgaXMgbm90IHNldApDT05GSUdfUENJRVBPUlRCVVM9eQojIENP
TkZJR19QQ0lFQUVSIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJRUFTUE0gaXMgbm90IHNldApDT05G
SUdfQVJDSF9TVVBQT1JUU19NU0k9eQpDT05GSUdfUENJX01TST15CkNPTkZJR19QQ0lfTEVHQUNZ
PXkKIyBDT05GSUdfUENJX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0hUX0lSUT15CkNPTkZJR19J
U0FfRE1BX0FQST15CkNPTkZJR19LOF9OQj15CiMgQ09ORklHX1BDQ0FSRCBpcyBub3Qgc2V0CiMg
Q09ORklHX0hPVFBMVUdfUENJIGlzIG5vdCBzZXQKCiMKIyBFeGVjdXRhYmxlIGZpbGUgZm9ybWF0
cyAvIEVtdWxhdGlvbnMKIwpDT05GSUdfQklORk1UX0VMRj15CkNPTkZJR19DT01QQVRfQklORk1U
X0VMRj15CkNPTkZJR19CSU5GTVRfTUlTQz15CkNPTkZJR19JQTMyX0VNVUxBVElPTj15CkNPTkZJ
R19JQTMyX0FPVVQ9eQpDT05GSUdfQ09NUEFUPXkKQ09ORklHX0NPTVBBVF9GT1JfVTY0X0FMSUdO
TUVOVD15CkNPTkZJR19TWVNWSVBDX0NPTVBBVD15CkNPTkZJR19ORVQ9eQoKIwojIE5ldHdvcmtp
bmcgb3B0aW9ucwojCkNPTkZJR19QQUNLRVQ9eQpDT05GSUdfUEFDS0VUX01NQVA9eQpDT05GSUdf
VU5JWD15CkNPTkZJR19YRlJNPXkKQ09ORklHX1hGUk1fVVNFUj15CiMgQ09ORklHX1hGUk1fU1VC
X1BPTElDWSBpcyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fTUlHUkFURSBpcyBub3Qgc2V0CiMgQ09O
RklHX1hGUk1fU1RBVElTVElDUyBpcyBub3Qgc2V0CkNPTkZJR19YRlJNX0lQQ09NUD15CkNPTkZJ
R19ORVRfS0VZPXkKIyBDT05GSUdfTkVUX0tFWV9NSUdSQVRFIGlzIG5vdCBzZXQKQ09ORklHX0lO
RVQ9eQpDT05GSUdfSVBfTVVMVElDQVNUPXkKQ09ORklHX0lQX0FEVkFOQ0VEX1JPVVRFUj15CkNP
TkZJR19BU0tfSVBfRklCX0hBU0g9eQojIENPTkZJR19JUF9GSUJfVFJJRSBpcyBub3Qgc2V0CkNP
TkZJR19JUF9GSUJfSEFTSD15CkNPTkZJR19JUF9NVUxUSVBMRV9UQUJMRVM9eQpDT05GSUdfSVBf
Uk9VVEVfTVVMVElQQVRIPXkKQ09ORklHX0lQX1JPVVRFX1ZFUkJPU0U9eQojIENPTkZJR19JUF9Q
TlAgaXMgbm90IHNldApDT05GSUdfTkVUX0lQSVA9eQpDT05GSUdfTkVUX0lQR1JFPXkKQ09ORklH
X05FVF9JUEdSRV9CUk9BRENBU1Q9eQpDT05GSUdfSVBfTVJPVVRFPXkKQ09ORklHX0lQX1BJTVNN
X1YxPXkKQ09ORklHX0lQX1BJTVNNX1YyPXkKIyBDT05GSUdfQVJQRCBpcyBub3Qgc2V0CkNPTkZJ
R19TWU5fQ09PS0lFUz15CkNPTkZJR19JTkVUX0FIPXkKQ09ORklHX0lORVRfRVNQPXkKQ09ORklH
X0lORVRfSVBDT01QPXkKQ09ORklHX0lORVRfWEZSTV9UVU5ORUw9eQpDT05GSUdfSU5FVF9UVU5O
RUw9eQpDT05GSUdfSU5FVF9YRlJNX01PREVfVFJBTlNQT1JUPXkKQ09ORklHX0lORVRfWEZSTV9N
T0RFX1RVTk5FTD15CkNPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUPXkKIyBDT05GSUdfSU5FVF9M
Uk8gaXMgbm90IHNldApDT05GSUdfSU5FVF9ESUFHPXkKQ09ORklHX0lORVRfVENQX0RJQUc9eQpD
T05GSUdfVENQX0NPTkdfQURWQU5DRUQ9eQpDT05GSUdfVENQX0NPTkdfQklDPXkKQ09ORklHX1RD
UF9DT05HX0NVQklDPW0KQ09ORklHX1RDUF9DT05HX1dFU1RXT09EPW0KQ09ORklHX1RDUF9DT05H
X0hUQ1A9bQpDT05GSUdfVENQX0NPTkdfSFNUQ1A9bQpDT05GSUdfVENQX0NPTkdfSFlCTEE9bQpD
T05GSUdfVENQX0NPTkdfVkVHQVM9bQpDT05GSUdfVENQX0NPTkdfU0NBTEFCTEU9bQpDT05GSUdf
VENQX0NPTkdfTFA9bQpDT05GSUdfVENQX0NPTkdfVkVOTz1tCkNPTkZJR19UQ1BfQ09OR19ZRUFI
PW0KQ09ORklHX1RDUF9DT05HX0lMTElOT0lTPW0KQ09ORklHX0RFRkFVTFRfQklDPXkKIyBDT05G
SUdfREVGQVVMVF9DVUJJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfSFRDUCBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFRkFVTFRfVkVHQVMgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX1dF
U1RXT09EIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9SRU5PIGlzIG5vdCBzZXQKQ09ORklH
X0RFRkFVTFRfVENQX0NPTkc9ImJpYyIKIyBDT05GSUdfVENQX01ENVNJRyBpcyBub3Qgc2V0CiMg
Q09ORklHX0lQVjYgaXMgbm90IHNldAojIENPTkZJR19ORVRXT1JLX1NFQ01BUksgaXMgbm90IHNl
dAojIENPTkZJR19ORVRGSUxURVIgaXMgbm90IHNldAojIENPTkZJR19JUF9EQ0NQIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSVBfU0NUUCBpcyBub3Qgc2V0CiMgQ09ORklHX1RJUEMgaXMgbm90IHNldAoj
IENPTkZJR19BVE0gaXMgbm90IHNldAojIENPTkZJR19CUklER0UgaXMgbm90IHNldAojIENPTkZJ
R19WTEFOXzgwMjFRIGlzIG5vdCBzZXQKIyBDT05GSUdfREVDTkVUIGlzIG5vdCBzZXQKIyBDT05G
SUdfTExDMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQUxL
IGlzIG5vdCBzZXQKIyBDT05GSUdfWDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfTEFQQiBpcyBub3Qg
c2V0CiMgQ09ORklHX0VDT05FVCBpcyBub3Qgc2V0CiMgQ09ORklHX1dBTl9ST1VURVIgaXMgbm90
IHNldAojIENPTkZJR19ORVRfU0NIRUQgaXMgbm90IHNldAoKIwojIE5ldHdvcmsgdGVzdGluZwoj
CiMgQ09ORklHX05FVF9QS1RHRU4gaXMgbm90IHNldAojIENPTkZJR19ORVRfVENQUFJPQkUgaXMg
bm90IHNldAojIENPTkZJR19IQU1SQURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0NBTiBpcyBub3Qg
c2V0CiMgQ09ORklHX0lSREEgaXMgbm90IHNldAojIENPTkZJR19CVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FGX1JYUlBDIGlzIG5vdCBzZXQKQ09ORklHX0ZJQl9SVUxFUz15CgojCiMgV2lyZWxlc3MK
IwojIENPTkZJR19DRkc4MDIxMSBpcyBub3Qgc2V0CiMgQ09ORklHX1dJUkVMRVNTX0VYVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01BQzgwMjExIGlzIG5vdCBzZXQKIyBDT05GSUdfSUVFRTgwMjExIGlz
IG5vdCBzZXQKIyBDT05GSUdfUkZLSUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUXzlQIGlzIG5v
dCBzZXQKCiMKIyBEZXZpY2UgRHJpdmVycwojCgojCiMgR2VuZXJpYyBEcml2ZXIgT3B0aW9ucwoj
CkNPTkZJR19VRVZFTlRfSEVMUEVSX1BBVEg9Ii9zYmluL2hvdHBsdWciCkNPTkZJR19TVEFOREFM
T05FPXkKQ09ORklHX1BSRVZFTlRfRklSTVdBUkVfQlVJTEQ9eQpDT05GSUdfRldfTE9BREVSPXkK
Q09ORklHX0ZJUk1XQVJFX0lOX0tFUk5FTD15CkNPTkZJR19FWFRSQV9GSVJNV0FSRT0iIgojIENP
TkZJR19ERUJVR19EUklWRVIgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19ERVZSRVMgaXMgbm90
IHNldAojIENPTkZJR19TWVNfSFlQRVJWSVNPUiBpcyBub3Qgc2V0CkNPTkZJR19DT05ORUNUT1I9
eQpDT05GSUdfUFJPQ19FVkVOVFM9eQojIENPTkZJR19NVEQgaXMgbm90IHNldApDT05GSUdfUEFS
UE9SVD1tCkNPTkZJR19QQVJQT1JUX1BDPW0KQ09ORklHX1BBUlBPUlRfU0VSSUFMPW0KIyBDT05G
SUdfUEFSUE9SVF9QQ19GSUZPIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFSUE9SVF9QQ19TVVBFUklP
IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFSUE9SVF9HU0MgaXMgbm90IHNldAojIENPTkZJR19QQVJQ
T1JUX0FYODg3OTYgaXMgbm90IHNldApDT05GSUdfUEFSUE9SVF8xMjg0PXkKQ09ORklHX1BOUD15
CiMgQ09ORklHX1BOUF9ERUJVRyBpcyBub3Qgc2V0CgojCiMgUHJvdG9jb2xzCiMKQ09ORklHX1BO
UEFDUEk9eQpDT05GSUdfQkxLX0RFVj15CkNPTkZJR19CTEtfREVWX0ZEPXkKIyBDT05GSUdfUEFS
SURFIGlzIG5vdCBzZXQKQ09ORklHX0JMS19DUFFfREE9bQpDT05GSUdfQkxLX0NQUV9DSVNTX0RB
PW0KIyBDT05GSUdfQ0lTU19TQ1NJX1RBUEUgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0RB
Qzk2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfVU1FTSBpcyBub3Qgc2V0CiMgQ09ORklH
X0JMS19ERVZfQ09XX0NPTU1PTiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0xPT1A9bQpDT05G
SUdfQkxLX0RFVl9DUllQVE9MT09QPW0KIyBDT05GSUdfQkxLX0RFVl9OQkQgaXMgbm90IHNldAoj
IENPTkZJR19CTEtfREVWX1NYOCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfVUIgaXMgbm90
IHNldApDT05GSUdfQkxLX0RFVl9SQU09eQpDT05GSUdfQkxLX0RFVl9SQU1fQ09VTlQ9MTYKQ09O
RklHX0JMS19ERVZfUkFNX1NJWkU9MTYzODQKIyBDT05GSUdfQkxLX0RFVl9YSVAgaXMgbm90IHNl
dApDT05GSUdfQ0RST01fUEtUQ0RWRD1tCkNPTkZJR19DRFJPTV9QS1RDRFZEX0JVRkZFUlM9OAoj
IENPTkZJR19DRFJPTV9QS1RDRFZEX1dDQUNIRSBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQV9PVkVS
X0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSEQgaXMgbm90IHNldApDT05GSUdfTUlT
Q19ERVZJQ0VTPXkKIyBDT05GSUdfSUJNX0FTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1BIQU5UT00g
aXMgbm90IHNldAojIENPTkZJR19FRVBST01fOTNDWDYgaXMgbm90IHNldAojIENPTkZJR19TR0lf
SU9DNCBpcyBub3Qgc2V0CiMgQ09ORklHX1RJRk1fQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZV
SklUU1VfTEFQVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfTVNJX0xBUFRPUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0NPTVBBTF9MQVBUT1AgaXMgbm90IHNldAojIENPTkZJR19TT05ZX0xBUFRPUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RISU5LUEFEX0FDUEkgaXMgbm90IHNldAojIENPTkZJR19JTlRFTF9N
RU5MT1cgaXMgbm90IHNldAojIENPTkZJR19FRUVQQ19MQVBUT1AgaXMgbm90IHNldAojIENPTkZJ
R19FTkNMT1NVUkVfU0VSVklDRVMgaXMgbm90IHNldAojIENPTkZJR19TR0lfWFAgaXMgbm90IHNl
dAojIENPTkZJR19IUF9JTE8gaXMgbm90IHNldAojIENPTkZJR19TR0lfR1JVIGlzIG5vdCBzZXQK
Q09ORklHX0hBVkVfSURFPXkKIyBDT05GSUdfSURFIGlzIG5vdCBzZXQKCiMKIyBTQ1NJIGRldmlj
ZSBzdXBwb3J0CiMKQ09ORklHX1JBSURfQVRUUlM9eQpDT05GSUdfU0NTST15CkNPTkZJR19TQ1NJ
X0RNQT15CkNPTkZJR19TQ1NJX1RHVD15CkNPTkZJR19TQ1NJX05FVExJTks9eQpDT05GSUdfU0NT
SV9QUk9DX0ZTPXkKCiMKIyBTQ1NJIHN1cHBvcnQgdHlwZSAoZGlzaywgdGFwZSwgQ0QtUk9NKQoj
CkNPTkZJR19CTEtfREVWX1NEPXkKIyBDT05GSUdfQ0hSX0RFVl9TVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0NIUl9ERVZfT1NTVCBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1NSPW0KQ09ORklHX0JM
S19ERVZfU1JfVkVORE9SPXkKQ09ORklHX0NIUl9ERVZfU0c9eQpDT05GSUdfQ0hSX0RFVl9TQ0g9
bQoKIwojIFNvbWUgU0NTSSBkZXZpY2VzIChlLmcuIENEIGp1a2Vib3gpIHN1cHBvcnQgbXVsdGlw
bGUgTFVOcwojCkNPTkZJR19TQ1NJX01VTFRJX0xVTj15CkNPTkZJR19TQ1NJX0NPTlNUQU5UUz15
CkNPTkZJR19TQ1NJX0xPR0dJTkc9eQojIENPTkZJR19TQ1NJX1NDQU5fQVNZTkMgaXMgbm90IHNl
dApDT05GSUdfU0NTSV9XQUlUX1NDQU49bQoKIwojIFNDU0kgVHJhbnNwb3J0cwojCkNPTkZJR19T
Q1NJX1NQSV9BVFRSUz15CkNPTkZJR19TQ1NJX0ZDX0FUVFJTPXkKIyBDT05GSUdfU0NTSV9GQ19U
R1RfQVRUUlMgaXMgbm90IHNldApDT05GSUdfU0NTSV9JU0NTSV9BVFRSUz15CkNPTkZJR19TQ1NJ
X1NBU19BVFRSUz15CkNPTkZJR19TQ1NJX1NBU19MSUJTQVM9eQpDT05GSUdfU0NTSV9TQVNfSE9T
VF9TTVA9eQojIENPTkZJR19TQ1NJX1NBU19MSUJTQVNfREVCVUcgaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX1NSUF9BVFRSUyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0xPV0xFVkVMPXkKIyBDT05G
SUdfSVNDU0lfVENQIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl8zV19YWFhYX1JBSUQgaXMg
bm90IHNldAojIENPTkZJR19TQ1NJXzNXXzlYWFggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FD
QVJEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9BQUNSQUlEIGlzIG5vdCBzZXQKQ09ORklHX1ND
U0lfQUlDN1hYWD1tCkNPTkZJR19BSUM3WFhYX0NNRFNfUEVSX0RFVklDRT00CkNPTkZJR19BSUM3
WFhYX1JFU0VUX0RFTEFZX01TPTE1MDAwCiMgQ09ORklHX0FJQzdYWFhfREVCVUdfRU5BQkxFIGlz
IG5vdCBzZXQKQ09ORklHX0FJQzdYWFhfREVCVUdfTUFTSz0wCiMgQ09ORklHX0FJQzdYWFhfUkVH
X1BSRVRUWV9QUklOVCBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0FJQzdYWFhfT0xEPW0KQ09ORklH
X1NDU0lfQUlDNzlYWD1tCkNPTkZJR19BSUM3OVhYX0NNRFNfUEVSX0RFVklDRT00CkNPTkZJR19B
SUM3OVhYX1JFU0VUX0RFTEFZX01TPTE1MDAwCiMgQ09ORklHX0FJQzc5WFhfREVCVUdfRU5BQkxF
IGlzIG5vdCBzZXQKQ09ORklHX0FJQzc5WFhfREVCVUdfTUFTSz0wCiMgQ09ORklHX0FJQzc5WFhf
UkVHX1BSRVRUWV9QUklOVCBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0FJQzk0WFg9bQojIENPTkZJ
R19BSUM5NFhYX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9EUFRfSTJPIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0NTSV9BRFZBTlNZUyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0FSQ01TUj1t
CiMgQ09ORklHX01FR0FSQUlEX05FV0dFTiBpcyBub3Qgc2V0CiMgQ09ORklHX01FR0FSQUlEX0xF
R0FDWSBpcyBub3Qgc2V0CiMgQ09ORklHX01FR0FSQUlEX1NBUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfSFBUSU9QIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9CVVNMT0dJQyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfRE1YMzE5MUQgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0VBVEEgaXMg
bm90IHNldAojIENPTkZJR19TQ1NJX0ZVVFVSRV9ET01BSU4gaXMgbm90IHNldAojIENPTkZJR19T
Q1NJX0dEVEggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0lQUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfSU5JVElPIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JTklBMTAwIGlzIG5vdCBzZXQK
Q09ORklHX1NDU0lfUFBBPW0KQ09ORklHX1NDU0lfSU1NPW0KIyBDT05GSUdfU0NTSV9JWklQX0VQ
UDE2IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JWklQX1NMT1dfQ1RSIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0NTSV9NVlNBUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU1RFWCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfU1lNNTNDOFhYXzIgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1FMT0dJ
Q18xMjgwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9RTEFfRkMgaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX1FMQV9JU0NTSSBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0xQRkM9bQojIENPTkZJR19T
Q1NJX0RDMzk1eCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfREMzOTBUIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0NTSV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX1NSUD15CiMgQ09ORklHX1ND
U0lfREggaXMgbm90IHNldAojIENPTkZJR19BVEEgaXMgbm90IHNldAojIENPTkZJR19NRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZVU0lPTiBpcyBub3Qgc2V0CgojCiMgSUVFRSAxMzk0IChGaXJlV2ly
ZSkgc3VwcG9ydAojCgojCiMgRW5hYmxlIG9ubHkgb25lIG9mIHRoZSB0d28gc3RhY2tzLCB1bmxl
c3MgeW91IGtub3cgd2hhdCB5b3UgYXJlIGRvaW5nCiMKIyBDT05GSUdfRklSRVdJUkUgaXMgbm90
IHNldApDT05GSUdfSUVFRTEzOTQ9bQpDT05GSUdfSUVFRTEzOTRfT0hDSTEzOTQ9bQpDT05GSUdf
SUVFRTEzOTRfUENJTFlOWD1tCkNPTkZJR19JRUVFMTM5NF9TQlAyPW0KIyBDT05GSUdfSUVFRTEz
OTRfU0JQMl9QSFlTX0RNQSBpcyBub3Qgc2V0CkNPTkZJR19JRUVFMTM5NF9FVEgxMzk0X1JPTV9F
TlRSWT15CkNPTkZJR19JRUVFMTM5NF9FVEgxMzk0PW0KQ09ORklHX0lFRUUxMzk0X1JBV0lPPW0K
Q09ORklHX0lFRUUxMzk0X1ZJREVPMTM5ND1tCkNPTkZJR19JRUVFMTM5NF9EVjEzOTQ9bQpDT05G
SUdfSUVFRTEzOTRfVkVSQk9TRURFQlVHPXkKIyBDT05GSUdfSTJPIGlzIG5vdCBzZXQKIyBDT05G
SUdfTUFDSU5UT1NIX0RSSVZFUlMgaXMgbm90IHNldApDT05GSUdfTkVUREVWSUNFUz15CkNPTkZJ
R19EVU1NWT1tCiMgQ09ORklHX0JPTkRJTkcgaXMgbm90IHNldAojIENPTkZJR19NQUNWTEFOIGlz
IG5vdCBzZXQKIyBDT05GSUdfRVFVQUxJWkVSIGlzIG5vdCBzZXQKQ09ORklHX1RVTj15CiMgQ09O
RklHX1ZFVEggaXMgbm90IHNldAojIENPTkZJR19ORVRfU0IxMDAwIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVJDTkVUIGlzIG5vdCBzZXQKQ09ORklHX1BIWUxJQj15CgojCiMgTUlJIFBIWSBkZXZpY2Ug
ZHJpdmVycwojCkNPTkZJR19NQVJWRUxMX1BIWT1tCkNPTkZJR19EQVZJQ09NX1BIWT1tCkNPTkZJ
R19RU0VNSV9QSFk9bQpDT05GSUdfTFhUX1BIWT1tCkNPTkZJR19DSUNBREFfUEhZPW0KQ09ORklH
X1ZJVEVTU0VfUEhZPW0KQ09ORklHX1NNU0NfUEhZPW0KIyBDT05GSUdfQlJPQURDT01fUEhZIGlz
IG5vdCBzZXQKIyBDT05GSUdfSUNQTFVTX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFQUxURUtf
UEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfRklYRURfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTURJ
T19CSVRCQU5HIGlzIG5vdCBzZXQKQ09ORklHX05FVF9FVEhFUk5FVD15CkNPTkZJR19NSUk9eQoj
IENPTkZJR19IQVBQWU1FQUwgaXMgbm90IHNldAojIENPTkZJR19TVU5HRU0gaXMgbm90IHNldAoj
IENPTkZJR19DQVNTSU5JIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl8zQ09NIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX1RVTElQIGlzIG5vdCBzZXQKIyBDT05GSUdfSFAxMDAgaXMgbm90
IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfWk1JSSBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9O
RVdfRU1BQ19SR01JSSBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19UQUggaXMgbm90
IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfRU1BQzQgaXMgbm90IHNldApDT05GSUdfTkVUX1BD
ST15CkNPTkZJR19QQ05FVDMyPW0KQ09ORklHX0FNRDgxMTFfRVRIPW0KIyBDT05GSUdfQURBUFRF
Q19TVEFSRklSRSBpcyBub3Qgc2V0CkNPTkZJR19CNDQ9eQpDT05GSUdfQjQ0X1BDSV9BVVRPU0VM
RUNUPXkKQ09ORklHX0I0NF9QQ0lDT1JFX0FVVE9TRUxFQ1Q9eQpDT05GSUdfQjQ0X1BDST15CkNP
TkZJR19GT1JDRURFVEg9bQpDT05GSUdfRk9SQ0VERVRIX05BUEk9eQojIENPTkZJR19FRVBSTzEw
MCBpcyBub3Qgc2V0CkNPTkZJR19FMTAwPW0KIyBDT05GSUdfRkVBTE5YIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkFUU0VNSSBpcyBub3Qgc2V0CiMgQ09ORklHX05FMktfUENJIGlzIG5vdCBzZXQKIyBD
T05GSUdfODEzOUNQIGlzIG5vdCBzZXQKIyBDT05GSUdfODEzOVRPTyBpcyBub3Qgc2V0CiMgQ09O
RklHX1I2MDQwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0lTOTAwIGlzIG5vdCBzZXQKIyBDT05GSUdf
RVBJQzEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NVTkRBTkNFIGlzIG5vdCBzZXQKIyBDT05GSUdf
VExBTiBpcyBub3Qgc2V0CkNPTkZJR19WSUFfUkhJTkU9bQpDT05GSUdfVklBX1JISU5FX01NSU89
eQojIENPTkZJR19TQzkyMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1BPQ0tFVCBpcyBub3Qg
c2V0CkNPTkZJR19ORVRERVZfMTAwMD15CiMgQ09ORklHX0FDRU5JQyBpcyBub3Qgc2V0CiMgQ09O
RklHX0RMMksgaXMgbm90IHNldApDT05GSUdfRTEwMDA9bQpDT05GSUdfRTEwMDBfRElTQUJMRV9Q
QUNLRVRfU1BMSVQ9eQojIENPTkZJR19FMTAwMEUgaXMgbm90IHNldAojIENPTkZJR19JUDEwMDAg
aXMgbm90IHNldAojIENPTkZJR19JR0IgaXMgbm90IHNldAojIENPTkZJR19OUzgzODIwIGlzIG5v
dCBzZXQKIyBDT05GSUdfSEFNQUNISSBpcyBub3Qgc2V0CiMgQ09ORklHX1lFTExPV0ZJTiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1I4MTY5IGlzIG5vdCBzZXQKIyBDT05GSUdfU0lTMTkwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0tHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NLWTIgaXMgbm90IHNldApDT05G
SUdfVklBX1ZFTE9DSVRZPW0KQ09ORklHX1RJR09OMz1tCkNPTkZJR19CTlgyPXkKIyBDT05GSUdf
UUxBM1hYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTDEgaXMgbm90IHNldAojIENPTkZJR19BVEwx
RSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVERFVl8xMDAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1RS
IGlzIG5vdCBzZXQKCiMKIyBXaXJlbGVzcyBMQU4KIwojIENPTkZJR19XTEFOX1BSRTgwMjExIGlz
IG5vdCBzZXQKIyBDT05GSUdfV0xBTl84MDIxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0lXTFdJRklf
TEVEUyBpcyBub3Qgc2V0CgojCiMgVVNCIE5ldHdvcmsgQWRhcHRlcnMKIwojIENPTkZJR19VU0Jf
Q0FUQyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9LQVdFVEggaXMgbm90IHNldAojIENPTkZJR19V
U0JfUEVHQVNVUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SVEw4MTUwIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1VTQk5FVCBpcyBub3Qgc2V0CiMgQ09ORklHX1dBTiBpcyBub3Qgc2V0CkNPTkZJ
R19GRERJPXkKIyBDT05GSUdfREVGWFggaXMgbm90IHNldAojIENPTkZJR19TS0ZQIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElQUEkgaXMgbm90IHNldAojIENPTkZJR19QTElQIGlzIG5vdCBzZXQKIyBD
T05GSUdfUFBQIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xJUCBpcyBub3Qgc2V0CkNPTkZJR19ORVRf
RkM9eQpDT05GSUdfTkVUQ09OU09MRT15CiMgQ09ORklHX05FVENPTlNPTEVfRFlOQU1JQyBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRQT0xMPXkKQ09ORklHX05FVFBPTExfVFJBUD15CkNPTkZJR19ORVRf
UE9MTF9DT05UUk9MTEVSPXkKIyBDT05GSUdfSVNETiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05F
IGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBkZXZpY2Ugc3VwcG9ydAojCkNPTkZJR19JTlBVVD15CkNP
TkZJR19JTlBVVF9GRl9NRU1MRVNTPXkKQ09ORklHX0lOUFVUX1BPTExERVY9eQoKIwojIFVzZXJs
YW5kIGludGVyZmFjZXMKIwpDT05GSUdfSU5QVVRfTU9VU0VERVY9eQojIENPTkZJR19JTlBVVF9N
T1VTRURFVl9QU0FVWCBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9NT1VTRURFVl9TQ1JFRU5fWD0x
MDI0CkNPTkZJR19JTlBVVF9NT1VTRURFVl9TQ1JFRU5fWT03NjgKIyBDT05GSUdfSU5QVVRfSk9Z
REVWIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX0VWREVWPXkKIyBDT05GSUdfSU5QVVRfRVZCVUcg
aXMgbm90IHNldAoKIwojIElucHV0IERldmljZSBEcml2ZXJzCiMKQ09ORklHX0lOUFVUX0tFWUJP
QVJEPXkKQ09ORklHX0tFWUJPQVJEX0FUS0JEPXkKIyBDT05GSUdfS0VZQk9BUkRfU1VOS0JEIGlz
IG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTEtLQkQgaXMgbm90IHNldAojIENPTkZJR19LRVlC
T0FSRF9YVEtCRCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX05FV1RPTiBpcyBub3Qgc2V0
CiMgQ09ORklHX0tFWUJPQVJEX1NUT1dBV0FZIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX01PVVNF
PXkKQ09ORklHX01PVVNFX1BTMj15CkNPTkZJR19NT1VTRV9QUzJfQUxQUz15CkNPTkZJR19NT1VT
RV9QUzJfTE9HSVBTMlBQPXkKQ09ORklHX01PVVNFX1BTMl9TWU5BUFRJQ1M9eQpDT05GSUdfTU9V
U0VfUFMyX0xJRkVCT09LPXkKQ09ORklHX01PVVNFX1BTMl9UUkFDS1BPSU5UPXkKIyBDT05GSUdf
TU9VU0VfUFMyX1RPVUNIS0lUIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfU0VSSUFMIGlzIG5v
dCBzZXQKIyBDT05GSUdfTU9VU0VfQVBQTEVUT1VDSCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNF
X0JDTTU5NzQgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9WU1hYWEFBIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5QVVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UQUJMRVQgaXMg
bm90IHNldAojIENPTkZJR19JTlBVVF9UT1VDSFNDUkVFTiBpcyBub3Qgc2V0CkNPTkZJR19JTlBV
VF9NSVNDPXkKQ09ORklHX0lOUFVUX1BDU1BLUj15CiMgQ09ORklHX0lOUFVUX0FUTEFTX0JUTlMg
aXMgbm90IHNldAojIENPTkZJR19JTlBVVF9BVElfUkVNT1RFIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5QVVRfQVRJX1JFTU9URTIgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9LRVlTUEFOX1JFTU9U
RSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1BPV0VSTUFURSBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOUFVUX1lFQUxJTksgaXMgbm90IHNldApDT05GSUdfSU5QVVRfVUlOUFVUPXkKCiMKIyBIYXJk
d2FyZSBJL08gcG9ydHMKIwpDT05GSUdfU0VSSU89eQpDT05GSUdfU0VSSU9fSTgwNDI9eQpDT05G
SUdfU0VSSU9fU0VSUE9SVD15CiMgQ09ORklHX1NFUklPX0NUODJDNzEwIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VSSU9fUEFSS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fUENJUFMyIGlzIG5v
dCBzZXQKQ09ORklHX1NFUklPX0xJQlBTMj15CkNPTkZJR19TRVJJT19SQVc9eQojIENPTkZJR19H
QU1FUE9SVCBpcyBub3Qgc2V0CgojCiMgQ2hhcmFjdGVyIGRldmljZXMKIwpDT05GSUdfVlQ9eQpD
T05GSUdfQ09OU09MRV9UUkFOU0xBVElPTlM9eQpDT05GSUdfVlRfQ09OU09MRT15CkNPTkZJR19I
V19DT05TT0xFPXkKQ09ORklHX1ZUX0hXX0NPTlNPTEVfQklORElORz15CkNPTkZJR19ERVZLTUVN
PXkKIyBDT05GSUdfU0VSSUFMX05PTlNUQU5EQVJEIGlzIG5vdCBzZXQKIyBDT05GSUdfTk9aT01J
IGlzIG5vdCBzZXQKCiMKIyBTZXJpYWwgZHJpdmVycwojCkNPTkZJR19TRVJJQUxfODI1MD15CkNP
TkZJR19TRVJJQUxfODI1MF9DT05TT0xFPXkKQ09ORklHX0ZJWF9FQVJMWUNPTl9NRU09eQpDT05G
SUdfU0VSSUFMXzgyNTBfUENJPXkKQ09ORklHX1NFUklBTF84MjUwX1BOUD15CkNPTkZJR19TRVJJ
QUxfODI1MF9OUl9VQVJUUz00CkNPTkZJR19TRVJJQUxfODI1MF9SVU5USU1FX1VBUlRTPTQKIyBD
T05GSUdfU0VSSUFMXzgyNTBfRVhURU5ERUQgaXMgbm90IHNldAoKIwojIE5vbi04MjUwIHNlcmlh
bCBwb3J0IHN1cHBvcnQKIwpDT05GSUdfU0VSSUFMX0NPUkU9eQpDT05GSUdfU0VSSUFMX0NPUkVf
Q09OU09MRT15CiMgQ09ORklHX1NFUklBTF9KU00gaXMgbm90IHNldApDT05GSUdfVU5JWDk4X1BU
WVM9eQojIENPTkZJR19MRUdBQ1lfUFRZUyBpcyBub3Qgc2V0CkNPTkZJR19QUklOVEVSPW0KQ09O
RklHX0xQX0NPTlNPTEU9eQpDT05GSUdfUFBERVY9bQpDT05GSUdfSVBNSV9IQU5ETEVSPXkKQ09O
RklHX0lQTUlfUEFOSUNfRVZFTlQ9eQpDT05GSUdfSVBNSV9QQU5JQ19TVFJJTkc9eQpDT05GSUdf
SVBNSV9ERVZJQ0VfSU5URVJGQUNFPXkKQ09ORklHX0lQTUlfU0k9eQpDT05GSUdfSVBNSV9XQVRD
SERPRz15CkNPTkZJR19JUE1JX1BPV0VST0ZGPXkKQ09ORklHX0hXX1JBTkRPTT15CkNPTkZJR19I
V19SQU5ET01fSU5URUw9eQpDT05GSUdfSFdfUkFORE9NX0FNRD15CkNPTkZJR19OVlJBTT15CiMg
Q09ORklHX1IzOTY0IGlzIG5vdCBzZXQKIyBDT05GSUdfQVBQTElDT00gaXMgbm90IHNldAojIENP
TkZJR19NV0FWRSBpcyBub3Qgc2V0CiMgQ09ORklHX1BDODczNnhfR1BJTyBpcyBub3Qgc2V0CkNP
TkZJR19SQVdfRFJJVkVSPXkKQ09ORklHX01BWF9SQVdfREVWUz04MTkyCkNPTkZJR19IUEVUPXkK
IyBDT05GSUdfSFBFVF9NTUFQIGlzIG5vdCBzZXQKQ09ORklHX0hBTkdDSEVDS19USU1FUj15CiMg
Q09ORklHX1RDR19UUE0gaXMgbm90IHNldAojIENPTkZJR19URUxDTE9DSyBpcyBub3Qgc2V0CkNP
TkZJR19ERVZQT1JUPXkKQ09ORklHX0kyQz15CkNPTkZJR19JMkNfQk9BUkRJTkZPPXkKQ09ORklH
X0kyQ19DSEFSREVWPXkKQ09ORklHX0kyQ19IRUxQRVJfQVVUTz15CkNPTkZJR19JMkNfQUxHT0JJ
VD15CgojCiMgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CiMKCiMKIyBQQyBTTUJ1cyBob3N0IGNv
bnRyb2xsZXIgZHJpdmVycwojCiMgQ09ORklHX0kyQ19BTEkxNTM1IGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX0FMSTE1NjMgaXMgbm90IHNldAojIENPTkZJR19JMkNfQUxJMTVYMyBpcyBub3Qgc2V0
CkNPTkZJR19JMkNfQU1ENzU2PXkKIyBDT05GSUdfSTJDX0FNRDc1Nl9TNDg4MiBpcyBub3Qgc2V0
CkNPTkZJR19JMkNfQU1EODExMT15CkNPTkZJR19JMkNfSTgwMT15CiMgQ09ORklHX0kyQ19JU0NI
IGlzIG5vdCBzZXQKQ09ORklHX0kyQ19QSUlYND15CkNPTkZJR19JMkNfTkZPUkNFMj15CiMgQ09O
RklHX0kyQ19ORk9SQ0UyX1M0OTg1IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJUzU1OTUgaXMg
bm90IHNldAojIENPTkZJR19JMkNfU0lTNjMwIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJUzk2
WCBpcyBub3Qgc2V0CkNPTkZJR19JMkNfVklBPXkKQ09ORklHX0kyQ19WSUFQUk89eQoKIwojIEky
QyBzeXN0ZW0gYnVzIGRyaXZlcnMgKG1vc3RseSBlbWJlZGRlZCAvIHN5c3RlbS1vbi1jaGlwKQoj
CiMgQ09ORklHX0kyQ19PQ09SRVMgaXMgbm90IHNldAojIENPTkZJR19JMkNfU0lNVEVDIGlzIG5v
dCBzZXQKCiMKIyBFeHRlcm5hbCBJMkMvU01CdXMgYWRhcHRlciBkcml2ZXJzCiMKIyBDT05GSUdf
STJDX1BBUlBPUlQgaXMgbm90IHNldAojIENPTkZJR19JMkNfUEFSUE9SVF9MSUdIVCBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19UQU9TX0VWTSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19USU5ZX1VT
QiBpcyBub3Qgc2V0CgojCiMgR3JhcGhpY3MgYWRhcHRlciBJMkMvRERDIGNoYW5uZWwgZHJpdmVy
cwojCiMgQ09ORklHX0kyQ19WT09ET08zIGlzIG5vdCBzZXQKCiMKIyBPdGhlciBJMkMvU01CdXMg
YnVzIGRyaXZlcnMKIwojIENPTkZJR19JMkNfUENBX1BMQVRGT1JNIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX1NUVUIgaXMgbm90IHNldAoKIwojIE1pc2NlbGxhbmVvdXMgSTJDIENoaXAgc3VwcG9y
dAojCiMgQ09ORklHX0RTMTY4MiBpcyBub3Qgc2V0CiMgQ09ORklHX0FUMjQgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0VFUFJPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUENGODU3
NCBpcyBub3Qgc2V0CiMgQ09ORklHX1BDRjg1NzUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X1BDQTk1MzkgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDRjg1OTEgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX01BWDY4NzUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RTTDI1
NTAgaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0kyQ19ERUJVR19BTEdPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0JVUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19ERUJVR19DSElQIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJIGlzIG5v
dCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9PUFRJT05BTF9HUElPTElCPXkKIyBDT05GSUdfR1BJT0xJ
QiBpcyBub3Qgc2V0CiMgQ09ORklHX1cxIGlzIG5vdCBzZXQKQ09ORklHX1BPV0VSX1NVUFBMWT15
CiMgQ09ORklHX1BPV0VSX1NVUFBMWV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BEQV9QT1dF
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfRFMyNzYwIGlzIG5vdCBzZXQKQ09ORklHX0hX
TU9OPXkKQ09ORklHX0hXTU9OX1ZJRD15CiMgQ09ORklHX1NFTlNPUlNfQUJJVFVHVVJVIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19BQklUVUdVUlUzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19BRDc0MTQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FENzQxOCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfQURNMTAyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURN
MTAyNSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAyNiBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfQURNMTAyOSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAzMSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNOTI0MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfQURUNzQ3MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURUNzQ3MyBpcyBub3Qg
c2V0CkNPTkZJR19TRU5TT1JTX0s4VEVNUD15CiMgQ09ORklHX1NFTlNPUlNfQVNCMTAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19BVFhQMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
RFMxNjIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19JNUtfQU1CIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19GNzE4MDVGIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GNzE4ODJG
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjc1Mzc1UyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfRlNDSEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GU0NQT1MgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0ZTQ0hNRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
R0w1MThTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfR0w1MjBTTSBpcyBub3Qgc2V0CkNP
TkZJR19TRU5TT1JTX0NPUkVURU1QPXkKIyBDT05GSUdfU0VOU09SU19JQk1BRU0gaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX0lCTVBFWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSVQ4
NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE02MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfTE03NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03NyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTE03OCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
TE04NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04NyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTE05MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MiBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfTE05MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMTYx
OSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYNjY1MCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfUEM4NzM2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUEM4NzQyNyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0lTNTU5NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfRE1FMTczNyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU01TQzQ3TTEgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1NNU0M0N00xOTIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X1NNU0M0N0IzOTcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FEUzc4MjggaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1RITUM1MCBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX1ZJQTY4
NkE9eQpDT05GSUdfU0VOU09SU19WVDEyMTE9eQpDT05GSUdfU0VOU09SU19WVDgyMzE9eQojIENP
TkZJR19TRU5TT1JTX1c4Mzc4MUQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4Mzc5MUQg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4Mzc5MkQgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX1c4Mzc5MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzTDc4NVRTIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19XODNMNzg2TkcgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX1c4MzYyN0hGIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODM2MjdFSEYgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0hEQVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19B
UFBMRVNNQyBpcyBub3Qgc2V0CiMgQ09ORklHX0hXTU9OX0RFQlVHX0NISVAgaXMgbm90IHNldApD
T05GSUdfVEhFUk1BTD15CiMgQ09ORklHX1RIRVJNQUxfSFdNT04gaXMgbm90IHNldApDT05GSUdf
V0FUQ0hET0c9eQojIENPTkZJR19XQVRDSERPR19OT1dBWU9VVCBpcyBub3Qgc2V0CgojCiMgV2F0
Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwpDT05GSUdfU09GVF9XQVRDSERPRz15CiMgQ09ORklHX0FD
UVVJUkVfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfQURWQU5URUNIX1dEVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FMSU0xNTM1X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FMSU03MTAxX1dEVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDNTIwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0VVUk9URUNIX1dE
VCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCNzAwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTUFT
UiBpcyBub3Qgc2V0CiMgQ09ORklHX1dBRkVSX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0k2MzAw
RVNCX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lUQ09fV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdf
SVQ4NzEyRl9XRFQgaXMgbm90IHNldAojIENPTkZJR19IUF9XQVRDSERPRyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NDMTIwMF9XRFQgaXMgbm90IHNldAojIENPTkZJR19QQzg3NDEzX1dEVCBpcyBub3Qg
c2V0CiMgQ09ORklHXzYwWFhfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0JDODM2MF9XRFQgaXMg
bm90IHNldAojIENPTkZJR19DUFU1X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NNU0MzN0I3ODdf
V0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzNjI3SEZfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdf
VzgzNjk3SEZfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzODc3Rl9XRFQgaXMgbm90IHNldAoj
IENPTkZJR19XODM5NzdGX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ0haX1dEVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NCQ19FUFhfQzNfV0FUQ0hET0cgaXMgbm90IHNldAoKIwojIFBDSS1iYXNl
ZCBXYXRjaGRvZyBDYXJkcwojCiMgQ09ORklHX1BDSVBDV0FUQ0hET0cgaXMgbm90IHNldAojIENP
TkZJR19XRFRQQ0kgaXMgbm90IHNldAoKIwojIFVTQi1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCiMg
Q09ORklHX1VTQlBDV0FUQ0hET0cgaXMgbm90IHNldAoKIwojIFNvbmljcyBTaWxpY29uIEJhY2tw
bGFuZQojCkNPTkZJR19TU0JfUE9TU0lCTEU9eQpDT05GSUdfU1NCPXkKQ09ORklHX1NTQl9TUFJP
TT15CkNPTkZJR19TU0JfUENJSE9TVF9QT1NTSUJMRT15CkNPTkZJR19TU0JfUENJSE9TVD15CiMg
Q09ORklHX1NTQl9CNDNfUENJX0JSSURHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NTQl9TSUxFTlQg
aXMgbm90IHNldAojIENPTkZJR19TU0JfREVCVUcgaXMgbm90IHNldApDT05GSUdfU1NCX0RSSVZF
Ul9QQ0lDT1JFX1BPU1NJQkxFPXkKQ09ORklHX1NTQl9EUklWRVJfUENJQ09SRT15CgojCiMgTXVs
dGlmdW5jdGlvbiBkZXZpY2UgZHJpdmVycwojCiMgQ09ORklHX01GRF9DT1JFIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUZEX1NNNTAxIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRDX1BBU0lDMyBpcyBub3Qg
c2V0CiMgQ09ORklHX01GRF9UTUlPIGlzIG5vdCBzZXQKCiMKIyBNdWx0aW1lZGlhIGRldmljZXMK
IwoKIwojIE11bHRpbWVkaWEgY29yZSBzdXBwb3J0CiMKIyBDT05GSUdfVklERU9fREVWIGlzIG5v
dCBzZXQKIyBDT05GSUdfRFZCX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19WSURFT19NRURJQSBp
cyBub3Qgc2V0CgojCiMgTXVsdGltZWRpYSBkcml2ZXJzCiMKIyBDT05GSUdfREFCIGlzIG5vdCBz
ZXQKCiMKIyBHcmFwaGljcyBzdXBwb3J0CiMKQ09ORklHX0FHUD15CkNPTkZJR19BR1BfQU1ENjQ9
eQpDT05GSUdfQUdQX0lOVEVMPXkKIyBDT05GSUdfQUdQX1NJUyBpcyBub3Qgc2V0CkNPTkZJR19B
R1BfVklBPXkKQ09ORklHX0RSTT15CiMgQ09ORklHX0RSTV9UREZYIGlzIG5vdCBzZXQKQ09ORklH
X0RSTV9SMTI4PXkKQ09ORklHX0RSTV9SQURFT049eQojIENPTkZJR19EUk1fSTgxMCBpcyBub3Qg
c2V0CiMgQ09ORklHX0RSTV9JODMwIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0k5MTUgaXMgbm90
IHNldAojIENPTkZJR19EUk1fTUdBIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1NJUyBpcyBub3Qg
c2V0CkNPTkZJR19EUk1fVklBPXkKIyBDT05GSUdfRFJNX1NBVkFHRSBpcyBub3Qgc2V0CkNPTkZJ
R19WR0FTVEFURT15CiMgQ09ORklHX1ZJREVPX09VVFBVVF9DT05UUk9MIGlzIG5vdCBzZXQKQ09O
RklHX0ZCPXkKQ09ORklHX0ZJUk1XQVJFX0VESUQ9eQpDT05GSUdfRkJfRERDPXkKQ09ORklHX0ZC
X0NGQl9GSUxMUkVDVD15CkNPTkZJR19GQl9DRkJfQ09QWUFSRUE9eQpDT05GSUdfRkJfQ0ZCX0lN
QUdFQkxJVD15CiMgQ09ORklHX0ZCX0NGQl9SRVZfUElYRUxTX0lOX0JZVEUgaXMgbm90IHNldAoj
IENPTkZJR19GQl9TWVNfRklMTFJFQ1QgaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNfQ09QWUFS
RUEgaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNfSU1BR0VCTElUIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfRk9SRUlHTl9FTkRJQU4gaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNfRk9QUyBpcyBu
b3Qgc2V0CkNPTkZJR19GQl9TVkdBTElCPXkKIyBDT05GSUdfRkJfTUFDTU9ERVMgaXMgbm90IHNl
dApDT05GSUdfRkJfQkFDS0xJR0hUPXkKQ09ORklHX0ZCX01PREVfSEVMUEVSUz15CkNPTkZJR19G
Ql9USUxFQkxJVFRJTkc9eQoKIwojIEZyYW1lIGJ1ZmZlciBoYXJkd2FyZSBkcml2ZXJzCiMKIyBD
T05GSUdfRkJfQ0lSUlVTIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUE0yIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfQ1lCRVIyMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVJDIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkJfQVNJTElBTlQgaXMgbm90IHNldAojIENPTkZJR19GQl9JTVNUVCBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZCX1ZHQTE2IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVVZFU0EgaXMgbm90
IHNldApDT05GSUdfRkJfVkVTQT15CiMgQ09ORklHX0ZCX0VGSSBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX040MTEgaXMgbm90IHNldAojIENPTkZJR19GQl9IR0EgaXMgbm90IHNldAojIENPTkZJR19G
Ql9TMUQxM1hYWCBpcyBub3Qgc2V0CkNPTkZJR19GQl9OVklESUE9eQpDT05GSUdfRkJfTlZJRElB
X0kyQz15CiMgQ09ORklHX0ZCX05WSURJQV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX05W
SURJQV9CQUNLTElHSFQgaXMgbm90IHNldApDT05GSUdfRkJfUklWQT15CiMgQ09ORklHX0ZCX1JJ
VkFfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUklWQV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJ
R19GQl9SSVZBX0JBQ0tMSUdIVD15CiMgQ09ORklHX0ZCX0xFODA1NzggaXMgbm90IHNldAojIENP
TkZJR19GQl9JTlRFTCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX01BVFJPWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX1JBREVPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FUWTEyOCBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZCX0FUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1MzIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfU0FWQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU0lTIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfTkVPTUFHSUMgaXMgbm90IHNldAojIENPTkZJR19GQl9LWVJPIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkJfM0RGWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZPT0RPTzEgaXMgbm90IHNl
dApDT05GSUdfRkJfVlQ4NjIzPXkKIyBDT05GSUdfRkJfVFJJREVOVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX0FSSyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1BNMyBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0NBUk1JTkUgaXMgbm90IHNldAojIENPTkZJR19GQl9HRU9ERSBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX1ZJUlRVQUwgaXMgbm90IHNldApDT05GSUdfQkFDS0xJR0hUX0xDRF9TVVBQT1JUPXkK
IyBDT05GSUdfTENEX0NMQVNTX0RFVklDRSBpcyBub3Qgc2V0CkNPTkZJR19CQUNLTElHSFRfQ0xB
U1NfREVWSUNFPXkKIyBDT05GSUdfQkFDS0xJR0hUX0NPUkdJIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkFDS0xJR0hUX1BST0dFQVIgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfTUJQX05WSURJ
QSBpcyBub3Qgc2V0CgojCiMgRGlzcGxheSBkZXZpY2Ugc3VwcG9ydAojCiMgQ09ORklHX0RJU1BM
QVlfU1VQUE9SVCBpcyBub3Qgc2V0CgojCiMgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0
CiMKQ09ORklHX1ZHQV9DT05TT0xFPXkKQ09ORklHX1ZHQUNPTl9TT0ZUX1NDUk9MTEJBQ0s9eQpD
T05GSUdfVkdBQ09OX1NPRlRfU0NST0xMQkFDS19TSVpFPTY0CkNPTkZJR19WSURFT19TRUxFQ1Q9
eQpDT05GSUdfRFVNTVlfQ09OU09MRT15CkNPTkZJR19GUkFNRUJVRkZFUl9DT05TT0xFPXkKQ09O
RklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVfREVURUNUX1BSSU1BUlk9eQpDT05GSUdfRlJBTUVCVUZG
RVJfQ09OU09MRV9ST1RBVElPTj15CiMgQ09ORklHX0ZPTlRTIGlzIG5vdCBzZXQKQ09ORklHX0ZP
TlRfOHg4PXkKQ09ORklHX0ZPTlRfOHgxNj15CiMgQ09ORklHX0xPR08gaXMgbm90IHNldAojIENP
TkZJR19TT1VORCBpcyBub3Qgc2V0CkNPTkZJR19ISURfU1VQUE9SVD15CkNPTkZJR19ISUQ9eQpD
T05GSUdfSElEX0RFQlVHPXkKIyBDT05GSUdfSElEUkFXIGlzIG5vdCBzZXQKCiMKIyBVU0IgSW5w
dXQgRGV2aWNlcwojCkNPTkZJR19VU0JfSElEPXkKIyBDT05GSUdfVVNCX0hJRElOUFVUX1BPV0VS
Qk9PSyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9GRiBpcyBub3Qgc2V0CkNPTkZJR19VU0JfSElE
REVWPXkKQ09ORklHX1VTQl9TVVBQT1JUPXkKQ09ORklHX1VTQl9BUkNIX0hBU19IQ0Q9eQpDT05G
SUdfVVNCX0FSQ0hfSEFTX09IQ0k9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX0VIQ0k9eQpDT05GSUdf
VVNCPXkKIyBDT05GSUdfVVNCX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0FOTk9VTkNF
X05FV19ERVZJQ0VTIGlzIG5vdCBzZXQKCiMKIyBNaXNjZWxsYW5lb3VzIFVTQiBvcHRpb25zCiMK
Q09ORklHX1VTQl9ERVZJQ0VGUz15CkNPTkZJR19VU0JfREVWSUNFX0NMQVNTPXkKIyBDT05GSUdf
VVNCX0RZTkFNSUNfTUlOT1JTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NVU1BFTkQgaXMgbm90
IHNldAojIENPTkZJR19VU0JfT1RHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09UR19XSElURUxJ
U1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfT1RHX0JMQUNLTElTVF9IVUIgaXMgbm90IHNldApD
T05GSUdfVVNCX01PTj15CgojCiMgVVNCIEhvc3QgQ29udHJvbGxlciBEcml2ZXJzCiMKIyBDT05G
SUdfVVNCX0M2N1gwMF9IQ0QgaXMgbm90IHNldApDT05GSUdfVVNCX0VIQ0lfSENEPW0KQ09ORklH
X1VTQl9FSENJX1JPT1RfSFVCX1RUPXkKQ09ORklHX1VTQl9FSENJX1RUX05FV1NDSEVEPXkKIyBD
T05GSUdfVVNCX0lTUDExNlhfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDE3NjBfSENE
IGlzIG5vdCBzZXQKQ09ORklHX1VTQl9PSENJX0hDRD1tCiMgQ09ORklHX1VTQl9PSENJX0hDRF9T
U0IgaXMgbm90IHNldAojIENPTkZJR19VU0JfT0hDSV9CSUdfRU5ESUFOX0RFU0MgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfT0hDSV9CSUdfRU5ESUFOX01NSU8gaXMgbm90IHNldApDT05GSUdfVVNC
X09IQ0lfTElUVExFX0VORElBTj15CkNPTkZJR19VU0JfVUhDSV9IQ0Q9bQojIENPTkZJR19VU0Jf
U0w4MTFfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1I4QTY2NTk3X0hDRCBpcyBub3Qgc2V0
CgojCiMgVVNCIERldmljZSBDbGFzcyBkcml2ZXJzCiMKIyBDT05GSUdfVVNCX0FDTSBpcyBub3Qg
c2V0CkNPTkZJR19VU0JfUFJJTlRFUj1tCiMgQ09ORklHX1VTQl9XRE0gaXMgbm90IHNldAoKIwoj
IE5PVEU6IFVTQl9TVE9SQUdFIGVuYWJsZXMgU0NTSSwgYW5kICdTQ1NJIGRpc2sgc3VwcG9ydCcK
IwoKIwojIG1heSBhbHNvIGJlIG5lZWRlZDsgc2VlIFVTQl9TVE9SQUdFIEhlbHAgZm9yIG1vcmUg
aW5mb3JtYXRpb24KIwpDT05GSUdfVVNCX1NUT1JBR0U9bQojIENPTkZJR19VU0JfU1RPUkFHRV9E
RUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0RBVEFGQUIgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfU1RPUkFHRV9GUkVFQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JB
R0VfSVNEMjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfRFBDTSBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TVE9SQUdFX1VTQkFUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JB
R0VfU0REUjA5IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfU0REUjU1IGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfSlVNUFNIT1QgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
U1RPUkFHRV9BTEFVREEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9PTkVUT1VDSCBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0tBUk1BIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1NUT1JBR0VfU0lFUlJBIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfQ1lQUkVT
U19BVEFDQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MSUJVU1VBTCBpcyBub3Qgc2V0CgojCiMg
VVNCIEltYWdpbmcgZGV2aWNlcwojCiMgQ09ORklHX1VTQl9NREM4MDAgaXMgbm90IHNldAojIENP
TkZJR19VU0JfTUlDUk9URUsgaXMgbm90IHNldAoKIwojIFVTQiBwb3J0IGRyaXZlcnMKIwojIENP
TkZJR19VU0JfVVNTNzIwIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TRVJJQUw9bQojIENPTkZJR19V
U0JfRVpVU0IgaXMgbm90IHNldApDT05GSUdfVVNCX1NFUklBTF9HRU5FUklDPXkKIyBDT05GSUdf
VVNCX1NFUklBTF9BSVJDQUJMRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfQVJLMzEx
NiBpcyBub3Qgc2V0CkNPTkZJR19VU0JfU0VSSUFMX0JFTEtJTj1tCiMgQ09ORklHX1VTQl9TRVJJ
QUxfQ0gzNDEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1dISVRFSEVBVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfRElHSV9BQ0NFTEVQT1JUIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NFUklBTF9DUDIxMDEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0NZUFJF
U1NfTTggaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0VNUEVHIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1NFUklBTF9GVERJX1NJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxf
RlVOU09GVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfVklTT1IgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfU0VSSUFMX0lQQVEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0lS
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9FREdFUE9SVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9TRVJJQUxfRURHRVBPUlRfVEkgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFM
X0dBUk1JTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfSVBXIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1NFUklBTF9JVVUgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX0tFWVNQ
QU5fUERBIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9LRVlTUEFOIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1NFUklBTF9LTFNJIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9L
T0JJTF9TQ1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX01DVF9VMjMyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1NFUklBTF9NT1M3NzIwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NF
UklBTF9NT1M3ODQwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9NT1RPUk9MQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfTkFWTUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1NFUklBTF9QTDIzMDMgaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX09USTY4NTggaXMg
bm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1NQQ1A4WDUgaXMgbm90IHNldAojIENPTkZJR19V
U0JfU0VSSUFMX0hQNFggaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1NBRkUgaXMgbm90
IHNldAojIENPTkZJR19VU0JfU0VSSUFMX1NJRVJSQVdJUkVMRVNTIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NFUklBTF9USSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfQ1lCRVJKQUNL
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFUklBTF9YSVJDT00gaXMgbm90IHNldAojIENPTkZJ
R19VU0JfU0VSSUFMX09QVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfT01OSU5F
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVJJQUxfREVCVUcgaXMgbm90IHNldAoKIwojIFVT
QiBNaXNjZWxsYW5lb3VzIGRyaXZlcnMKIwojIENPTkZJR19VU0JfRU1JNjIgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfRU1JMjYgaXMgbm90IHNldAojIENPTkZJR19VU0JfQURVVFVYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1JJTzUwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUdPVE9XRVIg
aXMgbm90IHNldAojIENPTkZJR19VU0JfTENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0JFUlJZ
X0NIQVJHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUQgaXMgbm90IHNldAojIENPTkZJR19V
U0JfQ1lQUkVTU19DWTdDNjMgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ1lUSEVSTSBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9QSElER0VUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lETU9VU0Ug
aXMgbm90IHNldAojIENPTkZJR19VU0JfRlRESV9FTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X0FQUExFRElTUExBWSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TSVNVU0JWR0EgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfTEQgaXMgbm90IHNldAojIENPTkZJR19VU0JfVFJBTkNFVklCUkFUT1Ig
aXMgbm90IHNldAojIENPTkZJR19VU0JfSU9XQVJSSU9SIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X1RFU1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfSVNJR0hURlcgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfR0FER0VUIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUVNU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19ORVdfTEVEUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0FDQ0VTU0lCSUxJVFkgaXMgbm90IHNldAojIENPTkZJR19JTkZJTklCQU5EIGlzIG5vdCBzZXQK
Q09ORklHX0VEQUM9eQoKIwojIFJlcG9ydGluZyBzdWJzeXN0ZW1zCiMKIyBDT05GSUdfRURBQ19E
RUJVRyBpcyBub3Qgc2V0CkNPTkZJR19FREFDX01NX0VEQUM9eQpDT05GSUdfRURBQ19FNzUyWD15
CkNPTkZJR19FREFDX0k4Mjk3NVg9eQojIENPTkZJR19FREFDX0kzMDAwIGlzIG5vdCBzZXQKQ09O
RklHX0VEQUNfSTUwMDA9eQojIENPTkZJR19FREFDX0k1MTAwIGlzIG5vdCBzZXQKQ09ORklHX1JU
Q19MSUI9eQpDT05GSUdfUlRDX0NMQVNTPXkKQ09ORklHX1JUQ19IQ1RPU1lTPXkKQ09ORklHX1JU
Q19IQ1RPU1lTX0RFVklDRT0icnRjMCIKIyBDT05GSUdfUlRDX0RFQlVHIGlzIG5vdCBzZXQKCiMK
IyBSVEMgaW50ZXJmYWNlcwojCkNPTkZJR19SVENfSU5URl9TWVNGUz15CkNPTkZJR19SVENfSU5U
Rl9QUk9DPXkKQ09ORklHX1JUQ19JTlRGX0RFVj15CiMgQ09ORklHX1JUQ19JTlRGX0RFVl9VSUVf
RU1VTCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfVEVTVCBpcyBub3Qgc2V0CgojCiMgSTJD
IFJUQyBkcml2ZXJzCiMKIyBDT05GSUdfUlRDX0RSVl9EUzEzMDcgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX0RTMTM3NCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxNjcyIGlzIG5v
dCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NQVg2OTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9SUzVDMzcyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9JU0wxMjA4IGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRDX0RSVl9YMTIwNSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU2
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU4MyBpcyBub3Qgc2V0CiMgQ09ORklH
X1JUQ19EUlZfTTQxVDgwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9TMzUzOTBBIGlzIG5v
dCBzZXQKIyBDT05GSUdfUlRDX0RSVl9GTTMxMzAgaXMgbm90IHNldAoKIwojIFNQSSBSVEMgZHJp
dmVycwojCgojCiMgUGxhdGZvcm0gUlRDIGRyaXZlcnMKIwpDT05GSUdfUlRDX0RSVl9DTU9TPXkK
IyBDT05GSUdfUlRDX0RSVl9EUzE1MTEgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTU1
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxNzQyIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0RSVl9TVEsxN1RBOCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDg2IGlzIG5v
dCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NNDhUNTkgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJW
X1YzMDIwIGlzIG5vdCBzZXQKCiMKIyBvbi1DUFUgUlRDIGRyaXZlcnMKIwojIENPTkZJR19ETUFE
RVZJQ0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfQVVYRElTUExBWSBpcyBub3Qgc2V0CiMgQ09ORklH
X1VJTyBpcyBub3Qgc2V0CgojCiMgRmlybXdhcmUgRHJpdmVycwojCkNPTkZJR19FREQ9eQojIENP
TkZJR19FRERfT0ZGIGlzIG5vdCBzZXQKQ09ORklHX0ZJUk1XQVJFX01FTU1BUD15CiMgQ09ORklH
X0RFTExfUkJVIGlzIG5vdCBzZXQKIyBDT05GSUdfRENEQkFTIGlzIG5vdCBzZXQKQ09ORklHX0RN
SUlEPXkKIyBDT05GSUdfSVNDU0lfSUJGVF9GSU5EIGlzIG5vdCBzZXQKCiMKIyBGaWxlIHN5c3Rl
bXMKIwpDT05GSUdfRVhUMl9GUz15CkNPTkZJR19FWFQyX0ZTX1hBVFRSPXkKQ09ORklHX0VYVDJf
RlNfUE9TSVhfQUNMPXkKQ09ORklHX0VYVDJfRlNfU0VDVVJJVFk9eQpDT05GSUdfRVhUMl9GU19Y
SVA9eQpDT05GSUdfRlNfWElQPXkKQ09ORklHX0VYVDNfRlM9eQpDT05GSUdfRVhUM19GU19YQVRU
Uj15CkNPTkZJR19FWFQzX0ZTX1BPU0lYX0FDTD15CkNPTkZJR19FWFQzX0ZTX1NFQ1VSSVRZPXkK
IyBDT05GSUdfRVhUNERFVl9GUyBpcyBub3Qgc2V0CkNPTkZJR19KQkQ9eQojIENPTkZJR19KQkRf
REVCVUcgaXMgbm90IHNldApDT05GSUdfRlNfTUJDQUNIRT15CkNPTkZJR19SRUlTRVJGU19GUz1t
CiMgQ09ORklHX1JFSVNFUkZTX0NIRUNLIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVJU0VSRlNfUFJP
Q19JTkZPIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVJU0VSRlNfRlNfWEFUVFIgaXMgbm90IHNldApD
T05GSUdfSkZTX0ZTPW0KIyBDT05GSUdfSkZTX1BPU0lYX0FDTCBpcyBub3Qgc2V0CiMgQ09ORklH
X0pGU19TRUNVUklUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0pGU19ERUJVRyBpcyBub3Qgc2V0CkNP
TkZJR19KRlNfU1RBVElTVElDUz15CkNPTkZJR19GU19QT1NJWF9BQ0w9eQpDT05GSUdfWEZTX0ZT
PW0KIyBDT05GSUdfWEZTX1FVT1RBIGlzIG5vdCBzZXQKIyBDT05GSUdfWEZTX1BPU0lYX0FDTCBp
cyBub3Qgc2V0CiMgQ09ORklHX1hGU19SVCBpcyBub3Qgc2V0CiMgQ09ORklHX1hGU19ERUJVRyBp
cyBub3Qgc2V0CiMgQ09ORklHX0dGUzJfRlMgaXMgbm90IHNldApDT05GSUdfT0NGUzJfRlM9bQpD
T05GSUdfT0NGUzJfRlNfTzJDQj1tCkNPTkZJR19PQ0ZTMl9GU19TVEFUUz15CkNPTkZJR19PQ0ZT
Ml9ERUJVR19NQVNLTE9HPXkKIyBDT05GSUdfT0NGUzJfREVCVUdfRlMgaXMgbm90IHNldApDT05G
SUdfRE5PVElGWT15CkNPTkZJR19JTk9USUZZPXkKQ09ORklHX0lOT1RJRllfVVNFUj15CiMgQ09O
RklHX1FVT1RBIGlzIG5vdCBzZXQKIyBDT05GSUdfQVVUT0ZTX0ZTIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVVUT0ZTNF9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZVU0VfRlMgaXMgbm90IHNldAoKIwoj
IENELVJPTS9EVkQgRmlsZXN5c3RlbXMKIwpDT05GSUdfSVNPOTY2MF9GUz15CkNPTkZJR19KT0xJ
RVQ9eQpDT05GSUdfWklTT0ZTPXkKQ09ORklHX1VERl9GUz1tCkNPTkZJR19VREZfTkxTPXkKCiMK
IyBET1MvRkFUL05UIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0ZBVF9GUz15CkNPTkZJR19NU0RPU19G
Uz15CkNPTkZJR19WRkFUX0ZTPXkKQ09ORklHX0ZBVF9ERUZBVUxUX0NPREVQQUdFPTQzNwpDT05G
SUdfRkFUX0RFRkFVTFRfSU9DSEFSU0VUPSJhc2NpaSIKQ09ORklHX05URlNfRlM9bQojIENPTkZJ
R19OVEZTX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTlRGU19SVyBpcyBub3Qgc2V0CgojCiMg
UHNldWRvIGZpbGVzeXN0ZW1zCiMKQ09ORklHX1BST0NfRlM9eQpDT05GSUdfUFJPQ19LQ09SRT15
CkNPTkZJR19QUk9DX1ZNQ09SRT15CkNPTkZJR19QUk9DX1NZU0NUTD15CkNPTkZJR19TWVNGUz15
CkNPTkZJR19UTVBGUz15CiMgQ09ORklHX1RNUEZTX1BPU0lYX0FDTCBpcyBub3Qgc2V0CkNPTkZJ
R19IVUdFVExCRlM9eQpDT05GSUdfSFVHRVRMQl9QQUdFPXkKQ09ORklHX0NPTkZJR0ZTX0ZTPXkK
CiMKIyBNaXNjZWxsYW5lb3VzIGZpbGVzeXN0ZW1zCiMKIyBDT05GSUdfQURGU19GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0FGRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19IRlNfRlMgaXMgbm90IHNl
dAojIENPTkZJR19IRlNQTFVTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQkVGU19GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0JGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0VGU19GUyBpcyBub3Qgc2V0
CkNPTkZJR19DUkFNRlM9bQojIENPTkZJR19WWEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlO
SVhfRlMgaXMgbm90IHNldAojIENPTkZJR19PTUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSFBG
U19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FOWDRGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JP
TUZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX1NZU1ZfRlM9bQpDT05GSUdfVUZTX0ZTPW0KIyBDT05G
SUdfVUZTX0ZTX1dSSVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfVUZTX0RFQlVHIGlzIG5vdCBzZXQK
Q09ORklHX05FVFdPUktfRklMRVNZU1RFTVM9eQpDT05GSUdfTkZTX0ZTPXkKQ09ORklHX05GU19W
Mz15CkNPTkZJR19ORlNfVjNfQUNMPXkKIyBDT05GSUdfTkZTX1Y0IGlzIG5vdCBzZXQKQ09ORklH
X05GU0Q9eQpDT05GSUdfTkZTRF9WMl9BQ0w9eQpDT05GSUdfTkZTRF9WMz15CkNPTkZJR19ORlNE
X1YzX0FDTD15CiMgQ09ORklHX05GU0RfVjQgaXMgbm90IHNldApDT05GSUdfTE9DS0Q9eQpDT05G
SUdfTE9DS0RfVjQ9eQpDT05GSUdfRVhQT1JURlM9eQpDT05GSUdfTkZTX0FDTF9TVVBQT1JUPXkK
Q09ORklHX05GU19DT01NT049eQpDT05GSUdfU1VOUlBDPXkKQ09ORklHX1NVTlJQQ19HU1M9eQpD
T05GSUdfUlBDU0VDX0dTU19LUkI1PXkKQ09ORklHX1JQQ1NFQ19HU1NfU1BLTTM9eQojIENPTkZJ
R19TTUJfRlMgaXMgbm90IHNldAojIENPTkZJR19DSUZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTkNQ
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09EQV9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FGU19G
UyBpcyBub3Qgc2V0CgojCiMgUGFydGl0aW9uIFR5cGVzCiMKQ09ORklHX1BBUlRJVElPTl9BRFZB
TkNFRD15CiMgQ09ORklHX0FDT1JOX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX09TRl9Q
QVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19BTUlHQV9QQVJUSVRJT04gaXMgbm90IHNldAoj
IENPTkZJR19BVEFSSV9QQVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19NQUNfUEFSVElUSU9O
IGlzIG5vdCBzZXQKQ09ORklHX01TRE9TX1BBUlRJVElPTj15CiMgQ09ORklHX0JTRF9ESVNLTEFC
RUwgaXMgbm90IHNldAojIENPTkZJR19NSU5JWF9TVUJQQVJUSVRJT04gaXMgbm90IHNldAojIENP
TkZJR19TT0xBUklTX1g4Nl9QQVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19VTklYV0FSRV9E
SVNLTEFCRUwgaXMgbm90IHNldAojIENPTkZJR19MRE1fUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0dJX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VMVFJJWF9QQVJUSVRJT04g
aXMgbm90IHNldAojIENPTkZJR19TVU5fUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfS0FS
TUFfUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklHX0VGSV9QQVJUSVRJT049eQojIENPTkZJR19T
WVNWNjhfUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklHX05MUz15CkNPTkZJR19OTFNfREVGQVVM
VD0idXRmOCIKQ09ORklHX05MU19DT0RFUEFHRV80Mzc9eQojIENPTkZJR19OTFNfQ09ERVBBR0Vf
NzM3IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzc3NSBpcyBub3Qgc2V0CkNPTkZJ
R19OTFNfQ09ERVBBR0VfODUwPXkKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1MiBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBB
R0VfODU3IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MCBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV84NjEgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
ODYyIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MyBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV84NjQgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY1
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NiBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV84NjkgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTM2IGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzk1MCBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19DT0RFUEFHRV85MzIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTQ5IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg3NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19J
U084ODU5XzggaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfMTI1MCBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV8xMjUxIGlzIG5vdCBzZXQKQ09ORklHX05MU19BU0NJST15
CkNPTkZJR19OTFNfSVNPODg1OV8xPXkKIyBDT05GSUdfTkxTX0lTTzg4NTlfMiBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19JU084ODU5XzMgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV80
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfNSBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19JU084ODU5XzYgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV83IGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0lTTzg4NTlfOSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzEz
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTQgaXMgbm90IHNldApDT05GSUdfTkxT
X0lTTzg4NTlfMTU9eQojIENPTkZJR19OTFNfS09JOF9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0tPSThfVSBpcyBub3Qgc2V0CkNPTkZJR19OTFNfVVRGOD15CiMgQ09ORklHX0RMTSBpcyBub3Qg
c2V0CgojCiMgS2VybmVsIGhhY2tpbmcKIwpDT05GSUdfVFJBQ0VfSVJRRkxBR1NfU1VQUE9SVD15
CiMgQ09ORklHX1BSSU5US19USU1FIGlzIG5vdCBzZXQKQ09ORklHX0VOQUJMRV9XQVJOX0RFUFJF
Q0FURUQ9eQpDT05GSUdfRU5BQkxFX01VU1RfQ0hFQ0s9eQpDT05GSUdfRlJBTUVfV0FSTj0yMDQ4
CkNPTkZJR19NQUdJQ19TWVNSUT15CiMgQ09ORklHX1VOVVNFRF9TWU1CT0xTIGlzIG5vdCBzZXQK
Q09ORklHX0RFQlVHX0ZTPXkKIyBDT05GSUdfSEVBREVSU19DSEVDSyBpcyBub3Qgc2V0CkNPTkZJ
R19ERUJVR19LRVJORUw9eQojIENPTkZJR19ERUJVR19TSElSUSBpcyBub3Qgc2V0CkNPTkZJR19E
RVRFQ1RfU09GVExPQ0tVUD15CiMgQ09ORklHX0JPT1RQQVJBTV9TT0ZUTE9DS1VQX1BBTklDIGlz
IG5vdCBzZXQKQ09ORklHX0JPT1RQQVJBTV9TT0ZUTE9DS1VQX1BBTklDX1ZBTFVFPTAKIyBDT05G
SUdfU0NIRURfREVCVUcgaXMgbm90IHNldApDT05GSUdfU0NIRURTVEFUUz15CkNPTkZJR19USU1F
Ul9TVEFUUz15CiMgQ09ORklHX0RFQlVHX09CSkVDVFMgaXMgbm90IHNldAojIENPTkZJR19TTFVC
X0RFQlVHX09OIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xVQl9TVEFUUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0RFQlVHX1JUX01VVEVYRVMgaXMgbm90IHNldAojIENPTkZJR19SVF9NVVRFWF9URVNURVIg
aXMgbm90IHNldAojIENPTkZJR19ERUJVR19TUElOTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19ERUJV
R19NVVRFWEVTPXkKIyBDT05GSUdfREVCVUdfTE9DS19BTExPQyBpcyBub3Qgc2V0CiMgQ09ORklH
X1BST1ZFX0xPQ0tJTkcgaXMgbm90IHNldAojIENPTkZJR19MT0NLX1NUQVQgaXMgbm90IHNldApD
T05GSUdfREVCVUdfU1BJTkxPQ0tfU0xFRVA9eQojIENPTkZJR19ERUJVR19MT0NLSU5HX0FQSV9T
RUxGVEVTVFMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19LT0JKRUNUIGlzIG5vdCBzZXQKQ09O
RklHX0RFQlVHX0JVR1ZFUkJPU0U9eQpDT05GSUdfREVCVUdfSU5GTz15CiMgQ09ORklHX0RFQlVH
X1ZNIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfV1JJVEVDT1VOVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0RFQlVHX01FTU9SWV9JTklUIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX0xJU1Q9eQojIENP
TkZJR19ERUJVR19TRyBpcyBub3Qgc2V0CkNPTkZJR19GUkFNRV9QT0lOVEVSPXkKIyBDT05GSUdf
Qk9PVF9QUklOVEtfREVMQVkgaXMgbm90IHNldAojIENPTkZJR19SQ1VfVE9SVFVSRV9URVNUIGlz
IG5vdCBzZXQKIyBDT05GSUdfS1BST0JFU19TQU5JVFlfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklH
X0JBQ0tUUkFDRV9TRUxGX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19MS0RUTSBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZBVUxUX0lOSkVDVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0xBVEVOQ1lUT1Ag
aXMgbm90IHNldAojIENPTkZJR19TWVNDVExfU1lTQ0FMTF9DSEVDSyBpcyBub3Qgc2V0CkNPTkZJ
R19IQVZFX0ZUUkFDRT15CkNPTkZJR19IQVZFX0RZTkFNSUNfRlRSQUNFPXkKIyBDT05GSUdfRlRS
QUNFIGlzIG5vdCBzZXQKIyBDT05GSUdfSVJRU09GRl9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJ
R19TWVNQUk9GX1RSQUNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NDSEVEX1RSQUNFUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0NPTlRFWFRfU1dJVENIX1RSQUNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BS
T1ZJREVfT0hDSTEzOTRfRE1BX0lOSVQgaXMgbm90IHNldAojIENPTkZJR19TQU1QTEVTIGlzIG5v
dCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LR0RCPXkKIyBDT05GSUdfS0dEQiBpcyBub3Qgc2V0CiMg
Q09ORklHX1NUUklDVF9ERVZNRU0gaXMgbm90IHNldApDT05GSUdfWDg2X1ZFUkJPU0VfQk9PVFVQ
PXkKQ09ORklHX0VBUkxZX1BSSU5USz15CkNPTkZJR19ERUJVR19TVEFDS09WRVJGTE9XPXkKQ09O
RklHX0RFQlVHX1NUQUNLX1VTQUdFPXkKIyBDT05GSUdfREVCVUdfUEFHRUFMTE9DIGlzIG5vdCBz
ZXQKIyBDT05GSUdfREVCVUdfUEVSX0NQVV9NQVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1BU
RFVNUCBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19ST0RBVEE9eQojIENPTkZJR19ESVJFQ1RfR0JQ
QUdFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1JPREFUQV9URVNUIGlzIG5vdCBzZXQKIyBD
T05GSUdfREVCVUdfTlhfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lPTU1VX0RFQlVHIGlzIG5v
dCBzZXQKIyBDT05GSUdfTU1JT1RSQUNFIGlzIG5vdCBzZXQKQ09ORklHX0lPX0RFTEFZX1RZUEVf
MFg4MD0wCkNPTkZJR19JT19ERUxBWV9UWVBFXzBYRUQ9MQpDT05GSUdfSU9fREVMQVlfVFlQRV9V
REVMQVk9MgpDT05GSUdfSU9fREVMQVlfVFlQRV9OT05FPTMKQ09ORklHX0lPX0RFTEFZXzBYODA9
eQojIENPTkZJR19JT19ERUxBWV8wWEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9fREVMQVlfVURF
TEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9fREVMQVlfTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19E
RUZBVUxUX0lPX0RFTEFZX1RZUEU9MAojIENPTkZJR19ERUJVR19CT09UX1BBUkFNUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NQQV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX09QVElNSVpFX0lOTElO
SU5HIGlzIG5vdCBzZXQKCiMKIyBTZWN1cml0eSBvcHRpb25zCiMKIyBDT05GSUdfS0VZUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFlfRklM
RV9DQVBBQklMSVRJRVMgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPPXkKCiMKIyBDcnlwdG8gY29y
ZSBvciBoZWxwZXIKIwpDT05GSUdfQ1JZUFRPX0FMR0FQST15CkNPTkZJR19DUllQVE9fQUVBRD15
CkNPTkZJR19DUllQVE9fQkxLQ0lQSEVSPXkKQ09ORklHX0NSWVBUT19IQVNIPXkKQ09ORklHX0NS
WVBUT19NQU5BR0VSPXkKIyBDT05GSUdfQ1JZUFRPX0dGMTI4TVVMIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX05VTEwgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQ1JZUFREIGlzIG5vdCBz
ZXQKQ09ORklHX0NSWVBUT19BVVRIRU5DPXkKIyBDT05GSUdfQ1JZUFRPX1RFU1QgaXMgbm90IHNl
dAoKIwojIEF1dGhlbnRpY2F0ZWQgRW5jcnlwdGlvbiB3aXRoIEFzc29jaWF0ZWQgRGF0YQojCiMg
Q09ORklHX0NSWVBUT19DQ00gaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fR0NNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1JZUFRPX1NFUUlWIGlzIG5vdCBzZXQKCiMKIyBCbG9jayBtb2RlcwojCkNP
TkZJR19DUllQVE9fQ0JDPXkKIyBDT05GSUdfQ1JZUFRPX0NUUiBpcyBub3Qgc2V0CiMgQ09ORklH
X0NSWVBUT19DVFMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fRUNCIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX0xSVyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19QQ0JDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1JZUFRPX1hUUyBpcyBub3Qgc2V0CgojCiMgSGFzaCBtb2RlcwojCkNPTkZJ
R19DUllQVE9fSE1BQz15CiMgQ09ORklHX0NSWVBUT19YQ0JDIGlzIG5vdCBzZXQKCiMKIyBEaWdl
c3QKIwpDT05GSUdfQ1JZUFRPX0NSQzMyQz15CiMgQ09ORklHX0NSWVBUT19NRDQgaXMgbm90IHNl
dApDT05GSUdfQ1JZUFRPX01ENT15CiMgQ09ORklHX0NSWVBUT19NSUNIQUVMX01JQyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19STUQxMjggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fUk1E
MTYwIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1JNRDI1NiBpcyBub3Qgc2V0CiMgQ09ORklH
X0NSWVBUT19STUQzMjAgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX1NIQTE9eQojIENPTkZJR19D
UllQVE9fU0hBMjU2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NIQTUxMiBpcyBub3Qgc2V0
CiMgQ09ORklHX0NSWVBUT19UR1IxOTIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fV1A1MTIg
aXMgbm90IHNldAoKIwojIENpcGhlcnMKIwojIENPTkZJR19DUllQVE9fQUVTIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1JZUFRPX0FFU19YODZfNjQgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQU5V
QklTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0FSQzQgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fQkxPV0ZJU0ggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQ0FNRUxMSUEgaXMgbm90
IHNldApDT05GSUdfQ1JZUFRPX0NBU1Q1PXkKIyBDT05GSUdfQ1JZUFRPX0NBU1Q2IGlzIG5vdCBz
ZXQKQ09ORklHX0NSWVBUT19ERVM9eQojIENPTkZJR19DUllQVE9fRkNSWVBUIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1JZUFRPX0tIQVpBRCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TQUxTQTIw
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NBTFNBMjBfWDg2XzY0IGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX1NFRUQgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0VSUEVOVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19URUEgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fVFdP
RklTSCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19UV09GSVNIX1g4Nl82NCBpcyBub3Qgc2V0
CgojCiMgQ29tcHJlc3Npb24KIwpDT05GSUdfQ1JZUFRPX0RFRkxBVEU9eQojIENPTkZJR19DUllQ
VE9fTFpPIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19IVz15CiMgQ09ORklHX0NSWVBUT19ERVZf
SElGTl83OTVYIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfS1ZNPXkKIyBDT05GSUdfVklSVFVBTEla
QVRJT04gaXMgbm90IHNldAoKIwojIExpYnJhcnkgcm91dGluZXMKIwpDT05GSUdfQklUUkVWRVJT
RT15CkNPTkZJR19HRU5FUklDX0ZJTkRfRklSU1RfQklUPXkKQ09ORklHX0dFTkVSSUNfRklORF9O
RVhUX0JJVD15CkNPTkZJR19DUkNfQ0NJVFQ9eQpDT05GSUdfQ1JDMTY9eQpDT05GSUdfQ1JDX1Qx
MERJRj15CkNPTkZJR19DUkNfSVRVX1Q9eQpDT05GSUdfQ1JDMzI9eQpDT05GSUdfQ1JDNz15CkNP
TkZJR19MSUJDUkMzMkM9eQpDT05GSUdfWkxJQl9JTkZMQVRFPXkKQ09ORklHX1pMSUJfREVGTEFU
RT15CkNPTkZJR19QTElTVD15CkNPTkZJR19IQVNfSU9NRU09eQpDT05GSUdfSEFTX0lPUE9SVD15
CkNPTkZJR19IQVNfRE1BPXkK

--Multipart=_Thu__21_Aug_2008_08_43_33_-0700_nZXE3aArB87C=Un5--
