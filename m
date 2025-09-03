Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0363594B
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 02:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756867602; cv=none; b=U1qpJN4ORhl5Z6dDaImIb2ZWp0cN8TOIOQ/I8Q+sBfiErjXO+279wZTh/74I1+aVvTdLL0VohWBIESEK2JLp2NJFGYh90es8cAxHiPZnbFsM4s9qVx+trweTbGapylkxbJX1Fl/TP/BaQJL9gzjk7bOgXz/h3phgNKT1I9r/NYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756867602; c=relaxed/simple;
	bh=6EIXJTh3kzq7903GlLMaJZBm7h7VxIkESzkdtsHtui0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FfWX8dwHBp412RbhRiYdJqx+SZD3Ibkgzzb+Vs338A9lbgTN2WpxREUwsTaNp8E8hBk5qLK8Lev6WsIa0Ar9k4mhjZkxPEG4nkjbGq1lGGvz3JpBzMQ77//VjIevNa4UbCmvcFKs27dYGJXXTJWQ9GdQloMwtpe2lNUpURdsg1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hIr9ECUp; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hIr9ECUp"
X-UUID: 34514716887011f0b33aeb1e7f16c2b6-20250903
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=n8Sk9E5xxC+u5KW0G+aJVwdsBx1/UGEZqh0DMzeAFrM=;
	b=hIr9ECUp6/ciUF+9xsTvaPQVHS/ENVu8g5GKYNtiHrZm5WVXnuCtn4XxrFDDqNxAO+icJpfbJ8UbaPo5S9CDbtVxS0EMOaKusnq2D/oo9gZgPm2Cor3qOuW3uunj/B2MANBoKITUt6pZCsdJNhFwcxxv1svGjxUcPQ5k1bkkF4E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:4b60aac2-15bc-4cec-942f-34f738a2c168,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:1efee1f7-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 34514716887011f0b33aeb1e7f16c2b6-20250903
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1384267657; Wed, 03 Sep 2025 10:46:34 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 3 Sep 2025 10:46:33 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 3 Sep 2025 10:46:33 +0800
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
Subject: [PATCH v3 02/10] ufs: host: mediatek: Enhance recovery on resume failure
Date: Wed, 3 Sep 2025 10:44:38 +0800
Message-ID: <20250903024631.496693-3-peter.wang@mediatek.com>
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

Improve the recovery process for failed resume operations.
Log the device's power status and return 0 if both resume
and recovery fail to prevent I/O hang.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 1aa14a8dc161..6d25110c8cb8 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1775,8 +1775,21 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	return 0;
+
 fail:
-	return ufshcd_link_recovery(hba);
+	/*
+	 * Check if the platform (parent) device has resumed, and ensure that
+	 * power, clock, and MTCMOS are all turned on.
+	 */
+	err = ufshcd_link_recovery(hba);
+	if (err) {
+		dev_err(hba->dev, "Device PM: req=%d, status:%d, err:%d\n",
+			hba->dev->power.request,
+			hba->dev->power.runtime_status,
+			hba->dev->power.runtime_error);
+	}
+
+	return 0; /* Cannot return a failure, otherwise, the I/O will hang. */
 }
 
 static void ufs_mtk_dbg_register_dump(struct ufs_hba *hba)
-- 
2.45.2

