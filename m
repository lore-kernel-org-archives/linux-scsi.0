Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB31C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E88A761186
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhKJAsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:39 -0500
Received: from mail-pj1-f54.google.com ([209.85.216.54]:39748 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhKJAsj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:39 -0500
Received: by mail-pj1-f54.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so303746pjc.4
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vcopxjIJAsx605lA2hzu0wTuKoBsdX+3qInjC3qG5IQ=;
        b=GVbf/faA48w59XKYQLaaJeZSJxkkCwnX+uLO2x+haIzYeUVK0KMwQBAP/sQVoxsd4I
         u2OsZyi5oNp/ntxv09PHbQcDvLcnjVNObOI6rgHa4x2dZ/SJ66+MZN6qOd0AxlNXSA5e
         tKtSc8jP7a3q+uied2ImSyyketpXD1b+QiKVXp0QlryYEe8ZzJRLJf+/5zrwDoKdceld
         4VtG2tEDJ3F16mQrChXmFZXKl8pmHHFJ6RdIDgehxDV5QlmwdQH8dhxpS3n/fAw9B6J0
         MvYTnUzTBieBY7R/epMY7u1F2yIMHjXkxbEds0K6ugOrw3urY7oIOI9vtoT8wQGG8NTV
         Y/PQ==
X-Gm-Message-State: AOAM530HVTrlSCPAz1n+T0aJv3zIEaWcgWVAa6YQKzvtjGPJRciVXV8K
        757ToK9JkzlIdhfiWjMZccoUB2+nFCRlZA==
X-Google-Smtp-Source: ABdhPJwgz8vrEcZ53li7dre7TClEp1PgD05Ims/ZkjG17jTB72DEVxdHzXoueRVED/ltjDF7BrXlPQ==
X-Received: by 2002:a17:90a:bf0b:: with SMTP id c11mr12122825pjs.208.1636505152174;
        Tue, 09 Nov 2021 16:45:52 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH 10/11] scsi: ufs: Optimize the command queueing code
Date:   Tue,  9 Nov 2021 16:44:39 -0800
Message-Id: <20211110004440.3389311-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the clock scaling lock from ufshcd_queuecommand() since it is a
performance bottleneck. As requested by Asutosh Das, change the behavior
of ufshcd_clock_scaling_prepare() from waiting until all pending
commands have finished into quiescing request queues. Insert a
rcu_read_lock() / rcu_read_unlock() pair in ufshcd_queuecommand() and also
in __ufshcd_issue_tm_cmd(). Use synchronize_rcu_expedited() to wait for
ongoing command and TMF queueing.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 121 +++++++++++++-------------------------
 drivers/scsi/ufs/ufshcd.h |   1 +
 2 files changed, 42 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 13848e93cda8..36df89e8a575 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1069,65 +1069,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
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
@@ -1175,37 +1116,51 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 
 static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 {
-	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
-	int ret = 0;
+	struct scsi_device *sdev;
+
 	/*
-	 * make sure that there are no outstanding requests when
-	 * clock scaling is in progress
+	 * Make sure that no commands are being queued while clock scaling
+	 * is in progress.
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
+	if (!hba->clk_scaling.is_allowed) {
 		up_write(&hba->clk_scaling_lock);
-		ufshcd_scsi_unblock_requests(hba);
-		goto out;
+		return -EBUSY;
 	}
-
+	blk_mq_quiesce_queue_nowait(hba->tmf_queue);
+	blk_mq_quiesce_queue_nowait(hba->cmd_queue);
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_quiesce_queue_nowait(sdev->request_queue);
+	/*
+	 * Calling synchronize_rcu_expedited() reduces the time required to
+	 * quiesce request queues from milliseconds to microseconds.
+	 *
+	 * See also the rcu_read_lock() and rcu_read_unlock() calls in
+	 * ufshcd_queuecommand() and also in __ufshcd_issue_tm_cmd().
+	 */
+	synchronize_rcu_expedited();
 	/* let's not get into low power until clock scaling is completed */
 	ufshcd_hold(hba, false);
-
-out:
-	return ret;
+	return 0;
 }
 
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 {
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unquiesce_queue(sdev->request_queue);
+	blk_mq_unquiesce_queue(hba->cmd_queue);
+	blk_mq_unquiesce_queue(hba->tmf_queue);
 	if (writelock)
 		up_write(&hba->clk_scaling_lock);
 	else
 		up_read(&hba->clk_scaling_lock);
-	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
 
@@ -2698,8 +2653,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
+	/*
+	 * Allows ufshcd_clock_scaling_prepare() and also the UFS error handler
+	 * to wait for prior ufshcd_queuecommand() calls.
+	 */
+	rcu_read_lock();
 
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
@@ -2780,7 +2738,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	ufshcd_send_command(hba, tag);
 out:
-	up_read(&hba->clk_scaling_lock);
+	rcu_read_unlock();
 
 	if (ufs_trigger_eh()) {
 		unsigned long flags;
@@ -5977,8 +5935,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
-	down_write(&hba->clk_scaling_lock);
-	up_write(&hba->clk_scaling_lock);
+	synchronize_rcu();
 	cancel_work_sync(&hba->eeh_work);
 }
 
@@ -6582,6 +6539,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	req->end_io_data = &wait;
 	ufshcd_hold(hba, false);
 
+	rcu_read_lock();
+
 	spin_lock_irqsave(host->host_lock, flags);
 
 	task_tag = req->tag;
@@ -6600,6 +6559,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
+	rcu_read_unlock();
+
 	ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_SEND);
 
 	/* wait until the task management command is completed */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 65178487adf3..7afe818ab1e3 100644
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
