Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100788;
	b=04WsLGpZiyTwReyU/5fhlgqaDhd/LdVa9dCsive+zcpwvSvBAiVS1kE9uWRu+7on7V7A
	 WClcmMQjR15f1ZBGbGEOfQZ3N53HmPPcCHC2HRQ7rCJosLWOBwMTZeOIqDE2Jl9QGXXbH
	 fx/d/yaUtyW71ILot1+EiPXeY19bzRwPeb0lvx66lNzco22ZDBZywU/qZuKLSz5p2N1gD
	 iX4uW9Z4RhRgpQmuPVXGXeiHAywXNFV2iVjtShweiW1QVlqctLJb7Ge6RtqHAMoW7eEKN
	 MfMts9S/PqHhaL6qIW7jdu2HwPEg3dFIrY8nvd2ZfB77ieQmuJAGZHG7vWqLmA/YZeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100788;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=nUpP2dfsahoavkSn49CJ56n1JVyy4KL9wBusNcZaWF4=;
	b=fqLwagjH//eRLw4Ce5Xe7BsD60rezDocZQpte69t6X1yMJo9ijB92diu1gF2RZz/65AA
	 yQ6BipYgdLLOL9K21HhS1ls29ti4sv9dMlCMQuJLBReRslKmYVedTBNgGGM/FmT/6pCV+
	 Azt4Ne7j23IW6oa9jCAQk6XDKnglo9Nh3dgPtTKNQW/fsSIhB2rYBxgqJ1U4izQ83Vycp
	 AGX2/1DNigucQ7Etu1E5kPdYATq5n4BB4QYJxHlX+AJGjW8rXWMTLSelqDWTYaqzmF/XZ
	 cMYvK/jfm2PyEiSRSQUbFb2pBCNm2KO1AoANGP/TyeQ4LiCavVF3cGn7u7FNpxvkDAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=bedznDu1;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8562260A382B;
	Thu, 19 Nov 2026 15:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8562260A382B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=bedznDu1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795100786;
	bh=16gt+Ka7nFFym9o+M73u3YA4XmhiVlMb7d+IVjkROOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bedznDu1gHUTDU50YXqACMe62KIJxKM+p2oN5ly1Qsea/mWi/ntYkN/+1IPXBvV7D
	 0Uw7v7+/nRwquqVqR4XsIAcLhV5D7QOAhf+QUKqbKpnGjsXQn+gg1qYs4LllY5McQG
	 dfXFoyr5mPyluDTnTleK09I1B5VXhkh1OUh6el9gzmFr2I2vIeOvX2pEd2FazFZ6Fh
	 YnJjgGUargde8FAXa80XKyA9IbINsGFvPIaehPhz0Rfrlo5C1ku38Mfify6Wf1nXQn
	 NnEorNkZ99U9omfhro+DdiCiYk/OFAbLEcGGOB0eAhoCijnk6aHn56Wb0kqc2yMhhV
	 lvBfoj8Tz8Mlg==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1C23D17E0E37;
	Thu, 19 Nov 2026 16:06:25 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 19 Nov 2026 16:05:57 +0100
Subject: [PATCH v15 09/23] scsi: ufs: mediatek: Rework init function
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
Message-Id: <20261119-mt8196-ufs-v15-9-aae1eb0382e8@collabora.com>
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
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795100772; l=3144;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=/LlC58cVSrCI0SFHQxJxgVKWtf90mbLp6Q/5YAMsU7Q=;
 b=EgCXezobjo1FL+YAGNe3KpSQi8DJM7X7cEzm+z7EROWHcuRIA401swweERoCmDTOSbSxPiJ2O
 UnD+cVqWZzHCVGUasMGuWHihKh4zIINA+cUVJLYZdNlM2hZfya9svK3
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
index d85824434b94..3b23d9726e43 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -54,18 +54,6 @@ static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
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
@@ -1322,29 +1310,19 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
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
 
 	host = devm_kzalloc_obj(dev, *host);
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
 
@@ -1420,11 +1398,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_get_hw_ip_version(hba);
 
-	goto out;
+	return 0;
 
 out_variant_clear:
 	ufshcd_set_variant(hba, NULL);
-out:
 	return err;
 }
 
@@ -2474,6 +2451,18 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
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
2.56.1

