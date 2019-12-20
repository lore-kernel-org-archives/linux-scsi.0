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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0089C2D0C8
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8FF12082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJfzedHq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfLTWiF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:38:05 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33851 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfLTWiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:38:04 -0500
Received: by mail-pl1-f194.google.com with SMTP id x17so4718999pln.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F7ksXRnA4VdsyjVnG+I4Kxm0tAdhyKWzPk2ZG7M18TE=;
        b=VJfzedHqyPhUvnVcZdtBIk5sgJ1yUKHgsR+C/RT3hDaW8gyZ8ZSM0ERRXY6xsx1buZ
         /6S3mmyoyy6kRulKqCeKx2fk2axzUn50ykH3eFr7+lB1rVwNDHF7+Abt2KatQcOIXRUI
         ypocg5svMpoZov9J3HSlNDM+y0xejRyCDKv+W7r8ib+AS0BqmJJwSZEh4/dbIIIC41Mf
         L4nYTEmz2n+ZjMsGF84nd/U8ntpqRgwRcMCe5Aj26GrQWxOeUhfQ+2yDqquoPs82sRTL
         k6lIYEfOiWyzMynBDloz1WhogpFLZVSCBOo0Wwuv0qEpHMSztzuomnh11jUdXPtcEqzE
         Ws2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F7ksXRnA4VdsyjVnG+I4Kxm0tAdhyKWzPk2ZG7M18TE=;
        b=QOehZGHhtplePI5vRGIVVDWoxVk/+DnmrLzFQ7k87lbq2wUUG40CAExpTlzrzz7BM4
         DzV+DqgAjhIEMHqEep7CBZjumit9L29/OFPeKn4Fh8bHbY7o8E4dSipFCbZ/ewm8PQYP
         KWorf+5leYl2bGL5GYb7Nb7XC/kT+OgoT5Yb0VZcEGXR1UVGspntVX06LAgqzmHBfO8h
         2peIBM0An8l516jbmZqFYksoFImy/6++wdbOjJIzJZpy1947LPHFAk7S3WvNQ9alKxS9
         r39DocwfOMGrkCE7kYrDIv4/1GBIHOeShi4rmEhjlDh1WISjpvd5uLz+pSfgVmH5WX7n
         oMBw==
X-Gm-Message-State: APjAAAUAdoX1wEjMdwXvmJff8dNT881OEPsCVsMAWDKHeCm7OU7Zuo0a
        Jah4OJcMiNNuTUm08vPmK8gUpbkX
X-Google-Smtp-Source: APXvYqxuE9CK5bLw/biZ1eq+d4YonPHVcC1pHoyNP1c2O4Py+e3QgGp3LdUvWFYwVE2oZ9BkUbj4mg==
X-Received: by 2002:a17:902:8202:: with SMTP id x2mr17012940pln.314.1576881483579;
        Fri, 20 Dec 2019 14:38:03 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.38.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:38:03 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 28/32] elx: efct: IO timeout handling routines
Date:   Fri, 20 Dec 2019 14:37:19 -0800
Message-Id: <20191220223723.26563-29-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/efct/efct_hw.c | 187 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index fb33317caa0d..c18bda1351cc 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -276,6 +276,98 @@ efct_logfcfi(struct efct_hw *hw, u32 j, u32 i, u32 id)
 		     j, hw->config.filter_def[j], i, id);
 }
 
+static void
+target_wqe_timer_cb(struct timer_list *t);
+
+static int
+target_wqe_timer_nop_cb(struct efct_hw *hw, int status,
+			u8 *mqe, void *arg)
+{
+	struct efct_hw_io *io = NULL;
+	struct efct_hw_io *io_next = NULL;
+	u64 ticks_current = jiffies_64;
+	u32 sec_elapsed;
+	struct sli4_mbox_command_header *hdr =
+				(struct sli4_mbox_command_header *)mqe;
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
+	struct efct_hw *hw = from_timer(hw, t, wqe_timer);
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
 static inline void
 efct_hw_init_free_io(struct efct_hw_io *io)
 {
@@ -4572,6 +4664,40 @@ efct_hw_port_control(struct efct_hw *hw, enum efct_hw_port ctrl,
 	return rc;
 }
 
+static void
+shutdown_target_wqe_timer(struct efct_hw *hw)
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
+
 enum efct_hw_rtn
 efct_hw_teardown(struct efct_hw *hw)
 {
@@ -4920,3 +5046,64 @@ efct_hw_get_num_eq(struct efct_hw *hw)
 {
 	return hw->eq_count;
 }
+
+/* HW async call context structure */
+struct efct_hw_async_call_ctx {
+	efct_hw_async_cb_t callback;
+	void *arg;
+	u8 cmd[SLI4_BMBX_SIZE];
+};
+
+static void
+efct_hw_async_cb(struct efct_hw *hw, int status, u8 *mqe, void *arg)
+{
+	struct efct_hw_async_call_ctx *ctx = arg;
+
+	if (ctx) {
+		if (ctx->callback)
+			(*ctx->callback)(hw, status, mqe, ctx->arg);
+
+		kfree(ctx);
+	}
+}
+
+/*
+ * Post a NOP mbox cmd; the callback with argument is invoked upon completion
+ * while in the event processing context.
+ */
+int
+efct_hw_async_call(struct efct_hw *hw,
+		   efct_hw_async_cb_t callback, void *arg)
+{
+	int rc = 0;
+	struct efct_hw_async_call_ctx *ctx;
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
-- 
2.13.7

