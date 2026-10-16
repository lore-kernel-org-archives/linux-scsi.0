Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D9049E5E8;
	Fri, 16 Oct 2026 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154037; cv=none; b=rxLU6jRArw/P4bOVeT8g2Fr0sX8aCrScK86iHHHeD8vfsWv2cr9l2UwwJ76QW6zUwVJQcUpULDZXYwZ97EXuAsvPDS0uEPGezD66eLPXu1KGpm6WJU7ywHtWr9ZaJPfUZVRBdaaWX7TyBQ/1hIurT/4cLYdjKEYdLXwKmcJ6fMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154037; c=relaxed/simple;
	bh=qhQj/W2FGJgVcnuSv1mvjlMbghrB/T2Td5HFXiF2ezE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cqXnwBuy32At8dEKU18mxES6wdQJVn7OASrWCQl5OQyl5KLNtPpRRrO8FckiSsinp6cnJsehgzoivTOtMWrdZuatVbl9hJPj268CCrJ0zz5dUo95y2LX5BSaKHATIcR5wJtEAzRiWQxAf0rSzV6qKhm5xWwV7ssY05wdXZtP0z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=DL4VM8+k; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="DL4VM8+k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792154033;
	bh=qhQj/W2FGJgVcnuSv1mvjlMbghrB/T2Td5HFXiF2ezE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DL4VM8+kOY+LyeNE5p3YtmDgtVcJYebF0pxR9sO6X0yH+ttFb1xfO4McJhRUU4pBx
	 /dEPhem1bT6/ysaR8FKPKsTo7W9hpBuO7sJTLlwGuXSO5x8qMaViUWXdqac2DXcBRs
	 NnrG7hkT5zTKADJ8tKGLyaFDvPysb6iZDvXujl5F+9bzx6u/pen6lE8+Dm1fdhJfkl
	 YmM3fLmSOjCirCCoH+Kq0EzqrrzAMDboQ9BTJZV56DES8zRCNHWBPh7a5Tgw2/7do6
	 EAa++Bq9SUoJMQiTpPRa4IEo7+J44ZjPsdAQQfSs/dESLnkp2vkAuRNiEHCCzj99sU
	 hjcWzj7WidOGA==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EA91D17E12B9;
	Fri, 16 Oct 2026 14:33:52 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 16 Oct 2026 14:33:13 +0200
Subject: [PATCH v14 21/23] scsi: ufs: mediatek: Remove ret local from
 link_startup_notify
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mt8196-ufs-v14-21-e8d565e0cd45@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792154009; l=1411;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=DTFoP4zj9jE4qTNyeHA3Vmefd9hRDOsT3YaWpVSzdiM=;
 b=Ok+XjieiGDxP983TlQjzezzsvGowIj1LQwXVx6ewSDrXI6oXk5Nl3jyp8Uiu56VrpY9ykI3+O
 j3+wKaBLpcmDSoxHnDwafkSnevcgxY3CibCSiyYSJqJjV7Rg/lZeWoZ
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Remove the "ret" local variable from ufs_mtk_link_startup_notify, as
it's pointless; in all cases it is assigned, it is returned right after
without being read first.

Rework the code to just return directly, and get rid of the default
branch while at it.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 328df4521a02..760c1ebd53bc 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1579,21 +1579,15 @@ static void ufs_mtk_post_link(struct ufs_hba *hba)
 static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
 				       enum ufs_notify_change_status stage)
 {
-	int ret = 0;
-
 	switch (stage) {
 	case PRE_CHANGE:
-		ret = ufs_mtk_pre_link(hba);
-		break;
+		return ufs_mtk_pre_link(hba);
 	case POST_CHANGE:
 		ufs_mtk_post_link(hba);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
+		return 0;
 	}
 
-	return ret;
+	return -EINVAL;
 }
 
 static int ufs_mtk_device_reset(struct ufs_hba *hba)

-- 
2.56.0

