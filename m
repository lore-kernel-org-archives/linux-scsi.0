Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FAA4A5EB4;
	Thu,  1 Oct 2026 08:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790842952; cv=none; b=D8MOwKAyCsmZtf/zJnoDBPfK3HCwsQtPoPIFjHGHDndRXcpjnFyHV7nhVkG76F5FXmuenDQ9l5yAswjQQiDBFK8Ta08UrvRu+GhtOzNM6NMAWLnzopjoHeiI6beRzLZa4hOF1ahMO5auWaOSCz+KyLJ8b58UY+xuGhWOCLVeFYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790842952; c=relaxed/simple;
	bh=JzFqyLLEnzw14LREPv+R8dP2K7kfrydZYiGRQQwwacM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=doD02O5W3RZxeV7MRfZtJ2StsuJJMEkPxgVNkULWsJ7JxWBMaQ+FmKfkQ4bWRujG0oAyX19ddNYIQBPe0CCTBMcUQZ87EiMsPVRQ/cZKAWHFiUjE+qX6SPbYlIdsuDX+FYxMjveJwywo/XSG3HBa7MUHar6B9nayAXRlNXjB8bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=k/gzjf0d; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="k/gzjf0d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1790842932;
	bh=JzFqyLLEnzw14LREPv+R8dP2K7kfrydZYiGRQQwwacM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=k/gzjf0d/ZBn3HgprXNy+ySz2ZlQl1ERGgKt1yIiqD4gzmjxtAwZyvqm+s6in8bdT
	 s3N/U/NKMqgJs2mKDmYvg+clCJ+U7erSbXkfwyBM4OLqHoUqvPhBaAAIAcVu6zV91G
	 JYrycu/5x9YrNyoqP2oevFaYb73ZCTRFHPjm2h6OqNKFE/hPDPCBS7rgC9NxbvfMko
	 kgtlXsTNaJeuZszFZv+pZIxK+ju7tQDNy8qcEh2zuvNB6q40/DTvwN8kO3EeFqejKF
	 xhAujnKapgPDPpd2aj0INwC3TkBpBONREVsjwpDAF4EyN3Gi02DNvpXqE6AjuIxphA
	 poFYB8vLTH/CQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 4EA9917E0B0F;
	Thu, 01 Oct 2026 10:22:11 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 01 Oct 2026 10:21:44 +0200
Subject: [PATCH v13 12/24] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-mt8196-ufs-v13-12-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
In-Reply-To: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790842918; l=2332;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=EA6SnVOzyjYYTTrEA8aFmVcHEyqNgJEZ5fw3Wj5qVwA=;
 b=JXYMP9/V+qp/DQx1MiTFqy5WT18iDnnEvK3HruU3fgM9QwcHCr06YkYrgkAB9irlLHJStYG4x
 TfPoA0NTVB0CSCUjJdwNF5FDZNfdniI81VcYu3QPmRzrRfbzgv8fX0H
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
index 16f1f10cd1c8..1dbf056e1d7a 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2456,38 +2456,12 @@ MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
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
 
@@ -2533,7 +2507,6 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 
 out:
 	of_node_put(phy_node);
-	of_node_put(reset_node);
 	return err;
 }
 

-- 
2.55.0

