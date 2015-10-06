From: Benjamin Rood <brood@attotech.com>
Subject: Infinite loop upon rmmod pm80xx with 1 drive attached
Date: Tue, 6 Oct 2015 16:37:23 -0400
Message-ID: <56143103.7010907@attotech.com>
Reply-To: brood@attotech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:16130 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753188AbbJFUwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2015 16:52:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I'm currently working to patch the pm80xx driver to function with a new=
=20
PMC-based chip and have run into the following issue while attempting t=
o=20
remove the driver with a single drive attached. What happens is the=20
kernel will enter an infinite loop repeatedly calling=20
sas_scsi_recover_host() and thus lead to an unusable system.  The error=
=20
does not occur if a drive is not attached.  I'm assuming that it's a=20
stuck command somewhere, but seeing as I'm relatively new to kernel=20
development I'm having a hard time tracking down the issue.

I have enabled all debug message from the pm80xx driver, which you can=20
see in the following snippet of dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.3.0-rc1+ (root@bgrove-test2.attotech.com=
)=20
(gcc version 4.8.1 20130603 (Red Hat 4.8.1-1) (GCC) ) #2 SMP Mon Oct 5=20
17:32:23 EDT 2015
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-4.3.0-rc1+=20
root=3D/dev/mapper/fedora_win--7lgoa5s28j0-root ro rd.md=3D0 rd.dm=3D0=20
rd.lvm.lv=3Dfedora_win-7lgoa5s28j0/swap rd.luks=3D0 vconsole.keymap=3Du=
s=20
rd.lvm.lv=3Dfedora_win-7lgoa5s28j0/root console=3DttyS0,115200 console=3D=
ttyS0=20
quiet LANG=3Den_US.UTF-8
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'lazy' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] u=
sable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dffc2e3f] u=
sable
[    0.000000] BIOS-e820: [mem 0x00000000dffc2e40-0x00000000efffffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff]=20
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] u=
sable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Hewlett-Packard HP xw6400 Workstation/0A04h, BIOS=20
786D4 v02.24 07/06/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> =
reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB WC  UC-=
 WT
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable =3D=3D> =
reserved
[    0.000000] e820: last_pfn =3D 0xdffc2 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fffc0-0x000fffcf] mapped=
=20
at [ffff8800000fffc0]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size =
24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0201e000, 0x0201efff] PGTABLE
[    0.000000] BRK [0x0201f000, 0x0201ffff] PGTABLE
[    0.000000] BRK [0x02020000, 0x02020fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02021000, 0x02021fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11fdfffff]
[    0.000000]  [mem 0x100000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdffc1fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdffc1fff] page 4k
[    0.000000] RAMDISK: [mem 0x365d8000-0x372e3fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000E9E10 000024 (v02 COMPAQ)
[    0.000000] ACPI: XSDT 0x00000000DFFC58EC 000064 (v01 HPQOEM SLIC-WK=
S=20
20070706      00000000)
[    0.000000] ACPI: FACP 0x00000000DFFC5A94 0000F4 (v03 COMPAQ GREENCR=
K=20
00000001      00000000)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in=20
=46ADT/Pm1aEventBlock: 32/16 (20150818/tbfadt-623)
[    0.000000] ACPI BIOS Warning (bug): 32/64X address mismatch in=20
=46ADT/Gpe0Block: 0x0000F828/0x000000000001F030, using 64-bit address=20
(20150818/tbfadt-588)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in=20
=46ADT/Gpe0Block: 64/32 (20150818/tbfadt-623)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for=20
=46ADT/Pm1aEventBlock: 16, using default 32 (20150818/tbfadt-704)
[    0.000000] ACPI: DSDT 0x00000000DFFC5ECA 002171 (v01 COMPAQ DSDT   =
 =20
00000001 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x00000000DFFC5800 000040
[    0.000000] ACPI: FACS 0x00000000DFFC5800 000040
[    0.000000] ACPI: SSDT 0x00000000DFFC803B 007655 (v01 COMPAQ PROJECT=
 =20
00000001 MSFT 0100000E)
[    0.000000] ACPI: APIC 0x00000000DFFC5B88 0000BC (v01 COMPAQ GREENCR=
K=20
00000001      00000000)
[    0.000000] ACPI: ASF! 0x00000000DFFC5C44 00006A (v32 COMPAQ GREENCR=
K=20
00000001      00000000)
[    0.000000] ACPI: MCFG 0x00000000DFFC5CAE 00003C (v01 COMPAQ GREENCR=
K=20
00000001      00000000)
[    0.000000] ACPI: TCPA 0x00000000DFFC5E98 000032 (v01 COMPAQ GREENCR=
K=20
00000001      00000000)
[    0.000000] ACPI: SLIC 0x00000000DFFC5CEA 000176 (v01 HPQOEM SLIC-WK=
S=20
00000001      00000000)
[    0.000000] ACPI: HPET 0x00000000DFFC5E60 000038 (v01 COMPAQ GREENCR=
K=20
00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011ffff=
fff]
[    0.000000] NODE_DATA(0) allocated [mem 0x11ffe8000-0x11fffbfff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD ->=20
[ffff88011b600000-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000011fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000dffc1fff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem=20
0x0000000000001000-0x000000011fffffff]
[    0.000000] On node 0 totalpages: 1048416
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913346 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GS=
I=20
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high lev=
el)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff=
]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e7fff=
]
[    0.000000] PM: Registered nosave memory: [mem 0x000e8000-0x000fffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xdffc2000-0xdffc2fff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xdffc3000-0xefffffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xffffffff=
]
[    0.000000] e820: [mem 0xf0000000-0xfebfffff] available for PCI devi=
ces
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff=20
max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128=20
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff88011fc00000 s96792=20
r8192 d30184 u262144
[    0.000000] pcpu-alloc: s96792 r8192 d30184 u262144 alloc=3D1*209715=
2
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Node order, mobility grouping on. =20
Total pages: 1032011
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-4.3.0-rc1+=20
root=3D/dev/mapper/fedora_win--7lgoa5s28j0-root ro rd.md=3D0 rd.dm=3D0=20
rd.lvm.lv=3Dfedora_win-7lgoa5s28j0/swap rd.luks=3D0 vconsole.keymap=3Du=
s=20
rd.lvm.lv=3Dfedora_win-7lgoa5s28j0/root console=3DttyS0,115200 console=3D=
ttyS0=20
quiet LANG=3Den_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 4030888K/4193664K available (7162K kernel code,=20
1216K rwdata, 3192K rodata, 1520K init, 1436K bss, 162776K reserved, 0K=
=20
cma-reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D=
8, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]     Build-time adjustment of leaf fanout to 64.
[    0.000000]     RCU restricting CPUs from NR_CPUS=3D128 to nr_cpu_id=
s=3D8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D64, nr_cpu=
_ids=3D8
[    0.000000] NR_IRQS:8448 nr_irqs:488 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles:=20
0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1995.070 MHz processor
[    0.001015] Calibrating delay loop (skipped), value calculated using=
=20
timer frequency.. 3990.14 BogoMIPS (lpj=3D1995070)
[    0.001019] pid_max: default: 32768 minimum: 301
[    0.001030] ACPI: Core revision 20150818
[    0.006020] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.006060] Security Framework initialized
[    0.006064] SELinux:  Initializing.
[    0.006079] SELinux:  Starting in permissive mode
[    0.006615] Dentry cache hash table entries: 524288 (order: 10,=20
4194304 bytes)
[    0.009019] Inode-cache hash table entries: 262144 (order: 9, 209715=
2=20
bytes)
[    0.010241] Mount-cache hash table entries: 8192 (order: 4, 65536 by=
tes)
[    0.010252] Mountpoint-cache hash table entries: 8192 (order: 4,=20
65536 bytes)
[    0.010673] Initializing cgroup subsys io
[    0.010683] Initializing cgroup subsys memory
[    0.010698] Initializing cgroup subsys devices
[    0.010702] Initializing cgroup subsys freezer
[    0.010707] Initializing cgroup subsys net_cls
[    0.010711] Initializing cgroup subsys perf_event
[    0.010742] CPU: Physical Processor ID: 0
[    0.010744] CPU: Processor Core ID: 0
[    0.010746] mce: CPU supports 6 MCE banks
[    0.010756] CPU0: Thermal monitoring enabled (TM2)
[    0.010760] process: using mwait in idle threads
[    0.010765] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.010767] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.010932] Freeing SMP alternatives memory: 28K (ffffffff81eae000 -=
=20
ffffffff81eb5000)
[    0.013008] ftrace: allocating 27746 entries in 109 pages
[    0.022520] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
[    0.033000] smpboot: CPU0: Intel(R) Xeon(R) CPU E5335  @ 2.00GHz=20
(fam: 06, model: 0f, stepping: 07)
[    0.033000] Performance Events: PEBS fmt0-, 4-deep LBR, Core2 events=
,=20
Intel PMU driver.
[    0.033000] perf_event_intel: PEBS disabled due to CPU errata
[    0.033000] ... version:                2
[    0.033000] ... bit width:              40
[    0.033000] ... generic registers:      2
[    0.033000] ... value mask:             000000ffffffffff
[    0.033000] ... max period:             000000007fffffff
[    0.033000] ... fixed-purpose events:   3
[    0.033000] ... event mask:             0000000700000003
[    0.033272] x86: Booting SMP configuration:
[    0.033275] .... node  #0, CPUs:      #1 #2
[   10.034004] smpboot: do_boot_cpu failed(-1) to wakeup CPU#2
[   10.035199] NMI watchdog: enabled on all CPUs, permanently consumes=20
one hw-PMU counter.
[   10.035338]  #3
[   20.035004] smpboot: do_boot_cpu failed(-1) to wakeup CPU#3
[   20.036008] x86: Booted up 1 node, 2 CPUs
[   20.036011] smpboot: Total of 2 processors activated (7980.28 BogoMI=
PS)
[   20.038141] devtmpfs: initialized
[   20.038322] clocksource: jiffies: mask: 0xffffffff max_cycles:=20
0xffffffff, max_idle_ns: 1911260446275000 ns
[   20.038322] atomic64_test: passed for x86-64 platform with CX8 and=20
with SSE
[   20.038322] RTC time: 19:29:31, date: 10/06/15
[   20.039032] NET: Registered protocol family 16
[   20.051004] cpuidle: using governor ladder
[   20.063004] cpuidle: using governor menu
[   20.063103] ACPI: bus type PCI registered
[   20.063106] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.=
5
[   20.063205] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem=20
0xe0000000-0xe7ffffff] (base 0xe0000000)
[   20.063208] PCI: MMCONFIG at [mem 0xe0000000-0xe7ffffff] reserved in=
 E820
[   20.063223] PCI: Using configuration type 1 for base access
[   20.063459] mtrr: your CPUs had inconsistent variable MTRR settings
[   20.063460] mtrr: probably your BIOS does not setup all CPUs.
[   20.063462] mtrr: corrected configuration.
[   20.075069] ACPI: Added _OSI(Module Device)
[   20.075069] ACPI: Added _OSI(Processor Device)
[   20.075069] ACPI: Added _OSI(3.0 _SCP Extensions)
[   20.075070] ACPI: Added _OSI(Processor Aggregator Device)
[   20.076409] ACPI Error: Illegal I/O port address/length above 64K:=20
000000000001F034/0x1 (20150818/hwvalid-155)
[   20.076415] ACPI Exception: AE_LIMIT, Could not create GPE Block 0=20
(20150818/evgpeinit-143)
[   20.079238] ACPI: Interpreter enabled
[   20.079251] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep=20
State [\_S2_] (20150818/hwxface-580)
[   20.079268] ACPI: (supports S0 S1 S3 S4 S5)
[   20.079270] ACPI: Using IOAPIC for interrupt routing
[   20.079300] PCI: Using host bridge windows from ACPI; if necessary,=20
use "pci=3Dnocrs" and report a bug
[   20.084795] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   20.084803] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM=20
ClockPM Segments MSI]
[   20.084809] ACPI BIOS Error (bug): \_SB_.PCI0._OSC: Excess arguments=
=20
- ASL declared 5, ACPI requires 4 (20150818/nsarguments-189)
[   20.084869] ACPI Error: [CAPD] Namespace lookup failure,=20
AE_ALREADY_EXISTS (20150818/dsfield-211)
[   20.084875] ACPI Error: Method parse/execution failed=20
[\_SB.PCI0._OSC] (Node ffff88011b0a52a8), AE_ALREADY_EXISTS=20
(20150818/psparse-542)
[   20.084888] acpi PNP0A08:00: _OSC failed (AE_ALREADY_EXISTS);=20
disabling ASPM
[   20.084989] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain=20
0000 [bus 00-7f] only partially covers this bridge
[   20.085190] PCI host bridge to bus 0000:00
[   20.085195] pci_bus 0000:00: root bus resource [bus 00-ff]
[   20.085198] pci_bus 0000:00: root bus resource [mem=20
0x000a0000-0x000bffff window]
[   20.085201] pci_bus 0000:00: root bus resource [mem=20
0xf0000000-0xfebfffff window]
[   20.085204] pci_bus 0000:00: root bus resource [mem=20
0xfed00000-0xfed003ff window]
[   20.085207] pci_bus 0000:00: root bus resource [mem=20
0xfed40000-0xfed44fff window]
[   20.085209] pci_bus 0000:00: root bus resource [io 0x0000-0x0cf7 win=
dow]
[   20.085212] pci_bus 0000:00: root bus resource [io 0x0d00-0xffff win=
dow]
[   20.085226] pci 0000:00:00.0: [8086:25c0] type 00 class 0x060000
[   20.085277] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[   20.085384] pci 0000:00:02.0: [8086:25e2] type 01 class 0x060400
[   20.085428] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[   20.085481] pci 0000:00:02.0: System wakeup disabled by ACPI
[   20.085542] pci 0000:00:03.0: [8086:25e3] type 01 class 0x060400
[   20.085586] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[   20.085641] pci 0000:00:03.0: System wakeup disabled by ACPI
[   20.085703] pci 0000:00:04.0: [8086:25fa] type 01 class 0x060400
[   20.085747] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[   20.085798] pci 0000:00:04.0: System wakeup disabled by ACPI
[   20.085859] pci 0000:00:05.0: [8086:25e5] type 01 class 0x060400
[   20.085902] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[   20.086010] pci 0000:00:06.0: [8086:25e6] type 01 class 0x060400
[   20.086053] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[   20.086163] pci 0000:00:07.0: [8086:25e7] type 01 class 0x060400
[   20.086206] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[   20.086310] pci 0000:00:10.0: [8086:25f0] type 00 class 0x060000
[   20.086421] pci 0000:00:10.1: [8086:25f0] type 00 class 0x060000
[   20.086913] pci 0000:00:10.2: [8086:25f0] type 00 class 0x060000
[   20.087034] pci 0000:00:11.0: [8086:25f1] type 00 class 0x060000
[   20.087146] pci 0000:00:13.0: [8086:25f3] type 00 class 0x060000
[   20.087258] pci 0000:00:15.0: [8086:25f5] type 00 class 0x060000
[   20.087369] pci 0000:00:16.0: [8086:25f6] type 00 class 0x060000
[   20.087493] pci 0000:00:1b.0: [8086:269a] type 00 class 0x040300
[   20.087522] pci 0000:00:1b.0: reg 0x10: [mem 0xfc600000-0xfc603fff 6=
4bit]
[   20.087583] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[   20.087690] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[   20.087760] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[   20.087816] pci 0000:00:1c.0: System wakeup disabled by ACPI
[   20.087883] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[   20.087927] pci 0000:00:1d.0: reg 0x20: [io  0x2000-0x201f]
[   20.087998] pci 0000:00:1d.0: System wakeup disabled by ACPI
[   20.088064] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[   20.088108] pci 0000:00:1d.1: reg 0x20: [io  0x2020-0x203f]
[   20.088178] pci 0000:00:1d.1: System wakeup disabled by ACPI
[   20.088237] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[   20.088280] pci 0000:00:1d.2: reg 0x20: [io  0x2040-0x205f]
[   20.088351] pci 0000:00:1d.2: System wakeup disabled by ACPI
[   20.088410] pci 0000:00:1d.3: [8086:268b] type 00 class 0x0c0300
[   20.088454] pci 0000:00:1d.3: reg 0x20: [io  0x2060-0x207f]
[   20.088524] pci 0000:00:1d.3: System wakeup disabled by ACPI
[   20.088593] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[   20.088620] pci 0000:00:1d.7: reg 0x10: [mem 0xfc604000-0xfc6043ff]
[   20.088690] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[   20.088743] pci 0000:00:1d.7: System wakeup disabled by ACPI
[   20.088803] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[   20.088897] pci 0000:00:1e.0: System wakeup disabled by ACPI
[   20.088959] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[   20.089136] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
[   20.089152] pci 0000:00:1f.1: reg 0x10: [io  0x20c0-0x20c7]
[   20.089162] pci 0000:00:1f.1: reg 0x14: [io  0x20e0-0x20e3]
[   20.089172] pci 0000:00:1f.1: reg 0x18: [io  0x20c8-0x20cf]
[   20.089182] pci 0000:00:1f.1: reg 0x1c: [io  0x20e4-0x20e7]
[   20.089192] pci 0000:00:1f.1: reg 0x20: [io  0x20a0-0x20af]
[   20.089212] pci 0000:00:1f.1: legacy IDE quirk: reg 0x10: [io=20
0x01f0-0x01f7]
[   20.089215] pci 0000:00:1f.1: legacy IDE quirk: reg 0x14: [io 0x03f6=
]
[   20.089217] pci 0000:00:1f.1: legacy IDE quirk: reg 0x18: [io=20
0x0170-0x0177]
[   20.089219] pci 0000:00:1f.1: legacy IDE quirk: reg 0x1c: [io 0x0376=
]
[   20.089323] pci 0000:00:1f.2: [8086:2680] type 00 class 0x01018f
[   20.089344] pci 0000:00:1f.2: reg 0x10: [io  0x20d0-0x20d7]
[   20.089353] pci 0000:00:1f.2: reg 0x14: [io  0x20e8-0x20eb]
[   20.089362] pci 0000:00:1f.2: reg 0x18: [io  0x20d8-0x20df]
[   20.089370] pci 0000:00:1f.2: reg 0x1c: [io  0x20ec-0x20ef]
[   20.089379] pci 0000:00:1f.2: reg 0x20: [io  0x20b0-0x20bf]
[   20.089388] pci 0000:00:1f.2: reg 0x24: [mem 0xfc604400-0xfc6047ff]
[   20.089413] pci 0000:00:1f.2: PME# supported from D3hot
[   20.089576] pci 0000:00:02.0: PCI bridge to [bus 10-20]
[   20.089582] pci 0000:00:02.0:   bridge window [mem 0xfc300000-0xfc5f=
ffff]
[   20.089942] pci 0000:10:00.0: [8086:3500] type 01 class 0x060400
[   20.092551] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
[   20.093413] pci 0000:10:00.3: [8086:350c] type 01 class 0x060400
[   20.094689] pci 0000:10:00.3: reg 0x10: [mem 0xfc501000-0xfc501fff 6=
4bit]
[   20.096367] pci 0000:10:00.3: PME# supported from D0 D3hot D3cold
[   20.097137] pci 0000:10:00.0: disabling ASPM on pre-1.1 PCIe device.=
 =20
You can enable it with 'pcie_aspm=3Dforce'
[   20.098368] pci 0000:10:00.0: PCI bridge to [bus 1e-20]
[   20.098551] pci 0000:10:00.0:   bridge window [mem 0xfc300000-0xfc4f=
ffff]
[   20.099092] pci 0000:1e:00.0: [8086:3510] type 01 class 0x060400
[   20.102003] pci 0000:1e:00.0: PME# supported from D0 D3hot D3cold
[   20.102432] pci 0000:1e:00.0: System wakeup disabled by ACPI
[   20.102504] pci 0000:1e:00.0: disabling ASPM on pre-1.1 PCIe device.=
 =20
You can enable it with 'pcie_aspm=3Dforce'
[   20.102872] pci 0000:1e:01.0: [8086:3514] type 01 class 0x060400
[   20.105780] pci 0000:1e:01.0: PME# supported from D0 D3hot D3cold
[   20.106199] pci 0000:1e:01.0: System wakeup disabled by ACPI
[   20.106275] pci 0000:1e:00.0: disabling ASPM on pre-1.1 PCIe device.=
 =20
You can enable it with 'pcie_aspm=3Dforce'
[   20.108781] pci 0000:1e:00.0: PCI bridge to [bus 20]
[   20.108964] pci 0000:1e:00.0:   bridge window [mem 0xfc300000-0xfc3f=
ffff]
[   20.109733] pci 0000:20:00.0: [117c:8070] type 00 class 0x010700
[   20.111138] pci 0000:20:00.0: reg 0x10: [mem 0xfc300000-0xfc30ffff 6=
4bit]
[   20.111643] pci 0000:20:00.0: reg 0x18: [mem 0xfc310000-0xfc31ffff 6=
4bit]
[   20.112597] pci 0000:20:00.0: reg 0x30: [mem 0x00000000-0x000fffff p=
ref]
[   20.113872] pci 0000:20:00.0: supports D1
[   20.113874] pci 0000:20:00.0: PME# supported from D0 D1 D3hot
[   20.114384] pci 0000:20:00.0: System wakeup disabled by ACPI
[   20.116231] pci 0000:1e:01.0: PCI bridge to [bus 1f]
[   20.116413] pci 0000:1e:01.0:   bridge window [mem 0xfc400000-0xfc4f=
ffff]
[   20.117092] pci 0000:1f:00.0: [14e4:1600] type 00 class 0x020000
[   20.118413] pci 0000:1f:00.0: reg 0x10: [mem 0xfc400000-0xfc40ffff 6=
4bit]
[   20.121413] pci 0000:1f:00.0: PME# supported from D3hot D3cold
[   20.121908] pci 0000:1f:00.0: System wakeup disabled by ACPI
[   20.121964] pci 0000:1f:00.0: disabling ASPM on pre-1.1 PCIe device.=
 =20
You can enable it with 'pcie_aspm=3Dforce'
[   20.123991] pci 0000:10:00.3: PCI bridge to [bus 11-1d]
[   20.126246] pci 0000:00:03.0: PCI bridge to [bus 60]
[   20.126252] pci 0000:00:03.0:   bridge window [mem 0xfc000000-0xfc0f=
ffff]
[   20.126270] pci 0000:60:00.0: [117c:0049] type 00 class 0x010400
[   20.126302] pci 0000:60:00.0: reg 0x10: [mem 0xfc040000-0xfc05ffff 6=
4bit]
[   20.126317] pci 0000:60:00.0: reg 0x18: [mem 0xfc000000-0xfc03ffff 6=
4bit]
[   20.126342] pci 0000:60:00.0: reg 0x30: [mem 0x00000000-0x0000ffff p=
ref]
[   20.126376] pci 0000:60:00.0: supports D1
[   20.126379] pci 0000:60:00.0: PME# supported from D0 D1 D3hot
[   20.126427] pci 0000:60:00.0: System wakeup disabled by ACPI
[   20.128075] pci 0000:00:04.0: PCI bridge to [bus 40]
[   20.128128] pci 0000:00:05.0: PCI bridge to [bus fe]
[   20.128175] pci 0000:00:06.0: PCI bridge to [bus fd]
[   20.128226] pci 0000:00:07.0: PCI bridge to [bus fc]
[   20.128308] pci 0000:00:1c.0: PCI bridge to [bus 80]
[   20.128315] pci 0000:00:1c.0:   bridge window [mem 0xfc200000-0xfc2f=
ffff]
[   20.128339] pci 0000:80:00.0: [117c:0042] type 00 class 0x010700
[   20.128382] pci 0000:80:00.0: reg 0x10: [mem 0xfc200000-0xfc20ffff 6=
4bit]
[   20.128401] pci 0000:80:00.0: reg 0x18: [mem 0xfc210000-0xfc21ffff 6=
4bit]
[   20.128414] pci 0000:80:00.0: reg 0x20: [mem 0xfc220000-0xfc22ffff]
[   20.128427] pci 0000:80:00.0: reg 0x24: [mem 0xfc230000-0xfc23ffff]
[   20.128440] pci 0000:80:00.0: reg 0x30: [mem 0x00000000-0x000fffff p=
ref]
[   20.128476] pci 0000:80:00.0: supports D1
[   20.128478] pci 0000:80:00.0: PME# supported from D0
[   20.128507] pci 0000:80:00.0: System wakeup disabled by ACPI
[   20.130101] pci 0000:00:1e.0: PCI bridge to [bus 01] (subtractive de=
code)
[   20.130106] pci 0000:00:1e.0:   bridge window [io 0x1000-0x1fff]
[   20.130110] pci 0000:00:1e.0:   bridge window [mem 0xfc100000-0xfc1f=
ffff]
[   20.130117] pci 0000:00:1e.0:   bridge window [mem=20
0xf8000000-0xfbffffff 64bit pref]
[   20.130120] pci 0000:00:1e.0:   bridge window [mem=20
0x000a0000-0x000bffff window] (subtractive decode)
[   20.130123] pci 0000:00:1e.0:   bridge window [mem=20
0xf0000000-0xfebfffff window] (subtractive decode)
[   20.130126] pci 0000:00:1e.0:   bridge window [mem=20
0xfed00000-0xfed003ff window] (subtractive decode)
[   20.130129] pci 0000:00:1e.0:   bridge window [mem=20
0xfed40000-0xfed44fff window] (subtractive decode)
[   20.130132] pci 0000:00:1e.0:   bridge window [io 0x0000-0x0cf7=20
window] (subtractive decode)
[   20.130135] pci 0000:00:1e.0:   bridge window [io 0x0d00-0xffff=20
window] (subtractive decode)
[   20.130153] pci 0000:01:04.0: [18ca:0020] type 00 class 0x030000
[   20.130176] pci 0000:01:04.0: reg 0x10: [mem 0xf8000000-0xfbffffff p=
ref]
[   20.130187] pci 0000:01:04.0: reg 0x14: [mem 0xfc100000-0xfc13ffff]
[   20.130198] pci 0000:01:04.0: reg 0x18: [io  0x1000-0x107f]
[   20.130233] pci 0000:01:04.0: reg 0x30: [mem 0x00000000-0x00007fff p=
ref]
[   20.130255] pci 0000:01:04.0: supports D1 D2
[   20.130299] pci 0000:01:04.0: System wakeup disabled by ACPI
[   20.131048] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 1=
4 15)
[   20.131121] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 1=
4 15)
[   20.131192] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 1=
4 15)
[   20.131261] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 1=
4 15)
[   20.131331] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14=
=20
15) *0, disabled.
[   20.131401] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 1=
4 15)
[   20.131471] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14=
=20
15) *0, disabled.
[   20.131541] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 1=
4 15)
[   20.131800] vgaarb: setting as boot device: PCI:0000:01:04.0
[   20.131800] vgaarb: device added:=20
PCI:0000:01:04.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
[   20.131800] vgaarb: loaded
[   20.131800] vgaarb: bridge control possible 0000:01:04.0
[   20.131800] SCSI subsystem initialized
[   20.132021] libata version 3.00 loaded.
[   20.132067] ACPI: bus type USB registered
[   20.132098] usbcore: registered new interface driver usbfs
[   20.132112] usbcore: registered new interface driver hub
[   20.132141] usbcore: registered new device driver usb
[   20.132213] PCI: Using ACPI for IRQ routing
[   20.152565] PCI: pci_cache_line_size set to 64 bytes
[   20.153070] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   20.153072] e820: reserve RAM buffer [mem 0xdffc2e40-0xdfffffff]
[   20.153255] NetLabel: Initializing
[   20.153258] NetLabel:  domain hash size =3D 128
[   20.153259] NetLabel:  protocols =3D UNLABELED CIPSOv4
[   20.153283] NetLabel:  unlabeled traffic allowed by default
[   20.153370] HPET: 3 timers in total, 0 timers will be used for=20
per-cpu timer
[   20.153375] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   20.153380] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[   20.155034] clocksource: Switched to clocksource hpet
[   20.167596] pnp: PnP ACPI init
[   20.167728] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (activ=
e)
[   20.167774] pnp 00:01: Plug and Play ACPI device, IDs PNP0f13 PNP0f0=
e=20
(active)
[   20.167822] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (activ=
e)
[   20.167996] pnp 00:03: Plug and Play ACPI device, IDs PNP0401 (disab=
led)
[   20.168287] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 PNP050=
0=20
(active)
[   20.168387] pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (disab=
led)
[   20.168526] system 00:06: [io  0x04d0-0x04d1] has been reserved
[   20.168532] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (ac=
tive)
[   20.168627] system 00:07: [io  0x0400-0x041f] has been reserved
[   20.168630] system 00:07: [io  0x0420-0x043f] has been reserved
[   20.168633] system 00:07: [io  0x0440-0x045f] has been reserved
[   20.168636] system 00:07: [io  0x0460-0x047f] has been reserved
[   20.168639] system 00:07: [io  0x0480-0x048f] has been reserved
[   20.168642] system 00:07: [io  0x0490-0x049f] has been reserved
[   20.168646] system 00:07: [io  0xf800-0xf81f] could not be reserved
[   20.168649] system 00:07: [io  0xf820-0xf83f] has been reserved
[   20.168652] system 00:07: [io  0xf840-0xf85f] has been reserved
[   20.168654] system 00:07: [io  0xf860-0xf87f] has been reserved
[   20.168657] system 00:07: [io  0xfa00-0xfa3f] has been reserved
[   20.168660] system 00:07: [io  0xfc00-0xfc7f] has been reserved
[   20.168663] system 00:07: [io  0xfc80-0xfcff] has been reserved
[   20.168666] system 00:07: [io  0xfe00-0xfe7f] has been reserved
[   20.168669] system 00:07: [io  0xfe80-0xfeff] has been reserved
[   20.168673] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (ac=
tive)
[   20.168738] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reser=
ved
[   20.168741] system 00:08: [mem 0xffe00000-0xffffffff] has been reser=
ved
[   20.168744] system 00:08: [mem 0xfee00000-0xfeefffff] has been reser=
ved
[   20.168747] system 00:08: [mem 0xfe700000-0xfe7003ff] has been reser=
ved
[   20.168754] system 00:08: [mem 0xfe600000-0xfe6fffff] has been reser=
ved
[   20.168757] system 00:08: [mem 0xfe000000-0xfe01ffff] has been reser=
ved
[   20.168761] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (ac=
tive)
[   20.168980] pnp 00:09: disabling [mem 0x00000000-0x0009ffff] because=
=20
it overlaps 0000:20:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[   20.168984] pnp 00:09: disabling [mem 0x000c0000-0x000e7fff] because=
=20
it overlaps 0000:20:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[   20.168988] pnp 00:09: disabling [mem 0x000e8000-0x000effff] because=
=20
it overlaps 0000:20:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[   20.168991] pnp 00:09: disabling [mem 0x000f0000-0x000fffff] because=
=20
it overlaps 0000:20:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[   20.168997] pnp 00:09: disabling [mem 0x00000000-0x0009ffff disabled=
]=20
because it overlaps 0000:80:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[   20.169000] pnp 00:09: disabling [mem 0x000c0000-0x000e7fff disabled=
]=20
because it overlaps 0000:80:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[   20.169012] pnp 00:09: disabling [mem 0x000e8000-0x000effff disabled=
]=20
because it overlaps 0000:80:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[   20.169015] pnp 00:09: disabling [mem 0x000f0000-0x000fffff disabled=
]=20
because it overlaps 0000:80:00.0 BAR 6 [mem 0x00000000-0x000fffff pref]
[   20.169054] system 00:09: [mem 0x00100000-0xdfffffff] could not be=20
reserved
[   20.169057] system 00:09: [mem 0xfeda0000-0xfedbffff] has been reser=
ved
[   20.169062] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (ac=
tive)
[   20.169152] system 00:0a: [mem 0xe0000000-0xefffffff] has been reser=
ved
[   20.169157] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (ac=
tive)
[   20.169170] pnp: PnP ACPI: found 11 devices
[   20.176924] clocksource: acpi_pm: mask: 0xffffff max_cycles:=20
0xffffff, max_idle_ns: 2085701024 ns
[   20.178030] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to=20
[bus 80] add_size 1000
[   20.178034] pci 0000:00:1c.0: bridge window [mem=20
0x00100000-0x000fffff 64bit pref] to [bus 80] add_size 200000 add_align=
=20
100000
[   20.178049] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff=20
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[   20.178052] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x002fffff=20
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[   20.178055] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff]=20
res_to_dev_res add_size 1000 min_align 1000
[   20.178058] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x1fff]=20
res_to_dev_res add_size 1000 min_align 1000
[   20.178068] pci 0000:00:1c.0: BAR 15: assigned [mem=20
0xf0000000-0xf01fffff 64bit pref]
[   20.178072] pci 0000:00:1c.0: BAR 13: assigned [io 0x3000-0x3fff]
[   20.178078] pci 0000:20:00.0: BAR 6: no space for [mem size=20
0x00100000 pref]
[   20.178081] pci 0000:20:00.0: BAR 6: failed to assign [mem size=20
0x00100000 pref]
[   20.178084] pci 0000:1e:00.0: PCI bridge to [bus 20]
[   20.178222] pci 0000:1e:00.0:   bridge window [mem 0xfc300000-0xfc3f=
ffff]
[   20.178497] pci 0000:1e:01.0: PCI bridge to [bus 1f]
[   20.178635] pci 0000:1e:01.0:   bridge window [mem 0xfc400000-0xfc4f=
ffff]
[   20.178910] pci 0000:10:00.0: PCI bridge to [bus 1e-20]
[   20.179048] pci 0000:10:00.0:   bridge window [mem 0xfc300000-0xfc4f=
ffff]
[   20.179324] pci 0000:10:00.3: PCI bridge to [bus 11-1d]
[   20.179737] pci 0000:00:02.0: PCI bridge to [bus 10-20]
[   20.179741] pci 0000:00:02.0:   bridge window [mem 0xfc300000-0xfc5f=
ffff]
[   20.179748] pci 0000:60:00.0: BAR 6: assigned [mem=20
0xfc060000-0xfc06ffff pref]
[   20.179751] pci 0000:00:03.0: PCI bridge to [bus 60]
[   20.179756] pci 0000:00:03.0:   bridge window [mem 0xfc000000-0xfc0f=
ffff]
[   20.179762] pci 0000:00:04.0: PCI bridge to [bus 40]
[   20.179770] pci 0000:00:05.0: PCI bridge to [bus fe]
[   20.179779] pci 0000:00:06.0: PCI bridge to [bus fd]
[   20.179787] pci 0000:00:07.0: PCI bridge to [bus fc]
[   20.179796] pci 0000:80:00.0: BAR 6: assigned [mem=20
0xf0000000-0xf00fffff pref]
[   20.179799] pci 0000:00:1c.0: PCI bridge to [bus 80]
[   20.179802] pci 0000:00:1c.0:   bridge window [io 0x3000-0x3fff]
[   20.179807] pci 0000:00:1c.0:   bridge window [mem 0xfc200000-0xfc2f=
ffff]
[   20.179812] pci 0000:00:1c.0:   bridge window [mem=20
0xf0000000-0xf01fffff 64bit pref]
[   20.179819] pci 0000:01:04.0: BAR 6: assigned [mem=20
0xfc140000-0xfc147fff pref]
[   20.179822] pci 0000:00:1e.0: PCI bridge to [bus 01]
[   20.179826] pci 0000:00:1e.0:   bridge window [io 0x1000-0x1fff]
[   20.179831] pci 0000:00:1e.0:   bridge window [mem 0xfc100000-0xfc1f=
ffff]
[   20.179835] pci 0000:00:1e.0:   bridge window [mem=20
0xf8000000-0xfbffffff 64bit pref]
[   20.179843] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff=20
window]
[   20.179845] pci_bus 0000:00: resource 5 [mem 0xf0000000-0xfebfffff=20
window]
[   20.179848] pci_bus 0000:00: resource 6 [mem 0xfed00000-0xfed003ff=20
window]
[   20.179851] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfed44fff=20
window]
[   20.179854] pci_bus 0000:00: resource 8 [io  0x0000-0x0cf7 window]
[   20.179856] pci_bus 0000:00: resource 9 [io  0x0d00-0xffff window]
[   20.179859] pci_bus 0000:10: resource 1 [mem 0xfc300000-0xfc5fffff]
[   20.179862] pci_bus 0000:1e: resource 1 [mem 0xfc300000-0xfc4fffff]
[   20.179865] pci_bus 0000:20: resource 1 [mem 0xfc300000-0xfc3fffff]
[   20.179868] pci_bus 0000:1f: resource 1 [mem 0xfc400000-0xfc4fffff]
[   20.179871] pci_bus 0000:60: resource 1 [mem 0xfc000000-0xfc0fffff]
[   20.179874] pci_bus 0000:80: resource 0 [io  0x3000-0x3fff]
[   20.179876] pci_bus 0000:80: resource 1 [mem 0xfc200000-0xfc2fffff]
[   20.179879] pci_bus 0000:80: resource 2 [mem 0xf0000000-0xf01fffff=20
64bit pref]
[   20.179882] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[   20.179884] pci_bus 0000:01: resource 1 [mem 0xfc100000-0xfc1fffff]
[   20.179887] pci_bus 0000:01: resource 2 [mem 0xf8000000-0xfbffffff=20
64bit pref]
[   20.179890] pci_bus 0000:01: resource 4 [mem 0x000a0000-0x000bffff=20
window]
[   20.179893] pci_bus 0000:01: resource 5 [mem 0xf0000000-0xfebfffff=20
window]
[   20.179895] pci_bus 0000:01: resource 6 [mem 0xfed00000-0xfed003ff=20
window]
[   20.179898] pci_bus 0000:01: resource 7 [mem 0xfed40000-0xfed44fff=20
window]
[   20.179901] pci_bus 0000:01: resource 8 [io  0x0000-0x0cf7 window]
[   20.179903] pci_bus 0000:01: resource 9 [io  0x0d00-0xffff window]
[   20.179962] NET: Registered protocol family 2
[   20.180238] TCP established hash table entries: 32768 (order: 6,=20
262144 bytes)
[   20.180426] TCP bind hash table entries: 32768 (order: 7, 524288 byt=
es)
[   20.180674] TCP: Hash tables configured (established 32768 bind 3276=
8)
[   20.180742] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[   20.180782] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes=
)
[   20.180900] NET: Registered protocol family 1
[   20.181079] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[   20.181331] pci 0000:01:04.0: Video device with shadowed ROM
[   20.181334] PCI: CLS 64 bytes, default 64
[   20.181423] Unpacking initramfs...
[   20.485355] Freeing initrd memory: 13360K (ffff8800365d8000 -=20
ffff8800372e4000)
[   20.485375] PCI-DMA: Using software bounce buffering for IO (SWIOTLB=
)
[   20.485378] software IO TLB [mem 0xdbfc2000-0xdffc2000] (64MB) mappe=
d=20
at [ffff8800dbfc2000-ffff8800dffc1fff]
[   20.486516] futex hash table entries: 2048 (order: 5, 131072 bytes)
[   20.486606] audit: initializing netlink subsys (disabled)
[   20.486639] audit: type=3D2000 audit(1444159771.485:1): initialized
[   20.487037] Initialise system trusted keyring
[   20.487155] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   20.490158] VFS: Disk quotas dquot_6.6.0
[   20.490222] VFS: Dquot-cache hash table entries: 512 (order 0, 4096=20
bytes)
[   20.490897] SELinux:  Registering netfilter hooks
[   20.496222] NET: Registered protocol family 38
[   20.496233] Key type asymmetric registered
[   20.496238] Asymmetric key parser 'x509' registered
[   20.496271] Block layer SCSI generic (bsg) driver version 0.4 loaded=
=20
(major 252)
[   20.496331] io scheduler noop registered
[   20.496334] io scheduler deadline registered
[   20.496393] io scheduler cfq registered (default)
[   20.501906] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   20.501917] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[   20.501960] vesafb: mode is 1024x768x32, linelength=3D4096, pages=3D=
0
[   20.501962] vesafb: scrolling: redraw
[   20.501965] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[   20.501985] vesafb: framebuffer at 0xf8000000, mapped to=20
0xffffc90000800000, using 3072k, total 3072k
[   20.621192] Console: switching to colour frame buffer device 128x48
[   20.729783] fb0: VESA VGA frame buffer device
[   20.729840] intel_idle: does not run on family 6 model 15
[   20.729964] input: Power Button as=20
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[   20.729969] ACPI: Power Button [PBTN]
[   20.730042] input: Power Button as=20
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   20.730045] ACPI: Power Button [PWRF]
[   20.730493] GHES: HEST is not enabled!
[   20.730624] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   20.751178] 00:04: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1152=
00)=20
is a 16550A
[   20.751876] Non-volatile memory driver v1.3
[   20.751916] Linux agpgart interface v0.103
[   20.754065] loop: module loaded
[   20.754437] ata_piix 0000:00:1f.1: version 2.13
[   20.754974] scsi host0: ata_piix
[   20.755109] scsi host1: ata_piix
[   20.755170] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x20a0=
=20
irq 14
[   20.755173] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x20a8=
=20
irq 15
[   20.755412] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   20.755558] ata2: port disabled--ignoring
[   20.906683] scsi host2: ata_piix
[   20.906806] scsi host3: ata_piix
[   20.906867] ata3: SATA max UDMA/133 cmd 0x20d0 ctl 0x20e8 bmdma=20
0x20b0 irq 19
[   20.906870] ata4: SATA max UDMA/133 cmd 0x20d8 ctl 0x20ec bmdma=20
0x20b8 irq 19
[   20.906962] libphy: Fixed MDIO Bus: probed
[   20.907063] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[   20.907070] ehci-pci: EHCI PCI platform driver
[   20.907338] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   20.907394] ehci-pci 0000:00:1d.7: new USB bus registered, assigned=20
bus number 1
[   20.907408] ehci-pci 0000:00:1d.7: debug port 1
[   20.911333] ehci-pci 0000:00:1d.7: cache line size of 64 is not supp=
orted
[   20.911624] ata1.00: ATAPI: HL-DT-STDVD-ROM GDR8164B, 0L06, max UDMA=
/33
[   20.911777] ehci-pci 0000:00:1d.7: irq 16, io mem 0xfc604000
[   20.917175] ata1.00: configured for UDMA/33
[   20.917248] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   20.917316] usb usb1: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0002
[   20.917320] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[   20.917322] usb usb1: Product: EHCI Host Controller
[   20.917325] usb usb1: Manufacturer: Linux 4.3.0-rc1+ ehci_hcd
[   20.917328] usb usb1: SerialNumber: 0000:00:1d.7
[   20.917483] hub 1-0:1.0: USB hub found
[   20.917493] hub 1-0:1.0: 8 ports detected
[   20.917755] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   20.917762] ohci-pci: OHCI PCI platform driver
[   20.917784] uhci_hcd: USB Universal Host Controller Interface driver
[   20.918074] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   20.918130] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned=20
bus number 2
[   20.918137] uhci_hcd 0000:00:1d.0: detected 2 ports
[   20.918159] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00002000
[   20.918215] usb usb2: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   20.918218] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[   20.918220] usb usb2: Product: UHCI Host Controller
[   20.918223] usb usb2: Manufacturer: Linux 4.3.0-rc1+ uhci_hcd
[   20.918226] usb usb2: SerialNumber: 0000:00:1d.0
[   20.918360] hub 2-0:1.0: USB hub found
[   20.918369] hub 2-0:1.0: 2 ports detected
[   20.918721] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   20.918771] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned=20
bus number 3
[   20.918779] uhci_hcd 0000:00:1d.1: detected 2 ports
[   20.918797] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002020
[   20.918851] usb usb3: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   20.918854] usb usb3: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[   20.918857] usb usb3: Product: UHCI Host Controller
[   20.918860] usb usb3: Manufacturer: Linux 4.3.0-rc1+ uhci_hcd
[   20.918862] usb usb3: SerialNumber: 0000:00:1d.1
[   20.919016] hub 3-0:1.0: USB hub found
[   20.919026] hub 3-0:1.0: 2 ports detected
[   20.919384] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   20.919435] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned=20
bus number 4
[   20.919442] uhci_hcd 0000:00:1d.2: detected 2 ports
[   20.919470] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[   20.919550] usb usb4: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   20.919553] usb usb4: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[   20.919556] usb usb4: Product: UHCI Host Controller
[   20.919559] usb usb4: Manufacturer: Linux 4.3.0-rc1+ uhci_hcd
[   20.919561] usb usb4: SerialNumber: 0000:00:1d.2
[   20.919700] hub 4-0:1.0: USB hub found
[   20.919709] hub 4-0:1.0: 2 ports detected
[   20.920069] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   20.920128] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned=20
bus number 5
[   20.920136] uhci_hcd 0000:00:1d.3: detected 2 ports
[   20.920161] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00002060
[   20.920216] usb usb5: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   20.920219] usb usb5: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[   20.920222] usb usb5: Product: UHCI Host Controller
[   20.920224] usb usb5: Manufacturer: Linux 4.3.0-rc1+ uhci_hcd
[   20.920227] usb usb5: SerialNumber: 0000:00:1d.3
[   20.920363] hub 5-0:1.0: USB hub found
[   20.920373] hub 5-0:1.0: 2 ports detected
[   20.920545] usbcore: registered new interface driver usbserial
[   20.920556] usbcore: registered new interface driver usbserial_gener=
ic
[   20.920567] usbserial: USB Serial support registered for generic
[   20.920627] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] a=
t=20
0x60,0x64 irq 1,12
[   20.921236] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8164=
B=20
0L06 PQ: 0 ANSI: 5
[   20.923682] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.923689] serio: i8042 AUX port at 0x60,0x64 irq 12
[   20.923850] mousedev: PS/2 mouse device common for all mice
[   20.924067] rtc_cmos 00:00: RTC can wake from S4
[   20.924217] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   20.924242] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes=20
nvram, hpet irqs
[   20.924324] device-mapper: uevent: version 1.0.3
[   20.924418] device-mapper: ioctl: 4.33.0-ioctl (2015-8-18)=20
initialised: dm-devel@redhat.com
[   20.925071] hidraw: raw HID events driver (C) Jiri Kosina
[   20.925248] usbcore: registered new interface driver usbhid
[   20.925251] usbhid: USB HID core driver
[   20.925289] drop_monitor: Initializing network drop monitor service
[   20.925393] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.925443] Initializing XFRM netlink socket
[   20.925630] NET: Registered protocol family 10
[   20.925914] mip6: Mobile IPv6
[   20.925920] NET: Registered protocol family 17
[   20.926371] registered taskstats version 1
[   20.926383] Loading compiled-in X.509 certificates
[   20.927692] Loaded X.509 cert 'Build time autogenerated kernel key:=20
901d8148726560b357726624c16e117b0ab6956b'
[   20.930361]   Magic number: 3:417:495
[   20.930470] rtc_cmos 00:00: setting system clock to 2015-10-06=20
19:29:32 UTC (1444159772)
[   20.930518] PM: Hibernation image not present or could not be loaded=
=2E
[   20.945989] sr 0:0:0:0: [sr0] scsi3-mmc drive: 52x/52x cd/rw xa/form=
2=20
cdda tray
[   20.945993] cdrom: Uniform CD-ROM driver Revision: 3.20
[   20.946171] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   20.946322] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   21.120638] ata4.00: ATA-7: ST380815AS, 3.AAC, max UDMA/133
[   21.120641] ata4.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0=
/32)
[   21.195605] ata4.00: configured for UDMA/133
[   21.195755] scsi 3:0:0:0: Direct-Access     ATA ST380815AS       C  =
 =20
PQ: 0 ANSI: 5
[   21.196022] sd 3:0:0:0: [sda] 156301488 512-byte logical blocks:=20
(80.0 GB/74.5 GiB)
[   21.196082] sd 3:0:0:0: [sda] Write Protect is off
[   21.196086] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   21.196112] sd 3:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[   21.196191] sd 3:0:0:0: Attached scsi generic sg1 type 0
[   21.243601]  sda: sda1 sda2 sda3
[   21.243980] sd 3:0:0:0: [sda] Attached SCSI disk
[   21.244692] Freeing unused kernel memory: 1520K (ffffffff81d32000 -=20
ffffffff81eae000)
[   21.244696] Write protecting the kernel read-only data: 12288k
[   21.245397] Freeing unused kernel memory: 1020K (ffff880001701000 -=20
ffff880001800000)
[   21.245869] Freeing unused kernel memory: 904K (ffff880001b1e000 -=20
ffff880001c00000)
[   21.250551] systemd[1]: systemd 204 running in system mode. (+PAM=20
+LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ=
)
[   21.250704] systemd[1]: Running in initial RAM disk.
[   21.250857] systemd[1]: Set hostname to <bgrove-test2.attotech.com>.
[   21.251639] random: systemd urandom read with 16 bits of entropy=20
available
[   21.258279] systemd[1]: Expecting device=20
dev-mapper-fedora_win\x2d\x2d7lgoa5s28j0\x2dswap.device...
[   21.258297] systemd[1]: Expecting device=20
dev-disk-by\x2duuid-d8488274\x2dec37\x2d427a\x2d8df2\x2dc6d6ef65062d.de=
vice...
[   21.258311] systemd[1]: Expecting device=20
dev-mapper-fedora_win\x2d\x2d7lgoa5s28j0\x2droot.device...
[   21.258323] systemd[1]: Starting Timers.
[   21.258339] systemd[1]: Reached target Timers.
[   21.258411] systemd[1]: Starting udev Kernel Socket.
[   21.258444] systemd[1]: Listening on udev Kernel Socket.
[   21.258501] systemd[1]: Starting udev Control Socket.
[   21.258541] systemd[1]: Listening on udev Control Socket.
[   21.258553] systemd[1]: Starting Journal Socket.
[   21.258616] systemd[1]: Listening on Journal Socket.
[   21.258827] systemd[1]: Starting dracut cmdline hook...
[   21.259694] systemd[1]: Started Load Kernel Modules.
[   21.259713] systemd[1]: Starting Sockets.
[   21.259728] systemd[1]: Reached target Sockets.
[   21.259739] systemd[1]: Starting Journal Service...
[   21.261964] systemd[1]: Started Journal Service.
[   21.262216] systemd[1]: Starting Swap.
[   21.262233] systemd[1]: Reached target Swap.
[   21.262248] systemd[1]: Starting Local File Systems.
[   21.262261] systemd[1]: Reached target Local File Systems.
[   21.392024] usb 4-1: new full-speed USB device number 2 using uhci_h=
cd
[   21.421330] systemd-udevd[189]: starting version 204
[   21.487025] tsc: Refined TSC clocksource calibration: 1994.999 MHz
[   21.487032] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:=20
0x398374a7fb8, max_idle_ns: 881590820223 ns
[   21.552045] usb 4-1: New USB device found, idVendor=3D058f, idProduc=
t=3D9254
[   21.552052] usb 4-1: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D0
[   21.552055] usb 4-1: Product: Generic USB Hub
[   21.552058] usb 4-1: Manufacturer: ALCOR
[   21.555088] hub 4-1:1.0: USB hub found
[   21.557039] hub 4-1:1.0: 4 ports detected
[   21.837020] usb 4-1.1: new low-speed USB device number 3 using uhci_=
hcd
[   21.965038] usb 4-1.1: New USB device found, idVendor=3D413c,=20
idProduct=3D2107
[   21.965042] usb 4-1.1: New USB device strings: Mfr=3D1, Product=3D2,=
=20
SerialNumber=3D0
[   21.965046] usb 4-1.1: Product: Dell USB Entry Keyboard
[   21.965048] usb 4-1.1: Manufacturer: DELL
[   21.983590] input: DELL Dell USB Entry Keyboard as=20
/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1.1/4-1.1:1.0/0003:413C:210=
7.0001/input/input5
[   22.034217] hid-generic 0003:413C:2107.0001: input,hidraw0: USB HID=20
v1.10 Keyboard [DELL Dell USB Entry Keyboard] on usb-0000:00:1d.2-1.1/i=
nput0
[   22.101014] usb 4-1.2: new low-speed USB device number 4 using uhci_=
hcd
[   22.231035] usb 4-1.2: New USB device found, idVendor=3D05ac,=20
idProduct=3D0304
[   22.231039] usb 4-1.2: New USB device strings: Mfr=3D1, Product=3D2,=
=20
SerialNumber=3D0
[   22.231042] usb 4-1.2: Product: Apple Optical USB Mouse
[   22.231045] usb 4-1.2: Manufacturer: Mitsumi Electric
[   22.248351] input: Mitsumi Electric Apple Optical USB Mouse as=20
/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1.2/4-1.2:1.0/0003:05AC:030=
4.0002/input/input6
[   22.248492] apple 0003:05AC:0304.0002: input,hidraw1: USB HID v1.10=20
Mouse [Mitsumi Electric Apple Optical USB Mouse] on=20
usb-0000:00:1d.2-1.2/input0
[   22.315015] usb 4-1.3: new low-speed USB device number 5 using uhci_=
hcd
[   22.447036] usb 4-1.3: New USB device found, idVendor=3D10d5,=20
idProduct=3D55a4
[   22.447040] usb 4-1.3: New USB device strings: Mfr=3D1, Product=3D2,=
=20
SerialNumber=3D3
[   22.447043] usb 4-1.3: Product: 4 Port KVMSwicther
[   22.447046] usb 4-1.3: Manufacturer: No brand
[   22.447049] usb 4-1.3: SerialNumber: 2=C3=A4=C3=92
[   22.487085] clocksource: Switched to clocksource tsc
[   22.488143] input: No brand 4 Port KVMSwicther as=20
/devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1.3/4-1.3:1.0/0003:10D5:55A=
4.0003/input/input7
[   22.539275] hid-generic 0003:10D5:55A4.0003: input,hidraw2: USB HID=20
v1.10 Keyboard [No brand 4 Port KVMSwicther] on usb-0000:00:1d.2-1.3/in=
put0
[   22.545053] usbhid 4-1.3:1.1: couldn't find an input interrupt endpo=
int
[   25.857080] scsi host4: ATTO ExpressSAS 6GB RAID Adapter (bus 0x60,=20
device 0x00, IRQ 0x19) driver version: 1.00  firmware version: 4.10

[   25.872394] scsi 4:0:0:0: Enclosure         ATTO     Virtual SES    =
 =20
0001 PQ: 0 ANSI: 6
[   25.932447] esas2r: request failure - cdb:a0 reqstatus:7 target:0
[   25.933827] scsi 4:0:1:0: Enclosure         ATTO     ESAS 6Gb x24 SE=
P=20
0001 PQ: 0 ANSI: 5
[   25.934996] esas2r: request failure - cdb:a0 reqstatus:7 target:1
[   25.975337] scsi 4:0:0:0: Attached scsi generic sg2 type 13
[   25.975566] scsi 4:0:1:0: Attached scsi generic sg3 type 13
[   25.975627] esas2r [unknown, scsi, 4:0:0:0]scsi device already exist=
s=20
at id 0
[   26.232311] random: nonblocking pool is initialized
[   26.717499] EXT4-fs (dm-1): INFO: recovery required on readonly=20
filesystem
[   26.717504] EXT4-fs (dm-1): write access will be enabled during reco=
very
[   28.263164] EXT4-fs (dm-1): recovery complete
[   28.320585] EXT4-fs (dm-1): mounted filesystem with ordered data=20
mode. Opts: (null)
[   28.487556] systemd-journald[102]: Received SIGTERM
[   30.060146] SELinux: 32768 avtab hash slots, 94943 rules.
[   30.081305] SELinux: 32768 avtab hash slots, 94943 rules.
[   30.448559] SELinux:  8 users, 82 roles, 4533 types, 257 bools, 1=20
sens, 1024 cats
[   30.448566] SELinux:  83 classes, 94943 rules
[   30.454797] SELinux:  Class netlink_iscsi_socket not defined in poli=
cy.
[   30.454806] SELinux:  Class netlink_fib_lookup_socket not defined in=
=20
policy.
[   30.454809] SELinux:  Class netlink_connector_socket not defined in=20
policy.
[   30.454810] SELinux:  Class netlink_netfilter_socket not defined in=20
policy.
[   30.454820] SELinux:  Class netlink_generic_socket not defined in po=
licy.
[   30.454822] SELinux:  Class netlink_scsitransport_socket not defined=
=20
in policy.
[   30.454823] SELinux:  Class netlink_rdma_socket not defined in polic=
y.
[   30.454825] SELinux:  Class netlink_crypto_socket not defined in pol=
icy.
[   30.454839] SELinux:  Permission audit_read in class capability2 not=
=20
defined in policy.
[   30.454845] SELinux:  Class binder not defined in policy.
[   30.454847] SELinux: the above unknown classes and permissions will=20
be allowed
[   30.454859] SELinux:  Completing initialization.
[   30.454860] SELinux:  Setting up existing superblocks.
[   30.472491] audit: type=3D1403 audit(1444159782.040:2): policy loade=
d=20
auid=3D4294967295 ses=3D4294967295
[   30.479684] systemd[1]: Successfully loaded SELinux policy in 659.53=
0ms.
[   30.632659] audit: type=3D1400 audit(1444159782.200:3): avc: denied =
 {=20
associate } for  pid=3D1 comm=3D"systemd" name=3D"/" dev=3D"pstore" ino=
=3D8433=20
scontext=3Dsystem_u:object_r:sysfs_t:s0=20
tcontext=3Dsystem_u:object_r:pstorefs_t:s0 tclass=3Dfilesystem permissi=
ve=3D1
[   30.654911] systemd[1]: Relabelled /dev and /run in 22.208ms.
[   31.226805] LVM: Logical Volume autoactivation enabled.
[   31.226812] LVM: Activation generator successfully completed.
[   34.991166] EXT4-fs (dm-1): re-mounted. Opts: (null)
[   35.899484] systemd-udevd[621]: starting version 204
[   36.428666] wmi: Mapper loaded
[   36.430794] parport_pc 00:03: [irq 10]
[   36.430801] parport_pc 00:03: [dma 1]
[   36.430809] parport_pc 00:03: [io  0x0378-0x037f]
[   36.430814] parport_pc 00:03: [io  0x0778-0x077d]
[   36.431358] parport_pc 00:03: activated
[   36.431363] parport_pc 00:03: reported by Plug and Play ACPI
[   36.431435] parport0: PC-style at 0x378 (0x778), irq 10=20
[PCSPP,TRISTATE,EPP]
[   36.455929] pps_core: LinuxPPS API ver. 1 registered
[   36.455934] pps_core: Software ver. 5.3.6 - Copyright 2005-2007=20
Rodolfo Giometti <giometti@linux.it>
[   36.466451] ACPI BIOS Error (bug): \_SB_.PCI0._OSC: Excess arguments=
=20
- ASL declared 5, ACPI requires 4 (20150818/nsarguments-189)
[   36.466523] ACPI Error: [CAPD] Namespace lookup failure,=20
AE_ALREADY_EXISTS (20150818/dsfield-211)
[   36.466530] ACPI Error: Method parse/execution failed=20
[\_SB.PCI0._OSC] (Node ffff88011b0a52a8), AE_ALREADY_EXISTS=20
(20150818/psparse-542)
[   36.466774] shpchp: Standard Hot Plug PCI Controller Driver version:=
 0.4
[   36.468508] PTP clock support registered
[   36.549947] intel_rng: Firmware space is locked read-only. If you=20
can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
[   36.612425] esas2r: request failure - SCSI error 5 ASC:24 ASCQ:0 CDB=
:1c
[   36.955170] EDAC MC: Ver: 3.0.0
[   36.957054] esas2r: request failure - SCSI error 5 ASC:35 ASCQ:1 CDB=
:1c
[   36.969476] ses 4:0:0:0: Attached Enclosure device
[   36.969497] ses 4:0:1:0: Attached Enclosure device
[   37.005225] EDAC MC0: Giving out device to module i5000_edac.c=20
controller I5000: DEV 0000:00:10.0 (POLLED)
[   37.005248] EDAC PCI0: Giving out device to module i5000_edac=20
controller EDAC PCI controller: DEV 0000:00:10.0 (POLLED)
[   37.263504] ACPI Warning: SystemIO range=20
0x000000000000F828-0x000000000000F82F conflicts with OpRegion=20
0x000000000000F800-0x000000000000F84F (\_SB_.PCI0.LPC_.PMIO)=20
(20150818/utaddress-254)
[   37.263514] ACPI: If an ACPI driver is available for this device, yo=
u=20
should use it instead of the native driver
[   37.263582] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   37.268668] iTCO_vendor_support: vendor-support=3D0
[   37.273275] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   37.273328] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=3D=
2,=20
TCOBASE=3D0xf860)
[   37.273823] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   37.283551] input: PC Speaker as /devices/platform/pcspkr/input/inpu=
t8
[   37.586820] tg3.c:v3.137 (May 11, 2014)
[   37.607118] tg3 0000:1f:00.0 eth0: Tigon3 [partno(BCM95752) rev 6001=
]=20
(PCI Express) MAC address 00:1c:c4:86:cc:3f
[   37.607123] tg3 0000:1f:00.0 eth0: attached PHY is 5752=20
(10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[   37.607127] tg3 0000:1f:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0]=
=20
ASF[0] TSOcap[1]
[   37.607130] tg3 0000:1f:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-=
bit]
[   37.757146] input: HP WMI hotkeys as /devices/virtual/input/input9
[   37.823434] tg3 0000:1f:00.0 em1: renamed from eth0
[   37.838161] systemd-udevd[633]: renamed network interface eth0 to em=
1
[   37.859624] snd_hda_codec_realtek hdaudioC0D0: ALC262: SKU not ready=
=20
0x411111f0
[   37.860341] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC262=
:=20
line_outs=3D1 (0x15/0x0/0x0/0x0/0x0) type:line
[   37.860345] snd_hda_codec_realtek hdaudioC0D0: speaker_outs=3D1=20
(0x16/0x0/0x0/0x0/0x0)
[   37.860349] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=3D1=20
(0x1b/0x0/0x0/0x0/0x0)
[   37.860351] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=3D0=
x0
[   37.860354] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   37.860357] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=3D0x18
[   37.860360] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=3D0x19
[   37.860363] snd_hda_codec_realtek hdaudioC0D0:      Line=3D0x1a
[   37.860366] snd_hda_codec_realtek hdaudioC0D0:      CD=3D0x1c
[   37.860368] snd_hda_codec_realtek hdaudioC0D0:      Aux=3D0x14
[   37.885912] ppdev: user-space parallel port driver
[   37.892536] input: HDA Intel Rear Mic as=20
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   37.892689] input: HDA Intel Front Mic as=20
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   37.892826] input: HDA Intel Line as=20
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   37.892975] input: HDA Intel Line Out as=20
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   37.893121] input: HDA Intel Front Headphone as=20
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   39.423034] floppy0: no floppy controllers found
[   39.532880] Adding 4063228k swap on=20
/dev/mapper/fedora_win--7lgoa5s28j0-swap.  Priority:-1 extents:1=20
across:4063228k FS
[   41.309279] EXT4-fs (sda1): mounted filesystem with ordered data=20
mode. Opts: (null)
[   41.373320] audit: type=3D1305 audit(1444159792.941:4): audit_pid=3D=
688=20
old=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:aud=
itd_t:s0=20
res=3D1
[   42.299192] alsactl[699]: segfault at 0 ip 00000036e2848a7d sp=20
00007ffe18932090 error 4 in libc-2.17.so[36e2800000+1b6000]
[   47.994128] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   49.060763] Ebtables v2.0 registered
[   49.475545] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   50.647359] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[   51.372710] Bluetooth: Core ver 2.20
[   51.372908] NET: Registered protocol family 31
[   51.372910] Bluetooth: HCI device and connection manager initialized
[   51.372916] Bluetooth: HCI socket layer initialized
[   51.372920] Bluetooth: L2CAP socket layer initialized
[   51.372933] Bluetooth: SCO socket layer initialized
[   51.621510] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   51.621516] Bluetooth: BNEP filters: protocol multicast
[   51.621524] Bluetooth: BNEP socket layer initialized
[   53.720533] tg3 0000:1f:00.0 em1: Link is up at 1000 Mbps, full dupl=
ex
[   53.720549] tg3 0000:1f:00.0 em1: Flow control is on for TX and on f=
or RX
[   53.720570] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   56.310628] FS-Cache: Loaded
[   58.199726] RPC: Registered named UNIX socket transport module.
[   58.199732] RPC: Registered udp transport module.
[   58.199734] RPC: Registered tcp transport module.
[   58.199736] RPC: Registered tcp NFSv4.1 backchannel transport module=
=2E
[   60.938744] FS-Cache: Netfs 'nfs' registered for caching
[   60.950771] Key type dns_resolver registered
[   62.105165] NFS: Registering the id_resolver key type
[   62.105183] Key type id_resolver registered
[   62.105186] Key type id_legacy registered
[   76.438402] Adjusting tsc more than 11% (3680585 vs 4667347)
[ 2009.148877] pm80xx: module verification failed: signature and/or=20
required key missing - tainting kernel
[ 2009.151309] pm80xx 0000:20:00.0: pm80xx: driver version 0.1.38
[ 2009.151919] pm80xx pm8001_ioremap 431:PCI: bar 0, logicalBar 0
[ 2009.151922] pm80xx pm8001_ioremap 437:base addr fc300000=20
virt_addr=3Dffffc90000ba0000 len=3D65536
[ 2009.151929] pm80xx pm8001_ioremap 431:PCI: bar 2, logicalBar 1
[ 2009.151931] pm80xx pm8001_ioremap 437:base addr fc310000=20
virt_addr=3Dffffc90000ce0000 len=3D65536
[ 2009.151933] pm80xx pm8001_alloc 255:pm8001_alloc: PHY:8
[ 2009.152597] pm80xx init_pci_device_addresses 788:Scratchpad 0 Offset=
:=20
0x2000 value 0x40002000
[ 2009.152601] pm80xx init_pci_device_addresses 792:Scratchpad 0 PCI BA=
R: 0
[ 2009.152610] pm80xx init_pci_device_addresses 816:GST OFFSET 0xc4
[ 2009.152612] pm80xx init_pci_device_addresses 819:INBND OFFSET 0x2000=
0128
[ 2009.152614] pm80xx init_pci_device_addresses 822:OBND OFFSET 0x24000=
928
[ 2009.152616] pm80xx init_pci_device_addresses 825:IVT OFFSET 0x800140=
8
[ 2009.152619] pm80xx init_pci_device_addresses 828:PSPA OFFSET 0x80016=
08
[ 2009.152622] pm80xx init_pci_device_addresses 832:addr - main cfg=20
ffffc90000ba2000 general status ffffc90000ba20c4
[ 2009.152624] pm80xx init_pci_device_addresses 836:addr - inbnd=20
ffffc90000ba2128 obnd ffffc90000ba2928
[ 2009.152627] pm80xx init_pci_device_addresses 840:addr - pspa=20
ffffc90000ba3608 ivt ffffc90000ba3408
[ 2009.152749] pm80xx pm80xx_chip_soft_rst 1220:reset register before=20
write : 0x0
[ 2009.652829] pm80xx pm80xx_chip_soft_rst 1227:reset register after=20
write 0x40
[ 2009.652833] pm80xx pm80xx_chip_soft_rst 1233: soft reset successful=20
[regval: 0x40]
[ 2010.040030] pm80xx check_fw_ready 720: ila ready status in 188201=20
millisec
[ 2010.172739] pm80xx check_fw_ready 735: raae ready status in 64495=20
millisec
[ 2010.172744] pm80xx check_fw_ready 750: iop0 ready status in 0 millis=
ec
[ 2010.172748] pm80xx check_fw_ready 768:iop1 ready status in 0 millise=
c
[ 2010.172750] pm80xx pm80xx_chip_soft_rst 1290:SPCv soft reset Complet=
e
[ 2010.172756] pm80xx check_fw_ready 720: ila ready status in 0 millise=
c
[ 2010.172760] pm80xx check_fw_ready 735: raae ready status in 0 millis=
ec
[ 2010.172763] pm80xx check_fw_ready 750: iop0 ready status in 0 millis=
ec
[ 2010.172767] pm80xx check_fw_ready 768:iop1 ready status in 0 millise=
c
[ 2010.172770] pm80xx init_pci_device_addresses 788:Scratchpad 0 Offset=
:=20
0x2000 value 0x40002000
[ 2010.172772] pm80xx init_pci_device_addresses 792:Scratchpad 0 PCI BA=
R: 0
[ 2010.172781] pm80xx init_pci_device_addresses 816:GST OFFSET 0xc4
[ 2010.172784] pm80xx init_pci_device_addresses 819:INBND OFFSET 0x2000=
0128
[ 2010.172787] pm80xx init_pci_device_addresses 822:OBND OFFSET 0x24000=
928
[ 2010.172789] pm80xx init_pci_device_addresses 825:IVT OFFSET 0x800140=
8
[ 2010.172792] pm80xx init_pci_device_addresses 828:PSPA OFFSET 0x80016=
08
[ 2010.172795] pm80xx init_pci_device_addresses 832:addr - main cfg=20
ffffc90000ba2000 general status ffffc90000ba20c4
[ 2010.172797] pm80xx init_pci_device_addresses 836:addr - inbnd=20
ffffc90000ba2128 obnd ffffc90000ba2928
[ 2010.172799] pm80xx init_pci_device_addresses 840:addr - pspa=20
ffffc90000ba3608 ivt ffffc90000ba3408
[ 2010.184151] pm80xx pm80xx_chip_init 1121:MPI initialize successful!
[ 2010.184154] pm80xx pm80xx_set_sas_protocol_timer_config=20
928:SASConfigPage.pageCode 0x00000004
[ 2010.184156] pm80xx pm80xx_set_sas_protocol_timer_config=20
931:SASConfigPage.MST_MSI  0x00018000
[ 2010.184158] pm80xx pm80xx_set_sas_protocol_timer_config=20
934:SASConfigPage.STP_SSP_MCT_TMO  0x00200020
[ 2010.184160] pm80xx pm80xx_set_sas_protocol_timer_config=20
937:SASConfigPage.STP_FRM_TMO  0x05ff0000
[ 2010.184162] pm80xx pm80xx_set_sas_protocol_timer_config=20
940:SASConfigPage.STP_IDLE_TMO  0x00000005
[ 2010.184164] pm80xx pm80xx_set_sas_protocol_timer_config=20
943:SASConfigPage.OPNRJT_RTRY_INTVL  0x00000002
[ 2010.184165] pm80xx pm80xx_set_sas_protocol_timer_config=20
946:SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO  0x00800080
[ 2010.184167] pm80xx pm80xx_set_sas_protocol_timer_config=20
949:SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR  0x5b8e5b8e
[ 2010.184169] pm80xx pm80xx_set_sas_protocol_timer_config=20
951:SASConfigPage.MAX_AIP  0x00200000
[ 2010.184172] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:30 ,=20
UPDATED PI=3D1 CI=3D0
[ 2010.184177] scsi host5: pm80xx
[ 2010.188617] pm80xx pm8001_setup_msix 917:pci_enable_msix_exact=20
request ret:0 no of intr 64
[ 2010.189496] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:30 ,=20
UPDATED PI=3D2 CI=3D1
[ 2010.189504] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:28 ,=20
UPDATED PI=3D3 CI=3D2
[ 2010.260514] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D0 PI=3D3=20
msgHeader=3D81002830
[ 2010.260516] pm80xx process_one_iomb=20
3673:OPC_OUB_SET_CONTROLLER_CONFIG opcode:830
[ 2010.260518] pm80xx mpi_set_controller_config_resp 3375:SET CONTROLLE=
R=20
RESP: status 0x0 qlfr_pgcd 0x4
[ 2010.260519] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D1 PI=3D3
[ 2010.260520] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D1 PI=3D3=20
msgHeader=3D81002830
[ 2010.260521] pm80xx process_one_iomb=20
3673:OPC_OUB_SET_CONTROLLER_CONFIG opcode:830
[ 2010.260522] pm80xx mpi_set_controller_config_resp 3375:SET CONTROLLE=
R=20
RESP: status 0x0 qlfr_pgcd 0x6
[ 2010.260523] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D2 PI=3D3
[ 2010.260525] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D2 PI=3D3=20
msgHeader=3D81002023
[ 2010.260526] pm80xx process_one_iomb 3635:OPC_OUB_GET_NVMD_DATA
[ 2010.260528] pm80xx pm8001_mpi_get_nvmd_resp 3147:Get nvm data comple=
te!
[ 2010.260528] pm80xx pm8001_mpi_get_nvmd_resp 3158:Get NVMD success, I=
R=3D1
[ 2010.260534] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D3 PI=3D3
[ 2010.260540] pm80xx pm8001_init_sas_add 685:phy 0 sas_addr =3D=20
40c6170060080150
[ 2010.260541] pm80xx pm8001_init_sas_add 685:phy 1 sas_addr =3D=20
40c6170060080150
[ 2010.260542] pm80xx pm8001_init_sas_add 685:phy 2 sas_addr =3D=20
40c6170060080150
[ 2010.260543] pm80xx pm8001_init_sas_add 685:phy 3 sas_addr =3D=20
40c6170060080150
[ 2010.260544] pm80xx pm8001_init_sas_add 685:phy 4 sas_addr =3D=20
40c6170060080150
[ 2010.260545] pm80xx pm8001_init_sas_add 685:phy 5 sas_addr =3D=20
40c6170060080150
[ 2010.260546] pm80xx pm8001_init_sas_add 685:phy 6 sas_addr =3D=20
40c6170060080150
[ 2010.260548] pm80xx pm8001_init_sas_add 685:phy 7 sas_addr =3D=20
40c6170060080150
[ 2010.260551] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:37 ,=20
UPDATED PI=3D4 CI=3D3
[ 2010.260554] pm80xx pm8001_set_phy_profile_single 4609:PHY 0 settings=
=20
applied
[ 2010.260554] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:37 ,=20
UPDATED PI=3D5 CI=3D3
[ 2010.260557] pm80xx pm8001_set_phy_profile_single 4609:PHY 1 settings=
=20
applied
[ 2010.260557] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:37 ,=20
UPDATED PI=3D6 CI=3D4
[ 2010.260560] pm80xx pm8001_set_phy_profile_single 4609:PHY 2 settings=
=20
applied
[ 2010.260560] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:37 ,=20
UPDATED PI=3D7 CI=3D5
[ 2010.260562] pm80xx pm8001_set_phy_profile_single 4609:PHY 3 settings=
=20
applied
[ 2010.260563] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:37 ,=20
UPDATED PI=3D8 CI=3D6
[ 2010.260565] pm80xx pm8001_set_phy_profile_single 4609:PHY 4 settings=
=20
applied
[ 2010.260565] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:37 ,=20
UPDATED PI=3D9 CI=3D7
[ 2010.260568] pm80xx pm8001_set_phy_profile_single 4609:PHY 5 settings=
=20
applied
[ 2010.260568] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:37 ,=20
UPDATED PI=3D10 CI=3D7
[ 2010.260571] pm80xx pm8001_set_phy_profile_single 4609:PHY 6 settings=
=20
applied
[ 2010.260571] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:37 ,=20
UPDATED PI=3D11 CI=3D8
[ 2010.260586] pm80xx pm8001_set_phy_profile_single 4609:PHY 7 settings=
=20
applied
[ 2010.260586] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D3 PI=3D4=20
msgHeader=3D81002837
[ 2010.260589] pm80xx process_one_iomb 3693:OPC_OUB_SET_PHY_PROFILE=20
opcode:837
[ 2010.260590] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D4 PI=3D5
[ 2010.260592] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D4 PI=3D5=20
msgHeader=3D81002837
[ 2010.260593] pm80xx process_one_iomb 3693:OPC_OUB_SET_PHY_PROFILE=20
opcode:837
[ 2010.260594] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D5 PI=3D7
[ 2010.260595] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D5 PI=3D7=20
msgHeader=3D81002837
[ 2010.260596] pm80xx process_one_iomb 3693:OPC_OUB_SET_PHY_PROFILE=20
opcode:837
[ 2010.260597] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D6 PI=3D7
[ 2010.260598] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D6 PI=3D7=20
msgHeader=3D81002837
[ 2010.260599] pm80xx process_one_iomb 3693:OPC_OUB_SET_PHY_PROFILE=20
opcode:837
[ 2010.260600] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D7 PI=3D9
[ 2010.260601] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D7 PI=3D9=20
msgHeader=3D81002837
[ 2010.260602] pm80xx process_one_iomb 3693:OPC_OUB_SET_PHY_PROFILE=20
opcode:837
[ 2010.260603] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D8 PI=3D9
[ 2010.260604] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D8 PI=3D9=20
msgHeader=3D81002837
[ 2010.260605] pm80xx process_one_iomb 3693:OPC_OUB_SET_PHY_PROFILE=20
opcode:837
[ 2010.260606] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D9 PI=3D9
[ 2010.260608] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D9 PI=3D10=20
msgHeader=3D81002837
[ 2010.260609] pm80xx process_one_iomb 3693:OPC_OUB_SET_PHY_PROFILE=20
opcode:837
[ 2010.260610] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D10 PI=3D10
[ 2010.260616] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D10 PI=3D11=20
msgHeader=3D81002837
[ 2010.260617] pm80xx process_one_iomb 3693:OPC_OUB_SET_PHY_PROFILE=20
opcode:837
[ 2010.260618] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D11 PI=3D11
[ 2010.261162] pm80xx pm80xx_chip_phy_start_req 4360:PHY START REQ for=20
phy_id 0
[ 2010.261165] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D12 CI=3D11
[ 2010.261166] pm80xx pm80xx_chip_phy_start_req 4360:PHY START REQ for=20
phy_id 1
[ 2010.261167] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D13 CI=3D11
[ 2010.261168] pm80xx pm80xx_chip_phy_start_req 4360:PHY START REQ for=20
phy_id 2
[ 2010.261170] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D14 CI=3D12
[ 2010.261171] pm80xx pm80xx_chip_phy_start_req 4360:PHY START REQ for=20
phy_id 3
[ 2010.261172] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D15 CI=3D12
[ 2010.261173] pm80xx pm80xx_chip_phy_start_req 4360:PHY START REQ for=20
phy_id 4
[ 2010.261175] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D16 CI=3D13
[ 2010.261176] pm80xx pm80xx_chip_phy_start_req 4360:PHY START REQ for=20
phy_id 5
[ 2010.261177] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D17 CI=3D14
[ 2010.261178] pm80xx pm80xx_chip_phy_start_req 4360:PHY START REQ for=20
phy_id 6
[ 2010.261180] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D18 CI=3D15
[ 2010.261181] pm80xx pm80xx_chip_phy_start_req 4360:PHY START REQ for=20
phy_id 7
[ 2010.261182] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D19 CI=3D16
[ 2010.261197] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D11 PI=3D12=20
msgHeader=3D81002804
[ 2010.261198] pm80xx process_one_iomb 3663:OPC_OUB_PHY_START_RESP=20
opcode:804
[ 2010.261199] pm80xx mpi_phy_start_resp 3098:phy start resp status:0x0=
,=20
phyid:0x0
[ 2010.261200] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D12 PI=3D13
[ 2010.261201] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D12 PI=3D13=20
msgHeader=3D81002804
[ 2010.261202] pm80xx process_one_iomb 3663:OPC_OUB_PHY_START_RESP=20
opcode:804
[ 2010.261203] pm80xx mpi_phy_start_resp 3098:phy start resp status:0x0=
,=20
phyid:0x1
[ 2010.261205] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D13 PI=3D14
[ 2010.261206] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D13 PI=3D14=20
msgHeader=3D81002804
[ 2010.261207] pm80xx process_one_iomb 3663:OPC_OUB_PHY_START_RESP=20
opcode:804
[ 2010.261208] pm80xx mpi_phy_start_resp 3098:phy start resp status:0x0=
,=20
phyid:0x2
[ 2010.261209] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D14 PI=3D14
[ 2010.261216] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D14 PI=3D16=20
msgHeader=3D81002804
[ 2010.261217] pm80xx process_one_iomb 3663:OPC_OUB_PHY_START_RESP=20
opcode:804
[ 2010.261218] pm80xx mpi_phy_start_resp 3098:phy start resp status:0x0=
,=20
phyid:0x3
[ 2010.261219] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D15 PI=3D17
[ 2010.261220] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D15 PI=3D17=20
msgHeader=3D81002804
[ 2010.261221] pm80xx process_one_iomb 3663:OPC_OUB_PHY_START_RESP=20
opcode:804
[ 2010.261222] pm80xx mpi_phy_start_resp 3098:phy start resp status:0x0=
,=20
phyid:0x4
[ 2010.261223] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D16 PI=3D18
[ 2010.261224] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D16 PI=3D18=20
msgHeader=3D81002804
[ 2010.261225] pm80xx process_one_iomb 3663:OPC_OUB_PHY_START_RESP=20
opcode:804
[ 2010.261226] pm80xx mpi_phy_start_resp 3098:phy start resp status:0x0=
,=20
phyid:0x5
[ 2010.261227] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D17 PI=3D19
[ 2010.261229] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D17 PI=3D19=20
msgHeader=3D81002804
[ 2010.261230] pm80xx process_one_iomb 3663:OPC_OUB_PHY_START_RESP=20
opcode:804
[ 2010.261231] pm80xx mpi_phy_start_resp 3098:phy start resp status:0x0=
,=20
phyid:0x6
[ 2010.261232] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D18 PI=3D19
[ 2010.261233] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D18 PI=3D19=20
msgHeader=3D81002804
[ 2010.261234] pm80xx process_one_iomb 3663:OPC_OUB_PHY_START_RESP=20
opcode:804
[ 2010.261235] pm80xx mpi_phy_start_resp 3098:phy start resp status:0x0=
,=20
phyid:0x7
[ 2010.261236] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D19 PI=3D19
[ 2010.261308] pm80xx 0000:80:00.0: pm80xx: driver version 0.1.38
[ 2010.261431] pm80xx pm8001_ioremap 431:PCI: bar 0, logicalBar 0
[ 2010.261431] pm80xx pm8001_ioremap 437:base addr fc200000=20
virt_addr=3Dffffc90000d00000 len=3D65536
[ 2010.261436] pm80xx pm8001_ioremap 431:PCI: bar 2, logicalBar 1
[ 2010.261437] pm80xx pm8001_ioremap 437:base addr fc210000=20
virt_addr=3Dffffc90000d20000 len=3D65536
[ 2010.261442] pm80xx pm8001_ioremap 431:PCI: bar 4, logicalBar 2
[ 2010.261442] pm80xx pm8001_ioremap 437:base addr fc220000=20
virt_addr=3Dffffc90000d40000 len=3D65536
[ 2010.261446] pm80xx pm8001_ioremap 431:PCI: bar 5, logicalBar 3
[ 2010.261446] pm80xx pm8001_ioremap 437:base addr fc230000=20
virt_addr=3Dffffc90000d60000 len=3D65536
[ 2010.261447] pm80xx pm8001_alloc 255:pm8001_alloc: PHY:8
[ 2010.262037] pm80xx init_pci_device_addresses 621:Scratchpad 0 Offset=
:=20
e600
[ 2010.262039] pm80xx init_pci_device_addresses 625:Scratchpad 0 PCI BA=
R: 3
[ 2010.362837] pm80xx pm8001_chip_soft_rst 842:MBIC - NMI Enable VPE0=20
(IOP)=3D 0x0
[ 2010.362840] pm80xx pm8001_chip_soft_rst 854:MBIC - NMI Enable VPE0=20
(AAP1)=3D 0x0
[ 2010.362843] pm80xx pm8001_chip_soft_rst 859:PCIE -Event Interrupt=20
Enable =3D 0x40fcf
[ 2010.362845] pm80xx pm8001_chip_soft_rst 864:PCIE - Event Interrupt  =
=3D 0x0
[ 2010.362847] pm80xx pm8001_chip_soft_rst 869:PCIE -Error Interrupt=20
Enable =3D 0xffffffff
[ 2010.362849] pm80xx pm8001_chip_soft_rst 874:PCIE - Error Interrupt =3D=
 0x0
[ 2010.362854] pm80xx pm8001_chip_soft_rst 898:GSM 0x0(0x00007b88)-GSM=20
Configuration and Reset =3D 0x7b88
[ 2010.362858] pm80xx pm8001_chip_soft_rst 916:GSM 0x0 (0x00007b88 =3D=3D=
>=20
0x00004088) - GSM Configuration and Reset is set to =3D 0x4088
[ 2010.362860] pm80xx pm8001_chip_soft_rst 923:GSM 0x700038 - Read=20
Address Parity Check Enable =3D 0xffffff
[ 2010.362862] pm80xx pm8001_chip_soft_rst 928:GSM 0x700038 - Read=20
Address Parity Check Enableis set to =3D 0x0
[ 2010.362865] pm80xx pm8001_chip_soft_rst 934:GSM 0x700040 - Write=20
Address Parity Check Enable =3D 0xffffff
[ 2010.362867] pm80xx pm8001_chip_soft_rst 939:GSM 0x700040 - Write=20
Address Parity Check Enable is set to =3D 0x0
[ 2010.362869] pm80xx pm8001_chip_soft_rst 945:GSM 0x300048 - Write Dat=
a=20
Parity Check Enable =3D 0xffffff
[ 2010.362871] pm80xx pm8001_chip_soft_rst 950:GSM 0x300048 - Write Dat=
a=20
Parity Check Enableis set to =3D 0x0
[ 2010.362885] pm80xx pm8001_chip_soft_rst 965:GPIO Output Control=20
Register: =3D 0x0
[ 2010.362889] pm80xx pm8001_chip_soft_rst 982:Top Register before=20
resetting IOP/AAP1:=3D 0x87fe01ff
[ 2010.362891] pm80xx pm8001_chip_soft_rst 990:Top Register before=20
resetting BDMA/OSSP: =3D 0x87fe01e7
[ 2010.362904] pm80xx pm8001_chip_soft_rst 1001:Top Register before=20
bringing up BDMA/OSSP:=3D 0x87fc01e6
[ 2010.362917] pm80xx pm8001_chip_soft_rst 1019:GSM 0x0 (0x00007b88)-GS=
M=20
Configuration and Reset =3D 0x4088
[ 2010.362921] pm80xx pm8001_chip_soft_rst 1034:GSM (0x00004088 =3D=3D>=
=20
0x00007b88) - GSM Configuration and Reset is set to =3D 0x7b88
[ 2010.362923] pm80xx pm8001_chip_soft_rst 1041:GSM 0x700038 - Read=20
Address Parity Check Enable =3D 0x0
[ 2010.362925] pm80xx pm8001_chip_soft_rst 1046:GSM 0x700038 - Read=20
Address Parity Check Enable is set to =3D 0xffffff
[ 2010.362929] pm80xx pm8001_chip_soft_rst 1053:GSM 0x700040 - Write=20
Address Parity Check Enable is set to =3D 0xffffff
[ 2010.362932] pm80xx pm8001_chip_soft_rst 1060:GSM 0x700048 - Write=20
Data Parity Check Enableis set to =3D 0xffffff
[ 2011.145804] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D19 PI=3D20=20
msgHeader=3D81002700
[ 2011.145810] pm80xx process_one_iomb 3518:OPC_OUB_HW_EVENT
[ 2011.145813] pm80xx mpi_hw_event 3164:portid:0 phyid:2 event:0x5=20
status:0x0
[ 2011.145815] pm80xx mpi_hw_event 3175:HW_EVENT_SATA_PHY_UP
[ 2011.145817] pm80xx hw_event_sata_phy_up 2992:port id 0, phy id 2=20
link_rate 2 portstate 0x1
[ 2011.145824] pm80xx pm8001_bytes_dmaed 3255:phy 2 byte dmaded.
[ 2011.145827] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D20 PI=3D20
[ 2011.145829] pm80xx pm8001_chip_soft_rst 1145:SPC soft reset Complete
[ 2011.145843] pm80xx init_pci_device_addresses 621:Scratchpad 0 Offset=
:=20
e600
[ 2011.145845] pm80xx init_pci_device_addresses 625:Scratchpad 0 PCI BA=
R: 3
[ 2011.146092] pm80xx pm8001_chip_init 684:MPI initialize successful!
[ 2011.146098] scsi host6: pm80xx
[ 2011.159117] sas: phy-5:2 added to port-5:0, phy_mask:0x4=20
(500108600017c642)
[ 2011.159140] sas: DOING DISCOVERY on port 0, pid:59
[ 2011.159144] pm80xx pm8001_dev_found_notify 631:Found device
[ 2011.159148] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:32 ,=20
UPDATED PI=3D20 CI=3D19
[ 2011.159175] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D20 PI=3D21=20
msgHeader=3D81002832
[ 2011.159176] pm80xx process_one_iomb 3543:OPC_OUB_DEV_REGIST
[ 2011.159178] pm80xx pm8001_mpi_reg_resp 3565: register device is=20
status =3D 0
[ 2011.159179] pm80xx pm8001_mpi_reg_resp 3568:DEVREG_SUCCESS
[ 2011.159182] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D21 PI=3D21
[ 2011.159862] sas: DONE DISCOVERY on port 0, pid:59, result:0
[ 2011.159873] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 2011.159882] sas: ata5: end_device-5:0: dev error handler
[ 2011.160211] pm80xx pm8001_setup_msix 917:pci_enable_msix_exact=20
request ret:0 no of intr 1
[ 2011.160239] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:28 ,=20
UPDATED PI=3D1 CI=3D0
[ 2011.161205] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D0 PI=3D1=20
msgHeader=3D81002023
[ 2011.161208] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.161208] pm80xx process_one_iomb 4120:OPC_OUB_GET_NVMD_DATA
[ 2011.161210] pm80xx pm8001_mpi_get_nvmd_resp 3147:Get nvm data comple=
te!
[ 2011.161211] pm80xx pm8001_mpi_get_nvmd_resp 3158:Get NVMD success, I=
R=3D1
[ 2011.161217] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D1 PI=3D1
[ 2011.161223] pm80xx pm8001_init_sas_add 685:phy 0 sas_addr =3D=20
2032630060080150
[ 2011.161224] pm80xx pm8001_init_sas_add 685:phy 1 sas_addr =3D=20
2032630060080150
[ 2011.161225] pm80xx pm8001_init_sas_add 685:phy 2 sas_addr =3D=20
2032630060080150
[ 2011.161226] pm80xx pm8001_init_sas_add 685:phy 3 sas_addr =3D=20
2032630060080150
[ 2011.161227] pm80xx pm8001_init_sas_add 685:phy 4 sas_addr =3D=20
2032630060080150
[ 2011.161229] pm80xx pm8001_init_sas_add 685:phy 5 sas_addr =3D=20
2032630060080150
[ 2011.161230] pm80xx pm8001_init_sas_add 685:phy 6 sas_addr =3D=20
2032630060080150
[ 2011.161231] pm80xx pm8001_init_sas_add 685:phy 7 sas_addr =3D=20
2032630060080150
[ 2011.163021] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:2d ,=20
UPDATED PI=3D2 CI=3D1
[ 2011.163023] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D3 CI=3D1
[ 2011.163025] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D4 CI=3D1
[ 2011.163026] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D5 CI=3D1
[ 2011.163028] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D6 CI=3D1
[ 2011.163030] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D7 CI=3D1
[ 2011.163031] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D8 CI=3D2
[ 2011.163033] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D9 CI=3D4
[ 2011.163035] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:4 ,=20
UPDATED PI=3D10 CI=3D4
[ 2011.163194] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D1 PI=3D10=20
msgHeader=3D81002029
[ 2011.163197] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163197] pm80xx process_one_iomb 4147:OPC_OUB_SAS_RE_INITIALIZE
[ 2011.163199] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D2 PI=3D10
[ 2011.163200] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D2 PI=3D10=20
msgHeader=3D81002004
[ 2011.163202] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163202] pm80xx process_one_iomb 4004:OPC_OUB_HW_EVENT
[ 2011.163204] pm80xx mpi_hw_event 3796:outbound queue HW event & event=
=20
type :
[ 2011.163204] pm80xx mpi_hw_event 3801:HW_EVENT_PHY_START_STATUS statu=
s =3D 0
[ 2011.163206] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D3 PI=3D10
[ 2011.163207] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D3 PI=3D10=20
msgHeader=3D81002004
[ 2011.163208] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163209] pm80xx process_one_iomb 4004:OPC_OUB_HW_EVENT
[ 2011.163210] pm80xx mpi_hw_event 3796:outbound queue HW event & event=
=20
type :
[ 2011.163210] pm80xx mpi_hw_event 3801:HW_EVENT_PHY_START_STATUS statu=
s =3D 0
[ 2011.163211] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D4 PI=3D10
[ 2011.163213] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D4 PI=3D10=20
msgHeader=3D81002004
[ 2011.163214] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163214] pm80xx process_one_iomb 4004:OPC_OUB_HW_EVENT
[ 2011.163216] pm80xx mpi_hw_event 3796:outbound queue HW event & event=
=20
type :
[ 2011.163216] pm80xx mpi_hw_event 3801:HW_EVENT_PHY_START_STATUS statu=
s =3D 0
[ 2011.163217] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D5 PI=3D10
[ 2011.163218] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D5 PI=3D10=20
msgHeader=3D81002004
[ 2011.163220] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163220] pm80xx process_one_iomb 4004:OPC_OUB_HW_EVENT
[ 2011.163222] pm80xx mpi_hw_event 3796:outbound queue HW event & event=
=20
type :
[ 2011.163222] pm80xx mpi_hw_event 3801:HW_EVENT_PHY_START_STATUS statu=
s =3D 0
[ 2011.163223] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D6 PI=3D10
[ 2011.163224] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D6 PI=3D10=20
msgHeader=3D81002004
[ 2011.163226] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163226] pm80xx process_one_iomb 4004:OPC_OUB_HW_EVENT
[ 2011.163228] pm80xx mpi_hw_event 3796:outbound queue HW event & event=
=20
type :
[ 2011.163228] pm80xx mpi_hw_event 3801:HW_EVENT_PHY_START_STATUS statu=
s =3D 0
[ 2011.163229] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D7 PI=3D10
[ 2011.163230] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D7 PI=3D10=20
msgHeader=3D81002004
[ 2011.163232] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163232] pm80xx process_one_iomb 4004:OPC_OUB_HW_EVENT
[ 2011.163233] pm80xx mpi_hw_event 3796:outbound queue HW event & event=
=20
type :
[ 2011.163234] pm80xx mpi_hw_event 3801:HW_EVENT_PHY_START_STATUS statu=
s =3D 0
[ 2011.163235] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D8 PI=3D10
[ 2011.163236] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D8 PI=3D10=20
msgHeader=3D81002004
[ 2011.163237] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163238] pm80xx process_one_iomb 4004:OPC_OUB_HW_EVENT
[ 2011.163239] pm80xx mpi_hw_event 3796:outbound queue HW event & event=
=20
type :
[ 2011.163239] pm80xx mpi_hw_event 3801:HW_EVENT_PHY_START_STATUS statu=
s =3D 0
[ 2011.163240] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D9 PI=3D10
[ 2011.163242] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D9 PI=3D10=20
msgHeader=3D81002004
[ 2011.163243] pm80xx process_one_iomb 3996:process_one_iomb:
[ 2011.163243] pm80xx process_one_iomb 4004:OPC_OUB_HW_EVENT
[ 2011.163245] pm80xx mpi_hw_event 3796:outbound queue HW event & event=
=20
type :
[ 2011.163245] pm80xx mpi_hw_event 3801:HW_EVENT_PHY_START_STATUS statu=
s =3D 0
[ 2011.163246] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D10 PI=3D10
[ 2011.310028] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.310028] pm80xx pm80xx_chip_sata_req 4131:PIO
[ 2011.310030] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0xec inb 0
[ 2011.310033] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D21 CI=3D20
[ 2011.311535] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D21 PI=3D22=20
msgHeader=3D8100200d
[ 2011.311537] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.311539] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.311549] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D22 PI=3D22
[ 2011.311563] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.311564] pm80xx pm80xx_chip_sata_req 4124:no data
[ 2011.311565] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x27 inb 0
[ 2011.311566] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D22 CI=3D21
[ 2011.339109] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D22 PI=3D23=20
msgHeader=3D8100200d
[ 2011.339110] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.339112] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.339114] pm80xx mpi_sata_completion 2106:SAS_PROTO_RESPONSE len =3D=
 20
[ 2011.339115] pm80xx mpi_sata_completion 2121:other len =3D 20
[ 2011.339119] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D23 PI=3D23
[ 2011.339128] ata5.00: ATA-8: ST3250310NS, SN06, max UDMA/133
[ 2011.339130] ata5.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31=
/32)
[ 2011.339138] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.339138] pm80xx pm80xx_chip_sata_req 4124:no data
[ 2011.339139] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0xef inb 0
[ 2011.339141] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D23 CI=3D22
[ 2011.352408] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D23 PI=3D24=20
msgHeader=3D8100200d
[ 2011.352409] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.352410] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.352411] pm80xx mpi_sata_completion 2106:SAS_PROTO_RESPONSE len =3D=
 20
[ 2011.352412] pm80xx mpi_sata_completion 2121:other len =3D 20
[ 2011.352417] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D24 PI=3D24
[ 2011.352593] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.352593] pm80xx pm80xx_chip_sata_req 4131:PIO
[ 2011.352595] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0xec inb 0
[ 2011.352596] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D24 CI=3D23
[ 2011.354174] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D24 PI=3D25=20
msgHeader=3D8100200d
[ 2011.354175] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.354176] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.354179] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D25 PI=3D25
[ 2011.354220] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.354220] pm80xx pm80xx_chip_sata_req 4124:no data
[ 2011.354221] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x27 inb 0
[ 2011.354223] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D25 CI=3D24
[ 2011.381682] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D25 PI=3D26=20
msgHeader=3D8100200d
[ 2011.381683] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.381684] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.381685] pm80xx mpi_sata_completion 2106:SAS_PROTO_RESPONSE len =3D=
 20
[ 2011.381686] pm80xx mpi_sata_completion 2121:other len =3D 20
[ 2011.381691] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D26 PI=3D26
[ 2011.383080] ata5.00: configured for UDMA/133
[ 2011.383105] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=20
tries: 1
[ 2011.398371] scsi 5:0:0:0: Direct-Access     ATA ST3250310NS      SN0=
6=20
PQ: 0 ANSI: 5
[ 2011.400603] sd 5:0:0:0: [sdb] 488397168 512-byte logical blocks: (25=
0=20
GB/232 GiB)
[ 2011.400659] sd 5:0:0:0: [sdb] Write Protect is off
[ 2011.400662] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 2011.400686] sd 5:0:0:0: [sdb] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[ 2011.401337] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.401337] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.401338] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.401340] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.401342] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D26 CI=3D25
[ 2011.401615] sd 5:0:0:0: Attached scsi generic sg4 type 0
[ 2011.408942] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D26 PI=3D27=20
msgHeader=3D8100200d
[ 2011.408944] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.408945] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.408948] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D27 PI=3D27
[ 2011.409272] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.409272] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.409273] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.409275] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.409277] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D27 CI=3D26
[ 2011.409817] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D27 PI=3D28=20
msgHeader=3D8100200d
[ 2011.409819] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.409821] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.409829] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D28 PI=3D28
[ 2011.410198] sd 5:0:0:0: [sdb] Attached SCSI disk
[ 2011.412955] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.412956] pm80xx pm80xx_chip_sata_req 4131:PIO
[ 2011.412957] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0xec inb 0
[ 2011.412960] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D28 CI=3D27
[ 2011.415231] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D28 PI=3D29=20
msgHeader=3D8100200d
[ 2011.415233] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.415234] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.415239] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D29 PI=3D29
[ 2011.417457] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.417458] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.417458] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.417460] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.417462] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D29 CI=3D28
[ 2011.436519] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D29 PI=3D30=20
msgHeader=3D8100200d
[ 2011.436520] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.436522] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.436526] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D30 PI=3D30
[ 2011.436576] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.436576] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.436577] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.436579] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.436581] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D30 CI=3D29
[ 2011.438396] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D30 PI=3D31=20
msgHeader=3D8100200d
[ 2011.438397] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.438398] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.438403] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D31 PI=3D31
[ 2011.438431] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.438431] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.438432] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.438433] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.438435] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D31 CI=3D30
[ 2011.440110] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D31 PI=3D32=20
msgHeader=3D8100200d
[ 2011.440111] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.440113] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.440115] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D32 PI=3D32
[ 2011.440142] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.440142] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.440143] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.440144] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.440146] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D32 CI=3D31
[ 2011.440416] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D32 PI=3D33=20
msgHeader=3D8100200d
[ 2011.440417] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.440418] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.440421] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D33 PI=3D33
[ 2011.440447] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.440447] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.440448] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.440449] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.440451] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D33 CI=3D32
[ 2011.440888] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D33 PI=3D34=20
msgHeader=3D8100200d
[ 2011.440889] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.440890] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.440892] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D34 PI=3D34
[ 2011.440916] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.440916] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.440917] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.440918] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.440919] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D34 CI=3D33
[ 2011.441559] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D34 PI=3D35=20
msgHeader=3D8100200d
[ 2011.441559] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.441560] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.441564] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D35 PI=3D35
[ 2011.441597] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.441597] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.441598] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.441599] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.441601] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D35 CI=3D34
[ 2011.441708] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D35 PI=3D36=20
msgHeader=3D8100200d
[ 2011.441709] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.441710] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.441712] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D36 PI=3D36
[ 2011.441734] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.441735] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.441735] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.441737] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.441738] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D36 CI=3D35
[ 2011.441834] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D36 PI=3D37=20
msgHeader=3D8100200d
[ 2011.441834] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.441835] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.441838] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D37 PI=3D37
[ 2011.441864] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.441864] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.441865] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.441866] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.441868] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D37 CI=3D36
[ 2011.450555] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D37 PI=3D38=20
msgHeader=3D8100200d
[ 2011.450556] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.450557] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.450560] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D38 PI=3D38
[ 2011.450583] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.450584] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.450585] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.450586] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.450587] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D38 CI=3D37
[ 2011.451812] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D38 PI=3D39=20
msgHeader=3D8100200d
[ 2011.451813] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.451814] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.451817] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D39 PI=3D39
[ 2011.451842] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.451842] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.451843] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.451844] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.451846] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D39 CI=3D38
[ 2011.452152] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D39 PI=3D40=20
msgHeader=3D8100200d
[ 2011.452153] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.452154] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.452156] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D40 PI=3D40
[ 2011.452179] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.452179] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.452180] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.452181] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.452183] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D40 CI=3D39
[ 2011.452447] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D40 PI=3D41=20
msgHeader=3D8100200d
[ 2011.452448] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.452449] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.452452] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D41 PI=3D41
[ 2011.452476] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.452477] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.452477] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.452479] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.452480] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D41 CI=3D40
[ 2011.452751] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D41 PI=3D42=20
msgHeader=3D8100200d
[ 2011.452752] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.452752] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.452755] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D42 PI=3D42
[ 2011.452779] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.452779] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.452780] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.452781] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.452783] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D42 CI=3D41
[ 2011.453016] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D42 PI=3D43=20
msgHeader=3D8100200d
[ 2011.453017] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.453018] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.453021] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D43 PI=3D43
[ 2011.453045] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.453045] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.453046] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.453047] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.453049] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D43 CI=3D42
[ 2011.453299] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D43 PI=3D44=20
msgHeader=3D8100200d
[ 2011.453300] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.453301] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.453303] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D44 PI=3D44
[ 2011.453325] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.453325] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.453326] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.453327] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.453329] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D44 CI=3D43
[ 2011.453582] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D44 PI=3D45=20
msgHeader=3D8100200d
[ 2011.453583] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.453584] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.453587] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D45 PI=3D45
[ 2011.453610] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.453611] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.453612] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.453613] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.453614] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D45 CI=3D44
[ 2011.458735] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D45 PI=3D46=20
msgHeader=3D8100200d
[ 2011.458736] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.458737] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.458739] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D46 PI=3D46
[ 2011.458799] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.458799] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.458800] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.458801] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.458803] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D46 CI=3D45
[ 2011.475256] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D46 PI=3D47=20
msgHeader=3D8100200d
[ 2011.475257] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.475258] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.475262] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D47 PI=3D47
[ 2011.482054] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.482054] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.482055] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.482057] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.482059] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D47 CI=3D46
[ 2011.482321] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D47 PI=3D48=20
msgHeader=3D8100200d
[ 2011.482322] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.482323] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.482325] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D48 PI=3D48
[ 2011.482355] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.482355] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.482356] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.482357] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.482359] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D48 CI=3D47
[ 2011.482664] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D48 PI=3D49=20
msgHeader=3D8100200d
[ 2011.482665] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.482666] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.482670] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D49 PI=3D49
[ 2011.482697] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.482697] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.482698] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.482699] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.482701] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D49 CI=3D48
[ 2011.483015] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D49 PI=3D50=20
msgHeader=3D8100200d
[ 2011.483016] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.483017] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.483020] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D50 PI=3D50
[ 2011.483048] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.483048] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.483049] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.483050] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.483052] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D50 CI=3D49
[ 2011.483359] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D50 PI=3D51=20
msgHeader=3D8100200d
[ 2011.483360] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.483361] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.483364] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D51 PI=3D51
[ 2011.483394] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.483394] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.483395] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.483396] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.483398] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D51 CI=3D50
[ 2011.483709] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D51 PI=3D52=20
msgHeader=3D8100200d
[ 2011.483709] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.483710] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.483713] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D52 PI=3D52
[ 2011.483737] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.483737] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.483738] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.483739] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.483741] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D52 CI=3D51
[ 2011.484054] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D52 PI=3D53=20
msgHeader=3D8100200d
[ 2011.484055] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.484056] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.484059] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D53 PI=3D53
[ 2011.484086] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.484087] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.484088] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.484089] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.484090] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D53 CI=3D52
[ 2011.484434] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D53 PI=3D54=20
msgHeader=3D8100200d
[ 2011.484435] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.484436] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.484438] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D54 PI=3D54
[ 2011.484460] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.484460] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.484461] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.484462] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.484464] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D54 CI=3D53
[ 2011.484744] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D54 PI=3D55=20
msgHeader=3D8100200d
[ 2011.484745] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.484746] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.484749] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D55 PI=3D55
[ 2011.484774] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.484774] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.484775] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.484776] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.484778] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D55 CI=3D54
[ 2011.485052] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D55 PI=3D56=20
msgHeader=3D8100200d
[ 2011.485053] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.485054] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.485056] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D56 PI=3D56
[ 2011.485079] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.485080] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.485080] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.485082] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.485083] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D56 CI=3D55
[ 2011.485342] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D56 PI=3D57=20
msgHeader=3D8100200d
[ 2011.485343] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.485344] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.485347] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D57 PI=3D57
[ 2011.485371] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.485371] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.485372] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.485373] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.485374] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D57 CI=3D56
[ 2011.485632] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D57 PI=3D58=20
msgHeader=3D8100200d
[ 2011.485633] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.485634] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.485636] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D58 PI=3D58
[ 2011.485658] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.485658] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.485659] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.485660] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.485662] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D58 CI=3D57
[ 2011.485938] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D58 PI=3D59=20
msgHeader=3D8100200d
[ 2011.485939] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.485940] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.485943] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D59 PI=3D59
[ 2011.485967] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.485967] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.485968] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.485969] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.485971] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D59 CI=3D58
[ 2011.486230] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D59 PI=3D60=20
msgHeader=3D8100200d
[ 2011.486231] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.486232] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.486234] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D60 PI=3D60
[ 2011.486257] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.486257] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.486258] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.486259] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.486261] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D60 CI=3D59
[ 2011.486536] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D60 PI=3D61=20
msgHeader=3D8100200d
[ 2011.486536] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.486537] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.486541] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D61 PI=3D61
[ 2011.486564] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.486564] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.486565] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.486566] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.486568] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D61 CI=3D60
[ 2011.486825] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D61 PI=3D62=20
msgHeader=3D8100200d
[ 2011.486826] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.486826] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.486828] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D62 PI=3D62
[ 2011.486850] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.486850] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.486851] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.486852] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.486854] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D62 CI=3D61
[ 2011.487113] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D62 PI=3D63=20
msgHeader=3D8100200d
[ 2011.487114] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.487115] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.487118] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D63 PI=3D63
[ 2011.487142] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.487142] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.487143] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.487144] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.487146] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D63 CI=3D62
[ 2011.487419] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D63 PI=3D64=20
msgHeader=3D8100200d
[ 2011.487420] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.487421] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.487423] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D64 PI=3D64
[ 2011.487445] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.487445] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.487446] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.487447] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.487449] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D64 CI=3D63
[ 2011.487707] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D64 PI=3D65=20
msgHeader=3D8100200d
[ 2011.487708] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.487709] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.487712] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D65 PI=3D65
[ 2011.487735] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.487736] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.487736] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.487738] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.487739] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D65 CI=3D64
[ 2011.487997] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D65 PI=3D66=20
msgHeader=3D8100200d
[ 2011.487998] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.487999] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.488001] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D66 PI=3D66
[ 2011.488029] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.488030] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.488030] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.488032] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.488033] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D66 CI=3D65
[ 2011.488305] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D66 PI=3D67=20
msgHeader=3D8100200d
[ 2011.488306] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.488307] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.488310] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D67 PI=3D67
[ 2011.488334] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.488334] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.488335] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.488336] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.488338] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D67 CI=3D66
[ 2011.488596] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D67 PI=3D68=20
msgHeader=3D8100200d
[ 2011.488597] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.488598] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.488600] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D68 PI=3D68
[ 2011.488622] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.488622] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.488623] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.488624] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.488626] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D68 CI=3D67
[ 2011.488900] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D68 PI=3D69=20
msgHeader=3D8100200d
[ 2011.488901] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.488902] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.488905] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D69 PI=3D69
[ 2011.488930] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.488931] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.488931] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.488933] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.488934] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D69 CI=3D68
[ 2011.489191] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D69 PI=3D70=20
msgHeader=3D8100200d
[ 2011.489192] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.489193] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.489195] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D70 PI=3D70
[ 2011.489219] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.489220] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.489220] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.489222] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.489223] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D70 CI=3D69
[ 2011.489479] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D70 PI=3D71=20
msgHeader=3D8100200d
[ 2011.489480] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.489481] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.489484] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D71 PI=3D71
[ 2011.489509] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.489509] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.489510] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.489511] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.489513] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D71 CI=3D70
[ 2011.489785] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D71 PI=3D72=20
msgHeader=3D8100200d
[ 2011.489786] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.489787] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.489789] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D72 PI=3D72
[ 2011.489812] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.489812] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.489813] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.489814] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.489816] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D72 CI=3D71
[ 2011.490074] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D72 PI=3D73=20
msgHeader=3D8100200d
[ 2011.490074] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.490075] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.490079] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D73 PI=3D73
[ 2011.490104] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.490104] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.490105] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.490106] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.490108] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D73 CI=3D72
[ 2011.490362] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D73 PI=3D74=20
msgHeader=3D8100200d
[ 2011.490363] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.490364] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.490366] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D74 PI=3D74
[ 2011.490389] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.490389] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.490390] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.490391] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.490393] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D74 CI=3D73
[ 2011.490667] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D74 PI=3D75=20
msgHeader=3D8100200d
[ 2011.490668] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.490669] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.490672] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D75 PI=3D75
[ 2011.490697] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.490697] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.490698] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.490699] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.490701] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D75 CI=3D74
[ 2011.490958] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D75 PI=3D76=20
msgHeader=3D8100200d
[ 2011.490959] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.490960] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.490962] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D76 PI=3D76
[ 2011.490984] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.490985] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.490985] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.490987] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.490988] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D76 CI=3D75
[ 2011.491245] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D76 PI=3D77=20
msgHeader=3D8100200d
[ 2011.491246] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.491247] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.491250] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D77 PI=3D77
[ 2011.491275] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.491275] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.491276] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.491277] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.491279] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D77 CI=3D76
[ 2011.491551] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D77 PI=3D78=20
msgHeader=3D8100200d
[ 2011.491552] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.491553] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.491555] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D78 PI=3D78
[ 2011.491577] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.491577] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.491578] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.491579] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.491581] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D78 CI=3D77
[ 2011.491840] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D78 PI=3D79=20
msgHeader=3D8100200d
[ 2011.491841] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.491842] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.491845] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D79 PI=3D79
[ 2011.491869] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.491869] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.491870] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.491871] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.491873] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D79 CI=3D78
[ 2011.492130] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D79 PI=3D80=20
msgHeader=3D8100200d
[ 2011.492131] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.492132] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.492134] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D80 PI=3D80
[ 2011.492158] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.492158] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.492159] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.492160] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.492162] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D80 CI=3D79
[ 2011.492435] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D80 PI=3D81=20
msgHeader=3D8100200d
[ 2011.492435] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.492436] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.492440] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D81 PI=3D81
[ 2011.492464] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.492464] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.492465] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.492466] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.492468] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D81 CI=3D80
[ 2011.492725] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D81 PI=3D82=20
msgHeader=3D8100200d
[ 2011.492726] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.492726] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.492729] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D82 PI=3D82
[ 2011.492751] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.492752] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.492752] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.492754] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.492755] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D82 CI=3D81
[ 2011.493013] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D82 PI=3D83=20
msgHeader=3D8100200d
[ 2011.493014] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.493015] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.493018] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D83 PI=3D83
[ 2011.493045] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.493045] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.493046] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.493047] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.493049] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D83 CI=3D82
[ 2011.493320] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D83 PI=3D84=20
msgHeader=3D8100200d
[ 2011.493321] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.493322] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.493324] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D84 PI=3D84
[ 2011.493346] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.493346] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.493347] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.493348] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.493350] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D84 CI=3D83
[ 2011.493611] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D84 PI=3D85=20
msgHeader=3D8100200d
[ 2011.493611] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.493612] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.493615] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D85 PI=3D85
[ 2011.493644] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.493644] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.493645] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.493646] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.493648] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D85 CI=3D84
[ 2011.493957] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D85 PI=3D86=20
msgHeader=3D8100200d
[ 2011.493957] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.493958] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.493960] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D86 PI=3D86
[ 2011.493983] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.493983] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.493984] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.493985] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.493987] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D86 CI=3D85
[ 2011.494246] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D86 PI=3D87=20
msgHeader=3D8100200d
[ 2011.494247] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.494248] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.494251] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D87 PI=3D87
[ 2011.494275] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.494275] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.494276] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.494277] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.494279] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D87 CI=3D86
[ 2011.494554] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D87 PI=3D88=20
msgHeader=3D8100200d
[ 2011.494555] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.494556] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.494558] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D88 PI=3D88
[ 2011.494580] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.494581] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.494581] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.494583] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.494584] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D88 CI=3D87
[ 2011.494842] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D88 PI=3D89=20
msgHeader=3D8100200d
[ 2011.494843] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.494844] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.494847] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D89 PI=3D89
[ 2011.494870] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.494871] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.494871] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.494872] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.494874] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D89 CI=3D88
[ 2011.495149] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D89 PI=3D90=20
msgHeader=3D8100200d
[ 2011.495150] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.495151] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.495153] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D90 PI=3D90
[ 2011.495176] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.495176] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.495177] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.495178] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.495180] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D90 CI=3D89
[ 2011.495437] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D90 PI=3D91=20
msgHeader=3D8100200d
[ 2011.495438] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.495439] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.495442] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D91 PI=3D91
[ 2011.495466] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.495466] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.495467] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.495468] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.495470] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D91 CI=3D90
[ 2011.495727] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D91 PI=3D92=20
msgHeader=3D8100200d
[ 2011.495728] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.495729] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.495731] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D92 PI=3D92
[ 2011.495754] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.495754] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.495755] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.495756] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.495758] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D92 CI=3D91
[ 2011.496032] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D92 PI=3D93=20
msgHeader=3D8100200d
[ 2011.496032] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.496033] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.496037] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D93 PI=3D93
[ 2011.496062] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.496062] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.496063] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.496064] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.496066] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D93 CI=3D92
[ 2011.496321] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D93 PI=3D94=20
msgHeader=3D8100200d
[ 2011.496322] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.496323] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.496325] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D94 PI=3D94
[ 2011.496348] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.496348] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.496349] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.496350] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.496352] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D94 CI=3D93
[ 2011.496608] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D94 PI=3D95=20
msgHeader=3D8100200d
[ 2011.496609] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.496610] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.496613] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D95 PI=3D95
[ 2011.496637] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.496638] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.496638] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.496640] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.496641] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D95 CI=3D94
[ 2011.496916] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D95 PI=3D96=20
msgHeader=3D8100200d
[ 2011.496917] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.496917] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.496920] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D96 PI=3D96
[ 2011.496944] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.496944] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.496945] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.496946] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.496948] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D96 CI=3D95
[ 2011.497204] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D96 PI=3D97=20
msgHeader=3D8100200d
[ 2011.497205] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.497206] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.497209] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D97 PI=3D97
[ 2011.497235] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.497235] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.497236] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.497237] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.497239] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D97 CI=3D96
[ 2011.497493] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D97 PI=3D98=20
msgHeader=3D8100200d
[ 2011.497494] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.497494] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.497497] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D98 PI=3D98
[ 2011.497518] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.497519] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.497520] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.497521] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.497522] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D98 CI=3D97
[ 2011.497798] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D98 PI=3D99=20
msgHeader=3D8100200d
[ 2011.497799] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.497800] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.497803] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D99 PI=3D99
[ 2011.497827] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.497827] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.497828] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.497829] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.497830] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D99 CI=3D98
[ 2011.498088] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D99 PI=3D100=20
msgHeader=3D8100200d
[ 2011.498088] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.498089] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.498092] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D100 PI=3D100
[ 2011.498116] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.498116] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.498117] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.498118] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.498120] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D100 CI=3D99
[ 2011.498375] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D100 PI=3D101=20
msgHeader=3D8100200d
[ 2011.498376] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.498377] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.498381] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D101 PI=3D101
[ 2011.498405] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.498405] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.498406] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.498407] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.498409] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D101 CI=3D100
[ 2011.498682] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D101 PI=3D102=20
msgHeader=3D8100200d
[ 2011.498683] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.498683] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.498686] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D102 PI=3D102
[ 2011.498708] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.498709] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.498709] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.498711] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.498712] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D102 CI=3D101
[ 2011.498969] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D102 PI=3D103=20
msgHeader=3D8100200d
[ 2011.498970] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.498971] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.498974] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D103 PI=3D103
[ 2011.498999] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.498999] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.499000] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.499001] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.499003] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D103 CI=3D102
[ 2011.499260] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D103 PI=3D104=20
msgHeader=3D8100200d
[ 2011.499261] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.499262] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.499264] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D104 PI=3D104
[ 2011.499288] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.499288] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.499289] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.499290] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.499292] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D104 CI=3D103
[ 2011.499565] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D104 PI=3D105=20
msgHeader=3D8100200d
[ 2011.499566] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.499567] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.499570] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D105 PI=3D105
[ 2011.499595] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.499595] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.499596] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.499597] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.499599] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D105 CI=3D104
[ 2011.499858] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D105 PI=3D106=20
msgHeader=3D8100200d
[ 2011.499859] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.499860] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.499862] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D106 PI=3D106
[ 2011.499885] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.499885] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.499886] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.499887] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.499889] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D106 CI=3D105
[ 2011.500145] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D106 PI=3D107=20
msgHeader=3D8100200d
[ 2011.500146] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.500147] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.500150] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D107 PI=3D107
[ 2011.500175] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.500176] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.500176] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.500178] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.500179] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D107 CI=3D106
[ 2011.500455] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D107 PI=3D108=20
msgHeader=3D8100200d
[ 2011.500455] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.500456] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.500458] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D108 PI=3D108
[ 2011.500480] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.500480] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.500481] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.500482] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.500484] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D108 CI=3D107
[ 2011.500742] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D108 PI=3D109=20
msgHeader=3D8100200d
[ 2011.500743] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.500744] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.500747] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D109 PI=3D109
[ 2011.500771] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.500771] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.500772] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.500773] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.500775] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D109 CI=3D108
[ 2011.501052] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D109 PI=3D110=20
msgHeader=3D8100200d
[ 2011.501053] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.501054] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.501057] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D110 PI=3D110
[ 2011.501082] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.501082] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.501083] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.501084] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.501086] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D110 CI=3D109
[ 2011.501342] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D110 PI=3D111=20
msgHeader=3D8100200d
[ 2011.501343] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.501344] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.501347] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D111 PI=3D111
[ 2011.501371] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.501371] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.501372] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.501373] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.501375] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D111 CI=3D110
[ 2011.501649] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D111 PI=3D112=20
msgHeader=3D8100200d
[ 2011.501650] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.501651] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.501653] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D112 PI=3D112
[ 2011.501676] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.501676] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.501677] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.501678] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.501680] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D112 CI=3D111
[ 2011.501936] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D112 PI=3D113=20
msgHeader=3D8100200d
[ 2011.501937] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.501938] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.501940] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D113 PI=3D113
[ 2011.501969] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.501970] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.501970] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.501972] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.501973] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D113 CI=3D112
[ 2011.502228] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D113 PI=3D114=20
msgHeader=3D8100200d
[ 2011.502228] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.502229] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.502232] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D114 PI=3D114
[ 2011.502256] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.502257] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.502257] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.502259] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.502260] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D114 CI=3D113
[ 2011.502535] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D114 PI=3D115=20
msgHeader=3D8100200d
[ 2011.502536] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.502537] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.502540] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D115 PI=3D115
[ 2011.502565] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.502565] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.502566] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.502567] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.502569] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D115 CI=3D114
[ 2011.502826] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D115 PI=3D116=20
msgHeader=3D8100200d
[ 2011.502827] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.502828] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.502830] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D116 PI=3D116
[ 2011.502853] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.502854] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.502854] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.502855] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.502857] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D116 CI=3D115
[ 2011.503141] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D116 PI=3D117=20
msgHeader=3D8100200d
[ 2011.503142] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.503143] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.503146] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D117 PI=3D117
[ 2011.503190] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.503190] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.503191] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.503192] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.503194] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D117 CI=3D116
[ 2011.503521] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D117 PI=3D118=20
msgHeader=3D8100200d
[ 2011.503521] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.503522] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.503524] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D118 PI=3D118
[ 2011.503550] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.503551] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.503552] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.503553] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.503555] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D118 CI=3D117
[ 2011.503831] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D118 PI=3D119=20
msgHeader=3D8100200d
[ 2011.503832] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.503833] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.503836] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D119 PI=3D119
[ 2011.503871] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.503871] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.503872] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.503873] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.503875] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D119 CI=3D118
[ 2011.507426] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D119 PI=3D120=20
msgHeader=3D8100200d
[ 2011.507427] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.507428] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.507430] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D120 PI=3D120
[ 2011.507472] pm80xx pm8001_task_exec 374:pm8001_task_exec device

[ 2011.507472] pm80xx pm80xx_chip_sata_req 4128:DMA
[ 2011.507473] pm80xx pm80xx_chip_sata_req 4136:FPDMA
[ 2011.507474] pm80xx pm80xx_chip_sata_req 4226:Sending Normal SATA=20
command 0x60 inb 0
[ 2011.507476] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:17 ,=20
UPDATED PI=3D120 CI=3D119
[ 2011.508186] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D120 PI=3D121=20
msgHeader=3D8100200d
[ 2011.508187] pm80xx process_one_iomb 3557:OPC_OUB_SATA_COMP
[ 2011.508188] pm80xx mpi_sata_completion 2082:IO_SUCCESS
[ 2011.508191] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D121 PI=3D121
[ 2041.921825] ------------[ cut here ]------------
[ 2041.921837] WARNING: CPU: 0 PID: 59 at fs/sysfs/group.c:224=20
sysfs_remove_group+0x8d/0x90()
[ 2041.921841] sysfs group ffffffff81cce480 not found for kobject=20
'end_device-5:0'
[ 2041.921843] Modules linked in: pm80xx(OE-) libsas scsi_transport_sas=
=20
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc=20
ebtable_nat fscache bnep bluetooth iptable_mangle nf_conntrack_ipv4=20
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables=20
ip6table_filter ip6_tables ppdev snd_hda_codec_realtek=20
snd_hda_codec_generic snd_hda_intel snd_hda_codec hp_wmi tg3=20
sparse_keymap pcspkr iTCO_wdt iTCO_vendor_support lpc_ich snd_hda_core=20
serio_raw snd_hwdep snd_seq snd_seq_device snd_pcm rfkill i5000_edac=20
mfd_core edac_core i5k_amb snd_timer snd ptp soundcore shpchp ses=20
pps_core enclosure parport_pc wmi parport acpi_cpufreq uinput esas2r
[ 2041.921900] CPU: 0 PID: 59 Comm: kworker/u16:1 Tainted: G          =20
OE   4.3.0-rc1+ #2
[ 2041.921902] Hardware name: Hewlett-Packard HP xw6400=20
Workstation/0A04h, BIOS 786D4 v02.24 07/06/2007
[ 2041.921913] Workqueue: scsi_wq_5 sas_destruct_devices [libsas]
[ 2041.921915]  ffffffff81a525ce ffff8800d934bc60 ffffffff8135f978=20
ffff8800d934bca8
[ 2041.921919]  ffff8800d934bc98 ffffffff81090f48 0000000000000000=20
ffffffff81cce480
[ 2041.921922]  ffff8800dac59810 ffff880119c7f400 ffff8801194dbe18=20
ffff8800d934bcf8
[ 2041.921925] Call Trace:
[ 2041.921931]  [<ffffffff8135f978>] dump_stack+0x44/0x5c
[ 2041.921936]  [<ffffffff81090f48>] warn_slowpath_common+0x88/0xc0
[ 2041.921938]  [<ffffffff81090fcc>] warn_slowpath_fmt+0x4c/0x50
[ 2041.921943]  [<ffffffff81268878>] ? kernfs_find_and_get_ns+0x48/0x60
[ 2041.921946]  [<ffffffff8126bcfd>] sysfs_remove_group+0x8d/0x90
[ 2041.921951]  [<ffffffff81487177>] dpm_sysfs_remove+0x57/0x60
[ 2041.921954]  [<ffffffff8147b379>] device_del+0x49/0x240
[ 2041.921959]  [<ffffffff814a49e6>] ? scsi_device_get+0x56/0x60
[ 2041.921962]  [<ffffffff8147b58e>] device_unregister+0x1e/0x60
[ 2041.921965]  [<ffffffff8134db1e>] bsg_unregister_queue+0x5e/0xa0
[ 2041.921972]  [<ffffffffa0307019>] sas_rphy_remove+0x49/0x80=20
[scsi_transport_sas]
[ 2041.921976]  [<ffffffffa0307062>] sas_rphy_delete+0x12/0x20=20
[scsi_transport_sas]
[ 2041.921981]  [<ffffffffa03e873d>] sas_destruct_devices+0x6d/0x90 [li=
bsas]
[ 2041.921986]  [<ffffffff810a7b97>] process_one_work+0x147/0x3c0
[ 2041.921988]  [<ffffffff810a81f4>] worker_thread+0x114/0x460
[ 2041.921991]  [<ffffffff810a80e0>] ? rescuer_thread+0x2d0/0x2d0
[ 2041.921995]  [<ffffffff810ad372>] kthread+0xd2/0xf0
[ 2041.921998]  [<ffffffff810ad2a0>] ? kthread_park+0x50/0x50
[ 2041.922002]  [<ffffffff816f9a9f>] ret_from_fork+0x3f/0x70
[ 2041.922026]  [<ffffffff810ad2a0>] ? kthread_park+0x50/0x50
[ 2041.922029] ---[ end trace f3d195aaffcdb43a ]---
[ 2041.922090] ------------[ cut here ]------------
[ 2041.922094] WARNING: CPU: 0 PID: 59 at fs/sysfs/group.c:224=20
sysfs_remove_group+0x8d/0x90()
[ 2041.922096] sysfs group ffffffff81cce480 not found for kobject=20
'end_device-5:0'
[ 2041.922098] Modules linked in: pm80xx(OE-) libsas scsi_transport_sas=
=20
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc=20
ebtable_nat fscache bnep bluetooth iptable_mangle nf_conntrack_ipv4=20
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables=20
ip6table_filter ip6_tables ppdev snd_hda_codec_realtek=20
snd_hda_codec_generic snd_hda_intel snd_hda_codec hp_wmi tg3=20
sparse_keymap pcspkr iTCO_wdt iTCO_vendor_support lpc_ich snd_hda_core=20
serio_raw snd_hwdep snd_seq snd_seq_device snd_pcm rfkill i5000_edac=20
mfd_core edac_core i5k_amb snd_timer snd ptp soundcore shpchp ses=20
pps_core enclosure parport_pc wmi parport acpi_cpufreq uinput esas2r
[ 2041.922140] CPU: 0 PID: 59 Comm: kworker/u16:1 Tainted: G        W =20
OE   4.3.0-rc1+ #2
[ 2041.922142] Hardware name: Hewlett-Packard HP xw6400=20
Workstation/0A04h, BIOS 786D4 v02.24 07/06/2007
[ 2041.922147] Workqueue: scsi_wq_5 sas_destruct_devices [libsas]
[ 2041.922149]  ffffffff81a525ce ffff8800d934bc08 ffffffff8135f978=20
ffff8800d934bc50
[ 2041.922152]  ffff8800d934bc40 ffffffff81090f48 0000000000000000=20
ffffffff81cce480
[ 2041.922156]  ffff880119c7a838 ffff880119c7f400 ffff8801194dbe18=20
ffff8800d934bca0
[ 2041.922159] Call Trace:
[ 2041.922162]  [<ffffffff8135f978>] dump_stack+0x44/0x5c
[ 2041.922165]  [<ffffffff81090f48>] warn_slowpath_common+0x88/0xc0
[ 2041.922167]  [<ffffffff81090fcc>] warn_slowpath_fmt+0x4c/0x50
[ 2041.922171]  [<ffffffff81268878>] ? kernfs_find_and_get_ns+0x48/0x60
[ 2041.922173]  [<ffffffff8126bcfd>] sysfs_remove_group+0x8d/0x90
[ 2041.922176]  [<ffffffff81487177>] dpm_sysfs_remove+0x57/0x60
[ 2041.922179]  [<ffffffff8147b379>] device_del+0x49/0x240
[ 2041.922181]  [<ffffffff8147aa49>] ? device_remove_file+0x19/0x20
[ 2041.922185]  [<ffffffff8148427a>]=20
attribute_container_class_device_del+0x1a/0x20
[ 2041.922187]  [<ffffffff8148447e>] transport_remove_classdev+0x4e/0x6=
0
[ 2041.922190]  [<ffffffff81484430>] ? transport_add_class_device+0x40/=
0x40
[ 2041.922193]  [<ffffffff81483e80>]=20
attribute_container_device_trigger+0xb0/0xc0
[ 2041.922196]  [<ffffffff814843e5>] transport_remove_device+0x15/0x20
[ 2041.922200]  [<ffffffffa0307021>] sas_rphy_remove+0x51/0x80=20
[scsi_transport_sas]
[ 2041.922204]  [<ffffffffa0307062>] sas_rphy_delete+0x12/0x20=20
[scsi_transport_sas]
[ 2041.922209]  [<ffffffffa03e873d>] sas_destruct_devices+0x6d/0x90 [li=
bsas]
[ 2041.922212]  [<ffffffff810a7b97>] process_one_work+0x147/0x3c0
[ 2041.922214]  [<ffffffff810a81f4>] worker_thread+0x114/0x460
[ 2041.922217]  [<ffffffff810a80e0>] ? rescuer_thread+0x2d0/0x2d0
[ 2041.922220]  [<ffffffff810ad372>] kthread+0xd2/0xf0
[ 2041.922223]  [<ffffffff810ad2a0>] ? kthread_park+0x50/0x50
[ 2041.922225]  [<ffffffff816f9a9f>] ret_from_fork+0x3f/0x70
[ 2041.922228]  [<ffffffff810ad2a0>] ? kthread_park+0x50/0x50
[ 2041.922231] ---[ end trace f3d195aaffcdb43b ]---
[ 2041.922247] ------------[ cut here ]------------
[ 2041.922251] WARNING: CPU: 0 PID: 59 at fs/sysfs/group.c:224=20
sysfs_remove_group+0x8d/0x90()
[ 2041.922253] sysfs group ffffffff81cce480 not found for kobject=20
'end_device-5:0'
[ 2041.922254] Modules linked in: pm80xx(OE-) libsas scsi_transport_sas=
=20
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc=20
ebtable_nat fscache bnep bluetooth iptable_mangle nf_conntrack_ipv4=20
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables=20
ip6table_filter ip6_tables ppdev snd_hda_codec_realtek=20
snd_hda_codec_generic snd_hda_intel snd_hda_codec hp_wmi tg3=20
sparse_keymap pcspkr iTCO_wdt iTCO_vendor_support lpc_ich snd_hda_core=20
serio_raw snd_hwdep snd_seq snd_seq_device snd_pcm rfkill i5000_edac=20
mfd_core edac_core i5k_amb snd_timer snd ptp soundcore shpchp ses=20
pps_core enclosure parport_pc wmi parport acpi_cpufreq uinput esas2r
[ 2041.922295] CPU: 0 PID: 59 Comm: kworker/u16:1 Tainted: G        W =20
OE   4.3.0-rc1+ #2
[ 2041.922297] Hardware name: Hewlett-Packard HP xw6400=20
Workstation/0A04h, BIOS 786D4 v02.24 07/06/2007
[ 2041.922302] Workqueue: scsi_wq_5 sas_destruct_devices [libsas]
[ 2041.922303]  ffffffff81a525ce ffff8800d934bc08 ffffffff8135f978=20
ffff8800d934bc50
[ 2041.922307]  ffff8800d934bc40 ffffffff81090f48 0000000000000000=20
ffffffff81cce480
[ 2041.922310]  ffff8800d24e7838 ffff880119c7f400 ffff8801194dbe18=20
ffff8800d934bca0
[ 2041.922313] Call Trace:
[ 2041.922316]  [<ffffffff8135f978>] dump_stack+0x44/0x5c
[ 2041.922319]  [<ffffffff81090f48>] warn_slowpath_common+0x88/0xc0
[ 2041.922321]  [<ffffffff81090fcc>] warn_slowpath_fmt+0x4c/0x50
[ 2041.922325]  [<ffffffff81268878>] ? kernfs_find_and_get_ns+0x48/0x60
[ 2041.922327]  [<ffffffff8126bcfd>] sysfs_remove_group+0x8d/0x90
[ 2041.922330]  [<ffffffff81487177>] dpm_sysfs_remove+0x57/0x60
[ 2041.922333]  [<ffffffff8147b379>] device_del+0x49/0x240
[ 2041.922335]  [<ffffffff8147aa49>] ? device_remove_file+0x19/0x20
[ 2041.922338]  [<ffffffff8148427a>]=20
attribute_container_class_device_del+0x1a/0x20
[ 2041.922340]  [<ffffffff8148447e>] transport_remove_classdev+0x4e/0x6=
0
[ 2041.922343]  [<ffffffff81484430>] ? transport_add_class_device+0x40/=
0x40
[ 2041.922345]  [<ffffffff81483e80>]=20
attribute_container_device_trigger+0xb0/0xc0
[ 2041.922348]  [<ffffffff814843e5>] transport_remove_device+0x15/0x20
[ 2041.922352]  [<ffffffffa0307021>] sas_rphy_remove+0x51/0x80=20
[scsi_transport_sas]
[ 2041.922356]  [<ffffffffa0307062>] sas_rphy_delete+0x12/0x20=20
[scsi_transport_sas]
[ 2041.922361]  [<ffffffffa03e873d>] sas_destruct_devices+0x6d/0x90 [li=
bsas]
[ 2041.922363]  [<ffffffff810a7b97>] process_one_work+0x147/0x3c0
[ 2041.922366]  [<ffffffff810a81f4>] worker_thread+0x114/0x460
[ 2041.922369]  [<ffffffff810a80e0>] ? rescuer_thread+0x2d0/0x2d0
[ 2041.922372]  [<ffffffff810ad372>] kthread+0xd2/0xf0
[ 2041.922375]  [<ffffffff810ad2a0>] ? kthread_park+0x50/0x50
[ 2041.922377]  [<ffffffff816f9a9f>] ret_from_fork+0x3f/0x70
[ 2041.922380]  [<ffffffff810ad2a0>] ? kthread_park+0x50/0x50
[ 2041.922382] ---[ end trace f3d195aaffcdb43c ]---
[ 2041.922396] ------------[ cut here ]------------
[ 2041.922399] WARNING: CPU: 0 PID: 59 at fs/sysfs/group.c:224=20
sysfs_remove_group+0x8d/0x90()
[ 2041.922401] sysfs group ffffffff81cce480 not found for kobject=20
'end_device-5:0'
[ 2041.922403] Modules linked in: pm80xx(OE-) libsas scsi_transport_sas=
=20
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc=20
ebtable_nat fscache bnep bluetooth iptable_mangle nf_conntrack_ipv4=20
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables=20
ip6table_filter ip6_tables ppdev snd_hda_codec_realtek=20
snd_hda_codec_generic snd_hda_intel snd_hda_codec hp_wmi tg3=20
sparse_keymap pcspkr iTCO_wdt iTCO_vendor_support lpc_ich snd_hda_core=20
serio_raw snd_hwdep snd_seq snd_seq_device snd_pcm rfkill i5000_edac=20
mfd_core edac_core i5k_amb snd_timer snd ptp soundcore shpchp ses=20
pps_core enclosure parport_pc wmi parport acpi_cpufreq uinput esas2r
[ 2041.922443] CPU: 0 PID: 59 Comm: kworker/u16:1 Tainted: G        W =20
OE   4.3.0-rc1+ #2
[ 2041.922445] Hardware name: Hewlett-Packard HP xw6400=20
Workstation/0A04h, BIOS 786D4 v02.24 07/06/2007
[ 2041.922450] Workqueue: scsi_wq_5 sas_destruct_devices [libsas]
[ 2041.922452]  ffffffff81a525ce ffff8800d934bc90 ffffffff8135f978=20
ffff8800d934bcd8
[ 2041.922455]  ffff8800d934bcc8 ffffffff81090f48 0000000000000000=20
ffffffff81cce480
[ 2041.922458]  ffff880119c7f410 ffff8800ce02e000 ffff8801194dbe18=20
ffff8800d934bd28
[ 2041.922461] Call Trace:
[ 2041.922464]  [<ffffffff8135f978>] dump_stack+0x44/0x5c
[ 2041.922467]  [<ffffffff81090f48>] warn_slowpath_common+0x88/0xc0
[ 2041.922470]  [<ffffffff81090fcc>] warn_slowpath_fmt+0x4c/0x50
[ 2041.922473]  [<ffffffff81268878>] ? kernfs_find_and_get_ns+0x48/0x60
[ 2041.922475]  [<ffffffff8126bcfd>] sysfs_remove_group+0x8d/0x90
[ 2041.922478]  [<ffffffff81487177>] dpm_sysfs_remove+0x57/0x60
[ 2041.922481]  [<ffffffff8147b379>] device_del+0x49/0x240
[ 2041.922485]  [<ffffffffa0307029>] sas_rphy_remove+0x59/0x80=20
[scsi_transport_sas]
[ 2041.922489]  [<ffffffffa0307062>] sas_rphy_delete+0x12/0x20=20
[scsi_transport_sas]
[ 2041.922493]  [<ffffffffa03e873d>] sas_destruct_devices+0x6d/0x90 [li=
bsas]
[ 2041.922496]  [<ffffffff810a7b97>] process_one_work+0x147/0x3c0
[ 2041.922499]  [<ffffffff810a81f4>] worker_thread+0x114/0x460
[ 2041.922502]  [<ffffffff810a80e0>] ? rescuer_thread+0x2d0/0x2d0
[ 2041.922505]  [<ffffffff810ad372>] kthread+0xd2/0xf0
[ 2041.922508]  [<ffffffff810ad2a0>] ? kthread_park+0x50/0x50
[ 2041.922510]  [<ffffffff816f9a9f>] ret_from_fork+0x3f/0x70
[ 2041.922513]  [<ffffffff810ad2a0>] ? kthread_park+0x50/0x50
[ 2041.922516] ---[ end trace f3d195aaffcdb43d ]---
[ 2041.922524] pm80xx pm8001_dev_gone_notify 855:found dev[16385:5] is =
gone.
[ 2041.922527] pm80xx pm8001_chip_dereg_dev_req 4586:unregister device=20
device_id =3D 16385
[ 2041.922531] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:10 ,=20
UPDATED PI=3D121 CI=3D120
[ 2041.922559] pm80xx pm8001_mpi_msg_consume 1450:: CI=3D121 PI=3D122=20
msgHeader=3D8100200b
[ 2041.922561] pm80xx process_one_iomb 3548:unregister the device
[ 2041.922564] pm80xx pm8001_mpi_msg_free_set 1407: CI=3D122 PI=3D122
[ 2041.923031] ------------[ cut here ]------------
[ 2041.923036] WARNING: CPU: 0 PID: 1876 at fs/sysfs/group.c:224=20
sysfs_remove_group+0x8d/0x90()
[ 2041.923038] sysfs group ffffffff81cce480 not found for kobject '5:0:=
0:0'
[ 2041.923039] Modules linked in: pm80xx(OE-) libsas scsi_transport_sas=
=20
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc=20
ebtable_nat fscache bnep bluetooth iptable_mangle nf_conntrack_ipv4=20
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables=20
ip6table_filter ip6_tables ppdev snd_hda_codec_realtek=20
snd_hda_codec_generic snd_hda_intel snd_hda_codec hp_wmi tg3=20
sparse_keymap pcspkr iTCO_wdt iTCO_vendor_support lpc_ich snd_hda_core=20
serio_raw snd_hwdep snd_seq snd_seq_device snd_pcm rfkill i5000_edac=20
mfd_core edac_core i5k_amb snd_timer snd ptp soundcore shpchp ses=20
pps_core enclosure parport_pc wmi parport acpi_cpufreq uinput esas2r
[ 2041.923082] CPU: 0 PID: 1876 Comm: rmmod Tainted: G        W OE  =20
4.3.0-rc1+ #2
[ 2041.923084] Hardware name: Hewlett-Packard HP xw6400=20
Workstation/0A04h, BIOS 786D4 v02.24 07/06/2007
[ 2041.923085]  ffffffff81a525ce ffff8800d25bbc18 ffffffff8135f978=20
ffff8800d25bbc60
[ 2041.923089]  ffff8800d25bbc50 ffffffff81090f48 0000000000000000=20
ffffffff81cce480
[ 2041.923092]  ffff880119677c10 ffff8800cc823168 ffff880036f7f000=20
ffff8800d25bbcb0
[ 2041.923095] Call Trace:
[ 2041.923098]  [<ffffffff8135f978>] dump_stack+0x44/0x5c
[ 2041.923101]  [<ffffffff81090f48>] warn_slowpath_common+0x88/0xc0
[ 2041.923104]  [<ffffffff81090fcc>] warn_slowpath_fmt+0x4c/0x50
[ 2041.923107]  [<ffffffff81268878>] ? kernfs_find_and_get_ns+0x48/0x60
[ 2041.923110]  [<ffffffff8126bcfd>] sysfs_remove_group+0x8d/0x90
[ 2041.923113]  [<ffffffff81487177>] dpm_sysfs_remove+0x57/0x60
[ 2041.923115]  [<ffffffff8147b379>] device_del+0x49/0x240
[ 2041.923118]  [<ffffffff8147b58e>] device_unregister+0x1e/0x60
[ 2041.923121]  [<ffffffff8134db1e>] bsg_unregister_queue+0x5e/0xa0
[ 2041.923125]  [<ffffffff814b34e6>] __scsi_remove_device+0xa6/0xd0
[ 2041.923129]  [<ffffffff814b1bd0>] scsi_forget_host+0x60/0x70
[ 2041.923132]  [<ffffffff814a6167>] scsi_remove_host+0x77/0x110
[ 2041.923138]  [<ffffffffa04055d1>] pm8001_pci_remove+0x51/0x160 [pm80=
xx]
[ 2041.923142]  [<ffffffff8139c9e9>] pci_device_remove+0x39/0xc0
[ 2041.923145]  [<ffffffff8147fd46>] __device_release_driver+0x96/0x130
[ 2041.923148]  [<ffffffff8147fed3>] driver_detach+0xa3/0xb0
[ 2041.923151]  [<ffffffff8147ef45>] bus_remove_driver+0x55/0xd0
[ 2041.923154]  [<ffffffff814805ec>] driver_unregister+0x2c/0x50
[ 2041.923156]  [<ffffffff8139c453>] pci_unregister_driver+0x23/0x80
[ 2041.923161]  [<ffffffffa041ba0c>] pm8001_exit+0x10/0x2a [pm80xx]
[ 2041.923166]  [<ffffffff8110a8df>] SyS_delete_module+0x16f/0x1f0
[ 2041.923170]  [<ffffffff81003b70>] ? syscall_return_slowpath+0x50/0x1=
20
[ 2041.923173]  [<ffffffff816f972e>] entry_SYSCALL_64_fastpath+0x12/0x7=
1
[ 2041.923175] ---[ end trace f3d195aaffcdb43e ]---
[ 2041.923232] ------------[ cut here ]------------
[ 2041.923236] WARNING: CPU: 0 PID: 1876 at fs/sysfs/group.c:224=20
sysfs_remove_group+0x8d/0x90()
[ 2041.923238] sysfs group ffffffff81cce480 not found for kobject '5:0:=
0:0'
[ 2041.923240] Modules linked in: pm80xx(OE-) libsas scsi_transport_sas=
=20
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc=20
ebtable_nat fscache bnep bluetooth iptable_mangle nf_conntrack_ipv4=20
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables=20
ip6table_filter ip6_tables ppdev snd_hda_codec_realtek=20
snd_hda_codec_generic snd_hda_intel snd_hda_codec hp_wmi tg3=20
sparse_keymap pcspkr iTCO_wdt iTCO_vendor_support lpc_ich snd_hda_core=20
serio_raw snd_hwdep snd_seq snd_seq_device snd_pcm rfkill i5000_edac=20
mfd_core edac_core i5k_amb snd_timer snd ptp soundcore shpchp ses=20
pps_core enclosure parport_pc wmi parport acpi_cpufreq uinput esas2r
[ 2041.923281] CPU: 0 PID: 1876 Comm: rmmod Tainted: G        W OE  =20
4.3.0-rc1+ #2
[ 2041.923283] Hardware name: Hewlett-Packard HP xw6400=20
Workstation/0A04h, BIOS 786D4 v02.24 07/06/2007
[ 2041.923285]  ffffffff81a525ce ffff8800d25bbc30 ffffffff8135f978=20
ffff8800d25bbc78
[ 2041.923288]  ffff8800d25bbc68 ffffffff81090f48 0000000000000000=20
ffffffff81cce480
[ 2041.923291]  ffff8800cc823448 ffff8800cc823168 ffff880036f7f000=20
ffff8800d25bbcc8
[ 2041.923295] Call Trace:
[ 2041.923298]  [<ffffffff8135f978>] dump_stack+0x44/0x5c
[ 2041.923300]  [<ffffffff81090f48>] warn_slowpath_common+0x88/0xc0
[ 2041.923303]  [<ffffffff81090fcc>] warn_slowpath_fmt+0x4c/0x50
[ 2041.923306]  [<ffffffff81268878>] ? kernfs_find_and_get_ns+0x48/0x60
[ 2041.923309]  [<ffffffff8126bcfd>] sysfs_remove_group+0x8d/0x90
[ 2041.923312]  [<ffffffff81487177>] dpm_sysfs_remove+0x57/0x60
[ 2041.923314]  [<ffffffff8147b379>] device_del+0x49/0x240
[ 2041.923317]  [<ffffffff8147b58e>] device_unregister+0x1e/0x60
[ 2041.923320]  [<ffffffff814b34f2>] __scsi_remove_device+0xb2/0xd0
[ 2041.923322]  [<ffffffff814b1bd0>] scsi_forget_host+0x60/0x70
[ 2041.923325]  [<ffffffff814a6167>] scsi_remove_host+0x77/0x110
[ 2041.923329]  [<ffffffffa04055d1>] pm8001_pci_remove+0x51/0x160 [pm80=
xx]
[ 2041.923332]  [<ffffffff8139c9e9>] pci_device_remove+0x39/0xc0
[ 2041.923336]  [<ffffffff8147fd46>] __device_release_driver+0x96/0x130
[ 2041.923338]  [<ffffffff8147fed3>] driver_detach+0xa3/0xb0
[ 2041.923341]  [<ffffffff8147ef45>] bus_remove_driver+0x55/0xd0
[ 2041.923344]  [<ffffffff814805ec>] driver_unregister+0x2c/0x50
[ 2041.923346]  [<ffffffff8139c453>] pci_unregister_driver+0x23/0x80
[ 2041.923351]  [<ffffffffa041ba0c>] pm8001_exit+0x10/0x2a [pm80xx]
[ 2041.923354]  [<ffffffff8110a8df>] SyS_delete_module+0x16f/0x1f0
[ 2041.923357]  [<ffffffff81003b70>] ? syscall_return_slowpath+0x50/0x1=
20
[ 2041.923359]  [<ffffffff816f972e>] entry_SYSCALL_64_fastpath+0x12/0x7=
1
[ 2041.923362] ---[ end trace f3d195aaffcdb43f ]---
[ 2041.923372] ------------[ cut here ]------------
[ 2041.923375] WARNING: CPU: 0 PID: 1876 at fs/sysfs/group.c:224=20
sysfs_remove_group+0x8d/0x90()
[ 2041.923377] sysfs group ffffffff81cce480 not found for kobject 'sg4'
[ 2041.923378] Modules linked in: pm80xx(OE-) libsas scsi_transport_sas=
=20
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc=20
ebtable_nat fscache bnep bluetooth iptable_mangle nf_conntrack_ipv4=20
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables=20
ip6table_filter ip6_tables ppdev snd_hda_codec_realtek=20
snd_hda_codec_generic snd_hda_intel snd_hda_codec hp_wmi tg3=20
sparse_keymap pcspkr iTCO_wdt iTCO_vendor_support lpc_ich snd_hda_core=20
serio_raw snd_hwdep snd_seq snd_seq_device snd_pcm rfkill i5000_edac=20
mfd_core edac_core i5k_amb snd_timer snd ptp soundcore shpchp ses=20
pps_core enclosure parport_pc wmi parport acpi_cpufreq uinput esas2r
[ 2041.923419] CPU: 0 PID: 1876 Comm: rmmod Tainted: G        W OE  =20
4.3.0-rc1+ #2
[ 2041.923421] Hardware name: Hewlett-Packard HP xw6400=20
Workstation/0A04h, BIOS 786D4 v02.24 07/06/2007
[ 2041.923422]  ffffffff81a525ce ffff8800d25bbb78 ffffffff8135f978=20
ffff8800d25bbbc0
[ 2041.923425]  ffff8800d25bbbb0 ffffffff81090f48 0000000000000000=20
ffffffff81cce480
[ 2041.923429]  ffff880119677410 ffff8800cc823168 ffff8800ce25cf50=20
ffff8800d25bbc10
[ 2041.923432] Call Trace:
[ 2041.923434]  [<ffffffff8135f978>] dump_stack+0x44/0x5c
[ 2041.923437]  [<ffffffff81090f48>] warn_slowpath_common+0x88/0xc0
[ 2041.923440]  [<ffffffff81090fcc>] warn_slowpath_fmt+0x4c/0x50
[ 2041.923443]  [<ffffffff81268878>] ? kernfs_find_and_get_ns+0x48/0x60
[ 2041.923446]  [<ffffffff8126bcfd>] sysfs_remove_group+0x8d/0x90
[ 2041.923448]  [<ffffffff81487177>] dpm_sysfs_remove+0x57/0x60
[ 2041.923451]  [<ffffffff8147b379>] device_del+0x49/0x240
[ 2041.923454]  [<ffffffff81480dcd>] ? class_find_device+0x7d/0xc0
[ 2041.923456]  [<ffffffff8147b58e>] device_unregister+0x1e/0x60
[ 2041.923459]  [<ffffffff8147b64c>] device_destroy+0x3c/0x50
[ 2041.923463]  [<ffffffff814c1078>] sg_remove_device+0xe8/0x160
[ 2041.923466]  [<ffffffff8147b3fa>] device_del+0xca/0x240
[ 2041.923468]  [<ffffffff8147b58e>] device_unregister+0x1e/0x60
[ 2041.923471]  [<ffffffff814b34f2>] __scsi_remove_device+0xb2/0xd0
[ 2041.923474]  [<ffffffff814b1bd0>] scsi_forget_host+0x60/0x70
[ 2041.923477]  [<ffffffff814a6167>] scsi_remove_host+0x77/0x110
[ 2041.923481]  [<ffffffffa04055d1>] pm8001_pci_remove+0x51/0x160 [pm80=
xx]
[ 2041.923484]  [<ffffffff8139c9e9>] pci_device_remove+0x39/0xc0
[ 2041.923487]  [<ffffffff8147fd46>] __device_release_driver+0x96/0x130
[ 2041.923489]  [<ffffffff8147fed3>] driver_detach+0xa3/0xb0
[ 2041.923492]  [<ffffffff8147ef45>] bus_remove_driver+0x55/0xd0
[ 2041.923495]  [<ffffffff814805ec>] driver_unregister+0x2c/0x50
[ 2041.923497]  [<ffffffff8139c453>] pci_unregister_driver+0x23/0x80
[ 2041.923502]  [<ffffffffa041ba0c>] pm8001_exit+0x10/0x2a [pm80xx]
[ 2041.923505]  [<ffffffff8110a8df>] SyS_delete_module+0x16f/0x1f0
[ 2041.923508]  [<ffffffff81003b70>] ? syscall_return_slowpath+0x50/0x1=
20
[ 2041.923510]  [<ffffffff816f972e>] entry_SYSCALL_64_fastpath+0x12/0x7=
1
[ 2041.923513] ---[ end trace f3d195aaffcdb440 ]---
[ 2041.923643] ------------[ cut here ]------------
[ 2041.923647] WARNING: CPU: 0 PID: 1876 at fs/sysfs/group.c:224=20
sysfs_remove_group+0x8d/0x90()
[ 2041.923649] sysfs group ffffffff81cce480 not found for kobject '5:0:=
0:0'
[ 2041.923650] Modules linked in: pm80xx(OE-) libsas scsi_transport_sas=
=20
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc=20
ebtable_nat fscache bnep bluetooth iptable_mangle nf_conntrack_ipv4=20
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables=20
ip6table_filter ip6_tables ppdev snd_hda_codec_realtek=20
snd_hda_codec_generic snd_hda_intel snd_hda_codec hp_wmi tg3=20
sparse_keymap pcspkr iTCO_wdt iTCO_vendor_support lpc_ich snd_hda_core=20
serio_raw snd_hwdep snd_seq snd_seq_device snd_pcm rfkill i5000_edac=20
mfd_core edac_core i5k_amb snd_timer snd ptp soundcore shpchp ses=20
pps_core enclosure parport_pc wmi parport acpi_cpufreq uinput esas2r
[ 2041.936328] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936330] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936331] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936333] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936334] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936336] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936337] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936339] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936340] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936342] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936343] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936345] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936347] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936348] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936350] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936351] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936353] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936354] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936356] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936357] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936359] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936360] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936362] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936363] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936365] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936367] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936368] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936370] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936371] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936373] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936374] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936376] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936377] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936379] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936380] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936382] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936383] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936385] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936386] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936388] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936389] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936391] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936392] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936394] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936395] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936397] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936399] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936400] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936402] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936403] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936405] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936406] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936408] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936410] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936411] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936413] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936414] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936416] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936417] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936419] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936420] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936422] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936423] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936425] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936426] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936428] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936429] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936431] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936432] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936434] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936436] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936437] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936439] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936440] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936442] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936443] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936445] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936446] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936448] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936449] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936451] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936453] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936454] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936456] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936457] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936459] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936460] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936462] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936463] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936465] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936466] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936468] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936469] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936471] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936472] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936474] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936475] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936477] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936478] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936480] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936481] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936483] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936484] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936486] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936488] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936489] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936491] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936492] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936494] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936495] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936497] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936498] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936500] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936502] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936503] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936505] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936506] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936508] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936509] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936511] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936512] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936514] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936515] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936517] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936518] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936520] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936521] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936523] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936524] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936526] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936527] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936529] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936530] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936532] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936533] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936535] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936537] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936538] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936540] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936541] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936543] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936544] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936546] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936547] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936549] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936550] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936552] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936553] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936555] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936557] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936558] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936560] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936561] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936563] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936564] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936566] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936567] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936569] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936570] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936572] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936573] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936575] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936576] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936578] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936579] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936581] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936582] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936584] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936586] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936587] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936589] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936590] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936592] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936593] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936595] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936596] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936598] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936599] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936601] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936602] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936604] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936606] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936607] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936609] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936610] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936612] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936613] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936615] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936616] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936618] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936619] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936621] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936622] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936624] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936625] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936627] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936628] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936635] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936636] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936638] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936639] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936641] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936642] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936644] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936646] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936647] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936649] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936650] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936652] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936653] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936655] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936656] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936658] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936659] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936661] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936662] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936664] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936666] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936667] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936669] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936670] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936672] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936673] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936675] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936676] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936678] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936679] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936681] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936683] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936684] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936686] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936687] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936689] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936690] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936692] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936693] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936695] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936696] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936698] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936700] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936701] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936703] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936704] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936706] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936707] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936709] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936710] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936712] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936713] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936715] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936716] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936718] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936719] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936721] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936722] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936724] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936725] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936727] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936728] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936730] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936731] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936733] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936735] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936736] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936738] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936739] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936741] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936742] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936744] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936745] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936747] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936748] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936750] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936752] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936753] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936755] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936756] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936758] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936759] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936761] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936762] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936764] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936766] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936767] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936769] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936770] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936772] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936773] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936775] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936776] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936778] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936779] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936781] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936783] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936784] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936786] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936787] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936789] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936790] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936794] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936795] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936797] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936799] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936800] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936802] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936803] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936805] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936806] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936808] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936809] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936811] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936812] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936814] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936816] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936817] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936819] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936820] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936822] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936823] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936825] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936826] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936828] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936829] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936831] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936832] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936834] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936836] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936838] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936839] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936841] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936842] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936844] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936845] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936847] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936848] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936850] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936851] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936853] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936854] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936856] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936857] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936859] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936860] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936862] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936864] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936865] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936867] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936870] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936871] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936873] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936874] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936876] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936877] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936879] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936880] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936882] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936883] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936885] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936887] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936888] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936890] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936891] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936893] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936894] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936896] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936897] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936899] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936900] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936902] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936904] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936905] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936907] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936908] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936910] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936911] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936913] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936914] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936916] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936917] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936919] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.936920] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.936922] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938223] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938224] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938226] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938227] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938229] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938230] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938232] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938234] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938235] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938237] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938238] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938240] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938241] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938243] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938244] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938246] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938247] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938249] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938250] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938252] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938253] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938255] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938257] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938258] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938260] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938261] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938263] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938264] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938266] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938268] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938269] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938271] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938272] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938274] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938275] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938277] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938279] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938280] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938282] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938283] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938285] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938287] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938288] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938290] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938291] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938293] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938294] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938296] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938297] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938299] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938300] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938302] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938303] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938305] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938306] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938308] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938309] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938311] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938313] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938314] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938316] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938317] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938319] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938320] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938322] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938323] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938325] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938326] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938328] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938330] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938331] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938333] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938334] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938336] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938337] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938339] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938340] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938342] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938343] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938345] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938346] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938348] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938350] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938351] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938353] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938354] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938356] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938358] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938359] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938361] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938362] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938364] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938365] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938367] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938368] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938370] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938372] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938373] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938375] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938376] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938378] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938379] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938381] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938383] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938384] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938386] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938387] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938389] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938390] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938392] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938393] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938395] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938397] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938398] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938400] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938401] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938403] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938404] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938406] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938407] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938409] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938411] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938412] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938414] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938415] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938417] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938418] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938420] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938422] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938423] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938425] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938426] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938428] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938430] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938431] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938433] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938434] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938436] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938437] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938439] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938440] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938442] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938443] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938445] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938446] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938448] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938450] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938451] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938453] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938455] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938456] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938458] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938459] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938461] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938462] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938464] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938465] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938467] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938468] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938470] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938471] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938473] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938474] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938476] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938478] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938479] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938481] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938483] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938484] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938486] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938487] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938489] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938490] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938492] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938493] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938495] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938496] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938498] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938500] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938501] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938503] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938504] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938506] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938507] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938509] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938511] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938512] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938514] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938516] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938517] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938519] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938521] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938522] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938524] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938525] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938527] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938528] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938530] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938531] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938533] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938535] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938537] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938538] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938540] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938541] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938543] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938544] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938546] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938547] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938549] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938551] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938552] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938554] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938555] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938557] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938559] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938560] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938562] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938563] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938565] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938567] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938568] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938570] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938572] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938645] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938647] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938648] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938650] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938651] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938653] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938654] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938656] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938658] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938659] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938661] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938663] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938664] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938666] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938667] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938669] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938670] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938672] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938673] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938675] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938677] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938678] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938680] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938682] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938683] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938685] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938686] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938688] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938689] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938691] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938692] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938694] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938695] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938697] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938699] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938700] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938702] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938703] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938705] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938707] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938708] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938710] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938712] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938713] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938715] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938716] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938718] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938720] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938721] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938723] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938724] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938726] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938727] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938729] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938730] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938732] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938733] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938735] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938736] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938738] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938739] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938741] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938742] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938744] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938745] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938747] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938748] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938750] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938752] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938753] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938755] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938756] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938758] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938760] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938761] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938763] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938764] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938766] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938767] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938769] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938770] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938772] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938773] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938775] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938777] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938778] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938780] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938782] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938783] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938785] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938786] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938788] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938789] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938791] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938792] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938794] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938796] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938798] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938799] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938801] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938802] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938804] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938805] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938807] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938808] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938810] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938811] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938813] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938815] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938816] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938818] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938819] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938821] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938823] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938824] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938826] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938827] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938829] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938830] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938832] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938833] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938835] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938836] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938838] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938840] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938842] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938843] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938845] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938846] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938848] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938849] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938851] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938852] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938854] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938856] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938857] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938859] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938860] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938862] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938863] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938865] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938866] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938868] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938869] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938871] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938873] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938874] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938876] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938877] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938879] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938880] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938882] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938883] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938885] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938887] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938888] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2041.938890] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2041.938891] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036398] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036401] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036404] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036406] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036409] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036411] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036414] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036417] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036419] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036422] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036425] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036427] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036430] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036432] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036435] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036438] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036440] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036443] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036446] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036448] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036451] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036453] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036456] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036459] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036461] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036464] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036466] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036469] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036472] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036474] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036477] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036479] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036482] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036485] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036487] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036490] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036492] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036495] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036498] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036500] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036503] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036505] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036508] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036511] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036513] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036516] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036519] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036521] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036524] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036526] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036529] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036532] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036534] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036537] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036539] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036542] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036545] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036547] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036550] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036552] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036555] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036558] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036560] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036563] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036566] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036568] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036571] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036573] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036576] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036578] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036581] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036584] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036586] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036589] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036592] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036594] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036597] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036599] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036602] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036605] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036607] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036610] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036612] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036615] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036618] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036620] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036623] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036625] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036628] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036631] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036633] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036636] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036639] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036641] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036644] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036647] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036649] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036652] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036654] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036657] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036659] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036662] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036665] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036667] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036670] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036672] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036675] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036678] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036680] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036683] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036685] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.036688] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.036691] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056930] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056932] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056933] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056935] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056936] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056938] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056939] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056941] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056942] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056944] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056945] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056947] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056948] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056950] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056951] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056953] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056955] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056956] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056958] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056959] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056961] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056962] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056964] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056965] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056967] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056968] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056970] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056971] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056973] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056974] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056976] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056977] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056979] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056980] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056982] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056983] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056985] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056986] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056988] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056989] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056991] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056992] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056994] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056995] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.056997] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.056999] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057005] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057006] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057008] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057009] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057011] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057012] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057014] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057015] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057017] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057019] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057020] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057022] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057023] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057025] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057027] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057028] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057030] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057031] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057033] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057034] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057036] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057037] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057039] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057040] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057042] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057043] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057045] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057046] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057048] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057049] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057051] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057052] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057054] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057055] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057057] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057058] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057060] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057061] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057063] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057065] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057066] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057068] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057069] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057071] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057072] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057074] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057075] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057077] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057078] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057080] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057082] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057083] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057085] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057086] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057088] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057089] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057091] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057092] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057094] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057095] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057097] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057098] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057100] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057101] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057103] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057104] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057106] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057107] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057109] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057110] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057112] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057114] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057115] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057117] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057118] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057120] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057121] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057123] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057125] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057126] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057128] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057129] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057131] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057132] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057134] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057135] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057137] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057138] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057140] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057141] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057143] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057144] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057146] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057147] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057149] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057150] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057152] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057153] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057155] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057157] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057158] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057160] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057161] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057163] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057164] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057166] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057167] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057169] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057171] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057172] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057174] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057175] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057177] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057178] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057180] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057181] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057183] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057184] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057186] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057187] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057189] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057190] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057192] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057194] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057195] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057197] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057198] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057200] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057201] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057203] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057204] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057206] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057207] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057209] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057210] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057212] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057214] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057215] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057217] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057218] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057220] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057221] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057223] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057224] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057226] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057227] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057229] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057230] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.057232] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.057233] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073973] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073975] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.073976] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073978] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.073979] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073981] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.073982] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073984] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.073985] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073987] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.073988] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073990] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.073991] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073993] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.073995] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073996] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.073998] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.073999] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075271] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075274] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075276] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075278] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075279] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075281] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075282] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075284] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075285] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075287] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075289] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075290] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075292] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075293] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075295] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075296] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075298] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075300] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075301] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075303] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075304] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075306] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075307] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075309] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075310] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075312] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075314] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075315] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075317] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075318] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075320] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075321] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075323] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075324] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075326] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075328] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075329] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075331] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075332] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075334] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075335] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075415] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075417] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075419] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075420] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075422] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075423] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075425] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075427] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075428] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075430] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075431] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075433] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075434] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075436] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075438] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075439] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075441] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075442] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075444] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075445] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075447] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075448] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075450] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075451] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075453] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075454] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075456] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075457] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075459] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075461] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075462] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075464] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075466] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075467] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075469] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075470] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075472] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075473] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075475] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075476] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075478] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075479] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075481] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075482] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075484] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075485] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075487] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075488] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075490] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075492] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075493] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075495] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075496] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075498] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075499] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075501] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075502] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075504] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075506] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075507] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075509] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075510] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075512] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075513] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075515] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075516] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075518] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075519] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075521] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075522] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075524] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075525] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075527] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075528] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075530] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075532] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075533] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075535] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075536] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075538] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075539] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075541] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075542] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075544] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075545] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075547] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075549] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075550] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075552] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075553] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075555] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075556] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075558] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075559] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075561] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075562] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075564] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075565] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075567] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075569] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075570] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.075572] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.075573] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085213] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085215] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085218] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085220] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085222] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085225] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085227] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085230] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085232] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085235] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085237] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085239] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085242] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085244] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085247] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085249] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085252] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085254] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085257] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085259] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085261] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085264] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085266] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085269] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085271] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085274] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085276] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085278] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085281] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085283] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085286] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085288] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085291] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085293] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085296] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085298] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085300] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085303] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085305] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085308] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085310] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085313] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085315] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085317] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085320] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085322] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085325] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085327] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085330] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085332] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085392] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085395] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085401] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085403] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085406] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085408] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085411] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085413] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085416] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085418] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085420] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085423] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085425] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085428] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085430] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085432] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085435] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085437] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085440] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085442] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085445] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085447] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085450] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085452] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085455] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085457] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085459] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085462] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085464] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085467] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085469] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085472] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085474] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085477] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085479] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085481] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085484] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085486] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085489] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085491] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085494] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085496] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085499] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085501] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085503] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085506] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085508] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085511] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085513] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085516] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085518] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085520] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085523] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085525] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085528] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085530] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085533] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085535] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085538] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085540] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085542] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085545] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085547] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085550] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085552] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085555] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085557] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085559] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085562] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085564] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085567] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085569] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085572] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085574] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085577] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085579] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085581] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085584] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085586] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085589] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085591] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085594] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085596] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085599] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085601] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085604] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085606] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.085608] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.085611] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093133] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093136] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093138] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093141] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093143] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093146] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093148] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093150] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093152] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093155] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093157] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093160] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093161] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093164] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093166] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093169] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093171] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093174] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093175] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093178] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093180] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093183] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093185] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093187] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093190] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093192] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093194] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093197] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093199] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093202] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093204] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093207] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093209] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093211] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093213] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093216] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093218] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093221] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093223] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093225] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093227] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093230] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093232] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093235] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093237] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093239] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093241] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093244] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093246] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093249] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093251] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093253] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093255] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093258] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093260] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093263] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093264] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093267] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093269] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093272] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093274] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093276] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093278] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093281] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093283] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093285] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093287] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093289] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093290] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093292] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093293] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093295] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093296] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093298] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093299] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093301] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093302] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093304] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093306] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093307] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093309] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093310] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093312] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093314] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093315] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093317] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093318] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093320] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093321] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093323] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093324] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093326] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093327] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093329] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093331] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093332] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093334] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093335] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093337] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093339] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093340] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093342] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093343] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093345] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093346] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093348] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093349] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093351] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093352] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093354] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093356] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093357] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093359] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093360] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093362] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093363] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093365] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093367] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093368] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093370] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093371] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093373] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093374] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093376] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093377] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093379] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093380] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093382] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093383] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093385] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093387] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093388] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093390] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093391] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093393] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093395] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093396] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093398] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093399] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093401] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093402] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093404] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093405] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093407] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093409] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093410] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093412] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093413] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093415] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093416] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093418] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093420] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093422] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093425] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093427] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093430] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093431] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093434] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093436] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093439] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093441] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093443] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093445] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093448] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093450] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093453] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093455] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093457] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093459] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093462] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093464] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093467] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093468] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093471] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093473] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093476] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093478] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093480] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093482] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093485] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093487] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093490] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093492] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093494] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093496] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093499] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093501] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093504] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093505] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093508] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093510] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093513] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093515] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093518] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093519] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093522] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093524] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093527] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093529] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093531] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093533] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093536] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093538] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093541] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093543] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093545] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093547] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093550] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093552] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093554] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093556] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093559] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093561] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093564] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093566] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093568] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093570] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093572] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093574] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093577] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093579] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093582] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093583] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093586] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093587] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093589] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093591] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093592] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093594] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093595] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093597] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093598] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093600] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093602] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093603] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093605] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093606] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093608] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093609] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093611] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093612] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093614] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093615] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093617] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093619] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093620] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093622] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093623] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093625] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093627] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093628] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093630] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093631] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093633] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093634] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093636] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093637] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093639] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093640] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093642] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093643] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093645] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093646] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093648] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093650] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093651] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093653] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093654] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093656] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093658] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.093659] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.093661] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097509] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097510] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097512] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097514] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097515] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097517] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097518] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097520] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097521] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097523] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097524] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097526] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097527] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097529] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097530] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097532] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097533] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097535] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097536] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097538] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097539] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097541] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097543] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097544] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097546] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097547] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097549] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097550] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097552] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097553] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097555] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097557] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097558] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097560] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097561] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097563] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097564] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097566] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097567] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097569] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097570] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097572] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097573] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097575] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097577] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097578] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097580] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097581] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097583] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097584] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097586] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097588] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097589] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097591] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097592] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097594] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097595] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097597] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097598] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097600] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097601] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097603] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097604] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097606] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097607] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097609] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097611] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097612] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097614] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097615] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097617] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097618] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097620] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097622] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097623] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097625] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097626] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097628] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097629] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097631] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097632] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097634] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097635] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097637] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097638] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097640] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097641] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097643] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097644] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097646] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097648] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097649] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097651] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097652] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097654] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097655] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097657] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097658] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097660] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097662] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097663] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097665] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097666] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097668] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097669] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097671] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097672] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097674] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097675] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097677] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097678] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097680] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097682] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097683] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097685] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097686] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097688] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097689] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097691] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097693] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097694] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097696] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097697] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097699] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097700] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097702] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097703] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097705] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097706] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097708] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097709] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097711] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097712] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097714] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097716] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097717] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097719] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097720] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097722] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097723] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097725] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097727] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097728] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097730] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097731] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097733] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097734] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097736] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097737] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097739] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097741] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097744] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097746] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097749] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097751] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097754] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097756] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097758] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097760] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097763] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097765] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097768] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097770] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097773] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097774] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097777] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097779] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097782] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097784] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097787] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097789] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097791] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097793] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097796] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097798] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097801] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097803] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097805] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097807] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097810] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097812] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097815] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097817] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097820] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097822] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097824] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097826] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097828] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097830] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097833] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097835] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097838] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097840] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097843] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097844] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097847] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097849] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097852] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097854] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097857] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097859] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097861] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097863] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097866] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097868] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097871] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097873] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097875] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097877] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097879] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097881] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097884] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097886] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097889] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097891] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097893] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097895] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097898] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097900] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097903] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097905] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097907] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097909] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097912] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097914] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097916] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097917] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097919] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097920] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097922] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097923] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097925] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097926] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097928] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097929] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097931] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097932] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097934] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097936] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097937] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097939] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097940] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097942] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097943] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097945] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097947] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097948] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097950] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097951] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097953] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097954] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097956] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097957] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097959] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097961] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097962] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097964] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097965] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097967] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097968] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097970] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097972] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.097973] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.097975] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111053] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111056] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111059] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111061] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111064] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111067] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111069] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111072] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111074] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111077] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111080] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111083] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111085] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111088] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111091] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111093] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111096] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111099] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111101] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111104] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111106] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111109] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111112] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111115] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111117] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111120] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111123] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111125] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111128] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111131] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111133] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111136] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111139] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111141] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111144] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111147] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111149] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111152] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 2042.111154] sas: --- Exit sas_scsi_recover_host: busy: 1 failed: 1=20
tries: 1
[ 2042.111157] sas: Enter sas_s

--=20
Benjamin Rood
Systems Engineer
ATTO Technology, Inc.
+1.716.691.1999 x277
www.attotech.com
"Powering the World's Networks & Storage"




This electronic transmission and any attachments hereto are intended on=
ly for the use of the individual or entity to which it is addressed and=
 may contain confidential information belonging to ATTO Technology, Inc=
=2E If you have reason to believe that you are not the intended recipie=
nt, you are hereby notified that any disclosure, copying, distribution =
or the taking of any action in reliance on the contents of this electro=
nic transmission is strictly prohibited. If you have reason to believe =
that you have received this transmission in error, please notify ATTO i=
mmediately by return e-mail and delete and destroy this communication. =
 =20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
