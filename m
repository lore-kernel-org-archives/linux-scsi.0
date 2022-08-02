Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A39CC00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 14:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbiHBOdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 10:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiHBOdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 10:33:51 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5D815719
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 07:33:49 -0700 (PDT)
X-UUID: a050bbf2511d407c9a1605ac0eec858c-20220802
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:af24013f-f376-4eb0-9fa0-60834e385efa,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:3acd06d1-841b-4e95-ad42-8f86e18f54fc,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: a050bbf2511d407c9a1605ac0eec858c-20220802
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1852328061; Tue, 02 Aug 2022 22:33:41 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 2 Aug 2022 22:33:39 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 2 Aug 2022 22:33:39 +0800
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
Subject: [PATCH v3 1/2] ufs: core: introduce a choice of wb toggle during clock scaling
Date:   Tue, 2 Aug 2022 22:32:22 +0800
Message-ID: <20220802143223.1276-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220802143223.1276-1-peter.wang@mediatek.com>
References: <20220802143223.1276-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Host driver may want to disable/enable write booster during clock scaling.
Introduce a flag UFSHCD_CAP_WB_WITH_CLK_SCALING to decouple WB and
clock scaling.

UFSHCD_CAP_WB_WITH_CLK_SCALING only valid when UFSHCD_CAP_CLK_SCALING
is set. Just like UFSHCD_CAP_HIBERN8_WITH_CLK_GATING is valid only when
UFSHCD_CAP_CLK_GATING set.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
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
index 3d367be71728..d86826e958e6 100644
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

