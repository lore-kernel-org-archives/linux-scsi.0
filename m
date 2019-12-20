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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D371DC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92F9E2082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdyPe3sy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLTWhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:46 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42896 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfLTWhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:45 -0500
Received: by mail-pl1-f193.google.com with SMTP id p9so4706605plk.9
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/9O6FpUReNEAkXYF61Jye6cH70qowyZuouuRPFf61Tk=;
        b=IdyPe3syCG7ih50hXiPcLWje+ow0eAPYZvR/VoRV0Mz1t/6zmJRCa4aPZFvf8Un97Y
         hbq6OCiGKclsDkN/j9+1owgh3jgWX4NSPnMlf26IqyzEpyiIyuR+aRWm0QaAql5ysUQm
         9kyF2tOB9E5NO052nwDC7yceaxc5RMPD66BOuq6ms4BE9e/VGjV92cjmBMJ0usvQV7y4
         /20tlLT3GOmecQrLGqDjvuMNc/D3QIh8rr8T0ZXAy6QRKAr1u5L0uU2bbU1W8c6r3dra
         L4tEzMqtuO85udCk1UwIXF3stfyTH2wJKbgUx+/RLovekFNY/2eucrASbNWBfwia8xBd
         9B0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/9O6FpUReNEAkXYF61Jye6cH70qowyZuouuRPFf61Tk=;
        b=ey0Bsi1Cq4dcwIXGTk7/4k8q6fqPPd6ccnQekelPypeHRtNpIlSQRw1oqn8Qe6W/F6
         oAFyq9Z9pLC1ZSYdfa4y4xsYeFioiKJGuBrlv/OHwNIqNdo1UQBRIAzhAehxLsPobgia
         gPqkUECBU5q9D07RqmPd0RMR6s45vy1A/xuQbVGY47JI3ZZP6Ensbaq033bLL+IE8OIV
         qEfgQOACKqXpRBVHbXO74JGIn08/djesswbk2jDS/K1EpcFopPDIE3TS9arZ7DQUyzpJ
         8iYcsx40rL2bnkQdH2wemumQOfo4CV9cTP/trhLDpjPYsCAov3Hb/r+A//GYvOiqgV4X
         +j8w==
X-Gm-Message-State: APjAAAUG/dk1Y+yyayxfanR8sSEkKO3Us6GG1vYBEjxRCApHd/vV2Yys
        5yf/x31SKy71/5XrouanXG9oU4fd
X-Google-Smtp-Source: APXvYqx0RJGQNSRVJENJtN1vJ2XyYu3wrHfhKg0sjd6CEdWeVn1XRQffkKrjIwI17hOZq5U8taOR5w==
X-Received: by 2002:a17:902:59c9:: with SMTP id d9mr17526789plj.184.1576881463296;
        Fri, 20 Dec 2019 14:37:43 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:42 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 11/32] elx: libefc: SLI and FC PORT state machine interfaces
Date:   Fri, 20 Dec 2019 14:37:02 -0800
Message-Id: <20191220223723.26563-12-jsmart2021@gmail.com>
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

This patch continues the libefc library population.

This patch adds library interface definitions for:
- SLI and FC port (aka n_port_id) registration, allocation and
  deallocation.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc/efc_sport.c | 843 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_sport.h |  52 +++
 2 files changed, 895 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_sport.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sport.h

diff --git a/drivers/scsi/elx/libefc/efc_sport.c b/drivers/scsi/elx/libefc/efc_sport.c
new file mode 100644
index 000000000000..11f3ba73ec6e
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sport.c
@@ -0,0 +1,843 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * Details SLI port (sport) functions.
+ */
+
+#include "efc.h"
+
+/* HW sport callback events from the user driver */
+int
+efc_lport_cb(void *arg, int event, void *data)
+{
+	struct efc *efc = arg;
+	struct efc_sli_port *sport = data;
+
+	switch (event) {
+	case EFC_HW_PORT_ALLOC_OK:
+		efc_log_debug(efc, "EFC_HW_PORT_ALLOC_OK\n");
+		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_ALLOC_OK, NULL);
+		break;
+	case EFC_HW_PORT_ALLOC_FAIL:
+		efc_log_debug(efc, "EFC_HW_PORT_ALLOC_FAIL\n");
+		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_ALLOC_FAIL, NULL);
+		break;
+	case EFC_HW_PORT_ATTACH_OK:
+		efc_log_debug(efc, "EFC_HW_PORT_ATTACH_OK\n");
+		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_ATTACH_OK, NULL);
+		break;
+	case EFC_HW_PORT_ATTACH_FAIL:
+		efc_log_debug(efc, "EFC_HW_PORT_ATTACH_FAIL\n");
+		efc_sm_post_event(&sport->sm,
+				  EFC_EVT_SPORT_ATTACH_FAIL, NULL);
+		break;
+	case EFC_HW_PORT_FREE_OK:
+		efc_log_debug(efc, "EFC_HW_PORT_FREE_OK\n");
+		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_FREE_OK, NULL);
+		break;
+	case EFC_HW_PORT_FREE_FAIL:
+		efc_log_debug(efc, "EFC_HW_PORT_FREE_FAIL\n");
+		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_FREE_FAIL, NULL);
+		break;
+	default:
+		efc_log_test(efc, "unknown event %#x\n", event);
+	}
+
+	return 0;
+}
+
+struct efc_sli_port *
+efc_sport_alloc(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
+		u32 fc_id, bool enable_ini, bool enable_tgt)
+{
+	struct efc_sli_port *sport;
+
+	if (domain->efc->enable_ini)
+		enable_ini = 0;
+
+	/* Return a failure if this sport has already been allocated */
+	if (wwpn != 0) {
+		sport = efc_sport_find_wwn(domain, wwnn, wwpn);
+		if (sport) {
+			efc_log_err(domain->efc,
+				    "Failed: SPORT %016llX %016llX already allocated\n",
+				    wwnn, wwpn);
+			return NULL;
+		}
+	}
+
+	sport = kzalloc(sizeof(*sport), GFP_ATOMIC);
+	if (!sport)
+		return sport;
+
+	sport->efc = domain->efc;
+	snprintf(sport->display_name, sizeof(sport->display_name), "------");
+	sport->domain = domain;
+	sport->lookup = efc_spv_new(domain->efc);
+	sport->instance_index = domain->sport_instance_count++;
+	INIT_LIST_HEAD(&sport->node_list);
+	sport->sm.app = sport;
+	sport->enable_ini = enable_ini;
+	sport->enable_tgt = enable_tgt;
+	sport->enable_rscn = (sport->enable_ini ||
+			(sport->enable_tgt && enable_target_rscn(sport->efc)));
+
+	/* Copy service parameters from domain */
+	memcpy(sport->service_params, domain->service_params,
+		sizeof(struct fc_els_flogi));
+
+	/* Update requested fc_id */
+	sport->fc_id = fc_id;
+
+	/* Update the sport's service parameters for the new wwn's */
+	sport->wwpn = wwpn;
+	sport->wwnn = wwnn;
+	snprintf(sport->wwnn_str, sizeof(sport->wwnn_str), "%016llX", wwnn);
+
+	/*
+	 * if this is the "first" sport of the domain,
+	 * then make it the "phys" sport
+	 */
+	if (list_empty(&domain->sport_list))
+		domain->sport = sport;
+
+	INIT_LIST_HEAD(&sport->list_entry);
+	list_add_tail(&sport->list_entry, &domain->sport_list);
+
+	efc_log_debug(domain->efc, "[%s] allocate sport\n",
+		      sport->display_name);
+
+	return sport;
+}
+
+void
+efc_sport_free(struct efc_sli_port *sport)
+{
+	struct efc_domain *domain;
+
+	if (!sport)
+		return;
+
+	domain = sport->domain;
+	efc_log_debug(domain->efc, "[%s] free sport\n", sport->display_name);
+	list_del(&sport->list_entry);
+	/*
+	 * if this is the physical sport,
+	 * then clear it out of the domain
+	 */
+	if (sport == domain->sport)
+		domain->sport = NULL;
+
+	efc_spv_del(sport->lookup);
+	sport->lookup = NULL;
+
+	efc_spv_set(domain->lookup, sport->fc_id, NULL);
+
+	if (list_empty(&domain->sport_list))
+		efc_domain_post_event(domain, EFC_EVT_ALL_CHILD_NODES_FREE,
+				      NULL);
+
+	kfree(sport);
+}
+
+void
+efc_sport_force_free(struct efc_sli_port *sport)
+{
+	struct efc_node *node;
+	struct efc_node *next;
+
+	/* shutdown sm processing */
+	efc_sm_disable(&sport->sm);
+
+	list_for_each_entry_safe(node, next, &sport->node_list, list_entry) {
+		efc_node_force_free(node);
+	}
+
+	efc_sport_free(sport);
+}
+
+/* Find a SLI port object, given an FC_ID */
+struct efc_sli_port *
+efc_sport_find(struct efc_domain *domain, u32 d_id)
+{
+	struct efc_sli_port *sport;
+
+	if (!domain->lookup) {
+		efc_log_test(domain->efc,
+			     "assertion failed: domain->lookup is not valid\n");
+		return NULL;
+	}
+
+	sport = efc_spv_get(domain->lookup, d_id);
+	return sport;
+}
+
+/* Find a SLI port, given the WWNN and WWPN */
+struct efc_sli_port *
+efc_sport_find_wwn(struct efc_domain *domain, uint64_t wwnn, uint64_t wwpn)
+{
+	struct efc_sli_port *sport = NULL;
+
+	list_for_each_entry(sport, &domain->sport_list, list_entry) {
+		if (sport->wwnn == wwnn && sport->wwpn == wwpn)
+			return sport;
+	}
+	return NULL;
+}
+
+/* External call to request an attach for a sport, given an FC_ID */
+int
+efc_sport_attach(struct efc_sli_port *sport, u32 fc_id)
+{
+	int rc;
+	struct efc_node *node;
+	struct efc *efc = sport->efc;
+
+	/* Set our lookup */
+	efc_spv_set(sport->domain->lookup, fc_id, sport);
+
+	/* Update our display_name */
+	efc_node_fcid_display(fc_id, sport->display_name,
+			      sizeof(sport->display_name));
+
+	list_for_each_entry(node, &sport->node_list, list_entry) {
+		efc_node_update_display_name(node);
+	}
+
+	efc_log_debug(sport->efc, "[%s] attach sport: fc_id x%06x\n",
+		      sport->display_name, fc_id);
+
+	rc = efc->tt.hw_port_attach(efc, sport, fc_id);
+	if (rc != EFC_HW_RTN_SUCCESS) {
+		efc_log_err(sport->efc,
+			    "efc_hw_port_attach failed: %d\n", rc);
+		return -1;
+	}
+	return 0;
+}
+
+static void
+efc_sport_shutdown(struct efc_sli_port *sport)
+{
+	struct efc *efc = sport->efc;
+	struct efc_node *node;
+	struct efc_node *node_next;
+
+	list_for_each_entry_safe(node, node_next,
+				 &sport->node_list, list_entry) {
+		if (node->rnode.fc_id != FC_FID_FLOGI ||
+		    !sport->is_vport) {
+			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
+			continue;
+		}
+
+		/*
+		 * If this is a vport, logout of the fabric
+		 * controller so that it deletes the vport
+		 * on the switch.
+		 */
+		/* if link is down, don't send logo */
+		if (efc->link_status == EFC_LINK_STATUS_DOWN) {
+			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
+		} else {
+			efc_log_debug(efc,
+				      "[%s] sport shutdown vport, sending logo to node\n",
+				      node->display_name);
+
+			if (efc->tt.els_send(efc, node, ELS_LOGO,
+					     EFC_FC_FLOGI_TIMEOUT_SEC,
+					EFC_FC_ELS_DEFAULT_RETRIES)) {
+				/* sent LOGO, wait for response */
+				efc_node_transition(node,
+						    __efc_d_wait_logo_rsp,
+						     NULL);
+				continue;
+			}
+
+			/*
+			 * failed to send LOGO,
+			 * go ahead and cleanup node anyways
+			 */
+			node_printf(node, "Failed to send LOGO\n");
+			efc_node_post_event(node,
+					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
+					    NULL);
+		}
+	}
+}
+
+/* Clear the sport reference in the vport specification */
+static void
+efc_vport_link_down(struct efc_sli_port *sport)
+{
+	struct efc *efc = sport->efc;
+	struct efc_vport_spec *vport;
+
+	list_for_each_entry(vport, &efc->vport_list, list_entry) {
+		if (vport->sport == sport) {
+			vport->sport = NULL;
+			break;
+		}
+	}
+}
+
+static void *
+__efc_sport_common(const char *funcname, struct efc_sm_ctx *ctx,
+		   enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport = ctx->app;
+	struct efc_domain *domain = sport->domain;
+	struct efc *efc = sport->efc;
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+	case EFC_EVT_REENTER:
+	case EFC_EVT_EXIT:
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		break;
+	case EFC_EVT_SPORT_ATTACH_OK:
+			efc_sm_transition(ctx, __efc_sport_attached, NULL);
+		break;
+	case EFC_EVT_SHUTDOWN: {
+		int node_list_empty;
+
+		/* Flag this sport as shutting down */
+		sport->shutting_down = true;
+
+		if (sport->is_vport)
+			efc_vport_link_down(sport);
+
+		node_list_empty = list_empty(&sport->node_list);
+
+		if (node_list_empty) {
+			/* sm: node list is empty / efc_hw_port_free */
+			/*
+			 * Remove the sport from the domain's
+			 * sparse vector lookup table
+			 */
+			efc_spv_set(domain->lookup, sport->fc_id, NULL);
+			efc_sm_transition(ctx, __efc_sport_wait_port_free,
+					  NULL);
+			if (efc->tt.hw_port_free(efc, sport)) {
+				efc_log_test(sport->efc,
+					     "efc_hw_port_free failed\n");
+				/* Not much we can do, free the sport anyways */
+				efc_sport_free(sport);
+			}
+		} else {
+			/* sm: node list is not empty / shutdown nodes */
+			efc_sm_transition(ctx,
+					  __efc_sport_wait_shutdown, NULL);
+			efc_sport_shutdown(sport);
+		}
+		break;
+	}
+	default:
+		efc_log_test(sport->efc, "[%s] %-20s %-20s not handled\n",
+			     sport->display_name, funcname,
+			     efc_sm_event_name(evt));
+		break;
+	}
+
+	return NULL;
+}
+
+/* SLI port state machine: Physical sport allocated */
+void *
+__efc_sport_allocated(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport = ctx->app;
+	struct efc_domain *domain = sport->domain;
+
+	sport_sm_trace(sport);
+
+	switch (evt) {
+	/* the physical sport is attached */
+	case EFC_EVT_SPORT_ATTACH_OK:
+		efc_assert(sport == domain->sport, NULL);
+		efc_sm_transition(ctx, __efc_sport_attached, NULL);
+		break;
+
+	case EFC_EVT_SPORT_ALLOC_OK:
+		/* ignore */
+		break;
+	default:
+		__efc_sport_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+	return NULL;
+}
+
+/* SLI port state machine: Handle initial virtual port events */
+void *
+__efc_sport_vport_init(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport = ctx->app;
+	struct efc *efc = sport->efc;
+
+	sport_sm_trace(sport);
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		__be64 be_wwpn = cpu_to_be64(sport->wwpn);
+
+		if (sport->wwpn == 0)
+			efc_log_debug(efc, "vport: letting f/w select WWN\n");
+
+		if (sport->fc_id != U32_MAX) {
+			efc_log_debug(efc, "vport: hard coding port id: %x\n",
+				      sport->fc_id);
+		}
+
+		efc_sm_transition(ctx, __efc_sport_vport_wait_alloc, NULL);
+		/* If wwpn is zero, then we'll let the f/w */
+		if (efc->tt.hw_port_alloc(efc, sport, sport->domain,
+					  sport->wwpn == 0 ? NULL :
+					  (uint8_t *)&be_wwpn)) {
+			efc_log_err(efc, "Can't allocate port\n");
+			break;
+		}
+
+		break;
+	}
+	default:
+		__efc_sport_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+	return NULL;
+}
+
+/**
+ * SLI port state machine:
+ * Wait for the HW SLI port allocation to complete
+ */
+void *
+__efc_sport_vport_wait_alloc(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport = ctx->app;
+	struct efc *efc = sport->efc;
+
+	sport_sm_trace(sport);
+
+	switch (evt) {
+	case EFC_EVT_SPORT_ALLOC_OK: {
+		struct fc_els_flogi *sp;
+		struct efc_node *fabric;
+
+		sp = (struct fc_els_flogi *)sport->service_params;
+		/*
+		 * If we let f/w assign wwn's,
+		 * then sport wwn's with those returned by hw
+		 */
+		if (sport->wwnn == 0) {
+			sport->wwnn = be64_to_cpu(sport->sli_wwnn);
+			sport->wwpn = be64_to_cpu(sport->sli_wwpn);
+			snprintf(sport->wwnn_str, sizeof(sport->wwnn_str),
+				 "%016llX", sport->wwpn);
+		}
+
+		/* Update the sport's service parameters */
+		sp->fl_wwpn = cpu_to_be64(sport->wwpn);
+		sp->fl_wwnn = cpu_to_be64(sport->wwnn);
+
+		/*
+		 * if sport->fc_id is uninitialized,
+		 * then request that the fabric node use FDISC
+		 * to find an fc_id.
+		 * Otherwise we're restoring vports, or we're in
+		 * fabric emulation mode, so attach the fc_id
+		 */
+		if (sport->fc_id == U32_MAX) {
+			fabric = efc_node_alloc(sport, FC_FID_FLOGI, false,
+						false);
+			if (!fabric) {
+				efc_log_err(efc, "efc_node_alloc() failed\n");
+				return NULL;
+			}
+			efc_node_transition(fabric, __efc_vport_fabric_init,
+					    NULL);
+		} else {
+			snprintf(sport->wwnn_str, sizeof(sport->wwnn_str),
+				 "%016llX", sport->wwpn);
+			efc_sport_attach(sport, sport->fc_id);
+		}
+		efc_sm_transition(ctx, __efc_sport_vport_allocated, NULL);
+		break;
+	}
+	default:
+		__efc_sport_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+	return NULL;
+}
+
+/**
+ * SLI port state machine: virtual sport allocated.
+ *
+ * This state is entered after the sport is allocated;
+ * it then waits for a fabric node
+ * FDISC to complete, which requests a sport attach.
+ * The sport attach complete is handled in this state.
+ */
+
+void *
+__efc_sport_vport_allocated(struct efc_sm_ctx *ctx,
+			    enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport = ctx->app;
+	struct efc *efc = sport->efc;
+
+	sport_sm_trace(sport);
+
+	switch (evt) {
+	case EFC_EVT_SPORT_ATTACH_OK: {
+		struct efc_node *node;
+
+		/* Find our fabric node, and forward this event */
+		node = efc_node_find(sport, FC_FID_FLOGI);
+		if (!node) {
+			efc_log_test(efc, "can't find node %06x\n",
+				     FC_FID_FLOGI);
+			break;
+		}
+		/* sm: / forward sport attach to fabric node */
+		efc_node_post_event(node, evt, NULL);
+		efc_sm_transition(ctx, __efc_sport_attached, NULL);
+		break;
+	}
+	default:
+		__efc_sport_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+	return NULL;
+}
+
+static void
+efc_vport_update_spec(struct efc_sli_port *sport)
+{
+	struct efc *efc = sport->efc;
+	struct efc_vport_spec *vport;
+
+	list_for_each_entry(vport, &efc->vport_list, list_entry) {
+		if (vport->sport == sport) {
+			vport->wwnn = sport->wwnn;
+			vport->wwpn = sport->wwpn;
+			vport->tgt_data = sport->tgt_data;
+			vport->ini_data = sport->ini_data;
+			break;
+		}
+	}
+}
+
+/* State entered after the sport attach has completed */
+void *
+__efc_sport_attached(struct efc_sm_ctx *ctx,
+		     enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport = ctx->app;
+	struct efc *efc = sport->efc;
+
+	sport_sm_trace(sport);
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		struct efc_node *node;
+
+		efc_log_debug(efc,
+			      "[%s] SPORT attached WWPN %016llX WWNN %016llX\n",
+			      sport->display_name,
+			      sport->wwpn, sport->wwnn);
+
+		list_for_each_entry(node, &sport->node_list, list_entry) {
+			efc_node_update_display_name(node);
+		}
+
+		sport->tgt_id = sport->fc_id;
+
+		efc->tt.new_sport(efc, sport);
+
+		/*
+		 * Update the vport (if its not the physical sport)
+		 * parameters
+		 */
+		if (sport->is_vport)
+			efc_vport_update_spec(sport);
+		break;
+	}
+
+	case EFC_EVT_EXIT:
+		efc_log_debug(efc,
+			      "[%s] SPORT deattached WWPN %016llX WWNN %016llX\n",
+			      sport->display_name,
+			      sport->wwpn, sport->wwnn);
+
+		efc->tt.del_sport(efc, sport);
+		break;
+	default:
+		__efc_sport_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+	return NULL;
+}
+
+
+/* SLI port state machine: Wait for the node shutdowns to complete */
+void *
+__efc_sport_wait_shutdown(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport = ctx->app;
+	struct efc_domain *domain = sport->domain;
+	struct efc *efc = sport->efc;
+
+	sport_sm_trace(sport);
+
+	switch (evt) {
+	case EFC_EVT_SPORT_ALLOC_OK:
+	case EFC_EVT_SPORT_ALLOC_FAIL:
+	case EFC_EVT_SPORT_ATTACH_OK:
+	case EFC_EVT_SPORT_ATTACH_FAIL:
+		/* ignore these events - just wait for the all free event */
+		break;
+
+	case EFC_EVT_ALL_CHILD_NODES_FREE: {
+		/*
+		 * Remove the sport from the domain's
+		 * sparse vector lookup table
+		 */
+		efc_spv_set(domain->lookup, sport->fc_id, NULL);
+		efc_sm_transition(ctx, __efc_sport_wait_port_free, NULL);
+		if (efc->tt.hw_port_free(efc, sport)) {
+			efc_log_err(sport->efc, "efc_hw_port_free failed\n");
+			/* Not much we can do, free the sport anyways */
+			efc_sport_free(sport);
+		}
+		break;
+	}
+	default:
+		__efc_sport_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+	return NULL;
+}
+
+/* SLI port state machine: Wait for the HW's port free to complete */
+void *
+__efc_sport_wait_port_free(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport = ctx->app;
+
+	sport_sm_trace(sport);
+
+	switch (evt) {
+	case EFC_EVT_SPORT_ATTACH_OK:
+		/* Ignore as we are waiting for the free CB */
+		break;
+	case EFC_EVT_SPORT_FREE_OK: {
+		/* All done, free myself */
+		/* sm: / efc_sport_free */
+		efc_sport_free(sport);
+		break;
+	}
+	default:
+		__efc_sport_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+	return NULL;
+}
+
+/* Use the vport specification to find the associated vports and start them */
+int
+efc_vport_start(struct efc_domain *domain)
+{
+	struct efc *efc = domain->efc;
+	struct efc_vport_spec *vport;
+	struct efc_vport_spec *next;
+	struct efc_sli_port *sport;
+	int rc = 0;
+	u8 found = false;
+
+	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
+		if (!vport->sport) {
+			found = true;
+			break;
+		}
+	}
+
+	if (found && vport) {
+		sport = efc_sport_alloc(domain, vport->wwpn,
+					vport->wwnn, vport->fc_id,
+					vport->enable_ini,
+					vport->enable_tgt);
+		vport->sport = sport;
+		if (!sport) {
+			rc = -1;
+		} else {
+			sport->is_vport = true;
+			sport->tgt_data = vport->tgt_data;
+			sport->ini_data = vport->ini_data;
+
+			efc_sm_transition(&sport->sm, __efc_sport_vport_init,
+					  NULL);
+		}
+	}
+
+	return rc;
+}
+
+/* Allocate a new virtual SLI port */
+int
+efc_sport_vport_new(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
+		    u32 fc_id, bool ini, bool tgt, void *tgt_data,
+		    void *ini_data, bool restore_vport)
+{
+	struct efc_sli_port *sport;
+
+	if (ini && domain->efc->enable_ini == 0) {
+		efc_log_test(domain->efc,
+			     "driver initiator functionality not enabled\n");
+		return -1;
+	}
+
+	if (tgt && domain->efc->enable_tgt == 0) {
+		efc_log_test(domain->efc,
+			     "driver target functionality not enabled\n");
+		return -1;
+	}
+
+	/*
+	 * Create a vport spec if we need to recreate
+	 * this vport after a link up event
+	 */
+	if (restore_vport) {
+		if (efc_vport_create_spec(domain->efc, wwnn, wwpn, fc_id,
+					  ini, tgt, tgt_data, ini_data)) {
+			efc_log_test(domain->efc,
+				     "failed to create vport object entry\n");
+			return -1;
+		}
+		return efc_vport_start(domain);
+	}
+
+	/* Allocate a sport */
+	sport = efc_sport_alloc(domain, wwpn, wwnn, fc_id, ini, tgt);
+
+	if (!sport)
+		return -1;
+
+	sport->is_vport = true;
+	sport->tgt_data = tgt_data;
+	sport->ini_data = ini_data;
+
+	/* Transition to vport_init */
+	efc_sm_transition(&sport->sm, __efc_sport_vport_init, NULL);
+
+	return 0;
+}
+
+/* Remove a previously-allocated virtual port */
+int
+efc_sport_vport_del(struct efc *efc, struct efc_domain *domain,
+		    u64 wwpn, uint64_t wwnn)
+{
+	struct efc_sli_port *sport;
+	int found = 0;
+	struct efc_vport_spec *vport;
+	struct efc_vport_spec *next;
+
+	/* walk the efc_vport_list and remove from there */
+	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
+		if (vport->wwpn == wwpn && vport->wwnn == wwnn) {
+			list_del(&vport->list_entry);
+			kfree(vport);
+			break;
+		}
+	}
+
+	if (!domain) {
+		/* No domain means no sport to look for */
+		return 0;
+	}
+
+	list_for_each_entry(sport, &domain->sport_list, list_entry) {
+		if (sport->wwpn == wwpn && sport->wwnn == wwnn) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		/* Shutdown this SPORT */
+		efc_sm_post_event(&sport->sm, EFC_EVT_SHUTDOWN, NULL);
+	}
+	return 0;
+}
+
+/* Force free all saved vports */
+void
+efc_vport_del_all(struct efc *efc)
+{
+	struct efc_vport_spec *vport;
+	struct efc_vport_spec *next;
+
+	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
+		list_del(&vport->list_entry);
+		kfree(vport);
+	}
+}
+
+/**
+ * Create a saved vport entry.
+ *
+ * A saved vport entry is added to the vport list,
+ * which is restored following a link up.
+ * This function is used to allow vports to be created the first time
+ * the link comes up without having to go through the ioctl() API.
+ */
+
+int8_t
+efc_vport_create_spec(struct efc *efc, uint64_t wwnn, uint64_t wwpn,
+		      u32 fc_id, bool enable_ini,
+		      bool enable_tgt, void *tgt_data, void *ini_data)
+{
+	struct efc_vport_spec *vport;
+
+	/*
+	 * walk the efc_vport_list and return failure
+	 * if a valid(vport with non zero WWPN and WWNN) vport entry
+	 * is already created
+	 */
+	list_for_each_entry(vport, &efc->vport_list, list_entry) {
+		if ((wwpn && vport->wwpn == wwpn) &&
+		    (wwnn && vport->wwnn == wwnn)) {
+			efc_log_test(efc,
+				     "Failed: VPORT %016llX %016llX already allocated\n",
+				     wwnn, wwpn);
+			return -1;
+		}
+	}
+
+	vport = kzalloc(sizeof(*vport), GFP_ATOMIC);
+	if (!vport)
+		return -1;
+
+	vport->wwnn = wwnn;
+	vport->wwpn = wwpn;
+	vport->fc_id = fc_id;
+	vport->enable_tgt = enable_tgt;
+	vport->enable_ini = enable_ini;
+	vport->tgt_data = tgt_data;
+	vport->ini_data = ini_data;
+
+	INIT_LIST_HEAD(&vport->list_entry);
+	list_add_tail(&vport->list_entry, &efc->vport_list);
+	return 0;
+}
diff --git a/drivers/scsi/elx/libefc/efc_sport.h b/drivers/scsi/elx/libefc/efc_sport.h
new file mode 100644
index 000000000000..3269e29c6f57
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sport.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/**
+ * EFC FC SLI port (SPORT) exported declarations
+ *
+ */
+
+#ifndef __EFC_SPORT_H__
+#define __EFC_SPORT_H__
+
+extern struct efc_sli_port *
+efc_sport_alloc(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
+		u32 fc_id, bool enable_ini, bool enable_tgt);
+extern void
+efc_sport_free(struct efc_sli_port *sport);
+extern void
+efc_sport_force_free(struct efc_sli_port *sport);
+extern struct efc_sli_port *
+efc_sport_find_wwn(struct efc_domain *domain, uint64_t wwnn, uint64_t wwpn);
+extern int
+efc_sport_attach(struct efc_sli_port *sport, u32 fc_id);
+
+extern void *
+__efc_sport_allocated(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg);
+extern void *
+__efc_sport_wait_shutdown(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg);
+extern void *
+__efc_sport_wait_port_free(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg);
+extern void *
+__efc_sport_vport_init(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg);
+extern void *
+__efc_sport_vport_wait_alloc(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg);
+extern void *
+__efc_sport_vport_allocated(struct efc_sm_ctx *ctx,
+			    enum efc_sm_event evt, void *arg);
+extern void *
+__efc_sport_attached(struct efc_sm_ctx *ctx,
+		     enum efc_sm_event evt, void *arg);
+
+extern int
+efc_vport_start(struct efc_domain *domain);
+
+#endif /* __EFC_SPORT_H__ */
-- 
2.13.7

