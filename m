Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795239;
	b=FrqBonMiwEz9ufBjSVzJh/UsPCKkQRSGtI/Gk6tJY1WSWOrzNhVoCVPm2hw5VR3EKXdw
	 H8EHRJ1iP52AvoeTwpXxjPjxiwjLGA/5BdltGZmS/e0ejGf+S0iOeoNm2/R6aAlb4RKSt
	 dF0Sh+Phz9yy2oiX5XgDLK2O8gz5IPHXaPlDjgTE9DGhTB5fYiNdBFmOegYfb8fENdlmc
	 UTBq5z64qEIv4vwVWdLWbEWTidh6iHMduMAdCkLCYGq6NNeYoilrOoUnomCFIlunKsVSg
	 dy5MxpU93blswrfeSRm7WPIBcM9b2xtRxz08BVYLjkEPLmZtilWivySXCKHVTkVMgXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795239;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=GtTI4H7/p5ukT6tYB3onQgsNbuPUVbCpuIyK8k4GxeY=;
	b=us71v7F9cVgIlIab3dLvAafaCLEQHI2mo3MHdNp5uF5zkFA6xFBZ3XcWEzxS1+21Jgg1
	 dbigcWsqu05xlAgkmTYLpfSXPZWS3KYqaZXp+P0Tmg2/pyIutTSSev4wkZC0Kk3iogHxi
	 GC1UhANjznyaqPm3oRmdf130PftP4BUU1P8vHTY6NDJkYvduKsJ5V9huweJLB5wHIogjL
	 gtEkQsJFXKjjaAjRjoGMci846AsaE4hyhSlyr6eJA1G3Gvw3/QWiig0LuxhRxwyyN33hj
	 zmtnmcmk0U1uhwXWj+I6HbJBmJcibQem+F727EaYeqClGK+xb19oNRXj+wLgkH19Myw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=irrRBx1e;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C29860A3807;
	Fri, 27 Nov 2026 16:00:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C29860A3807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=irrRBx1e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795795237;
	bh=9XODURj1/aPQjhdAIHQAM+FlqP2MtikTuvlHQ/OgkaU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=irrRBx1edGYiDyHBAASb84OcIqRdNpySEFIVHAWdHBDOFGpgyeXOe65pOd7MAmjH+
	 U5rsvoarr75Q3N3mpN2qIqZseGOCkCBH5mFbzGmYzcH683PIGszDCEK3FHQREGBFVf
	 2LzgdZdODJO0eFZCYCxWGW8wSz7gEeSbsmARaALKlyKQ1Qlk4+dtoypcd+UUdQsksr
	 SncCPkVNmEFjxXb5hznt4QpyAVYP5OBiMJs/9WO/I1CKrGMLMEsY0T1zaOHM23UvkS
	 YZ1RS5TZUaYGlgm6NGANcc2sgUICljTJHnNfjXwnP1+0BCqyIFgFpyDh9BxWfCPfjX
	 8cxnFmZyi22Tw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id F229117E0BA9;
	Fri, 27 Nov 2026 17:00:35 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 27 Nov 2026 17:00:13 +0100
Subject: [PATCH v16 10/23] scsi: ufs: mediatek: Rework the crypt-boost
 stuff
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261127-mt8196-ufs-v16-10-6f2568f7c119@collabora.com>
References: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
In-Reply-To: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Chun-Hung Wu <chun-hung.wu@mediatek.com>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795795222; l=4252;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=t+EX1zo42dcM7+KTo8uLwNF/1DfFs3i+4+N5UTCySt0=;
 b=YyNEmUf3FM2ks2sBgByG3NB+O0JG/jdzvenGC5svvVt/lXjXRg2uJeGVhOH1FHQYxmAMwr7te
 WiDjOawX3UmCJmTFvdDtpA/smB03pW5RSGkvbZdZaVF7E5+i5a0NnVR
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
 drivers/ufs/host/ufs-mediatek.c | 88 +++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 57 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 177e406cbc5f..41c477f5d5f3 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -617,21 +617,6 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
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
@@ -688,64 +673,53 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
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
 
-	host->crypt = devm_kzalloc_obj(dev, *(host->crypt));
-	if (!host->crypt)
-		goto disable_caps;
+	cfg = devm_kzalloc_obj(dev, *cfg);
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
2.56.1

