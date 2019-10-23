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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53C5CA9EBB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 615F220679
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FbyurQ+T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407631AbfJWV4e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:34 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:35480 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405976AbfJWV4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:33 -0400
Received: by mail-wm1-f46.google.com with SMTP id v6so474535wmj.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=leCQwT+nnCK+/qTMeHHunlfp5ghPMTPqTvBmmxXlSfA=;
        b=FbyurQ+TPzph+ms8g67wfbRU2UlFP3KwyxAYspyG4Qv/0T5Hfs3Om1Ac8AVLhmmWoa
         VlCaVMUR7CBGdnWb0y8vzINZRch364cy95VaHKiE1Oa04yIOwERfdWeyMdTfyw1NH1iI
         xhloU+0VMs2CtjsCWqlvkAJaeaw2EfnSP0hkMKJkxZmI+z+H7xV0Kf4uABLnQPDL4HiE
         Qxh4odF65I6z3jIurUljl2wuFNSjP+8NTey5jkypZZEekTulJ8NtS4EMlwg+9x02X7lM
         lde+IYA/2wFRVmaiYqHxpLpPPehJKHcS22JColyKIwbjobyFVYB7tb9qHdlO+fKK43cV
         llqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=leCQwT+nnCK+/qTMeHHunlfp5ghPMTPqTvBmmxXlSfA=;
        b=qc8njwopnpFWKAWfieuir0TS8pWJ8swfT8rZ9Xt8oHsPq3jIvXMgJdJrkRg5njdOFg
         ZjCJXTDXmmEbbDR2otmQAaw4NkoubtSHm7+qSIgiX+DVZL4SJzuxm86XVB2Q1601VuOt
         HpPmQkkvw+kJ7CBIK/aEgLoCb9jwktPT6V5WycZN2tYCJV32DcGIrhnUXWnmwxC81YU3
         aAbSrRCIjaoui9sJZ40QMeT8B53mZKKYk1elSHdpfdgCRxtswow33eGpPxNX7wwCtuvj
         eUutx1eVtHpS8q3KFovlHytgZ2IbSFO9giPcLkMfqUClYpXyxFvud+HjwulyfV/Oz7NC
         MMEw==
X-Gm-Message-State: APjAAAUIojq/PjkAPYzhMNBGyQCw/L/BinbnRnMMs+QRgGgbInNhrEY0
        IDGUyD/B2QFxJX/by7sRUL0Wy+LE
X-Google-Smtp-Source: APXvYqyTwlDP4KuRLwv1rfNTRp1cjZt1U8M/7GxQpKEqa/VHa4oK8GcWHTece8KHmhU2S4P2eLVYLA==
X-Received: by 2002:a1c:988b:: with SMTP id a133mr1773622wme.22.1571867786740;
        Wed, 23 Oct 2019 14:56:26 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 12/32] elx: libefc: Remote node state machine interfaces
Date:   Wed, 23 Oct 2019 14:55:37 -0700
Message-Id: <20191023215557.12581-13-jsmart2021@gmail.com>
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

This patch continues the libefc library population.

This patch adds library interface definitions for:
- Remote node (aka remote port) allocation, initializaion and
  destroy routines.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc/efc_node.c | 1878 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_node.h |  196 ++++
 2 files changed, 2074 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_node.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.h

diff --git a/drivers/scsi/elx/libefc/efc_node.c b/drivers/scsi/elx/libefc/efc_node.c
new file mode 100644
index 000000000000..dcb63b1515b2
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_node.c
@@ -0,0 +1,1878 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * EFC driver remote node handler.  This file contains code that is shared
+ * between fabric (efc_fabric.c) and device (efc_device.c) nodes.
+ */
+
+#include "efc.h"
+#include "efc_device.h"
+
+#define SCSI_IOFMT "[%04x][i:%0*x t:%0*x h:%04x]"
+#define SCSI_ITT_SIZE(efc)	4
+
+#define SCSI_IOFMT_ARGS(io) \
+	(io->instance_index, SCSI_ITT_SIZE(io->efc), \
+	 io->init_task_tag, SCSI_ITT_SIZE(io->efc), \
+	 io->tgt_task_tag, io->hw_tag)
+
+#define scsi_io_printf(io, fmt, ...) \
+	efc_log_debug(io->efc, "[%s]" SCSI_IOFMT fmt, \
+	io->node->display_name, SCSI_IOFMT_ARGS(io), ##__VA_ARGS__)
+
+#define MAX_ACC_REJECT_PAYLOAD	sizeof(struct fc_els_ls_rjt)
+
+/**
+ * @ingroup node_common
+ * @brief Handle remote node events from HW
+ *
+ * Handle remote node events from HW.
+ * Essentially the HW event is translated into
+ * a node state machine event that is posted to the affected node.
+ *
+ * @param arg pointer to efc
+ * @param event HW event to proceoss
+ * @param data application specific data (pointer to the affected node)
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+int
+efc_remote_node_cb(void *arg, int event,
+		   void *data)
+{
+	struct efc_lport *efc = arg;
+	enum efc_sm_event_e	sm_event = EFC_EVT_LAST;
+	struct efc_remote_node_s *rnode = data;
+	struct efc_node_s *node = rnode->node;
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
+		return -1;
+	}
+
+	spin_lock_irqsave(&efc->lock, flags);
+	efc_node_post_event(node, sm_event, NULL);
+	spin_unlock_irqrestore(&efc->lock, flags);
+
+	return 0;
+}
+
+/**
+ * @ingroup node_alloc
+ * @brief Find an FC node structure given the FC port ID
+ *
+ * @param sport the SPORT to search
+ * @param port_id FC port ID
+ *
+ * @return pointer to the object or NULL if not found
+ */
+struct efc_node_s *
+efc_node_find(struct efc_sli_port_s *sport, u32 port_id)
+{
+	struct efc_node_s *node;
+
+	node = efc_spv_get(sport->lookup, port_id);
+	return node;
+}
+
+/**
+ * @ingroup node_alloc
+ * @brief allocate node object pool
+ *
+ * A pool of struct efc_node_s objects is allocated.
+ *
+ * @param efc pointer to driver instance context
+ * @param node_count count of nodes to allocate
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+int
+efc_node_create_pool(struct efc_lport *efc, u32 node_count)
+{
+	u32 i;
+	struct efc_node_s *node;
+	u64 max_xfer_size;
+	struct efc_dma_s *dma;
+
+	efc->nodes_count = node_count;
+
+	efc->nodes = kmalloc_array(node_count, sizeof(struct efc_node_s *),
+				   GFP_ATOMIC);
+	if (!efc->nodes)
+		return -1;
+
+	memset(efc->nodes, 0, node_count * sizeof(struct efc_node_s *));
+
+	if (efc->max_xfer_size)
+		max_xfer_size = efc->max_xfer_size;
+	else
+		max_xfer_size = 65536;
+
+	INIT_LIST_HEAD(&efc->nodes_free_list);
+
+	for (i = 0; i < node_count; i++) {
+		dma = NULL;
+		node = kzalloc(sizeof(*node), GFP_ATOMIC);
+		if (!node) {
+			efc_log_err(efc, "node allocation failed");
+			goto error;
+		}
+		/* Assign any persistent field values */
+		node->instance_index = i;
+		node->max_wr_xfer_size = max_xfer_size;
+		node->rnode.indicator = U32_MAX;
+
+		dma = &node->sparm_dma_buf;
+		dma->size = 256;
+		dma->virt = dma_alloc_coherent(&efc->pcidev->dev, dma->size,
+					       &dma->phys, GFP_DMA);
+		if (!dma->virt) {
+			kfree(node);
+			efc_log_err(efc, "efc_dma_alloc failed");
+			goto error;
+		}
+
+		efc->nodes[i] = node;
+		INIT_LIST_HEAD(&node->list_entry);
+		list_add_tail(&node->list_entry, &efc->nodes_free_list);
+	}
+	return 0;
+
+error:
+	efc_node_free_pool(efc);
+	return -1;
+}
+
+/**
+ * @ingroup node_alloc
+ * @brief free node object pool
+ *
+ * The pool of previously allocated node objects is freed
+ *
+ * @param efc pointer to driver instance context
+ *
+ * @return none
+ */
+
+void
+efc_node_free_pool(struct efc_lport *efc)
+{
+	struct efc_node_s *node;
+	u32 i;
+	struct efc_dma_s *dma;
+
+	if (!efc->nodes)
+		return;
+
+	for (i = 0; i < efc->nodes_count; i++) {
+		node = efc->nodes[i];
+		if (node) {
+			/* free sparam_dma_buf */
+			dma = &node->sparm_dma_buf;
+			dma_free_coherent(&efc->pcidev->dev, dma->size,
+					  dma->virt, dma->phys);
+
+			kfree(node);
+		}
+		efc->nodes[i] = NULL;
+	}
+}
+
+/**
+ * @ingroup node_alloc
+ * @brief return pointer to node object given instance index
+ *
+ * A pointer to the node object given by an instance index is returned.
+ *
+ * @param efc pointer to driver instance context
+ * @param index instance index
+ *
+ * @return returns pointer to node object, or NULL
+ */
+
+struct efc_node_s *
+efc_node_get_instance(struct efc_lport *efc, u32 index)
+{
+	struct efc_node_s *node = NULL;
+
+	if (index >= efc->nodes_count) {
+		efc_log_test(efc, "invalid index: %d\n", index);
+		return NULL;
+	}
+	node = efc->nodes[index];
+	return node->attached ? node : NULL;
+}
+
+/**
+ * @ingroup node_alloc
+ * @brief Allocate an fc node structure and add to node list
+ *
+ * @param sport pointer to the SPORT from which this node is allocated
+ * @param port_id FC port ID of new node
+ * @param init Port is an inititiator (sent a plogi)
+ * @param targ Port is potentially a target
+ *
+ * @return pointer to the object or NULL if none available
+ */
+
+struct efc_node_s *efc_node_alloc(struct efc_sli_port_s *sport,
+				  u32 port_id, bool init, bool targ)
+{
+	int rc;
+	struct efc_node_s *node = NULL;
+	u32 instance_index;
+	u64 max_wr_xfer_size;
+	struct efc_lport *efc = sport->efc;
+	struct efc_dma_s sparm_dma_buf;
+
+	if (sport->shutting_down) {
+		efc_log_debug(efc, "node allocation when shutting down %06x",
+			      port_id);
+		return NULL;
+	}
+
+	if (!list_empty(&efc->nodes_free_list)) {
+		node = list_first_entry(&efc->nodes_free_list,
+					struct efc_node_s, list_entry);
+		list_del(&node->list_entry);
+	}
+
+	if (!node) {
+		efc_log_err(efc, "node allocation failed %06x", port_id);
+		return NULL;
+	}
+
+	/* Save persistent values across memset zero */
+	instance_index = node->instance_index;
+	max_wr_xfer_size = node->max_wr_xfer_size;
+	sparm_dma_buf = node->sparm_dma_buf;
+
+	memset(node, 0, sizeof(*node));
+	node->instance_index = instance_index;
+	node->max_wr_xfer_size = max_wr_xfer_size;
+	node->sparm_dma_buf = sparm_dma_buf;
+	node->rnode.indicator = U32_MAX;
+
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
+		return NULL;
+	}
+	/* zero the service parameters */
+	memset(node->sparm_dma_buf.virt, 0, node->sparm_dma_buf.size);
+
+	node->rnode.node = node;
+	node->sm.app = node;
+	node->evtdepth = 0;
+
+	efc_node_update_display_name(node);
+
+	efc_spv_set(sport->lookup, port_id, node);
+
+	return node;
+}
+
+/**
+ * @ingroup node_alloc
+ * @brief free a node structure
+ *
+ * The node structure given by 'node' is free'd
+ *
+ * @param node the node to free
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+int
+efc_node_free(struct efc_node_s *node)
+{
+	struct efc_sli_port_s *sport;
+	struct efc_lport *efc;
+	int rc = 0;
+	struct efc_node_s *ns = NULL;
+	bool post_all_free = false;
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
+	/* Remove from node list */
+	list_del(&node->list_entry);
+
+	/* Free HW resources */
+	rc = efc->tt.hw_node_free_resources(efc, &node->rnode);
+	if (EFC_HW_RTN_IS_ERROR(rc)) {
+		efc_log_test(efc, "efc_hw_node_free failed: %d\n", rc);
+		rc = -1;
+	}
+
+	/* if the gidpt_delay_timer is still running, then delete it */
+	if (timer_pending(&node->gidpt_delay_timer))
+		del_timer(&node->gidpt_delay_timer);
+
+	/* remove entry from sparse vector list */
+	if (!sport->lookup) {
+		efc_log_test(node->efc,
+			     "assertion failed: sport lookup is NULL\n");
+		return -1;
+	}
+
+	efc_spv_set(sport->lookup, node->rnode.fc_id, NULL);
+
+	/*
+	 * If the node_list is empty,
+	 * then post a ALL_CHILD_NODES_FREE event to the sport,
+	 * after the lock is released.
+	 * The sport may be free'd as a result of the event.
+	 */
+	if (list_empty(&sport->node_list))
+		post_all_free = true;
+
+	if (post_all_free) {
+		efc_sm_post_event(&sport->sm, EFC_EVT_ALL_CHILD_NODES_FREE,
+				  NULL);
+	}
+
+	node->sport = NULL;
+	node->sm.current_state = NULL;
+
+	/* return to free list */
+	INIT_LIST_HEAD(&node->list_entry);
+	list_add_tail(&node->list_entry, &efc->nodes_free_list);
+
+	if (ns) {
+		/* sending fake RSCN event to name server node */
+		efc_node_post_event(ns, EFC_EVT_RSCN_RCVD, NULL);
+	}
+
+	return rc;
+}
+
+/**
+ * @brief free memory resources of a node object
+ *
+ * The node object's child objects are freed after which the
+ * node object is freed.
+ *
+ * @param node pointer to a node object
+ *
+ * @return none
+ */
+
+void
+efc_node_force_free(struct efc_node_s *node)
+{
+	struct efc_lport *efc = node->efc;
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
+/**
+ * @ingroup node_common
+ * @brief Perform HW call to attach a remote node
+ *
+ * @param node pointer to node object
+ *
+ * @return 0 on success, non-zero otherwise
+ */
+int
+efc_node_attach(struct efc_node_s *node)
+{
+	int rc = 0;
+	struct efc_sli_port_s *sport = node->sport;
+	struct efc_domain_s *domain = sport->domain;
+	struct efc_lport *efc = node->efc;
+
+	if (!domain->attached) {
+		efc_log_test(efc,
+			     "Warning: unattached domain\n");
+		return -1;
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
+/**
+ * @ingroup node_common
+ * @brief Generate text for a node's fc_id
+ *
+ * The text for a nodes fc_id is generated,
+ * either as a well known name, or a 6 digit
+ * hex value.
+ *
+ * @param fc_id fc_id
+ * @param buffer text buffer
+ * @param buffer_length text buffer length in bytes
+ *
+ * @return none
+ */
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
+/**
+ * @brief update the node's display name
+ *
+ * The node's display name is updated, sometimes needed because the sport part
+ * is updated after the node is allocated.
+ *
+ * @param node pointer to the node object
+ *
+ * @return none
+ */
+
+void
+efc_node_update_display_name(struct efc_node_s *node)
+{
+	u32 port_id = node->rnode.fc_id;
+	struct efc_sli_port_s *sport = node->sport;
+	char portid_display[16];
+
+	efc_node_fcid_display(port_id, portid_display, sizeof(portid_display));
+
+	snprintf(node->display_name, sizeof(node->display_name), "%s.%s",
+		 sport->display_name, portid_display);
+}
+
+/**
+ * @brief cleans up an XRI for the pending link services accept by aborting the
+ *         XRI if required.
+ *
+ * <h3 class="desc">Description</h3>
+ * This function is called when the LS accept is not sent.
+ *
+ * @param node Node for which should be cleaned up
+ */
+
+void
+efc_node_send_ls_io_cleanup(struct efc_node_s *node)
+{
+	struct efc_lport *efc = node->efc;
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
+/**
+ * @ingroup node_common
+ * @brief state: shutdown a node
+ *
+ * A node is shutdown,
+ *
+ * @param ctx remote node sm context
+ * @param evt event to process
+ * @param arg per event optional argument
+ *
+ * @return returns NULL
+ *
+ * @note
+ */
+
+void *
+__efc_node_shutdown(struct efc_sm_ctx_s *ctx,
+		    enum efc_sm_event_e evt, void *arg)
+{
+	int rc;
+	unsigned long flags = 0;
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		efc_node_hold_frames(node);
+		efc_assert(efc_node_active_ios_empty(node), NULL);
+		efc_assert(efc_els_io_list_empty(node,
+						 &node->els_io_active_list),
+			   NULL);
+
+		/* by default, we will be freeing node after we unwind */
+		node->req_free = true;
+
+		switch (node->shutdown_reason) {
+		case EFC_NODE_SHUTDOWN_IMPLICIT_LOGO:
+			/*
+			 * sm: if shutdown reason is
+			 * implicit logout / efc_node_attach
+			 */
+			/* Node shutdown b/c of PLOGI received when node
+			 * already logged in. We have PLOGI service
+			 * parameters, so submit node attach; we won't be
+			 * freeing this node
+			 */
+
+			/* currently, only case for implicit logo is PLOGI
+			 * recvd. Thus, node's ELS IO pending list won't be
+			 * empty (PLOGI will be on it)
+			 */
+			efc_assert(node->send_ls_acc ==
+				   EFC_NODE_SEND_LS_ACC_PLOGI, NULL);
+			node_printf(node,
+				    "Shutdown reason: implicit logout, re-authenticate\n");
+
+			efc->tt.scsi_io_alloc_enable(efc, node);
+
+			/* Re-attach node with the same HW node resources */
+			node->req_free = false;
+			rc = efc_node_attach(node);
+			efc_node_transition(node, __efc_d_wait_node_attach,
+					    NULL);
+			if (rc == EFC_HW_RTN_SUCCESS_SYNC) {
+				efc_node_post_event(node,
+						    EFC_EVT_NODE_ATTACH_OK,
+						    NULL);
+			}
+			break;
+		case EFC_NODE_SHUTDOWN_EXPLICIT_LOGO: {
+			s8 pend_frames_empty;
+			struct list_head *list;
+
+			/* cleanup any pending LS_ACC ELSs */
+			efc_node_send_ls_io_cleanup(node);
+			list = &node->els_io_pend_list;
+			efc_assert(efc_els_io_list_empty(node, list), NULL);
+
+			spin_lock_irqsave(&node->pend_frames_lock, flags);
+			pend_frames_empty = list_empty(&node->pend_frames);
+			spin_unlock_irqrestore(&node->pend_frames_lock, flags);
+
+			/*
+			 * there are two scenarios where we want to keep
+			 * this node alive:
+			 * 1. there are pending frames that need to be
+			 *    processed or
+			 * 2. we're an initiator and the remote node is
+			 *    a target and we need to re-authenticate
+			 */
+			node_printf(node,
+				    "Shutdown: explicit logo pend=%d ",
+					!pend_frames_empty);
+			 node_printf(node,
+				     "sport.ini=%d node.tgt=%d\n",
+				    node->sport->enable_ini, node->targ);
+
+			if (!pend_frames_empty ||
+			    (node->sport->enable_ini && node->targ)) {
+				u8 send_plogi = false;
+
+				if (node->sport->enable_ini && node->targ) {
+					/*
+					 * we're an initiator and
+					 * node shutting down is a target;
+					 * we'll need to re-authenticate in
+					 * initial state
+					 */
+					send_plogi = true;
+				}
+
+				/*
+				 * transition to __efc_d_init
+				 * (will retain HW node resources)
+				 */
+				efc->tt.scsi_io_alloc_enable(efc, node);
+				node->req_free = false;
+
+				/*
+				 * either pending frames exist,
+				 * or we're re-authenticating with PLOGI
+				 * (or both); in either case,
+				 * return to initial state
+				 */
+				efc_node_init_device(node, send_plogi);
+			}
+			/* else: let node shutdown occur */
+			break;
+		}
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
+			efc_assert(efc_els_io_list_empty(node, list), NULL);
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
+/**
+ * @ingroup common_node
+ * @brief Checks to see if ELS's have been quiesced
+ *
+ * Check if ELS's have been quiesced. If so, transition to the
+ * next state in the shutdown process.
+ *
+ * @param node Node for which ELS's are checked
+ *
+ * @return Returns 1 if ELS's have been quiesced, 0 otherwise.
+ */
+static int
+efc_node_check_els_quiesced(struct efc_node_s *node)
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
+		return 1;
+	}
+	return 0;
+}
+
+/**
+ * @ingroup common_node
+ * @brief Initiate node IO cleanup.
+ *
+ * Note: this function must be called with a non-attached node
+ * or a node for which the node detach (efc_hw_node_detach())
+ * has already been initiated.
+ *
+ * @param node Node for which shutdown is initiated
+ *
+ * @return Returns None.
+ */
+
+void
+efc_node_initiate_cleanup(struct efc_node_s *node)
+{
+	struct efc_lport *efc;
+
+	efc = node->efc;
+	efc->tt.node_els_cleanup(efc, node, false);
+
+	/*
+	 * if ELS's have already been quiesced, will move to next state
+	 * if ELS's have not been quiesced, abort them
+	 */
+	if (efc_node_check_els_quiesced(node) == 0) {
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
+/**
+ * @ingroup node_common
+ * @brief Node state machine: Wait for all ELSs to complete.
+ *
+ * <h3 class="desc">Description</h3>
+ * State waits for all ELSs to complete after aborting all
+ * outstanding .
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_node_wait_els_shutdown(struct efc_sm_ctx_s *ctx,
+			     enum efc_sm_event_e evt, void *arg)
+{
+	bool check_quiesce = false;
+	struct efc_node_s *node = ctx->app;
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
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		check_quiesce = true;
+		break;
+
+	case EFC_EVT_SRRS_ELS_CMPL_OK:
+	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
+		efc_assert(node->els_cmpl_cnt, NULL);
+		node->els_cmpl_cnt--;
+		check_quiesce = true;
+		break;
+
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		/* all ELS IO's complete */
+		node_printf(node, "All ELS IOs complete\n");
+		efc_assert(efc_els_io_list_empty(node,
+						 &node->els_io_active_list),
+			   NULL);
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
+/**
+ * @ingroup node_command
+ * @brief Node state machine: Wait for a HW node free event to
+ * complete.
+ *
+ * <h3 class="desc">Description</h3>
+ * State waits for the node free event to be received from the HW.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_node_wait_node_free(struct efc_sm_ctx_s *ctx,
+			  enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = ctx->app;
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
+ * @ingroup node_common
+ * @brief state: initiate node shutdown
+ *
+ * State is entered when a node receives a shutdown event, and it's waiting
+ * for all the active IOs and ELS IOs associated with the node to complete.
+ *
+ * @param ctx remote node sm context
+ * @param evt event to process
+ * @param arg per event optional argument
+ *
+ * @return returns NULL
+ */
+
+void *
+__efc_node_wait_ios_shutdown(struct efc_sm_ctx_s *ctx,
+			     enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
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
+	case EFC_EVT_ALL_CHILD_NODES_FREE: {
+		if (efc_node_active_ios_empty(node) &&
+		    efc_els_io_list_empty(node, &node->els_io_active_list)) {
+			efc_node_transition(node, __efc_node_shutdown, NULL);
+		}
+		break;
+	}
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:
+		/* Can happen as ELS IO IO's complete */
+		efc_assert(node->els_req_cnt, NULL);
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
+/**
+ * @ingroup node_common
+ * @brief state: common node event handler
+ *
+ * Handle common/shared node events
+ *
+ * @param funcname calling function's name
+ * @param ctx remote node sm context
+ * @param evt event to process
+ * @param arg per event optional argument
+ *
+ * @return returns NULL
+ */
+
+void *
+__efc_node_common(const char *funcname, struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = NULL;
+	struct efc_lport *efc = NULL;
+	struct efc_node_cb_s *cbdata = arg;
+
+	efc_assert(ctx, NULL);
+	efc_assert(ctx->app, NULL);
+	node = ctx->app;
+	efc_assert(node->efc, NULL);
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
+		efc_assert(node->els_cmpl_cnt, NULL);
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
+		efc_assert(node->els_req_cnt, NULL);
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
+	case EFC_EVT_GID_PT_RCVD:
+	case EFC_EVT_RFT_ID_RCVD:
+	case EFC_EVT_RFF_ID_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		efc_log_debug(efc, "[%s] (%s) %s sending CT_REJECT\n",
+			      node->display_name, funcname,
+			      efc_sm_event_name(evt));
+		efc->tt.send_ct_rsp(efc, node, hdr->fh_ox_id,
+				cbdata->payload->dma.virt,
+				FC_FS_RJT, FC_FS_RJT_UNSUP, 0);
+		break;
+	}
+
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
+/**
+ * @ingroup node_common
+ * @brief save node service parameters
+ *
+ * Service parameters are copyed into the node structure
+ *
+ * @param node pointer to node structure
+ * @param payload pointer to service parameters to save
+ *
+ * @return none
+ */
+
+void
+efc_node_save_sparms(struct efc_node_s *node, void *payload)
+{
+	memcpy(node->service_params, payload, sizeof(node->service_params));
+}
+
+/**
+ * @ingroup node_common
+ * @brief Post event to node state machine context
+ *
+ * This is used by the node state machine code to post events to the nodes.
+ * Upon completion of the event posting, if the nesting depth is zero and
+ * we're not holding inbound frames, then the pending frames are processed.
+ *
+ * @param node pointer to node
+ * @param evt event to post
+ * @param arg event posting argument
+ *
+ * @return none
+ */
+
+void
+efc_node_post_event(struct efc_node_s *node,
+		    enum efc_sm_event_e evt, void *arg)
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
+/**
+ * @ingroup node_common
+ * @brief transition state of a node
+ *
+ * The node's state is transitioned to the requested state.
+ * Entry/Exit events are posted as needed.
+ *
+ * @param node pointer to node
+ * @param state state to transition to
+ * @param data transition data
+ *
+ * @return none
+ */
+
+void
+efc_node_transition(struct efc_node_s *node,
+		    void *(*state)(struct efc_sm_ctx_s *,
+				   enum efc_sm_event_e, void *), void *data)
+
+{
+	struct efc_sm_ctx_s *ctx = &node->sm;
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
+/**
+ * @ingroup node_common
+ * @brief build EUI formatted WWN
+ *
+ * Build a WWN given the somewhat transport agnostic
+ * iScsi naming specification, for FC
+ * use the eui. format, an ascii string such as: "eui.10000000C9A19501"
+ *
+ * @param buffer buffer to place formatted name into
+ * @param buffer_len length in bytes of the buffer
+ * @param eui_name cpu endian 64 bit WWN value
+ *
+ * @return none
+ */
+
+void
+efc_node_build_eui_name(char *buffer, u32 buffer_len, uint64_t eui_name)
+{
+	memset(buffer, 0, buffer_len);
+
+	snprintf(buffer, buffer_len, "eui.%016llX", eui_name);
+}
+
+/**
+ * @ingroup node_common
+ * @brief return nodes' WWPN as a uint64_t
+ *
+ * The WWPN is computed from service parameters and returned as a uint64_t
+ *
+ * @param node pointer to node structure
+ *
+ * @return WWPN
+ *
+ */
+
+uint64_t
+efc_node_get_wwpn(struct efc_node_s *node)
+{
+	struct fc_els_flogi *sp =
+			(struct fc_els_flogi *)node->service_params;
+
+	return be64_to_cpu(sp->fl_wwpn);
+}
+
+/**
+ * @ingroup node_common
+ * @brief return nodes' WWNN as a uint64_t
+ *
+ * The WWNN is computed from service parameters and returned as a uint64_t
+ *
+ * @param node pointer to node structure
+ *
+ * @return WWNN
+ *
+ */
+
+uint64_t
+efc_node_get_wwnn(struct efc_node_s *node)
+{
+	struct fc_els_flogi *sp =
+			(struct fc_els_flogi *)node->service_params;
+
+	return be64_to_cpu(sp->fl_wwnn);
+}
+
+/**
+ * @brief check ELS request completion
+ *
+ * Check ELS request completion event to make sure it's for the
+ * ELS request we expect. If not, invoke given common event
+ * handler and return an error.
+ *
+ * @param ctx state machine context
+ * @param evt ELS request event
+ * @param arg event argument
+ * @param cmd ELS command expected
+ * @param node_common_func common event handler to call if ELS
+ *	doesn't match
+ * @param funcname function name that called this
+ *
+ * @return zero if ELS command matches, -1 otherwise
+ */
+int
+efc_node_check_els_req(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt,
+		       void *arg, uint8_t cmd,
+			void *(*efc_node_common_func)(const char *,
+						      struct efc_sm_ctx_s *,
+			       enum efc_sm_event_e, void *),
+			const char *funcname)
+{
+	return 0;
+}
+
+/**
+ * @brief check NS request completion
+ *
+ * Check ELS request completion event to make sure it's for the
+ * nameserver request we expect. If not, invoke given common
+ * event handler and return an error.
+ *
+ * @param ctx state machine context
+ * @param evt ELS request event
+ * @param arg event argument
+ * @param cmd nameserver command expected
+ * @param node_common_func common event handler to call if
+ *                         nameserver cmd doesn't match
+ * @param funcname function name that called this
+ *
+ * @return zero if NS command matches, -1 otherwise
+ */
+int
+efc_node_check_ns_req(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt,
+		      void *arg, uint16_t cmd,
+		       void *(*efc_node_common_func)(const char *,
+						     struct efc_sm_ctx_s *,
+			      enum efc_sm_event_e, void *),
+		       const char *funcname)
+{
+	return 0;
+}
+
+/**
+ * @brief Return TRUE if active ios list is empty
+ *
+ * Test if node->active_ios list is empty while
+ * holding the node->active_ios_lock.
+ *
+ * @param node pointer to node object
+ *
+ * @return TRUE if node active ios list is empty
+ */
+
+int
+efc_node_active_ios_empty(struct efc_node_s *node)
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
+efc_els_io_list_empty(struct efc_node_s *node, struct list_head *list)
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
+/**
+ * @brief Pause a node
+ *
+ * The node is placed in the __efc_node_paused state after saving the state
+ * to return to
+ *
+ * @param node Pointer to node object
+ * @param state State to resume to
+ *
+ * @return none
+ */
+
+void
+efc_node_pause(struct efc_node_s *node,
+	       void *(*state)(struct efc_sm_ctx_s *,
+			      enum efc_sm_event_e, void *))
+
+{
+	node->nodedb_state = state;
+	efc_node_transition(node, __efc_node_paused, NULL);
+}
+
+/**
+ * @brief Paused node state
+ *
+ * This state is entered when a state is "paused". When resumed, the node
+ * is transitioned to a previously saved state (node->ndoedb_state)
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return returns NULL
+ */
+
+void *
+__efc_node_paused(struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = ctx->app;
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
+		void *(*pf)(struct efc_sm_ctx_s *ctx,
+			    enum efc_sm_event_e evt, void *arg);
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
+/**
+ * @brief Resume a paused state
+ *
+ * Posts a resume event to the paused node.
+ *
+ * @param node Pointer to node object
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+int
+efc_node_resume(struct efc_node_s *node)
+{
+	efc_node_post_event(node, EFC_EVT_RESUME, NULL);
+
+	return 0;
+}
+
+/**
+ * @ingroup node_common
+ * @brief Dispatch a ELS frame.
+ *
+ * <h3 class="desc">Description</h3>
+ * An ELS frame is dispatched to the \c node state machine.
+ * RQ Pair mode: this function is always called with a NULL hw
+ * io.
+ *
+ * @param node Node that originated the frame.
+ * @param seq header/payload sequence buffers
+ *
+ * @return Returns 0 if frame processed and RX buffers cleaned
+ * up appropriately, -1 if frame not handled and RX buffers need
+ * to be returned.
+ */
+
+int
+efc_node_recv_els_frame(struct efc_node_s *node,
+			struct efc_hw_sequence_s *seq)
+{
+	unsigned long flags = 0;
+	u32 prli_size = sizeof(struct fc_els_prli) + sizeof(struct fc_els_spp);
+	struct {
+		u32 cmd;
+		enum efc_sm_event_e evt;
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
+	struct efc_node_cb_s cbdata;
+	u8 *buf = seq->payload->dma.virt;
+	enum efc_sm_event_e evt = EFC_EVT_ELS_RCVD;
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
+
+	return 0;
+}
+
+/**
+ * @ingroup node_common
+ * @brief Dispatch a CT frame.
+ *
+ * <h3 class="desc">Description</h3>
+ * A CT frame is dispatched to the \c node state machine.
+ * RQ Pair mode: this function is always called with a NULL hw
+ * io.
+ *
+ * @param node Node that originated the frame.
+ * @param seq header/payload sequence buffers
+ *
+ * @return Returns 0 if frame processed and RX buffers cleaned
+ * up appropriately, -1 if frame not handled and RX buffers need
+ * to be returned.
+ */
+
+int
+efc_node_recv_ct_frame(struct efc_node_s *node,
+		       struct efc_hw_sequence_s *seq)
+{
+	struct fc_ct_hdr  *iu = seq->payload->dma.virt;
+	enum efc_sm_event_e evt = EFC_EVT_ELS_RCVD;
+	u16 gscmd = be16_to_cpu(iu->ct_cmd);
+	struct efc_node_cb_s cbdata;
+	unsigned long flags = 0;
+	u32 i;
+	struct {
+		u32 cmd;
+		enum efc_sm_event_e evt;
+		u32 payload_size;
+	} ct_cmd_list[] = {
+		{FC_NS_RFF_ID, EFC_EVT_RFF_ID_RCVD, 100},
+		{FC_NS_RFT_ID, EFC_EVT_RFT_ID_RCVD, 100},
+		{FC_NS_GNN_ID, EFC_EVT_GNN_ID_RCVD, 100},
+		{FC_NS_GPN_ID, EFC_EVT_GPN_ID_RCVD, 100},
+		{FC_NS_GID_PT, EFC_EVT_GID_PT_RCVD, 256},
+		{FC_NS_RPN_ID, EFC_EVT_RPN_ID_RCVD, 100},
+		{FC_NS_RNN_ID, EFC_EVT_RNN_ID_RCVD, 100},
+		{FC_NS_RSNN_NN, EFC_EVT_RSNN_NN_RCVD, 100},
+		{FC_NS_RSPN_ID, EFC_EVT_RSPN_ID_RCVD, 100},
+	};
+
+	memset(&cbdata, 0, sizeof(cbdata));
+	cbdata.header = seq->header;
+	cbdata.payload = seq->payload;
+
+	/* find a matching event for the ELS/GS command */
+	for (i = 0; i < ARRAY_SIZE(ct_cmd_list); i++) {
+		if (ct_cmd_list[i].cmd == gscmd) {
+			evt = ct_cmd_list[i].evt;
+			break;
+		}
+	}
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	efc_node_post_event(node, evt, &cbdata);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
+
+	return 0;
+}
+
+/*
+ *@ingroup node_common
+ * @brief Dispatch a FCP command frame when the node is not ready.
+ *
+ * <h3 class="desc">Description</h3>
+ * A frame is dispatched to the \c node state machine.
+ *
+ * @param node Node that originated the frame.
+ * @param seq header/payload sequence buffers
+ *
+ * @return Returns 0 if frame processed and RX buffers cleaned
+ * up appropriately, -1 if frame not handled.
+ */
+
+int
+efc_node_recv_fcp_cmd(struct efc_node_s *node, struct efc_hw_sequence_s *seq)
+{
+	struct efc_node_cb_s cbdata;
+	unsigned long flags = 0;
+
+	memset(&cbdata, 0, sizeof(cbdata));
+	cbdata.header = seq->header;
+	cbdata.payload = seq->payload;
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	efc_node_post_event(node, EFC_EVT_FCP_CMD_RCVD, &cbdata);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
+
+	return 1;
+}
+
+/**
+ * @ingroup node_common
+ * @brief Stub handler for non-ABTS BLS frames
+ *
+ * <h3 class="desc">Description</h3>
+ * Log message and drop. Customer can plumb it to their back-end as needed
+ *
+ * @param node Node that originated the frame.
+ * @param seq header/payload sequence buffers
+ *
+ * @return Returns 0
+ */
+
+int
+efc_node_recv_bls_no_sit(struct efc_node_s *node,
+			 struct efc_hw_sequence_s *seq)
+{
+	struct fc_frame_header *hdr = seq->header->dma.virt;
+
+	node_printf(node,
+		    "Dropping frame hdr = %08x %08x %08x %08x %08x %08x\n",
+		    cpu_to_be32(((u32 *)hdr)[0]),
+		    cpu_to_be32(((u32 *)hdr)[1]),
+		    cpu_to_be32(((u32 *)hdr)[2]),
+		    cpu_to_be32(((u32 *)hdr)[3]),
+		    cpu_to_be32(((u32 *)hdr)[4]),
+		    cpu_to_be32(((u32 *)hdr)[5]));
+
+	return -1;
+}
+
+/**
+ * @ingroup unsol
+ * @brief Process pending frames queued to the given node.
+ *
+ * <h3 class="desc">Description</h3>
+ * Frames that are queued for the \c node are dispatched and returned
+ * to the RQ.
+ *
+ * @param node Node of the queued frames that are to be dispatched.
+ *
+ * @return Returns 0 on success, or a negative error value on failure.
+ */
+
+int
+efc_process_node_pending(struct efc_node_s *node)
+{
+	struct efc_lport *efc = node->efc;
+	struct efc_hw_sequence_s *seq = NULL;
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
+			if (!list_empty(&node->pend_frames)) {
+				seq = list_first_entry(&node->pend_frames,
+						       struct efc_hw_sequence_s,
+						       list_entry);
+				list_del(&seq->list_entry);
+			}
+			if (!seq) {
+				pend_frames_processed =
+						node->pend_frames_processed;
+				node->pend_frames_processed = 0;
+				spin_unlock_irqrestore(&node->pend_frames_lock,
+						       flags);
+				break;
+			}
+			node->pend_frames_processed++;
+		spin_unlock_irqrestore(&node->pend_frames_lock, flags);
+
+		/* now dispatch frame(s) to dispatch function */
+		efc_node_dispatch_frame(node, seq);
+	}
+
+	if (pend_frames_processed != 0)
+		efc_log_debug(efc, "%u node frames held and processed\n",
+			      pend_frames_processed);
+
+	return 0;
+}
+
+/*
+ * @ingroup scsi_api_base
+ * @brief Notify that delete initiator is complete.
+ *
+ * @par Description
+ * Sent by the target-server to notify the base driver that the work
+ * started from efc_scsi_del_initiator() is now complete and that it
+ * is safe for the node to release the rest of its resources.
+ *
+ * @param node Pointer to the node.
+ *
+ * @return None.
+ */
+
+void
+efc_scsi_del_initiator_complete(struct efc_lport *efc, struct efc_node_s *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	/* Notify the node to resume */
+	efc_node_post_event(node, EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
+}
+
+/*
+ * @ingroup scsi_api_base
+ * @brief Notify that delete target is complete.
+ *
+ * @par Description
+ * Sent by the initiator-client to notify the base driver that the
+ * work started from efc_scsi_del_target() is now complete and
+ * that it is safe for the node to release the rest of its resources.
+ *
+ * @param node Pointer to the node.
+ *
+ * @return None.
+ */
+void
+efc_scsi_del_target_complete(struct efc_lport *efc, struct efc_node_s *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	/* Notify the node to resume */
+	efc_node_post_event(node, EFC_EVT_NODE_DEL_TGT_COMPLETE, NULL);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
+}
+
+void
+efc_scsi_io_list_empty(struct efc_lport *efc, struct efc_node_s *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->efc->lock, flags);
+	efc_node_post_event(node, EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY, NULL);
+	spin_unlock_irqrestore(&node->efc->lock, flags);
+}
+
+void efc_node_post_els_resp(struct efc_node_s *node,
+			    enum efc_hw_node_els_event_e evt, void *arg)
+{
+	enum efc_sm_event_e	sm_event = EFC_EVT_LAST;
+	struct efc_lport	*efc = node->efc;
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
+void efc_node_post_shutdown(struct efc_node_s *node,
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
index 000000000000..96a4964b74c1
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_node.h
@@ -0,0 +1,196 @@
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
+#define EFC_NODEDB_PAUSE_FABRIC_LOGIN	BIT(0)
+#define EFC_NODEDB_PAUSE_NAMESERVER	BIT(1)
+#define EFC_NODEDB_PAUSE_NEW_NODES	BIT(2)
+
+static inline void
+efc_node_evt_set(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt,
+		 const char *handler)
+{
+	struct efc_node_s *node = ctx->app;
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
+ * @brief hold frames in pending frame list
+ *
+ * Unsolicited receive frames are held on the node pending frame list,
+ * rather than being processed.
+ *
+ * @param node pointer to node structure
+ *
+ * @return none
+ */
+
+static inline void
+efc_node_hold_frames(struct efc_node_s *node)
+{
+	efc_assert(node);
+	node->hold_frames = true;
+}
+
+/**
+ * @brief accept frames
+ *
+ * Unsolicited receive frames processed rather than being held on the node
+ * pending frame list.
+ *
+ * @param node pointer to node structure
+ *
+ * @return none
+ */
+
+static inline void
+efc_node_accept_frames(struct efc_node_s *node)
+{
+	efc_assert(node);
+	node->hold_frames = false;
+}
+
+extern int
+efc_node_create_pool(struct efc_lport *efc, u32 node_count);
+extern void
+efc_node_free_pool(struct efc_lport *efc);
+extern struct efc_node_s *
+efc_node_get_instance(struct efc_lport *efc, u32 instance);
+
+/**
+ * @brief Node initiator/target enable defines
+ *
+ * All combinations of the SLI port (sport) initiator/target enable, and remote
+ * node initiator/target enable are enumerated.
+ *
+ */
+
+enum efc_node_enable_e {
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
+static inline enum efc_node_enable_e
+efc_node_get_enable(struct efc_node_s *node)
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
+	return (enum efc_node_enable_e)retval;
+}
+
+extern int
+efc_node_check_els_req(struct efc_sm_ctx_s *ctx,
+		       enum efc_sm_event_e evt, void *arg,
+		       u8 cmd, void *(*efc_node_common_func)(const char *,
+		       struct efc_sm_ctx_s *, enum efc_sm_event_e, void *),
+		       const char *funcname);
+extern int
+efc_node_check_ns_req(struct efc_sm_ctx_s *ctx,
+		      enum efc_sm_event_e evt, void *arg,
+		  u16 cmd, void *(*efc_node_common_func)(const char *,
+		  struct efc_sm_ctx_s *, enum efc_sm_event_e, void *),
+		  const char *funcname);
+extern int
+efc_node_attach(struct efc_node_s *node);
+extern struct efc_node_s *
+efc_node_alloc(struct efc_sli_port_s *sport, u32 port_id,
+		bool init, bool targ);
+extern int
+efc_node_free(struct efc_node_s *efc);
+extern void
+efc_node_force_free(struct efc_node_s *efc);
+extern void
+efc_node_update_display_name(struct efc_node_s *node);
+void efc_node_post_event(struct efc_node_s *node, enum efc_sm_event_e evt,
+			 void *arg);
+
+extern void *
+__efc_node_shutdown(struct efc_sm_ctx_s *ctx,
+		    enum efc_sm_event_e evt, void *arg);
+extern void *
+__efc_node_wait_node_free(struct efc_sm_ctx_s *ctx,
+			  enum efc_sm_event_e evt, void *arg);
+extern void *
+__efc_node_wait_els_shutdown(struct efc_sm_ctx_s *ctx,
+			     enum efc_sm_event_e evt, void *arg);
+extern void *
+__efc_node_wait_ios_shutdown(struct efc_sm_ctx_s *ctx,
+			     enum efc_sm_event_e evt, void *arg);
+extern void
+efc_node_save_sparms(struct efc_node_s *node, void *payload);
+extern void
+efc_node_transition(struct efc_node_s *node,
+		    void *(*state)(struct efc_sm_ctx_s *,
+		    enum efc_sm_event_e, void *), void *data);
+extern void *
+__efc_node_common(const char *funcname, struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *arg);
+
+extern void
+efc_node_initiate_cleanup(struct efc_node_s *node);
+
+extern void
+efc_node_build_eui_name(char *buffer, u32 buffer_len, uint64_t eui_name);
+extern uint64_t
+efc_node_get_wwpn(struct efc_node_s *node);
+
+extern void
+efc_node_pause(struct efc_node_s *node,
+	       void *(*state)(struct efc_sm_ctx_s *ctx,
+			      enum efc_sm_event_e evt, void *arg));
+extern int
+efc_node_resume(struct efc_node_s *node);
+extern void *
+__efc_node_paused(struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *arg);
+extern int
+efc_node_active_ios_empty(struct efc_node_s *node);
+extern void
+efc_node_send_ls_io_cleanup(struct efc_node_s *node);
+
+extern int
+efc_els_io_list_empty(struct efc_node_s *node, struct list_head *list);
+
+extern int
+efc_process_node_pending(struct efc_node_s *domain);
+
+#endif /* __EFC_NODE_H__ */
-- 
2.13.7

