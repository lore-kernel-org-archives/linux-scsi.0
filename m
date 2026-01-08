Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4E83C1991;
	Thu,  8 Jan 2026 10:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767869466; cv=pass; b=cKnhwlPGINOtriQ96KksGs5z7LeiNWM+QzYAosFg8u38GirzSl3+LAXimNOAwv793fIfPIo30jE3FNN0xQ5O1cujksF57e9cdA7bXrlEq5QKDsyWLhoYNpRGsAoHWgbTuoH7QuAD43teTW0vrvhgr06c+VAnLrON02jVv9d/sfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767869466; c=relaxed/simple;
	bh=p7+Vi5iubKANhoOBt1NFsjMGZNLHOq9sA+9jnQexWmQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F7ymzC0jYI7XeuBX0sqK2xD6nz2G/hLOH2pInlOfYTyFoNKtML1aYkZZ+5oDcNb/YaXH3fN6QVSJTY6vgfC+wLj5NyHVJPGR8Pt9hLn7IFYAY0f9+LLIlUih2eQuO3iPN+Shf2KliRkL8jDiTTYFyAN+HbVzMra0xMgENhyghro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=LRfW9Q12; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="LRfW9Q12"
ARC-Seal: i=1; a=rsa-sha256; t=1767869431; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=kgg8MSvx6xNB/D5P9oKdpurrYymS1HnAYwM7eHUDFRO2I8tDfelcKKcaqC26TPr2QejbPNlokcD0/Fv194M1dgDsoqbiWW6xDdALtgbcE+oyjZ09wp8a81N/06sKi8hV6LPRLGgInqcbV3oQQQbn5V+UjcKK4hMKr1RF8ch+cCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767869431; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=p+pqVDFI4rAhqmLsEOA0+6bKRGO8Bu8OpZ3aN+j2yxw=; 
	b=HBTMdwwGhMbrjv7xvmKT208We5kZ6iJvEM+7mB0xdPCwQcrDt7Or1VrJzn1/u+10oAyPGXLVnH5YYbL8Q/8nagmBhyhfcpspasLD0TvwyUEtP23ScXToNOx3A/MyKyVJniMyLJBDkAUOvslJ/5JjaGMVZdMKjxl9Usk6xwc/4jk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767869430;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=p+pqVDFI4rAhqmLsEOA0+6bKRGO8Bu8OpZ3aN+j2yxw=;
	b=LRfW9Q12m8WCTkkSp7vDXhwtYCX0+RWQGkS2zHTlSwVEQy901fD7ef1PyLpY1tnh
	4HwkQ4EvUcmigI3j05VuRKy76UZHybQr0gvzgFoie+sq+myoM8VjMfDp8uH2LsqGTNE
	8N3IBBIEzaxil3EGrKAopmyoTQwWpXRIAml6NCHM=
Received: by mx.zohomail.com with SMTPS id 1767869428849310.94216837879935;
	Thu, 8 Jan 2026 02:50:28 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 08 Jan 2026 11:49:25 +0100
Subject: [PATCH v5 06/24] scsi: ufs: mediatek: Rework resets
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-mt8196-ufs-v5-6-49215157ec41@collabora.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
In-Reply-To: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

Rework the reset control getting in the driver's probe function to use
the bulk reset APIs. Use the optional variant instead of defaulting to
NULL if the resets fail, so that absent resets can be distinguished from
erroneous resets.

Also remove all remnants of the MPHY reset ever having lived in this
driver.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h |  8 ----
 drivers/ufs/host/ufs-mediatek.c     | 78 ++++++++++++++++++-------------------
 drivers/ufs/host/ufs-mediatek.h     |  7 ++--
 3 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-mediatek-sip.h
index d627dfb4a766..256598cc3b5b 100644
--- a/drivers/ufs/host/ufs-mediatek-sip.h
+++ b/drivers/ufs/host/ufs-mediatek-sip.h
@@ -31,11 +31,6 @@ enum ufs_mtk_vcc_num {
 	UFS_VCC_MAX
 };
 
-enum ufs_mtk_mphy_op {
-	UFS_MPHY_BACKUP = 0,
-	UFS_MPHY_RESTORE
-};
-
 /*
  * SMC call wrapper function
  */
@@ -84,9 +79,6 @@ static inline void _ufs_mtk_smc(struct ufs_mtk_smc_arg s)
 #define ufs_mtk_device_pwr_ctrl(on, ufs_version, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_PWR_CTRL, &(res), on, ufs_version)
 
-#define ufs_mtk_mphy_ctrl(op, res) \
-	ufs_mtk_smc(UFS_MTK_SIP_MPHY_CTRL, &(res), op)
-
 #define ufs_mtk_mtcmos_ctrl(op, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_MTCMOS_CTRL, &(res), op)
 
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 66b11cc0703b..5cf5f4c94b8f 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -93,6 +93,12 @@ static const char *const ufs_uic_dl_err_str[] = {
 	"PA_INIT"
 };
 
+static const char *const ufs_reset_names[] = {
+	"unipro",
+	"crypto",
+	"hci",
+};
+
 static bool ufs_mtk_is_boost_crypt_enabled(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -203,49 +209,45 @@ static void ufs_mtk_crypto_enable(struct ufs_hba *hba)
 static void ufs_mtk_host_reset(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-	struct arm_smccc_res res;
-
-	reset_control_assert(host->hci_reset);
-	reset_control_assert(host->crypto_reset);
-	reset_control_assert(host->unipro_reset);
-	reset_control_assert(host->mphy_reset);
-
-	usleep_range(100, 110);
+	int ret;
 
-	reset_control_deassert(host->unipro_reset);
-	reset_control_deassert(host->crypto_reset);
-	reset_control_deassert(host->hci_reset);
-	reset_control_deassert(host->mphy_reset);
+	ret = reset_control_bulk_assert(MTK_UFS_NUM_RESETS, host->resets);
+	if (ret)
+		dev_warn(hba->dev, "Host reset assert failed: %pe\n", ERR_PTR(ret));
 
-	/* restore mphy setting aftre mphy reset */
-	if (host->mphy_reset)
-		ufs_mtk_mphy_ctrl(UFS_MPHY_RESTORE, res);
-}
+	ret = phy_reset(host->mphy);
 
-static void ufs_mtk_init_reset_control(struct ufs_hba *hba,
-				       struct reset_control **rc,
-				       char *str)
-{
-	*rc = devm_reset_control_get(hba->dev, str);
-	if (IS_ERR(*rc)) {
-		dev_info(hba->dev, "Failed to get reset control %s: %ld\n",
-			 str, PTR_ERR(*rc));
-		*rc = NULL;
+	/*
+	 * Only sleep if MPHY doesn't have a reset implemented (which already
+	 * sleeps) or the PHY reset function failed somehow, just to be safe
+	 */
+	if (ret) {
+		usleep_range(100, 110);
+		if (ret != -EOPNOTSUPP)
+			dev_warn(hba->dev, "PHY reset failed: %pe\n", ERR_PTR(ret));
 	}
+
+	ret = reset_control_bulk_deassert(MTK_UFS_NUM_RESETS, host->resets);
+	if (ret)
+		dev_warn(hba->dev, "Host reset deassert failed: %pe\n", ERR_PTR(ret));
 }
 
-static void ufs_mtk_init_reset(struct ufs_hba *hba)
+static int ufs_mtk_init_reset(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	int ret, i;
+
+	for (i = 0; i < MTK_UFS_NUM_RESETS; i++)
+		host->resets[i].id = ufs_reset_names[i];
 
-	ufs_mtk_init_reset_control(hba, &host->hci_reset,
-				   "hci_rst");
-	ufs_mtk_init_reset_control(hba, &host->unipro_reset,
-				   "unipro_rst");
-	ufs_mtk_init_reset_control(hba, &host->crypto_reset,
-				   "crypto_rst");
-	ufs_mtk_init_reset_control(hba, &host->mphy_reset,
-				   "mphy_rst");
+	ret = devm_reset_control_bulk_get_optional_exclusive(hba->dev, MTK_UFS_NUM_RESETS,
+							     host->resets);
+	if (ret) {
+		dev_err(hba->dev, "Failed to get resets: %pe\n", ERR_PTR(ret));
+		return ret;
+	}
+
+	return 0;
 }
 
 static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
@@ -1247,11 +1249,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	if (err)
 		goto out_variant_clear;
 
-	ufs_mtk_init_reset(hba);
-
-	/* backup mphy setting if mphy can reset */
-	if (host->mphy_reset)
-		ufs_mtk_mphy_ctrl(UFS_MPHY_BACKUP, res);
+	err = ufs_mtk_init_reset(hba);
+	if (err)
+		goto out_variant_clear;
 
 	/* Enable runtime autosuspend */
 	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 9747277f11e8..4fce29d131d1 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -7,12 +7,14 @@
 #define _UFS_MEDIATEK_H
 
 #include <linux/bitops.h>
+#include <linux/reset.h>
 
 /*
  * MCQ define and struct
  */
 #define UFSHCD_MAX_Q_NR 8
 #define MTK_MCQ_INVALID_IRQ	0xFFFF
+#define MTK_UFS_NUM_RESETS 3
 
 /* REG_UFS_MMIO_OPT_CTRL_0 160h */
 #define EHS_EN                  BIT(0)
@@ -175,10 +177,7 @@ struct ufs_mtk_mcq_intr_info {
 struct ufs_mtk_host {
 	struct phy *mphy;
 	struct regulator *reg_va09;
-	struct reset_control *hci_reset;
-	struct reset_control *unipro_reset;
-	struct reset_control *crypto_reset;
-	struct reset_control *mphy_reset;
+	struct reset_control_bulk_data resets[MTK_UFS_NUM_RESETS];
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;
 	struct ufs_mtk_clk mclk;

-- 
2.52.0

