Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A2D310764;
	Mon, 16 Feb 2026 13:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771249148; cv=pass; b=AsNc0NCbdikY4FyveUN88GF44vZ+ZqU9Bc/GNZ1uiRwuiEEczBjpYZVMCbQGinms/bYCqabkLZhz4mtm8siUfW3NOMccOU6DI+3mNBqaO92apGb7wZfnisGTWFa362Cbi898D5bU+Wy15WOOIz6xRFFzfeboYBTlNMatJ1rcEQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771249148; c=relaxed/simple;
	bh=w3AZfNS02pMmh1/aLXq8fp80IavtkQwt18Za2M+6tK4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FatBTq/JfDPlm/7txTZikUNLNfJ41fAQQxYUh0GZmg5UqTwK7rL/hR1CHNyMHIi9pX8qeJSMWhvjCk/DtlF2WgHNgRI0jbTu3QtU8ZoXmIUDo7Kyb5iuwbXYexVkBR8UpuWnAPvDWggKxdek2LVphoBsmYcSlxM3NJXGwY0D9f4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=GVPK0xJR; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="GVPK0xJR"
ARC-Seal: i=1; a=rsa-sha256; t=1771249125; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=g8d7m3Hsq/GUYW+BLAVylrSRynXBVM16CB+Xvr7oYshcztkW2r8ZO4jkMlagijem/BWswUmJ6M/OCDOPvmg7d/GbweIkkzVsVHMQu8nejKIZWT9T49JXSx7FIsaCwTHpcQa2nuz5p0dMnzZbgW7H6lPH6xUDVW2uu1ZlcTfFbD8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1771249125; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XbI1SV8H/A4qosZYbkwhTobyA++HOSFk8wTW5Aruoj4=; 
	b=OqnVmaH6N/Ic0o1/3LciOGsISxsvr+UTDsfuI/uwSBSW4cc1LUif1kx7XpMd+r0z6a6A+w1O7ej1njJZtiZw7NUwVtj1HuouHxHa4q6KCwPFcSJcLxsbrTsX7SJR3JNqY+IX5bmombAzLg1pU5Vc4q5jfn0ckOIClQDtIAh86g4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1771249125;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=XbI1SV8H/A4qosZYbkwhTobyA++HOSFk8wTW5Aruoj4=;
	b=GVPK0xJRxXP0QtbafWW8+yDlOO2VUUg1yzP4BarSsMYG1C0Rakgo1Ds7MSrdixZ0
	5yYWzYIVsoaG5+gO0/YWwSH+kA9VNfBSLvjvDGlTO3+Y2foCV7ovGz2r5wIdGZqw7a+
	d6Mg99fqY9VcT/JIdw81atZ6L/ZMMpIz8hqllLcQ=
Received: by mx.zohomail.com with SMTPS id 1771249124907979.0503377106259;
	Mon, 16 Feb 2026 05:38:44 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Mon, 16 Feb 2026 14:37:41 +0100
Subject: [PATCH v7 08/23] scsi: ufs: mediatek: Rework init function
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-mt8196-ufs-v7-8-b5f2907c6da7@collabora.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
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
 drivers/ufs/host/ufs-mediatek.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 0d22ac4c925c..392383e03ab0 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1248,29 +1248,19 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
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
 
@@ -1344,11 +1334,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_get_hw_ip_version(hba);
 
-	goto out;
+	return 0;
 
 out_variant_clear:
 	ufshcd_set_variant(hba, NULL);
-out:
 	return err;
 }
 

-- 
2.53.0

