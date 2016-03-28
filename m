From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/3] Avoid that I/O completion processing triggers lockup
 complaints
Date: Mon, 28 Mar 2016 14:50:47 -0700
Message-ID: <56F9A737.9030102@sandisk.com>
References: <56F9A692.2090704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0092.outbound.protection.outlook.com ([207.46.100.92]:1073
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752523AbcC1Vuv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 17:50:51 -0400
In-Reply-To: <56F9A692.2090704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that I/O completion processing triggers the following complaints
if kernel debug options that slow down the kernel significantly are
enabled:

NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [kdmwork-254:2:358]
irq event stamp: 15233868
hardirqs last  enabled at (15233867): [<ffffffff81578167>] _raw_spin_unlock_irq+0x27/0x40
hardirqs last disabled at (15233868): [<ffffffff81579664>] apic_timer_interrupt+0x84/0x90
softirqs last  enabled at (15233850): [<ffffffff8105a55b>] __do_softirq+0x1cb/0x230
softirqs last disabled at (15233743): [<ffffffff8105a748>] irq_exit+0xa8/0xb0
CPU: 3 PID: 358 Comm: kdmwork-254:2
RIP: 0010:[<ffffffff8157816f>]  [<ffffffff8157816f>] _raw_spin_unlock_irq+0x2f/0x40
Call Trace:
 [<ffffffff813dbe28>] scsi_request_fn+0x118/0x600
 [<ffffffff8128190e>] __blk_run_queue+0x2e/0x40
 [<ffffffff81281175>] __elv_add_request+0x75/0x1f0
 [<ffffffff81285b11>] blk_insert_cloned_request+0x101/0x190
 [<ffffffffa0170eee>] map_request+0x18e/0x210 [dm_mod]
 [<ffffffffa0170f8d>] map_tio_request+0x1d/0x40 [dm_mod]
 [<ffffffff81075a0d>] kthread_worker_fn+0x7d/0x1a0
 [<ffffffff8107591a>] kthread+0xea/0x100
 [<ffffffff81578c7f>] ret_from_fork+0x3f/0x70

INFO: rcu_sched self-detected stall on CPU
 3-...: (6497 ticks this GP) idle=fb9/140000000000002/0 softirq=2044956/2045037 fqs=5414
  (t=6500 jiffies g=219289 c=219288 q=7233211)
Task dump for CPU 3:
kdmwork-254:2   R  running task        0   358      2 0x00000008
Call Trace:
 <IRQ>  [<ffffffff8108195f>] sched_show_task+0xbf/0x150
 [<ffffffff81084742>] dump_cpu_task+0x32/0x40
 [<ffffffff810b5e79>] rcu_dump_cpu_stacks+0x89/0xe0
 [<ffffffff810b9999>] rcu_check_callbacks+0x439/0x730
 [<ffffffff810bc1c4>] update_process_times+0x34/0x60
 [<ffffffff810caaa0>] tick_sched_handle.isra.18+0x20/0x50
 [<ffffffff810cb148>] tick_sched_timer+0x38/0x70
 [<ffffffff810bc865>] __hrtimer_run_queues+0xa5/0x1c0
 [<ffffffff810bcef6>] hrtimer_interrupt+0xa6/0x1b0
 [<ffffffff81038ba3>] smp_trace_apic_timer_interrupt+0x63/0x90
 [<ffffffff81038bd9>] smp_apic_timer_interrupt+0x9/0x10
 [<ffffffff81579669>] apic_timer_interrupt+0x89/0x90
 [<ffffffff811640d6>] __slab_free+0xc6/0x270
 [<ffffffff811643d9>] kmem_cache_free+0x159/0x160
 [<ffffffff811d0a12>] kiocb_free+0x32/0x40
 [<ffffffff811d1b75>] aio_complete+0x1e5/0x3c0
 [<ffffffff811bef45>] dio_complete+0x75/0x1d0
 [<ffffffff811bf11a>] dio_bio_end_aio+0x7a/0x130
 [<ffffffff812800da>] bio_endio+0x3a/0x60
 [<ffffffff81284b7c>] blk_update_request+0x7c/0x2a0
 [<ffffffffa016fcc1>] end_clone_bio+0x41/0x70 [dm_mod]
 [<ffffffff812800da>] bio_endio+0x3a/0x60
 [<ffffffff81284b7c>] blk_update_request+0x7c/0x2a0
 [<ffffffff813da01e>] scsi_end_request+0x2e/0x1d0
 [<ffffffff813dc444>] scsi_io_completion+0xb4/0x610
 [<ffffffff813d3e0a>] scsi_finish_command+0xca/0x120
 [<ffffffff813dbcf0>] scsi_softirq_done+0x120/0x140
 [<ffffffff8128c742>] blk_done_softirq+0x72/0x90
 [<ffffffff8105a49f>] __do_softirq+0x10f/0x230
 [<ffffffff8105a748>] irq_exit+0xa8/0xb0
 [<ffffffff810065a5>] do_IRQ+0x65/0x110
 [<ffffffff815793c9>] common_interrupt+0x89/0x89
 <EOI>
 [<ffffffffa010f815>] __multipath_map.isra.16+0x145/0x260 [dm_multipath]
 [<ffffffffa010f962>] multipath_map+0x12/0x20 [dm_multipath]
 [<ffffffffa0170da3>] map_request+0x43/0x210 [dm_mod]
 [<ffffffffa0170f8d>] map_tio_request+0x1d/0x40 [dm_mod]
 [<ffffffff81075a0d>] kthread_worker_fn+0x7d/0x1a0
 [<ffffffff8107591a>] kthread+0xea/0x100
 [<ffffffff81578c7f>] ret_from_fork+0x3f/0x70

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/scsi_lib.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..3bf6c33 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1770,13 +1770,14 @@ static void scsi_request_fn(struct request_queue *q)
 	struct Scsi_Host *shost;
 	struct scsi_cmnd *cmd;
 	struct request *req;
+	int i;
 
 	/*
-	 * To start with, we keep looping until the queue is empty, or until
-	 * the host is no longer able to accept any more requests.
+	 * Loop until the queue is empty, until the host is no longer able to
+	 * accept any more requests or until 256 requests have been processed.
 	 */
 	shost = sdev->host;
-	for (;;) {
+	for (i = 256; i > 0; i--) {
 		int rtn;
 		/*
 		 * get next queueable request.  We do this early to make sure
@@ -1861,6 +1862,9 @@ static void scsi_request_fn(struct request_queue *q)
 		spin_lock_irq(q->queue_lock);
 	}
 
+	if (unlikely(i == 0))
+		blk_delay_queue(q, 0);
+
 	return;
 
  host_not_ready:
-- 
2.7.3

