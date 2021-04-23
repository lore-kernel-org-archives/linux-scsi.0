Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E21C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E9E0613D5
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243971AbhDWXh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244146AbhDWXgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 19:36:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA43FC061346
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:16 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q2so3077109pfk.9
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wie/rQ0oLoJS3GJX+GS+U9s7rwBnqqpC2i7BjN8t/WY=;
        b=W4f8ehuVUVc6GqvnKCDfNfb6I+eXSZ21PQo4M6DuViJe+Xl7N1Oc5HS/yrdb1w/eag
         V8YpAC3b6h/MrguVElhV9+NiAcgsiXHEVycrAtcYbYmmilAhwzmKGICqBfzua5avOOAL
         DucuEegdtZVcCQNUyGoHQMyrT9V7BaFI4yx5LufaUk3aypfqT6EhUXf4oLzLLnBG4Ozt
         +F2ds2TzzE+H+RhN4htKgZ/KNdZouMu5YTQ4XPzeIOJG/PNGomqiN+yhVzxDZwRSKSI7
         hNqDZEengG4kyrnGwdle07sqLdN5Q8mYX5W+js1WA+L6gpwpx4UQPJznlw2lzoJbbEPZ
         0/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wie/rQ0oLoJS3GJX+GS+U9s7rwBnqqpC2i7BjN8t/WY=;
        b=WDnnYotmEjoevmhU3djuf9joXPwOvAe7ZUkg+POH0uzBdQVfZbRIaLMlbyKzpLP29m
         AB9PhEh3alMdZcoJvQy9gPFfs3MaRM+D8AaA1tkIXbQEb+cKkqKN8i0Olzs8Y4nLQNI+
         eSWQ6P8ITUoSOHB6Lpg3ZUMC5u2XbanXIjtnSQu1frNoKLzecOZa9sr6pLl6TpE7MGuN
         GEqNWI85klwhhhQUe5mv4vwPxZjLYpcAbzsCLESmxlQSDEznPJrxQ65a/IhPStgc7GSv
         1HCtNXjaEM07TTbXR/nOP/Gus3a+lgtaIX7w8A/JkMmM1z7TWEHDDZ4wy3XyCjlaMsl3
         iwzA==
X-Gm-Message-State: AOAM532uY0GMAxXK27X2U+MfBFmUtb8gBcG/f0GPESvkIvwciyY93LhO
        1+ZamCB/6P9U1RO4oVkBP8zXKBm4T+g=
X-Google-Smtp-Source: ABdhPJwonvKUP6EH9XFiOGgWWfviAUz0/z+3zeGEHjnA8G4Sz3KsX0JYc8OL/bg2XxDbzwB4sSjyCw==
X-Received: by 2002:a63:a26:: with SMTP id 38mr6072323pgk.279.1619220916237;
        Fri, 23 Apr 2021 16:35:16 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v123sm5346892pfb.80.2021.04.23.16.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 16:35:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v8 20/31] elx: efct: RQ buffer, memory pool allocation and deallocation APIs
Date:   Fri, 23 Apr 2021 16:34:44 -0700
Message-Id: <20210423233455.27243-21-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423233455.27243-1-jsmart2021@gmail.com>
References: <20210423233455.27243-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
RQ data buffer allocation and deallocate.
Memory pool allocation and deallocation APIs.
Mailbox command submission and completion routines.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>

---
v8:
Return value fixes and function prototype changes
---
 drivers/scsi/elx/efct/efct_hw.c | 412 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |   9 +
 2 files changed, 421 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index b227f5f0f2b3..f92b23255a52 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1156,3 +1156,415 @@ efct_get_wwpn(struct efct_hw *hw)
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
+	if (!count)
+		return NULL;
+
+	rq_buf = kmalloc_array(count, sizeof(*rq_buf), GFP_KERNEL);
+	if (!rq_buf)
+		return NULL;
+	memset(rq_buf, 0, sizeof(*rq_buf) * count);
+
+	for (i = 0, prq = rq_buf; i < count; i ++, prq++) {
+		prq->rqindex = rqindex;
+		prq->dma.size = size;
+		prq->dma.virt = dma_alloc_coherent(&efct->pci->dev,
+						   prq->dma.size,
+						   &prq->dma.phys,
+						   GFP_DMA);
+		if (!prq->dma.virt) {
+			efc_log_err(hw->os, "DMA allocation failed\n");
+			kfree(rq_buf);
+			return NULL;
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
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
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
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
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
+static enum efct_hw_rtn
+efct_hw_cmd_submit_pending(struct efct_hw *hw)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+
+	/* Assumes lock held */
+
+	/* Only submit MQE if there's room */
+	while (hw->cmd_head_count < (EFCT_HW_MQ_DEPTH - 1) &&
+	       !list_empty(&hw->cmd_pending)) {
+		struct efct_command_ctx *ctx;
+
+		ctx = list_first_entry(&hw->cmd_pending,
+				       struct efct_command_ctx, list_entry);
+		if (!ctx)
+			break;
+
+		list_del_init(&ctx->list_entry);
+
+		list_add_tail(&ctx->list_entry, &hw->cmd_head);
+		hw->cmd_head_count++;
+		if (sli_mq_write(&hw->sli, hw->mq, ctx->buf) < 0) {
+			efc_log_debug(hw->os,
+				      "sli_queue_write failed: %d\n", rc);
+			rc = EFCT_HW_RTN_ERROR;
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
+	 * command.
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
+		list_del_init(&ctx->list_entry);
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
+		memcpy(ctx->buf, mqe, size);
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
+	int rc;
+
+	rc = sli_mq_read(&hw->sli, mq, mqe);
+	if (!rc)
+		rc = efct_hw_command_process(hw, status, mqe, mq->size);
+
+	return rc;
+}
+
+static int
+efct_hw_command_cancel(struct efct_hw *hw)
+{
+	unsigned long flags = 0;
+	int rc = EFC_SUCCESS;
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
+		struct efct_command_ctx *ctx;
+
+		ctx = list_first_entry(&hw->cmd_head,
+				       struct efct_command_ctx, list_entry);
+
+		efc_log_debug(hw->os, "hung command %08x\n",
+			      !ctx ? U32_MAX :
+			      (!ctx->buf ? U32_MAX :
+			       *((u32 *)ctx->buf)));
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+		rc = efct_hw_command_process(hw, -1, mqe, SLI4_BMBX_SIZE);
+		spin_lock_irqsave(&hw->cmd_lock, flags);
+	}
+
+	spin_unlock_irqrestore(&hw->cmd_lock, flags);
+
+	return rc;
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
+	struct efct_mbox_rqst_ctx *ctx;
+	struct efct *efct = base;
+	struct efct_hw *hw = &efct->hw;
+	enum efct_hw_rtn rc;
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
+	rc = efct_hw_command(hw, cmd, EFCT_CMD_NOWAIT, efct_mbox_rsp_cb, ctx);
+	if (rc) {
+		efc_log_err(efct, "issue mbox rqst failure rc:%d\n", rc);
+		mempool_free(ctx, hw->mbox_rqst_pool);
+		return EFC_FAIL;
+	}
+
+	return EFC_SUCCESS;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 96ffa5ace58d..f40e44357b91 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -616,4 +616,13 @@ efct_get_wwnn(struct efct_hw *hw);
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

