Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1C34052B9;
	Thu, 30 Jul 2026 09:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405014; cv=none; b=ABPmQZ0KCSB0Bs3JWCvveTgice2taYxX06EeSZyD8XfMOWFASrr4iYbiOlakgVUxmgp4PgtV0X7Rwwe8wVe9YZI/Op+3PSptAm8Rdg6eNhpLz6etzTy7Jok2OdH7Yk4BYTSMlB55Dy1QZxNfRAU4PVznRzh3JfWWxOCIlsouTTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405014; c=relaxed/simple;
	bh=fuSxyu14we/iXSFN94OZyC7rDYI28SKMmAo/MeiTkhY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eR0SYhrFpttc3zgr+Mo5+/zXkqe7Or6fhg4S3zZ0UgLT9xgHMtmlyeViiLgb4LGPLxK4OvkzQvvMPugrAZP/4blAGy67XXDDtVCO02Z4oq+pxvLj3ElcO7OjFim7yT756it+rpIcsqFx9eXnZCR+JLt78XAzLZRpglSE+e64r9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=bYun26Xk; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="bYun26Xk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405010;
	bh=fuSxyu14we/iXSFN94OZyC7rDYI28SKMmAo/MeiTkhY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bYun26XkGohcAyEtK1zXXTkuRV7zIL2EnAyl7GwKjO5tYItyhvD2F1lnYP0HZw+WM
	 yDrQe2Eqbd5d9q1Jniogbx5+vW4O6n/FaXaBqXE6ToRw5O0HiTy31z8DtDaUWgtSyo
	 8JFUWjiD9O6qBEtWP3ezLbWmtAxknP++U5Uf3UqMrvXtEDgiWe3ul7V2VgUp+Fz+w3
	 b5Coh50M75jX5/Q0/snQsys9qv+nKEepIjW81UHv4QN4gI6Kr22IECVoipATWYgGJ5
	 l/aso6jxfE5aPXziAqDjWEf/1xkkOXYxwMqXYZ7Eh9HvkwGXF8pRj2NNRDUYWYJ50/
	 /cmx9eozXmjFw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1E9B617E0937;
	Thu, 30 Jul 2026 11:50:09 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:06 +0200
Subject: [PATCH v10 10/26] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-10-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
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
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=3044;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=aRsdGKk+AxPKp6lmfFnG2Gu5CTm1DQ9gIJYj0vvjwCg=;
 b=u17bcvtIfwPlGTzcj2j3bPEWNBkwyHr85mjynrjRRW+tZgmBCa3bA/1t7r6t9DmEJSRO/VDGh
 7V1D/Bu8Z1XAJdIAmDawfbVG4Gyz39/63Ai1fTEDkSshy4oRFUdiSUY
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

MediaTek SoCs handled by this driver contain a per-SoC specific set of
miscellaneous supplies. These feed parts of the UFS controller silicon
inside the SoC, as opposed to the UFS card.

Add the necessary driver code to acquire these supplies using the
regulator bulk API. They should be kept on during suspend, so enable
them when acquiring.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 55701172bcf1..65036c839031 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -40,6 +40,8 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up);
 
 struct ufs_mtk_soc_data {
 	bool has_avdd09;
+	u8 num_reg_names;
+	const char *const *reg_names;
 };
 
 static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
@@ -1188,8 +1190,21 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
 {
 	struct device *dev = host->hba->dev;
 	const struct ufs_mtk_soc_data *data = of_device_get_match_data(dev);
+	int ret;
+
+	if (!data)
+		return 0;
+
+	if (data->num_reg_names) {
+		ret = devm_regulator_bulk_get_enable(dev, data->num_reg_names,
+						     data->reg_names);
+		if (ret) {
+			dev_err(dev, "Failed to get misc regulators: %pe\n", ERR_PTR(ret));
+			return ret;
+		}
+	}
 
-	if (!data || !data->has_avdd09)
+	if (!data->has_avdd09)
 		return 0;
 
 	host->reg_avdd09 = devm_regulator_get_optional(dev, "avdd09");
@@ -2350,14 +2365,30 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.config_scsi_dev     = ufs_mtk_config_scsi_dev,
 };
 
+static const char *const ufs_mtk_regs_avdd12_avdd18[] = {
+	"avdd12", "avdd18"
+};
+
+static const char *const ufs_mtk_regs_avdd12_ckbuf_avdd18[] = {
+	"avdd12", "avdd12-ckbuf", "avdd18"
+};
+
 static const struct ufs_mtk_soc_data mt8183_data = {
 	.has_avdd09 = true,
+	.reg_names = ufs_mtk_regs_avdd12_avdd18,
+	.num_reg_names = ARRAY_SIZE(ufs_mtk_regs_avdd12_avdd18),
+};
+
+static const struct ufs_mtk_soc_data mt8192_8195_data = {
+	.has_avdd09 = false,
+	.reg_names = ufs_mtk_regs_avdd12_ckbuf_avdd18,
+	.num_reg_names = ARRAY_SIZE(ufs_mtk_regs_avdd12_ckbuf_avdd18),
 };
 
 static const struct of_device_id ufs_mtk_of_match[] = {
 	{ .compatible = "mediatek,mt8183-ufshci", .data = &mt8183_data },
-	{ .compatible = "mediatek,mt8192-ufshci" },
-	{ .compatible = "mediatek,mt8195-ufshci" },
+	{ .compatible = "mediatek,mt8192-ufshci", .data = &mt8192_8195_data },
+	{ .compatible = "mediatek,mt8195-ufshci", .data = &mt8192_8195_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);

-- 
2.55.0

