From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 3/9] blk-mq: use the introduced blk_mq_unquiesce_queue()
Date: Wed, 31 May 2017 20:37:00 +0800
Message-ID: <20170531123706.20885-4-ming.lei@redhat.com>
References: <20170531123706.20885-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170531123706.20885-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Ming Lei <ming.lei@redhat.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

blk_mq_unquiesce_queue() is used for unquiescing the
queue explicitly, so replace blk_mq_start_stopped_hw_queues()
with it.

Cc: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c       | 2 +-
 drivers/nvme/host/core.c | 2 +-
 drivers/scsi/scsi_lib.c  | 5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index b639fa7246ee..ea4029de077f 100644
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
index a60926410438..c3f189e54d10 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2526,7 +2526,7 @@ void nvme_start_queues(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		blk_mq_start_stopped_hw_queues(ns->queue, true);
+		blk_mq_unquiesce_queue(ns->queue);
 		blk_mq_kick_requeue_list(ns->queue);
 	}
 	mutex_unlock(&ctrl->namespaces_mutex);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 99e16ac479e3..ffcf05765e2b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3031,7 +3031,10 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
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
