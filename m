Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AAE32692D
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 07:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770707925; cv=none; b=bmZfbAY2xDwlon2CQVG09kLiPS07xdwhNrLBWRJmt2PCrax5/ujJRRvrKSN9RlaY/zDUnjhY7oCMJxoOQcPmhL9JpcQpGWuOkU4++wzdqHRP+ufJU+pmX5ODeplwUSIAKFoKlRt+D7UTYklyqcUq6U3TvuGUfoEvim9mSOz7moY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770707925; c=relaxed/simple;
	bh=/Ug4mETlRHeEEb0fCPboXPc+NsFtKnj8yI8LADuQR58=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hqJebp+gH93hwShB+ctDmTY1ZfwHP7HzE8USnarZR7fYDXlxsKwc/7G5ScSKQRrOtjAbYcgRdFT5bbDR1ZO21qzgHZsc5tWDxGlgUfmLowzxIIXD2aB1cu7EscTX37JMMyh3bKaBwtR9ZN002HevTCdH9V7xDMvJ1EcJNcqykR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=B9BMjaJI; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="B9BMjaJI"
X-UUID: b7a4f758065011f1b7fc4fdb8733b2bc-20260210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=+xmc0FC3pvGrjmeYLsIfeCCZfgwjBH2I7Ows6bFhFk8=;
	b=B9BMjaJIcO4OYRb9amEy67RMoeU/CVTo0rJmTZ9OEGgwflR7fUR3pjgi8rv9AXw9NnIxnXrM6KP/fUe4qwAG2iWMVeYD8cCtm5/EDJx7t5sGFJkHk6uecw4tnY/9iJczbOfqj6JVcn2Huubde7uASljbA5SZYYZINlVTXXM7DEs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:6033180b-a032-441f-acf2-dba4ec378c66,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:0a7f215b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b7a4f758065011f1b7fc4fdb8733b2bc-20260210
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2072605427; Tue, 10 Feb 2026 15:18:37 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Feb 2026 15:18:36 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 10 Feb 2026 15:18:36 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v2] ufs: core: support UFSHCI 4.1 CQ entry tag
Date: Tue, 10 Feb 2026 15:17:30 +0800
Message-ID: <20260210071834.1837878-1-peter.wang@mediatek.com>
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

The UFSHCI 4.1 specification introduces a new completion queue(CQ)
entry format, allowing the tag to be obtained directly.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufs-mcq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index ad0ada57959a..a4d0f8834314 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -273,13 +273,18 @@ void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i)
 EXPORT_SYMBOL_GPL(ufshcd_mcq_write_cqis);
 
 /*
- * Current MCQ specification doesn't provide a Task Tag or its equivalent in
+ * UFSHCI 4.0 MCQ specification doesn't provide a Task Tag or its equivalent in
  * the Completion Queue Entry. Find the Task Tag using an indirect method.
+ * UFSHCI 4.1 and above can directly return the Task Tag in the Completion Queue
+ * Entry.
  */
 static int ufshcd_mcq_get_tag(struct ufs_hba *hba, struct cq_entry *cqe)
 {
 	u64 addr;
 
+	if (hba->ufs_version >= ufshci_version(4, 1))
+		return cqe->task_tag;
+
 	/* sizeof(struct utp_transfer_cmd_desc) must be a multiple of 128 */
 	BUILD_BUG_ON(sizeof(struct utp_transfer_cmd_desc) & GENMASK(6, 0));
 
-- 
2.45.2

