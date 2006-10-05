From: Stephen Hemminger <shemminger@osdl.org>
Subject: lockdep warning looks scsi related
Date: Thu, 5 Oct 2006 10:08:53 -0700
Message-ID: <20061005100853.4d65dc90@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:1216 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932172AbWJERIx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 13:08:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

This is current main linux-2.6 (git pulled yesterday).
Running on 2 CPU Opteron
Happened during overnight (beagle cronjob?)

[41735.668113] 
[41735.668117] =================================
[41735.668121] [ INFO: inconsistent lock state ]
[41735.668125] 2.6.18 #13
[41735.668127] ---------------------------------
[41735.668129] inconsistent {in-softirq-W} -> {softirq-on-W} usage.
[41735.668133] beagle-build-in/18927 [HC0[0]:SC0[0]:HE1:SE1] takes:
[41735.668136]  (&q->__queue_lock){-+..}, at: [<ffffffff8111f0b5>] cfq_set_request+0x219/0x39c
[41735.668146] {in-softirq-W} state was registered at:
[41735.668149]   [<ffffffff8104ac4d>] __lock_acquire+0x41b/0xa08
[41735.668155]   [<ffffffff8104b7b5>] lock_acquire+0x4b/0x6a
[41735.668161]   [<ffffffff811bc52b>] scsi_device_unbusy+0x76/0x98
[41735.668168]   [<ffffffff8125f81b>] _spin_lock+0x25/0x31
[41735.668173]   [<ffffffff811bc52b>] scsi_device_unbusy+0x76/0x98
[41735.668178]   [<ffffffff811b732c>] scsi_finish_command+0x1f/0xa1
[41735.668184]   [<ffffffff811bc700>] scsi_softirq_done+0xf4/0xfd
[41735.668189]   [<ffffffff81117d5c>] blk_done_softirq+0x6d/0x7c
[41735.668195]   [<ffffffff81036b74>] __do_softirq+0x5f/0xe3
[41735.668202]   [<ffffffff81036a4b>] ksoftirqd+0x0/0xca
[41735.668208]   [<ffffffff8100ae2c>] call_softirq+0x1c/0x28
[41735.668213]   [<ffffffffffffffff>] 0xffffffffffffffff
[41735.668220] irq event stamp: 617451
[41735.668222] hardirqs last  enabled at (617451): [<ffffffff8125f2ba>] trace_hardirqs_on_thunk+0x35/0x37
[41735.668230] hardirqs last disabled at (617450): [<ffffffff8125f2f1>] trace_hardirqs_off_thunk+0x35/0x67
[41735.668236] softirqs last  enabled at (615100): [<ffffffff81036bef>] __do_softirq+0xda/0xe3
[41735.668243] softirqs last disabled at (615087): [<ffffffff8100ae2c>] call_softirq+0x1c/0x28
[41735.668248] 
[41735.668249] other info that might help us debug this:
[41735.668252] 1 lock held by beagle-build-in/18927:
[41735.668254]  #0:  (&mm->mmap_sem){----}, at: [<ffffffff81261cf2>] do_page_fault+0x38e/0x7ed
[41735.668262] 
[41735.668263] stack backtrace:
[41735.668265] 
[41735.668266] Call Trace:
[41735.668271]  [<ffffffff810498fc>] print_usage_bug+0x264/0x275
[41735.668276]  [<ffffffff8104a1a3>] mark_lock+0x29c/0x3e1
[41735.668281]  [<ffffffff8104accc>] __lock_acquire+0x49a/0xa08
[41735.668286]  [<ffffffff8100a23c>] restore_args+0x0/0x30
[41735.668292]  [<ffffffff8104b7b5>] lock_acquire+0x4b/0x6a
[41735.668296]  [<ffffffff8111f0b5>] cfq_set_request+0x219/0x39c
[41735.668300]  [<ffffffff81123182>] rb_first+0x7/0x1c
[41735.668304]  [<ffffffff8125f81b>] _spin_lock+0x25/0x31
[41735.668309]  [<ffffffff8111f0b5>] cfq_set_request+0x219/0x39c
[41735.668317]  [<ffffffff8111303f>] elv_set_request+0x16/0x27
[41735.668321]  [<ffffffff811165d1>] get_request+0x1a1/0x24b
[41735.668327]  [<ffffffff81116ec4>] get_request_wait+0x25/0xfe
[41735.668334]  [<ffffffff8111738c>] __make_request+0x2d6/0x39d
[41735.668341]  [<ffffffff810cc630>] ext3_get_block+0x0/0xec
[41735.668345]  [<ffffffff81115d01>] generic_make_request+0x177/0x18e
[41735.668351]  [<ffffffff810cc630>] ext3_get_block+0x0/0xec
[41735.668355]  [<ffffffff81118107>] submit_bio+0xca/0xd3
[41735.668360]  [<ffffffff810cc630>] ext3_get_block+0x0/0xec
[41735.668365]  [<ffffffff81069ed4>] __pagevec_lru_add+0xb4/0xc5
[41735.668371]  [<ffffffff810aec91>] mpage_bio_submit+0x22/0x26
[41735.668376]  [<ffffffff810afd60>] mpage_readpages+0x138/0x14c
[41735.668384]  [<ffffffff8100a23c>] restore_args+0x0/0x30
[41735.668389]  [<ffffffff8106940e>] __do_page_cache_readahead+0xaa/0x229
[41735.668396]  [<ffffffff810cb872>] ext3_readpages+0x1a/0x1c
[41735.668400]  [<ffffffff8106948e>] __do_page_cache_readahead+0x12a/0x229
[41735.668408]  [<ffffffff81061e68>] handle_fasteoi_irq+0xc2/0xe8
[41735.668413]  [<ffffffff8100a23c>] restore_args+0x0/0x30
[41735.668420]  [<ffffffff81069901>] do_page_cache_readahead+0x52/0x5f
[41735.668425]  [<ffffffff81065236>] filemap_nopage+0x152/0x34d
[41735.668433]  [<ffffffff8106f9ae>] __handle_mm_fault+0x1fa/0x978
[41735.668441]  [<ffffffff81261dae>] do_page_fault+0x44a/0x7ed
[41735.668445]  [<ffffffff8125fb02>] _spin_unlock_irq+0x2b/0x31
[41735.668450]  [<ffffffff8125fb05>] _spin_unlock_irq+0x2e/0x31
[41735.668456]  [<ffffffff8125d1cd>] thread_return+0xd0/0x124
[41735.668461]  [<ffffffff8125f2ba>] trace_hardirqs_on_thunk+0x35/0x37
[41735.668467]  [<ffffffff8126000d>] error_exit+0x0/0x96
[41735.668474] 
