From: Meelis Roos <mroos@linux.ee>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Sat, 15 Nov 2014 00:59:01 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1411150033400.26813@adalberg.ut.ee>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee> <20141114165804.GA14631@infradead.org> <alpine.LRH.2.11.1411142114200.26813@adalberg.ut.ee> <54665B30.4070708@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <54665B30.4070708@kernel.dk>
Sender: sparclinux-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

> >> The second oops is in blk_mq_map_queue() which is a trivial
> >> two level cpu lookup.  I wonder if there's something odd about
> >> cpu numbers on these big old sparc systems?
> > 
> > CPU numbers are sparse - they are determined by hardware slot number and 
> > some models only fill every other mainboard slot, and first slots can be 
> > free. I have first board offline and currently have CPUs numbered 
> > 10,11,14,15 online.
> >  
> > Here is debug with Jens's patch:
> 
> > [  133.971050] CPU 11: synchronized TICK with master CPU (last diff -1 cycles, maxerr 516 cycles)
> > [  133.975491] CPU 14: synchronized TICK with master CPU (last diff -3 cycles, maxerr 531 cycles)
> > [  133.979943] CPU 15: synchronized TICK with master CPU (last diff -3 cycles, maxerr 531 cycles)
> > [  133.980146] Brought up 4 CPUs
> 
> So this looks like this might be the issue. On a scsi-mq disabled boot,
> you have 4 CPUs, but how are they numbered?

The numbers are always the same.

But everything seems to be mapped to queue 0?

> We might need Christophs debug patch on top this to fully know...

Applied it too, dmesg is below. Yes it does spam the log a lot, and over 
9600bps console its' somewhat slow :)

There is another detail to note  -this server contains a faulty disk as 
sdc that times out spinup. I left it in the server because it helped to 
pinpoint and fix a previous error in esp scsi driver. This can be a 
factor here too - the error handling details.

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
[    0.000000] Linux version 3.18.0-rc4-00052-g04689e7-dirty (mroos@mandel) (gcc version 4.9.2 (Debian 4.9.2-1) ) #27 SMP Sat Nov 15 00:34:49 EET 2014
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
[  138.161583] clocksource: mult[2042108] shift[23]
[  138.216192] clockevent: mult[3f7ced91] shift[32]
[  138.271690] Console: colour dummy device 80x25
[  138.324621] console [tty0] enabled
[  138.365200] bootconsole [earlyprom0] disabled
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.18.0-rc4-00052-g04689e7-dirty (mroos@mandel) (gcc version 4.9.2 (Debian 4.9.2-1) ) #27 SMP Sat Nov 15 00:34:49 EET 2014
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
[  138.161583] clocksource: mult[2042108] shift[23]
[  138.216192] clockevent: mult[3f7ced91] shift[32]
[  138.271690] Console: colour dummy device 80x25
[  138.324621] console [tty0] enabled
[  138.365200] bootconsole [earlyprom0] disabled
[  138.567474] Calibrating delay using timer specific routine.. 497.45 BogoMIPS (lpj=2487259)
[  138.567548] pid_max: default: 32768 minimum: 301
[  138.567985] Mount-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  138.568047] Mountpoint-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  138.579040] CPU 11: synchronized TICK with master CPU (last diff -1 cycles, maxerr 522 cycles)
[  138.583484] CPU 14: synchronized TICK with master CPU (last diff -2 cycles, maxerr 532 cycles)
[  138.587857] CPU 15: synchronized TICK with master CPU (last diff -2 cycles, maxerr 532 cycles)
[  138.588062] Brought up 4 CPUs
[  138.590170] devtmpfs: initialized
[  138.673554] device-tree: Duplicate name in base, renamed to "fhc#1"
[  138.676262] device-tree: Duplicate name in base, renamed to "fhc#2"
[  138.678778] device-tree: Duplicate name in base, renamed to "counter-timer#1"
[  138.680268] NET: Registered protocol family 16
[  138.697034] SYSIO: UPA portID ffffffff, at 000001c400000000
[  138.707685] SYSIO: UPA portID ffffffff, at 000001c600000000
[  138.752214] SCSI subsystem initialized
[  138.755227] /central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
[  138.756251] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
[  138.756617] fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
[  138.756953] fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
[  138.757299] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
[  138.757788] clock_board: Detected 4 slot Enterprise system.
[  138.758569] Switched to clocksource tick
[  138.785177] NET: Registered protocol family 2
[  138.787672] TCP established hash table entries: 32768 (order: 5, 262144 bytes)
[  138.789429] TCP bind hash table entries: 32768 (order: 6, 524288 bytes)
[  138.792521] TCP: Hash tables configured (established 32768 bind 32768)
[  138.793302] TCP: reno registered
[  138.793388] UDP hash table entries: 2048 (order: 3, 65536 bytes)
[  138.793924] UDP-Lite hash table entries: 2048 (order: 3, 65536 bytes)
[  138.795307] NET: Registered protocol family 1
[  138.800181] futex hash table entries: 1024 (order: 3, 65536 bytes)
[  138.800804] audit: initializing netlink subsys (disabled)
[  138.801168] audit: type=2000 audit(0.409:1): initialized
[  138.802557] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[  138.840854] msgmni has been set to 8090
[  138.843857] io scheduler noop registered
[  138.845037] io scheduler cfq registered (default)
[  139.054243] zs f005ddbc: ttyS0 at MMIO 0x1fff8902000 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  139.054348] Console: ttyS0 (SunZilog zs0)
[  145.082969] console [ttyS0] enabled
[  145.125625] zs f005ddbc: ttyS1 at MMIO 0x1fff8902004 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  145.440223] f005de94: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
[  145.516321] f005de94: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
[  145.593947] esp: esp0, regs[1c738810000:1c738800000] irq[19]
[  145.659689] esp: esp0 is a FASHME, 40 MHz (ccf=0), SCSI ID 7
[  148.728616] scsi host0: esp
[  148.761592] cpumap 0 -> 0
[  148.763781] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[  148.764857] TCP: cubic registered
[  148.766965] NET: Registered protocol family 10
[  148.769564] NET: Registered protocol family 17
[  148.791243] rtc-m48t59 rtc-m48t59.0: setting system clock to 2014-11-14 22:53:40 UTC (1416005620)
[  149.123623] cpumap 1 -> 0
[  149.123630] cpumap 2 -> 0
[  149.123636] cpumap 3 -> 0
[  149.123844] cpu: 10
[  149.123849] queue: 0
[  149.123857] cpu: 11
[  149.123861] queue: 0
[  149.123869] cpu: 14
[  149.123873] queue: 0
[  149.123881] cpu: 15
[  149.123884] queue: 0
[  149.123927] cpu: 10
[  149.123932] queue: 0
[  149.123938] cpu: 11
[  149.123943] queue: 0
[  149.123949] cpu: 14
[  149.123953] queue: 0
[  149.123959] cpu: 15
[  149.123963] queue: 0
[  149.124041] cpu: 10
[  149.124046] queue: 0
[  149.124084] cpu: 10
[  149.124088] queue: 0
[  149.155004] cpu: 10
[  149.155009] queue: 0
[  149.155109] cpu: 10
[  149.155113] queue: 0
[  149.155130] cpu: 10
[  149.155134] queue: 0
[  149.186185] cpu: 10
[  149.186191] queue: 0
[  149.186302] scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  149.186389] scsi target0:0:0: Beginning Domain Validation
[  149.186403] cpu: 10
[  149.186407] queue: 0
[  149.186424] cpu: 10
[  149.186428] queue: 0
[  149.217461] cpu: 10
[  149.217467] queue: 0
[  149.217478] cpu: 10
[  149.217481] queue: 0
[  149.217498] cpu: 10
[  149.217502] queue: 0
[  149.242472] cpu: 10
[  149.242477] queue: 0
[  149.242491] cpu: 10
[  149.242495] queue: 0
[  149.242512] cpu: 10
[  149.242516] queue: 0
[  149.268513] cpu: 10
[  149.268518] queue: 0
[  149.268532] cpu: 10
[  149.268535] queue: 0
[  149.268552] cpu: 10
[  149.268556] queue: 0
[  149.293510] cpu: 10
[  149.293515] queue: 0
[  149.293532] cpu: 10
[  149.293536] queue: 0
[  149.293552] cpu: 10
[  149.293556] queue: 0
[  149.319543] cpu: 10
[  149.319549] queue: 0
[  149.319562] cpu: 10
[  149.319566] queue: 0
[  149.319583] cpu: 10
[  149.319587] queue: 0
[  149.344559] cpu: 10
[  149.344565] queue: 0
[  149.344578] cpu: 10
[  149.344582] queue: 0
[  149.344599] cpu: 10
[  149.344603] queue: 0
[  149.370594] cpu: 10
[  149.370599] queue: 0
[  149.370621] cpu: 10
[  149.370625] queue: 0
[  149.370642] cpu: 10
[  149.370646] queue: 0
[  149.395643] scsi target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  149.421634] cpu: 10
[  149.421639] queue: 0
[  149.421654] cpu: 10
[  149.421658] queue: 0
[  149.421675] cpu: 10
[  149.421679] queue: 0
[  149.446644] cpu: 10
[  149.446649] queue: 0
[  149.446663] cpu: 10
[  149.446666] queue: 0
[  149.446683] cpu: 10
[  149.446687] queue: 0
[  149.472682] cpu: 10
[  149.472688] queue: 0
[  149.472718] scsi target0:0:0: Domain Validation skipping write tests
[  149.472734] scsi target0:0:0: Ending Domain Validation
[  149.472798] cpumap 0 -> 0
[  149.472803] cpumap 1 -> 0
[  149.472809] cpumap 2 -> 0
[  149.472814] cpumap 3 -> 0
[  149.472951] cpu: 10
[  149.472956] queue: 0
[  149.472964] cpu: 11
[  149.472968] queue: 0
[  149.472975] cpu: 14
[  149.472979] queue: 0
[  149.472987] cpu: 15
[  149.472991] queue: 0
[  149.473035] cpu: 10
[  149.473039] queue: 0
[  149.473045] cpu: 11
[  149.473050] queue: 0
[  149.473055] cpu: 14
[  149.473060] queue: 0
[  149.473065] cpu: 15
[  149.473070] queue: 0
[  149.473135] cpu: 10
[  149.473139] queue: 0
[  149.473157] cpu: 10
[  149.473161] queue: 0
[  149.497671] cpu: 10
[  149.497677] queue: 0
[  149.497756] cpu: 10
[  149.497761] queue: 0
[  149.497778] cpu: 10
[  149.497782] queue: 0
[  149.523707] cpu: 10
[  149.523712] queue: 0
[  149.523944] cpumap 0 -> 0
[  149.523950] cpumap 1 -> 0
[  149.523955] cpumap 2 -> 0
[  149.523961] cpumap 3 -> 0
[  149.524041] cpu: 10
[  149.524045] queue: 0
[  149.524053] cpu: 11
[  149.524057] queue: 0
[  149.524065] cpu: 14
[  149.524069] queue: 0
[  149.524077] cpu: 15
[  149.524081] queue: 0
[  149.524107] cpu: 10
[  149.524111] queue: 0
[  149.524117] cpu: 11
[  149.524122] queue: 0
[  149.524127] cpu: 14
[  149.524132] queue: 0
[  149.524137] cpu: 15
[  149.524142] queue: 0
[  149.524188] cpu: 10
[  149.524192] queue: 0
[  149.524209] cpu: 10
[  149.524213] queue: 0
[  149.548749] cpu: 10
[  149.548754] queue: 0
[  149.548832] cpu: 10
[  149.548836] queue: 0
[  149.548853] cpu: 10
[  149.548857] queue: 0
[  149.574794] cpu: 10
[  149.574799] queue: 0
[  149.574900] scsi 0:0:1:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  149.574947] scsi target0:0:1: Beginning Domain Validation
[  149.574959] cpu: 10
[  149.574963] queue: 0
[  149.574980] cpu: 10
[  149.574984] queue: 0
[  149.599827] cpu: 10
[  149.599832] queue: 0
[  149.599843] cpu: 10
[  149.599847] queue: 0
[  149.599864] cpu: 10
[  149.599868] queue: 0
[  149.625863] cpu: 10
[  149.625869] queue: 0
[  149.625883] cpu: 10
[  149.625887] queue: 0
[  149.625904] cpu: 10
[  149.625908] queue: 0
[  149.650872] cpu: 10
[  149.650878] queue: 0
[  149.650891] cpu: 10
[  149.650895] queue: 0
[  149.650912] cpu: 10
[  149.650916] queue: 0
[  149.676912] cpu: 10
[  149.676918] queue: 0
[  149.676934] cpu: 10
[  149.676938] queue: 0
[  149.676955] cpu: 10
[  149.676959] queue: 0
[  149.701901] cpu: 10
[  149.701906] queue: 0
[  149.701920] cpu: 10
[  149.701923] queue: 0
[  149.701940] cpu: 10
[  149.701944] queue: 0
[  149.727951] cpu: 10
[  149.727957] queue: 0
[  149.727970] cpu: 10
[  149.727974] queue: 0
[  149.727991] cpu: 10
[  149.727995] queue: 0
[  149.752947] cpu: 10
[  149.752952] queue: 0
[  149.752972] cpu: 10
[  149.752976] queue: 0
[  149.752993] cpu: 10
[  149.752997] queue: 0
[  149.779063] scsi target0:0:1: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  149.803994] cpu: 10
[  149.803999] queue: 0
[  149.804014] cpu: 10
[  149.804018] queue: 0
[  149.804035] cpu: 10
[  149.804039] queue: 0
[  149.830049] cpu: 10
[  149.830055] queue: 0
[  149.830068] cpu: 10
[  149.830072] queue: 0
[  149.830089] cpu: 10
[  149.830093] queue: 0
[  149.855057] cpu: 10
[  149.855063] queue: 0
[  149.855092] scsi target0:0:1: Domain Validation skipping write tests
[  149.855106] scsi target0:0:1: Ending Domain Validation
[  149.855169] cpumap 0 -> 0
[  149.855175] cpumap 1 -> 0
[  149.855180] cpumap 2 -> 0
[  149.855186] cpumap 3 -> 0
[  149.855267] cpu: 10
[  149.855271] queue: 0
[  149.855279] cpu: 11
[  149.855283] queue: 0
[  149.855291] cpu: 14
[  149.855295] queue: 0
[  149.855302] cpu: 15
[  149.855306] queue: 0
[  149.855352] cpu: 10
[  149.855356] queue: 0
[  149.855362] cpu: 11
[  149.855367] queue: 0
[  149.855372] cpu: 14
[  149.855377] queue: 0
[  149.855383] cpu: 15
[  149.855387] queue: 0
[  149.855449] cpu: 10
[  149.855454] queue: 0
[  149.855470] cpu: 10
[  149.855475] queue: 0
[  149.881076] cpu: 10
[  149.881082] queue: 0
[  149.881158] cpu: 10
[  149.881162] queue: 0
[  149.881179] cpu: 10
[  149.881183] queue: 0
[  149.906078] cpu: 10
[  149.906084] queue: 0
[  149.906293] cpumap 0 -> 0
[  149.906299] cpumap 1 -> 0
[  149.906304] cpumap 2 -> 0
[  149.906310] cpumap 3 -> 0
[  149.906391] cpu: 10
[  149.906395] queue: 0
[  149.906403] cpu: 11
[  149.906407] queue: 0
[  149.906415] cpu: 14
[  149.906419] queue: 0
[  149.906427] cpu: 15
[  149.906431] queue: 0
[  149.906463] cpu: 10
[  149.906468] queue: 0
[  149.906473] cpu: 11
[  149.906478] queue: 0
[  149.906483] cpu: 14
[  149.906488] queue: 0
[  149.906493] cpu: 15
[  149.906498] queue: 0
[  149.906545] cpu: 10
[  149.906549] queue: 0
[  149.906566] cpu: 10
[  149.906570] queue: 0
[  149.932104] cpu: 10
[  149.932109] queue: 0
[  149.932184] cpu: 10
[  149.932188] queue: 0
[  149.932205] cpu: 10
[  149.932209] queue: 0
[  150.028867] cpu: 10
[  150.028871] queue: 0
[  150.028968] scsi 0:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
[  150.029017] scsi target0:0:2: Beginning Domain Validation
[  150.029028] cpu: 10
[  150.029032] queue: 0
[  150.029050] cpu: 10
[  150.029054] queue: 0
[  150.029550] cpu: 10
[  150.029554] queue: 0
[  150.029564] cpu: 10
[  150.029568] queue: 0
[  150.029585] cpu: 10
[  150.029589] queue: 0
[  150.093674] cpu: 10
[  150.093679] queue: 0
[  150.093694] cpu: 10
[  150.093697] queue: 0
[  150.093715] cpu: 10
[  150.093719] queue: 0
[  150.094208] cpu: 10
[  150.094213] queue: 0
[  150.094227] cpu: 10
[  150.094231] queue: 0
[  150.094248] cpu: 10
[  150.094252] queue: 0
[  150.118677] cpu: 10
[  150.118683] queue: 0
[  150.118700] cpu: 10
[  150.118704] queue: 0
[  150.118721] cpu: 10
[  150.118725] queue: 0
[  150.144706] cpu: 10
[  150.144711] queue: 0
[  150.144725] cpu: 10
[  150.144729] queue: 0
[  150.144746] cpu: 10
[  150.144750] queue: 0
[  150.169612] cpu: 10
[  150.169617] queue: 0
[  150.169632] cpu: 10
[  150.169636] queue: 0
[  150.169653] cpu: 10
[  150.169657] queue: 0
[  150.195576] cpu: 10
[  150.195595] queue: 0
[  150.195617] cpu: 10
[  150.195621] queue: 0
[  150.195638] cpu: 10
[  150.195642] queue: 0
[  150.196559] scsi target0:0:2: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  150.220989] cpu: 10
[  150.220994] queue: 0
[  150.221009] cpu: 10
[  150.221013] queue: 0
[  150.221030] cpu: 10
[  150.221035] queue: 0
[  150.246801] cpu: 10
[  150.246807] queue: 0
[  150.246821] cpu: 10
[  150.246825] queue: 0
[  150.246842] cpu: 10
[  150.246846] queue: 0
[  150.271756] cpu: 10
[  150.271762] queue: 0
[  150.271792] scsi target0:0:2: Domain Validation skipping write tests
[  150.271807] scsi target0:0:2: Ending Domain Validation
[  150.271829] cpu: 10
[  150.271835] queue: 0
[  150.271862] cpu: 10
[  150.271866] queue: 0
[  150.297774] cpu: 10
[  150.297780] queue: 0
[  150.297796] cpu: 10
[  150.297802] queue: 0
[  150.297823] cpu: 10
[  150.297827] queue: 0
[  150.298296] cpu: 10
[  150.298302] queue: 0
[  150.298317] cpu: 10
[  150.298322] queue: 0
[  150.298343] cpu: 10
[  150.298347] queue: 0
[  150.323066] cpu: 10
[  150.323073] queue: 0
[  150.323097] cpu: 10
[  150.323101] queue: 0
[  150.323117] cpu: 10
[  150.323121] queue: 0
[  150.348857] cpu: 10
[  150.348862] queue: 0
[  150.348972] cpumap 0 -> 0
[  150.348977] cpumap 1 -> 0
[  150.348983] cpumap 2 -> 0
[  150.348988] cpumap 3 -> 0
[  150.349060] cpu: 10
[  150.349064] queue: 0
[  150.349072] cpu: 11
[  150.349076] queue: 0
[  150.349083] cpu: 14
[  150.349087] queue: 0
[  150.349095] cpu: 15
[  150.349099] queue: 0
[  150.349149] cpu: 10
[  150.349153] queue: 0
[  150.349159] cpu: 11
[  150.349163] queue: 0
[  150.349169] cpu: 14
[  150.349174] queue: 0
[  150.349179] cpu: 15
[  150.349184] queue: 0
[  150.349280] cpu: 10
[  150.349285] queue: 0
[  150.349302] cpu: 10
[  150.349306] queue: 0
[  150.604093] cpu: 10
[  150.604098] queue: 0
[  150.604267] cpumap 0 -> 0
[  150.604273] cpumap 1 -> 0
[  150.604278] cpumap 2 -> 0
[  150.604284] cpumap 3 -> 0
[  150.604352] cpu: 10
[  150.604357] queue: 0
[  150.604365] cpu: 11
[  150.604368] queue: 0
[  150.604376] cpu: 14
[  150.604380] queue: 0
[  150.604388] cpu: 15
[  150.604392] queue: 0
[  150.604432] cpu: 10
[  150.604437] queue: 0
[  150.604442] cpu: 11
[  150.604447] queue: 0
[  150.604453] cpu: 14
[  150.604457] queue: 0
[  150.604463] cpu: 15
[  150.604467] queue: 0
[  150.604527] cpu: 10
[  150.604531] queue: 0
[  150.604547] cpu: 10
[  150.604552] queue: 0
[  150.859338] cpu: 10
[  150.859343] queue: 0
[  150.859495] cpumap 0 -> 0
[  150.859501] cpumap 1 -> 0
[  150.859507] cpumap 2 -> 0
[  150.859512] cpumap 3 -> 0
[  150.859579] cpu: 10
[  150.859583] queue: 0
[  150.859591] cpu: 11
[  150.859595] queue: 0
[  150.859602] cpu: 14
[  150.859606] queue: 0
[  150.859614] cpu: 15
[  150.859618] queue: 0
[  150.859659] cpu: 10
[  150.859663] queue: 0
[  150.859669] cpu: 11
[  150.859673] queue: 0
[  150.859679] cpu: 14
[  150.859684] queue: 0
[  150.859689] cpu: 15
[  150.859693] queue: 0
[  150.859742] cpu: 10
[  150.859747] queue: 0
[  150.859763] cpu: 10
[  150.859768] queue: 0
[  151.114560] cpu: 10
[  151.114565] queue: 0
[  151.114720] cpumap 0 -> 0
[  151.114726] cpumap 1 -> 0
[  151.114732] cpumap 2 -> 0
[  151.114737] cpumap 3 -> 0
[  151.114806] cpu: 10
[  151.114810] queue: 0
[  151.114819] cpu: 11
[  151.114823] queue: 0
[  151.114831] cpu: 14
[  151.114835] queue: 0
[  151.114843] cpu: 15
[  151.114846] queue: 0
[  151.114886] cpu: 10
[  151.114891] queue: 0
[  151.114897] cpu: 11
[  151.114901] queue: 0
[  151.114907] cpu: 14
[  151.114911] queue: 0
[  151.114917] cpu: 15
[  151.114921] queue: 0
[  151.114971] cpu: 10
[  151.114975] queue: 0
[  151.114992] cpu: 10
[  151.114996] queue: 0
[  151.356269] cpu: 10
[  151.356275] queue: 0
[  151.356430] cpumap 0 -> 0
[  151.356436] cpumap 1 -> 0
[  151.356442] cpumap 2 -> 0
[  151.356447] cpumap 3 -> 0
[  151.356516] cpu: 10
[  151.356520] queue: 0
[  151.356528] cpu: 11
[  151.356532] queue: 0
[  151.356540] cpu: 14
[  151.356544] queue: 0
[  151.356552] cpu: 15
[  151.356556] queue: 0
[  151.356595] cpu: 10
[  151.356599] queue: 0
[  151.356605] cpu: 11
[  151.356610] queue: 0
[  151.356615] cpu: 14
[  151.356620] queue: 0
[  151.356625] cpu: 15
[  151.356630] queue: 0
[  151.356680] cpu: 10
[  151.356684] queue: 0
[  151.356701] cpu: 10
[  151.356705] queue: 0
[  151.611560] cpu: 10
[  151.611566] queue: 0
[  151.611719] cpumap 0 -> 0
[  151.611725] cpumap 1 -> 0
[  151.611730] cpumap 2 -> 0
[  151.611736] cpumap 3 -> 0
[  151.611802] cpu: 10
[  151.611806] queue: 0
[  151.611814] cpu: 11
[  151.611818] queue: 0
[  151.611826] cpu: 14
[  151.611830] queue: 0
[  151.611838] cpu: 15
[  151.611842] queue: 0
[  151.611881] cpu: 10
[  151.611886] queue: 0
[  151.611892] cpu: 11
[  151.611896] queue: 0
[  151.611902] cpu: 14
[  151.611907] queue: 0
[  151.611912] cpu: 15
[  151.611916] queue: 0
[  151.611966] cpu: 10
[  151.611970] queue: 0
[  151.611989] cpu: 10
[  151.611993] queue: 0
[  151.851149] cpu: 10
[  151.851155] queue: 0
[  151.851310] cpumap 0 -> 0
[  151.851316] cpumap 1 -> 0
[  151.851321] cpumap 2 -> 0
[  151.851327] cpumap 3 -> 0
[  151.851394] cpu: 10
[  151.851398] queue: 0
[  151.851406] cpu: 11
[  151.851410] queue: 0
[  151.851417] cpu: 14
[  151.851421] queue: 0
[  151.851429] cpu: 15
[  151.851433] queue: 0
[  151.851473] cpu: 10
[  151.851478] queue: 0
[  151.851484] cpu: 11
[  151.851488] queue: 0
[  151.851494] cpu: 14
[  151.851498] queue: 0
[  151.851504] cpu: 15
[  151.851508] queue: 0
[  151.851558] cpu: 10
[  151.851562] queue: 0
[  151.851582] cpu: 10
[  151.851586] queue: 0
[  152.103320] cpu: 10
[  152.103325] queue: 0
[  152.103478] cpumap 0 -> 0
[  152.103484] cpumap 1 -> 0
[  152.103489] cpumap 2 -> 0
[  152.103495] cpumap 3 -> 0
[  152.103563] cpu: 10
[  152.103567] queue: 0
[  152.103575] cpu: 11
[  152.103579] queue: 0
[  152.103587] cpu: 14
[  152.103590] queue: 0
[  152.103598] cpu: 15
[  152.103602] queue: 0
[  152.103642] cpu: 10
[  152.103647] queue: 0
[  152.103652] cpu: 11
[  152.103657] queue: 0
[  152.103663] cpu: 14
[  152.103667] queue: 0
[  152.103673] cpu: 15
[  152.103677] queue: 0
[  152.103727] cpu: 10
[  152.103731] queue: 0
[  152.103750] cpu: 10
[  152.103754] queue: 0
[  152.358573] cpu: 10
[  152.358578] queue: 0
[  152.358731] cpumap 0 -> 0
[  152.358737] cpumap 1 -> 0
[  152.358742] cpumap 2 -> 0
[  152.358748] cpumap 3 -> 0
[  152.358816] cpu: 10
[  152.358820] queue: 0
[  152.358828] cpu: 11
[  152.358832] queue: 0
[  152.358840] cpu: 14
[  152.358843] queue: 0
[  152.358851] cpu: 15
[  152.358855] queue: 0
[  152.358894] cpu: 10
[  152.358899] queue: 0
[  152.358905] cpu: 11
[  152.358909] queue: 0
[  152.358915] cpu: 14
[  152.358919] queue: 0
[  152.358925] cpu: 15
[  152.358929] queue: 0
[  152.358980] cpu: 10
[  152.358984] queue: 0
[  152.359002] cpu: 10
[  152.359006] queue: 0
[  152.613783] cpu: 10
[  152.613788] queue: 0
[  152.613939] cpumap 0 -> 0
[  152.613945] cpumap 1 -> 0
[  152.613951] cpumap 2 -> 0
[  152.613956] cpumap 3 -> 0
[  152.614024] cpu: 10
[  152.614028] queue: 0
[  152.614036] cpu: 11
[  152.614040] queue: 0
[  152.614048] cpu: 14
[  152.614052] queue: 0
[  152.614059] cpu: 15
[  152.614063] queue: 0
[  152.614103] cpu: 10
[  152.614108] queue: 0
[  152.614113] cpu: 11
[  152.614118] queue: 0
[  152.614123] cpu: 14
[  152.614128] queue: 0
[  152.614133] cpu: 15
[  152.614138] queue: 0
[  152.614187] cpu: 10
[  152.614192] queue: 0
[  152.614208] cpu: 10
[  152.614212] queue: 0
[  152.866997] cpu: 10
[  152.867002] queue: 0
[  152.867154] cpumap 0 -> 0
[  152.867160] cpumap 1 -> 0
[  152.867165] cpumap 2 -> 0
[  152.867171] cpumap 3 -> 0
[  152.867238] cpu: 10
[  152.867242] queue: 0
[  152.867250] cpu: 11
[  152.867254] queue: 0
[  152.867262] cpu: 14
[  152.867266] queue: 0
[  152.867273] cpu: 15
[  152.867277] queue: 0
[  152.867317] cpu: 10
[  152.867322] queue: 0
[  152.867327] cpu: 11
[  152.867332] queue: 0
[  152.867337] cpu: 14
[  152.867342] queue: 0
[  152.867348] cpu: 15
[  152.867352] queue: 0
[  152.867402] cpu: 10
[  152.867407] queue: 0
[  152.867423] cpu: 10
[  152.867427] queue: 0
[  153.122206] cpu: 10
[  153.122211] queue: 0
[  153.122363] cpumap 0 -> 0
[  153.122369] cpumap 1 -> 0
[  153.122374] cpumap 2 -> 0
[  153.122380] cpumap 3 -> 0
[  153.122446] cpu: 10
[  153.122451] queue: 0
[  153.122459] cpu: 11
[  153.122462] queue: 0
[  153.122470] cpu: 14
[  153.122474] queue: 0
[  153.122482] cpu: 15
[  153.122486] queue: 0
[  153.122526] cpu: 10
[  153.122531] queue: 0
[  153.122536] cpu: 11
[  153.122541] queue: 0
[  153.122546] cpu: 14
[  153.122551] queue: 0
[  153.122556] cpu: 15
[  153.122561] queue: 0
[  153.122611] cpu: 10
[  153.122615] queue: 0
[  153.122632] cpu: 10
[  153.122636] queue: 0
[  153.377467] cpu: 10
[  153.377472] queue: 0
[  153.403302] cpu: 15
[  153.403310] queue: 0
[  153.403336] cpu: 15
[  153.403340] queue: 0
[  153.428949] cpu: 15
[  153.428954] queue: 0
[  153.428976] cpu: 15
[  153.428981] queue: 0
[  153.428993] cpu: 15
[  153.428997] queue: 0
[  153.429379] cpu: 15
[  153.429384] queue: 0
[  153.429402] cpu: 15
[  153.429406] queue: 0
[  153.429439] cpu: 15
[  153.429444] queue: 0
[  153.453699] cpu: 15
[  153.453705] queue: 0
[  153.453769] sd 0:0:0:0: [sda] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  153.453789] cpu: 15
[  153.453793] queue: 0
[  153.453811] cpu: 15
[  153.453815] queue: 0
[  153.479708] cpu: 15
[  153.479713] queue: 0
[  153.479741] sd 0:0:0:0: [sda] Write Protect is off
[  153.479765] sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
[  153.479777] cpu: 15
[  153.479781] queue: 0
[  153.479799] cpu: 15
[  153.479803] queue: 0
[  153.479910] cpu: 11
[  153.479917] queue: 0
[  153.479944] cpu: 11
[  153.479948] queue: 0
[  153.480570] cpu: 11
[  153.480575] queue: 0
[  153.480596] cpu: 11
[  153.480601] queue: 0
[  153.480611] cpu: 11
[  153.480615] queue: 0
[  153.504706] cpu: 15
[  153.504711] queue: 0
[  153.504729] cpu: 15
[  153.504734] queue: 0
[  153.504751] cpu: 15
[  153.504756] queue: 0
[  153.505004] cpu: 11
[  153.505009] queue: 0
[  153.505026] cpu: 11
[  153.505030] queue: 0
[  153.505060] cpu: 11
[  153.505064] queue: 0
[  153.530761] cpu: 15
[  153.530766] queue: 0
[  153.530801] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  153.530813] cpu: 15
[  153.530817] queue: 0
[  153.530836] cpu: 15
[  153.530840] queue: 0
[  153.530919] cpu: 11
[  153.530924] queue: 0
[  153.530985] sd 0:0:1:0: [sdb] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  153.531006] cpu: 11
[  153.531010] queue: 0
[  153.531027] cpu: 11
[  153.531031] queue: 0
[  153.531420] cpu: 15
[  153.531426] queue: 0
[  153.533075] cpu: 15
[  153.533081] queue: 0
[  153.533093] cpu: 15
[  153.533097] queue: 0
[  153.627649] cpu: 11
[  153.627655] queue: 0
[  153.627681] sd 0:0:1:0: [sdb] Write Protect is off
[  153.627704] sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
[  153.627717] cpu: 11
[  153.627722] queue: 0
[  153.627739] cpu: 11
[  153.627743] queue: 0
[  153.627869] cpu: 15
[  153.627875] queue: 0
[  153.627896] cpu: 15
[  153.627900] queue: 0
[  153.628181] cpu: 15
[  153.628186] queue: 0
[  153.628223] cpu: 15
[  153.628227] queue: 0
[  153.628245] cpu: 15
[  153.628250] queue: 0
[  153.692637] cpu: 15
[  153.692643] queue: 0
[  153.692658] cpu: 15
[  153.692663] queue: 0
[  153.692674] cpu: 15
[  153.692679] queue: 0
[  153.692801] cpu: 11
[  153.692807] queue: 0
[  153.692823] cpu: 11
[  153.692828] queue: 0
[  153.692845] cpu: 11
[  153.692849] queue: 0
[  153.717224] cpu: 15
[  153.717230] queue: 0
[  153.717245] cpu: 15
[  153.717250] queue: 0
[  153.717261] cpu: 15
[  153.717265] queue: 0
[  153.717387] cpu: 15
[  153.717391] queue: 0
[  153.717434] cpu: 15
[  153.717438] queue: 0
[  153.717456] cpu: 15
[  153.717460] queue: 0
[  153.743277] cpu: 15
[  153.743283] queue: 0
[  153.743312] sd 0:0:2:0: [sdc] Spinning up disk...
[  153.743324] cpu: 15
[  153.743329] queue: 0
[  153.743341] cpu: 15
[  153.743345] queue: 0
[  153.743431] cpu: 11
[  153.743436] queue: 0
[  153.743471] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  153.743484] cpu: 11
[  153.743488] queue: 0
[  153.743505] cpu: 11
[  153.743509] queue: 0
[  153.743793] cpu: 15
[  153.743799] queue: 0
[  153.768275] cpu: 11
[  153.768280] queue: 0
[  153.768455] cpu: 15
[  153.768461] queue: 0
[  153.768480] cpu: 15
[  153.768484] queue: 0
[  153.768503] cpu: 15
[  153.768507] queue: 0
[  153.769257] cpu: 15
[  153.769263] queue: 0
[  153.769282] cpu: 15
[  153.769286] queue: 0
[  153.794331] cpu: 15
[  153.794337] queue: 0
[  153.794355] cpu: 15
[  153.794359] queue: 0
[  153.794377] cpu: 15
[  153.794381] queue: 0
[  153.794642] cpu: 15
[  153.794647] queue: 0
[  153.794661] cpu: 15
[  153.794666] queue: 0
[  153.794683] cpu: 15
[  153.794687] queue: 0
[  153.819328] cpu: 15
[  153.819334] queue: 0
[  153.819353] cpu: 15
[  153.819358] queue: 0
[  153.819376] cpu: 15
[  153.819380] queue: 0
[  153.819497] cpu: 15
[  153.819501] queue: 0
[  153.819537] cpu: 15
[  153.819541] queue: 0
[  153.819557] cpu: 15
[  153.819561] queue: 0
[  153.819995] cpu: 15
[  153.820000] queue: 0
[  153.820762] cpu: 15
[  153.820767] queue: 0
[  153.845399] cpu: 15
[  153.845404] queue: 0
[  153.845420] cpu: 15
[  153.845424] queue: 0
[  153.845442] cpu: 15
[  153.845446] queue: 0
[  153.870385] cpu: 15
[  153.870390] queue: 0
[  153.870405] cpu: 15
[  153.870409] queue: 0
[  153.870427] cpu: 15
[  153.870431] queue: 0
[  153.870884] cpu: 15
[  153.870889] queue: 0
[  153.871125]  sda: sda1 sda2 sda3 sda4
[  153.874034] cpu: 15
[  153.874039] queue: 0
[  153.874052] cpu: 15
[  153.874056] queue: 0
[  153.874131] cpu: 15
[  153.874136] queue: 0
[  153.874150] cpu: 15
[  153.874154] queue: 0
[  153.896427] cpu: 15
[  153.896433] queue: 0
[  153.896452] cpu: 15
[  153.896456] queue: 0
[  153.896477] cpu: 15
[  153.896481] queue: 0
[  153.896783] cpu: 15
[  153.896788] queue: 0
[  153.896803] cpu: 15
[  153.896808] queue: 0
[  153.896826] cpu: 15
[  153.896830] queue: 0
[  153.897039] cpu: 15
[  153.897044] queue: 0
[  153.897282] cpu: 15
[  153.897287] queue: 0
[  153.897366] cpu: 15
[  153.897371] queue: 0
[  153.921801] cpu: 15
[  153.921806] queue: 0
[  153.922122] cpu: 15
[  153.922127] queue: 0
[  153.922206] cpu: 15
[  153.922211] queue: 0
[  153.922251] cpu: 15
[  153.922255] queue: 0
[  153.922274] cpu: 15
[  153.922278] queue: 0
[  153.947815] cpu: 15
[  153.947820] queue: 0
[  153.947909]  sdb: unknown partition table
[  153.948979] cpu: 15
[  153.948984] queue: 0
[  153.948995] cpu: 15
[  153.948999] queue: 0
[  153.949065] cpu: 15
[  153.949070] queue: 0
[  153.949080] cpu: 15
[  153.949084] queue: 0
[  153.972486] cpu: 15
[  153.972491] queue: 0
[  153.972518] cpu: 15
[  153.972523] queue: 0
[  153.972542] cpu: 15
[  153.972546] queue: 0
[  153.972850] cpu: 15
[  153.972854] queue: 0
[  153.972869] cpu: 15
[  153.972873] queue: 0
[  153.972890] cpu: 15
[  153.972894] queue: 0
[  153.973135] cpu: 15
[  153.973140] queue: 0
[  153.998522] cpu: 15
[  153.998527] queue: 0
[  153.998542] cpu: 15
[  153.998546] queue: 0
[  153.998565] cpu: 15
[  153.998569] queue: 0
[  153.998701] cpu: 15
[  153.998705] queue: 0
[  153.998740] cpu: 15
[  153.998745] queue: 0
[  153.998761] cpu: 15
[  153.998765] queue: 0
[  154.023515] cpu: 15
[  154.023520] queue: 0
[  154.023537] cpu: 15
[  154.023541] queue: 0
[  154.023560] cpu: 15
[  154.023564] queue: 0
[  154.023690] cpu: 15
[  154.023695] queue: 0
[  154.023710] cpu: 15
[  154.023714] queue: 0
[  154.023731] cpu: 15
[  154.023735] queue: 0
[  154.024197] cpu: 15
[  154.024202] queue: 0
[  154.024235] sd 0:0:0:0: [sda] Attached SCSI disk
[  154.049558] cpu: 15
[  154.049564] queue: 0
[  154.049578] cpu: 15
[  154.049582] queue: 0
[  154.049600] cpu: 15
[  154.049604] queue: 0
[  154.074566] cpu: 15
[  154.074571] queue: 0
[  154.074586] cpu: 15
[  154.074590] queue: 0
[  154.074608] cpu: 15
[  154.074611] queue: 0
[  154.075175] cpu: 15
[  154.075179] queue: 0
[  154.075210] sd 0:0:1:0: [sdb] Attached SCSI disk
[  154.768453] .cpu: 15
[  154.768459] queue: 0
[  154.768471] cpu: 15
[  154.768475] queue: 0
[  154.790058] cpu: 15
[  154.790064] queue: 0
[  154.790079] cpu: 15
[  154.790083] queue: 0
[  154.790094] cpu: 15
[  154.790099] queue: 0
[  154.816089] cpu: 15
[  154.816094] queue: 0
[  154.816108] cpu: 15
[  154.816113] queue: 0
[  154.816125] cpu: 15
[  154.816129] queue: 0
[  154.841096] cpu: 15
[  154.841102] queue: 0
[  155.858439] .cpu: 15
[  155.858444] queue: 0
[  155.858457] cpu: 15
[  155.858462] queue: 0
[  155.881504] cpu: 15
[  155.881510] queue: 0
[  155.881523] cpu: 15
[  155.881528] queue: 0
[  155.881539] cpu: 15
[  155.881544] queue: 0
[  155.906153] cpu: 15
[  155.906159] queue: 0
[  155.906173] cpu: 15
[  155.906178] queue: 0
[  155.906189] cpu: 15
[  155.906194] queue: 0
[  155.906925] cpu: 15
[  155.906930] queue: 0
[  156.928432] .cpu: 15
[  156.928437] queue: 0
[  156.928448] cpu: 15
[  156.928453] queue: 0
[  156.950445] cpu: 15
[  156.950451] queue: 0
[  156.950465] cpu: 15
[  156.950470] queue: 0
[  156.950481] cpu: 15
[  156.950485] queue: 0
[  156.976142] cpu: 15
[  156.976148] queue: 0
[  156.976162] cpu: 15
[  156.976167] queue: 0
[  156.976178] cpu: 15
[  156.976183] queue: 0
[  156.976915] cpu: 15
[  156.976920] queue: 0
[  157.988424] .cpu: 15
[  157.988429] queue: 0
[  157.988441] cpu: 15
[  157.988445] queue: 0
[  158.005841] cpu: 15
[  158.005846] queue: 0
[  158.005860] cpu: 15
[  158.005865] queue: 0
[  158.005876] cpu: 15
[  158.005881] queue: 0
[  158.030497] cpu: 15
[  158.030503] queue: 0
[  158.030517] cpu: 15
[  158.030522] queue: 0
[  158.030533] cpu: 15
[  158.030537] queue: 0
[  158.031270] cpu: 15
[  158.031275] queue: 0
[  159.048419] .cpu: 15
[  159.048425] queue: 0
[  159.048436] cpu: 15
[  159.048441] queue: 0
[  159.049176] cpu: 15
[  159.049182] queue: 0
[  159.049196] cpu: 15
[  159.049201] queue: 0
[  159.049212] cpu: 15
[  159.049216] queue: 0
[  159.073742] cpu: 15
[  159.073748] queue: 0
[  159.073761] cpu: 15
[  159.073766] queue: 0
[  159.073777] cpu: 15
[  159.073781] queue: 0
[  159.099436] cpu: 15
[  159.099442] queue: 0
[  160.118411] .cpu: 15
[  160.118416] queue: 0
[  160.118428] cpu: 15
[  160.118432] queue: 0
[  160.143735] cpu: 15
[  160.143740] queue: 0
[  160.143754] cpu: 15
[  160.143759] queue: 0
[  160.143770] cpu: 15
[  160.143775] queue: 0
[  160.168432] cpu: 15
[  160.168439] queue: 0
[  160.168453] cpu: 15
[  160.168458] queue: 0
[  160.168469] cpu: 15
[  160.168473] queue: 0
[  160.169209] cpu: 15
[  160.169214] queue: 0
[  161.188403] .cpu: 15
[  161.188408] queue: 0
[  161.188420] cpu: 15
[  161.188425] queue: 0
[  161.210587] cpu: 15
[  161.210593] queue: 0
[  161.210606] cpu: 15
[  161.210611] queue: 0
[  161.210622] cpu: 15
[  161.210627] queue: 0
[  161.235241] cpu: 15
[  161.235247] queue: 0
[  161.235261] cpu: 15
[  161.235266] queue: 0
[  161.235277] cpu: 15
[  161.235281] queue: 0
[  161.236012] cpu: 15
[  161.236018] queue: 0
[  162.258391] .cpu: 15
[  162.258396] queue: 0
[  162.258408] cpu: 15
[  162.258412] queue: 0
[  162.279541] cpu: 15
[  162.279547] queue: 0
[  162.279560] cpu: 15
[  162.279565] queue: 0
[  162.279576] cpu: 15
[  162.279580] queue: 0
[  162.305228] cpu: 15
[  162.305234] queue: 0
[  162.305248] cpu: 15
[  162.305253] queue: 0
[  162.305264] cpu: 15
[  162.305269] queue: 0
[  162.306000] cpu: 15
[  162.306006] queue: 0
[  163.328383] .cpu: 15
[  163.328389] queue: 0
[  163.328400] cpu: 15
[  163.328405] queue: 0
[  163.346388] cpu: 15
[  163.346394] queue: 0
[  163.346409] cpu: 15
[  163.346414] queue: 0
[  163.346424] cpu: 15
[  163.346429] queue: 0
[  163.372086] cpu: 15
[  163.372091] queue: 0
[  163.372106] cpu: 15
[  163.372110] queue: 0
[  163.372122] cpu: 15
[  163.372126] queue: 0
[  163.372856] cpu: 15
[  163.372862] queue: 0
[  164.398379] .cpu: 15
[  164.398384] queue: 0
[  164.398395] cpu: 15
[  164.398400] queue: 0
[  164.416378] cpu: 15
[  164.416384] queue: 0
[  164.416397] cpu: 15
[  164.416402] queue: 0
[  164.416413] cpu: 15
[  164.416417] queue: 0
[  164.441029] cpu: 15
[  164.441035] queue: 0
[  164.441049] cpu: 15
[  164.441054] queue: 0
[  164.441065] cpu: 15
[  164.441070] queue: 0
[  164.441799] cpu: 15
[  164.441804] queue: 0
[  165.458370] .cpu: 15
[  165.458376] queue: 0
[  165.458387] cpu: 15
[  165.458392] queue: 0
[  165.483233] cpu: 15
[  165.483239] queue: 0
[  165.483252] cpu: 15
[  165.483257] queue: 0
[  165.483268] cpu: 15
[  165.483272] queue: 0
[  165.507885] cpu: 15
[  165.507890] queue: 0
[  165.507904] cpu: 15
[  165.507909] queue: 0
[  165.507920] cpu: 15
[  165.507925] queue: 0
[  165.508661] cpu: 15
[  165.508666] queue: 0
[  166.528358] .cpu: 15
[  166.528363] queue: 0
[  166.528375] cpu: 15
[  166.528379] queue: 0
[  166.558431] cpu: 15
[  166.558437] queue: 0
[  166.558451] cpu: 15
[  166.558456] queue: 0
[  166.558467] cpu: 15
[  166.558472] queue: 0
[  166.589347] cpu: 15
[  166.589352] queue: 0
[  166.589367] cpu: 15
[  166.589372] queue: 0
[  166.589382] cpu: 15
[  166.589387] queue: 0
[  166.590126] cpu: 15
[  166.590132] queue: 0
[  167.628352] .cpu: 15
[  167.628358] queue: 0
[  167.628370] cpu: 15
[  167.628374] queue: 0
[  167.645084] cpu: 15
[  167.645090] queue: 0
[  167.645103] cpu: 15
[  167.645108] queue: 0
[  167.645119] cpu: 15
[  167.645124] queue: 0
[  167.669734] cpu: 15
[  167.669740] queue: 0
[  167.669754] cpu: 15
[  167.669759] queue: 0
[  167.669771] cpu: 15
[  167.669775] queue: 0
[  167.670505] cpu: 15
[  167.670510] queue: 0
[  168.728343] .cpu: 15
[  168.728349] queue: 0
[  168.728360] cpu: 15
[  168.728365] queue: 0
[  168.746320] cpu: 15
[  168.746326] queue: 0
[  168.746340] cpu: 15
[  168.746344] queue: 0
[  168.746355] cpu: 15
[  168.746360] queue: 0
[  168.772017] cpu: 15
[  168.772022] queue: 0
[  168.772037] cpu: 15
[  168.772041] queue: 0
[  168.772053] cpu: 15
[  168.772057] queue: 0
[  168.772788] cpu: 15
[  168.772794] queue: 0
[  169.788337] .cpu: 15
[  169.788343] queue: 0
[  169.788354] cpu: 15
[  169.788359] queue: 0
[  169.807973] cpu: 15
[  169.807978] queue: 0
[  169.807992] cpu: 15
[  169.807997] queue: 0
[  169.808008] cpu: 15
[  169.808013] queue: 0
[  169.833658] cpu: 15
[  169.833664] queue: 0
[  169.833678] cpu: 15
[  169.833683] queue: 0
[  169.833694] cpu: 15
[  169.833699] queue: 0
[  169.834429] cpu: 15
[  169.834434] queue: 0
[  170.848323] .cpu: 15
[  170.848328] queue: 0
[  170.848340] cpu: 15
[  170.848345] queue: 0
[  170.870672] cpu: 15
[  170.870677] queue: 0
[  170.870691] cpu: 15
[  170.870696] queue: 0
[  170.870707] cpu: 15
[  170.870712] queue: 0
[  170.895316] cpu: 15
[  170.895322] queue: 0
[  170.895336] cpu: 15
[  170.895341] queue: 0
[  170.895353] cpu: 15
[  170.895357] queue: 0
[  170.896089] cpu: 15
[  170.896094] queue: 0
[  171.928315] .cpu: 15
[  171.928320] queue: 0
[  171.928332] cpu: 15
[  171.928337] queue: 0
[  171.948987] cpu: 15
[  171.948993] queue: 0
[  171.949007] cpu: 15
[  171.949012] queue: 0
[  171.949023] cpu: 15
[  171.949027] queue: 0
[  171.973636] cpu: 15
[  171.973642] queue: 0
[  171.973656] cpu: 15
[  171.973660] queue: 0
[  171.973672] cpu: 15
[  171.973676] queue: 0
[  171.974409] cpu: 15
[  171.974415] queue: 0
[  172.998310] .cpu: 15
[  172.998316] queue: 0
[  172.998327] cpu: 15
[  172.998332] queue: 0
[  173.021053] cpu: 15
[  173.021059] queue: 0
[  173.021072] cpu: 15
[  173.021077] queue: 0
[  173.021088] cpu: 15
[  173.021093] queue: 0
[  173.045705] cpu: 15
[  173.045710] queue: 0
[  173.045724] cpu: 15
[  173.045729] queue: 0
[  173.045740] cpu: 15
[  173.045745] queue: 0
[  173.046477] cpu: 15
[  173.046483] queue: 0
[  174.068302] .cpu: 15
[  174.068307] queue: 0
[  174.068319] cpu: 15
[  174.068324] queue: 0
[  174.085840] cpu: 15
[  174.085845] queue: 0
[  174.085859] cpu: 15
[  174.085864] queue: 0
[  174.085875] cpu: 15
[  174.085880] queue: 0
[  174.133398] cpu: 15
[  174.133404] queue: 0
[  174.133418] cpu: 15
[  174.133423] queue: 0
[  174.133434] cpu: 15
[  174.133438] queue: 0
[  174.134170] cpu: 15
[  174.134176] queue: 0
[  174.592682] NMI watchdog: BUG: soft lockup - CPU#14 stuck for 22s! [swapper/10:1]
[  174.592694] Modules linked in:
[  174.592718] CPU: 14 PID: 1 Comm: swapper/10 Not tainted 3.18.0-rc4-00052-g04689e7-dirty #27
[  174.592733] task: fffff800fe0d0000 ti: fffff800fe094000 task.ti: fffff800fe094000
[  174.592748] TSTATE: 0000004480001604 TPC: 0000000000490f60 TNPC: 0000000000490f64 Y: 00000000    Not tainted
[  174.592772] TPC: <console_unlock+0x440/0x4a0>
[  174.592784] g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000000000 g3: 0000000000000001
[  174.592797] g4: fffff800fe0d0000 g5: fffff800fed30000 g6: fffff800fe094000 g7: fffff800fe040f00
[  174.592809] o0: 0000000000798000 o1: 0000000000000018 o2: 000000000086f6d8 o3: 00000000008dbf50
[  174.592821] o4: 00000000008fcd08 o5: 0000000000000000 sp: fffff800fe096d71 ret_pc: 0000000000490f2c
[  174.592836] RPC: <console_unlock+0x40c/0x4a0>
[  174.592851] l0: 00000000008dbf48 l1: 000000000087f800 l2: 00000000008fcc18 l3: 00000000008fcc38
[  174.592862] l4: 0000000000000000 l5: 00000000008fcd08 l6: 00000000008e4988 l7: 0000000000000004
[  174.592874] i0: 00000000008fcc08 i1: 00000000008fcc38 i2: 0000000000000000 i3: 00000000008fc800
[  174.592886] i4: 00000000008fc800 i5: 00000000008fcbf8 i6: fffff800fe096e31 i7: 0000000000491e8c
[  174.592904] I7: <console_device+0x4c/0x60>
[  174.592910] Call Trace:
[  174.592928]  [0000000000491e8c] console_device+0x4c/0x60
[  174.592969]  [000000000062f660] tty_open+0x4a0/0x600
[  174.593001]  [0000000000513fa8] chrdev_open+0xa8/0x160
[  174.593042]  [000000000050d834] do_dentry_open.isra.13+0x1f4/0x340
[  174.593067]  [000000000051d18c] do_last.isra.45+0x2ec/0xd60
[  174.593087]  [000000000051dc7c] path_openat+0x7c/0x620
[  174.593108]  [000000000051ee9c] do_filp_open+0x1c/0xa0
[  174.593128]  [000000000050ec2c] do_sys_open+0x10c/0x200
[  174.593150]  [00000000008a6b18] kernel_init_freeable+0x168/0x1d0
[  174.593172]  [000000000078e1c4] kernel_init+0x4/0x100
[  174.593205]  [00000000004060c4] ret_from_fork+0x1c/0x2c
[  174.593215]  [0000000000000000]           (null)
[  175.158294] .cpu: 15
[  175.158300] queue: 0
[  175.158311] cpu: 15
[  175.158316] queue: 0
[  175.179771] cpu: 15
[  175.179776] queue: 0
[  175.179791] cpu: 15
[  175.179795] queue: 0
[  175.179806] cpu: 15
[  175.179811] queue: 0
[  175.205467] cpu: 15
[  175.205473] queue: 0
[  175.205487] cpu: 15
[  175.205492] queue: 0
[  175.205503] cpu: 15
[  175.205508] queue: 0
[  175.206239] cpu: 15
[  175.206244] queue: 0
[  176.218285] .cpu: 15
[  176.218290] queue: 0
[  176.218302] cpu: 15
[  176.218307] queue: 0
[  176.236212] cpu: 15
[  176.236218] queue: 0
[  176.236231] cpu: 15
[  176.236236] queue: 0
[  176.236247] cpu: 15
[  176.236252] queue: 0
[  176.260865] cpu: 15
[  176.260870] queue: 0
[  176.260885] cpu: 15
[  176.260889] queue: 0
[  176.260901] cpu: 15
[  176.260905] queue: 0
[  176.261636] cpu: 15
[  176.261641] queue: 0
[  177.288269] .cpu: 15
[  177.288274] queue: 0
[  177.288286] cpu: 15
[  177.288291] queue: 0
[  177.311409] cpu: 15
[  177.311415] queue: 0
[  177.311428] cpu: 15
[  177.311433] queue: 0
[  177.311444] cpu: 15
[  177.311449] queue: 0
[  177.336064] cpu: 15
[  177.336070] queue: 0
[  177.336084] cpu: 15
[  177.336089] queue: 0
[  177.336100] cpu: 15
[  177.336105] queue: 0
[  177.336843] cpu: 15
[  177.336849] queue: 0
[  178.368267] .cpu: 15
[  178.368272] queue: 0
[  178.368284] cpu: 15
[  178.368288] queue: 0
[  178.385561] cpu: 15
[  178.385567] queue: 0
[  178.385581] cpu: 15
[  178.385586] queue: 0
[  178.385597] cpu: 15
[  178.385602] queue: 0
[  178.410231] cpu: 15
[  178.410237] queue: 0
[  178.410252] cpu: 15
[  178.410257] queue: 0
[  178.410268] cpu: 15
[  178.410272] queue: 0
[  178.411005] cpu: 15
[  178.411011] queue: 0
[  179.438258] .cpu: 15
[  179.438264] queue: 0
[  179.438276] cpu: 15
[  179.438280] queue: 0
[  179.459717] cpu: 15
[  179.459722] queue: 0
[  179.459737] cpu: 15
[  179.459742] queue: 0
[  179.459752] cpu: 15
[  179.459757] queue: 0
[  179.484365] cpu: 15
[  179.484371] queue: 0
[  179.484385] cpu: 15
[  179.484390] queue: 0
[  179.484401] cpu: 15
[  179.484406] queue: 0
[  179.485137] cpu: 15
[  179.485142] queue: 0
[  180.518252] .cpu: 15
[  180.518258] queue: 0
[  180.518269] cpu: 15
[  180.518274] queue: 0
[  180.534907] cpu: 15
[  180.534912] queue: 0
[  180.534926] cpu: 15
[  180.534931] queue: 0
[  180.534941] cpu: 15
[  180.534946] queue: 0
[  180.559561] cpu: 15
[  180.559566] queue: 0
[  180.559581] cpu: 15
[  180.559586] queue: 0
[  180.559597] cpu: 15
[  180.559601] queue: 0
[  180.560330] cpu: 15
[  180.560335] queue: 0
[  181.588240] .cpu: 15
[  181.588246] queue: 0
[  181.588257] cpu: 15
[  181.588262] queue: 0
[  181.609064] cpu: 15
[  181.609069] queue: 0
[  181.609083] cpu: 15
[  181.609088] queue: 0
[  181.609099] cpu: 15
[  181.609103] queue: 0
[  181.633714] cpu: 15
[  181.633720] queue: 0
[  181.633734] cpu: 15
[  181.633740] queue: 0
[  181.633751] cpu: 15
[  181.633755] queue: 0
[  181.634486] cpu: 15
[  181.634491] queue: 0
[  182.658232] .cpu: 15
[  182.658238] queue: 0
[  182.658249] cpu: 15
[  182.658254] queue: 0
[  182.683224] cpu: 15
[  182.683230] queue: 0
[  182.683244] cpu: 15
[  182.683249] queue: 0
[  182.683260] cpu: 15
[  182.683265] queue: 0
[  182.707865] cpu: 15
[  182.707871] queue: 0
[  182.707885] cpu: 15
[  182.707890] queue: 0
[  182.707901] cpu: 15
[  182.707906] queue: 0
[  182.708645] cpu: 15
[  182.708651] queue: 0
[  183.738227] .cpu: 15
[  183.738232] queue: 0
[  183.738244] cpu: 15
[  183.738248] queue: 0
[  183.758412] cpu: 15
[  183.758417] queue: 0
[  183.758431] cpu: 15
[  183.758436] queue: 0
[  183.758448] cpu: 15
[  183.758452] queue: 0
[  183.783058] cpu: 15
[  183.783064] queue: 0
[  183.783078] cpu: 15
[  183.783083] queue: 0
[  183.783093] cpu: 15
[  183.783098] queue: 0
[  183.783828] cpu: 15
[  183.783833] queue: 0
[  184.808217] .cpu: 15
[  184.808223] queue: 0
[  184.808234] cpu: 15
[  184.808239] queue: 0
[  184.891949] cpu: 15
[  184.891955] queue: 0
[  184.891968] cpu: 15
[  184.891973] queue: 0
[  184.891984] cpu: 15
[  184.891989] queue: 0
[  185.009321] cpu: 15
[  185.009327] queue: 0
[  185.009341] cpu: 15
[  185.009346] queue: 0
[  185.009357] cpu: 15
[  185.009362] queue: 0
[  185.010092] cpu: 15
[  185.010098] queue: 0
[  186.038206] .cpu: 15
[  186.038212] queue: 0
[  186.038223] cpu: 15
[  186.038228] queue: 0
[  186.093207] cpu: 15
[  186.093212] queue: 0
[  186.093226] cpu: 15
[  186.093231] queue: 0
[  186.093242] cpu: 15
[  186.093246] queue: 0
[  186.152238] cpu: 15
[  186.152244] queue: 0
[  186.152258] cpu: 15
[  186.152263] queue: 0
[  186.152274] cpu: 15
[  186.152278] queue: 0
[  186.153012] cpu: 15
[  186.153018] queue: 0
[  187.178198] .cpu: 15
[  187.178203] queue: 0
[  187.178215] cpu: 15
[  187.178220] queue: 0
[  187.199648] cpu: 15
[  187.199654] queue: 0
[  187.199668] cpu: 15
[  187.199673] queue: 0
[  187.199684] cpu: 15
[  187.199689] queue: 0
[  187.224307] cpu: 15
[  187.224313] queue: 0
[  187.224327] cpu: 15
[  187.224332] queue: 0
[  187.224343] cpu: 15
[  187.224347] queue: 0
[  187.225079] cpu: 15
[  187.225085] queue: 0
[  188.258192] .cpu: 15
[  188.258198] queue: 0
[  188.258209] cpu: 15
[  188.258214] queue: 0
[  188.274850] cpu: 15
[  188.274855] queue: 0
[  188.274869] cpu: 15
[  188.274874] queue: 0
[  188.274885] cpu: 15
[  188.274889] queue: 0
[  188.299495] cpu: 15
[  188.299501] queue: 0
[  188.299515] cpu: 15
[  188.299520] queue: 0
[  188.299531] cpu: 15
[  188.299536] queue: 0
[  188.300267] cpu: 15
[  188.300272] queue: 0
[  189.328180] .cpu: 15
[  189.328185] queue: 0
[  189.328197] cpu: 15
[  189.328202] queue: 0
[  189.348999] cpu: 15
[  189.349004] queue: 0
[  189.349018] cpu: 15
[  189.349023] queue: 0
[  189.349034] cpu: 15
[  189.349038] queue: 0
[  189.373651] cpu: 15
[  189.373657] queue: 0
[  189.373671] cpu: 15
[  189.373676] queue: 0
[  189.373687] cpu: 15
[  189.373692] queue: 0
[  189.374422] cpu: 15
[  189.374428] queue: 0
[  190.398174] .cpu: 15
[  190.398179] queue: 0
[  190.398191] cpu: 15
[  190.398195] queue: 0
[  190.423161] cpu: 15
[  190.423167] queue: 0
[  190.423181] cpu: 15
[  190.423185] queue: 0
[  190.423196] cpu: 15
[  190.423201] queue: 0
[  190.447798] cpu: 15
[  190.447804] queue: 0
[  190.447818] cpu: 15
[  190.447823] queue: 0
[  190.447834] cpu: 15
[  190.447839] queue: 0
[  190.448578] cpu: 15
[  190.448583] queue: 0
[  191.478168] .cpu: 15
[  191.478173] queue: 0
[  191.478184] cpu: 15
[  191.478189] queue: 0
[  191.498353] cpu: 15
[  191.498358] queue: 0
[  191.498373] cpu: 15
[  191.498378] queue: 0
[  191.498389] cpu: 15
[  191.498394] queue: 0
[  191.522991] cpu: 15
[  191.522997] queue: 0
[  191.523010] cpu: 15
[  191.523015] queue: 0
[  191.523026] cpu: 15
[  191.523030] queue: 0
[  191.523760] cpu: 15
[  191.523766] queue: 0
[  192.548157] .cpu: 15
[  192.548162] queue: 0
[  192.548174] cpu: 15
[  192.548178] queue: 0
[  192.572502] cpu: 15
[  192.572507] queue: 0
[  192.572521] cpu: 15
[  192.572526] queue: 0
[  192.572537] cpu: 15
[  192.572542] queue: 0
[  192.597151] cpu: 15
[  192.597157] queue: 0
[  192.597171] cpu: 15
[  192.597176] queue: 0
[  192.597187] cpu: 15
[  192.597192] queue: 0
[  192.597922] cpu: 15
[  192.597927] queue: 0
[  193.628148] .cpu: 15
[  193.628154] queue: 0
[  193.628165] cpu: 15
[  193.628170] queue: 0
[  193.646648] cpu: 15
[  193.646654] queue: 0
[  193.646667] cpu: 15
[  193.646672] queue: 0
[  193.646683] cpu: 15
[  193.646688] queue: 0
[  193.671306] cpu: 15
[  193.671311] queue: 0
[  193.671325] cpu: 15
[  193.671330] queue: 0
[  193.671342] cpu: 15
[  193.671346] queue: 0
[  193.672077] cpu: 15
[  193.672082] queue: 0
[  194.698141] .cpu: 15
[  194.698146] queue: 0
[  194.698158] cpu: 15
[  194.698163] queue: 0
[  194.721849] cpu: 15
[  194.721855] queue: 0
[  194.721869] cpu: 15
[  194.721874] queue: 0
[  194.721885] cpu: 15
[  194.721889] queue: 0
[  194.746494] cpu: 15
[  194.746500] queue: 0
[  194.746514] cpu: 15
[  194.746519] queue: 0
[  194.746530] cpu: 15
[  194.746535] queue: 0
[  194.747266] cpu: 15
[  194.747272] queue: 0
[  195.748140] .cpu: 15
[  195.772134] queue: 0
[  195.798187] cpu: 15
[  195.823182] queue: 0
[  195.849975] cpu: 15
[  195.874246] queue: 0
[  195.900289] cpu: 15
[  195.925283] queue: 0
[  195.951340] cpu: 15
[  195.976335] queue: 0
[  196.003117] cpu: 15
[  196.027428] queue: 0
[  196.053447] cpu: 15
[  196.078440] queue: 0
[  196.104501] cpu: 15
[  196.129490] queue: 0
[  196.156270] cpu: 15
[  196.180551] queue: 0
[  197.208166] .cpu: 15
[  197.232187] queue: 0
[  197.258244] cpu: 15
[  197.283240] queue: 0
[  197.310028] cpu: 15
[  197.334301] queue: 0
[  197.360349] cpu: 15
[  197.385338] queue: 0
[  197.411392] cpu: 15
[  197.436393] queue: 0
[  197.463176] cpu: 15
[  197.487485] queue: 0
[  197.513503] cpu: 15
[  197.538497] queue: 0
[  197.564547] cpu: 15
[  197.589545] queue: 0
[  197.616328] cpu: 15
[  197.640609] queue: 0
[  198.668108] .cpu: 15
[  198.692135] queue: 0
[  198.718194] cpu: 15
[  198.743192] queue: 0
[  198.769979] cpu: 15
[  198.794253] queue: 0
[  198.820302] cpu: 15
[  198.845293] queue: 0
[  198.871342] cpu: 15
[  198.896344] queue: 0
[  198.923125] cpu: 15
[  198.947434] queue: 0
[  198.973455] cpu: 15
[  198.998446] queue: 0
[  199.024495] cpu: 15
[  199.049492] queue: 0
[  199.076277] cpu: 15
[  199.100564] queue: 0
[  200.128110] .cpu: 15
[  200.152087] queue: 0
[  200.178144] cpu: 15
[  200.203144] queue: 0
[  200.229923] cpu: 15
[  200.254201] queue: 0
[  200.280252] cpu: 15
[  200.305246] queue: 0
[  200.331292] cpu: 15
[  200.356295] queue: 0
[  200.383072] cpu: 15
[  200.407384] queue: 0
[  200.433408] cpu: 15
[  200.458397] queue: 0
[  200.484447] cpu: 15
[  200.509450] queue: 0
[  200.536231] cpu: 15
[  200.560508] queue: 0
[  201.588099] .cpu: 15
[  201.612139] queue: 0
[  201.638196] cpu: 15
[  201.663200] queue: 0
[  201.689976] cpu: 15
[  201.714263] queue: 0
[  201.740303] cpu: 15
[  201.765302] queue: 0
[  201.791350] cpu: 15
[  201.816347] queue: 0
[  201.843127] cpu: 15
[  201.867441] queue: 0
[  201.893458] cpu: 15
[  201.918453] queue: 0
[  201.944503] cpu: 15
[  201.969504] queue: 0
[  201.996281] cpu: 15
[  202.020565] queue: 0
[  203.048082] .cpu: 15
[  203.072090] queue: 0
[  203.098156] cpu: 15
[  203.123150] queue: 0
[  203.149929] cpu: 15
[  203.174210] queue: 0
[  203.200254] cpu: 15
[  203.225251] queue: 0
[  203.251302] cpu: 15
[  203.276302] queue: 0
[  203.303086] cpu: 15
[  203.327394] queue: 0
[  203.353411] cpu: 15
[  203.378401] queue: 0
[  203.404458] cpu: 15
[  203.429456] queue: 0
[  203.456242] cpu: 15
[  203.480513] queue: 0
[  204.508066] .cpu: 15
[  204.532044] queue: 0
[  204.558098] cpu: 15
[  204.583094] queue: 0
[  204.609882] cpu: 15
[  204.634162] queue: 0
[  204.660208] cpu: 15
[  204.685197] queue: 0
[  204.711251] cpu: 15
[  204.736248] queue: 0
[  204.763029] cpu: 15
[  204.787345] queue: 0
[  204.813363] cpu: 15
[  204.838352] queue: 0
[  204.864403] cpu: 15
[  204.889406] queue: 0
[  204.916186] cpu: 15
[  204.940464] queue: 0
[  205.968065] .cpu: 15
[  205.992101] queue: 0
[  206.018154] cpu: 15
[  206.043151] queue: 0
[  206.069944] cpu: 15
[  206.094215] queue: 0
[  206.120263] cpu: 15
[  206.145259] queue: 0
[  206.171308] cpu: 15
[  206.196306] queue: 0
[  206.223088] cpu: 15
[  206.247402] queue: 0
[  206.273419] cpu: 15
[  206.298410] queue: 0
[  206.324463] cpu: 15
[  206.349460] queue: 0
[  206.376244] cpu: 15
[  206.400524] queue: 0
[  207.428054] .cpu: 15
[  207.452052] queue: 0
[  207.478108] cpu: 15
[  207.503101] queue: 0
[  207.529888] cpu: 15
[  207.554168] queue: 0
[  207.580215] cpu: 15
[  207.605207] queue: 0
[  207.631261] cpu: 15
[  207.656258] queue: 0
[  207.683050] cpu: 15
[  207.707347] queue: 0
[  207.733366] cpu: 15
[  207.758357] queue: 0
[  207.784411] cpu: 15
[  207.809412] queue: 0
[  207.836193] cpu: 15
[  207.860474] queue: 0
[  208.888043] .cpu: 15
[  208.911999] queue: 0
[  208.938058] cpu: 15
[  208.963055] queue: 0
[  208.989835] cpu: 15
[  209.014120] queue: 0
[  209.040162] cpu: 15
[  209.065159] queue: 0
[  209.091203] cpu: 15
[  209.116211] queue: 0
[  209.142985] cpu: 15
[  209.167300] queue: 0
[  209.193320] cpu: 15
[  209.218310] queue: 0
[  209.244364] cpu: 15
[  209.269361] queue: 0
[  209.296145] cpu: 15
[  209.320420] queue: 0
[  210.348015] .cpu: 15
[  210.372057] queue: 0
[  210.398111] cpu: 15
[  210.423114] queue: 0
[  210.449894] cpu: 15
[  210.474172] queue: 0
[  210.500218] cpu: 15
[  210.525214] queue: 0
[  210.551266] cpu: 15
[  210.576262] queue: 0
[  210.603064] cpu: 15
[  210.627354] queue: 0
[  210.653376] cpu: 15
[  210.678363] queue: 0
[  210.704415] cpu: 15
[  210.729414] queue: 0
[  210.756196] cpu: 15
[  210.780476] queue: 0
[  211.808019] .cpu: 15
[  211.832008] queue: 0
[  211.858061] cpu: 15
[  211.883058] queue: 0
[  211.909844] cpu: 15
[  211.934121] queue: 0
[  211.960172] cpu: 15
[  211.985163] queue: 0
[  212.011214] cpu: 15
[  212.036217] queue: 0
[  212.062989] cpu: 15
[  212.087302] queue: 0
[  212.113325] cpu: 15
[  212.138314] queue: 0
[  212.164364] cpu: 15
[  212.189366] queue: 0
[  212.216150] cpu: 15
[  212.240431] queue: 0
[  213.268008] .cpu: 15
[  213.291954] queue: 0
[  213.318016] cpu: 15
[  213.343009] queue: 0
[  213.369790] cpu: 15
[  213.394078] queue: 0
[  213.420121] cpu: 15
[  213.445110] queue: 0
[  213.471168] cpu: 15
[  213.496162] queue: 0
[  213.522945] cpu: 15
[  213.547259] queue: 0
[  213.573275] cpu: 15
[  213.598265] queue: 0
[  213.624319] cpu: 15
[  213.649316] queue: 0
[  213.676100] cpu: 15
[  213.700379] queue: 0
[  214.727989] .cpu: 15
[  214.752011] queue: 0
[  214.778066] cpu: 15
[  214.803064] queue: 0
[  214.829853] cpu: 15
[  214.854127] queue: 0
[  214.880178] cpu: 15
[  214.905168] queue: 0
[  214.931221] cpu: 15
[  214.956223] queue: 0
[  214.982997] cpu: 15
[  215.007313] queue: 0
[  215.033328] cpu: 15
[  215.058320] queue: 0
[  215.084370] cpu: 15
[  215.109376] queue: 0
[  215.136156] cpu: 15
[  215.160433] queue: 0
[  216.187968] .cpu: 15
[  216.211963] queue: 0
[  216.238016] cpu: 15
[  216.263019] queue: 0
[  216.289799] cpu: 15
[  216.314077] queue: 0
[  216.340123] cpu: 15
[  216.365118] queue: 0
[  216.391170] cpu: 15
[  216.416167] queue: 0
[  216.442954] cpu: 15
[  216.467264] queue: 0
[  216.493278] cpu: 15
[  216.518275] queue: 0
[  216.544327] cpu: 15
[  216.569323] queue: 0
[  216.596106] cpu: 15
[  216.620385] queue: 0
[  217.647975] .cpu: 15
[  217.672020] queue: 0
[  217.698078] cpu: 15
[  217.723074] queue: 0
[  217.749851] cpu: 15
[  217.774136] queue: 0
[  217.800183] cpu: 15
[  217.825173] queue: 0
[  217.851231] cpu: 15
[  217.876226] queue: 0
[  217.903004] cpu: 15
[  217.927321] queue: 0
[  217.953337] cpu: 15
[  217.978328] queue: 0
[  218.004383] cpu: 15
[  218.029380] queue: 0
[  218.056163] cpu: 15
[  218.080439] queue: 0
[  219.107964] .cpu: 15
[  219.131970] queue: 0
[  219.158028] cpu: 15
[  219.183021] queue: 0
[  219.209816] cpu: 15
[  219.234089] queue: 0
[  219.260134] cpu: 15
[  219.285127] queue: 0
[  219.311181] cpu: 15
[  219.336176] queue: 0
[  219.362961] cpu: 15
[  219.387266] queue: 0
[  219.413290] cpu: 15
[  219.438282] queue: 0
[  219.464332] cpu: 15
[  219.489330] queue: 0
[  219.516114] cpu: 15
[  219.540394] queue: 0
[  220.567951] .cpu: 15
[  220.591920] queue: 0
[  220.617980] cpu: 15
[  220.642972] queue: 0
[  220.669755] cpu: 15
[  220.694038] queue: 0
[  220.720087] cpu: 15
[  220.745078] queue: 0
[  220.771129] cpu: 15
[  220.796126] queue: 0
[  220.822915] cpu: 15
[  220.847220] queue: 0
[  220.873236] cpu: 15
[  220.898227] queue: 0
[  220.924278] cpu: 15
[  220.949281] queue: 0
[  220.976063] cpu: 15
[  221.000341] queue: 0
[  222.027911] .cpu: 15
[  222.051875] queue: 0
[  222.077926] cpu: 15
[  222.102934] queue: 0
[  222.129709] cpu: 15
[  222.153986] queue: 0
[  222.180035] cpu: 15
[  222.205025] queue: 0
[  222.231077] cpu: 15
[  222.256080] queue: 0
[  222.282859] cpu: 15
[  222.307171] queue: 0
[  222.333191] cpu: 15
[  222.358182] queue: 0
[  222.384235] cpu: 15
[  222.409230] queue: 0
[  222.436012] cpu: 15
[  222.460291] queue: 0
[  223.487932] .cpu: 15
[  223.511924] queue: 0
[  223.537985] cpu: 15
[  223.562982] queue: 0
[  223.589765] cpu: 15
[  223.614048] queue: 0
[  223.640087] cpu: 15
[  223.665087] queue: 0
[  223.691139] cpu: 15
[  223.716135] queue: 0
[  223.742918] cpu: 15
[  223.767229] queue: 0
[  223.793248] cpu: 15
[  223.818239] queue: 0
[  223.844285] cpu: 15
[  223.869289] queue: 0
[  223.896064] cpu: 15
[  223.920346] queue: 0
[  224.947917] .cpu: 15
[  224.971881] queue: 0
[  224.997931] cpu: 15
[  225.022936] queue: 0
[  225.049715] cpu: 15
[  225.073992] queue: 0
[  225.100045] cpu: 15
[  225.125031] queue: 0
[  225.151091] cpu: 15
[  225.176086] queue: 0
[  225.202866] cpu: 15
[  225.227175] queue: 0
[  225.253197] cpu: 15
[  225.278186] queue: 0
[  225.304238] cpu: 15
[  225.329236] queue: 0
[  225.356023] cpu: 15
[  225.380301] queue: 0
[  226.407906] .cpu: 15
[  226.431933] queue: 0
[  226.457986] cpu: 15
[  226.482990] queue: 0
[  226.509766] cpu: 15
[  226.534050] queue: 0
[  226.560095] cpu: 15
[  226.585083] queue: 0
[  226.611165] cpu: 15
[  226.636143] queue: 0
[  226.662933] cpu: 15
[  226.687203] queue: 0
[  226.713253] cpu: 15
[  226.738242] queue: 0
[  226.764295] cpu: 15
[  226.789291] queue: 0
[  226.816075] cpu: 15
[  226.840355] queue: 0
[  227.867893] .cpu: 15
[  227.891880] queue: 0
[  227.917941] cpu: 15
[  227.942939] queue: 0
[  227.969713] cpu: 15
[  227.994002] cpu: 15
[  227.994007] queue: 0
[  228.045043] queue: 0
[  228.071095] cpu: 15
[  228.096084] queue: 0
[  228.122145] cpu: 15
[  228.147170] queue: 0
[  228.173927] cpu: 15
[  228.198204] queue: 0
[  228.224247] cpu: 15
[  228.249244] queue: 0
[  228.275295] cpu: 15
[  228.300293] queue: 0
[  228.327073] cpu: 15
[  228.351355] queue: 0
[  229.377884] .cpu: 15
[  229.401847] queue: 0
[  229.427897] cpu: 15
[  229.452894] queue: 0
[  229.479688] cpu: 15
[  229.503962] queue: 0
[  229.530009] cpu: 15
[  229.554999] queue: 0
[  229.581055] cpu: 15
[  229.606049] queue: 0
[  229.632830] cpu: 15
[  229.657145] queue: 0
[  229.683164] cpu: 15
[  229.708155] queue: 0
[  229.734204] cpu: 15
[  229.759202] queue: 0
[  229.785987] cpu: 15
[  229.810267] queue: 0
[  230.837865] .cpu: 15
[  230.861901] queue: 0
[  230.887957] cpu: 15
[  230.912953] queue: 0
[  230.939735] cpu: 15
[  230.964013] queue: 0
[  230.990063] cpu: 15
[  231.015057] queue: 0
[  231.041110] cpu: 15
[  231.066103] queue: 0
[  231.092884] cpu: 15
[  231.117203] queue: 0
[  231.143218] cpu: 15
[  231.168207] queue: 0
[  231.194264] cpu: 15
[  231.219260] queue: 0
[  231.246042] cpu: 15
[  231.270320] queue: 0
[  232.297858] .cpu: 15
[  232.321849] queue: 0
[  232.347902] cpu: 15
[  232.372906] queue: 0
[  232.399690] cpu: 15
[  232.423968] queue: 0
[  232.450015] cpu: 15
[  232.475003] queue: 0
[  232.501056] cpu: 15
[  232.526054] queue: 0
[  232.552838] cpu: 15
[  232.577148] queue: 0
[  232.603166] cpu: 15
[  232.628158] queue: 0
[  232.654211] cpu: 15
[  232.679213] queue: 0
[  232.705989] cpu: 15
[  232.730269] queue: 0
[  233.757852] .cpu: 15
[  233.781901] queue: 0
[  233.807958] cpu: 15
[  233.832957] queue: 0
[  233.859743] cpu: 15
[  233.884023] queue: 0
[  233.910069] cpu: 15
[  233.935060] queue: 0
[  233.961109] cpu: 15
[  233.986117] cpu: 15
[  233.986122] queue: 0
[  234.037196] queue: 0
[  234.063953] cpu: 15
[  234.088222] queue: 0
[  234.114275] cpu: 15
[  234.139263] queue: 0
[  234.165319] cpu: 15
[  234.190315] queue: 0
[  234.217092] cpu: 15
[  234.241378] queue: 0
[  235.267837] .cpu: 15
[  235.291862] queue: 0
[  235.317924] cpu: 15
[  235.342921] queue: 0
[  235.369706] cpu: 15
[  235.393978] queue: 0
[  235.420033] cpu: 15
[  235.445024] queue: 0
[  235.471070] cpu: 15
[  235.496074] queue: 0
[  235.522857] cpu: 15
[  235.547163] queue: 0
[  235.573185] cpu: 15
[  235.598176] queue: 0
[  235.624228] cpu: 15
[  235.649226] queue: 0
[  235.676007] cpu: 15
[  235.700287] queue: 0
[  236.727825] .cpu: 15
[  236.751818] queue: 0
[  236.777872] cpu: 15
[  236.802872] queue: 0
[  236.829654] cpu: 15
[  236.853934] queue: 0
[  236.879975] cpu: 15
[  236.904972] queue: 0
[  236.931024] cpu: 15
[  236.956020] queue: 0
[  236.982800] cpu: 15
[  237.007115] queue: 0
[  237.033134] cpu: 15
[  237.058125] queue: 0
[  237.084176] cpu: 15
[  237.109176] queue: 0
[  237.135957] cpu: 15
[  237.160238] queue: 0
[  238.187815] .cpu: 15
[  238.211769] queue: 0
[  238.237822] cpu: 15
[  238.262821] queue: 0
[  238.289603] cpu: 15
[  238.313880] queue: 0
[  238.339931] cpu: 15
[  238.364927] queue: 0
[  238.390976] cpu: 15
[  238.415975] queue: 0
[  238.442756] cpu: 15
[  238.467063] queue: 0
[  238.493088] cpu: 15
[  238.518078] queue: 0
[  238.544127] cpu: 15
[  238.569121] queue: 0
[  238.595931] cpu: 15
[  238.620193] queue: 0
[  239.647801] .cpu: 15
[  239.671822] queue: 0
[  239.697878] cpu: 15
[  239.722875] queue: 0
[  239.749663] cpu: 15
[  239.773934] queue: 0
[  239.799986] cpu: 15
[  239.824975] queue: 0
[  239.851027] cpu: 15
[  239.876032] queue: 0
[  239.902808] cpu: 15
[  239.927118] queue: 0
[  239.953143] cpu: 15
[  239.978135] queue: 0
[  240.004184] cpu: 15
[  240.029181] queue: 0
[  240.055963] cpu: 15
[  240.080246] queue: 0
[  241.107791] .cpu: 15
[  241.131771] queue: 0
[  241.157825] cpu: 15
[  241.182829] queue: 0
[  241.209611] cpu: 15
[  241.233890] queue: 0
[  241.259938] cpu: 15
[  241.284929] queue: 0
[  241.310980] cpu: 15
[  241.335977] queue: 0
[  241.362755] cpu: 15
[  241.387075] queue: 0
[  241.413089] cpu: 15
[  241.438085] queue: 0
[  241.464133] cpu: 15
[  241.489131] queue: 0
[  241.515912] cpu: 15
[  241.540196] queue: 0
[  242.567773] .cpu: 15
[  242.591751] queue: 0
[  242.617787] cpu: 15
[  242.642781] queue: 0
[  242.669572] cpu: 15
[  242.693843] queue: 0
[  242.719885] cpu: 15
[  242.744880] queue: 0
[  242.770930] cpu: 15
[  242.795931] queue: 0
[  242.822710] cpu: 15
[  242.847020] queue: 0
[  242.873045] cpu: 15
[  242.898029] queue: 0
[  242.924082] cpu: 15
[  242.949082] queue: 0
[  242.975865] cpu: 15
[  243.000147] queue: 0
[  244.027770] .cpu: 15
[  244.051776] queue: 0
[  244.077833] cpu: 15
[  244.102836] queue: 0
[  244.129616] cpu: 15
[  244.153896] queue: 0
[  244.179939] cpu: 15
[  244.204933] queue: 0
[  244.230987] cpu: 15
[  244.255984] queue: 0
[  244.282768] cpu: 15
[  244.307073] queue: 0
[  244.333096] cpu: 15
[  244.358085] queue: 0
[  244.384144] cpu: 15
[  244.409141] queue: 0
[  244.435928] cpu: 15
[  244.460200] queue: 0
[  245.487756] .cpu: 15
[  245.511730] queue: 0
[  245.537788] cpu: 15
[  245.562783] queue: 0
[  245.589565] cpu: 15
[  245.613847] queue: 0
[  245.639894] cpu: 15
[  245.664883] queue: 0
[  245.690937] cpu: 15
[  245.715935] queue: 0
[  245.742717] cpu: 15
[  245.767026] queue: 0
[  245.793045] cpu: 15
[  245.818036] queue: 0
[  245.844090] cpu: 15
[  245.869088] queue: 0
[  245.895872] cpu: 15
[  245.920149] queue: 0
[  246.947734] .cpu: 15
[  246.971783] queue: 0
[  246.997840] cpu: 15
[  247.022835] queue: 0
[  247.049632] cpu: 15
[  247.073902] queue: 0
[  247.099950] cpu: 15
[  247.124938] queue: 0
[  247.150992] cpu: 15
[  247.175992] queue: 0
[  247.202770] cpu: 15
[  247.227080] queue: 0
[  247.253100] cpu: 15
[  247.278095] queue: 0
[  247.304145] cpu: 15
[  247.329148] queue: 0
[  247.355927] cpu: 15
[  247.380206] queue: 0
[  248.407736] .cpu: 15
[  248.431736] queue: 0
[  248.457789] cpu: 15
[  248.482789] queue: 0
[  248.509573] cpu: 15
[  248.533856] queue: 0
[  248.559896] cpu: 15
[  248.584890] queue: 0
[  248.610945] cpu: 15
[  248.635944] queue: 0
[  248.662722] cpu: 15
[  248.687032] queue: 0
[  248.713058] cpu: 15
[  248.738045] queue: 0
[  248.764097] cpu: 15
[  248.789094] queue: 0
[  248.815882] cpu: 15
[  248.840155] queue: 0
[  249.867724] .cpu: 15
[  249.891687] queue: 0
[  249.917741] cpu: 15
[  249.942743] queue: 0
[  249.969527] cpu: 15
[  249.993807] queue: 0
[  250.019850] cpu: 15
[  250.044841] queue: 0
[  250.070892] cpu: 15
[  250.095893] queue: 0
[  250.122679] cpu: 15
[  250.146983] queue: 0
[  250.173009] cpu: 15
[  250.197999] queue: 0
[  250.224049] cpu: 15
[  250.249046] queue: 0
[  250.275826] cpu: 15
[  250.300107] queue: 0
[  251.327714] .cpu: 15
[  251.351744] queue: 0
[  251.377797] cpu: 15
[  251.402797] queue: 0
[  251.429582] cpu: 15
[  251.453857] queue: 0
[  251.479903] cpu: 15
[  251.504899] queue: 0
[  251.530950] cpu: 15
[  251.555946] queue: 0
[  251.582735] cpu: 15
[  251.607040] queue: 0
[  251.633060] cpu: 15
[  251.658049] queue: 0
[  251.684105] cpu: 15
[  251.709102] queue: 0
[  251.735887] cpu: 15
[  251.760163] queue: 0
[  252.787699] .cpu: 15
[  252.811692] queue: 0
[  252.837749] cpu: 15
[  252.862744] queue: 0
[  252.889532] cpu: 15
[  252.913811] queue: 0
[  252.939853] cpu: 15
[  252.964847] queue: 0
[  252.990909] cpu: 15
[  253.015898] queue: 0
[  253.042684] cpu: 15
[  253.066990] queue: 0
[  253.093005] cpu: 15
[  253.118006] queue: 0
[  253.144057] cpu: 15
[  253.169055] queue: 0
[  253.195835] cpu: 15
[  253.220116] queue: 0
[  254.247689] .not responding...
[  254.282071] cpu: 15
[  254.307067] queue: 0
[  254.333132] cpu: 15
[  254.358124] queue: 0
[  254.384937] cpu: 15
[  254.409185] queue: 0
[  254.435224] cpu: 15
[  254.460222] queue: 0
[  254.486278] cpu: 15
[  254.511311] queue: 0
[  254.538084] cpu: 15
[  254.562333] queue: 0
[  254.588396] cpu: 15
[  254.613390] queue: 0
[  254.639438] cpu: 15
[  254.664437] queue: 0
[  254.691236] cpu: 15
[  254.715487] queue: 0
[  254.741547] sd 0:0:2:0: [sdc] READ CAPACITY failed
[  254.798879] sd 0:0:2:0: [sdc]  
[  254.836340] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  254.903036] sd 0:0:2:0: [sdc]  
[  254.940525] Sense Key : Not Ready [current] 
[  254.991546] sd 0:0:2:0: [sdc]  
[  255.029090] Add. Sense: Logical unit not ready, cause not reportable
[  255.105108] cpu: 15
[  255.130136] queue: 0
[  255.156192] cpu: 15
[  255.181189] queue: 0
[  255.207989] cpu: 15
[  255.232251] queue: 0
[  255.258298] cpu: 15
[  255.283287] queue: 0
[  255.309347] cpu: 15
[  255.334338] queue: 0
[  255.361177] cpu: 15
[  255.385400] queue: 0
[  255.411448] cpu: 15
[  255.436443] queue: 0
[  255.462509] cpu: 15
[  255.487492] queue: 0
[  255.514297] cpu: 15
[  255.538554] queue: 0
[  255.564607] sd 0:0:2:0: [sdc] Test WP failed, assume Write Enabled
[  255.638612] cpu: 15
[  255.663567] queue: 0
[  255.689621] cpu: 15
[  255.714619] queue: 0
[  255.741416] cpu: 15
[  255.765678] queue: 0
[  255.791731] sd 0:0:2:0: [sdc] Asking for cache data failed
[  255.857376] sd 0:0:2:0: [sdc] Assuming drive cache: write through
[  255.930331] cpu: 15
[  255.955286] queue: 0
[  255.981346] cpu: 15
[  256.006337] queue: 0
[  256.032936] cpu: 15
[  256.057396] queue: 0
[  256.085028] cpu: 15
[  256.108465] queue: 0
[  256.134496] cpu: 15
[  256.159492] queue: 0
[  256.185633] cpu: 15
[  256.210621] queue: 0
[  256.236607] cpu: 15
[  256.236705] cpu: 15
[  256.236712] queue: 0
[  256.236742] cpu: 10
[  256.236749] queue: 809119744
[  256.236773] Unable to handle kernel paging request at virtual address fffff8027fd26000
[  256.236780] tsk->{mm,active_mm}->context = 0000000000000000
[  256.236788] tsk->{mm,active_mm}->pgd = fffff80000402000
[  256.236797]               \|/ ____ \|/
[  256.236797]               "@'/ .. \`@"
[  256.236797]               /_| \__/ |_\
[  256.236797]                  \__U_/
[  256.236809] kworker/u8:4(48): Oops [#1]
[  256.236839] CPU: 10 PID: 48 Comm: kworker/u8:4 Tainted: G             L 3.18.0-rc4-00052-g04689e7-dirty #27
[  256.236894] Workqueue: events_unbound async_run_entry_fn
[  256.236908] task: fffff800fe7b0c00 ti: fffff800fd010000 task.ti: fffff800fd010000
[  256.236925] TSTATE: 0000004480001602 TPC: 00000000005f1f1c TNPC: 00000000005f357c Y: 00000000    Tainted: G             L
[  256.236965] TPC: <blk_mq_map_queue+0x3c/0x40>
[  256.236979] g0: fffff800fd012f31 g1: fffff800fe00e898 g2: 0000000000000001 g3: 00000000008fcc00
[  256.236992] g4: fffff800fe7b0c00 g5: fffff800feb30000 g6: fffff800fd010000 g7: 0000000000000010
[  256.237005] o0: fffff800fe7e1a40 o1: 0000000000000028 o2: fffff800fe7e2070 o3: fffff800fd013780
[  256.237018] o4: fffff800fe7e2058 o5: 0000000181d18000 sp: fffff800fd012f91 ret_pc: 00000000005f3574
[  256.237042] RPC: <blk_mq_alloc_request+0x54/0x120>
[  256.237059] l0: fffff800fd013800 l1: fffff800fe03aba0 l2: 00000000007ae7b0 l3: fffff800fd0201b3
[  256.237070] l4: 000000000081fe63 l5: fffff800fd02091c l6: 0000000000000004 l7: 0000000000000000
[  256.237083] i0: fffff800fe7e1a40 i1: 0000000000000000 i2: 0000000000000010 i3: 0000000000000000
[  256.237096] i4: 00000000008d40c0 i5: fffff800ff408a80 i6: fffff800fd013061 i7: 000000000066c284
[  256.237133] I7: <scsi_execute+0x24/0x140>
[  256.237140] Call Trace:
[  256.237161]  [000000000066c284] scsi_execute+0x24/0x140
[  256.237184]  [000000000066c4bc] scsi_execute_req_flags+0x5c/0xe0
[  256.237209]  [0000000000681978] sd_revalidate_disk+0xd8/0x1ea0
[  256.237229]  [0000000000683908] sd_probe_async+0xc8/0x160
[  256.237255]  [000000000046fc94] async_run_entry_fn+0x34/0x100
[  256.237292]  [000000000046827c] process_one_work+0x15c/0x340
[  256.237316]  [0000000000468bf0] worker_thread+0x110/0x520
[  256.237337]  [000000000046d528] kthread+0xa8/0xe0
[  256.237378]  [00000000004060c4] ret_from_fork+0x1c/0x2c
[  256.237389]  [0000000000000000]           (null)
[  256.237396] Disabling lock debugging due to kernel taint
[  256.237420] Caller[000000000066c284]: scsi_execute+0x24/0x140
[  256.237443] Caller[000000000066c4bc]: scsi_execute_req_flags+0x5c/0xe0
[  256.237463] Caller[0000000000681978]: sd_revalidate_disk+0xd8/0x1ea0
[  256.237483] Caller[0000000000683908]: sd_probe_async+0xc8/0x160
[  256.237509] Caller[000000000046fc94]: async_run_entry_fn+0x34/0x100
[  256.237533] Caller[000000000046827c]: process_one_work+0x15c/0x340
[  256.237556] Caller[0000000000468bf0]: worker_thread+0x110/0x520
[  256.262424] Caller[000000000046d528]: kthread+0xa8/0xe0
[  256.262449] Caller[00000000004060c4]: ret_from_fork+0x1c/0x2c
[  256.262458] Caller[0000000000000000]:           (null)
[  256.262509] Instruction DUMP: bb2f7003  c25e20f0  81cfe008 <d058400d> 9de3bf50  c2062124  fa062120  82007fff  80a06000 
[  256.262526] note: kworker/u8:4[48] exited with preempt_count 1
[  256.286642] Unable to handle kernel paging request at virtual address ffffffffffffe000
[  256.286649] tsk->{mm,active_mm}->context = 0000000000000000
[  256.286656] tsk->{mm,active_mm}->pgd = fffff80000402000
[  256.286662]               \|/ ____ \|/
[  256.286662]               "@'/ .. \`@"
[  256.286662]               /_| \__/ |_\
[  256.286662]                  \__U_/
[  256.286672] kworker/u8:4(48): Oops [#2]
[  256.286694] CPU: 10 PID: 48 Comm: kworker/u8:4 Tainted: G      D      L 3.18.0-rc4-00052-g04689e7-dirty #27
[  256.286734] task: fffff800fe7b0c00 ti: fffff800fd010000 task.ti: fffff800fd010000
[  256.286751] TSTATE: 0000000011e01601 TPC: 000000000046db08 TNPC: 000000000046908c Y: fcf8b569    Tainted: G      D      L
[  256.286772] TPC: <kthread_data+0x8/0x20>
[  256.286786] g0: 00000000008fcc38 g1: 0000000000000000 g2: 0000000014e2ff9d g3: ffffffffff76abc0
[  256.286799] g4: fffff800fe7b0c00 g5: fffff800feb30000 g6: fffff800fd010000 g7: ffffffffff76abc0
[  256.286812] o0: fffff800fe7b0c00 o1: fffff800fe7b0c00 o2: 0000000000000001 o3: fffff800ff402840
[  256.286825] o4: fffff800fe7b0c90 o5: fffff800ff402840 sp: fffff800fd0129b1 ret_pc: 0000000000469084
[  256.286848] RPC: <wq_worker_sleeping+0x4/0xe0>
[  256.286863] l0: 000000000080b6f0 l1: 0000000000866000 l2: 000000000000000e l3: 0000000000000004
[  256.286873] l4: 0000000000000000 l5: 0000000000000030 l6: 0000000000000006 l7: 0000000000000000
[  256.286885] i0: fffff800fe7b0c00 i1: 000000000000000a i2: 0000000000000001 i3: 0000000000000000
[  256.286897] i4: 0000000000000000 i5: fffff800ff400e38 i6: fffff800fd012a61 i7: 0000000000791954
[  256.286932] I7: <switch_to_pc+0x198/0x3a4>
[  256.286937] Call Trace:
[  256.286959]  [0000000000791954] switch_to_pc+0x198/0x3a4
[  256.287011]  [0000000000454bd4] do_exit+0x5f4/0x9e0
[  256.287036]  [0000000000428744] die_if_kernel+0x184/0x300
[  256.287062]  [0000000000790214] unhandled_fault+0x84/0x90
[  256.287087]  [0000000000444298] do_sparc64_fault+0x498/0x6e0
[  256.287113]  [0000000000407bcc] sparc64_realfault_common+0x10/0x20
[  256.287142]  [00000000005f1f1c] blk_mq_map_queue+0x3c/0x40
[  256.287169]  [000000000066c284] scsi_execute+0x24/0x140
[  256.287193]  [000000000066c4bc] scsi_execute_req_flags+0x5c/0xe0
[  256.287215]  [0000000000681978] sd_revalidate_disk+0xd8/0x1ea0
[  256.287235]  [0000000000683908] sd_probe_async+0xc8/0x160
[  256.287262]  [000000000046fc94] async_run_entry_fn+0x34/0x100
[  256.287287]  [000000000046827c] process_one_work+0x15c/0x340
[  256.287310]  [0000000000468bf0] worker_thread+0x110/0x520
[  256.287330]  [000000000046d528] kthread+0xa8/0xe0
[  256.287356]  [00000000004060c4] ret_from_fork+0x1c/0x2c
[  256.287382] Caller[0000000000791954]: switch_to_pc+0x198/0x3a4
[  256.287408] Caller[0000000000454bd4]: do_exit+0x5f4/0x9e0
[  256.287428] Caller[0000000000428744]: die_if_kernel+0x184/0x300
[  256.287452] Caller[0000000000790214]: unhandled_fault+0x84/0x90
[  256.287474] Caller[0000000000444298]: do_sparc64_fault+0x498/0x6e0
[  256.287495] Caller[0000000000407bcc]: sparc64_realfault_common+0x10/0x20
[  256.287527] Caller[00000000005f3574]: blk_mq_alloc_request+0x54/0x120
[  256.287550] Caller[000000000066c284]: scsi_execute+0x24/0x140
[  256.287573] Caller[000000000066c4bc]: scsi_execute_req_flags+0x5c/0xe0
[  256.287594] Caller[0000000000681978]: sd_revalidate_disk+0xd8/0x1ea0
[  256.287613] Caller[0000000000683908]: sd_probe_async+0xc8/0x160
[  256.287638] Caller[000000000046fc94]: async_run_entry_fn+0x34/0x100
[  256.287663] Caller[000000000046827c]: process_one_work+0x15c/0x340
[  256.287685] Caller[0000000000468bf0]: worker_thread+0x110/0x520
[  256.287705] Caller[000000000046d528]: kthread+0xa8/0xe0
[  256.287729] Caller[00000000004060c4]: ret_from_fork+0x1c/0x2c
[  256.287738] Caller[0000000000000000]:           (null)
[  256.287787] Instruction DUMP: 01000000  c25a2358  81c3e008 <d0587fd8> 30680005  01000000  01000000  01000000  01000000 
[  256.287793] Fixing recursive fault but reboot is needed!
[  256.287806] BUG: scheduling while atomic: kworker/u8:4/48/0x00000005
[  256.287814] Modules linked in:
[  256.287836] CPU: 10 PID: 48 Comm: kworker/u8:4 Tainted: G      D      L 3.18.0-rc4-00052-g04689e7-dirty #27
[  256.287863] Call Trace:
[  256.287902]  [0000000000471780] __schedule_bug+0x40/0x60
[  256.287934]  [0000000000791a5c] switch_to_pc+0x2a0/0x3a4
[  256.287968]  [0000000000454dc4] do_exit+0x7e4/0x9e0
[  256.287997]  [0000000000428744] die_if_kernel+0x184/0x300
[  256.288029]  [0000000000790214] unhandled_fault+0x84/0x90
[  256.288059]  [0000000000444298] do_sparc64_fault+0x498/0x6e0
[  256.288089]  [0000000000407bcc] sparc64_realfault_common+0x10/0x20
[  256.288116]  [000000000046db08] kthread_data+0x8/0x20
[  256.288148]  [0000000000791954] switch_to_pc+0x198/0x3a4
[  256.288181]  [0000000000454bd4] do_exit+0x5f4/0x9e0
[  256.288209]  [0000000000428744] die_if_kernel+0x184/0x300
[  256.288241]  [0000000000790214] unhandled_fault+0x84/0x90
[  256.288271]  [0000000000444298] do_sparc64_fault+0x498/0x6e0
[  256.288299]  [0000000000407bcc] sparc64_realfault_common+0x10/0x20
[  256.288337]  [00000000005f1f1c] blk_mq_map_queue+0x3c/0x40
[  256.288369]  [000000000066c284] scsi_execute+0x24/0x140
[  259.019395] cpu: 15
[  259.019400] queue: 0
[  265.455953] queue: 0



-- 
Meelis Roos (mroos@linux.ee)
