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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EFEC2BB85
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E192073E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjeKkchT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgDLDd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38904 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgDLDdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id p8so2938828pgi.5
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MDKJzcvc0oYDlBkNkVa2opH8tVN3CS9QpLuilh16KwY=;
        b=hjeKkchTn2tP2S+GWtSs7PtptZgoRWCa1z6G/Hgt7eXuT0c+aGJ5bkWM9kpr1lSuOp
         6GtPY1Tq+E4OzuwubZb3BsWck8j+PTW0WKztF7hi6d5NQMgsSmYn+zoIK5C1DH345C8y
         3Xn+KqxQNR1i9Lb+os8i/5SsxkesUuXZlNR5+f2fV4ds2cfQkHJK+7sXowtETFg4EFKs
         R7fpA3L28COwKZXvjnUQVi5R51XtPf49Lwii2eqPtz0Hedn/sy5FiqTu87c8qaDn3kMP
         ikXav66YxLdYk0J7wqQptsziPa4f7TkaNeT6jhnGjbJfc945gdWDTDlsiw1zMZII+OW0
         nhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MDKJzcvc0oYDlBkNkVa2opH8tVN3CS9QpLuilh16KwY=;
        b=NPl5arBtPeebGkQRAPrUitXupfXGtwQh+iXCSiUXKjOcSPpStjPDH/8Zji40P0Y7kt
         GJjfVMYORyihScWTVmUa7xcfDSBazlWVKLTudOO9XVIvGLNMAUvXO4//jnT6ybG6Ehu9
         c/tFtTWFlMtPv19D+0JwTveb9OdN7EMPpzx9vLvVPeh3ptGnc21LOnnQf1ojbe+e4Si/
         983zkP5B445Pz3XvCliaQfLT0sibrdcGyqMpsHRq7Ndis6bn6l3wETuXJA/b3IvT4iRm
         zmgtRm0O6JMrG48UT1+PHrXPX4YZmG0KJToLxAFD8NoNcGtrOaXpzkSNakuP87IV5ZNl
         HidQ==
X-Gm-Message-State: AGi0PuaJO2yS8yzan1y0O1ops4PV84RsLYCwPpjN1eF44hWRMSsZNm4Z
        S4ZqpQuLEx5Qbn6HAschm5al1UPw
X-Google-Smtp-Source: APiQypLGDSAmhG0v3ZQvVpOjwqlZu7Kpf+9ewQtm+paerhAXyNdf12BsfcQwyarr1KwFRkXI57Ha9w==
X-Received: by 2002:a62:1dc2:: with SMTP id d185mr8419733pfd.67.1586662433983;
        Sat, 11 Apr 2020 20:33:53 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 25/31] elx: efct: Hardware IO submission routines
Date:   Sat, 11 Apr 2020 20:32:57 -0700
Message-Id: <20200412033303.29574-26-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200412033303.29574-1-jsmart2021@gmail.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
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
v3:
  Reduced arguments for sli_fcp_tsend64_wqe(), sli_fcp_trsp64_wqe(),
  sli_fcp_treceive64_wqe() calls
---
 drivers/scsi/elx/efct/efct_hw.c | 519 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |  19 ++
 2 files changed, 538 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index fd3c2dec3ef6..26dd9bd1eeef 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2516,3 +2516,522 @@ efct_hw_flush(struct efct_hw *hw)
 
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
+	if (!list_empty(&wq->pending_list)) {
+		INIT_LIST_HEAD(&wqe->list_entry);
+		list_add_tail(&wqe->list_entry, &wq->pending_list);
+		wq->wq_pending_count++;
+		while ((wq->free_count > 0) &&
+		       ((wqe = list_first_entry(&wq->pending_list,
+					struct efct_hw_wqe, list_entry))
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
+ * This routine supports communication sequences consisting of a single
+ * request and single response between two endpoints. Examples include:
+ *  - Sending an ELS request.
+ *  - Sending an ELS response - To send an ELS response, the caller must provide
+ * the OX_ID from the received request.
+ *  - Sending a FC Common Transport (FC-CT) request - To send a FC-CT request,
+ * the caller must provide the R_CTL, TYPE, and DF_CTL
+ * values to place in the FC frame header.
+ */
+enum efct_hw_rtn
+efct_hw_srrs_send(struct efct_hw *hw, enum efct_hw_io_type type,
+		  struct efct_hw_io *io,
+		  struct efc_dma *send, u32 len,
+		  struct efc_dma *receive, struct efc_remote_node *rnode,
+		  union efct_hw_io_param_u *iparam,
+		  efct_hw_srrs_cb_t cb, void *arg)
+{
+	struct sli4_sge	*sge = NULL;
+	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS;
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
+	memset(io->sgl->virt, 0, 2 * sizeof(struct sli4_sge));
+
+	sge0_flags = le32_to_cpu(sge[0].dw2_flags);
+	sge1_flags = le32_to_cpu(sge[1].dw2_flags);
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
+					rnode->attached, rnode->fc_id,
+					rnode->sport->fc_id)) {
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
+					rnode->attached, rnode->fc_id,
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
+					iparam->els.ox_id,
+					rnode->indicator,
+					rnode->sport->indicator,
+					rnode->attached, rnode->fc_id,
+					local_flags, iparam->els.s_id)) {
+			efc_log_err(hw->os, "RSP (SID) WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_FC_CT:
+		if (!send ||
+		    sli_gen_request64_wqe(&hw->sli, io->wqe.wqebuf, io->sgl,
+					len, receive->size, io->indicator,
+					io->reqtag, SLI4_CQ_DEFAULT,
+					rnode->fc_id, rnode->indicator,
+					&iparam->fc_ct)) {
+			efc_log_err(hw->os, "GEN WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_FC_CT_RSP:
+		if (!send ||
+		    sli_xmit_sequence64_wqe(&hw->sli, io->wqe.wqebuf,
+					    io->sgl, len, io->indicator,
+					    io->reqtag, rnode->fc_id,
+					    rnode->indicator, &iparam->fc_ct)) {
+			efc_log_err(hw->os, "XMIT SEQ WQE error\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_BLS_ACC:
+	case EFCT_HW_BLS_RJT:
+	{
+		struct sli_bls_payload	bls;
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
+					rnode->attached,
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
+		struct sli_bls_payload	bls;
+
+		bls.type = SLI4_SLI_BLS_ACC;
+		memcpy(&bls.u.acc, iparam->bls.payload,
+		       sizeof(bls.u.acc));
+
+		bls.ox_id = cpu_to_le16(iparam->bls.ox_id);
+		bls.rx_id = cpu_to_le16(iparam->bls.rx_id);
+
+		if (sli_xmit_bls_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
+					   hw->sli.wqe_size, &bls,
+					io->indicator, io->reqtag,
+					SLI4_CQ_DEFAULT,
+					rnode->attached,
+					rnode->indicator,
+					rnode->sport->indicator,
+					rnode->fc_id, rnode->sport->fc_id,
+					iparam->bls.s_id)) {
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
+
+		io->xbusy = true;
+
+		/*
+		 * Add IO to active io wqe list before submitting, in case the
+		 * wcqe processing preempts this thread.
+		 */
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
+/**
+ * Send a read, write, or response IO.
+ *
+ * This routine supports sending a higher-level IO (for example, FCP) between
+ * two endpoints as a target or initiator. Examples include:
+ *  - Sending read data and good response (target).
+ *  - Sending a response (target with no data or after receiving write data).
+ *  .
+ * This routine assumes all IOs use the SGL associated with the HW IO. Prior to
+ * calling this routine, the data should be loaded using efct_hw_io_add_sge().
+ */
+enum efct_hw_rtn
+efct_hw_io_send(struct efct_hw *hw, enum efct_hw_io_type type,
+		struct efct_hw_io *io,
+		u32 len, union efct_hw_io_param_u *iparam,
+		struct efc_remote_node *rnode, void *cb, void *arg)
+{
+	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS;
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
+		if (sli_fcp_treceive64_wqe(&hw->sli, io->wqe.wqebuf,
+					   &io->def_sgl, io->first_data_sge,
+					   len, io->indicator, io->reqtag,
+					   SLI4_CQ_DEFAULT, rpi, rnode->fc_id,
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
+		io->tgt_wqe_timeout = iparam->fcp_tgt.timeout;
+
+		if (sli_fcp_tsend64_wqe(&hw->sli, io->wqe.wqebuf,
+					&io->def_sgl, io->first_data_sge,
+					len, io->indicator, io->reqtag,
+					SLI4_CQ_DEFAULT, rpi, rnode->fc_id,
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
+		io->tgt_wqe_timeout = iparam->fcp_tgt.timeout;
+
+		if (sli_fcp_trsp64_wqe(&hw->sli, io->wqe.wqebuf,
+				       &io->def_sgl, len, io->indicator,
+				       io->reqtag, SLI4_CQ_DEFAULT, rpi,
+				       rnode->fc_id, 0, &iparam->fcp_tgt)) {
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
+/**
+ * Send a raw frame
+ *
+ * Using the SEND_FRAME_WQE, a frame consisting of header and payload is sent.
+ */
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
+u32
+efct_hw_io_get_count(struct efct_hw *hw,
+		     enum efct_hw_io_count_type io_count_type)
+{
+	struct efct_hw_io *io = NULL;
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
index b427a4eda5a3..36a832f32616 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -714,4 +714,23 @@ efct_hw_process(struct efct_hw *hw, u32 vector, u32 max_isr_time_msec);
 extern int
 efct_hw_queue_hash_find(struct efct_queue_hash *hash, u16 id);
 
+int efct_hw_wq_write(struct hw_wq *wq, struct efct_hw_wqe *wqe);
+enum efct_hw_rtn
+efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
+		   u8 sof, u8 eof, struct efc_dma *payload,
+		struct efct_hw_send_frame_context *ctx,
+		void (*callback)(void *arg, u8 *cqe, int status),
+		void *arg);
+typedef int(*efct_hw_srrs_cb_t)(struct efct_hw_io *io,
+				struct efc_remote_node *rnode, u32 length,
+				int status, u32 ext_status, void *arg);
+extern enum efct_hw_rtn
+efct_hw_srrs_send(struct efct_hw *hw, enum efct_hw_io_type type,
+		  struct efct_hw_io *io,
+		  struct efc_dma *send, u32 len,
+		  struct efc_dma *receive, struct efc_remote_node *rnode,
+		  union efct_hw_io_param_u *iparam,
+		  efct_hw_srrs_cb_t cb,
+		  void *arg);
+
 #endif /* __EFCT_H__ */
-- 
2.16.4

