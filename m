Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E3A47F773;
	Tue,  1 Sep 2026 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277181; cv=none; b=Y4/C6XJp4rLT4/AifT5CxuZ7amkFXIgEhhJr5kN/+j0IBC9nnQMrRlIWGXyzc4Of3qi2Wo/zdBICATir2KbAEr8DTv1OD27FaAej3zkEInyKssZriLfMRR//U8MBBbMyRCec61sTwOBYYQ01DHZAgMrTYgpMHIoWusoqoeZLqk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277181; c=relaxed/simple;
	bh=L2LyAjUUvnLIqA7nXO5wWmLeUrg9gPkR753DhuTI30Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KbrruxnT+tRhbyecJ8eGJJJJGspMky50csS0HfjOzKe2nF6frf0HxJEey4snH5sCDs6SAUMvK4FbyO1F8N2kH9y2l8kOLKSNwcVulzjaLLaZqp1AcZSujZDve2V1GBrx9wRtLSNxr5pIc4w1VWVYTlyKcW5mQK755UaLp9/ukfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=hrLXysCP; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="hrLXysCP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1788277178;
	bh=L2LyAjUUvnLIqA7nXO5wWmLeUrg9gPkR753DhuTI30Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hrLXysCPMlAV8R7j9Cye1jpIziTg3QKWdTLDeCfG48Fa28i3Bgd+8U7DLVTSSuPQ7
	 ZJuTUJufqSRvnzn10I9ASvhv96zNOjiKLf0aibCnIJGcTceewCCGG/x4Gq/k6HL/yt
	 eE2x3nSrHDQjoYkZ2Jmvq6jDp6crYxPR2RnDj3F7gYlKoJrvZrMTkHYNLZNuR7V4kT
	 SyA1+gAjW1ZpsaMJpcgTAuMWtqSVIc8up0GzAEzoCdrAbIKt7O1DZnuWICmYDapCTh
	 JpDcgWJdNYdQzowe1oReJBjFzvce6EJmxn8aTWfNkqNuXv+Q3Ezu+FA5cgB7zznmiT
	 kri5U7twgvaag==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 40E5317E07DB;
	Tue, 01 Sep 2026 17:39:37 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Tue, 01 Sep 2026 17:39:00 +0200
Subject: [PATCH v11 12/24] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mt8196-ufs-v11-12-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
In-Reply-To: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
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
 "Martin K. Petersen" <mkp@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788277163; l=2332;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=CR34d5yfvMhIxYS7i9UAHVrLNZzMjtuLEbTpbPOFwr4=;
 b=X5NInAGQw5vfVBEKdDq2lPm18OVU7yOQdcFjgVf1bVLgFftzsA0PHrxblIs6v1Ws5UaAWmYVk
 oKWtf++OUuUA/DIXoEbR3Op/5IZ4XV02Fywm4DYU3KziEGzUAQk+hXi
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

The MediaTek UFS host driver's probe function allows using a
ti,syscon-reset as a reset, without going through the appropriate
abstractions, or by documenting this in the binding at all.

Remove this, it's downstream code and does not belong here.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index f61727879c3c..b01fc37bd259 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2442,38 +2442,12 @@ MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
 static int ufs_mtk_probe(struct platform_device *pdev)
 {
 	int err;
-	struct device *dev = &pdev->dev, *phy_dev = NULL;
-	struct device_node *reset_node, *phy_node = NULL;
-	struct platform_device *reset_pdev, *phy_pdev = NULL;
-	struct device_link *link;
 	struct ufs_hba *hba;
+	struct platform_device *phy_pdev = NULL;
+	struct device *dev = &pdev->dev, *phy_dev = NULL;
+	struct device_node *phy_node = NULL;
 	struct ufs_mtk_host *host;
 
-	reset_node = of_find_compatible_node(NULL, NULL,
-					     "ti,syscon-reset");
-	if (!reset_node) {
-		dev_notice(dev, "find ti,syscon-reset fail\n");
-		goto skip_reset;
-	}
-	reset_pdev = of_find_device_by_node(reset_node);
-	if (!reset_pdev) {
-		dev_notice(dev, "find reset_pdev fail\n");
-		goto skip_reset;
-	}
-	link = device_link_add(dev, &reset_pdev->dev,
-		DL_FLAG_AUTOPROBE_CONSUMER);
-	put_device(&reset_pdev->dev);
-	if (!link) {
-		dev_notice(dev, "add reset device_link fail\n");
-		goto skip_reset;
-	}
-	/* supplier is not probed */
-	if (link->status == DL_STATE_DORMANT) {
-		err = -EPROBE_DEFER;
-		goto out;
-	}
-
-skip_reset:
 	/* find phy node */
 	phy_node = of_parse_phandle(dev->of_node, "phys", 0);
 
@@ -2519,7 +2493,6 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 
 out:
 	of_node_put(phy_node);
-	of_node_put(reset_node);
 	return err;
 }
 

-- 
2.55.0

