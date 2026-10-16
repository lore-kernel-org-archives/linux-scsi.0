Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCE24A013F;
	Fri, 16 Oct 2026 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154038; cv=none; b=KXzmGdb3gUjELSJazGfknAveS6dIgNHHlv9552xzUnQYvG4JH7S0dU4pwW47OfhrBb8X4HoZnvLO+c8EuHkAMz8NM82ZGPCifXrxkym1jihnS1XdCIAKiG/LqdasLO3MxUrCVXP4gicgMJtaPefsblsDrXon67yhbQ+ro6y5+Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154038; c=relaxed/simple;
	bh=gXEnr3OZegUE9ir+BeLU4PyMoWEG93XjQH8XIsmESYI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hYFYbOlbXTiWmMyrQ9tUMlcqQ9LIL9V3kJbPzFtpmmh7Naq2Ma+1t2JIlEIuh5xjFNecjj96vG1FqfpUcw5XAKcrdIkmDD5CkqzmD/pZakrvOWKkLEeHj5ZNlRxYk26zye0//YHD1b09MPa4KLirmWqD91YeNC4LfPOvgsRYBgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=QlhGgiGX; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="QlhGgiGX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792154035;
	bh=gXEnr3OZegUE9ir+BeLU4PyMoWEG93XjQH8XIsmESYI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QlhGgiGXgAqX7+92m5Avgv0+eDgicSb6CAoDRW588EkEnjP44v99JDcWrLzNtRRO4
	 Z7qr3g6tAHspSNP8yYvUN+0y+iB34vZYtrIVwiNmRr/4J7OLGxrNwi53a5cbLP1g4g
	 CVsXpa2Q9QS4S+LWfAxQonAGHe6LYuE6C6h5Ko+5rUBCX+Pu1J5Bv+8wh095UhZhFN
	 Ez9ppv6GE5gb0k+DEStEF4IwzVbI5iQeoDD46LvkLw7hEOXB+2CIUFLXubCQT4r4yr
	 QYcaqG2HLv9pa3Es6KpB7wB33Cnm5///UptMWIAWVy6kl4gJYbjkwtspzd0trq3lad
	 dDKkyFJkJnZvA==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0AEFA17E142F;
	Fri, 16 Oct 2026 14:33:54 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 16 Oct 2026 14:33:14 +0200
Subject: [PATCH v14 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mt8196-ufs-v14-22-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
In-Reply-To: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
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
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792154009; l=4256;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=oY1TPDYrB7rLzT8HMTxh2GSeYogHMabb0w2w4OOuY1U=;
 b=tzwlovnArZs5/wPckYJ1D8VXWrmiIFWgqU+qMo2Ts/Qt22L6jX2cV9IIxLKlLe78mKDuJY7J/
 nJiBzy5Kia5BZpMadZ2Gg6Thrm/IWrRxiKhpq7E9ENswqcZ1SU5VkoU
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

The MediaTek UFS driver contains support for an undocumented,
non-vendor-prefixed u32 property named "clk-scale-up-vcore-min".

Since it is not part of any binding, and would not pass a bindings
review in its current form, remove it.

To return this functionality, it needs to be resubmitted in a series
that also introduces it to the binding, and justifies what it is used
for. Compatibility with downstream device trees is not a valid
justification for its existence.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 42 +----------------------------------------
 drivers/ufs/host/ufs-mediatek.h |  1 -
 2 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 760c1ebd53bc..0ffd377ca395 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -930,8 +930,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki, *clki_tmp;
-	struct device *dev = hba->dev;
-	u32 volt;
 
 	/*
 	 * Find private clocks and store them in struct ufs_mtk_clk.
@@ -968,24 +966,7 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	if (!ufs_mtk_is_clk_scale_ready(hba)) {
 		hba->caps &= ~UFSHCD_CAP_CLK_SCALING;
 		dev_info(hba->dev, "%s: Clock scaling unavailable", __func__);
-		return;
-	}
-
-	if (!host->reg_vcore)
-		return;
-
-	if (of_property_read_u32(dev->of_node, "clk-scale-up-vcore-min",
-				 &volt)) {
-		dev_info(dev, "failed to get clk-scale-up-vcore-min");
-		return;
 	}
-
-	host->mclk.vcore_volt = volt;
-
-	/* If default boot is max gear, request vcore */
-	if (volt && host->clk_scale_up)
-		if (regulator_set_voltage(host->reg_vcore, volt, INT_MAX))
-			dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 }
 
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
@@ -1992,8 +1973,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
 	struct ufs_clk_info *fde_clki = mclk->ufs_fde_clki;
-	int volt, ret = 0;
-	bool clk_bind_vcore = false;
+	int ret = 0;
 	bool clk_fde_scale = false;
 
 	if (!hba->clk_scaling.is_initialized)
@@ -2002,10 +1982,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (!clki || !fde_clki)
 		return;
 
-	volt = host->mclk.vcore_volt;
-	if (host->reg_vcore && volt)
-		clk_bind_vcore = true;
-
 	if (mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
 		clk_fde_scale = true;
 
@@ -2026,14 +2002,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	}
 
 	if (scale_up) {
-		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
-			if (ret) {
-				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
-				goto out;
-			}
-		}
-
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_max_clki->clk);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to set clock mux: %pe\n",
@@ -2065,14 +2033,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 				__func__, ERR_PTR(ret));
 			goto out;
 		}
-
-		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
-			if (ret) {
-				dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
-					__func__, ERR_PTR(ret));
-			}
-		}
 	}
 
 out:
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 6b81c8f76201..5415b6419379 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -154,7 +154,6 @@ struct ufs_mtk_clk {
 	struct ufs_clk_info *ufs_fde_clki; /* Mux */
 	struct ufs_clk_info *ufs_fde_max_clki; /* Max src */
 	struct ufs_clk_info *ufs_fde_min_clki; /* Min src */
-	int vcore_volt;
 };
 
 struct ufs_mtk_hw_ver {

-- 
2.56.0

