From: Meelis Roos <mroos@linux.ee>
Subject: Another (ESP?) scsi blk-mq problem on sparc64
Date: Fri, 14 Nov 2014 13:32:36 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

I sort-of repaired my Sun E3000 (currently 4xCPU SBus-only with ESP SCSI 
and QLogic PTI scsi). It works fine with 3.17+sparc64 patches, it fails 
when scsi_mod.use_blk_mq=1 in 3.17 or 3.18-rc4+git. It works with 
scsi_mod.use_blk_mq=0 always.

This is after the previous ESP fix has been applied upstream. The 
problem happens after ESP has detected the disks but it seems ESP is the 
only scsi driver loaded.

The kernel is 3.18.0-rc4-00052-g04689e7-dirty where dirty part means 
previous sparc64 irq rcu patch by Paul E. McKenney has been applied.

I did a test boot with esp_scsi.esp_debug=0x7ff, below are the dmesg 
from it and config. Note that without esp_debug I do not see RCU hang 
warning, esp_debug seems to make it slower and trigger it - so RCU may 
be not related at all.

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.18.0-rc4-00052-g04689e7-dirty (mroos@mandel) (gcc version 4.9.2 (Debian 4.9.2-1) ) #25 SMP Fri Nov 14 11:34:12 EET 2014
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
[    0.000000] Kernel command line: root=/dev/sda2 ro ignore_loglevel esp_scsi.esp_debug=0x7ff
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 4142488K/4187472K available (3653K kernel code, 246K rwdata, 800K rodata, 184K init, 413K bss, 44984K reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[  275.731385] clocksource: mult[2042108] shift[23]
[  275.785993] clockevent: mult[3f7ced91] shift[32]
[  275.841490] Console: colour dummy device 80x25
[  275.894421] console [tty0] enabled
[  275.935000] bootconsole [earlyprom0] disabled
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.18.0-rc4-00052-g04689e7-dirty (mroos@mandel) (gcc version 4.9.2 (Debian 4.9.2-1) ) #25 SMP Fri Nov 14 11:34:12 EET 2014
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
[    0.000000] Kernel command line: root=/dev/sda2 ro ignore_loglevel esp_scsi.esp_debug=0x7ff
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 4142488K/4187472K available (3653K kernel code, 246K rwdata, 800K rodata, 184K init, 413K bss, 44984K reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[  275.731385] clocksource: mult[2042108] shift[23]
[  275.785993] clockevent: mult[3f7ced91] shift[32]
[  275.841490] Console: colour dummy device 80x25
[  275.894421] console [tty0] enabled
[  275.935000] bootconsole [earlyprom0] disabled
[  276.137269] Calibrating delay using timer specific routine.. 497.41 BogoMIPS (lpj=2487079)
[  276.137340] pid_max: default: 32768 minimum: 301
[  276.137768] Mount-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  276.137831] Mountpoint-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  276.148740] CPU 11: synchronized TICK with master CPU (last diff -3 cycles, maxerr 521 cycles)
[  276.153198] CPU 14: synchronized TICK with master CPU (last diff -3 cycles, maxerr 537 cycles)
[  276.157655] CPU 15: synchronized TICK with master CPU (last diff -3 cycles, maxerr 537 cycles)
[  276.157856] Brought up 4 CPUs
[  276.159961] devtmpfs: initialized
[  276.233391] device-tree: Duplicate name in base, renamed to "fhc#1"
[  276.236120] device-tree: Duplicate name in base, renamed to "fhc#2"
[  276.238668] device-tree: Duplicate name in base, renamed to "counter-timer#1"
[  276.240165] NET: Registered protocol family 16
[  276.257048] SYSIO: UPA portID ffffffff, at 000001c400000000
[  276.267693] SYSIO: UPA portID ffffffff, at 000001c600000000
[  276.321979] SCSI subsystem initialized
[  276.324994] /central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
[  276.326013] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
[  276.326378] fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
[  276.326720] fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
[  276.327070] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
[  276.327560] clock_board: Detected 4 slot Enterprise system.
[  276.328333] Switched to clocksource tick
[  276.355015] NET: Registered protocol family 2
[  276.357514] TCP established hash table entries: 32768 (order: 5, 262144 bytes)
[  276.359268] TCP bind hash table entries: 32768 (order: 6, 524288 bytes)
[  276.362361] TCP: Hash tables configured (established 32768 bind 32768)
[  276.363142] TCP: reno registered
[  276.363229] UDP hash table entries: 2048 (order: 3, 65536 bytes)
[  276.363764] UDP-Lite hash table entries: 2048 (order: 3, 65536 bytes)
[  276.365149] NET: Registered protocol family 1
[  276.370093] futex hash table entries: 1024 (order: 3, 65536 bytes)
[  276.370720] audit: initializing netlink subsys (disabled)
[  276.371083] audit: type=2000 audit(0.409:1): initialized
[  276.372482] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[  276.411727] msgmni has been set to 8090
[  276.414718] io scheduler noop registered
[  276.415914] io scheduler cfq registered (default)
[  276.624974] zs f005ddbc: ttyS0 at MMIO 0x1fff8902000 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  276.625082] Console: ttyS0 (SunZilog zs0)
[  282.679696] console [ttyS0] enabled
[  282.722366] zs f005ddbc: ttyS1 at MMIO 0x1fff8902004 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  283.036885] f005de94: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
[  283.113060] f005de94: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
[  283.190748] esp: esp0, regs[1c738810000:1c738800000] irq[19]
[  283.256525] esp: esp0 is a FASHME, 40 MHz (ccf=0), SCSI ID 7
[  286.328380] scsi host0: esp
[  286.361803] ESP: tgt[0] lun[0] scsi_cmd [ [  286.363597] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[  286.364676] TCP: cubic registered
[  286.366832] NET: Registered protocol family 10
[  286.369451] NET: Registered protocol family 17

[  286.632696] 12 00 00 00 24 00 ]
[  286.672402] rtc-m48t59 rtc-m48t59.0: setting system clock to 2014-11-14 11:02:29 UTC (1415962949)
[  286.778577] ESP: intr sreg[91] seqreg[00] sreg2[00] ireg[18]
[  286.778604] ESP: start data addr[c0003800] len[36] write(1)
[  286.778701] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  286.778718] ESP: data done flgs[1] sent[36]
[  286.778739] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  286.778759] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  286.778768] ESP: Command done status[0] message[0]
[  286.779039] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  286.846273] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  286.846289] ESP: start data addr[c0005800] len[144] write(1)
[  286.846411] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  286.846425] ESP: data done flgs[1] sent[144]
[  286.846444] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  286.846464] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  286.846473] ESP: Command done status[0] message[0]
[  286.846647] scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  286.846735] scsi target0:0:0: Beginning Domain Validation
[  286.846814] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  286.846860] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  286.846889] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  286.846895] ESP: Got msgin byte 4
[  286.846915] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  286.846926] ESP: Disconnecting tgt[0] tag[20:0]
[  286.912962] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  286.913007] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  286.913034] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  286.913047] ESP: start data addr[c0006000] len[144] write(1)
[  286.913171] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  286.913186] ESP: data done flgs[1] sent[144]
[  286.913205] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  286.913224] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  286.913233] ESP: Command done status[0] message[0]
[  286.913367] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  286.913411] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  286.913440] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  286.913445] ESP: Got msgin byte 4
[  286.913464] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  286.913475] ESP: Disconnecting tgt[0] tag[20:0]
[  286.980680] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  286.980725] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  286.980742] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  286.980754] ESP: start data addr[c0008090] len[144] write(1)
[  286.980880] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  286.980894] ESP: data done flgs[1] sent[144]
[  286.980913] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  286.980933] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  286.980941] ESP: Command done status[0] message[0]
[  286.981078] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  286.981122] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  286.981151] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  286.981156] ESP: Got msgin byte 4
[  286.981175] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  286.981186] ESP: Disconnecting tgt[0] tag[20:0]
[  287.030689] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  287.030734] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.030751] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  287.030763] ESP: start data addr[c000a090] len[144] write(1)
[  287.030893] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.030907] ESP: data done flgs[1] sent[144]
[  287.030926] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.030945] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.030953] ESP: Command done status[0] message[0]
[  287.031090] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.031134] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  287.031163] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  287.031168] ESP: Got msgin byte 4
[  287.031187] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  287.031198] ESP: Disconnecting tgt[0] tag[20:0]
[  287.098407] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  287.098452] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.098469] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  287.098481] ESP: start data addr[c000c090] len[144] write(1)
[  287.098602] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.098616] ESP: data done flgs[1] sent[144]
[  287.098636] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.098655] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.098663] ESP: Command done status[0] message[0]
[  287.098803] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.098849] ESP: intr sreg[96] seqreg[04] sreg2[00] ireg[18]
[  287.098878] ESP: Sending message [ 20 00 01 02 03 01 ]
[  287.099143] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.099176] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.099181] ESP: Got msgin byte 1
[  287.099231] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.099257] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.099261] ESP: Got msgin byte 2
[  287.099307] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.099347] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.099351] ESP: Got msgin byte 3
[  287.099400] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.099426] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.099431] ESP: Got msgin byte 1
[  287.166127] ESP: intr sreg[92] seqreg[01] sreg2[80] ireg[10]
[  287.166156] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.166182] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.166187] ESP: Got msgin byte 4
[  287.166205] ESP: intr sreg[90] seqreg[01] sreg2[20] ireg[20]
[  287.166215] ESP: Disconnecting tgt[0] tag[20:0]
[  287.223427] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[0c]
[  287.223468] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.223495] ESP: intr sreg[91] seqreg[01] sreg2[00] ireg[10]
[  287.223508] ESP: start data addr[c000e090] len[144] write(1)
[  287.223621] ESP: intr sreg[93] seqreg[01] sreg2[00] ireg[10]
[  287.223635] ESP: data done flgs[1] sent[144]
[  287.223654] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[08]
[  287.223673] ESP: intr sreg[90] seqreg[01] sreg2[00] ireg[20]
[  287.223681] ESP: Command done status[0] message[0]
[  287.223821] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.223866] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[18]
[  287.223894] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  287.223900] ESP: Got msgin byte 4
[  287.223919] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  287.223930] ESP: Disconnecting tgt[0] tag[20:0]
[  287.292192] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  287.292238] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.292255] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  287.292267] ESP: start data addr[c0010090] len[144] write(1)
[  287.292374] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.292388] ESP: data done flgs[1] sent[144]
[  287.292407] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.292427] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.292435] ESP: Command done status[0] message[0]
[  287.292572] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.292617] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  287.292645] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  287.292651] ESP: Got msgin byte 4
[  287.292670] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  287.292681] ESP: Disconnecting tgt[0] tag[20:0]
[  287.359913] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  287.359958] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.359974] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  287.359986] ESP: start data addr[c0012090] len[144] write(1)
[  287.360088] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.360102] ESP: data done flgs[1] sent[144]
[  287.360121] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.360141] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.360149] ESP: Command done status[0] message[0]
[  287.360295] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.360340] ESP: intr sreg[96] seqreg[04] sreg2[00] ireg[18]
[  287.360368] ESP: Sending message [ 20 00 01 02 03 01 ]
[  287.360645] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.360681] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.360686] ESP: Got msgin byte 1
[  287.360736] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.360760] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.360765] ESP: Got msgin byte 2
[  287.360812] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.360851] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.360856] ESP: Got msgin byte 3
[  287.360906] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.360946] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.360951] ESP: Got msgin byte 1
[  287.427632] ESP: intr sreg[96] seqreg[01] sreg2[80] ireg[10]
[  287.427654] ESP: Sending message [ 01 03 01 19 0f ]
[  287.427944] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.427978] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.427982] ESP: Got msgin byte 1
[  287.428032] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.428073] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.428077] ESP: Got msgin byte 3
[  287.428114] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.428147] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.428151] ESP: Got msgin byte 1
[  287.428189] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.428221] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.428226] ESP: Got msgin byte 19
[  287.428274] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.428299] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.428304] ESP: Got msgin byte f
[  287.428353] scsi target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  287.428470] ESP: intr sreg[92] seqreg[01] sreg2[80] ireg[10]
[  287.428499] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  287.428523] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  287.428528] ESP: Got msgin byte 4
[  287.428545] ESP: intr sreg[90] seqreg[01] sreg2[20] ireg[20]
[  287.428555] ESP: Disconnecting tgt[0] tag[20:0]
[  287.495353] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[0c]
[  287.495395] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.495422] ESP: intr sreg[91] seqreg[01] sreg2[00] ireg[10]
[  287.495435] ESP: start data addr[c0014090] len[144] write(1)
[  287.495526] ESP: intr sreg[93] seqreg[01] sreg2[00] ireg[10]
[  287.495540] ESP: data done flgs[1] sent[144]
[  287.495558] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[08]
[  287.495578] ESP: intr sreg[90] seqreg[01] sreg2[00] ireg[20]
[  287.495586] ESP: Command done status[0] message[0]
[  287.495731] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.495776] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[18]
[  287.495805] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  287.495810] ESP: Got msgin byte 4
[  287.495829] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  287.495840] ESP: Disconnecting tgt[0] tag[20:0]
[  287.546405] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  287.546449] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.546466] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  287.546478] ESP: start data addr[c0016090] len[144] write(1)
[  287.546581] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.546595] ESP: data done flgs[1] sent[144]
[  287.546614] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.546633] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.546642] ESP: Command done status[0] message[0]
[  287.546778] ESP: tgt[0] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.546823] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  287.546851] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  287.546857] ESP: Got msgin byte 4
[  287.546876] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  287.546887] ESP: Disconnecting tgt[0] tag[20:0]
[  287.614123] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  287.614165] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.614191] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  287.614204] ESP: start data addr[c0018090] len[144] write(1)
[  287.614295] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.614309] ESP: data done flgs[1] sent[144]
[  287.614328] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.614347] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.614355] ESP: Command done status[0] message[0]
[  287.614448] scsi target0:0:0: Domain Validation skipping write tests
[  287.614464] scsi target0:0:0: Ending Domain Validation
[  287.614830] ESP: tgt[0] lun[1] scsi_cmd [ 12 20 00 00 24 00 ]
[  287.681850] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  287.681871] ESP: start data addr[c001b800] len[36] write(1)
[  287.681961] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[10]
[  287.681976] ESP: data done flgs[1] sent[36]
[  287.681996] ESP: intr sreg[97] seqreg[03] sreg2[00] ireg[08]
[  287.682016] ESP: intr sreg[90] seqreg[03] sreg2[00] ireg[20]
[  287.682025] ESP: Command done status[0] message[0]
[  287.682287] ESP: tgt[0] lun[1] scsi_cmd [ 12 20 00 00 90 00 ]
[  287.739151] ESP: intr sreg[91] seqreg[03] sreg2[00] ireg[18]
[  287.739170] ESP: start data addr[c001d800] len[144] write(1)
[  287.739265] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[10]
[  287.739281] ESP: data done flgs[1] sent[144]
[  287.739300] ESP: intr sreg[97] seqreg[03] sreg2[00] ireg[08]
[  287.739320] ESP: intr sreg[90] seqreg[03] sreg2[00] ireg[20]
[  287.739329] ESP: Command done status[0] message[0]
[  287.739864] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  287.836052] ESP: intr sreg[91] seqreg[03] sreg2[00] ireg[18]
[  287.836070] ESP: start data addr[c001f800] len[36] write(1)
[  287.836163] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.836178] ESP: data done flgs[1] sent[36]
[  287.836197] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.836217] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.836226] ESP: Command done status[0] message[0]
[  287.836474] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.900650] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  287.900670] ESP: start data addr[c0021800] len[144] write(1)
[  287.900795] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.900811] ESP: data done flgs[1] sent[144]
[  287.900831] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.900851] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.900860] ESP: Command done status[0] message[0]
[  287.901038] scsi 0:0:1:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  287.901087] scsi target0:0:1: Beginning Domain Validation
[  287.901160] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.901240] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  287.901270] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  287.901276] ESP: Got msgin byte 4
[  287.901295] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  287.901306] ESP: Disconnecting tgt[1] tag[20:0]
[  287.969412] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  287.969459] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  287.969475] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  287.969488] ESP: start data addr[c0022000] len[144] write(1)
[  287.969623] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  287.969639] ESP: data done flgs[1] sent[144]
[  287.969658] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  287.969678] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  287.969687] ESP: Command done status[0] message[0]
[  287.969902] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  287.969974] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  287.970004] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  287.970010] ESP: Got msgin byte 4
[  287.970029] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  287.970041] ESP: Disconnecting tgt[1] tag[20:0]
[  288.037128] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  288.037180] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.037196] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  288.037209] ESP: start data addr[c0024090] len[144] write(1)
[  288.037336] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.037352] ESP: data done flgs[1] sent[144]
[  288.037371] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.037391] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.037400] ESP: Command done status[0] message[0]
[  288.037603] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  288.037677] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  288.037707] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  288.037712] ESP: Got msgin byte 4
[  288.037732] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  288.037743] ESP: Disconnecting tgt[1] tag[20:0]
[  288.104854] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  288.104899] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.104925] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  288.104938] ESP: start data addr[c0026090] len[144] write(1)
[  288.105065] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.105080] ESP: data done flgs[1] sent[144]
[  288.105100] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.105120] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.105129] ESP: Command done status[0] message[0]
[  288.105337] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  288.105411] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  288.105441] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  288.105446] ESP: Got msgin byte 4
[  288.105465] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  288.105477] ESP: Disconnecting tgt[1] tag[20:0]
[  288.144478] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  288.144522] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.144538] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  288.144550] ESP: start data addr[c0028090] len[144] write(1)
[  288.144680] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.144696] ESP: data done flgs[1] sent[144]
[  288.144715] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.144735] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.144744] ESP: Command done status[0] message[0]
[  288.144868] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  288.144946] ESP: intr sreg[96] seqreg[04] sreg2[00] ireg[18]
[  288.144976] ESP: Sending message [ 20 00 01 02 03 01 ]
[  288.145252] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.145292] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.145298] ESP: Got msgin byte 1
[  288.145346] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.145372] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.145376] ESP: Got msgin byte 2
[  288.145423] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.145461] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.145465] ESP: Got msgin byte 3
[  288.212156] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.212182] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.212187] ESP: Got msgin byte 1
[  288.212297] ESP: intr sreg[92] seqreg[01] sreg2[80] ireg[10]
[  288.212327] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.212352] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.212356] ESP: Got msgin byte 4
[  288.212376] ESP: intr sreg[90] seqreg[01] sreg2[20] ireg[20]
[  288.212387] ESP: Disconnecting tgt[1] tag[20:0]
[  288.266339] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[0c]
[  288.266395] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.266411] ESP: intr sreg[91] seqreg[01] sreg2[00] ireg[10]
[  288.266424] ESP: start data addr[c002a090] len[144] write(1)
[  288.266540] ESP: intr sreg[93] seqreg[01] sreg2[00] ireg[10]
[  288.266555] ESP: data done flgs[1] sent[144]
[  288.266574] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[08]
[  288.266594] ESP: intr sreg[90] seqreg[01] sreg2[00] ireg[20]
[  288.266603] ESP: Command done status[0] message[0]
[  288.266824] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  288.266898] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[18]
[  288.266928] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  288.266934] ESP: Got msgin byte 4
[  288.266953] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  288.266964] ESP: Disconnecting tgt[1] tag[20:0]
[  288.334056] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  288.334103] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.334120] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  288.334132] ESP: start data addr[c002c090] len[144] write(1)
[  288.334237] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.334251] ESP: data done flgs[1] sent[144]
[  288.334271] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.334291] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.334300] ESP: Command done status[0] message[0]
[  288.334528] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  288.334603] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  288.334633] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  288.334639] ESP: Got msgin byte 4
[  288.334659] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  288.334670] ESP: Disconnecting tgt[1] tag[20:0]
[  288.410112] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  288.410156] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.410183] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  288.410195] ESP: start data addr[c002e090] len[144] write(1)
[  288.410313] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.410328] ESP: data done flgs[1] sent[144]
[  288.410347] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.410367] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.410376] ESP: Command done status[0] message[0]
[  288.410599] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  288.410674] ESP: intr sreg[96] seqreg[04] sreg2[00] ireg[18]
[  288.410704] ESP: Sending message [ 20 00 01 02 03 01 ]
[  288.410970] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.411006] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.411011] ESP: Got msgin byte 1
[  288.411060] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.411087] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.411092] ESP: Got msgin byte 2
[  288.477831] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.477878] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.477883] ESP: Got msgin byte 3
[  288.477932] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.477969] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.477974] ESP: Got msgin byte 1
[  288.478030] ESP: intr sreg[96] seqreg[01] sreg2[80] ireg[10]
[  288.478052] ESP: Sending message [ 01 03 01 19 0f ]
[  288.478366] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.478406] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.478411] ESP: Got msgin byte 1
[  288.478460] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.478486] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.478490] ESP: Got msgin byte 3
[  288.478536] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.478574] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.478578] ESP: Got msgin byte 1
[  288.478613] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.478649] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.478654] ESP: Got msgin byte 19
[  288.478700] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.478727] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.478731] ESP: Got msgin byte f
[  288.478774] scsi target0:0:1: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  288.545550] ESP: intr sreg[92] seqreg[01] sreg2[80] ireg[10]
[  288.545581] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  288.545608] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  288.545613] ESP: Got msgin byte 4
[  288.545631] ESP: intr sreg[90] seqreg[01] sreg2[20] ireg[20]
[  288.545642] ESP: Disconnecting tgt[1] tag[20:0]
[  288.613280] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[0c]
[  288.613339] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.613356] ESP: intr sreg[91] seqreg[01] sreg2[00] ireg[10]
[  288.613370] ESP: start data addr[c0030090] len[144] write(1)
[  288.613480] ESP: intr sreg[93] seqreg[01] sreg2[00] ireg[10]
[  288.613495] ESP: data done flgs[1] sent[144]
[  288.613514] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[08]
[  288.613534] ESP: intr sreg[90] seqreg[01] sreg2[00] ireg[20]
[  288.613543] ESP: Command done status[0] message[0]
[  288.613669] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  288.613748] ESP: intr sreg[97] seqreg[01] sreg2[00] ireg[18]
[  288.613778] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  288.613783] ESP: Got msgin byte 4
[  288.613802] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  288.613814] ESP: Disconnecting tgt[1] tag[20:0]
[  288.664331] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  288.664385] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.664401] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  288.664414] ESP: start data addr[c0032090] len[144] write(1)
[  288.664507] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.664522] ESP: data done flgs[1] sent[144]
[  288.664542] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.664562] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.664571] ESP: Command done status[0] message[0]
[  288.664713] ESP: tgt[1] lun[0] scsi_cmd [ 12 00 00 00 90 00 ]
[  288.664789] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  288.664819] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  288.664824] ESP: Got msgin byte 4
[  288.664843] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  288.664855] ESP: Disconnecting tgt[1] tag[20:0]
[  288.732050] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  288.732094] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  288.732123] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  288.732136] ESP: start data addr[c0034090] len[144] write(1)
[  288.732240] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.732255] ESP: data done flgs[1] sent[144]
[  288.732274] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.732294] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.732303] ESP: Command done status[0] message[0]
[  288.732390] scsi target0:0:1: Domain Validation skipping write tests
[  288.732405] scsi target0:0:1: Ending Domain Validation
[  288.732705] ESP: tgt[1] lun[1] scsi_cmd [ 12 20 00 00 24 00 ]
[  288.799772] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  288.799792] ESP: start data addr[c0037800] len[36] write(1)
[  288.799884] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[10]
[  288.799899] ESP: data done flgs[1] sent[36]
[  288.799918] ESP: intr sreg[97] seqreg[03] sreg2[00] ireg[08]
[  288.799938] ESP: intr sreg[90] seqreg[03] sreg2[00] ireg[20]
[  288.799948] ESP: Command done status[0] message[0]
[  288.800178] ESP: tgt[1] lun[1] scsi_cmd [ 12 20 00 00 90 00 ]
[  288.857071] ESP: intr sreg[91] seqreg[03] sreg2[00] ireg[18]
[  288.857090] ESP: start data addr[c0039800] len[144] write(1)
[  288.857204] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[10]
[  288.857220] ESP: data done flgs[1] sent[144]
[  288.857239] ESP: intr sreg[97] seqreg[03] sreg2[00] ireg[08]
[  288.857259] ESP: intr sreg[90] seqreg[03] sreg2[00] ireg[20]
[  288.857269] ESP: Command done status[0] message[0]
[  288.857729] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  288.925831] ESP: intr sreg[91] seqreg[03] sreg2[00] ireg[18]
[  288.925850] ESP: start data addr[c003b800] len[36] write(1)
[  288.926002] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.926018] ESP: data done flgs[1] sent[36]
[  288.926039] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.926059] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.926068] ESP: Command done status[0] message[0]
[  288.926256] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  288.993571] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  288.993589] ESP: start data addr[c003d800] len[164] write(1)
[  288.993999] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  288.994016] ESP: data done flgs[1] sent[164]
[  288.994037] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  288.994057] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  288.994066] ESP: Command done status[0] message[0]
[  288.994212] scsi 0:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
[  288.994260] scsi target0:0:2: Beginning Domain Validation
[  288.994332] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.061272] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  289.061291] ESP: start data addr[c003e000] len[164] write(1)
[  289.061841] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  289.061857] ESP: data done flgs[1] sent[164]
[  289.061878] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  289.061898] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  289.061907] ESP: Command done status[0] message[0]
[  289.062027] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.100861] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  289.100893] ESP: start data addr[c00400a4] len[164] write(1)
[  289.101047] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  289.101063] ESP: data done flgs[1] sent[164]
[  289.101084] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  289.101104] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  289.101113] ESP: Command done status[0] message[0]
[  289.101237] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.168586] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  289.168604] ESP: start data addr[c00420a4] len[164] write(1)
[  289.169164] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  289.169180] ESP: data done flgs[1] sent[164]
[  289.169200] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  289.169220] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  289.169230] ESP: Command done status[0] message[0]
[  289.169354] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.222757] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  289.222776] ESP: start data addr[c00440a4] len[164] write(1)
[  289.222931] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  289.222947] ESP: data done flgs[1] sent[164]
[  289.222967] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  289.222987] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  289.222997] ESP: Command done status[0] message[0]
[  289.223121] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.223199] ESP: intr sreg[96] seqreg[04] sreg2[00] ireg[18]
[  289.223230] ESP: Sending message [ 20 00 01 02 03 01 ]
[  289.223413] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.223438] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.223444] ESP: Got msgin byte 1
[  289.223478] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.223501] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.223505] ESP: Got msgin byte 2
[  289.223538] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.223561] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.223566] ESP: Got msgin byte 3
[  289.223599] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.223622] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.223626] ESP: Got msgin byte 1
[  289.223669] ESP: intr sreg[92] seqreg[01] sreg2[80] ireg[10]
[  289.290476] ESP: intr sreg[91] seqreg[01] sreg2[80] ireg[10]
[  289.290490] ESP: start data addr[c00460a4] len[164] write(1)
[  289.290670] ESP: intr sreg[93] seqreg[01] sreg2[80] ireg[10]
[  289.290686] ESP: data done flgs[1] sent[164]
[  289.290707] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[08]
[  289.290727] ESP: intr sreg[90] seqreg[01] sreg2[80] ireg[20]
[  289.290737] ESP: Command done status[0] message[0]
[  289.290860] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.291125] ESP: intr sreg[91] seqreg[01] sreg2[80] ireg[18]
[  289.291143] ESP: start data addr[c00480a4] len[164] write(1)
[  289.366529] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  289.366544] ESP: data done flgs[1] sent[164]
[  289.366577] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  289.366597] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  289.366606] ESP: Command done status[0] message[0]
[  289.366766] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.367090] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  289.367108] ESP: start data addr[c004a0a4] len[164] write(1)
[  289.367239] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  289.367253] ESP: data done flgs[1] sent[164]
[  289.367274] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  289.367294] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  289.367303] ESP: Command done status[0] message[0]
[  289.367432] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.367510] ESP: intr sreg[96] seqreg[04] sreg2[80] ireg[18]
[  289.367540] ESP: Sending message [ 20 00 01 02 03 01 ]
[  289.434251] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.434278] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.434298] ESP: Got msgin byte 1
[  289.434330] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.434353] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.434358] ESP: Got msgin byte 2
[  289.434401] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.434425] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.434429] ESP: Got msgin byte 3
[  289.434461] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.434484] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.434488] ESP: Got msgin byte 1
[  289.434523] ESP: intr sreg[96] seqreg[01] sreg2[80] ireg[10]
[  289.434545] ESP: Sending message [ 01 03 01 19 0f ]
[  289.434621] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.434645] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.434650] ESP: Got msgin byte 1
[  289.434684] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.434707] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.434712] ESP: Got msgin byte 3
[  289.435114] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.435138] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.435143] ESP: Got msgin byte 1
[  289.435176] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.435199] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.435204] ESP: Got msgin byte 19
[  289.435238] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[10]
[  289.435261] ESP: intr sreg[97] seqreg[01] sreg2[20] ireg[08]
[  289.435265] ESP: Got msgin byte f
[  289.435308] scsi target0:0:2: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  289.501972] ESP: intr sreg[92] seqreg[01] sreg2[80] ireg[10]
[  289.502565] ESP: intr sreg[91] seqreg[01] sreg2[80] ireg[10]
[  289.502580] ESP: start data addr[c004c0a4] len[164] write(1)
[  289.502703] ESP: intr sreg[93] seqreg[01] sreg2[80] ireg[10]
[  289.502717] ESP: data done flgs[1] sent[164]
[  289.502737] ESP: intr sreg[97] seqreg[01] sreg2[80] ireg[08]
[  289.502758] ESP: intr sreg[90] seqreg[01] sreg2[80] ireg[20]
[  289.502767] ESP: Command done status[0] message[0]
[  289.502891] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.569696] ESP: intr sreg[91] seqreg[01] sreg2[80] ireg[18]
[  289.569715] ESP: start data addr[c004e0a4] len[164] write(1)
[  289.569866] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[10]
[  289.569882] ESP: data done flgs[1] sent[164]
[  289.569903] ESP: intr sreg[97] seqreg[03] sreg2[80] ireg[08]
[  289.569923] ESP: intr sreg[90] seqreg[03] sreg2[80] ireg[20]
[  289.569933] ESP: Command done status[0] message[0]
[  289.570055] ESP: tgt[2] lun[0] scsi_cmd [ 12 00 00 00 a4 00 ]
[  289.620752] ESP: intr sreg[91] seqreg[03] sreg2[80] ireg[18]
[  289.620771] ESP: start data addr[c00500a4] len[164] write(1)
[  289.620900] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[10]
[  289.620916] ESP: data done flgs[1] sent[164]
[  289.620936] ESP: intr sreg[97] seqreg[03] sreg2[80] ireg[08]
[  289.620957] ESP: intr sreg[90] seqreg[03] sreg2[80] ireg[20]
[  289.620966] ESP: Command done status[0] message[0]
[  289.621047] scsi target0:0:2: Domain Validation skipping write tests
[  289.621062] scsi target0:0:2: Ending Domain Validation
[  289.621154] ESP: tgt[2] lun[0] scsi_cmd [ 12 01 00 00 ff 00 ]
[  289.621419] ESP: intr sreg[91] seqreg[03] sreg2[80] ireg[18]
[  289.621437] ESP: start data addr[c0052000] len[255] write(1)
[  289.621474] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[10]
[  289.621491] ESP: data done flgs[1] sent[8]
[  289.621517] ESP: intr sreg[87] seqreg[03] sreg2[20] ireg[08]
[  289.621523] ESP: Got msgin byte 23
[  289.621557] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[10]
[  289.621580] ESP: intr sreg[87] seqreg[03] sreg2[20] ireg[08]
[  289.621584] ESP: Got msgin byte 1
[  289.621702] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  289.621722] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  289.621742] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  289.621751] ESP: Command done status[0] message[0]
[  289.688578] ESP: tgt[2] lun[0] scsi_cmd [ 12 01 80 00 ff 00 ]
[  289.688878] ESP: intr sreg[91] seqreg[03] sreg2[80] ireg[18]
[  289.688896] ESP: start data addr[c0054000] len[255] write(1)
[  289.689013] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  289.689031] ESP: data done flgs[1] sent[20]
[  289.689051] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  289.689072] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  289.689081] ESP: Command done status[0] message[0]
[  289.689210] ESP: tgt[2] lun[0] scsi_cmd [ 12 01 83 00 ff 00 ]
[  289.756193] ESP: intr sreg[91] seqreg[03] sreg2[80] ireg[18]
[  289.756212] ESP: start data addr[c0056000] len[255] write(1)
[  289.756361] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  289.756381] ESP: data done flgs[1] sent[16]
[  289.756402] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  289.756422] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  289.756432] ESP: Command done status[0] message[0]
[  289.756586] ESP: tgt[2] lun[0] scsi_cmd [ a0 00 00 00 00 00 00 00 10 00 00 00 ]
[  289.757116] ESP: intr sreg[91] seqreg[03] sreg2[80] ireg[18]
[  289.757134] ESP: start data addr[c0059000] len[4096] write(1)
[  289.813487] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  289.813506] ESP: data done flgs[1] sent[16]
[  289.813532] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  289.813553] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  289.813562] ESP: Command done status[0] message[0]
[  289.814010] ESP: tgt[3] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  290.057281] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  290.057748] ESP: tgt[4] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  290.322956] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  290.323433] ESP: tgt[5] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  290.577167] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  290.577639] ESP: tgt[6] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  290.838681] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  290.839161] ESP: tgt[8] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  291.081422] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  291.081899] ESP: tgt[9] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  291.347098] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  291.347580] ESP: tgt[10] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  291.601306] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  291.601785] ESP: tgt[11] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  291.862825] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  291.863269] ESP: tgt[12] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  292.099319] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  292.099759] ESP: tgt[13] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  292.342073] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  292.342511] ESP: tgt[14] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  292.584820] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  292.585255] ESP: tgt[15] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
[  292.827570] ESP: intr sreg[80] seqreg[00] sreg2[80] ireg[20]
[  292.868341] ESP: tgt[0] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  292.934899] ESP: intr sreg[97] seqreg[00] sreg2[80] ireg[18]
[  292.934932] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  292.934938] ESP: Got msgin byte 4
[  292.934958] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  292.934970] ESP: Disconnecting tgt[0] tag[20:0]
[  292.935001] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  292.935046] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  292.935064] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  292.935082] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  292.935103] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  292.935111] ESP: Command done status[2] message[0]
[  292.935123] esp0: Doing auto-sense for tgt[0] lun[0]
[  292.935317] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  292.935336] ESP: start data addr[c00726c0] len[96] write(1)
[  292.935432] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  292.935450] ESP: data done flgs[5] sent[18]
[  292.935470] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  292.935490] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
** 3 printk messages dropped ** [  292.935796] ESP: intr sreg[97] seqreg[03] sreg2[80] ireg[18]
** 5 printk messages dropped ** [  292.989145] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  292.989163] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  292.989181] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  292.989201] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  292.989209] ESP: Command done status[0] message[0]
[  292.989402] ESP: tgt[0] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
[  292.989454] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[18]
[  292.989484] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  292.989489] ESP: Got msgin byte 4
[  292.989508] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  292.989519] ESP: Disconnecting tgt[0] tag[20:0]
[  292.989942] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  292.989986] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  292.990002] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  292.990014] ESP: start data addr[c0074000] len[8] write(1)
** 7 printk messages dropped ** [  293.057149] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
** 15 printk messages dropped ** [  293.133307] ESP: tgt[0] lun[0] scsi_cmd [ 1a 00 08 00 04 00 ]
** 3 printk messages dropped ** [  293.133412] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.133424] ESP: Disconnecting tgt[0] tag[20:0]
[  293.133474] ESP: tgt[1] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  293.133524] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  293.133553] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.133558] ESP: Got msgin byte 4
[  293.133577] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.133588] ESP: Disconnecting tgt[1] tag[20:1]
[  293.133618] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.133661] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:1]
[  293.133679] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  293.133698] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  293.133717] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  293.133726] ESP: Command done status[2] message[0]
[  293.133736] esp0: Doing auto-sense for tgt[1] lun[0]
** 8 printk messages dropped ** [  293.200850] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[0c]
** 17 printk messages dropped ** [  293.201359] ESP: Got msgin byte 4
** 2 printk messages dropped ** [  293.201420] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.201462] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:1]
[  293.201480] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  293.201498] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  293.201517] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  293.201525] ESP: Command done status[0] message[0]
[  293.201688] ESP: tgt[1] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
[  293.268286] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[18]
[  293.268319] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.268324] ESP: Got msgin byte 4
[  293.268343] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.268354] ESP: Disconnecting tgt[1] tag[20:1]
[  293.268386] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.268427] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:1]
[  293.268443] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
** 7 printk messages dropped ** [  293.268691] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
** 16 printk messages dropped ** [  293.269165] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
** 1 printk messages dropped ** [  293.269198] ESP: Got msgin byte 4
[  293.269217] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.269227] ESP: Disconnecting tgt[0] tag[20:0]
[  293.336009] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.336054] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  293.336080] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  293.336094] ESP: start data addr[c0082000] len[64] write(1)
[  293.336188] ESP: intr sreg[83] seqreg[04] sreg2[00] ireg[10]
[  293.336206] ESP: data done flgs[1] sent[16]
[  293.336225] ESP: intr sreg[87] seqreg[04] sreg2[00] ireg[08]
[  293.336245] ESP: intr sreg[80] seqreg[04] sreg2[00] ireg[20]
[  293.336253] ESP: Command done status[0] message[0]
[  293.336303] ESP: intr sreg[87] seqreg[04] sreg2[00] ireg[0c]
[  293.336344] ESP: reconnect tag, IRQ(0:10:87), IRQ2(1:8:97) tag[20:1]
[  293.336360] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
** 7 printk messages dropped ** [  293.337614] sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
** 17 printk messages dropped ** [  293.387496] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
** 2 printk messages dropped ** [  293.387548] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.387559] ESP: Disconnecting tgt[0] tag[20:0]
[  293.387616] ESP: tgt[1] lun[0] scsi_cmd [ 1a 00 08 00 20 00 ]
[  293.387664] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  293.387694] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.387699] ESP: Got msgin byte 4
[  293.387718] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.387729] ESP: Disconnecting tgt[1] tag[20:1]
[  293.387760] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.387802] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  293.387820] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  293.387838] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  293.387857] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  293.387866] ESP: Command done status[0] message[0]
[  293.388016] ESP: tgt[0] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
** 8 printk messages dropped ** [  293.454956] ESP: start data addr[c0086200] len[32] write(1)
** 15 printk messages dropped ** [  293.455455] ESP: tgt[1] lun[0] scsi_cmd [ 12 01 00 00 40 00 ]
** 2 printk messages dropped ** [  293.455521] ESP: Got msgin byte 4
[  293.455539] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.455549] ESP: Disconnecting tgt[1] tag[20:1]
[  293.455601] ESP: tgt[0] lun[0] scsi_cmd [ 1a 00 3f 00 04 00 ]
[  293.455650] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  293.455679] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.455684] ESP: Got msgin byte 4
[  293.455703] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.455715] ESP: Disconnecting tgt[0] tag[20:0]
[  293.522497] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.522556] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:1]
[  293.522573] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  293.522586] ESP: start data addr[c008a200] len[64] write(1)
[  293.522678] ESP: intr sreg[83] seqreg[04] sreg2[00] ireg[10]
[  293.522696] ESP: data done flgs[1] sent[16]
** 8 printk messages dropped ** [  293.522963] ESP: data done flgs[1] sent[4]
** 16 printk messages dropped ** [  293.580469] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 06 00 00 00 00 18 00 00 00 00 29 02 00 00 00 00 ]
** 3 printk messages dropped ** [  293.580578] ESP: Got msgin byte 4
[  293.580597] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.580607] ESP: Disconnecting tgt[1] tag[20:2]
[  293.580644] ESP: tgt[0] lun[0] scsi_cmd [ 1a 00 08 00 04 00 ]
[  293.580677] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  293.580704] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.580708] ESP: Got msgin byte 4
[  293.580726] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.580736] ESP: Disconnecting tgt[0] tag[20:0]
[  293.580791] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  293.580824] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.580873] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:2]
[  293.580890] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  293.580908] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  293.580928] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
** 8 printk messages dropped ** [  293.648722] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
** 17 printk messages dropped ** [  293.649583] ESP: intr sreg[97] seqreg[03] sreg2[00] ireg[18]
** 1 printk messages dropped ** [  293.649616] ESP: Got msgin byte 4
[  293.649635] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.649645] ESP: Disconnecting tgt[1] tag[20:2]
[  293.649682] ESP: tgt[0] lun[0] scsi_cmd [ 1a 00 08 00 20 00 ]
[  293.649714] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  293.649741] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.649746] ESP: Got msgin byte 4
[  293.649763] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.649773] ESP: Disconnecting tgt[0] tag[20:0]
[  293.649826] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  293.716277] ESP: intr sreg[93] seqreg[04] sreg2[20] ireg[18]
[  293.716303] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.716329] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.716338] ESP: Command done status[2] message[0]
[  293.716349] esp0: Doing auto-sense for tgt[2] lun[0]
[  293.716382] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
** 7 printk messages dropped ** [  293.716614] ESP: Command done status[0] message[0]
** 19 printk messages dropped ** [  293.784184] ESP: tgt[1] lun[0] scsi_cmd [ 1a 00 3f 00 04 00 ]
[  293.784216] ESP: intr sreg[97] seqreg[03] sreg2[00] ireg[18]
[  293.784238] sd 0:0:2:0: [sdc] Spinning up disk...
[  293.784251] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.784256] ESP: Got msgin byte 4
[  293.784274] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.784285] ESP: Disconnecting tgt[1] tag[20:2]
[  293.784322] ESP: tgt[0] lun[0] scsi_cmd [ 12 01 00 00 40 00 ]
[  293.784354] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  293.784381] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.784385] ESP: Got msgin byte 4
[  293.784403] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.784413] ESP: Disconnecting tgt[0] tag[20:0]
[  293.784467] ESP: tgt[2] lun[0] scsi_cmd [ 1b 01 00 00 01 00 ]
[  293.784584] ESP: intr sreg[93] seqreg[04] sreg2[20] ireg[18]
[  293.784610] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.784630] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
** 6 printk messages dropped ** [  293.784862] ESP: data done flgs[1] sent[16]
** 18 printk messages dropped ** [  293.823991] ESP: Disconnecting tgt[0] tag[20:0]
** 1 printk messages dropped ** [  293.824096] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  293.824125] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.824130] ESP: Got msgin byte 4
[  293.824149] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.824159] ESP: Disconnecting tgt[1] tag[20:2]
[  293.891314] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.891361] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:2]
[  293.891378] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  293.891390] ESP: start data addr[c00a8600] len[4] write(1)
[  293.891479] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  293.891492] ESP: data done flgs[1] sent[4]
[  293.891510] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  293.891530] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  293.891538] ESP: Command done status[0] message[0]
[  293.891593] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
** 8 printk messages dropped ** [  293.892217] ESP: tgt[1] lun[0] scsi_cmd [ 1a 00 08 00 20 00 ]
** 18 printk messages dropped ** [  293.945853] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
** 1 printk messages dropped ** [  293.945876] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.945887] ESP: Disconnecting tgt[0] tag[20:0]
[  293.945919] ESP: tgt[0] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  293.945952] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  293.945979] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  293.945983] ESP: Got msgin byte 4
[  293.946001] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  293.946011] ESP: Disconnecting tgt[0] tag[20:1]
[  293.946067] ESP: tgt[1] lun[0] scsi_cmd [ 12 01 00 00 40 00 ]
[  293.946100] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  293.946156] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  293.946174] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  293.946192] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  293.946212] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  293.946220] ESP: Command done status[0] message[0]
** 8 printk messages dropped ** [  293.946510] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:1]
** 15 printk messages dropped ** [  294.013387] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
** 3 printk messages dropped ** [  294.013448] ESP: Disconnecting tgt[0] tag[20:0]
[  294.013620] ESP: tgt[1] lun[0] scsi_cmd [ 28 00 00 00 00 00 00 00 10 00 ]
[  294.013671] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[18]
[  294.013701] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  294.013705] ESP: Got msgin byte 4
[  294.013724] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  294.013734] ESP: Disconnecting tgt[1] tag[20:2]
[  294.013909] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  294.013950] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  294.013967] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  294.013978] ESP: start data addr[c00b4400] len[8] write(1)
[  294.014067] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  294.014080] ESP: data done flgs[1] sent[8]
[  294.014098] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  294.014118] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 8 printk messages dropped ** [  294.089411] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:2]
** 17 printk messages dropped ** [  294.156982] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 1 printk messages dropped ** [  294.157444] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[10]
[  294.157458] ESP: data done flgs[1] sent[8192]
[  294.157477] ESP: intr sreg[97] seqreg[03] sreg2[00] ireg[08]
[  294.157496] ESP: intr sreg[90] seqreg[03] sreg2[00] ireg[20]
[  294.157505] ESP: Command done status[0] message[0]
[  294.157562] ESP: tgt[0] lun[0] scsi_cmd [ 1a 00 08 00 04 00 ]
[  294.157595] ESP: intr sreg[97] seqreg[03] sreg2[00] ireg[18]
[  294.157622] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  294.157627] ESP: Got msgin byte 4
[  294.157642]  sdb: unknown partition table
[  294.157655] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  294.157667] ESP: Disconnecting tgt[0] tag[20:0]
[  294.158785] ESP: tgt[1] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  294.224706] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  294.224773] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:0]
[  294.224789] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
** 7 printk messages dropped ** [  294.225028] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
** 19 printk messages dropped ** [  294.225528] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  294.225532] ESP: Got msgin byte 4
[  294.225550] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  294.225560] ESP: Disconnecting tgt[0] tag[20:0]
[  294.225625] ESP: tgt[1] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
[  294.225659] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  294.225715] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:3]
[  294.225732] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[10]
[  294.225750] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  294.225769] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  294.225777] ESP: Command done status[0] message[0]
[  294.225831] ESP: tgt[1] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
[  294.225867] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[18]
[  294.225894] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  294.225898] ESP: Got msgin byte 4
[  294.225916] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
** 8 printk messages dropped ** [  294.292642] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 18 printk messages dropped ** [  294.293192] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
** 23 printk messages dropped ** [  294.344030] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[18]
[  294.344060] ESP: intr sreg[97] seqreg[04] sreg2[20] ireg[08]
[  294.344065] ESP: Got msgin byte 4
[  294.344083] ESP: intr sreg[90] seqreg[04] sreg2[20] ireg[20]
[  294.344094] ESP: Disconnecting tgt[1] tag[20:2]
[  294.411198] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[0c]
[  294.411245] ESP: reconnect tag, IRQ(0:10:97), IRQ2(1:8:97) tag[20:2]
[  294.411262] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[10]
[  294.411273] ESP: start data addr[c00ca600] len[4] write(1)
[  294.411353] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[10]
[  294.411366] ESP: data done flgs[1] sent[4]
[  294.411385] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  294.411404] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  294.411413] ESP: Command done status[0] message[0]
[  294.411573] ESP: tgt[1] lun[0] scsi_cmd [ 1a 00 08 00 20 00 ]
** 8 printk messages dropped ** [  294.478996] ESP: start data addr[c00cc600] len[32] write(1)
** 19 printk messages dropped ** [  294.479858] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  294.788278] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  294.847744] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
[  294.847783] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  294.847804] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  294.847813] ESP: Command done status[2] message[0]
[  294.847826] esp0: Doing auto-sense for tgt[2] lun[0]
[  294.848139] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  294.848157] ESP: start data addr[c00d0720] len[96] write(1)
[  294.848273] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  294.848291] ESP: data done flgs[5] sent[32]
[  294.848311] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  294.848331] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  294.848340] ESP: Command done status[0] message[0]
[  294.848407] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  294.848552] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  294.901923] ESP: start data addr[c00d2720] len[96] write(1)
** 18 printk messages dropped ** [  294.969720] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  295.978257] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  296.001084] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  296.001112] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  296.001133] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  296.001142] ESP: Command done status[2] message[0]
[  296.001155] esp0: Doing auto-sense for tgt[2] lun[0]
[  296.001470] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  296.001487] ESP: start data addr[c00d6720] len[96] write(1)
[  296.001603] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  296.001620] ESP: data done flgs[5] sent[32]
[  296.001641] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  296.001661] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  296.001669] ESP: Command done status[0] message[0]
[  296.001735] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  296.001871] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  296.040669] ESP: start data addr[c00d8720] len[96] write(1)
** 18 printk messages dropped ** [  296.108456] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  297.118251] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  297.177322] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  297.177350] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  297.177374] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  297.177384] ESP: Command done status[2] message[0]
[  297.177395] esp0: Doing auto-sense for tgt[2] lun[0]
[  297.177708] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  297.177725] ESP: start data addr[c00dc720] len[96] write(1)
[  297.177841] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  297.177859] ESP: data done flgs[5] sent[32]
[  297.177879] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  297.177898] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  297.177907] ESP: Command done status[0] message[0]
[  297.177972] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  297.178112] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  297.217961] ESP: start data addr[c00de720] len[96] write(1)
** 18 printk messages dropped ** [  297.285748] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  298.288243] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  298.311896] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  298.311923] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  298.311944] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  298.311954] ESP: Command done status[2] message[0]
[  298.311979] esp0: Doing auto-sense for tgt[2] lun[0]
[  298.312280] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  298.312298] ESP: start data addr[c00e2720] len[96] write(1)
[  298.312413] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  298.312431] ESP: data done flgs[5] sent[32]
[  298.312451] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  298.312471] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  298.312480] ESP: Command done status[0] message[0]
[  298.312546] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  298.312684] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  298.379633] ESP: start data addr[c00e4720] len[96] write(1)
** 18 printk messages dropped ** [  298.436991] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  299.438241] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  299.462108] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  299.462134] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  299.462155] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  299.462179] ESP: Command done status[2] message[0]
[  299.462190] esp0: Doing auto-sense for tgt[2] lun[0]
[  299.462492] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  299.462509] ESP: start data addr[c00e8720] len[96] write(1)
[  299.462624] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  299.462642] ESP: data done flgs[5] sent[32]
[  299.462662] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  299.462682] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  299.462691] ESP: Command done status[0] message[0]
[  299.462756] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  299.462895] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  299.529836] ESP: start data addr[c00ea720] len[96] write(1)
** 18 printk messages dropped ** [  299.597617] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  300.598232] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  300.623771] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  300.623798] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  300.623819] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  300.623844] ESP: Command done status[2] message[0]
[  300.623855] esp0: Doing auto-sense for tgt[2] lun[0]
[  300.624155] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  300.624172] ESP: start data addr[c00ee720] len[96] write(1)
[  300.624288] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  300.624306] ESP: data done flgs[5] sent[32]
[  300.624326] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  300.624346] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  300.624354] ESP: Command done status[0] message[0]
[  300.624421] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  300.624559] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  300.690464] ESP: start data addr[c00f0720] len[96] write(1)
** 17 printk messages dropped ** [  300.758233] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
** 2 printk messages dropped ** [  301.768211] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  301.787530] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  301.787558] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  301.787583] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  301.787592] ESP: Command done status[2] message[0]
[  301.787603] esp0: Doing auto-sense for tgt[2] lun[0]
[  301.787914] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  301.787931] ESP: start data addr[c00f4720] len[96] write(1)
[  301.788047] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  301.788065] ESP: data done flgs[5] sent[32]
[  301.788085] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  301.788105] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  301.788114] ESP: Command done status[0] message[0]
[  301.788179] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  301.788324] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  301.837546] ESP: start data addr[c00f6720] len[96] write(1)
** 17 printk messages dropped ** [  301.905316] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
** 2 printk messages dropped ** [  302.908204] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  302.911690] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  302.911716] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  302.911752] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  302.911761] ESP: Command done status[2] message[0]
[  302.911772] esp0: Doing auto-sense for tgt[2] lun[0]
[  302.912073] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  302.912091] ESP: start data addr[c00fa720] len[96] write(1)
[  302.912207] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  302.912224] ESP: data done flgs[5] sent[32]
[  302.912244] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  302.912265] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  302.912273] ESP: Command done status[0] message[0]
[  302.912340] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  302.912475] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  302.951294] ESP: start data addr[c00fc720] len[96] write(1)
** 17 printk messages dropped ** [  303.019078] ESP: intr sreg[80] seqreg[04] sreg2[00] ireg[20]
** 2 printk messages dropped ** [  304.028194] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  304.029601] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
[  304.029628] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  304.029663] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  304.029672] ESP: Command done status[2] message[0]
[  304.029683] esp0: Doing auto-sense for tgt[2] lun[0]
[  304.029985] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  304.030002] ESP: start data addr[c0100720] len[96] write(1)
[  304.030117] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  304.030135] ESP: data done flgs[5] sent[32]
[  304.030155] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  304.030175] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  304.030183] ESP: Command done status[0] message[0]
[  304.030248] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  304.030381] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  304.097327] ESP: start data addr[c0102720] len[96] write(1)
** 17 printk messages dropped ** [  304.173449] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
** 2 printk messages dropped ** [  305.178193] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  305.197515] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  305.197542] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  305.197563] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  305.197588] ESP: Command done status[2] message[0]
[  305.197599] esp0: Doing auto-sense for tgt[2] lun[0]
[  305.197899] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  305.197916] ESP: start data addr[c0106720] len[96] write(1)
[  305.198031] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  305.198049] ESP: data done flgs[5] sent[32]
[  305.198069] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  305.198089] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  305.198098] ESP: Command done status[0] message[0]
[  305.198165] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  305.198309] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  305.265247] ESP: start data addr[c0108720] len[96] write(1)
** 17 printk messages dropped ** [  305.333022] ESP: intr sreg[80] seqreg[04] sreg2[00] ireg[20]
** 2 printk messages dropped ** [  306.338185] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  306.340432] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
[  306.340467] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  306.340488] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  306.340497] ESP: Command done status[2] message[0]
[  306.340508] esp0: Doing auto-sense for tgt[2] lun[0]
[  306.340825] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  306.340842] ESP: start data addr[c010c720] len[96] write(1)
[  306.340957] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  306.340975] ESP: data done flgs[5] sent[32]
[  306.340995] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  306.341015] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  306.341023] ESP: Command done status[0] message[0]
[  306.341089] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  306.341223] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  306.408166] ESP: start data addr[c010e720] len[96] write(1)
** 18 printk messages dropped ** [  306.475945] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  307.478181] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  307.498973] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  307.499001] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  307.499026] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  307.499036] ESP: Command done status[2] message[0]
[  307.499047] esp0: Doing auto-sense for tgt[2] lun[0]
[  307.499359] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  307.499376] ESP: start data addr[c0112720] len[96] write(1)
[  307.499491] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  307.499508] ESP: data done flgs[5] sent[32]
[  307.499528] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  307.499548] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  307.499557] ESP: Command done status[0] message[0]
[  307.499622] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  307.499761] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  307.566708] ESP: start data addr[c0114720] len[96] write(1)
** 18 printk messages dropped ** [  307.634489] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  308.638171] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  308.698151] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  308.698178] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  308.698204] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  308.698213] ESP: Command done status[2] message[0]
[  308.698224] esp0: Doing auto-sense for tgt[2] lun[0]
[  308.698536] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  308.698553] ESP: start data addr[c0118720] len[96] write(1)
[  308.698669] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  308.698686] ESP: data done flgs[5] sent[32]
[  308.698706] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  308.698726] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  308.698735] ESP: Command done status[0] message[0]
[  308.698802] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  308.698941] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  308.752335] ESP: start data addr[c011a720] len[96] write(1)
** 18 printk messages dropped ** [  308.820121] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  309.828149] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  309.852527] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  309.852554] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  309.852579] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  309.852589] ESP: Command done status[2] message[0]
[  309.852599] esp0: Doing auto-sense for tgt[2] lun[0]
[  309.852912] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  309.852929] ESP: start data addr[c011e720] len[96] write(1)
[  309.853044] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  309.853062] ESP: data done flgs[5] sent[32]
[  309.853082] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  309.853102] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  309.853111] ESP: Command done status[0] message[0]
[  309.853177] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  309.853315] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  309.920255] ESP: start data addr[c0120720] len[96] write(1)
** 18 printk messages dropped ** [  309.988038] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  310.998142] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  311.022529] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  311.022566] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  311.022587] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  311.022597] ESP: Command done status[2] message[0]
[  311.022608] esp0: Doing auto-sense for tgt[2] lun[0]
[  311.022923] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  311.022941] ESP: start data addr[c0124720] len[96] write(1)
[  311.023057] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  311.023075] ESP: data done flgs[5] sent[32]
[  311.023096] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  311.023116] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  311.023125] ESP: Command done status[0] message[0]
[  311.023193] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  311.023331] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 7 printk messages dropped ** [  311.090381] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
** 17 printk messages dropped ** [  311.158031] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  312.160269] NMI watchdog: BUG: soft lockup - CPU#14 stuck for 22s! [swapper/10:1]
[  312.160281] Modules linked in:
[  312.160308] CPU: 14 PID: 1 Comm: swapper/10 Not tainted 3.18.0-rc4-00052-g04689e7-dirty #25
[  312.160323] task: fffff800fe0d0000 ti: fffff800fe094000 task.ti: fffff800fe094000
[  312.160339] TSTATE: 0000004480001602 TPC: 0000000000490f60 TNPC: 0000000000490f64 Y: 00000000    Not tainted
[  312.160362] TPC: <console_unlock+0x440/0x4a0>
[  312.160374] g0: 0000000000001000 g1: 0000000000000000 g2: 0000000000000000 g3: 0000000000000001
[  312.160387] g4: fffff800fe0d0000 g5: fffff800fed30000 g6: fffff800fe094000 g7: fffff800fe040f00
[  312.160399] o0: 0000000000798000 o1: 0000000000000040 o2: 000000000086f6d8 o3: 00000000008dbf50
[  312.160411] o4: 00000000008fcd08 o5: 0000000000000000 sp: fffff800fe096ef1 ret_pc: 0000000000490f2c
[  312.160424] RPC: <console_unlock+0x40c/0x4a0>
** 4 printk messages dropped ** [  312.160489] I7: <vprintk_emit+0x270/0x540>
** 17 printk messages dropped ** [  312.200227] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 3 printk messages dropped ** [  312.200400] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  312.200420] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  312.200429] ESP: Command done status[0] message[0]
[  312.200497] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  312.200636] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  312.200809] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  312.200835] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  312.200855] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  312.200864] ESP: Command done status[2] message[0]
[  312.200875] esp0: Doing auto-sense for tgt[2] lun[0]
[  312.288376] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  312.288393] ESP: start data addr[c012c720] len[96] write(1)
[  312.288509] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  312.288527] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  312.288997] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  313.380646] ESP: start data addr[c0130720] len[96] write(1)
** 2 printk messages dropped ** [  313.380800] ESP: intr sreg[87] seqreg[04] sreg2[00] ireg[08]
[  313.380820] ESP: intr sreg[80] seqreg[04] sreg2[00] ireg[20]
[  313.380830] ESP: Command done status[0] message[0]
[  313.380896] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  313.381034] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  313.381209] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
[  313.381236] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  313.381256] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  313.381264] ESP: Command done status[2] message[0]
[  313.381275] esp0: Doing auto-sense for tgt[2] lun[0]
[  313.447958] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  313.447974] ESP: start data addr[c0132720] len[96] write(1)
[  313.448097] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  313.448117] ESP: data done flgs[5] sent[32]
** 6 printk messages dropped ** [  313.448577] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
** 18 printk messages dropped ** [  314.512101] ESP: start data addr[c0136720] len[96] write(1)
** 2 printk messages dropped ** [  314.512254] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  314.512274] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  314.512282] ESP: Command done status[0] message[0]
[  314.512349] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  314.512487] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  314.512660] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  314.512686] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  314.512706] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  314.512715] ESP: Command done status[2] message[0]
[  314.512726] esp0: Doing auto-sense for tgt[2] lun[0]
[  314.565867] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  314.565883] ESP: start data addr[c0138720] len[96] write(1)
[  314.566000] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  314.566018] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  314.566489] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  315.683150] ESP: start data addr[c013c720] len[96] write(1)
** 2 printk messages dropped ** [  315.683304] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  315.683324] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  315.683333] ESP: Command done status[0] message[0]
[  315.683400] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  315.683536] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  315.683708] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  315.683735] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  315.683755] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  315.683764] ESP: Command done status[2] message[0]
[  315.683775] esp0: Doing auto-sense for tgt[2] lun[0]
[  315.750459] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  315.750475] ESP: start data addr[c013e720] len[96] write(1)
[  315.750592] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  315.750609] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  315.751075] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  316.837521] ESP: start data addr[c0142720] len[96] write(1)
** 2 printk messages dropped ** [  316.837677] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  316.837698] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  316.837707] ESP: Command done status[0] message[0]
[  316.837774] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  316.837913] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  316.838087] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  316.838113] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  316.838134] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  316.838142] ESP: Command done status[2] message[0]
[  316.838153] esp0: Doing auto-sense for tgt[2] lun[0]
[  316.905872] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  316.905888] ESP: start data addr[c0144720] len[96] write(1)
[  316.906006] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  316.906024] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  316.906495] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  318.030463] ESP: start data addr[c0148720] len[96] write(1)
** 2 printk messages dropped ** [  318.030616] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  318.030636] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  318.030645] ESP: Command done status[0] message[0]
[  318.030712] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  318.030852] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  318.031026] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  318.031051] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  318.031071] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  318.031080] ESP: Command done status[2] message[0]
[  318.031091] esp0: Doing auto-sense for tgt[2] lun[0]
[  318.098802] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  318.098818] ESP: start data addr[c014a720] len[96] write(1)
[  318.098934] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  318.098952] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  318.099424] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  319.198364] ESP: start data addr[c014e720] len[96] write(1)
** 2 printk messages dropped ** [  319.198517] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  319.198537] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  319.198545] ESP: Command done status[0] message[0]
[  319.198611] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  319.198750] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  319.198925] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  319.198950] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  319.198970] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  319.198978] ESP: Command done status[2] message[0]
[  319.198989] esp0: Doing auto-sense for tgt[2] lun[0]
[  319.265681] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  319.265698] ESP: start data addr[c0150720] len[96] write(1)
[  319.265814] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  319.265832] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  319.266330] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 16 printk messages dropped ** [  320.368351] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 3 printk messages dropped ** [  320.368522] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  320.368542] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  320.368551] ESP: Command done status[0] message[0]
[  320.368618] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  320.368757] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  320.368930] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  320.368957] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  320.368977] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  320.368986] ESP: Command done status[2] message[0]
[  320.368997] esp0: Doing auto-sense for tgt[2] lun[0]
[  320.435678] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  320.435694] ESP: start data addr[c0156720] len[96] write(1)
[  320.435811] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  320.435829] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  320.436296] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  321.506069] ESP: start data addr[c015a720] len[96] write(1)
** 2 printk messages dropped ** [  321.506223] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  321.506243] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  321.506251] ESP: Command done status[0] message[0]
[  321.506318] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  321.506457] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  321.506630] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  321.506657] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  321.506677] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  321.506686] ESP: Command done status[2] message[0]
[  321.506697] esp0: Doing auto-sense for tgt[2] lun[0]
[  321.574429] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  321.574445] ESP: start data addr[c015c720] len[96] write(1)
[  321.574562] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  321.574580] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  321.575049] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  322.705246] ESP: start data addr[c0160720] len[96] write(1)
** 2 printk messages dropped ** [  322.705400] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  322.705420] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  322.705429] ESP: Command done status[0] message[0]
[  322.705496] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  322.705623] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  322.705795] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  322.705822] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  322.705842] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  322.705851] ESP: Command done status[2] message[0]
[  322.705862] esp0: Doing auto-sense for tgt[2] lun[0]
[  322.744433] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  322.744450] ESP: start data addr[c0162720] len[96] write(1)
[  322.744566] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  322.744585] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  322.745059] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  323.882556] ESP: start data addr[c0166720] len[96] write(1)
** 2 printk messages dropped ** [  323.882709] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  323.882730] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  323.882739] ESP: Command done status[0] message[0]
[  323.882806] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  323.882943] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  323.883115] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  323.883141] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  323.883161] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  323.883169] ESP: Command done status[2] message[0]
[  323.883180] esp0: Doing auto-sense for tgt[2] lun[0]
[  323.921728] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  323.921745] ESP: start data addr[c0168720] len[96] write(1)
[  323.921861] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  323.921879] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  323.922346] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  325.041088] ESP: start data addr[c016c720] len[96] write(1)
** 2 printk messages dropped ** [  325.041243] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  325.041264] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  325.041273] ESP: Command done status[0] message[0]
[  325.041340] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  325.041479] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  325.041652] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  325.041679] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  325.041699] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  325.041707] ESP: Command done status[2] message[0]
[  325.041719] esp0: Doing auto-sense for tgt[2] lun[0]
[  325.109444] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  325.109461] ESP: start data addr[c016e720] len[96] write(1)
[  325.109577] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  325.109595] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  325.110066] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  326.191296] ESP: start data addr[c0172720] len[96] write(1)
** 2 printk messages dropped ** [  326.191451] ESP: intr sreg[87] seqreg[04] sreg2[00] ireg[08]
[  326.191471] ESP: intr sreg[80] seqreg[04] sreg2[00] ireg[20]
[  326.191480] ESP: Command done status[0] message[0]
[  326.191546] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  326.191684] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  326.191856] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
[  326.191882] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  326.191903] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  326.191911] ESP: Command done status[2] message[0]
[  326.191922] esp0: Doing auto-sense for tgt[2] lun[0]
[  326.258608] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  326.258624] ESP: start data addr[c0174720] len[96] write(1)
[  326.258740] ESP: intr sreg[83] seqreg[04] sreg2[00] ireg[10]
[  326.258757] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  326.259229] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 16 printk messages dropped ** [  327.345662] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 3 printk messages dropped ** [  327.345832] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  327.345852] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  327.345861] ESP: Command done status[0] message[0]
[  327.345926] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  327.346066] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  327.346239] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  327.346265] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  327.346285] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  327.346294] ESP: Command done status[2] message[0]
[  327.346304] esp0: Doing auto-sense for tgt[2] lun[0]
[  327.395270] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  327.395287] ESP: start data addr[c017a720] len[96] write(1)
[  327.395404] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  327.395422] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  327.395893] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  328.532354] ESP: start data addr[c017e720] len[96] write(1)
** 2 printk messages dropped ** [  328.532509] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  328.532529] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  328.532538] ESP: Command done status[0] message[0]
[  328.532606] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  328.532746] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  328.532922] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  328.532947] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  328.532967] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  328.532976] ESP: Command done status[2] message[0]
[  328.532987] esp0: Doing auto-sense for tgt[2] lun[0]
[  328.600693] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  328.600710] ESP: start data addr[c0180720] len[96] write(1)
[  328.600826] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  328.600844] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  328.601315] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  329.699214] ESP: start data addr[c0184720] len[96] write(1)
** 2 printk messages dropped ** [  329.699368] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  329.699388] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  329.699396] ESP: Command done status[0] message[0]
[  329.699462] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  329.699602] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  329.699774] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  329.699800] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  329.699820] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  329.699828] ESP: Command done status[2] message[0]
[  329.699839] esp0: Doing auto-sense for tgt[2] lun[0]
[  329.766534] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  329.766551] ESP: start data addr[c0186720] len[96] write(1)
[  329.766667] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  329.766686] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  329.767160] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  330.848382] ESP: start data addr[c018a720] len[96] write(1)
** 2 printk messages dropped ** [  330.848536] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  330.848557] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  330.848565] ESP: Command done status[0] message[0]
[  330.848631] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  330.848769] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  330.848942] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  330.848967] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  330.848987] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  330.848995] ESP: Command done status[2] message[0]
[  330.849006] esp0: Doing auto-sense for tgt[2] lun[0]
[  330.915700] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  330.915717] ESP: start data addr[c018c720] len[96] write(1)
[  330.915832] ESP: intr sreg[83] seqreg[04] sreg2[00] ireg[10]
[  330.915851] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  330.916321] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  332.044430] ESP: start data addr[c0190720] len[96] write(1)
** 2 printk messages dropped ** [  332.044585] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  332.044605] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  332.044614] ESP: Command done status[0] message[0]
[  332.044680] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  332.044818] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  332.044991] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  332.045016] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  332.045036] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  332.045045] ESP: Command done status[2] message[0]
[  332.045056] esp0: Doing auto-sense for tgt[2] lun[0]
[  332.109663] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  332.109680] ESP: start data addr[c0192720] len[96] write(1)
[  332.109796] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  332.109814] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  332.110283] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  333.239447] ESP: start data addr[c0196720] len[96] write(1)
** 2 printk messages dropped ** [  333.239601] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  333.239621] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  333.239630] ESP: Command done status[0] message[0]
[  333.239697] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  333.239836] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  333.240017] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  333.240042] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  333.240062] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  333.240070] ESP: Command done status[2] message[0]
[  333.240081] esp0: Doing auto-sense for tgt[2] lun[0]
[  333.298419] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  333.298436] ESP: start data addr[c0198720] len[96] write(1)
[  333.298553] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  333.298571] ESP: data done flgs[5] sent[32]
** 6 printk messages dropped ** [  333.299022] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
** 18 printk messages dropped ** [  334.433407] ESP: start data addr[c019c720] len[96] write(1)
** 2 printk messages dropped ** [  334.433560] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  334.433580] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  334.433589] ESP: Command done status[0] message[0]
[  334.433657] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  334.433796] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  334.433969] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  334.433996] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  334.434015] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  334.434024] ESP: Command done status[2] message[0]
[  334.434035] esp0: Doing auto-sense for tgt[2] lun[0]
[  334.500718] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  334.500735] ESP: start data addr[c019e720] len[96] write(1)
[  334.500852] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  334.500870] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  334.501340] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 13 printk messages dropped ** [  335.639533] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 6 printk messages dropped ** [  335.640035] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  335.640055] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  335.640064] ESP: Command done status[0] message[0]
[  335.640132] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  335.640270] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  335.640444] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  335.640469] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  335.640489] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  335.640498] ESP: Command done status[2] message[0]
[  335.640509] esp0: Doing auto-sense for tgt[2] lun[0]
[  335.707187] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  335.707203] ESP: start data addr[c01a4720] len[96] write(1)
[  335.707323] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  335.707342] ESP: data done flgs[5] sent[32]
** 7 printk messages dropped ** [  335.707813] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  336.828632] ESP: start data addr[c01a8720] len[96] write(1)
** 2 printk messages dropped ** [  336.828786] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  336.828806] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  336.828814] ESP: Command done status[0] message[0]
[  336.828881] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  336.829022] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  336.829195] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  336.829221] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  336.829241] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  336.829250] ESP: Command done status[2] message[0]
[  336.829261] esp0: Doing auto-sense for tgt[2] lun[0]
[  336.909488] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  336.909504] ESP: start data addr[c01aa720] len[96] write(1)
[  336.909621] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  336.909638] ESP: data done flgs[5] sent[32]
** 3 printk messages dropped ** [  336.909753] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 16 printk messages dropped ** [  338.019111] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
** 21 printk messages dropped ** [  338.069237] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
** 15 printk messages dropped ** [  338.151460] ESP: Command done status[0] message[0]
** 13 printk messages dropped ** [  339.203201] ESP: Command done status[0] message[0]
** 15 printk messages dropped ** [  339.270730] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 21 printk messages dropped ** [  340.431481] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
** 4 printk messages dropped ** [  340.431613] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 16 printk messages dropped ** [  340.499277] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
** 24 printk messages dropped ** [  341.616198] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 14 printk messages dropped ** [  341.683679] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  341.683851] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  341.683876] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  341.683896] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  341.683904] ESP: Command done status[2] message[0]
[  341.683915] esp0: Doing auto-sense for tgt[2] lun[0]
[  341.684229] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  341.684245] ESP: start data addr[c01c4720] len[96] write(1)
[  341.766612] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  341.766630] ESP: data done flgs[5] sent[32]
[  341.766650] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  341.766671] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  341.766698] ESP: Command done status[0] message[0]
[  341.766764] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 8 printk messages dropped ** [  342.772540] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
** 17 printk messages dropped ** [  342.839924] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  342.840128] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  342.840302] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  342.840327] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  342.840347] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  342.840356] ESP: Command done status[2] message[0]
[  342.840367] esp0: Doing auto-sense for tgt[2] lun[0]
[  342.840681] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  342.840697] ESP: start data addr[c01ca720] len[96] write(1)
[  342.941823] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  342.941841] ESP: data done flgs[5] sent[32]
[  342.941861] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  342.941881] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  342.941889] ESP: Command done status[0] message[0]
[  342.941977] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  343.947885] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 7 printk messages dropped ** [  343.981104] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
** 16 printk messages dropped ** [  344.038045] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
** 2 printk messages dropped ** [  344.038257] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  344.038430] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  344.038455] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  344.038475] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  344.038484] ESP: Command done status[2] message[0]
[  344.038494] esp0: Doing auto-sense for tgt[2] lun[0]
[  344.038808] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  344.038824] ESP: start data addr[c01d0720] len[96] write(1)
[  344.147263] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  344.147281] ESP: data done flgs[5] sent[32]
[  344.147302] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  344.147337] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  344.147346] ESP: Command done status[0] message[0]
[  344.147412] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  345.147882] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 7 printk messages dropped ** [  345.177125] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
** 17 printk messages dropped ** [  345.244523] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  345.244727] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  345.244900] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  345.244925] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  345.244945] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  345.244954] ESP: Command done status[2] message[0]
[  345.244965] esp0: Doing auto-sense for tgt[2] lun[0]
[  345.245279] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  345.245295] ESP: start data addr[c01d6720] len[96] write(1)
[  345.353717] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  345.353735] ESP: data done flgs[5] sent[32]
[  345.353755] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  345.353775] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  345.353802] ESP: Command done status[0] message[0]
[  345.353868] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  346.357868] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 7 printk messages dropped ** [  346.428396] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
** 17 printk messages dropped ** [  346.495788] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  346.495991] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  346.496164] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  346.496189] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  346.496210] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  346.496218] ESP: Command done status[2] message[0]
[  346.496229] esp0: Doing auto-sense for tgt[2] lun[0]
[  346.496543] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  346.496558] ESP: start data addr[c01dc720] len[96] write(1)
[  346.596652] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  346.596670] ESP: data done flgs[5] sent[32]
[  346.596691] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  346.596710] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  346.596719] ESP: Command done status[0] message[0]
[  346.596807] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  347.597869] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 7 printk messages dropped ** [  347.602565] ESP: intr sreg[83] seqreg[04] sreg2[00] ireg[10]
** 17 printk messages dropped ** [  347.669966] ESP: Command done status[0] message[0]
** 1 printk messages dropped ** [  347.670170] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  347.670343] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  347.670369] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  347.670389] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  347.670398] ESP: Command done status[2] message[0]
[  347.670408] esp0: Doing auto-sense for tgt[2] lun[0]
[  347.670722] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  347.670738] ESP: start data addr[c01e2720] len[96] write(1)
[  347.770818] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  347.770836] ESP: data done flgs[5] sent[32]
[  347.770857] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  347.770877] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  347.770885] ESP: Command done status[0] message[0]
[  347.770973] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  347.872973] INFO: rcu_sched self-detected stall on CPU
** 7 printk messages dropped ** [  347.873129]  [00000000004ac108] tick_sched_timer+0x28/0x60
** 17 printk messages dropped ** [  348.790869] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  348.791209] ESP: start data addr[c01e4720] len[96] write(1)
[  348.791324] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  348.791342] ESP: data done flgs[5] sent[32]
[  348.791362] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  348.791382] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  348.791391] ESP: Command done status[0] message[0]
[  348.791458] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  348.791596] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  348.791768] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  348.791794] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  348.791814] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  348.791822] ESP: Command done status[2] message[0]
[  348.791833] esp0: Doing auto-sense for tgt[2] lun[0]
[  348.859562] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  348.859578] ESP: start data addr[c01e6720] len[96] write(1)
** 6 printk messages dropped ** [  348.859966] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 16 printk messages dropped ** [  350.027546] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
** 3 printk messages dropped ** [  350.027902] ESP: start data addr[c01ea720] len[96] write(1)
[  350.028018] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  350.028035] ESP: data done flgs[5] sent[32]
[  350.028056] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  350.028076] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  350.028085] ESP: Command done status[0] message[0]
[  350.028152] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  350.028297] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  350.028470] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  350.028496] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  350.028516] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  350.028524] ESP: Command done status[2] message[0]
[  350.028535] esp0: Doing auto-sense for tgt[2] lun[0]
[  350.096242] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 7 printk messages dropped ** [  350.096649] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 17 printk messages dropped ** [  351.264223] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  351.264566] ESP: start data addr[c01f0720] len[96] write(1)
[  351.264681] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  351.264699] ESP: data done flgs[5] sent[32]
[  351.264719] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  351.264739] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  351.264748] ESP: Command done status[0] message[0]
[  351.264813] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  351.264953] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  351.265126] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  351.265151] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  351.265171] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  351.265179] ESP: Command done status[2] message[0]
[  351.265190] esp0: Doing auto-sense for tgt[2] lun[0]
[  351.332926] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  351.332942] ESP: start data addr[c01f2720] len[96] write(1)
** 6 printk messages dropped ** [  351.333327] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 17 printk messages dropped ** [  352.500906] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  352.501250] ESP: start data addr[c01f6720] len[96] write(1)
[  352.501366] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  352.501384] ESP: data done flgs[5] sent[32]
[  352.501404] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  352.501424] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  352.501432] ESP: Command done status[0] message[0]
[  352.501500] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  352.501640] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  352.501813] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  352.501839] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  352.501859] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  352.501868] ESP: Command done status[2] message[0]
[  352.501879] esp0: Doing auto-sense for tgt[2] lun[0]
[  352.569602] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  352.569619] ESP: start data addr[c01f8720] len[96] write(1)
** 6 printk messages dropped ** [  352.570004] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 18 printk messages dropped ** [  353.737612] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  353.737933] ESP: start data addr[c01fc720] len[96] write(1)
[  353.738049] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  353.738067] ESP: data done flgs[5] sent[32]
[  353.738087] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  353.738107] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  353.738116] ESP: Command done status[0] message[0]
[  353.738183] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  353.738327] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  353.738499] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  353.738524] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  353.738544] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  353.738553] ESP: Command done status[2] message[0]
[  353.738564] esp0: Doing auto-sense for tgt[2] lun[0]
[  353.806285] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  353.806301] ESP: start data addr[c01fe720] len[96] write(1)
** 8 printk messages dropped ** [  353.806892] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
** 18 printk messages dropped ** [  354.974625] ESP: start data addr[c0202720] len[96] write(1)
[  354.974741] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  354.974759] ESP: data done flgs[5] sent[32]
[  354.974779] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  354.974799] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  354.974808] ESP: Command done status[0] message[0]
[  354.974874] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  354.975013] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  354.975185] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  354.975211] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  354.975231] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  354.975240] ESP: Command done status[2] message[0]
[  354.975251] esp0: Doing auto-sense for tgt[2] lun[0]
[  355.042966] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 7 printk messages dropped ** [  355.043376] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 17 printk messages dropped ** [  356.210979] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  356.211311] ESP: start data addr[c0208720] len[96] write(1)
[  356.211426] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  356.211444] ESP: data done flgs[5] sent[32]
[  356.211464] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  356.211484] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  356.211492] ESP: Command done status[0] message[0]
[  356.211558] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  356.211699] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  356.211872] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  356.211898] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  356.211918] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  356.211926] ESP: Command done status[2] message[0]
[  356.211937] esp0: Doing auto-sense for tgt[2] lun[0]
[  356.279646] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  356.279662] ESP: start data addr[c020a720] len[96] write(1)
** 6 printk messages dropped ** [  356.280049] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 18 printk messages dropped ** [  357.458061] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  357.458396] ESP: start data addr[c020e720] len[96] write(1)
[  357.458512] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  357.458530] ESP: data done flgs[5] sent[32]
[  357.458550] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  357.458570] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  357.458579] ESP: Command done status[0] message[0]
[  357.458646] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  357.458785] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  357.458959] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  357.458986] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  357.459006] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  357.459015] ESP: Command done status[2] message[0]
[  357.459026] esp0: Doing auto-sense for tgt[2] lun[0]
[  357.526748] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 3 printk messages dropped ** [  357.526920] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
** 17 printk messages dropped ** [  358.627785] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 6 printk messages dropped ** [  358.705490] ESP: start data addr[c0214720] len[96] write(1)
[  358.705606] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  358.705624] ESP: data done flgs[5] sent[32]
[  358.705644] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  358.705664] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  358.705673] ESP: Command done status[0] message[0]
[  358.705739] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  358.705877] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  358.706051] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  358.706077] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  358.706097] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  358.706105] ESP: Command done status[2] message[0]
[  358.706116] esp0: Doing auto-sense for tgt[2] lun[0]
[  358.773852] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 7 printk messages dropped ** [  358.774252] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 18 printk messages dropped ** [  359.952261] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  359.952595] ESP: start data addr[c021a720] len[96] write(1)
[  359.952711] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  359.952729] ESP: data done flgs[5] sent[32]
[  359.952749] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  359.952769] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  359.952777] ESP: Command done status[0] message[0]
[  359.952845] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  359.952983] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  359.953155] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  359.953182] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  359.953202] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  359.953211] ESP: Command done status[2] message[0]
[  359.953222] esp0: Doing auto-sense for tgt[2] lun[0]
[  360.020964] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  360.020981] ESP: start data addr[c021c720] len[96] write(1)
** 6 printk messages dropped ** [  360.021365] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 18 printk messages dropped ** [  361.199362] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  361.199697] ESP: start data addr[c0220720] len[96] write(1)
[  361.199813] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  361.199831] ESP: data done flgs[5] sent[32]
[  361.199851] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  361.199871] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  361.199879] ESP: Command done status[0] message[0]
[  361.199946] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  361.200086] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  361.200259] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  361.200286] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  361.200307] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  361.200315] ESP: Command done status[2] message[0]
[  361.200326] esp0: Doing auto-sense for tgt[2] lun[0]
[  361.268048] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  361.268064] ESP: start data addr[c0222720] len[96] write(1)
** 8 printk messages dropped ** [  361.268649] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
** 18 printk messages dropped ** [  362.446793] ESP: start data addr[c0226720] len[96] write(1)
[  362.446908] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  362.446926] ESP: data done flgs[5] sent[32]
[  362.446946] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  362.446966] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  362.446975] ESP: Command done status[0] message[0]
[  362.447042] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  362.447181] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  362.447353] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  362.447378] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  362.447398] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  362.447407] ESP: Command done status[2] message[0]
[  362.447418] esp0: Doing auto-sense for tgt[2] lun[0]
[  362.515150] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 7 printk messages dropped ** [  362.515550] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 17 printk messages dropped ** [  363.683135] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  363.683479] ESP: start data addr[c022c720] len[96] write(1)
[  363.683594] ESP: intr sreg[83] seqreg[04] sreg2[00] ireg[10]
[  363.683612] ESP: data done flgs[5] sent[32]
[  363.683632] ESP: intr sreg[87] seqreg[04] sreg2[00] ireg[08]
[  363.683652] ESP: intr sreg[80] seqreg[04] sreg2[00] ireg[20]
[  363.683661] ESP: Command done status[0] message[0]
[  363.683726] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  363.683861] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  363.684033] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
[  363.684059] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  363.684079] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  363.684087] ESP: Command done status[2] message[0]
[  363.684098] esp0: Doing auto-sense for tgt[2] lun[0]
[  363.751832] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  363.751848] ESP: start data addr[c022e720] len[96] write(1)
** 7 printk messages dropped ** [  363.752404] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 18 printk messages dropped ** [  364.920141] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  364.920159] ESP: start data addr[c0232720] len[96] write(1)
[  364.920276] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  364.920294] ESP: data done flgs[5] sent[32]
[  364.920315] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  364.920335] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  364.920344] ESP: Command done status[0] message[0]
[  364.920413] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  364.920552] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  364.920725] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  364.920752] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  364.920772] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  364.920781] ESP: Command done status[2] message[0]
[  364.920792] esp0: Doing auto-sense for tgt[2] lun[0]
[  364.988528] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  364.988545] ESP: start data addr[c0234720] len[96] write(1)
** 7 printk messages dropped ** [  364.989105] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 18 printk messages dropped ** [  366.156819] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  366.156836] ESP: start data addr[c0238720] len[96] write(1)
[  366.156952] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  366.156970] ESP: data done flgs[5] sent[32]
[  366.156990] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  366.157010] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  366.157019] ESP: Command done status[0] message[0]
[  366.157086] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  366.157225] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  366.157398] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  366.157423] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  366.157443] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  366.157452] ESP: Command done status[2] message[0]
[  366.157462] esp0: Doing auto-sense for tgt[2] lun[0]
[  366.225187] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  366.225203] ESP: start data addr[c023a720] len[96] write(1)
** 7 printk messages dropped ** [  366.225770] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 16 printk messages dropped ** [  367.393173] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  367.393517] ESP: start data addr[c023e720] len[96] write(1)
[  367.393633] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  367.393651] ESP: data done flgs[5] sent[32]
[  367.393671] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  367.393691] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  367.393699] ESP: Command done status[0] message[0]
[  367.393765] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  367.393904] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  367.394076] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  367.394102] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  367.394122] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  367.394131] ESP: Command done status[2] message[0]
[  367.394141] esp0: Doing auto-sense for tgt[2] lun[0]
[  367.461878] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  367.461895] ESP: start data addr[c0240720] len[96] write(1)
** 7 printk messages dropped ** [  367.462455] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 16 printk messages dropped ** [  368.594442] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  368.594786] ESP: start data addr[c0244720] len[96] write(1)
[  368.594902] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  368.594920] ESP: data done flgs[5] sent[32]
[  368.594940] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  368.594960] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  368.594969] ESP: Command done status[0] message[0]
[  368.595037] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  368.595177] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  368.595351] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  368.595376] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  368.595396] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  368.595406] ESP: Command done status[2] message[0]
[  368.595416] esp0: Doing auto-sense for tgt[2] lun[0]
[  368.646465] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  368.646481] ESP: start data addr[c0246720] len[96] write(1)
** 7 printk messages dropped ** [  368.647042] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 16 printk messages dropped ** [  369.756109] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  369.756449] ESP: start data addr[c024a720] len[96] write(1)
[  369.756565] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  369.756583] ESP: data done flgs[5] sent[32]
[  369.756603] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  369.756623] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  369.756632] ESP: Command done status[0] message[0]
[  369.756699] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  369.756836] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  369.757009] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  369.757035] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  369.757055] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  369.757064] ESP: Command done status[2] message[0]
[  369.757074] esp0: Doing auto-sense for tgt[2] lun[0]
[  369.806048] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  369.806064] ESP: start data addr[c024c720] len[96] write(1)
** 7 printk messages dropped ** [  369.806626] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  370.933428] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  370.933747] ESP: start data addr[c0250720] len[96] write(1)
[  370.933862] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  370.933880] ESP: data done flgs[5] sent[32]
[  370.933900] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  370.933920] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  370.933929] ESP: Command done status[0] message[0]
[  370.933996] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  370.934136] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  370.934308] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  370.934335] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  370.934356] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  370.934364] ESP: Command done status[2] message[0]
[  370.934375] esp0: Doing auto-sense for tgt[2] lun[0]
[  370.983361] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  370.983395] ESP: start data addr[c0252720] len[96] write(1)
** 7 printk messages dropped ** [  370.983950] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
** 16 printk messages dropped ** [  372.110707] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  372.111036] ESP: start data addr[c0256720] len[96] write(1)
[  372.111152] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  372.111170] ESP: data done flgs[5] sent[32]
[  372.111190] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  372.111210] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  372.111219] ESP: Command done status[0] message[0]
[  372.111286] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  372.111422] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  372.111595] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  372.111620] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  372.111640] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  372.111649] ESP: Command done status[2] message[0]
[  372.111660] esp0: Doing auto-sense for tgt[2] lun[0]
[  372.160660] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  372.160677] ESP: start data addr[c0258720] len[96] write(1)
** 7 printk messages dropped ** [  372.161253] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 16 printk messages dropped ** [  373.288004] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  373.288334] ESP: start data addr[c025c720] len[96] write(1)
[  373.288449] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  373.288467] ESP: data done flgs[5] sent[32]
[  373.288487] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  373.288507] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  373.288516] ESP: Command done status[0] message[0]
[  373.288583] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  373.288722] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  373.288895] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  373.288921] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  373.288941] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  373.288949] ESP: Command done status[2] message[0]
[  373.288960] esp0: Doing auto-sense for tgt[2] lun[0]
[  373.337939] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  373.337956] ESP: start data addr[c025e720] len[96] write(1)
** 7 printk messages dropped ** [  373.338515] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 16 printk messages dropped ** [  374.465299] ESP: Command done status[2] message[0]
** 2 printk messages dropped ** [  374.465628] ESP: start data addr[c0262720] len[96] write(1)
[  374.465743] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  374.465762] ESP: data done flgs[5] sent[32]
[  374.465781] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  374.465801] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  374.465810] ESP: Command done status[0] message[0]
[  374.465876] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  374.466013] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  374.466186] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  374.466212] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  374.466232] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  374.466241] ESP: Command done status[2] message[0]
[  374.466252] esp0: Doing auto-sense for tgt[2] lun[0]
[  374.515237] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  374.515253] ESP: start data addr[c0264720] len[96] write(1)
** 7 printk messages dropped ** [  374.515812] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  375.642608] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  375.642926] ESP: start data addr[c0268720] len[96] write(1)
[  375.643041] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  375.643059] ESP: data done flgs[5] sent[32]
[  375.643080] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  375.643100] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  375.643109] ESP: Command done status[0] message[0]
[  375.643176] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  375.643314] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  375.643495] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  375.643522] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  375.643542] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  375.643550] ESP: Command done status[2] message[0]
[  375.643561] esp0: Doing auto-sense for tgt[2] lun[0]
[  375.692533] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  375.692549] ESP: start data addr[c026a720] len[96] write(1)
** 7 printk messages dropped ** [  375.693113] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  376.819902] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  376.820218] ESP: start data addr[c026e720] len[96] write(1)
[  376.820333] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  376.820351] ESP: data done flgs[5] sent[32]
[  376.820371] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  376.820391] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  376.820400] ESP: Command done status[0] message[0]
[  376.820466] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  376.820605] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  376.820777] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  376.820803] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  376.820823] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  376.820832] ESP: Command done status[2] message[0]
[  376.820843] esp0: Doing auto-sense for tgt[2] lun[0]
[  376.869825] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  376.869842] ESP: start data addr[c0270720] len[96] write(1)
** 7 printk messages dropped ** [  376.870406] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  377.998251] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  377.998572] ESP: start data addr[c0274720] len[96] write(1)
[  377.998689] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  377.998707] ESP: data done flgs[5] sent[32]
[  377.998727] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  377.998747] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  377.998755] ESP: Command done status[0] message[0]
[  377.998822] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  377.998961] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  377.999135] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  377.999160] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  377.999180] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  377.999188] ESP: Command done status[2] message[0]
[  377.999199] esp0: Doing auto-sense for tgt[2] lun[0]
[  378.048165] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 4 printk messages dropped ** [  378.048355] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
** 17 printk messages dropped ** [  379.175459] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 5 printk messages dropped ** [  379.175861] ESP: start data addr[c027a720] len[96] write(1)
[  379.175977] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  379.175995] ESP: data done flgs[5] sent[32]
[  379.176015] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  379.176035] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  379.176044] ESP: Command done status[0] message[0]
[  379.176111] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  379.176249] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  379.176421] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  379.176447] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  379.176467] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  379.176475] ESP: Command done status[2] message[0]
[  379.176486] esp0: Doing auto-sense for tgt[2] lun[0]
[  379.225454] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 8 printk messages dropped ** [  379.226029] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  380.352838] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  380.353164] ESP: start data addr[c0280720] len[96] write(1)
[  380.353280] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  380.353297] ESP: data done flgs[5] sent[32]
[  380.353318] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  380.353338] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  380.353346] ESP: Command done status[0] message[0]
[  380.353414] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  380.353554] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  380.353728] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  380.353754] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  380.353774] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  380.353782] ESP: Command done status[2] message[0]
[  380.353793] esp0: Doing auto-sense for tgt[2] lun[0]
[  380.402755] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  380.402772] ESP: start data addr[c0282720] len[96] write(1)
** 7 printk messages dropped ** [  380.403333] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  381.530124] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  381.530443] ESP: start data addr[c0286720] len[96] write(1)
[  381.530559] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  381.530577] ESP: data done flgs[5] sent[32]
[  381.530597] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  381.530617] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  381.530626] ESP: Command done status[0] message[0]
[  381.530692] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  381.530831] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  381.531004] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  381.531030] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  381.531050] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  381.531058] ESP: Command done status[2] message[0]
[  381.531069] esp0: Doing auto-sense for tgt[2] lun[0]
[  381.580052] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  381.580069] ESP: start data addr[c0288720] len[96] write(1)
** 7 printk messages dropped ** [  381.580627] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  382.707429] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  382.707749] ESP: start data addr[c028c720] len[96] write(1)
[  382.707865] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  382.707883] ESP: data done flgs[5] sent[32]
[  382.707904] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  382.707924] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  382.707933] ESP: Command done status[0] message[0]
[  382.708000] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  382.708143] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  382.708317] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  382.708342] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  382.708362] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  382.708371] ESP: Command done status[2] message[0]
[  382.708382] esp0: Doing auto-sense for tgt[2] lun[0]
[  382.757347] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  382.757363] ESP: start data addr[c028e720] len[96] write(1)
** 7 printk messages dropped ** [  382.757948] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  383.884716] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  383.885034] ESP: start data addr[c0292720] len[96] write(1)
[  383.885150] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  383.885167] ESP: data done flgs[5] sent[32]
[  383.885187] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  383.885207] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  383.885216] ESP: Command done status[0] message[0]
[  383.885281] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  383.885418] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  383.885591] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  383.885617] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  383.885637] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  383.885645] ESP: Command done status[2] message[0]
[  383.885657] esp0: Doing auto-sense for tgt[2] lun[0]
[  383.934639] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  383.934655] ESP: start data addr[c0294720] len[96] write(1)
** 7 printk messages dropped ** [  383.935214] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  385.063059] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  385.063377] ESP: start data addr[c0298720] len[96] write(1)
[  385.063492] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  385.063510] ESP: data done flgs[5] sent[32]
[  385.063530] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  385.063550] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  385.063559] ESP: Command done status[0] message[0]
[  385.063625] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  385.063765] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  385.063938] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  385.063964] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  385.063984] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  385.063992] ESP: Command done status[2] message[0]
[  385.064003] esp0: Doing auto-sense for tgt[2] lun[0]
[  385.112976] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  385.112992] ESP: start data addr[c029a720] len[96] write(1)
** 7 printk messages dropped ** [  385.113551] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  386.240349] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  386.240668] ESP: start data addr[c029e720] len[96] write(1)
[  386.240783] ESP: intr sreg[83] seqreg[04] sreg2[00] ireg[10]
[  386.240801] ESP: data done flgs[5] sent[32]
[  386.240821] ESP: intr sreg[87] seqreg[04] sreg2[00] ireg[08]
[  386.240841] ESP: intr sreg[80] seqreg[04] sreg2[00] ireg[20]
[  386.240850] ESP: Command done status[0] message[0]
[  386.240916] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  386.241055] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  386.241229] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
[  386.241254] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  386.241275] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  386.241283] ESP: Command done status[2] message[0]
[  386.241295] esp0: Doing auto-sense for tgt[2] lun[0]
[  386.290275] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  386.290291] ESP: start data addr[c02a0720] len[96] write(1)
** 7 printk messages dropped ** [  386.290849] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  387.417650] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  387.417968] ESP: start data addr[c02a4720] len[96] write(1)
[  387.418084] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  387.418101] ESP: data done flgs[5] sent[32]
[  387.418121] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  387.418142] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  387.418150] ESP: Command done status[0] message[0]
[  387.418216] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  387.418356] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  387.418529] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  387.418555] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  387.418575] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  387.418583] ESP: Command done status[2] message[0]
[  387.418595] esp0: Doing auto-sense for tgt[2] lun[0]
[  387.467570] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  387.467586] ESP: start data addr[c02a6720] len[96] write(1)
** 7 printk messages dropped ** [  387.468145] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  388.594948] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  388.595266] ESP: start data addr[c02aa720] len[96] write(1)
[  388.595382] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  388.595400] ESP: data done flgs[5] sent[32]
[  388.595420] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  388.595440] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  388.595448] ESP: Command done status[0] message[0]
[  388.595515] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  388.595654] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  388.595827] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  388.595854] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  388.595874] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  388.595882] ESP: Command done status[2] message[0]
[  388.595893] esp0: Doing auto-sense for tgt[2] lun[0]
[  388.644867] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  388.644883] ESP: start data addr[c02ac720] len[96] write(1)
** 7 printk messages dropped ** [  388.645442] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 13 printk messages dropped ** [  389.772156] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 5 printk messages dropped ** [  389.772557] ESP: start data addr[c02b0720] len[96] write(1)
[  389.772673] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  389.772691] ESP: data done flgs[5] sent[32]
[  389.772711] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  389.772731] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  389.772739] ESP: Command done status[0] message[0]
[  389.772806] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  389.772946] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  389.773119] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  389.773145] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  389.773165] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  389.773173] ESP: Command done status[2] message[0]
[  389.773184] esp0: Doing auto-sense for tgt[2] lun[0]
[  389.822160] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 8 printk messages dropped ** [  389.822732] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  390.949541] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  390.949860] ESP: start data addr[c02b6720] len[96] write(1)
[  390.949976] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  390.949994] ESP: data done flgs[5] sent[32]
[  390.950014] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  390.950033] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  390.950042] ESP: Command done status[0] message[0]
[  390.950107] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  390.950246] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  390.950419] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  390.950445] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  390.950464] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  390.950473] ESP: Command done status[2] message[0]
[  390.950484] esp0: Doing auto-sense for tgt[2] lun[0]
[  390.999475] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 8 printk messages dropped ** [  391.000067] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  392.126835] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  392.127154] ESP: start data addr[c02bc720] len[96] write(1)
[  392.127269] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  392.127287] ESP: data done flgs[5] sent[32]
[  392.127308] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  392.127328] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  392.127336] ESP: Command done status[0] message[0]
[  392.127403] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  392.127548] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  392.127724] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  392.127750] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  392.127771] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  392.127780] ESP: Command done status[2] message[0]
[  392.127791] esp0: Doing auto-sense for tgt[2] lun[0]
[  392.176768] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 8 printk messages dropped ** [  392.177382] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  393.305159] esp0: Doing auto-sense for tgt[2] lun[0]
** 1 printk messages dropped ** [  393.305486] ESP: start data addr[c02c2720] len[96] write(1)
[  393.305602] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  393.305619] ESP: data done flgs[5] sent[32]
[  393.305639] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  393.305659] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  393.305668] ESP: Command done status[0] message[0]
[  393.305735] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  393.305873] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  393.306046] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  393.306072] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  393.306092] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  393.306101] ESP: Command done status[2] message[0]
[  393.306112] esp0: Doing auto-sense for tgt[2] lun[0]
[  393.355091] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 8 printk messages dropped ** [  393.355666] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
** 18 printk messages dropped ** [  394.482462] esp0: Doing auto-sense for tgt[2] lun[0]
[  394.482762] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  394.482779] ESP: start data addr[c02ca720] len[96] write(1)
[  394.482895] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  394.482913] ESP: data done flgs[5] sent[32]
[  394.482933] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  394.482953] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  394.482961] ESP: Command done status[0] message[0]
[  394.483033] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  394.483213] ESP: tgt[2] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
[  394.532389] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  394.532431] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  394.532452] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  394.532461] ESP: Command done status[2] message[0]
[  394.532472] esp0: Doing auto-sense for tgt[2] lun[0]
[  394.532786] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 7 printk messages dropped ** [  394.533225] ESP: tgt[2] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
** 17 printk messages dropped ** [  394.674894] Sense Key : Not Ready [current] 
** 1 printk messages dropped ** [  394.674931] Add. Sense: Logical unit not ready, cause not reportable
[  394.675024] ESP: tgt[2] lun[0] scsi_cmd [ 1a 00 3f 00 04 00 ]
[  394.776187] ESP: intr sreg[93] seqreg[03] sreg2[00] ireg[18]
[  394.776213] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  394.776233] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  394.776242] ESP: Command done status[2] message[0]
[  394.776253] esp0: Doing auto-sense for tgt[2] lun[0]
[  394.776568] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  394.776584] ESP: start data addr[c02d6720] len[96] write(1)
[  394.776700] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  394.776717] ESP: data done flgs[5] sent[32]
[  394.776738] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  394.776757] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
[  394.776766] ESP: Command done status[0] message[0]
[  394.776836] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 6 printk messages dropped ** [  394.878275] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
** 17 printk messages dropped ** [  394.970149] ESP: intr sreg[87] seqreg[04] sreg2[00] ireg[08]
** 2 printk messages dropped ** [  394.970246] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  394.970355] sd 0:0:2:0: [sdc] Test WP failed, assume Write Enabled
[  394.970441] ESP: tgt[2] lun[0] scsi_cmd [ 1a 00 08 00 04 00 ]
[  394.970615] ESP: intr sreg[93] seqreg[04] sreg2[00] ireg[18]
[  394.970640] ESP: intr sreg[97] seqreg[04] sreg2[00] ireg[08]
[  394.970660] ESP: intr sreg[90] seqreg[04] sreg2[00] ireg[20]
[  394.970669] ESP: Command done status[2] message[0]
[  394.970680] esp0: Doing auto-sense for tgt[2] lun[0]
[  395.061645] ESP: intr sreg[91] seqreg[04] sreg2[00] ireg[18]
[  395.061661] ESP: start data addr[c02e2720] len[96] write(1)
[  395.061781] ESP: intr sreg[83] seqreg[03] sreg2[00] ireg[10]
[  395.061800] ESP: data done flgs[5] sent[32]
[  395.061821] ESP: intr sreg[87] seqreg[03] sreg2[00] ireg[08]
[  395.061841] ESP: intr sreg[80] seqreg[03] sreg2[00] ireg[20]
** 5 printk messages dropped ** [  395.062381] ESP: intr sreg[91] seqreg[03] sreg2[00] ireg[18]
** 18 printk messages dropped ** [  395.267280] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
** 2 printk messages dropped ** [  395.267440] ESP: data done flgs[5] sent[32]
[  395.267461] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  395.267481] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  395.267490] ESP: Command done status[0] message[0]
[  395.267557] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  395.267602] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  395.267772] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  395.267796] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  395.267816] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  395.267824] ESP: Command done status[2] message[0]
[  395.267835] esp0: Doing auto-sense for tgt[2] lun[0]
[  395.408588] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  395.408604] ESP: start data addr[c02e8780] len[96] write(1)
[  395.408725] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
** 7 printk messages dropped ** [  395.409095] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  395.511075] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
** 2 printk messages dropped ** [  395.511224] ESP: data done flgs[5] sent[32]
[  395.511244] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  395.511264] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  395.511272] ESP: Command done status[0] message[0]
[  395.511339] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  395.511434] sd 0:0:2:0: [sdc] Spinning up disk...
[  395.511502] ESP: tgt[2] lun[0] scsi_cmd [ 1b 01 00 00 01 00 ]
[  395.511616] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  395.511641] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  395.511662] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  395.511670] ESP: Command done status[0] message[0]
[  396.517472] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  396.521292] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  396.521326] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
** 7 printk messages dropped ** [  396.521854] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 16 printk messages dropped ** [  396.629902] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 2 printk messages dropped ** [  396.630237] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  396.630257] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  396.630265] ESP: Command done status[2] message[0]
[  396.630276] esp0: Doing auto-sense for tgt[2] lun[0]
[  396.630590] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  396.630606] ESP: start data addr[c02f2720] len[96] write(1)
[  396.730703] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  396.730721] ESP: data done flgs[5] sent[32]
[  396.730742] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  396.730761] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  396.730789] ESP: Command done status[0] message[0]
[  396.730856] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  397.737464] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  397.797566] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  397.798129] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 16 printk messages dropped ** [  397.867627] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 2 printk messages dropped ** [  397.867963] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  397.867983] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  397.867992] ESP: Command done status[2] message[0]
[  397.868003] esp0: Doing auto-sense for tgt[2] lun[0]
[  397.868317] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  397.868332] ESP: start data addr[c02f8720] len[96] write(1)
[  397.968439] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  397.968457] ESP: data done flgs[5] sent[32]
[  397.968477] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  397.968507] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  397.968516] ESP: Command done status[0] message[0]
[  397.968583] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  398.977458] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  399.045725] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  399.046281] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  399.115908] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  399.116107] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  399.116127] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  399.116135] ESP: Command done status[2] message[0]
[  399.116146] esp0: Doing auto-sense for tgt[2] lun[0]
[  399.116459] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  399.116475] ESP: start data addr[c02fe720] len[96] write(1)
[  399.216563] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  399.216581] ESP: data done flgs[5] sent[32]
[  399.216601] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  399.216622] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  399.216649] ESP: Command done status[0] message[0]
[  399.216716] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  400.217448] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  400.283430] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  400.283987] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  400.353630] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  400.353829] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  400.353849] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  400.353857] ESP: Command done status[2] message[0]
[  400.353868] esp0: Doing auto-sense for tgt[2] lun[0]
[  400.354183] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  400.354198] ESP: start data addr[c0304720] len[96] write(1)
[  400.454288] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  400.454306] ESP: data done flgs[5] sent[32]
[  400.454326] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  400.454346] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  400.454372] ESP: Command done status[0] message[0]
[  400.454439] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  401.457446] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  401.521153] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  401.521708] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  401.591353] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  401.591552] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  401.591572] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  401.591581] ESP: Command done status[2] message[0]
[  401.591592] esp0: Doing auto-sense for tgt[2] lun[0]
[  401.591905] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  401.591921] ESP: start data addr[c030a720] len[96] write(1)
[  401.692014] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  401.692032] ESP: data done flgs[5] sent[32]
[  401.692051] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  401.692071] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  401.692098] ESP: Command done status[0] message[0]
[  401.692165] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  402.697421] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  402.758874] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  402.759430] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 16 printk messages dropped ** [  402.820608] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 2 printk messages dropped ** [  402.820942] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  402.820963] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  402.820972] ESP: Command done status[2] message[0]
[  402.820983] esp0: Doing auto-sense for tgt[2] lun[0]
[  402.821296] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  402.821312] ESP: start data addr[c0310720] len[96] write(1)
[  402.919318] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  402.919336] ESP: data done flgs[5] sent[32]
[  402.919356] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  402.919376] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  402.919402] ESP: Command done status[0] message[0]
[  402.919468] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  403.927416] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  403.986193] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  403.986754] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  404.053252] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  404.053451] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  404.053471] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  404.053480] ESP: Command done status[2] message[0]
[  404.053491] esp0: Doing auto-sense for tgt[2] lun[0]
[  404.053805] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  404.053821] ESP: start data addr[c0316720] len[96] write(1)
[  404.154972] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  404.154989] ESP: data done flgs[5] sent[32]
[  404.155010] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  404.155040] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  404.155050] ESP: Command done status[0] message[0]
[  404.155116] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  405.157413] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  405.164524] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  405.165085] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  405.232633] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  405.232832] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  405.232852] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  405.232861] ESP: Command done status[2] message[0]
[  405.232872] esp0: Doing auto-sense for tgt[2] lun[0]
[  405.233186] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  405.233202] ESP: start data addr[c031c720] len[96] write(1)
[  405.334332] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  405.334349] ESP: data done flgs[5] sent[32]
[  405.334370] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  405.334390] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  405.334416] ESP: Command done status[0] message[0]
[  405.334482] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  406.337398] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  406.401204] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  406.401760] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  406.468277] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  406.468475] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  406.468496] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  406.468504] ESP: Command done status[2] message[0]
[  406.468515] esp0: Doing auto-sense for tgt[2] lun[0]
[  406.468829] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  406.468845] ESP: start data addr[c0322720] len[96] write(1)
[  406.569978] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  406.569996] ESP: data done flgs[5] sent[32]
[  406.570017] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  406.570037] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  406.570064] ESP: Command done status[0] message[0]
[  406.570129] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  407.577402] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  407.636838] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  407.637398] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  407.703922] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  407.704120] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  407.704140] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  407.704148] ESP: Command done status[2] message[0]
[  407.704159] esp0: Doing auto-sense for tgt[2] lun[0]
[  407.704473] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  407.704489] ESP: start data addr[c0328720] len[96] write(1)
[  407.805615] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  407.805633] ESP: data done flgs[5] sent[32]
[  407.805653] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  407.805672] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  407.805681] ESP: Command done status[0] message[0]
[  407.805769] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  408.807371] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  408.807548] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  408.874734] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  408.941516] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  408.941717] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  408.941738] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  408.941747] ESP: Command done status[2] message[0]
[  408.941758] esp0: Doing auto-sense for tgt[2] lun[0]
[  408.942072] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  408.942088] ESP: start data addr[c032e720] len[96] write(1)
[  408.942204] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  408.942222] ESP: data done flgs[5] sent[32]
[  408.942242] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  408.942262] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  408.942270] ESP: Command done status[0] message[0]
[  408.942335] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  409.947370] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  409.950804] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  409.951367] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  410.018932] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  410.019130] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  410.019150] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  410.019158] ESP: Command done status[2] message[0]
[  410.019170] esp0: Doing auto-sense for tgt[2] lun[0]
[  410.019483] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  410.019499] ESP: start data addr[c0334720] len[96] write(1)
[  410.120617] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  410.120635] ESP: data done flgs[5] sent[32]
[  410.120655] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  410.120675] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  410.120702] ESP: Command done status[0] message[0]
[  410.120768] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  411.127363] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  411.187476] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  411.188031] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  411.254561] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  411.254759] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  411.254779] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  411.254787] ESP: Command done status[2] message[0]
[  411.254798] esp0: Doing auto-sense for tgt[2] lun[0]
[  411.255112] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  411.255128] ESP: start data addr[c033a720] len[96] write(1)
[  411.356251] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  411.356269] ESP: data done flgs[5] sent[32]
[  411.356289] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  411.356308] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  411.356317] ESP: Command done status[0] message[0]
[  411.356404] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  412.357361] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  412.357537] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  412.358088] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  412.425981] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  412.426180] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  412.426201] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  412.426209] ESP: Command done status[2] message[0]
[  412.426220] esp0: Doing auto-sense for tgt[2] lun[0]
[  412.526258] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  412.526274] ESP: start data addr[c0340720] len[96] write(1)
[  412.526394] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  412.526413] ESP: data done flgs[5] sent[32]
[  412.526434] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  412.526454] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  412.526463] ESP: Command done status[0] message[0]
[  412.526530] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  413.527352] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  413.537905] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  413.538460] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  413.606023] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  413.606221] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  413.606241] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  413.606250] ESP: Command done status[2] message[0]
[  413.606261] esp0: Doing auto-sense for tgt[2] lun[0]
[  413.606574] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  413.606590] ESP: start data addr[c0346720] len[96] write(1)
[  413.707725] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  413.707744] ESP: data done flgs[5] sent[32]
[  413.707764] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  413.707783] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  413.707792] ESP: Command done status[0] message[0]
[  413.707880] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  414.717330] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  414.776669] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  414.777240] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  414.843754] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  414.843952] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  414.843972] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  414.843980] ESP: Command done status[2] message[0]
[  414.843991] esp0: Doing auto-sense for tgt[2] lun[0]
[  414.844305] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  414.844321] ESP: start data addr[c034c720] len[96] write(1)
[  414.945445] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  414.945463] ESP: data done flgs[5] sent[32]
[  414.945483] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  414.945503] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  414.945511] ESP: Command done status[0] message[0]
[  414.945599] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  415.947322] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  415.947497] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  416.014574] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
** 16 printk messages dropped ** [  416.081207] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 2 printk messages dropped ** [  416.081546] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  416.081567] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  416.081576] ESP: Command done status[2] message[0]
[  416.081587] esp0: Doing auto-sense for tgt[2] lun[0]
[  416.081900] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  416.081916] ESP: start data addr[c0352720] len[96] write(1)
[  416.082032] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  416.082050] ESP: data done flgs[5] sent[32]
[  416.082070] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  416.082089] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  416.082098] ESP: Command done status[0] message[0]
[  416.082164] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  417.087318] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  417.090632] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  417.091191] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  417.158747] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  417.158945] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  417.158965] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  417.158973] ESP: Command done status[2] message[0]
[  417.158984] esp0: Doing auto-sense for tgt[2] lun[0]
[  417.159298] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  417.159313] ESP: start data addr[c0358720] len[96] write(1)
[  417.260442] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  417.260460] ESP: data done flgs[5] sent[32]
[  417.260481] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  417.260501] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  417.260528] ESP: Command done status[0] message[0]
[  417.260594] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  418.200345] random: nonblocking pool is initialized
[  418.267310] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  418.327309] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 7 printk messages dropped ** [  418.327845] ESP: data done flgs[5] sent[32]
** 15 printk messages dropped ** [  418.394176] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
** 3 printk messages dropped ** [  418.394561] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  418.394587] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  418.394607] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  418.394616] ESP: Command done status[2] message[0]
[  418.394627] esp0: Doing auto-sense for tgt[2] lun[0]
[  418.394940] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  418.394957] ESP: start data addr[c035e720] len[96] write(1)
[  418.495043] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  418.495061] ESP: data done flgs[5] sent[32]
[  418.495081] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  418.495101] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  418.495110] ESP: Command done status[0] message[0]
[  418.495197] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  419.497307] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 8 printk messages dropped ** [  419.539522] ESP: data done flgs[5] sent[32]
** 15 printk messages dropped ** [  419.605855] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
** 3 printk messages dropped ** [  419.606239] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  419.606264] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  419.606285] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  419.606293] ESP: Command done status[2] message[0]
[  419.606304] esp0: Doing auto-sense for tgt[2] lun[0]
[  419.606617] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  419.606633] ESP: start data addr[c0364720] len[96] write(1)
[  419.706719] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  419.706737] ESP: data done flgs[5] sent[32]
[  419.706757] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  419.706777] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  419.706785] ESP: Command done status[0] message[0]
[  419.706872] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  420.707282] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 8 printk messages dropped ** [  420.751200] ESP: data done flgs[5] sent[32]
** 17 printk messages dropped ** [  420.817605] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 1 printk messages dropped ** [  420.817915] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  420.817940] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  420.817960] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  420.817969] ESP: Command done status[2] message[0]
[  420.817980] esp0: Doing auto-sense for tgt[2] lun[0]
[  420.818293] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  420.818310] ESP: start data addr[c036a720] len[96] write(1)
[  420.918399] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  420.918417] ESP: data done flgs[5] sent[32]
[  420.918437] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  420.918458] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  420.918485] ESP: Command done status[0] message[0]
[  420.918551] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  421.927278] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 9 printk messages dropped ** [  421.985835] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  422.052341] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  422.052540] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  422.052560] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  422.052569] ESP: Command done status[2] message[0]
[  422.052580] esp0: Doing auto-sense for tgt[2] lun[0]
[  422.052893] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  422.052909] ESP: start data addr[c0370720] len[96] write(1)
[  422.152994] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  422.153012] ESP: data done flgs[5] sent[32]
[  422.153032] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  422.153052] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  422.153079] ESP: Command done status[0] message[0]
[  422.153146] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  423.157262] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  423.219858] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  423.220413] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  423.286940] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  423.287138] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  423.287158] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  423.287167] ESP: Command done status[2] message[0]
[  423.287178] esp0: Doing auto-sense for tgt[2] lun[0]
[  423.287495] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  423.287513] ESP: start data addr[c0376720] len[96] write(1)
[  423.387588] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  423.387606] ESP: data done flgs[5] sent[32]
[  423.387626] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  423.387647] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  423.387674] ESP: Command done status[0] message[0]
[  423.387741] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  424.397267] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  424.454460] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  424.455017] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  424.521536] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  424.521735] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  424.521755] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  424.521764] ESP: Command done status[2] message[0]
[  424.521775] esp0: Doing auto-sense for tgt[2] lun[0]
[  424.522088] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  424.522104] ESP: start data addr[c037c720] len[96] write(1)
[  424.622190] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  424.622207] ESP: data done flgs[5] sent[32]
[  424.622228] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  424.622248] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  424.622257] ESP: Command done status[0] message[0]
[  424.622346] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  425.627251] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  425.691142] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  425.691700] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  425.758220] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  425.758419] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  425.758440] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  425.758448] ESP: Command done status[2] message[0]
[  425.758459] esp0: Doing auto-sense for tgt[2] lun[0]
[  425.758773] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  425.758790] ESP: start data addr[c0382720] len[96] write(1)
[  425.858873] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  425.858891] ESP: data done flgs[5] sent[32]
[  425.858911] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  425.858932] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  425.858958] ESP: Command done status[0] message[0]
[  425.859024] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  426.867235] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  426.925738] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  426.926293] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  426.992830] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  426.993028] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  426.993049] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  426.993057] ESP: Command done status[2] message[0]
[  426.993068] esp0: Doing auto-sense for tgt[2] lun[0]
[  426.993381] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  426.993397] ESP: start data addr[c0388720] len[96] write(1)
[  427.093468] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  427.093486] ESP: data done flgs[5] sent[32]
[  427.093506] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  427.093527] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  427.093553] ESP: Command done status[0] message[0]
[  427.093619] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  428.097225] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  428.160347] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  428.160904] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  428.227424] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  428.227623] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  428.227643] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  428.227652] ESP: Command done status[2] message[0]
[  428.227663] esp0: Doing auto-sense for tgt[2] lun[0]
[  428.227976] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  428.227993] ESP: start data addr[c038e720] len[96] write(1)
[  428.328068] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  428.328086] ESP: data done flgs[5] sent[32]
[  428.328106] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  428.328127] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  428.328154] ESP: Command done status[0] message[0]
[  428.328220] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  429.337224] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  429.394936] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  429.395499] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  429.462016] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  429.462215] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  429.462236] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  429.462244] ESP: Command done status[2] message[0]
[  429.462255] esp0: Doing auto-sense for tgt[2] lun[0]
[  429.462569] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  429.462585] ESP: start data addr[c0394720] len[96] write(1)
[  429.562669] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  429.562687] ESP: data done flgs[5] sent[32]
[  429.562707] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  429.562727] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  429.562735] ESP: Command done status[0] message[0]
[  429.562824] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  430.567213] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  430.631617] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  430.632173] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  430.698697] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  430.698896] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  430.698916] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  430.698925] ESP: Command done status[2] message[0]
[  430.698936] esp0: Doing auto-sense for tgt[2] lun[0]
[  430.699250] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  430.699267] ESP: start data addr[c039a720] len[96] write(1)
[  430.799350] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  430.799368] ESP: data done flgs[5] sent[32]
[  430.799388] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  430.799407] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  430.799416] ESP: Command done status[0] message[0]
[  430.799505] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  431.807196] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  431.868301] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  431.868858] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  431.935374] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  431.935574] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  431.935594] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  431.935603] ESP: Command done status[2] message[0]
[  431.935614] esp0: Doing auto-sense for tgt[2] lun[0]
[  431.935927] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  431.935943] ESP: start data addr[c03a0720] len[96] write(1)
[  432.036045] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  432.036063] ESP: data done flgs[5] sent[32]
[  432.036084] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  432.036104] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  432.036113] ESP: Command done status[0] message[0]
[  432.036194] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  433.037191] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  433.037367] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  433.037918] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  433.105758] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  433.105957] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  433.105977] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  433.105985] ESP: Command done status[2] message[0]
[  433.105996] esp0: Doing auto-sense for tgt[2] lun[0]
[  433.206031] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  433.206047] ESP: start data addr[c03a6720] len[96] write(1)
[  433.206167] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  433.206186] ESP: data done flgs[5] sent[32]
[  433.206207] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  433.206227] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  433.206236] ESP: Command done status[0] message[0]
[  433.206304] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  434.207187] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  434.215595] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  434.216157] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  434.283707] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  434.283905] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  434.283925] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  434.283934] ESP: Command done status[2] message[0]
[  434.283945] esp0: Doing auto-sense for tgt[2] lun[0]
[  434.284258] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  434.284274] ESP: start data addr[c03ac720] len[96] write(1)
[  434.384372] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  434.384390] ESP: data done flgs[5] sent[32]
[  434.384410] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  434.384430] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  434.384438] ESP: Command done status[0] message[0]
[  434.384527] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  435.387172] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  435.453314] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  435.453872] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
** 16 printk messages dropped ** [  435.520259] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
** 2 printk messages dropped ** [  435.520595] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  435.520615] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  435.520624] ESP: Command done status[2] message[0]
[  435.520635] esp0: Doing auto-sense for tgt[2] lun[0]
[  435.520949] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  435.520964] ESP: start data addr[c03b2720] len[96] write(1)
[  435.621051] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  435.621068] ESP: data done flgs[5] sent[32]
[  435.621089] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  435.621109] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  435.621117] ESP: Command done status[0] message[0]
[  435.621205] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  436.627166] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  436.690005] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  436.690562] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  436.757103] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  436.757305] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  436.757326] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  436.757335] ESP: Command done status[2] message[0]
[  436.757346] esp0: Doing auto-sense for tgt[2] lun[0]
[  436.757659] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  436.757676] ESP: start data addr[c03b8720] len[96] write(1)
[  436.857731] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  436.857749] ESP: data done flgs[5] sent[32]
[  436.857770] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  436.857790] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  436.857798] ESP: Command done status[0] message[0]
[  436.857886] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  437.867149] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  437.926681] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 8 printk messages dropped ** [  437.927246] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
** 17 printk messages dropped ** [  437.993781] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 1 printk messages dropped ** [  437.993980] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  437.994000] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  437.994008] ESP: Command done status[2] message[0]
[  437.994019] esp0: Doing auto-sense for tgt[2] lun[0]
[  437.994333] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  437.994349] ESP: start data addr[c03be720] len[96] write(1)
[  438.094412] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  438.094430] ESP: data done flgs[5] sent[32]
[  438.094450] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  438.094469] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  438.094478] ESP: Command done status[0] message[0]
[  438.094566] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  439.097138] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  439.163358] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
** 9 printk messages dropped ** [  439.163936] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
** 16 printk messages dropped ** [  439.230440] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
** 22 printk messages dropped ** [  440.400581] ESP: data done flgs[5] sent[32]
** 11 printk messages dropped ** [  440.466738] ESP: start data addr[c03c8720] len[96] write(1)
** 14 printk messages dropped ** [  440.567776] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
** 14 printk messages dropped ** [  441.637265] ESP: data done flgs[5] sent[32]
** 15 printk messages dropped ** [  441.703597] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  441.703606] ESP: Command done status[0] message[0]
[  441.703672] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  441.703811] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  441.703985] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  441.704010] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  441.704030] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  441.704039] ESP: Command done status[2] message[0]
[  441.704049] esp0: Doing auto-sense for tgt[2] lun[0]
[  441.704362] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  441.704379] ESP: start data addr[c03d0720] len[96] write(1)
[  441.804458] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  441.804476] ESP: data done flgs[5] sent[32]
[  441.804497] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  441.804516] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  441.804525] ESP: Command done status[0] message[0]
[  441.804613] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  442.807104] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  442.873402] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  442.873430] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  442.873456] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  442.873466] ESP: Command done status[2] message[0]
[  442.873476] esp0: Doing auto-sense for tgt[2] lun[0]
[  442.873787] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  442.873805] ESP: start data addr[c03d2720] len[96] write(1)
[  442.873920] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  442.873938] ESP: data done flgs[5] sent[32]
[  442.873958] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  442.873978] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  442.873987] ESP: Command done status[0] message[0]
[  442.874053] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  442.874193] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  442.874366] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  442.874392] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  442.874412] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  442.874420] ESP: Command done status[2] message[0]
[  442.874431] esp0: Doing auto-sense for tgt[2] lun[0]
[  442.940085] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  442.940101] ESP: start data addr[c03d4720] len[96] write(1)
[  442.940218] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  442.940236] ESP: data done flgs[5] sent[32]
[  442.940256] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  442.940275] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  442.940284] ESP: Command done status[0] message[0]
[  442.940350] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  442.940487] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  442.940661] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  442.940687] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  442.940708] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  442.940716] ESP: Command done status[2] message[0]
[  442.940727] esp0: Doing auto-sense for tgt[2] lun[0]
[  442.941041] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  442.941057] ESP: start data addr[c03d6720] len[96] write(1)
[  443.041151] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  443.041169] ESP: data done flgs[5] sent[32]
[  443.041190] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  443.041209] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  443.041218] ESP: Command done status[0] message[0]
[  443.041298] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  444.047098] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  444.110090] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  444.110116] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  444.110141] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  444.110151] ESP: Command done status[2] message[0]
[  444.110162] esp0: Doing auto-sense for tgt[2] lun[0]
[  444.110474] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  444.110491] ESP: start data addr[c03d8720] len[96] write(1)
[  444.110607] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  444.110625] ESP: data done flgs[5] sent[32]
[  444.110645] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  444.110665] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  444.110674] ESP: Command done status[0] message[0]
[  444.110739] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  444.110876] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  444.111050] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  444.111075] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  444.111095] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  444.111103] ESP: Command done status[2] message[0]
[  444.111114] esp0: Doing auto-sense for tgt[2] lun[0]
[  444.176784] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  444.176802] ESP: start data addr[c03da720] len[96] write(1)
[  444.176931] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  444.176950] ESP: data done flgs[5] sent[32]
[  444.176971] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  444.176991] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  444.177000] ESP: Command done status[0] message[0]
[  444.177067] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  444.177211] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  444.177386] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  444.177413] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  444.177433] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  444.177442] ESP: Command done status[2] message[0]
[  444.177453] esp0: Doing auto-sense for tgt[2] lun[0]
[  444.277819] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  444.277836] ESP: start data addr[c03dc720] len[96] write(1)
[  444.277952] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  444.277970] ESP: data done flgs[5] sent[32]
[  444.277990] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  444.278010] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  444.278019] ESP: Command done status[0] message[0]
[  444.278085] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  445.287100] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  445.287385] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  445.287418] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  445.287440] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  445.287448] ESP: Command done status[2] message[0]
[  445.287459] esp0: Doing auto-sense for tgt[2] lun[0]
[  445.287776] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  445.287794] ESP: start data addr[c03de720] len[96] write(1)
[  445.287909] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  445.287927] ESP: data done flgs[5] sent[32]
[  445.287947] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  445.287967] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  445.287976] ESP: Command done status[0] message[0]
[  445.288043] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  445.288177] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  445.288351] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  445.288377] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  445.288398] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  445.288406] ESP: Command done status[2] message[0]
[  445.288417] esp0: Doing auto-sense for tgt[2] lun[0]
[  445.355100] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  445.355116] ESP: start data addr[c03e0720] len[96] write(1)
[  445.355233] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  445.355251] ESP: data done flgs[5] sent[32]
[  445.355271] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  445.355291] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  445.355300] ESP: Command done status[0] message[0]
[  445.355366] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  445.355504] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  445.355676] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  445.355702] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  445.355722] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  445.355730] ESP: Command done status[2] message[0]
[  445.355741] esp0: Doing auto-sense for tgt[2] lun[0]
[  445.356054] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  445.356070] ESP: start data addr[c03e2720] len[96] write(1)
[  445.456160] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  445.456178] ESP: data done flgs[5] sent[32]
[  445.456198] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  445.456218] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  445.456227] ESP: Command done status[0] message[0]
[  445.456315] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  446.457097] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  446.457394] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  446.457423] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  446.457444] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  446.457453] ESP: Command done status[2] message[0]
[  446.457464] esp0: Doing auto-sense for tgt[2] lun[0]
[  446.457780] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  446.457797] ESP: start data addr[c03e4720] len[96] write(1)
[  446.457913] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  446.457931] ESP: data done flgs[5] sent[32]
[  446.457950] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  446.457971] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  446.457980] ESP: Command done status[0] message[0]
[  446.458047] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  446.458182] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  446.458354] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  446.458380] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  446.458400] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  446.458408] ESP: Command done status[2] message[0]
[  446.458419] esp0: Doing auto-sense for tgt[2] lun[0]
[  446.525104] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  446.525121] ESP: start data addr[c03e6720] len[96] write(1)
[  446.525237] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  446.525254] ESP: data done flgs[5] sent[32]
[  446.525274] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  446.525294] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  446.525302] ESP: Command done status[0] message[0]
[  446.525368] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  446.525505] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  446.525678] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  446.525704] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  446.525724] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  446.525732] ESP: Command done status[2] message[0]
[  446.525743] esp0: Doing auto-sense for tgt[2] lun[0]
[  446.526058] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  446.526074] ESP: start data addr[c03e8720] len[96] write(1)
[  446.626158] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  446.626176] ESP: data done flgs[5] sent[32]
[  446.626196] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  446.626216] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  446.626225] ESP: Command done status[0] message[0]
[  446.626314] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  447.627088] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  447.627392] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  447.627426] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  447.627447] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  447.627456] ESP: Command done status[2] message[0]
[  447.627467] esp0: Doing auto-sense for tgt[2] lun[0]
[  447.627784] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  447.627801] ESP: start data addr[c03ea720] len[96] write(1)
[  447.627917] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  447.627935] ESP: data done flgs[5] sent[32]
[  447.627955] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  447.627975] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  447.627984] ESP: Command done status[0] message[0]
[  447.628052] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  447.628186] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  447.628359] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  447.628386] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  447.628407] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  447.628415] ESP: Command done status[2] message[0]
[  447.628426] esp0: Doing auto-sense for tgt[2] lun[0]
[  447.695109] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  447.695126] ESP: start data addr[c03ec720] len[96] write(1)
[  447.695247] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  447.695266] ESP: data done flgs[5] sent[32]
[  447.695287] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  447.695307] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  447.695315] ESP: Command done status[0] message[0]
[  447.695382] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  447.695518] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  447.695690] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  447.695716] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  447.695736] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  447.695745] ESP: Command done status[2] message[0]
[  447.695755] esp0: Doing auto-sense for tgt[2] lun[0]
[  447.696070] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  447.696087] ESP: start data addr[c03ee720] len[96] write(1)
[  447.796164] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  447.796182] ESP: data done flgs[5] sent[32]
[  447.796202] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  447.796223] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  447.796231] ESP: Command done status[0] message[0]
[  447.796319] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  448.797064] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  448.797396] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  448.797431] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  448.797453] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  448.797461] ESP: Command done status[2] message[0]
[  448.797472] esp0: Doing auto-sense for tgt[2] lun[0]
[  448.797788] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  448.797805] ESP: start data addr[c03f0720] len[96] write(1)
[  448.797921] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  448.797939] ESP: data done flgs[5] sent[32]
[  448.797958] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  448.797979] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  448.797987] ESP: Command done status[0] message[0]
[  448.798054] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  448.798189] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  448.798362] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  448.798388] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  448.798408] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  448.798417] ESP: Command done status[2] message[0]
[  448.798428] esp0: Doing auto-sense for tgt[2] lun[0]
[  448.865109] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  448.865125] ESP: start data addr[c03f2720] len[96] write(1)
[  448.865241] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  448.865259] ESP: data done flgs[5] sent[32]
[  448.865280] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  448.865300] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  448.865308] ESP: Command done status[0] message[0]
[  448.865374] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  448.865511] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  448.865685] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  448.865710] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  448.865730] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  448.865739] ESP: Command done status[2] message[0]
[  448.865750] esp0: Doing auto-sense for tgt[2] lun[0]
[  448.866063] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  448.866079] ESP: start data addr[c03f4720] len[96] write(1)
[  448.966186] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  448.966204] ESP: data done flgs[5] sent[32]
[  448.966224] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  448.966243] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  448.966253] ESP: Command done status[0] message[0]
[  448.966332] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  449.967058] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  450.014296] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  450.014323] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  450.014344] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  450.014354] ESP: Command done status[2] message[0]
[  450.014364] esp0: Doing auto-sense for tgt[2] lun[0]
[  450.014681] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  450.014698] ESP: start data addr[c03f6720] len[96] write(1)
[  450.014815] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  450.014833] ESP: data done flgs[5] sent[32]
[  450.014853] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  450.014873] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  450.014882] ESP: Command done status[0] message[0]
[  450.014948] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  450.015087] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  450.015261] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  450.015286] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  450.015307] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  450.015315] ESP: Command done status[2] message[0]
[  450.015326] esp0: Doing auto-sense for tgt[2] lun[0]
[  450.081996] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  450.082012] ESP: start data addr[c03f8720] len[96] write(1)
[  450.082129] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  450.082146] ESP: data done flgs[5] sent[32]
[  450.082167] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  450.082187] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  450.082195] ESP: Command done status[0] message[0]
[  450.082261] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  450.082398] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  450.082571] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  450.082596] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  450.082616] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  450.082625] ESP: Command done status[2] message[0]
[  450.082636] esp0: Doing auto-sense for tgt[2] lun[0]
[  450.082950] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  450.082966] ESP: start data addr[c03fa720] len[96] write(1)
[  450.196596] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  450.196614] ESP: data done flgs[5] sent[32]
[  450.196634] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  450.196654] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  450.196663] ESP: Command done status[0] message[0]
[  450.196751] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  451.197051] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  451.224917] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  451.224945] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  451.224973] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  451.224982] ESP: Command done status[2] message[0]
[  451.224993] esp0: Doing auto-sense for tgt[2] lun[0]
[  451.225303] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  451.225320] ESP: start data addr[c03fc720] len[96] write(1)
[  451.225436] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  451.225454] ESP: data done flgs[5] sent[32]
[  451.225474] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  451.225494] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  451.225503] ESP: Command done status[0] message[0]
[  451.225570] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  451.225709] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  451.225882] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  451.225910] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  451.225930] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  451.225938] ESP: Command done status[2] message[0]
[  451.225949] esp0: Doing auto-sense for tgt[2] lun[0]
[  451.333266] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  451.333282] ESP: start data addr[c03fe720] len[96] write(1)
[  451.333399] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  451.333417] ESP: data done flgs[5] sent[32]
[  451.333437] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  451.333456] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  451.333464] ESP: Command done status[0] message[0]
[  451.333530] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  451.333669] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  451.333842] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  451.333868] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  451.333888] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  451.333896] ESP: Command done status[2] message[0]
[  451.333907] esp0: Doing auto-sense for tgt[2] lun[0]
[  451.334220] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  451.334236] ESP: start data addr[c0400720] len[96] write(1)
[  451.434320] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  451.434338] ESP: data done flgs[5] sent[32]
[  451.434358] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  451.434379] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  451.434405] ESP: Command done status[0] message[0]
[  451.434473] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  452.437048] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  452.460552] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  452.460579] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  452.460606] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  452.460615] ESP: Command done status[2] message[0]
[  452.460626] esp0: Doing auto-sense for tgt[2] lun[0]
[  452.460937] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  452.460954] ESP: start data addr[c0402720] len[96] write(1)
[  452.461070] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  452.461088] ESP: data done flgs[5] sent[32]
[  452.461108] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  452.461128] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  452.461137] ESP: Command done status[0] message[0]
[  452.461204] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  452.461342] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  452.461515] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  452.461542] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  452.461562] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  452.461571] ESP: Command done status[2] message[0]
[  452.461582] esp0: Doing auto-sense for tgt[2] lun[0]
[  452.528271] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  452.528287] ESP: start data addr[c0404720] len[96] write(1)
[  452.528404] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  452.528422] ESP: data done flgs[5] sent[32]
[  452.528442] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  452.528461] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  452.528470] ESP: Command done status[0] message[0]
[  452.528536] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  452.528675] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  452.528847] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  452.528872] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  452.528893] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  452.528901] ESP: Command done status[2] message[0]
[  452.528912] esp0: Doing auto-sense for tgt[2] lun[0]
[  452.529225] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  452.529241] ESP: start data addr[c0406720] len[96] write(1)
[  452.629330] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  452.629348] ESP: data done flgs[5] sent[32]
[  452.629368] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  452.629388] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  452.629415] ESP: Command done status[0] message[0]
[  452.629481] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  453.637041] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  453.638891] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  453.638927] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  453.638948] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  453.638957] ESP: Command done status[2] message[0]
[  453.638968] esp0: Doing auto-sense for tgt[2] lun[0]
[  453.639292] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  453.639309] ESP: start data addr[c0408720] len[96] write(1)
[  453.639425] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  453.639443] ESP: data done flgs[5] sent[32]
[  453.639463] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  453.639483] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  453.639491] ESP: Command done status[0] message[0]
[  453.639557] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  453.639692] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  453.639866] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  453.639891] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  453.639911] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  453.639920] ESP: Command done status[2] message[0]
[  453.639930] esp0: Doing auto-sense for tgt[2] lun[0]
[  453.706609] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  453.706625] ESP: start data addr[c040a720] len[96] write(1)
[  453.706745] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  453.706764] ESP: data done flgs[5] sent[32]
[  453.706784] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  453.706804] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  453.706813] ESP: Command done status[0] message[0]
[  453.706879] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  453.707024] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  453.707199] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  453.707226] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  453.707246] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  453.707255] ESP: Command done status[2] message[0]
[  453.707266] esp0: Doing auto-sense for tgt[2] lun[0]
[  453.707579] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  453.707596] ESP: start data addr[c040c720] len[96] write(1)
[  453.807664] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  453.807682] ESP: data done flgs[5] sent[32]
[  453.807702] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  453.807722] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  453.807749] ESP: Command done status[0] message[0]
[  453.807816] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  454.817017] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  454.817227] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  454.817254] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  454.817275] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  454.817298] ESP: Command done status[2] message[0]
[  454.817310] esp0: Doing auto-sense for tgt[2] lun[0]
[  454.817611] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  454.817628] ESP: start data addr[c040e720] len[96] write(1)
[  454.817743] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  454.817761] ESP: data done flgs[5] sent[32]
[  454.817781] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  454.817801] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  454.817810] ESP: Command done status[0] message[0]
[  454.817876] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  454.818011] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  454.818192] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  454.818218] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  454.818239] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  454.818247] ESP: Command done status[2] message[0]
[  454.818258] esp0: Doing auto-sense for tgt[2] lun[0]
[  454.884948] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  454.884964] ESP: start data addr[c0410720] len[96] write(1)
[  454.885081] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  454.885099] ESP: data done flgs[5] sent[32]
[  454.885119] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  454.885139] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  454.885148] ESP: Command done status[0] message[0]
[  454.885214] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  454.885349] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  454.885523] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  454.885548] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  454.885568] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  454.885577] ESP: Command done status[2] message[0]
[  454.885588] esp0: Doing auto-sense for tgt[2] lun[0]
[  454.885901] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  454.885917] ESP: start data addr[c0412720] len[96] write(1)
[  454.986018] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  454.986036] ESP: data done flgs[5] sent[32]
[  454.986056] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  454.986087] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  454.986096] ESP: Command done status[0] message[0]
[  454.986161] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  455.987009] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  456.037247] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  456.037274] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  456.037296] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  456.037319] ESP: Command done status[2] message[0]
[  456.037330] esp0: Doing auto-sense for tgt[2] lun[0]
[  456.037631] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  456.037649] ESP: start data addr[c0414720] len[96] write(1)
[  456.037764] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  456.037782] ESP: data done flgs[5] sent[32]
[  456.037802] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  456.037823] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  456.037832] ESP: Command done status[0] message[0]
[  456.037899] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  456.038036] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  456.038208] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  456.038235] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  456.038255] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  456.038264] ESP: Command done status[2] message[0]
[  456.038274] esp0: Doing auto-sense for tgt[2] lun[0]
[  456.104955] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  456.104971] ESP: start data addr[c0416720] len[96] write(1)
[  456.105088] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  456.105106] ESP: data done flgs[5] sent[32]
[  456.105126] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  456.105145] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  456.105154] ESP: Command done status[0] message[0]
[  456.105219] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  456.105354] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  456.105527] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  456.105552] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  456.105573] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  456.105581] ESP: Command done status[2] message[0]
[  456.105592] esp0: Doing auto-sense for tgt[2] lun[0]
[  456.105905] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  456.105921] ESP: start data addr[c0418720] len[96] write(1)
[  456.206033] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  456.206052] ESP: data done flgs[5] sent[32]
[  456.206072] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  456.206110] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  456.206119] ESP: Command done status[0] message[0]
[  456.206186] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  457.207005] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  457.257257] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  457.257284] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  457.257306] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  457.257330] ESP: Command done status[2] message[0]
[  457.257341] esp0: Doing auto-sense for tgt[2] lun[0]
[  457.257642] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  457.257659] ESP: start data addr[c041a720] len[96] write(1)
[  457.257774] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  457.257792] ESP: data done flgs[5] sent[32]
[  457.257811] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  457.257832] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  457.257841] ESP: Command done status[0] message[0]
[  457.257908] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  457.258047] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  457.258220] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  457.258246] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  457.258266] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  457.258274] ESP: Command done status[2] message[0]
[  457.258285] esp0: Doing auto-sense for tgt[2] lun[0]
[  457.324973] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  457.324989] ESP: start data addr[c041c720] len[96] write(1)
[  457.325105] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  457.325123] ESP: data done flgs[5] sent[32]
[  457.325144] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  457.325164] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  457.325172] ESP: Command done status[0] message[0]
[  457.325239] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  457.325376] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  457.325549] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  457.325575] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  457.325595] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  457.325604] ESP: Command done status[2] message[0]
[  457.325615] esp0: Doing auto-sense for tgt[2] lun[0]
[  457.325929] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  457.325944] ESP: start data addr[c041e720] len[96] write(1)
[  457.426026] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  457.426044] ESP: data done flgs[5] sent[32]
[  457.426064] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  457.426084] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  457.426111] ESP: Command done status[0] message[0]
[  457.426177] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  458.427002] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  458.437680] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  458.437706] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  458.437729] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  458.437752] ESP: Command done status[2] message[0]
[  458.437764] esp0: Doing auto-sense for tgt[2] lun[0]
[  458.438071] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  458.438088] ESP: start data addr[c0420720] len[96] write(1)
[  458.438204] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  458.438221] ESP: data done flgs[5] sent[32]
[  458.438241] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  458.438262] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  458.438271] ESP: Command done status[0] message[0]
[  458.438337] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  458.438475] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  458.438649] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  458.438674] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  458.438694] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  458.438702] ESP: Command done status[2] message[0]
[  458.438713] esp0: Doing auto-sense for tgt[2] lun[0]
[  458.505391] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  458.505407] ESP: start data addr[c0422720] len[96] write(1)
[  458.505524] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  458.505542] ESP: data done flgs[5] sent[32]
[  458.505562] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  458.505581] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  458.505590] ESP: Command done status[0] message[0]
[  458.505655] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  458.505793] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  458.505966] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  458.505991] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  458.506011] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  458.506020] ESP: Command done status[2] message[0]
[  458.506031] esp0: Doing auto-sense for tgt[2] lun[0]
[  458.506344] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  458.506359] ESP: start data addr[c0424720] len[96] write(1)
[  458.606450] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  458.606468] ESP: data done flgs[5] sent[32]
[  458.606488] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  458.606508] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  458.606536] ESP: Command done status[0] message[0]
[  458.606603] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  459.606996] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  459.618095] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  459.618122] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  459.618148] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  459.618158] ESP: Command done status[2] message[0]
[  459.618169] esp0: Doing auto-sense for tgt[2] lun[0]
[  459.618480] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  459.618497] ESP: start data addr[c0426720] len[96] write(1)
[  459.618613] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  459.618631] ESP: data done flgs[5] sent[32]
[  459.618651] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  459.618671] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  459.618680] ESP: Command done status[0] message[0]
[  459.618746] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  459.618883] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  459.619055] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  459.619081] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  459.619101] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  459.619109] ESP: Command done status[2] message[0]
[  459.619120] esp0: Doing auto-sense for tgt[2] lun[0]
[  459.685811] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  459.685827] ESP: start data addr[c0428720] len[96] write(1)
[  459.685947] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  459.685966] ESP: data done flgs[5] sent[32]
[  459.685986] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  459.686007] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  459.686016] ESP: Command done status[0] message[0]
[  459.686082] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  459.686217] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  459.686390] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  459.686415] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  459.686436] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  459.686444] ESP: Command done status[2] message[0]
[  459.686455] esp0: Doing auto-sense for tgt[2] lun[0]
[  459.686768] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  459.686784] ESP: start data addr[c042a720] len[96] write(1)
[  459.786874] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  459.786892] ESP: data done flgs[5] sent[32]
[  459.786912] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  459.786932] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  459.786959] ESP: Command done status[0] message[0]
[  459.787025] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  460.796972] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  460.798522] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  460.798559] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  460.798581] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  460.798589] ESP: Command done status[2] message[0]
[  460.798600] esp0: Doing auto-sense for tgt[2] lun[0]
[  460.798917] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  460.798934] ESP: start data addr[c042c720] len[96] write(1)
[  460.799049] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  460.799067] ESP: data done flgs[5] sent[32]
[  460.799088] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  460.799108] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  460.799117] ESP: Command done status[0] message[0]
[  460.799182] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  460.799317] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  460.799490] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  460.799516] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  460.799536] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  460.799545] ESP: Command done status[2] message[0]
[  460.799556] esp0: Doing auto-sense for tgt[2] lun[0]
[  460.866235] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  460.866252] ESP: start data addr[c042e720] len[96] write(1)
[  460.866368] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  460.866386] ESP: data done flgs[5] sent[32]
[  460.866406] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  460.866425] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  460.866434] ESP: Command done status[0] message[0]
[  460.866499] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  460.866634] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  460.866808] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  460.866834] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  460.866855] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  460.866863] ESP: Command done status[2] message[0]
[  460.866874] esp0: Doing auto-sense for tgt[2] lun[0]
[  460.867191] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  460.867208] ESP: start data addr[c0430720] len[96] write(1)
[  460.967303] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  460.967321] ESP: data done flgs[5] sent[32]
[  460.967342] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  460.967374] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  460.967384] ESP: Command done status[0] message[0]
[  460.967450] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  461.976965] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  462.018545] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  462.018579] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  462.018600] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  462.018609] ESP: Command done status[2] message[0]
[  462.018620] esp0: Doing auto-sense for tgt[2] lun[0]
[  462.018936] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  462.018953] ESP: start data addr[c0432720] len[96] write(1)
[  462.019069] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  462.019086] ESP: data done flgs[5] sent[32]
[  462.019106] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  462.019126] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  462.019135] ESP: Command done status[0] message[0]
[  462.019200] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  462.019340] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  462.019513] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  462.019538] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  462.019558] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  462.019567] ESP: Command done status[2] message[0]
[  462.019578] esp0: Doing auto-sense for tgt[2] lun[0]
[  462.086247] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  462.086264] ESP: start data addr[c0434720] len[96] write(1)
[  462.086380] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  462.086398] ESP: data done flgs[5] sent[32]
[  462.086417] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  462.086437] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  462.086445] ESP: Command done status[0] message[0]
[  462.086511] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  462.086649] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  462.086835] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  462.086861] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  462.086882] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  462.086890] ESP: Command done status[2] message[0]
[  462.086901] esp0: Doing auto-sense for tgt[2] lun[0]
[  462.087218] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  462.087235] ESP: start data addr[c0436720] len[96] write(1)
[  462.187304] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  462.187322] ESP: data done flgs[5] sent[32]
[  462.187343] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  462.187364] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  462.187391] ESP: Command done status[0] message[0]
[  462.187457] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  463.196959] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  463.198953] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  463.198990] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  463.199011] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  463.199020] ESP: Command done status[2] message[0]
[  463.199030] esp0: Doing auto-sense for tgt[2] lun[0]
[  463.199347] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  463.199364] ESP: start data addr[c0438720] len[96] write(1)
[  463.199479] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  463.199497] ESP: data done flgs[5] sent[32]
[  463.199517] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  463.199537] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  463.199546] ESP: Command done status[0] message[0]
[  463.199614] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  463.199750] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  463.199924] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  463.199949] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  463.199969] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  463.199978] ESP: Command done status[2] message[0]
[  463.199989] esp0: Doing auto-sense for tgt[2] lun[0]
[  463.266665] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  463.266681] ESP: start data addr[c043a720] len[96] write(1)
[  463.266798] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  463.266815] ESP: data done flgs[5] sent[32]
[  463.266836] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  463.266855] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  463.266864] ESP: Command done status[0] message[0]
[  463.266930] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  463.267073] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  463.267249] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  463.267276] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  463.267297] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  463.267305] ESP: Command done status[2] message[0]
[  463.267316] esp0: Doing auto-sense for tgt[2] lun[0]
[  463.267630] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  463.267646] ESP: start data addr[c043c720] len[96] write(1)
[  463.367725] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  463.367744] ESP: data done flgs[5] sent[32]
[  463.367764] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  463.367784] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  463.367811] ESP: Command done status[0] message[0]
[  463.367878] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  464.376959] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  464.379372] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  464.379409] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  464.379430] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  464.379439] ESP: Command done status[2] message[0]
[  464.379450] esp0: Doing auto-sense for tgt[2] lun[0]
[  464.379766] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  464.379783] ESP: start data addr[c043e720] len[96] write(1)
[  464.379899] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  464.379917] ESP: data done flgs[5] sent[32]
[  464.379937] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  464.379957] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  464.379966] ESP: Command done status[0] message[0]
[  464.380033] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  464.380167] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  464.380341] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  464.380368] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  464.380388] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  464.380397] ESP: Command done status[2] message[0]
[  464.380408] esp0: Doing auto-sense for tgt[2] lun[0]
[  464.447086] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  464.447102] ESP: start data addr[c0440720] len[96] write(1)
[  464.447219] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  464.447237] ESP: data done flgs[5] sent[32]
[  464.447257] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  464.447276] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  464.447285] ESP: Command done status[0] message[0]
[  464.447351] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  464.447486] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  464.447659] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  464.447684] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  464.447704] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  464.447713] ESP: Command done status[2] message[0]
[  464.447723] esp0: Doing auto-sense for tgt[2] lun[0]
[  464.448036] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  464.448052] ESP: start data addr[c0442720] len[96] write(1)
[  464.548147] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  464.548165] ESP: data done flgs[5] sent[32]
[  464.548185] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  464.548206] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  464.548233] ESP: Command done status[0] message[0]
[  464.548299] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  465.556950] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  465.559797] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  465.559825] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  465.559859] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  465.559869] ESP: Command done status[2] message[0]
[  465.559881] esp0: Doing auto-sense for tgt[2] lun[0]
[  465.560183] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  465.560200] ESP: start data addr[c0444720] len[96] write(1)
[  465.560316] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  465.560334] ESP: data done flgs[5] sent[32]
[  465.560355] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  465.560375] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  465.560384] ESP: Command done status[0] message[0]
[  465.560450] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  465.560586] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  465.560759] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  465.560786] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  465.560806] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  465.560815] ESP: Command done status[2] message[0]
[  465.560826] esp0: Doing auto-sense for tgt[2] lun[0]
[  465.627509] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  465.627525] ESP: start data addr[c0446720] len[96] write(1)
[  465.627641] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  465.627659] ESP: data done flgs[5] sent[32]
[  465.627679] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  465.627699] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  465.627708] ESP: Command done status[0] message[0]
[  465.627773] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  465.627910] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  465.628082] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  465.628108] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  465.628128] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  465.628136] ESP: Command done status[2] message[0]
[  465.628147] esp0: Doing auto-sense for tgt[2] lun[0]
[  465.628460] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  465.628476] ESP: start data addr[c0448720] len[96] write(1)
[  465.728567] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  465.728585] ESP: data done flgs[5] sent[32]
[  465.728605] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  465.728624] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  465.728650] ESP: Command done status[0] message[0]
[  465.728716] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  466.736922] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  466.740218] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  466.740246] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  466.740267] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  466.740290] ESP: Command done status[2] message[0]
[  466.740302] esp0: Doing auto-sense for tgt[2] lun[0]
[  466.740604] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  466.740621] ESP: start data addr[c044a720] len[96] write(1)
[  466.740737] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  466.740755] ESP: data done flgs[5] sent[32]
[  466.740774] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  466.740795] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  466.740804] ESP: Command done status[0] message[0]
[  466.740870] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  466.741004] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  466.741176] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  466.741201] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  466.741221] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  466.741230] ESP: Command done status[2] message[0]
[  466.741240] esp0: Doing auto-sense for tgt[2] lun[0]
[  466.807927] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  466.807943] ESP: start data addr[c044c720] len[96] write(1)
[  466.808060] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  466.808078] ESP: data done flgs[5] sent[32]
[  466.808097] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  466.808117] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  466.808125] ESP: Command done status[0] message[0]
[  466.808189] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  466.808326] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  466.808499] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  466.808524] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  466.808544] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  466.808553] ESP: Command done status[2] message[0]
[  466.808564] esp0: Doing auto-sense for tgt[2] lun[0]
[  466.808878] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  466.808893] ESP: start data addr[c044e720] len[96] write(1)
[  466.908991] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  466.909009] ESP: data done flgs[5] sent[32]
[  466.909029] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  466.909050] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  466.909077] ESP: Command done status[0] message[0]
[  466.909144] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  467.916921] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  467.920635] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  467.920662] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  467.920683] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  467.920706] ESP: Command done status[2] message[0]
[  467.920717] esp0: Doing auto-sense for tgt[2] lun[0]
[  467.921019] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  467.921037] ESP: start data addr[c0450720] len[96] write(1)
[  467.921152] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  467.921170] ESP: data done flgs[5] sent[32]
[  467.921190] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  467.921210] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  467.921219] ESP: Command done status[0] message[0]
[  467.921285] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  467.921418] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  467.921591] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  467.921617] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  467.921637] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  467.921645] ESP: Command done status[2] message[0]
[  467.921656] esp0: Doing auto-sense for tgt[2] lun[0]
[  467.988362] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  467.988379] ESP: start data addr[c0452720] len[96] write(1)
[  467.988495] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  467.988513] ESP: data done flgs[5] sent[32]
[  467.988533] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  467.988553] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  467.988562] ESP: Command done status[0] message[0]
[  467.988628] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  467.988762] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  467.988935] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  467.988960] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  467.988980] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  467.988988] ESP: Command done status[2] message[0]
[  467.988999] esp0: Doing auto-sense for tgt[2] lun[0]
[  467.989312] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  467.989328] ESP: start data addr[c0454720] len[96] write(1)
[  468.089410] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  468.089428] ESP: data done flgs[5] sent[32]
[  468.089448] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  468.089469] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  468.089496] ESP: Command done status[0] message[0]
[  468.089562] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  469.096910] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  469.101060] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  469.101087] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  469.101109] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  469.101132] ESP: Command done status[2] message[0]
[  469.101143] esp0: Doing auto-sense for tgt[2] lun[0]
[  469.101452] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  469.101469] ESP: start data addr[c0456720] len[96] write(1)
[  469.101584] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  469.101602] ESP: data done flgs[5] sent[32]
[  469.101623] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  469.101643] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  469.101652] ESP: Command done status[0] message[0]
[  469.101720] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  469.101855] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  469.102027] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  469.102053] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  469.102073] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  469.102081] ESP: Command done status[2] message[0]
[  469.102092] esp0: Doing auto-sense for tgt[2] lun[0]
[  469.168774] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  469.168790] ESP: start data addr[c0458720] len[96] write(1)
[  469.168905] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  469.168923] ESP: data done flgs[5] sent[32]
[  469.168943] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  469.168963] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  469.168972] ESP: Command done status[0] message[0]
[  469.169037] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  469.169174] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  469.169346] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  469.169372] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  469.169392] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  469.169400] ESP: Command done status[2] message[0]
[  469.169411] esp0: Doing auto-sense for tgt[2] lun[0]
[  469.169726] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  469.169741] ESP: start data addr[c045a720] len[96] write(1)
[  469.269832] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  469.269850] ESP: data done flgs[5] sent[32]
[  469.269870] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  469.269891] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  469.269918] ESP: Command done status[0] message[0]
[  469.269984] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  470.276907] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  470.281478] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  470.281505] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  470.281542] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  470.281551] ESP: Command done status[2] message[0]
[  470.281562] esp0: Doing auto-sense for tgt[2] lun[0]
[  470.281862] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  470.281879] ESP: start data addr[c045c720] len[96] write(1)
[  470.281994] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  470.282012] ESP: data done flgs[5] sent[32]
[  470.282032] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  470.282052] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  470.282061] ESP: Command done status[0] message[0]
[  470.282127] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  470.282261] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  470.282434] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  470.282460] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  470.282480] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  470.282489] ESP: Command done status[2] message[0]
[  470.282499] esp0: Doing auto-sense for tgt[2] lun[0]
[  470.349192] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  470.349208] ESP: start data addr[c045e720] len[96] write(1)
[  470.349325] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  470.349343] ESP: data done flgs[5] sent[32]
[  470.349363] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  470.349383] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  470.349392] ESP: Command done status[0] message[0]
[  470.349457] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  470.349594] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  470.349767] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  470.349793] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  470.349813] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  470.349821] ESP: Command done status[2] message[0]
[  470.349832] esp0: Doing auto-sense for tgt[2] lun[0]
[  470.350145] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  470.350161] ESP: start data addr[c0460720] len[96] write(1)
[  470.450249] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  470.450267] ESP: data done flgs[5] sent[32]
[  470.450287] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  470.450307] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  470.450334] ESP: Command done status[0] message[0]
[  470.450400] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  471.456901] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  471.461903] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  471.461930] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  471.461967] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  471.461976] ESP: Command done status[2] message[0]
[  471.461987] esp0: Doing auto-sense for tgt[2] lun[0]
[  471.462288] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  471.462305] ESP: start data addr[c0462720] len[96] write(1)
[  471.462420] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  471.462438] ESP: data done flgs[5] sent[32]
[  471.462458] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  471.462478] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  471.462487] ESP: Command done status[0] message[0]
[  471.462553] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  471.462688] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  471.462861] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  471.462887] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  471.462907] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  471.462916] ESP: Command done status[2] message[0]
[  471.462926] esp0: Doing auto-sense for tgt[2] lun[0]
[  471.529617] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  471.529633] ESP: start data addr[c0464720] len[96] write(1)
[  471.529750] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  471.529767] ESP: data done flgs[5] sent[32]
[  471.529787] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  471.529807] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  471.529816] ESP: Command done status[0] message[0]
[  471.529882] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  471.530019] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  471.530191] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  471.530216] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  471.530236] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  471.530245] ESP: Command done status[2] message[0]
[  471.530255] esp0: Doing auto-sense for tgt[2] lun[0]
[  471.530568] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  471.530584] ESP: start data addr[c0466720] len[96] write(1)
[  471.630672] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  471.630689] ESP: data done flgs[5] sent[32]
[  471.630709] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  471.630730] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  471.630757] ESP: Command done status[0] message[0]
[  471.630823] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  472.636892] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  472.642328] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  472.642354] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  472.642376] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  472.642399] ESP: Command done status[2] message[0]
[  472.642410] esp0: Doing auto-sense for tgt[2] lun[0]
[  472.642712] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  472.642729] ESP: start data addr[c0468720] len[96] write(1)
[  472.642844] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  472.642862] ESP: data done flgs[5] sent[32]
[  472.642882] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  472.642902] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  472.642911] ESP: Command done status[0] message[0]
[  472.642977] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  472.643112] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  472.643284] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  472.643310] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  472.643330] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  472.643338] ESP: Command done status[2] message[0]
[  472.643349] esp0: Doing auto-sense for tgt[2] lun[0]
[  472.710039] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  472.710055] ESP: start data addr[c046a720] len[96] write(1)
[  472.710174] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  472.710193] ESP: data done flgs[5] sent[32]
[  472.710214] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  472.710234] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  472.710244] ESP: Command done status[0] message[0]
[  472.710310] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  472.710449] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  472.710621] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  472.710647] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  472.710667] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  472.710676] ESP: Command done status[2] message[0]
[  472.710687] esp0: Doing auto-sense for tgt[2] lun[0]
[  472.711000] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  472.711017] ESP: start data addr[c046c720] len[96] write(1)
[  472.811098] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  472.811116] ESP: data done flgs[5] sent[32]
[  472.811136] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  472.811157] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  472.811184] ESP: Command done status[0] message[0]
[  472.811250] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  473.816868] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  473.822741] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  473.822767] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  473.822789] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  473.822812] ESP: Command done status[2] message[0]
[  473.822823] esp0: Doing auto-sense for tgt[2] lun[0]
[  473.823132] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  473.823149] ESP: start data addr[c046e720] len[96] write(1)
[  473.823264] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  473.823283] ESP: data done flgs[5] sent[32]
[  473.823303] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  473.823323] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  473.823332] ESP: Command done status[0] message[0]
[  473.823398] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  473.823534] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  473.823707] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  473.823731] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  473.823751] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  473.823760] ESP: Command done status[2] message[0]
[  473.823771] esp0: Doing auto-sense for tgt[2] lun[0]
[  473.890456] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  473.890472] ESP: start data addr[c0470720] len[96] write(1)
[  473.890588] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  473.890606] ESP: data done flgs[5] sent[32]
[  473.890626] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  473.890646] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  473.890654] ESP: Command done status[0] message[0]
[  473.890719] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  473.890856] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  473.891029] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  473.891054] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  473.891074] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  473.891083] ESP: Command done status[2] message[0]
[  473.891094] esp0: Doing auto-sense for tgt[2] lun[0]
[  473.891407] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  473.891422] ESP: start data addr[c0472720] len[96] write(1)
[  473.991531] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  473.991549] ESP: data done flgs[5] sent[32]
[  473.991569] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  473.991600] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  473.991609] ESP: Command done status[0] message[0]
[  473.991674] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  474.996862] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  475.042761] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  475.042787] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  475.042809] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  475.042833] ESP: Command done status[2] message[0]
[  475.042844] esp0: Doing auto-sense for tgt[2] lun[0]
[  475.043145] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  475.043162] ESP: start data addr[c0474720] len[96] write(1)
[  475.043279] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  475.043297] ESP: data done flgs[5] sent[32]
[  475.043317] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  475.043338] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  475.043347] ESP: Command done status[0] message[0]
[  475.043413] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  475.043552] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  475.043726] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  475.043752] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  475.043772] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  475.043781] ESP: Command done status[2] message[0]
[  475.043792] esp0: Doing auto-sense for tgt[2] lun[0]
[  475.110470] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  475.110487] ESP: start data addr[c0476720] len[96] write(1)
[  475.110604] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  475.110622] ESP: data done flgs[5] sent[32]
[  475.110642] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  475.110662] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  475.110671] ESP: Command done status[0] message[0]
[  475.110737] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  475.110875] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  475.111048] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  475.111073] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  475.111093] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  475.111102] ESP: Command done status[2] message[0]
[  475.111113] esp0: Doing auto-sense for tgt[2] lun[0]
[  475.111426] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  475.111442] ESP: start data addr[c0478720] len[96] write(1)
[  475.211527] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  475.211545] ESP: data done flgs[5] sent[32]
[  475.211565] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  475.211586] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  475.211613] ESP: Command done status[0] message[0]
[  475.211679] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  476.216856] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  476.281517] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  476.281545] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  476.281571] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  476.281581] ESP: Command done status[2] message[0]
[  476.281593] esp0: Doing auto-sense for tgt[2] lun[0]
[  476.281910] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  476.281927] ESP: start data addr[c047a720] len[96] write(1)
[  476.282043] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  476.282061] ESP: data done flgs[5] sent[32]
[  476.282082] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  476.282102] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  476.282111] ESP: Command done status[0] message[0]
[  476.282177] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  476.282317] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  476.282490] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  476.282517] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  476.282537] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  476.282546] ESP: Command done status[2] message[0]
[  476.282557] esp0: Doing auto-sense for tgt[2] lun[0]
[  476.349239] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  476.349255] ESP: start data addr[c047c720] len[96] write(1)
[  476.349371] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  476.349389] ESP: data done flgs[5] sent[32]
[  476.349409] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  476.349429] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  476.349437] ESP: Command done status[0] message[0]
[  476.349503] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  476.349640] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  476.349813] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  476.349838] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  476.349858] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  476.349867] ESP: Command done status[2] message[0]
[  476.349877] esp0: Doing auto-sense for tgt[2] lun[0]
[  476.350192] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  476.350207] ESP: start data addr[c047e720] len[96] write(1)
[  476.432581] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  476.432599] ESP: data done flgs[5] sent[32]
[  476.432636] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  476.432656] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  476.432664] ESP: Command done status[0] message[0]
[  476.432730] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  477.436851] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  477.441105] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  477.441132] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  477.441153] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  477.441162] ESP: Command done status[2] message[0]
[  477.441174] esp0: Doing auto-sense for tgt[2] lun[0]
[  477.441490] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  477.441507] ESP: start data addr[c0480720] len[96] write(1)
[  477.441623] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  477.441641] ESP: data done flgs[5] sent[32]
[  477.441661] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  477.441681] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  477.441691] ESP: Command done status[0] message[0]
[  477.441757] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  477.441890] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  477.442064] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  477.442090] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  477.442110] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  477.442119] ESP: Command done status[2] message[0]
[  477.442130] esp0: Doing auto-sense for tgt[2] lun[0]
[  477.510904] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  477.510920] ESP: start data addr[c0482720] len[96] write(1)
[  477.511037] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  477.511055] ESP: data done flgs[5] sent[32]
[  477.511075] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  477.511095] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  477.511104] ESP: Command done status[0] message[0]
[  477.511170] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  477.511305] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  477.511479] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  477.511504] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  477.511525] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  477.511533] ESP: Command done status[2] message[0]
[  477.511544] esp0: Doing auto-sense for tgt[2] lun[0]
[  477.511857] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  477.511872] ESP: start data addr[c0484720] len[96] write(1)
[  477.594251] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  477.594269] ESP: data done flgs[5] sent[32]
[  477.594307] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  477.594327] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  477.594336] ESP: Command done status[0] message[0]
[  477.594401] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  478.596848] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  478.602777] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  478.602803] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  478.602825] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  478.602847] ESP: Command done status[2] message[0]
[  478.602859] esp0: Doing auto-sense for tgt[2] lun[0]
[  478.603160] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  478.603178] ESP: start data addr[c0486720] len[96] write(1)
[  478.603294] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  478.603311] ESP: data done flgs[5] sent[32]
[  478.603332] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  478.603352] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  478.603361] ESP: Command done status[0] message[0]
[  478.603427] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  478.603560] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  478.603733] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  478.603759] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  478.603779] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  478.603788] ESP: Command done status[2] message[0]
[  478.603799] esp0: Doing auto-sense for tgt[2] lun[0]
[  478.672578] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  478.672594] ESP: start data addr[c0488720] len[96] write(1)
[  478.672714] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  478.672733] ESP: data done flgs[5] sent[32]
[  478.672753] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  478.672773] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  478.672782] ESP: Command done status[0] message[0]
[  478.672847] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  478.672985] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  478.673157] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  478.673182] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  478.673202] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  478.673211] ESP: Command done status[2] message[0]
[  478.673222] esp0: Doing auto-sense for tgt[2] lun[0]
[  478.673535] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  478.673552] ESP: start data addr[c048a720] len[96] write(1)
[  478.755917] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  478.755935] ESP: data done flgs[5] sent[32]
[  478.755955] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  478.755976] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  478.756005] ESP: Command done status[0] message[0]
[  478.756072] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  479.756822] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  479.805071] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  479.805098] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  479.805119] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  479.805129] ESP: Command done status[2] message[0]
[  479.805153] esp0: Doing auto-sense for tgt[2] lun[0]
[  479.805455] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  479.805472] ESP: start data addr[c048c720] len[96] write(1)
[  479.805590] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  479.805608] ESP: data done flgs[5] sent[32]
[  479.805628] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  479.805648] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  479.805656] ESP: Command done status[0] message[0]
[  479.805721] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  479.805858] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  479.806031] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  479.806057] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  479.806077] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  479.806086] ESP: Command done status[2] message[0]
[  479.806097] esp0: Doing auto-sense for tgt[2] lun[0]
[  479.874873] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  479.874889] ESP: start data addr[c048e720] len[96] write(1)
[  479.875006] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  479.875024] ESP: data done flgs[5] sent[32]
[  479.875044] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  479.875064] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  479.875073] ESP: Command done status[0] message[0]
[  479.875139] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  479.875273] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  479.875445] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  479.875471] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  479.875491] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  479.875499] ESP: Command done status[2] message[0]
[  479.875510] esp0: Doing auto-sense for tgt[2] lun[0]
[  479.875824] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  479.875839] ESP: start data addr[c0490720] len[96] write(1)
[  479.975941] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  479.975959] ESP: data done flgs[5] sent[32]
[  479.975979] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  479.975999] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  479.976007] ESP: Command done status[0] message[0]
[  479.976087] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  480.976818] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  480.987596] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  480.987630] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  480.987651] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  480.987661] ESP: Command done status[2] message[0]
[  480.987672] esp0: Doing auto-sense for tgt[2] lun[0]
[  480.987987] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  480.988004] ESP: start data addr[c0492720] len[96] write(1)
[  480.988120] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  480.988138] ESP: data done flgs[5] sent[32]
[  480.988159] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  480.988179] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  480.988188] ESP: Command done status[0] message[0]
[  480.988255] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  480.988394] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  480.988568] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  480.988593] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  480.988613] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  480.988622] ESP: Command done status[2] message[0]
[  480.988632] esp0: Doing auto-sense for tgt[2] lun[0]
[  481.055292] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  481.055308] ESP: start data addr[c0494720] len[96] write(1)
[  481.055425] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  481.055443] ESP: data done flgs[5] sent[32]
[  481.055464] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  481.055483] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  481.055492] ESP: Command done status[0] message[0]
[  481.055558] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  481.055696] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  481.055869] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  481.055896] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  481.055916] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  481.055925] ESP: Command done status[2] message[0]
[  481.055935] esp0: Doing auto-sense for tgt[2] lun[0]
[  481.056250] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  481.056265] ESP: start data addr[c0496720] len[96] write(1)
[  481.156352] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  481.156370] ESP: data done flgs[5] sent[32]
[  481.156391] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  481.156411] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  481.156438] ESP: Command done status[0] message[0]
[  481.156505] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  482.156816] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  482.168001] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  482.168028] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  482.168053] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  482.168063] ESP: Command done status[2] message[0]
[  482.168074] esp0: Doing auto-sense for tgt[2] lun[0]
[  482.168386] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  482.168403] ESP: start data addr[c0498720] len[96] write(1)
[  482.168519] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  482.168536] ESP: data done flgs[5] sent[32]
[  482.168556] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  482.168577] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  482.168585] ESP: Command done status[0] message[0]
[  482.168651] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  482.168788] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  482.168961] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  482.168987] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  482.169007] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  482.169016] ESP: Command done status[2] message[0]
[  482.169026] esp0: Doing auto-sense for tgt[2] lun[0]
[  482.235714] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  482.235730] ESP: start data addr[c049a720] len[96] write(1)
[  482.235846] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  482.235864] ESP: data done flgs[5] sent[32]
[  482.235884] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  482.235904] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  482.235912] ESP: Command done status[0] message[0]
[  482.235978] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  482.236117] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  482.236290] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  482.236315] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  482.236336] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  482.236344] ESP: Command done status[2] message[0]
[  482.236355] esp0: Doing auto-sense for tgt[2] lun[0]
[  482.236674] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  482.236689] ESP: start data addr[c049c720] len[96] write(1)
[  482.336766] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  482.336784] ESP: data done flgs[5] sent[32]
[  482.336805] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  482.336825] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  482.336851] ESP: Command done status[0] message[0]
[  482.336918] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  483.346806] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  483.348419] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  483.348458] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  483.348479] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  483.348489] ESP: Command done status[2] message[0]
[  483.348500] esp0: Doing auto-sense for tgt[2] lun[0]
[  483.348816] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  483.348833] ESP: start data addr[c049e720] len[96] write(1)
[  483.348950] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  483.348967] ESP: data done flgs[5] sent[32]
[  483.348988] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  483.349008] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  483.349017] ESP: Command done status[0] message[0]
[  483.349083] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  483.349217] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  483.349389] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  483.349417] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  483.349437] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  483.349445] ESP: Command done status[2] message[0]
[  483.349456] esp0: Doing auto-sense for tgt[2] lun[0]
[  483.416138] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  483.416154] ESP: start data addr[c04a0720] len[96] write(1)
[  483.416271] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  483.416289] ESP: data done flgs[5] sent[32]
[  483.416309] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  483.416329] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  483.416337] ESP: Command done status[0] message[0]
[  483.416404] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  483.416540] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  483.416722] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  483.416748] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  483.416769] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  483.416778] ESP: Command done status[2] message[0]
[  483.416789] esp0: Doing auto-sense for tgt[2] lun[0]
[  483.417102] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  483.417118] ESP: start data addr[c04a2720] len[96] write(1)
[  483.517191] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  483.517210] ESP: data done flgs[5] sent[32]
[  483.517230] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  483.517250] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  483.517277] ESP: Command done status[0] message[0]
[  483.517343] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  484.526802] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  484.528849] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  484.528882] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  484.528903] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  484.528912] ESP: Command done status[2] message[0]
[  484.528924] esp0: Doing auto-sense for tgt[2] lun[0]
[  484.529239] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  484.529256] ESP: start data addr[c04a4720] len[96] write(1)
[  484.529372] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  484.529389] ESP: data done flgs[5] sent[32]
[  484.529410] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  484.529431] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  484.529439] ESP: Command done status[0] message[0]
[  484.529507] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  484.529641] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  484.529814] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  484.529839] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  484.529860] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  484.529868] ESP: Command done status[2] message[0]
[  484.529879] esp0: Doing auto-sense for tgt[2] lun[0]
[  484.596558] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  484.596575] ESP: start data addr[c04a6720] len[96] write(1)
[  484.596698] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  484.596717] ESP: data done flgs[5] sent[32]
[  484.596738] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  484.596758] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  484.596767] ESP: Command done status[0] message[0]
[  484.596833] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  484.596974] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  484.597148] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  484.597173] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  484.597193] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  484.597202] ESP: Command done status[2] message[0]
[  484.597213] esp0: Doing auto-sense for tgt[2] lun[0]
[  484.597526] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  484.597542] ESP: start data addr[c04a8720] len[96] write(1)
[  484.697618] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  484.697636] ESP: data done flgs[5] sent[32]
[  484.697657] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  484.697677] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  484.697704] ESP: Command done status[0] message[0]
[  484.697771] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  485.706773] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  485.709269] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  485.709305] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  485.709327] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  485.709335] ESP: Command done status[2] message[0]
[  485.709346] esp0: Doing auto-sense for tgt[2] lun[0]
[  485.709662] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  485.709680] ESP: start data addr[c04aa720] len[96] write(1)
[  485.709797] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  485.709814] ESP: data done flgs[5] sent[32]
[  485.709834] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  485.709854] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  485.709863] ESP: Command done status[0] message[0]
[  485.709931] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  485.710064] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  485.710237] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  485.710262] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  485.710283] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  485.710291] ESP: Command done status[2] message[0]
[  485.710302] esp0: Doing auto-sense for tgt[2] lun[0]
[  485.776974] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  485.776990] ESP: start data addr[c04ac720] len[96] write(1)
[  485.777107] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  485.777125] ESP: data done flgs[5] sent[32]
[  485.777145] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  485.777165] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  485.777173] ESP: Command done status[0] message[0]
[  485.777239] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  485.777375] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  485.777548] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  485.777573] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  485.777593] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  485.777602] ESP: Command done status[2] message[0]
[  485.777613] esp0: Doing auto-sense for tgt[2] lun[0]
[  485.777926] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  485.777942] ESP: start data addr[c04ae720] len[96] write(1)
[  485.878036] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  485.878054] ESP: data done flgs[5] sent[32]
[  485.878074] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  485.878094] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  485.878121] ESP: Command done status[0] message[0]
[  485.878190] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  486.886773] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  486.889688] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  486.889715] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  486.889736] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  486.889759] ESP: Command done status[2] message[0]
[  486.889770] esp0: Doing auto-sense for tgt[2] lun[0]
[  486.890072] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  486.890089] ESP: start data addr[c04b0720] len[96] write(1)
[  486.890204] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  486.890222] ESP: data done flgs[5] sent[32]
[  486.890242] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  486.890262] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  486.890271] ESP: Command done status[0] message[0]
[  486.890337] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  486.890472] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  486.890644] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  486.890670] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  486.890690] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  486.890698] ESP: Command done status[2] message[0]
[  486.890709] esp0: Doing auto-sense for tgt[2] lun[0]
[  486.957411] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  486.957428] ESP: start data addr[c04b2720] len[96] write(1)
[  486.957545] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  486.957562] ESP: data done flgs[5] sent[32]
[  486.957582] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  486.957602] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  486.957610] ESP: Command done status[0] message[0]
[  486.957677] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  486.957813] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  486.957986] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  486.958012] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  486.958032] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  486.958041] ESP: Command done status[2] message[0]
[  486.958051] esp0: Doing auto-sense for tgt[2] lun[0]
[  486.958365] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  486.958381] ESP: start data addr[c04b4720] len[96] write(1)
[  487.058456] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  487.058474] ESP: data done flgs[5] sent[32]
[  487.058495] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  487.058515] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  487.058541] ESP: Command done status[0] message[0]
[  487.058609] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  488.066765] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  488.070115] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  488.070142] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  488.070175] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  488.070185] ESP: Command done status[2] message[0]
[  488.070196] esp0: Doing auto-sense for tgt[2] lun[0]
[  488.070506] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  488.070524] ESP: start data addr[c04b6720] len[96] write(1)
[  488.070639] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  488.070657] ESP: data done flgs[5] sent[32]
[  488.070677] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  488.070697] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  488.070705] ESP: Command done status[0] message[0]
[  488.070772] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  488.070905] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  488.071078] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  488.071103] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  488.071123] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  488.071132] ESP: Command done status[2] message[0]
[  488.071142] esp0: Doing auto-sense for tgt[2] lun[0]
[  488.137834] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  488.137851] ESP: start data addr[c04b8720] len[96] write(1)
[  488.137970] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  488.137990] ESP: data done flgs[5] sent[32]
[  488.138010] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  488.138031] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  488.138040] ESP: Command done status[0] message[0]
[  488.138107] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  488.138242] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  488.138415] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  488.138440] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  488.138460] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  488.138468] ESP: Command done status[2] message[0]
[  488.138479] esp0: Doing auto-sense for tgt[2] lun[0]
[  488.138793] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  488.138809] ESP: start data addr[c04ba720] len[96] write(1)
[  488.238883] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  488.238901] ESP: data done flgs[5] sent[32]
[  488.238921] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  488.238941] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  488.238967] ESP: Command done status[0] message[0]
[  488.239034] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  489.246758] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  489.250530] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  489.250556] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  489.250578] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  489.250601] ESP: Command done status[2] message[0]
[  489.250612] esp0: Doing auto-sense for tgt[2] lun[0]
[  489.250914] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  489.250931] ESP: start data addr[c04bc720] len[96] write(1)
[  489.251048] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  489.251065] ESP: data done flgs[5] sent[32]
[  489.251086] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  489.251106] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  489.251115] ESP: Command done status[0] message[0]
[  489.251180] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  489.251315] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  489.251488] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  489.251514] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  489.251534] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  489.251542] ESP: Command done status[2] message[0]
[  489.251553] esp0: Doing auto-sense for tgt[2] lun[0]
[  489.318241] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  489.318257] ESP: start data addr[c04be720] len[96] write(1)
[  489.318373] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  489.318392] ESP: data done flgs[5] sent[32]
[  489.318412] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  489.318431] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  489.318439] ESP: Command done status[0] message[0]
[  489.318506] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  489.318643] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  489.318817] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  489.318842] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  489.318863] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  489.318871] ESP: Command done status[2] message[0]
[  489.318882] esp0: Doing auto-sense for tgt[2] lun[0]
[  489.319195] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  489.319210] ESP: start data addr[c04c0720] len[96] write(1)
[  489.419303] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  489.419321] ESP: data done flgs[5] sent[32]
[  489.419342] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  489.419362] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  489.419388] ESP: Command done status[0] message[0]
[  489.419455] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  490.426750] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  490.430952] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  490.430979] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  490.431011] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  490.431020] ESP: Command done status[2] message[0]
[  490.431031] esp0: Doing auto-sense for tgt[2] lun[0]
[  490.431336] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  490.431353] ESP: start data addr[c04c2720] len[96] write(1)
[  490.431469] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  490.431487] ESP: data done flgs[5] sent[32]
[  490.431508] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  490.431528] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  490.431537] ESP: Command done status[0] message[0]
[  490.431604] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  490.431738] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  490.431911] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  490.431936] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  490.431956] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  490.431964] ESP: Command done status[2] message[0]
[  490.431975] esp0: Doing auto-sense for tgt[2] lun[0]
[  490.498662] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  490.498678] ESP: start data addr[c04c4720] len[96] write(1)
[  490.498795] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  490.498813] ESP: data done flgs[5] sent[32]
[  490.498834] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  490.498853] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  490.498862] ESP: Command done status[0] message[0]
[  490.498928] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  490.499064] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  490.499237] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  490.499263] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  490.499283] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  490.499291] ESP: Command done status[2] message[0]
[  490.499302] esp0: Doing auto-sense for tgt[2] lun[0]
[  490.499616] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  490.499631] ESP: start data addr[c04c6720] len[96] write(1)
[  490.599723] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  490.599741] ESP: data done flgs[5] sent[32]
[  490.599762] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  490.599782] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  490.599809] ESP: Command done status[0] message[0]
[  490.599876] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  491.606745] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  491.611374] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  491.611400] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  491.611433] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  491.611443] ESP: Command done status[2] message[0]
[  491.611454] esp0: Doing auto-sense for tgt[2] lun[0]
[  491.611756] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  491.611773] ESP: start data addr[c04c8720] len[96] write(1)
[  491.611888] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  491.611906] ESP: data done flgs[5] sent[32]
[  491.611926] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  491.611946] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  491.611955] ESP: Command done status[0] message[0]
[  491.612021] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  491.612156] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  491.612330] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  491.612355] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  491.612376] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  491.612385] ESP: Command done status[2] message[0]
[  491.612396] esp0: Doing auto-sense for tgt[2] lun[0]
[  491.679089] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  491.679106] ESP: start data addr[c04ca720] len[96] write(1)
[  491.679225] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  491.679244] ESP: data done flgs[5] sent[32]
[  491.679264] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  491.679284] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  491.679293] ESP: Command done status[0] message[0]
[  491.679360] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  491.679496] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  491.679668] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  491.679694] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  491.679714] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  491.679722] ESP: Command done status[2] message[0]
[  491.679733] esp0: Doing auto-sense for tgt[2] lun[0]
[  491.680046] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  491.680063] ESP: start data addr[c04cc720] len[96] write(1)
[  491.780146] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  491.780164] ESP: data done flgs[5] sent[32]
[  491.780184] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  491.780205] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  491.780232] ESP: Command done status[0] message[0]
[  491.780298] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  492.786719] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  492.791790] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  492.791817] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  492.791854] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  492.791863] ESP: Command done status[2] message[0]
[  492.791874] esp0: Doing auto-sense for tgt[2] lun[0]
[  492.792182] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  492.792199] ESP: start data addr[c04ce720] len[96] write(1)
[  492.792315] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  492.792333] ESP: data done flgs[5] sent[32]
[  492.792353] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  492.792373] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  492.792382] ESP: Command done status[0] message[0]
[  492.792450] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  492.792586] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  492.792759] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  492.792785] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  492.792805] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  492.792814] ESP: Command done status[2] message[0]
[  492.792824] esp0: Doing auto-sense for tgt[2] lun[0]
[  492.859505] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  492.859521] ESP: start data addr[c04d0720] len[96] write(1)
[  492.859638] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  492.859656] ESP: data done flgs[5] sent[32]
[  492.859676] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  492.859695] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  492.859704] ESP: Command done status[0] message[0]
[  492.859770] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  492.859907] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  492.860080] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  492.860105] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  492.860126] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  492.860134] ESP: Command done status[2] message[0]
[  492.860145] esp0: Doing auto-sense for tgt[2] lun[0]
[  492.860458] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  492.860474] ESP: start data addr[c04d2720] len[96] write(1)
[  492.960583] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  492.960601] ESP: data done flgs[5] sent[32]
[  492.960621] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  492.960651] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  492.960660] ESP: Command done status[0] message[0]
[  492.960727] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  493.966717] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  494.011816] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  494.011843] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  494.011876] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  494.011885] ESP: Command done status[2] message[0]
[  494.011896] esp0: Doing auto-sense for tgt[2] lun[0]
[  494.012200] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  494.012217] ESP: start data addr[c04d4720] len[96] write(1)
[  494.012333] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  494.012351] ESP: data done flgs[5] sent[32]
[  494.012371] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  494.012391] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  494.012400] ESP: Command done status[0] message[0]
[  494.012466] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  494.012605] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  494.012778] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  494.012805] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  494.012825] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  494.012833] ESP: Command done status[2] message[0]
[  494.012845] esp0: Doing auto-sense for tgt[2] lun[0]
[  494.079519] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  494.079536] ESP: start data addr[c04d6720] len[96] write(1)
[  494.079653] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  494.079671] ESP: data done flgs[5] sent[32]
[  494.079691] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  494.079710] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  494.079719] ESP: Command done status[0] message[0]
[  494.079785] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  494.079923] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  494.080095] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  494.080119] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  494.080139] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  494.080147] ESP: Command done status[2] message[0]
[  494.080158] esp0: Doing auto-sense for tgt[2] lun[0]
[  494.080472] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  494.080487] ESP: start data addr[c04d8720] len[96] write(1)
[  494.180578] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  494.180595] ESP: data done flgs[5] sent[32]
[  494.180616] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  494.180636] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  494.180663] ESP: Command done status[0] message[0]
[  494.180730] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  495.186709] .ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  495.192223] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  495.192251] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  495.192287] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  495.192296] ESP: Command done status[2] message[0]
[  495.192307] esp0: Doing auto-sense for tgt[2] lun[0]
[  495.192608] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  495.192625] ESP: start data addr[c04da720] len[96] write(1)
[  495.192741] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  495.192759] ESP: data done flgs[5] sent[32]
[  495.192779] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  495.192799] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  495.192808] ESP: Command done status[0] message[0]
[  495.192875] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  495.193009] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  495.193181] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  495.193207] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  495.193227] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  495.193235] ESP: Command done status[2] message[0]
[  495.193246] esp0: Doing auto-sense for tgt[2] lun[0]
[  495.259937] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  495.259953] ESP: start data addr[c04dc720] len[96] write(1)
[  495.260069] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  495.260086] ESP: data done flgs[5] sent[32]
[  495.260107] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  495.260126] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  495.260134] ESP: Command done status[0] message[0]
[  495.260199] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  495.260336] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  495.260509] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  495.260534] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  495.260554] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  495.260562] ESP: Command done status[2] message[0]
[  495.260573] esp0: Doing auto-sense for tgt[2] lun[0]
[  495.260887] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  495.260903] ESP: start data addr[c04de720] len[96] write(1)
[  495.360999] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  495.361017] ESP: data done flgs[5] sent[32]
[  495.361037] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  495.361058] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  495.361084] ESP: Command done status[0] message[0]
[  495.361152] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  496.366643] .not responding...
[  496.366750] ESP: tgt[2] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
[  496.372642] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  496.372670] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  496.372692] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  496.372715] ESP: Command done status[2] message[0]
[  496.372726] esp0: Doing auto-sense for tgt[2] lun[0]
[  496.373027] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  496.373044] ESP: start data addr[c04e2720] len[96] write(1)
[  496.373160] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  496.373178] ESP: data done flgs[5] sent[32]
[  496.373198] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  496.373218] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  496.373228] ESP: Command done status[0] message[0]
[  496.373298] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  496.373472] ESP: tgt[2] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
[  496.373646] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  496.373672] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  496.373692] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  496.373700] ESP: Command done status[2] message[0]
[  496.373711] esp0: Doing auto-sense for tgt[2] lun[0]
[  496.440359] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  496.440376] ESP: start data addr[c04e6720] len[96] write(1)
[  496.440493] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  496.440511] ESP: data done flgs[5] sent[32]
[  496.440531] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  496.440551] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  496.440560] ESP: Command done status[0] message[0]
[  496.440630] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  496.440801] ESP: tgt[2] lun[0] scsi_cmd [ 25 00 00 00 00 00 00 00 00 00 ]
[  496.440976] ESP: intr sreg[93] seqreg[04] sreg2[80] ireg[18]
[  496.441001] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  496.441022] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  496.441030] ESP: Command done status[2] message[0]
[  496.441041] esp0: Doing auto-sense for tgt[2] lun[0]
[  496.441354] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  496.441370] ESP: start data addr[c04ea720] len[96] write(1)
[  496.541420] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  496.541438] ESP: data done flgs[5] sent[32]
[  496.541459] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  496.541479] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  496.541506] ESP: Command done status[0] message[0]
[  496.541577] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  496.541678] sd 0:0:2:0: [sdc] READ CAPACITY failed
[  496.541696] sd 0:0:2:0: [sdc]  
[  496.541705] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  496.541721] sd 0:0:2:0: [sdc]  
[  496.541733] Sense Key : Not Ready [current] 
[  496.541747] sd 0:0:2:0: [sdc]  
[  496.541766] Add. Sense: Logical unit not ready, cause not reportable
[  496.541852] ESP: tgt[2] lun[0] scsi_cmd [ 1a 00 3f 00 04 00 ]
[  496.542029] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  496.542055] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  496.542076] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  496.542085] ESP: Command done status[2] message[0]
[  496.542096] esp0: Doing auto-sense for tgt[2] lun[0]
[  496.542409] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  496.542425] ESP: start data addr[c04ee720] len[96] write(1)
[  496.644565] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  496.644583] ESP: data done flgs[5] sent[32]
[  496.644604] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  496.644624] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  496.644632] ESP: Command done status[0] message[0]
[  496.644725] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  496.644886] ESP: tgt[2] lun[0] scsi_cmd [ 1a 00 00 00 04 00 ]
[  496.645059] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  496.645084] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  496.645104] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  496.645112] ESP: Command done status[2] message[0]
[  496.645123] esp0: Doing auto-sense for tgt[2] lun[0]
[  496.645437] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  496.645453] ESP: start data addr[c04f2720] len[96] write(1)
[  496.728957] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  496.728975] ESP: data done flgs[5] sent[32]
[  496.728996] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  496.729026] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  496.729034] ESP: Command done status[0] message[0]
[  496.729104] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  496.729277] ESP: tgt[2] lun[0] scsi_cmd [ 1a 00 3f 00 ff 00 ]
[  496.729453] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  496.729480] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  496.729501] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  496.729510] ESP: Command done status[2] message[0]
[  496.729520] esp0: Doing auto-sense for tgt[2] lun[0]
[  496.729833] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  496.729849] ESP: start data addr[c04f6720] len[96] write(1)
[  496.830018] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  496.830037] ESP: data done flgs[5] sent[32]
[  496.830057] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  496.830077] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  496.830104] ESP: Command done status[0] message[0]
[  496.830176] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  496.830344] ESP: tgt[2] lun[0] scsi_cmd [ 1a 00 08 00 04 00 ]
[  496.830517] ESP: intr sreg[93] seqreg[03] sreg2[80] ireg[18]
[  496.830543] ESP: intr sreg[97] seqreg[04] sreg2[80] ireg[08]
[  496.830563] ESP: intr sreg[90] seqreg[04] sreg2[80] ireg[20]
[  496.830571] ESP: Command done status[2] message[0]
[  496.830582] esp0: Doing auto-sense for tgt[2] lun[0]
[  496.830896] ESP: intr sreg[91] seqreg[04] sreg2[80] ireg[18]
[  496.830911] ESP: start data addr[c04fa720] len[96] write(1)
[  496.932117] ESP: intr sreg[83] seqreg[03] sreg2[80] ireg[10]
[  496.932135] ESP: data done flgs[5] sent[32]
[  496.932156] ESP: intr sreg[87] seqreg[03] sreg2[80] ireg[08]
[  496.932175] ESP: intr sreg[80] seqreg[03] sreg2[80] ireg[20]
[  496.932184] ESP: Command done status[0] message[0]
[  496.932275] esp0: tgt[2] lun[0] AUTO SENSE[ 70 00 02 00 00 00 00 18 00 00 00 00 04 00 00 00 00 00 ]
[  496.932428] ESP: tgt[2] lun[0] scsi_cmd [ 12 01 00 00 40 00 ]
[  496.932695] ESP: intr sreg[91] seqreg[03] sreg2[80] ireg[18]
[  496.932716] ESP: start data addr[c04fd200] len[64] write(1)
[  496.932752] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[10]
[  496.932770] ESP: data done flgs[1] sent[8]
[  496.932794] ESP: intr sreg[87] seqreg[04] sreg2[20] ireg[08]
[  496.932800] ESP: Got msgin byte 23
[  496.932834] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[10]
[  496.932857] ESP: intr sreg[87] seqreg[04] sreg2[20] ireg[08]
[  496.932862] ESP: Got msgin byte 1
[  496.932978] ESP: intr sreg[83] seqreg[04] sreg2[80] ireg[10]
[  496.932998] ESP: intr sreg[87] seqreg[04] sreg2[80] ireg[08]
[  496.933018] ESP: intr sreg[80] seqreg[04] sreg2[80] ireg[20]
[  496.933026] ESP: Command done status[0] message[0]
[  496.933130] sd 0:0:2:0: [sdc] Attached SCSI disk
[  527.957522] INFO: rcu_sched self-detected stall on CPU
[  527.957544] 	14: (3424 ticks this GP) idle=635/140000000000001/0 softirq=22/22 
[  527.957562] 	 (t=24013 jiffies g=-288 c=-289 q=18)
[  527.957569] Task dump for CPU 14:
[  527.957589] swapper/10      R  running task        0     1      0 0x200000201000008
[  527.957593] Call Trace:
[  527.957613]  [000000000049c208] rcu_check_callbacks+0x448/0x740
[  527.957634]  [000000000049ec2c] update_process_times+0x2c/0x60
[  527.957661]  [00000000004ac108] tick_sched_timer+0x28/0x60
[  527.957681]  [000000000049f380] __run_hrtimer.isra.33+0x40/0x100
[  527.957699]  [000000000049fa90] hrtimer_interrupt+0xd0/0x260
[  527.957725]  [000000000042fae0] timer_interrupt+0x80/0xe0
[  527.957744]  [00000000004209d4] tl0_irq14+0x14/0x20
[  527.957763]  [0000000000490f60] console_unlock+0x440/0x4a0
[  527.957780]  [0000000000491230] vprintk_emit+0x270/0x540
[  527.957806]  [0000000000654074] dev_vprintk_emit+0xf4/0x1a0
[  527.957825]  [0000000000654144] dev_printk_emit+0x24/0x40
[  527.957844]  [00000000006544f4] _dev_info+0x34/0x60
[  527.957870]  [00000000008bab38] rtc_hctosys+0xf4/0x114
[  527.957888]  [0000000000426c00] do_one_initcall+0x80/0x1c0
[  527.957907]  [00000000008a6ae8] kernel_init_freeable+0x138/0x1d0
[  527.957926]  [000000000078e144] kernel_init+0x4/0x100
[  634.787433] Unable to handle kernel paging request at virtual address fffff8027fd26000
[  634.880378] tsk->{mm,active_mm}->context = 0000000000000000
[  634.946971] tsk->{mm,active_mm}->pgd = fffff80000402000
[  635.009492]               \|/ ____ \|/
[  635.009492]               "@'/ .. \`@"
[  635.009492]               /_| \__/ |_\
[  635.009492]                  \__U_/
[  635.185678] swapper/10(1): Oops [#1]
[  635.228294] CPU: 10 PID: 1 Comm: swapper/10 Tainted: G             L 3.18.0-rc4-00052-g04689e7-dirty #25
[  635.341878] task: fffff800fe0d0000 ti: fffff800fe094000 task.ti: fffff800fe094000
[  635.431465] TSTATE: 0000004480001601 TPC: 00000000005f1cf8 TNPC: 00000000005f36dc Y: fc4dd851    Tainted: G             L
[  635.562806] TPC: <blk_mq_map_queue+0x18/0x20>
[  635.614803] g0: 4fa4fa4fa4fa4fa5 g1: 0000000181d18800 g2: fffff800fe00e860 g3: 0000000000000001
[  635.719019] g4: fffff800fe0d0000 g5: fffff800feb30000 g6: fffff800fe094000 g7: 0000000000000000
[  635.823234] o0: fffff800fe760000 o1: 0000000000000028 o2: fffff800fe760630 o3: fffff800fe0971f0
[  635.927395] o4: fffff800fe760618 o5: 0000000000000000 sp: fffff800fe096a01 ret_pc: 00000000005f36d4
[  636.035755] RPC: <blk_mq_map_request+0x54/0x140>
[  636.090958] l0: 00000000008d40c0 l1: 0000000000000000 l2: 0000060001fb00c0 l3: 0000000000010000
[  636.195166] l4: 0000000000020000 l5: 0000000000000000 l6: 0000000000000006 l7: 0000000000000000
[  636.299344] i0: fffff800fe760000 i1: fffff800fe272180 i2: fffff800fe097390 i3: fffff800fe0d0508
[  636.403550] i4: fffff800ff4082c0 i5: 0000000000000000 i6: fffff800fe096ad1 i7: 00000000005f4850
[  636.507720] I7: <blk_sq_make_request+0x50/0x200>
[  636.562885] Call Trace:
[  636.592071]  [00000000005f4850] blk_sq_make_request+0x50/0x200
[  636.661929]  [00000000005e96d0] generic_make_request+0x70/0xc0
[  636.731708]  [00000000005e979c] submit_bio+0x7c/0x160
[  636.792124]  [000000000053fc30] _submit_bh+0x150/0x1e0
[  636.853576]  [000000000053fd64] __bread_gfp+0x84/0x100
[  636.915054]  [00000000005959d0] ext4_fill_super+0x330/0x38a0
[  636.982811]  [00000000005129f0] mount_bdev+0x150/0x1a0
[  637.044245]  [0000000000513514] mount_fs+0x14/0x100
[  637.102597]  [000000000052de20] vfs_kern_mount+0x40/0xe0
[  637.166147]  [0000000000530d04] do_mount+0x1a4/0xb00
[  637.225525]  [00000000005319d4] SyS_mount+0x54/0xa0
[  637.283896]  [00000000008a6da0] mount_block_root+0x100/0x290
[  637.351599]  [00000000008a7104] prepare_namespace+0x170/0x1b0
[  637.420351]  [00000000008a6b70] kernel_init_freeable+0x1c0/0x1d0
[  637.492240]  [000000000078e144] kernel_init+0x4/0x100
[  637.552717]  [00000000004060c4] ret_from_fork+0x1c/0x2c
[  637.615163] Disabling lock debugging due to kernel taint
[  637.678734] Caller[00000000005f4850]: blk_sq_make_request+0x50/0x200
[  637.754792] Caller[00000000005e96d0]: generic_make_request+0x70/0xc0
[  637.830878] Caller[00000000005e979c]: submit_bio+0x7c/0x160
[  637.897517] Caller[000000000053fc30]: _submit_bh+0x150/0x1e0
[  637.965236] Caller[000000000053fd64]: __bread_gfp+0x84/0x100
[  638.032958] Caller[00000000005959d0]: ext4_fill_super+0x330/0x38a0
[  638.106966] Caller[00000000005129f0]: mount_bdev+0x150/0x1a0
[  638.174655] Caller[0000000000513514]: mount_fs+0x14/0x100
[  638.239249] Caller[000000000052de20]: vfs_kern_mount+0x40/0xe0
[  638.309055] Caller[0000000000530d04]: do_mount+0x1a4/0xb00
[  638.374726] Caller[00000000005319d4]: SyS_mount+0x54/0xa0
[  638.439288] Caller[00000000008a6da0]: mount_block_root+0x100/0x290
[  638.513260] Caller[00000000008a7104]: prepare_namespace+0x170/0x1b0
[  638.588273] Caller[00000000008a6b70]: kernel_init_freeable+0x1c0/0x1d0
[  638.666441] Caller[000000000078e144]: kernel_init+0x4/0x100
[  638.733089] Caller[00000000004060c4]: ret_from_fork+0x1c/0x2c
[  638.801835] Caller[0000000000000000]:           (null)
[  638.863300] Instruction DUMP: c2004009  83287003  81c3e008 <d0588001> 01000000  9de3bf20  c201a038  b607a7ef  b4062630 
[  638.992451] note: swapper/10[1] exited with preempt_count 1
[  639.059205] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[  639.059205] 
[  639.168584] Press Stop-A (L1-A) to return to the boot prom
[  639.234157] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[  639.234157] 


#
# Automatically generated file; DO NOT EDIT.
# Linux/sparc64 3.18.0-rc4 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_SPARC=y
# CONFIG_SPARC32 is not set
CONFIG_SPARC64=y
CONFIG_ARCH_DEFCONFIG="arch/sparc/configs/sparc64_defconfig"
CONFIG_IOMMU_HELPER=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_PREFLOW_FASTEOI=y
CONFIG_SPARSE_IRQ=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
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
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TASKS_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
# CONFIG_BUILD_BIN2C is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_BPF=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
# CONFIG_PERF_EVENTS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
CONFIG_HAVE_64BIT_ALIGNED_ACCESS=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_NMI_WATCHDOG=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_ODD_RT_SIGACTION=y
CONFIG_OLD_SIGSUSPEND=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_NR_CPUS=16
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_SPARC64_SMP=y
CONFIG_EARLYFB=y
# CONFIG_SECCOMP is not set
CONFIG_HOTPLUG_CPU=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_US3_MC is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_NO_BOOTMEM=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_CMDLINE_BOOL is not set

#
# Bus options (PCI etc.)
#
CONFIG_SBUS=y
CONFIG_SBUSCHAR=y
# CONFIG_SUN_LDOMS is not set
# CONFIG_PCI is not set
# CONFIG_PCI_DOMAINS is not set
# CONFIG_PCI_SYSCALL is not set
# CONFIG_PCCARD is not set
# CONFIG_SUN_OPENPROMFS is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

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
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_GENEVE is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=m
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
CONFIG_NF_CONNTRACK_MARK=y
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
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=m
CONFIG_NFT_EXTHDR=m
CONFIG_NFT_META=m
CONFIG_NFT_CT=m
CONFIG_NFT_RBTREE=m
CONFIG_NFT_HASH=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_NAT=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
# CONFIG_NETFILTER_XT_SET is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_CT is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

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
CONFIG_NETFILTER_XT_MATCH_IPCOMP=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
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
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
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
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NF_TABLES_ARP=m
CONFIG_NF_NAT_IPV4=m
CONFIG_NFT_CHAIN_NAT_IPV4=m
CONFIG_NF_NAT_MASQUERADE_IPV4=m
CONFIG_NFT_MASQ_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
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
CONFIG_NF_TABLES_IPV6=m
CONFIG_NFT_CHAIN_ROUTE_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_NF_NAT_IPV6=m
CONFIG_NFT_CHAIN_NAT_IPV6=m
CONFIG_NF_NAT_MASQUERADE_IPV6=m
CONFIG_NFT_MASQ_IPV6=m
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
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=m
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
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
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
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
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_OF_PROMTREE=y
CONFIG_OF_NET=y
CONFIG_PARPORT=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_SUNBPP=m
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set

#
# Texas Instruments shared transport line discipline
#

#
# Altera FPGA firmware download module
#

#
# Intel MIC Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_MQ_DEFAULT=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_QLOGICPTI=m
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SUNESP=y
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NLMON is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_NET_DSA_MV88E6171 is not set
# CONFIG_NET_DSA_BCM_SF2 is not set
CONFIG_ETHERNET=y
# CONFIG_GRETH is not set
# CONFIG_ALTERA_TSE is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_XGENE is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNBMAC=m
CONFIG_SUNQE=m
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_PHYLIB is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
# CONFIG_INPUT_KEYBOARD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
# CONFIG_SERIO is not set
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
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
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_SUNCORE=y
CONFIG_SERIAL_SUNZILOG=y
CONFIG_SERIAL_SUNZILOG_CONSOLE=y
# CONFIG_SERIAL_SUNHV is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_GRLIB_GAISLER_APBUART is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_R3964 is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set

#
# I2C support
#
# CONFIG_I2C is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_POWER_AVS is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
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
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_HI6421_PMIC is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_VGASTATE is not set

#
# Console display driver support
#
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_SUPPORT is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
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
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

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
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_SUN4V=y
CONFIG_RTC_DRV_STARFIRE=y
# CONFIG_RTC_DRV_SNVS is not set
# CONFIG_RTC_DRV_XGENE is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_SOC_TI is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Misc Linux/SPARC drivers
#
CONFIG_SUN_OPENPROMIO=m
CONFIG_OBP_FLASH=m
# CONFIG_TADPOLE_TS102_UCTRL is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
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
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
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
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_SCHED_STACK_END_CHECK=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_HAVE_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_DEBUG_DCFLUSH is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_MANAGER2 is not set
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_MCRYPTD is not set
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
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_SPARC64 is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRCT10DIF is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MD5_SPARC64 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA1_SPARC64 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA256_SPARC64 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_SHA512_SPARC64 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_SPARC64 is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_SPARC64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_DES_SPARC64 is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_ARCH_HAS_SG_CHAIN=y

-- 
Meelis Roos (mroos@linux.ee)
