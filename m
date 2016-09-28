From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 3/7] [RFC] nvme: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Wed, 28 Sep 2016 16:59:07 -0700
Message-ID: <f12a5fd7-845e-b33b-1e8e-bf0423b52de5@sandisk.com>
References: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0083.outbound.protection.outlook.com ([104.47.33.83]:10080
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754582AbcI1X7P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Sep 2016 19:59:15 -0400
In-Reply-To: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Make nvme_requeue_req() check BLK_MQ_S_STOPPED instead of
QUEUE_FLAG_STOPPED. Remove the QUEUE_FLAG_STOPPED manipulations
that became superfluous because of this change. This patch fixes
a race condition: using queue_flag_clear_unlocked() is not safe
if any other function that manipulates the queue flags can be
called concurrently, e.g. blk_cleanup_queue(). Untested.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4669c05..d791fba 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -205,7 +205,7 @@ void nvme_requeue_req(struct request *req)
 
 	blk_mq_requeue_request(req);
 	spin_lock_irqsave(req->q->queue_lock, flags);
-	if (!blk_queue_stopped(req->q))
+	if (!blk_mq_queue_stopped(req->q))
 		blk_mq_kick_requeue_list(req->q);
 	spin_unlock_irqrestore(req->q->queue_lock, flags);
 }
@@ -2080,10 +2080,6 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		spin_lock_irq(ns->queue->queue_lock);
-		queue_flag_set(QUEUE_FLAG_STOPPED, ns->queue);
-		spin_unlock_irq(ns->queue->queue_lock);
-
 		blk_mq_cancel_requeue_work(ns->queue);
 		blk_mq_stop_hw_queues(ns->queue);
 	}
@@ -2097,7 +2093,6 @@ void nvme_start_queues(struct nvme_ctrl *ctrl)
 
 	mutex_lock(&ctrl->namespaces_mutex);
 	list_for_each_entry(ns, &ctrl->namespaces, list) {
-		queue_flag_clear_unlocked(QUEUE_FLAG_STOPPED, ns->queue);
 		blk_mq_start_stopped_hw_queues(ns->queue, true);
 		blk_mq_kick_requeue_list(ns->queue);
 	}
-- 
2.10.0

