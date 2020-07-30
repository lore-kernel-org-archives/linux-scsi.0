Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C8FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 03:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9D2422CA0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 03:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgG3DCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 23:02:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8853 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgG3DCj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 23:02:39 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8DB13B32D8CD9ADA7F05;
        Thu, 30 Jul 2020 11:02:36 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 11:02:32 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] scsi: Remove superfluous memset()
Date:   Thu, 30 Jul 2020 11:03:55 +0800
Message-ID: <1596078235-54002-1-git-send-email-liheng40@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes coccicheck warning:

./drivers/scsi/mvsas/mv_init.c:244:11-29: WARNING: dma_alloc_coherent use in mvi -> tx already zeroes out memory,  so memset is not needed
./drivers/scsi/mvsas/mv_init.c:250:15-33: WARNING: dma_alloc_coherent use in mvi -> rx_fis already zeroes out memory,  so memset is not needed
./drivers/scsi/mvsas/mv_init.c:256:11-29: WARNING: dma_alloc_coherent use in mvi -> rx already zeroes out memory,  so memset is not needed
./drivers/scsi/mvsas/mv_init.c:265:13-31: WARNING: dma_alloc_coherent use in mvi -> slot already zeroes out memory,  so memset is not needed

dma_alloc_coherent use in status already zeroes out memory, so memset is not needed

Signed-off-by: Li Heng <liheng40@huawei.com>
---
 drivers/scsi/mvsas/mv_init.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 978f528..6aa2697 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -246,19 +246,16 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 				     &mvi->tx_dma, GFP_KERNEL);
 	if (!mvi->tx)
 		goto err_out;
-	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
 	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
 					 &mvi->rx_fis_dma, GFP_KERNEL);
 	if (!mvi->rx_fis)
 		goto err_out;
-	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
 
 	mvi->rx = dma_alloc_coherent(mvi->dev,
 				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
 				     &mvi->rx_dma, GFP_KERNEL);
 	if (!mvi->rx)
 		goto err_out;
-	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
 	mvi->rx[0] = cpu_to_le32(0xfff);
 	mvi->rx_cons = 0xfff;
 
@@ -267,7 +264,6 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 				       &mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
 
 	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
 				       TRASH_BUCKET_SIZE,
-- 
2.7.4

