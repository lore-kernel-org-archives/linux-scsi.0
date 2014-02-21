From: Imre Deak <imre.deak@intel.com>
Subject: scsi_target_reap_usercontext causes a WARN
Date: Fri, 21 Feb 2014 16:19:57 +0200
Message-ID: <1392992397.26076.16.camel@intelbox>
Reply-To: imre.deak@intel.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-OOEBtaGiLlVS/1rPJzqP"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-OOEBtaGiLlVS/1rPJzqP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

not sure if this is a know issue already, but with the 3.13 kernel I got
the warning below. There is also a jbd2_log_wait_commit() hang notice in
the log but I think it's unrelated.

I thought to drop a quick message about this, since it reminded me of
another bug with a similar backtrace. That one was a drm/i915 issue and
caused by an incorrect order of device unregistration for a parent and
its child device. The only allowed order is to first unregister any
child device and only afterwards the parent device. The opposite results
in a similar warning that I included here. For some more context see:

http://patchwork.freedesktop.org/patch/20023/
http://lists.freedesktop.org/archives/intel-gfx/2014-January/038782.html
http://lists.freedesktop.org/archives/intel-gfx/2014-February/039427.html
https://bugs.freedesktop.org/show_bug.cgi?id=3D70523

--Imre

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0-imre+ (jim@intelbox) (gcc version 4.8.1=
 (Ubuntu/Linaro 4.8.1-10ubuntu9) ) #327 SMP PREEMPT Wed Feb 12 15:26:44 EET=
 2014
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.13.0-imre+ root=
=3DUUID=3De8239eb9-a546-4c3b-9c43-bcdb32a655f6 ro quiet splash vt.handoff=
=3D7
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000c6d50fff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x00000000c6d51000-0x00000000c6da4fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000c6da5000-0x00000000c6dc9fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000c6dca000-0x00000000c6dcafff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x00000000c6dcb000-0x00000000c6ddafff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000c6ddb000-0x00000000c6de5fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000c6de6000-0x00000000c6de8fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000c6de9000-0x00000000c6decfff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000c6ded000-0x00000000c6e3cfff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000c6e3d000-0x00000000c6e7ffff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000c6e80000-0x00000000c6ffffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x00000000c7800000-0x00000000cf9fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000042fdfffff] usabl=
e
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Dell Inc. XPS 8300  /0Y2MRG, BIOS A03 02/15/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x42fe00 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FC0000000 write-back
[    0.000000]   2 base 0C7800000 mask FFF800000 uncachable
[    0.000000]   3 base 0C8000000 mask FF8000000 uncachable
[    0.000000]   4 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   5 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   6 base 42FE00000 mask FFFE00000 uncachable
[    0.000000]   7 base 430000000 mask FF0000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 16GB, type WB
[    0.000000] reg 1, base: 16GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3192MB, range: 8MB, type UC
[    0.000000] reg 3, base: 3200MB, range: 128MB, type UC
[    0.000000] reg 4, base: 3328MB, range: 256MB, type UC
[    0.000000] reg 5, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 6, base: 17150MB, range: 2MB, type UC
[    0.000000] reg 7, base: 17152MB, range: 256MB, type UC
[    0.000000] total RAM covered: 16246M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 9  	lose cover RA=
M: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 128MB, type WB
[    0.000000] reg 3, base: 3192MB, range: 8MB, type UC
[    0.000000] reg 4, base: 4GB, range: 4GB, type WB
[    0.000000] reg 5, base: 8GB, range: 8GB, type WB
[    0.000000] reg 6, base: 16GB, range: 512MB, type WB
[    0.000000] reg 7, base: 16896MB, range: 256MB, type WB
[    0.000000] reg 8, base: 17150MB, range: 2MB, type UC
[    0.000000] e820: update [mem 0xc7800000-0xffffffff] usable =3D=3D> rese=
rved
[    0.000000] e820: last_pfn =3D 0xc7000 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fcbb0-0x000fcbbf] mapped at =
[ffff8800000fcbb0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 2457=
6
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02996000, 0x02996fff] PGTABLE
[    0.000000] BRK [0x02997000, 0x02997fff] PGTABLE
[    0.000000] BRK [0x02998000, 0x02998fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x42fc00000-0x42fdfffff]
[    0.000000]  [mem 0x42fc00000-0x42fdfffff] page 2M
[    0.000000] BRK [0x02999000, 0x02999fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x42c000000-0x42fbfffff]
[    0.000000]  [mem 0x42c000000-0x42fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x42bffffff]
[    0.000000]  [mem 0x400000000-0x42bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40200000-0xc6d50fff]
[    0.000000]  [mem 0x40200000-0xc6bfffff] page 2M
[    0.000000]  [mem 0xc6c00000-0xc6d50fff] page 4k
[    0.000000] BRK [0x0299a000, 0x0299afff] PGTABLE
[    0.000000] BRK [0x0299b000, 0x0299bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xc6dca000-0xc6dcafff]
[    0.000000]  [mem 0xc6dca000-0xc6dcafff] page 4k
[    0.000000] init_memory_mapping: [mem 0xc6e80000-0xc6ffffff]
[    0.000000]  [mem 0xc6e80000-0xc6ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x3594a000-0x36c9cfff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000c6d9e070 00005C (v01 DELL    FX09    2010=
0118 AMI  00000097)
[    0.000000] ACPI: FACP 00000000c6da43a0 0000F4 (v04 DELL    FX09    2010=
0118 AMI  00000097)
[    0.000000] ACPI: DSDT 00000000c6d9e158 006242 (v02 DELL    FX09    0000=
0006 INTL 20051117)
[    0.000000] ACPI: FACS 00000000c6de9e80 000040
[    0.000000] ACPI: APIC 00000000c6da4498 000092 (v03 DELL    FX09    2010=
0118 AMI  00000097)
[    0.000000] ACPI: SSDT 00000000c6da4530 0001D6 (v01 AMICPU     PROC 0000=
0001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000c6da4708 00003C (v01   DELL     FX09 2010=
0118 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000c6da4748 000176 (v01 DELL    FX09    2010=
0118 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000c6da48c0 000038 (v01   DELL     FX09 2010=
0118 AMI. 00000004)
[    0.000000] ACPI: OSFR 00000000c6da48f8 000080 (v01 DELL    FX09    07DB=
020F ASL  00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0010bfffff] PMD -> [ffff88041f60000=
0-ffff88042f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x42fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xc6d50fff]
[    0.000000]   node   0: [mem 0xc6dca000-0xc6dcafff]
[    0.000000]   node   0: [mem 0xc6e80000-0xc6ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x42fdfffff]
[    0.000000] On node 0 totalpages: 4155502
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 156 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12652 pages used for memmap
[    0.000000]   DMA32 zone: 809682 pages, LIFO batch:31
[    0.000000]   Normal zone: 52216 pages used for memmap
[    0.000000]   Normal zone: 3341824 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6d51000-0xc6da4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6da5000-0xc6dc9fff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6dcb000-0xc6ddafff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6ddb000-0xc6de5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6de6000-0xc6de8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6de9000-0xc6decfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6ded000-0xc6e3cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6e3d000-0xc6e7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc7000000-0xc77fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc7800000-0xcf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfa00000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xcfa00000-0xfed1bfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88042fa00000 s84096 r8192=
 d22400 u262144
[    0.000000] pcpu-alloc: s84096 r8192 d22400 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4090414
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.13.0-imre+=
 root=3DUUID=3De8239eb9-a546-4c3b-9c43-bcdb32a655f6 ro quiet splash vt.hand=
off=3D7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 16223148K/16622008K available (6872K kernel code, 98=
9K rwdata, 3008K rodata, 1296K init, 11588K bss, 398860K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 66584576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3392.249 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6784.49 BogoMIPS (lpj=3D13568996)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000085] Security Framework initialized
[    0.000124] Mount-cache hash table entries: 256
[    0.000726] Initializing cgroup subsys memory
[    0.000738] Initializing cgroup subsys devices
[    0.000752] Initializing cgroup subsys freezer
[    0.000765] Initializing cgroup subsys blkio
[    0.000767] Initializing cgroup subsys perf_event
[    0.000804] CPU: Physical Processor ID: 0
[    0.000805] CPU: Processor Core ID: 0
[    0.000808] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000808] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.000810] mce: CPU supports 9 MCE banks
[    0.000819] CPU0: Thermal monitoring enabled (TM1)
[    0.000831] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.000831] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000831] tlb_flushall_shift: 5
[    0.000965] Freeing SMP alternatives memory: 24K (ffffffff81e3d000 - fff=
fffff81e43000)
[    0.000969] ACPI: Core revision 20131115
[    0.005686] ACPI: All ACPI Tables successfully acquired
[    0.005810] ftrace: allocating 24198 entries in 95 pages
[    0.015286] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.054988] smpboot: CPU0: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz (fam:=
 06, model: 2a, stepping: 07)
[    0.054995] TSC deadline timer enabled
[    0.055007] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge eve=
nts, full-width counters, Intel PMU driver.
[    0.055013] perf_event_intel: PEBS disabled due to CPU errata, please up=
grade microcode
[    0.055019] ... version:                3
[    0.055020] ... bit width:              48
[    0.055020] ... generic registers:      4
[    0.055021] ... value mask:             0000ffffffffffff
[    0.055022] ... max period:             0000ffffffffffff
[    0.055023] ... fixed-purpose events:   3
[    0.055024] ... event mask:             000000070000000f
[    0.087288] x86: Booting SMP configuration:
[    0.100621] NMI watchdog: enabled on all CPUs, permanently consumes one =
hw-PMU counter.
[    0.087290] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.228246] x86: Booted up 1 node, 8 CPUs
[    0.228250] smpboot: Total of 8 processors activated (54275.98 BogoMIPS)
[    0.234536] devtmpfs: initialized
[    0.234838] PM: Registering ACPI NVS region [mem 0xc6d51000-0xc6da4fff] =
(344064 bytes)
[    0.234847] PM: Registering ACPI NVS region [mem 0xc6ddb000-0xc6de5fff] =
(45056 bytes)
[    0.234848] PM: Registering ACPI NVS region [mem 0xc6de9000-0xc6decfff] =
(16384 bytes)
[    0.234850] PM: Registering ACPI NVS region [mem 0xc6e3d000-0xc6e7ffff] =
(274432 bytes)
[    0.235674] xor: automatically using best checksumming function:
[    0.273940]    avx       : 23239.000 MB/sec
[    0.273944] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.273972] RTC time: 13:19:19, date: 02/20/14
[    0.274107] NET: Registered protocol family 16
[    0.274387] cpuidle: using governor ladder
[    0.274389] cpuidle: using governor menu
[    0.274433] ACPI: bus type PCI registered
[    0.274525] PCI: Using configuration type 1 for base access
[    0.276176] bio: create slab <bio-0> at 0
[    0.342015] raid6: sse2x1    9076 MB/s
[    0.410080] raid6: sse2x2   11310 MB/s
[    0.478153] raid6: sse2x4   13004 MB/s
[    0.478154] raid6: using algorithm sse2x4 (13004 MB/s)
[    0.478155] raid6: using ssse3x2 recovery algorithm
[    0.478232] ACPI: Added _OSI(Module Device)
[    0.478233] ACPI: Added _OSI(Processor Device)
[    0.478235] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.478236] ACPI: Added _OSI(Processor Aggregator Device)
[    0.483280] ACPI: Executed 1 blocks of module-level executable AML code
[    0.487744] ACPI: SSDT 00000000c6de5898 0006F4 (v01    AMI      IST 0000=
0001 MSFT 03000001)
[    0.488580] ACPI: Dynamic OEM Table Load:
[    0.488583] ACPI: SSDT           (null) 0006F4 (v01    AMI      IST 0000=
0001 MSFT 03000001)
[    0.488625] ACPI: SSDT 00000000c6dded98 0000E4 (v01    AMI      CST 0000=
0001 MSFT 03000001)
[    0.489299] ACPI: Dynamic OEM Table Load:
[    0.489301] ACPI: SSDT           (null) 0000E4 (v01    AMI      CST 0000=
0001 MSFT 03000001)
[    0.490811] ACPI: Interpreter enabled
[    0.490820] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131115/hwxface-580)
[    0.490847] ACPI: (supports S0 S1 S3 S4 S5)
[    0.490848] ACPI: Using IOAPIC for interrupt routing
[    0.490884] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.491090] ACPI: No dock devices found.
[    0.491782] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.501698] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.501703] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.501879] acpi PNP0A08:00: _OSC: not requesting OS control; OS require=
s [ExtendedConfig ASPM ClockPM MSI]
[    0.502254] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c8000=
-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000cd9ff])
[    0.502458] PCI host bridge to bus 0000:00
[    0.502461] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.502462] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.502464] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.502465] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.502467] pci_bus 0000:00: root bus resource [mem 0xcfa00000-0xfffffff=
f]
[    0.502476] pci_bus 0000:00: scanning bus
[    0.502499] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.502505] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x10
[    0.502702] pci 0000:00:02.0: [8086:0102] type 00 class 0x030000
[    0.502715] pci 0000:00:02.0: reg 0x10: [mem 0xfe000000-0xfe3fffff 64bit=
]
[    0.502723] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit=
 pref]
[    0.502728] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.502942] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.502970] pci 0000:00:16.0: reg 0x10: [mem 0xfe508000-0xfe50800f 64bit=
]
[    0.503058] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.503083] pci 0000:00:16.0: PME# disabled
[    0.503229] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.503255] pci 0000:00:1a.0: reg 0x10: [mem 0xfe507000-0xfe5073ff]
[    0.503357] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.503362] pci 0000:00:1a.0: PME# disabled
[    0.503466] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.503514] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.503533] pci 0000:00:1b.0: reg 0x10: [mem 0xfe500000-0xfe503fff 64bit=
]
[    0.503621] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.503625] pci 0000:00:1b.0: PME# disabled
[    0.503751] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.503798] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0=
x20
[    0.503848] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.503852] pci 0000:00:1c.0: PME# disabled
[    0.503944] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.503993] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.504036] pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0=
x20
[    0.504086] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.504091] pci 0000:00:1c.3: PME# disabled
[    0.504182] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.504238] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.504262] pci 0000:00:1d.0: reg 0x10: [mem 0xfe506000-0xfe5063ff]
[    0.504365] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.504370] pci 0000:00:1d.0: PME# disabled
[    0.504461] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.504508] pci 0000:00:1f.0: [8086:1c4a] type 00 class 0x060100
[    0.504753] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.504779] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.504789] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.504799] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.504809] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.504818] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.504828] pci 0000:00:1f.2: reg 0x24: [mem 0xfe505000-0xfe5057ff]
[    0.504882] pci 0000:00:1f.2: PME# supported from D3hot
[    0.504886] pci 0000:00:1f.2: PME# disabled
[    0.505007] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.505026] pci 0000:00:1f.3: reg 0x10: [mem 0xfe504000-0xfe5040ff 64bit=
]
[    0.505052] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.505184] pci_bus 0000:00: fixups for bus
[    0.505188] pci 0000:00:1c.0: scanning [bus 01-01] behind bridge, pass 0
[    0.505253] pci_bus 0000:01: scanning bus
[    0.505257] pci_bus 0000:01: fixups for bus
[    0.505258] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.505270] pci_bus 0000:01: bus scan returning with max=3D01
[    0.505276] pci 0000:00:1c.3: scanning [bus 02-02] behind bridge, pass 0
[    0.505339] pci_bus 0000:02: scanning bus
[    0.505372] pci 0000:02:00.0: [14e4:1691] type 00 class 0x020000
[    0.505401] pci 0000:02:00.0: reg 0x10: [mem 0xfe400000-0xfe40ffff 64bit=
]
[    0.505568] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.505574] pci 0000:02:00.0: PME# disabled
[    0.510313] pci_bus 0000:02: fixups for bus
[    0.510315] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    0.510321] pci 0000:00:1c.3:   bridge window [mem 0xfe400000-0xfe4fffff=
]
[    0.510329] pci_bus 0000:02: bus scan returning with max=3D02
[    0.510334] pci 0000:00:1c.0: scanning [bus 01-01] behind bridge, pass 1
[    0.510341] pci 0000:00:1c.3: scanning [bus 02-02] behind bridge, pass 1
[    0.510346] pci_bus 0000:00: bus scan returning with max=3D02
[    0.510358] pci_bus 0000:00: on NUMA node 0
[    0.511543] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14=
 15)
[    0.511636] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14=
 15)
[    0.511727] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 1=
5)
[    0.511818] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 14 1=
5)
[    0.511908] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 =
15) *0
[    0.511999] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 =
15) *0
[    0.512090] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14=
 15)
[    0.512180] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14=
 15)
[    0.512390] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.512398] ACPI: \_SB_.PCI0: notify handler is installed
[    0.512487] Found 1 acpi root devices
[    0.512741] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.512745] vgaarb: loaded
[    0.512746] vgaarb: bridge control possible 0000:00:02.0
[    0.512818] SCSI subsystem initialized
[    0.512840] libata version 3.00 loaded.
[    0.512864] ACPI: bus type USB registered
[    0.512883] usbcore: registered new interface driver usbfs
[    0.512894] usbcore: registered new interface driver hub
[    0.512920] usbcore: registered new device driver usb
[    0.512942] pps_core: LinuxPPS API ver. 1 registered
[    0.512943] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.512947] PTP clock support registered
[    0.513023] PCI: Using ACPI for IRQ routing
[    0.513025] PCI: pci_cache_line_size set to 64 bytes
[    0.513030] pci 0000:00:02.0: BAR 0: reserving [mem 0xfe000000-0xfe3ffff=
f flags 0x140204] (d=3D0, p=3D0)
[    0.513033] pci 0000:00:02.0: BAR 2: reserving [mem 0xd0000000-0xdffffff=
f flags 0x14220c] (d=3D0, p=3D0)
[    0.513035] pci 0000:00:02.0: BAR 4: reserving [io  0xf000-0xf03f flags =
0x40101] (d=3D0, p=3D0)
[    0.513039] pci 0000:00:16.0: BAR 0: reserving [mem 0xfe508000-0xfe50800=
f flags 0x140204] (d=3D0, p=3D0)
[    0.513042] pci 0000:00:1a.0: BAR 0: reserving [mem 0xfe507000-0xfe5073f=
f flags 0x40200] (d=3D0, p=3D0)
[    0.513046] pci 0000:00:1b.0: BAR 0: reserving [mem 0xfe500000-0xfe503ff=
f flags 0x140204] (d=3D0, p=3D0)
[    0.513054] pci 0000:02:00.0: BAR 0: reserving [mem 0xfe400000-0xfe40fff=
f flags 0x140204] (d=3D0, p=3D0)
[    0.513057] pci 0000:00:1d.0: BAR 0: reserving [mem 0xfe506000-0xfe5063f=
f flags 0x40200] (d=3D0, p=3D0)
[    0.513063] pci 0000:00:1f.2: BAR 0: reserving [io  0xf0b0-0xf0b7 flags =
0x40101] (d=3D0, p=3D0)
[    0.513065] pci 0000:00:1f.2: BAR 1: reserving [io  0xf0a0-0xf0a3 flags =
0x40101] (d=3D0, p=3D0)
[    0.513067] pci 0000:00:1f.2: BAR 2: reserving [io  0xf090-0xf097 flags =
0x40101] (d=3D0, p=3D0)
[    0.513069] pci 0000:00:1f.2: BAR 3: reserving [io  0xf080-0xf083 flags =
0x40101] (d=3D0, p=3D0)
[    0.513070] pci 0000:00:1f.2: BAR 4: reserving [io  0xf060-0xf07f flags =
0x40101] (d=3D0, p=3D0)
[    0.513072] pci 0000:00:1f.2: BAR 5: reserving [mem 0xfe505000-0xfe5057f=
f flags 0x40200] (d=3D0, p=3D0)
[    0.513076] pci 0000:00:1f.3: BAR 0: reserving [mem 0xfe504000-0xfe5040f=
f flags 0x140204] (d=3D0, p=3D0)
[    0.513078] pci 0000:00:1f.3: BAR 4: reserving [io  0xf040-0xf05f flags =
0x40101] (d=3D0, p=3D0)
[    0.513099] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.513104] e820: reserve RAM buffer [mem 0xc6d51000-0xc7ffffff]
[    0.513106] e820: reserve RAM buffer [mem 0xc6dcb000-0xc7ffffff]
[    0.513108] e820: reserve RAM buffer [mem 0xc7000000-0xc7ffffff]
[    0.513109] e820: reserve RAM buffer [mem 0x42fe00000-0x42fffffff]
[    0.513361] NetLabel: Initializing
[    0.513362] NetLabel:  domain hash size =3D 128
[    0.513363] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.513393] NetLabel:  unlabeled traffic allowed by default
[    0.513421] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.513427] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.515477] Switched to clocksource hpet
[    0.530476] pnp: PnP ACPI init
[    0.530502] ACPI: bus type PNP registered
[    0.530706] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.530709] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.530710] system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.530714] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.530716] system 00:00: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.530764] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active=
)
[    0.530952] system 00:01: [io  0x0a00-0x0a1f] has been reserved
[    0.530954] system 00:01: [io  0x0a30-0x0a3f] has been reserved
[    0.530958] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active=
)
[    0.531197] pnp 00:02: [dma 4]
[    0.531223] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.531265] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.531297] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.531349] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.531353] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active=
)
[    0.531388] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.531673] system 00:07: [io  0x0400-0x0453] could not be reserved
[    0.531675] system 00:07: [io  0x0458-0x047f] has been reserved
[    0.531677] system 00:07: [io  0x1180-0x119f] has been reserved
[    0.531679] system 00:07: [io  0x0500-0x057f] has been reserved
[    0.531681] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.531683] system 00:07: [mem 0xfec00000-0xfecfffff] could not be reser=
ved
[    0.531685] system 00:07: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.531687] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.531691] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active=
)
[    0.531775] system 00:08: [io  0x0454-0x0457] has been reserved
[    0.531778] system 00:08: Plug and Play ACPI device, IDs INT3f0d PNP0c02=
 (active)
[    0.531988] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.532191] pnp: PnP ACPI: found 10 devices
[    0.532193] ACPI: bus type PNP unregistered
[    0.539320] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.539335] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    0.539341] pci 0000:00:1c.3:   bridge window [mem 0xfe400000-0xfe4fffff=
]
[    0.539351] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.539352] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.539354] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.539355] pci_bus 0000:00: resource 7 [mem 0xcfa00000-0xffffffff]
[    0.539357] pci_bus 0000:02: resource 1 [mem 0xfe400000-0xfe4fffff]
[    0.539401] NET: Registered protocol family 2
[    0.539747] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.539905] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes=
)
[    0.542569] TCP: Hash tables configured (established 131072 bind 65536)
[    0.542605] TCP: reno registered
[    0.542639] UDP hash table entries: 8192 (order: 8, 1310720 bytes)
[    0.543350] UDP-Lite hash table entries: 8192 (order: 8, 1310720 bytes)
[    0.544204] NET: Registered protocol family 1
[    0.544222] pci 0000:00:02.0: calling disable_igfx_irq+0x0/0x80
[    0.544646] pci 0000:00:02.0: BIOS left Intel GPU interrupts enabled; di=
sabling
[    0.544658] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xe0
[    0.544660] pci 0000:00:02.0: Boot video device
[    0.544668] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x7e0
[    0.615702] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x7e0
[    0.687732] PCI: CLS 64 bytes, default 64
[    0.687870] Unpacking initramfs...
[    0.945928] Freeing initrd memory: 19788K (ffff88003594a000 - ffff880036=
c9d000)
[    0.952001] DMA-API: preallocated 65536 debug entries
[    0.952003] DMA-API: debugging enabled by kernel config
[    0.952005] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.952007] software IO TLB [mem 0xc2d51000-0xc6d51000] (64MB) mapped at=
 [ffff8800c2d51000-ffff8800c6d50fff]
[    0.953107] Scanning for low memory corruption every 60 seconds
[    0.953300] cryptomgr_test (57) used greatest stack depth: 6224 bytes le=
ft
[    0.954953] modprobe (65) used greatest stack depth: 5760 bytes left
[    0.956064] cryptomgr_test (62) used greatest stack depth: 5544 bytes le=
ft
[    0.956182] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.956725] audit: initializing netlink socket (disabled)
[    0.956753] type=3D2000 audit(1392902359.948:1): initialized
[    0.973957] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.975897] VFS: Disk quotas dquot_6.5.2
[    0.975942] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.976645] msgmni has been set to 31724
[    0.977233] alg: No test for stdrng (krng)
[    0.977241] NET: Registered protocol family 38
[    0.977255] async_tx: api initialized (async)
[    0.977293] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    0.977369] io scheduler noop registered
[    0.977370] io scheduler deadline registered
[    0.977432] io scheduler cfq registered (default)
[    0.978262] list_sort_test: start testing list_sort()
[    0.979043] intel_idle: MWAIT substates: 0x1120
[    0.979044] intel_idle: v0.4 model 0x2A
[    0.979046] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.979435] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input0
[    0.979469] ACPI: Power Button [PWRB]
[    0.979514] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    0.979517] ACPI: Power Button [PWRF]
[    0.980954] GHES: HEST is not enabled!
[    0.980956] ERST DBG: ERST support is disabled.
[    0.981035] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.981751] Non-volatile memory driver v1.3
[    0.981753] Linux agpgart interface v0.103
[    0.982941] loop: module loaded
[    0.983138] mei_me 0000:00:16.0: irq 40 for MSI/MSI-X
[    0.989408] SCSI Media Changer driver v0.25=20
[    0.989432] ahci 0000:00:1f.2: version 3.0
[    0.989582] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.003746] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
1f impl SATA mode
[    1.003749] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum=
 part ems sxs apst=20
[    1.036602] scsi0 : ahci
[    1.036855] scsi1 : ahci
[    1.037005] scsi2 : ahci
[    1.037156] scsi3 : ahci
[    1.037310] scsi4 : ahci
[    1.037435] scsi5 : ahci
[    1.037490] ata1: SATA max UDMA/133 abar m2048@0xfe505000 port 0xfe50510=
0 irq 41
[    1.037492] ata2: SATA max UDMA/133 abar m2048@0xfe505000 port 0xfe50518=
0 irq 41
[    1.037494] ata3: SATA max UDMA/133 abar m2048@0xfe505000 port 0xfe50520=
0 irq 41
[    1.037497] ata4: SATA max UDMA/133 abar m2048@0xfe505000 port 0xfe50528=
0 irq 41
[    1.037499] ata5: SATA max UDMA/133 abar m2048@0xfe505000 port 0xfe50530=
0 irq 41
[    1.037500] ata6: DUMMY
[    1.037694] libphy: Fixed MDIO Bus: probed
[    1.037709] tg3.c:v3.134 (Sep 16, 2013)
[    1.053735] libphy: tg3 mdio bus: probed
[    1.063280] tg3 0000:02:00.0 eth0: Tigon3 [partno(BCM57788) rev 57780001=
] (PCI Express) MAC address 78:2b:cb:9a:34:46
[    1.063282] tg3 0000:02:00.0 eth0: attached PHY driver [Broadcom BCM5778=
0] (mii_bus:phy_addr=3D200:01)
[    1.063284] tg3 0000:02:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF=
[0] TSOcap[1]
[    1.063286] tg3 0000:02:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.063364] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    1.063365] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.063380] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.063381] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    1.063401] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.063408] ehci-pci: EHCI PCI platform driver
[    1.063555] ehci-pci 0000:00:1a.0: enabling bus mastering
[    1.063587] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.063659] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    1.063688] ehci-pci 0000:00:1a.0: debug port 2
[    1.067670] ehci-pci 0000:00:1a.0: cache line size of 64 is not supporte=
d
[    1.067703] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfe507000
[    1.075815] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.076024] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.076027] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.076028] usb usb1: Product: EHCI Host Controller
[    1.076030] usb usb1: Manufacturer: Linux 3.13.0-imre+ ehci_hcd
[    1.076031] usb usb1: SerialNumber: 0000:00:1a.0
[    1.076480] hub 1-0:1.0: USB hub found
[    1.076520] hub 1-0:1.0: 2 ports detected
[    1.077057] ehci-pci 0000:00:1d.0: enabling bus mastering
[    1.077069] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.077076] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    1.077092] ehci-pci 0000:00:1d.0: debug port 2
[    1.081013] ehci-pci 0000:00:1d.0: cache line size of 64 is not supporte=
d
[    1.081033] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfe506000
[    1.091788] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.091898] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.091900] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.091901] usb usb2: Product: EHCI Host Controller
[    1.091903] usb usb2: Manufacturer: Linux 3.13.0-imre+ ehci_hcd
[    1.091904] usb usb2: SerialNumber: 0000:00:1d.0
[    1.092145] hub 2-0:1.0: USB hub found
[    1.092155] hub 2-0:1.0: 2 ports detected
[    1.092325] ehci-platform: EHCI generic platform driver
[    1.092334] uhci_hcd: USB Universal Host Controller Interface driver
[    1.092459] i8042: PNP: No PS/2 controller found. Probing ports directly=
.
[    1.092910] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.093065] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.093259] mousedev: PS/2 mouse device common for all mice
[    1.093902] rtc_cmos 00:03: RTC can wake from S4
[    1.094198] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.094234] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram=
, hpet irqs
[    1.094718] md: linear personality registered for level -1
[    1.094720] md: raid0 personality registered for level 0
[    1.094721] md: raid1 personality registered for level 1
[    1.094722] md: raid10 personality registered for level 10
[    1.094861] md: raid6 personality registered for level 6
[    1.094864] md: raid5 personality registered for level 5
[    1.094865] md: raid4 personality registered for level 4
[    1.094866] md: multipath personality registered for level -4
[    1.094868] md: faulty personality registered for level -5
[    1.094936] device-mapper: uevent: version 1.0.3
[    1.095122] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    1.095303] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    1.095306] device-mapper: raid: Loading target version 1.5.2
[    1.095605] hidraw: raw HID events driver (C) Jiri Kosina
[    1.095732] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.096356] TCP: cubic registered
[    1.096359] Initializing XFRM netlink socket
[    1.096500] NET: Registered protocol family 10
[    1.096908] mip6: Mobile IPv6
[    1.096920] NET: Registered protocol family 17
[    1.097345] registered taskstats version 1
[    1.099762] Key type encrypted registered
[    1.102624]   Magic number: 2:128:332
[    1.102637] tty tty53: hash matches
[    1.102812] console [netcon0] enabled
[    1.102813] netconsole: network logging started
[    1.102898] rtc_cmos 00:03: setting system clock to 2014-02-20 13:19:20 =
UTC (1392902360)
[    1.105078] PM: Hibernation image not present or could not be loaded.
[    1.355921] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.356004] ata5: SATA link down (SStatus 0 SControl 300)
[    1.356082] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.356166] ata4: SATA link down (SStatus 0 SControl 300)
[    1.357465] ata3.00: ATA-8: WDC WD10EALX-759BA1, 17.01H17, max UDMA/133
[    1.357471] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.358876] ata3.00: configured for UDMA/133
[    1.363923] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.366400] ata2.00: ATAPI: PLDS DVD+/-RW DH-16ABS, PD11, max UDMA/100
[    1.367096] ata1.00: ATA-9: INTEL SSDSC2CT120A3, 300i, max UDMA/133
[    1.367102] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32=
), AA
[    1.367266] ata2.00: configured for UDMA/100
[    1.376970] ata1.00: configured for UDMA/133
[    1.377920] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2CT12 30=
0i PQ: 0 ANSI: 5
[    1.378881] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB=
/111 GiB)
[    1.379105] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.379549] sd 0:0:0:0: [sda] Write Protect is off
[    1.379556] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.379724] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.382308]  sda: sda1 sda2 < sda5 >
[    1.383100] scsi 1:0:0:0: CD-ROM            PLDS     DVD+-RW DH-16ABS PD=
11 PQ: 0 ANSI: 5
[    1.383861] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.387018] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    1.387024] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.387550] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.387793] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.387990] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.388290] scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EALX-759 17=
.0 PQ: 0 ANSI: 5
[    1.388688] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 =
TB/931 GiB)
[    1.388741] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.389044] sd 2:0:0:0: [sdb] Write Protect is off
[    1.389051] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.389220] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.520639] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    1.520645] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    1.521215] hub 1-1:1.0: USB hub found
[    1.521379] hub 1-1:1.0: 6 ports detected
[    1.632142] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.764716] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    1.764719] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    1.765184] hub 2-1:1.0: USB hub found
[    1.765361] hub 2-1:1.0: 8 ports detected
[    1.836402] usb 1-1.3: new low-speed USB device number 3 using ehci-pci
[    1.890872]  sdb: sdb1 sdb2 < sdb5 > sdb3
[    1.892506] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.894190] Freeing unused kernel memory: 1296K (ffffffff81cf9000 - ffff=
ffff81e3d000)
[    1.894194] Write protecting the kernel read-only data: 12288k
[    1.899057] Freeing unused kernel memory: 1312K (ffff8800016b8000 - ffff=
880001800000)
[    1.902373] Freeing unused kernel memory: 1088K (ffff880001af0000 - ffff=
880001c00000)
[    1.911241] busybox (141) used greatest stack depth: 5480 bytes left
[    1.932285] systemd-udevd[157]: starting version 204
[    1.935558] usb 1-1.3: New USB device found, idVendor=3D046d, idProduct=
=3Dc52a
[    1.935564] usb 1-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    1.935567] usb 1-1.3: Product: 2.4GHz Cordless Desktop
[    1.935570] usb 1-1.3: Manufacturer: Logitech
[    1.946779] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input5
[    1.948010] hid-generic 0003:046D:C52A.0001: input,hidraw0: USB HID v1.1=
1 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input=
0
[    1.952206] tsc: Refined TSC clocksource calibration: 3392.295 MHz
[    1.956239] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input6
[    1.956558] hid-generic 0003:046D:C52A.0002: input,hidraw1: USB HID v1.1=
1 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input1
[    1.956587] usbcore: registered new interface driver usbhid
[    1.956588] usbhid: USB HID core driver
[    1.985726] ata_id (180) used greatest stack depth: 3960 bytes left
[    2.036377] usb 2-1.1: new full-speed USB device number 3 using ehci-pci
[    2.132857] usb 2-1.1: New USB device found, idVendor=3D2341, idProduct=
=3D0043
[    2.132860] usb 2-1.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D220
[    2.132861] usb 2-1.1: Manufacturer: Arduino (www.arduino.cc)
[    2.132863] usb 2-1.1: SerialNumber: 74133353537351E0A042
[    2.204487] usb 2-1.2: new high-speed USB device number 4 using ehci-pci
[    2.296963] usb 2-1.2: New USB device found, idVendor=3D0409, idProduct=
=3D005a
[    2.296969] usb 2-1.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    2.297421] hub 2-1.2:1.0: USB hub found
[    2.297613] hub 2-1.2:1.0: 4 ports detected
[    2.368553] usb 2-1.4: new full-speed USB device number 5 using ehci-pci
[    2.463306] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[    2.463312] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    2.463315] usb 2-1.4: Product: Dual RS232
[    2.463318] usb 2-1.4: Manufacturer: FTDI
[    2.536576] usb 2-1.8: new high-speed USB device number 6 using ehci-pci
[    2.631393] usb 2-1.8: New USB device found, idVendor=3D18e3, idProduct=
=3D9106
[    2.631400] usb 2-1.8: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    2.631403] usb 2-1.8: Product: Mass Storage Device
[    2.631406] usb 2-1.8: Manufacturer: Generic
[    2.631409] usb 2-1.8: SerialNumber: 18E391066476
[    2.639078] usb-storage 2-1.8:1.0: USB Mass Storage device detected
[    2.639354] scsi6 : usb-storage 2-1.8:1.0
[    2.639526] usbcore: registered new interface driver usb-storage
[    2.953053] Switched to clocksource tsc
[    3.638808] scsi 6:0:0:0: Direct-Access     Generic- SD/MMC           1.=
00 PQ: 0 ANSI: 0
[    3.639499] scsi 6:0:0:1: Direct-Access     Generic- Compact Flash    1.=
01 PQ: 0 ANSI: 0
[    3.640249] scsi 6:0:0:2: Direct-Access     Generic- SM/xD-Picture    1.=
02 PQ: 0 ANSI: 0
[    3.640953] scsi 6:0:0:3: Direct-Access     Generic- MS/MS-Pro        1.=
03 PQ: 0 ANSI: 0 CCS
[    3.642352] sd 6:0:0:0: Attached scsi generic sg3 type 0
[    3.643578] sd 6:0:0:1: Attached scsi generic sg4 type 0
[    3.645326] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[    3.646005] sd 6:0:0:2: Attached scsi generic sg5 type 0
[    3.649111] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[    3.649486] sd 6:0:0:3: Attached scsi generic sg6 type 0
[    3.652440] sd 6:0:0:2: [sde] Attached SCSI removable disk
[    3.653185] sd 6:0:0:3: [sdf] Attached SCSI removable disk
[    7.026069] EXT4-fs (sda1): INFO: recovery required on readonly filesyst=
em
[    7.026075] EXT4-fs (sda1): write access will be enabled during recovery
[    7.075807] EXT4-fs (sda1): orphan cleanup on readonly fs
[    7.076147] EXT4-fs (sda1): 1 orphan inode deleted
[    7.076149] EXT4-fs (sda1): recovery complete
[    7.078868] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[    7.175909] random: init urandom read with 105 bits of entropy available
[    7.251242] init: ureadahead main process (225) terminated with status 5
[    7.423764] systemd-udevd[359]: starting version 204
[    7.509805] [drm] Initialized drm 1.1.0 20060810
[    7.510300] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO=
 conflicts with Region \LBAE 1 (20131115/utaddress-251)
[    7.510305] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    7.510306] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO=
 conflicts with Region \LBAE 1 (20131115/utaddress-251)
[    7.510309] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    7.510310] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO=
 conflicts with Region \LBAE 1 (20131115/utaddress-251)
[    7.510313] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    7.510314] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    7.546425] random: nonblocking pool is initialized
[    7.600954] microcode: CPU0 sig=3D0x206a7, pf=3D0x2, revision=3D0x14
[    7.601085] [drm] Memory usable by graphics device =3D 2048M
[    7.602335] platform microcode: Direct firmware load failed with error -=
2
[    7.602339] platform microcode: Falling back to user helper
[    7.614199] cdc_acm 2-1.1:1.0: ttyACM0: USB ACM device
[    7.615849] usbcore: registered new interface driver cdc_acm
[    7.615851] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    7.621887] modprobe (431) used greatest stack depth: 3688 bytes left
[    7.622554] usbcore: registered new interface driver usbserial
[    7.625892] usbcore: registered new interface driver ftdi_sio
[    7.626054] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    7.626116] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[    7.626507] usb 2-1.4: Detected FT2232C
[    7.626510] usb 2-1.4: Number of endpoints 2
[    7.626513] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[    7.626515] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[    7.626518] usb 2-1.4: Setting MaxPacketSize 64
[    7.627308] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[    7.627396] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[    7.627446] usb 2-1.4: Detected FT2232C
[    7.627448] usb 2-1.4: Number of endpoints 2
[    7.627451] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[    7.627453] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[    7.627456] usb 2-1.4: Setting MaxPacketSize 64
[    7.629903] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[    7.654946] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    7.654961] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    7.654962] [drm] Driver supports precise vblank timestamp query.
[    7.655419] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    7.671211] [drm] Wrong MCH_SSKPD value: 0x16040307
[    7.671214] [drm] This can cause pipe underruns and display issues.
[    7.671215] [drm] Please upgrade your BIOS to fix this.
[    7.743984] fbcon: inteldrmfb (fb0) is primary device
[    7.754136] EXT4-fs (sda1): re-mounted. Opts: errors=3Dremount-ro,discar=
d
[    7.767623] microcode: CPU1 sig=3D0x206a7, pf=3D0x2, revision=3D0x14
[    7.767651] platform microcode: Direct firmware load failed with error -=
2
[    7.767652] platform microcode: Falling back to user helper
[    7.775842] microcode: CPU2 sig=3D0x206a7, pf=3D0x2, revision=3D0x14
[    7.775860] platform microcode: Direct firmware load failed with error -=
2
[    7.775861] platform microcode: Falling back to user helper
[    7.776833] microcode: CPU3 sig=3D0x206a7, pf=3D0x2, revision=3D0x14
[    7.776851] platform microcode: Direct firmware load failed with error -=
2
[    7.776852] platform microcode: Falling back to user helper
[    7.777751] microcode: CPU4 sig=3D0x206a7, pf=3D0x2, revision=3D0x14
[    7.777765] platform microcode: Direct firmware load failed with error -=
2
[    7.777766] platform microcode: Falling back to user helper
[    7.778631] microcode: CPU5 sig=3D0x206a7, pf=3D0x2, revision=3D0x14
[    7.778650] platform microcode: Direct firmware load failed with error -=
2
[    7.778651] platform microcode: Falling back to user helper
[    7.780350] microcode: CPU6 sig=3D0x206a7, pf=3D0x2, revision=3D0x14
[    7.780369] platform microcode: Direct firmware load failed with error -=
2
[    7.780371] platform microcode: Falling back to user helper
[    7.781279] microcode: CPU7 sig=3D0x206a7, pf=3D0x2, revision=3D0x14
[    7.781298] platform microcode: Direct firmware load failed with error -=
2
[    7.781299] platform microcode: Falling back to user helper
[    7.782124] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    7.943373] Console: switching to colour frame buffer device 240x75
[    7.951638] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    7.951640] i915 0000:00:02.0: registered panic notifier
[    7.951755] i915: No ACPI video bus found
[    7.951999] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[    7.952698] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    7.971173] ALSA sound/pci/hda/patch_realtek.c:419 SKU: Nid=3D0x1d sku_c=
fg=3D0x4005e601
[    7.971177] ALSA sound/pci/hda/patch_realtek.c:421 SKU: port_connectivit=
y=3D0x1
[    7.971179] ALSA sound/pci/hda/patch_realtek.c:422 SKU: enable_pcbeep=3D=
0x0
[    7.971180] ALSA sound/pci/hda/patch_realtek.c:423 SKU: check_sum=3D0x00=
000005
[    7.971182] ALSA sound/pci/hda/patch_realtek.c:424 SKU: customization=3D=
0x000000e6
[    7.971183] ALSA sound/pci/hda/patch_realtek.c:425 SKU: external_amp=3D0=
x0
[    7.971185] ALSA sound/pci/hda/patch_realtek.c:426 SKU: platform_type=3D=
0x0
[    7.971186] ALSA sound/pci/hda/patch_realtek.c:427 SKU: swap=3D0x0
[    7.971187] ALSA sound/pci/hda/patch_realtek.c:428 SKU: override=3D0x1
[    7.971635] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_ou=
ts=3D4 (0x14/0x15/0x16/0x17/0x0) type:line
[    7.971637] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=3D0=
 (0x0/0x0/0x0/0x0/0x0)
[    7.971639] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=3D1 (0x1=
b/0x0/0x0/0x0/0x0)
[    7.971640] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=
=3D0x0
[    7.971642] ALSA sound/pci/hda/hda_auto_parser.c:405    dig-out=3D0x1e/0=
x0
[    7.971643] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[    7.971647] ALSA sound/pci/hda/hda_auto_parser.c:410      Front Mic=3D0x=
19
[    7.971649] ALSA sound/pci/hda/hda_auto_parser.c:410      Rear Mic=3D0x1=
8
[    7.971651] ALSA sound/pci/hda/hda_auto_parser.c:410      Line=3D0x1a
[    7.971654] ALSA sound/pci/hda/patch_realtek.c:491 realtek: No valid SSI=
D, checking pincfg 0x4005e601 for NID 0x1d
[    7.971655] ALSA sound/pci/hda/patch_realtek.c:507 realtek: Enabling ini=
t ASM_ID=3D0xe601 CODEC_ID=3D10ec0887
[    7.995862] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input15
[    7.996089] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input14
[    7.996193] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/00=
00:00:1b.0/sound/card0/input13
[    7.996305] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/00=
00:00:1b.0/sound/card0/input12
[    7.996406] input: HDA Intel PCH Line Out Surround as /devices/pci0000:0=
0/0000:00:1b.0/sound/card0/input11
[    7.996528] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0=
000:00:1b.0/sound/card0/input10
[    7.996612] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.=
0/sound/card0/input9
[    7.996729] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00=
:1b.0/sound/card0/input8
[    7.996842] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:0=
0:1b.0/sound/card0/input7
[    8.142706] init: failsafe main process (702) killed by TERM signal
[    8.232999] Bluetooth: Core ver 2.17
[    8.233029] NET: Registered protocol family 31
[    8.233031] Bluetooth: HCI device and connection manager initialized
[    8.233089] Bluetooth: HCI socket layer initialized
[    8.233095] Bluetooth: L2CAP socket layer initialized
[    8.233106] Bluetooth: SCO socket layer initialized
[    8.246354] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    8.246358] Bluetooth: BNEP filters: protocol multicast
[    8.246371] Bluetooth: BNEP socket layer initialized
[    8.248104] Bluetooth: RFCOMM TTY layer initialized
[    8.248149] Bluetooth: RFCOMM socket layer initialized
[    8.248158] Bluetooth: RFCOMM ver 1.11
[    8.262048] init: avahi-cups-reload main process (828) terminated with s=
tatus 1
[    8.329501] tg3 0000:02:00.0: irq 44 for MSI/MSI-X
[    8.356441] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.815549] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    8.942634] fuse init (API version 7.22)
[    9.064549] tg3 0000:02:00.0 eth0: Link is down
[   11.835954] init: plymouth-stop pre-start process (1591) terminated with=
 status 1
[   12.065901] tg3 0000:02:00.0 eth0: Link is up at 1000 Mbps, full duplex
[   12.065908] tg3 0000:02:00.0 eth0: Flow control is on for TX and on for =
RX
[   12.066008] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 1499.305308] DMA-API: debugging out of memory - disabling
[ 2154.841990] kworker/u16:3 (103) used greatest stack depth: 3528 bytes le=
ft
[ 3503.973325] usb 1-1.3: USB disconnect, device number 3
[ 3589.529938] usb 2-1.4: USB disconnect, device number 5
[ 3589.530782] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[ 3589.530887] ftdi_sio 2-1.4:1.0: device disconnected
[ 3589.531375] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[ 3589.531411] ftdi_sio 2-1.4:1.1: device disconnected
[ 3590.751525] usb 2-1.4: new full-speed USB device number 7 using ehci-pci
[ 3590.846444] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[ 3590.846451] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[ 3590.846454] usb 2-1.4: Product: Dual RS232
[ 3590.846457] usb 2-1.4: Manufacturer: FTDI
[ 3590.847226] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[ 3590.847329] usb 2-1.4: Detected FT2232C
[ 3590.847333] usb 2-1.4: Number of endpoints 2
[ 3590.847336] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 3590.847339] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 3590.847342] usb 2-1.4: Setting MaxPacketSize 64
[ 3590.847882] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[ 3590.848438] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[ 3590.848498] usb 2-1.4: Detected FT2232C
[ 3590.848501] usb 2-1.4: Number of endpoints 2
[ 3590.848504] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 3590.848507] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 3590.848510] usb 2-1.4: Setting MaxPacketSize 64
[ 3590.848869] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[ 3591.835002] usb 2-1.4: USB disconnect, device number 7
[ 3591.835620] ftdi_sio ttyUSB0: error from flowcontrol urb
[ 3591.836113] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[ 3591.836145] ftdi_sio 2-1.4:1.0: device disconnected
[ 3591.836501] ftdi_sio ttyUSB1: error from flowcontrol urb
[ 3591.836723] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[ 3591.836743] ftdi_sio 2-1.4:1.1: device disconnected
[ 3601.508417] usb 2-1.4: new full-speed USB device number 8 using ehci-pci
[ 3601.602682] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[ 3601.602689] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[ 3601.602693] usb 2-1.4: Product: Dual RS232
[ 3601.602696] usb 2-1.4: Manufacturer: FTDI
[ 3601.603329] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[ 3601.603392] usb 2-1.4: Detected FT2232C
[ 3601.603396] usb 2-1.4: Number of endpoints 2
[ 3601.603399] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 3601.603402] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 3601.603405] usb 2-1.4: Setting MaxPacketSize 64
[ 3601.603838] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[ 3601.604389] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[ 3601.604721] usb 2-1.4: Detected FT2232C
[ 3601.604725] usb 2-1.4: Number of endpoints 2
[ 3601.604728] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 3601.604731] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 3601.604734] usb 2-1.4: Setting MaxPacketSize 64
[ 3601.605206] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[ 3621.717849] usb 1-1.3: new low-speed USB device number 4 using ehci-pci
[ 3621.817140] usb 1-1.3: New USB device found, idVendor=3D046d, idProduct=
=3Dc52a
[ 3621.817147] usb 1-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[ 3621.817151] usb 1-1.3: Product: 2.4GHz Cordless Desktop
[ 3621.817154] usb 1-1.3: Manufacturer: Logitech
[ 3621.822948] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input16
[ 3621.823772] hid-generic 0003:046D:C52A.0003: input,hidraw0: USB HID v1.1=
1 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input=
0
[ 3621.832232] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input17
[ 3621.832792] hid-generic 0003:046D:C52A.0004: input,hidraw1: USB HID v1.1=
1 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input1
[ 8055.381009] ftdi_sio ttyUSB0: failed to get modem status: -32
[ 8055.431749] usb 2-1.4: USB disconnect, device number 8
[ 8055.432012] ftdi_sio ttyUSB0: error from flowcontrol urb
[ 8055.432342] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[ 8055.432379] ftdi_sio 2-1.4:1.0: device disconnected
[ 8055.432857] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[ 8055.432893] ftdi_sio 2-1.4:1.1: device disconnected
[ 8071.125275] usb 2-1.4: new full-speed USB device number 9 using ehci-pci
[ 8071.220081] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[ 8071.220088] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[ 8071.220091] usb 2-1.4: Product: Dual RS232
[ 8071.220094] usb 2-1.4: Manufacturer: FTDI
[ 8071.220867] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[ 8071.220964] usb 2-1.4: Detected FT2232C
[ 8071.220970] usb 2-1.4: Number of endpoints 2
[ 8071.220976] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 8071.220981] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 8071.220986] usb 2-1.4: Setting MaxPacketSize 64
[ 8071.221895] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[ 8071.222477] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[ 8071.222571] usb 2-1.4: Detected FT2232C
[ 8071.222577] usb 2-1.4: Number of endpoints 2
[ 8071.222583] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 8071.222588] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 8071.222593] usb 2-1.4: Setting MaxPacketSize 64
[ 8071.223102] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[ 8229.719572] usb 1-1.4: new high-speed USB device number 5 using ehci-pci
[ 8229.812609] usb 1-1.4: New USB device found, idVendor=3D18d1, idProduct=
=3D4ee6
[ 8229.812615] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[ 8229.812617] usb 1-1.4: Product: Nexus 4
[ 8229.812620] usb 1-1.4: Manufacturer: LGE
[ 8229.812622] usb 1-1.4: SerialNumber: 0071fcd4dc56c589
[ 8232.083393] usb 1-1.4: USB disconnect, device number 5
[ 8234.329801] usb 1-1.4: new high-speed USB device number 6 using ehci-pci
[ 8234.422839] usb 1-1.4: New USB device found, idVendor=3D18d1, idProduct=
=3D4ee6
[ 8234.422844] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[ 8234.422847] usb 1-1.4: Product: Nexus 4
[ 8234.422849] usb 1-1.4: Manufacturer: LGE
[ 8234.422852] usb 1-1.4: SerialNumber: 0071fcd4dc56c589
[ 8239.925406] perf samples too long (2501 > 2500), lowering kernel.perf_ev=
ent_max_sample_rate to 50000
[ 9305.737860] INFO: task Cache I/O:2855 blocked for more than 100 seconds.
[ 9305.737867]       Not tainted 3.13.0-imre+ #327
[ 9305.737869] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 9305.737872] Cache I/O       D ffff8804194ba030  5160  2855   1697 0x0000=
0000
[ 9305.737880]  ffff880035b35e48 0000000000000046 ffff880417e9a030 ffff8800=
35b35fd8
[ 9305.737887]  0000000000013a80 0000000000013a80 ffff880417e9a030 ffff8800=
3673d800
[ 9305.737892]  000000000041d7e2 ffff88003673d950 ffff88003673d828 ffff8800=
35b35e88
[ 9305.737898] Call Trace:
[ 9305.737907]  [<ffffffff816a6bc5>] schedule+0x65/0x70
[ 9305.737915]  [<ffffffff81260c9b>] jbd2_log_wait_commit+0xbb/0x110
[ 9305.737921]  [<ffffffff81091c20>] ? prepare_to_wait_event+0x110/0x110
[ 9305.737926]  [<ffffffff81263383>] jbd2_complete_transaction+0x73/0xa0
[ 9305.737932]  [<ffffffff8120d704>] ext4_sync_file+0x2f4/0x370
[ 9305.737937]  [<ffffffff811c1ac1>] do_fsync+0x51/0x80
[ 9305.737942]  [<ffffffff811c1d50>] SyS_fsync+0x10/0x20
[ 9305.737947]  [<ffffffff816b3c52>] system_call_fastpath+0x16/0x1b
[ 9305.737950] no locks held by Cache I/O/2855.
[ 9453.571179] usb 2-1.4: USB disconnect, device number 9
[ 9453.571449] ftdi_sio ttyUSB0: error from flowcontrol urb
[ 9453.571799] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[ 9453.571847] ftdi_sio 2-1.4:1.0: device disconnected
[ 9453.572407] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[ 9453.572451] ftdi_sio 2-1.4:1.1: device disconnected
[ 9455.561132] usb 2-1.4: new full-speed USB device number 10 using ehci-pc=
i
[ 9455.655531] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[ 9455.655538] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[ 9455.655541] usb 2-1.4: Product: Dual RS232
[ 9455.655544] usb 2-1.4: Manufacturer: FTDI
[ 9455.656240] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[ 9455.656335] usb 2-1.4: Detected FT2232C
[ 9455.656339] usb 2-1.4: Number of endpoints 2
[ 9455.656342] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 9455.656345] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 9455.656348] usb 2-1.4: Setting MaxPacketSize 64
[ 9455.656745] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[ 9455.657217] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[ 9455.657264] usb 2-1.4: Detected FT2232C
[ 9455.657266] usb 2-1.4: Number of endpoints 2
[ 9455.657267] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 9455.657269] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 9455.657270] usb 2-1.4: Setting MaxPacketSize 64
[ 9455.657780] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[ 9464.584219] usb 2-1.4: USB disconnect, device number 10
[ 9464.584484] ftdi_sio ttyUSB0: error from flowcontrol urb
[ 9464.584729] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[ 9464.584753] ftdi_sio 2-1.4:1.0: device disconnected
[ 9464.585014] ftdi_sio ttyUSB1: error from flowcontrol urb
[ 9464.585483] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[ 9464.585517] ftdi_sio 2-1.4:1.1: device disconnected
[ 9465.293796] usb 2-1.4: new full-speed USB device number 11 using ehci-pc=
i
[ 9465.388084] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[ 9465.388091] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[ 9465.388094] usb 2-1.4: Product: Dual RS232
[ 9465.388097] usb 2-1.4: Manufacturer: FTDI
[ 9465.388802] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[ 9465.388915] usb 2-1.4: Detected FT2232C
[ 9465.388921] usb 2-1.4: Number of endpoints 2
[ 9465.388927] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 9465.388932] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 9465.388937] usb 2-1.4: Setting MaxPacketSize 64
[ 9465.389453] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[ 9465.389878] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[ 9465.389974] usb 2-1.4: Detected FT2232C
[ 9465.389980] usb 2-1.4: Number of endpoints 2
[ 9465.389986] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 9465.389992] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 9465.389997] usb 2-1.4: Setting MaxPacketSize 64
[ 9465.390397] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[ 9472.267584] usb 2-1.4: USB disconnect, device number 11
[ 9472.268406] ftdi_sio ttyUSB0: error from flowcontrol urb
[ 9472.268682] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[ 9472.268718] ftdi_sio 2-1.4:1.0: device disconnected
[ 9472.269888] ftdi_sio ttyUSB1: error from flowcontrol urb
[ 9472.270413] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[ 9472.270470] ftdi_sio 2-1.4:1.1: device disconnected
[ 9473.489668] usb 2-1.4: new full-speed USB device number 12 using ehci-pc=
i
[ 9473.584557] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[ 9473.584564] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[ 9473.584567] usb 2-1.4: Product: Dual RS232
[ 9473.584571] usb 2-1.4: Manufacturer: FTDI
[ 9473.585477] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[ 9473.585569] usb 2-1.4: Detected FT2232C
[ 9473.585573] usb 2-1.4: Number of endpoints 2
[ 9473.585576] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 9473.585579] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 9473.585582] usb 2-1.4: Setting MaxPacketSize 64
[ 9473.586229] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[ 9473.586583] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[ 9473.586642] usb 2-1.4: Detected FT2232C
[ 9473.586645] usb 2-1.4: Number of endpoints 2
[ 9473.586648] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 9473.586651] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 9473.586654] usb 2-1.4: Setting MaxPacketSize 64
[ 9473.587144] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[ 9756.813002] usb 2-1.4: USB disconnect, device number 12
[ 9756.813271] ftdi_sio ttyUSB0: error from flowcontrol urb
[ 9756.813622] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[ 9756.813658] ftdi_sio 2-1.4:1.0: device disconnected
[ 9756.814138] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[ 9756.814174] ftdi_sio 2-1.4:1.1: device disconnected
[ 9757.015892] usb 2-1.4: new full-speed USB device number 13 using ehci-pc=
i
[ 9757.110871] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[ 9757.110878] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[ 9757.110881] usb 2-1.4: Product: Dual RS232
[ 9757.110884] usb 2-1.4: Manufacturer: FTDI
[ 9757.111562] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[ 9757.111656] usb 2-1.4: Detected FT2232C
[ 9757.111659] usb 2-1.4: Number of endpoints 2
[ 9757.111662] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 9757.111665] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 9757.111668] usb 2-1.4: Setting MaxPacketSize 64
[ 9757.112195] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[ 9757.112543] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[ 9757.112600] usb 2-1.4: Detected FT2232C
[ 9757.112603] usb 2-1.4: Number of endpoints 2
[ 9757.112606] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[ 9757.112609] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[ 9757.112612] usb 2-1.4: Setting MaxPacketSize 64
[ 9757.113183] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[11241.569133] ftdi_sio ttyUSB0: failed to get modem status: -32
[11241.775760] usb 2-1.4: USB disconnect, device number 13
[11241.776027] ftdi_sio ttyUSB0: error from flowcontrol urb
[11241.776325] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[11241.776359] ftdi_sio 2-1.4:1.0: device disconnected
[11241.776732] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[11241.776751] ftdi_sio 2-1.4:1.1: device disconnected
[11244.025104] usb 2-1.4: new full-speed USB device number 14 using ehci-pc=
i
[11244.120043] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[11244.120049] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[11244.120053] usb 2-1.4: Product: Dual RS232
[11244.120056] usb 2-1.4: Manufacturer: FTDI
[11244.120758] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[11244.120905] usb 2-1.4: Detected FT2232C
[11244.120910] usb 2-1.4: Number of endpoints 2
[11244.120915] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[11244.120918] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[11244.120921] usb 2-1.4: Setting MaxPacketSize 64
[11244.121374] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[11244.121777] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[11244.121835] usb 2-1.4: Detected FT2232C
[11244.121838] usb 2-1.4: Number of endpoints 2
[11244.121841] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[11244.121844] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[11244.121847] usb 2-1.4: Setting MaxPacketSize 64
[11244.122206] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[12584.525663] usb 1-1.4: USB disconnect, device number 6
[14502.192531] kworker/u16:5 (105) used greatest stack depth: 3512 bytes le=
ft
[14862.237347] usb 2-1.4: USB disconnect, device number 14
[14862.237616] ftdi_sio ttyUSB0: error from flowcontrol urb
[14862.237953] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[14862.238061] ftdi_sio 2-1.4:1.0: device disconnected
[14862.238565] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[14862.238613] ftdi_sio 2-1.4:1.1: device disconnected
[14864.484865] usb 2-1.4: new full-speed USB device number 15 using ehci-pc=
i
[14864.579990] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[14864.579996] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[14864.580000] usb 2-1.4: Product: Dual RS232
[14864.580003] usb 2-1.4: Manufacturer: FTDI
[14864.580704] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[14864.580855] usb 2-1.4: Detected FT2232C
[14864.580862] usb 2-1.4: Number of endpoints 2
[14864.580868] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[14864.580875] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[14864.580880] usb 2-1.4: Setting MaxPacketSize 64
[14864.581453] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[14864.581837] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[14864.581898] usb 2-1.4: Detected FT2232C
[14864.581902] usb 2-1.4: Number of endpoints 2
[14864.581905] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[14864.581908] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[14864.581910] usb 2-1.4: Setting MaxPacketSize 64
[14864.582518] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[15208.552297] INFO: task Cache I/O:2855 blocked for more than 100 seconds.
[15208.552305]       Not tainted 3.13.0-imre+ #327
[15208.552307] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[15208.552310] Cache I/O       D ffff8804194b8000  5160  2855   1697 0x0000=
0004
[15208.552318]  ffff880035b35e48 0000000000000046 ffff880417e9a030 ffff8800=
35b35fd8
[15208.552325]  0000000000013a80 0000000000013a80 ffff880417e9a030 ffff8800=
3673d800
[15208.552330]  000000000043c31a ffff88003673d950 ffff88003673d828 ffff8800=
35b35e88
[15208.552336] Call Trace:
[15208.552345]  [<ffffffff816a6bc5>] schedule+0x65/0x70
[15208.552353]  [<ffffffff81260c9b>] jbd2_log_wait_commit+0xbb/0x110
[15208.552359]  [<ffffffff81091c20>] ? prepare_to_wait_event+0x110/0x110
[15208.552364]  [<ffffffff81263383>] jbd2_complete_transaction+0x73/0xa0
[15208.552370]  [<ffffffff8120d704>] ext4_sync_file+0x2f4/0x370
[15208.552375]  [<ffffffff811c1ac1>] do_fsync+0x51/0x80
[15208.552380]  [<ffffffff811c1d50>] SyS_fsync+0x10/0x20
[15208.552385]  [<ffffffff816b3c52>] system_call_fastpath+0x16/0x1b
[15208.552389] no locks held by Cache I/O/2855.
[15607.792078] usb 2-1.2: USB disconnect, device number 4
[33484.477546] type=3D1006 audit(1392935827.805:2): pid=3D23433 uid=3D0 old=
 auid=3D4294967295 new auid=3D1000 old ses=3D4294967295 new ses=3D1 res=3D1
[33611.965380] type=3D1006 audit(1392935955.228:3): pid=3D23523 uid=3D0 old=
 auid=3D4294967295 new auid=3D1000 old ses=3D4294967295 new ses=3D2 res=3D1
[35177.485306] type=3D1006 audit(1392937520.005:4): pid=3D23757 uid=3D0 old=
 auid=3D4294967295 new auid=3D1000 old ses=3D4294967295 new ses=3D3 res=3D1
[35339.760157] type=3D1006 audit(1392937682.199:5): pid=3D23827 uid=3D0 old=
 auid=3D4294967295 new auid=3D1000 old ses=3D4294967295 new ses=3D4 res=3D1
[72974.578854] type=3D1006 audit(1392975299.150:6): pid=3D27780 uid=3D0 old=
 auid=3D4294967295 new auid=3D1000 old ses=3D4294967295 new ses=3D5 res=3D1
[80078.890970] usb 2-1.2: new high-speed USB device number 16 using ehci-pc=
i
[80078.983263] usb 2-1.2: New USB device found, idVendor=3D0409, idProduct=
=3D005a
[80078.983269] usb 2-1.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[80078.983837] hub 2-1.2:1.0: USB hub found
[80078.983997] hub 2-1.2:1.0: 4 ports detected
[80112.726967] usb 1-1.4: new high-speed USB device number 7 using ehci-pci
[80112.820657] usb 1-1.4: New USB device found, idVendor=3D18d1, idProduct=
=3D4ee6
[80112.820663] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[80112.820666] usb 1-1.4: Product: Nexus 4
[80112.820669] usb 1-1.4: Manufacturer: LGE
[80112.820672] usb 1-1.4: SerialNumber: 0071fcd4dc56c589
[80116.342638] usb 2-1.4: USB disconnect, device number 15
[80116.342902] ftdi_sio ttyUSB0: error from flowcontrol urb
[80116.343222] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[80116.343258] ftdi_sio 2-1.4:1.0: device disconnected
[80116.343738] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[80116.343774] ftdi_sio 2-1.4:1.1: device disconnected
[80130.371360] usb 2-1.4: new full-speed USB device number 17 using ehci-pc=
i
[80130.466246] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[80130.466251] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[80130.466254] usb 2-1.4: Product: Dual RS232
[80130.466256] usb 2-1.4: Manufacturer: FTDI
[80130.466913] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[80130.466983] usb 2-1.4: Detected FT2232C
[80130.466986] usb 2-1.4: Number of endpoints 2
[80130.466990] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[80130.466993] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[80130.466996] usb 2-1.4: Setting MaxPacketSize 64
[80130.467443] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[80130.467888] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[80130.467927] usb 2-1.4: Detected FT2232C
[80130.467930] usb 2-1.4: Number of endpoints 2
[80130.467932] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[80130.467934] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[80130.467935] usb 2-1.4: Setting MaxPacketSize 64
[80130.468317] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[80259.511519] usb 2-1.4: USB disconnect, device number 17
[80259.511786] ftdi_sio ttyUSB0: error from flowcontrol urb
[80259.512122] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[80259.512159] ftdi_sio 2-1.4:1.0: device disconnected
[80259.512630] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[80259.512665] ftdi_sio 2-1.4:1.1: device disconnected
[80259.744784] usb 2-1.4: new full-speed USB device number 18 using ehci-pc=
i
[80259.839203] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[80259.839210] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[80259.839213] usb 2-1.4: Product: Dual RS232
[80259.839216] usb 2-1.4: Manufacturer: FTDI
[80259.839993] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[80259.840103] usb 2-1.4: Detected FT2232C
[80259.840107] usb 2-1.4: Number of endpoints 2
[80259.840110] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[80259.840113] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[80259.840116] usb 2-1.4: Setting MaxPacketSize 64
[80259.840552] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[80259.840972] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[80259.841029] usb 2-1.4: Detected FT2232C
[80259.841032] usb 2-1.4: Number of endpoints 2
[80259.841035] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[80259.841038] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[80259.841041] usb 2-1.4: Setting MaxPacketSize 64
[80259.841589] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[80285.566754] usb 1-1.3: USB disconnect, device number 4
[81039.642077] usb 2-1.4: USB disconnect, device number 18
[81039.642338] ftdi_sio ttyUSB0: error from flowcontrol urb
[81039.642626] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[81039.642659] ftdi_sio 2-1.4:1.0: device disconnected
[81039.643290] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[81039.643338] ftdi_sio 2-1.4:1.1: device disconnected
[81051.552547] usb 1-1.3: new low-speed USB device number 8 using ehci-pci
[81051.651862] usb 1-1.3: New USB device found, idVendor=3D046d, idProduct=
=3Dc52a
[81051.651868] usb 1-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[81051.651872] usb 1-1.3: Product: 2.4GHz Cordless Desktop
[81051.651875] usb 1-1.3: Manufacturer: Logitech
[81051.657647] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input18
[81051.658071] hid-generic 0003:046D:C52A.0005: input,hidraw0: USB HID v1.1=
1 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input=
0
[81051.666993] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input19
[81051.667479] hid-generic 0003:046D:C52A.0006: input,hidraw1: USB HID v1.1=
1 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input1
[81070.563663] usb 1-1.4: USB disconnect, device number 7
[81354.608431] usb 2-1.4: new full-speed USB device number 19 using ehci-pc=
i
[81354.703032] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[81354.703039] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[81354.703043] usb 2-1.4: Product: Dual RS232
[81354.703046] usb 2-1.4: Manufacturer: FTDI
[81354.703715] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[81354.703811] usb 2-1.4: Detected FT2232C
[81354.703817] usb 2-1.4: Number of endpoints 2
[81354.703822] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81354.703827] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81354.703833] usb 2-1.4: Setting MaxPacketSize 64
[81354.704317] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[81354.704858] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[81354.704991] usb 2-1.4: Detected FT2232C
[81354.704997] usb 2-1.4: Number of endpoints 2
[81354.705002] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81354.705007] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81354.705012] usb 2-1.4: Setting MaxPacketSize 64
[81354.705390] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[81356.201840] usb 2-1.4: USB disconnect, device number 19
[81356.202038] ftdi_sio ttyUSB0: error from flowcontrol urb
[81356.202302] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[81356.202335] ftdi_sio 2-1.4:1.0: device disconnected
[81356.202839] ftdi_sio ttyUSB1: error from flowcontrol urb
[81356.203631] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[81356.203704] ftdi_sio 2-1.4:1.1: device disconnected
[81368.951170] usb 2-1.4: new full-speed USB device number 20 using ehci-pc=
i
[81369.046077] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[81369.046083] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[81369.046087] usb 2-1.4: Product: Dual RS232
[81369.046090] usb 2-1.4: Manufacturer: FTDI
[81369.046852] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[81369.046924] usb 2-1.4: Detected FT2232C
[81369.046928] usb 2-1.4: Number of endpoints 2
[81369.046931] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81369.046934] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81369.046937] usb 2-1.4: Setting MaxPacketSize 64
[81369.047594] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[81369.048075] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[81369.048168] usb 2-1.4: Detected FT2232C
[81369.048171] usb 2-1.4: Number of endpoints 2
[81369.048174] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81369.048177] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81369.048180] usb 2-1.4: Setting MaxPacketSize 64
[81369.048526] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[81374.642363] usb 2-1.4: USB disconnect, device number 20
[81374.642643] ftdi_sio ttyUSB0: error from flowcontrol urb
[81374.642997] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[81374.643050] ftdi_sio 2-1.4:1.0: device disconnected
[81374.643466] ftdi_sio ttyUSB1: error from flowcontrol urb
[81374.643757] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[81374.643799] ftdi_sio 2-1.4:1.1: device disconnected
[81414.527995] usb 1-1.3: USB disconnect, device number 8
[81416.845929] usb 2-1.4: new full-speed USB device number 21 using ehci-pc=
i
[81416.940842] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[81416.940848] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[81416.940852] usb 2-1.4: Product: Dual RS232
[81416.940855] usb 2-1.4: Manufacturer: FTDI
[81416.941614] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[81416.941769] usb 2-1.4: Detected FT2232C
[81416.941773] usb 2-1.4: Number of endpoints 2
[81416.941776] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81416.941779] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81416.941786] usb 2-1.4: Setting MaxPacketSize 64
[81416.942242] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[81416.942588] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[81416.942645] usb 2-1.4: Detected FT2232C
[81416.942649] usb 2-1.4: Number of endpoints 2
[81416.942652] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81416.942655] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81416.942658] usb 2-1.4: Setting MaxPacketSize 64
[81416.943043] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[81435.298688] usb 1-1.3: new low-speed USB device number 9 using ehci-pci
[81435.397478] usb 1-1.3: New USB device found, idVendor=3D046d, idProduct=
=3Dc52a
[81435.397484] usb 1-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[81435.397488] usb 1-1.3: Product: 2.4GHz Cordless Desktop
[81435.397491] usb 1-1.3: Manufacturer: Logitech
[81435.403171] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input20
[81435.403570] hid-generic 0003:046D:C52A.0007: input,hidraw0: USB HID v1.1=
1 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input=
0
[81435.412219] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input21
[81435.412787] hid-generic 0003:046D:C52A.0008: input,hidraw1: USB HID v1.1=
1 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input1
[81461.767172] ftdi_sio ttyUSB0: failed to get modem status: -32
[81461.767535] ftdi_sio ttyUSB0: error from flowcontrol urb
[81461.768662] ftdi_sio ttyUSB0: ftdi_set_termios FAILED to set databits/st=
opbits/parity
[81461.769036] ftdi_sio ttyUSB0: ftdi_set_termios urb failed to set baudrat=
e
[81461.769410] ftdi_sio ttyUSB0: urb failed to set to xon/xoff flow control
[81461.770789] ftdi_sio ttyUSB0: ftdi_set_termios urb failed to set baudrat=
e
[81461.771165] ftdi_sio ttyUSB0: urb failed to clear flow control
[81461.771538] ftdi_sio ttyUSB0: Unable to write latency timer: -32
[81461.771960] ftdi_sio ttyUSB0: failed to get modem status: -32
[81461.772793] ftdi_sio ttyUSB0: ftdi_set_termios urb failed to set baudrat=
e
[81461.773163] ftdi_sio ttyUSB0: urb failed to clear flow control
[81461.773699] ftdi_sio ttyUSB0: failed to get modem status: -32
[81461.774550] ftdi_sio ttyUSB0: urb failed to clear flow control
[81461.774915] ftdi_sio ttyUSB0: urb failed to clear flow control
[81461.775665] ftdi_sio ttyUSB0: urb failed to clear flow control
[81461.778303] ftdi_sio ttyUSB0: failed to get modem status: -32
[81461.778667] ftdi_sio ttyUSB0: failed to get modem status: -32
[81461.978027] usb 2-1.4: USB disconnect, device number 21
[81461.978299] ftdi_sio ttyUSB0: error from flowcontrol urb
[81461.978657] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[81461.978705] ftdi_sio 2-1.4:1.0: device disconnected
[81461.979321] ftdi_sio ttyUSB1: error from flowcontrol urb
[81461.979620] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[81461.979664] ftdi_sio 2-1.4:1.1: device disconnected
[81462.687648] usb 2-1.4: new full-speed USB device number 22 using ehci-pc=
i
[81462.782202] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[81462.782208] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[81462.782212] usb 2-1.4: Product: Dual RS232
[81462.782215] usb 2-1.4: Manufacturer: FTDI
[81462.782966] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[81462.783086] usb 2-1.4: Detected FT2232C
[81462.783090] usb 2-1.4: Number of endpoints 2
[81462.783093] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81462.783096] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81462.783098] usb 2-1.4: Setting MaxPacketSize 64
[81462.783572] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[81462.783947] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[81462.784006] usb 2-1.4: Detected FT2232C
[81462.784009] usb 2-1.4: Number of endpoints 2
[81462.784012] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81462.784015] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81462.784018] usb 2-1.4: Setting MaxPacketSize 64
[81462.784427] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[81496.041368] usb 2-1.4: USB disconnect, device number 22
[81496.041962] ftdi_sio ttyUSB0: error from flowcontrol urb
[81496.042337] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[81496.042387] ftdi_sio 2-1.4:1.0: device disconnected
[81496.042786] ftdi_sio ttyUSB1: error from flowcontrol urb
[81496.043080] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[81496.043112] ftdi_sio 2-1.4:1.1: device disconnected
[81496.751930] usb 2-1.4: new full-speed USB device number 23 using ehci-pc=
i
[81498.800801] usb 2-1.4: new full-speed USB device number 24 using ehci-pc=
i
[81498.895183] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[81498.895190] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[81498.895193] usb 2-1.4: Product: Dual RS232
[81498.895196] usb 2-1.4: Manufacturer: FTDI
[81498.895851] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[81498.895925] usb 2-1.4: Detected FT2232C
[81498.895927] usb 2-1.4: Number of endpoints 2
[81498.895929] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81498.895931] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81498.895933] usb 2-1.4: Setting MaxPacketSize 64
[81498.896286] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[81498.896561] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[81498.896618] usb 2-1.4: Detected FT2232C
[81498.896621] usb 2-1.4: Number of endpoints 2
[81498.896624] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[81498.896626] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[81498.896629] usb 2-1.4: Setting MaxPacketSize 64
[81498.896984] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[84669.058349] usb 1-1.3: USB disconnect, device number 9
[84756.147185] usb 2-1.4: USB disconnect, device number 24
[84756.147730] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[84756.147769] ftdi_sio 2-1.4:1.0: device disconnected
[84756.148248] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[84756.148284] ftdi_sio 2-1.4:1.1: device disconnected
[84758.651395] usb 2-1.4: new full-speed USB device number 25 using ehci-pc=
i
[84758.745769] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[84758.745776] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[84758.745780] usb 2-1.4: Product: Dual RS232
[84758.745783] usb 2-1.4: Manufacturer: FTDI
[84758.746436] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[84758.746520] usb 2-1.4: Detected FT2232C
[84758.746523] usb 2-1.4: Number of endpoints 2
[84758.746527] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[84758.746530] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[84758.746532] usb 2-1.4: Setting MaxPacketSize 64
[84758.746968] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[84758.747447] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[84758.747511] usb 2-1.4: Detected FT2232C
[84758.747515] usb 2-1.4: Number of endpoints 2
[84758.747518] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[84758.747521] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[84758.747524] usb 2-1.4: Setting MaxPacketSize 64
[84758.747980] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[85420.257214] usb 2-1.4: USB disconnect, device number 25
[85420.257756] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[85420.257795] ftdi_sio 2-1.4:1.0: device disconnected
[85420.258275] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[85420.258310] ftdi_sio 2-1.4:1.1: device disconnected
[85428.141020] usb 2-1.4: new full-speed USB device number 26 using ehci-pc=
i
[85428.236440] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[85428.236447] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[85428.236450] usb 2-1.4: Product: Dual RS232
[85428.236453] usb 2-1.4: Manufacturer: FTDI
[85428.237739] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[85428.237843] usb 2-1.4: Detected FT2232C
[85428.237849] usb 2-1.4: Number of endpoints 2
[85428.237855] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[85428.237860] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[85428.237865] usb 2-1.4: Setting MaxPacketSize 64
[85428.238319] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[85428.238793] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[85428.238853] usb 2-1.4: Detected FT2232C
[85428.238856] usb 2-1.4: Number of endpoints 2
[85428.238859] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[85428.238862] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[85428.238865] usb 2-1.4: Setting MaxPacketSize 64
[85428.239247] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[85431.974714] usb 1-1.3: new low-speed USB device number 10 using ehci-pci
[85432.073756] usb 1-1.3: New USB device found, idVendor=3D046d, idProduct=
=3Dc52a
[85432.073759] usb 1-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[85432.073761] usb 1-1.3: Product: 2.4GHz Cordless Desktop
[85432.073762] usb 1-1.3: Manufacturer: Logitech
[85432.079097] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input22
[85432.079376] hid-generic 0003:046D:C52A.0009: input,hidraw0: USB HID v1.1=
1 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input=
0
[85432.087619] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:=
00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input23
[85432.087971] hid-generic 0003:046D:C52A.000A: input,hidraw1: USB HID v1.1=
1 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:1a.0-1.3/input1
[85713.254204] usb 2-1.4: USB disconnect, device number 26
[85713.254762] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[85713.254801] ftdi_sio 2-1.4:1.0: device disconnected
[85713.255280] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[85713.255316] ftdi_sio 2-1.4:1.1: device disconnected
[85716.269705] usb 2-1.4: new full-speed USB device number 27 using ehci-pc=
i
[85716.367943] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[85716.367948] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[85716.367950] usb 2-1.4: Product: Dual RS232
[85716.367953] usb 2-1.4: Manufacturer: FTDI
[85716.368608] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[85716.368661] usb 2-1.4: Detected FT2232C
[85716.368664] usb 2-1.4: Number of endpoints 2
[85716.368666] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[85716.368669] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[85716.368671] usb 2-1.4: Setting MaxPacketSize 64
[85716.369078] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[85716.369476] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[85716.369515] usb 2-1.4: Detected FT2232C
[85716.369517] usb 2-1.4: Number of endpoints 2
[85716.369520] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[85716.369529] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[85716.369532] usb 2-1.4: Setting MaxPacketSize 64
[85716.369886] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[85970.651155] usb 2-1.4: USB disconnect, device number 27
[85970.651699] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[85970.651739] ftdi_sio 2-1.4:1.0: device disconnected
[85970.652218] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[85970.652254] ftdi_sio 2-1.4:1.1: device disconnected
[85971.010603] usb 2-1.4: new full-speed USB device number 28 using ehci-pc=
i
[85971.105270] usb 2-1.4: New USB device found, idVendor=3D0403, idProduct=
=3D6010
[85971.105276] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[85971.105280] usb 2-1.4: Product: Dual RS232
[85971.105283] usb 2-1.4: Manufacturer: FTDI
[85971.105947] ftdi_sio 2-1.4:1.0: FTDI USB Serial Device converter detecte=
d
[85971.106058] usb 2-1.4: Detected FT2232C
[85971.106061] usb 2-1.4: Number of endpoints 2
[85971.106064] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[85971.106067] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[85971.106070] usb 2-1.4: Setting MaxPacketSize 64
[85971.106502] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB0
[85971.106931] ftdi_sio 2-1.4:1.1: FTDI USB Serial Device converter detecte=
d
[85971.107031] usb 2-1.4: Detected FT2232C
[85971.107037] usb 2-1.4: Number of endpoints 2
[85971.107042] usb 2-1.4: Endpoint 1 MaxPacketSize 64
[85971.107048] usb 2-1.4: Endpoint 2 MaxPacketSize 64
[85971.107053] usb 2-1.4: Setting MaxPacketSize 64
[85971.107486] usb 2-1.4: FTDI USB Serial Device converter now attached to =
ttyUSB1
[86517.459670] usb 2-1.4: USB disconnect, device number 28
[86517.460219] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[86517.460259] ftdi_sio 2-1.4:1.0: device disconnected
[86517.460707] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[86517.460738] ftdi_sio 2-1.4:1.1: device disconnected
[86600.697409] usb 2-1.2: USB disconnect, device number 16
[86619.594391] usb 2-1.2: new high-speed USB device number 29 using ehci-pc=
i
[86620.362725] usb 2-1.2: new high-speed USB device number 30 using ehci-pc=
i
[86620.455034] usb 2-1.2: New USB device found, idVendor=3D0409, idProduct=
=3D005a
[86620.455041] usb 2-1.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[86620.455598] hub 2-1.2:1.0: USB hub found
[86620.455759] hub 2-1.2:1.0: 4 ports detected
[86621.955195] usb 2-1.2: USB disconnect, device number 30
[86644.690287] usb 2-1.2: new high-speed USB device number 31 using ehci-pc=
i
[86645.178304] usb 2-1.2: device not accepting address 31, error -71
[86645.394561] usb 2-1.2: new high-speed USB device number 33 using ehci-pc=
i
[86645.486843] usb 2-1.2: New USB device found, idVendor=3D0409, idProduct=
=3D005a
[86645.486848] usb 2-1.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[86645.487144] hub 2-1.2:1.0: USB hub found
[86645.487212] hub 2-1.2:1.0: 4 ports detected
[86647.054603] usb 2-1.2: USB disconnect, device number 33
[86663.387163] usb 2-1.2: new high-speed USB device number 34 using ehci-pc=
i
[86663.899406] usb 2-1.2: new high-speed USB device number 35 using ehci-pc=
i
[86663.991682] usb 2-1.2: New USB device found, idVendor=3D0409, idProduct=
=3D005a
[86663.991689] usb 2-1.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[86663.992089] hub 2-1.2:1.0: USB hub found
[86663.992294] hub 2-1.2:1.0: 4 ports detected
[86666.007185] usb 2-1.2: USB disconnect, device number 35
[86695.914570] usb 2-1.2: new high-speed USB device number 36 using ehci-pc=
i
[86696.402686] usb 2-1.2: device not accepting address 36, error -71
[86696.618885] usb 2-1.2: new high-speed USB device number 38 using ehci-pc=
i
[86696.711597] usb 2-1.2: New USB device found, idVendor=3D0409, idProduct=
=3D005a
[86696.711603] usb 2-1.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[86696.712131] hub 2-1.2:1.0: USB hub found
[86696.712291] hub 2-1.2:1.0: 4 ports detected
[86881.144870] usb 2-1.2: USB disconnect, device number 38
[87769.812428] usb 2-1.2: new high-speed USB device number 39 using ehci-pc=
i
[87770.580740] usb 2-1.2: new high-speed USB device number 40 using ehci-pc=
i
[87770.673024] usb 2-1.2: New USB device found, idVendor=3D0409, idProduct=
=3D005a
[87770.673030] usb 2-1.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[87770.673446] hub 2-1.2:1.0: USB hub found
[87770.673641] hub 2-1.2:1.0: 4 ports detected
[88032.032811] usb 1-1.1: new high-speed USB device number 11 using ehci-pc=
i
[88032.132233] usb 1-1.1: New USB device found, idVendor=3D18a5, idProduct=
=3D0302
[88032.132240] usb 1-1.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[88032.132244] usb 1-1.1: Product: STORE N GO
[88032.132247] usb 1-1.1: Manufacturer: Verbatim
[88032.132250] usb 1-1.1: SerialNumber: 07BB01013C483120
[88032.132850] usb-storage 1-1.1:1.0: USB Mass Storage device detected
[88032.133127] scsi7 : usb-storage 1-1.1:1.0
[88033.166905] scsi 7:0:0:0: Direct-Access     Verbatim STORE N GO       5.=
00 PQ: 0 ANSI: 4
[88033.168228] sd 7:0:0:0: Attached scsi generic sg7 type 0
[88034.567777] sd 7:0:0:0: [sdg] 31248384 512-byte logical blocks: (15.9 GB=
/14.9 GiB)
[88034.568580] sd 7:0:0:0: [sdg] Write Protect is off
[88034.568585] sd 7:0:0:0: [sdg] Mode Sense: 23 00 00 00
[88034.569305] sd 7:0:0:0: [sdg] No Caching mode page found
[88034.569310] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[88034.574718] sd 7:0:0:0: [sdg] No Caching mode page found
[88034.574725] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[88034.607334]  sdg: sdg1 sdg2
[88034.611203] sd 7:0:0:0: [sdg] No Caching mode page found
[88034.611210] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[88034.611214] sd 7:0:0:0: [sdg] Attached SCSI removable disk
[88036.411063] ISO 9660 Extensions: Microsoft Joliet Level 3
[88036.416542] ISO 9660 Extensions: RRIP_1991A
[88036.424202] init: ureadahead-other main process (30128) terminated with =
status 2
[88274.377324] usb 1-1.1: USB disconnect, device number 11
[88274.416168] ------------[ cut here ]------------
[88274.416180] WARNING: CPU: 3 PID: 30190 at fs/sysfs/group.c:214 sysfs_rem=
ove_group+0x53/0xd0()
[88274.416184] sysfs group ffffffff81c99820 not found for kobject 'target7:=
0:0'
[88274.416186] Modules linked in: nls_utf8 fuse rfcomm bnep bluetooth rfkil=
l snd_hda_codec_hdmi snd_hda_codec_realtek kvm_intel kvm crc32c_intel snd_h=
da_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss ftdi_sio usbseri=
al snd_pcm cdc_acm snd_seq_dummy snd_page_alloc snd_seq_oss microcode serio=
_raw i915 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_seq_devic=
e snd_timer snd cfbfillrect soundcore cfbimgblt i2c_algo_bit cfbcopyarea dr=
m_kms_helper lpc_ich drm mfd_core usb_storage usbhid
[88274.416236] CPU: 3 PID: 30190 Comm: umount Not tainted 3.13.0-imre+ #327
[88274.416239] Hardware name: Dell Inc. XPS 8300  /0Y2MRG, BIOS A03 02/15/2=
011
[88274.416241]  0000000000000009 ffff8803b7b6fb48 ffffffff816a32a6 ffff8803=
b7b6fb90
[88274.416248]  ffff8803b7b6fb80 ffffffff8104f75d 0000000000000000 ffffffff=
81c99820
[88274.416253]  ffff880027632838 ffff88015cbca278 ffff8803bf794000 ffff8803=
b7b6fbe0
[88274.416259] Call Trace:
[88274.416267]  [<ffffffff816a32a6>] dump_stack+0x4e/0x7a
[88274.416273]  [<ffffffff8104f75d>] warn_slowpath_common+0x7d/0xa0
[88274.416278]  [<ffffffff8104f7cc>] warn_slowpath_fmt+0x4c/0x50
[88274.416283]  [<ffffffff816aa25e>] ? mutex_unlock+0xe/0x10
[88274.416288]  [<ffffffff81203fc7>] ? sysfs_get_dirent_ns+0x67/0x80
[88274.416292]  [<ffffffff81205293>] sysfs_remove_group+0x53/0xd0
[88274.416298]  [<ffffffff813d34f3>] dpm_sysfs_remove+0x43/0x50
[88274.416303]  [<ffffffff813c95d5>] device_del+0x45/0x1d0
[88274.416309]  [<ffffffff813fa497>] scsi_target_reap_usercontext+0x27/0x40
[88274.416314]  [<ffffffff813fa470>] ? scsi_target_destroy+0xc0/0xc0
[88274.416320]  [<ffffffff81069e8c>] execute_in_process_context+0x2c/0x90
[88274.416324]  [<ffffffff813fb984>] scsi_target_reap+0xc4/0xf0
[88274.416330]  [<ffffffff813fdbea>] scsi_device_dev_release_usercontext+0x=
14a/0x1d0
[88274.416334]  [<ffffffff813fdaa0>] ? scsi_device_dev_release+0x20/0x20
[88274.416339]  [<ffffffff81069e8c>] execute_in_process_context+0x2c/0x90
[88274.416344]  [<ffffffff813fda9c>] scsi_device_dev_release+0x1c/0x20
[88274.416348]  [<ffffffff813c88ed>] device_release+0x5d/0xa0
[88274.416354]  [<ffffffff812d5335>] kobject_cleanup+0x145/0x180
[88274.416358]  [<ffffffff812d5138>] kobject_put+0x48/0x50
[88274.416364]  [<ffffffff813c8be7>] put_device+0x17/0x20
[88274.416369]  [<ffffffff813effd3>] scsi_device_put+0x43/0x50
[88274.416374]  [<ffffffff81407822>] scsi_disk_put+0x32/0x50
[88274.416379]  [<ffffffff81407b88>] sd_release+0xb8/0xc0
[88274.416384]  [<ffffffff811cc44e>] __blkdev_put+0xbe/0x190
[88274.416389]  [<ffffffff811cc4e8>] __blkdev_put+0x158/0x190
[88274.416394]  [<ffffffff811ccfce>] blkdev_put+0x12e/0x140
[88274.416399]  [<ffffffff81192ccf>] kill_block_super+0x6f/0x80
[88274.416403]  [<ffffffff8119255d>] deactivate_locked_super+0x3d/0x60
[88274.416407]  [<ffffffff811925d9>] deactivate_super+0x59/0x70
[88274.416413]  [<ffffffff811b155f>] mntput_no_expire+0x14f/0x180
[88274.416417]  [<ffffffff811b1427>] ? mntput_no_expire+0x17/0x180
[88274.416422]  [<ffffffff811b2d85>] SyS_umount+0xc5/0xf0
[88274.416427]  [<ffffffff816b3c52>] system_call_fastpath+0x16/0x1b
[88274.416430] ---[ end trace cc7a046285294002 ]---
[88288.150473] usb 1-1.2: new high-speed USB device number 12 using ehci-pc=
i
[88288.245047] usb 1-1.2: New USB device found, idVendor=3D8564, idProduct=
=3D1000
[88288.245053] usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[88288.245057] usb 1-1.2: Product: Mass Storage Device
[88288.245060] usb 1-1.2: Manufacturer: JetFlash
[88288.245063] usb 1-1.2: SerialNumber: 7711FF1S05AO20QH
[88288.245579] usb-storage 1-1.2:1.0: USB Mass Storage device detected
[88288.246881] scsi8 : usb-storage 1-1.2:1.0
[88289.428277] scsi 8:0:0:0: Direct-Access     JetFlash Transcend 8GB    11=
00 PQ: 0 ANSI: 4
[88289.429265] sd 8:0:0:0: Attached scsi generic sg7 type 0
[88289.429931] sd 8:0:0:0: [sdg] 15826944 512-byte logical blocks: (8.10 GB=
/7.54 GiB)
[88289.430682] sd 8:0:0:0: [sdg] Write Protect is off
[88289.430689] sd 8:0:0:0: [sdg] Mode Sense: 43 00 00 00
[88289.431547] sd 8:0:0:0: [sdg] No Caching mode page found
[88289.431557] sd 8:0:0:0: [sdg] Assuming drive cache: write through
[88289.435152] sd 8:0:0:0: [sdg] No Caching mode page found
[88289.435158] sd 8:0:0:0: [sdg] Assuming drive cache: write through
[88289.436031]  sdg: sdg1 sdg2
[88289.440008] sd 8:0:0:0: [sdg] No Caching mode page found
[88289.440013] sd 8:0:0:0: [sdg] Assuming drive cache: write through
[88289.440017] sd 8:0:0:0: [sdg] Attached SCSI removable disk
[88289.639259] ISO 9660 Extensions: Microsoft Joliet Level 3
[88289.640361] ISO 9660 Extensions: RRIP_1991A


--=-OOEBtaGiLlVS/1rPJzqP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJTB2CNAAoJEORIIAnNuWDFo+YIAJZ3GQkB/SsDjaSPMwp/gqwT
mg3BLlUK6ST5IkkdGZldpAgm0NlEmUC9jBpDTWksWHiaEf6w/2oUmROP4AL6u8XF
JyubLwBeXoMKhc4ZlX6GVfsRGmpJXeIMxpBcRg/UnGH0SAtaabLNHSaC5CoaikDf
xWYq6BDUdJ4Qlu+iGqwPA9zVLfmhS3t1vXRN3urV6pHMoz+VzdeJQPeunTG9l959
Y7wtsbE9B6wnkhTZfL9CAYqFv/HsfIt26lz2zage4ng+XDFDeFJQbem4xJpioJ3l
TQ35+r+q+RXiPzsOdQZi8YdM7bQFxeD71GRUPzd0o9uMuLI3n/N8H+zSUIA381w=
=d9Wt
-----END PGP SIGNATURE-----

--=-OOEBtaGiLlVS/1rPJzqP--
