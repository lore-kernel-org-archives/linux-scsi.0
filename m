Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B78C2BA19
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 08:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45F8220857
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 08:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgDRIIJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 04:08:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51618 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbgDRIII (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 04:08:08 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 90D8650A4B645AE86A4E;
        Sat, 18 Apr 2020 16:08:02 +0800 (CST)
Received: from huawei.com (10.175.105.27) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 16:07:56 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>
Subject: [PATCH] scsi:pmcraid:Replace dma_pool_malloc with dma_pool_zalloc
Date:   Sat, 18 Apr 2020 16:07:21 +0800
Message-ID: <1587197241-274646-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.27]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace dma_pool_malloc with dma_pool_zalloc to make the code more concise
in pmcraid_allocate_control_blocks() function.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/scsi/pmcraid.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 7eb88fe..aa9ae2a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4652,7 +4652,7 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 
 	for (i = 0; i < PMCRAID_MAX_CMD; i++) {
 		pinstance->cmd_list[i]->ioa_cb =
-			dma_pool_alloc(
+			dma_pool_zalloc(
 				pinstance->control_pool,
 				GFP_KERNEL,
 				&(pinstance->cmd_list[i]->ioa_cb_bus_addr));
@@ -4661,8 +4661,6 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 			pmcraid_release_control_blocks(pinstance, i);
 			return -ENOMEM;
 		}
-		memset(pinstance->cmd_list[i]->ioa_cb, 0,
-			sizeof(struct pmcraid_control_block));
 	}
 	return 0;
 }
-- 
1.8.3.1

