Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5990C2DAFA0
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918077; cv=none; b=QzuuNhKWGz7RxcadrCTSJscwrNlXrAJXPsi5gnE8t2U0lm9mCFGkVok/8FgA5HvMvKHCtqzwbXPH7H+s8XkUMtNWVf6OnQT6ltiPngGBZphe1T5FNXpruxyVtqZMZz6iC/eBgkIjC3EHWXVt1zRJ3v57IG/hvF1vMUP0DaJzPqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918077; c=relaxed/simple;
	bh=CmFgAZm65SUUaN63aS50MDtyJqiN4Ls8yIVIz9vb3HI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mSHKrTpNqk0DWW/4Zu5ercHgsXnDkhNv+ZvKxZO6L0gQCODbEVDYKCmSDeOYqeEHVJE2HhlsJFy3mN9yKPKWR+AC31khxGRAA1bE9INudxPtZ1eQYu1U7fwVg6fGHB/CPEMXLeG37uTJbrJ++xGjq/1+q/VyP2atkBto/B7qCsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=koOBXkXZ; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="koOBXkXZ"
X-UUID: 1b7352ba76b511f08729452bf625a8b4-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=0U7WXC3SmAyoXuFVjoEaiQcznGfmIvYEkSXnf8K72EU=;
	b=koOBXkXZ+vCUlm1QUv2Tx1OdYDVxAcaa6VMLWlxW4GStFyMzxn8xCHyz0Xx/bFm+bFePzP91JpADcwFe2xHwtwRo57HaSDjMdZAtHtHdLGourlDVx9p0Ld7XiXsQ57ocdawDa2AF0zgdkKyWlAITDKD8Ks1iz5ih5VKqWb+jGqI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:09fcebdd-9e63-457d-a4f8-84209954cf2f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:6adb4fa1-1800-4e4f-b665-a3d622db32cf,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1b7352ba76b511f08729452bf625a8b4-20250811
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 164765861; Mon, 11 Aug 2025 21:14:27 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:25 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 09/10] ufs: host: mediatek: Change reset sequence for improved stability
Date: Mon, 11 Aug 2025 21:11:25 +0800
Message-ID: <20250811131423.3444014-10-peter.wang@mediatek.com>
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

This patch modifies the reset sequence to ensure that the device
reset pin is set low before the host is disabled. This change
enhances the stability of the reset process by ensuring the
correct order of operations.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 6db75683bbe8..ae458c4a7a46 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1543,11 +1543,11 @@ static int ufs_mtk_device_reset(struct ufs_hba *hba)
 {
 	struct arm_smccc_res res;
 
-	/* disable hba before device reset */
-	ufshcd_hba_stop(hba);
-
 	ufs_mtk_device_reset_ctrl(0, res);
 
+	/* disable hba in middle of device reset */
+	ufshcd_hba_stop(hba);
+
 	/*
 	 * The reset signal is active low. UFS devices shall detect
 	 * more than or equal to 1us of positive or negative RST_n
-- 
2.45.2

