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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF113CA9EBC
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A4C205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ebwqir5v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436637AbfJWV4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38746 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436631AbfJWV4w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so462643wmi.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nnkpkOjIcT7NRwe9PCzw8+wbX+VP2+XgaggdN64EYcY=;
        b=Ebwqir5v/bWg/LwHqWhKuLn0TmF1nU+z+CmeQQeQnNRtXHx4fwoDxA0Y5tvvA98wjF
         4wdxTvBbci8+2BxrdRroVbKJ4TFr1pX008qh9WXctHXNum6nrsEIBrGY5JB/HEXcTq7F
         UV8Tlod6Vh0JhqGJzo99aQnpMiPgFSe52UvUHn/PQaVGv7x3L0GFmU8daSUy2yshsBqq
         SXkiZB6/RC+4zF/otz6aHX3UQ//dqqEz6TupniXbJngFGoo5TPErwTRE0iefp/cwcmYy
         S5abXllCtHrUWrh3O8wGH6hS0nURZ/f7PzKG26RsOMY4m7xiAuwEcLBIhigsaXuutwrR
         0MDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nnkpkOjIcT7NRwe9PCzw8+wbX+VP2+XgaggdN64EYcY=;
        b=njK6UI5UFJjJtFbvAVtj0HKthFL7rqqS9IEGb7I6pKX3Qf+uClQxHEgORAWzqthVMn
         upYCErfvukr7/6Snmsr+6QlwdSq0n/4CSlPN/05SZrmztUQm8JaFNHBN5tR39GUY+qG0
         Y69z3ai/kR3Yjd8GeSrVEJqYsQUznCWzmsOm4w8yH4DPiHkwKeNPXflN5an8thpEBfQD
         63dAp9Y1nqoUngZeBD8e/hDeE7O+iAhqj3NwrXavjooXJ6e29GfmD4Pv9M0VJdklSd+n
         lUjJfeien6UvS4+JqBWLflFCurqpdL/ftrWsmem8w5JGzxTSiXsoIgY8JhkLmuBI9aWH
         Tu2Q==
X-Gm-Message-State: APjAAAVKsZ3Ot6J76AUusp3zSRfFAzcW12ZuOKVRW5rGHyy8cBBRt52z
        1S23ant+j7Wn/pBhzj28v35fepk0
X-Google-Smtp-Source: APXvYqwcdeKnRQYDmjbGgZPg9Y1GaJr+AVosHhQl2Vcths43XfKk5UQ7H0wU80QhDzZoCK1R0vpuZA==
X-Received: by 2002:a05:600c:294b:: with SMTP id n11mr1762063wmd.70.1571867808711;
        Wed, 23 Oct 2019 14:56:48 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:48 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 25/32] elx: efct: Hardware IO submission routines
Date:   Wed, 23 Oct 2019 14:55:50 -0700
Message-Id: <20191023215557.12581-26-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines that write IO to Work queue, send SRRs and raw frames.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 723 +++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/elx/efct/efct_hw.h |  19 ++
 2 files changed, 741 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 9ce31326ce38..5e0ecd621f91 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -59,6 +59,8 @@ static void
 efct_hw_wq_process_io(void *arg, u8 *cqe, int status);
 static void
 efct_hw_wq_process_abort(void *arg, u8 *cqe, int status);
+static void
+hw_wq_submit_pending(struct hw_wq_s *wq, u32 update_free_count);
 
 static enum efct_hw_rtn_e
 efct_hw_link_event_init(struct efct_hw_s *hw)
@@ -3774,7 +3776,7 @@ efct_hw_wq_process_abort(void *arg, u8 *cqe, int status)
 	    ext == SLI4_FC_LOCAL_REJECT_NO_XRI &&
 		io->done) {
 		efct_hw_done_t done = io->done;
-		void		*arg = io->arg;
+		void *arg = io->arg;
 
 		io->done = NULL;
 
@@ -3903,3 +3905,722 @@ efct_hw_flush(struct efct_hw_s *hw)
 
 	return 0;
 }
+
+/**
+ * @brief Write a HW IO to a work queue.
+ *
+ * @par Description
+ * A HW IO is written to a work queue.
+ *
+ * @param wq Pointer to work queue.
+ * @param wqe Pointer to WQ entry.
+ *
+ * @n @b Note: Assumes the SLI-4 queue lock is held.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+static int
+_efct_hw_wq_write(struct hw_wq_s *wq, struct efct_hw_wqe_s *wqe)
+{
+	int rc;
+	int queue_rc;
+
+	/* Every so often, set the wqec bit to generate comsummed completions */
+	if (wq->wqec_count)
+		wq->wqec_count--;
+
+	if (wq->wqec_count == 0) {
+		struct sli4_generic_wqe_s *genwqe = (void *)wqe->wqebuf;
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
+	if (queue_rc < 0)
+		rc = -1;
+	else
+		rc = 0;
+
+	return rc;
+}
+
+/**
+ * @brief Write a HW IO to a work queue.
+ *
+ * @par Description
+ * A HW IO is written to a work queue.
+ *
+ * @param wq Pointer to work queue.
+ * @param wqe Pointer to WQE entry.
+ *
+ * @n @b Note: Takes the SLI-4 queue lock.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_hw_wq_write(struct hw_wq_s *wq, struct efct_hw_wqe_s *wqe)
+{
+	int rc = 0;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&wq->queue->lock, flags);
+	if (!list_empty(&wq->pending_list)) {
+		INIT_LIST_HEAD(&wqe->list_entry);
+		list_add_tail(&wqe->list_entry, &wq->pending_list);
+		wq->wq_pending_count++;
+		while ((wq->free_count > 0) &&
+		       ((wqe = list_first_entry(&wq->pending_list,
+					struct efct_hw_wqe_s, list_entry))
+			 != NULL)) {
+			list_del(&wqe->list_entry);
+			rc = _efct_hw_wq_write(wq, wqe);
+			if (rc < 0)
+				break;
+			if (wqe->abort_wqe_submit_needed) {
+				wqe->abort_wqe_submit_needed = false;
+				sli_abort_wqe(&wq->hw->sli,
+					      wqe->wqebuf,
+					      wq->hw->sli.wqe_size,
+					      SLI_ABORT_XRI,
+					      wqe->send_abts, wqe->id,
+					      0, wqe->abort_reqtag,
+					      SLI4_CQ_DEFAULT);
+
+				INIT_LIST_HEAD(&wqe->list_entry);
+				list_add_tail(&wqe->list_entry,
+					      &wq->pending_list);
+				wq->wq_pending_count++;
+			}
+		}
+	} else {
+		if (wq->free_count > 0) {
+			rc = _efct_hw_wq_write(wq, wqe);
+		} else {
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
+/**
+ * @brief Update free count and submit any pending HW IOs
+ *
+ * @par Description
+ * The WQ free count is updated, and any pending HW IOs are submitted that
+ * will fit in the queue.
+ *
+ * @param wq Pointer to work queue.
+ * @param update_free_count Value added to WQs free count.
+ *
+ * @return None.
+ */
+static void
+hw_wq_submit_pending(struct hw_wq_s *wq, u32 update_free_count)
+{
+	struct efct_hw_wqe_s *wqe;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&wq->queue->lock, flags);
+
+	/* Update free count with value passed in */
+	wq->free_count += update_free_count;
+
+	while ((wq->free_count > 0) && (!list_empty(&wq->pending_list))) {
+		wqe = list_first_entry(&wq->pending_list,
+				       struct efct_hw_wqe_s, list_entry);
+		list_del(&wqe->list_entry);
+		_efct_hw_wq_write(wq, wqe);
+
+		if (wqe->abort_wqe_submit_needed) {
+			wqe->abort_wqe_submit_needed = false;
+			sli_abort_wqe(&wq->hw->sli, wqe->wqebuf,
+				      wq->hw->sli.wqe_size,
+				      SLI_ABORT_XRI, wqe->send_abts, wqe->id,
+				      0, wqe->abort_reqtag, SLI4_CQ_DEFAULT);
+					  INIT_LIST_HEAD(&wqe->list_entry);
+			list_add_tail(&wqe->list_entry, &wq->pending_list);
+			wq->wq_pending_count++;
+		}
+	}
+
+	spin_unlock_irqrestore(&wq->queue->lock, flags);
+}
+
+/**
+ * @ingroup io
+ * @brief Send a Single Request/Response Sequence (SRRS).
+ *
+ * @par Description
+ * This routine supports communication sequences consisting of a single
+ * request and single response between two endpoints. Examples include:
+ *  - Sending an ELS request.
+ *  - Sending an ELS response - To send an ELS response, the caller must provide
+ * the OX_ID from the received request.
+ *  - Sending a FC Common Transport (FC-CT) request - To send a FC-CT request,
+ * the caller must provide the R_CTL, TYPE, and DF_CTL
+ * values to place in the FC frame header.
+ *  .
+ * @n @b Note: The caller is expected to provide both send and receive
+ * buffers for requests. In the case of sending a response, no receive buffer
+ * is necessary and the caller may pass in a NULL pointer.
+ *
+ * @param hw Hardware context.
+ * @param type Type of sequence (ELS request/response, FC-CT).
+ * @param io Previously-allocated HW IO object.
+ * @param send DMA memory holding data to send (for example, ELS request, BLS
+ * response).
+ * @param len Length, in bytes, of data to send.
+ * @param receive Optional DMA memory to hold a response.
+ * @param rnode Destination of data (that is, a remote node).
+ * @param iparam IO parameters (ELS response and FC-CT).
+ * @param cb Function call upon completion of sending the data (may be NULL).
+ * @param arg Argument to pass to IO completion function.
+ *
+ * @return Returns 0 on success, or a non-zero on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_srrs_send(struct efct_hw_s *hw, enum efct_hw_io_type_e type,
+		  struct efct_hw_io_s *io,
+		  struct efc_dma_s *send, u32 len,
+		  struct efc_dma_s *receive, struct efc_remote_node_s *rnode,
+		  union efct_hw_io_param_u *iparam,
+		  efct_hw_srrs_cb_t cb, void *arg)
+{
+	struct sli4_sge_s	*sge = NULL;
+	enum efct_hw_rtn_e	rc = EFCT_HW_RTN_SUCCESS;
+	u16	local_flags = 0;
+	u32 sge0_flags;
+	u32 sge1_flags;
+
+	if (!io || !rnode || !iparam) {
+		pr_err("bad parm hw=%p io=%p s=%p r=%p rn=%p iparm=%p\n",
+			hw, io, send, receive, rnode, iparam);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_test(hw->os,
+			      "cannot send SRRS, HW state=%d\n", hw->state);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	io->rnode = rnode;
+	io->type  = type;
+	io->done = cb;
+	io->arg  = arg;
+
+	sge = io->sgl->virt;
+
+	/* clear both SGE */
+	memset(io->sgl->virt, 0, 2 * sizeof(struct sli4_sge_s));
+
+	sge0_flags = sge[0].dw2_flags;
+	sge1_flags = sge[1].dw2_flags;
+	if (send) {
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
+	if (type == EFCT_HW_ELS_REQ || type == EFCT_HW_FC_CT) {
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
+	switch (type) {
+	case EFCT_HW_ELS_REQ:
+		if (!send ||
+		    sli_els_request64_wqe(&hw->sli, io->wqe.wqebuf,
+					  hw->sli.wqe_size, io->sgl,
+					*((u8 *)send->virt),
+					len, receive->size,
+					iparam->els.timeout,
+					io->indicator, io->reqtag,
+					SLI4_CQ_DEFAULT, rnode->indicator,
+					rnode->sport->indicator,
+					rnode->node_group, rnode->attached,
+					rnode->fc_id, rnode->sport->fc_id)) {
+			efc_log_err(hw->os, "REQ WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_ELS_RSP:
+		if (!send ||
+		    sli_xmit_els_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
+					   hw->sli.wqe_size, send, len,
+					io->indicator, io->reqtag,
+					SLI4_CQ_DEFAULT, iparam->els.ox_id,
+					rnode->indicator,
+					rnode->sport->indicator,
+					rnode->node_group, rnode->attached,
+					rnode->fc_id,
+					local_flags, U32_MAX)) {
+			efc_log_err(hw->os, "RSP WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_ELS_RSP_SID:
+		if (!send ||
+		    sli_xmit_els_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
+					   hw->sli.wqe_size, send, len,
+					io->indicator, io->reqtag,
+					SLI4_CQ_DEFAULT,
+					iparam->els_sid.ox_id,
+					rnode->indicator,
+					rnode->sport->indicator,
+					rnode->node_group, rnode->attached,
+					rnode->fc_id,
+					local_flags, iparam->els_sid.s_id)) {
+			efc_log_err(hw->os, "RSP (SID) WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_FC_CT:
+		if (!send ||
+		    sli_gen_request64_wqe(&hw->sli, io->wqe.wqebuf,
+					  hw->sli.wqe_size, io->sgl,
+					len, receive->size,
+					iparam->fc_ct.timeout, io->indicator,
+					io->reqtag, SLI4_CQ_DEFAULT,
+					rnode->node_group, rnode->fc_id,
+					rnode->indicator,
+					iparam->fc_ct.r_ctl,
+					iparam->fc_ct.type,
+					iparam->fc_ct.df_ctl)) {
+			efc_log_err(hw->os, "GEN WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_FC_CT_RSP:
+		if (!send ||
+		    sli_xmit_sequence64_wqe(&hw->sli, io->wqe.wqebuf,
+					    hw->sli.wqe_size, io->sgl,
+					len, iparam->fc_ct_rsp.timeout,
+					iparam->fc_ct_rsp.ox_id,
+					io->indicator, io->reqtag,
+					rnode->node_group, rnode->fc_id,
+					rnode->indicator,
+					iparam->fc_ct_rsp.r_ctl,
+					iparam->fc_ct_rsp.type,
+					iparam->fc_ct_rsp.df_ctl)) {
+			efc_log_err(hw->os, "XMIT SEQ WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_BLS_ACC:
+	case EFCT_HW_BLS_RJT:
+	{
+		struct sli_bls_payload_s	bls;
+
+		if (type == EFCT_HW_BLS_ACC) {
+			bls.type = SLI4_SLI_BLS_ACC;
+			memcpy(&bls.u.acc, iparam->bls.payload,
+			       sizeof(bls.u.acc));
+		} else {
+			bls.type = SLI4_SLI_BLS_RJT;
+			memcpy(&bls.u.rjt, iparam->bls.payload,
+			       sizeof(bls.u.rjt));
+		}
+
+		bls.ox_id = cpu_to_le16(iparam->bls.ox_id);
+		bls.rx_id = cpu_to_le16(iparam->bls.rx_id);
+
+		if (sli_xmit_bls_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
+					   hw->sli.wqe_size, &bls,
+					io->indicator, io->reqtag,
+					SLI4_CQ_DEFAULT,
+					rnode->attached, rnode->node_group,
+					rnode->indicator,
+					rnode->sport->indicator,
+					rnode->fc_id, rnode->sport->fc_id,
+					U32_MAX)) {
+			efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	}
+	case EFCT_HW_BLS_ACC_SID:
+	{
+		struct sli_bls_payload_s	bls;
+
+		bls.type = SLI4_SLI_BLS_ACC;
+		memcpy(&bls.u.acc, iparam->bls_sid.payload,
+		       sizeof(bls.u.acc));
+
+		bls.ox_id = cpu_to_le16(iparam->bls_sid.ox_id);
+		bls.rx_id = cpu_to_le16(iparam->bls_sid.rx_id);
+
+		if (sli_xmit_bls_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
+					   hw->sli.wqe_size, &bls,
+					io->indicator, io->reqtag,
+					SLI4_CQ_DEFAULT,
+					rnode->attached, rnode->node_group,
+					rnode->indicator,
+					rnode->sport->indicator,
+					rnode->fc_id, rnode->sport->fc_id,
+					iparam->bls_sid.s_id)) {
+			efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE SID error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	}
+	default:
+		efc_log_err(hw->os, "bad SRRS type %#x\n", type);
+		rc = EFCT_HW_RTN_ERROR;
+	}
+
+	if (rc == EFCT_HW_RTN_SUCCESS) {
+		if (!io->wq)
+			io->wq = efct_hw_queue_next_wq(hw, io);
+
+		io->xbusy = true;
+
+		/*
+		 * Add IO to active io wqe list before submitting, in case the
+		 * wcqe processing preempts this thread.
+		 */
+		io->wq->use_count++;
+		efct_hw_add_io_timed_wqe(hw, io);
+		rc = efct_hw_wq_write(io->wq, &io->wqe);
+		if (rc >= 0) {
+			/* non-negative return is success */
+			rc = 0;
+		} else {
+			/* failed to write wqe, remove from active wqe list */
+			efc_log_err(hw->os,
+				     "sli_queue_write failed: %d\n", rc);
+			io->xbusy = false;
+			efct_hw_remove_io_timed_wqe(hw, io);
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * @ingroup io
+ * @brief Send a read, write, or response IO.
+ *
+ * @par Description
+ * This routine supports sending a higher-level IO (for example, FCP) between
+ * two endpoints as a target or initiator. Examples include:
+ *  - Sending read data and good response (target).
+ *  - Sending a response (target with no data or after receiving write data).
+ *  .
+ * This routine assumes all IOs use the SGL associated with the HW IO. Prior to
+ * calling this routine, the data should be loaded using efct_hw_io_add_sge().
+ *
+ * @param hw Hardware context.
+ * @param type Type of IO (target read, target response, and so on).
+ * @param io Previously-allocated HW IO object.
+ * @param len Length, in bytes, of data to send.
+ * @param iparam IO parameters.
+ * @param rnode Destination of data (that is, a remote node).
+ * @param cb Function call upon completion of sending data (may be NULL).
+ * @param arg Argument to pass to IO completion function.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ *
+ */
+enum efct_hw_rtn_e
+efct_hw_io_send(struct efct_hw_s *hw, enum efct_hw_io_type_e type,
+		struct efct_hw_io_s *io,
+		u32 len, union efct_hw_io_param_u *iparam,
+		struct efc_remote_node_s *rnode, void *cb, void *arg)
+{
+	enum efct_hw_rtn_e	rc = EFCT_HW_RTN_SUCCESS;
+	u32	rpi;
+	bool send_wqe = true;
+
+	if (!io || !rnode || !iparam) {
+		pr_err("bad parm hw=%p io=%p iparam=%p rnode=%p\n",
+			hw, io, iparam, rnode);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_err(hw->os, "cannot send IO, HW state=%d\n",
+			     hw->state);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	rpi = rnode->indicator;
+
+	/*
+	 * Save state needed during later stages
+	 */
+	io->rnode = rnode;
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
+		xfer->ft_burst_len = cpu_to_be32(len);
+
+		if (io->xbusy)
+			flags |= SLI4_IO_CONTINUATION;
+		else
+			flags &= ~SLI4_IO_CONTINUATION;
+
+		io->tgt_wqe_timeout = iparam->fcp_tgt.timeout;
+
+		if (sli_fcp_treceive64_wqe(&hw->sli,
+					   io->wqe.wqebuf,
+					   hw->sli.wqe_size,
+					   &io->def_sgl,
+					   io->first_data_sge,
+					   iparam->fcp_tgt.offset, len,
+					   io->indicator, io->reqtag,
+					   SLI4_CQ_DEFAULT,
+					   iparam->fcp_tgt.ox_id, rpi,
+					   rnode->node_group,
+					   rnode->fc_id, flags,
+					   iparam->fcp_tgt.dif_oper,
+					   iparam->fcp_tgt.blk_size,
+					   iparam->fcp_tgt.cs_ctl,
+					   iparam->fcp_tgt.app_id)) {
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
+		io->tgt_wqe_timeout = iparam->fcp_tgt.timeout;
+		if (sli_fcp_tsend64_wqe(&hw->sli, io->wqe.wqebuf,
+					hw->sli.wqe_size, &io->def_sgl,
+					io->first_data_sge,
+					iparam->fcp_tgt.offset, len,
+					io->indicator, io->reqtag,
+					SLI4_CQ_DEFAULT, iparam->fcp_tgt.ox_id,
+					rpi, rnode->node_group,
+					rnode->fc_id, flags,
+					iparam->fcp_tgt.dif_oper,
+					iparam->fcp_tgt.blk_size,
+					iparam->fcp_tgt.cs_ctl,
+					iparam->fcp_tgt.app_id)) {
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
+		io->tgt_wqe_timeout = iparam->fcp_tgt.timeout;
+		if (sli_fcp_trsp64_wqe(&hw->sli, io->wqe.wqebuf,
+				       hw->sli.wqe_size, &io->def_sgl,
+				       len, io->indicator, io->reqtag,
+				       SLI4_CQ_DEFAULT, iparam->fcp_tgt.ox_id,
+					rpi, rnode->node_group, rnode->fc_id,
+					flags, iparam->fcp_tgt.cs_ctl,
+				       0, iparam->fcp_tgt.app_id)) {
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
+		if (!io->wq)
+			io->wq = efct_hw_queue_next_wq(hw, io);
+
+		io->xbusy = true;
+
+		/*
+		 * Add IO to active io wqe list before submitting, in case the
+		 * wcqe processing preempts this thread.
+		 */
+		hw->tcmd_wq_submit[io->wq->instance]++;
+		io->wq->use_count++;
+		efct_hw_add_io_timed_wqe(hw, io);
+		rc = efct_hw_wq_write(io->wq, &io->wqe);
+		if (rc >= 0) {
+			/* non-negative return is success */
+			rc = 0;
+		} else {
+			/* failed to write wqe, remove from active wqe list */
+			efc_log_err(hw->os,
+				     "sli_queue_write failed: %d\n", rc);
+			io->xbusy = false;
+			efct_hw_remove_io_timed_wqe(hw, io);
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * @brief Send a raw frame
+ *
+ * @par Description
+ * Using the SEND_FRAME_WQE, a frame consisting of header and payload is sent.
+ *
+ * @param hw Pointer to HW object.
+ * @param hdr Pointer to a little endian formatted FC header.
+ * @param sof Value to use as the frame SOF.
+ * @param eof Value to use as the frame EOF.
+ * @param payload Pointer to payload DMA buffer.
+ * @param ctx Pointer to caller provided send frame context.
+ * @param callback Callback function.
+ * @param arg Callback function argument.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_send_frame(struct efct_hw_s *hw, struct fc_frame_header *hdr,
+		   u8 sof, u8 eof, struct efc_dma_s *payload,
+		   struct efct_hw_send_frame_context_s *ctx,
+		   void (*callback)(void *arg, u8 *cqe, int status),
+		   void *arg)
+{
+	int rc;
+	struct efct_hw_wqe_s *wqe;
+	u32 xri;
+	struct hw_wq_s *wq;
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
+	/* Choose a work queue, first look for a class[1] wq, otherwise just
+	 * use wq[0]
+	 */
+	wq = efct_varray_iter_next(hw->wq_class_array[1]);
+	if (!wq)
+		wq = hw->hw_wq[0];
+
+	/* Set XRI and RX_ID in the header based on which WQ, and which
+	 * send_frame_io we are using
+	 */
+	xri = wq->send_frame_io->indicator;
+
+	/* Build the send frame WQE */
+	rc = sli_send_frame_wqe(&hw->sli, wqe->wqebuf,
+				hw->sli.wqe_size, sof, eof,
+				(u32 *)hdr, payload, payload->len,
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
+
+/**
+ * @brief Called to obtain the count for the specified type.
+ *
+ * @param hw Hardware context.
+ * @param io_count_type IO count type (inuse, free, wait_free).
+ *
+ * @return Returns the number of IOs on the specified list type.
+ */
+u32
+efct_hw_io_get_count(struct efct_hw_s *hw,
+		     enum efct_hw_io_count_type_e io_count_type)
+{
+	struct efct_hw_io_s *io = NULL;
+	u32 count = 0;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&hw->io_lock, flags);
+
+	switch (io_count_type) {
+	case EFCT_HW_IO_INUSE_COUNT:
+		list_for_each_entry(io, &hw->io_inuse, list_entry) {
+			count = count + 1;
+		}
+		break;
+	case EFCT_HW_IO_FREE_COUNT:
+		list_for_each_entry(io, &hw->io_free, list_entry) {
+			count = count + 1;
+		}
+		break;
+	case EFCT_HW_IO_WAIT_FREE_COUNT:
+		list_for_each_entry(io, &hw->io_wait_free, list_entry) {
+			count = count + 1;
+		}
+		break;
+	case EFCT_HW_IO_N_TOTAL_IO_COUNT:
+		count = hw->config.n_io;
+		break;
+	}
+
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+
+	return count;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 8a487df2338d..7f1c4091d91a 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -1112,4 +1112,23 @@ efct_hw_process(struct efct_hw_s *hw, u32 vector, u32 max_isr_time_msec);
 extern int
 efct_hw_queue_hash_find(struct efct_queue_hash_s *hash, u16 id);
 
+int efct_hw_wq_write(struct hw_wq_s *wq, struct efct_hw_wqe_s *wqe);
+enum efct_hw_rtn_e
+efct_hw_send_frame(struct efct_hw_s *hw, struct fc_frame_header *hdr,
+		   u8 sof, u8 eof, struct efc_dma_s *payload,
+		struct efct_hw_send_frame_context_s *ctx,
+		void (*callback)(void *arg, u8 *cqe, int status),
+		void *arg);
+typedef int(*efct_hw_srrs_cb_t)(struct efct_hw_io_s *io,
+				struct efc_remote_node_s *rnode, u32 length,
+				int status, u32 ext_status, void *arg);
+extern enum efct_hw_rtn_e
+efct_hw_srrs_send(struct efct_hw_s *hw, enum efct_hw_io_type_e type,
+		  struct efct_hw_io_s *io,
+		  struct efc_dma_s *send, u32 len,
+		  struct efc_dma_s *receive, struct efc_remote_node_s *rnode,
+		  union efct_hw_io_param_u *iparam,
+		  efct_hw_srrs_cb_t cb,
+		  void *arg);
+
 #endif /* __EFCT_H__ */
-- 
2.13.7

