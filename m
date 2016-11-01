From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] blk-mq: export blk_mq_map_queues
Date: Tue,  1 Nov 2016 08:12:47 -0600
Message-ID: <1478009569-19026-2-git-send-email-hch@lst.de>
References: <1478009569-19026-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34183 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966239AbcKAOMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 10:12:54 -0400
In-Reply-To: <1478009569-19026-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, don.brace@microsemi.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

This will allow SCSI to have a single blk_mq_ops structure that either
lets the LLDD map the queues to PCIe MSIx vectors or use the default.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-mq-cpumap.c  | 1 +
 block/blk-mq.h         | 1 -
 include/linux/blk-mq.h | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 19b1d9c..8e61e86 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -87,6 +87,7 @@ int blk_mq_map_queues(struct blk_mq_tag_set *set)
 	free_cpumask_var(cpus);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_mq_map_queues);
 
 /*
  * We have no quick way of doing reverse lookups. This is only used at
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

