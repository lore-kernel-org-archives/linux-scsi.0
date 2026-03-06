Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF8F3A0EBF;
	Fri,  6 Mar 2026 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772803685; cv=pass; b=DXd/f0q4ncBBjLbruhjcBw8IYG8IrNJswRvq+SySKhwdBETsz6C4TWMN2IQYUlJKfjI0htP1I6AQBIBRDWhRZiyt6r7iV6dkVHNVeySeCZilJ5IcPP1piwT8d3o0qVTjFxI+wF/zD/Yl8tz9Qh1yfpLDxEAcSARM48guORTIFe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772803685; c=relaxed/simple;
	bh=RiUoOoscMB6JIhHljdCIS4+vWOUgz5MkSHFfJZV611E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P/WXk5+nT2zPDXw86lN5U1vFmBYZMgDoxhidFk5wBovd8fQN74sNFuisR+ulk3hoqZBY/rvh6wrzzfaHoGkG5oeykh+YGK20+CpYUIeXJW93DmET9otJXNs78TUCUKQlTLm0v4s+pY5G1p8XC8oqOV4m+NLZrXr7mFqoSbe6bKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=YWnHIjrB; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="YWnHIjrB"
ARC-Seal: i=1; a=rsa-sha256; t=1772803628; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=b+2T+E3pBdHAcaTERaqKvcaSqY7yg2FLPiCMTpoffB3USLW499Ox90fXyzVSmO04xxgjaieUXyzIcSxQZOdrFRxc7QkXEISL9R0pwp0080GqGvfdaB7kFaCYl5+sJOKYT3YIeG/v5xVJZgbAioHxA6tg764dRABvNrZ4AH+64B0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772803628; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vHGev/SVJHjtM5KJlxdcEOTZoj6KMMDvqCC47rp4HM0=; 
	b=lOllQD+nUl534GajLJG4I2NvzitjCjtaaZNp3sjRsqGyp71lj93XC2I3eF7QrbXbXOBy85IdqfmM9Txp2bGsI+0SQPwFmp4YqNVsv+lXQxviTDmVro1x8NosufNNrA8XbL7VzRF4zTmDTdFOc2XZbwaK69SP9pjoBN4QyrmNp4g=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772803628;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=vHGev/SVJHjtM5KJlxdcEOTZoj6KMMDvqCC47rp4HM0=;
	b=YWnHIjrBeM9MpqXxZWyFswF7+EvZWWjF2/GX7ylbPAC+8CR8K0U7hA8LfqdcryZp
	qBEK5ImjP05WQKA+clNzw8Bv6VzVTpsEDB59thUl9IzqkHAPYE9H5f+e6Kx7zTrWidZ
	B0R6M1wquZmiJ0iUylioZDD5jDcNYnJkGX63elGY=
Received: by mx.zohomail.com with SMTPS id 1772803626023697.5615829679394;
	Fri, 6 Mar 2026 05:27:06 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Fri, 06 Mar 2026 14:25:01 +0100
Subject: [PATCH v9 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-mt8196-ufs-v9-20-55b073f7a830@collabora.com>
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

The MediaTek UFS driver uses a function-scope static variable to back up
a hardware register across a power change in the
ufs_mtk_pwr_change_notify function. This is dangerous, as it's only
correct if only ever one instance of the driver is loaded, which isn't
true if there's more than one device on a SoC that needs it, or it
otherwise gets loaded a second time.

Back it up into a member of the host struct instead, as this struct is
per-instance. Rework the function to not use a pointless "ret" local as
well.

Fixes: f5ca8d0c7a63 ("scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 20 ++++++++------------
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index c4e70fb99e82..2198271a269a 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1398,28 +1398,24 @@ static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
 				const struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
-	int ret = 0;
-	static u32 reg;
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	switch (stage) {
 	case PRE_CHANGE:
 		if (ufshcd_is_auto_hibern8_supported(hba)) {
-			reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
+			host->ahit = ufshcd_readl(
+				hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
 			ufs_mtk_auto_hibern8_disable(hba);
 		}
-		ret = ufs_mtk_pre_pwr_change(hba, dev_max_params,
-					     dev_req_params);
-		break;
+		return ufs_mtk_pre_pwr_change(hba, dev_max_params, dev_req_params);
 	case POST_CHANGE:
 		if (ufshcd_is_auto_hibern8_supported(hba))
-			ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
+			ufshcd_writel(hba, host->ahit,
+				      REG_AUTO_HIBERNATE_IDLE_TIMER);
+		return 0;
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 static int ufs_mtk_unipro_set_lpm(struct ufs_hba *hba, bool lpm)
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index fa27ab4d6d6c..2349d9b9375c 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -187,6 +187,7 @@ struct ufs_mtk_host {
 	u16 ref_clk_gating_wait_us;
 	u32 ip_ver;
 	bool legacy_ip_ver;
+	u32 ahit;
 
 	bool mcq_set_intr;
 	bool is_mcq_intr_enabled;

-- 
2.53.0

