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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22531C47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C55461245
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbhFAX5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbhFAX5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 19:57:22 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B814C06175F
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 16:55:39 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 6so732639pgk.5
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 16:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HD2qz4VwalL2YjbW40i44x1+ybIaUrILjpl3Tq7MN/o=;
        b=NjgRg8BxMqJAjmpiQGXgherBU7GZgLXomDrar6PVlvD52Xw46f35FhKlYjSd9gW9Vm
         CPH4IkxqnyjpZuriwn7oNLtj3uJf7njsjW4fKOXGtNwmPT1Ipg3XDW9yoTYa/xHJlzBh
         It8dUYzPc7H8bc/8ZUjVetIKbc5xNiJec5Zw1cGLmcXRcGikdH44d06NPA49z3RwFFmR
         I/obCuxGbmFAVPOyYqcnuthVgvpaIvUZibUdYu53bnoKZSuS75lMAs+hmcCPTHmiBVYh
         raG9fOxwSSqGX1gL23v6kTg/o+6d9HzTqxU7t0Aw3IAYdFYh1UgvCb/fc4lcfFh+MuNj
         VDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HD2qz4VwalL2YjbW40i44x1+ybIaUrILjpl3Tq7MN/o=;
        b=MNn+PRFQAdEmu6LHYDJpMClW+84i7fxDKl7GB1qEFZ8lux9DlF4hCEcl1kn9ZJG/n6
         VejZ8Ka7uVmnSNPab8LljSvTkadjWP4o4kcALW5MGOb6me/jnaz7NpKTJfYhF5+2sAKq
         dAi3O3/kZd59Sq3GqsJYjwpEe6emSTEWFOuPxZZWvt+rrTAvJerPHJyQhQaLO8gUdXkx
         tMUkCgy9QLsd054yRLTo6jIoEszrkwTOZ9V34A4zXWdpb7wUpvdWPXEPhGKi+B7EGpAz
         5O1oSznIceSsDR6y1yRv1hz9Ml/iS/bpYRrrMFe3T2CmdCAohnYGuMN2hDYKo0iggfdI
         nyBQ==
X-Gm-Message-State: AOAM532juZfhKL/Z10AoAS8wzFZOyGwlCxpqw3VHKiq8YGdacO9AOJdq
        h68zrsOxMQY4mO7dUNaR7cQK1sqFwH4=
X-Google-Smtp-Source: ABdhPJxi3iTrrufEXPjeNMs0edt7pGPX+Q7ZtNOav6YFd/18Zg3Sde0I+wsvLtDgLe116qy0hwd3Xg==
X-Received: by 2002:aa7:8ec8:0:b029:2ea:32b:9202 with SMTP id b8-20020aa78ec80000b02902ea032b9202mr5153249pfr.36.1622591738568;
        Tue, 01 Jun 2021 16:55:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm13915357pfm.187.2021.06.01.16.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:55:38 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v9 26/31] elx: efct: Hardware IO submission routines
Date:   Tue,  1 Jun 2021 16:55:07 -0700
Message-Id: <20210601235512.20104-27-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601235512.20104-1-jsmart2021@gmail.com>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines that write IO to Work queue, send SRRs and raw frames.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>

---
v9:
Non-functional changes:
  Remove EFC_SUCCESS/EFC_FAIL defines and use 0 and -Exxx errno values.
  Remove EFCT_xxx/EFCT_HW_RTN_xxx defines and use appropriate -Exxx errno
       values.
  Correct indentation on line continuations.
---
 drivers/scsi/elx/efct/efct_hw.c | 511 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  14 +
 2 files changed, 525 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index f195bb9c9cbf..ffe7dd106811 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2491,3 +2491,514 @@ efct_hw_flush(struct efct_hw *hw)
 
 	return 0;
 }
+
+int
+efct_hw_wq_write(struct hw_wq *wq, struct efct_hw_wqe *wqe)
+{
+	int rc = 0;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&wq->queue->lock, flags);
+	if (list_empty(&wq->pending_list)) {
+		if (wq->free_count > 0) {
+			rc = _efct_hw_wq_write(wq, wqe);
+		} else {
+			INIT_LIST_HEAD(&wqe->list_entry);
+			list_add_tail(&wqe->list_entry, &wq->pending_list);
+			wq->wq_pending_count++;
+		}
+
+		spin_unlock_irqrestore(&wq->queue->lock, flags);
+		return rc;
+	}
+
+	INIT_LIST_HEAD(&wqe->list_entry);
+	list_add_tail(&wqe->list_entry, &wq->pending_list);
+	wq->wq_pending_count++;
+	while (wq->free_count > 0) {
+		wqe = list_first_entry(&wq->pending_list, struct efct_hw_wqe,
+				       list_entry);
+		if (!wqe)
+			break;
+
+		list_del_init(&wqe->list_entry);
+		rc = _efct_hw_wq_write(wq, wqe);
+		if (rc)
+			break;
+
+		if (wqe->abort_wqe_submit_needed) {
+			wqe->abort_wqe_submit_needed = false;
+			efct_hw_fill_abort_wqe(wq->hw, wqe);
+
+			INIT_LIST_HEAD(&wqe->list_entry);
+			list_add_tail(&wqe->list_entry, &wq->pending_list);
+			wq->wq_pending_count++;
+		}
+	}
+
+	spin_unlock_irqrestore(&wq->queue->lock, flags);
+
+	return rc;
+}
+
+int
+efct_efc_bls_send(struct efc *efc, u32 type, struct sli_bls_params *bls)
+{
+	struct efct *efct = efc->base;
+
+	return efct_hw_bls_send(efct, type, bls, NULL, NULL);
+}
+
+int
+efct_hw_bls_send(struct efct *efct, u32 type, struct sli_bls_params *bls_params,
+		 void *cb, void *arg)
+{
+	struct efct_hw *hw = &efct->hw;
+	struct efct_hw_io *hio;
+	struct sli_bls_payload bls;
+	int rc;
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_err(hw->os,
+			    "cannot send BLS, HW state=%d\n", hw->state);
+		return -EIO;
+	}
+
+	hio = efct_hw_io_alloc(hw);
+	if (!hio) {
+		efc_log_err(hw->os, "HIO allocation failed\n");
+		return -EIO;
+	}
+
+	hio->done = cb;
+	hio->arg  = arg;
+
+	bls_params->xri = hio->indicator;
+	bls_params->tag = hio->reqtag;
+
+	if (type == FC_RCTL_BA_ACC) {
+		hio->type = EFCT_HW_BLS_ACC;
+		bls.type = SLI4_SLI_BLS_ACC;
+		memcpy(&bls.u.acc, bls_params->payload, sizeof(bls.u.acc));
+	} else {
+		hio->type = EFCT_HW_BLS_RJT;
+		bls.type = SLI4_SLI_BLS_RJT;
+		memcpy(&bls.u.rjt, bls_params->payload, sizeof(bls.u.rjt));
+	}
+
+	bls.ox_id = cpu_to_le16(bls_params->ox_id);
+	bls.rx_id = cpu_to_le16(bls_params->rx_id);
+
+	if (sli_xmit_bls_rsp64_wqe(&hw->sli, hio->wqe.wqebuf,
+				   &bls, bls_params)) {
+		efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE error\n");
+		return -EIO;
+	}
+
+	hio->xbusy = true;
+
+	/*
+	 * Add IO to active io wqe list before submitting, in case the
+	 * wcqe processing preempts this thread.
+	 */
+	hio->wq->use_count++;
+	rc = efct_hw_wq_write(hio->wq, &hio->wqe);
+	if (rc >= 0) {
+		/* non-negative return is success */
+		rc = 0;
+	} else {
+		/* failed to write wqe, remove from active wqe list */
+		efc_log_err(hw->os,
+			    "sli_queue_write failed: %d\n", rc);
+		hio->xbusy = false;
+	}
+
+	return rc;
+}
+
+static int
+efct_els_ssrs_send_cb(struct efct_hw_io *hio, u32 length, int status,
+		      u32 ext_status, void *arg)
+{
+	struct efc_disc_io *io = arg;
+
+	efc_disc_io_complete(io, length, status, ext_status);
+	return 0;
+}
+
+static inline void
+efct_fill_els_params(struct efc_disc_io *io, struct sli_els_params *params)
+{
+	u8 *cmd = io->req.virt;
+
+	params->cmd = *cmd;
+	params->s_id = io->s_id;
+	params->d_id = io->d_id;
+	params->ox_id = io->iparam.els.ox_id;
+	params->rpi = io->rpi;
+	params->vpi = io->vpi;
+	params->rpi_registered = io->rpi_registered;
+	params->xmit_len = io->xmit_len;
+	params->rsp_len = io->rsp_len;
+	params->timeout = io->iparam.els.timeout;
+}
+
+static inline void
+efct_fill_ct_params(struct efc_disc_io *io, struct sli_ct_params *params)
+{
+	params->r_ctl = io->iparam.ct.r_ctl;
+	params->type = io->iparam.ct.type;
+	params->df_ctl =  io->iparam.ct.df_ctl;
+	params->d_id = io->d_id;
+	params->ox_id = io->iparam.ct.ox_id;
+	params->rpi = io->rpi;
+	params->vpi = io->vpi;
+	params->rpi_registered = io->rpi_registered;
+	params->xmit_len = io->xmit_len;
+	params->rsp_len = io->rsp_len;
+	params->timeout = io->iparam.ct.timeout;
+}
+
+/**
+ * efct_els_hw_srrs_send() - Send a single request and response cmd.
+ * @efc: efc library structure
+ * @io: Discovery IO used to hold els and ct cmd context.
+ *
+ * This routine supports communication sequences consisting of a single
+ * request and single response between two endpoints. Examples include:
+ *  - Sending an ELS request.
+ *  - Sending an ELS response - To send an ELS response, the caller must provide
+ * the OX_ID from the received request.
+ *  - Sending a FC Common Transport (FC-CT) request - To send a FC-CT request,
+ * the caller must provide the R_CTL, TYPE, and DF_CTL
+ * values to place in the FC frame header.
+ *
+ * Return: Status of the request.
+ */
+int
+efct_els_hw_srrs_send(struct efc *efc, struct efc_disc_io *io)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw_io *hio;
+	struct efct_hw *hw = &efct->hw;
+	struct efc_dma *send = &io->req;
+	struct efc_dma *receive = &io->rsp;
+	struct sli4_sge	*sge = NULL;
+	int rc = 0;
+	u32 len = io->xmit_len;
+	u32 sge0_flags;
+	u32 sge1_flags;
+
+	hio = efct_hw_io_alloc(hw);
+	if (!hio) {
+		pr_err("HIO alloc failed\n");
+		return -EIO;
+	}
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_debug(hw->os,
+			      "cannot send SRRS, HW state=%d\n", hw->state);
+		return -EIO;
+	}
+
+	hio->done = efct_els_ssrs_send_cb;
+	hio->arg  = io;
+
+	sge = hio->sgl->virt;
+
+	/* clear both SGE */
+	memset(hio->sgl->virt, 0, 2 * sizeof(struct sli4_sge));
+
+	sge0_flags = le32_to_cpu(sge[0].dw2_flags);
+	sge1_flags = le32_to_cpu(sge[1].dw2_flags);
+	if (send->size) {
+		sge[0].buffer_address_high =
+			cpu_to_le32(upper_32_bits(send->phys));
+		sge[0].buffer_address_low  =
+			cpu_to_le32(lower_32_bits(send->phys));
+
+		sge0_flags |= (SLI4_SGE_TYPE_DATA << SLI4_SGE_TYPE_SHIFT);
+
+		sge[0].buffer_length = cpu_to_le32(len);
+	}
+
+	if (io->io_type == EFC_DISC_IO_ELS_REQ ||
+	    io->io_type == EFC_DISC_IO_CT_REQ) {
+		sge[1].buffer_address_high =
+			cpu_to_le32(upper_32_bits(receive->phys));
+		sge[1].buffer_address_low  =
+			cpu_to_le32(lower_32_bits(receive->phys));
+
+		sge1_flags |= (SLI4_SGE_TYPE_DATA << SLI4_SGE_TYPE_SHIFT);
+		sge1_flags |= SLI4_SGE_LAST;
+
+		sge[1].buffer_length = cpu_to_le32(receive->size);
+	} else {
+		sge0_flags |= SLI4_SGE_LAST;
+	}
+
+	sge[0].dw2_flags = cpu_to_le32(sge0_flags);
+	sge[1].dw2_flags = cpu_to_le32(sge1_flags);
+
+	switch (io->io_type) {
+	case EFC_DISC_IO_ELS_REQ: {
+		struct sli_els_params els_params;
+
+		hio->type = EFCT_HW_ELS_REQ;
+		efct_fill_els_params(io, &els_params);
+		els_params.xri = hio->indicator;
+		els_params.tag = hio->reqtag;
+
+		if (sli_els_request64_wqe(&hw->sli, hio->wqe.wqebuf, hio->sgl,
+					  &els_params)) {
+			efc_log_err(hw->os, "REQ WQE error\n");
+			rc = -EIO;
+		}
+		break;
+	}
+	case EFC_DISC_IO_ELS_RESP: {
+		struct sli_els_params els_params;
+
+		hio->type = EFCT_HW_ELS_RSP;
+		efct_fill_els_params(io, &els_params);
+		els_params.xri = hio->indicator;
+		els_params.tag = hio->reqtag;
+		if (sli_xmit_els_rsp64_wqe(&hw->sli, hio->wqe.wqebuf, send,
+					   &els_params)){
+			efc_log_err(hw->os, "RSP WQE error\n");
+			rc = -EIO;
+		}
+		break;
+	}
+	case EFC_DISC_IO_CT_REQ: {
+		struct sli_ct_params ct_params;
+
+		hio->type = EFCT_HW_FC_CT;
+		efct_fill_ct_params(io, &ct_params);
+		ct_params.xri = hio->indicator;
+		ct_params.tag = hio->reqtag;
+		if (sli_gen_request64_wqe(&hw->sli, hio->wqe.wqebuf, hio->sgl,
+					  &ct_params)){
+			efc_log_err(hw->os, "GEN WQE error\n");
+			rc = -EIO;
+		}
+		break;
+	}
+	case EFC_DISC_IO_CT_RESP: {
+		struct sli_ct_params ct_params;
+
+		hio->type = EFCT_HW_FC_CT_RSP;
+		efct_fill_ct_params(io, &ct_params);
+		ct_params.xri = hio->indicator;
+		ct_params.tag = hio->reqtag;
+		if (sli_xmit_sequence64_wqe(&hw->sli, hio->wqe.wqebuf, hio->sgl,
+					    &ct_params)){
+			efc_log_err(hw->os, "XMIT SEQ WQE error\n");
+			rc = -EIO;
+		}
+		break;
+	}
+	default:
+		efc_log_err(hw->os, "bad SRRS type %#x\n", io->io_type);
+		rc = -EIO;
+	}
+
+	if (rc == 0) {
+		hio->xbusy = true;
+
+		/*
+		 * Add IO to active io wqe list before submitting, in case the
+		 * wcqe processing preempts this thread.
+		 */
+		hio->wq->use_count++;
+		rc = efct_hw_wq_write(hio->wq, &hio->wqe);
+		if (rc >= 0) {
+			/* non-negative return is success */
+			rc = 0;
+		} else {
+			/* failed to write wqe, remove from active wqe list */
+			efc_log_err(hw->os,
+				    "sli_queue_write failed: %d\n", rc);
+			hio->xbusy = false;
+		}
+	}
+
+	return rc;
+}
+
+int
+efct_hw_io_send(struct efct_hw *hw, enum efct_hw_io_type type,
+		struct efct_hw_io *io, union efct_hw_io_param_u *iparam,
+		void *cb, void *arg)
+{
+	int rc = 0;
+	bool send_wqe = true;
+
+	if (!io) {
+		pr_err("bad parm hw=%p io=%p\n", hw, io);
+		return -EIO;
+	}
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_err(hw->os, "cannot send IO, HW state=%d\n", hw->state);
+		return -EIO;
+	}
+
+	/*
+	 * Save state needed during later stages
+	 */
+	io->type  = type;
+	io->done  = cb;
+	io->arg   = arg;
+
+	/*
+	 * Format the work queue entry used to send the IO
+	 */
+	switch (type) {
+	case EFCT_HW_IO_TARGET_WRITE: {
+		u16 *flags = &iparam->fcp_tgt.flags;
+		struct fcp_txrdy *xfer = io->xfer_rdy.virt;
+
+		/*
+		 * Fill in the XFER_RDY for IF_TYPE 0 devices
+		 */
+		xfer->ft_data_ro = cpu_to_be32(iparam->fcp_tgt.offset);
+		xfer->ft_burst_len = cpu_to_be32(iparam->fcp_tgt.xmit_len);
+
+		if (io->xbusy)
+			*flags |= SLI4_IO_CONTINUATION;
+		else
+			*flags &= ~SLI4_IO_CONTINUATION;
+		iparam->fcp_tgt.xri = io->indicator;
+		iparam->fcp_tgt.tag = io->reqtag;
+
+		if (sli_fcp_treceive64_wqe(&hw->sli, io->wqe.wqebuf,
+					   &io->def_sgl, io->first_data_sge,
+					   SLI4_CQ_DEFAULT,
+					   0, 0, &iparam->fcp_tgt)) {
+			efc_log_err(hw->os, "TRECEIVE WQE error\n");
+			rc = -EIO;
+		}
+		break;
+	}
+	case EFCT_HW_IO_TARGET_READ: {
+		u16 *flags = &iparam->fcp_tgt.flags;
+
+		if (io->xbusy)
+			*flags |= SLI4_IO_CONTINUATION;
+		else
+			*flags &= ~SLI4_IO_CONTINUATION;
+
+		iparam->fcp_tgt.xri = io->indicator;
+		iparam->fcp_tgt.tag = io->reqtag;
+
+		if (sli_fcp_tsend64_wqe(&hw->sli, io->wqe.wqebuf,
+					&io->def_sgl, io->first_data_sge,
+					SLI4_CQ_DEFAULT,
+					0, 0, &iparam->fcp_tgt)) {
+			efc_log_err(hw->os, "TSEND WQE error\n");
+			rc = -EIO;
+		}
+		break;
+	}
+	case EFCT_HW_IO_TARGET_RSP: {
+		u16 *flags = &iparam->fcp_tgt.flags;
+
+		if (io->xbusy)
+			*flags |= SLI4_IO_CONTINUATION;
+		else
+			*flags &= ~SLI4_IO_CONTINUATION;
+
+		iparam->fcp_tgt.xri = io->indicator;
+		iparam->fcp_tgt.tag = io->reqtag;
+
+		if (sli_fcp_trsp64_wqe(&hw->sli, io->wqe.wqebuf,
+				       &io->def_sgl, SLI4_CQ_DEFAULT,
+				       0, &iparam->fcp_tgt)) {
+			efc_log_err(hw->os, "TRSP WQE error\n");
+			rc = -EIO;
+		}
+
+		break;
+	}
+	default:
+		efc_log_err(hw->os, "unsupported IO type %#x\n", type);
+		rc = -EIO;
+	}
+
+	if (send_wqe && rc == 0) {
+		io->xbusy = true;
+
+		/*
+		 * Add IO to active io wqe list before submitting, in case the
+		 * wcqe processing preempts this thread.
+		 */
+		hw->tcmd_wq_submit[io->wq->instance]++;
+		io->wq->use_count++;
+		rc = efct_hw_wq_write(io->wq, &io->wqe);
+		if (rc >= 0) {
+			/* non-negative return is success */
+			rc = 0;
+		} else {
+			/* failed to write wqe, remove from active wqe list */
+			efc_log_err(hw->os,
+				    "sli_queue_write failed: %d\n", rc);
+			io->xbusy = false;
+		}
+	}
+
+	return rc;
+}
+
+int
+efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
+		   u8 sof, u8 eof, struct efc_dma *payload,
+		   struct efct_hw_send_frame_context *ctx,
+		   void (*callback)(void *arg, u8 *cqe, int status),
+		   void *arg)
+{
+	int rc;
+	struct efct_hw_wqe *wqe;
+	u32 xri;
+	struct hw_wq *wq;
+
+	wqe = &ctx->wqe;
+
+	/* populate the callback object */
+	ctx->hw = hw;
+
+	/* Fetch and populate request tag */
+	ctx->wqcb = efct_hw_reqtag_alloc(hw, callback, arg);
+	if (!ctx->wqcb) {
+		efc_log_err(hw->os, "can't allocate request tag\n");
+		return -ENOSPC;
+	}
+
+	wq = hw->hw_wq[0];
+
+	/* Set XRI and RX_ID in the header based on which WQ, and which
+	 * send_frame_io we are using
+	 */
+	xri = wq->send_frame_io->indicator;
+
+	/* Build the send frame WQE */
+	rc = sli_send_frame_wqe(&hw->sli, wqe->wqebuf,
+				sof, eof, (u32 *)hdr, payload, payload->len,
+				EFCT_HW_SEND_FRAME_TIMEOUT, xri,
+				ctx->wqcb->instance_index);
+	if (rc) {
+		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n", rc);
+		return -EIO;
+	}
+
+	/* Write to WQ */
+	rc = efct_hw_wq_write(wq, wqe);
+	if (rc) {
+		efc_log_err(hw->os, "efct_hw_wq_write failed: %d\n", rc);
+		return -EIO;
+	}
+
+	wq->use_count++;
+
+	return 0;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index a2e4ea79e239..b9e7f5b4115b 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -690,5 +690,19 @@ int
 efct_hw_process(struct efct_hw *hw, u32 vector, u32 max_isr_time_msec);
 int
 efct_hw_queue_hash_find(struct efct_queue_hash *hash, u16 id);
+int efct_hw_wq_write(struct hw_wq *wq, struct efct_hw_wqe *wqe);
+int
+efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
+		   u8 sof, u8 eof, struct efc_dma *payload,
+		struct efct_hw_send_frame_context *ctx,
+		void (*callback)(void *arg, u8 *cqe, int status),
+		void *arg);
+int
+efct_els_hw_srrs_send(struct efc *efc, struct efc_disc_io *io);
+int
+efct_efc_bls_send(struct efc *efc, u32 type, struct sli_bls_params *bls);
+int
+efct_hw_bls_send(struct efct *efct, u32 type, struct sli_bls_params *bls_params,
+		 void *cb, void *arg);
 
 #endif /* __EFCT_H__ */
-- 
2.26.2

