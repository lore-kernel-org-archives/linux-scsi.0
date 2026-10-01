Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197224A7C9B;
	Thu,  1 Oct 2026 08:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790842946; cv=none; b=Y9rpKR+MFzORMWbRp/QKeuhk2ek3niuhtSX8akfET1UhgJ68/33/WNkyNMkaRTT9CpGXwFXhuO5Gp0Mxvo82Erqrfq2+RhtJltm79n2083QXVeTQdHws9bm/EfFFBDEVaPwDqQTH1HYZwdM2BPGtX7teioj1MuAeYv7c1MaDbLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790842946; c=relaxed/simple;
	bh=7L9i93t/BVJTTaGuYZlULpi4UDuFf9Ashm27jVcSfvU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bntBEa7Jrakn8fTLz2DNMhwLxusbgeSvXOqwqLSoNPy2ELMNSGBtq1cYxioHNOM6WZWuwO+JlAwVV+TOsfVZ+AdVf8KrbCU1waoxgJvZ6axKz8U0NKcoEC88AnoyevHRqRPg1r+DVpUVvaqd+xe9+i3tfdKHhKsFSdxtOFzYSyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=dozFtOSC; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="dozFtOSC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1790842930;
	bh=7L9i93t/BVJTTaGuYZlULpi4UDuFf9Ashm27jVcSfvU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dozFtOSCZwkERxicqL95KFTpc5t2PLKUbaeMkvYh/V8Ncu57E649Ay26vJ4M/rFTB
	 YLAiIuN+dQ1fKJ8F9lSEcEwx66UUAZfVOtgFprOAVCnixrgndSFuqUT4kiGy6ebeOr
	 88jy0dJ6oWzVaokHxc8nQ5fnE+xWcPxuxh+R+Wfpr1zeQULeFoL3kf/CFbsFNgeZTE
	 xE/D5CR6JiJiL6sw9BG9T53YNlFnJewKmw8IBGD/UYSz6vCwCueWcehVVgM4ELMptx
	 WN3xNj6ORV6bhOx0gi84DWV6iC+O7Qwr7Sko86adKb4IsYnO0pMp6pjPCYYqCRLd8L
	 GezuCty9A90bw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 38ED017E056A;
	Thu, 01 Oct 2026 10:22:09 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 01 Oct 2026 10:21:42 +0200
Subject: [PATCH v13 10/24] scsi: ufs: mediatek: Rework the crypt-boost
 stuff
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261001-mt8196-ufs-v13-10-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
In-Reply-To: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
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
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790842918; l=4293;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=2v5vE4LE+FhXaNy2scnGuzCX5Bu+q/y+dkkm6/1D6fY=;
 b=vI5B2xmc4swuARPxCXwylH3QuzySS9Fdn3DKz6aCyxaPFE8qHvVCOAjZaYevPTmv8u1dNDSx5
 CRpSLiGoEC1B43Je0a5y/Kzaa0MyqsFJt+X3haoHtI+aIZtRktlaNDy
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

I don't know whether the crypt-boost functionality as it is currently
implemented is even appropriate for mainline. It might be better done in
some generic way. But what I do know is that I can rework the code to
make it less obtuse.

Prefix the boost stuff with the appropriate vendor prefix, remove the
pointless clock wrappers, and rework the function.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang (王信友) <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 89 ++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 58 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3251f6e7dfe9..7dd777e8392f 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -601,21 +601,6 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
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
@@ -672,65 +657,53 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
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
 	u32 volt;
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
+		dev_err(dev, "Failed to get dvfsrc-vcore: %pe\n", cfg->reg_vcore);
+		return;
 	}
 
-	if (of_property_read_u32(dev->of_node, "boost-crypt-vcore-min",
-				 &volt)) {
-		dev_info(dev, "failed to get boost-crypt-vcore-min");
-		goto disable_caps;
+	ret = of_property_read_u32(dev->of_node, "mediatek,boost-crypt-vcore-min",
+				   &volt);
+	if (ret) {
+		dev_err(dev, "Failed to get mediatek,boost-crypt-vcore-min: %pe\n",
+			ERR_PTR(ret));
+		return;
 	}
+	cfg->vcore_volt = volt;
 
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
2.55.0

