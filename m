Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40CEC41604
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7DB820709
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ba4lggsx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390848AbgJLWwh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390747AbgJLWwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:32 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FADC0613D8
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:30 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r10so15881075pgb.10
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=j2b8hrom6SW4Gs/xDyGJWGdGlVZMNUJygKep1tZIesQ=;
        b=Ba4lggsxtXsvbdWVebNE5EqrbPyMjXkeZSTySvS5Sseu542mS0+yq5k6LOBNxArqu6
         RdgYKZMBijCkPd+4336IUPwp/3b0LyqiBz6M9gKK9nFdR/owq8Yr91RF6DsMsF6k9pQu
         Pii+k94cfCUk2Zma+B9al/19odrSohYIYxL8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=j2b8hrom6SW4Gs/xDyGJWGdGlVZMNUJygKep1tZIesQ=;
        b=O3LpP17dFt74+HJC6jQf0pIeCQT/V5qRF69xU0hXlRCv9EtrXnT/QBFGtexAzQ0tcn
         iYjke+OCh2MSJ+aogZG9/JGBJnJFAcoZlgpsjVPxrvPlS3M/1xXQVPts+0rA4/t7fQRJ
         vHPVDIsVWx0M1TTUQga4QAtksAALPoHzVQeLyEo7lS7Wja3GAfr2OhFWPJf0OZu2q2gn
         6GokSKYH5+O0QhMotYosPIrBWRp8e6WaQJ8eqBAAiPTeJp2S2r6HT7Ft1EaszmcPIK3N
         k416ArItsuINTGiC2EiDi1HHwKQjxr0z/j3kKVJTxZDHqRBa1+Kub88aDg8CLbruCZkE
         6U6g==
X-Gm-Message-State: AOAM531+HSua2dJ9UR0zCmSBOLTM09N7K4Upe7hyNCgTM7EYKp4yIbqC
        bNJhoRD+mi6VdL5VyhoGFiT72BdlyIOSo5vBC40RHiJtVaExw6CISgcbc5OVdz5QYJIHnX2o+j4
        Uiu9XAZ1oUhg0zJMal9X3yyRql5NKV8KpZPUf3e7QGtfto5L2n0J0lwmNRyzqZ23axI+TjtDDaB
        gRdh8=
X-Google-Smtp-Source: ABdhPJwC56P5bCGYNloI7xwdDM8UtfKha+Mzvmn33kXlNbHzEiZ6sOs8pJAlAPgh0oPWqg0XNeJh7w==
X-Received: by 2002:a63:4f45:: with SMTP id p5mr14500676pgl.341.1602543148679;
        Mon, 12 Oct 2020 15:52:28 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:27 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 23/31] elx: efct: Unsolicited FC frame processing routines
Date:   Mon, 12 Oct 2020 15:51:39 -0700
Message-Id: <20201012225147.54404-24-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000028106605b1812772"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000028106605b1812772
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to handle unsolicited FC frames.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Changed unsol frame handling.
  Lookup for efct target node based on d_id and s_id. Take ref count and
     release when cmd handling is done.
  Now IO path doesn't lookup for discovery objects. So no impact on IO
     path because of EFC lock.
---
 drivers/scsi/elx/efct/efct_unsol.c | 495 +++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_unsol.h |  17 +
 2 files changed, 512 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.c
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.h

diff --git a/drivers/scsi/elx/efct/efct_unsol.c b/drivers/scsi/elx/efct/efct_unsol.c
new file mode 100644
index 000000000000..8fa7d0bacfbe
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_unsol.c
@@ -0,0 +1,495 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_unsol.h"
+
+#define frame_printf(efct, hdr, fmt, ...) \
+	do { \
+		char s_id_text[16]; \
+		efc_node_fcid_display(ntoh24((hdr)->fh_s_id), \
+			s_id_text, sizeof(s_id_text)); \
+		efc_log_debug(efct, "[%06x.%s] %02x/%04x/%04x: " fmt, \
+			ntoh24((hdr)->fh_d_id), s_id_text, \
+			(hdr)->fh_r_ctl, be16_to_cpu((hdr)->fh_ox_id), \
+			be16_to_cpu((hdr)->fh_rx_id), ##__VA_ARGS__); \
+	} while (0)
+
+static struct efct_node *
+efct_node_find(struct efct *efct, u32 port_id, u32 node_id)
+{
+	struct efct_node *node;
+	u64 id = (u64) port_id << 32 | node_id;
+
+	/*
+	 * During node shutdown, Lookup will be removed first,
+	 * before announcing to backend. So, no new IOs will be allowed
+	 */
+	/* Find a target node, given s_id and d_id */
+	node = xa_load(&efct->lookup, id);
+	if (node)
+		kref_get(&node->ref);
+
+	return node;
+}
+
+static int
+efct_dispatch_frame(struct efct *efct, struct efc_hw_sequence *seq)
+{
+	struct efct_node *node;
+	struct fc_frame_header *hdr;
+	u32 s_id, d_id;
+
+	hdr = seq->header->dma.virt;
+
+	/* extract the s_id and d_id */
+	s_id = ntoh24(hdr->fh_s_id);
+	d_id = ntoh24(hdr->fh_d_id);
+
+	if (!(hdr->fh_type == FC_TYPE_FCP || hdr->fh_type == FC_TYPE_BLS))
+		return EFC_FAIL;
+
+	if (hdr->fh_type == FC_TYPE_FCP) {
+		node = efct_node_find(efct, d_id, s_id);
+		if (!node) {
+			efc_log_err(efct,
+				    "Node not found, drop cmd d_id:%x s_id:%x\n",
+				    d_id, s_id);
+			efct_hw_sequence_free(&efct->hw, seq);
+			return EFC_SUCCESS;
+		}
+
+		efct_dispatch_fcp_cmd(node, seq);
+	} else {
+		node = efct_node_find(efct, d_id, s_id);
+		if (!node) {
+			efc_log_err(efct, "Node not found, d_id:%x s_id:%x\n",
+				    d_id, s_id);
+			return EFC_FAIL;
+		}
+
+		efc_log_err(efct, "Received ABTS for Node:%p\n", node);
+		efct_node_recv_abts_frame(node, seq);
+	}
+
+	kref_put(&node->ref, node->release);
+	efct_hw_sequence_free(&efct->hw, seq);
+	return EFC_SUCCESS;
+}
+
+int
+efct_unsolicited_cb(void *arg, struct efc_hw_sequence *seq)
+{
+	struct efct *efct = arg;
+
+	/* Process FCP command */
+	if (!efct_dispatch_frame(efct, seq))
+		return EFC_SUCCESS;
+
+	/* Forward frame to discovery lib */
+	efc_dispatch_frame(efct->efcport, seq);
+	return EFC_SUCCESS;
+}
+
+static int
+efct_fc_tmf_rejected_cb(struct efct_io *io,
+			enum efct_scsi_io_status scsi_status,
+			u32 flags, void *arg)
+{
+	efct_scsi_io_free(io);
+	return EFC_SUCCESS;
+}
+
+static void
+efct_dispatch_unsol_tmf(struct efct_io *io, u8 tm_flags, u32 lun)
+{
+	u32 i;
+	struct {
+		u32 mask;
+		enum efct_scsi_tmf_cmd cmd;
+	} tmflist[] = {
+	{FCP_TMF_ABT_TASK_SET, EFCT_SCSI_TMF_ABORT_TASK_SET},
+	{FCP_TMF_CLR_TASK_SET, EFCT_SCSI_TMF_CLEAR_TASK_SET},
+	{FCP_TMF_LUN_RESET, EFCT_SCSI_TMF_LOGICAL_UNIT_RESET},
+	{FCP_TMF_TGT_RESET, EFCT_SCSI_TMF_TARGET_RESET},
+	{FCP_TMF_CLR_ACA, EFCT_SCSI_TMF_CLEAR_ACA} };
+
+	io->exp_xfer_len = 0;
+
+	for (i = 0; i < ARRAY_SIZE(tmflist); i++) {
+		if (tmflist[i].mask & tm_flags) {
+			io->tmf_cmd = tmflist[i].cmd;
+			efct_scsi_recv_tmf(io, lun, tmflist[i].cmd, NULL, 0);
+			break;
+		}
+	}
+	if (i == ARRAY_SIZE(tmflist)) {
+		/* Not handled */
+		node_printf(io->node, "TMF x%x rejected\n", tm_flags);
+		efct_scsi_send_tmf_resp(io, EFCT_SCSI_TMF_FUNCTION_REJECTED,
+					NULL, efct_fc_tmf_rejected_cb, NULL);
+	}
+}
+
+static int
+efct_validate_fcp_cmd(struct efct *efct, struct efc_hw_sequence *seq)
+{
+	/*
+	 * If we received less than FCP_CMND_IU bytes, assume that the frame is
+	 * corrupted in some way and drop it.
+	 * This was seen when jamming the FCTL
+	 * fill bytes field.
+	 */
+	if (seq->payload->dma.len < sizeof(struct fcp_cmnd)) {
+		struct fc_frame_header	*fchdr = seq->header->dma.virt;
+
+		efc_log_debug(efct,
+			"drop ox_id %04x with payload (%zd) less than (%zd)\n",
+				    be16_to_cpu(fchdr->fh_ox_id),
+				    seq->payload->dma.len,
+				    sizeof(struct fcp_cmnd));
+		return EFC_FAIL;
+	}
+	return EFC_SUCCESS;
+}
+
+static void
+efct_populate_io_fcp_cmd(struct efct_io *io, struct fcp_cmnd *cmnd,
+			 struct fc_frame_header *fchdr, bool sit)
+{
+	io->init_task_tag = be16_to_cpu(fchdr->fh_ox_id);
+	/* note, tgt_task_tag, hw_tag  set when HW io is allocated */
+	io->exp_xfer_len = be32_to_cpu(cmnd->fc_dl);
+	io->transferred = 0;
+
+	/* The upper 7 bits of CS_CTL is the frame priority thru the SAN.
+	 * Our assertion here is, the priority given to a frame containing
+	 * the FCP cmd should be the priority given to ALL frames contained
+	 * in that IO. Thus we need to save the incoming CS_CTL here.
+	 */
+	if (ntoh24(fchdr->fh_f_ctl) & FC_FC_RES_B17)
+		io->cs_ctl = fchdr->fh_cs_ctl;
+	else
+		io->cs_ctl = 0;
+
+	io->seq_init = sit;
+}
+
+static u32
+efct_get_flags_fcp_cmd(struct fcp_cmnd *cmnd)
+{
+	u32 flags = 0;
+
+	switch (cmnd->fc_pri_ta & FCP_PTA_MASK) {
+	case FCP_PTA_SIMPLE:
+		flags |= EFCT_SCSI_CMD_SIMPLE;
+		break;
+	case FCP_PTA_HEADQ:
+		flags |= EFCT_SCSI_CMD_HEAD_OF_QUEUE;
+		break;
+	case FCP_PTA_ORDERED:
+		flags |= EFCT_SCSI_CMD_ORDERED;
+		break;
+	case FCP_PTA_ACA:
+		flags |= EFCT_SCSI_CMD_ACA;
+		break;
+	}
+	if (cmnd->fc_flags & FCP_CFL_WRDATA)
+		flags |= EFCT_SCSI_CMD_DIR_IN;
+	if (cmnd->fc_flags & FCP_CFL_RDDATA)
+		flags |= EFCT_SCSI_CMD_DIR_OUT;
+
+	return flags;
+}
+
+static void
+efct_sframe_common_send_cb(void *arg, u8 *cqe, int status)
+{
+	struct efct_hw_send_frame_context *ctx = arg;
+	struct efct_hw *hw = ctx->hw;
+
+	/* Free WQ completion callback */
+	efct_hw_reqtag_free(hw, ctx->wqcb);
+
+	/* Free sequence */
+	efct_hw_sequence_free(hw, ctx->seq);
+}
+
+static int
+efct_sframe_common_send(struct efct_node *node,
+			struct efc_hw_sequence *seq,
+			enum fc_rctl r_ctl, u32 f_ctl,
+			u8 type, void *payload, u32 payload_len)
+{
+	struct efct *efct = node->efct;
+	struct efct_hw *hw = &efct->hw;
+	enum efct_hw_rtn rc = 0;
+	struct fc_frame_header *req_hdr = seq->header->dma.virt;
+	struct fc_frame_header hdr;
+	struct efct_hw_send_frame_context *ctx;
+
+	u32 heap_size = seq->payload->dma.size;
+	uintptr_t heap_phys_base = seq->payload->dma.phys;
+	u8 *heap_virt_base = seq->payload->dma.virt;
+	u32 heap_offset = 0;
+
+	/* Build the FC header reusing the RQ header DMA buffer */
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.fh_r_ctl = r_ctl;
+	/* send it back to whomever sent it to us */
+	memcpy(hdr.fh_d_id, req_hdr->fh_s_id, sizeof(hdr.fh_d_id));
+	memcpy(hdr.fh_s_id, req_hdr->fh_d_id, sizeof(hdr.fh_s_id));
+	hdr.fh_type = type;
+	hton24(hdr.fh_f_ctl, f_ctl);
+	hdr.fh_ox_id = req_hdr->fh_ox_id;
+	hdr.fh_rx_id = req_hdr->fh_rx_id;
+	hdr.fh_cs_ctl = 0;
+	hdr.fh_df_ctl = 0;
+	hdr.fh_seq_cnt = 0;
+	hdr.fh_parm_offset = 0;
+
+	/*
+	 * send_frame_seq_id is an atomic, we just let it increment,
+	 * while storing only the low 8 bits to hdr->seq_id
+	 */
+	hdr.fh_seq_id = (u8)atomic_add_return(1, &hw->send_frame_seq_id);
+	hdr.fh_seq_id--;
+
+	/* Allocate and fill in the send frame request context */
+	ctx = (void *)(heap_virt_base + heap_offset);
+	heap_offset += sizeof(*ctx);
+	if (heap_offset > heap_size) {
+		efc_log_err(efct, "Fill send frame failed offset %d size %d\n",
+				heap_offset, heap_size);
+		return EFC_FAIL;
+	}
+
+	memset(ctx, 0, sizeof(*ctx));
+
+	/* Save sequence */
+	ctx->seq = seq;
+
+	/* Allocate a response payload DMA buffer from the heap */
+	ctx->payload.phys = heap_phys_base + heap_offset;
+	ctx->payload.virt = heap_virt_base + heap_offset;
+	ctx->payload.size = payload_len;
+	ctx->payload.len = payload_len;
+	heap_offset += payload_len;
+	if (heap_offset > heap_size) {
+		efc_log_err(efct, "Fill send frame failed offset %d size %d\n",
+				heap_offset, heap_size);
+		return EFC_FAIL;
+	}
+
+	/* Copy the payload in */
+	memcpy(ctx->payload.virt, payload, payload_len);
+
+	/* Send */
+	rc = efct_hw_send_frame(&efct->hw, (void *)&hdr, FC_SOF_N3,
+				FC_EOF_T, &ctx->payload, ctx,
+				efct_sframe_common_send_cb, ctx);
+	if (rc)
+		efc_log_test(efct, "efct_hw_send_frame failed: %d\n", rc);
+
+	return rc;
+}
+
+static int
+efct_sframe_send_fcp_rsp(struct efct_node *node, struct efc_hw_sequence *seq,
+			 void *rsp, u32 rsp_len)
+{
+	return efct_sframe_common_send(node, seq, FC_RCTL_DD_CMD_STATUS,
+				      FC_FC_EX_CTX |
+				      FC_FC_LAST_SEQ |
+				      FC_FC_END_SEQ |
+				      FC_FC_SEQ_INIT,
+				      FC_TYPE_FCP,
+				      rsp, rsp_len);
+}
+
+static int
+efct_sframe_send_task_set_full_or_busy(struct efct_node *node,
+				       struct efc_hw_sequence *seq)
+{
+	struct fcp_resp_with_ext fcprsp;
+	struct fcp_cmnd *fcpcmd = seq->payload->dma.virt;
+	int rc = 0;
+	unsigned long flags = 0;
+	struct efct *efct = node->efct;
+
+	/* construct task set full or busy response */
+	memset(&fcprsp, 0, sizeof(fcprsp));
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	fcprsp.resp.fr_status = list_empty(&node->active_ios) ?
+				SAM_STAT_BUSY : SAM_STAT_TASK_SET_FULL;
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+	*((u32 *)&fcprsp.ext.fr_resid) = be32_to_cpu(fcpcmd->fc_dl);
+
+	/* send it using send_frame */
+	rc = efct_sframe_send_fcp_rsp(node, seq, &fcprsp, sizeof(fcprsp));
+	if (rc)
+		efc_log_test(efct, "efct_sframe_send_fcp_rsp failed: %d\n", rc);
+
+	return rc;
+}
+
+int
+efct_dispatch_fcp_cmd(struct efct_node *node, struct efc_hw_sequence *seq)
+{
+	struct efct *efct = node->efct;
+	struct fc_frame_header *fchdr = seq->header->dma.virt;
+	struct fcp_cmnd	*cmnd = NULL;
+	struct efct_io *io = NULL;
+	u32 lun = U32_MAX;
+
+	if (!seq->payload) {
+		efc_log_err(efct, "Sequence payload is NULL.\n");
+		return EFC_FAIL;
+	}
+
+	cmnd = seq->payload->dma.virt;
+
+	/* perform FCP_CMND validation check(s) */
+	if (efct_validate_fcp_cmd(efct, seq))
+		return EFC_FAIL;
+
+	lun = scsilun_to_int(&cmnd->fc_lun);
+	if (lun == U32_MAX)
+		return EFC_FAIL;
+
+	io = efct_scsi_io_alloc(node);
+	if (!io) {
+		int rc;
+
+		/* Use SEND_FRAME to send task set full or busy */
+		rc = efct_sframe_send_task_set_full_or_busy(node, seq);
+		if (rc)
+			efc_log_err(efct, "Failed to send busy task: %d\n", rc);
+
+		return rc;
+	}
+
+	io->hw_priv = seq->hw_priv;
+
+	io->app_id = 0;
+
+	/* RQ pair, if we got here, SIT=1 */
+	efct_populate_io_fcp_cmd(io, cmnd, fchdr, true);
+
+	if (cmnd->fc_tm_flags) {
+		efct_dispatch_unsol_tmf(io, cmnd->fc_tm_flags, lun);
+	} else {
+		u32 flags = efct_get_flags_fcp_cmd(cmnd);
+
+		if (cmnd->fc_flags & FCP_CFL_LEN_MASK) {
+			efc_log_err(efct, "Additional CDB not supported\n");
+			return EFC_FAIL;
+		}
+		/*
+		 * Can return failure for things like task set full and UAs,
+		 * no need to treat as a dropped frame if rc != 0
+		 */
+		efct_scsi_recv_cmd(io, lun, cmnd->fc_cdb,
+				   sizeof(cmnd->fc_cdb), flags);
+	}
+
+	return EFC_SUCCESS;
+}
+
+static int
+efct_process_abts(struct efct_io *io, struct fc_frame_header *hdr)
+{
+	struct efct_node *node = io->node;
+	struct efct *efct = io->efct;
+	u16 ox_id = be16_to_cpu(hdr->fh_ox_id);
+	u16 rx_id = be16_to_cpu(hdr->fh_rx_id);
+	struct efct_io *abortio;
+
+	/* Find IO and attempt to take a reference on it */
+	abortio = efct_io_find_tgt_io(efct, node, ox_id, rx_id);
+
+	if (abortio) {
+		/* Got a reference on the IO. Hold it until backend
+		 * is notified below
+		 */
+		node_printf(node, "Abort request: ox_id [%04x] rx_id [%04x]\n",
+			    ox_id, rx_id);
+
+		/*
+		 * Save the ox_id for the ABTS as the init_task_tag in our
+		 * manufactured
+		 * TMF IO object
+		 */
+		io->display_name = "abts";
+		io->init_task_tag = ox_id;
+		/* don't set tgt_task_tag, don't want to confuse with XRI */
+
+		/*
+		 * Save the rx_id from the ABTS as it is
+		 * needed for the BLS response,
+		 * regardless of the IO context's rx_id
+		 */
+		io->abort_rx_id = rx_id;
+
+		/* Call target server command abort */
+		io->tmf_cmd = EFCT_SCSI_TMF_ABORT_TASK;
+		efct_scsi_recv_tmf(io, abortio->tgt_io.lun,
+				   EFCT_SCSI_TMF_ABORT_TASK, abortio, 0);
+
+		/*
+		 * Backend will have taken an additional
+		 * reference on the IO if needed;
+		 * done with current reference.
+		 */
+		kref_put(&abortio->ref, abortio->release);
+	} else {
+		/*
+		 * Either IO was not found or it has been
+		 * freed between finding it
+		 * and attempting to get the reference,
+		 */
+		node_printf(node, "Abort request: ox_id [%04x], IO not found\n",
+			    ox_id);
+
+		/* Send a BA_RJT */
+		efct_bls_send_rjt(io, hdr);
+	}
+	return EFC_SUCCESS;
+}
+
+int
+efct_node_recv_abts_frame(struct efct_node *node, struct efc_hw_sequence *seq)
+{
+	struct efct *efct = node->efct;
+	struct fc_frame_header *hdr = seq->header->dma.virt;
+	struct efct_io *io = NULL;
+
+	node->abort_cnt++;
+	io = efct_scsi_io_alloc(node);
+	if (io) {
+		io->hw_priv = seq->hw_priv;
+		/* If we got this far, SIT=1 */
+		io->seq_init = 1;
+
+		/* fill out generic fields */
+		io->efct = efct;
+		io->node = node;
+		io->cmd_tgt = true;
+
+		efct_process_abts(io, seq->header->dma.virt);
+	} else {
+		node_printf(node,
+			    "SCSI IO allocation failed for ABTS received ");
+		node_printf(node,
+			    "s_id %06x d_id %06x ox_id %04x rx_id %04x\n",
+			ntoh24(hdr->fh_s_id),
+			ntoh24(hdr->fh_d_id),
+			be16_to_cpu(hdr->fh_ox_id),
+			be16_to_cpu(hdr->fh_rx_id));
+	}
+
+	return EFC_SUCCESS;
+}
diff --git a/drivers/scsi/elx/efct/efct_unsol.h b/drivers/scsi/elx/efct/efct_unsol.h
new file mode 100644
index 000000000000..92cd805de6f6
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_unsol.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__OSC_UNSOL_H__)
+#define __OSC_UNSOL_H__
+
+int
+efct_unsolicited_cb(void *arg, struct efc_hw_sequence *seq);
+int
+efct_dispatch_fcp_cmd(struct efct_node *node, struct efc_hw_sequence *seq);
+int
+efct_node_recv_abts_frame(struct efct_node *node, struct efc_hw_sequence *seq);
+
+#endif /* __OSC_UNSOL_H__ */
-- 
2.26.2


--00000000000028106605b1812772
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgRKfPhNpeRYF4AWuf
gwhBo61t+ndLrzmaqkXgddnZMVYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjI5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKOLlNOTFYQiXoUwA/GMAsnGhmxAdJHk19qV
XJCj2uY8ZvheH0V3+NG6lTweXFnlRmK3lKm7WVlKzlwWurYJd2YFop99hk7WgOuXa6Beix2ptHpP
hrV2/vUQt60zpjqAsGhTKooXc7lf9OscyRHmAHzl5jWd9nqB5xvJApydsLwz9h6qKXaDGUwEAjVG
/5gH8q/9mbrYp53KpyL2ez4+90KFuN83j9PesnPbpQR3QGydSmOSZ0BPrnXC7+Wb6shhcJJ9e4ac
lBjEJ4PnXgisdWthZiYJlbdKHhcng5yrwg6onUZOdhJHaJWeDaIBwNI7UhZdUnEF39xHrTbIF6vN
rU4=
--00000000000028106605b1812772--
