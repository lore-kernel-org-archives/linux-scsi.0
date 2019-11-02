Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7D7CA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC772084D
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nnPk+OqS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="m3iTHYuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfKBFEU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:04:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:04:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 644F9615EF; Sat,  2 Nov 2019 05:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671057;
        bh=yQg8i3xK6+h7x6VbavbXkpLBis8OZgKaLPJiE7kroDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnPk+OqSHGDSSI8W+qK4cS6fO/BFBC5Wu2FgVUlT2QNOek2lPEJ8RhpD34sT8/VNQ
         JADJEL/ID/SqhsKdMT9Cqrtuz5wUmwAb7ovDR7Ou4OK/X2Xe0a1nH8x2Ho+YN4a9VF
         Br1KcH7UT8lWALMcgpGU7/c2p8RORbSKLlZOw+qU=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B471661619;
        Sat,  2 Nov 2019 05:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572671047;
        bh=yQg8i3xK6+h7x6VbavbXkpLBis8OZgKaLPJiE7kroDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3iTHYuAjld1PqEVxIpgw09SkHMuIijV1ylcwq0X3sdSF01kvnT1SlzHFqZrz4h7L
         6Rt2vOfZV0D9DJzkZaYrDigTYRVrlmfJifNrLzykCdIz+mkIHcsYV4Y7VV7ZTsqoUs
         R5Ac3faKO895ni8LjuzWmjRrrk4nybNXYM7zRvQ4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B471661619
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 4/6] scsi: ufs: Fix irq return code
Date:   Fri,  1 Nov 2019 22:03:34 -0700
Message-Id: <1572671016-883-5-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572671016-883-1-git-send-email-cang@codeaurora.org>
References: <1572671016-883-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Venkat Gopalakrishnan <venkatg@codeaurora.org>

Return IRQ_HANDLED only if the irq is really handled, this will
help in catching spurious interrupts that go unhandled.

Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 134 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 99 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f12f5a7..ee591cc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -240,7 +240,7 @@ struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
 	END_FIX
 };
 
-static void ufshcd_tmc_handler(struct ufs_hba *hba);
+static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
@@ -4799,19 +4799,29 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
  * ufshcd_uic_cmd_compl - handle completion of uic command
  * @hba: per adapter instance
  * @intr_status: interrupt status generated by the controller
+ *
+ * Returns
+ *  IRQ_HANDLED - If interrupt is valid
+ *  IRQ_NONE    - If invalid interrupt
  */
-static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
+static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 {
+	irqreturn_t retval = IRQ_NONE;
+
 	if ((intr_status & UIC_COMMAND_COMPL) && hba->active_uic_cmd) {
 		hba->active_uic_cmd->argument2 |=
 			ufshcd_get_uic_cmd_result(hba);
 		hba->active_uic_cmd->argument3 =
 			ufshcd_get_dme_attr_val(hba);
 		complete(&hba->active_uic_cmd->done);
+		retval = IRQ_HANDLED;
 	}
 
-	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done)
+	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
 		complete(hba->uic_async_done);
+		retval = IRQ_HANDLED;
+	}
+	return retval;
 }
 
 /**
@@ -4867,8 +4877,12 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
+ *
+ * Returns
+ *  IRQ_HANDLED - If interrupt is valid
+ *  IRQ_NONE    - If invalid interrupt
  */
-static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
+static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
 	unsigned long completed_reqs;
 	u32 tr_doorbell;
@@ -4887,7 +4901,12 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
 
-	__ufshcd_transfer_req_compl(hba, completed_reqs);
+	if (completed_reqs) {
+		__ufshcd_transfer_req_compl(hba, completed_reqs);
+		return IRQ_HANDLED;
+	} else {
+		return IRQ_NONE;
+	}
 }
 
 /**
@@ -5406,61 +5425,77 @@ static void ufshcd_err_handler(struct work_struct *work)
 /**
  * ufshcd_update_uic_error - check and set fatal UIC error flags.
  * @hba: per-adapter instance
+ *
+ * Returns
+ *  IRQ_HANDLED - If interrupt is valid
+ *  IRQ_NONE    - If invalid interrupt
  */
-static void ufshcd_update_uic_error(struct ufs_hba *hba)
+static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
 {
 	u32 reg;
+	irqreturn_t retval = IRQ_NONE;
 
 	/* PHY layer lane error */
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
 	/* Ignore LINERESET indication, as this is not an error */
 	if ((reg & UIC_PHY_ADAPTER_LAYER_ERROR) &&
-			(reg & UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK)) {
+	    (reg & UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK)) {
 		/*
 		 * To know whether this error is fatal or not, DB timeout
 		 * must be checked but this error is handled separately.
 		 */
 		dev_dbg(hba->dev, "%s: UIC Lane error reported\n", __func__);
 		ufshcd_update_reg_hist(&hba->ufs_stats.pa_err, reg);
+		retval |= IRQ_HANDLED;
 	}
 
 	/* PA_INIT_ERROR is fatal and needs UIC reset */
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
-	if (reg)
+	if ((reg & UIC_DATA_LINK_LAYER_ERROR) &&
+	    (reg & UIC_DATA_LINK_LAYER_ERROR_CODE_MASK)) {
 		ufshcd_update_reg_hist(&hba->ufs_stats.dl_err, reg);
 
-	if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
-		hba->uic_error |= UFSHCD_UIC_DL_PA_INIT_ERROR;
-	else if (hba->dev_quirks &
-		   UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
-		if (reg & UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED)
-			hba->uic_error |=
-				UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
-		else if (reg & UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT)
-			hba->uic_error |= UFSHCD_UIC_DL_TCx_REPLAY_ERROR;
+		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
+			hba->uic_error |= UFSHCD_UIC_DL_PA_INIT_ERROR;
+		else if (hba->dev_quirks &
+				UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+			if (reg & UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED)
+				hba->uic_error |=
+					UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
+			else if (reg & UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT)
+				hba->uic_error |= UFSHCD_UIC_DL_TCx_REPLAY_ERROR;
+		}
+		retval |= IRQ_HANDLED;
 	}
 
 	/* UIC NL/TL/DME errors needs software retry */
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_NETWORK_LAYER);
-	if (reg) {
+	if ((reg & UIC_NETWORK_LAYER_ERROR) &&
+	    (reg & UIC_NETWORK_LAYER_ERROR_CODE_MASK)) {
 		ufshcd_update_reg_hist(&hba->ufs_stats.nl_err, reg);
 		hba->uic_error |= UFSHCD_UIC_NL_ERROR;
+		retval |= IRQ_HANDLED;
 	}
 
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_TRANSPORT_LAYER);
-	if (reg) {
+	if ((reg & UIC_TRANSPORT_LAYER_ERROR) &&
+	    (reg & UIC_TRANSPORT_LAYER_ERROR_CODE_MASK)) {
 		ufshcd_update_reg_hist(&hba->ufs_stats.tl_err, reg);
 		hba->uic_error |= UFSHCD_UIC_TL_ERROR;
+		retval |= IRQ_HANDLED;
 	}
 
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DME);
-	if (reg) {
+	if ((reg & UIC_DME_ERROR) &&
+	    (reg & UIC_DME_ERROR_CODE_MASK)) {
 		ufshcd_update_reg_hist(&hba->ufs_stats.dme_err, reg);
 		hba->uic_error |= UFSHCD_UIC_DME_ERROR;
+		retval |= IRQ_HANDLED;
 	}
 
 	dev_dbg(hba->dev, "%s: UIC error flags = 0x%08x\n",
 			__func__, hba->uic_error);
+	return retval;
 }
 
 static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
@@ -5483,10 +5518,15 @@ static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
 /**
  * ufshcd_check_errors - Check for errors that need s/w attention
  * @hba: per-adapter instance
+ *
+ * Returns
+ *  IRQ_HANDLED - If interrupt is valid
+ *  IRQ_NONE    - If invalid interrupt
  */
-static void ufshcd_check_errors(struct ufs_hba *hba)
+static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 {
 	bool queue_eh_work = false;
+	irqreturn_t retval = IRQ_NONE;
 
 	if (hba->errors & INT_FATAL_ERRORS) {
 		ufshcd_update_reg_hist(&hba->ufs_stats.fatal_err, hba->errors);
@@ -5495,7 +5535,7 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 
 	if (hba->errors & UIC_ERROR) {
 		hba->uic_error = 0;
-		ufshcd_update_uic_error(hba);
+		retval = ufshcd_update_uic_error(hba);
 		if (hba->uic_error)
 			queue_eh_work = true;
 	}
@@ -5543,6 +5583,7 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 			}
 			schedule_work(&hba->eh_work);
 		}
+		retval |= IRQ_HANDLED;
 	}
 	/*
 	 * if (!queue_eh_work) -
@@ -5550,44 +5591,62 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 	 * itself without s/w intervention or errors that will be
 	 * handled by the SCSI core layer.
 	 */
+	return retval;
 }
 
 /**
  * ufshcd_tmc_handler - handle task management function completion
  * @hba: per adapter instance
+ *
+ * Returns
+ *  IRQ_HANDLED - If interrupt is valid
+ *  IRQ_NONE    - If invalid interrupt
  */
-static void ufshcd_tmc_handler(struct ufs_hba *hba)
+static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
 	u32 tm_doorbell;
 
 	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
-	wake_up(&hba->tm_wq);
+	if (hba->tm_condition) {
+		wake_up(&hba->tm_wq);
+		return IRQ_HANDLED;
+	} else {
+		return IRQ_NONE;
+	}
 }
 
 /**
  * ufshcd_sl_intr - Interrupt service routine
  * @hba: per adapter instance
  * @intr_status: contains interrupts generated by the controller
+ *
+ * Returns
+ *  IRQ_HANDLED - If interrupt is valid
+ *  IRQ_NONE    - If invalid interrupt
  */
-static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
+static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
+	irqreturn_t retval = IRQ_NONE;
+
 	hba->errors = UFSHCD_ERROR_MASK & intr_status;
 
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
 		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
 
 	if (hba->errors)
-		ufshcd_check_errors(hba);
+		retval |= ufshcd_check_errors(hba);
 
 	if (intr_status & UFSHCD_UIC_MASK)
-		ufshcd_uic_cmd_compl(hba, intr_status);
+		retval |= ufshcd_uic_cmd_compl(hba, intr_status);
 
 	if (intr_status & UTP_TASK_REQ_COMPL)
-		ufshcd_tmc_handler(hba);
+		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		ufshcd_transfer_req_compl(hba);
+		retval |= ufshcd_transfer_req_compl(hba);
+
+	return retval;
 }
 
 /**
@@ -5595,8 +5654,9 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
  * @irq: irq number
  * @__hba: pointer to adapter instance
  *
- * Returns IRQ_HANDLED - If interrupt is valid
- *		IRQ_NONE - If invalid interrupt
+ * Returns
+ *  IRQ_HANDLED - If interrupt is valid
+ *  IRQ_NONE    - If invalid interrupt
  */
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
@@ -5619,14 +5679,18 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		if (intr_status)
 			ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
-		if (enabled_intr_status) {
-			ufshcd_sl_intr(hba, enabled_intr_status);
-			retval = IRQ_HANDLED;
-		}
+		if (enabled_intr_status)
+			retval |= ufshcd_sl_intr(hba, enabled_intr_status);
 
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	} while (intr_status && --retries);
 
+	if (retval == IRQ_NONE) {
+		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
+					__func__, intr_status);
+		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
+	}
+
 	spin_unlock(hba->host->host_lock);
 	return retval;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

