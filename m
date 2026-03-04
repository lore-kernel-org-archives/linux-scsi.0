Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E723BE171;
	Wed,  4 Mar 2026 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636109; cv=pass; b=Xw2W7cF0en+8wwLjQGa0aLW9Ktd8tBcftZpHq0NIiSqrTNmIbTjbLeoiYv849b5I8NyHM1jx7RyJozmehopEw552BA4bzkZP6EOnfs0iYqzbpiHEs5WF9qf03MYbyKfd6UOXA/tIbNzL4X00hDWuKOYkMAHfAgKjpkWwlrYFrJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636109; c=relaxed/simple;
	bh=aWgDXGHB1O4exrHFREVeH1cEqeJo6l8p9wWbByLotwc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PKflEvP/Xop4NMXiJZuZ1vFMna0PdBJfEwTTFHvIWOKIgCH95zt38HdowCUSQPaYREE5EQ5M81MI7/55a0RsWjafPqH9GV3kA8vnMrtGjJwrtP7Qq2fBk3W6GXF3wI7mA3fbyFU8OJrSkImAF7vtw6GNfOKnWRiUvA5mrtL4ZOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=hqhq29N+; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="hqhq29N+"
ARC-Seal: i=1; a=rsa-sha256; t=1772636076; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Az+snCfu6clelABHHDk1q1uDlqRIgFrOu2lWCsn3E6nHNjLuC7R8RfSGEdztV+XvQpNcbFfGX7r7I/l+PakEl2v+2dLWxhzEOSMcHwglHrF6b58k1DwKHggWpKsX32b4928ZO3FLh1btXiiyKlu6GqcWJnkBWDTffU+MNSSgCq0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772636076; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ym2etkdO+ts/cZD3ij6LAesEMN8DpO+5cDZxLt6IHU4=; 
	b=mqVvSG7t/tXvSiadhQTN4WwH6Ypl9OfYYlduFrp1SvKDdnJuMYLAsZAzR2TlLyFGQMRwKO39SKmKHmedB1EHcUKG8js+zWLsNi1KzLvUyfkOQifr/rLO2e2X8/kDWa2T7r0ZY1t272hY4gjbg1ctUWa3mwIqR56N0djVpRsvFOw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772636076;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=ym2etkdO+ts/cZD3ij6LAesEMN8DpO+5cDZxLt6IHU4=;
	b=hqhq29N+KVl0x8Oj7F4koWJzUKOtDdbPRR/Lb8Xqlq88kF3Dr+OHXW90whOwO/MI
	vD/CPGiPwhW7151OgmbhLqZKmapxsQVrHK4A+sbgxTNEwOg7mK5cb1sojMLNmCCrM3A
	rSkM/E8NCljF8u8ac6lMSJnmZtqnwN6S8YODpN+Y=
Received: by mx.zohomail.com with SMTPS id 1772636075663472.44993474401576;
	Wed, 4 Mar 2026 06:54:35 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Wed, 04 Mar 2026 15:53:17 +0100
Subject: [PATCH v8 12/23] scsi: ufs: mediatek: Remove vendor kernel quirks
 cruft
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-mt8196-ufs-v8-12-5b0eac23314f@collabora.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
In-Reply-To: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
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
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3

Both ufs_mtk_vreg_fix_vcc and ufs_mtk_vreg_fix_vccqx look like they are
vendor kernel hacks to work around existing downstream device trees.
Mainline does not need or want them, so remove them.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 69 -----------------------------------------
 1 file changed, 69 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 5f08fbbaa447..c2ece9a2e7b4 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1017,73 +1017,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	}
 }
 
-#define MAX_VCC_NAME 30
-static int ufs_mtk_vreg_fix_vcc(struct ufs_hba *hba)
-{
-	struct ufs_vreg_info *info = &hba->vreg_info;
-	struct device_node *np = hba->dev->of_node;
-	struct device *dev = hba->dev;
-	char vcc_name[MAX_VCC_NAME];
-	struct arm_smccc_res res;
-	int err, ver;
-
-	if (info->vcc)
-		return 0;
-
-	if (of_property_read_bool(np, "mediatek,ufs-vcc-by-num")) {
-		ufs_mtk_get_vcc_num(res);
-		if (res.a1 > UFS_VCC_NONE && res.a1 < UFS_VCC_MAX)
-			snprintf(vcc_name, MAX_VCC_NAME, "vcc-opt%lu", res.a1);
-		else
-			return -ENODEV;
-	} else if (of_property_read_bool(np, "mediatek,ufs-vcc-by-ver")) {
-		ver = (hba->dev_info.wspecversion & 0xF00) >> 8;
-		snprintf(vcc_name, MAX_VCC_NAME, "vcc-ufs%u", ver);
-	} else {
-		return 0;
-	}
-
-	err = ufshcd_populate_vreg(dev, vcc_name, &info->vcc, false);
-	if (err)
-		return err;
-
-	err = ufshcd_get_vreg(dev, info->vcc);
-	if (err)
-		return err;
-
-	err = regulator_enable(info->vcc->reg);
-	if (!err) {
-		info->vcc->enabled = true;
-		dev_info(dev, "%s: %s enabled\n", __func__, vcc_name);
-	}
-
-	return err;
-}
-
-static void ufs_mtk_vreg_fix_vccqx(struct ufs_hba *hba)
-{
-	struct ufs_vreg_info *info = &hba->vreg_info;
-	struct ufs_vreg **vreg_on, **vreg_off;
-
-	if (hba->dev_info.wspecversion >= 0x0300) {
-		vreg_on = &info->vccq;
-		vreg_off = &info->vccq2;
-	} else {
-		vreg_on = &info->vccq2;
-		vreg_off = &info->vccq;
-	}
-
-	if (*vreg_on)
-		(*vreg_on)->always_on = true;
-
-	if (*vreg_off) {
-		regulator_disable((*vreg_off)->reg);
-		devm_kfree(hba->dev, (*vreg_off)->name);
-		devm_kfree(hba->dev, *vreg_off);
-		*vreg_off = NULL;
-	}
-}
-
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 {
 	unsigned long flags;
@@ -1981,8 +1914,6 @@ static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 		hba->dev_quirks &= ~UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM;
 	}
 
-	ufs_mtk_vreg_fix_vcc(hba);
-	ufs_mtk_vreg_fix_vccqx(hba);
 	ufs_mtk_fix_ahit(hba);
 	ufs_mtk_fix_clock_scaling(hba);
 }

-- 
2.53.0

