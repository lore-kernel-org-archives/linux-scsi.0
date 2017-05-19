From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 01/18] block: Introduce blk_queue_cmd_size()
Date: Fri, 19 May 2017 11:29:59 -0700
Message-ID: <20170519183016.12646-2-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This function will be used by later patches in this series.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: linux-block@vger.kernel.org
---
 block/blk-core.c       | 10 ++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index c7068520794b..a69d420b7ff0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -601,6 +601,16 @@ static void free_request_simple(void *element, void *data)
 	kmem_cache_free(request_cachep, element);
 }
 
+/**
+ * blk_queue_cmd_size - size in bytes of driver-private request data
+ * @q: request queue pointer
+ */
+int blk_queue_cmd_size(struct request_queue *q)
+{
+	return q->mq_ops ? q->tag_set->cmd_size : q->cmd_size;
+}
+EXPORT_SYMBOL_GPL(blk_queue_cmd_size);
+
 static void *alloc_request_size(gfp_t gfp_mask, void *data)
 {
 	struct request_queue *q = data;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b5d1e27631ee..75b71374e1ba 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1212,6 +1212,7 @@ extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatte
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
+int blk_queue_cmd_size(struct request_queue *q);
 bool __must_check blk_get_queue(struct request_queue *);
 struct request_queue *blk_alloc_queue(gfp_t);
 struct request_queue *blk_alloc_queue_node(gfp_t, int);
-- 
2.12.2
