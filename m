Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1418BC43215
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85EA2146E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfLBPj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 10:39:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:44716 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727549AbfLBPj1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Dec 2019 10:39:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E5A7C1A7;
        Mon,  2 Dec 2019 15:39:25 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/11] blk-mq: rename blk_mq_update_tag_set_depth()
Date:   Mon,  2 Dec 2019 16:39:06 +0100
Message-Id: <20191202153914.84722-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191202153914.84722-1-hare@suse.de>
References: <20191202153914.84722-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function does not set the depth, but rather transitions from
shared to non-shared queues and vice versa.
So rename it to blk_mq_update_tag_set_shared() to better reflect
its purpose.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq-tag.c | 18 ++++++++++--------
 block/blk-mq.c     |  8 ++++----
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d7aa23c82dbf..f5009587e1b5 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -440,24 +440,22 @@ static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,
 				       node);
 }
 
-static struct blk_mq_tags *blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
-						   int node, int alloc_policy)
+static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
+				   int node, int alloc_policy)
 {
 	unsigned int depth = tags->nr_tags - tags->nr_reserved_tags;
 	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
 
 	if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
-		goto free_tags;
+		return -ENOMEM;
 	if (bt_alloc(&tags->breserved_tags, tags->nr_reserved_tags, round_robin,
 		     node))
 		goto free_bitmap_tags;
 
-	return tags;
+	return 0;
 free_bitmap_tags:
 	sbitmap_queue_free(&tags->bitmap_tags);
-free_tags:
-	kfree(tags);
-	return NULL;
+	return -ENOMEM;
 }
 
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
@@ -478,7 +476,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_tags = total_tags;
 	tags->nr_reserved_tags = reserved_tags;
 
-	return blk_mq_init_bitmap_tags(tags, node, alloc_policy);
+	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
+		kfree(tags);
+		tags = NULL;
+	}
+	return tags;
 }
 
 void blk_mq_free_tags(struct blk_mq_tags *tags)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6b39cf0efdcd..91950d3e436a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2581,8 +2581,8 @@ static void queue_set_hctx_shared(struct request_queue *q, bool shared)
 	}
 }
 
-static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set,
-					bool shared)
+static void blk_mq_update_tag_set_shared(struct blk_mq_tag_set *set,
+					 bool shared)
 {
 	struct request_queue *q;
 
@@ -2605,7 +2605,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
-		blk_mq_update_tag_set_depth(set, false);
+		blk_mq_update_tag_set_shared(set, false);
 	}
 	mutex_unlock(&set->tag_list_lock);
 	INIT_LIST_HEAD(&q->tag_set_list);
@@ -2623,7 +2623,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	    !(set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
 		set->flags |= BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
-		blk_mq_update_tag_set_depth(set, true);
+		blk_mq_update_tag_set_shared(set, true);
 	}
 	if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
 		queue_set_hctx_shared(q, true);
-- 
2.16.4

