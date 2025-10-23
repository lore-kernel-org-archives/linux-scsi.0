Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53AE34DB5C;
	Thu, 23 Oct 2025 19:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249184; cv=pass; b=lQbNVM3lVDmKZYHrSy2GvMnDgxtIgsFL4frC+EVe+e1x6iOPQ7jTcqYrgJMV3+1poqMcLFSk/tRq6GAq6LU9bSeNKOxXhYYbHOZSUBFrVpakkF3KsSLusakc6VWjmDYl+1/2Syq9rv++shpaBlH4mthgYJVLKyzUIDzxbgCA8v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249184; c=relaxed/simple;
	bh=O02uzN9yjf1RGvGRKLeJ4SraHanlFlEJnAnE16WVrsw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AYwzQf0QD0FTFpUfvGOmdQNOgFOS2wzuhdqqbePZHdLvlhgDZYkcEHbLus15Tt+6Tzmgb06qDr/edKPr7UNL3zXBb1f8+BHpR2W2Iis7SNxdm5nL3BPuh+/kTaXXfNlExlOPjGhQg9ajowRqEl1jf/kstIfUBfOSpgK5f2FTUXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=SSWhn1m5; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="SSWhn1m5"
ARC-Seal: i=1; a=rsa-sha256; t=1761249150; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OvSSNLHStUlrCORQ9PchBe6O40+m7u6B/rckCMgFy0eHwNA27p/khkj3ToOxtAqHZUx9NNYAvts7gMz+13f0zbYP/vaA7VwiqFhY9KJS/VO4YaQLWGrD915tRZp8CZL/dkWD5E+GHBFNzE3CK1lZJIEEE2mAi9JReGqV5472tWM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249150; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=jOfAQy6zSU9ALbpL1BWUFEG7xOjI+5Wynrtljel5J2E=; 
	b=f44fxNE2GKwvoB360EzCyCi8e3JJTg0V5MnAFe2XrfasWO0mWqCg8D4OOX3VDf0en7GstPozmmwbuii86Wu81nzA5SX+uJ4jQBg5wMOkmCTtsehPuL0J/+cx5o6pyJdmladw8LjffqNU+Ykz2Ug65BlUPcfVkXcp4M8tpLKum9E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249150;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=jOfAQy6zSU9ALbpL1BWUFEG7xOjI+5Wynrtljel5J2E=;
	b=SSWhn1m5RDIPEWeXMnuakcnTctbnXu6PjKtibIJBDa2adzOH0oDZBaG2hFICID5q
	8VpMhqflL7gBeijxRiKoLr1mpEf+SaIPzo0SRHQScjs6PjB5T1XxpchDcDAzke5DEDb
	lxKk/HQRx0mYz63SgVMsOcy2Cp8tCs1XA797Up0g=
Received: by mx.zohomail.com with SMTPS id 1761249149624289.98114903850785;
	Thu, 23 Oct 2025 12:52:29 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:40 +0200
Subject: [PATCH v3 22/24] scsi: ufs: mediatek: Make scale_us in
 setup_clk_gating const
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-22-0f04b4a795ff@collabora.com>
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
index 38698fbbd228..5f5ebaf61ae0 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -940,10 +940,10 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 {
+	const u32 scale_us[] = {1, 10, 100, 1000, 10000, 100000};
 	unsigned long flags;
 	u32 ah_ms = 10;
 	u32 ah_scale, ah_timer;
-	u32 scale_us[] = {1, 10, 100, 1000, 10000, 100000};
 
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		if (ufshcd_is_auto_hibern8_supported(hba) && hba->ahit) {
@@ -951,7 +951,7 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
 					  hba->ahit);
 			ah_timer = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK,
 					  hba->ahit);
-			if (ah_scale <= 5)
+			if (ah_scale < ARRAY_SIZE(scale_us))
 				ah_ms = ah_timer * scale_us[ah_scale] / 1000;
 		}
 

-- 
2.51.1.dirty

