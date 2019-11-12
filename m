Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F960C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 17:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47997214E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 17:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfKLRh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 12:37:58 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40086 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLRh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 12:37:57 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so12303415pgt.7
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2019 09:37:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RiRLRVszdgbsqnBw0pFkgvYhCnhFTFUd+1RCHFnT5+U=;
        b=m0ATz80zYPBdMM3TaElZ+V1rl8juPcXwXucpoDinQL2xjRi9lumftDU2Bau4vM0RaH
         ZTyxOFUYsbQfELSr6yqxGY5gw14AOF35s5Gt9X9SAJqeX94GY/Q9N111pZAI8jC4DDPd
         1axk+Y5kWdKGcWy3BAjsPAaXJvmI109Ft6K2BBu/aO+5qrs/dwfClpZDSP2fVZ0DELfm
         1Fl6Yhi8FZjCcNUAihr2zUvnJ1csiyWCpihLTkqTx7zPHcNEsnpDQbhyAwMwBP3GM2NO
         rUwvbeOWqA8rk63HHM6qweSxvhFqKgDFxzM03EPw5auF7E2SMowt+pNvTJCWnllPq9gx
         TBag==
X-Gm-Message-State: APjAAAU7WGKKOFlFImb8ivadb858qLuuyrezChYCJ6UZOGxQYexztv8T
        3LQsGGBFP1wiiR8hBbzzHY4=
X-Google-Smtp-Source: APXvYqyBaKgrPv9tREd2bkCZHZ4yYnx9LJjKgN5fVVWRtWnlOLbvR6hoP/QBkM6XEQY/TFx+Kv9csw==
X-Received: by 2002:a17:90a:d818:: with SMTP id a24mr7928574pjv.40.1573580276834;
        Tue, 12 Nov 2019 09:37:56 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w19sm12930969pga.83.2019.11.12.09.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 09:37:56 -0800 (PST)
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
Subject: [PATCH v5 4/4] ufs: Simplify the clock scaling mechanism implementation
Date:   Tue, 12 Nov 2019 09:37:43 -0800
Message-Id: <20191112173743.141503-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191112173743.141503-1-bvanassche@acm.org>
References: <20191112173743.141503-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Scaling the clock is only safe while no commands are in progress. Use
blk_mq_{un,}freeze_queue() to block submission of new commands and to
wait for ongoing commands to complete. Remove "_scsi" from the name of
the functions that block and unblock requests since these functions
now block both SCSI commands and non-SCSI commands.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 141 +++++++++++++-------------------------
 drivers/scsi/ufs/ufshcd.h |   3 -
 2 files changed, 46 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 810b997f55fc..717ba24a2d40 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -290,16 +290,50 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
 	}
 }
 
-static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
+static void ufshcd_unblock_requests(struct ufs_hba *hba)
 {
-	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
-		scsi_unblock_requests(hba->host);
+	struct scsi_device *sdev;
+
+	blk_mq_unfreeze_queue(hba->tmf_queue);
+	blk_mq_unfreeze_queue(hba->cmd_queue);
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
 }
 
-static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
+static int ufshcd_block_requests(struct ufs_hba *hba, unsigned long timeout)
 {
-	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
-		scsi_block_requests(hba->host);
+	struct scsi_device *sdev;
+	unsigned long deadline = jiffies + timeout;
+
+	if (timeout == ULONG_MAX) {
+		shost_for_each_device(sdev, hba->host)
+			blk_mq_freeze_queue(sdev->request_queue);
+		blk_mq_freeze_queue(hba->cmd_queue);
+		blk_mq_freeze_queue(hba->tmf_queue);
+		return 0;
+	}
+
+	shost_for_each_device(sdev, hba->host)
+		blk_freeze_queue_start(sdev->request_queue);
+	blk_freeze_queue_start(hba->cmd_queue);
+	blk_freeze_queue_start(hba->tmf_queue);
+	shost_for_each_device(sdev, hba->host) {
+		if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0) {
+			goto err;
+		}
+	}
+	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0)
+		goto err;
+	if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0)
+		goto err;
+	return 0;
+
+err:
+	ufshcd_unblock_requests(hba);
+	return -ETIMEDOUT;
 }
 
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -971,65 +1005,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
 	return false;
 }
 
-static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
-					u64 wait_timeout_us)
-{
-	unsigned long flags;
-	int ret = 0;
-	u32 tm_doorbell;
-	u32 tr_doorbell;
-	bool timeout = false, do_last_check = false;
-	ktime_t start;
-
-	ufshcd_hold(hba, false);
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	/*
-	 * Wait for all the outstanding tasks/transfer requests.
-	 * Verify by checking the doorbell registers are clear.
-	 */
-	start = ktime_get();
-	do {
-		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		if (!tm_doorbell && !tr_doorbell) {
-			timeout = false;
-			break;
-		} else if (do_last_check) {
-			break;
-		}
-
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		schedule();
-		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
-		    wait_timeout_us) {
-			timeout = true;
-			/*
-			 * We might have scheduled out for long time so make
-			 * sure to check if doorbells are cleared by this time
-			 * or not.
-			 */
-			do_last_check = true;
-		}
-		spin_lock_irqsave(hba->host->host_lock, flags);
-	} while (tm_doorbell || tr_doorbell);
-
-	if (timeout) {
-		dev_err(hba->dev,
-			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
-			__func__, tm_doorbell, tr_doorbell);
-		ret = -EBUSY;
-	}
-out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_release(hba);
-	return ret;
-}
-
 /**
  * ufshcd_scale_gear - scale up/down UFS gear
  * @hba: per adapter instance
@@ -1079,27 +1054,16 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 
 static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 {
-	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
-	int ret = 0;
 	/*
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
-	ufshcd_scsi_block_requests(hba);
-	down_write(&hba->clk_scaling_lock);
-	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
-		ret = -EBUSY;
-		up_write(&hba->clk_scaling_lock);
-		ufshcd_scsi_unblock_requests(hba);
-	}
-
-	return ret;
+	return ufshcd_block_requests(hba, HZ);
 }
 
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 {
-	up_write(&hba->clk_scaling_lock);
-	ufshcd_scsi_unblock_requests(hba);
+	ufshcd_unblock_requests(hba);
 }
 
 /**
@@ -1471,7 +1435,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 		hba->clk_gating.is_suspended = false;
 	}
 unblock_reqs:
-	ufshcd_scsi_unblock_requests(hba);
+	ufshcd_unblock_requests(hba);
 }
 
 /**
@@ -1528,7 +1492,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		/* fallthrough */
 	case CLKS_OFF:
-		ufshcd_scsi_block_requests(hba);
+		ufshcd_block_requests(hba, ULONG_MAX);
 		hba->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
@@ -2395,9 +2359,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		BUG();
 	}
 
-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
@@ -2463,7 +2424,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -2617,8 +2577,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	struct completion wait;
 	unsigned long flags;
 
-	down_read(&hba->clk_scaling_lock);
-
 	/*
 	 * Get free slot, sleep if slots are unavailable.
 	 * Even though we use wait_event() which sleeps indefinitely,
@@ -2654,7 +2612,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 out_put_tag:
 	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -5342,7 +5299,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	if (starget)
 		scsi_target_unblock(&starget->dev, SDEV_RUNNING);
-	ufshcd_scsi_unblock_requests(hba);
+	scsi_unblock_requests(hba->host);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 }
@@ -5466,7 +5423,7 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 		/* handle fatal errors only when link is functional */
 		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
 			/* block commands from scsi mid-layer */
-			ufshcd_scsi_block_requests(hba);
+			scsi_block_requests(hba->host);
 
 			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
 
@@ -5772,8 +5729,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	unsigned long flags;
 	u32 upiu_flags;
 
-	down_read(&hba->clk_scaling_lock);
-
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -5853,7 +5808,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	}
 
 	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -8322,8 +8276,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize mutex for device management commands */
 	mutex_init(&hba->dev_cmd.lock);
 
-	init_rwsem(&hba->clk_scaling_lock);
-
 	ufshcd_init_clk_gating(hba);
 
 	ufshcd_init_clk_scaling(hba);
@@ -8410,7 +8362,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
-	atomic_set(&hba->scsi_block_reqs_cnt, 0);
 	/*
 	 * We are assuming that device wasn't put in sleep/power-down
 	 * state exclusively during the boot stage before kernel.
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5865e16f53a6..c44bfcdb26a3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -520,7 +520,6 @@ struct ufs_stats {
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
- * @scsi_block_reqs_cnt: reference counting for scsi block requests
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -724,9 +723,7 @@ struct ufs_hba {
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
 
-	struct rw_semaphore clk_scaling_lock;
 	struct ufs_desc_size desc_size;
-	atomic_t scsi_block_reqs_cnt;
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
