Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEA7C43457
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 08:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15EA42224A
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 08:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgJOIbA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:31:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60468 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729535AbgJOIbA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Oct 2020 04:31:00 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 37B398D955BED3DD956;
        Thu, 15 Oct 2020 16:30:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 15 Oct 2020 16:30:45 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Stop using queue #0 always for v2 hw
Date:   Thu, 15 Oct 2020 16:27:05 +0800
Message-ID: <1602750425-240341-1-git-send-email-john.garry@huawei.com>
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
Martin, James, this is a fix for the code which was went via Jens' tree,
now merged.

Maybe I need to wait until rc1 is released to send. Or maybe, if there is
a second SCSI pull for v5.10 (and a rebase to Linus' tree), it can go then.
It does not apply to Martin's 5.10/queue. Let me know, thanks!

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

