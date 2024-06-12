Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF33716C856;
	Wed, 12 Jun 2024 07:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178209; cv=none; b=ghcsHofhxGtYOOpaJUO+YUFsvaSim+qYeCBaIpifqQJkJ61I0X0HeA9W1fpsTGBsbA+bmsDTbVdk6i28oqWqSuHzzWX77WrSMbdxp7fF1GcU+tDT/PFWYjNJtaLYoREMbrv8ktTX9kyytZmZ5FpOHWWCfJm9jZaNb/QnQoTmfKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178209; c=relaxed/simple;
	bh=XTxdq7yH2tRPSNAKGFLMAQfypYpTrjvxDfqFeM7tqxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQApOQ2Sls11z1ub6C2ncKE3p872kzWWTAQq5m90Hsn3jaV8ra1rKIlaVWf53EA2lrUaXpFSIY8ioUik75632Q6bVnxUjUe004Ji9QPRQbpKAnBaHxNFywwNtQSNxZD6PVPp8O6yd9Zlc1mnelpVE/vfZOq1QMCTbftU1S6KwYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=P64NqKUr; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="P64NqKUr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178206;
	bh=XTxdq7yH2tRPSNAKGFLMAQfypYpTrjvxDfqFeM7tqxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P64NqKUrOcVq8coM8pIRjnqWlRA1bH6e2k9eoFmEXtl9mxjWsCe86QTzUbCfoJZ/E
	 FAMmjlSCeKlz09ggH9hgfJ3SASzr79ABe+Y8YD2t0cSZDHwtZGrGDgk/RUPVASa4yR
	 rizTeMkgmSt7Mrf0/V1hDctVcCR8T61oA88lePsFzdLuz5Wai/qb7JJPq2uS/AF87W
	 F81bJwdRQjb3JdTteRZV+q7osXRZ/aQiOi90Cp4WZ7xKg86hugUJwepcDCHakruuaI
	 8ag4Ttilq88EwFTgz9QT37tpvge10n3IuckBlYnuTsnFfG7PPq2NvMCNv55UJDxgxu
	 IvFxRVDpzmJiw==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 0C8A7378219A;
	Wed, 12 Jun 2024 07:43:24 +0000 (UTC)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: linux-scsi@vger.kernel.org
Cc: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	peter.wang@mediatek.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	wenst@chromium.org,
	michael@walle.cc
Subject: [PATCH v5 3/8] scsi: ufs: ufs-mediatek: Remove useless mediatek,ufs-boost-crypt property
Date: Wed, 12 Jun 2024 09:43:04 +0200
Message-ID: <20240612074309.50278-4-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
References: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to have a property that activates the inline crypto
boost feature, as this needs many things: a regulator, three clocks,
and the mediatek,boost-crypt-microvolt property to be set.

If any one of these is missing, the feature won't be activated,
hence, it is useless to have yet one more property to enable that.

While at it, also address another two issues:
1. Give back the return value to the caller and make sure to fail
   probing if we get an -EPROBE_DEFER or -ENOMEM; and
2. Free the ufs_mtk_crypt_cfg structure allocated in the crypto
   boost function if said functionality could not be enabled because
   it's not supported, as that'd be only wasted memory.

Last but not least, move the devm_kzalloc() call for ufs_mtk_crypt_cfg
to after getting the dvfsrc-vcore regulator and the boost microvolt
property, as if those fail there's no reason to even allocate that.

Fixes: ac8c2459091c ("scsi: ufs-mediatek: Decouple features from platform bindings")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 55 ++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 23271eb1a244..8d0e7ea52541 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -576,51 +576,55 @@ static int ufs_mtk_init_host_clk(struct ufs_hba *hba, const char *name,
 	return ret;
 }
 
-static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
+static int ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct ufs_mtk_crypt_cfg *cfg;
 	struct device *dev = hba->dev;
 	struct regulator *reg;
 	u32 volt;
-
-	host->crypt = devm_kzalloc(dev, sizeof(*(host->crypt)),
-				   GFP_KERNEL);
-	if (!host->crypt)
-		goto disable_caps;
+	int ret;
 
 	reg = devm_regulator_get_optional(dev, "dvfsrc-vcore");
 	if (IS_ERR(reg)) {
-		dev_info(dev, "failed to get dvfsrc-vcore: %ld",
-			 PTR_ERR(reg));
-		goto disable_caps;
+		ret = PTR_ERR(reg);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
+		return 0;
 	}
 
-	if (of_property_read_u32(dev->of_node, "mediatek,boost-crypt-microvolt",
-				 &volt)) {
+	ret = of_property_read_u32(dev->of_node, "mediatek,boost-crypt-microvolt", &volt);
+	if (ret) {
 		dev_info(dev, "failed to get mediatek,boost-crypt-microvolt");
-		goto disable_caps;
+		return 0;
 	}
 
+	host->crypt = devm_kzalloc(dev, sizeof(*host->crypt), GFP_KERNEL);
+	if (!host->crypt)
+		return -ENOMEM;
+
 	cfg = host->crypt;
-	if (ufs_mtk_init_host_clk(hba, "crypt_mux",
-				  &cfg->clk_crypt_mux))
-		goto disable_caps;
+	ret = ufs_mtk_init_host_clk(hba, "crypt_mux", &cfg->clk_crypt_mux);
+	if (ret)
+		goto out;
 
-	if (ufs_mtk_init_host_clk(hba, "crypt_lp",
-				  &cfg->clk_crypt_lp))
-		goto disable_caps;
+	ret = ufs_mtk_init_host_clk(hba, "crypt_lp", &cfg->clk_crypt_lp);
+	if (ret)
+		goto out;
 
-	if (ufs_mtk_init_host_clk(hba, "crypt_perf",
-				  &cfg->clk_crypt_perf))
-		goto disable_caps;
+	ret = ufs_mtk_init_host_clk(hba, "crypt_perf", &cfg->clk_crypt_perf);
+	if (ret)
+		goto out;
 
 	cfg->reg_vcore = reg;
 	cfg->vcore_volt = volt;
 	host->caps |= UFS_MTK_CAP_BOOST_CRYPT_ENGINE;
 
-disable_caps:
-	return;
+out:
+	if (ret)
+		devm_kfree(dev, host->crypt);
+	return 0;
 }
 
 static int ufs_mtk_init_va09_pwr_ctrl(struct ufs_hba *hba)
@@ -649,8 +653,9 @@ static int ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	struct device_node *np = hba->dev->of_node;
 	int ret;
 
-	if (of_property_read_bool(np, "mediatek,ufs-boost-crypt"))
-		ufs_mtk_init_boost_crypt(hba);
+	ret = ufs_mtk_init_boost_crypt(hba);
+	if (ret)
+		return ret;
 
 	ret = ufs_mtk_init_va09_pwr_ctrl(hba);
 	if (ret)
-- 
2.45.2

