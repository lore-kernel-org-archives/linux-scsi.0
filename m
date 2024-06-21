Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C37172BDC
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 11:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718969466; cv=none; b=Bet2R7VcuuV7qVt8EGXQy5Bm7I/CueUnw9KB70yf/+GzsuOMFP8i6hTuOZtfBxvJ0+vr8tk9KeRFFdg4NgLHuGbnLWpI1W7OKCWWxD7mBnJBowA+43M1vd5if6MtUkHS+L0Trx2rhsGJsRRkMQ+mbA8raDCQqyBua6ZSe7Ls29o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718969466; c=relaxed/simple;
	bh=blqHO2beB6JS3Q9ujKshe+t4Z1TH6f5Q/GgMxK2Ma9o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pe+8AxV3Sxelz74o9Rh0mpoOHNgNuRraDif02ZMboB72rk+9paBv2CRcC61YkU9XknRiJFL1sDy62iGnz+fl4NyLhQmask95WSF26k3MqBEzu2cniocejmb4lWmC1bp3yVxNL9saBP0/XaGmGnZ48noAH4ca7NIMqnr9rLbcMBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DIBWxHUZ; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DIBWxHUZ"
X-UUID: b9a0c6d42fc111ef99dc3f8fac2c3230-20240621
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Jx3ue8Ar3TfZ8NOq5r90AdDZ1RkmWQmSLiAuCfau2zY=;
	b=DIBWxHUZzgXVfVnsUFYXuktW+2fRI5eXDIyByHTUQQk3RUK4XBojT1gvezFDEJqc/4oG9auh7yBhuRqpJU6pLMWJfqrOy31ZGPO5lTx5oMtkYKo4MYmtPcBPSCx+yQ6Q9aelCB96hztWvmcpOBGatXScYKkxDOaM35ErNesF7bw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:2a8dcc5e-c336-4924-a934-56cacbbbb8f7,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:393d96e,CLOUDID:5a69df88-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: b9a0c6d42fc111ef99dc3f8fac2c3230-20240621
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1798723162; Fri, 21 Jun 2024 19:30:56 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 21 Jun 2024 19:30:53 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 21 Jun 2024 19:30:53 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: [PATCH v1] ufs: core: fix ufshcd_abort_all racing issue
Date: Fri, 21 Jun 2024 19:30:51 +0800
Message-ID: <20240621113051.29523-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--12.140500-8.000000
X-TMASE-MatchedRID: B6j6C829dRoMQLXc2MGSbEKcYi5Qw/RVFJFr2qlKix/FJnEpmt9OE34U
	OBQdfZJqNhxcj7T04bO1ONGFQGwumuV35K+BqYWNGVyS87Wb4lx+tO36GYDlsk04B0iWfKSh+oA
	N6qKcRV8Sz/bGxf+BBjB+UUO5j2rBb3gilrWi3GiQOktEo73GFFV+08YFNHSuw01zN1c0miKta8
	DXVXWIqS/rjK1CMnpugDLqnrRlXrZLA5JD98yI6t0H8LFZNFG7bkV4e2xSge4yADhXDNGAIQ2iQ
	dawUz6dGwR9SxBnBcu95FVNTq1SdLAUyUg9ogFt
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.140500-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 4BE08DA094D3E70E7AA5F455192B14E04C44E67A2A183599B6F75E2299A121B02000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

When ufshcd_abort_all racing with complete ISR,
the completed tag of request will be release by ISR.
And ufshca_abort_all call ufshcd_mcq_req_to_hwq will
get NULL pointer KE.
Also change the return value success when request is
completed by ISR beacuse sq dosen't need cleanup.

Below is KE back trace.
  ufshcd_try_to_abort_task: cmd at tag 41 not pending in the device.
  ufshcd_try_to_abort_task: cmd at tag=41 is cleared.
  Aborting tag 41 / CDB 0x28 succeeded
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000194
  pc : [0xffffffddd7a79bf8] blk_mq_unique_tag+0x8/0x14
  lr : [0xffffffddd6155b84] ufshcd_mcq_req_to_hwq+0x1c/0x40 [ufs_mediatek_mod_ise]
   do_mem_abort+0x58/0x118
   el1_abort+0x3c/0x5c
   el1h_64_sync_handler+0x54/0x90
   el1h_64_sync+0x68/0x6c
   blk_mq_unique_tag+0x8/0x14
   ufshcd_err_handler+0xae4/0xfa8 [ufs_mediatek_mod_ise]
   process_one_work+0x208/0x4fc
   worker_thread+0x228/0x438
   kthread+0x104/0x1d4
   ret_from_fork+0x10/0x20

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufs-mcq.c | 5 +++--
 drivers/ufs/core/ufshcd.c  | 9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8944548c30fa..3b2e5bcb08a7 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -512,8 +512,9 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 		return -ETIMEDOUT;
 
 	if (task_tag != hba->nutrs - UFSHCD_NUM_RESERVED) {
-		if (!cmd)
-			return -EINVAL;
+		/* Should return 0 if cmd is already complete by irq */
+		if (!cmd || !ufshcd_cmd_inflight(cmd))
+			return 0;
 		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
 	} else {
 		hwq = hba->dev_cmd_queue;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e5e9da61f15d..e8bca62ceed8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6455,11 +6455,12 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
 
 	/* Release cmd in MCQ mode if abort succeeds */
 	if (is_mcq_enabled(hba) && (*ret == 0)) {
-		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
-		spin_lock_irqsave(&hwq->cq_lock, flags);
-		if (ufshcd_cmd_inflight(lrbp->cmd))
+		if (ufshcd_cmd_inflight(lrbp->cmd)) {
+			hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
+			spin_lock_irqsave(&hwq->cq_lock, flags);
 			ufshcd_release_scsi_cmd(hba, lrbp);
-		spin_unlock_irqrestore(&hwq->cq_lock, flags);
+			spin_unlock_irqrestore(&hwq->cq_lock, flags);
+		}
 	}
 
 	return *ret == 0;
-- 
2.18.0

