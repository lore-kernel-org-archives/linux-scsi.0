Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795255;
	b=L7/34+YrdXwPV44XS/TW/yNw6k0shDeHRSbTBCwVOsO64h3mJ00adt3UbbYFmAay3USU
	 9AHwWPEUEMr6CFgMC+B1QDojiA341wFbS1C6qg9SWYDOkX1Y5eDzXuQl5wgPWz6u3jmjh
	 XPoIgnIS3SD8egezzzkI5UK27a+EBpSwRRcndcFrW93O7JJ+yIbMxVi8Ffb4PseoSGtF2
	 NYZY7TDIexNCWBUAAosuwsk3AawQDtOb8PkYDrN53xrDxZZJEkw8fN2hGmgcO6HIhxYbC
	 1gtm9Eb1OG+PLtV3sbf0vokOyh3w5+z5H/Bc5Th8kbV3Vfgub/RkJMTnL3rsJfkd9hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795255;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=HF4xqDo1W4H6falpMQXwO3+VNuOUqU4yy4/95m2JV7g=;
	b=KTz6aYfe14vNrF/Qv7IAfliNTtrdiXTa7k1lRmOsUMYj0YcdrtBsg2Oq9Jy32KnIkFAG
	 kxSWIFdoMNRboWBA2WO6qa3ik/eGNefdbue/OfGfKCQioOUNKwHyLsY17UQbFbkS71UJR
	 IQMldQgLITD3bI1A8IUbG5g6tlEDnB5zjFCua+3rwQwsh53cS1lV0+efS2xHlVo4XZ6CS
	 UzfMTPVGuBy7+Uyz4lH6MGaIG0lgpRswe2oUwdQVQv1Rp7678GrV/dPkktdguDWoCaMLV
	 WvrXqXL52pxkt40/yRF6nij7ZsgUwzGXQW7XHpDojPfPFciICNhB59tEPim6eh0npDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=AKErkKsO;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07964606C20E;
	Fri, 27 Nov 2026 16:00:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07964606C20E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=AKErkKsO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795795253;
	bh=/YjkNzuqpdkKxHczKvrXOxoVS1LI7KBGE4YOA6Q2OTA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AKErkKsOiPuXhBMd+gCrXN2ega2seLR9hs4yJSIJUmQ0pUE3GI03jClacp7VeJKhL
	 0IIqN+wDhcOJb6OibF5zvoVdn1NhcprQryTt+zgLC/EwNoiiyErPqU1fswPbA+cNhA
	 pJYrNSxTIUcOJ7ap3LNoo/zaHVk8b2htLYAsDaOXLsVcpygDNBbfbqWVLiH48bAQyf
	 c/8oB7z7k7f9Ficdnvm/UK2jdwE8KIBaU3PmlE7/KuTTeBwI3cFaT20Sg78khj+mK4
	 SKWnDYaBgzuuQ0SDWRpe8k695qbpT0h6imNAi4b3ogvB45nEhxzGkR3tEX0GJhDqfH
	 LEc8xEnikw4sA==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5E75F17E0E34;
	Fri, 27 Nov 2026 17:00:52 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 27 Nov 2026 17:00:25 +0100
Subject: [PATCH v16 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-mt8196-ufs-v16-22-6f2568f7c119@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795795222; l=4256;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=khDSMP1i01JIfLxLPHkhdhAhgpruGNZ72lgHbajpnfs=;
 b=6GYe+Pt0NbqTdAxpUCIGZLO2N55iHN/nS4EwDL1J9QekRo3KPX35RNdTnI52NLtA/ILaIkYZh
 KumWeVRdJxYCuaQzFPTZS/zM1stvtKs1uEyYj9WSvOrb2A3D4VYaD1X
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
index a94601d24a87..a16c67559712 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -938,8 +938,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki, *clki_tmp;
-	struct device *dev = hba->dev;
-	u32 volt;
 
 	/*
 	 * Find private clocks and store them in struct ufs_mtk_clk.
@@ -976,24 +974,7 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
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
@@ -2005,8 +1986,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
 	struct ufs_clk_info *fde_clki = mclk->ufs_fde_clki;
-	int volt, ret = 0;
-	bool clk_bind_vcore = false;
+	int ret = 0;
 	bool clk_fde_scale = false;
 
 	if (!hba->clk_scaling.is_initialized)
@@ -2015,10 +1995,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (!clki || !fde_clki)
 		return;
 
-	volt = host->mclk.vcore_volt;
-	if (host->reg_vcore && volt)
-		clk_bind_vcore = true;
-
 	if (mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
 		clk_fde_scale = true;
 
@@ -2039,14 +2015,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
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
@@ -2078,14 +2046,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
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
2.56.1

