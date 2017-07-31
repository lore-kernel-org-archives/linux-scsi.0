From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 02/14] blk-mq: rename flush_busy_ctx_data as ctx_iter_data
Date: Tue,  1 Aug 2017 00:50:59 +0800
Message-ID: <20170731165111.11536-4-ming.lei@redhat.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170731165111.11536-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The following patch need to reuse this data structure,
so rename as one generic name.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b70a4ad78b63..94818f78c099 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -808,14 +808,14 @@ static void blk_mq_timeout_work(struct work_struct *work)
 	blk_queue_exit(q);
 }
 
-struct flush_busy_ctx_data {
+struct ctx_iter_data {
 	struct blk_mq_hw_ctx *hctx;
 	struct list_head *list;
 };
 
 static bool flush_busy_ctx(struct sbitmap *sb, unsigned int bitnr, void *data)
 {
-	struct flush_busy_ctx_data *flush_data = data;
+	struct ctx_iter_data *flush_data = data;
 	struct blk_mq_hw_ctx *hctx = flush_data->hctx;
 	struct blk_mq_ctx *ctx = hctx->ctxs[bitnr];
 
@@ -832,7 +832,7 @@ static bool flush_busy_ctx(struct sbitmap *sb, unsigned int bitnr, void *data)
  */
 void blk_mq_flush_busy_ctxs(struct blk_mq_hw_ctx *hctx, struct list_head *list)
 {
-	struct flush_busy_ctx_data data = {
+	struct ctx_iter_data data = {
 		.hctx = hctx,
 		.list = list,
 	};
-- 
2.9.4
