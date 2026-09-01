Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C405E485CEC;
	Tue,  1 Sep 2026 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277192; cv=none; b=epDaYOTYfEaK/Gp0QQEnMxzAdwk5Py+qGOHkki2IMUWQJU4lRbuMTUjSmtFK27zwCxanlYCKM9f3VIA3pKwBD7U1ky9T3S2XwC1kQwpXdVz3u7wPTxBW8NTr3ALDhMnkjATRNnDwwOtHqHd1IM4PAhp2GQqFje3x28xPgmuKXCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277192; c=relaxed/simple;
	bh=yHYnZo9thDOybBolptJrfbVmNYQ8QaDOG2QmCxd3Q+g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iUZQOUpBWXv7XfSdkjjS8CALwSIV+phwigDSzoGkNpXtvrzxg8ky1qwkPoE6WtywCBuFVnuSnZ1uuFbNzfrkLHFyxian2cs2ZisjMtjrEQ6gf8GaBDF6iwSP1QsvuwDhMkUqnuuG/Ls7MehQXYSVW4ZMcIaqbnvhAogEBALgFiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=GU2fCD9R; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="GU2fCD9R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1788277188;
	bh=yHYnZo9thDOybBolptJrfbVmNYQ8QaDOG2QmCxd3Q+g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GU2fCD9RsYiU9hZMCjolF+iwNaEFIv5Rnh52DgFrsTaFprci5nYgwkH9xA8PgF7U/
	 u4gI3+9jHclDh5URPhaw3morFXY75GYBCzfNnsV2j0Au3DdV+G37E6A0xxinKpc5NE
	 BnhpwigKD1VCytAT0gZDTOhEV1OM5bRDbe+kugL6gAQAogoiBd4cccYaP7VW3ucX6D
	 9hFnpoMGa8BNm3ayviNGA/eizKBVvTd2GZmLkz0tpTGpKw07rjqSFYCFDGYPySUenb
	 3UXKyFfdGZBMz0Iwb+bwCooWV2XT53i4ooUsQ4RpZzwwoyqUknaj2w0t3LtQYX1jZ3
	 ag1baM/+ZU+XQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 035E117E10BE;
	Tue, 01 Sep 2026 17:39:47 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Tue, 01 Sep 2026 17:39:10 +0200
Subject: [PATCH v11 22/24] scsi: ufs: mediatek: Remove ret local from
 link_startup_notify
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mt8196-ufs-v11-22-dbd007704490@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788277164; l=1411;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=zpGKpq9Sjjpc/u30yTDEw/7TjoEnEL+HJGQ6bVDYcwU=;
 b=iWlT9fFLfgFjDWoVdKpsrOoZzhy2kdDfUlHuJ7CF7YbKJKp3HKMkyJT5/DvvzNm9ZhMP/pwoj
 IRHrCcPkD/LB5pgzzGcwJDeITYvcvZXTJLWYoss0LU3d/+aOYBIeiOC
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
index 4782fdf54866..bcde58e3aee8 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1543,21 +1543,15 @@ static void ufs_mtk_post_link(struct ufs_hba *hba)
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
2.55.0

