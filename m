Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF07C3F68F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A3752146E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RRelbMYD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfLTWh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:57 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40103 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfLTWh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:57 -0500
Received: by mail-pj1-f65.google.com with SMTP id bg7so4258133pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fca7CQuNMKVvP30zioXs+a2WV+7E5ZTS3DTql3nWslM=;
        b=RRelbMYD+zUzbyDKZiAqW3+7DnN2PnckUBG1RKDxmSCbKCqskESzyzYLOOW1/6Y7ft
         AcSIp+izr6FEtV/u9kuQzVO6Dj+XLIOUVkoGxvQ8fDjrw0cWLvYj6AtH4r4sGB1ILSay
         OAu6J3OZdgIbHDHTcYMua+Vbu29HIhyUS3ue4Tfnraq05klWM+C7YFFc5e/Xs2r1bQD0
         TJybVn7mMWpMgEO/G1iNqIXbLx34minnkyBFIn7t53SykTTBgBW9IVn7KdS7KQ7HB1TO
         ejXAj4XDB6KoiJgdLBzkfo8mPKgL92eiBKQPE2wArVOR4WuxdEuc8tUfhLmPgFJA6mrD
         yGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fca7CQuNMKVvP30zioXs+a2WV+7E5ZTS3DTql3nWslM=;
        b=gybjkNWiZpILXpYbFRd5b+vrIxJf8xhPCqCVkrH0gmmnHgxBW1UBrFV50ih/kxRmnw
         PxKA05k6xrkA5k4l6rZOFdThzfi2R0SlSg1hMnHoeUxu8XCaFI94dAP3HQtH5glPyooI
         9a6x2deaJNtTdVpqEkxfTM29+m0+l8s91+P2/e4kTR3eafmWvObawPlAJbExzuQjmVc6
         THRQfjuMmEGbXza0zflAY6vd0bN1XRkgEm1rnpL6oXRU4W0kZrUdZX0RE5bUIkt7QDxk
         4z8ryIcFRJMWDAdDlG1qwR+s5Stq7CBECQ8ZEEw7gqDu+MMEd7OXrkqdtBaI9Qi+TuhS
         /o9w==
X-Gm-Message-State: APjAAAXYLYfzSxjs2lnzREmdYVYelmPFtX5zW1Sd0CdrYS3uzB41DzqD
        /iv+vMNP9IxYjc4/zBd9Y36ys9rF
X-Google-Smtp-Source: APXvYqzhUAbTm7269xfe+gGjU/EXPIbwKBq1K3oiLsZkWj1YX78MzfBFXAkV2Bg0ilYLXSPs3i5uDw==
X-Received: by 2002:a17:90a:2729:: with SMTP id o38mr17913782pje.45.1576881474781;
        Fri, 20 Dec 2019 14:37:54 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:54 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 20/32] elx: efct: Hardware queues processing
Date:   Fri, 20 Dec 2019 14:37:11 -0800
Message-Id: <20191220223723.26563-21-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/efct/efct_hw.c        | 531 +++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h        |  36 +++
 drivers/scsi/elx/efct/efct_hw_queues.c | 192 ++++++++++++
 drivers/scsi/elx/efct/efct_io.c        | 203 +++++++++++++
 drivers/scsi/elx/efct/efct_io.h        | 196 ++++++++++++
 5 files changed, 1158 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_io.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.h

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index beca8534813d..2f30c7322a62 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -258,6 +258,17 @@ efct_hw_init_free_io(struct efct_hw_io *io)
 	io->tgt_wqe_timeout = 0;
 }
 
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
 static void
 efct_hw_io_restore_sgl(struct efct_hw *hw, struct efct_hw_io *io)
 {
@@ -271,6 +282,127 @@ efct_hw_io_restore_sgl(struct efct_hw *hw, struct efct_hw_io *io)
 	io->ovfl_lsp = NULL;
 }
 
+static void
+efct_hw_wq_process_io(void *arg, u8 *cqe, int status)
+{
+	struct efct_hw_io *io = arg;
+	struct efct_hw *hw = io->hw;
+	struct sli4_fc_wcqe *wcqe = (void *)cqe;
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
+			enum efct_hw_rtn rc;
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
 /* Initialize the pool of HW IO objects */
 static enum efct_hw_rtn
 efct_hw_setup_io(struct efct_hw *hw)
@@ -704,6 +836,25 @@ efct_hw_set_dif_seed(struct efct_hw *hw)
 	return rc;
 }
 
+static void
+efct_hw_queue_hash_add(struct efct_queue_hash *hash,
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
 /* enable sli port health check */
 static enum efct_hw_rtn
 efct_hw_config_sli_port_health_check(struct efct_hw *hw, u8 query,
@@ -2630,6 +2781,73 @@ efct_hw_io_abort_all(struct efct_hw *hw)
 	}
 }
 
+static void
+efct_hw_wq_process_abort(void *arg, u8 *cqe, int status)
+{
+	struct efct_hw_io *io = arg;
+	struct efct_hw *hw = io->hw;
+	u32 ext = 0;
+	u32 len = 0;
+	struct hw_wq_callback *wqcb;
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
+		void *arg = io->arg;
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
 enum efct_hw_rtn
 efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
 		 bool send_abts, void *cb, void *arg)
@@ -2857,3 +3075,316 @@ efct_hw_reqtag_reset(struct efct_hw *hw)
 		efct_pool_put(hw->wq_reqtag_pool, wqcb);
 	}
 }
+
+int
+efct_hw_queue_hash_find(struct efct_queue_hash *hash, u16 id)
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
+		return 0;
+
+	/* Get pointer to struct hw_eq */
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
+int
+efct_hw_eq_process(struct efct_hw *hw, struct hw_eq *eq,
+		   u32 max_isr_time_msec)
+{
+	u8		eqe[sizeof(struct sli4_eqe)] = { 0 };
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
+void
+efct_hw_cq_process(struct efct_hw *hw, struct hw_cq *cq)
+{
+	u8		cqe[sizeof(struct sli4_mcqe)];
+	u16	rid = U16_MAX;
+	enum sli4_qentry	ctype;		/* completion type */
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
+efct_hw_flush(struct efct_hw *hw)
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
index 9e4ac83a81d4..55679e40cc49 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -916,4 +916,40 @@ extern struct hw_wq_callback
 *efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index);
 void efct_hw_reqtag_reset(struct efct_hw *hw);
 
+/* RQ completion handlers for RQ pair mode */
+extern int
+efct_hw_rqpair_process_rq(struct efct_hw *hw,
+			  struct hw_cq *cq, u8 *cqe);
+extern
+enum efct_hw_rtn efct_hw_rqpair_sequence_free(struct efct_hw *hw,
+						struct efc_hw_sequence *seq);
+static inline void
+efct_hw_sequence_copy(struct efc_hw_sequence *dst,
+		      struct efc_hw_sequence *src)
+{
+	/* Copy src to dst, then zero out the linked list link */
+	*dst = *src;
+}
+
+static inline enum efct_hw_rtn
+efct_hw_sequence_free(struct efct_hw *hw, struct efc_hw_sequence *seq)
+{
+	/* Only RQ pair mode is supported */
+	return efct_hw_rqpair_sequence_free(hw, seq);
+}
+extern int
+efct_hw_eq_process(struct efct_hw *hw, struct hw_eq *eq,
+		   u32 max_isr_time_msec);
+void efct_hw_cq_process(struct efct_hw *hw, struct hw_cq *cq);
+extern void
+efct_hw_wq_process(struct efct_hw *hw, struct hw_cq *cq,
+		   u8 *cqe, int status, u16 rid);
+extern void
+efct_hw_xabt_process(struct efct_hw *hw, struct hw_cq *cq,
+		     u8 *cqe, u16 rid);
+extern int
+efct_hw_process(struct efct_hw *hw, u32 vector, u32 max_isr_time_msec);
+extern int
+efct_hw_queue_hash_find(struct efct_queue_hash *hash, u16 id);
+
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_hw_queues.c b/drivers/scsi/elx/efct/efct_hw_queues.c
index 8bbeef8ad22d..ac266fe9db19 100644
--- a/drivers/scsi/elx/efct/efct_hw_queues.c
+++ b/drivers/scsi/elx/efct/efct_hw_queues.c
@@ -1454,3 +1454,195 @@ efct_hw_qtop_free(struct efct_hw_qtop *qtop)
 		kfree(qtop);
 	}
 }
+
+static inline int
+efct_hw_rqpair_find(struct efct_hw *hw, u16 rq_id)
+{
+	return efct_hw_queue_hash_find(hw->rq_hash, rq_id);
+}
+
+static struct efc_hw_sequence *
+efct_hw_rqpair_get(struct efct_hw *hw, u16 rqindex, u16 bufindex)
+{
+	struct sli4_queue *rq_hdr = &hw->rq[rqindex];
+	struct efc_hw_sequence *seq = NULL;
+	struct hw_rq *rq = hw->hw_rq[hw->hw_rq_lookup[rqindex]];
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
+
+int
+efct_hw_rqpair_process_rq(struct efct_hw *hw, struct hw_cq *cq,
+			  u8 *cqe)
+{
+	u16 rq_id;
+	u32 index;
+	int rqindex;
+	int	 rq_status;
+	u32 h_len;
+	u32 p_len;
+	struct efc_hw_sequence *seq;
+	struct hw_rq *rq;
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
+
+static int
+efct_hw_rqpair_put(struct efct_hw *hw, struct efc_hw_sequence *seq)
+{
+	struct sli4_queue *rq_hdr = &hw->rq[seq->header->rqindex];
+	struct sli4_queue *rq_payload = &hw->rq[seq->payload->rqindex];
+	u32 hw_rq_index = hw->hw_rq_lookup[seq->header->rqindex];
+	struct hw_rq *rq = hw->hw_rq[hw_rq_index];
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
+enum efct_hw_rtn
+efct_hw_rqpair_sequence_free(struct efct_hw *hw,
+			     struct efc_hw_sequence *seq)
+{
+	enum efct_hw_rtn   rc = EFCT_HW_RTN_SUCCESS;
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
diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
new file mode 100644
index 000000000000..a31c18824ec7
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -0,0 +1,203 @@
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
+struct efct_io_pool {
+	struct efct *efct;
+	spinlock_t lock;	/* IO pool lock */
+	u32 io_num_ios;		/* Total IOs allocated */
+	struct efct_pool *pool;
+};
+
+struct efct_io_pool *
+efct_io_pool_create(struct efct *efct, u32 num_io, u32 num_sgl)
+{
+	u32 i = 0;
+	struct efct_io_pool *io_pool;
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
+	io_pool->pool = efct_pool_alloc(efct, sizeof(struct efct_io),
+					io_pool->io_num_ios);
+
+	for (i = 0; i < io_pool->io_num_ios; i++) {
+		struct efct_io *io = efct_pool_get_instance(io_pool->pool, i);
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
+			io = efct_pool_get_instance(io_pool->pool, i);
+			if (!io)
+				continue;
+
+			kfree(io->sgl);
+			dma_free_coherent(&efct->pcidev->dev,
+					  io->cmdbuf.size, io->cmdbuf.virt,
+					  io->cmdbuf.phys);
+			memset(&io->cmdbuf, 0, sizeof(struct efc_dma));
+			dma_free_coherent(&efct->pcidev->dev,
+					  io->rspbuf.size, io->rspbuf.virt,
+					  io->rspbuf.phys);
+			memset(&io->rspbuf, 0, sizeof(struct efc_dma));
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
+u32 efct_io_pool_allocated(struct efct_io_pool *io_pool)
+{
+	return io_pool->io_num_ios;
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
+/* Find an I/O given it's node and ox_id */
+struct efct_io *
+efct_io_find_tgt_io(struct efct *efct, struct efc_node *node,
+		    u16 ox_id, u16 rx_id)
+{
+	struct efct_io	*io = NULL;
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
+struct efct_io *
+efct_io_get_instance(struct efct *efct, u32 index)
+{
+	struct efct_xport *xport = efct->xport;
+	struct efct_io_pool *io_pool = xport->io_pool;
+
+	return efct_pool_get_instance(io_pool->pool, index);
+}
diff --git a/drivers/scsi/elx/efct/efct_io.h b/drivers/scsi/elx/efct/efct_io.h
new file mode 100644
index 000000000000..06784a8afcb1
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_io.h
@@ -0,0 +1,196 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_IO_H__)
+#define __EFCT_IO_H__
+
+#include "efct_lio.h"
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
+	struct efc_node		*node;
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
+	/* HW formatted DIF parameters */
+	struct efct_hw_dif_info hw_dif;
+	/* DIF info saved for DIF error recovery */
+	struct efct_scsi_dif_info scsi_dif_info;
+	/* HW IO type */
+	enum efct_hw_io_type	hio_type;
+	/* wire length */
+	u64			wire_len;
+	/* saved HW callback */
+	void			*hw_cb;
+	/* Overflow SGL */
+	struct efc_dma		ovfl_sgl;
+
+	/* for ELS requests/responses */
+	/* True if ELS is pending */
+	bool			els_pend;
+	/* True if ELS is active */
+	bool			els_active;
+	/* ELS request payload buffer */
+	struct efc_dma		els_req;
+	/* ELS response payload buffer */
+	struct efc_dma		els_rsp;
+	bool			els_req_free;
+	/* Retries remaining */
+	u32			els_retries_remaining;
+	void (*els_callback)(struct efc_node *node,
+			     struct efc_node_cb *cbdata, void *cbarg);
+	void			*els_callback_arg;
+	/* timeout */
+	u32			els_timeout_sec;
+
+	/* delay timer */
+	struct timer_list	delay_timer;
+
+	/* for abort handling */
+	/* pointer to IO to abort */
+	struct efct_io		*io_to_abort;
+
+	enum efct_els_state	state;
+	/* Protects els cmds */
+	spinlock_t		els_lock;
+
+	/* SCSI Command buffer, used for CDB (initiator) */
+	struct efc_dma		cmdbuf;
+	/* SCSI Response buffer (i+t) */
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
+efct_io_pool_create(struct efct *efct, u32 num_io, u32 num_sgl);
+extern int
+efct_io_pool_free(struct efct_io_pool *io_pool);
+extern u32
+efct_io_pool_allocated(struct efct_io_pool *io_pool);
+
+extern struct efct_io *
+efct_io_pool_io_alloc(struct efct_io_pool *io_pool);
+extern void
+efct_io_pool_io_free(struct efct_io_pool *io_pool, struct efct_io *io);
+extern struct efct_io *
+efct_io_find_tgt_io(struct efct *efct, struct efc_node *node,
+		    u16 ox_id, u16 rx_id);
+#endif /* __EFCT_IO_H__ */
-- 
2.13.7

