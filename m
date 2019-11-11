Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45477C17441
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 17:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6352173B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 17:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKKRsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:48:52 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43081 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfKKRsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 12:48:52 -0500
Received: by mail-pf1-f193.google.com with SMTP id 3so11126290pfb.10
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 09:48:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9yQcClbsRDzmRSZmq2PMM/2y+7R6cxwiqhylqdVDURQ=;
        b=bB1pow2yx4wImL7uRaVL0MWtsJqYnZB7VbamcpJ28bm2ZwVNnrEdsJ41r6znDQeHW/
         F6PWuBuP3E8kmJYtezdMKtWVSbedQJL0rYxfY+5j2A5ho2EE8oMq8lUSuQhwTb4MyfVD
         IDC5S/Enty3JEVqLf27wW4d4zDTSfxBk/bWVf+wTmQVW/OP2TO38hiqnZxpOIbAYgx4s
         hxRnqTs+8/YF/WWsT8eyAp/koUhdXQSUQJzphwwi750dHrU8FKzbR8AU67IaRgDdqQbS
         Bh7L81boShAu+PSE9oVG1g6bGh8wWvNHKDkTNacU+r7+ZKZiXmWABKz3E8NIkT+rpTSZ
         QsHA==
X-Gm-Message-State: APjAAAUvpp1P7E5MJ3x4Es0zt9BkgkXTgnHbtkeffCx9osrX6LDnhOdP
        ORa1Q6Gu84BDsdxFg9xeHDc=
X-Google-Smtp-Source: APXvYqwKZIdBh4cQ3L4LkfV3DPKz0Yu8c1XbAcU3NtMB3LfaWfxgwBgghU2Zhm5K/LxfrrcVTYlUDw==
X-Received: by 2002:a17:90a:9286:: with SMTP id n6mr283403pjo.84.1573494531755;
        Mon, 11 Nov 2019 09:48:51 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p123sm18126763pfg.30.2019.11.11.09.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 09:48:50 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     Bean Huo <beanhuo@micron.com>, Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v4 2/3] ufs: Use blk_{get,put}_request() to allocate and free TMFs
Date:   Mon, 11 Nov 2019 09:48:40 -0800
Message-Id: <20191111174841.185278-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191111174841.185278-1-bvanassche@acm.org>
References: <20191111174841.185278-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Manage TMF tags with blk_{get,put}_request() instead of
ufshcd_get_tm_free_slot() / ufshcd_put_tm_slot(). Store a per-request
completion pointer in request.end_io_data instead of using a waitqueue
to report TMF completion.

Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 122 +++++++++++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h |  12 ++--
 2 files changed, 77 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 93c920bf77d2..00c567bbbb64 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -645,40 +645,6 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 	return le32_to_cpu(lrbp->utr_descriptor_ptr->header.dword_2) & MASK_OCS;
 }
 
-/**
- * ufshcd_get_tm_free_slot - get a free slot for task management request
- * @hba: per adapter instance
- * @free_slot: pointer to variable with available slot value
- *
- * Get a free tag and lock it until ufshcd_put_tm_slot() is called.
- * Returns 0 if free slot is not available, else return 1 with tag value
- * in @free_slot.
- */
-static bool ufshcd_get_tm_free_slot(struct ufs_hba *hba, int *free_slot)
-{
-	int tag;
-	bool ret = false;
-
-	if (!free_slot)
-		goto out;
-
-	do {
-		tag = find_first_zero_bit(&hba->tm_slots_in_use, hba->nutmrs);
-		if (tag >= hba->nutmrs)
-			goto out;
-	} while (test_and_set_bit_lock(tag, &hba->tm_slots_in_use));
-
-	*free_slot = tag;
-	ret = true;
-out:
-	return ret;
-}
-
-static inline void ufshcd_put_tm_slot(struct ufs_hba *hba, int slot)
-{
-	clear_bit_unlock(slot, &hba->tm_slots_in_use);
-}
-
 /**
  * ufshcd_utrl_clear - Clear a bit in UTRLCLR register
  * @hba: per adapter instance
@@ -5517,17 +5483,38 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 	 */
 }
 
+struct ctm_info {
+	struct ufs_hba *hba;
+	unsigned long pending;
+};
+
+static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
+{
+	const struct ctm_info *const ci = priv;
+	struct completion *c;
+
+	WARN_ON_ONCE(reserved);
+	if (test_bit(req->tag, &ci->pending))
+		return true;
+	c = req->end_io_data;
+	if (c)
+		complete(c);
+	return true;
+}
+
 /**
  * ufshcd_tmc_handler - handle task management function completion
  * @hba: per adapter instance
  */
 static void ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	u32 tm_doorbell;
+	struct request_queue *q = hba->tmf_queue;
+	struct ctm_info ci = {
+		.hba	 = hba,
+		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
+	};
 
-	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
-	wake_up(&hba->tm_wq);
+	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
 }
 
 /**
@@ -5620,7 +5607,10 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		struct utp_task_req_desc *treq, u8 tm_function)
 {
+	struct request_queue *q = hba->tmf_queue;
 	struct Scsi_Host *host = hba->host;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request *req;
 	unsigned long flags;
 	int free_slot, task_tag, err;
 
@@ -5629,7 +5619,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
 	 */
-	wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba, &free_slot));
+	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
+	req->end_io_data = &wait;
+	free_slot = req->tag;
+	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
@@ -5655,10 +5648,14 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_send");
 
 	/* wait until the task management command is completed */
-	err = wait_event_timeout(hba->tm_wq,
-			test_bit(free_slot, &hba->tm_condition),
+	err = wait_for_completion_io_timeout(&wait,
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
+		/*
+		 * Make sure that ufshcd_compl_tm() does not trigger a
+		 * use-after-free.
+		 */
+		req->end_io_data = NULL;
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete_err");
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
@@ -5677,9 +5674,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	__clear_bit(free_slot, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	clear_bit(free_slot, &hba->tm_condition);
-	ufshcd_put_tm_slot(hba, free_slot);
-	wake_up(&hba->tm_tag_wq);
+	blk_put_request(req);
 
 	ufshcd_release(hba);
 	return err;
@@ -8142,6 +8137,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	blk_cleanup_queue(hba->tmf_queue);
+	blk_mq_free_tag_set(&hba->tmf_tag_set);
 	blk_cleanup_queue(hba->cmd_queue);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
@@ -8221,6 +8218,18 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 }
 EXPORT_SYMBOL(ufshcd_alloc_host);
 
+/* This function exists because blk_mq_alloc_tag_set() requires this. */
+static blk_status_t ufshcd_queue_tmf(struct blk_mq_hw_ctx *hctx,
+				     const struct blk_mq_queue_data *qd)
+{
+	WARN_ON_ONCE(true);
+	return BLK_STS_NOTSUPP;
+}
+
+static const struct blk_mq_ops ufshcd_tmf_ops = {
+	.queue_rq = ufshcd_queue_tmf,
+};
+
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -8290,10 +8299,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	hba->max_pwr_info.is_valid = false;
 
-	/* Initailize wait queue for task management */
-	init_waitqueue_head(&hba->tm_wq);
-	init_waitqueue_head(&hba->tm_tag_wq);
-
 	/* Initialize work queues */
 	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
@@ -8344,6 +8349,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if (!hba->cmd_queue)
 		goto out_remove_scsi_host;
 
+	hba->tmf_tag_set = (struct blk_mq_tag_set) {
+		.nr_hw_queues	= 1,
+		.queue_depth	= hba->nutmrs,
+		.ops		= &ufshcd_tmf_ops,
+		.flags		= BLK_MQ_F_NO_SCHED,
+	};
+	err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
+	if (err < 0)
+		goto free_cmd_queue;
+	hba->tmf_queue = blk_mq_init_queue(&hba->tmf_tag_set);
+	if (IS_ERR(hba->tmf_queue)) {
+		err = PTR_ERR(hba->tmf_queue);
+		goto free_tmf_tag_set;
+	}
+
 	/* Reset the attached device */
 	ufshcd_vops_device_reset(hba);
 
@@ -8353,7 +8373,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_host_regs(hba);
 		ufshcd_print_host_state(hba);
-		goto free_cmd_queue;
+		goto free_tmf_queue;
 	}
 
 	/*
@@ -8390,6 +8410,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	return 0;
 
+free_tmf_queue:
+	blk_cleanup_queue(hba->tmf_queue);
+free_tmf_tag_set:
+	blk_mq_free_tag_set(&hba->tmf_tag_set);
 free_cmd_queue:
 	blk_cleanup_queue(hba->cmd_queue);
 out_remove_scsi_host:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6d9521892a84..5865e16f53a6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -493,11 +493,9 @@ struct ufs_stats {
  * @irq: Irq number of the controller
  * @active_uic_cmd: handle of active UIC command
  * @uic_cmd_mutex: mutex for uic command
- * @tm_wq: wait queue for task management
- * @tm_tag_wq: wait queue for free task management slots
- * @tm_slots_in_use: bit map of task management request slots in use
+ * @tmf_tag_set: TMF tag set.
+ * @tmf_queue: Used to allocate TMF tags.
  * @pwr_done: completion for power mode change
- * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
  * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
@@ -641,10 +639,8 @@ struct ufs_hba {
 	/* Device deviations from standard UFS device spec. */
 	unsigned int dev_quirks;
 
-	wait_queue_head_t tm_wq;
-	wait_queue_head_t tm_tag_wq;
-	unsigned long tm_condition;
-	unsigned long tm_slots_in_use;
+	struct blk_mq_tag_set tmf_tag_set;
+	struct request_queue *tmf_queue;
 
 	struct uic_command *active_uic_cmd;
 	struct mutex uic_cmd_mutex;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

