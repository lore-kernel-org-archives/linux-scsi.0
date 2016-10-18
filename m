From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 06/11] dm: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Tue, 18 Oct 2016 14:51:33 -0700
Message-ID: <e5facfd0-82d5-10cb-712b-13d7950b78b8@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Instead of manipulating both QUEUE_FLAG_STOPPED and BLK_MQ_S_STOPPED
in the dm start and stop queue functions, only manipulate the latter
flag.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index d5cec26..9c34606 100644
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

