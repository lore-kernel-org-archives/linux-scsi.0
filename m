From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/12] dm: Use BLK_MQ_S_STOPPED instead of QUEUE_FLAG_STOPPED
 in blk-mq code
Date: Wed, 26 Oct 2016 15:54:07 -0700
Message-ID: <a0733adf-065e-2099-3850-cb1c55df1e35@sandisk.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0080.outbound.protection.outlook.com ([104.47.41.80]:22688
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932707AbcJZWyY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 18:54:24 -0400
In-Reply-To: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Instead of manipulating both QUEUE_FLAG_STOPPED and BLK_MQ_S_STOPPED
in the dm start and stop queue functions, only manipulate the latter
flag. Change blk_queue_stopped() tests into blk_mq_queue_stopped().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index fbd37b4..d47a504 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -75,12 +75,6 @@ static void dm_old_start_queue(struct request_queue *q)
 
 static void dm_mq_start_queue(struct request_queue *q)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	blk_mq_start_stopped_hw_queues(q, true);
 	blk_mq_kick_requeue_list(q);
 }
@@ -105,16 +99,8 @@ static void dm_old_stop_queue(struct request_queue *q)
 
 static void dm_mq_stop_queue(struct request_queue *q)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_queue_stopped(q)) {
-		spin_unlock_irqrestore(q->queue_lock, flags);
+	if (blk_mq_queue_stopped(q))
 		return;
-	}
-
-	queue_flag_set(QUEUE_FLAG_STOPPED, q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	/* Avoid that requeuing could restart the queue. */
 	blk_mq_cancel_requeue_work(q);
@@ -341,7 +327,7 @@ static void __dm_mq_kick_requeue_list(struct request_queue *q, unsigned long mse
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (!blk_queue_stopped(q))
+	if (!blk_mq_queue_stopped(q))
 		blk_mq_delay_kick_requeue_list(q, msecs);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
-- 
2.10.1

