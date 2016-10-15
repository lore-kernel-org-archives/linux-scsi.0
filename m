From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] blk-mq: export blk_mq_map_queues
Date: Sat, 15 Oct 2016 10:47:19 +0200
Message-ID: <1476521241-32765-2-git-send-email-hch@lst.de>
References: <1476521241-32765-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48103 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753522AbcJOIrf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Oct 2016 04:47:35 -0400
In-Reply-To: <1476521241-32765-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, don.brace@microsemi.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

This will allow SCSI to have a single blk_mq_ops structure that either
lets the LLDD map the queues to PCIe MSIx vectors or use the default.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.h         | 1 -
 include/linux/blk-mq.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.h b/block/blk-mq.h
index e5d2524..5347f01 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -38,7 +38,6 @@ void blk_mq_disable_hotplug(void);
 /*
  * CPU -> queue mappings
  */
-int blk_mq_map_queues(struct blk_mq_tag_set *set);
 extern int blk_mq_hw_queue_to_node(unsigned int *map, unsigned int);
 
 static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 535ab2e..6c0fb25 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -237,6 +237,7 @@ void blk_mq_unfreeze_queue(struct request_queue *q);
 void blk_mq_freeze_queue_start(struct request_queue *q);
 int blk_mq_reinit_tagset(struct blk_mq_tag_set *set);
 
+int blk_mq_map_queues(struct blk_mq_tag_set *set);
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
 
 /*
-- 
2.1.4

