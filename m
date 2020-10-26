Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92A9C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 10:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6151F222B9
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 10:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771753AbgJZKwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 06:52:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3488 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771850AbgJZKwV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 06:52:21 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CKWr81nlhzhZ37;
        Mon, 26 Oct 2020 18:52:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Mon, 26 Oct 2020 18:52:09 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [RESEND PATCH] scsi: hisi_sas: Stop using queue #0 always for v2 hw
Date:   Mon, 26 Oct 2020 18:48:33 +0800
Message-ID: <1603709313-185482-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In commit 8d98416a55eb ("scsi: hisi_sas: Switch v3 hw to MQ"), the dispatch
function was changed to choose the delivery queue based on the request tag
HW queue index.

This heavily degrades performance for v2 hw, since the HW queues are not
exposed there, and, as such, HW queue #0 is used for every command.

Revert to previous behaviour for when nr_hw_queues is not set, that being
to choose the HW queue based on target device index.

Fixes: 8d98416a55eb ("scsi: hisi_sas: Switch v3 hw to MQ")
Signed-off-by: John Garry <john.garry@huawei.com>
---
Please include as a v5.10 fix, thanks!

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a994c7b8d26f..fd980a86aa21 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -444,7 +444,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		}
 	}
 
-	if (scmd) {
+	if (scmd && hisi_hba->shost->nr_hw_queues) {
 		unsigned int dq_index;
 		u32 blk_tag;
 
-- 
2.26.2

