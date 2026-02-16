Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E543F224B0E;
	Mon, 16 Feb 2026 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771249177; cv=pass; b=aiRq9jRJ0ots1PnzOpniv1oZVWLA2CdfjU3wQXOds/tfpebXC3lSNmzQ6GuLCezJB+u2fUBnaUVlpBye9AjUYYlljabQdaVYDcIQSP055REMUqP/OiNb3tnSPcI5S0Rhn82tY+A/NEwc+UegB6kbpCugyoHExUfmPSp/BfD0kOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771249177; c=relaxed/simple;
	bh=d+MRwJGzxJ4qwCxjAgJ8J/DGO2HxUHcRY0+w8XCDnEM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ObUoEUDUmzn2WSuGr27oFZ80ANdx5c6SG5mJEiK71CE3l6TWoctm2Zy4k7M2tPYOIW0lhua4eKf2RJ+tKnXOfCEFY1Fgs95zx7+RGSkR+0AUtbbH1LTtuAJ40Mic6oYhw66AZwTUL6SdBJRQGIdvjsXjObDfknsuOjVkRiNd/dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=hr1A/3E8; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="hr1A/3E8"
ARC-Seal: i=1; a=rsa-sha256; t=1771249143; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VHd0n4X3ngqjp9j1YQAisFEUebglwEmBNr5QoFyiRFtSTYicHbR4zLUG5f5pD87DZAfY3Tapppt6FATNSSAX0jWwzX27Ai4/j5kOLriO66QLIir8yWaGYYMrIXatPLxxs0d51HJKODs4NVFHxx54pMx/IxnF8kUG8tUjmIS1o1k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1771249143; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nL8xfdNlrA3Gerx/WktYHbEfWYLWxl0XnMIz7PlkWFA=; 
	b=ai6Oxp+LlsVa/XIIWduNhSygy5CQytjyAzMgVKkayXZDdPJjdS1Hz1Mc8hVQs5xivLsmNpOf7q6bPM2z4auI57jiyDajQfzQ5TB94s/XQyUDHJLIH8+3LToPPTNzXSJUbsR+9Va7GAtRxkVXj6SxfxZvIqMjt3rIxKLgesRVA/U=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1771249143;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=nL8xfdNlrA3Gerx/WktYHbEfWYLWxl0XnMIz7PlkWFA=;
	b=hr1A/3E8emiZ6o8cayzvA2XYW+S4piBE9hBhQVtcNL+IslnwqzVi//xkxfTiIBNj
	oAdhL2NAUWtOKznj7IY+DEJVTg+c32Irjz7+Bv1zE1JNvFpAoj8ovXBFpZDxLkZk4ug
	Pzw3cbM6ZN9P9mQt6xPyoFHGg4nEOtKvGotz1oMg=
Received: by mx.zohomail.com with SMTPS id 1771249141320423.6808717629111;
	Mon, 16 Feb 2026 05:39:01 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Mon, 16 Feb 2026 14:37:44 +0100
Subject: [PATCH v7 11/23] scsi: ufs: mediatek: Rework probe function
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-mt8196-ufs-v7-11-b5f2907c6da7@collabora.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
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

Remove the ti,syscon-reset cruft, as it was never documented in the
binding, and is not modelling the hardware correctly.

Make PHY mandatory. All the compatibles supported by the binding make it
mandatory.

Entertain this driver's insistence on playing with the PHY's RPM, but at
least fix the part where it doesn't increase the reference count, which
would lead to use-after-free.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 87 +++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 55 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3282b2d2d498..ff03bd153645 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2382,74 +2382,49 @@ MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
  */
 static int ufs_mtk_probe(struct platform_device *pdev)
 {
-	int err;
-	struct device *dev = &pdev->dev, *phy_dev = NULL;
-	struct device_node *reset_node, *phy_node = NULL;
-	struct platform_device *reset_pdev, *phy_pdev = NULL;
-	struct device_link *link;
-	struct ufs_hba *hba;
+	struct platform_device *phy_pdev;
+	struct device *dev = &pdev->dev;
+	struct device_node *phy_node;
 	struct ufs_mtk_host *host;
+	struct device *phy_dev;
+	struct ufs_hba *hba;
+	int err;
 
-	reset_node = of_find_compatible_node(NULL, NULL,
-					     "ti,syscon-reset");
-	if (!reset_node) {
-		dev_notice(dev, "find ti,syscon-reset fail\n");
-		goto skip_reset;
-	}
-	reset_pdev = of_find_device_by_node(reset_node);
-	if (!reset_pdev) {
-		dev_notice(dev, "find reset_pdev fail\n");
-		goto skip_reset;
-	}
-	link = device_link_add(dev, &reset_pdev->dev,
-		DL_FLAG_AUTOPROBE_CONSUMER);
-	put_device(&reset_pdev->dev);
-	if (!link) {
-		dev_notice(dev, "add reset device_link fail\n");
-		goto skip_reset;
-	}
-	/* supplier is not probed */
-	if (link->status == DL_STATE_DORMANT) {
-		err = -EPROBE_DEFER;
-		goto out;
-	}
-
-skip_reset:
 	/* find phy node */
 	phy_node = of_parse_phandle(dev->of_node, "phys", 0);
+	if (!phy_node)
+		return dev_err_probe(dev, -ENOENT, "No PHY node found\n");
 
-	if (phy_node) {
-		phy_pdev = of_find_device_by_node(phy_node);
-		if (!phy_pdev)
-			goto skip_phy;
-		phy_dev = &phy_pdev->dev;
+	phy_pdev = of_find_device_by_node(phy_node);
+	of_node_put(phy_node);
+	if (!phy_pdev)
+		return dev_err_probe(dev, -ENODEV, "No PHY device found\n");
 
-		pm_runtime_set_active(phy_dev);
-		pm_runtime_enable(phy_dev);
-		pm_runtime_get_sync(phy_dev);
+	phy_dev = &phy_pdev->dev;
 
-		put_device(phy_dev);
-		dev_info(dev, "phys node found\n");
-	} else {
-		dev_notice(dev, "phys node not found\n");
+	err = pm_runtime_set_active(phy_dev);
+	if (err) {
+		dev_err_probe(dev, err, "Failed to activate PHY RPM\n");
+		goto err_put_phy;
+	}
+	pm_runtime_enable(phy_dev);
+	err = pm_runtime_get_sync(phy_dev);
+	if (err) {
+		dev_err_probe(dev, err, "Failed to power on PHY\n");
+		goto err_put_phy;
 	}
 
-skip_phy:
 	/* perform generic probe */
 	err = ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
 	if (err) {
-		dev_err(dev, "probe failed %d\n", err);
-		goto out;
+		dev_err_probe(dev, err, "Generic platform probe failed\n");
+		goto err_put_phy;
 	}
 
 	hba = platform_get_drvdata(pdev);
-	if (!hba)
-		goto out;
 
-	if (phy_node && phy_dev) {
-		host = ufshcd_get_variant(hba);
-		host->phy_dev = phy_dev;
-	}
+	host = ufshcd_get_variant(hba);
+	host->phy_dev = phy_dev;
 
 	/*
 	 * Because the default power setting of VSx (the upper layer of
@@ -2458,9 +2433,11 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 	 */
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
-out:
-	of_node_put(phy_node);
-	of_node_put(reset_node);
+	return 0;
+
+err_put_phy:
+	put_device(phy_dev);
+
 	return err;
 }
 

-- 
2.53.0

