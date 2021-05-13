Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A08C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 009A1613E6
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhEMIeh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 04:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhEMIeQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 04:34:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA49C061574
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:33:06 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id s20so13968782plr.13
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Xwz13Mr+7LQjd77d8QEsaZ+T0MvGA5LLniuFqhMIdOM=;
        b=BkINYnjohu0hbf4+bOL/PvbnFSx18kBrulJayds8qVhf/dozXX4+thEiV02u9ewubN
         Q3kaQmDI2+E/CKy0S8LgUlHuBnTPy3RF8LXJxFhB5EVGb9CMzVv8CWqTeGr2rWu/j0R0
         0FoB4MZXUQmAd64ygjfOC+M/rug4VwgC7K5wY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Xwz13Mr+7LQjd77d8QEsaZ+T0MvGA5LLniuFqhMIdOM=;
        b=HI8RNrCY0Y2Xp1c8/EpnjjQgJ+JximklzVgHXy/uQabxrrlCUD9BaxOMtFYFlpaJTt
         vUgW7JiqkTH+qEXbmiAFJ4iCt4Njo3HDFl9ONjpZTGo7xCNYzEYEHKKHz8PIZCRe+Y/r
         +TAwMkYFl9J5bBvQVFFnxXRYKlG89ujL1GPD/r5NTsZCWbYe8pAykDrQgwn+AOQX/e76
         PUCTaDSXSIleF4GlLdHeMDVn6u9UCcXXhxfEyqcvc+ldjFj/xnNzcRICO2n3UTgrS9k/
         pf8Ki6OzZj0yFNEBVkPlYh5Q8XoODnWWhueNvN6bkF76A7fWUd6kMtHYq8qe9uV3+Dzi
         B3Kg==
X-Gm-Message-State: AOAM5327GlnCZ73cFQ3pVbjtRKNQJYmQgcpkc4DvgUoHG8oIvQOmggjS
        hki0dxgxoS0ybANZ+zxHW6+wmeSWyoOZsQVN3bzqsBfg4gCoMvXIj+dTZK7zJaq/R935Iq0223N
        rEXUziChkNTBcMHr4gYahJqCy/dRusC4WS7llN0CGtB0KycElPWCx6Cuvmoa4jWG8Vro+YpoopU
        SINCuCRw==
X-Google-Smtp-Source: ABdhPJzcJNU6BWo8PS2zp/gi2iTqrPtPagTdcOQu9Gc1u4pJwY16VURWWUJYaQUGadVjSMJHw/5KFA==
X-Received: by 2002:a17:902:e9d1:b029:ed:1bde:8e4 with SMTP id 17-20020a170902e9d1b02900ed1bde08e4mr39812203plk.6.1620894784740;
        Thu, 13 May 2021 01:33:04 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i123sm1632468pfc.53.2021.05.13.01.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:33:04 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v5 09/24] mpi3mr: add support for recovering controller
Date:   Thu, 13 May 2021 14:05:53 +0530
Message-Id: <20210513083608.2243297-10-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e72b9a05c231f978"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e72b9a05c231f978

Added h/w defined process of doing controller reset.
The driver on detection of firmware fault or any kind of unresponsiveness
 in the controller (Any admin command time outs) results in resetting the
controller. The primary reset mechanisms used are either soft reset or
diag fault reset. Reset is performed if the host sets the ResetAction field
in the HostDiagnostic register to a 001b (Soft Reset) or
007b(diag fault reset). The driver after successfully resetting the
controller reinitialize the controller by going through start of the day
controller initialization procedures.The pending I/Os during the reset are
returned back to SML for retry.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  15 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 415 +++++++++++++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_os.c |  90 ++++++-
 3 files changed, 478 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9c6415f736c4..2404f86e2364 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -98,6 +98,7 @@ extern struct list_head mrioc_list;
 #define MPI3MR_INTADMCMD_TIMEOUT		10
 #define MPI3MR_PORTENABLE_TIMEOUT		300
 #define MPI3MR_RESETTM_TIMEOUT			30
+#define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
 #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
@@ -630,10 +631,14 @@ struct scmd_priv {
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
@@ -748,11 +753,15 @@ struct mpi3mr_ioc {
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
 	struct _mpi3_driver_info_layout driver_info;
@@ -801,8 +810,8 @@ struct delayed_dev_rmhs_node {
 
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
 void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
-int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
-void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc);
+int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init);
+void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 re_init);
 int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async);
 int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
 u16 admin_req_sz, u8 ignore_reset);
@@ -828,6 +837,8 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
 
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 			      u32 reset_reason, u8 snapdump);
+int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
+				   u32 reset_reason);
 void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
 void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 274acba2bcac..9a0884b897de 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1594,6 +1594,41 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc)
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
+
 /**
  * mpi3mr_setup_admin_qpair - Setup admin queue pair
  * @mrioc: Adapter instance reference
@@ -2550,6 +2585,7 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)
 /**
  * mpi3mr_init_ioc - Initialize the controller
  * @mrioc: Adapter instance reference
+ * @re_init: Flag to indicate is this fresh init or re-init
  *
  * This the controller initialization routine, executed either
  * after soft reset or from pci probe callback.
@@ -2562,7 +2598,7 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)
  *
  * Return: 0 on success and non-zero on failure.
  */
-int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
+int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 {
 	int retval = 0;
 	enum mpi3mr_iocstate ioc_state;
@@ -2572,13 +2608,16 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	struct _mpi3_ioc_facts_data facts_data;
 
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
+
 	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
 
@@ -2653,12 +2692,15 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
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
@@ -2668,11 +2710,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
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
 	}
 
 	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
@@ -2683,11 +2727,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
-	retval = mpi3mr_alloc_chain_bufs(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
-		    retval);
-		goto out_failed;
+	if (!re_init) {
+		retval = mpi3mr_alloc_chain_bufs(mrioc);
+		if (retval) {
+			ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
+			    retval);
+			goto out_failed;
+		}
 	}
 
 	retval = mpi3mr_issue_iocinit(mrioc);
@@ -2704,11 +2750,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	writel(mrioc->sbq_host_index,
 	    &mrioc->sysif_regs->sense_buffer_free_host_index);
 
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
@@ -2718,6 +2766,14 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
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
 
@@ -2741,14 +2797,110 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
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
+
 /**
  * mpi3mr_free_mem - Free memory allocated for a controller
  * @mrioc: Adapter instance reference
@@ -2921,6 +3073,7 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 /**
  * mpi3mr_cleanup_ioc - Cleanup controller
  * @mrioc: Adapter instance reference
+ * @re_init: Cleanup due to a reinit or not
  *
  * controller cleanup handler, Message unit reset or soft reset
  * and shutdown notification is issued to the controller and the
@@ -2928,11 +3081,12 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
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
 
@@ -2946,11 +3100,93 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
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
+}
+
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
 }
 
 /**
@@ -2959,12 +3195,119 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
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
+				    readl(&mrioc->sysif_regs->host_diagnostic);
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
index 17afe83406f9..5f66926935aa 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -310,6 +310,86 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
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
@@ -2504,6 +2584,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
 	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
 
+	mutex_init(&mrioc->reset_mutex);
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
@@ -2513,6 +2594,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pdev->revision)
 		mrioc->enable_segqueue = true;
 
+	init_waitqueue_head(&mrioc->reset_waitq);
 	mrioc->logging_level = logging_level;
 	mrioc->shost = shost;
 	mrioc->pdev = pdev;
@@ -2537,7 +2619,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc->is_driver_loading = 1;
-	if (mpi3mr_init_ioc(mrioc)) {
+	if (mpi3mr_init_ioc(mrioc, 0)) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
 		retval = -ENODEV;
@@ -2560,7 +2642,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return retval;
 
 addhost_failed:
-	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_cleanup_ioc(mrioc, 0);
 out_iocinit_failed:
 	destroy_workqueue(mrioc->fwevt_worker_thread);
 out_fwevtthread_failed:
@@ -2609,7 +2691,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
-	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_cleanup_ioc(mrioc, 0);
 
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
@@ -2649,7 +2731,7 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 	if (wq)
 		destroy_workqueue(wq);
-	mpi3mr_cleanup_ioc(mrioc);
+	mpi3mr_cleanup_ioc(mrioc, 0);
 }
 
 static const struct pci_device_id mpi3mr_pci_id_table[] = {
-- 
2.18.1


--000000000000e72b9a05c231f978
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMUg0+RNhcazufC/GDldg1svemRx
ZslMQ5QDaPwexdhTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxMzA4MzMwNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBtz0tAmc5Z7hlJAilWewB/GuyynrwKgKJZcvpW/KPnl1sE
38JpBa4v5k/t+J51XCYplf8O2pbVAQoc0uBev/xKcIOWM57b1Hl7786xpdeMs20XdDHQP3lJDgo6
c2wvsA6pd6v61vKvI2HTU7as7YBllRsJqNhBJEw0HkUJQIQ6lqTJ8pTexrFoCi5Fr8ohUydc60s7
mrCX7tTOV9V61dmFrpoCFxfrIWbihduYheaWr1DImfYPYH+YOfecesJmeOLH160Uh2tS2g0xetUW
JUX4hsikKuehE0/UZiSO7Kaqxg92t/xqZszS09Tnp5JzUtkfNknmcJOnmKrmJLSm/BXB
--000000000000e72b9a05c231f978--
