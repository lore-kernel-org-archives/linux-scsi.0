Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4354BC38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 12:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiIHMlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 08:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiIHMlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 08:41:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E608BCD501
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 05:41:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso2278955pjk.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 05:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date;
        bh=haMBP14o/PkzMPK995Ew2XJwuBgfLJ0mjBf4zakAwbU=;
        b=XTXx0Cq0hHAC+UO4CvFSNSgVKB3MT22C214Fg3SufZrwyV85B7+b6Ox6yQLbc5pN/Z
         iwD6bMTOSABxoSCy+5JqZ4zXlnlVNVh+Pbuko5r03eD96QMnQpUkkQHO6GGH4oTWyaoQ
         BW2efItXbJM+z2H3BZyGVmTfcKbmDkhYQhc4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=haMBP14o/PkzMPK995Ew2XJwuBgfLJ0mjBf4zakAwbU=;
        b=AZr+EP0LQVCdlYZ0DzS2Kn1lI5j/DHuqC8YR0sev7wGUGOvh3TYjFTLSW5rE3DAdBC
         B6gS9xTwQ6CsDuJdKcW6/iXJwW4P6e2j6AJ/xMd0mBOuvVCIE6KnZbCK8E51CTJbGcsK
         b7iymNiGCVFrkX8qv3gNH+x02pzd63lgVn/br5MYwaDaw+etorkgln9pdcjfB/4Djq3o
         xVrWte4SzgF2RvlXGZEM+RoNBpnYmgFtKFvzu8+cR0n4Ern+spiLPBdIjtgUpp765Byd
         gO6JkpxDQwVofmN1t0lofEf63vn3aNUryl8TZesfC0r5sf/td0giAohh4kmZU4X2V5hP
         MibQ==
X-Gm-Message-State: ACgBeo15pNvKIdSAu9p3VMIA0babKQyk2jVXb08LGKN3abDKD9CMpjau
        1+2Ci251mko8aqbVJJEVT6O7L5RAf6skuzuCAwrnBNU76i2/1znVt2YyytW5kt0Ypyxr4eLqVe0
        J/OigtxjKSziQKxCKzWBmAy2TdBTM5ScxpDuOTICFEI577mWRjPhqc1yr5HEGnw3wT+kfByhHo3
        GxHuRz+8ND
X-Google-Smtp-Source: AA6agR7Ayg+nuvEWkBlV5SN9l15FlQAbmGHKlFC+kofG4mX6Jm60ZI7Y7Tsu6ilrNeR38PaylwosTA==
X-Received: by 2002:a17:90b:3e84:b0:1fd:ce48:979 with SMTP id rj4-20020a17090b3e8400b001fdce480979mr3988430pjb.54.1662640882844;
        Thu, 08 Sep 2022 05:41:22 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id c17-20020a63ef51000000b0043395af24f6sm11106807pgk.25.2022.09.08.05.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:41:22 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 4/9] mpi3mr: Graceful handling of surprise removal of PCIe HBA
Date:   Thu,  8 Sep 2022 18:23:27 +0530
Message-Id: <20220908125332.21110-5-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220908125332.21110-1-sreekanth.reddy@broadcom.com>
References: <20220908125332.21110-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003eeaec05e829bf60"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003eeaec05e829bf60
Content-Transfer-Encoding: 8bit

Graceful handling of surprise or orderly removal of PCIe HBA with
below changes,
- Detect a hot removal of the controller at certain critical places
 in the driver. Early detection will help to reduce the time taken for
 cleaning up the hot removed controller at the driver level.
- Poll the status of the port enable issued after reset once in every
 5 seconds to avoid a long delay in detecting unavailable controller.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   3 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 102 +++++++++++++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_os.c |  45 ++++++++++++++
 3 files changed, 142 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 0f47b45..0eb0647 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -118,6 +118,7 @@ extern atomic64_t event_counter;
 /* command/controller interaction timeout definitions in seconds */
 #define MPI3MR_INTADMCMD_TIMEOUT		60
 #define MPI3MR_PORTENABLE_TIMEOUT		300
+#define MPI3MR_PORTENABLE_POLL_INTERVAL		5
 #define MPI3MR_ABORTTM_TIMEOUT			60
 #define MPI3MR_RESETTM_TIMEOUT			60
 #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
@@ -1389,4 +1390,6 @@ void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
 void mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc);
 void mpi3mr_refresh_expanders(struct mpi3mr_ioc *mrioc);
 void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc);
+void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc);
+void mpi3mr_flush_cmds_for_unrecovered_controller(struct mpi3mr_ioc *mrioc);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 78792f2..9f03f1c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -431,6 +431,9 @@ static int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 		return 0;
 
 	do {
+		if (mrioc->unrecoverable)
+			break;
+
 		mrioc->admin_req_ci = le16_to_cpu(reply_desc->request_queue_ci);
 		mpi3mr_process_admin_reply_desc(mrioc, reply_desc, &reply_dma);
 		if (reply_dma)
@@ -516,6 +519,9 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	}
 
 	do {
+		if (mrioc->unrecoverable)
+			break;
+
 		req_q_idx = le16_to_cpu(reply_desc->request_queue_id) - 1;
 		op_req_q = &mrioc->req_qinfo[req_q_idx];
 
@@ -577,7 +583,8 @@ int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 
 	mrioc = (struct mpi3mr_ioc *)shost->hostdata;
 
-	if ((mrioc->reset_in_progress || mrioc->prepare_for_reset))
+	if ((mrioc->reset_in_progress || mrioc->prepare_for_reset ||
+	    mrioc->unrecoverable))
 		return 0;
 
 	num_entries = mpi3mr_process_op_reply_q(mrioc,
@@ -673,7 +680,7 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 
 	/* Poll for pending IOs completions */
 	do {
-		if (!mrioc->intr_enabled)
+		if (!mrioc->intr_enabled || mrioc->unrecoverable)
 			break;
 
 		if (!midx)
@@ -1220,6 +1227,14 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			msleep(100);
 		} while (--timeout);
 
+		if (!pci_device_is_present(mrioc->pdev)) {
+			mrioc->unrecoverable = 1;
+			ioc_err(mrioc,
+			    "controller is not present while waiting to reset\n");
+			retval = -1;
+			goto out_device_not_present;
+		}
+
 		ioc_state = mpi3mr_get_iocstate(mrioc);
 		ioc_info(mrioc,
 		    "controller is in %s state after waiting to reset\n",
@@ -1277,6 +1292,13 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 			    mpi3mr_iocstate_name(ioc_state));
 			return 0;
 		}
+		if (!pci_device_is_present(mrioc->pdev)) {
+			mrioc->unrecoverable = 1;
+			ioc_err(mrioc,
+			    "controller is not present at the bringup\n");
+			retval = -1;
+			goto out_device_not_present;
+		}
 		msleep(100);
 	} while (--timeout);
 
@@ -1285,6 +1307,7 @@ out_failed:
 	ioc_err(mrioc,
 	    "failed to bring to ready state,  current state: %s\n",
 	    mpi3mr_iocstate_name(ioc_state));
+out_device_not_present:
 	return retval;
 }
 
@@ -2223,6 +2246,17 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
 {
 	u32 ioc_status, host_diagnostic, timeout;
 
+	if (mrioc->unrecoverable) {
+		ioc_err(mrioc, "controller is unrecoverable\n");
+		return;
+	}
+
+	if (!pci_device_is_present(mrioc->pdev)) {
+		mrioc->unrecoverable = 1;
+		ioc_err(mrioc, "controller is not present\n");
+		return;
+	}
+
 	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
 	    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)) {
@@ -2414,9 +2448,21 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	u32 fault, host_diagnostic, ioc_status;
 	u32 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
 
-	if (mrioc->reset_in_progress || mrioc->unrecoverable)
+	if (mrioc->reset_in_progress)
 		return;
 
+	if (!mrioc->unrecoverable && !pci_device_is_present(mrioc->pdev)) {
+		ioc_err(mrioc, "watchdog could not detect the controller\n");
+		mrioc->unrecoverable = 1;
+	}
+
+	if (mrioc->unrecoverable) {
+		ioc_err(mrioc,
+		    "flush pending commands for unrecoverable controller\n");
+		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
+		return;
+	}
+
 	if (mrioc->ts_update_counter++ >= MPI3MR_TSUPDATE_INTERVAL) {
 		mrioc->ts_update_counter = 0;
 		mpi3mr_sync_timestamp(mrioc);
@@ -2460,7 +2506,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		ioc_info(mrioc,
 		    "controller requires system power cycle, marking controller as unrecoverable\n");
 		mrioc->unrecoverable = 1;
-		return;
+		goto schedule_work;
 	case MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS:
 		return;
 	case MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET:
@@ -3396,10 +3442,13 @@ out_failed:
 static void mpi3mr_port_enable_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd)
 {
-	drv_cmd->state = MPI3MR_CMD_NOTUSED;
 	drv_cmd->callback = NULL;
-	mrioc->scan_failed = drv_cmd->ioc_status;
 	mrioc->scan_started = 0;
+	if (drv_cmd->state & MPI3MR_CMD_RESET)
+		mrioc->scan_failed = MPI3_IOCSTATUS_INTERNAL_ERROR;
+	else
+		mrioc->scan_failed = drv_cmd->ioc_status;
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
 }
 
 /**
@@ -3897,6 +3946,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 	int retval = 0;
 	u8 retry = 0;
 	struct mpi3_ioc_facts_data facts_data;
+	u32 pe_timeout, ioc_status;
 
 retry_init:
 	dprint_reset(mrioc, "bringing up the controller to ready state\n");
@@ -3994,11 +4044,46 @@ retry_init:
 	}
 
 	ioc_info(mrioc, "sending port enable\n");
-	retval = mpi3mr_issue_port_enable(mrioc, 0);
+	retval = mpi3mr_issue_port_enable(mrioc, 1);
 	if (retval) {
 		ioc_err(mrioc, "failed to issue port enable\n");
 		goto out_failed;
 	}
+	do {
+		ssleep(MPI3MR_PORTENABLE_POLL_INTERVAL);
+		if (mrioc->init_cmds.state == MPI3MR_CMD_NOTUSED)
+			break;
+		if (!pci_device_is_present(mrioc->pdev))
+			mrioc->unrecoverable = 1;
+		if (mrioc->unrecoverable) {
+			retval = -1;
+			goto out_failed_noretry;
+		}
+		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+		if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
+		    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)) {
+			mpi3mr_print_fault_info(mrioc);
+			mrioc->init_cmds.is_waiting = 0;
+			mrioc->init_cmds.callback = NULL;
+			mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+			goto out_failed;
+		}
+	} while (--pe_timeout);
+
+	if (!pe_timeout) {
+		ioc_err(mrioc, "port enable timed out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
+		    MPI3MR_RESET_FROM_PE_TIMEOUT);
+		mrioc->init_cmds.is_waiting = 0;
+		mrioc->init_cmds.callback = NULL;
+		mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+		goto out_failed;
+	} else if (mrioc->scan_failed) {
+		ioc_err(mrioc,
+		    "port enable failed with status=0x%04x\n",
+		    mrioc->scan_failed);
+	} else
+		ioc_info(mrioc, "port enable completed successfully\n");
 
 	ioc_info(mrioc, "controller %s completed successfully\n",
 	    (is_resume)?"resume":"re-initialization");
@@ -4417,7 +4502,7 @@ static inline void mpi3mr_drv_cmd_comp_reset(struct mpi3mr_ioc *mrioc,
  *
  * Return: Nothing.
  */
-static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
+void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 {
 	struct mpi3mr_drv_cmd *cmdptr;
 	u8 i;
@@ -4850,6 +4935,7 @@ out:
 		mrioc->unrecoverable = 1;
 		mrioc->reset_in_progress = 0;
 		retval = -1;
+		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
 	}
 	mrioc->prev_reset_result = retval;
 	mutex_unlock(&mrioc->reset_mutex);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f1a6448..a5b6402 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -582,6 +582,39 @@ void mpi3mr_flush_host_io(struct mpi3mr_ioc *mrioc)
 	    mrioc->flush_io_count);
 }
 
+/**
+ * mpi3mr_flush_cmds_for_unrecovered_controller- Flush all pend cmds
+ * @mrioc: Adapter instance reference
+ *
+ * This function waits for currently running IO poll threads to
+ * exit and then flushes all host I/Os and any internal pending
+ * cmds. This is executed after controller is marked as
+ * unrecoverable.
+ *
+ * Return: Nothing.
+ */
+void mpi3mr_flush_cmds_for_unrecovered_controller(struct mpi3mr_ioc *mrioc)
+{
+	struct Scsi_Host *shost = mrioc->shost;
+	int i;
+
+	if (!mrioc->unrecoverable)
+		return;
+
+	if (mrioc->op_reply_qinfo) {
+		for (i = 0; i < mrioc->num_queues; i++) {
+			while (atomic_read(&mrioc->op_reply_qinfo[i].in_use))
+				udelay(500);
+			atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
+		}
+	}
+	mrioc->flush_io_count = 0;
+	blk_mq_tagset_busy_iter(&shost->tag_set,
+	    mpi3mr_flush_scmd, (void *)mrioc);
+	mpi3mr_flush_delayed_cmd_lists(mrioc);
+	mpi3mr_flush_drv_cmds(mrioc);
+}
+
 /**
  * mpi3mr_alloc_tgtdev - target device allocator
  *
@@ -1815,6 +1848,13 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (mrioc->stop_drv_processing)
 		goto out;
 
+	if (mrioc->unrecoverable) {
+		dprint_event_bh(mrioc,
+		    "ignoring event(0x%02x) in bottom half handler due to unrecoverable controller\n",
+		    fwevt->event_id);
+		goto out;
+	}
+
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
@@ -5024,6 +5064,11 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 
+	if (!pci_device_is_present(mrioc->pdev)) {
+		mrioc->unrecoverable = 1;
+		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
+	}
+
 	mpi3mr_bsg_exit(mrioc);
 	mrioc->stop_drv_processing = 1;
 	mpi3mr_cleanup_fwevt_list(mrioc);
-- 
2.27.0


--0000000000003eeaec05e829bf60
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGjoxlq2oVvy6yeNeSCX
IhTS/H4ANnbLgtGTYawZxj5oMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDkwODEyNDEyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBP3t0y7huUoG0qi3+MSpjzfQXCGCRLKdjkFz+x
sP1A+M65nJKvQlIxhf3RL34P1SvmzcAkrFKi3hu3CIqoqf9+/FuB+4DxN8oUGJm2kO+3CiSVecF3
x2+bIF+acGsBKjaCgF7x3dBZSc/05mrY9u5JxRjDrjOWXiujVliWIljVGDUuE8SeQNWlz4zAmRGE
C+z6RllRYnzDNoaXyRTtkf9Kb8RKUHyoAxLO3/8MDbHxi0qpboyTiqBr67pKRVmKxzkMcLplwH3I
oZiCiB/o+MahhuaPYYugwAU/F+kaoDRk0/geL8tdI4jN9aC1eYZAzMnAZHkTRTAz4qh+sUW9puLU
--0000000000003eeaec05e829bf60--
