From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthrough command (try
 2)
Date: Sat, 1 Apr 2017 18:10:46 +0200
Message-ID: <20170401161046.GB18838@kroah.com>
References: <20170331135030.GA24063@zipoli.ccur.kvm>
 <20170331203857.GA22878@zipoli.ccur.kvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331203857.GA22878@zipoli.ccur.kvm>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Korty <joe.korty@ccur.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrey Grodzovsky <andrey2805@gmail.com>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Ingo Molnar <mingo@kernel.org>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Stable Mailing List <stable@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 31, 2017 at 04:38:57PM -0400, Joe Korty wrote:
> scsi: mpt3sas: fix hang on ata passthrough commands
> 
> commit 16236802bfecb1082144a48b7d6fa60997824662 upstream, in v4.9 in linux-stable.
> commit ffb58456589443ca572221fabbdef3db8483a779 upstream, in master.
> 
> Please backport the above mentioned v4.9 version of the commit into
> v4.4.  It fixes a 'inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage'
> bug introduced when two other mpt3sas patches were backported into
> v4.4.28.

Ok, now done.

> In v4.4.28, a call to scsi_internal_device_unblock() was added
> to the mpt3sas driver's interrupt level routine, but that service
> expects to be called only from base level, so not all of its uses
> of spin locks are protected from interrupts.  Thus self deadlock
> is possible.  In this case, the 'spin_lock(&hctx->lock)' in
> __blk_mq_run_hw_queue() is the immediate cause of this lockdep
> assertion.  This happens on the first use of the mpt3sas driver.
> 
> [   28.340336] =================================
> [   28.344799] [ INFO: inconsistent lock state ]
> [   28.349229] 4.4.53 #2 Not tainted
> [   28.352566] ---------------------------------
> [   28.357004] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [   28.363019] swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [   28.368202]  (&(&hctx->lock)->rlock){?.+...}, at: [<ffffffff815349a2>] __blk_mq_run_hw_queue+0x172/0x3b0
> [   28.377872] {HARDIRQ-ON-W} state was registered at:
> [   28.382829]   [<ffffffff810cdf34>] __lock_acquire+0x8e4/0xe80
> [   28.388612]   [<ffffffff810ce5ae>] lock_acquire+0xde/0x310
> [   28.390151]   [<ffffffff8203094b>] _raw_spin_lock+0x3b/0x50
> [   28.390154]   [<ffffffff81534a76>] __blk_mq_run_hw_queue+0x246/0x3b0
> [   28.390157]   [<ffffffff81535345>] blk_mq_run_hw_queue+0x65/0xf0
> [   28.390159]   [<ffffffff815357ad>] blk_sq_make_request+0x24d/0x740
> [   28.390163]   [<ffffffff81529bca>] generic_make_request+0xfa/0x190
> [   28.390166]   [<ffffffff81529cdf>] submit_bio+0x7f/0x160
> [   28.390172]   [<ffffffff8126286e>] submit_bh_wbc+0x13e/0x180
> [   28.390175]   [<ffffffff812628c2>] submit_bh+0x12/0x20
> [   28.390179]   [<ffffffff812c837c>] __ext4_get_inode_loc+0x21c/0x590
> [   28.390181]   [<ffffffff812c8fa8>] ext4_iget+0x88/0xc30
> [   28.390183]   [<ffffffff812f14f5>] ext4_fill_super+0x1cc5/0x3660
> [   28.390187]   [<ffffffff81226cc5>] mount_bdev+0x1b5/0x200
> [   28.390190]   [<ffffffff812e9985>] ext4_mount+0x15/0x20
> [   28.390193]   [<ffffffff81226883>] mount_fs+0x43/0x170
> [   28.390196]   [<ffffffff81249ac6>] vfs_kern_mount+0x76/0x160
> [   28.390198]   [<ffffffff8124a313>] do_mount+0x263/0xf40
> [   28.390200]   [<ffffffff8124b06b>] SyS_mount+0x7b/0xc0
> [   28.390204]   [<ffffffff82bdc56e>] do_mount_root+0x1e/0x97
> [   28.390206]   [<ffffffff82bdc82e>] mount_block_root+0x10f/0x24b
> [   28.390208]   [<ffffffff82bdca60>] mount_root+0xf6/0x101
> [   28.390210]   [<ffffffff82bdcbdb>] prepare_namespace+0x170/0x1a9
> [   28.390213]   [<ffffffff82bdbbf0>] kernel_init_freeable+0x254/0x26b
> [   28.390215]   [<ffffffff8202816e>] kernel_init+0xe/0xe0
> [   28.390218]   [<ffffffff82031a1f>] ret_from_fork+0x3f/0x70
> [   28.390219] irq event stamp: 482812
> [   28.390223] hardirqs last  enabled at (482809): [<ffffffff8101202c>] default_idle+0x2c/0x240
> [   28.390226] hardirqs last disabled at (482810): [<ffffffff82032187>] common_interrupt+0x87/0x8c
> [   28.390229] softirqs last  enabled at (482812): [<ffffffff81073261>] _local_bh_enable+0x21/0x50
> [   28.390231] softirqs last disabled at (482811): [<ffffffff8107349b>] irq_enter+0x4b/0x70
> [   28.390232] 
> other info that might help us debug this:
> [   28.390233]  Possible unsafe locking scenario:
> 
> [   28.390233]        CPU0
> [   28.390234]        ----
> [   28.390235]   lock(&(&hctx->lock)->rlock);
> [   28.390236]   <Interrupt>
> [   28.390237]     lock(&(&hctx->lock)->rlock);
> [   28.390238] 
>  *** DEADLOCK ***
> 
> [   28.390238] no locks held by swapper/0/0.
> [   28.390239] 
> stack backtrace:
> [   28.390241] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.53 #2
> [   28.390242] Hardware name: Supermicro H8QG6/H8QG6, BIOS 3.0b       02/01/2013
> [   28.390246]  0000000000000000 ffff88021fc03858 ffffffff8155ba95 0000000000000001
> [   28.390249]  0000000000000003 ffffffff82a17500 ffffffff83200800 ffff88021fc038a8
> [   28.390252]  ffffffff810c9cdf 0000000000000000 ffffffff00000000 0000000000000001
> [   28.390253] Call Trace:
> [   28.390257]  <IRQ>  [<ffffffff8155ba95>] dump_stack+0x89/0xd4
> [   28.390260]  [<ffffffff810c9cdf>] print_usage_bug+0x23f/0x300
> [   28.390263]  [<ffffffff810ca11d>] mark_lock+0x37d/0x690
> [   28.390266]  [<ffffffff810c89ad>] ? trace_hardirqs_off+0xd/0x10
> [   28.390268]  [<ffffffff810cdfbe>] __lock_acquire+0x96e/0xe80
> [   28.390272]  [<ffffffff8158ffaf>] ? check_unmap+0x3df/0x970
> [   28.390275]  [<ffffffff81561266>] ? radix_tree_delete_item+0xb6/0x110
> [   28.390278]  [<ffffffff810ce5ae>] lock_acquire+0xde/0x310
> [   28.390281]  [<ffffffff815349a2>] ? __blk_mq_run_hw_queue+0x172/0x3b0
> [   28.390284]  [<ffffffff8203094b>] _raw_spin_lock+0x3b/0x50
> [   28.390286]  [<ffffffff815349a2>] ? __blk_mq_run_hw_queue+0x172/0x3b0
> [   28.390288]  [<ffffffff815349a2>] __blk_mq_run_hw_queue+0x172/0x3b0
> [   28.390293]  [<ffffffff8192e038>] ? _scsih_io_done+0x48/0xa60
> [   28.390296]  [<ffffffff81535345>] blk_mq_run_hw_queue+0x65/0xf0
> [   28.390298]  [<ffffffff810cdcb6>] ? __lock_acquire+0x666/0xe80
> [   28.390301]  [<ffffffff815364f3>] blk_mq_start_stopped_hw_queues+0x63/0x80
> [   28.390304]  [<ffffffff81723a2b>] scsi_internal_device_unblock+0x4b/0xa0
> [   28.390307]  [<ffffffff8192e105>] _scsih_io_done+0x115/0xa60
> [   28.390310]  [<ffffffff810cdcb6>] ? __lock_acquire+0x666/0xe80
> [   28.390313]  [<ffffffff819234b8>] _base_interrupt+0x1e8/0xb90
> [   28.390317]  [<ffffffff8157a617>] ? debug_smp_processor_id+0x17/0x20
> [   28.390320]  [<ffffffff810e4585>] ? __rcu_is_watching+0x15/0x30
> [   28.390323]  [<ffffffff810d95c4>] handle_irq_event_percpu+0xb4/0x530
> [   28.390325]  [<ffffffff810de0fb>] ? handle_edge_irq+0x2b/0x150
> [   28.390327]  [<ffffffff810d9a7f>] ? handle_irq_event+0x3f/0x70
> [   28.390330]  [<ffffffff810d9a87>] handle_irq_event+0x47/0x70
> [   28.390332]  [<ffffffff810de1ae>] handle_edge_irq+0xde/0x150
> [   28.390335]  [<ffffffff8100951a>] handle_irq+0x7a/0x190
> [   28.390338]  [<ffffffff8157a617>] ? debug_smp_processor_id+0x17/0x20
> [   28.390340]  [<ffffffff810e4585>] ? __rcu_is_watching+0x15/0x30
> [   28.390342]  [<ffffffff8203403e>] do_IRQ+0x7e/0x150
> [   28.390345]  [<ffffffff8203218c>] common_interrupt+0x8c/0x8c
> [   28.390349]  <EOI>  [<ffffffff81055136>] ? native_safe_halt+0x6/0x10
> [   28.390351]  [<ffffffff810ca86d>] ? trace_hardirqs_on+0xd/0x10
> [   28.390353]  [<ffffffff81012031>] default_idle+0x31/0x240
> [   28.390356]  [<ffffffff810e6600>] ? rcu_eqs_enter_common+0xb0/0x140
> [   28.390358]  [<ffffffff81011a6f>] arch_cpu_idle+0xf/0x20
> [   28.390360]  [<ffffffff810c021e>] default_idle_call+0x2e/0x50
> [   28.390362]  [<ffffffff810c046b>] cpu_startup_entry+0x22b/0x570
> [   28.390365]  [<ffffffff8109f591>] ? get_parent_ip+0x11/0x50
> [   28.390367]  [<ffffffff8109f591>] ? get_parent_ip+0x11/0x50
> [   28.390370]  [<ffffffff820280f0>] rest_init+0xf0/0x160
> [   28.390372]  [<ffffffff82028000>] ? csum_partial_copy_generic+0x170/0x170
> [   28.390375]  [<ffffffff82c049f8>] ? ftrace_init+0xc9/0x15c
> [   28.390377]  [<ffffffff82bdc38c>] start_kernel+0x4e7/0x4f4
> [   28.390380]  [<ffffffff82bdbcc1>] ? set_init_arg+0x5f/0x5f
> [   28.390382]  [<ffffffff82bdb117>] ? early_idt_handler_array+0x117/0x120
> [   28.390385]  [<ffffffff82bdb5df>] x86_64_start_reservations+0x2a/0x2c
> [   28.390387]  [<ffffffff82bdb77d>] x86_64_start_kernel+0x19c/0x1ab
> 
> PS: This follows the form of 'Option 3' in Documentation/stable_kernel_rules.txt
> PPS: The original authors of this patch should review and ack before it is accepted.
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>

I don't understand, you only need/want one of these patches in 4.4,
right?

thanks,

greg k-h
