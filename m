Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD2BC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C89613BE
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGIUak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:40 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:44675 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:40 -0400
Received: by mail-pg1-f169.google.com with SMTP id u14so11073204pga.11
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mjeRe2ZT2aDgxBp30YAparOw7MGEGFodc61cMqxU+3o=;
        b=FRtmiaWAHRwjDCyO6S20i51GGfGA0kQv6ZMl3ln1Cd5+B15fVuY3z2QALTFfqxlcbB
         vhAPL6NPGVdv/IoP3uLqPIwhIEJdYKuDIwJmnIgzMf/G5928I31RQ+vrHkJaDS+Nerfr
         6vx1yxq7o32H3qfw/LQpT/nxaVxm8es7uI/5ljdRIfB/+ZH2IyAAaaCVVXC/nAXLE1Ku
         visT8US8CX3e4jfcO/1dTAlJPGHd267bJCqyO/uQ8WuPBWRVa1uAf+87tx7XtZkuXAty
         wPcWqxNqEd2JpcNuaF014bwXG9MlTAapPZpvmfU/131FtAXQXTismPjv/5e+9KN8GhlM
         t2YQ==
X-Gm-Message-State: AOAM5320nOmzkYK3cuwd+ukOuAnhif8atQLPs/WKH+Tw+vvKMxS9mXfD
        SDzQFlodgQH0tqNM+SzL/bM=
X-Google-Smtp-Source: ABdhPJzbctLFALsX/ikdyjnzi4ZPEozlIbSLi/VqCQjYqWpMm6IT3c43sv0IExTyqgIacP/RJP4bMQ==
X-Received: by 2002:aa7:8218:0:b029:316:88e:2a3a with SMTP id k24-20020aa782180000b0290316088e2a3amr39120907pfi.16.1625862476450;
        Fri, 09 Jul 2021 13:27:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 17/19] scsi: ufs: Synchronize SCSI and UFS error handling
Date:   Fri,  9 Jul 2021 13:26:36 -0700
Message-Id: <20210709202638.9480-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the SCSI error handler instead of a custom error handling strategy.
This change reduces the number of potential races in the UFS drivers since
the UFS error handler and the SCSI error handler no longer run concurrently.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 102 ++++++++++++++++++++------------------
 drivers/scsi/ufs/ufshcd.h |   4 --
 2 files changed, 55 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ae04c7ed9766..ae21240a6548 100644
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
@@ -3901,6 +3902,35 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
+{
+	lockdep_assert_held(hba->host->host_lock);
+
+	return (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR) ||
+	       (hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
+}
+
+static void ufshcd_schedule_eh(struct ufs_hba *hba)
+{
+	bool schedule_eh = false;
+	unsigned long flags;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/* handle fatal errors only when link is not in error state */
+	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
+		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
+		    ufshcd_is_saved_err_fatal(hba))
+			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
+		else
+			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
+		schedule_eh = true;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (schedule_eh)
+		scsi_schedule_eh(hba->host);
+}
+
 /**
  * ufshcd_uic_pwr_ctrl - executes UIC commands (which affects the link power
  * state) and waits for it to take effect.
@@ -3921,6 +3951,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(uic_async_done);
 	unsigned long flags;
+	bool schedule_eh = false;
 	u8 status;
 	int ret;
 	bool reenable_intr = false;
@@ -3990,10 +4021,14 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	if (ret) {
 		ufshcd_set_link_broken(hba);
-		ufshcd_schedule_eh_work(hba);
+		schedule_eh = true;
 	}
+
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (schedule_eh)
+		ufshcd_schedule_eh(hba);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
 	return ret;
@@ -5808,27 +5843,6 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 	return err_handling;
 }
 
-/* host lock must be held before calling this func */
-static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
-{
-	return (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR) ||
-	       (hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
-}
-
-/* host lock must be held before calling this func */
-static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
-{
-	/* handle fatal errors only when link is not in error state */
-	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
-		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
-		    ufshcd_is_saved_err_fatal(hba))
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
-		else
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
-		queue_work(hba->eh_wq, &hba->eh_work);
-	}
-}
-
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
 	down_write(&hba->clk_scaling_lock);
@@ -5962,11 +5976,11 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 
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
 	unsigned long flags;
 	bool err_xfer = false;
 	bool err_tm = false;
@@ -5974,10 +5988,9 @@ static void ufshcd_err_handler(struct work_struct *work)
 	int tag;
 	bool needs_reset = false, needs_restore = false;
 
-	hba = container_of(work, struct ufs_hba, eh_work);
-
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->host->host_eh_scheduled = 0;
 	if (ufshcd_err_handling_should_stop(hba)) {
 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
@@ -6291,7 +6304,6 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 					 "host_regs: ");
 			ufshcd_print_pwr_info(hba);
 		}
-		ufshcd_schedule_eh_work(hba);
 		retval |= IRQ_HANDLED;
 	}
 	/*
@@ -6303,6 +6315,10 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 	hba->errors = 0;
 	hba->uic_error = 0;
 	spin_unlock(hba->host->host_lock);
+
+	if (queue_eh_work)
+		ufshcd_schedule_eh(hba);
+
 	return retval;
 }
 
@@ -6960,15 +6976,17 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * will be to send LU reset which, again, is a spec violation.
 	 * To avoid these unnecessary/illegal steps, first we clean up
 	 * the lrb taken by this cmd and re-set it in outstanding_reqs,
-	 * then queue the eh_work and bail.
+	 * then queue the error handler and bail.
 	 */
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
 
 		spin_lock_irqsave(host->host_lock, flags);
 		hba->force_reset = true;
-		ufshcd_schedule_eh_work(hba);
 		spin_unlock_irqrestore(host->host_lock, flags);
+
+		ufshcd_schedule_eh(hba);
+
 		goto release;
 	}
 
@@ -7099,11 +7117,10 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->force_reset = true;
-	ufshcd_schedule_eh_work(hba);
 	dev_err(hba->dev, "%s: reset in progress - 1\n", __func__);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	flush_work(&hba->eh_work);
+	ufshcd_err_handler(hba->host);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ufshcd_state == UFSHCD_STATE_ERROR)
@@ -8463,8 +8480,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	if (hba->is_powered) {
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_exit_clk_gating(hba);
-		if (hba->eh_wq)
-			destroy_workqueue(hba->eh_wq);
 		ufs_debugfs_hba_exit(hba);
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
@@ -9303,6 +9318,10 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
 }
 
+static struct scsi_transport_template ufshcd_transport_template = {
+	.eh_strategy_handler = ufshcd_err_handler,
+};
+
 /**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
@@ -9329,6 +9348,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+	host->transportt = &ufshcd_transport_template;
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
@@ -9366,7 +9386,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	int err;
 	struct Scsi_Host *host = hba->host;
 	struct device *dev = hba->dev;
-	char eh_wq_name[sizeof("ufs_eh_wq_00")];
 
 	if (!mmio_base) {
 		dev_err(hba->dev,
@@ -9420,17 +9439,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
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
index b3d9b487846f..b821851a62eb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -715,8 +715,6 @@ struct ufs_hba_monitor {
  * @is_powered: flag to check if HBA is powered
  * @shutting_down: flag to check if shutdown has been invoked
  * @host_sem: semaphore used to serialize concurrent contexts
- * @eh_wq: Workqueue that eh_work works on
- * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
  * @uic_error: UFS interconnect layer error status
@@ -818,8 +816,6 @@ struct ufs_hba {
 	struct semaphore host_sem;
 
 	/* Work Queues */
-	struct workqueue_struct *eh_wq;
-	struct work_struct eh_work;
 	struct work_struct eeh_work;
 
 	/* HBA Errors */
