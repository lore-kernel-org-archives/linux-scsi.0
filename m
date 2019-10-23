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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC66CA9EBB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E456C205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSdGJwUm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436635AbfJWV4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54957 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436617AbfJWV4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id g7so507609wmk.4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P2KGE7NrQBj8ukksKyoyrxW2uqt3lQ5wwu3GvG9Fub0=;
        b=iSdGJwUmB/7Bp/w42NjcLKSMEUkdggBrBnGtZQPJanaXhB2GIMCNLED21ybnbAoHYF
         tqv8bmMKhbF6ZZwveuL0+nuvQelKiCDkI0maZpjLuwCAUTrZpALi1UGe7bpU9vg5gD1z
         IBBDmt1N3UWJH4g+j3R/WatyRLP+xv77T5MyRA70XT/PLgdbNRS3n9LeGjslw2wa3JfR
         PSAjHxSOfB4v1zP0/kZmxAn2yeew1I9ijbK3+xPQ4wONVD39RuwYmZLQVgi/2A01kS0l
         Jqrh9HibHvRh2ajFUOiTGKIo8nd35RqrxxwC3Vxi2q8hM0RuUi8gBrcbW0Q1QH5ja4mj
         N8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P2KGE7NrQBj8ukksKyoyrxW2uqt3lQ5wwu3GvG9Fub0=;
        b=uhHF6fVLtjZ/BmNbxbJ3HEC9W4jUWtqBszWCnOrvwBovwmB/DSIGV9O7HhbxanZFB2
         XgMic1ImHEdLmoTs4+CWG+DnqLAkQxLFUFSV88N01m2SBpjOei4r5H6C1j9x1zlYYtMM
         obPmPjE4Y//QBoEIuFp8J4XQQXV67n5oTkTBQvEQLUfo6SMuUMvJI+asiZM7vU/9V5rH
         hMi5PFAqaJr1bEVoYEcuD1vTZcXhjYM2FjY2BVytFKgBJdm6qXy/m5Jz5Jp4YIffcj9a
         qBKFDJmYxCRmRlVnZL2GsHcX1TF51jygp5rq4f1Eg67Gyt/AIQekgQ15fIPGrDBPyXuM
         2JNw==
X-Gm-Message-State: APjAAAVymTvkdldik1vYRkZ0cnSF3UsUJNWLdPlJTmWFBhOiNpJQ4ZjB
        rG93zJO6S322RhVRRaj6cTHa5hNJ
X-Google-Smtp-Source: APXvYqyO+nudU7L3fOyfziijELu2DlgybXesmz1mu0sKXsDbOboApduSALx2wKE6t6R32XLREk7lQg==
X-Received: by 2002:a1c:4045:: with SMTP id n66mr1813734wma.92.1571867805401;
        Wed, 23 Oct 2019 14:56:45 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:44 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 23/32] elx: efct: SCSI IO handling routines
Date:   Wed, 23 Oct 2019 14:55:48 -0700
Message-Id: <20191023215557.12581-24-jsmart2021@gmail.com>
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
Routines for SCSI trasport IO alloc, build and send IO.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_scsi.c | 1970 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_scsi.h |  401 ++++++++
 2 files changed, 2371 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.c
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.h

diff --git a/drivers/scsi/elx/efct/efct_scsi.c b/drivers/scsi/elx/efct/efct_scsi.c
new file mode 100644
index 000000000000..349a6610ad0b
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_scsi.c
@@ -0,0 +1,1970 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_els.h"
+#include "efct_utils.h"
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
+#define scsi_io_trace(io, fmt, ...) \
+	do { \
+		if (EFCT_LOG_ENABLE_SCSI_TRACE(io->efct)) \
+			scsi_io_printf(io, fmt, ##__VA_ARGS__); \
+	} while (0)
+
+static int
+efct_target_send_bls_resp(struct efct_io_s *, efct_scsi_io_cb_t, void *);
+static void
+efct_scsi_io_free_ovfl(struct efct_io_s *);
+static u32
+efct_scsi_count_sgls(struct efct_hw_dif_info_s *, struct efct_scsi_sgl_s *,
+		     u32);
+static int
+efct_scsi_io_dispatch_hw_io(struct efct_io_s *, struct efct_hw_io_s *);
+static int
+efct_scsi_io_dispatch_no_hw_io(struct efct_io_s *);
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Returns a big-endian 32-bit value given a pointer.
+ *
+ * @param p Pointer to the 32-bit big-endian location.
+ *
+ * @return Returns the byte-swapped 32-bit value.
+ */
+
+static inline u32
+efct_fc_getbe32(void *p)
+{
+	return be32_to_cpu(*((u32 *)p));
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Enable IO allocation.
+ *
+ * @par Description
+ * The SCSI and Transport IO allocation functions are enabled.
+ * If the allocation functions are not enabled, then calls to
+ * efct_scsi_io_alloc() (and efct_els_io_alloc() for FC) will fail.
+ *
+ * @param node Pointer to node object.
+ *
+ * @return None.
+ */
+void
+efct_scsi_io_alloc_enable(struct efc_lport *efc, struct efc_node_s *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+		node->io_alloc_enabled = true;
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Disable IO allocation
+ *
+ * @par Description
+ * The SCSI and Transport IO allocation functions are disabled.
+ * If the allocation functions are not enabled, then calls to
+ * efct_scsi_io_alloc() (and efct_els_io_alloc() for FC) will fail.
+ *
+ * @param node Pointer to node object
+ *
+ * @return None.
+ */
+void
+efct_scsi_io_alloc_disable(struct efc_lport *efc, struct efc_node_s *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+		node->io_alloc_enabled = false;
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Allocate a SCSI IO context.
+ *
+ * @par Description
+ * A SCSI IO context is allocated and associated with a @c node.
+ * This function is called by an initiator-client when issuing SCSI
+ * commands to remote target devices. On completion, efct_scsi_io_free()
+ * is called.
+ * The returned struct efct_io_s structure has an element of type
+ * struct efct_scsi_ini_io_s named &quot;ini_io&quot; that is declared
+ * and used by an initiator-client
+ * for private information.
+ *
+ * @param node Pointer to the associated node structure.
+ * @param role Role for IO (originator/responder).
+ *
+ * @return Returns the pointer to the IO context, or NULL.
+ *
+ */
+
+struct efct_io_s *
+efct_scsi_io_alloc(struct efc_node_s *node, enum efct_scsi_io_role_e role)
+{
+	struct efct_s *efct;
+	struct efc_lport *efcp;
+	struct efct_xport_s *xport;
+	struct efct_io_s *io;
+	unsigned long flags = 0;
+
+	efcp = node->efc;
+	efct = efcp->base;
+
+	xport = efct->xport;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+
+		if (!node->io_alloc_enabled) {
+			spin_unlock_irqrestore(&node->active_ios_lock, flags);
+			return NULL;
+		}
+
+		io = efct_io_pool_io_alloc(efct->xport->io_pool);
+		if (!io) {
+			atomic_add_return(1, &xport->io_alloc_failed_count);
+			spin_unlock_irqrestore(&node->active_ios_lock, flags);
+			return NULL;
+		}
+
+		/* initialize refcount */
+		kref_init(&io->ref);
+		io->release = _efct_scsi_io_free;
+
+		if (io->hio) {
+			efc_log_err(efct,
+				     "assertion failed: io->hio is not NULL\n");
+			spin_unlock_irqrestore(&node->active_ios_lock, flags);
+			return NULL;
+		}
+
+		/* set generic fields */
+		io->efct = efct;
+		io->node = node;
+
+		/* set type and name */
+		io->io_type = EFCT_IO_TYPE_IO;
+		io->display_name = "scsi_io";
+
+		switch (role) {
+		case EFCT_SCSI_IO_ROLE_ORIGINATOR:
+			io->cmd_ini = true;
+			io->cmd_tgt = false;
+			break;
+		case EFCT_SCSI_IO_ROLE_RESPONDER:
+			io->cmd_ini = false;
+			io->cmd_tgt = true;
+			break;
+		}
+
+		/* Add to node's active_ios list */
+		INIT_LIST_HEAD(&io->list_entry);
+		list_add_tail(&io->list_entry, &node->active_ios);
+
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+
+	return io;
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Free a SCSI IO context (internal).
+ *
+ * @par Description
+ * The IO context previously allocated using efct_scsi_io_alloc()
+ * is freed. This is called from within the transport layer,
+ * when the reference count goes to zero.
+ *
+ * @param arg Pointer to the IO context.
+ *
+ * @return None.
+ */
+void
+_efct_scsi_io_free(struct kref *arg)
+{
+	struct efct_io_s *io = container_of(arg, struct efct_io_s, ref);
+	struct efct_s *efct = io->efct;
+	struct efc_node_s *node = io->node;
+	int send_empty_event;
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
+		list_del(&io->list_entry);
+		send_empty_event = (!node->io_alloc_enabled) &&
+					list_empty(&node->active_ios);
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+
+	if (send_empty_event)
+		efc_scsi_io_list_empty(node->efc, node);
+
+	io->node = NULL;
+	efct_io_pool_io_free(efct->xport->io_pool, io);
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Free a SCSI IO context.
+ *
+ * @par Description
+ * The IO context previously allocated using efct_scsi_io_alloc() is freed.
+ *
+ * @param io Pointer to the IO context.
+ *
+ * @return None.
+ */
+void
+efct_scsi_io_free(struct efct_io_s *io)
+{
+	scsi_io_trace(io, "freeing io 0x%p %s\n", io, io->display_name);
+	WARN_ON(refcount_read(&io->ref.refcount) != 0);
+	kref_put(&io->ref, io->release);
+}
+
+/**
+ * @brief Target response completion callback.
+ *
+ * @par Description
+ * Function is called upon the completion of a target IO request.
+ *
+ * @param hio Pointer to the HW IO structure.
+ * @param rnode Remote node associated with the IO that is completing.
+ * @param length Length of the response payload.
+ * @param status Completion status.
+ * @param ext_status Extended completion status.
+ * @param app Application-specific data (generally a pointer to
+ * the IO context).
+ *
+ * @return None.
+ */
+
+static void
+efct_target_io_cb(struct efct_hw_io_s *hio, struct efc_remote_node_s *rnode,
+		  u32 length, int status, u32 ext_status, void *app)
+{
+	struct efct_io_s *io = app;
+	struct efct_s *efct;
+	enum efct_scsi_io_status_e scsi_stat = EFCT_SCSI_STATUS_GOOD;
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
+	efct_scsi_io_free_ovfl(io);
+
+	io->transferred += length;
+
+	/* Call target server completion */
+	if (io->scsi_tgt_cb) {
+		efct_scsi_io_cb_t cb = io->scsi_tgt_cb;
+		u32 flags = 0;
+
+		/* Clear the callback before invoking the callback */
+		io->scsi_tgt_cb = NULL;
+
+		/* if status was good, and auto-good-response was set,
+		 * then callback target-server with IO_CMPL_RSP_SENT,
+		 * otherwise send IO_CMPL
+		 */
+		if (status == 0 && io->auto_resp)
+			flags |= EFCT_SCSI_IO_CMPL_RSP_SENT;
+		else
+			flags |= EFCT_SCSI_IO_CMPL;
+
+		switch (status) {
+		case SLI4_FC_WCQE_STATUS_SUCCESS:
+			scsi_stat = EFCT_SCSI_STATUS_GOOD;
+			break;
+		case SLI4_FC_WCQE_STATUS_DI_ERROR:
+			if (ext_status & SLI4_FC_DI_ERROR_GE)
+				scsi_stat = EFCT_SCSI_STATUS_DIF_GUARD_ERR;
+			else if (ext_status & SLI4_FC_DI_ERROR_AE)
+				scsi_stat = EFCT_SCSI_STATUS_DIF_APP_TAG_ERROR;
+			else if (ext_status & SLI4_FC_DI_ERROR_RE)
+				scsi_stat = EFCT_SCSI_STATUS_DIF_REF_TAG_ERROR;
+			else
+				scsi_stat = EFCT_SCSI_STATUS_DIF_UNKNOWN_ERROR;
+			break;
+		case SLI4_FC_WCQE_STATUS_LOCAL_REJECT:
+			switch (ext_status) {
+			case SLI4_FC_LOCAL_REJECT_INVALID_RELOFFSET:
+			case SLI4_FC_LOCAL_REJECT_ABORT_REQUESTED:
+				scsi_stat = EFCT_SCSI_STATUS_ABORTED;
+				break;
+			case SLI4_FC_LOCAL_REJECT_INVALID_RPI:
+				scsi_stat = EFCT_SCSI_STATUS_NEXUS_LOST;
+				break;
+			case SLI4_FC_LOCAL_REJECT_NO_XRI:
+				scsi_stat = EFCT_SCSI_STATUS_NO_IO;
+				break;
+			default:
+				/*we have seen 0x0d(TX_DMA_FAILED err)*/
+				scsi_stat = EFCT_SCSI_STATUS_ERROR;
+				break;
+			}
+			break;
+
+		case SLI4_FC_WCQE_STATUS_TARGET_WQE_TIMEOUT:
+			/* target IO timed out */
+			scsi_stat = EFCT_SCSI_STATUS_TIMEDOUT_AND_ABORTED;
+			break;
+
+		case SLI4_FC_WCQE_STATUS_SHUTDOWN:
+			/* Target IO cancelled by HW */
+			scsi_stat = EFCT_SCSI_STATUS_SHUTDOWN;
+			break;
+
+		default:
+			scsi_stat = EFCT_SCSI_STATUS_ERROR;
+			break;
+		}
+
+		cb(io, scsi_stat, flags, io->scsi_tgt_cb_arg);
+	}
+	efct_scsi_check_pending(efct);
+}
+
+/**
+ * @brief Return count of SGE's required for request
+ *
+ * @par Description
+ * An accurate count of SGEs is computed and returned.
+ *
+ * @param hw_dif Pointer to HW dif information.
+ * @param sgl Pointer to SGL from back end.
+ * @param sgl_count Count of SGEs in SGL.
+ *
+ * @return Count of SGEs.
+ */
+static u32
+efct_scsi_count_sgls(struct efct_hw_dif_info_s *hw_dif,
+		     struct efct_scsi_sgl_s *sgl, u32 sgl_count)
+{
+	u32 count = 0;
+	u32 i;
+
+	/* Convert DIF Information */
+	if (hw_dif->dif_oper != EFCT_HW_DIF_OPER_DISABLED) {
+		/* If we're not DIF separate, then emit a seed SGE */
+		if (!hw_dif->dif_separate)
+			count++;
+
+		for (i = 0; i < sgl_count; i++) {
+			/* If DIF is enabled, and DIF is separate,
+			 * then append a SEED then DIF SGE
+			 */
+			if (hw_dif->dif_separate)
+				count += 2;
+
+			count++;
+		}
+	} else {
+		count = sgl_count;
+	}
+	return count;
+}
+
+static int
+efct_scsi_build_sgls(struct efct_hw_s *hw, struct efct_hw_io_s *hio,
+		     struct efct_hw_dif_info_s *hw_dif,
+		struct efct_scsi_sgl_s *sgl, u32 sgl_count,
+		enum efct_hw_io_type_e type)
+{
+	int rc;
+	u32 i;
+	struct efct_s *efct = hw->os;
+	u32 blocksize = 0;
+	u32 blockcount;
+
+	/* Initialize HW SGL */
+	rc = efct_hw_io_init_sges(hw, hio, type);
+	if (rc) {
+		efc_log_err(efct, "efct_hw_io_init_sges failed: %d\n", rc);
+		return -1;
+	}
+
+	/* Convert DIF Information */
+	if (hw_dif->dif_oper != EFCT_HW_DIF_OPER_DISABLED) {
+		/* If we're not DIF separate, then emit a seed SGE */
+		if (!hw_dif->dif_separate) {
+			rc = efct_hw_io_add_seed_sge(hw, hio, hw_dif);
+			if (rc)
+				return rc;
+		}
+
+		/* if we are doing DIF separate, then figure out the
+		 * block size so that we can update the ref tag in the
+		 * DIF seed SGE.   Also verify that the
+		 * the sgl lengths are all multiples of the blocksize
+		 */
+		if (hw_dif->dif_separate) {
+			switch (hw_dif->blk_size) {
+			case EFCT_HW_DIF_BK_SIZE_512:
+				blocksize = 512;
+				break;
+			case EFCT_HW_DIF_BK_SIZE_1024:
+				blocksize = 1024;
+				break;
+			case EFCT_HW_DIF_BK_SIZE_2048:
+				blocksize = 2048;
+				break;
+			case EFCT_HW_DIF_BK_SIZE_4096:
+				blocksize = 4096;
+				break;
+			case EFCT_HW_DIF_BK_SIZE_520:
+				blocksize = 520;
+				break;
+			case EFCT_HW_DIF_BK_SIZE_4104:
+				blocksize = 4104;
+				break;
+			default:
+				efc_log_test(efct,
+					      "Invalid hw_dif blocksize %d\n",
+					hw_dif->blk_size);
+				return -1;
+			}
+			for (i = 0; i < sgl_count; i++) {
+				if ((sgl[i].len % blocksize) != 0) {
+					efc_log_test(efct,
+						      "sgl[%d] len of %ld is not multiple of blocksize\n",
+					i, sgl[i].len);
+					return -1;
+				}
+			}
+		}
+
+		for (i = 0; i < sgl_count; i++) {
+
+			/* If DIF is enabled, and DIF is separate,
+			 * then append a SEED then DIF SGE
+			 */
+			if (hw_dif->dif_separate) {
+				rc = efct_hw_io_add_seed_sge(hw, hio,
+							     hw_dif);
+				if (rc)
+					return rc;
+				rc = efct_hw_io_add_dif_sge(hw, hio,
+							    sgl[i].dif_addr);
+				if (rc)
+					return rc;
+				/* Update the ref_tag for next DIF seed SGE*/
+				blockcount = sgl[i].len / blocksize;
+				if (hw_dif->dif_oper ==
+					EFCT_HW_DIF_OPER_INSERT)
+					hw_dif->ref_tag_repl += blockcount;
+				else
+					hw_dif->ref_tag_cmp += blockcount;
+			}
+
+			/* Add data SGE */
+			rc = efct_hw_io_add_sge(hw, hio,
+						sgl[i].addr, sgl[i].len);
+			if (rc) {
+				efc_log_err(efct,
+					     "add sge failed cnt=%d rc=%d\n",
+					     sgl_count, rc);
+				return rc;
+			}
+		}
+	} else {
+		for (i = 0; i < sgl_count; i++) {
+
+			/* Add data SGE */
+			rc = efct_hw_io_add_sge(hw, hio,
+						sgl[i].addr, sgl[i].len);
+			if (rc) {
+				efc_log_err(efct,
+					     "add sge failed cnt=%d rc=%d\n",
+					     sgl_count, rc);
+				return rc;
+			}
+		}
+	}
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Convert SCSI API T10 DIF information into the FC HW format.
+ *
+ * @param efct Pointer to the efct structure for logging.
+ * @param scsi_dif_info Pointer to the SCSI API T10 DIF fields.
+ * @param hw_dif_info Pointer to the FC HW API T10 DIF fields.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+static int
+efct_scsi_convert_dif_info(struct efct_s *efct,
+			   struct efct_scsi_dif_info_s *scsi_dif_info,
+			  struct efct_hw_dif_info_s *hw_dif_info)
+{
+	u32 dif_seed;
+
+	memset(hw_dif_info, 0,
+	       sizeof(struct efct_hw_dif_info_s));
+
+	if (!scsi_dif_info) {
+		hw_dif_info->dif_oper = EFCT_HW_DIF_OPER_DISABLED;
+		hw_dif_info->blk_size =  EFCT_HW_DIF_BK_SIZE_NA;
+		return 0;
+	}
+
+	/* Convert the DIF operation */
+	switch (scsi_dif_info->dif_oper) {
+	case EFCT_SCSI_DIF_OPER_IN_NODIF_OUT_CRC:
+		hw_dif_info->dif_oper = EFCT_HW_SGE_DIFOP_INNODIFOUTCRC;
+		hw_dif_info->dif = SLI4_DIF_INSERT;
+		break;
+	case EFCT_SCSI_DIF_OPER_IN_CRC_OUT_NODIF:
+		hw_dif_info->dif_oper = EFCT_HW_SGE_DIFOP_INCRCOUTNODIF;
+		hw_dif_info->dif = SLI4_DIF_STRIP;
+		break;
+	case EFCT_SCSI_DIF_OPER_IN_NODIF_OUT_CHKSUM:
+		hw_dif_info->dif_oper =
+				EFCT_HW_SGE_DIFOP_INNODIFOUTCHKSUM;
+		hw_dif_info->dif = SLI4_DIF_INSERT;
+		break;
+	case EFCT_SCSI_DIF_OPER_IN_CHKSUM_OUT_NODIF:
+		hw_dif_info->dif_oper = EFCT_HW_SGE_DIFOP_INCHKSUMOUTNODIF;
+		hw_dif_info->dif = SLI4_DIF_STRIP;
+		break;
+	case EFCT_SCSI_DIF_OPER_IN_CRC_OUT_CRC:
+		hw_dif_info->dif_oper = EFCT_HW_SGE_DIFOP_INCRCOUTCRC;
+		hw_dif_info->dif = SLI4_DIF_PASS_THROUGH;
+		break;
+	case EFCT_SCSI_DIF_OPER_IN_CHKSUM_OUT_CHKSUM:
+		hw_dif_info->dif_oper =
+			EFCT_HW_SGE_DIFOP_INCHKSUMOUTCHKSUM;
+		hw_dif_info->dif = SLI4_DIF_PASS_THROUGH;
+		break;
+	case EFCT_SCSI_DIF_OPER_IN_CRC_OUT_CHKSUM:
+		hw_dif_info->dif_oper = EFCT_HW_SGE_DIFOP_INCRCOUTCHKSUM;
+		hw_dif_info->dif = SLI4_DIF_PASS_THROUGH;
+		break;
+	case EFCT_SCSI_DIF_OPER_IN_CHKSUM_OUT_CRC:
+		hw_dif_info->dif_oper = EFCT_HW_SGE_DIFOP_INCHKSUMOUTCRC;
+		hw_dif_info->dif = SLI4_DIF_PASS_THROUGH;
+		break;
+	case EFCT_SCSI_DIF_OPER_IN_RAW_OUT_RAW:
+		hw_dif_info->dif_oper = EFCT_HW_SGE_DIFOP_INRAWOUTRAW;
+		hw_dif_info->dif = SLI4_DIF_PASS_THROUGH;
+		break;
+	default:
+		efc_log_test(efct, "unhandled SCSI DIF operation %d\n",
+			      scsi_dif_info->dif_oper);
+		return -1;
+	}
+
+	switch (scsi_dif_info->blk_size) {
+	case EFCT_SCSI_DIF_BK_SIZE_512:
+		hw_dif_info->blk_size = EFCT_HW_DIF_BK_SIZE_512;
+		break;
+	case EFCT_SCSI_DIF_BK_SIZE_1024:
+		hw_dif_info->blk_size = EFCT_HW_DIF_BK_SIZE_1024;
+		break;
+	case EFCT_SCSI_DIF_BK_SIZE_2048:
+		hw_dif_info->blk_size = EFCT_HW_DIF_BK_SIZE_2048;
+		break;
+	case EFCT_SCSI_DIF_BK_SIZE_4096:
+		hw_dif_info->blk_size = EFCT_HW_DIF_BK_SIZE_4096;
+		break;
+	case EFCT_SCSI_DIF_BK_SIZE_520:
+		hw_dif_info->blk_size = EFCT_HW_DIF_BK_SIZE_520;
+		break;
+	case EFCT_SCSI_DIF_BK_SIZE_4104:
+		hw_dif_info->blk_size = EFCT_HW_DIF_BK_SIZE_4104;
+		break;
+	default:
+		efc_log_test(efct, "unhandled SCSI DIF block size %d\n",
+			      scsi_dif_info->blk_size);
+		return -1;
+	}
+
+	/* If the operation is an INSERT the tags provided are the
+	 * ones that should be inserted, otherwise they're the ones
+	 * to be checked against.
+	 */
+	if (hw_dif_info->dif == SLI4_DIF_INSERT) {
+		hw_dif_info->ref_tag_repl = scsi_dif_info->ref_tag;
+		hw_dif_info->app_tag_repl = scsi_dif_info->app_tag;
+	} else {
+		hw_dif_info->ref_tag_cmp = scsi_dif_info->ref_tag;
+		hw_dif_info->app_tag_cmp = scsi_dif_info->app_tag;
+	}
+
+	hw_dif_info->check_ref_tag = scsi_dif_info->check_ref_tag;
+	hw_dif_info->check_app_tag = scsi_dif_info->check_app_tag;
+	hw_dif_info->check_guard = scsi_dif_info->check_guard;
+	hw_dif_info->auto_incr_ref_tag = true;
+	hw_dif_info->dif_separate = scsi_dif_info->dif_separate;
+	hw_dif_info->disable_app_ffff = scsi_dif_info->disable_app_ffff;
+	hw_dif_info->disable_app_ref_ffff =
+			scsi_dif_info->disable_app_ref_ffff;
+
+	efct_hw_get(&efct->hw, EFCT_HW_DIF_SEED, &dif_seed);
+	hw_dif_info->dif_seed = dif_seed;
+
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief This function logs the SGLs for an IO.
+ *
+ * @param io Pointer to the IO context.
+ */
+static void efc_log_sgl(struct efct_io_s *io)
+{
+	struct efct_hw_io_s *hio = io->hio;
+	struct sli4_sge_s *data = NULL;
+	u32 *dword = NULL;
+	u32 i;
+	u32 n_sge;
+
+	scsi_io_trace(io, "def_sgl at 0x%x 0x%08x\n",
+		      upper_32_bits(hio->def_sgl.phys),
+		      lower_32_bits(hio->def_sgl.phys));
+	n_sge = (hio->sgl == &hio->def_sgl ?
+			hio->n_sge : hio->def_sgl_count);
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
+	if (hio->ovfl_sgl &&
+	    hio->sgl == hio->ovfl_sgl) {
+		scsi_io_trace(io, "Overflow at 0x%x 0x%08x\n",
+			      upper_32_bits(hio->ovfl_sgl->phys),
+			      lower_32_bits(hio->ovfl_sgl->phys));
+		for (i = 0, data = hio->ovfl_sgl->virt; i < hio->n_sge;
+			i++, data++) {
+			dword = (u32 *)data;
+
+			scsi_io_trace(io,
+				      "SGL %2d 0x%08x 0x%08x 0x%08x 0x%08x\n",
+				i, dword[0], dword[1], dword[2], dword[3]);
+			if (dword[2] & (1U << 31))
+				break;
+		}
+	}
+}
+
+/* @brief Check pending error asynchronous callback function.
+ *
+ * @par Description
+ * Invoke the HW callback function for a given IO. This
+ * function is called from the NOP mailbox completion context.
+ *
+ * @param hw Pointer to HW object.
+ * @param status Completion status.
+ * @param mqe Mailbox completion queue entry.
+ * @param arg General purpose argument.
+ *
+ * @return Returns 0.
+ */
+static int
+efct_scsi_check_pending_async_cb(struct efct_hw_s *hw, int status,
+				 u8 *mqe, void *arg)
+{
+	struct efct_io_s *io = arg;
+
+	if (io) {
+		if (io->hw_cb) {
+			efct_hw_done_t cb = io->hw_cb;
+
+			io->hw_cb = NULL;
+			(cb)(io->hio, NULL, 0,
+			 SLI4_FC_WCQE_STATUS_DISPATCH_ERROR, 0, io);
+		}
+	}
+	return 0;
+}
+
+/**
+ * @brief Check for pending IOs to dispatch.
+ *
+ * @par Description
+ * If there are IOs on the pending list, and a HW IO is available, then
+ * dispatch the IOs.
+ *
+ * @param efct Pointer to the EFCT structure.
+ *
+ * @return None.
+ */
+
+void
+efct_scsi_check_pending(struct efct_s *efct)
+{
+	struct efct_xport_s *xport = efct->xport;
+	struct efct_io_s *io = NULL;
+	struct efct_hw_io_s *hio;
+	int status;
+	int count = 0;
+	int dispatch;
+	unsigned long flags = 0;
+
+	/* Guard against recursion */
+	if (atomic_add_return(1, &xport->io_pending_recursing)) {
+		/* This function is already running.  Decrement and return. */
+		atomic_sub_return(1, &xport->io_pending_recursing);
+		return;
+	}
+
+	do {
+		spin_lock_irqsave(&xport->io_pending_lock, flags);
+		status = 0;
+		hio = NULL;
+		if (!list_empty(&xport->io_pending_list)) {
+			io = list_first_entry(&xport->io_pending_list,
+					      struct efct_io_s,
+					      io_pending_link);
+		}
+		if (io) {
+			list_del(&io->io_pending_link);
+			if (io->io_type == EFCT_IO_TYPE_ABORT) {
+				hio = NULL;
+			} else {
+				hio = efct_hw_io_alloc(&efct->hw);
+				if (!hio) {
+					/*
+					 * No HW IO available.Put IO back on
+					 * the front of pending list
+					 */
+					list_add(&xport->io_pending_list,
+						 &io->io_pending_link);
+					io = NULL;
+				} else {
+					hio->eq = io->hw_priv;
+				}
+			}
+		}
+		/* Must drop the lock before dispatching the IO */
+		spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+
+		if (io) {
+			count++;
+
+			/*
+			 * We pulled an IO off the pending list,
+			 * and either got an HW IO or don't need one
+			 */
+			atomic_sub_return(1, &xport->io_pending_count);
+			if (!hio)
+				status = efct_scsi_io_dispatch_no_hw_io(io);
+			else
+				status = efct_scsi_io_dispatch_hw_io(io, hio);
+			if (status) {
+				/*
+				 * Invoke the HW callback, but do so in the
+				 * separate execution context,provided by the
+				 * NOP mailbox completion processing context
+				 * by using efct_hw_async_call()
+				 */
+				if (efct_hw_async_call(&efct->hw,
+					       efct_scsi_check_pending_async_cb,
+					io)) {
+					efc_log_test(efct,
+						      "call hw async failed\n");
+				}
+			}
+		}
+	} while (io);
+
+	/*
+	 * If nothing was removed from the list,
+	 * we might be in a case where we need to abort an
+	 * active IO and the abort is on the pending list.
+	 * Look for an abort we can dispatch.
+	 */
+	if (count == 0) {
+		dispatch = 0;
+
+		spin_lock_irqsave(&xport->io_pending_lock, flags);
+		list_for_each_entry(io, &xport->io_pending_list,
+				    io_pending_link) {
+			if (io->io_type == EFCT_IO_TYPE_ABORT) {
+				if (io->io_to_abort->hio) {
+					/* This IO has a HW IO, so it is
+					 * active.  Dispatch the abort.
+					 */
+					dispatch = 1;
+				} else {
+					/* Leave this abort on the pending
+					 * list and keep looking
+					 */
+					dispatch = 0;
+				}
+			}
+			if (dispatch) {
+				list_del(&io->io_pending_link);
+				atomic_sub_return(1, &xport->io_pending_count);
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+
+		if (dispatch) {
+			status = efct_scsi_io_dispatch_no_hw_io(io);
+			if (status) {
+				if (efct_hw_async_call(&efct->hw,
+					       efct_scsi_check_pending_async_cb,
+					io)) {
+					efc_log_test(efct,
+						      "call to hw async failed\n");
+				}
+			}
+		}
+	}
+
+	atomic_sub_return(1, &xport->io_pending_recursing);
+}
+
+/**
+ * @brief Attempt to dispatch a non-abort IO
+ *
+ * @par Description
+ * An IO is dispatched:
+ * - if the pending list is not empty, add IO to pending list
+ *   and call a function to process the pending list.
+ * - if pending list is empty, try to allocate a HW IO. If none
+ *   is available, place this IO at the tail of the pending IO
+ *   list.
+ * - if HW IO is available, attach this IO to the HW IO and
+ *   submit it.
+ *
+ * @param io Pointer to IO structure.
+ * @param cb Callback function.
+ *
+ * @return Returns 0 on success, a negative error code value on failure.
+ */
+
+int
+efct_scsi_io_dispatch(struct efct_io_s *io, void *cb)
+{
+	struct efct_hw_io_s *hio;
+	struct efct_s *efct = io->efct;
+	struct efct_xport_s *xport = efct->xport;
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
+		if (!list_empty(&xport->io_pending_list)) {
+			/*
+			 * If this is a low latency request,
+			 * the put at the front of the IO pending
+			 * queue, otherwise put it at the end of the queue.
+			 */
+			if (io->low_latency) {
+				INIT_LIST_HEAD(&io->io_pending_link);
+				list_add(&xport->io_pending_list,
+					 &io->io_pending_link);
+			} else {
+				INIT_LIST_HEAD(&io->io_pending_link);
+				list_add_tail(&io->io_pending_link,
+					      &xport->io_pending_list);
+			}
+			spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+			atomic_add_return(1, &xport->io_pending_count);
+			atomic_add_return(1, &xport->io_total_pending);
+
+			/* process pending list */
+			efct_scsi_check_pending(efct);
+			return 0;
+		}
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
+		return 0;
+	}
+
+	/* We successfully allocated a HW IO; dispatch to HW */
+	return efct_scsi_io_dispatch_hw_io(io, hio);
+}
+
+/**
+ * @brief Attempt to dispatch an Abort IO.
+ *
+ * @par Description
+ * An Abort IO is dispatched:
+ * - if the pending list is not empty, add IO to pending list
+ *   and call a function to process the pending list.
+ * - if pending list is empty, send abort to the HW.
+ *
+ * @param io Pointer to IO structure.
+ * @param cb Callback function.
+ *
+ * @return Returns 0 on success, a negative error code value on failure.
+ */
+
+int
+efct_scsi_io_dispatch_abort(struct efct_io_s *io, void *cb)
+{
+	struct efct_s *efct = io->efct;
+	struct efct_xport_s *xport = efct->xport;
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
+		if (!list_empty(&xport->io_pending_list)) {
+			INIT_LIST_HEAD(&io->io_pending_link);
+			list_add_tail(&io->io_pending_link,
+				      &xport->io_pending_list);
+			spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+			atomic_add_return(1, &xport->io_pending_count);
+			atomic_add_return(1, &xport->io_total_pending);
+
+			/* process pending list */
+			efct_scsi_check_pending(efct);
+			return 0;
+		}
+	spin_unlock_irqrestore(&xport->io_pending_lock, flags);
+
+	/* nothing on pending list, dispatch abort */
+	return efct_scsi_io_dispatch_no_hw_io(io);
+}
+
+/**
+ * @brief Dispatch IO
+ *
+ * @par Description
+ * An IO and its associated HW IO is dispatched to the HW.
+ *
+ * @param io Pointer to IO structure.
+ * @param hio Pointer to HW IO structure from which IO will be
+ * dispatched.
+ *
+ * @return Returns 0 on success, a negative error code value on failure.
+ */
+
+static int
+efct_scsi_io_dispatch_hw_io(struct efct_io_s *io, struct efct_hw_io_s *hio)
+{
+	int rc = 0;
+	struct efct_s *efct = io->efct;
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
+	case EFCT_IO_TYPE_IO: {
+		u32 max_sgl;
+		u32 total_count;
+		u32 host_allocated;
+
+		efct_hw_get(&efct->hw, EFCT_HW_N_SGL, &max_sgl);
+		efct_hw_get(&efct->hw, EFCT_HW_SGL_CHAINING_HOST_ALLOCATED,
+			    &host_allocated);
+
+		/*
+		 * If the requested SGL is larger than the default size,
+		 * then we can allocate an overflow SGL.
+		 */
+		total_count = efct_scsi_count_sgls(&io->hw_dif,
+						   io->sgl, io->sgl_count);
+
+		/*
+		 * Lancer requires us to allocate the chained memory area
+		 */
+		if (host_allocated && total_count > max_sgl) {
+			/* Compute count needed, the number
+			 * extra plus 1 for the link sge
+			 */
+			u32 count = total_count - max_sgl + 1;
+
+			io->ovfl_sgl.size = count * sizeof(struct sli4_sge_s);
+			io->ovfl_sgl.virt =
+				dma_alloc_coherent(&efct->pcidev->dev,
+						   io->ovfl_sgl.size,
+						&io->ovfl_sgl.phys, GFP_DMA);
+			if (!io->ovfl_sgl.virt) {
+				efc_log_err(efct,
+					     "dma alloc overflow sgl failed\n");
+				break;
+			}
+			rc = efct_hw_io_register_sgl(&efct->hw,
+						     io->hio, &io->ovfl_sgl,
+						     count);
+			if (rc) {
+				efct_scsi_io_free_ovfl(io);
+				efc_log_err(efct,
+					     "efct_hw_io_register_sgl() failed\n");
+				break;
+			}
+			/* EVT: update chained_io_count */
+			io->node->chained_io_count++;
+		}
+
+		rc = efct_scsi_build_sgls(&efct->hw, io->hio, &io->hw_dif,
+					  io->sgl, io->sgl_count, io->hio_type);
+		if (rc) {
+			efct_scsi_io_free_ovfl(io);
+			break;
+		}
+
+		if (EFCT_LOG_ENABLE_SCSI_TRACE(efct))
+			efc_log_sgl(io);
+
+		if (io->app_id)
+			io->iparam.fcp_tgt.app_id = io->app_id;
+
+		rc = efct_hw_io_send(&io->efct->hw, io->hio_type, io->hio,
+				     io->wire_len, &io->iparam,
+				     &io->node->rnode, io->hw_cb, io);
+		break;
+	}
+	case EFCT_IO_TYPE_ELS:
+	case EFCT_IO_TYPE_CT: {
+		rc = efct_hw_srrs_send(&efct->hw, io->hio_type, io->hio,
+				       &io->els_req, io->wire_len,
+			&io->els_rsp, &io->node->rnode, &io->iparam,
+			io->hw_cb, io);
+		break;
+	}
+	case EFCT_IO_TYPE_CT_RESP: {
+		rc = efct_hw_srrs_send(&efct->hw, io->hio_type, io->hio,
+				       &io->els_rsp, io->wire_len,
+			NULL, &io->node->rnode, &io->iparam,
+			io->hw_cb, io);
+		break;
+	}
+	case EFCT_IO_TYPE_BLS_RESP: {
+		/* no need to update tgt_task_tag for BLS response since
+		 * the RX_ID will be specified by the payload, not the XRI
+		 */
+		rc = efct_hw_srrs_send(&efct->hw, io->hio_type, io->hio,
+				       NULL, 0, NULL, &io->node->rnode,
+			&io->iparam, io->hw_cb, io);
+		break;
+	}
+	default:
+		scsi_io_printf(io, "Unknown IO type=%d\n", io->io_type);
+		rc = -1;
+		break;
+	}
+	return rc;
+}
+
+/**
+ * @brief Dispatch IO
+ *
+ * @par Description
+ * An IO that does require a HW IO is dispatched to the HW.
+ *
+ * @param io Pointer to IO structure.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+static int
+efct_scsi_io_dispatch_no_hw_io(struct efct_io_s *io)
+{
+	int rc;
+
+	switch (io->io_type) {
+	case EFCT_IO_TYPE_ABORT: {
+		struct efct_hw_io_s *hio_to_abort = NULL;
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
+			((efct_hw_done_t)io->hw_cb)(io->hio, NULL, 0,
+					SLI4_FC_WCQE_STATUS_SUCCESS, 0, io);
+			rc = 0;
+		} else {
+			/* HW IO is valid, abort it */
+			scsi_io_printf(io, "aborting\n");
+			rc = efct_hw_io_abort(&io->efct->hw, hio_to_abort,
+					      io->send_abts, io->hw_cb, io);
+			if (rc) {
+				int status = SLI4_FC_WCQE_STATUS_SUCCESS;
+
+				if (rc != EFCT_HW_RTN_IO_NOT_ACTIVE &&
+				    rc != EFCT_HW_RTN_IO_ABORT_IN_PROGRESS) {
+					status = -1;
+					scsi_io_printf(io,
+						       "Failed to abort IO: status=%d\n",
+						rc);
+				}
+				((efct_hw_done_t)io->hw_cb)(io->hio,
+						NULL, 0, status, 0, io);
+				rc = 0;
+			}
+		}
+
+		break;
+	}
+	default:
+		scsi_io_printf(io, "Unknown IO type=%d\n", io->io_type);
+		rc = -1;
+		break;
+	}
+	return rc;
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Send read/write data.
+ *
+ * @par Description
+ * This call is made by a target-server to initiate a SCSI read
+ * or write data phase, transferring data between the target to
+ * the remote initiator. The payload is specified by the scatter-gather
+ * list @c sgl of length @c sgl_count.
+ * The @c wire_len argument specifies the payload length (independent
+ * of the scatter-gather list cumulative length).
+ * @n @n
+ * The @c flags argument has one bit, EFCT_SCSI_LAST_DATAPHASE, which is
+ * a hint to the base driver that it may use auto SCSI response features
+ * if the hardware supports it.
+ * @n @n
+ * Upon completion, the callback function @b cb is called with flags
+ * indicating that the IO has completed (EFCT_SCSI_IO_COMPL) and another
+ * data phase or response may be sent; that the IO has completed and no
+ * response needs to be sent (EFCT_SCSI_IO_COMPL_NO_RSP); or that the IO
+ * was aborted (EFCT_SCSI_IO_ABORTED).
+ *
+ * @param io Pointer to the IO context.
+ * @param flags Flags controlling the sending of data.
+ * @param dif_info Pointer to T10 DIF fields, or NULL if no DIF.
+ * @param sgl Pointer to the payload scatter-gather list.
+ * @param sgl_count Count of the scatter-gather list elements.
+ * @param xwire_len Length of the payload on wire, in bytes.
+ * @param type HW IO type.
+ * @param enable_ar Enable auto-response if true.
+ * @param cb Completion callback.
+ * @param arg Application-supplied callback data.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+static inline int
+efct_scsi_xfer_data(struct efct_io_s *io, u32 flags,
+		    struct efct_scsi_dif_info_s *dif_info,
+	struct efct_scsi_sgl_s *sgl, u32 sgl_count, u64 xwire_len,
+	enum efct_hw_io_type_e type, int enable_ar,
+	efct_scsi_io_cb_t cb, void *arg)
+{
+	int rc;
+	struct efct_s *efct;
+	size_t residual = 0;
+
+	if (dif_info &&
+	    dif_info->dif_oper == EFCT_SCSI_DIF_OPER_DISABLED)
+		dif_info = NULL;
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
+	rc = efct_scsi_convert_dif_info(efct, dif_info, &io->hw_dif);
+	if (rc)
+		return rc;
+
+	/* If DIF is used, then save lba for error recovery */
+	if (dif_info)
+		io->scsi_dif_info = *dif_info;
+
+	residual = io->exp_xfer_len - io->transferred;
+	io->wire_len = (xwire_len < residual) ? xwire_len : residual;
+	residual = (xwire_len - io->wire_len);
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.fcp_tgt.ox_id = io->init_task_tag;
+	io->iparam.fcp_tgt.offset = io->transferred;
+	io->iparam.fcp_tgt.dif_oper = io->hw_dif.dif;
+	io->iparam.fcp_tgt.blk_size = io->hw_dif.blk_size;
+	io->iparam.fcp_tgt.cs_ctl = io->cs_ctl;
+	io->iparam.fcp_tgt.timeout = io->timeout;
+
+	/* if this is the last data phase and there is no residual, enable
+	 * auto-good-response
+	 */
+	if (enable_ar && (flags & EFCT_SCSI_LAST_DATAPHASE) &&
+	    residual == 0 &&
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
+		struct efct_scsi_sgl_s  *sgl_ptr = &io->sgl[sgl_count - 1];
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
+		struct efct_xport_s *xport = efct->xport;
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
+efct_scsi_send_rd_data(struct efct_io_s *io, u32 flags,
+		       struct efct_scsi_dif_info_s *dif_info,
+	struct efct_scsi_sgl_s *sgl, u32 sgl_count, u64 len,
+	efct_scsi_io_cb_t cb, void *arg)
+{
+	return efct_scsi_xfer_data(io, flags, dif_info, sgl, sgl_count,
+				 len, EFCT_HW_IO_TARGET_READ,
+				 enable_tsend_auto_resp(io->efct), cb, arg);
+}
+
+int
+efct_scsi_recv_wr_data(struct efct_io_s *io, u32 flags,
+		       struct efct_scsi_dif_info_s *dif_info,
+	struct efct_scsi_sgl_s *sgl, u32 sgl_count, u64 len,
+	efct_scsi_io_cb_t cb, void *arg)
+{
+	return efct_scsi_xfer_data(io, flags, dif_info, sgl, sgl_count, len,
+				 EFCT_HW_IO_TARGET_WRITE,
+				 enable_treceive_auto_resp(io->efct), cb, arg);
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Free overflow SGL.
+ *
+ * @par Description
+ * Free the overflow SGL if it is present.
+ *
+ * @param io Pointer to IO object.
+ *
+ * @return None.
+ */
+static void
+efct_scsi_io_free_ovfl(struct efct_io_s *io)
+{
+	if (io->ovfl_sgl.size) {
+		dma_free_coherent(&io->efct->pcidev->dev,
+				  io->ovfl_sgl.size, io->ovfl_sgl.virt,
+				  io->ovfl_sgl.phys);
+		memset(&io->ovfl_sgl, 0, sizeof(struct efc_dma_s));
+	}
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Send response data.
+ *
+ * @par Description
+ * This function is used by a target-server to send the SCSI response
+ * data to a remote initiator node. The target-server populates the
+ * @c struct efct_scsi_cmd_resp_s argument with scsi status, status qualifier,
+ * sense data, and response data, as needed.
+ * @n @n
+ * Upon completion, the callback function @c cb is invoked. The
+ * target-server will generally clean up its IO context resources and
+ * call efct_scsi_io_complete().
+ *
+ * @param io Pointer to the IO context.
+ * @param flags Flags to control sending of the SCSI response.
+ * @param rsp Pointer to the response data populated by the caller.
+ * @param cb Completion callback.
+ * @param arg Application-specified completion callback argument.
+
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_scsi_send_resp(struct efct_io_s *io, u32 flags,
+		    struct efct_scsi_cmd_resp_s *rsp,
+		   efct_scsi_io_cb_t cb, void *arg)
+{
+	struct efct_s *efct;
+	int residual;
+	bool auto_resp = true;		/* Always try auto resp */
+	u8 scsi_status = 0;
+	u16 scsi_status_qualifier = 0;
+	u8 *sense_data = NULL;
+	u32 sense_data_length = 0;
+
+	efct = io->efct;
+
+	efct_scsi_convert_dif_info(efct, NULL, &io->hw_dif);
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
+		u8 *sns_data = io->rspbuf.virt + sizeof(*fcprsp);
+
+		if (!fcprsp) {
+			efc_log_err(efct, "NULL response buffer\n");
+			return -1;
+		}
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
+				return -1;
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
+/**
+ * @ingroup scsi_api_base
+ * @brief Send TMF response data.
+ *
+ * @par Description
+ * This function is used by a target-server to send SCSI TMF response\
+ * data to a remote initiator node.
+ * Upon completion, the callback function @c cb is invoked.
+ * The target-server will generally
+ * clean up its IO context resources and call efct_scsi_io_complete().
+ *
+ * @param io Pointer to the IO context.
+ * @param rspcode TMF response code.
+ * @param addl_rsp_info Additional TMF response information
+ *		(may be NULL for zero data).
+ * @param cb Completion callback.
+ * @param arg Application-specified completion callback argument.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_scsi_send_tmf_resp(struct efct_io_s *io,
+			enum efct_scsi_tmf_resp_e rspcode,
+			u8 addl_rsp_info[3],
+			efct_scsi_io_cb_t cb, void *arg)
+{
+	int rc = -1;
+	struct efct_s *efct = NULL;
+	struct fcp_resp_with_ext *fcprsp = NULL;
+	struct fcp_resp_rsp_info *rspinfo = NULL;
+	u8 fcp_rspcode;
+
+	efct = io->efct;
+
+	io->wire_len = 0;
+	efct_scsi_convert_dif_info(efct, NULL, &io->hw_dif);
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
+	fcprsp->resp.fr_flags |= FCP_SNS_LEN_VAL;
+
+	rspinfo = io->rspbuf.virt + sizeof(*fcprsp);
+	if (addl_rsp_info) {
+		memcpy(rspinfo->_fr_resvd, addl_rsp_info,
+		       sizeof(rspinfo->_fr_resvd));
+	}
+	rspinfo->rsp_code = fcp_rspcode;
+
+	io->wire_len = sizeof(*fcprsp) + sizeof(*rspinfo);
+
+	fcprsp->ext.fr_rsp_len = cpu_to_be32(sizeof(*rspinfo));
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
+/**
+ * @brief Process target abort callback.
+ *
+ * @par Description
+ * Accepts HW abort requests.
+ *
+ * @param hio HW IO context.
+ * @param rnode Remote node.
+ * @param length Length of response data.
+ * @param status Completion status.
+ * @param ext_status Extended completion status.
+ * @param app Application-specified callback data.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+static int
+efct_target_abort_cb(struct efct_hw_io_s *hio,
+		     struct efc_remote_node_s *rnode,
+		     u32 length, int status,
+		     u32 ext_status, void *app)
+{
+	struct efct_io_s *io = app;
+	struct efct_s *efct;
+	enum efct_scsi_io_status_e scsi_status;
+
+	efct = io->efct;
+
+	if (io->abort_cb) {
+		efct_scsi_io_cb_t abort_cb = io->abort_cb;
+		void *abort_cb_arg = io->abort_cb_arg;
+
+		io->abort_cb = NULL;
+		io->abort_cb_arg = NULL;
+
+		switch (status) {
+		case SLI4_FC_WCQE_STATUS_SUCCESS:
+			scsi_status = EFCT_SCSI_STATUS_GOOD;
+			break;
+		case SLI4_FC_WCQE_STATUS_LOCAL_REJECT:
+			switch (ext_status) {
+			case SLI4_FC_LOCAL_REJECT_NO_XRI:
+				scsi_status = EFCT_SCSI_STATUS_NO_IO;
+				break;
+			case SLI4_FC_LOCAL_REJECT_ABORT_IN_PROGRESS:
+				scsi_status =
+					EFCT_SCSI_STATUS_ABORT_IN_PROGRESS;
+				break;
+			default:
+				/*we have seen 0x15 (abort in progress)*/
+				scsi_status = EFCT_SCSI_STATUS_ERROR;
+				break;
+			}
+			break;
+		case SLI4_FC_WCQE_STATUS_FCP_RSP_FAILURE:
+			scsi_status = EFCT_SCSI_STATUS_CHECK_RESPONSE;
+			break;
+		default:
+			scsi_status = EFCT_SCSI_STATUS_ERROR;
+			break;
+		}
+		/* invoke callback */
+		abort_cb(io->io_to_abort, scsi_status, 0, abort_cb_arg);
+	}
+
+	/* done with IO to abort,efct_ref_get(): efct_scsi_tgt_abort_io() */
+	kref_put(&io->io_to_abort->ref, io->io_to_abort->release);
+
+	efct_io_pool_io_free(efct->xport->io_pool, io);
+
+	efct_scsi_check_pending(efct);
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Abort a target IO.
+ *
+ * @par Description
+ * This routine is called from a SCSI target-server. It initiates an
+ * abort of a previously-issued target data phase or response request.
+ *
+ * @param io IO context.
+ * @param cb SCSI target server callback.
+ * @param arg SCSI target server supplied callback argument.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+efct_scsi_tgt_abort_io(struct efct_io_s *io, efct_scsi_io_cb_t cb, void *arg)
+{
+	struct efct_s *efct;
+	struct efct_xport_s *xport;
+	int rc;
+	struct efct_io_s *abort_io = NULL;
+
+	efct = io->efct;
+	xport = efct->xport;
+
+	/* take a reference on IO being aborted */
+	if ((kref_get_unless_zero(&io->ref) == 0)) {
+		/* command no longer active */
+		scsi_io_printf(io, "command no longer active\n");
+		return -1;
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
+		return -1;
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
+/**
+ * @brief Process target BLS response callback.
+ *
+ * @par Description
+ * Accepts HW abort requests.
+ *
+ * @param hio HW IO context.
+ * @param rnode Remote node.
+ * @param length Length of response data.
+ * @param status Completion status.
+ * @param ext_status Extended completion status.
+ * @param app Application-specified callback data.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+static int
+efct_target_bls_resp_cb(struct efct_hw_io_s *hio,
+			struct efc_remote_node_s *rnode,
+	u32 length, int status, u32 ext_status, void *app)
+{
+	struct efct_io_s *io = app;
+	struct efct_s *efct;
+	enum efct_scsi_io_status_e bls_status;
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
+	return 0;
+}
+
+/**
+ * @brief Complete abort request.
+ *
+ * @par Description
+ * An abort request is completed by posting a BA_ACC for the IO that
+ * requested the abort.
+ *
+ * @param io Pointer to the IO context.
+ * @param cb Callback function to invoke upon completion.
+ * @param arg Application-specified completion callback argument.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+static int
+efct_target_send_bls_resp(struct efct_io_s *io,
+			  efct_scsi_io_cb_t cb, void *arg)
+{
+	int rc;
+	struct fc_ba_acc *acc;
+
+	/* fill out IO structure with everything needed to send BA_ACC */
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.bls.ox_id = io->init_task_tag;
+	io->iparam.bls.rx_id = io->abort_rx_id;
+
+	acc = (void *)io->iparam.bls.payload;
+
+	memset(io->iparam.bls.payload, 0,
+	       sizeof(io->iparam.bls.payload));
+	acc->ba_ox_id = io->iparam.bls.ox_id;
+	acc->ba_rx_id = io->iparam.bls.rx_id;
+	acc->ba_high_seq_cnt = U16_MAX;
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
+	rc = efct_scsi_io_dispatch(io, efct_target_bls_resp_cb);
+	return rc;
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Notify the base driver that the IO is complete.
+ *
+ * @par Description
+ * This function is called by a target-server to notify the base
+ * driver that an IO has completed, allowing for the base driver
+ * to free resources.
+ * @n
+ * @n @b Note: This function is not called by initiator-clients.
+ *
+ * @param io Pointer to IO context.
+ *
+ * @return None.
+ */
+void
+efct_scsi_io_complete(struct efct_io_s *io)
+{
+	if (io->io_free) {
+		efc_log_test(io->efct,
+			      "Got completion for non-busy io with tag 0x%x\n",
+		    io->tag);
+		return;
+	}
+
+	scsi_io_trace(io, "freeing io 0x%p %s\n", io, io->display_name);
+	kref_put(&io->ref, io->release);
+}
+
+/**
+ * @ingroup scsi_api_base
+ * @brief Return SCSI API integer valued property.
+ *
+ * @par Description
+ * This function is called by a target-server or initiator-client to
+ * retrieve an integer valued property.
+ *
+ * @param efct Pointer to the efct.
+ * @param prop Property value to return.
+ *
+ * @return Returns a value, or 0 if invalid property was requested.
+ */
+u32
+efct_scsi_get_property(struct efct_s *efct, enum efct_scsi_property_e prop)
+{
+	struct efct_xport_s *xport = efct->xport;
+	u32	val;
+
+	switch (prop) {
+	case EFCT_SCSI_MAX_SGE:
+		if (efct_hw_get(&efct->hw, EFCT_HW_MAX_SGE, &val) == 0)
+			return val;
+		break;
+	case EFCT_SCSI_MAX_SGL:
+		if (efct_hw_get(&efct->hw, EFCT_HW_N_SGL, &val) == 0)
+			return val;
+		break;
+	case EFCT_SCSI_MAX_IOS:
+		return efct_io_pool_allocated(xport->io_pool);
+	case EFCT_SCSI_DIF_CAPABLE:
+		if (efct_hw_get(&efct->hw,
+				EFCT_HW_DIF_CAPABLE, &val) == 0) {
+			return val;
+		}
+		break;
+	case EFCT_SCSI_MAX_FIRST_BURST:
+		return 0;
+	case EFCT_SCSI_DIF_MULTI_SEPARATE:
+		if (efct_hw_get(&efct->hw,
+				EFCT_HW_DIF_MULTI_SEPARATE, &val) == 0) {
+			return val;
+		}
+		break;
+	case EFCT_SCSI_ENABLE_TASK_SET_FULL:
+		/* Return FALSE if we are send frame capable */
+		if (efct_hw_get(&efct->hw,
+				EFCT_HW_SEND_FRAME_CAPABLE, &val) == 0) {
+			return !val;
+		}
+		break;
+	default:
+		break;
+	}
+
+	efc_log_debug(efct, "invalid property request %d\n", prop);
+	return 0;
+}
+
+/**
+ * @brief Update transferred count
+ *
+ * @par Description
+ * Updates io->transferred, as required when using first burst,
+ * when the amount of first burst data processed differs from the
+ * amount of first burst data received.
+ *
+ * @param io Pointer to the io object.
+ * @param transferred Number of bytes transferred out of first burst buffers.
+ *
+ * @return None.
+ */
+void
+efct_scsi_update_first_burst_transferred(struct efct_io_s *io,
+					 u32 transferred)
+{
+	io->transferred = transferred;
+}
diff --git a/drivers/scsi/elx/efct/efct_scsi.h b/drivers/scsi/elx/efct/efct_scsi.h
new file mode 100644
index 000000000000..f4d0d453c792
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_scsi.h
@@ -0,0 +1,401 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_SCSI_H__)
+#define __EFCT_SCSI_H__
+
+/* efct_scsi_rcv_cmd() efct_scsi_rcv_tmf() flags */
+#define EFCT_SCSI_CMD_DIR_IN		BIT(0)
+#define EFCT_SCSI_CMD_DIR_OUT		BIT(1)
+#define EFCT_SCSI_CMD_SIMPLE		BIT(2)
+#define EFCT_SCSI_CMD_HEAD_OF_QUEUE	BIT(3)
+#define EFCT_SCSI_CMD_ORDERED		BIT(4)
+#define EFCT_SCSI_CMD_UNTAGGED		BIT(5)
+#define EFCT_SCSI_CMD_ACA		BIT(6)
+#define EFCT_SCSI_FIRST_BURST_ERR	BIT(7)
+#define EFCT_SCSI_FIRST_BURST_ABORTED	BIT(8)
+
+/* efct_scsi_send_rd_data/recv_wr_data/send_resp flags */
+#define EFCT_SCSI_LAST_DATAPHASE		BIT(0)
+#define EFCT_SCSI_NO_AUTO_RESPONSE	BIT(1)
+#define EFCT_SCSI_LOW_LATENCY		BIT(2)
+
+#define EFCT_SCSI_SNS_BUF_VALID(sense)	((sense) && \
+			(0x70 == (((const u8 *)(sense))[0] & 0x70)))
+
+#define EFCT_SCSI_WQ_STEERING_SHIFT	(16)
+#define EFCT_SCSI_WQ_STEERING_MASK	(0xf << EFCT_SCSI_WQ_STEERING_SHIFT)
+#define EFCT_SCSI_WQ_STEERING_CLASS	(0 << EFCT_SCSI_WQ_STEERING_SHIFT)
+#define EFCT_SCSI_WQ_STEERING_REQUEST	BIT(EFCT_SCSI_WQ_STEERING_SHIFT)
+#define EFCT_SCSI_WQ_STEERING_CPU	(2 << EFCT_SCSI_WQ_STEERING_SHIFT)
+
+#define EFCT_SCSI_WQ_CLASS_SHIFT		(20)
+#define EFCT_SCSI_WQ_CLASS_MASK		(0xf << EFCT_SCSI_WQ_CLASS_SHIFT)
+#define EFCT_SCSI_WQ_CLASS(x)		((x & EFCT_SCSI_WQ_CLASS_MASK) << \
+						EFCT_SCSI_WQ_CLASS_SHIFT)
+
+#define EFCT_SCSI_WQ_CLASS_LOW_LATENCY	(1)
+
+/*!
+ * @defgroup scsi_api_base SCSI Base Target/Initiator
+ * @defgroup scsi_api_target SCSI Target
+ * @defgroup scsi_api_initiator SCSI Initiator
+ */
+
+/**
+ * @brief SCSI command response.
+ *
+ * This structure is used by target-servers to specify SCSI status and
+ * sense data.  In this case all but the @b residual element are used. For
+ * initiator-clients, this structure is used by the SCSI API to convey the
+ * response data for issued commands, including the residual element.
+ */
+struct efct_scsi_cmd_resp_s {
+	u8 scsi_status;			/**< SCSI status */
+	u16 scsi_status_qualifier;		/**< SCSI status qualifier */
+	/**< pointer to response data buffer */
+	u8 *response_data;
+	/**< length of response data buffer (bytes) */
+	u32 response_data_length;
+	u8 *sense_data;		/**< pointer to sense data buffer */
+	/**< length of sense data buffer (bytes) */
+	u32 sense_data_length;
+	/* command residual (not used for target), positive value
+	 * indicates an underflow, negative value indicates overflow
+	 */
+	int residual;
+	/**< Command response length received in wcqe */
+	u32 response_wire_length;
+};
+
+struct efct_vport_s {
+	struct efct_s *efct;
+	bool is_vport;
+	struct fc_host_statistics fc_host_stats;
+	struct Scsi_Host *shost;
+	struct fc_vport *fc_vport;
+	u64 npiv_wwpn;
+	u64 npiv_wwnn;
+
+};
+
+/* Status values returned by IO callbacks */
+enum efct_scsi_io_status_e {
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
+
+};
+
+struct efct_io_s;
+struct efc_node_s;
+struct efc_domain_s;
+struct efc_sli_port_s;
+
+/* Callback used by send_rd_data(), recv_wr_data(), send_resp() */
+typedef int (*efct_scsi_io_cb_t)(struct efct_io_s *io,
+				    enum efct_scsi_io_status_e status,
+				    u32 flags, void *arg);
+
+/* Callback used by send_rd_io(), send_wr_io() */
+typedef int (*efct_scsi_rsp_io_cb_t)(struct efct_io_s *io,
+			enum efct_scsi_io_status_e status,
+			struct efct_scsi_cmd_resp_s *rsp,
+			u32 flags, void *arg);
+
+/* efct_scsi_cb_t flags */
+#define EFCT_SCSI_IO_CMPL		BIT(0)	/* IO completed */
+/* IO completed, response sent */
+#define EFCT_SCSI_IO_CMPL_RSP_SENT	BIT(1)
+#define EFCT_SCSI_IO_ABORTED		BIT(2)	/* IO was aborted */
+
+/* efct_scsi_recv_tmf() request values */
+enum efct_scsi_tmf_cmd_e {
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
+enum efct_scsi_tmf_resp_e {
+	EFCT_SCSI_TMF_FUNCTION_COMPLETE = 1,
+	EFCT_SCSI_TMF_FUNCTION_SUCCEEDED,
+	EFCT_SCSI_TMF_FUNCTION_IO_NOT_FOUND,
+	EFCT_SCSI_TMF_FUNCTION_REJECTED,
+	EFCT_SCSI_TMF_INCORRECT_LOGICAL_UNIT_NUMBER,
+	EFCT_SCSI_TMF_SERVICE_DELIVERY,
+};
+
+/**
+ * @brief property names for efct_scsi_get_property() functions
+ */
+
+enum efct_scsi_property_e {
+	EFCT_SCSI_MAX_SGE,
+	EFCT_SCSI_MAX_SGL,
+	EFCT_SCSI_WWNN,
+	EFCT_SCSI_WWPN,
+	EFCT_SCSI_SERIALNUMBER,
+	EFCT_SCSI_PARTNUMBER,
+	EFCT_SCSI_PORTNUM,
+	EFCT_SCSI_BIOS_VERSION_STRING,
+	EFCT_SCSI_MAX_IOS,
+	EFCT_SCSI_DIF_CAPABLE,
+	EFCT_SCSI_DIF_MULTI_SEPARATE,
+	EFCT_SCSI_MAX_FIRST_BURST,
+	EFCT_SCSI_ENABLE_TASK_SET_FULL,
+};
+
+#define DIF_SIZE		8
+
+/**
+ * @brief T10 DIF operations
+ *
+ *	WARNING: do not reorder or insert to this list without making
+ *	appropriate changes in efct_dif.c
+ */
+enum efct_scsi_dif_oper_e {
+	EFCT_SCSI_DIF_OPER_DISABLED,
+	EFCT_SCSI_DIF_OPER_IN_NODIF_OUT_CRC,
+	EFCT_SCSI_DIF_OPER_IN_CRC_OUT_NODIF,
+	EFCT_SCSI_DIF_OPER_IN_NODIF_OUT_CHKSUM,
+	EFCT_SCSI_DIF_OPER_IN_CHKSUM_OUT_NODIF,
+	EFCT_SCSI_DIF_OPER_IN_CRC_OUT_CRC,
+	EFCT_SCSI_DIF_OPER_IN_CHKSUM_OUT_CHKSUM,
+	EFCT_SCSI_DIF_OPER_IN_CRC_OUT_CHKSUM,
+	EFCT_SCSI_DIF_OPER_IN_CHKSUM_OUT_CRC,
+	EFCT_SCSI_DIF_OPER_IN_RAW_OUT_RAW,
+};
+
+#define EFCT_SCSI_DIF_OPER_PASS_THRU	EFCT_SCSI_DIF_OPER_IN_CRC_OUT_CRC
+#define EFCT_SCSI_DIF_OPER_STRIP	EFCT_SCSI_DIF_OPER_IN_CRC_OUT_NODIF
+#define EFCT_SCSI_DIF_OPER_INSERT	EFCT_SCSI_DIF_OPER_IN_NODIF_OUT_CRC
+
+/**
+ * @brief T10 DIF block sizes
+ */
+enum efct_scsi_dif_blk_size_e {
+	EFCT_SCSI_DIF_BK_SIZE_512,
+	EFCT_SCSI_DIF_BK_SIZE_1024,
+	EFCT_SCSI_DIF_BK_SIZE_2048,
+	EFCT_SCSI_DIF_BK_SIZE_4096,
+	EFCT_SCSI_DIF_BK_SIZE_520,
+	EFCT_SCSI_DIF_BK_SIZE_4104
+};
+
+/**
+ * @brief generic scatter-gather list structure
+ */
+
+struct efct_scsi_sgl_s {
+	uintptr_t	addr;		/**< physical address */
+	/**< address of DIF segment, zero if DIF is interleaved */
+	uintptr_t	dif_addr;
+	size_t		len;		/**< length */
+};
+
+/**
+ * @brief T10 DIF information passed to the transport
+ */
+
+struct efct_scsi_dif_info_s {
+	enum efct_scsi_dif_oper_e dif_oper;
+	enum efct_scsi_dif_blk_size_e blk_size;
+	u32 ref_tag;
+	bool check_ref_tag;
+	bool check_app_tag;
+	bool check_guard;
+	bool dif_separate;
+
+	/* If the APP TAG is 0xFFFF, disable checking
+	 * the REF TAG and CRC fields
+	 */
+	bool disable_app_ffff;
+
+	/* if the APP TAG is 0xFFFF and REF TAG is 0xFFFF_FFFF,
+	 * disable checking the received CRC field.
+	 */
+	bool disable_app_ref_ffff;
+	u64 lba;
+	u16 app_tag;
+};
+
+/* Return values for calls from base driver to
+ * target-server/initiator-client
+ */
+#define EFCT_SCSI_CALL_COMPLETE	0 /* All work is done */
+#define EFCT_SCSI_CALL_ASYNC	1 /* Work will be completed asynchronously */
+
+/* Calls from target/initiator to base driver */
+
+enum efct_scsi_io_role_e {
+	EFCT_SCSI_IO_ROLE_ORIGINATOR,
+	EFCT_SCSI_IO_ROLE_RESPONDER,
+};
+
+void efct_scsi_io_alloc_enable(struct efc_lport *efc, struct efc_node_s *node);
+void efct_scsi_io_alloc_disable(struct efc_lport *efc, struct efc_node_s *node);
+extern struct efct_io_s *
+efct_scsi_io_alloc(struct efc_node_s *node, enum efct_scsi_io_role_e);
+void efct_scsi_io_free(struct efct_io_s *io);
+struct efct_io_s *efct_io_get_instance(struct efct_s *efct, u32 index);
+
+/* Calls from base driver to target-server */
+
+int efct_scsi_tgt_driver_init(void);
+int efct_scsi_tgt_driver_exit(void);
+int efct_scsi_tgt_io_init(struct efct_io_s *io);
+int efct_scsi_tgt_io_exit(struct efct_io_s *io);
+int efct_scsi_tgt_new_device(struct efct_s *efct);
+int efct_scsi_tgt_del_device(struct efct_s *efct);
+int
+efct_scsi_tgt_new_domain(struct efc_lport *efc, struct efc_domain_s *domain);
+void
+efct_scsi_tgt_del_domain(struct efc_lport *efc, struct efc_domain_s *domain);
+int
+efct_scsi_tgt_new_sport(struct efc_lport *efc, struct efc_sli_port_s *sport);
+void
+efct_scsi_tgt_del_sport(struct efc_lport *efc, struct efc_sli_port_s *sport);
+int
+efct_scsi_validate_initiator(struct efc_lport *efc, struct efc_node_s *node);
+int
+efct_scsi_new_initiator(struct efc_lport *efc, struct efc_node_s *node);
+
+enum efct_scsi_del_initiator_reason_e {
+	EFCT_SCSI_INITIATOR_DELETED,
+	EFCT_SCSI_INITIATOR_MISSING,
+};
+
+extern int
+efct_scsi_del_initiator(struct efc_lport *efc, struct efc_node_s *node,
+			int reason);
+extern int
+efct_scsi_recv_cmd(struct efct_io_s *io, uint64_t lun, u8 *cdb,
+		   u32 cdb_len, u32 flags);
+extern int
+efct_scsi_recv_cmd_first_burst(struct efct_io_s *io, uint64_t lun,
+			       u8 *cdb, u32 cdb_len, u32 flags,
+	struct efc_dma_s first_burst_buffers[], u32 first_burst_bytes);
+extern int
+efct_scsi_recv_tmf(struct efct_io_s *tmfio, u32 lun,
+		   enum efct_scsi_tmf_cmd_e cmd, struct efct_io_s *abortio,
+		  u32 flags);
+extern struct efc_sli_port_s *
+efct_sport_get_instance(struct efc_domain_s *domain, u32 index);
+extern struct efc_domain_s *
+efct_domain_get_instance(struct efct_s *efct, u32 index);
+
+/* Calls from target-server to base driver */
+
+extern int
+efct_scsi_send_rd_data(struct efct_io_s *io, u32 flags,
+		       struct efct_scsi_dif_info_s *dif_info,
+		      struct efct_scsi_sgl_s *sgl, u32 sgl_count,
+		      u64 wire_len, efct_scsi_io_cb_t cb, void *arg);
+extern int
+efct_scsi_recv_wr_data(struct efct_io_s *io, u32 flags,
+		       struct efct_scsi_dif_info_s *dif_info,
+		      struct efct_scsi_sgl_s *sgl, u32 sgl_count,
+		      u64 wire_len, efct_scsi_io_cb_t cb, void *arg);
+extern int
+efct_scsi_send_resp(struct efct_io_s *io, u32 flags,
+		    struct efct_scsi_cmd_resp_s *rsp, efct_scsi_io_cb_t cb,
+		   void *arg);
+extern int
+efct_scsi_send_tmf_resp(struct efct_io_s *io,
+			enum efct_scsi_tmf_resp_e rspcode,
+		       u8 addl_rsp_info[3],
+		       efct_scsi_io_cb_t cb, void *arg);
+extern int
+efct_scsi_tgt_abort_io(struct efct_io_s *io, efct_scsi_io_cb_t cb, void *arg);
+
+void efct_scsi_io_complete(struct efct_io_s *io);
+
+extern u32
+efct_scsi_get_property(struct efct_s *efct, enum efct_scsi_property_e prop);
+
+//extern void efct_scsi_del_initiator_complete(struct efc_node_s *node);
+
+extern void
+efct_scsi_update_first_burst_transferred(struct efct_io_s *io,
+					 u32 transferred);
+
+/* Calls from base driver to initiator-client */
+
+int efct_scsi_ini_driver_init(void);
+int efct_scsi_ini_driver_exit(void);
+int efct_scsi_reg_fc_transport(void);
+int efct_scsi_release_fc_transport(void);
+int efct_scsi_ini_io_init(struct efct_io_s *io);
+int efct_scsi_ini_io_exit(struct efct_io_s *io);
+int efct_scsi_new_device(struct efct_s *efct);
+int efct_scsi_del_device(struct efct_s *efct);
+int
+efct_scsi_ini_new_domain(struct efc_lport *efc, struct efc_domain_s *domain);
+void
+efct_scsi_ini_del_domain(struct efc_lport *efc, struct efc_domain_s *domain);
+int
+efct_scsi_ini_new_sport(struct efc_lport *efc, struct efc_sli_port_s *sport);
+void
+efct_scsi_ini_del_sport(struct efc_lport *efc, struct efc_sli_port_s *sport);
+int
+efct_scsi_new_target(struct efc_lport *efc, struct efc_node_s *node);
+void _efct_scsi_io_free(struct kref *arg);
+
+enum efct_scsi_del_target_reason_e {
+	EFCT_SCSI_TARGET_DELETED,
+	EFCT_SCSI_TARGET_MISSING,
+};
+
+int efct_scsi_del_target(struct efc_lport *efc,
+			 struct efc_node_s *node, int reason);
+
+int efct_scsi_send_tmf(struct efc_node_s *node,
+		       struct efct_io_s *io,
+		       struct efct_io_s *io_to_abort, u32 lun,
+		       enum efct_scsi_tmf_cmd_e tmf,
+		       struct efct_scsi_sgl_s *sgl,
+		       u32 sgl_count, u32 len,
+		       efct_scsi_rsp_io_cb_t cb, void *arg);
+
+struct efct_scsi_vaddr_len_s {
+	void *vaddr;
+	u32 length;
+};
+
+extern int
+efct_scsi_get_block_vaddr(struct efct_io_s *io, uint64_t blocknumber,
+			  struct efct_scsi_vaddr_len_s addrlen[],
+			  u32 max_addrlen, void **dif_vaddr);
+extern int
+efct_scsi_del_vport(struct efct_s *efct, struct Scsi_Host *shost);
+
+extern struct efct_vport_s *
+efct_scsi_new_vport(struct efct_s *efct, struct device *dev);
+
+/* Calls within base driver */
+int efct_scsi_io_dispatch(struct efct_io_s *io, void *cb);
+int efct_scsi_io_dispatch_abort(struct efct_io_s *io, void *cb);
+void efct_scsi_check_pending(struct efct_s *efct);
+
+#endif /* __EFCT_SCSI_H__ */
-- 
2.13.7

