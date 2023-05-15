Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D19C7EE22
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 02:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjEOCKy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 May 2023 22:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjEOCKx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 May 2023 22:10:53 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DD110EC
        for <linux-scsi@vger.kernel.org>; Sun, 14 May 2023 19:10:51 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QKN5h24hsz18LVZ;
        Mon, 15 May 2023 10:06:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 10:10:48 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 1/3] scsi: hisi_sas: Configure initial value of some registers according to HBA model
Date:   Mon, 15 May 2023 10:41:19 +0800
Message-ID: <1684118481-95908-2-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
References: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yihang Li <liyihang9@huawei.com>

For SAS HBAs of 920 and previous version, we use init_reg_v3_hw() to set
some registers which are related to HW boards. For SAS HBAs of 920B and
later version, those HW registers are set through firmware. And different
HBA models are distinguished through pci_dev->revision.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 12d5884..e279c9c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -627,12 +627,12 @@ static void interrupt_enable_v3_hw(struct hisi_hba *hisi_hba)
 
 static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 {
+	struct pci_dev *pdev = hisi_hba->pci_dev;
 	int i, j;
 
 	/* Global registers init */
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE,
 			 (u32)((1ULL << hisi_hba->queue_count) - 1));
-	hisi_sas_write32(hisi_hba, SAS_AXI_USER3, 0);
 	hisi_sas_write32(hisi_hba, CFG_MAX_TAG, 0xfff0400);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
 	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
@@ -652,6 +652,9 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, ARQOS_ARCACHE_CFG, 0xf0f0);
 	hisi_sas_write32(hisi_hba, HYPER_STREAM_ID_EN_CFG, 1);
 
+	if (pdev->revision < 0x30)
+		hisi_sas_write32(hisi_hba, SAS_AXI_USER3, 0);
+
 	interrupt_enable_v3_hw(hisi_hba);
 	for (i = 0; i < hisi_hba->n_phy; i++) {
 		enum sas_linkrate max;
@@ -669,7 +672,6 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		prog_phy_link_rate |= hisi_sas_get_prog_phy_linkrate_mask(max);
 		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE,
 			prog_phy_link_rate);
-		hisi_sas_phy_write32(hisi_hba, i, SERDES_CFG, 0xffc00);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_RX_TRAIN_TIMER, 0x13e80);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT0, 0xffffffff);
 		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1, 0xffffffff);
@@ -680,13 +682,18 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, PHYCTRL_OOB_RESTART_MSK, 0x1);
 		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER, 0x7f7a120);
 		hisi_sas_phy_write32(hisi_hba, i, CON_CFG_DRIVER, 0x2a0a01);
-		hisi_sas_phy_write32(hisi_hba, i, SAS_SSP_CON_TIMER_CFG, 0x32);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_EC_INT_COAL_TIME,
 				     0x30f4240);
-		/* used for 12G negotiate */
-		hisi_sas_phy_write32(hisi_hba, i, COARSETUNE_TIME, 0x1e);
 		hisi_sas_phy_write32(hisi_hba, i, AIP_LIMIT, 0x2ffff);
 
+		/* set value through firmware for 920B and later version */
+		if (pdev->revision < 0x30) {
+			hisi_sas_phy_write32(hisi_hba, i, SAS_SSP_CON_TIMER_CFG, 0x32);
+			hisi_sas_phy_write32(hisi_hba, i, SERDES_CFG, 0xffc00);
+			/* used for 12G negotiate */
+			hisi_sas_phy_write32(hisi_hba, i, COARSETUNE_TIME, 0x1e);
+		}
+
 		/* get default FFE configuration for BIST */
 		for (j = 0; j < FFE_CFG_MAX; j++) {
 			u32 val = hisi_sas_phy_read32(hisi_hba, i,
-- 
2.8.1

