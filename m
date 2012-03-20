From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Tue, 20 Mar 2012 20:06:39 +0000
Message-ID: <4F68E34F.1060502@acm.org>
References: <4F65E09D.6010600@acm.org> <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com> <4F663BE3.4000503@acm.org> <20120319170435.GH11069@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:40581 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab2CTUGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 16:06:42 -0400
In-Reply-To: <20120319170435.GH11069@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/19/12 17:04, Tejun Heo wrote:

> I don't think it's a good idea to push requests out to stopped queue.
> Wouldn't aborting all pending requests be better? Thanks. 


How about the (lightly tested) patch below ? It combines three separate
changes:
- Making blk_drain_queue() ignore the stopped state of a queue.
- Add request_queue.kill_all_requests_fn.
- Fix a null pointer dereference triggered by sd during device removal.

Thanks,

Bart.

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a78b00..9429f1b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -375,8 +375,12 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 		 * (e.g. fd) get unhappy in such cases.  Kick queue iff
 		 * dispatch queue has something on it.
 		 */
-		if (!list_empty(&q->queue_head))
-			__blk_run_queue(q);
+		if (!list_empty(&q->queue_head)) {
+			if (blk_queue_dead(q) && q->kill_all_requests_fn)
+				q->kill_all_requests_fn(q);
+			else
+				q->request_fn(q);
+		}
 
 		drain |= q->rq.elvpriv;
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..9ce3df6 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -191,6 +191,13 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 }
 EXPORT_SYMBOL(blk_queue_make_request);
 
+void blk_queue_kill_all_requests(struct request_queue *q,
+				 kill_all_requests_fn *kfn)
+{
+	q->kill_all_requests_fn = kfn;
+}
+EXPORT_SYMBOL(blk_queue_kill_all_requests);
+
 /**
  * blk_queue_bounce_limit - set bounce buffer limit for queue
  * @q: the request queue for the device
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 351dc0b..5cf3a92 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -296,6 +296,12 @@ static void scsi_host_dev_release(struct device *dev)
 		destroy_workqueue(shost->work_q);
 	q = shost->uspace_req_q;
 	if (q) {
+		/*
+		 * Note: freeing queuedata before invoking scsi_free_queue()
+		 * is safe here because no request function is associated with
+		 * uspace_req_q. See also the __scsi_alloc_queue() call in
+		 * drivers/scsi/scsi_tgt_lib.c.
+		 */
 		kfree(q->queuedata);
 		q->queuedata = NULL;
 		scsi_free_queue(q);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2c95db..21ede38 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1468,6 +1468,14 @@ static void scsi_softirq_done(struct request *rq)
 	}
 }
 
+static void scsi_kill_all_requests(struct request_queue *q)
+{
+	struct request *req;
+
+	while ((req = blk_peek_request(q)) != NULL)
+		scsi_kill_request(req, q);
+}
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -1486,11 +1494,7 @@ static void scsi_request_fn(struct request_queue *q)
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if (!sdev) {
-		while ((req = blk_peek_request(q)) != NULL)
-			scsi_kill_request(req, q);
-		return;
-	}
+	BUG_ON(!sdev);
 
 	if(!get_device(&sdev->sdev_gendev))
 		/* We must be tearing the block queue down already */
@@ -1686,6 +1690,7 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 	if (!q)
 		return NULL;
 
+	blk_queue_kill_all_requests(q, scsi_kill_all_requests);
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_rq_timed_out(q, scsi_times_out);
@@ -1695,15 +1700,6 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 
 void scsi_free_queue(struct request_queue *q)
 {
-	unsigned long flags;
-
-	WARN_ON(q->queuedata);
-
-	/* cause scsi_request_fn() to kill all non-finished requests */
-	spin_lock_irqsave(q->queue_lock, flags);
-	q->request_fn(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	blk_cleanup_queue(q);
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..65801e9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -971,9 +971,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
-	/* cause the request function to reject all I/O requests */
-	sdev->request_queue->queuedata = NULL;
-
 	/* Freeing the queue signals to block that we're done */
 	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 606cf33..5a31e4c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -200,6 +200,7 @@ struct request_pm_state
 
 typedef void (request_fn_proc) (struct request_queue *q);
 typedef void (make_request_fn) (struct request_queue *q, struct bio *bio);
+typedef void (kill_all_requests_fn) (struct request_queue *q);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
 
@@ -282,6 +283,7 @@ struct request_queue {
 
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
+	kill_all_requests_fn	*kill_all_requests_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
 	merge_bvec_fn		*merge_bvec_fn;
@@ -825,6 +827,8 @@ extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
+extern void blk_queue_kill_all_requests(struct request_queue *,
+					kill_all_requests_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_limits_max_hw_sectors(struct queue_limits *, unsigned int);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
