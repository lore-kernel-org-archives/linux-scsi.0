Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC0A34BA2A
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 06:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759906636; cv=none; b=YZHLMuolOl4T/+q/dTJ0b2AJT89YJArbz+ihHITd+2ySzK2g7nG0NGPuLDrP87Fhbqe4+XwqmvhFldw3nN0136S805HP7wo57/TWOSB4bABD1XUbMBV5TbUa7P0qAdNzw/cHO/WDyPeG/1yTO5VxAl5/dIoGcs84G0QbsiBiriE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759906636; c=relaxed/simple;
	bh=BDBjMcfjukFfrjs4nsMtfdQ/F29OTnOfTdd5MTmRaFM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z90BS7hkJG0FQn13pBxhk0J6YBtyUt+tHsN76JHbihYrPcWcvUyoRNcc/HliA32KBqcwLZYpoQGNJMY4/Cz+smAac9pUBr5j2HIRTQLaUkEnDwVOpalfWIVDcb8EbehfLUT4DKXhP1cgqGYZkkn6JZh0ttWQ2f0JfRfC/T/Rs9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VM/N3IV0; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VM/N3IV0"
X-UUID: 01fa21e2a41411f08d9e1119e76e3a28-20251008
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=G76w+kFPdmOMA0cCRispGE38I+sLsfDMcB6m6OpGKpc=;
	b=VM/N3IV0aAv/KHYt6FHVjd2IxotH9tGvIFScqAgdzE82zm9/UXKtm+bCKvzU1cBXX06JA34ckFF5rEBGTwjdPkIiK0k6lJWJIAtMIbgZnzZknzNPsxiuYdWvlBNlflDc6dfUJOy6yzmE0PsOLYRQ1wdXAJ321YJyllRe77y1b1U=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:d85a915f-2696-4073-b3d3-4a3b6141080e,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:1502eb05-56ed-4a2f-9417-82fff695211e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|888|898,TC:-5,Content:0|15|5
	0,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 01fa21e2a41411f08d9e1119e76e3a28-20251008
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 337326083; Wed, 08 Oct 2025 14:57:08 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 8 Oct 2025 14:57:06 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 8 Oct 2025 14:57:06 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<qilin.tan@mediatek.com>, <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>, <dan.carpenter@linaro.org>
Subject: [PATCH v2] ufs: core: Fix error handler host_sem issue
Date: Wed, 8 Oct 2025 14:55:43 +0800
Message-ID: <20251008065651.1589614-2-peter.wang@mediatek.com>
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

Fix the issue where host_sem is not released due to a new return
patch in commit f966e02ae521. Check pm_op_in_progress before
acquiring hba->host_sem to prevent deadlocks and ensure proper
resource management during error handling. Add comment for
use ufshcd_rpm_get_noresume() to safely perform link recovery
without interfering with ongoing PM operations.

Fixes: f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error deadlock")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8185a7791923..ff7a3d60b11d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6670,6 +6670,20 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
 
+	/*
+	 * Use ufshcd_rpm_get_noresume() here to safely perform link recovery
+	 * even if an error occurs during runtime suspend or runtime resume.
+	 * This avoids potential deadlocks that could happen if we tried to
+	 * resume the device while a PM operation is already in progress.
+	 */
+	ufshcd_rpm_get_noresume(hba);
+	if (hba->pm_op_in_progress) {
+		ufshcd_link_recovery(hba);
+		ufshcd_rpm_put(hba);
+		return;
+	}
+	ufshcd_rpm_put(hba);
+
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
@@ -6681,14 +6695,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	ufshcd_rpm_get_noresume(hba);
-	if (hba->pm_op_in_progress) {
-		ufshcd_link_recovery(hba);
-		ufshcd_rpm_put(hba);
-		return;
-	}
-	ufshcd_rpm_put(hba);
-
 	ufshcd_err_handling_prepare(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.45.2

