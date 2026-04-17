Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043CB3921CA
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776427140; cv=none; b=DGsBVeEaX54rV2/DFHlCfAnTXpPGBPb3rjRhBiP+8dQQCaI/S218rkVBbqlpKNLlws8ysHIoqy4nRcngh2YizKBAlu2l2SZMZ9g+dW4ByrE/J3Q64xJ7fpvnjx3z2q5yIpOv0gzcjmRWRQQs3jvjs3lzsLHkAJx249M2tgJHhB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776427140; c=relaxed/simple;
	bh=P4UERcC0BmDunlzQBPWNVv/Xldi6DJfCh7Cpgu6N/Ig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=VdQ6l8nUVoZN8C6ztaQ+jOROJ34lmFwHsNo8eeNcFglD2De+djElC9LuW6pr0fPdttfVROjz7/1pE72/E9/oBWRU/m8JJTrnSQOrCpZmtefY18+zLV1GhC5FJBwRpv34QawiTCqiMY9R0Uofq59m2pAzR3pb1v5VswOItyn0mF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qz3kqZzr; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qz3kqZzr"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260417115856epoutp03dbc5e2a4bafb061effbda280dd5eb290~nIxGzg0vU0474704747epoutp03_
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 11:58:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260417115856epoutp03dbc5e2a4bafb061effbda280dd5eb290~nIxGzg0vU0474704747epoutp03_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1776427136;
	bh=8EdPdiU4KsJ5gvlgsRREVXrpo7NEt6gYIdb33cKgTB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qz3kqZzrusED51nN8T5CobfpPI1RZDjJbxGiG+K5me/IG5wSV3ranbJ4HEhcBTods
	 VjslQ0dmVNukKfvwi5/K7a2U1UVVuI25nhH9Tki4EA4XswdxfB21QWttiUx2dcsHP6
	 UMuD4Jq5zlQDb7Y9lXgXA2Cr+unZmI9gz7CgQ49g=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260417115856epcas5p36436a9aa58982f589e38cae1af21db53~nIxGRvcb-0411004110epcas5p3O;
	Fri, 17 Apr 2026 11:58:56 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4fxthH3Bk1z6B9m6; Fri, 17 Apr
	2026 11:58:55 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260417115854epcas5p22e080e0804f24b76706350d08f13c158~nIxEvxdzr1381413814epcas5p21;
	Fri, 17 Apr 2026 11:58:54 +0000 (GMT)
Received: from bose.samsungds.net (unknown [107.108.83.9]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260417115850epsmtip2214ba2275f669556dab19f6e6f10e313~nIxAxcfq00979809798epsmtip2L;
	Fri, 17 Apr 2026 11:58:49 +0000 (GMT)
From: Alim Akhtar <alim.akhtar@samsung.com>
To: avri.altman@wdc.com, bvanassche@acm.org, robh@kernel.org,
	martin.petersen@oracle.com, krzk+dt@kernel.org
Cc: sowon.na@samsung.com, peter.griffin@linaro.org,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, Alim Akhtar
	<alim.akhtar@samsung.com>
Subject: [PATCH v2 3/4] scsi: ufs: exynos: add support for ExynosAutov920
 SoC
Date: Fri, 17 Apr 2026 17:44:51 +0530
Message-Id: <20260417121452.827054-4-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260417121452.827054-1-alim.akhtar@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260417115854epcas5p22e080e0804f24b76706350d08f13c158
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-543,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260417115854epcas5p22e080e0804f24b76706350d08f13c158
References: <20260417121452.827054-1-alim.akhtar@samsung.com>
	<CGME20260417115854epcas5p22e080e0804f24b76706350d08f13c158@epcas5p2.samsung.com>

From: Sowon Na <sowon.na@samsung.com>

Add a dedicated compatible and drv_data with associated hooks for
ExynosAutov920 SoC.

ExynosAutov920 has a different mask of UFS sharability
from ExynosAutov9, so add related changes for the same.

Signed-off-by: Sowon Na <sowon.na@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
[Alim: fixed unintended changes, other fixes]
---
 drivers/ufs/host/ufs-exynos.c | 110 ++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 77a6c8e44485..b2f65c465525 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -97,6 +97,10 @@
 #define UFS_EXYNOSAUTO_RD_SHARABLE	BIT(1)
 #define UFS_EXYNOSAUTO_SHARABLE		(UFS_EXYNOSAUTO_WR_SHARABLE | \
 					 UFS_EXYNOSAUTO_RD_SHARABLE)
+#define UFS_EXYNOSAUTOV920_WR_SHARABLE	BIT(3)
+#define UFS_EXYNOSAUTOV920_RD_SHARABLE	BIT(2)
+#define UFS_EXYNOSAUTOV920_SHARABLE	(UFS_EXYNOSAUTOV920_WR_SHARABLE |\
+					 UFS_EXYNOSAUTOV920_RD_SHARABLE)
 #define UFS_GS101_WR_SHARABLE		BIT(1)
 #define UFS_GS101_RD_SHARABLE		BIT(0)
 #define UFS_GS101_SHARABLE		(UFS_GS101_WR_SHARABLE | \
@@ -417,6 +421,95 @@ static int exynos7_ufs_post_pwr_change(struct exynos_ufs *ufs,
 	return 0;
 }
 
+static int exynosautov920_ufs_pre_link(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	int i;
+	u32 tx_line_reset_period, rx_line_reset_period;
+
+	rx_line_reset_period = (RX_LINE_RESET_TIME * ufs->mclk_rate)
+				/ NSEC_PER_MSEC;
+	tx_line_reset_period = (TX_LINE_RESET_TIME * ufs->mclk_rate)
+				/ NSEC_PER_MSEC;
+
+	unipro_writel(ufs, 0x5f, 0x44);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x40);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x202), 0x02);
+
+	for_each_ufs_rx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_CLK_PRD, i),
+			       DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_CLK_PRD_EN, i), 0x0);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_VALUE2, i),
+			       (rx_line_reset_period >> 16) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_VALUE1, i),
+			       (rx_line_reset_period >> 8) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_VALUE0, i),
+			       (rx_line_reset_period) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, i), 0x69);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x84, i), 0x1);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, i), 0xf6);
+	}
+
+	for_each_ufs_tx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_CLK_PRD, i),
+			       DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_CLK_PRD_EN, i),
+			       0x02);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_LINERESET_PVALUE2, i),
+			       (tx_line_reset_period >> 16) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_LINERESET_PVALUE1, i),
+			       (tx_line_reset_period >> 8) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_LINERESET_PVALUE0, i),
+			       (tx_line_reset_period) & 0xFF);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x04, i), 0x1);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x7f, i), 0x0);
+	}
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x0);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0x0);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0xa011), 0x8000);
+
+	return 0;
+}
+
+static int exynosautov920_ufs_post_link(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x9529), 0x1);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x15a4), 0x3e8);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x9529), 0x0);
+
+	return 0;
+}
+
+static int exynosautov920_ufs_pre_pwr_change(struct exynos_ufs *ufs,
+					     struct ufs_pa_layer_attr *pwr)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x15d4), 0x1);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_FC0PROTTIMEOUTVAL), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_TC0REPLAYTIMEOUTVAL), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), 20160);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 12000);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 32000);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 16000);
+
+	unipro_writel(ufs, 8064, UNIPRO_DME_POWERMODE_REQ_LOCALL2TIMER0);
+	unipro_writel(ufs, 28224, UNIPRO_DME_POWERMODE_REQ_LOCALL2TIMER1);
+	unipro_writel(ufs, 20160, UNIPRO_DME_POWERMODE_REQ_LOCALL2TIMER2);
+	unipro_writel(ufs, 12000, UNIPRO_DME_POWERMODE_REQ_REMOTEL2TIMER0);
+	unipro_writel(ufs, 32000, UNIPRO_DME_POWERMODE_REQ_REMOTEL2TIMER1);
+	unipro_writel(ufs, 16000, UNIPRO_DME_POWERMODE_REQ_REMOTEL2TIMER2);
+
+	return 0;
+}
+
 /*
  * exynos_ufs_auto_ctrl_hcc - HCI core clock control by h/w
  * Control should be disabled in the below cases
@@ -2201,6 +2294,21 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
 	.suspend		= gs101_ufs_suspend,
 };
 
+static const struct exynos_ufs_drv_data exynosautov920_ufs_drvs = {
+	.uic_attr               = &exynos7_uic_attr,
+	.quirks                 = UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
+	.opts                   = EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
+				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
+				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
+				  EXYNOS_UFS_OPT_TIMER_TICK_SELECT,
+	.iocc_mask		= UFS_EXYNOSAUTOV920_SHARABLE,
+	.drv_init               = exynosauto_ufs_drv_init,
+	.post_hce_enable        = exynosauto_ufs_post_hce_enable,
+	.pre_link               = exynosautov920_ufs_pre_link,
+	.post_link              = exynosautov920_ufs_post_link,
+	.pre_pwr_change         = exynosautov920_ufs_pre_pwr_change,
+};
+
 static const struct of_device_id exynos_ufs_of_match[] = {
 	{ .compatible = "google,gs101-ufs",
 	  .data	      = &gs101_ufs_drvs },
@@ -2210,6 +2318,8 @@ static const struct of_device_id exynos_ufs_of_match[] = {
 	  .data	      = &exynosauto_ufs_drvs },
 	{ .compatible = "samsung,exynosautov9-ufs-vh",
 	  .data	      = &exynosauto_ufs_vh_drvs },
+	{ .compatible = "samsung,exynosautov920-ufs",
+	  .data       = &exynosautov920_ufs_drvs },
 	{ .compatible = "tesla,fsd-ufs",
 	  .data       = &fsd_ufs_drvs },
 	{},
-- 
2.34.1

