Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C383E2F3C30;
	Sat, 24 Jan 2026 12:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769256270; cv=pass; b=H7jYuhw/8J7EmRfQM7m4BJiebYGbMxv32A3WLpcjXXol9otsTVA3Jk5NaaebI08t2GyyPuW4Gs47g1zkpqsxff9KnnUZkiWB5TzWBMMQcpxU9lTUixeZram7binBlrtGOkGCXdtu1VAY8MmQZkGE/h0OkzZNlMojIeH2WN+Q6NY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769256270; c=relaxed/simple;
	bh=vZ3LOu+wQWKPs2oaFOfd6lc4PTECPG7VVlUg0ftazfo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hkw54HFStsHzj+XBe7JLsQYKvl+ZK6+WTRZzFdd8F+pSbFHtRXc8v1phxVjpXHY/28Rsm9UdNeBiHBYCH3IbkRSpigBJ4KojqqsPDML1XbrDJR6w+ngW1+/mVK/u6tUFsoHNfMsM1dIH/ZUXqiQJ1T5Y6w4q25sLx44YPElmJJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=NPkA+uq7; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="NPkA+uq7"
ARC-Seal: i=1; a=rsa-sha256; t=1769256221; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gkvlXziP+lgOfKPzBoot3qqY3Nw2rn6fYHXYBSlEBNdlICA0ExaZRoK9SdLCbbq7lxYq/54OktdIa0QHhsuVltHgXgRV2JwGMqdVf8H3JE3CQe1ghXKLgTCrDLAj34emx6pIvP+KMcoFuyvwKXT6BxPp5S7Izx7kVH7LLq3gIF0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1769256221; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=d2ImRJ75pZduojZEXoZjZ2G3lk/uDGjJ8V1tW99jraA=; 
	b=X7AHvEeT/KeUQNbUPTUCPSDxDKPbNiCy+X0tvK0R+Fj3ThWHjdfcLUO+qMvA1PLabu+b7Jj/2jLXiz12CTgmojR/gWmUYn4NqhMyAtZRSwVWSfWfoiJ+/YWUkSJVl7FWdJlx1M7005MU9aKEOIOO7q4i5DVQC7nTQ8ufN6f8jAs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769256221;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=d2ImRJ75pZduojZEXoZjZ2G3lk/uDGjJ8V1tW99jraA=;
	b=NPkA+uq7VOYQMnrPLgNxDnMPFtUwLxyGCMXl1qAVTXxvmnpksVAo4z6/7tKIDoVN
	2La/lY3Wnd9tDoCPWfli/KDA2eNOQLunuR3WRIWbxrnKKpaWgx2QISyxLgVvAKMnija
	U2foZIhOH/zSUpM7b+b+y5jmW+s+dBNnNSWnCtbQ=
Received: by mx.zohomail.com with SMTPS id 1769256219717617.1320721102721;
	Sat, 24 Jan 2026 04:03:39 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Sat, 24 Jan 2026 13:01:09 +0100
Subject: [PATCH v6 23/24] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260124-mt8196-ufs-v6-23-e7c005b60028@collabora.com>
References: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
In-Reply-To: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
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
2.52.0

