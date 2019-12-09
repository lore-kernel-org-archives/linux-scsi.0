Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAE5C04E30
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C470B206D3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfLISNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:13:20 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:39007 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLISNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:13:20 -0500
Received: by mail-pf1-f172.google.com with SMTP id 2so7627760pfx.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 10:13:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BkrNWWFjmO6CmQrGA6EbrNNmxT5DhfxdzSQwN3I0qzU=;
        b=LTRdUVzo4Ggm7qvI+ObgRJgyY43Nm0rUEPJq8VJ/X0Y36puAXTn24laOdUNvXB4L5l
         yDjWVBG8d5PrVK9zDIUEPh4BsaIT/q1ExsVsl631wNjKuAC2GflVUe1dZ1duLu4T55rq
         Q1fJx8ZUVIeQ06nAkFvtmk5P3+GFLN+cTH3OSCD/xI9Mt5FBRb1v3E7wnWAym55Ie316
         lL+T7vT2Zy/JnmxNHp//gz1XOZHD1mw67PYlJz+29aQ5wxMliE6OkN3qYRrgAX8S3Kea
         sLiA3CR6qU2WjXqL29gOUxs+hFT4Mt3hdaGVKINegItU3OHrEfaIPp5Bpsnxye1BR34t
         njuQ==
X-Gm-Message-State: APjAAAWixZSuxtRR+uttsGSWYKEOMnjpLJz398yJ1/LXtXOvfnT2mZcp
        SK5PWyHjUVA63FAz6FSCvcI=
X-Google-Smtp-Source: APXvYqy4Yb8kY3byH20TMdVrQtlhJRmaPlU3Jvh2nu/DDZoDPuLJX1q9DwK+csyh8KX7Dxqhf3aL4A==
X-Received: by 2002:a62:be12:: with SMTP id l18mr23239642pff.206.1575915199291;
        Mon, 09 Dec 2019 10:13:19 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.10])
        by smtp.gmail.com with ESMTPSA id q21sm139129pff.105.2019.12.09.10.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:13:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v7 2/2] ufs: Use blk_{get,put}_request() to allocate and free TMFs
Date:   Mon,  9 Dec 2019 10:13:09 -0800
Message-Id: <20191209181309.196233-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209181309.196233-1-bvanassche@acm.org>
References: <20191209181309.196233-1-bvanassche@acm.org>
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
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 130 ++++++++++++++++++++++----------------
 drivers/scsi/ufs/ufshcd.h |  12 ++--
 2 files changed, 80 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7b3649111b4e..99337e0b54f6 100644
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
@@ -5583,6 +5549,27 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 	return retval;
 }
 
+struct ctm_info {
+	struct ufs_hba	*hba;
+	unsigned long	pending;
+	unsigned int	ncpl;
+};
+
+static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
+{
+	struct ctm_info *const ci = priv;
+	struct completion *c;
+
+	WARN_ON_ONCE(reserved);
+	if (test_bit(req->tag, &ci->pending))
+		return true;
+	ci->ncpl++;
+	c = req->end_io_data;
+	if (c)
+		complete(c);
+	return true;
+}
+
 /**
  * ufshcd_tmc_handler - handle task management function completion
  * @hba: per adapter instance
@@ -5593,16 +5580,14 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	u32 tm_doorbell;
+	struct request_queue *q = hba->tmf_queue;
+	struct ctm_info ci = {
+		.hba	 = hba,
+		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
+	};
 
-	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
-	if (hba->tm_condition) {
-		wake_up(&hba->tm_wq);
-		return IRQ_HANDLED;
-	} else {
-		return IRQ_NONE;
-	}
+	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
 }
 
 /**
@@ -5708,7 +5693,10 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		struct utp_task_req_desc *treq, u8 tm_function)
 {
+	struct request_queue *q = hba->tmf_queue;
 	struct Scsi_Host *host = hba->host;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request *req;
 	unsigned long flags;
 	int free_slot, task_tag, err;
 
@@ -5717,7 +5705,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
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
@@ -5743,10 +5734,14 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
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
@@ -5765,9 +5760,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	__clear_bit(free_slot, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	clear_bit(free_slot, &hba->tm_condition);
-	ufshcd_put_tm_slot(hba, free_slot);
-	wake_up(&hba->tm_tag_wq);
+	blk_put_request(req);
 
 	ufshcd_release(hba);
 	return err;
@@ -8232,6 +8225,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	blk_cleanup_queue(hba->tmf_queue);
+	blk_mq_free_tag_set(&hba->tmf_tag_set);
 	blk_cleanup_queue(hba->cmd_queue);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
@@ -8311,6 +8306,18 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
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
@@ -8380,10 +8387,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	hba->max_pwr_info.is_valid = false;
 
-	/* Initailize wait queue for task management */
-	init_waitqueue_head(&hba->tm_wq);
-	init_waitqueue_head(&hba->tm_tag_wq);
-
 	/* Initialize work queues */
 	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
@@ -8435,6 +8438,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_remove_scsi_host;
 	}
 
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
 
@@ -8444,7 +8462,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_host_regs(hba);
 		ufshcd_print_host_state(hba);
-		goto free_cmd_queue;
+		goto free_tmf_queue;
 	}
 
 	/*
@@ -8481,6 +8499,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	return 0;
 
+free_tmf_queue:
+	blk_cleanup_queue(hba->tmf_queue);
+free_tmf_tag_set:
+	blk_mq_free_tag_set(&hba->tmf_tag_set);
 free_cmd_queue:
 	blk_cleanup_queue(hba->cmd_queue);
 out_remove_scsi_host:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 56b9da6db1cc..53bfe175342c 100644
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
