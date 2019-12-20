Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415DEC2D0D3
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 157872146E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4svsE2H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfLTWh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:57 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45735 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbfLTWhy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:54 -0500
Received: by mail-pl1-f195.google.com with SMTP id b22so4699084pls.12
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h/02AdDZFlrOC23JmsFxQl2lkMd+4B8bSnmbLOyooGA=;
        b=G4svsE2HoYizOFHgRqvaGQfFLu0t5+GAn0nw5k7DDwytSzXVfulHqWCC+BGB0dt2w1
         l7sVXEqXI0bup1Znrh+oLmi3ADocv975Yx4Smc8GNzFQ7WBB+IAFR9SsMBrH+hPjszk2
         62/a5/Cb0NtAvyOHJWvCXD2V0Ef8bdyCJpXTeUreQ055AdKbczxX9cHsL3FKKJ7IsE6K
         dr6pgf4YWEhYEdbY5CqFUJRSPBaJ3c468VGVvjE2ZNbIAe3cZXkPi+1EY2redIgOGPMf
         KF6HcFER//WfHDSishJLyFds3Zk8+Y0kXdtbkmUhTU2qL3q1ox2eTpWUQ1B+aEErI9tN
         WD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h/02AdDZFlrOC23JmsFxQl2lkMd+4B8bSnmbLOyooGA=;
        b=Cecjz4EWwPx8n/xzI1QuzvAjnnZjlHBDaishK8exYuDlIOrEmBnp+43Y5eqMP5T0rx
         2HiMCTzK+8m62cEEszVCppz/5fcsX1SZlycsQ6DZKZ3zivMbGhSuns3kCShBAkyl6/d1
         vYh+1ZgdtlWtZ2LoxV6LZrzAgcL431nQapH7UkegIfyYItUxw7OyTV4glGxKKieqJWpn
         wVBfMn+w6yUZCY6dr+DUqv2fNOBMjnr0o2Q8sDdwHYIB1rbXzCnOICt/j9WhXxbbjZJa
         S1Xm/uixU2L1+3BUPNlPL7GvwnTjMp+EtG/TCm6zBBhd3y3Yb+0di39XRx9GP8pIO0CT
         iwJw==
X-Gm-Message-State: APjAAAUYJMv0hWODW0V4cECFrR7DFHgIYWRTQT8QDxqfc2t/6iZmUjM7
        DoijF4WuI8vY7dvN1Bv8tXatRNSs
X-Google-Smtp-Source: APXvYqx9+uXbCcU0b00XPMk1YUS6+z3um6IXyis4nFNmeP8sdF1XqDDYauaJ7aBjdMhP1b6GwoYaYw==
X-Received: by 2002:a17:90a:8001:: with SMTP id b1mr18721882pjn.39.1576881472094;
        Fri, 20 Dec 2019 14:37:52 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:51 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 18/32] elx: efct: RQ buffer, memory pool allocation and deallocation APIs
Date:   Fri, 20 Dec 2019 14:37:09 -0800
Message-Id: <20191220223723.26563-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/efct/efct_hw.c    | 355 +++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h    |   7 +
 drivers/scsi/elx/efct/efct_utils.c | 446 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_utils.h |  83 +++++++
 4 files changed, 891 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_utils.c
 create mode 100644 drivers/scsi/elx/efct/efct_utils.h

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 41e400f9d401..339e904b0276 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1220,3 +1220,358 @@ efct_get_wwn(struct efct_hw *hw, enum efct_hw_property prop)
 
 	return value;
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
+			dma_free_coherent(&efct->pcidev->dev,
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
+	struct hw_rq *rq;
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
+enum efct_hw_rtn
+efct_hw_rx_post(struct efct_hw *hw)
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
+		struct hw_rq *rq = hw->hw_rq[rq_idx];
+
+		for (i = 0; i < rq->entry_count - 1; i++) {
+			struct efc_hw_sequence *seq;
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
+void
+efct_hw_rx_free(struct efct_hw *hw)
+{
+	struct hw_rq *rq;
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
+/**
+ * Send a mailbox command to the hardware, and either wait for a completion
+ * (EFCT_CMD_POLL) or get an optional asynchronous completion (EFCT_CMD_NOWAIT).
+ */
+enum efct_hw_rtn
+efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb,
+		void *arg)
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
+		struct efct_command_ctx	*ctx = NULL;
+
+		ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
+		if (!ctx)
+			return EFCT_HW_RTN_NO_RESOURCES;
+
+		memset(ctx, 0, sizeof(struct efct_command_ctx));
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
+	memset(ctx, 0, sizeof(struct efct_command_ctx));
+	kfree(ctx);
+
+	return 0;
+}
+
+static int
+efct_hw_mq_process(struct efct_hw *hw,
+		   int status, struct sli4_queue *mq)
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
+	return 0;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index bbba73969de3..2360b64fc2c3 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -863,4 +863,11 @@ efct_hw_set_ptr(struct efct_hw *hw, enum efct_hw_property prop,
 extern uint64_t
 efct_get_wwn(struct efct_hw *hw, enum efct_hw_property prop);
 
+enum efct_hw_rtn efct_hw_rx_allocate(struct efct_hw *hw);
+enum efct_hw_rtn efct_hw_rx_post(struct efct_hw *hw);
+void efct_hw_rx_free(struct efct_hw *hw);
+extern enum efct_hw_rtn
+efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb,
+		void *arg);
+
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_utils.c b/drivers/scsi/elx/efct/efct_utils.c
new file mode 100644
index 000000000000..1d28be633a41
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_utils.c
@@ -0,0 +1,446 @@
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
+struct pool_hdr {
+	struct list_head list_entry;
+};
+
+struct efct_array {
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
+ * Void pointer array structure
+ *
+ * This structure describes an object consisting of an array of void
+ * pointers.   The object is allocated with a maximum array size, entries
+ * are then added to the array with while maintaining an entry count.   A set of
+ * iterator APIs are included to allow facilitate cycling through the array
+ * entries in a circular fashion.
+ *
+ */
+struct efct_varray {
+	void *os;
+	u32 array_count;	/* maximum entry count in array */
+	void **array;		/* pointer to allocated array memory */
+	u32 entry_count;	/* number of entries added to the array */
+	uint next_index;	/* iterator next index */
+	spinlock_t lock;	/* iterator lock */
+};
+
+void
+efct_array_set_slablen(u32 len)
+{
+	slab_len = len;
+}
+
+struct efct_array *
+efct_array_alloc(void *os, u32 size, u32 count)
+{
+	struct efct_array *array = NULL;
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
+void
+efct_array_free(struct efct_array *array)
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
+void *efct_array_get(struct efct_array *array, u32 idx)
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
+u32
+efct_array_get_count(struct efct_array *array)
+{
+	return array->count;
+}
+
+u32
+efct_array_get_size(struct efct_array *array)
+{
+	return array->size;
+}
+
+struct efct_varray *
+efct_varray_alloc(void *os, u32 array_count)
+{
+	struct efct_varray *va;
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
+void
+efct_varray_free(struct efct_varray *va)
+{
+	if (va) {
+		kfree(va->array);
+		kfree(va);
+	}
+}
+
+int
+efct_varray_add(struct efct_varray *va, void *entry)
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
+void
+efct_varray_iter_reset(struct efct_varray *va)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&va->lock, flags);
+		va->next_index = 0;
+	spin_unlock_irqrestore(&va->lock, flags);
+}
+
+void *
+efct_varray_iter_next(struct efct_varray *va)
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
+void *
+_efct_varray_iter_next(struct efct_varray *va)
+{
+	void *rval;
+
+	rval = va->array[va->next_index];
+	if (++va->next_index >= va->entry_count)
+		va->next_index = 0;
+	return rval;
+}
+
+u32
+efct_varray_get_count(struct efct_varray *va)
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
+ * The efct_pool data structure consists of:
+ *
+ *	pool->a		An efct_array_s.
+ *	pool->freelist	A linked list of free items.
+ *
+ *	When a pool is allocated using efct_pool_alloc(), the caller
+ *	provides the size in bytes of each memory pool item (size), and
+ *	a count of items (count). Since efct_pool_alloc() has no visibility
+ *	into the object the caller is allocating, a link for the linked list
+ *	is "pre-pended".  Thus when allocating the efct_array, the size used
+ *	is the size of the pool_hdr plus the requestedmemory pool item size.
+ *
+ *	array item layout:
+ *
+ *		pool_hdr
+ *		pool data[size]
+ *
+ *	The address of the pool data is returned when allocated (using
+ *	efct_pool_get(), or efct_pool_get_instance()), and received when being
+ *	freed (using efct_pool_put(). So the address returned by the array item
+ *	(efct_array_get()) must be offset by the size of pool_hdr_s.
+ */
+struct efct_pool *
+efct_pool_alloc(void *os, u32 size, u32 count)
+{
+	struct efct_pool *pool;
+	struct pool_hdr *pool_entry;
+	u32 i;
+
+	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	memset(pool, 0, sizeof(*pool));
+	pool->os = os;
+
+	/* Allocate an array where each array item is the size of a pool_hdr
+	 * plus the requested memory item size (size)
+	 */
+	pool->a = efct_array_alloc(os, size + sizeof(struct pool_hdr),
+				   count);
+	if (!pool->a) {
+		efct_pool_free(pool);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&pool->freelist);
+	for (i = 0; i < count; i++) {
+		pool_entry = (struct pool_hdr *)efct_array_get(pool->a, i);
+		INIT_LIST_HEAD(&pool_entry->list_entry);
+		list_add_tail(&pool_entry->list_entry, &pool->freelist);
+	}
+
+	spin_lock_init(&pool->lock);
+
+	return pool;
+}
+
+void
+efct_pool_reset(struct efct_pool *pool)
+{
+	u32 i;
+	u32 count = efct_array_get_count(pool->a);
+	u32 size = efct_array_get_size(pool->a);
+	unsigned long flags = 0;
+	struct pool_hdr *pool_entry;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	/*
+	 * Remove all the entries from the free list, otherwise we will
+	 * encountered linked list asserts when they are re-added.
+	 */
+	while (!list_empty(&pool->freelist)) {
+		pool_entry = list_first_entry(&pool->freelist,
+					      struct pool_hdr, list_entry);
+		list_del(&pool_entry->list_entry);
+	}
+
+	/* Reset the free list */
+	INIT_LIST_HEAD(&pool->freelist);
+
+	/* Return all elements to the free list and zero the elements */
+	for (i = 0; i < count; i++) {
+		pool_entry = (struct pool_hdr *)efct_array_get(pool->a, i);
+		memset(pool_entry, 0, size - sizeof(struct pool_hdr));
+		INIT_LIST_HEAD(&pool_entry->list_entry);
+		list_add_tail(&pool_entry->list_entry, &pool->freelist);
+	}
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+void
+efct_pool_free(struct efct_pool *pool)
+{
+	if (pool) {
+		if (pool->a)
+			efct_array_free(pool->a);
+		kfree(pool);
+	}
+}
+
+void *
+efct_pool_get(struct efct_pool *pool)
+{
+	struct pool_hdr *h = NULL;
+	void *item = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	if (!list_empty(&pool->freelist)) {
+		h = list_first_entry(&pool->freelist, struct pool_hdr,
+				     list_entry);
+	}
+
+	if (h) {
+		list_del(&h->list_entry);
+		/*
+		 * Return the array item address offset by the size of
+		 * pool_hdr
+		 */
+		item = &h[1];
+	}
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+	return item;
+}
+
+void
+efct_pool_put(struct efct_pool *pool, void *item)
+{
+	struct pool_hdr *h;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	/* Fetch the address of the array item, which is the item address
+	 * negatively offset by size of pool_hdr (note the index of [-1]
+	 */
+	h = &((struct pool_hdr *)item)[-1];
+
+	INIT_LIST_HEAD(&h->list_entry);
+	list_add_tail(&h->list_entry, &pool->freelist);
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+void
+efct_pool_put_head(struct efct_pool *pool, void *item)
+{
+	struct pool_hdr *h;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	/* Fetch the address of the array item, which is the item address
+	 * negatively offset by size of pool_hdr (note the index of [-1]
+	 */
+	h = &((struct pool_hdr *)item)[-1];
+
+	INIT_LIST_HEAD(&h->list_entry);
+	list_add(&h->list_entry, &pool->freelist);
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+u32
+efct_pool_get_count(struct efct_pool *pool)
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
+void *
+efct_pool_get_instance(struct efct_pool *pool, u32 idx)
+{
+	struct pool_hdr *h = efct_array_get(pool->a, idx);
+
+	if (!h)
+		return NULL;
+	return &h[1];
+}
+
+u32
+efct_pool_get_freelist_count(struct efct_pool *pool)
+{
+	u32 count = 0;
+	struct pool_hdr *item;
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
index 000000000000..1c24fef138f3
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_utils.h
@@ -0,0 +1,83 @@
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
+struct sparse_vector {
+	void	*os;
+	u32	max_idx;
+	void	**array;
+};
+
+#define EFCT_LOG_ENABLE_SCSI_TRACE(efct)                \
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 2)) != 0) : 0)
+#define EFCT_LOG_ENABLE_ELS_TRACE(efct)		\
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 1)) != 0) : 0)
+#define EFCT_LOG_ENABLE_IO_ERRORS(efct)		\
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 6)) != 0) : 0)
+
+#define SPV_ROWLEN	256
+#define SPV_DIM		3
+
+struct efct_pool {
+	void			*os;
+	struct efct_array	*a;
+	struct list_head	freelist;
+	/* Protects freelist */
+	spinlock_t		lock;
+};
+
+extern void
+efct_array_set_slablen(u32 len);
+extern struct efct_array *
+efct_array_alloc(void *os, u32 size, u32 count);
+extern void
+efct_array_free(struct efct_array *array);
+extern void *
+efct_array_get(struct efct_array *array, u32 idx);
+extern u32
+efct_array_get_count(struct efct_array *array);
+extern u32
+efct_array_get_size(struct efct_array *array);
+
+extern struct efct_varray *
+efct_varray_alloc(void *os, u32 entry_count);
+extern void
+efct_varray_free(struct efct_varray *ai);
+extern int
+efct_varray_add(struct efct_varray *ai, void *entry);
+extern void
+efct_varray_iter_reset(struct efct_varray *ai);
+extern void *
+efct_varray_iter_next(struct efct_varray *ai);
+extern void *
+_efct_varray_iter_next(struct efct_varray *ai);
+extern void
+efct_varray_unlock(struct efct_varray *ai);
+extern u32
+efct_varray_get_count(struct efct_varray *ai);
+
+extern struct efct_pool *
+efct_pool_alloc(void *os, u32 size, u32 count);
+extern void
+efct_pool_reset(struct efct_pool *pool);
+extern void
+efct_pool_free(struct efct_pool *pool);
+extern void *
+efct_pool_get(struct efct_pool *pool);
+extern void
+efct_pool_put(struct efct_pool *pool, void *arg);
+extern void
+efct_pool_put_head(struct efct_pool *pool, void *arg);
+extern u32
+efct_pool_get_count(struct efct_pool *pool);
+extern void *
+efct_pool_get_instance(struct efct_pool *pool, u32 instance);
+extern u32
+efct_pool_get_freelist_count(struct efct_pool *pool);
+#endif /* __EFCT_UTILS_H__ */
-- 
2.13.7

