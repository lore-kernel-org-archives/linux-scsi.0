Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ECEC19F41
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD0CF6101E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhHIOiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:38:16 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3613 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbhHIOgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 10:36:17 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gjz9k06cVz6D9Ll;
        Mon,  9 Aug 2021 22:34:18 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 9 Aug 2021 16:34:45 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 15:34:42 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        <hare@suse.de>, <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 07/11] blk-mq: Add blk_mq_tag_update_sched_shared_sbitmap()
Date:   Mon, 9 Aug 2021 22:29:34 +0800
Message-ID: <1628519378-211232-8-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
---
 block/blk-mq-sched.c | 3 +--
 block/blk-mq-tag.c   | 6 ++++++
 block/blk-mq-tag.h   | 1 +
 block/blk-mq.c       | 3 +--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index b4d7ad9a7a60..ac0408ebcd47 100644
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
index 0bb596f4d061..f14cc2705f9b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3645,8 +3645,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
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

