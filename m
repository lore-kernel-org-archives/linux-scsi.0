Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82AD2DAFA7
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2025 10:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756117111; cv=none; b=DxCTfEBW1Lz+su3Z2NDLvAUOznL4jmaoDQ0zwZIbrr491W/jFtUCeg+stdahq223Gst9D6/dbItTDU1chjdNJxfNUCs9hDVlK+vGA065Wc86QTkE0KbqQNyAl5oXfHhXBMdzbv+GZWNCMvNO7hpFYW7nBEx3YknVVnVYRr5dhDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756117111; c=relaxed/simple;
	bh=mBiMmgcGtqqBLay7Ym7qX5Yct6as8fLvrqpzmfn6l34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dwymDK8eNSPdkEc6MSxYTae+ZYOYz1sAwxrYMdc/ee6achbwau6w1bnMRpN6LQtKIxeAbLcis6cRtts5fV/xXYDjzTO8SQ4EAqF8Do2u6cCj0URHbKDExRzWegIerddGXX1GuNx8chqHJtGAtUlX69i6S3nT2hXYwYAQcGnfHbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=l5+WW/H/; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="l5+WW/H/"
X-UUID: d22d066c819c11f0b33aeb1e7f16c2b6-20250825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Qfdw/ITjmzYWjnbBfZz/Vd8i7s8q+zphrbs5bJAlP88=;
	b=l5+WW/H/kO/oddV0XW46L503Mw5EU+2aLgoQIGQbCPANB08Kuno5TMuUzWIHcwiFb2dLO7U9FW2Vc3VK9YfDr3r/cYbQzNyc+CUl8JIscvIHyZljcEmK8wxsw5rZBYB5qj7FxTNvP/OCTL8qoZPoMxPzudz7CDNekNbG+58UctA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:4ad68ace-54d8-4bee-a4e6-0792087b2f2d,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:038bd744-18c5-4075-a135-4c0afe29f9d6,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d22d066c819c11f0b33aeb1e7f16c2b6-20250825
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 695420744; Mon, 25 Aug 2025 18:18:18 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 25 Aug 2025 18:18:17 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 25 Aug 2025 18:18:17 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>
Subject: [PATCH v1 02/10] ufs: host: mediatek: Enhance recovery on resume failure
Date: Mon, 25 Aug 2025 18:10:10 +0800
Message-ID: <20250825101815.2891905-3-peter.wang@mediatek.com>
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

This patch improves the recovery process when a resume operation
fails. If both the resume and recovery fail, it logs the device's
power status and returns 0 to prevent I/O hang..

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3882bcc85305..d396878cc9a4 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1780,8 +1780,21 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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

