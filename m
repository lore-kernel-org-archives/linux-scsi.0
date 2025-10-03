Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945AC1494DB
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 10:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759486294; cv=none; b=pspDRh5esXHMkgfknZl1jkOs5gfWOGtwGdOJ+HW2G8m5e4NRMOXkX8+IOkvxTfV2k9CD5SF70hKNY3H+aFhQA1SLNMWpN9aKwIBjw9zw1AXC0lGekYHNvCDo5lKFU+wOg+EIwn8QSLi8O9rHtffa4bU14nxol4fI27ZhwB4PerM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759486294; c=relaxed/simple;
	bh=WUE1HmARz7jFiNBR1mKcM7sXMw/IFiLX0088daOdO0U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j6Ttz4M+4pzb9VR3Qi6u642Ower9egOYhtsT04P8ITEbpYLCVIU5Ltgd5wR0w8gMJbcvh+BSi9+eXMAxlKScm7vOj8VqyeHJUL+AID17Y7Hv2qug17zEqH91E3OEzVLipGtAP4MXINVxbAKdGr+enFMyFuXhkE5gTPuQgyFu9Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aFjQ+8+K; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aFjQ+8+K"
X-UUID: 4de03eeca04111f0b33aeb1e7f16c2b6-20251003
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=rCWTJ5R2NCNypQCi7Ufs3WBbi/2erjgrmQN0rSx0Sy0=;
	b=aFjQ+8+K23QQagfDMzyJdeFAjFRVrCFh2a+pZWYhnFZ2f8O/0nKESEDyCWe4rTitAmTNL+2AhNHneZ5dOc+t9xzDuuPA+HbNcXsidTYQTI4s38rm6I5TGVEIhfGiUne/WHoWaVu+7PRTN0Xyt1kQdm9Uhf5eADByULzEiKtrXtU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:96c30518-1b64-4ef9-ba68-0d9783d38e3d,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:9d30f4f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|888|898,TC:-5,Content:0|15|5
	0,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4de03eeca04111f0b33aeb1e7f16c2b6-20251003
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 28348752; Fri, 03 Oct 2025 18:11:18 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 3 Oct 2025 18:11:16 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 3 Oct 2025 18:11:16 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<dan.carpenter@linaro.org>
Subject: [PATCH v1] ufs: core: Fix error handler host_sem issue
Date: Fri, 3 Oct 2025 18:10:29 +0800
Message-ID: <20251003101115.3642410-1-peter.wang@mediatek.com>
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
path introduced in commit 'f966e02ae521'. Move the check for
pm_op_in_progress before acquiring hba->host_sem to ensure proper
semaphore handling. This fix prevents potential deadlocks and
ensures that resources are correctly managed during error handling.

Fixes: f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error deadlock")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8185a7791923..9b1207dede64 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6670,6 +6670,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
 
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
@@ -6681,14 +6689,6 @@ static void ufshcd_err_handler(struct work_struct *work)
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

