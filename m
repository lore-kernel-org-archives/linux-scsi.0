Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40912338F20;
	Thu, 18 Dec 2025 12:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766062641; cv=pass; b=GAdjlmVYZ/89PYYa4u6FIQ4j21Z74ELRwR4rpc3kXeddKP3n1m1Lguvu/nUSdhE3H6lgUhwAFMGhuO5tLWz4d9njo7Tl8y1B5TBQ6OW0itJraaHEinvjOEH+9maaStEk7PcXIXoiVwKq8nbtrfplkCa3PdlW4usSsGj/GBqznu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766062641; c=relaxed/simple;
	bh=bSyZbgOa9ARRtRxF+v0iFNGOZGdal56NPbdqxQzQCvk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E6dMdZOz5q7Sg6rXMzL4CN/xS/K7EDAeE/obteXXuzFDHYHSK8aa/2hyE1KkVFNke0EQY2xtTxil2eF+qk5g9bBiaHg+sapwI7dhW4JRXBv8WU44hldVhUCx9c3iHR444nCZdxP7WtG34NvNa1Qj30474KK/97ciBzAFOKP8iks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=et3HgHL3; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="et3HgHL3"
ARC-Seal: i=1; a=rsa-sha256; t=1766062608; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=XCTIj5jr/MbEG7Nxrk2UEXMjAt1VO2AQtnfvLPHQdHcEEWzlqs2FpuA9PGWkbKqjLdxMqV3z25VZlIUBzQZ0Sg1gd7gR6mYsdHyRXGnbHGP4VWrq6NPSNCLmv3OVmTHLeY4mNGAZyG3jqoZZmt6Jo3vASQNWeF7Xsey3C8BvqDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766062608; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=jJiFeoZ/M5Al7+1C6wVPCkiJYqI4sv3GjNFC8VaIeWs=; 
	b=CBwFv4tlCkVPn9bQ2DyEOdtiFC8YAowE0ckX8wg7wq+l8RB+E0U2jete70c1ucxanh0YjvNn3Nk8ZvuQp8/jXCkohf/G0uSKVdkHIw4MP4LHN4Ym056g7Kx7DokLb9890t1Vb5Rd1T/1QrsTpglC3imbHw7pJRzJCtpa1CUlr/k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766062608;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=jJiFeoZ/M5Al7+1C6wVPCkiJYqI4sv3GjNFC8VaIeWs=;
	b=et3HgHL3NIg5fcxAeQCq/Zwb8Y0klAB1VbDOy/AHmJKPTzpU/0lEQ/yfdpWx0ASJ
	dmNO6WT8m7Hh45wu6U34XNmhJNBO23vhSEbQ3upnfw1x/GsLyAvuKk2bMJshUYHE4tJ
	QDwaS3fS58Fk1rDlGnZZINr8y21WEybNZpSo6VZc=
Received: by mx.zohomail.com with SMTPS id 1766062607674226.3438815292385;
	Thu, 18 Dec 2025 04:56:47 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 18 Dec 2025 13:55:02 +0100
Subject: [PATCH v4 12/25] scsi: ufs: mediatek: Remove vendor kernel quirks
 cruft
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251218-mt8196-ufs-v4-12-ddec7a369dd2@collabora.com>
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

Both ufs_mtk_vreg_fix_vcc and ufs_mtk_vreg_fix_vccqx look like they are
vendor kernel hacks to work around existing downstream device trees.
Mainline does not need or want them, so remove them.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 69 -----------------------------------------
 1 file changed, 69 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index cc6a3a4c9704..6385ebcc9142 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1019,73 +1019,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
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
@@ -2005,8 +1938,6 @@ static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 		hba->dev_quirks &= ~UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM;
 	}
 
-	ufs_mtk_vreg_fix_vcc(hba);
-	ufs_mtk_vreg_fix_vccqx(hba);
 	ufs_mtk_fix_ahit(hba);
 	ufs_mtk_fix_clock_scaling(hba);
 }

-- 
2.52.0

