Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CC0CA9ECE
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 22:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 375C120862
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 22:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfJaWzj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 18:55:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45676 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfJaWzi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 18:55:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id r1so5076161pgj.12
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2019 15:55:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EEOV50IZRPg32q0FSFfXKmFxs3kNH9cfwbJA85sPBQk=;
        b=FrpdeyN6Y8dRplfM3tyjLqXc/9cwu3n8QCrP1OK68ni+eQEgNiowzrpzNUPl0dSRnN
         xTQ/eNi9fvCzfrFmoFm0b9W5ep3dN5N6crONROS3Tp8UNk4j6Z2k43kXvXYXQTbcGIsL
         ZN4d1+eIvEVut5XAAdG7nEqbvj8PH+l7NNN4sa2K+iQjAfcoiKSnvq6gJJqHtngYYzoD
         15u+/mDtSzh3DTAfYw+n/Akkz363r5rEYh9jMaU6Mwf3jcgCPgNz81qS7XabmSj17QXS
         mK2KUQfd9lpYsOKTp0i3oIF4JxsNSV68xw3Db5tmZLl74v3r4RrDOfKp/Khi4/k6fiO2
         tZwg==
X-Gm-Message-State: APjAAAXDskYt2in1KHodoAE1KokuGaH0CgG2vy1UNbZZts1prYZM5y+3
        TTCTd802ySnrebubG9gqZQM=
X-Google-Smtp-Source: APXvYqyO0CRrcbVI5rY8t7goof3GiwmMRcCp/nuJrcRhDL7BV+C/FwbXdUDZOfOyumwVOV3mrbGetw==
X-Received: by 2002:a17:90a:26c1:: with SMTP id m59mr10883959pje.101.1572562537216;
        Thu, 31 Oct 2019 15:55:37 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id d139sm8391711pfd.162.2019.10.31.15.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:55:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/4] ufs: Simplify the clock scaling mechanism implementation
Date:   Thu, 31 Oct 2019 15:55:26 -0700
Message-Id: <20191031225528.233895-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191031225528.233895-1-bvanassche@acm.org>
References: <20191031225528.233895-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Scaling the clock is only safe while no commands are in progress. Use
blk_mq_{un,}freeze_queue() to block submission of new commands and to
wait for ongoing commands to complete.

Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 131 ++++++++++++--------------------------
 drivers/scsi/ufs/ufshcd.h |   3 -
 2 files changed, 40 insertions(+), 94 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da9677fb2d5d..b7e27d86a0ec 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -292,14 +292,46 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
 
 static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
 {
-	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
-		scsi_unblock_requests(hba->host);
+	struct scsi_device *sdev;
+
+	blk_mq_unfreeze_queue(hba->tag_alloc_queue);
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
 }
 
-static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
+static int ufshcd_scsi_block_requests(struct ufs_hba *hba,
+				      unsigned long timeout)
 {
-	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
-		scsi_block_requests(hba->host);
+	struct scsi_device *sdev;
+	unsigned long deadline = jiffies + timeout;
+	bool success = true;
+
+	if (timeout == ULONG_MAX) {
+		shost_for_each_device(sdev, hba->host)
+			blk_mq_freeze_queue(sdev->request_queue);
+		blk_mq_freeze_queue(hba->tag_alloc_queue);
+		return 0;
+	}
+
+	shost_for_each_device(sdev, hba->host)
+		blk_freeze_queue_start(sdev->request_queue);
+	blk_freeze_queue_start(hba->tag_alloc_queue);
+	if (blk_mq_freeze_queue_wait_timeout(hba->tag_alloc_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0)
+		goto err;
+	shost_for_each_device(sdev, hba->host) {
+		if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
+				max_t(long, 0, deadline - jiffies)) <= 0) {
+			success = false;
+			break;
+		}
+	}
+	if (!success) {
+err:
+		ufshcd_scsi_unblock_requests(hba);
+		return -ETIMEDOUT;
+	}
+	return 0;
 }
 
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -1005,65 +1037,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
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
@@ -1113,26 +1086,15 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 
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
+	return ufshcd_scsi_block_requests(hba, HZ);
 }
 
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 {
-	up_write(&hba->clk_scaling_lock);
 	ufshcd_scsi_unblock_requests(hba);
 }
 
@@ -1562,7 +1524,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		/* fallthrough */
 	case CLKS_OFF:
-		ufshcd_scsi_block_requests(hba);
+		ufshcd_scsi_block_requests(hba, ULONG_MAX);
 		hba->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
@@ -2428,9 +2390,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		BUG();
 	}
 
-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
@@ -2495,7 +2454,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -2649,8 +2607,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	struct completion wait;
 	unsigned long flags;
 
-	down_read(&hba->clk_scaling_lock);
-
 	/*
 	 * Get free slot, sleep if slots are unavailable.
 	 * Even though we use wait_event() which sleeps indefinitely,
@@ -2684,7 +2640,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 out_put_tag:
 	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -5483,7 +5438,7 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 		/* handle fatal errors only when link is functional */
 		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
 			/* block commands from scsi mid-layer */
-			ufshcd_scsi_block_requests(hba);
+			ufshcd_scsi_block_requests(hba, ULONG_MAX);
 
 			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
 
@@ -5760,8 +5715,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	unsigned long flags;
 	u32 upiu_flags;
 
-	down_read(&hba->clk_scaling_lock);
-
 	req = blk_get_request(q, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -5840,7 +5793,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	}
 
 	blk_put_request(req);
-	up_read(&hba->clk_scaling_lock);
 	return err;
 }
 
@@ -8320,8 +8272,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize mutex for device management commands */
 	mutex_init(&hba->dev_cmd.lock);
 
-	init_rwsem(&hba->clk_scaling_lock);
-
 	ufshcd_init_clk_gating(hba);
 
 	ufshcd_init_clk_scaling(hba);
@@ -8387,7 +8337,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
-	atomic_set(&hba->scsi_block_reqs_cnt, 0);
 	/*
 	 * We are assuming that device wasn't put in sleep/power-down
 	 * state exclusively during the boot stage before kernel.
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8fa33fb71237..fd88a9de3519 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -522,7 +522,6 @@ struct ufs_stats {
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
- * @scsi_block_reqs_cnt: reference counting for scsi block requests
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -728,9 +727,7 @@ struct ufs_hba {
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
 
-	struct rw_semaphore clk_scaling_lock;
 	struct ufs_desc_size desc_size;
-	atomic_t scsi_block_reqs_cnt;
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
-- 
2.24.0.rc0.303.g954a862665-goog

