Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE53C19F29
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 02:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiHDCyi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 22:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237551AbiHDCyg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 22:54:36 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D335A88B
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 19:54:34 -0700 (PDT)
X-UUID: 587ca261bd4d4c01b462a9d8d0b7a7ec-20220804
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=1vI3wruLcjIYklT5fsqB4avGk8cA64Dy6aiHNB94GPM=;
        b=IeYvkfjva9xVCiRaRv7mx+arRKZ/AHRXB9x1hsdtDG/zJibr8mFSiBAXibMDRhwvIGqJaqYBm4D4yC7uxQRnsrPI3ga+FVDInhNnOmC4xWraqzxNM/1/gZF9DaGMVlaBqi4xNZLLg7i+D+/Dg4QsgTSWhhX2rYjZaFom5f9HFdg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:25e67dae-db11-44da-aacd-3ea982bbb38d,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:95
X-CID-INFO: VERSION:1.1.8,REQID:25e67dae-db11-44da-aacd-3ea982bbb38d,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:95
X-CID-META: VersionHash:0f94e32,CLOUDID:8b7e2dd1-841b-4e95-ad42-8f86e18f54fc,C
        OID:005c62367045,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 587ca261bd4d4c01b462a9d8d0b7a7ec-20220804
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1469363403; Thu, 04 Aug 2022 10:54:26 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 4 Aug 2022 10:54:25 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 4 Aug 2022 10:54:25 +0800
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
Subject: [PATCH v5] ufs: allow host driver to disable wb toggling during clock scaling
Date:   Thu, 4 Aug 2022 10:54:22 +0800
Message-ID: <20220804025422.18803-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Mediatek ufs do not want to toggle write booster during clock scaling.
This patch allow host driver to disable wb toggling during clock scaling.

So, introduce a flag UFSHCD_CAP_WB_WITH_CLK_SCALING to decouple WB
and clock scaling. UFSHCD_CAP_WB_WITH_CLK_SCALING only valid when
UFSHCD_CAP_CLK_SCALING is set. Just like UFSHCD_CAP_HIBERN8_WITH_CLK_GATING
is valid only when UFSHCD_CAP_CLK_GATING set.

Set UFSHCD_CAP_WB_WITH_CLK_SCALING for qcom to compatible legacy design in
the same time.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/ufs/core/ufs-sysfs.c |  3 ++-
 drivers/ufs/core/ufshcd.c    |  8 +++++---
 drivers/ufs/host/ufs-qcom.c  |  2 +-
 include/ufs/ufshcd.h         | 11 +++++++++++
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 0a088b47d557..7f41f2a69b04 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -225,7 +225,8 @@ static ssize_t wb_on_store(struct device *dev, struct
 device_attribute *attr,
 	unsigned int wb_enable;
 	ssize_t res;
 
-	if (!ufshcd_is_wb_allowed(hba) || ufshcd_is_clkscaling_supported(hba)) {
+	if (!ufshcd_is_wb_allowed(hba) || (ufshcd_is_clkscaling_supported(hba)
+		&& ufshcd_enable_wb_if_scaling_up(hba))) {
 		/*
 		 * If the platform supports UFSHCD_CAP_CLK_SCALING, turn WB
 		 * on/off will be done while clock scaling up/down.
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7b337480e3e..ac50fbe8aeb8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1301,9 +1301,11 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba,
 bool scale_up)
 	}
 
 	/* Enable Write Booster if we have scaled up else disable it */
-	downgrade_write(&hba->clk_scaling_lock);
-	is_writelock = false;
-	ufshcd_wb_toggle(hba, scale_up);
+	if (ufshcd_enable_wb_if_scaling_up(hba)) {
+		downgrade_write(&hba->clk_scaling_lock);
+		is_writelock = false;
+		ufshcd_wb_toggle(hba, scale_up);
+	}
 
 out_unprepare:
 	ufshcd_clock_scaling_unprepare(hba, is_writelock);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index f10d4668814c..f8c9a78e7776 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -869,7 +869,7 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
-	hba->caps |= UFSHCD_CAP_CLK_SCALING;
+	hba->caps |= UFSHCD_CAP_CLK_SCALING | UFSHCD_CAP_WB_WITH_CLK_SCALING;
 	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
 	hba->caps |= UFSHCD_CAP_WB_EN;
 	hba->caps |= UFSHCD_CAP_CRYPTO;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a92271421718..bed6fb1da78d 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -648,6 +648,12 @@ enum ufshcd_caps {
 	 * notification if it is supported by the UFS device.
 	 */
 	UFSHCD_CAP_TEMP_NOTIF				= 1 << 11,
+
+	/*
+	 * Enable WriteBooster when scaling up the clock and disable
+	 * WriteBooster when scaling the clock down.
+	 */
+	UFSHCD_CAP_WB_WITH_CLK_SCALING			= 1 << 12,
 };
 
 struct ufs_hba_variant_params {
@@ -1005,6 +1011,11 @@ static inline bool ufshcd_is_wb_allowed(struct
 ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_WB_EN;
 }
 
+static inline bool ufshcd_enable_wb_if_scaling_up(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_WB_WITH_CLK_SCALING;
+}
+
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
-- 
2.18.0

