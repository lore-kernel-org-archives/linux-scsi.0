From: Jan Kara <jack@suse.cz>
Subject: Re: problem with block: Move bdi_unregister() to del_gendisk()
 commit 165a5e22fafb127ecb5914e12e8c32a1f0d3f820
Date: Wed, 8 Mar 2017 14:20:08 +0100
Message-ID: <20170308132008.GC19740@quack2.suse.cz>
References: <6fdebabe-d399-0fe0-0d5e-fd84cc189101@internode.on.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oTHb8nViIGeoXxdp"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6fdebabe-d399-0fe0-0d5e-fd84cc189101@internode.on.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Jan Kara <jack@suse.cz>, Lekshmi Pillai <lekshmicpillai@in.ibm.com>, Tejun Heo <tj@kernel.org>, Omar Sandoval <osandov@fb.com>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 08-03-17 20:37:54, Arthur Marsh wrote:
> 
> On one of my pc's I have 2 PATA disks (one, WDC below is used for booting,
> the other SAMSUNG is not mounted), plus an IBM SCSI disk using a DPT 2044W
> controller with eata driver and sometimes a Verbatim Storengo USB stick.
> 
> On recent 4.10.0+ kernel builds (i386), the resulting kernel would pause
> during the start-up when the USB stick was inserted but boot normally
> otherwise.
> 
> A git-bisect lead to:
> 
> commit 165a5e22fafb127ecb5914e12e8c32a1f0d3f820
> Author: Jan Kara <jack@suse.cz>
> Date:   Wed Feb 8 08:05:56 2017 +0100
> 
>     block: Move bdi_unregister() to del_gendisk()
> 
>     Commit 6cd18e711dd8 "block: destroy bdi before blockdev is
>     unregistered." moved bdi unregistration (at that time through
>     bdi_destroy()) from blk_release_queue() to blk_cleanup_queue() because
>     it needs to happen before blk_unregister_region() call in del_gendisk()
>     for MD. SCSI though will free up the device number from sd_remove()
>     called through a maze of callbacks from device_del() in
>     __scsi_remove_device() before blk_cleanup_queue() and thus similar races
>     as described in 6cd18e711dd8 can happen for SCSI as well as reported by
>     Omar [1].
> 
>     Moving bdi_unregister() to del_gendisk() works for MD and fixes the
>     problem for SCSI since del_gendisk() gets called from sd_remove() before
>     freeing the device number.
> 
>     This also makes device_add_disk() (calling bdi_register_owner()) more
>     symmetric with del_gendisk().
> 
>     [1] http://marc.info/?l=linux-block&m=148554717109098&w=2

Thanks for report and the analysis! The real culprit seems to be:

 [    4.614530] BUG: unable to handle kernel NULL pointer dereference at 00000258
 [    4.614606] IP: sd_revalidate_disk+0x12/0x1460 [sd_mod]
 [    4.614668] *pdpt = 00000000370de001 *pde = 0000000000000000 
 [    4.614788] Oops: 0000 [#1] PREEMPT SMP
 [    4.614847] Modules linked in: uas sd_mod usb_storage psmouse pata_via ehci_pci uhci_hcd ehci_hcd via_rhine usbcore eata mii i2c_viapro usb_common libata scsi_mod
 [    4.614970] CPU: 0 PID: 127 Comm: kworker/u4:5 Not tainted 4.10.0+ #652
 [    4.615035] Hardware name: System manufacturer System Product Name/A8V-MX, BIOS 0503    12/06/2005
 [    4.615117] Workqueue: events_unbound async_run_entry_fn
 [    4.615180] task: f71b9080 task.stack: f729c000
 [    4.615243] EIP: sd_revalidate_disk+0x12/0x1460 [sd_mod]
 [    4.615305] EFLAGS: 00010296 CPU: 0
 [    4.615363] EAX: f7261000 EBX: 00000000 ECX: 00000000 EDX: f7196000
 [    4.615426] ESI: f7196000 EDI: f7261000 EBP: f729deac ESP: f729de44
 [    4.615489]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 [    4.615552] CR0: 80050033 CR2: 00000258 CR3: 370ce6c0 CR4: 000006f0
 [    4.615615] Call Trace:
 [    4.615675]  ? kobject_uevent+0xa/0x10
 [    4.615736]  ? blk_integrity_add+0x41/0x50
 [    4.615797]  ? device_add_disk+0x275/0x450
 [    4.615861]  sd_probe_async+0x103/0x1b0 [sd_mod]
 [    4.615923]  ? preempt_count_sub+0x26/0x70
 [    4.615984]  async_run_entry_fn+0x30/0x170
 [    4.616045]  ? preempt_count_sub+0x26/0x70
 [    4.616107]  process_one_work+0x235/0x670
 [    4.616167]  ? process_one_work+0x1a3/0x670
 [    4.616229]  worker_thread+0x2f/0x4c0
 [    4.616288]  ? preempt_count_add+0x82/0xc0
 [    4.616349]  ? process_one_work+0x670/0x670
 [    4.616410]  kthread+0xd0/0x100
 [    4.616467]  ? process_one_work+0x670/0x670
 [    4.616528]  ? kthread_create_on_node+0x30/0x30
 [    4.616591]  ret_from_fork+0x21/0x2c
 [    4.616652] Code: 43 02 31 c0 8b 5d f4 c9 c3 8d 75 e4 89 34 24 e8 95 0a fb ff eb d4 8d 76 00 55 89 e5 57 56 53 83 ec 5c 8b 98 0c 03 00 00 89 45 c8 <8b> 93 58 02 00 00 8b 43 04 89 45 d8 8b 82 08 03 00 00 89 45 d0
 [    4.616840] EIP: sd_revalidate_disk+0x12/0x1460 [sd_mod] SS:ESP: 0068:f729de44
 [    4.616914] CR2: 0000000000000258
 [    4.616973] ---[ end trace b1bff84fe33f3677 ]---

in your log. And this apparently happened because disk->private_data was
NULL. Can you try whether attached patches fix the problem for you?

								Honza


> 
> When booting the bad kernel, I would eventually get a prompt to press the
> enter key to boot and it eventually started, but the SCSI disk partitions
> were not found by blkid nor could they be mounted.
> 
> lsscsi reports:
> 
> [0:0:6:0]    disk    IBM      DCAS-34330W      S65A  /dev/sda
> [1:0:0:0]    disk    ATA      WDC WD3200AAJB-0 2C01  /dev/sdc
> [2:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GSA-4163B A103  /dev/sr0
> [2:0:1:0]    disk    ATA      SAMSUNG SP4002H  0-57  /dev/sdd
> [3:0:0:0]    disk    Verbatim STORE N GO       5.00  /dev/sdb
> 
> blkid reports:
> 
> /dev/sdb1: LABEL="STORENGO" UUID="B08B-79DA" TYPE="vfat"
> PARTUUID="961d9655-01"
> /dev/sdc1: UUID="bfdeb6d6-0b77-4beb-a63d-bdc3e455b8ea" TYPE="ext3"
> PTTYPE="dos" PARTUUID="000750bf-01"
> /dev/sdc5: UUID="26b7280a-f40c-49dd-a086-dbbb9b7e3def" TYPE="swap"
> PARTUUID="000750bf-05"
> /dev/sdc6: UUID="7417-5AFF" TYPE="vfat" PARTUUID="000750bf-06"
> /dev/sdc7: UUID="96c96a61-8615-4715-86d0-09cb8c62638c" TYPE="ext3"
> PARTUUID="000750bf-07"
> /dev/sdd1: LABEL="W-98 SE" UUID="3571-16DE" TYPE="vfat"
> PARTUUID="43598af3-01"
> /dev/sdd3: UUID="fd6a052e-c062-4c47-801d-087595635c5d" SEC_TYPE="ext2"
> TYPE="ext3" PARTUUID="43598af3-03"
> /dev/sdd5: UUID="026a3f5c-0064-4ae7-869e-519d2cee05e7" SEC_TYPE="ext2"
> TYPE="ext3" PTTYPE="dos" PARTUUID="43598af3-05"
> /dev/sdd6: UUID="9a0970fa-74ba-4426-98ac-1e8b81933e0e" TYPE="swap"
> PARTUUID="43598af3-06"
> /dev/sdd7: UUID="4912-06CA" TYPE="vfat" PARTUUID="43598af3-07"
> 
> The boot screen is at:
> 
> http://www.users.on.net/~arthur.marsh/20170308_185555.jpg
> 
> and the dmesg output from booting the bad kernel is attached.
> 
> I'm happy to supply any other configuration details needed and run further
> tests.
> 
> Regards,
> 
> Arthur.
> 
> 
> 

> [    0.000000] Linux version 4.10.0+ (root@victoria) (gcc version 6.3.0 20170221 (Debian 6.3.0-8) ) #652 SMP PREEMPT Wed Mar 8 04:45:06 ACDT 2017
> [    0.000000] x86/fpu: x87 FPU will use FXSAVE
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003ffaffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000003ffb0000-0x000000003ffbdfff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000003ffbe000-0x000000003ffdffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000003ffe0000-0x000000003fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff780000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.3 present.
> [    0.000000] DMI: System manufacturer System Product Name/A8V-MX, BIOS 0503    12/06/2005
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x3ffb0 max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0000000000 mask FFC0000000 write-back
> [    0.000000]   1 base 00D0000000 mask FFF0000000 write-combining
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
> [    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [c00ff780]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x025fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] BRK [0x02115000, 0x02115fff] PGTABLE
> [    0.000000] BRK [0x02116000, 0x02116fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x36f9d000-0x377c5fff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000FAC60 000024 (v02 ACPIAM)
> [    0.000000] ACPI: XSDT 0x000000003FFB0100 00003C (v01 A M I  OEMXSDT  12000506 MSFT 00000097)
> [    0.000000] ACPI: FACP 0x000000003FFB0290 0000F4 (v03 A M I  OEMFACP  12000506 MSFT 00000097)
> [    0.000000] ACPI: DSDT 0x000000003FFB03F0 0046F0 (v01 A0347  A0347001 00000001 INTL 02002026)
> [    0.000000] ACPI: FACS 0x000000003FFBE000 000040
> [    0.000000] ACPI: FACS 0x000000003FFBE000 000040
> [    0.000000] ACPI: APIC 0x000000003FFB0390 00005C (v01 A M I  OEMAPIC  12000506 MSFT 00000097)
> [    0.000000] ACPI: OEMB 0x000000003FFBE040 000046 (v01 A M I  AMI_OEM  12000506 MSFT 00000097)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 131MB HIGHMEM available.
> [    0.000000] 891MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 37bfe000
> [    0.000000]   low ram: 0 - 37bfe000
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.000000]   Normal   [mem 0x0000000001000000-0x0000000037bfdfff]
> [    0.000000]   HighMem  [mem 0x0000000037bfe000-0x000000003ffaffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
> [    0.000000]   node   0: [mem 0x0000000000100000-0x000000003ffaffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000003ffaffff]
> [    0.000000] On node 0 totalpages: 261966
> [    0.000000]   DMA zone: 36 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1971 pages used for memmap
> [    0.000000]   Normal zone: 224254 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 33714 pages, LIFO batch:7
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] smpboot: Allowing 2 CPUs, 1 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] e820: [mem 0x40000000-0xdfffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 30582079743023 ns
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] percpu: Embedded 21 pages/cpu @f7bd1000 s57192 r0 d28824 u86016
> [    0.000000] pcpu-alloc: s57192 r0 d28824 u86016 alloc=21*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259959
> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.10.0+ root=UUID=96c96a61-8615-4715-86d0-09cb8c62638c ro
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00037bfe:0003ffb0)
> [    0.000000] Initializing Movable for node 0 (00000000:00000000)
> [    0.000000] Memory: 1011736K/1047864K available (6053K kernel code, 652K rwdata, 2156K rodata, 584K init, 7932K bss, 36128K reserved, 0K cma-reserved, 134856K highmem)
> [    0.000000] virtual kernel memory layout:
>                    fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
>                    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
>                    vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
>                    lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
>                      .init : 0xc18ab000 - 0xc193d000   ( 584 kB)
>                      .data : 0xc15e96a3 - 0xc18a9240   (2814 kB)
>                      .text : 0xc1000000 - 0xc15e96a3   (6053 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] Running RCU self tests
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] 	RCU lockdep checking is enabled.
> [    0.000000] 	Build-time adjustment of leaf fanout to 32.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=32, nr_cpu_ids=2
> [    0.000000] NR_IRQS:2304 nr_irqs:440 16
> [    0.000000] CPU 0 irqstacks, hard=f601c000 soft=f601e000
> [    0.000000] spurious 8259A interrupt: IRQ7.
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.000000] ... CHAINHASH_SIZE:          32768
> [    0.000000]  memory used by lock dependency info: 4911 kB
> [    0.000000]  per task-struct memory footprint: 1344 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]   | Wound/wait tests |
> [    0.000000]   ---------------------
> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
> [    0.000000]                ww contexts mixing:  ok  |  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:  ok  |  ok  |  ok  |
> [    0.000000]                               try:  ok  |  ok  |  ok  |
> [    0.000000]                             block:  ok  |  ok  |  ok  |
> [    0.000000]                          spinlock:  ok  |  ok  |  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 253 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.004000] tsc: Fast TSC calibration using PIT
> [    0.008000] tsc: Detected 2000.053 MHz processor
> [    0.008000] tsc: Marking TSC unstable due to TSCs unsynchronized
> [    0.008000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.10 BogoMIPS (lpj=8000212)
> [    0.008000] pid_max: default: 32768 minimum: 301
> [    0.008000] ACPI: Core revision 20170119
> [    0.018632] ACPI: 1 ACPI AML tables successfully acquired and loaded
> [    0.018791] Security Framework initialized
> [    0.018860] Yama: becoming mindful.
> [    0.018941] AppArmor: AppArmor disabled by boot time parameter
> [    0.019053] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.019129] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.019833] mce: CPU supports 5 MCE banks
> [    0.019917] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
> [    0.019988] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4, 1GB 0
> [    0.026369] smpboot: Max logical packages: 2
> [    0.026444] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.026954] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
> [    0.068000] smpboot: CPU0: AMD Athlon(tm) 64 Processor 3200+ (family: 0xf, model: 0x2f, stepping: 0x2)
> [    0.076017] Performance Events: AMD PMU driver.
> [    0.076094] ... version:                0
> [    0.076160] ... bit width:              48
> [    0.076225] ... generic registers:      4
> [    0.076291] ... value mask:             0000ffffffffffff
> [    0.076361] ... max period:             00007fffffffffff
> [    0.076430] ... fixed-purpose events:   0
> [    0.076496] ... event mask:             000000000000000f
> [    0.104118] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.112011] smp: Bringing up secondary CPUs ...
> [    0.112080] smp: Brought up 1 node, 1 CPU
> [    0.112147] smpboot: Total of 1 processors activated (4000.10 BogoMIPS)
> [    0.113050] devtmpfs: initialized
> [    0.116052] PM: Registering ACPI NVS region [mem 0x3ffbe000-0x3ffdffff] (139264 bytes)
> [    0.120090] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.120190] futex hash table entries: 512 (order: 3, 32768 bytes)
> [    0.120465] pinctrl core: initialized pinctrl subsystem
> [    0.121038] NET: Registered protocol family 16
> [    0.121754] cpuidle: using governor ladder
> [    0.121858] cpuidle: using governor menu
> [    0.121928] node 0 link 0: io port [1000, ffffff]
> [    0.121933] TOM: 0000000040000000 aka 1024M
> [    0.122002] node 0 link 0: mmio [a0000, bffff]
> [    0.122008] node 0 link 0: mmio [40000000, ffffffff]
> [    0.122014] bus: [bus 00-ff] on node 0 link 0
> [    0.122017] bus: 00 [io  0x0000-0xffff]
> [    0.122020] bus: 00 [mem 0x000a0000-0x000bffff]
> [    0.122023] bus: 00 [mem 0x40000000-0xfcffffffff]
> [    0.122070] ACPI: bus type PCI registered
> [    0.123684] PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.
> [    0.123840] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
> [    0.123912] PCI: Using configuration type 1 for base access
> [    0.128164] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.144124] ACPI: Added _OSI(Module Device)
> [    0.144193] ACPI: Added _OSI(Processor Device)
> [    0.144261] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.144329] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.144675] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.154891] ACPI: Interpreter enabled
> [    0.155016] ACPI: (supports S0 S1 S4 S5)
> [    0.155082] ACPI: Using IOAPIC for interrupt routing
> [    0.155229] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.179754] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.179844] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
> [    0.179948] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.180033] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> [    0.180771] PCI host bridge to bus 0000:00
> [    0.180840] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
> [    0.180916] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> [    0.180992] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
> [    0.181080] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
> [    0.181169] pci_bus 0000:00: root bus resource [mem 0x40000000-0xffffffff window]
> [    0.181258] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.181376] pci 0000:00:00.0: [1106:0204] type 00 class 0x060000
> [    0.181392] pci 0000:00:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff pref]
> [    0.181839] pci 0000:00:00.1: [1106:1204] type 00 class 0x060000
> [    0.182212] pci 0000:00:00.2: [1106:2204] type 00 class 0x060000
> [    0.182571] pci 0000:00:00.3: [1106:3204] type 00 class 0x060000
> [    0.182930] pci 0000:00:00.4: [1106:4204] type 00 class 0x060000
> [    0.183291] pci 0000:00:00.7: [1106:7204] type 00 class 0x060000
> [    0.183652] pci 0000:00:01.0: [1106:b188] type 01 class 0x060400
> [    0.183730] pci 0000:00:01.0: supports D1
> [    0.184086] pci 0000:00:0f.0: [1106:0571] type 00 class 0x01018a
> [    0.184149] pci 0000:00:0f.0: reg 0x20: [io  0xfc00-0xfc0f]
> [    0.184178] pci 0000:00:0f.0: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    0.184255] pci 0000:00:0f.0: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    0.184330] pci 0000:00:0f.0: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    0.184407] pci 0000:00:0f.0: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    0.184782] pci 0000:00:10.0: [1106:3038] type 00 class 0x0c0300
> [    0.184844] pci 0000:00:10.0: reg 0x20: [io  0xec00-0xec1f]
> [    0.184912] pci 0000:00:10.0: supports D1 D2
> [    0.184916] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.185148] pci 0000:00:10.0: System wakeup disabled by ACPI
> [    0.185339] pci 0000:00:10.1: [1106:3038] type 00 class 0x0c0300
> [    0.185401] pci 0000:00:10.1: reg 0x20: [io  0xe880-0xe89f]
> [    0.185469] pci 0000:00:10.1: supports D1 D2
> [    0.185472] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.185687] pci 0000:00:10.1: System wakeup disabled by ACPI
> [    0.185878] pci 0000:00:10.2: [1106:3038] type 00 class 0x0c0300
> [    0.185940] pci 0000:00:10.2: reg 0x20: [io  0xe800-0xe81f]
> [    0.186008] pci 0000:00:10.2: supports D1 D2
> [    0.186011] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.186226] pci 0000:00:10.2: System wakeup disabled by ACPI
> [    0.186416] pci 0000:00:10.3: [1106:3038] type 00 class 0x0c0300
> [    0.186478] pci 0000:00:10.3: reg 0x20: [io  0xe480-0xe49f]
> [    0.186545] pci 0000:00:10.3: supports D1 D2
> [    0.186549] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.186764] pci 0000:00:10.3: System wakeup disabled by ACPI
> [    0.186958] pci 0000:00:10.4: [1106:3104] type 00 class 0x0c0320
> [    0.186982] pci 0000:00:10.4: reg 0x10: [mem 0xff6ffc00-0xff6ffcff]
> [    0.187098] pci 0000:00:10.4: supports D1 D2
> [    0.187101] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.187319] pci 0000:00:10.4: System wakeup disabled by ACPI
> [    0.187516] pci 0000:00:11.0: [1106:3287] type 00 class 0x060100
> [    0.187947] pci 0000:00:11.5: [1106:3059] type 00 class 0x040100
> [    0.187970] pci 0000:00:11.5: reg 0x10: [io  0xe000-0xe0ff]
> [    0.188092] pci 0000:00:11.5: supports D1 D2
> [    0.188391] pci 0000:00:11.7: [1106:287e] type 00 class 0x060000
> [    0.188763] pci 0000:00:12.0: [1106:3065] type 00 class 0x020000
> [    0.188785] pci 0000:00:12.0: reg 0x10: [io  0xd800-0xd8ff]
> [    0.188800] pci 0000:00:12.0: reg 0x14: [mem 0xff6ff800-0xff6ff8ff]
> [    0.188899] pci 0000:00:12.0: supports D1 D2
> [    0.188902] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.189117] pci 0000:00:12.0: System wakeup disabled by ACPI
> [    0.189305] pci 0000:00:13.0: [1106:287b] type 01 class 0x060400
> [    0.189640] pci 0000:00:13.1: [1106:287a] type 01 class 0x060400
> [    0.189900] pci 0000:00:13.1: System wakeup disabled by ACPI
> [    0.190107] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
> [    0.190429] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
> [    0.190738] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
> [    0.191045] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
> [    0.191458] pci 0000:01:00.0: [1002:4153] type 00 class 0x030000
> [    0.191478] pci 0000:01:00.0: reg 0x10: [mem 0xa0000000-0xafffffff pref]
> [    0.191490] pci 0000:01:00.0: reg 0x14: [io  0xb000-0xb0ff]
> [    0.191502] pci 0000:01:00.0: reg 0x18: [mem 0xff4f0000-0xff4fffff]
> [    0.191537] pci 0000:01:00.0: reg 0x30: [mem 0xff4c0000-0xff4dffff pref]
> [    0.191591] pci 0000:01:00.0: supports D1 D2
> [    0.191712] pci 0000:01:00.1: [1002:4173] type 00 class 0x038000
> [    0.191730] pci 0000:01:00.1: reg 0x10: [mem 0x90000000-0x9fffffff pref]
> [    0.191742] pci 0000:01:00.1: reg 0x14: [mem 0xff4e0000-0xff4effff]
> [    0.191829] pci 0000:01:00.1: supports D1 D2
> [    0.191985] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.192011] pci 0000:00:01.0:   bridge window [io  0x9000-0xbfff]
> [    0.192017] pci 0000:00:01.0:   bridge window [mem 0xff400000-0xff4fffff]
> [    0.192023] pci 0000:00:01.0:   bridge window [mem 0x7ff00000-0xbfefffff pref]
> [    0.192149] pci 0000:02:00.0: [1106:287c] type 01 class 0x060400
> [    0.192241] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> [    0.192311] pci 0000:02:00.0: System wakeup disabled by ACPI
> [    0.192506] pci 0000:02:00.1: [1106:287d] type 01 class 0x060400
> [    0.192597] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
> [    0.192766] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.192922] pci 0000:00:13.0: PCI bridge to [bus 02-04]
> [    0.193094] pci 0000:02:00.0: PCI bridge to [bus 03]
> [    0.193265] pci 0000:02:00.1: PCI bridge to [bus 04]
> [    0.193465] pci 0000:05:0c.0: [1044:a400] type 00 class 0x010000
> [    0.193485] pci 0000:05:0c.0: reg 0x10: [io  0xcc00-0xcc1f]
> [    0.193551] pci 0000:05:0c.0: reg 0x30: [mem 0xff5f0000-0xff5f7fff pref]
> [    0.193709] pci 0000:00:13.1: PCI bridge to [bus 05]
> [    0.193782] pci 0000:00:13.1:   bridge window [io  0xc000-0xcfff]
> [    0.193788] pci 0000:00:13.1:   bridge window [mem 0xff500000-0xff5fffff]
> [    0.193813] pci_bus 0000:00: on NUMA node 0
> [    0.196180] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.196468] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.196740] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.197011] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.197287] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.197577] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.197871] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.198164] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.198878] pci 0000:01:00.0: vgaarb: setting as boot VGA device
> [    0.198957] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
> [    0.199052] pci 0000:01:00.0: vgaarb: bridge control possible
> [    0.199123] vgaarb: loaded
> [    0.200040] PCI: Using ACPI for IRQ routing
> [    0.200111] PCI: pci_cache_line_size set to 64 bytes
> [    0.200217] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.200224] e820: reserve RAM buffer [mem 0x3ffb0000-0x3fffffff]
> [    0.204184] clocksource: Switched to clocksource refined-jiffies
> [    0.205718] VFS: Disk quotas dquot_6.6.0
> [    0.205827] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.206240] pnp: PnP ACPI init
> [    0.206542] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.207823] pnp 00:01: [dma 3]
> [    0.207823] pnp 00:01: Plug and Play ACPI device, IDs PNP0401 (active)
> [    0.207823] system 00:02: [io  0x0290-0x0297] has been reserved
> [    0.207823] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.207823] system 00:03: [io  0x03e0-0x03e7] has been reserved
> [    0.207823] system 00:03: [io  0x04d0-0x04d1] has been reserved
> [    0.207823] system 00:03: [io  0x0800-0x087f] has been reserved
> [    0.207823] system 00:03: [io  0x0400-0x041f] has been reserved
> [    0.207823] system 00:03: [mem 0xff780000-0xffffffff] has been reserved
> [    0.207823] system 00:03: [mem 0xf0000000-0xf7ffffff] has been reserved
> [    0.207823] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.207823] system 00:04: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    0.207823] system 00:04: [mem 0xfee00000-0xfee00fff] has been reserved
> [    0.207823] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.207823] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
> [    0.207823] pnp 00:06: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
> [    0.207823] pnp 00:07: [dma 0 disabled]
> [    0.207823] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.207823] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.207823] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.207905] system 00:09: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.207983] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
> [    0.208060] system 00:09: [mem 0x00100000-0x3fffffff] could not be reserved
> [    0.208060] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.208060] pnp: PnP ACPI: found 10 devices
> [    0.208113] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> [    0.208113] clocksource: Switched to clocksource acpi_pm
> [    0.208113] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.208113] pci 0000:00:01.0:   bridge window [io  0x9000-0xbfff]
> [    0.208113] pci 0000:00:01.0:   bridge window [mem 0xff400000-0xff4fffff]
> [    0.208113] pci 0000:00:01.0:   bridge window [mem 0x7ff00000-0xbfefffff pref]
> [    0.208113] pci 0000:02:00.0: PCI bridge to [bus 03]
> [    0.208113] pci 0000:02:00.1: PCI bridge to [bus 04]
> [    0.208113] pci 0000:00:13.0: PCI bridge to [bus 02-04]
> [    0.208113] pci 0000:00:13.1: PCI bridge to [bus 05]
> [    0.208113] pci 0000:00:13.1:   bridge window [io  0xc000-0xcfff]
> [    0.208113] pci 0000:00:13.1:   bridge window [mem 0xff500000-0xff5fffff]
> [    0.208113] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> [    0.208113] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> [    0.208113] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
> [    0.208113] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff window]
> [    0.208113] pci_bus 0000:00: resource 8 [mem 0x40000000-0xffffffff window]
> [    0.208113] pci_bus 0000:01: resource 0 [io  0x9000-0xbfff]
> [    0.208113] pci_bus 0000:01: resource 1 [mem 0xff400000-0xff4fffff]
> [    0.208113] pci_bus 0000:01: resource 2 [mem 0x7ff00000-0xbfefffff pref]
> [    0.208113] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
> [    0.208113] pci_bus 0000:05: resource 1 [mem 0xff500000-0xff5fffff]
> [    0.208113] NET: Registered protocol family 2
> [    0.208280] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
> [    0.208280] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
> [    0.208280] TCP: Hash tables configured (established 8192 bind 8192)
> [    0.208280] UDP hash table entries: 512 (order: 3, 40960 bytes)
> [    0.208315] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
> [    0.208661] NET: Registered protocol family 1
> [    0.208748] pci 0000:00:00.0: MSI quirk detected; MSI disabled
> [    0.208845] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
> [    0.210956] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
> [    0.210956] PCI: CLS 64 bytes, default 64
> [    0.210956] Unpacking initramfs...
> [    0.493085] Freeing initrd memory: 8356K
> [    0.493290] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1cd4603885c, max_idle_ns: 440795251062 ns
> [    0.494245] audit: initializing netlink subsys (disabled)
> [    0.495028] audit: type=2000 audit(1488960908.488:1): state=initialized audit_enabled=0 res=1
> [    0.499328] workingset: timestamp_bits=14 max_order=18 bucket_order=4
> [    0.505605] bounce: pool size: 64 pages
> [    0.505695] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    0.509925] io scheduler noop registered
> [    0.509991] io scheduler deadline registered
> [    0.510087] io scheduler cfq registered (default)
> [    0.510156] io scheduler mq-deadline registered
> [    0.511145] GHES: HEST is not enabled!
> [    0.511408] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.532086] 00:07: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    0.533348] Linux agpgart interface v0.103
> [    0.533444] agpgart-amd64 0000:00:00.0: AGP bridge [1106/0204]
> [    0.540620] agpgart-amd64 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [    0.541222] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> [    0.541878] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.542139] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.542600] mousedev: PS/2 mouse device common for all mice
> [    0.542886] rtc_cmos 00:00: RTC can wake from S4
> [    0.543285] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
> [    0.543396] rtc_cmos 00:00: alarms up to one year, y3k, 114 bytes nvram
> [    0.543758] NET: Registered protocol family 10
> [    0.548553] Segment Routing with IPv6
> [    0.548645] mip6: Mobile IPv6
> [    0.548723] NET: Registered protocol family 17
> [    0.548795] mpls_gso: MPLS GSO support
> [    0.549181] microcode: AMD CPU family 0xf not supported
> [    0.549255] Using IPI No-Shortcut mode
> [    0.549767] registered taskstats version 1
> [    0.554773] rtc_cmos 00:00: setting system clock to 2017-03-08 08:15:09 UTC (1488960909)
> [    0.554978] PM: Hibernation image not present or could not be loaded.
> [    0.555763] Freeing unused kernel memory: 584K
> [    0.556129] Write protecting the kernel text: 6056k
> [    0.556216] Write protecting the kernel read-only data: 2160k
> [    0.556288] NX-protecting the kernel data: 4184k
> [    0.565308] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    0.730947] random: udevadm: uninitialized urandom read (16 bytes read)
> [    0.733618] random: systemd-udevd: uninitialized urandom read (16 bytes read)
> [    0.733988] random: systemd-udevd: uninitialized urandom read (16 bytes read)
> [    0.734094] random: systemd-udevd: uninitialized urandom read (16 bytes read)
> [    0.735754] random: udevadm: uninitialized urandom read (16 bytes read)
> [    0.738531] random: udevadm: uninitialized urandom read (16 bytes read)
> [    0.738895] random: udevadm: uninitialized urandom read (16 bytes read)
> [    0.740565] random: udevadm: uninitialized urandom read (16 bytes read)
> [    0.740898] random: udevadm: uninitialized urandom read (16 bytes read)
> [    0.741213] random: udevadm: uninitialized urandom read (16 bytes read)
> [    0.877948] SCSI subsystem initialized
> [    0.894416] ACPI: bus type USB registered
> [    0.894638] usbcore: registered new interface driver usbfs
> [    0.894760] usbcore: registered new interface driver hub
> [    0.901074] via_rhine: v1.10-LK1.5.1 2010-10-09 Written by Donald Becker
> [    0.902139] via-rhine 0000:00:12.0 eth0: VIA Rhine II at 0x1d800, 00:13:d4:cc:9b:57, IRQ 23
> [    0.903001] via-rhine 0000:00:12.0 eth0: MII PHY found at address 1, status 0x786d advertising 01e1 Link 45e1
> [    0.904654] EATA0: IRQ 10 mapped to IO-APIC IRQ 17.
> [    0.904874] usbcore: registered new device driver usb
> [    0.905983] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.906600] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.908186] ehci-pci: EHCI PCI platform driver
> [    0.909297] uhci_hcd 0000:00:10.0: UHCI Host Controller
> [    0.909463] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
> [    0.909582] uhci_hcd 0000:00:10.0: detected 2 ports
> [    0.909707] uhci_hcd 0000:00:10.0: irq 20, io base 0x0000ec00
> [    0.911006] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
> [    0.911084] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n, ip:n, ep:n, pp:y.
> [    0.911172] EATA0: 2.0C, PCI 0xcc10, IRQ 17, BMST, SG 122, MB 64.
> [    0.911244] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
> [    0.911317] EATA0: SCSI channel 0 enabled, host target ID 7.
> [    0.911396] scsi host0: EATA/DMA 2.0x rev. 8.10.00 
> [    0.913517] libata version 3.00 loaded.
> [    0.914284] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.914374] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.914462] usb usb1: Product: UHCI Host Controller
> [    0.914532] usb usb1: Manufacturer: Linux 4.10.0+ uhci_hcd
> [    0.914603] usb usb1: SerialNumber: 0000:00:10.0
> [    0.918818] hub 1-0:1.0: USB hub found
> [    0.920567] hub 1-0:1.0: 2 ports detected
> [    0.928835] ehci-pci 0000:00:10.4: EHCI Host Controller
> [    0.928940] ehci-pci 0000:00:10.4: new USB bus registered, assigned bus number 2
> [    0.929051] ehci-pci 0000:00:10.4: debug port 1
> [    0.929212] ehci-pci 0000:00:10.4: irq 22, io mem 0xff6ffc00
> [    0.944067] ehci-pci 0000:00:10.4: USB 2.0 started, EHCI 1.00
> [    0.944440] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.944522] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.944610] usb usb2: Product: EHCI Host Controller
> [    0.944680] usb usb2: Manufacturer: Linux 4.10.0+ ehci_hcd
> [    0.944752] usb usb2: SerialNumber: 0000:00:10.4
> [    0.945460] hub 2-0:1.0: USB hub found
> [    0.945594] hub 2-0:1.0: 8 ports detected
> [    0.972361] hub 1-0:1.0: USB hub found
> [    0.972516] hub 1-0:1.0: 2 ports detected
> [    0.973309] pata_via 0000:00:0f.0: version 0.3.4
> [    0.980527] scsi host1: pata_via
> [    0.986970] scsi host2: pata_via
> [    0.987231] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
> [    0.987308] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
> [    0.988316] uhci_hcd 0000:00:10.1: UHCI Host Controller
> [    0.988402] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
> [    0.988500] uhci_hcd 0000:00:10.1: detected 2 ports
> [    0.988593] uhci_hcd 0000:00:10.1: irq 22, io base 0x0000e880
> [    0.988873] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.988950] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.989038] usb usb3: Product: UHCI Host Controller
> [    0.989108] usb usb3: Manufacturer: Linux 4.10.0+ uhci_hcd
> [    0.989180] usb usb3: SerialNumber: 0000:00:10.1
> [    0.989704] hub 3-0:1.0: USB hub found
> [    0.989799] hub 3-0:1.0: 2 ports detected
> [    0.990603] uhci_hcd 0000:00:10.2: UHCI Host Controller
> [    0.990683] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
> [    0.990779] uhci_hcd 0000:00:10.2: detected 2 ports
> [    0.990885] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e800
> [    0.991141] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.991219] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.991307] usb usb4: Product: UHCI Host Controller
> [    0.991377] usb usb4: Manufacturer: Linux 4.10.0+ uhci_hcd
> [    0.991448] usb usb4: SerialNumber: 0000:00:10.2
> [    0.994413] hub 4-0:1.0: USB hub found
> [    0.996095] hub 4-0:1.0: 2 ports detected
> [    0.999410] uhci_hcd 0000:00:10.3: UHCI Host Controller
> [    0.999499] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
> [    0.999597] uhci_hcd 0000:00:10.3: detected 2 ports
> [    0.999708] uhci_hcd 0000:00:10.3: irq 23, io base 0x0000e480
> [    1.002450] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.002531] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.002618] usb usb5: Product: UHCI Host Controller
> [    1.002688] usb usb5: Manufacturer: Linux 4.10.0+ uhci_hcd
> [    1.002759] usb usb5: SerialNumber: 0000:00:10.3
> [    1.006177] hub 5-0:1.0: USB hub found
> [    1.006284] hub 5-0:1.0: 2 ports detected
> [    1.163570] ata1.00: ATA-8: WDC WD3200AAJB-00WGA0, 00.02C01, max UDMA/100
> [    1.163661] ata1.00: 625142448 sectors, multi 16: LBA48 
> [    1.166475] ata1.00: configured for UDMA/100
> [    1.272067] usb 2-5: new high-speed USB device number 2 using ehci-pci
> [    1.430262] usb 2-5: New USB device found, idVendor=13fe, idProduct=1e23
> [    1.430348] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    1.430425] usb 2-5: Product: STORE N GO
> [    1.430493] usb 2-5: Manufacturer: Verbatim
> [    1.430561] usb 2-5: SerialNumber: 078A18B40293
> [    1.440905] usb-storage 2-5:1.0: USB Mass Storage device detected
> [    1.445284] scsi host3: usb-storage 2-5:1.0
> [    1.446277] usbcore: registered new interface driver usb-storage
> [    1.452668] usbcore: registered new interface driver uas
> [    1.967295] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input2
> [    2.474346] scsi 3:0:0:0: Direct-Access     Verbatim STORE N GO       5.00 PQ: 0 ANSI: 0 CCS
> [    2.482188] scsi 0:0:6:0: Direct-Access     IBM      DCAS-34330W      S65A PQ: 0 ANSI: 2
> [    2.482280] scsi 0:0:6:0: cmds/lun 16, sorted, simple tags.
> [    2.494928] random: fast init done
> [    4.068313] floppy0: no floppy controllers found
> [    4.068402] work still pending
> [    4.557081] sd 3:0:0:0: [sdb] 3911680 512-byte logical blocks: (2.00 GB/1.87 GiB)
> [    4.557477] sd 0:0:6:0: [sda] 8466688 512-byte logical blocks: (4.33 GB/4.04 GiB)
> [    4.557819] sd 3:0:0:0: [sdb] Write Protect is off
> [    4.557888] sd 3:0:0:0: [sdb] Mode Sense: 23 00 00 00
> [    4.558579] sd 3:0:0:0: [sdb] No Caching mode page found
> [    4.558653] sd 3:0:0:0: [sdb] Assuming drive cache: write through
> [    4.562503] scsi 1:0:0:0: Direct-Access     ATA      WDC WD3200AAJB-0 2C01 PQ: 0 ANSI: 5
> [    4.567628]  sdb: sdb1
> [    4.571083] sd 3:0:0:0: [sdb] Attached SCSI removable disk
> [    4.581040] sd 1:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 GB/298 GiB)
> [    4.581177] sd 1:0:0:0: [sdc] Write Protect is off
> [    4.581248] sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    4.581329] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.590459] sd 0:0:6:0: [sda] Write Protect is off
> [    4.590547] sd 0:0:6:0: [sda] Mode Sense: b3 00 00 08
> [    4.611330] sd 0:0:6:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.614530] BUG: unable to handle kernel NULL pointer dereference at 00000258
> [    4.614606] IP: sd_revalidate_disk+0x12/0x1460 [sd_mod]
> [    4.614668] *pdpt = 00000000370de001 *pde = 0000000000000000 
> 
> [    4.614788] Oops: 0000 [#1] PREEMPT SMP
> [    4.614847] Modules linked in: uas sd_mod usb_storage psmouse pata_via ehci_pci uhci_hcd ehci_hcd via_rhine usbcore eata mii i2c_viapro usb_common libata scsi_mod
> [    4.614970] CPU: 0 PID: 127 Comm: kworker/u4:5 Not tainted 4.10.0+ #652
> [    4.615035] Hardware name: System manufacturer System Product Name/A8V-MX, BIOS 0503    12/06/2005
> [    4.615117] Workqueue: events_unbound async_run_entry_fn
> [    4.615180] task: f71b9080 task.stack: f729c000
> [    4.615243] EIP: sd_revalidate_disk+0x12/0x1460 [sd_mod]
> [    4.615305] EFLAGS: 00010296 CPU: 0
> [    4.615363] EAX: f7261000 EBX: 00000000 ECX: 00000000 EDX: f7196000
> [    4.615426] ESI: f7196000 EDI: f7261000 EBP: f729deac ESP: f729de44
> [    4.615489]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    4.615552] CR0: 80050033 CR2: 00000258 CR3: 370ce6c0 CR4: 000006f0
> [    4.615615] Call Trace:
> [    4.615675]  ? kobject_uevent+0xa/0x10
> [    4.615736]  ? blk_integrity_add+0x41/0x50
> [    4.615797]  ? device_add_disk+0x275/0x450
> [    4.615861]  sd_probe_async+0x103/0x1b0 [sd_mod]
> [    4.615923]  ? preempt_count_sub+0x26/0x70
> [    4.615984]  async_run_entry_fn+0x30/0x170
> [    4.616045]  ? preempt_count_sub+0x26/0x70
> [    4.616107]  process_one_work+0x235/0x670
> [    4.616167]  ? process_one_work+0x1a3/0x670
> [    4.616229]  worker_thread+0x2f/0x4c0
> [    4.616288]  ? preempt_count_add+0x82/0xc0
> [    4.616349]  ? process_one_work+0x670/0x670
> [    4.616410]  kthread+0xd0/0x100
> [    4.616467]  ? process_one_work+0x670/0x670
> [    4.616528]  ? kthread_create_on_node+0x30/0x30
> [    4.616591]  ret_from_fork+0x21/0x2c
> [    4.616652] Code: 43 02 31 c0 8b 5d f4 c9 c3 8d 75 e4 89 34 24 e8 95 0a fb ff eb d4 8d 76 00 55 89 e5 57 56 53 83 ec 5c 8b 98 0c 03 00 00 89 45 c8 <8b> 93 58 02 00 00 8b 43 04 89 45 d8 8b 82 08 03 00 00 89 45 d0
> [    4.616840] EIP: sd_revalidate_disk+0x12/0x1460 [sd_mod] SS:ESP: 0068:f729de44
> [    4.616914] CR2: 0000000000000258
> [    4.616973] ---[ end trace b1bff84fe33f3677 ]---
> [    4.629008]  sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 >
> [    4.629967] sd 1:0:0:0: [sdc] Attached SCSI disk
> [    4.764354] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-4163B, A103, max UDMA/33
> [    4.764718] ata2.01: HPA detected: current 66055248, native 78242976
> [    4.764782] ata2.01: ATA-6: SAMSUNG SP4002H, QU100-57, max UDMA/100
> [    4.764846] ata2.01: 66055248 sectors, multi 16: LBA 
> [    4.764912] ata2.01: limited to UDMA/33 due to 40-wire cable
> [    4.788219] ata2.00: configured for UDMA/33
> [    4.793151] ata2.01: configured for UDMA/33
> [    4.813358] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B A103 PQ: 0 ANSI: 5
> [    4.830589] scsi 2:0:1:0: Direct-Access     ATA      SAMSUNG SP4002H  0-57 PQ: 0 ANSI: 5
> [    4.852690] sd 2:0:1:0: [sdd] 66055248 512-byte logical blocks: (33.8 GB/31.5 GiB)
> [    4.852791] sd 2:0:1:0: [sdd] Write Protect is off
> [    4.852853] sd 2:0:1:0: [sdd] Mode Sense: 00 3a 00 00
> [    4.852956] sd 2:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    4.884776]  sdd: sdd1 sdd2 < sdd5 sdd6 sdd7 > sdd3
> [    4.884999] sdd: p3 size 13333950 extends beyond EOD, enabling native capacity
> [    4.885118] ata2: soft resetting link
> [    5.049657] ata2.01: n_sectors mismatch 66055248 != 78242976
> [    5.049719] ata2.01: new n_sectors matches native, probably late HPA unlock, n_sectors updated
> [    5.092214] ata2.00: configured for UDMA/33
> [    5.097111] ata2.01: configured for UDMA/33
> [    5.099313] ata2: EH complete
> [    5.109935] sd 2:0:1:0: [sdd] 78242976 512-byte logical blocks: (40.1 GB/37.3 GiB)
> [    5.110103] sdd: detected capacity change from 33820286976 to 40060403712
> [    5.160249]  sdd: sdd1 sdd2 < sdd5 sdd6 sdd7 > sdd3
> [    5.174036] sd 2:0:1:0: [sdd] Attached SCSI disk
> [    5.196260] sdd: detected capacity change from 0 to 40060403712
> [  687.847544] random: crng init done
> [  689.010603] EXT4-fs (sdc7): mounting ext3 file system using the ext4 subsystem
> [  689.050499] EXT4-fs (sdc7): mounted filesystem with ordered data mode. Opts: (null)
> [  724.075034] parport_pc 00:01: reported by Plug and Play ACPI
> [  724.075219] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
> [  724.361403] sd 0:0:6:0: Attached scsi generic sg0 type 0
> [  724.361543] sd 3:0:0:0: Attached scsi generic sg1 type 0
> [  724.361674] sd 1:0:0:0: Attached scsi generic sg2 type 0
> [  724.361804] scsi 2:0:0:0: Attached scsi generic sg3 type 5
> [  724.361934] sd 2:0:1:0: Attached scsi generic sg4 type 0
> [  724.415804] ATK0110 ATK0110:00: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
> [  724.420851] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
> [  724.420934] ACPI: Sleep Button [SLPB]
> [  724.421279] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
> [  724.421355] ACPI: Power Button [PWRB]
> [  724.421511] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
> [  724.421585] ACPI: Power Button [PWRF]
> [  724.596126] sr 2:0:0:0: [sr0] scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
> [  724.596210] cdrom: Uniform CD-ROM driver Revision: 3.20
> [  724.596667] sr 2:0:0:0: Attached scsi CD-ROM sr0
> [  726.183709] [drm] radeon kernel modesetting enabled.
> [  726.187165] [drm] initializing kernel modesetting (RV350 0x1002:0x4153 0x1458:0x4050 0x00).
> [  726.187266] [drm] register mmio base: 0xFF4F0000
> [  726.187326] [drm] register mmio size: 65536
> [  726.188472] agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
> [  726.188550] agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
> [  726.188683] radeon 0000:01:00.0: putting AGP V3 device into 8x mode
> [  726.188766] radeon 0000:01:00.0: GTT: 256M 0xD0000000 - 0xDFFFFFFF
> [  726.188831] [drm] Generation 2 PCI interface, using max accessible memory
> [  726.188898] radeon 0000:01:00.0: VRAM: 256M 0x00000000A0000000 - 0x00000000AFFFFFFF (256M used)
> [  726.188995] [drm] Detected VRAM RAM=256M, BAR=256M
> [  726.189056] [drm] RAM width 128bits DDR
> [  726.193221] [TTM] Zone  kernel: Available graphics memory: 442910 kiB
> [  726.193283] [TTM] Zone highmem: Available graphics memory: 510338 kiB
> [  726.193347] [TTM] Initializing pool allocator
> [  726.193415] [TTM] Initializing DMA pool allocator
> [  726.193516] [drm] radeon: 256M of VRAM memory ready
> [  726.193579] [drm] radeon: 256M of GTT memory ready.
> [  726.193681] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
> [  726.196836] radeon 0000:01:00.0: WB disabled
> [  726.196899] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x00000000d0000000 and cpu addr 0xf840d000
> [  726.196981] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [  726.198266] [drm] Driver supports precise vblank timestamp query.
> [  726.198350] [drm] radeon: irq initialized.
> [  726.198417] [drm] Loading R300 Microcode
> [  726.512559] k8temp 0000:00:18.3: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
> [  726.559193] [drm] radeon: ring at 0x00000000D0001000
> [  726.559281] [drm] ring test succeeded in 1 usecs
> [  726.559620] [drm] ib test succeeded in 0 usecs
> [  726.560282] [drm] Radeon Display Connectors
> [  726.560341] [drm] Connector 0:
> [  726.560398] [drm]   VGA-1
> [  726.560455] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
> [  726.560517] [drm]   Encoders:
> [  726.560573] [drm]     CRT1: INTERNAL_DAC1
> [  726.560632] [drm] Connector 1:
> [  726.560689] [drm]   DVI-I-1
> [  726.560745] [drm]   HPD1
> [  726.560801] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
> [  726.560863] [drm]   Encoders:
> [  726.560920] [drm]     CRT2: INTERNAL_DAC2
> [  726.560978] [drm]     DFP1: INTERNAL_TMDS1
> [  726.561037] [drm] Connector 2:
> [  726.561093] [drm]   SVIDEO-1
> [  726.561150] [drm]   Encoders:
> [  726.561206] [drm]     TV1: INTERNAL_DAC2
> [  726.763606] [drm] fb mappable at 0xA0040000
> [  726.763670] [drm] vram apper at 0xA0000000
> [  726.763729] [drm] size 8294400
> [  726.763786] [drm] fb depth is 24
> [  726.763843] [drm]    pitch is 7680
> [  726.765288] fbcon: radeondrmfb (fb0) is primary device
> [  727.019048] Console: switching to colour frame buffer device 240x67
> [  727.163903] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
> [  727.176050] [drm] Initialized radeon 2.49.0 20080528 for 0000:01:00.0 on minor 0
> [  727.396107] EDAC MC: Ver: 3.0.0
> [  727.424049] MCE: In-kernel MCE decoding enabled.
> [  727.457484] EDAC amd64: Node 0: DRAM ECC enabled.
> [  727.457915] EDAC amd64: K8 revE or earlier detected (node 0).
> [  727.458465] EDAC amd64: using x4 syndromes.
> [  727.460830] EDAC MC0: Giving out device to module amd64_edac controller K8: DEV 0000:00:18.3 (INTERRUPT)
> [  727.461703] EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)
> [  727.462670] EDAC amd64: Error: amd64_edac on 32-bit is unsupported. USE AT YOUR OWN RISK!
> [  727.463401] AMD64 EDAC driver v3.5.0
> [  727.484080] powernow_k8: fid 0xc (2000 MHz), vid 0x6
> [  727.484532] powernow_k8: fid 0xa (1800 MHz), vid 0x8
> [  727.484974] powernow_k8: fid 0x2 (1000 MHz), vid 0x12
> [  727.485586] powernow_k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ (1 cpu cores) (version 2.20.00)
> [  727.564598] input: PC Speaker as /devices/platform/pcspkr/input/input6
> [  727.776075] floppy0: no floppy controllers found
> [  727.795955] ppdev: user-space parallel port driver
> [  727.977254] Error: Driver 'pcspkr' is already registered, aborting...
> [  731.360448] Adding 2200868k swap on /dev/sdc5.  Priority:-1 extents:1 across:2200868k 
> [  731.489557] EXT4-fs (sdc7): re-mounted. Opts: errors=remount-ro,data=ordered
> [  732.288340] lp0: using parport0 (interrupt-driven).
> [  732.488096] Loading iSCSI transport class v2.0-870.
> [  732.523625] iscsi: registered transport (tcp)
> [  732.708913] fuse init (API version 7.26)
> [  732.773971] tun: Universal TUN/TAP device driver, 1.6
> [  732.774434] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [  732.847808] w83627ehf: Found W83627EHG chip at 0x290
> [  732.851750] ACPI Warning: SystemIO range 0x0000000000000295-0x0000000000000296 conflicts with OpRegion 0x0000000000000290-0x0000000000000299 (\_SB.PCI0.SBRG.SIOR.HWRE) (20170119/utaddress-247)
> [  732.853348] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [  762.430514] EXT4-fs (sdc1): mounting ext3 file system using the ext4 subsystem
> [  762.497316] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
> [  762.606990] FAT-fs (sdc6): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
> [  762.753765] FAT-fs (sdb1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
> [  772.514205] Process accounting resumed
> [ 1317.700076] ------------[ cut here ]------------
> [ 1317.700092] WARNING: CPU: 0 PID: 3229 at ./arch/x86/include/asm/fpu/internal.h:538 fpu__restore+0x343/0x490
> [ 1317.700095] Modules linked in: cpufreq_conservative cpufreq_powersave cpufreq_userspace binfmt_misc nls_utf8 nls_cp437 vfat fat hwmon_vid tun cuse fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi lp ppdev pcspkr powernow_k8 amd64_edac_mod edac_mce_amd edac_core evdev serio_raw k8temp radeon snd_via82xx snd_ac97_codec ac97_bus snd_mpu401_uart snd_pcm snd_timer snd_rawmidi snd_seq_device gameport snd ttm soundcore drm_kms_helper drm i2c_algo_bit sysimgblt sr_mod syscopyarea cdrom sysfillrect fb_sys_fops button asus_atk0110 sg acpi_cpufreq ata_generic parport_pc parport tpm_tis tpm_tis_core tpm ext4 mbcache crc16 jbd2 uas sd_mod usb_storage psmouse pata_via ehci_pci uhci_hcd ehci_hcd via_rhine usbcore eata mii i2c_viapro usb_common libata scsi_mod
> [ 1317.700212] CPU: 0 PID: 3229 Comm: smbd Tainted: G      D         4.10.0+ #652
> [ 1317.700215] Hardware name: System manufacturer System Product Name/A8V-MX, BIOS 0503    12/06/2005
> [ 1317.700218] Call Trace:
> [ 1317.700226]  dump_stack+0x77/0xac
> [ 1317.700232]  __warn+0xea/0x110
> [ 1317.700237]  ? fpu__restore+0x343/0x490
> [ 1317.700242]  warn_slowpath_null+0x25/0x30
> [ 1317.700246]  fpu__restore+0x343/0x490
> [ 1317.700251]  __fpu__restore_sig+0x256/0x800
> [ 1317.700261]  fpu__restore_sig+0x2a/0x50
> [ 1317.700266]  restore_sigcontext.isra.10+0xd0/0xf0
> [ 1317.700271]  sys_sigreturn+0x9c/0xb0
> [ 1317.700276]  do_int80_syscall_32+0x61/0x150
> [ 1317.700282]  entry_INT80_32+0x2f/0x2f
> [ 1317.700285] EIP: 0xb76e6ce9
> [ 1317.700288] EFLAGS: 00200246 CPU: 0
> [ 1317.700291] EAX: fffffffc EBX: 00000003 ECX: bfcb9144 EDX: 00000001
> [ 1317.700294] ESI: 000610cb EDI: bfcb9128 EBP: 00000000 ESP: bfcb90e4
> [ 1317.700297]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
> [ 1317.700402] ---[ end trace b1bff84fe33f3678 ]---
> [ 2199.567972] perf: interrupt took too long (2509 > 2500), lowering kernel.perf_event_max_sample_rate to 79500
> [ 2700.692080] usb 2-6: new high-speed USB device number 3 using ehci-pci
> [ 2700.841349] usb 2-6: New USB device found, idVendor=04e8, idProduct=6860
> [ 2700.841358] usb 2-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [ 2700.841362] usb 2-6: Product: SAMSUNG_Android
> [ 2700.841365] usb 2-6: Manufacturer: SAMSUNG
> [ 2700.841368] usb 2-6: SerialNumber: 1101af07a03eb200
> [ 3068.313765] perf: interrupt took too long (3145 > 3136), lowering kernel.perf_event_max_sample_rate to 63500
> [ 3565.600541]  sdd: sdd1 sdd2 < sdd5 sdd6 sdd7 > sdd3
> [ 3616.900891]  sdd: sdd1 sdd2 < sdd5 sdd6 sdd7 > sdd3
> [ 3619.430478]  sdd: sdd1 sdd2 < sdd5 sdd6 sdd7 > sdd3
> [ 3998.230325] usb 2-6: USB disconnect, device number 3

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--oTHb8nViIGeoXxdp
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-block-Allow-bdi-re-registration.patch"

>From 60623ea9de6309f7717fc3536e3594b079735af0 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 7 Mar 2017 18:01:51 +0100
Subject: [PATCH 1/2] block: Allow bdi re-registration

SCSI can call device_add_disk() several times for one request queue when
a device in unbound and bound, creating new gendisk each time. This will
lead to bdi being repeatedly registered and unregistered. This was not a
big problem until commit 165a5e22fafb "block: Move bdi_unregister() to
del_gendisk()" since bdi was only registered repeatedly (bdi_register()
handles repeated calls fine, only we ended up leaking reference to
gendisk due to overwriting bdi->owner) but unregistered only in
blk_cleanup_queue() which didn't get called repeatedly. After
165a5e22fafb we were doing correct bdi_register() - bdi_unregister()
cycles however bdi_unregister() is not prepared for it. So make sure
bdi_unregister() cleans up bdi in such a way that it is prepared for
a possible following bdi_register() call.

An easy way to provoke this behavior is to enable
CONFIG_DEBUG_TEST_DRIVER_REMOVE and use scsi_debug driver to create a
scsi disk which immediately hangs without this fix.

Fixes: 165a5e22fafb127ecb5914e12e8c32a1f0d3f820
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 6d861d090e9f..6ac932210f56 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -710,6 +710,11 @@ static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
 	 */
 	atomic_dec(&bdi->usage_cnt);
 	wait_event(cgwb_release_wait, !atomic_read(&bdi->usage_cnt));
+	/*
+	 * Grab back our reference so that we hold it when @bdi gets
+	 * re-registered.
+	 */
+	atomic_inc(&bdi->usage_cnt);
 }
 
 /**
@@ -857,6 +862,8 @@ int bdi_register_owner(struct backing_dev_info *bdi, struct device *owner)
 			MINOR(owner->devt));
 	if (rc)
 		return rc;
+	/* Leaking owner reference... */
+	WARN_ON(bdi->owner);
 	bdi->owner = owner;
 	get_device(owner);
 	return 0;
-- 
2.10.2


--oTHb8nViIGeoXxdp
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-bdi-Fix-use-after-free-in-wb_congested_put.patch"

>From b9a6424cabd0eb4a663a1faeb11afef268faebc6 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 8 Mar 2017 13:24:47 +0100
Subject: [PATCH 2/2] bdi: Fix use-after-free in wb_congested_put()

bdi_writeback_congested structures get created for each blkcg and bdi
regardless whether bdi is registered or not. When they are created in
unregistered bdi and the request queue (and thus bdi) is then destroyed
while blkg still holds reference to bdi_writeback_congested structure,
this structure will be referencing freed bdi and last wb_congested_put()
will try to remove the structure from already freed bdi.

With commit 165a5e22fafb "block: Move bdi_unregister() to
del_gendisk()", SCSI started to destroy bdis without calling
bdi_unregister() first (previously it was calling bdi_unregister() even
for unregistered bdis) and thus the code detaching
bdi_writeback_congested in cgwb_bdi_destroy() was not triggered and we
started hitting this use-after-free bug. It is enough to boot a KVM
instance with virtio-scsi device to trigger this behavior.

Fix the problem by detaching bdi_writeback_congested structures in
bdi_exit() instead of bdi_unregister(). This is also more logical as
they can get attached to bdi regardless whether it ever got registered
or not.

Fixes: 165a5e22fafb127ecb5914e12e8c32a1f0d3f820
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 6ac932210f56..c6f2a37028c2 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -683,30 +683,18 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
 {
 	struct radix_tree_iter iter;
-	struct rb_node *rbn;
 	void **slot;
 
 	WARN_ON(test_bit(WB_registered, &bdi->wb.state));
 
 	spin_lock_irq(&cgwb_lock);
-
 	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
 		cgwb_kill(*slot);
-
-	while ((rbn = rb_first(&bdi->cgwb_congested_tree))) {
-		struct bdi_writeback_congested *congested =
-			rb_entry(rbn, struct bdi_writeback_congested, rb_node);
-
-		rb_erase(rbn, &bdi->cgwb_congested_tree);
-		congested->bdi = NULL;	/* mark @congested unlinked */
-	}
-
 	spin_unlock_irq(&cgwb_lock);
 
 	/*
-	 * All cgwb's and their congested states must be shutdown and
-	 * released before returning.  Drain the usage counter to wait for
-	 * all cgwb's and cgwb_congested's ever created on @bdi.
+	 * All cgwb's must be shutdown and released before returning.  Drain
+	 * the usage counter to wait for all cgwb's ever created on @bdi.
 	 */
 	atomic_dec(&bdi->usage_cnt);
 	wait_event(cgwb_release_wait, !atomic_read(&bdi->usage_cnt));
@@ -754,6 +742,21 @@ void wb_blkcg_offline(struct blkcg *blkcg)
 	spin_unlock_irq(&cgwb_lock);
 }
 
+static void cgwb_bdi_exit(struct backing_dev_info *bdi)
+{
+	struct rb_node *rbn;
+
+	spin_lock_irq(&cgwb_lock);
+	while ((rbn = rb_first(&bdi->cgwb_congested_tree))) {
+		struct bdi_writeback_congested *congested =
+			rb_entry(rbn, struct bdi_writeback_congested, rb_node);
+
+		rb_erase(rbn, &bdi->cgwb_congested_tree);
+		congested->bdi = NULL;	/* mark @congested unlinked */
+	}
+	spin_unlock_irq(&cgwb_lock);
+}
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static int cgwb_bdi_init(struct backing_dev_info *bdi)
@@ -774,7 +777,9 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 	return 0;
 }
 
-static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
+static void cgwb_bdi_destroy(struct backing_dev_info *bdi) { }
+
+static void cgwb_bdi_exit(struct backing_dev_info *bdi)
 {
 	wb_congested_put(bdi->wb_congested);
 }
@@ -905,6 +910,7 @@ static void bdi_exit(struct backing_dev_info *bdi)
 {
 	WARN_ON_ONCE(bdi->dev);
 	wb_exit(&bdi->wb);
+	cgwb_bdi_exit(bdi);
 }
 
 static void release_bdi(struct kref *ref)
-- 
2.10.2


--oTHb8nViIGeoXxdp--
