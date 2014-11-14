From: Meelis Roos <mroos@linux.ee>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Fri, 14 Nov 2014 21:35:07 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1411142114200.26813@adalberg.ut.ee>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee> <20141114165804.GA14631@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:50586 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161286AbaKNTfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 14:35:11 -0500
In-Reply-To: <20141114165804.GA14631@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

> Paul, what's the best way to figure out these CPU stalls?
> 
> The second oops is in blk_mq_map_queue() which is a trivial
> two level cpu lookup.  I wonder if there's something odd about
> cpu numbers on these big old sparc systems?

CPU numbers are sparse - they are determined by hardware slot number and 
some models only fill every other mainboard slot, and first slots can be 
free. I have first board offline and currently have CPUs numbered 
10,11,14,15 online.
 
Here is debug with Jens's patch:

screen not found.
Can't open input device.
Keyboard not present.  Using ttya for input and output.

4-slot Sun Enterprise 3000, No Keyboard
OpenBoot 3.2.29, 4096 MB memory installed, Serial #51540060.
Copyright 2001 Sun Microsystems, Inc.  All rights reserved
Ethernet address 0:3:ba:12:70:5c, Host ID: 8312705c.



Rebooting with command: boot
Boot device: disk  File and args: 
SILO Version 1.4.14
boot: 
Allocated 64 Megs of memory at 0x40000000 for kernel
\Uncompressing image...
|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\
 |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-
 \|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|Loaded kernel version 3.18.0

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.18.0-rc4-00052-g04689e7-dirty (mroos@mandel) (gcc version 4.9.2 (Debian 4.9.2-1) ) #26 SMP Fri Nov 14 21:22:28 EET 2014
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
[    0.000000] PROM: Built device tree with 92727 bytes of memory.
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
[    0.000000] PERCPU: Embedded 7 pages/cpu @fffff800ff400000 s13248 r8192 d35904 u1048576
[    0.000000] pcpu-alloc: s13248 r8192 d35904 u1048576 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 10 11 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519340
[    0.000000] Kernel command line: root=/dev/sda2 ro ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 4142488K/4187472K available (3653K kernel code, 246K rwdata, 800K rodata, 184K init, 413K bss, 44984K reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[  133.553714] clocksource: mult[2042108] shift[23]
[  133.608322] clockevent: mult[3f7ced91] shift[32]
[  133.663820] Console: colour dummy device 80x25
[  133.716752] console [tty0] enabled
[  133.757332] bootconsole [earlyprom0] disabled
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.18.0-rc4-00052-g04689e7-dirty (mroos@mandel) (gcc version 4.9.2 (Debian 4.9.2-1) ) #26 SMP Fri Nov 14 21:22:28 EET 2014
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
[    0.000000] PROM: Built device tree with 92727 bytes of memory.
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
[    0.000000] PERCPU: Embedded 7 pages/cpu @fffff800ff400000 s13248 r8192 d35904 u1048576
[    0.000000] pcpu-alloc: s13248 r8192 d35904 u1048576 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 10 11 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519340
[    0.000000] Kernel command line: root=/dev/sda2 ro ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 4142488K/4187472K available (3653K kernel code, 246K rwdata, 800K rodata, 184K init, 413K bss, 44984K reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[  133.553714] clocksource: mult[2042108] shift[23]
[  133.608322] clockevent: mult[3f7ced91] shift[32]
[  133.663820] Console: colour dummy device 80x25
[  133.716752] console [tty0] enabled
[  133.757332] bootconsole [earlyprom0] disabled
[  133.959600] Calibrating delay using timer specific routine.. 497.44 BogoMIPS (lpj=2487228)
[  133.959672] pid_max: default: 32768 minimum: 301
[  133.960109] Mount-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  133.960172] Mountpoint-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  133.971050] CPU 11: synchronized TICK with master CPU (last diff -1 cycles, maxerr 516 cycles)
[  133.975491] CPU 14: synchronized TICK with master CPU (last diff -3 cycles, maxerr 531 cycles)
[  133.979943] CPU 15: synchronized TICK with master CPU (last diff -3 cycles, maxerr 531 cycles)
[  133.980146] Brought up 4 CPUs
[  133.982246] devtmpfs: initialized
[  134.055642] device-tree: Duplicate name in base, renamed to "fhc#1"
[  134.058336] device-tree: Duplicate name in base, renamed to "fhc#2"
[  134.060857] device-tree: Duplicate name in base, renamed to "counter-timer#1"
[  134.062360] NET: Registered protocol family 16
[  134.079082] SYSIO: UPA portID ffffffff, at 000001c400000000
[  134.089731] SYSIO: UPA portID ffffffff, at 000001c600000000
[  134.144239] SCSI subsystem initialized
[  134.147262] /central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
[  134.148285] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
[  134.148648] fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
[  134.148987] fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
[  134.149333] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
[  134.149825] clock_board: Detected 4 slot Enterprise system.
[  134.150613] Switched to clocksource tick
[  134.176770] NET: Registered protocol family 2
[  134.179169] TCP established hash table entries: 32768 (order: 5, 262144 bytes)
[  134.180949] TCP bind hash table entries: 32768 (order: 6, 524288 bytes)
[  134.184045] TCP: Hash tables configured (established 32768 bind 32768)
[  134.184824] TCP: reno registered
[  134.184910] UDP hash table entries: 2048 (order: 3, 65536 bytes)
[  134.185446] UDP-Lite hash table entries: 2048 (order: 3, 65536 bytes)
[  134.186828] NET: Registered protocol family 1
[  134.191719] futex hash table entries: 1024 (order: 3, 65536 bytes)
[  134.192341] audit: initializing netlink subsys (disabled)
[  134.192704] audit: type=2000 audit(0.409:1): initialized
[  134.194109] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[  134.232599] msgmni has been set to 8090
[  134.235554] io scheduler noop registered
[  134.236738] io scheduler cfq registered (default)
[  134.445702] zs f005ddbc: ttyS0 at MMIO 0x1fff8902000 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  134.445807] Console: ttyS0 (SunZilog zs0)
[  140.474391] console [ttyS0] enabled
[  140.517028] zs f005ddbc: ttyS1 at MMIO 0x1fff8902004 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  140.831526] f005de94: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
[  140.907727] f005de94: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
[  140.985352] esp: esp0, regs[1c738810000:1c738800000] irq[19]
[  141.051123] esp: esp0 is a FASHME, 40 MHz (ccf=0), SCSI ID 7
[  144.120661] scsi host0: esp
[  144.153625] cpumap 0 -> 0
[  144.155824] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[  144.156895] TCP: cubic registered
[  144.159012] NET: Registered protocol family 10
[  144.161613] NET: Registered protocol family 17
[  144.183269] rtc-m48t59 rtc-m48t59.0: setting system clock to 2014-11-14 19:32:50 UTC (1415993570)
[  144.515654] cpumap 1 -> 0
[  144.515661] cpumap 2 -> 0
[  144.515668] cpumap 3 -> 0
[  144.578311] scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  144.578399] scsi target0:0:0: Beginning Domain Validation
[  144.781389] scsi target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  144.874152] scsi target0:0:0: Domain Validation skipping write tests
[  144.948317] scsi target0:0:0: Ending Domain Validation
[  145.009775] cpumap 0 -> 0
[  145.040968] cpumap 1 -> 0
[  145.072219] cpumap 2 -> 0
[  145.103471] cpumap 3 -> 0
[  145.139419] cpumap 0 -> 0
[  145.168745] cpumap 1 -> 0
[  145.199961] cpumap 2 -> 0
[  145.231239] cpumap 3 -> 0
[  145.266910] scsi 0:0:1:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  145.361859] scsi target0:0:1: Beginning Domain Validation
[  145.442413] scsi target0:0:1: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  145.535183] scsi target0:0:1: Domain Validation skipping write tests
[  145.609277] scsi target0:0:1: Ending Domain Validation
[  145.670737] cpumap 0 -> 0
[  145.701937] cpumap 1 -> 0
[  145.733179] cpumap 2 -> 0
[  145.764438] cpumap 3 -> 0
[  145.800352] cpumap 0 -> 0
[  145.829580] cpumap 1 -> 0
[  145.860840] cpumap 2 -> 0
[  145.892057] cpumap 3 -> 0
[  145.925446] scsi 0:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
[  146.020469] scsi target0:0:2: Beginning Domain Validation
[  146.089203] scsi target0:0:2: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  146.177232] scsi target0:0:2: Domain Validation skipping write tests
[  146.251884] scsi target0:0:2: Ending Domain Validation
[  146.316577] cpumap 0 -> 0
[  146.345795] cpumap 1 -> 0
[  146.377040] cpumap 2 -> 0
[  146.408293] cpumap 3 -> 0
[  146.673873] cpumap 0 -> 0
[  146.703213] cpumap 1 -> 0
[  146.734403] cpumap 2 -> 0
[  146.765655] cpumap 3 -> 0
[  147.031177] cpumap 0 -> 0
[  147.060473] cpumap 1 -> 0
[  147.091691] cpumap 2 -> 0
[  147.122912] cpumap 3 -> 0
[  147.388455] cpumap 0 -> 0
[  147.417784] cpumap 1 -> 0
[  147.449042] cpumap 2 -> 0
[  147.480263] cpumap 3 -> 0
[  147.745790] cpumap 0 -> 0
[  147.775043] cpumap 1 -> 0
[  147.806290] cpumap 2 -> 0
[  147.837513] cpumap 3 -> 0
[  148.103042] cpumap 0 -> 0
[  148.132294] cpumap 1 -> 0
[  148.163545] cpumap 2 -> 0
[  148.194764] cpumap 3 -> 0
[  148.460272] cpumap 0 -> 0
[  148.489543] cpumap 1 -> 0
[  148.520811] cpumap 2 -> 0
[  148.552023] cpumap 3 -> 0
[  148.817566] cpumap 0 -> 0
[  148.846902] cpumap 1 -> 0
[  148.878149] cpumap 2 -> 0
[  148.909376] cpumap 3 -> 0
[  149.174889] cpumap 0 -> 0
[  149.204155] cpumap 1 -> 0
[  149.235405] cpumap 2 -> 0
[  149.266626] cpumap 3 -> 0
[  149.532161] cpumap 0 -> 0
[  149.561399] cpumap 1 -> 0
[  149.592655] cpumap 2 -> 0
[  149.623879] cpumap 3 -> 0
[  149.889390] cpumap 0 -> 0
[  149.918654] cpumap 1 -> 0
[  149.949909] cpumap 2 -> 0
[  149.981142] cpumap 3 -> 0
[  150.246664] cpumap 0 -> 0
[  150.275908] cpumap 1 -> 0
[  150.307160] cpumap 2 -> 0
[  150.338381] cpumap 3 -> 0
[  150.607451] sd 0:0:0:0: [sda] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  150.697659] sd 0:0:0:0: [sda] Write Protect is off
[  150.753382] sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
[  150.815185] sd 0:0:1:0: [sdb] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  150.905748] sd 0:0:2:0: [sdc] Spinning up disk...
[  150.960893] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  150.961063] sd 0:0:1:0: [sdb] Write Protect is off
[  150.961090] sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
[  151.121334] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  151.294739]  sdb: unknown partition table
[  151.342046]  sda: sda1 sda2 sda3 sda4
[  151.384597] Unable to handle kernel paging request at virtual address fffff8027fd26000
[  151.479529] tsk->{mm,active_mm}->context = 0000000000000000
[  151.546016] tsk->{mm,active_mm}->pgd = fffff80000402000
[  151.608509]               \|/ ____ \|/
[  151.608509]               "@'/ .. \`@"
[  151.608509]               /_| \__/ |_\
[  151.608509]                  \__U_/
[  151.784621] kworker/u8:3(47): Oops [#1]
[  151.830451] CPU: 10 PID: 47 Comm: kworker/u8:3 Not tainted 3.18.0-rc4-00052-g04689e7-dirty #26
[  151.933636] Workqueue: events_unbound async_run_entry_fn[  151.970501] .

[  152.015747] task: fffff800fe7b0600 ti: fffff800fe7dc000 task.ti: fffff800fe7dc000
[  152.105552] TSTATE: 0000004480001603 TPC: 00000000005f1cf8 TNPC: 00000000005f355c Y: 00000000    Not tainted
[  152.223273] TPC: <blk_mq_map_queue+0x18/0x20>
[  152.275378] g0: 0000000000000000 g1: 0000000181d19000 g2: fffff800fe00e880 g3: 000000000088ee30
[  152.379472] g4: fffff800fe7b0600 g5: fffff800feb30000 g6: fffff800fe7dc000 g7: 0000000000000000
[  152.483723] o0: fffff800fe7e0d20 o1: 0000000000000028 o2: fffff800fe7e1350 o3: fffff800fe7df690
[  152.587912] o4: fffff800fe7e1338 o5: 0000000000000000 sp: fffff800fe7deea1 ret_pc: 00000000005f3554
[  152.696267] sd 0:0:0:0: [sda] Attached SCSI disk
[  152.751370] RPC: <blk_mq_alloc_request+0x54/0x120>
[  152.808689] l0: 00000000008d4ec0 l1: 000000000089b800 l2: 0000000000000001 l3: 0000000000000000
[  152.912852] l4: 0000000000000000 l5: 0000000000000000 l6: fffff800fe7df758 l7: 0000060001fa0aa0
[  153.017063] i0: fffff800fe7e0d20 i1: 0000000000000000 i2: 0000000000000010 i3: 0000000000000000
[  153.121224] i4: 00000000008d40c0 i5: fffff800ff408940 i6: fffff800fe7def71 i7: 000000000066c244
[  153.225431] I7: <scsi_execute+0x24/0x140>
[  153.273315] Call Trace:
[  153.302472]  [000000000066c244] scsi_execute+0x24/0x140
[  153.364995]  [000000000066c47c] scsi_execute_req_flags+0x5c/0xe0
[  153.436887]  [0000000000680f88] read_capacity_10+0x88/0x260
[  153.503557]  [00000000006824a4] sd_revalidate_disk+0xc44/0x1ea0
[  153.574430]  [00000000006838c8] sd_probe_async+0xc8/0x160
[  153.639012]  [000000000046fc94] async_run_entry_fn+0x34/0x100
[  153.707783]  [000000000046827c] process_one_work+0x15c/0x340
[  153.775486]  [0000000000468bf0] worker_thread+0x110/0x520
[  153.840279] .
[  153.840280]  [000000000046d528] kthread+0xa8/0xe0
[  153.915162]  [00000000004060c4] ret_from_fork+0x1c/0x2c
[  153.977768]  [0000000000000000]           (null)
[  154.032819] Disabling lock debugging due to kernel taint
[  154.096465] Caller[000000000066c244]: scsi_execute+0x24/0x140
[  154.165310] Caller[000000000066c47c]: scsi_execute_req_flags+0x5c/0xe0
[  154.243301] Caller[0000000000680f88]: read_capacity_10+0x88/0x260
[  154.316264] Caller[00000000006824a4]: sd_revalidate_disk+0xc44/0x1ea0
[  154.393343] Caller[00000000006838c8]: sd_probe_async+0xc8/0x160
[  154.464168] Caller[000000000046fc94]: async_run_entry_fn+0x34/0x100
[  154.539170] Caller[000000000046827c]: process_one_work+0x15c/0x340
[  154.613136] Caller[0000000000468bf0]: worker_thread+0x110/0x520
[  154.684012] Caller[000000000046d528]: kthread+0xa8/0xe0
[  154.746495] Caller[00000000004060c4]: ret_from_fork+0x1c/0x2c
[  154.815237] Caller[0000000000000000]:           (null)
[  154.876702] Instruction DUMP: c2004009  83287003  81c3e008 <d0588001> 01000000  9de3bf20  c201a038  b607a7ef  b4062630 
[  155.005855] note: kworker/u8:3[47] exited with preempt_count 1
[  155.075807] Unable to handle kernel paging request at virtual address ffffffffffffe000
[  155.170494] tsk->{mm,active_mm}->context = 0000000000000000
[  155.237136] tsk->{mm,active_mm}->pgd = fffff80000402000
[  155.299651]               \|/ ____ \|/
[  155.299651]               "@'/ .. \`@"
[  155.299651]               /_| \__/ |_\
[  155.299651]                  \__U_/
[  155.475822] .
[  155.475823] kworker/u8:3(47): Oops [#2]
[  155.540327] CPU: 10 PID: 47 Comm: kworker/u8:3 Tainted: G      D        3.18.0-rc4-00052-g04689e7-dirty #26
[  155.657078] task: fffff800fe7b0600 ti: fffff800fe7dc000 task.ti: fffff800fe7dc000
[  155.746648] TSTATE: 0000000011e01602 TPC: 000000000046db08 TNPC: 000000000046908c Y: fcf8b5ad    Tainted: G      D       
[  155.877941] TPC: <kthread_data+0x8/0x20>
[  155.924766] g0: 00000000008e0910 g1: 0000000000000000 g2: 00000000a1dc8b80 g3: ffffffffff76abc0
[  156.028986] g4: fffff800fe7b0600 g5: fffff800feb30000 g6: fffff800fe7dc000 g7: ffffffffff76abc0
[  156.133174] o0: fffff800fe7b0600 o1: fffff800fe7b0600 o2: 0000000000000001 o3: fffff800ff402840
[  156.237363] o4: fffff800fe7b0690 o5: fffff800ff402840 sp: fffff800fe7de8c1 ret_pc: 0000000000469084
[  156.345733] RPC: <wq_worker_sleeping+0x4/0xe0>
[  156.398811] l0: 0000000000000000 l1: 00000000005300ab l2: 0000000000000000 l3: 0000000000000000
[  156.503034] l4: 00000000005200ab l5: 000000000000002f l6: 0000000000000006 l7: 0000000000000004
[  156.607217] i0: fffff800fe7b0600 i1: 000000000000000a i2: 0000000000000001 i3: 0000000000000000
[  156.711405] i4: fffffffffffffefe i5: 0000000000000002 i6: fffff800fe7de971 i7: 0000000000791914
[  156.815611] I7: <switch_to_pc+0x198/0x3a4>
[  156.864512] Call Trace:
[  156.893692]  [0000000000791914] switch_to_pc+0x198/0x3a4
[  156.957287]  [0000000000454bd4] do_exit+0x5f4/0x9e0
[  157.015601]  [0000000000428744] die_if_kernel+0x184/0x300
[  157.080198]  [00000000007901d4] unhandled_fault+0x84/0x90
[  157.144793]  [0000000000444298] do_sparc64_fault+0x498/0x6e0
[  157.212519]  [0000000000407bcc] sparc64_realfault_common+0x10/0x20
[  157.286495]  [00000000005f1cf8] blk_mq_map_queue+0x18/0x20
[  157.352127]  [000000000066c244] scsi_execute+0x24/0x140
[  157.414635]  [000000000066c47c] scsi_execute_req_flags+0x5c/0xe0
[  157.486521]  [0000000000680f88] read_capacity_10+0x88/0x260
[  157.553200]  [00000000006824a4] sd_revalidate_disk+0xc44/0x1ea0
[  157.624042]  [00000000006838c8] sd_probe_async+0xc8/0x160
[  157.688648]  [000000000046fc94] async_run_entry_fn+0x34/0x100
[  157.757414]  [000000000046827c] process_one_work+0x15c/0x340
[  157.825131]  [0000000000468bf0] worker_thread+0x110/0x520
[  157.889717]  [000000000046d528] kthread+0xa8/0xe0
[  157.945979] Caller[0000000000791914]: switch_to_pc+0x198/0x3a4
[  158.015790] Caller[0000000000454bd4]: do_exit+0x5f4/0x9e0
[  158.080374] Caller[0000000000428744]: die_if_kernel+0x184/0x300
[  158.151225] Caller[00000000007901d4]: unhandled_fault+0x84/0x90
[  158.222075] Caller[0000000000444298]: do_sparc64_fault+0x498/0x6e0
[  158.296046] Caller[0000000000407bcc]: sparc64_realfault_common+0x10/0x20
[  158.376270] Caller[00000000005f3554]: blk_mq_alloc_request+0x54/0x120
[  158.453366] Caller[000000000066c244]: scsi_execute+0x24/0x140
[  158.522124] Caller[000000000066c47c]: scsi_execute_req_flags+0x5c/0xe0
[  158.600268] Caller[0000000000680f88]: read_capacity_10+0x88/0x260
[  158.673196] Caller[00000000006824a4]: sd_revalidate_disk+0xc44/0x1ea0
[  158.750289] Caller[00000000006838c8]: sd_probe_async+0xc8/0x160
[  158.821142] Caller[000000000046fc94]: async_run_entry_fn+0x34/0x100
[  158.896162] Caller[000000000046827c]: process_one_work+0x15c/0x340
[  158.970135] Caller[0000000000468bf0]: worker_thread+0x110/0x520
[  159.040969] Caller[000000000046d528]: kthread+0xa8/0xe0
[  159.103483] Caller[00000000004060c4]: ret_from_fork+0x1c/0x2c
[  159.172227] Caller[0000000000000000]:           (null)
[  159.233688] Instruction DUMP: 01000000  c25a2358  81c3e008 <d0587fd8> 30680005  01000000  01000000  01000000  01000000 
[  159.362867] Fixing recursive fault but reboot is needed!
[  159.426448] BUG: scheduling while atomic: kworker/u8:3/47/0x00000005
[  159.502490] Modules linked in:
[  159.538956] CPU: 10 PID: 47 Comm: kworker/u8:3 Tainted: G      D        3.18.0-rc4-00052-g04689e7-dirty #26
[  159.655704] Call Trace:
[  159.684829]  [0000000000471780] __schedule_bug+0x40/0x60
[  159.748388]  [0000000000791a1c] switch_to_pc+0x2a0/0x3a4
[  159.811944]  [0000000000454dc4] do_exit+0x7e4/0x9e0
[  159.870278]  [0000000000428744] die_if_kernel+0x184/0x300
[  159.934880]  [00000000007901d4] unhandled_fault+0x84/0x90
[  159.999474]  [0000000000444298] do_sparc64_fault+0x498/0x6e0
[  160.067193]  [0000000000407bcc] sparc64_realfault_common+0x10/0x20
[  160.141167]  [000000000046db08] kthread_data+0x8/0x20
[  160.201591]  [0000000000791914] switch_to_pc+0x198/0x3a4
[  160.265150]  [0000000000454bd4] do_exit+0x5f4/0x9e0
[  160.323485]  [0000000000428744] die_if_kernel+0x184/0x300
[  160.388088]  [00000000007901d4] unhandled_fault+0x84/0x90
[  160.452681]  [0000000000444298] do_sparc64_fault+0x498/0x6e0
[  160.520397]  [0000000000407bcc] sparc64_realfault_common+0x10/0x20
[  160.594378]  [00000000005f1cf8] blk_mq_map_queue+0x18/0x20
[  160.660012]  [000000000066c244] scsi_execute+0x24/0x140


-- 
Meelis Roos (mroos@linux.ee)
