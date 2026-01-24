Received: from sender4-pp-f119.zoho.com (sender4-pp-f119.zoho.com [136.143.188.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D352E8B74;
	Sat, 24 Jan 2026 12:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769256157; cv=pass; b=W9pWqu6z1aLbkWvLwOOlbPaSzauLsb1twuXm+PXkmj6/l9KJd4XeT6LLb4LRGwNa80Ye7RhmKDYAc+L7WgxwG/ilpXasGaPOm4f4An6U8LHb2GuKkTEmRUAXIMw2aj3Fyx6Hwh0NO8bD4NqZpmh7tPPAOv+6xG/5emsJy05n8tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769256157; c=relaxed/simple;
	bh=7rqevkmcYA1yLF7/xhPzfzPI81cortTnhV25h5gfo4E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KFNoTB4RzRVbtDuqzGYi7phEc/r2UefpItZfQ7ziN4lnLZ8qr8HR6WuRLs/FvyAuBPT6vkkektOOQkA/kgC4Oi3IMcXjY20YzkxiFzUk5Zgq9eIvBAAYO0UsDvvbxjyrHvb1+jN2BbVLo9yxmZ0hT2Dgb8bPM/2yy+nF0VgDyno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Z+4yT40A; arc=pass smtp.client-ip=136.143.188.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Z+4yT40A"
ARC-Seal: i=1; a=rsa-sha256; t=1769256128; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fHVk7A9L6UvKsRCiMN3vdc4LkkZAxJOwjMwyKc+WFgD0KMpQSgMTu3UksvOYlB8Ae3c0BsaGEGKW8P42i/zj0oJjUcA1MSZYv/m6JHv3ROD8jQ1Xz8o4GCMFWCoEWj84JiER+ViEg3jdvnyTbprrCu4wuugTYtC16cZ0o+F/cVM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769256128; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=3Btq5ze3Dk+XwNnveSGIJE7cooTqyLjb6gxWgmCMTts=; 
	b=YFcDZbSsA6XWvtNYQvNXCxVj4O7fuM5nngZ15rEG35SNifN7ae/VmZ4PZTqD6+raf23CEuXMgIx3c9TEDkrR8+f6A46V6psi32X/9Ya5z234mie6DBtcN7ylOUZBAxoWaeQi7AAhyPecVd8gSIVKKA9x668ocaCADJH/c0SxmUY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769256128;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=3Btq5ze3Dk+XwNnveSGIJE7cooTqyLjb6gxWgmCMTts=;
	b=Z+4yT40AxDggUFGSx/3OHrwne+Ns84Hsk3zwO5gd+66/tDIc2WfE/+Ojwq94Lp8X
	IB3JbCWsmWtdzqq4vJ/MOBwZTUyKD83nAx0AsPrsi7gCZSO6WAWSARvX8RsKVM+g/gv
	ddJj09izv5Q2By9/zLoJUff3Lo9j1wHLBEyjUebw=
Received: by mx.zohomail.com with SMTPS id 1769256127593665.8798652878884;
	Sat, 24 Jan 2026 04:02:07 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Sat, 24 Jan 2026 13:00:55 +0100
Subject: [PATCH v6 09/24] scsi: ufs: mediatek: Rework the crypt-boost stuff
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260124-mt8196-ufs-v6-9-e7c005b60028@collabora.com>
References: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
In-Reply-To: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
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

I don't know whether the crypt-boost functionality as it is currently
implemented is even appropriate for mainline. It might be better done in
some generic way. But what I do know is that I can rework the code to
make it less obtuse.

Prefix the boost stuff with the appropriate vendor prefix, remove the
pointless clock wrappers, and rework the function.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang (王信友) <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 89 ++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 59 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 4cb1a1b400ac..0d8f4e542d47 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -562,21 +562,6 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 	return 0;
 }
 
-static int ufs_mtk_get_host_clk(struct device *dev, const char *name,
-				struct clk **clk_out)
-{
-	struct clk *clk;
-	int err = 0;
-
-	clk = devm_clk_get(dev, name);
-	if (IS_ERR(clk))
-		err = PTR_ERR(clk);
-	else
-		*clk_out = clk;
-
-	return err;
-}
-
 static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -633,65 +618,51 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 	clk_disable_unprepare(cfg->clk_crypt_mux);
 }
 
-static int ufs_mtk_init_host_clk(struct ufs_hba *hba, const char *name,
-				 struct clk **clk)
-{
-	int ret;
-
-	ret = ufs_mtk_get_host_clk(hba->dev, name, clk);
-	if (ret) {
-		dev_info(hba->dev, "%s: failed to get %s: %d", __func__,
-			 name, ret);
-	}
-
-	return ret;
-}
-
 static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct ufs_mtk_crypt_cfg *cfg;
 	struct device *dev = hba->dev;
-	struct regulator *reg;
-	u32 volt;
+	int ret;
 
-	host->crypt = devm_kzalloc(dev, sizeof(*(host->crypt)),
-				   GFP_KERNEL);
-	if (!host->crypt)
-		goto disable_caps;
+	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
+		return;
 
-	reg = devm_regulator_get_optional(dev, "dvfsrc-vcore");
-	if (IS_ERR(reg)) {
-		dev_info(dev, "failed to get dvfsrc-vcore: %ld",
-			 PTR_ERR(reg));
-		goto disable_caps;
+	cfg->reg_vcore = devm_regulator_get_optional(dev, "dvfsrc-vcore");
+	if (IS_ERR(cfg->reg_vcore)) {
+		dev_err(dev, "Failed to get dvfsrc-vcore: %pe", cfg->reg_vcore);
+		return;
 	}
 
-	if (of_property_read_u32(dev->of_node, "boost-crypt-vcore-min",
-				 &volt)) {
-		dev_info(dev, "failed to get boost-crypt-vcore-min");
-		goto disable_caps;
+	ret = of_property_read_u32(dev->of_node, "mediatek,boost-crypt-vcore-min",
+				   &cfg->vcore_volt);
+	if (ret) {
+		dev_err(dev, "Failed to get mediatek,boost-crypt-vcore-min: %pe\n",
+			ERR_PTR(ret));
+		return;
 	}
 
-	cfg = host->crypt;
-	if (ufs_mtk_init_host_clk(hba, "crypt_mux",
-				  &cfg->clk_crypt_mux))
-		goto disable_caps;
+	cfg->clk_crypt_mux = devm_clk_get(dev, "crypt_mux");
+	if (IS_ERR(cfg->clk_crypt_mux)) {
+		dev_err(dev, "Failed to get clock crypt_mux: %pe\n", cfg->clk_crypt_mux);
+		return;
+	}
 
-	if (ufs_mtk_init_host_clk(hba, "crypt_lp",
-				  &cfg->clk_crypt_lp))
-		goto disable_caps;
+	cfg->clk_crypt_lp = devm_clk_get(dev, "crypt_lp");
+	if (IS_ERR(cfg->clk_crypt_lp)) {
+		dev_err(dev, "Failed to get clock crypt_lp: %pe\n", cfg->clk_crypt_lp);
+		return;
+	}
 
-	if (ufs_mtk_init_host_clk(hba, "crypt_perf",
-				  &cfg->clk_crypt_perf))
-		goto disable_caps;
+	cfg->clk_crypt_perf = devm_clk_get(dev, "crypt_perf");
+	if (IS_ERR(cfg->clk_crypt_perf)) {
+		dev_err(dev, "Failed to get clock crypt_perf: %pe\n", cfg->clk_crypt_perf);
+		return;
+	}
 
-	cfg->reg_vcore = reg;
-	cfg->vcore_volt = volt;
+	host->crypt = cfg;
 	host->caps |= UFS_MTK_CAP_BOOST_CRYPT_ENGINE;
-
-disable_caps:
-	return;
 }
 
 static void ufs_mtk_init_host_caps(struct ufs_hba *hba)

-- 
2.52.0

