Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB5448AA93;
	Thu,  8 Jan 2026 10:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767869565; cv=pass; b=SA7TQNC3f4A4acm5/s2XDPyfT2GQb+uiGP2vk8yHa5sKbn9ZXwuqco01qCQNHObo5kmunUry1ESKoS1WFnQ48H95ZMakGbqbjrhE38sIkCSE5PPdCGCtuG72tEl48tUIiePVUGj6gFkau0p/Kn07S4xxuHe9ePtH5y3P57zlbG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767869565; c=relaxed/simple;
	bh=eztl3kg3Ogp8dBKoRRM5zaJ704CGMF31ieQhlOhdmpI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WDfQFlL/Rhq7ioOW2y1I+4IGwUERn/vtxsriH0aVaTju6d9b8xwefhHp04at9WQyi/t7ZMyvetYD1LeHeLW9PpuyQqlHApAoaaLjnRnsfRrE0qUKDS1+onpWx7ES0hIps6U3kvXYobWEea9p0leFWJtS1rYh+faz05QLpAilpVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=AIOj9TMc; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="AIOj9TMc"
ARC-Seal: i=1; a=rsa-sha256; t=1767869525; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=V85e3k7s50vtPAK02iqpdOBRa2VXuLeIv0T9+4Pd62Sp/7ufkiBhcPwW3G3P67hwwZcR5QsI+P980ppzKrjekdVSJ6S59/vKoZ+NHo9hLn8f4sChht87KWeGi8LPFNQHMCI4XHnGE+YLVzikPL/BmogFaZtgmvAtGD/tM1Vi/Yw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767869525; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WlI6u/5oNvVqPDYWnCWn3kBiMPmGfQfGJduj3SAQtlA=; 
	b=SkPfKMY43paPpf2aPPrLhe95uJlf4I1G75sZdaaeTVsn3XHamOzDaC+BME4rH3e/VNgGN7ITErI8pa9uInQpY4eqHOBZZIttoi2rbP1auRnujFrY7023rHiQxeZIaCuHZprj1x/d5Gc9zZcbk5k05M7hiyGSccEEv16afXR+Ll0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767869525;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=WlI6u/5oNvVqPDYWnCWn3kBiMPmGfQfGJduj3SAQtlA=;
	b=AIOj9TMcqaXrguE/eeM57X/Or1syMB71PNoISL67ecBQ4ZlQDXtAv5hIvjPacfSh
	OsGwuKKKP/pKaIl4UAe1JQ4P/E0vs9WY/GQAqKnqgC6qYUYCEYJOy0IjQwAbjTkbDvE
	6hobMHiifz0TtekuRa8vP+EbmZWFk7B49u/p9aFM=
Received: by mx.zohomail.com with SMTPS id 1767869523702213.87407455318748;
	Thu, 8 Jan 2026 02:52:03 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 08 Jan 2026 11:49:40 +0100
Subject: [PATCH v5 21/24] scsi: ufs: mediatek: Rework hardware version
 reading
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-mt8196-ufs-v5-21-49215157ec41@collabora.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
In-Reply-To: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
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

Split assignment to the host struct out from the read function, and
utilise bitfield helpers to simplify the code. Also move the debug print
out of the legacy version helper, which means it no longer has to take a
struct ufs_hba as an input, and can be rewritten as a pure function.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 65 +++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 66bff5e623e9..fbfa23abbb87 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -797,50 +797,47 @@ static void ufs_mtk_mcq_set_irq_affinity(struct ufs_hba *hba, unsigned int cpu)
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
+#define MTK_UFS_VER_PREFIX_M (0xFF << 24)
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
+		FIELD_MODIFY(MTK_UFS_VER_PREFIX_M, &version, BIT(28));
 
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
@@ -1191,7 +1188,11 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_setup_clocks(hba, true, POST_CHANGE);
 
-	ufs_mtk_get_hw_ip_version(hba);
+	host->ip_ver = ufs_mtk_get_hw_ip_version(hba);
+	host->legacy_ip_ver = ufs_mtk_is_legacy_chipset(host->ip_ver);
+
+	dev_dbg(hba->dev, "IP version 0x%x, legacy = %s", host->ip_ver,
+		str_true_false(host->legacy_ip_ver));
 
 	return 0;
 

-- 
2.52.0

