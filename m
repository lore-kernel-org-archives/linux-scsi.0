From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 2/7] dm: Use BLK_MQ_S_STOPPED instead of QUEUE_FLAG_STOPPED
 in blk-mq code
Date: Wed, 28 Sep 2016 16:58:33 -0700
Message-ID: <03abff7f-c882-aae7-b5db-8ca9b56e6e3a@sandisk.com>
References: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0058.outbound.protection.outlook.com ([104.47.40.58]:50816
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750812AbcI2AOE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Sep 2016 20:14:04 -0400
In-Reply-To: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 182b679..f2c271a 100644
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
2.10.0

