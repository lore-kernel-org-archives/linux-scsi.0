Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA13FC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 08:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B36EE2073A
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 08:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfKRIcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 03:32:07 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6247 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbfKRIcH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 03:32:07 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AF0432B04E199BEA0818;
        Mon, 18 Nov 2019 16:32:05 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 18 Nov 2019
 16:31:56 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] scsi: pmcraid: remove not needed memset
Date:   Mon, 18 Nov 2019 16:39:19 +0800
Message-ID: <1574066359-88294-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes coccicheck warning:

drivers/scsi/pmcraid.c:4711:3-21: WARNING: dma_alloc_coherent use in pinstance -> hrrq_start [ i ] already zeroes out memory,  so memset is not needed

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/pmcraid.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 398d2af..b0916d2 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4720,7 +4720,6 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
 			return -ENOMEM;
 		}

-		memset(pinstance->hrrq_start[i], 0, buffer_size);
 		pinstance->hrrq_curr[i] = pinstance->hrrq_start[i];
 		pinstance->hrrq_end[i] =
 			pinstance->hrrq_start[i] + PMCRAID_MAX_CMD - 1;
--
2.7.4

