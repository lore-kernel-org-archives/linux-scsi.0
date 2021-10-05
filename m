Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAA0C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D44611AE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbhJEKa6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:30:58 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3923 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbhJEKau (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 06:30:50 -0400
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNtyk6KjRz67Xsj;
        Tue,  5 Oct 2021 18:25:50 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 12:28:58 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 11:28:55 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v5 06/14] blk-mq-sched: Rename blk_mq_sched_free_{requests -> rqs}()
Date:   Tue, 5 Oct 2021 18:23:31 +0800
Message-ID: <1633429419-228500-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To be more concise and consistent in naming, rename
blk_mq_sched_free_requests() -> blk_mq_sched_free_rqs().

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c     | 2 +-
 block/blk-mq-sched.c | 6 +++---
 block/blk-mq-sched.h | 2 +-
 block/blk.h          | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cf0899a93367..7c869737ce4c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -407,7 +407,7 @@ void blk_cleanup_queue(struct request_queue *q)
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
index f6a1ce9e31f3..e4d367e0b2a3 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -29,7 +29,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx);
 
 int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e);
 void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e);
-void blk_mq_sched_free_requests(struct request_queue *q);
+void blk_mq_sched_free_rqs(struct request_queue *q);
 
 static inline bool
 blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio,
diff --git a/block/blk.h b/block/blk.h
index deb8393e34ee..762af963b302 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -240,7 +240,7 @@ static inline void elevator_exit(struct request_queue *q,
 {
 	lockdep_assert_held(&q->sysfs_lock);
 
-	blk_mq_sched_free_requests(q);
+	blk_mq_sched_free_rqs(q);
 	__elevator_exit(q, e);
 }
 
-- 
2.26.2

