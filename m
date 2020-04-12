Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2221BC2BB55
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7B9220739
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOrSK419"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgDLDdr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:47 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37898 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgDLDdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:46 -0400
Received: by mail-pj1-f67.google.com with SMTP id t40so2442107pjb.3
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iGs/rsqE1BsvT2j8zbDUEggTPorMzoCuIHg7qEbGEc0=;
        b=OOrSK419+aUR8z+saklXzHEo+UHHeVj83TynB5S40TL2xQGONy2WaRhlc0I2Zvc95X
         S9LIC+9HVffg9Asg9OE8iT2s5vTvoiziAdvQ2LgJkXk4QK3EeEvA692y8BOnIRmGvw+W
         K4j5suL3xCAMITFG7tEHf6RRcSFe8Iec8Qr8cothOSLpeDycl5JJDmoDv74axvWAxEwe
         EaSc4SJincpl3QMi2N6HpbZGw1C7YuZBFJ3sAnjQ8yz93vBz3AZoVFwqKNxLxBSB26Gk
         NGGQ59GiT95noiIh9cGTzwCGLiGSQD9kbGdmTc48ygQMqyt7wCTGZ48d9NbUMpqm5HJm
         MM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iGs/rsqE1BsvT2j8zbDUEggTPorMzoCuIHg7qEbGEc0=;
        b=uYWsbd93+00NR/niQtSDtu2vnRHRL8YiDMpkoJgiVVGosF6UtA8IOekFUaZ437JarC
         ScsGGLpNcjR90/vGx6iWZ9LT8539iQbUqON5MD377sPWQaP7WtN+R6ui+/dpIOqzYk6L
         nydGVKAWSYmZKnebZMsdGrCcyIxwPf/471emWPA90VEFydzQE416uzuxkBCzuvTEifEx
         lyPMItioeopXOc3xDJsDSwpplsBzxoYtE7WjGPfjq7wcgQpxOwisExJqvTE+AglhID5q
         ELjTIWunlSGbLHb2q4mv5bpJ6z0ZYSR+Swb9Ez/fZ10fpLaooZVtiquYrqRmb/FsC8VR
         fzdQ==
X-Gm-Message-State: AGi0PuYLT3vsSibLtBddQgkIP+2kHu+a1hKERvoFFB6iLXMVo2w9KUik
        cWSOiO61xoCuePw+nN3JbJt+9owS
X-Google-Smtp-Source: APiQypKZOjsLMb9NiU5/iNsbK0miLL1KwTjd6Rd6b1KaF03aVUfYBath1wtWvquYhhziBkI6yAsB7w==
X-Received: by 2002:a17:902:6bc3:: with SMTP id m3mr11728106plt.288.1586662423465;
        Sat, 11 Apr 2020 20:33:43 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 19/31] elx: efct: Hardware IO and SGL initialization
Date:   Sat, 11 Apr 2020 20:32:51 -0700
Message-Id: <20200412033303.29574-20-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200412033303.29574-1-jsmart2021@gmail.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to create IO interfaces (wqs, etc), SGL initialization,
and configure hardware features.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  Request tag pool(reqtag_pool) handling fuctions.
---
 drivers/scsi/elx/efct/efct_hw.c | 657 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  42 +++
 2 files changed, 699 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 3e9906749da2..892493a3a35e 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1489,3 +1489,660 @@ efct_hw_command_cancel(struct efct_hw *hw)
 
 	return EFC_SUCCESS;
 }
+
+static inline struct efct_hw_io *
+_efct_hw_io_alloc(struct efct_hw *hw)
+{
+	struct efct_hw_io	*io = NULL;
+
+	if (!list_empty(&hw->io_free)) {
+		io = list_first_entry(&hw->io_free, struct efct_hw_io,
+				      list_entry);
+		list_del(&io->list_entry);
+	}
+	if (io) {
+		INIT_LIST_HEAD(&io->list_entry);
+		INIT_LIST_HEAD(&io->wqe_link);
+		INIT_LIST_HEAD(&io->dnrx_link);
+		list_add_tail(&io->list_entry, &hw->io_inuse);
+		io->state = EFCT_HW_IO_STATE_INUSE;
+		io->abort_reqtag = U32_MAX;
+		io->wq = hw->hw_wq[0];
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
+	struct efct_hw_io	*io = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&hw->io_lock, flags);
+	io = _efct_hw_io_alloc(hw);
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+
+	return io;
+}
+
+/*
+ * When an IO is freed, depending on the exchange busy flag, and other
+ * workarounds, move it to the correct list.
+ */
+static void
+efct_hw_io_free_move_correct_list(struct efct_hw *hw,
+				  struct efct_hw_io *io)
+{
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
+/**
+ * Free a previously-allocated HW IO object. Called when
+ * IO refcount goes to zero (host-owned IOs only).
+ */
+void
+efct_hw_io_free_internal(struct kref *arg)
+{
+	unsigned long flags = 0;
+	struct efct_hw_io *io =
+			container_of(arg, struct efct_hw_io, ref);
+	struct efct_hw *hw = io->hw;
+
+	/* perform common cleanup */
+	efct_hw_io_free_common(hw, io);
+
+	spin_lock_irqsave(&hw->io_lock, flags);
+		/* remove from in-use list */
+		if (io->list_entry.next &&
+		    !list_empty(&hw->io_inuse)) {
+			list_del(&io->list_entry);
+			efct_hw_io_free_move_correct_list(hw, io);
+		}
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+}
+
+int
+efct_hw_io_free(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	return kref_put(&io->ref, io->release);
+}
+
+u8
+efct_hw_io_inuse(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	return (refcount_read(&io->ref.refcount) > 0);
+}
+
+struct efct_hw_io *
+efct_hw_io_lookup(struct efct_hw *hw, u32 xri)
+{
+	u32 ioindex;
+
+	ioindex = xri - hw->sli.extent[SLI_RSRC_XRI].base[0];
+	return hw->io[ioindex];
+}
+
+enum efct_hw_rtn
+efct_hw_io_register_sgl(struct efct_hw *hw, struct efct_hw_io *io,
+			struct efc_dma *sgl,
+			u32 sgl_count)
+{
+	if (hw->sli.sgl_pre_registered) {
+		efc_log_err(hw->os,
+			     "can't use temp SGL with pre-registered SGLs\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+	io->ovfl_sgl = sgl;
+	io->ovfl_sgl_count = sgl_count;
+
+	return EFCT_HW_RTN_SUCCESS;
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
+#define EFCT_TARGET_WRITE_SKIPS	2
+		skips = EFCT_TARGET_WRITE_SKIPS;
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
+		skips--;
+
+		io->n_sge = 1;
+		break;
+	case EFCT_HW_IO_TARGET_READ:
+		/*
+		 * For FCP_TSEND64, the first 2 entries are SKIP SGE's
+		 */
+#define EFCT_TARGET_READ_SKIPS	2
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
+	/* Update the linked segment length (only executed after overflow has
+	 * begun)
+	 */
+	if (io->ovfl_lsp)
+		io->ovfl_lsp->dw3_seglen =
+			cpu_to_le32(io->n_sge * sizeof(struct sli4_sge) &
+				    SLI4_LSP_SGE_SEGLEN);
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
+enum efct_hw_rtn
+efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
+		 bool send_abts, void *cb, void *arg)
+{
+	enum sli4_abort_type atype = SLI_ABORT_MAX;
+	u32 id = 0, mask = 0;
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
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
+		efc_log_test(hw->os,
+			      "io not active xri=0x%x tag=0x%x\n",
+			     io_to_abort->indicator, io_to_abort->reqtag);
+		return EFCT_HW_RTN_IO_NOT_ACTIVE;
+	}
+
+	/* Must have a valid WQ reference */
+	if (!io_to_abort->wq) {
+		efc_log_test(hw->os, "io_to_abort xri=0x%x not active on WQ\n",
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
+	atype = SLI_ABORT_XRI;
+	id = io_to_abort->indicator;
+
+	/* Allocate a request tag for the abort portion of this IO */
+	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
+	if (!wqcb) {
+		efc_log_err(hw->os, "can't allocate request tag\n");
+		return EFCT_HW_RTN_NO_RESOURCES;
+	}
+	io_to_abort->abort_reqtag = wqcb->instance_index;
+
+	/*
+	 * If the wqe is on the pending list, then set this wqe to be
+	 * aborted when the IO's wqe is removed from the list.
+	 */
+	if (io_to_abort->wq) {
+		spin_lock_irqsave(&io_to_abort->wq->queue->lock, flags);
+		if (io_to_abort->wqe.list_entry.next) {
+			io_to_abort->wqe.abort_wqe_submit_needed = true;
+			io_to_abort->wqe.send_abts = send_abts;
+			io_to_abort->wqe.id = id;
+			io_to_abort->wqe.abort_reqtag =
+						 io_to_abort->abort_reqtag;
+			spin_unlock_irqrestore(&io_to_abort->wq->queue->lock,
+					       flags);
+			return EFC_SUCCESS;
+		}
+		spin_unlock_irqrestore(&io_to_abort->wq->queue->lock, flags);
+	}
+
+	if (sli_abort_wqe(&hw->sli, io_to_abort->wqe.wqebuf,
+			  hw->sli.wqe_size, atype, send_abts, id, mask,
+			  io_to_abort->abort_reqtag, SLI4_CQ_DEFAULT)) {
+		efc_log_err(hw->os, "ABORT WQE error\n");
+		io_to_abort->abort_reqtag = U32_MAX;
+		efct_hw_reqtag_free(hw, wqcb);
+		rc = EFCT_HW_RTN_ERROR;
+	}
+
+	if (rc == EFCT_HW_RTN_SUCCESS) {
+
+		/* ABORT_WQE does not actually utilize an XRI on the Port,
+		 * therefore, keep xbusy as-is to track the exchange's state,
+		 * not the ABORT_WQE's state
+		 */
+		rc = efct_hw_wq_write(io_to_abort->wq, &io_to_abort->wqe);
+		if (rc > 0)
+			/* non-negative return is success */
+			rc = 0;
+			/*
+			 * can't abort an abort so skip adding to timed wqe
+			 * list
+			 */
+	}
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		spin_lock_irqsave(&hw->io_abort_lock, flags);
+		io_to_abort->abort_in_progress = false;
+		spin_unlock_irqrestore(&hw->io_abort_lock, flags);
+		/* efct_ref_get(): same function */
+		kref_put(&io_to_abort->ref, io_to_abort->release);
+	}
+	return rc;
+}
+
+void
+efct_hw_reqtag_pool_free(struct efct_hw *hw)
+{
+	u32 i = 0;
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
+		list_del(&wqcb->list_entry);
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
+
+void
+efct_hw_reqtag_reset(struct efct_hw *hw)
+{
+	struct hw_wq_callback *wqcb;
+	u32 i;
+	struct reqtag_pool *reqtag_pool = hw->wq_reqtag_pool;
+	struct list_head *p, *n;
+
+	/* Remove all from freelist */
+	list_for_each_safe(p, n, &reqtag_pool->freelist) {
+		wqcb = list_entry(p, struct hw_wq_callback, list_entry);
+
+		if (wqcb)
+			list_del(&wqcb->list_entry);
+	}
+
+	/* Put them all back */
+	for (i = 0; i < ARRAY_SIZE(reqtag_pool->tags); i++) {
+		wqcb = reqtag_pool->tags[i];
+		wqcb->instance_index = i;
+		wqcb->callback = NULL;
+		wqcb->arg = NULL;
+		INIT_LIST_HEAD(&wqcb->list_entry);
+		list_add_tail(&wqcb->list_entry, &reqtag_pool->freelist);
+	}
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 1b67e0721936..86736d5295ec 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -635,5 +635,47 @@ void efct_hw_rx_free(struct efct_hw *hw);
 extern enum efct_hw_rtn
 efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb,
 		void *arg);
+struct efct_hw_io *efct_hw_io_alloc(struct efct_hw *hw);
+int efct_hw_io_free(struct efct_hw *hw, struct efct_hw_io *io);
+u8 efct_hw_io_inuse(struct efct_hw *hw, struct efct_hw_io *io);
+extern enum efct_hw_rtn
+efct_hw_io_send(struct efct_hw *hw, enum efct_hw_io_type type,
+		struct efct_hw_io *io, u32 len,
+		union efct_hw_io_param_u *iparam,
+		struct efc_remote_node *rnode, void *cb, void *arg);
+extern enum efct_hw_rtn
+efct_hw_io_register_sgl(struct efct_hw *hw, struct efct_hw_io *io,
+			struct efc_dma *sgl,
+			u32 sgl_count);
+extern enum efct_hw_rtn
+efct_hw_io_init_sges(struct efct_hw *hw,
+		     struct efct_hw_io *io, enum efct_hw_io_type type);
+
+extern enum efct_hw_rtn
+efct_hw_io_add_sge(struct efct_hw *hw, struct efct_hw_io *io,
+		   uintptr_t addr, u32 length);
+extern enum efct_hw_rtn
+efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
+		 bool send_abts, void *cb, void *arg);
+extern u32
+efct_hw_io_get_count(struct efct_hw *hw,
+		     enum efct_hw_io_count_type io_count_type);
+extern struct efct_hw_io
+*efct_hw_io_lookup(struct efct_hw *hw, u32 indicator);
+void efct_hw_io_abort_all(struct efct_hw *hw);
+void efct_hw_io_free_internal(struct kref *arg);
+
+/* HW WQ request tag API */
+struct reqtag_pool *efct_hw_reqtag_pool_alloc(struct efct_hw *hw);
+void efct_hw_reqtag_pool_free(struct efct_hw *hw);
+extern struct hw_wq_callback
+*efct_hw_reqtag_alloc(struct efct_hw *hw,
+			void (*callback)(void *arg, u8 *cqe,
+					 int status), void *arg);
+extern void
+efct_hw_reqtag_free(struct efct_hw *hw, struct hw_wq_callback *wqcb);
+extern struct hw_wq_callback
+*efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index);
+void efct_hw_reqtag_reset(struct efct_hw *hw);
 
 #endif /* __EFCT_H__ */
-- 
2.16.4

