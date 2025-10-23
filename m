Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210D035581B;
	Thu, 23 Oct 2025 19:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249323; cv=pass; b=NlC9BoWm+USKNUsWM8vXP7wBjKLrTJzVAT8dx0nOhT7Kl9jH4xcoQSemGwBilN7C4gqMy1tUY48Oi6fXY9ldeCoYnXQ6yHlxHU2/k8Q2Vq4M8vrqGSMu6GjcTXFdFhxOtEBeQV7XeIooY/I00DZ8yDu3SN9avjUOQgUWgMMAh0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249323; c=relaxed/simple;
	bh=rj/4m5FhRA1T9Eph1W2qdgaRwmrU+RpZvDZfU/wS+sI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Wc2DT+JzRgC6YVSHGynWjHTirifYN6tDNrbISLPFiypELbErOGBVDIxjs90sTbg2B7V5KB/Vl4qH+jUUkygidh518sPjBkCYeXdumT0JfwQfcDR6lr++zLo5EcWXvdMUs0qHp6AxWN+HVQ9ySk0C3Ot2Od4HOhPkr5pBUpFK09Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=AUU/Z/tf; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="AUU/Z/tf"
ARC-Seal: i=1; a=rsa-sha256; t=1761249108; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=UjYck4NtCRh07bo3PLr54WhHz9HjjPWD9/RO5RcsuofaTM3XS2OnqkfKfER7HmJ0x2mOnJ0kymJwOF/7HDuNWVkGQIPoaxYzCZSDzbMT7OlsqlqjgoZ8jc/M3DAWHtfZMId0tuwbfbSMV2sLjZ0X9pTZ5yViwKBc0y+154Qr5sA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249108; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2aDKj6WNDWNLHF3f3XJYCSyGQVnYFF06NugjrW7Y14w=; 
	b=SrZPIDKNJpJAw6FYX6n1AavMV8N6sO+ErxWW9OOEyX0FjNaI5nQATkDTPY5zBhW3NSWJ9Ce3DoMl8dACAUi/7dgeIZqSRY5fGjWGXElKsfvUjlCuz5X2UTPGes8/4/yfu2t18X4uy22aRF2SzOCOY4l4qMSfEP8zF2eScdl/KR4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249108;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=2aDKj6WNDWNLHF3f3XJYCSyGQVnYFF06NugjrW7Y14w=;
	b=AUU/Z/tf+JwCpPfvqGN7ErU9Hcl/M9Iy6LHsBA6OXHA1Bt2NORmkShfXvxilfSE7
	CHZq2eAu/fBeM8UCN9YNBFiYrfdP9/h2wdJfRqRMjxWTpyuEWLpbo6jk5+uJbw1rM9E
	RrYp0lTiqLYkH6DCy6vt+lL+0jE2fGCHJNYo0XAs=
Received: by mx.zohomail.com with SMTPS id 1761249106241227.6363113071401;
	Thu, 23 Oct 2025 12:51:46 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:33 +0200
Subject: [PATCH v3 15/24] scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale
 error paths
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-15-0f04b4a795ff@collabora.com>
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

Errors should be printed at the correct log level. Additionally, it
looks like some "goto out"'s were omitted in the scale up case, which
looks like a mistake, as the scale down branch of the code does use
them.

Rework the error messages to make them nicer and at the correct
verbosity, and add the missing gotos.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 44676ba4c392..7a890302c240 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1948,16 +1948,16 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 
 	ret = clk_prepare_enable(clki->clk);
 	if (ret) {
-		dev_info(hba->dev,
-			 "clk_prepare_enable() fail, ret: %d\n", ret);
+		dev_err(hba->dev, "%s: Failed to enable clock: %pe\n", __func__, ERR_PTR(ret));
 		return;
 	}
 
 	if (clk_fde_scale) {
 		ret = clk_prepare_enable(fde_clki->clk);
 		if (ret) {
-			dev_info(hba->dev,
-				 "fde clk_prepare_enable() fail, ret: %d\n", ret);
+			dev_err(hba->dev, "%s: Failed to enable FDE clock: %pe\n",
+				__func__, ERR_PTR(ret));
+			clk_disable_unprepare(clki->clk);
 			return;
 		}
 	}
@@ -1966,51 +1966,48 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 		if (clk_bind_vcore) {
 			ret = regulator_set_voltage(reg, volt, INT_MAX);
 			if (ret) {
-				dev_info(hba->dev,
-					"Failed to set vcore to %d\n", volt);
+				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 				goto out;
 			}
 		}
 
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_max_clki->clk);
 		if (ret) {
-			dev_info(hba->dev, "Failed to set clk mux, ret = %d\n",
-				ret);
+			dev_err(hba->dev, "%s: Failed to set clock mux: %pe\n",
+				__func__, ERR_PTR(ret));
+			goto out;
 		}
 
 		if (clk_fde_scale) {
-			ret = clk_set_parent(fde_clki->clk,
-				mclk->ufs_fde_max_clki->clk);
+			ret = clk_set_parent(fde_clki->clk, mclk->ufs_fde_max_clki->clk);
 			if (ret) {
-				dev_info(hba->dev,
-					"Failed to set fde clk mux, ret = %d\n",
-					ret);
+				dev_err(hba->dev, "%s: Failed to set fde clock mux: %pe\n",
+					__func__, ERR_PTR(ret));
+				goto out;
 			}
 		}
 	} else {
 		if (clk_fde_scale) {
-			ret = clk_set_parent(fde_clki->clk,
-				mclk->ufs_fde_min_clki->clk);
+			ret = clk_set_parent(fde_clki->clk, mclk->ufs_fde_min_clki->clk);
 			if (ret) {
-				dev_info(hba->dev,
-					"Failed to set fde clk mux, ret = %d\n",
-					ret);
+				dev_err(hba->dev, "%s: Failed to set fde clock mux: %pe\n",
+					__func__, ERR_PTR(ret));
 				goto out;
 			}
 		}
 
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_min_clki->clk);
 		if (ret) {
-			dev_info(hba->dev, "Failed to set clk mux, ret = %d\n",
-				ret);
+			dev_err(hba->dev, "%s: Failed to set clock mux: %pe\n",
+				__func__, ERR_PTR(ret));
 			goto out;
 		}
 
 		if (clk_bind_vcore) {
 			ret = regulator_set_voltage(reg, 0, INT_MAX);
 			if (ret) {
-				dev_info(hba->dev,
-					"failed to set vcore to MIN\n");
+				dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
+					__func__, ERR_PTR(ret));
 			}
 		}
 	}

-- 
2.51.1.dirty

