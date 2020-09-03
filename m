Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B848C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 02:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5877320773
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 02:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgICC0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 22:26:03 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:11840 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgICC0C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 22:26:02 -0400
IronPort-SDR: hQzm/UzqdA69CQYQqtQ6e1s6zNE0ZEPr1i4+tgpizquKjs/nwr7HWb1XwycKs4fykJn+wgpYhZ
 f9iQCiCggXQlBkY4wBDDyW46FW56mAYvOM8KQfHeUXknmVKfs41Gb0p4hgfWJnACHGa6OqUr6S
 eKOyYkhxg67N/V5CwvQ49F1dWeWgVzOZNPcI3JiR3FMti6YBH3rK7ltCk9KXVN3X9OUWoZ3aUj
 VseokIu8HrhqGlXRAaIRnqj9fNXKyVHVeAai9xXDLW9m6Jb3l02bwR/FJ4ea3PVGO8vXg1iO65
 gIk=
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="29130860"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 02 Sep 2020 19:24:50 -0700
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 02 Sep 2020 19:24:49 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 7E3D1215EA; Wed,  2 Sep 2020 19:24:49 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] scsi: ufs: Handle LINERESET indication in err handler
Date:   Wed,  2 Sep 2020 19:24:32 -0700
Message-Id: <1599099873-32579-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PA Layer issues a LINERESET to the PHY at the recovery step in the Power
Mode change operation. If it happens during auto or mannual hibern8 enter,
even if hibern8 enter succeeds, UFS power mode shall be set to PWM-G1 mode
and kept in that mode after exit from hibern8, leading to bad performance.
Handle the LINERESET in the eh_work by restoring power mode to HS mode
after all pending reqs and tasks are cleared from doorbell.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 140 ++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h |   2 +
 drivers/scsi/ufs/ufshci.h |   1 +
 drivers/scsi/ufs/unipro.h |   3 +
 4 files changed, 115 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 72afe12..93619bc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -146,6 +146,7 @@ enum {
 	UFSHCD_UIC_NL_ERROR = (1 << 3), /* Network layer error */
 	UFSHCD_UIC_TL_ERROR = (1 << 4), /* Transport Layer error */
 	UFSHCD_UIC_DME_ERROR = (1 << 5), /* DME error */
+	UFSHCD_UIC_PA_GENERIC_ERROR = (1 << 6), /* Generic PA error */
 };
 
 #define ufshcd_set_eh_in_progress(h) \
@@ -4069,7 +4070,8 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 	int ret;
 
 	/* if already configured to the requested pwr_mode */
-	if (pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
+	if (!hba->force_pmc &&
+	    pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
 	    pwr_mode->gear_tx == hba->pwr_info.gear_tx &&
 	    pwr_mode->lane_rx == hba->pwr_info.lane_rx &&
 	    pwr_mode->lane_tx == hba->pwr_info.lane_tx &&
@@ -4503,6 +4505,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	/* Clear UECPA once due to LINERESET has happened during LINK_STARTUP */
+	ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
 	ret = ufshcd_make_hba_operational(hba);
 out:
 	if (ret) {
@@ -5659,6 +5663,22 @@ static inline void ufshcd_recover_pm_error(struct ufs_hba *hba)
 }
 #endif
 
+static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
+{
+	struct ufs_pa_layer_attr *pwr_info = &hba->pwr_info;
+	u32 mode;
+
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);
+
+	if (pwr_info->pwr_rx != ((mode >> PWRMODE_RX_OFFSET) & PWRMODE_MASK))
+		return true;
+
+	if (pwr_info->pwr_tx != (mode & PWRMODE_MASK))
+		return true;
+
+	return false;
+}
+
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
@@ -5669,9 +5689,9 @@ static void ufshcd_err_handler(struct work_struct *work)
 	unsigned long flags;
 	bool err_xfer = false;
 	bool err_tm = false;
-	int err = 0;
+	int err = 0, pmc_err;
 	int tag;
-	bool needs_reset = false;
+	bool needs_reset = false, needs_restore = false;
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
@@ -5687,16 +5707,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_err_handling_prepare(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_scsi_block_requests(hba);
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
 	/*
 	 * A full reset and restore might have happened after preparation
 	 * is finished, double check whether we should stop.
 	 */
-	if (ufshcd_err_handling_should_stop(hba)) {
-		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
-			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
-		goto out;
-	}
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	if (ufshcd_err_handling_should_stop(hba))
+		goto skip_err_handling;
 
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
@@ -5712,15 +5729,9 @@ static void ufshcd_err_handler(struct work_struct *work)
 			goto skip_err_handling;
 	}
 
-	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
-	    ufshcd_is_saved_err_fatal(hba) ||
-	    ((hba->saved_err & UIC_ERROR) &&
-	     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
-				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
-		needs_reset = true;
-
-	if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR |
-			      UFSHCD_UIC_HIBERN8_MASK)) {
+	if ((hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK)) ||
+	    (hba->saved_uic_err &&
+	     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
 		bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -5733,13 +5744,36 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 
 	/*
-	 * if host reset is required then skip clearing the pending
+	 * If host reset is required then skip clearing the pending
 	 * transfers forcefully because they will get cleared during
 	 * host reset and restore
 	 */
-	if (needs_reset)
-		goto skip_pending_xfer_clear;
+	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
+	    ufshcd_is_saved_err_fatal(hba) ||
+	    ((hba->saved_err & UIC_ERROR) &&
+	     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
+				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))) {
+		needs_reset = true;
+		goto do_reset;
+	}
+
+	/*
+	 * If LINERESET was caught, UFS might have been put to PWM mode,
+	 * check if power mode restore is needed.
+	 */
+	if (hba->saved_uic_err & UFSHCD_UIC_PA_GENERIC_ERROR) {
+		hba->saved_uic_err &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
+		if (!hba->saved_uic_err)
+			hba->saved_err &= ~UIC_ERROR;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		if (ufshcd_is_pwr_mode_restore_needed(hba))
+			needs_restore = true;
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		if (!hba->saved_err && !needs_restore)
+			goto skip_err_handling;
+	}
 
+	hba->silence_err_logs = true;
 	/* release lock as clear command might sleep */
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	/* Clear pending transfer requests */
@@ -5763,11 +5797,38 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	/* Complete the requests that are cleared by s/w */
 	ufshcd_complete_requests(hba);
+	hba->silence_err_logs = false;
 
-	if (err_xfer || err_tm)
+	if (err_xfer || err_tm) {
 		needs_reset = true;
+		goto do_reset;
+	}
 
-skip_pending_xfer_clear:
+	/*
+	 * After all reqs and tasks are cleared from doorbell,
+	 * now it is safe to retore power mode.
+	 */
+	if (needs_restore) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		/*
+		 * Hold the scaling lock just in case dev cmds
+		 * are sent via bsg and/or sysfs.
+		 */
+		down_write(&hba->clk_scaling_lock);
+		hba->force_pmc = true;
+		pmc_err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
+		if (pmc_err) {
+			needs_reset = true;
+			dev_err(hba->dev, "%s: Failed to restore power mode, err = %d\n",
+					__func__, pmc_err);
+		}
+		hba->force_pmc = false;
+		ufshcd_print_pwr_info(hba);
+		up_write(&hba->clk_scaling_lock);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+	}
+
+do_reset:
 	/* Fatal errors need reset */
 	if (needs_reset) {
 		unsigned long max_doorbells = (1UL << hba->nutrs) - 1;
@@ -5802,8 +5863,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
 			    __func__, hba->saved_err, hba->saved_uic_err);
 	}
-
-out:
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_scsi_unblock_requests(hba);
@@ -5823,17 +5882,34 @@ static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 	u32 reg;
 	irqreturn_t retval = IRQ_NONE;
 
-	/* PHY layer lane error */
+	/* PHY layer error */
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
-	/* Ignore LINERESET indication, as this is not an error */
 	if ((reg & UIC_PHY_ADAPTER_LAYER_ERROR) &&
-	    (reg & UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK)) {
+	    (reg & UIC_PHY_ADAPTER_LAYER_ERROR_CODE_MASK)) {
 		/*
 		 * To know whether this error is fatal or not, DB timeout
 		 * must be checked but this error is handled separately.
 		 */
-		dev_dbg(hba->dev, "%s: UIC Lane error reported\n", __func__);
-		ufshcd_update_reg_hist(&hba->ufs_stats.pa_err, reg);
+		if (reg & UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK) {
+			ufshcd_update_reg_hist(&hba->ufs_stats.pa_err, reg);
+			dev_dbg(hba->dev, "%s: UIC Lane error reported\n",
+					__func__);
+		}
+
+		/* Got a LINERESET indication. */
+		if (reg & UIC_PHY_ADAPTER_LAYER_GENERIC_ERROR) {
+			struct uic_command *cmd = NULL;
+
+			hba->uic_error |= UFSHCD_UIC_PA_GENERIC_ERROR;
+			if (hba->uic_async_done && hba->active_uic_cmd)
+				cmd = hba->active_uic_cmd;
+			/*
+			 * Ignore the LINERESET during power mode change
+			 * operation via DME_SET command.
+			 */
+			if (cmd && (cmd->command == UIC_CMD_DME_SET))
+				hba->uic_error &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
+		}
 		retval |= IRQ_HANDLED;
 	}
 
@@ -5950,7 +6026,9 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 		hba->saved_uic_err |= hba->uic_error;
 
 		/* dump controller state before resetting */
-		if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
+		if ((hba->saved_err & (INT_FATAL_ERRORS)) ||
+		    (hba->saved_uic_err &&
+		     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
 			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
 					__func__, hba->saved_err,
 					hba->saved_uic_err);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 618b253..8817103 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -629,6 +629,7 @@ struct ufs_hba_variant_params {
  * @saved_err: sticky error mask
  * @saved_uic_err: sticky UIC error mask
  * @force_reset: flag to force eh_work perform a full reset
+ * @force_pmc: flag to force a power mode change
  * @silence_err_logs: flag to silence error logs
  * @dev_cmd: ufs device management command information
  * @last_dme_cmd_tstamp: time stamp of the last completed DME command
@@ -728,6 +729,7 @@ struct ufs_hba {
 	u32 saved_uic_err;
 	struct ufs_stats ufs_stats;
 	bool force_reset;
+	bool force_pmc;
 	bool silence_err_logs;
 
 	/* Device management request data */
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index ba31b09..6795e1f 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -171,6 +171,7 @@ enum {
 #define UIC_PHY_ADAPTER_LAYER_ERROR			0x80000000
 #define UIC_PHY_ADAPTER_LAYER_ERROR_CODE_MASK		0x1F
 #define UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK		0xF
+#define UIC_PHY_ADAPTER_LAYER_GENERIC_ERROR		0x10
 
 /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
 #define UIC_DATA_LINK_LAYER_ERROR		0x80000000
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 4ee6478..f6b52ce 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -205,6 +205,9 @@ enum {
 	UNCHANGED	= 7,
 };
 
+#define PWRMODE_MASK		0xF
+#define PWRMODE_RX_OFFSET	4
+
 /* PA TX/RX Frequency Series */
 enum {
 	PA_HS_MODE_A	= 1,
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

