Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28CBC33C9B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 19:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CDBA20656
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 19:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgAGTZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 14:25:46 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55947 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGTZq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 14:25:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so199680pjz.5
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2020 11:25:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DBYne2FAAS5qgrEHV1UMc+G/r+Tx+hzADaRr1+V2D+M=;
        b=gqEng/wsQeoZaFQswZDE288hDbUSXPgsXF/V+abUbJC0Gs3LUcDqXvFK+uPEqCkcuq
         pqDSlG45L6wQyP7BlzseCsKhp5UsOUrfcZ2LO86NssoEjVWjTsGugO8dxjgzSQx5pIah
         7SFUDgXayjxOIi0vNSYXW5biYNA3rQf1gkBaz2APr0Xl+x6bFk3olOvVODD+8Gk65eyd
         Q4ihIdbIoxFoy0WmtwpE3Tk9RYgNkxjpJJy6U6sHUsFO2bX3WmSVmAjevqoOisxxv5HR
         tPPkcB0m6yIaHBOxpquA2VC/zuSpVTjVMI0cmP7YRgeC//bkC6hFx4vcMK1O+n7f1Bzt
         wbnA==
X-Gm-Message-State: APjAAAV28Ur/qIczXvFu4oLzdLDCLDThRPQrWbsG7Q/uBSCOuZ9UB+XU
        Cmo5KIGOlaXuuxtzgsC/vPktoHo9
X-Google-Smtp-Source: APXvYqy2okTyuIhCDOf2sE4tUF4+a0ScEL90eQo+e/5ElOQEtl8y+TevUnTEYGIU4Nirci6swACaFA==
X-Received: by 2002:a17:902:b210:: with SMTP id t16mr1232384plr.65.1578425145154;
        Tue, 07 Jan 2020 11:25:45 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c2sm329051pjq.27.2020.01.07.11.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 11:25:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 4/4] ufs: Let the SCSI core allocate per-command UFS data
Date:   Tue,  7 Jan 2020 11:25:31 -0800
Message-Id: <20200107192531.73802-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <20200107192531.73802-1-bvanassche@acm.org>
References: <20200107192531.73802-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template such that the SCSI core allocates
space at the end of each SCSI command for the UFS data. Set the
.init_cmd_priv function pointer in the SCSI host template such that the
UFS data is only initialized once.

Remove the struct members that are no longer necessary due to these
changes, namely ufshcd_lrb.cmd and ufs_hba.lrb.

Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 207 ++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |   5 -
 2 files changed, 134 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 15e65248597d..e4b6408e55c4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -294,19 +294,60 @@ static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
 		scsi_block_requests(hba->host);
 }
 
+/*
+ * Convert a SCSI or device management command tag into a request pointer. Use
+ * scsi_cmd_priv() instead of this function if a SCSI command pointer is
+ * available. The caller must ensure that the request state won't change as
+ * long as the returned pointer is in use.
+ */
+static struct request *ufshcd_tag_to_req(struct ufs_hba *hba, unsigned int tag)
+{
+	return blk_mq_tag_to_rq(hba->cmd_queue->tag_set->tags[0], tag);
+}
+
+/* Convert a SCSI or device management request pointer into an LRB pointer. */
+static struct ufshcd_lrb *ufshcd_req_to_lrb(struct request *req)
+{
+	struct scsi_cmnd *cmd = container_of(scsi_req(req), typeof(*cmd), req);
+
+	return scsi_cmd_priv(cmd);
+}
+
+/*
+ * Convert a SCSI or device management command tag into a UFS data pointer. Use
+ * scsi_cmd_priv() instead of this function if a SCSI command pointer is
+ * available. The caller must ensure that the SCSI command state won't change
+ * as long as the returned pointer is in use.
+ */
+static struct ufshcd_lrb *ufshcd_tag_to_lrb(struct ufs_hba *hba,
+					    unsigned int tag)
+{
+	struct request *req = ufshcd_tag_to_req(hba, tag);
+
+	return req ? ufshcd_req_to_lrb(req) : NULL;
+}
+
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		const char *str)
 {
-	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+	struct ufshcd_lrb *lrb = ufshcd_tag_to_lrb(hba, tag);
+	struct utp_upiu_req *rq;
 
+	if (WARN_ON_ONCE(!lrb))
+		return;
+	rq = lrb->ucd_req_ptr;
 	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.cdb);
 }
 
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		const char *str)
 {
-	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+	struct ufshcd_lrb *lrb = ufshcd_tag_to_lrb(hba, tag);
+	struct utp_upiu_req *rq;
 
+	if (WARN_ON_ONCE(!lrb))
+		return;
+	rq = lrb->ucd_req_ptr;
 	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);
 }
 
@@ -320,16 +361,35 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 			&descp->input_param1);
 }
 
-static void ufshcd_add_command_trace(struct ufs_hba *hba,
-		unsigned int tag, const char *str)
+/*
+ * Whether or not @req represents a SCSI command. Device management commands
+ * and TMF commands have the operation type set to REQ_OP_DRV_OUT.
+ */
+static bool ufshcd_is_scsi(struct request *req)
+{
+	switch (req_op(req)) {
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
+		return false;
+	}
+	return true;
+}
+
+/* Trace a SCSI or device management command. */
+static void ufshcd_add_command_trace(struct ufs_hba *hba, struct request *req,
+				     const char *str)
 {
 	sector_t lba = -1;
 	u8 opcode = 0;
 	u32 intr, doorbell;
-	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
-	struct scsi_cmnd *cmd = lrbp->cmd;
+	struct ufshcd_lrb *lrbp = ufshcd_req_to_lrb(req);
+	struct scsi_cmnd *cmd = NULL;
+	unsigned int tag = req->tag;
 	int transfer_len = -1;
 
+	if (ufshcd_is_scsi(req))
+		cmd = blk_mq_rq_to_pdu(req);
+
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
 		if (cmd)
@@ -439,7 +499,9 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 	int tag;
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
-		lrbp = &hba->lrb[tag];
+		lrbp = ufshcd_tag_to_lrb(hba, tag);
+		if (!lrbp)
+			continue;
 
 		dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
 				tag, ktime_to_us(lrbp->issue_time_stamp));
@@ -1853,14 +1915,17 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 /**
  * ufshcd_send_command - Send SCSI or device management commands
  * @hba: per adapter instance
- * @task_tag: Task tag of the command
+ * @req: SCSI or device management command pointer
  */
 static inline
-void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
+void ufshcd_send_command(struct ufs_hba *hba, struct request *req)
 {
-	hba->lrb[task_tag].issue_time_stamp = ktime_get();
-	hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
-	ufshcd_add_command_trace(hba, task_tag, "send");
+	struct ufshcd_lrb *lrbp = ufshcd_req_to_lrb(req);
+	unsigned int task_tag = req->tag;
+
+	lrbp->issue_time_stamp = ktime_get();
+	lrbp->compl_time_stamp = ktime_set(0, 0);
+	ufshcd_add_command_trace(hba, req, "send");
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
@@ -2076,19 +2141,18 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 /**
  * ufshcd_map_sg - Map scatter-gather list to prdt
  * @hba: per adapter instance
- * @lrbp: pointer to local reference block
+ * @cmd: SCSI command to map
  *
  * Returns 0 in case of success, non-zero value in case of failure
  */
-static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static int ufshcd_map_sg(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 {
+	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	struct ufshcd_sg_entry *prd_table;
 	struct scatterlist *sg;
-	struct scsi_cmnd *cmd;
 	int sg_segments;
 	int i;
 
-	cmd = lrbp->cmd;
 	sg_segments = scsi_dma_map(cmd);
 	if (sg_segments < 0)
 		return sg_segments;
@@ -2212,13 +2276,13 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 /**
  * ufshcd_prepare_utp_scsi_cmd_upiu() - fills the utp_transfer_req_desc,
  * for scsi commands
- * @lrbp: local reference block pointer
+ * @cmd: SCSI command to prepare
  * @upiu_flags: flags
  */
 static
-void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
+void ufshcd_prepare_utp_scsi_cmd_upiu(struct scsi_cmnd *cmd, u32 upiu_flags)
 {
-	struct scsi_cmnd *cmd = lrbp->cmd;
+	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
 	unsigned short cdb_len;
 
@@ -2329,10 +2393,12 @@ static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
  * ufshcd_comp_scsi_upiu - UFS Protocol Information Unit(UPIU)
  *			   for SCSI Purposes
  * @hba: per adapter instance
- * @lrbp: pointer to local reference block
+ * @cmd: command to prepare.
  */
-static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 {
+	struct request *req = cmd->request;
+	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	u32 upiu_flags;
 	int ret = 0;
 
@@ -2342,10 +2408,10 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	else
 		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
-	if (likely(lrbp->cmd)) {
+	if (likely(ufshcd_is_scsi(req))) {
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
-						lrbp->cmd->sc_data_direction);
-		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+						cmd->sc_data_direction);
+		ufshcd_prepare_utp_scsi_cmd_upiu(cmd, upiu_flags);
 	} else {
 		ret = -EINVAL;
 	}
@@ -2394,7 +2460,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
  */
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
-	struct ufshcd_lrb *lrbp;
+	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	struct ufs_hba *hba;
 	unsigned long flags;
 	int tag;
@@ -2410,6 +2476,13 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		BUG();
 	}
 
+	/* See also ufshcd_is_scsi() */
+	switch (req_op(cmd->request)) {
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
+		WARN_ON_ONCE(true);
+	}
+
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
@@ -2450,10 +2523,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 	WARN_ON(hba->clk_gating.state != CLKS_ON);
 
-	lrbp = &hba->lrb[tag];
-
-	WARN_ON(lrbp->cmd);
-	lrbp->cmd = cmd;
 	lrbp->sense_bufflen = UFS_SENSE_SIZE;
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
@@ -2461,21 +2530,18 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 	lrbp->req_abort_skip = false;
 
-	ufshcd_comp_scsi_upiu(hba, lrbp);
+	ufshcd_comp_scsi_upiu(hba, cmd);
 
-	err = ufshcd_map_sg(hba, lrbp);
-	if (err) {
-		lrbp->cmd = NULL;
-		ufshcd_release(hba);
+	err = ufshcd_map_sg(hba, cmd);
+	if (err)
 		goto out;
-	}
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_vops_setup_xfer_req(hba, tag, true);
-	ufshcd_send_command(hba, tag);
+	ufshcd_send_command(hba, cmd->request);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
@@ -2486,7 +2552,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
 {
-	lrbp->cmd = NULL;
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
@@ -2649,8 +2714,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	init_completion(&wait);
-	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
+	lrbp = ufshcd_req_to_lrb(req);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
 		goto out_put_tag;
@@ -2662,7 +2726,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_vops_setup_xfer_req(hba, tag, false);
-	ufshcd_send_command(hba, tag);
+	ufshcd_send_command(hba, req);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
@@ -3378,14 +3442,6 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* Allocate memory for local reference block */
-	hba->lrb = devm_kcalloc(hba->dev,
-				hba->nutrs, sizeof(struct ufshcd_lrb),
-				GFP_KERNEL);
-	if (!hba->lrb) {
-		dev_err(hba->dev, "LRB Memory allocation failed\n");
-		goto out;
-	}
 	return 0;
 out:
 	return -ENOMEM;
@@ -3449,11 +3505,17 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 			utrdlp[i].response_upiu_length =
 				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 		}
-
-		ufshcd_init_lrb(hba, &hba->lrb[i], i);
 	}
 }
 
+static int ufshcd_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+{
+	struct ufs_hba *hba = shost_priv(shost);
+
+	ufshcd_init_lrb(hba, scsi_cmd_priv(cmd), cmd->tag);
+	return 0;
+}
+
 /**
  * ufshcd_dme_link_startup - Notify Unipro to perform link startup
  * @hba: per adapter instance
@@ -4826,19 +4888,21 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
+	struct request *req;
 	int result;
 	int index;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
-		lrbp = &hba->lrb[index];
-		cmd = lrbp->cmd;
-		if (cmd) {
-			ufshcd_add_command_trace(hba, index, "complete");
+		req = ufshcd_tag_to_req(hba, index);
+		if (!req)
+			continue;
+		cmd = blk_mq_rq_to_pdu(req);
+		lrbp = scsi_cmd_priv(cmd);
+		if (ufshcd_is_scsi(req)) {
+			ufshcd_add_command_trace(hba, req, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
-			/* Mark completed command as NULL in LRB */
-			lrbp->cmd = NULL;
 			lrbp->compl_time_stamp = ktime_get();
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
@@ -4847,7 +4911,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			lrbp->compl_time_stamp = ktime_get();
 			if (hba->dev_cmd.complete) {
-				ufshcd_add_command_trace(hba, index,
+				ufshcd_add_command_trace(hba, req,
 						"dev_complete");
 				complete(hba->dev_cmd.complete);
 			}
@@ -5892,10 +5956,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	init_completion(&wait);
-	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
-
-	lrbp->cmd = NULL;
+	lrbp = ufshcd_req_to_lrb(req);
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
@@ -5936,7 +5997,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_send_command(hba, tag);
+	ufshcd_send_command(hba, req);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/*
@@ -6053,18 +6114,15 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
-	unsigned int tag;
 	u32 pos;
 	int err;
 	u8 resp = 0xF;
-	struct ufshcd_lrb *lrbp;
+	struct ufshcd_lrb *lrbp, *lrbp2;
 	unsigned long flags;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
-
-	lrbp = &hba->lrb[tag];
+	lrbp = scsi_cmd_priv(cmd);
 	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
 		if (!err)
@@ -6074,7 +6132,8 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	/* clear the commands that were pending for corresponding LUN */
 	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[pos].lun == lrbp->lun) {
+		lrbp2 = ufshcd_tag_to_lrb(hba, pos);
+		if (lrbp2->lun == lrbp->lun) {
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
@@ -6102,8 +6161,9 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 	int tag;
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
-		lrbp = &hba->lrb[tag];
-		lrbp->req_abort_skip = true;
+		lrbp = ufshcd_tag_to_lrb(hba, tag);
+		if (lrbp)
+			lrbp->req_abort_skip = true;
 	}
 }
 
@@ -6134,7 +6194,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	host = cmd->device->host;
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
-	lrbp = &hba->lrb[tag];
+	lrbp = scsi_cmd_priv(cmd);
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
 			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
@@ -6178,7 +6238,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * to reduce repeated printouts. For other aborted requests only print
 	 * basic details.
 	 */
-	scsi_print_command(hba->lrb[tag].cmd);
+	scsi_print_command(cmd);
 	if (!hba->req_abort_count) {
 		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort, 0);
 		ufshcd_print_host_regs(hba);
@@ -6258,7 +6318,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	spin_lock_irqsave(host->host_lock, flags);
 	ufshcd_outstanding_req_clear(hba, tag);
-	hba->lrb[tag].cmd = NULL;
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 out:
@@ -7102,6 +7161,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
+	.init_cmd_priv		= ufshcd_init_cmd_priv,
 	.queuecommand		= ufshcd_queuecommand,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_configure	= ufshcd_slave_configure,
@@ -7113,6 +7173,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
+	.cmd_size		= sizeof(struct ufshcd_lrb),
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
 	.max_host_blocked	= 1,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e05cafddc87b..231a948151ca 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -157,7 +157,6 @@ struct ufs_pm_lvl_states {
  * @ucd_prdt_dma_addr: PRDT dma address for debug
  * @ucd_rsp_dma_addr: UPIU response dma address for debug
  * @ucd_req_dma_addr: UPIU request dma address for debug
- * @cmd: pointer to SCSI command
  * @sense_buffer: pointer to sense buffer address of the SCSI command
  * @sense_bufflen: Length of the sense buffer
  * @scsi_status: SCSI status of the command
@@ -180,7 +179,6 @@ struct ufshcd_lrb {
 	dma_addr_t ucd_rsp_dma_addr;
 	dma_addr_t ucd_prdt_dma_addr;
 
-	struct scsi_cmnd *cmd;
 	u8 *sense_buffer;
 	unsigned int sense_bufflen;
 	int scsi_status;
@@ -480,7 +478,6 @@ struct ufs_stats {
  * @utmrdl_dma_addr: UTMRDL DMA address
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
- * @lrb: local reference block
  * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_reqs: Bits representing outstanding transfer requests
@@ -558,8 +555,6 @@ struct ufs_hba {
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
 
-	struct ufshcd_lrb *lrb;
-
 	unsigned long outstanding_tasks;
 	unsigned long outstanding_reqs;
 
