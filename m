Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BADBC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 07:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 436E020825
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 07:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgERHsb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 03:48:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53578 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726489AbgERHsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 May 2020 03:48:31 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E54FF4B9C4C949C3B0D2;
        Mon, 18 May 2020 15:48:27 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 18 May 2020
 15:48:17 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <yebin10@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: Refactor scsi_mq_setup_tags function
Date:   Mon, 18 May 2020 15:47:32 +0800
Message-ID: <20200518074732.39679-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  "shost->tag_set" is used too many times, introduce temporary parameter
"tag_set" instead of "&shost->tag_set".

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_lib.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47835c4b4ee0..be1a4a9a5fca 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1870,6 +1870,7 @@ struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
 int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
+	struct blk_mq_tag_set *tag_set = &shost->tag_set;
 
 	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
 				scsi_mq_inline_sgl_size(shost));
@@ -1878,21 +1879,21 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		cmd_size += sizeof(struct scsi_data_buffer) +
 			sizeof(struct scatterlist) * SCSI_INLINE_PROT_SG_CNT;
 
-	memset(&shost->tag_set, 0, sizeof(shost->tag_set));
+	memset(tag_set, 0, sizeof(*tag_set));
 	if (shost->hostt->commit_rqs)
-		shost->tag_set.ops = &scsi_mq_ops;
+		tag_set->ops = &scsi_mq_ops;
 	else
-		shost->tag_set.ops = &scsi_mq_ops_no_commit;
-	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
-	shost->tag_set.queue_depth = shost->can_queue;
-	shost->tag_set.cmd_size = cmd_size;
-	shost->tag_set.numa_node = NUMA_NO_NODE;
-	shost->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
-	shost->tag_set.flags |=
+		tag_set->ops = &scsi_mq_ops_no_commit;
+	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
+	tag_set->queue_depth = shost->can_queue;
+	tag_set->cmd_size = cmd_size;
+	tag_set->numa_node = NUMA_NO_NODE;
+	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
+	tag_set->flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
-	shost->tag_set.driver_data = shost;
+	tag_set->driver_data = shost;
 
-	return blk_mq_alloc_tag_set(&shost->tag_set);
+	return blk_mq_alloc_tag_set(tag_set);
 }
 
 void scsi_mq_destroy_tags(struct Scsi_Host *shost)
-- 
2.21.3

