From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 0/2] target: Add TFO->complete_irq queue_work bypass
Date: Wed, 3 Jun 2015 14:57:56 +0200
Message-ID: <20150603125756.GA19696@lst.de>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432281446-31080-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

This makes lockdep very unhappy, rightly so.  If you execute
one end_io function inside another you bas=D1=96cally nest every possib=
le
lock taken in the I/O completion path.  Also adding more work
to the hardirq path generally isn't a smart idea.  Can you explain
what issues you were seeing and how much this helps?  Note that
the workqueue usage in the target core so far is fairly basic, so
there should some low hanging fruit.

[   21.119148]=20
[   21.119382] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
[   21.120012] [ INFO: possible recursive locking detected ]
[   21.120639] 4.1.0-rc1+ #489 Not tainted
[   21.121131] ---------------------------------------------
[   21.121754] swapper/0/0 is trying to acquire lock:
[   21.122324]  (&(&fq->mq_flush_lock)->rlock){-.....}, at: [<ffffffff8=
17b0256>] flush_end_io+0x66/0x220
[   21.122451]=20
[   21.122451] but task is already holding lock:
[   21.122451]  (&(&fq->mq_flush_lock)->rlock){-.....}, at: [<ffffffff8=
17b0256>] flush_end_io+0x66/0x220
[   21.122451]=20
[   21.122451] other info that might help us debug this:
[   21.122451]  Possible unsafe locking scenario:
[   21.122451]=20
[   21.122451]        CPU0
[   21.122451]        ----
[   21.122451]   lock(&(&fq->mq_flush_lock)->rlock);
[   21.122451]   lock(&(&fq->mq_flush_lock)->rlock);
[   21.122451]=20
[   21.122451]  *** DEADLOCK ***
[   21.122451]=20
[   21.122451]  May be due to missing lock nesting notation
[   21.122451]=20
[   21.122451] 3 locks held by swapper/0/0:
[   21.122451]  #0:  (&(&vp_dev->lock)->rlock){-.-...}, at: [<ffffffff8=
187c87c>] vp_vring_interrupt+0x2c/0x90
[   21.122451]  #1:  (&(&virtscsi_vq->vq_lock)->rlock){-.-...}, at: [<f=
fffffff81ad2796>] virtscsi_vq_done+0x26/0x90
[   21.122451]  #2:  (&(&fq->mq_flush_lock)->rlock){-.....}, at: [<ffff=
ffff817b0256>] flush_end_io+0x66/0x220
[   21.122451]=20
[   21.122451] stack backtrace:
[   21.122451] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.1.0-rc1+ #48=
9
[   21.122451] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   21.122451]  ffffffff82c34820 ffff88007fc03618 ffffffff81e3396f 0000=
000000000000
[   21.122451]  ffffffff82445500 ffff88007fc036c8 ffffffff811209a9 ffff=
88007fc17d18
[   21.122451]  0000000000000000 0000000000000000 ffffffff82c34820 ffff=
88007fc17d18
[   21.122451] Call Trace:
[   21.122451]  <IRQ>  [<ffffffff81e3396f>] dump_stack+0x45/0x57
[   21.122451]  [<ffffffff811209a9>] validate_chain.isra.37+0xd39/0x116=
0
[   21.122451]  [<ffffffff811219b8>] __lock_acquire+0x488/0xd40
[   21.122451]  [<ffffffff810f6b28>] ? __kernel_text_address+0x58/0x80
[   21.122451]  [<ffffffff8112285f>] lock_acquire+0xaf/0x130
[   21.122451]  [<ffffffff817b0256>] ? flush_end_io+0x66/0x220
[   21.122451]  [<ffffffff81e3d859>] _raw_spin_lock_irqsave+0x49/0x60
[   21.122451]  [<ffffffff817b0256>] ? flush_end_io+0x66/0x220
[   21.122451]  [<ffffffff817b0256>] flush_end_io+0x66/0x220
[   21.122451]  [<ffffffff817b5d0f>] __blk_mq_end_request+0x2f/0x70
[   21.122451]  [<ffffffff81a088ad>] scsi_end_request+0x7d/0x1e0
[   21.122451]  [<ffffffff81a0a3e0>] scsi_io_completion+0x110/0x610
[   21.122451]  [<ffffffff811219b8>] ? __lock_acquire+0x488/0xd40
[   21.122451]  [<ffffffff81a00e5b>] scsi_finish_command+0xdb/0x140
[   21.122451]  [<ffffffff81a09b66>] scsi_softirq_done+0x136/0x150
[   21.122451]  [<ffffffff817b7f6e>] __blk_mq_complete_request+0x8e/0x1=
30
[   21.122451]  [<ffffffff817b8039>] blk_mq_complete_request+0x29/0x30
[   21.122451]  [<ffffffff81a078d8>] scsi_mq_done+0x28/0x60
[   21.122451]  [<ffffffff81b43fbb>] tcm_loop_queue_status+0x3b/0xb0
[   21.122451]  [<ffffffff81b318da>] target_complete_irq+0x8a/0x250
[   21.122451]  [<ffffffff81b335ea>] target_complete_cmd+0x1fa/0x2a0
[   21.122451]  [<ffffffff81b3f6da>] iblock_end_io_flush+0x2a/0x60
[   21.122451]  [<ffffffff817a3a93>] bio_endio+0x53/0x90
[   21.122451]  [<ffffffff817acd58>] blk_update_request+0x98/0x360
[   21.122451]  [<ffffffff817b752e>] blk_mq_end_request+0x1e/0x80
[   21.122451]  [<ffffffff817affb4>] blk_flush_complete_seq+0xe4/0x320
[   21.122451]  [<ffffffff817b0328>] flush_end_io+0x138/0x220
[   21.122451]  [<ffffffff817b5d0f>] __blk_mq_end_request+0x2f/0x70
[   21.122451]  [<ffffffff81a088ad>] scsi_end_request+0x7d/0x1e0
[   21.122451]  [<ffffffff81a0a3e0>] scsi_io_completion+0x110/0x610
[   21.122451]  [<ffffffff8111dcdd>] ? trace_hardirqs_off+0xd/0x10
[   21.122451]  [<ffffffff81a00e5b>] scsi_finish_command+0xdb/0x140
[   21.122451]  [<ffffffff81a09b66>] scsi_softirq_done+0x136/0x150
[   21.122451]  [<ffffffff817b7f6e>] __blk_mq_complete_request+0x8e/0x1=
30
[   21.122451]  [<ffffffff817b8039>] blk_mq_complete_request+0x29/0x30
[   21.122451]  [<ffffffff81a078d8>] scsi_mq_done+0x28/0x60
[   21.122451]  [<ffffffff81ad29af>] virtscsi_complete_cmd+0x10f/0x1e0
[   21.122451]  [<ffffffff81ad28a0>] ? virtscsi_ctrl_done+0x30/0x30
[   21.122451]  [<ffffffff81ad27b9>] virtscsi_vq_done+0x49/0x90
[   21.122451]  [<ffffffff81ad2839>] virtscsi_req_done+0x39/0x40
[   21.122451]  [<ffffffff8187a470>] vring_interrupt+0x30/0x60
[   21.122451]  [<ffffffff8187c8ab>] vp_vring_interrupt+0x5b/0x90
[   21.122451]  [<ffffffff811348a0>] handle_irq_event_percpu+0x60/0x1d0
[   21.122451]  [<ffffffff81134a53>] handle_irq_event+0x43/0x70
[   21.122451]  [<ffffffff811376d6>] handle_edge_irq+0x96/0x110
[   21.122451]  [<ffffffff81063fe8>] handle_irq+0x58/0x130
[   21.122451]  [<ffffffff810f96a1>] ? atomic_notifier_call_chain+0x11/=
0x20
[   21.122451]  [<ffffffff810638d7>] do_IRQ+0x57/0x100
[   21.122451]  [<ffffffff81e3eeb3>] common_interrupt+0x73/0x73
[   21.122451]  <EOI>  [<ffffffff810a3726>] ? native_safe_halt+0x6/0x10
[   21.122451]  [<ffffffff811233fd>] ? trace_hardirqs_on+0xd/0x10
[   21.122451]  [<ffffffff8106c8ae>] default_idle+0x1e/0xc0
[   21.122451]  [<ffffffff8106d26a>] arch_cpu_idle+0xa/0x10
[   21.122451]  [<ffffffff81118073>] cpu_startup_entry+0x383/0x430
[   21.122451]  [<ffffffff81e29788>] rest_init+0x128/0x130
[   21.122451]  [<ffffffff81e29660>] ? csum_partial_copy_generic+0x170/=
0x170
[   21.122451]  [<ffffffff825d21a6>] start_kernel+0x54a/0x557
[   21.122451]  [<ffffffff825d1a49>] ? set_init_arg+0x58/0x58
[   21.122451]  [<ffffffff825d1117>] ? early_idt_handlers+0x117/0x120
[   21.122451]  [<ffffffff825d15f0>] x86_64_start_reservations+0x2a/0x2=
c
[   21.122451]  [<ffffffff825d1730>] x86_64_start_kernel+0x13e/0x14d
