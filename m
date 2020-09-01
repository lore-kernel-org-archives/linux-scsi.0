Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C1FC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2710F206EB
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgIALfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:35:16 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43740 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbgIALeh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 07:34:37 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 69B232334A629702BB85;
        Tue,  1 Sep 2020 19:17:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 19:16:58 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 2/8] scsi: hisi_sas: Modify macro name for OOB phy linkrate
Date:   Tue, 1 Sep 2020 19:13:04 +0800
Message-ID: <1598958790-232272-3-git-send-email-john.garry@huawei.com>
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

The macro for OOB phy linkrate is named as CFG_PROG_PHY_LINK_RATE_*, but
it's not correct. To avoid some misunderstand, we modify it to a correct
naming.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 60adf5c32143..05b60cdf6b24 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -191,8 +191,8 @@
 #define PHY_CFG_PHY_RST_OFF		3
 #define PHY_CFG_PHY_RST_MSK		(0x1 << PHY_CFG_PHY_RST_OFF)
 #define PROG_PHY_LINK_RATE		(PORT_BASE + 0x8)
-#define CFG_PROG_PHY_LINK_RATE_OFF	8
-#define CFG_PROG_PHY_LINK_RATE_MSK	(0xf << CFG_PROG_PHY_LINK_RATE_OFF)
+#define CFG_PROG_OOB_PHY_LINK_RATE_OFF	8
+#define CFG_PROG_OOB_PHY_LINK_RATE_MSK	(0xf << CFG_PROG_OOB_PHY_LINK_RATE_OFF)
 #define PHY_CTRL			(PORT_BASE + 0x14)
 #define PHY_CTRL_RESET_OFF		0
 #define PHY_CTRL_RESET_MSK		(0x1 << PHY_CTRL_RESET_OFF)
@@ -2998,8 +2998,8 @@ static void hisi_sas_bist_test_restore_v3_hw(struct hisi_hba *hisi_hba)
 	/* restore the linkrate */
 	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, PROG_PHY_LINK_RATE);
 	/* init OOB link rate as 1.5 Gbits */
-	reg_val &= ~CFG_PROG_PHY_LINK_RATE_MSK;
-	reg_val |= (0x8 << CFG_PROG_PHY_LINK_RATE_OFF);
+	reg_val &= ~CFG_PROG_OOB_PHY_LINK_RATE_MSK;
+	reg_val |= (0x8 << CFG_PROG_OOB_PHY_LINK_RATE_OFF);
 	hisi_sas_phy_write32(hisi_hba, phy_id, PROG_PHY_LINK_RATE, reg_val);
 
 	/* enable PHY */
@@ -3027,8 +3027,8 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 		/* set linkrate of bit test*/
 		reg_val = hisi_sas_phy_read32(hisi_hba, phy_id,
 					      PROG_PHY_LINK_RATE);
-		reg_val &= ~CFG_PROG_PHY_LINK_RATE_MSK;
-		reg_val |= (linkrate << CFG_PROG_PHY_LINK_RATE_OFF);
+		reg_val &= ~CFG_PROG_OOB_PHY_LINK_RATE_MSK;
+		reg_val |= (linkrate << CFG_PROG_OOB_PHY_LINK_RATE_OFF);
 		hisi_sas_phy_write32(hisi_hba, phy_id,
 				     PROG_PHY_LINK_RATE, reg_val);
 
@@ -3050,8 +3050,7 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 		hisi_sas_phy_write32(hisi_hba, phy_id,
 				     SAS_PHY_BIST_CODE,
 				     SAS_PHY_BIST_CODE_INIT);
-		hisi_sas_phy_write32(hisi_hba, phy_id,
-				     SAS_PHY_BIST_CODE1,
+		hisi_sas_phy_write32(hisi_hba, phy_id, SAS_PHY_BIST_CODE1,
 				     SAS_PHY_BIST_CODE1_INIT);
 
 		mdelay(100);
-- 
2.26.2

