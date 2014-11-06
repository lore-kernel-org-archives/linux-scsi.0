From: Christoph Hellwig <hch@infradead.org>
Subject: Re: blk_mq: suspicious RCU usage, rcu_read_lock() used illegally
 while idle!
Date: Thu, 6 Nov 2014 07:46:16 -0800
Message-ID: <20141106154616.GA25039@infradead.org>
References: <alpine.LRH.2.11.1411061654330.20750@siim2.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaKFPqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 10:46:17 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1411061654330.20750@siim2.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Without help from Paul I can't even make sense of the message..

On Thu, Nov 06, 2014 at 05:45:43PM +0200, Meelis Roos wrote:
> I tested a machine with multiple scsi adapters today with latest kernel 
> and found the following warning in the logs. It is probably from QLA1040 
> adapter initialization, full dmesg is below. Adaptec SCSI card dumps is 
> normal on this server, it is usually there and seems to be harmless 
> (maybe a supurious IRQ somewhere - but this should not be relevant).
> 
> The message is not there for scsi_mod.use_blk_mq=0 boot.
> 
> Booting 3.17.0 with scsi_mod.use_blk_mq=1 does not show this message 
> either.
> 
> [  188.275021] ===============================
> [  188.309351] [ INFO: suspicious RCU usage. ]
> [  188.343737] 3.18.0-rc3-00068-g20f3963-dirty #54 Not tainted
> [  188.394786] -------------------------------
> [  188.429170] include/linux/rcupdate.h:883 rcu_read_lock() used 
> illegally while idle!
> [  188.505235]
> other info that might help us debug this:
> 
> [  188.554230]
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 0
> [  188.637587] RCU used illegally from extended quiescent state!
> [  188.690684] 3 locks held by swapper/7/0:
> [  188.721932]  #0:  (&x->wait#11){......}, at: [<0000000000495de8>] complete+0x8/0x60
> [  188.797994]  #1:  (&p->pi_lock){-.-.-.}, at: [<000000000048510c>] try_to_wake_up+0xc/0x400
> [  188.881343]  #2:  (rcu_read_lock){......}, at: [<000000000048a910>] select_task_rq_fair+0x90/0xb40
> [  188.973043]stack backtrace:
> [  188.993879] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.18.0-rc3-00068-g20f3963-dirty #54
> [  189.076187] Call Trace:
> [  189.089719]  [0000000000499360] lockdep_rcu_suspicious+0xe0/0x100
> [  189.147035]  [000000000048a99c] select_task_rq_fair+0x11c/0xb40
> [  189.202253]  [00000000004852d8] try_to_wake_up+0x1d8/0x400
> [  189.252258]  [000000000048554c] default_wake_function+0xc/0x20
> [  189.306435]  [0000000000495554] __wake_up_common+0x34/0x80
> [  189.356448]  [00000000004955b4] __wake_up_locked+0x14/0x40
> [  189.406456]  [0000000000495e08] complete+0x28/0x60 
> [  189.448142]  [0000000000636e28] blk_end_sync_rq+0x8/0x20
> [  189.496057]  [0000000000639898] __blk_mq_end_request+0x18/0x60
> [  189.550249]  [00000000006ee014] scsi_end_request+0x94/0x180
> [  189.601286]  [00000000006ee334] scsi_io_completion+0x1d4/0x600
> [  189.655463]  [00000000006e51c4] scsi_finish_command+0xc4/0xe0
> [  189.708598]  [00000000006ed958] scsi_softirq_done+0x118/0x140
> [  189.761735]  [00000000006398ec] __blk_mq_complete_request_remote+0xc/0x20
> [  189.827383]  [00000000004c75d0] generic_smp_call_function_single_interrupt+0x150/0x1c0
> [  189.906581]  [000000000043e514] smp_call_function_single_client+0x14/0x40
> 
> 
> Full dmesg:
> 
> [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
> [    0.000000] PROMLIB: Root node compatible: 
> [    0.000000] Linux version 3.18.0-rc3-00068-g20f3963-dirty (mroos@korvits) (gcc version 4.9.1 (Debian 4.9.1-18) ) #54 SMP Thu Nov 6 14:37:34 EET 2014
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] bootconsole [earlyprom0] enabled
> [    0.000000] ARCH: SUN4U
> [    0.000000] Ethernet address: 08:00:20:b6:ee:e2
> [    0.000000] MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
> [    0.000000] MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
> [    0.000000] MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
> [    0.000000] Kernel: Using 6 locked TLB entries for main kernel image.
> [    0.000000] Remapping the kernel... done.
> [    0.000000] kmemleak: Kernel memory leak detector disabled
> [    0.000000] OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
> [    0.000000] PROM: Built device tree with 169763 bytes of memory.
> [    0.000000] Top of RAM: 0x7fcf2000, Total RAM: 0x7f8c0000
> [    0.000000] Memory hole size: 4MB
> [    0.000000] Allocated 2113536 bytes for kernel page tables.
> [    0.000000] Zone ranges:
> [    0.000000]   Normal   [mem 0x00000000-0x7fcf1fff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00000000-0x7f7ddfff]
> [    0.000000]   node   0: [mem 0x7fc00000-0x7fcd1fff]
> [    0.000000]   node   0: [mem 0x7fce2000-0x7fcf1fff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x7fcf1fff]
> [    0.000000] On node 0 totalpages: 261216
> [    0.000000]   Normal zone: 2301 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 261216 pages, LIFO batch:15
> [    0.000000] Booting Linux...
> [    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
> [    0.000000] CPU CAPS: [vis]
> [    0.000000] PERCPU: Embedded 7 pages/cpu @fffff8007f000000 s15808 r8192 d33344 u2097152
> [    0.000000] pcpu-alloc: s15808 r8192 d33344 u2097152 alloc=1*4194304
> [    0.000000] pcpu-alloc: [0] 6 7 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258915
> [    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
> [    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 262144 (order: 8, 2097152 bytes)
> [    0.000000] Inode-cache hash table entries: 131072 (order: 7, 1048576 bytes)
> [    0.000000] Sorting __ex_table...
> [    0.000000] Memory: 2037784K/2089728K available (4533K kernel code, 305K rwdata, 1504K rodata, 576K init, 14539K bss, 51944K reserved)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU lockdep checking is enabled.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
> [    0.000000] NR_IRQS:2048 nr_irqs:2048 1
> [  161.238391] clocksource: mult[2800000] shift[24]
> [  161.277473] clockevent: mult[66666666] shift[32]
> [  161.318721] Console: colour dummy device 80x25
> [  161.355382] console [tty0] enabled
> [  161.380218] bootconsole [earlyprom0] disabled
> [  161.416696] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [  161.416740] ... MAX_LOCKDEP_SUBCLASSES:  8
> [  161.416765] ... MAX_LOCK_DEPTH:          48
> [  161.416790] ... MAX_LOCKDEP_KEYS:        8191
> [  161.416816] ... CLASSHASH_SIZE:          4096
> [  161.416841] ... MAX_LOCKDEP_ENTRIES:     32768
> [  161.416867] ... MAX_LOCKDEP_CHAINS:      65536
> [  161.416892] ... CHAINHASH_SIZE:          32768
> [  161.416918]  memory used by lock dependency info: 8159 kB
> [  161.416949]  per task-struct memory footprint: 1920 bytes
> [  161.416978] ------------------------
> [  161.416999] | Locking API testsuite:
> [  161.417019] ----------------------------------------------------------------------------
> [  161.417061]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [  161.417104]   --------------------------------------------------------------------------
> [  161.417173]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.457494]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.495480]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.533653]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.571829]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.610241]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.648630]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.687043]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.724876]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.762661]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  161.800701]   --------------------------------------------------------------------------
> [  161.800747]               recursive read-lock:             |  ok  |             |  ok  |
> [  161.813409]            recursive read-lock #2:             |  ok  |             |  ok  |
> [  161.826070]             mixed read-write-lock:             |  ok  |             |  ok  |
> [  161.838756]             mixed write-read-lock:             |  ok  |             |  ok  |
> [  161.851441]   --------------------------------------------------------------------------
> [  161.851489]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [  161.870404]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [  161.889387]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [  161.908303]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [  161.927281]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [  161.946218]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [  161.965194]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [  161.984110]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [  162.003086]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [  162.022023]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [  162.041005]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [  162.060021]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [  162.079090]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [  162.098089]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [  162.117160]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [  162.136184]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [  162.155258]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [  162.174253]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [  162.193316]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [  162.212268]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [  162.231264]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [  162.250265]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [  162.269312]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [  162.288321]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [  162.307393]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [  162.326395]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [  162.345469]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [  162.364485]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [  162.383569]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [  162.402578]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [  162.421652]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [  162.440662]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [  162.459750]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [  162.478756]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [  162.497822]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [  162.516832]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [  162.535924]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [  162.554942]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [  162.574036]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [  162.593071]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [  162.612151]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [  162.631163]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [  162.650245]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [  162.669272]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [  162.688368]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [  162.707370]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [  162.726457]       hard-irq read-recursion/123:  ok  |
> [  162.732811]       soft-irq read-recursion/123:  ok  |
> [  162.739223]       hard-irq read-recursion/132:  ok  |
> [  162.745568]       soft-irq read-recursion/132:  ok  |
> [  162.751969]       hard-irq read-recursion/213:  ok  |
> [  162.758313]       soft-irq read-recursion/213:  ok  |
> [  162.764715]       hard-irq read-recursion/231:  ok  |
> [  162.771062]       soft-irq read-recursion/231:  ok  |
> [  162.777472]       hard-irq read-recursion/312:  ok  |
> [  162.783817]       soft-irq read-recursion/312:  ok  |
> [  162.790220]       hard-irq read-recursion/321:  ok  |
> [  162.796571]       soft-irq read-recursion/321:  ok  |
> [  162.802972]   --------------------------------------------------------------------------
> [  162.803016]   | Wound/wait tests |
> [  162.803039]   ---------------------
> [  162.803064]                   ww api failures:  ok  |  ok  |  ok  |
> [  162.822112]                ww contexts mixing:  ok  |  ok  |
> [  162.834785]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [  162.860095]                locking mismatches:  ok  |  ok  |  ok  |
> [  162.879128]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [  162.942686]            spinlock nest unlocked:  ok  |
> [  162.949005]   -----------------------------------------------------
> [  162.949044]                                  |block | try  |context|
> [  162.949082]   -----------------------------------------------------
> [  162.949121]                           context:  ok  |  ok  |  ok  |
> [  162.968211]                               try:  ok  |  ok  |  ok  |
> [  162.987181]                             block:  ok  |  ok  |  ok  |
> [  163.006186]                          spinlock:  ok  |  ok  |  ok  |
> [  163.025283] -------------------------------------------------------
> [  163.025322] Good, all 253 testcases passed! |
> [  163.025349] ---------------------------------
> [  163.027126] ODEBUG: selftest passed
> [  163.027345] kmemleak: Early log buffer exceeded (3329), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
> [  163.169263] Calibrating delay using timer specific routine.. 804.17 BogoMIPS (lpj=4020880)
> [  163.169341] pid_max: default: 32768 minimum: 301
> [  163.170354] Mount-cache hash table entries: 4096 (order: 2, 32768 bytes)
> [  163.170426] Mountpoint-cache hash table entries: 4096 (order: 2, 32768 bytes)
> [  163.191280] CPU 7: synchronized TICK with master CPU (last diff -8 cycles, maxerr 677 cycles)
> [  163.191904] Brought up 2 CPUs
> [  163.196096] devtmpfs: initialized
> [  163.199102] Performance events: No support for PMU type 'ultra12'
> [  163.282260] atomic64_test: passed
> [  163.284207] kworker/u4:0 (20) used greatest stack depth: 8216 bytes left
> [  163.300285] device-tree: Duplicate name in base, renamed to "fhc#1"
> [  163.307412] device-tree: Duplicate name in base, renamed to "counter-timer#1"
> [  163.312131] device-tree: Duplicate name in base, renamed to "fhc#2"
> [  163.314228] device-tree: Duplicate name in base, renamed to "counter-timer#2"
> [  163.318010] device-tree: Duplicate name in base, renamed to "counter-timer#3"
> [  163.323548] device-tree: Duplicate name in base, renamed to "fhc#3"
> [  163.325699] device-tree: Duplicate name in base, renamed to "counter-timer#4"
> [  163.330745] device-tree: Duplicate name in base, renamed to "counter-timer#5"
> [  163.333752] NET: Registered protocol family 16
> [  163.344321] kworker/u4:0 (31) used greatest stack depth: 7976 bytes left
> [  163.347152] kworker/u4:0 (34) used greatest stack depth: 7896 bytes left
> [  163.390763] SYSIO: UPA portID ffffffff, at 000001c400000000
> [  163.400388] SYSIO: UPA portID ffffffff, at 000001c600000000
> [  163.410018] SYSIO: UPA portID ffffffff, at 000001d400000000
> [  163.420198] SYSIO: UPA portID ffffffff, at 000001d600000000
> [  163.439052] /pci@e,4000: PCI IO[1dc02010000] MEM[1dd80000000]
> [  163.439288] /pci@e,4000: PSYCHO PCI Bus Module ver[4:0]
> [  163.439377] PCI: Scanning PBM /pci@e,4000
> [  163.440634] psycho f01bf7bc: PCI host bridge to bus 0000:00
> [  163.440713] pci_bus 0000:00: root bus resource [io  0x1dc02010000-0x1dc0201ffff] (bus address [0x0000-0xffff])
> [  163.440818] pci_bus 0000:00: root bus resource [mem 0x1dd80000000-0x1ddffffffff] (bus address [0x00000000-0x7fffffff])
> [  163.440929] pci_bus 0000:00: root bus resource [bus 00]
> [  163.445838] /pci@e,2000: PCI IO[1dc02000000] MEM[1dd00000000]
> [  163.445927] /pci@e,2000: PSYCHO PCI Bus Module ver[4:0]
> [  163.445984] PCI: Scanning PBM /pci@e,2000
> [  163.446800] psycho f01c88e0: PCI host bridge to bus 0001:80
> [  163.446876] pci_bus 0001:80: root bus resource [io  0x1dc02000000-0x1dc0200ffff] (bus address [0x0000-0xffff])
> [  163.446983] pci_bus 0001:80: root bus resource [mem 0x1dd00000000-0x1dd7fffffff] (bus address [0x00000000-0x7fffffff])
> [  163.447088] pci_bus 0001:80: root bus resource [bus 80]
> [  163.457405] /pci@f,4000: PCI IO[1de02010000] MEM[1df80000000]
> [  163.457494] /pci@f,4000: PSYCHO PCI Bus Module ver[4:0]
> [  163.457549] PCI: Scanning PBM /pci@f,4000
> [  163.458367] psycho f01ca118: PCI host bridge to bus 0002:00
> [  163.458443] pci_bus 0002:00: root bus resource [io  0x1de02010000-0x1de0201ffff] (bus address [0x0000-0xffff])
> [  163.458547] pci_bus 0002:00: root bus resource [mem 0x1df80000000-0x1dfffffffff] (bus address [0x00000000-0x7fffffff])
> [  163.458653] pci_bus 0002:00: root bus resource [bus 00]
> [  163.461719] /pci@f,2000: PCI IO[1de02000000] MEM[1df00000000]
> [  163.461804] /pci@f,2000: PSYCHO PCI Bus Module ver[4:0]
> [  163.461859] PCI: Scanning PBM /pci@f,2000
> [  163.462668] psycho f01d320c: PCI host bridge to bus 0003:80
> [  163.462743] pci_bus 0003:80: root bus resource [io  0x1de02000000-0x1de0200ffff] (bus address [0x0000-0xffff])
> [  163.462855] pci_bus 0003:80: root bus resource [mem 0x1df00000000-0x1df7fffffff] (bus address [0x00000000-0x7fffffff])
> [  163.462964] pci_bus 0003:80: root bus resource [bus 80]
> [  163.580345] vgaarb: loaded
> [  163.584298] SCSI subsystem initialized
> [  163.592449] /central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
> [  163.595898] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
> [  163.596622] fhc: Board #3, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
> [  163.597384] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
> [  163.598197] fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] 
> [  163.598978] fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
> [  163.600178] clock_board: Detected 5 slot Enterprise system.
> [  163.690823] DMA-API: preallocated 32768 debug entries
> [  163.690902] DMA-API: debugging enabled by kernel config
> [  163.693159] Switched to clocksource tick
> [  163.703829] kworker/u4:0 (280) used greatest stack depth: 7752 bytes left
> [  163.754938] NET: Registered protocol family 2
> [  163.757716] TCP established hash table entries: 16384 (order: 4, 131072 bytes)
> [  163.758687] TCP bind hash table entries: 16384 (order: 7, 1048576 bytes)
> [  163.768861] TCP: Hash tables configured (established 16384 bind 16384)
> [  163.769822] TCP: reno registered
> [  163.769975] UDP hash table entries: 1024 (order: 4, 163840 bytes)
> [  163.771566] UDP-Lite hash table entries: 1024 (order: 4, 163840 bytes)
> [  163.775400] NET: Registered protocol family 1
> [  163.775741] PCI: CLS 0 bytes, default 64
> [  163.784319] futex hash table entries: 512 (order: 3, 65536 bytes)
> [  163.784865] ====[ backtrace testing ]===========
> [  163.784908] Testing a backtrace from process context.
> [  163.784952] The following trace is a kernel self test and not a bug!
> [  163.785015] CPU: 6 PID: 1 Comm: swapper/6 Not tainted 3.18.0-rc3-00068-g20f3963-dirty #54
> [  163.785076] Call Trace:
> [  163.785122]  [00000000004cd80c] backtrace_regression_test+0x2c/0x100
> [  163.785183]  [0000000000426ea4] do_one_initcall+0xe4/0x1e0
> [  163.785250]  [0000000000a40b44] kernel_init_freeable+0x120/0x1d0
> [  163.785326]  [0000000000865a84] kernel_init+0x4/0x100
> [  163.785389]  [0000000000406104] ret_from_fork+0x1c/0x2c
> [  163.785436]  [0000000000000000]           (null)
> [  163.785477] Testing a backtrace from irq context.
> [  163.785519] The following trace is a kernel self test and not a bug!
> [  163.786004] CPU: 6 PID: 3 Comm: ksoftirqd/6 Not tainted 3.18.0-rc3-00068-g20f3963-dirty #54
> [  163.786068] Call Trace:
> [  163.786116]  [00000000004cd7c4] backtrace_test_irq_callback+0x4/0x20
> [  163.786183]  [000000000045f278] tasklet_action+0x98/0x120
> [  163.786238]  [000000000045f3f0] __do_softirq+0xf0/0x240
> [  163.786294]  [000000000045f568] run_ksoftirqd+0x28/0x80
> [  163.786373]  [000000000047e3e4] smpboot_thread_fn+0x244/0x280
> [  163.786440]  [0000000000479ef0] kthread+0xb0/0xe0
> [  163.786496]  [0000000000406104] ret_from_fork+0x1c/0x2c
> [  163.786546]  [0000000000000000]           (null)
> [  163.786707] Testing a saved backtrace.
> [  163.786753] The following trace is a kernel self test and not a bug!
> [  163.786810]  [<00000000004cd8a8>] backtrace_regression_test+0xc8/0x100
> [  163.786888]  [<0000000000426ea4>] do_one_initcall+0xe4/0x1e0
> [  163.786952]  [<0000000000a40b44>] kernel_init_freeable+0x120/0x1d0
> [  163.787022]  [<0000000000865a84>] kernel_init+0x4/0x100
> [  163.787088]  [<0000000000406104>] ret_from_fork+0x1c/0x2c
> [  163.787153]  [<          (null)>]           (null)
> [  163.787207] ====[ end of backtrace testing ]====
> [  163.787332] audit: initializing netlink subsys (disabled)
> [  163.787886] audit: type=2000 audit(2.050:1): initialized
> [  163.791649] HugeTLB registered 8 MB page size, pre-allocated 0 pages
> [  163.797716] msgmni has been set to 3980
> [  163.803398] io scheduler noop registered
> [  163.803651] io scheduler cfq registered (default)
> [  163.803717] start plist test
> [  163.826582] end plist test
> [  163.831561] test_string_helpers: Running tests...
> [  164.044577] zs f005de3c: ttyS0 at MMIO 0x1fff8902000 (irq = 2, base_baud = 307200) is a zs (ESCC)
> [  164.044724] Console: ttyS0 (SunZilog zs0)
> [  179.468351] console [ttyS0] enabled
> [  179.496405] zs f005de3c: ttyS1 at MMIO 0x1fff8902004 (irq = 2, base_baud = 307200) is a zs (ESCC)
> [  179.795321] f005df14: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
> [  179.855846] f005df14: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
> [  179.954009] loop: module loaded
> [  179.975578] PCI: Enabling device: (0003:80:02.0), cmd 3
> [  185.152853] scsi0: Missing case in ahd_handle_scsiint. status = 0
> [  185.208135] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x0 Mode 0x33
> [  185.334228] Card was paused
> [  185.351888] INTSTAT[0x8]:(SCSIINT) SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
> [  185.418562] INTCTL[0x0] SEQINTSTAT[0x0] SAVED_MODE[0x25] DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE) 
> [  185.519625] SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0] 
> [  185.577970] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) SCSISEQ0[0x0] 
> [  185.633186] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) SEQCTL0[0x0] SEQINTCTL[0x0] 
> [  185.701952] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] QFREEZE_COUNT[0x0] 
> [  185.756130] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff] 
> [  185.834268] SSTAT0[0x0] SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] 
> [  185.900952] SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) LQISTAT0[0x0] 
> [  185.966586] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] 
> [  186.027015] LQOSTAT2[0x0] 
> [  186.043701] 
> SCB Count = 8 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
> [  186.119786] qinstart = 0 qinfifonext = 0
> QINFIFO:
> WAITING_TID_QUEUES:
> [  186.183326] Pending list:
> Total 0
> [  186.208314] Kernel Free SCB list: 7 6 5 4 3 2 1 0 
> [  186.249973] Sequencer Complete DMA-inprog list: 
> [  186.289562] Sequencer Complete list: 
> [  186.317694] Sequencer DMA-Up and Complete list: 
> [  186.357284] Sequencer On QFreeze and Complete list: 
> [  186.401059] 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x803b, SCB 0x0
> [  186.454230] SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
> [  186.544821] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
> [  186.622965] SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
> [  186.689642] SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
> [  186.766758] HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x80bc, SCB 0x0
> [  186.878272] SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
> [  186.968863] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
> [  187.047006] SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
> [  187.113688] SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
> [  187.190796] HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> [  187.342907] scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> [  187.403351] scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> [  187.449192] scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> 
> [  187.496052] SIMODE0[0x6c]:(ENOVERRUN|ENIOERR|ENSELDI|ENSELDO) 
> [  187.550231] CCSCBCTL[0x0] 
> [  187.566913] scsi0: REG0 == 0x45d1, SINDEX = 0x0, DINDEX = 0x0
> [  187.620062] scsi0: SCBPTR == 0x1ff, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
> [  187.684665] CDB ff 1 0 0 0 0
> [  187.703390] STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> [  187.806958] scsi host0: Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
>         <Adaptec 29320ALP PCIx Ultra320 SCSI adapter>
>         aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66MHz, 512 SCBs
> [  188.016407] qla1280: QLA1040 found on PCI bus 0, dev 3
> [  188.060231] PCI: Enabling device: (0002:00:03.0), cmd 7
> 
> [  188.275021] ===============================
> [  188.309351] [ INFO: suspicious RCU usage. ]
> [  188.343737] 3.18.0-rc3-00068-g20f3963-dirty #54 Not tainted
> [  188.394786] -------------------------------
> [  188.429170] include/linux/rcupdate.h:883 rcu_read_lock() used illegally while idle!
> [  188.505235] 
> other info that might help us debug this:
> 
> [  188.554230] 
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 0
> [  188.637587] RCU used illegally from extended quiescent state!
> [  188.690684] 3 locks held by swapper/7/0:
> [  188.721932]  #0:  (&x->wait#11){......}, at: [<0000000000495de8>] complete+0x8/0x60
> [  188.797994]  #1:  (&p->pi_lock){-.-.-.}, at: [<000000000048510c>] try_to_wake_up+0xc/0x400
> [  188.881343]  #2:  (rcu_read_lock){......}, at: [<000000000048a910>] select_task_rq_fair+0x90/0xb40
> [  188.973043] 
> stack backtrace:
> [  188.993879] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.18.0-rc3-00068-g20f3963-dirty #54
> [  189.076187] Call Trace:
> [  189.089719]  [0000000000499360] lockdep_rcu_suspicious+0xe0/0x100
> [  189.147035]  [000000000048a99c] select_task_rq_fair+0x11c/0xb40
> [  189.202253]  [00000000004852d8] try_to_wake_up+0x1d8/0x400
> [  189.252258]  [000000000048554c] default_wake_function+0xc/0x20
> [  189.306435]  [0000000000495554] __wake_up_common+0x34/0x80
> [  189.356448]  [00000000004955b4] __wake_up_locked+0x14/0x40
> [  189.406456]  [0000000000495e08] complete+0x28/0x60
> [  189.448142]  [0000000000636e28] blk_end_sync_rq+0x8/0x20
> [  189.496057]  [0000000000639898] __blk_mq_end_request+0x18/0x60
> [  189.550249]  [00000000006ee014] scsi_end_request+0x94/0x180
> [  189.601286]  [00000000006ee334] scsi_io_completion+0x1d4/0x600
> [  189.655463]  [00000000006e51c4] scsi_finish_command+0xc4/0xe0
> [  189.708598]  [00000000006ed958] scsi_softirq_done+0x118/0x140
> [  189.761735]  [00000000006398ec] __blk_mq_complete_request_remote+0xc/0x20
> [  189.827383]  [00000000004c75d0] generic_smp_call_function_single_interrupt+0x150/0x1c0
> [  189.906581]  [000000000043e514] smp_call_function_single_client+0x14/0x40
> [  190.269728] random: nonblocking pool is initialized
> [  190.828808] scsi(1:0): Resetting SCSI BUS
> [  193.862671] scsi host1: QLogic QLA1040 PCI to SCSI Host Adapter
>        Firmware version:  7.65.06, Driver version 3.27.1
> [  193.976290] blk-mq: reduced tag depth to 10240
> [  194.037930] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.16-k.
> [  194.118405] PCI: Enabling device: (0001:80:02.0), cmd 3
> [  194.165280] qla2xxx [0001:80:02.0]-001d: : Found an ISP2200 irq 49 iobase 0x000001dd00002000.
> [  194.353211] qla2xxx 0001:80:02.0: Direct firmware load for ql2200_fw.bin failed with error -2
> [  194.437839] qla2xxx 0001:80:02.0: Falling back to user helper
> [  194.491932] scsi 1:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
> [  194.573022] scsi(1:0:2:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
> [  194.823272] scsi 1:0:4:0: Direct-Access     IBM      DDYS-T18350M     S80D PQ: 0 ANSI: 3
> [  194.903416] scsi(1:0:4:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
> [  195.662569] scsi 1:0:10:0: Direct-Access     HP       9.10GB A 80-6331      PQ: 0 ANSI: 2
> [  195.743713] scsi(1:0:10:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
> [  195.830214] scsi 1:0:11:0: Direct-Access     IBM      DDRS-34560D      DC1B PQ: 0 ANSI: 2
> [  195.911336] scsi(1:0:11:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
> [  196.006929] scsi 1:0:12:0: Direct-Access     HP       4.26GB A 80-0430 0430 PQ: 0 ANSI: 2
> [  196.087903] scsi(1:0:12:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
> [  196.187208] scsi 1:0:13:0: Direct-Access     HP       2.13GB A 80-0430 0430 PQ: 0 ANSI: 2
> [  196.268525] scsi(1:0:13:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
> [  254.692919] qla2xxx [0001:80:02.0]-0063:2: Failed to load firmware image (ql2200_fw.bin).
> [  254.773218] qla2xxx [0001:80:02.0]-0083:2: Fimware image unavailable.
> [  254.834679] qla2xxx [0001:80:02.0]-0084:2: Firmware images can be retrieved from: http://ldriver.qlogic.com/firmware/.
> [  254.947216] qla2xxx [0001:80:02.0]-00cf:2: Setup chip ****FAILED****.
> [  255.008657] qla2xxx [0001:80:02.0]-00d6:2: Failed to initialize adapter - Adapter flags 2.
> [  255.097006] sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
> [  255.170460] eth0: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
> [  255.235445] sd 1:0:4:0: [sdb] 35843670 512-byte logical blocks: (18.3 GB/17.0 GiB)
> [  255.237573] eth1: Quattro HME slot 0 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:94
> [  255.239977] eth2: Quattro HME slot 1 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:95
> [  255.242388] eth3: Quattro HME slot 2 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:96
> [  255.244859] eth4: Quattro HME slot 3 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:97
> [  255.247283] eth5: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
> [  255.247840] PCI: Enabling device: (0000:00:01.1), cmd 2
> [  255.250196] eth6: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:b6:ee:e2
> [  255.251312] sd 1:0:2:0: [sda] 35843670 512-byte logical blocks: (18.3 GB/17.0 GiB)
> [  255.310326] sd 1:0:2:0: [sda] Write Protect is off
> [  255.310343] sd 1:0:2:0: [sda] Mode Sense: cb 00 00 08
> [  255.310591] sd 1:0:10:0: [sdc] 17773524 512-byte logical blocks: (9.10 GB/8.47 GiB)
> [  255.310697] sd 1:0:11:0: [sdd] 8925000 512-byte logical blocks: (4.56 GB/4.25 GiB)
> [  255.311960] mousedev: PS/2 mouse device common for all mice
> [  255.315824] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
> [  255.317082] TCP: cubic registered
> [  255.317108] NET: Registered protocol family 17
> [  255.318580] registered taskstats version 1
> [  255.385635] sd 1:0:12:0: [sde] 8330543 512-byte logical blocks: (4.26 GB/3.97 GiB)
> [  255.385792] sd 1:0:10:0: [sdc] Write Protect is off
> [  255.385809] sd 1:0:10:0: [sdc] Mode Sense: 9f 00 10 08
> [  255.385905] sd 1:0:11:0: [sdd] Write Protect is off
> [  255.385921] sd 1:0:11:0: [sdd] Mode Sense: b9 00 00 08
> [  255.460208] rtc-m48t59 rtc-m48t59.0: setting system clock to 2014-11-06 14:44:49 UTC (1415285089)
> [  255.460593] sd 1:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  255.460897] sd 1:0:12:0: [sde] Write Protect is off
> [  255.460913] sd 1:0:12:0: [sde] Mode Sense: 9f 00 10 08
> [  255.535967] sd 1:0:10:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
> [  255.536140] sd 1:0:13:0: [sdf] 4165272 512-byte logical blocks: (2.13 GB/1.98 GiB)
> [  255.536319] sd 1:0:11:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  255.611389] sd 1:0:12:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
> [  255.611526] sd 1:0:13:0: [sdf] Write Protect is off
> [  255.611542] sd 1:0:13:0: [sdf] Mode Sense: 9f 00 10 08
> [  255.724337] sd 1:0:13:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
> [  255.960802]  sda: sda1 sda2 sda3 sda4
> [  256.036886]  sdd: unknown partition table
> [  256.038024]  sdc: unknown partition table
> [  256.161971]  sde: unknown partition table
> [  256.226521]  sdf: unknown partition table
> [  256.287571] sd 1:0:2:0: [sda] Attached SCSI disk
> [  256.320837] sd 1:0:11:0: [sdd] Attached SCSI disk
> [  256.321195] sd 1:0:10:0: [sdc] Attached SCSI disk
> [  256.438589] sd 1:0:12:0: [sde] Attached SCSI disk
> [  256.484470] sd 1:0:13:0: [sdf] Attached SCSI disk
> [  257.730003] sd 1:0:4:0: [sdb] Write Protect is off
> [  257.769724] sd 1:0:4:0: [sdb] Mode Sense: cb 00 00 08
> [  257.816196] sd 1:0:4:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  257.932380]  sdb: unknown partition table
> [  257.967850] sd 1:0:4:0: [sdb] Attached SCSI disk
> [  258.009691] EXT4-fs (sda2): mounting ext3 file system using the ext4 subsystem
> [  258.103029] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> [  258.177139] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
> [  258.268770] devtmpfs: mounted
> [  259.504165] stty (523) used greatest stack depth: 5544 bytes left
> [  261.465793] systemd-udevd[610]: starting version 215
> [  262.297628] hme f009fba8 eth7: renamed from eth2
> [  262.430354] systemd-udevd[634]: renamed network interface eth2 to eth7
> [  262.430471] hme f0099bf4 eth9: renamed from eth1
> [  262.553566] systemd-udevd[648]: renamed network interface eth1 to eth9
> [  262.633511] hme f008d070 eth1: renamed from eth0
> [  262.697674] hwclock (658) used greatest stack depth: 4168 bytes left
> [  262.773763] hme f00ab960 eth8: renamed from eth4
> [  262.873209] systemd-udevd[635]: renamed network interface eth0 to eth1
> [  262.918444] hme 0000:00:01.1 eth0: renamed from eth6
> [  262.918716] systemd-udevd[640]: renamed network interface eth4 to eth8
> [  263.053804] systemd-udevd[643]: renamed network interface eth6 to eth0
> [  263.114350] hme f01673a8 eth2: renamed from eth5
> [  263.192734] hme f00a5a84 eth10: renamed from eth3
> [  263.238837] systemd-udevd[641]: renamed network interface eth5 to eth2
> [  263.355961] systemd-udevd[639]: renamed network interface eth3 to eth10
> [  267.436399] Adding 787176k swap on /dev/sda4.  Priority:-1 extents:1 across:787176k 
> [  267.775195] EXT4-fs (sda2): re-mounted. Opts: (null)
> [  268.309702] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
> [  272.239364] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
> [  272.321644] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [  280.082651] eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.
> [  284.153738] basename (1686) used greatest stack depth: 3752 bytes left
> 
> -- 
> Meelis Roos (mroos@linux.ee)
---end quoted text---
