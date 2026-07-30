Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD2840099E;
	Thu, 30 Jul 2026 09:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405010; cv=none; b=b9gD7r5vO2m0HQSGKuam7jLMu36iZl8XjDZ2JPdND+Piw7NNPHwUa5kz3Sn5d77ojX3BXe9FIyrws8mrEDrXjnlZfyTQs3Ewi2fkT0rzRAF4lEb4fB+JZ/y+kFikHbwitVkRmlm0TrGlIv9xmFjNQi2m7m0hOYAyF6zk0egRHnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405010; c=relaxed/simple;
	bh=jMcptFGWKEz/LazKiN2JuJh4vp2xEtPPYfboxcdOrn4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=khPbAz1tgN6AlvDEIf8/oP9LoEv4gfU5aD5K+BRnF3iCh7xc+ToUJm4n7TAES0VbhTEoFTdgzQ9m0FsS/40iOVkoSnqOLkt6V1ALtnjoUiYQfxRlQLUwmwW+ZCKdHzCrEHbx6qUo3cMRBoFv8gbMW9gX3KeF4lc4yCRy+LIiSo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=VeaQ8BcI; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="VeaQ8BcI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405007;
	bh=jMcptFGWKEz/LazKiN2JuJh4vp2xEtPPYfboxcdOrn4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VeaQ8BcIw8CvoT7Ftt7jzdhOh8je137GHaRkCmJXTNlrzKeV2cBeZR+Zdr9DKdK3k
	 lcvNGOGUkiCQ6YvTpPnDYegcvPQLpBMcpy7u429QG4uM1wJQf1NxbGQiZjoBGDlvfe
	 fOddk3Q+h/j3Q3AIP9j5BYa6SpgaiZnfhCgblCrqlGy+h9CIafDU/eDs0nQEpDCUGb
	 WY3IhMFal840dEcG9ErPSV/bDVzLNvtwz4m1UdZJpcVRc7+DRcuBFwcTXJX8bewZf2
	 O+z8HrNpeAUoGFQ6bDIothMfc//0k1JwWsUMSbvJdPoWBa+2llYnv07lrNQtpw526c
	 X44mZcBp76rDg==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 23CA617E062C;
	Thu, 30 Jul 2026 11:50:06 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:04 +0200
Subject: [PATCH v10 08/26] scsi: ufs: mediatek: Rework init function
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-8-bc5ecef202dc@collabora.com>
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
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=3160;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=37iLP4i3wyEpucKYHGpmbRoJJNWcdn2pMK33BkoNwiE=;
 b=4vH79Aax4bwrNsLnG0C+W+yP1DyvfjmkZx5AoIymB1t5TQk5fPsBXpnId7W0DMtNXWgooPROP
 cIv2DHQchU/An3UpFs1yHjg5SD4T/34Kv0v3XTMohwgO0EqeLhibeE8
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Printing an error message on ENOMEM is pointless. The print will not
work because there is no memory.

Adding an of_match_device to the init function is pointless. Why would a
different device with a different probe function ever use the same init
function? Get rid of it.

zero-initialising an error variable just so you can then goto a bare
return statement with that error variable to signal success is also
pointless, just return directly, there's no unwind being done.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 43 +++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index f6859cd0b1d4..50e7701d7943 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -52,18 +52,6 @@ static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
 	{}
 };
 
-static const struct ufs_mtk_soc_data mt8183_data = {
-	.has_avdd09 = true,
-};
-
-static const struct of_device_id ufs_mtk_of_match[] = {
-	{ .compatible = "mediatek,mt8183-ufshci", .data = &mt8183_data },
-	{ .compatible = "mediatek,mt8192-ufshci" },
-	{ .compatible = "mediatek,mt8195-ufshci" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
-
 /*
  * Details of UIC Errors
  */
@@ -1260,29 +1248,19 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
  */
 static int ufs_mtk_init(struct ufs_hba *hba)
 {
-	const struct of_device_id *id;
 	struct device *dev = hba->dev;
 	struct ufs_mtk_host *host;
 	struct Scsi_Host *shost = hba->host;
-	int err = 0;
+	int err;
 	struct arm_smccc_res res;
 
 	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
-	if (!host) {
-		err = -ENOMEM;
-		dev_info(dev, "%s: no memory for mtk ufs host\n", __func__);
-		goto out;
-	}
+	if (!host)
+		return -ENOMEM;
 
 	host->hba = hba;
 	ufshcd_set_variant(hba, host);
 
-	id = of_match_device(ufs_mtk_of_match, dev);
-	if (!id) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	/* Initialize host capability */
 	ufs_mtk_init_host_caps(hba);
 
@@ -1356,11 +1334,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_get_hw_ip_version(hba);
 
-	goto out;
+	return 0;
 
 out_variant_clear:
 	ufshcd_set_variant(hba, NULL);
-out:
 	return err;
 }
 
@@ -2402,6 +2379,18 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.config_scsi_dev     = ufs_mtk_config_scsi_dev,
 };
 
+static const struct ufs_mtk_soc_data mt8183_data = {
+	.has_avdd09 = true,
+};
+
+static const struct of_device_id ufs_mtk_of_match[] = {
+	{ .compatible = "mediatek,mt8183-ufshci", .data = &mt8183_data },
+	{ .compatible = "mediatek,mt8192-ufshci" },
+	{ .compatible = "mediatek,mt8195-ufshci" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
+
 /**
  * ufs_mtk_probe - probe routine of the driver
  * @pdev: pointer to Platform device handle

-- 
2.55.0

