From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/18] mtd_blkdevs: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:11 +0900
Message-ID: <1241751256-17435-14-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

mtd_blkdevs processes requests one-by-one synchronously from a kthread
and can be easily converted to dequeueing model.  Convert it.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/mtd_blkdevs.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 50c76a2..3e10442 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -89,18 +89,22 @@ static int mtd_blktrans_thread(void *arg)
 {
 	struct mtd_blktrans_ops *tr = arg;
 	struct request_queue *rq = tr->blkcore_priv->rq;
+	struct request *req = NULL;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
 	current->flags |= PF_MEMALLOC;
 
 	spin_lock_irq(rq->queue_lock);
+
 	while (!kthread_should_stop()) {
-		struct request *req;
 		struct mtd_blktrans_dev *dev;
 		int res;
 
-		req = elv_next_request(rq);
-
+		if (!req) {
+			req = elv_next_request(rq);
+			if (req)
+				blkdev_dequeue_request(req);
+		}
 		if (!req) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_irq(rq->queue_lock);
@@ -120,8 +124,13 @@ static int mtd_blktrans_thread(void *arg)
 
 		spin_lock_irq(rq->queue_lock);
 
-		__blk_end_request_cur(req, res);
+		if (!__blk_end_request_cur(req, res))
+			req = NULL;
 	}
+
+	if (req)
+		__blk_end_request_all(req, -EIO);
+
 	spin_unlock_irq(rq->queue_lock);
 
 	return 0;
-- 
1.6.0.2

