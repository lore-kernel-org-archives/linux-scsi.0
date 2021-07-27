Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_NO_TEXT,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB00C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 08:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B49E3611F2
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 08:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhG0IGt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 04:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbhG0IGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 04:06:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E3EC061760
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 01:06:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so3837379pjd.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 01:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=TIAyBdbNZru2P+N/rFunR0ABgdxPoSKQx1shrfBHGos=;
        b=A5Mx14uoMjlQd6kqZy8fZX466vR+8lCJt+blLPQ0o1Cn4+Se2BF6bT41T8B+7y7FpM
         7HhrtSW4+o1pTolopc+Yb0l5GEtovoqefrwwqyluzoPrHpzPoFtqYtvKHKL7J2V+Ww95
         vdAyKj0lgFaaLVSAQD03c7sew/jz+c8TEOU10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=TIAyBdbNZru2P+N/rFunR0ABgdxPoSKQx1shrfBHGos=;
        b=NDN8B9FPqH227NbcKnNoaq65/v/4JzZbFQRsqa6x6hNU09XfpXljyumMuiYuCAnKBi
         Bl5gTrkLTAU9+GPkX+z5IuGPef0GazG3iz2odByeFaS9h9pqUPXYjyg8sGKB6Fw1atyx
         x0ma7BNn3VSQCfi8qEG3bTU22tXI9NaZyBQZP4mYb44fKEgwfpSpymUJAOpqYoM17iNL
         P1YVoSobJXq945Ku9gUrShcQ/tY4RsWRnz454p+sBiWDqgDsxM1t/+eKEeKiO05WLvdA
         UkMPbFtzwqsIudDuYXSoU6mv6pMCF277gjtaHWgxul0RZuW//XQQqwwwWU986Zkwr8Hn
         Tj1A==
X-Gm-Message-State: AOAM531DQgqaAdGmC6ZqXGn+t21T3elTNYGFOyfEM5Aaeds7vIPy0a1b
        QD71S0shXtMo/QaTiwfJKZb+sJOidMe8du3Ee8YItPXVFlxgTwWZDIEy0+cjgXLyEyDYG9kHKbB
        sRyswemX/HknsEKBnsQy2Xy9wPerHZfkn9NZfXMeZ/rogFu5WI7g2ZH5oSPBzKSft0ZIxcjQrJB
        Jlwi59wS87McU=
X-Google-Smtp-Source: ABdhPJzqlfRyVfggU+PbmyPHczzL2jCsGNddYoar+BavtBZHXj34GMs8cFgBQjCREYYZPNGtJRXTDQ==
X-Received: by 2002:a17:90a:7389:: with SMTP id j9mr3023751pjg.27.1627373175012;
        Tue, 27 Jul 2021 01:06:15 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z16sm2562954pgu.21.2021.07.27.01.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 01:06:14 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Add io_uring iopoll support
Date:   Tue, 27 Jul 2021 13:42:12 +0530
Message-Id: <20210727081212.2742-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000f9b0d05c816585c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000000f9b0d05c816585c
Content-Transfer-Encoding: 8bit

Added support of iouring iopoll interface in driver.

Driver will work in non-IRQ mode i.e. There will not
be any msix vector associated for poll_queues and
h/w can still work in this mode. IOC h/w is single
submission queue and multiple reply queue,
but using shared host tagset support it will enable
simulated multiple hw queue.

Driver allocates user provided poll_queue count
number of extra reply queues and
they will be marked as io uring poll_queue.
These poll_queues will not have associated msix vectors.
All the IO completion on this queue will be done from
IOPOLL interface.

This feature can be enabled using module parameter poll_queues.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 243 ++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  23 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  62 +++++--
 3 files changed, 296 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c399552..90dd18a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -116,6 +116,14 @@ MODULE_PARM_DESC(perf_mode,
 	"\t\tdefault - default perf_mode is 'balanced'"
 	);
 
+static int poll_queues;
+module_param(poll_queues, int, 0444);
+MODULE_PARM_DESC(poll_queues, "Number of queues to be use for io_uring poll mode.\n\t\t"
+	"This parameter is effective only if host_tagset_enable=1. &\n\t\t"
+	"when poll_queues are enabled then &\n\t\t"
+	"perf_mode is set to latency mode. &\n\t\t"
+	);
+
 enum mpt3sas_perf_mode {
 	MPT_PERF_MODE_DEFAULT	= -1,
 	MPT_PERF_MODE_BALANCED	= 0,
@@ -709,6 +717,7 @@ _base_fault_reset_work(struct work_struct *work)
 		 * and this call is safe since dead ioc will never return any
 		 * command back from HW.
 		 */
+		mpt3sas_base_pause_mq_polling(ioc);
 		ioc->schedule_dead_ioc_flush_running_cmds(ioc);
 		/*
 		 * Set remove_host flag early since kernel thread will
@@ -744,6 +753,7 @@ _base_fault_reset_work(struct work_struct *work)
 			spin_unlock_irqrestore(
 			    &ioc->ioc_reset_in_progress_lock, flags);
 			mpt3sas_base_mask_interrupts(ioc);
+			mpt3sas_base_pause_mq_polling(ioc);
 			_base_clear_outstanding_commands(ioc);
 		}
 
@@ -1547,6 +1557,53 @@ _base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	return cb_idx;
 }
 
+/**
+ * mpt3sas_base_pause_mq_polling - pause polling on the mq poll queues
+ *				when driver is flushing out the IOs.
+ * @ioc: per adapter object
+ *
+ * Pause polling on the mq poll (io uring) queues when driver is flushing
+ * out the IOs. Otherwise we may see the race condition of completing the same
+ * IO from two paths.
+ *
+ * Returns nothing.
+ */
+void
+mpt3sas_base_pause_mq_polling(struct MPT3SAS_ADAPTER *ioc)
+{
+	int iopoll_q_count =
+	    ioc->reply_queue_count - ioc->iopoll_q_start_index;
+	int qid;
+
+	for (qid = 0; qid < iopoll_q_count; qid++)
+		atomic_set(&ioc->io_uring_poll_queues[qid].pause, 1);
+
+	/*
+	 * wait for current poll to complete.
+	 */
+	for (qid = 0; qid < iopoll_q_count; qid++) {
+		while (atomic_read(&ioc->io_uring_poll_queues[qid].busy))
+			udelay(500);
+	}
+}
+
+/**
+ * mpt3sas_base_resume_mq_polling - Resume polling on mq poll queues.
+ * @ioc: per adapter object
+ *
+ * Returns nothing.
+ */
+void
+mpt3sas_base_resume_mq_polling(struct MPT3SAS_ADAPTER *ioc)
+{
+	int iopoll_q_count =
+	    ioc->reply_queue_count - ioc->iopoll_q_start_index;
+	int qid;
+
+	for (qid = 0; qid < iopoll_q_count; qid++)
+		atomic_set(&ioc->io_uring_poll_queues[qid].pause, 0);
+}
+
 /**
  * mpt3sas_base_mask_interrupts - disable interrupts
  * @ioc: per adapter object
@@ -1722,7 +1779,8 @@ _base_process_reply_queue(struct adapter_reply_queue *reply_q)
 						 MPI2_RPHI_MSIX_INDEX_SHIFT),
 						&ioc->chip->ReplyPostHostIndex);
 			}
-			if (!reply_q->irq_poll_scheduled) {
+			if (!reply_q->is_iouring_poll_q &&
+			    !reply_q->irq_poll_scheduled) {
 				reply_q->irq_poll_scheduled = true;
 				irq_poll_sched(&reply_q->irqpoll);
 			}
@@ -1778,6 +1836,33 @@ _base_process_reply_queue(struct adapter_reply_queue *reply_q)
 	return completed_cmds;
 }
 
+/**
+ * mpt3sas_blk_mq_poll - poll the blk mq poll queue
+ * @shost: Scsi_Host object
+ * @queue_num: hw ctx queue number
+ *
+ * Return number of entries that has been processed from poll queue.
+ */
+int mpt3sas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	struct MPT3SAS_ADAPTER *ioc =
+	    (struct MPT3SAS_ADAPTER *)shost->hostdata;
+	struct adapter_reply_queue *reply_q;
+	int num_entries = 0;
+	int qid = queue_num - ioc->iopoll_q_start_index;
+
+	if (atomic_read(&ioc->io_uring_poll_queues[qid].pause) ||
+	    !atomic_add_unless(&ioc->io_uring_poll_queues[qid].busy, 1, 1))
+		return 0;
+
+	reply_q = ioc->io_uring_poll_queues[qid].reply_q;
+
+	num_entries = _base_process_reply_queue(reply_q);
+	atomic_dec(&ioc->io_uring_poll_queues[qid].busy);
+
+	return num_entries;
+}
+
 /**
  * _base_interrupt - MPT adapter (IOC) specific interrupt handler.
  * @irq: irq number (not used)
@@ -1851,6 +1936,8 @@ _base_init_irqpolls(struct MPT3SAS_ADAPTER *ioc)
 		return;
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
+		if (reply_q->is_iouring_poll_q)
+			continue;
 		irq_poll_init(&reply_q->irqpoll,
 			ioc->hba_queue_depth/4, _base_irqpoll);
 		reply_q->irq_poll_scheduled = false;
@@ -1900,6 +1987,12 @@ mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc, u8 poll)
 		/* TMs are on msix_index == 0 */
 		if (reply_q->msix_index == 0)
 			continue;
+
+		if (reply_q->is_iouring_poll_q) {
+			_base_process_reply_queue(reply_q);
+			continue;
+		}
+
 		synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
 		if (reply_q->irq_poll_scheduled) {
 			/* Calling irq_poll_disable will wait for any pending
@@ -2998,6 +3091,11 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
+		if (reply_q->is_iouring_poll_q) {
+			kfree(reply_q);
+			continue;
+		}
+
 		if (ioc->smp_affinity_enable)
 			irq_set_affinity_hint(pci_irq_vector(ioc->pdev,
 			    reply_q->msix_index), NULL);
@@ -3019,7 +3117,7 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 {
 	struct pci_dev *pdev = ioc->pdev;
 	struct adapter_reply_queue *reply_q;
-	int r;
+	int r, qid;
 
 	reply_q =  kzalloc(sizeof(struct adapter_reply_queue), GFP_KERNEL);
 	if (!reply_q) {
@@ -3031,6 +3129,17 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 	reply_q->msix_index = index;
 
 	atomic_set(&reply_q->busy, 0);
+
+	if (index >= ioc->iopoll_q_start_index) {
+		qid = index - ioc->iopoll_q_start_index;
+		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-mq-poll%d",
+		    ioc->driver_name, ioc->id, qid);
+		reply_q->is_iouring_poll_q = 1;
+		ioc->io_uring_poll_queues[qid].reply_q = reply_q;
+		goto out;
+	}
+
+
 	if (ioc->msix_enable)
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
 		    ioc->driver_name, ioc->id, index);
@@ -3045,7 +3154,7 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 		kfree(reply_q);
 		return -EBUSY;
 	}
-
+out:
 	INIT_LIST_HEAD(&reply_q->list);
 	list_add_tail(&reply_q->list, &ioc->reply_queue_list);
 	return 0;
@@ -3066,6 +3175,8 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 	unsigned int cpu, nr_cpus, nr_msix, index = 0;
 	struct adapter_reply_queue *reply_q;
 	int local_numa_node;
+	int iopoll_q_count = ioc->reply_queue_count -
+	    ioc->iopoll_q_start_index;
 
 	if (!_base_is_controller_msix_enabled(ioc))
 		return;
@@ -3099,7 +3210,8 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 		list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
 			const cpumask_t *mask;
 
-			if (reply_q->msix_index < ioc->high_iops_queues)
+			if (reply_q->msix_index < ioc->high_iops_queues ||
+			    reply_q->msix_index >= ioc->iopoll_q_start_index)
 				continue;
 
 			mask = pci_irq_get_affinity(ioc->pdev,
@@ -3121,13 +3233,14 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 
 fall_back:
 	cpu = cpumask_first(cpu_online_mask);
-	nr_msix -= ioc->high_iops_queues;
+	nr_msix -= (ioc->high_iops_queues - iopoll_q_count);
 	index = 0;
 
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
 		unsigned int i, group = nr_cpus / nr_msix;
 
-		if (reply_q->msix_index < ioc->high_iops_queues)
+		if (reply_q->msix_index < ioc->high_iops_queues ||
+		    reply_q->msix_index >= ioc->iopoll_q_start_index)
 			continue;
 
 		if (cpu >= nr_cpus)
@@ -3164,8 +3277,12 @@ _base_check_and_enable_high_iops_queues(struct MPT3SAS_ADAPTER *ioc,
 {
 	u16 lnksta, speed;
 
+	/*
+	 * Disable high iops queues if io uring poll queues are enabled.
+	 */
 	if (perf_mode == MPT_PERF_MODE_IOPS ||
-	    perf_mode == MPT_PERF_MODE_LATENCY) {
+	    perf_mode == MPT_PERF_MODE_LATENCY ||
+	    ioc->io_uring_poll_queues) {
 		ioc->high_iops_queues = 0;
 		return;
 	}
@@ -3202,6 +3319,7 @@ _base_disable_msix(struct MPT3SAS_ADAPTER *ioc)
 		return;
 	pci_free_irq_vectors(ioc->pdev);
 	ioc->msix_enable = 0;
+	kfree(ioc->io_uring_poll_queues);
 }
 
 /**
@@ -3215,18 +3333,24 @@ _base_alloc_irq_vectors(struct MPT3SAS_ADAPTER *ioc)
 	int i, irq_flags = PCI_IRQ_MSIX;
 	struct irq_affinity desc = { .pre_vectors = ioc->high_iops_queues };
 	struct irq_affinity *descp = &desc;
+	/*
+	 * Don't allocate msix vectors for poll_queues.
+	 * msix_vectors is always within a range of FW supported reply queue.
+	 */
+	int nr_msix_vectors = ioc->iopoll_q_start_index;
+
 
 	if (ioc->smp_affinity_enable)
-		irq_flags |= PCI_IRQ_AFFINITY;
+		irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
 	else
 		descp = NULL;
 
-	ioc_info(ioc, " %d %d\n", ioc->high_iops_queues,
-	    ioc->reply_queue_count);
+	ioc_info(ioc, " %d %d %d\n", ioc->high_iops_queues,
+	    ioc->reply_queue_count, nr_msix_vectors);
 
 	i = pci_alloc_irq_vectors_affinity(ioc->pdev,
 	    ioc->high_iops_queues,
-	    ioc->reply_queue_count, irq_flags, descp);
+	    nr_msix_vectors, irq_flags, descp);
 
 	return i;
 }
@@ -3242,6 +3366,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	int r;
 	int i, local_max_msix_vectors;
 	u8 try_msix = 0;
+	int iopoll_q_count = 0;
 
 	ioc->msix_load_balance = false;
 
@@ -3257,22 +3382,16 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	ioc_info(ioc, "MSI-X vectors supported: %d\n", ioc->msix_vector_count);
 	pr_info("\t no of cores: %d, max_msix_vectors: %d\n",
 		ioc->cpu_count, max_msix_vectors);
-	if (ioc->is_aero_ioc)
-		_base_check_and_enable_high_iops_queues(ioc,
-			ioc->msix_vector_count);
+
 	ioc->reply_queue_count =
-		min_t(int, ioc->cpu_count + ioc->high_iops_queues,
-		ioc->msix_vector_count);
+		min_t(int, ioc->cpu_count, ioc->msix_vector_count);
 
 	if (!ioc->rdpq_array_enable && max_msix_vectors == -1)
 		local_max_msix_vectors = (reset_devices) ? 1 : 8;
 	else
 		local_max_msix_vectors = max_msix_vectors;
 
-	if (local_max_msix_vectors > 0)
-		ioc->reply_queue_count = min_t(int, local_max_msix_vectors,
-			ioc->reply_queue_count);
-	else if (local_max_msix_vectors == 0)
+	if (local_max_msix_vectors == 0)
 		goto try_ioapic;
 
 	/*
@@ -3293,14 +3412,77 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->msix_load_balance)
 		ioc->smp_affinity_enable = 0;
 
+	if (!ioc->smp_affinity_enable || ioc->reply_queue_count <= 1)
+		ioc->shost->host_tagset = 0;
+
+	/*
+	 * Enable io uring poll queues only if host_tagset is enabled.
+	 */
+	if (ioc->shost->host_tagset)
+		iopoll_q_count = poll_queues;
+
+	if (iopoll_q_count) {
+		ioc->io_uring_poll_queues = kcalloc(iopoll_q_count,
+		    sizeof(struct io_uring_poll_queue), GFP_KERNEL);
+		if (!ioc->io_uring_poll_queues)
+			iopoll_q_count = 0;
+	}
+
+	if (ioc->is_aero_ioc)
+		_base_check_and_enable_high_iops_queues(ioc,
+		    ioc->msix_vector_count);
+
+	/*
+	 * Add high iops queues count to reply queue count if high iops queues
+	 * are enabled.
+	 */
+	ioc->reply_queue_count = min_t(int,
+	    ioc->reply_queue_count + ioc->high_iops_queues,
+	    ioc->msix_vector_count);
+
+	/*
+	 * Adjust the reply queue count incase reply queue count
+	 * exceeds the user provided MSIx vectors count.
+	 */
+	if (local_max_msix_vectors > 0)
+		ioc->reply_queue_count = min_t(int, local_max_msix_vectors,
+		    ioc->reply_queue_count);
+	/*
+	 * Add io uring poll queues count to reply queues count
+	 * if io uring is enabled in driver.
+	 */
+	if (iopoll_q_count) {
+		if (ioc->reply_queue_count < (iopoll_q_count + MPT3_MIN_IRQS))
+			iopoll_q_count = 0;
+		ioc->reply_queue_count = min_t(int,
+		    ioc->reply_queue_count + iopoll_q_count,
+		    ioc->msix_vector_count);
+	}
+
+	/*
+	 * Starting index of io uring poll queues in reply queue list.
+	 */
+	ioc->iopoll_q_start_index =
+	    ioc->reply_queue_count - iopoll_q_count;
+
 	r = _base_alloc_irq_vectors(ioc);
 	if (r < 0) {
 		ioc_info(ioc, "pci_alloc_irq_vectors failed (r=%d) !!!\n", r);
 		goto try_ioapic;
 	}
 
+	/*
+	 * Adjust the reply queue count if the allocated
+	 * MSIx vectors is less then the requested number
+	 * of MSIx vectors.
+	 */
+	if (r < ioc->iopoll_q_start_index) {
+		ioc->reply_queue_count = r + iopoll_q_count;
+		ioc->iopoll_q_start_index =
+		    ioc->reply_queue_count - iopoll_q_count;
+	}
+
 	ioc->msix_enable = 1;
-	ioc->reply_queue_count = r;
 	for (i = 0; i < ioc->reply_queue_count; i++) {
 		r = _base_request_irq(ioc, i);
 		if (r) {
@@ -3320,6 +3502,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	ioc->high_iops_queues = 0;
 	ioc_info(ioc, "High IOPs queues : disabled\n");
 	ioc->reply_queue_count = 1;
+	ioc->iopoll_q_start_index = ioc->reply_queue_count - 0;
 	r = pci_alloc_irq_vectors(ioc->pdev, 1, 1, PCI_IRQ_LEGACY);
 	if (r < 0) {
 		dfailprintk(ioc,
@@ -3416,6 +3599,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	u64 pio_chip = 0;
 	phys_addr_t chip_phys = 0;
 	struct adapter_reply_queue *reply_q;
+	int iopoll_q_count = 0;
 
 	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
@@ -3489,6 +3673,12 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	if (r)
 		goto out_fail;
 
+	iopoll_q_count = ioc->reply_queue_count - ioc->iopoll_q_start_index;
+	for (i = 0; i < iopoll_q_count; i++) {
+		atomic_set(&ioc->io_uring_poll_queues[i].busy, 0);
+		atomic_set(&ioc->io_uring_poll_queues[i].pause, 0);
+	}
+
 	if (!ioc->is_driver_loading)
 		_base_init_irqpolls(ioc);
 	/* Use the Combined reply queue feature only for SAS3 C0 & higher
@@ -3530,11 +3720,18 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 			* 4)));
 	}
 
-	list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+		if (reply_q->msix_index >= ioc->iopoll_q_start_index) {
+			pr_info("%s: enabled: index: %d\n",
+			    reply_q->name, reply_q->msix_index);
+			continue;
+		}
+
 		pr_info("%s: %s enabled: IRQ %d\n",
 			reply_q->name,
 			ioc->msix_enable ? "PCI-MSI-X" : "IO-APIC",
 			pci_irq_vector(ioc->pdev, reply_q->msix_index));
+	}
 
 	ioc_info(ioc, "iomem(%pap), mapped(0x%p), size(%d)\n",
 		 &chip_phys, ioc->chip, memap_sz);
@@ -8471,6 +8668,7 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	_base_pre_reset_handler(ioc);
 	mpt3sas_wait_for_commands_to_complete(ioc);
 	mpt3sas_base_mask_interrupts(ioc);
+	mpt3sas_base_pause_mq_polling(ioc);
 	r = _base_make_ioc_ready(ioc, type);
 	if (r)
 		goto out;
@@ -8512,6 +8710,7 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	ioc->ioc_reset_count++;
 	mutex_unlock(&ioc->reset_in_progress_mutex);
+	mpt3sas_base_resume_mq_polling(ioc);
 
  out_unlocked:
 	if ((r == 0) && is_trigger) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d4834c8..ee74279 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -354,6 +354,7 @@ struct mpt3sas_nvme_cmd {
 #define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT_G3	12
 #define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT_G35	16
 #define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET	(0x10)
+#define MPT3_MIN_IRQS					1
 
 /* OEM Identifiers */
 #define MFG10_OEM_ID_INVALID                   (0x00000000)
@@ -936,6 +937,8 @@ struct _event_ack_list {
  * @os_irq: irq number
  * @irqpoll: irq_poll object
  * @irq_poll_scheduled: Tells whether irq poll is scheduled or not
+ * @is_iouring_poll_q: Tells whether reply queues is assigned
+ *			to io uring poll queues or not
  * @list: this list
 */
 struct adapter_reply_queue {
@@ -949,9 +952,22 @@ struct adapter_reply_queue {
 	struct irq_poll         irqpoll;
 	bool			irq_poll_scheduled;
 	bool			irq_line_enable;
+	bool			is_iouring_poll_q;
 	struct list_head	list;
 };
 
+/**
+ * struct io_uring_poll_queue - the io uring poll queue structure
+ * @busy: Tells whether io uring poll queue is busy or not
+ * @pause: Tells whether IOs are paused on io uring poll queue or not
+ * @reply_q: reply queue mapped for io uring poll queue
+ */
+struct io_uring_poll_queue {
+	atomic_t	busy;
+	atomic_t	pause;
+	struct adapter_reply_queue *reply_q;
+};
+
 typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
 
 /* SAS3.0 support */
@@ -1176,6 +1192,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @schedule_dead_ioc_flush_running_cmds: callback to flush pending commands
  * @thresh_hold: Max number of reply descriptors processed
  *				before updating Host Index
+ * @iopoll_q_start_index: starting index of io uring poll queues
+ *				in reply queue list
  * @drv_internal_flags: Bit map internal to driver
  * @drv_support_bitmap: driver's supported feature bit map
  * @use_32bit_dma: Flag to use 32 bit consistent dma mask
@@ -1372,11 +1390,13 @@ struct MPT3SAS_ADAPTER {
 	bool            msix_load_balance;
 	u16		thresh_hold;
 	u8		high_iops_queues;
+	u8		iopoll_q_start_index;
 	u32             drv_internal_flags;
 	u32		drv_support_bitmap;
 	u32             dma_mask;
 	bool		enable_sdev_max_qd;
 	bool		use_32bit_dma;
+	struct io_uring_poll_queue *io_uring_poll_queues;
 
 	/* internal commands, callback index */
 	u8		scsi_io_cb_idx;
@@ -1730,6 +1750,9 @@ do {	ioc_err(ioc, "In func: %s\n", __func__); \
 	status, mpi_request, sz); } while (0)
 
 int mpt3sas_wait_for_ioc(struct MPT3SAS_ADAPTER *ioc, int wait_count);
+int mpt3sas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
+void mpt3sas_base_pause_mq_polling(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_base_resume_mq_polling(struct MPT3SAS_ADAPTER *ioc);
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 866d118..f15c809 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11178,8 +11178,10 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	if (!pci_device_is_present(pdev))
+	if (!pci_device_is_present(pdev)) {
+		mpt3sas_base_pause_mq_polling(ioc);
 		_scsih_flush_running_cmds(ioc);
+	}
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
@@ -11274,8 +11276,10 @@ scsih_shutdown(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	if (!pci_device_is_present(pdev))
+	if (!pci_device_is_present(pdev)) {
+		mpt3sas_base_pause_mq_polling(ioc);
 		_scsih_flush_running_cmds(ioc);
+	}
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
@@ -11780,12 +11784,41 @@ static int scsih_map_queues(struct Scsi_Host *shost)
 {
 	struct MPT3SAS_ADAPTER *ioc =
 	    (struct MPT3SAS_ADAPTER *)shost->hostdata;
+	struct blk_mq_queue_map *map;
+	int i, qoff, offset;
+	int nr_msix_vectors = ioc->iopoll_q_start_index;
+	int iopoll_q_count = ioc->reply_queue_count - nr_msix_vectors;
 
-	if (ioc->shost->nr_hw_queues == 1)
+	if (shost->nr_hw_queues == 1)
 		return 0;
 
-	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-	    ioc->pdev, ioc->high_iops_queues);
+	for (i = 0, qoff = 0; i < shost->nr_maps; i++) {
+		map = &shost->tag_set.map[i];
+		map->nr_queues = 0;
+		offset = 0;
+		if (i == HCTX_TYPE_DEFAULT) {
+			map->nr_queues =
+			    nr_msix_vectors - ioc->high_iops_queues;
+			offset = ioc->high_iops_queues;
+		} else if (i == HCTX_TYPE_POLL)
+			map->nr_queues = iopoll_q_count;
+
+		if (!map->nr_queues)
+			BUG_ON(i == HCTX_TYPE_DEFAULT);
+
+		/*
+		 * The poll queue(s) doesn't have an IRQ (and hence IRQ
+		 * affinity), so use the regular blk-mq cpu mapping
+		 */
+		map->queue_offset = qoff;
+		if (i != HCTX_TYPE_POLL)
+			blk_mq_pci_map_queues(map, ioc->pdev, offset);
+		else
+			blk_mq_map_queues(map);
+
+		qoff += map->nr_queues;
+	}
+	return 0;
 }
 
 /* shost template for SAS 2.0 HBA devices */
@@ -11856,6 +11889,7 @@ static struct scsi_host_template mpt3sas_driver_template = {
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct scsiio_tracker),
 	.map_queues			= scsih_map_queues,
+	.mq_poll			= mpt3sas_blk_mq_poll,
 };
 
 /* raid transport support for SAS 3.0 HBA devices */
@@ -11952,6 +11986,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *shost = NULL;
 	int rv;
 	u16 hba_mpi_version;
+	int iopoll_q_count = 0;
 
 	/* Determine in which MPI version class this pci device belongs */
 	hba_mpi_version = _scsih_determine_hba_mpi_version(pdev);
@@ -12199,6 +12234,11 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_thread_fail;
 	}
 
+	shost->host_tagset = 0;
+
+	if (ioc->is_gen35_ioc && host_tagset_enable)
+		shost->host_tagset = 1;
+
 	ioc->is_driver_loading = 1;
 	if ((mpt3sas_base_attach(ioc))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -12221,16 +12261,17 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	} else
 		ioc->hide_drives = 0;
 
-	shost->host_tagset = 0;
 	shost->nr_hw_queues = 1;
 
-	if (ioc->is_gen35_ioc && ioc->reply_queue_count > 1 &&
-	    host_tagset_enable && ioc->smp_affinity_enable) {
-
-		shost->host_tagset = 1;
+	if (shost->host_tagset) {
 		shost->nr_hw_queues =
 		    ioc->reply_queue_count - ioc->high_iops_queues;
 
+		iopoll_q_count =
+		    ioc->reply_queue_count - ioc->iopoll_q_start_index;
+
+		shost->nr_maps = iopoll_q_count ? 3 : 1;
+
 		dev_info(&ioc->pdev->dev,
 		    "Max SCSIIO MPT commands: %d shared with nr_hw_queues = %d\n",
 		    shost->can_queue, shost->nr_hw_queues);
@@ -12354,6 +12395,7 @@ scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		/* Permanent error, prepare for device removal */
 		ioc->pci_error_recovery = 1;
 		mpt3sas_base_stop_watchdog(ioc);
+		mpt3sas_base_pause_mq_polling(ioc);
 		_scsih_flush_running_cmds(ioc);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
-- 
2.27.0


--0000000000000f9b0d05c816585c
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIH3R4R+62wbbTT9jxDyD
oml0RNpe6jgZS2f7IRDIkG7oMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMDcyNzA4MDYxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCb24ioinik3V32Ji0XPq3HJe8C8IYCrorUSEcO
s8kNKh/fuxlGw+gRgSV1T719IBA3tPaXY9v4kxRBET5Ug8S4nQkOTYX6gkW3yTvtiVY1wnh2bTQJ
oJ4zF2Uj7UBCgIUM84Tu6Q1UdvOnPUbFh4e0Kz89PHKeK6oFZ+nCnuWmNmKvtIkBNVh+t/c/FDLt
ukzseHjNpOFUAzKioGHNoNvQUoR8GNe/xdGB+ZpxK0rXujCjXE0l0A61UpBjxiJZdfybqvStVrHJ
F1aaUcsaQGJEGwHrjpHrZuRzDNfOjt4e2/Hb6EnsajOkaShCiUUmoBnjCmKFfjgGx8xFi7rUV2Mm
--0000000000000f9b0d05c816585c--
