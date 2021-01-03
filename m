Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0911DC4332D
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAAD7206F4
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbhACRNd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jan 2021 12:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727760AbhACRNc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2021 12:13:32 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E96C0617B0
        for <linux-scsi@vger.kernel.org>; Sun,  3 Jan 2021 09:12:57 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 30so12538103pgr.6
        for <linux-scsi@vger.kernel.org>; Sun, 03 Jan 2021 09:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u49Nyd0aR8ObhLykrpUOGLy1FHRVKJQ8H8Gp4y2XS5U=;
        b=N3HnGzfBWEFiJeKoNDdodDcp9IJKm+WyJQQO50jh5hMh33BW1hf5DeIiQiY9brQJxR
         RLCGa+XB41yGk4KuHkdosPlSuVRUzccpri4aUwk1ovy3jXAExGCAVR4L7xNBD5VOTqoi
         ZF6xvRE9Q4XkLOK/0HBFaXEe3nvbZTfAbomcj/uLBcK//RhFKgmTvOulOcTg2QZTIefR
         ulWo3olWqcazXtiLa5Lhh7d74HI/kqgUqD7QJMa1LNAjQRq32fD4RMsan4oy0MozZIrc
         0e3xSEQT6Lg/+R61drjLuqpSINHg+uLktPHrbgJaRrz6lRcD7oYdWmDsMfIe1wUuKY8B
         +J9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u49Nyd0aR8ObhLykrpUOGLy1FHRVKJQ8H8Gp4y2XS5U=;
        b=EEkQMHBlEDAwhLr0g6VqjNyZnBc7EEmZsEnSx0nd8IsTKMmL7TONhMurJRias/hSPE
         IiuMoPSWlzWMtw4mMfWT/MnHA+7rVas2plRqUXHOa3wm/LQAFP47Mx/lmn31hUtfUUNd
         /s5DP/EuauvGSD8tXUHj5A/Ej1wh27wDSKl14fT4FNpA4ccK85uBkZW3argBWx2p3MGJ
         fW60S+Am6soz3opTy094FbWw/b/WC7cn3djtyuARgXAewFn9IQw65zr8ESASFyXb/WsT
         DFoOkVtj3XaC+bmO5m+hOBwTJ0a2xgQZX1L8KpGD9Xuw2GPl/7kQNmkoZJqGpSGrHPFv
         S7Hw==
X-Gm-Message-State: AOAM532hoxOrMW+OZ/CfUTrPmDuUud1liIoe/jg9elbGB06cAqHuzth3
        IT5e00RnSjUhtK4YoEP42WI6qZd3pm8=
X-Google-Smtp-Source: ABdhPJzEpc0XKUqDU+WRr0m+D1sGURV5NoUrWg2dDNQhhZgfw9FCNaZe/EQJ1Q+kL2PLEtmlCVgUSA==
X-Received: by 2002:a63:700f:: with SMTP id l15mr28576442pgc.214.1609693976101;
        Sun, 03 Jan 2021 09:12:56 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m4sm33145151pgv.16.2021.01.03.09.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 09:12:55 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v5 22/31] elx: efct: Hardware queues processing
Date:   Sun,  3 Jan 2021 09:11:25 -0800
Message-Id: <20210103171134.39878-23-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103171134.39878-1-jsmart2021@gmail.com>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines for EQ, CQ, WQ and RQ processing.
Routines for IO object pool allocation and deallocation.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/elx/efct/efct_hw.c | 366 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  38 ++++
 drivers/scsi/elx/efct/efct_io.c | 191 +++++++++++++++++
 drivers/scsi/elx/efct/efct_io.h | 166 +++++++++++++++
 4 files changed, 761 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_io.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.h

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 40811c229a15..7dc9cb7e743b 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2150,3 +2150,369 @@ efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index)
 
 	return wqcb;
 }
+
+int
+efct_hw_queue_hash_find(struct efct_queue_hash *hash, u16 id)
+{
+	int index = -1;
+	int i = id & (EFCT_HW_Q_HASH_SIZE - 1);
+
+	/*
+	 * Since the hash is always bigger than the maximum number of Qs, then
+	 * we never have to worry about an infinite loop. We will always find
+	 * an unused entry.
+	 */
+	do {
+		if (hash[i].in_use && hash[i].id == id)
+			index = hash[i].index;
+		else
+			i = (i + 1) & (EFCT_HW_Q_HASH_SIZE - 1);
+	} while (index == -1 && hash[i].in_use);
+
+	return index;
+}
+
+int
+efct_hw_process(struct efct_hw *hw, u32 vector,
+		u32 max_isr_time_msec)
+{
+	struct hw_eq *eq;
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
+		return EFC_SUCCESS;
+
+	/* Get pointer to struct hw_eq */
+	eq = hw->hw_eq[vector];
+	if (!eq)
+		return EFC_SUCCESS;
+
+	eq->use_count++;
+
+	rc = efct_hw_eq_process(hw, eq, max_isr_time_msec);
+
+	return rc;
+}
+
+int
+efct_hw_eq_process(struct efct_hw *hw, struct hw_eq *eq,
+		   u32 max_isr_time_msec)
+{
+	u8 eqe[sizeof(struct sli4_eqe)] = { 0 };
+	u32 tcheck_count;
+	u64 tstart;
+	u64 telapsed;
+	bool done = false;
+
+	tcheck_count = EFCT_HW_TIMECHECK_ITERATIONS;
+	tstart = jiffies_to_msecs(jiffies);
+
+	while (!done && !sli_eq_read(&hw->sli, eq->queue, eqe)) {
+		u16 cq_id = 0;
+		int rc;
+
+		rc = sli_eq_parse(&hw->sli, eqe, &cq_id);
+		if (unlikely(rc)) {
+			if (rc == SLI4_EQE_STATUS_EQ_FULL) {
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
+	return EFC_SUCCESS;
+}
+
+static int
+_efct_hw_wq_write(struct hw_wq *wq, struct efct_hw_wqe *wqe)
+{
+	int queue_rc;
+
+	/* Every so often, set the wqec bit to generate comsummed completions */
+	if (wq->wqec_count)
+		wq->wqec_count--;
+
+	if (wq->wqec_count == 0) {
+		struct sli4_generic_wqe *genwqe = (void *)wqe->wqebuf;
+
+		genwqe->cmdtype_wqec_byte |= SLI4_GEN_WQE_WQEC;
+		wq->wqec_count = wq->wqec_set_count;
+	}
+
+	/* Decrement WQ free count */
+	wq->free_count--;
+
+	queue_rc = sli_wq_write(&wq->hw->sli, wq->queue, wqe->wqebuf);
+
+	return (queue_rc < 0) ? EFC_FAIL : EFC_SUCCESS;
+}
+
+static void
+hw_wq_submit_pending(struct hw_wq *wq, u32 update_free_count)
+{
+	struct efct_hw_wqe *wqe;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&wq->queue->lock, flags);
+
+	/* Update free count with value passed in */
+	wq->free_count += update_free_count;
+
+	while ((wq->free_count > 0) && (!list_empty(&wq->pending_list))) {
+		wqe = list_first_entry(&wq->pending_list,
+				       struct efct_hw_wqe, list_entry);
+		list_del_init(&wqe->list_entry);
+		_efct_hw_wq_write(wq, wqe);
+
+		if (wqe->abort_wqe_submit_needed) {
+			wqe->abort_wqe_submit_needed = false;
+			efct_hw_fill_abort_wqe(wq->hw, wqe);
+			INIT_LIST_HEAD(&wqe->list_entry);
+			list_add_tail(&wqe->list_entry, &wq->pending_list);
+			wq->wq_pending_count++;
+		}
+	}
+
+	spin_unlock_irqrestore(&wq->queue->lock, flags);
+}
+
+void
+efct_hw_cq_process(struct efct_hw *hw, struct hw_cq *cq)
+{
+	u8 cqe[sizeof(struct sli4_mcqe)];
+	u16 rid = U16_MAX;
+	/* completion type */
+	enum sli4_qentry ctype;
+	u32 n_processed = 0;
+	u32 tstart, telapsed;
+
+	tstart = jiffies_to_msecs(jiffies);
+
+	while (!sli_cq_read(&hw->sli, cq->queue, cqe)) {
+		int status;
+
+		status = sli_cq_parse(&hw->sli, cq->queue, cqe, &ctype, &rid);
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
+			if (status == SLI4_MCQE_STATUS_NOT_COMPLETED)
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
+		case SLI4_QENTRY_ASYNC:
+			sli_cqe_async(&hw->sli, cqe);
+			break;
+		case SLI4_QENTRY_MQ:
+			/*
+			 * Process MQ entry. Note there is no way to determine
+			 * the MQ_ID from the completion entry.
+			 */
+			efct_hw_mq_process(hw, status, hw->mq);
+			break;
+		case SLI4_QENTRY_WQ:
+			efct_hw_wq_process(hw, cq, cqe, status, rid);
+			break;
+		case SLI4_QENTRY_WQ_RELEASE: {
+			u32 wq_id = rid;
+			int index;
+			struct hw_wq *wq = NULL;
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
+		case SLI4_QENTRY_RQ:
+			efct_hw_rqpair_process_rq(hw, cq, cqe);
+			break;
+		case SLI4_QENTRY_XABT: {
+			efct_hw_xabt_process(hw, cq, cqe, rid);
+			break;
+		}
+		default:
+			efc_log_debug(hw->os,
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
+void
+efct_hw_wq_process(struct efct_hw *hw, struct hw_cq *cq,
+		   u8 *cqe, int status, u16 rid)
+{
+	struct hw_wq_callback *wqcb;
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
+void
+efct_hw_xabt_process(struct efct_hw *hw, struct hw_cq *cq,
+		     u8 *cqe, u16 rid)
+{
+	/* search IOs wait free list */
+	struct efct_hw_io *io = NULL;
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
+		done(io, len, status, ext, arg);
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
+			list_del_init(&io->list_entry);
+			efct_hw_io_free_move_correct_list(hw, io);
+		}
+	}
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+}
+
+static int
+efct_hw_flush(struct efct_hw *hw)
+{
+	u32 i = 0;
+
+	/* Process any remaining completions */
+	for (i = 0; i < hw->eq_count; i++)
+		efct_hw_process(hw, i, ~0);
+
+	return EFC_SUCCESS;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 512ae9e2b228..4a6186b70b76 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -669,4 +669,42 @@ efct_hw_reqtag_free(struct efct_hw *hw, struct hw_wq_callback *wqcb);
 struct hw_wq_callback
 *efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index);
 
+/* RQ completion handlers for RQ pair mode */
+int
+efct_hw_rqpair_process_rq(struct efct_hw *hw,
+			  struct hw_cq *cq, u8 *cqe);
+enum efct_hw_rtn
+efct_hw_rqpair_sequence_free(struct efct_hw *hw, struct efc_hw_sequence *seq);
+static inline void
+efct_hw_sequence_copy(struct efc_hw_sequence *dst,
+		      struct efc_hw_sequence *src)
+{
+	/* Copy src to dst, then zero out the linked list link */
+	*dst = *src;
+}
+
+int
+efct_efc_hw_sequence_free(struct efc *efc, struct efc_hw_sequence *seq);
+
+static inline enum efct_hw_rtn
+efct_hw_sequence_free(struct efct_hw *hw, struct efc_hw_sequence *seq)
+{
+	/* Only RQ pair mode is supported */
+	return efct_hw_rqpair_sequence_free(hw, seq);
+}
+int
+efct_hw_eq_process(struct efct_hw *hw, struct hw_eq *eq,
+		   u32 max_isr_time_msec);
+void efct_hw_cq_process(struct efct_hw *hw, struct hw_cq *cq);
+void
+efct_hw_wq_process(struct efct_hw *hw, struct hw_cq *cq,
+		   u8 *cqe, int status, u16 rid);
+void
+efct_hw_xabt_process(struct efct_hw *hw, struct hw_cq *cq,
+		     u8 *cqe, u16 rid);
+int
+efct_hw_process(struct efct_hw *hw, u32 vector, u32 max_isr_time_msec);
+int
+efct_hw_queue_hash_find(struct efct_queue_hash *hash, u16 id);
+
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
new file mode 100644
index 000000000000..669ed12a47a9
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_hw.h"
+#include "efct_io.h"
+
+struct efct_io_pool {
+	struct efct *efct;
+	spinlock_t lock;	/* IO pool lock */
+	u32 io_num_ios;		/* Total IOs allocated */
+	struct efct_io *ios[EFCT_NUM_SCSI_IOS];
+	struct list_head freelist;
+
+};
+
+struct efct_io_pool *
+efct_io_pool_create(struct efct *efct, u32 num_sgl)
+{
+	u32 i = 0;
+	struct efct_io_pool *io_pool;
+	struct efct_io *io;
+
+	/* Allocate the IO pool */
+	io_pool = kzalloc(sizeof(*io_pool), GFP_KERNEL);
+	if (!io_pool)
+		return NULL;
+
+	io_pool->efct = efct;
+	INIT_LIST_HEAD(&io_pool->freelist);
+	/* initialize IO pool lock */
+	spin_lock_init(&io_pool->lock);
+
+	for (i = 0; i < EFCT_NUM_SCSI_IOS; i++) {
+		io = kzalloc(sizeof(*io), GFP_KERNEL);
+		if (!io)
+			break;
+
+		io_pool->io_num_ios++;
+		io_pool->ios[i] = io;
+		io->tag = i;
+		io->instance_index = i;
+
+		/* Allocate a response buffer */
+		io->rspbuf.size = SCSI_RSP_BUF_LENGTH;
+		io->rspbuf.virt = dma_alloc_coherent(&efct->pci->dev,
+						     io->rspbuf.size,
+						     &io->rspbuf.phys, GFP_DMA);
+		if (!io->rspbuf.virt) {
+			efc_log_err(efct, "dma_alloc rspbuf failed\n");
+			efct_io_pool_free(io_pool);
+			return NULL;
+		}
+
+		/* Allocate SGL */
+		io->sgl = kzalloc(sizeof(*io->sgl) * num_sgl, GFP_KERNEL);
+		if (!io->sgl) {
+			efct_io_pool_free(io_pool);
+			return NULL;
+		}
+
+		memset(io->sgl, 0, sizeof(*io->sgl) * num_sgl);
+		io->sgl_allocated = num_sgl;
+		io->sgl_count = 0;
+
+		INIT_LIST_HEAD(&io->list_entry);
+		list_add_tail(&io->list_entry, &io_pool->freelist);
+	}
+
+	return io_pool;
+}
+
+int
+efct_io_pool_free(struct efct_io_pool *io_pool)
+{
+	struct efct *efct;
+	u32 i;
+	struct efct_io *io;
+
+	if (io_pool) {
+		efct = io_pool->efct;
+
+		for (i = 0; i < io_pool->io_num_ios; i++) {
+			io = io_pool->ios[i];
+			if (!io)
+				continue;
+
+			kfree(io->sgl);
+			dma_free_coherent(&efct->pci->dev,
+					  io->rspbuf.size, io->rspbuf.virt,
+					  io->rspbuf.phys);
+			memset(&io->rspbuf, 0, sizeof(struct efc_dma));
+		}
+
+		kfree(io_pool);
+		efct->xport->io_pool = NULL;
+	}
+
+	return EFC_SUCCESS;
+}
+
+struct efct_io *
+efct_io_pool_io_alloc(struct efct_io_pool *io_pool)
+{
+	struct efct_io *io = NULL;
+	struct efct *efct;
+	unsigned long flags = 0;
+
+	efct = io_pool->efct;
+
+	spin_lock_irqsave(&io_pool->lock, flags);
+
+	if (!list_empty(&io_pool->freelist)) {
+		io = list_first_entry(&io_pool->freelist, struct efct_io,
+				     list_entry);
+		list_del_init(&io->list_entry);
+	}
+
+	spin_unlock_irqrestore(&io_pool->lock, flags);
+
+	if (!io)
+		return NULL;
+
+	io->io_type = EFCT_IO_TYPE_MAX;
+	io->hio_type = EFCT_HW_IO_MAX;
+	io->hio = NULL;
+	io->transferred = 0;
+	io->efct = efct;
+	io->timeout = 0;
+	io->sgl_count = 0;
+	io->tgt_task_tag = 0;
+	io->init_task_tag = 0;
+	io->hw_tag = 0;
+	io->display_name = "pending";
+	io->seq_init = 0;
+	io->io_free = 0;
+	io->release = NULL;
+	atomic_add_return(1, &efct->xport->io_active_count);
+	atomic_add_return(1, &efct->xport->io_total_alloc);
+	return io;
+}
+
+/* Free an object used to track an IO */
+void
+efct_io_pool_io_free(struct efct_io_pool *io_pool, struct efct_io *io)
+{
+	struct efct *efct;
+	struct efct_hw_io *hio = NULL;
+	unsigned long flags = 0;
+
+	efct = io_pool->efct;
+
+	spin_lock_irqsave(&io_pool->lock, flags);
+	hio = io->hio;
+	io->hio = NULL;
+	io->io_free = 1;
+	INIT_LIST_HEAD(&io->list_entry);
+	list_add(&io->list_entry, &io_pool->freelist);
+	spin_unlock_irqrestore(&io_pool->lock, flags);
+
+	if (hio)
+		efct_hw_io_free(&efct->hw, hio);
+
+	atomic_sub_return(1, &efct->xport->io_active_count);
+	atomic_add_return(1, &efct->xport->io_total_free);
+}
+
+/* Find an I/O given it's node and ox_id */
+struct efct_io *
+efct_io_find_tgt_io(struct efct *efct, struct efct_node *node,
+		    u16 ox_id, u16 rx_id)
+{
+	struct efct_io	*io = NULL;
+	unsigned long flags = 0;
+	u8 found = false;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	list_for_each_entry(io, &node->active_ios, list_entry) {
+		if ((io->cmd_tgt && io->init_task_tag == ox_id) &&
+		    (rx_id == 0xffff || io->tgt_task_tag == rx_id)) {
+			if (kref_get_unless_zero(&io->ref))
+				found = true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+	return found ? io : NULL;
+}
diff --git a/drivers/scsi/elx/efct/efct_io.h b/drivers/scsi/elx/efct/efct_io.h
new file mode 100644
index 000000000000..52e9c18fe887
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_io.h
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_IO_H__)
+#define __EFCT_IO_H__
+
+#include "efct_lio.h"
+
+#define EFCT_LOG_ENABLE_IO_ERRORS(efct)		\
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 6)) != 0) : 0)
+
+#define io_error_log(io, fmt, ...)  \
+	do { \
+		if (EFCT_LOG_ENABLE_IO_ERRORS(io->efct)) \
+			efc_log_warn(io->efct, fmt, ##__VA_ARGS__); \
+	} while (0)
+
+#define SCSI_CMD_BUF_LENGTH	48
+#define SCSI_RSP_BUF_LENGTH	(FCP_RESP_WITH_EXT + SCSI_SENSE_BUFFERSIZE)
+#define EFCT_NUM_SCSI_IOS	8192
+
+enum efct_io_type {
+	EFCT_IO_TYPE_IO = 0,
+	EFCT_IO_TYPE_ELS,
+	EFCT_IO_TYPE_CT,
+	EFCT_IO_TYPE_CT_RESP,
+	EFCT_IO_TYPE_BLS_RESP,
+	EFCT_IO_TYPE_ABORT,
+
+	EFCT_IO_TYPE_MAX,
+};
+
+enum efct_els_state {
+	EFCT_ELS_REQUEST = 0,
+	EFCT_ELS_REQUEST_DELAYED,
+	EFCT_ELS_REQUEST_DELAY_ABORT,
+	EFCT_ELS_REQ_ABORT,
+	EFCT_ELS_REQ_ABORTED,
+	EFCT_ELS_ABORT_IO_COMPL,
+};
+
+struct efct_io {
+	struct list_head	list_entry;
+	struct list_head	io_pending_link;
+	/* reference counter and callback function */
+	struct kref		ref;
+	void (*release)(struct kref *arg);
+	/* pointer back to efct */
+	struct efct		*efct;
+	/* unique instance index value */
+	u32			instance_index;
+	/* display name */
+	const char		*display_name;
+	/* pointer to node */
+	struct efct_node	*node;
+	/* (io_pool->io_free_list) free list link */
+	/* initiator task tag (OX_ID) for back-end and SCSI logging */
+	u32			init_task_tag;
+	/* target task tag (RX_ID) - for back-end and SCSI logging */
+	u32			tgt_task_tag;
+	/* HW layer unique IO id - for back-end and SCSI logging */
+	u32			hw_tag;
+	/* unique IO identifier */
+	u32			tag;
+	/* SGL */
+	struct efct_scsi_sgl	*sgl;
+	/* Number of allocated SGEs */
+	u32			sgl_allocated;
+	/* Number of SGEs in this SGL */
+	u32			sgl_count;
+	/* backend target private IO data */
+	struct efct_scsi_tgt_io tgt_io;
+	/* expected data transfer length, based on FC header */
+	u32			exp_xfer_len;
+
+	/* Declarations private to HW/SLI */
+	void			*hw_priv;
+
+	/* indicates what this struct efct_io structure is used for */
+	enum efct_io_type	io_type;
+	struct efct_hw_io	*hio;
+	size_t			transferred;
+
+	/* set if auto_trsp was set */
+	bool			auto_resp;
+	/* set if low latency request */
+	bool			low_latency;
+	/* selected WQ steering request */
+	u8			wq_steering;
+	/* selected WQ class if steering is class */
+	u8			wq_class;
+	/* transfer size for current request */
+	u64			xfer_req;
+	/* target callback function */
+	efct_scsi_io_cb_t	scsi_tgt_cb;
+	/* target callback function argument */
+	void			*scsi_tgt_cb_arg;
+	/* abort callback function */
+	efct_scsi_io_cb_t	abort_cb;
+	/* abort callback function argument */
+	void			*abort_cb_arg;
+	/* BLS callback function */
+	efct_scsi_io_cb_t	bls_cb;
+	/* BLS callback function argument */
+	void			*bls_cb_arg;
+	/* TMF command being processed */
+	enum efct_scsi_tmf_cmd	tmf_cmd;
+	/* rx_id from the ABTS that initiated the command abort */
+	u16			abort_rx_id;
+
+	/* True if this is a Target command */
+	bool			cmd_tgt;
+	/* when aborting, indicates ABTS is to be sent */
+	bool			send_abts;
+	/* True if this is an Initiator command */
+	bool			cmd_ini;
+	/* True if local node has sequence initiative */
+	bool			seq_init;
+	/* iparams for hw io send call */
+	union efct_hw_io_param_u iparam;
+	/* HW IO type */
+	enum efct_hw_io_type	hio_type;
+	/* wire length */
+	u64			wire_len;
+	/* saved HW callback */
+	void			*hw_cb;
+
+	/* for abort handling */
+	/* pointer to IO to abort */
+	struct efct_io		*io_to_abort;
+
+	/* SCSI Response buffer */
+	struct efc_dma		rspbuf;
+	/* Timeout value in seconds for this IO */
+	u32			timeout;
+	/* CS_CTL priority for this IO */
+	u8			cs_ctl;
+	/* Is io object in freelist > */
+	u8			io_free;
+	u32			app_id;
+};
+
+struct efct_io_cb_arg {
+	int status;		/* completion status */
+	int ext_status;		/* extended completion status */
+	void *app;		/* application argument */
+};
+
+struct efct_io_pool *
+efct_io_pool_create(struct efct *efct, u32 num_sgl);
+int
+efct_io_pool_free(struct efct_io_pool *io_pool);
+u32
+efct_io_pool_allocated(struct efct_io_pool *io_pool);
+
+struct efct_io *
+efct_io_pool_io_alloc(struct efct_io_pool *io_pool);
+void
+efct_io_pool_io_free(struct efct_io_pool *io_pool, struct efct_io *io);
+struct efct_io *
+efct_io_find_tgt_io(struct efct *efct, struct efct_node *node,
+		    u16 ox_id, u16 rx_id);
+#endif /* __EFCT_IO_H__ */
-- 
2.26.2

