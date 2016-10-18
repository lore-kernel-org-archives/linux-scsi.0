From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 11/11] nvme: Fix a race condition
Date: Tue, 18 Oct 2016 14:53:35 -0700
Message-ID: <2a29b7ec-0113-3450-9a36-b925b47b1fb0@sandisk.com>
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

Avoid that nvme_queue_rq() is still running when nvme_stop_queues()
returns.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 18a265d..96f00c7 100644
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
+	blk_mq_requeue_request(req, true);
 }
 EXPORT_SYMBOL_GPL(nvme_requeue_req);
 
@@ -2074,11 +2068,14 @@ EXPORT_SYMBOL_GPL(nvme_kill_queues);
 void nvme_stop_queues(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
+	struct request_queue *q;
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		blk_mq_cancel_requeue_work(ns->queue);
-		blk_mq_stop_hw_queues(ns->queue);
+		q = ns->queue;
+		blk_mq_cancel_requeue_work(q);
+		blk_mq_stop_hw_queues(q);
+		blk_mq_quiesce_queue(q);
 	}
 	mutex_unlock(&ctrl->namespaces_mutex);
 }
-- 
2.10.1

