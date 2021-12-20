Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762F8C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhLTOEm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhLTOEj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC07BC061746
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id v19so8195670plo.7
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Gvc9qO/vkjd6YIw2lmoAcT+7I/3DQh8TA/2x7v5HEi8=;
        b=V8HEr6F7YH3ngIlue+xCONDk/sqM+vElf4RLWy8l6rMQmr3tn1p+GLQK9t78O0V1N8
         s+yHspuByhSWEt7e7KSUGJQ4UbgQgk5cXqUEmW1zGuX7+rYPbZmQaMdQLOwRJeujDuRd
         dEsmRicEFvSlnaftLyGD70Vh8dKLKw0tCW27Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Gvc9qO/vkjd6YIw2lmoAcT+7I/3DQh8TA/2x7v5HEi8=;
        b=R/LhJATxqJG1g1pCe6Vrjld5gvsRBLyonLotGujQMPHq/FwP7bAhXvTL9PUbcDQ3ku
         DW95lB0xuOJ1nqwARfU/8dgiG5GOnpLWQPZ5zIcyKGYiMaRpo/cu1Z5FGXGMhSd0bJ73
         JGXce2EIG+NqRpt9UeKOhhJWvz+DjLrfDVMBneCmcvtKbehB8ReY9aUYGQqsy86xuJJA
         aopJ4wkhgLYaZDNwaKIucBoZaf7XL1PI46D+ss3F2mB9mtuF+upbftiXu2+EmkcXVwyW
         SY3UTabvXQXsaXMmptsCLSh+ctwH7w2uzoevdLMF+N30SqeM3ndgycVQZ7jHXjGwt6dJ
         cgTw==
X-Gm-Message-State: AOAM532uaq9oxxKLFzEzqeo/HGFTcp9+4Qh167NMnbAQ5qsLopqJKcXs
        RKFAMijuVGuNWQ9uCOy77rADmqtQUvRBEe2SgBNC+ryFVNo848UnW/6xuDvXm+GiKbN1t0Nf1QH
        2J9EH8USrm0Rx993ZLW3ut2GcwH2azZw8SjuddxhhZaCJPNX1mSzQlsvMwSIYJNRnxGvIzCEckq
        qkqvGW/u8o
X-Google-Smtp-Source: ABdhPJywFDpJvWe6gxl3BWKWxbh0JYQZ5Yne/nUxqMcEUj3tzBC3Ejvbkph8eQSL1XPBXnU3dH6DtQ==
X-Received: by 2002:a17:902:b905:b0:148:d0bd:975f with SMTP id bf5-20020a170902b90500b00148d0bd975fmr17286995plb.171.1640009077685;
        Mon, 20 Dec 2021 06:04:37 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:36 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 16/25] mpi3mr: Detect async reset occurred in firmware
Date:   Mon, 20 Dec 2021 19:41:50 +0530
Message-Id: <20211220141159.16117-17-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008a814105d3945ec2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008a814105d3945ec2
Content-Transfer-Encoding: 8bit

Detect asynchronous reset that occurred in the firmware
by polling for reset history bit of IOC status register
is set and if that bit is set, then the driver waits for
the controller to become ready and then re-initialize the
controller.

Also reduce the time driver is waiting for the controller
to acknowledge the reset action after issuing a specific
reset action to the controller. The wait time is reduced
from 510 seconds to 30 seconds. If the controller didn't
acknowledge a specific reset action within the time
interval then the driver marks the controller as
unrecoverable instead of retrying two more times
prior to giving up.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  12 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 233 ++++++++++++--------------------
 drivers/scsi/mpi3mr/mpi3mr_os.c |  38 ++++--
 3 files changed, 120 insertions(+), 163 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index ea5f27f..b24efe2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -110,6 +110,7 @@ extern int prot_mask;
 #define MPI3MR_TSUPDATE_INTERVAL		900
 #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
 #define	MPI3MR_RAID_ERRREC_RESET_TIMEOUT	180
+#define MPI3MR_RESET_ACK_TIMEOUT		30
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
@@ -210,7 +211,8 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_GETPKGVER_TIMEOUT = 21,
 	MPI3MR_RESET_FROM_PELABORT_TIMEOUT = 22,
 	MPI3MR_RESET_FROM_SYSFS = 23,
-	MPI3MR_RESET_FROM_SYSFS_TIMEOUT = 24
+	MPI3MR_RESET_FROM_SYSFS_TIMEOUT = 24,
+	MPI3MR_RESET_FROM_FIRMWARE = 27,
 };
 
 /**
@@ -678,9 +680,9 @@ struct scmd_priv {
  * @removepend_bitmap: Remove pending bitmap
  * @delayed_rmhs_list: Delayed device removal list
  * @ts_update_counter: Timestamp update counter
- * @fault_dbg: Fault debug flag
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
+ * @prev_reset_result: Result of previous reset
  * @reset_mutex: Controller reset mutex
  * @reset_waitq: Controller reset  wait queue
  * @diagsave_timeout: Diagnostic information save timeout
@@ -804,9 +806,9 @@ struct mpi3mr_ioc {
 	struct list_head delayed_rmhs_list;
 
 	u32 ts_update_counter;
-	u8 fault_dbg;
 	u8 reset_in_progress;
 	u8 unrecoverable;
+	int prev_reset_result;
 	struct mutex reset_mutex;
 	wait_queue_head_t reset_waitq;
 
@@ -891,8 +893,6 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
 
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 			      u32 reset_reason, u8 snapdump);
-int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
-				   u32 reset_reason);
 void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
 void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
 
@@ -907,5 +907,7 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc);
 void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_delayed_rmhs_list(struct mpi3mr_ioc *mrioc);
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
+void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc);
+void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index a7cd02f..4d048e5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -808,6 +808,7 @@ static const struct {
 	},
 	{ MPI3MR_RESET_FROM_SYSFS, "sysfs invocation" },
 	{ MPI3MR_RESET_FROM_SYSFS_TIMEOUT, "sysfs TM timeout" },
+	{ MPI3MR_RESET_FROM_FIRMWARE, "firmware asynchronus reset" },
 };
 
 /**
@@ -872,7 +873,7 @@ static const char *mpi3mr_reset_type_name(u16 reset_type)
  *
  * Return: Nothing.
  */
-static void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc)
+void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc)
 {
 	u32 ioc_status, code, code1, code2, code3;
 
@@ -970,25 +971,25 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 	ioc_config &= ~MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC;
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 
-	timeout = mrioc->ready_timeout * 10;
+	timeout = MPI3MR_RESET_ACK_TIMEOUT * 10;
 	do {
 		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 		if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY)) {
 			mpi3mr_clear_reset_history(mrioc);
-			ioc_config =
-			    readl(&mrioc->sysif_regs->ioc_configuration);
-			if (!((ioc_status & MPI3_SYSIF_IOC_STATUS_READY) ||
-			      (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) ||
-			    (ioc_config & MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC))) {
-				retval = 0;
-				break;
-			}
+			break;
+		}
+		if (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) {
+			mpi3mr_print_fault_info(mrioc);
+			break;
 		}
 		msleep(100);
 	} while (--timeout);
 
-	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
+	if (timeout && !((ioc_status & MPI3_SYSIF_IOC_STATUS_READY) ||
+	      (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) ||
+	      (ioc_config & MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC)))
+		retval = 0;
 
 	ioc_info(mrioc, "Base IOC Sts/Config after %s MUR is (0x%x)/(0x%x)\n",
 	    (!retval) ? "successful" : "failed", ioc_status, ioc_config);
@@ -1117,7 +1118,6 @@ static inline bool
 mpi3mr_soft_reset_success(u32 ioc_status, u32 ioc_config)
 {
 	if (!((ioc_status & MPI3_SYSIF_IOC_STATUS_READY) ||
-	    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) ||
 	    (ioc_config & MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC)))
 		return true;
 	return false;
@@ -1140,8 +1140,10 @@ static inline bool mpi3mr_diagfault_success(struct mpi3mr_ioc *mrioc,
 	if (!(ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT))
 		return false;
 	fault = readl(&mrioc->sysif_regs->fault) & MPI3_SYSIF_FAULT_CODE_MASK;
-	if (fault == MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET)
+	if (fault == MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET) {
+		mpi3mr_print_fault_info(mrioc);
 		return true;
+	}
 	return false;
 }
 
@@ -1180,26 +1182,36 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
 	u32 reset_reason)
 {
 	int retval = -1;
-	u8 unlock_retry_count, reset_retry_count = 0;
-	u32 host_diagnostic, timeout, ioc_status, ioc_config;
+	u8 unlock_retry_count = 0;
+	u32 host_diagnostic, ioc_status, ioc_config;
+	u32 timeout = MPI3MR_RESET_ACK_TIMEOUT * 10;
 
-	pci_cfg_access_lock(mrioc->pdev);
 	if ((reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) &&
 	    (reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT))
-		goto out;
+		return retval;
 	if (mrioc->unrecoverable)
-		goto out;
-retry_reset:
-	unlock_retry_count = 0;
+		return retval;
+	if (reset_reason == MPI3MR_RESET_FROM_FIRMWARE) {
+		retval = 0;
+		return retval;
+	}
+
+	ioc_info(mrioc, "%s reset due to %s(0x%x)\n",
+	    mpi3mr_reset_type_name(reset_type),
+	    mpi3mr_reset_rc_name(reset_reason), reset_reason);
+
 	mpi3mr_clear_reset_history(mrioc);
 	do {
 		ioc_info(mrioc,
 		    "Write magic sequence to unlock host diag register (retry=%d)\n",
 		    ++unlock_retry_count);
 		if (unlock_retry_count >= MPI3MR_HOSTDIAG_UNLOCK_RETRY_COUNT) {
-			writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
+			ioc_err(mrioc,
+			    "%s reset failed due to unlock failure, host_diagnostic(0x%08x)\n",
+			    mpi3mr_reset_type_name(reset_type),
+			    host_diagnostic);
 			mrioc->unrecoverable = 1;
-			goto out;
+			return retval;
 		}
 
 		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_FLUSH,
@@ -1224,31 +1236,26 @@ retry_reset:
 	} while (!(host_diagnostic & MPI3_SYSIF_HOST_DIAG_DIAG_WRITE_ENABLE));
 
 	writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
-	ioc_info(mrioc, "%s reset due to %s(0x%x)\n",
-	    mpi3mr_reset_type_name(reset_type),
-	    mpi3mr_reset_rc_name(reset_reason), reset_reason);
 	writel(host_diagnostic | reset_type,
 	    &mrioc->sysif_regs->host_diagnostic);
-	timeout = mrioc->ready_timeout * 10;
-	if (reset_type == MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) {
+	switch (reset_type) {
+	case MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET:
 		do {
 			ioc_status = readl(&mrioc->sysif_regs->ioc_status);
-			if (ioc_status &
-			    MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) {
+			ioc_config =
+			    readl(&mrioc->sysif_regs->ioc_configuration);
+			if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY)
+			    && mpi3mr_soft_reset_success(ioc_status, ioc_config)
+			    ) {
 				mpi3mr_clear_reset_history(mrioc);
-				ioc_config =
-				    readl(&mrioc->sysif_regs->ioc_configuration);
-				if (mpi3mr_soft_reset_success(ioc_status,
-				    ioc_config)) {
-					retval = 0;
-					break;
-				}
+				retval = 0;
+				break;
 			}
 			msleep(100);
 		} while (--timeout);
-		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
-		    &mrioc->sysif_regs->write_sequence);
-	} else if (reset_type == MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT) {
+		mpi3mr_print_fault_info(mrioc);
+		break;
+	case MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT:
 		do {
 			ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 			if (mpi3mr_diagfault_success(mrioc, ioc_status)) {
@@ -1257,28 +1264,22 @@ retry_reset:
 			}
 			msleep(100);
 		} while (--timeout);
-		mpi3mr_clear_reset_history(mrioc);
-		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
-		    &mrioc->sysif_regs->write_sequence);
-	}
-	if (retval && ((++reset_retry_count) < MPI3MR_MAX_RESET_RETRY_COUNT)) {
-		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
-		ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
-		ioc_info(mrioc,
-		    "Base IOC Sts/Config after reset try %d is (0x%x)/(0x%x)\n",
-		    reset_retry_count, ioc_status, ioc_config);
-		goto retry_reset;
+		break;
+	default:
+		break;
 	}
 
-out:
-	pci_cfg_access_unlock(mrioc->pdev);
-	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
-	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
+	writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
+	    &mrioc->sysif_regs->write_sequence);
 
+	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	ioc_info(mrioc,
-	    "Base IOC Sts/Config after %s reset is (0x%x)/(0x%x)\n",
-	    (!retval) ? "successful" : "failed", ioc_status,
+	    "ioc_status/ioc_onfig after %s reset is (0x%x)/(0x%x)\n",
+	    (!retval)?"successful":"failed", ioc_status,
 	    ioc_config);
+	if (retval)
+		mrioc->unrecoverable = 1;
 	return retval;
 }
 
@@ -2190,6 +2191,9 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	enum mpi3mr_iocstate ioc_state;
 	u32 fault, host_diagnostic;
 
+	if (mrioc->reset_in_progress || mrioc->unrecoverable)
+		return;
+
 	if (mrioc->ts_update_counter++ >= MPI3MR_TSUPDATE_INTERVAL) {
 		mrioc->ts_update_counter = 0;
 		mpi3mr_sync_timestamp(mrioc);
@@ -2300,41 +2304,6 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc)
 	}
 }
 
-/**
- * mpi3mr_kill_ioc - Kill the controller
- * @mrioc: Adapter instance reference
- * @reason: reason for the failure.
- *
- * If fault debug is enabled, display the fault info else issue
- * diag fault and freeze the system for controller debug
- * purpose.
- *
- * Return: Nothing.
- */
-static void mpi3mr_kill_ioc(struct mpi3mr_ioc *mrioc, u32 reason)
-{
-	enum mpi3mr_iocstate ioc_state;
-
-	if (!mrioc->fault_dbg)
-		return;
-
-	dump_stack();
-
-	ioc_state = mpi3mr_get_iocstate(mrioc);
-	if (ioc_state == MRIOC_STATE_FAULT)
-		mpi3mr_print_fault_info(mrioc);
-	else {
-		ioc_err(mrioc, "Firmware is halted due to the reason %d\n",
-		    reason);
-		mpi3mr_diagfault_reset_handler(mrioc, reason);
-	}
-	if (mrioc->fault_dbg == 2)
-		for (;;)
-			;
-	else
-		panic("panic in %s\n", __func__);
-}
-
 /**
  * mpi3mr_setup_admin_qpair - Setup admin queue pair
  * @mrioc: Adapter instance reference
@@ -4039,41 +4008,6 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 	}
 }
 
-/**
- * mpi3mr_diagfault_reset_handler - Diag fault reset handler
- * @mrioc: Adapter instance reference
- * @reset_reason: Reset reason code
- *
- * This is an handler for issuing diag fault reset from the
- * applications through IOCTL path to stop the execution of the
- * controller
- *
- * Return: 0 on success, non-zero on failure.
- */
-int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
-	u32 reset_reason)
-{
-	int retval = 0;
-
-	ioc_info(mrioc, "Entry: reason code: %s\n",
-	    mpi3mr_reset_rc_name(reset_reason));
-	mrioc->reset_in_progress = 1;
-
-	mpi3mr_ioc_disable_intr(mrioc);
-
-	retval = mpi3mr_issue_reset(mrioc,
-	    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
-
-	if (retval) {
-		ioc_err(mrioc, "The diag fault reset failed: reason %d\n",
-		    reset_reason);
-		mpi3mr_ioc_enable_intr(mrioc);
-	}
-	ioc_info(mrioc, "%s\n", ((retval == 0) ? "SUCCESS" : "FAILED"));
-	mrioc->reset_in_progress = 0;
-	return retval;
-}
-
 /**
  * mpi3mr_soft_reset_handler - Reset the controller
  * @mrioc: Adapter instance reference
@@ -4102,34 +4036,44 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	unsigned long flags;
 	u32 host_diagnostic, timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
 
-	if (mrioc->fault_dbg) {
-		if (snapdump)
-			mpi3mr_set_diagsave(mrioc);
-		mpi3mr_kill_ioc(mrioc, reset_reason);
-	}
-
+	/* Block the reset handler until diag save in progress*/
+	dprint_reset(mrioc,
+	    "soft_reset_handler: check and block on diagsave_timeout(%d)\n",
+	    mrioc->diagsave_timeout);
+	while (mrioc->diagsave_timeout)
+		ssleep(1);
 	/*
 	 * Block new resets until the currently executing one is finished and
 	 * return the status of the existing reset for all blocked resets
 	 */
+	dprint_reset(mrioc, "soft_reset_handler: acquiring reset_mutex\n");
 	if (!mutex_trylock(&mrioc->reset_mutex)) {
-		ioc_info(mrioc, "Another reset in progress\n");
-		return -1;
+		ioc_info(mrioc,
+		    "controller reset triggered by %s is blocked due to another reset in progress\n",
+		    mpi3mr_reset_rc_name(reset_reason));
+		do {
+			ssleep(1);
+		} while (mrioc->reset_in_progress == 1);
+		ioc_info(mrioc,
+		    "returning previous reset result(%d) for the reset triggered by %s\n",
+		    mrioc->prev_reset_result,
+		    mpi3mr_reset_rc_name(reset_reason));
+		return mrioc->prev_reset_result;
 	}
+	ioc_info(mrioc, "controller reset is triggered by %s\n",
+	    mpi3mr_reset_rc_name(reset_reason));
+
 	mrioc->reset_in_progress = 1;
+	mrioc->prev_reset_result = -1;
 
 	if ((!snapdump) && (reset_reason != MPI3MR_RESET_FROM_FAULT_WATCH) &&
+	    (reset_reason != MPI3MR_RESET_FROM_FIRMWARE) &&
 	    (reset_reason != MPI3MR_RESET_FROM_CIACTIV_FAULT)) {
 		for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 			mrioc->event_masks[i] = -1;
 
-		retval = mpi3mr_issue_event_notification(mrioc);
-
-		if (retval) {
-			ioc_err(mrioc,
-			    "Failed to turn off events prior to reset %d\n",
-			    retval);
-		}
+		dprint_reset(mrioc, "soft_reset_handler: masking events\n");
+		mpi3mr_issue_event_notification(mrioc);
 	}
 
 	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
@@ -4177,8 +4121,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 
 out:
 	if (!retval) {
+		mrioc->diagsave_timeout = 0;
 		mrioc->reset_in_progress = 0;
-		scsi_unblock_requests(mrioc->shost);
 		mpi3mr_rfresh_tgtdevs(mrioc);
 		mrioc->ts_update_counter = 0;
 		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
@@ -4194,8 +4138,9 @@ out:
 		mrioc->reset_in_progress = 0;
 		retval = -1;
 	}
-
+	mrioc->prev_reset_result = retval;
 	mutex_unlock(&mrioc->reset_mutex);
-	ioc_info(mrioc, "%s\n", ((retval == 0) ? "SUCCESS" : "FAILED"));
+	ioc_info(mrioc, "controller reset is %s\n",
+	    ((retval == 0) ? "successful" : "failed"));
 	return retval;
 }
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e17b2c1..38e1043 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3073,32 +3073,42 @@ static int mpi3mr_scan_finished(struct Scsi_Host *shost,
 {
 	struct mpi3mr_ioc *mrioc = shost_priv(shost);
 	u32 pe_timeout = MPI3MR_PORTENABLE_TIMEOUT;
+	u32 ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 
-	if (time >= (pe_timeout * HZ)) {
+	if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
+	    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)) {
+		ioc_err(mrioc, "port enable failed due to fault or reset\n");
+		mpi3mr_print_fault_info(mrioc);
+		mrioc->scan_failed = MPI3_IOCSTATUS_INTERNAL_ERROR;
+		mrioc->scan_started = 0;
 		mrioc->init_cmds.is_waiting = 0;
 		mrioc->init_cmds.callback = NULL;
 		mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
-		ioc_err(mrioc, "%s :port enable request timed out\n", __func__);
-		mrioc->is_driver_loading = 0;
-		mpi3mr_soft_reset_handler(mrioc,
-		    MPI3MR_RESET_FROM_PE_TIMEOUT, 1);
 	}
 
-	if (mrioc->scan_failed) {
-		ioc_err(mrioc,
-		    "%s :port enable failed with (ioc_status=0x%08x)\n",
-		    __func__, mrioc->scan_failed);
-		mrioc->is_driver_loading = 0;
-		mrioc->stop_drv_processing = 1;
-		return 1;
+	if (time >= (pe_timeout * HZ)) {
+		ioc_err(mrioc, "port enable failed due to time out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
+		    MPI3MR_RESET_FROM_PE_TIMEOUT);
+		mrioc->scan_failed = MPI3_IOCSTATUS_INTERNAL_ERROR;
+		mrioc->scan_started = 0;
+		mrioc->init_cmds.is_waiting = 0;
+		mrioc->init_cmds.callback = NULL;
+		mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
 	}
 
 	if (mrioc->scan_started)
 		return 0;
-	ioc_info(mrioc, "%s :port enable: SUCCESS\n", __func__);
+
+	if (mrioc->scan_failed) {
+		ioc_err(mrioc,
+		    "port enable failed with status=0x%04x\n",
+		    mrioc->scan_failed);
+	} else
+		ioc_info(mrioc, "port enable is successfully completed\n");
+
 	mpi3mr_start_watchdog(mrioc);
 	mrioc->is_driver_loading = 0;
-
 	return 1;
 }
 
-- 
2.27.0


--0000000000008a814105d3945ec2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIN/oHz8IVw8+UWU08aB9
GXsIlWJ0G8PtX+IQNiESdONJMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBwnbGUVQKoC7j2/gxW0wPiNjaHxOy5j6D2aFTk
ghBnzfIIuPY6Avk/NeQjANOz08n+wMuAvvowUMIMbtDBrlkZNnHYK3oVj4yCKjw8Sn0+/1SUpQ48
SA9ckdu5kFnGH6zRR1+fin+tYMIYcv5DcB62cFvhW6iFFC8vgsMrGx+PmeQZ9+S+HDUsQLgug8BF
1erj2a9jPDbGJmyGXsfbR7oz4CtNtvELxyuFPmRvVGcXquHPdoOXySq2CtXNtoKkWYCAR51f1zG0
3aKyLgMrjkkQp9gKGefd18gIwzHScEN/LpiChJm4p79C5zl76CqLd9SZqCUIXnsiT3UW1+WFYE60
--0000000000008a814105d3945ec2--
