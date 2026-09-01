Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73220483BEA;
	Tue,  1 Sep 2026 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277190; cv=none; b=XSSiJTko1+PejbuhWJBkYoMuIhoQwustvkzMZCr/pGQSMc+JlBRB6fzJD8JqgcOlm6Wb0mt8fETsJCfqhUtQI9qrh5KxehEnEoGdMcXdWINPzK1cCN5OffhO50dJ5XyZJewQ3BdLMFIgafYSVjXBbR6L832vnu3Kk3QcZUJUa+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277190; c=relaxed/simple;
	bh=Keecvxdtpvo5IwVZR81wWNECXjxq/1OmKCf2voct0cs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=M/RCAppb2ihg6zLTg14W9k4d6GhGjHx2QTZcBWnPmscGwpLxlaHRfYtJjX5tTkNCaSnUpm6yhHaCrRhXmdfqxq6IcLbM+G+4QQ+Pf3Q/ps3FKl944QNKr+8DH2Xs3c/DIjTdjCE5O2/B9eqM2T9HtzyJXITnrAcgpNaORkCjYfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=Z1WqpiCC; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Z1WqpiCC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1788277186;
	bh=Keecvxdtpvo5IwVZR81wWNECXjxq/1OmKCf2voct0cs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Z1WqpiCC1BQKQPuXCif1LHfxMVq1qt0lo2EFzYcvCAskaVzBtycaNyV8fwe0yoXYQ
	 dlU4s58KZ+GvKYO7Xy0Ynidzn13NQpvKFjyEeNuOZ+EpJDnUvXMumK6pygAJDwp0Wp
	 m2iVyzyBa9omZnIuMf+FCC2O64G+D6MmQlNfxzwyYNpcnDyiLrhXzijOPdxupCoGgr
	 wSWR+vJirOToLELtft672Q4h22qBSnUP9NcelcTc8OjO1l8tlILgWoK9ofhRxHGskx
	 Q1HZej+p20U+jkvk9D5Dhiv2zHakct+KbLWEEysk37ZHkI77IKmeMudPhQps1FFEDy
	 j/Ov/mBIz9W8g==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D0AD917E0FD2;
	Tue, 01 Sep 2026 17:39:45 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Tue, 01 Sep 2026 17:39:08 +0200
Subject: [PATCH v11 20/24] scsi: ufs: mediatek: Rework hardware version
 reading
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mt8196-ufs-v11-20-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
In-Reply-To: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788277163; l=4038;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=d7nWJkalnqN0Z7rPnYWeVLQCXBQfOXhl+6vGC2hPHFw=;
 b=FhBIpfTchqxgqCiBX1MB2dYHuCJthUs6zlw1solZdCTpBmRweLBWwN/MDjA8VgO3Opvsg1kKs
 v2Uc/YNCLIEAK2gyps1sFYeq0ZyH6s7sUV8NmylH31/A858C9iLSuZJ
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Split assignment to the host struct out from the read function, and
utilise bitfield helpers to simplify the code. Also move the debug print
out of the legacy version helper, which means it no longer has to take a
struct ufs_hba as an input, and can be rewritten as a pure function.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 65 +++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 4e916d5ac2af..f405f511f41f 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -826,50 +826,47 @@ static void ufs_mtk_mcq_set_irq_affinity(struct ufs_hba *hba, unsigned int cpu)
 	dev_dbg(hba->dev, "set irq %d affinity to CPU %d\n", irq, _cpu);
 }
 
-static bool ufs_mtk_is_legacy_chipset(struct ufs_hba *hba, u32 hw_ip_ver)
+static bool __pure ufs_mtk_is_legacy_chipset(u32 hw_ip_ver)
 {
-	bool is_legacy = false;
-
 	switch (hw_ip_ver) {
 	case IP_LEGACY_VER_MT6893:
 	case IP_LEGACY_VER_MT6781:
 		/* can add other legacy chipset ID here accordingly */
-		is_legacy = true;
-		break;
-	default:
-		break;
+		return true;
 	}
-	dev_dbg(hba->dev, "IP version 0x%x, legacy = %s", hw_ip_ver,
-		str_true_false(is_legacy));
 
-	return is_legacy;
+	return false;
 }
 
-/*
- * HW version format has been changed from 01MMmmmm to 1MMMmmmm, since
- * project MT6878. In order to perform correct version comparison,
- * version number is changed by SW for the following projects.
- * IP_VER_MT6983	0x00360000 to 0x10360000
- * IP_VER_MT6897	0x01440000 to 0x10440000
- * IP_VER_MT6989	0x01450000 to 0x10450000
- * IP_VER_MT6991	0x01460000 to 0x10460000
+#define MTK_UFS_VER_PREFIX_M GENMASK(31, 24)
+
+/**
+ * ufs_mtk_get_hw_ip_version - read and return adjusted hardware version
+ * @hba: pointer to this device's &struct ufs_hba
+ *
+ * Reads, transforms and returns the hardware version.
+ *
+ * Since MT6878, the versioning scheme was changed from 01MMmmmm to 1MMMmmmm.
+ * In order to support version comparisons across these different versioning
+ * schemes, this function transforms the older style to the newer one.
+ *
+ * For example:
+ *  MT6983 is transformed from 0x00360000 to 0x10360000
+ *  MT6897 is transformed from 0x01440000 to 0x10440000
+ *  MT6989 is transformed from 0x01450000 to 0x10450000
+ *  MT6991 is transformed from 0x01460000 to 0x10460000
+ *
+ * Returns a u32 representing the hardware version.
  */
-static void ufs_mtk_get_hw_ip_version(struct ufs_hba *hba)
+static u32 ufs_mtk_get_hw_ip_version(struct ufs_hba *hba)
 {
-	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-	u32 hw_ip_ver;
+	u32 version = ufshcd_readl(hba, REG_UFS_MTK_IP_VER);
+	u32 prefix = FIELD_GET(MTK_UFS_VER_PREFIX_M, version);
 
-	hw_ip_ver = ufshcd_readl(hba, REG_UFS_MTK_IP_VER);
+	if (prefix <= 1)
+		FIELD_MODIFY(MTK_UFS_VER_PREFIX_M, &version, 0x10);
 
-	if (((hw_ip_ver & (0xFF << 24)) == (0x1 << 24)) ||
-	    ((hw_ip_ver & (0xFF << 24)) == 0)) {
-		hw_ip_ver &= ~(0xFF << 24);
-		hw_ip_ver |= (0x1 << 28);
-	}
-
-	host->ip_ver = hw_ip_ver;
-
-	host->legacy_ip_ver = ufs_mtk_is_legacy_chipset(hba, hw_ip_ver);
+	return version;
 }
 
 static void ufs_mtk_get_controller_version(struct ufs_hba *hba)
@@ -1232,7 +1229,11 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_setup_clocks(hba, true, POST_CHANGE);
 
-	ufs_mtk_get_hw_ip_version(hba);
+	host->ip_ver = ufs_mtk_get_hw_ip_version(hba);
+	host->legacy_ip_ver = ufs_mtk_is_legacy_chipset(host->ip_ver);
+
+	dev_dbg(hba->dev, "IP version 0x%x, legacy = %s", host->ip_ver,
+		str_true_false(host->legacy_ip_ver));
 
 	return 0;
 

-- 
2.55.0

