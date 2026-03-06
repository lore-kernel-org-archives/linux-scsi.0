Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2837A39902C;
	Fri,  6 Mar 2026 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772803590; cv=pass; b=NK+UzA8y0eptlE1M5kKCiqQIf8GzZxXgsAovgVBwdCEzROfMjd9OvgvGXhVNhAn0CHtNd7BrEIsn4LFeNyXriWM7ANuB0rrcI1zu0MZBEMottymvOqktA87wzL9yvd0JnVW5EmuMrENKCxedYW/WluVVc+ErGrRzJWm00zQAG0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772803590; c=relaxed/simple;
	bh=PIJwcg7b7PGyxpfg72fGBTChA7MxXYqq/VCQrBvntZA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FNWZjkgF/RhWa2o0pv96vH6EqXZ90P7y8yeeiYMLSIg+3K65PtBu58rQvbnWS3V0HMPobALOPcqvcE41LSeLplVdh5grNUhAEBfq90WbYQ/WbNmJIQAnJIW8778ghNHO43BD+r9B3RkdpTvN093O5gs7HXCf226RA0HkF02M/sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=jVS5d1F3; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="jVS5d1F3"
ARC-Seal: i=1; a=rsa-sha256; t=1772803561; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OC2rXeR52OCB3Sg9gb6nx44BwtEnPzFhVR4v9unEiq9eKKTNOWNyvC1gmyiX5dTyQWoWHIHWLajlDHoZCZ7FDsgpp1sj6195kIFJzX8ma+ebCUavEpCdl0MRnqSdgAa5d4blNQIHvLxRWHW4ftl8HCj6pVODmB9fR5KvFMKVc/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772803561; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=5Xyy8e3p/cq+P8guK42rqsXIPHr3owm/c/IQ70yQSTU=; 
	b=W/0qr7YEVwzN3WzOtTP/2a5CFudi9SX0nKan1HuFEjSc6io8AmDK9QNrJE/PyAXa/oe+fs7j4V2lThbFSVQTxr0+e/MB07jpYA5Mt8D9iJul+CvBf2i8MWf/7D8q1yNcE+1FZAqEkMsAQacSh9E6E7GuoKjRIA2/ZOlr4QKl4Ak=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772803561;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=5Xyy8e3p/cq+P8guK42rqsXIPHr3owm/c/IQ70yQSTU=;
	b=jVS5d1F3qz2G06VMoTop7qI3FKguH46tvRuIU1v8kJOaPYNMZdP7dgjhkov9h7xK
	ZE/ks408IXcmd1gMcN4ZehBa4cJPobBFfWZZiUUB9xFWZAp1z3aDAJaFA5jhpaWLhXS
	+1cqwg6twyYVdWSlUO6/6KMCphz0loQq0nfYg3ds=
Received: by mx.zohomail.com with SMTPS id 177280355950865.93873774029385;
	Fri, 6 Mar 2026 05:25:59 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Fri, 06 Mar 2026 14:24:51 +0100
Subject: [PATCH v9 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-mt8196-ufs-v9-10-55b073f7a830@collabora.com>
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

MediaTek SoCs handled by this driver contain a per-SoC specific set of
miscellaneous supplies. These feed parts of the UFS controller silicon
inside the SoC, as opposed to the UFS card.

Add the necessary driver code to acquire these supplies using the
regulator bulk API. They should be kept on during suspend, so enable
them when acquiring.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 9b7d7e4ba4ba..3282b2d2d498 100644
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
@@ -2331,14 +2346,30 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
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
2.53.0

