Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8508A2D46A9
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918077; cv=none; b=cy3o9tjNL1BvWwzqnrrd1c5lZwNPFTgHB3uWG+RO1cvuuMxTi7KHOg93eVUMtSjSjkuz/4qJ0NkhFBZ6CqnlNKWdEx6dcyj5AgXmXSjxzKrdhLI4Xzuwak8Hpin/TPZRl/qVndzQi6O9nxPxGcjeMX9IY7NdKD+CYvkqj+YcXU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918077; c=relaxed/simple;
	bh=teiVehO4llrDWi9u8454Y18bOwUwm+MI73UQmgsvc7o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=svU67cctfnFnpbdkv9w/Z7hOYynHidKGDouDA3f6KZpYTi6vKulJL5bV/6vdpcF8dgmA/Sbko8Z1ORfRmIvP/P4gHc2iXz1fADCZgfMdU328acmt+IaoL4EP9AQbJdqmEi+HBL2YOxhTwAAKarWmzX6yD22iIBxzKgWqQDi2K1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=lxLsqFfR; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lxLsqFfR"
X-UUID: 1ac1124e76b511f0b33aeb1e7f16c2b6-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=R4ByMA2i57dW91+nFyI17BlRwhij8fMihptY17VG9Kk=;
	b=lxLsqFfRLtGMYpnisF2TktO6ZNpxgmWv0Wd4KhkBIweqWvQgSSNA750CJnZakyoCazf3rtR5/L5GvAa6BqEgDUAjiIXgo1/gC+GTbewOm6y/A3sU2xpr0cbxp6OQqCn6U67xtf9gpNFUoZn5BYVIxxnKSCpxaZG7UFF4DuOe76k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:9d9e37a6-8f07-4796-b6e6-8a34c2433c41,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:7da549ce-1ac4-40cd-97d9-e8f32bab97d5,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1ac1124e76b511f0b33aeb1e7f16c2b6-20250811
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 503807780; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:24 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:24 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 03/10] ufs: host: mediatek: Add debug information for Auto-Hibern8
Date: Mon, 11 Aug 2025 21:11:19 +0800
Message-ID: <20250811131423.3444014-4-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250811131423.3444014-1-peter.wang@mediatek.com>
References: <20250811131423.3444014-1-peter.wang@mediatek.com>
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

This patch enhances the clock gating logic by adding debug
information for the Auto-Hibern8 (AHIT) register.
This additional logging aids in troubleshooting by providing
insights into the AHIT configuration when the clock is not
turned off as expected.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3e661494fbb6..3d50cd3a01b3 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -798,8 +798,14 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
 				clk_pwr_off = true;
 		}
 
-		if (clk_pwr_off)
+		if (clk_pwr_off) {
 			ufs_mtk_pwr_ctrl(hba, false);
+		} else {
+			dev_warn(hba->dev, "Clock is not turned off, hba->ahit = 0x%x, AHIT = 0x%x\n",
+				hba->ahit,
+				ufshcd_readl(hba,
+					REG_AUTO_HIBERNATE_IDLE_TIMER));
+		}
 		ufs_mtk_mcq_disable_irq(hba);
 	} else if (on && status == POST_CHANGE) {
 		ufs_mtk_pwr_ctrl(hba, true);
-- 
2.45.2

