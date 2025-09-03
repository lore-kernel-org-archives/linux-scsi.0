Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54371E7660
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 02:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756867610; cv=none; b=HMskxAPZwvZBVt1dD6KMfCM/nRVnNKyIYFFeK7yMBh5DINNhz/5VpUur9f4b9iHUA57IrIAjAlgrcc+/MRG4TcLbRu6JmPw65+o98LFbxpSNqZc2pyl+Kolj/YNCO3neW9zNuvSKIhzgF8pDFhZkeD8KJWNkpBkwoe9/yVzzCtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756867610; c=relaxed/simple;
	bh=OW2jfFd6YwX+lGQ7BWRjGCjeQEomPqKuli9Sd5kudUo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IuQ5khBR9pYt68RvUFXSUvcDfdVXDBfT3ysu+1u1KkrsAI/IIuatFF/Q8U4uoAFsWZO+RiXsoNJ6PB7Mbma4/i7usZlcLzcFXxBsNbTQGJMuMkBf2uKMpeaGaoO9ZTSoj26gwJXrSu759UUjQC0iOzhuKf/U/ggfqqGchVX1Dkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=s56hETQx; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="s56hETQx"
X-UUID: 353ed094887011f0bd5779446731db89-20250903
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=yJM3QRWKwghijxAxoB1xIHPf6yU3QVHxPDn1YFn/kYQ=;
	b=s56hETQx07y5djvFWDoQkVmu952usiN+a0ETEc/K+oSnEfF9HF36ma01QzbBFaeMpx3daJl3M2OvZRu/XLl89pQq/xIQlMKIt48/qe8miFORnrShyIOvTYV9w3PlFE5nC+9ddiKCC44Z5QKRToEnosnzYID/WNBqgYDqpGcK2bk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:fd149aa8-9b36-4182-9712-3804cf4d0559,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:003b5f84-5317-4626-9d82-238d715c253f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 353ed094887011f0bd5779446731db89-20250903
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 191011099; Wed, 03 Sep 2025 10:46:35 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 3 Sep 2025 10:46:34 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 3 Sep 2025 10:46:34 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v3 10/10] ufs: host: mediatek: Fix device power control
Date: Wed, 3 Sep 2025 10:44:46 +0800
Message-ID: <20250903024631.496693-11-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250903024631.496693-1-peter.wang@mediatek.com>
References: <20250903024631.496693-1-peter.wang@mediatek.com>
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

Adjust the timing of device power control to ensure low power mode
(LPM) is entered only after VCC is turned off. Prevent VCCQ/VCCQ2
from entering LPM prematurely, ensuring proper power management
and device stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index af5574ac0b3c..758a393a9de1 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2342,6 +2342,13 @@ static int ufs_mtk_probe(struct platform_device *pdev)
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

