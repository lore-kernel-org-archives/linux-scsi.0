Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC085C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241095AbhK3Xhu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:50 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:39566 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhK3Xht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:49 -0500
Received: by mail-pg1-f181.google.com with SMTP id r5so21486521pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WtZRiMZiXejpaLTrbZn8XfgRNYsyVCWYUCazi6KKYBM=;
        b=XSarRX3Ai3x5qa5meInd74JygnoSf5knIbJryxtig8Zq7MhEbkTlJYQRTGgrvSBx2I
         +RfbMTFHJMNfmMBczQZpa9YtzVYc8vV7FdRL2rAySAmVEcPoxr5TBhqZwcbUFqTruXvc
         LRe9iogMHzuEKb+fQZ5akPwj6tzvMGNfFVrsCG7a1+aZTsiCsOSkDnzMETdYVHALIrNW
         NYEq0QbGDK9MS7fo78Mfw4IsJuzec2/1cII95R9jsgZjCApOJkcYN9ZqYYGY2LtV5gbC
         3lw++JALM2N6PhoG9RHFBy8RXpxcH6JcBGsSDd/c6oF/7UbjhouDPKzIgMkhZULh/GJw
         SyXg==
X-Gm-Message-State: AOAM5307CwAXm+vKBwWH7X2Dmxrg2LTkVrbnfQkFqKeR5UEOre7bNZi0
        hCN/ShS8gxo7BYCEGiJC4Es=
X-Google-Smtp-Source: ABdhPJxluhLseoBwqtUZPS/tm03gQMfYMuQahhtHJy7XhrWxCw++jOpkTlDk4ygSkLgkxmfUSmwNRw==
X-Received: by 2002:a63:9:: with SMTP id 9mr1861652pga.91.1638315269600;
        Tue, 30 Nov 2021 15:34:29 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 10/17] scsi: ufs: Fix a deadlock in the error handler
Date:   Tue, 30 Nov 2021 15:33:17 -0800
Message-Id: <20211130233324.1402448-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following deadlock has been observed on a test setup:
* All tags allocated.
* The SCSI error handler calls ufshcd_eh_host_reset_handler()
* ufshcd_eh_host_reset_handler() queues work that calls ufshcd_err_handler()
* ufshcd_err_handler() locks up as follows:

Workqueue: ufs_eh_wq_0 ufshcd_err_handler.cfi_jt
Call trace:
 __switch_to+0x298/0x5d8
 __schedule+0x6cc/0xa94
 schedule+0x12c/0x298
 blk_mq_get_tag+0x210/0x480
 __blk_mq_alloc_request+0x1c8/0x284
 blk_get_request+0x74/0x134
 ufshcd_exec_dev_cmd+0x68/0x640
 ufshcd_verify_dev_init+0x68/0x35c
 ufshcd_probe_hba+0x12c/0x1cb8
 ufshcd_host_reset_and_restore+0x88/0x254
 ufshcd_reset_and_restore+0xd0/0x354
 ufshcd_err_handler+0x408/0xc58
 process_one_work+0x24c/0x66c
 worker_thread+0x3e8/0xa4c
 kthread+0x150/0x1b4
 ret_from_fork+0x10/0x30

Fix this lockup by making ufshcd_exec_dev_cmd() allocate a reserved
request.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 53 +++++++++++----------------------------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 16 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2d0f59424b00..da4714aaa850 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -128,8 +128,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
-	UFSHCD_CMD_PER_LUN	= 32,
-	UFSHCD_CAN_QUEUE	= 32,
+	UFSHCD_NUM_RESERVED	= 1,
+	UFSHCD_CMD_PER_LUN	= 32 - UFSHCD_NUM_RESERVED,
+	UFSHCD_CAN_QUEUE	= 32 - UFSHCD_NUM_RESERVED,
 };
 
 static const char *const ufshcd_state_name[] = {
@@ -2170,6 +2171,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
 	hba->nutmrs =
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
+	hba->reserved_slot = hba->nutrs - 1;
 
 	/* Read crypto capabilities */
 	err = ufshcd_hba_init_crypto_capabilities(hba);
@@ -2912,30 +2914,15 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
-	struct request_queue *q = hba->cmd_queue;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request *req;
+	const u32 tag = hba->reserved_slot;
 	struct ufshcd_lrb *lrbp;
 	int err;
-	int tag;
 
-	down_read(&hba->clk_scaling_lock);
+	/* Protects use of hba->reserved_slot. */
+	lockdep_assert_held(&hba->dev_cmd.lock);
 
-	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by SCSI request timeout.
-	 */
-	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto out_unlock;
-	}
-	tag = req->tag;
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
-	/* Set the timeout such that the SCSI error handler is not activated. */
-	req->timeout = msecs_to_jiffies(2 * timeout);
-	blk_mq_start_request(req);
+	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
@@ -2953,8 +2940,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out:
-	blk_mq_free_request(req);
-out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -6689,23 +6674,16 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					enum dev_cmd_type cmd_type,
 					enum query_opcode desc_op)
 {
-	struct request_queue *q = hba->cmd_queue;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request *req;
+	const u32 tag = hba->reserved_slot;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
-	int tag;
 	u8 upiu_flags;
 
-	down_read(&hba->clk_scaling_lock);
+	/* Protects use of hba->reserved_slot. */
+	lockdep_assert_held(&hba->dev_cmd.lock);
 
-	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto out_unlock;
-	}
-	tag = req->tag;
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
@@ -6774,9 +6752,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-	blk_mq_free_request(req);
-
-out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -9507,8 +9482,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Configure LRB */
 	ufshcd_host_memory_configure(hba);
 
-	host->can_queue = hba->nutrs;
-	host->cmd_per_lun = hba->nutrs;
+	host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
+	host->cmd_per_lun = hba->nutrs - UFSHCD_NUM_RESERVED;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFS_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index ecc6c545a19d..c3c2792f309f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -745,6 +745,7 @@ struct ufs_hba_monitor {
  * @capabilities: UFS Controller Capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
+ * @reserved_slot: Used to submit device commands. Protected by @dev_cmd.lock.
  * @ufs_version: UFS Version to which controller complies
  * @vops: pointer to variant specific operations
  * @priv: pointer to variant specific private data
@@ -836,6 +837,7 @@ struct ufs_hba {
 	u32 capabilities;
 	int nutrs;
 	int nutmrs;
+	u32 reserved_slot;
 	u32 ufs_version;
 	const struct ufs_hba_variant_ops *vops;
 	struct ufs_hba_variant_params *vps;
