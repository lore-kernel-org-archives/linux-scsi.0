From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/8] block: Fix declaration of blk-mq debugfs functions
Date: Fri,  1 Sep 2017 20:36:24 +0900
Message-ID: <20170901113631.12323-2-damien.lemoal@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901113631.12323-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

__blk_mq_debugfs_rq_show() and blk_mq_debugfs_rq_show() are exported
symbols but declared in the block internal file block/blk-mq-debugfs.h.
Move the declaration of these functions to the public linux/blk-mq.h
file to make these functions available to other modules.

While at it, also move the definition of the blk_mq_debugfs_attr
strcture to allow scheduler modules outside of block to define debugfs
attributes.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-mq-debugfs.h | 14 --------------
 include/linux/blk-mq.h | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index a182e6f97565..85759aef53e1 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -3,20 +3,6 @@
 
 #ifdef CONFIG_BLK_DEBUG_FS
 
-#include <linux/seq_file.h>
-
-struct blk_mq_debugfs_attr {
-	const char *name;
-	umode_t mode;
-	int (*show)(void *, struct seq_file *);
-	ssize_t (*write)(void *, const char __user *, size_t, loff_t *);
-	/* Set either .show or .seq_ops. */
-	const struct seq_operations *seq_ops;
-};
-
-int __blk_mq_debugfs_rq_show(struct seq_file *m, struct request *rq);
-int blk_mq_debugfs_rq_show(struct seq_file *m, void *v);
-
 int blk_mq_debugfs_register(struct request_queue *q);
 void blk_mq_debugfs_unregister(struct request_queue *q);
 int blk_mq_debugfs_register_hctx(struct request_queue *q,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 14542308d25b..a369174a9679 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -5,6 +5,21 @@
 #include <linux/sbitmap.h>
 #include <linux/srcu.h>
 
+#ifdef CONFIG_BLK_DEBUG_FS
+
+#include <linux/seq_file.h>
+
+struct blk_mq_debugfs_attr {
+	const char *name;
+	umode_t mode;
+	int (*show)(void *, struct seq_file *);
+	ssize_t (*write)(void *, const char __user *, size_t, loff_t *);
+	/* Set either .show or .seq_ops. */
+	const struct seq_operations *seq_ops;
+};
+
+#endif
+
 struct blk_mq_tags;
 struct blk_flush_queue;
 
@@ -289,4 +304,9 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	for ((i) = 0; (i) < (hctx)->nr_ctx &&				\
 	     ({ ctx = (hctx)->ctxs[(i)]; 1; }); (i)++)
 
+#ifdef CONFIG_BLK_DEBUG_FS
+int __blk_mq_debugfs_rq_show(struct seq_file *m, struct request *rq);
+int blk_mq_debugfs_rq_show(struct seq_file *m, void *v);
+#endif
+
 #endif
-- 
2.13.5
