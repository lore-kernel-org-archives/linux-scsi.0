Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480C01386B4
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2024 09:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726823215; cv=none; b=iIdYbZB5eiWAG9OdhmWpdzpTgpwQzxTInHNHevZDgxlZoQR3DlOSL0WSdgdRRFSLmR/TKZcyU86y0ZUmfA88tojLdvXwefZU0iI6L2646HLEVYPtslOHmW7aw/e86IUeqOnrEPaESTBHz6uL6GHFO15sfF6NhPhz8sEnO7xjMxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726823215; c=relaxed/simple;
	bh=OMHaUOlg7L84+AcVoFaH3k2Rtrbcpx/q9WA70V8GAso=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PHhKNY2aoeAl+QqhvzEttUg7uvBwLoDi9N0TvTIoHanNd20Mrp6/TY3dMbVIQufjcKyxCFIorkp1l9WaJWCdIpl9GsNiyBY8KB+7t86lEJG2Lz9a8/8NHpuDAZxivQ6iknitKVfS13RgmkSF9Hdw5Z+Wuo4vl+dKITUOLB5KDGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jV4AP/TM; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jV4AP/TM"
X-UUID: a92eeffa772f11ef8b96093e013ec31c-20240920
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=tbwcydwDUBTubr2Um38bHOO3yWTV5YSyXpU3VXJrRXY=;
	b=jV4AP/TMEdlv4hIdqQcfA/p68j+MyJerK6n6klUXhvSR8AgI6Of/aN1Lp1Vzg1IxO0Y02FzvM1EITaEumx6p6wZNntTKg1vwQ8uxHvHiSmrp/QdwwufNXfaputJqlany/vvQ8robDQtU1nKwH0Bx0nNiP/Zk7vaOTdJewHnViyw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:e61533c7-09a3-4961-9aff-ac58165fc0b2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:45ec7fd0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: a92eeffa772f11ef8b96093e013ec31c-20240920
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 384985152; Fri, 20 Sep 2024 17:06:45 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 20 Sep 2024 02:06:45 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 20 Sep 2024 17:06:45 +0800
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
Subject: [PATCH v7 4/4] ufs: core: skip ISR notifying scsi when ufshcd_abort
Date: Fri, 20 Sep 2024 17:06:43 +0800
Message-ID: <20240920090643.3566-5-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240920090643.3566-1-peter.wang@mediatek.com>
References: <20240920090643.3566-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

When a SCSI abort occurs, ufshcd_try_to_abort_task may trigger
the ISR, and the ISR may release the command and notify SCSI
via scsi_done. This patch prevents the ISR from notifying
SCSI to requeue, allowing SCSI to decide whether to requeue.

Below is ufshcd_abort legacy SDB flow:

ufshcd_abort()
  ufshcd_try_to_abort_task() // will trigger ISR
  get outstanding_lock
  clear outstanding_reqs tag
  ufshcd_release_scsi_cmd()
  release outstanding_lock

ufshcd_intr()
  ufshcd_sl_intr()
    ufshcd_transfer_req_compl()
      ufshcd_poll()
        get outstanding_lock
        clear outstanding_reqs tag
        release outstanding_lock
        __ufshcd_transfer_req_compl()
          ufshcd_compl_one_cqe()
          cmd->result = DID_REQUEUE
          ufshcd_release_scsi_cmd()
          scsi_done();

In most cases, ufshcd_intr will not reach scsi_done because the
outstanding_reqs tag is cleared by the original thread.
Therefore, whether there is an interrupt or not doesn't affect
the result because the ISR will do nothing in most cases.

In a very low chance, the ISR will reach scsi_done and notify
SCSI to requeue, and the original thread will not
call ufshcd_release_scsi_cmd. So should release because
outstanding_reqs is clear by ISR.

Below is ufshcd_abort MCQ flow:

ufshcd_abort()
  ufshcd_mcq_abort()
    ufshcd_try_to_abort_task()	// will trigger ISR
    ufshcd_release_scsi_cmd()

ufs_mtk_mcq_intr()
  ufshcd_mcq_poll_cqe_lock()
    ufshcd_mcq_process_cqe()
      ufshcd_compl_one_cqe()
        cmd->result = DID_ABORT
        ufshcd_release_scsi_cmd() // will release twice
        scsi_done()

In the case of MCQ ufshcd_abort, there is an issue where
ufshcd_release_scsi_cmd might be called twice. We could simply
skip the ISR release and scsi_done.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufs-mcq.c |  6 ++++++
 drivers/ufs/core/ufshcd.c  | 27 +++++++++++++++++++++++++++
 include/ufs/ufshcd.h       |  1 +
 3 files changed, 34 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 3903947dbed1..73d7cf337e2f 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -699,6 +699,12 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
+	/*
+	 * In MCQ mode, set this variable so that the ISR posted by
+	 * the host controller can be skipped.
+	 */
+	lrbp->abort_initiated_by = UFS_SCSI_ABORT;
+
 	/*
 	 * The command is not in the submission queue, and it is not
 	 * in the completion queue either. Query the device to see if
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b34125238a70..21091b11b4ba 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5537,6 +5537,27 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			ufshcd_update_monitor(hba, lrbp);
 		ufshcd_add_command_trace(hba, task_tag, UFS_CMD_COMP);
 		cmd->result = ufshcd_transfer_rsp_status(hba, lrbp, cqe);
+
+		/*
+		 * Let the SCSI layer decide how to handle the ufshcd_abort
+		 * situation, neither releasing nor notifying scsi_done in MCQ
+		 * mode. SDB mode should release because outstanding_reqs is
+		 * clear by ISR.
+		 */
+		if (lrbp->abort_initiated_by == UFS_SCSI_ABORT) {
+			ocs = ufshcd_get_tr_ocs(lrbp, cqe);
+			if ((hba->mcq_enabled) && (ocs == OCS_ABORTED))
+				 return;
+
+			if ((!hba->mcq_enabled) &&
+			    ((ocs == OCS_INVALID_COMMAND_STATUS) ||
+			     ((hba->quirks & UFSHCD_QUIRK_OCS_ABORTED) &&
+			      (ocs == OCS_ABORTED)))) {
+				ufshcd_release_scsi_cmd(hba, lrbp);
+				return;
+			}
+		}
+
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
 		scsi_done(cmd);
@@ -7673,6 +7694,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
 
+	/*
+	 * In SDB mode, set this variable so that the ISR posted by
+	 * the host controller clear UTRLCLR can be skipped.
+	 */
+	lrbp->abort_initiated_by = UFS_SCSI_ABORT;
+
 	err = ufshcd_try_to_abort_task(hba, tag);
 	if (err) {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 4d17a13ac558..4785a45040eb 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -148,6 +148,7 @@ enum ufs_pm_level {
 enum ufs_abort_by {
 	UFS_NO_ABORT,
 	UFS_ERR_HANDLER,
+	UFS_SCSI_ABORT
 };
 
 struct ufs_pm_lvl_states {
-- 
2.45.2

