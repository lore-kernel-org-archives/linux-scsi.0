Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D928AC7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjE2U1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjE2U1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:27:04 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D64E4
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:27:02 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-53fa455cd94so362166a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685392022; x=1687984022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9eEX29GkLjiKp4moHsnymXIpSZx5RtL3e/3PBh6hJk=;
        b=QIezIfycD78+vR6VjHNixgFLFFS2Q8BA/5sSod2zl2ORPwWxPf1Xo+5BH2mMCQo1Ez
         2QfWMPM/6IKs3NvGtrmyGHgZmHddb2c5gZrTHtQrG0wU+K+7lTkUuhZ+MT4KGzWrSya/
         5MHtSjspfrjdQtRuVMGV9ddZGexd43JYt0Ic9uCK+5PByAKFXMixFNnZnbBp3P2BSkKB
         r4se2YHEd8RamAuytNiEI+tD6Nkn1Mdh5XUSloT78Q0rJI0CJYSYRXdr9HXqv4dhnA7n
         sfsimL/kOCMMT4fhlsCEvrOQJ7+g+pOjxI0sp5u45AO+gvAgOkpWPeNJiqz1fq0EDeFo
         LFHg==
X-Gm-Message-State: AC+VfDxC4fjtmyVZvVmjXB6D3vmPjG+dZ47SoupiZVw0XpuXXguNMzWS
        YMbL8p/ZoVta50AUBzz+j/4=
X-Google-Smtp-Source: ACHHUZ42aURC1JDCV9480B0Ws52Q6wf3yr6e4zy5hCciwJTX4j2QSHqEboMEYuV1ion1dwSlnlbV5Q==
X-Received: by 2002:a17:903:2281:b0:1b0:106e:f5b2 with SMTP id b1-20020a170903228100b001b0106ef5b2mr234597plh.58.1685392021598;
        Mon, 29 May 2023 13:27:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id l18-20020a170903245200b001b027221393sm4957237pls.43.2023.05.29.13.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:27:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v4 5/5] scsi: ufs: Ungate the clock synchronously
Date:   Mon, 29 May 2023 13:26:40 -0700
Message-Id: <20230529202640.11883-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202640.11883-1-bvanassche@acm.org>
References: <20230529202640.11883-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ungating the clock asynchronously causes ufshcd_queuecommand() to return
SCSI_MLQUEUE_HOST_BUSY and hence causes commands to be requeued.  This is
suboptimal. Allow ufshcd_queuecommand() to sleep such that clock ungating
does not trigger command requeuing. Remove the ufshcd_scsi_block_requests()
and ufshcd_scsi_unblock_requests() calls because these are no longer
needed. The flush_work(&hba->clk_gating.ungate_work) call is sufficient to
make the SCSI core wait for clock ungating to complete.

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-sysfs.c     |  2 +-
 drivers/ufs/core/ufshcd-crypto.c |  2 +-
 drivers/ufs/core/ufshcd.c        | 86 ++++++++++----------------------
 include/ufs/ufshcd.h             |  2 +-
 4 files changed, 30 insertions(+), 62 deletions(-)

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
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2d9109102f3..d9b6da33842a 100644
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
@@ -1640,7 +1640,7 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 		goto out;
 
 	ufshcd_rpm_get_sync(hba);
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	hba->clk_scaling.is_enabled = value;
 
@@ -1723,7 +1723,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->clk_gating.state == CLKS_ON) {
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		goto unblock_reqs;
+		return;
 	}
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1746,25 +1746,21 @@ static void ufshcd_ungate_work(struct work_struct *work)
 		}
 		hba->clk_gating.is_suspended = false;
 	}
-unblock_reqs:
-	ufshcd_scsi_unblock_requests(hba);
 }
 
 /**
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
 
@@ -1781,15 +1777,10 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
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
@@ -1811,21 +1802,14 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		hba->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
-		if (queue_work(hba->clk_gating.clk_gating_workq,
-			       &hba->clk_gating.ungate_work))
-			ufshcd_scsi_block_requests(hba);
+		queue_work(hba->clk_gating.clk_gating_workq,
+			   &hba->clk_gating.ungate_work);
 		/*
 		 * fall through to check if we should wait for this
 		 * work to be done or not.
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
@@ -1837,8 +1821,6 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		break;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-out:
-	return rc;
 }
 EXPORT_SYMBOL_GPL(ufshcd_hold);
 
@@ -2070,7 +2052,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	ufshcd_remove_clk_gating_sysfs(hba);
 
 	/* Ungate the clock if necessary. */
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	hba->clk_gating.is_initialized = false;
 	ufshcd_release(hba);
 
@@ -2468,7 +2450,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
 		return 0;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
@@ -2871,12 +2853,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
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
@@ -2922,13 +2898,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
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
@@ -2956,8 +2926,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	ufshcd_send_command(hba, tag, hwq);
 
 out:
-	rcu_read_unlock();
-
 	if (ufs_trigger_eh()) {
 		unsigned long flags;
 
@@ -3251,7 +3219,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 
 	BUG_ON(!hba);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
@@ -3325,7 +3293,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		return -EINVAL;
 	}
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
@@ -3421,7 +3389,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 		return -EINVAL;
 	}
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
@@ -4239,7 +4207,7 @@ int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 	uic_cmd.command = UIC_CMD_DME_SET;
 	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
 	uic_cmd.argument3 = mode;
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	ufshcd_release(hba);
 
@@ -4346,7 +4314,7 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	if (update &&
 	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
-		ufshcd_hold(hba, false);
+		ufshcd_hold(hba);
 		ufshcd_auto_hibern8_enable(hba);
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
@@ -4939,7 +4907,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	int err = 0;
 	int retries;
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
@@ -6224,22 +6192,22 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
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
 		ufshcd_clk_scaling_allow(hba, false);
 	}
 	ufshcd_scsi_block_requests(hba);
-	/* Drain ufshcd_queuecommand() */
-	synchronize_rcu();
+	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
+	blk_mq_wait_quiesce_done(&hba->host->tag_set);
 	cancel_work_sync(&hba->eeh_work);
 }
 
@@ -6884,7 +6852,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		return PTR_ERR(req);
 
 	req->end_io_data = &wait;
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 
 	spin_lock_irqsave(host->host_lock, flags);
 
@@ -7120,7 +7088,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 		cmd_type = DEV_CMD_TYPE_NOP;
 		fallthrough;
 	case UPIU_TRANSACTION_QUERY_REQ:
-		ufshcd_hold(hba, false);
+		ufshcd_hold(hba);
 		mutex_lock(&hba->dev_cmd.lock);
 		err = ufshcd_issue_devman_upiu_cmd(hba, req_upiu, rsp_upiu,
 						   desc_buff, buff_len,
@@ -7186,7 +7154,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 	u16 ehs_len;
 
 	/* Protects use of hba->reserved_slot. */
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	mutex_lock(&hba->dev_cmd.lock);
 	down_read(&hba->clk_scaling_lock);
 
@@ -7420,7 +7388,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return FAILED. */
 	if (!(test_bit(tag, &hba->outstanding_reqs))) {
@@ -9412,7 +9380,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
 	 */
-	ufshcd_hold(hba, false);
+	ufshcd_hold(hba);
 	hba->clk_gating.is_suspended = true;
 
 	if (ufshcd_is_clkscaling_supported(hba))
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index db2e669985d5..40c537a3880b 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1357,7 +1357,7 @@ void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
-int ufshcd_hold(struct ufs_hba *hba, bool async);
+void ufshcd_hold(struct ufs_hba *hba);
 void ufshcd_release(struct ufs_hba *hba);
 
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
