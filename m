From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/7] blk-mq: don't wait in blk_mq_queue_enter() if __GFP_WAIT isn't set
Date: Wed, 11 Mar 2015 23:56:39 -0400
Message-ID: <1426132602-34331-5-git-send-email-snitzer@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbbCLD4v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Mar 2015 23:56:51 -0400
In-Reply-To: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

From: Keith Busch <keith.busch@intel.com>

Return -EBUSY if we're unable to enter a queue immediately when
allocating a blk-mq request without __GFP_WAIT.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5706dd9..01b2912 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -77,7 +77,7 @@ static void blk_mq_hctx_clear_pending(struct blk_mq_hw_ctx *hctx,
 	clear_bit(CTX_TO_BIT(hctx, ctx), &bm->word);
 }
 
-static int blk_mq_queue_enter(struct request_queue *q)
+static int blk_mq_queue_enter(struct request_queue *q, gfp_t gfp)
 {
 	while (true) {
 		int ret;
@@ -85,6 +85,9 @@ static int blk_mq_queue_enter(struct request_queue *q)
 		if (percpu_ref_tryget_live(&q->mq_usage_counter))
 			return 0;
 
+		if (!(gfp & __GFP_WAIT))
+			return -EBUSY;
+
 		ret = wait_event_interruptible(q->mq_freeze_wq,
 				!q->mq_freeze_depth || blk_queue_dying(q));
 		if (blk_queue_dying(q))
@@ -256,7 +259,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp,
 	struct blk_mq_alloc_data alloc_data;
 	int ret;
 
-	ret = blk_mq_queue_enter(q);
+	ret = blk_mq_queue_enter(q, gfp);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -1186,7 +1189,7 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	int rw = bio_data_dir(bio);
 	struct blk_mq_alloc_data alloc_data;
 
-	if (unlikely(blk_mq_queue_enter(q))) {
+	if (unlikely(blk_mq_queue_enter(q, GFP_KERNEL))) {
 		bio_endio(bio, -EIO);
 		return NULL;
 	}
-- 
1.9.5 (Apple Git-50.3)

