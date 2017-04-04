From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] block: Implement global tagset
Date: Tue,  4 Apr 2017 14:07:44 +0200
Message-ID: <1491307665-47656-2-git-send-email-hare@suse.de>
References: <1491307665-47656-1-git-send-email-hare@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1491307665-47656-1-git-send-email-hare@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Most legacy HBAs have a tagset per HBA, not per queue. To map
these devices onto block-mq this patch implements a new tagset
flag BLK_MQ_F_GLOBAL_TAGS, which will cause the tag allocator
to use just one tagset for all hardware queues.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq-tag.c     | 12 ++++++++----
 block/blk-mq.c         | 10 ++++++++--
 include/linux/blk-mq.h |  1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index e48bc2c..a14e76c 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -276,9 +276,11 @@ static void blk_mq_all_tag_busy_iter(struct blk_mq_tags *tags,
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv)
 {
-	int i;
+	int i, lim = tagset->nr_hw_queues;
 
-	for (i = 0; i < tagset->nr_hw_queues; i++) {
+	if (tagset->flags & BLK_MQ_F_GLOBAL_TAGS)
+		lim = 1;
+	for (i = 0; i < lim; i++) {
 		if (tagset->tags && tagset->tags[i])
 			blk_mq_all_tag_busy_iter(tagset->tags[i], fn, priv);
 	}
@@ -287,12 +289,14 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 
 int blk_mq_reinit_tagset(struct blk_mq_tag_set *set)
 {
-	int i, j, ret = 0;
+	int i, j, ret = 0, lim = set->nr_hw_queues;
 
 	if (!set->ops->reinit_request)
 		goto out;
 
-	for (i = 0; i < set->nr_hw_queues; i++) {
+	if (set->flags & BLK_MQ_F_GLOBAL_TAGS)
+		lim = 1;
+	for (i = 0; i < lim; i++) {
 		struct blk_mq_tags *tags = set->tags[i];
 
 		for (j = 0; j < tags->nr_tags; j++) {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 159187a..db96ed0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2061,6 +2061,10 @@ static bool __blk_mq_alloc_rq_map(struct blk_mq_tag_set *set, int hctx_idx)
 {
 	int ret = 0;
 
+	if ((set->flags & BLK_MQ_F_GLOBAL_TAGS) && hctx_idx != 0) {
+		set->tags[hctx_idx] = set->tags[0];
+		return true;
+	}
 	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
 					set->queue_depth, set->reserved_tags);
 	if (!set->tags[hctx_idx])
@@ -2080,8 +2084,10 @@ static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
 					 unsigned int hctx_idx)
 {
 	if (set->tags[hctx_idx]) {
-		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
-		blk_mq_free_rq_map(set->tags[hctx_idx]);
+		if (!(set->flags & BLK_MQ_F_GLOBAL_TAGS) || hctx_idx == 0) {
+			blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
+			blk_mq_free_rq_map(set->tags[hctx_idx]);
+		}
 		set->tags[hctx_idx] = NULL;
 	}
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b296a90..eee27b016 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -155,6 +155,7 @@ enum {
 	BLK_MQ_F_DEFER_ISSUE	= 1 << 4,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
+	BLK_MQ_F_GLOBAL_TAGS	= 1 << 7,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
 	BLK_MQ_F_ALLOC_POLICY_BITS = 1,
 
-- 
1.8.5.6
