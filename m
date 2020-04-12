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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A59C2D0EC
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2CDB2073E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L7VavNP5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgDLDdb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45093 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgDLDda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:30 -0400
Received: by mail-pg1-f194.google.com with SMTP id w11so2919397pga.12
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VQ2Vo5Mp/7Jd1OmsBWP7c1+HYIzN9Z83sysfX/DfL4s=;
        b=L7VavNP5+JzuSdnrvO/D4CBS8ZYftH7RkLQczL7CjDCas4XI0hVTdUFwYjGBnsl+9h
         6n/4FfSzH7N2ZHb3t9lir6Uyxee1SrMbwKs6a4aB/ALiag63aPzreb+/gCBk9PnxkPPd
         wgqaaavCghWawBWgNw7aodHizz99kXcXcGGmmOL3q9VN/8F7LHgJI9PkOf6eUvq59yxz
         mRL6Ej8zMRoxF9M9f7JybjtWTZwr3RiS7ZwHf/slGuzE97X/zYJPCCozOzSK8nkO6h6J
         uzjQaASXaGlqHKSi8ZZNhAW54ioM02FxuXaitpN89hVCbFgKe7N+cQ0bRa5RFm5gIvcv
         CtGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VQ2Vo5Mp/7Jd1OmsBWP7c1+HYIzN9Z83sysfX/DfL4s=;
        b=C589CrKdPBamr/Dks9VP3x3WDnjAL+ikpP0GL6BTPGhAth5n6Z2RoXdgpmCwFEYL5P
         +qynPxvkVrQCcIoDr10ve5uIkDIUwC9ElRYM4tQT1b3eK0IXxyDhStMFzDIzzURNT0ri
         snUYj9LHmxwzzr4p14d514ojUgf8Sp2RoteFvBGBIJ9lK1Kb8K7j9PKLMDzxcmPYSJQs
         YDir4ichPahFT0T6zkJL2KVV/8Gea+Ey2MeB5uwF78lR060xGwyq0xiKfOozvEltGF4N
         /SVqggRvHrNRds8PDC5GAJ9blZ4FamizqOnBJ0Dm0jV6DnkxK9u6nfeIurFS0JKnbPPA
         kwfA==
X-Gm-Message-State: AGi0PuasVBCjVKR2HE54k+ACgtbxwVmTCa0LdXBYhtgKgSOA7rKlvu2F
        Jkj5CBCm0yg1LDJJG+e38xB5zBWR
X-Google-Smtp-Source: APiQypKvjgQJPvQFoC0wcJ646fC6QpaRXDiuxoCgIszAgBEDU1irHX0p5f3cjGtm7TowixG1XAzKJg==
X-Received: by 2002:aa7:8649:: with SMTP id a9mr12015423pfo.138.1586662408756;
        Sat, 11 Apr 2020 20:33:28 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 11/31] elx: libefc: SLI and FC PORT state machine interfaces
Date:   Sat, 11 Apr 2020 20:32:43 -0700
Message-Id: <20200412033303.29574-12-jsmart2021@gmail.com>
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
- SLI and FC port (aka n_port_id) registration, allocation and
  deallocation.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  Acquire efc->lock in efc_lport_cb to protect all the port state
    transitions.
  Add vport_lock to protect vport_list access.
  Fixed vport_sport allocation race.
  Reworked on vport code.
---
 drivers/scsi/elx/libefc/efc_sport.c | 846 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_sport.h |  52 +++
 2 files changed, 898 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_sport.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sport.h

diff --git a/drivers/scsi/elx/libefc/efc_sport.c b/drivers/scsi/elx/libefc/efc_sport.c
new file mode 100644
index 000000000000..99f5213e0902
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sport.c
@@ -0,0 +1,846 @@
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
+	enum efc_sm_event sm_event = EFC_EVT_LAST;
+	unsigned long flags = 0;
+
+	switch (event) {
+	case EFC_HW_PORT_ALLOC_OK:
+		sm_event = EFC_EVT_SPORT_ALLOC_OK;
+		break;
+	case EFC_HW_PORT_ALLOC_FAIL:
+		sm_event = EFC_EVT_SPORT_ALLOC_FAIL;
+		break;
+	case EFC_HW_PORT_ATTACH_OK:
+		sm_event = EFC_EVT_SPORT_ATTACH_OK;
+		break;
+	case EFC_HW_PORT_ATTACH_FAIL:
+		sm_event = EFC_EVT_SPORT_ATTACH_FAIL;
+		break;
+	case EFC_HW_PORT_FREE_OK:
+		sm_event = EFC_EVT_SPORT_FREE_OK;
+		break;
+	case EFC_HW_PORT_FREE_FAIL:
+		sm_event = EFC_EVT_SPORT_FREE_FAIL;
+		break;
+	default:
+		efc_log_err(efc, "unknown event %#x\n", event);
+		return EFC_FAIL;
+	}
+
+	efc_log_debug(efc, "sport event: %s\n", efc_sm_event_name(sm_event));
+
+	spin_lock_irqsave(&efc->lock, flags);
+	efc_sm_post_event(&sport->sm, sm_event, NULL);
+	spin_unlock_irqrestore(&efc->lock, flags);
+
+	return EFC_SUCCESS;
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
+	xa_init(&sport->lookup);
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
+	xa_destroy(&sport->lookup);
+	xa_erase(&domain->lookup, sport->fc_id);
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
+	return xa_load(&domain->lookup, d_id);
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
+	rc = xa_err(xa_store(&sport->domain->lookup, fc_id, sport, GFP_ATOMIC));
+	if (rc) {
+		efc_log_err(efc, "Sport lookup store failed: %d\n", rc);
+		return rc;
+	}
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
+		return EFC_FAIL;
+	}
+	return EFC_SUCCESS;
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
+					&sport->node_list, list_entry) {
+		if (!(node->rnode.fc_id == FC_FID_FLOGI && sport->is_vport)) {
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
+			/* Remove the sport from the domain's lookup table */
+			xa_erase(&domain->lookup, sport->fc_id);
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
+		WARN_ON(sport != domain->sport);
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
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->vport_lock, flags);
+	list_for_each_entry(vport, &efc->vport_list, list_entry) {
+		if (vport->sport == sport) {
+			vport->wwnn = sport->wwnn;
+			vport->wwpn = sport->wwpn;
+			vport->tgt_data = sport->tgt_data;
+			vport->ini_data = sport->ini_data;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&efc->vport_lock, flags);
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
+		xa_erase(&domain->lookup, sport->fc_id);
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
+static int
+efc_vport_sport_alloc(struct efc_domain *domain, struct efc_vport_spec *vport)
+{
+	struct efc_sli_port *sport;
+
+	sport = efc_sport_alloc(domain, vport->wwpn,
+				vport->wwnn, vport->fc_id,
+				vport->enable_ini,
+				vport->enable_tgt);
+	vport->sport = sport;
+	if (!sport)
+		return EFC_FAIL;
+
+	sport->is_vport = true;
+	sport->tgt_data = vport->tgt_data;
+	sport->ini_data = vport->ini_data;
+
+	efc_sm_transition(&sport->sm, __efc_sport_vport_init, NULL);
+
+	return EFC_SUCCESS;
+}
+
+/* Use the vport specification to find the associated vports and start them */
+int
+efc_vport_start(struct efc_domain *domain)
+{
+	struct efc *efc = domain->efc;
+	struct efc_vport_spec *vport;
+	struct efc_vport_spec *next;
+	int rc = EFC_SUCCESS;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->vport_lock, flags);
+	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
+		if (!vport->sport) {
+			if (efc_vport_sport_alloc(domain, vport))
+				rc = EFC_FAIL;
+		}
+	}
+	spin_unlock_irqrestore(&efc->vport_lock, flags);
+
+	return rc;
+}
+
+/* Allocate a new virtual SLI port */
+int
+efc_sport_vport_new(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
+		    u32 fc_id, bool ini, bool tgt, void *tgt_data,
+		    void *ini_data)
+{
+	struct efc *efc = domain->efc;
+	struct efc_vport_spec *vport;
+	int rc = EFC_SUCCESS;
+	unsigned long flags = 0;
+
+	if (ini && domain->efc->enable_ini == 0) {
+		efc_log_debug(efc,
+			     "driver initiator functionality not enabled\n");
+		return EFC_FAIL;
+	}
+
+	if (tgt && domain->efc->enable_tgt == 0) {
+		efc_log_debug(efc,
+			     "driver target functionality not enabled\n");
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Create a vport spec if we need to recreate
+	 * this vport after a link up event
+	 */
+	vport = efc_vport_create_spec(domain->efc, wwnn, wwpn, fc_id, ini, tgt,
+					tgt_data, ini_data);
+	if (!vport) {
+		efc_log_err(efc, "failed to create vport object entry\n");
+		return EFC_FAIL;
+	}
+
+	spin_lock_irqsave(&efc->lock, flags);
+	rc = efc_vport_sport_alloc(domain, vport);
+	spin_unlock_irqrestore(&efc->lock, flags);
+
+	return rc;
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
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->vport_lock, flags);
+	/* walk the efc_vport_list and remove from there */
+	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
+		if (vport->wwpn == wwpn && vport->wwnn == wwnn) {
+			list_del(&vport->list_entry);
+			kfree(vport);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&efc->vport_lock, flags);
+
+	if (!domain) {
+		/* No domain means no sport to look for */
+		return EFC_SUCCESS;
+	}
+
+	spin_lock_irqsave(&efc->lock, flags);
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
+	spin_unlock_irqrestore(&efc->lock, flags);
+	return EFC_SUCCESS;
+}
+
+/* Force free all saved vports */
+void
+efc_vport_del_all(struct efc *efc)
+{
+	struct efc_vport_spec *vport;
+	struct efc_vport_spec *next;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->vport_lock, flags);
+	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
+		list_del(&vport->list_entry);
+		kfree(vport);
+	}
+	spin_unlock_irqrestore(&efc->vport_lock, flags);
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
+struct efc_vport_spec *
+efc_vport_create_spec(struct efc *efc, uint64_t wwnn, uint64_t wwpn,
+		      u32 fc_id, bool enable_ini,
+		      bool enable_tgt, void *tgt_data, void *ini_data)
+{
+	struct efc_vport_spec *vport;
+	unsigned long flags = 0;
+
+	/*
+	 * walk the efc_vport_list and return failure
+	 * if a valid(vport with non zero WWPN and WWNN) vport entry
+	 * is already created
+	 */
+	spin_lock_irqsave(&efc->vport_lock, flags);
+	list_for_each_entry(vport, &efc->vport_list, list_entry) {
+		if ((wwpn && vport->wwpn == wwpn) &&
+		    (wwnn && vport->wwnn == wwnn)) {
+			efc_log_err(efc,
+				"Failed: VPORT %016llX %016llX already allocated\n",
+				wwnn, wwpn);
+			spin_unlock_irqrestore(&efc->vport_lock, flags);
+			return NULL;
+		}
+	}
+
+	vport = kzalloc(sizeof(*vport), GFP_ATOMIC);
+	if (!vport) {
+		spin_unlock_irqrestore(&efc->vport_lock, flags);
+		return NULL;
+	}
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
+	spin_unlock_irqrestore(&efc->vport_lock, flags);
+	return vport;
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
2.16.4

