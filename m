Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6776A158557
	for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2024 10:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727259119; cv=none; b=t+/nCEBlAozwHX2/NRE3kXFz4D3QBU/QlYZBXRWI4dhwXnRgvA45amf31SjSADfpq+fsKe0VIjD2aoyHZdM6mzBRqtjrx9YgZpha/nxXX58EqiWp8x+z1EFpdU5wZC1tevzfOoYOfDbgA0ptEeKC7wCxI14koB+q/JpQ/WYWl5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727259119; c=relaxed/simple;
	bh=2tS85xO8NlwJO7HA7gzbDEun9PIIt97c8yfc0lMNgRk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QeKi5HW1JxJEhEEEY08GhY6esNUQCTvjx2jLkKwtBEcGjqLtNwRGM/0VXuL4Mc98LGNqvyDtpMwo8t0s+8W6KGwovC57/4Dk5G5KdN6MNkb7/RIFYytMnMxvvG5lxNvYYRtAeo5Y6VM5te9ibPbCC55W2Pr/ZbtMC71VsSwhQaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=f7iP6xL+; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="f7iP6xL+"
X-UUID: 93e063227b2611efb66947d174671e26-20240925
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Fm8E4wlpRggBTCT5LOsARIN/XWw2DmG3o9deh+e7oDQ=;
	b=f7iP6xL+USbYojvJpF69kre6j8VsVQVHVK8DQ0jJWpf1hJ1g6BOdG1I6tVPXOtjZu7NtbKDCNlOt2FL8ihuAc/qfa1D9LF9NCWgnQQctaWmyQ4eK1otlCr7ZQP6jSUiUYL5wWSwJsPJSz3bURTqUnVXtIhAixqVekXHrTj28YxM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:7c3c37df-d913-42cb-bfeb-599eebcdd071,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:a5913b18-b42d-49a6-94d2-a75fa0df01d2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 93e063227b2611efb66947d174671e26-20240925
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2041453358; Wed, 25 Sep 2024 18:11:49 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 25 Sep 2024 03:11:47 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 25 Sep 2024 18:11:47 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<quic_nguyenb@quicinc.com>
Subject: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
Date: Wed, 25 Sep 2024 17:55:45 +0800
Message-ID: <20240925095546.19492-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240925095546.19492-1-peter.wang@mediatek.com>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

When the error handler successfully aborts a MCQ request,
it only releases the command and does not notify the SCSI layer.
This may cause another abort after 30 seconds timeout.
This patch notifies the SCSI layer to requeue the request.

Additionally, ignore the OCS: ABORTED CQ slot after MCQ mode
SQ cleanup. This makes the behavior of MCQ mode consistent with
that of legacy SDB mode.

Also, print logs for OCS: ABORTED and OCS_INVALID_COMMAND_STATUS
for debugging purposes.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a6f818cdef0e..4fff929b70d6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5405,9 +5405,15 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 		break;
 	case OCS_ABORTED:
 		result |= DID_ABORT << 16;
+		dev_warn(hba->dev,
+				"OCS aborted from controller for tag %d\n",
+				lrbp->task_tag);
 		break;
 	case OCS_INVALID_COMMAND_STATUS:
 		result |= DID_REQUEUE << 16;
+		dev_warn(hba->dev,
+				"OCS invaild from controller for tag %d\n",
+				lrbp->task_tag);
 		break;
 	case OCS_INVALID_CMD_TABLE_ATTR:
 	case OCS_INVALID_PRDT_ATTR:
@@ -5526,6 +5532,18 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			ufshcd_update_monitor(hba, lrbp);
 		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
 		cmd->result = ufshcd_transfer_rsp_status(hba, lrbp, cqe);
+
+		/*
+		 * Ignore MCQ OCS: ABORTED posted by the host controller.
+		 * This makes the behavior of MCQ mode consistent with that
+		 * of legacy SDB mode.
+		 */
+		if (hba->mcq_enabled) {
+			ocs = ufshcd_get_tr_ocs(lrbp, cqe);
+			if (ocs == OCS_ABORTED)
+				return;
+		}
+
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
 		scsi_done(cmd);
@@ -6486,8 +6504,11 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
 		if (!hwq)
 			return 0;
 		spin_lock_irqsave(&hwq->cq_lock, flags);
-		if (ufshcd_cmd_inflight(lrbp->cmd))
+		if (ufshcd_cmd_inflight(lrbp->cmd)) {
+			set_host_byte(lrbp->cmd, DID_REQUEUE);
 			ufshcd_release_scsi_cmd(hba, lrbp);
+			scsi_done(lrbp->cmd);
+		}
 		spin_unlock_irqrestore(&hwq->cq_lock, flags);
 	}
 
-- 
2.45.2

