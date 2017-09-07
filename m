From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 01/12] block: Fix declaration of blk-mq debugfs functions
Date: Fri,  8 Sep 2017 01:16:29 +0900
Message-ID: <20170907161640.30465-2-damien.lemoal@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170907161640.30465-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

__blk_mq_debugfs_rq_show() and blk_mq_debugfs_rq_show() are exported
symbols but ar eonly declared in the block internal file
block/blk-mq-debugfs.h. which is not cleanly accessible to files outside
of the block directory.
Move the declaration of these functions to the new file
include/linux/blk-mq-debugfs.h file to make the declarations cleanly
available to other modules.

While at it, also move the definition of the blk_mq_debugfs_attr
structure to allow scheduler modules outside of the block directory to
define debugfs attributes.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-mq-debugfs.h         | 14 +-------------
 include/linux/blk-mq-debugfs.h | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 13 deletions(-)
 create mode 100644 include/linux/blk-mq-debugfs.h

diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index a182e6f97565..4ffeae84b83a 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -3,19 +3,7 @@
 
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
+#include <linux/blk-mq-debugfs.h>
 
 int blk_mq_debugfs_register(struct request_queue *q);
 void blk_mq_debugfs_unregister(struct request_queue *q);
diff --git a/include/linux/blk-mq-debugfs.h b/include/linux/blk-mq-debugfs.h
new file mode 100644
index 000000000000..211537f61dce
--- /dev/null
+++ b/include/linux/blk-mq-debugfs.h
@@ -0,0 +1,23 @@
+#ifndef BLK_MQ_DEBUGFS_H
+#define BLK_MQ_DEBUGFS_H
+
+#ifdef CONFIG_BLK_DEBUG_FS
+
+#include <linux/blkdev.h>
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
+int __blk_mq_debugfs_rq_show(struct seq_file *m, struct request *rq);
+int blk_mq_debugfs_rq_show(struct seq_file *m, void *v);
+
+#endif
+
+#endif
-- 
2.13.5
