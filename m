From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v4 05/11] blk-mq: use the introduced blk_mq_unquiesce_queue()
Date: Mon,  5 Jun 2017 23:59:19 +0800
Message-ID: <20170605155925.7896-6-ming.lei@redhat.com>
References: <20170605155925.7896-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170605155925.7896-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Ming Lei <ming.lei@redhat.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

blk_mq_unquiesce_queue() is used for unquiescing the
queue explicitly, so replace blk_mq_start_stopped_hw_queues()
with it.

For the scsi part, this patch takes Bart's suggestion to
switch to block quiesce/unquiesce API completely.

Cc: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c       | 2 +-
 drivers/nvme/host/core.c | 2 +-
 drivers/scsi/scsi_lib.c  | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

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
index 884aaa84c2dd..d6df1dafdc9f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2979,7 +2979,7 @@ scsi_internal_device_block(struct scsi_device *sdev, bool wait)
 		if (wait)
 			blk_mq_quiesce_queue(q);
 		else
-			blk_mq_stop_hw_queues(q);
+			blk_mq_quiesce_queue_nowait(q);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_stop_queue(q);
@@ -3033,7 +3033,7 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 		return -EINVAL;
 
 	if (q->mq_ops) {
-		blk_mq_start_stopped_hw_queues(q, false);
+		blk_mq_unquiesce_queue(q);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_start_queue(q);
-- 
2.9.4
