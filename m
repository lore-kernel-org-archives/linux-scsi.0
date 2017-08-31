From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 6/9] blk-mq: rename blk_mq_freeze_queue_wait as blk_freeze_queue_wait
Date: Fri,  1 Sep 2017 01:27:25 +0800
Message-ID: <20170831172728.15817-7-ming.lei@redhat.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbdHaR3N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 13:29:13 -0400
In-Reply-To: <20170831172728.15817-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>

The only change on legacy is that blk_drain_queue() is run
from blk_freeze_queue(), which is called in blk_cleanup_queue().

So this patch removes the explicite __blk_drain_queue() in
blk_cleanup_queue().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c         | 2 --
 block/blk-mq.c           | 8 +++++---
 drivers/nvme/host/core.c | 2 +-
 include/linux/blk-mq.h   | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 636452f151ea..7a9f93889669 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -669,8 +669,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	 */
 	blk_freeze_queue(q);
 	spin_lock_irq(lock);
-	if (!q->mq_ops)
-		__blk_drain_queue(q, true);
 	queue_flag_set(QUEUE_FLAG_DEAD, q);
 	spin_unlock_irq(lock);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c532d8612e1..24de78afbe9a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -131,11 +131,13 @@ void blk_freeze_queue_start(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
-void blk_mq_freeze_queue_wait(struct request_queue *q)
+void blk_freeze_queue_wait(struct request_queue *q)
 {
+	if (!q->mq_ops)
+		blk_drain_queue(q);
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
 }
-EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);
+EXPORT_SYMBOL_GPL(blk_freeze_queue_wait);
 
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout)
@@ -160,7 +162,7 @@ void blk_freeze_queue(struct request_queue *q)
 	 * exported to drivers as the only user for unfreeze is blk_mq.
 	 */
 	blk_freeze_queue_start(q);
-	blk_mq_freeze_queue_wait(q);
+	blk_freeze_queue_wait(q);
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue);
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 986f2b4f9760..d34a9ffaa940 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2778,7 +2778,7 @@ void nvme_wait_freeze(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list)
-		blk_mq_freeze_queue_wait(ns->queue);
+		blk_freeze_queue_wait(ns->queue);
 	mutex_unlock(&ctrl->namespaces_mutex);
 }
 EXPORT_SYMBOL_GPL(nvme_wait_freeze);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8ae77e088c01..f90d78eb85df 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -259,7 +259,7 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 void blk_freeze_queue(struct request_queue *q);
 void blk_unfreeze_queue(struct request_queue *q);
 void blk_freeze_queue_start(struct request_queue *q);
-void blk_mq_freeze_queue_wait(struct request_queue *q);
+void blk_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
 int blk_mq_reinit_tagset(struct blk_mq_tag_set *set,
-- 
2.9.5
