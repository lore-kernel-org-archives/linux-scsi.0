Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBD4C2D0DE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 01:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D43224653
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 01:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgABBvj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jan 2020 20:51:39 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:53984 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbgABBvj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Jan 2020 20:51:39 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3D352BF1F07AC17C3AF6;
        Thu,  2 Jan 2020 09:51:37 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Thu, 2 Jan 2020 09:51:29 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH next] scsi: pmcraid: replace dma_pool_alloc + memset with dma_pool_zalloc
Date:   Thu, 2 Jan 2020 09:47:38 +0800
Message-ID: <20200102014738.139575-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use dma_pool_zalloc rather than dma_pool_alloc followed by memset with 0.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
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
2.7.4

