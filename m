Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E41944CF22;
	Mon, 14 Sep 2026 11:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385973; cv=none; b=f4Il1R0ayqp3Iw6cX9wB6qeuQQ7i3LEywLRXTzLU9cyM0sLgukEv8rF+iBlo5pDjvJbAzwBzO/4BOyZZjPSlUlRFuj/qN754HtF1ZVYtv0mPM6KfbHfRxek3zdZaG8IJM+lIfXsljST86n6gi+sLG6kGA8ez85szQPTgVjSNhLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385973; c=relaxed/simple;
	bh=qXRhQiWz4yjkAG64NpqUexuN8x59eP05aPyDyJLzjuE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ATSha7Ky8/E+YlPJTvjzL58gEUbBN3frf0sacSH4SNEqiRCtDsM2iDpJUFGcSfi+US+WI4Xjf/yvkR5viBQdq5t6jjSfDVjfa0ib89XScsXMdn8Y+AUjNjgcOxOR3OcIcUrDRngL9KF9AFtJMay8ydew5LCpBeHpdHk56Zs804c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=EStvmeoK; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="EStvmeoK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1789385969;
	bh=qXRhQiWz4yjkAG64NpqUexuN8x59eP05aPyDyJLzjuE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EStvmeoKgz2OvHtOibWJGQkcoc4u2xnHAQHAE1zeLSySgAitfxESycy7D2u1o7WLj
	 r5lCQWxS3RiqBOYIppEsBPpqxk5SoKsCBCm4qR8GI+wI7xkMWSJDEHy18D9qC8CkNn
	 phr3rG3VzJq5jDlsSSwYKNvTD+vIn8ZnoxVNKQkfGvGCCcJINQGkTeUsTLf4XoC32w
	 0e60iXZWuKEEAcJBetaOK6PC8nX+0Ahh3LE2QwxiRlWkbCAbA2vzQn35TCEayhFgVD
	 tYKZcvaxxE0Zk5KJl0lOg7crfPHPsGMrYpsBy5BIZrGe5PSBShD8B8sRAA6NtrGCQK
	 p9oOMaucKhkBQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E842E17E091A;
	Mon, 14 Sep 2026 13:39:27 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Mon, 14 Sep 2026 13:38:58 +0200
Subject: [PATCH v12 12/24] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-mt8196-ufs-v12-12-9279d7ef814d@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789385943; l=2332;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=g/eawi80h53Tw7KZFt8dlxUWQY3Eq7uS+MqISAa1J18=;
 b=DSX8wp8bC/Y3ZCiB6NYbMTcRBphCn4WJ77ytgCQxx8jZuXtrAs9D3Vxst3ceoOJWhykQKbyiV
 19IIGdQ8CqMCz+ab+1JimVwtIkLykxKqT9QBe52t1sBXdt0shJ/87IW
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
index 15960d7d99af..3d108a092920 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2451,38 +2451,12 @@ MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
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
 
@@ -2528,7 +2502,6 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 
 out:
 	of_node_put(phy_node);
-	of_node_put(reset_node);
 	return err;
 }
 

-- 
2.55.0

