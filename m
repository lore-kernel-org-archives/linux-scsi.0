Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51187C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3488461184
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhJ2NkY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:40:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:46397 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhJ2NkX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Oct 2021 09:40:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="228121660"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="228121660"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 06:37:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="636693962"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2021 06:37:51 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
Subject: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in ufshcd_queuecommand()
Date:   Fri, 29 Oct 2021 16:37:50 +0300
Message-Id: <20211029133751.420015-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use flags and memory barriers instead of the clk_scaling_lock in
ufshcd_queuecommand().  This is done to prepare for potentially faster IOPS
in the future.

On an x86 test system (Samsung Galaxy Book S), for random 4k reads this cut
the time of ufshcd_queuecommand() from about 690 ns to 460 ns.  With larger
I/O sizes, the increased duration of DMA mapping made the difference
increasingly negligible. Random 4k read IOPS was not affected, remaining at
about 97 kIOPS.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 110 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h |   4 ++
 2 files changed, 106 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 115ea16f5a22..36536e11db78 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -294,6 +294,82 @@ static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
 		scsi_block_requests(hba->host);
 }
 
+static void ufshcd_check_issuing(struct ufs_hba *hba, unsigned long *issuing)
+{
+	int tag;
+
+	/*
+	 * A memory barrier is needed to ensure changes to lrbp->issuing will be
+	 * seen here.
+	 */
+	smp_rmb();
+	for_each_set_bit(tag, issuing, hba->nutrs) {
+		struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+
+		if (!lrbp->issuing)
+			__clear_bit(tag, issuing);
+	}
+}
+
+struct issuing {
+	struct ufs_hba *hba;
+	unsigned long issuing;
+};
+
+static bool ufshcd_is_issuing(struct request *req, void *priv, bool reserved)
+{
+	int tag = req->tag;
+	struct issuing *issuing = priv;
+	struct ufshcd_lrb *lrbp = &issuing->hba->lrb[tag];
+
+	if (lrbp->issuing)
+		__set_bit(tag, &issuing->issuing);
+	return false;
+}
+
+static void ufshcd_flush_queuecommand(struct ufs_hba *hba)
+{
+	struct request_queue *q = hba->cmd_queue;
+	struct issuing issuing = { .hba = hba };
+	int i;
+
+	/*
+	 * Ensure any changes will be visible in ufshcd_queuecommand(), before
+	 * finding requests that are currently in ufshcd_queuecommand(). Any
+	 * requests not yet past the memory barrier in ufshcd_queuecommand()
+	 * will therefore certainly see any changes that this task has made.
+	 * Any requests that are past the memory barrier in
+	 * ufshcd_queuecommand() will be found below, unless they are already
+	 * exiting ufshcd_queuecommand().
+	 */
+	smp_mb();
+
+	/*
+	 * Requests coming through ufshcd_queuecommand() will always have been
+	 * "started", so blk_mq_tagset_busy_iter() will find them.
+	 */
+	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_is_issuing, &issuing);
+
+	/*
+	 * Spin briefly, to wait for tasks currently executing
+	 * ufshcd_queuecommand(), assuming ufshcd_queuecommand() typically takes
+	 * less that 10 microseconds.
+	 */
+	for (i = 0; i < 10 && issuing.issuing; i++) {
+		udelay(1);
+		ufshcd_check_issuing(hba, &issuing.issuing);
+	}
+
+	/*
+	 * Anything still in ufshcd_queuecommand() presumably got preempted, so
+	 * sleep while polling.
+	 */
+	while (issuing.issuing) {
+		usleep_range(100, 500);
+		ufshcd_check_issuing(hba, &issuing.issuing);
+	}
+}
+
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				      enum ufs_trace_str_t str_t)
 {
@@ -1195,6 +1271,8 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	/* let's not get into low power until clock scaling is completed */
 	ufshcd_hold(hba, false);
 
+	hba->clk_scaling.in_progress = true;
+	ufshcd_flush_queuecommand(hba);
 out:
 	return ret;
 }
@@ -1205,6 +1283,9 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 		up_write(&hba->clk_scaling_lock);
 	else
 		up_read(&hba->clk_scaling_lock);
+	/* Ensure writes are done before setting in_progress to false */
+	smp_wmb();
+	hba->clk_scaling.in_progress = false;
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
@@ -2111,7 +2192,11 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
-	/* Make sure that doorbell is committed immediately */
+	/*
+	 * Make sure that doorbell is committed immediately.
+	 * Also provides synchronization for ufshcd_queuecommand() wrt
+	 * ufshcd_flush_queuecommand().
+	 */
 	wmb();
 }
 
@@ -2695,8 +2780,15 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (!down_read_trylock(&hba->clk_scaling_lock))
-		return SCSI_MLQUEUE_HOST_BUSY;
+	lrbp = &hba->lrb[tag];
+	lrbp->issuing = true;
+	/* Synchronize with ufshcd_flush_queuecommand() */
+	smp_mb();
+
+	if (unlikely(hba->clk_scaling.in_progress)) {
+		err = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
 
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
@@ -2751,7 +2843,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
 		(hba->clk_gating.state != CLKS_ON));
 
-	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
 	lrbp->sense_bufflen = UFS_SENSE_SIZE;
@@ -2782,7 +2873,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	ufshcd_send_command(hba, tag);
 out:
-	up_read(&hba->clk_scaling_lock);
+	/*
+	 * Leverages wmb() in ufshcd_send_command() for synchronization with
+	 * ufshcd_flush_queuecommand(), otherwise if no command was sent, then
+	 * there is no need to synchronize anyway.
+	 */
+	lrbp->issuing = false;
 
 	if (ufs_trigger_eh()) {
 		unsigned long flags;
@@ -5987,9 +6083,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_clk_scaling_allow(hba, false);
 	}
 	ufshcd_scsi_block_requests(hba);
-	/* Drain ufshcd_queuecommand() */
-	down_write(&hba->clk_scaling_lock);
-	up_write(&hba->clk_scaling_lock);
+	ufshcd_flush_queuecommand(hba);
 	cancel_work_sync(&hba->eeh_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b9492f300bd1..46f385133aaa 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -188,6 +188,7 @@ struct ufs_pm_lvl_states {
  * @task_tag: Task tag of the command
  * @lun: LUN of the command
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
+ * @issuing: Is in ufshcd_queuecommand()
  * @issue_time_stamp: time stamp for debug purposes
  * @compl_time_stamp: time stamp for statistics
  * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
@@ -214,6 +215,7 @@ struct ufshcd_lrb {
 	int task_tag;
 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
+	bool issuing;
 	ktime_t issue_time_stamp;
 	ktime_t compl_time_stamp;
 #ifdef CONFIG_SCSI_UFS_CRYPTO
@@ -425,6 +427,7 @@ struct ufs_saved_pwr_info {
  * @is_initialized: Indicates whether clock scaling is initialized or not
  * @is_busy_started: tracks if busy period has started or not
  * @is_suspended: tracks if devfreq is suspended or not
+ * @in_progress: clock_scaling is in progress
  */
 struct ufs_clk_scaling {
 	int active_reqs;
@@ -442,6 +445,7 @@ struct ufs_clk_scaling {
 	bool is_initialized;
 	bool is_busy_started;
 	bool is_suspended;
+	bool in_progress;
 };
 
 #define UFS_EVENT_HIST_LENGTH 8
-- 
2.25.1

