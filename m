Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EE434EEE0;
	Thu, 23 Oct 2025 19:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249298; cv=pass; b=b0oCWPW4j3gIVYaYBlXanHB9bb5hmcAzwR1VztzJr9HB71WVgtWjE81WULg/uzbnQmnv8LilzdF5DNcr6CRv75fpaTEhB60EI5N+dQf1XQN4vvyVdb3VyeC7/yKX/mxQ7NMFcC1d0wrpK8kyNcEAUeijfVjY2kxslnCF9LjmV0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249298; c=relaxed/simple;
	bh=Z2YmR7PkMS1YSbm0iLpHQBQSgJiGkM4/ruXx4rHJCcU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lq0cVod8GQM6nYHptiVwRveQVcuwn1cv43LYN5dGu8veyE0Xe7vthu0omwr+ULSqNgiKtUpRM/GZfcf6LXIuWhv2h/rSmOO4qjpfCixSlnb1KfbEtczEneJNSc7I6G4aP6y3jSpaAZx7ih3f6n0aX2ryIul/GS+TRi6xsOfV7vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=EfYbZfF7; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="EfYbZfF7"
ARC-Seal: i=1; a=rsa-sha256; t=1761249070; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=kh2DOk86wNOd/SNL8t9Y2k595JSm+vN0O7rsHjVHuHBlUNJIS/kxMXKVRs74WO4tek3YKaxg8RoREl5LhWL+CBiU0T6nmaRsZRLM9aw+QVCrqmyh5aPCZPQOsokpIjxY04TyRLFyrq0/Ffm0ux32HHPKurCZ1JJYCiIYkOxhJHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249070; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=b6NzRNKiv3Nyg0F/aRgR7DPEXa3XyvQBX/ydFnGvTNg=; 
	b=b9PAMB9hZVZp+CMz92vuH+nQqtqyyOeC/CA1ognpgJD1el6s4X8mry96g+ZtB0qs9VjQwxdQu/cA6xAN9Adz12W+52ZunD/yPyp5wMUEIlauG0raE++QPom/1bz8DXjznSVCJ4//SmTjySoEWf41AOlkIfxGTIpsV7c1Pzvfbjo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249070;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=b6NzRNKiv3Nyg0F/aRgR7DPEXa3XyvQBX/ydFnGvTNg=;
	b=EfYbZfF7gbLSTnK6tv97bD76v7y0QIB01K1i5OyKHvmuTUmY9dbLD3Q6OWAKoApW
	Ic30PWMym9eQiR0bCwQQUktstXeON5E7F3hdiA0g7CQWc5Jw26xcvQZTSn8IdkD4t5K
	9L/bMuUrCXdDqNn4CecSOumeQepgXbdb0WzBmPpw=
Received: by mx.zohomail.com with SMTPS id 1761249069163707.8494877333445;
	Thu, 23 Oct 2025 12:51:09 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:27 +0200
Subject: [PATCH v3 09/24] scsi: ufs: mediatek: Rework the crypt-boost stuff
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-9-0f04b4a795ff@collabora.com>
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

I don't know whether the crypt-boost functionality as it is currently
implemented is even appropriate for mainline. It might be better done in
some generic way. But what I do know is that I can rework the code to
make it less obtuse.

Prefix the boost stuff with the appropriate vendor prefix, remove the
pointless clock wrappers, and rework the function.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 91 +++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 59 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 131f71145a12..9c0ac72d6e43 100644
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
@@ -633,65 +618,53 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
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
-static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
+static int ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
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
+		return -ENOMEM;
 
-	reg = devm_regulator_get_optional(dev, "dvfsrc-vcore");
-	if (IS_ERR(reg)) {
-		dev_info(dev, "failed to get dvfsrc-vcore: %ld",
-			 PTR_ERR(reg));
-		goto disable_caps;
+	cfg->reg_vcore = devm_regulator_get_optional(dev, "dvfsrc-vcore");
+	if (IS_ERR(cfg->reg_vcore)) {
+		dev_err(dev, "Failed to get dvfsrc-vcore: %pe", cfg->reg_vcore);
+		return PTR_ERR(cfg->reg_vcore);
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
+		return ret;
 	}
 
-	cfg = host->crypt;
-	if (ufs_mtk_init_host_clk(hba, "crypt_mux",
-				  &cfg->clk_crypt_mux))
-		goto disable_caps;
+	cfg->clk_crypt_mux = devm_clk_get(dev, "crypt_mux");
+	if (IS_ERR(cfg->clk_crypt_mux)) {
+		dev_err(dev, "Failed to get clock crypt_mux: %pe\n", cfg->clk_crypt_mux);
+		return PTR_ERR(cfg->clk_crypt_mux);
+	}
 
-	if (ufs_mtk_init_host_clk(hba, "crypt_lp",
-				  &cfg->clk_crypt_lp))
-		goto disable_caps;
+	cfg->clk_crypt_lp = devm_clk_get(dev, "crypt_lp");
+	if (IS_ERR(cfg->clk_crypt_lp)) {
+		dev_err(dev, "Failed to get clock crypt_lp: %pe\n", cfg->clk_crypt_lp);
+		return PTR_ERR(cfg->clk_crypt_lp);
+	}
 
-	if (ufs_mtk_init_host_clk(hba, "crypt_perf",
-				  &cfg->clk_crypt_perf))
-		goto disable_caps;
+	cfg->clk_crypt_perf = devm_clk_get(dev, "crypt_perf");
+	if (IS_ERR(cfg->clk_crypt_perf)) {
+		dev_err(dev, "Failed to get clock crypt_perf: %pe\n", cfg->clk_crypt_perf);
+		return PTR_ERR(cfg->clk_crypt_perf);
+	}
 
-	cfg->reg_vcore = reg;
-	cfg->vcore_volt = volt;
+	host->crypt = cfg;
 	host->caps |= UFS_MTK_CAP_BOOST_CRYPT_ENGINE;
 
-disable_caps:
-	return;
+	return 0;
 }
 
 static void ufs_mtk_init_host_caps(struct ufs_hba *hba)

-- 
2.51.1.dirty

