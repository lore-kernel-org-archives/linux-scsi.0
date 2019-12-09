Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBADC00454
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8292820836
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLISNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:13:19 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42592 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLISNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:13:19 -0500
Received: by mail-pg1-f193.google.com with SMTP id s64so789408pgb.9
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 10:13:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zcFeLGaC0kZuLZi8us1AZWM4bS28wziNMRfKkCINacI=;
        b=KvdpnKnF6Nn+QgVZ3zXvxsv4Tw5LyOnEXKPeq3PQTJ23DDj+LjjuNJ7U/MEmZ4cZe4
         yj/30dySygtBEOFn2APPQpowLp5grlg/5y1D4jvoEva7GlpBWRZaNTvxsFRc1XHd8XwY
         mGCglptGcYodbBvqtYa2brGvhueGkTrUpoox+4+YA+0HsJSe1fpwQ/FtJttFtG1ux1L0
         9F1zMscyuynSbEPcSHu/kzYJFg3FcQXGa7u7K/qtSGZYN2vCozUGa2wy5iORA7Sfn6Ao
         T2TFtNzluhMb7RmTyO3mUgKiPFZmRCPYkkfMLj73HnzZbpjNJQbxdKAGxBlEQLTBat1q
         1ASA==
X-Gm-Message-State: APjAAAUdPMusIljXPck7zuxZgrrpQ9rpMWE6rkmIF1dqui1Atx7lVmZR
        fRuvd5HBORnAwCzWSL6prQ0=
X-Google-Smtp-Source: APXvYqwZhVcWLcicdqOVfQu7fUXb3Xm9E191b7qowkc60EH7DUDD2UluM94PJ05/Yg9g5Vecq05kMg==
X-Received: by 2002:a62:e817:: with SMTP id c23mr30601852pfi.24.1575915197626;
        Mon, 09 Dec 2019 10:13:17 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.10])
        by smtp.gmail.com with ESMTPSA id q21sm139129pff.105.2019.12.09.10.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:13:16 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v7 1/2] ufs: Avoid busy-waiting by eliminating tag conflicts
Date:   Mon,  9 Dec 2019 10:13:08 -0800
Message-Id: <20191209181309.196233-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209181309.196233-1-bvanassche@acm.org>
References: <20191209181309.196233-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of tracking which tags are in use in the ufs_hba.lrb_in_use
bitmask, rely on the block layer tag allocation mechanism. This patch
removes the following busy-waiting loop if ufshcd_issue_devman_upiu_cmd()
and the block layer accidentally allocate the same tag for a SCSI request:
* ufshcd_queuecommand() returns SCSI_MLQUEUE_HOST_BUSY.
* The SCSI core requeues the SCSI command.

Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 121 +++++++++++++++-----------------------
 drivers/scsi/ufs/ufshcd.h |   6 +-
 2 files changed, 50 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index deca1538e184..7b3649111b4e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -497,8 +497,8 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 static void ufshcd_print_host_state(struct ufs_hba *hba)
 {
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
-	dev_err(hba->dev, "lrb in use=0x%lx, outstanding reqs=0x%lx tasks=0x%lx\n",
-		hba->lrb_in_use, hba->outstanding_reqs, hba->outstanding_tasks);
+	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
+		hba->outstanding_reqs, hba->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
 		hba->saved_err, hba->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
@@ -1273,6 +1273,24 @@ static int ufshcd_devfreq_target(struct device *dev,
 	return ret;
 }
 
+static bool ufshcd_is_busy(struct request *req, void *priv, bool reserved)
+{
+	int *busy = priv;
+
+	WARN_ON_ONCE(reserved);
+	(*busy)++;
+	return false;
+}
+
+/* Whether or not any tag is in use by a request that is in progress. */
+static bool ufshcd_any_tag_in_use(struct ufs_hba *hba)
+{
+	struct request_queue *q = hba->cmd_queue;
+	int busy = 0;
+
+	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_is_busy, &busy);
+	return busy;
+}
 
 static int ufshcd_devfreq_get_dev_status(struct device *dev,
 		struct devfreq_dev_status *stat)
@@ -1619,7 +1637,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 
 	if (hba->clk_gating.active_reqs
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| hba->lrb_in_use || hba->outstanding_tasks
+		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
 		|| hba->active_uic_cmd || hba->uic_async_done)
 		goto rel_lock;
 
@@ -1673,7 +1691,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| hba->lrb_in_use || hba->outstanding_tasks
+		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
 		|| hba->active_uic_cmd || hba->uic_async_done
 		|| ufshcd_eh_in_progress(hba))
 		return;
@@ -2443,22 +2461,9 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	hba->req_abort_count = 0;
 
-	/* acquire the tag to make sure device cmds don't use it */
-	if (test_and_set_bit_lock(tag, &hba->lrb_in_use)) {
-		/*
-		 * Dev manage command in progress, requeue the command.
-		 * Requeuing the command helps in cases where the request *may*
-		 * find different tag instead of waiting for dev manage command
-		 * completion.
-		 */
-		err = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
-	}
-
 	err = ufshcd_hold(hba, true);
 	if (err) {
 		err = SCSI_MLQUEUE_HOST_BUSY;
-		clear_bit_unlock(tag, &hba->lrb_in_use);
 		goto out;
 	}
 	WARN_ON(hba->clk_gating.state != CLKS_ON);
@@ -2479,7 +2484,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
-		clear_bit_unlock(tag, &hba->lrb_in_use);
 		goto out;
 	}
 	/* Make sure descriptors are ready before ringing the doorbell */
@@ -2626,44 +2630,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 	return err;
 }
 
-/**
- * ufshcd_get_dev_cmd_tag - Get device management command tag
- * @hba: per-adapter instance
- * @tag_out: pointer to variable with available slot value
- *
- * Get a free slot and lock it until device management command
- * completes.
- *
- * Returns false if free slot is unavailable for locking, else
- * return true with tag value in @tag.
- */
-static bool ufshcd_get_dev_cmd_tag(struct ufs_hba *hba, int *tag_out)
-{
-	int tag;
-	bool ret = false;
-	unsigned long tmp;
-
-	if (!tag_out)
-		goto out;
-
-	do {
-		tmp = ~hba->lrb_in_use;
-		tag = find_last_bit(&tmp, hba->nutrs);
-		if (tag >= hba->nutrs)
-			goto out;
-	} while (test_and_set_bit_lock(tag, &hba->lrb_in_use));
-
-	*tag_out = tag;
-	ret = true;
-out:
-	return ret;
-}
-
-static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
-{
-	clear_bit_unlock(tag, &hba->lrb_in_use);
-}
-
 /**
  * ufshcd_exec_dev_cmd - API for sending device management requests
  * @hba: UFS hba
@@ -2676,6 +2642,8 @@ static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
+	struct request_queue *q = hba->cmd_queue;
+	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err;
 	int tag;
@@ -2689,7 +2657,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by SCSI request timeout.
 	 */
-	wait_event(hba->dev_cmd.tag_wq, ufshcd_get_dev_cmd_tag(hba, &tag));
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	tag = req->tag;
+	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
@@ -2714,8 +2686,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 			err ? "query_complete_err" : "query_complete");
 
 out_put_tag:
-	ufshcd_put_dev_cmd_tag(hba, tag);
-	wake_up(&hba->dev_cmd.tag_wq);
+	blk_put_request(req);
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -4856,7 +4827,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
-			clear_bit_unlock(index, &hba->lrb_in_use);
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
@@ -4878,9 +4848,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	hba->outstanding_reqs ^= completed_reqs;
 
 	ufshcd_clk_scaling_update_busy(hba);
-
-	/* we might have free'd some tags above */
-	wake_up(&hba->dev_cmd.tag_wq);
 }
 
 /**
@@ -5876,6 +5843,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					enum dev_cmd_type cmd_type,
 					enum query_opcode desc_op)
 {
+	struct request_queue *q = hba->cmd_queue;
+	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 	int tag;
@@ -5885,7 +5854,11 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	down_read(&hba->clk_scaling_lock);
 
-	wait_event(hba->dev_cmd.tag_wq, ufshcd_get_dev_cmd_tag(hba, &tag));
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	tag = req->tag;
+	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
@@ -5961,8 +5934,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		}
 	}
 
-	ufshcd_put_dev_cmd_tag(hba, tag);
-	wake_up(&hba->dev_cmd.tag_wq);
+	blk_put_request(req);
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -6257,9 +6229,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	hba->lrb[tag].cmd = NULL;
 	spin_unlock_irqrestore(host->host_lock, flags);
 
-	clear_bit_unlock(tag, &hba->lrb_in_use);
-	wake_up(&hba->dev_cmd.tag_wq);
-
 out:
 	if (!err) {
 		err = SUCCESS;
@@ -8263,6 +8232,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	blk_cleanup_queue(hba->cmd_queue);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
@@ -8426,9 +8396,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	init_rwsem(&hba->clk_scaling_lock);
 
-	/* Initialize device management tag acquire wait queue */
-	init_waitqueue_head(&hba->dev_cmd.tag_wq);
-
 	ufshcd_init_clk_gating(hba);
 
 	ufshcd_init_clk_scaling(hba);
@@ -8462,6 +8429,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto exit_gating;
 	}
 
+	hba->cmd_queue = blk_mq_init_queue(&hba->host->tag_set);
+	if (IS_ERR(hba->cmd_queue)) {
+		err = PTR_ERR(hba->cmd_queue);
+		goto out_remove_scsi_host;
+	}
+
 	/* Reset the attached device */
 	ufshcd_vops_device_reset(hba);
 
@@ -8471,7 +8444,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_host_regs(hba);
 		ufshcd_print_host_state(hba);
-		goto out_remove_scsi_host;
+		goto free_cmd_queue;
 	}
 
 	/*
@@ -8508,6 +8481,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	return 0;
 
+free_cmd_queue:
+	blk_cleanup_queue(hba->cmd_queue);
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 exit_gating:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2740f6941ec6..56b9da6db1cc 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -212,13 +212,11 @@ struct ufs_query {
  * @type: device management command type - Query, NOP OUT
  * @lock: lock to allow one command at a time
  * @complete: internal commands completion
- * @tag_wq: wait queue until free command slot is available
  */
 struct ufs_dev_cmd {
 	enum dev_cmd_type type;
 	struct mutex lock;
 	struct completion *complete;
-	wait_queue_head_t tag_wq;
 	struct ufs_query query;
 };
 
@@ -483,7 +481,7 @@ struct ufs_stats {
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
  * @lrb: local reference block
- * @lrb_in_use: lrb in use
+ * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_reqs: Bits representing outstanding transfer requests
  * @capabilities: UFS Controller Capabilities
@@ -541,6 +539,7 @@ struct ufs_hba {
 
 	struct Scsi_Host *host;
 	struct device *dev;
+	struct request_queue *cmd_queue;
 	/*
 	 * This field is to keep a reference to "scsi_device" corresponding to
 	 * "UFS device" W-LU.
@@ -561,7 +560,6 @@ struct ufs_hba {
 	u32 ahit;
 
 	struct ufshcd_lrb *lrb;
-	unsigned long lrb_in_use;
 
 	unsigned long outstanding_tasks;
 	unsigned long outstanding_reqs;
