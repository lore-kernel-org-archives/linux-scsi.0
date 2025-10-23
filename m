Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE0D34E741;
	Thu, 23 Oct 2025 19:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249296; cv=pass; b=PdAo5Ul2dm7iEBG0SNit2cCT6yKjvemFUZ/n52u4s0Cj0/E0VKvuuTKDBD2hUjNMlmmFA04Ax8sSMxZ4SNrW4woxMZndS0/tcepHgewYSogFH7btkZR0UHwJCgTzKwjlN74dJ8iR7BFj9XAQJr6Wr829dX/Hf9KE1v95QYaoc8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249296; c=relaxed/simple;
	bh=Bo/lDu/4JUGihfvAIT1mtkOWnAdt3U2SL+Xx9yiZ2Q0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pIpLcJOkgsGBiCOMXbXg5/18x0Ri6IhsOGsbFP6wgYCX6avM29i+tzCKs+E3FBsS73rtL4ZTUI54NQRm+sh0QrVYjfFLP98AiA9DbrbOsP162qahHCipe7+TN4A2L/zaHPBcBywqUyEiNfSlEhS6Ov6d2q4I6UAbkcw0Cs3zuho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=WkrH9tiB; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="WkrH9tiB"
ARC-Seal: i=1; a=rsa-sha256; t=1761249144; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Yo7AUNLYG4puaMUg1pCpAmZPzjl4FefWOw57fITmQG3igaTqZRC1RR5lWLG+bm4fXYez/Q0Kr2+KuEwP0INWlDtLefFxsDsUY9FjUWGYgG9SuMWFl67KX09+IXXfewOBBxGJI/H6y/Zlzo6PDlz9eUSHyLLI3l+wnYFy8sZ03WU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249144; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nv8CMZib8nFBopw2ZL97D8iWGoOkqbxJHPOsEghWneg=; 
	b=ZR0Wr8jOoFZJqJHrimXvVWiSfDSOsyDkXYFxbX2HrGQAkCHdjjUjpe21JQKB8X84pNIuYVYHQzrdISdXgF3RyxqawAhMRDl/UEIQiwDpIJ+dNpxnXY8lCGNNC+hMWZK0kYsZZqNw86GhsLtLykOM7Wd2ErUDYUAO/oZVfYh+PK8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249144;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=nv8CMZib8nFBopw2ZL97D8iWGoOkqbxJHPOsEghWneg=;
	b=WkrH9tiBEPdtYHzyMrol6REHB/Z4EXjOm4wCIIpf4XRfh4ZeNw6ND2DZcdOhzWd2
	D/Ga5nm6Gkc1fwL8+cqAW3J77MI5Ybiaq68g74k11nVxDT63euPRiYuem655e1oZ138
	9dqQPFYxqgxMuTX4U9CJXPgTzayBijHzrONyXOj8=
Received: by mx.zohomail.com with SMTPS id 1761249143490950.346003343342;
	Thu, 23 Oct 2025 12:52:23 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:39 +0200
Subject: [PATCH v3 21/24] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-21-0f04b4a795ff@collabora.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
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
 Mark Brown <broonie@kernel.org>
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
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 20 ++++++++------------
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 6f54c5a35dc4..38698fbbd228 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1385,28 +1385,24 @@ static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
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
+			host->hibernate_idle_timer = ufshcd_readl(
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
+			ufshcd_writel(hba, host->hibernate_idle_timer,
+				      REG_AUTO_HIBERNATE_IDLE_TIMER);
+		return 0;
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 static int ufs_mtk_unipro_set_lpm(struct ufs_hba *hba, bool lpm)
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index fa27ab4d6d6c..e5a3f70e7024 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -187,6 +187,7 @@ struct ufs_mtk_host {
 	u16 ref_clk_gating_wait_us;
 	u32 ip_ver;
 	bool legacy_ip_ver;
+	u32 hibernate_idle_timer;
 
 	bool mcq_set_intr;
 	bool is_mcq_intr_enabled;

-- 
2.51.1.dirty

