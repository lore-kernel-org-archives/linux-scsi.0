Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CD5C2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8363620828
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WjWL6I4a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfLZLOG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:14:06 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:36776 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZLOG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:14:06 -0500
Received: by mail-wm1-f53.google.com with SMTP id p17so5860580wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Iy4FW1K06V2+9ZjA6VZjTG18TYcWypi0jcaRrzEXWQ=;
        b=WjWL6I4alIr5TbNnMAnztb2BLbXck7La5VffMzjgr0/kdlt+ZyyAJ6Gvu9tR4sIgZl
         r5keIBLTtEb3CIZC3FJMyhjzM6MXAE1GoVxORhqbLzOpR6aQs7OFNiD3N/V4v+Jz1Qw6
         yLV5K3vsrLh4h8eGq02FK1O3vq0imORs77irQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6Iy4FW1K06V2+9ZjA6VZjTG18TYcWypi0jcaRrzEXWQ=;
        b=EpZ1RByKThyHRjySayO7mSFKcGE7yDBniXRIjuU02lypFMRO9iS5dlR7jsIKDhxOkj
         15fCGsVT4oGyQ9RpmLxMEGI0NjmiqZy9JZ+0fGi86wetgKrxRyJB39qGtGLyGinUmvhe
         iCHgBNINGgdkhFoWWd6dPF/aFXgewPF2GI/a+Yi3bfCvZ7SKUHR/DDwxQBgC9j4sBXri
         hZEzmFtieWaMxnJsO1p8+lCjVAFTJaG1buF3tGO3Kdx0Oj4Amd5TPiYc7hDcgsVCAQE+
         +f08JJtVOgMlnQfh6H/jwSLJPCshzZazvnGhIQEmzSj/3qjUZtxtRhcdwvwbkeRjB8WR
         NvZw==
X-Gm-Message-State: APjAAAU3638F7jeftOyLrSB95Oq0D9Tt2cPh1P5JyXLlceVJmFJuXWXt
        4WXuSGdAIaaCDFt9ehFzR+MKVfq6fW9aayuCZ8iuxHG6IQ4PRIzpa6VRRDmBE2Qi7YLmL+0cn9+
        rPHm6KN6H8DEmhbAaVgahqKRb/1xO6sUb1ySoekd14fNjBx7unDXH/4Q5iJxGYgq8w2OacV0qPw
        dq/bViwkOY
X-Google-Smtp-Source: APXvYqx/JErGEzeg15IDVyqr6nZYo0yXFGQe7Z3Xl7XqtjqKUTXzwo2NXqo1vI9Wx/hXHtTI+ZDVzA==
X-Received: by 2002:a1c:4b0a:: with SMTP id y10mr14231577wma.78.1577358842331;
        Thu, 26 Dec 2019 03:14:02 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:14:01 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 05/10] mpt3sas: Handle CoreDump state from watchdog thread
Date:   Thu, 26 Dec 2019 06:13:28 -0500
Message-Id: <20191226111333.26131-6-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
References: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Watchdog thread polls for IOC state for every one second.
If it detects that IOC state is in CoreDump state then it
will immediately stops the IOs and also clears the
outstanding commands issued to the HBA firmware and then
it will poll for IOC state to be out of CoreDump state and
once it detects that IOC state is changed from CoreDump
state to Fault state (or) CoreDumpTOSec number of seconds
are elapsed then it will issue host reset operation and
moves the IOC state to Operational state and resumes
the IOs.

Whenever any TM is received from SML then if driver detects
the IOC state is in CoreDump state then it will wait for
CoreDump state to be cleared and will host reset operation.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 76 +++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 19 +++++++
 3 files changed, 91 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 2e4be9a..0ffbe37 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -128,6 +128,10 @@ _base_wait_on_iocstate(struct MPT3SAS_ADAPTER *ioc,
 		u32 ioc_state, int timeout);
 static int
 _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc);
+static void
+_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc);
+static void
+_base_clear_outstanding_commands(struct MPT3SAS_ADAPTER *ioc);
 
 /**
  * mpt3sas_base_check_cmd_timeout - Function
@@ -612,7 +616,8 @@ _base_fault_reset_work(struct work_struct *work)
 
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->shost_recovery || ioc->pci_error_recovery)
+	if ((ioc->shost_recovery && (ioc->ioc_coredump_loop == 0)) ||
+			ioc->pci_error_recovery)
 		goto rearm_timer;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
@@ -659,20 +664,64 @@ _base_fault_reset_work(struct work_struct *work)
 		return; /* don't rearm timer */
 	}
 
-	ioc->non_operational_loop = 0;
+	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_COREDUMP) {
+		u8 timeout = (ioc->manu_pg11.CoreDumpTOSec) ?
+		    ioc->manu_pg11.CoreDumpTOSec :
+		    MPT3SAS_DEFAULT_COREDUMP_TIMEOUT_SECONDS;
+
+		timeout /= (FAULT_POLLING_INTERVAL/1000);
+
+		if (ioc->ioc_coredump_loop == 0) {
+			mpt3sas_base_coredump_info(ioc,
+			    doorbell & MPI2_DOORBELL_DATA_MASK);
+			/* do not accept any IOs and disable the interrupts */
+			spin_lock_irqsave(
+			    &ioc->ioc_reset_in_progress_lock, flags);
+			ioc->shost_recovery = 1;
+			spin_unlock_irqrestore(
+			    &ioc->ioc_reset_in_progress_lock, flags);
+			_base_mask_interrupts(ioc);
+			_base_clear_outstanding_commands(ioc);
+		}
+
+		ioc_info(ioc, "%s: CoreDump loop %d.",
+		    __func__, ioc->ioc_coredump_loop);
+
+		/* Wait until CoreDump completes or times out */
+		if (ioc->ioc_coredump_loop++ < timeout) {
+			spin_lock_irqsave(
+			    &ioc->ioc_reset_in_progress_lock, flags);
+			goto rearm_timer;
+		}
+	}
 
+	if (ioc->ioc_coredump_loop) {
+		if ((doorbell & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_COREDUMP)
+			ioc_err(ioc, "%s: CoreDump completed. LoopCount: %d",
+			    __func__, ioc->ioc_coredump_loop);
+		else
+			ioc_err(ioc, "%s: CoreDump Timed out. LoopCount: %d",
+			    __func__, ioc->ioc_coredump_loop);
+		ioc->ioc_coredump_loop = MPT3SAS_COREDUMP_LOOP_DONE;
+	}
+	ioc->non_operational_loop = 0;
 	if ((doorbell & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL) {
 		rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 		ioc_warn(ioc, "%s: hard reset: %s\n",
 			 __func__, rc == 0 ? "success" : "failed");
 		doorbell = mpt3sas_base_get_iocstate(ioc, 0);
-		if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT)
+		if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 			mpt3sas_base_fault_info(ioc, doorbell &
 			    MPI2_DOORBELL_DATA_MASK);
+		} else if ((doorbell & MPI2_IOC_STATE_MASK) ==
+		    MPI2_IOC_STATE_COREDUMP)
+			mpt3sas_base_coredump_info(ioc, doorbell &
+			    MPI2_DOORBELL_DATA_MASK);
 		if (rc && (doorbell & MPI2_IOC_STATE_MASK) !=
 		    MPI2_IOC_STATE_OPERATIONAL)
 			return; /* don't rearm timer */
 	}
+	ioc->ioc_coredump_loop = 0;
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
  rearm_timer:
@@ -6815,9 +6864,19 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 	}
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_COREDUMP) {
-		mpt3sas_base_coredump_info(ioc, ioc_state &
-		    MPI2_DOORBELL_DATA_MASK);
-		mpt3sas_base_wait_for_coredump_completion(ioc, __func__);
+		/*
+		 * if host reset is invoked while watch dog thread is waiting
+		 * for IOC state to be changed to Fault state then driver has
+		 * to wait here for CoreDump state to clear otherwise reset
+		 * will be issued to the FW and FW move the IOC state to
+		 * reset state without copying the FW logs to coredump region.
+		 */
+		if (ioc->ioc_coredump_loop != MPT3SAS_COREDUMP_LOOP_DONE) {
+			mpt3sas_base_coredump_info(ioc, ioc_state &
+			    MPI2_DOORBELL_DATA_MASK);
+			mpt3sas_base_wait_for_coredump_completion(ioc,
+			    __func__);
+		}
 		goto issue_diag_reset;
 	}
 
@@ -7301,6 +7360,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	    sizeof(struct mpt3sas_facts));
 
 	ioc->non_operational_loop = 0;
+	ioc->ioc_coredump_loop = 0;
 	ioc->got_task_abort_from_ioctl = 0;
 	return 0;
 
@@ -7591,7 +7651,9 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	    MPT3_DIAG_BUFFER_IS_RELEASED))) {
 		is_trigger = 1;
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
-		if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT)
+		if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT ||
+		    (ioc_state & MPI2_IOC_STATE_MASK) ==
+		    MPI2_IOC_STATE_COREDUMP)
 			is_fault = 1;
 	}
 	_base_pre_reset_handler(ioc);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d29753f..cfd12d2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -92,6 +92,7 @@
 
 /* CoreDump: Default timeout */
 #define MPT3SAS_DEFAULT_COREDUMP_TIMEOUT_SECONDS	(15) /*15 seconds*/
+#define MPT3SAS_COREDUMP_LOOP_DONE                     (0xFF)
 
 /*
  * Set MPT3SAS_SG_DEPTH value based on user input.
@@ -1054,6 +1055,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @cpu_msix_table: table for mapping cpus to msix index
  * @cpu_msix_table_sz: table size
  * @total_io_cnt: Gives total IO count, used to load balance the interrupts
+ * @ioc_coredump_loop: will have non-zero value when FW is in CoreDump state
  * @high_iops_outstanding: used to load balance the interrupts
  *				within high iops reply queues
  * @msix_load_balance: Enables load balancing of interrupts across
@@ -1244,6 +1246,7 @@ struct MPT3SAS_ADAPTER {
 	u32		ioc_reset_count;
 	MPT3SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
 	u32             non_operational_loop;
+	u8              ioc_coredump_loop;
 	atomic64_t      total_io_cnt;
 	atomic64_t	high_iops_outstanding;
 	bool            msix_load_balance;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 785835a..2c4b5c0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2751,6 +2751,12 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
 		    MPI2_DOORBELL_DATA_MASK);
 		rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 		return (!rc) ? SUCCESS : FAILED;
+	} else if ((ioc_state & MPI2_IOC_STATE_MASK) ==
+	    MPI2_IOC_STATE_COREDUMP) {
+		mpt3sas_base_coredump_info(ioc, ioc_state &
+		    MPI2_DOORBELL_DATA_MASK);
+		rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
+		return (!rc) ? SUCCESS : FAILED;
 	}
 
 	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
@@ -4527,6 +4533,7 @@ static void
 _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2EventDataTemperature_t *event_data)
 {
+	u32 doorbell;
 	if (ioc->temp_sensors_count >= event_data->SensorNum) {
 		ioc_err(ioc, "Temperature Threshold flags %s%s%s%s exceeded for Sensor: %d !!!\n",
 			le16_to_cpu(event_data->Status) & 0x1 ? "0 " : " ",
@@ -4536,6 +4543,18 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 			event_data->SensorNum);
 		ioc_err(ioc, "Current Temp In Celsius: %d\n",
 			event_data->CurrentTemperature);
+		if (ioc->hba_mpi_version_belonged != MPI2_VERSION) {
+			doorbell = mpt3sas_base_get_iocstate(ioc, 0);
+			if ((doorbell & MPI2_IOC_STATE_MASK) ==
+			    MPI2_IOC_STATE_FAULT) {
+				mpt3sas_base_fault_info(ioc,
+				    doorbell & MPI2_DOORBELL_DATA_MASK);
+			} else if ((doorbell & MPI2_IOC_STATE_MASK) ==
+			    MPI2_IOC_STATE_COREDUMP) {
+				mpt3sas_base_coredump_info(ioc,
+				    doorbell & MPI2_DOORBELL_DATA_MASK);
+			}
+		}
 	}
 }
 
-- 
2.18.1

