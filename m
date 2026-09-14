Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A746B4446E9;
	Mon, 14 Sep 2026 11:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385991; cv=none; b=PsEWfcEdrY9CnDBDVLnL2j6HG+kihjWdGgjCPn9R15DQCan+lZUKqp1yEarumJHb6pj/iP1UAvuJFz2kNx7HVVSvtp5RgJnwa24YQtJhVTAZl7c16q9I9MOJQc77Bjisx6GIVFRdMU/6wQRmGiyPRVctJVzirAc9qihtqXKmW/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385991; c=relaxed/simple;
	bh=jzk/Hw+RMwYFWiQX14D3JvGuRlF3I6Kcci6JFjZ+Rhw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N0SOowNO+t5qwTkJxYbMR715WF/oK3mhk4NUduX9l4Y1sTxNDnl/RjMDazsOVRm+lsvFRYaBr0Ak4IS+057k0odAb5eyQRRgQOjGjsiuCQaQquPbltkBg+iLPYIjyhhG/feOia2kzISo9AAUaI2Rq+O/V45FrkUZBXgcqj+0UK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=kglZ+1pC; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="kglZ+1pC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1789385987;
	bh=jzk/Hw+RMwYFWiQX14D3JvGuRlF3I6Kcci6JFjZ+Rhw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kglZ+1pCLAaMd32Ck52SsCESzA3bzkzVVVCjtzgbhVyZ4M6EZgNT64GJIAqf2Wekm
	 hDVbe+mXuBB63TE3SeoxXlc/alqqof//rNNQxkXEdKSfHgsQlJHVpSoBS55DysPkvH
	 wwTzbFjhi5Cs0OFszpUgzIfDx7iElQdSCbUJX60yRrCSGDCBf0pvsfd8CYKaau30tv
	 EaHjjec1K2FU/f1UuQNmcBntzX4+IajLK3cdA5JtFO/tljVcULZarIvFx8dRIba7t0
	 ynbwj/LCyDERd1RtQl9DzgKJ7RITuoPksPxAJc02qxzm6Ea4ja3JLIhKT127trOZmG
	 VCKcnG6lm5cAw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 22FAB17E07DC;
	Mon, 14 Sep 2026 13:39:46 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Mon, 14 Sep 2026 13:39:07 +0200
Subject: [PATCH v12 21/24] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-mt8196-ufs-v12-21-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
In-Reply-To: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
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
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789385943; l=2715;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=eDREcKfoNXLAMviPu/dYRbgFH1U4oQmTK8LePrPi/OU=;
 b=+V2pAzKnvTPRbSFBLcbv/V9Qw+vmZYTrBCuLglcudtJ9HCrbCGJGG+/p5zFhS02J2ozHJEbAZ
 Nzg1Jwboy+9DKdRxHWDs5rM9pEJtSzMs0HuW+NSIFHMV3xva/+X083x
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

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
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 19 ++++++++-----------
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index fc42e6baa47d..9cd852cadab5 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1451,27 +1451,24 @@ static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
 				enum ufs_notify_change_status stage,
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
-		ret = ufs_mtk_pre_pwr_change(hba, dev_req_params);
-		break;
+		return ufs_mtk_pre_pwr_change(hba, dev_req_params);
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
index 6b81c8f76201..1fa14a83e8cd 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -188,6 +188,7 @@ struct ufs_mtk_host {
 	u16 ref_clk_gating_wait_us;
 	u32 ip_ver;
 	bool legacy_ip_ver;
+	u32 ahit;
 
 	bool mcq_set_intr;
 	bool is_mcq_intr_enabled;

-- 
2.55.0

