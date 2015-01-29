From: Meelis Roos <mroos@linux.ee>
Subject: kobject (00000000008e10d8): tried to init an initialized object,
 something is seriously wrong.
Date: Thu, 29 Jan 2015 10:03:27 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1501290948470.25245@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:59432 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbbA2IEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 03:04:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel list <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org

Tried 3.19.0-rc6-00105-gc59c961-dirty (first kernel after 3.18) on Sun 
E3000 (spoarc64), got a bunch on warnings in blk_mq_register_disk. After 
that, it seems to work fine.

-dirty means the following patch to fix the warnings in "Another (ESP?) 
scsi blk-mq problem on sparc64" thread from Nov 14 2014.

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 0a9a6da..db21f68 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -83,7 +83,13 @@ extern const struct cpumask *const cpu_active_mask;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
-#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
+/*
+ * For platforms with discontig CPU numbering, the weight of the possible
+ * bitmask may be less than the highest numbered CPU. Return the max of
+ * the two, to prevent accidentical bugs.
+ */
+#define num_possible_cpus()	\
+	max_t(unsigned int, cpumask_weight(cpu_possible_mask), nr_cpu_ids)
 #define num_present_cpus()	cpumask_weight(cpu_present_mask)
 #define num_active_cpus()	cpumask_weight(cpu_active_mask)
 #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)



Full dmesg:

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.19.0-rc6-00105-gc59c961-dirty (mroos@mandel) (gcc version 4.9.2 (Debian 4.9.2-1) ) #31 SMP Wed Jan 28 16:40:28 EET 2015
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 00:03:ba:12:70:5c
[    0.000000] MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
[    0.000000] MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
[    0.000000] MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
[    0.000000] PROM: Built device tree with 95892 bytes of memory.
[    0.000000] Top of RAM: 0xffd16000, Total RAM: 0xff954000
[    0.000000] Memory hole size: 3MB
[    0.000000] Allocated 16384 bytes for kernel page tables.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0xffd15fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0xff84dfff]
[    0.000000]   node   0: [mem 0xffc00000-0xffceffff]
[    0.000000]   node   0: [mem 0xffd00000-0xffd15fff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0xffd15fff]
[    0.000000] On node 0 totalpages: 523434
[    0.000000]   Normal zone: 4094 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 523434 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
[    0.000000] CPU CAPS: [vis]
[    0.000000] PERCPU: Embedded 7 pages/cpu @fffff800ff400000 s13888 r8192 d35264 u1048576
[    0.000000] pcpu-alloc: s13888 r8192 d35264 u1048576 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 10 11 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519340
[    0.000000] Kernel command line: root=/dev/sda2 ro ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 4142456K/4187472K available (3684K kernel code, 242K rwdata, 808K rodata, 184K init, 413K bss, 45016K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[  138.460070] clocksource: mult[2042108] shift[23]
[  138.514676] clockevent: mult[3f7ced91] shift[32]
[  138.570180] Console: colour dummy device 80x25
[  138.623106] console [tty0] enabled
[  138.663685] bootconsole [earlyprom0] disabled
[  138.865946] Calibrating delay using timer specific routine.. 497.37 BogoMIPS (lpj=2486892)
[  138.866023] pid_max: default: 32768 minimum: 301
[  138.866453] Mount-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  138.866515] Mountpoint-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  138.877710] CPU 11: synchronized TICK with master CPU (last diff -1 cycles, maxerr 517 cycles)
[  138.882148] CPU 14: synchronized TICK with master CPU (last diff -4 cycles, maxerr 529 cycles)
[  138.886557] CPU 15: synchronized TICK with master CPU (last diff -4 cycles, maxerr 529 cycles)
[  138.886777] Brought up 4 CPUs
[  138.888914] devtmpfs: initialized
[  138.963355] device-tree: Duplicate name in base, renamed to "fhc#1"
[  138.967091] device-tree: Duplicate name in base, renamed to "fhc#2"
[  138.970036] device-tree: Duplicate name in base, renamed to "counter-timer#1"
[  138.971620] NET: Registered protocol family 16
[  138.998352] SYSIO: UPA portID ffffffff, at 000001c400000000
[  139.009269] SYSIO: UPA portID ffffffff, at 000001c600000000
[  139.061357] SCSI subsystem initialized
[  139.064947] /central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
[  139.066214] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
[  139.066700] fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
[  139.067307] fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
[  139.067803] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
[  139.068447] clock_board: Detected 4 slot Enterprise system.
[  139.069239] Switched to clocksource tick
[  139.102051] NET: Registered protocol family 2
[  139.104429] TCP established hash table entries: 32768 (order: 5, 262144 bytes)
[  139.106151] TCP bind hash table entries: 32768 (order: 6, 524288 bytes)
[  139.109388] TCP: Hash tables configured (established 32768 bind 32768)
[  139.110166] TCP: reno registered
[  139.110247] UDP hash table entries: 2048 (order: 3, 65536 bytes)
[  139.110782] UDP-Lite hash table entries: 2048 (order: 3, 65536 bytes)
[  139.112157] NET: Registered protocol family 1
[  139.117774] futex hash table entries: 4096 (order: 5, 262144 bytes)
[  139.119535] audit: initializing netlink subsys (disabled)
[  139.119773] audit: type=2000 audit(0.429:1): initialized
[  139.121150] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[  139.171114] io scheduler noop registered
[  139.172542] io scheduler cfq registered (default)
[  139.381725] f005ddbc: ttyS0 at MMIO 0x1fff8902000 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  139.381833] Console: ttyS0 (SunZilog zs0)
[  145.380188] console [ttyS0] enabled
[  145.423020] f005ddbc: ttyS1 at MMIO 0x1fff8902004 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  145.734171] f005de94: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
[  145.810322] f005de94: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
[  145.888385] esp f00945a0: esp0: regs[1c738810000:1c738800000] irq[20]
[  145.963515] esp f00945a0: esp0: is a FASHME, 40 MHz (ccf=0), SCSI ID 7
[  149.049186] scsi host0: esp
[  149.085446] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[  149.164019] scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  149.165607] TCP: cubic registered
[  149.168299] NET: Registered protocol family 10
[  149.171523] NET: Registered protocol family 17
[  149.260719] rtc-m48t59 rtc-m48t59.0: setting system clock to 2015-01-28 15:51:22 UTC (1422460282)
[  149.512893] scsi target0:0:0: Beginning Domain Validation
[  149.596067] scsi target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  149.688764] scsi target0:0:0: Domain Validation skipping write tests
[  149.762828] scsi target0:0:0: Ending Domain Validation
[  149.833677] scsi 0:0:1:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  149.928668] scsi target0:0:1: Beginning Domain Validation
[  150.009245] scsi target0:0:1: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  150.102000] scsi target0:0:1: Domain Validation skipping write tests
[  150.176028] scsi target0:0:1: Ending Domain Validation
[  150.244282] scsi 0:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
[  150.339263] scsi target0:0:2: Beginning Domain Validation
[  150.410823] scsi target0:0:2: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  150.499704] scsi target0:0:2: Domain Validation skipping write tests
[  150.573814] scsi target0:0:2: Ending Domain Validation
[  153.463315] sd 0:0:2:0: [sdc] Spinning up disk...
[  153.517754] sd 0:0:1:0: [sdb] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  153.517800] sd 0:0:0:0: [sda] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  153.698994] sd 0:0:0:0: [sda] Write Protect is off
[  153.756163] sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
[  153.756316] sd 0:0:1:0: [sdb] Write Protect is off
[  153.756340] sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
[  153.874013] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  154.039637] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  154.151807]  sdb: unknown partition table
[  154.198629] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  154.313497] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  154.313938]  sda: sda1 sda2 sda3 sda4
[  154.421820] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  154.576018] Workqueue: events_unbound async_run_entry_fn
[  154.579181] .

[  154.658195] Call Trace:
[  154.687444]  [000000000060ce20] kobject_init+0x80/0xa0
[  154.748944]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  154.819764]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  154.888539]  [00000000005fc6bc] add_disk+0x19c/0x460
[  154.947927]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.012539]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.081282]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.148994]  [0000000000468db4] worker_thread+0x114/0x500
[  155.213569]  [000000000046d774] kthread+0xb4/0xe0
[  155.269881]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.332358]  [0000000000000000]           (null)
[  155.387566] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  155.387610] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.387673] Workqueue: events_unbound async_run_entry_fn
[  155.387679] Call Trace:
[  155.387718]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.387747]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.387780]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.387804]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.387849]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.387875]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.387915]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.387935]  [0000000000468db4] worker_thread+0x114/0x500
[  155.387955]  [000000000046d774] kthread+0xb4/0xe0
[  155.387993]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.388002]  [0000000000000000]           (null)
[  155.388013] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.388029] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.388057] Workqueue: events_unbound async_run_entry_fn
[  155.388061] Call Trace:
[  155.388078]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.388097]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.388116]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.388133]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.388156]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.388182]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.388203]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.388223]  [0000000000468db4] worker_thread+0x114/0x500
[  155.388238]  [000000000046d774] kthread+0xb4/0xe0
[  155.388258]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.388265]  [0000000000000000]           (null)
[  155.388275] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.388292] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.388320] Workqueue: events_unbound async_run_entry_fn
[  155.388324] Call Trace:
[  155.388341]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.388359]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.388379]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.388396]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.388419]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.388442]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.388464]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.388483]  [0000000000468db4] worker_thread+0x114/0x500
[  155.388499]  [000000000046d774] kthread+0xb4/0xe0
[  155.388519]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.388526]  [0000000000000000]           (null)
[  155.388536] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.388553] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.388576] Workqueue: events_unbound async_run_entry_fn
[  155.388579] Call Trace:
[  155.388597]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.388615]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.388634]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.388652]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.388674]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.388696]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.388718]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.388737]  [0000000000468db4] worker_thread+0x114/0x500
[  155.388753]  [000000000046d774] kthread+0xb4/0xe0
[  155.388772]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.388779]  [0000000000000000]           (null)
[  155.388790] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.388806] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.388830] Workqueue: events_unbound async_run_entry_fn
[  155.388833] Call Trace:
[  155.388851]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.388869]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.388888]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.388906]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.388928]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.388950]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.388971]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.388991]  [0000000000468db4] worker_thread+0x114/0x500
[  155.389006]  [000000000046d774] kthread+0xb4/0xe0
[  155.389025]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.389061]  [0000000000000000]           (null)
[  155.389072] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.389090] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.389115] Workqueue: events_unbound async_run_entry_fn
[  155.389119] Call Trace:
[  155.389137]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.389155]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.389175]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.389193]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.389216]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.389238]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.389260]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.389280]  [0000000000468db4] worker_thread+0x114/0x500
[  155.389296]  [000000000046d774] kthread+0xb4/0xe0
[  155.389315]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.389322]  [0000000000000000]           (null)
[  155.389333] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.389350] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.389373] Workqueue: events_unbound async_run_entry_fn
[  155.389376] Call Trace:
[  155.389394]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.389413]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.389433]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.389451]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.389473]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.389495]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.389517]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.389537]  [0000000000468db4] worker_thread+0x114/0x500
[  155.389553]  [000000000046d774] kthread+0xb4/0xe0
[  155.389573]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.389580]  [0000000000000000]           (null)
[  155.389590] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.389607] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.389630] Workqueue: events_unbound async_run_entry_fn
[  155.389633] Call Trace:
[  155.389651]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.389670]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.389689]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.389707]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.389730]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.389752]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.389773]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.389793]  [0000000000468db4] worker_thread+0x114/0x500
[  155.389809]  [000000000046d774] kthread+0xb4/0xe0
[  155.389829]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.389836]  [0000000000000000]           (null)
[  155.389846] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.389863] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.389886] Workqueue: events_unbound async_run_entry_fn
[  155.389890] Call Trace:
[  155.389908]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.389926]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.389946]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.389963]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.389986]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.390008]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.390030]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.390050]  [0000000000468db4] worker_thread+0x114/0x500
[  155.390065]  [000000000046d774] kthread+0xb4/0xe0
[  155.390086]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.390093]  [0000000000000000]           (null)
[  155.390104] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.390121] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.390144] Workqueue: events_unbound async_run_entry_fn
[  155.390148] Call Trace:
[  155.390166]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.390184]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.390203]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.390221]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.390244]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.390266]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.390287]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.390307]  [0000000000468db4] worker_thread+0x114/0x500
[  155.390323]  [000000000046d774] kthread+0xb4/0xe0
[  155.390343]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.390350]  [0000000000000000]           (null)
[  155.390360] kobject (00000000008e0658): tried to init an initialized object, something is seriously wrong.
[  155.390377] CPU: 15 PID: 6 Comm: kworker/u8:0 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  155.390400] Workqueue: events_unbound async_run_entry_fn
[  155.390404] Call Trace:
[  155.390422]  [000000000060ce20] kobject_init+0x80/0xa0
[  155.390440]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  155.390460]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  155.390478]  [00000000005fc6bc] add_disk+0x19c/0x460
[  155.390500]  [000000000068b570] sd_probe_async+0xd0/0x180
[  155.390522]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  155.390544]  [00000000004683bc] process_one_work+0x15c/0x340
[  155.390564]  [0000000000468db4] worker_thread+0x114/0x500
[  155.390580]  [000000000046d774] kthread+0xb4/0xe0
[  155.390600]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  155.390607]  [0000000000000000]           (null)
[  155.831285] .
[  155.831287] sd 0:0:0:0: [sda] Attached SCSI disk
[  166.578133] .........
[  166.578135] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  166.708416] Workqueue: events_unbound async_run_entry_fn
[  166.771847] Call Trace:
[  166.801116]  [000000000060ce20] kobject_init+0x80/0xa0
[  166.862566]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  166.933410]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  167.002180]  [00000000005fc6bc] add_disk+0x19c/0x460
[  167.061592]  [000000000068b570] sd_probe_async+0xd0/0x180
[  167.126162]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  167.194925]  [00000000004683bc] process_one_work+0x15c/0x340
[  167.262644] .
[  167.262646]  [0000000000468db4] worker_thread+0x114/0x500
[  167.346014]  [000000000046d774] kthread+0xb4/0xe0
[  167.402246]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  167.464744]  [0000000000000000]           (null)
[  167.519963] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  167.635677] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  167.738803] Workqueue: events_unbound async_run_entry_fn
[  167.802241] Call Trace:
[  167.831479]  [000000000060ce20] kobject_init+0x80/0xa0
[  167.892991]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  167.963813]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  168.032571]  [00000000005fc6bc] add_disk+0x19c/0x460
[  168.091961]  [000000000068b570] sd_probe_async+0xd0/0x180
[  168.156581]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  168.225318]  [00000000004683bc] process_one_work+0x15c/0x340
[  168.293040]  [0000000000468db4] worker_thread+0x114/0x500
[  168.357624] .
[  168.357626]  [000000000046d774] kthread+0xb4/0xe0
[  168.432672]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  168.495144]  [0000000000000000]           (null)
[  168.550361] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  168.666055] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  168.769222] Workqueue: events_unbound async_run_entry_fn
[  168.832641] Call Trace:
[  168.861875]  [000000000060ce20] kobject_init+0x80/0xa0
[  168.923357]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  168.994202]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  169.062992]  [00000000005fc6bc] add_disk+0x19c/0x460
[  169.122353]  [000000000068b570] sd_probe_async+0xd0/0x180
[  169.186950]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  169.255715]  [00000000004683bc] process_one_work+0x15c/0x340
[  169.323464]  [0000000000468db4] worker_thread+0x114/0x500
[  169.388024]  [000000000046d774] kthread+0xb4/0xe0
[  169.444284] .
[  169.444285]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  169.525539]  [0000000000000000]           (null)
[  169.580779] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  169.696446] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  169.799588] Workqueue: events_unbound async_run_entry_fn
[  169.863035] Call Trace:
[  169.892270]  [000000000060ce20] kobject_init+0x80/0xa0
[  169.953747]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  170.024599]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  170.093358]  [00000000005fc6bc] add_disk+0x19c/0x460
[  170.152779]  [000000000068b570] sd_probe_async+0xd0/0x180
[  170.217347]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  170.286104]  [00000000004683bc] process_one_work+0x15c/0x340
[  170.353823]  [0000000000468db4] worker_thread+0x114/0x500
[  170.418442]  [000000000046d774] kthread+0xb4/0xe0
[  170.474681]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  170.537176] .
[  170.537178]  [0000000000000000]           (null)
[  170.611148] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  170.726867] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  170.829989] Workqueue: events_unbound async_run_entry_fn
[  170.893425] Call Trace:
[  170.922667]  [000000000060ce20] kobject_init+0x80/0xa0
[  170.984171]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  171.054993]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  171.123756]  [00000000005fc6bc] add_disk+0x19c/0x460
[  171.183145]  [000000000068b570] sd_probe_async+0xd0/0x180
[  171.247765]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  171.316502]  [00000000004683bc] process_one_work+0x15c/0x340
[  171.384220]  [0000000000468db4] worker_thread+0x114/0x500
[  171.448807]  [000000000046d774] kthread+0xb4/0xe0
[  171.505105]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  171.567569]  [0000000000000000]           (null)
[  171.622790] .
[  171.622792] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  171.757239] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  171.860403] Workqueue: events_unbound async_run_entry_fn
[  171.923821] Call Trace:
[  171.953058]  [000000000060ce20] kobject_init+0x80/0xa0
[  172.014535]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  172.085389]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  172.154178]  [00000000005fc6bc] add_disk+0x19c/0x460
[  172.213539]  [000000000068b570] sd_probe_async+0xd0/0x180
[  172.278129]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  172.346897]  [00000000004683bc] process_one_work+0x15c/0x340
[  172.414646]  [0000000000468db4] worker_thread+0x114/0x500
[  172.479202]  [000000000046d774] kthread+0xb4/0xe0
[  172.535469]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  172.597967]  [0000000000000000]           (null)
[  172.653188] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  172.768935] .
[  172.768937] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  172.890778] Workqueue: events_unbound async_run_entry_fn
[  172.954218] Call Trace:
[  172.983452]  [000000000060ce20] kobject_init+0x80/0xa0
[  173.044962]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  173.115784]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  173.184542]  [00000000005fc6bc] add_disk+0x19c/0x460
[  173.243935]  [000000000068b570] sd_probe_async+0xd0/0x180
[  173.308555]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  173.377297]  [00000000004683bc] process_one_work+0x15c/0x340
[  173.445014]  [0000000000468db4] worker_thread+0x114/0x500
[  173.509595]  [000000000046d774] kthread+0xb4/0xe0
[  173.565890]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  173.628359]  [0000000000000000]           (null)
[  173.683580] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  173.799276] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  173.902444] .
[  173.921098] Workqueue: events_unbound async_run_entry_fn
[  173.984676] Call Trace:
[  174.013843]  [000000000060ce20] kobject_init+0x80/0xa0
[  174.075333]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  174.146177]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  174.214970]  [00000000005fc6bc] add_disk+0x19c/0x460
[  174.274330]  [000000000068b570] sd_probe_async+0xd0/0x180
[  174.338938]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  174.407683]  [00000000004683bc] process_one_work+0x15c/0x340
[  174.475433]  [0000000000468db4] worker_thread+0x114/0x500
[  174.539996]  [000000000046d774] kthread+0xb4/0xe0
[  174.596255]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  174.658753]  [0000000000000000]           (null)
[  174.713979] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  174.829694] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  174.932808] Workqueue: events_unbound async_run_entry_fn
[  174.938969] .

[  175.015005] Call Trace:
[  175.044240]  [000000000060ce20] kobject_init+0x80/0xa0
[  175.105750]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  175.176575]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  175.245331]  [00000000005fc6bc] add_disk+0x19c/0x460
[  175.304720]  [000000000068b570] sd_probe_async+0xd0/0x180
[  175.369347]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  175.438086]  [00000000004683bc] process_one_work+0x15c/0x340
[  175.505802]  [0000000000468db4] worker_thread+0x114/0x500
[  175.570390]  [000000000046d774] kthread+0xb4/0xe0
[  175.626653]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  175.689178]  [0000000000000000]           (null)
[  175.744367] kobject (00000000008e0e58): tried to init an initialized object, something is seriously wrong.
[  175.860057] CPU: 14 PID: 46 Comm: kworker/u8:2 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  175.963232] Workqueue: events_unbound async_run_entry_fn
[  176.026650] Call Trace:
[  176.055885] .
[  176.055886]  [000000000060ce20] kobject_init+0x80/0xa0
[  176.136116]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  176.206966]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  176.275755]  [00000000005fc6bc] add_disk+0x19c/0x460
[  176.335117]  [000000000068b570] sd_probe_async+0xd0/0x180
[  176.399709]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  176.468473]  [00000000004683bc] process_one_work+0x15c/0x340
[  176.536228]  [0000000000468db4] worker_thread+0x114/0x500
[  176.600785]  [000000000046d774] kthread+0xb4/0xe0
[  176.657041]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  176.719544]  [0000000000000000]           (null)
[  176.780899] sd 0:0:1:0: [sdb] Attached SCSI disk
[  177.078939] .............................................................................not responding...
[  253.869566] sd 0:0:2:0: [sdc] Read Capacity(10) failed: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  253.980130] sd 0:0:2:0: [sdc] Sense Key : Not Ready [current]
[  254.048859] sd 0:0:2:0: [sdc] Add. Sense: Logical unit not ready, cause not reportable
[  254.146163] sd 0:0:2:0: [sdc] Test WP failed, assume Write Enabled
[  254.218964] sd 0:0:2:0: [sdc] Asking for cache data failed
[  254.283789] sd 0:0:2:0: [sdc] Assuming drive cache: write through
[  254.359069] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  254.473827] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  254.575864] Workqueue: events_unbound async_run_entry_fn
[  254.639331] Call Trace:
[  254.668534]  [000000000060ce20] kobject_init+0x80/0xa0
[  254.730047]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  254.800864]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  254.869625]  [00000000005fc6bc] add_disk+0x19c/0x460
[  254.929042]  [000000000068b570] sd_probe_async+0xd0/0x180
[  254.993641]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  255.062375]  [00000000004683bc] process_one_work+0x15c/0x340
[  255.130092]  [0000000000468db4] worker_thread+0x114/0x500
[  255.194678]  [000000000046d774] kthread+0xb4/0xe0
[  255.250974]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  255.313455]  [0000000000000000]           (null)
[  255.368663] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  255.484359] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  255.587536] Workqueue: events_unbound async_run_entry_fn
[  255.650948] Call Trace:
[  255.680177]  [000000000060ce20] kobject_init+0x80/0xa0
[  255.741655]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  255.812516]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  255.881298]  [00000000005fc6bc] add_disk+0x19c/0x460
[  255.940661]  [000000000068b570] sd_probe_async+0xd0/0x180
[  256.005259]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  256.074017]  [00000000004683bc] process_one_work+0x15c/0x340
[  256.141767]  [0000000000468db4] worker_thread+0x114/0x500
[  256.206325]  [000000000046d774] kthread+0xb4/0xe0
[  256.262586]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  256.325084]  [0000000000000000]           (null)
[  256.380304] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  256.496033] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  256.599143] Workqueue: events_unbound async_run_entry_fn
[  256.662584] Call Trace:
[  256.691816]  [000000000060ce20] kobject_init+0x80/0xa0
[  256.753335]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  256.824155]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  256.892910]  [00000000005fc6bc] add_disk+0x19c/0x460
[  256.952300]  [000000000068b570] sd_probe_async+0xd0/0x180
[  257.016929]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  257.085662]  [00000000004683bc] process_one_work+0x15c/0x340
[  257.153378]  [0000000000468db4] worker_thread+0x114/0x500
[  257.217964]  [000000000046d774] kthread+0xb4/0xe0
[  257.274261]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  257.336726]  [0000000000000000]           (null)
[  257.391944] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  257.507645] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  257.610811] Workqueue: events_unbound async_run_entry_fn
[  257.674230] Call Trace:
[  257.703463]  [000000000060ce20] kobject_init+0x80/0xa0
[  257.764947]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  257.835789]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  257.904580]  [00000000005fc6bc] add_disk+0x19c/0x460
[  257.963943]  [000000000068b570] sd_probe_async+0xd0/0x180
[  258.028541]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  258.097302]  [00000000004683bc] process_one_work+0x15c/0x340
[  258.165050]  [0000000000468db4] worker_thread+0x114/0x500
[  258.229607]  [000000000046d774] kthread+0xb4/0xe0
[  258.285867]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  258.348368]  [0000000000000000]           (null)
[  258.403593] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  258.519301] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  258.622429] Workqueue: events_unbound async_run_entry_fn
[  258.685869] Call Trace:
[  258.715102]  [000000000060ce20] kobject_init+0x80/0xa0
[  258.776587]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  258.847466]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  258.916188]  [00000000005fc6bc] add_disk+0x19c/0x460
[  258.975586]  [000000000068b570] sd_probe_async+0xd0/0x180
[  259.040178]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  259.108972]  [00000000004683bc] process_one_work+0x15c/0x340
[  259.176664]  [0000000000468db4] worker_thread+0x114/0x500
[  259.241256]  [000000000046d774] kthread+0xb4/0xe0
[  259.297508]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  259.360017]  [0000000000000000]           (null)
[  259.415258] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  259.530925] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  259.634064] Workqueue: events_unbound async_run_entry_fn
[  259.697513] Call Trace:
[  259.726748]  [000000000060ce20] kobject_init+0x80/0xa0
[  259.788253]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  259.859076]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  259.927840]  [00000000005fc6bc] add_disk+0x19c/0x460
[  259.987250]  [000000000068b570] sd_probe_async+0xd0/0x180
[  260.051820]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  260.120589]  [00000000004683bc] process_one_work+0x15c/0x340
[  260.188305]  [0000000000468db4] worker_thread+0x114/0x500
[  260.252921]  [000000000046d774] kthread+0xb4/0xe0
[  260.309151]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  260.371651]  [0000000000000000]           (null)
[  260.426879] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  260.542588] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  260.645706] Workqueue: events_unbound async_run_entry_fn
[  260.709187] Call Trace:
[  260.738390]  [000000000060ce20] kobject_init+0x80/0xa0
[  260.799893]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  260.870714]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  260.939476]  [00000000005fc6bc] add_disk+0x19c/0x460
[  260.998864]  [000000000068b570] sd_probe_async+0xd0/0x180
[  261.063493]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  261.132223]  [00000000004683bc] process_one_work+0x15c/0x340
[  261.199941]  [0000000000468db4] worker_thread+0x114/0x500
[  261.264534]  [000000000046d774] kthread+0xb4/0xe0
[  261.320820]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  261.383297]  [0000000000000000]           (null)
[  261.438519] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  261.554202] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  261.657373] Workqueue: events_unbound async_run_entry_fn
[  261.720796] Call Trace:
[  261.750029]  [000000000060ce20] kobject_init+0x80/0xa0
[  261.811508]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  261.882356]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  261.951147]  [00000000005fc6bc] add_disk+0x19c/0x460
[  262.010512]  [000000000068b570] sd_probe_async+0xd0/0x180
[  262.075104]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  262.143865]  [00000000004683bc] process_one_work+0x15c/0x340
[  262.211613]  [0000000000468db4] worker_thread+0x114/0x500
[  262.276171]  [000000000046d774] kthread+0xb4/0xe0
[  262.332438]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  262.394929]  [0000000000000000]           (null)
[  262.450153] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  262.565870] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  262.668993] Workqueue: events_unbound async_run_entry_fn
[  262.732432] Call Trace:
[  262.761675]  [000000000060ce20] kobject_init+0x80/0xa0
[  262.823179]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  262.893993]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  262.962762]  [00000000005fc6bc] add_disk+0x19c/0x460
[  263.022145]  [000000000068b570] sd_probe_async+0xd0/0x180
[  263.086775]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  263.155507]  [00000000004683bc] process_one_work+0x15c/0x340
[  263.223226]  [0000000000468db4] worker_thread+0x114/0x500
[  263.287816]  [000000000046d774] kthread+0xb4/0xe0
[  263.344106]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  263.406582]  [0000000000000000]           (null)
[  263.461798] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  263.577487] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  263.680662] Workqueue: events_unbound async_run_entry_fn
[  263.744073] Call Trace:
[  263.773319]  [000000000060ce20] kobject_init+0x80/0xa0
[  263.834794]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  263.905644]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  263.974429]  [00000000005fc6bc] add_disk+0x19c/0x460
[  264.033791]  [000000000068b570] sd_probe_async+0xd0/0x180
[  264.098384]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  264.167147]  [00000000004683bc] process_one_work+0x15c/0x340
[  264.234894]  [0000000000468db4] worker_thread+0x114/0x500
[  264.299456]  [000000000046d774] kthread+0xb4/0xe0
[  264.355718]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  264.418220]  [0000000000000000]           (null)
[  264.473435] kobject (00000000008e10d8): tried to init an initialized object, something is seriously wrong.
[  264.589154] CPU: 15 PID: 35 Comm: kworker/u8:1 Not tainted 3.19.0-rc6-00105-gc59c961-dirty #31
[  264.692271] Workqueue: events_unbound async_run_entry_fn
[  264.755717] Call Trace:
[  264.784950]  [000000000060ce20] kobject_init+0x80/0xa0
[  264.846436]  [00000000005f9880] blk_mq_register_disk+0xa0/0x180
[  264.917313]  [00000000005ef6b0] blk_register_queue+0x70/0x120
[  264.986047]  [00000000005fc6bc] add_disk+0x19c/0x460
[  265.045431]  [000000000068b570] sd_probe_async+0xd0/0x180
[  265.110023]  [000000000046ff34] async_run_entry_fn+0x34/0x100
[  265.178815]  [00000000004683bc] process_one_work+0x15c/0x340
[  265.246512]  [0000000000468db4] worker_thread+0x114/0x500
[  265.311094]  [000000000046d774] kthread+0xb4/0xe0
[  265.367362]  [00000000004060e4] ret_from_fork+0x1c/0x2c
[  265.429864]  [0000000000000000]           (null)
[  265.488620] sd 0:0:2:0: [sdc] Spinning up disk...
[  266.548289] ............
[  277.668385] random: nonblocking pool is initialized
[  278.738170] .......................................................................................not responding...
[  365.628699] sd 0:0:2:0: [sdc] Read Capacity(10) failed: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  365.739310] sd 0:0:2:0: [sdc] Sense Key : Not Ready [current]
[  365.808031] sd 0:0:2:0: [sdc] Add. Sense: Logical unit not ready, cause not reportable
[  365.906637] sd 0:0:2:0: [sdc] Attached SCSI disk
[  365.970544] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[  366.063367] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[  366.199154] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[  366.288956] VFS: Mounted root (ext4 filesystem) readonly on device 259:786432.
[  366.399127] devtmpfs: mounted
[  367.085045] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ -SECCOMP -APPARMOR)
[  367.243095] systemd[1]: Detected architecture 'sparc64'.
[  367.552684] systemd[1]: Failed to insert module 'autofs4'
[  367.623891] systemd[1]: Set hostname to <mandel>.
[  369.308980] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[  369.491743] systemd[1]: Expecting device dev-ttyS0.device...
[  369.617729] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[  369.708476] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[  369.798364] systemd[1]: Starting Remote File Systems (Pre).
[  369.947661] systemd[1]: Reached target Remote File Systems (Pre).
[  370.019004] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[  370.115163] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[  370.209614] systemd[1]: Starting Paths.
[  370.317654] systemd[1]: Reached target Paths.
[  370.368176] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[  370.472339] systemd[1]: Failed to open /dev/autofs: No such file or directory
[  370.557527] systemd[1]: Failed to initialize automounter: No such file or directory
[  370.847666] systemd[1]: Failed to set up automount Arbitrary Executable File Formats File System Automount Point.
[  370.968867] systemd[1]: Unit proc-sys-fs-binfmt_misc.automount entered failed state.
[  371.061612] systemd[1]: Starting Encrypted Volumes.
[  371.187646] systemd[1]: Reached target Encrypted Volumes.
[  371.250516] systemd[1]: Expecting device dev-disk-by\x2duuid-bea3cb0e\x2d50b4\x2d4f9a\x2db255\x2db30866bdf689.device...
[  371.477694] systemd[1]: Expecting device dev-disk-by\x2duuid-0cf86009\x2dcf54\x2d4c05\x2d8a82\x2d3d82b1abaea4.device...
[  371.707683] systemd[1]: Starting Root Slice.
[  371.817642] systemd[1]: Created slice Root Slice.
[  371.872218] systemd[1]: Starting User and Session Slice.
[  372.007651] systemd[1]: Created slice User and Session Slice.
[  372.074669] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[  372.247659] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[  372.329299] systemd[1]: Starting Delayed Shutdown Socket.
[  372.467649] systemd[1]: Listening on Delayed Shutdown Socket.
[  372.534660] systemd[1]: Starting Journal Socket (/dev/log).
[  372.677647] systemd[1]: Listening on Journal Socket (/dev/log).
[  372.746796] systemd[1]: Starting Syslog Socket.
[  372.867639] systemd[1]: Listening on Syslog Socket.
[  372.924277] systemd[1]: Starting udev Control Socket.
[  373.057643] systemd[1]: Listening on udev Control Socket.
[  373.120578] systemd[1]: Starting udev Kernel Socket.
[  373.247643] systemd[1]: Listening on udev Kernel Socket.
[  373.309456] systemd[1]: Starting Journal Socket.
[  373.427682] systemd[1]: Listening on Journal Socket.
[  373.485473] systemd[1]: Starting System Slice.
[  373.607630] systemd[1]: Created slice System Slice.
[  373.664296] systemd[1]: Starting File System Check on Root Device...
[  373.821901] systemd[1]: Starting system-systemd\x2dfsck.slice.
[  373.967634] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[  374.041101] systemd[1]: Starting system-getty.slice.
[  374.102348] systemd[1]: Created slice system-getty.slice.
[  374.166661] systemd[1]: Starting system-serial\x2dgetty.slice.
[  374.237787] systemd[1]: Created slice system-serial\x2dgetty.slice.
[  374.313816] systemd[1]: Mounted Debug File System.
[  374.370960] systemd[1]: Mounting POSIX Message Queue File System...
[  374.563276] systemd[1]: Starting Load Kernel Modules...
[  374.699081] systemd[1]: Started Set Up Additional Binary Formats.
[  374.772024] systemd[1]: Mounting Huge Pages File System...
[  374.843191] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[  374.959263] systemd[1]: Starting udev Coldplug all Devices...
[  375.032858] systemd[1]: Starting Journal Service...
[  375.096015] systemd[1]: Started Journal Service.
[  375.234366] loop: module loaded
[  375.426107] sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
[  375.517931] eth0: HAPPY MEAL (SBUS) 10/100baseT Ethernet 00:03:ba:12:70:5c
[  375.603161] eth1: Quattro HME slot 0 (SBUS) 10/100baseT Ethernet 08:00:20:9d:77:08
[  375.697083] eth2: Quattro HME slot 1 (SBUS) 10/100baseT Ethernet 08:00:20:9d:77:09
[  375.791010] eth3: Quattro HME slot 2 (SBUS) 10/100baseT Ethernet 08:00:20:9d:77:0a
[  375.884476] eth4: Quattro HME slot 3 (SBUS) 10/100baseT Ethernet 08:00:20:9d:77:0b
[  376.995278] systemd-udevd[86]: starting version 215
[  377.724173] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  377.813155] sd 0:0:1:0: Attached scsi generic sg1 type 0
[  377.884506] sd 0:0:2:0: Attached scsi generic sg2 type 0
[  379.330231] Adding 1566328k swap on /dev/sda4.  Priority:-1 extents:1 across:1566328k 
[  380.555602] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[  380.948336] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[  381.051395] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[  381.894633] systemd-journald[70]: Received request to flush runtime journal from PID 1
[  387.067316] eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.

-- 
Meelis Roos (mroos@linux.ee)
