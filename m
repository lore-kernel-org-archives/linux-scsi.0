Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100802;
	b=5F9DXbKToNSStvmiN1xhXBXZqcgMImmg2SyRNqZH1vnXmW70D8C9CBFIPBTKvPaAG3Hn
	 XVQd4ViAcGYA/sXF/dk1NCYW7b/yFLU1v7qHlFib9GC3Q/s16iBAoBBMdCZ9K5KRwK7s/
	 cc9f4KJd6IkFVZwG1oVSQytBLV4zSl9oXWy1K0fZrtWdcjXSyY8fwZiYpmPYMdRXA038n
	 lIl1Upi2VOBqb31zHfj7zeR9XSKnVt65VamWN/iTH2hYHOX7zKgy9o5KLFJ9bvvWF5vZd
	 ZRhVlwpFvWzBlQ+24NhRu8SRaQqXe68L1vGaoQUbTX8YU+pXV/jCva6cx1nvcjR0V3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100802;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=nXiSdjZU8L5zDZ6t6JMLiXRlMWvOY3yTDFC/9zm0NiQ=;
	b=QwuHZ6NvOLMfL+fm50jdSLTg3y74GuLxjgDVcXWMJNh3RvbA121wVUQZsV29gwhP1Cq3
	 /220LLB+8oDYJ2xrjtRBeNQK+vXKSQdVCH2L9e5ZsXBzclTBryCabK49XuLdtSA3XcbOT
	 RDrMqIVKZ3FM+pFn+gDVg5pvFAapjkCrILCx+Soe65oOTdIdj3uGJ+pbOKPcd0reijYav
	 O7bTROiPFGIO9uMaFQd7akK3ygFmmu0xs9lUQDBER5UCuI0Hnz+RBReA2+uQaXWaVgAHq
	 flY7OMvdc1iY7sRQjJKtGUidS+xPVxPhXNJfmQqnifEtLrPsOz77AYqX3fNhNvmkvYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=joBzCsGQ;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E684606B3E8;
	Thu, 19 Nov 2026 15:06:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E684606B3E8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=joBzCsGQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795100800;
	bh=TG8NHqroE470IhtPWPineNbuAKCud3LW4LfdKrS3x3o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=joBzCsGQ3Npz/cVmNMzW964+IzEpR5LtVsdrQ+NoGbAVnLRNXgJzOr+l9oxUJdtb/
	 DiiBORkE8qQ2tZLOkkcJ6NaXDGeAYfo1bj0XDSJiAd06mOYvLzasnoIklWqEs59Cp6
	 atXdgkU444nefP3P6VYoY2fSCNRt2rlESoGu4qQYYDrWkDn4ohH7ugqXGFK3tv+3xt
	 VuZA50S+EcUhDqEfhUFat7fwb3nwhBzPrvpGdm1xHe10TktawdHR1xdgUAJ4boLSzT
	 tHl7Um6uKy7Q+/IRTS5bCMcY4K3680xZF80I74vGzIK1EpcPKyWWc6kXoFQ14PNQWd
	 cFh1uUrqw5C5Q==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id A0EC817E091F;
	Thu, 19 Nov 2026 16:06:39 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 19 Nov 2026 16:06:08 +0100
Subject: [PATCH v15 20/23] scsi: ufs: mediatek: Rework hardware version
 reading
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
Message-Id: <20261119-mt8196-ufs-v15-20-aae1eb0382e8@collabora.com>
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
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795100772; l=4038;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=YnQ655Ukh2nZOkR+JY7qt0+WM0oB7MulZeY9i8qeDqA=;
 b=YWOkMfyA3bBhi12LjDNFFTRd5/TpAw0oEaRrvE1sbl39J1eb2lTK58r/t0xDs0+eF65bCqJgC
 Q3ygrl0nRWDDtFHv8Hlw+malHfOu8WeMUcx008CknE2StD2oha1VkIQ
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
index fbdf69895db0..b1167f7831a7 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -849,50 +849,47 @@ static void ufs_mtk_mcq_set_irq_affinity(struct ufs_hba *hba, unsigned int cpu)
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
@@ -1259,7 +1256,11 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_setup_clocks(hba, true, POST_CHANGE);
 
-	ufs_mtk_get_hw_ip_version(hba);
+	host->ip_ver = ufs_mtk_get_hw_ip_version(hba);
+	host->legacy_ip_ver = ufs_mtk_is_legacy_chipset(host->ip_ver);
+
+	dev_dbg(hba->dev, "IP version 0x%x, legacy = %s", host->ip_ver,
+		str_true_false(host->legacy_ip_ver));
 
 	return 0;
 

-- 
2.56.1

