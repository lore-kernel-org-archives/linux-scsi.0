Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3478CA9EBD
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A27A1205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aldZMa3e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436628AbfJWV4q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39806 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436618AbfJWV4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id a11so7625191wra.6
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TXGFPKIio4tf6XyvJWdetXU4hrvbG9o0xyZyPmbeXw0=;
        b=aldZMa3ewTZwi/xDarOOuRSQn/CRv4RJTRP61uLO7D47waNfnu/Vu1jF6Qtj8CCoqV
         1jTpkHTqwx9cpwD3bOt5/RSQdUIeBQy/OYycsHI2o+Ph8YPlBpeQyMYIx4gBSVwXf6mx
         mN2r020TrUnEFnO3JPgJYmtTxwNvAku8l1gleya+GL2ung53IvB1eyaku07zCyd/LLUi
         Un5mgI79ivPCrtd3vKnLKV2skrFgPia5fuD4bAi7RvIqRegWJkXlSFCgi0x0C0/X1GOD
         68KpPVyfUkRgW4fICvyICCR0qB+S2/j127rSyhP8wxXspB4RXgqzMz3D4CR56Hs0oKi8
         xNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TXGFPKIio4tf6XyvJWdetXU4hrvbG9o0xyZyPmbeXw0=;
        b=U2qZI2wcg/3ARMs5rVT+DSilSpL82JkNKIYRTaWzbNgbg4Oowvlk4tOTh/A//Q5eyn
         3UicMJENz6qP3nVWWQbK7pQdeGhRMaj2LhF4mmIRK6XipgXNvXVoggAeLcAu8WQVBxep
         aT2F05yFz14KvvOrcP+/2Oh59LPMlfkruq9ZEVM+04zEHyerxqa27XUSLAEah/+xy5hD
         hggZ5Me2Gvq6tIcmM4nkCQDvEY+yYCSmh2IIawKXvbYKei8u+3i7ACHdRtfryZf+dGA/
         OQYgIjYGJXqkILVpgsqhkhXp9A6axSLY5XK5ML73LDvA0Psle3e6MpcqDp8wqTBsyd+G
         Qhww==
X-Gm-Message-State: APjAAAU0JDJfYeTutCJ7UWaF2HC/ws3pJZohvOS0yiDEcCZY+5o8q/U4
        N53EUiRKcnxS1K72s1BAu5ytgfJa
X-Google-Smtp-Source: APXvYqwtfFAmcjqT1dPE5GCHEpCcrfeeKTqzbdvkuD4rj0dBIFOUvHzrBsIa4ALU5oiLigpVGZurFw==
X-Received: by 2002:adf:fd88:: with SMTP id d8mr743404wrr.200.1571867799917;
        Wed, 23 Oct 2019 14:56:39 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:39 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 20/32] elx: efct: Hardware queues processing
Date:   Wed, 23 Oct 2019 14:55:45 -0700
Message-Id: <20191023215557.12581-21-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines for EQ, CQ, WQ and RQ processing.
Routines for IO object pool allocation and deallocation.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c        | 628 +++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h        |  36 ++
 drivers/scsi/elx/efct/efct_hw_queues.c | 247 +++++++++++++
 drivers/scsi/elx/efct/efct_io.c        | 288 +++++++++++++++
 drivers/scsi/elx/efct/efct_io.h        | 219 ++++++++++++
 5 files changed, 1418 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_io.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.h

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index ae0f49e5d751..aab66f5d7908 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -49,6 +49,14 @@ efct_hw_config_sli_port_health_check(struct efct_hw_s *hw, u8 query,
 				     u8 enable);
 static enum efct_hw_rtn_e
 efct_hw_set_dif_seed(struct efct_hw_s *hw);
+static void
+efct_hw_queue_hash_add(struct efct_queue_hash_s *, u16, u16);
+static int
+efct_hw_flush(struct efct_hw_s *);
+static void
+efct_hw_wq_process_io(void *arg, u8 *cqe, int status);
+static void
+efct_hw_wq_process_abort(void *arg, u8 *cqe, int status);
 
 static enum efct_hw_rtn_e
 efct_hw_link_event_init(struct efct_hw_s *hw)
@@ -3273,3 +3281,623 @@ efct_hw_config_set_fdt_xfer_hint(struct efct_hw_s *hw, u32 fdt_xfer_hint)
 
 	return rc;
 }
+
+static u8 efct_hw_iotype_is_originator(u16 io_type)
+{
+	switch (io_type) {
+	case EFCT_HW_FC_CT:
+	case EFCT_HW_ELS_REQ:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/**
+ * @brief Update the queue hash with the ID and index.
+ *
+ * @param hash Pointer to hash table.
+ * @param id ID that was created.
+ * @param index The index into the hash object.
+ */
+static void
+efct_hw_queue_hash_add(struct efct_queue_hash_s *hash,
+		       u16 id, u16 index)
+{
+	u32	hash_index = id & (EFCT_HW_Q_HASH_SIZE - 1);
+
+	/*
+	 * Since the hash is always bigger than the number of queues, then we
+	 * never have to worry about an infinite loop.
+	 */
+	while (hash[hash_index].in_use)
+		hash_index = (hash_index + 1) & (EFCT_HW_Q_HASH_SIZE - 1);
+
+	/* not used, claim the entry */
+	hash[hash_index].id = id;
+	hash[hash_index].in_use = true;
+	hash[hash_index].index = index;
+}
+
+/**
+ * @brief Find index given queue ID.
+ *
+ * @param hash Pointer to hash table.
+ * @param id ID to find.
+ *
+ * @return Returns the index into the HW cq array or -1 if not found.
+ */
+int
+efct_hw_queue_hash_find(struct efct_queue_hash_s *hash, u16 id)
+{
+	int	rc = -1;
+	int	index = id & (EFCT_HW_Q_HASH_SIZE - 1);
+
+	/*
+	 * Since the hash is always bigger than the maximum number of Qs, then
+	 * we never have to worry about an infinite loop. We will always find
+	 * an unused entry.
+	 */
+	do {
+		if (hash[index].in_use &&
+		    hash[index].id == id)
+			rc = hash[index].index;
+		else
+			index = (index + 1) & (EFCT_HW_Q_HASH_SIZE - 1);
+	} while (rc == -1 && hash[index].in_use);
+
+	return rc;
+}
+
+int
+efct_hw_process(struct efct_hw_s *hw, u32 vector,
+		u32 max_isr_time_msec)
+{
+	struct hw_eq_s *eq;
+	int rc = 0;
+
+	/*
+	 * The caller should disable interrupts if they wish to prevent us
+	 * from processing during a shutdown. The following states are defined:
+	 *   EFCT_HW_STATE_UNINITIALIZED - No queues allocated
+	 *   EFCT_HW_STATE_QUEUES_ALLOCATED - The state after a chip reset,
+	 *                                    queues are cleared.
+	 *   EFCT_HW_STATE_ACTIVE - Chip and queues are operational
+	 *   EFCT_HW_STATE_RESET_IN_PROGRESS - reset, we still want completions
+	 *   EFCT_HW_STATE_TEARDOWN_IN_PROGRESS - We still want mailbox
+	 *                                        completions.
+	 */
+	if (hw->state == EFCT_HW_STATE_UNINITIALIZED)
+		return 0;
+
+	/* Get pointer to struct hw_eq_s */
+	eq = hw->hw_eq[vector];
+	if (!eq)
+		return 0;
+
+	eq->use_count++;
+
+	rc = efct_hw_eq_process(hw, eq, max_isr_time_msec);
+
+	return rc;
+}
+
+/**
+ * @ingroup interrupt
+ * @brief Process events associated with an EQ.
+ *
+ * @par Description
+ * Loop termination:
+ * @n @n Without a mechanism to terminate the completion processing loop, it
+ * is possible under some workload conditions for the loop to never terminate
+ * (or at least take longer than the OS is happy to have an interrupt handler
+ * or kernel thread context hold a CPU without yielding).
+ * @n @n The approach taken here is to periodically check how much time
+ * we have been in this
+ * processing loop, and if we exceed a predetermined time (multiple seconds),
+ * the loop is terminated, and efct_hw_process() returns.
+ *
+ * @param hw Hardware context.
+ * @param eq Pointer to HW EQ object.
+ * @param max_isr_time_msec Maximum time in msec to stay in this function.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+efct_hw_eq_process(struct efct_hw_s *hw, struct hw_eq_s *eq,
+		   u32 max_isr_time_msec)
+{
+	u8		eqe[sizeof(struct sli4_eqe_s)] = { 0 };
+	u32	tcheck_count;
+	time_t		tstart;
+	time_t		telapsed;
+	bool		done = false;
+
+	tcheck_count = EFCT_HW_TIMECHECK_ITERATIONS;
+	tstart = jiffies_to_msecs(jiffies);
+
+	while (!done && !sli_eq_read(&hw->sli, eq->queue, eqe)) {
+		u16	cq_id = 0;
+		int		rc;
+
+		rc = sli_eq_parse(&hw->sli, eqe, &cq_id);
+		if (unlikely(rc)) {
+			if (rc > 0) {
+				u32 i;
+
+				/*
+				 * Received a sentinel EQE indicating the
+				 * EQ is full. Process all CQs
+				 */
+				for (i = 0; i < hw->cq_count; i++)
+					efct_hw_cq_process(hw, hw->hw_cq[i]);
+				continue;
+			} else {
+				return rc;
+			}
+		} else {
+			int index;
+
+			index  = efct_hw_queue_hash_find(hw->cq_hash, cq_id);
+
+			if (likely(index >= 0))
+				efct_hw_cq_process(hw, hw->hw_cq[index]);
+			else
+				efc_log_err(hw->os, "bad CQ_ID %#06x\n",
+					     cq_id);
+		}
+
+		if (eq->queue->n_posted > eq->queue->posted_limit)
+			sli_queue_arm(&hw->sli, eq->queue, false);
+
+		if (tcheck_count && (--tcheck_count == 0)) {
+			tcheck_count = EFCT_HW_TIMECHECK_ITERATIONS;
+			telapsed = jiffies_to_msecs(jiffies) - tstart;
+			if (telapsed >= max_isr_time_msec)
+				done = true;
+		}
+	}
+	sli_queue_eq_arm(&hw->sli, eq->queue, true);
+
+	return 0;
+}
+
+/**
+ * @brief Process entries on the given completion queue.
+ *
+ * @param hw Hardware context.
+ * @param cq Pointer to the HW completion queue object.
+ *
+ * @return None.
+ */
+void
+efct_hw_cq_process(struct efct_hw_s *hw, struct hw_cq_s *cq)
+{
+	u8		cqe[sizeof(struct sli4_mcqe_s)];
+	u16	rid = U16_MAX;
+	enum sli4_qentry_e	ctype;		/* completion type */
+	int		status;
+	u32	n_processed = 0;
+	u32	tstart, telapsed;
+
+	tstart = jiffies_to_msecs(jiffies);
+
+	while (!sli_cq_read(&hw->sli, cq->queue, cqe)) {
+		status = sli_cq_parse(&hw->sli, cq->queue,
+				      cqe, &ctype, &rid);
+		/*
+		 * The sign of status is significant. If status is:
+		 * == 0 : call completed correctly and
+		 * the CQE indicated success
+		 * > 0 : call completed correctly and
+		 * the CQE indicated an error
+		 * < 0 : call failed and no information is available about the
+		 * CQE
+		 */
+		if (status < 0) {
+			if (status == -2)
+				/*
+				 * Notification that an entry was consumed,
+				 * but not completed
+				 */
+				continue;
+
+			break;
+		}
+
+		switch (ctype) {
+		case SLI_QENTRY_ASYNC:
+			sli_cqe_async(&hw->sli, cqe);
+			break;
+		case SLI_QENTRY_MQ:
+			/*
+			 * Process MQ entry. Note there is no way to determine
+			 * the MQ_ID from the completion entry.
+			 */
+			efct_hw_mq_process(hw, status, hw->mq);
+			break;
+		case SLI_QENTRY_WQ:
+			efct_hw_wq_process(hw, cq, cqe, status, rid);
+			break;
+		case SLI_QENTRY_WQ_RELEASE: {
+			u32 wq_id = rid;
+			int index;
+			struct hw_wq_s *wq = NULL;
+
+			index = efct_hw_queue_hash_find(hw->wq_hash, wq_id);
+
+			if (likely(index >= 0)) {
+				wq = hw->hw_wq[index];
+			} else {
+				efc_log_err(hw->os, "bad WQ_ID %#06x\n", wq_id);
+				break;
+			}
+			/* Submit any HW IOs that are on the WQ pending list */
+			hw_wq_submit_pending(wq, wq->wqec_set_count);
+
+			break;
+		}
+
+		case SLI_QENTRY_RQ:
+			efct_hw_rqpair_process_rq(hw, cq, cqe);
+			break;
+		case SLI_QENTRY_XABT: {
+			efct_hw_xabt_process(hw, cq, cqe, rid);
+			break;
+		}
+		default:
+			efc_log_test(hw->os,
+				      "unhandled ctype=%#x rid=%#x\n",
+				     ctype, rid);
+			break;
+		}
+
+		n_processed++;
+		if (n_processed == cq->queue->proc_limit)
+			break;
+
+		if (cq->queue->n_posted >= cq->queue->posted_limit)
+			sli_queue_arm(&hw->sli, cq->queue, false);
+	}
+
+	sli_queue_arm(&hw->sli, cq->queue, true);
+
+	if (n_processed > cq->queue->max_num_processed)
+		cq->queue->max_num_processed = n_processed;
+	telapsed = jiffies_to_msecs(jiffies) - tstart;
+	if (telapsed > cq->queue->max_process_time)
+		cq->queue->max_process_time = telapsed;
+}
+
+/**
+ * @brief Process WQ completion queue entries.
+ *
+ * @param hw Hardware context.
+ * @param cq Pointer to the HW completion queue object.
+ * @param cqe Pointer to WQ completion queue.
+ * @param status Completion status.
+ * @param rid Resource ID (IO tag).
+ *
+ * @return none
+ */
+void
+efct_hw_wq_process(struct efct_hw_s *hw, struct hw_cq_s *cq,
+		   u8 *cqe, int status, u16 rid)
+{
+	struct hw_wq_callback_s *wqcb;
+
+	if (rid == EFCT_HW_REQUE_XRI_REGTAG) {
+		if (status)
+			efc_log_err(hw->os, "reque xri failed, status = %d\n",
+				     status);
+		return;
+	}
+
+	wqcb = efct_hw_reqtag_get_instance(hw, rid);
+	if (!wqcb) {
+		efc_log_err(hw->os, "invalid request tag: x%x\n", rid);
+		return;
+	}
+
+	if (!wqcb->callback) {
+		efc_log_err(hw->os, "wqcb callback is NULL\n");
+		return;
+	}
+
+	(*wqcb->callback)(wqcb->arg, cqe, status);
+}
+
+/**
+ * @brief Process WQ completions for IO requests
+ *
+ * @param arg Generic callback argument
+ * @param cqe Pointer to completion queue entry
+ * @param status Completion status
+ *
+ * @par Description
+ * Note:  Regarding io->reqtag, the reqtag is assigned once when HW IOs are
+ * initialized in efct_hw_setup_io(), and don't need to be returned to the
+ * hw->wq_reqtag_pool.
+ *
+ * @return None.
+ */
+static void
+efct_hw_wq_process_io(void *arg, u8 *cqe, int status)
+{
+	struct efct_hw_io_s *io = arg;
+	struct efct_hw_s *hw = io->hw;
+	struct sli4_fc_wcqe_s *wcqe = (void *)cqe;
+	u32	len = 0;
+	u32 ext = 0;
+
+	efct_hw_remove_io_timed_wqe(hw, io);
+
+	/* clear xbusy flag if WCQE[XB] is clear */
+	if (io->xbusy && (wcqe->flags & SLI4_WCQE_XB) == 0)
+		io->xbusy = false;
+
+	/* get extended CQE status */
+	switch (io->type) {
+	case EFCT_HW_BLS_ACC:
+	case EFCT_HW_BLS_ACC_SID:
+		break;
+	case EFCT_HW_ELS_REQ:
+		sli_fc_els_did(&hw->sli, cqe, &ext);
+		len = sli_fc_response_length(&hw->sli, cqe);
+		break;
+	case EFCT_HW_ELS_RSP:
+	case EFCT_HW_ELS_RSP_SID:
+	case EFCT_HW_FC_CT_RSP:
+		break;
+	case EFCT_HW_FC_CT:
+		len = sli_fc_response_length(&hw->sli, cqe);
+		break;
+	case EFCT_HW_IO_TARGET_WRITE:
+		len = sli_fc_io_length(&hw->sli, cqe);
+		break;
+	case EFCT_HW_IO_TARGET_READ:
+		len = sli_fc_io_length(&hw->sli, cqe);
+		break;
+	case EFCT_HW_IO_TARGET_RSP:
+		break;
+	case EFCT_HW_IO_DNRX_REQUEUE:
+		/* release the count for re-posting the buffer */
+		/* efct_hw_io_free(hw, io); */
+		break;
+	default:
+		efc_log_test(hw->os, "unhandled io type %#x for XRI 0x%x\n",
+			      io->type, io->indicator);
+		break;
+	}
+	if (status) {
+		ext = sli_fc_ext_status(&hw->sli, cqe);
+		/*
+		 * If we're not an originator IO, and XB is set, then issue
+		 * abort for the IO from within the HW
+		 */
+		if ((!efct_hw_iotype_is_originator(io->type)) &&
+		    wcqe->flags & SLI4_WCQE_XB) {
+			enum efct_hw_rtn_e rc;
+
+			efc_log_debug(hw->os, "aborting xri=%#x tag=%#x\n",
+				       io->indicator, io->reqtag);
+
+			/*
+			 * Because targets may send a response when the IO
+			 * completes using the same XRI, we must wait for the
+			 * XRI_ABORTED CQE to issue the IO callback
+			 */
+			rc = efct_hw_io_abort(hw, io, false, NULL, NULL);
+			if (rc == EFCT_HW_RTN_SUCCESS) {
+				/*
+				 * latch status to return after abort is
+				 * complete
+				 */
+				io->status_saved = true;
+				io->saved_status = status;
+				io->saved_ext = ext;
+				io->saved_len = len;
+				goto exit_efct_hw_wq_process_io;
+			} else if (rc == EFCT_HW_RTN_IO_ABORT_IN_PROGRESS) {
+				/*
+				 * Already being aborted by someone else (ABTS
+				 * perhaps). Just fall thru and return original
+				 * error.
+				 */
+				efc_log_debug(hw->os, "%s%#x tag=%#x\n",
+					       "abort in progress xri=",
+					      io->indicator, io->reqtag);
+
+			} else {
+				/* Failed to abort for some other reason, log
+				 * error
+				 */
+				efc_log_test(hw->os, "%s%#x tag=%#x rc=%d\n",
+					      "Failed to abort xri=",
+					     io->indicator, io->reqtag, rc);
+			}
+		}
+	}
+
+	if (io->done) {
+		efct_hw_done_t done = io->done;
+		void *arg = io->arg;
+
+		io->done = NULL;
+
+		if (io->status_saved) {
+			/* use latched status if exists */
+			status = io->saved_status;
+			len = io->saved_len;
+			ext = io->saved_ext;
+			io->status_saved = false;
+		}
+
+		/* Restore default SGL */
+		efct_hw_io_restore_sgl(hw, io);
+		done(io, io->rnode, len, status, ext, arg);
+	}
+
+exit_efct_hw_wq_process_io:
+	return;
+}
+
+/**
+ * @brief Process WQ completions for abort requests.
+ *
+ * @param arg Generic callback argument.
+ * @param cqe Pointer to completion queue entry.
+ * @param status Completion status.
+ *
+ * @return None.
+ */
+static void
+efct_hw_wq_process_abort(void *arg, u8 *cqe, int status)
+{
+	struct efct_hw_io_s *io = arg;
+	struct efct_hw_s *hw = io->hw;
+	u32 ext = 0;
+	u32 len = 0;
+	struct hw_wq_callback_s *wqcb;
+	unsigned long flags = 0;
+
+	/*
+	 * For IOs that were aborted internally, we may need to issue the
+	 * callback here depending on whether a XRI_ABORTED CQE is expected ot
+	 * not. If the status is Local Reject/No XRI, then
+	 * issue the callback now.
+	 */
+	ext = sli_fc_ext_status(&hw->sli, cqe);
+	if (status == SLI4_FC_WCQE_STATUS_LOCAL_REJECT &&
+	    ext == SLI4_FC_LOCAL_REJECT_NO_XRI &&
+		io->done) {
+		efct_hw_done_t done = io->done;
+		void		*arg = io->arg;
+
+		io->done = NULL;
+
+		/*
+		 * Use latched status as this is always saved for an internal
+		 * abort Note: We wont have both a done and abort_done
+		 * function, so don't worry about
+		 *       clobbering the len, status and ext fields.
+		 */
+		status = io->saved_status;
+		len = io->saved_len;
+		ext = io->saved_ext;
+		io->status_saved = false;
+		done(io, io->rnode, len, status, ext, arg);
+	}
+
+	if (io->abort_done) {
+		efct_hw_done_t done = io->abort_done;
+		void *arg = io->abort_arg;
+
+		io->abort_done = NULL;
+
+		done(io, io->rnode, len, status, ext, arg);
+	}
+	spin_lock_irqsave(&hw->io_abort_lock, flags);
+	/* clear abort bit to indicate abort is complete */
+	io->abort_in_progress = false;
+	spin_unlock_irqrestore(&hw->io_abort_lock, flags);
+
+	/* Free the WQ callback */
+	if (io->abort_reqtag == U32_MAX) {
+		efc_log_err(hw->os, "HW IO already freed\n");
+		return;
+	}
+
+	wqcb = efct_hw_reqtag_get_instance(hw, io->abort_reqtag);
+	efct_hw_reqtag_free(hw, wqcb);
+
+	/*
+	 * Call efct_hw_io_free() because this releases the WQ reservation as
+	 * well as doing the refcount put. Don't duplicate the code here.
+	 */
+	(void)efct_hw_io_free(hw, io);
+}
+
+/**
+ * @brief Process XABT completions
+ *
+ * @param hw Hardware context.
+ * @param cq Pointer to the HW completion queue object.
+ * @param cqe Pointer to WQ completion queue.
+ * @param rid Resource ID (IO tag).
+ *
+ *
+ * @return None.
+ */
+void
+efct_hw_xabt_process(struct efct_hw_s *hw, struct hw_cq_s *cq,
+		     u8 *cqe, u16 rid)
+{
+	/* search IOs wait free list */
+	struct efct_hw_io_s *io = NULL;
+	unsigned long flags = 0;
+
+	io = efct_hw_io_lookup(hw, rid);
+	if (!io) {
+		/* IO lookup failure should never happen */
+		efc_log_err(hw->os,
+			     "Error: xabt io lookup failed rid=%#x\n", rid);
+		return;
+	}
+
+	if (!io->xbusy)
+		efc_log_debug(hw->os, "xabt io not busy rid=%#x\n", rid);
+	else
+		/* mark IO as no longer busy */
+		io->xbusy = false;
+
+	/*
+	 * For IOs that were aborted internally, we need to issue any pending
+	 * callback here.
+	 */
+	if (io->done) {
+		efct_hw_done_t done = io->done;
+		void		*arg = io->arg;
+
+		/*
+		 * Use latched status as this is always saved for an internal
+		 * abort
+		 */
+		int status = io->saved_status;
+		u32 len = io->saved_len;
+		u32 ext = io->saved_ext;
+
+		io->done = NULL;
+		io->status_saved = false;
+
+		done(io, io->rnode, len, status, ext, arg);
+	}
+
+	spin_lock_irqsave(&hw->io_lock, flags);
+	if (io->state == EFCT_HW_IO_STATE_INUSE ||
+	    io->state == EFCT_HW_IO_STATE_WAIT_FREE) {
+		/* if on wait_free list, caller has already freed IO;
+		 * remove from wait_free list and add to free list.
+		 * if on in-use list, already marked as no longer busy;
+		 * just leave there and wait for caller to free.
+		 */
+		if (io->state == EFCT_HW_IO_STATE_WAIT_FREE) {
+			io->state = EFCT_HW_IO_STATE_FREE;
+			list_del(&io->list_entry);
+			efct_hw_io_free_move_correct_list(hw, io);
+		}
+	}
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+}
+
+static int
+efct_hw_flush(struct efct_hw_s *hw)
+{
+	u32	i = 0;
+
+	/* Process any remaining completions */
+	for (i = 0; i < hw->eq_count; i++)
+		efct_hw_process(hw, i, ~0);
+
+	return 0;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index d913c0169c44..8a487df2338d 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -1076,4 +1076,40 @@ extern struct hw_wq_callback_s
 *efct_hw_reqtag_get_instance(struct efct_hw_s *hw, u32 instance_index);
 void efct_hw_reqtag_reset(struct efct_hw_s *hw);
 
+/* RQ completion handlers for RQ pair mode */
+extern int
+efct_hw_rqpair_process_rq(struct efct_hw_s *hw,
+			  struct hw_cq_s *cq, u8 *cqe);
+extern
+enum efct_hw_rtn_e efct_hw_rqpair_sequence_free(struct efct_hw_s *hw,
+						struct efc_hw_sequence_s *seq);
+static inline void
+efct_hw_sequence_copy(struct efc_hw_sequence_s *dst,
+		      struct efc_hw_sequence_s *src)
+{
+	/* Copy src to dst, then zero out the linked list link */
+	*dst = *src;
+}
+
+static inline enum efct_hw_rtn_e
+efct_hw_sequence_free(struct efct_hw_s *hw, struct efc_hw_sequence_s *seq)
+{
+	/* Only RQ pair mode is supported */
+	return efct_hw_rqpair_sequence_free(hw, seq);
+}
+extern int
+efct_hw_eq_process(struct efct_hw_s *hw, struct hw_eq_s *eq,
+		   u32 max_isr_time_msec);
+void efct_hw_cq_process(struct efct_hw_s *hw, struct hw_cq_s *cq);
+extern void
+efct_hw_wq_process(struct efct_hw_s *hw, struct hw_cq_s *cq,
+		   u8 *cqe, int status, u16 rid);
+extern void
+efct_hw_xabt_process(struct efct_hw_s *hw, struct hw_cq_s *cq,
+		     u8 *cqe, u16 rid);
+extern int
+efct_hw_process(struct efct_hw_s *hw, u32 vector, u32 max_isr_time_msec);
+extern int
+efct_hw_queue_hash_find(struct efct_queue_hash_s *hash, u16 id);
+
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_hw_queues.c b/drivers/scsi/elx/efct/efct_hw_queues.c
index 5196aa75553c..97d64e225f43 100644
--- a/drivers/scsi/elx/efct/efct_hw_queues.c
+++ b/drivers/scsi/elx/efct/efct_hw_queues.c
@@ -1715,3 +1715,250 @@ efct_hw_qtop_free(struct efct_hw_qtop_s *qtop)
 		kfree(qtop);
 	}
 }
+
+/**
+ * @brief Process receive queue completions for RQ Pair mode.
+ *
+ * @par Description
+ * RQ completions are processed. In RQ pair mode, a single header and single
+ * payload buffer are received, and passed to the function that has registered
+ * for unsolicited callbacks.
+ *
+ * @param hw Hardware context.
+ * @param cq Pointer to HW completion queue.
+ * @param cqe Completion queue entry.
+ *
+ * @return Returns 0 for success, or a negative error code value for failure.
+ **/
+
+int
+efct_hw_rqpair_process_rq(struct efct_hw_s *hw, struct hw_cq_s *cq,
+			  u8 *cqe)
+{
+	u16 rq_id;
+	u32 index;
+	int rqindex;
+	int	 rq_status;
+	u32 h_len;
+	u32 p_len;
+	struct efc_hw_sequence_s *seq;
+	struct hw_rq_s *rq;
+
+	rq_status = sli_fc_rqe_rqid_and_index(&hw->sli, cqe,
+					      &rq_id, &index);
+	if (rq_status != 0) {
+		switch (rq_status) {
+		case SLI4_FC_ASYNC_RQ_BUF_LEN_EXCEEDED:
+		case SLI4_FC_ASYNC_RQ_DMA_FAILURE:
+			/* just get RQ buffer then return to chip */
+			rqindex = efct_hw_rqpair_find(hw, rq_id);
+			if (rqindex < 0) {
+				efc_log_test(hw->os,
+					      "status=%#x: lookup fail id=%#x\n",
+					     rq_status, rq_id);
+				break;
+			}
+
+			/* get RQ buffer */
+			seq = efct_hw_rqpair_get(hw, rqindex, index);
+
+			/* return to chip */
+			if (efct_hw_rqpair_sequence_free(hw, seq)) {
+				efc_log_test(hw->os,
+					      "status=%#x,fail rtrn buf to RQ\n",
+					     rq_status);
+				break;
+			}
+			break;
+		case SLI4_FC_ASYNC_RQ_INSUFF_BUF_NEEDED:
+		case SLI4_FC_ASYNC_RQ_INSUFF_BUF_FRM_DISC:
+			/*
+			 * since RQ buffers were not consumed, cannot return
+			 * them to chip
+			 * fall through
+			 */
+			efc_log_debug(hw->os, "Warning: RCQE status=%#x,\n",
+				       rq_status);
+		default:
+			break;
+		}
+		return -1;
+	}
+
+	rqindex = efct_hw_rqpair_find(hw, rq_id);
+	if (rqindex < 0) {
+		efc_log_test(hw->os, "Error: rq_id lookup failed for id=%#x\n",
+			      rq_id);
+		return -1;
+	}
+
+	rq = hw->hw_rq[hw->hw_rq_lookup[rqindex]];
+	rq->use_count++;
+
+	seq = efct_hw_rqpair_get(hw, rqindex, index);
+	if (WARN_ON(!seq))
+		return -1;
+
+	seq->hw = hw;
+	seq->auto_xrdy = 0;
+	seq->out_of_xris = 0;
+	seq->xri = 0;
+	seq->hio = NULL;
+
+	sli_fc_rqe_length(&hw->sli, cqe, &h_len, &p_len);
+	seq->header->dma.len = h_len;
+	seq->payload->dma.len = p_len;
+	seq->fcfi = sli_fc_rqe_fcfi(&hw->sli, cqe);
+	seq->hw_priv = cq->eq;
+
+	efct_unsolicited_cb(hw->os, seq);
+
+	return 0;
+}
+/**
+ * @brief Return pointer to RQ buffer entry.
+ *
+ * @par Description
+ * Returns a pointer to the RQ buffer entry given by @c rqindex and @c bufindex.
+ *
+ * @param hw Hardware context.
+ * @param rqindex Index of the RQ that is being processed.
+ * @param bufindex Index into the RQ that is being processed.
+ *
+ * @return Pointer to the sequence structure, or NULL otherwise.
+ */
+static struct efc_hw_sequence_s *
+efct_hw_rqpair_get(struct efct_hw_s *hw, u16 rqindex, u16 bufindex)
+{
+	struct sli4_queue_s *rq_hdr = &hw->rq[rqindex];
+	struct efc_hw_sequence_s *seq = NULL;
+	struct hw_rq_s *rq = hw->hw_rq[hw->hw_rq_lookup[rqindex]];
+	unsigned long flags = 0;
+
+	if (bufindex >= rq_hdr->length) {
+		efc_log_err(hw->os,
+				"RQidx %d bufidx %d exceed ring len %d for id %d\n",
+				rqindex, bufindex, rq_hdr->length, rq_hdr->id);
+		return NULL;
+	}
+
+	/* rq_hdr lock also covers rqindex+1 queue */
+	spin_lock_irqsave(&rq_hdr->lock, flags);
+
+	seq = rq->rq_tracker[bufindex];
+	rq->rq_tracker[bufindex] = NULL;
+
+	if (!seq) {
+		efc_log_err(hw->os,
+			     "RQbuf NULL, rqidx %d, bufidx %d, cur q idx = %d\n",
+			     rqindex, bufindex, rq_hdr->index);
+	}
+
+	spin_unlock_irqrestore(&rq_hdr->lock, flags);
+	return seq;
+}
+/**
+ * @brief Posts an RQ buffer to a queue and update the verification structures
+ *
+ * @param hw		hardware context
+ * @param seq Pointer to sequence object.
+ *
+ * @return Returns 0 on success, or a non-zero value otherwise.
+ */
+static int
+efct_hw_rqpair_put(struct efct_hw_s *hw, struct efc_hw_sequence_s *seq)
+{
+	struct sli4_queue_s *rq_hdr = &hw->rq[seq->header->rqindex];
+	struct sli4_queue_s *rq_payload = &hw->rq[seq->payload->rqindex];
+	u32 hw_rq_index = hw->hw_rq_lookup[seq->header->rqindex];
+	struct hw_rq_s *rq = hw->hw_rq[hw_rq_index];
+	u32     phys_hdr[2];
+	u32     phys_payload[2];
+	int      qindex_hdr;
+	int      qindex_payload;
+	unsigned long flags = 0;
+
+	/* Update the RQ verification lookup tables */
+	phys_hdr[0] = upper_32_bits(seq->header->dma.phys);
+	phys_hdr[1] = lower_32_bits(seq->header->dma.phys);
+	phys_payload[0] = upper_32_bits(seq->payload->dma.phys);
+	phys_payload[1] = lower_32_bits(seq->payload->dma.phys);
+
+	/* rq_hdr lock also covers payload / header->rqindex+1 queue */
+	spin_lock_irqsave(&rq_hdr->lock, flags);
+
+	/*
+	 * Note: The header must be posted last for buffer pair mode because
+	 *       posting on the header queue posts the payload queue as well.
+	 *       We do not ring the payload queue independently in RQ pair mode.
+	 */
+	qindex_payload = sli_rq_write(&hw->sli, rq_payload,
+				      (void *)phys_payload);
+	qindex_hdr = sli_rq_write(&hw->sli, rq_hdr, (void *)phys_hdr);
+	if (qindex_hdr < 0 ||
+	    qindex_payload < 0) {
+		efc_log_err(hw->os, "RQ_ID=%#x write failed\n", rq_hdr->id);
+		spin_unlock_irqrestore(&rq_hdr->lock, flags);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* ensure the indexes are the same */
+	WARN_ON(qindex_hdr != qindex_payload);
+
+	/* Update the lookup table */
+	if (!rq->rq_tracker[qindex_hdr]) {
+		rq->rq_tracker[qindex_hdr] = seq;
+	} else {
+		efc_log_test(hw->os,
+			      "expected rq_tracker[%d][%d] buffer to be NULL\n",
+			     hw_rq_index, qindex_hdr);
+	}
+
+	spin_unlock_irqrestore(&rq_hdr->lock, flags);
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+/**
+ * @brief Return RQ buffers (while in RQ pair mode).
+ *
+ * @par Description
+ * The header and payload buffers are returned to the Receive Queue.
+ *
+ * @param hw Hardware context.
+ * @param seq Header/payload sequence buffers.
+ *
+ * @return Returns EFCT_HW_RTN_SUCCESS on success, or an error code value on
+ * failure.
+ */
+
+enum efct_hw_rtn_e
+efct_hw_rqpair_sequence_free(struct efct_hw_s *hw,
+			     struct efc_hw_sequence_s *seq)
+{
+	enum efct_hw_rtn_e   rc = EFCT_HW_RTN_SUCCESS;
+
+	/*
+	 * Post the data buffer first. Because in RQ pair mode, ringing the
+	 * doorbell of the header ring will post the data buffer as well.
+	 */
+	if (efct_hw_rqpair_put(hw, seq)) {
+		efc_log_err(hw->os, "error writing buffers\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	return rc;
+}
+
+/**
+ * @brief Find the RQ index of RQ_ID.
+ *
+ * @param hw Hardware context.
+ * @param rq_id RQ ID to find.
+ *
+ * @return Returns the RQ index, or -1 if not found
+ */
+static inline int
+efct_hw_rqpair_find(struct efct_hw_s *hw, u16 rq_id)
+{
+	return efct_hw_queue_hash_find(hw->rq_hash, rq_id);
+}
diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
new file mode 100644
index 000000000000..f61ee0fdd616
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -0,0 +1,288 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_utils.h"
+#include "efct_hw.h"
+#include "efct_io.h"
+
+/**
+ * @brief IO pool.
+ *
+ * Structure encapsulating a pool of IO objects.
+ *
+ */
+
+struct efct_io_pool_s {
+	struct efct_s *efct;			/* Pointer to device object */
+	spinlock_t lock;		/* IO pool lock */
+	u32 io_num_ios;		/* Total IOs allocated */
+	struct efct_pool_s *pool;
+};
+
+/**
+ * @brief Create a pool of IO objects.
+ *
+ * @par Description
+ * This function allocates memory in larger chucks called
+ * "slabs" which are a fixed size. It calculates the number of IO objects that
+ * fit within each "slab" and determines the number of "slabs" required to
+ * allocate the number of IOs requested. Each of the slabs is allocated and
+ * then it grabs each IO object within the slab and adds it to the free list.
+ * Individual command, response and SGL DMA buffers are allocated for each IO.
+ *
+ *           "Slabs"
+ *      +----------------+
+ *      |                |
+ *   +----------------+  |
+ *   |    IO          |  |
+ *   +----------------+  |
+ *   |    ...         |  |
+ *   +----------------+__+
+ *   |    IO          |
+ *   +----------------+
+ *
+ * @param efct Driver instance's software context.
+ * @param num_io Number of IO contexts to allocate.
+ * @param num_sgl Number of SGL entries to allocate for each IO.
+ *
+ * @return Returns a pointer to a new efct_io_pool_s on success,
+ *         or NULL on failure.
+ */
+
+struct efct_io_pool_s *
+efct_io_pool_create(struct efct_s *efct, u32 num_io, u32 num_sgl)
+{
+	u32 i = 0;
+	struct efct_io_pool_s *io_pool;
+
+	/* Allocate the IO pool */
+	io_pool = kmalloc(sizeof(*io_pool), GFP_KERNEL);
+	if (!io_pool)
+		return NULL;
+
+	memset(io_pool, 0, sizeof(*io_pool));
+	io_pool->efct = efct;
+	io_pool->io_num_ios = num_io;
+
+	/* initialize IO pool lock */
+	spin_lock_init(&io_pool->lock);
+
+	io_pool->pool = efct_pool_alloc(efct, sizeof(struct efct_io_s),
+					io_pool->io_num_ios);
+
+	for (i = 0; i < io_pool->io_num_ios; i++) {
+		struct efct_io_s *io = efct_pool_get_instance(io_pool->pool, i);
+
+		io->tag = i;
+		io->instance_index = i;
+		io->efct = efct;
+
+		/* Allocate a response buffer */
+		io->rspbuf.size = SCSI_RSP_BUF_LENGTH;
+		io->rspbuf.virt = dma_alloc_coherent(&efct->pcidev->dev,
+						     io->rspbuf.size,
+						     &io->rspbuf.phys, GFP_DMA);
+		if (!io->rspbuf.virt) {
+			efc_log_err(efct, "dma_alloc cmdbuf failed\n");
+			efct_io_pool_free(io_pool);
+			return NULL;
+		}
+
+		/* Allocate SGL */
+		io->sgl = kzalloc(sizeof(*io->sgl) * num_sgl, GFP_ATOMIC);
+		if (!io->sgl) {
+			efct_io_pool_free(io_pool);
+			return NULL;
+		}
+
+		memset(io->sgl, 0, sizeof(*io->sgl) * num_sgl);
+		io->sgl_allocated = num_sgl;
+		io->sgl_count = 0;
+
+		/* Make IO backend call to initialize IO */
+		efct_scsi_tgt_io_init(io);
+	}
+
+	return io_pool;
+}
+
+/**
+ * @brief Free IO objects pool
+ *
+ * @par Description
+ * The pool of IO objects are freed.
+ *
+ * @param io_pool Pointer to IO pool object.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_io_pool_free(struct efct_io_pool_s *io_pool)
+{
+	struct efct_s *efct;
+	u32 i;
+	struct efct_io_s *io;
+
+	if (io_pool) {
+		efct = io_pool->efct;
+
+		for (i = 0; i < io_pool->io_num_ios; i++) {
+			io = efct_pool_get_instance(io_pool->pool, i);
+			if (!io)
+				continue;
+
+			efct_scsi_tgt_io_exit(io);
+			kfree(io->sgl);
+			dma_free_coherent(&efct->pcidev->dev,
+					  io->cmdbuf.size, io->cmdbuf.virt,
+					  io->cmdbuf.phys);
+			memset(&io->cmdbuf, 0, sizeof(struct efc_dma_s));
+			dma_free_coherent(&efct->pcidev->dev,
+					  io->rspbuf.size, io->rspbuf.virt,
+					  io->rspbuf.phys);
+			memset(&io->rspbuf, 0, sizeof(struct efc_dma_s));
+		}
+
+		if (io_pool->pool)
+			efct_pool_free(io_pool->pool);
+
+		kfree(io_pool);
+		efct->xport->io_pool = NULL;
+	}
+
+	return 0;
+}
+
+u32 efct_io_pool_allocated(struct efct_io_pool_s *io_pool)
+{
+	return io_pool->io_num_ios;
+}
+
+/**
+ * @ingroup io_alloc
+ * @brief Allocate an object used to track an IO.
+ *
+ * @param io_pool Pointer to the IO pool.
+ *
+ * @return Returns the pointer to a new object, or NULL if none available.
+ */
+struct efct_io_s *
+efct_io_pool_io_alloc(struct efct_io_pool_s *io_pool)
+{
+	struct efct_io_s *io = NULL;
+	struct efct_s *efct;
+	unsigned long flags = 0;
+
+	efct = io_pool->efct;
+
+	spin_lock_irqsave(&io_pool->lock, flags);
+	io = efct_pool_get(io_pool->pool);
+	if (io) {
+		spin_unlock_irqrestore(&io_pool->lock, flags);
+
+		io->io_type = EFCT_IO_TYPE_MAX;
+		io->hio_type = EFCT_HW_IO_MAX;
+		io->hio = NULL;
+		io->transferred = 0;
+		io->efct = efct;
+		io->timeout = 0;
+		io->sgl_count = 0;
+		io->tgt_task_tag = 0;
+		io->init_task_tag = 0;
+		io->hw_tag = 0;
+		io->display_name = "pending";
+		io->seq_init = 0;
+		io->els_req_free = false;
+		io->io_free = 0;
+		io->release = NULL;
+		atomic_add_return(1, &efct->xport->io_active_count);
+		atomic_add_return(1, &efct->xport->io_total_alloc);
+	} else {
+		spin_unlock_irqrestore(&io_pool->lock, flags);
+	}
+	return io;
+}
+
+/**
+ * @ingroup io_alloc
+ * @brief Free an object used to track an IO.
+ *
+ * @param io_pool Pointer to IO pool object.
+ * @param io Pointer to the IO object.
+ */
+void
+efct_io_pool_io_free(struct efct_io_pool_s *io_pool, struct efct_io_s *io)
+{
+	struct efct_s *efct;
+	struct efct_hw_io_s *hio = NULL;
+	unsigned long flags = 0;
+
+	efct = io_pool->efct;
+
+	spin_lock_irqsave(&io_pool->lock, flags);
+	hio = io->hio;
+	io->hio = NULL;
+	io->io_free = 1;
+	efct_pool_put_head(io_pool->pool, io);
+	spin_unlock_irqrestore(&io_pool->lock, flags);
+
+	if (hio)
+		efct_hw_io_free(&efct->hw, hio);
+
+	atomic_sub_return(1, &efct->xport->io_active_count);
+	atomic_add_return(1, &efct->xport->io_total_free);
+}
+
+/**
+ * @ingroup io_alloc
+ * @brief Find an I/O given it's node and ox_id.
+ *
+ * @param efct Driver instance's software context.
+ * @param node Pointer to node.
+ * @param ox_id OX_ID to find.
+ * @param rx_id RX_ID to find (0xffff for unassigned).
+ */
+struct efct_io_s *
+efct_io_find_tgt_io(struct efct_s *efct, struct efc_node_s *node,
+		    u16 ox_id, u16 rx_id)
+{
+	struct efct_io_s	*io = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	list_for_each_entry(io, &node->active_ios, list_entry) {
+		if ((io->cmd_tgt && io->init_task_tag == ox_id) &&
+		    (rx_id == 0xffff || io->tgt_task_tag == rx_id)) {
+			if (!kref_get_unless_zero(&io->ref))
+				io = NULL;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+	return io;
+}
+
+/**
+ * @ingroup io_alloc
+ * @brief Return IO context given the instance index.
+ *
+ * @par Description
+ * Returns a pointer to the IO context given by the instance index.
+ *
+ * @param efct Pointer to driver structure.
+ * @param index IO instance index to return.
+ *
+ * @return Returns a pointer to the IO context, or NULL if not found.
+ */
+struct efct_io_s *
+efct_io_get_instance(struct efct_s *efct, u32 index)
+{
+	struct efct_xport_s *xport = efct->xport;
+	struct efct_io_pool_s *io_pool = xport->io_pool;
+
+	return efct_pool_get_instance(io_pool->pool, index);
+}
diff --git a/drivers/scsi/elx/efct/efct_io.h b/drivers/scsi/elx/efct/efct_io.h
new file mode 100644
index 000000000000..4a4278433e25
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_io.h
@@ -0,0 +1,219 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_IO_H__)
+#define __EFCT_IO_H__
+
+#define io_error_log(io, fmt, ...)  \
+	do { \
+		if (EFCT_LOG_ENABLE_IO_ERRORS(io->efct)) \
+			efc_log_warn(io->efct, fmt, ##__VA_ARGS__); \
+	} while (0)
+
+/**
+ * @brief FCP IO context
+ *
+ * This structure is used for transport and backend IO requests and responses.
+ */
+
+#define SCSI_CMD_BUF_LENGTH	48
+#define SCSI_RSP_BUF_LENGTH	(FCP_RESP_WITH_EXT + SCSI_SENSE_BUFFERSIZE)
+#define EFCT_NUM_SCSI_IOS	8192
+
+#include "efct_lio.h"
+/**
+ * @brief EFCT IO types
+ */
+enum efct_io_type_e {
+	EFCT_IO_TYPE_IO = 0,
+	EFCT_IO_TYPE_ELS,
+	EFCT_IO_TYPE_CT,
+	EFCT_IO_TYPE_CT_RESP,
+	EFCT_IO_TYPE_BLS_RESP,
+	EFCT_IO_TYPE_ABORT,
+
+	EFCT_IO_TYPE_MAX,		/* must be last */
+};
+
+enum efct_els_state_e {
+	EFCT_ELS_REQUEST = 0,
+	EFCT_ELS_REQUEST_DELAYED,
+	EFCT_ELS_REQUEST_DELAY_ABORT,
+	EFCT_ELS_REQ_ABORT,
+	EFCT_ELS_REQ_ABORTED,
+	EFCT_ELS_ABORT_IO_COMPL,
+};
+
+struct efct_io_s {
+	struct list_head list_entry;
+	struct list_head io_pending_link;
+	/* reference counter and callback function */
+	struct kref ref;
+	void (*release)(struct kref *arg);
+	/* pointer back to efct */
+	struct efct_s *efct;
+	/* unique instance index value */
+	u32 instance_index;
+	/* display name */
+	const char *display_name;
+	/* pointer to node */
+	struct efc_node_s *node;
+	/* (io_pool->io_free_list) free list link */
+	/* initiator task tag (OX_ID) for back-end and SCSI logging */
+	u32 init_task_tag;
+	/* target task tag (RX_ID) - for back-end and SCSI logging */
+	u32 tgt_task_tag;
+	/* HW layer unique IO id - for back-end and SCSI logging */
+	u32 hw_tag;
+	/* unique IO identifier */
+	u32 tag;
+	/* SGL */
+	struct efct_scsi_sgl_s *sgl;
+	/* Number of allocated SGEs */
+	u32 sgl_allocated;
+	/* Number of SGEs in this SGL */
+	u32 sgl_count;
+	/* backend target private IO data */
+	struct efct_scsi_tgt_io_s tgt_io;
+	/* expected data transfer length, based on FC header */
+	u32 exp_xfer_len;
+
+	/* Declarations private to HW/SLI */
+	void *hw_priv;			/* HW private context */
+
+	/* Declarations private to FC Transport */
+
+	/* indicates what this struct efct_io_s structure is used for */
+	enum efct_io_type_e io_type;
+	/* pointer back to dslab allocation object */
+	void *dslab_item;
+	struct efct_hw_io_s *hio;		/* HW IO context */
+	size_t transferred;		/* Number of bytes transferred so far */
+
+	/* set if auto_trsp was set */
+	bool auto_resp;
+	/* set if low latency request */
+	bool low_latency;
+	/* selected WQ steering request */
+	u8 wq_steering;
+	/* selected WQ class if steering is class */
+	u8 wq_class;
+	/* transfer size for current request */
+	u64 xfer_req;
+	/* target callback function */
+	efct_scsi_io_cb_t scsi_tgt_cb;
+	/* target callback function argument */
+	void *scsi_tgt_cb_arg;
+	/* abort callback function */
+	efct_scsi_io_cb_t abort_cb;
+	/* abort callback function argument */
+	void *abort_cb_arg;
+	/* BLS callback function */
+	efct_scsi_io_cb_t bls_cb;
+	/* BLS callback function argument */
+	void *bls_cb_arg;
+	/* TMF command being processed */
+	enum efct_scsi_tmf_cmd_e tmf_cmd;
+	/* rx_id from the ABTS that initiated the command abort */
+	u16 abort_rx_id;
+
+	/* True if this is a Target command */
+	bool cmd_tgt;
+	/* when aborting, indicates ABTS is to be sent */
+	bool send_abts;
+	/* True if this is an Initiator command */
+	bool cmd_ini;
+	/* True if local node has sequence initiative */
+	bool seq_init;
+	/* iparams for hw io send call */
+	union efct_hw_io_param_u iparam;
+	/* HW formatted DIF parameters */
+	struct efct_hw_dif_info_s hw_dif;
+	/* DIF info saved for DIF error recovery */
+	struct efct_scsi_dif_info_s scsi_dif_info;
+	/* HW IO type */
+	enum efct_hw_io_type_e hio_type;
+	/* wire length */
+	u64 wire_len;
+	/* saved HW callback */
+	void *hw_cb;
+	/* Overflow SGL */
+	struct efc_dma_s ovfl_sgl;
+
+	/* for ELS requests/responses */
+	/* True if ELS is pending */
+	bool els_pend;
+	/* True if ELS is active */
+	bool els_active;
+	/* ELS request payload buffer */
+	struct efc_dma_s els_req;
+	/* ELS response payload buffer */
+	struct efc_dma_s els_rsp;
+	/* EIO IO state machine context */
+	//struct efc_sm_ctx_s els_sm;
+	/* current event posting nesting depth */
+	//uint els_evtdepth;
+	/* this els is to be free'd */
+	bool els_req_free;
+	/* Retries remaining */
+	u32 els_retries_remaining;
+	void (*els_callback)(struct efc_node_s *node,
+			     struct efc_node_cb_s *cbdata, void *cbarg);
+	void *els_callback_arg;
+	/* timeout */
+	u32 els_timeout_sec;
+
+	/* delay timer */
+	struct timer_list delay_timer;
+
+	/* for abort handling */
+	/* pointer to IO to abort */
+	struct efct_io_s *io_to_abort;
+
+	enum efct_els_state_e	state;
+	/* Protects els cmds */
+	spinlock_t	els_lock;
+
+	/* SCSI Command buffer, used for CDB (initiator) */
+	struct efc_dma_s cmdbuf;
+	/* SCSI Response buffer (i+t) */
+	struct efc_dma_s rspbuf;
+	/* Timeout value in seconds for this IO */
+	u32  timeout;
+	/* CS_CTL priority for this IO */
+	u8   cs_ctl;
+	/* Is io object in freelist > */
+	u8	  io_free;
+	u32  app_id;
+};
+
+/**
+ * @brief common IO callback argument
+ *
+ * Callback argument used as common I/O callback argument
+ */
+
+struct efct_io_cb_arg_s {
+	int status;		/* completion status */
+	int ext_status;	/* extended completion status */
+	void *app;		/* application argument */
+};
+
+struct efct_io_pool_s *
+efct_io_pool_create(struct efct_s *efct, u32 num_io, u32 num_sgl);
+extern int
+efct_io_pool_free(struct efct_io_pool_s *io_pool);
+extern u32
+efct_io_pool_allocated(struct efct_io_pool_s *io_pool);
+
+extern struct efct_io_s *
+efct_io_pool_io_alloc(struct efct_io_pool_s *io_pool);
+extern void
+efct_io_pool_io_free(struct efct_io_pool_s *io_pool, struct efct_io_s *io);
+extern struct efct_io_s *
+efct_io_find_tgt_io(struct efct_s *efct, struct efc_node_s *node,
+		    u16 ox_id, u16 rx_id);
+#endif /* __EFCT_IO_H__ */
-- 
2.13.7

