Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D332D8DD6
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707146; cv=none; b=Js+u7QrkPmCqTQwNaeY6H6UVL7olqw7idPXZX1bFVqYujBschGkJy/Kw/Mo04+pp6k0BmCPv92vBl8eAuU4gpezVfsMF9XYI2vWNGer7GFxJv/ti2Bdpgi1ypolZcQvn+uQMrdR/YFuoTGhvvkLVxtWAafwTwl2hI0Ovoow/cTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707146; c=relaxed/simple;
	bh=Ps8ei+v2R0NLXq9LdTBRfMNULQo/CQqgcpEmd++eYFo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YxA+CPu7qav5e4UMdBLopaIYYuLBCTTraYb+e1hDX8f1yWSpqjsX+RPmIcMu2WQ7sMSR/XZ8GSAQ3w7s8APmLAQbb95EbMrpaKNDa/YcJ9bHOThIO2tq+XJfamE8cOygxO8Y+zIXvZob9vdaEt8tLjpvvaK6rNO8FSp7GadLXtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZeHZbcEv; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZeHZbcEv"
X-UUID: 351f03ba992b11f0b33aeb1e7f16c2b6-20250924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=j6HX2TtKgTRoakZD0tE6W91kVtZ62DR9MqHoUCCxcGo=;
	b=ZeHZbcEvgsEjNBy0CFX/GNoRZ+LUtgVpHfqSXPX+j5sdght51o+2iuoeRJuRDaiv9jtnSPLaRsbTp8hw6AG/8nwIhUTyFZMRLXCq9RmU0YtF+rCjjLEVhMM5aHzE5cs4BHo5HRmBODbnOy+5fJYcJHtgYAraUmhiFggdEYn6lMc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:e40368c9-419e-4a9d-ac56-12b06aace2c7,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:1ca6b93,CLOUDID:a0dca3f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 351f03ba992b11f0b33aeb1e7f16c2b6-20250924
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1465005810; Wed, 24 Sep 2025 17:45:30 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 24 Sep 2025 17:45:28 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 24 Sep 2025 17:45:28 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2 2/8] ufs: host: mediatek: Adjust clock scaling for PM flow
Date: Wed, 24 Sep 2025 17:43:24 +0800
Message-ID: <20250924094527.2992256-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250924094527.2992256-1-peter.wang@mediatek.com>
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Adjust clock scaling during suspend and resume in the UFS
Mediatek driver. Ensure that the clock scales down during
suspend if it was scaled up, and scales up again after resume.
This adjustment maintains proper power management.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 009031fee744..0622b7b32e51 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1774,9 +1774,11 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 	ufs_mtk_sram_pwr_ctrl(false, res);
 
-	/* Release pm_qos if in scale-up mode during suspend */
-	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up))
+	/* Release pm_qos/clk if in scale-up mode during suspend */
+	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up)) {
 		ufshcd_pm_qos_update(hba, false);
+		_ufs_mtk_clk_scale(hba, false);
+	}
 
 	return 0;
 fail:
@@ -1804,9 +1806,11 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (err)
 		goto fail;
 
-	/* Request pm_qos if in scale-up mode after resume */
-	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up))
+	/* Request pm_qos/clk if in scale-up mode after resume */
+	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up)) {
 		ufshcd_pm_qos_update(hba, true);
+		_ufs_mtk_clk_scale(hba, true);
+	}
 
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_hpm(hba);
-- 
2.45.2

