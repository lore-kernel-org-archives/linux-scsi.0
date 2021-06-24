Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FBEC49EA6
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 17:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ACFB613CC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 17:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhFXRNx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 13:13:53 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:40525 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhFXRNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 13:13:49 -0400
Received: by mail-pg1-f180.google.com with SMTP id m2so5256151pgk.7;
        Thu, 24 Jun 2021 10:11:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZZ4JcEGvLC3DFqeMde4Zk3pT0B6tjDdQI3IZfxrSfA=;
        b=rKow1A4uVb4+YzD76PuGkZcslQoF0NC4Iydcw186oHxU0xWmLtMhu1fJBTjdcxPYo2
         FPf+Ik/LE919igpwJ+mEzH1cMF/ibCaLx15ykePVMka4vuf+Pl9Qf4bAvR2RnBvs9+0G
         gPf2+c/T8hf93oVcMQPZ3eS0EOGiQq3NdPzVomK+2BaJavfKvmhXlkhqOTjZgnrOsnV8
         Xw87ULZ8kg5jXqoV0X2fooX2tJuQxMnLh1Lc+yQn27FKQhkDX50jxDhgStMiNmVRON1J
         3BHHg6InU9Ch551QwmbYOt2ROs+GehogaIUZf64yOHtPxK5dbA4P2hnNBU/Ef2xGE0r3
         OBgg==
X-Gm-Message-State: AOAM533UR4EKyfl2tYgreGNZ1NLagseYEvYtM4+abfuJvPye1iTlZx5B
        Sb3pQTEcke20GE7AnUXhars2dDAYwEg=
X-Google-Smtp-Source: ABdhPJxggEJnuK3LB6teQHuJmxgbR+sfNII2K2Qw6dDDXxT+sijD4qJKhNAi3usNFf3hhTTsU493Yw==
X-Received: by 2002:a63:1b0c:: with SMTP id b12mr5560689pgb.334.1624554688769;
        Thu, 24 Jun 2021 10:11:28 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u20sm3423876pfn.189.2021.06.24.10.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 10:11:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 06/10] scsi: ufs: Remove host_sem used in
 suspend/resume
To:     Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-8-git-send-email-cang@codeaurora.org>
 <ed59d61a-6951-2acd-4f89-40f8dc5015e1@intel.com>
 <9105f328ee6ce916a7f01027b0d28332@codeaurora.org>
 <a87e5ca5-390f-8ca0-41bf-27cdc70e3316@intel.com>
 <1b351766a6e40d0df90b3adec964eb33@codeaurora.org>
 <a654d2ef-b333-1c56-42c6-3d69e9f44bd0@intel.com>
 <3970b015e444c1f1714c7e7bd4c44651@codeaurora.org>
Message-ID: <7ba226fe-789c-bf20-076b-cc635530db42@acm.org>
Date:   Thu, 24 Jun 2021 10:11:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3970b015e444c1f1714c7e7bd4c44651@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 11:31 PM, Can Guo wrote:
> Using back host_sem in suspend_prepare()/resume_complete() won't have this
> problem of deadlock, right?

Although that would solve the deadlock discussed in this email thread, it
wouldn't solve the issue of potential adverse interactions of the UFS error
handler and the SCSI error handler running concurrently. How about using the
standard approach for invoking the UFS error handler instead of using a custom
mechanism, e.g. by using something like the (untested) patch below? This
approach guarantees that the UFS error handler is only activated after all
pending SCSI commands have failed or timed out and also guarantees that no new
SCSI commands will be queued while the UFS error handler is in progress (see
also scsi_host_queue_ready()).

Thanks,

Bart.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0ac1e15ac914..c6303ea9e5db 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -17,6 +17,8 @@
 #include <linux/blk-pm.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_transport.h>
+#include "../scsi_transport_api.h"
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -233,7 +235,6 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
-static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
 static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
@@ -2697,26 +2698,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)

 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
-	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
 		break;
-	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
-		/*
-		 * pm_runtime_get_sync() is used at error handling preparation
-		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
-		 * PM ops, it can never be finished if we let SCSI layer keep
-		 * retrying it, which gets err handler stuck forever. Neither
-		 * can we let the scsi cmd pass through, because UFS is in bad
-		 * state, the scsi cmd may eventually time out, which will get
-		 * err handler blocked for too long. So, just fail the scsi cmd
-		 * sent from PM ops, err handler can recover PM error anyways.
-		 */
-		if (hba->pm_op_in_progress) {
-			hba->force_reset = true;
-			set_host_byte(cmd, DID_BAD_TARGET);
-			cmd->scsi_done(cmd);
-			goto out;
-		}
-		fallthrough;
 	case UFSHCD_STATE_RESET:
 		err = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
@@ -3954,6 +3936,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	u8 status;
 	int ret;
 	bool reenable_intr = false;
+	bool schedule_eh = false;

 	mutex_lock(&hba->uic_cmd_mutex);
 	init_completion(&uic_async_done);
@@ -4021,10 +4004,12 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	if (ret) {
 		ufshcd_set_link_broken(hba);
-		ufshcd_schedule_eh_work(hba);
+		schedule_eh = true;
 	}
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (schedule_eh)
+		scsi_schedule_eh(hba->host);
 	mutex_unlock(&hba->uic_cmd_mutex);

 	return ret;
@@ -4085,8 +4070,6 @@ static bool ufshcd_set_state(struct ufs_hba *hba, enum ufshcd_state new_state)
 		}
 		break;
 	case UFSHCD_STATE_RESET:
-	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
-	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
 		allowed = hba->ufshcd_state != UFSHCD_STATE_ERROR;
 		break;
 	case UFSHCD_STATE_ERROR:
@@ -5886,22 +5869,6 @@ static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
 	       (hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
 }

-/* host lock must be held before calling this func */
-static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
-{
-	bool proceed;
-
-	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
-	    ufshcd_is_saved_err_fatal(hba))
-		proceed = ufshcd_set_state(hba,
-					   UFSHCD_STATE_EH_SCHEDULED_FATAL);
-	else
-		proceed = ufshcd_set_state(hba,
-					   UFSHCD_STATE_EH_SCHEDULED_NON_FATAL);
-	if (proceed)
-		queue_work(hba->eh_wq, &hba->eh_work);
-}
-
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
 	down_write(&hba->clk_scaling_lock);
@@ -5924,7 +5891,7 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)

 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
-	ufshcd_rpm_get_sync(hba);
+	pm_runtime_get_noresume(&hba->sdev_ufs_device->sdev_gendev);
 	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
 	    hba->is_sys_suspended) {
 		enum ufs_pm_op pm_op;
@@ -6035,11 +6002,12 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)

 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
- * @work: pointer to work structure
+ * @host: SCSI host pointer
  */
-static void ufshcd_err_handler(struct work_struct *work)
+static void ufshcd_err_handler(struct Scsi_Host *host)
 {
-	struct ufs_hba *hba;
+	struct ufs_hba *hba = shost_priv(host);
+	struct completion *eh_compl = NULL;
 	unsigned long flags;
 	bool err_xfer = false;
 	bool err_tm = false;
@@ -6047,10 +6015,10 @@ static void ufshcd_err_handler(struct work_struct *work)
 	int tag;
 	bool needs_reset = false, needs_restore = false;

-	hba = container_of(work, struct ufs_hba, eh_work);
-
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	/* Clear host_eh_scheduled which has been set by scsi_schedule_eh(). */
+	hba->host->host_eh_scheduled = 0;
 	if (ufshcd_err_handling_should_stop(hba)) {
 		ufshcd_set_state(hba, UFSHCD_STATE_OPERATIONAL);
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -6202,9 +6170,12 @@ static void ufshcd_err_handler(struct work_struct *work)
 			    __func__, hba->saved_err, hba->saved_uic_err);
 	}
 	ufshcd_clear_eh_in_progress(hba);
+	swap(hba->eh_compl, eh_compl);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->host_sem);
+	if (eh_compl)
+		complete(eh_compl);
 }

 /**
@@ -6361,7 +6332,6 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 					 "host_regs: ");
 			ufshcd_print_pwr_info(hba);
 		}
-		ufshcd_schedule_eh_work(hba);
 		retval |= IRQ_HANDLED;
 	}
 	/*
@@ -6373,6 +6343,8 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 	hba->errors = 0;
 	hba->uic_error = 0;
 	spin_unlock(hba->host->host_lock);
+	if (queue_eh_work)
+		scsi_schedule_eh(hba->host);
 	return retval;
 }

@@ -7045,8 +7017,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		set_bit(tag, &hba->outstanding_reqs);
 		spin_lock_irqsave(host->host_lock, flags);
 		hba->force_reset = true;
-		ufshcd_schedule_eh_work(hba);
 		spin_unlock_irqrestore(host->host_lock, flags);
+		scsi_schedule_eh(hba->host);
 		goto out;
 	}

@@ -7172,7 +7144,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
  */
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	int err = SUCCESS;
+	DECLARE_COMPLETION_ONSTACK(eh_compl);
+	int err = SUCCESS, res;
 	unsigned long flags;
 	struct ufs_hba *hba;

@@ -7180,11 +7153,15 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)

 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->force_reset = true;
-	ufshcd_schedule_eh_work(hba);
+	hba->eh_compl = &eh_compl;
 	dev_err(hba->dev, "%s: reset in progress - 1\n", __func__);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);

-	flush_work(&hba->eh_work);
+	scsi_schedule_eh(hba->host);
+	res = wait_for_completion_interruptible_timeout(&eh_compl, 180 * HZ);
+	WARN_ONCE(res <= 0,
+		  "wait_for_completion_interruptible_timeout() returned %d",
+		  res);

 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ufshcd_state == UFSHCD_STATE_ERROR)
@@ -8511,8 +8488,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	if (hba->is_powered) {
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_exit_clk_gating(hba);
-		if (hba->eh_wq)
-			destroy_workqueue(hba->eh_wq);
 		ufs_debugfs_hba_exit(hba);
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
@@ -9371,6 +9346,10 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
 }

+static struct scsi_transport_template ufshcd_transport_template = {
+	.eh_strategy_handler = ufshcd_err_handler,
+};
+
 /**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
@@ -9397,6 +9376,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+	host->transportt = &ufshcd_transport_template;
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
@@ -9434,7 +9414,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	int err;
 	struct Scsi_Host *host = hba->host;
 	struct device *dev = hba->dev;
-	char eh_wq_name[sizeof("ufs_eh_wq_00")];

 	if (!mmio_base) {
 		dev_err(hba->dev,
@@ -9488,17 +9467,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)

 	hba->max_pwr_info.is_valid = false;

-	/* Initialize work queues */
-	snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
-		 hba->host->host_no);
-	hba->eh_wq = create_singlethread_workqueue(eh_wq_name);
-	if (!hba->eh_wq) {
-		dev_err(hba->dev, "%s: failed to create eh workqueue\n",
-				__func__);
-		err = -ENOMEM;
-		goto out_disable;
-	}
-	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);

 	sema_init(&hba->host_sem, 1);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f2796ea25598..d4f7ab0171c6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -482,18 +482,12 @@ struct ufs_stats {
  *	processing.
  * @UFSHCD_STATE_OPERATIONAL: The host controller is operational and can process
  *	SCSI commands.
- * @UFSHCD_STATE_EH_SCHEDULED_NON_FATAL: The error handler has been scheduled.
- *	SCSI commands may be submitted to the controller.
- * @UFSHCD_STATE_EH_SCHEDULED_FATAL: The error handler has been scheduled. Fail
- *	newly submitted SCSI commands with error code DID_BAD_TARGET.
  * @UFSHCD_STATE_ERROR: An unrecoverable error occurred, e.g. link recovery
  *	failed. Fail all SCSI commands with error code DID_ERROR.
  */
 enum ufshcd_state {
 	UFSHCD_STATE_RESET,
 	UFSHCD_STATE_OPERATIONAL,
-	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
-	UFSHCD_STATE_EH_SCHEDULED_FATAL,
 	UFSHCD_STATE_ERROR,
 };

@@ -715,8 +709,7 @@ struct ufs_hba_monitor {
  * @is_powered: flag to check if HBA is powered
  * @shutting_down: flag to check if shutdown has been invoked
  * @host_sem: semaphore used to serialize concurrent contexts
- * @eh_wq: Workqueue that eh_work works on
- * @eh_work: Worker to handle UFS errors that require s/w attention
+ * @eh_compl: Signaled by the UFS error handler after error handling finished.
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
  * @uic_error: UFS interconnect layer error status
@@ -817,9 +810,7 @@ struct ufs_hba {
 	bool shutting_down;
 	struct semaphore host_sem;

-	/* Work Queues */
-	struct workqueue_struct *eh_wq;
-	struct work_struct eh_work;
+	struct completion *eh_compl;
 	struct work_struct eeh_work;

 	/* HBA Errors */
