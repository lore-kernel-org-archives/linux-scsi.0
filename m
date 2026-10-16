Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7225493653;
	Fri, 16 Oct 2026 12:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154027; cv=none; b=jOJ5sGC7CjgS+keNodpL4u+JZkPGa87xINe2w2//lwIoUn7GXKhy3iw2Kt1dsHVM3Jw/yA3o/eunqhydQ5+VTA0BxQyrY3IRM9AuFRgvichqSmxtXqH9VEyICxAsKqVOppWpn/xpO2f3O4B4L0jqFGz3mpWgqKYCVBsDXveBwwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154027; c=relaxed/simple;
	bh=lkTtSrZZebD0D1MrHOhVvg4ecqLH9ywFPtjBgVBc6iY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EQFRoapTgdGL5VFcAVnmhClVWwHMUF68b4N4tBY50/iZrFOydpBIauDQLgnYbeIIN1pxElD6DAGTfQAEhvKN/w+g7hcZ3Sg//0XSnAaVvG12qX7FpprsR53S+djNhhhGU3QQgmaDT2QHLv6oP6V+J8ZfI+nXQnvKPk6fAKcpCs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=U2DeIx5O; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="U2DeIx5O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792154023;
	bh=lkTtSrZZebD0D1MrHOhVvg4ecqLH9ywFPtjBgVBc6iY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=U2DeIx5O45yR79/+d5IIaAUWFtuDBLjYPEhiACW47IXthUmdhc4l1sS2V9aVtwn8v
	 ACmAgSRruaFrncM18TON7GiZdIGlKZiTUrvBPondSHL3itKXo5P9zpPT+CtHUBOBnR
	 LsIHgozKu2io295ROFwWx6mUvxpYQb/kY2Kavbq+jGi9sAyqy/fuzqnu1F5QYyzaU5
	 nLgfBOLbHoRsVmg+lRHH1XW83ebc45IiG35KudpHI14biW2zq8724Vbbczs7u6XrWO
	 +vK5o0CbSRpiAhZcoSqJm96v6xeEJ+5xm1KkryYg4afkBxGi+lYL2NU4LwJVpETcU+
	 HI0e2Dqhj28IQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 039D117E3747;
	Fri, 16 Oct 2026 14:33:42 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 16 Oct 2026 14:33:04 +0200
Subject: [PATCH v14 12/23] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mt8196-ufs-v14-12-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
In-Reply-To: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
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
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792154009; l=2332;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=EY0U3sj6rvUEERgFSF8RhjFWo7pI9Zw40jOv/4R8JTc=;
 b=V6CjxCJjTnXt3CI41w2YUJqdYY7UzjTUKmEB/PI3JatcVd6ItXmxU+wGsSAg2/tDPVVrcs20p
 MnC6A1s5L40CMEaOWUuo9notrrMHNCScEluylpPBLXsDysE5lOy//iK
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
index 58ae8499ebf7..46c9153be6e2 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2474,38 +2474,12 @@ MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
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
 
@@ -2551,7 +2525,6 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 
 out:
 	of_node_put(phy_node);
-	of_node_put(reset_node);
 	return err;
 }
 

-- 
2.56.0

