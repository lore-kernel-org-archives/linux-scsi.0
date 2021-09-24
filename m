Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DAEC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 08:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3549E610C7
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 08:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244855AbhIXIfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 04:35:21 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3860 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244827AbhIXIfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 04:35:18 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HG4xb6qbVz67kg2;
        Fri, 24 Sep 2021 16:31:15 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 10:33:43 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 09:33:41 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.de>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH v4 06/13] blk-mq-sched: Rename blk_mq_sched_free_{requests -> rqs}()
Date:   Fri, 24 Sep 2021 16:28:23 +0800
Message-ID: <1632472110-244938-7-git-send-email-john.garry@huawei.com>
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

To be more concise and consistent in naming, rename
blk_mq_sched_free_requests() -> blk_mq_sched_free_rqs().

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c     | 2 +-
 block/blk-mq-sched.c | 6 +++---
 block/blk-mq-sched.h | 2 +-
 block/blk.h          | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5d7137bec48e..3480df0e958c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -406,7 +406,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	 */
 	mutex_lock(&q->sysfs_lock);
 	if (q->elevator)
-		blk_mq_sched_free_requests(q);
+		blk_mq_sched_free_rqs(q);
 	mutex_unlock(&q->sysfs_lock);
 
 	percpu_ref_exit(&q->q_usage_counter);
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 644b6d554d72..bdbb6c31b433 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -631,7 +631,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 			ret = e->ops.init_hctx(hctx, i);
 			if (ret) {
 				eq = q->elevator;
-				blk_mq_sched_free_requests(q);
+				blk_mq_sched_free_rqs(q);
 				blk_mq_exit_sched(q, eq);
 				kobject_put(&eq->kobj);
 				return ret;
@@ -646,7 +646,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
 		blk_mq_exit_sched_shared_sbitmap(q);
 err_free_map_and_rqs:
-	blk_mq_sched_free_requests(q);
+	blk_mq_sched_free_rqs(q);
 	blk_mq_sched_tags_teardown(q);
 	q->elevator = NULL;
 	return ret;
@@ -656,7 +656,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
  * called in either blk_queue_cleanup or elevator_switch, tagset
  * is required for freeing requests
  */
-void blk_mq_sched_free_requests(struct request_queue *q)
+void blk_mq_sched_free_rqs(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
 	int i;
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 1e46be6c5178..e70748d18754 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -28,7 +28,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx);
 
 int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e);
 void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e);
-void blk_mq_sched_free_requests(struct request_queue *q);
+void blk_mq_sched_free_rqs(struct request_queue *q);
 
 static inline bool
 blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio,
diff --git a/block/blk.h b/block/blk.h
index 7d2a0ba7ed21..6f125c8cddb0 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -200,7 +200,7 @@ static inline void elevator_exit(struct request_queue *q,
 {
 	lockdep_assert_held(&q->sysfs_lock);
 
-	blk_mq_sched_free_requests(q);
+	blk_mq_sched_free_rqs(q);
 	__elevator_exit(q, e);
 }
 
-- 
2.26.2

