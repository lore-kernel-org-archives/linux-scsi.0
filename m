From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 3/8] block: move flush initialized stuff to blk_flush_init
Date: Tue,  9 Sep 2014 21:05:44 +0800
Message-ID: <1410267949-21904-4-git-send-email-ming.lei@canonical.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

These stuff is always used with flush req together, so
we can do that safely.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-core.c  |    3 ---
 block/blk-flush.c |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0a9d172..222fe84 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -600,9 +600,6 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 #ifdef CONFIG_BLK_CGROUP
 	INIT_LIST_HEAD(&q->blkg_list);
 #endif
-	INIT_LIST_HEAD(&q->flush_queue[0]);
-	INIT_LIST_HEAD(&q->flush_queue[1]);
-	INIT_LIST_HEAD(&q->flush_data_in_flight);
 	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 6932ee8..a5b2a00 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -490,6 +490,10 @@ static int blk_mq_init_flush(struct request_queue *q)
 
 int blk_init_flush(struct request_queue *q)
 {
+	INIT_LIST_HEAD(&q->flush_queue[0]);
+	INIT_LIST_HEAD(&q->flush_queue[1]);
+	INIT_LIST_HEAD(&q->flush_data_in_flight);
+
 	if (q->mq_ops)
 		return blk_mq_init_flush(q);
 
-- 
1.7.9.5
