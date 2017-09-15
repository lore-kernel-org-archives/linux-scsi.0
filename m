From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 02/12] block: Fix declaration of blk-mq scheduler functions
Date: Fri, 15 Sep 2017 19:06:35 +0900
Message-ID: <20170915100645.17999-3-damien.lemoal@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:45913 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdIOKHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 06:07:33 -0400
In-Reply-To: <20170915100645.17999-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

The functions blk_mq_sched_free_hctx_data(), blk_mq_sched_try_merge(),
blk_mq_sched_try_insert_merge() and blk_mq_sched_request_inserted() are
all exported symbols but are declared only internally in
block/blk-mq-sched.h. Move these declarations to the new file
include/linux/blk-mq-sched.h to make them available to block scheduler
modules implemented outside of the block directory.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-mq-sched.h         | 11 +++--------
 include/linux/blk-mq-sched.h | 14 ++++++++++++++
 2 files changed, 17 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/blk-mq-sched.h

diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 9267d0b7c197..f48f3c8edcb3 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -1,19 +1,14 @@
-#ifndef BLK_MQ_SCHED_H
-#define BLK_MQ_SCHED_H
+#ifndef INT_BLK_MQ_SCHED_H
+#define INT_BLK_MQ_SCHED_H
 
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
-void blk_mq_sched_free_hctx_data(struct request_queue *q,
-				 void (*exit)(struct blk_mq_hw_ctx *));
+#include <linux/blk-mq-sched.h>
 
 void blk_mq_sched_assign_ioc(struct request *rq, struct bio *bio);
 
-void blk_mq_sched_request_inserted(struct request *rq);
-bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
-				struct request **merged_request);
 bool __blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio);
-bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq);
 void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx);
 
 void blk_mq_sched_insert_request(struct request *rq, bool at_head,
diff --git a/include/linux/blk-mq-sched.h b/include/linux/blk-mq-sched.h
new file mode 100644
index 000000000000..8ae1992e02c6
--- /dev/null
+++ b/include/linux/blk-mq-sched.h
@@ -0,0 +1,14 @@
+#ifndef BLK_MQ_SCHED_H
+#define BLK_MQ_SCHED_H
+
+/*
+ * Scheduler helper functions.
+ */
+void blk_mq_sched_free_hctx_data(struct request_queue *q,
+				 void (*exit)(struct blk_mq_hw_ctx *));
+void blk_mq_sched_request_inserted(struct request *rq);
+bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
+			    struct request **merged_request);
+bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq);
+
+#endif
-- 
2.13.5
