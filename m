From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] block: move SCSI timeout check into block
Date: Tue, 16 Dec 2008 17:00:44 -0500
Message-ID: <1229464844.3193.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49074 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754242AbYLPXV3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 18:21:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

We can eliminate the SCSI command timed out check entirely if the block
layer does this for us.  The way to do this in block is to check how
long the request has been outstanding if a requeue is requested and
ending it if we've gone over retries * timeout.

This will also eliminate many cases in SCSI where we evade the command
timeout for various reasons (like initial success converted to requeue)

James

---

diff --git a/block/blk-core.c b/block/blk-core.c
index c36aa98..d32af31 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -926,6 +926,8 @@ EXPORT_SYMBOL(blk_start_queueing);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
+	unsigned long wait_for = (rq->retries + 1) * rq->timeout;
+
 	blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
 	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
@@ -933,7 +935,17 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
 
-	elv_requeue_request(q, rq);
+	if (time_before(rq->start_time + wait_for, jiffies)) {
+		int bytes = (rq->hard_nr_sectors << 9);
+
+		printk(KERN_ERR "%s: timing out command, waited %lus\n",
+		       rq->rq_disk ? rq->rq_disk->disk_name : "?",
+		       wait_for/HZ);
+		if (blk_pc_request(rq))
+			bytes = rq->data_len;
+		blk_end_request(rq, -EIO, bytes);
+	} else
+		elv_requeue_request(q, rq);
 }
 EXPORT_SYMBOL(blk_requeue_request);
 


