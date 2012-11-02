From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 6/7] Fix race between starved list processing and device
 removal
Date: Fri, 02 Nov 2012 11:48:05 +0100
Message-ID: <5093A4E5.20207@acm.org>
References: <508A7B63.60608@acm.org> <508A7C6D.8070002@acm.org> <267107B7B5D6404FB174AB273F79D8BD1A4C39@SHSMSX101.ccr.corp.intel.com> <508E936F.7050004@acm.org> <267107B7B5D6404FB174AB273F79D8BD1A5BC4@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:38699 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab2KBKsN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2012 06:48:13 -0400
In-Reply-To: <267107B7B5D6404FB174AB273F79D8BD1A5BC4@SHSMSX101.ccr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zhuang, Jin Can" <jin.can.zhuang@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 10/30/12 06:40, Zhuang, Jin Can wrote:
> Yes. Here's the warning.
> For the trace below, I used scsi_device_get/scsi_device_put() in scsi_run_queue(). (A little different from your patch). But I think it's the same.
> 
> 10-23 18:15:53.309     8     8 I KERNEL  : [  268.994556] BUG: sleeping function called from invalid context at linux-2.6/kernel/workqueue.c:2500
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.006898] in_atomic(): 0, irqs_disabled(): 1, pid: 8, name: kworker/0:1
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.013689] Pid: 8, comm: kworker/0:1 Tainted: G        WC  3.0.34-140359-g85a6d67-dirty #43
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.022113] Call Trace:
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.028828]  [<c123464a>] __might_sleep+0x10a/0x110
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.033695]  [<c12628a3>] wait_on_work+0x23/0x1a0
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.054913]  [<c126472a>] __cancel_work_timer+0x6a/0x110
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.060217]  [<c12647ff>] cancel_work_sync+0xf/0x20
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.065087]  [<c1548d5d>] scsi_device_dev_release_usercontext+0x6d/0x100
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.071785]  [<c12626a2>] execute_in_process_context+0x42/0x50
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.077609]  [<c1548cc8>] scsi_device_dev_release+0x18/0x20
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.083174]  [<c15234a0>] device_release+0x20/0x80
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.092479]  [<c148d1b4>] kobject_release+0x84/0x1f0
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.107430]  [<c148e8ec>] kref_put+0x2c/0x60
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.111688]  [<c148d06d>] kobject_put+0x1d/0x50
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.116209]  [<c15232a4>] put_device+0x14/0x20
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.120646]  [<c153daa7>] scsi_device_put+0x37/0x60
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.125515]  [<c1543cc7>] scsi_run_queue+0x247/0x320
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.130470]  [<c1545903>] scsi_requeue_run_queue+0x13/0x20
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.135941]  [<c1263efe>] process_one_work+0xfe/0x3f0
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.146384]  [<c12644f1>] worker_thread+0x121/0x2f0
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.156383]  [<c1267ffd>] kthread+0x6d/0x80
> 10-23 18:15:53.309     8     8 I KERNEL  : [  269.166124]  [<c186a27a>] kernel_thread_helper+0x6/0x10

Thanks for the feedback. Something that kept me busy since I posted
the patch at the start of this thread is how to avoid adding two
atomic operations in a hot path (the get_device() and put_device()
calls in scsi_run_queue()). The patch below should realize that.
However, since I haven't been able so far to trigger the above call
trace that means that the test I ran wasn't sufficient to trigger
all code paths. So it would be appreciated if anyone could help
testing the patch below.

[PATCH] Fix race between starved list processing and device removal

---
 block/blk-core.c          |    9 +++++----
 drivers/scsi/scsi_lib.c   |   20 ++++++++++++++------
 drivers/scsi/scsi_sysfs.c |    9 ++++++++-
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e4f4e06..565484f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -407,10 +407,11 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 
 		/*
 		 * This function might be called on a queue which failed
-		 * driver init after queue creation or is not yet fully
-		 * active yet.  Some drivers (e.g. fd and loop) get unhappy
-		 * in such cases.  Kick queue iff dispatch queue has
-		 * something on it and @q has request_fn set.
+		 * driver init after queue creation, is not yet fully active
+		 * or is being cleaned up and doesn't make progress anymore
+		 * (e.g. a SCSI device in state SDEV_DEL). Kick queue iff
+		 * dispatch queue has something on it and @q has request_fn
+		 * set.
 		 */
 		if (!list_empty(&q->queue_head) && q->request_fn)
 			__blk_run_queue(q);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 488035b..1763181 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -447,8 +447,9 @@ static void scsi_run_queue(struct request_queue *q)
 				  struct scsi_device, starved_entry);
 		list_del_init(&sdev->starved_entry);
 		if (scsi_target_is_busy(scsi_target(sdev))) {
-			list_move_tail(&sdev->starved_entry,
-				       &shost->starved_list);
+			if (sdev->sdev_state != SDEV_DEL)
+				list_add_tail(&sdev->starved_entry,
+					      &shost->starved_list);
 			continue;
 		}
 
@@ -1344,7 +1345,9 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	}
 
 	if (scsi_target_is_busy(starget)) {
-		list_move_tail(&sdev->starved_entry, &shost->starved_list);
+		if (sdev->sdev_state != SDEV_DEL)
+			list_move_tail(&sdev->starved_entry,
+				       &shost->starved_list);
 		return 0;
 	}
 
@@ -1377,8 +1380,11 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 		}
 	}
 	if (scsi_host_is_busy(shost)) {
-		if (list_empty(&sdev->starved_entry))
-			list_add_tail(&sdev->starved_entry, &shost->starved_list);
+		if (list_empty(&sdev->starved_entry) &&
+		    sdev->sdev_state != SDEV_DEL) {
+			list_add_tail(&sdev->starved_entry,
+				      &shost->starved_list);
+		}
 		return 0;
 	}
 
@@ -1571,9 +1577,11 @@ static void scsi_request_fn(struct request_queue *q)
 		 * a run when a tag is freed.
 		 */
 		if (blk_queue_tagged(q) && !blk_rq_tagged(req)) {
-			if (list_empty(&sdev->starved_entry))
+			if (list_empty(&sdev->starved_entry) &&
+			    sdev->sdev_state != SDEV_DEL) {
 				list_add_tail(&sdev->starved_entry,
 					      &shost->starved_list);
+			}
 			goto not_ready;
 		}
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ce5224c..2f0f31e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -348,7 +348,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
-	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	cancel_work_sync(&sdev->event_work);
@@ -956,6 +955,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
 
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
@@ -973,7 +974,13 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 * scsi_run_queue() invocations have finished before tearing down the
 	 * device.
 	 */
+
 	scsi_device_set_state(sdev, SDEV_DEL);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&sdev->starved_entry);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-- 
1.7.10.4


