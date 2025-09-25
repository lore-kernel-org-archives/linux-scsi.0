Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B52EA464
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 10:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795871; cv=none; b=PDIYAcZuQ1fBDR9Nbnzo7Tig7UA8G8u6qZ5COZULAm8fyfUGCMEElFa4wOSnuwlMLU+zxWdA9lwyGBLeUWAR45fxGybIFQsaBZOQvpVR9gQf7b18+29eoMJsCFGx+wp5YQlOXBjSeqlj2fV8RooNsx78izq+JtNH3YGAtmENRHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795871; c=relaxed/simple;
	bh=VjT9Yascm7HCRW44tlxab+bewcYfi/9WyD+5ReGVf2s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ejBXCNdifvAEx0+UWW1hEyWOlIQXMjkicP7PpilwIww5Olh1lfNDSgPelPeidEb6PvwYIeWYfqx3qEde1l4oHFpvJy5+jyRGJ7VgXpwUeiezn6F9ejd0GcmUFjyoYRproc3CacyEj9lXUzdx9MIotvCFRPTRQtk9ENoJRh4TVfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DTq6BLCP; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DTq6BLCP"
X-UUID: cdc3e72e99f911f08d9e1119e76e3a28-20250925
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=t6Yl0F3CBWt6RVv26a4kHnOE9hsWbU7MfM6c5bWgKbk=;
	b=DTq6BLCP1HkzNeYg4mHf7lnhRJpm9WZvG1gouUffmA4/WKEYz7RslTvB/KQQoHaP+dMpBGzKhZxqW1bAKCjda/1Cxi83ooScLZYBLDKOKjftesQ593o3i7yotQmOiqa6Z/PZ31ndIugCZg1cBY/TMUfgKbQFzrLMUNKB0Yx2Ecw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:1b3f6fcf-6531-483c-9655-448731c80de2,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:12ecef6c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|888|898,TC:-5,Content:0|15|5
	0,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cdc3e72e99f911f08d9e1119e76e3a28-20250925
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 943721817; Thu, 25 Sep 2025 18:24:22 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 25 Sep 2025 18:24:21 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 25 Sep 2025 18:24:21 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2] ufs: core: Fix runtime suspend error deadlock
Date: Thu, 25 Sep 2025 18:22:25 +0800
Message-ID: <20250925102420.3553715-1-peter.wang@mediatek.com>
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

Resolve the deadlock issue during runtime suspend when an
error triggers the error handler. Prevent the deadlock
by checking pm_op_in_progress and performing a quick recovery.
This approach ensures that the error handler does not wait
indefinitely for runtime PM to resume, allowing runtime
suspend to proceed smoothly.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 88a0e9289ca6..8185a7791923 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6681,6 +6681,14 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	ufshcd_rpm_get_noresume(hba);
+	if (hba->pm_op_in_progress) {
+		ufshcd_link_recovery(hba);
+		ufshcd_rpm_put(hba);
+		return;
+	}
+	ufshcd_rpm_put(hba);
+
 	ufshcd_err_handling_prepare(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.45.2

