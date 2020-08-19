Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A361C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFCFF208A9
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgHSP0p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:26:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38868 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726747AbgHSP0m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:26:42 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 73BF6DEDDFE7CC69C53B;
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
Subject: [PATCH v8 03/18] blk-mq: Free tags in blk_mq_init_tags() upon error
Date:   Wed, 19 Aug 2020 23:20:21 +0800
Message-ID: <1597850436-116171-4-git-send-email-john.garry@huawei.com>
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

Since the tags are allocated in blk_mq_init_tags(), it's better practice
to free in that same function upon error, rather than a callee which is to
init the bitmap tags (blk_mq_init_tags()).

Signed-off-by: Hannes Reinecke <hare@suse.de>
[jpg: Split from an earlier patch with a new commit message]
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-tag.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 32d82e23b095..c2c9f369d777 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -429,24 +429,22 @@ static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,
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
@@ -467,7 +465,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_tags = total_tags;
 	tags->nr_reserved_tags = reserved_tags;
 
-	return blk_mq_init_bitmap_tags(tags, node, alloc_policy);
+	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
+		kfree(tags);
+		return NULL;
+	}
+	return tags;
 }
 
 void blk_mq_free_tags(struct blk_mq_tags *tags)
-- 
2.26.2

