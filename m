Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955754119F2;
	Thu, 30 Jul 2026 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405026; cv=none; b=nLCyz+y3cGJ1xeRgpzuHARFVb/bt29ZIjR2v3m4g5Y6+hUPSNK5/v2vbPOT6xgAaCpnGzu3kHJoLa0YHbBzLD+vwKyDCMLsgb8c04h13t00TXfH0Hra5MsR6F1iQfZGTKeaOikuFg0+0prpuJ0AY6gfhv1QV0iMmF0weXC+HaJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405026; c=relaxed/simple;
	bh=8fEuHq1yPlnzeHENnBf/TGIwb5o8hOsfa/FinBTM1ZU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WVU2L6fxX9EL3GxMUnT0cgkmfm86KTlEq1cGsXH3pvRvBoUaA646663PCX0v9ROuybQGTJYbxB+00IDRZurC/sxgWYmDHNJ3lz04atZ0R1qL0466DbF7DIuoVypRZ5Wf0zsAPiX6MLPgP2ECdmUgLRqyZB950hIfVFSQXoY61aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=OVvPhKLz; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="OVvPhKLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405022;
	bh=8fEuHq1yPlnzeHENnBf/TGIwb5o8hOsfa/FinBTM1ZU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OVvPhKLzy6hWH0dEoVMqnGq6xDdaee+Hh7lI/hxKR8eDy/ZvysEBPxJbND0D2L4Em
	 Qyv04yOVZuiZfatMGrqdteuTcmqiOBygYUsz6aCklpJIRWzZ/OFLiIVRWn71h8x7yS
	 MhZ5Jbg6r0jIkQtoJxJnoq7iferqHlIS+j2x7vCoB06p4Bw74VhpgLL95wpeT5RQwy
	 VLK10mY3Qm1d9qyAVgC6kElFhEbBHjEJYEu9t2xzrW/AVUTUBD1Of9gBDzI7ysF/QY
	 PMWquKQ/Q4Hhy5ZaxqlnjBdZGcWIiKltnKxBFha80Tt77yyzJ3SQkizqrTqyRzk3b0
	 Cg+EUUII/Q6FA==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5C9EE17E0961;
	Thu, 30 Jul 2026 11:50:21 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:14 +0200
Subject: [PATCH v10 18/26] scsi: ufs: mediatek: Don't acquire dvfsrc-vcore
 twice
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-18-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=8501;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=G1srB0RxuOnedjAn46UWFPe8WoaTCLNsvIKPik3Bgl4=;
 b=vQKtVjIiR3eCR9qPCUxdrMj7+kygUOc3xKalzXVMjsMSm7madi1l7mlQtlVmV2mhmoLCO6FZD
 8+O3Zq/bJ2/DYI+9WffGUnDGs6cpc0zAVW73vKilP2q+sGHPX0CeNWE
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

As part of its featureset, the ufs-mediatek driver needs to play with an
optional dvfsrc-vcore regulator for some of them.

However, it currently does this by acquiring two different references to
it in two different places, needlessly duplicating logic.

Move reg_vcore to the host struct, acquire it in the same function as
avdd09 is acquired, and rework the users of reg_vcore.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 71 +++++++++++++++++++----------------------
 drivers/ufs/host/ufs-mediatek.h |  3 +-
 2 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 0821de5b8a8f..8214cf0b3a16 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -519,7 +519,6 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct ufs_mtk_crypt_cfg *cfg;
-	struct regulator *reg;
 	int volt, ret;
 
 	if (!ufs_mtk_is_boost_crypt_enabled(hba))
@@ -527,7 +526,6 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 
 	cfg = host->crypt;
 	volt = cfg->vcore_volt;
-	reg = cfg->reg_vcore;
 
 	ret = clk_prepare_enable(cfg->clk_crypt_mux);
 	if (ret) {
@@ -537,7 +535,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 	}
 
 	if (boost) {
-		ret = regulator_set_voltage(reg, volt, INT_MAX);
+		ret = regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to set vcore to %d: %pe\n",
 				__func__, volt, ERR_PTR(ret));
@@ -548,7 +546,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to reparent clk_crypt_perf: %pe\n",
 				__func__, ERR_PTR(ret));
-			regulator_set_voltage(reg, 0, INT_MAX);
+			regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 			goto out;
 		}
 	} else {
@@ -559,7 +557,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 			goto out;
 		}
 
-		ret = regulator_set_voltage(reg, 0, INT_MAX);
+		ret = regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
 				__func__, ERR_PTR(ret));
@@ -576,15 +574,12 @@ static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	int ret;
 
-	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
-	if (!cfg)
+	if (!host->reg_vcore)
 		return;
 
-	cfg->reg_vcore = devm_regulator_get_optional(dev, "dvfsrc-vcore");
-	if (IS_ERR(cfg->reg_vcore)) {
-		dev_err(dev, "Failed to get dvfsrc-vcore: %pe", cfg->reg_vcore);
+	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
 		return;
-	}
 
 	ret = of_property_read_u32(dev->of_node, "mediatek,boost-crypt-vcore-min",
 				   &cfg->vcore_volt);
@@ -889,7 +884,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki, *clki_tmp;
 	struct device *dev = hba->dev;
-	struct regulator *reg;
 	u32 volt;
 
 	/*
@@ -930,16 +924,8 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 		return;
 	}
 
-	/*
-	 * Default get vcore if dts have these settings.
-	 * No matter clock scaling support or not. (may disable by customer)
-	 */
-	reg = devm_regulator_get_optional(dev, "dvfsrc-vcore");
-	if (IS_ERR(reg)) {
-		if (PTR_ERR(reg) != -ENODEV)
-			dev_err(dev, "Failed to get dvfsrc-vcore: %pe\n", reg);
+	if (!host->reg_vcore)
 		return;
-	}
 
 	if (of_property_read_u32(dev->of_node, "clk-scale-up-vcore-min",
 				 &volt)) {
@@ -947,12 +933,11 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 		return;
 	}
 
-	host->mclk.reg_vcore = reg;
 	host->mclk.vcore_volt = volt;
 
 	/* If default boot is max gear, request vcore */
-	if (reg && volt && host->clk_scale_up)
-		if (regulator_set_voltage(reg, volt, INT_MAX))
+	if (volt && host->clk_scale_up)
+		if (regulator_set_voltage(host->reg_vcore, volt, INT_MAX))
 			dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 }
 
@@ -1064,6 +1049,17 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
 	const struct ufs_mtk_soc_data *data = of_device_get_match_data(dev);
 	int ret;
 
+	host->reg_vcore = devm_regulator_get_optional(dev, "dvfsrc-vcore");
+	if (IS_ERR(host->reg_vcore)) {
+		if (PTR_ERR(host->reg_vcore) != -ENODEV) {
+			dev_err(dev, "Failed to get dvfsrc-vcore supply: %pe\n",
+				host->reg_vcore);
+			return PTR_ERR(host->reg_vcore);
+		}
+
+		host->reg_vcore = NULL;
+	}
+
 	if (!data)
 		return 0;
 
@@ -1081,14 +1077,13 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
 
 	host->reg_avdd09 = devm_regulator_get_optional(dev, "avdd09");
 	if (IS_ERR(host->reg_avdd09)) {
-		if (PTR_ERR(host->reg_avdd09) == -ENODEV) {
-			host->reg_avdd09 = NULL;
-			return 0;
+		if (PTR_ERR(host->reg_avdd09) != -ENODEV) {
+			dev_err(dev, "Failed to get avdd09 regulator: %pe\n",
+				host->reg_avdd09);
+			return PTR_ERR(host->reg_avdd09);
 		}
 
-		dev_err(dev, "Failed to get avdd09 regulator: %pe\n",
-			host->reg_avdd09);
-		return PTR_ERR(host->reg_avdd09);
+		host->reg_avdd09 = NULL;
 	}
 
 	return 0;
@@ -1119,6 +1114,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	host->hba = hba;
 	ufshcd_set_variant(hba, host);
 
+	err = ufs_mtk_get_supplies(host);
+	if (err)
+		goto out_variant_clear;
+
 	/* Initialize host capability */
 	ufs_mtk_init_host_caps(hba);
 
@@ -1173,10 +1172,6 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_init_clocks(hba);
 
-	err = ufs_mtk_get_supplies(host);
-	if (err)
-		goto out_phy_exit;
-
 	/*
 	 * ufshcd_vops_init() is invoked after
 	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
@@ -1928,7 +1923,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
 	struct ufs_clk_info *fde_clki = mclk->ufs_fde_clki;
-	struct regulator *reg;
 	int volt, ret = 0;
 	bool clk_bind_vcore = false;
 	bool clk_fde_scale = false;
@@ -1939,9 +1933,8 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (!clki || !fde_clki)
 		return;
 
-	reg = host->mclk.reg_vcore;
 	volt = host->mclk.vcore_volt;
-	if (reg && volt != 0)
+	if (host->reg_vcore && volt)
 		clk_bind_vcore = true;
 
 	if (mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
@@ -1965,7 +1958,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 
 	if (scale_up) {
 		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(reg, volt, INT_MAX);
+			ret = regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
 			if (ret) {
 				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 				goto out;
@@ -2005,7 +1998,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 		}
 
 		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(reg, 0, INT_MAX);
+			ret = regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 			if (ret) {
 				dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
 					__func__, ERR_PTR(ret));
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index d73093900d49..634c76c903c0 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -141,7 +141,6 @@ enum ufs_mtk_host_caps {
 };
 
 struct ufs_mtk_crypt_cfg {
-	struct regulator *reg_vcore;
 	struct clk *clk_crypt_perf;
 	struct clk *clk_crypt_mux;
 	struct clk *clk_crypt_lp;
@@ -155,7 +154,6 @@ struct ufs_mtk_clk {
 	struct ufs_clk_info *ufs_fde_clki; /* Mux */
 	struct ufs_clk_info *ufs_fde_max_clki; /* Max src */
 	struct ufs_clk_info *ufs_fde_min_clki; /* Min src */
-	struct regulator *reg_vcore;
 	int vcore_volt;
 };
 
@@ -174,6 +172,7 @@ struct ufs_mtk_mcq_intr_info {
 struct ufs_mtk_host {
 	struct phy *mphy;
 	struct regulator *reg_avdd09;
+	struct regulator *reg_vcore;
 	struct reset_control_bulk_data resets[MTK_UFS_NUM_RESETS];
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;

-- 
2.55.0

