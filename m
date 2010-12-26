From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [Probably regression] Possible circular locking dependency from ATA in current mainline
Date: Sun, 26 Dec 2010 23:16:26 +0100
Message-ID: <201012262316.26638.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_667FNY7Y1BHthqa"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_667FNY7Y1BHthqa
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi,

I get the following during resume from hibernation:

[  318.951686] ata9.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[  318.951688] ata9.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[  318.963949] ata9.00: configured for UDMA/33
[  319.103425] ata7: SATA link down (SStatus 0 SControl 300)
[  319.103452] ata6: SATA link down (SStatus 0 SControl 300)
[  319.103471] ata8: SATA link down (SStatus 0 SControl 300)
[  319.103494] ata2: SATA link down (SStatus 0 SControl 300)
[  319.103524] ata5: SATA link down (SStatus 0 SControl 300)
[  319.110095] ata4: SATA link down (SStatus 0 SControl 300)
[  319.256728] usb 3-2: reset full speed USB device using ohci_hcd and address 2
[  319.270051] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  319.276717] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  319.281558] ata1.00: configured for UDMA/133
[  319.281891] 
[  319.281892] =======================================================
[  319.281893] [ INFO: possible circular locking dependency detected ]
[  319.281894] 2.6.37-rc7+ #16
[  319.281895] -------------------------------------------------------
[  319.281896] kworker/1:0/13333 is trying to acquire lock:
[  319.281897]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811271a6>] revalidate_disk+0x56/0x90
[  319.281902] 
[  319.281903] but task is already holding lock:
[  319.281903]  (&ap->scsi_scan_mutex){+.+...}, at: [<ffffffff81360420>] ata_scsi_dev_rescan+0x30/0x120
[  319.281907] 
[  319.281907] which lock already depends on the new lock.
[  319.281907] 
[  319.281908] 
[  319.281908] the existing dependency chain (in reverse order) is:
[  319.281909] 
[  319.281910] -> #3 (&ap->scsi_scan_mutex){+.+...}:
[  319.281911]        [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.281914]        [<ffffffff81492fae>] mutex_lock_nested+0x5e/0x380
[  319.281916]        [<ffffffff81360420>] ata_scsi_dev_rescan+0x30/0x120
[  319.281918]        [<ffffffff81060722>] process_one_work+0x1a2/0x450
[  319.281921]        [<ffffffff81061ee2>] worker_thread+0x162/0x340
[  319.281922]        [<ffffffff810668e6>] kthread+0x96/0xa0
[  319.281924]        [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[  319.281927] 
[  319.281927] -> #2 ((&ap->scsi_rescan_task)){+.+...}:
[  319.281929]        [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.281930]        [<ffffffff8106071c>] process_one_work+0x19c/0x450
[  319.281932]        [<ffffffff81061ee2>] worker_thread+0x162/0x340
[  319.281934]        [<ffffffff810668e6>] kthread+0x96/0xa0
[  319.281935]        [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[  319.281937] 
[  319.281937] -> #1 (events){+.+.+.}:
[  319.281939]        [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.281940]        [<ffffffff81060463>] start_flush_work+0xc3/0x130
[  319.281942]        [<ffffffff810604f0>] flush_work+0x20/0x50
[  319.281944]        [<ffffffff81062a2b>] schedule_on_each_cpu+0xeb/0x130
[  319.281946]        [<ffffffff810c2070>] lru_add_drain_all+0x10/0x20
[  319.281948]        [<ffffffff81120578>] invalidate_bdev+0x28/0x40
[  319.281950]        [<ffffffff8112696a>] __invalidate_device+0x4a/0x60
[  319.281952]        [<ffffffff81126a78>] flush_disk+0x18/0xa0
[  319.281953]        [<ffffffff81126be8>] check_disk_size_change+0x78/0x80
[  319.281955]        [<ffffffff811271b1>] revalidate_disk+0x61/0x90
[  319.281957]        [<ffffffff813ba499>] do_md_run+0x59/0xa0
[  319.281959]        [<ffffffff813bbb78>] md_ioctl+0x928/0x1100
[  319.281961]        [<ffffffff811b87f8>] blkdev_ioctl+0x228/0x700
[  319.281962]        [<ffffffff8112681c>] block_ioctl+0x3c/0x40
[  319.281964]        [<ffffffff81107dc7>] do_vfs_ioctl+0x97/0x580
[  319.281966]        [<ffffffff81108329>] sys_ioctl+0x79/0x90
[  319.281968]        [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[  319.281970] 
[  319.281970] -> #0 (&bdev->bd_mutex){+.+.+.}:
[  319.281972]        [<ffffffff8107af58>] __lock_acquire+0x1698/0x1ca0
[  319.281973]        [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.281975]        [<ffffffff81492fae>] mutex_lock_nested+0x5e/0x380
[  319.281976]        [<ffffffff811271a6>] revalidate_disk+0x56/0x90
[  319.281978]        [<ffffffffa0055c92>] sd_rescan+0x22/0x40 [sd_mod]
[  319.281981]        [<ffffffff81346ed6>] scsi_rescan_device+0xa6/0xd0
[  319.281984]        [<ffffffff813604aa>] ata_scsi_dev_rescan+0xba/0x120
[  319.281985]        [<ffffffff81060722>] process_one_work+0x1a2/0x450
[  319.281987]        [<ffffffff81061ee2>] worker_thread+0x162/0x340
[  319.281989]        [<ffffffff810668e6>] kthread+0x96/0xa0
[  319.281990]        [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[  319.281992] 
[  319.281993] other info that might help us debug this:
[  319.281993] 
[  319.281994] 3 locks held by kworker/1:0/13333:
[  319.281995]  #0:  (events){+.+.+.}, at: [<ffffffff810606c4>] process_one_work+0x144/0x450
[  319.281998]  #1:  ((&ap->scsi_rescan_task)){+.+...}, at: [<ffffffff810606c4>] process_one_work+0x144/0x450
[  319.282000]  #2:  (&ap->scsi_scan_mutex){+.+...}, at: [<ffffffff81360420>] ata_scsi_dev_rescan+0x30/0x120
[  319.282003] 
[  319.282003] stack backtrace:
[  319.282005] Pid: 13333, comm: kworker/1:0 Not tainted 2.6.37-rc7+ #16
[  319.282006] Call Trace:
[  319.282008]  [<ffffffff81078707>] print_circular_bug+0xe7/0xf0
[  319.282010]  [<ffffffff8107af58>] __lock_acquire+0x1698/0x1ca0
[  319.282013]  [<ffffffff81044001>] ? get_parent_ip+0x11/0x50
[  319.282015]  [<ffffffff811271a6>] ? revalidate_disk+0x56/0x90
[  319.282017]  [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.282019]  [<ffffffff811271a6>] ? revalidate_disk+0x56/0x90
[  319.282020]  [<ffffffff810441a5>] ? add_preempt_count+0x95/0xd0
[  319.282022]  [<ffffffff81492fae>] mutex_lock_nested+0x5e/0x380
[  319.282024]  [<ffffffff811271a6>] ? revalidate_disk+0x56/0x90
[  319.282026]  [<ffffffff811c49e7>] ? kobject_put+0x27/0x60
[  319.282028]  [<ffffffff811b9784>] ? disk_get_part+0x14/0xa0
[  319.282030]  [<ffffffff81329b22>] ? put_device+0x12/0x20
[  319.282032]  [<ffffffff811271a6>] revalidate_disk+0x56/0x90
[  319.282035]  [<ffffffffa0055c92>] sd_rescan+0x22/0x40 [sd_mod]
[  319.282037]  [<ffffffff81346ed6>] scsi_rescan_device+0xa6/0xd0
[  319.282038]  [<ffffffff813604aa>] ata_scsi_dev_rescan+0xba/0x120
[  319.282040]  [<ffffffff81060722>] process_one_work+0x1a2/0x450
[  319.282042]  [<ffffffff810606c4>] ? process_one_work+0x144/0x450
[  319.282044]  [<ffffffff813603f0>] ? ata_scsi_dev_rescan+0x0/0x120
[  319.282045]  [<ffffffff81061ee2>] worker_thread+0x162/0x340
[  319.282047]  [<ffffffff81061d80>] ? worker_thread+0x0/0x340
[  319.282049]  [<ffffffff810668e6>] kthread+0x96/0xa0
[  319.282051]  [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[  319.282052]  [<ffffffff810375ab>] ? finish_task_switch+0x7b/0xe0
[  319.282055]  [<ffffffff81495d00>] ? restore_args+0x0/0x30
[  319.282056]  [<ffffffff81066850>] ? kthread+0x0/0xa0
[  319.282058]  [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
[  319.288123] ata3.00: configured for UDMA/133
[  319.346789] firewire_core: rediscovered device fw0
[  319.683384] usb 3-3: reset low speed USB device using ohci_hcd and address 3
[  319.992978] PM: restore of devices complete after 1208.480 msecs

The kernel is more-or-less current Linus' tree.

Full dmesg is attached, please let me know if you need any more information.

Thanks,
Rafael

--Boundary-00=_667FNY7Y1BHthqa
Content-Type: text/x-log;
  charset="UTF-8";
  name="desktop.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="desktop.log"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc7+ (rafael@chimera) (gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux) ) #16 SMP PREEMPT Sun Dec 26 20:48:28 CET 2010
[    0.000000] Command line: root=/dev/md0 resume=/dev/sda2 3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b000 (usable)
[    0.000000]  BIOS-e820: 000000000009b000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7e90000 (usable)
[    0.000000]  BIOS-e820: 00000000c7e90000 - 00000000c7e9e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7e9e000 - 00000000c7ee0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7ee0000 - 00000000c7f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: 890FXA-GD70 (MS-7640)  /MS-7640, BIOS V1.6 05/18/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x138000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000138000000 aka 4992M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xc7e90 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7e90000
[    0.000000]  0000000000 - 00c7e90000 page 4k
[    0.000000] kernel direct mapping tables up to c7e90000 @ 1f9bb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
[    0.000000]  0100000000 - 0138000000 page 4k
[    0.000000] kernel direct mapping tables up to 138000000 @ c74ca000-c7e90000
[    0.000000] RAMDISK: 370fc000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fb6a0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000c7e90000 00044 (v01 MSI    OEMSLIC  20100518 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000c7e90200 00084 (v01 7640MS A7640100 20100518 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000c7e905e0 09F32 (v01  A7640 A7640100 00000100 INTL 20051117)
[    0.000000] ACPI: FACS 00000000c7e9e000 00040
[    0.000000] ACPI: APIC 00000000c7e90390 00088 (v01 7640MS A7640100 20100518 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000c7e90420 0003C (v01 7640MS OEMMCFG  20100518 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000c7e90460 00176 (v01 MSI    OEMSLIC  20100518 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000c7e9e040 00072 (v01 7640MS A7640100 20100518 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000c7e9a5e0 00108 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 00000000c7e9a6f0 00038 (v01 7640MS OEMHPET  20100518 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000c7e9a730 00DA4 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00138000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000c7e90
[    0.000000]     0: 0x00100000 -> 0x00138000
[    0.000000] On node 0 totalpages: 1048091
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3917 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800456 pages, LIFO batch:31
[    0.000000]   Normal zone: 3136 pages used for memmap
[    0.000000]   Normal zone: 226240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec20000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 6 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c7e90000 - 00000000c7e9e000
[    0.000000] PM: Registered nosave memory: 00000000c7e9e000 - 00000000c7ee0000
[    0.000000] PM: Registered nosave memory: 00000000c7ee0000 - 00000000c7f00000
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c7f00000 (gap: c7f00000:37f00000)
[    0.000000] setup_percpu: NR_CPUS:6 nr_cpumask_bits:6 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800c7c00000 s75200 r8192 d23104 u262144
[    0.000000] pcpu-alloc: s75200 r8192 d23104 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030613
[    0.000000] Kernel command line: root=/dev/md0 resume=/dev/sda2 3
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ bc000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ bc000000
[    0.000000] PM: Registered nosave memory: 00000000bc000000 - 00000000c0000000
[    0.000000] Memory: 3951492k/5111808k available (4707k kernel code, 919444k absent, 240872k reserved, 6114k data, 496k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:448
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3199.844 MHz processor.
[    0.003348] Calibrating delay loop (skipped), value calculated using timer frequency.. 6402.34 BogoMIPS (lpj=10666146)
[    0.003419] pid_max: default: 32768 minimum: 301
[    0.003491] Security Framework initialized
[    0.003530] SELinux:  Initializing.
[    0.003587] SELinux:  Starting in permissive mode
[    0.003588] AppArmor: AppArmor disabled by boot time parameter
[    0.003653] Mount-cache hash table entries: 256
[    0.004413] tseg: 0000000000
[    0.004416] CPU: Physical Processor ID: 0
[    0.004451] CPU: Processor Core ID: 0
[    0.004485] mce: CPU supports 6 MCE banks
[    0.004525] Performance Events: AMD PMU driver.
[    0.004590] ... version:                0
[    0.004624] ... bit width:              48
[    0.004658] ... generic registers:      4
[    0.004692] ... value mask:             0000ffffffffffff
[    0.004726] ... max period:             00007fffffffffff
[    0.004761] ... fixed-purpose events:   0
[    0.004795] ... event mask:             000000000000000f
[    0.004893] ACPI: Core revision 20101013
[    0.016810] Setting APIC routing to flat
[    0.017170] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.051422] CPU0: AMD Phenom(tm) II X6 1090T Processor stepping 00
[    0.066682] lockdep: fixing up alternatives.
[    0.070134] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.173424]  #2lockdep: fixing up alternatives.
[    0.276760]  #3lockdep: fixing up alternatives.
[    0.380094]  #4lockdep: fixing up alternatives.
[    0.483430]  #5 Ok.
[    0.580027] Brought up 6 CPUs
[    0.580076] Total of 6 processors activated (38417.62 BogoMIPS).
[    0.583011] devtmpfs: initialized
[    0.583530] kworker/u:0 used greatest stack depth: 4968 bytes left
[    0.583612] Time: 21:40:07  Date: 12/26/10
[    0.583613] NET: Registered protocol family 16
[    0.583704] node 0 link 0: io port [1000, ffffff]
[    0.583704] TOM: 00000000c8000000 aka 3200M
[    0.583704] Fam 10h mmconf [e0000000, efffffff]
[    0.583704] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.583704] node 0 link 0: mmio [f0000000, ffffffff]
[    0.583704] node 0 link 0: mmio [a0000, bffff]
[    0.583704] node 0 link 0: mmio [c8000000, dfffffff]
[    0.583704] TOM2: 0000000138000000 aka 4992M
[    0.583704] bus: [00, 07] on node 0 link 0
[    0.583704] bus: 00 index 0 [io  0x0000-0xffff]
[    0.583704] bus: 00 index 1 [mem 0xf0000000-0xffffffff]
[    0.583704] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.583704] bus: 00 index 3 [mem 0xc8000000-0xdfffffff]
[    0.583704] bus: 00 index 4 [mem 0x138000000-0xfcffffffff]
[    0.583704] ACPI: bus type pci registered
[    0.583704] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.583704] PCI: not using MMCONFIG
[    0.583704] PCI: Using configuration type 1 for base access
[    0.583704] PCI: Using configuration type 1 for extended access
[    0.590047] bio: create slab <bio-0> at 0
[    0.595726] ACPI: EC: Look up EC in DSDT
[    0.598922] ACPI: Executed 3 blocks of module-level executable AML code
[    0.620630] ACPI: Interpreter enabled
[    0.620667] ACPI: (supports S0 S3 S4 S5)
[    0.620857] ACPI: Using IOAPIC for interrupt routing
[    0.620930] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.622803] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.660358] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    0.660358] ACPI Exception: AE_NOT_FOUND, Evaluating _PRW (20101013/scan-723)
[    0.663679] ACPI: No dock devices found.
[    0.663679] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.664105] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.664299] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.664299] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.664299] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.664299] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.664299] pci_root PNP0A03:00: host bridge window [mem 0xc8000000-0xdfffffff]
[    0.664299] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.666679] pci_bus 0000:00: scanning bus
[    0.666713] pci 0000:00:00.0: [1002:5a11] type 0 class 0x000600
[    0.666719] pci 0000:00:00.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.666721] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.666745] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.666828] pci 0000:00:03.0: [1002:5a17] type 1 class 0x000604
[    0.666831] pci 0000:00:03.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.666833] pci 0000:00:03.0: calling quirk_mmio_always_on+0x0/0x17
[    0.666856] pci 0000:00:03.0: calling quirk_resource_alignment+0x0/0x166
[    0.666870] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.666873] pci 0000:00:03.0: PME# disabled
[    0.666888] pci 0000:00:04.0: [1002:5a18] type 1 class 0x000604
[    0.666890] pci 0000:00:04.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.666892] pci 0000:00:04.0: calling quirk_mmio_always_on+0x0/0x17
[    0.666915] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x166
[    0.666929] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.666931] pci 0000:00:04.0: PME# disabled
[    0.666946] pci 0000:00:05.0: [1002:5a19] type 1 class 0x000604
[    0.666948] pci 0000:00:05.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.666950] pci 0000:00:05.0: calling quirk_mmio_always_on+0x0/0x17
[    0.666973] pci 0000:00:05.0: calling quirk_resource_alignment+0x0/0x166
[    0.666987] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.666989] pci 0000:00:05.0: PME# disabled
[    0.667004] pci 0000:00:06.0: [1002:5a1a] type 1 class 0x000604
[    0.667006] pci 0000:00:06.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667008] pci 0000:00:06.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667031] pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x166
[    0.667044] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.667047] pci 0000:00:06.0: PME# disabled
[    0.667072] pci 0000:00:09.0: [1002:5a1c] type 1 class 0x000604
[    0.667074] pci 0000:00:09.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667076] pci 0000:00:09.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667099] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x166
[    0.667113] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.667115] pci 0000:00:09.0: PME# disabled
[    0.667144] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.667154] pci 0000:00:11.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667156] pci 0000:00:11.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667167] pci 0000:00:11.0: reg 10: [io  0x8000-0x8007]
[    0.667175] pci 0000:00:11.0: reg 14: [io  0x7000-0x7003]
[    0.667184] pci 0000:00:11.0: reg 18: [io  0x6000-0x6007]
[    0.667192] pci 0000:00:11.0: reg 1c: [io  0x5000-0x5003]
[    0.667201] pci 0000:00:11.0: reg 20: [io  0x3000-0x300f]
[    0.667209] pci 0000:00:11.0: reg 24: [mem 0xfe3ff000-0xfe3ff3ff]
[    0.667222] pci 0000:00:11.0: calling quirk_resource_alignment+0x0/0x166
[    0.667263] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.667266] pci 0000:00:12.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667268] pci 0000:00:12.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667278] pci 0000:00:12.0: reg 10: [mem 0xfe3f7000-0xfe3f7fff]
[    0.667327] pci 0000:00:12.0: calling quirk_resource_alignment+0x0/0x166
[    0.667345] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.667353] pci 0000:00:12.2: calling quirk_no_ata_d3+0x0/0x1b
[    0.667355] pci 0000:00:12.2: calling quirk_mmio_always_on+0x0/0x17
[    0.667366] pci 0000:00:12.2: reg 10: [mem 0xfe3ff400-0xfe3ff4ff]
[    0.667414] pci 0000:00:12.2: calling quirk_resource_alignment+0x0/0x166
[    0.667432] pci 0000:00:12.2: supports D1 D2
[    0.667433] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.667437] pci 0000:00:12.2: PME# disabled
[    0.667458] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.667461] pci 0000:00:13.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667463] pci 0000:00:13.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667474] pci 0000:00:13.0: reg 10: [mem 0xfe3fc000-0xfe3fcfff]
[    0.667522] pci 0000:00:13.0: calling quirk_resource_alignment+0x0/0x166
[    0.667541] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.667549] pci 0000:00:13.2: calling quirk_no_ata_d3+0x0/0x1b
[    0.667551] pci 0000:00:13.2: calling quirk_mmio_always_on+0x0/0x17
[    0.667561] pci 0000:00:13.2: reg 10: [mem 0xfe3ff800-0xfe3ff8ff]
[    0.667610] pci 0000:00:13.2: calling quirk_resource_alignment+0x0/0x166
[    0.667628] pci 0000:00:13.2: supports D1 D2
[    0.667629] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.667633] pci 0000:00:13.2: PME# disabled
[    0.667651] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.667654] pci 0000:00:14.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.667656] pci 0000:00:14.0: calling quirk_mmio_always_on+0x0/0x17
[    0.667659] pci 0000:00:14.0: calling sb600_disable_hpet_bar+0x0/0x50
[    0.667715] pci 0000:00:14.0: calling force_disable_hpet_msi+0x0/0x10
[    0.667717] pci 0000:00:14.0: calling quirk_resource_alignment+0x0/0x166
[    0.667734] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.667740] pci 0000:00:14.2: calling quirk_no_ata_d3+0x0/0x1b
[    0.667742] pci 0000:00:14.2: calling quirk_mmio_always_on+0x0/0x17
[    0.667757] pci 0000:00:14.2: reg 10: [mem 0xfe3f8000-0xfe3fbfff 64bit]
[    0.667798] pci 0000:00:14.2: calling quirk_resource_alignment+0x0/0x166
[    0.667812] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.667816] pci 0000:00:14.2: PME# disabled
[    0.667827] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.667830] pci 0000:00:14.3: calling quirk_no_ata_d3+0x0/0x1b
[    0.667832] pci 0000:00:14.3: calling quirk_mmio_always_on+0x0/0x17
[    0.667889] pci 0000:00:14.3: calling quirk_resource_alignment+0x0/0x166
[    0.667901] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.667904] pci 0000:00:14.4: calling quirk_no_ata_d3+0x0/0x1b
[    0.667906] pci 0000:00:14.4: calling quirk_mmio_always_on+0x0/0x17
[    0.667935] pci 0000:00:14.4: calling quirk_resource_alignment+0x0/0x166
[    0.667947] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.667950] pci 0000:00:14.5: calling quirk_no_ata_d3+0x0/0x1b
[    0.667952] pci 0000:00:14.5: calling quirk_mmio_always_on+0x0/0x17
[    0.667963] pci 0000:00:14.5: reg 10: [mem 0xfe3fd000-0xfe3fdfff]
[    0.668011] pci 0000:00:14.5: calling quirk_resource_alignment+0x0/0x166
[    0.668029] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.668032] pci 0000:00:15.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.668034] pci 0000:00:15.0: calling quirk_mmio_always_on+0x0/0x17
[    0.668068] pci 0000:00:15.0: calling quirk_resource_alignment+0x0/0x166
[    0.668089] pci 0000:00:15.0: supports D1 D2
[    0.668110] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.668113] pci 0000:00:15.1: calling quirk_no_ata_d3+0x0/0x1b
[    0.668114] pci 0000:00:15.1: calling quirk_mmio_always_on+0x0/0x17
[    0.668148] pci 0000:00:15.1: calling quirk_resource_alignment+0x0/0x166
[    0.668168] pci 0000:00:15.1: supports D1 D2
[    0.668193] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.668196] pci 0000:00:16.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.668198] pci 0000:00:16.0: calling quirk_mmio_always_on+0x0/0x17
[    0.668209] pci 0000:00:16.0: reg 10: [mem 0xfe3fe000-0xfe3fefff]
[    0.668257] pci 0000:00:16.0: calling quirk_resource_alignment+0x0/0x166
[    0.668275] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.668283] pci 0000:00:16.2: calling quirk_no_ata_d3+0x0/0x1b
[    0.668285] pci 0000:00:16.2: calling quirk_mmio_always_on+0x0/0x17
[    0.668296] pci 0000:00:16.2: reg 10: [mem 0xfe3ffc00-0xfe3ffcff]
[    0.668344] pci 0000:00:16.2: calling quirk_resource_alignment+0x0/0x166
[    0.668362] pci 0000:00:16.2: supports D1 D2
[    0.668363] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.668367] pci 0000:00:16.2: PME# disabled
[    0.668386] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.668388] pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x17
[    0.668404] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x166
[    0.668425] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.668427] pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x17
[    0.668443] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x166
[    0.668450] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.668453] pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x17
[    0.668468] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x166
[    0.668477] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.668479] pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x17
[    0.668495] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x166
[    0.668506] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.668509] pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x17
[    0.668524] pci 0000:00:18.4: calling quirk_resource_alignment+0x0/0x166
[    0.668538] pci_bus 0000:00: fixups for bus
[    0.668541] pci 0000:00:03.0: scanning [bus 08-08] behind bridge, pass 0
[    0.668569] pci_bus 0000:08: scanning bus
[    0.668580] pci 0000:08:00.0: [1002:68da] type 0 class 0x000300
[    0.668583] pci 0000:08:00.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.668585] pci 0000:08:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.668598] pci 0000:08:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.668609] pci 0000:08:00.0: reg 18: [mem 0xfe9c0000-0xfe9dffff 64bit]
[    0.668617] pci 0000:08:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.668631] pci 0000:08:00.0: reg 30: [mem 0xfe9a0000-0xfe9bffff pref]
[    0.668637] pci 0000:08:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.668654] pci 0000:08:00.0: supports D1 D2
[    0.668674] pci 0000:08:00.1: [1002:aa60] type 0 class 0x000403
[    0.668677] pci 0000:08:00.1: calling quirk_no_ata_d3+0x0/0x1b
[    0.668678] pci 0000:08:00.1: calling quirk_mmio_always_on+0x0/0x17
[    0.668692] pci 0000:08:00.1: reg 10: [mem 0xfe9fc000-0xfe9fffff 64bit]
[    0.668728] pci 0000:08:00.1: calling quirk_resource_alignment+0x0/0x166
[    0.668745] pci 0000:08:00.1: supports D1 D2
[    0.673369] pci_bus 0000:08: fixups for bus
[    0.673372] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.673414] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.673417] pci 0000:00:03.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.673422] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.673423] pci_bus 0000:08: bus scan returning with max=08
[    0.673427] pci 0000:00:04.0: scanning [bus 07-07] behind bridge, pass 0
[    0.673458] pci_bus 0000:07: scanning bus
[    0.673475] pci 0000:07:00.0: [1106:3403] type 0 class 0x000c00
[    0.673480] pci 0000:07:00.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.673482] pci 0000:07:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.673500] pci 0000:07:00.0: reg 10: [mem 0xfe8ff800-0xfe8fffff 64bit]
[    0.673510] pci 0000:07:00.0: reg 18: [io  0xd800-0xd8ff]
[    0.673552] pci 0000:07:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.673578] pci 0000:07:00.0: supports D2
[    0.673580] pci 0000:07:00.0: PME# supported from D2 D3hot D3cold
[    0.673584] pci 0000:07:00.0: PME# disabled
[    0.680023] pci_bus 0000:07: fixups for bus
[    0.680025] pci 0000:00:04.0: PCI bridge to [bus 07-07]
[    0.680071] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.680074] pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.680078] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.680080] pci_bus 0000:07: bus scan returning with max=07
[    0.680083] pci 0000:00:05.0: scanning [bus 06-06] behind bridge, pass 0
[    0.680118] pci_bus 0000:06: scanning bus
[    0.680135] pci 0000:06:00.0: [10ec:8168] type 0 class 0x000200
[    0.680140] pci 0000:06:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.680153] pci 0000:06:00.0: reg 10: [io  0xc800-0xc8ff]
[    0.680176] pci 0000:06:00.0: reg 18: [mem 0xcffff000-0xcfffffff 64bit pref]
[    0.680191] pci 0000:06:00.0: reg 20: [mem 0xcfff8000-0xcfffbfff 64bit pref]
[    0.680201] pci 0000:06:00.0: reg 30: [mem 0xfe7e0000-0xfe7fffff pref]
[    0.680208] pci 0000:06:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.680240] pci 0000:06:00.0: supports D1 D2
[    0.680241] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.680245] pci 0000:06:00.0: PME# disabled
[    0.686689] pci_bus 0000:06: fixups for bus
[    0.686692] pci 0000:00:05.0: PCI bridge to [bus 06-06]
[    0.686738] pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
[    0.686740] pci 0000:00:05.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.686744] pci 0000:00:05.0:   bridge window [mem 0xcff00000-0xcfffffff 64bit pref]
[    0.686746] pci_bus 0000:06: bus scan returning with max=06
[    0.686749] pci 0000:00:06.0: scanning [bus 05-05] behind bridge, pass 0
[    0.686780] pci_bus 0000:05: scanning bus
[    0.686798] pci 0000:05:00.0: [10ec:8168] type 0 class 0x000200
[    0.686802] pci 0000:05:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.686815] pci 0000:05:00.0: reg 10: [io  0xb800-0xb8ff]
[    0.686838] pci 0000:05:00.0: reg 18: [mem 0xcfeff000-0xcfefffff 64bit pref]
[    0.686853] pci 0000:05:00.0: reg 20: [mem 0xcfef8000-0xcfefbfff 64bit pref]
[    0.686863] pci 0000:05:00.0: reg 30: [mem 0xfe6e0000-0xfe6fffff pref]
[    0.686871] pci 0000:05:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.686902] pci 0000:05:00.0: supports D1 D2
[    0.686903] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.686907] pci 0000:05:00.0: PME# disabled
[    0.693356] pci_bus 0000:05: fixups for bus
[    0.693358] pci 0000:00:06.0: PCI bridge to [bus 05-05]
[    0.693404] pci 0000:00:06.0:   bridge window [io  0xb000-0xbfff]
[    0.693407] pci 0000:00:06.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.693411] pci 0000:00:06.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.693412] pci_bus 0000:05: bus scan returning with max=05
[    0.693416] pci 0000:00:09.0: scanning [bus 04-04] behind bridge, pass 0
[    0.693446] pci_bus 0000:04: scanning bus
[    0.693464] pci 0000:04:00.0: [1033:0194] type 0 class 0x000c03
[    0.693468] pci 0000:04:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.693485] pci 0000:04:00.0: reg 10: [mem 0xfe5fe000-0xfe5fffff 64bit]
[    0.693531] pci 0000:04:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.693559] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.693563] pci 0000:04:00.0: PME# disabled
[    0.700022] pci_bus 0000:04: fixups for bus
[    0.700024] pci 0000:00:09.0: PCI bridge to [bus 04-04]
[    0.700063] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.700066] pci 0000:00:09.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.700071] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.700072] pci_bus 0000:04: bus scan returning with max=04
[    0.700076] pci 0000:00:14.4: scanning [bus 03-03] behind bridge, pass 0
[    0.700087] pci_bus 0000:03: scanning bus
[    0.700136] pci_bus 0000:03: fixups for bus
[    0.700138] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
[    0.700176] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.700180] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.700184] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.700186] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.700188] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.700191] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.700193] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.700194] pci 0000:00:14.4:   bridge window [mem 0xc8000000-0xdfffffff] (subtractive decode)
[    0.700196] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.700198] pci_bus 0000:03: bus scan returning with max=03
[    0.700202] pci 0000:00:15.0: scanning [bus 02-02] behind bridge, pass 0
[    0.700246] pci_bus 0000:02: scanning bus
[    0.700248] pci_bus 0000:02: fixups for bus
[    0.700249] pci 0000:00:15.0: PCI bridge to [bus 02-02]
[    0.700288] pci 0000:00:15.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.700292] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.700297] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.700298] pci_bus 0000:02: bus scan returning with max=02
[    0.700302] pci 0000:00:15.1: scanning [bus 01-01] behind bridge, pass 0
[    0.700345] pci_bus 0000:01: scanning bus
[    0.700365] pci 0000:01:00.0: [197b:2363] type 0 class 0x000101
[    0.700370] pci 0000:01:00.0: calling quirk_jmicron_ata+0x0/0x140
[    0.700383] pci 0000:01:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.700471] pci 0000:01:00.0: reg 24: [mem 0xfe4fe000-0xfe4fffff]
[    0.700492] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x166
[    0.700520] pci 0000:01:00.0: PME# supported from D3hot
[    0.700525] pci 0000:01:00.0: PME# disabled
[    0.700556] pci 0000:01:00.1: [197b:2363] type 0 class 0x000101
[    0.700565] pci 0000:01:00.1: calling quirk_jmicron_ata+0x0/0x140
[    0.700567] pci 0000:01:00.1: calling quirk_mmio_always_on+0x0/0x17
[    0.700584] pci 0000:01:00.1: reg 10: [io  0xa800-0xa807]
[    0.700598] pci 0000:01:00.1: reg 14: [io  0xa400-0xa403]
[    0.700611] pci 0000:01:00.1: reg 18: [io  0xa000-0xa007]
[    0.700625] pci 0000:01:00.1: reg 1c: [io  0x9800-0x9803]
[    0.700639] pci 0000:01:00.1: reg 20: [io  0x9400-0x940f]
[    0.700672] pci 0000:01:00.1: calling quirk_resource_alignment+0x0/0x166
[    0.700715] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.700767] pci_bus 0000:01: fixups for bus
[    0.700768] pci 0000:00:15.1: PCI bridge to [bus 01-01]
[    0.700807] pci 0000:00:15.1:   bridge window [io  0x9000-0xafff]
[    0.700810] pci 0000:00:15.1:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.700815] pci 0000:00:15.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.700816] pci_bus 0000:01: bus scan returning with max=01
[    0.700819] pci 0000:00:03.0: scanning [bus 08-08] behind bridge, pass 1
[    0.700823] pci 0000:00:04.0: scanning [bus 07-07] behind bridge, pass 1
[    0.700827] pci 0000:00:05.0: scanning [bus 06-06] behind bridge, pass 1
[    0.700830] pci 0000:00:06.0: scanning [bus 05-05] behind bridge, pass 1
[    0.700834] pci 0000:00:09.0: scanning [bus 04-04] behind bridge, pass 1
[    0.700838] pci 0000:00:14.4: scanning [bus 03-03] behind bridge, pass 1
[    0.700843] pci 0000:00:15.0: scanning [bus 02-02] behind bridge, pass 1
[    0.700848] pci 0000:00:15.1: scanning [bus 01-01] behind bridge, pass 1
[    0.700852] pci_bus 0000:00: bus scan returning with max=08
[    0.700853] pci_bus 0000:00: on NUMA node 0
[    0.700857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.701158] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC03._PRT]
[    0.701216] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC04._PRT]
[    0.701271] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC05._PRT]
[    0.701328] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC06._PRT]
[    0.701388] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PC09._PRT]
[    0.701476] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.701586] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.701643] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.720104] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 14 15)
[    0.720469] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *7 10 11 14 15)
[    0.720837] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 14 15)
[    0.721205] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 14 15)
[    0.721553] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 *11 14 15)
[    0.721882] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 *10 11 14 15)
[    0.723585] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 14 15)
[    0.723920] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.724249] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.724249] vgaarb: loaded
[    0.724249] SCSI subsystem initialized
[    0.724249] libata version 3.00 loaded.
[    0.724249] usbcore: registered new interface driver usbfs
[    0.724249] usbcore: registered new interface driver hub
[    0.724249] usbcore: registered new device driver usb
[    0.724249] PCI: Using ACPI for IRQ routing
[    0.724249] PCI: pci_cache_line_size set to 64 bytes
[    0.724249] pci 0000:00:11.0: BAR 0: reserving [io  0x8000-0x8007 flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:00:11.0: BAR 1: reserving [io  0x7000-0x7003 flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:00:11.0: BAR 2: reserving [io  0x6000-0x6007 flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:00:11.0: BAR 3: reserving [io  0x5000-0x5003 flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:00:11.0: BAR 4: reserving [io  0x3000-0x300f flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:00:11.0: BAR 5: reserving [mem 0xfe3ff000-0xfe3ff3ff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:00:12.0: BAR 0: reserving [mem 0xfe3f7000-0xfe3f7fff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:00:12.2: BAR 0: reserving [mem 0xfe3ff400-0xfe3ff4ff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:00:13.0: BAR 0: reserving [mem 0xfe3fc000-0xfe3fcfff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:00:13.2: BAR 0: reserving [mem 0xfe3ff800-0xfe3ff8ff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:00:14.2: BAR 0: reserving [mem 0xfe3f8000-0xfe3fbfff flags 0x140204] (d=0, p=0)
[    0.724249] pci 0000:00:14.5: BAR 0: reserving [mem 0xfe3fd000-0xfe3fdfff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:00:16.0: BAR 0: reserving [mem 0xfe3fe000-0xfe3fefff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:00:16.2: BAR 0: reserving [mem 0xfe3ffc00-0xfe3ffcff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:08:00.0: BAR 0: reserving [mem 0xd0000000-0xdfffffff flags 0x14220c] (d=0, p=0)
[    0.724249] pci 0000:08:00.0: BAR 2: reserving [mem 0xfe9c0000-0xfe9dffff flags 0x140204] (d=0, p=0)
[    0.724249] pci 0000:08:00.0: BAR 4: reserving [io  0xe000-0xe0ff flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:08:00.1: BAR 0: reserving [mem 0xfe9fc000-0xfe9fffff flags 0x140204] (d=0, p=0)
[    0.724249] pci 0000:07:00.0: BAR 0: reserving [mem 0xfe8ff800-0xfe8fffff flags 0x140204] (d=0, p=0)
[    0.724249] pci 0000:07:00.0: BAR 2: reserving [io  0xd800-0xd8ff flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:06:00.0: BAR 0: reserving [io  0xc800-0xc8ff flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:06:00.0: BAR 2: reserving [mem 0xcffff000-0xcfffffff flags 0x14220c] (d=0, p=0)
[    0.724249] pci 0000:06:00.0: BAR 4: reserving [mem 0xcfff8000-0xcfffbfff flags 0x14220c] (d=0, p=0)
[    0.724249] pci 0000:05:00.0: BAR 0: reserving [io  0xb800-0xb8ff flags 0x40101] (d=0, p=0)
[    0.724249] pci 0000:05:00.0: BAR 2: reserving [mem 0xcfeff000-0xcfefffff flags 0x14220c] (d=0, p=0)
[    0.724249] pci 0000:05:00.0: BAR 4: reserving [mem 0xcfef8000-0xcfefbfff flags 0x14220c] (d=0, p=0)
[    0.724249] pci 0000:04:00.0: BAR 0: reserving [mem 0xfe5fe000-0xfe5fffff flags 0x140204] (d=0, p=0)
[    0.724249] pci 0000:01:00.0: BAR 5: reserving [mem 0xfe4fe000-0xfe4fffff flags 0x40200] (d=0, p=0)
[    0.724249] pci 0000:01:00.1: BAR 0: reserving [io  0xa800-0xa807 flags 0x40101] (d=1, p=1)
[    0.724249] pci 0000:01:00.1: BAR 1: reserving [io  0xa400-0xa403 flags 0x40101] (d=1, p=1)
[    0.724249] pci 0000:01:00.1: BAR 2: reserving [io  0xa000-0xa007 flags 0x40101] (d=1, p=1)
[    0.724249] pci 0000:01:00.1: BAR 3: reserving [io  0x9800-0x9803 flags 0x40101] (d=1, p=1)
[    0.724249] pci 0000:01:00.1: BAR 4: reserving [io  0x9400-0x940f flags 0x40101] (d=1, p=1)
[    0.724249] reserve RAM buffer: 000000000009b000 - 000000000009ffff 
[    0.724249] reserve RAM buffer: 00000000c7e90000 - 00000000c7ffffff 
[    0.726740] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.726894] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.729008] Switching to clocksource tsc
[    0.729336] pnp: PnP ACPI init
[    0.729401] ACPI: bus type pnp registered
[    0.729587] pnp 00:00: [bus 00-ff]
[    0.729589] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.729590] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.729592] pnp 00:00: [io  0x0d00-0xffff window]
[    0.729593] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.729595] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.729597] pnp 00:00: [mem 0xc8000000-0xdfffffff window]
[    0.729598] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.729683] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.729683] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.729683] pnp 00:01: [mem 0xfec20000-0xfec200ff]
[    0.729683] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.729683] pnp 00:02: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.729683] pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.729683] pnp 00:03: [dma 4]
[    0.729683] pnp 00:03: [io  0x0000-0x000f]
[    0.729683] pnp 00:03: [io  0x0081-0x0083]
[    0.729683] pnp 00:03: [io  0x0087]
[    0.729683] pnp 00:03: [io  0x0089-0x008b]
[    0.729683] pnp 00:03: [io  0x008f]
[    0.729683] pnp 00:03: [io  0x00c0-0x00df]
[    0.729683] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.729683] pnp 00:04: [io  0x0070-0x0071]
[    0.729683] pnp 00:04: [irq 8]
[    0.729683] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.729683] pnp 00:05: [io  0x0061]
[    0.729683] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.729683] pnp 00:06: [io  0x00f0-0x00ff]
[    0.729683] pnp 00:06: [irq 13]
[    0.729683] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.729683] pnp 00:07: [io  0x03f8-0x03ff]
[    0.729683] pnp 00:07: [irq 4]
[    0.729683] pnp 00:07: [dma 0 disabled]
[    0.729683] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.729683] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.729683] pnp 00:08: [io  0x0600-0x06df]
[    0.729683] pnp 00:08: [io  0x0ae0-0x0aef]
[    0.729683] pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.729683] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.729683] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.729683] pnp 00:0a: [io  0x0060]
[    0.729683] pnp 00:0a: [io  0x0064]
[    0.729683] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
[    0.729683] pnp 00:0a: [mem 0xfee00000-0xfee00fff]
[    0.729823] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.730060] pnp 00:0b: [io  0x0010-0x001f]
[    0.730061] pnp 00:0b: [io  0x0022-0x003f]
[    0.730063] pnp 00:0b: [io  0x0062-0x0063]
[    0.730064] pnp 00:0b: [io  0x0065-0x006f]
[    0.730065] pnp 00:0b: [io  0x0072-0x007f]
[    0.730067] pnp 00:0b: [io  0x0080]
[    0.730068] pnp 00:0b: [io  0x0084-0x0086]
[    0.730069] pnp 00:0b: [io  0x0088]
[    0.730071] pnp 00:0b: [io  0x008c-0x008e]
[    0.730072] pnp 00:0b: [io  0x0090-0x009f]
[    0.730073] pnp 00:0b: [io  0x00a2-0x00bf]
[    0.730074] pnp 00:0b: [io  0x00b1]
[    0.730076] pnp 00:0b: [io  0x00e0-0x00ef]
[    0.730077] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.730078] pnp 00:0b: [io  0x040b]
[    0.730080] pnp 00:0b: [io  0x04d6]
[    0.730081] pnp 00:0b: [io  0x0c00-0x0c01]
[    0.730082] pnp 00:0b: [io  0x0c14]
[    0.730083] pnp 00:0b: [io  0x0c50-0x0c51]
[    0.730085] pnp 00:0b: [io  0x0c52]
[    0.730086] pnp 00:0b: [io  0x0c6c]
[    0.730087] pnp 00:0b: [io  0x0c6f]
[    0.730088] pnp 00:0b: [io  0x0cd0-0x0cd1]
[    0.730090] pnp 00:0b: [io  0x0cd2-0x0cd3]
[    0.730091] pnp 00:0b: [io  0x0cd4-0x0cd5]
[    0.730092] pnp 00:0b: [io  0x0cd6-0x0cd7]
[    0.730094] pnp 00:0b: [io  0x0cd8-0x0cdf]
[    0.730097] pnp 00:0b: [io  0x0800-0x089f]
[    0.730098] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.730100] pnp 00:0b: [io  0x0b00-0x0b1f]
[    0.730101] pnp 00:0b: [io  0x0b20-0x0b3f]
[    0.730102] pnp 00:0b: [io  0x0900-0x090f]
[    0.730103] pnp 00:0b: [io  0x0910-0x091f]
[    0.730105] pnp 00:0b: [io  0xfe00-0xfefe]
[    0.730106] pnp 00:0b: [io  0x0060]
[    0.730107] pnp 00:0b: [io  0x0064]
[    0.730109] pnp 00:0b: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.730110] pnp 00:0b: [mem 0xffb80000-0xffbfffff]
[    0.730112] pnp 00:0b: [mem 0xfec10000-0xfec1001f]
[    0.730113] pnp 00:0b: [mem 0xfed80000-0xfed80fff]
[    0.730115] pnp 00:0b: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.730342] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.730406] pnp 00:0c: [mem 0xe0000000-0xefffffff]
[    0.730592] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.730834] pnp 00:0d: [mem 0x00000000-0x0009ffff]
[    0.730836] pnp 00:0d: [mem 0x000c0000-0x000cffff]
[    0.730838] pnp 00:0d: [mem 0x000e0000-0x000fffff]
[    0.730839] pnp 00:0d: [mem 0x00100000-0xc7ffffff]
[    0.730841] pnp 00:0d: [mem 0xfec00000-0xffffffff]
[    0.731027] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.731183] pnp: PnP ACPI: found 14 devices
[    0.731218] ACPI: ACPI bus type pnp unregistered
[    0.731274] system 00:01: [mem 0xfec20000-0xfec200ff] could not be reserved
[    0.731320] system 00:08: [io  0x0600-0x06df] has been reserved
[    0.731356] system 00:08: [io  0x0ae0-0x0aef] has been reserved
[    0.731397] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.731433] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.731474] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.731510] system 00:0b: [io  0x040b] has been reserved
[    0.731545] system 00:0b: [io  0x04d6] has been reserved
[    0.731581] system 00:0b: [io  0x0c00-0x0c01] has been reserved
[    0.731617] system 00:0b: [io  0x0c14] has been reserved
[    0.731652] system 00:0b: [io  0x0c50-0x0c51] has been reserved
[    0.731688] system 00:0b: [io  0x0c52] has been reserved
[    0.731723] system 00:0b: [io  0x0c6c] has been reserved
[    0.731759] system 00:0b: [io  0x0c6f] has been reserved
[    0.731794] system 00:0b: [io  0x0cd0-0x0cd1] has been reserved
[    0.731830] system 00:0b: [io  0x0cd2-0x0cd3] has been reserved
[    0.731866] system 00:0b: [io  0x0cd4-0x0cd5] has been reserved
[    0.731902] system 00:0b: [io  0x0cd6-0x0cd7] has been reserved
[    0.731938] system 00:0b: [io  0x0cd8-0x0cdf] has been reserved
[    0.731974] system 00:0b: [io  0x0800-0x089f] has been reserved
[    0.732010] system 00:0b: [io  0x0b00-0x0b1f] has been reserved
[    0.732046] system 00:0b: [io  0x0b20-0x0b3f] has been reserved
[    0.732081] system 00:0b: [io  0x0900-0x090f] has been reserved
[    0.732117] system 00:0b: [io  0x0910-0x091f] has been reserved
[    0.732153] system 00:0b: [io  0xfe00-0xfefe] has been reserved
[    0.732190] system 00:0b: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.732226] system 00:0b: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.732262] system 00:0b: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.732302] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.732343] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.732380] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.732417] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.732453] system 00:0d: [mem 0x00100000-0xc7ffffff] could not be reserved
[    0.732490] system 00:0d: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.743575] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.743612] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.743649] pci 0000:00:03.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.743686] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.743727] pci 0000:00:04.0: PCI bridge to [bus 07-07]
[    0.743762] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.743799] pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.743836] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    0.743873] pci 0000:00:05.0: PCI bridge to [bus 06-06]
[    0.743908] pci 0000:00:05.0:   bridge window [io  0xc000-0xcfff]
[    0.743944] pci 0000:00:05.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.743984] pci 0000:00:05.0:   bridge window [mem 0xcff00000-0xcfffffff 64bit pref]
[    0.744041] pci 0000:00:06.0: PCI bridge to [bus 05-05]
[    0.744077] pci 0000:00:06.0:   bridge window [io  0xb000-0xbfff]
[    0.744114] pci 0000:00:06.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.744152] pci 0000:00:06.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.744194] pci 0000:00:09.0: PCI bridge to [bus 04-04]
[    0.744229] pci 0000:00:09.0:   bridge window [io  disabled]
[    0.744266] pci 0000:00:09.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.744303] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    0.744341] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.744376] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.744414] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.744452] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.744497] pci 0000:00:15.0: PCI bridge to [bus 02-02]
[    0.744531] pci 0000:00:15.0:   bridge window [io  disabled]
[    0.744568] pci 0000:00:15.0:   bridge window [mem disabled]
[    0.744604] pci 0000:00:15.0:   bridge window [mem pref disabled]
[    0.744643] pci 0000:00:15.1: PCI bridge to [bus 01-01]
[    0.744678] pci 0000:00:15.1:   bridge window [io  0x9000-0xafff]
[    0.744716] pci 0000:00:15.1:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.744752] pci 0000:00:15.1:   bridge window [mem pref disabled]
[    0.744800] pci 0000:00:03.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    0.744837] pci 0000:00:03.0: setting latency timer to 64
[    0.744842] pci 0000:00:04.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    0.744879] pci 0000:00:04.0: setting latency timer to 64
[    0.744883] pci 0000:00:05.0: PCI INT A -> GSI 52 (level, low) -> IRQ 52
[    0.744919] pci 0000:00:05.0: setting latency timer to 64
[    0.744926] pci 0000:00:06.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
[    0.744963] pci 0000:00:06.0: setting latency timer to 64
[    0.744967] pci 0000:00:09.0: PCI INT A -> GSI 53 (level, low) -> IRQ 53
[    0.745003] pci 0000:00:09.0: setting latency timer to 64
[    0.745015] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.745052] pci 0000:00:15.0: setting latency timer to 64
[    0.745057] pci 0000:00:15.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.745094] pci 0000:00:15.1: setting latency timer to 64
[    0.745097] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.745098] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.745100] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.745101] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.745103] pci_bus 0000:00: resource 8 [mem 0xc8000000-0xdfffffff]
[    0.745104] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.745106] pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
[    0.745107] pci_bus 0000:08: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.745109] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.745110] pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
[    0.745112] pci_bus 0000:07: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.745113] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.745115] pci_bus 0000:06: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.745116] pci_bus 0000:06: resource 2 [mem 0xcff00000-0xcfffffff 64bit pref]
[    0.745118] pci_bus 0000:05: resource 0 [io  0xb000-0xbfff]
[    0.745119] pci_bus 0000:05: resource 1 [mem 0xfe600000-0xfe6fffff]
[    0.745121] pci_bus 0000:05: resource 2 [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.745122] pci_bus 0000:04: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.745124] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.745125] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.745127] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.745128] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.745130] pci_bus 0000:03: resource 8 [mem 0xc8000000-0xdfffffff]
[    0.745131] pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.745133] pci_bus 0000:01: resource 0 [io  0x9000-0xafff]
[    0.745134] pci_bus 0000:01: resource 1 [mem 0xfe400000-0xfe4fffff]
[    0.745174] NET: Registered protocol family 2
[    0.745347] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.746004] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.746975] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    0.749749] TCP: Hash tables configured (established 262144 bind 65536)
[    0.749810] TCP reno registered
[    0.749893] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    0.750150] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    0.750483] NET: Registered protocol family 1
[    0.750565] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750568] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750571] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xb0
[    0.750576] pci 0000:00:03.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750579] pci 0000:00:03.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750581] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xb0
[    0.750584] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750586] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750588] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xb0
[    0.750592] pci 0000:00:05.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750594] pci 0000:00:05.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750596] pci 0000:00:05.0: calling pci_fixup_video+0x0/0xb0
[    0.750600] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750602] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750604] pci 0000:00:06.0: calling pci_fixup_video+0x0/0xb0
[    0.750611] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750613] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750615] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xb0
[    0.750619] pci 0000:00:11.0: calling quirk_msi_intx_disable_ati_bug+0x0/0x41
[    0.750625] pci 0000:00:11.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750627] pci 0000:00:11.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    0.750629] pci 0000:00:11.0: calling pci_fixup_video+0x0/0xb0
[    0.750633] pci 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.750635] pci 0000:00:12.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.510827] pci 0000:00:12.0: calling pci_fixup_video+0x0/0xb0
[    1.510835] pci 0000:00:12.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.510838] pci 0000:00:12.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.510867] pci 0000:00:12.2: calling pci_fixup_video+0x0/0xb0
[    1.510872] pci 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.510874] pci 0000:00:13.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.534158] pci 0000:00:13.0: calling pci_fixup_video+0x0/0xb0
[    1.534166] pci 0000:00:13.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.534169] pci 0000:00:13.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.534197] pci 0000:00:13.2: calling pci_fixup_video+0x0/0xb0
[    1.534202] pci 0000:00:14.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.534204] pci 0000:00:14.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.534206] pci 0000:00:14.0: calling pci_fixup_video+0x0/0xb0
[    1.534210] pci 0000:00:14.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.534213] pci 0000:00:14.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.534215] pci 0000:00:14.2: calling pci_fixup_video+0x0/0xb0
[    1.534219] pci 0000:00:14.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.534221] pci 0000:00:14.3: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.534223] pci 0000:00:14.3: calling pci_fixup_video+0x0/0xb0
[    1.534228] pci 0000:00:14.4: calling quirk_cardbus_legacy+0x0/0x30
[    1.534230] pci 0000:00:14.4: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.534232] pci 0000:00:14.4: calling pci_fixup_video+0x0/0xb0
[    1.534236] pci 0000:00:14.5: calling quirk_cardbus_legacy+0x0/0x30
[    1.534239] pci 0000:00:14.5: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.557496] pci 0000:00:14.5: calling pci_fixup_video+0x0/0xb0
[    1.557504] pci 0000:00:15.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.557506] pci 0000:00:15.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.557508] pci 0000:00:15.0: calling pci_fixup_video+0x0/0xb0
[    1.557513] pci 0000:00:15.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.557515] pci 0000:00:15.1: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.557517] pci 0000:00:15.1: calling pci_fixup_video+0x0/0xb0
[    1.557521] pci 0000:00:16.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.557523] pci 0000:00:16.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580831] pci 0000:00:16.0: calling pci_fixup_video+0x0/0xb0
[    1.580838] pci 0000:00:16.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.580841] pci 0000:00:16.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580868] pci 0000:00:16.2: calling pci_fixup_video+0x0/0xb0
[    1.580872] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580875] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580877] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xb0
[    1.580881] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.580883] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580885] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xb0
[    1.580888] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.580891] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580893] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xb0
[    1.580896] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.580899] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580901] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xb0
[    1.580904] pci 0000:00:18.4: calling quirk_cardbus_legacy+0x0/0x30
[    1.580906] pci 0000:00:18.4: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580909] pci 0000:00:18.4: calling pci_fixup_video+0x0/0xb0
[    1.580912] pci 0000:08:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580914] pci 0000:08:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580917] pci 0000:08:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580920] pci 0000:08:00.0: Boot video device
[    1.580924] pci 0000:08:00.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.580926] pci 0000:08:00.1: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580928] pci 0000:08:00.1: calling pci_fixup_video+0x0/0xb0
[    1.580932] pci 0000:07:00.0: calling via_no_dac+0x0/0x3b
[    1.580934] pci 0000:07:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580936] pci 0000:07:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580939] pci 0000:07:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580943] pci 0000:06:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580945] pci 0000:06:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580947] pci 0000:06:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580952] pci 0000:05:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580954] pci 0000:05:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580956] pci 0000:05:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580961] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580963] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580987] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xb0
[    1.580991] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.580993] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.580995] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xb0
[    1.581001] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.581003] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x4bf
[    1.581005] pci 0000:01:00.1: calling pci_fixup_video+0x0/0xb0
[    1.581009] PCI: CLS 64 bytes, default 64
[    1.581140] Trying to unpack rootfs image as initramfs...
[    1.783879] debug: unmapping init memory ffff8800370fc000..ffff880037ff0000
[    1.784884] PCI-DMA: Disabling AGP.
[    1.785172] PCI-DMA: aperture base @ bc000000 size 65536 KB
[    1.785208] PCI-DMA: using GART IOMMU.
[    1.785244] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.804866] audit: initializing netlink socket (disabled)
[    1.804934] type=2000 audit(1293399607.803:1): initialized
[    1.805425] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.810934] VFS: Disk quotas dquot_6.5.2
[    1.811159] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.811692] msgmni has been set to 7846
[    1.812003] SELinux:  Registering netfilter hooks
[    1.812597] io scheduler noop registered
[    1.812635] io scheduler deadline registered
[    1.812852] io scheduler cfq registered (default)
[    1.813579] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1d
[    1.813624] pcieport 0000:00:03.0: setting latency timer to 64
[    1.813674] pcieport 0000:00:03.0: irq 72 for MSI/MSI-X
[    1.813835] pcieport 0000:00:04.0: ACPI _OSC control granted for 0x1d
[    1.813876] pcieport 0000:00:04.0: setting latency timer to 64
[    1.813903] pcieport 0000:00:04.0: irq 73 for MSI/MSI-X
[    1.814049] pcieport 0000:00:05.0: ACPI _OSC control granted for 0x1d
[    1.814089] pcieport 0000:00:05.0: setting latency timer to 64
[    1.814116] pcieport 0000:00:05.0: irq 74 for MSI/MSI-X
[    1.814265] pcieport 0000:00:06.0: ACPI _OSC control granted for 0x1d
[    1.814305] pcieport 0000:00:06.0: setting latency timer to 64
[    1.814332] pcieport 0000:00:06.0: irq 75 for MSI/MSI-X
[    1.814478] pcieport 0000:00:09.0: ACPI _OSC control granted for 0x1d
[    1.814518] pcieport 0000:00:09.0: setting latency timer to 64
[    1.814545] pcieport 0000:00:09.0: irq 76 for MSI/MSI-X
[    1.814701] pcieport 0000:00:15.0: ACPI _OSC control granted for 0x1d
[    1.814743] pcieport 0000:00:15.0: setting latency timer to 64
[    1.814784] pcieport 0000:00:15.0: irq 77 for MSI/MSI-X
[    1.814961] pcieport 0000:00:15.1: ACPI _OSC control granted for 0x1d
[    1.815003] pcieport 0000:00:15.1: setting latency timer to 64
[    1.815044] pcieport 0000:00:15.1: irq 78 for MSI/MSI-X
[    1.815389] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    1.815428] pci 0000:08:00.0: Signaling PME through PCIe PME interrupt
[    1.815464] pci 0000:08:00.1: Signaling PME through PCIe PME interrupt
[    1.815501] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    1.815525] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
[    1.815561] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    1.815598] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[    1.815620] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    1.815657] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    1.815693] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    1.815714] pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
[    1.815750] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    1.815787] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    1.815810] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    1.815847] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    1.815884] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    1.815908] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    1.815945] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.815969] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    1.816006] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.816042] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    1.816079] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    1.867039] Linux agpgart interface v0.103
[    1.867152] [drm] Initialized drm 1.1.0 20060810
[    1.867283] [drm] radeon defaulting to kernel modesetting.
[    1.867319] [drm] radeon kernel modesetting enabled.
[    1.867433] radeon 0000:08:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    1.867475] radeon 0000:08:00.0: setting latency timer to 64
[    1.869978] [drm] initializing kernel modesetting (REDWOOD 0x1002:0x68DA).
[    1.870209] [drm] register mmio base: 0xFE9C0000
[    1.870245] [drm] register mmio size: 131072
[    1.870911] ATOM BIOS: REDWOOD
[    1.870988] radeon 0000:08:00.0: GPU softreset 
[    1.871023] radeon 0000:08:00.0:   GRBM_STATUS=0x00003828
[    1.871059] radeon 0000:08:00.0:   GRBM_STATUS_SE0=0x00000007
[    1.871094] radeon 0000:08:00.0:   GRBM_STATUS_SE1=0x00000007
[    1.871130] radeon 0000:08:00.0:   SRBM_STATUS=0x200000C0
[    1.871175] radeon 0000:08:00.0:   GRBM_SOFT_RESET=0x00007F6B
[    1.871312] radeon 0000:08:00.0:   GRBM_STATUS=0x00003828
[    1.871350] radeon 0000:08:00.0:   GRBM_STATUS_SE0=0x00000007
[    1.871385] radeon 0000:08:00.0:   GRBM_STATUS_SE1=0x00000007
[    1.871421] radeon 0000:08:00.0:   SRBM_STATUS=0x200000C0
[    1.872494] radeon 0000:08:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    1.872567] radeon 0000:08:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    1.876712] [drm] Detected VRAM RAM=1024M, BAR=256M
[    1.876752] [drm] RAM width 128bits DDR
[    1.877054] [TTM] Zone  kernel: Available graphics memory: 2008722 kiB.
[    1.877090] [TTM] Initializing pool allocator.
[    1.877360] [drm] radeon: 1024M of VRAM memory ready
[    1.877429] [drm] radeon: 512M of GTT memory ready.
[    1.877556] radeon 0000:08:00.0: irq 79 for MSI/MSI-X
[    1.877562] radeon 0000:08:00.0: radeon: using MSI.
[    1.877640] [drm] radeon: irq initialized.
[    1.877677] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.878378] [drm] Loading REDWOOD Microcode
[    1.880754] radeon 0000:08:00.0: WB enabled
[    1.897686] [drm] ring test succeeded in 1 usecs
[    1.898422] [drm] radeon: ib pool ready.
[    1.898745] [drm] ib test succeeded in 0 usecs
[    1.898797] failed to evaluate ATIF got AE_BAD_PARAMETER
[    1.899989] [drm] Radeon Display Connectors
[    1.900029] [drm] Connector 0:
[    1.900063] [drm]   HDMI-A
[    1.900096] [drm]   HPD2
[    1.900130] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[    1.900169] [drm]   Encoders:
[    1.900203] [drm]     DFP1: INTERNAL_UNIPHY2
[    1.900237] [drm] Connector 1:
[    1.900271] [drm]   DVI-I
[    1.900304] [drm]   HPD1
[    1.900337] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[    1.900375] [drm]   Encoders:
[    1.900409] [drm]     DFP2: INTERNAL_UNIPHY1
[    1.900443] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.900477] [drm] Connector 2:
[    1.900511] [drm]   VGA
[    1.900544] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    1.900582] [drm]   Encoders:
[    1.900615] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    1.958323] [drm] Internal thermal controller without fan control
[    1.958629] [drm] radeon: power management initialized
[    2.031773] [drm] fb mappable at 0xD0141000
[    2.031842] [drm] vram apper at 0xD0000000
[    2.031876] [drm] size 5914624
[    2.031909] [drm] fb depth is 24
[    2.031943] [drm]    pitch is 5632
[    2.265160] Console: switching to colour frame buffer device 175x65
[    2.269013] fb0: radeondrmfb frame buffer device
[    2.269033] drm: registered panic notifier
[    2.269079] [drm] Initialized radeon 2.7.0 20080528 for 0000:08:00.0 on minor 0
[    2.269247] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.289943] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.524737] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.580061] brd: module loaded
[    2.581662] loop: module loaded
[    2.581903] ahci 0000:00:11.0: version 3.0
[    2.581919] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.581989] ahci 0000:00:11.0: irq 80 for MSI/MSI-X
[    2.582133] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    2.582171] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    2.584581] scsi0 : ahci
[    2.584924] scsi1 : ahci
[    2.585137] scsi2 : ahci
[    2.585359] scsi3 : ahci
[    2.585562] scsi4 : ahci
[    2.585767] scsi5 : ahci
[    2.585950] ata1: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff100 irq 80
[    2.585985] ata2: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff180 irq 80
[    2.586019] ata3: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff200 irq 80
[    2.586053] ata4: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff280 irq 80
[    2.586087] ata5: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff300 irq 80
[    2.586122] ata6: SATA max UDMA/133 abar m1024@0xfe3ff000 port 0xfe3ff380 irq 80
[    2.586247] ahci 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.596753] ahci 0000:01:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.596794] ahci 0000:01:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.596839] ahci 0000:01:00.0: setting latency timer to 64
[    2.597854] scsi6 : ahci
[    2.598091] scsi7 : ahci
[    2.598372] ata7: SATA max UDMA/133 abar m8192@0xfe4fe000 port 0xfe4fe100 irq 17
[    2.598409] ata8: SATA max UDMA/133 abar m8192@0xfe4fe000 port 0xfe4fe180 irq 17
[    2.599223] usbcore: registered new interface driver libusual
[    2.599508] PNP: No PS/2 controller found. Probing ports directly.
[    2.600056] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.600113] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.600627] mice: PS/2 mouse device common for all mice
[    2.601864] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    2.603094] md: raid1 personality registered for level 1
[    2.603929] md: multipath personality registered for level -4
[    2.604756] cpuidle: using governor ladder
[    2.605569] cpuidle: using governor menu
[    2.607457] usbcore: registered new interface driver usbhid
[    2.608308] usbhid: USB HID core driver
[    2.609558] TCP bic registered
[    2.610617] NET: Registered protocol family 33
[    2.611468] Registering the dns_resolver key type
[    2.612724] PM: Checking hibernation image partition /dev/sda2
[    2.903424] ata5: SATA link down (SStatus 0 SControl 300)
[    2.904370] ata6: SATA link down (SStatus 0 SControl 300)
[    2.905288] ata2: SATA link down (SStatus 0 SControl 300)
[    2.906264] ata4: SATA link down (SStatus 0 SControl 300)
[    2.916763] ata7: SATA link down (SStatus 0 SControl 300)
[    2.917668] ata8: SATA link down (SStatus 0 SControl 300)
[    3.070107] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.070992] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.076701] ata1.00: ATA-8: SAMSUNG HD103SJ, 1AJ10001, max UDMA/133
[    3.077516] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.078469] ata3.00: ATA-8: SAMSUNG HD103SJ, 1AJ10001, max UDMA/133
[    3.079280] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.084110] ata1.00: configured for UDMA/133
[    3.085566] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103SJ  1AJ1 PQ: 0 ANSI: 5
[    3.085874] ata3.00: configured for UDMA/133
[    3.087954] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103SJ  1AJ1 PQ: 0 ANSI: 5
[    3.089286] PM: Hibernation image not present or could not be loaded.
[    3.089728]   Magic number: 6:353:703
[    3.091050] debug: unmapping init memory ffffffff81a93000..ffffffff81b0f000
[    3.091997] Write protecting the kernel read-only data: 10240k
[    3.093049] debug: unmapping init memory ffff88000149e000..ffff880001600000
[    3.094039] debug: unmapping init memory ffff880001851000..ffff880001a00000
[    3.128272] pata_jmicron 0000:01:00.1: enabling device (0000 -> 0001)
[    3.129227] pata_jmicron 0000:01:00.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    3.130164] pata_jmicron 0000:01:00.1: enabling bus mastering
[    3.130170] pata_jmicron 0000:01:00.1: setting latency timer to 64
[    3.131151] scsi8 : pata_jmicron
[    3.132310] scsi9 : pata_jmicron
[    3.134295] ata9: PATA max UDMA/100 cmd 0xa800 ctl 0xa400 bmdma 0x9400 irq 18
[    3.135173] ata10: PATA max UDMA/100 cmd 0xa000 ctl 0x9800 bmdma 0x9408 irq 18
[    3.290654] ata9.00: ATAPI: TSSTcorpCD/DVDW SH-S182M, SB03, max UDMA/33
[    3.303952] ata9.00: configured for UDMA/33
[    3.306525] scsi 8:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182M SB03 PQ: 0 ANSI: 5
[    3.471879] modprobe used greatest stack depth: 4120 bytes left
[    3.480259] ACPI: acpi_idle registered with cpuidle
[    3.492778] udev: starting version 157
[    3.493888] udevd (1391): /proc/1391/oom_adj is deprecated, please use /proc/1391/oom_score_adj instead.
[    3.565105] rtc_cmos 00:04: RTC can wake from S4
[    3.575209] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.576334] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.581535] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.582835] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.583483] sd 0:0:0:0: [sda] Write Protect is off
[    3.583486] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.583612] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.586233] sd 2:0:0:0: [sdb] Write Protect is off
[    3.586409] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.586455] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.589461] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.589470] ehci_hcd 0000:00:12.2: enabling bus mastering
[    3.589475] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    3.589492] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.592983] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    3.599169]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    3.602155] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.603422] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.604048] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.604743]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
[    3.607228] ehci_hcd 0000:00:12.2: debug port 1
[    3.608382] ehci_hcd 0000:00:12.2: enabling Mem-Wr-Inval
[    3.608401] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe3ff400
[    3.610041] sd 2:0:0:0: [sdb] Attached SCSI disk
[    3.616784] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    3.618190] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.619356] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.620639] usb usb1: Product: EHCI Host Controller
[    3.621812] usb usb1: Manufacturer: Linux 2.6.37-rc7+ ehci_hcd
[    3.623016] usb usb1: SerialNumber: 0000:00:12.2
[    3.629387] hub 1-0:1.0: USB hub found
[    3.630685] hub 1-0:1.0: 5 ports detected
[    3.634125] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.635411] ehci_hcd 0000:00:13.2: enabling bus mastering
[    3.635415] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    3.637341] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    3.646806] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.648106] ehci_hcd 0000:00:13.2: debug port 1
[    3.649340] ehci_hcd 0000:00:13.2: enabling Mem-Wr-Inval
[    3.649355] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfe3ff800
[    3.660073] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    3.661317] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.662502] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.663707] usb usb2: Product: EHCI Host Controller
[    3.664878] usb usb2: Manufacturer: Linux 2.6.37-rc7+ ehci_hcd
[    3.666078] usb usb2: SerialNumber: 0000:00:13.2
[    3.668562] hub 2-0:1.0: USB hub found
[    3.669766] hub 2-0:1.0: 5 ports detected
[    3.672347] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.673615] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    3.675181] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    3.683416] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfe3f7000
[    3.740864] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.742054] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.743242] usb usb3: Product: OHCI Host Controller
[    3.744430] usb usb3: Manufacturer: Linux 2.6.37-rc7+ ohci_hcd
[    3.745604] usb usb3: SerialNumber: 0000:00:12.0
[    3.749866] hub 3-0:1.0: USB hub found
[    3.751152] hub 3-0:1.0: 5 ports detected
[    3.753320] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.754593] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.756392] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 4
[    3.763402] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe3fc000
[    3.824125] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.825231] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.826315] usb usb4: Product: OHCI Host Controller
[    3.827432] usb usb4: Manufacturer: Linux 2.6.37-rc7+ ohci_hcd
[    3.828512] usb usb4: SerialNumber: 0000:00:13.0
[    3.830024] hub 4-0:1.0: USB hub found
[    3.831154] hub 4-0:1.0: 5 ports detected
[    3.831537] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.831564] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    3.831790] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 5
[    3.856806] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe3fd000
[    3.914108] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.915174] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.916226] usb usb5: Product: OHCI Host Controller
[    3.917289] usb usb5: Manufacturer: Linux 2.6.37-rc7+ ohci_hcd
[    3.918316] usb usb5: SerialNumber: 0000:00:14.5
[    3.919740] hub 5-0:1.0: USB hub found
[    3.920806] hub 5-0:1.0: 2 ports detected
[    3.922208] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.923246] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    3.924506] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 6
[    3.960085] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfe3fe000
[    4.017464] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.018477] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.019483] usb usb6: Product: OHCI Host Controller
[    4.020532] usb usb6: Manufacturer: Linux 2.6.37-rc7+ ohci_hcd
[    4.021530] usb usb6: SerialNumber: 0000:00:16.0
[    4.022923] hub 6-0:1.0: USB hub found
[    4.023968] hub 6-0:1.0: 4 ports detected
[    4.025301] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.026439] ehci_hcd 0000:00:16.2: enabling bus mastering
[    4.026444] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    4.027741] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 7
[    4.063445] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    4.064522] ehci_hcd 0000:00:16.2: debug port 1
[    4.065528] ehci_hcd 0000:00:16.2: enabling Mem-Wr-Inval
[    4.065541] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfe3ffc00
[    4.073427] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    4.074469] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    4.075479] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.076483] usb usb7: Product: EHCI Host Controller
[    4.077507] usb usb7: Manufacturer: Linux 2.6.37-rc7+ ehci_hcd
[    4.078505] usb usb7: SerialNumber: 0000:00:16.2
[    4.079859] hub 7-0:1.0: USB hub found
[    4.080910] hub 7-0:1.0: 4 ports detected
[    4.240053] usb 3-2: new full speed USB device using ohci_hcd and address 2
[    4.406897] usb 3-2: New USB device found, idVendor=046d, idProduct=c526
[    4.407922] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.408930] usb 3-2: Product: USB Receiver
[    4.409928] usb 3-2: Manufacturer: Logitech
[    4.418427] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input1
[    4.420547] generic-usb 0003:046D:C526.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-2/input0
[    4.429121] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.1/input/input2
[    4.431205] generic-usb 0003:046D:C526.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.0-2/input1
[    4.680047] usb 3-3: new low speed USB device using ohci_hcd and address 3
[    4.842951] usb 3-3: New USB device found, idVendor=046d, idProduct=c517
[    4.844097] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.845233] usb 3-3: Product: USB Receiver
[    4.846354] usb 3-3: Manufacturer: Logitech
[    4.876895] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.0/input/input3
[    4.878323] logitech 0003:046D:C517.0003: input,hidraw2: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.0-3/input0
[    4.886914] logitech 0003:046D:C517.0004: fixing up Logitech keyboard report descriptor
[    4.888740] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.1/input/input4
[    4.890451] logitech 0003:046D:C517.0004: input,hiddev0,hidraw3: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-3/input1
[    5.000322] md: raid0 personality registered for level 0
[    5.006901] md: raid10 personality registered for level 10
[    5.070030] raid6: int64x1   3019 MB/s
[    5.126680] raid6: int64x2   4308 MB/s
[    5.183351] raid6: int64x4   3152 MB/s
[    5.240024] raid6: int64x8   2873 MB/s
[    5.296675] raid6: sse2x1    4913 MB/s
[    5.353397] raid6: sse2x2    7972 MB/s
[    5.410035] raid6: sse2x4    9275 MB/s
[    5.411241] raid6: using algorithm sse2x4 (9275 MB/s)
[    5.414498] xor: automatically using best checksumming function: generic_sse
[    5.430019]    generic_sse:  6315.600 MB/sec
[    5.431268] xor: using function: generic_sse (6315.600 MB/sec)
[    5.437873] md: raid6 personality registered for level 6
[    5.439107] md: raid5 personality registered for level 5
[    5.440350] md: raid4 personality registered for level 4
[    5.472138] md: md0 stopped.
[    5.475012] md: bind<sdb3>
[    5.476379] md: bind<sda3>
[    5.479256] bio: create slab <bio-1> at 1
[    5.480663] md/raid1:md0: active with 2 out of 2 mirrors
[    5.481987] created bitmap (200 pages) for device md0
[    5.494901] md0: bitmap initialized from disk: read 13/13 pages, set 1324 bits
[    5.520892] md0: detected capacity change from 0 to 107373060096
[    5.524888] md0: detected capacity change from 0 to 107373060096
[    5.526391]  md0: unknown partition table
[    5.630872] PM: Marking nosave pages: 000000000009b000 - 0000000000100000
[    5.630874] PM: Marking nosave pages: 00000000c7e90000 - 0000000100000000
[    5.631326] PM: Marking nosave pages: 00000000bc000000 - 00000000c0000000
[    5.631491] PM: Basic memory bitmaps created
[    5.651201] PM: Basic memory bitmaps freed
[    5.662579] PM: Starting manual resume from disk
[    5.663957] PM: Hibernation image partition 8:2 present
[    5.663958] PM: Looking for hibernation image.
[    5.664254] PM: Image not found (code -22)
[    5.664256] PM: Hibernation image not present or could not be loaded.
[    7.616028] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    7.682224] EXT4-fs (md0): re-mounted. Opts: acl,user_xattr
[    8.259119] showconsole used greatest stack depth: 3792 bytes left
[   10.450317] udev: starting version 157
[   10.614026] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
[   10.615212] ACPI: Power Button [PWRB]
[   10.616548] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
[   10.617775] ACPI: Power Button [PWRF]
[   10.768412] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[   10.769711] xhci_hcd 0000:04:00.0: setting latency timer to 64
[   10.769715] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   10.771674] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 8
[   10.780189] xhci_hcd 0000:04:00.0: enabling Mem-Wr-Inval
[   10.780223] xhci_hcd 0000:04:00.0: irq 48, io mem 0xfe5fe000
[   10.781562] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[   10.781567] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[   10.781571] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[   10.781575] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[   10.781578] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[   10.781582] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[   10.781586] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[   10.783555] usb usb8: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[   10.784858] usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
[   10.786135] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.787475] usb usb8: Product: xHCI Host Controller
[   10.788735] usb usb8: Manufacturer: Linux 2.6.37-rc7+ xhci_hcd
[   10.789998] usb usb8: SerialNumber: 0000:04:00.0
[   10.792458] xHCI xhci_add_endpoint called for root hub
[   10.792461] xHCI xhci_check_bandwidth called for root hub
[   10.792933] hub 8-0:1.0: USB hub found
[   10.794325] hub 8-0:1.0: 4 ports detected
[   10.815375] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.817290] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   10.819160] scsi 8:0:0:0: Attached scsi generic sg2 type 5
[   10.841244] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   10.842573] r8169 0000:06:00.0: PCI INT A -> GSI 46 (level, low) -> IRQ 46
[   10.843935] r8169 0000:06:00.0: enabling Mem-Wr-Inval
[   10.843988] r8169 0000:06:00.0: setting latency timer to 64
[   10.844034] r8169 0000:06:00.0: irq 88 for MSI/MSI-X
[   10.846224] r8169 0000:06:00.0: eth0: RTL8168d/8111d at 0xffffc90010554000, 6c:62:6d:0f:d3:0e, XID 081000c0 IRQ 88
[   10.861927] firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
[   10.863277] firewire_ohci 0000:07:00.0: calling quirk_via_vlink+0x0/0xc0
[   10.863283] firewire_ohci 0000:07:00.0: setting latency timer to 64
[   10.879207] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   10.880598] cdrom: Uniform CD-ROM driver Revision: 3.20
[   10.888356] sr 8:0:0:0: Attached scsi CD-ROM sr0
[   10.906737] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   10.908091] r8169 0000:05:00.0: PCI INT A -> GSI 51 (level, low) -> IRQ 51
[   10.909418] r8169 0000:05:00.0: enabling Mem-Wr-Inval
[   10.909467] r8169 0000:05:00.0: setting latency timer to 64
[   10.909512] r8169 0000:05:00.0: irq 89 for MSI/MSI-X
[   10.911901] r8169 0000:05:00.0: eth1: RTL8168d/8111d at 0xffffc90010514000, 6c:62:6d:0f:d3:0d, XID 081000c0 IRQ 89
[   10.923583] firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x11
[   11.280550] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.340336] hda_codec: ALC889: BIOS auto-probing.
[   11.348332] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[   11.350943] HDA Intel 0000:08:00.1: PCI INT B -> GSI 29 (level, low) -> IRQ 29
[   11.352468] HDA Intel 0000:08:00.1: irq 90 for MSI/MSI-X
[   11.352500] HDA Intel 0000:08:00.1: setting latency timer to 64
[   11.424343] firewire_core: created device fw0: GUID 0010dc0001b245eb, S400
[   11.516450] Adding 8385532k swap on /dev/sda2.  Priority:-1 extents:1 across:8385532k 
[   11.519738] Adding 8385532k swap on /dev/sdb2.  Priority:-2 extents:1 across:8385532k 
[   12.130938] device-mapper: uevent: version 1.0.3
[   12.132957] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[   12.234672] ip used greatest stack depth: 3632 bytes left
[   12.370076] md: md1 stopped.
[   12.372514] md: bind<sdb5>
[   12.374076] md: bind<sda5>
[   12.394828] md/raid1:md1: active with 2 out of 2 mirrors
[   12.414562] created bitmap (300 pages) for device md1
[   12.433045] md1: bitmap initialized from disk: read 19/19 pages, set 35 bits
[   12.469373] md1: detected capacity change from 0 to 644243906560
[   12.485810]  md1: unknown partition table
[   14.277283] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   14.942991] EXT3-fs: barriers not enabled
[   14.953022] kjournald starting.  Commit interval 5 seconds
[   14.953216] EXT3-fs (sdb1): using internal journal
[   14.953305] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[   14.957265] EXT3-fs: barriers not enabled
[   14.963642] kjournald starting.  Commit interval 5 seconds
[   14.963771] EXT3-fs (sda1): using internal journal
[   14.963777] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   16.293807] powernow-k8: Found 1 AMD Phenom(tm) II X6 1090T Processor (6 cpu cores) (version 2.20.00)
[   16.294938] powernow-k8: Core Performance Boosting: on.
[   16.296297] powernow-k8:    0 : pstate 0 (3200 MHz)
[   16.297390] powernow-k8:    1 : pstate 1 (2400 MHz)
[   16.298409] powernow-k8:    2 : pstate 2 (1600 MHz)
[   16.299420] powernow-k8:    3 : pstate 3 (800 MHz)
[   16.799982] r8169 0000:06:00.0: eth0: link up
[   16.800990] r8169 0000:06:00.0: eth0: link up
[   17.346881] NET: Registered protocol family 10
[   17.347777] lo: Disabled Privacy Extensions
[   17.630247] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[   18.128122] RPC: Registered udp transport module.
[   18.128125] RPC: Registered tcp transport module.
[   18.128127] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   18.314644] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   18.547263] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   18.547784] NFSD: starting 90-second grace period
[   18.548852] rpc.nfsd used greatest stack depth: 3600 bytes left
[   27.990089] eth0: no IPv6 routers present
[  218.181523] mv used greatest stack depth: 3328 bytes left
[  229.737833] modpost used greatest stack depth: 3216 bytes left
[  265.040757] xhci_hcd 0000:04:00.0: remove, state 4
[  265.040861] usb usb8: USB disconnect, address 1
[  265.078779] xhci_hcd 0000:04:00.0: Host controller not halted, aborting reset.
[  265.081040] xhci_hcd 0000:04:00.0: USB bus 8 deregistered
[  265.082083] xhci_hcd 0000:04:00.0: PCI INT A disabled
[  271.036383] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[  271.036475] xhci_hcd 0000:04:00.0: enabling bus mastering
[  271.036480] xhci_hcd 0000:04:00.0: setting latency timer to 64
[  271.036483] xhci_hcd 0000:04:00.0: xHCI Host Controller
[  271.036783] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 8
[  271.056848] xhci_hcd 0000:04:00.0: enabling Mem-Wr-Inval
[  271.056865] xhci_hcd 0000:04:00.0: irq 48, io mem 0xfe5fe000
[  271.056922] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[  271.056926] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[  271.056930] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[  271.056934] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[  271.056937] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[  271.056941] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[  271.056944] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[  271.060213] usb usb8: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[  271.060230] usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
[  271.060232] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  271.060234] usb usb8: Product: xHCI Host Controller
[  271.060236] usb usb8: Manufacturer: Linux 2.6.37-rc7+ xhci_hcd
[  271.060237] usb usb8: SerialNumber: 0000:04:00.0
[  271.060501] xHCI xhci_add_endpoint called for root hub
[  271.060504] xHCI xhci_check_bandwidth called for root hub
[  271.060732] hub 8-0:1.0: USB hub found
[  271.060764] hub 8-0:1.0: 4 ports detected
[  315.733611] PM: Marking nosave pages: 000000000009b000 - 0000000000100000
[  315.733615] PM: Marking nosave pages: 00000000c7e90000 - 0000000100000000
[  315.734069] PM: Marking nosave pages: 00000000bc000000 - 00000000c0000000
[  315.734236] PM: Basic memory bitmaps created
[  316.532073] Syncing filesystems ... done.
[  316.537603] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  316.550075] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  316.564792] PM: Preallocating image memory... done (allocated 378014 pages)
[  316.968219] PM: Allocated 1512056 kbytes in 0.40 seconds (3780.14 MB/s)
[  316.968220] Suspending console(s) (use no_console_suspend to debug)
[  316.970186] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  316.970193] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[  316.971650] serial 00:07: disabled
[  316.972327] pata_jmicron 0000:01:00.1: PCI INT B disabled
[  316.972336] ahci 0000:01:00.0: PCI INT A disabled
[  316.976714] ACPI handle has no context!
[  317.073462] HDA Intel 0000:00:14.2: PCI INT A disabled
[  317.073466] HDA Intel 0000:08:00.1: PCI INT B disabled
[  317.073534] ACPI handle has no context!
[  317.086747] PM: freeze of devices complete after 117.227 msecs
[  317.087764] PM: late freeze of devices complete after 1.015 msecs
[  317.088326] ACPI: Preparing to enter system sleep state S4
[  317.100814] PM: Saving platform NVS memory
[  317.103792] Disabling non-boot CPUs ...
[  317.145134] CPU 1 is now offline
[  317.195001] CPU 2 is now offline
[  317.228231] CPU 3 is now offline
[  317.271457] CPU 4 is now offline
[  317.396647] CPU 5 is now offline
[  317.396648] lockdep: fixing up alternatives.
[  317.397242] PM: Creating hibernation image:
[  317.399970] PM: Need to copy 376918 pages
[  317.399970] PM: Normal pages needed: 376918 + 1024, available pages: 649971
[  317.399970] PM: Restoring platform NVS memory
[  317.399970] PCI-DMA: Resuming GART IOMMU
[  317.399970] PCI-DMA: Restoring GART aperture settings
[  317.399970] Enabling non-boot CPUs ...
[  317.403357] lockdep: fixing up alternatives.
[  317.403366] Booting Node 0 Processor 1 APIC 0x1
[  317.557500] CPU1 is up
[  317.557627] lockdep: fixing up alternatives.
[  317.557632] Booting Node 0 Processor 2 APIC 0x2
[  317.710669] CPU2 is up
[  317.710790] lockdep: fixing up alternatives.
[  317.710797] Booting Node 0 Processor 3 APIC 0x3
[  317.864088] CPU3 is up
[  317.864206] lockdep: fixing up alternatives.
[  317.864213] Booting Node 0 Processor 4 APIC 0x4
[  318.017542] CPU4 is up
[  318.017670] lockdep: fixing up alternatives.
[  318.017676] Booting Node 0 Processor 5 APIC 0x5
[  318.170984] CPU5 is up
[  318.173866] ACPI: Waking up from system sleep state S4
[  318.174403] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174438] pcieport 0000:00:03.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174471] pcieport 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174503] pcieport 0000:00:05.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174535] pcieport 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174568] pcieport 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174629] ahci 0000:00:11.0: restoring config space at offset 0x1 (was 0x2300503, writing 0x2300507)
[  318.174653] ahci 0000:00:11.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174676] ohci_hcd 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174711] ehci_hcd 0000:00:12.2: calling quirk_cardbus_legacy+0x0/0x30
[  318.174735] ohci_hcd 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174769] ehci_hcd 0000:00:13.2: calling quirk_cardbus_legacy+0x0/0x30
[  318.174792] pci 0000:00:14.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174801] HDA Intel 0000:00:14.2: restoring config space at offset 0xf (was 0x10b, writing 0xb)
[  318.174819] HDA Intel 0000:00:14.2: restoring config space at offset 0x1 (was 0x4100006, writing 0x4100002)
[  318.174827] HDA Intel 0000:00:14.2: calling quirk_cardbus_legacy+0x0/0x30
[  318.174850] pci 0000:00:14.3: calling quirk_cardbus_legacy+0x0/0x30
[  318.174872] pci 0000:00:14.4: calling quirk_cardbus_legacy+0x0/0x30
[  318.174895] ohci_hcd 0000:00:14.5: calling quirk_cardbus_legacy+0x0/0x30
[  318.174945] pcieport 0000:00:15.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.174995] pcieport 0000:00:15.1: calling quirk_cardbus_legacy+0x0/0x30
[  318.175017] ohci_hcd 0000:00:16.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.175051] ehci_hcd 0000:00:16.2: calling quirk_cardbus_legacy+0x0/0x30
[  318.175066] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.175076] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x30
[  318.175086] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x30
[  318.175099] k10temp 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x30
[  318.175110] pci 0000:00:18.4: calling quirk_cardbus_legacy+0x0/0x30
[  318.175157] radeon 0000:08:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.175186] HDA Intel 0000:08:00.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100103)
[  318.175198] HDA Intel 0000:08:00.1: calling quirk_cardbus_legacy+0x0/0x30
[  318.175244] firewire_ohci 0000:07:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.175285] r8169 0000:06:00.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  318.175317] r8169 0000:06:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.175358] r8169 0000:05:00.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  318.175389] r8169 0000:05:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.175429] xhci_hcd 0000:04:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  318.175454] xhci_hcd 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.175536] ahci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100103, writing 0x100107)
[  318.175552] ahci 0000:01:00.0: calling quirk_jmicron_ata+0x0/0x140
[  318.175565] ahci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  318.175603] pata_jmicron 0000:01:00.1: restoring config space at offset 0x1 (was 0x100001, writing 0x100005)
[  318.175616] pata_jmicron 0000:01:00.1: calling quirk_jmicron_ata+0x0/0x140
[  318.175618] pata_jmicron 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x30
[  318.176080] PM: early restore of devices complete after 1.757 msecs
[  318.784982] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  318.784986] HDA Intel 0000:00:14.2: enabling bus mastering
[  318.785029] ohci_hcd 0000:00:14.5: HC died; cleaning up
[  318.785071] radeon 0000:08:00.0: setting latency timer to 64
[  318.785079] HDA Intel 0000:08:00.1: PCI INT B -> GSI 29 (level, low) -> IRQ 29
[  318.785081] radeon 0000:08:00.0: GPU softreset 
[  318.785084] HDA Intel 0000:08:00.1: enabling bus mastering
[  318.785086] radeon 0000:08:00.0:   GRBM_STATUS=0x00003828
[  318.785089] HDA Intel 0000:08:00.1: setting latency timer to 64
[  318.785091] radeon 0000:08:00.0:   GRBM_STATUS_SE0=0x00000007
[  318.785093] radeon 0000:08:00.0:   GRBM_STATUS_SE1=0x00000007
[  318.785096] radeon 0000:08:00.0:   SRBM_STATUS=0x200000C0
[  318.785119] radeon 0000:08:00.0:   GRBM_SOFT_RESET=0x00007F6B
[  318.785141] HDA Intel 0000:08:00.1: irq 90 for MSI/MSI-X
[  318.785224] radeon 0000:08:00.0:   GRBM_STATUS=0x00003828
[  318.785226] radeon 0000:08:00.0:   GRBM_STATUS_SE0=0x00000007
[  318.785227] radeon 0000:08:00.0:   GRBM_STATUS_SE1=0x00000007
[  318.785229] radeon 0000:08:00.0:   SRBM_STATUS=0x200000C0
[  318.785261] xhci_hcd 0000:04:00.0: setting latency timer to 64
[  318.785279] usb usb8: root hub lost power or was reset
[  318.785292] ahci 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  318.785299] ahci 0000:01:00.0: setting latency timer to 64
[  318.785329] pata_jmicron 0000:01:00.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[  318.785337] pata_jmicron 0000:01:00.1: setting latency timer to 64
[  318.785453] sd 0:0:0:0: [sda] Starting disk
[  318.785639] sd 2:0:0:0: [sdb] Starting disk
[  318.785767] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[  318.785771] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[  318.785791] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[  318.785794] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[  318.785798] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[  318.785801] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[  318.785822] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[  318.787325] serial 00:07: activated
[  318.800511] radeon 0000:08:00.0: WB enabled
[  318.816617] [drm] ring test succeeded in 1 usecs
[  318.816676] [drm] ib test succeeded in 0 usecs
[  318.840686] usb usb4: root hub lost power or was reset
[  318.840767] usb usb5: root hub lost power or was reset
[  318.840777] usb usb6: root hub lost power or was reset
[  318.840780] usb usb2: root hub lost power or was reset
[  318.840783] usb usb3: root hub lost power or was reset
[  318.840833] usb usb7: root hub lost power or was reset
[  318.840865] usb usb1: root hub lost power or was reset
[  318.846899] firewire_core: skipped bus generations, destroying all nodes
[  318.847285] r8169 0000:06:00.0: eth0: link down
[  318.951686] ata9.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[  318.951688] ata9.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[  318.963949] ata9.00: configured for UDMA/33
[  319.103425] ata7: SATA link down (SStatus 0 SControl 300)
[  319.103452] ata6: SATA link down (SStatus 0 SControl 300)
[  319.103471] ata8: SATA link down (SStatus 0 SControl 300)
[  319.103494] ata2: SATA link down (SStatus 0 SControl 300)
[  319.103524] ata5: SATA link down (SStatus 0 SControl 300)
[  319.110095] ata4: SATA link down (SStatus 0 SControl 300)
[  319.256728] usb 3-2: reset full speed USB device using ohci_hcd and address 2
[  319.270051] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  319.276717] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  319.281558] ata1.00: configured for UDMA/133
[  319.281891] 
[  319.281892] =======================================================
[  319.281893] [ INFO: possible circular locking dependency detected ]
[  319.281894] 2.6.37-rc7+ #16
[  319.281895] -------------------------------------------------------
[  319.281896] kworker/1:0/13333 is trying to acquire lock:
[  319.281897]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811271a6>] revalidate_disk+0x56/0x90
[  319.281902] 
[  319.281903] but task is already holding lock:
[  319.281903]  (&ap->scsi_scan_mutex){+.+...}, at: [<ffffffff81360420>] ata_scsi_dev_rescan+0x30/0x120
[  319.281907] 
[  319.281907] which lock already depends on the new lock.
[  319.281907] 
[  319.281908] 
[  319.281908] the existing dependency chain (in reverse order) is:
[  319.281909] 
[  319.281910] -> #3 (&ap->scsi_scan_mutex){+.+...}:
[  319.281911]        [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.281914]        [<ffffffff81492fae>] mutex_lock_nested+0x5e/0x380
[  319.281916]        [<ffffffff81360420>] ata_scsi_dev_rescan+0x30/0x120
[  319.281918]        [<ffffffff81060722>] process_one_work+0x1a2/0x450
[  319.281921]        [<ffffffff81061ee2>] worker_thread+0x162/0x340
[  319.281922]        [<ffffffff810668e6>] kthread+0x96/0xa0
[  319.281924]        [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[  319.281927] 
[  319.281927] -> #2 ((&ap->scsi_rescan_task)){+.+...}:
[  319.281929]        [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.281930]        [<ffffffff8106071c>] process_one_work+0x19c/0x450
[  319.281932]        [<ffffffff81061ee2>] worker_thread+0x162/0x340
[  319.281934]        [<ffffffff810668e6>] kthread+0x96/0xa0
[  319.281935]        [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[  319.281937] 
[  319.281937] -> #1 (events){+.+.+.}:
[  319.281939]        [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.281940]        [<ffffffff81060463>] start_flush_work+0xc3/0x130
[  319.281942]        [<ffffffff810604f0>] flush_work+0x20/0x50
[  319.281944]        [<ffffffff81062a2b>] schedule_on_each_cpu+0xeb/0x130
[  319.281946]        [<ffffffff810c2070>] lru_add_drain_all+0x10/0x20
[  319.281948]        [<ffffffff81120578>] invalidate_bdev+0x28/0x40
[  319.281950]        [<ffffffff8112696a>] __invalidate_device+0x4a/0x60
[  319.281952]        [<ffffffff81126a78>] flush_disk+0x18/0xa0
[  319.281953]        [<ffffffff81126be8>] check_disk_size_change+0x78/0x80
[  319.281955]        [<ffffffff811271b1>] revalidate_disk+0x61/0x90
[  319.281957]        [<ffffffff813ba499>] do_md_run+0x59/0xa0
[  319.281959]        [<ffffffff813bbb78>] md_ioctl+0x928/0x1100
[  319.281961]        [<ffffffff811b87f8>] blkdev_ioctl+0x228/0x700
[  319.281962]        [<ffffffff8112681c>] block_ioctl+0x3c/0x40
[  319.281964]        [<ffffffff81107dc7>] do_vfs_ioctl+0x97/0x580
[  319.281966]        [<ffffffff81108329>] sys_ioctl+0x79/0x90
[  319.281968]        [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[  319.281970] 
[  319.281970] -> #0 (&bdev->bd_mutex){+.+.+.}:
[  319.281972]        [<ffffffff8107af58>] __lock_acquire+0x1698/0x1ca0
[  319.281973]        [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.281975]        [<ffffffff81492fae>] mutex_lock_nested+0x5e/0x380
[  319.281976]        [<ffffffff811271a6>] revalidate_disk+0x56/0x90
[  319.281978]        [<ffffffffa0055c92>] sd_rescan+0x22/0x40 [sd_mod]
[  319.281981]        [<ffffffff81346ed6>] scsi_rescan_device+0xa6/0xd0
[  319.281984]        [<ffffffff813604aa>] ata_scsi_dev_rescan+0xba/0x120
[  319.281985]        [<ffffffff81060722>] process_one_work+0x1a2/0x450
[  319.281987]        [<ffffffff81061ee2>] worker_thread+0x162/0x340
[  319.281989]        [<ffffffff810668e6>] kthread+0x96/0xa0
[  319.281990]        [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[  319.281992] 
[  319.281993] other info that might help us debug this:
[  319.281993] 
[  319.281994] 3 locks held by kworker/1:0/13333:
[  319.281995]  #0:  (events){+.+.+.}, at: [<ffffffff810606c4>] process_one_work+0x144/0x450
[  319.281998]  #1:  ((&ap->scsi_rescan_task)){+.+...}, at: [<ffffffff810606c4>] process_one_work+0x144/0x450
[  319.282000]  #2:  (&ap->scsi_scan_mutex){+.+...}, at: [<ffffffff81360420>] ata_scsi_dev_rescan+0x30/0x120
[  319.282003] 
[  319.282003] stack backtrace:
[  319.282005] Pid: 13333, comm: kworker/1:0 Not tainted 2.6.37-rc7+ #16
[  319.282006] Call Trace:
[  319.282008]  [<ffffffff81078707>] print_circular_bug+0xe7/0xf0
[  319.282010]  [<ffffffff8107af58>] __lock_acquire+0x1698/0x1ca0
[  319.282013]  [<ffffffff81044001>] ? get_parent_ip+0x11/0x50
[  319.282015]  [<ffffffff811271a6>] ? revalidate_disk+0x56/0x90
[  319.282017]  [<ffffffff8107baa7>] lock_acquire+0x57/0x70
[  319.282019]  [<ffffffff811271a6>] ? revalidate_disk+0x56/0x90
[  319.282020]  [<ffffffff810441a5>] ? add_preempt_count+0x95/0xd0
[  319.282022]  [<ffffffff81492fae>] mutex_lock_nested+0x5e/0x380
[  319.282024]  [<ffffffff811271a6>] ? revalidate_disk+0x56/0x90
[  319.282026]  [<ffffffff811c49e7>] ? kobject_put+0x27/0x60
[  319.282028]  [<ffffffff811b9784>] ? disk_get_part+0x14/0xa0
[  319.282030]  [<ffffffff81329b22>] ? put_device+0x12/0x20
[  319.282032]  [<ffffffff811271a6>] revalidate_disk+0x56/0x90
[  319.282035]  [<ffffffffa0055c92>] sd_rescan+0x22/0x40 [sd_mod]
[  319.282037]  [<ffffffff81346ed6>] scsi_rescan_device+0xa6/0xd0
[  319.282038]  [<ffffffff813604aa>] ata_scsi_dev_rescan+0xba/0x120
[  319.282040]  [<ffffffff81060722>] process_one_work+0x1a2/0x450
[  319.282042]  [<ffffffff810606c4>] ? process_one_work+0x144/0x450
[  319.282044]  [<ffffffff813603f0>] ? ata_scsi_dev_rescan+0x0/0x120
[  319.282045]  [<ffffffff81061ee2>] worker_thread+0x162/0x340
[  319.282047]  [<ffffffff81061d80>] ? worker_thread+0x0/0x340
[  319.282049]  [<ffffffff810668e6>] kthread+0x96/0xa0
[  319.282051]  [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[  319.282052]  [<ffffffff810375ab>] ? finish_task_switch+0x7b/0xe0
[  319.282055]  [<ffffffff81495d00>] ? restore_args+0x0/0x30
[  319.282056]  [<ffffffff81066850>] ? kthread+0x0/0xa0
[  319.282058]  [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
[  319.288123] ata3.00: configured for UDMA/133
[  319.346789] firewire_core: rediscovered device fw0
[  319.683384] usb 3-3: reset low speed USB device using ohci_hcd and address 3
[  319.992978] PM: restore of devices complete after 1208.480 msecs
[  320.013372] snapshot_ioctl: ioctl '4004330c' is deprecated and will be removed soon, update your suspend-to-disk utilities
[  320.013385] Restarting tasks ... done.
[  320.131971] PM: Basic memory bitmaps freed
[  322.233760] r8169 0000:06:00.0: eth0: link up
[  404.240630] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[  422.060607] fuse init (API version 7.15)
[  667.249750] PM: Marking nosave pages: 000000000009b000 - 0000000000100000
[  667.249754] PM: Marking nosave pages: 00000000c7e90000 - 0000000100000000
[  667.250286] PM: Marking nosave pages: 00000000bc000000 - 00000000c0000000
[  667.250476] PM: Basic memory bitmaps created
[  668.003201] Syncing filesystems ... done.
[  668.014503] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  668.026649] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  668.041351] PM: Preallocating image memory... done (allocated 567188 pages)
[  669.364382] PM: Allocated 2268752 kbytes in 1.32 seconds (1718.75 MB/s)
[  669.364384] Suspending console(s) (use no_console_suspend to debug)
[  669.365523] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[  669.365598] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  669.366303] serial 00:07: disabled
[  669.366633] ahci 0000:01:00.0: PCI INT A disabled
[  669.366639] pata_jmicron 0000:01:00.1: PCI INT B disabled
[  669.369989] ACPI handle has no context!
[  669.466663] HDA Intel 0000:08:00.1: PCI INT B disabled
[  669.466699] ACPI handle has no context!
[  669.470030] HDA Intel 0000:00:14.2: PCI INT A disabled
[  669.483331] PM: freeze of devices complete after 118.166 msecs
[  669.484169] PM: late freeze of devices complete after 0.836 msecs
[  669.484725] ACPI: Preparing to enter system sleep state S4
[  669.485235] PM: Saving platform NVS memory
[  669.488079] Disabling non-boot CPUs ...
[  669.528087] CPU 1 is now offline
[  669.588030] CPU 2 is now offline
[  669.644641] CPU 3 is now offline
[  669.786623] CPU 4 is now offline
[  669.906608] CPU 5 is now offline
[  669.906610] lockdep: fixing up alternatives.
[  669.907035] PM: Creating hibernation image:
[  669.909937] PM: Need to copy 410466 pages
[  669.909937] PM: Normal pages needed: 410466 + 1024, available pages: 616413
[  669.909937] PM: Restoring platform NVS memory
[  669.909937] PCI-DMA: Resuming GART IOMMU
[  669.909937] PCI-DMA: Restoring GART aperture settings
[  669.909937] Enabling non-boot CPUs ...
[  669.913302] lockdep: fixing up alternatives.
[  669.913307] Booting Node 0 Processor 1 APIC 0x1
[  670.066960] CPU1 is up
[  670.067055] lockdep: fixing up alternatives.
[  670.067059] Booting Node 0 Processor 2 APIC 0x2
[  670.220928] CPU2 is up
[  670.221020] lockdep: fixing up alternatives.
[  670.221026] Booting Node 0 Processor 3 APIC 0x3
[  670.447853] CPU3 is up
[  670.449942] lockdep: fixing up alternatives.
[  670.449948] Booting Node 0 Processor 4 APIC 0x4
[  670.617203] CPU4 is up
[  670.617327] lockdep: fixing up alternatives.
[  670.617333] Booting Node 0 Processor 5 APIC 0x5
[  670.770564] CPU5 is up
[  670.773410] ACPI: Waking up from system sleep state S4
[  670.773733] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.773760] pcieport 0000:00:03.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.773784] pcieport 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.773807] pcieport 0000:00:05.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.773831] pcieport 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.773854] pcieport 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.773911] ahci 0000:00:11.0: restoring config space at offset 0x1 (was 0x2300503, writing 0x2300507)
[  670.773931] ahci 0000:00:11.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.773950] ohci_hcd 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.773980] ehci_hcd 0000:00:12.2: calling quirk_cardbus_legacy+0x0/0x30
[  670.774000] ohci_hcd 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774028] ehci_hcd 0000:00:13.2: calling quirk_cardbus_legacy+0x0/0x30
[  670.774047] pci 0000:00:14.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774055] HDA Intel 0000:00:14.2: restoring config space at offset 0xf (was 0x10b, writing 0xb)
[  670.774070] HDA Intel 0000:00:14.2: restoring config space at offset 0x1 (was 0x4100006, writing 0x4100002)
[  670.774077] HDA Intel 0000:00:14.2: calling quirk_cardbus_legacy+0x0/0x30
[  670.774097] pci 0000:00:14.3: calling quirk_cardbus_legacy+0x0/0x30
[  670.774115] pci 0000:00:14.4: calling quirk_cardbus_legacy+0x0/0x30
[  670.774134] ohci_hcd 0000:00:14.5: calling quirk_cardbus_legacy+0x0/0x30
[  670.774175] pcieport 0000:00:15.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774216] pcieport 0000:00:15.1: calling quirk_cardbus_legacy+0x0/0x30
[  670.774235] ohci_hcd 0000:00:16.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774264] ehci_hcd 0000:00:16.2: calling quirk_cardbus_legacy+0x0/0x30
[  670.774273] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774281] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x30
[  670.774287] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x30
[  670.774296] k10temp 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x30
[  670.774303] pci 0000:00:18.4: calling quirk_cardbus_legacy+0x0/0x30
[  670.774343] radeon 0000:08:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774367] HDA Intel 0000:08:00.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100103)
[  670.774377] HDA Intel 0000:08:00.1: calling quirk_cardbus_legacy+0x0/0x30
[  670.774416] firewire_ohci 0000:07:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774451] r8169 0000:06:00.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  670.774478] r8169 0000:06:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774513] r8169 0000:05:00.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  670.774540] r8169 0000:05:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774574] xhci_hcd 0000:04:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  670.774596] xhci_hcd 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774672] ahci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100103, writing 0x100107)
[  670.774687] ahci 0000:01:00.0: calling quirk_jmicron_ata+0x0/0x140
[  670.774699] ahci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x30
[  670.774733] pata_jmicron 0000:01:00.1: restoring config space at offset 0x1 (was 0x100001, writing 0x100005)
[  670.774745] pata_jmicron 0000:01:00.1: calling quirk_jmicron_ata+0x0/0x140
[  670.774747] pata_jmicron 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x30
[  670.775059] PM: early restore of devices complete after 1.380 msecs
[  671.211652] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  671.211656] HDA Intel 0000:00:14.2: enabling bus mastering
[  671.211762] ohci_hcd 0000:00:16.0: HC died; cleaning up
[  671.211771] radeon 0000:08:00.0: setting latency timer to 64
[  671.211775] radeon 0000:08:00.0: GPU softreset 
[  671.211777] radeon 0000:08:00.0:   GRBM_STATUS=0x00003828
[  671.211780] radeon 0000:08:00.0:   GRBM_STATUS_SE0=0x00000007
[  671.211782] radeon 0000:08:00.0:   GRBM_STATUS_SE1=0x00000007
[  671.211788] HDA Intel 0000:08:00.1: PCI INT B -> GSI 29 (level, low) -> IRQ 29
[  671.211792] radeon 0000:08:00.0:   SRBM_STATUS=0x200000C0
[  671.211794] HDA Intel 0000:08:00.1: enabling bus mastering
[  671.211798] HDA Intel 0000:08:00.1: setting latency timer to 64
[  671.211808] radeon 0000:08:00.0:   GRBM_SOFT_RESET=0x00007F6B
[  671.211836] HDA Intel 0000:08:00.1: irq 90 for MSI/MSI-X
[  671.211862] xhci_hcd 0000:04:00.0: setting latency timer to 64
[  671.211867] usb usb8: root hub lost power or was reset
[  671.211881] ahci 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  671.211887] ahci 0000:01:00.0: setting latency timer to 64
[  671.211908] pata_jmicron 0000:01:00.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[  671.211913] radeon 0000:08:00.0:   GRBM_STATUS=0x00003828
[  671.211914] pata_jmicron 0000:01:00.1: setting latency timer to 64
[  671.211916] radeon 0000:08:00.0:   GRBM_STATUS_SE0=0x00000007
[  671.211919] radeon 0000:08:00.0:   GRBM_STATUS_SE1=0x00000007
[  671.211921] radeon 0000:08:00.0:   SRBM_STATUS=0x200000C0
[  671.211999] sd 0:0:0:0: [sda] Starting disk
[  671.212130] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[  671.212133] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[  671.212136] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[  671.212138] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[  671.212140] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[  671.212142] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[  671.212144] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[  671.213151] serial 00:07: activated
[  671.213911] sd 2:0:0:0: [sdb] Starting disk
[  671.227036] radeon 0000:08:00.0: WB enabled
[  671.243131] [drm] ring test succeeded in 1 usecs
[  671.243148] [drm] ib test succeeded in 0 usecs
[  671.263445] firewire_core: skipped bus generations, destroying all nodes
[  671.267330] usb usb4: root hub lost power or was reset
[  671.267333] usb usb6: root hub lost power or was reset
[  671.267380] usb usb3: root hub lost power or was reset
[  671.267390] usb usb5: root hub lost power or was reset
[  671.267400] usb usb7: root hub lost power or was reset
[  671.267434] usb usb2: root hub lost power or was reset
[  671.267450] usb usb1: root hub lost power or was reset
[  671.273320] r8169 0000:06:00.0: eth0: link down
[  671.378424] ata9.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[  671.378426] ata9.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[  671.390566] ata9.00: configured for UDMA/33
[  671.523378] ata7: SATA link down (SStatus 0 SControl 300)
[  671.523402] ata2: SATA link down (SStatus 0 SControl 300)
[  671.523422] ata8: SATA link down (SStatus 0 SControl 300)
[  671.530017] ata4: SATA link down (SStatus 0 SControl 300)
[  671.530048] ata5: SATA link down (SStatus 0 SControl 300)
[  671.530078] ata6: SATA link down (SStatus 0 SControl 300)
[  671.690014] usb 3-2: reset full speed USB device using ohci_hcd and address 2
[  671.690023] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  671.700027] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  671.701438] ata1.00: configured for UDMA/133
[  671.711443] ata3.00: configured for UDMA/133
[  671.763387] firewire_core: rediscovered device fw0
[  672.116648] usb 3-3: reset low speed USB device using ohci_hcd and address 3
[  672.425682] PM: restore of devices complete after 1214.182 msecs
[  672.445047] snapshot_ioctl: ioctl '4004330c' is deprecated and will be removed soon, update your suspend-to-disk utilities
[  672.445051] Restarting tasks ... done.
[  672.577305] PM: Basic memory bitmaps freed
[  674.296701] r8169 0000:06:00.0: eth0: link up

--Boundary-00=_667FNY7Y1BHthqa--
