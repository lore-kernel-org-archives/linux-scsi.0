Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49975C43467
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 053C92073A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HuVvJOBz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390875AbgJLWwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390798AbgJLWwe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:34 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A72C0613D1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q21so4673264pgi.13
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=9qhuBLNBk2DTpojX7fUC4DTJI29iey0zKTFXRApWwE0=;
        b=HuVvJOBzLKl3oqIL6kPO3YIOrSAh22vHKALeujnCUgHjXyvPRJJPiqawwX9cf6WAFH
         x0D3zNO4mXcYTvfv9gy0dM7uKIp/iwal/GAuYI+nYvG0WPIu4Ap6Ialo1xFY8Abv6Q2L
         c6fSWT5R5ScrEpEspqoIRAZKgNkikzGn1b4cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=9qhuBLNBk2DTpojX7fUC4DTJI29iey0zKTFXRApWwE0=;
        b=BkNrWIf62qILoU00hiM6PUe0rtDK9BmCh8ZcPCKb5ZTUnfebRuVIgVNoZniVYSXDJv
         FKEwLtil5XWYjlom1a2qoywe3JId3DSw5D7h2vruZMBV6+mQ+ISvbigc2md4hi35tALy
         Z+nL/lKPTjE4pXTlQhUY/79PqIxKKt8gshVdwOA0MRDAQ1jRBhKq8A4gDkWrMkqemc1v
         AWPqflS+IleHHQPBM8Uwx4vKPDIZNNGljXppNPdpkqCF8ygRu8Kx/ZbvJ38CkHphtBlZ
         Nri4Wl3PAizzsOxItf0NOX8VjreyyALfBFhknernM/SDTEGz+mux5O5NET8t3fAY7NH1
         XIgQ==
X-Gm-Message-State: AOAM533ExzPblKh5/DxSJOGe7eGD9ipK0tYY4JM/6PvNFQh/XhydKZvI
        ZezBPk2m8onsAXHr2uPj8032s7SdaVkAzJVjSeTmBXb49DtQaS7c9TQH3kx2GVU/HlwoD3GyjBC
        ILNPf7ma6NbMIIILvbREva37zUAHNV+6ztO9IBJpAlh8lx8fN0TzgFJd0vBk5psgApsKXVJm+ua
        YTGzY=
X-Google-Smtp-Source: ABdhPJyHWBeTB3TqGGtS6RXJFswmaOxypa6YsU0qBzWZXOBECHbVpYh6i+J4RUi4EUw/UdXe7NcBvg==
X-Received: by 2002:a17:90a:4f01:: with SMTP id p1mr21659741pjh.144.1602543152924;
        Mon, 12 Oct 2020 15:52:32 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:32 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 26/31] elx: efct: Hardware IO submission routines
Date:   Mon, 12 Oct 2020 15:51:42 -0700
Message-Id: <20201012225147.54404-27-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000068179205b18127c2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000068179205b18127c2
Content-Transfer-Encoding: 8bit

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines that write IO to Work queue, send SRRs and raw frames.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Reduced the argument list for WQE filling routines.
---
 drivers/scsi/elx/efct/efct_hw.c | 515 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  14 +
 2 files changed, 529 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 7764f16b2bed..6e92e86cbb84 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2531,3 +2531,518 @@ efct_hw_flush(struct efct_hw *hw)
 
 	return EFC_SUCCESS;
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
+				      list_entry);
+		if (!wqe)
+			break;
+
+		list_del(&wqe->list_entry);
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
+			      "cannot send BLS, HW state=%d\n", hw->state);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	hio = efct_hw_io_alloc(hw);
+	if (!hio) {
+		efc_log_err(hw->os, "HIO allocation failed\n");
+		return EFCT_HW_RTN_ERROR;
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
+		return EFCT_HW_RTN_ERROR;
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
+		rc = EFC_SUCCESS;
+	} else {
+		/* failed to write wqe, remove from active wqe list */
+		efc_log_err(hw->os,
+			     "sli_queue_write failed: %d\n", rc);
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
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	u32 len = io->xmit_len;
+	u32 sge0_flags;
+	u32 sge1_flags;
+
+	hio = efct_hw_io_alloc(hw);
+	if (!hio) {
+		pr_err("HIO alloc failed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_test(hw->os,
+			      "cannot send SRRS, HW state=%d\n", hw->state);
+		return EFCT_HW_RTN_ERROR;
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
+		io->io_type == EFC_DISC_IO_CT_REQ) {
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
+			rc = EFCT_HW_RTN_ERROR;
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
+			rc = EFCT_HW_RTN_ERROR;
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
+			rc = EFCT_HW_RTN_ERROR;
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
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	}
+	default:
+		efc_log_err(hw->os, "bad SRRS type %#x\n", io->io_type);
+		rc = EFCT_HW_RTN_ERROR;
+	}
+
+	if (rc == EFCT_HW_RTN_SUCCESS) {
+
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
+				     "sli_queue_write failed: %d\n", rc);
+			hio->xbusy = false;
+		}
+	}
+
+	return rc;
+}
+
+enum efct_hw_rtn
+efct_hw_io_send(struct efct_hw *hw, enum efct_hw_io_type type,
+		struct efct_hw_io *io, union efct_hw_io_param_u *iparam,
+		void *cb, void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	bool send_wqe = true;
+
+	if (!io) {
+		pr_err("bad parm hw=%p io=%p\n", hw, io);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_err(hw->os, "cannot send IO, HW state=%d\n", hw->state);
+		return EFCT_HW_RTN_ERROR;
+	}
+
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
+		u16 flags = iparam->fcp_tgt.flags;
+		struct fcp_txrdy *xfer = io->xfer_rdy.virt;
+
+		/*
+		 * Fill in the XFER_RDY for IF_TYPE 0 devices
+		 */
+		xfer->ft_data_ro = cpu_to_be32(iparam->fcp_tgt.offset);
+		xfer->ft_burst_len = cpu_to_be32(iparam->fcp_tgt.xmit_len);
+
+		if (io->xbusy)
+			flags |= SLI4_IO_CONTINUATION;
+		else
+			flags &= ~SLI4_IO_CONTINUATION;
+		iparam->fcp_tgt.xri = io->indicator;
+		iparam->fcp_tgt.tag = io->reqtag;
+
+		if (sli_fcp_treceive64_wqe(&hw->sli, io->wqe.wqebuf,
+					   &io->def_sgl, io->first_data_sge,
+					   SLI4_CQ_DEFAULT,
+					   0, 0, &iparam->fcp_tgt)) {
+			efc_log_err(hw->os, "TRECEIVE WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	}
+	case EFCT_HW_IO_TARGET_READ: {
+		u16 flags = iparam->fcp_tgt.flags;
+
+		if (io->xbusy)
+			flags |= SLI4_IO_CONTINUATION;
+		else
+			flags &= ~SLI4_IO_CONTINUATION;
+
+		iparam->fcp_tgt.xri = io->indicator;
+		iparam->fcp_tgt.tag = io->reqtag;
+
+		if (sli_fcp_tsend64_wqe(&hw->sli, io->wqe.wqebuf,
+					&io->def_sgl, io->first_data_sge,
+					SLI4_CQ_DEFAULT,
+					0, 0, &iparam->fcp_tgt)) {
+			efc_log_err(hw->os, "TSEND WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	}
+	case EFCT_HW_IO_TARGET_RSP: {
+		u16 flags = iparam->fcp_tgt.flags;
+
+		if (io->xbusy)
+			flags |= SLI4_IO_CONTINUATION;
+		else
+			flags &= ~SLI4_IO_CONTINUATION;
+
+		iparam->fcp_tgt.xri = io->indicator;
+		iparam->fcp_tgt.tag = io->reqtag;
+
+		if (sli_fcp_trsp64_wqe(&hw->sli, io->wqe.wqebuf,
+				       &io->def_sgl, SLI4_CQ_DEFAULT,
+				       0, &iparam->fcp_tgt)) {
+			efc_log_err(hw->os, "TRSP WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+
+		break;
+	}
+	default:
+		efc_log_err(hw->os, "unsupported IO type %#x\n", type);
+		rc = EFCT_HW_RTN_ERROR;
+	}
+
+	if (send_wqe && rc == EFCT_HW_RTN_SUCCESS) {
+
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
+				     "sli_queue_write failed: %d\n", rc);
+			io->xbusy = false;
+		}
+	}
+
+	return rc;
+}
+
+enum efct_hw_rtn
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
+		return EFCT_HW_RTN_NO_RESOURCES;
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
+		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n",
+			     rc);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* Write to WQ */
+	rc = efct_hw_wq_write(wq, wqe);
+	if (rc) {
+		efc_log_err(hw->os, "efct_hw_wq_write failed: %d\n", rc);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	wq->use_count++;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index ab9a86ded815..bcd77b5095e8 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -706,5 +706,19 @@ int
 efct_hw_process(struct efct_hw *hw, u32 vector, u32 max_isr_time_msec);
 int
 efct_hw_queue_hash_find(struct efct_queue_hash *hash, u16 id);
+int efct_hw_wq_write(struct hw_wq *wq, struct efct_hw_wqe *wqe);
+enum efct_hw_rtn
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


--00000000000068179205b18127c2
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgaU/U+CqoWLpVdQGj
lB1S5E543n1DBmOqFg7BJidD2DYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjMzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFPvmaTMPOygt8iOFuyfz8bYcAwJ3YikrEUo
i0gQCxq7flTGQ+pqi+MGZhDhQuQmbgo+oF0Ra7HAfEQyYct78jkcM2PCZkaBgWu8kV1eNVL6o1zC
NaxBf65UQpaURejlqpw86sF02p5EJqyf8dHF/yzRewPcrgoBbBwnF9/CrS9/v4ViapbVsxjPjH5T
DyhHA8q5eAtqogd2AxE95GEmblAj7zzNjUO7DrgjjqBBWhWy6AMijq6NTVrJvlEfo9J9XIop2+TK
d7h6Pf3lHLfaUrgSnMijaFIL7TqMu1fRp/ta/YTwB92UngoUuTK9nyDkfVRU+pw17eOA9KiISDpz
mfo=
--00000000000068179205b18127c2--
