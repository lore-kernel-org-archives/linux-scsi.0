Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D9534D904;
	Fri,  6 Mar 2026 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772803651; cv=pass; b=f0JvkJTj9LHiZ50PQXaaLrDXAZEBncXrOG7oGT+k5X1qFimqYUOohwWQJTnaHSCTCWcAWHZlDlycW9+KPMEtEtr2hUAbAw3QNUeBVEfY2DjESkC0RyydbnMrSrqQck67tGS/9y6zrV2SqDcEVHqs1Am1C+qxyeVPW/1j9O56BDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772803651; c=relaxed/simple;
	bh=i31CRJMU4nhHsxL0WDdGh0s0nJ400npamI1KkgbsLcg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F54KafX6J7HqwDSJM0do8nRBiPyJKCSG8pAs7N1qdKEV5cR1gq7eYqitLZKK1TxxgGzeI+CY7LoyZIQ3VpkNh1Rcg+56ZSv63CEhAq5f6WjdaPM0DE9A4M2bWW56Q7JBoTFR2J+GNglAGaporQXib3rouF73Vup3+Hm0F7iHnrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=OC1v41G+; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="OC1v41G+"
ARC-Seal: i=1; a=rsa-sha256; t=1772803599; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JydZtb6FD2Ac7RoUwr6cYvOUJTtYWi3CQSpSp5zD/uN5RMefcCJIeDrkhvBgKXTzFNAK0r8vCPLUWOWLkrV9uXbD1QBQgbslaR1iO8mkUCDj+g+i/Q9pBkoeDdDw/qu8R8q6o+Rw08p4KcroK5AadprfUey2Wn/wtA880NG9ApU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772803599; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=/sEbnTP6mjprc+lvmLAb38b+csIauS2bw1X07zMWkGg=; 
	b=LFomU/+XetnrHLJmDfeisIDQtCyYcsE1K1Eji17x48Vh0qzWcVrb5Cttr6VOwCM1lkdEou6jRWTRm52HHjzxD7QIUir3N+JYeox3bhenVW3D3a4l5J40jQeAT4Gf9YZHAlQEXKSzwq082UpdW4RV2e8lJVaJdVdpO+DZ0jLuUJo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772803599;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=/sEbnTP6mjprc+lvmLAb38b+csIauS2bw1X07zMWkGg=;
	b=OC1v41G+BtRYEBVFUxshQNKqa/J0u77vYoCx8p2yK7ImZuN6uWkR2pfgVj2tuZtH
	vW68IcnWDG/fjFpNgsVOlehG2CnMDNOW7TJCmert9Wm7MjFpq37PMEOayFcDcsLHIkI
	YseJCABpiM/fZyDiJP+MBGsJOJkr4iLk0NmYzzTQ=
Received: by mx.zohomail.com with SMTPS id 1772803597852879.7693043464217;
	Fri, 6 Mar 2026 05:26:37 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Fri, 06 Mar 2026 14:24:56 +0100
Subject: [PATCH v9 15/23] scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale
 error paths
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-mt8196-ufs-v9-15-55b073f7a830@collabora.com>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
In-Reply-To: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
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

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 909e4ea2d92c..c236a833fe9a 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1961,16 +1961,16 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 
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
@@ -1979,51 +1979,48 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
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
2.53.0

