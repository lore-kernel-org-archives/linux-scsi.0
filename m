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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF50CA9EBE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2B2021906
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRPYnzHc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407619AbfJWV4e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:34 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:46255 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407582AbfJWV4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:34 -0400
Received: by mail-wr1-f45.google.com with SMTP id n15so12916989wrw.13
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qtMqODbz/X+dEz7lvIc++6Rhc/rQbl7Rel4YuI7Cs+M=;
        b=NRPYnzHcIMff/orhnvYMS2slugS+h59Ol1vDvIrAvnxos5CJ4+zY1kenvy5WtC4cO8
         lMoZlmdyhB/LlND1vB+UFx/gL/Rlpp9uPqm/lCXMkkFdINUeYqw/KOhRwp+FTMSS8T2T
         BEbiaWuxQV2gh7AoUtqlPKxScD+XHF2svQX+HC2VkEpNA8EQAydTRJ1QRYg0xzcTR4r7
         Wo1/b1dsCfag7fP/xXeBdV8ioN0IGHSwauWobIPt1ski79UutmwkPGctjY78T0SFA+NA
         aaHwOvltIKmTZMHqSs/xhIq84KMmOy/FFgCsbMJDtE3qb7Qiw9+v8q6mieCNx/BHjE+J
         knjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qtMqODbz/X+dEz7lvIc++6Rhc/rQbl7Rel4YuI7Cs+M=;
        b=g356ByPI1U0Ja9Wm8bgQ4r97eCV/C70Fuo12E5ox6PfSfNOQUNzTEtXdgVQpVnSytu
         8yR83vAD+RqkWXrjLpBHGbuNJUDDps9Vf/F83ukqf4g0Gr+NZcMpl5EB7H2YKSwypWQ9
         7kRlN5pGW5HaAxEpH5v2UHcMsBXb5AZLWb0vvTsnSWGPSxLCHUGFXfRobpnRPt8HEm68
         TCDqkidEmyz0yqu7HmzZ8cgTJFE57C54GdhiLT/xOAMK/bRFJPzp+jYVhy04TPHms3Lq
         o+37mrNAG16uqjMbY27ByRLjdSeLsrOpIgeTKy11km7iHcD21/Uxaylw4BraiiOfMBf0
         N1Zg==
X-Gm-Message-State: APjAAAUcsItPSZbRUmhgv2r3hvuOEuD5idH45YPVfwTXecTuY0LNrJ9/
        tE7Z4VkpnsLCSBwNqt0EtJ6IpA/P
X-Google-Smtp-Source: APXvYqxyGLwCpv0aK0REnAaA13HM/kJTWs2Eqc/hN5N4ZFvqj+2PcC5hSLxSTzIeTN37/d0r3OBggA==
X-Received: by 2002:adf:ecc7:: with SMTP id s7mr729318wro.305.1571867788418;
        Wed, 23 Oct 2019 14:56:28 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 13/32] elx: libefc: Fabric node state machine interfaces
Date:   Wed, 23 Oct 2019 14:55:38 -0700
Message-Id: <20191023215557.12581-14-jsmart2021@gmail.com>
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
- Fabric node initialization and logins.
- Name/Directory Services node.
- Fabric Controller node to process rscn events.

These are all interactions with remote ports that correspond
to well-known fabric entities

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc/efc_fabric.c | 2252 ++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_fabric.h |  116 ++
 2 files changed, 2368 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.c
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.h

diff --git a/drivers/scsi/elx/libefc/efc_fabric.c b/drivers/scsi/elx/libefc/efc_fabric.c
new file mode 100644
index 000000000000..d8e77df5d6ff
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_fabric.c
@@ -0,0 +1,2252 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * This file implements remote node state machines for:
+ * - Fabric logins.
+ * - Fabric controller events.
+ * - Name/directory services interaction.
+ * - Point-to-point logins.
+ */
+
+/*
+ * fabric_sm Node State Machine: Fabric States
+ * ns_sm Node State Machine: Name/Directory Services States
+ * p2p_sm Node State Machine: Point-to-Point Node States
+ */
+
+#include "efc.h"
+#include "efc_fabric.h"
+#include "efc_device.h"
+
+static void efc_fabric_initiate_shutdown(struct efc_node_s *node);
+static void *__efc_fabric_common(const char *funcname,
+				 struct efc_sm_ctx_s *ctx,
+				  enum efc_sm_event_e evt, void *arg);
+static int efc_start_ns_node(struct efc_sli_port_s *sport);
+static int efc_start_fabctl_node(struct efc_sli_port_s *sport);
+static int efc_process_gidpt_payload(struct efc_node_s *node,
+				     void *gidpt, u32 gidpt_len);
+static void efc_process_rscn(struct efc_node_s *node,
+			     struct efc_node_cb_s *cbdata);
+static uint64_t efc_get_wwpn(struct fc_els_flogi *sp);
+static void gidpt_delay_timer_cb(struct timer_list *t);
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric node state machine: Initial state.
+ *
+ * @par Description
+ * Send an FLOGI to a well-known fabric.
+ *
+ * @param ctx Remote node sm context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_fabric_init(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt,
+		  void *arg)
+{
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_REENTER:	/* not sure why we're getting these ... */
+		efc_log_debug(efc, ">>> reenter !!\n");
+		/* fall through */
+	case EFC_EVT_ENTER:
+		/*  sm: / send FLOGI */
+		efc->tt.els_send(efc, node, ELS_FLOGI,
+				EFC_FC_FLOGI_TIMEOUT_SEC,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+		efc_node_transition(node, __efc_fabric_flogi_wait_rsp, NULL);
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Set sport topology.
+ *
+ * @par Description
+ * Set sport topology.
+ *
+ * @param node Pointer to the node for which the topology is set.
+ * @param topology Topology to set.
+ *
+ * @return Returns NULL.
+ */
+void
+efc_fabric_set_topology(struct efc_node_s *node,
+			enum efc_sport_topology_e topology)
+{
+	node->sport->topology = topology;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Set sport topology.
+ *
+ * @par Description
+ * Nofity sport topology.
+ *
+ * @param node Pointer to the node for which the topology is set.
+ * @param topology Topology to set.
+ *
+ * @return Returns NULL.
+ */
+void
+efc_fabric_notify_topology(struct efc_node_s *node)
+{
+	struct efc_node_s *tmp_node;
+	struct efc_node_s *next;
+	enum efc_sport_topology_e topology = node->sport->topology;
+
+	/*
+	 * now loop through the nodes in the sport
+	 * and send topology notification
+	 */
+	list_for_each_entry_safe(tmp_node, next, &node->sport->node_list,
+				 list_entry) {
+		if (tmp_node != node) {
+			efc_node_post_event(tmp_node,
+					    EFC_EVT_SPORT_TOPOLOGY_NOTIFY,
+					    (void *)topology);
+		}
+	}
+}
+
+static bool efc_rnode_is_nport(struct fc_els_flogi *rsp)
+{
+	return !(ntohs(rsp->fl_csp.sp_features) & FC_SP_FT_FPORT);
+}
+
+static bool efc_rnode_is_npiv_capable(struct fc_els_flogi *rsp)
+{
+	return !!(ntohs(rsp->fl_csp.sp_features) & FC_SP_FT_NPIV_ACC);
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric node state machine: Wait for an FLOGI response.
+ *
+ * @par Description
+ * Wait for an FLOGI response event.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_fabric_flogi_wait_rsp(struct efc_sm_ctx_s *ctx,
+			    enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_cb_s *cbdata = arg;
+	struct efc_node_s *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK: {
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_FLOGI,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+
+		memcpy(node->sport->domain->flogi_service_params,
+		       cbdata->els_rsp.virt,
+		       sizeof(struct fc_els_flogi));
+
+		/* Check to see if the fabric is an F_PORT or and N_PORT */
+		if (!efc_rnode_is_nport(cbdata->els_rsp.virt)) {
+			/* sm: if not nport / efc_domain_attach */
+			/* ext_status has the fc_id, attach domain */
+			if (efc_rnode_is_npiv_capable(cbdata->els_rsp.virt)) {
+				efc_log_debug(node->efc,
+					      " NPIV is enabled at switch side\n");
+				//node->efc->sw_feature_cap |= 1<<10;
+			}
+			efc_fabric_set_topology(node,
+						EFC_SPORT_TOPOLOGY_FABRIC);
+			efc_fabric_notify_topology(node);
+			efc_assert(!node->sport->domain->attached, NULL);
+			efc_domain_attach(node->sport->domain,
+					  cbdata->ext_status);
+			efc_node_transition(node,
+					    __efc_fabric_wait_domain_attach,
+					    NULL);
+			break;
+		}
+
+		/*  sm: if nport and p2p_winner / efc_domain_attach */
+		efc_fabric_set_topology(node, EFC_SPORT_TOPOLOGY_P2P);
+		if (efc_p2p_setup(node->sport)) {
+			node_printf(node,
+				    "p2p setup failed, shutting down node\n");
+			node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+			efc_fabric_initiate_shutdown(node);
+			break;
+		}
+
+		if (node->sport->p2p_winner) {
+			efc_node_transition(node,
+					    __efc_p2p_wait_domain_attach,
+					     NULL);
+			if (node->sport->domain->attached &&
+			    !node->sport->domain->domain_notify_pend) {
+				/*
+				 * already attached,
+				 * just send ATTACH_OK
+				 */
+				node_printf(node,
+					    "p2p winner, domain already attached\n");
+				efc_node_post_event(node,
+						    EFC_EVT_DOMAIN_ATTACH_OK,
+						    NULL);
+			}
+		} else {
+			/*
+			 * peer is p2p winner;
+			 * PLOGI will be received on the
+			 * remote SID=1 node;
+			 * this node has served its purpose
+			 */
+			node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+			efc_fabric_initiate_shutdown(node);
+		}
+
+		break;
+	}
+
+	case EFC_EVT_ELS_REQ_ABORTED:
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+	case EFC_EVT_SRRS_ELS_REQ_FAIL: {
+		struct efc_sli_port_s *sport = node->sport;
+		/*
+		 * with these errors, we have no recovery,
+		 * so shutdown the sport, leave the link
+		 * up and the domain ready
+		 */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_FLOGI,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		node_printf(node,
+			    "FLOGI failed evt=%s, shutting down sport [%s]\n",
+			    efc_sm_event_name(evt), sport->display_name);
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		efc_sm_post_event(&sport->sm, EFC_EVT_SHUTDOWN, NULL);
+		break;
+	}
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric node state machine: Initial state for a virtual port.
+ *
+ * @par Description
+ * State entered when a virtual port is created. Send FDISC.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_vport_fabric_init(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg)
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
+		/* sm: / send FDISC */
+		efc->tt.els_send(efc, node, ELS_FDISC,
+				EFC_FC_FLOGI_TIMEOUT_SEC,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+
+		efc_node_transition(node, __efc_fabric_fdisc_wait_rsp, NULL);
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric node state machine: Wait for an FDISC response
+ *
+ * @par Description
+ * Used for a virtual port. Waits for an FDISC response.
+ * If OK, issue a HW port attach.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_fabric_fdisc_wait_rsp(struct efc_sm_ctx_s *ctx,
+			    enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_cb_s *cbdata = arg;
+	struct efc_node_s *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK: {
+		/* fc_id is in ext_status */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_FDISC,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		/* sm: / efc_sport_attach */
+		efc_sport_attach(node->sport, cbdata->ext_status);
+		efc_node_transition(node, __efc_fabric_wait_domain_attach,
+				    NULL);
+		break;
+	}
+
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+	case EFC_EVT_SRRS_ELS_REQ_FAIL: {
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_FDISC,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		efc_log_err(node->efc, "FDISC failed, shutting down sport\n");
+		/* sm: / shutdown sport */
+		efc_sm_post_event(&node->sport->sm, EFC_EVT_SHUTDOWN, NULL);
+		break;
+	}
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric node state machine: Wait for a domain/sport attach event.
+ *
+ * @par Description
+ * Waits for a domain/sport attach event.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_fabric_wait_domain_attach(struct efc_sm_ctx_s *ctx,
+				enum efc_sm_event_e evt, void *arg)
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
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+	case EFC_EVT_SPORT_ATTACH_OK: {
+		int rc;
+
+		rc = efc_start_ns_node(node->sport);
+		if (rc)
+			return NULL;
+
+		/* sm: if enable_ini / start fabctl node */
+		/* Instantiate the fabric controller (sends SCR) */
+		if (node->sport->enable_rscn) {
+			rc = efc_start_fabctl_node(node->sport);
+			if (rc)
+				return NULL;
+		}
+		efc_node_transition(node, __efc_fabric_idle, NULL);
+		break;
+	}
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric node state machine: Fabric node is idle.
+ *
+ * @par Description
+ * Wait for fabric node events.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_fabric_idle(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt,
+		  void *arg)
+{
+	struct efc_node_s *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		break;
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Name services node state machine: Initialize.
+ *
+ * @par Description
+ * A PLOGI is sent to the well-known name/directory services node.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_ns_init(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt, void *arg)
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
+		/* sm: / send PLOGI */
+		efc->tt.els_send(efc, node, ELS_PLOGI,
+				EFC_FC_FLOGI_TIMEOUT_SEC,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+		efc_node_transition(node, __efc_ns_plogi_wait_rsp, NULL);
+		break;
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Name services node state machine: Wait for a PLOGI response.
+ *
+ * @par Description
+ * Waits for a response from PLOGI to name services node, then issues a
+ * node attach request to the HW.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_ns_plogi_wait_rsp(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg)
+{
+	int rc;
+	struct efc_node_cb_s *cbdata = arg;
+	struct efc_node_s *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK: {
+		/* Save service parameters */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		/* sm: / save sparams, efc_node_attach */
+		efc_node_save_sparms(node, cbdata->els_rsp.virt);
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_ns_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK,
+					    NULL);
+		break;
+	}
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Name services node state machine: Wait for a node attach completion.
+ *
+ * @par Description
+ * Waits for a node attach completion, then issues an RFTID name services
+ * request.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_ns_wait_node_attach(struct efc_sm_ctx_s *ctx,
+			  enum efc_sm_event_e evt, void *arg)
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
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_NODE_ATTACH_OK:
+		node->attached = true;
+		/* sm: / send RFTID */
+		efc->tt.els_send_ct(efc, node, FC_RCTL_ELS_REQ,
+				EFC_FC_ELS_SEND_DEFAULT_TIMEOUT,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+		efc_node_transition(node, __efc_ns_rftid_wait_rsp, NULL);
+		break;
+
+	case EFC_EVT_NODE_ATTACH_FAIL:
+		/* node attach failed, shutdown the node */
+		node->attached = false;
+		node_printf(node, "Node attach failed\n");
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_fabric_initiate_shutdown(node);
+		break;
+
+	case EFC_EVT_SHUTDOWN:
+		node_printf(node, "Shutdown event received\n");
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_node_transition(node,
+				    __efc_fabric_wait_attach_evt_shutdown,
+				     NULL);
+		break;
+
+	/*
+	 * if receive RSCN just ignore,
+	 * we haven't sent GID_PT yet (ACC sent by fabctl node)
+	 */
+	case EFC_EVT_RSCN_RCVD:
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Wait for a domain/sport/node attach completion, then
+ * shutdown.
+ *
+ * @par Description
+ * Waits for a domain/sport/node attach completion, then shuts
+ * node down.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_fabric_wait_attach_evt_shutdown(struct efc_sm_ctx_s *ctx,
+				      enum efc_sm_event_e evt, void *arg)
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
+	/* wait for any of these attach events and then shutdown */
+	case EFC_EVT_NODE_ATTACH_OK:
+		node->attached = true;
+		node_printf(node, "Attach evt=%s, proceed to shutdown\n",
+			    efc_sm_event_name(evt));
+		efc_fabric_initiate_shutdown(node);
+		break;
+
+	case EFC_EVT_NODE_ATTACH_FAIL:
+		node->attached = false;
+		node_printf(node, "Attach evt=%s, proceed to shutdown\n",
+			    efc_sm_event_name(evt));
+		efc_fabric_initiate_shutdown(node);
+		break;
+
+	/* ignore shutdown event as we're already in shutdown path */
+	case EFC_EVT_SHUTDOWN:
+		node_printf(node, "Shutdown event received\n");
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Name services node state machine: Wait for an RFTID response event.
+ *
+ * @par Description
+ * Waits for an RFTID response event; if configured for an initiator operation,
+ * a GIDPT name services request is issued.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_ns_rftid_wait_rsp(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK:
+		if (efc_node_check_ns_req(ctx, evt, arg, FC_NS_RFT_ID,
+					  __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		/* sm: / send RFFID */
+		efc->tt.els_send_ct(efc, node, FC_NS_RFF_ID,
+				EFC_FC_ELS_SEND_DEFAULT_TIMEOUT,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+		efc_node_transition(node, __efc_ns_rffid_wait_rsp, NULL);
+		break;
+
+	/*
+	 * if receive RSCN just ignore,
+	 * we haven't sent GID_PT yet (ACC sent by fabctl node)
+	 */
+	case EFC_EVT_RSCN_RCVD:
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Fabric node state machine: Wait for RFFID response event.
+ *
+ * @par Description
+ * Waits for an RFFID response event; if configured for an initiator operation,
+ * a GIDPT name services request is issued.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_ns_rffid_wait_rsp(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK:	{
+		if (efc_node_check_ns_req(ctx, evt, arg, FC_NS_RFF_ID,
+					  __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		if (node->sport->enable_rscn) {
+			/* sm: if enable_rscn / send GIDPT */
+			efc->tt.els_send_ct(efc, node, FC_NS_GID_PT,
+					EFC_FC_ELS_SEND_DEFAULT_TIMEOUT,
+					EFC_FC_ELS_DEFAULT_RETRIES);
+
+			efc_node_transition(node, __efc_ns_gidpt_wait_rsp,
+					    NULL);
+		} else {
+			/* if 'T' only, we're done, go to idle */
+			efc_node_transition(node, __efc_ns_idle, NULL);
+		}
+		break;
+	}
+	/*
+	 * if receive RSCN just ignore,
+	 * we haven't sent GID_PT yet (ACC sent by fabctl node)
+	 */
+	case EFC_EVT_RSCN_RCVD:
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Name services node state machine: Wait for a GIDPT response.
+ *
+ * @par Description
+ * Wait for a GIDPT response from the name server. Process the FC_IDs that are
+ * reported by creating new remote ports, as needed.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_ns_gidpt_wait_rsp(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_cb_s *cbdata = arg;
+	struct efc_node_s *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK:	{
+		if (efc_node_check_ns_req(ctx, evt, arg, FC_NS_GID_PT,
+					  __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		/* sm: / process GIDPT payload */
+		efc_process_gidpt_payload(node, cbdata->els_rsp.virt,
+					  cbdata->els_rsp.len);
+		efc_node_transition(node, __efc_ns_idle, NULL);
+		break;
+	}
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:	{
+		/* not much we can do; will retry with the next RSCN */
+		node_printf(node, "GID_PT failed to complete\n");
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		efc_node_transition(node, __efc_ns_idle, NULL);
+		break;
+	}
+
+	/* if receive RSCN here, queue up another discovery processing */
+	case EFC_EVT_RSCN_RCVD: {
+		node_printf(node, "RSCN received during GID_PT processing\n");
+		node->rscn_pending = true;
+		break;
+	}
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Name services node state machine: Idle state.
+ *
+ * @par Description
+ * Idle. Waiting for RSCN received events
+ * (posted from the fabric controller), and
+ * restarts the GIDPT name services query and processing.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_ns_idle(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt, void *arg)
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
+		if (!node->rscn_pending)
+			break;
+
+		node_printf(node, "RSCN pending, restart discovery\n");
+		node->rscn_pending = false;
+
+			/* fall through */
+
+	case EFC_EVT_RSCN_RCVD: {
+		/* sm: / send GIDPT */
+		/*
+		 * If target RSCN processing is enabled,
+		 * and this is target only (not initiator),
+		 * and tgt_rscn_delay is non-zero,
+		 * then we delay issuing the GID_PT
+		 */
+		if (efc->tgt_rscn_delay_msec != 0 &&
+		    !node->sport->enable_ini && node->sport->enable_tgt &&
+		    enable_target_rscn(efc)) {
+			efc_node_transition(node, __efc_ns_gidpt_delay, NULL);
+		} else {
+			efc->tt.els_send_ct(efc, node, FC_NS_GID_PT,
+					EFC_FC_ELS_SEND_DEFAULT_TIMEOUT,
+					EFC_FC_ELS_DEFAULT_RETRIES);
+			efc_node_transition(node, __efc_ns_gidpt_wait_rsp,
+					    NULL);
+		}
+		break;
+	}
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * @brief Handle GIDPT delay timer callback
+ *
+ * @par Description
+ * Post an EFC_EVT_GIDPT_DEIALY_EXPIRED event to the passed in node.
+ *
+ * @param arg Pointer to node.
+ *
+ * @return None.
+ */
+static void
+gidpt_delay_timer_cb(struct timer_list *t)
+{
+	struct efc_node_s *node = from_timer(node, t, gidpt_delay_timer);
+
+	del_timer(&node->gidpt_delay_timer);
+
+	efc_node_post_event(node, EFC_EVT_GIDPT_DELAY_EXPIRED, NULL);
+}
+
+/**
+ * @ingroup ns_sm
+ * @brief Name services node state machine: Delayed GIDPT.
+ *
+ * @par Description
+ * Waiting for GIDPT delay to expire before submitting GIDPT to name server.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_ns_gidpt_delay(struct efc_sm_ctx_s *ctx,
+		     enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		time_t delay_msec;
+
+		/*
+		 * Compute the delay time.
+		 * Set to tgt_rscn_delay, if the time since last GIDPT
+		 * is less than tgt_rscn_period, then use tgt_rscn_period.
+		 */
+		delay_msec = efc->tgt_rscn_delay_msec;
+		if ((jiffies_to_msecs(jiffies) - node->time_last_gidpt_msec)
+		    < efc->tgt_rscn_period_msec) {
+			delay_msec = efc->tgt_rscn_period_msec;
+		}
+		timer_setup(&node->gidpt_delay_timer, &gidpt_delay_timer_cb,
+			    0);
+		mod_timer(&node->gidpt_delay_timer,
+			  jiffies + msecs_to_jiffies(delay_msec));
+
+		break;
+	}
+
+	case EFC_EVT_GIDPT_DELAY_EXPIRED:
+		node->time_last_gidpt_msec = jiffies_to_msecs(jiffies);
+
+		efc->tt.els_send_ct(efc, node, FC_NS_GID_PT,
+				EFC_FC_ELS_SEND_DEFAULT_TIMEOUT,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+		efc_node_transition(node, __efc_ns_gidpt_wait_rsp, NULL);
+		break;
+
+	case EFC_EVT_RSCN_RCVD: {
+		efc_log_debug(efc,
+			      "RSCN received while in GIDPT delay - no action\n");
+		break;
+	}
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric controller node state machine: Initial state.
+ *
+ * @par Description
+ * Issue a PLOGI to a well-known fabric controller address.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_fabctl_init(struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		/* no need to login to fabric controller, just send SCR */
+		efc->tt.els_send(efc, node, ELS_SCR,
+				EFC_FC_FLOGI_TIMEOUT_SEC,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+		efc_node_transition(node, __efc_fabctl_wait_scr_rsp, NULL);
+		break;
+
+	case EFC_EVT_NODE_ATTACH_OK:
+		node->attached = true;
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric controller node state machine: Wait for a node attach request
+ * to complete.
+ *
+ * @par Description
+ * Wait for a node attach to complete. If successful, issue an SCR
+ * to the fabric controller, subscribing to all RSCN.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ *
+ */
+void *
+__efc_fabctl_wait_node_attach(struct efc_sm_ctx_s *ctx,
+			      enum efc_sm_event_e evt, void *arg)
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
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_NODE_ATTACH_OK:
+		node->attached = true;
+		/* sm: / send SCR */
+		efc->tt.els_send(efc, node, ELS_SCR,
+				EFC_FC_ELS_SEND_DEFAULT_TIMEOUT,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+		efc_node_transition(node, __efc_fabctl_wait_scr_rsp, NULL);
+		break;
+
+	case EFC_EVT_NODE_ATTACH_FAIL:
+		/* node attach failed, shutdown the node */
+		node->attached = false;
+		node_printf(node, "Node attach failed\n");
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_fabric_initiate_shutdown(node);
+		break;
+
+	case EFC_EVT_SHUTDOWN:
+		node_printf(node, "Shutdown event received\n");
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_node_transition(node,
+				    __efc_fabric_wait_attach_evt_shutdown,
+				     NULL);
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric controller node state machine:
+ * Wait for an SCR response from the
+ * fabric controller.
+ *
+ * @par Description
+ * Waits for an SCR response from the fabric controller.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+void *
+__efc_fabctl_wait_scr_rsp(struct efc_sm_ctx_s *ctx,
+			  enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK:
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_SCR,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		efc_node_transition(node, __efc_fabctl_ready, NULL);
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric controller node state machine: Ready.
+ *
+ * @par Description
+ * In this state, the fabric controller sends a RSCN, which is received
+ * by this node and is forwarded to the name services node object; and
+ * the RSCN LS_ACC is sent.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_fabctl_ready(struct efc_sm_ctx_s *ctx,
+		   enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_cb_s *cbdata = arg;
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_RSCN_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		/*
+		 * sm: / process RSCN (forward to name services node),
+		 * send LS_ACC
+		 */
+		efc_process_rscn(node, cbdata);
+		efc->tt.els_send_resp(efc, node, ELS_LS_ACC,
+					be16_to_cpu(hdr->fh_ox_id));
+		efc_node_transition(node, __efc_fabctl_wait_ls_acc_cmpl,
+				    NULL);
+		break;
+	}
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric controller node state machine: Wait for LS_ACC.
+ *
+ * @par Description
+ * Waits for the LS_ACC from the fabric controller.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_fabctl_wait_ls_acc_cmpl(struct efc_sm_ctx_s *ctx,
+			      enum efc_sm_event_e evt, void *arg)
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
+	case EFC_EVT_SRRS_ELS_CMPL_OK:
+		efc_assert(node->els_cmpl_cnt, NULL);
+		node->els_cmpl_cnt--;
+		efc_node_transition(node, __efc_fabctl_ready, NULL);
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Initiate fabric node shutdown.
+ *
+ * @param node Node for which shutdown is initiated.
+ *
+ * @return Returns None.
+ */
+
+static void
+efc_fabric_initiate_shutdown(struct efc_node_s *node)
+{
+	int rc;
+	struct efc_lport *efc = node->efc;
+
+	efc->tt.scsi_io_alloc_disable(efc, node);
+
+	if (node->attached) {
+		/* issue hw node free; don't care if succeeds right away
+		 * or sometime later, will check node->attached later in
+		 * shutdown process
+		 */
+		rc = efc->tt.hw_node_detach(efc, &node->rnode);
+		if (rc != EFC_HW_RTN_SUCCESS &&
+		    rc != EFC_HW_RTN_SUCCESS_SYNC) {
+			node_printf(node, "Failed freeing HW node, rc=%d\n",
+				    rc);
+		}
+	}
+	/*
+	 * node has either been detached or is in the process of being detached,
+	 * call common node's initiate cleanup function
+	 */
+	efc_node_initiate_cleanup(node);
+}
+
+/**
+ * @ingroup fabric_sm
+ * @brief Fabric node state machine: Handle the common fabric node events.
+ *
+ * @param funcname Function name text.
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+static void *
+__efc_fabric_common(const char *funcname, struct efc_sm_ctx_s *ctx,
+		    enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_s *node = NULL;
+
+	efc_assert(ctx, NULL);
+	efc_assert(ctx->app, NULL);
+	node = ctx->app;
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		break;
+	case EFC_EVT_SHUTDOWN:
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_fabric_initiate_shutdown(node);
+		break;
+
+	default:
+		/* call default event handler common to all nodes */
+		__efc_node_common(funcname, ctx, evt, arg);
+		break;
+	}
+	return NULL;
+}
+
+/**
+ * @brief Return the node's WWPN as an uint64_t.
+ *
+ * @par Description
+ * The WWPN is computed from service parameters, and returned as a uint64_t.
+ *
+ * @param sp Pointer to service parameters.
+ *
+ * @return Returns WWPN.
+ *
+ */
+
+static uint64_t
+efc_get_wwpn(struct fc_els_flogi *sp)
+{
+	return be64_to_cpu(sp->fl_wwnn);
+}
+
+/**
+ * @brief Return TRUE if the remote node is the point-to-point winner.
+ *
+ * @par Description
+ * Compares WWPNs. Returns TRUE if the remote node's WWPN is numerically
+ * higher than the local node's WWPN.
+ *
+ * @param sport Pointer to the sport object.
+ *
+ * @return
+ * - 0, if the remote node is the loser.
+ * - 1, if the remote node is the winner.
+ * - (-1), if remote node is neither the loser nor the winner
+ *   (WWPNs match)
+ */
+
+static int
+efc_rnode_is_winner(struct efc_sli_port_s *sport)
+{
+	struct fc_els_flogi *remote_sp;
+	u64 remote_wwpn;
+	u64 local_wwpn = sport->wwpn;
+	//char prop_buf[32];
+	u64 wwn_bump = 0;
+
+	remote_sp = (struct fc_els_flogi *)sport->domain->flogi_service_params;
+	remote_wwpn = efc_get_wwpn(remote_sp);
+
+	local_wwpn ^= wwn_bump;
+
+	remote_wwpn = efc_get_wwpn(remote_sp);
+
+	efc_log_debug(sport->efc, "r: %llx\n",
+		      be64_to_cpu(remote_sp->fl_wwpn));
+	efc_log_debug(sport->efc, "l: %llx\n", local_wwpn);
+
+	if (remote_wwpn == local_wwpn) {
+		efc_log_warn(sport->efc,
+			     "WWPN of remote node [%08x %08x] matches local WWPN\n",
+			     (u32)(local_wwpn >> 32ll),
+			     (u32)local_wwpn);
+		return -1;
+	}
+
+	return (remote_wwpn > local_wwpn);
+}
+
+/**
+ * @ingroup p2p_sm
+ * @brief Point-to-point state machine: Wait for the domain attach to complete.
+ *
+ * @par Description
+ * Once the domain attach has completed, a PLOGI is sent (if we're the
+ * winning point-to-point node).
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_p2p_wait_domain_attach(struct efc_sm_ctx_s *ctx,
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
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_DOMAIN_ATTACH_OK: {
+		struct efc_sli_port_s *sport = node->sport;
+		struct efc_node_s *rnode;
+
+		/*
+		 * this transient node (SID=0 (recv'd FLOGI)
+		 * or DID=fabric (sent FLOGI))
+		 * is the p2p winner, will use a separate node
+		 * to send PLOGI to peer
+		 */
+		efc_assert(node->sport->p2p_winner, NULL);
+
+		rnode = efc_node_find(sport, node->sport->p2p_remote_port_id);
+		if (rnode) {
+			/*
+			 * the "other" transient p2p node has
+			 * already kicked off the
+			 * new node from which PLOGI is sent
+			 */
+			node_printf(node,
+				    "Node with fc_id x%x already exists\n",
+				    rnode->rnode.fc_id);
+		} else {
+			/*
+			 * create new node (SID=1, DID=2)
+			 * from which to send PLOGI
+			 */
+			rnode = efc_node_alloc(sport,
+					       sport->p2p_remote_port_id,
+						false, false);
+			if (!rnode) {
+				efc_log_err(efc, "node alloc failed\n");
+				return NULL;
+			}
+
+			efc_fabric_notify_topology(node);
+			/* sm: / allocate p2p remote node */
+			efc_node_transition(rnode, __efc_p2p_rnode_init,
+					    NULL);
+		}
+
+		/*
+		 * the transient node (SID=0 or DID=fabric)
+		 * has served its purpose
+		 */
+		if (node->rnode.fc_id == 0) {
+			/*
+			 * if this is the SID=0 node,
+			 * move to the init state in case peer
+			 * has restarted FLOGI discovery and FLOGI is pending
+			 */
+			/* don't send PLOGI on efc_d_init entry */
+			efc_node_init_device(node, false);
+		} else {
+			/*
+			 * if this is the DID=fabric node
+			 * (we initiated FLOGI), shut it down
+			 */
+			node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+			efc_fabric_initiate_shutdown(node);
+		}
+		break;
+	}
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup p2p_sm
+ * @brief Point-to-point state machine: Remote node initialization state.
+ *
+ * @par Description
+ * This state is entered after winning point-to-point, and the remote node
+ * is instantiated.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_p2p_rnode_init(struct efc_sm_ctx_s *ctx,
+		     enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_cb_s *cbdata = arg;
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		/* sm: / send PLOGI */
+		efc->tt.els_send(efc, node, ELS_PLOGI,
+				EFC_FC_FLOGI_TIMEOUT_SEC,
+				EFC_FC_ELS_DEFAULT_RETRIES);
+		efc_node_transition(node, __efc_p2p_wait_plogi_rsp, NULL);
+		break;
+
+	case EFC_EVT_ABTS_RCVD:
+		/* sm: send BA_ACC */
+		efc->tt.bls_send_acc_hdr(efc, node, cbdata->header->dma.virt);
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup p2p_sm
+ * @brief Point-to-point node state machine:
+ * Wait for the FLOGI accept completion.
+ *
+ * @par Description
+ * Wait for the FLOGI accept completion.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_p2p_wait_flogi_acc_cmpl(struct efc_sm_ctx_s *ctx,
+			      enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_cb_s *cbdata = arg;
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
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_SRRS_ELS_CMPL_OK:
+		efc_assert(node->els_cmpl_cnt, NULL);
+		node->els_cmpl_cnt--;
+
+		/* sm: if p2p_winner / domain_attach */
+		if (node->sport->p2p_winner) {
+			efc_node_transition(node,
+					    __efc_p2p_wait_domain_attach,
+					NULL);
+			if (!node->sport->domain->attached) {
+				node_printf(node, "Domain not attached\n");
+				efc_domain_attach(node->sport->domain,
+						  node->sport->p2p_port_id);
+			} else {
+				node_printf(node, "Domain already attached\n");
+				efc_node_post_event(node,
+						    EFC_EVT_DOMAIN_ATTACH_OK,
+						    NULL);
+			}
+		} else {
+			/* this node has served its purpose;
+			 * we'll expect a PLOGI on a separate
+			 * node (remote SID=0x1); return this node
+			 * to init state in case peer
+			 * restarts discovery -- it may already
+			 * have (pending frames may exist).
+			 */
+			/* don't send PLOGI on efc_d_init entry */
+			efc_node_init_device(node, false);
+		}
+		break;
+
+	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
+		/*
+		 * LS_ACC failed, possibly due to link down;
+		 * shutdown node and wait
+		 * for FLOGI discovery to restart
+		 */
+		node_printf(node, "FLOGI LS_ACC failed, shutting down\n");
+		efc_assert(node->els_cmpl_cnt, NULL);
+		node->els_cmpl_cnt--;
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_fabric_initiate_shutdown(node);
+		break;
+
+	case EFC_EVT_ABTS_RCVD: {
+		/* sm: / send BA_ACC */
+		efc->tt.bls_send_acc_hdr(efc, node,
+					 cbdata->header->dma.virt);
+		break;
+	}
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup p2p_sm
+ * @brief Point-to-point node state machine: Wait for a PLOGI response
+ * as a point-to-point winner.
+ *
+ * @par Description
+ * Wait for a PLOGI response from the remote node as a point-to-point winner.
+ * Submit node attach request to the HW.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_p2p_wait_plogi_rsp(struct efc_sm_ctx_s *ctx,
+			 enum efc_sm_event_e evt, void *arg)
+{
+	int rc;
+	struct efc_node_cb_s *cbdata = arg;
+	struct efc_node_s *node = ctx->app;
+	struct efc_lport *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK: {
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		/* sm: / save sparams, efc_node_attach */
+		efc_node_save_sparms(node, cbdata->els_rsp.virt);
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_p2p_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK,
+					    NULL);
+		break;
+	}
+	case EFC_EVT_SRRS_ELS_REQ_FAIL: {
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		node_printf(node, "PLOGI failed, shutting down\n");
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_fabric_initiate_shutdown(node);
+		break;
+	}
+
+	case EFC_EVT_PLOGI_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+		/* if we're in external loopback mode, just send LS_ACC */
+		if (node->efc->external_loopback) {
+			efc->tt.els_send_resp(efc, node, ELS_PLOGI,
+						be16_to_cpu(hdr->fh_ox_id));
+		} else {
+			/*
+			 * if this isn't external loopback,
+			 * pass to default handler
+			 */
+			__efc_fabric_common(__func__, ctx, evt, arg);
+		}
+		break;
+	}
+	case EFC_EVT_PRLI_RCVD:
+		/* I, or I+T */
+		/* sent PLOGI and before completion was seen, received the
+		 * PRLI from the remote node (WCQEs and RCQEs come in on
+		 * different queues and order of processing cannot be assumed)
+		 * Save OXID so PRLI can be sent after the attach and continue
+		 * to wait for PLOGI response
+		 */
+		efc_process_prli_payload(node, cbdata->payload->dma.virt);
+		efc_send_ls_acc_after_attach(node,
+					     cbdata->header->dma.virt,
+					     EFC_NODE_SEND_LS_ACC_PRLI);
+		efc_node_transition(node, __efc_p2p_wait_plogi_rsp_recvd_prli,
+				    NULL);
+		break;
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup p2p_sm
+ * @brief Point-to-point node state machine:
+ * Waiting on a response for a sent PLOGI.
+ *
+ * @par Description
+ * State is entered when the point-to-point winner has sent
+ * a PLOGI and is waiting for a response. Before receiving the
+ * response, a PRLI was received, implying that the PLOGI was
+ * successful.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_p2p_wait_plogi_rsp_recvd_prli(struct efc_sm_ctx_s *ctx,
+				    enum efc_sm_event_e evt, void *arg)
+{
+	int rc;
+	struct efc_node_cb_s *cbdata = arg;
+	struct efc_node_s *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		/*
+		 * Since we've received a PRLI, we have a port login and will
+		 * just need to wait for the PLOGI response to do the node
+		 * attach and then we can send the LS_ACC for the PRLI. If,
+		 * during this time, we receive FCP_CMNDs (which is possible
+		 * since we've already sent a PRLI and our peer may have
+		 * accepted).
+		 * At this time, we are not waiting on any other unsolicited
+		 * frames to continue with the login process. Thus, it will not
+		 * hurt to hold frames here.
+		 */
+		efc_node_hold_frames(node);
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_OK:	/* PLOGI response received */
+		/* Completion from PLOGI sent */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		/* sm: / save sparams, efc_node_attach */
+		efc_node_save_sparms(node, cbdata->els_rsp.virt);
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_p2p_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK,
+					    NULL);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:	/* PLOGI response received */
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+		/* PLOGI failed, shutdown the node */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_fabric_common, __func__)) {
+			return NULL;
+		}
+		efc_assert(node->els_req_cnt, NULL);
+		node->els_req_cnt--;
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_fabric_initiate_shutdown(node);
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @ingroup p2p_sm
+ * @brief Point-to-point node state machine:
+ * Wait for a point-to-point node attach
+ * to complete.
+ *
+ * @par Description
+ * Waits for the point-to-point node attach to complete.
+ *
+ * @param ctx Remote node state machine context.
+ * @param evt Event to process.
+ * @param arg Per event optional argument.
+ *
+ * @return Returns NULL.
+ */
+
+void *
+__efc_p2p_wait_node_attach(struct efc_sm_ctx_s *ctx,
+			   enum efc_sm_event_e evt, void *arg)
+{
+	struct efc_node_cb_s *cbdata = arg;
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
+	case EFC_EVT_NODE_ATTACH_OK:
+		node->attached = true;
+		switch (node->send_ls_acc) {
+		case EFC_NODE_SEND_LS_ACC_PRLI: {
+			efc_d_send_prli_rsp(node->ls_acc_io,
+					    node->ls_acc_oxid);
+			node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
+			node->ls_acc_io = NULL;
+			break;
+		}
+		case EFC_NODE_SEND_LS_ACC_PLOGI: /* Can't happen in P2P */
+		case EFC_NODE_SEND_LS_ACC_NONE:
+		default:
+			/* Normal case for I */
+			/* sm: send_plogi_acc is not set / send PLOGI acc */
+			efc_node_transition(node, __efc_d_port_logged_in,
+					    NULL);
+			break;
+		}
+		break;
+
+	case EFC_EVT_NODE_ATTACH_FAIL:
+		/* node attach failed, shutdown the node */
+		node->attached = false;
+		node_printf(node, "Node attach failed\n");
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_fabric_initiate_shutdown(node);
+		break;
+
+	case EFC_EVT_SHUTDOWN:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_node_transition(node,
+				    __efc_fabric_wait_attach_evt_shutdown,
+				     NULL);
+		break;
+	case EFC_EVT_PRLI_RCVD:
+		node_printf(node, "%s: PRLI received before node is attached\n",
+			    efc_sm_event_name(evt));
+		efc_process_prli_payload(node, cbdata->payload->dma.virt);
+		efc_send_ls_acc_after_attach(node,
+					     cbdata->header->dma.virt,
+				EFC_NODE_SEND_LS_ACC_PRLI);
+		break;
+
+	default:
+		__efc_fabric_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/**
+ * @brief Start up the name services node.
+ *
+ * @par Description
+ * Allocates and starts up the name services node.
+ *
+ * @param sport Pointer to the sport structure.
+ *
+ * @return Returns 0 on success, or a negative error value on failure.
+ */
+
+static int
+efc_start_ns_node(struct efc_sli_port_s *sport)
+{
+	struct efc_node_s *ns;
+
+	/* Instantiate a name services node */
+	ns = efc_node_find(sport, FC_FID_DIR_SERV);
+	if (!ns) {
+		ns = efc_node_alloc(sport, FC_FID_DIR_SERV, false, false);
+		if (!ns)
+			return -1;
+	}
+	/*
+	 * for found ns, should we be transitioning from here?
+	 * breaks transition only
+	 *  1. from within state machine or
+	 *  2. if after alloc
+	 */
+	if (ns->efc->nodedb_mask & EFC_NODEDB_PAUSE_NAMESERVER)
+		efc_node_pause(ns, __efc_ns_init);
+	else
+		efc_node_transition(ns, __efc_ns_init, NULL);
+	return 0;
+}
+
+/**
+ * @brief Start up the fabric controller node.
+ *
+ * @par Description
+ * Allocates and starts up the fabric controller node.
+ *
+ * @param sport Pointer to the sport structure.
+ *
+ * @return Returns 0 on success, or a negative error value on failure.
+ */
+
+static int
+efc_start_fabctl_node(struct efc_sli_port_s *sport)
+{
+	struct efc_node_s *fabctl;
+
+	fabctl = efc_node_find(sport, FC_FID_FCTRL);
+	if (!fabctl) {
+		fabctl = efc_node_alloc(sport, FC_FID_FCTRL,
+					false, false);
+		if (!fabctl)
+			return -1;
+	}
+	/*
+	 * for found ns, should we be transitioning from here?
+	 * breaks transition only
+	 *  1. from within state machine or
+	 *  2. if after alloc
+	 */
+	efc_node_transition(fabctl, __efc_fabctl_init, NULL);
+	return 0;
+}
+
+/**
+ * @brief Process the GIDPT payload.
+ *
+ * @par Description
+ * The GIDPT payload is parsed, and new nodes are created, as needed.
+ *
+ * @param node Pointer to the node structure.
+ * @param gidpt Pointer to the GIDPT payload.
+ * @param gidpt_len Payload length
+ *
+ * @return Returns 0 on success, or a negative error value on failure.
+ */
+
+static int
+efc_process_gidpt_payload(struct efc_node_s *node,
+			  void *data, u32 gidpt_len)
+{
+	u32 i, j;
+	struct efc_node_s *newnode;
+	struct efc_sli_port_s *sport = node->sport;
+	struct efc_lport *efc = node->efc;
+	u32 port_id = 0, port_count, portlist_count;
+	struct efc_node_s *n;
+	struct efc_node_s **active_nodes;
+	int residual;
+	struct fc_ct_hdr *hdr = data;
+	struct fc_gid_pn_resp *gidpt = data + sizeof(*hdr);
+
+	residual = be16_to_cpu(hdr->ct_mr_size);
+
+	if (residual != 0)
+		efc_log_debug(node->efc, "residual is %u words\n", residual);
+
+	if (be16_to_cpu(hdr->ct_cmd) == FC_FS_RJT) {
+		node_printf(node,
+			    "GIDPT request failed: rsn x%x rsn_expl x%x\n",
+			    hdr->ct_reason, hdr->ct_explan);
+		return -1;
+	}
+
+	portlist_count = (gidpt_len - sizeof(*hdr)) / sizeof(*gidpt);
+
+	/* Count the number of nodes */
+	port_count = 0;
+	list_for_each_entry(n, &sport->node_list, list_entry) {
+		port_count++;
+	}
+
+	/* Allocate a buffer for all nodes */
+	active_nodes = kzalloc(port_count * sizeof(*active_nodes), GFP_ATOMIC);
+	if (!active_nodes) {
+		node_printf(node, "efc_malloc failed\n");
+		return -1;
+	}
+
+	/* Fill buffer with fc_id of active nodes */
+	i = 0;
+	list_for_each_entry(n, &sport->node_list, list_entry) {
+		port_id = n->rnode.fc_id;
+		switch (port_id) {
+		case FC_FID_FLOGI:
+		case FC_FID_FCTRL:
+		case FC_FID_DIR_SERV:
+			break;
+		default:
+			if (port_id != FC_FID_DOM_MGR)
+				active_nodes[i++] = n;
+			break;
+		}
+	}
+
+	/* update the active nodes buffer */
+	for (i = 0; i < portlist_count; i++) {
+		hton24(gidpt[i].fp_fid, port_id);
+
+		for (j = 0; j < port_count; j++) {
+			if (active_nodes[j] &&
+			    port_id == active_nodes[j]->rnode.fc_id) {
+				active_nodes[j] = NULL;
+			}
+		}
+
+		if (gidpt[i].fp_resvd & FC_NS_FID_LAST)
+			break;
+	}
+
+	/* Those remaining in the active_nodes[] are now gone ! */
+	for (i = 0; i < port_count; i++) {
+		/*
+		 * if we're an initiator and the remote node
+		 * is a target, then post the node missing event.
+		 * if we're target and we have enabled
+		 * target RSCN, then post the node missing event.
+		 */
+		if (active_nodes[i]) {
+			if ((node->sport->enable_ini &&
+			     active_nodes[i]->targ) ||
+			     (node->sport->enable_tgt &&
+			     enable_target_rscn(efc))) {
+				efc_node_post_event(active_nodes[i],
+						    EFC_EVT_NODE_MISSING,
+						     NULL);
+			} else {
+				node_printf(node,
+					    "GID_PT: skipping non-tgt port_id x%06x\n",
+					    active_nodes[i]->rnode.fc_id);
+			}
+		}
+	}
+	kfree(active_nodes);
+
+	for (i = 0; i < portlist_count; i++) {
+		hton24(gidpt[i].fp_fid, port_id);
+
+		/* Don't create node for ourselves */
+		if (port_id != node->rnode.sport->fc_id) {
+			newnode = efc_node_find(sport, port_id);
+			if (!newnode) {
+				if (node->sport->enable_ini) {
+					newnode = efc_node_alloc(sport,
+								 port_id,
+								  false,
+								  false);
+					if (!newnode) {
+						efc_log_err(efc,
+							    "efc_node_alloc() failed\n");
+						return -1;
+					}
+					/*
+					 * send PLOGI automatically
+					 * if initiator
+					 */
+					efc_node_init_device(newnode, true);
+				}
+				continue;
+			}
+
+			if (node->sport->enable_ini && newnode->targ) {
+				efc_node_post_event(newnode,
+						    EFC_EVT_NODE_REFOUND,
+						    NULL);
+			}
+			/*
+			 * original code sends ADISC,
+			 * has notion of "refound"
+			 */
+		}
+
+		if (gidpt[i].fp_resvd & FC_NS_FID_LAST)
+			break;
+	}
+	return 0;
+}
+
+/**
+ * @brief Set up the domain point-to-point parameters.
+ *
+ * @par Description
+ * The remote node service parameters are examined, and various point-to-point
+ * variables are set.
+ *
+ * @param sport Pointer to the sport object.
+ *
+ * @return Returns 0 on success, or a negative error value on failure.
+ */
+
+int
+efc_p2p_setup(struct efc_sli_port_s *sport)
+{
+	struct efc_lport *efc = sport->efc;
+	int rnode_winner;
+
+	rnode_winner = efc_rnode_is_winner(sport);
+
+	/* set sport flags to indicate p2p "winner" */
+	if (rnode_winner == 1) {
+		sport->p2p_remote_port_id = 0;
+		sport->p2p_port_id = 0;
+		sport->p2p_winner = false;
+	} else if (rnode_winner == 0) {
+		sport->p2p_remote_port_id = 2;
+		sport->p2p_port_id = 1;
+		sport->p2p_winner = true;
+	} else {
+		/* no winner; only okay if external loopback enabled */
+		if (sport->efc->external_loopback) {
+			/*
+			 * External loopback mode enabled;
+			 * local sport and remote node
+			 * will be registered with an NPortID = 1;
+			 */
+			efc_log_debug(efc,
+				      "External loopback mode enabled\n");
+			sport->p2p_remote_port_id = 1;
+			sport->p2p_port_id = 1;
+			sport->p2p_winner = true;
+		} else {
+			efc_log_warn(efc,
+				     "failed to determine p2p winner\n");
+			return rnode_winner;
+		}
+	}
+	return 0;
+}
+
+/**
+ * @brief Process the FABCTL node RSCN.
+ *
+ * <h3 class="desc">Description</h3>
+ * Processes the FABCTL node RSCN payload,
+ * simply passes the event to the name server.
+ *
+ * @param node Pointer to the node structure.
+ * @param cbdata Callback data to pass forward.
+ *
+ * @return None.
+ */
+
+static void
+efc_process_rscn(struct efc_node_s *node, struct efc_node_cb_s *cbdata)
+{
+	struct efc_lport *efc = node->efc;
+	struct efc_sli_port_s *sport = node->sport;
+	struct efc_node_s *ns;
+
+	/* Forward this event to the name-services node */
+	ns = efc_node_find(sport, FC_FID_DIR_SERV);
+	if (ns)
+		efc_node_post_event(ns, EFC_EVT_RSCN_RCVD, cbdata);
+	else
+		efc_log_warn(efc, "can't find name server node\n");
+}
diff --git a/drivers/scsi/elx/libefc/efc_fabric.h b/drivers/scsi/elx/libefc/efc_fabric.h
new file mode 100644
index 000000000000..7c5f5e0ea5ba
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_fabric.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * Declarations for the interface exported by efc_fabric
+ */
+
+#if !defined(__EFCT_FABRIC_H__)
+#define __EFCT_FABRIC_H__
+#include "scsi/fc/fc_els.h"
+#include "scsi/fc/fc_fs.h"
+#include "scsi/fc/fc_ns.h"
+
+void *
+__efc_fabric_init(struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabric_flogi_wait_rsp(struct efc_sm_ctx_s *ctx,
+			    enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabric_domain_attach_wait(struct efc_sm_ctx_s *ctx,
+				enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabric_wait_domain_attach(struct efc_sm_ctx_s *ctx,
+				enum efc_sm_event_e evt, void *arg);
+
+void *
+__efc_vport_fabric_init(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabric_fdisc_wait_rsp(struct efc_sm_ctx_s *ctx,
+			    enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabric_wait_sport_attach(struct efc_sm_ctx_s *ctx,
+			       enum efc_sm_event_e evt, void *arg);
+
+void *
+__efc_ns_init(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt, void *arg);
+void *
+__efc_ns_plogi_wait_rsp(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg);
+void *
+__efc_ns_rftid_wait_rsp(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg);
+void *
+__efc_ns_rffid_wait_rsp(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg);
+void *
+__efc_ns_wait_node_attach(struct efc_sm_ctx_s *ctx,
+			  enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabric_wait_attach_evt_shutdown(struct efc_sm_ctx_s *ctx,
+				      enum efc_sm_event_e evt, void *arg);
+void *
+__efc_ns_logo_wait_rsp(struct efc_sm_ctx_s *ctx,
+		       enum efc_sm_event_e, void *arg);
+void *
+__efc_ns_gidpt_wait_rsp(struct efc_sm_ctx_s *ctx,
+			enum efc_sm_event_e evt, void *arg);
+void *
+__efc_ns_idle(struct efc_sm_ctx_s *ctx, enum efc_sm_event_e evt, void *arg);
+void *
+__efc_ns_gidpt_delay(struct efc_sm_ctx_s *ctx,
+		     enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabctl_init(struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabctl_wait_node_attach(struct efc_sm_ctx_s *ctx,
+			      enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabctl_wait_scr_rsp(struct efc_sm_ctx_s *ctx,
+			  enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabctl_ready(struct efc_sm_ctx_s *ctx,
+		   enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabctl_wait_ls_acc_cmpl(struct efc_sm_ctx_s *ctx,
+			      enum efc_sm_event_e evt, void *arg);
+void *
+__efc_fabric_idle(struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *arg);
+
+void *
+__efc_p2p_rnode_init(struct efc_sm_ctx_s *ctx,
+		     enum efc_sm_event_e evt, void *arg);
+void *
+__efc_p2p_domain_attach_wait(struct efc_sm_ctx_s *ctx,
+			     enum efc_sm_event_e evt, void *arg);
+void *
+__efc_p2p_wait_flogi_acc_cmpl(struct efc_sm_ctx_s *ctx,
+			      enum efc_sm_event_e evt, void *arg);
+void *
+__efc_p2p_wait_plogi_rsp(struct efc_sm_ctx_s *ctx,
+			 enum efc_sm_event_e evt, void *arg);
+void *
+__efc_p2p_wait_plogi_rsp_recvd_prli(struct efc_sm_ctx_s *ctx,
+				    enum efc_sm_event_e evt, void *arg);
+void *
+__efc_p2p_wait_domain_attach(struct efc_sm_ctx_s *ctx,
+			     enum efc_sm_event_e evt, void *arg);
+void *
+__efc_p2p_wait_node_attach(struct efc_sm_ctx_s *ctx,
+			   enum efc_sm_event_e evt, void *arg);
+
+int
+efc_p2p_setup(struct efc_sli_port_s *sport);
+void
+efc_fabric_set_topology(struct efc_node_s *node,
+			enum efc_sport_topology_e topology);
+void efc_fabric_notify_topology(struct efc_node_s *node);
+
+#endif /* __EFCT_FABRIC_H__ */
-- 
2.13.7

