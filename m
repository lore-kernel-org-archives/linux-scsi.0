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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB89C2D0EC
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2AD420746
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vQ0ldGk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgDLDdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:50 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39675 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgDLDdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:49 -0400
Received: by mail-pj1-f65.google.com with SMTP id o1so1602507pjs.4
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7cU3tHQuzFnl4pKcOlr98rLFNWyoZUf2xZJQmscRgiE=;
        b=vQ0ldGk3P7Xv0h7ep8icXsb6gNXx8gY0gmAnf/bHFrJo+A1MXAZAp3BuyoTvK6qczF
         8yqtWiYuW91t1okD0tCjQCcz4+ASuSBWmDN4dyGp87jXz2pL6jGVYXNAFFZLhq5vZMGh
         80IFfA6TX/73oLp9Qw8NfDJkrwCA3YX91Bp/iB9yO0LHRJVFpODrWQGcKpfBzq3BksP5
         edlaawT+MqRFxt7fztwd8GT3qlpe5rkz19ivd/PABrCZnuFGzNL8D5o8FWgKeLfpo+Ib
         0afGYo3suKfdpxdddU1WCJxORLYD9/2/ZOIf0jPG4CIqXib/4vW43BvxMsRTxPFB+627
         cpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7cU3tHQuzFnl4pKcOlr98rLFNWyoZUf2xZJQmscRgiE=;
        b=DiCrP2iA+cKHooekDVlVCc27vLsfUmcRcLps8vSC+DQDatrgd8cZBqU5Mk9v+URTCQ
         sVk0FoWIXcuFP8TDIPvTHbrpIXg84OnPBYu+Wp6qZ3RC0m72TpMUt5ubkkG4puhOt6Xg
         Fe3eCXXnbJ+CV0pUUUQ328NBfB/0nRwsQt+bCjxgPdyjQky28Aah4uhQwTO0QeRBwK8j
         LTP9tj0/8vyZ+e7rkAV1wArmMeYsGb0IKmuTcHecgy0tt6tAhcUWum9siEGSGR+hW5Je
         rSO4Lu1bOST2FzzjlZPVhDdfj+2S7KHgUoHEFWaw3qWDncVnKqk/7puBgoXdXbBpPA8a
         UP7g==
X-Gm-Message-State: AGi0Pub84hmU9oM7C9NEhqgZ+D52OhwU/I3tmBuR8nh06JZIpLAud/in
        OkMYocwtW3Oc5JxHLg77b7FehIWg
X-Google-Smtp-Source: APiQypJyyfQk2aN2i1P0BCoxFJoo1Ci9RzmBIt/p0R1DJ46pO70HVKBvNQ7w9TUB246km4cdNV1YyQ==
X-Received: by 2002:a17:90a:8cf:: with SMTP id 15mr14333804pjn.136.1586662426991;
        Sat, 11 Apr 2020 20:33:46 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:46 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 21/31] elx: efct: Unsolicited FC frame processing routines
Date:   Sat, 11 Apr 2020 20:32:53 -0700
Message-Id: <20200412033303.29574-22-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200412033303.29574-1-jsmart2021@gmail.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to handle unsolicited FC frames.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
v3:
  Return defined values
---
 drivers/scsi/elx/efct/efct_hw.c    |   1 +
 drivers/scsi/elx/efct/efct_unsol.c | 813 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_unsol.h |  49 +++
 3 files changed, 863 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.c
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.h

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 6cdc7e27b148..fd3c2dec3ef6 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -6,6 +6,7 @@
 
 #include "efct_driver.h"
 #include "efct_hw.h"
+#include "efct_unsol.h"
 
 static enum efct_hw_rtn
 efct_hw_link_event_init(struct efct_hw *hw)
diff --git a/drivers/scsi/elx/efct/efct_unsol.c b/drivers/scsi/elx/efct/efct_unsol.c
new file mode 100644
index 000000000000..e8611524e2cd
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_unsol.c
@@ -0,0 +1,813 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_els.h"
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
+static int
+efct_unsol_process(struct efct *efct, struct efc_hw_sequence *seq)
+{
+	struct efct_xport_fcfi *xport_fcfi = NULL;
+	struct efc_domain *domain;
+	struct efct_hw *hw = &efct->hw;
+	unsigned long flags = 0;
+
+	xport_fcfi = &efct->xport->fcfi;
+
+	/* If the transport FCFI entry is NULL, then drop the frame */
+	if (!xport_fcfi) {
+		efc_log_test(efct,
+			      "FCFI %d is not valid, dropping frame\n",
+			seq->fcfi);
+
+		efct_hw_sequence_free(&efct->hw, seq);
+		return EFC_SUCCESS;
+	}
+
+	domain = hw->domain;
+
+	/*
+	 * If we are holding frames or the domain is not yet registered or
+	 * there's already frames on the pending list,
+	 * then add the new frame to pending list
+	 */
+	if (!domain ||
+	    xport_fcfi->hold_frames ||
+	    !list_empty(&xport_fcfi->pend_frames)) {
+		spin_lock_irqsave(&xport_fcfi->pend_frames_lock, flags);
+		INIT_LIST_HEAD(&seq->list_entry);
+		list_add_tail(&seq->list_entry, &xport_fcfi->pend_frames);
+		spin_unlock_irqrestore(&xport_fcfi->pend_frames_lock, flags);
+
+		if (domain) {
+			/* immediately process pending frames */
+			efct_domain_process_pending(domain);
+		}
+	} else {
+		/*
+		 * We are not holding frames and pending list is empty,
+		 * just process frame. A non-zero return means the frame
+		 * was not handled - so cleanup
+		 */
+		if (efc_domain_dispatch_frame(domain, seq))
+			efct_hw_sequence_free(&efct->hw, seq);
+	}
+	return EFC_SUCCESS;
+}
+
+int
+efct_unsolicited_cb(void *arg, struct efc_hw_sequence *seq)
+{
+	struct efct *efct = arg;
+	int rc;
+
+	rc = efct_unsol_process(efct, seq);
+	if (rc)
+		efct_hw_sequence_free(&efct->hw, seq);
+
+	return EFC_SUCCESS;
+}
+
+void
+efct_process_node_pending(struct efc_node *node)
+{
+	struct efct *efct = node->efc->base;
+	struct efc_hw_sequence *seq = NULL;
+	u32 pend_frames_processed = 0;
+	unsigned long flags = 0;
+
+	for (;;) {
+		/* need to check for hold frames condition after each frame
+		 * processed because any given frame could cause a transition
+		 * to a state that holds frames
+		 */
+		if (node->hold_frames)
+			break;
+
+		/* Get next frame/sequence */
+		spin_lock_irqsave(&node->pend_frames_lock, flags);
+		if (!list_empty(&node->pend_frames)) {
+			seq = list_first_entry(&node->pend_frames,
+					struct efc_hw_sequence, list_entry);
+			list_del(&seq->list_entry);
+		}
+		spin_unlock_irqrestore(&node->pend_frames_lock, flags);
+
+		if (!seq) {
+			pend_frames_processed =	node->pend_frames_processed;
+			node->pend_frames_processed = 0;
+			break;
+		}
+		node->pend_frames_processed++;
+
+		/* now dispatch frame(s) to dispatch function */
+		efc_node_dispatch_frame(node, seq);
+		efct_hw_sequence_free(&efct->hw, seq);
+	}
+
+	if (pend_frames_processed != 0)
+		efc_log_debug(efct, "%u node frames held and processed\n",
+			       pend_frames_processed);
+}
+
+static bool efct_domain_frames_held(void *arg)
+{
+	struct efc_domain *domain = (struct efc_domain *)arg;
+	struct efct *efct = domain->efc->base;
+	struct efct_xport_fcfi *xport_fcfi;
+
+	xport_fcfi = &efct->xport->fcfi;
+	return xport_fcfi->hold_frames;
+}
+
+void
+efct_domain_process_pending(struct efc_domain *domain)
+{
+	struct efct *efct = domain->efc->base;
+	struct efct_xport_fcfi *xport_fcfi;
+	struct efc_hw_sequence *seq = NULL;
+	u32 pend_frames_processed = 0;
+	unsigned long flags = 0;
+
+	xport_fcfi = &efct->xport->fcfi;
+
+	for (;;) {
+		/* need to check for hold frames condition after each frame
+		 * processed because any given frame could cause a transition
+		 * to a state that holds frames
+		 */
+		if (efct_domain_frames_held(domain))
+			break;
+
+		/* Get next frame/sequence */
+		spin_lock_irqsave(&xport_fcfi->pend_frames_lock, flags);
+			if (!list_empty(&xport_fcfi->pend_frames)) {
+				seq = list_first_entry(&xport_fcfi->pend_frames,
+						       struct efc_hw_sequence,
+						       list_entry);
+				list_del(&seq->list_entry);
+			}
+			if (!seq) {
+				pend_frames_processed =
+					xport_fcfi->pend_frames_processed;
+				xport_fcfi->pend_frames_processed = 0;
+				spin_unlock_irqrestore(&
+						xport_fcfi->pend_frames_lock,
+						flags);
+				break;
+			}
+			xport_fcfi->pend_frames_processed++;
+		spin_unlock_irqrestore(&xport_fcfi->pend_frames_lock, flags);
+
+		/* now dispatch frame(s) to dispatch function */
+		if (efc_domain_dispatch_frame(domain, seq))
+			efct_hw_sequence_free(&efct->hw, seq);
+
+		seq = NULL;
+	}
+	if (pend_frames_processed != 0)
+		efc_log_debug(efct, "%u domain frames held and processed\n",
+			       pend_frames_processed);
+}
+
+static struct efc_hw_sequence *
+efct_frame_next(struct list_head *pend_list, spinlock_t *list_lock)
+{
+	struct efc_hw_sequence *frame = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(list_lock, flags);
+
+	if (!list_empty(pend_list)) {
+		frame = list_first_entry(pend_list,
+					 struct efc_hw_sequence, list_entry);
+		list_del(&frame->list_entry);
+	}
+
+	spin_unlock_irqrestore(list_lock, flags);
+	return frame;
+}
+
+static int
+efct_purge_pending(struct efct *efct, struct list_head *pend_list,
+		   spinlock_t *list_lock)
+{
+	struct efc_hw_sequence *frame;
+
+	for (;;) {
+		frame = efct_frame_next(pend_list, list_lock);
+		if (!frame)
+			break;
+
+		frame_printf(efct,
+			     (struct fc_frame_header *)frame->header->dma.virt,
+			     "Discarding held frame\n");
+		efct_hw_sequence_free(&efct->hw, frame);
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+efct_node_purge_pending(struct efc *efc, struct efc_node *node)
+{
+	struct efct *efct = efc->base;
+
+	return efct_purge_pending(efct, &node->pend_frames,
+				&node->pend_frames_lock);
+}
+
+int
+efct_domain_purge_pending(struct efc_domain *domain)
+{
+	struct efct *efct = domain->efc->base;
+	struct efct_xport_fcfi *xport_fcfi;
+
+	xport_fcfi = &efct->xport->fcfi;
+	return efct_purge_pending(efct,
+				 &xport_fcfi->pend_frames,
+				 &xport_fcfi->pend_frames_lock);
+}
+
+void
+efct_domain_hold_frames(struct efc *efc, struct efc_domain *domain)
+{
+	struct efct *efct = domain->efc->base;
+	struct efct_xport_fcfi *xport_fcfi;
+
+	xport_fcfi = &efct->xport->fcfi;
+	if (!xport_fcfi->hold_frames) {
+		efc_log_debug(efct, "hold frames set for FCFI %d\n",
+			       domain->fcf_indicator);
+		xport_fcfi->hold_frames = true;
+	}
+}
+
+void
+efct_domain_accept_frames(struct efc *efc, struct efc_domain *domain)
+{
+	struct efct *efct = domain->efc->base;
+	struct efct_xport_fcfi *xport_fcfi;
+
+	xport_fcfi = &efct->xport->fcfi;
+	if (xport_fcfi->hold_frames) {
+		efc_log_debug(efct, "hold frames cleared for FCFI %d\n",
+			       domain->fcf_indicator);
+	}
+	xport_fcfi->hold_frames = false;
+	efct_domain_process_pending(domain);
+}
+
+static int
+efct_fc_tmf_rejected_cb(struct efct_io *io,
+			enum efct_scsi_io_status scsi_status,
+		       u32 flags, void *arg)
+{
+	efct_scsi_io_free(io);
+	return EFC_SUCCESS;
+}
+
+static void
+efct_dispatch_unsolicited_tmf(struct efct_io *io,
+			      u8 task_management_flags,
+			      struct efc_node *node, u32 lun)
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
+		if (tmflist[i].mask & task_management_flags) {
+			io->tmf_cmd = tmflist[i].cmd;
+			efct_scsi_recv_tmf(io, lun, tmflist[i].cmd, NULL, 0);
+			break;
+		}
+	}
+	if (i == ARRAY_SIZE(tmflist)) {
+		/* Not handled */
+		node_printf(node, "TMF x%x rejected\n", task_management_flags);
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
+efct_sframe_common_send(struct efc_node *node,
+			struct efc_hw_sequence *seq,
+			enum fc_rctl r_ctl, u32 f_ctl,
+			u8 type, void *payload, u32 payload_len)
+{
+	struct efct *efct = node->efc->base;
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
+	return rc ? -1 : 0;
+}
+
+static int
+efct_sframe_send_fcp_rsp(struct efc_node *node,
+			 struct efc_hw_sequence *seq,
+			 void *rsp, u32 rsp_len)
+{
+	return efct_sframe_common_send(node, seq,
+				      FC_RCTL_DD_CMD_STATUS,
+				      FC_FC_EX_CTX |
+				      FC_FC_LAST_SEQ |
+				      FC_FC_END_SEQ |
+				      FC_FC_SEQ_INIT,
+				      FC_TYPE_FCP,
+				      rsp, rsp_len);
+}
+
+static int
+efct_sframe_send_task_set_full_or_busy(struct efc_node *node,
+				       struct efc_hw_sequence *seq)
+{
+	struct fcp_resp_with_ext fcprsp;
+	struct fcp_cmnd *fcpcmd = seq->payload->dma.virt;
+	int rc = 0;
+	unsigned long flags = 0;
+	struct efct *efct = node->efc->base;
+
+	/* construct task set full or busy response */
+	memset(&fcprsp, 0, sizeof(fcprsp));
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+		fcprsp.resp.fr_status = list_empty(&node->active_ios) ?
+				SAM_STAT_BUSY : SAM_STAT_TASK_SET_FULL;
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+	*((u32 *)&fcprsp.ext.fr_resid) = be32_to_cpu(fcpcmd->fc_dl);
+
+	/* send it using send_frame */
+	rc = efct_sframe_send_fcp_rsp(node, seq, &fcprsp, sizeof(fcprsp));
+	if (rc)
+		efc_log_test(efct,
+			      "efct_sframe_send_fcp_rsp failed: %d\n",
+			rc);
+
+	return rc;
+}
+
+int
+efct_dispatch_fcp_cmd(struct efc_node *node, struct efc_hw_sequence *seq)
+{
+	struct efc *efc = node->efc;
+	struct efct *efct = efc->base;
+	struct fc_frame_header *fchdr = seq->header->dma.virt;
+	struct fcp_cmnd	*cmnd = NULL;
+	struct efct_io *io = NULL;
+	u32 lun = U32_MAX;
+	int rc = 0;
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
+	io = efct_scsi_io_alloc(node, EFCT_SCSI_IO_ROLE_RESPONDER);
+	if (!io) {
+		/* Use SEND_FRAME to send task set full or busy */
+		rc = efct_sframe_send_task_set_full_or_busy(node, seq);
+		if (rc)
+			efc_log_err(efct, "Failed to send busy task: %d\n", rc);
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
+		efct_dispatch_unsolicited_tmf(io,
+					      cmnd->fc_tm_flags,
+					      node, lun);
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
+int
+efct_sframe_send_bls_acc(struct efc_node *node,
+			 struct efc_hw_sequence *seq)
+{
+	struct fc_frame_header *behdr = seq->header->dma.virt;
+	u16 ox_id = be16_to_cpu(behdr->fh_ox_id);
+	u16 rx_id = be16_to_cpu(behdr->fh_rx_id);
+	struct fc_ba_acc acc = {0};
+
+	acc.ba_ox_id = cpu_to_be16(ox_id);
+	acc.ba_rx_id = cpu_to_be16(rx_id);
+	acc.ba_low_seq_cnt = cpu_to_be16(U16_MAX);
+	acc.ba_high_seq_cnt = cpu_to_be16(U16_MAX);
+
+	return efct_sframe_common_send(node, seq,
+				      FC_RCTL_BA_ACC,
+				      FC_FC_EX_CTX |
+				      FC_FC_LAST_SEQ |
+				      FC_FC_END_SEQ,
+				      FC_TYPE_BLS,
+				      &acc, sizeof(acc));
+}
+
+void
+efct_node_io_cleanup(struct efc *efc, struct efc_node *node, bool force)
+{
+	struct efct_io *io;
+	struct efct_io *next;
+	unsigned long flags = 0;
+	struct efct *efct = efc->base;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	list_for_each_entry_safe(io, next, &node->active_ios, list_entry) {
+		list_del(&io->list_entry);
+		efct_io_pool_io_free(efct->xport->io_pool, io);
+	}
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+}
+
+void
+efct_node_els_cleanup(struct efc *efc, struct efc_node *node,
+		      bool force)
+{
+	struct efct_io *els;
+	struct efct_io *els_next;
+	struct efct_io *ls_acc_io;
+	unsigned long flags = 0;
+	struct efct *efct = efc->base;
+
+	/* first cleanup ELS's that are pending (not yet active) */
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	list_for_each_entry_safe(els, els_next, &node->els_io_pend_list,
+				 list_entry) {
+		/*
+		 * skip the ELS IO for which a response
+		 * will be sent after shutdown
+		 */
+		if (node->send_ls_acc != EFC_NODE_SEND_LS_ACC_NONE &&
+		    els == node->ls_acc_io) {
+			continue;
+		}
+		/*
+		 * can't call efct_els_io_free()
+		 * because lock is held; cleanup manually
+		 */
+		node_printf(node, "Freeing pending els %s\n",
+			    els->display_name);
+		list_del(&els->list_entry);
+
+		dma_free_coherent(&efct->pcidev->dev,
+				  els->els_rsp.size, els->els_rsp.virt,
+				  els->els_rsp.phys);
+		dma_free_coherent(&efct->pcidev->dev,
+				  els->els_req.size, els->els_req.virt,
+				  els->els_req.phys);
+		memset(&els->els_rsp, 0, sizeof(struct efc_dma));
+		memset(&els->els_req, 0, sizeof(struct efc_dma));
+		efct_io_pool_io_free(efct->xport->io_pool, els);
+	}
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+
+	ls_acc_io = node->ls_acc_io;
+
+	if (node->ls_acc_io && ls_acc_io->hio) {
+		/*
+		 * if there's an IO that will result in an LS_ACC after
+		 * shutdown and its HW IO is non-NULL, it better be an
+		 * implicit logout in vanilla sequence coalescing. In this
+		 * case, force the LS_ACC to go out on another XRI (hio)
+		 * since the previous will have been aborted by the UNREG_RPI
+		 */
+		node_printf(node,
+			    "invalidating ls_acc_io due to implicit logo\n");
+
+		/*
+		 * No need to abort because the unreg_rpi
+		 * takes care of it, just free
+		 */
+		efct_hw_io_free(&efct->hw, ls_acc_io->hio);
+
+		/* NULL out hio to force the LS_ACC to grab a new XRI */
+		ls_acc_io->hio = NULL;
+	}
+}
+
+void
+efct_node_abort_all_els(struct efc *efc, struct efc_node *node)
+{
+	struct efct_io *els;
+	struct efct_io *els_next;
+	struct efc_node_cb cbdata;
+	struct efct *efct = efc->base;
+	unsigned long flags = 0;
+
+	memset(&cbdata, 0, sizeof(struct efc_node_cb));
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	list_for_each_entry_safe(els, els_next, &node->els_io_active_list,
+				 list_entry) {
+		if (els->els_req_free)
+			continue;
+		efc_log_debug(efct, "[%s] initiate ELS abort %s\n",
+			       node->display_name, els->display_name);
+		spin_unlock_irqrestore(&node->active_ios_lock, flags);
+		efct_els_abort(els, &cbdata);
+		spin_lock_irqsave(&node->active_ios_lock, flags);
+	}
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+}
+
+static int
+efct_process_abts(struct efct_io *io, struct fc_frame_header *hdr)
+{
+	struct efc_node *node = io->node;
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
+		node_printf(node,
+			    "Abort request: ox_id [%04x], IO not found (exists=%d)\n",
+			    ox_id, (abortio != NULL));
+
+		/* Send a BA_RJT */
+		efct_bls_send_rjt_hdr(io, hdr);
+	}
+	return EFC_SUCCESS;
+}
+
+int
+efct_node_recv_abts_frame(struct efc *efc, struct efc_node *node,
+			  struct efc_hw_sequence *seq)
+{
+	struct efct *efct = efc->base;
+	struct fc_frame_header *hdr = seq->header->dma.virt;
+	struct efct_io *io = NULL;
+
+	node->abort_cnt++;
+
+	io = efct_scsi_io_alloc(node, EFCT_SCSI_IO_ROLE_RESPONDER);
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
index 000000000000..615c83120a00
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_unsol.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__OSC_UNSOL_H__)
+#define __OSC_UNSOL_H__
+
+extern int
+efct_unsolicited_cb(void *arg, struct efc_hw_sequence *seq);
+extern int
+efct_node_purge_pending(struct efc *efc, struct efc_node *node);
+extern void
+efct_process_node_pending(struct efc_node *domain);
+extern void
+efct_domain_process_pending(struct efc_domain *domain);
+extern int
+efct_domain_purge_pending(struct efc_domain *domain);
+extern int
+efct_dispatch_unsolicited_bls(struct efc_node *node,
+			      struct efc_hw_sequence *seq);
+extern void
+efct_domain_hold_frames(struct efc *efc, struct efc_domain *domain);
+extern void
+efct_domain_accept_frames(struct efc *efc, struct efc_domain *domain);
+extern void
+efct_seq_coalesce_cleanup(struct efct_hw_io *io, u8 count);
+extern int
+efct_sframe_send_bls_acc(struct efc_node *node,
+			 struct efc_hw_sequence *seq);
+extern int
+efct_dispatch_fcp_cmd(struct efc_node *node, struct efc_hw_sequence *seq);
+
+extern int
+efct_node_recv_abts_frame(struct efc *efc, struct efc_node *node,
+			  struct efc_hw_sequence *seq);
+extern void
+efct_node_els_cleanup(struct efc *efc, struct efc_node *node,
+		      bool force);
+
+extern void
+efct_node_io_cleanup(struct efc *efc, struct efc_node *node,
+		     bool force);
+
+void
+efct_node_abort_all_els(struct efc *efc, struct efc_node *node);
+
+#endif /* __OSC_UNSOL_H__ */
-- 
2.16.4

