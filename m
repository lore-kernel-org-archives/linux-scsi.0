From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [BUG] Unable to handle kernel NULL pointer dereference...as_move_to_dispatch+0x11/0x135
Date: Mon, 22 Jan 2007 10:35:10 -0800
Message-ID: <20070122183510.GA19905@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="i9LlY+UWpKt15+FH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:36341 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbXAVSfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 13:35:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Nigel Kirkland <nigel.kirkland@qlogic.com>


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

All,

We've been trying to track down a nagging regression  seen during some
port-disable/enable testing.  The problem occurs anywhere from
20 minutes to 120 minutes of testing under very minimal I/O load:

	[ 1143.890598] Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP: 
	[ 1143.896087]  [<ffffffff802ed04f>] as_move_to_dispatch+0x11/0x135
	[ 1143.904574] PGD 120ba067 PUD 31e8c067 PMD 0 
	[ 1143.908895] Oops: 0000 [1] SMP 
	[ 1143.912065] CPU 1 
	[ 1143.914092] Modules linked in: qla2xxx scsi_transport_fc
	[ 1143.919453] Pid: 8362, comm: dt Not tainted 2.6.19 #39
	[ 1143.924588] RIP: 0010:[<ffffffff802ed04f>]  [<ffffffff802ed04f>] as_move_to_dispatch+0x11/0x135
	[ 1143.933300] RSP: 0018:ffff8100021f7cf0  EFLAGS: 00010046
	[ 1143.938610] RAX: 0000000000000000 RBX: ffff8100261392f0 RCX: 0000000000000000
	[ 1143.945736] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8100261392f0
	[ 1143.952865] RBP: 0000000000000000 R08: ffffffff804d0928 R09: ffff8100351a96e0
	[ 1143.959992] R10: ffff8100351a96e0 R11: 0000000000000000 R12: 0000000000000000
	[ 1143.967118] R13: 0000000000000000 R14: 0000000000000282 R15: 0000000000000001
	[ 1143.974248] FS:  0000000000000000(0000) GS:ffff8100021c5930(0000) knlGS:0000000000000000
	[ 1143.982327] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
	[ 1143.988070] CR2: 0000000000000028 CR3: 000000003493b000 CR4: 00000000000006e0
	[ 1143.995198] Process dt (pid: 8362, threadinfo ffff8100207a2000, task ffff810023d86840)
	[ 1144.003103] Stack:  0000000000000000 ffff8100261392f0 0000000000000000 0000000000000001
	[ 1144.011183]  0000000000000000 ffffffff802ed591 0000000000000000 ffff810035795990
	[ 1144.018640]  ffff81000f11b3f8 ffff810035795990 ffff810035795990 ffffffff802e53d6
	[ 1144.025906] Call Trace:
	[ 1144.028548]  <IRQ>  [<ffffffff802ed591>] as_dispatch_request+0x39d/0x3aa
	[ 1144.035274]  [<ffffffff802e53d6>] elv_next_request+0x45/0x151
	[ 1144.041015]  [<ffffffff8037b3cf>] scsi_request_fn+0x7a/0x375
	[ 1144.046667]  [<ffffffff802e8fa0>] blk_run_queue+0x42/0x74
	[ 1144.052062]  [<ffffffff8037b2bc>] scsi_next_command+0x2d/0x39
	[ 1144.057805]  [<ffffffff8037b85b>] scsi_end_request+0xc0/0xce
	[ 1144.063460]  [<ffffffff8037ba03>] scsi_io_completion+0x149/0x351
	[ 1144.069464]  [<ffffffff8038aad6>] sd_rw_intr+0x247/0x256
	[ 1144.074770]  [<ffffffff80376b92>] scsi_finish_command+0x88/0x8d
	[ 1144.080686]  [<ffffffff8037c25e>] scsi_softirq_done+0xe7/0xef
	[ 1144.086429]  [<ffffffff802e614c>] blk_done_softirq+0x63/0x71
	[ 1144.092082]  [<ffffffff80226487>] __do_softirq+0x51/0xbd
	[ 1144.097394]  [<ffffffff8020a88c>] call_softirq+0x1c/0x28
	[ 1144.102701]  [<ffffffff8020bffa>] do_softirq+0x2e/0x94
	[ 1144.107836]  [<ffffffff8020c10e>] do_IRQ+0xae/0xc8
	[ 1144.112625]  [<ffffffff80209c81>] ret_from_intr+0x0/0xb
	[ 1144.117845]  <EOI>  [<ffffffff8027dfad>] __bio_add_page+0x1b8/0x1bf
	[ 1144.124135]  [<ffffffff8027ecb6>] blkdev_direct_IO+0x2c9/0x420
	[ 1144.129964]  [<ffffffff8021a1f4>] __activate_task+0x2d/0x3f
	[ 1144.135537]  [<ffffffff8040df0d>] _spin_unlock_irq+0x6/0x9
	[ 1144.141024]  [<ffffffff80241d86>] generic_file_direct_IO+0xa6/0xe8
	[ 1144.147196]  [<ffffffff80219efe>] __wake_up_common+0x42/0x6c
	[ 1144.152852]  [<ffffffff80242515>] generic_file_aio_read+0xcc/0x19d
	[ 1144.159029]  [<ffffffff8025d7cd>] do_sync_read+0xc8/0x10b
	[ 1144.164426]  [<ffffffff8023343c>] autoremove_wake_function+0x0/0x2e
	[ 1144.170684]  [<ffffffff8040df0d>] _spin_unlock_irq+0x6/0x9
	[ 1144.176166]  [<ffffffff8025c516>] do_filp_open+0x2d/0x3d
	[ 1144.181480]  [<ffffffff80259876>] poison_obj+0x35/0x44
	[ 1144.186620]  [<ffffffff8025e1c0>] vfs_read+0xac/0x14f
	[ 1144.191668]  [<ffffffff8025e322>] sys_read+0x45/0x6e
	[ 1144.196630]  [<ffffffff8020976e>] system_call+0x7e/0x83
	[ 1144.201852] 
	[ 1144.203348] 
	[ 1144.203349] Code: 8b 46 28 48 8b 56 78 25 01 80 00 00 83 f8 01 48 8d 46 78 41 
	[ 1144.212416] RIP  [<ffffffff802ed04f>] as_move_to_dispatch+0x11/0x135
	[ 1144.218783]  RSP <ffff8100021f7cf0>
	[ 1144.222272] CR2: 0000000000000028
	[ 1144.225866]  <3>BUG: sleeping function called from invalid context at kernel/rwsem.c:20
	[ 1144.233878] in_atomic():1, irqs_disabled():1
	[ 1144.238147] 
	[ 1144.238148] Call Trace:
	[ 1144.242088]  <IRQ>  [<ffffffff8021ae13>] __might_sleep+0xba/0xbc
	[ 1144.248109]  [<ffffffff80235c33>] down_read+0x15/0x1e
	[ 1144.253163]  [<ffffffff8022e430>] blocking_notifier_call_chain+0x13/0x36
	[ 1144.259864]  [<ffffffff802247af>] do_exit+0x22/0x843
	[ 1144.264823]  [<ffffffff80219259>] do_page_fault+0x708/0x775
	[ 1144.270394]  [<ffffffff8021433a>] smp_local_timer_interrupt+0x32/0x53
	[ 1144.276826]  [<ffffffff802143b0>] smp_apic_timer_interrupt+0x55/0x68
	[ 1144.283174]  [<ffffffff8020a336>] apic_timer_interrupt+0x66/0x70
	[ 1144.289178]  [<ffffffff8040e12d>] error_exit+0x0/0x84
	[ 1144.294226]  [<ffffffff802ed04f>] as_move_to_dispatch+0x11/0x135
	[ 1144.300227]  [<ffffffff802ed591>] as_dispatch_request+0x39d/0x3aa
	[ 1144.306315]  [<ffffffff802e53d6>] elv_next_request+0x45/0x151
	[ 1144.312058]  [<ffffffff8037b3cf>] scsi_request_fn+0x7a/0x375
	[ 1144.317713]  [<ffffffff802e8fa0>] blk_run_queue+0x42/0x74
	[ 1144.323108]  [<ffffffff8037b2bc>] scsi_next_command+0x2d/0x39
	[ 1144.328850]  [<ffffffff8037b85b>] scsi_end_request+0xc0/0xce
	[ 1144.334505]  [<ffffffff8037ba03>] scsi_io_completion+0x149/0x351
	[ 1144.340507]  [<ffffffff8038aad6>] sd_rw_intr+0x247/0x256
	[ 1144.345815]  [<ffffffff80376b92>] scsi_finish_command+0x88/0x8d
	[ 1144.351730]  [<ffffffff8037c25e>] scsi_softirq_done+0xe7/0xef
	[ 1144.357474]  [<ffffffff802e614c>] blk_done_softirq+0x63/0x71
	[ 1144.363127]  [<ffffffff80226487>] __do_softirq+0x51/0xbd
	[ 1144.368437]  [<ffffffff8020a88c>] call_softirq+0x1c/0x28
	[ 1144.373745]  [<ffffffff8020bffa>] do_softirq+0x2e/0x94
	[ 1144.378880]  [<ffffffff8020c10e>] do_IRQ+0xae/0xc8
	[ 1144.383669]  [<ffffffff80209c81>] ret_from_intr+0x0/0xb
	[ 1144.388890]  <EOI>  [<ffffffff8027dfad>] __bio_add_page+0x1b8/0x1bf
	[ 1144.395170]  [<ffffffff8027ecb6>] blkdev_direct_IO+0x2c9/0x420
	[ 1144.401001]  [<ffffffff8021a1f4>] __activate_task+0x2d/0x3f
	[ 1144.406569]  [<ffffffff8040df0d>] _spin_unlock_irq+0x6/0x9
	[ 1144.412051]  [<ffffffff80241d86>] generic_file_direct_IO+0xa6/0xe8
	[ 1144.418224]  [<ffffffff80219efe>] __wake_up_common+0x42/0x6c
	[ 1144.423881]  [<ffffffff80242515>] generic_file_aio_read+0xcc/0x19d
	[ 1144.430056]  [<ffffffff8025d7cd>] do_sync_read+0xc8/0x10b
	[ 1144.435451]  [<ffffffff8023343c>] autoremove_wake_function+0x0/0x2e
	[ 1144.441713]  [<ffffffff8040df0d>] _spin_unlock_irq+0x6/0x9
	[ 1144.447194]  [<ffffffff8025c516>] do_filp_open+0x2d/0x3d
	[ 1144.452503]  [<ffffffff80259876>] poison_obj+0x35/0x44
	[ 1144.457639]  [<ffffffff8025e1c0>] vfs_read+0xac/0x14f
	[ 1144.462688]  [<ffffffff8025e322>] sys_read+0x45/0x6e
	[ 1144.467650]  [<ffffffff8020976e>] system_call+0x7e/0x83
	[ 1144.472870] 
	[ 1144.474364] Kernel panic - not syncing: Aiee, killing interrupt handler!

Basically what is happening from the FC side is the initiator executes
a simple dt test:

        dt of=/dev/raw/raw1 procs=8 oncerr=abort bs=16k disable=stats limit=2m passes=1000000 pattern=iot dlimit=2048

against a single lun (a very basic Windows target mode driver).
During the test a port-enable, port-disable script is running agains
the switch's port that is connected to the target (this occurs every
sixty seconds (for a disabled duration of 2 seconds).  Additionally,
the target itself is set to LOGO (logout) or drop off the topology
every 30 seconds.

This test runs fine up to 2.6.19.  Breakage appears to have been introduced in
2.6.20-rc1 (our firmware-engineer noticed the problem in 2.6.20-rc4).
Unfortunately our efforts a basic bisections have been fruitless as according
to git-bisect the bad commit is:

	commit 029530f810dd5147f7e59b939eb22cfbe0beea12
	Author: Adrian Bunk <bunk@stusta.de>
	Date:   Wed Dec 13 00:35:16 2006 -0800

	    [PATCH] one more EXPORT_UNUSED_SYMBOL removal

	    Signed-off-by: Adrian Bunk <bunk@stusta.de>
	    Signed-off-by: Andrew Morton <akpm@osdl.org>
	    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

which doesn't make much sense...  Here's the log...

	$ git bisect log
	git-bisect start
	# good: [c3fe6924620fd733ffe8bc8a9da1e9cde08402b3] Linux 2.6.19
	git-bisect good c3fe6924620fd733ffe8bc8a9da1e9cde08402b3
	# bad: [cc016448b0bf0764928275d034e367753bde8162] Linux v2.6.20-rc1
	git-bisect bad cc016448b0bf0764928275d034e367753bde8162
	# good: [b2c03941b50944a268ee4d5823872f220809a3ba] IPMI: Allow hot system interface remove
	git-bisect good b2c03941b50944a268ee4d5823872f220809a3ba
	# good: [de1ba09b214056365d9082982905b255caafb7a2] fault injection: documentation and scripts
	git-bisect good de1ba09b214056365d9082982905b255caafb7a2
	# good: [116140b7f5c9182c86a4e419f81684209357aea7] Merge branch 'upstream-linus' of master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6
	git-bisect good 116140b7f5c9182c86a4e419f81684209357aea7
	# good: [775ba7ad491a154f99871fe603f03366e84ae159] Merge git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial
	git-bisect good 775ba7ad491a154f99871fe603f03366e84ae159
	# good: [69688262fb94e92a32f188b79c02dc32016d4927] update Tigran's email addresses
	git-bisect good 69688262fb94e92a32f188b79c02dc32016d4927
	# bad: [5faad620264290b17e80a8b0996b039ea0d5ac73] Merge branch 'for-linus' of git://brick.kernel.dk/data/git/linux-2.6-block
	git-bisect bad 5faad620264290b17e80a8b0996b039ea0d5ac73
	# bad: [3161986224a3faa8ccca3e665b7404d81e7ee3cf] fbdev: remove references to non-existent fbmon_valid_timings()
	git-bisect bad 3161986224a3faa8ccca3e665b7404d81e7ee3cf
	# bad: [c954e2a5d1c9662991a41282297ddebcadee0578] knfsd: nfsd4: make verify and nverify wrappers
	git-bisect bad c954e2a5d1c9662991a41282297ddebcadee0578
	# bad: [021d3a72459191a76e8e482ee4937ba6bc9fd712] knfsd: nfsd4: handling more nfsd_cross_mnt errors in nfsd4 readdir
	git-bisect bad 021d3a72459191a76e8e482ee4937ba6bc9fd712
	# bad: [b797b5beac966df5c5d96c0d39fe366f57135343] knfsd: svcrpc: fix gss krb5i memory leak
	git-bisect bad b797b5beac966df5c5d96c0d39fe366f57135343
	# bad: [b21a323710e77a27b2f66af901bd3640c30aba6e] remove the broken BLK_DEV_SWIM_IOP driver
	git-bisect bad b21a323710e77a27b2f66af901bd3640c30aba6e
	# bad: [029530f810dd5147f7e59b939eb22cfbe0beea12] one more EXPORT_UNUSED_SYMBOL removal
	git-bisect bad 029530f810dd5147f7e59b939eb22cfbe0beea12


Not sure how much help it is, but while trying to instrument
as-iosched.c, we can see that the failure has a fairly stable
signature:

	[15280.813479] as_dispatch_request: ad=ffff810038704da8 ; reads=0 ; writes=1 ; dir=0 ;fifo_list[async]=ffff81003f4071a0 ad-new_batch=0 ad->change_batch=0.
	[15280.827032] as_dispatch_request: q=ffff81003fdae050 ; #_reqs=128 ; lmerge=ffff81003f4071a0 ;.

which means:

	static int as_dispatch_request(request_queue_t *q, int force)
	{
		...
		const int writes = !list_empty(&ad->fifo_list[REQ_ASYNC]);

'writes' is set, the batch_data_dir has not changed
(ad->batch_data_dir != REQ_SYNC) in the following segment:

		...
		if (writes) {
	dispatch_writes:
			BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));

			if (ad->batch_data_dir == REQ_SYNC) {
				ad->changed_batch = 1;

				/*
				 * new_batch might be 1 when the queue runs out of
				 * reads. A subsequent submission of a write might
				 * cause a change of batch before the read is finished.
				 */
				ad->new_batch = 0;
			}
			ad->batch_data_dir = REQ_ASYNC;
			ad->current_write_count = ad->write_batch_count;
			ad->write_batch_idled = 0;
			rq = ad->next_rq[ad->batch_data_dir];
			goto dispatch_request;
		}

ad->next_rq[ad->batch_data_dir] is NULL, and is then passed down to
as_move_to_dispatch() where the first dereference of rq:

	static void as_move_to_dispatch(struct as_data *ad, struct request *rq)
	{
		const int data_dir = rq_is_sync(rq);

borks the machine.  What's odd (perhaps it's just our rudimentary
understanding of AS) is that there are segments of code where
ad->next_rq[REQ_ASYNC] is checked against NULL (in 'writes' case it is
not).

Anyway, any ideas or hints?  Attached is the .config used.

Thanks,
Andrew Vasquez

--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config.txt"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.19
# Fri Jan 19 16:53:19 2007
#
CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_ZONE_DMA32=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_CMPXCHG=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_DMI=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
# CONFIG_CPUSETS is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_KMOD is not set
CONFIG_STOP_MACHINE=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
CONFIG_X86_PC=y
# CONFIG_X86_VSMP is not set
# CONFIG_MK8 is not set
CONFIG_MPSC=y
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_X86_HT=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
CONFIG_SMP=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_NR_CPUS=4
# CONFIG_HOTPLUG_CPU is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HPET_TIMER=y
# CONFIG_HPET_EMULATE_RTC is not set
CONFIG_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_REORDER is not set
CONFIG_K8_NB=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_ISA_DMA_API=y
CONFIG_GENERIC_PENDING_IRQ=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_HOTKEY is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_MULTITHREAD_PROBE is not set
CONFIG_PCI_DEBUG=y
# CONFIG_HT_IRQ is not set

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set

#
# PCI Hotplug Support
#
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
# CONFIG_IA32_EMULATION is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_NETDEBUG is not set
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set

#
# DCCP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP is not set

#
# SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set

#
# TIPC Configuration (EXPERIMENTAL)
#
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_IEEE80211 is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
# CONFIG_PNP is not set

#
# Block devices
#
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_BLK_DEV_INITRD=y
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set

#
# ATA/ATAPI/MFM/RLL support
#
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
CONFIG_IDEDMA_PCI_AUTO=y
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
CONFIG_IDEDMA_AUTO=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
CONFIG_ATA=y
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INTEL_COMBINED=y
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#

#
# Ethernet (10 or 100Mbit)
#
# CONFIG_NET_ETHERNET is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
# CONFIG_NET_RADIO is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=m
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_RX is not set
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_I2C_CHARDEV is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Hardware Monitoring support
#
# CONFIG_HWMON is not set
# CONFIG_HWMON_VID is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set

#
# Graphics support
#
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Sound
#
# CONFIG_SOUND is not set

#
# HID Devices
#
# CONFIG_HID is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
# CONFIG_USB is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# MMC/SD Card support
#
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#

#
# Virtualization
#
# CONFIG_KVM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
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
CONFIG_NLS_ISO8859_1=y
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
# CONFIG_NLS_UTF8 is not set

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_LOG_BUF_SHIFT=15
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHEDSTATS is not set
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_UNWIND_INFO is not set
CONFIG_FORCED_INLINING=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
# CONFIG_CRYPTO is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC32=y
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_IOMAP_COPY=y

--i9LlY+UWpKt15+FH--
