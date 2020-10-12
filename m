Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6215DC43467
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 040F92073A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VEdSu3Bu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390827AbgJLWwe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390748AbgJLWwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36FCC0613D7
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:28 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e10so15131017pfj.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=IHjMNUnwzMR272Rkimlnir5XqvTsEzCjdAooWkr6HV4=;
        b=VEdSu3BuQrthw5BV3DmD2FzWNRwBwv7AyomyYvOxIV4WPPwzrNT4+KXWz9xT0oySw/
         l+FkJpoAEqhf2kHhZ/Ob6qz8elylX7KECuK7ybJ9BcKlQIoUbeWNoNDWXHfPLFat9qY1
         PkJYkiyab9atuppK1Y0ihOjAAMysYtvppb5Q0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=IHjMNUnwzMR272Rkimlnir5XqvTsEzCjdAooWkr6HV4=;
        b=BMsUkrEhmFomuJ+0sDpKpJEGS5zrWxc5hG0UWqIOqSw+gu9AKI1RDBw4kqIn+IGHFd
         ov2mf5AMe9MP07tBIZHf0cPXJsSsF99UUrR+Gsx0kq2agrI0fKUXkgVfl9Ky1/sPomff
         nJk2DSEbh8KoA67KoHE2RgKzbNP61YsccqrbxMgmM1kwNwdmj34zSOTRxe8OYzdl/KPf
         YgSX7i8BJ6hlNBr//3i5pl235sNiqn2x8DytAK2UeGHuuk0siiuIv2UJV/igPalJHPEx
         ITHJbXSphDXrAWjTYvN48i6DUXUFmcqtiYl2MYE9d/eQ2b9ahQoO/SFdICnSQUW8848r
         Qevg==
X-Gm-Message-State: AOAM531b6QRnWbrrKxpHRVhbEWfix35rxU/hTdbyzadPx16b7XIbMbvu
        4TwVbrtPCSP3Nsab/ovd0rvm1s+wbLo2RuJTaQCO/qVVnq8i/9dbrIEgtuKsRJ+96aOwBmJBMD1
        klj6vUOC8EXIHK/bWd039T3nYTCn/SmsOVqZSF7yNeP8gw4dJIfY4RvtxfvOTOZlf0M3bopy1ww
        JZK+k=
X-Google-Smtp-Source: ABdhPJzU1jIYiZR4lAFi5wuogjGNJwSYkDfIFrCMSg/MKd+X6QTWdtP1zsDG66XhXnj+wHqvho2T7A==
X-Received: by 2002:a63:40c1:: with SMTP id n184mr7274928pga.215.1602543147251;
        Mon, 12 Oct 2020 15:52:27 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:26 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 22/31] elx: efct: Hardware queues processing
Date:   Mon, 12 Oct 2020 15:51:38 -0700
Message-Id: <20201012225147.54404-23-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000012b3e505b181270c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000012b3e505b181270c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines for EQ, CQ, WQ and RQ processing.
Routines for IO object pool allocation and deallocation.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Remove els entries from scsi io object, as discovery IO object handles
     all els.
  scsi io takes efct_node object refernce and releases when IO is done.
---
 drivers/scsi/elx/efct/efct_hw.c | 366 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  38 ++++
 drivers/scsi/elx/efct/efct_io.c | 191 +++++++++++++++++
 drivers/scsi/elx/efct/efct_io.h | 166 +++++++++++++++
 4 files changed, 761 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_io.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.h

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 3df46eb20fa1..7764f16b2bed 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2165,3 +2165,369 @@ efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index)
 
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
+		list_del(&wqe->list_entry);
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
+			list_del(&io->list_entry);
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
index f90f78ab73d8..ab9a86ded815 100644
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
index 000000000000..3398e0240d2e
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
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
+		list_del(&io->list_entry);
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
index 000000000000..8e4df9fcf9df
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_io.h
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
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


--00000000000012b3e505b181270c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg7Wfcsw2/QHDMJGYp
G+3fZVrkIeBF3j+BQdH2X3xiIXMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjI3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABDemEdFe5PxNRUa2kVTiLsG3y+J7hFUevc5
8JsI4SRfmba+v+TJdDR+lduXy3WRM612tqm6eteeMOeh3gOLK+Nld5JqffmiBTLYpxivQY988KBJ
O2vqgT8dC6D/efdkLMtIYwoO7J9LoBr0o7OQviEmPVsIEnVkojidEEd0V5iypuD07vygtbfiTaAb
jLHZxE0yEki7tWd6yEMT+UAyCapybwClRXG/vrr22B6julAMWCIRPK26c+fWVFksAKkw321l3/Hn
2riGtF3nLJu+ov51PQaR9m4k8h5xkTTrXtdUZGqSVKtdysrBJUzfYWTNlK7WTJcdQDgkQF+ynABT
/fU=
--00000000000012b3e505b181270c--
