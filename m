From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 7/7] [RFC] nvme: Fix a race condition
Date: Wed, 28 Sep 2016 17:01:45 -0700
Message-ID: <ff412bfb-548c-c4fc-5180-78ede8a19ef2@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Avoid that nvme_queue_rq() is still running when nvme_stop_queues()
returns. Untested.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d791fba..98f1f29 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -201,13 +201,9 @@ fail:
 
 void nvme_requeue_req(struct request *req)
 {
-	unsigned long flags;
-
 	blk_mq_requeue_request(req);
-	spin_lock_irqsave(req->q->queue_lock, flags);
-	if (!blk_mq_queue_stopped(req->q))
-		blk_mq_kick_requeue_list(req->q);
-	spin_unlock_irqrestore(req->q->queue_lock, flags);
+	WARN_ON_ONCE(blk_mq_queue_stopped(req->q));
+	blk_mq_kick_requeue_list(req->q);
 }
 EXPORT_SYMBOL_GPL(nvme_requeue_req);
 
@@ -2077,11 +2073,19 @@ EXPORT_SYMBOL_GPL(nvme_kill_queues);
 void nvme_stop_queues(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
+	struct request_queue *q;
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		blk_mq_cancel_requeue_work(ns->queue);
-		blk_mq_stop_hw_queues(ns->queue);
+		q = ns->queue;
+		blk_mq_quiesce_queue(q);
+		blk_mq_cancel_requeue_work(q);
+		blk_mq_stop_hw_queues(q);
+		/*
+		 * Note: blk_mq_resume_queue() does not affect the value
+		 * of the BLK_MQ_S_STOPPED bit.
+		 */
+		blk_mq_resume_queue(q);
 	}
 	mutex_unlock(&ctrl->namespaces_mutex);
 }
-- 
2.10.0

