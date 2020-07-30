Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98080C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D42420809
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IC6Clc4x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgG3IEj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgG3IEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:04:37 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D15C061794
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c6so3465541pje.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J2vxRaLJbYjx/WNOq6int4KscmiEZcRt7XXwFnk3Mks=;
        b=IC6Clc4xyccSKV+LpJY7v/+PK45i+uhp0VR4mj9u14VbY3MSecZsgVUt6yNmPp33Tr
         2IkLmd0dmFnriydNpPWc4QxMcr83o9sLMrdTWRvmth+/4JHTGtfATwCSBKPExwU9UAP7
         wTTFymb/ZcQLBH+VWMPT2uqaKRvATYvnfouYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J2vxRaLJbYjx/WNOq6int4KscmiEZcRt7XXwFnk3Mks=;
        b=fI0zaHYjUus2IGVcJErnnm9R/YNTBKTTlvSpjr6bigK9w/xB39eqTwFuhmG5fembS0
         LLiqNGI1En667BNfci/9RdjcFwHlii4KMcrzL2VQojlUK7vY6XGATjlk1Y/uYhwLXHVv
         KizTCsqyj6X/XbcQlombtU7TAWgIhCAbd2Se/NdCrWMJI6n7JZxnsDWxPkus5f046nFR
         IICqIs1nKowY2EpP8R/JruVjRQF2nrbzERAYZZEOlt1aHmpYhf9eQGBtpkKR+6ZlFCS9
         1oW7iDb8xY76cGgiD23n1szlXwoT2kEOXD9qEMf3SLQEtqSM41CbnpYRSRk4i2LvakL+
         p27g==
X-Gm-Message-State: AOAM530pHARx59xG86Rrkm1DIRdd6+E1yckPwwzBq5kS04XpyuTy3fIN
        m77uCvhGVrHkmYGbOFTAolrGFaCD6ErFEQ==
X-Google-Smtp-Source: ABdhPJwTjyxFCIspYNXfle/828JsRphDudS9wgDq0JsOn5iNww7XRD5XSV5jOUWeNmnxTkANo8FykQ==
X-Received: by 2002:a17:90a:fd82:: with SMTP id cx2mr5585011pjb.67.1596096276844;
        Thu, 30 Jul 2020 01:04:36 -0700 (PDT)
Received: from localhost.localdomain ([192.19.212.250])
        by smtp.gmail.com with ESMTPSA id d13sm5051412pfq.118.2020.07.30.01.04.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:04:36 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 6/7] mpt3sas: Postprocessing of target and LUN reset.
Date:   Thu, 30 Jul 2020 13:33:48 +0530
Message-Id: <1596096229-3341-7-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If driver has not received the interrupt for the aborted SCSI command
before processing the TM reply, Driver polls all the reply descriptor
pools looking for the reply for the aborted SCSI command before marking
TM as FAILED. If it finds the reply then mark the TM as SUCCESS
otherwise mark as FAILED.
scsih_tm_cmd_map_status() -> Checks whether TM has aborted
the timed out SCSI command or not, if TM has aborted the IO
then returns SUCCESS else returns FAILED.
scsih_tm_post_processing() -> Post proceesing of target &
LUN reset

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 136 ++++++++++++++++++++++++++-
 3 files changed, 139 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 2ffdbbb..3606676 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1784,12 +1784,14 @@ _base_is_controller_msix_enabled(struct MPT3SAS_ADAPTER *ioc)
 /**
  * mpt3sas_base_sync_reply_irqs - flush pending MSIX interrupts
  * @ioc: per adapter object
+ * @poll: poll over reply descriptor pools incase interrupt for
+ *		timed-out SCSI command got delayed
  * Context: non ISR conext
  *
  * Called when a Task Management request has completed.
  */
 void
-mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
+mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc, u8 poll)
 {
 	struct adapter_reply_queue *reply_q;
 
@@ -1819,6 +1821,8 @@ mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
 		}
 		synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
 	}
+	if (poll)
+		_base_process_reply_queue(reply_q);
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index fd61deb..feb8328 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1528,7 +1528,7 @@ __le32 mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
 void *mpt3sas_base_get_pcie_sgl(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 dma_addr_t mpt3sas_base_get_pcie_sgl_dma(struct MPT3SAS_ADAPTER *ioc, u16 smid);
-void mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc, u8 poll);
 void mpt3sas_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_base_unmask_interrupts(struct MPT3SAS_ADAPTER *ioc);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ce12253..67270e0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2760,6 +2760,96 @@ mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	}
 }
 
+/**
+ * scsih_tm_cmd_map_status - map the target reset & LUN reset TM status
+ * @ioc - per adapter object
+ * @channel - the channel assigned by the OS
+ * @id: the id assigned by the OS
+ * @lun: lun number
+ * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
+ * @smid_task: smid assigned to the task
+ *
+ * Look whether TM has aborted the timed out SCSI command, if
+ * TM has aborted the IO then return SUCCESS else return FAILED.
+ */
+int
+scsih_tm_cmd_map_status(struct MPT3SAS_ADAPTER *ioc, uint channel,
+	uint id, uint lun, u8 type, u16 smid_task)
+{
+
+	if (smid_task <= ioc->shost->can_queue) {
+		switch (type) {
+		case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
+			if (!(_scsih_scsi_lookup_find_by_target(ioc,
+			    id, channel)))
+				return SUCCESS;
+			break;
+		case MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET:
+		case MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
+			if (!(_scsih_scsi_lookup_find_by_lun(ioc, id,
+			    lun, channel)))
+				return SUCCESS;
+			break;
+		default:
+			return SUCCESS;
+		}
+	} else if (smid_task == ioc->scsih_cmds.smid) {
+		if ((ioc->scsih_cmds.status & MPT3_CMD_COMPLETE) ||
+		    (ioc->scsih_cmds.status & MPT3_CMD_NOT_USED))
+			return SUCCESS;
+	} else if (smid_task == ioc->ctl_cmds.smid) {
+		if ((ioc->ctl_cmds.status & MPT3_CMD_COMPLETE) ||
+		    (ioc->ctl_cmds.status & MPT3_CMD_NOT_USED))
+			return SUCCESS;
+	}
+
+	return FAILED;
+}
+
+/**
+ * scsih_tm_post_processing - post proceesing of target & LUN reset
+ * @ioc - per adapter object
+ * @handle: device handle
+ * @channel - the channel assigned by the OS
+ * @id: the id assigned by the OS
+ * @lun: lun number
+ * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
+ * @smid_task: smid assigned to the task
+ *
+ * Post processing of target & LUN reset. Due to interrupt latency
+ * issue it possible that interrupt for aborted IO might not
+ * received yet. So before returning failure status poll the
+ * reply descriptor pools for the reply of timed out SCSI command.
+ * Return FAILED status if reply for timed out is not received
+ * otherwise return SUCCESS.
+ */
+int
+scsih_tm_post_processing(struct MPT3SAS_ADAPTER *ioc, u16 handle,
+	uint channel, uint id, uint lun, u8 type, u16 smid_task)
+{
+	int rc;
+
+	rc = scsih_tm_cmd_map_status(ioc, channel, id, lun, type, smid_task);
+	if (rc == SUCCESS)
+		return rc;
+
+	ioc_info(ioc,
+	    "Poll ReplyDescriptor queues for completion of"
+	    " smid(%d), task_type(0x%02x), handle(0x%04x)\n",
+	    smid_task, type, handle);
+
+	/*
+	 * Due to interrupt latency issues, driver may receive interrupt for
+	 * TM first and then for aborted SCSI IO command. So, poll all the
+	 * ReplyDescriptor pools before returning the FAILED status to SML.
+	 */
+	mpt3sas_base_mask_interrupts(ioc);
+	mpt3sas_base_sync_reply_irqs(ioc, 1);
+	mpt3sas_base_unmask_interrupts(ioc);
+
+	return scsih_tm_cmd_map_status(ioc, channel, id, lun, type, smid_task);
+}
+
 /**
  * mpt3sas_scsih_issue_tm - main routine for sending tm requests
  * @ioc: per adapter struct
@@ -2788,6 +2878,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 {
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
+	Mpi25SCSIIORequest_t *request;
 	u16 smid = 0;
 	u32 ioc_state;
 	int rc;
@@ -2843,7 +2934,9 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = type;
-	mpi_request->MsgFlags = tr_method;
+	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK ||
+	    type == MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK)
+		mpi_request->MsgFlags = tr_method;
 	mpi_request->TaskMID = cpu_to_le16(smid_task);
 	int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
 	mpt3sas_scsih_set_tm_flag(ioc, handle);
@@ -2863,7 +2956,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	}
 
 	/* sync IRQs in case those were busy during flush. */
-	mpt3sas_base_sync_reply_irqs(ioc);
+	mpt3sas_base_sync_reply_irqs(ioc, 0);
 
 	if (ioc->tm_cmds.status & MPT3_CMD_REPLY_VALID) {
 		mpt3sas_trigger_master(ioc, MASTER_TRIGGER_TASK_MANAGMENT);
@@ -2880,7 +2973,44 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 				    sizeof(Mpi2SCSITaskManagementRequest_t)/4);
 		}
 	}
-	rc = SUCCESS;
+
+	switch (type) {
+	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
+		rc = SUCCESS;
+		/*
+		 * If DevHandle filed in smid_task's entry of request pool
+		 * doesn't matches with device handle on which this task abort
+		 * TM is received then it means that TM has successfully
+		 * aborted the timed out command. Since smid_task's entry in
+		 * request pool will be memset to zero once the timed out
+		 * command is returned to the SML. If the command is not
+		 * aborted then smid_task’s entry won’t be cleared and it
+		 * will have same DevHandle value on which this task abort TM
+		 * is received and driver will return the TM status as FAILED.
+		 */
+		request = mpt3sas_base_get_msg_frame(ioc, smid_task);
+		if (le16_to_cpu(request->DevHandle) != handle)
+			break;
+
+		ioc_info(ioc, "Task abort tm failed: handle(0x%04x),"
+		    "timeout(%d) tr_method(0x%x) smid(%d) msix_index(%d)\n",
+		    handle, timeout, tr_method, smid_task, msix_task);
+		rc = FAILED;
+		break;
+
+	case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
+	case MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET:
+	case MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
+		rc = scsih_tm_post_processing(ioc, handle, channel, id, lun,
+		    type, smid_task);
+		break;
+	case MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK:
+		rc = SUCCESS;
+		break;
+	default:
+		rc = FAILED;
+		break;
+	}
 
 out:
 	mpt3sas_scsih_clear_tm_flag(ioc, handle);
-- 
2.26.2

