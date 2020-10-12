Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB18C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0BA20838
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HI8MZ4xZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390774AbgJLWwd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390688AbgJLWw1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:27 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28100C0613D5
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:26 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l18so6803711pgg.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=igo3CCZYDpzxvI1i0plDXiDdItLWmSO93tihtZvDcSQ=;
        b=HI8MZ4xZqJGpOVYf2ehAYNxyU3WXLT+6XNZQFb+E/um8i0NdTEbY+bjgrFnmZXowfc
         NHEsDQHCog66SKEwhANyWt0sG996F/zjMQPbmirt+zCvQ8RQ6+E8i1p4ZtXSe34NPYpa
         7LcPlzQdBn17MTZwo6iR/psEni/rMq0sIZVjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=igo3CCZYDpzxvI1i0plDXiDdItLWmSO93tihtZvDcSQ=;
        b=qsBscnkanGX464c3QNM5NoYrJylVZQLMncaoPxjh1gkDq32v2j986yJDFoLJq5g8m6
         ZeO9g5e5Fyb6LureG60YcxaxsQD2D/jtDJCKMfEN2DPuWhVEy60uZUXyZJuYJddshiiK
         6wHcCdJe8mBZvQWe8HWVvLWWHpHPlhubcEk5I9phCOWQ0Tn9hTId9CdjPJxkBT3lFhlN
         osEJxat9IwPF93fbO2/8GL019ODPwkzWF6vzuiZmhfNehVy//21jvh2qbhULtiFH66Z6
         W102ak/72Qpn4QaunG5eQwv58kCpXbnqDdmr280YeWJAeumeg3ckygkC5NNnM225ODRv
         aIpA==
X-Gm-Message-State: AOAM530zqiU0crWyv558aYMSS+1mH/8BBSheoyYn4BHuA3SPRxRPE9tn
        KO8orqbO5SLd9Ve4jubBpVopc5GTfIDRbSaG9JbQg6HmO4uGbX7NyPYUUWbkLP2dTwUZ3JxonXl
        Mx3a+T+Zp4610yIUCKemRSUH2e23mzA2vG2HHIl3rNwAGZLxI3yk8mu3yIkx2LvAxc0SP/aZafK
        Q6Fxk=
X-Google-Smtp-Source: ABdhPJznTHFUM/+/WbHIBdeqMh6A9C/67JNcxslNYUzyAe/X0FLSiqsboKlaxXOTG1cO78zwqTGJ4w==
X-Received: by 2002:a17:90a:7c0c:: with SMTP id v12mr21905669pjf.71.1602543144471;
        Mon, 12 Oct 2020 15:52:24 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:23 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 20/31] elx: efct: RQ buffer, memory pool allocation and deallocation APIs
Date:   Mon, 12 Oct 2020 15:51:36 -0700
Message-Id: <20201012225147.54404-21-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e5818305b1812620"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e5818305b1812620
Content-Transfer-Encoding: 8bit

This patch continues the efct driver population.

This patch adds driver definitions for:
RQ data buffer allocation and deallocate.
Memory pool allocation and deallocation APIs.
Mailbox command submission and completion routines.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 411 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |   9 +
 2 files changed, 420 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 0af13aa12e35..fdde7f70bedf 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1164,3 +1164,414 @@ efct_get_wwpn(struct efct_hw *hw)
 	memcpy(p, sli->wwpn, sizeof(p));
 	return get_unaligned_be64(p);
 }
+
+static struct efc_hw_rq_buffer *
+efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
+			u32 size)
+{
+	struct efct *efct = hw->os;
+	struct efc_hw_rq_buffer *rq_buf = NULL;
+	struct efc_hw_rq_buffer *prq;
+	u32 i;
+
+	if (count != 0) {
+		rq_buf = kmalloc_array(count, sizeof(*rq_buf), GFP_KERNEL);
+		if (!rq_buf)
+			return NULL;
+		memset(rq_buf, 0, sizeof(*rq_buf) * count);
+
+		for (i = 0, prq = rq_buf; i < count; i ++, prq++) {
+			prq->rqindex = rqindex;
+			prq->dma.size = size;
+			prq->dma.virt = dma_alloc_coherent(&efct->pci->dev,
+							   prq->dma.size,
+							   &prq->dma.phys,
+							   GFP_DMA);
+			if (!prq->dma.virt) {
+				efc_log_err(hw->os, "DMA allocation failed\n");
+				kfree(rq_buf);
+				rq_buf = NULL;
+				break;
+			}
+		}
+	}
+	return rq_buf;
+}
+
+static void
+efct_hw_rx_buffer_free(struct efct_hw *hw,
+		       struct efc_hw_rq_buffer *rq_buf,
+			u32 count)
+{
+	struct efct *efct = hw->os;
+	u32 i;
+	struct efc_hw_rq_buffer *prq;
+
+	if (rq_buf) {
+		for (i = 0, prq = rq_buf; i < count; i++, prq++) {
+			dma_free_coherent(&efct->pci->dev,
+					  prq->dma.size, prq->dma.virt,
+					  prq->dma.phys);
+			memset(&prq->dma, 0, sizeof(struct efc_dma));
+		}
+
+		kfree(rq_buf);
+	}
+}
+
+enum efct_hw_rtn
+efct_hw_rx_allocate(struct efct_hw *hw)
+{
+	struct efct *efct = hw->os;
+	u32 i;
+	int rc = EFCT_HW_RTN_SUCCESS;
+	u32 rqindex = 0;
+	u32 hdr_size = EFCT_HW_RQ_SIZE_HDR;
+	u32 payload_size = hw->config.rq_default_buffer_size;
+
+	rqindex = 0;
+
+	for (i = 0; i < hw->hw_rq_count; i++) {
+		struct hw_rq *rq = hw->hw_rq[i];
+
+		/* Allocate header buffers */
+		rq->hdr_buf = efct_hw_rx_buffer_alloc(hw, rqindex,
+						      rq->entry_count,
+						      hdr_size);
+		if (!rq->hdr_buf) {
+			efc_log_err(efct,
+				     "efct_hw_rx_buffer_alloc hdr_buf failed\n");
+			rc = EFCT_HW_RTN_ERROR;
+			break;
+		}
+
+		efc_log_debug(hw->os,
+			       "rq[%2d] rq_id %02d header  %4d by %4d bytes\n",
+			      i, rq->hdr->id, rq->entry_count, hdr_size);
+
+		rqindex++;
+
+		/* Allocate payload buffers */
+		rq->payload_buf = efct_hw_rx_buffer_alloc(hw, rqindex,
+							  rq->entry_count,
+							  payload_size);
+		if (!rq->payload_buf) {
+			efc_log_err(efct,
+				     "efct_hw_rx_buffer_alloc fb_buf failed\n");
+			rc = EFCT_HW_RTN_ERROR;
+			break;
+		}
+		efc_log_debug(hw->os,
+			       "rq[%2d] rq_id %02d default %4d by %4d bytes\n",
+			      i, rq->data->id, rq->entry_count, payload_size);
+		rqindex++;
+	}
+
+	return rc ? EFCT_HW_RTN_ERROR : EFCT_HW_RTN_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_rx_post(struct efct_hw *hw)
+{
+	u32 i;
+	u32 idx;
+	u32 rq_idx;
+	int rc = 0;
+
+	if (!hw->seq_pool) {
+		u32 count = 0;
+
+		for (i = 0; i < hw->hw_rq_count; i++)
+			count += hw->hw_rq[i]->entry_count;
+
+		hw->seq_pool = kmalloc_array(count,
+				sizeof(struct efc_hw_sequence),	GFP_KERNEL);
+		if (!hw->seq_pool)
+			return EFCT_HW_RTN_NO_MEMORY;
+	}
+
+	/*
+	 * In RQ pair mode, we MUST post the header and payload buffer at the
+	 * same time.
+	 */
+	for (rq_idx = 0, idx = 0; rq_idx < hw->hw_rq_count; rq_idx++) {
+		struct hw_rq *rq = hw->hw_rq[rq_idx];
+
+		for (i = 0; i < rq->entry_count - 1; i++) {
+			struct efc_hw_sequence *seq;
+
+			seq = hw->seq_pool + idx;
+			if (!seq) {
+				rc = -1;
+				break;
+			}
+			idx++;
+			seq->header = &rq->hdr_buf[i];
+			seq->payload = &rq->payload_buf[i];
+			rc = efct_hw_sequence_free(hw, seq);
+			if (rc)
+				break;
+		}
+		if (rc)
+			break;
+	}
+
+	if (rc && hw->seq_pool)
+		kfree(hw->seq_pool);
+
+	return rc;
+}
+
+void
+efct_hw_rx_free(struct efct_hw *hw)
+{
+	u32 i;
+
+	/* Free hw_rq buffers */
+	for (i = 0; i < hw->hw_rq_count; i++) {
+		struct hw_rq *rq = hw->hw_rq[i];
+
+		if (rq) {
+			efct_hw_rx_buffer_free(hw, rq->hdr_buf,
+					       rq->entry_count);
+			rq->hdr_buf = NULL;
+			efct_hw_rx_buffer_free(hw, rq->payload_buf,
+					       rq->entry_count);
+			rq->payload_buf = NULL;
+		}
+	}
+}
+
+static int
+efct_hw_cmd_submit_pending(struct efct_hw *hw)
+{
+	struct efct_command_ctx *ctx = NULL;
+	int rc = 0;
+
+	/* Assumes lock held */
+
+	/* Only submit MQE if there's room */
+	while (hw->cmd_head_count < (EFCT_HW_MQ_DEPTH - 1) &&
+	       !list_empty(&hw->cmd_pending)) {
+		ctx = list_first_entry(&hw->cmd_pending,
+				       struct efct_command_ctx, list_entry);
+		if (!ctx)
+			break;
+
+		list_del(&ctx->list_entry);
+
+		INIT_LIST_HEAD(&ctx->list_entry);
+		list_add_tail(&ctx->list_entry, &hw->cmd_head);
+		hw->cmd_head_count++;
+		if (sli_mq_write(&hw->sli, hw->mq, ctx->buf) < 0) {
+			efc_log_test(hw->os,
+				      "sli_queue_write failed: %d\n", rc);
+			rc = -1;
+			break;
+		}
+	}
+	return rc;
+}
+
+enum efct_hw_rtn
+efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb, void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
+	unsigned long flags = 0;
+	void *bmbx = NULL;
+
+	/*
+	 * If the chip is in an error state (UE'd) then reject this mailbox
+	 *  command.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		efc_log_crit(hw->os,
+			      "status=%#x error1=%#x error2=%#x\n",
+			sli_reg_read_status(&hw->sli),
+			sli_reg_read_err1(&hw->sli),
+			sli_reg_read_err2(&hw->sli));
+
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Send a mailbox command to the hardware, and either wait for
+	 * a completion (EFCT_CMD_POLL) or get an optional asynchronous
+	 * completion (EFCT_CMD_NOWAIT).
+	 */
+
+	if (opts == EFCT_CMD_POLL) {
+		mutex_lock(&hw->bmbx_lock);
+		bmbx = hw->sli.bmbx.virt;
+
+		memset(bmbx, 0, SLI4_BMBX_SIZE);
+		memcpy(bmbx, cmd, SLI4_BMBX_SIZE);
+
+		if (sli_bmbx_command(&hw->sli) == 0) {
+			rc = EFCT_HW_RTN_SUCCESS;
+			memcpy(cmd, bmbx, SLI4_BMBX_SIZE);
+		}
+		mutex_unlock(&hw->bmbx_lock);
+	} else if (opts == EFCT_CMD_NOWAIT) {
+		struct efct_command_ctx	*ctx = NULL;
+
+		if (hw->state != EFCT_HW_STATE_ACTIVE) {
+			efc_log_err(hw->os,
+				     "Can't send command, HW state=%d\n",
+				    hw->state);
+			return EFCT_HW_RTN_ERROR;
+		}
+
+		ctx = mempool_alloc(hw->cmd_ctx_pool, GFP_ATOMIC);
+		if (!ctx)
+			return EFCT_HW_RTN_NO_RESOURCES;
+
+		memset(ctx, 0, sizeof(struct efct_command_ctx));
+
+		if (cb) {
+			ctx->cb = cb;
+			ctx->arg = arg;
+		}
+
+		memcpy(ctx->buf, cmd, SLI4_BMBX_SIZE);
+		ctx->ctx = hw;
+
+		spin_lock_irqsave(&hw->cmd_lock, flags);
+
+		/* Add to pending list */
+		INIT_LIST_HEAD(&ctx->list_entry);
+		list_add_tail(&ctx->list_entry, &hw->cmd_pending);
+
+		/* Submit as much of the pending list as we can */
+		rc = efct_hw_cmd_submit_pending(hw);
+
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_command_process(struct efct_hw *hw, int status, u8 *mqe,
+			size_t size)
+{
+	struct efct_command_ctx *ctx = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&hw->cmd_lock, flags);
+	if (!list_empty(&hw->cmd_head)) {
+		ctx = list_first_entry(&hw->cmd_head,
+				       struct efct_command_ctx, list_entry);
+		list_del(&ctx->list_entry);
+	}
+	if (!ctx) {
+		efc_log_err(hw->os, "no command context?!?\n");
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+		return EFC_FAIL;
+	}
+
+	hw->cmd_head_count--;
+
+	/* Post any pending requests */
+	efct_hw_cmd_submit_pending(hw);
+
+	spin_unlock_irqrestore(&hw->cmd_lock, flags);
+
+	if (ctx->cb) {
+		if (ctx->buf)
+			memcpy(ctx->buf, mqe, size);
+
+		ctx->cb(hw, status, ctx->buf, ctx->arg);
+	}
+
+	mempool_free(ctx, hw->cmd_ctx_pool);
+
+	return EFC_SUCCESS;
+}
+
+static int
+efct_hw_mq_process(struct efct_hw *hw,
+		   int status, struct sli4_queue *mq)
+{
+	u8 mqe[SLI4_BMBX_SIZE];
+
+	if (!sli_mq_read(&hw->sli, mq, mqe))
+		efct_hw_command_process(hw, status, mqe, mq->size);
+
+	return EFC_SUCCESS;
+}
+
+static int
+efct_hw_command_cancel(struct efct_hw *hw)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&hw->cmd_lock, flags);
+
+	/*
+	 * Manually clean up remaining commands. Note: since this calls
+	 * efct_hw_command_process(), we'll also process the cmd_pending
+	 * list, so no need to manually clean that out.
+	 */
+	while (!list_empty(&hw->cmd_head)) {
+		u8		mqe[SLI4_BMBX_SIZE] = { 0 };
+		struct efct_command_ctx *ctx =
+	list_first_entry(&hw->cmd_head, struct efct_command_ctx, list_entry);
+
+		efc_log_test(hw->os, "hung command %08x\n",
+			      !ctx ? U32_MAX :
+			      (!ctx->buf ? U32_MAX :
+			       *((u32 *)ctx->buf)));
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+		efct_hw_command_process(hw, -1, mqe, SLI4_BMBX_SIZE);
+		spin_lock_irqsave(&hw->cmd_lock, flags);
+	}
+
+	spin_unlock_irqrestore(&hw->cmd_lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+static void
+efct_mbox_rsp_cb(struct efct_hw *hw, int status, u8 *mqe, void *arg)
+{
+	struct efct_mbox_rqst_ctx *ctx = arg;
+
+	if (ctx) {
+		if (ctx->callback)
+			(*ctx->callback)(hw->os->efcport, status, mqe,
+					 ctx->arg);
+
+		mempool_free(ctx, hw->mbox_rqst_pool);
+	}
+}
+
+int
+efct_issue_mbox_rqst(void *base, void *cmd, void *cb, void *arg)
+{
+	int rc = 0;
+	struct efct_mbox_rqst_ctx *ctx;
+	struct efct *efct = base;
+	struct efct_hw *hw = &efct->hw;
+
+	/*
+	 * Allocate a callback context (which includes the mbox cmd buffer),
+	 * we need this to be persistent as the mbox cmd submission may be
+	 * queued and executed later execution.
+	 */
+	ctx = mempool_alloc(hw->mbox_rqst_pool, GFP_ATOMIC);
+	if (!ctx)
+		return EFC_FAIL;
+
+	ctx->callback = cb;
+	ctx->arg = arg;
+
+	if (efct_hw_command(hw, cmd, EFCT_CMD_NOWAIT, efct_mbox_rsp_cb, ctx)) {
+		efc_log_err(efct, "issue mbox rqst failure\n");
+		mempool_free(ctx, hw->mbox_rqst_pool);
+		rc = -1;
+	}
+	return rc;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 44649d649229..03787da3f4f7 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -619,4 +619,13 @@ efct_get_wwnn(struct efct_hw *hw);
 uint64_t
 efct_get_wwpn(struct efct_hw *hw);
 
+enum efct_hw_rtn efct_hw_rx_allocate(struct efct_hw *hw);
+enum efct_hw_rtn efct_hw_rx_post(struct efct_hw *hw);
+void efct_hw_rx_free(struct efct_hw *hw);
+enum efct_hw_rtn
+efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb,
+		void *arg);
+int
+efct_issue_mbox_rqst(void *base, void *cmd, void *cb, void *arg);
+
 #endif /* __EFCT_H__ */
-- 
2.26.2


--000000000000e5818305b1812620
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg7UpN4+C77ItfqkXE
FS+L3SeGEbAo6DntHsfi8SBlWH4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjI1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAizSuTBn3XHFuuo3ahlvjQ6mCRxz78JisZD
6ZX1BnOE1tlD2gwYM/8UuUWLBlVScdG1z64CwvZF7YGt7bd8VpwtE9YkrUJ+5NdWHFRzZaWVf4yo
6AqarGBRAlJED8L4Qe+QeZnn3070lblwLJzekMkdmqECLFAoOgn22vZFuV21FeMXqy+N1VL3Dcgp
3miSIqeatD8UKQLa4epChg5fc3DmuXdhuJyELfSj+u52kY7Fd2eUC/g35xFh3hbqOhree6oqtMHW
kqRc0b0+R2TcwiVSvr9QhoSSBUWNPGgoFleS1paJc9cSMxwWr84paDbca30cgdBL4meEu5fqNGHn
fhE=
--000000000000e5818305b1812620--
