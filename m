Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BBEC43381
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536352310D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgLVKNo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgLVKNn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:43 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F2EC0613D3
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:47 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id w6so8219777pfu.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hJgn4yLRR2+gaFv7NUzHAwhlT4VJfQNcymbjn0TMDnk=;
        b=hGZX4apsk4zWAigdU2PQ+yrFXCEEGCX4GK7nWs0Oem4yB/QSIRPomRI2xWq9qZ5O59
         OUeFzO9CxJruYvc/G9tACyWNTdbnFOdd8pyLhjAQDowgrluDNzgB3kPymoe0iRYdvbw1
         Bu+nR04E9+iJb6vYtQ/r2B//OND8h0WKUVpaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=hJgn4yLRR2+gaFv7NUzHAwhlT4VJfQNcymbjn0TMDnk=;
        b=KzwXXR+RsDSjV8IvpJ58BH85etqpa/EqB/BGthJnOiFVTnzTr9pix+uNqzvWO4EvWx
         PdEBFrTtv6EUnxZaPLbWq692iNbncs7yBr753yDLCZTaZuQaq+qXrEguiAXfgYQHxdMI
         AV0cCtTyZ36CrjBOgv5415obnsY1otfpnaw16qpcpkIGTVxBSfdoTnoCziWAwq2LEQ8j
         C5kmMd3+eiJ6Dht4euZX/0TaPjodkSoIjUmLwZkoClzUkHdjQtCuzgEp8ZrLArRNnpja
         2CmwR6WsD1C+LsXhyxXULVXQNy1stScXeimmZCoZ75S5J40jz+3736AqXGx52xCuqWsV
         gCyA==
X-Gm-Message-State: AOAM530553ltJYKtYwvlYzqwH+0FHENosC5RDsZyGnegBgUU/ojb3F82
        k4X29WL5PPWVJ9iSy1FyOZSPPa9BV75zyXn7DyGHeHC5CMjIeOv8kzBZOfrvnqeodIEtv9KJfKJ
        RZHT0grut6Ajo2PiYCoqCSibWQnvi2m0nB9l7vgqH10BUTA1GTjo+AI2alrSanqMyD6MjT2NBvj
        w/eI19iKDc
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJw+QciQS1FgUZ1kqATD703+Gdt8pt+IfzGBc2v0oLCKDKm+Qf+qWrpg1NbBOChA+CQdyoOrog==
X-Received: by 2002:a63:ed54:: with SMTP id m20mr18482433pgk.401.1608631966397;
        Tue, 22 Dec 2020 02:12:46 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:12:45 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 09/24] mpi3mr: add support for recovering controller
Date:   Tue, 22 Dec 2020 15:41:41 +0530
Message-Id: <20201222101156.98308-10-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f843c205b70ad051"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f843c205b70ad051
Content-Type: text/plain; charset="US-ASCII"

Added h/w defined process of doing controller reset.
The driver on detection of firmware fault or any kind of unresponsiveness in
the controller (Any admin command time outs) results in resetting the controller.
The primary reset mechanisms used are either soft reset or diag fault reset.
Reset is performed if the host sets the ResetAction field in the HostDiagnostic
register to a 001b (Soft Reset) or 007b(diag fault reset).
The driver after successfully resetting the controller reinitialize the
controller by going through start of the day controller initialization procedures.
The pending I/Os during the reset are returned back to SML for retry.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  22 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 416 +++++++++++++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_os.c |  93 ++++++-
 3 files changed, 488 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 1f70a67d7868..f60749c94c9a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -98,6 +98,7 @@ extern struct list_head mrioc_list;
 #define MPI3MR_INTADMCMD_TIMEOUT		10
 #define MPI3MR_PORTENABLE_TIMEOUT		300
 #define MPI3MR_RESETTM_TIMEOUT			30
+#define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
 #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
@@ -632,10 +633,14 @@ struct scmd_priv {
  * @dev_handle_bitmap_sz: Device handle bitmap size
  * @removepend_bitmap: Remove pending bitmap
  * @delayed_rmhs_list: Delayed device removal list
+ * @fault_dbg: Fault debug flag
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
+ * @reset_mutex: Controller reset mutex
+ * @reset_waitq: Controller reset  wait queue
  * @diagsave_timeout: Diagnostic information save timeout
  * @logging_level: Controller debug logging level
+ * @flush_io_count: I/O count to flush after reset
  * @current_event: Firmware event currently in process
  * @driver_info: Driver, Kernel, OS information to firmware
  * @change_count: Topology change count
@@ -750,11 +755,15 @@ struct mpi3mr_ioc {
 	void *removepend_bitmap;
 	struct list_head delayed_rmhs_list;
 
+	u8 fault_dbg;
 	u8 reset_in_progress;
 	u8 unrecoverable;
+	struct mutex reset_mutex;
+	wait_queue_head_t reset_waitq;
 
 	u16 diagsave_timeout;
 	int logging_level;
+	u16 flush_io_count;
 
 	struct mpi3mr_fwevt *current_event;
 	Mpi3DriverInfoLayout_t driver_info;
@@ -803,8 +812,8 @@ struct delayed_dev_rmhs_node {
 
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
 void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
-int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
-void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc);
+int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init);
+void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 re_init);
 int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async);
 int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
 u16 admin_req_sz, u8 ignore_reset);
@@ -830,6 +839,8 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
 
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 			      u32 reset_reason, u8 snapdump);
+int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
+				   u32 reset_reason);
 void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
 void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
 
@@ -837,4 +848,11 @@ enum mpi3mr_iocstate mpi3mr_get_iocstate(struct mpi3mr_ioc *mrioc);
 int mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 			  u32 event_ctx);
 
+void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout);
+void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc);
+void mpi3mr_flush_host_io(struct mpi3mr_ioc *mrioc);
+void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc);
+void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc);
+void mpi3mr_flush_delayed_rmhs_list(struct mpi3mr_ioc *mrioc);
+
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index de2de39c719e..6129065c34b7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1604,6 +1604,40 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc)
 	}
 }
 
+/**
+ * mpi3mr_kill_ioc - Kill the controller
+ * @mrioc: Adapter instance reference
+ * @reason: reason for the failure.
+ *
+ * If fault debug is enabled, display the fault info else issue
+ * diag fault and freeze the system for controller debug
+ * purpose.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_kill_ioc(struct mpi3mr_ioc *mrioc, u32 reason)
+{
+	enum mpi3mr_iocstate ioc_state;
+
+	if (!mrioc->fault_dbg)
+		return;
+
+	dump_stack();
+
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if (ioc_state == MRIOC_STATE_FAULT)
+		mpi3mr_print_fault_info(mrioc);
+	else {
+		ioc_err(mrioc, "Firmware is halted due to the reason %d\n",
+		    reason);
+		mpi3mr_diagfault_reset_handler(mrioc, reason);
+	}
+	if (mrioc->fault_dbg == 2)
+		for (;;)
+			;
+	else
+		panic("panic in %s\n", __func__);
+}
 
 /**
  * mpi3mr_setup_admin_qpair - Setup admin queue pair
@@ -2347,6 +2381,7 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 	return retval;
 }
 
+
 /**
  * mpi3mr_port_enable_complete - Mark port enable complete
  * @mrioc: Adapter instance reference
@@ -2557,6 +2592,7 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)
 /**
  * mpi3mr_init_ioc - Initialize the controller
  * @mrioc: Adapter instance reference
+ * @re_init: Flag to indicate is this fresh init or re-init
  *
  * This the controller initialization routine, executed either
  * after soft reset or from pci probe callback.
@@ -2569,7 +2605,7 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)
  *
  * Return: 0 on success and non-zero on failure.
  */
-int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
+int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 {
 	int retval = 0;
 	enum mpi3mr_iocstate ioc_state;
@@ -2579,12 +2615,14 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	Mpi3IOCFactsData_t facts_data;
 
 	mrioc->change_count = 0;
-	mrioc->cpu_count = num_online_cpus();
-	retval = mpi3mr_setup_resources(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to setup resources:error %d\n",
-		    retval);
-		goto out_nocleanup;
+	if (!re_init) {
+		mrioc->cpu_count = num_online_cpus();
+		retval = mpi3mr_setup_resources(mrioc);
+		if (retval) {
+			ioc_err(mrioc, "Failed to setup resources:error %d\n",
+			    retval);
+			goto out_nocleanup;
+		}
 	}
 	ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
 	ioc_config = readl(&mrioc->sysif_regs->IOCConfiguration);
@@ -2660,12 +2698,15 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
-	retval = mpi3mr_setup_isr(mrioc, 1);
-	if (retval) {
-		ioc_err(mrioc, "Failed to setup ISR error %d\n",
-		    retval);
-		goto out_failed;
-	}
+	if (!re_init) {
+		retval = mpi3mr_setup_isr(mrioc, 1);
+		if (retval) {
+			ioc_err(mrioc, "Failed to setup ISR error %d\n",
+			    retval);
+			goto out_failed;
+		}
+	} else
+		mpi3mr_ioc_enable_intr(mrioc);
 
 	retval = mpi3mr_issue_iocfacts(mrioc, &facts_data);
 	if (retval) {
@@ -2675,11 +2716,14 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	}
 
 	mpi3mr_process_factsdata(mrioc, &facts_data);
-	retval = mpi3mr_check_reset_dma_mask(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Resetting dma mask failed %d\n",
-		    retval);
-		goto out_failed;
+	if (!re_init) {
+		retval = mpi3mr_check_reset_dma_mask(mrioc);
+		if (retval) {
+			ioc_err(mrioc, "Resetting dma mask failed %d\n",
+			    retval);
+			goto out_failed;
+		}
+
 	}
 
 	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
@@ -2690,13 +2734,15 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
-	retval = mpi3mr_alloc_chain_bufs(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
-		    retval);
-		goto out_failed;
-	}
+	if (!re_init) {
+		retval = mpi3mr_alloc_chain_bufs(mrioc);
+		if (retval) {
+			ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
+			    retval);
+			goto out_failed;
+		}
 
+	}
 	retval = mpi3mr_issue_iocinit(mrioc);
 	if (retval) {
 		ioc_err(mrioc, "Failed to Issue IOC Init %d\n",
@@ -2711,11 +2757,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	writel(mrioc->sbq_host_index,
 	    &mrioc->sysif_regs->SenseBufferFreeHostIndex);
 
-	retval = mpi3mr_setup_isr(mrioc, 0);
-	if (retval) {
-		ioc_err(mrioc, "Failed to re-setup ISR, error %d\n",
-		    retval);
-		goto out_failed;
+	if (!re_init)  {
+		retval = mpi3mr_setup_isr(mrioc, 0);
+		if (retval) {
+			ioc_err(mrioc, "Failed to re-setup ISR, error %d\n",
+			    retval);
+			goto out_failed;
+		}
 	}
 
 	retval = mpi3mr_create_op_queues(mrioc);
@@ -2725,6 +2773,14 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	if (re_init &&
+	    (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q)) {
+		ioc_err(mrioc,
+		    "Cannot create minimum number of OpQueues expected:%d created:%d\n",
+		    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
+		goto out_failed;
+	}
+
 	for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 		mrioc->event_masks[i] = -1;
 
@@ -2748,14 +2804,109 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	if (re_init) {
+		ioc_info(mrioc, "Issuing Port Enable\n");
+		retval = mpi3mr_issue_port_enable(mrioc, 0);
+		if (retval) {
+			ioc_err(mrioc, "Failed to issue port enable %d\n",
+			    retval);
+			goto out_failed;
+		}
+	}
 	return retval;
 
 out_failed:
-	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_cleanup_ioc(mrioc, re_init);
 out_nocleanup:
 	return retval;
 }
 
+/**
+ * mpi3mr_memset_op_reply_q_buffers - memset the operational reply queue's
+ *					segments
+ * @mrioc: Adapter instance reference
+ * @qidx: Operational reply queue index
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_memset_op_reply_q_buffers(struct mpi3mr_ioc *mrioc, u16 qidx)
+{
+	struct op_reply_qinfo *op_reply_q = mrioc->op_reply_qinfo + qidx;
+	struct segments *segments;
+	int i, size;
+
+	if (!op_reply_q->q_segments)
+		return;
+
+	size = op_reply_q->segment_qd * mrioc->op_reply_desc_sz;
+	segments = op_reply_q->q_segments;
+	for (i = 0; i < op_reply_q->num_segments; i++)
+		memset(segments[i].segment, 0, size);
+}
+
+/**
+ * mpi3mr_memset_op_req_q_buffers - memset the operational request queue's
+ *					segments
+ * @mrioc: Adapter instance reference
+ * @qidx: Operational request queue index
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_memset_op_req_q_buffers(struct mpi3mr_ioc *mrioc, u16 qidx)
+{
+	struct op_req_qinfo *op_req_q = mrioc->req_qinfo + qidx;
+	struct segments *segments;
+	int i, size;
+
+	if (!op_req_q->q_segments)
+		return;
+
+	size = op_req_q->segment_qd * mrioc->facts.op_req_sz;
+	segments = op_req_q->q_segments;
+	for (i = 0; i < op_req_q->num_segments; i++)
+		memset(segments[i].segment, 0, size);
+}
+
+/**
+ * mpi3mr_memset_buffers - memset memory for a controller
+ * @mrioc: Adapter instance reference
+ *
+ * clear all the memory allocated for a controller, typically
+ * called post reset to reuse the memory allocated during the
+ * controller init.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
+{
+	u16 i;
+
+	memset(mrioc->admin_req_base, 0, mrioc->admin_req_q_sz);
+	memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
+
+	memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
+	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
+		memset(mrioc->dev_rmhs_cmds[i].reply, 0,
+		    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
+	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
+	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
+
+	for (i = 0; i < mrioc->num_queues; i++) {
+		mrioc->op_reply_qinfo[i].qid = 0;
+		mrioc->op_reply_qinfo[i].ci = 0;
+		mrioc->op_reply_qinfo[i].num_replies = 0;
+		mrioc->op_reply_qinfo[i].ephase = 0;
+		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
+
+		mrioc->req_qinfo[i].ci = 0;
+		mrioc->req_qinfo[i].pi = 0;
+		mrioc->req_qinfo[i].num_requests = 0;
+		mrioc->req_qinfo[i].qid = 0;
+		mrioc->req_qinfo[i].reply_qid = 0;
+		spin_lock_init(&mrioc->req_qinfo[i].q_lock);
+		mpi3mr_memset_op_req_q_buffers(mrioc, i);
+	}
+}
 
 /**
  * mpi3mr_free_mem - Free memory allocated for a controller
@@ -2926,6 +3077,7 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 /**
  * mpi3mr_cleanup_ioc - Cleanup controller
  * @mrioc: Adapter instance reference
+ * @re_init: Cleanup due to a reinit or not
  *
  * Controller cleanup handler, Message unit reset or soft reset
  * and shutdown notification is issued to the controller and the
@@ -2933,11 +3085,12 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
  *
  * Return: Nothing.
  */
-void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
+void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 {
 	enum mpi3mr_iocstate ioc_state;
 
-	mpi3mr_stop_watchdog(mrioc);
+	if (!re_init)
+		mpi3mr_stop_watchdog(mrioc);
 
 	mpi3mr_ioc_disable_intr(mrioc);
 
@@ -2951,13 +3104,94 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
 			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
 			    MPI3MR_RESET_FROM_MUR_FAILURE);
 
-		 mpi3mr_issue_ioc_shutdown(mrioc);
+		if (!re_init)
+			mpi3mr_issue_ioc_shutdown(mrioc);
 	}
 
-	mpi3mr_free_mem(mrioc);
-	mpi3mr_cleanup_resources(mrioc);
+	if (!re_init) {
+		mpi3mr_free_mem(mrioc);
+		mpi3mr_cleanup_resources(mrioc);
+	}
+}
+
+/**
+ * mpi3mr_drv_cmd_comp_reset - Flush a internal driver command
+ * @mrioc: Adapter instance reference
+ * @cmdptr: Internal command tracker
+ *
+ * Complete an internal driver commands with state indicating it
+ * is completed due to reset.
+ *
+ * Return: Nothing.
+ */
+static inline void mpi3mr_drv_cmd_comp_reset(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_drv_cmd *cmdptr)
+{
+	if (cmdptr->state & MPI3MR_CMD_PENDING) {
+		cmdptr->state |= MPI3MR_CMD_RESET;
+		cmdptr->state &= ~MPI3MR_CMD_PENDING;
+		if (cmdptr->is_waiting) {
+			complete(&cmdptr->done);
+			cmdptr->is_waiting = 0;
+		} else if (cmdptr->callback)
+			cmdptr->callback(mrioc, cmdptr);
+	}
 }
 
+/**
+ * mpi3mr_flush_drv_cmds - Flush internaldriver commands
+ * @mrioc: Adapter instance reference
+ *
+ * Flush all internal driver commands post reset
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3mr_drv_cmd *cmdptr;
+	u8 i;
+
+	cmdptr = &mrioc->init_cmds;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
+	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
+		cmdptr = &mrioc->dev_rmhs_cmds[i];
+		mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+	}
+}
+
+/**
+ * mpi3mr_diagfault_reset_handler - Diag fault reset handler
+ * @mrioc: Adapter instance reference
+ * @reset_reason: Reset reason code
+ *
+ * This is an handler for issuing diag fault reset from the
+ * applications through IOCTL path to stop the execution of the
+ * controller
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
+	u32 reset_reason)
+{
+	int retval = 0;
+
+	mrioc->reset_in_progress = 1;
+
+	mpi3mr_ioc_disable_intr(mrioc);
+
+	retval = mpi3mr_issue_reset(mrioc,
+	    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
+
+	if (retval) {
+		ioc_err(mrioc, "The diag fault reset failed: reason %d\n",
+		    reset_reason);
+		mpi3mr_ioc_enable_intr(mrioc);
+	}
+	ioc_info(mrioc, "%s\n", ((retval == 0) ? "SUCCESS" : "FAILED"));
+	mrioc->reset_in_progress = 0;
+	return retval;
+}
 
 /**
  * mpi3mr_soft_reset_handler - Reset the controller
@@ -2965,12 +3199,120 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
  * @reset_reason: Reset reason code
  * @snapdump: Flag to generate snapdump in firmware or not
  *
- * TBD
+ * This is an handler for recovering controller by issuing soft
+ * reset are diag fault reset.  This is a blocking function and
+ * when one reset is executed if any other resets they will be
+ * blocked. All IOCTLs/IO will be blocked during the reset. If
+ * controller reset is successful then the controller will be
+ * reinitalized, otherwise the controller will be marked as not
+ * recoverable
+ *
+ * In snapdump bit is set, the controller is issued with diag
+ * fault reset so that the firmware can create a snap dump and
+ * post that the firmware will result in F000 fault and the
+ * driver will issue soft reset to recover from that.
  *
  * Return: 0 on success, non-zero on failure.
  */
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	u32 reset_reason, u8 snapdump)
 {
-	return 0;
+	int retval = 0, i;
+	unsigned long flags;
+	u32 host_diagnostic, timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
+
+	if (mrioc->fault_dbg) {
+		if (snapdump)
+			mpi3mr_set_diagsave(mrioc);
+		mpi3mr_kill_ioc(mrioc, reset_reason);
+	}
+
+	/*
+	 * Block new resets until the currently executing one is finished and
+	 * return the status of the existing reset for all blocked resets
+	 */
+	if (!mutex_trylock(&mrioc->reset_mutex)) {
+		ioc_info(mrioc, "Another reset in progress\n");
+		return -1;
+	}
+	mrioc->reset_in_progress = 1;
+
+	if ((!snapdump) && (reset_reason != MPI3MR_RESET_FROM_FAULT_WATCH) &&
+	    (reset_reason != MPI3MR_RESET_FROM_CIACTIV_FAULT)) {
+
+		for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
+			mrioc->event_masks[i] = -1;
+
+		retval = mpi3mr_issue_event_notification(mrioc);
+
+		if (retval) {
+			ioc_err(mrioc,
+			    "Failed to turn off events prior to reset %d\n",
+			    retval);
+		}
+	}
+
+	mpi3mr_ioc_disable_intr(mrioc);
+
+	if (snapdump) {
+		mpi3mr_set_diagsave(mrioc);
+		retval = mpi3mr_issue_reset(mrioc,
+		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
+		if (!retval) {
+			do {
+				host_diagnostic =
+				    readl(&mrioc->sysif_regs->HostDiagnostic);
+				if (!(host_diagnostic &
+				    MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS))
+					break;
+				msleep(100);
+			} while (--timeout);
+		}
+	}
+
+	retval = mpi3mr_issue_reset(mrioc,
+	    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET, reset_reason);
+	if (retval) {
+		ioc_err(mrioc, "Failed to issue soft reset to the ioc\n");
+		goto out;
+	}
+
+	mpi3mr_flush_delayed_rmhs_list(mrioc);
+	mpi3mr_flush_drv_cmds(mrioc);
+	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
+	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
+	mpi3mr_cleanup_fwevt_list(mrioc);
+	mpi3mr_flush_host_io(mrioc);
+	mpi3mr_invalidate_devhandles(mrioc);
+	mpi3mr_memset_buffers(mrioc);
+	retval = mpi3mr_init_ioc(mrioc, 1);
+	if (retval) {
+		pr_err(IOCNAME "reinit after soft reset failed: reason %d\n",
+		    mrioc->name, reset_reason);
+		goto out;
+	}
+	ssleep(10);
+
+out:
+	if (!retval) {
+		mrioc->reset_in_progress = 0;
+		scsi_unblock_requests(mrioc->shost);
+		mpi3mr_rfresh_tgtdevs(mrioc);
+		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
+		if (mrioc->watchdog_work_q)
+			queue_delayed_work(mrioc->watchdog_work_q,
+			    &mrioc->watchdog_work,
+			    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
+		spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
+	} else {
+		mpi3mr_issue_reset(mrioc,
+		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
+		mrioc->unrecoverable = 1;
+		mrioc->reset_in_progress = 0;
+		retval = -1;
+	}
+
+	mutex_unlock(&mrioc->reset_mutex);
+	ioc_info(mrioc, "%s\n", ((retval == 0) ? "SUCCESS" : "FAILED"));
+	return retval;
 }
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 9999d4c9be05..4d94352a4d48 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -311,6 +311,88 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
 	}
 }
 
+/**
+ * mpi3mr_invalidate_devhandles -Invalidate device handles
+ * @mrioc: Adapter instance reference
+ *
+ * Invalidate the device handles in the target device structures
+ * . Called post reset prior to reinitializing the controller.
+ *
+ * Return: Nothing.
+ */
+void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+	struct mpi3mr_stgt_priv_data *tgt_priv;
+
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
+		tgtdev->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+		if (tgtdev->starget && tgtdev->starget->hostdata) {
+			tgt_priv = tgtdev->starget->hostdata;
+			tgt_priv->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+		}
+	}
+}
+
+
+/**
+ * mpi3mr_flush_scmd - Flush individual SCSI command
+ * @rq: Block request
+ * @data: Adapter instance reference
+ *
+ * Return the SCSI command to the upper layers if it is in LLD
+ * scope.
+ *
+ * Return: true always.
+ */
+
+static bool mpi3mr_flush_scmd(struct request *rq,
+	void *data, bool reserved)
+{
+	struct mpi3mr_ioc *mrioc = (struct mpi3mr_ioc *)data;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct scmd_priv *priv = NULL;
+
+	if (scmd) {
+		priv = scsi_cmd_priv(scmd);
+		if (!priv->in_lld_scope)
+			goto out;
+
+		mpi3mr_clear_scmd_priv(mrioc, scmd);
+		scsi_dma_unmap(scmd);
+		scmd->result = DID_RESET << 16;
+		scsi_print_command(scmd);
+		scmd->scsi_done(scmd);
+		mrioc->flush_io_count++;
+	}
+
+out:
+	return(true);
+}
+
+
+/**
+ * mpi3mr_flush_host_io -  Flush host I/Os
+ * @mrioc: Adapter instance reference
+ *
+ * Flush all of the pending I/Os by calling
+ * blk_mq_tagset_busy_iter() for each possible tag. This is
+ * executed post controller reset
+ *
+ * Return: Nothing.
+ */
+void mpi3mr_flush_host_io(struct mpi3mr_ioc *mrioc)
+{
+	struct Scsi_Host *shost = mrioc->shost;
+
+	mrioc->flush_io_count = 0;
+	ioc_info(mrioc, "%s :Flushing Host I/O cmds post reset\n", __func__);
+	blk_mq_tagset_busy_iter(&shost->tag_set,
+	    mpi3mr_flush_scmd, (void *)mrioc);
+	ioc_info(mrioc, "%s :Flushed %d Host I/O cmds\n", __func__,
+	    mrioc->flush_io_count);
+}
+
 /**
  * mpi3mr_alloc_tgtdev - target device allocator
  *
@@ -2513,11 +2595,14 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
 	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
 
+	mutex_init(&mrioc->reset_mutex);
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
 
 	if (pdev->revision)
 		mrioc->enable_segqueue = true;
 
+	init_waitqueue_head(&mrioc->reset_waitq);
+
 	mrioc->logging_level = logging_level;
 	mrioc->shost = shost;
 	mrioc->pdev = pdev;
@@ -2542,7 +2627,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc->is_driver_loading = 1;
-	if (mpi3mr_init_ioc(mrioc)) {
+	if (mpi3mr_init_ioc(mrioc, 0)) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
 		retval = -ENODEV;
@@ -2565,7 +2650,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return retval;
 
 addhost_failed:
-	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_cleanup_ioc(mrioc, 0);
 out_iocinit_failed:
 	destroy_workqueue(mrioc->fwevt_worker_thread);
 out_fwevtthread_failed:
@@ -2615,7 +2700,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 		mpi3mr_tgtdev_put(tgtdev);
 	}
 
-	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_cleanup_ioc(mrioc, 0);
 
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
@@ -2655,7 +2740,7 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 	if (wq)
 		destroy_workqueue(wq);
 
-	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_cleanup_ioc(mrioc, 0);
 
 }
 
-- 
2.18.1


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000f843c205b70ad051
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg6PEo1wzm
P9lxdPd3f+sOJqwf/D1qP9MbRMYwfFf/mVgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMjQ3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAwKWnnGYPhxUzbLHWvSM/+8zMby
Bv7pi09DLA0mWumgb7FKZz+bq1eRPLGHvfv7UYhv5vcDr0dMq2H3Mz/JTACE/jaKmjG1LB/+rov9
YLvm/crOastPuQOd65Npn1AuyV7ZaDOBj//i8WMS+TlE3tlF2NeuQGJHdYDVNqftCI+LnwoIVqqi
TJBrpGkpb0megJ09bso9hhVjGHUJbw2Fxv37hWeQLxY1qpqkeKhWAW6gSq7f1/7cYgyCyg7I3Vpb
HBp5WkPmcMrcx9aoWH85hpXuHA++aqh4QsPZ+yxxjUt9jwT8+WaO/bEKF816TA3QUjtbwFsmuY8N
UdrlGUpNp34=
--000000000000f843c205b70ad051--
