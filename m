Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D22C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39DE7613A2
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhJDMLc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:11:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:5858 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232549AbhJDMLb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 08:11:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="205532794"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="205532794"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 05:07:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="482927036"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 04 Oct 2021 05:07:04 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH RFC 1/6] scsi: ufs: Encapsulate clk_scaling_lock by inline functions
Date:   Mon,  4 Oct 2021 15:06:45 +0300
Message-Id: <20211004120650.153218-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004120650.153218-1-adrian.hunter@intel.com>
References: <20211004120650.153218-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for making clk_scaling_lock a more general purpose sleeping
lock for the host.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 34 +++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9faf02cbb9ad..350ecfd90306 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1175,12 +1175,12 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	 * clock scaling is in progress
 	 */
 	ufshcd_scsi_block_requests(hba);
-	down_write(&hba->clk_scaling_lock);
+	ufshcd_down_write(hba);
 
 	if (!hba->clk_scaling.is_allowed ||
 	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
-		up_write(&hba->clk_scaling_lock);
+		ufshcd_up_write(hba);
 		ufshcd_scsi_unblock_requests(hba);
 		goto out;
 	}
@@ -1195,9 +1195,9 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 {
 	if (writelock)
-		up_write(&hba->clk_scaling_lock);
+		ufshcd_up_write(hba);
 	else
-		up_read(&hba->clk_scaling_lock);
+		ufshcd_up_read(hba);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
@@ -1244,7 +1244,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	}
 
 	/* Enable Write Booster if we have scaled up else disable it */
-	downgrade_write(&hba->clk_scaling_lock);
+	ufshcd_downgrade_write(hba);
 	is_writelock = false;
 	ufshcd_wb_toggle(hba, scale_up);
 
@@ -2681,7 +2681,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	if (!down_read_trylock(&hba->clk_scaling_lock))
+	if (!ufshcd_down_read_trylock(hba))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	switch (hba->ufshcd_state) {
@@ -2756,7 +2756,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	ufshcd_send_command(hba, tag);
 out:
-	up_read(&hba->clk_scaling_lock);
+	ufshcd_up_read(hba);
 
 	if (ufs_trigger_eh())
 		scsi_schedule_eh(hba->host);
@@ -2914,7 +2914,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	int err;
 	int tag;
 
-	down_read(&hba->clk_scaling_lock);
+	ufshcd_down_read(hba);
 
 	/*
 	 * Get free slot, sleep if slots are unavailable.
@@ -2950,7 +2950,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 out:
 	blk_put_request(req);
 out_unlock:
-	up_read(&hba->clk_scaling_lock);
+	ufshcd_up_read(hba);
 	return err;
 }
 
@@ -5934,9 +5934,9 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
-	down_write(&hba->clk_scaling_lock);
+	ufshcd_down_write(hba);
 	hba->clk_scaling.is_allowed = allow;
-	up_write(&hba->clk_scaling_lock);
+	ufshcd_up_write(hba);
 }
 
 static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
@@ -5984,8 +5984,8 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
-	down_write(&hba->clk_scaling_lock);
-	up_write(&hba->clk_scaling_lock);
+	ufshcd_down_write(hba);
+	ufshcd_up_write(hba);
 	cancel_work_sync(&hba->eeh_work);
 }
 
@@ -6196,7 +6196,7 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 		 * Hold the scaling lock just in case dev cmds
 		 * are sent via bsg and/or sysfs.
 		 */
-		down_write(&hba->clk_scaling_lock);
+		ufshcd_down_write(hba);
 		hba->force_pmc = true;
 		pmc_err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
 		if (pmc_err) {
@@ -6206,7 +6206,7 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 		}
 		hba->force_pmc = false;
 		ufshcd_print_pwr_info(hba);
-		up_write(&hba->clk_scaling_lock);
+		ufshcd_up_write(hba);
 		spin_lock_irqsave(hba->host->host_lock, flags);
 	}
 
@@ -6705,7 +6705,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	int tag;
 	u8 upiu_flags;
 
-	down_read(&hba->clk_scaling_lock);
+	ufshcd_down_read(hba);
 
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req)) {
@@ -6790,7 +6790,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 out:
 	blk_put_request(req);
 out_unlock:
-	up_read(&hba->clk_scaling_lock);
+	ufshcd_up_read(hba);
 	return err;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index ed960d206260..9b1ef272fb3c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1418,4 +1418,34 @@ static inline int ufshcd_rpmb_rpm_put(struct ufs_hba *hba)
 	return pm_runtime_put(&hba->sdev_rpmb->sdev_gendev);
 }
 
+static inline void ufshcd_down_read(struct ufs_hba *hba)
+{
+	down_read(&hba->clk_scaling_lock);
+}
+
+static inline void ufshcd_up_read(struct ufs_hba *hba)
+{
+	up_read(&hba->clk_scaling_lock);
+}
+
+static inline int ufshcd_down_read_trylock(struct ufs_hba *hba)
+{
+	return down_read_trylock(&hba->clk_scaling_lock);
+}
+
+static inline void ufshcd_down_write(struct ufs_hba *hba)
+{
+	down_write(&hba->clk_scaling_lock);
+}
+
+static inline void ufshcd_up_write(struct ufs_hba *hba)
+{
+	up_write(&hba->clk_scaling_lock);
+}
+
+static inline void ufshcd_downgrade_write(struct ufs_hba *hba)
+{
+	downgrade_write(&hba->clk_scaling_lock);
+}
+
 #endif /* End of Header */
-- 
2.25.1

