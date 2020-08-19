Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD911C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97AE720897
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgHSP0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:26:30 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39652 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728735AbgHSPZW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:22 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D749C98872B15E6472CE;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:48 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v8 02/18] blk-mq: Rename blk_mq_update_tag_set_depth()
Date:   Wed, 19 Aug 2020 23:20:20 +0800
Message-ID: <1597850436-116171-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
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
[jpg: take out some unrelated changes in blk_mq_init_bitmap_tags()]
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8f95cc443527..50de9eb60466 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2880,8 +2880,8 @@ static void queue_set_hctx_shared(struct request_queue *q, bool shared)
 	}
 }
 
-static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set,
-					bool shared)
+static void blk_mq_update_tag_set_shared(struct blk_mq_tag_set *set,
+					 bool shared)
 {
 	struct request_queue *q;
 
@@ -2904,7 +2904,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
 		/* update existing queue */
-		blk_mq_update_tag_set_depth(set, false);
+		blk_mq_update_tag_set_shared(set, false);
 	}
 	mutex_unlock(&set->tag_list_lock);
 	INIT_LIST_HEAD(&q->tag_set_list);
@@ -2922,7 +2922,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
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

