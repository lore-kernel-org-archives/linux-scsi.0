Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7679713B58D;
	Mon, 24 Jun 2024 12:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719231132; cv=none; b=WHjUtuxmAlBj23pugpnykGjh22t43Pm/7TzWbb8ycE/q94VoHI/8Vtbo8+whHN4mzlGq4h7e4yXbVvjKpcFhwfFHJGkMVeaK34te/qex4KzY/9PDsIECSCPf1Mce9iC4n93/vyfpw3P/knJbJS/JWDKyQ4bDbSzEwmG9bO9OgUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719231132; c=relaxed/simple;
	bh=csxvwcEGX8Jgl/BPH4QmAJFpyauXRgyOqljB6Rkjhe8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jPIHWVObp/m2e+/51lX4PkbYgk2kVxvNqz8XnvjPwD9sFCW7pISUVuy8jRldboyN67L4dEdZ6QrYwNvSP56PSDsAXdf5DE1YKmTK8XCcYgeyTST0M6F4Qlyhz2i8GmDxyvDacfUETvN/yk88+vmgUKVzj5cPwt3k4Up5F4r7BaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=p+2l7ZXV; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="p+2l7ZXV"
X-UUID: f7969528322211ef8da6557f11777fc4-20240624
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=i2jYQbB2j4nvENCVMGA7xPeqY9+B3KTTX1K9D7GjK/Q=;
	b=p+2l7ZXVIg3tACqu/QVPy/Sg01/o9DcmRMtheNNpEwN/1cGg8rgabb4UB2ErNq8k7UTXvGZgO27z8xUs6OV8NOo/TkeL3HriXjX4huFlq5rxQ/K+kwt93EAlH2tJHQOVdqmBzv7Ewg8NYg2DVqMvAWkPMNc/M4sAkU3IynO9X0c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:f8fa26b5-1831-4773-8bea-6f75f2d9ba37,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:393d96e,CLOUDID:1a755e94-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: f7969528322211ef8da6557f11777fc4-20240624
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 132791005; Mon, 24 Jun 2024 20:12:03 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 24 Jun 2024 20:12:00 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 24 Jun 2024 20:12:00 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <quic_nguyenb@quicinc.com>, <alim.akhtar@samsung.com>,
	<jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
Date: Mon, 24 Jun 2024 20:11:58 +0800
Message-ID: <20240624121158.21354-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--12.315100-8.000000
X-TMASE-MatchedRID: SAABl2Xm4hsMQLXc2MGSbEKcYi5Qw/RVFJFr2qlKix/FJnEpmt9OE34U
	OBQdfZJqNhxcj7T04bO1ONGFQGwumuV35K+BqYWNGVyS87Wb4lx+tO36GYDlsk04B0iWfKSh+oA
	N6qKcRV8Sz/bGxf+BBtuTkfZxmWFnrRlLslggfyruykw7cfAoIEo8jH4wkX2j31GU/N5W5BBYua
	/kyrSLK1MqZVuLxgGS393jXWrWwbiR9GF2J2xqMxRFJJyf5BJerSFs54Y4wbX6C0ePs7A07cNbT
	FVOzjU8cJKtxUrql0U39SUJmeP8pNTl0N+pk8qbWQEZREt3xE0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.315100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 9F8D39E9FF3C2E9EFF60B4303561EE1B8BFAEF490EC8E7EFB0F6C9599AD520ED2000:8
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

  ufshcd_try_to_abort_task: cmd pending in the device. tag = 6
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000194
   pc : [0xffffffd589679bf8] blk_mq_unique_tag+0x8/0x14
   lr : [0xffffffd5862f95b4] ufshcd_mcq_sq_cleanup+0x6c/0x1cc [ufs_mediatek_mod_ise]
   Workqueue: ufs_eh_wq_0 ufshcd_err_handler [ufs_mediatek_mod_ise]
   Call trace:
    dump_backtrace+0xf8/0x148
    show_stack+0x18/0x24
    dump_stack_lvl+0x60/0x7c
    dump_stack+0x18/0x3c
    mrdump_common_die+0x24c/0x398 [mrdump]
    ipanic_die+0x20/0x34 [mrdump]
    notify_die+0x80/0xd8
    die+0x94/0x2b8
    __do_kernel_fault+0x264/0x298
    do_page_fault+0xa4/0x4b8
    do_translation_fault+0x38/0x54
    do_mem_abort+0x58/0x118
    el1_abort+0x3c/0x5c
    el1h_64_sync_handler+0x54/0x90
    el1h_64_sync+0x68/0x6c
    blk_mq_unique_tag+0x8/0x14
    ufshcd_clear_cmd+0x34/0x118 [ufs_mediatek_mod_ise]
    ufshcd_try_to_abort_task+0x2c8/0x5b4 [ufs_mediatek_mod_ise]
    ufshcd_err_handler+0xa7c/0xfa8 [ufs_mediatek_mod_ise]
    process_one_work+0x208/0x4fc
    worker_thread+0x228/0x438
    kthread+0x104/0x1d4
    ret_from_fork+0x10/0x20

Fixes: 8d7290348992 ("scsi: ufs: mcq: Add supporting functions for MCQ abort")
Fixes: 93e6c0e19d5b ("scsi: ufs: core: Clear cmd if abort succeeds in MCQ mode")
Cc: <stable@vger.kernel.org> 6.6.x
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

