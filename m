Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78769C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 07:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiG1HQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 03:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbiG1HQr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 03:16:47 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D16A5A885
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 00:16:46 -0700 (PDT)
X-UUID: 5fa94813c75a43498f2bfafe02edf246-20220728
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:8f8e3560-4a6f-476c-adda-a05fa45a0c0f,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:646c9ecf-a6cf-4fb6-be1b-c60094821ca2,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 5fa94813c75a43498f2bfafe02edf246-20220728
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 402631683; Thu, 28 Jul 2022 15:16:41 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 28 Jul 2022 15:16:40 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 28 Jul 2022 15:16:40 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Subject: [PATCH v1 1/2] ufs: core: interduce a choice of wb toggle in clock scaling
Date:   Thu, 28 Jul 2022 15:16:36 +0800
Message-ID: <20220728071637.22364-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220728071637.22364-1-peter.wang@mediatek.com>
References: <20220728071637.22364-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Vendor may wan't disable/enable write booster while clock scaling.
Introduce a flag UFSHCD_CAP_WB_WITH_CLK_SCALING to decouple WB and
clock scaling.

UFSHCD_CAP_WB_WITH_CLK_SCALING only valid when UFSHCD_CAP_CLK_SCALING
is set. Just like UFSHCD_CAP_HIBERN8_WITH_CLK_GATING is valid only when
UFSHCD_CAP_CLK_GATING set.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufs-sysfs.c | 3 ++-
 drivers/ufs/core/ufshcd.c    | 8 +++++---
 include/ufs/ufshcd.h         | 7 +++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 0a088b47d557..8fa1679ffd1a 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -225,7 +225,8 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 	unsigned int wb_enable;
 	ssize_t res;
 
-	if (!ufshcd_is_wb_allowed(hba) || ufshcd_is_clkscaling_supported(hba)) {
+	if (!ufshcd_is_wb_allowed(hba) || (ufshcd_is_clkscaling_supported(hba)
+		&& ufshcd_can_wb_during_scaling(hba))) {
 		/*
 		 * If the platform supports UFSHCD_CAP_CLK_SCALING, turn WB
 		 * on/off will be done while clock scaling up/down.
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7b337480e3e..5d1f2ff0f596 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1301,9 +1301,11 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	}
 
 	/* Enable Write Booster if we have scaled up else disable it */
-	downgrade_write(&hba->clk_scaling_lock);
-	is_writelock = false;
-	ufshcd_wb_toggle(hba, scale_up);
+	if (ufshcd_can_wb_during_scaling(hba)) {
+		downgrade_write(&hba->clk_scaling_lock);
+		is_writelock = false;
+		ufshcd_wb_toggle(hba, scale_up);
+	}
 
 out_unprepare:
 	ufshcd_clock_scaling_unprepare(hba, is_writelock);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a92271421718..4bd35d68acde 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -648,6 +648,9 @@ enum ufshcd_caps {
 	 * notification if it is supported by the UFS device.
 	 */
 	UFSHCD_CAP_TEMP_NOTIF				= 1 << 11,
+
+	/* Allow WB with clk scaling */
+	UFSHCD_CAP_WB_WITH_CLK_SCALING			= 1 << 12,
 };
 
 struct ufs_hba_variant_params {
@@ -1004,6 +1007,10 @@ static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
 {
 	return hba->caps & UFSHCD_CAP_WB_EN;
 }
+static inline bool ufshcd_can_wb_during_scaling(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_WB_WITH_CLK_SCALING;
+}
 
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
-- 
2.18.0

