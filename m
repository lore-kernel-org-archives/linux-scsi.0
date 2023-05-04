Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA49EC7EE21
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 23:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjEDXvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 19:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjEDXvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 19:51:50 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1FE86AD
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 16:51:48 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1aaf70676b6so8269155ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 May 2023 16:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683244308; x=1685836308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ac+lV3ttBDC6WYKknPpj/rlfwz2YKXKPkx3DE1oGOH8=;
        b=PSaTnrtR2T8aZENj3n7dSzT/IWGzllz7LVTKqFEScgG/nGmGRMCmzU47nfWR1HD1IB
         gui0Qc4snJTU+FU8PUSud5jVBS4xhdoeJCjE/1+VHivjoz48MJef90z2Zebxr7yYAgXV
         9halvdiQTCxxNgUK9e4BPtn8Sxi8e2nt4l0TS9X65+McgjnaA1zs4xaF6bVB7/oWchvq
         6KHqypsZN1wfClxsW1bmnuzmIsaOCB5R6AwOHvSqzcF2y/xFEMqPLwxpmLIVm5VrVtIq
         iQMx5+LhPUtP/rVw3MSvl5OOq8Ja7a2wHTNvflQQytDgCUfm0xkjKvF0x6d9Om+6gbwa
         JdbA==
X-Gm-Message-State: AC+VfDx2TAWZFnPG1EPXVK/4a2kQyiQKk5eAdf7G4pKi68Rgw4hRvUvw
        OD6dp8lcRtVfI1av1YwsU7Y=
X-Google-Smtp-Source: ACHHUZ4yNqnkBiFDLJ+T5GzcezzpmgCxsFDeaRdG4freKoJXS7fp6ITPvORsDIU2y2ZVkLHBtJmN2g==
X-Received: by 2002:a17:902:d4d2:b0:1ab:14da:981 with SMTP id o18-20020a170902d4d200b001ab14da0981mr6685912plg.35.1683244307980;
        Thu, 04 May 2023 16:51:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902758d00b001aad4be4503sm143169pll.2.2023.05.04.16.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:51:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH 5/5] scsi: ufs: Ungate the clock synchronously
Date:   Thu,  4 May 2023 16:50:52 -0700
Message-Id: <20230504235052.4423-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230504235052.4423-1-bvanassche@acm.org>
References: <20230504235052.4423-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ungating the clock asynchronously causes ufshcd_queuecommand() to
return SCSI_MLQUEUE_HOST_BUSY and hence causes commands to be requeued.
This is suboptimal. Allow ufshcd_queuecommand() to sleep such that
clock ungating does not trigger command requeuing.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-sysfs.c     |  2 +-
 drivers/ufs/core/ufshcd-crypto.c |  2 +-
 drivers/ufs/core/ufshcd-priv.h   |  2 +-
 drivers/ufs/core/ufshcd.c        | 75 ++++++++++----------------------
 4 files changed, 26 insertions(+), 55 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 883f0e44b54e..cdf3d5f2b77b 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -168,7 +168,7 @@ static ssize_t auto_hibern8_show(struct device *dev,
 	}
 
 	pm_runtime_get_sync(hba->dev);
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 198360fe5e8e..f2c4422cab86 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -24,7 +24,7 @@ static int ufshcd_program_key(struct ufs_hba *hba,
 	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
 	int err = 0;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	if (hba->vops && hba->vops->program_key) {
 		err = hba->vops->program_key(hba, cfg, slot);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index d53b93c21a0c..22cac71090ae 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -84,7 +84,7 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
-int ufshcd_hold(struct ufs_hba *hba, bool async);
+void ufshcd_hold(struct ufs_hba *hba);
 void ufshcd_release(struct ufs_hba *hba);
 
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 54f91d7d0192..e4f490a25def 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1189,7 +1189,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 	bool timeout = false, do_last_check = false;
 	ktime_t start;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	/*
 	 * Wait for all the outstanding tasks/transfer requests.
@@ -1310,7 +1310,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	}
 
 	/* let's not get into low power until clock scaling is completed */
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 out:
 	return ret;
@@ -1647,7 +1647,7 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 		goto out;
 
 	ufshcd_rpm_get_sync(hba);
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	hba->clk_scaling.is_enabled = value;
 
@@ -1761,17 +1761,15 @@ static void ufshcd_ungate_work(struct work_struct *work)
  * ufshcd_hold - Enable clocks that were gated earlier due to ufshcd_release.
  * Also, exit from hibern8 mode and set the link as active.
  * @hba: per adapter instance
- * @async: This indicates whether caller should ungate clocks asynchronously.
  */
-int ufshcd_hold(struct ufs_hba *hba, bool async)
+void ufshcd_hold(struct ufs_hba *hba)
 {
-	int rc = 0;
 	bool flush_result;
 	unsigned long flags;
 
 	if (!ufshcd_is_clkgating_allowed(hba) ||
 	    !hba->clk_gating.is_initialized)
-		goto out;
+		return;
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->clk_gating.active_reqs++;
 
@@ -1788,15 +1786,10 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		if (ufshcd_can_hibern8_during_gating(hba) &&
 		    ufshcd_is_link_hibern8(hba)) {
-			if (async) {
-				rc = -EAGAIN;
-				hba->clk_gating.active_reqs--;
-				break;
-			}
 			spin_unlock_irqrestore(hba->host->host_lock, flags);
 			flush_result = flush_work(&hba->clk_gating.ungate_work);
 			if (hba->clk_gating.is_suspended && !flush_result)
-				goto out;
+				return;
 			spin_lock_irqsave(hba->host->host_lock, flags);
 			goto start;
 		}
@@ -1827,12 +1820,6 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		fallthrough;
 	case REQ_CLKS_ON:
-		if (async) {
-			rc = -EAGAIN;
-			hba->clk_gating.active_reqs--;
-			break;
-		}
-
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		flush_work(&hba->clk_gating.ungate_work);
 		/* Make sure state is CLKS_ON before returning */
@@ -1844,8 +1831,6 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		break;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-out:
-	return rc;
 }
 
 static void ufshcd_gate_work(struct work_struct *work)
@@ -2075,7 +2060,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	ufshcd_remove_clk_gating_sysfs(hba);
 
 	/* Ungate the clock if necessary. */
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	hba->clk_gating.is_initialized = false;
 	ufshcd_release(hba);
 
@@ -2471,7 +2456,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
 		return 0;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
@@ -2874,12 +2859,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
 
-	/*
-	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
-	 * calls.
-	 */
-	rcu_read_lock();
-
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
@@ -2925,13 +2904,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	hba->req_abort_count = 0;
 
-	err = ufshcd_hold(hba, true);
-	if (err) {
-		err = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
-	}
-	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
-		(hba->clk_gating.state != CLKS_ON));
+	ufshcd_hold(hba);
 
 	lrbp = &hba->lrb[tag];
 	lrbp->cmd = cmd;
@@ -2959,8 +2932,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	ufshcd_send_command(hba, tag, hwq);
 
 out:
-	rcu_read_unlock();
-
 	if (ufs_trigger_eh()) {
 		unsigned long flags;
 
@@ -3254,7 +3225,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 	BUG_ON(!hba);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
@@ -3328,7 +3299,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		return -EINVAL;
 	}
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
@@ -3424,7 +3395,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 		return -EINVAL;
 	}
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
@@ -4242,7 +4213,7 @@ int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 	uic_cmd.command = UIC_CMD_DME_SET;
 	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
 	uic_cmd.argument3 = mode;
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	ufshcd_release(hba);
 
@@ -4349,7 +4320,7 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	if (update &&
 	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
-		ufshcd_hold(hba, false);
+		ufshcd_hold(hba);
 		ufshcd_auto_hibern8_enable(hba);
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
@@ -4942,7 +4913,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	int err = 0;
 	int retries;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
@@ -6227,14 +6198,14 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_setup_vreg(hba, true);
 		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
 		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
-		ufshcd_hold(hba, false);
+		ufshcd_hold(hba);
 		if (!ufshcd_is_clkgating_allowed(hba))
 			ufshcd_setup_clocks(hba, true);
 		ufshcd_release(hba);
 		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 		ufshcd_vops_resume(hba, pm_op);
 	} else {
-		ufshcd_hold(hba, false);
+		ufshcd_hold(hba);
 		if (ufshcd_is_clkscaling_supported(hba) &&
 		    hba->clk_scaling.is_enabled)
 			ufshcd_suspend_clkscaling(hba);
@@ -6242,7 +6213,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
-	synchronize_rcu();
+	blk_mq_wait_quiesce_done(&hba->host->tag_set);
 	cancel_work_sync(&hba->eeh_work);
 }
 
@@ -6887,7 +6858,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		return PTR_ERR(req);
 
 	req->end_io_data = &wait;
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	spin_lock_irqsave(host->host_lock, flags);
 
@@ -7123,7 +7094,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 		cmd_type = DEV_CMD_TYPE_NOP;
 		fallthrough;
 	case UPIU_TRANSACTION_QUERY_REQ:
-		ufshcd_hold(hba, false);
+		ufshcd_hold(hba);
 		mutex_lock(&hba->dev_cmd.lock);
 		err = ufshcd_issue_devman_upiu_cmd(hba, req_upiu, rsp_upiu,
 						   desc_buff, buff_len,
@@ -7189,7 +7160,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 	u16 ehs_len;
 
 	/* Protects use of hba->reserved_slot. */
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
 	down_read(&hba->clk_scaling_lock);
 
@@ -7423,7 +7394,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return FAILED. */
 	if (!(test_bit(tag, &hba->outstanding_reqs))) {
@@ -9407,7 +9378,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
 	 */
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	hba->clk_gating.is_suspended = true;
 
 	if (ufshcd_is_clkscaling_supported(hba))
