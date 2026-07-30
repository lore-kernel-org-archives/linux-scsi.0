Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D27407CCF;
	Thu, 30 Jul 2026 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405016; cv=none; b=Jh7BWUiQU6vGfpy6+WCe6s/I5lheFYW0IKiVObDZHDwnNny6R3SFXRnhUQ9HrpCnIaSeuXxyQAIuAKzLLlXBNC8JlEtI7vDsTXoir2yBzNutql8gS75CSyFIMM4qqlWlhiEINja6/mjOD5lI1N9uuYQEmOW8UAAfwa+O3iaC+nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405016; c=relaxed/simple;
	bh=4ll3OEUxJR8oe1S3VBPQPkAR4Xay+19kDpsAma9ZH38=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TscxC+wdV3Cu3SMGgA+OJK099ylOwPZx+bTPymKAln9bt9DRTYvVH74t9ptU1W1svao9NsCo0ecoHNzcwsCM8u/xsAHe6a6S5CtguUok1J/upGfCIzElW9yS49wOSiyI8OKbIXoJWkHxNQ5TL8di9jWv7tljsS2Vn4Dh1aOYih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=GRFZI9dN; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="GRFZI9dN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405011;
	bh=4ll3OEUxJR8oe1S3VBPQPkAR4Xay+19kDpsAma9ZH38=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GRFZI9dNYFOKquSW1j4KA+O635BSr9sL+eYdaq+T/BdB4YKKOdSskdaVYGAX4jb27
	 VFje0rmpLdG596q1NPY56NgSwtRqmcKLQWFXUBEMdSIt2fHcj501l3Vh5EelrLt7Bf
	 oKxFYcOyxUocmLOO89Aj7qrRMpPTGTAou0LNPDCBdyaMFzjmLLNgiK1F9njddieL5t
	 NKPYHnWh253dAfErWByjXGl4+y4hBsim6Hi+RgvLNwjHLQTkNYhKK0VppzTvpL65rm
	 +jMxI/bK6823JJvMZOcROFIgTaGJTCSd92OWIrN13RF4tkjCzuEJanKb+ndmVcynm0
	 QUc+ji82ST0Cw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9A9E717E093E;
	Thu, 30 Jul 2026 11:50:10 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:07 +0200
Subject: [PATCH v10 11/26] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-11-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
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
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=2275;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=i6jmgwFp2/77FhEJuMn2TADRA2ctSix1jT8hftPwcoM=;
 b=XMxgXw2J1zYEu5Q3W1KTN4HrN/iVRRXACnnJ20Z6h6dSLOROZ9s90wttWK7yYHoHLmteZmd0T
 tovMLktus5ADqgXCs8ZeysdM4NBnQcxI80b5tdZwGJkQwvcV6ryDpEM
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

The MediaTek UFS host driver's probe function allows using a
ti,syscon-reset as a reset, without going through the appropriate
abstractions, or by documenting this in the binding at all.

Remove this, it's downstream code and does not belong here.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 65036c839031..a2749e79514c 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2402,38 +2402,12 @@ MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
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
 
@@ -2479,7 +2453,6 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 
 out:
 	of_node_put(phy_node);
-	of_node_put(reset_node);
 	return err;
 }
 

-- 
2.55.0

