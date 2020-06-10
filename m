Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8EEC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AA702070B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgFJRdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 13:33:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5813 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbgFJRdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 13:33:35 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3A5C1CE5B94ED033FB87;
        Thu, 11 Jun 2020 01:33:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 11 Jun 2020 01:33:18 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>, <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
Date:   Thu, 11 Jun 2020 01:29:09 +0800
Message-ID: <1591810159-240929-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

The function does not set the depth, but rather transitions from
shared to non-shared queues and vice versa.
So rename it to blk_mq_update_tag_set_shared() to better reflect
its purpose.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-tag.c | 18 ++++++++++--------
 block/blk-mq.c     |  8 ++++----
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 85aa1690cbcf..bedddf168253 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -454,24 +454,22 @@ static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,
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
@@ -492,7 +490,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
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
index d255c485ca5f..c20d75c851f2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2802,8 +2802,8 @@ static void queue_set_hctx_shared(struct request_queue *q, bool shared)
 	}
 }
 
-static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set,
-					bool shared)
+static void blk_mq_update_tag_set_shared(struct blk_mq_tag_set *set,
+					 bool shared)
 {
 	struct request_queue *q;
 
@@ -2826,7 +2826,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
-		blk_mq_update_tag_set_depth(set, false);
+		blk_mq_update_tag_set_shared(set, false);
 	}
 	mutex_unlock(&set->tag_list_lock);
 	INIT_LIST_HEAD(&q->tag_set_list);
@@ -2844,7 +2844,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	    !(set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
 		set->flags |= BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
-		blk_mq_update_tag_set_depth(set, true);
+		blk_mq_update_tag_set_shared(set, true);
 	}
 	if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
 		queue_set_hctx_shared(q, true);
-- 
2.26.2

