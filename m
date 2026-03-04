Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2C62AE8D
	for <linux-scsi@vger.kernel.org>; Wed,  4 Mar 2026 07:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772608444; cv=none; b=owRXLKf28JFgnZ8/PJz8VEc4s2bzb1BgP09/Ap4IOBhjnSWpnhHRFhjvgFOtazMYTXIY3X1tziiiIKJTJ1/ZvH7DE3dpcYuFZeqaN5Sh+C3PrC2+IBo+0FMcexvr3bdrGXBPs1X2Ng6qplhJiDhoZ2BWgKi8kwV8TN12oqqvSs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772608444; c=relaxed/simple;
	bh=ghq81Jeuvoq11zxI6QY6VqoYA7W6aGrsOGBSVh9fhhw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dURR7+rxfqghScIu2qe4FJzXoi8j4oaa3ba1im6t9+U6O8gMhNbS+//AXc7Vuc9PTPsWyYa84LpYK775ZBAU478WXmyXBiLvMihDxCjJNXsLX7EIi+YWRZr38vnqarvDDUvHBemoaLsPYfUWwqiiUjH79x5c0hsnBjDKOrvE6AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QmTY9Zs5; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QmTY9Zs5"
X-UUID: b1981b06179911f1b7fc4fdb8733b2bc-20260304
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=eGCFx++2VzGehtBzmKmti7W4IMXs0RaEEqoTklgLkF8=;
	b=QmTY9Zs5Ogr5rsM6HYlIUgwAqK6YR+arqXVaNaeHLHLQaZ17KpTy5Lfl5qVMJ6taqkNyS0Kkyt08QR0a8GL0XQ+g0MN4IPVVbTjjUP0qgM7U7F2cTX086Ldgkt2sV2LjhdBrJ4ckxoS0x6l6ndM9zXh2hqRhgZrWkNGkAegsFqo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:c0c211cc-07c3-465f-934b-5a80d472813c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:082c3ef1-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b1981b06179911f1b7fc4fdb8733b2bc-20260304
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 726065777; Wed, 04 Mar 2026 15:13:50 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 4 Mar 2026 15:13:49 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 4 Mar 2026 15:13:48 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v1] ufs: core: Avoid IRQ thread wakeup during active UIC command
Date: Wed, 4 Mar 2026 15:12:45 +0800
Message-ID: <20260304071346.1391315-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

Only return IRQ_WAKE_THREAD when MCQ and ESI are not enabled
and no UIC command is active. Since the default UIC command
timeout is 500ms, handling IRQs in a thread during an active UIC
command can easily lead to timeouts due to delayed processing.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9908375b2f98..3f18c1a39f27 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7201,8 +7201,11 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	u32 intr_status, enabled_intr_status;
 
 	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
-	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
-		return IRQ_WAKE_THREAD;
+	if (!hba->mcq_enabled || !hba->mcq_esi_enabled) {
+		/* UIC commands should be processed promptly */
+		if (!hba->active_uic_cmd)
+			return IRQ_WAKE_THREAD;
+	}
 
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	enabled_intr_status = intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-- 
2.45.2

