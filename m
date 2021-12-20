Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6709CC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhLTOEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbhLTOEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:34 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49628C06173F
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:34 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u16so2144668plg.9
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=/Ehe4CtStKPCk4LWVzohCS/v0L1flEJtGc8DNB1wx/s=;
        b=Bbk+I/+BLeo4dT/ZjXEGiKgUMvLwqL58v5AS5Z01vLHmWiZ6JTcW4kYBmwllbnsoV1
         Hb0ECmBpS7dbptlW20Is5Vp1YfwI8Y133ylxPK3S57QQI3IGezRDfp/OZQURx97Cv5bO
         hh1wipOu7BGW2p8LjH0yI4Y4e2yXv7Y1R1zqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=/Ehe4CtStKPCk4LWVzohCS/v0L1flEJtGc8DNB1wx/s=;
        b=qKBC5OrFKubvvrMWixZYtslIa9SaAnEGQxdLXwIOCd8zZraz3UO3CGelq1hG1H7ja2
         E3XWG0ZwSriEu+zMdAMwhMAY4wtKaprQiDJ2zDln35HJKJtFeNTuYQVc33oRNEUM74LL
         uPLOLKKNm1juh15mFt7OjuPaG+5kEyMaZM+aUYTlCFpS6pZfVw6R9pb/DNPIUGc33R1i
         qTmCHqsb+QWTTSqaf9wkEdyqVAZSFgnPaC5eLqB/62RBehvpbZLdNU1Vb6jNFhm6F7qo
         NKwIpmJjuELYW69XfZsWVYcSfBLjpkbN/sPeyfPAkm7wj75pL4gsOub2jxQ2YQdVCuYF
         aizw==
X-Gm-Message-State: AOAM531HCwPfRIwzOMb3O5OV1EBm2Yqhj3tI6xtVpN1tITPimvyDZA+Q
        yrGs9fHFv86gAe8THeosRzwUd/bFh7na2T9v0IXkOXgYOyIDmGIVOAWnOUCQnL+7Xi9FnKRdOoi
        AxZRZYf176n+6+AonAqZQhT+OPhrI5QlvLFhCqxRgv1FK/N4YDJJQyFTIATQmn1qLJ9nwPBm1SX
        8iGDCKs/k3
X-Google-Smtp-Source: ABdhPJyWPb1RQgs0ZzDcZFIbYTUOe5ZbE3C0ofn78ocQpn3WCgO4l7PMtsEWhv3RMz4LYC9kbcWoWw==
X-Received: by 2002:a17:90b:2252:: with SMTP id hk18mr20240354pjb.218.1640009072946;
        Mon, 20 Dec 2021 06:04:32 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:32 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 14/25] mpi3mr: Handle offline FW activation in graceful manner
Date:   Mon, 20 Dec 2021 19:41:48 +0530
Message-Id: <20211220141159.16117-15-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000435a5205d3945e3b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000435a5205d3945e3b
Content-Transfer-Encoding: 8bit

Currently driver mark the controller as unrecoverable if there
is an asynchronous reset or fault during the initialization,
reinitialization post reset, and OS resume.
Driver is enhanced to retry the initialization, re-initialization,
and resume sequences for a maximum of 3 times if the controller
became faulty or asynchronously reset due to a firmware activation
during the initialization sequence.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  22 ++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 180 ++++++++++++++------------------
 drivers/scsi/mpi3mr/mpi3mr_os.c |  46 +++++---
 3 files changed, 120 insertions(+), 128 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 55a07f9..ea5f27f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -185,20 +185,6 @@ enum mpi3mr_iocstate {
 	MRIOC_STATE_UNRECOVERABLE,
 };
 
-/* Init type definitions */
-enum mpi3mr_init_type {
-	MPI3MR_IT_INIT = 0,
-	MPI3MR_IT_RESET,
-	MPI3MR_IT_RESUME,
-};
-
-/* Cleanup reason definitions */
-enum mpi3mr_cleanup_reason {
-	MPI3MR_COMPLETE_CLEANUP = 0,
-	MPI3MR_REINIT_FAILURE,
-	MPI3MR_SUSPEND,
-};
-
 /* Reset reason code definitions*/
 enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_BRINGUP = 1,
@@ -634,6 +620,7 @@ struct scmd_priv {
  * @ready_timeout: Controller ready timeout
  * @intr_info: Interrupt cookie pointer
  * @intr_info_count: Number of interrupt cookies
+ * @is_intr_info_set: Flag to indicate intr info is setup
  * @num_queues: Number of operational queues
  * @num_op_req_q: Number of operational request queues
  * @req_qinfo: Operational request queue info pointer
@@ -743,6 +730,7 @@ struct mpi3mr_ioc {
 
 	struct mpi3mr_intr_info *intr_info;
 	u16 intr_info_count;
+	bool is_intr_info_set;
 
 	u16 num_queues;
 	u16 num_op_req_q;
@@ -873,8 +861,9 @@ struct delayed_dev_rmhs_node {
 
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
 void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
-int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type);
-void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 reason);
+int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
+int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume);
+void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc);
 int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async);
 int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
 u16 admin_req_sz, u8 ignore_reset);
@@ -891,6 +880,7 @@ void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
 				     u64 sense_buf_dma);
 
 void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc);
+void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc);
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 			     struct mpi3_event_notification_reply *event_reply);
 void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 163e8b9..bad708a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -82,6 +82,7 @@ static void mpi3mr_cleanup_isr(struct mpi3mr_ioc *mrioc)
 	kfree(mrioc->intr_info);
 	mrioc->intr_info = NULL;
 	mrioc->intr_info_count = 0;
+	mrioc->is_intr_info_set = false;
 	pci_free_irq_vectors(mrioc->pdev);
 }
 
@@ -675,6 +676,9 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 	int i;
 	struct irq_affinity desc = { .pre_vectors =  1};
 
+	if (mrioc->is_intr_info_set)
+		return 0;
+
 	mpi3mr_cleanup_isr(mrioc);
 
 	if (setup_one || reset_devices)
@@ -726,6 +730,8 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 			goto out_failed;
 		}
 	}
+	if (reset_devices || !setup_one)
+		mrioc->is_intr_info_set = true;
 	mrioc->intr_info_count = max_vectors;
 	mpi3mr_ioc_enable_intr(mrioc);
 	return 0;
@@ -1712,7 +1718,8 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 		goto out_unlock;
 	}
 	op_reply_q->qid = reply_qid;
-	mrioc->intr_info[midx].op_reply_q = op_reply_q;
+	if (midx < mrioc->intr_info_count)
+		mrioc->intr_info[midx].op_reply_q = op_reply_q;
 
 out_unlock:
 	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
@@ -3074,6 +3081,9 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 	u32 sz, i;
 	u16 num_chains;
 
+	if (mrioc->chain_sgl_list)
+		return retval;
+
 	num_chains = mrioc->max_host_ios / MPI3MR_CHAINBUF_FACTOR;
 
 	if (prot_mask & (SHOST_DIX_TYPE0_PROTECTION
@@ -3452,39 +3462,26 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
  *
  * Return: 0 on success and non-zero on failure.
  */
-int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
+int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
+	u8 retry = 0;
 	struct mpi3_ioc_facts_data facts_data;
 
-	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
-	mrioc->change_count = 0;
-	if (init_type == MPI3MR_IT_INIT) {
-		mrioc->cpu_count = num_online_cpus();
-		retval = mpi3mr_setup_resources(mrioc);
-		if (retval) {
-			ioc_err(mrioc, "Failed to setup resources:error %d\n",
-			    retval);
-			goto out_nocleanup;
-		}
-	}
-
+retry_init:
 	retval = mpi3mr_bring_ioc_ready(mrioc);
 	if (retval) {
 		ioc_err(mrioc, "Failed to bring ioc ready: error %d\n",
 		    retval);
-		goto out_failed;
+		goto out_failed_noretry;
 	}
 
-	if (init_type != MPI3MR_IT_RESET) {
-		retval = mpi3mr_setup_isr(mrioc, 1);
-		if (retval) {
-			ioc_err(mrioc, "Failed to setup ISR error %d\n",
-			    retval);
-			goto out_failed;
-		}
-	} else
-		mpi3mr_ioc_enable_intr(mrioc);
+	retval = mpi3mr_setup_isr(mrioc, 1);
+	if (retval) {
+		ioc_err(mrioc, "Failed to setup ISR error %d\n",
+		    retval);
+		goto out_failed_noretry;
+	}
 
 	retval = mpi3mr_issue_iocfacts(mrioc, &facts_data);
 	if (retval) {
@@ -3494,13 +3491,12 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 	}
 
 	mpi3mr_process_factsdata(mrioc, &facts_data);
-	if (init_type == MPI3MR_IT_INIT) {
-		retval = mpi3mr_check_reset_dma_mask(mrioc);
-		if (retval) {
-			ioc_err(mrioc, "Resetting dma mask failed %d\n",
-			    retval);
-			goto out_failed;
-		}
+
+	retval = mpi3mr_check_reset_dma_mask(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "Resetting dma mask failed %d\n",
+		    retval);
+		goto out_failed_noretry;
 	}
 
 	mpi3mr_print_ioc_info(mrioc);
@@ -3510,16 +3506,14 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		ioc_err(mrioc,
 		    "%s :Failed to allocated reply sense buffers %d\n",
 		    __func__, retval);
-		goto out_failed;
+		goto out_failed_noretry;
 	}
 
-	if (init_type == MPI3MR_IT_INIT) {
-		retval = mpi3mr_alloc_chain_bufs(mrioc);
-		if (retval) {
-			ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
-			    retval);
-			goto out_failed;
-		}
+	retval = mpi3mr_alloc_chain_bufs(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
+		    retval);
+		goto out_failed_noretry;
 	}
 
 	retval = mpi3mr_issue_iocinit(mrioc);
@@ -3535,13 +3529,11 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		goto out_failed;
 	}
 
-	if (init_type != MPI3MR_IT_RESET) {
-		retval = mpi3mr_setup_isr(mrioc, 0);
-		if (retval) {
-			ioc_err(mrioc, "Failed to re-setup ISR, error %d\n",
-			    retval);
-			goto out_failed;
-		}
+	retval = mpi3mr_setup_isr(mrioc, 0);
+	if (retval) {
+		ioc_err(mrioc, "Failed to re-setup ISR, error %d\n",
+		    retval);
+		goto out_failed_noretry;
 	}
 
 	retval = mpi3mr_create_op_queues(mrioc);
@@ -3551,15 +3543,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		goto out_failed;
 	}
 
-	if ((init_type != MPI3MR_IT_INIT) &&
-	    (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q)) {
-		retval = -1;
-		ioc_err(mrioc,
-		    "Cannot create minimum number of OpQueues expected:%d created:%d\n",
-		    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
-		goto out_failed;
-	}
-
 	retval = mpi3mr_enable_events(mrioc);
 	if (retval) {
 		ioc_err(mrioc, "failed to enable events %d\n",
@@ -3567,26 +3550,30 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		goto out_failed;
 	}
 
-	if (init_type != MPI3MR_IT_INIT) {
-		ioc_info(mrioc, "Issuing Port Enable\n");
-		retval = mpi3mr_issue_port_enable(mrioc, 0);
-		if (retval) {
-			ioc_err(mrioc, "Failed to issue port enable %d\n",
-			    retval);
-			goto out_failed;
-		}
-	}
+	ioc_info(mrioc, "controller initialization completed successfully\n");
 	return retval;
-
 out_failed:
-	if (init_type == MPI3MR_IT_INIT)
-		mpi3mr_cleanup_ioc(mrioc, MPI3MR_COMPLETE_CLEANUP);
-	else
-		mpi3mr_cleanup_ioc(mrioc, MPI3MR_REINIT_FAILURE);
-out_nocleanup:
+	if (retry < 2) {
+		retry++;
+		ioc_warn(mrioc, "retrying controller initialization, retry_count:%d\n",
+		    retry);
+		mpi3mr_memset_buffers(mrioc);
+		goto retry_init;
+	}
+out_failed_noretry:
+	ioc_err(mrioc, "controller initialization failed\n");
+	mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+	    MPI3MR_RESET_FROM_CTLR_CLEANUP);
+	mrioc->unrecoverable = 1;
 	return retval;
 }
 
+int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
+{
+
+	return 0;
+}
+
 /**
  * mpi3mr_memset_op_reply_q_buffers - memset the operational reply queue's
  *					segments
@@ -3647,17 +3634,22 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 {
 	u16 i;
 
-	memset(mrioc->admin_req_base, 0, mrioc->admin_req_q_sz);
-	memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
-
-	memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
-	memset(mrioc->host_tm_cmds.reply, 0,
-	    sizeof(*mrioc->host_tm_cmds.reply));
-	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
-		memset(mrioc->dev_rmhs_cmds[i].reply, 0,
-		    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
-	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
-	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
+	mrioc->change_count = 0;
+	if (mrioc->admin_req_base)
+		memset(mrioc->admin_req_base, 0, mrioc->admin_req_q_sz);
+	if (mrioc->admin_reply_base)
+		memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
+
+	if (mrioc->init_cmds.reply) {
+		memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
+		memset(mrioc->host_tm_cmds.reply, 0,
+		    sizeof(*mrioc->host_tm_cmds.reply));
+		for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
+			memset(mrioc->dev_rmhs_cmds[i].reply, 0,
+			    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
+		memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
+		memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
+	}
 
 	for (i = 0; i < mrioc->num_queues; i++) {
 		mrioc->op_reply_qinfo[i].qid = 0;
@@ -3686,7 +3678,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
  *
  * Return: Nothing.
  */
-static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
+void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 {
 	u16 i;
 	struct mpi3mr_intr_info *intr_info;
@@ -3858,21 +3850,17 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 /**
  * mpi3mr_cleanup_ioc - Cleanup controller
  * @mrioc: Adapter instance reference
- * @reason: Cleanup reason
- *
+
  * controller cleanup handler, Message unit reset or soft reset
- * and shutdown notification is issued to the controller and the
- * associated memory resources are freed.
+ * and shutdown notification is issued to the controller.
  *
  * Return: Nothing.
  */
-void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 reason)
+void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
 {
 	enum mpi3mr_iocstate ioc_state;
 
-	if (reason == MPI3MR_COMPLETE_CLEANUP)
-		mpi3mr_stop_watchdog(mrioc);
-
+	dprint_exit(mrioc, "cleaning up the controller\n");
 	mpi3mr_ioc_disable_intr(mrioc);
 
 	ioc_state = mpi3mr_get_iocstate(mrioc);
@@ -3884,15 +3872,9 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 reason)
 			mpi3mr_issue_reset(mrioc,
 			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
 			    MPI3MR_RESET_FROM_MUR_FAILURE);
-
-		if (reason != MPI3MR_REINIT_FAILURE)
-			mpi3mr_issue_ioc_shutdown(mrioc);
-	}
-
-	if (reason == MPI3MR_COMPLETE_CLEANUP) {
-		mpi3mr_free_mem(mrioc);
-		mpi3mr_cleanup_resources(mrioc);
+		mpi3mr_issue_ioc_shutdown(mrioc);
 	}
+	dprint_exit(mrioc, "controller cleanup completed\n");
 }
 
 /**
@@ -4071,7 +4053,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mpi3mr_flush_host_io(mrioc);
 	mpi3mr_invalidate_devhandles(mrioc);
 	mpi3mr_memset_buffers(mrioc);
-	retval = mpi3mr_init_ioc(mrioc, MPI3MR_IT_RESET);
+	retval = mpi3mr_reinit_ioc(mrioc, 0);
 	if (retval) {
 		pr_err(IOCNAME "reinit after soft reset failed: reason %d\n",
 		    mrioc->name, reset_reason);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2a153df..e17b2c1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3821,21 +3821,26 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
 		retval = -ENODEV;
-		goto out_fwevtthread_failed;
+		goto fwevtthread_failed;
 	}
 
 	mrioc->is_driver_loading = 1;
-	if (mpi3mr_init_ioc(mrioc, MPI3MR_IT_INIT)) {
-		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
-		    __FILE__, __LINE__, __func__);
+	mrioc->cpu_count = num_online_cpus();
+	if (mpi3mr_setup_resources(mrioc)) {
+		ioc_err(mrioc, "setup resources failed\n");
+		retval = -ENODEV;
+		goto resource_alloc_failed;
+	}
+	if (mpi3mr_init_ioc(mrioc)) {
+		ioc_err(mrioc, "initializing IOC failed\n");
 		retval = -ENODEV;
-		goto out_iocinit_failed;
+		goto init_ioc_failed;
 	}
 
 	shost->nr_hw_queues = mrioc->num_op_reply_q;
 	shost->can_queue = mrioc->max_host_ios;
 	shost->sg_tablesize = MPI3MR_SG_DEPTH;
-	shost->max_id = mrioc->facts.max_perids;
+	shost->max_id = mrioc->facts.max_perids + 1;
 
 	retval = scsi_add_host(shost, &pdev->dev);
 	if (retval) {
@@ -3848,10 +3853,14 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return retval;
 
 addhost_failed:
-	mpi3mr_cleanup_ioc(mrioc, MPI3MR_COMPLETE_CLEANUP);
-out_iocinit_failed:
+	mpi3mr_stop_watchdog(mrioc);
+	mpi3mr_cleanup_ioc(mrioc);
+init_ioc_failed:
+	mpi3mr_free_mem(mrioc);
+	mpi3mr_cleanup_resources(mrioc);
+resource_alloc_failed:
 	destroy_workqueue(mrioc->fwevt_worker_thread);
-out_fwevtthread_failed:
+fwevtthread_failed:
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
@@ -3864,6 +3873,7 @@ shost_failed:
  * mpi3mr_remove - PCI remove callback
  * @pdev: PCI device instance
  *
+ * Cleanup the IOC by issuing MUR and shutdown notification.
  * Free up all memory and resources associated with the
  * controllerand target devices, unregister the shost.
  *
@@ -3900,7 +3910,10 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
-	mpi3mr_cleanup_ioc(mrioc, MPI3MR_COMPLETE_CLEANUP);
+	mpi3mr_stop_watchdog(mrioc);
+	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_free_mem(mrioc);
+	mpi3mr_cleanup_resources(mrioc);
 
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
@@ -3940,7 +3953,10 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 	if (wq)
 		destroy_workqueue(wq);
-	mpi3mr_cleanup_ioc(mrioc, MPI3MR_COMPLETE_CLEANUP);
+
+	mpi3mr_stop_watchdog(mrioc);
+	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_cleanup_resources(mrioc);
 }
 
 #ifdef CONFIG_PM
@@ -3970,7 +3986,7 @@ static int mpi3mr_suspend(struct pci_dev *pdev, pm_message_t state)
 	mpi3mr_cleanup_fwevt_list(mrioc);
 	scsi_block_requests(shost);
 	mpi3mr_stop_watchdog(mrioc);
-	mpi3mr_cleanup_ioc(mrioc, MPI3MR_SUSPEND);
+	mpi3mr_cleanup_ioc(mrioc);
 
 	device_state = pci_choose_state(pdev, state);
 	ioc_info(mrioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
@@ -4019,7 +4035,11 @@ static int mpi3mr_resume(struct pci_dev *pdev)
 
 	mrioc->stop_drv_processing = 0;
 	mpi3mr_memset_buffers(mrioc);
-	mpi3mr_init_ioc(mrioc, MPI3MR_IT_RESUME);
+	r = mpi3mr_reinit_ioc(mrioc, 1);
+	if (r) {
+		ioc_err(mrioc, "resuming controller failed[%d]\n", r);
+		return r;
+	}
 	scsi_unblock_requests(shost);
 	mpi3mr_start_watchdog(mrioc);
 
-- 
2.27.0


--000000000000435a5205d3945e3b
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIpV9ijc/MxXDn3m4mwy
tA5+/AvqYKzNZjVwbLChApDiMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQzM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB0rIV3CQ3LqblknxNdchtRY4rSk66TmLMSeRfS
RPVqJA2TLp+s44ERnmQSmd/D2G0W/S93R/e0r9UDIKwppIyIklV4pFUQ1gWtwkvgade9bWiEL5nO
sOu5LxZsGeOm8KrZJKKo+Hk+R/hZRgGIcD12k33HT8DvtF4NJXWZSvrLuo3lbxNbJyPARIyAS0St
I6ioZn/PSU2bSd58gqcpdPAy2SR3Kp572u62DXSsl17SCq+yuOreBU4qh3kOnTgMaG3fcWjIOFX/
XrkQXMIHaqQJcsTaK6dktZbR786zfjjLMVmi6r8rNyfBo7PZjZQtqyJ142vU6KUpV1h5G1oEC+2W
--000000000000435a5205d3945e3b--
