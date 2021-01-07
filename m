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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0628C4332D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B634A235FF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbhAGXAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbhAGXAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 18:00:49 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1164C0612AB
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2021 14:59:34 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id j13so5050867pjz.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 14:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+5z3jfmfD/61VedoO4uuPeWZIfp6E+0YwASOjWtstxc=;
        b=jDTInvoASDQpNweEl6/nddwgwTSlGkZyDWYkQk0B9czOgwOFGO/iBV+ARdBU2cQD+2
         39yFB2o6DpsSYNc8LFS8Pu9lOpJOtzG2E8hE8xuiM89LUcqMR7/nIZLT5tz7fJT7wMaw
         y1tnKk7C8cIHBqvdwOEfNcDYjkvT7xU7OEOZKfTOjoPrcw69spBo3jNWOlmdmFLTMqlu
         yEB+izm3X9rELKmtsENtzXKS5QANEwwMogL4USdJZNpaRo3enUieVRfy/aJdZHxLEaqd
         HgkdbugBw1IFaMDfbParROI0/PJyqCfFLghCQ3saeLsXcTZelYZh1D+0JbDHdDygnqB+
         6HLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+5z3jfmfD/61VedoO4uuPeWZIfp6E+0YwASOjWtstxc=;
        b=d2ckLWtrw3AQzR/TjM40gfVnbbHwuriiddaCu6NAUv4WrH/csopMIiad7u52h4I7Og
         r4snB6K63lCOLsFFEb5cHClQRweGKFXxfEWEa7eQCjjK8MXb1JLWwiE7cc9i+UtdK/Da
         xYJKuQL9rnDwCu4zqR5mfWO4rSD5OD4xNIwFFLcO7cxC9vjAC802CeNSrfTMGgI20q37
         FVZ99B3ejjanQVINpFJ+sOpCu0yCurTunl/t51rG9fZ8yX6yVH6K71bNLyB7DySQ7KnN
         Y6rRokWzRAKVc1iYkPAfEYKB2OaiXEkGQE5d7p8IHEkmGSGdy/2HS1wGuWDFK2RHCjER
         uRPQ==
X-Gm-Message-State: AOAM532hOb0b4segpusQgjKgFCKfl4nw/abngnZlUFWryzuFFPLMpz/U
        GpoBw1vN4FfwTTiYK940PMUueGTHcL4R1g==
X-Google-Smtp-Source: ABdhPJw6WT4jmrpbqujuka1CT/fGTw1rrFGqN9R7KJK8dFp2hZK4VdEqy1ZDGJoCS7Ul+P6ByXaxlQ==
X-Received: by 2002:a17:902:c38b:b029:db:fa4b:5d31 with SMTP id g11-20020a170902c38bb02900dbfa4b5d31mr4083478plg.5.1610060373870;
        Thu, 07 Jan 2021 14:59:33 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l197sm6881405pfd.97.2021.01.07.14.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:59:32 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v7 23/31] elx: efct: Unsolicited FC frame processing routines
Date:   Thu,  7 Jan 2021 14:58:57 -0800
Message-Id: <20210107225905.18186-24-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107225905.18186-1-jsmart2021@gmail.com>
References: <20210107225905.18186-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to handle unsolicited FC frames.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/elx/efct/efct_unsol.c | 493 +++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_unsol.h |  17 +
 2 files changed, 510 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.c
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.h

diff --git a/drivers/scsi/elx/efct/efct_unsol.c b/drivers/scsi/elx/efct/efct_unsol.c
new file mode 100644
index 000000000000..a11a6a0e238b
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_unsol.c
@@ -0,0 +1,493 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
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
+		efc_log_err(io->node->efct, "TMF x%x rejected\n", tm_flags);
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
+		efc_log_debug(efct, "efct_hw_send_frame failed: %d\n", rc);
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
+		efc_log_debug(efct, "efct_sframe_send_fcp_rsp failed %d\n", rc);
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
+		efc_log_info(node->efct, "Abort ox_id [%04x] rx_id [%04x]\n",
+			     ox_id, rx_id);
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
+		efc_log_info(node->efct, "Abort: ox_id [%04x], IO not found\n",
+			     ox_id);
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
+		efc_log_err(efct,
+			    "SCSI IO allocation failed for ABTS received ");
+		efc_log_err(efct, "s_id %06x d_id %06x ox_id %04x rx_id %04x\n",
+			    ntoh24(hdr->fh_s_id), ntoh24(hdr->fh_d_id),
+			    be16_to_cpu(hdr->fh_ox_id),
+			    be16_to_cpu(hdr->fh_rx_id));
+	}
+
+	return EFC_SUCCESS;
+}
diff --git a/drivers/scsi/elx/efct/efct_unsol.h b/drivers/scsi/elx/efct/efct_unsol.h
new file mode 100644
index 000000000000..16d1e3ba1833
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_unsol.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
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

