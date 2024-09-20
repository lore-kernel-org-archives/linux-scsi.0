Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E945537FF;
	Fri, 20 Sep 2024 09:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726823214; cv=none; b=EIIswCMQbIfImIYxve8dDLuNbUFhDdcOFQ/ul5UitYhvdogvw/vynl/R6gDgnZemdYGxL8iBJ+nkAvGy5yH92YOffHXvn8BDM9hGzky2DA4oOboxxA89OeWFNKtLCwrXf7NiG4TGarDdIDUNlmxP4PiiDGR/wvAKM7xMowCB+xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726823214; c=relaxed/simple;
	bh=rMKwVXYRsy2mWYHYe+A9QCKC/Kj7A42a0wbnkpEAErU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AiEiBHhYGPs/qvnhc7RmaiY7vmU9mKgyraa68f/F2mV2g3CfEoSpMSQeOQNxQV5GB/cGva6wDkSlc3biFGWwawt7zIDKi5wh7FaJ2MC91q0+wVmnWhOWzRlZU5zQuQtrlrY58Ee073H04ttffF74J+TF/JPwVCtyJRYkGhxLcmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Q9EnDM8G; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Q9EnDM8G"
X-UUID: a92c14ec772f11ef8b96093e013ec31c-20240920
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=u4GTLoVuO7Bft9IHUdKhStH8Q38r+FyR4qW51Ikzg7M=;
	b=Q9EnDM8G1AYE0idaqOvR09Pev2WiCnaTPKKhPSulo5DSmksrRFZVRVVBAmtBBGpvPQ8m4B6heMdvF+hsBtWQw362L6QNMVmOZcYe+J2zXHovZrgQp9iI5kkxwgIAcEbLQnnAuPnpyyj0Si9n0TP4JaoWQ+j7ksnF2G5DK7XNPGo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:4d919eda-9471-45b5-b572-acf2f2f65e04,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6dc6a47,CLOUDID:46ec7fd0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: a92c14ec772f11ef8b96093e013ec31c-20240920
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1226816037; Fri, 20 Sep 2024 17:06:45 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 20 Sep 2024 02:06:44 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 20 Sep 2024 17:06:44 +0800
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
	<quic_nguyenb@quicinc.com>, <stable@vger.kernel.org>
Subject: [PATCH v7 2/4] ufs: core: requeue aborted request
Date: Fri, 20 Sep 2024 17:06:41 +0800
Message-ID: <20240920090643.3566-3-peter.wang@mediatek.com>
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

Regarding the specification of MCQ:
Aborts a command using SQ cleanup, The host controller
will post a Completion Queue entry with OCS = ABORTED.

ufshcd_abort_all forcibly aborts all on-going commands.
In MCQ mode, set a variable to notify SCSI to requeue the
command after receiving response with OCS_ABORTED.
This approach would then be consistent with legacy SDB mode.

Below is ufshcd_err_handler legacy SDB flow:
ufshcd_err_handler()
  ufshcd_abort_all()
    ufshcd_abort_one()
      ufshcd_try_to_abort_task()
    ufshcd_complete_requests()
      ufshcd_transfer_req_compl()
        ufshcd_poll()
          get outstanding_lock
          clear outstanding_reqs tag
          release outstanding_lock
          __ufshcd_transfer_req_compl()
            ufshcd_compl_one_cqe()
              cmd->result = DID_REQUEUE
              ufshcd_release_scsi_cmd()
              scsi_done()

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

Below is ufshcd_err_handler MCQ flow:

ufshcd_err_handler()
  ufshcd_abort_all()
    ufshcd_abort_one()
      ufshcd_try_to_abort_task()
    ufshcd_complete_requests()
      ufshcd_mcq_compl_pending_transfer()
        ufshcd_mcq_poll_cqe_lock()
          ufshcd_mcq_process_cqe()
            ufshcd_compl_one_cqe()
              cmd->result = DID_ABORT // should change to DID_REQUEUE
              ufshcd_release_scsi_cmd()
              scsi_done()

ufs_mtk_mcq_intr()
  ufshcd_mcq_poll_cqe_lock()
    ufshcd_mcq_process_cqe()
      ufshcd_compl_one_cqe()
        cmd->result = DID_ABORT  // should change to DID_REQUEUE
        ufshcd_release_scsi_cmd()
        scsi_done()

So what we need to correct is to notify SCSI to requeue
when MCQ mode receives OCS: ABORTED.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 40 ++++++++++++++++++++++++---------------
 include/ufs/ufshcd.h      |  8 ++++++++
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a6f818cdef0e..4f9c7a632465 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3006,6 +3006,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
 
 	lrbp->req_abort_skip = false;
+	lrbp->abort_initiated_by = UFS_NO_ABORT;
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
@@ -5404,10 +5405,19 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 		}
 		break;
 	case OCS_ABORTED:
-		result |= DID_ABORT << 16;
+		if (lrbp->abort_initiated_by == UFS_ERR_HANDLER)
+			result |= DID_REQUEUE << 16;
+		else
+			result |= DID_ABORT << 16;
+		dev_warn(hba->dev,
+				"OCS aborted from controller = %x for tag %d\n",
+				ocs, lrbp->task_tag);
 		break;
 	case OCS_INVALID_COMMAND_STATUS:
 		result |= DID_REQUEUE << 16;
+		dev_warn(hba->dev,
+				"OCS invaild from controller = %x for tag %d\n",
+				ocs, lrbp->task_tag);
 		break;
 	case OCS_INVALID_CMD_TABLE_ATTR:
 	case OCS_INVALID_PRDT_ATTR:
@@ -6471,26 +6481,12 @@ static bool ufshcd_abort_one(struct request *rq, void *priv)
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	struct ufs_hba *hba = shost_priv(shost);
-	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
-	struct ufs_hw_queue *hwq;
-	unsigned long flags;
 
 	*ret = ufshcd_try_to_abort_task(hba, tag);
 	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
 		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
 		*ret ? "failed" : "succeeded");
 
-	/* Release cmd in MCQ mode if abort succeeds */
-	if (hba->mcq_enabled && (*ret == 0)) {
-		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
-		if (!hwq)
-			return 0;
-		spin_lock_irqsave(&hwq->cq_lock, flags);
-		if (ufshcd_cmd_inflight(lrbp->cmd))
-			ufshcd_release_scsi_cmd(hba, lrbp);
-		spin_unlock_irqrestore(&hwq->cq_lock, flags);
-	}
-
 	return *ret == 0;
 }
 
@@ -7561,6 +7557,20 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 		goto out;
 	}
 
+	/*
+	 * When the host software receives a "FUNCTION COMPLETE", set this
+	 * variable to requeue command after receive response with OCS_ABORTED
+	 *
+	 * MCQ mode: Host will post to CQ with OCS_ABORTED after SQ cleanup
+	 *
+	 * This variable is set because error handler ufshcd_abort_all forcibly
+	 * aborts all commands, and the host controller will automatically
+	 * fill in the OCS field of the corresponding response with OCS_ABORTED.
+	 * Therefore, upon receiving this response, it needs to be requeued.
+	 */
+	if (!err && hba->mcq_enabled && ufshcd_eh_in_progress(hba))
+		lrbp->abort_initiated_by = UFS_ERR_HANDLER;
+
 	err = ufshcd_clear_cmd(hba, tag);
 	if (err)
 		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 0fd2aebac728..61a7dc489511 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -145,6 +145,11 @@ enum ufs_pm_level {
 	UFS_PM_LVL_MAX
 };
 
+enum ufs_abort_by {
+	UFS_NO_ABORT,
+	UFS_ERR_HANDLER,
+};
+
 struct ufs_pm_lvl_states {
 	enum ufs_dev_pwr_mode dev_state;
 	enum uic_link_state link_state;
@@ -173,6 +178,8 @@ struct ufs_pm_lvl_states {
  * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
  * @data_unit_num: the data unit number for the first block for inline crypto
  * @req_abort_skip: skip request abort task flag
+ * @abort_initiated_by: This variable is used to store the scenario in
+ *                      which the abort occurs
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
@@ -202,6 +209,7 @@ struct ufshcd_lrb {
 #endif
 
 	bool req_abort_skip;
+	int abort_initiated_by;
 };
 
 /**
-- 
2.45.2

