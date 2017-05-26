From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/6] blk-mq: use the introduced blk_mq_unquiesce_queue()
Date: Fri, 26 May 2017 11:07:35 +0800
Message-ID: <20170526030740.26959-3-ming.lei@redhat.com>
References: <20170526030740.26959-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170526030740.26959-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

blk_mq_unquiesce_queue() is used for unquiescing the queue.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c       | 2 +-
 drivers/nvme/host/core.c | 2 +-
 drivers/scsi/scsi_lib.c  | 5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 2af27026aa2e..673fcf075077 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -71,7 +71,7 @@ static void dm_old_start_queue(struct request_queue *q)
 
 static void dm_mq_start_queue(struct request_queue *q)
 {
-	blk_mq_start_stopped_hw_queues(q, true);
+	blk_mq_unquiesce_queue(q);
 	blk_mq_kick_requeue_list(q);
 }
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 04e115834702..231d36028afc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2514,7 +2514,7 @@ void nvme_start_queues(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		blk_mq_start_stopped_hw_queues(ns->queue, true);
+		blk_mq_unquiesce_queue(ns->queue);
 		blk_mq_kick_requeue_list(ns->queue);
 	}
 	mutex_unlock(&ctrl->namespaces_mutex);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 814a4bd8405d..72b11f75719c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3030,7 +3030,10 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 		return -EINVAL;
 
 	if (q->mq_ops) {
-		blk_mq_start_stopped_hw_queues(q, false);
+		if (blk_queue_quiesced(q))
+			blk_mq_unquiesce_queue(q);
+		else
+			blk_mq_start_stopped_hw_queues(q, false);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_start_queue(q);
-- 
2.9.4
