From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [scsi] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one()
Date: Thu, 13 Jun 2013 09:30:32 +0800
Message-ID: <20130613013032.GA7558@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: fengguang.wu@intel.com, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit a256ba092ec57213f96059d41ac5473ff92f5e7c
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sat May 18 02:40:43 2013 -0700

    scsi: Split scsi_dispatch_cmd into __scsi_dispatch_cmd setup
    
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>


[   29.326637]  vda: unknown partition table
[   29.386474] ------------[ cut here ]------------
[   29.388453] WARNING: at /c/kernel-tests/src/stable/fs/sysfs/dir.c:530 sysfs_add_one+0x96/0xaa()
[   29.391061] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:05.0/virtio1/block/vda/mq/0/cpu0'
[   29.403737] Modules linked in:
[   29.406289] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc4-13319-g10adcdf #541
[   29.407936] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   29.410433]  ffffffff81d9d860 ffff88001df65958 ffffffff81994579 ffff88001df65998
[   29.416742]  ffffffff81068740 ffff88001bf6f000 ffff88001df659a8 ffff88001bf6f000
[   29.418708]  ffff88001b8fee60 00000000ffffffef ffff88001df65a48 ffff88001df659f8
[   29.431422] Call Trace:
[   29.433133]  [<ffffffff81994579>] dump_stack+0x19/0x1b
[   29.434352]  [<ffffffff81068740>] warn_slowpath_common+0x67/0x80
[   29.435606]  [<ffffffff810687fc>] warn_slowpath_fmt+0x46/0x48
[   29.437753]  [<ffffffff811c0130>] sysfs_add_one+0x96/0xaa
[   29.439068]  [<ffffffff811c02b5>] create_dir+0x70/0xb2
[   29.451011]  [<ffffffff811c05b6>] sysfs_create_dir+0x9d/0xbb
[   29.453076]  [<ffffffff81461f19>] kobject_add_internal+0x11e/0x222
[   29.454405]  [<ffffffff81462220>] kobject_add+0x8b/0xa4
[   29.455543]  [<ffffffff8144b70d>] ? blk_mq_register_disk+0x72/0x18d
[   29.457534]  [<ffffffff8144b7bc>] blk_mq_register_disk+0x121/0x18d
[   29.458956]  [<ffffffff81444464>] blk_register_queue+0xb1/0x121
[   29.470939]  [<ffffffff8144d0b1>] ? disk_part_iter_next+0x27/0x126
[   29.473011]  [<ffffffff8144df8f>] add_disk+0x33b/0x45b
[   29.474129]  [<ffffffff815518fc>] virtblk_probe+0x4d6/0x5da
[   29.475266]  [<ffffffff8153e7e5>] ? driver_probe_device+0x2f7/0x2f7
[   29.477436]  [<ffffffff814e915b>] virtio_dev_probe+0xba/0xf9
[   29.478740]  [<ffffffff8153e60a>] driver_probe_device+0x11c/0x2f7
[   29.490567]  [<ffffffff8153e848>] __driver_attach+0x63/0x86
[   29.491880]  [<ffffffff8153c868>] bus_for_each_dev+0x5f/0x91
[   29.493903]  [<ffffffff8153df8d>] driver_attach+0x1e/0x20
[   29.495102]  [<ffffffff8153dbbe>] bus_add_driver+0x11d/0x241
[   29.497041]  [<ffffffff8153ee52>] driver_register+0x96/0x11c
[   29.498262]  [<ffffffff82358d87>] ? loop_init+0x147/0x147
[   29.499433]  [<ffffffff814e9303>] register_virtio_driver+0x2b/0x30
[   29.511350]  [<ffffffff82358ddb>] init+0x54/0x8b
[   29.513134]  [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
[   29.514312]  [<ffffffff82314e1a>] kernel_init_freeable+0x13c/0x1cb
[   29.515532]  [<ffffffff823146ee>] ? do_early_param+0x8d/0x8d
[   29.517357]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.518558]  [<ffffffff8197def7>] kernel_init+0xe/0xdb
[   29.527871]  [<ffffffff819a641c>] ret_from_fork+0x7c/0xb0
[   29.529838]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.531584] ---[ end trace dfaab53c7b1f7bcc ]---

git bisect start 10adcdf8d7877e87f3084678709fe74f1e42a25b v3.9 --
git bisect good 1aad08dc571604ebe473e2a187f0f7b211ae6c3f  # 18:48   1366+  Merge tag 'pm+acpi-3.10-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect good 138de5158fc6968b483ef2a7aaf59ad92c362c4c  # 19:57    170+  [MEDIA] Remove duplicate entry for tuner-3036.
git bisect good 61143925693ceef11350b385aa1c685091277cfc  # 20:06    720+  ARM: shmobile: r8a7778: use fixed ratio clock
git bisect good c2da33a672cb50a043751c68f1c01309f260617f  # 20:46    170+  arm64: KVM: Basic ESR_EL2 helpers and vcpu register access
git bisect  bad a486357b0ce26a04a496156e2e4ce9595cf495d9  # 20:49      0-  block: Add missing blk_mq_free_request for scsi-ioctl -> SG_IO
git bisect  bad 7605530fdbe18d69bf84855350c53eb93e8616af  # 20:49      0-  scsi: Make scsi_softirq_done extern for scsi-mq
git bisect good 00060f37d61cce84b05ab265a1d3532fb83b1002  # 20:49    185+  mtip32xx: basic mq support
git bisect good c10a780562ba6664b0766411b7d6924c8d785437  # 00:58    170+  blk-mq: cpu hot plug/unplug fixes
git bisect good 5754ab54c1b28888e9700550585c5729fccbd15f  # 00:58    185+  blk-mq: timeout fixes
git bisect  bad a256ba092ec57213f96059d41ac5473ff92f5e7c  # 00:58      0-  scsi: Split scsi_dispatch_cmd into __scsi_dispatch_cmd setup
git bisect good 5754ab54c1b28888e9700550585c5729fccbd15f  # 01:46    510+  blk-mq: timeout fixes
git bisect  bad 10adcdf8d7877e87f3084678709fe74f1e42a25b  # 01:46      0-  Merge remote-tracking branch 'arm-platforms/kvm-arm64/kvm' into devel-hourly-2013060809
git bisect good 77293e215edef7871a39de4b326f777bc39278ca  # 02:22    510+  Merge branch 'fixes-3.10' of git://git.infradead.org/users/willy/linux-nvme
git bisect good c04efed734409f5a44715b54a6ca1b54b0ccf215  # 03:42    510+  Add linux-next specific files for 20130607

Thanks,
Fengguang

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-24774-20130610130334-3.10.0-rc4-13319-g10adcdf-541"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc4-13319-g10adcdf (kbuild@inn) (gcc version 4.7.1 (Debian 4.7.1-6) ) #541 SMP Sat Jun 8 09:49:31 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-lkp/linux-devel:devel-hourly-2013060809:10adcdf8d7877e87f3084678709fe74f1e42a25b:bisect-drm/.vmlinuz-10adcdf8d7877e87f3084678709fe74f1e42a25b-20130610024841-10-inn-retry-ant branch=linux-devel/devel-hourly-2013060809 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-lkp/10adcdf8d7877e87f3084678709fe74f1e42a25b/vmlinuz-3.10.0-rc4-13319-g10adcdf
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02d97000, 0x02d97fff] PGTABLE
[    0.000000] BRK [0x02d98000, 0x02d98fff] PGTABLE
[    0.000000] BRK [0x02d99000, 0x02d99fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000]  [mem 0x1fc00000-0x1fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
[    0.000000]  [mem 0x1c000000-0x1fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1fffdfff]
[    0.000000]  [mem 0x1fe00000-0x1fffdfff] page 4k
[    0.000000] BRK [0x02d9a000, 0x02d9afff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 1044756(99%)
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000001fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1fffdfff]
[    0.000000]   NODE_DATA [mem 0x1f7fa000-0x1f7fdfff]
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130960
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 126974 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x00093000-0x00093fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00094000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x20000000-0xfffbffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001e200000 s1920128 r8192 d21376 u2097152
[    0.000000] pcpu-alloc: s1920128 r8192 d21376 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 128891
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=/kernel-tests/run-queue/kvm/x86_64-lkp/linux-devel:devel-hourly-2013060809:10adcdf8d7877e87f3084678709fe74f1e42a25b:bisect-drm/.vmlinuz-10adcdf8d7877e87f3084678709fe74f1e42a25b-20130610024841-10-inn-retry-ant branch=linux-devel/devel-hourly-2013060809 noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-lkp/10adcdf8d7877e87f3084678709fe74f1e42a25b/vmlinuz-3.10.0-rc4-13319-g10adcdf
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 473136k/524280k available (9902k kernel code, 440k absent, 50704k reserved, 7750k data, 3088k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 2097152 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.952 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.045627] Calibrating delay loop (skipped), value calculated using timer frequency.. 6383.90 BogoMIPS (lpj=12767808)
[    0.050098] pid_max: default: 32768 minimum: 301
[    0.069368] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.080463] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.086555] Mount-cache hash table entries: 256
[    0.153940] Initializing cgroup subsys memory
[    0.160393] Initializing cgroup subsys blkio
[    0.161687] Initializing cgroup subsys perf_event
[    0.163196] Initializing cgroup subsys hugetlb
[    0.174000] mce: CPU supports 10 MCE banks
[    0.179096] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.179096] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.179096] tlb_flushall_shift: -1
[    0.194502] Freeing SMP alternatives: 40k freed
[    0.197408] ACPI: Core revision 20130418
[    0.461556] ACPI: All ACPI Tables successfully acquired
[    0.465881] ACPI: setting ELCR to 0200 (from 0c00)
[    0.481183] ftrace: allocating 38150 entries in 150 pages
[    1.166345] smpboot: SMP disabled
[    1.172984] Performance Events: 
[    1.174190] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    1.176265] no hardware sampling interrupt available.
[    1.177873] Broken PMU hardware detected, using software events only.
[    1.180254] Failed to access perfctr msr (MSR c0010004 is 0)
[    1.286004] Brought up 1 CPUs
[    1.287226] smpboot: Total of 1 processors activated (6383.90 BogoMIPS)
[    1.297887] CPU0 attaching NULL sched-domain.
[    1.372604] devtmpfs: initialized
[    1.613096] xor: measuring software checksum speed
[    1.672445]    prefetch64-sse:   157.000 MB/sec
[    1.712277]    generic_sse:   194.000 MB/sec
[    1.713592] xor: using function: generic_sse (194.000 MB/sec)
[    1.718009] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    1.738227] NET: Registered protocol family 16
[    1.873896] ACPI: bus type PCI registered
[    1.875280] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.901916] PCI: Using configuration type 1 for base access
[    4.820240] bio: create slab <bio-0> at 0
[    4.908698] raid6: sse2x1      31 MB/s
[    4.976257] raid6: sse2x2      53 MB/s
[    5.044749] raid6: sse2x4      69 MB/s
[    5.045662] raid6: using algorithm sse2x4 (69 MB/s)
[    5.046801] raid6: using intx1 recovery algorithm
[    5.060000] ACPI: Added _OSI(Module Device)
[    5.060271] ACPI: Added _OSI(Processor Device)
[    5.061163] ACPI: Added _OSI(3.0 _SCP Extensions)
[    5.062065] ACPI: Added _OSI(Processor Aggregator Device)
[    5.217174] ACPI: EC: Look up EC in DSDT
[    5.569174] ACPI: Interpreter enabled
[    5.570923] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130418/hwxface-568)
[    5.574040] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130418/hwxface-568)
[    5.589560] ACPI: (supports S0 S3 S4 S5)
[    5.590616] ACPI: Using PIC for interrupt routing
[    5.600627] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    6.622649] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    6.630933] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    6.632355] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    6.633735] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    6.636205] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    6.637993] PCI: root bus 00: using default resources
[    6.641090] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    6.674247] acpiphp: Slot [3] registered
[    6.684781] acpiphp: Slot [4] registered
[    6.693129] acpiphp: Slot [5] registered
[    6.701405] acpiphp: Slot [6] registered
[    6.709899] acpiphp: Slot [7] registered
[    6.721500] acpiphp: Slot [8] registered
[    6.732741] acpiphp: Slot [9] registered
[    6.743446] acpiphp: Slot [10] registered
[    6.752918] acpiphp: Slot [11] registered
[    6.764504] acpiphp: Slot [12] registered
[    6.773598] acpiphp: Slot [13] registered
[    6.784616] acpiphp: Slot [14] registered
[    6.794569] acpiphp: Slot [15] registered
[    6.803560] acpiphp: Slot [16] registered
[    6.814588] acpiphp: Slot [17] registered
[    6.826065] acpiphp: Slot [18] registered
[    6.835107] acpiphp: Slot [19] registered
[    6.846273] acpiphp: Slot [20] registered
[    6.855288] acpiphp: Slot [21] registered
[    6.866351] acpiphp: Slot [22] registered
[    6.875530] acpiphp: Slot [23] registered
[    6.887150] acpiphp: Slot [24] registered
[    6.897936] acpiphp: Slot [25] registered
[    6.908934] acpiphp: Slot [26] registered
[    6.925823] acpiphp: Slot [27] registered
[    6.935550] acpiphp: Slot [28] registered
[    6.946220] acpiphp: Slot [29] registered
[    6.955485] acpiphp: Slot [30] registered
[    6.965420] acpiphp: Slot [31] registered
[    6.966809] PCI host bridge to bus 0000:00
[    6.969371] pci_bus 0000:00: root bus resource [bus 00-ff]
[    6.970807] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    6.972359] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    6.977512] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    7.014182] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    7.031156] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    7.041740] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    7.072990] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    7.077556] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    7.079362] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    7.094306] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    7.100440] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    7.104305] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    7.121563] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    7.136000] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    7.141433] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    7.145445] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    7.162629] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    7.190574] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    7.194953] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    7.200281] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    7.216340] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    7.233302] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    7.237446] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    7.241584] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    7.276575] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    7.281491] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    7.285630] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    7.333502] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    7.338148] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    7.344299] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    7.378417] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    7.383310] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    7.388401] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    7.429036] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    7.433801] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    7.437628] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    7.477929] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    7.481520] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    7.485390] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    7.518971] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    7.521892] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    7.561417] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    7.564415] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    7.649706] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    7.665372] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    7.678161] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    7.694104] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    7.713035] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    7.768756] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2/0x1 ignored.
[    7.770588] Unable to map lapic to logical cpu number
[    7.792000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    7.797048] acpi root: \_SB_.PCI0 notify handler is installed
[    7.808500] Found 1 acpi root devices
[    7.907222] ACPI: No dock devices found.
[    7.947176] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    7.952529] vgaarb: loaded
[    7.953355] vgaarb: bridge control possible 0000:00:02.0
[    7.985407] SCSI subsystem initialized
[    7.988679] ACPI: bus type ATA registered
[    8.014123] libata version 3.00 loaded.
[    8.042687] ACPI: bus type USB registered
[    8.058158] usbcore: registered new interface driver usbfs
[    8.066883] usbcore: registered new interface driver hub
[    8.078474] usbcore: registered new device driver usb
[    8.104561] pps_core: LinuxPPS API ver. 1 registered
[    8.105791] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    8.113490] PTP clock support registered
[    8.146941] EDAC MC: Ver: 3.0.0
[    8.178350] PCI: Using ACPI for IRQ routing
[    8.180983] PCI: pci_cache_line_size set to 64 bytes
[    8.185976] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    8.187605] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[    8.250943] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    8.252956] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    8.256582] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    8.288912] Switching to clocksource hpet
[    8.302769] CE: hpet increased min_delta_ns to 5000 nsec
[    8.302769] CE: hpet increased min_delta_ns to 7500 nsec
[    8.302769] CE: hpet increased min_delta_ns to 11250 nsec
[   15.295821] pnp: PnP ACPI init
[   15.310179] ACPI: bus type PNP registered
[   15.361278] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   15.391834] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   15.426453] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   15.435932] pnp 00:03: [dma 2]
[   15.459626] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   15.498742] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   15.538336] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   15.618739] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   15.657916] pnp: PnP ACPI: found 7 devices
[   15.659204] ACPI: bus type PNP unregistered
[   17.015290] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[   17.022338] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[   17.046179] NET: Registered protocol family 2
[   17.143463] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[   17.158376] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[   17.195315] TCP: Hash tables configured (established 4096 bind 4096)
[   17.207588] TCP: reno registered
[   17.214990] UDP hash table entries: 256 (order: 3, 49152 bytes)
[   17.227307] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[   17.279071] NET: Registered protocol family 1
[   17.335180] RPC: Registered named UNIX socket transport module.
[   17.341054] RPC: Registered udp transport module.
[   17.342262] RPC: Registered tcp transport module.
[   17.343412] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   17.351290] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   17.357292] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   17.359616] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   17.366993] pci 0000:00:02.0: Boot video device
[   17.374995] PCI: CLS 0 bytes, default 64
[   18.831961] DMA-API: preallocated 65536 debug entries
[   18.835612] DMA-API: debugging enabled by kernel config
[   18.867750] kvm: no hardware support
[   18.891493] Machine check injector initialized
[   18.931237] simple rtm test
[   18.938268] transaction aborted 0
[   22.310194] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   23.911847] VFS: Disk quotas dquot_6.5.2
[   23.951867] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   24.427472] NFS: Registering the id_resolver key type
[   24.443878] Key type id_resolver registered
[   24.449467] Key type id_legacy registered
[   24.451236] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   24.666673] ROMFS MTD (C) 2007 Red Hat, Inc.
[   24.720934] fuse init (API version 7.22)
[   24.785289] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
[   25.143425] bio: create slab <bio-1> at 1
[   25.267317] Btrfs loaded
[   25.269855] msgmni has been set to 924
[   25.435963] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   25.453320] io scheduler noop registered
[   25.454426] io scheduler deadline registered
[   25.467203] io scheduler cfq registered (default)
[   25.550425] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   25.606232] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   25.779094] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   25.794733] ACPI: Power Button [PWRF]
[   26.061213] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   26.062979] PCI: setting IRQ 11 as level-triggered
[   26.066969] virtio-pci 0000:00:03.0: setting latency timer to 64
[   26.234920] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   26.246973] PCI: setting IRQ 10 as level-triggered
[   26.249221] virtio-pci 0000:00:05.0: setting latency timer to 64
[   26.378609] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   26.381265] virtio-pci 0000:00:06.0: setting latency timer to 64
[   26.499251] virtio-pci 0000:00:07.0: setting latency timer to 64
[   26.630325] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   26.642870] virtio-pci 0000:00:08.0: setting latency timer to 64
[   26.750180] virtio-pci 0000:00:09.0: setting latency timer to 64
[   26.855959] virtio-pci 0000:00:0a.0: setting latency timer to 64
[   26.931706] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   27.007430] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   27.449172] Non-volatile memory driver v1.3
[   27.491862] Linux agpgart interface v0.103
[   27.638748] [drm] Initialized drm 1.1.0 20060810
[   28.598670] brd: module loaded
[   29.083165] loop: module loaded
[   29.141238] blk-mq: CPU -> queue map
[   29.142294]   CPU 0 -> Queue 0
[   29.326637]  vda: unknown partition table
[   29.386474] ------------[ cut here ]------------
[   29.388453] WARNING: at /c/kernel-tests/src/stable/fs/sysfs/dir.c:530 sysfs_add_one+0x96/0xaa()
[   29.391061] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:05.0/virtio1/block/vda/mq/0/cpu0'
[   29.403737] Modules linked in:
[   29.406289] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc4-13319-g10adcdf #541
[   29.407936] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   29.410433]  ffffffff81d9d860 ffff88001df65958 ffffffff81994579 ffff88001df65998
[   29.416742]  ffffffff81068740 ffff88001bf6f000 ffff88001df659a8 ffff88001bf6f000
[   29.418708]  ffff88001b8fee60 00000000ffffffef ffff88001df65a48 ffff88001df659f8
[   29.431422] Call Trace:
[   29.433133]  [<ffffffff81994579>] dump_stack+0x19/0x1b
[   29.434352]  [<ffffffff81068740>] warn_slowpath_common+0x67/0x80
[   29.435606]  [<ffffffff810687fc>] warn_slowpath_fmt+0x46/0x48
[   29.437753]  [<ffffffff811c0130>] sysfs_add_one+0x96/0xaa
[   29.439068]  [<ffffffff811c02b5>] create_dir+0x70/0xb2
[   29.451011]  [<ffffffff811c05b6>] sysfs_create_dir+0x9d/0xbb
[   29.453076]  [<ffffffff81461f19>] kobject_add_internal+0x11e/0x222
[   29.454405]  [<ffffffff81462220>] kobject_add+0x8b/0xa4
[   29.455543]  [<ffffffff8144b70d>] ? blk_mq_register_disk+0x72/0x18d
[   29.457534]  [<ffffffff8144b7bc>] blk_mq_register_disk+0x121/0x18d
[   29.458956]  [<ffffffff81444464>] blk_register_queue+0xb1/0x121
[   29.470939]  [<ffffffff8144d0b1>] ? disk_part_iter_next+0x27/0x126
[   29.473011]  [<ffffffff8144df8f>] add_disk+0x33b/0x45b
[   29.474129]  [<ffffffff815518fc>] virtblk_probe+0x4d6/0x5da
[   29.475266]  [<ffffffff8153e7e5>] ? driver_probe_device+0x2f7/0x2f7
[   29.477436]  [<ffffffff814e915b>] virtio_dev_probe+0xba/0xf9
[   29.478740]  [<ffffffff8153e60a>] driver_probe_device+0x11c/0x2f7
[   29.490567]  [<ffffffff8153e848>] __driver_attach+0x63/0x86
[   29.491880]  [<ffffffff8153c868>] bus_for_each_dev+0x5f/0x91
[   29.493903]  [<ffffffff8153df8d>] driver_attach+0x1e/0x20
[   29.495102]  [<ffffffff8153dbbe>] bus_add_driver+0x11d/0x241
[   29.497041]  [<ffffffff8153ee52>] driver_register+0x96/0x11c
[   29.498262]  [<ffffffff82358d87>] ? loop_init+0x147/0x147
[   29.499433]  [<ffffffff814e9303>] register_virtio_driver+0x2b/0x30
[   29.511350]  [<ffffffff82358ddb>] init+0x54/0x8b
[   29.513134]  [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
[   29.514312]  [<ffffffff82314e1a>] kernel_init_freeable+0x13c/0x1cb
[   29.515532]  [<ffffffff823146ee>] ? do_early_param+0x8d/0x8d
[   29.517357]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.518558]  [<ffffffff8197def7>] kernel_init+0xe/0xdb
[   29.527871]  [<ffffffff819a641c>] ret_from_fork+0x7c/0xb0
[   29.529838]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.531584] ---[ end trace dfaab53c7b1f7bcc ]---
[   29.534204] ------------[ cut here ]------------
[   29.535314] WARNING: at /c/kernel-tests/src/stable/lib/kobject.c:196 kobject_add_internal+0x191/0x222()
[   29.547890] kobject_add_internal failed for cpu0 with -EEXIST, don't try to register things with the same name in the same directory.
[   29.562467] Modules linked in:
[   29.563768] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-rc4-13319-g10adcdf #541
[   29.566509] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   29.567827]  ffffffff81dda2d1 ffff88001df65a28 ffffffff81994579 ffff88001df65a68
[   29.570405]  ffffffff81068740 ffff88001b938b85 ffff88001df65a78 ffff88001e5db4d8
[   29.583081]  ffff88001b807a58 00000000ffffffef ffff88001b9aa800 ffff88001df65ac8
[   29.586029] Call Trace:
[   29.586654]  [<ffffffff81994579>] dump_stack+0x19/0x1b
[   29.587672]  [<ffffffff81068740>] warn_slowpath_common+0x67/0x80
[   29.591901]  [<ffffffff810687fc>] warn_slowpath_fmt+0x46/0x48
[   29.595078]  [<ffffffff81461f8c>] kobject_add_internal+0x191/0x222
[   29.600172]  [<ffffffff81462220>] kobject_add+0x8b/0xa4
[   29.605753]  [<ffffffff8144b70d>] ? blk_mq_register_disk+0x72/0x18d
[   29.606999]  [<ffffffff8144b7bc>] blk_mq_register_disk+0x121/0x18d
[   29.610187]  [<ffffffff81444464>] blk_register_queue+0xb1/0x121
[   29.611557]  [<ffffffff8144d0b1>] ? disk_part_iter_next+0x27/0x126
[   29.616810]  [<ffffffff8144df8f>] add_disk+0x33b/0x45b
[   29.617958]  [<ffffffff815518fc>] virtblk_probe+0x4d6/0x5da
[   29.619032]  [<ffffffff8153e7e5>] ? driver_probe_device+0x2f7/0x2f7
[   29.626064]  [<ffffffff814e915b>] virtio_dev_probe+0xba/0xf9
[   29.627270]  [<ffffffff8153e60a>] driver_probe_device+0x11c/0x2f7
[   29.634511]  [<ffffffff8153e848>] __driver_attach+0x63/0x86
[   29.635622]  [<ffffffff8153c868>] bus_for_each_dev+0x5f/0x91
[   29.640705]  [<ffffffff8153df8d>] driver_attach+0x1e/0x20
[   29.641981]  [<ffffffff8153dbbe>] bus_add_driver+0x11d/0x241
[   29.647375]  [<ffffffff8153ee52>] driver_register+0x96/0x11c
[   29.650615]  [<ffffffff82358d87>] ? loop_init+0x147/0x147
[   29.651701]  [<ffffffff814e9303>] register_virtio_driver+0x2b/0x30
[   29.655943]  [<ffffffff82358ddb>] init+0x54/0x8b
[   29.661173]  [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
[   29.662453]  [<ffffffff82314e1a>] kernel_init_freeable+0x13c/0x1cb
[   29.663598]  [<ffffffff823146ee>] ? do_early_param+0x8d/0x8d
[   29.666958]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.669618]  [<ffffffff8197def7>] kernel_init+0xe/0xdb
[   29.670872]  [<ffffffff819a641c>] ret_from_fork+0x7c/0xb0
[   29.672269]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.673722] ---[ end trace dfaab53c7b1f7bcd ]---
[   29.683210] blk-mq: CPU -> queue map
[   29.684971]   CPU 0 -> Queue 0
[   29.725325]  vdb: unknown partition table
[   29.742681] ------------[ cut here ]------------
[   29.743773] WARNING: at /c/kernel-tests/src/stable/fs/sysfs/dir.c:530 sysfs_add_one+0x96/0xaa()
[   29.749383] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:06.0/virtio2/block/vdb/mq/0/cpu0'
[   29.755371] Modules linked in:
[   29.758274] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-rc4-13319-g10adcdf #541
[   29.759842] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   29.763915]  ffffffff81d9d860 ffff88001df65958 ffffffff81994579 ffff88001df65998
[   29.770715]  ffffffff81068740 ffff88001bf6f000 ffff88001df659a8 ffff88001bf6f000
[   29.775410]  ffff88001b90b960 00000000ffffffef ffff88001df65a48 ffff88001df659f8
[   29.779229] Call Trace:
[   29.779914]  [<ffffffff81994579>] dump_stack+0x19/0x1b
[   29.784901]  [<ffffffff81068740>] warn_slowpath_common+0x67/0x80
[   29.786060]  [<ffffffff810687fc>] warn_slowpath_fmt+0x46/0x48
[   29.787153]  [<ffffffff811c0130>] sysfs_add_one+0x96/0xaa
[   29.794095]  [<ffffffff811c02b5>] create_dir+0x70/0xb2
[   29.795163]  [<ffffffff811c05b6>] sysfs_create_dir+0x9d/0xbb
[   29.799247]  [<ffffffff81461f19>] kobject_add_internal+0x11e/0x222
[   29.802532]  [<ffffffff81462220>] kobject_add+0x8b/0xa4
[   29.803561]  [<ffffffff81462b47>] ? kobject_uevent_env+0xe7/0x52e
[   29.808827]  [<ffffffff8144b7bc>] blk_mq_register_disk+0x121/0x18d
[   29.810025]  [<ffffffff81444464>] blk_register_queue+0xb1/0x121
[   29.811135]  [<ffffffff8144d0b1>] ? disk_part_iter_next+0x27/0x126
[   29.818324]  [<ffffffff8144df8f>] add_disk+0x33b/0x45b
[   29.819408]  [<ffffffff815518fc>] virtblk_probe+0x4d6/0x5da
[   29.823475]  [<ffffffff8153e7e5>] ? driver_probe_device+0x2f7/0x2f7
[   29.826748]  [<ffffffff814e915b>] virtio_dev_probe+0xba/0xf9
[   29.827893]  [<ffffffff8153e60a>] driver_probe_device+0x11c/0x2f7
[   29.833051]  [<ffffffff8153e848>] __driver_attach+0x63/0x86
[   29.834196]  [<ffffffff8153c868>] bus_for_each_dev+0x5f/0x91
[   29.835276]  [<ffffffff8153df8d>] driver_attach+0x1e/0x20
[   29.842149]  [<ffffffff8153dbbe>] bus_add_driver+0x11d/0x241
[   29.843265]  [<ffffffff8153ee52>] driver_register+0x96/0x11c
[   29.847313]  [<ffffffff82358d87>] ? loop_init+0x147/0x147
[   29.850399]  [<ffffffff814e9303>] register_virtio_driver+0x2b/0x30
[   29.851544]  [<ffffffff82358ddb>] init+0x54/0x8b
[   29.856462]  [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
[   29.857559]  [<ffffffff82314e1a>] kernel_init_freeable+0x13c/0x1cb
[   29.858704]  [<ffffffff823146ee>] ? do_early_param+0x8d/0x8d
[   29.863988]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.867081]  [<ffffffff8197def7>] kernel_init+0xe/0xdb
[   29.871981]  [<ffffffff819a641c>] ret_from_fork+0x7c/0xb0
[   29.875128]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.878194] ---[ end trace dfaab53c7b1f7bce ]---
[   29.879227] ------------[ cut here ]------------
[   29.884067] WARNING: at /c/kernel-tests/src/stable/lib/kobject.c:196 kobject_add_internal+0x191/0x222()
[   29.887634] kobject_add_internal failed for cpu0 with -EEXIST, don't try to register things with the same name in the same directory.
[   29.891707] Modules linked in:
[   29.896690] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-rc4-13319-g10adcdf #541
[   29.898211] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   29.899241]  ffffffff81dda2d1 ffff88001df65a28 ffffffff81994579 ffff88001df65a68
[   29.906840]  ffffffff81068740 ffff88001b938cd5 ffff88001df65a78 ffff88001e5dba98
[   29.911460]  ffff88001b810a58 00000000ffffffef ffff88001b9ac000 ffff88001df65ac8
[   29.915196] Call Trace:
[   29.915867]  [<ffffffff81994579>] dump_stack+0x19/0x1b
[   29.920901]  [<ffffffff81068740>] warn_slowpath_common+0x67/0x80
[   29.922055]  [<ffffffff810687fc>] warn_slowpath_fmt+0x46/0x48
[   29.923150]  [<ffffffff81461f8c>] kobject_add_internal+0x191/0x222
[   29.930127]  [<ffffffff81462220>] kobject_add+0x8b/0xa4
[   29.931199]  [<ffffffff81462b47>] ? kobject_uevent_env+0xe7/0x52e
[   29.935300]  [<ffffffff8144b7bc>] blk_mq_register_disk+0x121/0x18d
[   29.938488]  [<ffffffff81444464>] blk_register_queue+0xb1/0x121
[   29.939618]  [<ffffffff8144d0b1>] ? disk_part_iter_next+0x27/0x126
[   29.944738]  [<ffffffff8144df8f>] add_disk+0x33b/0x45b
[   29.945837]  [<ffffffff815518fc>] virtblk_probe+0x4d6/0x5da
[   29.946902]  [<ffffffff8153e7e5>] ? driver_probe_device+0x2f7/0x2f7
[   29.948419]  [<ffffffff814e915b>] virtio_dev_probe+0xba/0xf9
[   29.954998]  [<ffffffff8153e60a>] driver_probe_device+0x11c/0x2f7
[   29.959082]  [<ffffffff8153e848>] __driver_attach+0x63/0x86
[   29.962184]  [<ffffffff8153c868>] bus_for_each_dev+0x5f/0x91
[   29.963283]  [<ffffffff8153df8d>] driver_attach+0x1e/0x20
[   29.968365]  [<ffffffff8153dbbe>] bus_add_driver+0x11d/0x241
[   29.969443]  [<ffffffff8153ee52>] driver_register+0x96/0x11c
[   29.970488]  [<ffffffff82358d87>] ? loop_init+0x147/0x147
[   29.975676]  [<ffffffff814e9303>] register_virtio_driver+0x2b/0x30
[   29.978894]  [<ffffffff82358ddb>] init+0x54/0x8b
[   29.979863]  [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
[   29.984894]  [<ffffffff82314e1a>] kernel_init_freeable+0x13c/0x1cb
[   29.986055]  [<ffffffff823146ee>] ? do_early_param+0x8d/0x8d
[   29.987129]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   29.993130]  [<ffffffff8197def7>] kernel_init+0xe/0xdb
[   29.994186]  [<ffffffff819a641c>] ret_from_fork+0x7c/0xb0
[   29.995229]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   30.001043] ---[ end trace dfaab53c7b1f7bcf ]---
[   30.031292] blk-mq: CPU -> queue map
[   30.034171]   CPU 0 -> Queue 0
[   30.049866] BUG: unable to handle kernel paging request at ffffe8ffffc00084
[   30.049866] IP: [<ffffffff814493e6>] blk_mq_init_queue+0x302/0x3a5
[   30.049866] PGD 1ba10067 PUD 1ba11067 PMD 0 
[   30.049866] Oops: 0002 [#1] SMP 
[   30.049866] Modules linked in:
[   30.049866] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-rc4-13319-g10adcdf #541
[   30.049866] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   30.049866] task: ffff88001df68000 ti: ffff88001df64000 task.ti: ffff88001df64000
[   30.049866] RIP: 0010:[<ffffffff814493e6>]  [<ffffffff814493e6>] blk_mq_init_queue+0x302/0x3a5
[   30.049866] RSP: 0000:ffff88001df65c58  EFLAGS: 00000297
[   30.049866] RAX: ffff88001b811800 RBX: ffff88001ba26940 RCX: ffff88001b938d30
[   30.049866] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88001ba26940
[   30.049866] RBP: ffff88001df65cb8 R08: ffff88001e3d6cc0 R09: ffff88001dc01e00
[   30.049866] R10: ffff88001b938d50 R11: ffff88001df65fd8 R12: ffffe8ffffc00000
[   30.049866] R13: 0000000000000002 R14: 00000000001cefb0 R15: 0000000000000100
[   30.049866] FS:  0000000000000000(0000) GS:ffff88001e200000(0000) knlGS:0000000000000000
[   30.049866] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   30.049866] CR2: ffffe8ffffc00084 CR3: 000000000200b000 CR4: 00000000000006f0
[   30.049866] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   30.049866] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[   30.049866] Stack:
[   30.049866]  ffff88001df65c78 0000000000000000 ffffe8ffffa00000 ffff88001bff2000
[   30.049866]  000000041df65ca8 000060ffe1800000 0000000000000001 ffff88001b92b800
[   30.049866]  ffff88001bff2000 0000000000001090 0000000000000002 ffff88001b9ad800
[   30.049866] Call Trace:
[   30.049866]  [<ffffffff815515f2>] virtblk_probe+0x1cc/0x5da
[   30.049866]  [<ffffffff814ebbbb>] ? vp_set_status+0x26/0x28
[   30.049866]  [<ffffffff8153e7e5>] ? driver_probe_device+0x2f7/0x2f7
[   30.049866]  [<ffffffff814e915b>] virtio_dev_probe+0xba/0xf9
[   30.049866]  [<ffffffff8153e60a>] driver_probe_device+0x11c/0x2f7
[   30.049866]  [<ffffffff8153e848>] __driver_attach+0x63/0x86
[   30.049866]  [<ffffffff8153c868>] bus_for_each_dev+0x5f/0x91
[   30.049866]  [<ffffffff8153df8d>] driver_attach+0x1e/0x20
[   30.049866]  [<ffffffff8153dbbe>] bus_add_driver+0x11d/0x241
[   30.049866]  [<ffffffff8153ee52>] driver_register+0x96/0x11c
[   30.049866]  [<ffffffff82358d87>] ? loop_init+0x147/0x147
[   30.049866]  [<ffffffff814e9303>] register_virtio_driver+0x2b/0x30
[   30.049866]  [<ffffffff82358ddb>] init+0x54/0x8b
[   30.049866]  [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
[   30.049866]  [<ffffffff82314e1a>] kernel_init_freeable+0x13c/0x1cb
[   30.049866]  [<ffffffff823146ee>] ? do_early_param+0x8d/0x8d
[   30.049866]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   30.049866]  [<ffffffff8197def7>] kernel_init+0xe/0xdb
[   30.049866]  [<ffffffff819a641c>] ret_from_fork+0x7c/0xb0
[   30.049866]  [<ffffffff8197dee9>] ? rest_init+0xdd/0xdd
[   30.049866] Code: ff 85 c0 75 68 4c 8b a3 68 01 00 00 45 31 ed 4c 03 25 cf 9d ce 00 eb 45 48 8b 83 58 01 00 00 48 89 df ff 50 08 8b 90 88 01 00 00 <41> 89 94 24 84 00 00 00 8b 90 88 01 00 00 48 8b 88 90 01 00 00 
[   30.049866] RIP  [<ffffffff814493e6>] blk_mq_init_queue+0x302/0x3a5
[   30.049866]  RSP <ffff88001df65c58>
[   30.049866] CR2: ffffe8ffffc00084
[   30.049866] ---[ end trace dfaab53c7b1f7bd0 ]---
[   30.205679] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[   30.205679] 
[   30.207150] Kernel Offset: 0x0
[   30.207150] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 65

--cWoXeonUoKmBZSoM
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-10adcdf8d7877e87f3084678709fe74f1e42a25b-x86_64-lkp-sysfs_add_one-80868.log"
Content-Transfer-Encoding: base64

YmlzZWN0OiBza2lwIGU4MTkzY2U1NzJmMGRkYjgwMDRhY2Y5NzZiYmExMTlmMGFiYmU2Y2E6
IG5vdCBhIGdvb2QgbWVyZ2UgYmFzZQpnaXQgY2hlY2tvdXQgdjMuOQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyAxMGFkY2RmLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J2FybS1wbGF0Zm9ybXMva3ZtLWFybTY0L2t2bScgaW50byBkZXZlbC1ob3VybHktMjAxMzA2
MDgwOQpIRUFEIGlzIG5vdyBhdCBjMWJlNWE1Li4uIExpbnV4IDMuOQpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxMzA2MDgwOTpjMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQx
OmJpc2VjdC1saW51eAogU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My45CmdpdCBi
aXNlY3Qgc3RhcnQgMTBhZGNkZjhkNzg3N2U4N2YzMDg0Njc4NzA5ZmU3NGYxZTQyYTI1YiB2
My45IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGMxYmU1YTUuLi4gTGludXggMy45
CkhFQUQgaXMgbm93IGF0IDgwNWE2YWYuLi4gTGludXggMy4yCkJpc2VjdGluZzogMTM1NTkg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpb
MWFhZDA4ZGM1NzE2MDRlYmU0NzNlMmExODdmMGY3YjIxMWFlNmMzZl0gTWVyZ2UgdGFnICdw
bSthY3BpLTMuMTAtcmMzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvcmFmYWVsL2xpbnV4LXBtCmdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tb3RtL29iai1i
aXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtbGtwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMDYw
ODA5OjFhYWQwOGRjNTcxNjA0ZWJlNDczZTJhMTg3ZjBmN2IyMTFhZTZjM2Y6YmlzZWN0LWxp
bnV4CiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDY3NzkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbMTM4ZGU1MTU4ZmM2OTY4YjQ4M2VmMmE3
YWFmNTlhZDkyYzM2MmM0Y10gW01FRElBXSBSZW1vdmUgZHVwbGljYXRlIGVudHJ5IGZvciB0
dW5lci0zMDM2LgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL21tb3RtL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1sa3AvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTMwNjA4MDk6MTM4ZGU1MTU4ZmM2OTY4YjQ4M2VmMmE3YWFmNTlhZDkyYzM2MmM0YzpiaXNl
Y3QtbGludXgKCjIwMTMtMDYtMTItMTg6NDg6NDcgMTM4ZGU1MTU4ZmM2OTY4YjQ4M2VmMmE3
YWFmNTlhZDkyYzM2MmM0YyByZXVzZSAva2VybmVsL3g4Nl82NC1sa3AvMTM4ZGU1MTU4ZmM2
OTY4YjQ4M2VmMmE3YWFmNTlhZDkyYzM2MmM0Yy92bWxpbnV6LTIuNi4xNi1yYzUtZzEzOGRl
NTE1CgoyMDEzLTA2LTEyLTE4OjQ4OjQ3IGRldGVjdGluZyBib290IHN0YXRlIC4JMwk0Lgk2
Li4uLi4uCTcuLgkxNC4uCTE2CTIwCTIyLi4uLgkyNS4uCTI5CTMwCTMzCTM1CTM2LgkzNwkz
OQk0Mwk0NQk0OQk1MQk1Mwk1Nwk1OAk2MAk2MQk2Mwk2Ni4uCTY5CTczCTc0Li4uLgk3OAk3
OS4JODAJODEJODIJODMuLgk4NC4JODcJODkuLgk5MAk5Mgk5My4JOTcJMTAyCTEwNAkxMDcJ
MTA4LgkxMTIJMTEzCTExNS4uCTExOS4uLgkxMjMJMTMwLi4uLi4JMTMyLi4uCTEzNC4uLi4J
MTM1CTEzNi4uCTEzNy4JMTQxCTE0NC4uCTE0NwkxNTAJMTUxLgkxNTIuLgkxNTQuLgkxNTcJ
MTU4CTE2MAkxNjEJMTYzLgkxNjUJMTY3CTE2OAkxNjkuCTE3MCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDMzODkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEy
IHN0ZXBzKQpbMGM4NDRkNzA4YWRhNjU1MDNhNzE5NWE2OTVkNDViMDA5NTE2YTYyMl0gTUlQ
UzogQVI3OiBJbXBsZW1lbnQgZ3Bpb2xpYgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tb3RtL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1sa3AvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTMwNjA4MDk6MGM4NDRkNzA4YWRhNjU1MDNhNzE5NWE2OTVkNDVi
MDA5NTE2YTYyMjpiaXNlY3QtbGludXgKCjIwMTMtMDYtMTItMTk6NTc6NTAgMGM4NDRkNzA4
YWRhNjU1MDNhNzE5NWE2OTVkNDViMDA5NTE2YTYyMiBjb21waWxpbmcKG1sxOzM1bXg4Nl82
NC1sa3A6IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVteDg2XzY0LWxrcDog
bWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQoxNjkgcmVhbCAgMTA0OCB1c2VyICAxMDUg
c3lzICA2ODIuMDElIGNwdSAJeDg2XzY0LWxrcAoyMDEzLTA2LTEyLTIwOjAxOjI4IDBjODQ0
ZDcwOGFkYTY1NTAzYTcxOTVhNjk1ZDQ1YjAwOTUxNmE2MjIgU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9tbW90bS1iaXNlY3QgYW5kIC90bXAva2VybmVsL3g4
Nl82NC1sa3AvMGM4NDRkNzA4YWRhNjU1MDNhNzE5NWE2OTVkNDViMDA5NTE2YTYyMgpCaXNl
Y3Rpbmc6IDMzODkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDEyIHN0ZXBzKQpbNzcyMGE0MTU0MWYwZGFiZmM1NDRkODg3MzczOGI4OGE4YmZmNTRhN10g
TWVyZ2UgYnJhbmNoICdtYXN0ZXInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC0yLjYKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMDYwODA5Ojc3MjBhNDE1NDFmMGRhYmZjNTQ0
ZDg4NzM3MzhiODhhOGJmZjU0YTc6YmlzZWN0LWxpbnV4CgoyMDEzLTA2LTEyLTIwOjAxOjQ4
IDc3MjBhNDE1NDFmMGRhYmZjNTQ0ZDg4NzM3MzhiODhhOGJmZjU0YTcgY29tcGlsaW5nChtb
MTszNW14ODZfNjQtbGtwOiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bXg4
Nl82NC1sa3A6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMjA3IHJlYWwgIDY5NyB1
c2VyICA2MiBzeXMgIDM2Ny4wNyUgY3B1IAl4ODZfNjQtbGtwCjIwMTMtMDYtMTItMjA6MDU6
NTAgNzcyMGE0MTU0MWYwZGFiZmM1NDRkODg3MzczOGI4OGE4YmZmNTRhNyBTS0lQIEJST0tF
TiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL21tb3RtLWJpc2VjdCBhbmQgL3RtcC9r
ZXJuZWwveDg2XzY0LWxrcC83NzIwYTQxNTQxZjBkYWJmYzU0NGQ4ODczNzM4Yjg4YThiZmY1
NGE3CkJpc2VjdGluZzogMzM4OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMTIgc3RlcHMpCls2MTE0MzkyNTY5M2NlZWYxMTM1MGIzODVhYTFjNjg1MDkx
Mjc3Y2ZjXSBBUk06IHNobW9iaWxlOiByOGE3Nzc4OiB1c2UgZml4ZWQgcmF0aW8gY2xvY2sK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtbGtwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMDYwODA5OjYx
MTQzOTI1NjkzY2VlZjExMzUwYjM4NWFhMWM2ODUwOTEyNzdjZmM6YmlzZWN0LWxpbnV4CiBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDMzODcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbNTlmYTQxM2UyMGM0MDgwODIwMzU1MmE5ZDkxODRj
MmNlZWNjZGViN10gTUlQUzogQVI3OiByZXBsYWNlIHByb21fZ2V0Y21kbGluZSgpIHRvIGFy
Y3NfY21kbGluZVtdCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxMzA2MDgwOTo1OWZhNDEzZTIwYzQwODA4MjAzNTUyYTlkOTE4NGMyY2VlY2NkZWI3OmJp
c2VjdC1saW51eAoKMjAxMy0wNi0xMi0yMDowNjo0NSA1OWZhNDEzZTIwYzQwODA4MjAzNTUy
YTlkOTE4NGMyY2VlY2NkZWI3IGNvbXBpbGluZwobWzE7MzVteDg2XzY0LWxrcDogbWFrZSBv
bGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW14ODZfNjQtbGtwOiBtYWtlIG9sZGNvbmZp
ZyBzdWNjZWVkZWQbWzBtCjEyMiByZWFsICAxMDM0IHVzZXIgIDEwMyBzeXMgIDkyOC44NyUg
Y3B1IAl4ODZfNjQtbGtwCjIwMTMtMDYtMTItMjA6MTE6MDcgNTlmYTQxM2UyMGM0MDgwODIw
MzU1MmE5ZDkxODRjMmNlZWNjZGViNyBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBp
biAvY2Mvd2ZnL21tb3RtLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwveDg2XzY0LWxrcC81OWZh
NDEzZTIwYzQwODA4MjAzNTUyYTlkOTE4NGMyY2VlY2NkZWI3CkJpc2VjdGluZzogMzM4NyBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCltj
MmRhMzNhNjcyY2I1MGEwNDM3NTFjNjhmMWMwMTMwOWYyNjA2MTdmXSBhcm02NDogS1ZNOiBC
YXNpYyBFU1JfRUwyIGhlbHBlcnMgYW5kIHZjcHUgcmVnaXN0ZXIgYWNjZXNzCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
bW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LWxrcC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxMzA2MDgwOTpjMmRhMzNhNjcy
Y2I1MGEwNDM3NTFjNjhmMWMwMTMwOWYyNjA2MTdmOmJpc2VjdC1saW51eAoKMjAxMy0wNi0x
Mi0yMDoxMTozMCBjMmRhMzNhNjcyY2I1MGEwNDM3NTFjNjhmMWMwMTMwOWYyNjA2MTdmIHJl
dXNlIC9rZXJuZWwveDg2XzY0LWxrcC9jMmRhMzNhNjcyY2I1MGEwNDM3NTFjNjhmMWMwMTMw
OWYyNjA2MTdmL3ZtbGludXotMy4xMC4wLXJjMy0wMDAzNi1nYzJkYTMzYQoKMjAxMy0wNi0x
Mi0yMDoxMTozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLgkxMDEJMTAzLi4JMTA1CTEw
NwkxMDguLgkxMDkJMTEyCTExNi4uLgkxMTguCTExOQkxMjIJMTI1Li4uCTEyNwkxMjgJMTI5
Li4JMTM1Li4uCTEzNgkxMzcJMTM4LgkxMzkuCTE0MgkxNDYJMTQ4LgkxNDkJMTUwCTE1Mi4u
LgkxNTUJMTU2CTE1OC4JMTYwCTE2MQkxNjMJMTY0CTE2NS4uCTE2Ny4uCTE2OQkxNzAgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAzMzUyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMiBzdGVwcykKWzQ4ZGQwODkxNWE1NWNkY2JlODBiZTRhZDUxYWIzZmZl
YWZiMDYxODNdIE1JUFM6IEFsY2hlbXk6IE9ubHkgYnVpbGQgQVUxMDAwIElOVEMgY29kZSBm
b3IgY29tcGF0aWJsZSBjcHVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxMzA2MDgwOTo0OGRkMDg5MTVhNTVjZGNiZTgwYmU0YWQ1MWFiM2ZmZWFmYjA2
MTgzOmJpc2VjdC1saW51eAoKMjAxMy0wNi0xMi0yMDo0NjozMSA0OGRkMDg5MTVhNTVjZGNi
ZTgwYmU0YWQ1MWFiM2ZmZWFmYjA2MTgzIGNvbXBpbGluZwobWzE7MzVteDg2XzY0LWxrcDog
bWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW14ODZfNjQtbGtwOiBtYWtlIG9s
ZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjExOSByZWFsICAxMDQzIHVzZXIgIDEwMiBzeXMgIDk2
Mi4zMiUgY3B1IAl4ODZfNjQtbGtwCjIwMTMtMDYtMTItMjA6NDk6MDIgNDhkZDA4OTE1YTU1
Y2RjYmU4MGJlNGFkNTFhYjNmZmVhZmIwNjE4MyBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBl
cnJvcyBpbiAvY2Mvd2ZnL21tb3RtLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwveDg2XzY0LWxr
cC80OGRkMDg5MTVhNTVjZGNiZTgwYmU0YWQ1MWFiM2ZmZWFmYjA2MTgzCkJpc2VjdGluZzog
MzM1MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3Rl
cHMpClthNDg2MzU3YjBjZTI2YTA0YTQ5NjE1NmUyZTRjZTk1OTVjZjQ5NWQ5XSBibG9jazog
QWRkIG1pc3NpbmcgYmxrX21xX2ZyZWVfcmVxdWVzdCBmb3Igc2NzaS1pb2N0bCAtPiBTR19J
TwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL21tb3RtL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1sa3AvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTMwNjA4MDk6
YTQ4NjM1N2IwY2UyNmEwNGE0OTYxNTZlMmU0Y2U5NTk1Y2Y0OTVkOTpiaXNlY3QtbGludXgK
IFRFU1QgRkFJTFVSRQova2VybmVsL3g4Nl82NC1sa3AvYTQ4NjM1N2IwY2UyNmEwNGE0OTYx
NTZlMmU0Y2U5NTk1Y2Y0OTVkOS9kbWVzZy1rdm0tYW50LTI1MjQwLTIwMTMwNjExMjEzODM1
LTMuMTAuMC1yYzMtMDAwMjYtZ2E0ODYzNTctNDQKCkJpc2VjdGluZzogMTIgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCls3NjA1NTMwZmRi
ZTE4ZDY5YmY4NDg1NTM1MGM1M2ViOTNlODYxNmFmXSBzY3NpOiBNYWtlIHNjc2lfc29mdGly
cV9kb25lIGV4dGVybiBmb3Igc2NzaS1tcQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tb3RtL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1sa3AvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTMwNjA4MDk6NzYwNTUzMGZkYmUxOGQ2OWJmODQ4NTUzNTBjNTNl
YjkzZTg2MTZhZjpiaXNlY3QtbGludXgKIFRFU1QgRkFJTFVSRQova2VybmVsL3g4Nl82NC1s
a3AvNzYwNTUzMGZkYmUxOGQ2OWJmODQ4NTUzNTBjNTNlYjkzZTg2MTZhZi9kbWVzZy1rdm0t
YW50LTI1NTM5LTIwMTMwNjExMjE1MDUzLTMuMTAuMC1yYzMtMDAwMTMtZzc2MDU1MzAtNDUK
CkJpc2VjdGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMyBzdGVwcykKWzAwMDYwZjM3ZDYxY2NlODRiMDVhYjI2NWExZDM1MzJmYjgzYjEwMDJd
IG10aXAzMnh4OiBiYXNpYyBtcSBzdXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxMzA2MDgwOTowMDA2MGYzN2Q2MWNjZTg0YjA1YWIyNjVhMWQz
NTMyZmI4M2IxMDAyOmJpc2VjdC1saW51eAogU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbYzEwYTc4
MDU2MmJhNjY2NGIwNzY2NDExYjdkNjkyNGM4ZDc4NTQzN10gYmxrLW1xOiBjcHUgaG90IHBs
dWcvdW5wbHVnIGZpeGVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxMzA2MDgwOTpjMTBhNzgwNTYyYmE2NjY0YjA3NjY0MTFiN2Q2OTI0YzhkNzg1NDM3
OmJpc2VjdC1saW51eAoKMjAxMy0wNi0xMi0yMDo0OToyNyBjMTBhNzgwNTYyYmE2NjY0YjA3
NjY0MTFiN2Q2OTI0YzhkNzg1NDM3IHJldXNlIC9rZXJuZWwveDg2XzY0LWxrcC9jMTBhNzgw
NTYyYmE2NjY0YjA3NjY0MTFiN2Q2OTI0YzhkNzg1NDM3L3ZtbGludXotMy4xMC4wLXJjMy0w
MDAxMC1nYzEwYTc4MAoKMjAxMy0wNi0xMi0yMDo0OToyNyBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4uLi4uLi4JMS4uCTQJNQk2LgkxMS4JMTMJMTUJMTgJMjIuCTI0LgkyNwkyOQkzMS4J
MzIuCTMzLi4uCTM0LgkzNS4uCTM2Li4JMzcJMzguLgkzOS4JNDAJNDEuCTQyCTQ0CTQ1CTQ2
Li4uCTQ4CTUwLi4JNTIuCTU3CTU4Lgk1OQk2Mgk2My4uLgk2NAk2Ngk2OS4uCTcwCTcyCTc0
Li4uCTc2CTc3CTc4Lgk4MS4JODQuLgk4Ni4JODguLgk4OS4uLgk5MC4uLi4uLi4JOTEJOTIu
Lgk5NC4uLgk5Ni4uLi4JOTguLgkxMDAJMTA0Li4JMTA2Li4JMTA4Li4JMTA5LgkxMTMuCTEx
NAkxMTUuLgkxMTYuCTExNwkxMTkJMTIxCTEyMi4uCTEyMwkxMzMJMTM1CTEzNi4JMTQyLi4J
MTQzLgkxNDYuCTE0OQkxNTAJMTUxLi4uCTE1NQkxNTYuCTE1OAkxNjAJMTYzLi4JMTY1Lgkx
NjcJMTY4Li4uCTE2OS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRk
X3RvX3J1bl9xdWV1ZSAxG1swbQouLi4uLi4uLi4JMTcwIFNVQ0NFU1MKCkJpc2VjdGluZzog
MSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCls1
NzU0YWI1NGMxYjI4ODg4ZTk3MDA1NTA1ODVjNTcyOWZjY2JkMTVmXSBibGstbXE6IHRpbWVv
dXQgZml4ZXMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEz
MDYwODA5OjU3NTRhYjU0YzFiMjg4ODhlOTcwMDU1MDU4NWM1NzI5ZmNjYmQxNWY6YmlzZWN0
LWxpbnV4CiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpClthMjU2YmEwOTJlYzU3MjEzZjk2MDU5ZDQx
YWM1NDczZmY5MmY1ZTdjXSBzY3NpOiBTcGxpdCBzY3NpX2Rpc3BhdGNoX2NtZCBpbnRvIF9f
c2NzaV9kaXNwYXRjaF9jbWQgc2V0dXAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwL2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDEzMDYwODA5OmEyNTZiYTA5MmVjNTcyMTNmOTYwNTlkNDFhYzU0NzNm
ZjkyZjVlN2M6YmlzZWN0LWxpbnV4CiBURVNUIEZBSUxVUkUKL2tlcm5lbC94ODZfNjQtbGtw
L2EyNTZiYTA5MmVjNTcyMTNmOTYwNTlkNDFhYzU0NzNmZjkyZjVlN2MvZG1lc2cta3ZtLWFu
dC0yNTg4Mi0yMDEzMDYxMjAwNTkwMi0zLjEwLjAtcmMzLTAwMDEyLWdhMjU2YmEwLTQ3Cgph
MjU2YmEwOTJlYzU3MjEzZjk2MDU5ZDQxYWM1NDczZmY5MmY1ZTdjIGlzIHRoZSBmaXJzdCBi
YWQgY29tbWl0CmNvbW1pdCBhMjU2YmEwOTJlYzU3MjEzZjk2MDU5ZDQxYWM1NDczZmY5MmY1
ZTdjCkF1dGhvcjogTmljaG9sYXMgQmVsbGluZ2VyIDxuYWJAbGludXgtaXNjc2kub3JnPgpE
YXRlOiAgIFNhdCBNYXkgMTggMDI6NDA6NDMgMjAxMyAtMDcwMAoKICAgIHNjc2k6IFNwbGl0
IHNjc2lfZGlzcGF0Y2hfY21kIGludG8gX19zY3NpX2Rpc3BhdGNoX2NtZCBzZXR1cAogICAg
CiAgICBTaWduZWQtb2ZmLWJ5OiBOaWNob2xhcyBCZWxsaW5nZXIgPG5hYkBsaW51eC1pc2Nz
aS5vcmc+Cgo6MDQwMDAwIDA0MDAwMCAyNmYyZTkzMDcxZDBlYmFhNTYyNTU1NGEzNWIxYjNj
ZjhjZDkwYTk0IGZjYWNiMmQ2OGEzMTFkNTg1ODcwMjc1YmIwM2I0OGFlMTRjOThlOGIgTQlk
cml2ZXJzCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LWxrcC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxMzA2MDgwOTo1
NzU0YWI1NGMxYjI4ODg4ZTk3MDA1NTA1ODVjNTcyOWZjY2JkMTVmOmJpc2VjdC1saW51eAoK
MjAxMy0wNi0xMy0wMDo1ODo1MCA1NzU0YWI1NGMxYjI4ODg4ZTk3MDA1NTA1ODVjNTcyOWZj
Y2JkMTVmIHJldXNlIC9rZXJuZWwveDg2XzY0LWxrcC81NzU0YWI1NGMxYjI4ODg4ZTk3MDA1
NTA1ODVjNTcyOWZjY2JkMTVmL3ZtbGludXotMy4xMC4wLXJjMy0wMDAxMS1nNTc1NGFiNQoK
MjAxMy0wNi0xMy0wMDo1ODo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4JMTg2Lgkx
ODcuLgkxOTMJMTk2CTIwMy4uCTIwOAkyMTAJMjEyLgkyMTQJMjE2CTIxOQkyMjQuLi4JMjI4
CTIzMC4JMjMyCTIzNAkyMzYJMjM5LgkyNDAuCTI0MwkyNDkuCTI1MAkyNTIJMjU5CTI2Ny4u
CTI3MAkyNzkJMjgwLi4JMjg4CTI5NwkzMDIJMzA3CTMxMwkzMTkJMzMxCTMzNwkzMzkJMzQz
CTM1MQkzNjAuLgkzNjMJMzY2CTM3MgkzNzMJMzc0CTM3Ny4JMzgxLgkzODIJMzg0CTM5Mwkz
OTgJNDAxCTQwNQk0MDYJNDA4CTQxMQk0MjMJNDQzCTQ1MQk0NjcJNDg0CTQ5NQk0OTYuCTUw
MQk1MDcJNTA4CTUxMCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LWxrcC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxMzA2MDgwOToxMGFk
Y2RmOGQ3ODc3ZTg3ZjMwODQ2Nzg3MDlmZTc0ZjFlNDJhMjViOmJpc2VjdC1saW51eAogVEVT
VCBGQUlMVVJFCi9rZXJuZWwveDg2XzY0LWxrcC8xMGFkY2RmOGQ3ODc3ZTg3ZjMwODQ2Nzg3
MDlmZTc0ZjFlNDJhMjViL2RtZXNnLWt2bS1hbnQtMjQ3NzQtMjAxMzA2MTAxMzAzMzQtMy4x
MC4wLXJjNC0xMzMxOS1nMTBhZGNkZi01NDEKL2tlcm5lbC94ODZfNjQtbGtwLzEwYWRjZGY4
ZDc4NzdlODdmMzA4NDY3ODcwOWZlNzRmMWU0MmEyNWIvZG1lc2cta3ZtLWFudC0yNDc3NC0y
MDEzMDYxMTE1NTExMi0zLjEwLjAtcmM0LTEzMzE5LWcxMGFkY2RmLTU0MQova2VybmVsL3g4
Nl82NC1sa3AvMTBhZGNkZjhkNzg3N2U4N2YzMDg0Njc4NzA5ZmU3NGYxZTQyYTI1Yi9kbWVz
Zy1rdm0tYW50LTI1MTQzLTIwMTMwNjExMTIwNjAwLTMuMTAuMC1yYzQtMTMzMTktZzEwYWRj
ZGYtNTQxCi9rZXJuZWwveDg2XzY0LWxrcC8xMGFkY2RmOGQ3ODc3ZTg3ZjMwODQ2Nzg3MDlm
ZTc0ZjFlNDJhMjViL2RtZXNnLWt2bS1hbnQtMjUyNDAtMjAxMzA2MTAxNDA2MjktMy4xMC4w
LXJjNC0xMzMxOS1nMTBhZGNkZi01NDEKL2tlcm5lbC94ODZfNjQtbGtwLzEwYWRjZGY4ZDc4
NzdlODdmMzA4NDY3ODcwOWZlNzRmMWU0MmEyNWIvZG1lc2cta3ZtLWFudC0yNTI0MC0yMDEz
MDYxMTEyMDU0My0zLjEwLjAtcmM0LTEzMzE5LWcxMGFkY2RmLTU0MQova2VybmVsL3g4Nl82
NC1sa3AvMTBhZGNkZjhkNzg3N2U4N2YzMDg0Njc4NzA5ZmU3NGYxZTQyYTI1Yi9kbWVzZy1r
dm0tYW50LTI1MjQwLTIwMTMwNjEyMTg0NzQxLTMuMTAuMC1yYzQtMTMzMTktZzEwYWRjZGYt
NTQxCi9rZXJuZWwveDg2XzY0LWxrcC8xMGFkY2RmOGQ3ODc3ZTg3ZjMwODQ2Nzg3MDlmZTc0
ZjFlNDJhMjViL2RtZXNnLWt2bS1hbnQtMjUzMjItMjAxMzA2MDkwMTE5MjctMy4xMC4wLXJj
NC0xMzMxOS1nMTBhZGNkZi01NDEKL2tlcm5lbC94ODZfNjQtbGtwLzEwYWRjZGY4ZDc4Nzdl
ODdmMzA4NDY3ODcwOWZlNzRmMWU0MmEyNWIvZG1lc2cta3ZtLWFudC0yNTMyMi0yMDEzMDYx
MDA1MjQzNy0zLjEwLjAtcmM0LTEzMzE5LWcxMGFkY2RmLTU0MQova2VybmVsL3g4Nl82NC1s
a3AvMTBhZGNkZjhkNzg3N2U4N2YzMDg0Njc4NzA5ZmU3NGYxZTQyYTI1Yi9kbWVzZy1rdm0t
YW50LTI1NDU0LTIwMTMwNjEwMTMwMzQ1LTMuMTAuMC1yYzQtMTMzMTktZzEwYWRjZGYtNTQx
Ci9rZXJuZWwveDg2XzY0LWxrcC8xMGFkY2RmOGQ3ODc3ZTg3ZjMwODQ2Nzg3MDlmZTc0ZjFl
NDJhMjViL2RtZXNnLWt2bS1hbnQtMjU0NTQtMjAxMzA2MTAxNjA2MzAtMy4xMC4wLXJjNC0x
MzMxOS1nMTBhZGNkZi01NDEKL2tlcm5lbC94ODZfNjQtbGtwLzEwYWRjZGY4ZDc4NzdlODdm
MzA4NDY3ODcwOWZlNzRmMWU0MmEyNWIvZG1lc2cta3ZtLWFudC0yNTQ1NC0yMDEzMDYxMTE1
NTEzMS0zLjEwLjAtcmM0LTEzMzE5LWcxMGFkY2RmLTU0MQova2VybmVsL3g4Nl82NC1sa3Av
MTBhZGNkZjhkNzg3N2U4N2YzMDg0Njc4NzA5ZmU3NGYxZTQyYTI1Yi9kbWVzZy1rdm0tYW50
LTI1NzcyLTIwMTMwNjExMTU1MDU2LTMuMTAuMC1yYzQtMTMzMTktZzEwYWRjZGYtNTQxCi9r
ZXJuZWwveDg2XzY0LWxrcC8xMGFkY2RmOGQ3ODc3ZTg3ZjMwODQ2Nzg3MDlmZTc0ZjFlNDJh
MjViL2RtZXNnLWt2bS1hbnQtMjU4ODItMjAxMzA2MDgwOTU3MzMtMy4xMC4wLXJjNC0xMzMx
OS1nMTBhZGNkZi01NDEKL2tlcm5lbC94ODZfNjQtbGtwLzEwYWRjZGY4ZDc4NzdlODdmMzA4
NDY3ODcwOWZlNzRmMWU0MmEyNWIvZG1lc2cta3ZtLWFudC0yNTg4Mi0yMDEzMDYxMDEzMDMy
MS0zLjEwLjAtcmM0LTEzMzE5LWcxMGFkY2RmLTU0MQoKSEVBRCBpcyBub3cgYXQgMTBhZGNk
ZiBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhcm0tcGxhdGZvcm1zL2t2bS1hcm02
NC9rdm0nIGludG8gZGV2ZWwtaG91cmx5LTIwMTMwNjA4MDkKCj09PT09PT09PSB1cHN0cmVh
bSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1sa3AvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTMwNjA4MDk6
NzcyOTNlMjE1ZWRlZjc4NzFhMzlkZTRiMzI2Zjc3N2JjMzkyNzhjYTpiaXNlY3QtbGludXgK
CjIwMTMtMDYtMTMtMDE6NDY6MzAgNzcyOTNlMjE1ZWRlZjc4NzFhMzlkZTRiMzI2Zjc3N2Jj
MzkyNzhjYSByZXVzZSAva2VybmVsL3g4Nl82NC1sa3AvNzcyOTNlMjE1ZWRlZjc4NzFhMzlk
ZTRiMzI2Zjc3N2JjMzkyNzhjYS92bWxpbnV6LTMuMTAuMC1yYzUtMDAwNjEtZzc3MjkzZTIK
CjIwMTMtMDYtMTMtMDE6NDY6MzEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4JMTYJMzYJ
NzEJODEJODUJOTAJOTgJMTEwCTEyMgkxMzQJMTM3CTE0OAkxNjUJMTcyCTE3OC4JMTgwCTE5
MwkyMTcJMjIwCTIyMwkyNDcJMjc1CTI5MgkyOTkJMzA4CTMyMwkzNDUJMzc3CTM5Ngk0MDAJ
NDA2CTQxNgk0MzUJNDkzCTQ5OQk1MDAJNTA4CTUwOS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLgk1MTAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRj
aGluZyBuZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtw
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMDYwODA5OmMwNGVmZWQ3MzQ0MDlmNWE0
NDcxNWI1NGE2Y2ExYjU0YjBjY2YyMTU6YmlzZWN0LWxpbnV4CgoyMDEzLTA2LTEzLTAyOjIy
OjM2IGMwNGVmZWQ3MzQ0MDlmNWE0NDcxNWI1NGE2Y2ExYjU0YjBjY2YyMTUgcmV1c2UgL2tl
cm5lbC94ODZfNjQtbGtwL2MwNGVmZWQ3MzQ0MDlmNWE0NDcxNWI1NGE2Y2ExYjU0YjBjY2Yy
MTUvdm1saW51ei0zLjEwLjAtcmM0LW5leHQtMjAxMzA2MDcKCjIwMTMtMDYtMTMtMDI6MjI6
MzcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4JMjYJNDMJOTUJMTA0CTEyMgkxMzMJMTQ1
CTE0OAkxODgJMjA5CTI0OAkzMTQJMzUxCTM2NAkzODUJMzkxCTQwMQk0MTQJNDM1CTQ2MAk1
MDIuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTUwMy4JNTA0CTUwNS4JNTA2CTUwNy4JNTA4CTUxMCBTVUND
RVNTCgo=

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc4 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
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
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=256
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MOVABLE_NODE is not set
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
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
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
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
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
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
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

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
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

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
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD64 is not set
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
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
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
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
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
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
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_AVX2_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_OID_REGISTRY=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--cWoXeonUoKmBZSoM--
