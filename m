From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v5 14/14] nvme: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Fri, 28 Oct 2016 17:23:40 -0700
Message-ID: <fe057bf0-6ede-fc9e-9a53-9d790c9782c2@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Make nvme_requeue_req() check BLK_MQ_S_STOPPED instead of
QUEUE_FLAG_STOPPED. Remove the QUEUE_FLAG_STOPPED manipulations
that became superfluous because of this change. Change
blk_queue_stopped() tests into blk_mq_queue_stopped().

This patch fixes a race condition: using queue_flag_clear_unlocked()
is not safe if any other function that manipulates the queue flags
can be called concurrently, e.g. blk_cleanup_queue().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/core.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fe15d94..45dd237 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -201,13 +201,7 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct gendisk *disk)
 
 void nvme_requeue_req(struct request *req)
 {
-	unsigned long flags;
-
-	blk_mq_requeue_request(req, false);
-	spin_lock_irqsave(req->q->queue_lock, flags);
-	if (!blk_queue_stopped(req->q))
-		blk_mq_kick_requeue_list(req->q);
-	spin_unlock_irqrestore(req->q->queue_lock, flags);
+	blk_mq_requeue_request(req, !blk_mq_queue_stopped(req->q));
 }
 EXPORT_SYMBOL_GPL(nvme_requeue_req);
 
@@ -2078,13 +2072,8 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
 	struct nvme_ns *ns;
 
 	mutex_lock(&ctrl->namespaces_mutex);
-	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		spin_lock_irq(ns->queue->queue_lock);
-		queue_flag_set(QUEUE_FLAG_STOPPED, ns->queue);
-		spin_unlock_irq(ns->queue->queue_lock);
-
+	list_for_each_entry(ns, &ctrl->namespaces, list)
 		blk_mq_quiesce_queue(ns->queue);
-	}
 	mutex_unlock(&ctrl->namespaces_mutex);
 }
 EXPORT_SYMBOL_GPL(nvme_stop_queues);
@@ -2095,7 +2084,6 @@ void nvme_start_queues(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		queue_flag_clear_unlocked(QUEUE_FLAG_STOPPED, ns->queue);
 		blk_mq_start_stopped_hw_queues(ns->queue, true);
 		blk_mq_kick_requeue_list(ns->queue);
 	}
-- 
2.10.1

