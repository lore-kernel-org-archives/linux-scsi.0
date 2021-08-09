Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43568C19F3F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319A560234
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhHIOiN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:38:13 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3611 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbhHIOfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 10:35:01 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gjz9Y1Jzyz6C990;
        Mon,  9 Aug 2021 22:34:09 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 9 Aug 2021 16:34:39 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 15:34:36 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        <hare@suse.de>, <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 05/11] blk-mq-sched: Rename blk_mq_sched_alloc_{tags -> map_and_request}()
Date:   Mon, 9 Aug 2021 22:29:32 +0800
Message-ID: <1628519378-211232-6-git-send-email-john.garry@huawei.com>
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

Function blk_mq_sched_alloc_tags() does same as
__blk_mq_alloc_map_and_request(), so give a similar name to be consistent.

Similarly rename label err_free_tags -> err_free_map_and_request.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-sched.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 2231fb0d4c35..b4d7ad9a7a60 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -515,9 +515,9 @@ void blk_mq_sched_insert_requests(struct blk_mq_hw_ctx *hctx,
 	percpu_ref_put(&q->q_usage_counter);
 }
 
-static int blk_mq_sched_alloc_tags(struct request_queue *q,
-				   struct blk_mq_hw_ctx *hctx,
-				   unsigned int hctx_idx)
+static int blk_mq_sched_alloc_map_and_request(struct request_queue *q,
+					      struct blk_mq_hw_ctx *hctx,
+					      unsigned int hctx_idx)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 	int ret;
@@ -609,15 +609,15 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 				   BLKDEV_DEFAULT_RQ);
 
 	queue_for_each_hw_ctx(q, hctx, i) {
-		ret = blk_mq_sched_alloc_tags(q, hctx, i);
+		ret = blk_mq_sched_alloc_map_and_request(q, hctx, i);
 		if (ret)
-			goto err_free_tags;
+			goto err_free_map_and_request;
 	}
 
 	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
 		ret = blk_mq_init_sched_shared_sbitmap(q);
 		if (ret)
-			goto err_free_tags;
+			goto err_free_map_and_request;
 	}
 
 	ret = e->ops.init_sched(q, e);
@@ -645,7 +645,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 err_free_sbitmap:
 	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
 		blk_mq_exit_sched_shared_sbitmap(q);
-err_free_tags:
+err_free_map_and_request:
 	blk_mq_sched_free_requests(q);
 	blk_mq_sched_tags_teardown(q);
 	q->elevator = NULL;
-- 
2.26.2

