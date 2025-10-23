Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7D134DCE1;
	Thu, 23 Oct 2025 19:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249171; cv=pass; b=eD8ssjHbWElQQyhnrYf9ZWpmPrkN1TtudlAY+8m8OF50PeeiAJ6OKX+yEZmQmOlv+cn5JYgkr6G/bCqaLWCn3u5B5STKknTNX/zB1yu5Czkmkb+cMRTshQOyM7NiCI5Nzzvc4IH+2OCQbveFtq2Re4W6XGF+4EyDKCZqxQZXjiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249171; c=relaxed/simple;
	bh=CI48vN+OqW//gI6MJ6d0uNY7uB8RUoFXhC16x/KJ4us=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O8H3p8G0Ot3r8BtGN8w35mX1CgKjc2JSWUCyFXZbA/6ZY9YhMFefsRuhuzJHazG7frC9T9d7dQY01jjnQS3LbkVIP+MVN33kjkN7NR7+yaiK838OYA+cBA//Q/OK6ixNCKphf4BQo4fpTJyjRl8e5CZPxqZPHwi/7ZEA8dSUsho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=jVkNqpab; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="jVkNqpab"
ARC-Seal: i=1; a=rsa-sha256; t=1761249132; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FXOUrbU6QAwjuzQCocan6fHumSb5oTWfVVP6/8un24LxeRIjJdGP40RKP1sk7C0NRNPM7j+svssJzdBcRHyzjE/5m7WpHidMQhzNAcEj0MHxfhMXn2nufdTfUIku0ZpAjdGPK+nNXTuWT2pE/J9ziTtU5APjhktFMp/e4dfviMg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249132; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=KR+BcCsecTnzFh4LHEoMyJI1b62+9nwBXGXT9X6PEOo=; 
	b=BehPvXJ6CvEuO8wJcbpvT/xFJTRv0TPffliXRm96AnVjc17xdtCftQhPJMowYTa473G1qpdQmuck+wGWVO5VhnHH3W6rvyJcaKNXTSj54x4UAJqXGuyIKeDWU8nu5NMoaOQWXa3gBA+2CC/1WlDQgGqxDCFMcs17FNVfPfSAm9Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249132;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=KR+BcCsecTnzFh4LHEoMyJI1b62+9nwBXGXT9X6PEOo=;
	b=jVkNqpabpZXj7dwMafkIozpXZFUtWWvPZMEfROqfY+1f6SlHVWPhJdxuz5aHIgvS
	R49IAqoaGBuUqMuDprpwqPZ+Vk1BR6HkN7A7nm92HL1kqoekY/+Y2eG7/EBJV3K8oOT
	GkgcQQkhiUazL5ODC1FKE6bThGuFCWnqdAT/l6J0=
Received: by mx.zohomail.com with SMTPS id 176124913108355.027902607352644;
	Thu, 23 Oct 2025 12:52:11 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:37 +0200
Subject: [PATCH v3 19/24] scsi: ufs: mediatek: Don't acquire dvfsrc-vcore
 twice
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-19-0f04b4a795ff@collabora.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
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
 Mark Brown <broonie@kernel.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

As part of its featureset, the ufs-mediatek driver needs to play with an
optional dvfsrc-vcore regulator for some of them.

However, it currently does this by acquiring two different references to
it in two different places, needlessly duplicating logic.

Move reg_vcore to the host struct, acquire it in the same function as
avdd09 is acquired, and rework the users of reg_vcore.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 73 +++++++++++++++++++----------------------
 drivers/ufs/host/ufs-mediatek.h |  3 +-
 2 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index a2e5c2cdafe1..22b9e10b1560 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -517,15 +517,13 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct ufs_mtk_crypt_cfg *cfg;
-	struct regulator *reg;
 	int volt, ret;
 
-	if (!ufs_mtk_is_boost_crypt_enabled(hba))
+	if (!ufs_mtk_is_boost_crypt_enabled(hba) || !host->reg_vcore)
 		return;
 
 	cfg = host->crypt;
 	volt = cfg->vcore_volt;
-	reg = cfg->reg_vcore;
 
 	ret = clk_prepare_enable(cfg->clk_crypt_mux);
 	if (ret) {
@@ -535,7 +533,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 	}
 
 	if (boost) {
-		ret = regulator_set_voltage(reg, volt, INT_MAX);
+		ret = regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to set vcore to %d: %pe\n",
 				__func__, volt, ERR_PTR(ret));
@@ -546,7 +544,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to reparent clk_crypt_perf: %pe\n",
 				__func__, ERR_PTR(ret));
-			regulator_set_voltage(reg, 0, INT_MAX);
+			regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 			goto out;
 		}
 	} else {
@@ -557,7 +555,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 			goto out;
 		}
 
-		ret = regulator_set_voltage(reg, 0, INT_MAX);
+		ret = regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
 				__func__, ERR_PTR(ret));
@@ -574,16 +572,13 @@ static int ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	int ret;
 
+	if (!host->reg_vcore)
+		return 0;
+
 	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
 	if (!cfg)
 		return -ENOMEM;
 
-	cfg->reg_vcore = devm_regulator_get_optional(dev, "dvfsrc-vcore");
-	if (IS_ERR(cfg->reg_vcore)) {
-		dev_err(dev, "Failed to get dvfsrc-vcore: %pe", cfg->reg_vcore);
-		return PTR_ERR(cfg->reg_vcore);
-	}
-
 	ret = of_property_read_u32(dev->of_node, "mediatek,boost-crypt-vcore-min",
 				   &cfg->vcore_volt);
 	if (ret) {
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
 
 	if (of_property_read_u32(dev->of_node, "mediatek,clk-scale-up-vcore-min",
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
 
@@ -1063,19 +1048,29 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
 	struct device *dev = host->hba->dev;
 	const struct ufs_mtk_soc_data *data = of_device_get_match_data(dev);
 
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
 	if (!data || !data->has_avdd09)
 		return 0;
 
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
@@ -1106,6 +1101,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	host->hba = hba;
 	ufshcd_set_variant(hba, host);
 
+	err = ufs_mtk_get_supplies(host);
+	if (err)
+		goto out_variant_clear;
+
 	/* Initialize host capability */
 	ufs_mtk_init_host_caps(hba);
 
@@ -1160,10 +1159,6 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_init_clocks(hba);
 
-	err = ufs_mtk_get_supplies(host);
-	if (err)
-		goto out_phy_exit;
-
 	/*
 	 * ufshcd_vops_init() is invoked after
 	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
@@ -1903,7 +1898,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
 	struct ufs_clk_info *fde_clki = mclk->ufs_fde_clki;
-	struct regulator *reg;
 	int volt, ret = 0;
 	bool clk_bind_vcore = false;
 	bool clk_fde_scale = false;
@@ -1914,9 +1908,8 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (!clki || !fde_clki)
 		return;
 
-	reg = host->mclk.reg_vcore;
 	volt = host->mclk.vcore_volt;
-	if (reg && volt != 0)
+	if (host->reg_vcore && volt)
 		clk_bind_vcore = true;
 
 	if (mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
@@ -1940,7 +1933,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 
 	if (scale_up) {
 		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(reg, volt, INT_MAX);
+			ret = regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
 			if (ret) {
 				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 				goto out;
@@ -1980,7 +1973,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 		}
 
 		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(reg, 0, INT_MAX);
+			ret = regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 			if (ret) {
 				dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
 					__func__, ERR_PTR(ret));
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 9c377745f7a0..fa27ab4d6d6c 100644
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
2.51.1.dirty

