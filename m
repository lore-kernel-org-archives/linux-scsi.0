Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06069C2D0EC
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B220120739
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEUZbRKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgDLDdf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44096 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgDLDdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id n13so2921598pgp.11
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xvhyHqkANOQ/ZMM3JBmp+HTl7KbOBGHyuY70bpQpWBE=;
        b=eEUZbRKL35R0+0+87szay4tpTzr9BZOIREKdavgi+Cgosj1N4F+RTMWIJ+ZKrONxwo
         dHS2QX22S4f+MHNAD30bs6TWxKzO0DycA8AmJ5I0Pqh6ZE1Daqk/FwtYkfD69o5JWkko
         HHNu/Jc7Ga7nSWL5wIEtKgADZxY4ZPups/kH/LSgrN9qzUaaybUEpaUT3sLu0y4ix43p
         BwBvKsFPeGghMxEZf1VapG/aFzS8JXs5OXfct8Ao4HaQMlyBYdxHcieaZWWReA+/Pxz8
         /V139m61fZtQ2Ovpp1jh8ClK8qtwWsDchMR+6sePOm7/AMfTUq5hzU7N25d8nPrm1uAd
         Uujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xvhyHqkANOQ/ZMM3JBmp+HTl7KbOBGHyuY70bpQpWBE=;
        b=glo5KT1rBFtuKeqpyvCwh7i/kmGrWOZX8pzpWngKkQG3ViLJwvTHRObPshQT1K38Jo
         lmtAkn4MI/xsM9Z0n56wAOZOAJaeB1WDRB70rTX/js8fEc5FKjSicUMlK6fvA8D6B0XL
         Ry0Xrq76VL4srW8Lf/1HgqUtYsIebGHwNRnfP/njIeOeoNqlco1HvG2rpvtZVlihIJFl
         fsCWv1XxyJTxojd3nEUggIeZmSHC87DF7WHyIWKPOhiXsYyQTzhMQXVofLnVZhZqYPPO
         QIEMcOhssRGAPnuX9W4IQtEk0Qjvd1HcG0UPkWN3gS4n3q6xZJYYzgQNXnSEVB7w33e/
         zlSQ==
X-Gm-Message-State: AGi0PubwwiE1azZYCwCiaPl9ivmbZh+g08n+eOyycbLzNjxFPJQDvsDm
        xGtoM7IE8CEFbsntIGziJ5WQRQrR
X-Google-Smtp-Source: APiQypKu1ST23ASknTjL0uj/7T89fryQrZY0REwql9Nk4hPUT9pXSHzqa7sfwX8eHkI2oVMvAcx8BA==
X-Received: by 2002:aa7:9a4b:: with SMTP id x11mr12052455pfj.73.1586662410497;
        Sat, 11 Apr 2020 20:33:30 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 12/31] elx: libefc: Remote node state machine interfaces
Date:   Sat, 11 Apr 2020 20:32:44 -0700
Message-Id: <20200412033303.29574-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200412033303.29574-1-jsmart2021@gmail.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc library population.

This patch adds library interface definitions for:
- Remote node (aka remote port) allocation, initializaion and
  destroy routines.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  Changed node pool creation. Use mempool for node structure and allocate
    dma mem when required.
  Added functions efc_node_handle_implicit_logo() and
    efc_node_handle_explicit_logo() for better indentation.
  Replace efc_assert with WARN_ON.
  Use linux xarray api for lookup instead of sparse vectors.
  Use defined return values.
---
 drivers/scsi/elx/libefc/efc_node.c | 1196 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_node.h |  183 ++++++
 2 files changed, 1379 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_node.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.h

diff --git a/drivers/scsi/elx/libefc/efc_node.c b/drivers/scsi/elx/libefc/efc_node.c
new file mode 100644
index 000000000000..e8fd631f1793
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_node.c
@@ -0,0 +1,1196 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efc.h"
+
+/* HW node callback events from the user driver */
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
+/* Find an FC node structure given the FC port ID */
+struct efc_node *
+efc_node_find(struct efc_sli_port *sport, u32 port_id)
+{
+	return xa_load(&sport->lookup, port_id);
+}
+
+struct efc_node *efc_node_alloc(struct efc_sli_port *sport,
+				  u32 port_id, bool init, bool targ)
+{
+	int rc;
+	struct efc_node *node = NULL;
+	struct efc *efc = sport->efc;
+	struct efc_dma *dma;
+
+	if (sport->shutting_down) {
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
+	node->sport = sport;
+	INIT_LIST_HEAD(&node->list_entry);
+	list_add_tail(&node->list_entry, &sport->node_list);
+
+	node->efc = efc;
+	node->init = init;
+	node->targ = targ;
+
+	spin_lock_init(&node->pend_frames_lock);
+	INIT_LIST_HEAD(&node->pend_frames);
+	spin_lock_init(&node->active_ios_lock);
+	INIT_LIST_HEAD(&node->active_ios);
+	INIT_LIST_HEAD(&node->els_io_pend_list);
+	INIT_LIST_HEAD(&node->els_io_active_list);
+	efc->tt.scsi_io_alloc_enable(efc, node);
+
+	rc = efc->tt.hw_node_alloc(efc, &node->rnode, port_id, sport);
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
+	rc = xa_err(xa_store(&sport->lookup, port_id, node, GFP_ATOMIC));
+	if (rc) {
+		efc_log_err(efc, "Node lookup store failed: %d\n", rc);
+		goto xa_fail;
+	}
+
+	return node;
+
+xa_fail:
+	efc->tt.hw_node_free_resources(efc, &node->rnode);
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
+	struct efc_sli_port *sport;
+	struct efc *efc;
+	int rc = 0;
+	struct efc_node *ns = NULL;
+	struct efc_dma *dma;
+
+	sport = node->sport;
+	efc = node->efc;
+
+	node_printf(node, "Free'd\n");
+
+	if (node->refound) {
+		/*
+		 * Save the name server node. We will send fake RSCN event at
+		 * the end to handle ignored RSCN event during node deletion
+		 */
+		ns = efc_node_find(node->sport, FC_FID_DIR_SERV);
+	}
+
+	list_del(&node->list_entry);
+
+	/* Free HW resources */
+	rc = efc->tt.hw_node_free_resources(efc, &node->rnode);
+	if (EFC_HW_RTN_IS_ERROR(rc))
+		efc_log_test(efc, "efc_hw_node_free failed: %d\n", rc);
+
+	/* if the gidpt_delay_timer is still running, then delete it */
+	if (timer_pending(&node->gidpt_delay_timer))
+		del_timer(&node->gidpt_delay_timer);
+
+	xa_erase(&sport->lookup, node->rnode.fc_id);
+
+	/*
+	 * If the node_list is empty,
+	 * then post a ALL_CHILD_NODES_FREE event to the sport,
+	 * after the lock is released.
+	 * The sport may be free'd as a result of the event.
+	 */
+	if (list_empty(&sport->node_list))
+		efc_sm_post_event(&sport->sm, EFC_EVT_ALL_CHILD_NODES_FREE,
+				  NULL);
+
+	node->sport = NULL;
+	node->sm.current_state = NULL;
+
+	dma = &node->sparm_dma_buf;
+	dma_pool_free(efc->node_dma_pool, dma->virt, dma->phys);
+	memset(dma, 0, sizeof(struct efc_dma));
+	mempool_free(node, efc->node_pool);
+
+	if (ns) {
+		/* sending fake RSCN event to name server node */
+		efc_node_post_event(ns, EFC_EVT_RSCN_RCVD, NULL);
+	}
+}
+
+void
+efc_node_force_free(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
+	/* shutdown sm processing */
+	efc_sm_disable(&node->sm);
+
+	strncpy(node->prev_state_name, node->current_state_name,
+		sizeof(node->prev_state_name));
+	strncpy(node->current_state_name, "disabled",
+		sizeof(node->current_state_name));
+
+	efc->tt.node_io_cleanup(efc, node, true);
+	efc->tt.node_els_cleanup(efc, node, true);
+
+	/* manually purge pending frames (if any) */
+	efc->tt.node_purge_pending(efc, node);
+
+	efc_node_free(node);
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
+	struct efc_sli_port *sport = node->sport;
+	struct efc_domain *domain = sport->domain;
+	struct efc *efc = node->efc;
+
+	if (!domain->attached) {
+		efc_log_err(efc,
+			     "Warning: unattached domain\n");
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
+	rc = efc->tt.hw_node_attach(efc, &node->rnode, &node->sparm_dma_buf);
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
+	struct efc_sli_port *sport = node->sport;
+	char portid_display[16];
+
+	efc_node_fcid_display(port_id, portid_display, sizeof(portid_display));
+
+	snprintf(node->display_name, sizeof(node->display_name), "%s.%s",
+		 sport->display_name, portid_display);
+}
+
+void
+efc_node_send_ls_io_cleanup(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
+
+	if (node->send_ls_acc != EFC_NODE_SEND_LS_ACC_NONE) {
+		efc_log_debug(efc, "[%s] cleaning up LS_ACC oxid=0x%x\n",
+			      node->display_name, node->ls_acc_oxid);
+
+		node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
+		node->ls_acc_io = NULL;
+	}
+}
+
+/* currently, only case for implicit logo is PLOGI
+ * recvd. Thus, node's ELS IO pending list won't be
+ * empty (PLOGI will be on it)
+ */
+static void efc_node_handle_implicit_logo(struct efc_node *node)
+{
+	int rc;
+	struct efc *efc = node->efc;
+
+	WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_PLOGI);
+	node_printf(node, "Reason: implicit logout, re-authenticate\n");
+
+	efc->tt.scsi_io_alloc_enable(efc, node);
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
+	struct efc *efc = node->efc;
+	s8 pend_frames_empty;
+	struct list_head *list;
+	unsigned long flags = 0;
+
+	/* cleanup any pending LS_ACC ELSs */
+	efc_node_send_ls_io_cleanup(node);
+	list = &node->els_io_pend_list;
+	WARN_ON(!efc_els_io_list_empty(node, list));
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
+	node_printf(node, "sport.ini=%d node.tgt=%d\n",
+			  node->sport->enable_ini, node->targ);
+	if (!pend_frames_empty || (node->sport->enable_ini && node->targ)) {
+		u8 send_plogi = false;
+
+		if (node->sport->enable_ini && node->targ) {
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
+		efc->tt.scsi_io_alloc_enable(efc, node);
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
+void *
+__efc_node_shutdown(struct efc_sm_ctx *ctx,
+		    enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = ctx->app;
+	struct efc *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		efc_node_hold_frames(node);
+		WARN_ON(!efc_node_active_ios_empty(node));
+		WARN_ON(!efc_els_io_list_empty(node,
+						&node->els_io_active_list));
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
+			struct list_head *list;
+
+			/*
+			 * shutdown due to link down,
+			 * node going away (xport event) or
+			 * sport shutdown, purge pending and
+			 * proceed to cleanup node
+			 */
+
+			/* cleanup any pending LS_ACC ELSs */
+			efc_node_send_ls_io_cleanup(node);
+			list = &node->els_io_pend_list;
+			WARN_ON(!efc_els_io_list_empty(node, list));
+
+			node_printf(node,
+				    "Shutdown reason: default, purge pending\n");
+			efc->tt.node_purge_pending(efc, node);
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
+		return NULL;
+	}
+
+	return NULL;
+}
+
+static bool
+efc_node_check_els_quiesced(struct efc_node *node)
+{
+	/* check to see if ELS requests, completions are quiesced */
+	if (node->els_req_cnt == 0 && node->els_cmpl_cnt == 0 &&
+	    efc_els_io_list_empty(node, &node->els_io_active_list)) {
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
+	struct efc *efc;
+
+	efc = node->efc;
+	efc->tt.node_els_cleanup(efc, node, false);
+
+	/*
+	 * if ELS's have already been quiesced, will move to next state
+	 * if ELS's have not been quiesced, abort them
+	 */
+	if (!efc_node_check_els_quiesced(node)) {
+		/*
+		 * Abort all ELS's since ELS's won't be aborted by HW
+		 * node free.
+		 */
+		efc_node_hold_frames(node);
+		efc->tt.node_abort_all_els(efc, node);
+		efc_node_transition(node, __efc_node_wait_els_shutdown, NULL);
+	}
+}
+
+/* Node state machine: Wait for all ELSs to complete */
+void *
+__efc_node_wait_els_shutdown(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg)
+{
+	bool check_quiesce = false;
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		efc_node_hold_frames(node);
+		if (efc_els_io_list_empty(node, &node->els_io_active_list)) {
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
+		WARN_ON(!efc_els_io_list_empty(node,
+					 &node->els_io_active_list));
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
+		/* fall through */
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		break;
+
+	default:
+		__efc_node_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	if (check_quiesce)
+		efc_node_check_els_quiesced(node);
+
+	return NULL;
+}
+
+/* Node state machine: Wait for a HW node free event to complete */
+void *
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
+		/* Fall through */
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		break;
+	default:
+		__efc_node_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * State is entered when a node receives a shutdown event, and it's waiting
+ * for all the active IOs and ELS IOs associated with the node to complete.
+ */
+void *
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
+		if (efc_els_io_list_empty(node, &node->els_io_active_list)) {
+			/* If there are any active IOS, Free them. */
+			efc_node_transition(node, __efc_node_shutdown, NULL);
+		}
+		break;
+
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		if (efc_node_active_ios_empty(node) &&
+		    efc_els_io_list_empty(node, &node->els_io_active_list)) {
+			efc_node_transition(node, __efc_node_shutdown, NULL);
+		}
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
+		/* fall through */
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
+		return NULL;
+	}
+
+	return NULL;
+}
+
+void *
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
+		efc->tt.send_ls_rjt(efc, node, be16_to_cpu(hdr->fh_ox_id),
+					ELS_RJT_UNSUP, ELS_EXPL_NONE, 0);
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
+		efc->tt.send_ls_rjt(efc, node, be16_to_cpu(hdr->fh_ox_id),
+						ELS_RJT_UNAB, ELS_EXPL_NONE, 0);
+
+		break;
+	}
+	case EFC_EVT_ABTS_RCVD: {
+		efc_log_debug(efc, "[%s] (%s) %s sending BA_ACC\n",
+			      node->display_name, funcname,
+			      efc_sm_event_name(evt));
+
+		/* sm: / send BA_ACC */
+		efc->tt.bls_send_acc_hdr(efc, node, cbdata->header->dma.virt);
+		break;
+	}
+
+	default:
+		efc_log_test(node->efc, "[%s] %-20s %-20s not handled\n",
+			     node->display_name, funcname,
+			     efc_sm_event_name(evt));
+		break;
+	}
+	return NULL;
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
+		    void *(*state)(struct efc_sm_ctx *,
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
+efc_node_build_eui_name(char *buffer, u32 buffer_len, uint64_t eui_name)
+{
+	memset(buffer, 0, buffer_len);
+
+	snprintf(buffer, buffer_len, "eui.%016llX", eui_name);
+}
+
+uint64_t
+efc_node_get_wwpn(struct efc_node *node)
+{
+	struct fc_els_flogi *sp =
+			(struct fc_els_flogi *)node->service_params;
+
+	return be64_to_cpu(sp->fl_wwpn);
+}
+
+uint64_t
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
+		uint8_t cmd, void *(*efc_node_common_func)(const char *,
+				struct efc_sm_ctx *, enum efc_sm_event, void *),
+		const char *funcname)
+{
+	return 0;
+}
+
+int
+efc_node_check_ns_req(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg,
+		uint16_t cmd, void *(*efc_node_common_func)(const char *,
+				struct efc_sm_ctx *, enum efc_sm_event, void *),
+		const char *funcname)
+{
+	return 0;
+}
+
+int
+efc_node_active_ios_empty(struct efc_node *node)
+{
+	int empty;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	empty = list_empty(&node->active_ios);
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+	return empty;
+}
+
+int
+efc_els_io_list_empty(struct efc_node *node, struct list_head *list)
+{
+	int empty;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->active_ios_lock, flags);
+	empty = list_empty(list);
+	spin_unlock_irqrestore(&node->active_ios_lock, flags);
+	return empty;
+}
+
+void
+efc_node_pause(struct efc_node *node,
+	       void *(*state)(struct efc_sm_ctx *,
+			      enum efc_sm_event, void *))
+
+{
+	node->nodedb_state = state;
+	efc_node_transition(node, __efc_node_paused, NULL);
+}
+
+/**
+ * This state is entered when a state is "paused". When resumed, the node
+ * is transitioned to a previously saved state (node->ndoedb_state)
+ */
+void *
+__efc_node_paused(struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		node_printf(node, "Paused\n");
+		break;
+
+	case EFC_EVT_RESUME: {
+		void *(*pf)(struct efc_sm_ctx *ctx,
+			    enum efc_sm_event evt, void *arg);
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
+		break;
+	}
+	return NULL;
+}
+
+void
+efc_node_recv_els_frame(struct efc_node *node,
+			struct efc_hw_sequence *seq)
+{
+	unsigned long flags = 0;
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
+	spin_lock_irqsave(&node->efc->lock, flags);
+	efc_node_post_event(node, evt, &cbdata);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
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
+	efc->tt.send_ct_rsp(efc, node, be16_to_cpu(hdr->fh_ox_id), iu,
+			    FC_FS_RJT, FC_FS_RJT_UNSUP, 0);
+}
+
+void
+efc_node_recv_fcp_cmd(struct efc_node *node, struct efc_hw_sequence *seq)
+{
+	struct efc_node_cb cbdata;
+	unsigned long flags = 0;
+
+	memset(&cbdata, 0, sizeof(cbdata));
+	cbdata.header = seq->header;
+	cbdata.payload = seq->payload;
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	efc_node_post_event(node, EFC_EVT_FCP_CMD_RCVD, &cbdata);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
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
+	}
+
+	if (pend_frames_processed != 0)
+		efc_log_debug(efc, "%u node frames held and processed\n",
+			      pend_frames_processed);
+}
+
+void
+efc_scsi_del_initiator_complete(struct efc *efc, struct efc_node *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	/* Notify the node to resume */
+	efc_node_post_event(node, EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
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
+	spin_lock_irqsave(&node->efc->lock, flags);
+	efc_node_post_event(node, sm_event, arg);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
+}
+
+void efc_node_post_shutdown(struct efc_node *node,
+			    u32 evt, void *arg)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	efc_node_post_event(node, EFC_EVT_SHUTDOWN, arg);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
+}
diff --git a/drivers/scsi/elx/libefc/efc_node.h b/drivers/scsi/elx/libefc/efc_node.h
new file mode 100644
index 000000000000..0608703cfd04
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_node.h
@@ -0,0 +1,183 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
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
+ * All combinations of the SLI port (sport) initiator/target enable,
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
+	if (node->sport->enable_ini)
+		retval |= (1U << 3);
+	if (node->sport->enable_tgt)
+		retval |= (1U << 2);
+	if (node->init)
+		retval |= (1U << 1);
+	if (node->targ)
+		retval |= (1U << 0);
+	return (enum efc_node_enable)retval;
+}
+
+extern int
+efc_node_check_els_req(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg,
+		       u8 cmd, void *(*efc_node_common_func)(const char *,
+		       struct efc_sm_ctx *, enum efc_sm_event, void *),
+		       const char *funcname);
+extern int
+efc_node_check_ns_req(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg,
+		  u16 cmd, void *(*efc_node_common_func)(const char *,
+		  struct efc_sm_ctx *, enum efc_sm_event, void *),
+		  const char *funcname);
+extern int
+efc_node_attach(struct efc_node *node);
+extern struct efc_node *
+efc_node_alloc(struct efc_sli_port *sport, u32 port_id,
+		bool init, bool targ);
+extern void
+efc_node_free(struct efc_node *efc);
+extern void
+efc_node_force_free(struct efc_node *efc);
+extern void
+efc_node_update_display_name(struct efc_node *node);
+void efc_node_post_event(struct efc_node *node, enum efc_sm_event evt,
+			 void *arg);
+
+extern void *
+__efc_node_shutdown(struct efc_sm_ctx *ctx,
+		    enum efc_sm_event evt, void *arg);
+extern void *
+__efc_node_wait_node_free(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg);
+extern void *
+__efc_node_wait_els_shutdown(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg);
+extern void *
+__efc_node_wait_ios_shutdown(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg);
+extern void
+efc_node_save_sparms(struct efc_node *node, void *payload);
+extern void
+efc_node_transition(struct efc_node *node,
+		    void *(*state)(struct efc_sm_ctx *,
+		    enum efc_sm_event, void *), void *data);
+extern void *
+__efc_node_common(const char *funcname, struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg);
+
+extern void
+efc_node_initiate_cleanup(struct efc_node *node);
+
+extern void
+efc_node_build_eui_name(char *buffer, u32 buffer_len, uint64_t eui_name);
+extern uint64_t
+efc_node_get_wwpn(struct efc_node *node);
+
+extern void
+efc_node_pause(struct efc_node *node,
+	       void *(*state)(struct efc_sm_ctx *ctx,
+			      enum efc_sm_event evt, void *arg));
+extern void *
+__efc_node_paused(struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg);
+extern int
+efc_node_active_ios_empty(struct efc_node *node);
+extern void
+efc_node_send_ls_io_cleanup(struct efc_node *node);
+
+extern int
+efc_els_io_list_empty(struct efc_node *node, struct list_head *list);
+
+extern void
+efc_process_node_pending(struct efc_node *domain);
+
+#endif /* __EFC_NODE_H__ */
-- 
2.16.4

