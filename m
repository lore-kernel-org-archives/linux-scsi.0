Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55178C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 426F2610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhKSUB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:56 -0500
Received: from mail-pj1-f42.google.com ([209.85.216.42]:37445 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236210AbhKSUBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:49 -0500
Received: by mail-pj1-f42.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so11778021pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1/KqamDFUllDDt4JBg8BsSRY3ZHEeUO2jb7QeQ204zI=;
        b=daNN48NEmvvPqFm+i5hQ5IeLVGC1+MTkdZL4wPIhCQ3CKxDw3AJJzeX9t2V9nTyqgp
         PSCagEl3yWpqzJmd7zQt4oEc6elyGRLfgo48nFi3HDYzL25cp7rXf2PVcdqFdQU1L5fu
         OS+ItREtJwv6o5sx3Y8zxw/1Z+zyydpq3gFZFiyJMqjUSkUasbLKch8qgFZ9BnMotbCX
         yZX2zDaGb723rvOuiIDBpeLr4tewF1aV1YSTrWCes1fFU4MbLz68ZfI72oaZ/grTKXYy
         1Ob7l0Tct0wEQvITRN7QxeXNXe/8lAIu0djPfyNBoolTF984k17SUsUuGsWga+ym2W6a
         voDw==
X-Gm-Message-State: AOAM533UQP476lC+sJFsK98uDhkCy4UB6uQilpnWch0xhjzoMPPc4Hpo
        ijo4SUdIiaQ2Ws5CIpy7fZA=
X-Google-Smtp-Source: ABdhPJyNDfqpGWCgo/JDagGmZM5Ma3MO8HhKZC41VkPjIuzl5NV6hUK5zw1b/Sg1kLsQWLXjKiRCeQ==
X-Received: by 2002:a17:902:8f97:b0:143:88c2:e2d5 with SMTP id z23-20020a1709028f9700b0014388c2e2d5mr80752499plo.70.1637351927147;
        Fri, 19 Nov 2021 11:58:47 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v2 18/20] scsi: ufs: Optimize the command queueing code
Date:   Fri, 19 Nov 2021 11:57:41 -0800
Message-Id: <20211119195743.2817-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the clock scaling lock from ufshcd_queuecommand() since it is a
performance bottleneck. Freeze request queues instead of polling the
doorbell registers to wait until pending commands have completed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 124 +++++++++++++-------------------------
 drivers/scsi/ufs/ufshcd.h |   1 +
 2 files changed, 44 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a6d3f71c6b00..9cf4a22f1950 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1070,65 +1070,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
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
@@ -1176,37 +1117,63 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 
 static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 {
-	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
-	int ret = 0;
+	struct scsi_device *sdev;
+
 	/*
-	 * make sure that there are no outstanding requests when
-	 * clock scaling is in progress
+	 * Make sure that no commands are in progress while the clock frequency
+	 * is being modified.
+	 *
+	 * Since ufshcd_exec_dev_cmd() and ufshcd_issue_devman_upiu_cmd() lock
+	 * the clk_scaling_lock before calling blk_get_request(), lock
+	 * clk_scaling_lock before freezing the request queues to prevent lock
+	 * inversion.
 	 */
-	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
-
-	if (!hba->clk_scaling.is_allowed ||
-	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
-		ret = -EBUSY;
-		up_write(&hba->clk_scaling_lock);
-		ufshcd_scsi_unblock_requests(hba);
-		goto out;
-	}
-
+	if (!hba->clk_scaling.is_allowed)
+		goto busy;
+	blk_freeze_queue_start(hba->tmf_queue);
+	blk_freeze_queue_start(hba->cmd_queue);
+	shost_for_each_device(sdev, hba->host)
+		blk_freeze_queue_start(sdev->request_queue);
+	/*
+	 * Calling synchronize_rcu_expedited() reduces the time required to
+	 * freeze request queues from milliseconds to microseconds.
+	 */
+	synchronize_rcu_expedited();
+	shost_for_each_device(sdev, hba->host)
+		if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue, HZ)
+		    <= 0)
+			goto unfreeze;
+	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue, HZ) <= 0 ||
+	    blk_mq_freeze_queue_wait_timeout(hba->tmf_queue, HZ / 10) <= 0)
+		goto unfreeze;
 	/* let's not get into low power until clock scaling is completed */
 	ufshcd_hold(hba, false);
+	return 0;
 
-out:
-	return ret;
+unfreeze:
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
+	blk_mq_unfreeze_queue(hba->cmd_queue);
+	blk_mq_unfreeze_queue(hba->tmf_queue);
+
+busy:
+	up_write(&hba->clk_scaling_lock);
+	return -EBUSY;
 }
 
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 {
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
+	blk_mq_unfreeze_queue(hba->cmd_queue);
+	blk_mq_unfreeze_queue(hba->tmf_queue);
 	if (writelock)
 		up_write(&hba->clk_scaling_lock);
 	else
 		up_read(&hba->clk_scaling_lock);
-	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
 
@@ -2699,9 +2666,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	/*
 	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
 	 * calls.
@@ -2790,8 +2754,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 out:
 	rcu_read_unlock();
 
-	up_read(&hba->clk_scaling_lock);
-
 	if (ufs_trigger_eh()) {
 		unsigned long flags;
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e9bc07c69a80..7ec463c97d64 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -778,6 +778,7 @@ struct ufs_hba_monitor {
  * @clk_list_head: UFS host controller clocks list node head
  * @pwr_info: holds current power mode
  * @max_pwr_info: keeps the device max valid pwm
+ * @clk_scaling_lock: used to serialize device commands and clock scaling
  * @desc_size: descriptor sizes reported by device
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
