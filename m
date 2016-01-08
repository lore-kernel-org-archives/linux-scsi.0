From: Meelis Roos <mroos@linux.ee>
Subject: parisc late boot crash in 4.4-rc, scsi-related
Date: Fri, 8 Jan 2016 22:56:43 +0200 (EET)
Message-ID: <alpine.LRH.2.20.1601082249420.19024@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-parisc-owner@vger.kernel.org>
Sender: linux-parisc-owner@vger.kernel.org
To: linux-parisc@vger.kernel.org, linux.block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I noticed on RP3440 and A500 that recent 4.4-rc* crashes on boot. The 
following is dmesg that was copied piecewise by hand from ILO console 
log (so it can contain some whitespace damage), from 
4.4.0-rc7-00028-gc616920 on RP3440:

SCSI subsystem initialized
NET: Registered protocol family 2
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
UDP hash table entries: 8192 (order: 6, 262144 bytes)
UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
NET: Registered protocol family 1
Chassis warnings not supported.
Performance monitoring counters enabled for Storm Peak Slow
futex hash table entries: 1024 (order: 3, 32768 bytes)
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
PDC Stable Storage facility v0.30
STI GSC/PCI core graphics driver Version 0.9b
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
0000:e0:01.0: ttyS0 at MMIO 0xfffffffff4051000 (irq = 27, base_baud = 115200) is a 16450
0000:e0:01.1: ttyS1 at MMIO 0xfffffffff4050000 (irq = 27, base_baud = 115200) is a 16550A
console [ttyS1] enabled
console [ttyS1] enabled
bootconsole [ttyB0] disabled
bootconsole [ttyB0] disabled
0000:e0:01.1: ttyS2 at MMIO 0xfffffffff4050010 (irq = 27, base_baud = 115200) is a 16550A
0000:e0:01.1: ttyS3 at MMIO 0xfffffffff4050038 (irq = 27, base_baud = 115200) is a 16550A
sym0: <1010-66> rev 0x1 at pci 0000:20:01.0 irq 22
sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi host0: sym-2.2.3
scsi 0:0:0:0: Direct-Access     COMPAQ   BF07285A36       HPB7 PQ: 0 ANSI: 3
scsi target0:0:0: tagged command queuing enabled, command queue depth 16.
scsi target0:0:0: Beginning Domain Validation
scsi target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi target0:0:0: Ending Domain Validation
random: nonblocking pool is initialized
sym1: <1010-66> rev 0x1 at pci 0000:20:01.1 irq 23
sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: SCSI BUS has been reset.
scsi host1: sym-2.2.3
mousedev: PS/2 mouse device common for all mice
sd 0:0:0:0: [sda] 142264000 512-byte logical blocks: (72.8 GB/67.8 GiB)
rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
NET: Registered protocol family 17
sd 0:0:0:0: [sda] Write Protect is off
rtc-generic rtc-generic: setting system clock to 2015-12-31 11:45:39 UTC (1451562339)
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
EXT4-fs (sda3): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda3): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
devtmpfs: mounted
Freeing unused kernel memory: 1024K (0000000040100000 - 0000000040200000)
------------[ cut here ]------------
WARNING: at block/blk-merge.c:438
Modules linked in:
CPU: 0 PID: 1 Comm: init Not tainted 4.4.0-rc7-00028-gc616920 #81
task: 000000007fce8000 ti: 000000007fc3c000 task.ti: 000000007fc3c000

     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001101111111100001111 Not tainted
r00-03  000000ff0806ff0f 000000007fc3d990 0000000000000000 000000007fc3d990
r04-07  00000000407b20b0 0000000000000000 0000000000000110 0000000000000000
r08-11  0000000000000000 0000000000000001 000000033f8b6bf0 0000000000000000
r12-15  0000000000001000 000000033f9e0000 0000000000000002 0000000000000011
r16-19  0000000042174470 000000033f8b6bf0 000000033f8b6930 0000000000000000
r20-23  0000000000000000 000000007f1dd800 0000000000011000 0000000000000000
r24-27  0000000000000000 2ffffedf40000000 000000033f8b6bf0 00000000407b20b0
r28-31  0000000000000001 0000000000001000 000000007fc3dac0 0000000000000001
sr00-03  0000000000000000 0000000000000800 0000000000000000 0000000000000800
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040481d9c 0000000040481da0
 IIR: 03ffe01f    ISR: 0000000010340800  IOR: 000003fe2d8b6bf0
 CPU:        0   CR30: 000000007fc3c000 CR31: ffffffffffffffff
 ORIG_R28: 0000000000000158
 IAOQ[0]: blk_rq_map_sg+0x5cc/0x600
 IAOQ[1]: blk_rq_map_sg+0x5d0/0x600
 RP(r2):           (null)
Backtrace:
 [<00000000405510d0>] scsi_init_sgtable+0xa0/0x130
 [<00000000405511b4>] scsi_init_io+0x54/0x160
 [<0000000040570958>] sd_init_command+0x68/0x708
 [<00000000405513c4>] scsi_setup_cmnd+0x104/0x1a0
 [<0000000040551f54>] scsi_queue_rq+0x864/0x9f8
 [<00000000404877f4>] __blk_mq_run_hw_queue+0x2e4/0x4e0
 [<00000000404874e4>] blk_mq_run_hw_queue+0xdc/0x108
 [<000000004048928c>] blk_mq_insert_requests+0x15c/0x190
 [<000000004048a19c>] blk_mq_flush_plug_list+0x17c/0x1a8
 [<000000004047af64>] blk_flush_plug_list+0x104/0x2b0
 [<000000004047b4c4>] blk_finish_plug+0x44/0x68
 [<00000000402ee0dc>] __do_page_cache_readahead+0x29c/0x360
 [<00000000402dfb4c>] filemap_fault+0x4f4/0x5a0
 [<000000004030d464>] __do_fault+0x5c/0x148
 [<000000004031360c>] handle_mm_fault+0xa84/0x1a10

---[ end trace 4a3faaec387ada43 ]---
------------[ cut here ]------------
kernel BUG at drivers/scsi/scsi_lib.c:1096!
CPU: 0 PID: 1 Comm: init Tainted: G        W       4.4.0-rc7-00028-gc616920 #81
task: 000000007fce8000 ti: 000000007fc3c000 task.ti: 000000007fc3c000

     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001101111111100001111 Tainted: G        W
r00-03  000000ff0806ff0f 000000007fc3d990 00000000405510d0 000000007fc3d8f0
r04-07  00000000407b20b0 0000000000000001 000000033f8b6b48 000000033f8b6930
r08-11  000000033f871000 000000007f148000 0000000000011000 0000000040999d00
r12-15  000000033f871000 000000033f8b6930 0000000000000000 000000033f871000
r16-19  0000000000000000 0000000000000158 000000033f854ba0 0000000000000000
r20-23  0000000000000000 000000007f1dd800 0000000000011000 0000000000000000
r24-27  0000000000000000 2ffffedf40000000 000000033f8b6bf0 00000000407b20b0
r28-31  0000000000000002 0000000000001000 000000007fc3d990 0000000000000001
sr00-03  0000000000000000 0000000000000800 0000000000000000 0000000000000800
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 0000000040551140 0000000040551144
 IIR: 03ffe01f    ISR: 0000000000000000  IOR: 0000000000000000
 CPU:        0   CR30: 000000007fc3c000 CR31: ffffffffffffffff
 ORIG_R28: 0000000000000000
 IAOQ[0]: scsi_init_sgtable+0x110/0x130
 IAOQ[1]: scsi_init_sgtable+0x114/0x130
 RP(r2): scsi_init_sgtable+0xa0/0x130
Backtrace:
 [<00000000405511b4>] scsi_init_io+0x54/0x160
 [<0000000040570958>] sd_init_command+0x68/0x708
 [<00000000405513c4>] scsi_setup_cmnd+0x104/0x1a0
 [<0000000040551f54>] scsi_queue_rq+0x864/0x9f8
 [<00000000404877f4>] __blk_mq_run_hw_queue+0x2e4/0x4e0
 [<00000000404874e4>] blk_mq_run_hw_queue+0xdc/0x108
 [<000000004048928c>] blk_mq_insert_requests+0x15c/0x190
 [<000000004048a19c>] blk_mq_flush_plug_list+0x17c/0x1a8
 [<000000004047af64>] blk_flush_plug_list+0x104/0x2b0
 [<000000004047b4c4>] blk_finish_plug+0x44/0x68
 [<00000000402ee0dc>] __do_page_cache_readahead+0x29c/0x360
 [<00000000402dfb4c>] filemap_fault+0x4f4/0x5a0
 [<000000004030d464>] __do_fault+0x5c/0x148
 [<000000004031360c>] handle_mm_fault+0xa84/0x1a10

CPU: 0 PID: 1 Comm: init Tainted: G        W       4.4.0-rc7-00028-gc616920 #81
Backtrace:
 [<0000000040216888>] show_stack+0x20/0x38
 [<00000000404a2fac>] dump_stack+0xac/0x130
 [<0000000040216a5c>] die_if_kernel+0x19c/0x2e0
 [<0000000040217948>] handle_interruption+0x9a8/0x9d0

---[ end trace 4a3faaec387ada44 ]---
note: init[1] exited with preempt_count 2
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

---[ end Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b

-- 
Meelis Roos (mroos@linux.ee)
