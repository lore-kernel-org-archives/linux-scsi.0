Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E060175BF;
	Fri, 23 May 2025 10:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747995104; cv=none; b=dExL8IYdgHW5tsC2vzQNCUnIT7ta2ec5PS+WIHHVMk0J6EgclE40CDfIluQJx5ssxQNy02jeamauRNCV6UYP2uP2rOFARrGdS0HPXas5bcmqVZtvT3v2JQOJgbTX6d+9BirL1A9AeFN8+ylnZjif2p9zlN3ZDzGqWg46GVa8h6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747995104; c=relaxed/simple;
	bh=AQehsrbWL7uVfxeqw0y0mpcVuztmCAsak93tdGOxGM8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p4CcK/cPwSGa/kbceQfkmRGtZIvsqP7hSIVZVZ/5vSsUPsZUubdqQOgsGxxfACX9kPCpqg9cJodKGwxP93k/jyVXtZO2wBu2zfJxxmPEYc7Ycvgi0DJ4wCzId9fyfWDUBlDYQdgAjGZD8alM58eyzE5buEICdAi4Ys7ZCoMgzVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=sPuMG2Sr; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sPuMG2Sr"
X-UUID: 4faff8b637be11f0813e4fe1310efc19-20250523
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Y4tw7qmJ3jSvvoRbf0zUM7ZRt2Sjeuu4sfQXYus+jSY=;
	b=sPuMG2SrFHnAkvWaCugRz5veb7BclODgAlRZjoF2fTDL3huBBTQQzS9mPo9YhNKC4BRtHInlzx/jVgpCcI0PoZryEsHHoxeA4lj0OR87cCCJFjgAfCbWKeP7PS7CNViIrjpgUdM0MILLng3+GqPwOHXpyJYghPgysj0Q7i+2/ao=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:505dcdb8-4dc6-4a51-81fc-9775172f044f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:69eca647-ee4f-4716-aedb-66601021a588,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 4faff8b637be11f0813e4fe1310efc19-20250523
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <naomi.chu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1359594943; Fri, 23 May 2025 18:11:36 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 23 May 2025 18:11:34 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 23 May 2025 18:11:34 +0800
From: <naomi.chu@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>,
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: <wsd_upstream@mediatek.com>, <naomi.chu@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<chun-hung.wu@mediatek.com>, <cc.chou@mediatek.com>,
	<yi-fan.peng@mediatek.com>
Subject: [PATCH 1/1] ufs: core: add fatal errors check for LINERESET
Date: Fri, 23 May 2025 18:10:34 +0800
Message-ID: <20250523101041.3615819-1-naomi.chu@mediatek.com>
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

From: Naomi Chu <naomi.chu@mediatek.com>

The current error handling flow directly checks the power mode after a
LINERESET occurs. However, if a PA_INIT_ERR occurs after the LINERESET,
checking the power mode may require waiting for three DME_GET timeouts,
which wastes 1.5 seconds.

To improve efficiency, when a LINERESET occurs, wait for PA_INIT to
complete and check for any other errors. After a LINERESET, PA_INIT
takes up to 75.4ms to complete. Therefore, a 100ms delay is added.

Signed-off-by: Naomi Chu <naomi.chu@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7735421e3991..c7cc62429fc9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6359,6 +6359,46 @@ static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
 	       (hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
 }
 
+static bool ufshcd_is_linereset_fatal(struct ufs_hba *hba)
+{
+	bool needs_reset = true;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	if (ufshcd_is_saved_err_fatal(hba)) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto out;
+	}
+
+	/*
+	 * Wait for 100ms to ensure the PA_INIT flow is complete,
+	 * and check for PA_INIT_ERR or other fatal errors.
+	 */
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	msleep(100);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	if (ufshcd_is_saved_err_fatal(hba)) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		goto out;
+	}
+
+	/*
+	 * PA_INIT_ERR on the device side will not trigger UIC
+	 * error interrupt.
+	 * Send NOP to check if the link is alive.
+	 */
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	err = ufshcd_verify_dev_init(hba);
+	if (!err)
+		needs_reset = false;
+
+out:
+	return needs_reset;
+}
+
 void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 {
 	lockdep_assert_held(hba->host->host_lock);
@@ -6655,6 +6695,11 @@ static void ufshcd_err_handler(struct work_struct *work)
 		if (!hba->saved_uic_err)
 			hba->saved_err &= ~UIC_ERROR;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		if (ufshcd_is_linereset_fatal(hba)) {
+			needs_reset = true;
+			spin_lock_irqsave(hba->host->host_lock, flags);
+			goto do_reset;
+		}
 		if (ufshcd_is_pwr_mode_restore_needed(hba))
 			needs_restore = true;
 		spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.45.2

