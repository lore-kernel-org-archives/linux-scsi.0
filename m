From: Meelis Roos <mroos@linux.ee>
Subject: Re: 3.2-rc2+git: kernel BUG at block/blk-core.c:1000!
 (__scsi_queue_insert)
Date: Tue, 13 Dec 2011 16:04:23 +0200 (EET)
Message-ID: <alpine.SOC.1.00.1112131603130.28063@math.ut.ee>
References: <alpine.SOC.1.00.1111231223090.15939@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.SOC.1.00.1111231223090.15939@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Any hope of somebody looking into it? It's still present and 
reproducible in 3.2-rc5.

> Hello,
> 
> While trying 3.2.0-rc2-00143-ga767835 on Sun Ultra 10 (sparc64) with 
> Adaptec SCSI controller, I can consistently get the below BUG shortly 
> after bootup. Another machine, Sun Ultra 5 with IDE disk, works fine 
> (config might also differ in other details than ide/scsi).
> 
> PROMLIB: Sun IEEE Boot Prom 'OBP 3.31.0 2001/07/25 20:36'
> PROMLIB: Root node compatible: 
> Initializing cgroup subsys cpu
> Linux version 3.2.0-rc2-00143-ga767835 (mroos@u10) (gcc version 4.6.2 (Debian 4.6.2-4) ) #8 Mon Nov 21 00:18:29 EET 2011
> debug: ignoring loglevel setting.
> bootconsole [earlyprom0] enabled
> ARCH: SUN4U
> Ethernet address: 08:00:20:9e:82:fd
> Kernel: Using 2 locked TLB entries for main kernel image.
> Remapping the kernel... done.
> OF stdout device is: /pci@1f,0/pci@1,1/ebus@1/se@14,400000:a
> PROM: Built device tree with 49735 bytes of memory.
> Top of RAM: 0x1ff28000, Total RAM: 0x1ff16000
> Memory hole size: 0MB
> [0000010000000000-fffff80000c00000] page_structs=131072 node=0 entry=0/8192
> [0000010000000000-fffff80001000000] page_structs=131072 node=0 entry=1/8192
> Zone PFN ranges:
>   Normal   0x00000000 -> 0x0000ff94
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x0000ff7f
>     0: 0x0000ff88 -> 0x0000ff94
> On node 0 totalpages: 65419
>   Normal zone: 512 pages used for memmap
>   Normal zone: 0 pages reserved
>   Normal zone: 64907 pages, LIFO batch:15
> Booting Linux...
> CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
> CPU CAPS: [vis]
> pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> pcpu-alloc: [0] 0 
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64907
> Kernel command line: root=/dev/sda4 ro debug ignore_loglevel
> PID hash table entries: 2048 (order: 1, 16384 bytes)
> Dentry cache hash table entries: 65536 (order: 6, 524288 bytes)
> Inode-cache hash table entries: 32768 (order: 5, 262144 bytes)
> Memory: 508840k available (3472k kernel code, 1248k data, 168k init) [fffff80000000000,000000001ff28000]
> SLUB: Genslabs=16, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> NR_IRQS:255
> clocksource: mult[3555555] shift[24]
> clockevent: mult[4ccccccd] shift[32]
> Console: colour dummy device 80x25
> console [tty0] enabled, bootconsole disabled
> PROMLIB: Sun IEEE Boot Prom 'OBP 3.31.0 2001/07/25 20:36'
> PROMLIB: Root node compatible: 
> Initializing cgroup subsys cpu
> Linux version 3.2.0-rc2-00143-ga767835 (mroos@u10) (gcc version 4.6.2 (Debian 4.6.2-4) ) #8 Mon Nov 21 00:18:29 EET 2011
> debug: ignoring loglevel setting.
> bootconsole [earlyprom0] enabled
> ARCH: SUN4U
> Ethernet address: 08:00:20:9e:82:fd
> Kernel: Using 2 locked TLB entries for main kernel image.
> Remapping the kernel... done.
> OF stdout device is: /pci@1f,0/pci@1,1/ebus@1/se@14,400000:a
> PROM: Built device tree with 49735 bytes of memory.
> Top of RAM: 0x1ff28000, Total RAM: 0x1ff16000
> Memory hole size: 0MB
> [0000010000000000-fffff80000c00000] page_structs=131072 node=0 entry=0/8192
> [0000010000000000-fffff80001000000] page_structs=131072 node=0 entry=1/8192
> Zone PFN ranges:
>   Normal   0x00000000 -> 0x0000ff94
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x0000ff7f
>     0: 0x0000ff88 -> 0x0000ff94
> On node 0 totalpages: 65419
>   Normal zone: 512 pages used for memmap
>   Normal zone: 0 pages reserved
>   Normal zone: 64907 pages, LIFO batch:15
> Booting Linux...
> CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
> CPU CAPS: [vis]
> pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> pcpu-alloc: [0] 0 
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64907
> Kernel command line: root=/dev/sda4 ro debug ignore_loglevel
> PID hash table entries: 2048 (order: 1, 16384 bytes)
> Dentry cache hash table entries: 65536 (order: 6, 524288 bytes)
> Inode-cache hash table entries: 32768 (order: 5, 262144 bytes)
> Memory: 508840k available (3472k kernel code, 1248k data, 168k init) [fffff80000000000,000000001ff28000]
> SLUB: Genslabs=16, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> NR_IRQS:255
> clocksource: mult[3555555] shift[24]
> clockevent: mult[4ccccccd] shift[32]
> Console: colour dummy device 80x25
> console [tty0] enabled, bootconsole disabled
> Calibrating delay using timer specific routine.. 601.00 BogoMIPS (lpj=3005039)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> NET: Registered protocol family 16
> /pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
> /pci@1f,0: SABRE PCI Bus Module ver[0:0]
> PCI: Scanning PBM /pci@1f,0
> pci 0000:02:02.0: supports D1 D2
> pci 0000:02:02.0: PME# supported from D0 D1 D2 D3hot
> pci 0000:02:02.0: PME# disabled
> bio: create slab <bio-0> at 0
> vgaarb: device added: PCI:0000:01:02.0,decodes=io+mem,owns=none,locks=none
> vgaarb: loaded
> vgaarb: bridge control possible 0000:01:02.0
> SCSI subsystem initialized
> /pci@1f,0/pci@1,1/ebus@1/eeprom@14,0: Mostek regs at 0x1fff1000000
> AUXIO: Found device at /pci@1f,0/pci@1,1/ebus@1/auxio@14,726000
> Switching to clocksource tick
> NET: Registered protocol family 2
> IP route cache hash table entries: 4096 (order: 2, 32768 bytes)
> TCP established hash table entries: 16384 (order: 5, 262144 bytes)
> TCP bind hash table entries: 16384 (order: 4, 131072 bytes)
> TCP: Hash tables configured (established 16384 bind 16384)
> TCP reno registered
> UDP hash table entries: 256 (order: 0, 8192 bytes)
> UDP-Lite hash table entries: 256 (order: 0, 8192 bytes)
> NET: Registered protocol family 1
> PCI: CLS 64 bytes, default 64
> power: Control reg at 1fff1724000
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
> msgmni has been set to 993
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> start plist test
> end plist test
> PCI: Enabling device: (0000:01:02.0), cmd 82
> atyfb: 3D RAGE II+ (Mach64 GT) [0x4754 rev 0x9a]
> atyfb: 2M SGRAM (1:1), 14.31818 MHz XTAL, 200 MHz PLL, 67 Mhz MCLK, 67 MHz XCLK
> Console: switching to colour frame buffer device 80x30
> atyfb: fb0: ATY Mach64 frame buffer device on PCI
> /SUNW,ffb@1e,0: FFB at 000001fc00000000, type 51, DAC pnum[236e] rev[10] manuf_rev[1]
> /pci@1f,0/pci@1,1/ebus@1/su@14,3083f8: Keyboard port at 1fff13083f8, irq 6
> /pci@1f,0/pci@1,1/ebus@1/su@14,3062f8: Mouse port at 1fff13062f8, irq 7
> f0061c64: ttyS0 at MMIO 0x1fff1400000 (irq = 5) is a SAB82532 V3.2
> Console: ttyS0 (SAB82532)
> console [ttyS0] enabled
> f0061c64: ttyS1 at MMIO 0x1fff1400040 (irq = 5) is a SAB82532 V3.2
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a National Semiconductor PC87306
> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>         <Adaptec 2940 Ultra SCSI adapter>
>         aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs
> 
> scsi 0:0:0:0: Direct-Access     QUANTUM  ATLAS IV 18 WLS  0909 PQ: 0 ANSI: 3
> scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
> scsi target0:0:0: Beginning Domain Validation
> scsi target0:0:0: wide asynchronous
> scsi target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 8)
> scsi target0:0:0: Domain Validation skipping write tests
> scsi target0:0:0: Ending Domain Validation
> sd 0:0:0:0: [sda] 35885168 512-byte logical blocks: (18.3 GB/17.1 GiB)
> PCI: Enabling device: (0000:01:01.1), cmd 2
> sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
> eth0: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:9e:82:fd
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: e3 00 10 08
> mousedev: PS/2 mouse device common for all mice
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
> TCP cubic registered
> NET: Registered protocol family 17
> Registering the dns_resolver key type
> registered taskstats version 1
> rtc-m48t59 rtc-m48t59.0: setting system clock to 2011-11-21 11:41:58 UTC (1321875718)
>  sda: sda1 sda2 sda3 sda4
> sd 0:0:0:0: [sda] Attached SCSI disk
> input: Sun Mouse as /devices/root/f005f9c0/f00601b4/f0061504/f0064df4/serio1/input/input0
> EXT3-fs (sda4): error: couldn't mount because of unsupported optional features (240)
> EXT2-fs (sda4): error: couldn't mount because of unsupported optional features (244)
> EXT4-fs (sda4): INFO: recovery required on readonly filesystem
> EXT4-fs (sda4): write access will be enabled during recovery
> EXT4-fs (sda4): recovery complete
> EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 8:4.
> 8139too: 8139too Fast Ethernet driver 0.9.28
> PCI: Enabling device: (0000:02:02.0), cmd 3
> 8139too 0000:02:02.0: eth1: RealTek RTL8139 at 0x1ff00020000, 00:10:b5:a3:e4:a6, IRQ 16
> /pci@1f,0/pci@1,1/ebus@1/flashprom@10,0: OBP Flash, RD 1fff0000000[100000] WR 1fff0000000[100000]
> libata version 3.00 loaded.
> scsi1 : pata_cmd64x
> scsi2 : pata_cmd64x
> ata1: PATA max MWDMA2 cmd 0x1fe02c00000 ctl 0x1fe02c00008 bmdma 0x1fe02c00020 irq 14
> ata2: PATA max MWDMA2 cmd 0x1fe02c00010 ctl 0x1fe02c00018 bmdma 0x1fe02c00028 irq 14
> pata_cmd64x: active 10 recovery 10 setup 3.
> pata_cmd64x: active 10 recovery 10 setup 3.
> pata_cmd64x: active 10 recovery 10 setup 3.
> pata_cmd64x: active 10 recovery 10 setup 3.
> Adding 1052248k swap on /dev/sda2.  Priority:-1 extents:1 across:1052248k 
> EXT4-fs (sda4): re-mounted. Opts: (null)
> eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.
> eth0: no IPv6 routers present
> kernel BUG at block/blk-core.c:1000!
>               \|/ ____ \|/
>               "@'/ .. \`@"
>               /_| \__/ |_\
>                  \__U_/
> swapper(0): Kernel bad sw trap 5 [#1]
> TSTATE: 0000008080e01602 TPC: 00000000005c3380 TNPC: 00000000005c3384 Y: 00000000    Not tainted
> TPC: <blk_requeue_request+0x60/0x80>
> g0: 0000000000000003 g1: 0000000000872000 g2: 0000000000000001 g3: ffffffffffffffd8
> g4: 0000000000869b50 g5: f7ddef20f7767b60 g6: 0000000000860000 g7: 0000000000001000
> o0: 0000000000000028 o1: 0000000000816440 o2: 00000000000003e8 o3: 00000000ffffa86e
> o4: fffff8001f00cb60 o5: 0000000000816440 sp: fffff8001fefb471 ret_pc: 00000000005c3378
> RPC: <blk_requeue_request+0x58/0x80>
> l0: 00000000fffc00f0 l1: 0000000000883790 l2: 0000000000000001 l3: fffff8001f0060c0
> l4: fffff8001f0020c0 l5: 0000000000000000 l6: 00000000008a2e18 l7: fffffffffffffff8
> i0: fffff8001f2d3100 i1: fffff8001f329a20 i2: 000000000091d56c i3: 000000000091d400
> i4: 0000000000000001 i5: 0000000000000000 i6: fffff8001fefb521 i7: 000000000065dc10
> I7: <__scsi_queue_insert+0xb0/0x100>
> Call Trace:
>  [000000000065dc10] __scsi_queue_insert+0xb0/0x100
>  [00000000005c812c] blk_done_softirq+0x6c/0xa0
>  [000000000045a530] __do_softirq+0x90/0x120
>  [000000000042b054] do_softirq+0x74/0xa0
>  [000000000045a82c] irq_exit+0x8c/0xa0
>  [000000000042af9c] handler_irq+0x9c/0xe0
>  [00000000004208b4] tl0_irq5+0x14/0x20
>  [0000000000439484] touch_nmi_watchdog+0x4/0x40
>  [00000000008a8788] start_kernel+0x318/0x328
>  [000000000074af88] tlb_fixup_done+0x80/0x88
>  [0000000000000000]           (null)
> Disabling lock debugging due to kernel taint
> Caller[000000000065dc10]: __scsi_queue_insert+0xb0/0x100
> Caller[00000000005c812c]: blk_done_softirq+0x6c/0xa0
> Caller[000000000045a530]: __do_softirq+0x90/0x120
> Caller[000000000042b054]: do_softirq+0x74/0xa0
> Caller[000000000045a82c]: irq_exit+0x8c/0xa0
> Caller[000000000042af9c]: handler_irq+0x9c/0xe0
> Caller[00000000004208b4]: tl0_irq5+0x14/0x20
> Caller[000000000042b828]: cpu_idle+0x28/0x60
> Caller[00000000008a8788]: start_kernel+0x318/0x328
> Caller[000000000074af88]: tlb_fixup_done+0x80/0x88
> Caller[0000000000000000]:           (null)
> Instruction DUMP: 921023e8  7ff99282  90122040 <91d02005> 30680007  01000000  01000000  01000000  01000000 
> Kernel panic - not syncing: Aiee, killing interrupt handler!
> Call Trace:
>  [00000000004586ec] do_exit+0x2cc/0x300
>  [00000000004274c0] die_if_kernel+0x180/0x260
>  [00000000004282d4] bad_trap+0xd4/0xe0
>  [00000000004220b0] tl0_resv104+0x30/0xa0
>  [00000000005c3380] blk_requeue_request+0x60/0x80
>  [000000000065dc10] __scsi_queue_insert+0xb0/0x100
>  [00000000005c812c] blk_done_softirq+0x6c/0xa0
>  [000000000045a530] __do_softirq+0x90/0x120
>  [000000000042b054] do_softirq+0x74/0xa0
>  [000000000045a82c] irq_exit+0x8c/0xa0
>  [000000000042af9c] handler_irq+0x9c/0xe0
>  [00000000004208b4] tl0_irq5+0x14/0x20
>  [0000000000439484] touch_nmi_watchdog+0x4/0x40
>  [00000000008a8788] start_kernel+0x318/0x328
>  [000000000074af88] tlb_fixup_done+0x80/0x88
>  [0000000000000000]           (null)
> Press Stop-A (L1-A) to return to the boot prom
> 
> 

-- 
Meelis Roos (mroos@linux.ee)
