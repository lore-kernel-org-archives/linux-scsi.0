Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241FFC07E9C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E6A5613CB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbhGNPOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 11:14:16 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3407 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239611AbhGNPOP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 11:14:15 -0400
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GQ0vq10X7z6D91S;
        Wed, 14 Jul 2021 22:56:55 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:11:21 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 16:11:19 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 4/9] blk-mq: Add blk_mq_tag_resize_sched_shared_sbitmap()
Date:   Wed, 14 Jul 2021 23:06:30 +0800
Message-ID: <1626275195-215652-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Put the functionality to resize the sched shared sbitmap in a common
function.

Since the same formula is always used to resize, and it can be got from
the request queue argument, so just pass the request queue pointer.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-sched.c |  3 +--
 block/blk-mq-tag.c   | 10 ++++++++++
 block/blk-mq-tag.h   |  1 +
 block/blk-mq.c       |  3 +--
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index f5cb2931c20d..1e028183557d 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -584,8 +584,7 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
 					&queue->sched_breserved_tags;
 	}
 
-	sbitmap_queue_resize(&queue->sched_bitmap_tags,
-			     queue->nr_requests - set->reserved_tags);
+	blk_mq_tag_resize_sched_shared_sbitmap(queue);
 
 	return 0;
 }
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 86f87346232a..55c7f1bf41c7 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -634,6 +634,16 @@ void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int s
 	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
 }
 
+/*
+ * We always resize with q->nr_requests - q->tag_set->reserved_tags, so
+ * don't bother passing a size.
+ */
+void blk_mq_tag_resize_sched_shared_sbitmap(struct request_queue *q)
+{
+	sbitmap_queue_resize(&q->sched_bitmap_tags,
+			     q->nr_requests - q->tag_set->reserved_tags);
+}
+
 /**
  * blk_mq_unique_tag() - return a tag that is unique queue-wide
  * @rq: request for which to compute a unique tag
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 8ed55af08427..3a7495e47fb4 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -48,6 +48,7 @@ extern int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 					unsigned int depth, bool can_grow);
 extern void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set,
 					     unsigned int size);
+extern void blk_mq_tag_resize_sched_shared_sbitmap(struct request_queue *q);
 
 extern void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
 void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 56e3c6fdba60..b0d4197d36c7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3643,8 +3643,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		q->nr_requests = nr;
 		if (blk_mq_is_sbitmap_shared(set->flags)) {
 			if (q->elevator) {
-				sbitmap_queue_resize(&q->sched_bitmap_tags,
-						     nr - set->reserved_tags);
+				blk_mq_tag_resize_sched_shared_sbitmap(q);
 			} else {
 				blk_mq_tag_resize_shared_sbitmap(set, nr);
 			}
-- 
2.26.2

