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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB72ECA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 781C6205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DJfz/mXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436634AbfJWV4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:51 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:53965 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436618AbfJWV4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:50 -0400
Received: by mail-wm1-f52.google.com with SMTP id i13so516450wmd.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Az706PzEP/INEHjQzZ0XripR5q2NTi06E/gKsY65dyM=;
        b=DJfz/mXucPIJ2lnAn931Ytg/2l8zIv7vMNIOaAxaGMhbjLZVYyetrwy/u2ptidl0Ro
         RDthBcg2fNTXQEOb3v0VId7KXoSDhULXybmeoHRz5C3ZX2m/6jghzauaKXOdA4WGAPWa
         TqSQ2hSnIQXCiVSlbn6gDBWCywTEvujwkyZdSFwDPHfUGADORjPXJ67scKbFLtO2Lytx
         tASxARs7F30i9tZ5hIdfZ4oqPYB9/zJ6QtaG6oWZn6AfMw+RRUfJJUPFLjMH3GhCUCX2
         ptXFvGBpw8ljMifxwg3mGs0uumMtHIO/hPFM64Mx0JBaXYTDW/lAjC1EKwsyG/yrcGrH
         wkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Az706PzEP/INEHjQzZ0XripR5q2NTi06E/gKsY65dyM=;
        b=hPUJksHVvGZUevwxMwHgFECmruPHcn91iHWwZ2/QEGGWwdD2xtIUGYrirJ/zHgPS1j
         lWoXoMKwd8DgZiCri2y/WGZvUYFnH3Nqc9ZAOkWxjOiZCc7in9GWDWbtZfcIfvpeKiIK
         19z697IKnHyZpBt0f/0RPvyLe/mdO3bRJcQRZRkuyrMWSpKn7Zb2uFtu1EmxH6cBLtWT
         IWgejH96CIKKm+LSar6baV5MYXEWfe48HBBzLEDdObVQOVEnkBEMBdeMt26LMkOnzPIJ
         l7xx4nfGoFDpP/dT260d6Mzo7/A6Wr92V3ydxnWx9bwLtyoMZf7y2b3hw+cFJHWEMmur
         aQjg==
X-Gm-Message-State: APjAAAXkZPQcYOucVl0g4/5mJ32ku/8XmSz3VEZQl1pJcZXsetawb3o7
        Wx8zhi1qOBrjDUVSlDlh5iG98A5a
X-Google-Smtp-Source: APXvYqx9ewy0a3V6Srs1MYbScnYXMNTIpeWRCPhGdywN+c50CEp1ZXPhXKdE3qwI84E6hwSV2PMBhg==
X-Received: by 2002:a05:600c:490:: with SMTP id d16mr1832871wme.7.1571867803445;
        Wed, 23 Oct 2019 14:56:43 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 22/32] elx: efct: Extended link Service IO handling
Date:   Wed, 23 Oct 2019 14:55:47 -0700
Message-Id: <20191023215557.12581-23-jsmart2021@gmail.com>
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
Functions to build and send ELS/CT/BLS commands and responses.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_els.c | 2676 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_els.h |  139 ++
 2 files changed, 2815 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_els.c
 create mode 100644 drivers/scsi/elx/efct/efct_els.h

diff --git a/drivers/scsi/elx/efct/efct_els.c b/drivers/scsi/elx/efct/efct_els.c
new file mode 100644
index 000000000000..5aef991712c2
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_els.c
@@ -0,0 +1,2676 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * Functions to build and send ELS/CT/BLS commands and responses.
+ */
+
+#include "efct_driver.h"
+#include "efct_els.h"
+
+#define ELS_IOFMT "[i:%04x t:%04x h:%04x]"
+
+#define node_els_trace()  \
+	do { \
+		if (EFCT_LOG_ENABLE_ELS_TRACE(efct)) \
+			efc_log_info(efct, "[%s] %-20s\n", \
+				node->display_name, __func__); \
+	} while (0)
+
+#define els_io_printf(els, fmt, ...) \
+	efc_log_debug((struct efct_s *)els->node->efc->base,\
+		      "[%s]" ELS_IOFMT " %-8s " fmt, \
+		      els->node->display_name,\
+		      els->init_task_tag, els->tgt_task_tag, els->hw_tag,\
+		      els->display_name, ##__VA_ARGS__)
+
+static int
+efct_els_send(struct efct_io_s *els,
+	      u32 reqlen, u32 timeout_sec,
+	efct_hw_srrs_cb_t cb);
+static int
+efct_els_send_rsp(struct efct_io_s *els, u32 rsplen);
+static int
+efct_els_acc_cb(struct efct_hw_io_s *hio, struct efc_remote_node_s *rnode,
+		u32 length, int status,
+		u32 ext_status, void *arg);
+static struct efct_io_s *
+efct_bls_send_acc(struct efct_io_s *, u32 s_id,
+		  u16 ox_id, u16 rx_id);
+static int
+efct_bls_send_acc_cb(struct efct_hw_io_s *, struct efc_remote_node_s *rnode,
+		     u32 length, int status,
+		u32 ext_status, void *app);
+static struct efct_io_s *
+efct_bls_send_rjt(struct efct_io_s *, u32 s_id,
+		  u16 ox_id, u16 rx_id);
+static int
+efct_bls_send_rjt_cb(struct efct_hw_io_s *, struct efc_remote_node_s *rnode,
+		     u32 length, int status,
+		u32 ext_status, void *app);
+
+static int
+efct_els_req_cb(struct efct_hw_io_s *hio, struct efc_remote_node_s *rnode,
+		u32 length, int status, u32 ext_status, void *arg);
+static struct efct_io_s *
+efct_els_abort_io(struct efct_io_s *els, bool send_abts);
+static void
+efct_els_delay_timer_cb(struct timer_list *t);
+
+static void
+efct_els_retry(struct efct_io_s *els);
+
+static void
+efct_els_abort_cleanup(struct efct_io_s *els);
+
+#define EFCT_ELS_RSP_LEN		1024
+#define EFCT_ELS_GID_PT_RSP_LEN	8096 /* Enough for 2K remote target nodes */
+
+void *
+efct_els_req_send(struct efc_lport *efc, struct efc_node_s *node, u32 cmd,
+		  u32 timeout_sec, u32 retries)
+{
+	struct efct_s *efct = efc->base;
+
+	switch (cmd) {
+	case ELS_PLOGI:
+		efc_log_debug(efct, "send efct_send_plogi\n");
+		efct_send_plogi(node, timeout_sec, retries, NULL, NULL);
+		break;
+	case ELS_FLOGI:
+		efc_log_debug(efct, "send efct_send_flogi\n");
+		efct_send_flogi(node, timeout_sec, retries, NULL, NULL);
+		break;
+	case ELS_LOGO:
+		efc_log_debug(efct, "send efct_send_logo\n");
+		efct_send_logo(node, timeout_sec, retries, NULL, NULL);
+		break;
+	case ELS_PRLI:
+		efc_log_debug(efct, "send efct_send_prli\n");
+		efct_send_prli(node, timeout_sec, retries, NULL, NULL);
+		break;
+	case ELS_ADISC:
+		efc_log_debug(efct, "send efct_send_prli\n");
+		efct_send_adisc(node, timeout_sec, retries, NULL, NULL);
+		break;
+	case ELS_SCR:
+		efc_log_debug(efct, "send efct_send_scr\n");
+		efct_send_scr(node, timeout_sec, retries, NULL, NULL);
+		break;
+	default:
+		efc_log_debug(efct, "Unhandled command cmd: %x\n", cmd);
+	}
+
+	return NULL;
+}
+
+void *
+efct_els_resp_send(struct efc_lport *efc, struct efc_node_s *node,
+		   u32 cmd, u16 ox_id)
+{
+	struct efct_s *efct = efc->base;
+
+	switch (cmd) {
+	case ELS_PLOGI:
+		efct_send_plogi_acc(node, ox_id, NULL, NULL);
+		break;
+	case ELS_FLOGI:
+		efct_send_flogi_acc(node, ox_id, 0, NULL, NULL);
+		break;
+	case ELS_LOGO:
+		efct_send_logo_acc(node, ox_id, NULL, NULL);
+		break;
+	case ELS_PRLI:
+		efct_send_prli_acc(node, ox_id, NULL, NULL);
+		break;
+	case ELS_PRLO:
+		efct_send_prlo_acc(node, ox_id, NULL, NULL);
+		break;
+	case ELS_ADISC:
+		efct_send_adisc_acc(node, ox_id, NULL, NULL);
+		break;
+	case ELS_LS_ACC:
+		efct_send_ls_acc(node, ox_id, NULL, NULL);
+		break;
+	case ELS_PDISC:
+	case ELS_FDISC:
+	case ELS_RSCN:
+	case ELS_SCR:
+		efct_send_ls_rjt(efc, node, ox_id, ELS_RJT_UNAB,
+				 ELS_EXPL_NONE, 0);
+		break;
+	default:
+		efc_log_err(efct, "Unhandled command cmd: %x\n", cmd);
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Allocate an IO structure for an ELS IO context.
+ *
+ * <h3 class="desc">Description</h3>
+ * Allocate an IO for an ELS context.
+ * Uses EFCT_ELS_RSP_LEN as response size.
+ *
+ * @param node node to associate ELS IO with
+ * @param reqlen Length of ELS request
+ * @param role Role of ELS (originator/responder)
+ *
+ * @return pointer to IO structure allocated
+ */
+
+struct efct_io_s *
+efct_els_io_alloc(struct efc_node_s *node, u32 reqlen,
+		  enum efct_els_role_e role)
+{
+	return efct_els_io_alloc_size(node, reqlen, EFCT_ELS_RSP_LEN, role);
+}
+
+/**
+ * @ingroup els_api
+ * @brief Allocate an IO structure for an ELS IO context.
+ *
+ * <h3 class="desc">Description</h3>
+ * Allocate an IO for an ELS context, allowing the
+ * caller to specify the size of the response.
+ *
+ * @param node node to associate ELS IO with
+ * @param reqlen Length of ELS request
+ * @param rsplen Length of ELS response
+ * @param role Role of ELS (originator/responder)
+ *
+ * @return pointer to IO structure allocated
+ */
+
+struct efct_io_s *
+efct_els_io_alloc_size(struct efc_node_s *node, u32 reqlen,
+		       u32 rsplen, enum efct_els_role_e role)
+{
+	struct efct_s *efct;
+	struct efct_xport_s *xport;
+	struct efct_io_s *els;
+	unsigned long flags = 0;
+
+	efct = node->efc->base;
+
+	xport = efct->xport;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+
+	if (!node->io_alloc_enabled) {
+		efc_log_debug(efct,
+			       "called with io_alloc_enabled = FALSE\n");
+		spin_unlock_irqrestore(&node->active_ios_lock, flags);
+		return NULL;
+	}
+
+	els = efct_io_pool_io_alloc(efct->xport->io_pool);
+	if (!els) {
+		atomic_add_return(1, &xport->io_alloc_failed_count);
+		spin_unlock_irqrestore(&node->active_ios_lock, flags);
+		return NULL;
+	}
+
+	/* initialize refcount */
+	kref_init(&els->ref);
+	els->release = _efct_els_io_free;
+
+	switch (role) {
+	case EFCT_ELS_ROLE_ORIGINATOR:
+		els->cmd_ini = true;
+		els->cmd_tgt = false;
+		break;
+	case EFCT_ELS_ROLE_RESPONDER:
+		els->cmd_ini = false;
+		els->cmd_tgt = true;
+		break;
+	}
+
+	/* IO should not have an associated HW IO yet.
+	 * Assigned below.
+	 */
+	if (els->hio) {
+		efc_log_err(efct,
+			     "assertion failed.  HIO is not null\n");
+		efct_io_pool_io_free(efct->xport->io_pool, els);
+		spin_unlock_irqrestore(&node->active_ios_lock, flags);
+		return NULL;
+	}
+
+	/* populate generic io fields */
+	els->efct = efct;
+	els->node = node;
+
+	/* set type and ELS-specific fields */
+	els->io_type = EFCT_IO_TYPE_ELS;
+	els->display_name = "pending";
+
+	/* now allocate DMA for request and response */
+	els->els_req.size = reqlen;
+	els->els_req.virt = dma_alloc_coherent(&efct->pcidev->dev,
+					       els->els_req.size,
+					       &els->els_req.phys,
+					       GFP_DMA);
+	if (els->els_req.virt) {
+		els->els_rsp.size = rsplen;
+		els->els_rsp.virt = dma_alloc_coherent(&efct->pcidev->dev,
+						       els->els_rsp.size,
+						       &els->els_rsp.phys,
+						       GFP_DMA);
+		if (!els->els_rsp.virt) {
+			efc_log_err(efct, "dma_alloc rsp\n");
+			dma_free_coherent(&efct->pcidev->dev,
+					  els->els_req.size,
+				els->els_req.virt, els->els_req.phys);
+			efct_io_pool_io_free(efct->xport->io_pool, els);
+			els = NULL;
+		}
+	} else {
+		efc_log_err(efct, "dma_alloc req\n");
+		efct_io_pool_io_free(efct->xport->io_pool, els);
+		els = NULL;
+	}
+
+	if (els) {
+		/* initialize fields */
+		els->els_retries_remaining =
+					EFCT_FC_ELS_DEFAULT_RETRIES;
+		els->els_pend = false;
+		els->els_active = false;
+
+		/* add els structure to ELS IO list */
+		INIT_LIST_HEAD(&els->list_entry);
+		list_add_tail(&els->list_entry,
+			      &node->els_io_pend_list);
+		els->els_pend = true;
+	}
+
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Free IO structure for an ELS IO context.
+ *
+ * <h3 class="desc">Description</h3> Free IO for an ELS
+ * IO context
+ *
+ * @param els ELS IO structure for which IO is allocated
+ *
+ * @return None
+ */
+
+void
+efct_els_io_free(struct efct_io_s *els)
+{
+	kref_put(&els->ref, els->release);
+}
+
+/**
+ * @ingroup els_api
+ * @brief Free IO structure for an ELS IO context.
+ *
+ * <h3 class="desc">Description</h3> Free IO for an ELS
+ * IO context
+ *
+ * @param arg ELS IO structure for which IO is allocated
+ *
+ * @return None
+ */
+
+void
+_efct_els_io_free(struct kref *arg)
+{
+	struct efct_io_s *els = container_of(arg, struct efct_io_s, ref);
+	struct efct_s *efct;
+	struct efc_node_s *node;
+	int send_empty_event = false;
+	unsigned long flags = 0;
+
+	node = els->node;
+	efct = node->efc->base;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+		if (els->els_active) {
+			/* if active, remove from active list and check empty */
+			list_del(&els->list_entry);
+			/* Send list empty event if the IO allocator
+			 * is disabled, and the list is empty
+			 * If node->io_alloc_enabled was not checked,
+			 * the event would be posted continually
+			 */
+			send_empty_event = (!node->io_alloc_enabled) &&
+				list_empty(&node->els_io_active_list);
+			els->els_active = false;
+		} else if (els->els_pend) {
+			/* if pending, remove from pending list;
+			 * node shutdown isn't gated off the
+			 * pending list (only the active list),
+			 * so no need to check if pending list is empty
+			 */
+			list_del(&els->list_entry);
+			els->els_pend = 0;
+		} else {
+			efc_log_err(efct,
+				     "assertion fail: niether els_pend nor active set\n");
+			spin_unlock_irqrestore(&node->active_ios_lock, flags);
+			return;
+		}
+
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+
+	/* free ELS request and response buffers */
+	dma_free_coherent(&efct->pcidev->dev, els->els_rsp.size,
+			  els->els_rsp.virt, els->els_rsp.phys);
+	dma_free_coherent(&efct->pcidev->dev, els->els_req.size,
+			  els->els_req.virt, els->els_req.phys);
+
+	efct_io_pool_io_free(efct->xport->io_pool, els);
+
+	if (send_empty_event)
+		efc_scsi_io_list_empty(node->efc, node);
+
+	efct_scsi_check_pending(efct);
+}
+
+/**
+ * @ingroup els_api
+ * @brief Make ELS IO active
+ *
+ * @param els Pointer to the IO context to make active.
+ *
+ * @return Returns 0 on success; or a negative error code value on failure.
+ */
+
+static void
+efct_els_make_active(struct efct_io_s *els)
+{
+	struct efc_node_s *node = els->node;
+	unsigned long flags = 0;
+
+	/* move ELS from pending list to active list */
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+		if (els->els_pend) {
+			if (els->els_active) {
+				efc_log_err(node->efc,
+					     "assertion fail:both els_pend and active set\n");
+				spin_unlock_irqrestore(&node->active_ios_lock,
+						       flags);
+				return;
+			}
+			/* remove from pending list */
+			list_del(&els->list_entry);
+			els->els_pend = false;
+
+			/* add els structure to ELS IO list */
+			INIT_LIST_HEAD(&els->list_entry);
+			list_add_tail(&els->list_entry,
+				      &node->els_io_active_list);
+			els->els_active = true;
+		} else {
+			/* must be retrying; make sure it's already active */
+			if (!els->els_active) {
+				efc_log_err(node->efc,
+					     "assertion fail: niether els_pend nor active set\n");
+			}
+		}
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+}
+
+static void efct_els_send_req(struct efc_node_s *node, struct efct_io_s *els)
+{
+	int rc = 0;
+	struct efct_s *efct;
+
+	efct = node->efc->base;
+	rc = efct_els_send(els, els->els_req.size,
+			   els->els_timeout_sec, efct_els_req_cb);
+
+	if (rc) {
+		struct efc_node_cb_s cbdata;
+
+		cbdata.status = INT_MAX;
+		cbdata.ext_status = INT_MAX;
+		cbdata.els_rsp = els->els_rsp;
+		efc_log_err(efct, "efct_els_send failed: %d\n", rc);
+		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
+				    &cbdata);
+	}
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send the ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * The command, given by the \c els IO context,
+ * is sent to the node that the IO was
+ * configured with, using efct_hw_srrs_send().
+ * Upon completion,the \c cb callback is invoked,
+ * with the application-specific argument set to
+ * the \c els IO context.
+ *
+ * @param els Pointer to the IO context.
+ * @param reqlen Byte count in the payload to send.
+ * @param timeout_sec Command timeout, in seconds (0 -> 2*R_A_TOV).
+ * @param cb Completion callback.
+ *
+ * @return Returns 0 on success; or a negative error code value on failure.
+ */
+
+static int efct_els_send(struct efct_io_s *els, u32 reqlen,
+			 u32 timeout_sec, efct_hw_srrs_cb_t cb)
+{
+	struct efc_node_s *node = els->node;
+
+	/* update ELS request counter */
+	node->els_req_cnt++;
+
+	/* move ELS from pending list to active list */
+	efct_els_make_active(els);
+
+	els->wire_len = reqlen;
+	return efct_scsi_io_dispatch(els, cb);
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send the ELS response.
+ *
+ * <h3 class="desc">Description</h3>
+ * The ELS response, given by the \c els IO context, is sent to the node
+ * that the IO was configured with, using efct_hw_srrs_send().
+ *
+ * @param els Pointer to the IO context.
+ * @param rsplen Byte count in the payload to send.
+ *
+ * @return Returns 0 on success; or a negative error value on failure.
+ */
+
+static int
+efct_els_send_rsp(struct efct_io_s *els, u32 rsplen)
+{
+	struct efc_node_s *node = els->node;
+
+	/* increment ELS completion counter */
+	node->els_cmpl_cnt++;
+
+	/* move ELS from pending list to active list */
+	efct_els_make_active(els);
+
+	els->wire_len = rsplen;
+	return efct_scsi_io_dispatch(els, efct_els_acc_cb);
+}
+
+/**
+ * @ingroup els_api
+ * @brief Handle ELS IO request completions.
+ *
+ * <h3 class="desc">Description</h3>
+ * This callback is used for several ELS send operations.
+ *
+ * @param hio Pointer to the HW IO context that completed.
+ * @param rnode Pointer to the remote node.
+ * @param length Length of the returned payload data.
+ * @param status Status of the completion.
+ * @param ext_status Extended status of the completion.
+ * @param arg Application-specific argument
+ * (generally a pointer to the ELS IO context).
+ *
+ * @return Returns 0 on success; or a negative error value on failure.
+ */
+
+static int
+efct_els_req_cb(struct efct_hw_io_s *hio, struct efc_remote_node_s *rnode,
+		u32 length, int status, u32 ext_status, void *arg)
+{
+	struct efct_io_s *els;
+	struct efc_node_s *node;
+	struct efct_s *efct;
+	struct efc_node_cb_s cbdata;
+	u32 reason_code;
+
+	els = arg;
+	node = els->node;
+	efct = node->efc->base;
+
+	if (status != 0)
+		els_io_printf(els, "status x%x ext x%x\n", status, ext_status);
+
+	/* set the response len element of els->rsp */
+	els->els_rsp.len = length;
+
+	cbdata.status = status;
+	cbdata.ext_status = ext_status;
+	cbdata.header = NULL;
+	cbdata.els_rsp = els->els_rsp;
+
+	/* FW returns the number of bytes received on the link in
+	 * the WCQE, not the amount placed in the buffer; use this info to
+	 * check if there was an overrun.
+	 */
+	if (length > els->els_rsp.size) {
+		efc_log_warn(efct,
+			      "ELS response returned len=%d > buflen=%zu\n",
+			     length, els->els_rsp.size);
+		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL, &cbdata);
+		return 0;
+	}
+
+	/* Post event to ELS IO object */
+	switch (status) {
+	case SLI4_FC_WCQE_STATUS_SUCCESS:
+		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_OK, &cbdata);
+		break;
+
+	case SLI4_FC_WCQE_STATUS_LS_RJT:
+		reason_code = (ext_status >> 16) & 0xff;
+
+		/* delay and retry if reason code is Logical Busy */
+		switch (reason_code) {
+		case ELS_RJT_BUSY:
+			els->node->els_req_cnt--;
+			els_io_printf(els,
+				      "LS_RJT Logical Busy response,delay and retry\n");
+			timer_setup(&els->delay_timer,
+				    efct_els_delay_timer_cb, 0);
+			mod_timer(&els->delay_timer,
+				  jiffies + msecs_to_jiffies(5000));
+			els->state = EFCT_ELS_REQUEST_DELAYED;
+			break;
+		default:
+			efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_RJT,
+					    &cbdata);
+			break;
+		}
+		break;
+
+	case SLI4_FC_WCQE_STATUS_LOCAL_REJECT:
+		switch (ext_status) {
+		case SLI4_FC_LOCAL_REJECT_SEQUENCE_TIMEOUT:
+			efct_els_retry(els);
+			break;
+
+		case SLI4_FC_LOCAL_REJECT_ABORT_REQUESTED:
+			if (els->state == EFCT_ELS_ABORT_IO_COMPL) {
+				/* completion for ELS that was aborted */
+				efct_els_abort_cleanup(els);
+			} else {
+				/* completion for ELS received first,
+				 * transition to wait for abort cmpl
+				 */
+				els->state = EFCT_ELS_REQ_ABORTED;
+			}
+
+			break;
+		default:
+			efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
+					    &cbdata);
+			break;
+		}
+		break;
+	default:	/* Other error */
+		efc_log_warn(efct,
+			      "els req failed status x%x, ext_status, x%x\n",
+					status, ext_status);
+		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL, &cbdata);
+		break;
+	}
+
+	return 0;
+}
+
+void
+efct_els_abort(struct efct_io_s *els, struct efc_node_cb_s *arg)
+{
+	struct efct_io_s *io = NULL;
+	struct efc_node_s *node;
+	struct efct_s *efct;
+
+	node = els->node;
+	efct = node->efc->base;
+
+	/* request to abort this ELS without an ABTS */
+	els_io_printf(els, "ELS abort requested\n");
+	/* Set retries to zero,we are done */
+	els->els_retries_remaining = 0;
+	if (els->state == EFCT_ELS_REQUEST) {
+		els->state = EFCT_ELS_REQ_ABORT;
+		io = efct_els_abort_io(els, false);
+		if (!io) {
+			efc_log_err(efct, "efct_els_abort_io failed\n");
+			efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
+					    arg);
+		}
+
+	} else if (els->state == EFCT_ELS_REQUEST_DELAYED) {
+		/* mod/resched the timer for a short duration */
+		mod_timer(&els->delay_timer,
+			  jiffies + msecs_to_jiffies(1));
+
+		els->state = EFCT_ELS_REQUEST_DELAY_ABORT;
+	}
+}
+
+/**
+ * @ingroup els_api
+ * @brief Handle ELS IO accept/response completions.
+ *
+ * <h3 class="desc">Description</h3>
+ * This callback is used for several ELS send operations.
+ *
+ * @param hio Pointer to the HW IO context that completed.
+ * @param rnode Pointer to the remote node.
+ * @param length Length of the returned payload data.
+ * @param status Status of the completion.
+ * @param ext_status Extended status of the completion.
+ * @param arg Application-specific argument
+ *	(generally a pointer to the ELS IO context).
+ *
+ * @return Returns 0 on success; or a negative error value on failure.
+ */
+
+static int
+efct_els_acc_cb(struct efct_hw_io_s *hio, struct efc_remote_node_s *rnode,
+		u32 length, int status, u32 ext_status, void *arg)
+{
+	struct efct_io_s *els;
+	struct efc_node_s *node;
+	struct efct_s *efct;
+	struct efc_node_cb_s cbdata;
+
+	els = arg;
+	node = els->node;
+	efct = node->efc->base;
+
+	cbdata.status = status;
+	cbdata.ext_status = ext_status;
+	cbdata.header = NULL;
+	cbdata.els_rsp = els->els_rsp;
+
+	/* Post node event */
+	switch (status) {
+	case SLI4_FC_WCQE_STATUS_SUCCESS:
+		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_CMPL_OK, &cbdata);
+		break;
+
+	default:	/* Other error */
+		efc_log_warn(efct,
+			      "[%s] %-8s failed status x%x, ext_status x%x\n",
+			    node->display_name, els->display_name,
+			    status, ext_status);
+		efc_log_warn(efct,
+			      "els acc complete: failed status x%x, ext_status, x%x\n",
+		     status, ext_status);
+		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_CMPL_FAIL, &cbdata);
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Format and send a PLOGI ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a PLOGI payload using the domain SLI port service parameters,
+ * and send to the \c node.
+ *
+ * @param node Node to which the PLOGI is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_plogi(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries,
+	      void (*cb)(struct efc_node_s *node,
+			 struct efc_node_cb_s *cbdata, void *arg), void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct = node->efc->base;
+	struct fc_els_flogi  *plogi;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*plogi), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "plogi";
+
+		/* Build PLOGI request */
+		plogi = els->els_req.virt;
+
+		memcpy(plogi, node->sport->service_params, sizeof(*plogi));
+
+		plogi->fl_cmd = ELS_PLOGI;
+		memset(plogi->_fl_resvd, 0, sizeof(plogi->_fl_resvd));
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Format and send a FLOGI ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct an FLOGI payload, and send to the \c node.
+ *
+ * @param node Node to which the FLOGI is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before
+ * reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_flogi(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct;
+	struct fc_els_flogi  *flogi;
+
+	efct = node->efc->base;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*flogi), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "flogi";
+
+		/* Build FLOGI request */
+		flogi = els->els_req.virt;
+
+		memcpy(flogi, node->sport->service_params, sizeof(*flogi));
+		flogi->fl_cmd = ELS_FLOGI;
+		memset(flogi->_fl_resvd, 0, sizeof(flogi->_fl_resvd));
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Format and send a FDISC ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct an FDISC payload, and send to the \c node.
+ *
+ * @param node Node to which the FDISC is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_fdisc(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct;
+	struct fc_els_flogi *fdisc;
+
+	efct = node->efc->base;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*fdisc), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "fdisc";
+
+		/* Build FDISC request */
+		fdisc = els->els_req.virt;
+
+		memcpy(fdisc, node->sport->service_params, sizeof(*fdisc));
+		fdisc->fl_cmd = ELS_FDISC;
+		memset(fdisc->_fl_resvd, 0, sizeof(fdisc->_fl_resvd));
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a PRLI ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a PRLI ELS command, and send to the \c node.
+ *
+ * @param node Node to which the PRLI is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_prli(struct efc_node_s *node, u32 timeout_sec, u32 retries,
+	       els_cb_t cb, void *cbarg)
+{
+	struct efct_s *efct = node->efc->base;
+	struct efct_io_s *els;
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*pp), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "prli";
+
+		/* Build PRLI request */
+		pp = els->els_req.virt;
+
+		memset(pp, 0, sizeof(*pp));
+
+		pp->prli.prli_cmd = ELS_PRLI;
+		pp->prli.prli_spp_len = 16;
+		pp->prli.prli_len = cpu_to_be16(sizeof(*pp));
+		pp->spp.spp_type = FC_TYPE_FCP;
+		pp->spp.spp_type_ext = 0;
+		pp->spp.spp_flags = FC_SPP_EST_IMG_PAIR;
+		pp->spp.spp_params = cpu_to_be32(FCP_SPPF_RD_XRDY_DIS |
+				       (node->sport->enable_ini ?
+				       FCP_SPPF_INIT_FCN : 0) |
+				       (node->sport->enable_tgt ?
+				       FCP_SPPF_TARG_FCN : 0));
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a PRLO ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a PRLO ELS command, and send to the \c node.
+ *
+ * @param node Node to which the PRLO is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_prlo(struct efc_node_s *node, u32 timeout_sec, u32 retries,
+	       els_cb_t cb, void *cbarg)
+{
+	struct efct_s *efct = node->efc->base;
+	struct efct_io_s *els;
+	struct {
+		struct fc_els_prlo prlo;
+		struct fc_els_spp spp;
+	} *pp;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*pp), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "prlo";
+
+		/* Build PRLO request */
+		pp = els->els_req.virt;
+
+		memset(pp, 0, sizeof(*pp));
+		pp->prlo.prlo_cmd = ELS_PRLO;
+		pp->prlo.prlo_obs = 0x10;
+		pp->prlo.prlo_len = cpu_to_be16(sizeof(*pp));
+
+		pp->spp.spp_type = FC_TYPE_FCP;
+		pp->spp.spp_type_ext = 0;
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a LOGO ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Format a LOGO, and send to the \c node.
+ *
+ * @param node Node to which the LOGO is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_logo(struct efc_node_s *node, u32 timeout_sec, u32 retries,
+	       els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct;
+	struct fc_els_logo *logo;
+	struct fc_els_flogi  *sparams;
+
+	efct = node->efc->base;
+
+	node_els_trace();
+
+	sparams = (struct fc_els_flogi *)node->sport->service_params;
+
+	els = efct_els_io_alloc(node, sizeof(*logo), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "logo";
+
+		/* Build LOGO request */
+
+		logo = els->els_req.virt;
+
+		memset(logo, 0, sizeof(*logo));
+		logo->fl_cmd = ELS_LOGO;
+		hton24(logo->fl_n_port_id, node->rnode.sport->fc_id);
+		logo->fl_n_port_wwn = sparams->fl_wwpn;
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send an ADISC ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct an ADISC ELS command, and send to the \c node.
+ *
+ * @param node Node to which the ADISC is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_adisc(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct;
+	struct fc_els_adisc *adisc;
+	struct fc_els_flogi  *sparams;
+	struct efc_sli_port_s *sport = node->sport;
+
+	efct = node->efc->base;
+
+	node_els_trace();
+
+	sparams = (struct fc_els_flogi *)node->sport->service_params;
+
+	els = efct_els_io_alloc(node, sizeof(*adisc), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "adisc";
+
+		/* Build ADISC request */
+
+		adisc = els->els_req.virt;
+
+		memset(adisc, 0, sizeof(*adisc));
+		adisc->adisc_cmd = ELS_ADISC;
+		hton24(adisc->adisc_hard_addr, sport->fc_id);
+		adisc->adisc_wwpn = sparams->fl_wwpn;
+		adisc->adisc_wwnn = sparams->fl_wwnn;
+		hton24(adisc->adisc_port_id, node->rnode.sport->fc_id);
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a PDISC ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a PDISC ELS command, and send to the \c node.
+ *
+ * @param node Node to which the PDISC is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_pdisc(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct = node->efc->base;
+	struct fc_els_flogi  *pdisc;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*pdisc), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "pdisc";
+
+		pdisc = els->els_req.virt;
+
+		memcpy(pdisc, node->sport->service_params, sizeof(*pdisc));
+
+		pdisc->fl_cmd = ELS_PDISC;
+		memset(pdisc->_fl_resvd, 0, sizeof(pdisc->_fl_resvd));
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send an SCR ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Format an SCR, and send to the \c node.
+ *
+ * @param node Node to which the SCR is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function
+ * @param cbarg Callback function arg
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_scr(struct efc_node_s *node, u32 timeout_sec, u32 retries,
+	      els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct = node->efc->base;
+	struct fc_els_scr *req;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*req), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "scr";
+
+		req = els->els_req.virt;
+
+		memset(req, 0, sizeof(*req));
+		req->scr_cmd = ELS_SCR;
+		req->scr_reg_func = ELS_SCRF_FULL;
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send an RRQ ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Format an RRQ, and send to the \c node.
+ *
+ * @param node Node to which the RRQ is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function
+ * @param cbarg Callback function arg
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_rrq(struct efc_node_s *node, u32 timeout_sec, u32 retries,
+	      els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct = node->efc->base;
+	struct fc_els_scr *req;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*req), EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "scr";
+
+		req = els->els_req.virt;
+
+		memset(req, 0, sizeof(*req));
+		req->scr_cmd = ELS_RRQ;
+		req->scr_reg_func = ELS_SCRF_FULL;
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send an RSCN ELS command.
+ *
+ * <h3 class="desc">Description</h3>
+ * Format an RSCN, and send to the \c node.
+ *
+ * @param node Node to which the RRQ is sent.
+ * @param timeout_sec Command timeout, in seconds.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param port_ids Pointer to port IDs
+ * @param port_ids_count Count of port IDs
+ * @param cb Callback function
+ * @param cbarg Callback function arg
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+struct efct_io_s *
+efct_send_rscn(struct efc_node_s *node, u32 timeout_sec, u32 retries,
+	       void *port_ids, u32 port_ids_count, els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct = node->efc->base;
+	struct fc_els_rscn *req;
+	struct fc_els_rscn_page *rscn_page;
+	u32 length = sizeof(*rscn_page) * port_ids_count;
+
+	length += sizeof(*req);
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, length, EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->els_timeout_sec = timeout_sec;
+		els->els_retries_remaining = retries;
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "rscn";
+
+		req = els->els_req.virt;
+
+		req->rscn_cmd = ELS_RSCN;
+		req->rscn_page_len = sizeof(struct fc_els_rscn_page);
+		req->rscn_plen = cpu_to_be16(length);
+
+		els->hio_type = EFCT_HW_ELS_REQ;
+		els->iparam.els.timeout = timeout_sec;
+
+		/* copy in the payload */
+		rscn_page = els->els_req.virt + sizeof(*req);
+		memcpy(rscn_page, port_ids,
+		       port_ids_count * sizeof(*rscn_page));
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @brief Send an LS_RJT ELS response.
+ *
+ * <h3 class="desc">Description</h3>
+ * Send an LS_RJT ELS response.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param ox_id Originator exchange ID being responded to.
+ * @param reason_code Reason code value for LS_RJT.
+ * @param reason_code_expl Reason code explanation value for LS_RJT.
+ * @param vendor_unique Vendor-unique value for LS_RJT.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+void *
+efct_send_ls_rjt(struct efc_lport *efc, struct efc_node_s *node,
+		 u32 ox_id, u32 reason_code,
+		u32 reason_code_expl, u32 vendor_unique)
+{
+	struct efct_io_s *io = NULL;
+	int rc;
+	struct efct_s *efct = node->efc->base;
+	struct fc_els_ls_rjt *rjt;
+
+	io = efct_els_io_alloc(node, sizeof(*rjt), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+
+	node_els_trace();
+
+	io->els_callback = NULL;
+	io->els_callback_arg = NULL;
+	io->display_name = "ls_rjt";
+	io->init_task_tag = ox_id;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els.ox_id = ox_id;
+
+	rjt = io->els_req.virt;
+	memset(rjt, 0, sizeof(*rjt));
+
+	rjt->er_cmd = ELS_LS_RJT;
+	rjt->er_reason = reason_code;
+	rjt->er_explan = reason_code_expl;
+
+	io->hio_type = EFCT_HW_ELS_RSP;
+	rc = efct_els_send_rsp(io, sizeof(*rjt));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+
+	return io;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a PLOGI accept response.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a PLOGI LS_ACC, and send to the \c node,
+ * using the originator exchange ID ox_id.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param ox_id Originator exchange ID being responsed to.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+struct efct_io_s *
+efct_send_plogi_acc(struct efc_node_s *node, u32 ox_id,
+		    els_cb_t cb, void *cbarg)
+{
+	int rc;
+	struct efct_s *efct = node->efc->base;
+	struct efct_io_s *io = NULL;
+	struct fc_els_flogi  *plogi;
+	struct fc_els_flogi  *req = (struct fc_els_flogi *)node->service_params;
+
+	node_els_trace();
+
+	io = efct_els_io_alloc(node, sizeof(*plogi), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+
+	io->els_callback = cb;
+	io->els_callback_arg = cbarg;
+	io->display_name = "plog_acc";
+	io->init_task_tag = ox_id;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els.ox_id = ox_id;
+
+	plogi = io->els_req.virt;
+
+	/* copy our port's service parameters to payload */
+	memcpy(plogi, node->sport->service_params, sizeof(*plogi));
+	plogi->fl_cmd = ELS_LS_ACC;
+	memset(plogi->_fl_resvd, 0, sizeof(plogi->_fl_resvd));
+
+	/* Set Application header support bit if requested */
+	if (req->fl_csp.sp_features & cpu_to_be16(FC_SP_FT_BCAST))
+		plogi->fl_csp.sp_features |= cpu_to_be32(FC_SP_FT_BCAST);
+
+	io->hio_type = EFCT_HW_ELS_RSP;
+	rc = efct_els_send_rsp(io, sizeof(*plogi));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+	return io;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send an FLOGI accept response for point-to-point negotiation.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct an FLOGI accept response, and send to the \c node using
+ * the originator exchange id \c ox_id. The \c s_id is used for the
+ * response frame source FC ID.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param ox_id Originator exchange ID for the response.
+ * @param s_id Source FC ID to be used in the response frame.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+void *
+efct_send_flogi_p2p_acc(struct efc_lport *efc, struct efc_node_s *node,
+			u32 ox_id, u32 s_id)
+{
+	struct efct_io_s *io = NULL;
+	int rc;
+	struct efct_s *efct = node->efc->base;
+	struct fc_els_flogi  *flogi;
+
+	node_els_trace();
+
+	io = efct_els_io_alloc(node, sizeof(*flogi), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+
+	io->els_callback = NULL;
+	io->els_callback_arg = NULL;
+	io->display_name = "flogi_p2p_acc";
+	io->init_task_tag = ox_id;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els_sid.ox_id = ox_id;
+	io->iparam.els_sid.s_id = s_id;
+
+	flogi = io->els_req.virt;
+
+	/* copy our port's service parameters to payload */
+	memcpy(flogi, node->sport->service_params, sizeof(*flogi));
+	flogi->fl_cmd = ELS_LS_ACC;
+	memset(flogi->_fl_resvd, 0, sizeof(flogi->_fl_resvd));
+
+	memset(flogi->fl_cssp, 0, sizeof(flogi->fl_cssp));
+
+	io->hio_type = EFCT_HW_ELS_RSP_SID;
+	rc = efct_els_send_rsp(io, sizeof(*flogi));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+
+	return io;
+}
+
+struct efct_io_s *
+efct_send_flogi_acc(struct efc_node_s *node, u32 ox_id, u32 is_fport,
+		    els_cb_t cb, void *cbarg)
+{
+	int rc;
+	struct efct_s *efct = node->efc->base;
+	struct efct_io_s *io = NULL;
+	struct fc_els_flogi  *flogi;
+
+	node_els_trace();
+
+	io = efct_els_io_alloc(node, sizeof(*flogi), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+	io->els_callback = cb;
+	io->els_callback_arg = cbarg;
+	io->display_name = "flogi_acc";
+	io->init_task_tag = ox_id;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els_sid.ox_id = ox_id;
+	io->iparam.els_sid.s_id = io->node->sport->fc_id;
+
+	flogi = io->els_req.virt;
+
+	/* copy our port's service parameters to payload */
+	memcpy(flogi, node->sport->service_params, sizeof(*flogi));
+
+	/* Set F_port */
+	if (is_fport) {
+		/* Set F_PORT and Multiple N_PORT_ID Assignment */
+		flogi->fl_csp.sp_r_a_tov |=  be32_to_cpu(3U << 28);
+	}
+
+	flogi->fl_cmd = ELS_LS_ACC;
+	memset(flogi->_fl_resvd, 0, sizeof(flogi->_fl_resvd));
+
+	memset(flogi->fl_cssp, 0, sizeof(flogi->fl_cssp));
+
+	io->hio_type = EFCT_HW_ELS_RSP_SID;
+	rc = efct_els_send_rsp(io, sizeof(*flogi));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+
+	return io;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a PRLI accept response
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a PRLI LS_ACC response, and send to the \c node,
+ * using the originator ox_id exchange ID.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param ox_id Originator exchange ID.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *efct_send_prli_acc(struct efc_node_s *node,
+				     u32 ox_id, els_cb_t cb, void *cbarg)
+{
+	int rc;
+	struct efct_s *efct = node->efc->base;
+	struct efct_io_s *io = NULL;
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
+
+	node_els_trace();
+
+	io = efct_els_io_alloc(node, sizeof(*pp), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+
+	io->els_callback = cb;
+	io->els_callback_arg = cbarg;
+	io->display_name = "prli_acc";
+	io->init_task_tag = ox_id;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els.ox_id = ox_id;
+
+	pp = io->els_req.virt;
+	memset(pp, 0, sizeof(*pp));
+
+	pp->prli.prli_cmd = ELS_LS_ACC;
+	pp->prli.prli_spp_len = 0x10;
+	pp->prli.prli_len = cpu_to_be16(sizeof(*pp));
+	pp->spp.spp_type = FC_TYPE_FCP;
+	pp->spp.spp_type_ext = 0;
+	pp->spp.spp_flags = FC_SPP_EST_IMG_PAIR | FC_SPP_RESP_ACK;
+
+	pp->spp.spp_params = cpu_to_be32(FCP_SPPF_RD_XRDY_DIS |
+					(node->sport->enable_ini ?
+					 FCP_SPPF_INIT_FCN : 0) |
+					(node->sport->enable_tgt ?
+					 FCP_SPPF_TARG_FCN : 0));
+
+	io->hio_type = EFCT_HW_ELS_RSP;
+	rc = efct_els_send_rsp(io, sizeof(*pp));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+
+	return io;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a PRLO accept response.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a PRLO LS_ACC response, and send to the \c node,
+ * using the originator exchange ID \c ox_id.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param ox_id Originator exchange ID.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_prlo_acc(struct efc_node_s *node, u32 ox_id,
+		   els_cb_t cb, void *cbarg)
+{
+	int rc;
+	struct efct_s *efct = node->efc->base;
+	struct efct_io_s *io = NULL;
+	struct {
+		struct fc_els_prlo prlo;
+		struct fc_els_spp spp;
+	} *pp;
+
+	node_els_trace();
+
+	io = efct_els_io_alloc(node, sizeof(*pp), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+
+	io->els_callback = cb;
+	io->els_callback_arg = cbarg;
+	io->display_name = "prlo_acc";
+	io->init_task_tag = ox_id;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els.ox_id = ox_id;
+
+	pp = io->els_req.virt;
+	memset(pp, 0, sizeof(*pp));
+	pp->prlo.prlo_cmd = ELS_LS_ACC;
+	pp->prlo.prlo_obs = 0x10;
+	pp->prlo.prlo_len = cpu_to_be16(sizeof(*pp));
+
+	pp->spp.spp_type = FC_TYPE_FCP;
+	pp->spp.spp_type_ext = 0;
+	pp->spp.spp_flags = FC_SPP_RESP_ACK;
+
+	io->hio_type = EFCT_HW_ELS_RSP;
+	rc = efct_els_send_rsp(io, sizeof(*pp));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+
+	return io;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a generic LS_ACC response without a payload.
+ *
+ * <h3 class="desc">Description</h3>
+ * A generic LS_ACC response is sent to the \c node using the
+ * originator exchange ID ox_id.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param ox_id Originator exchange id.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+struct efct_io_s *
+efct_send_ls_acc(struct efc_node_s *node, u32 ox_id, els_cb_t cb,
+		 void *cbarg)
+{
+	int rc;
+	struct efct_s *efct = node->efc->base;
+	struct efct_io_s *io = NULL;
+	struct fc_els_ls_acc *acc;
+
+	node_els_trace();
+
+	io = efct_els_io_alloc(node, sizeof(*acc), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+
+	io->els_callback = cb;
+	io->els_callback_arg = cbarg;
+	io->display_name = "ls_acc";
+	io->init_task_tag = ox_id;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els.ox_id = ox_id;
+
+	acc = io->els_req.virt;
+	memset(acc, 0, sizeof(*acc));
+
+	acc->la_cmd = ELS_LS_ACC;
+
+	io->hio_type = EFCT_HW_ELS_RSP;
+	rc = efct_els_send_rsp(io, sizeof(*acc));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+
+	return io;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a LOGO accept response.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a LOGO LS_ACC response, and send to the \c node,
+ * using the originator exchange ID \c ox_id.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param ox_id Originator exchange ID.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+struct efct_io_s *
+efct_send_logo_acc(struct efc_node_s *node, u32 ox_id,
+		   els_cb_t cb, void *cbarg)
+{
+	int rc;
+	struct efct_io_s *io = NULL;
+	struct efct_s *efct = node->efc->base;
+	struct fc_els_ls_acc *logo;
+
+	node_els_trace();
+
+	io = efct_els_io_alloc(node, sizeof(*logo), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+
+	io->els_callback = cb;
+	io->els_callback_arg = cbarg;
+	io->display_name = "logo_acc";
+	io->init_task_tag = ox_id;
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els.ox_id = ox_id;
+
+	logo = io->els_req.virt;
+	memset(logo, 0, sizeof(*logo));
+
+	logo->la_cmd = ELS_LS_ACC;
+
+	io->hio_type = EFCT_HW_ELS_RSP;
+	rc = efct_els_send_rsp(io, sizeof(*logo));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+
+	return io;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send an ADISC accept response.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct an ADISC LS__ACC, and send to the \c node, using the originator
+ * exchange id \c ox_id.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param ox_id Originator exchange ID.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_send_adisc_acc(struct efc_node_s *node, u32 ox_id,
+		    els_cb_t cb, void *cbarg)
+{
+	int rc;
+	struct efct_io_s *io = NULL;
+	struct fc_els_adisc *adisc;
+	struct fc_els_flogi  *sparams;
+	struct efct_s *efct;
+
+	efct = node->efc->base;
+
+	node_els_trace();
+
+	io = efct_els_io_alloc(node, sizeof(*adisc), EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efct, "els IO alloc failed\n");
+		return io;
+	}
+
+	io->els_callback = cb;
+	io->els_callback_arg = cbarg;
+	io->display_name = "adisc_acc";
+	io->init_task_tag = ox_id;
+
+	/* Go ahead and send the ELS_ACC */
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.els.ox_id = ox_id;
+
+	sparams = (struct fc_els_flogi  *)node->sport->service_params;
+	adisc = io->els_req.virt;
+	memset(adisc, 0, sizeof(*adisc));
+	adisc->adisc_cmd = ELS_LS_ACC;
+	adisc->adisc_wwpn = sparams->fl_wwpn;
+	adisc->adisc_wwnn = sparams->fl_wwnn;
+	hton24(adisc->adisc_port_id, node->rnode.sport->fc_id);
+
+	io->hio_type = EFCT_HW_ELS_RSP;
+	rc = efct_els_send_rsp(io, sizeof(*adisc));
+	if (rc) {
+		efct_els_io_free(io);
+		io = NULL;
+	}
+
+	return io;
+}
+
+void *
+efct_els_send_ct(struct efc_lport *efc, struct efc_node_s *node, u32 cmd,
+		 u32 timeout_sec, u32 retries)
+{
+	struct efct_s *efct = efc->base;
+
+	switch (cmd) {
+	case FC_RCTL_ELS_REQ:
+		efc_log_err(efct, "send efct_ns_send_rftid\n");
+		efct_ns_send_rftid(node, timeout_sec, retries, NULL, NULL);
+		break;
+	case FC_NS_RFF_ID:
+		efc_log_err(efct, "send efct_ns_send_rffid\n");
+		efct_ns_send_rffid(node, timeout_sec, retries, NULL, NULL);
+		break;
+	case FC_NS_GID_PT:
+		efc_log_err(efct, "send efct_ns_send_gidpt\n");
+		efct_ns_send_gidpt(node, timeout_sec, retries, NULL, NULL);
+		break;
+	default:
+		efc_log_err(efct, "Unhandled command cmd: %x\n", cmd);
+	}
+
+	return NULL;
+}
+
+static inline void fcct_build_req_header(struct fc_ct_hdr  *hdr,
+					 u16 cmd, u16 max_size)
+{
+	hdr->ct_rev = FC_CT_REV;
+	hdr->ct_fs_type = FC_FST_DIR;
+	hdr->ct_fs_subtype = FC_NS_SUBTYPE;
+	hdr->ct_options = 0;
+	hdr->ct_cmd = cpu_to_be16(cmd);
+	/* words */
+	hdr->ct_mr_size = cpu_to_be16(max_size / (sizeof(u32)));
+	hdr->ct_reason = 0;
+	hdr->ct_explan = 0;
+	hdr->ct_vendor = 0;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a RFTID CT request.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct an RFTID CT request, and send to the \c node.
+ *
+ * @param node Node to which the RFTID request is sent.
+ * @param timeout_sec Time, in seconds, to wait before timing out the ELS.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+struct efct_io_s *
+efct_ns_send_rftid(struct efc_node_s *node, u32 timeout_sec,
+		   u32 retries, els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct = node->efc->base;
+	struct fc_ct_hdr *ct;
+	struct fc_ns_rft_id *rftid;
+
+	node_els_trace();
+
+	els = efct_els_io_alloc(node, sizeof(*ct) + sizeof(*rftid),
+				EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->iparam.fc_ct.r_ctl = FC_RCTL_ELS_REQ;
+		els->iparam.fc_ct.type = FC_TYPE_CT;
+		els->iparam.fc_ct.df_ctl = 0;
+		els->iparam.fc_ct.timeout = timeout_sec;
+
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "rftid";
+
+		ct = els->els_req.virt;
+		memset(ct, 0, sizeof(*ct));
+		fcct_build_req_header(ct, FC_NS_RFT_ID, sizeof(*rftid));
+
+		rftid = els->els_req.virt + sizeof(*ct);
+		memset(rftid, 0, sizeof(*rftid));
+		hton24(rftid->fr_fid.fp_fid, node->rnode.sport->fc_id);
+		rftid->fr_fts.ff_type_map[FC_TYPE_FCP / FC_NS_BPW] =
+			cpu_to_be32(1 << (FC_TYPE_FCP % FC_NS_BPW));
+
+		els->hio_type = EFCT_HW_FC_CT;
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a RFFID CT request.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct an RFFID CT request, and send to the \c node.
+ *
+ * @param node Node to which the RFFID request is sent.
+ * @param timeout_sec Time, in seconds, to wait before timing out the ELS.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+struct efct_io_s *
+efct_ns_send_rffid(struct efc_node_s *node, u32 timeout_sec,
+		   u32 retries, els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els;
+	struct efct_s *efct = node->efc->base;
+	struct fc_ct_hdr *ct;
+	struct fc_ns_rff_id *rffid;
+	u32 size = 0;
+
+	node_els_trace();
+
+	size = sizeof(*ct) + sizeof(*rffid);
+
+	els = efct_els_io_alloc(node, size, EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+	} else {
+		els->iparam.fc_ct.r_ctl = FC_RCTL_ELS_REQ;
+		els->iparam.fc_ct.type = FC_TYPE_CT;
+		els->iparam.fc_ct.df_ctl = 0;
+		els->iparam.fc_ct.timeout = timeout_sec;
+
+		els->els_callback = cb;
+		els->els_callback_arg = cbarg;
+		els->display_name = "rffid";
+		ct = els->els_req.virt;
+
+		memset(ct, 0, sizeof(*ct));
+		fcct_build_req_header(ct, FC_NS_RFF_ID, sizeof(*rffid));
+
+		rffid = els->els_req.virt + sizeof(*ct);
+		memset(rffid, 0, sizeof(*rffid));
+
+		hton24(rffid->fr_fid.fp_fid, node->rnode.sport->fc_id);
+		if (node->sport->enable_ini)
+			rffid->fr_feat |= FCP_FEAT_INIT;
+		if (node->sport->enable_tgt)
+			rffid->fr_feat |= FCP_FEAT_TARG;
+		rffid->fr_type = FC_TYPE_FCP;
+
+		els->hio_type = EFCT_HW_FC_CT;
+
+		efct_els_send_req(node, els);
+	}
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a GIDPT CT request.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a GIDPT CT request, and send to the \c node.
+ *
+ * @param node Node to which the GIDPT request is sent.
+ * @param timeout_sec Time, in seconds, to wait before timing out the ELS.
+ * @param retries Number of times to retry errors before reporting a failure.
+ * @param cb Callback function.
+ * @param cbarg Callback function argument.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_ns_send_gidpt(struct efc_node_s *node, u32 timeout_sec,
+		   u32 retries, els_cb_t cb, void *cbarg)
+{
+	struct efct_io_s *els = NULL;
+	struct efct_s *efct = node->efc->base;
+	struct fc_ct_hdr *ct;
+	struct fc_ns_gid_pt *gidpt;
+	u32 size = 0;
+
+	node_els_trace();
+
+	size = sizeof(*ct) + sizeof(*gidpt);
+	els = efct_els_io_alloc_size(node, size,
+				     EFCT_ELS_GID_PT_RSP_LEN,
+				   EFCT_ELS_ROLE_ORIGINATOR);
+	if (!els) {
+		efc_log_err(efct, "IO alloc failed\n");
+		return els;
+	}
+
+	els->iparam.fc_ct.r_ctl = FC_RCTL_ELS_REQ;
+	els->iparam.fc_ct.type = FC_TYPE_CT;
+	els->iparam.fc_ct.df_ctl = 0;
+	els->iparam.fc_ct.timeout = timeout_sec;
+
+	els->els_callback = cb;
+	els->els_callback_arg = cbarg;
+	els->display_name = "gidpt";
+
+	ct = els->els_req.virt;
+
+	memset(ct, 0, sizeof(*ct));
+	fcct_build_req_header(ct, FC_NS_GID_PT, sizeof(*gidpt));
+
+	gidpt = els->els_req.virt + sizeof(*ct);
+	memset(gidpt, 0, sizeof(*gidpt));
+	gidpt->fn_pt_type = FC_TYPE_FCP;
+
+	els->hio_type = EFCT_HW_FC_CT;
+
+	efct_els_send_req(node, els);
+
+	return els;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a BA_ACC given the request's FC header
+ *
+ * <h3 class="desc">Description</h3>
+ * Using the S_ID/D_ID from the request's FC header, generate a BA_ACC.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param hdr Pointer to the FC header.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+//struct efct_io_s *
+void *
+efct_bls_send_acc_hdr(struct efc_lport *efc, struct efc_node_s *node,
+		      struct fc_frame_header *hdr)
+{
+	struct efct_io_s *io = NULL;
+	u16 ox_id = be16_to_cpu(hdr->fh_ox_id);
+	u16 rx_id = be16_to_cpu(hdr->fh_rx_id);
+	u32 d_id = ntoh24(hdr->fh_d_id);
+
+	io = efct_scsi_io_alloc(node, EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return io;
+	}
+
+	return efct_bls_send_acc(io, d_id, ox_id, rx_id);
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a BA_RJT given the request's FC header
+ *
+ * <h3 class="desc">Description</h3>
+ * Using the S_ID/D_ID from the request's FC header, generate a BA_ACC.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param hdr Pointer to the FC header.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+struct efct_io_s *
+efct_bls_send_rjt_hdr(struct efct_io_s *io, struct fc_frame_header *hdr)
+{
+	u16 ox_id = be16_to_cpu(hdr->fh_ox_id);
+	u16 rx_id = be16_to_cpu(hdr->fh_rx_id);
+	u32 d_id = ntoh24(hdr->fh_d_id);
+
+	return efct_bls_send_rjt(io, d_id, ox_id, rx_id);
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a BLS BA_RJT response.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a BLS BA_RJT response, and send to the \c node.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param s_id S_ID to use for the response.
+ * If U32_MAX, then use our SLI port (sport) S_ID.
+ * @param ox_id Originator exchange ID.
+ * @param rx_id Responder exchange ID.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+static struct efct_io_s *
+efct_bls_send_rjt(struct efct_io_s *io, u32 s_id,
+		  u16 ox_id, u16 rx_id)
+{
+	struct efc_node_s *node = io->node;
+	int rc;
+	struct fc_ba_rjt *acc;
+	struct efct_s *efct;
+
+	efct = node->efc->base;
+
+	if (node->rnode.sport->fc_id == s_id)
+		s_id = U32_MAX;
+
+	/* fill out generic fields */
+	io->efct = efct;
+	io->node = node;
+	io->cmd_tgt = true;
+
+	/* fill out BLS Response-specific fields */
+	io->io_type = EFCT_IO_TYPE_BLS_RESP;
+	io->display_name = "ba_rjt";
+	io->hio_type = EFCT_HW_BLS_RJT;
+	io->init_task_tag = ox_id;
+
+	/* fill out iparam fields */
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.bls_sid.ox_id = ox_id;
+	io->iparam.bls_sid.rx_id = rx_id;
+
+	acc = (void *)io->iparam.bls_sid.payload;
+
+	memset(io->iparam.bls_sid.payload, 0,
+	       sizeof(io->iparam.bls_sid.payload));
+	acc->br_reason = ELS_RJT_UNAB;
+	acc->br_explan = ELS_EXPL_NONE;
+
+	rc = efct_scsi_io_dispatch(io, efct_bls_send_rjt_cb);
+	if (rc) {
+		efc_log_err(efct, "efct_scsi_io_dispatch() failed: %d\n", rc);
+		efct_scsi_io_free(io);
+		io = NULL;
+	}
+	return io;
+}
+
+/**
+ * @ingroup els_api
+ * @brief Send a BLS BA_ACC response.
+ *
+ * <h3 class="desc">Description</h3>
+ * Construct a BLS BA_ACC response, and send to the \c node.
+ *
+ * @param io Pointer to a SCSI IO object.
+ * @param s_id S_ID to use for the response.
+ * If U32_MAX, then use our SLI port (sport) S_ID.
+ * @param ox_id Originator exchange ID.
+ * @param rx_id Responder exchange ID.
+ *
+ * @return Returns pointer to IO object, or NULL if error.
+ */
+
+static struct efct_io_s *
+efct_bls_send_acc(struct efct_io_s *io, u32 s_id,
+		  u16 ox_id, u16 rx_id)
+{
+	struct efc_node_s *node = io->node;
+	int rc;
+	struct fc_ba_acc *acc;
+	struct efct_s *efct;
+
+	efct = node->efc->base;
+
+	if (node->rnode.sport->fc_id == s_id)
+		s_id = U32_MAX;
+
+	/* fill out generic fields */
+	io->efct = efct;
+	io->node = node;
+	io->cmd_tgt = true;
+
+	/* fill out BLS Response-specific fields */
+	io->io_type = EFCT_IO_TYPE_BLS_RESP;
+	io->display_name = "ba_acc";
+	io->hio_type = EFCT_HW_BLS_ACC_SID;
+	io->init_task_tag = ox_id;
+
+	/* fill out iparam fields */
+	memset(&io->iparam, 0, sizeof(io->iparam));
+	io->iparam.bls_sid.s_id = s_id;
+	io->iparam.bls_sid.ox_id = ox_id;
+	io->iparam.bls_sid.rx_id = rx_id;
+
+	acc = (void *)io->iparam.bls_sid.payload;
+
+	memset(io->iparam.bls_sid.payload, 0,
+	       sizeof(io->iparam.bls_sid.payload));
+	acc->ba_ox_id = io->iparam.bls_sid.ox_id;
+	acc->ba_rx_id = io->iparam.bls_sid.rx_id;
+	acc->ba_high_seq_cnt = U16_MAX;
+
+	rc = efct_scsi_io_dispatch(io, efct_bls_send_acc_cb);
+	if (rc) {
+		efc_log_err(efct, "efct_scsi_io_dispatch() failed: %d\n", rc);
+		efct_scsi_io_free(io);
+		io = NULL;
+	}
+	return io;
+}
+
+/**
+ * @brief Handle the BLS accept completion.
+ *
+ * <h3 class="desc">Description</h3>
+ * Upon completion of sending a BA_ACC, this callback is invoked by the HW.
+ *
+ * @param hio Pointer to the HW IO object.
+ * @param rnode Pointer to the HW remote node.
+ * @param length Length of the response payload, in bytes.
+ * @param status Completion status.
+ * @param ext_status Extended completion status.
+ * @param app Callback private argument.
+ *
+ * @return Returns 0 on success; or a negative error value on failure.
+ */
+
+static int efct_bls_send_acc_cb(struct efct_hw_io_s *hio,
+				struct efc_remote_node_s *rnode, u32 length,
+		int status, u32 ext_status, void *app)
+{
+	struct efct_io_s *io = app;
+
+	efct_scsi_io_free(io);
+	return 0;
+}
+
+/**
+ * @brief Handle the BLS reject completion.
+ *
+ * <h3 class="desc">Description</h3>
+ * Upon completion of sending a BA_RJT, this callback is invoked by the HW.
+ *
+ * @param hio Pointer to the HW IO object.
+ * @param rnode Pointer to the HW remote node.
+ * @param length Length of the response payload, in bytes.
+ * @param status Completion status.
+ * @param ext_status Extended completion status.
+ * @param app Callback private argument.
+ *
+ * @return Returns 0 on success; or a negative error value on failure.
+ */
+
+static int efct_bls_send_rjt_cb(struct efct_hw_io_s *hio,
+				struct efc_remote_node_s *rnode, u32 length,
+		int status, u32 ext_status, void *app)
+{
+	struct efct_io_s *io = app;
+
+	efct_scsi_io_free(io);
+	return 0;
+}
+
+/**
+ * @brief ELS abort callback.
+ *
+ * <h3 class="desc">Description</h3>
+ * This callback is invoked by the HW when an ELS IO is aborted.
+ *
+ * @param hio Pointer to the HW IO object.
+ * @param rnode Pointer to the HW remote node.
+ * @param length Length of the response payload, in bytes.
+ * @param status Completion status.
+ * @param ext_status Extended completion status.
+ * @param app Callback private argument.
+ *
+ * @return Returns 0 on success; or a negative error value on failure.
+ */
+
+static int
+efct_els_abort_cb(struct efct_hw_io_s *hio, struct efc_remote_node_s *rnode,
+		  u32 length, int status, u32 ext_status,
+		 void *app)
+{
+	struct efct_io_s *els;
+	struct efct_io_s *abort_io = NULL; /* IO structure used to abort ELS */
+	struct efct_s *efct;
+
+	abort_io = app;
+	els = abort_io->io_to_abort;
+
+	if (!els || !els->node || !els->node->efc)
+		return -1;
+
+	efct = els->node->efc->base;
+
+	if (status != 0)
+		efc_log_warn(efct, "status x%x ext x%x\n", status, ext_status);
+
+	/* now free the abort IO */
+	efct_io_pool_io_free(efct->xport->io_pool, abort_io);
+
+	/* send completion event to indicate abort process is complete
+	 * Note: The ELS SM will already be receiving
+	 * ELS_REQ_OK/FAIL/RJT/ABORTED
+	 */
+	if (els->state == EFCT_ELS_REQ_ABORTED) {
+		/* completion for ELS that was aborted */
+		efct_els_abort_cleanup(els);
+	} else {
+		/* completion for abort was received first,
+		 * transition to wait for req cmpl
+		 */
+		els->state = EFCT_ELS_ABORT_IO_COMPL;
+	}
+
+	/* done with ELS IO to abort */
+	kref_put(&els->ref, els->release);
+	return 0;
+}
+
+/**
+ * @brief Abort an ELS IO.
+ *
+ * <h3 class="desc">Description</h3>
+ * The ELS IO is aborted by making a HW abort IO request,
+ * optionally requesting that an ABTS is sent.
+ *
+ * \b Note: This function allocates a HW IO, and associates the HW IO
+ * with the ELS IO that it is aborting. It does not associate
+ * the HW IO with the node directly, like for ELS requests. The
+ * abort completion is propagated up to the node once the
+ * original WQE and the abort WQE are complete (the original WQE
+ * completion is not propagated up to node).
+ *
+ * @param els Pointer to the ELS IO.
+ * @param send_abts Boolean to indicate if hardware will
+ *	automatically generate an ABTS.
+ *
+ * @return Returns pointer to Abort IO object, or NULL if error.
+ */
+
+static struct efct_io_s *
+efct_els_abort_io(struct efct_io_s *els, bool send_abts)
+{
+	struct efct_s *efct;
+	struct efct_xport_s *xport;
+	int rc;
+	struct efct_io_s *abort_io = NULL;
+
+	efct = els->node->efc->base;
+	xport = efct->xport;
+
+	/* take a reference on IO being aborted */
+	if ((kref_get_unless_zero(&els->ref) == 0)) {
+		/* command no longer active */
+		efc_log_debug(efct, "els no longer active\n");
+		return NULL;
+	}
+
+	/* allocate IO structure to send abort */
+	abort_io = efct_io_pool_io_alloc(efct->xport->io_pool);
+	if (!abort_io) {
+		atomic_add_return(1, &xport->io_alloc_failed_count);
+	} else {
+		/* set generic fields */
+		abort_io->efct = efct;
+		abort_io->node = els->node;
+		abort_io->cmd_ini = true;
+
+		/* set type and ABORT-specific fields */
+		abort_io->io_type = EFCT_IO_TYPE_ABORT;
+		abort_io->display_name = "abort_els";
+		abort_io->io_to_abort = els;
+		abort_io->send_abts = send_abts;
+
+		/* now dispatch IO */
+		rc = efct_scsi_io_dispatch_abort(abort_io, efct_els_abort_cb);
+		if (rc) {
+			efc_log_err(efct,
+				     "efct_scsi_io_dispatch failed: %d\n", rc);
+			efct_io_pool_io_free(efct->xport->io_pool, abort_io);
+			abort_io = NULL;
+		}
+	}
+
+	/* if something failed, put reference on ELS to abort */
+	if (!abort_io)
+		kref_put(&els->ref, els->release);
+	return abort_io;
+}
+
+/**
+ * @brief Cleanup an ELS IO
+ *
+ * <h3 class="desc">Description</h3>
+ * Cleans up an ELS IO by posting the requested event to the
+ * owning node object; invoking the callback, if one is
+ * provided; and then freeing the ELS IO object.
+ *
+ * @param els Pointer to the ELS IO.
+ * @param node_evt Node SM event to post.
+ * @param arg Node SM event argument.
+ *
+ * @return None.
+ */
+
+void
+efct_els_io_cleanup(struct efct_io_s *els,
+		    enum efc_hw_node_els_event_e node_evt, void *arg)
+{
+	/* don't want further events that could come; e.g. abort requests
+	 * from the node state machine; thus, disable state machine
+	 */
+	els->els_req_free = true;
+	efc_node_post_els_resp(els->node, node_evt, arg);
+
+	/* If this IO has a callback, invoke it */
+	if (els->els_callback) {
+		(*els->els_callback)(els->node, arg,
+				    els->els_callback_arg);
+	}
+	efct_els_io_free(els);
+}
+
+/**
+ * @brief cleanup ELS after abort
+ *
+ * @param els ELS IO to cleanup
+ *
+ * @return Returns None.
+ */
+
+static void
+efct_els_abort_cleanup(struct efct_io_s *els)
+{
+	/* handle event for ABORT_WQE
+	 * whatever state ELS happened to be in, propagate aborted even
+	 * up to node state machine in lieu of EFC_HW_SRRS_ELS_* event
+	 */
+	struct efc_node_cb_s cbdata;
+
+	cbdata.status = 0;
+	cbdata.ext_status = 0;
+	cbdata.els_rsp = els->els_rsp;
+	els_io_printf(els, "Request aborted\n");
+	efct_els_io_cleanup(els, EFC_HW_ELS_REQ_ABORTED, &cbdata);
+}
+
+/**
+ * @brief return TRUE if given ELS list is empty (while taking proper locks)
+ *
+ * Test if given ELS list is empty while holding the node->active_ios_lock.
+ *
+ * @param node pointer to node object
+ * @param list pointer to list
+ *
+ * @return TRUE if els_io_list is empty
+ */
+
+int
+efct_els_io_list_empty(struct efc_node_s *node, struct list_head *list)
+{
+	int empty;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+		empty = list_empty(list);
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+	return empty;
+}
+
+/**
+ * @brief Handle CT send response completion
+ *
+ * Called when CT response completes, free IO
+ *
+ * @param hio Pointer to the HW IO context that completed.
+ * @param rnode Pointer to the remote node.
+ * @param length Length of the returned payload data.
+ * @param status Status of the completion.
+ * @param ext_status Extended status of the completion.
+ * @param arg Application-specific argument (generally a
+ * pointer to the ELS IO context).
+ *
+ * @return returns 0
+ */
+static int
+efct_ct_acc_cb(struct efct_hw_io_s *hio, struct efc_remote_node_s *rnode,
+	       u32 length, int status, u32 ext_status,
+	      void *arg)
+{
+	struct efct_io_s *io = arg;
+
+	efct_els_io_free(io);
+
+	return 0;
+}
+
+/**
+ * @brief Send CT response
+ *
+ * Sends a CT response frame with payload
+ *
+ * @param io Pointer to the IO context.
+ * @param ox_id Originator exchange ID
+ * @param ct_hdr Pointer to the CT IU
+ * @param cmd_rsp_code CT response code
+ * @param reason_code Reason code
+ * @param reason_code_explanation Reason code explanation
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+int
+efct_send_ct_rsp(struct efc_lport *efc, struct efc_node_s *node, __be16 ox_id,
+		 struct fc_ct_hdr  *ct_hdr, u32 cmd_rsp_code,
+		u32 reason_code, u32 reason_code_explanation)
+{
+	struct efct_io_s *io = NULL;
+	struct fc_ct_hdr  *rsp = NULL;
+
+	io = efct_els_io_alloc(node, 256, EFCT_ELS_ROLE_RESPONDER);
+	if (!io) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return -1;
+	}
+
+	rsp = io->els_rsp.virt;
+	io->io_type = EFCT_IO_TYPE_CT_RESP;
+
+	*rsp = *ct_hdr;
+
+	fcct_build_req_header(rsp, cmd_rsp_code, 0);
+	rsp->ct_reason = reason_code;
+	rsp->ct_explan = reason_code_explanation;
+
+	io->display_name = "ct response";
+	io->init_task_tag = ox_id;
+	io->wire_len += sizeof(*rsp);
+
+	memset(&io->iparam, 0, sizeof(io->iparam));
+
+	io->io_type = EFCT_IO_TYPE_CT_RESP;
+	io->hio_type = EFCT_HW_FC_CT_RSP;
+	io->iparam.fc_ct_rsp.ox_id = cpu_to_be16(ox_id);
+	io->iparam.fc_ct_rsp.r_ctl = 3;
+	io->iparam.fc_ct_rsp.type = FC_TYPE_CT;
+	io->iparam.fc_ct_rsp.df_ctl = 0;
+	io->iparam.fc_ct_rsp.timeout = 5;
+
+	if (efct_scsi_io_dispatch(io, efct_ct_acc_cb) < 0) {
+		efct_els_io_free(io);
+		return -1;
+	}
+	return 0;
+}
+
+static void
+efct_els_retry(struct efct_io_s *els)
+{
+	struct efct_s *efct;
+	struct efc_node_cb_s cbdata;
+
+	efct = els->node->efc->base;
+	cbdata.status = INT_MAX;
+	cbdata.ext_status = INT_MAX;
+	cbdata.els_rsp = els->els_rsp;
+
+	if (!els->els_retries_remaining) {
+		efc_log_err(efct, "ELS retries exhausted\n");
+		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
+				    &cbdata);
+		return;
+	}
+
+	els->els_retries_remaining--;
+	 /* Free the HW IO so that a new oxid is used.*/
+	if (els->hio) {
+		efct_hw_io_free(&efct->hw, els->hio);
+		els->hio = NULL;
+	}
+
+	efct_els_send_req(els->node, els);
+}
+
+/**
+ * @brief Handle delay retry timeout
+ *
+ * Callback is invoked when the delay retry timer expires.
+ *
+ * @param arg pointer to the ELS IO object
+ *
+ * @return none
+ */
+static void
+efct_els_delay_timer_cb(struct timer_list *t)
+{
+	struct efct_io_s *els = from_timer(els, t, delay_timer);
+	struct efc_node_s *node = els->node;
+
+	/* Retry delay timer expired, retry the ELS request,
+	 * Free the HW IO so that a new oxid is used.
+	 */
+	if (els->state == EFCT_ELS_REQUEST_DELAY_ABORT) {
+		node->els_req_cnt++;
+		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
+					    NULL);
+	} else {
+		efct_els_retry(els);
+	}
+
+}
diff --git a/drivers/scsi/elx/efct/efct_els.h b/drivers/scsi/elx/efct/efct_els.h
new file mode 100644
index 000000000000..19fbfcb77f78
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_els.h
@@ -0,0 +1,139 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_ELS_H__)
+#define __EFCT_ELS_H__
+
+enum efct_els_role_e {
+	EFCT_ELS_ROLE_ORIGINATOR,
+	EFCT_ELS_ROLE_RESPONDER,
+};
+
+void _efct_els_io_free(struct kref *arg);
+extern struct efct_io_s *
+efct_els_io_alloc(struct efc_node_s *node, u32 reqlen,
+		  enum efct_els_role_e role);
+extern struct efct_io_s *
+efct_els_io_alloc_size(struct efc_node_s *node, u32 reqlen,
+		       u32 rsplen,
+				       enum efct_els_role_e role);
+void efct_els_io_free(struct efct_io_s *els);
+
+extern void *
+efct_els_req_send(struct efc_lport *efc, struct efc_node_s *node,
+		  u32 cmd, u32 timeout_sec, u32 retries);
+extern void *
+efct_els_send_ct(struct efc_lport *efc, struct efc_node_s *node,
+		 u32 cmd, u32 timeout_sec, u32 retries);
+extern void *
+efct_els_resp_send(struct efc_lport *efc, struct efc_node_s *node,
+		   u32 cmd, u16 ox_id);
+void
+efct_els_abort(struct efct_io_s *els, struct efc_node_cb_s *arg);
+/* ELS command send */
+typedef void (*els_cb_t)(struct efc_node_s *node,
+			 struct efc_node_cb_s *cbdata, void *arg);
+extern struct efct_io_s *
+efct_send_plogi(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_flogi(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_fdisc(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_prli(struct efc_node_s *node, u32 timeout_sec,
+	       u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_prlo(struct efc_node_s *node, u32 timeout_sec,
+	       u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_logo(struct efc_node_s *node, u32 timeout_sec,
+	       u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_adisc(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_pdisc(struct efc_node_s *node, u32 timeout_sec,
+		u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_scr(struct efc_node_s *node, u32 timeout_sec,
+	      u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_rrq(struct efc_node_s *node, u32 timeout_sec,
+	      u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_ns_send_rftid(struct efc_node_s *node,
+		   u32 timeout_sec,
+		  u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_ns_send_rffid(struct efc_node_s *node,
+		   u32 timeout_sec,
+		  u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_ns_send_gidpt(struct efc_node_s *node, u32 timeout_sec,
+		   u32 retries, els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_rscn(struct efc_node_s *node, u32 timeout_sec,
+	       u32 retries, void *port_ids,
+	      u32 port_ids_count, els_cb_t cb, void *cbarg);
+extern void
+efct_els_io_cleanup(struct efct_io_s *els, enum efc_hw_node_els_event_e,
+		    void *arg);
+
+/* ELS acc send */
+extern struct efct_io_s *
+efct_send_ls_acc(struct efc_node_s *node, u32 ox_id,
+		 els_cb_t cb, void *cbarg);
+
+extern void *
+efct_send_ls_rjt(struct efc_lport *efc, struct efc_node_s *node, u32 ox_id,
+		 u32 reason_cod, u32 reason_code_expl,
+		u32 vendor_unique);
+extern void *
+efct_send_flogi_p2p_acc(struct efc_lport *efc, struct efc_node_s *node,
+			u32 ox_id, u32 s_id);
+extern struct efct_io_s *
+efct_send_flogi_acc(struct efc_node_s *node, u32 ox_id,
+		    u32 is_fport, els_cb_t cb,
+		   void *cbarg);
+extern struct efct_io_s *
+efct_send_plogi_acc(struct efc_node_s *node, u32 ox_id,
+		    els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_prli_acc(struct efc_node_s *node, u32 ox_id,
+		   els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_logo_acc(struct efc_node_s *node, u32 ox_id,
+		   els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_prlo_acc(struct efc_node_s *node, u32 ox_id,
+		   els_cb_t cb, void *cbarg);
+extern struct efct_io_s *
+efct_send_adisc_acc(struct efc_node_s *node, u32 ox_id,
+		    els_cb_t cb, void *cbarg);
+
+/* BLS acc send */
+extern void *
+efct_bls_send_acc_hdr(struct efc_lport *efc, struct efc_node_s *node,
+		      struct fc_frame_header *hdr);
+/* BLS rjt send */
+extern struct efct_io_s *
+efct_bls_send_rjt_hdr(struct efct_io_s *io, struct fc_frame_header *hdr);
+
+/* Misc */
+extern int
+efct_els_io_list_empty(struct efc_node_s *node, struct list_head *list);
+
+/* CT */
+extern int
+efct_send_ct_rsp(struct efc_lport *efc, struct efc_node_s *node, __be16 ox_id,
+		 struct fc_ct_hdr *ct_hdr,
+		u32 cmd_rsp_code, u32 reason_code,
+		u32 reason_code_explanation);
+
+#endif /* __EFCT_ELS_H__ */
-- 
2.13.7

