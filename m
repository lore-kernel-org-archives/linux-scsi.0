Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC111FA3741
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 09:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiJYJsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 05:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiJYJsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 05:48:01 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF17C118764;
        Tue, 25 Oct 2022 02:47:58 -0700 (PDT)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MxRsm01JJz6HJLh;
        Tue, 25 Oct 2022 17:46:36 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 11:47:57 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 10:47:52 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <jinpu.wang@cloud.ionos.com>, <hare@suse.de>, <bvanassche@acm.org>,
        <hch@lst.de>, <ming.lei@redhat.com>, <niklas.cassel@wdc.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v3 01/22] blk-mq: Don't get budget for reserved requests
Date:   Tue, 25 Oct 2022 18:17:55 +0800
Message-ID: <1666693096-180008-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
References: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It should be possible to send reserved requests even when there is no
budget, so don't request a budget in that case.

This comes into play when we need to allocate a reserved request from the
target device request queue for error handling for that same device.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq.c          | 4 +++-
 drivers/scsi/scsi_lib.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 260adeb2e455..d8baabb32ea4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1955,11 +1955,13 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 	errors = queued = 0;
 	do {
 		struct blk_mq_queue_data bd;
+		bool need_budget;
 
 		rq = list_first_entry(list, struct request, queuelist);
 
 		WARN_ON_ONCE(hctx != rq->mq_hctx);
-		prep = blk_mq_prep_dispatch_rq(rq, !nr_budgets);
+		need_budget = !nr_budgets && !blk_mq_is_reserved_rq(rq);
+		prep = blk_mq_prep_dispatch_rq(rq, need_budget);
 		if (prep != PREP_DISPATCH_OK)
 			break;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fa96d3cfdfa3..39d4fd124375 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -298,7 +298,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
 
-	sbitmap_put(&sdev->budget_map, cmd->budget_token);
+	if (!blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))
+		sbitmap_put(&sdev->budget_map, cmd->budget_token);
 	cmd->budget_token = -1;
 }
 
-- 
2.35.3

