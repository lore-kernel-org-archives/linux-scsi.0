Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D971483802;
	Tue,  1 Sep 2026 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277189; cv=none; b=lHSKiAScUFyB5pBvUfNK8c/hfl8tS3BgNnRS7h/qvBheKqxO5l5ylk0xfxzm8clf7B5TPQ8ug4Owx10qa7puoKnkmtEl30ZLuaItL3HQu9LJ0aDT2NHDQgsJHm9uYf/gxahGyHvB5b2uQ5cEAwevxR4GGAOKIO9FUV/Qc8FFjSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277189; c=relaxed/simple;
	bh=Z9IqXxZNS01isTEbUjUawnhnkzuZiZ/o6njcGnQDOfg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jbhJBzQYhIkWxaWo8vhgwMpQegRZtd6H6FisZvtntQCvEukrEt5dQXvewO5726m0DvhGE0IlMWM70GKilRjgnwK+lyWgT5aqUXnuQorCbv2HnDUOxAnn3ebLlYAssmzdaIE6jbe6CYrntelmPwxcSWb1J77Roma+s+74mkqpxIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=hHl+wSGk; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="hHl+wSGk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1788277185;
	bh=Z9IqXxZNS01isTEbUjUawnhnkzuZiZ/o6njcGnQDOfg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hHl+wSGkExRdNIbl56hlywfeJZVp+NUcAKIo8gXs6ivWkTw1AnuxY7Pcvkpj/40YB
	 GSoJE27lIuSLI4JJMkXzJgtbrCYdTbNlPLMa+4dIpQhhb55VGydea/5uNGYe46Gp/F
	 bAiQtnQlN4crbZ1r9km+ZiPa4HTrOiHDyPV4f+MfEWB5Q4Tm/WoMho+KxLxfwW48Hx
	 ogl0PeSwgDOjzwWMd7AE9JHdSnk3b0S6e8s01ZHF1fZhK7fPrw/4RT3nqiVKsY/C6f
	 Z+8lYenlYhiYsOZPDZAtSUdow7ZIR9qY6qX/IPDxne/UdF6V6nlkkOwnihQw0NRH9U
	 DvaT5MiY50YtQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id BE62817E0FCC;
	Tue, 01 Sep 2026 17:39:44 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Tue, 01 Sep 2026 17:39:07 +0200
Subject: [PATCH v11 19/24] scsi: ufs: mediatek: Don't acquire dvfsrc-vcore
 twice
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mt8196-ufs-v11-19-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
In-Reply-To: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
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
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788277163; l=7843;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=Nzb2DxtXypiMhGT1x7WnE4AmAql6lK9b9F95aIeoDPs=;
 b=u0GI+fHLB6pFAUEYPhcU+jSoBo11/BvGHx3wGNIax9Qm7OFN4osuWqi702BYdVxGEqp4fKjOd
 NgmGucv8lfOAGM+MwHLYf2j4vocv2CxTcLjf8JR6O3zInyV8c8wfUgy
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
 drivers/ufs/host/ufs-mediatek.c | 60 +++++++++++++++++++----------------------
 drivers/ufs/host/ufs-mediatek.h |  3 +--
 2 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index c71a4034127e..4e916d5ac2af 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -546,7 +546,6 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct ufs_mtk_crypt_cfg *cfg;
-	struct regulator *reg;
 	int volt, ret;
 
 	if (!ufs_mtk_is_boost_crypt_enabled(hba))
@@ -554,7 +553,6 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 
 	cfg = host->crypt;
 	volt = cfg->vcore_volt;
-	reg = cfg->reg_vcore;
 
 	ret = clk_prepare_enable(cfg->clk_crypt_mux);
 	if (ret) {
@@ -564,7 +562,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 	}
 
 	if (boost) {
-		ret = regulator_set_voltage(reg, volt, INT_MAX);
+		ret = regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to set vcore to %d: %pe\n",
 				__func__, volt, ERR_PTR(ret));
@@ -575,7 +573,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to reparent clk_crypt_perf: %pe\n",
 				__func__, ERR_PTR(ret));
-			regulator_set_voltage(reg, 0, INT_MAX);
+			regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 			goto out;
 		}
 	} else {
@@ -586,7 +584,7 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 			goto out;
 		}
 
-		ret = regulator_set_voltage(reg, 0, INT_MAX);
+		ret = regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
 				__func__, ERR_PTR(ret));
@@ -604,15 +602,12 @@ static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 	u32 volt;
 	int ret;
 
-	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
-	if (!cfg)
+	if (!host->reg_vcore)
 		return;
 
-	cfg->reg_vcore = devm_regulator_get_optional(dev, "dvfsrc-vcore");
-	if (IS_ERR(cfg->reg_vcore)) {
-		dev_err(dev, "Failed to get dvfsrc-vcore: %pe\n", cfg->reg_vcore);
+	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
 		return;
-	}
 
 	ret = of_property_read_u32(dev->of_node, "mediatek,boost-crypt-vcore-min",
 				   &volt);
@@ -918,7 +913,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki, *clki_tmp;
 	struct device *dev = hba->dev;
-	struct regulator *reg;
 	u32 volt;
 
 	/*
@@ -959,16 +953,8 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
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
@@ -976,12 +962,11 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
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
 
@@ -1093,6 +1078,17 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
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
 
@@ -1159,6 +1155,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	host->hba = hba;
 	ufshcd_set_variant(hba, host);
 
+	err = ufs_mtk_get_supplies(host);
+	if (err)
+		goto out_variant_clear;
+
 	/* Initialize host capability */
 	ufs_mtk_init_host_caps(hba);
 
@@ -1213,10 +1213,6 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_init_clocks(hba);
 
-	err = ufs_mtk_get_supplies(host);
-	if (err)
-		goto out_phy_exit;
-
 	/*
 	 * ufshcd_vops_init() is invoked after
 	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
@@ -1968,7 +1964,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
 	struct ufs_clk_info *fde_clki = mclk->ufs_fde_clki;
-	struct regulator *reg;
 	int volt, ret = 0;
 	bool clk_bind_vcore = false;
 	bool clk_fde_scale = false;
@@ -1979,9 +1974,8 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (!clki || !fde_clki)
 		return;
 
-	reg = host->mclk.reg_vcore;
 	volt = host->mclk.vcore_volt;
-	if (reg && volt != 0)
+	if (host->reg_vcore && volt)
 		clk_bind_vcore = true;
 
 	if (mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
@@ -2005,7 +1999,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 
 	if (scale_up) {
 		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(reg, volt, INT_MAX);
+			ret = regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
 			if (ret) {
 				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 				goto out;
@@ -2045,7 +2039,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 		}
 
 		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(reg, 0, INT_MAX);
+			ret = regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
 			if (ret) {
 				dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
 					__func__, ERR_PTR(ret));
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index d97951ee1f4e..6b81c8f76201 100644
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
 
@@ -175,6 +173,7 @@ struct ufs_mtk_host {
 	struct phy *mphy;
 	struct regulator *reg_avdd09;
 	struct regulator *reg_avdd09_1;
+	struct regulator *reg_vcore;
 	struct reset_control_bulk_data resets[MTK_UFS_NUM_RESETS];
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;

-- 
2.55.0

