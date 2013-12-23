From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [scsi-mq] WARNING: CPU: 0 PID: 99 at block/elevator.c:193
 elevator_init()
Date: Mon, 23 Dec 2013 11:16:24 +0800
Message-ID: <20131223031624.GB23200@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: LKP <fnstml-lkp@cn.fujitsu.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 29ff818720ce09b044652b83e9c70ef474800d54
Author:     Nicholas Bellinger <nab@linux-iscsi.org>
AuthorDate: Thu May 23 22:11:38 2013 -0700
Commit:     Nicholas Bellinger <nab@linux-iscsi.org>
CommitDate: Sun Dec 22 13:00:48 2013 +0000

    scsi-debug: Enable scsi-mq operation
    
    v4 changes:
      - Bump can_queue to 64 for performance testing
      - Enable scsi-mq DIF support
      - Add nop_fs_io module parameter for performance testing
    
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

+-----------------------------------------------------+----+
|                                                     |    |
+-----------------------------------------------------+----+
| boot_successes                                      | 0  |
| boot_failures                                       | 19 |
| WARNING:CPU:PID:at_block/elevator.c:elevator_init() | 19 |
+-----------------------------------------------------+----+

[    4.763205]   CPU 1 -> Queue 0
[    4.764566] ------------[ cut here ]------------
[    4.764566] ------------[ cut here ]------------
[    4.765951] WARNING: CPU: 0 PID: 99 at block/elevator.c:193 elevator_init+0xf0/0xfb()

Attached are the full dmesg and kconfig.

Thanks,
Fengguang

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-athens-16:20131222211843:i386-randconfig-r3-1222:3.13.0-rc3-00015-g3d712c2:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.13.0-rc3-00015-g3d712c2 (kbuild@roam) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Dec 22 21:16:43 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e5fffff]
[    0.000000]  [mem 0x0e400000-0x0e5fffff] page 4k
[    0.000000] BRK [0x023cc000, 0x023ccfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e3fffff]
[    0.000000]  [mem 0x0c000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x023cd000, 0x023cdfff] PGTABLE
[    0.000000] BRK [0x023ce000, 0x023cefff] PGTABLE
[    0.000000] BRK [0x023cf000, 0x023cffff] PGTABLE
[    0.000000] BRK [0x023d0000, 0x023d0fff] PGTABLE
[    0.000000] BRK [0x023d1000, 0x023d1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0fffdfff]
[    0.000000]  [mem 0x0e600000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @cde86000 s1338304 r0 d13376 =
u1351680
[    0.000000] pcpu-alloc: s1338304 r0 d13376 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de88600
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r3-1222/target:scsi-mq=
/.vmlinuz-3d712c22114220c3fb9b7fd646bb808e7a61ce6d-20131222211705-2-athens =
branch=3Dtarget/scsi-mq BOOT_IMAGE=3D/kernel/i386-randconfig-r3-1222/3d712c=
22114220c3fb9b7fd646bb808e7a61ce6d/vmlinuz-3.13.0-rc3-00015-g3d712c2
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 207836K/261744K available (7820K kernel code, 637K r=
wdata, 3424K rodata, 1820K init, 6456K bss, 53908K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6d000 - 0xfffff000   (1608 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff9fe000   ( 754 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1b9d000 - 0xc1d64000   (1820 kB)
[    0.000000]       .data : 0xc17a34f4 - 0xc1b9c780   (4068 kB)
[    0.000000]       .text : 0xc1000000 - 0xc17a34f4   (7821 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd804000 soft=3Dcd806000
[    0.000000] Linux version 3.13.0-rc3-00015-g3d712c2 (kbuild@roam) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Dec 22 21:16:43 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e5fffff]
[    0.000000]  [mem 0x0e400000-0x0e5fffff] page 4k
[    0.000000] BRK [0x023cc000, 0x023ccfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e3fffff]
[    0.000000]  [mem 0x0c000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x023cd000, 0x023cdfff] PGTABLE
[    0.000000] BRK [0x023ce000, 0x023cefff] PGTABLE
[    0.000000] BRK [0x023cf000, 0x023cffff] PGTABLE
[    0.000000] BRK [0x023d0000, 0x023d0fff] PGTABLE
[    0.000000] BRK [0x023d1000, 0x023d1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0fffdfff]
[    0.000000]  [mem 0x0e600000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @cde86000 s1338304 r0 d13376 =
u1351680
[    0.000000] pcpu-alloc: s1338304 r0 d13376 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de88600
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r3-1222/target:scsi-mq=
/.vmlinuz-3d712c22114220c3fb9b7fd646bb808e7a61ce6d-20131222211705-2-athens =
branch=3Dtarget/scsi-mq BOOT_IMAGE=3D/kernel/i386-randconfig-r3-1222/3d712c=
22114220c3fb9b7fd646bb808e7a61ce6d/vmlinuz-3.13.0-rc3-00015-g3d712c2
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 207836K/261744K available (7820K kernel code, 637K r=
wdata, 3424K rodata, 1820K init, 6456K bss, 53908K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6d000 - 0xfffff000   (1608 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff9fe000   ( 754 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1b9d000 - 0xc1d64000   (1820 kB)
[    0.000000]       .data : 0xc17a34f4 - 0xc1b9c780   (4068 kB)
[    0.000000]       .text : 0xc1000000 - 0xc17a34f4   (7821 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd804000 soft=3Dcd806000
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 9 of 9 active objects replaced
[    0.000000] ODEBUG: 9 of 9 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.018 MHz processor
[    0.000000] tsc: Detected 2893.018 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.03 Bogo=
MIPS (lpj=3D28930180)
5786.03 BogoMIPS (lpj=3D28930180)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys memory
[    0.020000] Initializing cgroup subsys memory
[    0.020072] Initializing cgroup subsys devices
[    0.020072] Initializing cgroup subsys devices
[    0.021429] Initializing cgroup subsys freezer
[    0.021429] Initializing cgroup subsys freezer
[    0.022796] Initializing cgroup subsys perf_event
[    0.022796] Initializing cgroup subsys perf_event
[    0.024210] Initializing cgroup subsys net_prio
[    0.024210] Initializing cgroup subsys net_prio
[    0.025593] Initializing cgroup subsys hugetlb
[    0.025593] Initializing cgroup subsys hugetlb
[    0.027121] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027121] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027121] tlb_flushall_shift: 6
[    0.027121] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027121] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027121] tlb_flushall_shift: 6
[    0.030414] debug: unmapping init [mem 0xc1d64000-0xc1d68fff]
[    0.030414] debug: unmapping init [mem 0xc1d64000-0xc1d68fff]
[    0.034070] ACPI: Core revision 20131115
[    0.034070] ACPI: Core revision 20131115
[    0.047942] ACPI:=20
[    0.047942] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.050615] Getting VERSION: 50014
[    0.050615] Getting VERSION: 50014
[    0.051698] Getting VERSION: 50014
[    0.051698] Getting VERSION: 50014
[    0.052705] Getting ID: 0
[    0.052705] Getting ID: 0
[    0.053495] Getting ID: f000000
[    0.053495] Getting ID: f000000
[    0.054460] Getting LVT0: 8700
[    0.054460] Getting LVT0: 8700
[    0.055360] Getting LVT1: 8400
[    0.055360] Getting LVT1: 8400
[    0.056296] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.056296] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.058009] enabled ExtINT on CPU#0
[    0.058009] enabled ExtINT on CPU#0
[    0.061398] ENABLING IO-APIC IRQs
[    0.061398] ENABLING IO-APIC IRQs
[    0.062400] init IO_APIC IRQs
[    0.062400] init IO_APIC IRQs
[    0.063278]  apic 0 pin 0 not connected
[    0.063278]  apic 0 pin 0 not connected
[    0.064444] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.064444] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.066825] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.066825] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.070060] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.070060] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.072434] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.072434] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.074804] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.074804] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.077153] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.077153] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.079577] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.079577] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.080051] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.080051] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.082399] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.082399] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.084755] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.084755] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.090050] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.090050] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.092381] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.092381] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.094736] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.094736] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.097070] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.097070] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.100055] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.100055] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.102400]  apic 0 pin 16 not connected
[    0.102400]  apic 0 pin 16 not connected
[    0.103539]  apic 0 pin 17 not connected
[    0.103539]  apic 0 pin 17 not connected
[    0.104669]  apic 0 pin 18 not connected
[    0.104669]  apic 0 pin 18 not connected
[    0.105798]  apic 0 pin 19 not connected
[    0.105798]  apic 0 pin 19 not connected
[    0.106924]  apic 0 pin 20 not connected
[    0.106924]  apic 0 pin 20 not connected
[    0.108130]  apic 0 pin 21 not connected
[    0.108130]  apic 0 pin 21 not connected
[    0.109262]  apic 0 pin 22 not connected
[    0.109262]  apic 0 pin 22 not connected
[    0.110014]  apic 0 pin 23 not connected
[    0.110014]  apic 0 pin 23 not connected
[    0.111398] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.111398] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.113843] smpboot: CPU0:=20
[    0.113843] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.117209] Using local APIC timer interrupts.
[    0.117209] calibrating APIC timer ...
[    0.117209] Using local APIC timer interrupts.
[    0.117209] calibrating APIC timer ...
[    0.130000] ... lapic delta =3D 6250164
[    0.130000] ... lapic delta =3D 6250164
[    0.130000] ... PM-Timer delta =3D 357968
[    0.130000] ... PM-Timer delta =3D 357968
[    0.130000] ... PM-Timer result ok
[    0.130000] ... PM-Timer result ok
[    0.130000] ..... delta 6250164
[    0.130000] ..... delta 6250164
[    0.130000] ..... mult: 268442499
[    0.130000] ..... mult: 268442499
[    0.130000] ..... calibration result: 10000262
[    0.130000] ..... calibration result: 10000262
[    0.130000] ..... CPU clock speed is 2893.1006 MHz.
[    0.130000] ..... CPU clock speed is 2893.1006 MHz.
[    0.130000] ..... host bus clock speed is 1000.0262 MHz.
[    0.130000] ..... host bus clock speed is 1000.0262 MHz.
[    0.130141] Performance Events:=20
[    0.130141] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.136528] CPU 1 irqstacks, hard=3Dcd862000 soft=3Dcd864000
[    0.136528] CPU 1 irqstacks, hard=3Dcd862000 soft=3Dcd864000
[    0.139033] x86: Booting SMP configuration:
[    0.139033] x86: Booting SMP configuration:
[    0.140015] .... node  #0, CPUs: =20
[    0.140015] .... node  #0, CPUs:         #1 #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1


[    0.160154] x86: Booted up 1 node, 2 CPUs
[    0.160154] x86: Booted up 1 node, 2 CPUs
[    0.160975] smpboot: Total of 2 processors activated (11572.07 BogoMIPS)
[    0.160975] smpboot: Total of 2 processors activated (11572.07 BogoMIPS)
[    0.160119] KVM setup async PF for cpu 1
[    0.160119] KVM setup async PF for cpu 1
[    0.160119] kvm-stealtime: cpu 1, msr dfd2600
[    0.160119] kvm-stealtime: cpu 1, msr dfd2600
[    0.172845] devtmpfs: initialized
[    0.172845] devtmpfs: initialized
[    0.176356] xor: measuring software checksum speed
[    0.176356] xor: measuring software checksum speed
[    0.270076]    pIII_sse  :   146.800 MB/sec
[    0.270076]    pIII_sse  :   146.800 MB/sec
[    0.370074]    prefetch64-sse:   154.000 MB/sec
[    0.370074]    prefetch64-sse:   154.000 MB/sec
[    0.371433] xor: using function: prefetch64-sse (154.000 MB/sec)
[    0.371433] xor: using function: prefetch64-sse (154.000 MB/sec)
[    0.374070] regulator-dummy: no parameters
[    0.374070] regulator-dummy: no parameters
[    0.375762] NET: Registered protocol family 16
[    0.375762] NET: Registered protocol family 16
[    0.378086] cpuidle: using governor ladder
[    0.378086] cpuidle: using governor ladder
[    0.380141] ACPI: bus type PCI registered
[    0.380141] ACPI: bus type PCI registered
[    0.381878] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.381878] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.383978] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.383978] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.385803] PCI: Using configuration type 1 for base access
[    0.385803] PCI: Using configuration type 1 for base access
[    0.410904] bio: create slab <bio-0> at 0
[    0.410904] bio: create slab <bio-0> at 0
[    0.580030] raid6: mmxx1     3267 MB/s
[    0.580030] raid6: mmxx1     3267 MB/s
[    0.750024] raid6: mmxx2     4193 MB/s
[    0.750024] raid6: mmxx2     4193 MB/s
[    0.920013] raid6: sse1x1    3613 MB/s
[    0.920013] raid6: sse1x1    3613 MB/s
[    1.090033] raid6: sse1x2    3481 MB/s
[    1.090033] raid6: sse1x2    3481 MB/s
[    1.260029] raid6: sse2x1    4337 MB/s
[    1.260029] raid6: sse2x1    4337 MB/s
[    1.430020] raid6: sse2x2    5962 MB/s
[    1.430020] raid6: sse2x2    5962 MB/s
[    1.431232] raid6: using algorithm sse2x2 (5962 MB/s)
[    1.431232] raid6: using algorithm sse2x2 (5962 MB/s)
[    1.432749] raid6: using intx1 recovery algorithm
[    1.432749] raid6: using intx1 recovery algorithm
[    1.434824] ACPI: Added _OSI(Module Device)
[    1.434824] ACPI: Added _OSI(Module Device)
[    1.436090] ACPI: Added _OSI(Processor Device)
[    1.436090] ACPI: Added _OSI(Processor Device)
[    1.437423] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.437423] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.438800] ACPI: Added _OSI(Processor Aggregator Device)
[    1.438800] ACPI: Added _OSI(Processor Aggregator Device)
[    1.462956] ACPI: Interpreter enabled
[    1.462956] ACPI: Interpreter enabled
[    1.464084] ACPI: (supports S0 S5)
[    1.464084] ACPI: (supports S0 S5)
[    1.465020] ACPI: Using IOAPIC for interrupt routing
[    1.465020] ACPI: Using IOAPIC for interrupt routing
[    1.466508] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.466508] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.501374] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.501374] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.503223] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.503223] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.504849] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.504849] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.508178] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.508178] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.510293] PCI host bridge to bus 0000:00
[    1.510293] PCI host bridge to bus 0000:00
[    1.511587] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.511587] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.513284] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.513284] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.515049] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.515049] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.516737] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.516737] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.520016] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.520016] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.522082] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.522082] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.525284] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.525284] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.528466] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.528466] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.534685] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.534685] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.539195] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.539195] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.540612] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.540612] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.542727] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.542727] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.545808] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.545808] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.551372] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.551372] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.555820] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.555820] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.570128] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.570128] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.573561] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.573561] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.577056] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.577056] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.580900] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.580900] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.591721] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.591721] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.594904] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.594904] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.598518] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.598518] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.601783] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.601783] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.613600] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.613600] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.617315] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.617315] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.620020] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.620020] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.632077] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.632077] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.635762] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.635762] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.639192] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.639192] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.651136] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.651136] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.654625] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.654625] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.658015] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.658015] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.669823] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.669823] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.671910] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.671910] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.675315] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.675315] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.687948] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.687948] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.691927] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.691927] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.695378] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.695378] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.707166] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.707166] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.710016] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.710016] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.718459] pci_bus 0000:00: on NUMA node 0
[    1.718459] pci_bus 0000:00: on NUMA node 0
[    1.723031] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.723031] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.725436] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.725436] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.727869] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.727869] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.730211] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.730211] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.732258] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.732258] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.735961] ACPI:=20
[    1.735961] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.737459] ACPI: \_SB_.PCI0: notify handler is installed
[    1.737459] ACPI: \_SB_.PCI0: notify handler is installed
[    1.739220] Found 1 acpi root devices
[    1.739220] Found 1 acpi root devices
[    1.741411] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.741411] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.741411] vgaarb: loaded
[    1.741411] vgaarb: loaded
[    1.741411] vgaarb: bridge control possible 0000:00:02.0
[    1.741411] vgaarb: bridge control possible 0000:00:02.0
[    1.743381] SCSI subsystem initialized
[    1.743381] SCSI subsystem initialized
[    1.744686] libata version 3.00 loaded.
[    1.744686] libata version 3.00 loaded.
[    1.746221] Linux video capture interface: v2.00
[    1.746221] Linux video capture interface: v2.00
[    1.747839] pps_core: LinuxPPS API ver. 1 registered
[    1.747839] pps_core: LinuxPPS API ver. 1 registered
[    1.749230] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.749230] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.750083] PTP clock support registered
[    1.750083] PTP clock support registered
[    1.760652] PCI: Using ACPI for IRQ routing
[    1.760652] PCI: Using ACPI for IRQ routing
[    1.760652] PCI: pci_cache_line_size set to 64 bytes
[    1.760652] PCI: pci_cache_line_size set to 64 bytes
[    1.760652] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.760652] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.760652] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.760652] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.763071] NET: Registered protocol family 23
[    1.763071] NET: Registered protocol family 23
[    1.764506] Bluetooth: Core ver 2.17
[    1.764506] Bluetooth: Core ver 2.17
[    1.765692] NET: Registered protocol family 31
[    1.765692] NET: Registered protocol family 31
[    1.766992] Bluetooth: HCI device and connection manager initialized
[    1.766992] Bluetooth: HCI device and connection manager initialized
[    1.768920] Bluetooth: HCI socket layer initialized
[    1.768920] Bluetooth: HCI socket layer initialized
[    1.770043] Bluetooth: L2CAP socket layer initialized
[    1.770043] Bluetooth: L2CAP socket layer initialized
[    1.771542] Bluetooth: SCO socket layer initialized
[    1.771542] Bluetooth: SCO socket layer initialized
[    1.780015] NET: Registered protocol family 8
[    1.780015] NET: Registered protocol family 8
[    1.780015] NET: Registered protocol family 20
[    1.780015] NET: Registered protocol family 20
[    1.783952] cfg80211: Calling CRDA to update world regulatory domain
[    1.783952] cfg80211: Calling CRDA to update world regulatory domain
[    1.786007] Switched to clocksource kvm-clock
[    1.786007] Switched to clocksource kvm-clock
[    1.786007] FS-Cache: Loaded
[    1.786007] FS-Cache: Loaded
[    1.786007] CacheFiles: Loaded
[    1.786007] CacheFiles: Loaded
[    1.786007] pnp: PnP ACPI init
[    1.786007] pnp: PnP ACPI init
[    1.786427] ACPI: bus type PNP registered
[    1.786427] ACPI: bus type PNP registered
[    1.787732] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.787732] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.790000] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.790000] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.792039] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.792039] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.794542] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.794542] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.796609] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.796609] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.799155] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.799155] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.801326] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.801326] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.803693] pnp 00:03: [dma 2]
[    1.803693] pnp 00:03: [dma 2]
[    1.804851] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.804851] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.807056] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.807056] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.809569] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.809569] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.811711] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.811711] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.814215] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.814215] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.817305] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.817305] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.820428] pnp: PnP ACPI: found 7 devices
[    1.820428] pnp: PnP ACPI: found 7 devices
[    1.821623] ACPI: bus type PNP unregistered
[    1.821623] ACPI: bus type PNP unregistered
[    1.859883] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.859883] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.861553] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.861553] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.863285] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.863285] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.865097] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.865097] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.867029] NET: Registered protocol family 1
[    1.867029] NET: Registered protocol family 1
[    1.868307] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.868307] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.870001] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.870001] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.871718] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.871718] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.873641] pci 0000:00:02.0: Boot video device
[    1.873641] pci 0000:00:02.0: Boot video device
[    1.875122] PCI: CLS 0 bytes, default 64
[    1.875122] PCI: CLS 0 bytes, default 64
[    1.876983] Unpacking initramfs...
[    1.876983] Unpacking initramfs...
[    3.743493] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[    3.743493] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[    3.746597] kvm: no hardware support
[    3.746597] kvm: no hardware support
[    3.747759] has_svm: not amd
[    3.747759] has_svm: not amd
[    3.748669] kvm: no hardware support
[    3.748669] kvm: no hardware support
[    3.751520] cryptomgr_test (25) used greatest stack depth: 7240 bytes le=
ft
[    3.751520] cryptomgr_test (25) used greatest stack depth: 7240 bytes le=
ft
[    3.756088] PCLMULQDQ-NI instructions are not detected.
[    3.756088] PCLMULQDQ-NI instructions are not detected.
[    3.757825] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.757825] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.761651] Initialise system trusted keyring
[    3.761651] Initialise system trusted keyring
[    3.763186] audit: initializing netlink socket (disabled)
[    3.763186] audit: initializing netlink socket (disabled)
[    3.765094] type=3D2000 audit(1387718315.125:1): initialized
[    3.765094] type=3D2000 audit(1387718315.125:1): initialized
[    3.768770] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.768770] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.771656] VFS: Disk quotas dquot_6.5.2
[    3.771656] VFS: Disk quotas dquot_6.5.2
[    3.773005] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.773005] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.776390] NTFS driver 2.1.30 [Flags: R/O].
[    3.776390] NTFS driver 2.1.30 [Flags: R/O].
[    3.778058] fuse init (API version 7.22)
[    3.778058] fuse init (API version 7.22)
[    3.779852] JFS: nTxBlock =3D 1623, nTxLock =3D 12989
[    3.779852] JFS: nTxBlock =3D 1623, nTxLock =3D 12989
[    3.785048] SGI XFS with security attributes, large block/inode numbers,=
 debug enabled
[    3.785048] SGI XFS with security attributes, large block/inode numbers,=
 debug enabled
[    3.788738] NILFS version 2 loaded
[    3.788738] NILFS version 2 loaded
[    3.789993] bio: create slab <bio-1> at 1
[    3.789993] bio: create slab <bio-1> at 1
[    3.792658] Btrfs loaded, debug=3Don, integrity-checker=3Don
[    3.792658] Btrfs loaded, debug=3Don, integrity-checker=3Don
[    3.795642] GFS2 installed
[    3.795642] GFS2 installed
[    3.807617] NET: Registered protocol family 38
[    3.807617] NET: Registered protocol family 38
[    3.808855] async_tx: api initialized (async)
[    3.808855] async_tx: api initialized (async)
[    3.810269] Key type asymmetric registered
[    3.810269] Key type asymmetric registered
[    3.811673] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    3.811673] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    3.813878] io scheduler noop registered (default)
[    3.813878] io scheduler noop registered (default)
[    3.815360] io scheduler deadline registered
[    3.815360] io scheduler deadline registered
[    3.816719] io scheduler cfq registered
[    3.816719] io scheduler cfq registered
[    3.819538] list_sort_test: start testing list_sort()
[    3.819538] list_sort_test: start testing list_sort()
[    3.822758] test_string_helpers: Running tests...
[    3.822758] test_string_helpers: Running tests...
[    3.826226] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    3.826226] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    3.827789] crc32: self tests passed, processed 225944 bytes in 878528 n=
sec
[    3.827789] crc32: self tests passed, processed 225944 bytes in 878528 n=
sec
[    3.830849] crc32c: CRC_LE_BITS =3D 32
[    3.830849] crc32c: CRC_LE_BITS =3D 32
[    3.831917] crc32c: self tests passed, processed 225944 bytes in 443375 =
nsec
[    3.831917] crc32c: self tests passed, processed 225944 bytes in 443375 =
nsec
[    4.122085] crc32_combine: 8373 self tests passed
[    4.122085] crc32_combine: 8373 self tests passed
[    4.437770] crc32c_combine: 8373 self tests passed
[    4.437770] crc32c_combine: 8373 self tests passed
[    4.439677] xz_dec_test: module loaded
[    4.439677] xz_dec_test: module loaded
[    4.440447] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
248 0' and write .xz files to it.
[    4.440447] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
248 0' and write .xz files to it.
[    4.444270] no IO addresses supplied
[    4.444270] no IO addresses supplied
[    4.445123] hgafb: HGA card not detected.
[    4.445123] hgafb: HGA card not detected.
[    4.445877] hgafb: probe of hgafb.0 failed with error -22
[    4.445877] hgafb: probe of hgafb.0 failed with error -22
[    4.447333] ipmi message handler version 39.2
[    4.447333] ipmi message handler version 39.2
[    4.448206] IPMI System Interface driver.
[    4.448206] IPMI System Interface driver.
[    4.449300] ipmi_si: Adding default-specified kcs state machine
[    4.449300] ipmi_si: Adding default-specified kcs state machine

[    4.450477] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.450477] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.452298] ipmi_si: Interface detection failed
[    4.452298] ipmi_si: Interface detection failed
[    4.491108] ipmi_si: Adding default-specified smic state machine
[    4.491108] ipmi_si: Adding default-specified smic state machine

[    4.493052] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    4.493052] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    4.496033] ipmi_si: Interface detection failed
[    4.496033] ipmi_si: Interface detection failed
[    4.520319] ipmi_si: Adding default-specified bt state machine
[    4.520319] ipmi_si: Adding default-specified bt state machine

[    4.522088] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    4.522088] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    4.524915] ipmi_si: Interface detection failed
[    4.524915] ipmi_si: Interface detection failed
[    4.550384] kobject: 'ipmi_si' (c7556008): kobject_release, parent cd877=
410 (delayed)
[    4.550384] kobject: 'ipmi_si' (c7556008): kobject_release, parent cd877=
410 (delayed)
[    4.552827] kobject: 'ipmi_si' (c7556330): kobject_release, parent cd8f4=
ea0 (delayed)
[    4.552827] kobject: 'ipmi_si' (c7556330): kobject_release, parent cd8f4=
ea0 (delayed)
[    4.555206] kobject: 'ipmi_si' (c7555d28): kobject_release, parent cd86b=
7b0 (delayed)
[    4.555206] kobject: 'ipmi_si' (c7555d28): kobject_release, parent cd86b=
7b0 (delayed)
[    4.557491] ipmi_si: Unable to find any System Interface(s)
[    4.557491] ipmi_si: Unable to find any System Interface(s)
[    4.559224] IPMI Watchdog: driver initialized
[    4.559224] IPMI Watchdog: driver initialized
[    4.560632] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    4.560632] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    4.562884] IPMI poweroff: Unable to register powercycle sysctl
[    4.562884] IPMI poweroff: Unable to register powercycle sysctl
[    4.565111] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.565111] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.567302] ACPI: Power Button [PWRF]
[    4.567302] ACPI: Power Button [PWRF]
[    4.651121] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.651121] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.677423] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.677423] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.683254] serial: Freescale lpuart driver
[    4.683254] serial: Freescale lpuart driver
[    4.685194] Non-volatile memory driver v1.3
[    4.685194] Non-volatile memory driver v1.3
[    4.686560] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    4.686560] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    4.688587] platform pc8736x_gpio.0: no device found
[    4.688587] platform pc8736x_gpio.0: no device found
[    4.690154] kobject: 'pc8736x_gpio.0' (c75a1dcc): kobject_release, paren=
t   (null) (delayed)
[    4.690154] kobject: 'pc8736x_gpio.0' (c75a1dcc): kobject_release, paren=
t   (null) (delayed)
[    4.692545] nsc_gpio initializing
[    4.692545] nsc_gpio initializing
[    4.693520] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.693520] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.694918] kobject: 'telco_clock' (c003cb28): kobject_release, parent  =
 (null) (delayed)
[    4.694918] kobject: 'telco_clock' (c003cb28): kobject_release, parent  =
 (null) (delayed)
[    4.697967] SyncLink PC Card driver $Revision: 4.34 $, tty major#244
[    4.697967] SyncLink PC Card driver $Revision: 4.34 $, tty major#244
[    4.699934] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.699934] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.702412] Hangcheck: Using getrawmonotonic().
[    4.702412] Hangcheck: Using getrawmonotonic().
[    4.703838] kobject: 'tpm_atmel' (c75aa528): kobject_release, parent cd8=
6b7b0 (delayed)
[    4.703838] kobject: 'tpm_atmel' (c75aa528): kobject_release, parent cd8=
6b7b0 (delayed)
[    4.705418] [drm] Initialized drm 1.1.0 20060810
[    4.705418] [drm] Initialized drm 1.1.0 20060810
[    4.706818] dummy-irq: no IRQ given.  Use irq=3DN
[    4.706818] dummy-irq: no IRQ given.  Use irq=3DN
[    4.707820] lkdtm: No crash points registered, enable through debugfs
[    4.707820] lkdtm: No crash points registered, enable through debugfs
[    4.709421] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.709421] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.712041] Uniform Multi-Platform E-IDE driver
[    4.712041] Uniform Multi-Platform E-IDE driver
[    4.713444] ide-gd driver 1.18
[    4.713444] ide-gd driver 1.18
[    4.714040] ide-cd driver 5.00
[    4.714040] ide-cd driver 5.00
[    4.715785] Loading iSCSI transport class v2.0-870.
[    4.715785] Loading iSCSI transport class v2.0-870.
[    4.719996] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.719996] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.722165] osst :I: Tape driver with OnStream support version 0.99.4
[    4.722165] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    4.722165] osst :I: Tape driver with OnStream support version 0.99.4
[    4.722165] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    4.727627] SCSI Media Changer driver v0.25=20
[    4.727627] SCSI Media Changer driver v0.25=20
[    4.740221] tsc: Refined TSC clocksource calibration: 2892.943 MHz
[    4.740221] tsc: Refined TSC clocksource calibration: 2892.943 MHz
[    4.750611] scsi_debug: host protection
[    4.750611] scsi_debug: host protection
[    4.751876] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    4.751876] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    4.755589] Calling blk_mq_init_queue: scsi_mq_ops: c1b41f18, queue_dept=
h: 64, cmd_size: 188 SCSI cmd_size: 0
[    4.755589] Calling blk_mq_init_queue: scsi_mq_ops: c1b41f18, queue_dept=
h: 64, cmd_size: 188 SCSI cmd_size: 0
[    4.759033] blk-mq: CPU -> queue map
[    4.759033] blk-mq: CPU -> queue map
[    4.760095] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    4.760095] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    4.762282]   CPU 0 -> Queue 0
[    4.762282]   CPU 0 -> Queue 0
[    4.763205]   CPU 1 -> Queue 0
[    4.763205]   CPU 1 -> Queue 0
[    4.764566] ------------[ cut here ]------------
[    4.764566] ------------[ cut here ]------------
[    4.765951] WARNING: CPU: 0 PID: 99 at block/elevator.c:193 elevator_ini=
t+0xf0/0xfb()
[    4.765951] WARNING: CPU: 0 PID: 99 at block/elevator.c:193 elevator_ini=
t+0xf0/0xfb()
[    4.769926] CPU: 0 PID: 99 Comm: kworker/u4:1 Not tainted 3.13.0-rc3-000=
15-g3d712c2 #1
[    4.769926] CPU: 0 PID: 99 Comm: kworker/u4:1 Not tainted 3.13.0-rc3-000=
15-g3d712c2 #1
[    4.772316] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.772316] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.773986] Workqueue: events_unbound async_run_entry_fn
[    4.773986] Workqueue: events_unbound async_run_entry_fn

[    4.775549]  00000000
[    4.775549]  00000000 00000000 00000000 c7413c1c c7413c1c c17994db c1799=
4db 00000000 00000000 c7413c4c c7413c4c c1064ea6 c1064ea6 c1a09e87 c1a09e87

[    4.777988]  00000000
[    4.777988]  00000000 00000063 00000063 c1a4a4ae c1a4a4ae 000000c1 00000=
0c1 c134a9e6 c134a9e6 c134a9e6 c134a9e6 c75ef000 c75ef000 00000000 00000000

[    4.780450]  c6d64008
[    4.780450]  c6d64008 c7413c5c c7413c5c c1064f5b c1064f5b 00000009 00000=
009 00000000 00000000 c7413c74 c7413c74 c134a9e6 c134a9e6 c75ef000 c75ef000

[    4.782849] Call Trace:
[    4.782849] Call Trace:
[    4.783616]  [<c17994db>] dump_stack+0x48/0x60
[    4.783616]  [<c17994db>] dump_stack+0x48/0x60
[    4.784931]  [<c1064ea6>] warn_slowpath_common+0x6f/0x86
[    4.784931]  [<c1064ea6>] warn_slowpath_common+0x6f/0x86
[    4.786439]  [<c134a9e6>] ? elevator_init+0xf0/0xfb
[    4.786439]  [<c134a9e6>] ? elevator_init+0xf0/0xfb
[    4.787791]  [<c134a9e6>] ? elevator_init+0xf0/0xfb
[    4.787791]  [<c134a9e6>] ? elevator_init+0xf0/0xfb
[    4.789217]  [<c1064f5b>] warn_slowpath_null+0x1d/0x1f
[    4.789217]  [<c1064f5b>] warn_slowpath_null+0x1d/0x1f
[    4.790771]  [<c134a9e6>] elevator_init+0xf0/0xfb
[    4.790771]  [<c134a9e6>] elevator_init+0xf0/0xfb
[    4.792151]  [<c146ffc0>] scsi_mq_alloc_queue+0xf4/0x279
[    4.792151]  [<c146ffc0>] scsi_mq_alloc_queue+0xf4/0x279
[    4.793705]  [<c108de2f>] ? lockdep_init_map+0xbc/0x136
[    4.793705]  [<c108de2f>] ? lockdep_init_map+0xbc/0x136
[    4.795222]  [<c1091fa7>] ? __raw_spin_lock_init+0x2d/0x4d
[    4.795222]  [<c1091fa7>] ? __raw_spin_lock_init+0x2d/0x4d
[    4.796746]  [<c14706e2>] scsi_alloc_sdev+0x1a5/0x259
[    4.796746]  [<c14706e2>] scsi_alloc_sdev+0x1a5/0x259
[    4.798179]  [<c147083d>] scsi_probe_and_add_lun+0xa7/0x80d
[    4.798179]  [<c147083d>] scsi_probe_and_add_lun+0xa7/0x80d
[    4.799811]  [<c179e500>] ? mutex_unlock+0x8/0xa
[    4.799811]  [<c179e500>] ? mutex_unlock+0x8/0xa
[    4.801164]  [<c143c173>] ? attribute_container_add_device+0xfd/0x105
[    4.801164]  [<c143c173>] ? attribute_container_add_device+0xfd/0x105
[    4.802954]  [<c14711ed>] __scsi_scan_target+0x98/0x485
[    4.802954]  [<c14711ed>] __scsi_scan_target+0x98/0x485
[    4.804408]  [<c108cea2>] ? mark_held_locks+0x5c/0x73
[    4.804408]  [<c108cea2>] ? mark_held_locks+0x5c/0x73
[    4.805888]  [<c108d1d6>] ? trace_hardirqs_on_caller+0x16e/0x1c4
[    4.805888]  [<c108d1d6>] ? trace_hardirqs_on_caller+0x16e/0x1c4
[    4.807481]  [<c1471835>] ? scsi_scan_host_selected+0x53/0x109
[    4.807481]  [<c1471835>] ? scsi_scan_host_selected+0x53/0x109
[    4.809085]  [<c179d5cf>] ? mutex_lock_nested+0x3b2/0x44f
[    4.809085]  [<c179d5cf>] ? mutex_lock_nested+0x3b2/0x44f
[    4.810223]  [<c1471835>] ? scsi_scan_host_selected+0x53/0x109
[    4.810223]  [<c1471835>] ? scsi_scan_host_selected+0x53/0x109
[    4.811269]  [<c10832e3>] ? sched_clock_cpu+0x106/0x114
[    4.811269]  [<c10832e3>] ? sched_clock_cpu+0x106/0x114
[    4.812210]  [<c105497f>] ? kvm_clock_read+0x1e/0x27
[    4.812210]  [<c105497f>] ? kvm_clock_read+0x1e/0x27
[    4.813104]  [<c108cc57>] ? mark_lock+0x1e/0x20d
[    4.813104]  [<c108cc57>] ? mark_lock+0x1e/0x20d
[    4.813936]  [<c1471625>] scsi_scan_channel.part.15+0x4b/0x55
[    4.813936]  [<c1471625>] scsi_scan_channel.part.15+0x4b/0x55
[    4.814961]  [<c1471882>] scsi_scan_host_selected+0xa0/0x109
[    4.814961]  [<c1471882>] scsi_scan_host_selected+0xa0/0x109
[    4.815970]  [<c1471951>] do_scsi_scan_host+0x66/0x6c
[    4.815970]  [<c1471951>] do_scsi_scan_host+0x66/0x6c
[    4.816875]  [<c147196a>] do_scan_async+0x13/0x129
[    4.816875]  [<c147196a>] do_scan_async+0x13/0x129
[    4.817756]  [<c107d93a>] async_run_entry_fn+0x68/0x123
[    4.817756]  [<c107d93a>] async_run_entry_fn+0x68/0x123
[    4.819015]  [<c1074158>] ? process_one_work+0x141/0x2df
[    4.819015]  [<c1074158>] ? process_one_work+0x141/0x2df
[    4.820708]  [<c10741db>] process_one_work+0x1c4/0x2df
[    4.820708]  [<c10741db>] process_one_work+0x1c4/0x2df
[    4.821974]  [<c1074158>] ? process_one_work+0x141/0x2df
[    4.821974]  [<c1074158>] ? process_one_work+0x141/0x2df
[    4.823440]  [<c107465a>] worker_thread+0x127/0x1c4
[    4.823440]  [<c107465a>] worker_thread+0x127/0x1c4
[    4.824655]  [<c1074533>] ? rescuer_thread+0x21c/0x21c
[    4.824655]  [<c1074533>] ? rescuer_thread+0x21c/0x21c
[    4.826171]  [<c1078e7a>] kthread+0xa2/0xa7
[    4.826171]  [<c1078e7a>] kthread+0xa2/0xa7
[    4.827415]  [<c17a113b>] ret_from_kernel_thread+0x1b/0x30
[    4.827415]  [<c17a113b>] ret_from_kernel_thread+0x1b/0x30
[    4.828844]  [<c1078dd8>] ? __kthread_parkme+0x50/0x50
[    4.828844]  [<c1078dd8>] ? __kthread_parkme+0x50/0x50
[    4.830355] ---[ end trace f3ee4008be610a98 ]---
[    4.830355] ---[ end trace f3ee4008be610a98 ]---
[    4.831798] Performing sc map setup on q: c75ef000 hctx: c75fbd88 i: 0
[    4.831798] Performing sc map setup on q: c75ef000 hctx: c75fbd88 i: 0
[    4.835390] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    4.835390] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    4.836205] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    4.836205] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    4.836500] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    4.836500] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    4.840241] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    4.840241] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    4.845299] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.845299] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.846218] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@sa=
mba.org>
[    4.846218] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@sa=
mba.org>
[    4.846232] CAN device driver interface
[    4.846232] CAN device driver interface
[    4.846237] cc770: CAN netdevice driver
[    4.846237] cc770: CAN netdevice driver
[    4.846238] cc770_isa: insufficient parameters supplied
[    4.846238] cc770_isa: insufficient parameters supplied
[    4.846311] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    4.846311] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    4.846314] YAM driver version 0.8 by F1OAT/F6FBB
[    4.846314] YAM driver version 0.8 by F1OAT/F6FBB
[    4.849700] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    4.849700] baycom_ser_hdx: version 0.10
[    4.849700] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    4.849700] baycom_ser_hdx: version 0.10
[    4.852720] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    4.852720] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    4.852721] hdlcdrv: version 0.8
[    4.852721] hdlcdrv: version 0.8
[    4.854116] kobject: 'smsc-ircc2' (c6e24358): kobject_release, parent cd=
86b7b0 (delayed)
[    4.854116] kobject: 'smsc-ircc2' (c6e24358): kobject_release, parent cd=
86b7b0 (delayed)
[    4.854557] kobject: 'ali-ircc' (c6e244f0): kobject_release, parent cd86=
b7b0 (delayed)
[    4.854557] kobject: 'ali-ircc' (c6e244f0): kobject_release, parent cd86=
b7b0 (delayed)
[    4.855298] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.855298] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.857326] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.857326] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.857405] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.857405] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.875099] sd 0:0:0:0: [sda] Write Protect is off
[    4.875099] sd 0:0:0:0: [sda] Write Protect is off
[    4.876697] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.876697] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.890143] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    4.890143] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    4.946016] mousedev: PS/2 mouse device common for all mice
[    4.946016] mousedev: PS/2 mouse device common for all mice
[    4.948318] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    4.948318] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    4.952256] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.952256] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.955354] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    4.955354] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    4.958424] kobject: 'input2' (c6e2e884): kobject_release, parent   (nul=
l) (delayed)
[    4.958424] kobject: 'input2' (c6e2e884): kobject_release, parent   (nul=
l) (delayed)
[    4.964078] wistron_btns: System unknown
[    4.964078] wistron_btns: System unknown
[    4.965643] rtc_cmos 00:00: RTC can wake from S4
[    4.965643] rtc_cmos 00:00: RTC can wake from S4
[    4.967557] rtc (null): alarm rollover: day
[    4.967557] rtc (null): alarm rollover: day
[    4.969339] rtc rtc0: rtc_cmos: dev (254:0)
[    4.969339] rtc rtc0: rtc_cmos: dev (254:0)
[    4.970135]  sda: unknown partition table
[    4.970135]  sda: unknown partition table
[    4.972065] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    4.972065] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    4.974778] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    4.974778] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    4.978263] kobject: 'rtc-rp5c01' (c6e45d08): kobject_release, parent cd=
86b7b0 (delayed)
[    4.978263] kobject: 'rtc-rp5c01' (c6e45d08): kobject_release, parent cd=
86b7b0 (delayed)
[    4.980776] i2c /dev entries driver
[    4.980776] i2c /dev entries driver
[    4.981735] i2c-parport-light: adapter type unspecified
[    4.981735] i2c-parport-light: adapter type unspecified
[    4.983146] lirc_dev: IR Remote Control driver registered, major 240=20
[    4.983146] lirc_dev: IR Remote Control driver registered, major 240=20
[    4.984375] IR NEC protocol handler initialized
[    4.984375] IR NEC protocol handler initialized
[    4.985200] IR RC6 protocol handler initialized
[    4.985200] IR RC6 protocol handler initialized
[    4.986027] IR Sony protocol handler initialized
[    4.986027] IR Sony protocol handler initialized
[    4.986870] IR RC5 (streamzap) protocol handler initialized
[    4.986870] IR RC5 (streamzap) protocol handler initialized
[    4.987888] IR MCE Keyboard/mouse protocol handler initialized
[    4.987888] IR MCE Keyboard/mouse protocol handler initialized
[    4.988968] IR LIRC bridge handler initialized
[    4.988968] IR LIRC bridge handler initialized
[    4.990231] pps pps0: new PPS source ktimer
[    4.990231] pps pps0: new PPS source ktimer
[    4.991584] pps pps0: ktimer PPS source registered
[    4.991584] pps pps0: ktimer PPS source registered
[    4.992755] pps_ldisc: PPS line discipline registered
[    4.992755] pps_ldisc: PPS line discipline registered
[    4.994187] Driver for 1-wire Dallas network protocol.
[    4.994187] Driver for 1-wire Dallas network protocol.
[    4.995685] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    4.995685] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    4.996939] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    4.996939] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    4.999760] kobject: 'twl4030_bci' (c6e4dd60): kobject_release, parent c=
d86b7b0 (delayed)
[    4.999760] kobject: 'twl4030_bci' (c6e4dd60): kobject_release, parent c=
d86b7b0 (delayed)
[    5.004155] applesmc: supported laptop not found!
[    5.004155] applesmc: supported laptop not found!
[    5.005632] applesmc: driver init failed (ret=3D-19)!
[    5.005632] applesmc: driver init failed (ret=3D-19)!
[    5.010197] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.010197] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.011071] kobject: 'mc13783-adc' (c6e55770): kobject_release, parent c=
d86b7b0 (delayed)
[    5.011071] kobject: 'mc13783-adc' (c6e55770): kobject_release, parent c=
d86b7b0 (delayed)
[    5.011388] kobject: 'nct6775' (c6e55b80): kobject_release, parent cd86b=
7b0 (delayed)
[    5.011388] kobject: 'nct6775' (c6e55b80): kobject_release, parent cd86b=
7b0 (delayed)
[    5.011452] pc87360: PC8736x not detected, module not inserted
[    5.011452] pc87360: PC8736x not detected, module not inserted
[    5.013255] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    5.013255] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    5.013258] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    5.013258] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    5.013799] acquirewdt: I/O address 0x0043 already in use
[    5.013799] acquirewdt: I/O address 0x0043 already in use
[    5.013816] acquirewdt: probe of acquirewdt failed with error -5
[    5.013816] acquirewdt: probe of acquirewdt failed with error -5
[    5.025657] sc520_wdt: WDT driver for SC520 initialised. timeout=3D30 se=
c (nowayout=3D1)
[    5.025657] sc520_wdt: WDT driver for SC520 initialised. timeout=3D30 se=
c (nowayout=3D1)
[    5.027993] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    5.027993] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    5.030434] wafer5823wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    5.030434] wafer5823wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    5.032429] it87_wdt: no device
[    5.032429] it87_wdt: no device
[    5.033513] sc1200wdt: build 20020303
[    5.033513] sc1200wdt: build 20020303
[    5.034688] sc1200wdt: io parameter must be specified
[    5.034688] sc1200wdt: io parameter must be specified
[    5.036210] kobject: 'scl200wdt' (c6e59650): kobject_release, parent cd8=
f4ea0 (delayed)
[    5.036210] kobject: 'scl200wdt' (c6e59650): kobject_release, parent cd8=
f4ea0 (delayed)
[    5.038622] pc87413_wdt: Version 1.1 at io 0x2E
[    5.038622] pc87413_wdt: Version 1.1 at io 0x2E
[    5.039950] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.039950] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.041935] sbc8360: failed to register misc device
[    5.041935] sbc8360: failed to register misc device
[    5.043472] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    5.043472] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    5.046920] smsc37b787_wdt: Unable to register miscdev on minor 130
[    5.046920] smsc37b787_wdt: Unable to register miscdev on minor 130
[    5.048778] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    5.048778] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    5.051661] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    5.051661] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    5.053982] watchdog: W83627HF Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    5.053982] watchdog: W83627HF Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    5.056356] watchdog: W83627HF Watchdog: a legacy watchdog module is pro=
bably present.
[    5.056356] watchdog: W83627HF Watchdog: a legacy watchdog module is pro=
bably present.
[    5.060491] w83627hf_wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    5.060491] w83627hf_wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    5.062366] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    5.062366] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    5.064174] w83697hf_wdt: watchdog not found at address 0x2e
[    5.064174] w83697hf_wdt: watchdog not found at address 0x2e
[    5.065826] w83697hf_wdt: No W83697HF/HG could be found
[    5.065826] w83697hf_wdt: No W83697HF/HG could be found
[    5.067374] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    5.067374] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    5.069930] w83697ug_wdt: No W83697UG/UF could be found
[    5.069930] w83697ug_wdt: No W83697UG/UF could be found
[    5.071555] w83877f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.071555] w83877f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.073537] w83977f_wdt: driver v1.00
[    5.073537] w83977f_wdt: driver v1.00
[    5.074674] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.074674] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    5.076589] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    5.076589] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    5.078415] machzwd: no ZF-Logic found
[    5.078415] machzwd: no ZF-Logic found
[    5.080387] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    5.080387] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    5.082760] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    5.082760] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    5.086356] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    5.086356] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    5.089699] md: raid0 personality registered for level 0
[    5.089699] md: raid0 personality registered for level 0
[    5.091344] md: raid1 personality registered for level 1
[    5.091344] md: raid1 personality registered for level 1
[    5.092942] md: raid10 personality registered for level 10
[    5.092942] md: raid10 personality registered for level 10
[    5.094869] md: raid6 personality registered for level 6
[    5.094869] md: raid6 personality registered for level 6
[    5.096398] md: raid5 personality registered for level 5
[    5.096398] md: raid5 personality registered for level 5
[    5.097949] md: raid4 personality registered for level 4
[    5.097949] md: raid4 personality registered for level 4
[    5.099479] md: multipath personality registered for level -4
[    5.099479] md: multipath personality registered for level -4
[    5.101310] md: faulty personality registered for level -5
[    5.101310] md: faulty personality registered for level -5
[    5.104107] device-mapper: uevent: version 1.0.3
[    5.104107] device-mapper: uevent: version 1.0.3
[    5.105886] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    5.105886] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    5.109963] device-mapper: multipath: version 1.6.0 loaded
[    5.109963] device-mapper: multipath: version 1.6.0 loaded
[    5.111735] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.111735] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.113661] device-mapper: multipath queue-length: version 0.1.0 loaded
[    5.113661] device-mapper: multipath queue-length: version 0.1.0 loaded
[    5.115656] device-mapper: multipath service-time: version 0.2.0 loaded
[    5.115656] device-mapper: multipath service-time: version 0.2.0 loaded
[    5.117532] device-mapper: raid: Loading target version 1.5.2
[    5.117532] device-mapper: raid: Loading target version 1.5.2
[    5.119237] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.119237] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.120891] Bluetooth: Virtual HCI driver ver 1.4
[    5.120891] Bluetooth: Virtual HCI driver ver 1.4
[    5.122144] Bluetooth: HCI UART driver ver 2.2
[    5.122144] Bluetooth: HCI UART driver ver 2.2
[    5.123671] Bluetooth: HCIATH3K protocol initialized
[    5.123671] Bluetooth: HCIATH3K protocol initialized
[    5.125292] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    5.125292] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    5.128338] lguest: switcher text too large (4384)
[    5.128338] lguest: switcher text too large (4384)
[    5.133451] hidraw: raw HID events driver (C) Jiri Kosina
[    5.133451] hidraw: raw HID events driver (C) Jiri Kosina
[    5.142517] hdaps: supported laptop not found!
[    5.142517] hdaps: supported laptop not found!
[    5.143981] hdaps: driver init failed (ret=3D-19)!
[    5.143981] hdaps: driver init failed (ret=3D-19)!
[    5.147785] oprofile: using NMI interrupt.
[    5.147785] oprofile: using NMI interrupt.
[    5.149307] netem: version 1.3
[    5.149307] netem: version 1.3
[    5.150175] NET: Registered protocol family 17
[    5.150175] NET: Registered protocol family 17
[    5.151543] NET: Registered protocol family 15
[    5.151543] NET: Registered protocol family 15
[    5.153107] NET: Registered protocol family 4
[    5.153107] NET: Registered protocol family 4
[    5.154471] NET: Registered protocol family 5
[    5.154471] NET: Registered protocol family 5
[    5.156380] NET: Registered protocol family 9
[    5.156380] NET: Registered protocol family 9
[    5.157698] X.25 for Linux Version 0.2
[    5.157698] X.25 for Linux Version 0.2
[    5.163421] NET: Registered protocol family 6
[    5.163421] NET: Registered protocol family 6
[    5.164865] NET: Registered protocol family 3
[    5.164865] NET: Registered protocol family 3
[    5.166213] can: controller area network core (rev 20120528 abi 9)
[    5.166213] can: controller area network core (rev 20120528 abi 9)
[    5.168163] NET: Registered protocol family 29
[    5.168163] NET: Registered protocol family 29
[    5.169509] can: netlink gateway (rev 20130117) max_hops=3D1
[    5.169509] can: netlink gateway (rev 20130117) max_hops=3D1
[    5.172621] Bluetooth: RFCOMM TTY layer initialized
[    5.172621] Bluetooth: RFCOMM TTY layer initialized
[    5.174154] Bluetooth: RFCOMM socket layer initialized
[    5.174154] Bluetooth: RFCOMM socket layer initialized
[    5.175687] Bluetooth: RFCOMM ver 1.11
[    5.175687] Bluetooth: RFCOMM ver 1.11
[    5.176845] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.176845] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.178467] Bluetooth: BNEP socket layer initialized
[    5.178467] Bluetooth: BNEP socket layer initialized
[    5.179953] lec:lane_module_init: lec.c: initialized
[    5.179953] lec:lane_module_init: lec.c: initialized
[    5.181507] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    5.181507] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    5.184395] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    5.184395] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    5.186169] NET: Registered protocol family 12
[    5.186169] NET: Registered protocol family 12
[    5.187577] NET: Registered protocol family 35
[    5.187577] NET: Registered protocol family 35
[    5.189062] 9pnet: Installing 9P2000 support
[    5.189062] 9pnet: Installing 9P2000 support
[    5.191011] NET: Registered protocol family 37
[    5.191011] NET: Registered protocol family 37
[    5.192383] NET: Registered protocol family 36
[    5.192383] NET: Registered protocol family 36
[    5.193614] Key type dns_resolver registered
[    5.193614] Key type dns_resolver registered
[    5.196476] batman_adv: B.A.T.M.A.N. advanced 2013.5.0 (compatibility ve=
rsion 15) loaded
[    5.196476] batman_adv: B.A.T.M.A.N. advanced 2013.5.0 (compatibility ve=
rsion 15) loaded
[    5.198998] mpls_gso: MPLS GSO support
[    5.198998] mpls_gso: MPLS GSO support
[    5.200717]=20
[    5.200717] printing PIC contents
[    5.200717]=20
[    5.200717] printing PIC contents
[    5.202240] ... PIC  IMR: ffff
[    5.202240] ... PIC  IMR: ffff
[    5.203218] ... PIC  IRR: 1113
[    5.203218] ... PIC  IRR: 1113
[    5.204233] ... PIC  ISR: 0000
[    5.204233] ... PIC  ISR: 0000
[    5.205212] ... PIC ELCR: 0c00
[    5.205212] ... PIC ELCR: 0c00
[    5.206126] printing local APIC contents on CPU#0/0:
[    5.206126] printing local APIC contents on CPU#0/0:
[    5.207565] ... APIC ID:      00000000 (0)
[    5.207565] ... APIC ID:      00000000 (0)
[    5.208769] ... APIC VERSION: 00050014
[    5.208769] ... APIC VERSION: 00050014
[    5.209907] ... APIC TASKPRI: 00000000 (00)
[    5.209907] ... APIC TASKPRI: 00000000 (00)
[    5.210052] ... APIC PROCPRI: 00000000
[    5.210052] ... APIC PROCPRI: 00000000
[    5.210052] ... APIC LDR: 01000000
[    5.210052] ... APIC LDR: 01000000
[    5.210052] ... APIC DFR: ffffffff
[    5.210052] ... APIC DFR: ffffffff
[    5.210052] ... APIC SPIV: 000001ff
[    5.210052] ... APIC SPIV: 000001ff
[    5.210052] ... APIC ISR field:
[    5.210052] ... APIC ISR field:
[    5.210052] 00000000
[    5.210052] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    5.210052] ... APIC TMR field:
[    5.210052] ... APIC TMR field:
[    5.210052] 00000000
[    5.210052] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    5.210052] ... APIC IRR field:
[    5.210052] ... APIC IRR field:
[    5.210052] 00000000
[    5.210052] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    5.210052] ... APIC ESR: 00000000
[    5.210052] ... APIC ESR: 00000000
[    5.210052] ... APIC ICR: 000008fd
[    5.210052] ... APIC ICR: 000008fd
[    5.210052] ... APIC ICR2: 02000000
[    5.210052] ... APIC ICR2: 02000000
[    5.210052] ... APIC LVTT: 000000ef
[    5.210052] ... APIC LVTT: 000000ef
[    5.210052] ... APIC LVTPC: 00010000
[    5.210052] ... APIC LVTPC: 00010000
[    5.210052] ... APIC LVT0: 00010700
[    5.210052] ... APIC LVT0: 00010700
[    5.210052] ... APIC LVT1: 00000400
[    5.210052] ... APIC LVT1: 00000400
[    5.210052] ... APIC LVTERR: 000000fe
[    5.210052] ... APIC LVTERR: 000000fe
[    5.210052] ... APIC TMICT: 00097b08
[    5.210052] ... APIC TMICT: 00097b08
[    5.210052] ... APIC TMCCT: 00000000
[    5.210052] ... APIC TMCCT: 00000000
[    5.210052] ... APIC TDCR: 00000003
[    5.210052] ... APIC TDCR: 00000003
[    5.210052]=20
[    5.210052]=20
[    5.238239] number of MP IRQ sources: 15.
[    5.238239] number of MP IRQ sources: 15.
[    5.239517] number of IO-APIC #0 registers: 24.
[    5.239517] number of IO-APIC #0 registers: 24.
[    5.240962] testing the IO APIC.......................
[    5.240962] testing the IO APIC.......................
[    5.242631] IO APIC #0......
[    5.242631] IO APIC #0......
[    5.243556] .... register #00: 00000000
[    5.243556] .... register #00: 00000000
[    5.244770] .......    : physical APIC id: 00
[    5.244770] .......    : physical APIC id: 00
[    5.246155] .......    : Delivery Type: 0
[    5.246155] .......    : Delivery Type: 0
[    5.247423] .......    : LTS          : 0
[    5.247423] .......    : LTS          : 0
[    5.248596] .... register #01: 00170011
[    5.248596] .... register #01: 00170011
[    5.249757] .......     : max redirection entries: 17
[    5.249757] .......     : max redirection entries: 17
[    5.251297] .......     : PRQ implemented: 0
[    5.251297] .......     : PRQ implemented: 0
[    5.252589] .......     : IO APIC version: 11
[    5.252589] .......     : IO APIC version: 11
[    5.253908] .... register #02: 00000000
[    5.253908] .... register #02: 00000000
[    5.255116] .......     : arbitration: 00
[    5.255116] .......     : arbitration: 00
[    5.256249] .... IRQ redirection table:
[    5.256249] .... IRQ redirection table:
[    5.257411] 1    0    0   0   0    0    0    00
[    5.257411] 1    0    0   0   0    0    0    00
[    5.258810] 0    0    0   0   0    1    1    31
[    5.258810] 0    0    0   0   0    1    1    31
[    5.260223] 0    0    0   0   0    1    1    30
[    5.260223] 0    0    0   0   0    1    1    30
[    5.261371] 0    0    0   0   0    1    1    33
[    5.261371] 0    0    0   0   0    1    1    33
[    5.262551] 1    0    0   0   0    1    1    34
[    5.262551] 1    0    0   0   0    1    1    34
[    5.263931] 1    1    0   0   0    1    1    35
[    5.263931] 1    1    0   0   0    1    1    35
[    5.265256] 0    0    0   0   0    1    1    36
[    5.265256] 0    0    0   0   0    1    1    36
[    5.267375] 0    0    0   0   0    1    1    37
[    5.267375] 0    0    0   0   0    1    1    37
[    5.268663] 0    0    0   0   0    1    1    38
[    5.268663] 0    0    0   0   0    1    1    38
[    5.269950] 0    1    0   0   0    1    1    39
[    5.269950] 0    1    0   0   0    1    1    39
[    5.271375] 1    1    0   0   0    1    1    3A
[    5.271375] 1    1    0   0   0    1    1    3A
[    5.272584] 1    1    0   0   0    1    1    3B
[    5.272584] 1    1    0   0   0    1    1    3B
[    5.273748] 0    0    0   0   0    1    1    3C
[    5.273748] 0    0    0   0   0    1    1    3C
[    5.275163] 0    0    0   0   0    1    1    3D
[    5.275163] 0    0    0   0   0    1    1    3D
[    5.276591] 0    0    0   0   0    1    1    3E
[    5.276591] 0    0    0   0   0    1    1    3E
[    5.278028] 0    0    0   0   0    1    1    3F
[    5.278028] 0    0    0   0   0    1    1    3F
[    5.279266] 1    0    0   0   0    0    0    00
[    5.279266] 1    0    0   0   0    0    0    00
[    5.280551] 1    0    0   0   0    0    0    00
[    5.280551] 1    0    0   0   0    0    0    00
[    5.281798] 1    0    0   0   0    0    0    00
[    5.281798] 1    0    0   0   0    0    0    00
[    5.282950] 1    0    0   0   0    0    0    00
[    5.282950] 1    0    0   0   0    0    0    00
[    5.284346] 1    0    0   0   0    0    0    00
[    5.284346] 1    0    0   0   0    0    0    00
[    5.285698] 1    0    0   0   0    0    0    00
[    5.285698] 1    0    0   0   0    0    0    00
[    5.287035] 1    0    0   0   0    0    0    00
[    5.287035] 1    0    0   0   0    0    0    00
[    5.288443] 1    0    0   0   0    0    0    00
[    5.288443] 1    0    0   0   0    0    0    00
[    5.289835] IRQ to pin mappings:
[    5.289835] IRQ to pin mappings:
[    5.290876] IRQ0=20
[    5.290876] IRQ0 -> 0:2-> 0:2

[    5.291689] IRQ1=20
[    5.291689] IRQ1 -> 0:1-> 0:1

[    5.292498] IRQ3=20
[    5.292498] IRQ3 -> 0:3-> 0:3

[    5.293305] IRQ4=20
[    5.293305] IRQ4 -> 0:4-> 0:4

[    5.294105] IRQ5=20
[    5.294105] IRQ5 -> 0:5-> 0:5

[    5.294913] IRQ6=20
[    5.294913] IRQ6 -> 0:6-> 0:6

[    5.295729] IRQ7=20
[    5.295729] IRQ7 -> 0:7-> 0:7

[    5.296533] IRQ8=20
[    5.296533] IRQ8 -> 0:8-> 0:8

[    5.297193] IRQ9=20
[    5.297193] IRQ9 -> 0:9-> 0:9

[    5.297872] IRQ10=20
[    5.297872] IRQ10 -> 0:10-> 0:10

[    5.298605] IRQ11=20
[    5.298605] IRQ11 -> 0:11-> 0:11

[    5.299425] IRQ12=20
[    5.299425] IRQ12 -> 0:12-> 0:12

[    5.300330] IRQ13=20
[    5.300330] IRQ13 -> 0:13-> 0:13

[    5.301167] IRQ14=20
[    5.301167] IRQ14 -> 0:14-> 0:14

[    5.302015] IRQ15=20
[    5.302015] IRQ15 -> 0:15-> 0:15

[    5.302849] .................................... done.
[    5.302849] .................................... done.
[    5.304323] Using IPI No-Shortcut mode
[    5.304323] Using IPI No-Shortcut mode
[    5.306780] bootconsole [earlyser0] disabled
[    5.306780] bootconsole [earlyser0] disabled
[    5.308147] Loading compiled-in X.509 certificates
[    5.308925] registered taskstats version 1
[    5.310456] cryptomgr_probe (118) used greatest stack depth: 6796 bytes =
left
[    5.311604] Key type trusted registered
[    5.312617] raid6test: testing the 4-disk case...
[    5.313450] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    5.314532] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[    5.315579] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[    5.316639] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[    5.317705] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[    5.318748] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[    5.319846] raid6test: testing the 5-disk case...
[    5.320710] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    5.321792] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    5.322838] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[    5.323887] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[    5.324968] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    5.326033] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[    5.327079] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[    5.328145] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[    5.329202] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[    5.330298] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[    5.331545] raid6test: testing the 11-disk case...
[    5.332385] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    5.333468] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    5.334550] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    5.335620] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    5.336690] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    5.337774] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    5.338871] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    5.339952] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    5.341067] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[    5.342122] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[    5.343215] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    5.344304] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    5.345367] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    5.346444] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    5.347526] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    5.348621] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    5.349658] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    5.350775] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[    5.351851] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[    5.352950] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    5.354070] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    5.355150] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    5.356253] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    5.357362] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    5.358485] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    5.359549] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[    5.360665] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[    5.361751] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    5.362851] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    5.363934] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    5.365009] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    5.366119] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    5.367182] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[    5.368291] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[    5.369363] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    5.370531] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    5.371583] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    5.372646] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    5.373719] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[    5.374813] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[    5.375891] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    5.376971] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    5.378019] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    5.379077] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[    5.379845] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[    5.380562] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    5.381220] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    5.381904] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[    5.382551] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[    5.383215] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    5.383902] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[    5.384550] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[    5.385211] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[    5.385872] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[    5.386522] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[    5.387262] raid6test: testing the 12-disk case...
[    5.387784] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    5.388466] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    5.389198] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    5.389964] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    5.390671] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    5.391343] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    5.391999] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    5.392665] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    5.393328] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    5.393989] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[    5.394650] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[    5.395324] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    5.395983] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    5.396656] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    5.397318] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    5.397975] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    5.398655] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    5.399319] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    5.399980] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    5.400695] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[    5.401360] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[    5.402025] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    5.402698] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    5.403362] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    5.404019] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    5.404689] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    5.405355] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    5.406017] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    5.406689] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[    5.407350] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[    5.408012] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    5.408701] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    5.409363] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    5.410047] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    5.410716] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    5.411384] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    5.412034] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[    5.412690] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[    5.413361] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    5.414018] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    5.414688] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    5.415351] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    5.416006] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    5.416680] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[    5.417333] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[    5.417999] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    5.418681] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    5.419344] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    5.420000] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    5.420702] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[    5.421362] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[    5.422020] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    5.422688] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    5.423351] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    5.424000] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[    5.424653] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[    5.425323] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    5.425980] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    5.426647] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[    5.427292] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[    5.427954] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    5.428627] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[    5.429279] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[    5.429939] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[    5.430627] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[    5.431283] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[    5.432179] raid6test: testing the 24-disk case...
[    5.432714] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    5.433393] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    5.434064] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    5.434750] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    5.435425] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    5.436091] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    5.436779] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    5.437456] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    5.438127] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    5.438828] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[    5.439511] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[    5.440293] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[    5.440981] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[    5.441674] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[    5.442363] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[    5.443040] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[    5.443739] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[    5.444424] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[    5.445101] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[    5.445790] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[    5.446478] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[    5.447149] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(P)=
  OK
[    5.447816] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(Q)=
  OK
[    5.448519] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    5.449187] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    5.449865] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    5.450582] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    5.451255] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    5.451939] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    5.452789] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    5.453896] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    5.454996] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[    5.456164] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[    5.457239] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[    5.458333] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[    5.459499] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[    5.460650] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[    5.461728] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[    5.462818] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[    5.463914] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[    5.465079] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[    5.466241] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[    5.467411] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[    5.468534] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(P)=
  OK
[    5.469580] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(Q)=
  OK
[    5.470733] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    5.471845] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    5.472951] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    5.474037] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    5.475131] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    5.476223] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    5.477310] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    5.478515] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[    5.479601] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[    5.480716] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[    5.481829] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[    5.482921] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[    5.484118] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[    5.485257] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[    5.486369] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[    5.487474] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[    5.488548] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[    5.489607] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[    5.490731] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[    5.491844] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(P)=
  OK
[    5.492968] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(Q)=
  OK
[    5.494095] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    5.495182] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    5.496291] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    5.497431] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    5.498571] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    5.499690] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    5.500842] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[    5.501967] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[    5.503103] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[    5.504245] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[    5.505373] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[    5.506530] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[    5.507623] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[    5.508776] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[    5.509887] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[    5.511074] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[    5.512197] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[    5.513336] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[    5.514459] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(P)=
  OK
[    5.515584] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(Q)=
  OK
[    5.516678] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    5.517795] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    5.518911] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    5.520013] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    5.521150] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    5.522238] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[    5.523416] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[    5.524478] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[    5.525589] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[    5.526702] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[    5.527789] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[    5.528858] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[    5.529941] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[    5.531137] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[    5.532311] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[    5.533364] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[    5.534466] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[    5.535545] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(P)=
  OK
[    5.536571] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(Q)=
  OK
[    5.537619] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    5.538688] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    5.539738] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    5.540936] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    5.542094] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[    5.543172] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[    5.544359] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[    5.545451] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[    5.546549] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[    5.547653] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[    5.548763] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[    5.549884] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[    5.551298] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[    5.552356] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[    5.553469] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[    5.554605] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[    5.555717] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(P)=
  OK
[    5.556817] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(Q)=
  OK
[    5.557913] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    5.559048] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    5.560192] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    5.561320] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[    5.562387] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[    5.563546] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[    5.564735] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[    5.565905] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[    5.567083] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[    5.568259] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[    5.569445] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[    5.570689] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[    5.571871] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[    5.573039] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[    5.574218] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[    5.575404] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(P)=
  OK
[    5.576544] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(Q)=
  OK
[    5.577715] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    5.578882] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    5.580105] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[    5.581314] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[    5.582492] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[    5.583686] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[    5.584862] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[    5.586049] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[    5.587257] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[    5.588433] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[    5.589615] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[    5.590839] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[    5.592026] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[    5.593213] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[    5.594388] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(P)=
  OK
[    5.595539] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(Q)=
  OK
[    5.596723] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    5.597907] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[    5.599108] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[    5.600333] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[    5.601454] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[    5.602636] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[    5.603827] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[    5.605015] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[    5.606191] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[    5.607372] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[    5.608561] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[    5.609737] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[    5.610980] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[    5.612162] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(P)=
  OK
[    5.613315] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(Q)=
  OK
[    5.614514] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[    5.615705] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[    5.616884] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[    5.618060] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[    5.619250] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[    5.620489] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[    5.621703] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[    5.622913] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[    5.624116] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[    5.625350] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[    5.626522] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[    5.627699] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[    5.628882] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(P)=
  OK
[    5.630088] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(Q)=
  OK
[    5.631252] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[    5.632451] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[    5.633645] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[    5.634825] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[    5.636019] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[    5.637166] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[    5.638324] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[    5.639461] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[    5.640603] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[    5.641749] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[    5.642866] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[    5.643960] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(P=
)  OK
[    5.645051] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(Q=
)  OK
[    5.646159] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[    5.647290] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[    5.648435] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[    5.649555] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[    5.650755] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[    5.651814] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[    5.652922] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[    5.654024] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[    5.655129] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[    5.656256] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[    5.657389] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(P=
)  OK
[    5.658523] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(Q=
)  OK
[    5.659669] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[    5.660821] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[    5.661965] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[    5.663087] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[    5.664215] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[    5.665363] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[    5.666503] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[    5.667654] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[    5.668837] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[    5.670073] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(P=
)  OK
[    5.671238] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(Q=
)  OK
[    5.672356] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[    5.673476] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[    5.674604] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[    5.675734] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[    5.676873] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[    5.678009] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[    5.679159] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[    5.680360] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[    5.681486] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(P=
)  OK
[    5.682497] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(Q=
)  OK
[    5.683186] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[    5.683895] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[    5.684595] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[    5.685294] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[    5.685985] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[    5.686681] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[    5.687382] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[    5.688067] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(P=
)  OK
[    5.688764] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(Q=
)  OK
[    5.689466] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[    5.690281] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[    5.690976] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[    5.691682] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[    5.692375] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[    5.693067] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[    5.693770] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(P=
)  OK
[    5.694457] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(Q=
)  OK
[    5.695144] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[    5.695847] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[    5.696539] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[    5.697226] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[    5.697926] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[    5.698638] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(P=
)  OK
[    5.699318] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(Q=
)  OK
[    5.700063] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[    5.700764] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[    5.701460] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[    5.702144] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[    5.702836] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(P=
)  OK
[    5.703520] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(Q=
)  OK
[    5.704208] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[    5.704905] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[    5.705604] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[    5.706292] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(P=
)  OK
[    5.706966] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(Q=
)  OK
[    5.707671] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[    5.708380] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[    5.709077] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(P=
)  OK
[    5.709764] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(Q=
)  OK
[    5.710570] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[    5.711278] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(P=
)  OK
[    5.711954] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(Q=
)  OK
[    5.712644] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(P=
)  OK
[    5.713330] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(Q=
)  OK
[    5.714003] raid6test: test_disks(22, 23): faila=3D 22(P)  failb=3D 23(Q=
)  OK
[    5.715407] raid6test: testing the 64-disk case...
[    5.715995] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    5.716743] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    5.717494] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    5.718229] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    5.718991] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    5.719741] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    5.720537] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    5.721266] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    5.722008] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    5.722755] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[    5.723508] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[    5.724252] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[    5.725000] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[    5.725758] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[    5.726503] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[    5.727242] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[    5.727996] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[    5.728759] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[    5.729518] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[    5.730302] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[    5.731037] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[    5.732126] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(D)=
  OK
[    5.733395] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(D)=
  OK
[    5.734632] raid6test: test_disks(0, 24): faila=3D  0(D)  failb=3D 24(D)=
  OK
[    5.735898] raid6test: test_disks(0, 25): faila=3D  0(D)  failb=3D 25(D)=
  OK
[    5.737167] raid6test: test_disks(0, 26): faila=3D  0(D)  failb=3D 26(D)=
  OK
[    5.738453] raid6test: test_disks(0, 27): faila=3D  0(D)  failb=3D 27(D)=
  OK
[    5.739714] raid6test: test_disks(0, 28): faila=3D  0(D)  failb=3D 28(D)=
  OK
[    5.741232] raid6test: test_disks(0, 29): faila=3D  0(D)  failb=3D 29(D)=
  OK
[    5.742604] raid6test: test_disks(0, 30): faila=3D  0(D)  failb=3D 30(D)=
  OK
[    5.743877] raid6test: test_disks(0, 31): faila=3D  0(D)  failb=3D 31(D)=
  OK
[    5.745015] raid6test: test_disks(0, 32): faila=3D  0(D)  failb=3D 32(D)=
  OK
[    5.746293] raid6test: test_disks(0, 33): faila=3D  0(D)  failb=3D 33(D)=
  OK
[    5.747557] raid6test: test_disks(0, 34): faila=3D  0(D)  failb=3D 34(D)=
  OK
[    5.748846] raid6test: test_disks(0, 35): faila=3D  0(D)  failb=3D 35(D)=
  OK
[    5.750198] raid6test: test_disks(0, 36): faila=3D  0(D)  failb=3D 36(D)=
  OK
[    5.751471] raid6test: test_disks(0, 37): faila=3D  0(D)  failb=3D 37(D)=
  OK
[    5.752737] raid6test: test_disks(0, 38): faila=3D  0(D)  failb=3D 38(D)=
  OK
[    5.753996] raid6test: test_disks(0, 39): faila=3D  0(D)  failb=3D 39(D)=
  OK
[    5.755251] raid6test: test_disks(0, 40): faila=3D  0(D)  failb=3D 40(D)=
  OK
[    5.756545] raid6test: test_disks(0, 41): faila=3D  0(D)  failb=3D 41(D)=
  OK
[    5.757831] raid6test: test_disks(0, 42): faila=3D  0(D)  failb=3D 42(D)=
  OK
[    5.759145] raid6test: test_disks(0, 43): faila=3D  0(D)  failb=3D 43(D)=
  OK
[    5.760488] raid6test: test_disks(0, 44): faila=3D  0(D)  failb=3D 44(D)=
  OK
[    5.761767] raid6test: test_disks(0, 45): faila=3D  0(D)  failb=3D 45(D)=
  OK
[    5.763076] raid6test: test_disks(0, 46): faila=3D  0(D)  failb=3D 46(D)=
  OK
[    5.764379] raid6test: test_disks(0, 47): faila=3D  0(D)  failb=3D 47(D)=
  OK
[    5.765644] raid6test: test_disks(0, 48): faila=3D  0(D)  failb=3D 48(D)=
  OK
[    5.766916] raid6test: test_disks(0, 49): faila=3D  0(D)  failb=3D 49(D)=
  OK
[    5.768191] raid6test: test_disks(0, 50): faila=3D  0(D)  failb=3D 50(D)=
  OK
[    5.769476] raid6test: test_disks(0, 51): faila=3D  0(D)  failb=3D 51(D)=
  OK
[    5.770795] raid6test: test_disks(0, 52): faila=3D  0(D)  failb=3D 52(D)=
  OK
[    5.772062] raid6test: test_disks(0, 53): faila=3D  0(D)  failb=3D 53(D)=
  OK
[    5.773327] raid6test: test_disks(0, 54): faila=3D  0(D)  failb=3D 54(D)=
  OK
[    5.774591] raid6test: test_disks(0, 55): faila=3D  0(D)  failb=3D 55(D)=
  OK
[    5.775853] raid6test: test_disks(0, 56): faila=3D  0(D)  failb=3D 56(D)=
  OK
[    5.777095] raid6test: test_disks(0, 57): faila=3D  0(D)  failb=3D 57(D)=
  OK
[    5.778397] raid6test: test_disks(0, 58): faila=3D  0(D)  failb=3D 58(D)=
  OK
[    5.779674] raid6test: test_disks(0, 59): faila=3D  0(D)  failb=3D 59(D)=
  OK
[    5.781004] raid6test: test_disks(0, 60): faila=3D  0(D)  failb=3D 60(D)=
  OK
[    5.782294] raid6test: test_disks(0, 61): faila=3D  0(D)  failb=3D 61(D)=
  OK
[    5.783544] raid6test: test_disks(0, 62): faila=3D  0(D)  failb=3D 62(P)=
  OK
[    5.784810] raid6test: test_disks(0, 63): faila=3D  0(D)  failb=3D 63(Q)=
  OK
[    5.786102] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    5.787369] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    5.788621] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    5.789854] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    5.791150] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    5.792431] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    5.793695] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    5.794945] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    5.796190] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[    5.797451] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[    5.798741] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[    5.800015] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[    5.801344] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[    5.802624] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[    5.803890] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[    5.805153] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[    5.805984] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[    5.806745] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[    5.807494] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[    5.808226] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[    5.808998] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(D)=
  OK
[    5.809745] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(D)=
  OK
[    5.810533] raid6test: test_disks(1, 24): faila=3D  1(D)  failb=3D 24(D)=
  OK
[    5.811285] raid6test: test_disks(1, 25): faila=3D  1(D)  failb=3D 25(D)=
  OK
[    5.812026] raid6test: test_disks(1, 26): faila=3D  1(D)  failb=3D 26(D)=
  OK
[    5.812781] raid6test: test_disks(1, 27): faila=3D  1(D)  failb=3D 27(D)=
  OK
[    5.813527] raid6test: test_disks(1, 28): faila=3D  1(D)  failb=3D 28(D)=
  OK
[    5.814277] raid6test: test_disks(1, 29): faila=3D  1(D)  failb=3D 29(D)=
  OK
[    5.815019] raid6test: test_disks(1, 30): faila=3D  1(D)  failb=3D 30(D)=
  OK
[    5.815765] raid6test: test_disks(1, 31): faila=3D  1(D)  failb=3D 31(D)=
  OK
[    5.816517] raid6test: test_disks(1, 32): faila=3D  1(D)  failb=3D 32(D)=
  OK
[    5.817264] raid6test: test_disks(1, 33): faila=3D  1(D)  failb=3D 33(D)=
  OK
[    5.818007] raid6test: test_disks(1, 34): faila=3D  1(D)  failb=3D 34(D)=
  OK
[    5.818778] raid6test: test_disks(1, 35): faila=3D  1(D)  failb=3D 35(D)=
  OK
[    5.819522] raid6test: test_disks(1, 36): faila=3D  1(D)  failb=3D 36(D)=
  OK
[    5.820304] raid6test: test_disks(1, 37): faila=3D  1(D)  failb=3D 37(D)=
  OK
[    5.821050] raid6test: test_disks(1, 38): faila=3D  1(D)  failb=3D 38(D)=
  OK
[    5.821800] raid6test: test_disks(1, 39): faila=3D  1(D)  failb=3D 39(D)=
  OK
[    5.822557] raid6test: test_disks(1, 40): faila=3D  1(D)  failb=3D 40(D)=
  OK
[    5.823303] raid6test: test_disks(1, 41): faila=3D  1(D)  failb=3D 41(D)=
  OK
[    5.824041] raid6test: test_disks(1, 42): faila=3D  1(D)  failb=3D 42(D)=
  OK
[    5.824796] raid6test: test_disks(1, 43): faila=3D  1(D)  failb=3D 43(D)=
  OK
[    5.825539] raid6test: test_disks(1, 44): faila=3D  1(D)  failb=3D 44(D)=
  OK
[    5.826287] raid6test: test_disks(1, 45): faila=3D  1(D)  failb=3D 45(D)=
  OK
[    5.827375] raid6test: test_disks(1, 46): faila=3D  1(D)  failb=3D 46(D)=
  OK
[    5.828614] raid6test: test_disks(1, 47): faila=3D  1(D)  failb=3D 47(D)=
  OK
[    5.829861] raid6test: test_disks(1, 48): faila=3D  1(D)  failb=3D 48(D)=
  OK
[    5.831122] raid6test: test_disks(1, 49): faila=3D  1(D)  failb=3D 49(D)=
  OK
[    5.832218] raid6test: test_disks(1, 50): faila=3D  1(D)  failb=3D 50(D)=
  OK
[    5.833296] raid6test: test_disks(1, 51): faila=3D  1(D)  failb=3D 51(D)=
  OK
[    5.834508] raid6test: test_disks(1, 52): faila=3D  1(D)  failb=3D 52(D)=
  OK
[    5.835686] raid6test: test_disks(1, 53): faila=3D  1(D)  failb=3D 53(D)=
  OK
[    5.836943] raid6test: test_disks(1, 54): faila=3D  1(D)  failb=3D 54(D)=
  OK
[    5.838204] raid6test: test_disks(1, 55): faila=3D  1(D)  failb=3D 55(D)=
  OK
[    5.839512] raid6test: test_disks(1, 56): faila=3D  1(D)  failb=3D 56(D)=
  OK
[    5.840945] raid6test: test_disks(1, 57): faila=3D  1(D)  failb=3D 57(D)=
  OK
[    5.842211] raid6test: test_disks(1, 58): faila=3D  1(D)  failb=3D 58(D)=
  OK
[    5.843467] raid6test: test_disks(1, 59): faila=3D  1(D)  failb=3D 59(D)=
  OK
[    5.844716] raid6test: test_disks(1, 60): faila=3D  1(D)  failb=3D 60(D)=
  OK
[    5.845948] raid6test: test_disks(1, 61): faila=3D  1(D)  failb=3D 61(D)=
  OK
[    5.847167] raid6test: test_disks(1, 62): faila=3D  1(D)  failb=3D 62(P)=
  OK
[    5.848409] raid6test: test_disks(1, 63): faila=3D  1(D)  failb=3D 63(Q)=
  OK
[    5.849676] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    5.851007] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    5.852236] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    5.853469] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    5.854709] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    5.855904] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    5.857152] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    5.858413] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[    5.859669] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[    5.860961] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[    5.862224] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[    5.863480] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[    5.864716] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[    5.865918] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[    5.867154] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[    5.868474] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[    5.869721] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[    5.871013] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[    5.872282] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[    5.873564] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(D)=
  OK
[    5.874818] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(D)=
  OK
[    5.876079] raid6test: test_disks(2, 24): faila=3D  2(D)  failb=3D 24(D)=
  OK
[    5.877351] raid6test: test_disks(2, 25): faila=3D  2(D)  failb=3D 25(D)=
  OK
[    5.878514] raid6test: test_disks(2, 26): faila=3D  2(D)  failb=3D 26(D)=
  OK
[    5.879254] raid6test: test_disks(2, 27): faila=3D  2(D)  failb=3D 27(D)=
  OK
[    5.879999] raid6test: test_disks(2, 28): faila=3D  2(D)  failb=3D 28(D)=
  OK
[    5.880791] raid6test: test_disks(2, 29): faila=3D  2(D)  failb=3D 29(D)=
  OK
[    5.881543] raid6test: test_disks(2, 30): faila=3D  2(D)  failb=3D 30(D)=
  OK
[    5.882285] raid6test: test_disks(2, 31): faila=3D  2(D)  failb=3D 31(D)=
  OK
[    5.883021] raid6test: test_disks(2, 32): faila=3D  2(D)  failb=3D 32(D)=
  OK
[    5.883766] raid6test: test_disks(2, 33): faila=3D  2(D)  failb=3D 33(D)=
  OK
[    5.884517] raid6test: test_disks(2, 34): faila=3D  2(D)  failb=3D 34(D)=
  OK
[    5.885252] raid6test: test_disks(2, 35): faila=3D  2(D)  failb=3D 35(D)=
  OK
[    5.886003] raid6test: test_disks(2, 36): faila=3D  2(D)  failb=3D 36(D)=
  OK
[    5.886759] raid6test: test_disks(2, 37): faila=3D  2(D)  failb=3D 37(D)=
  OK
[    5.887503] raid6test: test_disks(2, 38): faila=3D  2(D)  failb=3D 38(D)=
  OK
[    5.888240] raid6test: test_disks(2, 39): faila=3D  2(D)  failb=3D 39(D)=
  OK
[    5.889005] raid6test: test_disks(2, 40): faila=3D  2(D)  failb=3D 40(D)=
  OK
[    5.889748] raid6test: test_disks(2, 41): faila=3D  2(D)  failb=3D 41(D)=
  OK
[    5.890543] raid6test: test_disks(2, 42): faila=3D  2(D)  failb=3D 42(D)=
  OK
[    5.891292] raid6test: test_disks(2, 43): faila=3D  2(D)  failb=3D 43(D)=
  OK
[    5.892041] raid6test: test_disks(2, 44): faila=3D  2(D)  failb=3D 44(D)=
  OK
[    5.892791] raid6test: test_disks(2, 45): faila=3D  2(D)  failb=3D 45(D)=
  OK
[    5.893555] raid6test: test_disks(2, 46): faila=3D  2(D)  failb=3D 46(D)=
  OK
[    5.894302] raid6test: test_disks(2, 47): faila=3D  2(D)  failb=3D 47(D)=
  OK
[    5.895037] raid6test: test_disks(2, 48): faila=3D  2(D)  failb=3D 48(D)=
  OK
[    5.895779] raid6test: test_disks(2, 49): faila=3D  2(D)  failb=3D 49(D)=
  OK
[    5.896530] raid6test: test_disks(2, 50): faila=3D  2(D)  failb=3D 50(D)=
  OK
[    5.897272] raid6test: test_disks(2, 51): faila=3D  2(D)  failb=3D 51(D)=
  OK
[    5.898011] raid6test: test_disks(2, 52): faila=3D  2(D)  failb=3D 52(D)=
  OK
[    5.898774] raid6test: test_disks(2, 53): faila=3D  2(D)  failb=3D 53(D)=
  OK
[    5.899520] raid6test: test_disks(2, 54): faila=3D  2(D)  failb=3D 54(D)=
  OK
[    5.900302] raid6test: test_disks(2, 55): faila=3D  2(D)  failb=3D 55(D)=
  OK
[    5.901040] raid6test: test_disks(2, 56): faila=3D  2(D)  failb=3D 56(D)=
  OK
[    5.901791] raid6test: test_disks(2, 57): faila=3D  2(D)  failb=3D 57(D)=
  OK
[    5.902547] raid6test: test_disks(2, 58): faila=3D  2(D)  failb=3D 58(D)=
  OK
[    5.903293] raid6test: test_disks(2, 59): faila=3D  2(D)  failb=3D 59(D)=
  OK
[    5.904030] raid6test: test_disks(2, 60): faila=3D  2(D)  failb=3D 60(D)=
  OK
[    5.904782] raid6test: test_disks(2, 61): faila=3D  2(D)  failb=3D 61(D)=
  OK
[    5.905520] raid6test: test_disks(2, 62): faila=3D  2(D)  failb=3D 62(P)=
  OK
[    5.906250] raid6test: test_disks(2, 63): faila=3D  2(D)  failb=3D 63(Q)=
  OK
[    5.907003] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    5.907741] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    5.908492] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    5.909223] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    5.909958] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    5.910733] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    5.911480] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[    5.912216] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[    5.912968] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[    5.913715] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[    5.914467] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[    5.915205] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[    5.915951] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[    5.916703] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[    5.917451] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[    5.918190] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[    5.918956] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[    5.919710] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[    5.920494] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(D)=
  OK
[    5.921232] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(D)=
  OK
[    5.921985] raid6test: test_disks(3, 24): faila=3D  3(D)  failb=3D 24(D)=
  OK
[    5.922729] raid6test: test_disks(3, 25): faila=3D  3(D)  failb=3D 25(D)=
  OK
[    5.923482] raid6test: test_disks(3, 26): faila=3D  3(D)  failb=3D 26(D)=
  OK
[    5.924220] raid6test: test_disks(3, 27): faila=3D  3(D)  failb=3D 27(D)=
  OK
[    5.924966] raid6test: test_disks(3, 28): faila=3D  3(D)  failb=3D 28(D)=
  OK
[    5.925719] raid6test: test_disks(3, 29): faila=3D  3(D)  failb=3D 29(D)=
  OK
[    5.926472] raid6test: test_disks(3, 30): faila=3D  3(D)  failb=3D 30(D)=
  OK
[    5.927211] raid6test: test_disks(3, 31): faila=3D  3(D)  failb=3D 31(D)=
  OK
[    5.927965] raid6test: test_disks(3, 32): faila=3D  3(D)  failb=3D 32(D)=
  OK
[    5.928722] raid6test: test_disks(3, 33): faila=3D  3(D)  failb=3D 33(D)=
  OK
[    5.929474] raid6test: test_disks(3, 34): faila=3D  3(D)  failb=3D 34(D)=
  OK
[    5.930243] raid6test: test_disks(3, 35): faila=3D  3(D)  failb=3D 35(D)=
  OK
[    5.930988] raid6test: test_disks(3, 36): faila=3D  3(D)  failb=3D 36(D)=
  OK
[    5.931737] raid6test: test_disks(3, 37): faila=3D  3(D)  failb=3D 37(D)=
  OK
[    5.932487] raid6test: test_disks(3, 38): faila=3D  3(D)  failb=3D 38(D)=
  OK
[    5.933226] raid6test: test_disks(3, 39): faila=3D  3(D)  failb=3D 39(D)=
  OK
[    5.933983] raid6test: test_disks(3, 40): faila=3D  3(D)  failb=3D 40(D)=
  OK
[    5.934737] raid6test: test_disks(3, 41): faila=3D  3(D)  failb=3D 41(D)=
  OK
[    5.935488] raid6test: test_disks(3, 42): faila=3D  3(D)  failb=3D 42(D)=
  OK
[    5.936226] raid6test: test_disks(3, 43): faila=3D  3(D)  failb=3D 43(D)=
  OK
[    5.936973] raid6test: test_disks(3, 44): faila=3D  3(D)  failb=3D 44(D)=
  OK
[    5.937725] raid6test: test_disks(3, 45): faila=3D  3(D)  failb=3D 45(D)=
  OK
[    5.938484] raid6test: test_disks(3, 46): faila=3D  3(D)  failb=3D 46(D)=
  OK
[    5.939219] raid6test: test_disks(3, 47): faila=3D  3(D)  failb=3D 47(D)=
  OK
[    5.939970] raid6test: test_disks(3, 48): faila=3D  3(D)  failb=3D 48(D)=
  OK
[    5.940747] raid6test: test_disks(3, 49): faila=3D  3(D)  failb=3D 49(D)=
  OK
[    5.941500] raid6test: test_disks(3, 50): faila=3D  3(D)  failb=3D 50(D)=
  OK
[    5.942235] raid6test: test_disks(3, 51): faila=3D  3(D)  failb=3D 51(D)=
  OK
[    5.942992] raid6test: test_disks(3, 52): faila=3D  3(D)  failb=3D 52(D)=
  OK
[    5.943745] raid6test: test_disks(3, 53): faila=3D  3(D)  failb=3D 53(D)=
  OK
[    5.944484] raid6test: test_disks(3, 54): faila=3D  3(D)  failb=3D 54(D)=
  OK
[    5.945221] raid6test: test_disks(3, 55): faila=3D  3(D)  failb=3D 55(D)=
  OK
[    5.945971] raid6test: test_disks(3, 56): faila=3D  3(D)  failb=3D 56(D)=
  OK
[    5.946714] raid6test: test_disks(3, 57): faila=3D  3(D)  failb=3D 57(D)=
  OK
[    5.947465] raid6test: test_disks(3, 58): faila=3D  3(D)  failb=3D 58(D)=
  OK
[    5.948201] raid6test: test_disks(3, 59): faila=3D  3(D)  failb=3D 59(D)=
  OK
[    5.948956] raid6test: test_disks(3, 60): faila=3D  3(D)  failb=3D 60(D)=
  OK
[    5.949707] raid6test: test_disks(3, 61): faila=3D  3(D)  failb=3D 61(D)=
  OK
[    5.950478] raid6test: test_disks(3, 62): faila=3D  3(D)  failb=3D 62(P)=
  OK
[    5.951208] raid6test: test_disks(3, 63): faila=3D  3(D)  failb=3D 63(Q)=
  OK
[    5.951963] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    5.952697] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    5.953439] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    5.954169] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    5.954906] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    5.955651] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[    5.956397] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[    5.957133] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[    5.957888] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[    5.958652] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[    5.959405] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[    5.960219] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[    5.960968] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[    5.961722] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[    5.962467] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[    5.963202] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[    5.963952] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[    5.964699] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(D)=
  OK
[    5.965448] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(D)=
  OK
[    5.966184] raid6test: test_disks(4, 24): faila=3D  4(D)  failb=3D 24(D)=
  OK
[    5.966929] raid6test: test_disks(4, 25): faila=3D  4(D)  failb=3D 25(D)=
  OK
[    5.967680] raid6test: test_disks(4, 26): faila=3D  4(D)  failb=3D 26(D)=
  OK
[    5.968434] raid6test: test_disks(4, 27): faila=3D  4(D)  failb=3D 27(D)=
  OK
[    5.969171] raid6test: test_disks(4, 28): faila=3D  4(D)  failb=3D 28(D)=
  OK
[    5.969921] raid6test: test_disks(4, 29): faila=3D  4(D)  failb=3D 29(D)=
  OK
[    5.970769] raid6test: test_disks(4, 30): faila=3D  4(D)  failb=3D 30(D)=
  OK
[    5.971524] raid6test: test_disks(4, 31): faila=3D  4(D)  failb=3D 31(D)=
  OK
[    5.972275] raid6test: test_disks(4, 32): faila=3D  4(D)  failb=3D 32(D)=
  OK
[    5.973022] raid6test: test_disks(4, 33): faila=3D  4(D)  failb=3D 33(D)=
  OK
[    5.973774] raid6test: test_disks(4, 34): faila=3D  4(D)  failb=3D 34(D)=
  OK
[    5.974526] raid6test: test_disks(4, 35): faila=3D  4(D)  failb=3D 35(D)=
  OK
[    5.975272] raid6test: test_disks(4, 36): faila=3D  4(D)  failb=3D 36(D)=
  OK
[    5.976008] raid6test: test_disks(4, 37): faila=3D  4(D)  failb=3D 37(D)=
  OK
[    5.976757] raid6test: test_disks(4, 38): faila=3D  4(D)  failb=3D 38(D)=
  OK
[    5.977504] raid6test: test_disks(4, 39): faila=3D  4(D)  failb=3D 39(D)=
  OK
[    5.978241] raid6test: test_disks(4, 40): faila=3D  4(D)  failb=3D 40(D)=
  OK
[    5.979001] raid6test: test_disks(4, 41): faila=3D  4(D)  failb=3D 41(D)=
  OK
[    5.979752] raid6test: test_disks(4, 42): faila=3D  4(D)  failb=3D 42(D)=
  OK
[    5.980528] raid6test: test_disks(4, 43): faila=3D  4(D)  failb=3D 43(D)=
  OK
[    5.981273] raid6test: test_disks(4, 44): faila=3D  4(D)  failb=3D 44(D)=
  OK
[    5.982012] raid6test: test_disks(4, 45): faila=3D  4(D)  failb=3D 45(D)=
  OK
[    5.982760] raid6test: test_disks(4, 46): faila=3D  4(D)  failb=3D 46(D)=
  OK
[    5.983511] raid6test: test_disks(4, 47): faila=3D  4(D)  failb=3D 47(D)=
  OK
[    5.984260] raid6test: test_disks(4, 48): faila=3D  4(D)  failb=3D 48(D)=
  OK
[    5.984998] raid6test: test_disks(4, 49): faila=3D  4(D)  failb=3D 49(D)=
  OK
[    5.985752] raid6test: test_disks(4, 50): faila=3D  4(D)  failb=3D 50(D)=
  OK
[    5.986497] raid6test: test_disks(4, 51): faila=3D  4(D)  failb=3D 51(D)=
  OK
[    5.987237] raid6test: test_disks(4, 52): faila=3D  4(D)  failb=3D 52(D)=
  OK
[    5.987989] raid6test: test_disks(4, 53): faila=3D  4(D)  failb=3D 53(D)=
  OK
[    5.988746] raid6test: test_disks(4, 54): faila=3D  4(D)  failb=3D 54(D)=
  OK
[    5.989497] raid6test: test_disks(4, 55): faila=3D  4(D)  failb=3D 55(D)=
  OK
[    5.990373] raid6test: test_disks(4, 56): faila=3D  4(D)  failb=3D 56(D)=
  OK
[    5.991117] raid6test: test_disks(4, 57): faila=3D  4(D)  failb=3D 57(D)=
  OK
[    5.991867] raid6test: test_disks(4, 58): faila=3D  4(D)  failb=3D 58(D)=
  OK
[    5.992614] raid6test: test_disks(4, 59): faila=3D  4(D)  failb=3D 59(D)=
  OK
[    5.993361] raid6test: test_disks(4, 60): faila=3D  4(D)  failb=3D 60(D)=
  OK
[    5.994096] raid6test: test_disks(4, 61): faila=3D  4(D)  failb=3D 61(D)=
  OK
[    5.994840] raid6test: test_disks(4, 62): faila=3D  4(D)  failb=3D 62(P)=
  OK
[    5.995583] raid6test: test_disks(4, 63): faila=3D  4(D)  failb=3D 63(Q)=
  OK
[    5.996324] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    5.997050] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    5.997792] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    5.998536] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    5.999273] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[    6.000048] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[    6.000792] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[    6.001546] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[    6.002291] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[    6.003027] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[    6.003776] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[    6.004521] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[    6.005257] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[    6.005998] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[    6.006748] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[    6.007501] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[    6.008239] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(D)=
  OK
[    6.008991] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(D)=
  OK
[    6.009740] raid6test: test_disks(5, 24): faila=3D  5(D)  failb=3D 24(D)=
  OK
[    6.010663] raid6test: test_disks(5, 25): faila=3D  5(D)  failb=3D 25(D)=
  OK
[    6.011423] raid6test: test_disks(5, 26): faila=3D  5(D)  failb=3D 26(D)=
  OK
[    6.012158] raid6test: test_disks(5, 27): faila=3D  5(D)  failb=3D 27(D)=
  OK
[    6.012903] raid6test: test_disks(5, 28): faila=3D  5(D)  failb=3D 28(D)=
  OK
[    6.013650] raid6test: test_disks(5, 29): faila=3D  5(D)  failb=3D 29(D)=
  OK
[    6.014386] raid6test: test_disks(5, 30): faila=3D  5(D)  failb=3D 30(D)=
  OK
[    6.015121] raid6test: test_disks(5, 31): faila=3D  5(D)  failb=3D 31(D)=
  OK
[    6.015874] raid6test: test_disks(5, 32): faila=3D  5(D)  failb=3D 32(D)=
  OK
[    6.016618] raid6test: test_disks(5, 33): faila=3D  5(D)  failb=3D 33(D)=
  OK
[    6.017364] raid6test: test_disks(5, 34): faila=3D  5(D)  failb=3D 34(D)=
  OK
[    6.018101] raid6test: test_disks(5, 35): faila=3D  5(D)  failb=3D 35(D)=
  OK
[    6.018858] raid6test: test_disks(5, 36): faila=3D  5(D)  failb=3D 36(D)=
  OK
[    6.019609] raid6test: test_disks(5, 37): faila=3D  5(D)  failb=3D 37(D)=
  OK
[    6.020409] raid6test: test_disks(5, 38): faila=3D  5(D)  failb=3D 38(D)=
  OK
[    6.021148] raid6test: test_disks(5, 39): faila=3D  5(D)  failb=3D 39(D)=
  OK
[    6.021903] raid6test: test_disks(5, 40): faila=3D  5(D)  failb=3D 40(D)=
  OK
[    6.022655] raid6test: test_disks(5, 41): faila=3D  5(D)  failb=3D 41(D)=
  OK
[    6.023405] raid6test: test_disks(5, 42): faila=3D  5(D)  failb=3D 42(D)=
  OK
[    6.024145] raid6test: test_disks(5, 43): faila=3D  5(D)  failb=3D 43(D)=
  OK
[    6.024897] raid6test: test_disks(5, 44): faila=3D  5(D)  failb=3D 44(D)=
  OK
[    6.025651] raid6test: test_disks(5, 45): faila=3D  5(D)  failb=3D 45(D)=
  OK
[    6.026398] raid6test: test_disks(5, 46): faila=3D  5(D)  failb=3D 46(D)=
  OK
[    6.027142] raid6test: test_disks(5, 47): faila=3D  5(D)  failb=3D 47(D)=
  OK
[    6.027899] raid6test: test_disks(5, 48): faila=3D  5(D)  failb=3D 48(D)=
  OK
[    6.028658] raid6test: test_disks(5, 49): faila=3D  5(D)  failb=3D 49(D)=
  OK
[    6.029413] raid6test: test_disks(5, 50): faila=3D  5(D)  failb=3D 50(D)=
  OK
[    6.030231] raid6test: test_disks(5, 51): faila=3D  5(D)  failb=3D 51(D)=
  OK
[    6.030982] raid6test: test_disks(5, 52): faila=3D  5(D)  failb=3D 52(D)=
  OK
[    6.031735] raid6test: test_disks(5, 53): faila=3D  5(D)  failb=3D 53(D)=
  OK
[    6.032476] raid6test: test_disks(5, 54): faila=3D  5(D)  failb=3D 54(D)=
  OK
[    6.033212] raid6test: test_disks(5, 55): faila=3D  5(D)  failb=3D 55(D)=
  OK
[    6.033962] raid6test: test_disks(5, 56): faila=3D  5(D)  failb=3D 56(D)=
  OK
[    6.034711] raid6test: test_disks(5, 57): faila=3D  5(D)  failb=3D 57(D)=
  OK
[    6.035463] raid6test: test_disks(5, 58): faila=3D  5(D)  failb=3D 58(D)=
  OK
[    6.036203] raid6test: test_disks(5, 59): faila=3D  5(D)  failb=3D 59(D)=
  OK
[    6.036949] raid6test: test_disks(5, 60): faila=3D  5(D)  failb=3D 60(D)=
  OK
[    6.037700] raid6test: test_disks(5, 61): faila=3D  5(D)  failb=3D 61(D)=
  OK
[    6.038466] raid6test: test_disks(5, 62): faila=3D  5(D)  failb=3D 62(P)=
  OK
[    6.039196] raid6test: test_disks(5, 63): faila=3D  5(D)  failb=3D 63(Q)=
  OK
[    6.039948] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    6.040735] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    6.041477] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    6.042206] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[    6.042948] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[    6.043701] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[    6.044446] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[    6.045187] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[    6.045940] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[    6.046685] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[    6.047442] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[    6.048183] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[    6.048946] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[    6.049697] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[    6.050479] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[    6.051215] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(D)=
  OK
[    6.051968] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(D)=
  OK
[    6.052715] raid6test: test_disks(6, 24): faila=3D  6(D)  failb=3D 24(D)=
  OK
[    6.053472] raid6test: test_disks(6, 25): faila=3D  6(D)  failb=3D 25(D)=
  OK
[    6.054210] raid6test: test_disks(6, 26): faila=3D  6(D)  failb=3D 26(D)=
  OK
[    6.054958] raid6test: test_disks(6, 27): faila=3D  6(D)  failb=3D 27(D)=
  OK
[    6.055711] raid6test: test_disks(6, 28): faila=3D  6(D)  failb=3D 28(D)=
  OK
[    6.056460] raid6test: test_disks(6, 29): faila=3D  6(D)  failb=3D 29(D)=
  OK
[    6.057200] raid6test: test_disks(6, 30): faila=3D  6(D)  failb=3D 30(D)=
  OK
[    6.057956] raid6test: test_disks(6, 31): faila=3D  6(D)  failb=3D 31(D)=
  OK
[    6.058715] raid6test: test_disks(6, 32): faila=3D  6(D)  failb=3D 32(D)=
  OK
[    6.059466] raid6test: test_disks(6, 33): faila=3D  6(D)  failb=3D 33(D)=
  OK
[    6.060237] raid6test: test_disks(6, 34): faila=3D  6(D)  failb=3D 34(D)=
  OK
[    6.060974] raid6test: test_disks(6, 35): faila=3D  6(D)  failb=3D 35(D)=
  OK
[    6.061727] raid6test: test_disks(6, 36): faila=3D  6(D)  failb=3D 36(D)=
  OK
[    6.062469] raid6test: test_disks(6, 37): faila=3D  6(D)  failb=3D 37(D)=
  OK
[    6.063206] raid6test: test_disks(6, 38): faila=3D  6(D)  failb=3D 38(D)=
  OK
[    6.063956] raid6test: test_disks(6, 39): faila=3D  6(D)  failb=3D 39(D)=
  OK
[    6.064705] raid6test: test_disks(6, 40): faila=3D  6(D)  failb=3D 40(D)=
  OK
[    6.065456] raid6test: test_disks(6, 41): faila=3D  6(D)  failb=3D 41(D)=
  OK
[    6.066199] raid6test: test_disks(6, 42): faila=3D  6(D)  failb=3D 42(D)=
  OK
[    6.066951] raid6test: test_disks(6, 43): faila=3D  6(D)  failb=3D 43(D)=
  OK
[    6.067701] raid6test: test_disks(6, 44): faila=3D  6(D)  failb=3D 44(D)=
  OK
[    6.068457] raid6test: test_disks(6, 45): faila=3D  6(D)  failb=3D 45(D)=
  OK
[    6.069193] raid6test: test_disks(6, 46): faila=3D  6(D)  failb=3D 46(D)=
  OK
[    6.069943] raid6test: test_disks(6, 47): faila=3D  6(D)  failb=3D 47(D)=
  OK
[    6.070728] raid6test: test_disks(6, 48): faila=3D  6(D)  failb=3D 48(D)=
  OK
[    6.071480] raid6test: test_disks(6, 49): faila=3D  6(D)  failb=3D 49(D)=
  OK
[    6.072220] raid6test: test_disks(6, 50): faila=3D  6(D)  failb=3D 50(D)=
  OK
[    6.072965] raid6test: test_disks(6, 51): faila=3D  6(D)  failb=3D 51(D)=
  OK
[    6.073718] raid6test: test_disks(6, 52): faila=3D  6(D)  failb=3D 52(D)=
  OK
[    6.074459] raid6test: test_disks(6, 53): faila=3D  6(D)  failb=3D 53(D)=
  OK
[    6.075199] raid6test: test_disks(6, 54): faila=3D  6(D)  failb=3D 54(D)=
  OK
[    6.075954] raid6test: test_disks(6, 55): faila=3D  6(D)  failb=3D 55(D)=
  OK
[    6.076698] raid6test: test_disks(6, 56): faila=3D  6(D)  failb=3D 56(D)=
  OK
[    6.077446] raid6test: test_disks(6, 57): faila=3D  6(D)  failb=3D 57(D)=
  OK
[    6.078183] raid6test: test_disks(6, 58): faila=3D  6(D)  failb=3D 58(D)=
  OK
[    6.078932] raid6test: test_disks(6, 59): faila=3D  6(D)  failb=3D 59(D)=
  OK
[    6.079683] raid6test: test_disks(6, 60): faila=3D  6(D)  failb=3D 60(D)=
  OK
[    6.080460] raid6test: test_disks(6, 61): faila=3D  6(D)  failb=3D 61(D)=
  OK
[    6.081198] raid6test: test_disks(6, 62): faila=3D  6(D)  failb=3D 62(P)=
  OK
[    6.081944] raid6test: test_disks(6, 63): faila=3D  6(D)  failb=3D 63(Q)=
  OK
[    6.082694] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    6.083433] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    6.084163] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[    6.084901] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[    6.085657] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[    6.086404] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[    6.087142] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[    6.087895] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[    6.088652] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[    6.089400] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[    6.090181] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[    6.090932] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[    6.091687] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[    6.092442] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[    6.093185] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(D)=
  OK
[    6.093948] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(D)=
  OK
[    6.094698] raid6test: test_disks(7, 24): faila=3D  7(D)  failb=3D 24(D)=
  OK
[    6.095451] raid6test: test_disks(7, 25): faila=3D  7(D)  failb=3D 25(D)=
  OK
[    6.096192] raid6test: test_disks(7, 26): faila=3D  7(D)  failb=3D 26(D)=
  OK
[    6.096940] raid6test: test_disks(7, 27): faila=3D  7(D)  failb=3D 27(D)=
  OK
[    6.097691] raid6test: test_disks(7, 28): faila=3D  7(D)  failb=3D 28(D)=
  OK
[    6.098449] raid6test: test_disks(7, 29): faila=3D  7(D)  failb=3D 29(D)=
  OK
[    6.099187] raid6test: test_disks(7, 30): faila=3D  7(D)  failb=3D 30(D)=
  OK
[    6.099939] raid6test: test_disks(7, 31): faila=3D  7(D)  failb=3D 31(D)=
  OK
[    6.100715] raid6test: test_disks(7, 32): faila=3D  7(D)  failb=3D 32(D)=
  OK
[    6.101464] raid6test: test_disks(7, 33): faila=3D  7(D)  failb=3D 33(D)=
  OK
[    6.102203] raid6test: test_disks(7, 34): faila=3D  7(D)  failb=3D 34(D)=
  OK
[    6.102959] raid6test: test_disks(7, 35): faila=3D  7(D)  failb=3D 35(D)=
  OK
[    6.103708] raid6test: test_disks(7, 36): faila=3D  7(D)  failb=3D 36(D)=
  OK
[    6.104452] raid6test: test_disks(7, 37): faila=3D  7(D)  failb=3D 37(D)=
  OK
[    6.105188] raid6test: test_disks(7, 38): faila=3D  7(D)  failb=3D 38(D)=
  OK
[    6.105939] raid6test: test_disks(7, 39): faila=3D  7(D)  failb=3D 39(D)=
  OK
[    6.106699] raid6test: test_disks(7, 40): faila=3D  7(D)  failb=3D 40(D)=
  OK
[    6.107487] raid6test: test_disks(7, 41): faila=3D  7(D)  failb=3D 41(D)=
  OK
[    6.108223] raid6test: test_disks(7, 42): faila=3D  7(D)  failb=3D 42(D)=
  OK
[    6.108986] raid6test: test_disks(7, 43): faila=3D  7(D)  failb=3D 43(D)=
  OK
[    6.109740] raid6test: test_disks(7, 44): faila=3D  7(D)  failb=3D 44(D)=
  OK
[    6.110517] raid6test: test_disks(7, 45): faila=3D  7(D)  failb=3D 45(D)=
  OK
[    6.111268] raid6test: test_disks(7, 46): faila=3D  7(D)  failb=3D 46(D)=
  OK
[    6.112006] raid6test: test_disks(7, 47): faila=3D  7(D)  failb=3D 47(D)=
  OK
[    6.112754] raid6test: test_disks(7, 48): faila=3D  7(D)  failb=3D 48(D)=
  OK
[    6.113504] raid6test: test_disks(7, 49): faila=3D  7(D)  failb=3D 49(D)=
  OK
[    6.114239] raid6test: test_disks(7, 50): faila=3D  7(D)  failb=3D 50(D)=
  OK
[    6.114980] raid6test: test_disks(7, 51): faila=3D  7(D)  failb=3D 51(D)=
  OK
[    6.115735] raid6test: test_disks(7, 52): faila=3D  7(D)  failb=3D 52(D)=
  OK
[    6.116479] raid6test: test_disks(7, 53): faila=3D  7(D)  failb=3D 53(D)=
  OK
[    6.117216] raid6test: test_disks(7, 54): faila=3D  7(D)  failb=3D 54(D)=
  OK
[    6.117969] raid6test: test_disks(7, 55): faila=3D  7(D)  failb=3D 55(D)=
  OK
[    6.118730] raid6test: test_disks(7, 56): faila=3D  7(D)  failb=3D 56(D)=
  OK
[    6.119482] raid6test: test_disks(7, 57): faila=3D  7(D)  failb=3D 57(D)=
  OK
[    6.120248] raid6test: test_disks(7, 58): faila=3D  7(D)  failb=3D 58(D)=
  OK
[    6.120992] raid6test: test_disks(7, 59): faila=3D  7(D)  failb=3D 59(D)=
  OK
[    6.121742] raid6test: test_disks(7, 60): faila=3D  7(D)  failb=3D 60(D)=
  OK
[    6.122484] raid6test: test_disks(7, 61): faila=3D  7(D)  failb=3D 61(D)=
  OK
[    6.123217] raid6test: test_disks(7, 62): faila=3D  7(D)  failb=3D 62(P)=
  OK
[    6.123961] raid6test: test_disks(7, 63): faila=3D  7(D)  failb=3D 63(Q)=
  OK
[    6.124705] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    6.125449] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[    6.126184] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[    6.126931] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[    6.127683] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[    6.128435] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[    6.129170] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[    6.129925] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[    6.130707] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[    6.131452] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[    6.132187] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[    6.132927] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[    6.133678] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[    6.134432] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(D)=
  OK
[    6.135168] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(D)=
  OK
[    6.135923] raid6test: test_disks(8, 24): faila=3D  8(D)  failb=3D 24(D)=
  OK
[    6.136672] raid6test: test_disks(8, 25): faila=3D  8(D)  failb=3D 25(D)=
  OK
[    6.137426] raid6test: test_disks(8, 26): faila=3D  8(D)  failb=3D 26(D)=
  OK
[    6.138169] raid6test: test_disks(8, 27): faila=3D  8(D)  failb=3D 27(D)=
  OK
[    6.138929] raid6test: test_disks(8, 28): faila=3D  8(D)  failb=3D 28(D)=
  OK
[    6.139677] raid6test: test_disks(8, 29): faila=3D  8(D)  failb=3D 29(D)=
  OK
[    6.140446] raid6test: test_disks(8, 30): faila=3D  8(D)  failb=3D 30(D)=
  OK
[    6.141183] raid6test: test_disks(8, 31): faila=3D  8(D)  failb=3D 31(D)=
  OK
[    6.141939] raid6test: test_disks(8, 32): faila=3D  8(D)  failb=3D 32(D)=
  OK
[    6.142682] raid6test: test_disks(8, 33): faila=3D  8(D)  failb=3D 33(D)=
  OK
[    6.143430] raid6test: test_disks(8, 34): faila=3D  8(D)  failb=3D 34(D)=
  OK
[    6.144168] raid6test: test_disks(8, 35): faila=3D  8(D)  failb=3D 35(D)=
  OK
[    6.144915] raid6test: test_disks(8, 36): faila=3D  8(D)  failb=3D 36(D)=
  OK
[    6.145668] raid6test: test_disks(8, 37): faila=3D  8(D)  failb=3D 37(D)=
  OK
[    6.146416] raid6test: test_disks(8, 38): faila=3D  8(D)  failb=3D 38(D)=
  OK
[    6.147152] raid6test: test_disks(8, 39): faila=3D  8(D)  failb=3D 39(D)=
  OK
[    6.147906] raid6test: test_disks(8, 40): faila=3D  8(D)  failb=3D 40(D)=
  OK
[    6.148665] raid6test: test_disks(8, 41): faila=3D  8(D)  failb=3D 41(D)=
  OK
[    6.149415] raid6test: test_disks(8, 42): faila=3D  8(D)  failb=3D 42(D)=
  OK
[    6.150189] raid6test: test_disks(8, 43): faila=3D  8(D)  failb=3D 43(D)=
  OK
[    6.150931] raid6test: test_disks(8, 44): faila=3D  8(D)  failb=3D 44(D)=
  OK
[    6.151682] raid6test: test_disks(8, 45): faila=3D  8(D)  failb=3D 45(D)=
  OK
[    6.152426] raid6test: test_disks(8, 46): faila=3D  8(D)  failb=3D 46(D)=
  OK
[    6.153162] raid6test: test_disks(8, 47): faila=3D  8(D)  failb=3D 47(D)=
  OK
[    6.153916] raid6test: test_disks(8, 48): faila=3D  8(D)  failb=3D 48(D)=
  OK
[    6.154657] raid6test: test_disks(8, 49): faila=3D  8(D)  failb=3D 49(D)=
  OK
[    6.155402] raid6test: test_disks(8, 50): faila=3D  8(D)  failb=3D 50(D)=
  OK
[    6.156136] raid6test: test_disks(8, 51): faila=3D  8(D)  failb=3D 51(D)=
  OK
[    6.156882] raid6test: test_disks(8, 52): faila=3D  8(D)  failb=3D 52(D)=
  OK
[    6.157630] raid6test: test_disks(8, 53): faila=3D  8(D)  failb=3D 53(D)=
  OK
[    6.158384] raid6test: test_disks(8, 54): faila=3D  8(D)  failb=3D 54(D)=
  OK
[    6.159125] raid6test: test_disks(8, 55): faila=3D  8(D)  failb=3D 55(D)=
  OK
[    6.159875] raid6test: test_disks(8, 56): faila=3D  8(D)  failb=3D 56(D)=
  OK
[    6.160654] raid6test: test_disks(8, 57): faila=3D  8(D)  failb=3D 57(D)=
  OK
[    6.161394] raid6test: test_disks(8, 58): faila=3D  8(D)  failb=3D 58(D)=
  OK
[    6.162134] raid6test: test_disks(8, 59): faila=3D  8(D)  failb=3D 59(D)=
  OK
[    6.162875] raid6test: test_disks(8, 60): faila=3D  8(D)  failb=3D 60(D)=
  OK
[    6.163628] raid6test: test_disks(8, 61): faila=3D  8(D)  failb=3D 61(D)=
  OK
[    6.164371] raid6test: test_disks(8, 62): faila=3D  8(D)  failb=3D 62(P)=
  OK
[    6.165104] raid6test: test_disks(8, 63): faila=3D  8(D)  failb=3D 63(Q)=
  OK
[    6.165850] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[    6.166599] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[    6.167349] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[    6.168087] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[    6.168842] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[    6.169591] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[    6.170374] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[    6.171108] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[    6.171861] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[    6.172604] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[    6.173350] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[    6.174088] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[    6.174835] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(D)=
  OK
[    6.175584] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(D)=
  OK
[    6.176326] raid6test: test_disks(9, 24): faila=3D  9(D)  failb=3D 24(D)=
  OK
[    6.177083] raid6test: test_disks(9, 25): faila=3D  9(D)  failb=3D 25(D)=
  OK
[    6.178337] raid6test: test_disks(9, 26): faila=3D  9(D)  failb=3D 26(D)=
  OK
[    6.179450] raid6test: test_disks(9, 27): faila=3D  9(D)  failb=3D 27(D)=
  OK
[    6.180564] raid6test: test_disks(9, 28): faila=3D  9(D)  failb=3D 28(D)=
  OK
[    6.181786] raid6test: test_disks(9, 29): faila=3D  9(D)  failb=3D 29(D)=
  OK
[    6.182599] raid6test: test_disks(9, 30): faila=3D  9(D)  failb=3D 30(D)=
  OK
[    6.183342] raid6test: test_disks(9, 31): faila=3D  9(D)  failb=3D 31(D)=
  OK
[    6.184076] raid6test: test_disks(9, 32): faila=3D  9(D)  failb=3D 32(D)=
  OK
[    6.184828] raid6test: test_disks(9, 33): faila=3D  9(D)  failb=3D 33(D)=
  OK
[    6.185571] raid6test: test_disks(9, 34): faila=3D  9(D)  failb=3D 34(D)=
  OK
[    6.186312] raid6test: test_disks(9, 35): faila=3D  9(D)  failb=3D 35(D)=
  OK
[    6.187043] raid6test: test_disks(9, 36): faila=3D  9(D)  failb=3D 36(D)=
  OK
[    6.187794] raid6test: test_disks(9, 37): faila=3D  9(D)  failb=3D 37(D)=
  OK
[    6.188573] raid6test: test_disks(9, 38): faila=3D  9(D)  failb=3D 38(D)=
  OK
[    6.189319] raid6test: test_disks(9, 39): faila=3D  9(D)  failb=3D 39(D)=
  OK
[    6.190093] raid6test: test_disks(9, 40): faila=3D  9(D)  failb=3D 40(D)=
  OK
[    6.190875] raid6test: test_disks(9, 41): faila=3D  9(D)  failb=3D 41(D)=
  OK
[    6.191625] raid6test: test_disks(9, 42): faila=3D  9(D)  failb=3D 42(D)=
  OK
[    6.192366] raid6test: test_disks(9, 43): faila=3D  9(D)  failb=3D 43(D)=
  OK
[    6.193103] raid6test: test_disks(9, 44): faila=3D  9(D)  failb=3D 44(D)=
  OK
[    6.193867] raid6test: test_disks(9, 45): faila=3D  9(D)  failb=3D 45(D)=
  OK
[    6.194613] raid6test: test_disks(9, 46): faila=3D  9(D)  failb=3D 46(D)=
  OK
[    6.195360] raid6test: test_disks(9, 47): faila=3D  9(D)  failb=3D 47(D)=
  OK
[    6.196098] raid6test: test_disks(9, 48): faila=3D  9(D)  failb=3D 48(D)=
  OK
[    6.196869] raid6test: test_disks(9, 49): faila=3D  9(D)  failb=3D 49(D)=
  OK
[    6.197652] raid6test: test_disks(9, 50): faila=3D  9(D)  failb=3D 50(D)=
  OK
[    6.198423] raid6test: test_disks(9, 51): faila=3D  9(D)  failb=3D 51(D)=
  OK
[    6.199155] raid6test: test_disks(9, 52): faila=3D  9(D)  failb=3D 52(D)=
  OK
[    6.199904] raid6test: test_disks(9, 53): faila=3D  9(D)  failb=3D 53(D)=
  OK
[    6.200712] raid6test: test_disks(9, 54): faila=3D  9(D)  failb=3D 54(D)=
  OK
[    6.201461] raid6test: test_disks(9, 55): faila=3D  9(D)  failb=3D 55(D)=
  OK
[    6.202192] raid6test: test_disks(9, 56): faila=3D  9(D)  failb=3D 56(D)=
  OK
[    6.202936] raid6test: test_disks(9, 57): faila=3D  9(D)  failb=3D 57(D)=
  OK
[    6.203704] raid6test: test_disks(9, 58): faila=3D  9(D)  failb=3D 58(D)=
  OK
[    6.204454] raid6test: test_disks(9, 59): faila=3D  9(D)  failb=3D 59(D)=
  OK
[    6.205189] raid6test: test_disks(9, 60): faila=3D  9(D)  failb=3D 60(D)=
  OK
[    6.205938] raid6test: test_disks(9, 61): faila=3D  9(D)  failb=3D 61(D)=
  OK
[    6.206718] raid6test: test_disks(9, 62): faila=3D  9(D)  failb=3D 62(P)=
  OK
[    6.207462] raid6test: test_disks(9, 63): faila=3D  9(D)  failb=3D 63(Q)=
  OK
[    6.208199] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[    6.208988] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[    6.209787] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[    6.210581] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[    6.211334] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[    6.212080] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[    6.212833] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[    6.213588] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[    6.214344] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[    6.215093] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[    6.215854] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[    6.216617] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(D=
)  OK
[    6.217368] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(D=
)  OK
[    6.218111] raid6test: test_disks(10, 24): faila=3D 10(D)  failb=3D 24(D=
)  OK
[    6.218886] raid6test: test_disks(10, 25): faila=3D 10(D)  failb=3D 25(D=
)  OK
[    6.219640] raid6test: test_disks(10, 26): faila=3D 10(D)  failb=3D 26(D=
)  OK
[    6.220432] raid6test: test_disks(10, 27): faila=3D 10(D)  failb=3D 27(D=
)  OK
[    6.221182] raid6test: test_disks(10, 28): faila=3D 10(D)  failb=3D 28(D=
)  OK
[    6.221943] raid6test: test_disks(10, 29): faila=3D 10(D)  failb=3D 29(D=
)  OK
[    6.222708] raid6test: test_disks(10, 30): faila=3D 10(D)  failb=3D 30(D=
)  OK
[    6.223462] raid6test: test_disks(10, 31): faila=3D 10(D)  failb=3D 31(D=
)  OK
[    6.224215] raid6test: test_disks(10, 32): faila=3D 10(D)  failb=3D 32(D=
)  OK
[    6.224975] raid6test: test_disks(10, 33): faila=3D 10(D)  failb=3D 33(D=
)  OK
[    6.225732] raid6test: test_disks(10, 34): faila=3D 10(D)  failb=3D 34(D=
)  OK
[    6.226496] raid6test: test_disks(10, 35): faila=3D 10(D)  failb=3D 35(D=
)  OK
[    6.227245] raid6test: test_disks(10, 36): faila=3D 10(D)  failb=3D 36(D=
)  OK
[    6.228006] raid6test: test_disks(10, 37): faila=3D 10(D)  failb=3D 37(D=
)  OK
[    6.228781] raid6test: test_disks(10, 38): faila=3D 10(D)  failb=3D 38(D=
)  OK
[    6.229535] raid6test: test_disks(10, 39): faila=3D 10(D)  failb=3D 39(D=
)  OK
[    6.230318] raid6test: test_disks(10, 40): faila=3D 10(D)  failb=3D 40(D=
)  OK
[    6.231069] raid6test: test_disks(10, 41): faila=3D 10(D)  failb=3D 41(D=
)  OK
[    6.231830] raid6test: test_disks(10, 42): faila=3D 10(D)  failb=3D 42(D=
)  OK
[    6.232593] raid6test: test_disks(10, 43): faila=3D 10(D)  failb=3D 43(D=
)  OK
[    6.233347] raid6test: test_disks(10, 44): faila=3D 10(D)  failb=3D 44(D=
)  OK
[    6.234094] raid6test: test_disks(10, 45): faila=3D 10(D)  failb=3D 45(D=
)  OK
[    6.234857] raid6test: test_disks(10, 46): faila=3D 10(D)  failb=3D 46(D=
)  OK
[    6.235617] raid6test: test_disks(10, 47): faila=3D 10(D)  failb=3D 47(D=
)  OK
[    6.236373] raid6test: test_disks(10, 48): faila=3D 10(D)  failb=3D 48(D=
)  OK
[    6.237114] raid6test: test_disks(10, 49): faila=3D 10(D)  failb=3D 49(D=
)  OK
[    6.237864] raid6test: test_disks(10, 50): faila=3D 10(D)  failb=3D 50(D=
)  OK
[    6.238630] raid6test: test_disks(10, 51): faila=3D 10(D)  failb=3D 51(D=
)  OK
[    6.239377] raid6test: test_disks(10, 52): faila=3D 10(D)  failb=3D 52(D=
)  OK
[    6.240146] raid6test: test_disks(10, 53): faila=3D 10(D)  failb=3D 53(D=
)  OK
[    6.240906] raid6test: test_disks(10, 54): faila=3D 10(D)  failb=3D 54(D=
)  OK
[    6.241664] raid6test: test_disks(10, 55): faila=3D 10(D)  failb=3D 55(D=
)  OK
[    6.242419] raid6test: test_disks(10, 56): faila=3D 10(D)  failb=3D 56(D=
)  OK
[    6.243167] raid6test: test_disks(10, 57): faila=3D 10(D)  failb=3D 57(D=
)  OK
[    6.243922] raid6test: test_disks(10, 58): faila=3D 10(D)  failb=3D 58(D=
)  OK
[    6.244684] raid6test: test_disks(10, 59): faila=3D 10(D)  failb=3D 59(D=
)  OK
[    6.245438] raid6test: test_disks(10, 60): faila=3D 10(D)  failb=3D 60(D=
)  OK
[    6.246179] raid6test: test_disks(10, 61): faila=3D 10(D)  failb=3D 61(D=
)  OK
[    6.246936] raid6test: test_disks(10, 62): faila=3D 10(D)  failb=3D 62(P=
)  OK
[    6.247685] raid6test: test_disks(10, 63): faila=3D 10(D)  failb=3D 63(Q=
)  OK
[    6.248459] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[    6.249205] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[    6.249957] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[    6.250746] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[    6.251505] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[    6.252253] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[    6.253001] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[    6.253749] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[    6.254505] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[    6.255256] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[    6.256004] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(D=
)  OK
[    6.256763] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(D=
)  OK
[    6.257518] raid6test: test_disks(11, 24): faila=3D 11(D)  failb=3D 24(D=
)  OK
[    6.258287] raid6test: test_disks(11, 25): faila=3D 11(D)  failb=3D 25(D=
)  OK
[    6.259040] raid6test: test_disks(11, 26): faila=3D 11(D)  failb=3D 26(D=
)  OK
[    6.259796] raid6test: test_disks(11, 27): faila=3D 11(D)  failb=3D 27(D=
)  OK
[    6.260577] raid6test: test_disks(11, 28): faila=3D 11(D)  failb=3D 28(D=
)  OK
[    6.261334] raid6test: test_disks(11, 29): faila=3D 11(D)  failb=3D 29(D=
)  OK
[    6.262079] raid6test: test_disks(11, 30): faila=3D 11(D)  failb=3D 30(D=
)  OK
[    6.262823] raid6test: test_disks(11, 31): faila=3D 11(D)  failb=3D 31(D=
)  OK
[    6.263576] raid6test: test_disks(11, 32): faila=3D 11(D)  failb=3D 32(D=
)  OK
[    6.264323] raid6test: test_disks(11, 33): faila=3D 11(D)  failb=3D 33(D=
)  OK
[    6.265069] raid6test: test_disks(11, 34): faila=3D 11(D)  failb=3D 34(D=
)  OK
[    6.265823] raid6test: test_disks(11, 35): faila=3D 11(D)  failb=3D 35(D=
)  OK
[    6.266575] raid6test: test_disks(11, 36): faila=3D 11(D)  failb=3D 36(D=
)  OK
[    6.267328] raid6test: test_disks(11, 37): faila=3D 11(D)  failb=3D 37(D=
)  OK
[    6.268075] raid6test: test_disks(11, 38): faila=3D 11(D)  failb=3D 38(D=
)  OK
[    6.268834] raid6test: test_disks(11, 39): faila=3D 11(D)  failb=3D 39(D=
)  OK
[    6.269581] raid6test: test_disks(11, 40): faila=3D 11(D)  failb=3D 40(D=
)  OK
[    6.270362] raid6test: test_disks(11, 41): faila=3D 11(D)  failb=3D 41(D=
)  OK
[    6.271112] raid6test: test_disks(11, 42): faila=3D 11(D)  failb=3D 42(D=
)  OK
[    6.271873] raid6test: test_disks(11, 43): faila=3D 11(D)  failb=3D 43(D=
)  OK
[    6.272633] raid6test: test_disks(11, 44): faila=3D 11(D)  failb=3D 44(D=
)  OK
[    6.273389] raid6test: test_disks(11, 45): faila=3D 11(D)  failb=3D 45(D=
)  OK
[    6.274136] raid6test: test_disks(11, 46): faila=3D 11(D)  failb=3D 46(D=
)  OK
[    6.274902] raid6test: test_disks(11, 47): faila=3D 11(D)  failb=3D 47(D=
)  OK
[    6.275662] raid6test: test_disks(11, 48): faila=3D 11(D)  failb=3D 48(D=
)  OK
[    6.276407] raid6test: test_disks(11, 49): faila=3D 11(D)  failb=3D 49(D=
)  OK
[    6.277149] raid6test: test_disks(11, 50): faila=3D 11(D)  failb=3D 50(D=
)  OK
[    6.277899] raid6test: test_disks(11, 51): faila=3D 11(D)  failb=3D 51(D=
)  OK
[    6.278662] raid6test: test_disks(11, 52): faila=3D 11(D)  failb=3D 52(D=
)  OK
[    6.279409] raid6test: test_disks(11, 53): faila=3D 11(D)  failb=3D 53(D=
)  OK
[    6.280181] raid6test: test_disks(11, 54): faila=3D 11(D)  failb=3D 54(D=
)  OK
[    6.280933] raid6test: test_disks(11, 55): faila=3D 11(D)  failb=3D 55(D=
)  OK
[    6.281684] raid6test: test_disks(11, 56): faila=3D 11(D)  failb=3D 56(D=
)  OK
[    6.282435] raid6test: test_disks(11, 57): faila=3D 11(D)  failb=3D 57(D=
)  OK
[    6.283175] raid6test: test_disks(11, 58): faila=3D 11(D)  failb=3D 58(D=
)  OK
[    6.283929] raid6test: test_disks(11, 59): faila=3D 11(D)  failb=3D 59(D=
)  OK
[    6.284679] raid6test: test_disks(11, 60): faila=3D 11(D)  failb=3D 60(D=
)  OK
[    6.285429] raid6test: test_disks(11, 61): faila=3D 11(D)  failb=3D 61(D=
)  OK
[    6.286169] raid6test: test_disks(11, 62): faila=3D 11(D)  failb=3D 62(P=
)  OK
[    6.286915] raid6test: test_disks(11, 63): faila=3D 11(D)  failb=3D 63(Q=
)  OK
[    6.287667] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[    6.288428] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[    6.289170] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[    6.289923] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[    6.290707] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[    6.291464] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[    6.292208] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[    6.292958] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[    6.293716] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[    6.294470] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(D=
)  OK
[    6.295213] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(D=
)  OK
[    6.295969] raid6test: test_disks(12, 24): faila=3D 12(D)  failb=3D 24(D=
)  OK
[    6.296718] raid6test: test_disks(12, 25): faila=3D 12(D)  failb=3D 25(D=
)  OK
[    6.297468] raid6test: test_disks(12, 26): faila=3D 12(D)  failb=3D 26(D=
)  OK
[    6.298211] raid6test: test_disks(12, 27): faila=3D 12(D)  failb=3D 27(D=
)  OK
[    6.298968] raid6test: test_disks(12, 28): faila=3D 12(D)  failb=3D 28(D=
)  OK
[    6.299721] raid6test: test_disks(12, 29): faila=3D 12(D)  failb=3D 29(D=
)  OK
[    6.300497] raid6test: test_disks(12, 30): faila=3D 12(D)  failb=3D 30(D=
)  OK
[    6.301238] raid6test: test_disks(12, 31): faila=3D 12(D)  failb=3D 31(D=
)  OK
[    6.301993] raid6test: test_disks(12, 32): faila=3D 12(D)  failb=3D 32(D=
)  OK
[    6.302744] raid6test: test_disks(12, 33): faila=3D 12(D)  failb=3D 33(D=
)  OK
[    6.303498] raid6test: test_disks(12, 34): faila=3D 12(D)  failb=3D 34(D=
)  OK
[    6.304242] raid6test: test_disks(12, 35): faila=3D 12(D)  failb=3D 35(D=
)  OK
[    6.304992] raid6test: test_disks(12, 36): faila=3D 12(D)  failb=3D 36(D=
)  OK
[    6.305742] raid6test: test_disks(12, 37): faila=3D 12(D)  failb=3D 37(D=
)  OK
[    6.306494] raid6test: test_disks(12, 38): faila=3D 12(D)  failb=3D 38(D=
)  OK
[    6.307239] raid6test: test_disks(12, 39): faila=3D 12(D)  failb=3D 39(D=
)  OK
[    6.307993] raid6test: test_disks(12, 40): faila=3D 12(D)  failb=3D 40(D=
)  OK
[    6.308759] raid6test: test_disks(12, 41): faila=3D 12(D)  failb=3D 41(D=
)  OK
[    6.309514] raid6test: test_disks(12, 42): faila=3D 12(D)  failb=3D 42(D=
)  OK
[    6.310292] raid6test: test_disks(12, 43): faila=3D 12(D)  failb=3D 43(D=
)  OK
[    6.311039] raid6test: test_disks(12, 44): faila=3D 12(D)  failb=3D 44(D=
)  OK
[    6.311789] raid6test: test_disks(12, 45): faila=3D 12(D)  failb=3D 45(D=
)  OK
[    6.312539] raid6test: test_disks(12, 46): faila=3D 12(D)  failb=3D 46(D=
)  OK
[    6.313293] raid6test: test_disks(12, 47): faila=3D 12(D)  failb=3D 47(D=
)  OK
[    6.314039] raid6test: test_disks(12, 48): faila=3D 12(D)  failb=3D 48(D=
)  OK
[    6.314791] raid6test: test_disks(12, 49): faila=3D 12(D)  failb=3D 49(D=
)  OK
[    6.315546] raid6test: test_disks(12, 50): faila=3D 12(D)  failb=3D 50(D=
)  OK
[    6.316295] raid6test: test_disks(12, 51): faila=3D 12(D)  failb=3D 51(D=
)  OK
[    6.317039] raid6test: test_disks(12, 52): faila=3D 12(D)  failb=3D 52(D=
)  OK
[    6.317789] raid6test: test_disks(12, 53): faila=3D 12(D)  failb=3D 53(D=
)  OK
[    6.318738] raid6test: test_disks(12, 54): faila=3D 12(D)  failb=3D 54(D=
)  OK
[    6.320009] raid6test: test_disks(12, 55): faila=3D 12(D)  failb=3D 55(D=
)  OK
[    6.321324] raid6test: test_disks(12, 56): faila=3D 12(D)  failb=3D 56(D=
)  OK
[    6.322597] raid6test: test_disks(12, 57): faila=3D 12(D)  failb=3D 57(D=
)  OK
[    6.323860] raid6test: test_disks(12, 58): faila=3D 12(D)  failb=3D 58(D=
)  OK
[    6.325119] raid6test: test_disks(12, 59): faila=3D 12(D)  failb=3D 59(D=
)  OK
[    6.326386] raid6test: test_disks(12, 60): faila=3D 12(D)  failb=3D 60(D=
)  OK
[    6.327648] raid6test: test_disks(12, 61): faila=3D 12(D)  failb=3D 61(D=
)  OK
[    6.328916] raid6test: test_disks(12, 62): faila=3D 12(D)  failb=3D 62(P=
)  OK
[    6.330215] raid6test: test_disks(12, 63): faila=3D 12(D)  failb=3D 63(Q=
)  OK
[    6.331487] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[    6.332752] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[    6.334013] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[    6.335305] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[    6.336572] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[    6.337839] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[    6.339121] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[    6.340442] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[    6.341716] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(D=
)  OK
[    6.342990] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(D=
)  OK
[    6.344268] raid6test: test_disks(13, 24): faila=3D 13(D)  failb=3D 24(D=
)  OK
[    6.345534] raid6test: test_disks(13, 25): faila=3D 13(D)  failb=3D 25(D=
)  OK
[    6.346804] raid6test: test_disks(13, 26): faila=3D 13(D)  failb=3D 26(D=
)  OK
[    6.348068] raid6test: test_disks(13, 27): faila=3D 13(D)  failb=3D 27(D=
)  OK
[    6.349362] raid6test: test_disks(13, 28): faila=3D 13(D)  failb=3D 28(D=
)  OK
[    6.350678] raid6test: test_disks(13, 29): faila=3D 13(D)  failb=3D 29(D=
)  OK
[    6.351944] raid6test: test_disks(13, 30): faila=3D 13(D)  failb=3D 30(D=
)  OK
[    6.353203] raid6test: test_disks(13, 31): faila=3D 13(D)  failb=3D 31(D=
)  OK
[    6.354478] raid6test: test_disks(13, 32): faila=3D 13(D)  failb=3D 32(D=
)  OK
[    6.355740] raid6test: test_disks(13, 33): faila=3D 13(D)  failb=3D 33(D=
)  OK
[    6.357014] raid6test: test_disks(13, 34): faila=3D 13(D)  failb=3D 34(D=
)  OK
[    6.358300] raid6test: test_disks(13, 35): faila=3D 13(D)  failb=3D 35(D=
)  OK
[    6.359569] raid6test: test_disks(13, 36): faila=3D 13(D)  failb=3D 36(D=
)  OK
[    6.360896] raid6test: test_disks(13, 37): faila=3D 13(D)  failb=3D 37(D=
)  OK
[    6.362161] raid6test: test_disks(13, 38): faila=3D 13(D)  failb=3D 38(D=
)  OK
[    6.363436] raid6test: test_disks(13, 39): faila=3D 13(D)  failb=3D 39(D=
)  OK
[    6.364698] raid6test: test_disks(13, 40): faila=3D 13(D)  failb=3D 40(D=
)  OK
[    6.365955] raid6test: test_disks(13, 41): faila=3D 13(D)  failb=3D 41(D=
)  OK
[    6.367224] raid6test: test_disks(13, 42): faila=3D 13(D)  failb=3D 42(D=
)  OK
[    6.368513] raid6test: test_disks(13, 43): faila=3D 13(D)  failb=3D 43(D=
)  OK
[    6.369774] raid6test: test_disks(13, 44): faila=3D 13(D)  failb=3D 44(D=
)  OK
[    6.371103] raid6test: test_disks(13, 45): faila=3D 13(D)  failb=3D 45(D=
)  OK
[    6.372367] raid6test: test_disks(13, 46): faila=3D 13(D)  failb=3D 46(D=
)  OK
[    6.373633] raid6test: test_disks(13, 47): faila=3D 13(D)  failb=3D 47(D=
)  OK
[    6.374896] raid6test: test_disks(13, 48): faila=3D 13(D)  failb=3D 48(D=
)  OK
[    6.376153] raid6test: test_disks(13, 49): faila=3D 13(D)  failb=3D 49(D=
)  OK
[    6.377437] raid6test: test_disks(13, 50): faila=3D 13(D)  failb=3D 50(D=
)  OK
[    6.378716] raid6test: test_disks(13, 51): faila=3D 13(D)  failb=3D 51(D=
)  OK
[    6.379975] raid6test: test_disks(13, 52): faila=3D 13(D)  failb=3D 52(D=
)  OK
[    6.381306] raid6test: test_disks(13, 53): faila=3D 13(D)  failb=3D 53(D=
)  OK
[    6.382605] raid6test: test_disks(13, 54): faila=3D 13(D)  failb=3D 54(D=
)  OK
[    6.383865] raid6test: test_disks(13, 55): faila=3D 13(D)  failb=3D 55(D=
)  OK
[    6.385127] raid6test: test_disks(13, 56): faila=3D 13(D)  failb=3D 56(D=
)  OK
[    6.386394] raid6test: test_disks(13, 57): faila=3D 13(D)  failb=3D 57(D=
)  OK
[    6.387667] raid6test: test_disks(13, 58): faila=3D 13(D)  failb=3D 58(D=
)  OK
[    6.388946] raid6test: test_disks(13, 59): faila=3D 13(D)  failb=3D 59(D=
)  OK
[    6.390269] raid6test: test_disks(13, 60): faila=3D 13(D)  failb=3D 60(D=
)  OK
[    6.391547] raid6test: test_disks(13, 61): faila=3D 13(D)  failb=3D 61(D=
)  OK
[    6.392799] raid6test: test_disks(13, 62): faila=3D 13(D)  failb=3D 62(P=
)  OK
[    6.394039] raid6test: test_disks(13, 63): faila=3D 13(D)  failb=3D 63(Q=
)  OK
[    6.395307] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[    6.396570] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[    6.397833] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[    6.399088] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[    6.400399] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[    6.401662] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[    6.402935] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[    6.404192] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(D=
)  OK
[    6.405467] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(D=
)  OK
[    6.406735] raid6test: test_disks(14, 24): faila=3D 14(D)  failb=3D 24(D=
)  OK
[    6.408014] raid6test: test_disks(14, 25): faila=3D 14(D)  failb=3D 25(D=
)  OK
[    6.409294] raid6test: test_disks(14, 26): faila=3D 14(D)  failb=3D 26(D=
)  OK
[    6.410599] raid6test: test_disks(14, 27): faila=3D 14(D)  failb=3D 27(D=
)  OK
[    6.411863] raid6test: test_disks(14, 28): faila=3D 14(D)  failb=3D 28(D=
)  OK
[    6.413128] raid6test: test_disks(14, 29): faila=3D 14(D)  failb=3D 29(D=
)  OK
[    6.414401] raid6test: test_disks(14, 30): faila=3D 14(D)  failb=3D 30(D=
)  OK
[    6.415655] raid6test: test_disks(14, 31): faila=3D 14(D)  failb=3D 31(D=
)  OK
[    6.416918] raid6test: test_disks(14, 32): faila=3D 14(D)  failb=3D 32(D=
)  OK
[    6.418182] raid6test: test_disks(14, 33): faila=3D 14(D)  failb=3D 33(D=
)  OK
[    6.419472] raid6test: test_disks(14, 34): faila=3D 14(D)  failb=3D 34(D=
)  OK
[    6.420786] raid6test: test_disks(14, 35): faila=3D 14(D)  failb=3D 35(D=
)  OK
[    6.422130] raid6test: test_disks(14, 36): faila=3D 14(D)  failb=3D 36(D=
)  OK
[    6.423400] raid6test: test_disks(14, 37): faila=3D 14(D)  failb=3D 37(D=
)  OK
[    6.424660] raid6test: test_disks(14, 38): faila=3D 14(D)  failb=3D 38(D=
)  OK
[    6.425930] raid6test: test_disks(14, 39): faila=3D 14(D)  failb=3D 39(D=
)  OK
[    6.427188] raid6test: test_disks(14, 40): faila=3D 14(D)  failb=3D 40(D=
)  OK
[    6.428466] raid6test: test_disks(14, 41): faila=3D 14(D)  failb=3D 41(D=
)  OK
[    6.429723] raid6test: test_disks(14, 42): faila=3D 14(D)  failb=3D 42(D=
)  OK
[    6.431040] raid6test: test_disks(14, 43): faila=3D 14(D)  failb=3D 43(D=
)  OK
[    6.432313] raid6test: test_disks(14, 44): faila=3D 14(D)  failb=3D 44(D=
)  OK
[    6.433561] raid6test: test_disks(14, 45): faila=3D 14(D)  failb=3D 45(D=
)  OK
[    6.434821] raid6test: test_disks(14, 46): faila=3D 14(D)  failb=3D 46(D=
)  OK
[    6.436088] raid6test: test_disks(14, 47): faila=3D 14(D)  failb=3D 47(D=
)  OK
[    6.437359] raid6test: test_disks(14, 48): faila=3D 14(D)  failb=3D 48(D=
)  OK
[    6.438633] raid6test: test_disks(14, 49): faila=3D 14(D)  failb=3D 49(D=
)  OK
[    6.439937] raid6test: test_disks(14, 50): faila=3D 14(D)  failb=3D 50(D=
)  OK
[    6.441250] raid6test: test_disks(14, 51): faila=3D 14(D)  failb=3D 51(D=
)  OK
[    6.442526] raid6test: test_disks(14, 52): faila=3D 14(D)  failb=3D 52(D=
)  OK
[    6.443819] raid6test: test_disks(14, 53): faila=3D 14(D)  failb=3D 53(D=
)  OK
[    6.444993] raid6test: test_disks(14, 54): faila=3D 14(D)  failb=3D 54(D=
)  OK
[    6.446279] raid6test: test_disks(14, 55): faila=3D 14(D)  failb=3D 55(D=
)  OK
[    6.447563] raid6test: test_disks(14, 56): faila=3D 14(D)  failb=3D 56(D=
)  OK
[    6.448860] raid6test: test_disks(14, 57): faila=3D 14(D)  failb=3D 57(D=
)  OK
[    6.450181] raid6test: test_disks(14, 58): faila=3D 14(D)  failb=3D 58(D=
)  OK
[    6.451464] raid6test: test_disks(14, 59): faila=3D 14(D)  failb=3D 59(D=
)  OK
[    6.452708] raid6test: test_disks(14, 60): faila=3D 14(D)  failb=3D 60(D=
)  OK
[    6.453967] raid6test: test_disks(14, 61): faila=3D 14(D)  failb=3D 61(D=
)  OK
[    6.455200] raid6test: test_disks(14, 62): faila=3D 14(D)  failb=3D 62(P=
)  OK
[    6.456471] raid6test: test_disks(14, 63): faila=3D 14(D)  failb=3D 63(Q=
)  OK
[    6.457738] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[    6.459027] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[    6.460365] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[    6.461648] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[    6.462916] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[    6.464177] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[    6.465445] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(D=
)  OK
[    6.466697] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(D=
)  OK
[    6.467959] raid6test: test_disks(15, 24): faila=3D 15(D)  failb=3D 24(D=
)  OK
[    6.469252] raid6test: test_disks(15, 25): faila=3D 15(D)  failb=3D 25(D=
)  OK
[    6.470572] raid6test: test_disks(15, 26): faila=3D 15(D)  failb=3D 26(D=
)  OK
[    6.471826] raid6test: test_disks(15, 27): faila=3D 15(D)  failb=3D 27(D=
)  OK
[    6.473066] raid6test: test_disks(15, 28): faila=3D 15(D)  failb=3D 28(D=
)  OK
[    6.474338] raid6test: test_disks(15, 29): faila=3D 15(D)  failb=3D 29(D=
)  OK
[    6.475609] raid6test: test_disks(15, 30): faila=3D 15(D)  failb=3D 30(D=
)  OK
[    6.476871] raid6test: test_disks(15, 31): faila=3D 15(D)  failb=3D 31(D=
)  OK
[    6.478149] raid6test: test_disks(15, 32): faila=3D 15(D)  failb=3D 32(D=
)  OK
[    6.479373] raid6test: test_disks(15, 33): faila=3D 15(D)  failb=3D 33(D=
)  OK
[    6.480687] raid6test: test_disks(15, 34): faila=3D 15(D)  failb=3D 34(D=
)  OK
[    6.481960] raid6test: test_disks(15, 35): faila=3D 15(D)  failb=3D 35(D=
)  OK
[    6.483216] raid6test: test_disks(15, 36): faila=3D 15(D)  failb=3D 36(D=
)  OK
[    6.484466] raid6test: test_disks(15, 37): faila=3D 15(D)  failb=3D 37(D=
)  OK
[    6.485730] raid6test: test_disks(15, 38): faila=3D 15(D)  failb=3D 38(D=
)  OK
[    6.486878] raid6test: test_disks(15, 39): faila=3D 15(D)  failb=3D 39(D=
)  OK
[    6.487922] raid6test: test_disks(15, 40): faila=3D 15(D)  failb=3D 40(D=
)  OK
[    6.489064] raid6test: test_disks(15, 41): faila=3D 15(D)  failb=3D 41(D=
)  OK
[    6.490204] raid6test: test_disks(15, 42): faila=3D 15(D)  failb=3D 42(D=
)  OK
[    6.491282] raid6test: test_disks(15, 43): faila=3D 15(D)  failb=3D 43(D=
)  OK
[    6.492339] raid6test: test_disks(15, 44): faila=3D 15(D)  failb=3D 44(D=
)  OK
[    6.493558] raid6test: test_disks(15, 45): faila=3D 15(D)  failb=3D 45(D=
)  OK
[    6.494787] raid6test: test_disks(15, 46): faila=3D 15(D)  failb=3D 46(D=
)  OK
[    6.496017] raid6test: test_disks(15, 47): faila=3D 15(D)  failb=3D 47(D=
)  OK
[    6.497250] raid6test: test_disks(15, 48): faila=3D 15(D)  failb=3D 48(D=
)  OK
[    6.498507] raid6test: test_disks(15, 49): faila=3D 15(D)  failb=3D 49(D=
)  OK
[    6.499770] raid6test: test_disks(15, 50): faila=3D 15(D)  failb=3D 50(D=
)  OK
[    6.500992] raid6test: test_disks(15, 51): faila=3D 15(D)  failb=3D 51(D=
)  OK
[    6.502290] raid6test: test_disks(15, 52): faila=3D 15(D)  failb=3D 52(D=
)  OK
[    6.503501] raid6test: test_disks(15, 53): faila=3D 15(D)  failb=3D 53(D=
)  OK
[    6.504727] raid6test: test_disks(15, 54): faila=3D 15(D)  failb=3D 54(D=
)  OK
[    6.505957] raid6test: test_disks(15, 55): faila=3D 15(D)  failb=3D 55(D=
)  OK
[    6.507191] raid6test: test_disks(15, 56): faila=3D 15(D)  failb=3D 56(D=
)  OK
[    6.508414] raid6test: test_disks(15, 57): faila=3D 15(D)  failb=3D 57(D=
)  OK
[    6.509696] raid6test: test_disks(15, 58): faila=3D 15(D)  failb=3D 58(D=
)  OK
[    6.510998] raid6test: test_disks(15, 59): faila=3D 15(D)  failb=3D 59(D=
)  OK
[    6.512184] raid6test: test_disks(15, 60): faila=3D 15(D)  failb=3D 60(D=
)  OK
[    6.513424] raid6test: test_disks(15, 61): faila=3D 15(D)  failb=3D 61(D=
)  OK
[    6.514626] raid6test: test_disks(15, 62): faila=3D 15(D)  failb=3D 62(P=
)  OK
[    6.515877] raid6test: test_disks(15, 63): faila=3D 15(D)  failb=3D 63(Q=
)  OK
[    6.517053] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[    6.518309] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[    6.519565] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[    6.520862] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[    6.522090] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[    6.523150] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(D=
)  OK
[    6.524201] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(D=
)  OK
[    6.525268] raid6test: test_disks(16, 24): faila=3D 16(D)  failb=3D 24(D=
)  OK
[    6.526423] raid6test: test_disks(16, 25): faila=3D 16(D)  failb=3D 25(D=
)  OK
[    6.527641] raid6test: test_disks(16, 26): faila=3D 16(D)  failb=3D 26(D=
)  OK
[    6.528872] raid6test: test_disks(16, 27): faila=3D 16(D)  failb=3D 27(D=
)  OK
[    6.530141] raid6test: test_disks(16, 28): faila=3D 16(D)  failb=3D 28(D=
)  OK
[    6.531361] raid6test: test_disks(16, 29): faila=3D 16(D)  failb=3D 29(D=
)  OK
[    6.532568] raid6test: test_disks(16, 30): faila=3D 16(D)  failb=3D 30(D=
)  OK
[    6.533778] raid6test: test_disks(16, 31): faila=3D 16(D)  failb=3D 31(D=
)  OK
[    6.534995] raid6test: test_disks(16, 32): faila=3D 16(D)  failb=3D 32(D=
)  OK
[    6.536215] raid6test: test_disks(16, 33): faila=3D 16(D)  failb=3D 33(D=
)  OK
[    6.537481] raid6test: test_disks(16, 34): faila=3D 16(D)  failb=3D 34(D=
)  OK
[    6.538664] raid6test: test_disks(16, 35): faila=3D 16(D)  failb=3D 35(D=
)  OK
[    6.539838] raid6test: test_disks(16, 36): faila=3D 16(D)  failb=3D 36(D=
)  OK
[    6.541112] raid6test: test_disks(16, 37): faila=3D 16(D)  failb=3D 37(D=
)  OK
[    6.542310] raid6test: test_disks(16, 38): faila=3D 16(D)  failb=3D 38(D=
)  OK
[    6.543566] raid6test: test_disks(16, 39): faila=3D 16(D)  failb=3D 39(D=
)  OK
[    6.544816] raid6test: test_disks(16, 40): faila=3D 16(D)  failb=3D 40(D=
)  OK
[    6.546007] raid6test: test_disks(16, 41): faila=3D 16(D)  failb=3D 41(D=
)  OK
[    6.547228] raid6test: test_disks(16, 42): faila=3D 16(D)  failb=3D 42(D=
)  OK
[    6.548450] raid6test: test_disks(16, 43): faila=3D 16(D)  failb=3D 43(D=
)  OK
[    6.549698] raid6test: test_disks(16, 44): faila=3D 16(D)  failb=3D 44(D=
)  OK
[    6.550932] raid6test: test_disks(16, 45): faila=3D 16(D)  failb=3D 45(D=
)  OK
[    6.552101] raid6test: test_disks(16, 46): faila=3D 16(D)  failb=3D 46(D=
)  OK
[    6.553338] raid6test: test_disks(16, 47): faila=3D 16(D)  failb=3D 47(D=
)  OK
[    6.554561] raid6test: test_disks(16, 48): faila=3D 16(D)  failb=3D 48(D=
)  OK
[    6.555768] raid6test: test_disks(16, 49): faila=3D 16(D)  failb=3D 49(D=
)  OK
[    6.556972] raid6test: test_disks(16, 50): faila=3D 16(D)  failb=3D 50(D=
)  OK
[    6.558168] raid6test: test_disks(16, 51): faila=3D 16(D)  failb=3D 51(D=
)  OK
[    6.559407] raid6test: test_disks(16, 52): faila=3D 16(D)  failb=3D 52(D=
)  OK
[    6.560672] raid6test: test_disks(16, 53): faila=3D 16(D)  failb=3D 53(D=
)  OK
[    6.561854] raid6test: test_disks(16, 54): faila=3D 16(D)  failb=3D 54(D=
)  OK
[    6.563069] raid6test: test_disks(16, 55): faila=3D 16(D)  failb=3D 55(D=
)  OK
[    6.564283] raid6test: test_disks(16, 56): faila=3D 16(D)  failb=3D 56(D=
)  OK
[    6.565484] raid6test: test_disks(16, 57): faila=3D 16(D)  failb=3D 57(D=
)  OK
[    6.566701] raid6test: test_disks(16, 58): faila=3D 16(D)  failb=3D 58(D=
)  OK
[    6.567920] raid6test: test_disks(16, 59): faila=3D 16(D)  failb=3D 59(D=
)  OK
[    6.569152] raid6test: test_disks(16, 60): faila=3D 16(D)  failb=3D 60(D=
)  OK
[    6.570420] raid6test: test_disks(16, 61): faila=3D 16(D)  failb=3D 61(D=
)  OK
[    6.571608] raid6test: test_disks(16, 62): faila=3D 16(D)  failb=3D 62(P=
)  OK
[    6.572797] raid6test: test_disks(16, 63): faila=3D 16(D)  failb=3D 63(Q=
)  OK
[    6.574017] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[    6.575232] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[    6.576459] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[    6.577672] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[    6.578914] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(D=
)  OK
[    6.580191] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(D=
)  OK
[    6.581425] raid6test: test_disks(17, 24): faila=3D 17(D)  failb=3D 24(D=
)  OK
[    6.582664] raid6test: test_disks(17, 25): faila=3D 17(D)  failb=3D 25(D=
)  OK
[    6.583868] raid6test: test_disks(17, 26): faila=3D 17(D)  failb=3D 26(D=
)  OK
[    6.585076] raid6test: test_disks(17, 27): faila=3D 17(D)  failb=3D 27(D=
)  OK
[    6.586223] raid6test: test_disks(17, 28): faila=3D 17(D)  failb=3D 28(D=
)  OK
[    6.587427] raid6test: test_disks(17, 29): faila=3D 17(D)  failb=3D 29(D=
)  OK
[    6.588646] raid6test: test_disks(17, 30): faila=3D 17(D)  failb=3D 30(D=
)  OK
[    6.589850] raid6test: test_disks(17, 31): faila=3D 17(D)  failb=3D 31(D=
)  OK
[    6.591117] raid6test: test_disks(17, 32): faila=3D 17(D)  failb=3D 32(D=
)  OK
[    6.592331] raid6test: test_disks(17, 33): faila=3D 17(D)  failb=3D 33(D=
)  OK
[    6.593535] raid6test: test_disks(17, 34): faila=3D 17(D)  failb=3D 34(D=
)  OK
[    6.594738] raid6test: test_disks(17, 35): faila=3D 17(D)  failb=3D 35(D=
)  OK
[    6.595950] raid6test: test_disks(17, 36): faila=3D 17(D)  failb=3D 36(D=
)  OK
[    6.597150] raid6test: test_disks(17, 37): faila=3D 17(D)  failb=3D 37(D=
)  OK
[    6.598383] raid6test: test_disks(17, 38): faila=3D 17(D)  failb=3D 38(D=
)  OK
[    6.599584] raid6test: test_disks(17, 39): faila=3D 17(D)  failb=3D 39(D=
)  OK
[    6.600853] raid6test: test_disks(17, 40): faila=3D 17(D)  failb=3D 40(D=
)  OK
[    6.602086] raid6test: test_disks(17, 41): faila=3D 17(D)  failb=3D 41(D=
)  OK
[    6.603275] raid6test: test_disks(17, 42): faila=3D 17(D)  failb=3D 42(D=
)  OK
[    6.604482] raid6test: test_disks(17, 43): faila=3D 17(D)  failb=3D 43(D=
)  OK
[    6.605688] raid6test: test_disks(17, 44): faila=3D 17(D)  failb=3D 44(D=
)  OK
[    6.606848] raid6test: test_disks(17, 45): faila=3D 17(D)  failb=3D 45(D=
)  OK
[    6.608063] raid6test: test_disks(17, 46): faila=3D 17(D)  failb=3D 46(D=
)  OK
[    6.609284] raid6test: test_disks(17, 47): faila=3D 17(D)  failb=3D 47(D=
)  OK
[    6.610570] raid6test: test_disks(17, 48): faila=3D 17(D)  failb=3D 48(D=
)  OK
[    6.611749] raid6test: test_disks(17, 49): faila=3D 17(D)  failb=3D 49(D=
)  OK
[    6.612977] raid6test: test_disks(17, 50): faila=3D 17(D)  failb=3D 50(D=
)  OK
[    6.614255] raid6test: test_disks(17, 51): faila=3D 17(D)  failb=3D 51(D=
)  OK
[    6.615437] raid6test: test_disks(17, 52): faila=3D 17(D)  failb=3D 52(D=
)  OK
[    6.616595] raid6test: test_disks(17, 53): faila=3D 17(D)  failb=3D 53(D=
)  OK
[    6.617756] raid6test: test_disks(17, 54): faila=3D 17(D)  failb=3D 54(D=
)  OK
[    6.618946] raid6test: test_disks(17, 55): faila=3D 17(D)  failb=3D 55(D=
)  OK
[    6.620199] raid6test: test_disks(17, 56): faila=3D 17(D)  failb=3D 56(D=
)  OK
[    6.621424] raid6test: test_disks(17, 57): faila=3D 17(D)  failb=3D 57(D=
)  OK
[    6.622650] raid6test: test_disks(17, 58): faila=3D 17(D)  failb=3D 58(D=
)  OK
[    6.623890] raid6test: test_disks(17, 59): faila=3D 17(D)  failb=3D 59(D=
)  OK
[    6.625043] raid6test: test_disks(17, 60): faila=3D 17(D)  failb=3D 60(D=
)  OK
[    6.626251] raid6test: test_disks(17, 61): faila=3D 17(D)  failb=3D 61(D=
)  OK
[    6.627473] raid6test: test_disks(17, 62): faila=3D 17(D)  failb=3D 62(P=
)  OK
[    6.628670] raid6test: test_disks(17, 63): faila=3D 17(D)  failb=3D 63(Q=
)  OK
[    6.629873] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[    6.631134] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[    6.632293] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[    6.633470] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(D=
)  OK
[    6.634639] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(D=
)  OK
[    6.635824] raid6test: test_disks(18, 24): faila=3D 18(D)  failb=3D 24(D=
)  OK
[    6.636995] raid6test: test_disks(18, 25): faila=3D 18(D)  failb=3D 25(D=
)  OK
[    6.638162] raid6test: test_disks(18, 26): faila=3D 18(D)  failb=3D 26(D=
)  OK
[    6.639415] raid6test: test_disks(18, 27): faila=3D 18(D)  failb=3D 27(D=
)  OK
[    6.640705] raid6test: test_disks(18, 28): faila=3D 18(D)  failb=3D 28(D=
)  OK
[    6.641923] raid6test: test_disks(18, 29): faila=3D 18(D)  failb=3D 29(D=
)  OK
[    6.643178] raid6test: test_disks(18, 30): faila=3D 18(D)  failb=3D 30(D=
)  OK
[    6.644342] raid6test: test_disks(18, 31): faila=3D 18(D)  failb=3D 31(D=
)  OK
[    6.645575] raid6test: test_disks(18, 32): faila=3D 18(D)  failb=3D 32(D=
)  OK
[    6.646797] raid6test: test_disks(18, 33): faila=3D 18(D)  failb=3D 33(D=
)  OK
[    6.648013] raid6test: test_disks(18, 34): faila=3D 18(D)  failb=3D 34(D=
)  OK
[    6.649253] raid6test: test_disks(18, 35): faila=3D 18(D)  failb=3D 35(D=
)  OK
[    6.650526] raid6test: test_disks(18, 36): faila=3D 18(D)  failb=3D 36(D=
)  OK
[    6.651714] raid6test: test_disks(18, 37): faila=3D 18(D)  failb=3D 37(D=
)  OK
[    6.652931] raid6test: test_disks(18, 38): faila=3D 18(D)  failb=3D 38(D=
)  OK
[    6.654177] raid6test: test_disks(18, 39): faila=3D 18(D)  failb=3D 39(D=
)  OK
[    6.655356] raid6test: test_disks(18, 40): faila=3D 18(D)  failb=3D 40(D=
)  OK
[    6.656588] raid6test: test_disks(18, 41): faila=3D 18(D)  failb=3D 41(D=
)  OK
[    6.657805] raid6test: test_disks(18, 42): faila=3D 18(D)  failb=3D 42(D=
)  OK
[    6.659045] raid6test: test_disks(18, 43): faila=3D 18(D)  failb=3D 43(D=
)  OK
[    6.660293] raid6test: test_disks(18, 44): faila=3D 18(D)  failb=3D 44(D=
)  OK
[    6.661538] raid6test: test_disks(18, 45): faila=3D 18(D)  failb=3D 45(D=
)  OK
[    6.662766] raid6test: test_disks(18, 46): faila=3D 18(D)  failb=3D 46(D=
)  OK
[    6.663997] raid6test: test_disks(18, 47): faila=3D 18(D)  failb=3D 47(D=
)  OK
[    6.665188] raid6test: test_disks(18, 48): faila=3D 18(D)  failb=3D 48(D=
)  OK
[    6.666412] raid6test: test_disks(18, 49): faila=3D 18(D)  failb=3D 49(D=
)  OK
[    6.667634] raid6test: test_disks(18, 50): faila=3D 18(D)  failb=3D 50(D=
)  OK
[    6.668896] raid6test: test_disks(18, 51): faila=3D 18(D)  failb=3D 51(D=
)  OK
[    6.670122] raid6test: test_disks(18, 52): faila=3D 18(D)  failb=3D 52(D=
)  OK
[    6.671428] raid6test: test_disks(18, 53): faila=3D 18(D)  failb=3D 53(D=
)  OK
[    6.672702] raid6test: test_disks(18, 54): faila=3D 18(D)  failb=3D 54(D=
)  OK
[    6.673918] raid6test: test_disks(18, 55): faila=3D 18(D)  failb=3D 55(D=
)  OK
[    6.675076] raid6test: test_disks(18, 56): faila=3D 18(D)  failb=3D 56(D=
)  OK
[    6.676285] raid6test: test_disks(18, 57): faila=3D 18(D)  failb=3D 57(D=
)  OK
[    6.677502] raid6test: test_disks(18, 58): faila=3D 18(D)  failb=3D 58(D=
)  OK
[    6.678712] raid6test: test_disks(18, 59): faila=3D 18(D)  failb=3D 59(D=
)  OK
[    6.679996] raid6test: test_disks(18, 60): faila=3D 18(D)  failb=3D 60(D=
)  OK
[    6.681303] raid6test: test_disks(18, 61): faila=3D 18(D)  failb=3D 61(D=
)  OK
[    6.682491] raid6test: test_disks(18, 62): faila=3D 18(D)  failb=3D 62(P=
)  OK
[    6.683736] raid6test: test_disks(18, 63): faila=3D 18(D)  failb=3D 63(Q=
)  OK
[    6.684997] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[    6.686266] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[    6.687494] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(D=
)  OK
[    6.688703] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(D=
)  OK
[    6.689871] raid6test: test_disks(19, 24): faila=3D 19(D)  failb=3D 24(D=
)  OK
[    6.691160] raid6test: test_disks(19, 25): faila=3D 19(D)  failb=3D 25(D=
)  OK
[    6.692394] raid6test: test_disks(19, 26): faila=3D 19(D)  failb=3D 26(D=
)  OK
[    6.693639] raid6test: test_disks(19, 27): faila=3D 19(D)  failb=3D 27(D=
)  OK
[    6.694878] raid6test: test_disks(19, 28): faila=3D 19(D)  failb=3D 28(D=
)  OK
[    6.696081] raid6test: test_disks(19, 29): faila=3D 19(D)  failb=3D 29(D=
)  OK
[    6.697307] raid6test: test_disks(19, 30): faila=3D 19(D)  failb=3D 30(D=
)  OK
[    6.698556] raid6test: test_disks(19, 31): faila=3D 19(D)  failb=3D 31(D=
)  OK
[    6.699797] raid6test: test_disks(19, 32): faila=3D 19(D)  failb=3D 32(D=
)  OK
[    6.701079] raid6test: test_disks(19, 33): faila=3D 19(D)  failb=3D 33(D=
)  OK
[    6.702295] raid6test: test_disks(19, 34): faila=3D 19(D)  failb=3D 34(D=
)  OK
[    6.703518] raid6test: test_disks(19, 35): faila=3D 19(D)  failb=3D 35(D=
)  OK
[    6.704731] raid6test: test_disks(19, 36): faila=3D 19(D)  failb=3D 36(D=
)  OK
[    6.705936] raid6test: test_disks(19, 37): faila=3D 19(D)  failb=3D 37(D=
)  OK
[    6.707163] raid6test: test_disks(19, 38): faila=3D 19(D)  failb=3D 38(D=
)  OK
[    6.708428] raid6test: test_disks(19, 39): faila=3D 19(D)  failb=3D 39(D=
)  OK
[    6.709668] raid6test: test_disks(19, 40): faila=3D 19(D)  failb=3D 40(D=
)  OK
[    6.710942] raid6test: test_disks(19, 41): faila=3D 19(D)  failb=3D 41(D=
)  OK
[    6.712164] raid6test: test_disks(19, 42): faila=3D 19(D)  failb=3D 42(D=
)  OK
[    6.713382] raid6test: test_disks(19, 43): faila=3D 19(D)  failb=3D 43(D=
)  OK
[    6.714635] raid6test: test_disks(19, 44): faila=3D 19(D)  failb=3D 44(D=
)  OK
[    6.715849] raid6test: test_disks(19, 45): faila=3D 19(D)  failb=3D 45(D=
)  OK
[    6.717015] raid6test: test_disks(19, 46): faila=3D 19(D)  failb=3D 46(D=
)  OK
[    6.718231] raid6test: test_disks(19, 47): faila=3D 19(D)  failb=3D 47(D=
)  OK
[    6.719459] raid6test: test_disks(19, 48): faila=3D 19(D)  failb=3D 48(D=
)  OK
[    6.720741] raid6test: test_disks(19, 49): faila=3D 19(D)  failb=3D 49(D=
)  OK
[    6.721990] raid6test: test_disks(19, 50): faila=3D 19(D)  failb=3D 50(D=
)  OK
[    6.723262] raid6test: test_disks(19, 51): faila=3D 19(D)  failb=3D 51(D=
)  OK
[    6.724512] raid6test: test_disks(19, 52): faila=3D 19(D)  failb=3D 52(D=
)  OK
[    6.725673] raid6test: test_disks(19, 53): faila=3D 19(D)  failb=3D 53(D=
)  OK
[    6.726824] raid6test: test_disks(19, 54): faila=3D 19(D)  failb=3D 54(D=
)  OK
[    6.728008] raid6test: test_disks(19, 55): faila=3D 19(D)  failb=3D 55(D=
)  OK
[    6.729299] raid6test: test_disks(19, 56): faila=3D 19(D)  failb=3D 56(D=
)  OK
[    6.730580] raid6test: test_disks(19, 57): faila=3D 19(D)  failb=3D 57(D=
)  OK
[    6.731796] raid6test: test_disks(19, 58): faila=3D 19(D)  failb=3D 58(D=
)  OK
[    6.733019] raid6test: test_disks(19, 59): faila=3D 19(D)  failb=3D 59(D=
)  OK
[    6.734268] raid6test: test_disks(19, 60): faila=3D 19(D)  failb=3D 60(D=
)  OK
[    6.735511] raid6test: test_disks(19, 61): faila=3D 19(D)  failb=3D 61(D=
)  OK
[    6.736709] raid6test: test_disks(19, 62): faila=3D 19(D)  failb=3D 62(P=
)  OK
[    6.737907] raid6test: test_disks(19, 63): faila=3D 19(D)  failb=3D 63(Q=
)  OK
[    6.739138] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[    6.740443] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(D=
)  OK
[    6.741679] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(D=
)  OK
[    6.742917] raid6test: test_disks(20, 24): faila=3D 20(D)  failb=3D 24(D=
)  OK
[    6.744154] raid6test: test_disks(20, 25): faila=3D 20(D)  failb=3D 25(D=
)  OK
[    6.745353] raid6test: test_disks(20, 26): faila=3D 20(D)  failb=3D 26(D=
)  OK
[    6.746604] raid6test: test_disks(20, 27): faila=3D 20(D)  failb=3D 27(D=
)  OK
[    6.747834] raid6test: test_disks(20, 28): faila=3D 20(D)  failb=3D 28(D=
)  OK
[    6.749124] raid6test: test_disks(20, 29): faila=3D 20(D)  failb=3D 29(D=
)  OK
[    6.750402] raid6test: test_disks(20, 30): faila=3D 20(D)  failb=3D 30(D=
)  OK
[    6.751581] raid6test: test_disks(20, 31): faila=3D 20(D)  failb=3D 31(D=
)  OK
[    6.752820] raid6test: test_disks(20, 32): faila=3D 20(D)  failb=3D 32(D=
)  OK
[    6.754041] raid6test: test_disks(20, 33): faila=3D 20(D)  failb=3D 33(D=
)  OK
[    6.755305] raid6test: test_disks(20, 34): faila=3D 20(D)  failb=3D 34(D=
)  OK
[    6.756551] raid6test: test_disks(20, 35): faila=3D 20(D)  failb=3D 35(D=
)  OK
[    6.757763] raid6test: test_disks(20, 36): faila=3D 20(D)  failb=3D 36(D=
)  OK
[    6.758997] raid6test: test_disks(20, 37): faila=3D 20(D)  failb=3D 37(D=
)  OK
[    6.760288] raid6test: test_disks(20, 38): faila=3D 20(D)  failb=3D 38(D=
)  OK
[    6.761510] raid6test: test_disks(20, 39): faila=3D 20(D)  failb=3D 39(D=
)  OK
[    6.762714] raid6test: test_disks(20, 40): faila=3D 20(D)  failb=3D 40(D=
)  OK
[    6.763966] raid6test: test_disks(20, 41): faila=3D 20(D)  failb=3D 41(D=
)  OK
[    6.765141] raid6test: test_disks(20, 42): faila=3D 20(D)  failb=3D 42(D=
)  OK
[    6.766369] raid6test: test_disks(20, 43): faila=3D 20(D)  failb=3D 43(D=
)  OK
[    6.767587] raid6test: test_disks(20, 44): faila=3D 20(D)  failb=3D 44(D=
)  OK
[    6.768867] raid6test: test_disks(20, 45): faila=3D 20(D)  failb=3D 45(D=
)  OK
[    6.770188] raid6test: test_disks(20, 46): faila=3D 20(D)  failb=3D 46(D=
)  OK
[    6.771393] raid6test: test_disks(20, 47): faila=3D 20(D)  failb=3D 47(D=
)  OK
[    6.772562] raid6test: test_disks(20, 48): faila=3D 20(D)  failb=3D 48(D=
)  OK
[    6.773784] raid6test: test_disks(20, 49): faila=3D 20(D)  failb=3D 49(D=
)  OK
[    6.774997] raid6test: test_disks(20, 50): faila=3D 20(D)  failb=3D 50(D=
)  OK
[    6.776254] raid6test: test_disks(20, 51): faila=3D 20(D)  failb=3D 51(D=
)  OK
[    6.777472] raid6test: test_disks(20, 52): faila=3D 20(D)  failb=3D 52(D=
)  OK
[    6.778702] raid6test: test_disks(20, 53): faila=3D 20(D)  failb=3D 53(D=
)  OK
[    6.779930] raid6test: test_disks(20, 54): faila=3D 20(D)  failb=3D 54(D=
)  OK
[    6.781211] raid6test: test_disks(20, 55): faila=3D 20(D)  failb=3D 55(D=
)  OK
[    6.782439] raid6test: test_disks(20, 56): faila=3D 20(D)  failb=3D 56(D=
)  OK
[    6.783653] raid6test: test_disks(20, 57): faila=3D 20(D)  failb=3D 57(D=
)  OK
[    6.784915] raid6test: test_disks(20, 58): faila=3D 20(D)  failb=3D 58(D=
)  OK
[    6.786090] raid6test: test_disks(20, 59): faila=3D 20(D)  failb=3D 59(D=
)  OK
[    6.787315] raid6test: test_disks(20, 60): faila=3D 20(D)  failb=3D 60(D=
)  OK
[    6.788574] raid6test: test_disks(20, 61): faila=3D 20(D)  failb=3D 61(D=
)  OK
[    6.789775] raid6test: test_disks(20, 62): faila=3D 20(D)  failb=3D 62(P=
)  OK
[    6.791073] raid6test: test_disks(20, 63): faila=3D 20(D)  failb=3D 63(Q=
)  OK
[    6.792346] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(D=
)  OK
[    6.793531] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(D=
)  OK
[    6.794697] raid6test: test_disks(21, 24): faila=3D 21(D)  failb=3D 24(D=
)  OK
[    6.795910] raid6test: test_disks(21, 25): faila=3D 21(D)  failb=3D 25(D=
)  OK
[    6.797124] raid6test: test_disks(21, 26): faila=3D 21(D)  failb=3D 26(D=
)  OK
[    6.798368] raid6test: test_disks(21, 27): faila=3D 21(D)  failb=3D 27(D=
)  OK
[    6.799609] raid6test: test_disks(21, 28): faila=3D 21(D)  failb=3D 28(D=
)  OK
[    6.800886] raid6test: test_disks(21, 29): faila=3D 21(D)  failb=3D 29(D=
)  OK
[    6.802114] raid6test: test_disks(21, 30): faila=3D 21(D)  failb=3D 30(D=
)  OK
[    6.803340] raid6test: test_disks(21, 31): faila=3D 21(D)  failb=3D 31(D=
)  OK
[    6.804551] raid6test: test_disks(21, 32): faila=3D 21(D)  failb=3D 32(D=
)  OK
[    6.805728] raid6test: test_disks(21, 33): faila=3D 21(D)  failb=3D 33(D=
)  OK
[    6.806941] raid6test: test_disks(21, 34): faila=3D 21(D)  failb=3D 34(D=
)  OK
[    6.808166] raid6test: test_disks(21, 35): faila=3D 21(D)  failb=3D 35(D=
)  OK
[    6.809400] raid6test: test_disks(21, 36): faila=3D 21(D)  failb=3D 36(D=
)  OK
[    6.810673] raid6test: test_disks(21, 37): faila=3D 21(D)  failb=3D 37(D=
)  OK
[    6.811917] raid6test: test_disks(21, 38): faila=3D 21(D)  failb=3D 38(D=
)  OK
[    6.813161] raid6test: test_disks(21, 39): faila=3D 21(D)  failb=3D 39(D=
)  OK
[    6.814354] raid6test: test_disks(21, 40): faila=3D 21(D)  failb=3D 40(D=
)  OK
[    6.815603] raid6test: test_disks(21, 41): faila=3D 21(D)  failb=3D 41(D=
)  OK
[    6.816821] raid6test: test_disks(21, 42): faila=3D 21(D)  failb=3D 42(D=
)  OK
[    6.818056] raid6test: test_disks(21, 43): faila=3D 21(D)  failb=3D 43(D=
)  OK
[    6.819249] raid6test: test_disks(21, 44): faila=3D 21(D)  failb=3D 44(D=
)  OK
[    6.820526] raid6test: test_disks(21, 45): faila=3D 21(D)  failb=3D 45(D=
)  OK
[    6.821741] raid6test: test_disks(21, 46): faila=3D 21(D)  failb=3D 46(D=
)  OK
[    6.822981] raid6test: test_disks(21, 47): faila=3D 21(D)  failb=3D 47(D=
)  OK
[    6.824196] raid6test: test_disks(21, 48): faila=3D 21(D)  failb=3D 48(D=
)  OK
[    6.825404] raid6test: test_disks(21, 49): faila=3D 21(D)  failb=3D 49(D=
)  OK
[    6.826637] raid6test: test_disks(21, 50): faila=3D 21(D)  failb=3D 50(D=
)  OK
[    6.827857] raid6test: test_disks(21, 51): faila=3D 21(D)  failb=3D 51(D=
)  OK
[    6.829106] raid6test: test_disks(21, 52): faila=3D 21(D)  failb=3D 52(D=
)  OK
[    6.830378] raid6test: test_disks(21, 53): faila=3D 21(D)  failb=3D 53(D=
)  OK
[    6.831643] raid6test: test_disks(21, 54): faila=3D 21(D)  failb=3D 54(D=
)  OK
[    6.832804] raid6test: test_disks(21, 55): faila=3D 21(D)  failb=3D 55(D=
)  OK
[    6.834011] raid6test: test_disks(21, 56): faila=3D 21(D)  failb=3D 56(D=
)  OK
[    6.835299] raid6test: test_disks(21, 57): faila=3D 21(D)  failb=3D 57(D=
)  OK
[    6.836524] raid6test: test_disks(21, 58): faila=3D 21(D)  failb=3D 58(D=
)  OK
[    6.837763] raid6test: test_disks(21, 59): faila=3D 21(D)  failb=3D 59(D=
)  OK
[    6.838941] raid6test: test_disks(21, 60): faila=3D 21(D)  failb=3D 60(D=
)  OK
[    6.840161] raid6test: test_disks(21, 61): faila=3D 21(D)  failb=3D 61(D=
)  OK
[    6.841391] raid6test: test_disks(21, 62): faila=3D 21(D)  failb=3D 62(P=
)  OK
[    6.842582] raid6test: test_disks(21, 63): faila=3D 21(D)  failb=3D 63(Q=
)  OK
[    6.843815] raid6test: test_disks(22, 23): faila=3D 22(D)  failb=3D 23(D=
)  OK
[    6.845051] raid6test: test_disks(22, 24): faila=3D 22(D)  failb=3D 24(D=
)  OK
[    6.846286] raid6test: test_disks(22, 25): faila=3D 22(D)  failb=3D 25(D=
)  OK
[    6.847498] raid6test: test_disks(22, 26): faila=3D 22(D)  failb=3D 26(D=
)  OK
[    6.848738] raid6test: test_disks(22, 27): faila=3D 22(D)  failb=3D 27(D=
)  OK
[    6.849964] raid6test: test_disks(22, 28): faila=3D 22(D)  failb=3D 28(D=
)  OK
[    6.851282] raid6test: test_disks(22, 29): faila=3D 22(D)  failb=3D 29(D=
)  OK
[    6.852478] raid6test: test_disks(22, 30): faila=3D 22(D)  failb=3D 30(D=
)  OK
[    6.853704] raid6test: test_disks(22, 31): faila=3D 22(D)  failb=3D 31(D=
)  OK
[    6.854926] raid6test: test_disks(22, 32): faila=3D 22(D)  failb=3D 32(D=
)  OK
[    6.856095] raid6test: test_disks(22, 33): faila=3D 22(D)  failb=3D 33(D=
)  OK
[    6.857341] raid6test: test_disks(22, 34): faila=3D 22(D)  failb=3D 34(D=
)  OK
[    6.858591] raid6test: test_disks(22, 35): faila=3D 22(D)  failb=3D 35(D=
)  OK
[    6.859810] raid6test: test_disks(22, 36): faila=3D 22(D)  failb=3D 36(D=
)  OK
[    6.861076] raid6test: test_disks(22, 37): faila=3D 22(D)  failb=3D 37(D=
)  OK
[    6.862302] raid6test: test_disks(22, 38): faila=3D 22(D)  failb=3D 38(D=
)  OK
[    6.863529] raid6test: test_disks(22, 39): faila=3D 22(D)  failb=3D 39(D=
)  OK
[    6.864750] raid6test: test_disks(22, 40): faila=3D 22(D)  failb=3D 40(D=
)  OK
[    6.865974] raid6test: test_disks(22, 41): faila=3D 22(D)  failb=3D 41(D=
)  OK
[    6.867161] raid6test: test_disks(22, 42): faila=3D 22(D)  failb=3D 42(D=
)  OK
[    6.868411] raid6test: test_disks(22, 43): faila=3D 22(D)  failb=3D 43(D=
)  OK
[    6.869638] raid6test: test_disks(22, 44): faila=3D 22(D)  failb=3D 44(D=
)  OK
[    6.870901] raid6test: test_disks(22, 45): faila=3D 22(D)  failb=3D 45(D=
)  OK
[    6.872117] raid6test: test_disks(22, 46): faila=3D 22(D)  failb=3D 46(D=
)  OK
[    6.873292] raid6test: test_disks(22, 47): faila=3D 22(D)  failb=3D 47(D=
)  OK
[    6.874494] raid6test: test_disks(22, 48): faila=3D 22(D)  failb=3D 48(D=
)  OK
[    6.875730] raid6test: test_disks(22, 49): faila=3D 22(D)  failb=3D 49(D=
)  OK
[    6.876938] raid6test: test_disks(22, 50): faila=3D 22(D)  failb=3D 50(D=
)  OK
[    6.878119] raid6test: test_disks(22, 51): faila=3D 22(D)  failb=3D 51(D=
)  OK
[    6.879357] raid6test: test_disks(22, 52): faila=3D 22(D)  failb=3D 52(D=
)  OK
[    6.880641] raid6test: test_disks(22, 53): faila=3D 22(D)  failb=3D 53(D=
)  OK
[    6.881846] raid6test: test_disks(22, 54): faila=3D 22(D)  failb=3D 54(D=
)  OK
[    6.883062] raid6test: test_disks(22, 55): faila=3D 22(D)  failb=3D 55(D=
)  OK
[    6.884293] raid6test: test_disks(22, 56): faila=3D 22(D)  failb=3D 56(D=
)  OK
[    6.885517] raid6test: test_disks(22, 57): faila=3D 22(D)  failb=3D 57(D=
)  OK
[    6.886689] raid6test: test_disks(22, 58): faila=3D 22(D)  failb=3D 58(D=
)  OK
[    6.887899] raid6test: test_disks(22, 59): faila=3D 22(D)  failb=3D 59(D=
)  OK
[    6.889125] raid6test: test_disks(22, 60): faila=3D 22(D)  failb=3D 60(D=
)  OK
[    6.890347] raid6test: test_disks(22, 61): faila=3D 22(D)  failb=3D 61(D=
)  OK
[    6.891558] raid6test: test_disks(22, 62): faila=3D 22(D)  failb=3D 62(P=
)  OK
[    6.892758] raid6test: test_disks(22, 63): faila=3D 22(D)  failb=3D 63(Q=
)  OK
[    6.893987] raid6test: test_disks(23, 24): faila=3D 23(D)  failb=3D 24(D=
)  OK
[    6.895198] raid6test: test_disks(23, 25): faila=3D 23(D)  failb=3D 25(D=
)  OK
[    6.896415] raid6test: test_disks(23, 26): faila=3D 23(D)  failb=3D 26(D=
)  OK
[    6.897637] raid6test: test_disks(23, 27): faila=3D 23(D)  failb=3D 27(D=
)  OK
[    6.898853] raid6test: test_disks(23, 28): faila=3D 23(D)  failb=3D 28(D=
)  OK
[    6.900131] raid6test: test_disks(23, 29): faila=3D 23(D)  failb=3D 29(D=
)  OK
[    6.901372] raid6test: test_disks(23, 30): faila=3D 23(D)  failb=3D 30(D=
)  OK
[    6.902556] raid6test: test_disks(23, 31): faila=3D 23(D)  failb=3D 31(D=
)  OK
[    6.903791] raid6test: test_disks(23, 32): faila=3D 23(D)  failb=3D 32(D=
)  OK
[    6.905017] raid6test: test_disks(23, 33): faila=3D 23(D)  failb=3D 33(D=
)  OK
[    6.906240] raid6test: test_disks(23, 34): faila=3D 23(D)  failb=3D 34(D=
)  OK
[    6.907467] raid6test: test_disks(23, 35): faila=3D 23(D)  failb=3D 35(D=
)  OK
[    6.908711] raid6test: test_disks(23, 36): faila=3D 23(D)  failb=3D 36(D=
)  OK
[    6.909918] raid6test: test_disks(23, 37): faila=3D 23(D)  failb=3D 37(D=
)  OK
[    6.911244] raid6test: test_disks(23, 38): faila=3D 23(D)  failb=3D 38(D=
)  OK
[    6.912408] raid6test: test_disks(23, 39): faila=3D 23(D)  failb=3D 39(D=
)  OK
[    6.913678] raid6test: test_disks(23, 40): faila=3D 23(D)  failb=3D 40(D=
)  OK
[    6.914927] raid6test: test_disks(23, 41): faila=3D 23(D)  failb=3D 41(D=
)  OK
[    6.916144] raid6test: test_disks(23, 42): faila=3D 23(D)  failb=3D 42(D=
)  OK
[    6.917312] raid6test: test_disks(23, 43): faila=3D 23(D)  failb=3D 43(D=
)  OK
[    6.918511] raid6test: test_disks(23, 44): faila=3D 23(D)  failb=3D 44(D=
)  OK
[    6.919749] raid6test: test_disks(23, 45): faila=3D 23(D)  failb=3D 45(D=
)  OK
[    6.920986] raid6test: test_disks(23, 46): faila=3D 23(D)  failb=3D 46(D=
)  OK
[    6.922277] raid6test: test_disks(23, 47): faila=3D 23(D)  failb=3D 47(D=
)  OK
[    6.923487] raid6test: test_disks(23, 48): faila=3D 23(D)  failb=3D 48(D=
)  OK
[    6.924727] raid6test: test_disks(23, 49): faila=3D 23(D)  failb=3D 49(D=
)  OK
[    6.925988] raid6test: test_disks(23, 50): faila=3D 23(D)  failb=3D 50(D=
)  OK
[    6.927250] raid6test: test_disks(23, 51): faila=3D 23(D)  failb=3D 51(D=
)  OK
[    6.928517] raid6test: test_disks(23, 52): faila=3D 23(D)  failb=3D 52(D=
)  OK
[    6.929701] raid6test: test_disks(23, 53): faila=3D 23(D)  failb=3D 53(D=
)  OK
[    6.930913] raid6test: test_disks(23, 54): faila=3D 23(D)  failb=3D 54(D=
)  OK
[    6.932051] raid6test: test_disks(23, 55): faila=3D 23(D)  failb=3D 55(D=
)  OK
[    6.933208] raid6test: test_disks(23, 56): faila=3D 23(D)  failb=3D 56(D=
)  OK
[    6.934431] raid6test: test_disks(23, 57): faila=3D 23(D)  failb=3D 57(D=
)  OK
[    6.935656] raid6test: test_disks(23, 58): faila=3D 23(D)  failb=3D 58(D=
)  OK
[    6.936885] raid6test: test_disks(23, 59): faila=3D 23(D)  failb=3D 59(D=
)  OK
[    6.938085] raid6test: test_disks(23, 60): faila=3D 23(D)  failb=3D 60(D=
)  OK
[    6.939304] raid6test: test_disks(23, 61): faila=3D 23(D)  failb=3D 61(D=
)  OK
[    6.940568] raid6test: test_disks(23, 62): faila=3D 23(D)  failb=3D 62(P=
)  OK
[    6.941792] raid6test: test_disks(23, 63): faila=3D 23(D)  failb=3D 63(Q=
)  OK
[    6.943036] raid6test: test_disks(24, 25): faila=3D 24(D)  failb=3D 25(D=
)  OK
[    6.944240] raid6test: test_disks(24, 26): faila=3D 24(D)  failb=3D 26(D=
)  OK
[    6.945455] raid6test: test_disks(24, 27): faila=3D 24(D)  failb=3D 27(D=
)  OK
[    6.946680] raid6test: test_disks(24, 28): faila=3D 24(D)  failb=3D 28(D=
)  OK
[    6.947867] raid6test: test_disks(24, 29): faila=3D 24(D)  failb=3D 29(D=
)  OK
[    6.949066] raid6test: test_disks(24, 30): faila=3D 24(D)  failb=3D 30(D=
)  OK
[    6.950330] raid6test: test_disks(24, 31): faila=3D 24(D)  failb=3D 31(D=
)  OK
[    6.951535] raid6test: test_disks(24, 32): faila=3D 24(D)  failb=3D 32(D=
)  OK
[    6.952738] raid6test: test_disks(24, 33): faila=3D 24(D)  failb=3D 33(D=
)  OK
[    6.953938] raid6test: test_disks(24, 34): faila=3D 24(D)  failb=3D 34(D=
)  OK
[    6.955112] raid6test: test_disks(24, 35): faila=3D 24(D)  failb=3D 35(D=
)  OK
[    6.956375] raid6test: test_disks(24, 36): faila=3D 24(D)  failb=3D 36(D=
)  OK
[    6.957586] raid6test: test_disks(24, 37): faila=3D 24(D)  failb=3D 37(D=
)  OK
[    6.958830] raid6test: test_disks(24, 38): faila=3D 24(D)  failb=3D 38(D=
)  OK
[    6.960097] raid6test: test_disks(24, 39): faila=3D 24(D)  failb=3D 39(D=
)  OK
[    6.961335] raid6test: test_disks(24, 40): faila=3D 24(D)  failb=3D 40(D=
)  OK
[    6.962586] raid6test: test_disks(24, 41): faila=3D 24(D)  failb=3D 41(D=
)  OK
[    6.963826] raid6test: test_disks(24, 42): faila=3D 24(D)  failb=3D 42(D=
)  OK
[    6.964996] raid6test: test_disks(24, 43): faila=3D 24(D)  failb=3D 43(D=
)  OK
[    6.966284] raid6test: test_disks(24, 44): faila=3D 24(D)  failb=3D 44(D=
)  OK
[    6.967510] raid6test: test_disks(24, 45): faila=3D 24(D)  failb=3D 45(D=
)  OK
[    6.968731] raid6test: test_disks(24, 46): faila=3D 24(D)  failb=3D 46(D=
)  OK
[    6.969908] raid6test: test_disks(24, 47): faila=3D 24(D)  failb=3D 47(D=
)  OK
[    6.971136] raid6test: test_disks(24, 48): faila=3D 24(D)  failb=3D 48(D=
)  OK
[    6.972360] raid6test: test_disks(24, 49): faila=3D 24(D)  failb=3D 49(D=
)  OK
[    6.973594] raid6test: test_disks(24, 50): faila=3D 24(D)  failb=3D 50(D=
)  OK
[    6.974884] raid6test: test_disks(24, 51): faila=3D 24(D)  failb=3D 51(D=
)  OK
[    6.976058] raid6test: test_disks(24, 52): faila=3D 24(D)  failb=3D 52(D=
)  OK
[    6.977304] raid6test: test_disks(24, 53): faila=3D 24(D)  failb=3D 53(D=
)  OK
[    6.978564] raid6test: test_disks(24, 54): faila=3D 24(D)  failb=3D 54(D=
)  OK
[    6.979812] raid6test: test_disks(24, 55): faila=3D 24(D)  failb=3D 55(D=
)  OK
[    6.981117] raid6test: test_disks(24, 56): faila=3D 24(D)  failb=3D 56(D=
)  OK
[    6.982306] raid6test: test_disks(24, 57): faila=3D 24(D)  failb=3D 57(D=
)  OK
[    6.983462] raid6test: test_disks(24, 58): faila=3D 24(D)  failb=3D 58(D=
)  OK
[    6.984597] raid6test: test_disks(24, 59): faila=3D 24(D)  failb=3D 59(D=
)  OK
[    6.985790] raid6test: test_disks(24, 60): faila=3D 24(D)  failb=3D 60(D=
)  OK
[    6.987106] raid6test: test_disks(24, 61): faila=3D 24(D)  failb=3D 61(D=
)  OK
[    6.988428] raid6test: test_disks(24, 62): faila=3D 24(D)  failb=3D 62(P=
)  OK
[    6.989616] raid6test: test_disks(24, 63): faila=3D 24(D)  failb=3D 63(Q=
)  OK
[    6.990857] raid6test: test_disks(25, 26): faila=3D 25(D)  failb=3D 26(D=
)  OK
[    6.992078] raid6test: test_disks(25, 27): faila=3D 25(D)  failb=3D 27(D=
)  OK
[    6.993265] raid6test: test_disks(25, 28): faila=3D 25(D)  failb=3D 28(D=
)  OK
[    6.994419] raid6test: test_disks(25, 29): faila=3D 25(D)  failb=3D 29(D=
)  OK
[    6.995588] raid6test: test_disks(25, 30): faila=3D 25(D)  failb=3D 30(D=
)  OK
[    6.996745] raid6test: test_disks(25, 31): faila=3D 25(D)  failb=3D 31(D=
)  OK
[    6.997922] raid6test: test_disks(25, 32): faila=3D 25(D)  failb=3D 32(D=
)  OK
[    6.999103] raid6test: test_disks(25, 33): faila=3D 25(D)  failb=3D 33(D=
)  OK
[    7.000302] raid6test: test_disks(25, 34): faila=3D 25(D)  failb=3D 34(D=
)  OK
[    7.001445] raid6test: test_disks(25, 35): faila=3D 25(D)  failb=3D 35(D=
)  OK
[    7.002776] raid6test: test_disks(25, 36): faila=3D 25(D)  failb=3D 36(D=
)  OK
[    7.003982] raid6test: test_disks(25, 37): faila=3D 25(D)  failb=3D 37(D=
)  OK
[    7.005130] raid6test: test_disks(25, 38): faila=3D 25(D)  failb=3D 38(D=
)  OK
[    7.006339] raid6test: test_disks(25, 39): faila=3D 25(D)  failb=3D 39(D=
)  OK
[    7.007498] raid6test: test_disks(25, 40): faila=3D 25(D)  failb=3D 40(D=
)  OK
[    7.008807] raid6test: test_disks(25, 41): faila=3D 25(D)  failb=3D 41(D=
)  OK
[    7.010192] raid6test: test_disks(25, 42): faila=3D 25(D)  failb=3D 42(D=
)  OK
[    7.011429] raid6test: test_disks(25, 43): faila=3D 25(D)  failb=3D 43(D=
)  OK
[    7.012616] raid6test: test_disks(25, 44): faila=3D 25(D)  failb=3D 44(D=
)  OK
[    7.013760] raid6test: test_disks(25, 45): faila=3D 25(D)  failb=3D 45(D=
)  OK
[    7.014959] raid6test: test_disks(25, 46): faila=3D 25(D)  failb=3D 46(D=
)  OK
[    7.016222] raid6test: test_disks(25, 47): faila=3D 25(D)  failb=3D 47(D=
)  OK
[    7.017569] raid6test: test_disks(25, 48): faila=3D 25(D)  failb=3D 48(D=
)  OK
[    7.018841] raid6test: test_disks(25, 49): faila=3D 25(D)  failb=3D 49(D=
)  OK
[    7.020169] raid6test: test_disks(25, 50): faila=3D 25(D)  failb=3D 50(D=
)  OK
[    7.021456] raid6test: test_disks(25, 51): faila=3D 25(D)  failb=3D 51(D=
)  OK
[    7.022715] raid6test: test_disks(25, 52): faila=3D 25(D)  failb=3D 52(D=
)  OK
[    7.023973] raid6test: test_disks(25, 53): faila=3D 25(D)  failb=3D 53(D=
)  OK
[    7.025287] raid6test: test_disks(25, 54): faila=3D 25(D)  failb=3D 54(D=
)  OK
[    7.026511] raid6test: test_disks(25, 55): faila=3D 25(D)  failb=3D 55(D=
)  OK
[    7.027668] raid6test: test_disks(25, 56): faila=3D 25(D)  failb=3D 56(D=
)  OK
[    7.028887] raid6test: test_disks(25, 57): faila=3D 25(D)  failb=3D 57(D=
)  OK
[    7.030086] raid6test: test_disks(25, 58): faila=3D 25(D)  failb=3D 58(D=
)  OK
[    7.031222] raid6test: test_disks(25, 59): faila=3D 25(D)  failb=3D 59(D=
)  OK
[    7.032397] raid6test: test_disks(25, 60): faila=3D 25(D)  failb=3D 60(D=
)  OK
[    7.033566] raid6test: test_disks(25, 61): faila=3D 25(D)  failb=3D 61(D=
)  OK
[    7.034690] raid6test: test_disks(25, 62): faila=3D 25(D)  failb=3D 62(P=
)  OK
[    7.035933] raid6test: test_disks(25, 63): faila=3D 25(D)  failb=3D 63(Q=
)  OK
[    7.037092] raid6test: test_disks(26, 27): faila=3D 26(D)  failb=3D 27(D=
)  OK
[    7.038277] raid6test: test_disks(26, 28): faila=3D 26(D)  failb=3D 28(D=
)  OK
[    7.039537] raid6test: test_disks(26, 29): faila=3D 26(D)  failb=3D 29(D=
)  OK
[    7.040776] raid6test: test_disks(26, 30): faila=3D 26(D)  failb=3D 30(D=
)  OK
[    7.042026] raid6test: test_disks(26, 31): faila=3D 26(D)  failb=3D 31(D=
)  OK
[    7.043201] raid6test: test_disks(26, 32): faila=3D 26(D)  failb=3D 32(D=
)  OK
[    7.044398] raid6test: test_disks(26, 33): faila=3D 26(D)  failb=3D 33(D=
)  OK
[    7.045660] raid6test: test_disks(26, 34): faila=3D 26(D)  failb=3D 34(D=
)  OK
[    7.046850] raid6test: test_disks(26, 35): faila=3D 26(D)  failb=3D 35(D=
)  OK
[    7.048032] raid6test: test_disks(26, 36): faila=3D 26(D)  failb=3D 36(D=
)  OK
[    7.049222] raid6test: test_disks(26, 37): faila=3D 26(D)  failb=3D 37(D=
)  OK
[    7.050459] raid6test: test_disks(26, 38): faila=3D 26(D)  failb=3D 38(D=
)  OK
[    7.051686] raid6test: test_disks(26, 39): faila=3D 26(D)  failb=3D 39(D=
)  OK
[    7.052922] raid6test: test_disks(26, 40): faila=3D 26(D)  failb=3D 40(D=
)  OK
[    7.054159] raid6test: test_disks(26, 41): faila=3D 26(D)  failb=3D 41(D=
)  OK
[    7.055406] raid6test: test_disks(26, 42): faila=3D 26(D)  failb=3D 42(D=
)  OK
[    7.056644] raid6test: test_disks(26, 43): faila=3D 26(D)  failb=3D 43(D=
)  OK
[    7.057874] raid6test: test_disks(26, 44): faila=3D 26(D)  failb=3D 44(D=
)  OK
[    7.059102] raid6test: test_disks(26, 45): faila=3D 26(D)  failb=3D 45(D=
)  OK
[    7.060381] raid6test: test_disks(26, 46): faila=3D 26(D)  failb=3D 46(D=
)  OK
[    7.061588] raid6test: test_disks(26, 47): faila=3D 26(D)  failb=3D 47(D=
)  OK
[    7.062754] raid6test: test_disks(26, 48): faila=3D 26(D)  failb=3D 48(D=
)  OK
[    7.063920] raid6test: test_disks(26, 49): faila=3D 26(D)  failb=3D 49(D=
)  OK
[    7.065078] raid6test: test_disks(26, 50): faila=3D 26(D)  failb=3D 50(D=
)  OK
[    7.066280] raid6test: test_disks(26, 51): faila=3D 26(D)  failb=3D 51(D=
)  OK
[    7.067490] raid6test: test_disks(26, 52): faila=3D 26(D)  failb=3D 52(D=
)  OK
[    7.068692] raid6test: test_disks(26, 53): faila=3D 26(D)  failb=3D 53(D=
)  OK
[    7.069876] raid6test: test_disks(26, 54): faila=3D 26(D)  failb=3D 54(D=
)  OK
[    7.071155] raid6test: test_disks(26, 55): faila=3D 26(D)  failb=3D 55(D=
)  OK
[    7.072411] raid6test: test_disks(26, 56): faila=3D 26(D)  failb=3D 56(D=
)  OK
[    7.073564] raid6test: test_disks(26, 57): faila=3D 26(D)  failb=3D 57(D=
)  OK
[    7.074757] raid6test: test_disks(26, 58): faila=3D 26(D)  failb=3D 58(D=
)  OK
[    7.076011] raid6test: test_disks(26, 59): faila=3D 26(D)  failb=3D 59(D=
)  OK
[    7.077207] raid6test: test_disks(26, 60): faila=3D 26(D)  failb=3D 60(D=
)  OK
[    7.078447] raid6test: test_disks(26, 61): faila=3D 26(D)  failb=3D 61(D=
)  OK
[    7.079675] raid6test: test_disks(26, 62): faila=3D 26(D)  failb=3D 62(P=
)  OK
[    7.080931] raid6test: test_disks(26, 63): faila=3D 26(D)  failb=3D 63(Q=
)  OK
[    7.082097] raid6test: test_disks(27, 28): faila=3D 27(D)  failb=3D 28(D=
)  OK
[    7.083372] raid6test: test_disks(27, 29): faila=3D 27(D)  failb=3D 29(D=
)  OK
[    7.084602] raid6test: test_disks(27, 30): faila=3D 27(D)  failb=3D 30(D=
)  OK
[    7.085771] raid6test: test_disks(27, 31): faila=3D 27(D)  failb=3D 31(D=
)  OK
[    7.086975] raid6test: test_disks(27, 32): faila=3D 27(D)  failb=3D 32(D=
)  OK
[    7.088250] raid6test: test_disks(27, 33): faila=3D 27(D)  failb=3D 33(D=
)  OK
[    7.089435] raid6test: test_disks(27, 34): faila=3D 27(D)  failb=3D 34(D=
)  OK
[    7.090725] raid6test: test_disks(27, 35): faila=3D 27(D)  failb=3D 35(D=
)  OK
[    7.091981] raid6test: test_disks(27, 36): faila=3D 27(D)  failb=3D 36(D=
)  OK
[    7.093244] raid6test: test_disks(27, 37): faila=3D 27(D)  failb=3D 37(D=
)  OK
[    7.094459] raid6test: test_disks(27, 38): faila=3D 27(D)  failb=3D 38(D=
)  OK
[    7.095604] raid6test: test_disks(27, 39): faila=3D 27(D)  failb=3D 39(D=
)  OK
[    7.096742] raid6test: test_disks(27, 40): faila=3D 27(D)  failb=3D 40(D=
)  OK
[    7.097971] raid6test: test_disks(27, 41): faila=3D 27(D)  failb=3D 41(D=
)  OK
[    7.099304] raid6test: test_disks(27, 42): faila=3D 27(D)  failb=3D 42(D=
)  OK
[    7.100621] raid6test: test_disks(27, 43): faila=3D 27(D)  failb=3D 43(D=
)  OK
[    7.101817] raid6test: test_disks(27, 44): faila=3D 27(D)  failb=3D 44(D=
)  OK
[    7.102989] raid6test: test_disks(27, 45): faila=3D 27(D)  failb=3D 45(D=
)  OK
[    7.104164] raid6test: test_disks(27, 46): faila=3D 27(D)  failb=3D 46(D=
)  OK
[    7.105342] raid6test: test_disks(27, 47): faila=3D 27(D)  failb=3D 47(D=
)  OK
[    7.106493] raid6test: test_disks(27, 48): faila=3D 27(D)  failb=3D 48(D=
)  OK
[    7.107680] raid6test: test_disks(27, 49): faila=3D 27(D)  failb=3D 49(D=
)  OK
[    7.108886] raid6test: test_disks(27, 50): faila=3D 27(D)  failb=3D 50(D=
)  OK
[    7.110085] raid6test: test_disks(27, 51): faila=3D 27(D)  failb=3D 51(D=
)  OK
[    7.111413] raid6test: test_disks(27, 52): faila=3D 27(D)  failb=3D 52(D=
)  OK
[    7.112607] raid6test: test_disks(27, 53): faila=3D 27(D)  failb=3D 53(D=
)  OK
[    7.113782] raid6test: test_disks(27, 54): faila=3D 27(D)  failb=3D 54(D=
)  OK
[    7.114985] raid6test: test_disks(27, 55): faila=3D 27(D)  failb=3D 55(D=
)  OK
[    7.116308] raid6test: test_disks(27, 56): faila=3D 27(D)  failb=3D 56(D=
)  OK
[    7.117492] raid6test: test_disks(27, 57): faila=3D 27(D)  failb=3D 57(D=
)  OK
[    7.118723] raid6test: test_disks(27, 58): faila=3D 27(D)  failb=3D 58(D=
)  OK
[    7.119872] raid6test: test_disks(27, 59): faila=3D 27(D)  failb=3D 59(D=
)  OK
[    7.121156] raid6test: test_disks(27, 60): faila=3D 27(D)  failb=3D 60(D=
)  OK
[    7.122427] raid6test: test_disks(27, 61): faila=3D 27(D)  failb=3D 61(D=
)  OK
[    7.123672] raid6test: test_disks(27, 62): faila=3D 27(D)  failb=3D 62(P=
)  OK
[    7.124918] raid6test: test_disks(27, 63): faila=3D 27(D)  failb=3D 63(Q=
)  OK
[    7.126188] raid6test: test_disks(28, 29): faila=3D 28(D)  failb=3D 29(D=
)  OK
[    7.127461] raid6test: test_disks(28, 30): faila=3D 28(D)  failb=3D 30(D=
)  OK
[    7.128745] raid6test: test_disks(28, 31): faila=3D 28(D)  failb=3D 31(D=
)  OK
[    7.130002] raid6test: test_disks(28, 32): faila=3D 28(D)  failb=3D 32(D=
)  OK
[    7.131193] raid6test: test_disks(28, 33): faila=3D 28(D)  failb=3D 33(D=
)  OK
[    7.132380] raid6test: test_disks(28, 34): faila=3D 28(D)  failb=3D 34(D=
)  OK
[    7.133539] raid6test: test_disks(28, 35): faila=3D 28(D)  failb=3D 35(D=
)  OK
[    7.134689] raid6test: test_disks(28, 36): faila=3D 28(D)  failb=3D 36(D=
)  OK
[    7.135852] raid6test: test_disks(28, 37): faila=3D 28(D)  failb=3D 37(D=
)  OK
[    7.137009] raid6test: test_disks(28, 38): faila=3D 28(D)  failb=3D 38(D=
)  OK
[    7.138217] raid6test: test_disks(28, 39): faila=3D 28(D)  failb=3D 39(D=
)  OK
[    7.139384] raid6test: test_disks(28, 40): faila=3D 28(D)  failb=3D 40(D=
)  OK
[    7.140584] raid6test: test_disks(28, 41): faila=3D 28(D)  failb=3D 41(D=
)  OK
[    7.141847] raid6test: test_disks(28, 42): faila=3D 28(D)  failb=3D 42(D=
)  OK
[    7.143089] raid6test: test_disks(28, 43): faila=3D 28(D)  failb=3D 43(D=
)  OK
[    7.144277] raid6test: test_disks(28, 44): faila=3D 28(D)  failb=3D 44(D=
)  OK
[    7.145487] raid6test: test_disks(28, 45): faila=3D 28(D)  failb=3D 45(D=
)  OK
[    7.146709] raid6test: test_disks(28, 46): faila=3D 28(D)  failb=3D 46(D=
)  OK
[    7.147913] raid6test: test_disks(28, 47): faila=3D 28(D)  failb=3D 47(D=
)  OK
[    7.149108] raid6test: test_disks(28, 48): faila=3D 28(D)  failb=3D 48(D=
)  OK
[    7.150332] raid6test: test_disks(28, 49): faila=3D 28(D)  failb=3D 49(D=
)  OK
[    7.151567] raid6test: test_disks(28, 50): faila=3D 28(D)  failb=3D 50(D=
)  OK
[    7.152800] raid6test: test_disks(28, 51): faila=3D 28(D)  failb=3D 51(D=
)  OK
[    7.154043] raid6test: test_disks(28, 52): faila=3D 28(D)  failb=3D 52(D=
)  OK
[    7.155284] raid6test: test_disks(28, 53): faila=3D 28(D)  failb=3D 53(D=
)  OK
[    7.156517] raid6test: test_disks(28, 54): faila=3D 28(D)  failb=3D 54(D=
)  OK
[    7.157740] raid6test: test_disks(28, 55): faila=3D 28(D)  failb=3D 55(D=
)  OK
[    7.158943] raid6test: test_disks(28, 56): faila=3D 28(D)  failb=3D 56(D=
)  OK
[    7.160163] raid6test: test_disks(28, 57): faila=3D 28(D)  failb=3D 57(D=
)  OK
[    7.161351] raid6test: test_disks(28, 58): faila=3D 28(D)  failb=3D 58(D=
)  OK
[    7.162568] raid6test: test_disks(28, 59): faila=3D 28(D)  failb=3D 59(D=
)  OK
[    7.163763] raid6test: test_disks(28, 60): faila=3D 28(D)  failb=3D 60(D=
)  OK
[    7.164946] raid6test: test_disks(28, 61): faila=3D 28(D)  failb=3D 61(D=
)  OK
[    7.166172] raid6test: test_disks(28, 62): faila=3D 28(D)  failb=3D 62(P=
)  OK
[    7.167368] raid6test: test_disks(28, 63): faila=3D 28(D)  failb=3D 63(Q=
)  OK
[    7.168589] raid6test: test_disks(29, 30): faila=3D 29(D)  failb=3D 30(D=
)  OK
[    7.169799] raid6test: test_disks(29, 31): faila=3D 29(D)  failb=3D 31(D=
)  OK
[    7.171063] raid6test: test_disks(29, 32): faila=3D 29(D)  failb=3D 32(D=
)  OK
[    7.172302] raid6test: test_disks(29, 33): faila=3D 29(D)  failb=3D 33(D=
)  OK
[    7.173486] raid6test: test_disks(29, 34): faila=3D 29(D)  failb=3D 34(D=
)  OK
[    7.174701] raid6test: test_disks(29, 35): faila=3D 29(D)  failb=3D 35(D=
)  OK
[    7.175908] raid6test: test_disks(29, 36): faila=3D 29(D)  failb=3D 36(D=
)  OK
[    7.177132] raid6test: test_disks(29, 37): faila=3D 29(D)  failb=3D 37(D=
)  OK
[    7.178391] raid6test: test_disks(29, 38): faila=3D 29(D)  failb=3D 38(D=
)  OK
[    7.179627] raid6test: test_disks(29, 39): faila=3D 29(D)  failb=3D 39(D=
)  OK
[    7.181233] raid6test: test_disks(29, 40): faila=3D 29(D)  failb=3D 40(D=
)  OK
[    7.182469] raid6test: test_disks(29, 41): faila=3D 29(D)  failb=3D 41(D=
)  OK
[    7.183721] raid6test: test_disks(29, 42): faila=3D 29(D)  failb=3D 42(D=
)  OK
[    7.184961] raid6test: test_disks(29, 43): faila=3D 29(D)  failb=3D 43(D=
)  OK
[    7.186233] raid6test: test_disks(29, 44): faila=3D 29(D)  failb=3D 44(D=
)  OK
[    7.187497] raid6test: test_disks(29, 45): faila=3D 29(D)  failb=3D 45(D=
)  OK
[    7.188691] raid6test: test_disks(29, 46): faila=3D 29(D)  failb=3D 46(D=
)  OK
[    7.189925] raid6test: test_disks(29, 47): faila=3D 29(D)  failb=3D 47(D=
)  OK
[    7.191205] raid6test: test_disks(29, 48): faila=3D 29(D)  failb=3D 48(D=
)  OK
[    7.192465] raid6test: test_disks(29, 49): faila=3D 29(D)  failb=3D 49(D=
)  OK
[    7.193678] raid6test: test_disks(29, 50): faila=3D 29(D)  failb=3D 50(D=
)  OK
[    7.194858] raid6test: test_disks(29, 51): faila=3D 29(D)  failb=3D 51(D=
)  OK
[    7.196063] raid6test: test_disks(29, 52): faila=3D 29(D)  failb=3D 52(D=
)  OK
[    7.197291] raid6test: test_disks(29, 53): faila=3D 29(D)  failb=3D 53(D=
)  OK
[    7.198511] raid6test: test_disks(29, 54): faila=3D 29(D)  failb=3D 54(D=
)  OK
[    7.199728] raid6test: test_disks(29, 55): faila=3D 29(D)  failb=3D 55(D=
)  OK
[    7.201005] raid6test: test_disks(29, 56): faila=3D 29(D)  failb=3D 56(D=
)  OK
[    7.202237] raid6test: test_disks(29, 57): faila=3D 29(D)  failb=3D 57(D=
)  OK
[    7.203481] raid6test: test_disks(29, 58): faila=3D 29(D)  failb=3D 58(D=
)  OK
[    7.204662] raid6test: test_disks(29, 59): faila=3D 29(D)  failb=3D 59(D=
)  OK
[    7.205952] raid6test: test_disks(29, 60): faila=3D 29(D)  failb=3D 60(D=
)  OK
[    7.207162] raid6test: test_disks(29, 61): faila=3D 29(D)  failb=3D 61(D=
)  OK
[    7.208325] raid6test: test_disks(29, 62): faila=3D 29(D)  failb=3D 62(P=
)  OK
[    7.209508] raid6test: test_disks(29, 63): faila=3D 29(D)  failb=3D 63(Q=
)  OK
[    7.210780] raid6test: test_disks(30, 31): faila=3D 30(D)  failb=3D 31(D=
)  OK
[    7.211973] raid6test: test_disks(30, 32): faila=3D 30(D)  failb=3D 32(D=
)  OK
[    7.213262] raid6test: test_disks(30, 33): faila=3D 30(D)  failb=3D 33(D=
)  OK
[    7.214494] raid6test: test_disks(30, 34): faila=3D 30(D)  failb=3D 34(D=
)  OK
[    7.215744] raid6test: test_disks(30, 35): faila=3D 30(D)  failb=3D 35(D=
)  OK
[    7.217007] raid6test: test_disks(30, 36): faila=3D 30(D)  failb=3D 36(D=
)  OK
[    7.218293] raid6test: test_disks(30, 37): faila=3D 30(D)  failb=3D 37(D=
)  OK
[    7.219488] raid6test: test_disks(30, 38): faila=3D 30(D)  failb=3D 38(D=
)  OK
[    7.220696] raid6test: test_disks(30, 39): faila=3D 30(D)  failb=3D 39(D=
)  OK
[    7.221844] raid6test: test_disks(30, 40): faila=3D 30(D)  failb=3D 40(D=
)  OK
[    7.223014] raid6test: test_disks(30, 41): faila=3D 30(D)  failb=3D 41(D=
)  OK
[    7.224272] raid6test: test_disks(30, 42): faila=3D 30(D)  failb=3D 42(D=
)  OK
[    7.225498] raid6test: test_disks(30, 43): faila=3D 30(D)  failb=3D 43(D=
)  OK
[    7.226686] raid6test: test_disks(30, 44): faila=3D 30(D)  failb=3D 44(D=
)  OK
[    7.227887] raid6test: test_disks(30, 45): faila=3D 30(D)  failb=3D 45(D=
)  OK
[    7.229138] raid6test: test_disks(30, 46): faila=3D 30(D)  failb=3D 46(D=
)  OK
[    7.230431] raid6test: test_disks(30, 47): faila=3D 30(D)  failb=3D 47(D=
)  OK
[    7.231661] raid6test: test_disks(30, 48): faila=3D 30(D)  failb=3D 48(D=
)  OK
[    7.232874] raid6test: test_disks(30, 49): faila=3D 30(D)  failb=3D 49(D=
)  OK
[    7.234096] raid6test: test_disks(30, 50): faila=3D 30(D)  failb=3D 50(D=
)  OK
[    7.235301] raid6test: test_disks(30, 51): faila=3D 30(D)  failb=3D 51(D=
)  OK
[    7.236485] raid6test: test_disks(30, 52): faila=3D 30(D)  failb=3D 52(D=
)  OK
[    7.237628] raid6test: test_disks(30, 53): faila=3D 30(D)  failb=3D 53(D=
)  OK
[    7.238813] raid6test: test_disks(30, 54): faila=3D 30(D)  failb=3D 54(D=
)  OK
[    7.239949] raid6test: test_disks(30, 55): faila=3D 30(D)  failb=3D 55(D=
)  OK
[    7.241120] raid6test: test_disks(30, 56): faila=3D 30(D)  failb=3D 56(D=
)  OK
[    7.242229] raid6test: test_disks(30, 57): faila=3D 30(D)  failb=3D 57(D=
)  OK
[    7.243366] raid6test: test_disks(30, 58): faila=3D 30(D)  failb=3D 58(D=
)  OK
[    7.244557] raid6test: test_disks(30, 59): faila=3D 30(D)  failb=3D 59(D=
)  OK
[    7.245699] raid6test: test_disks(30, 60): faila=3D 30(D)  failb=3D 60(D=
)  OK
[    7.246814] raid6test: test_disks(30, 61): faila=3D 30(D)  failb=3D 61(D=
)  OK
[    7.247895] raid6test: test_disks(30, 62): faila=3D 30(D)  failb=3D 62(P=
)  OK
[    7.248984] raid6test: test_disks(30, 63): faila=3D 30(D)  failb=3D 63(Q=
)  OK
[    7.250112] raid6test: test_disks(31, 32): faila=3D 31(D)  failb=3D 32(D=
)  OK
[    7.251292] raid6test: test_disks(31, 33): faila=3D 31(D)  failb=3D 33(D=
)  OK
[    7.252560] raid6test: test_disks(31, 34): faila=3D 31(D)  failb=3D 34(D=
)  OK
[    7.253817] raid6test: test_disks(31, 35): faila=3D 31(D)  failb=3D 35(D=
)  OK
[    7.255003] raid6test: test_disks(31, 36): faila=3D 31(D)  failb=3D 36(D=
)  OK
[    7.256186] raid6test: test_disks(31, 37): faila=3D 31(D)  failb=3D 37(D=
)  OK
[    7.257366] raid6test: test_disks(31, 38): faila=3D 31(D)  failb=3D 38(D=
)  OK
[    7.258518] raid6test: test_disks(31, 39): faila=3D 31(D)  failb=3D 39(D=
)  OK
[    7.259684] raid6test: test_disks(31, 40): faila=3D 31(D)  failb=3D 40(D=
)  OK
[    7.260905] raid6test: test_disks(31, 41): faila=3D 31(D)  failb=3D 41(D=
)  OK
[    7.262082] raid6test: test_disks(31, 42): faila=3D 31(D)  failb=3D 42(D=
)  OK
[    7.263228] raid6test: test_disks(31, 43): faila=3D 31(D)  failb=3D 43(D=
)  OK
[    7.264387] raid6test: test_disks(31, 44): faila=3D 31(D)  failb=3D 44(D=
)  OK
[    7.265552] raid6test: test_disks(31, 45): faila=3D 31(D)  failb=3D 45(D=
)  OK
[    7.266727] raid6test: test_disks(31, 46): faila=3D 31(D)  failb=3D 46(D=
)  OK
[    7.267873] raid6test: test_disks(31, 47): faila=3D 31(D)  failb=3D 47(D=
)  OK
[    7.270131] raid6test: test_disks(31, 48): faila=3D 31(D)  failb=3D 48(D=
)  OK
[    7.271313] raid6test: test_disks(31, 49): faila=3D 31(D)  failb=3D 49(D=
)  OK
[    7.272456] raid6test: test_disks(31, 50): faila=3D 31(D)  failb=3D 50(D=
)  OK
[    7.273635] raid6test: test_disks(31, 51): faila=3D 31(D)  failb=3D 51(D=
)  OK
[    7.274805] raid6test: test_disks(31, 52): faila=3D 31(D)  failb=3D 52(D=
)  OK
[    7.275971] raid6test: test_disks(31, 53): faila=3D 31(D)  failb=3D 53(D=
)  OK
[    7.277103] raid6test: test_disks(31, 54): faila=3D 31(D)  failb=3D 54(D=
)  OK
[    7.278285] raid6test: test_disks(31, 55): faila=3D 31(D)  failb=3D 55(D=
)  OK
[    7.279455] raid6test: test_disks(31, 56): faila=3D 31(D)  failb=3D 56(D=
)  OK
[    7.280688] raid6test: test_disks(31, 57): faila=3D 31(D)  failb=3D 57(D=
)  OK
[    7.281832] raid6test: test_disks(31, 58): faila=3D 31(D)  failb=3D 58(D=
)  OK
[    7.283010] raid6test: test_disks(31, 59): faila=3D 31(D)  failb=3D 59(D=
)  OK
[    7.284161] raid6test: test_disks(31, 60): faila=3D 31(D)  failb=3D 60(D=
)  OK
[    7.285315] raid6test: test_disks(31, 61): faila=3D 31(D)  failb=3D 61(D=
)  OK
[    7.286485] raid6test: test_disks(31, 62): faila=3D 31(D)  failb=3D 62(P=
)  OK
[    7.287608] raid6test: test_disks(31, 63): faila=3D 31(D)  failb=3D 63(Q=
)  OK
[    7.288795] raid6test: test_disks(32, 33): faila=3D 32(D)  failb=3D 33(D=
)  OK
[    7.289977] raid6test: test_disks(32, 34): faila=3D 32(D)  failb=3D 34(D=
)  OK
[    7.291170] raid6test: test_disks(32, 35): faila=3D 32(D)  failb=3D 35(D=
)  OK
[    7.292364] raid6test: test_disks(32, 36): faila=3D 32(D)  failb=3D 36(D=
)  OK
[    7.293499] raid6test: test_disks(32, 37): faila=3D 32(D)  failb=3D 37(D=
)  OK
[    7.294653] raid6test: test_disks(32, 38): faila=3D 32(D)  failb=3D 38(D=
)  OK
[    7.295843] raid6test: test_disks(32, 39): faila=3D 32(D)  failb=3D 39(D=
)  OK
[    7.297019] raid6test: test_disks(32, 40): faila=3D 32(D)  failb=3D 40(D=
)  OK
[    7.298185] raid6test: test_disks(32, 41): faila=3D 32(D)  failb=3D 41(D=
)  OK
[    7.299398] raid6test: test_disks(32, 42): faila=3D 32(D)  failb=3D 42(D=
)  OK
[    7.300554] raid6test: test_disks(32, 43): faila=3D 32(D)  failb=3D 43(D=
)  OK
[    7.301658] raid6test: test_disks(32, 44): faila=3D 32(D)  failb=3D 44(D=
)  OK
[    7.302764] raid6test: test_disks(32, 45): faila=3D 32(D)  failb=3D 45(D=
)  OK
[    7.303870] raid6test: test_disks(32, 46): faila=3D 32(D)  failb=3D 46(D=
)  OK
[    7.305004] raid6test: test_disks(32, 47): faila=3D 32(D)  failb=3D 47(D=
)  OK
[    7.306107] raid6test: test_disks(32, 48): faila=3D 32(D)  failb=3D 48(D=
)  OK
[    7.307230] raid6test: test_disks(32, 49): faila=3D 32(D)  failb=3D 49(D=
)  OK
[    7.308411] raid6test: test_disks(32, 50): faila=3D 32(D)  failb=3D 50(D=
)  OK
[    7.309611] raid6test: test_disks(32, 51): faila=3D 32(D)  failb=3D 51(D=
)  OK
[    7.310829] raid6test: test_disks(32, 52): faila=3D 32(D)  failb=3D 52(D=
)  OK
[    7.311999] raid6test: test_disks(32, 53): faila=3D 32(D)  failb=3D 53(D=
)  OK
[    7.313215] raid6test: test_disks(32, 54): faila=3D 32(D)  failb=3D 54(D=
)  OK
[    7.314277] raid6test: test_disks(32, 55): faila=3D 32(D)  failb=3D 55(D=
)  OK
[    7.315023] raid6test: test_disks(32, 56): faila=3D 32(D)  failb=3D 56(D=
)  OK
[    7.315779] raid6test: test_disks(32, 57): faila=3D 32(D)  failb=3D 57(D=
)  OK
[    7.316534] raid6test: test_disks(32, 58): faila=3D 32(D)  failb=3D 58(D=
)  OK
[    7.317287] raid6test: test_disks(32, 59): faila=3D 32(D)  failb=3D 59(D=
)  OK
[    7.318028] raid6test: test_disks(32, 60): faila=3D 32(D)  failb=3D 60(D=
)  OK
[    7.319118] raid6test: test_disks(32, 61): faila=3D 32(D)  failb=3D 61(D=
)  OK
[    7.320410] raid6test: test_disks(32, 62): faila=3D 32(D)  failb=3D 62(P=
)  OK
[    7.321515] raid6test: test_disks(32, 63): faila=3D 32(D)  failb=3D 63(Q=
)  OK
[    7.322675] raid6test: test_disks(33, 34): faila=3D 33(D)  failb=3D 34(D=
)  OK
[    7.323955] raid6test: test_disks(33, 35): faila=3D 33(D)  failb=3D 35(D=
)  OK
[    7.325246] raid6test: test_disks(33, 36): faila=3D 33(D)  failb=3D 36(D=
)  OK
[    7.326395] raid6test: test_disks(33, 37): faila=3D 33(D)  failb=3D 37(D=
)  OK
[    7.327497] raid6test: test_disks(33, 38): faila=3D 33(D)  failb=3D 38(D=
)  OK
[    7.328615] raid6test: test_disks(33, 39): faila=3D 33(D)  failb=3D 39(D=
)  OK
[    7.329842] raid6test: test_disks(33, 40): faila=3D 33(D)  failb=3D 40(D=
)  OK
[    7.331146] raid6test: test_disks(33, 41): faila=3D 33(D)  failb=3D 41(D=
)  OK
[    7.332417] raid6test: test_disks(33, 42): faila=3D 33(D)  failb=3D 42(D=
)  OK
[    7.333709] raid6test: test_disks(33, 43): faila=3D 33(D)  failb=3D 43(D=
)  OK
[    7.334990] raid6test: test_disks(33, 44): faila=3D 33(D)  failb=3D 44(D=
)  OK
[    7.336271] raid6test: test_disks(33, 45): faila=3D 33(D)  failb=3D 45(D=
)  OK
[    7.337541] raid6test: test_disks(33, 46): faila=3D 33(D)  failb=3D 46(D=
)  OK
[    7.338814] raid6test: test_disks(33, 47): faila=3D 33(D)  failb=3D 47(D=
)  OK
[    7.340158] raid6test: test_disks(33, 48): faila=3D 33(D)  failb=3D 48(D=
)  OK
[    7.341408] raid6test: test_disks(33, 49): faila=3D 33(D)  failb=3D 49(D=
)  OK
[    7.342668] raid6test: test_disks(33, 50): faila=3D 33(D)  failb=3D 50(D=
)  OK
[    7.343922] raid6test: test_disks(33, 51): faila=3D 33(D)  failb=3D 51(D=
)  OK
[    7.345225] raid6test: test_disks(33, 52): faila=3D 33(D)  failb=3D 52(D=
)  OK
[    7.346489] raid6test: test_disks(33, 53): faila=3D 33(D)  failb=3D 53(D=
)  OK
[    7.347736] raid6test: test_disks(33, 54): faila=3D 33(D)  failb=3D 54(D=
)  OK
[    7.349005] raid6test: test_disks(33, 55): faila=3D 33(D)  failb=3D 55(D=
)  OK
[    7.350293] raid6test: test_disks(33, 56): faila=3D 33(D)  failb=3D 56(D=
)  OK
[    7.351548] raid6test: test_disks(33, 57): faila=3D 33(D)  failb=3D 57(D=
)  OK
[    7.352819] raid6test: test_disks(33, 58): faila=3D 33(D)  failb=3D 58(D=
)  OK
[    7.354078] raid6test: test_disks(33, 59): faila=3D 33(D)  failb=3D 59(D=
)  OK
[    7.355358] raid6test: test_disks(33, 60): faila=3D 33(D)  failb=3D 60(D=
)  OK
[    7.356625] raid6test: test_disks(33, 61): faila=3D 33(D)  failb=3D 61(D=
)  OK
[    7.357872] raid6test: test_disks(33, 62): faila=3D 33(D)  failb=3D 62(P=
)  OK
[    7.359122] raid6test: test_disks(33, 63): faila=3D 33(D)  failb=3D 63(Q=
)  OK
[    7.360489] raid6test: test_disks(34, 35): faila=3D 34(D)  failb=3D 35(D=
)  OK
[    7.361623] raid6test: test_disks(34, 36): faila=3D 34(D)  failb=3D 36(D=
)  OK
[    7.362904] raid6test: test_disks(34, 37): faila=3D 34(D)  failb=3D 37(D=
)  OK
[    7.364185] raid6test: test_disks(34, 38): faila=3D 34(D)  failb=3D 38(D=
)  OK
[    7.365455] raid6test: test_disks(34, 39): faila=3D 34(D)  failb=3D 39(D=
)  OK
[    7.366711] raid6test: test_disks(34, 40): faila=3D 34(D)  failb=3D 40(D=
)  OK
[    7.367975] raid6test: test_disks(34, 41): faila=3D 34(D)  failb=3D 41(D=
)  OK
[    7.368898] raid6test: test_disks(34, 42): faila=3D 34(D)  failb=3D 42(D=
)  OK
[    7.369664] raid6test: test_disks(34, 43): faila=3D 34(D)  failb=3D 43(D=
)  OK
[    7.370464] raid6test: test_disks(34, 44): faila=3D 34(D)  failb=3D 44(D=
)  OK
[    7.371214] raid6test: test_disks(34, 45): faila=3D 34(D)  failb=3D 45(D=
)  OK
[    7.371973] raid6test: test_disks(34, 46): faila=3D 34(D)  failb=3D 46(D=
)  OK
[    7.372738] raid6test: test_disks(34, 47): faila=3D 34(D)  failb=3D 47(D=
)  OK
[    7.373500] raid6test: test_disks(34, 48): faila=3D 34(D)  failb=3D 48(D=
)  OK
[    7.374255] raid6test: test_disks(34, 49): faila=3D 34(D)  failb=3D 49(D=
)  OK
[    7.375008] raid6test: test_disks(34, 50): faila=3D 34(D)  failb=3D 50(D=
)  OK
[    7.375767] raid6test: test_disks(34, 51): faila=3D 34(D)  failb=3D 51(D=
)  OK
[    7.376525] raid6test: test_disks(34, 52): faila=3D 34(D)  failb=3D 52(D=
)  OK
[    7.377285] raid6test: test_disks(34, 53): faila=3D 34(D)  failb=3D 53(D=
)  OK
[    7.378034] raid6test: test_disks(34, 54): faila=3D 34(D)  failb=3D 54(D=
)  OK
[    7.378823] raid6test: test_disks(34, 55): faila=3D 34(D)  failb=3D 55(D=
)  OK
[    7.379585] raid6test: test_disks(34, 56): faila=3D 34(D)  failb=3D 56(D=
)  OK
[    7.380384] raid6test: test_disks(34, 57): faila=3D 34(D)  failb=3D 57(D=
)  OK
[    7.381136] raid6test: test_disks(34, 58): faila=3D 34(D)  failb=3D 58(D=
)  OK
[    7.381900] raid6test: test_disks(34, 59): faila=3D 34(D)  failb=3D 59(D=
)  OK
[    7.382946] raid6test: test_disks(34, 60): faila=3D 34(D)  failb=3D 60(D=
)  OK
[    7.384162] raid6test: test_disks(34, 61): faila=3D 34(D)  failb=3D 61(D=
)  OK
[    7.385375] raid6test: test_disks(34, 62): faila=3D 34(D)  failb=3D 62(P=
)  OK
[    7.386576] raid6test: test_disks(34, 63): faila=3D 34(D)  failb=3D 63(Q=
)  OK
[    7.387817] raid6test: test_disks(35, 36): faila=3D 35(D)  failb=3D 36(D=
)  OK
[    7.389075] raid6test: test_disks(35, 37): faila=3D 35(D)  failb=3D 37(D=
)  OK
[    7.390386] raid6test: test_disks(35, 38): faila=3D 35(D)  failb=3D 38(D=
)  OK
[    7.391660] raid6test: test_disks(35, 39): faila=3D 35(D)  failb=3D 39(D=
)  OK
[    7.392916] raid6test: test_disks(35, 40): faila=3D 35(D)  failb=3D 40(D=
)  OK
[    7.394163] raid6test: test_disks(35, 41): faila=3D 35(D)  failb=3D 41(D=
)  OK
[    7.395434] raid6test: test_disks(35, 42): faila=3D 35(D)  failb=3D 42(D=
)  OK
[    7.396655] raid6test: test_disks(35, 43): faila=3D 35(D)  failb=3D 43(D=
)  OK
[    7.397901] raid6test: test_disks(35, 44): faila=3D 35(D)  failb=3D 44(D=
)  OK
[    7.399121] raid6test: test_disks(35, 45): faila=3D 35(D)  failb=3D 45(D=
)  OK
[    7.400400] raid6test: test_disks(35, 46): faila=3D 35(D)  failb=3D 46(D=
)  OK
[    7.401626] raid6test: test_disks(35, 47): faila=3D 35(D)  failb=3D 47(D=
)  OK
[    7.402871] raid6test: test_disks(35, 48): faila=3D 35(D)  failb=3D 48(D=
)  OK
[    7.404080] raid6test: test_disks(35, 49): faila=3D 35(D)  failb=3D 49(D=
)  OK
[    7.405341] raid6test: test_disks(35, 50): faila=3D 35(D)  failb=3D 50(D=
)  OK
[    7.406600] raid6test: test_disks(35, 51): faila=3D 35(D)  failb=3D 51(D=
)  OK
[    7.407851] raid6test: test_disks(35, 52): faila=3D 35(D)  failb=3D 52(D=
)  OK
[    7.409100] raid6test: test_disks(35, 53): faila=3D 35(D)  failb=3D 53(D=
)  OK
[    7.410431] raid6test: test_disks(35, 54): faila=3D 35(D)  failb=3D 54(D=
)  OK
[    7.411654] raid6test: test_disks(35, 55): faila=3D 35(D)  failb=3D 55(D=
)  OK
[    7.412917] raid6test: test_disks(35, 56): faila=3D 35(D)  failb=3D 56(D=
)  OK
[    7.414123] raid6test: test_disks(35, 57): faila=3D 35(D)  failb=3D 57(D=
)  OK
[    7.415368] raid6test: test_disks(35, 58): faila=3D 35(D)  failb=3D 58(D=
)  OK
[    7.416570] raid6test: test_disks(35, 59): faila=3D 35(D)  failb=3D 59(D=
)  OK
[    7.417832] raid6test: test_disks(35, 60): faila=3D 35(D)  failb=3D 60(D=
)  OK
[    7.419107] raid6test: test_disks(35, 61): faila=3D 35(D)  failb=3D 61(D=
)  OK
[    7.420420] raid6test: test_disks(35, 62): faila=3D 35(D)  failb=3D 62(P=
)  OK
[    7.421688] raid6test: test_disks(35, 63): faila=3D 35(D)  failb=3D 63(Q=
)  OK
[    7.422955] raid6test: test_disks(36, 37): faila=3D 36(D)  failb=3D 37(D=
)  OK
[    7.424262] raid6test: test_disks(36, 38): faila=3D 36(D)  failb=3D 38(D=
)  OK
[    7.425503] raid6test: test_disks(36, 39): faila=3D 36(D)  failb=3D 39(D=
)  OK
[    7.426706] raid6test: test_disks(36, 40): faila=3D 36(D)  failb=3D 40(D=
)  OK
[    7.427915] raid6test: test_disks(36, 41): faila=3D 36(D)  failb=3D 41(D=
)  OK
[    7.429192] raid6test: test_disks(36, 42): faila=3D 36(D)  failb=3D 42(D=
)  OK
[    7.430509] raid6test: test_disks(36, 43): faila=3D 36(D)  failb=3D 43(D=
)  OK
[    7.431776] raid6test: test_disks(36, 44): faila=3D 36(D)  failb=3D 44(D=
)  OK
[    7.432978] raid6test: test_disks(36, 45): faila=3D 36(D)  failb=3D 45(D=
)  OK
[    7.434202] raid6test: test_disks(36, 46): faila=3D 36(D)  failb=3D 46(D=
)  OK
[    7.435445] raid6test: test_disks(36, 47): faila=3D 36(D)  failb=3D 47(D=
)  OK
[    7.436667] raid6test: test_disks(36, 48): faila=3D 36(D)  failb=3D 48(D=
)  OK
[    7.437877] raid6test: test_disks(36, 49): faila=3D 36(D)  failb=3D 49(D=
)  OK
[    7.439083] raid6test: test_disks(36, 50): faila=3D 36(D)  failb=3D 50(D=
)  OK
[    7.440383] raid6test: test_disks(36, 51): faila=3D 36(D)  failb=3D 51(D=
)  OK
[    7.441576] raid6test: test_disks(36, 52): faila=3D 36(D)  failb=3D 52(D=
)  OK
[    7.442795] raid6test: test_disks(36, 53): faila=3D 36(D)  failb=3D 53(D=
)  OK
[    7.444017] raid6test: test_disks(36, 54): faila=3D 36(D)  failb=3D 54(D=
)  OK
[    7.445251] raid6test: test_disks(36, 55): faila=3D 36(D)  failb=3D 55(D=
)  OK
[    7.446458] raid6test: test_disks(36, 56): faila=3D 36(D)  failb=3D 56(D=
)  OK
[    7.447656] raid6test: test_disks(36, 57): faila=3D 36(D)  failb=3D 57(D=
)  OK
[    7.448915] raid6test: test_disks(36, 58): faila=3D 36(D)  failb=3D 58(D=
)  OK
[    7.450159] raid6test: test_disks(36, 59): faila=3D 36(D)  failb=3D 59(D=
)  OK
[    7.451401] raid6test: test_disks(36, 60): faila=3D 36(D)  failb=3D 60(D=
)  OK
[    7.452642] raid6test: test_disks(36, 61): faila=3D 36(D)  failb=3D 61(D=
)  OK
[    7.453831] raid6test: test_disks(36, 62): faila=3D 36(D)  failb=3D 62(P=
)  OK
[    7.455017] raid6test: test_disks(36, 63): faila=3D 36(D)  failb=3D 63(Q=
)  OK
[    7.456248] raid6test: test_disks(37, 38): faila=3D 37(D)  failb=3D 38(D=
)  OK
[    7.457474] raid6test: test_disks(37, 39): faila=3D 37(D)  failb=3D 39(D=
)  OK
[    7.458667] raid6test: test_disks(37, 40): faila=3D 37(D)  failb=3D 40(D=
)  OK
[    7.459900] raid6test: test_disks(37, 41): faila=3D 37(D)  failb=3D 41(D=
)  OK
[    7.461162] raid6test: test_disks(37, 42): faila=3D 37(D)  failb=3D 42(D=
)  OK
[    7.462380] raid6test: test_disks(37, 43): faila=3D 37(D)  failb=3D 43(D=
)  OK
[    7.463610] raid6test: test_disks(37, 44): faila=3D 37(D)  failb=3D 44(D=
)  OK
[    7.464814] raid6test: test_disks(37, 45): faila=3D 37(D)  failb=3D 45(D=
)  OK
[    7.466032] raid6test: test_disks(37, 46): faila=3D 37(D)  failb=3D 46(D=
)  OK
[    7.467260] raid6test: test_disks(37, 47): faila=3D 37(D)  failb=3D 47(D=
)  OK
[    7.468480] raid6test: test_disks(37, 48): faila=3D 37(D)  failb=3D 48(D=
)  OK
[    7.469695] raid6test: test_disks(37, 49): faila=3D 37(D)  failb=3D 49(D=
)  OK
[    7.470984] raid6test: test_disks(37, 50): faila=3D 37(D)  failb=3D 50(D=
)  OK
[    7.472232] raid6test: test_disks(37, 51): faila=3D 37(D)  failb=3D 51(D=
)  OK
[    7.473453] raid6test: test_disks(37, 52): faila=3D 37(D)  failb=3D 52(D=
)  OK
[    7.474687] raid6test: test_disks(37, 53): faila=3D 37(D)  failb=3D 53(D=
)  OK
[    7.475879] raid6test: test_disks(37, 54): faila=3D 37(D)  failb=3D 54(D=
)  OK
[    7.477105] raid6test: test_disks(37, 55): faila=3D 37(D)  failb=3D 55(D=
)  OK
[    7.478347] raid6test: test_disks(37, 56): faila=3D 37(D)  failb=3D 56(D=
)  OK
[    7.479570] raid6test: test_disks(37, 57): faila=3D 37(D)  failb=3D 57(D=
)  OK
[    7.480817] raid6test: test_disks(37, 58): faila=3D 37(D)  failb=3D 58(D=
)  OK
[    7.482020] raid6test: test_disks(37, 59): faila=3D 37(D)  failb=3D 59(D=
)  OK
[    7.483230] raid6test: test_disks(37, 60): faila=3D 37(D)  failb=3D 60(D=
)  OK
[    7.484438] raid6test: test_disks(37, 61): faila=3D 37(D)  failb=3D 61(D=
)  OK
[    7.485647] raid6test: test_disks(37, 62): faila=3D 37(D)  failb=3D 62(P=
)  OK
[    7.486836] raid6test: test_disks(37, 63): faila=3D 37(D)  failb=3D 63(Q=
)  OK
[    7.488042] raid6test: test_disks(38, 39): faila=3D 38(D)  failb=3D 39(D=
)  OK
[    7.489279] raid6test: test_disks(38, 40): faila=3D 38(D)  failb=3D 40(D=
)  OK
[    7.490537] raid6test: test_disks(38, 41): faila=3D 38(D)  failb=3D 41(D=
)  OK
[    7.491769] raid6test: test_disks(38, 42): faila=3D 38(D)  failb=3D 42(D=
)  OK
[    7.493059] raid6test: test_disks(38, 43): faila=3D 38(D)  failb=3D 43(D=
)  OK
[    7.494246] raid6test: test_disks(38, 44): faila=3D 38(D)  failb=3D 44(D=
)  OK
[    7.495477] raid6test: test_disks(38, 45): faila=3D 38(D)  failb=3D 45(D=
)  OK
[    7.496711] raid6test: test_disks(38, 46): faila=3D 38(D)  failb=3D 46(D=
)  OK
[    7.497981] raid6test: test_disks(38, 47): faila=3D 38(D)  failb=3D 47(D=
)  OK
[    7.499237] raid6test: test_disks(38, 48): faila=3D 38(D)  failb=3D 48(D=
)  OK
[    7.500454] raid6test: test_disks(38, 49): faila=3D 38(D)  failb=3D 49(D=
)  OK
[    7.501686] raid6test: test_disks(38, 50): faila=3D 38(D)  failb=3D 50(D=
)  OK
[    7.502920] raid6test: test_disks(38, 51): faila=3D 38(D)  failb=3D 51(D=
)  OK
[    7.504136] raid6test: test_disks(38, 52): faila=3D 38(D)  failb=3D 52(D=
)  OK
[    7.505355] raid6test: test_disks(38, 53): faila=3D 38(D)  failb=3D 53(D=
)  OK
[    7.506575] raid6test: test_disks(38, 54): faila=3D 38(D)  failb=3D 54(D=
)  OK
[    7.507819] raid6test: test_disks(38, 55): faila=3D 38(D)  failb=3D 55(D=
)  OK
[    7.509038] raid6test: test_disks(38, 56): faila=3D 38(D)  failb=3D 56(D=
)  OK
[    7.510343] raid6test: test_disks(38, 57): faila=3D 38(D)  failb=3D 57(D=
)  OK
[    7.511609] raid6test: test_disks(38, 58): faila=3D 38(D)  failb=3D 58(D=
)  OK
[    7.512793] raid6test: test_disks(38, 59): faila=3D 38(D)  failb=3D 59(D=
)  OK
[    7.514019] raid6test: test_disks(38, 60): faila=3D 38(D)  failb=3D 60(D=
)  OK
[    7.515251] raid6test: test_disks(38, 61): faila=3D 38(D)  failb=3D 61(D=
)  OK
[    7.516410] raid6test: test_disks(38, 62): faila=3D 38(D)  failb=3D 62(P=
)  OK
[    7.517686] raid6test: test_disks(38, 63): faila=3D 38(D)  failb=3D 63(Q=
)  OK
[    7.518899] raid6test: test_disks(39, 40): faila=3D 39(D)  failb=3D 40(D=
)  OK
[    7.520071] raid6test: test_disks(39, 41): faila=3D 39(D)  failb=3D 41(D=
)  OK
[    7.521182] raid6test: test_disks(39, 42): faila=3D 39(D)  failb=3D 42(D=
)  OK
[    7.522290] raid6test: test_disks(39, 43): faila=3D 39(D)  failb=3D 43(D=
)  OK
[    7.523564] raid6test: test_disks(39, 44): faila=3D 39(D)  failb=3D 44(D=
)  OK
[    7.524667] raid6test: test_disks(39, 45): faila=3D 39(D)  failb=3D 45(D=
)  OK
[    7.525857] raid6test: test_disks(39, 46): faila=3D 39(D)  failb=3D 46(D=
)  OK
[    7.527020] raid6test: test_disks(39, 47): faila=3D 39(D)  failb=3D 47(D=
)  OK
[    7.528149] raid6test: test_disks(39, 48): faila=3D 39(D)  failb=3D 48(D=
)  OK
[    7.529273] raid6test: test_disks(39, 49): faila=3D 39(D)  failb=3D 49(D=
)  OK
[    7.530437] raid6test: test_disks(39, 50): faila=3D 39(D)  failb=3D 50(D=
)  OK
[    7.531648] raid6test: test_disks(39, 51): faila=3D 39(D)  failb=3D 51(D=
)  OK
[    7.532926] raid6test: test_disks(39, 52): faila=3D 39(D)  failb=3D 52(D=
)  OK
[    7.534152] raid6test: test_disks(39, 53): faila=3D 39(D)  failb=3D 53(D=
)  OK
[    7.535330] raid6test: test_disks(39, 54): faila=3D 39(D)  failb=3D 54(D=
)  OK
[    7.536509] raid6test: test_disks(39, 55): faila=3D 39(D)  failb=3D 55(D=
)  OK
[    7.537682] raid6test: test_disks(39, 56): faila=3D 39(D)  failb=3D 56(D=
)  OK
[    7.538839] raid6test: test_disks(39, 57): faila=3D 39(D)  failb=3D 57(D=
)  OK
[    7.540071] raid6test: test_disks(39, 58): faila=3D 39(D)  failb=3D 58(D=
)  OK
[    7.541208] raid6test: test_disks(39, 59): faila=3D 39(D)  failb=3D 59(D=
)  OK
[    7.542386] raid6test: test_disks(39, 60): faila=3D 39(D)  failb=3D 60(D=
)  OK
[    7.543536] raid6test: test_disks(39, 61): faila=3D 39(D)  failb=3D 61(D=
)  OK
[    7.544683] raid6test: test_disks(39, 62): faila=3D 39(D)  failb=3D 62(P=
)  OK
[    7.545801] raid6test: test_disks(39, 63): faila=3D 39(D)  failb=3D 63(Q=
)  OK
[    7.546982] raid6test: test_disks(40, 41): faila=3D 40(D)  failb=3D 41(D=
)  OK
[    7.548122] raid6test: test_disks(40, 42): faila=3D 40(D)  failb=3D 42(D=
)  OK
[    7.549315] raid6test: test_disks(40, 43): faila=3D 40(D)  failb=3D 43(D=
)  OK
[    7.550502] raid6test: test_disks(40, 44): faila=3D 40(D)  failb=3D 44(D=
)  OK
[    7.551677] raid6test: test_disks(40, 45): faila=3D 40(D)  failb=3D 45(D=
)  OK
[    7.552826] raid6test: test_disks(40, 46): faila=3D 40(D)  failb=3D 46(D=
)  OK
[    7.554002] raid6test: test_disks(40, 47): faila=3D 40(D)  failb=3D 47(D=
)  OK
[    7.555143] raid6test: test_disks(40, 48): faila=3D 40(D)  failb=3D 48(D=
)  OK
[    7.556299] raid6test: test_disks(40, 49): faila=3D 40(D)  failb=3D 49(D=
)  OK
[    7.557466] raid6test: test_disks(40, 50): faila=3D 40(D)  failb=3D 50(D=
)  OK
[    7.558632] raid6test: test_disks(40, 51): faila=3D 40(D)  failb=3D 51(D=
)  OK
[    7.559802] raid6test: test_disks(40, 52): faila=3D 40(D)  failb=3D 52(D=
)  OK
[    7.560992] raid6test: test_disks(40, 53): faila=3D 40(D)  failb=3D 53(D=
)  OK
[    7.562157] raid6test: test_disks(40, 54): faila=3D 40(D)  failb=3D 54(D=
)  OK
[    7.563308] raid6test: test_disks(40, 55): faila=3D 40(D)  failb=3D 55(D=
)  OK
[    7.564493] raid6test: test_disks(40, 56): faila=3D 40(D)  failb=3D 56(D=
)  OK
[    7.565669] raid6test: test_disks(40, 57): faila=3D 40(D)  failb=3D 57(D=
)  OK
[    7.566840] raid6test: test_disks(40, 58): faila=3D 40(D)  failb=3D 58(D=
)  OK
[    7.568004] raid6test: test_disks(40, 59): faila=3D 40(D)  failb=3D 59(D=
)  OK
[    7.569161] raid6test: test_disks(40, 60): faila=3D 40(D)  failb=3D 60(D=
)  OK
[    7.570366] raid6test: test_disks(40, 61): faila=3D 40(D)  failb=3D 61(D=
)  OK
[    7.571528] raid6test: test_disks(40, 62): faila=3D 40(D)  failb=3D 62(P=
)  OK
[    7.572648] raid6test: test_disks(40, 63): faila=3D 40(D)  failb=3D 63(Q=
)  OK
[    7.573774] raid6test: test_disks(41, 42): faila=3D 41(D)  failb=3D 42(D=
)  OK
[    7.574936] raid6test: test_disks(41, 43): faila=3D 41(D)  failb=3D 43(D=
)  OK
[    7.576037] raid6test: test_disks(41, 44): faila=3D 41(D)  failb=3D 44(D=
)  OK
[    7.577135] raid6test: test_disks(41, 45): faila=3D 41(D)  failb=3D 45(D=
)  OK
[    7.578350] raid6test: test_disks(41, 46): faila=3D 41(D)  failb=3D 46(D=
)  OK
[    7.579537] raid6test: test_disks(41, 47): faila=3D 41(D)  failb=3D 47(D=
)  OK
[    7.580761] raid6test: test_disks(41, 48): faila=3D 41(D)  failb=3D 48(D=
)  OK
[    7.581935] raid6test: test_disks(41, 49): faila=3D 41(D)  failb=3D 49(D=
)  OK
[    7.583072] raid6test: test_disks(41, 50): faila=3D 41(D)  failb=3D 50(D=
)  OK
[    7.584175] raid6test: test_disks(41, 51): faila=3D 41(D)  failb=3D 51(D=
)  OK
[    7.585327] raid6test: test_disks(41, 52): faila=3D 41(D)  failb=3D 52(D=
)  OK
[    7.586386] raid6test: test_disks(41, 53): faila=3D 41(D)  failb=3D 53(D=
)  OK
[    7.587571] raid6test: test_disks(41, 54): faila=3D 41(D)  failb=3D 54(D=
)  OK
[    7.588746] raid6test: test_disks(41, 55): faila=3D 41(D)  failb=3D 55(D=
)  OK
[    7.589886] raid6test: test_disks(41, 56): faila=3D 41(D)  failb=3D 56(D=
)  OK
[    7.591136] raid6test: test_disks(41, 57): faila=3D 41(D)  failb=3D 57(D=
)  OK
[    7.592320] raid6test: test_disks(41, 58): faila=3D 41(D)  failb=3D 58(D=
)  OK
[    7.593486] raid6test: test_disks(41, 59): faila=3D 41(D)  failb=3D 59(D=
)  OK
[    7.594704] raid6test: test_disks(41, 60): faila=3D 41(D)  failb=3D 60(D=
)  OK
[    7.595916] raid6test: test_disks(41, 61): faila=3D 41(D)  failb=3D 61(D=
)  OK
[    7.596815] raid6test: test_disks(41, 62): faila=3D 41(D)  failb=3D 62(P=
)  OK
[    7.597567] raid6test: test_disks(41, 63): faila=3D 41(D)  failb=3D 63(Q=
)  OK
[    7.598350] raid6test: test_disks(42, 43): faila=3D 42(D)  failb=3D 43(D=
)  OK
[    7.599102] raid6test: test_disks(42, 44): faila=3D 42(D)  failb=3D 44(D=
)  OK
[    7.599865] raid6test: test_disks(42, 45): faila=3D 42(D)  failb=3D 45(D=
)  OK
[    7.600699] raid6test: test_disks(42, 46): faila=3D 42(D)  failb=3D 46(D=
)  OK
[    7.601467] raid6test: test_disks(42, 47): faila=3D 42(D)  failb=3D 47(D=
)  OK
[    7.602223] raid6test: test_disks(42, 48): faila=3D 42(D)  failb=3D 48(D=
)  OK
[    7.602972] raid6test: test_disks(42, 49): faila=3D 42(D)  failb=3D 49(D=
)  OK
[    7.603748] raid6test: test_disks(42, 50): faila=3D 42(D)  failb=3D 50(D=
)  OK
[    7.604508] raid6test: test_disks(42, 51): faila=3D 42(D)  failb=3D 51(D=
)  OK
[    7.605265] raid6test: test_disks(42, 52): faila=3D 42(D)  failb=3D 52(D=
)  OK
[    7.606011] raid6test: test_disks(42, 53): faila=3D 42(D)  failb=3D 53(D=
)  OK
[    7.606788] raid6test: test_disks(42, 54): faila=3D 42(D)  failb=3D 54(D=
)  OK
[    7.607561] raid6test: test_disks(42, 55): faila=3D 42(D)  failb=3D 55(D=
)  OK
[    7.608348] raid6test: test_disks(42, 56): faila=3D 42(D)  failb=3D 56(D=
)  OK
[    7.609105] raid6test: test_disks(42, 57): faila=3D 42(D)  failb=3D 57(D=
)  OK
[    7.609883] raid6test: test_disks(42, 58): faila=3D 42(D)  failb=3D 58(D=
)  OK
[    7.610682] raid6test: test_disks(42, 59): faila=3D 42(D)  failb=3D 59(D=
)  OK
[    7.611437] raid6test: test_disks(42, 60): faila=3D 42(D)  failb=3D 60(D=
)  OK
[    7.612185] raid6test: test_disks(42, 61): faila=3D 42(D)  failb=3D 61(D=
)  OK
[    7.612966] raid6test: test_disks(42, 62): faila=3D 42(D)  failb=3D 62(P=
)  OK
[    7.613719] raid6test: test_disks(42, 63): faila=3D 42(D)  failb=3D 63(Q=
)  OK
[    7.614577] raid6test: test_disks(43, 44): faila=3D 43(D)  failb=3D 44(D=
)  OK
[    7.615360] raid6test: test_disks(43, 45): faila=3D 43(D)  failb=3D 45(D=
)  OK
[    7.616109] raid6test: test_disks(43, 46): faila=3D 43(D)  failb=3D 46(D=
)  OK
[    7.616866] raid6test: test_disks(43, 47): faila=3D 43(D)  failb=3D 47(D=
)  OK
[    7.617645] raid6test: test_disks(43, 48): faila=3D 43(D)  failb=3D 48(D=
)  OK
[    7.618431] raid6test: test_disks(43, 49): faila=3D 43(D)  failb=3D 49(D=
)  OK
[    7.619175] raid6test: test_disks(43, 50): faila=3D 43(D)  failb=3D 50(D=
)  OK
[    7.619936] raid6test: test_disks(43, 51): faila=3D 43(D)  failb=3D 51(D=
)  OK
[    7.620744] raid6test: test_disks(43, 52): faila=3D 43(D)  failb=3D 52(D=
)  OK
[    7.621507] raid6test: test_disks(43, 53): faila=3D 43(D)  failb=3D 53(D=
)  OK
[    7.622264] raid6test: test_disks(43, 54): faila=3D 43(D)  failb=3D 54(D=
)  OK
[    7.623014] raid6test: test_disks(43, 55): faila=3D 43(D)  failb=3D 55(D=
)  OK
[    7.623776] raid6test: test_disks(43, 56): faila=3D 43(D)  failb=3D 56(D=
)  OK
[    7.624532] raid6test: test_disks(43, 57): faila=3D 43(D)  failb=3D 57(D=
)  OK
[    7.625289] raid6test: test_disks(43, 58): faila=3D 43(D)  failb=3D 58(D=
)  OK
[    7.626039] raid6test: test_disks(43, 59): faila=3D 43(D)  failb=3D 59(D=
)  OK
[    7.626793] raid6test: test_disks(43, 60): faila=3D 43(D)  failb=3D 60(D=
)  OK
[    7.627553] raid6test: test_disks(43, 61): faila=3D 43(D)  failb=3D 61(D=
)  OK
[    7.628321] raid6test: test_disks(43, 62): faila=3D 43(D)  failb=3D 62(P=
)  OK
[    7.629063] raid6test: test_disks(43, 63): faila=3D 43(D)  failb=3D 63(Q=
)  OK
[    7.629831] raid6test: test_disks(44, 45): faila=3D 44(D)  failb=3D 45(D=
)  OK
[    7.630622] raid6test: test_disks(44, 46): faila=3D 44(D)  failb=3D 46(D=
)  OK
[    7.631381] raid6test: test_disks(44, 47): faila=3D 44(D)  failb=3D 47(D=
)  OK
[    7.632130] raid6test: test_disks(44, 48): faila=3D 44(D)  failb=3D 48(D=
)  OK
[    7.632886] raid6test: test_disks(44, 49): faila=3D 44(D)  failb=3D 49(D=
)  OK
[    7.633652] raid6test: test_disks(44, 50): faila=3D 44(D)  failb=3D 50(D=
)  OK
[    7.634406] raid6test: test_disks(44, 51): faila=3D 44(D)  failb=3D 51(D=
)  OK
[    7.635154] raid6test: test_disks(44, 52): faila=3D 44(D)  failb=3D 52(D=
)  OK
[    7.635915] raid6test: test_disks(44, 53): faila=3D 44(D)  failb=3D 53(D=
)  OK
[    7.636671] raid6test: test_disks(44, 54): faila=3D 44(D)  failb=3D 54(D=
)  OK
[    7.637435] raid6test: test_disks(44, 55): faila=3D 44(D)  failb=3D 55(D=
)  OK
[    7.638184] raid6test: test_disks(44, 56): faila=3D 44(D)  failb=3D 56(D=
)  OK
[    7.638948] raid6test: test_disks(44, 57): faila=3D 44(D)  failb=3D 57(D=
)  OK
[    7.639712] raid6test: test_disks(44, 58): faila=3D 44(D)  failb=3D 58(D=
)  OK
[    7.640504] raid6test: test_disks(44, 59): faila=3D 44(D)  failb=3D 59(D=
)  OK
[    7.641265] raid6test: test_disks(44, 60): faila=3D 44(D)  failb=3D 60(D=
)  OK
[    7.642013] raid6test: test_disks(44, 61): faila=3D 44(D)  failb=3D 61(D=
)  OK
[    7.642765] raid6test: test_disks(44, 62): faila=3D 44(D)  failb=3D 62(P=
)  OK
[    7.643522] raid6test: test_disks(44, 63): faila=3D 44(D)  failb=3D 63(Q=
)  OK
[    7.644278] raid6test: test_disks(45, 46): faila=3D 45(D)  failb=3D 46(D=
)  OK
[    7.645028] raid6test: test_disks(45, 47): faila=3D 45(D)  failb=3D 47(D=
)  OK
[    7.645791] raid6test: test_disks(45, 48): faila=3D 45(D)  failb=3D 48(D=
)  OK
[    7.646544] raid6test: test_disks(45, 49): faila=3D 45(D)  failb=3D 49(D=
)  OK
[    7.647304] raid6test: test_disks(45, 50): faila=3D 45(D)  failb=3D 50(D=
)  OK
[    7.648056] raid6test: test_disks(45, 51): faila=3D 45(D)  failb=3D 51(D=
)  OK
[    7.648827] raid6test: test_disks(45, 52): faila=3D 45(D)  failb=3D 52(D=
)  OK
[    7.649594] raid6test: test_disks(45, 53): faila=3D 45(D)  failb=3D 53(D=
)  OK
[    7.650381] raid6test: test_disks(45, 54): faila=3D 45(D)  failb=3D 54(D=
)  OK
[    7.651128] raid6test: test_disks(45, 55): faila=3D 45(D)  failb=3D 55(D=
)  OK
[    7.651887] raid6test: test_disks(45, 56): faila=3D 45(D)  failb=3D 56(D=
)  OK
[    7.652643] raid6test: test_disks(45, 57): faila=3D 45(D)  failb=3D 57(D=
)  OK
[    7.653407] raid6test: test_disks(45, 58): faila=3D 45(D)  failb=3D 58(D=
)  OK
[    7.654158] raid6test: test_disks(45, 59): faila=3D 45(D)  failb=3D 59(D=
)  OK
[    7.654938] raid6test: test_disks(45, 60): faila=3D 45(D)  failb=3D 60(D=
)  OK
[    7.655693] raid6test: test_disks(45, 61): faila=3D 45(D)  failb=3D 61(D=
)  OK
[    7.656447] raid6test: test_disks(45, 62): faila=3D 45(D)  failb=3D 62(P=
)  OK
[    7.657188] raid6test: test_disks(45, 63): faila=3D 45(D)  failb=3D 63(Q=
)  OK
[    7.657952] raid6test: test_disks(46, 47): faila=3D 46(D)  failb=3D 47(D=
)  OK
[    7.658720] raid6test: test_disks(46, 48): faila=3D 46(D)  failb=3D 48(D=
)  OK
[    7.659473] raid6test: test_disks(46, 49): faila=3D 46(D)  failb=3D 49(D=
)  OK
[    7.660256] raid6test: test_disks(46, 50): faila=3D 46(D)  failb=3D 50(D=
)  OK
[    7.661000] raid6test: test_disks(46, 51): faila=3D 46(D)  failb=3D 51(D=
)  OK
[    7.661757] raid6test: test_disks(46, 52): faila=3D 46(D)  failb=3D 52(D=
)  OK
[    7.662510] raid6test: test_disks(46, 53): faila=3D 46(D)  failb=3D 53(D=
)  OK
[    7.663261] raid6test: test_disks(46, 54): faila=3D 46(D)  failb=3D 54(D=
)  OK
[    7.664006] raid6test: test_disks(46, 55): faila=3D 46(D)  failb=3D 55(D=
)  OK
[    7.664757] raid6test: test_disks(46, 56): faila=3D 46(D)  failb=3D 56(D=
)  OK
[    7.665514] raid6test: test_disks(46, 57): faila=3D 46(D)  failb=3D 57(D=
)  OK
[    7.666263] raid6test: test_disks(46, 58): faila=3D 46(D)  failb=3D 58(D=
)  OK
[    7.667013] raid6test: test_disks(46, 59): faila=3D 46(D)  failb=3D 59(D=
)  OK
[    7.667766] raid6test: test_disks(46, 60): faila=3D 46(D)  failb=3D 60(D=
)  OK
[    7.668532] raid6test: test_disks(46, 61): faila=3D 46(D)  failb=3D 61(D=
)  OK
[    7.669274] raid6test: test_disks(46, 62): faila=3D 46(D)  failb=3D 62(P=
)  OK
[    7.670041] raid6test: test_disks(46, 63): faila=3D 46(D)  failb=3D 63(Q=
)  OK
[    7.670797] raid6test: test_disks(47, 48): faila=3D 47(D)  failb=3D 48(D=
)  OK
[    7.671547] raid6test: test_disks(47, 49): faila=3D 47(D)  failb=3D 49(D=
)  OK
[    7.672302] raid6test: test_disks(47, 50): faila=3D 47(D)  failb=3D 50(D=
)  OK
[    7.673050] raid6test: test_disks(47, 51): faila=3D 47(D)  failb=3D 51(D=
)  OK
[    7.673809] raid6test: test_disks(47, 52): faila=3D 47(D)  failb=3D 52(D=
)  OK
[    7.674563] raid6test: test_disks(47, 53): faila=3D 47(D)  failb=3D 53(D=
)  OK
[    7.675317] raid6test: test_disks(47, 54): faila=3D 47(D)  failb=3D 54(D=
)  OK
[    7.676067] raid6test: test_disks(47, 55): faila=3D 47(D)  failb=3D 55(D=
)  OK
[    7.676820] raid6test: test_disks(47, 56): faila=3D 47(D)  failb=3D 56(D=
)  OK
[    7.677577] raid6test: test_disks(47, 57): faila=3D 47(D)  failb=3D 57(D=
)  OK
[    7.678340] raid6test: test_disks(47, 58): faila=3D 47(D)  failb=3D 58(D=
)  OK
[    7.679087] raid6test: test_disks(47, 59): faila=3D 47(D)  failb=3D 59(D=
)  OK
[    7.679842] raid6test: test_disks(47, 60): faila=3D 47(D)  failb=3D 60(D=
)  OK
[    7.680626] raid6test: test_disks(47, 61): faila=3D 47(D)  failb=3D 61(D=
)  OK
[    7.681375] raid6test: test_disks(47, 62): faila=3D 47(D)  failb=3D 62(P=
)  OK
[    7.682114] raid6test: test_disks(47, 63): faila=3D 47(D)  failb=3D 63(Q=
)  OK
[    7.682864] raid6test: test_disks(48, 49): faila=3D 48(D)  failb=3D 49(D=
)  OK
[    7.683612] raid6test: test_disks(48, 50): faila=3D 48(D)  failb=3D 50(D=
)  OK
[    7.684362] raid6test: test_disks(48, 51): faila=3D 48(D)  failb=3D 51(D=
)  OK
[    7.685109] raid6test: test_disks(48, 52): faila=3D 48(D)  failb=3D 52(D=
)  OK
[    7.685863] raid6test: test_disks(48, 53): faila=3D 48(D)  failb=3D 53(D=
)  OK
[    7.686617] raid6test: test_disks(48, 54): faila=3D 48(D)  failb=3D 54(D=
)  OK
[    7.687372] raid6test: test_disks(48, 55): faila=3D 48(D)  failb=3D 55(D=
)  OK
[    7.688122] raid6test: test_disks(48, 56): faila=3D 48(D)  failb=3D 56(D=
)  OK
[    7.688887] raid6test: test_disks(48, 57): faila=3D 48(D)  failb=3D 57(D=
)  OK
[    7.689639] raid6test: test_disks(48, 58): faila=3D 48(D)  failb=3D 58(D=
)  OK
[    7.690420] raid6test: test_disks(48, 59): faila=3D 48(D)  failb=3D 59(D=
)  OK
[    7.691163] raid6test: test_disks(48, 60): faila=3D 48(D)  failb=3D 60(D=
)  OK
[    7.691909] raid6test: test_disks(48, 61): faila=3D 48(D)  failb=3D 61(D=
)  OK
[    7.692661] raid6test: test_disks(48, 62): faila=3D 48(D)  failb=3D 62(P=
)  OK
[    7.693403] raid6test: test_disks(48, 63): faila=3D 48(D)  failb=3D 63(Q=
)  OK
[    7.694147] raid6test: test_disks(49, 50): faila=3D 49(D)  failb=3D 50(D=
)  OK
[    7.694894] raid6test: test_disks(49, 51): faila=3D 49(D)  failb=3D 51(D=
)  OK
[    7.695646] raid6test: test_disks(49, 52): faila=3D 49(D)  failb=3D 52(D=
)  OK
[    7.696397] raid6test: test_disks(49, 53): faila=3D 49(D)  failb=3D 53(D=
)  OK
[    7.697141] raid6test: test_disks(49, 54): faila=3D 49(D)  failb=3D 54(D=
)  OK
[    7.697896] raid6test: test_disks(49, 55): faila=3D 49(D)  failb=3D 55(D=
)  OK
[    7.698659] raid6test: test_disks(49, 56): faila=3D 49(D)  failb=3D 56(D=
)  OK
[    7.699413] raid6test: test_disks(49, 57): faila=3D 49(D)  failb=3D 57(D=
)  OK
[    7.700187] raid6test: test_disks(49, 58): faila=3D 49(D)  failb=3D 58(D=
)  OK
[    7.700943] raid6test: test_disks(49, 59): faila=3D 49(D)  failb=3D 59(D=
)  OK
[    7.701694] raid6test: test_disks(49, 60): faila=3D 49(D)  failb=3D 60(D=
)  OK
[    7.702444] raid6test: test_disks(49, 61): faila=3D 49(D)  failb=3D 61(D=
)  OK
[    7.703184] raid6test: test_disks(49, 62): faila=3D 49(D)  failb=3D 62(P=
)  OK
[    7.703928] raid6test: test_disks(49, 63): faila=3D 49(D)  failb=3D 63(Q=
)  OK
[    7.704675] raid6test: test_disks(50, 51): faila=3D 50(D)  failb=3D 51(D=
)  OK
[    7.705427] raid6test: test_disks(50, 52): faila=3D 50(D)  failb=3D 52(D=
)  OK
[    7.706165] raid6test: test_disks(50, 53): faila=3D 50(D)  failb=3D 53(D=
)  OK
[    7.706918] raid6test: test_disks(50, 54): faila=3D 50(D)  failb=3D 54(D=
)  OK
[    7.707671] raid6test: test_disks(50, 55): faila=3D 50(D)  failb=3D 55(D=
)  OK
[    7.708438] raid6test: test_disks(50, 56): faila=3D 50(D)  failb=3D 56(D=
)  OK
[    7.709184] raid6test: test_disks(50, 57): faila=3D 50(D)  failb=3D 57(D=
)  OK
[    7.709934] raid6test: test_disks(50, 58): faila=3D 50(D)  failb=3D 58(D=
)  OK
[    7.710715] raid6test: test_disks(50, 59): faila=3D 50(D)  failb=3D 59(D=
)  OK
[    7.711466] raid6test: test_disks(50, 60): faila=3D 50(D)  failb=3D 60(D=
)  OK
[    7.712215] raid6test: test_disks(50, 61): faila=3D 50(D)  failb=3D 61(D=
)  OK
[    7.712961] raid6test: test_disks(50, 62): faila=3D 50(D)  failb=3D 62(P=
)  OK
[    7.713709] raid6test: test_disks(50, 63): faila=3D 50(D)  failb=3D 63(Q=
)  OK
[    7.714460] raid6test: test_disks(51, 52): faila=3D 51(D)  failb=3D 52(D=
)  OK
[    7.715213] raid6test: test_disks(51, 53): faila=3D 51(D)  failb=3D 53(D=
)  OK
[    7.715959] raid6test: test_disks(51, 54): faila=3D 51(D)  failb=3D 54(D=
)  OK
[    7.716712] raid6test: test_disks(51, 55): faila=3D 51(D)  failb=3D 55(D=
)  OK
[    7.717465] raid6test: test_disks(51, 56): faila=3D 51(D)  failb=3D 56(D=
)  OK
[    7.718228] raid6test: test_disks(51, 57): faila=3D 51(D)  failb=3D 57(D=
)  OK
[    7.718967] raid6test: test_disks(51, 58): faila=3D 51(D)  failb=3D 58(D=
)  OK
[    7.719728] raid6test: test_disks(51, 59): faila=3D 51(D)  failb=3D 59(D=
)  OK
[    7.720509] raid6test: test_disks(51, 60): faila=3D 51(D)  failb=3D 60(D=
)  OK
[    7.721264] raid6test: test_disks(51, 61): faila=3D 51(D)  failb=3D 61(D=
)  OK
[    7.722002] raid6test: test_disks(51, 62): faila=3D 51(D)  failb=3D 62(P=
)  OK
[    7.722750] raid6test: test_disks(51, 63): faila=3D 51(D)  failb=3D 63(Q=
)  OK
[    7.723502] raid6test: test_disks(52, 53): faila=3D 52(D)  failb=3D 53(D=
)  OK
[    7.724257] raid6test: test_disks(52, 54): faila=3D 52(D)  failb=3D 54(D=
)  OK
[    7.725006] raid6test: test_disks(52, 55): faila=3D 52(D)  failb=3D 55(D=
)  OK
[    7.725761] raid6test: test_disks(52, 56): faila=3D 52(D)  failb=3D 56(D=
)  OK
[    7.726516] raid6test: test_disks(52, 57): faila=3D 52(D)  failb=3D 57(D=
)  OK
[    7.727274] raid6test: test_disks(52, 58): faila=3D 52(D)  failb=3D 58(D=
)  OK
[    7.728023] raid6test: test_disks(52, 59): faila=3D 52(D)  failb=3D 59(D=
)  OK
[    7.728787] raid6test: test_disks(52, 60): faila=3D 52(D)  failb=3D 60(D=
)  OK
[    7.729536] raid6test: test_disks(52, 61): faila=3D 52(D)  failb=3D 61(D=
)  OK
[    7.730308] raid6test: test_disks(52, 62): faila=3D 52(D)  failb=3D 62(P=
)  OK
[    7.731048] raid6test: test_disks(52, 63): faila=3D 52(D)  failb=3D 63(Q=
)  OK
[    7.731799] raid6test: test_disks(53, 54): faila=3D 53(D)  failb=3D 54(D=
)  OK
[    7.732552] raid6test: test_disks(53, 55): faila=3D 53(D)  failb=3D 55(D=
)  OK
[    7.733303] raid6test: test_disks(53, 56): faila=3D 53(D)  failb=3D 56(D=
)  OK
[    7.734047] raid6test: test_disks(53, 57): faila=3D 53(D)  failb=3D 57(D=
)  OK
[    7.734793] raid6test: test_disks(53, 58): faila=3D 53(D)  failb=3D 58(D=
)  OK
[    7.735541] raid6test: test_disks(53, 59): faila=3D 53(D)  failb=3D 59(D=
)  OK
[    7.736293] raid6test: test_disks(53, 60): faila=3D 53(D)  failb=3D 60(D=
)  OK
[    7.737032] raid6test: test_disks(53, 61): faila=3D 53(D)  failb=3D 61(D=
)  OK
[    7.737778] raid6test: test_disks(53, 62): faila=3D 53(D)  failb=3D 62(P=
)  OK
[    7.738537] raid6test: test_disks(53, 63): faila=3D 53(D)  failb=3D 63(Q=
)  OK
[    7.739289] raid6test: test_disks(54, 55): faila=3D 54(D)  failb=3D 55(D=
)  OK
[    7.740062] raid6test: test_disks(54, 56): faila=3D 54(D)  failb=3D 56(D=
)  OK
[    7.740814] raid6test: test_disks(54, 57): faila=3D 54(D)  failb=3D 57(D=
)  OK
[    7.741568] raid6test: test_disks(54, 58): faila=3D 54(D)  failb=3D 58(D=
)  OK
[    7.742347] raid6test: test_disks(54, 59): faila=3D 54(D)  failb=3D 59(D=
)  OK
[    7.743094] raid6test: test_disks(54, 60): faila=3D 54(D)  failb=3D 60(D=
)  OK
[    7.743853] raid6test: test_disks(54, 61): faila=3D 54(D)  failb=3D 61(D=
)  OK
[    7.744603] raid6test: test_disks(54, 62): faila=3D 54(D)  failb=3D 62(P=
)  OK
[    7.745349] raid6test: test_disks(54, 63): faila=3D 54(D)  failb=3D 63(Q=
)  OK
[    7.746098] raid6test: test_disks(55, 56): faila=3D 55(D)  failb=3D 56(D=
)  OK
[    7.746852] raid6test: test_disks(55, 57): faila=3D 55(D)  failb=3D 57(D=
)  OK
[    7.747607] raid6test: test_disks(55, 58): faila=3D 55(D)  failb=3D 58(D=
)  OK
[    7.748370] raid6test: test_disks(55, 59): faila=3D 55(D)  failb=3D 59(D=
)  OK
[    7.749108] raid6test: test_disks(55, 60): faila=3D 55(D)  failb=3D 60(D=
)  OK
[    7.749860] raid6test: test_disks(55, 61): faila=3D 55(D)  failb=3D 61(D=
)  OK
[    7.750656] raid6test: test_disks(55, 62): faila=3D 55(D)  failb=3D 62(P=
)  OK
[    7.751399] raid6test: test_disks(55, 63): faila=3D 55(D)  failb=3D 63(Q=
)  OK
[    7.752143] raid6test: test_disks(56, 57): faila=3D 56(D)  failb=3D 57(D=
)  OK
[    7.752892] raid6test: test_disks(56, 58): faila=3D 56(D)  failb=3D 58(D=
)  OK
[    7.753643] raid6test: test_disks(56, 59): faila=3D 56(D)  failb=3D 59(D=
)  OK
[    7.754391] raid6test: test_disks(56, 60): faila=3D 56(D)  failb=3D 60(D=
)  OK
[    7.755134] raid6test: test_disks(56, 61): faila=3D 56(D)  failb=3D 61(D=
)  OK
[    7.755885] raid6test: test_disks(56, 62): faila=3D 56(D)  failb=3D 62(P=
)  OK
[    7.756627] raid6test: test_disks(56, 63): faila=3D 56(D)  failb=3D 63(Q=
)  OK
[    7.757377] raid6test: test_disks(57, 58): faila=3D 57(D)  failb=3D 58(D=
)  OK
[    7.758124] raid6test: test_disks(57, 59): faila=3D 57(D)  failb=3D 59(D=
)  OK
[    7.758888] raid6test: test_disks(57, 60): faila=3D 57(D)  failb=3D 60(D=
)  OK
[    7.759644] raid6test: test_disks(57, 61): faila=3D 57(D)  failb=3D 61(D=
)  OK
[    7.760421] raid6test: test_disks(57, 62): faila=3D 57(D)  failb=3D 62(P=
)  OK
[    7.761160] raid6test: test_disks(57, 63): faila=3D 57(D)  failb=3D 63(Q=
)  OK
[    7.761910] raid6test: test_disks(58, 59): faila=3D 58(D)  failb=3D 59(D=
)  OK
[    7.762657] raid6test: test_disks(58, 60): faila=3D 58(D)  failb=3D 60(D=
)  OK
[    7.763404] raid6test: test_disks(58, 61): faila=3D 58(D)  failb=3D 61(D=
)  OK
[    7.764142] raid6test: test_disks(58, 62): faila=3D 58(D)  failb=3D 62(P=
)  OK
[    7.764886] raid6test: test_disks(58, 63): faila=3D 58(D)  failb=3D 63(Q=
)  OK
[    7.765633] raid6test: test_disks(59, 60): faila=3D 59(D)  failb=3D 60(D=
)  OK
[    7.766385] raid6test: test_disks(59, 61): faila=3D 59(D)  failb=3D 61(D=
)  OK
[    7.767128] raid6test: test_disks(59, 62): faila=3D 59(D)  failb=3D 62(P=
)  OK
[    7.767873] raid6test: test_disks(59, 63): faila=3D 59(D)  failb=3D 63(Q=
)  OK
[    7.768631] raid6test: test_disks(60, 61): faila=3D 60(D)  failb=3D 61(D=
)  OK
[    7.769376] raid6test: test_disks(60, 62): faila=3D 60(D)  failb=3D 62(P=
)  OK
[    7.770136] raid6test: test_disks(60, 63): faila=3D 60(D)  failb=3D 63(Q=
)  OK
[    7.770886] raid6test: test_disks(61, 62): faila=3D 61(D)  failb=3D 62(P=
)  OK
[    7.771633] raid6test: test_disks(61, 63): faila=3D 61(D)  failb=3D 63(Q=
)  OK
[    7.772363] raid6test: test_disks(62, 63): faila=3D 62(P)  failb=3D 63(Q=
)  OK
[    7.772992] raid6test:=20
[    7.773235] raid6test: complete (2429 tests, 0 failures)
[    7.776066] rtc_cmos 00:00: setting system clock to 2013-12-22 21:18:39 =
UTC (1387747119)
[    7.778033] debug: unmapping init [mem 0xc1b9d000-0xc1d63fff]
[    7.803948] random: init urandom read with 0 bits of entropy available
[    7.835767] hostname (124) used greatest stack depth: 6748 bytes left
[    7.863534] hwclock (127) used greatest stack depth: 6388 bytes left
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_=
fd >=3D 0' failed.
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[    7.959701] Unregister pv shared memory for cpu 1
[    7.960491] Unregister pv shared memory for cpu 0
[    7.961371] sc520_wdt: Watchdog timer is now disabled...
[    7.962842] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    7.965324] reboot: Restarting system
[    7.965902] reboot: machine restart
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
3-1222/3d712c22114220c3fb9b7fd646bb808e7a61ce6d/vmlinuz-3.13.0-rc3-00015-g3=
d712c2 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS=
0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-te=
sts/run-queue/kvm/i386-randconfig-r3-1222/target:scsi-mq/.vmlinuz-3d712c221=
14220c3fb9b7fd646bb808e7a61ce6d-20131222211705-2-athens branch=3Dtarget/scs=
i-mq BOOT_IMAGE=3D/kernel/i386-randconfig-r3-1222/3d712c22114220c3fb9b7fd64=
6bb808e7a61ce6d/vmlinuz-3.13.0-rc3-00015-g3d712c2'  -initrd /kernel-tests/i=
nitrd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 =
-net user,vlan=3D1,hostfwd=3Dtcp::10806-:22 -boot order=3Dnc -no-reboot -wa=
tchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-q=
uantal-athens-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/dis=
k1-quantal-athens-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM=
/disk2-quantal-athens-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk3-quantal-athens-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/L=
ABEL=3DKVM/disk4-quantal-athens-16,media=3Ddisk,if=3Dvirtio -drive file=3D/=
fs/LABEL=3DKVM/disk5-quantal-athens-16,media=3Ddisk,if=3Dvirtio -pidfile /d=
ev/shm/kboot/pid-quantal-athens-16 -serial file:/dev/shm/kboot/serial-quant=
al-athens-16 -daemonize -display none -monitor null=20

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.13.0-rc3-00015-g3d712c2"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.13.0-rc3 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_LGUEST_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_MELAN=y
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_TS5500=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
CONFIG_CAN_CC770_PLATFORM=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIDTL1=y
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_BT_WILINK=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_MESSAGE_TRACING=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
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
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
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
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_AHCI_IMX=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_THIN_PROVISIONING=y
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_CACHE=y
# CONFIG_DM_CACHE_MQ is not set
CONFIG_DM_CACHE_CLEANER=y
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_TCM_FC=y
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_TWL4030_MADC is not set
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
# CONFIG_TWL4030_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_AS3711 is not set
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9063 is not set
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65090 is not set
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=y
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_MCE_KBD_DECODER=y
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
# CONFIG_VIDEO_SH_VEU is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX8997 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM8350=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD799X is not set
# CONFIG_LPC32XX_ADC is not set
CONFIG_MXS_LRADC=y
CONFIG_SPEAR_ADC=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7854=y
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
# CONFIG_SYNC is not set
CONFIG_DGRP=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_MAX8997=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=y
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=y
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_HID_SENSOR_GYRO_3D=y
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_HID_SENSOR_ALS=y
CONFIG_SENSORS_LM3533=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
CONFIG_LGUEST=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_STMP_DEVICE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y

--wac7ysb48OaltWcw--
