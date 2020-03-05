Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87EAC3F2D7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BB8B20848
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgCEL7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:59:02 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726894AbgCEL7C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 06:59:02 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ECEF31612FBD43E28849;
        Thu,  5 Mar 2020 19:58:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 19:58:53 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.de>, <don.brace@microsemi.com>,
        <sumit.saxena@broadcom.com>, <hch@infradead.org>,
        <kashyap.desai@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <chenxiang66@hisilicon.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v6 02/10] blk-mq: rename blk_mq_update_tag_set_depth()
Date:   Thu, 5 Mar 2020 19:54:32 +0800
Message-ID: <1583409280-158604-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
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
index 42792942b428..4643ad86cf8b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -432,24 +432,22 @@ static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,
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
@@ -470,7 +468,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
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
index 80c81da62174..9e350c646141 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2610,8 +2610,8 @@ static void queue_set_hctx_shared(struct request_queue *q, bool shared)
 	}
 }
 
-static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set,
-					bool shared)
+static void blk_mq_update_tag_set_shared(struct blk_mq_tag_set *set,
+					 bool shared)
 {
 	struct request_queue *q;
 
@@ -2634,7 +2634,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
-		blk_mq_update_tag_set_depth(set, false);
+		blk_mq_update_tag_set_shared(set, false);
 	}
 	mutex_unlock(&set->tag_list_lock);
 	INIT_LIST_HEAD(&q->tag_set_list);
@@ -2652,7 +2652,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	    !(set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
 		set->flags |= BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
-		blk_mq_update_tag_set_depth(set, true);
+		blk_mq_update_tag_set_shared(set, true);
 	}
 	if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
 		queue_set_hctx_shared(q, true);
-- 
2.17.1

