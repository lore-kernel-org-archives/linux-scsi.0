Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D06CC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhLTOEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhLTOEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:50 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139CEC06173E
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:50 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so4608882pjb.5
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=uRjZU9Adjm4ZAhf9liuk6tPuJxe3CUERdww0c7WxsBw=;
        b=KgtvOnPBirHp24mYJE6vJJLIhWXRzPFPc8tdvrSwOJnriYGdkCvW3ZyhAd3ehqA3Tv
         9l0Y4FsgS4ZmAK65mUfheWRCF6stPKY/lpaOoF/Zox1CTJjG6FD1GmiOOkUcKnuz3wVs
         l+BZC4lxJ50uKiC8H4VCV4er/hPElO+LX11SQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=uRjZU9Adjm4ZAhf9liuk6tPuJxe3CUERdww0c7WxsBw=;
        b=urXe6TmlpqeW0pnzATmaO9Z74vVX6mmBpQ/oLYijg3g3GAkDle40L3rAVmllZi7p41
         qneMA1V31bOt+tY9tQUkFYCNhvRKTh+AWxuIdDNdcIjEiOnryb9OzI6izPhEVjNT6JTH
         gsA6H4j23JCH2tb0V3Rqu/lhbBDZQGhOtbGsd5hrCIT1lcl43g4x7phWD0hrj836fvAk
         pvfS5cwDTB+eK9kx/O2bnn2KqfxUiDlIUejG+3zvTzIjmk5sBc2OjHVuM6EzIa+E/Jwd
         1iP/wLyF2DngprQ8+06VTUyUofmTcpv06A+vIXqLr4OEhGTNbQZ+gJd8vVvQvsuocjP9
         GhuA==
X-Gm-Message-State: AOAM530pwgiAsPHosgM+VRx4TxJvaruG6uRZcGB3BOjSpZ0Mbjvd4CSB
        4shcXVHR+VIS5Ils7x1uDhOkF6aYTVcdatZn3NZXQ3/1SDm0kgj2qrl9UVZvDPeBBpcFq526PFs
        GLDBRWiaFAPSuqhj+gLo00mokZolZC1aFXCbHyB86wQc+8z29FM5VI46H7vKGlO+GbFLDlUxiWG
        W7PGdHAZAJ
X-Google-Smtp-Source: ABdhPJzrnBrmGdMyVP77IeV46w2a+Nh5jco9Py8VtZSaBfTEMcHvs+LyV4FcTSHP9FK/JT0IjaRHBw==
X-Received: by 2002:a17:90b:124f:: with SMTP id gx15mr7931003pjb.28.1640009088847;
        Mon, 20 Dec 2021 06:04:48 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:48 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 21/25] mpi3mr: Add iouring interface support in io-polled mode
Date:   Mon, 20 Dec 2021 19:41:55 +0530
Message-Id: <20211220141159.16117-22-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000035fd7305d3945f6f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000035fd7305d3945f6f
Content-Transfer-Encoding: 8bit

Added support in the driver for Linux iouring interface in
io-polled mode as explained below,

This feature is disabled in the driver by default. To enable the
feature, a module parameter "poll_queues" has to be set with the
desired number of polling queues.

When the feature is enabled, the driver reserves a certain number
of operational queue pairs for the poll_queues either from the
available queue pairs or creates additional queue pairs based on
the operational queue availability.

The Polling queues will have corresponding IRQ and ISR functions
as similar to default queues, However, the IRQ line is disabled
by the driver for poll_queues.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  18 ++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 184 ++++++++++++++++++++++++++------
 drivers/scsi/mpi3mr/mpi3mr_os.c |  46 +++++++-
 3 files changed, 210 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8dd669f..64783a8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -220,6 +220,12 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_FIRMWARE = 27,
 };
 
+/* Queue type definitions */
+enum queue_type {
+	MPI3MR_DEFAULT_QUEUE = 0,
+	MPI3MR_POLL_QUEUE,
+};
+
 /**
  * struct mpi3mr_compimg_ver - replica of component image
  * version defined in mpi30_image.h in host endianness
@@ -331,6 +337,7 @@ struct op_req_qinfo {
  * @pend_ios: Number of IOs pending in HW for this queue
  * @enable_irq_poll: Flag to indicate polling is enabled
  * @in_use: Queue is handled by poll/ISR
+ * @qtype: Type of queue (types defined in enum queue_type)
  */
 struct op_reply_qinfo {
 	u16 ci;
@@ -345,6 +352,7 @@ struct op_reply_qinfo {
 	atomic_t pend_ios;
 	bool enable_irq_poll;
 	atomic_t in_use;
+	enum queue_type qtype;
 };
 
 /**
@@ -703,6 +711,9 @@ struct scmd_priv {
  * @driver_info: Driver, Kernel, OS information to firmware
  * @change_count: Topology change count
  * @op_reply_q_offset: Operational reply queue offset with MSIx
+ * @default_qcount: Total Default queues
+ * @active_poll_qcount: Currently active poll queue count
+ * @requested_poll_qcount: User requested poll queue count
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -839,6 +850,10 @@ struct mpi3mr_ioc {
 	struct mpi3_driver_info_layout driver_info;
 	u16 change_count;
 	u16 op_reply_q_offset;
+
+	u16 default_qcount;
+	u16 active_poll_qcount;
+	u16 requested_poll_qcount;
 };
 
 /**
@@ -940,5 +955,8 @@ void mpi3mr_flush_delayed_cmd_lists(struct mpi3mr_ioc *mrioc);
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc);
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
+int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
+	struct op_reply_qinfo *op_reply_q);
+int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1cbc732..82d9d6b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -16,6 +16,10 @@ static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
 static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data);
 
+static int poll_queues;
+module_param(poll_queues, int, 0444);
+MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
+
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
 {
@@ -461,10 +465,21 @@ mpi3mr_get_reply_desc(struct op_reply_qinfo *op_reply_q, u32 reply_ci)
 	return reply_desc;
 }
 
-static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
-	struct mpi3mr_intr_info *intr_info)
+/**
+ * mpi3mr_process_op_reply_q - Operational reply queue handler
+ * @mrioc: Adapter instance reference
+ * @op_reply_q: Operational reply queue info
+ *
+ * Checks the specific operational reply queue and drains the
+ * reply queue entries until the queue is empty and process the
+ * individual reply descriptors.
+ *
+ * Return: 0 if queue is already processed,or number of reply
+ *	    descriptors processed.
+ */
+int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
+	struct op_reply_qinfo *op_reply_q)
 {
-	struct op_reply_qinfo *op_reply_q = intr_info->op_reply_q;
 	struct op_req_qinfo *op_req_q;
 	u32 exp_phase;
 	u32 reply_ci;
@@ -515,7 +530,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		 * Ensure remaining completion happens from threaded ISR.
 		 */
 		if (num_op_reply > mrioc->max_host_ios) {
-			intr_info->op_reply_q->enable_irq_poll = true;
+			op_reply_q->enable_irq_poll = true;
 			break;
 		}
 
@@ -530,6 +545,34 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	return num_op_reply;
 }
 
+/**
+ * mpi3mr_blk_mq_poll - Operational reply queue handler
+ * @shost: SCSI Host reference
+ * @queue_num: Request queue number (w.r.t OS it is hardware context number)
+ *
+ * Checks the specific operational reply queue and drains the
+ * reply queue entries until the queue is empty and process the
+ * individual reply descriptors.
+ *
+ * Return: 0 if queue is already processed,or number of reply
+ *	    descriptors processed.
+ */
+int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	int num_entries = 0;
+	struct mpi3mr_ioc *mrioc;
+
+	mrioc = (struct mpi3mr_ioc *)shost->hostdata;
+
+	if ((mrioc->reset_in_progress || mrioc->prepare_for_reset))
+		return 0;
+
+	num_entries = mpi3mr_process_op_reply_q(mrioc,
+			&mrioc->op_reply_qinfo[queue_num]);
+
+	return num_entries;
+}
+
 static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
@@ -550,7 +593,8 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 	if (!midx)
 		num_admin_replies = mpi3mr_process_admin_reply_q(mrioc);
 	if (intr_info->op_reply_q)
-		num_op_reply = mpi3mr_process_op_reply_q(mrioc, intr_info);
+		num_op_reply = mpi3mr_process_op_reply_q(mrioc,
+		    intr_info->op_reply_q);
 
 	if (num_admin_replies || num_op_reply)
 		return IRQ_HANDLED;
@@ -621,9 +665,10 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 			mpi3mr_process_admin_reply_q(mrioc);
 		if (intr_info->op_reply_q)
 			num_op_reply +=
-			    mpi3mr_process_op_reply_q(mrioc, intr_info);
+			    mpi3mr_process_op_reply_q(mrioc,
+				intr_info->op_reply_q);
 
-		usleep_range(mrioc->irqpoll_sleep, 10 * mrioc->irqpoll_sleep);
+		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
 
 	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
 	    (num_op_reply < mrioc->max_host_ios));
@@ -667,6 +712,25 @@ static inline int mpi3mr_request_irq(struct mpi3mr_ioc *mrioc, u16 index)
 	return retval;
 }
 
+static void mpi3mr_calc_poll_queues(struct mpi3mr_ioc *mrioc, u16 max_vectors)
+{
+	if (!mrioc->requested_poll_qcount)
+		return;
+
+	/* Reserved for Admin and Default Queue */
+	if (max_vectors > 2 &&
+		(mrioc->requested_poll_qcount < max_vectors - 2)) {
+		ioc_info(mrioc,
+		    "enabled polled queues (%d) msix (%d)\n",
+		    mrioc->requested_poll_qcount, max_vectors);
+	} else {
+		ioc_info(mrioc,
+		    "disabled polled queues (%d) msix (%d) because of no resources for default queue\n",
+		    mrioc->requested_poll_qcount, max_vectors);
+		mrioc->requested_poll_qcount = 0;
+	}
+}
+
 /**
  * mpi3mr_setup_isr - Setup ISR for the controller
  * @mrioc: Adapter instance reference
@@ -679,51 +743,72 @@ static inline int mpi3mr_request_irq(struct mpi3mr_ioc *mrioc, u16 index)
 static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 {
 	unsigned int irq_flags = PCI_IRQ_MSIX;
-	int max_vectors;
+	int max_vectors, min_vec;
 	int retval;
 	int i;
-	struct irq_affinity desc = { .pre_vectors =  1};
+	struct irq_affinity desc = { .pre_vectors =  1, .post_vectors = 1 };
 
 	if (mrioc->is_intr_info_set)
 		return 0;
 
 	mpi3mr_cleanup_isr(mrioc);
 
-	if (setup_one || reset_devices)
+	if (setup_one || reset_devices) {
 		max_vectors = 1;
-	else {
+		retval = pci_alloc_irq_vectors(mrioc->pdev,
+		    1, max_vectors, irq_flags);
+		if (retval < 0) {
+			ioc_err(mrioc, "cannot allocate irq vectors, ret %d\n",
+			    retval);
+			goto out_failed;
+		}
+	} else {
 		max_vectors =
-		    min_t(int, mrioc->cpu_count + 1, mrioc->msix_count);
+		    min_t(int, mrioc->cpu_count + 1 +
+			mrioc->requested_poll_qcount, mrioc->msix_count);
+
+		mpi3mr_calc_poll_queues(mrioc, max_vectors);
 
 		ioc_info(mrioc,
 		    "MSI-X vectors supported: %d, no of cores: %d,",
 		    mrioc->msix_count, mrioc->cpu_count);
 		ioc_info(mrioc,
-		    "MSI-x vectors requested: %d\n", max_vectors);
-	}
+		    "MSI-x vectors requested: %d poll_queues %d\n",
+		    max_vectors, mrioc->requested_poll_qcount);
+
+		desc.post_vectors = mrioc->requested_poll_qcount;
+		min_vec = desc.pre_vectors + desc.post_vectors;
+		irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
+
+		retval = pci_alloc_irq_vectors_affinity(mrioc->pdev,
+			min_vec, max_vectors, irq_flags, &desc);
+
+		if (retval < 0) {
+			ioc_err(mrioc, "cannot allocate irq vectors, ret %d\n",
+			    retval);
+			goto out_failed;
+		}
 
-	irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
 
-	mrioc->op_reply_q_offset = (max_vectors > 1) ? 1 : 0;
-	retval = pci_alloc_irq_vectors_affinity(mrioc->pdev,
-				1, max_vectors, irq_flags, &desc);
-	if (retval < 0) {
-		ioc_err(mrioc, "Cannot alloc irq vectors\n");
-		goto out_failed;
-	}
-	if (retval != max_vectors) {
-		ioc_info(mrioc,
-		    "allocated vectors (%d) are less than configured (%d)\n",
-		    retval, max_vectors);
 		/*
 		 * If only one MSI-x is allocated, then MSI-x 0 will be shared
 		 * between Admin queue and operational queue
 		 */
-		if (retval == 1)
+		if (retval == min_vec)
 			mrioc->op_reply_q_offset = 0;
+		else if (retval != (max_vectors)) {
+			ioc_info(mrioc,
+			    "allocated vectors (%d) are less than configured (%d)\n",
+			    retval, max_vectors);
+		}
 
 		max_vectors = retval;
+		mrioc->op_reply_q_offset = (max_vectors > 1) ? 1 : 0;
+
+		mpi3mr_calc_poll_queues(mrioc, max_vectors);
+
 	}
+
 	mrioc->intr_info = kzalloc(sizeof(struct mpi3mr_intr_info) * max_vectors,
 	    GFP_KERNEL);
 	if (!mrioc->intr_info) {
@@ -1511,10 +1596,11 @@ static void mpi3mr_free_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 static int mpi3mr_delete_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 {
 	struct mpi3_delete_reply_queue_request delq_req;
+	struct op_reply_qinfo *op_reply_q = mrioc->op_reply_qinfo + qidx;
 	int retval = 0;
 	u16 reply_qid = 0, midx;
 
-	reply_qid = mrioc->op_reply_qinfo[qidx].qid;
+	reply_qid = op_reply_q->qid;
 
 	midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, mrioc->op_reply_q_offset);
 
@@ -1524,6 +1610,9 @@ static int mpi3mr_delete_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 		goto out;
 	}
 
+	(op_reply_q->qtype == MPI3MR_DEFAULT_QUEUE) ? mrioc->default_qcount-- :
+	    mrioc->active_poll_qcount--;
+
 	memset(&delq_req, 0, sizeof(delq_req));
 	mutex_lock(&mrioc->init_cmds.mutex);
 	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
@@ -1748,8 +1837,26 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	create_req.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
 	create_req.function = MPI3_FUNCTION_CREATE_REPLY_QUEUE;
 	create_req.queue_id = cpu_to_le16(reply_qid);
-	create_req.flags = MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_ENABLE;
-	create_req.msix_index = cpu_to_le16(mrioc->intr_info[midx].msix_index);
+
+	if (midx < (mrioc->intr_info_count - mrioc->requested_poll_qcount))
+		op_reply_q->qtype = MPI3MR_DEFAULT_QUEUE;
+	else
+		op_reply_q->qtype = MPI3MR_POLL_QUEUE;
+
+	if (op_reply_q->qtype == MPI3MR_DEFAULT_QUEUE) {
+		create_req.flags =
+			MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_ENABLE;
+		create_req.msix_index =
+			cpu_to_le16(mrioc->intr_info[midx].msix_index);
+	} else {
+		create_req.msix_index = cpu_to_le16(mrioc->intr_info_count - 1);
+		ioc_info(mrioc, "create reply queue(polled): for qid(%d), midx(%d)\n",
+			reply_qid, midx);
+		if (!mrioc->active_poll_qcount)
+			disable_irq_nosync(pci_irq_vector(mrioc->pdev,
+			    mrioc->intr_info_count - 1));
+	}
+
 	if (mrioc->enable_segqueue) {
 		create_req.flags |=
 		    MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_SEGMENTED;
@@ -1790,6 +1897,9 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	if (midx < mrioc->intr_info_count)
 		mrioc->intr_info[midx].op_reply_q = op_reply_q;
 
+	(op_reply_q->qtype == MPI3MR_DEFAULT_QUEUE) ? mrioc->default_qcount++ :
+	    mrioc->active_poll_qcount++;
+
 out_unlock:
 	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
 	mutex_unlock(&mrioc->init_cmds.mutex);
@@ -1970,8 +2080,10 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 	mrioc->num_op_reply_q = mrioc->num_op_req_q = i;
-	ioc_info(mrioc, "Successfully created %d Operational Q pairs\n",
-	    mrioc->num_op_reply_q);
+	ioc_info(mrioc,
+	    "successfully created %d operational queue pairs(default/polled) queue = (%d/%d)\n",
+	    mrioc->num_op_reply_q, mrioc->default_qcount,
+	    mrioc->active_poll_qcount);
 
 	return retval;
 out_failed:
@@ -2019,7 +2131,7 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 	if (mpi3mr_check_req_qfull(op_req_q)) {
 		midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(
 		    reply_qidx, mrioc->op_reply_q_offset);
-		mpi3mr_process_op_reply_q(mrioc, &mrioc->intr_info[midx]);
+		mpi3mr_process_op_reply_q(mrioc, mrioc->intr_info[midx].op_reply_q);
 
 		if (mpi3mr_check_req_qfull(op_req_q)) {
 			retval = -EAGAIN;
@@ -3465,6 +3577,10 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)
 	    mrioc->sysif_regs, memap_sz);
 	ioc_info(mrioc, "Number of MSI-X vectors found in capabilities: (%d)\n",
 	    mrioc->msix_count);
+
+	if (!reset_devices && poll_queues > 0)
+		mrioc->requested_poll_qcount = min_t(int, poll_queues,
+				mrioc->msix_count - 2);
 	return retval;
 
 out_failed:
@@ -3826,6 +3942,8 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	u16 i;
 
 	mrioc->change_count = 0;
+	mrioc->active_poll_qcount = 0;
+	mrioc->default_qcount = 0;
 	if (mrioc->admin_req_base)
 		memset(mrioc->admin_req_base, 0, mrioc->admin_req_q_sz);
 	if (mrioc->admin_reply_base)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d893c6d..8bf1b59 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3049,17 +3049,49 @@ static int mpi3mr_bios_param(struct scsi_device *sdev,
  * mpi3mr_map_queues - Map queues callback handler
  * @shost: SCSI host reference
  *
- * Call the blk_mq_pci_map_queues with from which operational
- * queue the mapping has to be done
+ * Maps default and poll queues.
  *
- * Return: return of blk_mq_pci_map_queues
+ * Return: return zero.
  */
 static int mpi3mr_map_queues(struct Scsi_Host *shost)
 {
 	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+	int i, qoff, offset;
+	struct blk_mq_queue_map *map = NULL;
+
+	offset = mrioc->op_reply_q_offset;
+
+	for (i = 0, qoff = 0; i < HCTX_MAX_TYPES; i++) {
+		map = &shost->tag_set.map[i];
+
+		map->nr_queues  = 0;
+
+		if (i == HCTX_TYPE_DEFAULT)
+			map->nr_queues = mrioc->default_qcount;
+		else if (i == HCTX_TYPE_POLL)
+			map->nr_queues = mrioc->active_poll_qcount;
+
+		if (!map->nr_queues) {
+			BUG_ON(i == HCTX_TYPE_DEFAULT);
+			continue;
+		}
+
+		/*
+		 * The poll queue(s) doesn't have an IRQ (and hence IRQ
+		 * affinity), so use the regular blk-mq cpu mapping
+		 */
+		map->queue_offset = qoff;
+		if (i != HCTX_TYPE_POLL)
+			blk_mq_pci_map_queues(map, mrioc->pdev, offset);
+		else
+			blk_mq_map_queues(map);
+
+		qoff += map->nr_queues;
+		offset += map->nr_queues;
+	}
+
+	return 0;
 
-	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-	    mrioc->pdev, mrioc->op_reply_q_offset);
 }
 
 /**
@@ -3873,6 +3905,7 @@ static struct scsi_host_template mpi3mr_driver_template = {
 	.eh_host_reset_handler		= mpi3mr_eh_host_reset,
 	.bios_param			= mpi3mr_bios_param,
 	.map_queues			= mpi3mr_map_queues,
+	.mq_poll                        = mpi3mr_blk_mq_poll,
 	.no_write_same			= 1,
 	.can_queue			= 1,
 	.this_id			= -1,
@@ -4105,6 +4138,9 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	shost->nr_hw_queues = mrioc->num_op_reply_q;
+	if (mrioc->active_poll_qcount)
+		shost->nr_maps = 3;
+
 	shost->can_queue = mrioc->max_host_ios;
 	shost->sg_tablesize = MPI3MR_SG_DEPTH;
 	shost->max_id = mrioc->facts.max_perids + 1;
-- 
2.27.0


--00000000000035fd7305d3945f6f
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEL0aYXswmpUFZlfyqWj
z0b67+cNs+qAtZ3BY+x7NDXTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQ0OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCLvfQb9fUydEoSqB7d36EV2lL8H0AFTvP4oEIL
Gtw3xr+KziU8eZrtZJpjDuzwt9AOVdGVHMSsN2cV4/nHvySQIU29FqHQivPgRUJy02ZDps1HSxdg
NPKpp8GrMrtW22Rxl4v5auaIB3AcOhmKI6DNGyzfkTbVg0fmwhL5+JrEQyN+TM8ZV5RgZpJBkP9j
GDXzQtsZZA/e29B8fpiXGC0lJ0nX1BdJW8EZphl+dLjpFg3H7azZ6U7i96Mm7jx3QibsaofyYltP
noOjd4V5s7VHguRNeeZDRQOCopMYyQEqXNfd82n6OvrSoa8X//CB7r9wOvCYmfB83mtr+zEH+4tD
--00000000000035fd7305d3945f6f--
