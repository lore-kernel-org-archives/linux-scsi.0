From: Meelis Roos <mroos@linux.ee>
Subject: Sparc ESP problem with blk-mq
Date: Tue, 14 Oct 2014 01:07:15 +0300 (EEST)
Message-ID: <alpine.LRH.2.11.1410140102230.18488@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: linux-scsi@cger.kernel.org, sparclinux@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

I turned on blk-mq for all my test machines today and got a failure from 
Sun Ultra 1 with Sparc ESP SCSI (dmesg below). Booting with 
scsi_mod.use_blk_mq=0 fixes the problem. The problem is reproducible.


[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.35.0 2004/04/19 12:15'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-07613-gca32188-dirty (mroos@melon) (gcc version 4.9.1 (Debian 4.9.1-16) ) #56 Mon Oct 13 19:17:41 EEST 2014
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:9f:6b:e4
[    0.000000] MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
[    0.000000] MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
[    0.000000] MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /sbus@1f,0/zs@f,1100000:a
[    0.000000] PROM: Built device tree with 52656 bytes of memory.
[    0.000000] Top of RAM: 0x33f50000, Total RAM: 0x33f3e000
[    0.000000] Memory hole size: 0MB
[    0.000000] Allocated 16384 bytes for kernel page tables.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0x33f4ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0x33efdfff]
[    0.000000]   node   0: [mem 0x33f00000-0x33f2bfff]
[    0.000000]   node   0: [mem 0x33f3c000-0x33f4ffff]
[    0.000000] On node 0 totalpages: 106399
[    0.000000]   Normal zone: 832 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 106399 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
[    0.000000] CPU CAPS: [vis]
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 105567
[    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 836032K/851192K available (3453K kernel code, 260K rwdata, 824K rodata, 152K init, 399K bss, 15160K reserved)
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[   57.524698] clocksource: mult[6fe6b32] shift[24]
[   57.579457] clockevent: mult[249a8de9] shift[32]
[   57.635375] Console: colour dummy device 80x25
[   57.687876] console [tty0] enabled
[   57.728458] bootconsole [earlyprom0] disabled
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.35.0 2004/04/19 12:15'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-07613-gca32188-dirty (mroos@melon) (gcc version 4.9.1 (Debian 4.9.1-16) ) #56 Mon Oct 13 19:17:41 EEST 2014
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:9f:6b:e4
[    0.000000] MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
[    0.000000] MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
[    0.000000] MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /sbus@1f,0/zs@f,1100000:a
[    0.000000] PROM: Built device tree with 52656 bytes of memory.
[    0.000000] Top of RAM: 0x33f50000, Total RAM: 0x33f3e000
[    0.000000] Memory hole size: 0MB
[    0.000000] Allocated 16384 bytes for kernel page tables.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0x33f4ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0x33efdfff]
[    0.000000]   node   0: [mem 0x33f00000-0x33f2bfff]
[    0.000000]   node   0: [mem 0x33f3c000-0x33f4ffff]
[    0.000000] On node 0 totalpages: 106399
[    0.000000]   Normal zone: 832 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 106399 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
[    0.000000] CPU CAPS: [vis]
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 105567
[    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 524288 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 836032K/851192K available (3453K kernel code, 260K rwdata, 824K rodata, 152K init, 399K bss, 15160K reserved)
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[   57.524698] clocksource: mult[6fe6b32] shift[24]
[   57.579457] clockevent: mult[249a8de9] shift[32]
[   57.635375] Console: colour dummy device 80x25
[   57.687876] console [tty0] enabled
[   57.728458] bootconsole [earlyprom0] disabled
[   57.930716] Calibrating delay using timer specific routine.. 286.82 BogoMIPS (lpj=1434111)
[   57.930833] pid_max: default: 32768 minimum: 301
[   57.931505] Mount-cache hash table entries: 2048 (order: 1, 16384 bytes)
[   57.931607] Mountpoint-cache hash table entries: 2048 (order: 1, 16384 bytes)
[   57.934712] Initializing cgroup subsys net_cls
[   57.934835] Initializing cgroup subsys blkio
[   57.939070] devtmpfs: initialized
[   57.950915] NET: Registered protocol family 16
[   57.966431] SYSIO: UPA portID ffffffff, at 000001fe00000000
[   57.997222] SCSI subsystem initialized
[   58.001006] /sbus@1f,0/eeprom@f,1200000: Mostek regs at 0x1fff1200000
[   58.002807] AUXIO: Found device at /sbus@1f,0/auxio@f,1900000
[   58.003132] Switched to clocksource tick
[   58.034939] NET: Registered protocol family 2
[   58.037991] TCP established hash table entries: 8192 (order: 3, 65536 bytes)
[   58.038520] TCP bind hash table entries: 8192 (order: 3, 65536 bytes)
[   58.039006] TCP: Hash tables configured (established 8192 bind 8192)
[   58.039635] TCP: reno registered
[   58.039743] UDP hash table entries: 512 (order: 1, 16384 bytes)
[   58.039934] UDP-Lite hash table entries: 512 (order: 1, 16384 bytes)
[   58.040912] NET: Registered protocol family 1
[   58.045390] futex hash table entries: 256 (order: -1, 6144 bytes)
[   58.047786] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[   58.052426] msgmni has been set to 1632
[   58.056218] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[   58.056410] io scheduler noop registered
[   58.056536] io scheduler deadline registered
[   58.056799] io scheduler cfq registered (default)
[   58.059858] zs f005a290: ttyS0 at MMIO 0x1fff1100000 (irq = 9, base_baud = 307200) is a zs
[   58.060010] Console: ttyS0 (SunZilog zs0)
[   62.880751] console [ttyS0] enabled
[   62.922660] [sched_delayed] sched: RT throttling activated
[   62.988320] zs f005a290: ttyS1 at MMIO 0x1fff1100004 (irq = 9, base_baud = 307200) is a zs
[   63.088878] f005b730: Keyboard at MMIO 0x1fff1000000 (irq = 9) is a zs
[   63.165231] f005b730: Mouse at MMIO 0x1fff1000004 (irq = 9) is a zs
[   63.244199] esp: esp0, regs[1ffe8800000:1ffe8400000] irq[10]
[   63.310055] esp: esp0 is a FAS100A, 40 MHz (ccf=0), SCSI ID 7
[   66.383895] scsi host0: esp
[  148.437533] scsi 0:0:0:0: timing out command, waited 82s
[  149.674112] ESP: unexpected IREG 40
[  149.713889] esp: esp0: Dumping command log
[  149.762847] esp: esp0: ent[14] CMD val[01] sreg[93] seqreg[04] sreg2[00] ireg[18] ss[00] event[0d]
[  149.870182] esp: esp0: ent[15] CMD val[11] sreg[93] seqreg[04] sreg2[00] ireg[18] ss[00] event[0d]
[  149.977486] esp: esp0: ent[16] EVENT val[0b] sreg[93] seqreg[04] sreg2[00] ireg[18] ss[00] event[0d]
[  150.086871] esp: esp0: ent[17] CMD val[12] sreg[97] seqreg[04] sreg2[00] ireg[08] ss[00] event[0b]
[  150.194174] esp: esp0: ent[18] EVENT val[0c] sreg[97] seqreg[04] sreg2[00] ireg[08] ss[00] event[0b]
[  150.303555] esp: esp0: ent[19] CMD val[44] sreg[90] seqreg[04] sreg2[00] ireg[20] ss[00] event[0c]
[  150.410858] esp: esp0: ent[20] CMD val[c6] sreg[90] seqreg[04] sreg2[00] ireg[20] ss[01] event[0c]
[  150.518165] esp: esp0: ent[21] CMD val[44] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[00] event[0c]
[  150.625463] esp: esp0: ent[22] CMD val[c6] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[01] event[0c]
[  150.732768] esp: esp0: ent[23] CMD val[44] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[00] event[0c]
[  150.840072] esp: esp0: ent[24] CMD val[c6] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[01] event[0c]
[  150.947372] esp: esp0: ent[25] CMD val[44] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[00] event[0c]
[  151.054677] esp: esp0: ent[26] CMD val[c6] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[01] event[0c]
[  151.161975] esp: esp0: ent[27] CMD val[44] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[00] event[0c]
[  151.269279] esp: esp0: ent[28] CMD val[c6] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[01] event[0c]
[  151.376586] esp: esp0: ent[29] CMD val[44] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[00] event[0c]
[  151.483884] esp: esp0: ent[30] CMD val[c6] sreg[80] seqreg[00] sreg2[00] ireg[20] ss[01] event[0c]
[  151.591191] esp: esp0: ent[31] EVENT val[0d] sreg[87] seqreg[02] sreg2[00] ireg[18] ss[00] event[0c]
[  151.700572] esp: esp0: ent[0] EVENT val[06] sreg[87] seqreg[02] sreg2[00] ireg[18] ss[00] event[0d]
[  151.808918] esp: esp0: ent[1] CMD val[01] sreg[87] seqreg[02] sreg2[00] ireg[18] ss[00] event[06]
[  151.915180] esp: esp0: ent[2] CMD val[10] sreg[87] seqreg[02] sreg2[00] ireg[18] ss[00] event[06]
[  152.021438] esp: esp0: ent[3] CMD val[1a] sreg[87] seqreg[02] sreg2[00] ireg[08] ss[00] event[06]
[  152.127700] esp: esp0: ent[4] CMD val[12] sreg[87] seqreg[02] sreg2[00] ireg[08] ss[00] event[06]
[  152.233958] esp: esp0: ent[5] EVENT val[0d] sreg[87] seqreg[02] sreg2[00] ireg[08] ss[00] event[06]
[  152.342305] esp: esp0: ent[6] EVENT val[09] sreg[86] seqreg[02] sreg2[00] ireg[10] ss[00] event[0d]
[  152.450651] esp: esp0: ent[7] CMD val[01] sreg[86] seqreg[02] sreg2[00] ireg[10] ss[00] event[09]
[  152.556907] esp: esp0: ent[8] CMD val[10] sreg[86] seqreg[02] sreg2[00] ireg[10] ss[00] event[09]
[  152.663169] esp: esp0: ent[9] EVENT val[0a] sreg[86] seqreg[02] sreg2[00] ireg[10] ss[00] event[09]
[  152.771518] esp: esp0: ent[10] EVENT val[0d] sreg[80] seqreg[02] sreg2[00] ireg[20] ss[00] event[0a]
[  152.880898] esp: esp0: ent[11] EVENT val[04] sreg[80] seqreg[02] sreg2[00] ireg[20] ss[00] event[0d]
[  152.990289] esp: esp0: ent[12] CMD val[90] sreg[80] seqreg[02] sreg2[00] ireg[20] ss[00] event[04]
[  153.097589] esp: esp0: ent[13] EVENT val[05] sreg[80] seqreg[02] sreg2[00] ireg[20] ss[00] event[04]
[  153.209036] esp: esp1, regs[1ff08810000:1ff08800000] irq[14]
[  153.274954] esp: esp1 is a FASHME, 40 MHz (ccf=0), SCSI ID 7
[  156.347855] scsi host1: esp
[  159.895509] mousedev: PS/2 mouse device common for all mice
[  159.963193] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[  160.043367] TCP: cubic registered
[  160.081194] NET: Registered protocol family 17
[  160.134524] Key type dns_resolver registered
[  160.194533] rtc-m48t59 rtc-m48t59.0: setting system clock to 2014-10-13 21:40:47 UTC (1413236447)
[  160.958857] input: Sun Mouse as /devices/root/f0059940/f005b730/serio1/input/input1
[  161.050132] VFS: Cannot open root device "sda2" or unknown-block(0,0): error -6
[  161.136193] Please append a correct "root=" boot option; here are the available partitions:
[  161.236197] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[  161.335119] CPU: 0 PID: 1 Comm: swapper Not tainted 3.17.0-07613-gca32188-dirty #56
[  161.426769] Call Trace:
[  161.455930]  [000000000087ce48] mount_block_root+0x1f8/0x284
[  161.523644]  [000000000087d0a8] prepare_namespace+0x170/0x1b0
[  161.592402]  [000000000087cb20] kernel_init_freeable+0x1a8/0x1b8
[  161.664296]  [000000000075c264] kernel_init+0x4/0x100
[  161.724712]  [0000000000405f84] ret_from_fork+0x1c/0x2c
[  161.787191]  [0000000000000000]           (null)
[  161.842406] Press Stop-A (L1-A) to return to the boot prom
[  161.908038] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)


-- 
Meelis Roos (mroos@linux.ee)
