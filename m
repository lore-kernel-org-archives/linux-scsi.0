Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0D51607AA;
	Fri, 23 Aug 2024 10:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724407638; cv=none; b=aQul3PS//ZQFtiqa0YZ0dnINlnJ5MM8tpKtrN+6eq4yd4fpOpZw16CFMmnRhXHG9phGXSh0xRk/XsazG/ALVM71x/NR/KYqqeOa5I+Ud2NBG9OX5bI+m5Yk5+V3T1UhFta96T1RFOer3AiGP+TySUvsr+wjLupO8QjRL3RjP9dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724407638; c=relaxed/simple;
	bh=GDu1Dmo0obYx3kikcXFy8nHInWtzJqBpUs5HH2QE9LU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TdTAAI3BdCz7LQY3uc+INV+npxw+QQVCTKFn1wCyzvxN625vZ+qI6Fggk8kson1qAn/zwzLOCsBHIGy4wQ4Qo8jPNMYFK7XuXi8xJhMiCyhiuTPCVwILS8kuzh3KjgappVbu+Dxhv2L1XacCxnvr5+2/GDktA3uS6yhuN+UntVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nilores/; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nilores/"
X-UUID: 754c3796613711ef8b96093e013ec31c-20240823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Q/hVDi5QlE7twKetiUuJWI0sQsaizIXKv/4S0mRRLMs=;
	b=nilores/ifgJbNFLNxbKyTOBmGeCFx1zggzRJSGOv6FHouMlwV4tDrOmqSi4oG/+M3mqVY+F2wR9Qd9NQwR+MRYRvfoXVkEl1BCnXkR/CQsdj2MIcgCjaoxnHYgLKSnGdiG+0C2ZX01TWl8l6macYjIzJehzOcfFz5BTWRHY+nU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:547aa801-8c89-4273-a212-66417edc1500,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6dc6a47,CLOUDID:ecb411cf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 754c3796613711ef8b96093e013ec31c-20240823
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 805658517; Fri, 23 Aug 2024 18:07:09 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 23 Aug 2024 03:07:09 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 23 Aug 2024 18:07:09 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH v1 1/2] ufs: core: complete scsi command after release
Date: Fri, 23 Aug 2024 18:07:06 +0800
Message-ID: <20240823100707.6699-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240823100707.6699-1-peter.wang@mediatek.com>
References: <20240823100707.6699-1-peter.wang@mediatek.com>
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

Below is error log
[   14.183804][   T74] ufshcd-mtk 112b0000.ufshci: ufshcd_err_handler started; HBA state eh_non_fatal; powered 1; shutting down 0; saved_err = 4; saved_uic_err = 64; force_reset = 0
[   14.256164][   T74] ufshcd-mtk 112b0000.ufshci: ufshcd_try_to_abort_task: cmd pending in the device. tag = 19
[   14.257511][   T74] ufshcd-mtk 112b0000.ufshci: Aborting tag 19 / CDB 0x35 succeeded
[   34.287949][    T8] ufshcd-mtk 112b0000.ufshci: ufshcd_abort: Device abort task at tag 19
[   34.290514][    T8] ufshcd-mtk 112b0000.ufshci: ufshcd_mcq_abort: skip abort. cmd at tag 19 already completed.

Fixes:93e6c0e19d5b ("scsi: ufs: core: Clear cmd if abort succeeds in MCQ mode")
Cc: <stable@vger.kernel.org> 6.6.x

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0b3d0c8e0dda..4bcd4e5b62bd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6482,8 +6482,12 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
 		if (!hwq)
 			return 0;
 		spin_lock_irqsave(&hwq->cq_lock, flags);
-		if (ufshcd_cmd_inflight(lrbp->cmd))
+		if (ufshcd_cmd_inflight(lrbp->cmd)) {
+			struct scsi_cmnd *cmd = lrbp->cmd;
+			set_host_byte(cmd, DID_REQUEUE);
 			ufshcd_release_scsi_cmd(hba, lrbp);
+			scsi_done(cmd);
+		}
 		spin_unlock_irqrestore(&hwq->cq_lock, flags);
 	}
 
-- 
2.45.2

