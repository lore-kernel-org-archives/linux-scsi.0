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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0027C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2ECA235FF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbhAGXBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbhAGXBO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 18:01:14 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E113C0612AC
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2021 14:59:36 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 11so4994292pfu.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 14:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjxV6JB+4YwDi3u/iYx+LgOmM81MO6obRrCU6zOXe4w=;
        b=bT9SV484V7aWviM9FSv+0igx9RnlRPfm6zLYF/+ph0Hl9pQUfo32XN39ZMcark3+wA
         wzo7oPWgsvILL/OcYH4bCh2dn2xwQlXQK4Fl4dJtZ2J2QtBxS+2jcHN2dd0lFpLtxpEy
         cjMMFv6mE/YciCQKmvyn4R33UoG4Ltl/yKKTFsKge5NUxb10cLNRsdNcAxgPn8bwyueu
         O5BCTZAi5UY38tHKp432o2+w3+gg082XqGOfJ1y7dmZ9cNCerz8YBCkzX003LGXGUWx1
         0MNwkvKc+ELi45tW/oVfNq0z2zLjQtEK7CZA5N2PjhwnfeHzh6CeZT9ruKzd6k34zEEG
         ydGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjxV6JB+4YwDi3u/iYx+LgOmM81MO6obRrCU6zOXe4w=;
        b=nn85SvO9tjGLB+YvU/JyMRicHBnGCgK0AGHyH3eyycYMNu5IEESP75faq8DQUCO7RV
         K4SCJLpQnEIq3XUQQMuC/feHBX7nxa+dbiuRhKKysfUOPIX/1/B2978Hr3aaCWWeDdN6
         hnQWbKMm6EosGl0tKmZA7PSQTtgJrlWltJGyKWgdzFd1wU18YewckFklov0vmrnhTH1Y
         +WHAVPfm9xZhucTct8sF0vPIb6j9co+VQNxylY8QTizG2ikSkiadytB19RXHJxacawSb
         cZU8LQj8tVHISDbkKfFTjwm8Jc1dyG8dSlrYQibTDgZhIqZgDy2nffTEGPZwTk4QpbKM
         vymQ==
X-Gm-Message-State: AOAM531n2KWCThD/4lHuVsGjGwpTT9BLT5qIUrDmgOOzN67u0ex+zOdB
        XKEOXr+ChTJU4piWsw5hXfu40OLqUaiDKw==
X-Google-Smtp-Source: ABdhPJyS1dGunBYGjjIabdUtZvmjuiuZfyBBAEwk5Yxy03MqUT6G0MWmOCQ093JOI4D7qqKlIBldsQ==
X-Received: by 2002:aa7:8506:0:b029:19e:95:f75f with SMTP id v6-20020aa785060000b029019e0095f75fmr807750pfn.7.1610060375165;
        Thu, 07 Jan 2021 14:59:35 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l197sm6881405pfd.97.2021.01.07.14.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:59:34 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v7 24/31] elx: efct: SCSI IO handling routines
Date:   Thu,  7 Jan 2021 14:58:58 -0800
Message-Id: <20210107225905.18186-25-jsmart2021@gmail.com>
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
Routines for SCSI transport IO alloc, build and send IO.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/elx/efct/efct_scsi.c | 1164 +++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_scsi.h |  207 +++++
 2 files changed, 1371 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.c
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.h

diff --git a/drivers/scsi/elx/efct/efct_scsi.c b/drivers/scsi/elx/efct/efct_scsi.c
new file mode 100644
index 000000000000..20aed62a1bff
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_scsi.c
@@ -0,0 +1,1164 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_hw.h"
+
+#define enable_tsend_auto_resp(efct)	1
+#define enable_treceive_auto_resp(efct)	0
+
+#define SCSI_IOFMT "[%04x][i:%04x t:%04x h:%04x]"
+
+#define scsi_io_printf(io, fmt, ...) \
+	efc_log_debug(io->efct, "[%s]" SCSI_IOFMT fmt, \
+		io->node->display_name, io->instance_index,\
+		io->init_task_tag, io->tgt_task_tag, io->hw_tag, ##__VA_ARGS__)
+
+#define EFCT_LOG_ENABLE_SCSI_TRACE(efct)                \
+		(((efct) != NULL) ? (((efct)->logmask & (1U << 2)) != 0) : 0)
+
+#define scsi_io_trace(io, fmt, ...) \
+	do { \
+		if (EFCT_LOG_ENABLE_SCSI_TRACE(io->efct)) \
+			scsi_io_printf(io, fmt, ##__VA_ARGS__); \
+	} while (0)
+
+struct efct_io *
+efct_scsi_io_alloc(struct efct_node *node)
+{
+	struct efct *efct;
+	struct efct_xport *xport;
+	struct efct_io *io;
+	unsigned long flags = 0;
+
+	efct = node->efct;
+
+	xport = efct->xport;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+
+	io = efct_io_pool_io_alloc(efct->xport->io_pool);
+	if (!io) {
+		efc_log_err(efct, "IO alloc Failed\n");
+		atomic_add_return(1, &xport->io_alloc_failed_count);
+		spin_unlock_irqrestore(&node->active_ios_lock, flags);
+		return NULL;
+	}
+
+	/* initialize refcount */
+	kref_init(&io->ref);
+	io->release = _efct_scsi_io_free;
+
+	/* set generic fields */
+	io->efct = efct;
+	io->node = node;
+	kref_get(&node->ref);
+
+	/* set type and name */
+	io->io_type = EFCT_IO_TYPE_IO;
+	io->display_name = "scsi_io";
+
+	io->cmd_ini = false;
+	io->cmd_tgt = true;
+
+	/* Add to node's active_ios list */
+	INIT_LIST_HEAD(&io->list_entry);
+	list_add(&io->list_entry, &node->active_ios);
+
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+
+	return io;
+}
+
+void
+_efct_scsi_io_free(struct kref *arg)
+{
+	struct efct_io *io = container_of(arg, struct efct_io, ref);
+	struct efct *efct = io->efct;
+	struct efct_node *node = io->node;
+	unsigned long flags = 0;
+
+	scsi_io_trace(io, "freeing io 0x%p %s\n", io, io->display_name);
+
+	if (io->io_free) {
+		efc_log_err(efct, "IO already freed.\n");
+		return;
+	}
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	list_del_init(&io->list_entry);
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+
+	kref_put(&node->ref, node->release);
+	io->node = NULL;
+	efct_io_pool_io_free(efct->xport->io_pool, io);
+}
+
+void
+efct_scsi_io_free(struct efct_io *io)
+{
+	scsi_io_trace(io, "freeing io 0x%p %s\n", io, io->display_name);
+	WARN_ON(!refcount_read(&io->ref.refcount));
+	kref_put(&io->ref, io->release);
+}
+
+static void
+efct_target_io_cb(struct efct_hw_io *hio, u32 length, int status,
+		  u32 ext_status, void *app)
+{
+	u32 flags = 0;
+	struct efct_io *io = app;
+	struct efct *efct;
+	enum efct_scsi_io_status scsi_stat = EFCT_SCSI_STATUS_GOOD;
+	efct_scsi_io_cb_t cb;
+
+	if (!io || !io->efct) {
+		pr_err("%s: IO can not be NULL\n", __func__);
+		return;
+	}
+
+	scsi_io_trace(io, "status x%x ext_status x%x\n", status, ext_status);
+
+	efct = io->efct;
+
+	io->transferred += length;
+
+	if (!io->scsi_tgt_cb) {
+		efct_scsi_check_pending(efct);
+		return;
+	}
+
+	/* Call target server completion */
+	cb = io->scsi_tgt_cb;
+
+	/* Clear the callback before invoking the callback */
+	io->scsi_tgt_cb = NULL;
+
+	/* if status was good, and auto-good-response was set,
+	 * then callback target-server with IO_CMPL_RSP_SENT,
+	 * otherwise send IO_CMPL
+	 */
+	if (status == 0 && io->auto_resp)
+		flags |= EFCT_SCSI_IO_CMPL_RSP_SENT;
+	else
+		flags |= EFCT_SCSI_IO_CMPL;
+
+	switch (status) {
+	case SLI4_FC_WCQE_STATUS_SUCCESS:
+		scsi_stat = EFCT_SCSI_STATUS_GOOD;
+		break;
+	case SLI4_FC_WCQE_STATUS_DI_ERROR:
+		if (ext_status & SLI4_FC_DI_ERROR_GE)
+			scsi_stat = EFCT_SCSI_STATUS_DIF_GUARD_ERR;
+		else if (ext_status & SLI4_FC_DI_ERROR_AE)
+			scsi_stat = EFCT_SCSI_STATUS_DIF_APP_TAG_ERROR;
+		else if (ext_status & SLI4_FC_DI_ERROR_RE)
+			scsi_stat = EFCT_SCSI_STATUS_DIF_REF_TAG_ERROR;
+		else
+			scsi_stat = EFCT_SCSI_STATUS_DIF_UNKNOWN_ERROR;
+		break;
+	case SLI4_FC_WCQE_STATUS_LOCAL_REJECT:
+		switch (ext_status) {
+		case SLI4_FC_LOCAL_REJECT_INVALID_RELOFFSET:
+		case SLI4_FC_LOCAL_REJECT_ABORT_REQUESTED:
+			scsi_stat = EFCT_SCSI_STATUS_ABORTED;
+			break;
+		case SLI4_FC_LOCAL_REJECT_INVALID_RPI:
+			scsi_stat = EFCT_SCSI_STATUS_NEXUS_LOST;
+			break;
+		case SLI4_FC_LOCAL_REJECT_NO_XRI:
+			scsi_stat = EFCT_SCSI_STATUS_NO_IO;
+			break;
+		default:
+			/*we have seen 0x0d(TX_DMA_FAILED err)*/
+			scsi_stat = EFCT_SCSI_STATUS_ERROR;
+			break;
+		}
+		break;
+
+	case SLI4_FC_WCQE_STATUS_TARGET_WQE_TIMEOUT:
+		/* target IO timed out */
+		scsi_stat = EFCT_SCSI_STATUS_TIMEDOUT_AND_ABORTED;
+		break;
+
+	case SLI4_FC_WCQE_STATUS_SHUTDOWN:
+		/* Target IO cancelled by HW */
+		scsi_stat = EFCT_SCSI_STATUS_SHUTDOWN;
+		break;
+
+	default:
+		scsi_stat = EFCT_SCSI_STATUS_ERROR;
+		break;
+	}
+
+	cb(io, scsi_stat, flags, io->scsi_tgt_cb_arg);
+
+	efct_scsi_check_pending(efct);
+}
+
+static int
+efct_scsi_build_sgls(struct efct_hw *hw, struct efct_hw_io *hio,
+		struct efct_scsi_sgl *sgl, u32 sgl_count,
+		enum efct_hw_io_type type)
+{
+	int rc;
+	u32 i;
+	struct efct *efct = hw->os;
+
+	/* Initialize HW SGL */
+	rc = efct_hw_io_init_sges(hw, hio, type);
+	if (rc) {
+		efc_log_err(efct, "efct_hw_io_init_sges failed: %d\n", rc);
+		return EFC_FAIL;
+	}
+
+	for (i = 0; i < sgl_count; i++) {
+
+		/* Add data SGE */
+		rc = efct_hw_io_add_sge(hw, hio, sgl[i].addr, sgl[i].len);
+		if (rc) {
+			efc_log_err(efct,
+					"add sge failed cnt=%d rc=%d\n",
+					sgl_count, rc);
+			return rc;
+		}
+	}
+
+	return EFC_SUCCESS;
+}
+
+static void efc_log_sgl(struct efct_io *io)
+{
+	struct efct_hw_io *hio = io->hio;
+	struct sli4_sge *data = NULL;
+	u32 *dword = NULL;
+	u32 i;
+	u32 n_sge;
+
+	scsi_io_trace(io, "def_sgl at 0x%x 0x%08x\n",
+			upper_32_bits(hio->def_sgl.phys),
+			lower_32_bits(hio->def_sgl.phys));
+	n_sge = (hio->sgl == &hio->def_sgl) ? hio->n_sge : hio->def_sgl_count;
+	for (i = 0, data = hio->def_sgl.virt; i < n_sge; i++, data++) {
+		dword = (u32 *)data;
+
+		scsi_io_trace(io, "SGL %2d 0x%08x 0x%08x 0x%08x 0x%08x\n",
+			      i, dword[0], dword[1], dword[2], dword[3]);
+
+		if (dword[2] & (1U << 31))
+			break;
+	}
+
+}
+
+static void
+efct_scsi_check_pending_async_cb(struct efct_hw *hw, int status,
+				 u8 *mqe, void *arg)
+{
+	struct efct_io *io = arg;
+
+	if (io) {
+		efct_hw_done_t cb = io->hw_cb;
+
+		if (!io->hw_cb)
+			return;
+
+		io->hw_cb = NULL;
+		(cb)(io->hio, 0, SLI4_FC_WCQE_STATUS_DISPATCH_ERROR, 0, io);
+	}
+}
+
+static int
+efct_scsi_io_dispatch_hw_io(struct efct_io *io, struct efct_hw_io *hio)
+{
+	int rc = EFC_SUCCESS;
+	struct efct *efct = io->efct;
+
+	/* Got a HW IO;
+	 * update ini/tgt_task_tag with HW IO info and dispatch
+	 */
+	io->hio = hio;
+	if (io->cmd_tgt)
+		io->tgt_task_tag = hio->indicator;
+	else if (io->cmd_ini)
+		io->init_task_tag = hio->indicator;
+	io->hw_tag = hio->reqtag;
+
+	hio->eq = io->hw_priv;
+
+	/* Copy WQ steering */
+	switch (io->wq_steering) {
+	case EFCT_SCSI_WQ_STEERING_CLASS >> EFCT_SCSI_WQ_STEERING_SHIFT:
+		hio->wq_steering = EFCT_HW_WQ_STEERING_CLASS;
+		break;
+	case EFCT_SCSI_WQ_STEERING_REQUEST >> EFCT_SCSI_WQ_STEERING_SHIFT:
+		hio->wq_steering = EFCT_HW_WQ_STEERING_REQUEST;
+		break;
+	case EFCT_SCSI_WQ_STEERING_CPU >> EFCT_SCSI_WQ_STEERING_SHIFT:
+		hio->wq_steering = EFCT_HW_WQ_STEERING_CPU;
+		break;
+	}
+
+	switch (io->io_type) {
+	case EFCT_IO_TYPE_IO:
+		rc = efct_scsi_build_sgls(&efct->hw, io->hio,
+					  io->sgl, io->sgl_count, io->hio_type);
+		if (rc)
+			break;
+
+		if (EFCT_LOG_ENABLE_SCSI_TRACE(efct))
+			efc_log_sgl(io);
+
+		if (io->app_id)
+			io->iparam.fcp_tgt.app_id = io->app_id;
+
+		io->iparam.fcp_tgt.vpi = io->node->vpi;
+		io->iparam.fcp_tgt.rpi = io->node->rpi;
+		io->iparam.fcp_tgt.s_id = io->node->port_fc_id;
+		io->iparam.fcp_tgt.d_id = io->node->node_fc_id;
+		io->iparam.fcp_tgt.xmit_len = io->wire_len;
+
+		rc = efct_hw_io_send(&io->efct->hw, io->hio_type, io->hio,
+				     &io->iparam, io->hw_cb, io);
+		break;
+	default:
+		scsi_io_printf(io, "Unknown IO type=%d\n", io->io_type);
+		rc = EFC_FAIL;
+		break;
+	}
+	return rc;
+}
+
+static int
+efct_scsi_io_dispatch_no_hw_io(struct efct_io *io)
+{
+	int rc;
+
+	switch (io->io_type) {
+	case EFCT_IO_TYPE_ABORT: {
+		struct efct_hw_io *hio_to_abort = NULL;
+
+		hio_to_abort = io->io_to_abort->hio;
+
+		if (!hio_to_abort) {
+			/*
+			 * If "IO to abort" does not have an
+			 * associated HW IO, immediately make callback with
+			 * success. The command must have been sent to
+			 * the backend, but the data phase has not yet
+			 * started, so we don't have a HW IO.
+			 *
+			 * Note: since the backend shims should be
+			 * taking a reference on io_to_abort, it should not
+			 * be possible to have been completed and freed by
+			 * the backend before the abort got here.
+			 */
+			scsi_io_printf(io, "IO: not active\n");
+			((efct_hw_done_t)io->hw_cb)(io->hio, 0,
+					SLI4_FC_WCQE_STATUS_SUCCESS, 0, io);
+			rc = EFC_SUCCESS;
+			break;
+		}
+
+		/* HW IO is valid, abort it */
+		scsi_io_printf(io, "aborting\n");
+		rc = efct_hw_io_abort(&io->efct->hw, hio_to_abort,
+					      io->send_abts, io->hw_cb, io);
+		if (rc) {
+			int status = SLI4_FC_WCQE_STATUS_SUCCESS;
+			efct_hw_done_t cb = io->hw_cb;
+
+
+			if (rc != EFCT_HW_RTN_IO_NOT_ACTIVE &&
+			    rc != EFCT_HW_RTN_IO_ABORT_IN_PROGRESS) {
+				status = -1;
+				scsi_io_printf(io,
+					"Failed to abort IO rc=%d\n", rc);
+			}
+			cb(io->hio, 0, status, 0, io);
+			rc = EFC_SUCCESS;
+		}
+
+		break;
+	}
+	default:
+		scsi_io_printf(io, "Unknown IO type=%d\n", io->io_type);
+		rc = EFC_FAIL;
+		break;
+	}
+	return rc;
+}
+
+static struct efct_io *
+efct_scsi_dispatch_pending(struct efct *efct)
+{
+	struct efct_xport *xport = efct->xport;
+	struct efct_io *io = NULL;
+	struct efct_hw_io *hio;
+	unsigned long flags = 0;
+	int status;
+
+	spin_lock_irqsave(&xport->io_pending_lock, flags);
+
+	if (!list_empty(&xport->io_pending_list)) {
+		io = list_first_entry(&xport->io_pending_list, struct efct_io,
+					io_pending_link);
+		list_del_init(&io->io_pending_link);
+	}
+
+	if (!io) {
+		spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+		return NULL;
+	}
+
+	if (io->io_type == EFCT_IO_TYPE_ABORT) {
+		hio = NULL;
+	} else {
+		hio = efct_hw_io_alloc(&efct->hw);
+		if (!hio) {
+			/*
+			 * No HW IO available.Put IO back on
+			 * the front of pending list
+			 */
+			list_add(&xport->io_pending_list, &io->io_pending_link);
+			io = NULL;
+		} else {
+			hio->eq = io->hw_priv;
+		}
+	}
+
+	/* Must drop the lock before dispatching the IO */
+	spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+
+	if (!io)
+		return NULL;
+
+	/*
+	 * We pulled an IO off the pending list,
+	 * and either got an HW IO or don't need one
+	 */
+	atomic_sub_return(1, &xport->io_pending_count);
+	if (!hio)
+		status = efct_scsi_io_dispatch_no_hw_io(io);
+	else
+		status = efct_scsi_io_dispatch_hw_io(io, hio);
+	if (status) {
+		/*
+		 * Invoke the HW callback, but do so in the
+		 * separate execution context,provided by the
+		 * NOP mailbox completion processing context
+		 * by using efct_hw_async_call()
+		 */
+		if (efct_hw_async_call(&efct->hw,
+				efct_scsi_check_pending_async_cb, io)) {
+			efc_log_debug(efct, "call hw async failed\n");
+		}
+	}
+
+	return io;
+}
+
+void
+efct_scsi_check_pending(struct efct *efct)
+{
+	struct efct_xport *xport = efct->xport;
+	struct efct_io *io = NULL;
+	int count = 0;
+	unsigned long flags = 0;
+	int dispatch = 0;
+
+	/* Guard against recursion */
+	if (atomic_add_return(1, &xport->io_pending_recursing)) {
+		/* This function is already running.  Decrement and return. */
+		atomic_sub_return(1, &xport->io_pending_recursing);
+		return;
+	}
+
+	while (efct_scsi_dispatch_pending(efct))
+		count++;
+
+	if (count) {
+		atomic_sub_return(1, &xport->io_pending_recursing);
+		return;
+	}
+
+	/*
+	 * If nothing was removed from the list,
+	 * we might be in a case where we need to abort an
+	 * active IO and the abort is on the pending list.
+	 * Look for an abort we can dispatch.
+	 */
+
+	spin_lock_irqsave(&xport->io_pending_lock, flags);
+
+	list_for_each_entry(io, &xport->io_pending_list, io_pending_link) {
+		if (io->io_type == EFCT_IO_TYPE_ABORT && io->io_to_abort->hio) {
+			/* This IO has a HW IO, so it is
+			 * active.  Dispatch the abort.
+			 */
+			dispatch = 1;
+			list_del_init(&io->io_pending_link);
+			atomic_sub_return(1, &xport->io_pending_count);
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+
+	if (dispatch) {
+		if (efct_scsi_io_dispatch_no_hw_io(io)) {
+			if (efct_hw_async_call(&efct->hw,
+				efct_scsi_check_pending_async_cb, io)) {
+				efc_log_debug(efct, "hw async failed\n");
+			}
+		}
+	}
+
+	atomic_sub_return(1, &xport->io_pending_recursing);
+}
+
+int
+efct_scsi_io_dispatch(struct efct_io *io, void *cb)
+{
+	struct efct_hw_io *hio;
+	struct efct *efct = io->efct;
+	struct efct_xport *xport = efct->xport;
+	unsigned long flags = 0;
+
+	io->hw_cb = cb;
+
+	/*
+	 * if this IO already has a HW IO, then this is either
+	 * not the first phase of the IO. Send it to the HW.
+	 */
+	if (io->hio)
+		return efct_scsi_io_dispatch_hw_io(io, io->hio);
+
+	/*
+	 * We don't already have a HW IO associated with the IO. First check
+	 * the pending list. If not empty, add IO to the tail and process the
+	 * pending list.
+	 */
+	spin_lock_irqsave(&xport->io_pending_lock, flags);
+	if (!list_empty(&xport->io_pending_list)) {
+		/*
+		 * If this is a low latency request,
+		 * the put at the front of the IO pending
+		 * queue, otherwise put it at the end of the queue.
+		 */
+		if (io->low_latency) {
+			INIT_LIST_HEAD(&io->io_pending_link);
+			list_add(&xport->io_pending_list, &io->io_pending_link);
+		} else {
+			INIT_LIST_HEAD(&io->io_pending_link);
+			list_add_tail(&io->io_pending_link,
+					&xport->io_pending_list);
+		}
+		spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+		atomic_add_return(1, &xport->io_pending_count);
+		atomic_add_return(1, &xport->io_total_pending);
+
+		/* process pending list */
+		efct_scsi_check_pending(efct);
+		return EFC_SUCCESS;
+	}
+	spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+
+	/*
+	 * We don't have a HW IO associated with the IO and there's nothing
+	 * on the pending list. Attempt to allocate a HW IO and dispatch it.
+	 */
+	hio = efct_hw_io_alloc(&io->efct->hw);
+	if (!hio) {
+		/* Couldn't get a HW IO. Save this IO on the pending list */
+		spin_lock_irqsave(&xport->io_pending_lock, flags);
+		INIT_LIST_HEAD(&io->io_pending_link);
+		list_add_tail(&io->io_pending_link, &xport->io_pending_list);
+		spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+
+		atomic_add_return(1, &xport->io_total_pending);
+		atomic_add_return(1, &xport->io_pending_count);
+		return EFC_SUCCESS;
+	}
+
+	/* We successfully allocated a HW IO; dispatch to HW */
+	return efct_scsi_io_dispatch_hw_io(io, hio);
+}
+
+int
+efct_scsi_io_dispatch_abort(struct efct_io *io, void *cb)
+{
+	struct efct *efct = io->efct;
+	struct efct_xport *xport = efct->xport;
+	unsigned long flags = 0;
+
+	io->hw_cb = cb;
+
+	/*
+	 * For aborts, we don't need a HW IO, but we still want
+	 * to pass through the pending list to preserve ordering.
+	 * Thus, if the pending list is not empty, add this abort
+	 * to the pending list and process the pending list.
+	 */
+	spin_lock_irqsave(&xport->io_pending_lock, flags);
+	if (!list_empty(&xport->io_pending_list)) {
+		INIT_LIST_HEAD(&io->io_pending_link);
+		list_add_tail(&io->io_pending_link, &xport->io_pending_list);
+		spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+		atomic_add_return(1, &xport->io_pending_count);
+		atomic_add_return(1, &xport->io_total_pending);
+
+		/* process pending list */
+		efct_scsi_check_pending(efct);
+		return EFC_SUCCESS;
+	}
+	spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+
+	/* nothing on pending list, dispatch abort */
+	return efct_scsi_io_dispatch_no_hw_io(io);
+}
+
+static inline int
+efct_scsi_xfer_data(struct efct_io *io, u32 flags,
+	struct efct_scsi_sgl *sgl, u32 sgl_count, u64 xwire_len,
+	enum efct_hw_io_type type, int enable_ar,
+	efct_scsi_io_cb_t cb, void *arg)
+{
+	struct efct *efct;
+	size_t residual = 0;
+
+	io->sgl_count = sgl_count;
+
+	efct = io->efct;
+
+	scsi_io_trace(io, "%s wire_len %llu\n",
+		      (type == EFCT_HW_IO_TARGET_READ) ? "send" : "recv",
+		      xwire_len);
+
+	io->hio_type = type;
+
+	io->scsi_tgt_cb = cb;
+	io->scsi_tgt_cb_arg = arg;
+
+	residual = io->exp_xfer_len - io->transferred;
+	io->wire_len = (xwire_len < residual) ? xwire_len : residual;
+	residual = (xwire_len - io->wire_len);
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.fcp_tgt.ox_id = io->init_task_tag;
+	io->iparam.fcp_tgt.offset = io->transferred;
+	io->iparam.fcp_tgt.cs_ctl = io->cs_ctl;
+	io->iparam.fcp_tgt.timeout = io->timeout;
+
+	/* if this is the last data phase and there is no residual, enable
+	 * auto-good-response
+	 */
+	if (enable_ar && (flags & EFCT_SCSI_LAST_DATAPHASE) && residual == 0 &&
+		((io->transferred + io->wire_len) == io->exp_xfer_len) &&
+		(!(flags & EFCT_SCSI_NO_AUTO_RESPONSE))) {
+		io->iparam.fcp_tgt.flags |= SLI4_IO_AUTO_GOOD_RESPONSE;
+		io->auto_resp = true;
+	} else {
+		io->auto_resp = false;
+	}
+
+	/* save this transfer length */
+	io->xfer_req = io->wire_len;
+
+	/* Adjust the transferred count to account for overrun
+	 * when the residual is calculated in efct_scsi_send_resp
+	 */
+	io->transferred += residual;
+
+	/* Adjust the SGL size if there is overrun */
+
+	if (residual) {
+		struct efct_scsi_sgl  *sgl_ptr = &io->sgl[sgl_count - 1];
+
+		while (residual) {
+			size_t len = sgl_ptr->len;
+
+			if (len > residual) {
+				sgl_ptr->len = len - residual;
+				residual = 0;
+			} else {
+				sgl_ptr->len = 0;
+				residual -= len;
+				io->sgl_count--;
+			}
+			sgl_ptr--;
+		}
+	}
+
+	/* Set latency and WQ steering */
+	io->low_latency = (flags & EFCT_SCSI_LOW_LATENCY) != 0;
+	io->wq_steering = (flags & EFCT_SCSI_WQ_STEERING_MASK) >>
+				EFCT_SCSI_WQ_STEERING_SHIFT;
+	io->wq_class = (flags & EFCT_SCSI_WQ_CLASS_MASK) >>
+				EFCT_SCSI_WQ_CLASS_SHIFT;
+
+	if (efct->xport) {
+		struct efct_xport *xport = efct->xport;
+
+		if (type == EFCT_HW_IO_TARGET_READ) {
+			xport->fcp_stats.input_requests++;
+			xport->fcp_stats.input_bytes += xwire_len;
+		} else if (type == EFCT_HW_IO_TARGET_WRITE) {
+			xport->fcp_stats.output_requests++;
+			xport->fcp_stats.output_bytes += xwire_len;
+		}
+	}
+	return efct_scsi_io_dispatch(io, efct_target_io_cb);
+}
+
+int
+efct_scsi_send_rd_data(struct efct_io *io, u32 flags,
+	struct efct_scsi_sgl *sgl, u32 sgl_count, u64 len,
+	efct_scsi_io_cb_t cb, void *arg)
+{
+	return efct_scsi_xfer_data(io, flags, sgl, sgl_count,
+				 len, EFCT_HW_IO_TARGET_READ,
+				 enable_tsend_auto_resp(io->efct), cb, arg);
+}
+
+int
+efct_scsi_recv_wr_data(struct efct_io *io, u32 flags,
+	struct efct_scsi_sgl *sgl, u32 sgl_count, u64 len,
+	efct_scsi_io_cb_t cb, void *arg)
+{
+	return efct_scsi_xfer_data(io, flags, sgl, sgl_count, len,
+				 EFCT_HW_IO_TARGET_WRITE,
+				 enable_treceive_auto_resp(io->efct), cb, arg);
+}
+
+int
+efct_scsi_send_resp(struct efct_io *io, u32 flags,
+		    struct efct_scsi_cmd_resp *rsp,
+		    efct_scsi_io_cb_t cb, void *arg)
+{
+	struct efct *efct;
+	int residual;
+	/* Always try auto resp */
+	bool auto_resp = true;
+	u8 scsi_status = 0;
+	u16 scsi_status_qualifier = 0;
+	u8 *sense_data = NULL;
+	u32 sense_data_length = 0;
+
+	efct = io->efct;
+
+	if (rsp) {
+		scsi_status = rsp->scsi_status;
+		scsi_status_qualifier = rsp->scsi_status_qualifier;
+		sense_data = rsp->sense_data;
+		sense_data_length = rsp->sense_data_length;
+		residual = rsp->residual;
+	} else {
+		residual = io->exp_xfer_len - io->transferred;
+	}
+
+	io->wire_len = 0;
+	io->hio_type = EFCT_HW_IO_TARGET_RSP;
+
+	io->scsi_tgt_cb = cb;
+	io->scsi_tgt_cb_arg = arg;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.fcp_tgt.ox_id = io->init_task_tag;
+	io->iparam.fcp_tgt.offset = 0;
+	io->iparam.fcp_tgt.cs_ctl = io->cs_ctl;
+	io->iparam.fcp_tgt.timeout = io->timeout;
+
+	/* Set low latency queueing request */
+	io->low_latency = (flags & EFCT_SCSI_LOW_LATENCY) != 0;
+	io->wq_steering = (flags & EFCT_SCSI_WQ_STEERING_MASK) >>
+				EFCT_SCSI_WQ_STEERING_SHIFT;
+	io->wq_class = (flags & EFCT_SCSI_WQ_CLASS_MASK) >>
+				EFCT_SCSI_WQ_CLASS_SHIFT;
+
+	if (scsi_status != 0 || residual || sense_data_length) {
+		struct fcp_resp_with_ext *fcprsp = io->rspbuf.virt;
+		u8 *sns_data;
+
+		if (!fcprsp) {
+			efc_log_err(efct, "NULL response buffer\n");
+			return EFC_FAIL;
+		}
+
+		sns_data = (u8 *)io->rspbuf.virt + sizeof(*fcprsp);
+
+		auto_resp = false;
+
+		memset(fcprsp, 0, sizeof(*fcprsp));
+
+		io->wire_len += sizeof(*fcprsp);
+
+		fcprsp->resp.fr_status = scsi_status;
+		fcprsp->resp.fr_retry_delay =
+			cpu_to_be16(scsi_status_qualifier);
+
+		/* set residual status if necessary */
+		if (residual != 0) {
+			/* FCP: if data transferred is less than the
+			 * amount expected, then this is an underflow.
+			 * If data transferred would have been greater
+			 * than the amount expected this is an overflow
+			 */
+			if (residual > 0) {
+				fcprsp->resp.fr_flags |= FCP_RESID_UNDER;
+				fcprsp->ext.fr_resid =	cpu_to_be32(residual);
+			} else {
+				fcprsp->resp.fr_flags |= FCP_RESID_OVER;
+				fcprsp->ext.fr_resid = cpu_to_be32(-residual);
+			}
+		}
+
+		if (EFCT_SCSI_SNS_BUF_VALID(sense_data) && sense_data_length) {
+			if (sense_data_length > SCSI_SENSE_BUFFERSIZE) {
+				efc_log_err(efct, "Sense exceeds max size.\n");
+				return EFC_FAIL;
+			}
+
+			fcprsp->resp.fr_flags |= FCP_SNS_LEN_VAL;
+			memcpy(sns_data, sense_data, sense_data_length);
+			fcprsp->ext.fr_sns_len = cpu_to_be32(sense_data_length);
+			io->wire_len += sense_data_length;
+		}
+
+		io->sgl[0].addr = io->rspbuf.phys;
+		io->sgl[0].dif_addr = 0;
+		io->sgl[0].len = io->wire_len;
+		io->sgl_count = 1;
+	}
+
+	if (auto_resp)
+		io->iparam.fcp_tgt.flags |= SLI4_IO_AUTO_GOOD_RESPONSE;
+
+	return efct_scsi_io_dispatch(io, efct_target_io_cb);
+}
+
+static int
+efct_target_bls_resp_cb(struct efct_hw_io *hio,	u32 length, int status,
+			u32 ext_status, void *app)
+{
+	struct efct_io *io = app;
+	struct efct *efct;
+	enum efct_scsi_io_status bls_status;
+
+	efct = io->efct;
+
+	/* BLS isn't really a "SCSI" concept, but use SCSI status */
+	if (status) {
+		io_error_log(io, "s=%#x x=%#x\n", status, ext_status);
+		bls_status = EFCT_SCSI_STATUS_ERROR;
+	} else {
+		bls_status = EFCT_SCSI_STATUS_GOOD;
+	}
+
+	if (io->bls_cb) {
+		efct_scsi_io_cb_t bls_cb = io->bls_cb;
+		void *bls_cb_arg = io->bls_cb_arg;
+
+		io->bls_cb = NULL;
+		io->bls_cb_arg = NULL;
+
+		/* invoke callback */
+		bls_cb(io, bls_status, 0, bls_cb_arg);
+	}
+
+	efct_scsi_check_pending(efct);
+	return EFC_SUCCESS;
+}
+
+static int
+efct_target_send_bls_resp(struct efct_io *io,
+			  efct_scsi_io_cb_t cb, void *arg)
+{
+	struct efct_node *node = io->node;
+	struct sli_bls_params *bls = &io->iparam.bls;
+	struct efct *efct = node->efct;
+	struct fc_ba_acc *acc;
+	int rc;
+
+	/* fill out IO structure with everything needed to send BA_ACC */
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	bls->ox_id = io->init_task_tag;
+	bls->rx_id = io->abort_rx_id;
+	bls->vpi = io->node->vpi;
+	bls->rpi = io->node->rpi;
+	bls->s_id = U32_MAX;
+	bls->d_id = io->node->node_fc_id;
+	bls->rpi_registered = true;
+
+	acc = (void *)bls->payload;
+	acc->ba_ox_id = cpu_to_be16(bls->ox_id);
+	acc->ba_rx_id = cpu_to_be16(bls->rx_id);
+	acc->ba_high_seq_cnt = cpu_to_be16(U16_MAX);
+
+	/* generic io fields have already been populated */
+
+	/* set type and BLS-specific fields */
+	io->io_type = EFCT_IO_TYPE_BLS_RESP;
+	io->display_name = "bls_rsp";
+	io->hio_type = EFCT_HW_BLS_ACC;
+	io->bls_cb = cb;
+	io->bls_cb_arg = arg;
+
+	/* dispatch IO */
+	rc = efct_hw_bls_send(efct, FC_RCTL_BA_ACC, bls,
+			      efct_target_bls_resp_cb, io);
+	return rc;
+}
+
+static int efct_bls_send_rjt_cb(struct efct_hw_io *hio, u32 length, int status,
+				u32 ext_status, void *app)
+{
+	struct efct_io *io = app;
+
+	efct_scsi_io_free(io);
+	return 0;
+}
+
+struct efct_io *
+efct_bls_send_rjt(struct efct_io *io, struct fc_frame_header *hdr)
+{
+	struct efct_node *node = io->node;
+	struct sli_bls_params *bls = &io->iparam.bls;
+	struct efct *efct = node->efct;
+	struct fc_ba_rjt *acc;
+	int rc;
+
+	/* fill out BLS Response-specific fields */
+	io->io_type = EFCT_IO_TYPE_BLS_RESP;
+	io->display_name = "ba_rjt";
+	io->hio_type = EFCT_HW_BLS_RJT;
+	io->init_task_tag = be16_to_cpu(hdr->fh_ox_id);
+
+	/* fill out iparam fields */
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	bls->ox_id = be16_to_cpu(hdr->fh_ox_id);
+	bls->rx_id = be16_to_cpu(hdr->fh_rx_id);
+	bls->vpi = io->node->vpi;
+	bls->rpi = io->node->rpi;
+	bls->s_id = U32_MAX;
+	bls->d_id = io->node->node_fc_id;
+	bls->rpi_registered = true;
+
+	acc = (void *)bls->payload;
+	acc->br_reason = ELS_RJT_UNAB;
+	acc->br_explan = ELS_EXPL_NONE;
+
+	rc = efct_hw_bls_send(efct, FC_RCTL_BA_RJT, bls, efct_bls_send_rjt_cb,
+			      io);
+	if (rc) {
+		efc_log_err(efct, "efct_scsi_io_dispatch() failed: %d\n", rc);
+		efct_scsi_io_free(io);
+		io = NULL;
+	}
+	return io;
+}
+
+int
+efct_scsi_send_tmf_resp(struct efct_io *io,
+			enum efct_scsi_tmf_resp rspcode,
+			u8 addl_rsp_info[3],
+			efct_scsi_io_cb_t cb, void *arg)
+{
+	int rc;
+	struct {
+		struct fcp_resp_with_ext rsp_ext;
+		struct fcp_resp_rsp_info info;
+	} *fcprsp;
+	u8 fcp_rspcode;
+
+	io->wire_len = 0;
+
+	switch (rspcode) {
+	case EFCT_SCSI_TMF_FUNCTION_COMPLETE:
+		fcp_rspcode = FCP_TMF_CMPL;
+		break;
+	case EFCT_SCSI_TMF_FUNCTION_SUCCEEDED:
+	case EFCT_SCSI_TMF_FUNCTION_IO_NOT_FOUND:
+		fcp_rspcode = FCP_TMF_CMPL;
+		break;
+	case EFCT_SCSI_TMF_FUNCTION_REJECTED:
+		fcp_rspcode = FCP_TMF_REJECTED;
+		break;
+	case EFCT_SCSI_TMF_INCORRECT_LOGICAL_UNIT_NUMBER:
+		fcp_rspcode = FCP_TMF_INVALID_LUN;
+		break;
+	case EFCT_SCSI_TMF_SERVICE_DELIVERY:
+		fcp_rspcode = FCP_TMF_FAILED;
+		break;
+	default:
+		fcp_rspcode = FCP_TMF_REJECTED;
+		break;
+	}
+
+	io->hio_type = EFCT_HW_IO_TARGET_RSP;
+
+	io->scsi_tgt_cb = cb;
+	io->scsi_tgt_cb_arg = arg;
+
+	if (io->tmf_cmd == EFCT_SCSI_TMF_ABORT_TASK) {
+		rc = efct_target_send_bls_resp(io, cb, arg);
+		return rc;
+	}
+
+	/* populate the FCP TMF response */
+	fcprsp = io->rspbuf.virt;
+	memset(fcprsp, 0, sizeof(*fcprsp));
+
+	fcprsp->rsp_ext.resp.fr_flags |= FCP_SNS_LEN_VAL;
+
+	if (addl_rsp_info) {
+		memcpy(fcprsp->info._fr_resvd, addl_rsp_info,
+		       sizeof(fcprsp->info._fr_resvd));
+	}
+	fcprsp->info.rsp_code = fcp_rspcode;
+
+	io->wire_len = sizeof(*fcprsp);
+
+	fcprsp->rsp_ext.ext.fr_rsp_len =
+			cpu_to_be32(sizeof(struct fcp_resp_rsp_info));
+
+	io->sgl[0].addr = io->rspbuf.phys;
+	io->sgl[0].dif_addr = 0;
+	io->sgl[0].len = io->wire_len;
+	io->sgl_count = 1;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.fcp_tgt.ox_id = io->init_task_tag;
+	io->iparam.fcp_tgt.offset = 0;
+	io->iparam.fcp_tgt.cs_ctl = io->cs_ctl;
+	io->iparam.fcp_tgt.timeout = io->timeout;
+
+	rc = efct_scsi_io_dispatch(io, efct_target_io_cb);
+
+	return rc;
+}
+
+static int
+efct_target_abort_cb(struct efct_hw_io *hio, u32 length, int status,
+		     u32 ext_status, void *app)
+{
+	struct efct_io *io = app;
+	struct efct *efct;
+	enum efct_scsi_io_status scsi_status;
+	efct_scsi_io_cb_t abort_cb;
+	void *abort_cb_arg;
+
+	efct = io->efct;
+
+	if (!io->abort_cb)
+		goto done;
+
+	abort_cb = io->abort_cb;
+	abort_cb_arg = io->abort_cb_arg;
+
+	io->abort_cb = NULL;
+	io->abort_cb_arg = NULL;
+
+	switch (status) {
+	case SLI4_FC_WCQE_STATUS_SUCCESS:
+		scsi_status = EFCT_SCSI_STATUS_GOOD;
+		break;
+	case SLI4_FC_WCQE_STATUS_LOCAL_REJECT:
+		switch (ext_status) {
+		case SLI4_FC_LOCAL_REJECT_NO_XRI:
+			scsi_status = EFCT_SCSI_STATUS_NO_IO;
+			break;
+		case SLI4_FC_LOCAL_REJECT_ABORT_IN_PROGRESS:
+			scsi_status = EFCT_SCSI_STATUS_ABORT_IN_PROGRESS;
+			break;
+		default:
+			/*we have seen 0x15 (abort in progress)*/
+			scsi_status = EFCT_SCSI_STATUS_ERROR;
+			break;
+		}
+		break;
+	case SLI4_FC_WCQE_STATUS_FCP_RSP_FAILURE:
+		scsi_status = EFCT_SCSI_STATUS_CHECK_RESPONSE;
+		break;
+	default:
+		scsi_status = EFCT_SCSI_STATUS_ERROR;
+		break;
+	}
+	/* invoke callback */
+	abort_cb(io->io_to_abort, scsi_status, 0, abort_cb_arg);
+
+done:
+	/* done with IO to abort,efct_ref_get(): efct_scsi_tgt_abort_io() */
+	kref_put(&io->io_to_abort->ref, io->io_to_abort->release);
+
+	efct_io_pool_io_free(efct->xport->io_pool, io);
+
+	efct_scsi_check_pending(efct);
+	return EFC_SUCCESS;
+}
+
+int
+efct_scsi_tgt_abort_io(struct efct_io *io, efct_scsi_io_cb_t cb, void *arg)
+{
+	struct efct *efct;
+	struct efct_xport *xport;
+	int rc;
+	struct efct_io *abort_io = NULL;
+
+	efct = io->efct;
+	xport = efct->xport;
+
+	/* take a reference on IO being aborted */
+	if (kref_get_unless_zero(&io->ref) == 0) {
+		/* command no longer active */
+		scsi_io_printf(io, "command no longer active\n");
+		return EFC_FAIL;
+	}
+
+	/*
+	 * allocate a new IO to send the abort request. Use efct_io_alloc()
+	 * directly, as we need an IO object that will not fail allocation
+	 * due to allocations being disabled (in efct_scsi_io_alloc())
+	 */
+	abort_io = efct_io_pool_io_alloc(efct->xport->io_pool);
+	if (!abort_io) {
+		atomic_add_return(1, &xport->io_alloc_failed_count);
+		kref_put(&io->ref, io->release);
+		return EFC_FAIL;
+	}
+
+	/* Save the target server callback and argument */
+	/* set generic fields */
+	abort_io->cmd_tgt = true;
+	abort_io->node = io->node;
+
+	/* set type and abort-specific fields */
+	abort_io->io_type = EFCT_IO_TYPE_ABORT;
+	abort_io->display_name = "tgt_abort";
+	abort_io->io_to_abort = io;
+	abort_io->send_abts = false;
+	abort_io->abort_cb = cb;
+	abort_io->abort_cb_arg = arg;
+
+	/* now dispatch IO */
+	rc = efct_scsi_io_dispatch_abort(abort_io, efct_target_abort_cb);
+	if (rc)
+		kref_put(&io->ref, io->release);
+	return rc;
+}
+
+void
+efct_scsi_io_complete(struct efct_io *io)
+{
+	if (io->io_free) {
+		efc_log_debug(io->efct, "completion for non-busy io tag 0x%x\n",
+					io->tag);
+		return;
+	}
+
+	scsi_io_trace(io, "freeing io 0x%p %s\n", io, io->display_name);
+	kref_put(&io->ref, io->release);
+}
diff --git a/drivers/scsi/elx/efct/efct_scsi.h b/drivers/scsi/elx/efct/efct_scsi.h
new file mode 100644
index 000000000000..7c4afa1e8c95
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_scsi.h
@@ -0,0 +1,207 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_SCSI_H__)
+#define __EFCT_SCSI_H__
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_fc.h>
+
+/* efct_scsi_rcv_cmd() efct_scsi_rcv_tmf() flags */
+#define EFCT_SCSI_CMD_DIR_IN		(1 << 0)
+#define EFCT_SCSI_CMD_DIR_OUT		(1 << 1)
+#define EFCT_SCSI_CMD_SIMPLE		(1 << 2)
+#define EFCT_SCSI_CMD_HEAD_OF_QUEUE	(1 << 3)
+#define EFCT_SCSI_CMD_ORDERED		(1 << 4)
+#define EFCT_SCSI_CMD_UNTAGGED		(1 << 5)
+#define EFCT_SCSI_CMD_ACA		(1 << 6)
+#define EFCT_SCSI_FIRST_BURST_ERR	(1 << 7)
+#define EFCT_SCSI_FIRST_BURST_ABORTED	(1 << 8)
+
+/* efct_scsi_send_rd_data/recv_wr_data/send_resp flags */
+#define EFCT_SCSI_LAST_DATAPHASE	(1 << 0)
+#define EFCT_SCSI_NO_AUTO_RESPONSE	(1 << 1)
+#define EFCT_SCSI_LOW_LATENCY		(1 << 2)
+
+#define EFCT_SCSI_SNS_BUF_VALID(sense)	((sense) && \
+			(0x70 == (((const u8 *)(sense))[0] & 0x70)))
+
+#define EFCT_SCSI_WQ_STEERING_SHIFT	16
+#define EFCT_SCSI_WQ_STEERING_MASK	(0xf << EFCT_SCSI_WQ_STEERING_SHIFT)
+#define EFCT_SCSI_WQ_STEERING_CLASS	(0 << EFCT_SCSI_WQ_STEERING_SHIFT)
+#define EFCT_SCSI_WQ_STEERING_REQUEST	(1 << EFCT_SCSI_WQ_STEERING_SHIFT)
+#define EFCT_SCSI_WQ_STEERING_CPU	(2 << EFCT_SCSI_WQ_STEERING_SHIFT)
+
+#define EFCT_SCSI_WQ_CLASS_SHIFT		(20)
+#define EFCT_SCSI_WQ_CLASS_MASK		(0xf << EFCT_SCSI_WQ_CLASS_SHIFT)
+#define EFCT_SCSI_WQ_CLASS(x)		((x & EFCT_SCSI_WQ_CLASS_MASK) << \
+						EFCT_SCSI_WQ_CLASS_SHIFT)
+
+#define EFCT_SCSI_WQ_CLASS_LOW_LATENCY	1
+
+struct efct_scsi_cmd_resp {
+	u8 scsi_status;
+	u16 scsi_status_qualifier;
+	u8 *response_data;
+	u32 response_data_length;
+	u8 *sense_data;
+	u32 sense_data_length;
+	int residual;
+	u32 response_wire_length;
+};
+
+struct efct_vport {
+	struct efct		*efct;
+	bool			is_vport;
+	struct fc_host_statistics fc_host_stats;
+	struct Scsi_Host	*shost;
+	struct fc_vport		*fc_vport;
+	u64			npiv_wwpn;
+	u64			npiv_wwnn;
+};
+
+/* Status values returned by IO callbacks */
+enum efct_scsi_io_status {
+	EFCT_SCSI_STATUS_GOOD = 0,
+	EFCT_SCSI_STATUS_ABORTED,
+	EFCT_SCSI_STATUS_ERROR,
+	EFCT_SCSI_STATUS_DIF_GUARD_ERR,
+	EFCT_SCSI_STATUS_DIF_REF_TAG_ERROR,
+	EFCT_SCSI_STATUS_DIF_APP_TAG_ERROR,
+	EFCT_SCSI_STATUS_DIF_UNKNOWN_ERROR,
+	EFCT_SCSI_STATUS_PROTOCOL_CRC_ERROR,
+	EFCT_SCSI_STATUS_NO_IO,
+	EFCT_SCSI_STATUS_ABORT_IN_PROGRESS,
+	EFCT_SCSI_STATUS_CHECK_RESPONSE,
+	EFCT_SCSI_STATUS_COMMAND_TIMEOUT,
+	EFCT_SCSI_STATUS_TIMEDOUT_AND_ABORTED,
+	EFCT_SCSI_STATUS_SHUTDOWN,
+	EFCT_SCSI_STATUS_NEXUS_LOST,
+};
+
+struct efct_node;
+struct efct_io;
+struct efc_node;
+struct efc_nport;
+
+/* Callback used by send_rd_data(), recv_wr_data(), send_resp() */
+typedef int (*efct_scsi_io_cb_t)(struct efct_io *io,
+				    enum efct_scsi_io_status status,
+				    u32 flags, void *arg);
+
+/* Callback used by send_rd_io(), send_wr_io() */
+typedef int (*efct_scsi_rsp_io_cb_t)(struct efct_io *io,
+			enum efct_scsi_io_status status,
+			struct efct_scsi_cmd_resp *rsp,
+			u32 flags, void *arg);
+
+/* efct_scsi_cb_t flags */
+#define EFCT_SCSI_IO_CMPL		(1 << 0)
+/* IO completed, response sent */
+#define EFCT_SCSI_IO_CMPL_RSP_SENT	(1 << 1)
+#define EFCT_SCSI_IO_ABORTED		(1 << 2)
+
+/* efct_scsi_recv_tmf() request values */
+enum efct_scsi_tmf_cmd {
+	EFCT_SCSI_TMF_ABORT_TASK = 1,
+	EFCT_SCSI_TMF_QUERY_TASK_SET,
+	EFCT_SCSI_TMF_ABORT_TASK_SET,
+	EFCT_SCSI_TMF_CLEAR_TASK_SET,
+	EFCT_SCSI_TMF_QUERY_ASYNCHRONOUS_EVENT,
+	EFCT_SCSI_TMF_LOGICAL_UNIT_RESET,
+	EFCT_SCSI_TMF_CLEAR_ACA,
+	EFCT_SCSI_TMF_TARGET_RESET,
+};
+
+/* efct_scsi_send_tmf_resp() response values */
+enum efct_scsi_tmf_resp {
+	EFCT_SCSI_TMF_FUNCTION_COMPLETE = 1,
+	EFCT_SCSI_TMF_FUNCTION_SUCCEEDED,
+	EFCT_SCSI_TMF_FUNCTION_IO_NOT_FOUND,
+	EFCT_SCSI_TMF_FUNCTION_REJECTED,
+	EFCT_SCSI_TMF_INCORRECT_LOGICAL_UNIT_NUMBER,
+	EFCT_SCSI_TMF_SERVICE_DELIVERY,
+};
+
+struct efct_scsi_sgl {
+	uintptr_t	addr;
+	uintptr_t	dif_addr;
+	size_t		len;
+};
+
+/* Return values for calls from base driver to libefc */
+#define EFCT_SCSI_CALL_COMPLETE	0 /* All work is done */
+#define EFCT_SCSI_CALL_ASYNC	1 /* Work will be completed asynchronously */
+
+enum efct_scsi_io_role {
+	EFCT_SCSI_IO_ROLE_ORIGINATOR,
+	EFCT_SCSI_IO_ROLE_RESPONDER,
+};
+
+struct efct_io *
+efct_scsi_io_alloc(struct efct_node *node);
+void efct_scsi_io_free(struct efct_io *io);
+struct efct_io *efct_io_get_instance(struct efct *efct, u32 index);
+
+int efct_scsi_tgt_driver_init(void);
+int efct_scsi_tgt_driver_exit(void);
+int efct_scsi_tgt_new_device(struct efct *efct);
+int efct_scsi_tgt_del_device(struct efct *efct);
+int
+efct_scsi_tgt_new_nport(struct efc *efc, struct efc_nport *nport);
+void
+efct_scsi_tgt_del_nport(struct efc *efc, struct efc_nport *nport);
+
+int
+efct_scsi_new_initiator(struct efc *efc, struct efc_node *node);
+
+enum efct_scsi_del_initiator_reason {
+	EFCT_SCSI_INITIATOR_DELETED,
+	EFCT_SCSI_INITIATOR_MISSING,
+};
+
+int
+efct_scsi_del_initiator(struct efc *efc, struct efc_node *node,	int reason);
+int
+efct_scsi_recv_cmd(struct efct_io *io, uint64_t lun, u8 *cdb, u32 cdb_len,
+			u32 flags);
+int
+efct_scsi_recv_tmf(struct efct_io *tmfio, u32 lun, enum efct_scsi_tmf_cmd cmd,
+			struct efct_io *abortio, u32 flags);
+int
+efct_scsi_send_rd_data(struct efct_io *io, u32 flags, struct efct_scsi_sgl *sgl,
+		u32 sgl_count, u64 wire_len, efct_scsi_io_cb_t cb, void *arg);
+int
+efct_scsi_recv_wr_data(struct efct_io *io, u32 flags, struct efct_scsi_sgl *sgl,
+		u32 sgl_count, u64 wire_len, efct_scsi_io_cb_t cb, void *arg);
+int
+efct_scsi_send_resp(struct efct_io *io, u32 flags,
+	struct efct_scsi_cmd_resp *rsp, efct_scsi_io_cb_t cb, void *arg);
+int
+efct_scsi_send_tmf_resp(struct efct_io *io, enum efct_scsi_tmf_resp rspcode,
+		       u8 addl_rsp_info[3], efct_scsi_io_cb_t cb, void *arg);
+int
+efct_scsi_tgt_abort_io(struct efct_io *io, efct_scsi_io_cb_t cb, void *arg);
+
+void efct_scsi_io_complete(struct efct_io *io);
+
+int efct_scsi_reg_fc_transport(void);
+int efct_scsi_release_fc_transport(void);
+int efct_scsi_new_device(struct efct *efct);
+int efct_scsi_del_device(struct efct *efct);
+void _efct_scsi_io_free(struct kref *arg);
+
+int
+efct_scsi_del_vport(struct efct *efct, struct Scsi_Host *shost);
+struct efct_vport *
+efct_scsi_new_vport(struct efct *efct, struct device *dev);
+
+int efct_scsi_io_dispatch(struct efct_io *io, void *cb);
+int efct_scsi_io_dispatch_abort(struct efct_io *io, void *cb);
+void efct_scsi_check_pending(struct efct *efct);
+struct efct_io *
+efct_bls_send_rjt(struct efct_io *io, struct fc_frame_header *hdr);
+
+#endif /* __EFCT_SCSI_H__ */
-- 
2.26.2

