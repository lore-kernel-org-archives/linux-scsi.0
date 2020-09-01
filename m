Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED780C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A74206C0
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgIALUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:20:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47610 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbgIALTv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 07:19:51 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5A1F9B41CA48ED149795;
        Tue,  1 Sep 2020 19:17:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 19:17:00 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 6/8] scsi: hisi_sas: Add BIST support for fixed code pattern
Date:   Tue, 1 Sep 2020 19:13:08 +0800
Message-ID: <1598958790-232272-7-git-send-email-john.garry@huawei.com>
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

Add BIST support for fixed code pattern.

Through the new debugfs interface, the user can select fixed code pattern
if they want. We added two new interfaces fixed_code and fixed_code1 to
configure fixed code pattern.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 22 +++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 25 ++++++---------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 43 ++++++++++++++++----------
 3 files changed, 59 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index ce6a7d212afe..c617ac8d8315 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -285,6 +285,27 @@ enum hisi_sas_debugfs_bist_ffe_cfg {
 	FFE_CFG_MAX
 };
 
+enum hisi_sas_debugfs_bist_fixed_code {
+	FIXED_CODE,
+	FIXED_CODE_1,
+	FIXED_CODE_MAX
+};
+
+enum {
+	HISI_SAS_BIST_CODE_MODE_PRBS7,
+	HISI_SAS_BIST_CODE_MODE_PRBS23,
+	HISI_SAS_BIST_CODE_MODE_PRBS31,
+	HISI_SAS_BIST_CODE_MODE_JTPAT,
+	HISI_SAS_BIST_CODE_MODE_CJTPAT,
+	HISI_SAS_BIST_CODE_MODE_SCRAMBED_0,
+	HISI_SAS_BIST_CODE_MODE_TRAIN,
+	HISI_SAS_BIST_CODE_MODE_TRAIN_DONE,
+	HISI_SAS_BIST_CODE_MODE_HFTP,
+	HISI_SAS_BIST_CODE_MODE_MFTP,
+	HISI_SAS_BIST_CODE_MODE_LFTP,
+	HISI_SAS_BIST_CODE_MODE_FIXED_DATA,
+};
+
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
 	void (*setup_itct)(struct hisi_hba *hisi_hba,
@@ -453,6 +474,7 @@ struct hisi_hba {
 	u32 debugfs_bist_cnt;
 	int debugfs_bist_enable;
 	u32 debugfs_bist_ffe[HISI_SAS_MAX_PHYS][FFE_CFG_MAX];
+	u32 debugfs_bist_fixed_code[FIXED_CODE_MAX];
 
 	/* debugfs memories */
 	/* Put Global AXI and RAS Register into register array */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6cd9b25fbbe7..6d1e42389cd6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3334,21 +3334,6 @@ enum {
 	HISI_SAS_BIST_LOOPBACK_MODE_REMOTE,
 };
 
-enum {
-	HISI_SAS_BIST_CODE_MODE_PRBS7 = 0,
-	HISI_SAS_BIST_CODE_MODE_PRBS23,
-	HISI_SAS_BIST_CODE_MODE_PRBS31,
-	HISI_SAS_BIST_CODE_MODE_JTPAT,
-	HISI_SAS_BIST_CODE_MODE_CJTPAT,
-	HISI_SAS_BIST_CODE_MODE_SCRAMBED_0,
-	HISI_SAS_BIST_CODE_MODE_TRAIN,
-	HISI_SAS_BIST_CODE_MODE_TRAIN_DONE,
-	HISI_SAS_BIST_CODE_MODE_HFTP,
-	HISI_SAS_BIST_CODE_MODE_MFTP,
-	HISI_SAS_BIST_CODE_MODE_LFTP,
-	HISI_SAS_BIST_CODE_MODE_FIXED_DATA,
-};
-
 static const struct {
 	int		value;
 	char		*name;
@@ -3966,6 +3951,16 @@ static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 			    hisi_hba->debugfs_bist_dentry, hisi_hba,
 			    &hisi_sas_debugfs_bist_code_mode_ops);
 
+	debugfs_create_file("fixed_code", 0600,
+			    hisi_hba->debugfs_bist_dentry,
+			    &hisi_hba->debugfs_bist_fixed_code[0],
+			    &hisi_sas_debugfs_ops);
+
+	debugfs_create_file("fixed_code_1", 0600,
+			    hisi_hba->debugfs_bist_dentry,
+			    &hisi_hba->debugfs_bist_fixed_code[1],
+			    &hisi_sas_debugfs_ops);
+
 	debugfs_create_file("phy_id", 0600, hisi_hba->debugfs_bist_dentry,
 			    hisi_hba, &hisi_sas_debugfs_bist_phy_ops);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f5d566832d6c..8522f693033f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3033,14 +3033,16 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 	u32 *ffe = hisi_hba->debugfs_bist_ffe[phy_no];
 	u32 code_mode = hisi_hba->debugfs_bist_code_mode;
 	u32 path_mode = hisi_hba->debugfs_bist_mode;
+	u32 *fix_code = &hisi_hba->debugfs_bist_fixed_code[0];
 	struct device *dev = hisi_hba->dev;
 
-	dev_info(dev, "BIST info:phy%d link_rate=%d code_mode=%d path_mode=%d ffe={0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x}\n",
+	dev_info(dev, "BIST info:phy%d link_rate=%d code_mode=%d path_mode=%d ffe={0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x} fixed_code={0x%x, 0x%x}\n",
 		 phy_no, linkrate, code_mode, path_mode,
 		 ffe[FFE_SAS_1_5_GBPS], ffe[FFE_SAS_3_0_GBPS],
 		 ffe[FFE_SAS_6_0_GBPS], ffe[FFE_SAS_12_0_GBPS],
 		 ffe[FFE_SATA_1_5_GBPS], ffe[FFE_SATA_3_0_GBPS],
-		 ffe[FFE_SATA_6_0_GBPS]);
+		 ffe[FFE_SATA_6_0_GBPS], fix_code[FIXED_CODE],
+		 fix_code[FIXED_CODE_1]);
 	mode_tmp = path_mode ? 2 : 1;
 	if (enable) {
 		/* some preparations before bist test */
@@ -3057,28 +3059,37 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 		/* set code mode of bit test */
 		reg_val = hisi_sas_phy_read32(hisi_hba, phy_no,
 					      SAS_PHY_BIST_CTRL);
-		reg_val &= ~(CFG_BIST_MODE_SEL_MSK |
-				CFG_LOOP_TEST_MODE_MSK |
-				CFG_RX_BIST_EN_MSK |
-				CFG_TX_BIST_EN_MSK |
-				CFG_BIST_TEST_MSK);
+		reg_val &= ~(CFG_BIST_MODE_SEL_MSK | CFG_LOOP_TEST_MODE_MSK |
+			     CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK |
+			     CFG_BIST_TEST_MSK);
 		reg_val |= ((code_mode << CFG_BIST_MODE_SEL_OFF) |
 			    (mode_tmp << CFG_LOOP_TEST_MODE_OFF) |
 			    CFG_BIST_TEST_MSK);
-		hisi_sas_phy_write32(hisi_hba, phy_no,
-				     SAS_PHY_BIST_CTRL, reg_val);
+		hisi_sas_phy_write32(hisi_hba, phy_no, SAS_PHY_BIST_CTRL,
+				     reg_val);
 
 		/* set the bist init value */
-		hisi_sas_phy_write32(hisi_hba, phy_no,
-				     SAS_PHY_BIST_CODE,
-				     SAS_PHY_BIST_CODE_INIT);
-		hisi_sas_phy_write32(hisi_hba, phy_no, SAS_PHY_BIST_CODE1,
-				     SAS_PHY_BIST_CODE1_INIT);
+		if (code_mode == HISI_SAS_BIST_CODE_MODE_FIXED_DATA) {
+			reg_val = hisi_hba->debugfs_bist_fixed_code[0];
+			hisi_sas_phy_write32(hisi_hba, phy_no,
+					     SAS_PHY_BIST_CODE, reg_val);
+
+			reg_val = hisi_hba->debugfs_bist_fixed_code[1];
+			hisi_sas_phy_write32(hisi_hba, phy_no,
+					     SAS_PHY_BIST_CODE1, reg_val);
+		} else {
+			hisi_sas_phy_write32(hisi_hba, phy_no,
+					     SAS_PHY_BIST_CODE,
+					     SAS_PHY_BIST_CODE_INIT);
+			hisi_sas_phy_write32(hisi_hba, phy_no,
+					     SAS_PHY_BIST_CODE1,
+					     SAS_PHY_BIST_CODE1_INIT);
+		}
 
 		mdelay(100);
 		reg_val |= (CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK);
-		hisi_sas_phy_write32(hisi_hba, phy_no,
-				     SAS_PHY_BIST_CTRL, reg_val);
+		hisi_sas_phy_write32(hisi_hba, phy_no, SAS_PHY_BIST_CTRL,
+				     reg_val);
 
 		/* clear error bit */
 		mdelay(100);
-- 
2.26.2

