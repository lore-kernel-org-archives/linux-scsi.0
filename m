Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807AB2C0F87
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2025 10:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756117109; cv=none; b=rWq1McWB1+yixS8+U8U2BOlgoCr2HQCAI5dupq4AWC5vXS548TN88FNAiuhGuZ7X/k5icwNT40Ag0+APVm4LyGS5MRHPERejBdvM8ofgr2e3uB44B3zCE7x3qN4DTrfEPxZ48rur6qk8lchO3QoW8VTLY2MaHFPMfYHC0n8w7hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756117109; c=relaxed/simple;
	bh=CPCb/83qHJT9ksFQJDpvBQSc1eXq1kiijPDzya3sSis=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLO6l5E57mgLUYZyB7M/A36rNwi6vD8ZQUAmx03gw+xkhOl+we37DUGBZPqZmeRbuzOVktEUIPkT/d36NT2hdlCk1sJo3CXBGXxJ07QjAfvz5SVrHnydLgwkCd7jwz9NXF82CtYmHlq+BpJAbZ/10moEqcnrGr5Db79y3UJER0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IXfeBvTc; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IXfeBvTc"
X-UUID: d2d8522e819c11f0b2125946c7b33498-20250825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=HjCkHVOhsLCDp6N1cKFvox0iWt1EEMUjcHsCDxPK9mQ=;
	b=IXfeBvTcO25Kf1yEQQ5BJ0ECdoRfcnCDEUj+63rtUEjNwUs7jkVfAnhrOIewsHoOHZixU/9e8JxLGESSS9ZTW22EhfagCHBM2rQ8pBMg9Q0LmQZEJidRakwabV1Q3oYCBtWLAeQ12ySSBhLpN/jyBRqbhzc0kQ7aOYtwwJeQSSU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:de8e90ed-9462-4496-96bf-c5e764e03505,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:18e47f7a-966c-41bd-96b5-7d0b3c22e782,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d2d8522e819c11f0b2125946c7b33498-20250825
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 573725188; Mon, 25 Aug 2025 18:18:20 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 25 Aug 2025 18:18:18 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 25 Aug 2025 18:18:18 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>
Subject: [PATCH v1 10/10] ufs: host: mediatek: Fix device power control
Date: Mon, 25 Aug 2025 18:10:18 +0800
Message-ID: <20250825101815.2891905-11-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250825101815.2891905-1-peter.wang@mediatek.com>
References: <20250825101815.2891905-1-peter.wang@mediatek.com>
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

This patch adjusts the timing of device power control to ensure
that low power mode (LPM) is entered only after VCC is turned off.
This change prevents VCCQ/VCCQ2 from entering LPM prematurely,
ensuring proper power management and device stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 934c643633d3..ec45a40f04d0 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2347,6 +2347,13 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 		host->phy_dev = phy_dev;
 	}
 
+	/*
+	 * Because the default power setting of VSx (the upper layer of
+	 * VCCQ/VCCQ2) is HWLP, we need to prevent VCCQ/VCCQ2 from
+	 * entering LPM.
+	 */
+	ufs_mtk_dev_vreg_set_lpm(hba, false);
+
 out:
 	of_node_put(phy_node);
 	of_node_put(reset_node);
-- 
2.45.2

