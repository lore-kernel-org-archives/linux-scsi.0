Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D922C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 08:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470F661261
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 08:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244952AbhIXIfl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 04:35:41 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3863 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244825AbhIXIfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 04:35:24 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HG4xF3lGxz67kT0;
        Fri, 24 Sep 2021 16:30:57 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 10:33:49 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 09:33:47 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.de>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH v4 09/13] blk-mq: Add blk_mq_tag_update_sched_shared_sbitmap()
Date:   Fri, 24 Sep 2021 16:28:26 +0800
Message-ID: <1632472110-244938-10-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq-sched.c | 3 +--
 block/blk-mq-tag.c   | 6 ++++++
 block/blk-mq-tag.h   | 1 +
 block/blk-mq.c       | 3 +--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index bdbb6c31b433..6c15f6e98e2e 100644
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
index ff5caeb82542..55b5a226dcc0 100644
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
index 5229c5420b85..5fec444d6399 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3641,8 +3641,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
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

