Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FA0C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C65F235FF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbhAGXBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbhAGXBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 18:01:13 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1953C0612A7
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2021 14:59:31 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id q20so1713243pfu.8
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 14:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aL8dP+fHg8BUhmzE8eO6HH19ZMW92ZmKxkMjUYWEEyk=;
        b=gWsOb2dG7u8zL/5C+7kEFSrqODpYZkEmBoeOi9o890cZUOGuR1jGeykhVNCWPy4Rcd
         3Jd6+IOEU/bsdXGjIC4bqpC0hyZ8mHJOp6Ak5jaI5Pf+t0lAsph2aRZdXXGwXUxs6Kar
         wIX2w2eLwR2McubgY28fXg90OhS1uvNLkQvlk7hZqrUTOHaCGS8NVRwx1g8MCHg2qqqO
         RTHiwfKJtFOj2lu3vvvPPL48ECoKehLJYK99+gfgLuaBKo/ani80hger0XAoKxZ9ROB6
         VjDRahhqAuO5YLmafJRmFTbiQoBsUo1NWM5o4KZrbmU5ud06cACeDPx21shQ7ojVerkg
         53hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aL8dP+fHg8BUhmzE8eO6HH19ZMW92ZmKxkMjUYWEEyk=;
        b=Nvgy1vlZBOpOgDF/eVV8x2yLgGF7MVtcUE54cbPKbj1OIlI48LSjqYzTjDXFDcgkf3
         iAblpbcIs9IynotR+We3xjCQEflixxBpWwHn6evcqMB5TUpvGr3M4TXLwNtApjY411MP
         dn2gn1rI9wZag8XKKL/snE5/b9YxXXaMQCfAXws9GA+0QZ57Ywrw8oyO0mlTB1lUDkH5
         R9TMgCDd0XHNs0KzgWDF2Seu9R8jZPR5r0kY8v8bd0bg/03uIS2qVpbxCouSq4HBHX9d
         D/ZlGdNj1Z+N8pjEDVxgLSaKtxsi7Bq2IgOgzyzUcnZQBp2C80TEk32qx1/l12EJP43W
         n8Eg==
X-Gm-Message-State: AOAM531X9PhI34KOTiNdc3rA8cdPqUJFYPKynhrMt//fpUgRcKrEV41B
        97oZXlpPPlzOXRdc/ONN2xZfaAqymEgVew==
X-Google-Smtp-Source: ABdhPJx8/91lABPMwvzp4I59jieEJEjIDe3nLV4dZVjmNRUKMl5F8RB/ae8XiW3dt4K3KsEdbPjNqA==
X-Received: by 2002:a62:f948:0:b029:1ad:c27d:2b9e with SMTP id g8-20020a62f9480000b02901adc27d2b9emr715095pfm.33.1610060371051;
        Thu, 07 Jan 2021 14:59:31 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l197sm6881405pfd.97.2021.01.07.14.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:59:30 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v7 21/31] elx: efct: Hardware IO and SGL initialization
Date:   Thu,  7 Jan 2021 14:58:55 -0800
Message-Id: <20210107225905.18186-22-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107225905.18186-1-jsmart2021@gmail.com>
References: <20210107225905.18186-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to create IO interfaces (wqs, etc), SGL initialization,
and configure hardware features.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/elx/efct/efct_hw.c | 590 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  41 +++
 2 files changed, 631 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 451a5729bff4..da4e53407b94 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1565,3 +1565,593 @@ efct_issue_mbox_rqst(void *base, void *cmd, void *cb, void *arg)
 	}
 	return EFC_SUCCESS;
 }
+
+static inline struct efct_hw_io *
+_efct_hw_io_alloc(struct efct_hw *hw)
+{
+	struct efct_hw_io *io = NULL;
+
+	if (!list_empty(&hw->io_free)) {
+		io = list_first_entry(&hw->io_free, struct efct_hw_io,
+				      list_entry);
+		list_del(&io->list_entry);
+	}
+	if (io) {
+		INIT_LIST_HEAD(&io->list_entry);
+		list_add_tail(&io->list_entry, &hw->io_inuse);
+		io->state = EFCT_HW_IO_STATE_INUSE;
+		io->abort_reqtag = U32_MAX;
+		io->wq = hw->wq_cpu_array[raw_smp_processor_id()];
+		if (!io->wq) {
+			efc_log_err(hw->os, "WQ not assigned for cpu:%d\n",
+					raw_smp_processor_id());
+			io->wq = hw->hw_wq[0];
+		}
+		kref_init(&io->ref);
+		io->release = efct_hw_io_free_internal;
+	} else {
+		atomic_add_return(1, &hw->io_alloc_failed_count);
+	}
+
+	return io;
+}
+
+struct efct_hw_io *
+efct_hw_io_alloc(struct efct_hw *hw)
+{
+	struct efct_hw_io *io = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&hw->io_lock, flags);
+	io = _efct_hw_io_alloc(hw);
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+
+	return io;
+}
+
+static void
+efct_hw_io_free_move_correct_list(struct efct_hw *hw,
+				  struct efct_hw_io *io)
+{
+
+	/*
+	 * When an IO is freed, depending on the exchange busy flag,
+	 * move it to the correct list.
+	 */
+	if (io->xbusy) {
+		/*
+		 * add to wait_free list and wait for XRI_ABORTED CQEs to clean
+		 * up
+		 */
+		INIT_LIST_HEAD(&io->list_entry);
+		list_add_tail(&io->list_entry, &hw->io_wait_free);
+		io->state = EFCT_HW_IO_STATE_WAIT_FREE;
+	} else {
+		/* IO not busy, add to free list */
+		INIT_LIST_HEAD(&io->list_entry);
+		list_add_tail(&io->list_entry, &hw->io_free);
+		io->state = EFCT_HW_IO_STATE_FREE;
+	}
+}
+
+static inline void
+efct_hw_io_free_common(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	/* initialize IO fields */
+	efct_hw_init_free_io(io);
+
+	/* Restore default SGL */
+	efct_hw_io_restore_sgl(hw, io);
+}
+
+void
+efct_hw_io_free_internal(struct kref *arg)
+{
+	unsigned long flags = 0;
+	struct efct_hw_io *io =	container_of(arg, struct efct_hw_io, ref);
+	struct efct_hw *hw = io->hw;
+
+	/* perform common cleanup */
+	efct_hw_io_free_common(hw, io);
+
+	spin_lock_irqsave(&hw->io_lock, flags);
+	/* remove from in-use list */
+	if (!list_empty(&io->list_entry) && !list_empty(&hw->io_inuse)) {
+		list_del_init(&io->list_entry);
+		efct_hw_io_free_move_correct_list(hw, io);
+	}
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+}
+
+int
+efct_hw_io_free(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	return kref_put(&io->ref, io->release);
+}
+
+struct efct_hw_io *
+efct_hw_io_lookup(struct efct_hw *hw, u32 xri)
+{
+	u32 ioindex;
+
+	ioindex = xri - hw->sli.ext[SLI4_RSRC_XRI].base[0];
+	return hw->io[ioindex];
+}
+
+enum efct_hw_rtn
+efct_hw_io_init_sges(struct efct_hw *hw, struct efct_hw_io *io,
+		     enum efct_hw_io_type type)
+{
+	struct sli4_sge	*data = NULL;
+	u32 i = 0;
+	u32 skips = 0;
+	u32 sge_flags = 0;
+
+	if (!io) {
+		efc_log_err(hw->os,
+			     "bad parameter hw=%p io=%p\n", hw, io);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* Clear / reset the scatter-gather list */
+	io->sgl = &io->def_sgl;
+	io->sgl_count = io->def_sgl_count;
+	io->first_data_sge = 0;
+
+	memset(io->sgl->virt, 0, 2 * sizeof(struct sli4_sge));
+	io->n_sge = 0;
+	io->sge_offset = 0;
+
+	io->type = type;
+
+	data = io->sgl->virt;
+
+	/*
+	 * Some IO types have underlying hardware requirements on the order
+	 * of SGEs. Process all special entries here.
+	 */
+	switch (type) {
+	case EFCT_HW_IO_TARGET_WRITE:
+
+		/* populate host resident XFER_RDY buffer */
+		sge_flags = le32_to_cpu(data->dw2_flags);
+		sge_flags &= (~SLI4_SGE_TYPE_MASK);
+		sge_flags |= (SLI4_SGE_TYPE_DATA << SLI4_SGE_TYPE_SHIFT);
+		data->buffer_address_high =
+			cpu_to_le32(upper_32_bits(io->xfer_rdy.phys));
+		data->buffer_address_low  =
+			cpu_to_le32(lower_32_bits(io->xfer_rdy.phys));
+		data->buffer_length = cpu_to_le32(io->xfer_rdy.size);
+		data->dw2_flags = cpu_to_le32(sge_flags);
+		data++;
+
+		skips = EFCT_TARGET_WRITE_SKIPS;
+
+		io->n_sge = 1;
+		break;
+	case EFCT_HW_IO_TARGET_READ:
+		/*
+		 * For FCP_TSEND64, the first 2 entries are SKIP SGE's
+		 */
+		skips = EFCT_TARGET_READ_SKIPS;
+		break;
+	case EFCT_HW_IO_TARGET_RSP:
+		/*
+		 * No skips, etc. for FCP_TRSP64
+		 */
+		break;
+	default:
+		efc_log_err(hw->os, "unsupported IO type %#x\n", type);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Write skip entries
+	 */
+	for (i = 0; i < skips; i++) {
+		sge_flags = le32_to_cpu(data->dw2_flags);
+		sge_flags &= (~SLI4_SGE_TYPE_MASK);
+		sge_flags |= (SLI4_SGE_TYPE_SKIP << SLI4_SGE_TYPE_SHIFT);
+		data->dw2_flags = cpu_to_le32(sge_flags);
+		data++;
+	}
+
+	io->n_sge += skips;
+
+	/*
+	 * Set last
+	 */
+	sge_flags = le32_to_cpu(data->dw2_flags);
+	sge_flags |= SLI4_SGE_LAST;
+	data->dw2_flags = cpu_to_le32(sge_flags);
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_io_add_sge(struct efct_hw *hw, struct efct_hw_io *io,
+		   uintptr_t addr, u32 length)
+{
+	struct sli4_sge	*data = NULL;
+	u32 sge_flags = 0;
+
+	if (!io || !addr || !length) {
+		efc_log_err(hw->os,
+			     "bad parameter hw=%p io=%p addr=%lx length=%u\n",
+			    hw, io, addr, length);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (length > hw->sli.sge_supported_length) {
+		efc_log_err(hw->os,
+			     "length of SGE %d bigger than allowed %d\n",
+			    length, hw->sli.sge_supported_length);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	data = io->sgl->virt;
+	data += io->n_sge;
+
+	sge_flags = le32_to_cpu(data->dw2_flags);
+	sge_flags &= ~SLI4_SGE_TYPE_MASK;
+	sge_flags |= SLI4_SGE_TYPE_DATA << SLI4_SGE_TYPE_SHIFT;
+	sge_flags &= ~SLI4_SGE_DATA_OFFSET_MASK;
+	sge_flags |= SLI4_SGE_DATA_OFFSET_MASK & io->sge_offset;
+
+	data->buffer_address_high = cpu_to_le32(upper_32_bits(addr));
+	data->buffer_address_low  = cpu_to_le32(lower_32_bits(addr));
+	data->buffer_length = cpu_to_le32(length);
+
+	/*
+	 * Always assume this is the last entry and mark as such.
+	 * If this is not the first entry unset the "last SGE"
+	 * indication for the previous entry
+	 */
+	sge_flags |= SLI4_SGE_LAST;
+	data->dw2_flags = cpu_to_le32(sge_flags);
+
+	if (io->n_sge) {
+		sge_flags = le32_to_cpu(data[-1].dw2_flags);
+		sge_flags &= ~SLI4_SGE_LAST;
+		data[-1].dw2_flags = cpu_to_le32(sge_flags);
+	}
+
+	/* Set first_data_bde if not previously set */
+	if (io->first_data_sge == 0)
+		io->first_data_sge = io->n_sge;
+
+	io->sge_offset += length;
+	io->n_sge++;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+void
+efct_hw_io_abort_all(struct efct_hw *hw)
+{
+	struct efct_hw_io *io_to_abort	= NULL;
+	struct efct_hw_io *next_io = NULL;
+
+	list_for_each_entry_safe(io_to_abort, next_io,
+				 &hw->io_inuse, list_entry) {
+		efct_hw_io_abort(hw, io_to_abort, true, NULL, NULL);
+	}
+}
+
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
+	    ext == SLI4_FC_LOCAL_REJECT_NO_XRI && io->done) {
+		efct_hw_done_t done = io->done;
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
+		done(io, len, status, ext, io->arg);
+	}
+
+	if (io->abort_done) {
+		efct_hw_done_t done = io->abort_done;
+
+		io->abort_done = NULL;
+		done(io, len, status, ext, io->abort_arg);
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
+static void
+efct_hw_fill_abort_wqe(struct efct_hw *hw, struct efct_hw_wqe *wqe)
+{
+	struct sli4_abort_wqe *abort = (void *)wqe->wqebuf;
+
+	memset(abort, 0, hw->sli.wqe_size);
+
+	abort->criteria = SLI4_ABORT_CRITERIA_XRI_TAG;
+	abort->ia_ir_byte |= wqe->send_abts ? 0 : 1;
+
+	/* Suppress ABTS retries */
+	abort->ia_ir_byte |= SLI4_ABRT_WQE_IR;
+
+	abort->t_tag  = cpu_to_le32(wqe->id);
+	abort->command = SLI4_WQE_ABORT;
+	abort->request_tag = cpu_to_le16(wqe->abort_reqtag);
+
+	abort->dw10w0_flags = cpu_to_le16(SLI4_ABRT_WQE_QOSD);
+
+	abort->cq_id = cpu_to_le16(SLI4_CQ_DEFAULT);
+}
+
+enum efct_hw_rtn
+efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
+		 bool send_abts, void *cb, void *arg)
+{
+	struct hw_wq_callback *wqcb;
+	unsigned long flags = 0;
+
+	if (!io_to_abort) {
+		efc_log_err(hw->os,
+			     "bad parameter hw=%p io=%p\n",
+			    hw, io_to_abort);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_err(hw->os, "cannot send IO abort, HW state=%d\n",
+			     hw->state);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* take a reference on IO being aborted */
+	if (kref_get_unless_zero(&io_to_abort->ref) == 0) {
+		/* command no longer active */
+		efc_log_debug(hw->os,
+			      "io not active xri=0x%x tag=0x%x\n",
+			     io_to_abort->indicator, io_to_abort->reqtag);
+		return EFCT_HW_RTN_IO_NOT_ACTIVE;
+	}
+
+	/* Must have a valid WQ reference */
+	if (!io_to_abort->wq) {
+		efc_log_debug(hw->os, "io_to_abort xri=0x%x not active on WQ\n",
+			      io_to_abort->indicator);
+		/* efct_ref_get(): same function */
+		kref_put(&io_to_abort->ref, io_to_abort->release);
+		return EFCT_HW_RTN_IO_NOT_ACTIVE;
+	}
+
+	/*
+	 * Validation checks complete; now check to see if already being
+	 * aborted
+	 */
+	spin_lock_irqsave(&hw->io_abort_lock, flags);
+	if (io_to_abort->abort_in_progress) {
+		spin_unlock_irqrestore(&hw->io_abort_lock, flags);
+		/* efct_ref_get(): same function */
+		kref_put(&io_to_abort->ref, io_to_abort->release);
+		efc_log_debug(hw->os,
+			       "io already being aborted xri=0x%x tag=0x%x\n",
+			      io_to_abort->indicator, io_to_abort->reqtag);
+		return EFCT_HW_RTN_IO_ABORT_IN_PROGRESS;
+	}
+
+	/*
+	 * This IO is not already being aborted. Set flag so we won't try to
+	 * abort it again. After all, we only have one abort_done callback.
+	 */
+	io_to_abort->abort_in_progress = true;
+	spin_unlock_irqrestore(&hw->io_abort_lock, flags);
+
+	/*
+	 * If we got here, the possibilities are:
+	 * - host owned xri
+	 *	- io_to_abort->wq_index != U32_MAX
+	 *		- submit ABORT_WQE to same WQ
+	 * - port owned xri:
+	 *	- rxri: io_to_abort->wq_index == U32_MAX
+	 *		- submit ABORT_WQE to any WQ
+	 *	- non-rxri
+	 *		- io_to_abort->index != U32_MAX
+	 *			- submit ABORT_WQE to same WQ
+	 *		- io_to_abort->index == U32_MAX
+	 *			- submit ABORT_WQE to any WQ
+	 */
+	io_to_abort->abort_done = cb;
+	io_to_abort->abort_arg  = arg;
+
+	/* Allocate a request tag for the abort portion of this IO */
+	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
+	if (!wqcb) {
+		efc_log_err(hw->os, "can't allocate request tag\n");
+		return EFCT_HW_RTN_NO_RESOURCES;
+	}
+
+	io_to_abort->abort_reqtag = wqcb->instance_index;
+	io_to_abort->wqe.send_abts = send_abts;
+	io_to_abort->wqe.id = io_to_abort->indicator;
+	io_to_abort->wqe.abort_reqtag = io_to_abort->abort_reqtag;
+
+	/*
+	 * If the wqe is on the pending list, then set this wqe to be
+	 * aborted when the IO's wqe is removed from the list.
+	 */
+	if (io_to_abort->wq) {
+		spin_lock_irqsave(&io_to_abort->wq->queue->lock, flags);
+		if (io_to_abort->wqe.list_entry.next) {
+			io_to_abort->wqe.abort_wqe_submit_needed = true;
+			spin_unlock_irqrestore(&io_to_abort->wq->queue->lock,
+					       flags);
+			return EFC_SUCCESS;
+		}
+		spin_unlock_irqrestore(&io_to_abort->wq->queue->lock, flags);
+	}
+
+	efct_hw_fill_abort_wqe(hw, &io_to_abort->wqe);
+
+	/* ABORT_WQE does not actually utilize an XRI on the Port,
+	 * therefore, keep xbusy as-is to track the exchange's state,
+	 * not the ABORT_WQE's state
+	 */
+	if (efct_hw_wq_write(io_to_abort->wq, &io_to_abort->wqe)) {
+		spin_lock_irqsave(&hw->io_abort_lock, flags);
+		io_to_abort->abort_in_progress = false;
+		spin_unlock_irqrestore(&hw->io_abort_lock, flags);
+		/* efct_ref_get(): same function */
+		kref_put(&io_to_abort->ref, io_to_abort->release);
+		return EFC_FAIL;
+	}
+
+	return EFC_SUCCESS;
+}
+
+void
+efct_hw_reqtag_pool_free(struct efct_hw *hw)
+{
+	u32 i;
+	struct reqtag_pool *reqtag_pool = hw->wq_reqtag_pool;
+	struct hw_wq_callback *wqcb = NULL;
+
+	if (reqtag_pool) {
+		for (i = 0; i < U16_MAX; i++) {
+			wqcb = reqtag_pool->tags[i];
+			if (!wqcb)
+				continue;
+
+			kfree(wqcb);
+		}
+		kfree(reqtag_pool);
+		hw->wq_reqtag_pool = NULL;
+	}
+}
+
+struct reqtag_pool *
+efct_hw_reqtag_pool_alloc(struct efct_hw *hw)
+{
+	u32 i = 0;
+	struct reqtag_pool *reqtag_pool;
+	struct hw_wq_callback *wqcb;
+
+	reqtag_pool = kzalloc(sizeof(*reqtag_pool), GFP_KERNEL);
+	if (!reqtag_pool)
+		return NULL;
+
+	INIT_LIST_HEAD(&reqtag_pool->freelist);
+	/* initialize reqtag pool lock */
+	spin_lock_init(&reqtag_pool->lock);
+	for (i = 0; i < U16_MAX; i++) {
+		wqcb = kmalloc(sizeof(*wqcb), GFP_KERNEL);
+		if (!wqcb)
+			break;
+
+		reqtag_pool->tags[i] = wqcb;
+		wqcb->instance_index = i;
+		wqcb->callback = NULL;
+		wqcb->arg = NULL;
+		INIT_LIST_HEAD(&wqcb->list_entry);
+		list_add_tail(&wqcb->list_entry, &reqtag_pool->freelist);
+	}
+
+	return reqtag_pool;
+}
+
+struct hw_wq_callback *
+efct_hw_reqtag_alloc(struct efct_hw *hw,
+		     void (*callback)(void *arg, u8 *cqe, int status),
+		     void *arg)
+{
+	struct hw_wq_callback *wqcb = NULL;
+	struct reqtag_pool *reqtag_pool = hw->wq_reqtag_pool;
+	unsigned long flags = 0;
+
+	if (!callback)
+		return wqcb;
+
+	spin_lock_irqsave(&reqtag_pool->lock, flags);
+
+	if (!list_empty(&reqtag_pool->freelist)) {
+		wqcb = list_first_entry(&reqtag_pool->freelist,
+				      struct hw_wq_callback, list_entry);
+	}
+
+	if (wqcb) {
+		list_del_init(&wqcb->list_entry);
+		spin_unlock_irqrestore(&reqtag_pool->lock, flags);
+		wqcb->callback = callback;
+		wqcb->arg = arg;
+	} else {
+		spin_unlock_irqrestore(&reqtag_pool->lock, flags);
+	}
+
+	return wqcb;
+}
+
+void
+efct_hw_reqtag_free(struct efct_hw *hw, struct hw_wq_callback *wqcb)
+{
+	unsigned long flags = 0;
+	struct reqtag_pool *reqtag_pool = hw->wq_reqtag_pool;
+
+	if (!wqcb->callback)
+		efc_log_err(hw->os, "WQCB is already freed\n");
+
+	spin_lock_irqsave(&reqtag_pool->lock, flags);
+	wqcb->callback = NULL;
+	wqcb->arg = NULL;
+	INIT_LIST_HEAD(&wqcb->list_entry);
+	list_add(&wqcb->list_entry, &hw->wq_reqtag_pool->freelist);
+	spin_unlock_irqrestore(&reqtag_pool->lock, flags);
+}
+
+struct hw_wq_callback *
+efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index)
+{
+	struct hw_wq_callback *wqcb;
+
+	wqcb = hw->wq_reqtag_pool->tags[instance_index];
+	if (!wqcb)
+		efc_log_err(hw->os, "wqcb for instance %d is null\n",
+			     instance_index);
+
+	return wqcb;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 76de5decfbea..dd00d4df6ada 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -628,4 +628,45 @@ efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb,
 int
 efct_issue_mbox_rqst(void *base, void *cmd, void *cb, void *arg);
 
+struct efct_hw_io *efct_hw_io_alloc(struct efct_hw *hw);
+int efct_hw_io_free(struct efct_hw *hw, struct efct_hw_io *io);
+u8 efct_hw_io_inuse(struct efct_hw *hw, struct efct_hw_io *io);
+enum efct_hw_rtn
+efct_hw_io_send(struct efct_hw *hw, enum efct_hw_io_type type,
+		struct efct_hw_io *io, union efct_hw_io_param_u *iparam,
+		void *cb, void *arg);
+enum efct_hw_rtn
+efct_hw_io_register_sgl(struct efct_hw *hw, struct efct_hw_io *io,
+			struct efc_dma *sgl,
+			u32 sgl_count);
+enum efct_hw_rtn
+efct_hw_io_init_sges(struct efct_hw *hw,
+		     struct efct_hw_io *io, enum efct_hw_io_type type);
+
+enum efct_hw_rtn
+efct_hw_io_add_sge(struct efct_hw *hw, struct efct_hw_io *io,
+		   uintptr_t addr, u32 length);
+enum efct_hw_rtn
+efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
+		 bool send_abts, void *cb, void *arg);
+u32
+efct_hw_io_get_count(struct efct_hw *hw,
+		     enum efct_hw_io_count_type io_count_type);
+struct efct_hw_io
+*efct_hw_io_lookup(struct efct_hw *hw, u32 indicator);
+void efct_hw_io_abort_all(struct efct_hw *hw);
+void efct_hw_io_free_internal(struct kref *arg);
+
+/* HW WQ request tag API */
+struct reqtag_pool *efct_hw_reqtag_pool_alloc(struct efct_hw *hw);
+void efct_hw_reqtag_pool_free(struct efct_hw *hw);
+struct hw_wq_callback
+*efct_hw_reqtag_alloc(struct efct_hw *hw,
+			void (*callback)(void *arg, u8 *cqe,
+					 int status), void *arg);
+void
+efct_hw_reqtag_free(struct efct_hw *hw, struct hw_wq_callback *wqcb);
+struct hw_wq_callback
+*efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index);
+
 #endif /* __EFCT_H__ */
-- 
2.26.2

