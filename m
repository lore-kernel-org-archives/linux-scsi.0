Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E615433ADBA;
	Thu, 18 Dec 2025 12:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766062665; cv=pass; b=Kdhdwkl1w3D3YSeM9gpb8Nm6BFL427UPMR62T35oZbmFtvet1yCWs7UzACYBZsSCnblfu7KEiGDpfH1jF4LIpru6pzYiq9gkwZpyqLftKB3ze7UgfAAvhBcRQPQoB3xqBU9Cig8UHDuB0/4ut1oxQmyOwAQ3P7HXSHH5gmaXlOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766062665; c=relaxed/simple;
	bh=qaqVG02hF7pO+vAcnNocH2AgR6JA4p98bUwxkpxW2J4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JFv+MKTilm/kBFDIbfr9hnYVDqd39xvr+Y58iZqYV+jGXnA+es5d3pn3jmnELIIq1+Wc4775WpjF+lDaBdXBtSgCRrFzvqNIBq7gcE1qwR5EGJs47wByZCVUulfl2Ndf9thLyfnalHeJqaYQuhtj6awxqqhcWsP4hx9FjYlO1Ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=k+36rhv7; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="k+36rhv7"
ARC-Seal: i=1; a=rsa-sha256; t=1766062634; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PMlFqcrnEWOkJJJ7ftnDdnFhzrK0krdRO9v+TapBXA7Y0RrkKxv5Tq0j0iR+begGHNCwL4P6WN+KrterbpirEjWf0KzRaBTsJsHq/Rawrdnpvxxfb366/wWP+2D5RgrAsV4aRRGFE5GiOlBd0wAX0KJBWKRpeBYkYzF8NMXS9Jo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766062634; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=TTl4r4f6Il+Hnj8EJO5lgTBBkjOsH1KrF0jWRvAtRn0=; 
	b=E4+yh0JfW9JvPA0zTtGPWnTs0UtP5xnVY9xD/+1RzdOwKgny482n0VEnJ9zXuZDsZ0nhDT1VQPTgllNQs+nAP2Gm6oMHQpmh7b8Kj75BIHekNeF8AAFC1Y3CcmVuo+o3FqmG/q4posR/w0CbQKwFheQd1471/9FyGGX3lCwfME0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766062634;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=TTl4r4f6Il+Hnj8EJO5lgTBBkjOsH1KrF0jWRvAtRn0=;
	b=k+36rhv7SZ52ojxw1sdywYKG3Tav4dBj7dPGwa+03wnfE1ExKHr58xjupG00EJZe
	lDnqu6Nwqe8wIzuEyF1F8ks/yiLbdnmiIDFCCkqCcCG7zlqh2C8ED51sTL7rNt7vJQ+
	insrddx4neT7KpKWxRMYvumJIfMteVa1mpMk3v/o=
Received: by mx.zohomail.com with SMTPS id 1766062633346532.3493326825272;
	Thu, 18 Dec 2025 04:57:13 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 18 Dec 2025 13:55:06 +0100
Subject: [PATCH v4 16/25] scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale
 error paths
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251218-mt8196-ufs-v4-16-ddec7a369dd2@collabora.com>
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
index ffd52b8c295a..d72b6ab05a23 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1985,16 +1985,16 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 
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
@@ -2003,51 +2003,48 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
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
2.52.0

