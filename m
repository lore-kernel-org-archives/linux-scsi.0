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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CB4CA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B2F5205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DOrK3zF3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436641AbfJWV44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39824 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436638AbfJWV44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id a11so7625607wra.6
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eBCoXUNNBsOs/vwsPSFmwq98aaZ8ZGOQ3Iaa+a9RxcQ=;
        b=DOrK3zF3v2Dt6w90ErlL+5DULxbfKoKtHh/QLHT2LQsUjFZlM1Xa2JOEBEeX6wR3Fx
         EFVT5Y0IEhERvGKU6UCacPk8m8exVLHGy61lHvVlYUxD4vYSJG1uwZmIjgsE0Czy160F
         63N11Hqy9ZqJ+itA/+/ovJJf0ezqVmZ8RaP5jJSM2UAtPwLfD19jsUp3xAki0+LE5gDX
         BSQ1MYLWJZl7JsukYEiny0OP9A2l7RiGEIxyiaVgYMAFhcgKSkbXiMg5DNokS6nVYFKR
         3Gkun6IFgvbmhl3VMmZ9f96LBTcuUdYGMUrgB3OrT2FrJObptls7b9N7SofjRBoIF18S
         shGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eBCoXUNNBsOs/vwsPSFmwq98aaZ8ZGOQ3Iaa+a9RxcQ=;
        b=f4vkrO8YG4j4VUCOkO4kq4NMvBNfLWj11hjQpzvkGo6ZCryb5QRib5X7rLTiTlXE3I
         UxQzCWZZDJGUHo9nSRlSrltfruXso1sjwNvWkrxPKy55vo9vXrQyE6m8VOrJYU3Kc8ah
         DkyCS/tG3ctzJy8t+Uo27Z/Q74Cz9BVmWVQWDK/SGqmYOJGhzyVW7p2/tpPEGWa0P4+O
         YOU1ZkX+cb9oUAI8p2FPb7K1TzAXtOWOUiuSFgQuxHBPr6k3YOPZlWVS1wgkGYA9rk3P
         J96YhIX7g20v5a4cP5TM1suEkQt7BUxZMfzrz/qoSZ45XbhYVZCauk9q0/AM5KU53ZBT
         Uhjw==
X-Gm-Message-State: APjAAAW9eOB03cl1yUPnHyJtxLn8+nQEjrHycD/RtqLr5l98y9IYG+Vg
        z9CvX/xXsa/O0Zu2Lz3j8OnsUkIS
X-Google-Smtp-Source: APXvYqx0TgLhG2EeQW302JxMTMTy9nuA6LnQq5WAMXP2rdQipZMapGgVtKYaIbDt5pLSqd/7P+ZUNg==
X-Received: by 2002:adf:fe81:: with SMTP id l1mr720439wrr.165.1571867813655;
        Wed, 23 Oct 2019 14:56:53 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 28/32] elx: efct: IO timeout handling routines
Date:   Wed, 23 Oct 2019 14:55:53 -0700
Message-Id: <20191023215557.12581-29-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Add support for a WQE timer to handle the wqe and IO timeouts.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 209 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 209 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 48cdbeebd058..751edbd2ddf9 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -5716,3 +5716,212 @@ efct_hw_get_num_eq(struct efct_hw_s *hw)
 {
 	return hw->eq_count;
 }
+
+/**
+ * @brief HW async call context structure.
+ */
+struct efct_hw_async_call_ctx_s {
+	efct_hw_async_cb_t callback;
+	void *arg;
+	u8 cmd[SLI4_BMBX_SIZE];
+};
+
+/**
+ * @brief HW async callback handler
+ *
+ * @par Description
+ * This function is called when the NOP mbox cmd completes.  The callback stored
+ * in the requesting context is invoked.
+ *
+ * @param hw Pointer to HW object.
+ * @param status Completion status.
+ * @param mqe Pointer to mailbox completion queue entry.
+ * @param arg Caller-provided argument.
+ *
+ * @return None.
+ */
+static void
+efct_hw_async_cb(struct efct_hw_s *hw, int status, u8 *mqe, void *arg)
+{
+	struct efct_hw_async_call_ctx_s *ctx = arg;
+
+	if (ctx) {
+		if (ctx->callback)
+			(*ctx->callback)(hw, status, mqe, ctx->arg);
+
+		kfree(ctx);
+	}
+}
+
+/**
+ * @brief Make an async callback using NOP mailbox command
+ *
+ * @par Description
+ * Post a NOP mbox cmd; the callback with argument is invoked upon completion
+ * while in the event processing context.
+ *
+ * @param hw Pointer to HW object.
+ * @param callback Pointer to callback function.
+ * @param arg Caller-provided callback.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_hw_async_call(struct efct_hw_s *hw,
+		   efct_hw_async_cb_t callback, void *arg)
+{
+	int rc = 0;
+	struct efct_hw_async_call_ctx_s *ctx;
+
+	/*
+	 * Allocate a callback context (which includes the mbox cmd buffer),
+	 * we need this to be persistent as the mbox cmd submission may be
+	 * queued and executed later execution.
+	 */
+	ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
+	if (!ctx)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->callback = callback;
+	ctx->arg = arg;
+
+	/* Build and send a NOP mailbox command */
+	if (!sli_cmd_common_nop(&hw->sli, ctx->cmd,
+			       sizeof(ctx->cmd), 0) == 0) {
+		efc_log_err(hw->os, "COMMON_NOP format failure\n");
+		kfree(ctx);
+		rc = -1;
+	}
+
+	if (efct_hw_command(hw, ctx->cmd, EFCT_CMD_NOWAIT, efct_hw_async_cb,
+			    ctx)) {
+		efc_log_err(hw->os, "COMMON_NOP command failure\n");
+		kfree(ctx);
+		rc = -1;
+	}
+	return rc;
+}
+
+static int
+target_wqe_timer_nop_cb(struct efct_hw_s *hw, int status,
+			u8 *mqe, void *arg)
+{
+	struct efct_hw_io_s *io = NULL;
+	struct efct_hw_io_s *io_next = NULL;
+	u64 ticks_current = jiffies_64;
+	u32 sec_elapsed;
+	struct sli4_mbox_command_header_s *hdr =
+				(struct sli4_mbox_command_header_s *)mqe;
+	unsigned long flags = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(hw->os, "bad status st=%x hdr=%x\n",
+			       status,
+			       le16_to_cpu(hdr->status));
+		/* go ahead and proceed with wqe timer checks... */
+	}
+
+	/* loop through active WQE list and check for timeouts */
+	spin_lock_irqsave(&hw->io_lock, flags);
+	list_for_each_entry_safe(io, io_next, &hw->io_timed_wqe, wqe_link) {
+		sec_elapsed = ((u32)(ticks_current - io->submit_ticks) / HZ);
+
+		/*
+		 * If elapsed time > timeout, abort it. No need to check type
+		 * since it wouldn't be on this list unless it was a target WQE
+		 */
+		if (sec_elapsed > io->tgt_wqe_timeout) {
+			efc_log_test(hw->os,
+				      "IO timeout xri=0x%x tag=0x%x type=%d\n",
+				     io->indicator, io->reqtag, io->type);
+
+			/*
+			 * remove from active_wqe list so won't try to abort
+			 * again
+			 */
+			list_del(&io->list_entry);
+
+			/* save status of timed_out for when abort completes */
+			io->status_saved = true;
+			io->saved_status =
+					 SLI4_FC_WCQE_STATUS_TARGET_WQE_TIMEOUT;
+			io->saved_ext = 0;
+			io->saved_len = 0;
+
+			/* now abort outstanding IO */
+			efct_hw_io_abort(hw, io, false, NULL, NULL);
+		}
+		/*
+		 * need to go through entire list since each IO could have a
+		 * different timeout value
+		 */
+	}
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+
+	/* if we're not in the middle of shutting down, schedule next timer */
+	if (!hw->active_wqe_timer_shutdown) {
+		timer_setup(&hw->wqe_timer,
+			    &target_wqe_timer_cb, 0);
+
+		mod_timer(&hw->wqe_timer,
+			  jiffies +
+			  msecs_to_jiffies(EFCT_HW_WQ_TIMER_PERIOD_MS));
+	}
+	hw->in_active_wqe_timer = false;
+	return 0;
+}
+
+static void
+target_wqe_timer_cb(struct timer_list *t)
+{
+	struct efct_hw_s *hw = from_timer(hw, t, wqe_timer);
+
+	/*
+	 * delete existing timer; will kick off new timer after checking wqe
+	 * timeouts
+	 */
+	hw->in_active_wqe_timer = true;
+	del_timer(&hw->wqe_timer);
+
+	/*
+	 * Forward timer callback to execute in the mailbox completion
+	 * processing context
+	 */
+	if (efct_hw_async_call(hw, target_wqe_timer_nop_cb, hw))
+		efc_log_test(hw->os, "efct_hw_async_call failed\n");
+}
+
+static void
+shutdown_target_wqe_timer(struct efct_hw_s *hw)
+{
+	u32	iters = 100;
+
+	if (hw->config.emulate_tgt_wqe_timeout) {
+		/*
+		 * request active wqe timer shutdown, then wait for it to
+		 * complete
+		 */
+		hw->active_wqe_timer_shutdown = true;
+
+		/*
+		 * delete WQE timer and wait for timer handler to complete
+		 * (if necessary)
+		 */
+		del_timer(&hw->wqe_timer);
+
+		/* now wait for timer handler to complete (if necessary) */
+		while (hw->in_active_wqe_timer && iters) {
+			/*
+			 * if we happen to have just sent NOP mbox cmn, make
+			 * sure completions are being processed
+			 */
+			efct_hw_flush(hw);
+			iters--;
+		}
+
+		if (iters == 0)
+			efc_log_test(hw->os,
+				      "Failed to shutdown active wqe timer\n");
+	}
+}
-- 
2.13.7

