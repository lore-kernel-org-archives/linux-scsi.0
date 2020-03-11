Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CEEC10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 11:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0DA22464B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 11:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUt8LWGC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgCKL3n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 07:29:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33041 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCKL3l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 07:29:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id a25so2146737wrd.0;
        Wed, 11 Mar 2020 04:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ysYHZDTlY3etmxSYB+6dnU8MZ52EdpQrVhW4Z1+VCNA=;
        b=DUt8LWGCt+OJXuu3soDvYXqbGMR67FkUSgtH188EW323bqCwsASd0+u7YHsh8v5TFb
         wRrkopjE+9pnAytF7mD8t1kAlEj0Nvqx16HySaM47OeGIKEXy67/DjdYw/1W7hzODOsW
         MxxWudF88WHuIbEXsnN10oA3u/FD0oLWxarm0bnvMb6d1pwS/2IVshF42XlhFVJ9/zbC
         t1eAg3niKa/ITwQHOpcYQu7JNn+IWyXnBecKkQ5mdkWekTUq7qi1gSv1aEuOHdRF3+hf
         ZiK425aEH7F20kY5gdi3TIINW3WmNgPjvMlh9PjYNWOavT0j9Ill40SALZgYmATLXLVy
         sMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ysYHZDTlY3etmxSYB+6dnU8MZ52EdpQrVhW4Z1+VCNA=;
        b=N0TlJaD2Z0ps/97dhGFcT48+1F42ABeDqbnijE+0zvoSueVzqZ0ex/mHFeP0BJEmgd
         MEh01yVqftbow1raCA2iqlnmJ/9Et3PiiAXVk8nawrbpcfk7Q8GXpti4fvj0mfoB/C5j
         NMF0OAARAPaiQND1hdE1d8DcD68lEe+7ia6AkI5H83xekDYB1f4+v37yHHWY2SQlqICE
         Pn7YBt6yBAMUgCZFqSiMl1ZLvTOkXIcvEjUN2SHZ9cKX8b29CGdcKvAWJDzt6dRy14vV
         3jOuMVcKtC4EV/hmVuZHs1pKNwm9uGimrSbzYUwnnt0QKt4zn9w8D6A3rFNeWd+ztksd
         dwhQ==
X-Gm-Message-State: ANhLgQ1g7I5HXTqlH4zdOizo0pBdOlpi2E9nw+pzoc14b2rLaEq6UWwH
        uK7wfcrikZPZnRLFNVD24og=
X-Google-Smtp-Source: ADFU+vupEmnZ+5MgnzBaXwzfJXLnvJ1FxQyjqDWRJZz8La1WPZBd+haS/ePyGiQK772B1aPicoyrKQ==
X-Received: by 2002:a5d:66c4:: with SMTP id k4mr3867193wrw.133.1583926178260;
        Wed, 11 Mar 2020 04:29:38 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id l64sm8190735wmf.30.2020.03.11.04.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 04:29:37 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Revert "scsi: ufs: Let the SCSI core allocate per-command UFS data"
Date:   Wed, 11 Mar 2020 12:29:21 +0100
Message-Id: <20200311112921.29031-2-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200311112921.29031-1-beanhuo@micron.com>
References: <20200311112921.29031-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patch is to revert commit 2bb1156f9f1b36b1f594b89fa5412fd4178b28c6.

There are two issues in commit (scsi: ufs: Let the SCSI core
allocate per-command UFS data) with the ufshcd_init_lrb() called
in ufshcd_init_cmd_priv():

- cmd->tag is set from inside scsi_mq_prep_fn() and hence is not yet
  set when ufshcd_init_cmd_priv() is set.
- Inside ufshcd_init_cmd_priv() the tag can only be derived from the SCSI
  command pointer if no scheduler has been associated with the UFS block
  device. If no scheduler is associated with a block device, the
  relationship between hctx->tags->static_rqs[] and rq->tag is static.
  If a scheduler has been configured, a single tag can be associated
  with a different struct request if a request is reallocated.

So revert this commit simply.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 198 ++++++++++++++------------------------
 drivers/scsi/ufs/ufshcd.h |   5 +
 2 files changed, 75 insertions(+), 128 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e987fa3a77c7..2a2a63b68a67 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -296,60 +296,19 @@ static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
 		scsi_block_requests(hba->host);
 }
 
-/*
- * Convert a SCSI or device management command tag into a request pointer. Use
- * scsi_cmd_priv() instead of this function if a SCSI command pointer is
- * available. The caller must ensure that the request state won't change as
- * long as the returned pointer is in use.
- */
-static struct request *ufshcd_tag_to_req(struct ufs_hba *hba, unsigned int tag)
-{
-	return blk_mq_tag_to_rq(hba->cmd_queue->tag_set->tags[0], tag);
-}
-
-/* Convert a SCSI or device management request pointer into an LRB pointer. */
-static struct ufshcd_lrb *ufshcd_req_to_lrb(struct request *req)
-{
-	struct scsi_cmnd *cmd = container_of(scsi_req(req), typeof(*cmd), req);
-
-	return scsi_cmd_priv(cmd);
-}
-
-/*
- * Convert a SCSI or device management command tag into a UFS data pointer. Use
- * scsi_cmd_priv() instead of this function if a SCSI command pointer is
- * available. The caller must ensure that the SCSI command state won't change
- * as long as the returned pointer is in use.
- */
-static struct ufshcd_lrb *ufshcd_tag_to_lrb(struct ufs_hba *hba,
-					    unsigned int tag)
-{
-	struct request *req = ufshcd_tag_to_req(hba, tag);
-
-	return req ? ufshcd_req_to_lrb(req) : NULL;
-}
-
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		const char *str)
 {
-	struct ufshcd_lrb *lrb = ufshcd_tag_to_lrb(hba, tag);
-	struct utp_upiu_req *rq;
+	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
 
-	if (WARN_ON_ONCE(!lrb))
-		return;
-	rq = lrb->ucd_req_ptr;
 	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.cdb);
 }
 
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		const char *str)
 {
-	struct ufshcd_lrb *lrb = ufshcd_tag_to_lrb(hba, tag);
-	struct utp_upiu_req *rq;
+	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
 
-	if (WARN_ON_ONCE(!lrb))
-		return;
-	rq = lrb->ucd_req_ptr;
 	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);
 }
 
@@ -363,35 +322,16 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 			&descp->input_param1);
 }
 
-/*
- * Whether or not @req represents a SCSI command. Returns false for device
- * management commands and also for TMFs.
- */
-static bool ufshcd_is_scsi(struct request *req)
-{
-	switch (req_op(req)) {
-	case REQ_OP_DRV_IN:
-	case REQ_OP_DRV_OUT:
-		return false;
-	}
-	return true;
-}
-
-/* Trace a SCSI or device management command. */
-static void ufshcd_add_command_trace(struct ufs_hba *hba, struct request *req,
-				     const char *str)
+static void ufshcd_add_command_trace(struct ufs_hba *hba,
+		unsigned int tag, const char *str)
 {
 	sector_t lba = -1;
 	u8 opcode = 0;
 	u32 intr, doorbell;
-	struct ufshcd_lrb *lrbp = ufshcd_req_to_lrb(req);
-	struct scsi_cmnd *cmd = NULL;
-	unsigned int tag = req->tag;
+	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	struct scsi_cmnd *cmd = lrbp->cmd;
 	int transfer_len = -1;
 
-	if (ufshcd_is_scsi(req))
-		cmd = blk_mq_rq_to_pdu(req);
-
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
 		if (cmd)
@@ -501,9 +441,7 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 	int tag;
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
-		lrbp = ufshcd_tag_to_lrb(hba, tag);
-		if (!lrbp)
-			continue;
+		lrbp = &hba->lrb[tag];
 
 		dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
 				tag, ktime_to_us(lrbp->issue_time_stamp));
@@ -1915,17 +1853,14 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
 /**
  * ufshcd_send_command - Send SCSI or device management commands
  * @hba: per adapter instance
- * @req: SCSI or device management command pointer
+ * @task_tag: Task tag of the command
  */
 static inline
-void ufshcd_send_command(struct ufs_hba *hba, struct request *req)
+void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
-	struct ufshcd_lrb *lrbp = ufshcd_req_to_lrb(req);
-	unsigned int task_tag = req->tag;
-
-	lrbp->issue_time_stamp = ktime_get();
-	lrbp->compl_time_stamp = ktime_set(0, 0);
-	ufshcd_add_command_trace(hba, req, "send");
+	hba->lrb[task_tag].issue_time_stamp = ktime_get();
+	hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
+	ufshcd_add_command_trace(hba, task_tag, "send");
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
@@ -2141,18 +2076,19 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 /**
  * ufshcd_map_sg - Map scatter-gather list to prdt
  * @hba: per adapter instance
- * @cmd: SCSI command to map
+ * @lrbp: pointer to local reference block
  *
  * Returns 0 in case of success, non-zero value in case of failure
  */
-static int ufshcd_map_sg(struct ufs_hba *hba, struct scsi_cmnd *cmd)
+static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	struct ufshcd_sg_entry *prd_table;
 	struct scatterlist *sg;
+	struct scsi_cmnd *cmd;
 	int sg_segments;
 	int i;
 
+	cmd = lrbp->cmd;
 	sg_segments = scsi_dma_map(cmd);
 	if (sg_segments < 0)
 		return sg_segments;
@@ -2271,13 +2207,13 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
 /**
  * ufshcd_prepare_utp_scsi_cmd_upiu() - fills the utp_transfer_req_desc,
  * for scsi commands
- * @cmd: SCSI command to prepare
+ * @lrbp: local reference block pointer
  * @upiu_flags: flags
  */
 static
-void ufshcd_prepare_utp_scsi_cmd_upiu(struct scsi_cmnd *cmd, u32 upiu_flags)
+void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32 upiu_flags)
 {
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct scsi_cmnd *cmd = lrbp->cmd;
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
 	unsigned short cdb_len;
 
@@ -2388,12 +2324,10 @@ static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
  * ufshcd_comp_scsi_upiu - UFS Protocol Information Unit(UPIU)
  *			   for SCSI Purposes
  * @hba: per adapter instance
- * @cmd: command to prepare.
+ * @lrbp: pointer to local reference block
  */
-static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct scsi_cmnd *cmd)
+static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	struct request *req = cmd->request;
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	u32 upiu_flags;
 	int ret = 0;
 
@@ -2403,10 +2337,10 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct scsi_cmnd *cmd)
 	else
 		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
-	if (likely(ufshcd_is_scsi(req))) {
+	if (likely(lrbp->cmd)) {
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
-						cmd->sc_data_direction);
-		ufshcd_prepare_utp_scsi_cmd_upiu(cmd, upiu_flags);
+						lrbp->cmd->sc_data_direction);
+		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 	} else {
 		ret = -EINVAL;
 	}
@@ -2455,7 +2389,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
  */
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct ufshcd_lrb *lrbp;
 	struct ufs_hba *hba;
 	unsigned long flags;
 	int tag;
@@ -2471,8 +2405,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		BUG();
 	}
 
-	WARN_ON_ONCE(!ufshcd_is_scsi(cmd->request));
-
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
@@ -2513,6 +2445,10 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 	WARN_ON(hba->clk_gating.state != CLKS_ON);
 
+	lrbp = &hba->lrb[tag];
+
+	WARN_ON(lrbp->cmd);
+	lrbp->cmd = cmd;
 	lrbp->sense_bufflen = UFS_SENSE_SIZE;
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
@@ -2520,10 +2456,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 	lrbp->req_abort_skip = false;
 
-	ufshcd_comp_scsi_upiu(hba, cmd);
+	ufshcd_comp_scsi_upiu(hba, lrbp);
 
-	err = ufshcd_map_sg(hba, cmd);
+	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
+		lrbp->cmd = NULL;
 		ufshcd_release(hba);
 		goto out;
 	}
@@ -2533,7 +2470,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_vops_setup_xfer_req(hba, tag, true);
-	ufshcd_send_command(hba, cmd->request);
+	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
@@ -2544,6 +2481,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
 {
+	lrbp->cmd = NULL;
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
@@ -2706,7 +2644,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	init_completion(&wait);
-	lrbp = ufshcd_req_to_lrb(req);
+	lrbp = &hba->lrb[tag];
+	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
 		goto out_put_tag;
@@ -2718,7 +2657,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_vops_setup_xfer_req(hba, tag, false);
-	ufshcd_send_command(hba, req);
+	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
@@ -3448,6 +3387,14 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	/* Allocate memory for local reference block */
+	hba->lrb = devm_kcalloc(hba->dev,
+				hba->nutrs, sizeof(struct ufshcd_lrb),
+				GFP_KERNEL);
+	if (!hba->lrb) {
+		dev_err(hba->dev, "LRB Memory allocation failed\n");
+		goto out;
+	}
 	return 0;
 out:
 	return -ENOMEM;
@@ -3501,15 +3448,9 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 		utrdlp[i].prd_table_offset = cpu_to_le16(prdt_offset >> 2);
 		utrdlp[i].response_upiu_length =
 			cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
-	}
-}
-
-static int ufshcd_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	struct ufs_hba *hba = shost_priv(shost);
 
-	ufshcd_init_lrb(hba, scsi_cmd_priv(cmd), cmd->tag);
-	return 0;
+		ufshcd_init_lrb(hba, &hba->lrb[i], i);
+	}
 }
 
 /**
@@ -4824,21 +4765,19 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
-	struct request *req;
 	int result;
 	int index;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
-		req = ufshcd_tag_to_req(hba, index);
-		if (!req)
-			continue;
-		cmd = blk_mq_rq_to_pdu(req);
-		lrbp = scsi_cmd_priv(cmd);
-		if (ufshcd_is_scsi(req)) {
-			ufshcd_add_command_trace(hba, req, "complete");
+		lrbp = &hba->lrb[index];
+		cmd = lrbp->cmd;
+		if (cmd) {
+			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
+			/* Mark completed command as NULL in LRB */
+			lrbp->cmd = NULL;
 			lrbp->compl_time_stamp = ktime_get();
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
@@ -4847,7 +4786,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			lrbp->compl_time_stamp = ktime_get();
 			if (hba->dev_cmd.complete) {
-				ufshcd_add_command_trace(hba, req,
+				ufshcd_add_command_trace(hba, index,
 						"dev_complete");
 				complete(hba->dev_cmd.complete);
 			}
@@ -5899,7 +5838,10 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	init_completion(&wait);
-	lrbp = ufshcd_req_to_lrb(req);
+	lrbp = &hba->lrb[tag];
+	WARN_ON(lrbp->cmd);
+
+	lrbp->cmd = NULL;
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
@@ -5940,7 +5882,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_send_command(hba, req);
+	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/*
@@ -6057,15 +5999,18 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
+	unsigned int tag;
 	u32 pos;
 	int err;
 	u8 resp = 0xF;
-	struct ufshcd_lrb *lrbp, *lrbp2;
+	struct ufshcd_lrb *lrbp;
 	unsigned long flags;
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	lrbp = scsi_cmd_priv(cmd);
+	tag = cmd->request->tag;
+
+	lrbp = &hba->lrb[tag];
 	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
 		if (!err)
@@ -6075,8 +6020,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	/* clear the commands that were pending for corresponding LUN */
 	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		lrbp2 = ufshcd_tag_to_lrb(hba, pos);
-		if (lrbp2 && lrbp2->lun == lrbp->lun) {
+		if (hba->lrb[pos].lun == lrbp->lun) {
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
@@ -6104,9 +6048,8 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 	int tag;
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
-		lrbp = ufshcd_tag_to_lrb(hba, tag);
-		if (lrbp)
-			lrbp->req_abort_skip = true;
+		lrbp = &hba->lrb[tag];
+		lrbp->req_abort_skip = true;
 	}
 }
 
@@ -6137,7 +6080,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	host = cmd->device->host;
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
-	lrbp = scsi_cmd_priv(cmd);
+	lrbp = &hba->lrb[tag];
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
 			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
@@ -6181,7 +6124,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * to reduce repeated printouts. For other aborted requests only print
 	 * basic details.
 	 */
-	scsi_print_command(cmd);
+	scsi_print_command(hba->lrb[tag].cmd);
 	if (!hba->req_abort_count) {
 		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort, 0);
 		ufshcd_print_host_regs(hba);
@@ -6261,6 +6204,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	spin_lock_irqsave(host->host_lock, flags);
 	ufshcd_outstanding_req_clear(hba, tag);
+	hba->lrb[tag].cmd = NULL;
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 out:
@@ -7180,7 +7124,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
-	.init_cmd_priv		= ufshcd_init_cmd_priv,
 	.queuecommand		= ufshcd_queuecommand,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_configure	= ufshcd_slave_configure,
@@ -7192,7 +7135,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
-	.cmd_size		= sizeof(struct ufshcd_lrb),
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
 	.max_host_blocked	= 1,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5c10777154fc..d45a04444191 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -158,6 +158,7 @@ struct ufs_pm_lvl_states {
  * @ucd_prdt_dma_addr: PRDT dma address for debug
  * @ucd_rsp_dma_addr: UPIU response dma address for debug
  * @ucd_req_dma_addr: UPIU request dma address for debug
+ * @cmd: pointer to SCSI command
  * @sense_buffer: pointer to sense buffer address of the SCSI command
  * @sense_bufflen: Length of the sense buffer
  * @scsi_status: SCSI status of the command
@@ -180,6 +181,7 @@ struct ufshcd_lrb {
 	dma_addr_t ucd_rsp_dma_addr;
 	dma_addr_t ucd_prdt_dma_addr;
 
+	struct scsi_cmnd *cmd;
 	u8 *sense_buffer;
 	unsigned int sense_bufflen;
 	int scsi_status;
@@ -521,6 +523,7 @@ enum ufshcd_quirks {
  * @utmrdl_dma_addr: UTMRDL DMA address
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
+ * @lrb: local reference block
  * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_reqs: Bits representing outstanding transfer requests
@@ -597,6 +600,8 @@ struct ufs_hba {
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
 
+	struct ufshcd_lrb *lrb;
+
 	unsigned long outstanding_tasks;
 	unsigned long outstanding_reqs;
 
-- 
2.17.1

