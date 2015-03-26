From: Meelis Roos <mroos@linux.ee>
Subject: blk-mq startup crash in 3.19 with qlogic on sparc64
Date: Thu, 26 Mar 2015 08:54:42 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1503260845500.23699@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I powered on my Sun E3500 and E3000 sparc64 servers after several 
months. E3000 has some hardware trouble (and I have another issue open 
there, need to test lastest kernel with and without a patch fronm you) 
but E3500 runs but has another blk-mq problem. I do not understand from 
the dmesg if it is from qla1280 that runs also the boot diks, or 
qla2xxx that has some FC disks installed for test. The machine is 
remote, I can not disconnect things physically before Wednesday.

3.19 with blk-mq has the problem, with scsi_mod.use_blk_mq=0 boots fine.

Note the lines 
Ignoring CPU 18 which is >= NR_CPUS (16)
Ignoring CPU 19 which is >= NR_CPUS (16)
It was a kernel configuration error (I added CPUS recently and the ID-s 
are above configured 16) - it may be releated?


PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
PROMLIB: Root node compatible: 
Linux version 3.19.0 (mroos@korvits) (gcc version 4.9.2 (Debian 4.9.2-1) ) #63 SMP Wed Mar 25 16:14:28 EET 2015
debug: ignoring loglevel setting.
bootconsole [earlyprom0] enabled
ARCH: SUN4U
Ethernet address: 08:00:20:b6:ee:e2
MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
Kernel: Using 6 locked TLB entries for main kernel image.
Remapping the kernel... done.
kmemleak: Kernel memory leak detector disabled
OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
PROM: Built device tree with 184787 bytes of memory.
Ignoring CPU 18 which is >= NR_CPUS (16)
Ignoring CPU 19 which is >= NR_CPUS (16)
Top of RAM: 0xffcf0000, Total RAM: 0xff77e000
Memory hole size: 5MB
Allocated 4210688 bytes for kernel page tables.
Zone ranges:
  Normal   [mem 0x00000000-0xffceffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00000000-0xff69dfff]
  node   0: [mem 0xffc00000-0xffccffff]
  node   0: [mem 0xffce0000-0xffceffff]
Initmem setup node 0 [mem 0x00000000-0xffceffff]
On node 0 totalpages: 523199
  Normal zone: 4093 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 523199 pages, LIFO batch:15
Booting Linux...
CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
CPU CAPS: [vis]
PERCPU: Embedded 7 pages/cpu @fffff800fec00000 s14848 r8192 d34304 u2097152
pcpu-alloc: s14848 r8192 d34304 u2097152 alloc=1*4194304
pcpu-alloc: [0] 6 7 
Ignoring CPU 18 which is >= NR_CPUS (16)
Ignoring CPU 19 which is >= NR_CPUS (16)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519106
Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
PID hash table entries: 4096 (order: 2, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
Sorting __ex_table...
Memory: 4119992K/4185592K available (4554K kernel code, 299K rwdata, 1600K rodata, 584K init, 14666K bss, 65600K reserved, 0K cma-reserved)
Hierarchical RCU implementation.
	RCU lockdep checking is enabled.
	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
Running RCU self tests
NR_IRQS:2048 nr_irqs:2048 1
clocksource: mult[2800000] shift[24]
clockevent: mult[66666666] shift[32]
Console: colour dummy device 80x25
console [tty0] enabled
bootconsole [earlyprom0] disabled
PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
PROMLIB: Root node compatible: 
Linux version 3.19.0 (mroos@korvits) (gcc version 4.9.2 (Debian 4.9.2-1) ) #63 SMP Wed Mar 25 16:14:28 EET 2015
debug: ignoring loglevel setting.
bootconsole [earlyprom0] enabled
ARCH: SUN4U
Ethernet address: 08:00:20:b6:ee:e2
MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
Kernel: Using 6 locked TLB entries for main kernel image.
Remapping the kernel... done.
kmemleak: Kernel memory leak detector disabled
OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
PROM: Built device tree with 184787 bytes of memory.
Ignoring CPU 18 which is >= NR_CPUS (16)
Ignoring CPU 19 which is >= NR_CPUS (16)
Top of RAM: 0xffcf0000, Total RAM: 0xff77e000
Memory hole size: 5MB
Allocated 4210688 bytes for kernel page tables.
Zone ranges:
  Normal   [mem 0x00000000-0xffceffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00000000-0xff69dfff]
  node   0: [mem 0xffc00000-0xffccffff]
  node   0: [mem 0xffce0000-0xffceffff]
Initmem setup node 0 [mem 0x00000000-0xffceffff]
On node 0 totalpages: 523199
  Normal zone: 4093 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 523199 pages, LIFO batch:15
Booting Linux...
CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
CPU CAPS: [vis]
PERCPU: Embedded 7 pages/cpu @fffff800fec00000 s14848 r8192 d34304 u2097152
pcpu-alloc: s14848 r8192 d34304 u2097152 alloc=1*4194304
pcpu-alloc: [0] 6 7 
Ignoring CPU 18 which is >= NR_CPUS (16)
Ignoring CPU 19 which is >= NR_CPUS (16)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519106
Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
PID hash table entries: 4096 (order: 2, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
Sorting __ex_table...
Memory: 4119992K/4185592K available (4554K kernel code, 299K rwdata, 1600K rodata, 584K init, 14666K bss, 65600K reserved, 0K cma-reserved)
Hierarchical RCU implementation.
	RCU lockdep checking is enabled.
	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
Running RCU self tests
NR_IRQS:2048 nr_irqs:2048 1
clocksource: mult[2800000] shift[24]
clockevent: mult[66666666] shift[32]
Console: colour dummy device 80x25
console [tty0] enabled
bootconsole [earlyprom0] disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     32768
... MAX_LOCKDEP_CHAINS:      65536
... CHAINHASH_SIZE:          32768
 memory used by lock dependency info: 8159 kB
 per task-struct memory footprint: 1920 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
  --------------------------------------------------------------------------
  | Wound/wait tests |
  ---------------------
                  ww api failures:  ok  |  ok  |  ok  |
               ww contexts mixing:  ok  |  ok  |
             finishing ww context:  ok  |  ok  |  ok  |  ok  |
               locking mismatches:  ok  |  ok  |  ok  |
                 EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
           spinlock nest unlocked:  ok  |
  -----------------------------------------------------
                                 |block | try  |context|
  -----------------------------------------------------
                          context:  ok  |  ok  |  ok  |
                              try:  ok  |  ok  |  ok  |
                            block:  ok  |  ok  |  ok  |
                         spinlock:  ok  |  ok  |  ok  |
-------------------------------------------------------
Good, all 253 testcases passed! |
---------------------------------
ODEBUG: selftest passed
kmemleak: Early log buffer exceeded (3873), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
Calibrating delay using timer specific routine.. 804.40 BogoMIPS (lpj=4022029)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 8192 (order: 3, 65536 bytes)
Mountpoint-cache hash table entries: 8192 (order: 3, 65536 bytes)
CPU 7: synchronized TICK with master CPU (last diff -15 cycles, maxerr 660 cycles)
Brought up 2 CPUs
devtmpfs: initialized
Performance events: No support for PMU type 'ultra12'
atomic64_test: passed
kworker/u4:0 (20) used greatest stack depth: 8152 bytes left
device-tree: Duplicate name in base, renamed to "fhc#1"
device-tree: Duplicate name in base, renamed to "fhc#2"
device-tree: Duplicate name in base, renamed to "counter-timer#1"
device-tree: Duplicate name in base, renamed to "fhc#3"
device-tree: Duplicate name in base, renamed to "counter-timer#2"
device-tree: Duplicate name in base, renamed to "counter-timer#3"
device-tree: Duplicate name in base, renamed to "fhc#4"
device-tree: Duplicate name in base, renamed to "counter-timer#4"
device-tree: Duplicate name in base, renamed to "counter-timer#5"
NET: Registered protocol family 16
kworker/u4:1 (21) used greatest stack depth: 7832 bytes left
SYSIO: UPA portID ffffffff, at 000001c400000000
SYSIO: UPA portID ffffffff, at 000001c600000000
SYSIO: UPA portID ffffffff, at 000001d400000000
SYSIO: UPA portID ffffffff, at 000001d600000000
/pci@e,4000: PCI IO[1dc02010000] MEM[1dd80000000]
/pci@e,4000: PSYCHO PCI Bus Module ver[4:0]
PCI: Scanning PBM /pci@e,4000
psycho f027f7dc: PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x1dc02010000-0x1dc0201ffff] (bus address [0x0000-0xffff])
pci_bus 0000:00: root bus resource [mem 0x1dd80000000-0x1ddffffffff] (bus address [0x00000000-0x7fffffff])
pci_bus 0000:00: root bus resource [bus 00]
/pci@e,2000: PCI IO[1dc02000000] MEM[1dd00000000]
/pci@e,2000: PSYCHO PCI Bus Module ver[4:0]
PCI: Scanning PBM /pci@e,2000
psycho f0288900: PCI host bridge to bus 0001:80
pci_bus 0001:80: root bus resource [io  0x1dc02000000-0x1dc0200ffff] (bus address [0x0000-0xffff])
pci_bus 0001:80: root bus resource [mem 0x1dd00000000-0x1dd7fffffff] (bus address [0x00000000-0x7fffffff])
pci_bus 0001:80: root bus resource [bus 80]
/pci@f,4000: PCI IO[1de02010000] MEM[1df80000000]
/pci@f,4000: PSYCHO PCI Bus Module ver[4:0]
PCI: Scanning PBM /pci@f,4000
psycho f028a138: PCI host bridge to bus 0002:00
pci_bus 0002:00: root bus resource [io  0x1de02010000-0x1de0201ffff] (bus address [0x0000-0xffff])
pci_bus 0002:00: root bus resource [mem 0x1df80000000-0x1dfffffffff] (bus address [0x00000000-0x7fffffff])
pci_bus 0002:00: root bus resource [bus 00]
/pci@f,2000: PCI IO[1de02000000] MEM[1df00000000]
/pci@f,2000: PSYCHO PCI Bus Module ver[4:0]
PCI: Scanning PBM /pci@f,2000
psycho f029322c: PCI host bridge to bus 0003:80
pci_bus 0003:80: root bus resource [io  0x1de02000000-0x1de0200ffff] (bus address [0x0000-0xffff])
pci_bus 0003:80: root bus resource [mem 0x1df00000000-0x1df7fffffff] (bus address [0x00000000-0x7fffffff])
pci_bus 0003:80: root bus resource [bus 80]
vgaarb: loaded
SCSI subsystem initialized
/central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
fhc: Board #3, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
fhc: Board #9, Version[1] PartID[fa0] Manuf[3e] 
fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] 
fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
clock_board: Detected 5 slot Enterprise system.
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
Switched to clocksource tick
NET: Registered protocol family 2
TCP established hash table entries: 32768 (order: 5, 262144 bytes)
TCP bind hash table entries: 32768 (order: 8, 2097152 bytes)
TCP: Hash tables configured (established 32768 bind 32768)
TCP: reno registered
UDP hash table entries: 2048 (order: 5, 327680 bytes)
UDP-Lite hash table entries: 2048 (order: 5, 327680 bytes)
NET: Registered protocol family 1
PCI: CLS 0 bytes, default 64
futex hash table entries: 512 (order: 3, 65536 bytes)
====[ backtrace testing ]===========
Testing a backtrace from process context.
The following trace is a kernel self test and not a bug!
CPU: 6 PID: 1 Comm: swapper/6 Not tainted 3.19.0 #63
Call Trace:
 [00000000004cf1ec] backtrace_regression_test+0x2c/0x100
 [0000000000426ea4] do_one_initcall+0xe4/0x1e0
 [0000000000a5cb5c] kernel_init_freeable+0x120/0x1d0
 [000000000086b4c4] kernel_init+0x4/0x100
 [0000000000406124] ret_from_fork+0x1c/0x2c
 [0000000000000000]           (null)
Testing a backtrace from irq context.
The following trace is a kernel self test and not a bug!
CPU: 6 PID: 3 Comm: ksoftirqd/6 Not tainted 3.19.0 #63
Call Trace:
 [00000000004cf1a4] backtrace_test_irq_callback+0x4/0x20
 [000000000045f3f8] tasklet_action+0x98/0x120
 [000000000045f570] __do_softirq+0xf0/0x240
 [000000000045f6e8] run_ksoftirqd+0x28/0x80
 [000000000047e6e8] smpboot_thread_fn+0x268/0x2a0
 [000000000047a17c] kthread+0xbc/0xe0
 [0000000000406124] ret_from_fork+0x1c/0x2c
 [0000000000000000]           (null)
Testing a saved backtrace.
The following trace is a kernel self test and not a bug!
 [<00000000004cf288>] backtrace_regression_test+0xc8/0x100
 [<0000000000426ea4>] do_one_initcall+0xe4/0x1e0
 [<0000000000a5cb5c>] kernel_init_freeable+0x120/0x1d0
 [<000000000086b4c4>] kernel_init+0x4/0x100
 [<0000000000406124>] ret_from_fork+0x1c/0x2c
 [<          (null)>]           (null)
====[ end of backtrace testing ]====
audit: initializing netlink subsys (disabled)
audit: type=2000 audit(2.070:1): initialized
HugeTLB registered 8 MB page size, pre-allocated 0 pages
io scheduler noop registered
io scheduler cfq registered (default)
start plist test
end plist test
test_string_helpers: Running tests...
f005de3c: ttyS0 at MMIO 0x1fff8902000 (irq = 2, base_baud = 307200) is a zs (ESCC)
Console: ttyS0 (SunZilog zs0)
console [ttyS0] enabled
f005de3c: ttyS1 at MMIO 0x1fff8902004 (irq = 2, base_baud = 307200) is a zs (ESCC)
f005df14: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
f005df14: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
kworker/u4:1 (401) used greatest stack depth: 7544 bytes left
loop: module loaded
PCI: Enabling device: (0003:80:02.0), cmd 3
scsi host0: Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320ALP PCIx Ultra320 SCSI adapter>
        aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66MHz, 512 SCBs
scsi0: Missing case in ahd_handle_scsiint. status = 0
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x0 Mode 0x33
Card was paused
INTSTAT[0x8]:(SCSIINT) SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x0] SEQINTSTAT[0x0] SAVED_MODE[0x25] DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE) 
SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0] 
LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) SCSISEQ0[0x0] 
SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff] 
SSTAT0[0x0] SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] 
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) LQISTAT0[0x0] 
LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] 
LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
qinstart = 0 qinfifonext = 0
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
Total 0
Kernel Free SCB list: 7 6 5 4 3 2 1 0 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x803b, SCB 0x0
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 

scsi0: FIFO1 Free, LONGJMP == 0x80bc, SCB 0x0
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0

SIMODE0[0x6c]:(ENOVERRUN|ENIOERR|ENSELDI|ENSELDO) 
CCSCBCTL[0x0] 
scsi0: REG0 == 0x45d1, SINDEX = 0x0, DINDEX = 0x0
scsi0: SCBPTR == 0x1ff, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
CDB ff 1 0 0 0 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
qla1280: QLA1040 found on PCI bus 0, dev 3
PCI: Enabling device: (0002:00:03.0), cmd 7
random: nonblocking pool is initialized
scsi(1:0): Resetting SCSI BUS
scsi host1: QLogic QLA1040 PCI to SCSI Host Adapter
       Firmware version:  7.65.06, Driver version 3.27.1
blk-mq: reduced tag depth to 10240
qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.16-k.
PCI: Enabling device: (0001:80:02.0), cmd 3
qla2xxx [0001:80:02.0]-001d: : Found an ISP2200 irq 49 iobase 0x000001dd00002000.
scsi 1:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
scsi(1:0:2:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 1:0:4:0: Direct-Access     IBM      DDYS-T18350M     S80D PQ: 0 ANSI: 3
scsi(1:0:4:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 1:0:10:0: Direct-Access     HP       9.10GB A 80-6331      PQ: 0 ANSI: 2
scsi(1:0:10:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 1:0:11:0: Direct-Access     IBM      DDRS-34560D      DC1B PQ: 0 ANSI: 2
scsi(1:0:11:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 1:0:12:0: Direct-Access     HP       4.26GB A 80-0430 0430 PQ: 0 ANSI: 2
scsi(1:0:12:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 1:0:13:0: Direct-Access     HP       2.13GB A 80-0430 0430 PQ: 0 ANSI: 2
scsi(1:0:13:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi host2: qla2xxx
qla2xxx [0001:80:02.0]-500a:2: LOOP UP detected (1 Gbps).
qla2xxx [0001:80:02.0]-00fb:2: QLogic QLA22xx - .
qla2xxx [0001:80:02.0]-00fc:2: ISP2200: PCI (33 MHz) @ 0001:80:02.0 hdma- host#=2 fw=2.02.08 TP.
sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
eth0: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
eth1: Quattro HME slot 0 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:94
eth2: Quattro HME slot 1 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:95
eth3: Quattro HME slot 2 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:96
eth4: Quattro HME slot 3 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:97
eth5: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
eth6: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
PCI: Enabling device: (0000:00:01.1), cmd 2
eth7: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:b6:ee:e2
mousedev: PS/2 mouse device common for all mice
rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
TCP: cubic registered
NET: Registered protocol family 17
registered taskstats version 1
rtc-m48t59 rtc-m48t59.0: setting system clock to 2015-03-25 14:31:08 UTC (1427293868)
sd 1:0:2:0: [sda] 35843670 512-byte logical blocks: (18.3 GB/17.0 GiB)
sd 1:0:4:0: [sdb] 35843670 512-byte logical blocks: (18.3 GB/17.0 GiB)
sd 1:0:10:0: [sdc] 17773524 512-byte logical blocks: (9.10 GB/8.47 GiB)
sd 1:0:4:0: [sdb] Write Protect is off
sd 1:0:4:0: [sdb] Mode Sense: cb 00 00 08
sd 1:0:11:0: [sdd] 8925000 512-byte logical blocks: (4.56 GB/4.25 GiB)
sd 1:0:13:0: [sdf] 4165272 512-byte logical blocks: (2.13 GB/1.98 GiB)
sd 1:0:12:0: [sde] 8330543 512-byte logical blocks: (4.26 GB/3.97 GiB)
sd 1:0:4:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:10:0: [sdc] Write Protect is off
scsi 2:0:0:0: Direct-Access     SEAGATE  ST3146854FC      0003 PQ: 0 ANSI: 3
sd 1:0:12:0: [sde] Write Protect is off
sd 1:0:12:0: [sde] Mode Sense: 9f 00 10 08
sd 1:0:2:0: [sda] Write Protect is off
sd 1:0:2:0: [sda] Mode Sense: cb 00 00 08
sd 1:0:11:0: [sdd] Write Protect is off
sd 1:0:11:0: [sdd] Mode Sense: b9 00 00 08
sd 1:0:13:0: [sdf] Write Protect is off
sd 1:0:13:0: [sdf] Mode Sense: 9f 00 10 08
sd 1:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:12:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:13:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:11:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdg] 286749488 512-byte logical blocks: (146 GB/136 GiB)
 sdb: unknown partition table
spitfire_data_access_exception: SFSR[0000000000801009] SFAR[fffffdff01af0590], going.
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
kworker/u4:2(391): Dax [#1]
CPU: 7 PID: 391 Comm: kworker/u4:2 Not tainted 3.19.0 #63
Workqueue: events_unbound async_run_entry_fn
task: fffff800fe3c20c0 ti: fffff800fc968000 task.ti: fffff800fc968000
TSTATE: 0000000080001602 TPC: 0000000000654b94 TNPC: 0000000000654b98 Y: 00000000    Not tainted
TPC: <kobject_init+0x14/0xa0>
g0: 0000000000000022 g1: 0000000080000000 g2: 0000000000000000 g3: 0000000000000001
g4: fffff800fe3c20c0 g5: fffff800fe316000 g6: fffff800fc968000 g7: 0000000000000017
o0: 0000000000000000 o1: fffff800fd4d3148 o2: 00000000009a5800 o3: 0000000000a15800
o4: fffff800f7ef28c0 o5: 0000000000000000 sp: fffff800fc96af51 ret_pc: 0000000000655dec
RPC: <kobject_uevent_env+0x4c/0x500>
l0: 0000000000000002 l1: fffff800fe03e8a0 l2: 00000000008992d8 l3: 0000000000000014
l4: 000000000122e950 l5: 0000000000a88000 l6: 0000000000000002 l7: 00000000017af400
i0: 00000dff01af0558 i1: 0000000000a36a90 i2: 0000000000000000 i3: 0000000000a364d0
i4: 00000000009a5f90 i5: fffff800fd4d3148 i6: fffff800fc96b001 i7: 0000000000643140
I7: <blk_mq_register_disk+0xe0/0x1a0>
Call Trace:
 [0000000000643140] blk_mq_register_disk+0xe0/0x1a0
 [0000000000638860] blk_register_queue+0xa0/0x120
 [0000000000646a3c] add_disk+0x33c/0x480
 [0000000000791aa8] sd_probe_async+0x148/0x180
 [000000000047d4dc] async_run_entry_fn+0x3c/0x100

-- 
Meelis Roos (mroos@linux.ee)
