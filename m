Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412CBC28E83
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DF7D207D3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIALWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:22:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47604 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725949AbgIALTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 07:19:50 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 554C5CB1E8FE32F7B9DB;
        Tue,  1 Sep 2020 19:17:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 19:16:59 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 4/8] scsi: hisi_sas: Make phy index variable name consistent
Date:   Tue, 1 Sep 2020 19:13:06 +0800
Message-ID: <1598958790-232272-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
References: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

We use "phy_id" to identify phy in the BIST code, but the rest of code
always use "phy_no". So we change it for consistent coding style.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 50 +++++++++++++-------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b7d94f2e49ae..8a5c6f5e2a7a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2971,42 +2971,42 @@ static void read_iost_itct_cache_v3_hw(struct hisi_hba *hisi_hba,
 static void hisi_sas_bist_test_prep_v3_hw(struct hisi_hba *hisi_hba)
 {
 	u32 reg_val;
-	int phy_id = hisi_hba->debugfs_bist_phy_no;
+	int phy_no = hisi_hba->debugfs_bist_phy_no;
 
 	/* disable PHY */
-	hisi_sas_phy_enable(hisi_hba, phy_id, 0);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 
 	/* disable ALOS */
-	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, SERDES_CFG);
+	reg_val = hisi_sas_phy_read32(hisi_hba, phy_no, SERDES_CFG);
 	reg_val |= CFG_ALOS_CHK_DISABLE_MSK;
-	hisi_sas_phy_write32(hisi_hba, phy_id, SERDES_CFG, reg_val);
+	hisi_sas_phy_write32(hisi_hba, phy_no, SERDES_CFG, reg_val);
 }
 
 static void hisi_sas_bist_test_restore_v3_hw(struct hisi_hba *hisi_hba)
 {
 	u32 reg_val;
-	int phy_id = hisi_hba->debugfs_bist_phy_no;
+	int phy_no = hisi_hba->debugfs_bist_phy_no;
 
 	/* disable loopback */
-	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, SAS_PHY_BIST_CTRL);
+	reg_val = hisi_sas_phy_read32(hisi_hba, phy_no, SAS_PHY_BIST_CTRL);
 	reg_val &= ~(CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK |
 		     CFG_BIST_TEST_MSK);
-	hisi_sas_phy_write32(hisi_hba, phy_id, SAS_PHY_BIST_CTRL, reg_val);
+	hisi_sas_phy_write32(hisi_hba, phy_no, SAS_PHY_BIST_CTRL, reg_val);
 
 	/* enable ALOS */
-	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, SERDES_CFG);
+	reg_val = hisi_sas_phy_read32(hisi_hba, phy_no, SERDES_CFG);
 	reg_val &= ~CFG_ALOS_CHK_DISABLE_MSK;
-	hisi_sas_phy_write32(hisi_hba, phy_id, SERDES_CFG, reg_val);
+	hisi_sas_phy_write32(hisi_hba, phy_no, SERDES_CFG, reg_val);
 
 	/* restore the linkrate */
-	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, PROG_PHY_LINK_RATE);
+	reg_val = hisi_sas_phy_read32(hisi_hba, phy_no, PROG_PHY_LINK_RATE);
 	/* init OOB link rate as 1.5 Gbits */
 	reg_val &= ~CFG_PROG_OOB_PHY_LINK_RATE_MSK;
 	reg_val |= (0x8 << CFG_PROG_OOB_PHY_LINK_RATE_OFF);
-	hisi_sas_phy_write32(hisi_hba, phy_id, PROG_PHY_LINK_RATE, reg_val);
+	hisi_sas_phy_write32(hisi_hba, phy_no, PROG_PHY_LINK_RATE, reg_val);
 
 	/* enable PHY */
-	hisi_sas_phy_enable(hisi_hba, phy_id, 1);
+	hisi_sas_phy_enable(hisi_hba, phy_no, 1);
 }
 
 #define SAS_PHY_BIST_CODE_INIT	0x1
@@ -3015,28 +3015,28 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 {
 	u32 reg_val, mode_tmp;
 	u32 linkrate = hisi_hba->debugfs_bist_linkrate;
-	u32 phy_id = hisi_hba->debugfs_bist_phy_no;
+	u32 phy_no = hisi_hba->debugfs_bist_phy_no;
 	u32 code_mode = hisi_hba->debugfs_bist_code_mode;
 	u32 path_mode = hisi_hba->debugfs_bist_mode;
 	struct device *dev = hisi_hba->dev;
 
-	dev_info(dev, "BIST info:linkrate=%d phy_id=%d code_mode=%d path_mode=%d\n",
-		 linkrate, phy_id, code_mode, path_mode);
+	dev_info(dev, "BIST info:linkrate=%d phy_no=%d code_mode=%d path_mode=%d\n",
+		 linkrate, phy_no, code_mode, path_mode);
 	mode_tmp = path_mode ? 2 : 1;
 	if (enable) {
 		/* some preparations before bist test */
 		hisi_sas_bist_test_prep_v3_hw(hisi_hba);
 
 		/* set linkrate of bit test*/
-		reg_val = hisi_sas_phy_read32(hisi_hba, phy_id,
+		reg_val = hisi_sas_phy_read32(hisi_hba, phy_no,
 					      PROG_PHY_LINK_RATE);
 		reg_val &= ~CFG_PROG_OOB_PHY_LINK_RATE_MSK;
 		reg_val |= (linkrate << CFG_PROG_OOB_PHY_LINK_RATE_OFF);
-		hisi_sas_phy_write32(hisi_hba, phy_id,
-				     PROG_PHY_LINK_RATE, reg_val);
+		hisi_sas_phy_write32(hisi_hba, phy_no, PROG_PHY_LINK_RATE,
+				     reg_val);
 
 		/* set code mode of bit test */
-		reg_val = hisi_sas_phy_read32(hisi_hba, phy_id,
+		reg_val = hisi_sas_phy_read32(hisi_hba, phy_no,
 					      SAS_PHY_BIST_CTRL);
 		reg_val &= ~(CFG_BIST_MODE_SEL_MSK |
 				CFG_LOOP_TEST_MODE_MSK |
@@ -3046,28 +3046,28 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 		reg_val |= ((code_mode << CFG_BIST_MODE_SEL_OFF) |
 			    (mode_tmp << CFG_LOOP_TEST_MODE_OFF) |
 			    CFG_BIST_TEST_MSK);
-		hisi_sas_phy_write32(hisi_hba, phy_id,
+		hisi_sas_phy_write32(hisi_hba, phy_no,
 				     SAS_PHY_BIST_CTRL, reg_val);
 
 		/* set the bist init value */
-		hisi_sas_phy_write32(hisi_hba, phy_id,
+		hisi_sas_phy_write32(hisi_hba, phy_no,
 				     SAS_PHY_BIST_CODE,
 				     SAS_PHY_BIST_CODE_INIT);
-		hisi_sas_phy_write32(hisi_hba, phy_id, SAS_PHY_BIST_CODE1,
+		hisi_sas_phy_write32(hisi_hba, phy_no, SAS_PHY_BIST_CODE1,
 				     SAS_PHY_BIST_CODE1_INIT);
 
 		mdelay(100);
 		reg_val |= (CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK);
-		hisi_sas_phy_write32(hisi_hba, phy_id,
+		hisi_sas_phy_write32(hisi_hba, phy_no,
 				     SAS_PHY_BIST_CTRL, reg_val);
 
 		/* clear error bit */
 		mdelay(100);
-		hisi_sas_phy_read32(hisi_hba, phy_id, SAS_BIST_ERR_CNT);
+		hisi_sas_phy_read32(hisi_hba, phy_no, SAS_BIST_ERR_CNT);
 	} else {
 		/* disable bist test and recover it */
 		hisi_hba->debugfs_bist_cnt += hisi_sas_phy_read32(hisi_hba,
-				phy_id, SAS_BIST_ERR_CNT);
+				phy_no, SAS_BIST_ERR_CNT);
 		hisi_sas_bist_test_restore_v3_hw(hisi_hba);
 	}
 
-- 
2.26.2

