Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441D036CE1E
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 05:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772775868; cv=none; b=ss3GMfy8AaHZcWJqdK6g5nzUOCGKlei0u2nENZ1izElrr+atyr6I3QbhDysMF3lnX/UQsHijpY9DTfmApxmtS01UgRgTbeBI4MDRqWA2DPulntcZTvrQjRzTqBj6QyKmRL1JdNNx7DzQLDpZvYfd8pKvRReB0wtGsEWbAdb8JkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772775868; c=relaxed/simple;
	bh=2Boi1tvIT7g4zA13W5JR7fZyCOZPDWEJjMQdzO2ijfQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TBRRGKkbslahaIYE2UFxljg7CtwQhvZiRqvit+ROqVr3UJ/9xnUPDCx3tCp7D6oEkL65L2mVYcyYiVcWI7QaWgFzytZtz0iK2ciD1tm6YL9Z6dMjLwGT25xUhHtl7lEeT3n1GsCNGdUuxfMyTID8btmE2bsQK9cCFrp4IUBFoDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=pHpZsTp+; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pHpZsTp+"
X-UUID: 86c3a2ec191f11f1a02d4725871ece0b-20260306
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0dlhYLj8ZPQDL/ivichbm7Abi/77rG55s+eXIdgghzw=;
	b=pHpZsTp+5by2g999wbCEIMWtynj0WLat7RYbTiWCtSjmzHo7K4WLkiZyPOIklpX6T+rMTDdYITMZrwx6JGefl0Ih2zfQfOvGvrA0tDNuOSGbflGxZxmfLNpI9/gbwrMj1dnH1cKPAt0xzbwFPzEqgnXjl5eZ+cHb6hM2vsun5CM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:936492e8-47f7-4d14-831e-a99ccbdc66cf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:ce00967b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 86c3a2ec191f11f1a02d4725871ece0b-20260306
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 970707673; Fri, 06 Mar 2026 13:44:22 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Mar 2026 13:44:20 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Mar 2026 13:44:20 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC command
Date: Fri, 6 Mar 2026 13:43:02 +0800
Message-ID: <20260306054419.3816557-1-peter.wang@mediatek.com>
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
and no UIC command is active. The default UIC command timeout
is 500ms, Using threaded IRQs during an active UIC command
increases the risk of timeout due to possible preemption
by other system IRQs.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9908375b2f98..6554e1db3343 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7200,8 +7200,12 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	struct ufs_hba *hba = __hba;
 	u32 intr_status, enabled_intr_status;
 
-	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
-	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
+	/*
+	 * Handle interrupt in thread if MCQ or ESI is disabled,
+	 * and no active UIC command.
+	 */
+	if ((!hba->mcq_enabled || !hba->mcq_esi_enabled) &&
+	    !hba->active_uic_cmd)
 		return IRQ_WAKE_THREAD;
 
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-- 
2.45.2

