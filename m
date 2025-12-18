Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E377339860;
	Thu, 18 Dec 2025 12:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766062647; cv=pass; b=gIb6Od0RK+UTmJrK6C9L5ircI1zdscU5P2HTImOwXAVNKSZgv+D/YGlcL4tyPfY0EIAxJZImr7MnhB3FL8rTBLC+JrvpkhbF+epVBVFVDkEHBYwVKKJEE+Nn4H0aEfMHlpZW4FM6uGUkQEI50DTv+jnsiwK61izX7yLpfYU8TmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766062647; c=relaxed/simple;
	bh=LWMlzSoTxDNgARzpkHK2WDdmNrt8RKLSOSGhHAObYrU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NShJPsgE5MXXQ4C4KA1ZY8Chj9rTOPpPbyiBcHa5biZW+3xhTCn+vXtlp8gaZu4Lk74TQ/mlRWQKFpbZ5w5ioJvnJ57BytbcIVn89OFoQdmH3U9u/Cbxkd80Yjkxej9tBFCHhfyA32uFgo4lvDlu/79hG5BB/E0QMwmkVFALhu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=bL0j2K5k; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="bL0j2K5k"
ARC-Seal: i=1; a=rsa-sha256; t=1766062614; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=l3aGq9QDz41gJbokdMzYD50Z8g//EH0nmtjFOa0Kgo+H/qEdD9Cgf4gZKeF8CZPstgk8CAnlwzM1q83EzGoDAqwolxGALjpDnJiKsKVAiCNmgJ+EP0f+Aj1QG1tPNzc64nD6P8lm+rNWH+nhuQfRzLsKyYRp7FvVp+KG5wEnpuM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766062614; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=lIRA5jBmzjNM1Jhu5oCUpBq81ZSbzIvIV0wFiZyrEjY=; 
	b=bzIK1XgYoQ/AKwP0lsah5psrpkDansQQrb6rJX51R+FiEaUZTZHIni53Oi517+4HtNcZeynLyyVu48XhyiSECRP0MP3BmpKrA32Sw+gQcqFnOFjyGsHCCDbkwGY3QT9u7jeGmYwKWRS070LMqwG8aQHJNnfZvu6GsQr4B9QSZa0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766062614;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=lIRA5jBmzjNM1Jhu5oCUpBq81ZSbzIvIV0wFiZyrEjY=;
	b=bL0j2K5kZgXBQTF4qaC6akzmQmGfzwfjuP2qPUiM8JB3nYNAvwvZ/oG7aLvUkkvR
	G40wxQhmtdABp7+52RhucmM8PyNy+SMzdcnFyXAdIt3l15WQLVY6nLkKg+DzImCOqxr
	YnXpmPdFEZGLw6Z9v0XFqwBt4+SFAsywpggXFDyg=
Received: by mx.zohomail.com with SMTPS id 1766062614054781.808413243351;
	Thu, 18 Dec 2025 04:56:54 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 18 Dec 2025 13:55:03 +0100
Subject: [PATCH v4 13/25] scsi: ufs: mediatek: Use the common PHY framework
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251218-mt8196-ufs-v4-13-ddec7a369dd2@collabora.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
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

There is no need to reinvent the PHY framework, especially not its OF
parsing.

Change the code to simply use the PHY framework to acquire the device's
PHY in the ufshcd init, so that it's device linked to the right device.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 133 ++++++++++++----------------------------
 drivers/ufs/host/ufs-mediatek.h |   1 -
 2 files changed, 40 insertions(+), 94 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 6385ebcc9142..b3fb87bd1c75 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -293,44 +293,6 @@ static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
 	return 0;
 }
 
-static int ufs_mtk_bind_mphy(struct ufs_hba *hba)
-{
-	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-	struct device *dev = hba->dev;
-	struct device_node *np = dev->of_node;
-	int err = 0;
-
-	host->mphy = devm_of_phy_get_by_index(dev, np, 0);
-
-	if (host->mphy == ERR_PTR(-EPROBE_DEFER)) {
-		/*
-		 * UFS driver might be probed before the phy driver does.
-		 * In that case we would like to return EPROBE_DEFER code.
-		 */
-		err = -EPROBE_DEFER;
-		dev_info(dev,
-			 "%s: required phy hasn't probed yet. err = %d\n",
-			__func__, err);
-	} else if (IS_ERR(host->mphy)) {
-		err = PTR_ERR(host->mphy);
-		if (err != -ENODEV) {
-			dev_info(dev, "%s: PHY get failed %d\n", __func__,
-				 err);
-		}
-	}
-
-	if (err)
-		host->mphy = NULL;
-	/*
-	 * Allow unbound mphy because not every platform needs specific
-	 * mphy control.
-	 */
-	if (err == -ENODEV)
-		err = 0;
-
-	return err;
-}
-
 static int ufs_mtk_setup_ref_clk(struct ufs_hba *hba, bool on)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -1203,13 +1165,21 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_init_mcq_irq(hba);
 
-	err = ufs_mtk_bind_mphy(hba);
-	if (err)
+	host->mphy = devm_phy_get(dev, NULL);
+	if (IS_ERR(host->mphy)) {
+		err = dev_err_probe(dev, PTR_ERR(host->mphy), "Failed to get PHY\n");
+		goto out_variant_clear;
+	}
+
+	err = phy_init(host->mphy);
+	if (err) {
+		dev_err_probe(dev, err, "Failed to initialize PHY\n");
 		goto out_variant_clear;
+	}
 
 	err = ufs_mtk_init_reset(hba);
 	if (err)
-		goto out_variant_clear;
+		goto out_phy_exit;
 
 	/* Enable runtime autosuspend */
 	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
@@ -1248,7 +1218,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	err = ufs_mtk_get_supplies(host);
 	if (err)
-		goto out_variant_clear;
+		goto out_phy_exit;
 
 	/*
 	 * ufshcd_vops_init() is invoked after
@@ -1273,11 +1243,22 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	return 0;
 
+out_phy_exit:
+	phy_exit(host->mphy);
 out_variant_clear:
 	ufshcd_set_variant(hba, NULL);
 	return err;
 }
 
+static void ufs_mtk_exit(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	ufs_mtk_mphy_power_on(hba, false);
+
+	phy_exit(host->mphy);
+}
+
 static bool ufs_mtk_pmc_via_fastauto(struct ufs_hba *hba,
 				     struct ufs_pa_layer_attr *dev_req_params)
 {
@@ -2279,6 +2260,7 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.name                = "mediatek.ufshci",
 	.max_num_rtt         = MTK_MAX_NUM_RTT,
 	.init                = ufs_mtk_init,
+	.exit                = ufs_mtk_exit,
 	.get_ufs_hci_version = ufs_mtk_get_ufs_hci_version,
 	.setup_clocks        = ufs_mtk_setup_clocks,
 	.hce_enable_notify   = ufs_mtk_hce_enable_notify,
@@ -2337,50 +2319,17 @@ MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
  */
 static int ufs_mtk_probe(struct platform_device *pdev)
 {
-	struct platform_device *phy_pdev;
 	struct device *dev = &pdev->dev;
-	struct device_node *phy_node;
-	struct ufs_mtk_host *host;
-	struct device *phy_dev;
 	struct ufs_hba *hba;
-	int err;
-
-	/* find phy node */
-	phy_node = of_parse_phandle(dev->of_node, "phys", 0);
-	if (!phy_node)
-		return dev_err_probe(dev, -ENOENT, "No PHY node found\n");
-
-	phy_pdev = of_find_device_by_node(phy_node);
-	of_node_put(phy_node);
-	if (!phy_pdev)
-		return dev_err_probe(dev, -ENODEV, "No PHY device found\n");
-
-	phy_dev = &phy_pdev->dev;
-
-	err = pm_runtime_set_active(phy_dev);
-	if (err) {
-		dev_err_probe(dev, err, "Failed to activate PHY RPM\n");
-		goto err_put_phy;
-	}
-	pm_runtime_enable(phy_dev);
-	err = pm_runtime_get_sync(phy_dev);
-	if (err) {
-		dev_err_probe(dev, err, "Failed to power on PHY\n");
-		goto err_put_phy;
-	}
+	int ret;
 
 	/* perform generic probe */
-	err = ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
-	if (err) {
-		dev_err_probe(dev, err, "Generic platform probe failed\n");
-		goto err_put_phy;
-	}
+	ret = ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
+	if (ret)
+		return dev_err_probe(dev, ret, "Generic platform probe failed\n");
 
 	hba = platform_get_drvdata(pdev);
 
-	host = ufshcd_get_variant(hba);
-	host->phy_dev = phy_dev;
-
 	/*
 	 * Because the default power setting of VSx (the upper layer of
 	 * VCCQ/VCCQ2) is HWLP, we need to prevent VCCQ/VCCQ2 from
@@ -2389,18 +2338,11 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
 	return 0;
-
-err_put_phy:
-	put_device(phy_dev);
-
-	return err;
 }
 
 /**
  * ufs_mtk_remove - set driver_data of the device to NULL
  * @pdev: pointer to platform device handle
- *
- * Always return 0
  */
 static void ufs_mtk_remove(struct platform_device *pdev)
 {
@@ -2460,9 +2402,8 @@ static int ufs_mtk_system_resume(struct device *dev)
 static int ufs_mtk_runtime_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct arm_smccc_res res;
-	int ret = 0;
+	int ret;
 
 	ret = ufshcd_runtime_suspend(dev);
 	if (ret)
@@ -2473,8 +2414,11 @@ static int ufs_mtk_runtime_suspend(struct device *dev)
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(false, res);
 
-	if (host->phy_dev)
-		pm_runtime_put_sync(host->phy_dev);
+	ret = ufs_mtk_mphy_power_on(hba, false);
+	if (ret) {
+		dev_err(dev, "Failed to power off PHY: %pe\n", ERR_PTR(ret));
+		return ret;
+	}
 
 	return 0;
 }
@@ -2482,14 +2426,17 @@ static int ufs_mtk_runtime_suspend(struct device *dev)
 static int ufs_mtk_runtime_resume(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
-	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct arm_smccc_res res;
+	int ret;
 
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(true, res);
 
-	if (host->phy_dev)
-		pm_runtime_get_sync(host->phy_dev);
+	ret = ufs_mtk_mphy_power_on(hba, true);
+	if (ret) {
+		dev_err(dev, "Failed to power on PHY: %pe\n", ERR_PTR(ret));
+		return ret;
+	}
 
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index cb32fc987864..bf8122af69f0 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -197,7 +197,6 @@ struct ufs_mtk_host {
 	bool is_mcq_intr_enabled;
 	int mcq_nr_intr;
 	struct ufs_mtk_mcq_intr_info mcq_intr_info[UFSHCD_MAX_Q_NR];
-	struct device *phy_dev;
 };
 
 /* MTK delay of autosuspend: 500 ms */

-- 
2.52.0

