Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3FAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A24720672
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Rb+7lX/6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgG3IEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgG3IEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:04:34 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC37CC061794
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:33 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q17so13313517pls.9
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4n7bJyoN6kqIWp0KEEEyHDEQfGv8rWiSooGpu41nJNQ=;
        b=Rb+7lX/6FvzlDu+07rsC+f2i7qkcRcn2rsJMRzXC+DbLRxWTgjAw/jZSOrYrrAxEL6
         CJuPdFGJqGXXlxh4gsZSDZTWePDN8B+jPAoKeDbEre4ynSQI5GFZVYJBWUtdDde9Hh4H
         pJ8VtdPeEd0fi3lSwnc5uadie6/T2b3tJCFNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4n7bJyoN6kqIWp0KEEEyHDEQfGv8rWiSooGpu41nJNQ=;
        b=eUEEYSrOH6uNf1X/z5BOAVQS8JDQi5L3gMEEeSWYYE2cFjlOhBnfuean1lExY5d9T5
         RaONcmHAx7R2oB8wC4ImcX7SKCDuaX35+NhetN57epQYJbXQhb5nydHmFkvSiRgNj+gz
         UCzsJOtzQTfkS2lAELb0vRBdigidGTsWdRY5qjfiB1vgScMOm6w1P+GQt0PXm4H4X6yt
         +zOtdNyQFw0S72aCHcOmOEJZKGCSxlYxgCKUNzuRb5DlLGPqtWkOXQYU2U5ZiWdNZEZt
         R6M2kf2L1zWk1FZZ+B+drIqvJY/1RfQOAuuZ5xEcF6lmbAIvaTT4MA03Pa+Q/37uODQ5
         c+Ng==
X-Gm-Message-State: AOAM532XACsKofoHTpJEjP52IyC+VEEhMzCsMNHwHDtoTGWhaS1kONTZ
        UdlNvm5M5OmsOeN/KdhzW81EFYVRK4y1EQ==
X-Google-Smtp-Source: ABdhPJzIttO4BL8RRusG2ZoZrmpc9hnTrq1YLjsPo550SuRDLkiQEGujV10kK3rkgkqsvBSdRU7Hug==
X-Received: by 2002:a17:90a:2e85:: with SMTP id r5mr1965212pjd.232.1596096273317;
        Thu, 30 Jul 2020 01:04:33 -0700 (PDT)
Received: from localhost.localdomain ([192.19.212.250])
        by smtp.gmail.com with ESMTPSA id d13sm5051412pfq.118.2020.07.30.01.04.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:04:32 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 5/7] mpt3sas: Added helper functions to check any cmd is outstanding on Target and LUN.
Date:   Thu, 30 Jul 2020 13:33:47 +0530
Message-Id: <1596096229-3341-6-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Added helper functions to check whether any SCSI command  is
outstanding on particular Target, LUN device,
* Added addition function parameters 'channel', 'id' to function
mpt3sas_scsih_issue_tm().

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  9 +--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  6 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 92 ++++++++++++++++++++++++----
 3 files changed, 88 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 9da7265..fd61deb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1610,11 +1610,12 @@ void mpt3sas_scsih_clear_outstanding_scsi_tm_commands(
 	struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc);
 
-int mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
-	u8 type, u16 smid_task, u16 msix_task, u8 timeout, u8 tr_method);
+int mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
+	uint channel, uint id, u64 lun, u8 type, u16 smid_task,
+	u16 msix_task, u8 timeout, u8 tr_method);
 int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
-	u64 lun, u8 type, u16 smid_task, u16 msix_task,
-	u8 timeout, u8 tr_method);
+	uint channel, uint id, u64 lun, u8 type, u16 smid_task,
+	u16 msix_task, u8 timeout, u8 tr_method);
 
 void mpt3sas_scsih_set_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
 void mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 62e5528..98d6b9c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1109,13 +1109,15 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			    pcie_device->device_info))))
 				mpt3sas_scsih_issue_locked_tm(ioc,
 				  le16_to_cpu(mpi_request->FunctionDependent1),
-				  0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
+				  0, 0, 0,
+				  MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 				  0, pcie_device->reset_timeout,
 			MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE);
 			else
 				mpt3sas_scsih_issue_locked_tm(ioc,
 				  le16_to_cpu(mpi_request->FunctionDependent1),
-				  0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
+				  0, 0, 0,
+				  MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 				  0, 30, MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET);
 		} else
 			mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 66b29d4..ce12253 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1512,6 +1512,66 @@ _scsih_is_nvme_pciescsi_device(u32 device_info)
 		return 0;
 }
 
+/**
+ * _scsih_scsi_lookup_find_by_target - search for matching channel:id
+ * @ioc: per adapter object
+ * @id: target id
+ * @channel: channel
+ * Context: This function will acquire ioc->scsi_lookup_lock.
+ *
+ * This will search for a matching channel:id in the scsi_lookup array,
+ * returning 1 if found.
+ */
+static u8
+_scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
+	int channel)
+{
+	int smid;
+	struct scsi_cmnd *scmd;
+
+	for (smid = 1;
+	     smid <= ioc->shost->can_queue; smid++) {
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
+		if (!scmd)
+			continue;
+		if (scmd->device->id == id &&
+		    scmd->device->channel == channel)
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * _scsih_scsi_lookup_find_by_lun - search for matching channel:id:lun
+ * @ioc: per adapter object
+ * @id: target id
+ * @lun: lun number
+ * @channel: channel
+ * Context: This function will acquire ioc->scsi_lookup_lock.
+ *
+ * This will search for a matching channel:id:lun in the scsi_lookup array,
+ * returning 1 if found.
+ */
+static u8
+_scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
+	unsigned int lun, int channel)
+{
+	int smid;
+	struct scsi_cmnd *scmd;
+
+	for (smid = 1; smid <= ioc->shost->can_queue; smid++) {
+
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
+		if (!scmd)
+			continue;
+		if (scmd->device->id == id &&
+		    scmd->device->channel == channel &&
+		    scmd->device->lun == lun)
+			return 1;
+	}
+	return 0;
+}
+
 /**
  * mpt3sas_scsih_scsi_lookup_get - returns scmd entry
  * @ioc: per adapter object
@@ -2704,6 +2764,8 @@ mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
  * mpt3sas_scsih_issue_tm - main routine for sending tm requests
  * @ioc: per adapter struct
  * @handle: device handle
+ * @channel: the channel assigned by the OS
+ * @id: the id assigned by the OS
  * @lun: lun number
  * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
  * @smid_task: smid assigned to the task
@@ -2720,8 +2782,9 @@ mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
  * Return: SUCCESS or FAILED.
  */
 int
-mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
-	u8 type, u16 smid_task, u16 msix_task, u8 timeout, u8 tr_method)
+mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
+	uint id, u64 lun, u8 type, u16 smid_task, u16 msix_task,
+	u8 timeout, u8 tr_method)
 {
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
@@ -2826,14 +2889,14 @@ out:
 }
 
 int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
-		u64 lun, u8 type, u16 smid_task, u16 msix_task,
-		u8 timeout, u8 tr_method)
+		uint channel, uint id, u64 lun, u8 type, u16 smid_task,
+		u16 msix_task, u8 timeout, u8 tr_method)
 {
 	int ret;
 
 	mutex_lock(&ioc->tm_cmds.mutex);
-	ret = mpt3sas_scsih_issue_tm(ioc, handle, lun, type, smid_task,
-			msix_task, timeout, tr_method);
+	ret = mpt3sas_scsih_issue_tm(ioc, handle, channel, id, lun, type,
+			smid_task, msix_task, timeout, tr_method);
 	mutex_unlock(&ioc->tm_cmds.mutex);
 
 	return ret;
@@ -2980,7 +3043,8 @@ scsih_abort(struct scsi_cmnd *scmd)
 	if (pcie_device && (!ioc->tm_custom_handling) &&
 	    (!(mpt3sas_scsih_is_pcie_scsi_device(pcie_device->device_info))))
 		timeout = ioc->nvme_abort_timeout;
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->lun,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
+		scmd->device->id, scmd->device->lun,
 		MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 		st->smid, st->msix_io, timeout, 0);
 	/* Command must be cleared after abort */
@@ -3056,7 +3120,8 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	} else
 		tr_method = MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET;
 
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->lun,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
+		scmd->device->id, scmd->device->lun,
 		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
 		tr_timeout, tr_method);
 	/* Check for busy commands after reset */
@@ -3134,7 +3199,8 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 		tr_method = MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE;
 	} else
 		tr_method = MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET;
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, 0,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
+		scmd->device->id, 0,
 		MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 0,
 	    tr_timeout, tr_method);
 	/* Check for busy commands after reset */
@@ -7530,7 +7596,7 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 			goto out;
 
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		r = mpt3sas_scsih_issue_tm(ioc, handle, lun,
+		r = mpt3sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
 			MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, st->smid,
 			st->msix_io, 30, 0);
 		if (r == FAILED) {
@@ -7571,9 +7637,9 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 		if (ioc->shost_recovery)
 			goto out_no_lock;
 
-		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->lun,
-			MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, st->smid,
-			st->msix_io, 30, 0);
+		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
+			sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
+			st->smid, st->msix_io, 30, 0);
 		if (r == FAILED || st->cb_idx != 0xFF) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
-- 
2.26.2

