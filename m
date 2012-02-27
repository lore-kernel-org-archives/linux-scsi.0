From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH] kick ksoftirqd more often to please soft lockup detector
Date: Mon, 27 Feb 2012 12:38:47 -0800
Message-ID: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-Id: linux-scsi@vger.kernel.org

An experimental hack to tease out whether we are continuing to
run the softirq handler past the point of needing scheduling.

It allows only one trip through __do_softirq() as long as need_resched()
is set which hopefully creates the back pressure needed to get ksoftirqd
scheduled.

Targeted to address reports like the following that are produced
with i/o tests to a sas domain with a large number of disks (48+), and
lots of debugging enabled (slub_deubg, lockdep) that makes the
block+scsi softirq path more cpu-expensive than normal.

With this patch applied the softlockup detector seems appeased, but it
seems odd to need changes to kernel/softirq.c so maybe I have overlooked
something that needs changing at the block/scsi level?

BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:78]
Modules linked in: nls_utf8 ipv6 uinput sg iTCO_wdt iTCO_vendor_support ioatdma dca i2c_i801 i2c_core wmi sd_mod ahci libahci isci libsas libata scsi_transport_sas [last unloaded: scsi_wait_scan]
irq event stamp: 26260303
hardirqs last  enabled at (26260302): [<ffffffff814becf4>] restore_args+0x0/0x30
hardirqs last disabled at (26260303): [<ffffffff814c60ee>] apic_timer_interrupt+0x6e/0x80
softirqs last  enabled at (26220386): [<ffffffff81033edd>] __do_softirq+0x1ae/0x1bd
softirqs last disabled at (26220665): [<ffffffff814c696c>] call_softirq+0x1c/0x26
CPU 3
Modules linked in: nls_utf8 ipv6 uinput sg iTCO_wdt iTCO_vendor_support ioatdma dca i2c_i801 i2c_core wmi sd_mod ahci libahci isci libsas libata scsi_transport_sas [last unloaded: scsi_wait_scan]

Pid: 78, comm: kworker/3:1 Not tainted 3.3.0-rc3-7ada1dd-isci-3.0.183+ #1 Intel Corporation ROSECITY/ROSECITY
RIP: 0010:[<ffffffff814be8b6>]  [<ffffffff814be8b6>] _raw_spin_unlock_irq+0x34/0x4b
RSP: 0000:ffff8800bb8c3c50  EFLAGS: 00000202
RAX: ffff8800375f3ec0 RBX: ffffffff814becf4 RCX: ffff8800bb8c3c00
RDX: 0000000000000001 RSI: ffff880035bbc348 RDI: ffff8800375f4588
RBP: ffff8800bb8c3c60 R08: 0000000000000000 R09: ffff880035aed150
R10: 0000000000018f3b R11: ffff8800bb8c39e0 R12: ffff8800bb8c3bc8
R13: ffffffff814c60f3 R14: ffff8800bb8c3c60 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8800bb8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000f2e028 CR3: 00000000b11b3000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/3:1 (pid: 78, threadinfo ffff8800377d2000, task ffff8800375f3ec0)
Stack:
 ffff88003555f800 ffff88003555f800 ffff8800bb8c3cc0 ffffffffa00512c4
 ffffffff814be8b2 ffff880035dfc000 ffff880035dfe000 000000000553a265
 ffff8800bb8c3cb0 ffff88003555f800 ffff8800b20af200 ffff880035dfe000
Call Trace:
 <IRQ>
 [<ffffffffa00512c4>] sas_queuecommand+0xa7/0x204 [libsas]
 [<ffffffff814be8b2>] ? _raw_spin_unlock_irq+0x30/0x4b
 [<ffffffff8132b6a9>] scsi_dispatch_cmd+0x1a2/0x24c
 [<ffffffff813317a8>] ? spin_lock+0x9/0xb
 [<ffffffff813333b0>] scsi_request_fn+0x3b1/0x3d9
 [<ffffffff8124a19f>] __blk_run_queue+0x1d/0x1f
 [<ffffffff8124b869>] blk_run_queue+0x26/0x3a
 [<ffffffff813319a5>] scsi_run_queue+0x1fb/0x20a
 [<ffffffff81332136>] scsi_next_command+0x3b/0x4c
 [<ffffffff81332b66>] scsi_io_completion+0x205/0x44f
 [<ffffffff813316b8>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff8132b3ab>] scsi_finish_command+0xeb/0xf4
 [<ffffffff81333a04>] scsi_softirq_done+0x112/0x11b
 [<ffffffff812540ac>] blk_done_softirq+0x7e/0x96
 [<ffffffff81033e0c>] __do_softirq+0xdd/0x1bd
 [<ffffffff814c696c>] call_softirq+0x1c/0x26
 [<ffffffff81003ce6>] do_softirq+0x4b/0xa5
 [<ffffffff81034916>] irq_exit+0x55/0xc2
 [<ffffffff814c6a9c>] smp_apic_timer_interrupt+0x7c/0x8a
 [<ffffffff814c60f3>] apic_timer_interrupt+0x73/0x80
 <EOI>
 [<ffffffff814be8b6>] ? _raw_spin_unlock_irq+0x34/0x4b
 [<ffffffffa00512c4>] sas_queuecommand+0xa7/0x204 [libsas]
 [<ffffffff814be8b2>] ? _raw_spin_unlock_irq+0x30/0x4b
 [<ffffffff8132b6a9>] scsi_dispatch_cmd+0x1a2/0x24c
 [<ffffffff813317a8>] ? spin_lock+0x9/0xb
 [<ffffffff813333b0>] scsi_request_fn+0x3b1/0x3d9
 [<ffffffff8124a19f>] __blk_run_queue+0x1d/0x1f
 [<ffffffff8125f3bb>] cfq_kick_queue+0x2f/0x41
 [<ffffffff8104462e>] process_one_work+0x1c8/0x336
 [<ffffffff81044599>] ? process_one_work+0x133/0x336
 [<ffffffff81044306>] ? spin_lock_irq+0x9/0xb
 [<ffffffff8125f38c>] ? cfq_init_queue+0x2a3/0x2a3
 [<ffffffff81045fd9>] ? workqueue_congested+0x1e/0x1e
 [<ffffffff81046085>] worker_thread+0xac/0x151
 [<ffffffff81045fd9>] ? workqueue_congested+0x1e/0x1e
 [<ffffffff8104a618>] kthread+0x8a/0x92
 [<ffffffff8107654e>] ? trace_hardirqs_on_caller+0x16/0x16d
 [<ffffffff814c6874>] kernel_thread_helper+0x4/0x10
 [<ffffffff814becf4>] ? retint_restore_args+0x13/0x13
 [<ffffffff8104a58e>] ? kthread_create_on_node+0x14d/0x14d
 [<ffffffff814c6870>] ? gs_change+0x13/0x13

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <JBottomley@parallels.com>
Reported-by: Lukasz Dorau <lukasz.dorau@intel.com>
Reported-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
Not-yet-signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/softirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..82a3f43 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -255,7 +255,7 @@ restart:
 	local_irq_disable();
 
 	pending = local_softirq_pending();
-	if (pending && --max_restart)
+	if (pending && --max_restart && !need_resched())
 		goto restart;
 
 	if (pending)
