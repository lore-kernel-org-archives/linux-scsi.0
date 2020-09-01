Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F216C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7523C206C0
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgIAOzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:55:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726997AbgIALeb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 07:34:31 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4633EDAAF5E80908D7C9;
        Tue,  1 Sep 2020 19:17:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 19:16:58 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 3/8] scsi: hisi_sas: Do not modify upper fields of PROG_PHY_LINK_RATE reg
Date:   Tue, 1 Sep 2020 19:13:05 +0800
Message-ID: <1598958790-232272-4-git-send-email-john.garry@huawei.com>
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

When we update register of PROG_PHY_LINK_RATE to set linkrate for a phy,
we used a hard-coded initial value instead of getting the current value
from register. We had assumed that this register would not be modified,
but in fact it was partially modified in new version of hardware. So
hard-coded value we used change default value of register to a wrong
setting and make SAS controller can not change linkrate for phy at new
version of hardware.

So we delete hard-coded value and always read the latest value of register
before we update part of it.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 05b60cdf6b24..b7d94f2e49ae 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -191,6 +191,8 @@
 #define PHY_CFG_PHY_RST_OFF		3
 #define PHY_CFG_PHY_RST_MSK		(0x1 << PHY_CFG_PHY_RST_OFF)
 #define PROG_PHY_LINK_RATE		(PORT_BASE + 0x8)
+#define CFG_PROG_PHY_LINK_RATE_OFF	0
+#define CFG_PROG_PHY_LINK_RATE_MSK	(0xff << CFG_PROG_PHY_LINK_RATE_OFF)
 #define CFG_PROG_OOB_PHY_LINK_RATE_OFF	8
 #define CFG_PROG_OOB_PHY_LINK_RATE_MSK	(0xf << CFG_PROG_OOB_PHY_LINK_RATE_OFF)
 #define PHY_CTRL			(PORT_BASE + 0x14)
@@ -598,20 +600,19 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, HYPER_STREAM_ID_EN_CFG, 1);
 
 	for (i = 0; i < hisi_hba->n_phy; i++) {
+		enum sas_linkrate max;
 		struct hisi_sas_phy *phy = &hisi_hba->phy[i];
 		struct asd_sas_phy *sas_phy = &phy->sas_phy;
-		u32 prog_phy_link_rate = 0x800;
+		u32 prog_phy_link_rate = hisi_sas_phy_read32(hisi_hba, i,
+							   PROG_PHY_LINK_RATE);
 
+		prog_phy_link_rate &= ~CFG_PROG_PHY_LINK_RATE_MSK;
 		if (!sas_phy->phy || (sas_phy->phy->maximum_linkrate <
-				SAS_LINK_RATE_1_5_GBPS)) {
-			prog_phy_link_rate = 0x855;
-		} else {
-			enum sas_linkrate max = sas_phy->phy->maximum_linkrate;
-
-			prog_phy_link_rate =
-				hisi_sas_get_prog_phy_linkrate_mask(max) |
-				0x800;
-		}
+				SAS_LINK_RATE_1_5_GBPS))
+			max = SAS_LINK_RATE_12_0_GBPS;
+		else
+			max = sas_phy->phy->maximum_linkrate;
+		prog_phy_link_rate |= hisi_sas_get_prog_phy_linkrate_mask(max);
 		hisi_sas_phy_write32(hisi_hba, i, PROG_PHY_LINK_RATE,
 			prog_phy_link_rate);
 		hisi_sas_phy_write32(hisi_hba, i, SERDES_CFG, 0xffc00);
@@ -2501,8 +2502,10 @@ static void phy_set_linkrate_v3_hw(struct hisi_hba *hisi_hba, int phy_no,
 		struct sas_phy_linkrates *r)
 {
 	enum sas_linkrate max = r->maximum_linkrate;
-	u32 prog_phy_link_rate = 0x800;
+	u32 prog_phy_link_rate = hisi_sas_phy_read32(hisi_hba, phy_no,
+						     PROG_PHY_LINK_RATE);
 
+	prog_phy_link_rate &= ~CFG_PROG_PHY_LINK_RATE_MSK;
 	prog_phy_link_rate |= hisi_sas_get_prog_phy_linkrate_mask(max);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PROG_PHY_LINK_RATE,
 			     prog_phy_link_rate);
-- 
2.26.2

