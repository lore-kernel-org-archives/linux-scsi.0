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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0F7CA9EBB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0F6621928
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o44BTAU0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436622AbfJWV4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40695 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436618AbfJWV4k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id o28so23698469wro.7
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nn+f/P6KWd9+LIWXW6ztvkeWul84qk3yM+DlJ3wTr80=;
        b=o44BTAU0Hudp2iDk51aG+tIrvXOHcvw7GnvQ1PWXpMRG/HDnOUWVU2yFO6F+jO3y1s
         q5t9EceCGdktay07PgcuQa8m5rdVLFW6Ch6BTOO9Tvg3hO0Vf0xnBOBKvAliAvyHyjnG
         pILLCYf7uT6AlsFJrX+EMZYTznf3hFGEdjgk9Z8PHFeSsVlsQtnM0tBDK7srrf6e+1Z0
         L/UpDeB1exktkJgULP94PSJ4WYQvOoU13QD8oudJ2RSQlMyzktst6GdiebzHeqSuEFr6
         ROi1VgqkfV8A9qlPC004SuWm5bAmC5W1ICZYgAfTYpIwsC6hPY/+04eMImpzkvI5tNDP
         QhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nn+f/P6KWd9+LIWXW6ztvkeWul84qk3yM+DlJ3wTr80=;
        b=Q7XZYO6GbArNok8onuqC3RLzxVmcz6mylW8ujcRfFlxPjh+FHYwaE6+q8h/Eap5+qH
         ElNgLRXnRP/CJfGiWluqLaFiHYwXLdLCKWlmk89UOPgs+pCAus6pSNE+nUx6RRVEnhx5
         L2yQQ+9SBeuQwkLqvoR5bi5kkfO+nF7BLQoqh0Un2upVZ189lg84bfdgjUMUCcuycMZ2
         /4OJkQltgwB6gMTCZK6vM5LJSynj6MLaoJJrxE/2Hy1vgymNi0/+eZMWAO/EDZzOY3gY
         SsS7Hkn/tkjNIn2pcKg/BPJF+30Fed0DnvqyJbPcU9I+v7LeKfjybnVgs3DC+74ZzmZf
         JHdw==
X-Gm-Message-State: APjAAAWyXJcp3CdaA4L8vWBZgRnEuUG+ikrxCIKbneKbqsiMC5MwVJ6l
        avAhdPKkfBOH7CGyD3gS2UGEAXd5
X-Google-Smtp-Source: APXvYqwpkbdD6aVPb9V/V/Ai53rvkfqms+Z6tG46eQ/f7nYZglJwgxJpJW/X9w6oL6Y6AjQBB0dtVQ==
X-Received: by 2002:adf:9486:: with SMTP id 6mr751273wrr.28.1571867796633;
        Wed, 23 Oct 2019 14:56:36 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 18/32] elx: efct: RQ buffer, memory pool allocation and deallocation APIs
Date:   Wed, 23 Oct 2019 14:55:43 -0700
Message-Id: <20191023215557.12581-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
RQ data buffer allocation and deallocate.
Memory pool allocation and deallocation APIs.
Mailbox command submission and completion routines.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c    | 447 +++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h    |   7 +
 drivers/scsi/elx/efct/efct_utils.c | 662 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_utils.h | 113 +++++++
 4 files changed, 1229 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_utils.c
 create mode 100644 drivers/scsi/elx/efct/efct_utils.h

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index ecb3ccbf7c4c..ea23bb33e11d 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -23,6 +23,14 @@ target_wqe_timer_cb(struct timer_list *);
 static void
 shutdown_target_wqe_timer(struct efct_hw_s *hw);
 
+static int
+efct_hw_command_process(struct efct_hw_s *, int, u8 *, size_t);
+static int
+efct_hw_command_cancel(struct efct_hw_s *);
+static int
+efct_hw_mq_process(struct efct_hw_s *, int, struct sli4_queue_s *);
+
+
 static enum efct_hw_rtn_e
 efct_hw_link_event_init(struct efct_hw_s *hw)
 {
@@ -1296,3 +1304,442 @@ efct_get_wwn(struct efct_hw_s *hw, enum efct_hw_property_e prop)
 
 	return value;
 }
+
+/**
+ * @brief Allocate an efct_hw_rx_buffer_t array.
+ *
+ * @par Description
+ * An efct_hw_rx_buffer_t array is allocated, along with the required DMA mem.
+ *
+ * @param hw Pointer to HW object.
+ * @param rqindex RQ index for this buffer.
+ * @param count Count of buffers in array.
+ * @param size Size of buffer.
+ *
+ * @return Returns the pointer to the allocated efc_hw_rq_buffer_s array.
+ */
+static struct efc_hw_rq_buffer_s *
+efct_hw_rx_buffer_alloc(struct efct_hw_s *hw, u32 rqindex, u32 count,
+			u32 size)
+{
+	struct efct_s *efct = hw->os;
+	struct efc_hw_rq_buffer_s *rq_buf = NULL;
+	struct efc_hw_rq_buffer_s *prq;
+	u32 i;
+
+	if (count != 0) {
+		rq_buf = kmalloc_array(count, sizeof(*rq_buf), GFP_ATOMIC);
+		if (!rq_buf)
+			return NULL;
+		memset(rq_buf, 0, sizeof(*rq_buf) * count);
+
+		for (i = 0, prq = rq_buf; i < count; i ++, prq++) {
+			prq->rqindex = rqindex;
+			prq->dma.size = size;
+			prq->dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
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
+/**
+ * @brief Free an efct_hw_rx_buffer_t array.
+ *
+ * @par Description
+ * The efct_hw_rx_buffer_t array is freed, along with allocated DMA memory.
+ *
+ * @param hw Pointer to HW object.
+ * @param rq_buf Pointer to efct_hw_rx_buffer_t array.
+ * @param count Count of buffers in array.
+ *
+ * @return None.
+ */
+static void
+efct_hw_rx_buffer_free(struct efct_hw_s *hw,
+		       struct efc_hw_rq_buffer_s *rq_buf,
+			u32 count)
+{
+	struct efct_s *efct = hw->os;
+	u32 i;
+	struct efc_hw_rq_buffer_s *prq;
+
+	if (rq_buf) {
+		for (i = 0, prq = rq_buf; i < count; i++, prq++) {
+			dma_free_coherent(&efct->pcidev->dev,
+					  prq->dma.size, prq->dma.virt,
+					  prq->dma.phys);
+			memset(&prq->dma, 0, sizeof(struct efc_dma_s));
+		}
+
+		kfree(rq_buf);
+	}
+}
+
+/**
+ * @brief Allocate the RQ data buffers.
+ *
+ * @param hw Pointer to HW object.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_rx_allocate(struct efct_hw_s *hw)
+{
+	struct efct_s *efct = hw->os;
+	u32 i;
+	int rc = EFCT_HW_RTN_SUCCESS;
+	u32 rqindex = 0;
+	struct hw_rq_s *rq;
+	u32 hdr_size = EFCT_HW_RQ_SIZE_HDR;
+	u32 payload_size = hw->config.rq_default_buffer_size;
+
+	rqindex = 0;
+
+	for (i = 0; i < hw->hw_rq_count; i++) {
+		rq = hw->hw_rq[i];
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
+/**
+ * @brief Post the RQ data buffers to the chip.
+ *
+ * @param hw Pointer to HW object.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_rx_post(struct efct_hw_s *hw)
+{
+	u32 i;
+	u32 idx;
+	u32 rq_idx;
+	int rc = 0;
+
+	/*
+	 * In RQ pair mode, we MUST post the header and payload buffer at the
+	 * same time.
+	 */
+	for (rq_idx = 0, idx = 0; rq_idx < hw->hw_rq_count; rq_idx++) {
+		struct hw_rq_s *rq = hw->hw_rq[rq_idx];
+
+		for (i = 0; i < rq->entry_count - 1; i++) {
+			struct efc_hw_sequence_s *seq;
+
+			seq = efct_array_get(hw->seq_pool, idx++);
+			if (!seq) {
+				rc = -1;
+				break;
+			}
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
+	return rc;
+}
+
+/**
+ * @brief Free the RQ data buffers.
+ *
+ * @param hw Pointer to HW object.
+ *
+ */
+void
+efct_hw_rx_free(struct efct_hw_s *hw)
+{
+	struct hw_rq_s *rq;
+	u32 i;
+
+	/* Free hw_rq buffers */
+	for (i = 0; i < hw->hw_rq_count; i++) {
+		rq = hw->hw_rq[i];
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
+/**
+ * @brief Submit queued (pending) mbx commands.
+ *
+ * @par Description
+ * Submit queued mailbox commands.
+ * --- Assumes that hw->cmd_lock is held ---
+ *
+ * @param hw Hardware context.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+static int
+efct_hw_cmd_submit_pending(struct efct_hw_s *hw)
+{
+	struct efct_command_ctx_s *ctx = NULL;
+	int rc = 0;
+
+	/* Assumes lock held */
+
+	/* Only submit MQE if there's room */
+	while (hw->cmd_head_count < (EFCT_HW_MQ_DEPTH - 1) &&
+	       !list_empty(&hw->cmd_pending)) {
+		ctx = list_first_entry(&hw->cmd_pending,
+				       struct efct_command_ctx_s, list_entry);
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
+/**
+ * @ingroup io
+ * @brief Issue a SLI command.
+ *
+ * @par Description
+ * Send a mailbox command to the hardware, and either wait for a completion
+ * (EFCT_CMD_POLL) or get an optional asynchronous completion (EFCT_CMD_NOWAIT).
+ *
+ * @param hw Hardware context.
+ * @param cmd Buffer containing a formatted command and results.
+ * @param opts Command options:
+ *  - EFCT_CMD_POLL - Cmd executes synchronously &
+ *		      busy-waits for the completion.
+ *  - EFCT_CMD_NOWAIT - Cmd executes asynchronously. Uses callback.
+ * @param cb Function callback used for asynchronous mode. May be NULL.
+ * @n Prototype is <tt>(*cb)(void *arg, u8 *cmd)</tt>.
+ * @n @n @b Note: If the
+ * callback function pointer is NULL, the results of the command are silently
+ * discarded, allowing this pointer to exist solely on the stack.
+ * @param arg Argument passed to an asynchronous callback.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_command(struct efct_hw_s *hw, u8 *cmd, u32 opts, void *cb,
+		void *arg)
+{
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_ERROR;
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
+	if (opts == EFCT_CMD_POLL) {
+		spin_lock_irqsave(&hw->cmd_lock, flags);
+		bmbx = hw->sli.bmbx.virt;
+
+		memset(bmbx, 0, SLI4_BMBX_SIZE);
+		memcpy(bmbx, cmd, SLI4_BMBX_SIZE);
+
+		if (sli_bmbx_command(&hw->sli) == 0) {
+			rc = EFCT_HW_RTN_SUCCESS;
+			memcpy(cmd, bmbx, SLI4_BMBX_SIZE);
+		}
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+	} else if (opts == EFCT_CMD_NOWAIT) {
+		struct efct_command_ctx_s	*ctx = NULL;
+
+		ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
+		if (!ctx)
+			return EFCT_HW_RTN_NO_RESOURCES;
+
+		memset(ctx, 0, sizeof(struct efct_command_ctx_s));
+
+		if (hw->state != EFCT_HW_STATE_ACTIVE) {
+			efc_log_err(hw->os,
+				     "Can't send command, HW state=%d\n",
+				    hw->state);
+			kfree(ctx);
+			return EFCT_HW_RTN_ERROR;
+		}
+
+		if (cb) {
+			ctx->cb = cb;
+			ctx->arg = arg;
+		}
+		ctx->buf = cmd;
+		ctx->ctx = hw;
+
+		spin_lock_irqsave(&hw->cmd_lock, flags);
+
+			/* Add to pending list */
+			INIT_LIST_HEAD(&ctx->list_entry);
+			list_add_tail(&ctx->list_entry, &hw->cmd_pending);
+
+			/* Submit as much of the pending list as we can */
+			if (efct_hw_cmd_submit_pending(hw) == 0)
+				rc = EFCT_HW_RTN_SUCCESS;
+
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_command_process(struct efct_hw_s *hw, int status, u8 *mqe,
+			size_t size)
+{
+	struct efct_command_ctx_s *ctx = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&hw->cmd_lock, flags);
+	if (!list_empty(&hw->cmd_head)) {
+		ctx = list_first_entry(&hw->cmd_head,
+				       struct efct_command_ctx_s, list_entry);
+		list_del(&ctx->list_entry);
+	}
+	if (!ctx) {
+		efc_log_err(hw->os, "no command context?!?\n");
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+		return -1;
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
+	memset(ctx, 0, sizeof(struct efct_command_ctx_s));
+	kfree(ctx);
+
+	return 0;
+}
+
+/**
+ * @brief Process entries on the given mailbox queue.
+ *
+ * @param hw Hardware context.
+ * @param status CQE status.
+ * @param mq Pointer to the mailbox queue object.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+static int
+efct_hw_mq_process(struct efct_hw_s *hw,
+		   int status, struct sli4_queue_s *mq)
+{
+	u8		mqe[SLI4_BMBX_SIZE];
+
+	if (!sli_mq_read(&hw->sli, mq, mqe))
+		efct_hw_command_process(hw, status, mqe, mq->size);
+
+	return 0;
+}
+
+static int
+efct_hw_command_cancel(struct efct_hw_s *hw)
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
+		struct efct_command_ctx_s *ctx =
+	list_first_entry(&hw->cmd_head, struct efct_command_ctx_s, list_entry);
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
+	return 0;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 9636e6dbe259..161f9001a5c6 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -1023,4 +1023,11 @@ efct_hw_set_ptr(struct efct_hw_s *hw, enum efct_hw_property_e prop,
 extern uint64_t
 efct_get_wwn(struct efct_hw_s *hw, enum efct_hw_property_e prop);
 
+enum efct_hw_rtn_e efct_hw_rx_allocate(struct efct_hw_s *hw);
+enum efct_hw_rtn_e efct_hw_rx_post(struct efct_hw_s *hw);
+void efct_hw_rx_free(struct efct_hw_s *hw);
+extern enum efct_hw_rtn_e
+efct_hw_command(struct efct_hw_s *hw, u8 *cmd, u32 opts, void *cb,
+		void *arg);
+
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_utils.c b/drivers/scsi/elx/efct/efct_utils.c
new file mode 100644
index 000000000000..3c2deca23420
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_utils.c
@@ -0,0 +1,662 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_utils.h"
+
+#define DEFAULT_SLAB_LEN		(64 * 1024)
+
+struct pool_hdr_s {
+	struct list_head list_entry;
+};
+
+struct efct_array_s {
+	void *os;
+
+	u32 size;
+	u32 count;
+
+	u32 n_rows;
+	u32 elems_per_row;
+	u32 bytes_per_row;
+
+	void **array_rows;
+	u32 array_rows_len;
+};
+
+static u32 slab_len = DEFAULT_SLAB_LEN;
+
+/**
+ * @brief Void pointer array structure
+ *
+ * This structure describes an object consisting of an array of void
+ * pointers.   The object is allocated with a maximum array size, entries
+ * are then added to the array with while maintaining an entry count.   A set of
+ * iterator APIs are included to allow facilitate cycling through the array
+ * entries in a circular fashion.
+ *
+ */
+struct efct_varray_s {
+	void *os;
+	u32 array_count;	/*>> maximum entry count in array */
+	void **array;		/*>> pointer to allocated array memory */
+	u32 entry_count;	/*>> number of entries added to the array */
+	uint next_index;	/*>> iterator next index */
+	spinlock_t lock;	/*>> iterator lock */
+};
+
+/**
+ * @brief Set array slab allocation length
+ *
+ * The slab length is the maximum allocation length that the array uses.
+ * The default 64k slab length may be overridden using this function.
+ *
+ * @param len new slab length.
+ *
+ * @return none
+ */
+void
+efct_array_set_slablen(u32 len)
+{
+	slab_len = len;
+}
+
+/**
+ * @brief Allocate an array object
+ *
+ * An array object of size and number of elements is allocated
+ *
+ * @param os OS handle
+ * @param size size of array elements in bytes
+ * @param count number of elements in array
+ *
+ * @return pointer to array object or NULL
+ */
+struct efct_array_s *
+efct_array_alloc(void *os, u32 size, u32 count)
+{
+	struct efct_array_s *array = NULL;
+	u32 i;
+
+	/* Fail if the item size exceeds slab_len - caller should increase
+	 * slab_size, or not use this API.
+	 */
+	if (size > slab_len) {
+		pr_err("Error: size exceeds slab length\n");
+		return NULL;
+	}
+
+	array = kmalloc(sizeof(*array), GFP_KERNEL);
+	if (!array)
+		return NULL;
+
+	memset(array, 0, sizeof(*array));
+	array->os = os;
+	array->size = size;
+	array->count = count;
+	array->elems_per_row = slab_len / size;
+	array->n_rows = (count + array->elems_per_row - 1) /
+			array->elems_per_row;
+	array->bytes_per_row = array->elems_per_row * array->size;
+
+	array->array_rows_len = array->n_rows * sizeof(*array->array_rows);
+	array->array_rows = kmalloc(array->array_rows_len, GFP_ATOMIC);
+	if (!array->array_rows) {
+		efct_array_free(array);
+		return NULL;
+	}
+	memset(array->array_rows, 0, array->array_rows_len);
+	for (i = 0; i < array->n_rows; i++) {
+		array->array_rows[i] = kmalloc(array->bytes_per_row,
+					       GFP_KERNEL);
+		if (!array->array_rows[i]) {
+			efct_array_free(array);
+			return NULL;
+		}
+		memset(array->array_rows[i], 0, array->bytes_per_row);
+	}
+
+	return array;
+}
+
+/**
+ * @brief Free an array object
+ *
+ * Frees a prevously allocated array object
+ *
+ * @param array pointer to array object
+ *
+ * @return none
+ */
+void
+efct_array_free(struct efct_array_s *array)
+{
+	u32 i;
+
+	if (array) {
+		if (array->array_rows) {
+			for (i = 0; i < array->n_rows; i++)
+				kfree(array->array_rows[i]);
+
+			kfree(array->array_rows);
+		}
+		kfree(array);
+	}
+}
+
+/**
+ * @brief Return reference to an element of an array object
+ *
+ * Return the address of an array element given an index
+ *
+ * @param array pointer to array object
+ * @param idx array element index
+ *
+ * @return rointer to array element, or NULL if index out of range
+ */
+void *efct_array_get(struct efct_array_s *array, u32 idx)
+{
+	void *entry = NULL;
+
+	if (idx < array->count) {
+		u32 row = idx / array->elems_per_row;
+		u32 offset = idx % array->elems_per_row;
+
+		entry = ((u8 *)array->array_rows[row]) +
+			 (offset * array->size);
+	}
+	return entry;
+}
+
+/**
+ * @brief Return number of elements in an array
+ *
+ * Return the number of elements in an array
+ *
+ * @param array pointer to array object
+ *
+ * @return returns count of elements in an array
+ */
+u32
+efct_array_get_count(struct efct_array_s *array)
+{
+	return array->count;
+}
+
+/**
+ * @brief Return size of array elements in bytes
+ *
+ * Returns the size in bytes of each array element
+ *
+ * @param array pointer to array object
+ *
+ * @return size of array element
+ */
+u32
+efct_array_get_size(struct efct_array_s *array)
+{
+	return array->size;
+}
+
+/**
+ * @brief Allocate a void pointer array
+ *
+ * A void pointer array of given length is allocated.
+ *
+ * @param os OS handle
+ * @param array_count Array size
+ *
+ * @return returns a pointer to the efct_varray_s object, other NULL on error
+ */
+struct efct_varray_s *
+efct_varray_alloc(void *os, u32 array_count)
+{
+	struct efct_varray_s *va;
+
+	va = kmalloc(sizeof(*va), GFP_ATOMIC);
+	if (va) {
+		memset(va, 0, sizeof(*va));
+		va->os = os;
+		va->array_count = array_count;
+		va->array = kmalloc_array(va->array_count, sizeof(*va->array),
+					  GFP_KERNEL);
+		if (va->array) {
+			va->next_index = 0;
+			spin_lock_init(&va->lock);
+		} else {
+			kfree(va);
+			va = NULL;
+		}
+	}
+	return va;
+}
+
+/**
+ * @brief Free a void pointer array
+ *
+ * The void pointer array object is free'd
+ *
+ * @param va Pointer to void pointer array
+ *
+ * @return none
+ */
+void
+efct_varray_free(struct efct_varray_s *va)
+{
+	if (va) {
+		kfree(va->array);
+		kfree(va);
+	}
+}
+
+/**
+ * @brief Add an entry to a void pointer array
+ *
+ * An entry is added to the void pointer array
+ *
+ * @param va Pointer to void pointer array
+ * @param entry Pointer to entry to add
+ *
+ * @return returns 0 if entry was added, -1 if there is no more space in the
+ * array
+ */
+int
+efct_varray_add(struct efct_varray_s *va, void *entry)
+{
+	u32 rc = -1;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&va->lock, flags);
+		if (va->entry_count < va->array_count) {
+			va->array[va->entry_count++] = entry;
+			rc = 0;
+		}
+	spin_unlock_irqrestore(&va->lock, flags);
+
+	return rc;
+}
+
+/**
+ * @brief Reset the void pointer array iterator
+ *
+ * The next index value of the void pointer array iterator is cleared.
+ *
+ * @param va Pointer to void pointer array
+ *
+ * @return none
+ */
+void
+efct_varray_iter_reset(struct efct_varray_s *va)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&va->lock, flags);
+		va->next_index = 0;
+	spin_unlock_irqrestore(&va->lock, flags);
+}
+
+/**
+ * @brief Return next entry from a void pointer array
+ *
+ * The next entry in the void pointer array is returned.
+ *
+ * @param va Pointer to void point array
+ *
+ * Note: takes the void pointer array lock
+ *
+ * @return returns next void pointer entry
+ */
+void *
+efct_varray_iter_next(struct efct_varray_s *va)
+{
+	void *rval = NULL;
+	unsigned long flags = 0;
+
+	if (va) {
+		spin_lock_irqsave(&va->lock, flags);
+			rval = _efct_varray_iter_next(va);
+		spin_unlock_irqrestore(&va->lock, flags);
+	}
+	return rval;
+}
+
+/**
+ * @brief Return next entry from a void pointer array
+ *
+ * The next entry in the void pointer array is returned.
+ *
+ * @param va Pointer to void point array
+ *
+ * Note: doesn't take the void pointer array lock
+ *
+ * @return returns next void pointer entry
+ */
+void *
+_efct_varray_iter_next(struct efct_varray_s *va)
+{
+	void *rval;
+
+	rval = va->array[va->next_index];
+	if (++va->next_index >= va->entry_count)
+		va->next_index = 0;
+	return rval;
+}
+
+/**
+ * @brief Return entry count for a void pointer array
+ *
+ * The entry count for a void pointer array is returned
+ *
+ * @param va Pointer to void pointer array
+ *
+ * @return returns entry count
+ */
+u32
+efct_varray_get_count(struct efct_varray_s *va)
+{
+	u32 rc;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&va->lock, flags);
+		rc = va->entry_count;
+	spin_unlock_irqrestore(&va->lock, flags);
+	return rc;
+}
+
+/**
+ * The efct_pool_s data structure consists of:
+ *
+ *	pool->a		An efct_array_s.
+ *	pool->freelist	A linked list of free items.
+ *
+ *	When a pool is allocated using efct_pool_alloc(), the caller
+ *	provides the size in bytes of each memory pool item (size), and
+ *	a count of items (count). Since efct_pool_alloc() has no visibility
+ *	into the object the caller is allocating, a link for the linked list
+ *	is "pre-pended".  Thus when allocating the efct_array_s, the size used
+ *	is the size of the pool_hdr_s plus the requestedmemory pool item size.
+ *
+ *	array item layout:
+ *
+ *		pool_hdr_s
+ *		pool data[size]
+ *
+ *	The address of the pool data is returned when allocated (using
+ *	efct_pool_get(), or efct_pool_get_instance()), and received when being
+ *	freed (using efct_pool_put(). So the address returned by the array item
+ *	(efct_array_get()) must be offset by the size of pool_hdr_s.
+ */
+
+/**
+ * @brief Allocate a memory pool.
+ *
+ * A memory pool of given size and item count is allocated.
+ *
+ * @param os OS handle.
+ * @param size Size in bytes of item.
+ * @param count Number of items in a memory pool.
+ *
+ * @return Returns pointer to allocated memory pool, or NULL.
+ */
+struct efct_pool_s *
+efct_pool_alloc(void *os, u32 size, u32 count)
+{
+	struct efct_pool_s *pool;
+	struct pool_hdr_s *pool_entry;
+	u32 i;
+
+	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	memset(pool, 0, sizeof(*pool));
+	pool->os = os;
+
+	/* Allocate an array where each array item is the size of a pool_hdr_s
+	 * plus the requested memory item size (size)
+	 */
+	pool->a = efct_array_alloc(os, size + sizeof(struct pool_hdr_s),
+				   count);
+	if (!pool->a) {
+		efct_pool_free(pool);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&pool->freelist);
+	for (i = 0; i < count; i++) {
+		pool_entry = (struct pool_hdr_s *)efct_array_get(pool->a, i);
+		INIT_LIST_HEAD(&pool_entry->list_entry);
+		list_add_tail(&pool_entry->list_entry, &pool->freelist);
+	}
+
+	spin_lock_init(&pool->lock);
+
+	return pool;
+}
+
+/**
+ * @brief Reset a memory pool.
+ *
+ * Place all pool elements on the free list, and zero them.
+ *
+ * @param pool Pointer to the pool object.
+ *
+ * @return None.
+ */
+void
+efct_pool_reset(struct efct_pool_s *pool)
+{
+	u32 i;
+	u32 count = efct_array_get_count(pool->a);
+	u32 size = efct_array_get_size(pool->a);
+	unsigned long flags = 0;
+	struct pool_hdr_s *pool_entry;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	/*
+	 * Remove all the entries from the free list, otherwise we will
+	 * encountered linked list asserts when they are re-added.
+	 */
+	while (!list_empty(&pool->freelist)) {
+		pool_entry = list_first_entry(&pool->freelist,
+					      struct pool_hdr_s, list_entry);
+		list_del(&pool_entry->list_entry);
+	}
+
+	/* Reset the free list */
+	INIT_LIST_HEAD(&pool->freelist);
+
+	/* Return all elements to the free list and zero the elements */
+	for (i = 0; i < count; i++) {
+		pool_entry = (struct pool_hdr_s *)efct_array_get(pool->a, i);
+		memset(pool_entry, 0, size - sizeof(struct pool_hdr_s));
+		INIT_LIST_HEAD(&pool_entry->list_entry);
+		list_add_tail(&pool_entry->list_entry, &pool->freelist);
+	}
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+/**
+ * @brief Free a previously allocated memory pool.
+ *
+ * The memory pool is freed.
+ *
+ * @param pool Pointer to memory pool.
+ *
+ * @return None.
+ */
+void
+efct_pool_free(struct efct_pool_s *pool)
+{
+	if (pool) {
+		if (pool->a)
+			efct_array_free(pool->a);
+		kfree(pool);
+	}
+}
+
+/**
+ * @brief Allocate a memory pool item
+ *
+ * A memory pool item is taken from the free list and returned.
+ *
+ * @param pool Pointer to memory pool.
+ *
+ * @return Pointer to allocated item, otherwise NULL if there are
+ * no unallocated items.
+ */
+void *
+efct_pool_get(struct efct_pool_s *pool)
+{
+	struct pool_hdr_s *h = NULL;
+	void *item = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	if (!list_empty(&pool->freelist)) {
+		h = list_first_entry(&pool->freelist, struct pool_hdr_s,
+				     list_entry);
+	}
+
+	if (h) {
+		list_del(&h->list_entry);
+		/*
+		 * Return the array item address offset by the size of
+		 * pool_hdr_s
+		 */
+		item = &h[1];
+	}
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+	return item;
+}
+
+/**
+ * @brief free memory pool item
+ *
+ * A memory pool item is freed.
+ *
+ * @param pool Pointer to memory pool.
+ * @param item Pointer to item to free.
+ *
+ * @return None.
+ */
+void
+efct_pool_put(struct efct_pool_s *pool, void *item)
+{
+	struct pool_hdr_s *h;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	/* Fetch the address of the array item, which is the item address
+	 * negatively offset by size of pool_hdr_s (note the index of [-1]
+	 */
+	h = &((struct pool_hdr_s *)item)[-1];
+
+	INIT_LIST_HEAD(&h->list_entry);
+	list_add_tail(&h->list_entry, &pool->freelist);
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+/**
+ * @brief free memory pool item
+ *
+ * A memory pool item is freed to head of list.
+ *
+ * @param pool Pointer to memory pool.
+ * @param item Pointer to item to free.
+ *
+ * @return None.
+ */
+void
+efct_pool_put_head(struct efct_pool_s *pool, void *item)
+{
+	struct pool_hdr_s *h;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	/* Fetch the address of the array item, which is the item address
+	 * negatively offset by size of pool_hdr_s (note the index of [-1]
+	 */
+	h = &((struct pool_hdr_s *)item)[-1];
+
+	INIT_LIST_HEAD(&h->list_entry);
+	list_add(&h->list_entry, &pool->freelist);
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+/**
+ * @brief Return memory pool item count.
+ *
+ * Returns the allocated number of items.
+ *
+ * @param pool Pointer to memory pool.
+ *
+ * @return Returns count of allocated items.
+ */
+u32
+efct_pool_get_count(struct efct_pool_s *pool)
+{
+	u32 count;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	count = efct_array_get_count(pool->a);
+	spin_unlock_irqrestore(&pool->lock, flags);
+	return count;
+}
+
+/**
+ * @brief Return item given an index.
+ *
+ * A pointer to a memory pool item is returned given an index.
+ *
+ * @param pool Pointer to memory pool.
+ * @param idx Index.
+ *
+ * @return Returns pointer to item, or NULL if index is invalid.
+ */
+void *
+efct_pool_get_instance(struct efct_pool_s *pool, u32 idx)
+{
+	struct pool_hdr_s *h = efct_array_get(pool->a, idx);
+
+	if (!h)
+		return NULL;
+	return &h[1];
+}
+
+/**
+ * @brief Return count of free objects in a pool.
+ *
+ * The number of objects on a pool's free list.
+ *
+ * @param pool Pointer to memory pool.
+ *
+ * @return Returns count of objects on free list.
+ */
+u32
+efct_pool_get_freelist_count(struct efct_pool_s *pool)
+{
+	u32 count = 0;
+	struct pool_hdr_s *item;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	list_for_each_entry(item, &pool->freelist, list_entry) {
+		count++;
+	}
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+	return count;
+}
diff --git a/drivers/scsi/elx/efct/efct_utils.h b/drivers/scsi/elx/efct/efct_utils.h
new file mode 100644
index 000000000000..c9743ed37b9b
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_utils.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFCT_UTILS_H__
+#define __EFCT_UTILS_H__
+
+/* Sparse vector structure. */
+struct sparse_vector_s {
+	void *os;
+	u32 max_idx;		/**< maximum index value */
+	void **array;		/**< pointer to 3D array */
+};
+
+#define EFCT_LOG_ENABLE_SCSI_TRACE(efct)                \
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 2)) != 0) : 0)
+#define EFCT_LOG_ENABLE_ELS_TRACE(efct)		\
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 1)) != 0) : 0)
+#define EFCT_LOG_ENABLE_IO_ERRORS(efct)		\
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 6)) != 0) : 0)
+#define EFCT_LOG_ENABLE_LIO_IO_TRACE(efct)	\
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 7)) != 0) : 0)
+#define EFCT_LOG_ENABLE_LIO_TRACE(efct)		\
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 8)) != 0) : 0)
+
+#define SPV_ROWLEN	256
+#define SPV_DIM		3
+
+struct efct_pool_s {
+	void *os;
+	struct efct_array_s *a;
+	struct list_head freelist;
+	/* Protects freelist */
+	spinlock_t lock;
+};
+
+extern void
+efct_array_set_slablen(u32 len);
+extern struct efct_array_s *
+efct_array_alloc(void *os, u32 size, u32 count);
+extern void
+efct_array_free(struct efct_array_s *array);
+extern void *
+efct_array_get(struct efct_array_s *array, u32 idx);
+extern u32
+efct_array_get_count(struct efct_array_s *array);
+extern u32
+efct_array_get_size(struct efct_array_s *array);
+
+extern struct efct_varray_s *
+efct_varray_alloc(void *os, u32 entry_count);
+extern void
+efct_varray_free(struct efct_varray_s *ai);
+extern int
+efct_varray_add(struct efct_varray_s *ai, void *entry);
+extern void
+efct_varray_iter_reset(struct efct_varray_s *ai);
+extern void *
+efct_varray_iter_next(struct efct_varray_s *ai);
+extern void *
+_efct_varray_iter_next(struct efct_varray_s *ai);
+extern void
+efct_varray_unlock(struct efct_varray_s *ai);
+extern u32
+efct_varray_get_count(struct efct_varray_s *ai);
+
+/**
+ * @brief Sparse Vector API
+ *
+ * This is a trimmed down sparse vector implementation tuned to the problem of
+ * 24-bit FC_IDs. In this case, the 24-bit index value is broken down in three
+ * 8-bit values. These values are used to index up to three 256 element arrays.
+ * Arrays are allocated, only when needed. @n @n
+ * The lookup can complete in constant time (3 indexed array references). @n @n
+ * A typical use case would be that the fabric/directory FC_IDs would cause two
+ * rows to be allocated, and the fabric assigned remote nodes would cause two
+ * rows to be allocated, with the root row always allocated. This gives five
+ * rows of 256 x sizeof(void*), resulting in 10k.
+ */
+/*!
+ * @defgroup spv Sparse Vector
+ */
+
+void efct_spv_del(struct sparse_vector_s *spv);
+struct sparse_vector_s *efct_spv_new(void *os);
+void efct_spv_set(struct sparse_vector_s *sv, u32 idx, void *value);
+void *efct_spv_get(struct sparse_vector_s *sv, u32 idx);
+
+/**
+ * @POOL
+ *
+ */
+extern struct efct_pool_s *
+efct_pool_alloc(void *os, u32 size, u32 count);
+extern void
+efct_pool_reset(struct efct_pool_s *pool);
+extern void
+efct_pool_free(struct efct_pool_s *pool);
+extern void *
+efct_pool_get(struct efct_pool_s *pool);
+extern void
+efct_pool_put(struct efct_pool_s *pool, void *arg);
+extern void
+efct_pool_put_head(struct efct_pool_s *pool, void *arg);
+extern u32
+efct_pool_get_count(struct efct_pool_s *pool);
+extern void *
+efct_pool_get_instance(struct efct_pool_s *pool, u32 instance);
+extern u32
+efct_pool_get_freelist_count(struct efct_pool_s *pool);
+#endif /* __EFCT_UTILS_H__ */
-- 
2.13.7

