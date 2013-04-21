From: Meelis Roos <mroos@linux.ee>
Subject: sparc ESP SCSI error handling BUG+hang
Date: Sun, 21 Apr 2013 14:02:11 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1304211357540.2145@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I revived my Sun E3000 after its main disk died, reinstalled Debian and 
after long apuse I am testing linux kernels again on it. In general it 
works fine but I left the bad disk connected and sometimes it causes ESP 
SCSI BUG in esp_free_lun_tag. Sometimes it just works.

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.9.0-rc7-00004-gbb33db7 (mroos@mandel) (gcc version 4.6.3 (Debian 4.6.3-15) ) #3 SMP Mon Apr 15 19:05:00 EEST 2013
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:ad:f1:d6
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
[    0.000000] PROM: Built device tree with 69541 bytes of memory.
[    0.000000] Top of RAM: 0xffd16000, Total RAM: 0xff954000
[    0.000000] Memory hole size: 3MB
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0xffd15fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0xff84dfff]
[    0.000000]   node   0: [mem 0xffc00000-0xffceffff]
[    0.000000]   node   0: [mem 0xffd00000-0xffd15fff]
[    0.000000] On node 0 totalpages: 523434
[    0.000000]   Normal zone: 4094 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 523434 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
[    0.000000] CPU CAPS: [vis]
[    0.000000] PERCPU: Embedded 6 pages/cpu @fffff800fd400000 s12800 r8192 d28160 u524288
[    0.000000] pcpu-alloc: s12800 r8192 d28160 u524288 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 6 7 10 11 14 15 - - 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519340
[    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Memory: 4143104k available (3160k kernel code, 992k data, 168k init) [fffff80000000000,00000000ffd16000]
[    0.000000] SLUB: Genslabs=16, HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:255
[    0.000000] clocksource: mult[2042108] shift[23]
[    0.000000] clockevent: mult[3f7ced91] shift[32]
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.9.0-rc7-00004-gbb33db7 (mroos@mandel) (gcc version 4.6.3 (Debian 4.6.3-15) ) #3 SMP Mon Apr 15 19:05:00 EEST 2013
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:ad:f1:d6
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
[    0.000000] PROM: Built device tree with 69541 bytes of memory.
[    0.000000] Top of RAM: 0xffd16000, Total RAM: 0xff954000
[    0.000000] Memory hole size: 3MB
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0xffd15fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0xff84dfff]
[    0.000000]   node   0: [mem 0xffc00000-0xffceffff]
[    0.000000]   node   0: [mem 0xffd00000-0xffd15fff]
[    0.000000] On node 0 totalpages: 523434
[    0.000000]   Normal zone: 4094 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 523434 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
[    0.000000] CPU CAPS: [vis]
[    0.000000] PERCPU: Embedded 6 pages/cpu @fffff800fd400000 s12800 r8192 d28160 u524288
[    0.000000] pcpu-alloc: s12800 r8192 d28160 u524288 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 6 7 10 11 14 15 - - 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519340
[    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Memory: 4143104k available (3160k kernel code, 992k data, 168k init) [fffff80000000000,00000000ffd16000]
[    0.000000] SLUB: Genslabs=16, HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:255
[    0.000000] clocksource: mult[2042108] shift[23]
[    0.000000] clockevent: mult[3f7ced91] shift[32]
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[  131.958555] Calibrating delay using timer specific routine.. 497.16 BogoMIPS (lpj=2485841)
[  131.958631] pid_max: default: 32768 minimum: 301
[  131.959376] Mount-cache hash table entries: 512
[  131.970234] CPU 7: synchronized TICK with master CPU (last diff -3 cycles, maxerr 522 cycles)
[  131.975376] CPU 10: synchronized TICK with master CPU (last diff -1 cycles, maxerr 530 cycles)
[  131.980531] CPU 11: synchronized TICK with master CPU (last diff -3 cycles, maxerr 528 cycles)
[  131.985727] CPU 14: synchronized TICK with master CPU (last diff -2 cycles, maxerr 540 cycles)
[  131.990975] CPU 15: synchronized TICK with master CPU (last diff -2 cycles, maxerr 528 cycles)
[  131.991020] Brought up 6 CPUs
[  131.993791] devtmpfs: initialized
[  131.995438] NET: Registered protocol family 16
[  132.030987] SYSIO: UPA portID ffffffff, at 000001c400000000
[  132.041806] SYSIO: UPA portID ffffffff, at 000001c600000000
[  132.074370] bio: create slab <bio-0> at 0
[  132.077589] SCSI subsystem initialized
[  132.082360] /central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
[  132.084071] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
[  132.084594] fhc: Board #3, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
[  132.085121] fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] 
[  132.085637] fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
[  132.086210] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
[  132.087125] clock_board: Detected 4 slot Enterprise system.
[  132.088116] Switching to clocksource tick
[  132.135145] NET: Registered protocol family 2
[  132.137131] TCP established hash table entries: 32768 (order: 6, 524288 bytes)
[  132.140402] TCP bind hash table entries: 32768 (order: 6, 524288 bytes)
[  132.143494] TCP: Hash tables configured (established 32768 bind 32768)
[  132.144262] TCP: reno registered
[  132.144358] UDP hash table entries: 2048 (order: 3, 65536 bytes)
[  132.144891] UDP-Lite hash table entries: 2048 (order: 3, 65536 bytes)
[  132.146363] NET: Registered protocol family 1
[  132.196725] msgmni has been set to 8092
[  132.199226] io scheduler noop registered
[  132.200041] io scheduler cfq registered (default)
[  132.409054] f005ddbc: ttyS0 at MMIO 0x1fff8902000 (irq = 2) is a zs (ESCC)
[  132.409141] Console: ttyS0 (SunZilog zs0)
[  137.667797] console [ttyS0] enabled
[  137.710387] f005ddbc: ttyS1 at MMIO 0x1fff8902004 (irq = 2) is a zs (ESCC)
[  138.000538] f005de94: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
[  138.076655] f005de94: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
[  138.155155] esp: esp0, regs[1c738810000:1c738800000] irq[19]
[  138.220888] esp: esp0 is a FASHME, 40 MHz (ccf=0), SCSI ID 7
[  141.298371] scsi0 : esp
[  141.329635] mousedev: PS/2 mouse device common for all mice
[  141.396770] scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  141.491795] scsi target0:0:0: Beginning Domain Validation
[  141.508651] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[  141.511966] TCP: cubic registered
[  141.515182] NET: Registered protocol family 10
[  141.517446] NET: Registered protocol family 17
[  141.782371] rtc-m48t59 rtc-m48t59.0: setting system clock to 2013-04-21 10:45:28 UTC (1366541128)
[  141.903372] scsi target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  141.996064] scsi target0:0:0: Domain Validation skipping write tests
[  142.070148] scsi target0:0:0: Ending Domain Validation
[  142.373093] scsi 0:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
[  142.468111] scsi target0:0:2: Beginning Domain Validation
[  142.539170] scsi target0:0:2: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  142.627902] scsi target0:0:2: Domain Validation skipping write tests
[  142.702028] scsi target0:0:2: Ending Domain Validation
[  145.581597] sd 0:0:0:0: [sda] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  145.671726] sd 0:0:0:0: [sda] Write Protect is off
[  145.727568] sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
[  145.790300] sd 0:0:2:0: [sdb] Spinning up disk...
[  145.844883] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  145.959244]  sda: sda1 sda2 sda3 sda4
[  146.009457] sd 0:0:0:0: [sda] Attached SCSI disk
[  146.878278] ....................................................................................................not responding...
[  246.898564] sd 0:0:2:0: [sdb] READ CAPACITY failed
[  246.953884] sd 0:0:2:0: [sdb]  
[  246.991365] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  247.058060] sd 0:0:2:0: [sdb]  
[  247.095552] Sense Key : Not Ready [current] 
[  247.146571] sd 0:0:2:0: [sdb]  
[  247.184115] Add. Sense: Logical unit not ready, cause not reportable
[  247.262440] sd 0:0:2:0: [sdb] Test WP failed, assume Write Enabled
[  247.335136] sd 0:0:2:0: [sdb] Asking for cache data failed
[  247.400034] sd 0:0:2:0: [sdb] Assuming drive cache: write through
[  247.477260] sd 0:0:2:0: [sdb] Spinning up disk...
[  248.537494] ....................................................................................................not responding...
[  348.557762] sd 0:0:2:0: [sdb] READ CAPACITY failed
[  348.613114] sd 0:0:2:0: [sdb]  
[  348.650594] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  348.717297] sd 0:0:2:0: [sdb]  
[  348.754787] Sense Key : Not Ready [current] 
[  348.805800] sd 0:0:2:0: [sdb]  
[  348.843352] Add. Sense: Logical unit not ready, cause not reportable
[  348.921662] sd 0:0:2:0: [sdb] Test WP failed, assume Write Enabled
[  348.994361] sd 0:0:2:0: [sdb] Asking for cache data failed
[  349.059261] sd 0:0:2:0: [sdb] Assuming drive cache: write through
[  349.132168] sd 0:0:2:0: [sdb] Attached SCSI disk
[  349.194254] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[  349.289565] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[  349.456227] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[  349.545994] VFS: Mounted root (ext4 filesystem) readonly on device 259:262144.
[  349.655127] devtmpfs: mounted
INIT: version 2.88 booting
[info] Using makefile-style concurrent boot in runlevel S.
findfs: unable to resolve 'UUID=c18c8172-9a4b-441e-89f3-ea6501e0b61b'
[....] Starting the hotplug events dispatcher: ude[  351.888752] udevd[554]: starting version 175
vd[ ok .
[....] Synthesizing the initial hotplug events...[ ok done.
[...[  352.565179] kernel BUG at drivers/scsi/esp_scsi.c:583!
[  352.625648]               \|/ ____ \|/
[  352.625648]               "@'/ .. \`@"
[  352.625648]               /_| \__/ |_\
[  352.625648]                  \__U_/
[  352.801776] scsi_id(689): Kernel bad sw trap 5 [#1]
[  352.860038] TSTATE: 0000004411e01604 TPC: 00000000006196ac TNPC: 00000000006196b0 Y: 00000000    Not tainted
[  352.977839] TPC: <esp_free_lun_tag+0x6c/0x80>
[  353.029855] g0: 0000000000000005 g1: 0000000000000000 g2: 0000000000010001 g3: 00000000007f4a90
[  353.134072] g4: fffff800fc673900 g5: fffff800fcbc0000 g6: fffff800fb560000 g7: 0000000000000720
[  353.238258] o0: 000000000000002a o1: 00000000007a02c0 o2: 0000000000000247 o3: fffff800fb5635f1
[  353.342444] o4: 0000000000000001 o5: 00000000007a02c0 sp: fffff800ffcd7251 ret_pc: 00000000006196a4
[  353.450804] RPC: <esp_free_lun_tag+0x64/0x80>
[  353.502858] l0: 0000000000001000 l1: 0000000010000000 l2: 00000000004208b0 l3: 0000000000000000
[  353.607072] l4: 0000000000000002 l5: 000000000000000c l6: fffff800fb560000 l7: 0000000011001004
[  353.711259] i0: fffff800fc1e5860 i1: fffff800fc046000 i2: 000000000000000c i3: 0000000000000003
[  353.815449] i4: 6e616c697a650000 i5: 0000000000000030 i6: fffff800ffcd7301 i7: 000000000061a1e0
[  353.919636] I7: <esp_cmd_is_done+0x40/0x140>
[  353.970639] Call Trace:
[  353.999819]  [000000000061a1e0] esp_cmd_is_done+0x40/0x140
[  354.065469]  [000000000061b10c] scsi_esp_intr+0xbcc/0x1bc0
[  354.131112]  [0000000000496bfc] handle_irq_event_percpu+0x5c/0x1a0
[  354.205078]  [0000000000496d7c] handle_irq_event+0x3c/0x80
[  354.270720]  [0000000000499f90] handle_fasteoi_irq+0x90/0x180
[  354.339478]  [0000000000496330] generic_handle_irq+0x30/0x40
[  354.407209]  [000000000042b0ac] handler_irq+0xac/0x100
[  354.468671]  [00000000004208b4] tl0_irq5+0x14/0x20
[  354.525949] Disabling lock debugging due to kernel taint
[  354.589523] Caller[000000000061a1e0]: esp_cmd_is_done+0x40/0x140
[  354.661410] Caller[000000000061b10c]: scsi_esp_intr+0xbcc/0x1bc0
[  354.733298] Caller[0000000000496bfc]: handle_irq_event_percpu+0x5c/0x1a0
[  354.813520] Caller[0000000000496d7c]: handle_irq_event+0x3c/0x80
[  354.885416] Caller[0000000000499f90]: handle_fasteoi_irq+0x90/0x180
[  354.960418] Caller[0000000000496330]: generic_handle_irq+0x30/0x40
[  355.034392] Caller[000000000042b0ac]: handler_irq+0xac/0x100
[  355.102108] Caller[00000000004208b4]: tl0_irq5+0x14/0x20
[  355.165657] Caller[00000000f7bdfbf4]: 0xf7bdfbf4
[  355.220866] Instruction DUMP: 92102247  7ff83a4f  901222c0 <91d02005> 92102243  7ff83a4b  901222c0  91d02005  9de3bf50 
[  355.350042] Kernel panic - not syncing: Aiee, killing interrupt handler!
[  355.430295] Press Stop-A (L1-A) to return to the boot prom
.] Waiting for /dev to be fully populated...


-- 
Meelis Roos (mroos@linux.ee)
