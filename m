Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1041CC4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8E9920838
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MqqY1DmF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390632AbgJLWwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390607AbgJLWwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:14 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E160C0613D5
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:14 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b26so15128299pff.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=aIBYL/29Hg0znowBekH8V2SoqpR3J3ZFsoDXBM5xXQw=;
        b=MqqY1DmFPLvRCC25fJRgksNQA/rtPqJtwHRkLik56F9ycnCRVJeSA/ps4lsvTsM0RD
         Oyec4OiZtpjufFCDRJGSvKw9jSVr5Uyb9e0L8u79jxTARyh0fzfhZfHcETervZSugUr2
         7Cn5d3BI2LJY1PjMJNaLxQq2zqldLK5Zw3oDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=aIBYL/29Hg0znowBekH8V2SoqpR3J3ZFsoDXBM5xXQw=;
        b=OKN60+vDesykkaGHwZnX2bNZy3PlILeSKuJZJAE86Au4rAAt0TiUmbGlHPueFusly6
         TghgcHYSb+Ea0yvJZ3twosaRCnLc199A8bQNpN9CGMxGY9QIxAa58bxs/ly5t6lC39au
         u0KOe3tUF5eKncAnhVNfOm9YceaYbeaPvtC4sh7A9p5t8ee830mOQ8gATSAwSdBHEAXn
         83lI9ye8lVVjpEh6iDbpiSO1t9JVrjeRuAybdeFKUcNMb3sxCELzBgH8hFVVJsdNPV3W
         SBkNo+4ba5j04LrIBs4fMSJdE2+ElT0nQs/gYRVn7PfwAXxJxckgvnG2p/n5titvqvSq
         OCVA==
X-Gm-Message-State: AOAM531c5MIGwq4G20qsuC08IdgVsXjda1IcahlQDKl4NUu8bsfewTEI
        bDbJIP8hUX/si9fty9W1HTz5AtP9jkAZ2zECepbu1zC0lVLFss/YGTHWFPUJ63fW+lvjstc2d4z
        uxyT1nMyFMmWVOmI71Gurxq2halNYacOfDjJrDj8T+uohN9Z2BQ5J8++XJ/2bG7rIsN4hYE4UDD
        hqTG4=
X-Google-Smtp-Source: ABdhPJwxlfw3JC/Sackq8nnsPweU8C20NKzqKS+hw4xdMZNrrUDjg+ERoUEF5i8lHQTy/YiDY7f6WQ==
X-Received: by 2002:a17:90a:fa86:: with SMTP id cu6mr12967194pjb.167.1602543132702;
        Mon, 12 Oct 2020 15:52:12 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:11 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 12/31] elx: libefc: Remote node state machine interfaces
Date:   Mon, 12 Oct 2020 15:51:28 -0700
Message-Id: <20201012225147.54404-13-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003658dd05b1812619"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003658dd05b1812619
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the libefc library population.

This patch adds library interface definitions for:
- Remote node (aka remote port) allocation, initializaion and
  destroy routines.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Upon received PRLI, Wait for LIO session registation before sending the
     PRLI response.
  Changes to call new els functions.
---
 drivers/scsi/elx/libefc/efc_node.c | 1157 ++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_node.h |  191 +++++
 2 files changed, 1348 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_node.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.h

diff --git a/drivers/scsi/elx/libefc/efc_node.c b/drivers/scsi/elx/libefc/efc_node.c
new file mode 100644
index 000000000000..9d9404eee216
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_node.c
@@ -0,0 +1,1157 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efc.h"
+
+int
+efc_remote_node_cb(void *arg, int event,
+		   void *data)
+{
+	struct efc *efc = arg;
+	enum efc_sm_event sm_event = EFC_EVT_LAST;
+	struct efc_remote_node *rnode = data;
+	struct efc_node *node = rnode->node;
+	unsigned long flags = 0;
+
+	/* HW node callback events from the user driver */
+	switch (event) {
+	case EFC_HW_NODE_ATTACH_OK:
+		sm_event = EFC_EVT_NODE_ATTACH_OK;
+		break;
+
+	case EFC_HW_NODE_ATTACH_FAIL:
+		sm_event = EFC_EVT_NODE_ATTACH_FAIL;
+		break;
+
+	case EFC_HW_NODE_FREE_OK:
+		sm_event = EFC_EVT_NODE_FREE_OK;
+		break;
+
+	case EFC_HW_NODE_FREE_FAIL:
+		sm_event = EFC_EVT_NODE_FREE_FAIL;
+		break;
+
+	default:
+		efc_log_test(efc, "unhandled event %#x\n", event);
+		return EFC_FAIL;
+	}
+
+	spin_lock_irqsave(&efc->lock, flags);
+	efc_node_post_event(node, sm_event, NULL);
+	spin_unlock_irqrestore(&efc->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+struct efc_node *
+efc_node_find(struct efc_nport *nport, u32 port_id)
+{
+	/* Find an FC node structure given the FC port ID */
+	return xa_load(&nport->lookup, port_id);
+}
+
+static void
+_efc_node_free(struct kref *arg)
+{
+	struct efc_node *node = container_of(arg, struct efc_node, ref);
+	struct efc *efc = node->efc;
+	struct efc_dma *dma;
+
+	dma = &node->sparm_dma_buf;
+	dma_pool_free(efc->node_dma_pool, dma->virt, dma->phys);
+	memset(dma, 0, sizeof(struct efc_dma));
+	mempool_free(node, efc->node_pool);
+}
+
+struct efc_node *efc_node_alloc(struct efc_nport *nport,
+				  u32 port_id, bool init, bool targ)
+{
+	int rc;
+	struct efc_node *node = NULL;
+	struct efc *efc = nport->efc;
+	struct efc_dma *dma;
+
+	if (nport->shutting_down) {
+		efc_log_debug(efc, "node allocation when shutting down %06x",
+			      port_id);
+		return NULL;
+	}
+
+	node = mempool_alloc(efc->node_pool, GFP_ATOMIC);
+	if (!node) {
+		efc_log_err(efc, "node allocation failed %06x", port_id);
+		return NULL;
+	}
+	memset(node, 0, sizeof(*node));
+
+	dma = &node->sparm_dma_buf;
+	dma->size = NODE_SPARAMS_SIZE;
+	dma->virt = dma_pool_zalloc(efc->node_dma_pool, GFP_ATOMIC, &dma->phys);
+	if (!dma->virt) {
+		efc_log_err(efc, "node dma alloc failed\n");
+		goto dma_fail;
+	}
+	node->rnode.indicator = U32_MAX;
+	node->nport = nport;
+	INIT_LIST_HEAD(&node->list_entry);
+	list_add_tail(&node->list_entry, &nport->node_list);
+
+	node->efc = efc;
+	node->init = init;
+	node->targ = targ;
+
+	spin_lock_init(&node->pend_frames_lock);
+	INIT_LIST_HEAD(&node->pend_frames);
+	spin_lock_init(&node->els_ios_lock);
+	INIT_LIST_HEAD(&node->els_ios_list);
+	efc_io_alloc_enable(node);
+
+	rc = efc_cmd_node_alloc(efc, &node->rnode, port_id, nport);
+	if (rc) {
+		efc_log_err(efc, "efc_hw_node_alloc failed: %d\n", rc);
+		goto hw_alloc_fail;
+	}
+
+	node->rnode.node = node;
+	node->sm.app = node;
+	node->evtdepth = 0;
+
+	efc_node_update_display_name(node);
+
+	rc = xa_err(xa_store(&nport->lookup, port_id, node, GFP_ATOMIC));
+	if (rc) {
+		efc_log_err(efc, "Node lookup store failed: %d\n", rc);
+		goto xa_fail;
+	}
+
+	/* initialize refcount */
+	kref_init(&node->ref);
+	node->release = _efc_node_free;
+	kref_get(&nport->ref);
+
+	return node;
+
+xa_fail:
+	efc_node_free_resources(efc, &node->rnode);
+hw_alloc_fail:
+	list_del(&node->list_entry);
+	dma_pool_free(efc->node_dma_pool, dma->virt, dma->phys);
+dma_fail:
+	mempool_free(node, efc->node_pool);
+	return NULL;
+}
+
+void
+efc_node_free(struct efc_node *node)
+{
+	struct efc_nport *nport;
+	struct efc *efc;
+	int rc = 0;
+	struct efc_node *ns = NULL;
+
+	nport = node->nport;
+	efc = node->efc;
+
+	node_printf(node, "Free'd\n");
+
+	if (node->refound) {
+		/*
+		 * Save the name server node. We will send fake RSCN event at
+		 * the end to handle ignored RSCN event during node deletion
+		 */
+		ns = efc_node_find(node->nport, FC_FID_DIR_SERV);
+	}
+
+	if (!node->nport) {
+		efc_log_err(efc, "Node already Freed\n");
+		return;
+	}
+
+	list_del(&node->list_entry);
+
+	/* Free HW resources */
+	rc = efc_node_free_resources(efc, &node->rnode);
+	if (EFC_HW_RTN_IS_ERROR(rc))
+		efc_log_err(efc, "efc_hw_node_free failed: %d\n", rc);
+
+	/* if the gidpt_delay_timer is still running, then delete it */
+	if (timer_pending(&node->gidpt_delay_timer))
+		del_timer(&node->gidpt_delay_timer);
+
+	xa_erase(&nport->lookup, node->rnode.fc_id);
+
+	/*
+	 * If the node_list is empty,
+	 * then post a ALL_CHILD_NODES_FREE event to the nport,
+	 * after the lock is released.
+	 * The nport may be free'd as a result of the event.
+	 */
+	if (list_empty(&nport->node_list))
+		efc_sm_post_event(&nport->sm, EFC_EVT_ALL_CHILD_NODES_FREE,
+				  NULL);
+
+	node->nport = NULL;
+	node->sm.current_state = NULL;
+
+	kref_put(&nport->ref, nport->release);
+	kref_put(&node->ref, node->release);
+
+	if (ns) {
+		/* sending fake RSCN event to name server node */
+		efc_node_post_event(ns, EFC_EVT_RSCN_RCVD, NULL);
+	}
+}
+
+static void
+efc_dma_copy_in(struct efc_dma *dma, void *buffer, u32 buffer_length)
+{
+	if (!dma || !buffer || !buffer_length)
+		return;
+
+	if (buffer_length > dma->size)
+		buffer_length = dma->size;
+
+	memcpy(dma->virt, buffer, buffer_length);
+	dma->len = buffer_length;
+}
+
+int
+efc_node_attach(struct efc_node *node)
+{
+	int rc = 0;
+	struct efc_nport *nport = node->nport;
+	struct efc_domain *domain = nport->domain;
+	struct efc *efc = node->efc;
+
+	if (!domain->attached) {
+		efc_log_err(efc, "Warning: unattached domain\n");
+		return EFC_FAIL;
+	}
+	/* Update node->wwpn/wwnn */
+
+	efc_node_build_eui_name(node->wwpn, sizeof(node->wwpn),
+				efc_node_get_wwpn(node));
+	efc_node_build_eui_name(node->wwnn, sizeof(node->wwnn),
+				efc_node_get_wwnn(node));
+
+	efc_dma_copy_in(&node->sparm_dma_buf, node->service_params + 4,
+			sizeof(node->service_params) - 4);
+
+	/* take lock to protect node->rnode.attached */
+	rc = efc_cmd_node_attach(efc, &node->rnode, &node->sparm_dma_buf);
+	if (EFC_HW_RTN_IS_ERROR(rc))
+		efc_log_test(efc, "efc_hw_node_attach failed: %d\n", rc);
+
+	return rc;
+}
+
+void
+efc_node_fcid_display(u32 fc_id, char *buffer, u32 buffer_length)
+{
+	switch (fc_id) {
+	case FC_FID_FLOGI:
+		snprintf(buffer, buffer_length, "fabric");
+		break;
+	case FC_FID_FCTRL:
+		snprintf(buffer, buffer_length, "fabctl");
+		break;
+	case FC_FID_DIR_SERV:
+		snprintf(buffer, buffer_length, "nserve");
+		break;
+	default:
+		if (fc_id == FC_FID_DOM_MGR) {
+			snprintf(buffer, buffer_length, "dctl%02x",
+				 (fc_id & 0x0000ff));
+		} else {
+			snprintf(buffer, buffer_length, "%06x", fc_id);
+		}
+		break;
+	}
+}
+
+void
+efc_node_update_display_name(struct efc_node *node)
+{
+	u32 port_id = node->rnode.fc_id;
+	struct efc_nport *nport = node->nport;
+	char portid_display[16];
+
+	efc_node_fcid_display(port_id, portid_display, sizeof(portid_display));
+
+	snprintf(node->display_name, sizeof(node->display_name), "%s.%s",
+		 nport->display_name, portid_display);
+}
+
+void
+efc_node_send_ls_io_cleanup(struct efc_node *node)
+{
+	if (node->send_ls_acc != EFC_NODE_SEND_LS_ACC_NONE) {
+		efc_log_debug(node->efc, "[%s] cleaning up LS_ACC oxid=0x%x\n",
+			      node->display_name, node->ls_acc_oxid);
+
+		node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
+		node->ls_acc_io = NULL;
+	}
+}
+
+static void efc_node_handle_implicit_logo(struct efc_node *node)
+{
+	int rc;
+
+	/*
+	 * currently, only case for implicit logo is PLOGI
+	 * recvd. Thus, node's ELS IO pending list won't be
+	 * empty (PLOGI will be on it)
+	 */
+	WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_PLOGI);
+	node_printf(node, "Reason: implicit logout, re-authenticate\n");
+
+	/* Re-attach node with the same HW node resources */
+	node->req_free = false;
+	rc = efc_node_attach(node);
+	efc_node_transition(node, __efc_d_wait_node_attach, NULL);
+
+	if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+		efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK, NULL);
+
+}
+
+static void efc_node_handle_explicit_logo(struct efc_node *node)
+{
+	s8 pend_frames_empty;
+	unsigned long flags = 0;
+
+	/* cleanup any pending LS_ACC ELSs */
+	efc_node_send_ls_io_cleanup(node);
+
+	spin_lock_irqsave(&node->pend_frames_lock, flags);
+	pend_frames_empty = list_empty(&node->pend_frames);
+	spin_unlock_irqrestore(&node->pend_frames_lock, flags);
+
+	/*
+	 * there are two scenarios where we want to keep
+	 * this node alive:
+	 * 1. there are pending frames that need to be
+	 *    processed or
+	 * 2. we're an initiator and the remote node is
+	 *    a target and we need to re-authenticate
+	 */
+	node_printf(node, "Shutdown: explicit logo pend=%d ",
+			  !pend_frames_empty);
+	node_printf(node, "nport.ini=%d node.tgt=%d\n",
+			  node->nport->enable_ini, node->targ);
+	if (!pend_frames_empty || (node->nport->enable_ini && node->targ)) {
+		u8 send_plogi = false;
+
+		if (node->nport->enable_ini && node->targ) {
+			/*
+			 * we're an initiator and
+			 * node shutting down is a target;
+			 * we'll need to re-authenticate in
+			 * initial state
+			 */
+			send_plogi = true;
+		}
+
+		/*
+		 * transition to __efc_d_init
+		 * (will retain HW node resources)
+		 */
+		node->req_free = false;
+
+		/*
+		 * either pending frames exist,
+		 * or we're re-authenticating with PLOGI
+		 * (or both); in either case,
+		 * return to initial state
+		 */
+		efc_node_init_device(node, send_plogi);
+	}
+	/* else: let node shutdown occur */
+}
+
+static void
+efc_node_purge_pending(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
+	struct efc_hw_sequence *frame, *next;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->pend_frames_lock, flags);
+
+	list_for_each_entry_safe(frame, next, &node->pend_frames, list_entry) {
+		list_del(&frame->list_entry);
+		efc->tt.hw_seq_free(efc, frame);
+	}
+
+	spin_unlock_irqrestore(&node->pend_frames_lock, flags);
+}
+
+void
+__efc_node_shutdown(struct efc_sm_ctx *ctx,
+		    enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		efc_node_hold_frames(node);
+		WARN_ON(!efc_els_io_list_empty(node, &node->els_ios_list));
+		/* by default, we will be freeing node after we unwind */
+		node->req_free = true;
+
+		switch (node->shutdown_reason) {
+		case EFC_NODE_SHUTDOWN_IMPLICIT_LOGO:
+			/* Node shutdown b/c of PLOGI received when node
+			 * already logged in. We have PLOGI service
+			 * parameters, so submit node attach; we won't be
+			 * freeing this node
+			 */
+
+			efc_node_handle_implicit_logo(node);
+			break;
+
+		case EFC_NODE_SHUTDOWN_EXPLICIT_LOGO:
+			efc_node_handle_explicit_logo(node);
+			break;
+
+		case EFC_NODE_SHUTDOWN_DEFAULT:
+		default: {
+			/*
+			 * shutdown due to link down,
+			 * node going away (xport event) or
+			 * nport shutdown, purge pending and
+			 * proceed to cleanup node
+			 */
+
+			/* cleanup any pending LS_ACC ELSs */
+			efc_node_send_ls_io_cleanup(node);
+
+			node_printf(node,
+				    "Shutdown reason: default, purge pending\n");
+			efc_node_purge_pending(node);
+			break;
+		}
+		}
+
+		break;
+	}
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	default:
+		__efc_node_common(__func__, ctx, evt, arg);
+	}
+}
+
+static bool
+efc_node_check_els_quiesced(struct efc_node *node)
+{
+	/* check to see if ELS requests, completions are quiesced */
+	if (node->els_req_cnt == 0 && node->els_cmpl_cnt == 0 &&
+	    efc_els_io_list_empty(node, &node->els_ios_list)) {
+		if (!node->attached) {
+			/* hw node detach already completed, proceed */
+			node_printf(node, "HW node not attached\n");
+			efc_node_transition(node,
+					    __efc_node_wait_ios_shutdown,
+					     NULL);
+		} else {
+			/*
+			 * hw node detach hasn't completed,
+			 * transition and wait
+			 */
+			node_printf(node, "HW node still attached\n");
+			efc_node_transition(node, __efc_node_wait_node_free,
+					    NULL);
+		}
+		return true;
+	}
+	return false;
+}
+
+void
+efc_node_initiate_cleanup(struct efc_node *node)
+{
+	/*
+	 * if ELS's have already been quiesced, will move to next state
+	 * if ELS's have not been quiesced, abort them
+	 */
+	if (!efc_node_check_els_quiesced(node)) {
+		efc_node_hold_frames(node);
+		efc_node_transition(node, __efc_node_wait_els_shutdown, NULL);
+	}
+}
+
+void
+__efc_node_wait_els_shutdown(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg)
+{
+	bool check_quiesce = false;
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+	/* Node state machine: Wait for all ELSs to complete */
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		efc_node_hold_frames(node);
+		if (efc_els_io_list_empty(node, &node->els_ios_list)) {
+			node_printf(node, "All ELS IOs complete\n");
+			check_quiesce = true;
+		}
+		break;
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_OK:
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+	case EFC_EVT_ELS_REQ_ABORTED:
+		if (WARN_ON(!node->els_req_cnt))
+			break;
+		node->els_req_cnt--;
+		check_quiesce = true;
+		break;
+
+	case EFC_EVT_SRRS_ELS_CMPL_OK:
+	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
+		if (WARN_ON(!node->els_cmpl_cnt))
+			break;
+		node->els_cmpl_cnt--;
+		check_quiesce = true;
+		break;
+
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		/* all ELS IO's complete */
+		node_printf(node, "All ELS IOs complete\n");
+		WARN_ON(!efc_els_io_list_empty(node, &node->els_ios_list));
+		check_quiesce = true;
+		break;
+
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+		check_quiesce = true;
+		break;
+
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		/* don't care about domain_attach_ok */
+		break;
+
+	/* ignore shutdown events as we're already in shutdown path */
+	case EFC_EVT_SHUTDOWN:
+		/* have default shutdown event take precedence */
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		fallthrough;
+
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		break;
+
+	default:
+		__efc_node_common(__func__, ctx, evt, arg);
+	}
+
+	if (check_quiesce)
+		efc_node_check_els_quiesced(node);
+}
+
+void
+__efc_node_wait_node_free(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		efc_node_hold_frames(node);
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_NODE_FREE_OK:
+		/* node is officially no longer attached */
+		node->attached = false;
+		efc_node_transition(node, __efc_node_wait_ios_shutdown, NULL);
+		break;
+
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+		/* As IOs and ELS IO's complete we expect to get these events */
+		break;
+
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		/* don't care about domain_attach_ok */
+		break;
+
+	/* ignore shutdown events as we're already in shutdown path */
+	case EFC_EVT_SHUTDOWN:
+		/* have default shutdown event take precedence */
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		fallthrough;
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		break;
+	default:
+		__efc_node_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_node_wait_ios_shutdown(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = ctx->app;
+	struct efc *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		efc_node_hold_frames(node);
+
+		/* first check to see if no ELS IOs are outstanding */
+		if (efc_els_io_list_empty(node, &node->els_ios_list))
+			/* If there are any active IOS, Free them. */
+			efc_node_transition(node, __efc_node_shutdown, NULL);
+		break;
+
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		if (efc_els_io_list_empty(node, &node->els_ios_list))
+			efc_node_transition(node, __efc_node_shutdown, NULL);
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:
+		/* Can happen as ELS IO IO's complete */
+		if (WARN_ON(!node->els_req_cnt))
+			break;
+		node->els_req_cnt--;
+		break;
+
+	/* ignore shutdown events as we're already in shutdown path */
+	case EFC_EVT_SHUTDOWN:
+		/* have default shutdown event take precedence */
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		fallthrough;
+
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		efc_log_debug(efc, "[%s] %-20s\n", node->display_name,
+			      efc_sm_event_name(evt));
+		break;
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		/* don't care about domain_attach_ok */
+		break;
+	default:
+		__efc_node_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_node_common(const char *funcname, struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = NULL;
+	struct efc *efc = NULL;
+	struct efc_node_cb *cbdata = arg;
+
+	node = ctx->app;
+	efc = node->efc;
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+	case EFC_EVT_REENTER:
+	case EFC_EVT_EXIT:
+	case EFC_EVT_SPORT_TOPOLOGY_NOTIFY:
+	case EFC_EVT_NODE_MISSING:
+	case EFC_EVT_FCP_CMD_RCVD:
+		break;
+
+	case EFC_EVT_NODE_REFOUND:
+		node->refound = true;
+		break;
+
+	/*
+	 * node->attached must be set appropriately
+	 * for all node attach/detach events
+	 */
+	case EFC_EVT_NODE_ATTACH_OK:
+		node->attached = true;
+		break;
+
+	case EFC_EVT_NODE_FREE_OK:
+	case EFC_EVT_NODE_ATTACH_FAIL:
+		node->attached = false;
+		break;
+
+	/*
+	 * handle any ELS completions that
+	 * other states either didn't care about
+	 * or forgot about
+	 */
+	case EFC_EVT_SRRS_ELS_CMPL_OK:
+	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
+		if (WARN_ON(!node->els_cmpl_cnt))
+			break;
+		node->els_cmpl_cnt--;
+		break;
+
+	/*
+	 * handle any ELS request completions that
+	 * other states either didn't care about
+	 * or forgot about
+	 */
+	case EFC_EVT_SRRS_ELS_REQ_OK:
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+	case EFC_EVT_ELS_REQ_ABORTED:
+		if (WARN_ON(!node->els_req_cnt))
+			break;
+		node->els_req_cnt--;
+		break;
+
+	case EFC_EVT_ELS_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		/*
+		 * Unsupported ELS was received,
+		 * send LS_RJT, command not supported
+		 */
+		efc_log_debug(efc,
+			      "[%s] (%s) ELS x%02x, LS_RJT not supported\n",
+			      node->display_name, funcname,
+			      ((uint8_t *)cbdata->payload->dma.virt)[0]);
+
+		efc_send_ls_rjt(node, be16_to_cpu(hdr->fh_ox_id),
+				ELS_RJT_UNSUP, ELS_EXPL_NONE, 0);
+		break;
+	}
+
+	case EFC_EVT_PLOGI_RCVD:
+	case EFC_EVT_FLOGI_RCVD:
+	case EFC_EVT_LOGO_RCVD:
+	case EFC_EVT_PRLI_RCVD:
+	case EFC_EVT_PRLO_RCVD:
+	case EFC_EVT_PDISC_RCVD:
+	case EFC_EVT_FDISC_RCVD:
+	case EFC_EVT_ADISC_RCVD:
+	case EFC_EVT_RSCN_RCVD:
+	case EFC_EVT_SCR_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		/* sm: / send ELS_RJT */
+		efc_log_debug(efc, "[%s] (%s) %s sending ELS_RJT\n",
+			      node->display_name, funcname,
+			      efc_sm_event_name(evt));
+		/* if we didn't catch this in a state, send generic LS_RJT */
+		efc_send_ls_rjt(node, be16_to_cpu(hdr->fh_ox_id),
+				ELS_RJT_UNAB, ELS_EXPL_NONE, 0);
+		break;
+	}
+	case EFC_EVT_ABTS_RCVD: {
+		efc_log_debug(efc, "[%s] (%s) %s sending BA_ACC\n",
+			      node->display_name, funcname,
+			      efc_sm_event_name(evt));
+
+		/* sm: / send BA_ACC */
+		efc_send_bls_acc(node, cbdata->header->dma.virt);
+		break;
+	}
+
+	default:
+		efc_log_test(node->efc, "[%s] %-20s %-20s not handled\n",
+			     node->display_name, funcname,
+			     efc_sm_event_name(evt));
+	}
+}
+
+void
+efc_node_save_sparms(struct efc_node *node, void *payload)
+{
+	memcpy(node->service_params, payload, sizeof(node->service_params));
+}
+
+void
+efc_node_post_event(struct efc_node *node,
+		    enum efc_sm_event evt, void *arg)
+{
+	bool free_node = false;
+
+	node->evtdepth++;
+
+	efc_sm_post_event(&node->sm, evt, arg);
+
+	/* If our event call depth is one and
+	 * we're not holding frames
+	 * then we can dispatch any pending frames.
+	 * We don't want to allow the efc_process_node_pending()
+	 * call to recurse.
+	 */
+	if (!node->hold_frames && node->evtdepth == 1)
+		efc_process_node_pending(node);
+
+	node->evtdepth--;
+
+	/*
+	 * Free the node object if so requested,
+	 * and we're at an event call depth of zero
+	 */
+	if (node->evtdepth == 0 && node->req_free)
+		free_node = true;
+
+	if (free_node)
+		efc_node_free(node);
+}
+
+void
+efc_node_transition(struct efc_node *node,
+		    void (*state)(struct efc_sm_ctx *,
+				   enum efc_sm_event, void *), void *data)
+{
+	struct efc_sm_ctx *ctx = &node->sm;
+
+	if (ctx->current_state == state) {
+		efc_node_post_event(node, EFC_EVT_REENTER, data);
+	} else {
+		efc_node_post_event(node, EFC_EVT_EXIT, data);
+		ctx->current_state = state;
+		efc_node_post_event(node, EFC_EVT_ENTER, data);
+	}
+}
+
+void
+efc_node_build_eui_name(char *buf, u32 buf_len, uint64_t eui_name)
+{
+	memset(buf, 0, buf_len);
+
+	snprintf(buf, buf_len, "eui.%016llX", (unsigned long long)eui_name);
+}
+
+u64
+efc_node_get_wwpn(struct efc_node *node)
+{
+	struct fc_els_flogi *sp =
+			(struct fc_els_flogi *)node->service_params;
+
+	return be64_to_cpu(sp->fl_wwpn);
+}
+
+u64
+efc_node_get_wwnn(struct efc_node *node)
+{
+	struct fc_els_flogi *sp =
+			(struct fc_els_flogi *)node->service_params;
+
+	return be64_to_cpu(sp->fl_wwnn);
+}
+
+int
+efc_node_check_els_req(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg,
+		uint8_t cmd, void (*efc_node_common_func)(const char *,
+				struct efc_sm_ctx *, enum efc_sm_event, void *),
+		const char *funcname)
+{
+	return 0;
+}
+
+int
+efc_node_check_ns_req(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg,
+		uint16_t cmd, void (*efc_node_common_func)(const char *,
+				struct efc_sm_ctx *, enum efc_sm_event, void *),
+		const char *funcname)
+{
+	return 0;
+}
+
+int
+efc_els_io_list_empty(struct efc_node *node, struct list_head *list)
+{
+	int empty;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->els_ios_lock, flags);
+	empty = list_empty(list);
+	spin_unlock_irqrestore(&node->els_ios_lock, flags);
+	return empty;
+}
+
+void
+efc_node_pause(struct efc_node *node,
+	       void (*state)(struct efc_sm_ctx *,
+			      enum efc_sm_event, void *))
+
+{
+	node->nodedb_state = state;
+	efc_node_transition(node, __efc_node_paused, NULL);
+}
+
+void
+__efc_node_paused(struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	/*
+	 * This state is entered when a state is "paused". When resumed, the
+	 * node is transitioned to a previously saved state (node->ndoedb_state)
+	 */
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		node_printf(node, "Paused\n");
+		break;
+
+	case EFC_EVT_RESUME: {
+		void (*pf)(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg);
+
+		pf = node->nodedb_state;
+
+		node->nodedb_state = NULL;
+		efc_node_transition(node, pf, NULL);
+		break;
+	}
+
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		break;
+
+	case EFC_EVT_SHUTDOWN:
+		node->req_free = true;
+		break;
+
+	default:
+		__efc_node_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+efc_node_recv_els_frame(struct efc_node *node,
+			struct efc_hw_sequence *seq)
+{
+	u32 prli_size = sizeof(struct fc_els_prli) + sizeof(struct fc_els_spp);
+	struct {
+		u32 cmd;
+		enum efc_sm_event evt;
+		u32 payload_size;
+	} els_cmd_list[] = {
+		{ELS_PLOGI, EFC_EVT_PLOGI_RCVD,	sizeof(struct fc_els_flogi)},
+		{ELS_FLOGI, EFC_EVT_FLOGI_RCVD,	sizeof(struct fc_els_flogi)},
+		{ELS_LOGO, EFC_EVT_LOGO_RCVD, sizeof(struct fc_els_ls_acc)},
+		{ELS_PRLI, EFC_EVT_PRLI_RCVD, prli_size},
+		{ELS_PRLO, EFC_EVT_PRLO_RCVD, prli_size},
+		{ELS_PDISC, EFC_EVT_PDISC_RCVD,	MAX_ACC_REJECT_PAYLOAD},
+		{ELS_FDISC, EFC_EVT_FDISC_RCVD,	MAX_ACC_REJECT_PAYLOAD},
+		{ELS_ADISC, EFC_EVT_ADISC_RCVD,	sizeof(struct fc_els_adisc)},
+		{ELS_RSCN, EFC_EVT_RSCN_RCVD, MAX_ACC_REJECT_PAYLOAD},
+		{ELS_SCR, EFC_EVT_SCR_RCVD, MAX_ACC_REJECT_PAYLOAD},
+	};
+	struct efc_node_cb cbdata;
+	u8 *buf = seq->payload->dma.virt;
+	enum efc_sm_event evt = EFC_EVT_ELS_RCVD;
+	u32 i;
+
+	memset(&cbdata, 0, sizeof(cbdata));
+	cbdata.header = seq->header;
+	cbdata.payload = seq->payload;
+
+	/* find a matching event for the ELS command */
+	for (i = 0; i < ARRAY_SIZE(els_cmd_list); i++) {
+		if (els_cmd_list[i].cmd == buf[0]) {
+			evt = els_cmd_list[i].evt;
+			break;
+		}
+	}
+
+	efc_node_post_event(node, evt, &cbdata);
+}
+
+void
+efc_node_recv_ct_frame(struct efc_node *node,
+		       struct efc_hw_sequence *seq)
+{
+	struct fc_ct_hdr *iu = seq->payload->dma.virt;
+	struct fc_frame_header *hdr = seq->header->dma.virt;
+	struct efc *efc = node->efc;
+	u16 gscmd = be16_to_cpu(iu->ct_cmd);
+
+	efc_log_err(efc, "[%s] Received cmd :%x sending CT_REJECT\n",
+		    node->display_name, gscmd);
+	efc_send_ct_rsp(efc, node, be16_to_cpu(hdr->fh_ox_id), iu,
+			FC_FS_RJT, FC_FS_RJT_UNSUP, 0);
+}
+
+void
+efc_node_recv_fcp_cmd(struct efc_node *node, struct efc_hw_sequence *seq)
+{
+	struct efc_node_cb cbdata;
+
+	memset(&cbdata, 0, sizeof(cbdata));
+	cbdata.header = seq->header;
+	cbdata.payload = seq->payload;
+
+	efc_node_post_event(node, EFC_EVT_FCP_CMD_RCVD, &cbdata);
+}
+
+void
+efc_process_node_pending(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
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
+
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
+		efc->tt.hw_seq_free(efc, seq);
+	}
+
+	if (pend_frames_processed != 0)
+		efc_log_debug(efc, "%u node frames held and processed\n",
+			      pend_frames_processed);
+}
+
+void
+efc_scsi_sess_reg_complete(struct efc_node *node, u32 status)
+{
+	unsigned long flags = 0;
+	enum efc_sm_event evt = EFC_EVT_NODE_SESS_REG_OK;
+
+	if (status)
+		evt = EFC_EVT_NODE_SESS_REG_FAIL;
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	/* Notify the node to resume */
+	efc_node_post_event(node, evt, NULL);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
+}
+
+void
+efc_scsi_del_initiator_complete(struct efc *efc, struct efc_node *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->lock, flags);
+	/* Notify the node to resume */
+	efc_node_post_event(node, EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);
+	spin_unlock_irqrestore(&efc->lock, flags);
+}
+
+void
+efc_scsi_del_target_complete(struct efc *efc, struct efc_node *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->lock, flags);
+	/* Notify the node to resume */
+	efc_node_post_event(node, EFC_EVT_NODE_DEL_TGT_COMPLETE, NULL);
+	spin_unlock_irqrestore(&efc->lock, flags);
+}
+
+void
+efc_scsi_io_list_empty(struct efc *efc, struct efc_node *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->lock, flags);
+	efc_node_post_event(node, EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY, NULL);
+	spin_unlock_irqrestore(&efc->lock, flags);
+}
+
+void efc_node_post_els_resp(struct efc_node *node,
+			    enum efc_hw_node_els_event evt, void *arg)
+{
+	enum efc_sm_event sm_event = EFC_EVT_LAST;
+	struct efc *efc = node->efc;
+	unsigned long flags = 0;
+
+	switch (evt) {
+	case EFC_HW_SRRS_ELS_REQ_OK:
+		sm_event = EFC_EVT_SRRS_ELS_REQ_OK;
+		break;
+	case EFC_HW_SRRS_ELS_CMPL_OK:
+		sm_event = EFC_EVT_SRRS_ELS_CMPL_OK;
+		break;
+	case EFC_HW_SRRS_ELS_REQ_FAIL:
+		sm_event = EFC_EVT_SRRS_ELS_REQ_FAIL;
+		break;
+	case EFC_HW_SRRS_ELS_CMPL_FAIL:
+		sm_event = EFC_EVT_SRRS_ELS_CMPL_FAIL;
+		break;
+	case EFC_HW_SRRS_ELS_REQ_RJT:
+		sm_event = EFC_EVT_SRRS_ELS_REQ_RJT;
+		break;
+	case EFC_HW_ELS_REQ_ABORTED:
+		sm_event = EFC_EVT_ELS_REQ_ABORTED;
+		break;
+	default:
+		efc_log_test(efc, "unhandled event %#x\n", evt);
+		return;
+	}
+
+	spin_lock_irqsave(&efc->lock, flags);
+	efc_node_post_event(node, sm_event, arg);
+	spin_unlock_irqrestore(&efc->lock, flags);
+}
+
+void efc_node_post_shutdown(struct efc_node *node,
+			    u32 evt, void *arg)
+{
+	unsigned long flags = 0;
+	struct efc *efc = node->efc;
+
+	spin_lock_irqsave(&efc->lock, flags);
+	efc_node_post_event(node, EFC_EVT_SHUTDOWN, arg);
+	spin_unlock_irqrestore(&efc->lock, flags);
+}
diff --git a/drivers/scsi/elx/libefc/efc_node.h b/drivers/scsi/elx/libefc/efc_node.h
new file mode 100644
index 000000000000..866a6a3d9196
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_node.h
@@ -0,0 +1,191 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFC_NODE_H__)
+#define __EFC_NODE_H__
+#include "scsi/fc/fc_ns.h"
+
+#define EFC_NODEDB_PAUSE_FABRIC_LOGIN	(1 << 0)
+#define EFC_NODEDB_PAUSE_NAMESERVER	(1 << 1)
+#define EFC_NODEDB_PAUSE_NEW_NODES	(1 << 2)
+
+#define MAX_ACC_REJECT_PAYLOAD	sizeof(struct fc_els_ls_rjt)
+
+#define scsi_io_printf(io, fmt, ...) \
+	efc_log_debug(io->efc, "[%s] [%04x][i:%04x t:%04x h:%04x]" fmt, \
+	io->node->display_name, io->instance_index, io->init_task_tag, \
+	io->tgt_task_tag, io->hw_tag, ##__VA_ARGS__)
+
+static inline void
+efc_node_evt_set(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+		 const char *handler)
+{
+	struct efc_node *node = ctx->app;
+
+	if (evt == EFC_EVT_ENTER) {
+		strncpy(node->current_state_name, handler,
+			sizeof(node->current_state_name));
+	} else if (evt == EFC_EVT_EXIT) {
+		strncpy(node->prev_state_name, node->current_state_name,
+			sizeof(node->prev_state_name));
+		strncpy(node->current_state_name, "invalid",
+			sizeof(node->current_state_name));
+	}
+	node->prev_evt = node->current_evt;
+	node->current_evt = evt;
+}
+
+/**
+ * hold frames in pending frame list
+ *
+ * Unsolicited receive frames are held on the node pending frame list,
+ * rather than being processed.
+ */
+
+static inline void
+efc_node_hold_frames(struct efc_node *node)
+{
+	node->hold_frames = true;
+}
+
+/**
+ * accept frames
+ *
+ * Unsolicited receive frames processed rather than being held on the node
+ * pending frame list.
+ */
+
+static inline void
+efc_node_accept_frames(struct efc_node *node)
+{
+	node->hold_frames = false;
+}
+
+/*
+ * Node initiator/target enable defines
+ * All combinations of the SLI port (nport) initiator/target enable,
+ * and remote node initiator/target enable are enumerated.
+ * ex: EFC_NODE_ENABLE_T_TO_IT decodes to target mode is enabled on SLI port
+ * and I+T is enabled on remote node.
+ */
+enum efc_node_enable {
+	EFC_NODE_ENABLE_x_TO_x,
+	EFC_NODE_ENABLE_x_TO_T,
+	EFC_NODE_ENABLE_x_TO_I,
+	EFC_NODE_ENABLE_x_TO_IT,
+	EFC_NODE_ENABLE_T_TO_x,
+	EFC_NODE_ENABLE_T_TO_T,
+	EFC_NODE_ENABLE_T_TO_I,
+	EFC_NODE_ENABLE_T_TO_IT,
+	EFC_NODE_ENABLE_I_TO_x,
+	EFC_NODE_ENABLE_I_TO_T,
+	EFC_NODE_ENABLE_I_TO_I,
+	EFC_NODE_ENABLE_I_TO_IT,
+	EFC_NODE_ENABLE_IT_TO_x,
+	EFC_NODE_ENABLE_IT_TO_T,
+	EFC_NODE_ENABLE_IT_TO_I,
+	EFC_NODE_ENABLE_IT_TO_IT,
+};
+
+static inline enum efc_node_enable
+efc_node_get_enable(struct efc_node *node)
+{
+	u32 retval = 0;
+
+	if (node->nport->enable_ini)
+		retval |= (1U << 3);
+	if (node->nport->enable_tgt)
+		retval |= (1U << 2);
+	if (node->init)
+		retval |= (1U << 1);
+	if (node->targ)
+		retval |= (1U << 0);
+	return (enum efc_node_enable)retval;
+}
+
+int
+efc_node_check_els_req(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg,
+		       u8 cmd, void (*efc_node_common_func)(const char *,
+		       struct efc_sm_ctx *, enum efc_sm_event, void *),
+		       const char *funcname);
+int
+efc_node_check_ns_req(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg,
+		  u16 cmd, void (*efc_node_common_func)(const char *,
+		  struct efc_sm_ctx *, enum efc_sm_event, void *),
+		  const char *funcname);
+int
+efc_node_attach(struct efc_node *node);
+struct efc_node *
+efc_node_alloc(struct efc_nport *nport, u32 port_id,
+		bool init, bool targ);
+void
+efc_node_free(struct efc_node *efc);
+void
+efc_node_update_display_name(struct efc_node *node);
+void efc_node_post_event(struct efc_node *node, enum efc_sm_event evt,
+			 void *arg);
+
+void
+__efc_node_shutdown(struct efc_sm_ctx *ctx,
+		    enum efc_sm_event evt, void *arg);
+void
+__efc_node_wait_node_free(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg);
+void
+__efc_node_wait_els_shutdown(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg);
+void
+__efc_node_wait_ios_shutdown(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg);
+void
+efc_node_save_sparms(struct efc_node *node, void *payload);
+void
+efc_node_transition(struct efc_node *node,
+		    void (*state)(struct efc_sm_ctx *,
+		    enum efc_sm_event, void *), void *data);
+void
+__efc_node_common(const char *funcname, struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg);
+
+void
+efc_node_initiate_cleanup(struct efc_node *node);
+
+void
+efc_node_build_eui_name(char *buf, u32 buf_len, uint64_t eui_name);
+
+void
+efc_node_pause(struct efc_node *node,
+	       void (*state)(struct efc_sm_ctx *ctx,
+			      enum efc_sm_event evt, void *arg));
+void
+__efc_node_paused(struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg);
+int
+efc_node_active_ios_empty(struct efc_node *node);
+void
+efc_node_send_ls_io_cleanup(struct efc_node *node);
+
+int
+efc_els_io_list_empty(struct efc_node *node, struct list_head *list);
+
+void
+efc_process_node_pending(struct efc_node *domain);
+
+u64 efc_node_get_wwnn(struct efc_node *node);
+struct efc_node *
+efc_node_find(struct efc_nport *nport, u32 id);
+void
+efc_node_post_els_resp(struct efc_node *node, u32 evt, void *arg);
+void
+efc_node_recv_els_frame(struct efc_node *node, struct efc_hw_sequence *s);
+void
+efc_node_recv_ct_frame(struct efc_node *node, struct efc_hw_sequence *seq);
+void
+efc_node_recv_fcp_cmd(struct efc_node *node, struct efc_hw_sequence *seq);
+
+#endif /* __EFC_NODE_H__ */
-- 
2.26.2


--0000000000003658dd05b1812619
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgtByGmkz4DegjbUvB
aMzEWDKHGb9FCABjME1FpD19iXgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjEzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIl22uAbeB1xLDjVf4ZAF1c4mjLb38kEjZLc
EFVRuHQeeZtN2wyMxhGyZt7C923NQUIwaTcAmhR9NMjeQvu0ea7dkHoSK/KVInSBKaspi2LzWcgZ
aIGedXFlZ8FFGPZkBNubj20TNgA+cQ4BijUuRy+VC/O4nJwsoTuvaroT18JhNlwy/m6WBtT1O2yF
4cJIPUld9f4ZAL5Y8cPgz1Y37AMv81hYmEFXU+9UtjtI5Z6h5gDQAWmWNYtudwF1LU65Pb3s+9jz
9xvYNVNwytGyoOO4LnaP8/AfJ5qxBbeXMTct/6GFWPyZa+4VDky3VuAN+bgP5JBldCbtJfuuTL1X
1jk=
--0000000000003658dd05b1812619--
