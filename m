Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00076C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 02:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiBOCFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 21:05:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiBOCFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 21:05:38 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E511EC75;
        Mon, 14 Feb 2022 18:05:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4WCuSn_1644890725;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V4WCuSn_1644890725)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 10:05:26 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, john.garry@huawei.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] scsi: hisi_sas: Remove unnecessary print function dev_err()
Date:   Tue, 15 Feb 2022 10:05:24 +0800
Message-Id: <20220215020524.44268-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The print function dev_err() is redundant because platform_get_irq()
already prints an error.

Eliminate the follow coccicheck warnings:
./drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1661:3-10: line 1661 is
redundant because platform_get_irq() already prints an error
./drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1642:4-11: line 1642 is
redundant because platform_get_irq() already prints an error
./drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1679:3-10: line 1679 is
redundant because platform_get_irq() already prints an error

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 6914e992a02e..e564c78ff910 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1638,11 +1638,8 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		idx = i * HISI_SAS_PHY_INT_NR;
 		for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
 			irq = platform_get_irq(pdev, idx);
-			if (irq < 0) {
-				dev_err(dev, "irq init: fail map phy interrupt %d\n",
-					idx);
+			if (irq < 0)
 				return irq;
-			}
 
 			rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
 					      DRV_NAME " phy", phy);
@@ -1657,11 +1654,8 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 	idx = hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
 	for (i = 0; i < hisi_hba->queue_count; i++, idx++) {
 		irq = platform_get_irq(pdev, idx);
-		if (irq < 0) {
-			dev_err(dev, "irq init: could not map cq interrupt %d\n",
-				idx);
+		if (irq < 0)
 			return irq;
-		}
 
 		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
 				      DRV_NAME " cq", &hisi_hba->cq[i]);
@@ -1675,11 +1669,8 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 	idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_count;
 	for (i = 0; i < HISI_SAS_FATAL_INT_NR; i++, idx++) {
 		irq = platform_get_irq(pdev, idx);
-		if (irq < 0) {
-			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
-				idx);
+		if (irq < 0)
 			return irq;
-		}
 
 		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
 				      DRV_NAME " fatal", hisi_hba);
-- 
2.20.1.7.g153144c

