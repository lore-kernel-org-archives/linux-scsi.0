Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0BA30FC1B;
	Mon, 16 Feb 2026 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771249239; cv=pass; b=BKjHlQW4V9SoEfv2bSuGVLpf4m3OH0OB0LnVRIbLXHTGf1t6hmmrG6RbJwsBo+ZVtFTFM7CC1ZC2wq1D2GyrcarL1NEPgeAGrCQ+NYuMf8QUve7+gpxYRZHMOt6mr0OT9Ho7ECUqxsMvbGXeO9x2qYSmvFIpMjACgZRZj8pBe4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771249239; c=relaxed/simple;
	bh=XJuEDCmEOGyWov3aEl4ryLbgR1+P9LkM0Clr2Hk+yHQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kv4V5+whpjox1GJFGWmKzVE8cbTxHcz7Fer+ocfIhnDzP5MqZV6d8ip4AaMTBeqBN1bxcRRODFTS7xdeIt1fauoEsBexKx6n38whnNZl8/pnIUnJhZF0lAoCLGUi7WPZnmvEaIWGvvP6GMn4RHWu3DN4slvwOrhP3Uiw5cYofx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=BfGI0ce4; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="BfGI0ce4"
ARC-Seal: i=1; a=rsa-sha256; t=1771249203; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=L2EF3JmXn57D0ii6OX/PLq6A/zM5wRqxClWvqFOn4tU1dflGoTL9t3iQAu9q4qTB/duAyUgjsmANo5NlGuOH5LAt8L1mKM4LHkpW4Wx/kiT1bkBrztn+S7lgIBPwMWpCsAbIMFr/2fS6GmL3KthsPzyxND8VLiQC6qsfxZn9uBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1771249203; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=5LnxA1JU38LWEEDUOHdTJfl2OEL43g5hAFfOClgSk2c=; 
	b=UlkGY8vypRzWkkhQ04fziFVN3nSyWYvmzgCcJeoXtZXarWUa3cIKULH4rgpdQaq0mrmHQbvvHFF2acKJc/gnQFKaS4OSvKgofx1HkQwerAdo9jwI+/KDOauJhIjrb3dWZVe86gOF8AudIgdygpGAwwau3xbF685FT+H9YZ7jKXo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1771249203;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=5LnxA1JU38LWEEDUOHdTJfl2OEL43g5hAFfOClgSk2c=;
	b=BfGI0ce45Qp9SHuKWOj6ZXjpG0ItYVxZOWqdV5fSoz89WmGT/80LCwAHXd31oq0+
	Q0iG8JjgvHIDWRuJZYOTgNlYYhHU35QbGzOyEIKvAIJ8DufDwH42QelmfHPkYuSlCoS
	VO7J1BfGUlbdcIg/jaG8W2W8dsOqydu14auqIIOE=
Received: by mx.zohomail.com with SMTPS id 1771249201935370.9689229671135;
	Mon, 16 Feb 2026 05:40:01 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Mon, 16 Feb 2026 14:37:55 +0100
Subject: [PATCH v7 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-mt8196-ufs-v7-22-b5f2907c6da7@collabora.com>
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

The MediaTek UFS driver contains support for an undocumented,
non-vendor-prefixed u32 property named "clk-scale-up-vcore-min".

Since it is not part of any binding, and would not pass a bindings
review in its current form, remove it.

To return this functionality, it needs to be resubmitted in a series
that also introduces it to the binding, and justifies what it is used
for. Compatibility with downstream device trees is not a valid
justification for its existence.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index e863e4f8af55..dfa104207cc6 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -880,8 +880,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki, *clki_tmp;
-	struct device *dev = hba->dev;
-	u32 volt;
 
 	/*
 	 * Find private clocks and store them in struct ufs_mtk_clk.
@@ -918,24 +916,7 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	if (!ufs_mtk_is_clk_scale_ready(hba)) {
 		hba->caps &= ~UFSHCD_CAP_CLK_SCALING;
 		dev_info(hba->dev, "%s: Clock scaling unavailable", __func__);
-		return;
-	}
-
-	if (!host->reg_vcore)
-		return;
-
-	if (of_property_read_u32(dev->of_node, "clk-scale-up-vcore-min",
-				 &volt)) {
-		dev_info(dev, "failed to get clk-scale-up-vcore-min");
-		return;
 	}
-
-	host->mclk.vcore_volt = volt;
-
-	/* If default boot is max gear, request vcore */
-	if (volt && host->clk_scale_up)
-		if (regulator_set_voltage(host->reg_vcore, volt, INT_MAX))
-			dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 }
 
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)

-- 
2.53.0

