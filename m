Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1CBC19F37
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5611360FE6
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 12:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245209AbhH0MIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 08:08:10 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3704 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245172AbhH0MH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 08:07:57 -0400
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gwz1y1qlfz67svh;
        Fri, 27 Aug 2021 20:05:42 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 14:07:07 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 13:07:04 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v3 09/13] blk-mq: Add blk_mq_tag_update_sched_shared_sbitmap()
Date:   Fri, 27 Aug 2021 20:02:00 +0800
Message-ID: <1630065724-69146-10-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630065724-69146-1-git-send-email-john.garry@huawei.com>
References: <1630065724-69146-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Put the functionality to update the sched shared sbitmap size in a common
function.

Since the same formula is always used to resize, and it can be got from
the request queue argument, so just pass the request queue pointer.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c | 3 +--
 block/blk-mq-tag.c   | 6 ++++++
 block/blk-mq-tag.h   | 1 +
 block/blk-mq.c       | 3 +--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 3ab26154f0ea..a3b5a5399bc8 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -575,8 +575,7 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
 					&queue->sched_breserved_tags;
 	}
 
-	sbitmap_queue_resize(&queue->sched_bitmap_tags,
-			     queue->nr_requests - set->reserved_tags);
+	blk_mq_tag_update_sched_shared_sbitmap(queue);
 
 	return 0;
 }
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 86f87346232a..5f06ad6efc8f 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -634,6 +634,12 @@ void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int s
 	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
 }
 
+void blk_mq_tag_update_sched_shared_sbitmap(struct request_queue *q)
+{
+	sbitmap_queue_resize(&q->sched_bitmap_tags,
+			     q->nr_requests - q->tag_set->reserved_tags);
+}
+
 /**
  * blk_mq_unique_tag() - return a tag that is unique queue-wide
  * @rq: request for which to compute a unique tag
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 8ed55af08427..88f3c6485543 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -48,6 +48,7 @@ extern int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 					unsigned int depth, bool can_grow);
 extern void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set,
 					     unsigned int size);
+extern void blk_mq_tag_update_sched_shared_sbitmap(struct request_queue *q);
 
 extern void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
 void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 09380274d2d6..d82d477c9c9d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3649,8 +3649,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		q->nr_requests = nr;
 		if (blk_mq_is_sbitmap_shared(set->flags)) {
 			if (q->elevator)
-				sbitmap_queue_resize(&q->sched_bitmap_tags,
-						     nr - set->reserved_tags);
+				blk_mq_tag_update_sched_shared_sbitmap(q);
 			else
 				blk_mq_tag_resize_shared_sbitmap(set, nr);
 		}
-- 
2.26.2

