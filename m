Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100793;
	b=2TiagM569qsdI5b6rNIDiQ9v1wVK3dMYb4D6UK4QtaTvKT1mnbu6XKG48R5NJE0Wm/x9
	 CLPgvVqx8cOm0rXZGnykdrCAKTK93kwUZTygv6R8kQ7/IoCX7CvOq7hSzVRcFS1h+j6UI
	 tL4ebA+Wqqu96JtqGW6RygTkg7GOjB2tdfoqHBcH3zzwVZYj57V5OTMmDMmHXbn5Bu6bu
	 YT0RMKcwPK+W736YwYgmKJH1fSGvc3o/NXy61xmFODes8zKYBuub1ixiehWXE0/+ArEx/
	 9E0jDh0MfUzo0xkj5taTKCBiAb284nBWwdE8+rZA2PtPNdOD5S7QQWnZCMS6G78nTZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100793;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=GXUUyL0vpqc8ZYwbhsQAkyhweJ5csk33vAatXuTsix4=;
	b=qhhkLJNawLRapBWo91xQWpBeu0hyNr/LuhELktPo/g5SMnIoaYTUWogGyc4eR6o9/Hb9
	 c61mzfv388wcs3eKpwlQr8kY0SIKWlsHeRBetnj3Sr1fElKRxHI6uyBs4ng30j32EqRUk
	 +48Wjs5CHkKOt/WNFdOhiIb05SOWCfSb2wS5wWachB5azs03JftOtyP4PsjvUDw/xexB2
	 b0ylb5a+Lh6LzEOhpy3n/bgVJYuHJs1nvmovofDvfvCP+gB7zmseoxaJaqu3itbxbLvfA
	 +PWK5OAz5s3k7pPbrSAgyP/JstgXUAjzShCTyLkxoqpGk4ZMy+4LFbuRob+W4Gnb32g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=fw2XXHiS;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA90260A2621;
	Thu, 19 Nov 2026 15:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA90260A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=fw2XXHiS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795100791;
	bh=1jtFAeZKd0WQq7ddrXOCopmfdnCCVSjyYnrjiS6Lgx0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fw2XXHiSzCbuFzgaUpArxqxttrrNjP4e9siHKz28oKEnE6HQhNMa/GgDaxFQ5ALhO
	 0Gb/QPrQVU74pUja7q9XIx2evbKEn1/wPvf3X5YYBN1n7trwTP8WSgTmz+KDGed0rM
	 6zQ1p0/d0fhU/ITeYdR+LAuhzQkp5Kl7fL6L+tF/waG9usSPF7+xIzMtYXmTt0MeQp
	 mUdr+NNeQyZX235snHrMzCyPIMyE5MFWQaTvvOy8Mufpo6IrSn2VPsclNV/s+ewVJ3
	 zPbZdRnQbTDxmqus6UWmIRZMPoBL1l1i5jX5ZGDWU9CJ9NVo/43Ph1DvFewPY03Oxr
	 gAQUW5512FV0g==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5C90E17E0BCD;
	Thu, 19 Nov 2026 16:06:30 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 19 Nov 2026 16:06:01 +0100
Subject: [PATCH v15 13/23] scsi: ufs: mediatek: Remove vendor kernel quirks
 cruft
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
Message-Id: <20261119-mt8196-ufs-v15-13-aae1eb0382e8@collabora.com>
References: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
In-Reply-To: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
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
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795100772; l=3056;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=3yGcZdsWwhdkRi9PU591oxcE0sawA8UxY8uNe/rKOBQ=;
 b=KmDNEDtXi2pzh7kLMdIfygX/67eOxreQSrAC0qnzsLTsOUwVOiFpIZz3L8sIeTX8K+mZJDDhN
 v+XapV3+8hJCmwhPyV+NlaUeS65bRafPP66oU8ucyCz8CUmNId0muI6
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Both ufs_mtk_vreg_fix_vcc and ufs_mtk_vreg_fix_vccqx look like they are
vendor kernel hacks to work around existing downstream device trees.
Mainline does not need or want them, so remove them.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 69 -----------------------------------------
 1 file changed, 69 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 907b5fe6eb22..fec0fb24e7a2 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1068,73 +1068,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
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
@@ -2065,8 +1998,6 @@ static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 	     host->ip_ver == IP_VER_MT6995_B0))
 		hba->quirks |= UFSHCD_QUIRK_VCC_ON_DELAY;
 
-	ufs_mtk_vreg_fix_vcc(hba);
-	ufs_mtk_vreg_fix_vccqx(hba);
 	ufs_mtk_fix_ahit(hba);
 	ufs_mtk_fix_clock_scaling(hba);
 }

-- 
2.56.1

