Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4202C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9F0423130
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgLVKNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgLVKNI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:08 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECFAC0617A6
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:27 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id h186so8215597pfe.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mxDQp5QX0/Ld9fpUiwFn3Y19XNjlp5NWVRNZ0Vi4eEU=;
        b=ACbxkKiKBytcHmChRbiYMRdM7C3OWfr/6CXJM6773iSQf9Or9CWUVIZstQgZjswglR
         MrEGQixIu5iEmbXKGr4qur6o5hAL+q8SsSY+6D1A94qrMcFYnqfzHknFJAKmjOVU4RnS
         vbGQWAF4aTIAnRsLTZ2qIfBzgd0+1BYtK9TzQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=mxDQp5QX0/Ld9fpUiwFn3Y19XNjlp5NWVRNZ0Vi4eEU=;
        b=K5vaEaHy5ZzEM3V8SkJcgP8betXPNnnWBhuUZjh7lpFq3MMSdzvuGxJbHPx4vKqVR+
         XOCFghKqv94WhAhvU+9102apTe0hl46T7eJusfNqZGCu2yUBpXsxDjRytl5ensVYVrvF
         /k3JsCsG5LVXiXssE+wmFxAdmBTci+xLWXKWhXiwLxmEdWE0FErLBmz18mzT55o3toQk
         xJjD/duBZ+4Ad+KhgnSZNI7N0LSasBDH6ML6sAQ9+o+I0f0orbJGlw2Dxv0WmwxhQ66n
         vDz485uBRcJ2l/w/AVXhWDx/5eK39idC29TMAaol1SYkQxWOjrkyzips8URMpVjArU2d
         WGOw==
X-Gm-Message-State: AOAM530HOP4dZ1pQNZoh1y9KshW8FEnQSqeSvbt1Y8o7bra93gcPVwUS
        0X/kuQf0Xd6IhyxR78B9UmIfEBn6iCxwCPcvUQfjvbYP9v/lApdE6JS+1uDaXga9MX2KzfQbfwR
        fXgUcVpbGPi1b2jInT/uklVexqGSh7Pus9Z3Ap7SVH3wT2gydJzoA0viovMEIwBmky4q7fpgWOC
        xOkxqzb9jd
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJxOuqDKU2rSX5x7o7Ccho/SH+TsKWNkYgnLNxLl4Ezhu0lqmdTPqNivdUsBbOXmfk/LLwiHXQ==
X-Received: by 2002:a65:4347:: with SMTP id k7mr8347289pgq.186.1608631946463;
        Tue, 22 Dec 2020 02:12:26 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:12:26 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 03/24] mpi3mr: create operational request and reply queue pair
Date:   Tue, 22 Dec 2020 15:41:35 +0530
Message-Id: <20201222101156.98308-4-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c7801905b70acf66"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c7801905b70acf66
Content-Type: text/plain; charset="US-ASCII"

Create operational request and reply queue pair.

The MPI3 transport interface consists of an Administrative Request Queue,
an Administrative Reply Queue, and Operational Messaging Queues.
The Operational Messaging Queues are the primary communication mechanism
between the host and the I/O Controller (IOC).
Request messages, allocated in host memory, identify I/O operations to be
performed by the IOC. These operations are queued on an Operational
Request Queue by the host driver.
Reply descriptors track I/O operations as they complete.
The IOC queues these completions in an Operational Reply Queue.

To fulfil large contiguous memory requirement, driver creates multiple
segments and provide the list of segments. Each segment size should be 4K
which is h/w requirement. An element array is contiguous or segmented.
A contiguous element array is located in contiguous physical memory.
A contiguous element array must be aligned on an element size boundary.
An element's physical address within the array may be directly calculated
from the base address, the Producer/Consumer index, and the element size.

Expected phased identifier bit is used to find out valid entry on reply queue.
Driver set <ephase> bit and IOC invert the value of this bit on each pass.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  56 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 601 ++++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c |   4 +-
 3 files changed, 660 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index dd79b12218e1..fe6094bb357a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -71,6 +71,12 @@ extern struct list_head mrioc_list;
 #define MPI3MR_ADMIN_REQ_FRAME_SZ	128
 #define MPI3MR_ADMIN_REPLY_FRAME_SZ	16
 
+/* Operational queue management definitions */
+#define MPI3MR_OP_REQ_Q_QD		512
+#define MPI3MR_OP_REP_Q_QD		4096
+#define MPI3MR_OP_REQ_Q_SEG_SIZE	4096
+#define MPI3MR_OP_REP_Q_SEG_SIZE	4096
+#define MPI3MR_MAX_SEG_LIST_SIZE	4096
 
 /* Reserved Host Tag definitions */
 #define MPI3MR_HOSTTAG_INVALID		0xFFFF
@@ -132,6 +138,9 @@ extern struct list_head mrioc_list;
 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
 	MPI3_SGE_FLAGS_END_OF_LIST)
 
+/* MSI Index from Reply Queue Index */
+#define REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, offset)	(qidx + offset)
+
 /* IOC State definitions */
 enum mpi3mr_iocstate {
 	MRIOC_STATE_READY = 1,
@@ -222,15 +231,45 @@ struct mpi3mr_ioc_facts {
 	u8 sge_mod_shift;
 };
 
+/**
+ * struct segments - memory descriptor structure to store
+ * virtual and dma addresses for operational queue segments.
+ *
+ * @segment: virtual address
+ * @segment_dma: dma address
+ */
+struct segments {
+	void *segment;
+	dma_addr_t segment_dma;
+};
+
 /**
  * struct op_req_qinfo -  Operational Request Queue Information
  *
  * @ci: consumer index
  * @pi: producer index
+ * @num_request: Maximum number of entries in the queue
+ * @qid: Queue Id starting from 1
+ * @reply_qid: Associated reply queue Id
+ * @num_segments: Number of discontiguous memory segments
+ * @segment_qd: Depth of each segments
+ * @q_lock: Concurrent queue access lock
+ * @q_segments: Segment descriptor pointer
+ * @q_segment_list: Segment list base virtual address
+ * @q_segment_list_dma: Segment list base DMA address
  */
 struct op_req_qinfo {
 	u16 ci;
 	u16 pi;
+	u16 num_requests;
+	u16 qid;
+	u16 reply_qid;
+	u16 num_segments;
+	u16 segment_qd;
+	spinlock_t q_lock;
+	struct segments *q_segments;
+	void *q_segment_list;
+	dma_addr_t q_segment_list_dma;
 };
 
 /**
@@ -238,10 +277,24 @@ struct op_req_qinfo {
  *
  * @ci: consumer index
  * @qid: Queue Id starting from 1
+ * @num_replies: Maximum number of entries in the queue
+ * @num_segments: Number of discontiguous memory segments
+ * @segment_qd: Depth of each segments
+ * @q_segments: Segment descriptor pointer
+ * @q_segment_list: Segment list base virtual address
+ * @q_segment_list_dma: Segment list base DMA address
+ * @ephase: Expected phased identifier for the reply queue
  */
 struct op_reply_qinfo {
 	u16 ci;
 	u16 qid;
+	u16 num_replies;
+	u16 num_segments;
+	u16 segment_qd;
+	struct segments *q_segments;
+	void *q_segment_list;
+	dma_addr_t q_segment_list_dma;
+	u8 ephase;
 };
 
 /**
@@ -402,6 +455,7 @@ struct scmd_priv {
  * @current_event: Firmware event currently in process
  * @driver_info: Driver, Kernel, OS information to firmware
  * @change_count: Topology change count
+ * @op_reply_q_offset: Operational reply queue offset with MSIx
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -409,6 +463,7 @@ struct mpi3mr_ioc {
 	struct Scsi_Host *shost;
 	u8 id;
 	int cpu_count;
+	bool enable_segqueue;
 
 	char name[MPI3MR_NAME_LENGTH];
 	char driver_name[MPI3MR_NAME_LENGTH];
@@ -495,6 +550,7 @@ struct mpi3mr_ioc {
 	struct mpi3mr_fwevt *current_event;
 	Mpi3DriverInfoLayout_t driver_info;
 	u16 change_count;
+	u16 op_reply_q_offset;
 };
 
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 97eb7e6ec5c6..6fb28983038e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -408,6 +408,8 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 
 	irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
 
+	mrioc->op_reply_q_offset = (max_vectors > 1) ? 1 : 0;
+
 	i = pci_alloc_irq_vectors_affinity(mrioc->pdev,
 	    1, max_vectors, irq_flags, &desc);
 	if (i <= 0) {
@@ -418,6 +420,12 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 		ioc_info(mrioc,
 		    "allocated vectors (%d) are less than configured (%d)\n",
 		    i, max_vectors);
+		/*
+		 * If only one MSI-x is allocated, then MSI-x 0 will be shared
+		 * between Admin queue and operational queue
+		 */
+		if (i == 1)
+			mrioc->op_reply_q_offset = 0;
 
 		max_vectors = i;
 	}
@@ -726,6 +734,586 @@ int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
 	return retval;
 }
 
+/**
+ * mpi3mr_free_op_req_q_segments - free request memory segments
+ * @mrioc: Adapter instance reference
+ * @q_idx: operational request queue index
+ *
+ * Free memory segments allocated for operational request queue
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
+{
+	u16 j;
+	int size;
+	struct segments *segments;
+
+	segments = mrioc->req_qinfo[q_idx].q_segments;
+	if (!segments)
+		return;
+
+	if (mrioc->enable_segqueue) {
+		size = MPI3MR_OP_REQ_Q_SEG_SIZE;
+		if (mrioc->req_qinfo[q_idx].q_segment_list) {
+			dma_free_coherent(&mrioc->pdev->dev,
+			    MPI3MR_MAX_SEG_LIST_SIZE,
+			    mrioc->req_qinfo[q_idx].q_segment_list,
+			    mrioc->req_qinfo[q_idx].q_segment_list_dma);
+			mrioc->op_reply_qinfo[q_idx].q_segment_list = NULL;
+		}
+	} else
+		size = mrioc->req_qinfo[q_idx].num_requests *
+		    mrioc->facts.op_req_sz;
+
+	for (j = 0; j < mrioc->req_qinfo[q_idx].num_segments; j++) {
+		if (!segments[j].segment)
+			continue;
+		dma_free_coherent(&mrioc->pdev->dev,
+		    size, segments[j].segment, segments[j].segment_dma);
+		segments[j].segment = NULL;
+	}
+	kfree(mrioc->req_qinfo[q_idx].q_segments);
+	mrioc->req_qinfo[q_idx].q_segments = NULL;
+	mrioc->req_qinfo[q_idx].qid = 0;
+}
+
+/**
+ * mpi3mr_free_op_reply_q_segments - free reply memory segments
+ * @mrioc: Adapter instance reference
+ * @q_idx: operational reply queue index
+ *
+ * Free memory segments allocated for operational reply queue
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_free_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
+{
+	u16 j;
+	int size;
+	struct segments *segments;
+
+	segments = mrioc->op_reply_qinfo[q_idx].q_segments;
+	if (!segments)
+		return;
+
+	if (mrioc->enable_segqueue) {
+		size = MPI3MR_OP_REP_Q_SEG_SIZE;
+		if (mrioc->op_reply_qinfo[q_idx].q_segment_list) {
+			dma_free_coherent(&mrioc->pdev->dev,
+			    MPI3MR_MAX_SEG_LIST_SIZE,
+			    mrioc->op_reply_qinfo[q_idx].q_segment_list,
+			    mrioc->op_reply_qinfo[q_idx].q_segment_list_dma);
+			mrioc->op_reply_qinfo[q_idx].q_segment_list = NULL;
+		}
+	} else
+		size = mrioc->op_reply_qinfo[q_idx].segment_qd *
+		    mrioc->op_reply_desc_sz;
+
+	for (j = 0; j < mrioc->op_reply_qinfo[q_idx].num_segments; j++) {
+		if (!segments[j].segment)
+			continue;
+		dma_free_coherent(&mrioc->pdev->dev,
+		    size, segments[j].segment, segments[j].segment_dma);
+		segments[j].segment = NULL;
+	}
+
+	kfree(mrioc->op_reply_qinfo[q_idx].q_segments);
+	mrioc->op_reply_qinfo[q_idx].q_segments = NULL;
+	mrioc->op_reply_qinfo[q_idx].qid = 0;
+}
+
+/**
+ * mpi3mr_delete_op_reply_q - delete operational reply queue
+ * @mrioc: Adapter instance reference
+ * @qidx: operational reply queue index
+ *
+ * Delete operatinal reply queue by issuing MPI request
+ * through admin queue.
+ *
+ * Return:  0 on success, non-zero on failure.
+ */
+static int mpi3mr_delete_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
+{
+	Mpi3DeleteReplyQueueRequest_t delq_req;
+	int retval = 0;
+	u16 reply_qid = 0, midx;
+
+	reply_qid = mrioc->op_reply_qinfo[qidx].qid;
+
+	midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, mrioc->op_reply_q_offset);
+
+	if (!reply_qid)	{
+		retval = -1;
+		ioc_err(mrioc, "Issue DelRepQ: called with invalid ReqQID\n");
+		goto out;
+	}
+
+	memset(&delq_req, 0, sizeof(delq_req));
+	mutex_lock(&mrioc->init_cmds.mutex);
+	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "Issue DelRepQ: Init command is in use\n");
+		mutex_unlock(&mrioc->init_cmds.mutex);
+		goto out;
+	}
+	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->init_cmds.is_waiting = 1;
+	mrioc->init_cmds.callback = NULL;
+	delq_req.HostTag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
+	delq_req.Function = MPI3_FUNCTION_DELETE_REPLY_QUEUE;
+	delq_req.QueueID = cpu_to_le16(reply_qid);
+
+	init_completion(&mrioc->init_cmds.done);
+	retval = mpi3mr_admin_request_post(mrioc, &delq_req, sizeof(delq_req),
+	    1);
+	if (retval) {
+		ioc_err(mrioc, "Issue DelRepQ: Admin Post failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->init_cmds.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "Issue DelRepQ: command timed out\n");
+		mpi3mr_set_diagsave(mrioc);
+		mpi3mr_issue_reset(mrioc,
+		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		    MPI3MR_RESET_FROM_DELREPQ_TIMEOUT);
+		mrioc->unrecoverable = 1;
+
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	    != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc,
+		    "Issue DelRepQ: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
+		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->init_cmds.ioc_loginfo);
+		retval = -1;
+		goto out_unlock;
+	}
+	mrioc->intr_info[midx].op_reply_q = NULL;
+
+	mpi3mr_free_op_reply_q_segments(mrioc, qidx);
+out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->init_cmds.mutex);
+out:
+
+	return retval;
+}
+
+/**
+ * mpi3mr_alloc_op_reply_q_segments -Alloc segmented reply pool
+ * @mrioc: Adapter instance reference
+ * @qidx: request queue index
+ *
+ * Allocate segmented memory pools for operational reply
+ * queue.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_alloc_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u16 qidx)
+{
+	struct op_reply_qinfo *op_reply_q = mrioc->op_reply_qinfo + qidx;
+	int i, size;
+	u64 *q_segment_list_entry = NULL;
+	struct segments *segments;
+
+	if (mrioc->enable_segqueue) {
+		op_reply_q->segment_qd =
+		    MPI3MR_OP_REP_Q_SEG_SIZE / mrioc->op_reply_desc_sz;
+
+		size = MPI3MR_OP_REP_Q_SEG_SIZE;
+
+		op_reply_q->q_segment_list = dma_alloc_coherent(&mrioc->pdev->dev,
+		    MPI3MR_MAX_SEG_LIST_SIZE, &op_reply_q->q_segment_list_dma,
+		    GFP_KERNEL);
+		if (!op_reply_q->q_segment_list)
+			return -ENOMEM;
+		q_segment_list_entry = (u64 *)op_reply_q->q_segment_list;
+	} else {
+		op_reply_q->segment_qd = op_reply_q->num_replies;
+		size = op_reply_q->num_replies * mrioc->op_reply_desc_sz;
+	}
+
+	op_reply_q->num_segments = DIV_ROUND_UP(op_reply_q->num_replies,
+	    op_reply_q->segment_qd);
+
+	op_reply_q->q_segments = kcalloc(op_reply_q->num_segments,
+	    sizeof(struct segments), GFP_KERNEL);
+	if (!op_reply_q->q_segments)
+		return -ENOMEM;
+
+	segments = op_reply_q->q_segments;
+	for (i = 0; i < op_reply_q->num_segments; i++) {
+		segments[i].segment =
+		    dma_alloc_coherent(&mrioc->pdev->dev,
+		    size, &segments[i].segment_dma, GFP_KERNEL);
+		if (!segments[i].segment)
+			return -ENOMEM;
+		if (mrioc->enable_segqueue)
+			q_segment_list_entry[i] =
+			    (unsigned long)segments[i].segment_dma;
+	}
+
+	return 0;
+}
+
+/**
+ * mpi3mr_alloc_op_req_q_segments - Alloc segmented req pool.
+ * @mrioc: Adapter instance reference
+ * @qidx: request queue index
+ *
+ * Allocate segmented memory pools for operational request
+ * queue.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_alloc_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 qidx)
+{
+	struct op_req_qinfo *op_req_q = mrioc->req_qinfo + qidx;
+	int i, size;
+	u64 *q_segment_list_entry = NULL;
+	struct segments *segments;
+
+	if (mrioc->enable_segqueue) {
+		op_req_q->segment_qd =
+		    MPI3MR_OP_REQ_Q_SEG_SIZE / mrioc->facts.op_req_sz;
+
+		size = MPI3MR_OP_REQ_Q_SEG_SIZE;
+
+		op_req_q->q_segment_list = dma_alloc_coherent(&mrioc->pdev->dev,
+		    MPI3MR_MAX_SEG_LIST_SIZE, &op_req_q->q_segment_list_dma,
+		    GFP_KERNEL);
+		if (!op_req_q->q_segment_list)
+			return -ENOMEM;
+		q_segment_list_entry = (u64 *)op_req_q->q_segment_list;
+
+	} else {
+		op_req_q->segment_qd = op_req_q->num_requests;
+		size = op_req_q->num_requests * mrioc->facts.op_req_sz;
+	}
+
+	op_req_q->num_segments = DIV_ROUND_UP(op_req_q->num_requests,
+	    op_req_q->segment_qd);
+
+	op_req_q->q_segments = kcalloc(op_req_q->num_segments,
+	    sizeof(struct segments), GFP_KERNEL);
+	if (!op_req_q->q_segments)
+		return -ENOMEM;
+
+	segments = op_req_q->q_segments;
+	for (i = 0; i < op_req_q->num_segments; i++) {
+		segments[i].segment =
+		    dma_alloc_coherent(&mrioc->pdev->dev,
+		    size, &segments[i].segment_dma, GFP_KERNEL);
+		if (!segments[i].segment)
+			return -ENOMEM;
+		if (mrioc->enable_segqueue)
+			q_segment_list_entry[i] =
+			    (unsigned long)segments[i].segment_dma;
+	}
+
+	return 0;
+}
+
+/**
+ * mpi3mr_create_op_reply_q - create operational reply queue
+ * @mrioc: Adapter instance reference
+ * @qidx: operational reply queue index
+ *
+ * Create operatinal reply queue by issuing MPI request
+ * through admin queue.
+ *
+ * Return:  0 on success, non-zero on failure.
+ */
+static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
+{
+	Mpi3CreateReplyQueueRequest_t create_req;
+	struct op_reply_qinfo *op_reply_q = mrioc->op_reply_qinfo + qidx;
+	int retval = 0;
+	u16 reply_qid = 0, midx;
+
+
+	reply_qid = op_reply_q->qid;
+
+	midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, mrioc->op_reply_q_offset);
+
+	if (reply_qid) {
+		retval = -1;
+		ioc_err(mrioc, "CreateRepQ: called for duplicate qid %d\n",
+		    reply_qid);
+
+		return retval;
+	}
+
+	reply_qid = qidx + 1;
+	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
+	op_reply_q->ci = 0;
+	op_reply_q->ephase = 1;
+
+	if (!op_reply_q->q_segments) {
+		retval = mpi3mr_alloc_op_reply_q_segments(mrioc, qidx);
+		if (retval) {
+			mpi3mr_free_op_reply_q_segments(mrioc, qidx);
+			goto out;
+		}
+	}
+
+	memset(&create_req, 0, sizeof(create_req));
+	mutex_lock(&mrioc->init_cmds.mutex);
+	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "CreateRepQ: Init command is in use\n");
+		goto out;
+	}
+	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->init_cmds.is_waiting = 1;
+	mrioc->init_cmds.callback = NULL;
+	create_req.HostTag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
+	create_req.Function = MPI3_FUNCTION_CREATE_REPLY_QUEUE;
+	create_req.QueueID = cpu_to_le16(reply_qid);
+	create_req.Flags = MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_ENABLE;
+	create_req.MSIxIndex = cpu_to_le16(mrioc->intr_info[midx].msix_index);
+	if (mrioc->enable_segqueue) {
+		create_req.Flags |=
+		    MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_SEGMENTED;
+		create_req.BaseAddress = cpu_to_le64(
+		    op_reply_q->q_segment_list_dma);
+	} else
+		create_req.BaseAddress = cpu_to_le64(
+		    op_reply_q->q_segments[0].segment_dma);
+
+	create_req.Size = cpu_to_le16(op_reply_q->num_replies);
+
+	init_completion(&mrioc->init_cmds.done);
+	retval = mpi3mr_admin_request_post(mrioc, &create_req,
+	    sizeof(create_req), 1);
+	if (retval) {
+		ioc_err(mrioc, "CreateRepQ: Admin Post failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->init_cmds.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "CreateRepQ: command timed out\n");
+		mpi3mr_set_diagsave(mrioc);
+		mpi3mr_issue_reset(mrioc,
+		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		    MPI3MR_RESET_FROM_CREATEREPQ_TIMEOUT);
+		mrioc->unrecoverable = 1;
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	    != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc,
+		    "CreateRepQ: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
+		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->init_cmds.ioc_loginfo);
+		retval = -1;
+		goto out_unlock;
+	}
+	op_reply_q->qid = reply_qid;
+	mrioc->intr_info[midx].op_reply_q = op_reply_q;
+
+out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->init_cmds.mutex);
+out:
+
+	return retval;
+}
+
+/**
+ * mpi3mr_create_op_req_q - create operational request queue
+ * @mrioc: Adapter instance reference
+ * @idx: operational request queue index
+ * @reply_qid: Reply queue ID
+ *
+ * Create operatinal request queue by issuing MPI request
+ * through admin queue.
+ *
+ * Return:  0 on success, non-zero on failure.
+ */
+static int mpi3mr_create_op_req_q(struct mpi3mr_ioc *mrioc, u16 idx,
+	u16 reply_qid)
+{
+	Mpi3CreateRequestQueueRequest_t create_req;
+	struct op_req_qinfo *op_req_q = mrioc->req_qinfo + idx;
+	int retval = 0;
+	u16 req_qid = 0;
+
+
+	req_qid = op_req_q->qid;
+
+	if (req_qid) {
+		retval = -1;
+		ioc_err(mrioc, "CreateReqQ: called for duplicate qid %d\n",
+		    req_qid);
+
+		return retval;
+	}
+	req_qid = idx + 1;
+
+	op_req_q->num_requests = MPI3MR_OP_REQ_Q_QD;
+	op_req_q->ci = 0;
+	op_req_q->pi = 0;
+	op_req_q->reply_qid = reply_qid;
+	spin_lock_init(&op_req_q->q_lock);
+
+	if (!op_req_q->q_segments) {
+		retval = mpi3mr_alloc_op_req_q_segments(mrioc, idx);
+		if (retval) {
+			mpi3mr_free_op_req_q_segments(mrioc, idx);
+			goto out;
+		}
+	}
+
+	memset(&create_req, 0, sizeof(create_req));
+	mutex_lock(&mrioc->init_cmds.mutex);
+	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "CreateReqQ: Init command is in use\n");
+		goto out;
+	}
+	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->init_cmds.is_waiting = 1;
+	mrioc->init_cmds.callback = NULL;
+	create_req.HostTag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
+	create_req.Function = MPI3_FUNCTION_CREATE_REQUEST_QUEUE;
+	create_req.QueueID = cpu_to_le16(req_qid);
+	if (mrioc->enable_segqueue) {
+		create_req.Flags =
+		    MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_SEGMENTED;
+		create_req.BaseAddress = cpu_to_le64(
+		    op_req_q->q_segment_list_dma);
+	} else
+		create_req.BaseAddress = cpu_to_le64(
+		    op_req_q->q_segments[0].segment_dma);
+	create_req.ReplyQueueID = cpu_to_le16(reply_qid);
+	create_req.Size = cpu_to_le16(op_req_q->num_requests);
+
+	init_completion(&mrioc->init_cmds.done);
+	retval = mpi3mr_admin_request_post(mrioc, &create_req,
+	    sizeof(create_req), 1);
+	if (retval) {
+		ioc_err(mrioc, "CreateReqQ: Admin Post failed\n");
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->init_cmds.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "CreateReqQ: command timed out\n");
+		mpi3mr_set_diagsave(mrioc);
+		if (mpi3mr_issue_reset(mrioc,
+		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		    MPI3MR_RESET_FROM_CREATEREQQ_TIMEOUT))
+			mrioc->unrecoverable = 1;
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	    != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc,
+		    "CreateReqQ: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
+		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->init_cmds.ioc_loginfo);
+		retval = -1;
+		goto out_unlock;
+	}
+	op_req_q->qid = req_qid;
+
+out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->init_cmds.mutex);
+out:
+
+	return retval;
+}
+
+/**
+ * mpi3mr_create_op_queues - create operational queue pairs
+ * @mrioc: Adapter instance reference
+ *
+ * Allocate memory for operational queue meta data and call
+ * create request and reply queue functions.
+ *
+ * Return: 0 on success, non-zero on failures.
+ */
+static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
+{
+	int retval = 0;
+	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+
+	num_queues = min_t(int, mrioc->facts.max_op_reply_q,
+	    mrioc->facts.max_op_req_q);
+
+	msix_count_op_q =
+	    mrioc->intr_info_count - mrioc->op_reply_q_offset;
+	if (!mrioc->num_queues)
+		mrioc->num_queues = min_t(int, num_queues, msix_count_op_q);
+	num_queues = mrioc->num_queues;
+	ioc_info(mrioc, "Trying to create %d Operational Q pairs\n",
+	    num_queues);
+
+	if (!mrioc->req_qinfo) {
+		mrioc->req_qinfo = kcalloc(num_queues,
+		    sizeof(struct op_req_qinfo), GFP_KERNEL);
+		if (!mrioc->req_qinfo) {
+			retval = -1;
+			goto out_failed;
+		}
+
+		mrioc->op_reply_qinfo = kzalloc(sizeof(struct op_reply_qinfo) *
+		    num_queues, GFP_KERNEL);
+		if (!mrioc->op_reply_qinfo) {
+			retval = -1;
+			goto out_failed;
+		}
+	}
+
+	if (mrioc->enable_segqueue)
+		ioc_info(mrioc,
+		    "allocating operational queues through segmented queues\n");
+
+	for (i = 0; i < num_queues; i++) {
+		if (mpi3mr_create_op_reply_q(mrioc, i)) {
+			ioc_err(mrioc, "Cannot create OP RepQ %d\n", i);
+			break;
+		}
+		if (mpi3mr_create_op_req_q(mrioc, i,
+		    mrioc->op_reply_qinfo[i].qid)) {
+			ioc_err(mrioc, "Cannot create OP ReqQ %d\n", i);
+			mpi3mr_delete_op_reply_q(mrioc, i);
+			break;
+		}
+	}
+
+	if (i == 0) {
+		/* Not even one queue is created successfully*/
+		retval = -1;
+		goto out_failed;
+	}
+	mrioc->num_op_reply_q = mrioc->num_op_req_q = i;
+	ioc_info(mrioc, "Successfully created %d Operational Q pairs\n",
+	    mrioc->num_op_reply_q);
+
+
+	return retval;
+out_failed:
+	kfree(mrioc->req_qinfo);
+	mrioc->req_qinfo = NULL;
+
+	kfree(mrioc->op_reply_qinfo);
+	mrioc->op_reply_qinfo = NULL;
+
+
+	return retval;
+}
+
 
 /**
  * mpi3mr_setup_admin_qpair - Setup admin queue pair
@@ -1599,6 +2187,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	retval = mpi3mr_create_op_queues(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "Failed to create OpQueues error %d\n",
+		    retval);
+		goto out_failed;
+	}
+
 	return retval;
 
 out_failed:
@@ -1655,6 +2250,12 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		mrioc->reply_free_q_pool = NULL;
 	}
 
+	for (i = 0; i < mrioc->num_op_req_q; i++)
+		mpi3mr_free_op_req_q_segments(mrioc, i);
+
+	for (i = 0; i < mrioc->num_op_reply_q; i++)
+		mpi3mr_free_op_reply_q_segments(mrioc, i);
+
 	for (i = 0; i < mrioc->intr_info_count; i++) {
 		intr_info = mrioc->intr_info + i;
 		if (intr_info)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index c31ec9883152..3cf0be63842f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -41,7 +41,7 @@ static int mpi3mr_map_queues(struct Scsi_Host *shost)
 	struct mpi3mr_ioc *mrioc = shost_priv(shost);
 
 	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-	    mrioc->pdev, 0);
+	    mrioc->pdev, mrioc->op_reply_q_offset);
 }
 
 /**
@@ -220,6 +220,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->sbq_lock);
 
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
+	if (pdev->revision)
+		mrioc->enable_segqueue = true;
 
 	mrioc->logging_level = logging_level;
 	mrioc->shost = shost;
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

--000000000000c7801905b70acf66
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgy6oxWA+9
lEvwQaf9dufwlGvKoQ86LOM4TWNQy2n4KrwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMjI3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAASMVaZW0OOrn0LVHnN97D7DqOMI
SXTAJNR6II5zDDRpxBm/Ix7vQt3AcTvNFx6Os5+PiSjUQWKYB4z7uZJUDbLEr1Jm3x+vORtqVK/B
a0ozC+ZM8710UT43gmyFYZ5+XFXTsZZ196pXK/wRp1eWPolnFFMRkjWrptNtJwXWJBZvjNMTRVdJ
cCx0gPOkIwjb22l+yEaFcGYvwocb3+6cUAZ83KQQZV+Ts2deTSp4DpYEe9Pj2dejb01zzyT8tJ4J
tTysWQgNehBDBoOovc045geavm7m8ZGOuv5GjmMmGyv05/36VOuD3Wy0w0ffqmcWJbdPHOc2j0HU
tQNjWlJSSs8=
--000000000000c7801905b70acf66--
