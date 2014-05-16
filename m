From: Olaf Hering <olaf@aepfle.de>
Subject: 3.14: WARNING: sysfs group ffffffff81c50ca0 not found for kobject
 'target5:0:0'
Date: Fri, 16 May 2014 19:18:43 +0200
Message-ID: <20140516171842.GA4610@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


I did unplug an USB stick by accident with 3.14.4, the result is this
warning:


[94414.233882] usb 1-3: USB disconnect, device number 4
[94414.245377] scsi 5:0:0:0: rejecting I/O to offline device
[94414.245383] scsi 5:0:0:0: killing request
[94414.370354] FAT-fs (sdc1): unable to read boot sector to mark fs as dirty
[94414.370393] ------------[ cut here ]------------
[94414.370400] WARNING: CPU: 2 PID: 3619 at fs/sysfs/group.c:216 sysfs_remove_group+0xa1/0xb0()
[94414.370403] sysfs group ffffffff81c50ca0 not found for kobject 'target5:0:0'
[94414.370404] Modules linked in: usb_storage sha256_generic tun rfcomm bluetooth 6lowpan_iphc nfsd ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device xts gf128mul loop hp_accel uvcvideo videobuf2_core tpm_infineon videodev kvm_amd videobuf2_vmalloc videobuf2_memops snd_hda_codec_hdmi kvm joydev i2c_piix4 lis3lv02d snd_hda_codec_idt snd_hda_codec_generic sdhci_pci sdhci mmc_core snd_hda_intel snd_hda_codec snd_pcm snd_timer snd soundcore hp_wmi tpm_tis sparse_keymap k10temp tpm input_polldev led_class wmi radeon ttm drm_kms_helper drm
[94414.370441] CPU: 2 PID: 3619 Comm: umount Not tainted 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 #1
[94414.370443] Hardware name: Hewlett-Packard HP ProBook 6555b/1455, BIOS 68DTM Ver. F.20 09/15/2011
[94414.370445]  00000000000000d8 ffff880073ab7af8 ffffffff8172db82 ffff880073ab7b38
[94414.370449]  ffffffff81055882 ffff880073ab7b28 0000000000000000 ffffffff81c50ca0
[94414.370452]  ffff88009eac9838 ffff8801ef30e190 ffff88009eac9828 ffff880073ab7b98
[94414.370455] Call Trace:
[94414.370461]  [<ffffffff8172db82>] dump_stack+0x6a/0x78
[94414.370465]  [<ffffffff81055882>] warn_slowpath_common+0x82/0xb0
[94414.370468]  [<ffffffff81055951>] warn_slowpath_fmt+0x41/0x50
[94414.370472]  [<ffffffff81195c2e>] ? kernfs_find_and_get_ns+0x4e/0x60
[94414.370475]  [<ffffffff81193d01>] sysfs_remove_group+0xa1/0xb0
[94414.370479]  [<ffffffff81517592>] dpm_sysfs_remove+0x42/0x50
[94414.370482]  [<ffffffff8150f930>] device_del+0x40/0x1d0
[94414.370486]  [<ffffffff8153051f>] scsi_target_reap_usercontext+0x2f/0x50
[94414.370490]  [<ffffffff8106f1e5>] execute_in_process_context+0x55/0x60
[94414.370493]  [<ffffffff8152f531>] scsi_target_reap+0xc1/0xe0
[94414.370496]  [<ffffffff815319dc>] scsi_device_dev_release_usercontext+0x19c/0x1d0
[94414.370500]  [<ffffffff8106f1e5>] execute_in_process_context+0x55/0x60
[94414.370502]  [<ffffffff81531837>] scsi_device_dev_release+0x17/0x20
[94414.370505]  [<ffffffff8150ed42>] device_release+0x32/0xa0
[94414.370509]  [<ffffffff81437a07>] kobject_release+0x47/0x90
[94414.370512]  [<ffffffff81437a7b>] kobject_put+0x2b/0x60
[94414.370514]  [<ffffffff8150e4a2>] put_device+0x12/0x20
[94414.370517]  [<ffffffff81522c10>] scsi_device_put+0x40/0x60
[94414.370521]  [<ffffffff81535108>] scsi_disk_put+0x38/0x50
[94414.370523]  [<ffffffff81536692>] sd_release+0x52/0xd0
[94414.370527]  [<ffffffff8115f591>] __blkdev_put+0x1a1/0x1d0
[94414.370530]  [<ffffffff8115f4e4>] __blkdev_put+0xf4/0x1d0
[94414.370533]  [<ffffffff8115f618>] blkdev_put+0x58/0x150
[94414.370537]  [<ffffffff8112d375>] kill_block_super+0x45/0x80
[94414.370540]  [<ffffffff8112d785>] deactivate_locked_super+0x45/0x70
[94414.370543]  [<ffffffff8112de41>] deactivate_super+0x61/0x70
[94414.370547]  [<ffffffff81149134>] mntput_no_expire+0x134/0x1d0
[94414.370549]  [<ffffffff8114aade>] SyS_umount+0xce/0x3e0
[94414.370553]  [<ffffffff81049fc9>] ? do_page_fault+0x39/0x50
[94414.370557]  [<ffffffff817331b9>] system_call_fastpath+0x16/0x1b
[94414.370559] ---[ end trace 30a2ff6dc29ae7a9 ]---


full dmesg, .config is below.
Basesystem is openSUSE 11.4.

Olaf


[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 (abuild@cloud127) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP Tue May 13 12:44:19 UTC 2014
[    0.000000] Command line: quiet panic=9 sysrq_always_enabled showopts resume=/dev/disk/by-label/DBG1S82E_swap log_buf_len=32M
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000af3cefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000af3cf000-0x00000000afacefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000afacf000-0x00000000afbcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000afbcf000-0x00000000afbfefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000afbff000-0x00000000afbfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP ProBook 6555b/1455, BIOS 68DTM Ver. F.20 09/15/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 0000A0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 000100000000 mask FFFF00000000 write-back
[    0.000000]   4 base 000200000000 mask FFFFC0000000 write-back
[    0.000000]   5 base 0000FFE00000 mask FFFFFFE00000 write-protect
[    0.000000]   6 base 0000FFF40000 mask FFFFFFFF0000 write-protect
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000240000000 aka 9216M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xafc00 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 28672
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fe3000, 0x01fe3fff] PGTABLE
[    0.000000] BRK [0x01fe4000, 0x01fe4fff] PGTABLE
[    0.000000] BRK [0x01fe5000, 0x01fe5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23fe00000-0x23fffffff]
[    0.000000]  [mem 0x23fe00000-0x23fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x23c000000-0x23fdfffff]
[    0.000000]  [mem 0x23c000000-0x23fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x200000000-0x23bffffff]
[    0.000000]  [mem 0x200000000-0x23bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xaf3cefff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xaf1fffff] page 2M
[    0.000000]  [mem 0xaf200000-0xaf3cefff] page 4k
[    0.000000] init_memory_mapping: [mem 0xafbff000-0xafbfffff]
[    0.000000]  [mem 0xafbff000-0xafbfffff] page 4k
[    0.000000] BRK [0x01fe6000, 0x01fe6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] log_buf_len: 33554432
[    0.000000] early log buf free: 2092728(99%)
[    0.000000] RAMDISK: [mem 0x374c8000-0x37feffff]
[    0.000000] ACPI: RSDP 00000000000f2a70 000014 (v00 HPQOEM)
[    0.000000] ACPI: RSDT 00000000afbfe038 000044 (v01 HPQOEM SLIC-MPC 00000003      01000013)
[    0.000000] ACPI: FACP 00000000afbfd000 000074 (v01 HPQOEM 307E     00000003 HP   00000001)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20131218/tbfadt-634)
[    0.000000] ACPI: DSDT 00000000afbdd000 01C288 (v01 HPQOEM   SB700  00000001 INTL 20060912)
[    0.000000] ACPI: FACS 00000000afb7e000 000040
[    0.000000] ACPI: APIC 00000000afbfc000 000084 (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 00000000afbfb000 00003C (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: SLIC 00000000afbfa000 000176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
[    0.000000] ACPI: SSDT 00000000afbdc000 00005F (v01 HPQOEM   HPQNLP 00000001 INTL 20060912)
[    0.000000] ACPI: TCPA 00000000afbdb000 000032 (v02 HPQOEM 307E     00000000 HP   00000001)
[    0.000000] ACPI: HPET 00000000afbda000 000038 (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: SSDT 00000000afbd9000 0007AD (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880235a00000-ffff88023d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xaf3cefff]
[    0.000000]   node   0: [mem 0xafbff000-0xafbfffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000] On node 0 totalpages: 2028398
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11152 pages used for memmap
[    0.000000]   DMA32 zone: 713680 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538301 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 1 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xaf3cf000-0xafacefff]
[    0.000000] PM: Registered nosave memory: [mem 0xafacf000-0xafbcefff]
[    0.000000] PM: Registered nosave memory: [mem 0xafbcf000-0xafbfefff]
[    0.000000] PM: Registered nosave memory: [mem 0xafc00000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffdfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffe00000-0xffffffff]
[    0.000000] e820: [mem 0xafc00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88023dc00000 s80192 r8192 d22208 u524288
[    0.000000] pcpu-alloc: s80192 r8192 d22208 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1996680
[    0.000000] Kernel command line: quiet panic=9 sysrq_always_enabled showopts resume=/dev/disk/by-label/DBG1S82E_swap log_buf_len=32M
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Memory: 7847112K/8113592K available (7387K kernel code, 469K rwdata, 2588K rodata, 964K init, 2496K bss, 266480K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 32505856 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2094.654 MHz processor
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4189.30 BogoMIPS (lpj=8378616)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000016] ACPI: Core revision 20131218
[    0.004382] ACPI: All ACPI Tables successfully acquired
[    0.033722] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.033725] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.033963] Initializing cgroup subsys memory
[    0.033969] Initializing cgroup subsys devices
[    0.033971] Initializing cgroup subsys freezer
[    0.033973] Initializing cgroup subsys blkio
[    0.033975] Initializing cgroup subsys perf_event
[    0.033997] tseg: 00afc00000
[    0.034001] CPU: Physical Processor ID: 0
[    0.034002] CPU: Processor Core ID: 0
[    0.034004] mce: CPU supports 6 MCE banks
[    0.034009] LVT offset 0 assigned for vector 0xf9
[    0.034013] process: using AMD E400 aware idle routine
[    0.034016] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.034016] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.034016] tlb_flushall_shift: 6
[    0.034141] Freeing SMP alternatives memory: 36K (ffffffff81d68000 - ffffffff81d71000)
[    0.035518] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.075217] smpboot: CPU0: AMD Phenom(tm) II N830 Triple-Core Processor (fam: 10, model: 05, stepping: 03)
[    0.180548] Performance Events: AMD PMU driver.
[    0.180553] ... version:                0
[    0.180555] ... bit width:              48
[    0.180556] ... generic registers:      4
[    0.180558] ... value mask:             0000ffffffffffff
[    0.180559] ... max period:             00007fffffffffff
[    0.180560] ... fixed-purpose events:   0
[    0.180562] ... event mask:             000000000000000f
[    0.180713] MCE: In-kernel MCE decoding enabled.
[    0.180783] x86: Booting SMP configuration:
[    0.180785] .... node  #0, CPUs:      #1
[    0.193959] process: System has AMD C1E enabled
[    0.193975]  #2
[    0.193975] process: Switch to broadcast mode on CPU1
[    0.207051] x86: Booted up 1 node, 3 CPUs
[    0.207054] smpboot: Total of 3 processors activated (12567.92 BogoMIPS)
[    0.207095] process: Switch to broadcast mode on CPU2
[    0.207646] process: Switch to broadcast mode on CPU0
[    0.207783] devtmpfs: initialized
[    0.208101] PM: Registering ACPI NVS region [mem 0xafacf000-0xafbcefff] (1048576 bytes)
[    0.208233] xor: measuring software checksum speed
[    0.246043]    prefetch64-sse:  8218.000 MB/sec
[    0.286055]    generic_sse:  7725.000 MB/sec
[    0.286057] xor: using function: prefetch64-sse (8218.000 MB/sec)
[    0.286110] NET: Registered protocol family 16
[    0.286216] cpuidle: using governor ladder
[    0.286218] cpuidle: using governor menu
[    0.286223] node 0 link 0: io port [0, ffffff]
[    0.286225] TOM: 00000000c0000000 aka 3072M
[    0.286228] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    0.286231] node 0 link 0: mmio [c0000000, cfffffff]
[    0.286234] node 0 link 0: mmio [d0000000, d62fffff]
[    0.286236] node 0 link 0: mmio [d6300000, d64fffff]
[    0.286238] node 0 link 0: mmio [d6500000, dfffffff]
[    0.286240] node 0 link 0: mmio [e0000000, e0ffffff] ==> none
[    0.286243] node 0 link 0: mmio [e1000000, ffb7ffff] ==> [f0000000, ffb7ffff]
[    0.286245] TOM2: 0000000240000000 aka 9216M
[    0.286248] bus: [bus 00-1f] on node 0 link 0
[    0.286249] bus: 00 [io  0x0000-0xffff]
[    0.286251] bus: 00 [mem 0xc0000000-0xdfffffff]
[    0.286253] bus: 00 [mem 0xf0000000-0xffffffff]
[    0.286254] bus: 00 [mem 0x240000000-0xfcffffffff]
[    0.286313] ACPI: bus type PCI registered
[    0.286370] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.286373] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.299399] PCI: Using configuration type 1 for base access
[    0.299525] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.299527] mtrr: probably your BIOS does not setup all CPUs.
[    0.299528] mtrr: corrected configuration.
[    0.300618] bio: create slab <bio-0> at 0
[    0.366093] raid6: sse2x1    3064 MB/s
[    0.434121] raid6: sse2x2    4928 MB/s
[    0.502140] raid6: sse2x4    5968 MB/s
[    0.502143] raid6: using algorithm sse2x4 (5968 MB/s)
[    0.502144] raid6: using intx1 recovery algorithm
[    0.502178] ACPI: Added _OSI(Module Device)
[    0.502180] ACPI: Added _OSI(Processor Device)
[    0.502181] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.502183] ACPI: Added _OSI(Processor Aggregator Device)
[    0.505124] ACPI: Executed 1 blocks of module-level executable AML code
[    0.554170] ACPI: Interpreter enabled
[    0.554183] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
[    0.554188] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    0.554205] ACPI: (supports S0 S3 S4 S5)
[    0.554207] ACPI: Using IOAPIC for interrupt routing
[    0.554378] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.556639] ACPI: Power Resource [APPR] (off)
[    0.575285] ACPI: Power Resource [COMP] (on)
[    0.575619] ACPI: Power Resource [LPP] (off)
[    0.768147] ACPI: Power Resource [PFN0] (off)
[    0.768189] ACPI: Power Resource [PFN1] (off)
[    0.768227] ACPI: Power Resource [PFN2] (off)
[    0.768265] ACPI: Power Resource [PFN3] (off)
[    0.768301] ACPI: Power Resource [PFN4] (off)
[    0.768940] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.768947] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.768953] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.769077] acpi PNP0A03:00: host bridge window expanded to [mem 0xf0000000-0xffffffff]; [mem 0xf0000000-0xfffdffff] ignored
[    0.769082] acpi PNP0A03:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000cedff])
[    0.769120] PCI host bridge to bus 0000:00
[    0.769123] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.769126] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.769129] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.769131] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.769133] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.769136] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.769138] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.769140] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.769143] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.769145] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.769147] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.769149] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.769152] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.769154] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.769156] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.769159] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
[    0.769161] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xffffffff]
[    0.769164] pci_bus 0000:00: scanning bus
[    0.769176] pci 0000:00:00.0: [1022:9601] type 00 class 0x060000
[    0.769183] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x10
[    0.769286] pci 0000:00:01.0: [103c:9602] type 01 class 0x060400
[    0.769408] pci 0000:00:04.0: [1022:9604] type 01 class 0x060400
[    0.769449] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.769452] pci 0000:00:04.0: PME# disabled
[    0.769486] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.769524] pci 0000:00:05.0: [1022:9605] type 01 class 0x060400
[    0.769563] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.769566] pci 0000:00:05.0: PME# disabled
[    0.769598] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.769672] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
[    0.769711] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.769714] pci 0000:00:07.0: PME# disabled
[    0.769746] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.769789] pci 0000:00:09.0: [1022:9608] type 01 class 0x060400
[    0.769827] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.769830] pci 0000:00:09.0: PME# disabled
[    0.769862] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.769916] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.769935] pci 0000:00:11.0: reg 0x10: [io  0x7018-0x701f]
[    0.769945] pci 0000:00:11.0: reg 0x14: [io  0x7024-0x7027]
[    0.769954] pci 0000:00:11.0: reg 0x18: [io  0x7010-0x7017]
[    0.769964] pci 0000:00:11.0: reg 0x1c: [io  0x7020-0x7023]
[    0.769973] pci 0000:00:11.0: reg 0x20: [io  0x7000-0x700f]
[    0.769983] pci 0000:00:11.0: reg 0x24: [mem 0xd650b000-0xd650b3ff]
[    0.770090] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.770104] pci 0000:00:12.0: reg 0x10: [mem 0xd650a000-0xd650afff]
[    0.770218] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.770262] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.770281] pci 0000:00:12.2: reg 0x10: [mem 0xd6509000-0xd65090ff]
[    0.770360] pci 0000:00:12.2: supports D1 D2
[    0.770362] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.770366] pci 0000:00:12.2: PME# disabled
[    0.770399] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.770445] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.770459] pci 0000:00:13.0: reg 0x10: [mem 0xd6508000-0xd6508fff]
[    0.770551] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.770595] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.770614] pci 0000:00:13.2: reg 0x10: [mem 0xd6507000-0xd65070ff]
[    0.770692] pci 0000:00:13.2: supports D1 D2
[    0.770694] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.770698] pci 0000:00:13.2: PME# disabled
[    0.770731] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.770777] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.770783] pci 0000:00:14.0: calling sb600_disable_hpet_bar+0x0/0x50
[    0.770841] pci 0000:00:14.0: calling force_disable_hpet_msi+0x0/0x10
[    0.770911] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.770932] pci 0000:00:14.2: reg 0x10: [mem 0xd6500000-0xd6503fff 64bit]
[    0.770995] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.770999] pci 0000:00:14.2: PME# disabled
[    0.771030] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.771072] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.771194] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.771282] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.771296] pci 0000:00:14.5: reg 0x10: [mem 0xd6506000-0xd6506fff]
[    0.771410] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.771423] pci 0000:00:16.0: reg 0x10: [mem 0xd6505000-0xd6505fff]
[    0.771541] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.771559] pci 0000:00:16.2: reg 0x10: [mem 0xd6504000-0xd65040ff]
[    0.771637] pci 0000:00:16.2: supports D1 D2
[    0.771639] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.771643] pci 0000:00:16.2: PME# disabled
[    0.771717] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.771720] pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x10
[    0.771787] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.771790] pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x10
[    0.771848] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.771851] pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x10
[    0.771908] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.771911] pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x10
[    0.771973] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.771976] pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x10
[    0.772077] pci_bus 0000:00: fixups for bus
[    0.772080] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 0
[    0.772106] pci_bus 0000:01: scanning bus
[    0.772119] pci 0000:01:05.0: [1002:9712] type 00 class 0x030000
[    0.772128] pci 0000:01:05.0: reg 0x10: [mem 0xc0000000-0xcfffffff pref]
[    0.772133] pci 0000:01:05.0: reg 0x14: [io  0x6000-0x60ff]
[    0.772138] pci 0000:01:05.0: reg 0x18: [mem 0xd6400000-0xd640ffff]
[    0.772149] pci 0000:01:05.0: reg 0x24: [mem 0xd6300000-0xd63fffff]
[    0.772167] pci 0000:01:05.0: supports D1 D2
[    0.772208] pci 0000:01:05.1: [1002:970f] type 00 class 0x040300
[    0.772217] pci 0000:01:05.1: reg 0x10: [mem 0xd6410000-0xd6413fff]
[    0.772249] pci 0000:01:05.1: supports D1 D2
[    0.772346] pci_bus 0000:01: fixups for bus
[    0.772348] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.772352] pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
[    0.772355] pci 0000:00:01.0:   bridge window [mem 0xd6300000-0xd64fffff]
[    0.772359] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.772362] pci_bus 0000:01: bus scan returning with max=01
[    0.772365] pci 0000:00:04.0: scanning [bus 02-02] behind bridge, pass 0
[    0.772398] pci_bus 0000:02: scanning bus
[    0.772485] pci 0000:02:00.0: [11ab:4381] type 00 class 0x020000
[    0.772505] pci 0000:02:00.0: reg 0x10: [mem 0xd5200000-0xd5203fff 64bit]
[    0.772515] pci 0000:02:00.0: reg 0x18: [io  0x4000-0x40ff]
[    0.772551] pci 0000:02:00.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
[    0.772613] pci 0000:02:00.0: supports D1 D2
[    0.772615] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.772650] pci 0000:02:00.0: PME# disabled
[    0.772671] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.782298] pci_bus 0000:02: fixups for bus
[    0.782305] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.782310] pci 0000:00:04.0:   bridge window [io  0x4000-0x5fff]
[    0.782314] pci 0000:00:04.0:   bridge window [mem 0xd5200000-0xd62fffff]
[    0.782318] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.782321] pci_bus 0000:02: bus scan returning with max=02
[    0.782325] pci 0000:00:05.0: scanning [bus 03-03] behind bridge, pass 0
[    0.782383] pci_bus 0000:03: scanning bus
[    0.782434] pci 0000:03:00.0: [1180:e822] type 00 class 0x080500
[    0.782442] pci 0000:03:00.0: calling ricoh_mmc_fixup_r5c832+0x0/0x180
[    0.782451] pci 0000:03:00.0: MMC controller base frequency changed to 50Mhz.
[    0.782459] pci 0000:03:00.0: proprietary Ricoh MMC controller disabled (via firewire function)
[    0.782461] pci 0000:03:00.0: MMC cards are now supported by standard SDHCI controller
[    0.782475] pci 0000:03:00.0: reg 0x10: [mem 0xd4103000-0xd41030ff]
[    0.782584] pci 0000:03:00.0: supports D1 D2
[    0.782586] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.782591] pci 0000:03:00.0: PME# disabled
[    0.782690] pci 0000:03:00.1: [1180:e230] type 00 class 0x088000
[    0.782705] pci 0000:03:00.1: reg 0x10: [mem 0xd4102000-0xd41020ff]
[    0.782805] pci 0000:03:00.1: supports D1 D2
[    0.782807] pci 0000:03:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.782811] pci 0000:03:00.1: PME# disabled
[    0.782903] pci 0000:03:00.3: [1180:e832] type 00 class 0x0c0010
[    0.782918] pci 0000:03:00.3: reg 0x10: [mem 0xd4100000-0xd41007ff]
[    0.783018] pci 0000:03:00.3: supports D1 D2
[    0.783020] pci 0000:03:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.783024] pci 0000:03:00.3: PME# disabled
[    0.794307] pci_bus 0000:03: fixups for bus
[    0.794314] pci 0000:00:05.0: PCI bridge to [bus 03]
[    0.794319] pci 0000:00:05.0:   bridge window [io  0x3000-0x3fff]
[    0.794322] pci 0000:00:05.0:   bridge window [mem 0xd4100000-0xd51fffff]
[    0.794327] pci 0000:00:05.0:   bridge window [mem 0xd1000000-0xd1ffffff 64bit pref]
[    0.794329] pci_bus 0000:03: bus scan returning with max=03
[    0.794334] pci 0000:00:07.0: scanning [bus 04-06] behind bridge, pass 0
[    0.794387] pci_bus 0000:04: scanning bus
[    0.794390] pci_bus 0000:04: fixups for bus
[    0.794393] pci 0000:00:07.0: PCI bridge to [bus 04-06]
[    0.794397] pci 0000:00:07.0:   bridge window [io  0x2000-0x2fff]
[    0.794400] pci 0000:00:07.0:   bridge window [mem 0xd3100000-0xd40fffff]
[    0.794404] pci 0000:00:07.0:   bridge window [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.794406] pci_bus 0000:04: bus scan returning with max=04
[    0.794409] pci 0000:00:09.0: scanning [bus 07-07] behind bridge, pass 0
[    0.794445] pci_bus 0000:07: scanning bus
[    0.794448] pci_bus 0000:07: fixups for bus
[    0.794450] pci 0000:00:09.0: PCI bridge to [bus 07]
[    0.794455] pci 0000:00:09.0:   bridge window [mem 0xd3000000-0xd30fffff]
[    0.794458] pci_bus 0000:07: bus scan returning with max=07
[    0.794467] pci 0000:00:14.4: scanning [bus 08-08] behind bridge, pass 0
[    0.794488] pci_bus 0000:08: scanning bus
[    0.794535] pci_bus 0000:08: fixups for bus
[    0.794537] pci 0000:00:14.4: PCI bridge to [bus 08] (subtractive decode)
[    0.794542] pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
[    0.794548] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.794551] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.794553] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.794556] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
[    0.794558] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
[    0.794560] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
[    0.794563] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.794565] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.794567] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.794570] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.794572] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    0.794574] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    0.794577] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
[    0.794579] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
[    0.794581] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.794584] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
[    0.794586] pci_bus 0000:08: bus scan returning with max=08
[    0.794596] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 1
[    0.794600] pci 0000:00:04.0: scanning [bus 02-02] behind bridge, pass 1
[    0.794603] pci 0000:00:05.0: scanning [bus 03-03] behind bridge, pass 1
[    0.794607] pci 0000:00:07.0: scanning [bus 04-06] behind bridge, pass 1
[    0.794610] pci 0000:00:09.0: scanning [bus 07-07] behind bridge, pass 1
[    0.794615] pci 0000:00:14.4: scanning [bus 08-08] behind bridge, pass 1
[    0.794620] pci_bus 0000:00: bus scan returning with max=08
[    0.794692] pci_bus 0000:00: on NUMA node 0
[    0.858524] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.858597] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.858668] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.858737] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.858793] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.858837] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.858880] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.858924] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.859077] ACPI: Enabled 8 GPEs in block 00 to 1F
[    0.859131] ACPI : EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.859260] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.859264] vgaarb: loaded
[    0.859265] vgaarb: bridge control possible 0000:01:05.0
[    0.859337] SCSI subsystem initialized
[    0.859436] libata version 3.00 loaded.
[    0.859451] ACPI: bus type USB registered
[    0.859485] usbcore: registered new interface driver usbfs
[    0.859497] usbcore: registered new interface driver hub
[    0.859591] usbcore: registered new device driver usb
[    0.859617] pps_core: LinuxPPS API ver. 1 registered
[    0.859618] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.859622] PTP clock support registered
[    0.859640] PCI: Using ACPI for IRQ routing
[    0.867352] PCI: pci_cache_line_size set to 64 bytes
[    0.867368] pci 0000:01:05.0: BAR 0: reserving [mem 0xc0000000-0xcfffffff flags 0x42208] (d=0, p=0)
[    0.867372] pci 0000:01:05.0: BAR 1: reserving [io  0x6000-0x60ff flags 0x40101] (d=0, p=0)
[    0.867375] pci 0000:01:05.0: BAR 2: reserving [mem 0xd6400000-0xd640ffff flags 0x40200] (d=0, p=0)
[    0.867378] pci 0000:01:05.0: BAR 5: reserving [mem 0xd6300000-0xd63fffff flags 0x40200] (d=0, p=0)
[    0.867382] pci 0000:01:05.1: BAR 0: reserving [mem 0xd6410000-0xd6413fff flags 0x40200] (d=0, p=0)
[    0.867417] pci 0000:02:00.0: BAR 0: reserving [mem 0xd5200000-0xd5203fff flags 0x140204] (d=0, p=0)
[    0.867420] pci 0000:02:00.0: BAR 2: reserving [io  0x4000-0x40ff flags 0x40101] (d=0, p=0)
[    0.867456] pci 0000:03:00.0: BAR 0: reserving [mem 0xd4103000-0xd41030ff flags 0x40200] (d=0, p=0)
[    0.867461] pci 0000:03:00.1: BAR 0: reserving [mem 0xd4102000-0xd41020ff flags 0x40200] (d=0, p=0)
[    0.867465] pci 0000:03:00.3: BAR 0: reserving [mem 0xd4100000-0xd41007ff flags 0x40200] (d=0, p=0)
[    0.867475] pci 0000:00:11.0: BAR 0: reserving [io  0x7018-0x701f flags 0x40101] (d=0, p=0)
[    0.867478] pci 0000:00:11.0: BAR 1: reserving [io  0x7024-0x7027 flags 0x40101] (d=0, p=0)
[    0.867480] pci 0000:00:11.0: BAR 2: reserving [io  0x7010-0x7017 flags 0x40101] (d=0, p=0)
[    0.867483] pci 0000:00:11.0: BAR 3: reserving [io  0x7020-0x7023 flags 0x40101] (d=0, p=0)
[    0.867486] pci 0000:00:11.0: BAR 4: reserving [io  0x7000-0x700f flags 0x40101] (d=0, p=0)
[    0.867488] pci 0000:00:11.0: BAR 5: reserving [mem 0xd650b000-0xd650b3ff flags 0x40200] (d=0, p=0)
[    0.867493] pci 0000:00:12.0: BAR 0: reserving [mem 0xd650a000-0xd650afff flags 0x40200] (d=0, p=0)
[    0.867498] pci 0000:00:12.2: BAR 0: reserving [mem 0xd6509000-0xd65090ff flags 0x40200] (d=0, p=0)
[    0.867502] pci 0000:00:13.0: BAR 0: reserving [mem 0xd6508000-0xd6508fff flags 0x40200] (d=0, p=0)
[    0.867507] pci 0000:00:13.2: BAR 0: reserving [mem 0xd6507000-0xd65070ff flags 0x40200] (d=0, p=0)
[    0.867512] pci 0000:00:14.2: BAR 0: reserving [mem 0xd6500000-0xd6503fff flags 0x140204] (d=0, p=0)
[    0.867520] pci 0000:00:14.5: BAR 0: reserving [mem 0xd6506000-0xd6506fff flags 0x40200] (d=0, p=0)
[    0.867524] pci 0000:00:16.0: BAR 0: reserving [mem 0xd6505000-0xd6505fff flags 0x40200] (d=0, p=0)
[    0.867529] pci 0000:00:16.2: BAR 0: reserving [mem 0xd6504000-0xd65040ff flags 0x40200] (d=0, p=0)
[    0.867628] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.867630] e820: reserve RAM buffer [mem 0xaf3cf000-0xafffffff]
[    0.867632] e820: reserve RAM buffer [mem 0xafc00000-0xafffffff]
[    0.867787] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.867791] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.869869] Switched to clocksource hpet
[    0.869962] pnp: PnP ACPI init
[    0.869976] ACPI: bus type PNP registered
[    0.870104] pnp 00:00: [dma 4]
[    0.870137] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.870178] pnp 00:01: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.870288] pnp 00:02: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.870316] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.870423] system 00:04: [io  0x0400-0x04cf] could not be reserved
[    0.870426] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.870429] system 00:04: [io  0x04d6] has been reserved
[    0.870432] system 00:04: [io  0x0680-0x06ff] has been reserved
[    0.870434] system 00:04: [io  0x077a] has been reserved
[    0.870437] system 00:04: [io  0x0c00-0x0c01] has been reserved
[    0.870439] system 00:04: [io  0x0c14] has been reserved
[    0.870443] system 00:04: [io  0x0c50-0x0c52] has been reserved
[    0.870445] system 00:04: [io  0x0c6c] has been reserved
[    0.870448] system 00:04: [io  0x0c6f] has been reserved
[    0.870450] system 00:04: [io  0x0cd0-0x0cdb] has been reserved
[    0.870453] system 00:04: [io  0x0220-0x0227] has been reserved
[    0.870455] system 00:04: [io  0x0260-0x0273] has been reserved
[    0.870458] system 00:04: [io  0x0800] has been reserved
[    0.870460] system 00:04: [io  0x0804] has been reserved
[    0.870463] system 00:04: [io  0x087f] has been reserved
[    0.870465] system 00:04: [io  0x0cdc-0x0cdf] has been reserved
[    0.870468] system 00:04: [io  0x0b00-0x0b0f] has been reserved
[    0.870470] system 00:04: [io  0x0b20-0x0b3f] has been reserved
[    0.870473] system 00:04: [io  0x0200-0x027f] could not be reserved
[    0.870477] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.870557] system 00:05: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.870560] system 00:05: [mem 0x000ec000-0x000fffff] could not be reserved
[    0.870563] system 00:05: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.870566] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    0.870569] system 00:05: [mem 0xfeb00000-0xfeb00fff] has been reserved
[    0.870571] system 00:05: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.870574] system 00:05: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.870577] system 00:05: [mem 0xffe00000-0xffffffff] has been reserved
[    0.870580] system 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.870671] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.870764] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.871159] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.871235] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.871269] pnp 00:0a: Plug and Play ACPI device, IDs SYN0178 SYN0100 SYN0002 PNP0f13 (active)
[    0.918090] pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.918351] pnp: PnP ACPI: found 12 devices
[    0.918353] ACPI: bus type PNP unregistered
[    0.925756] pci 0000:02:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.925790] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.925793] pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
[    0.925797] pci 0000:00:01.0:   bridge window [mem 0xd6300000-0xd64fffff]
[    0.925801] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.925808] pci 0000:02:00.0: BAR 6: assigned [mem 0xd0000000-0xd001ffff pref]
[    0.925811] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.925814] pci 0000:00:04.0:   bridge window [io  0x4000-0x5fff]
[    0.925817] pci 0000:00:04.0:   bridge window [mem 0xd5200000-0xd62fffff]
[    0.925821] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.925826] pci 0000:00:05.0: PCI bridge to [bus 03]
[    0.925828] pci 0000:00:05.0:   bridge window [io  0x3000-0x3fff]
[    0.925832] pci 0000:00:05.0:   bridge window [mem 0xd4100000-0xd51fffff]
[    0.925835] pci 0000:00:05.0:   bridge window [mem 0xd1000000-0xd1ffffff 64bit pref]
[    0.925839] pci 0000:00:07.0: PCI bridge to [bus 04-06]
[    0.925842] pci 0000:00:07.0:   bridge window [io  0x2000-0x2fff]
[    0.925845] pci 0000:00:07.0:   bridge window [mem 0xd3100000-0xd40fffff]
[    0.925848] pci 0000:00:07.0:   bridge window [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.925852] pci 0000:00:09.0: PCI bridge to [bus 07]
[    0.925856] pci 0000:00:09.0:   bridge window [mem 0xd3000000-0xd30fffff]
[    0.925861] pci 0000:00:14.4: PCI bridge to [bus 08]
[    0.925868] pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
[    0.925890] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.925893] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.925895] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.925897] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.925899] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.925901] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.925904] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.925906] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.925908] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.925910] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    0.925912] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.925914] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.925916] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.925919] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    0.925921] pci_bus 0000:00: resource 18 [mem 0xc0000000-0xdfffffff]
[    0.925923] pci_bus 0000:00: resource 19 [mem 0xf0000000-0xffffffff]
[    0.925925] pci_bus 0000:01: resource 0 [io  0x6000-0x6fff]
[    0.925928] pci_bus 0000:01: resource 1 [mem 0xd6300000-0xd64fffff]
[    0.925930] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.925933] pci_bus 0000:02: resource 0 [io  0x4000-0x5fff]
[    0.925935] pci_bus 0000:02: resource 1 [mem 0xd5200000-0xd62fffff]
[    0.925937] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xd0ffffff 64bit pref]
[    0.925940] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.925942] pci_bus 0000:03: resource 1 [mem 0xd4100000-0xd51fffff]
[    0.925944] pci_bus 0000:03: resource 2 [mem 0xd1000000-0xd1ffffff 64bit pref]
[    0.925947] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.925949] pci_bus 0000:04: resource 1 [mem 0xd3100000-0xd40fffff]
[    0.925951] pci_bus 0000:04: resource 2 [mem 0xd2000000-0xd2ffffff 64bit pref]
[    0.925954] pci_bus 0000:07: resource 1 [mem 0xd3000000-0xd30fffff]
[    0.925956] pci_bus 0000:08: resource 0 [io  0x1000-0x1fff]
[    0.925959] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.925961] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.925963] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.925965] pci_bus 0000:08: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.925967] pci_bus 0000:08: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.925970] pci_bus 0000:08: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.925972] pci_bus 0000:08: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.925974] pci_bus 0000:08: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.925976] pci_bus 0000:08: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.925978] pci_bus 0000:08: resource 13 [mem 0x000dc000-0x000dffff]
[    0.925980] pci_bus 0000:08: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.925982] pci_bus 0000:08: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.925985] pci_bus 0000:08: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.925987] pci_bus 0000:08: resource 17 [mem 0x000ec000-0x000effff]
[    0.925989] pci_bus 0000:08: resource 18 [mem 0xc0000000-0xdfffffff]
[    0.925991] pci_bus 0000:08: resource 19 [mem 0xf0000000-0xffffffff]
[    0.926023] NET: Registered protocol family 2
[    0.926146] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.926318] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.926611] TCP: Hash tables configured (established 65536 bind 65536)
[    0.926659] TCP: reno registered
[    0.926663] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.926716] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.926817] NET: Registered protocol family 1
[    0.927001] RPC: Registered named UNIX socket transport module.
[    0.927006] RPC: Registered udp transport module.
[    0.927008] RPC: Registered tcp transport module.
[    0.927009] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.927025] pci 0000:00:00.0: calling quirk_amd_780_apc_msi+0x0/0x50
[    0.927029] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.927047] pci 0000:00:11.0: calling quirk_msi_intx_disable_ati_bug+0x0/0x50
[    0.927059] pci 0000:00:12.0: calling quirk_usb_early_handoff+0x0/0x770
[    0.982170] pci 0000:00:12.2: calling quirk_usb_early_handoff+0x0/0x770
[    0.982399] pci 0000:00:13.0: calling quirk_usb_early_handoff+0x0/0x770
[    1.038168] pci 0000:00:13.2: calling quirk_usb_early_handoff+0x0/0x770
[    1.038389] PCI: CLS mismatch (64 != 32), using 64 bytes
[    1.038397] pci 0000:00:14.5: calling quirk_usb_early_handoff+0x0/0x770
[    1.094180] pci 0000:00:16.0: calling quirk_usb_early_handoff+0x0/0x770
[    1.150201] pci 0000:00:16.2: calling quirk_usb_early_handoff+0x0/0x770
[    1.150423] pci 0000:01:05.0: calling pci_fixup_video+0x0/0xe0
[    1.150427] pci 0000:01:05.0: Boot video device
[    1.150491] Unpacking initramfs...
[    1.367070] Freeing initrd memory: 11424K (ffff8800374c8000 - ffff880037ff0000)
[    1.367077] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.367081] software IO TLB [mem 0xab3cf000-0xaf3cf000] (64MB) mapped at [ffff8800ab3cf000-ffff8800af3cefff]
[    1.367285] LVT offset 1 assigned for vector 0x400
[    1.367295] IBS: LVT offset 1 assigned
[    1.367327] perf: AMD IBS detected (0x0000001f)
[    1.367356] Scanning for low memory corruption every 60 seconds
[    1.367669] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    1.370366] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.370723] NFS: Registering the id_resolver key type
[    1.370733] Key type id_resolver registered
[    1.370734] Key type id_legacy registered
[    1.370738] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.370750] NTFS driver 2.1.30 [Flags: R/O].
[    1.370886] fuse init (API version 7.22)
[    1.371066] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    1.371605] msgmni has been set to 15348
[    1.371864] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    1.371866] io scheduler noop registered
[    1.371868] io scheduler deadline registered
[    1.371874] io scheduler cfq registered (default)
[    1.372114] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    1.372274] pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
[    1.372421] pcieport 0000:00:07.0: irq 42 for MSI/MSI-X
[    1.372570] pcieport 0000:00:09.0: irq 43 for MSI/MSI-X
[    1.594267] ACPI: AC Adapter [AC] (on-line)
[    1.594365] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    1.594369] ACPI: Sleep Button [SLPB]
[    1.594413] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.594443] ACPI: Lid Switch [LID]
[    1.594489] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.594491] ACPI: Power Button [PWRF]
[    1.594562] ACPI: Fan [FAN0] (off)
[    1.594598] ACPI: Fan [FAN1] (off)
[    1.594632] ACPI: Fan [FAN2] (off)
[    1.594666] ACPI: Fan [FAN3] (off)
[    1.594700] ACPI: Fan [FAN4] (off)
[    1.594714] ACPI: processor limited to max C-state 1
[    1.600420] thermal LNXTHERM:00: registered as thermal_zone0
[    1.600424] ACPI: Thermal Zone [CPUZ] (75 C)
[    1.615375] thermal LNXTHERM:01: registered as thermal_zone1
[    1.615379] ACPI: Thermal Zone [TZ3] (32 C)
[    1.615511] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.636016] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.636679] Non-volatile memory driver v1.3
[    1.636681] Linux agpgart interface v0.103
[    1.637056] ahci 0000:00:11.0: version 3.0
[    1.637320] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 5 ports 6 Gbps 0x1f impl SATA mode
[    1.637325] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[    1.638205] scsi0 : ahci
[    1.638453] scsi1 : ahci
[    1.638708] scsi2 : ahci
[    1.638990] scsi3 : ahci
[    1.639235] scsi4 : ahci
[    1.639310] ata1: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b100 irq 19
[    1.639313] ata2: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b180 irq 19
[    1.639317] ata3: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b200 irq 19
[    1.639320] ata4: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b280 irq 19
[    1.639323] ata5: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b300 irq 19
[    1.639403] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.639404] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    1.639424] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    1.639425] igb: Copyright (c) 2007-2013 Intel Corporation.
[    1.639442] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.2-k
[    1.639444] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    1.639458] sky2: driver version 1.30
[    1.639773] sky2 0000:02:00.0: Yukon-2 Optima chip revision 1
[    2.346223] sky2 0000:02:00.0: irq 44 for MSI/MSI-X
[    2.346599] sky2 0000:02:00.0 eth0: addr 1c:c1:de:91:f5:1c
[    2.366425] tsc: Refined TSC clocksource calibration: 2094.754 MHz
[    2.371244] ACPI: Battery Slot [BAT0] (battery present)
[    2.371308] ACPI: Battery Slot [BAT1] (battery absent)
[    2.402500] firewire_ohci 0000:03:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    2.402537] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.402539] ehci-pci: EHCI PCI platform driver
[    2.402709] QUIRK: Enable AMD PLL fix
[    2.402724] ehci-pci 0000:00:12.2: enabling bus mastering
[    2.402740] ehci-pci 0000:00:12.2: EHCI Host Controller
[    2.402747] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    2.402752] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.402763] ehci-pci 0000:00:12.2: debug port 1
[    2.402784] ehci-pci 0000:00:12.2: enabling Mem-Wr-Inval
[    2.402804] ehci-pci 0000:00:12.2: irq 17, io mem 0xd6509000
[    2.414463] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.414788] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.414793] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.414796] usb usb1: Product: EHCI Host Controller
[    2.414799] usb usb1: Manufacturer: Linux 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 ehci_hcd
[    2.414801] usb usb1: SerialNumber: 0000:00:12.2
[    2.415083] hub 1-0:1.0: USB hub found
[    2.415137] hub 1-0:1.0: 5 ports detected
[    2.415845] ehci-pci 0000:00:13.2: enabling bus mastering
[    2.415859] ehci-pci 0000:00:13.2: EHCI Host Controller
[    2.415867] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    2.415871] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.415883] ehci-pci 0000:00:13.2: debug port 1
[    2.415905] ehci-pci 0000:00:13.2: enabling Mem-Wr-Inval
[    2.415914] ehci-pci 0000:00:13.2: irq 17, io mem 0xd6507000
[    2.426478] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.426758] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.426763] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.426766] usb usb2: Product: EHCI Host Controller
[    2.426768] usb usb2: Manufacturer: Linux 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 ehci_hcd
[    2.426771] usb usb2: SerialNumber: 0000:00:13.2
[    2.427007] hub 2-0:1.0: USB hub found
[    2.427058] hub 2-0:1.0: 5 ports detected
[    2.427769] ehci-pci 0000:00:16.2: enabling bus mastering
[    2.427783] ehci-pci 0000:00:16.2: EHCI Host Controller
[    2.427790] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 3
[    2.427795] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.427806] ehci-pci 0000:00:16.2: debug port 1
[    2.427828] ehci-pci 0000:00:16.2: enabling Mem-Wr-Inval
[    2.427836] ehci-pci 0000:00:16.2: irq 17, io mem 0xd6504000
[    2.438488] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    2.438787] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.438792] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.438794] usb usb3: Product: EHCI Host Controller
[    2.438797] usb usb3: Manufacturer: Linux 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 ehci_hcd
[    2.438799] usb usb3: SerialNumber: 0000:00:16.2
[    2.439028] hub 3-0:1.0: USB hub found
[    2.439080] hub 3-0:1.0: 4 ports detected
[    2.439486] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.439497] ohci-pci: OHCI PCI platform driver
[    2.439676] ohci-pci 0000:00:12.0: enabling bus mastering
[    2.439683] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    2.439689] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 4
[    2.439720] ohci-pci 0000:00:12.0: irq 18, io mem 0xd650a000
[    2.498802] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.498806] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.498808] usb usb4: Product: OHCI PCI host controller
[    2.498811] usb usb4: Manufacturer: Linux 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 ohci_hcd
[    2.498813] usb usb4: SerialNumber: 0000:00:12.0
[    2.499047] hub 4-0:1.0: USB hub found
[    2.499106] hub 4-0:1.0: 5 ports detected
[    2.499796] ohci-pci 0000:00:13.0: enabling bus mastering
[    2.499804] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    2.499811] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.499838] ohci-pci 0000:00:13.0: irq 18, io mem 0xd6508000
[    2.558792] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.558797] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.558799] usb usb5: Product: OHCI PCI host controller
[    2.558802] usb usb5: Manufacturer: Linux 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 ohci_hcd
[    2.558804] usb usb5: SerialNumber: 0000:00:13.0
[    2.559044] hub 5-0:1.0: USB hub found
[    2.559101] hub 5-0:1.0: 5 ports detected
[    2.559795] ohci-pci 0000:00:14.5: enabling bus mastering
[    2.559803] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    2.559810] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 6
[    2.559839] ohci-pci 0000:00:14.5: irq 18, io mem 0xd6506000
[    2.618811] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.618816] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.618818] usb usb6: Product: OHCI PCI host controller
[    2.618821] usb usb6: Manufacturer: Linux 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 ohci_hcd
[    2.618823] usb usb6: SerialNumber: 0000:00:14.5
[    2.619059] hub 6-0:1.0: USB hub found
[    2.619112] hub 6-0:1.0: 2 ports detected
[    2.619606] ohci-pci 0000:00:16.0: enabling bus mastering
[    2.619615] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    2.619621] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 7
[    2.619650] ohci-pci 0000:00:16.0: irq 18, io mem 0xd6505000
[    2.658569] ata3: SATA link down (SStatus 0 SControl 300)
[    2.670583] ata4: SATA link down (SStatus 0 SControl 300)
[    2.678883] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.678887] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.678889] usb usb7: Product: OHCI PCI host controller
[    2.678892] usb usb7: Manufacturer: Linux 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 ohci_hcd
[    2.678894] usb usb7: SerialNumber: 0000:00:16.0
[    2.679116] hub 7-0:1.0: USB hub found
[    2.679173] hub 7-0:1.0: 4 ports detected
[    2.679562] uhci_hcd: USB Universal Host Controller Interface driver
[    2.679632] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.681308] i8042: Detected active multiplexing controller, rev 1.1
[    2.682035] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.682045] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.682048] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.682050] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.682052] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.682188] mousedev: PS/2 mouse device common for all mice
[    2.682521] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    2.682601] rtc_cmos 00:06: RTC can wake from S4
[    2.682744] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.682772] rtc_cmos 00:06: alarms up to one day, 114 bytes nvram, hpet irqs
[    2.682853] device-mapper: uevent: version 1.0.3
[    2.682958] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    2.683089] hidraw: raw HID events driver (C) Jiri Kosina
[    2.683192] usbcore: registered new interface driver usbhid
[    2.683193] usbhid: USB HID core driver
[    2.683252] TCP: cubic registered
[    2.683255] NET: Registered protocol family 17
[    2.683280] Key type dns_resolver registered
[    2.683619] registered taskstats version 1
[    2.683841] bio: create slab <bio-1> at 1
[    2.684181] Btrfs loaded
[    2.684724] rtc_cmos 00:06: setting system clock to 2014-05-15 14:57:35 UTC (1400165855)
[    2.684779] acpi-cpufreq: overriding BIOS provided _PSD data
[    2.684945] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    2.707201] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.726595] usb 1-5: new high-speed USB device number 2 using ehci-pci
[    2.830623] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.838639] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.838675] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.840372] ata5.00: ATA-8: ST3500418AS, CC45, max UDMA/133
[    2.840377] ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.840587] ata1.00: ATA-8: HGST HTE541515A9E630, KA0OA560, max UDMA/133
[    2.840593] ata1.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.841516] ata2.00: ATAPI: hp      DVD RW AD-7586H, KH04, max UDMA/100
[    2.841707] ata5.00: configured for UDMA/133
[    2.842600] ata1.00: configured for UDMA/133
[    2.842814] scsi 0:0:0:0: Direct-Access     ATA      HGST HTE541515A9 KA0O PQ: 0 ANSI: 5
[    2.843029] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.843055] sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.843061] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.843200] sd 0:0:0:0: [sda] Write Protect is off
[    2.843203] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.843310] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.851631] ata2.00: configured for UDMA/100
[    2.854888] scsi 1:0:0:0: CD-ROM            hp       DVD RW AD-7586H  KH04 PQ: 0 ANSI: 5
[    2.867272] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.867278] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.867489] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.867624] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.867960] scsi 4:0:0:0: Direct-Access     ATA      ST3500418AS      CC45 PQ: 0 ANSI: 5
[    2.868160] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    2.868187] sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.868449] sd 4:0:0:0: [sdb] Write Protect is off
[    2.868455] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.868595] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.890584] usb 1-5: New USB device found, idVendor=0461, idProduct=4db6
[    2.890589] usb 1-5: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.890592] usb 1-5: Product: Villem
[    2.890594] usb 1-5: Manufacturer: Primax Electronics Ltd.
[    2.890597] usb 1-5: SerialNumber: PMX01
[    2.902760] firewire_core 0000:03:00.3: created device fw0: GUID 5566778811223344, S400
[    2.916771]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    2.917836] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.006737] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    3.139359] usb 2-1: New USB device found, idVendor=1a40, idProduct=0101
[    3.139364] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.139366] usb 2-1: Product: USB 2.0 Hub
[    3.139606] hub 2-1:1.0: USB hub found
[    3.139731] hub 2-1:1.0: 4 ports detected
[    3.366916] Switched to clocksource tsc
[    3.426912] usb 2-1.1: new low-speed USB device number 3 using ehci-pci
[    3.540709] usb 2-1.1: New USB device found, idVendor=413c, idProduct=2106
[    3.540716] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.540720] usb 2-1.1: Product: Dell QuietKey Keyboard
[    3.540724] usb 2-1.1: Manufacturer: DELL
[    3.544295] input: DELL Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.1/2-1.1:1.0/0003:413C:2106.0001/input/input13
[    3.544463] hid-generic 0003:413C:2106.0001: input,hidraw0: USB HID v1.10 Keyboard [DELL Dell QuietKey Keyboard] on usb-0000:00:13.2-1.1/input0
[    3.596325] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.4, id: 0x1c0b1, caps: 0xd04773/0xa40000/0xa0400, board id: 3655, fw id: 643134
[    3.630967] usb 2-1.3: new low-speed USB device number 4 using ehci-pci
[    3.640026] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input12
[    3.750628] usb 2-1.3: New USB device found, idVendor=1ea7, idProduct=0002
[    3.750635] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.750640] usb 2-1.3: Product: 2.4GHZ Mouse
[    3.754343] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.0/0003:1EA7:0002.0002/input/input14
[    3.754595] hid-generic 0003:1EA7:0002.0002: input,hidraw1: USB HID v1.10 Keyboard [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input0
[    3.762085] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.1/0003:1EA7:0002.0003/input/input15
[    3.762617] hid-generic 0003:1EA7:0002.0003: input,hiddev0,hidraw2: USB HID v1.10 Mouse [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input1
[    6.725157]  sdb: sdb1
[    6.726290] sd 4:0:0:0: [sdb] Attached SCSI disk
[    6.728325] Freeing unused kernel memory: 964K (ffffffff81c77000 - ffffffff81d68000)
[    6.728331] Write protecting the kernel read-only data: 12288k
[    6.732855] Freeing unused kernel memory: 792K (ffff88000173a000 - ffff880001800000)
[    6.741492] Freeing unused kernel memory: 1508K (ffff880001a87000 - ffff880001c00000)
[    6.850834] udev[102]: starting version 166
[    6.885552] [drm] Initialized drm 1.1.0 20060810
[    6.935407] [drm] radeon kernel modesetting enabled.
[    6.969224] [drm] initializing kernel modesetting (RS880 0x1002:0x9712 0x103C:0x1455).
[    6.969270] [drm] register mmio base: 0xD6400000
[    6.969275] [drm] register mmio size: 65536
[    6.970209] ATOM BIOS: HP_Timex
[    6.970255] radeon 0000:01:05.0: VRAM: 320M 0x00000000C0000000 - 0x00000000D3FFFFFF (320M used)
[    6.970263] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    6.970272] [drm] Detected VRAM RAM=320M, BAR=256M
[    6.970277] [drm] RAM width 32bits DDR
[    6.974430] [TTM] Zone  kernel: Available graphics memory: 3930918 kiB
[    6.974439] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    6.974443] [TTM] Initializing pool allocator
[    6.974460] [TTM] Initializing DMA pool allocator
[    6.974505] [drm] radeon: 320M of VRAM memory ready
[    6.974510] [drm] radeon: 512M of GTT memory ready.
[    6.974560] [drm] Loading RS780 Microcode
[    6.974713] [drm] radeon: power management initialized
[    6.974723] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.989612] [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
[    6.989736] radeon 0000:01:05.0: WB enabled
[    6.989746] radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffff88022fc34c00
[    6.989752] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.989755] [drm] Driver supports precise vblank timestamp query.
[    6.989784] [drm] radeon: irq initialized.
[    7.022919] [drm] ring test on 0 succeeded in 0 usecs
[    7.023725] [drm] ib test on ring 0 succeeded in 0 usecs
[    7.026473] [drm] radeon atom DIG backlight initialized
[    7.026479] [drm] Radeon Display Connectors
[    7.026482] [drm] Connector 0:
[    7.026486] [drm]   VGA-1
[    7.026492] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    7.026495] [drm]   Encoders:
[    7.026498] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    7.026502] [drm] Connector 1:
[    7.026505] [drm]   LVDS-1
[    7.026510] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    7.026513] [drm]   Encoders:
[    7.026516] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
[    7.026519] [drm] Connector 2:
[    7.026522] [drm]   DP-1
[    7.026525] [drm]   HPD1
[    7.026530] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[    7.026533] [drm]   Encoders:
[    7.026536] [drm]     DFP1: INTERNAL_UNIPHY
[    7.026539] [drm] Connector 3:
[    7.026542] [drm]   DP-2
[    7.026545] [drm]   HPD2
[    7.026550] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[    7.026553] [drm]   Encoders:
[    7.026556] [drm]     DFP2: INTERNAL_UNIPHY
[    7.403962] random: nonblocking pool is initialized
[    8.043808] [drm] fb mappable at 0xC0141000
[    8.043817] [drm] vram apper at 0xC0000000
[    8.043822] [drm] size 5787648
[    8.043826] [drm] fb depth is 24
[    8.043830] [drm]    pitch is 6400
[    8.044041] fbcon: radeondrmfb (fb0) is primary device
[    8.107732] Console: switching to colour frame buffer device 200x56
[    8.122921] radeon 0000:01:05.0: fb0: radeondrmfb frame buffer device
[    8.122928] radeon 0000:01:05.0: registered panic notifier
[    8.123074] [drm] Initialized radeon 2.37.0 20080528 for 0000:01:05.0 on minor 0
[    8.347711] PM: Starting manual resume from disk
[    8.548113] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    8.787733] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr
[   11.974535] udev[486]: starting version 166
[   12.079024] wmi: Mapper loaded
[   12.211342] tpm_tis 00:02: 1.2 TPM (device-id 0xB, rev-id 16)
[   12.222199] sdhci: Secure Digital Host Controller Interface driver
[   12.222205] sdhci: Copyright(c) Pierre Ossman
[   12.223034] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 1)
[   12.259233] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input17
[   12.282103] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   12.282254] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
[   12.282901] input: HP WMI hotkeys as /devices/virtual/input/input16
[   12.344896] ACPI Warning: SystemIO range 0x0000000000000b00-0x0000000000000b07 conflicts with OpRegion 0x0000000000000b00-0x0000000000000b06 (\_SB_.PCI0.SMBS.SMBO) (20131218/utaddress-258)
[   12.344910] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   12.445850] hp_wmi: device hp-wifi blocked by BIOS
[   12.449344] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/input18
[   12.449719] tpm_tis 00:02: TPM is disabled/deactivated (0x7)
[   12.483736] kvm: Nested Virtualization enabled
[   12.483745] kvm: Nested Paging enabled
[   12.485108] Linux video capture interface: v2.00
[   12.574072] uvcvideo: Found UVC 1.00 device Villem (0461:4db6)
[   12.582141] input: Villem as /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/input/input19
[   12.582298] usbcore: registered new interface driver uvcvideo
[   12.582301] USB Video Class driver (1.1.1)
[   12.586611] input: HDA ATI SB Dock Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input23
[   12.586772] input: HDA ATI SB Line Out as /devices/pci0000:00/0000:00:14.2/sound/card0/input22
[   12.586873] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input21
[   12.586969] input: HDA ATI SB Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input20
[   12.591008] hp_accel: hardware type HPB655x found
[   12.591754] lis3lv02d: 8 bits sensor found
[   12.633903] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input24
[   14.045770] Adding 8384508k swap on /dev/sda6.  Priority:-1 extents:1 across:8384508k 
[   15.353204] loop: module loaded
[   38.064167] bio: create slab <bio-2> at 2
[   38.308545] bio: create slab <bio-2> at 2
[   43.284978] kjournald starting.  Commit interval 5 seconds
[   43.285017] EXT3-fs (sda2): mounted filesystem with ordered data mode
[   43.356199] kjournald starting.  Commit interval 5 seconds
[   43.358801] EXT3-fs (sda5): using internal journal
[   43.358813] EXT3-fs (sda5): mounted filesystem with journal data mode
[   43.421222] kjournald starting.  Commit interval 5 seconds
[   43.422195] EXT3-fs (dm-3): using internal journal
[   43.422208] EXT3-fs (dm-3): mounted filesystem with journal data mode
[   43.546077] kjournald starting.  Commit interval 5 seconds
[   43.548684] EXT3-fs (dm-4): using internal journal
[   43.548696] EXT3-fs (dm-4): mounted filesystem with journal data mode
[   43.682260] kjournald starting.  Commit interval 5 seconds
[   43.684720] EXT3-fs (dm-2): using internal journal
[   43.684733] EXT3-fs (dm-2): mounted filesystem with writeback data mode
[   43.738664] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[   43.948272] ISO 9660 Extensions: Microsoft Joliet Level 3
[   43.977866] ISO 9660 Extensions: RRIP_1991A
[   44.308286] ISO 9660 Extensions: Microsoft Joliet Level 3
[   44.483729] ISO 9660 Extensions: RRIP_1991A
[   44.619463] ISO 9660 Extensions: Microsoft Joliet Level 3
[   44.649010] ISO 9660 Extensions: RRIP_1991A
[   44.950667] ISO 9660 Extensions: Microsoft Joliet Level 3
[   44.970093] ISO 9660 Extensions: RRIP_1991A
[   45.279722] ISO 9660 Extensions: Microsoft Joliet Level 3
[   45.301888] ISO 9660 Extensions: RRIP_1991A
[   45.387165] ISO 9660 Extensions: Microsoft Joliet Level 3
[   45.410751] ISO 9660 Extensions: RRIP_1991A
[   45.565333] ISO 9660 Extensions: Microsoft Joliet Level 3
[   45.589144] ISO 9660 Extensions: RRIP_1991A
[   45.697091] ISO 9660 Extensions: Microsoft Joliet Level 3
[   45.722319] ISO 9660 Extensions: RRIP_1991A
[   45.968338] ISO 9660 Extensions: Microsoft Joliet Level 3
[   46.032974] ISO 9660 Extensions: RRIP_1991A
[   46.168175] ISO 9660 Extensions: Microsoft Joliet Level 3
[   46.209226] ISO 9660 Extensions: RRIP_1991A
[   46.324319] ISO 9660 Extensions: Microsoft Joliet Level 3
[   46.349907] ISO 9660 Extensions: RRIP_1991A
[   46.443360] ISO 9660 Extensions: Microsoft Joliet Level 3
[   46.481255] ISO 9660 Extensions: RRIP_1991A
[   46.645581] ISO 9660 Extensions: Microsoft Joliet Level 3
[   46.675467] ISO 9660 Extensions: RRIP_1991A
[   46.785537] ISO 9660 Extensions: Microsoft Joliet Level 3
[   46.811698] ISO 9660 Extensions: RRIP_1991A
[   47.047178] ISO 9660 Extensions: Microsoft Joliet Level 3
[   47.068003] ISO 9660 Extensions: RRIP_1991A
[   47.166461] ISO 9660 Extensions: Microsoft Joliet Level 3
[   47.184916] ISO 9660 Extensions: RRIP_1991A
[   47.287272] ISO 9660 Extensions: Microsoft Joliet Level 3
[   47.301892] ISO 9660 Extensions: RRIP_1991A
[   49.848723] NET: Registered protocol family 10
[   50.244221] sky2 0000:02:00.0 en0: enabling interface
[   50.244416] IPv6: ADDRCONF(NETDEV_UP): en0: link is not ready
[   50.382816] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   50.651343] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   50.655768] NFSD: starting 90-second grace period (net ffffffff81c61e00)
[   52.652944] sky2 0000:02:00.0 en0: Link is up at 100 Mbps, full duplex, flow control both
[   52.653563] IPv6: ADDRCONF(NETDEV_CHANGE): en0: link becomes ready
[   54.873406] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[   59.813591] Bluetooth: Core ver 2.18
[   59.813620] NET: Registered protocol family 31
[   59.813623] Bluetooth: HCI device and connection manager initialized
[   59.813633] Bluetooth: HCI socket layer initialized
[   59.813637] Bluetooth: L2CAP socket layer initialized
[   59.813649] Bluetooth: SCO socket layer initialized
[   60.029129] Bluetooth: RFCOMM TTY layer initialized
[   60.029146] Bluetooth: RFCOMM socket layer initialized
[   60.029155] Bluetooth: RFCOMM ver 1.11
[   63.682249] tun: Universal TUN/TAP device driver, 1.6
[   63.682256] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   77.323080] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr,commit=0
[   79.563149] EXT4-fs (dm-1): re-mounted. Opts: commit=0
[  139.514386] kjournald starting.  Commit interval 5 seconds
[  139.521673] EXT3-fs (dm-5): using internal journal
[  139.521686] EXT3-fs (dm-5): mounted filesystem with ordered data mode
[  905.546125] usb 4-3: new full-speed USB device number 2 using ohci-pci
[  905.713273] usb 4-3: New USB device found, idVendor=06bd, idProduct=2061
[  905.713286] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  905.713294] usb 4-3: Product: SNAPSCAN
[  905.713300] usb 4-3: Manufacturer: AGFA 
[  905.726307] WARNING! power/level is deprecated; use power/control instead
[26415.677269] usb 4-3: USB disconnect, device number 2
[93370.203271] usb 1-3: new high-speed USB device number 4 using ehci-pci
[93370.352383] usb 1-3: New USB device found, idVendor=13fe, idProduct=5500
[93370.352396] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[93370.352404] usb 1-3: Product: Silicon-Power16G
[93370.352410] usb 1-3: Manufacturer: UFD 3.0
[93370.352415] usb 1-3: SerialNumber: 13114490036E6003C9643C6DA95
[93370.494644] usb-storage 1-3:1.0: USB Mass Storage device detected
[93370.494836] scsi5 : usb-storage 1-3:1.0
[93370.495022] usbcore: registered new interface driver usb-storage
[93371.552226] scsi 5:0:0:0: Direct-Access     UFD 3.0  Silicon-Power16G PMAP PQ: 0 ANSI: 6
[93371.555978] sd 5:0:0:0: Attached scsi generic sg3 type 0
[93373.535802] sd 5:0:0:0: [sdc] 30572544 512-byte logical blocks: (15.6 GB/14.5 GiB)
[93373.539467] sd 5:0:0:0: [sdc] Write Protect is off
[93373.539482] sd 5:0:0:0: [sdc] Mode Sense: 23 00 00 00
[93373.543095] sd 5:0:0:0: [sdc] No Caching mode page found
[93373.543107] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[93373.555840] sd 5:0:0:0: [sdc] No Caching mode page found
[93373.555852] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[93373.594936]  sdc: sdc1 sdc2
[93373.606104] sd 5:0:0:0: [sdc] No Caching mode page found
[93373.606117] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[93373.606126] sd 5:0:0:0: [sdc] Attached SCSI removable disk
[93382.403371] EXT4-fs (sdc2): mounted filesystem without journal. Opts: (null)
[94284.318876] usb 2-1: USB disconnect, device number 2
[94284.318882] usb 2-1.1: USB disconnect, device number 3
[94284.382782] usb 2-1.3: USB disconnect, device number 4
[94284.722879] usb 2-1: new high-speed USB device number 5 using ehci-pci
[94284.855823] usb 2-1: New USB device found, idVendor=1a40, idProduct=0101
[94284.855835] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94284.855842] usb 2-1: Product: USB 2.0 Hub
[94284.857233] hub 2-1:1.0: USB hub found
[94284.857408] hub 2-1:1.0: 4 ports detected
[94285.143127] usb 2-1.1: new low-speed USB device number 6 using ehci-pci
[94285.258876] usb 2-1.1: New USB device found, idVendor=413c, idProduct=2106
[94285.258888] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[94285.258895] usb 2-1.1: Product: Dell QuietKey Keyboard
[94285.258900] usb 2-1.1: Manufacturer: DELL
[94285.264277] input: DELL Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.1/2-1.1:1.0/0003:413C:2106.0004/input/input25
[94285.264595] hid-generic 0003:413C:2106.0004: input,hidraw0: USB HID v1.10 Keyboard [DELL Dell QuietKey Keyboard] on usb-0000:00:13.2-1.1/input0
[94285.355010] usb 2-1.3: new low-speed USB device number 7 using ehci-pci
[94285.474968] usb 2-1.3: New USB device found, idVendor=1ea7, idProduct=0002
[94285.474981] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94285.474988] usb 2-1.3: Product: 2.4GHZ Mouse
[94285.480036] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.0/0003:1EA7:0002.0005/input/input26
[94285.480408] hid-generic 0003:1EA7:0002.0005: input,hidraw1: USB HID v1.10 Keyboard [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input0
[94285.488157] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.1/0003:1EA7:0002.0006/input/input27
[94285.488764] hid-generic 0003:1EA7:0002.0006: input,hiddev0,hidraw2: USB HID v1.10 Mouse [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input1
[94288.470191] usb 2-1: USB disconnect, device number 5
[94288.470204] usb 2-1.1: USB disconnect, device number 6
[94288.536037] usb 2-1.3: USB disconnect, device number 7
[94288.920119] usb 2-1: new high-speed USB device number 8 using ehci-pci
[94289.053129] usb 2-1: New USB device found, idVendor=1a40, idProduct=0101
[94289.053142] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94289.053150] usb 2-1: Product: USB 2.0 Hub
[94289.053749] hub 2-1:1.0: USB hub found
[94289.053870] hub 2-1:1.0: 4 ports detected
[94289.372442] usb 2-1.1: new low-speed USB device number 9 using ehci-pci
[94289.486596] usb 2-1.1: New USB device found, idVendor=413c, idProduct=2106
[94289.486603] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[94289.486608] usb 2-1.1: Product: Dell QuietKey Keyboard
[94289.486611] usb 2-1.1: Manufacturer: DELL
[94289.490652] input: DELL Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.1/2-1.1:1.0/0003:413C:2106.0007/input/input28
[94289.492395] hid-generic 0003:413C:2106.0007: input,hidraw0: USB HID v1.10 Keyboard [DELL Dell QuietKey Keyboard] on usb-0000:00:13.2-1.1/input0
[94289.568617] usb 2-1.3: new low-speed USB device number 10 using ehci-pci
[94289.708999] usb 2-1: clear tt 1 (80a0) error -71
[94289.721155] usb 2-1.3: New USB device found, idVendor=1ea7, idProduct=0002
[94289.721169] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94289.732527] usb 2-1: clear tt 1 (80a0) error -71
[94289.744548] usb 2-1.3: can't set config #1, error -71
[94289.756254] usb 2-1: clear tt 1 (00a0) error -71
[94289.768431] hub 2-1:1.0: hub_port_status failed (err = -71)
[94289.768557] usb 2-1: USB disconnect, device number 8
[94289.768570] usb 2-1.1: USB disconnect, device number 9
[94294.692725] hid-generic 0003:413C:2106.0007: can't reset device, 0000:00:13.2-1.1/input0, status -110
[94294.726087] usb 2-1.3: USB disconnect, device number 10
[94294.966064] usb 2-1: new high-speed USB device number 11 using ehci-pci
[94295.099054] usb 2-1: New USB device found, idVendor=1a40, idProduct=0101
[94295.099067] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94295.099074] usb 2-1: Product: USB 2.0 Hub
[94295.100446] hub 2-1:1.0: USB hub found
[94295.100636] hub 2-1:1.0: 4 ports detected
[94295.386466] usb 2-1.1: new low-speed USB device number 12 using ehci-pci
[94295.410979] usb 2-1: clear tt 1 (8000) error -71
[94295.433613] usb 2-1: clear tt 1 (8000) error -71
[94295.445110] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.456610] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.467741] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.479240] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.490742] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.490754] hub 2-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
[94295.502250] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94295.513014] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.521268] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.531353] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.539524] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.547763] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.547772] hub 2-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
[94295.556020] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94295.564548] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.572798] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.583893] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.595036] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.606064] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.606075] hub 2-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
[94295.617503] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94295.628441] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.639415] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.650901] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.662405] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.673558] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94295.673569] hub 2-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
[94295.684659] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94295.684678] hub 2-1:1.0: unable to enumerate USB device on port 1
[94295.696157] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94295.707536] hub 2-1:1.0: hub_port_status failed (err = -71)
[94295.707722] usb 2-1: USB disconnect, device number 11
[94295.954437] usb 2-1: new high-speed USB device number 16 using ehci-pci
[94296.087232] usb 2-1: New USB device found, idVendor=1a40, idProduct=0101
[94296.087245] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94296.087252] usb 2-1: Product: USB 2.0 Hub
[94296.088623] hub 2-1:1.0: USB hub found
[94296.088859] hub 2-1:1.0: 4 ports detected
[94296.382668] usb 2-1.1: new low-speed USB device number 17 using ehci-pci
[94296.400073] usb 2-1: clear tt 1 (8000) error -71
[94296.416327] usb 2-1: clear tt 1 (8000) error -71
[94296.432596] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94296.440828] usb 2-1: clear tt 1 (8000) error -71
[94297.434081] hub 2-1:1.0: cannot reset port 1 (err = -110)
[94297.445497] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.456999] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.467753] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.467765] hub 2-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
[94297.479131] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94297.490133] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.501149] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.512051] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.522780] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.533407] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.533418] hub 2-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
[94297.541905] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94297.550152] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.558432] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.566677] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.574931] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.583181] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.583193] hub 2-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
[94297.591445] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94297.599676] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.607947] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.616459] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.624711] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.632963] hub 2-1:1.0: cannot reset port 1 (err = -71)
[94297.632974] hub 2-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
[94297.641464] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94297.641482] hub 2-1:1.0: unable to enumerate USB device on port 1
[94297.649841] hub 2-1:1.0: cannot disable port 1 (err = -71)
[94297.658068] hub 2-1:1.0: hub_port_status failed (err = -71)
[94297.658260] usb 2-1: USB disconnect, device number 16
[94297.903108] usb 2-1: new high-speed USB device number 21 using ehci-pci
[94298.035876] usb 2-1: New USB device found, idVendor=1a40, idProduct=0101
[94298.035888] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94298.035896] usb 2-1: Product: USB 2.0 Hub
[94298.037281] hub 2-1:1.0: USB hub found
[94298.037497] hub 2-1:1.0: 4 ports detected
[94298.323307] usb 2-1.1: new low-speed USB device number 22 using ehci-pci
[94298.437316] usb 2-1.1: New USB device found, idVendor=413c, idProduct=2106
[94298.437329] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[94298.437336] usb 2-1.1: Product: Dell QuietKey Keyboard
[94298.437341] usb 2-1.1: Manufacturer: DELL
[94298.443505] input: DELL Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.1/2-1.1:1.0/0003:413C:2106.0008/input/input29
[94298.444003] hid-generic 0003:413C:2106.0008: input,hidraw0: USB HID v1.10 Keyboard [DELL Dell QuietKey Keyboard] on usb-0000:00:13.2-1.1/input0
[94298.531461] usb 2-1.3: new low-speed USB device number 23 using ehci-pci
[94298.650591] usb 2-1.3: New USB device found, idVendor=1ea7, idProduct=0002
[94298.650597] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94298.650600] usb 2-1.3: Product: 2.4GHZ Mouse
[94298.656905] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.0/0003:1EA7:0002.0009/input/input30
[94298.657438] hid-generic 0003:1EA7:0002.0009: input,hidraw1: USB HID v1.10 Keyboard [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input0
[94298.663931] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.1/0003:1EA7:0002.000A/input/input31
[94298.668228] hid-generic 0003:1EA7:0002.000A: input,hiddev0,hidraw2: USB HID v1.10 Mouse [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input1
[94303.399954] usb 2-1: USB disconnect, device number 21
[94303.399960] usb 2-1.1: USB disconnect, device number 22
[94303.492870] usb 2-1.3: USB disconnect, device number 23
[94303.869161] usb 2-1: new high-speed USB device number 24 using ehci-pci
[94304.001782] usb 2-1: New USB device found, idVendor=1a40, idProduct=0101
[94304.001795] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94304.001802] usb 2-1: Product: USB 2.0 Hub
[94304.003190] hub 2-1:1.0: USB hub found
[94304.003406] hub 2-1:1.0: 4 ports detected
[94304.289347] usb 2-1.1: new low-speed USB device number 25 using ehci-pci
[94304.403089] usb 2-1.1: New USB device found, idVendor=413c, idProduct=2106
[94304.403095] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[94304.403097] usb 2-1.1: Product: Dell QuietKey Keyboard
[94304.403100] usb 2-1.1: Manufacturer: DELL
[94304.408238] input: DELL Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.1/2-1.1:1.0/0003:413C:2106.000B/input/input32
[94304.409329] hid-generic 0003:413C:2106.000B: input,hidraw0: USB HID v1.10 Keyboard [DELL Dell QuietKey Keyboard] on usb-0000:00:13.2-1.1/input0
[94304.497355] usb 2-1.3: new low-speed USB device number 26 using ehci-pci
[94304.617479] usb 2-1.3: New USB device found, idVendor=1ea7, idProduct=0002
[94304.617492] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94304.617499] usb 2-1.3: Product: 2.4GHZ Mouse
[94304.623651] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.0/0003:1EA7:0002.000C/input/input33
[94304.623909] hid-generic 0003:1EA7:0002.000C: input,hidraw1: USB HID v1.10 Keyboard [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input0
[94304.630587] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.1/0003:1EA7:0002.000D/input/input34
[94304.630952] hid-generic 0003:1EA7:0002.000D: input,hiddev0,hidraw2: USB HID v1.10 Mouse [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input1
[94311.878603] usb 2-1: USB disconnect, device number 24
[94311.878609] usb 2-1.1: USB disconnect, device number 25
[94311.975755] usb 2-1.3: USB disconnect, device number 26
[94312.363914] usb 2-1: new high-speed USB device number 27 using ehci-pci
[94312.500641] usb 2-1: New USB device found, idVendor=1a40, idProduct=0101
[94312.500654] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94312.500662] usb 2-1: Product: USB 2.0 Hub
[94312.502049] hub 2-1:1.0: USB hub found
[94312.502195] hub 2-1:1.0: 4 ports detected
[94312.788248] usb 2-1.1: new low-speed USB device number 28 using ehci-pci
[94312.903440] usb 2-1.1: New USB device found, idVendor=413c, idProduct=2106
[94312.903447] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[94312.903450] usb 2-1.1: Product: Dell QuietKey Keyboard
[94312.903452] usb 2-1.1: Manufacturer: DELL
[94312.908554] input: DELL Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.1/2-1.1:1.0/0003:413C:2106.000E/input/input35
[94312.908855] hid-generic 0003:413C:2106.000E: input,hidraw0: USB HID v1.10 Keyboard [DELL Dell QuietKey Keyboard] on usb-0000:00:13.2-1.1/input0
[94312.996162] usb 2-1.3: new low-speed USB device number 29 using ehci-pci
[94313.115962] usb 2-1.3: New USB device found, idVendor=1ea7, idProduct=0002
[94313.115976] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94313.115984] usb 2-1.3: Product: 2.4GHZ Mouse
[94313.122206] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.0/0003:1EA7:0002.000F/input/input36
[94313.122946] hid-generic 0003:1EA7:0002.000F: input,hidraw1: USB HID v1.10 Keyboard [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input0
[94313.129712] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1.3/2-1.3:1.1/0003:1EA7:0002.0010/input/input37
[94313.131605] hid-generic 0003:1EA7:0002.0010: input,hiddev0,hidraw2: USB HID v1.10 Mouse [2.4GHZ Mouse] on usb-0000:00:13.2-1.3/input1
[94404.172576] usb 2-1: USB disconnect, device number 27
[94404.172588] usb 2-1.1: USB disconnect, device number 28
[94404.230022] usb 2-1.3: USB disconnect, device number 29
[94404.590130] usb 2-1: new high-speed USB device number 30 using ehci-pci
[94405.126274] usb 2-1: device not accepting address 30, error -71
[94405.502364] usb 5-1: new full-speed USB device number 2 using ohci-pci
[94405.669540] usb 5-1: not running at top speed; connect to a high speed hub
[94405.677550] usb 5-1: New USB device found, idVendor=1a40, idProduct=0101
[94405.677563] usb 5-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94405.677570] usb 5-1: Product: USB 2.0 Hub
[94405.679603] hub 5-1:1.0: USB hub found
[94405.681542] hub 5-1:1.0: 4 ports detected
[94405.987649] usb 5-1.1: new low-speed USB device number 3 using ohci-pci
[94406.103654] usb 5-1.1: New USB device found, idVendor=413c, idProduct=2106
[94406.103667] usb 5-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[94406.103675] usb 5-1.1: Product: Dell QuietKey Keyboard
[94406.103681] usb 5-1.1: Manufacturer: DELL
[94406.111544] input: DELL Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1.1/5-1.1:1.0/0003:413C:2106.0011/input/input38
[94406.112064] hid-generic 0003:413C:2106.0011: input,hidraw0: USB HID v1.10 Keyboard [DELL Dell QuietKey Keyboard] on usb-0000:00:13.0-1.1/input0
[94406.207665] usb 5-1.3: new low-speed USB device number 4 using ohci-pci
[94406.323765] usb 5-1.3: New USB device found, idVendor=1ea7, idProduct=0002
[94406.323778] usb 5-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[94406.323785] usb 5-1.3: Product: 2.4GHZ Mouse
[94406.331613] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1.3/5-1.3:1.0/0003:1EA7:0002.0012/input/input39
[94406.332127] hid-generic 0003:1EA7:0002.0012: input,hidraw1: USB HID v1.10 Keyboard [2.4GHZ Mouse] on usb-0000:00:13.0-1.3/input0
[94406.340683] input: 2.4GHZ Mouse as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1.3/5-1.3:1.1/0003:1EA7:0002.0013/input/input40
[94406.341279] hid-generic 0003:1EA7:0002.0013: input,hiddev0,hidraw2: USB HID v1.10 Mouse [2.4GHZ Mouse] on usb-0000:00:13.0-1.3/input1
[94414.233882] usb 1-3: USB disconnect, device number 4
[94414.245377] scsi 5:0:0:0: rejecting I/O to offline device
[94414.245383] scsi 5:0:0:0: killing request
[94414.370354] FAT-fs (sdc1): unable to read boot sector to mark fs as dirty
[94414.370393] ------------[ cut here ]------------
[94414.370400] WARNING: CPU: 2 PID: 3619 at fs/sysfs/group.c:216 sysfs_remove_group+0xa1/0xb0()
[94414.370403] sysfs group ffffffff81c50ca0 not found for kobject 'target5:0:0'
[94414.370404] Modules linked in: usb_storage sha256_generic tun rfcomm bluetooth 6lowpan_iphc nfsd ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device xts gf128mul loop hp_accel uvcvideo videobuf2_core tpm_infineon videodev kvm_amd videobuf2_vmalloc videobuf2_memops snd_hda_codec_hdmi kvm joydev i2c_piix4 lis3lv02d snd_hda_codec_idt snd_hda_codec_generic sdhci_pci sdhci mmc_core snd_hda_intel snd_hda_codec snd_pcm snd_timer snd soundcore hp_wmi tpm_tis sparse_keymap k10temp tpm input_polldev led_class wmi radeon ttm drm_kms_helper drm
[94414.370441] CPU: 2 PID: 3619 Comm: umount Not tainted 3.14.4-5.olh_kernel_sles11sp3.1-kernel-linux-3_14 #1
[94414.370443] Hardware name: Hewlett-Packard HP ProBook 6555b/1455, BIOS 68DTM Ver. F.20 09/15/2011
[94414.370445]  00000000000000d8 ffff880073ab7af8 ffffffff8172db82 ffff880073ab7b38
[94414.370449]  ffffffff81055882 ffff880073ab7b28 0000000000000000 ffffffff81c50ca0
[94414.370452]  ffff88009eac9838 ffff8801ef30e190 ffff88009eac9828 ffff880073ab7b98
[94414.370455] Call Trace:
[94414.370461]  [<ffffffff8172db82>] dump_stack+0x6a/0x78
[94414.370465]  [<ffffffff81055882>] warn_slowpath_common+0x82/0xb0
[94414.370468]  [<ffffffff81055951>] warn_slowpath_fmt+0x41/0x50
[94414.370472]  [<ffffffff81195c2e>] ? kernfs_find_and_get_ns+0x4e/0x60
[94414.370475]  [<ffffffff81193d01>] sysfs_remove_group+0xa1/0xb0
[94414.370479]  [<ffffffff81517592>] dpm_sysfs_remove+0x42/0x50
[94414.370482]  [<ffffffff8150f930>] device_del+0x40/0x1d0
[94414.370486]  [<ffffffff8153051f>] scsi_target_reap_usercontext+0x2f/0x50
[94414.370490]  [<ffffffff8106f1e5>] execute_in_process_context+0x55/0x60
[94414.370493]  [<ffffffff8152f531>] scsi_target_reap+0xc1/0xe0
[94414.370496]  [<ffffffff815319dc>] scsi_device_dev_release_usercontext+0x19c/0x1d0
[94414.370500]  [<ffffffff8106f1e5>] execute_in_process_context+0x55/0x60
[94414.370502]  [<ffffffff81531837>] scsi_device_dev_release+0x17/0x20
[94414.370505]  [<ffffffff8150ed42>] device_release+0x32/0xa0
[94414.370509]  [<ffffffff81437a07>] kobject_release+0x47/0x90
[94414.370512]  [<ffffffff81437a7b>] kobject_put+0x2b/0x60
[94414.370514]  [<ffffffff8150e4a2>] put_device+0x12/0x20
[94414.370517]  [<ffffffff81522c10>] scsi_device_put+0x40/0x60
[94414.370521]  [<ffffffff81535108>] scsi_disk_put+0x38/0x50
[94414.370523]  [<ffffffff81536692>] sd_release+0x52/0xd0
[94414.370527]  [<ffffffff8115f591>] __blkdev_put+0x1a1/0x1d0
[94414.370530]  [<ffffffff8115f4e4>] __blkdev_put+0xf4/0x1d0
[94414.370533]  [<ffffffff8115f618>] blkdev_put+0x58/0x150
[94414.370537]  [<ffffffff8112d375>] kill_block_super+0x45/0x80
[94414.370540]  [<ffffffff8112d785>] deactivate_locked_super+0x45/0x70
[94414.370543]  [<ffffffff8112de41>] deactivate_super+0x61/0x70
[94414.370547]  [<ffffffff81149134>] mntput_no_expire+0x134/0x1d0
[94414.370549]  [<ffffffff8114aade>] SyS_umount+0xce/0x3e0
[94414.370553]  [<ffffffff81049fc9>] ? do_page_fault+0x39/0x50
[94414.370557]  [<ffffffff817331b9>] system_call_fastpath+0x16/0x1b
[94414.370559] ---[ end trace 30a2ff6dc29ae7a9 ]---



#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 3.14.4 Kernel Configuration
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
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION="-5.olh_kernel_sles11sp3.1-kernel-linux-3_14"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
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
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

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
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
# CONFIG_MEMCG_KMEM is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
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
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
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
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
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
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
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
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
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
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
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
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

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
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_AMD_FREQ_SENSITIVITY=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
# CONFIG_NET_IPGRE is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=m
# CONFIG_IP_SET_HASH_NETNET is not set
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_SYNPROXY is not set
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT_IPV4=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
# CONFIG_IP6_NF_TARGET_SYNPROXY is not set
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_NF_NAT_IPV6=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=m
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
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
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
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
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_XEN_BLKDEV_BACKEND=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
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
# CONFIG_VMWARE_BALLOON is not set
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
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
# CONFIG_GENWQE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
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
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
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
CONFIG_ATA_SFF=y

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
# CONFIG_SATA_RCAR is not set
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
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=m
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
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
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
# CONFIG_I40EVF is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
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
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=m
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
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
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_PHYLIB is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
# CONFIG_PPTP is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_CARDS is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL_TI is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
# CONFIG_MWIFIEX is not set
# CONFIG_CW1200 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_XEN_NETDEV_BACKEND=m
# CONFIG_VMXNET3 is not set
CONFIG_HYPERV_NET=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
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
# CONFIG_KEYBOARD_LM8323 is not set
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
# CONFIG_MOUSE_SERIAL is not set
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
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
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
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_HYPERV_KEYBOARD=m
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
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
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
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
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
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
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
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
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
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
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
CONFIG_SENSORS_K10TEMP=m
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
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
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
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_CORE is not set
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
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
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
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
CONFIG_XEN_WDT=m

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
CONFIG_MFD_CORE=m
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
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
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
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
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GL860 is not set
# CONFIG_USB_GSPCA_BENQ is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_CPIA1 is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_JEILINJ is not set
# CONFIG_USB_GSPCA_JL2005BCD is not set
# CONFIG_USB_GSPCA_KINECT is not set
# CONFIG_USB_GSPCA_KONICA is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_NW80X is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_OV534_9 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7302 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SE401 is not set
# CONFIG_USB_GSPCA_SN9C2028 is not set
# CONFIG_USB_GSPCA_SN9C20X is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_SPCA1528 is not set
# CONFIG_USB_GSPCA_SQ905 is not set
# CONFIG_USB_GSPCA_SQ905C is not set
# CONFIG_USB_GSPCA_SQ930X is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STK1135 is not set
# CONFIG_USB_GSPCA_STV0680 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TOPRO is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_VICAM is not set
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_USB_PWC is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_VIDEO_USBTV is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

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
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_UMS is not set
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
# CONFIG_DRM_BOCHS is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

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
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=64
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=m
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=m
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_HDMI=m
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_USB_HIFACE is not set
CONFIG_SND_FIREWIRE=y
# CONFIG_SND_DICE is not set
# CONFIG_SND_FIREWIRE_SPEAKERS is not set
# CONFIG_SND_ISIGHT is not set
# CONFIG_SND_SCS1X is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
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
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_HYPERV_MOUSE=m
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
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
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

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
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
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
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_OTG_FSM is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
CONFIG_MMC_REALTEK_PCI=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_AMD64 is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I7CORE=m
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
# CONFIG_RTC_DRV_TEST is not set

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
# CONFIG_RTC_DRV_ISL12057 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
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
CONFIG_RTC_DRV_CMOS=y
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
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=m
CONFIG_XEN_GRANT_DEV_ALLOC=m
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_R8821AE is not set
# CONFIG_RTS5139 is not set
# CONFIG_RTS5208 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_DX_SEP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
CONFIG_NET_VENDOR_SILICOM=y
# CONFIG_SBYPASS is not set
# CONFIG_BPCTL is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
CONFIG_DELL_WMI=m
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_HP_ACCEL=m
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=m
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_MXM_WMI is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
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
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=m
CONFIG_EFI_VARS_PSTORE=m
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
CONFIG_EFI_RUNTIME_MAP=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

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
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_EFIVAR_FS=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
# CONFIG_NFS_V4_2 is not set
CONFIG_PNFS_FILE_LAYOUT=y
CONFIG_PNFS_BLOCK=y
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=m
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
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
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

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_CRCT10DIF is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_CCP is not set
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
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_DEVICE_ASSIGNMENT=y
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=m
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
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
