Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A6433BBA3;
	Thu, 18 Dec 2025 12:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766062712; cv=pass; b=disa7Ma4hZuXsIm8qhoA1T+5iNzhkaU6S5DRqSsSODOHMa0kN2+/B6LEVmKbfvjH5FzO7IbN0O6M958iCZpyNtGrUoyJM248pouEXou9H4hcCFSpMRxWzWRlRuUyvRhBEOpqClRPKaktdrsIj0IymPNgnYRP8K1nqcPhtgEc5pQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766062712; c=relaxed/simple;
	bh=Rpz+CXC3S5JW0OgBDgIymhXsitMu3vIjmcjR/JEbWdI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g56w0j9p/uqoSNcytyVYDntVGPU5rdluJ7zUq8OpBx2DMwPs+oPQClbr+/hz9OBsiGipuPlKgtUCiUnUJCtWt6DWMO4G/d3LK9NJyZe1LEuXoRBzf9IO5ev/H1wqSs1B5AYOzi+NuP+nVq3lucSODlASZFYBNlNTDhAuEPW7Bhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=cfEBC9wD; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="cfEBC9wD"
ARC-Seal: i=1; a=rsa-sha256; t=1766062680; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JvEh5IYt51YcfOnUcSMdrLkoaEMYgUKu125daH6xH2alpVTUNJvyzJUgGDuoIOk5TT7t+rGFlYDlOZ91EuRez+qbVD7HLN9o9n5s3YepnFD+Qeo8YpB/B18f+4u6MhSLtxNliR8yCXvuCDM+YXp4yLJfmOdagSEur96TXk/S2qQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766062680; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=PwRQjIGkhjDWwlzr0m8u9shXY9S6IfLiEtsbgCw2Q40=; 
	b=QnRj6pZVM0VfzandcLt0O9DbAriFldqNoApNir02fXKWVhcPVUVpTYTVKEdJe6BP+NlbPl+cvEfklnCct7qA5XM4Rxqyfmw0fY9vXh7NJkMRFIlpL2JNxA5+7eMa1jGqot2gcj4AvPW+M6E6hjT6Bb5hYMxtM+yX2AMOSlRqBjA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766062680;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=PwRQjIGkhjDWwlzr0m8u9shXY9S6IfLiEtsbgCw2Q40=;
	b=cfEBC9wD74zkqgD3C+yK0zvONOfkNv8MIekt5xe1lZrrHwbjZisKIe/dCU0X2U0G
	svqJ2jI0ihKuyfZTsn0KItSqUYC04ie10IOdobnKDHrN3KYveoCa2lOF9lmJBgqa76u
	jjpPKObwjzwJdOlF4Qt+SbIJk2vZDhLb/uquzAyQ=
Received: by mx.zohomail.com with SMTPS id 1766062678850418.2281420795334;
	Thu, 18 Dec 2025 04:57:58 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 18 Dec 2025 13:55:13 +0100
Subject: [PATCH v4 23/25] scsi: ufs: mediatek: Make scale_us in
 setup_clk_gating const
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251218-mt8196-ufs-v4-23-ddec7a369dd2@collabora.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
In-Reply-To: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
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

The scale_us values are constant, and should be declared as such. Do
this, and use ARRAY_SIZE instead of a fixed <= comparison before
accessing members of the array, to avoid possible future mistakes.

This results in the same assembly with clang, so there is no functional
change, but it makes me feel better.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 147beb46a447..7c5d30a79456 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -942,10 +942,10 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 {
+	const u32 scale_us[] = {1, 10, 100, 1000, 10000, 100000};
 	unsigned long flags;
 	u32 ah_ms = 10;
 	u32 ah_scale, ah_timer;
-	u32 scale_us[] = {1, 10, 100, 1000, 10000, 100000};
 
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		if (ufshcd_is_auto_hibern8_supported(hba) && hba->ahit) {
@@ -953,7 +953,7 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 					  hba->ahit);
 			ah_timer = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK,
 					  hba->ahit);
-			if (ah_scale <= 5)
+			if (ah_scale < ARRAY_SIZE(scale_us))
 				ah_ms = ah_timer * scale_us[ah_scale] / 1000;
 		}
 

-- 
2.52.0

