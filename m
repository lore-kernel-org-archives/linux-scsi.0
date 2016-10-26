From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 12/12] nvme: Fix a race condition related to stopping queues
Date: Wed, 26 Oct 2016 15:56:28 -0700
Message-ID: <c84a33ce-e601-400b-f4c5-9c2ae4904f4f@sandisk.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b22edafc-725f-0419-d074-34d35d57d126-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Avoid that nvme_queue_rq() is still running when nvme_stop_queues()
returns.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/nvme/host/core.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b662416..d6ab9a0 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -201,13 +201,7 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct gendisk *disk)
 
 void nvme_requeue_req(struct request *req)
 {
-	unsigned long flags;
-
-	blk_mq_requeue_request(req, false);
-	spin_lock_irqsave(req->q->queue_lock, flags);
-	if (!blk_mq_queue_stopped(req->q))
-		blk_mq_kick_requeue_list(req->q);
-	spin_unlock_irqrestore(req->q->queue_lock, flags);
+	blk_mq_requeue_request(req, !blk_mq_queue_stopped(req->q));
 }
 EXPORT_SYMBOL_GPL(nvme_requeue_req);
 
@@ -2079,8 +2073,11 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		blk_mq_cancel_requeue_work(ns->queue);
-		blk_mq_stop_hw_queues(ns->queue);
+		struct request_queue *q = ns->queue;
+
+		blk_mq_cancel_requeue_work(q);
+		blk_mq_stop_hw_queues(q);
+		blk_mq_quiesce_queue(q);
 	}
 	mutex_unlock(&ctrl->namespaces_mutex);
 }
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
