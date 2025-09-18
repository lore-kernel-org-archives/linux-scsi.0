Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF811B394F
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192018; cv=none; b=CsSWQckEGLMyokJ1tqCJ8M5rf5kVAdnqBUqFFKJp4+ml6rgjqyai3T2LCT7+1LqjB/wbnbve56iD5JyGlDiD537W7b8grBioF+x4oWAKHPTdMPZgliHC4UnY+E7DNP62oTw2ylYgy2IpSgl2Nrw0uJM2RtqZD8VEtpd44s0eGBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192018; c=relaxed/simple;
	bh=GFcdX+RfWHQtnPtLf2PNSn4IA51VjLEGzcuxiK2n06g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NoNS2eLP9RR2E7lUA1bWyB/2odzDqHr1XHdG2jeSqicwpNpuEyIfNHQXsQeW/9lGeRGLka0mOr8OYdSuuqnp4mviJggydiNHKWF0/XnSJ9dGSxxvWnoJ9gZr3CDGUdBeG+GpwMRuzNm6so5UAvc7PsP4v/2qgZTAzQL6GQ4Ig+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=pN2o8eZS; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pN2o8eZS"
X-UUID: d60baa4e947b11f0b33aeb1e7f16c2b6-20250918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=dLaU06h1GKMNAiOkoLHMFT9Embuo7qYZ2D2vfkwmpWg=;
	b=pN2o8eZSz1lD8oV26XnAJ9BItdab1SWVrWolFBiCSme1sz3yGRMr8BkFYjrkhZJf8FKxyUHrXkYRmAzMDsvMn9vi5ZDbI4Hy8j7azjfBBDkVZ9lnm52s+jol7wVYHrlSYDyOwu7UQ9F2LnoALnjOn1jWPRU4Jk9xC4tdXDQBaZc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:6129935e-325c-4593-8619-352b51484517,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:b8fd1891-68e1-4022-b848-86f5c49a6751,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d60baa4e947b11f0b33aeb1e7f16c2b6-20250918
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1474271614; Thu, 18 Sep 2025 18:40:04 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 18 Sep 2025 18:40:03 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 18 Sep 2025 18:40:02 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 04/10] ufs: host: mediatek: Handle clock scaling for high gear in PM flow
Date: Thu, 18 Sep 2025 18:36:14 +0800
Message-ID: <20250918104000.208856-5-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250918104000.208856-1-peter.wang@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
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

Add clock scaling down for power management flow in the UFS
Mediatek driver. If clock scaling is disabled and fixed in
high gear, ensure the clock scales down during suspend and
scales up again after resume to support high gear.
This adjustment maintains proper power management.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index f445bc720a5e..d9026a9afe17 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1784,6 +1784,9 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up)) {
 		ufshcd_pm_qos_update(hba, false);
 		_ufs_mtk_clk_scale(hba, false);
+	} else if ((!ufshcd_is_clkscaling_supported(hba) &&
+		    hba->pwr_info.gear_rx >= UFS_HS_G5)) {
+		_ufs_mtk_clk_scale(hba, false);
 	}
 
 	return 0;
@@ -1816,6 +1819,9 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (ufshcd_is_clkscaling_supported(hba) && (host->clk_scale_up)) {
 		ufshcd_pm_qos_update(hba, true);
 		_ufs_mtk_clk_scale(hba, true);
+	} else if ((!ufshcd_is_clkscaling_supported(hba) &&
+		    hba->pwr_info.gear_rx >= UFS_HS_G5)) {
+		_ufs_mtk_clk_scale(hba, true);
 	}
 
 	if (ufshcd_is_link_hibern8(hba)) {
-- 
2.45.2

