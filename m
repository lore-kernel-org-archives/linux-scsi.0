Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C186C43457
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B35B20709
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hXoyWQhN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390622AbgJLWwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390597AbgJLWwM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:12 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B09C0613D2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:12 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r10so15880151pgb.10
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=nMm+ZHMR1cinJKMec49Z5SsmxARvIJipUYe0tYYjcBQ=;
        b=hXoyWQhNAeCZrb+8SAoVhEW1XMBYvUVE8wbGFAI94/O148p189ij4L9McKY429iK/S
         9EZFC0eNi2JKOM1TSuYuvbOZqK+3CIwX159ph9aKw+n8sx2GLpbwxhEVyakYYOTAysv1
         SnxcXmi9tqU8rxayBe8q4yZQ6rUHSe4fvCfjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=nMm+ZHMR1cinJKMec49Z5SsmxARvIJipUYe0tYYjcBQ=;
        b=LrKCWKhlWuAveR6FNi9uu3GDZ2t3D7YNa63cYhzpc3Yjs7Qa2crzEMLDCi9vChHH8T
         ckWkFxCfmcJafNq2wFTm5N3LR/b2fUPwfva59ssZ3XWQUVPC3rw+783MH5yccegv/hHZ
         RaXqZ7loD7yLUpfASi/4011qgttVVUmVDFkSYWjCjOIUxULZbH4x4wzbFJ8bdKELJQn0
         icj76gvk5yhJk1hvXwSXO4hrU6CcMTNMX2OJf+SrnuMGuQ0Qc/3ARpTVsxS0tSnt4V/t
         oJX9Uyz3lttQbT+bVriqNGmwqS7PNosp9tKYX/g0XnKVBw7Hx4rvpm+QDTR+PkEH5Zld
         btqQ==
X-Gm-Message-State: AOAM533oGISBzNSc3qUIjDCPdbjdS6y5Uk4Ea9dPfL5i5vFLUKw2uXOb
        zf48Zy0lR6DkKze8KLxqC349JG9MfbTyZblNwDKJN+TcJOJGNfJA32DvXyjmFFiyExhFm00T0O7
        sRz6qi3CuXr/lCRcV1EcgeQF3pjzmaIbzyryFomMryyMai5WCohajs1PfdOE44YOUK8yt4LI8r2
        q7B1Q=
X-Google-Smtp-Source: ABdhPJy3F8G3x4Wn/UCh2Yb4Sppphfa9e4WMS3dhc/bNbpV8hrhFyN16N9mZRfu6pGXm84poK8m/0w==
X-Received: by 2002:a17:90a:2dcd:: with SMTP id q13mr21779648pjm.202.1602543131255;
        Mon, 12 Oct 2020 15:52:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:10 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 11/31] elx: libefc: SLI and FC PORT state machine interfaces
Date:   Mon, 12 Oct 2020 15:51:27 -0700
Message-Id: <20201012225147.54404-12-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001dc6cb05b1812693"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001dc6cb05b1812693
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the libefc library population.

This patch adds library interface definitions for:
- SLI and FC port (aka n_port_id) registration, allocation and
  deallocation.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Renamed efc_sport.[ch] to efc_nport.[ch]
  Kref for Nport structure.
  Get kref while lookup for nport during unsolicited frame processing.
     Release after processing the frame.
  Get Kref while Allocating nport for vport creation. Release while
     deleting the vport.
---
 drivers/scsi/elx/libefc/efc_nport.c | 825 ++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_nport.h |  50 ++
 2 files changed, 875 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_nport.c
 create mode 100644 drivers/scsi/elx/libefc/efc_nport.h

diff --git a/drivers/scsi/elx/libefc/efc_nport.c b/drivers/scsi/elx/libefc/efc_nport.c
new file mode 100644
index 000000000000..077fc6b1369f
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_nport.c
@@ -0,0 +1,825 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * NPORT
+ *
+ * Port object for physical port and NPIV ports.
+ */
+
+/*
+ * NPORT REFERENCE COUNTING
+ *
+ * A nport reference should be taken when:
+ * - an nport is allocated
+ * - a vport populates associated nport
+ * - a remote node is allocated
+ * - a unsolicited frame is processed
+ * The reference should be dropped when:
+ * - the unsolicited frame processesing is done
+ * - the remote node is removed
+ * - the vport is removed
+ * - the nport is removed
+ */
+
+#include "efc.h"
+
+int
+efc_nport_cb(void *arg, int event, void *data)
+{
+	struct efc *efc = arg;
+	struct efc_nport *nport = data;
+	enum efc_sm_event sm_event = EFC_EVT_LAST;
+	unsigned long flags = 0;
+
+	/* HW nport callback events from the user driver */
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
+	efc_log_debug(efc, "nport event: %s\n", efc_sm_event_name(sm_event));
+
+	spin_lock_irqsave(&efc->lock, flags);
+	efc_sm_post_event(&nport->sm, sm_event, NULL);
+	spin_unlock_irqrestore(&efc->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+static struct efc_nport *
+efc_nport_find_wwn(struct efc_domain *domain, uint64_t wwnn, uint64_t wwpn)
+{
+	struct efc_nport *nport = NULL;
+
+	/* Find a nport, given the WWNN and WWPN */
+	list_for_each_entry(nport, &domain->nport_list, list_entry) {
+		if (nport->wwnn == wwnn && nport->wwpn == wwpn)
+			return nport;
+	}
+	return NULL;
+}
+
+static void
+_efc_nport_free(struct kref *arg)
+{
+	struct efc_nport *nport = container_of(arg, struct efc_nport, ref);
+
+	kfree(nport);
+}
+
+struct efc_nport *
+efc_nport_alloc(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
+		u32 fc_id, bool enable_ini, bool enable_tgt)
+{
+	struct efc_nport *nport;
+
+	if (domain->efc->enable_ini)
+		enable_ini = 0;
+
+	/* Return a failure if this nport has already been allocated */
+	if (wwpn != 0) {
+		nport = efc_nport_find_wwn(domain, wwnn, wwpn);
+		if (nport) {
+			efc_log_err(domain->efc,
+				"Err: NPORT %016llX %016llX already allocated\n",
+				wwnn, wwpn);
+			return NULL;
+		}
+	}
+
+	nport = kzalloc(sizeof(*nport), GFP_ATOMIC);
+	if (!nport)
+		return nport;
+
+	/* initialize refcount */
+	kref_init(&nport->ref);
+	nport->release = _efc_nport_free;
+
+	nport->efc = domain->efc;
+	snprintf(nport->display_name, sizeof(nport->display_name), "------");
+	nport->domain = domain;
+	xa_init(&nport->lookup);
+	nport->instance_index = domain->nport_count++;
+	INIT_LIST_HEAD(&nport->node_list);
+	nport->sm.app = nport;
+	nport->enable_ini = enable_ini;
+	nport->enable_tgt = enable_tgt;
+	nport->enable_rscn = (nport->enable_ini ||
+			(nport->enable_tgt && enable_target_rscn(nport->efc)));
+
+	/* Copy service parameters from domain */
+	memcpy(nport->service_params, domain->service_params,
+		sizeof(struct fc_els_flogi));
+
+	/* Update requested fc_id */
+	nport->fc_id = fc_id;
+
+	/* Update the nport's service parameters for the new wwn's */
+	nport->wwpn = wwpn;
+	nport->wwnn = wwnn;
+	snprintf(nport->wwnn_str, sizeof(nport->wwnn_str), "%016llX",
+			(unsigned long long)wwnn);
+
+	/*
+	 * if this is the "first" nport of the domain,
+	 * then make it the "phys" nport
+	 */
+	if (list_empty(&domain->nport_list))
+		domain->nport = nport;
+
+	INIT_LIST_HEAD(&nport->list_entry);
+	list_add_tail(&nport->list_entry, &domain->nport_list);
+
+	kref_get(&domain->ref);
+
+	efc_log_debug(domain->efc, "New Nport [%s]\n", nport->display_name);
+
+	return nport;
+}
+
+void
+efc_nport_free(struct efc_nport *nport)
+{
+	struct efc_domain *domain;
+
+	if (!nport)
+		return;
+
+	domain = nport->domain;
+	efc_log_debug(domain->efc, "[%s] free nport\n", nport->display_name);
+	list_del(&nport->list_entry);
+	/*
+	 * if this is the physical nport,
+	 * then clear it out of the domain
+	 */
+	if (nport == domain->nport)
+		domain->nport = NULL;
+
+	xa_destroy(&nport->lookup);
+	xa_erase(&domain->lookup, nport->fc_id);
+
+	if (list_empty(&domain->nport_list))
+		efc_domain_post_event(domain, EFC_EVT_ALL_CHILD_NODES_FREE,
+				      NULL);
+
+	kref_put(&domain->ref, domain->release);
+	kref_put(&nport->ref, nport->release);
+
+}
+
+struct efc_nport *
+efc_nport_find(struct efc_domain *domain, u32 d_id)
+{
+	struct efc_nport *nport;
+
+	/* Find a nport object, given an FC_ID */
+	nport = xa_load(&domain->lookup, d_id);
+	if (!nport || !kref_get_unless_zero(&nport->ref))
+		return NULL;
+
+	return nport;
+}
+
+int
+efc_nport_attach(struct efc_nport *nport, u32 fc_id)
+{
+	int rc;
+	struct efc_node *node;
+	struct efc *efc = nport->efc;
+
+	/* Set our lookup */
+	rc = xa_err(xa_store(&nport->domain->lookup, fc_id, nport, GFP_ATOMIC));
+	if (rc) {
+		efc_log_err(efc, "Sport lookup store failed: %d\n", rc);
+		return rc;
+	}
+
+	/* Update our display_name */
+	efc_node_fcid_display(fc_id, nport->display_name,
+			      sizeof(nport->display_name));
+
+	list_for_each_entry(node, &nport->node_list, list_entry) {
+		efc_node_update_display_name(node);
+	}
+
+	efc_log_debug(nport->efc, "[%s] attach nport: fc_id x%06x\n",
+		      nport->display_name, fc_id);
+
+	/* Register a nport, given an FC_ID */
+	rc = efc_cmd_nport_attach(efc, nport, fc_id);
+	if (rc != EFC_HW_RTN_SUCCESS) {
+		efc_log_err(nport->efc,
+			    "efc_hw_port_attach failed: %d\n", rc);
+		return EFC_FAIL;
+	}
+	return EFC_SUCCESS;
+}
+
+static void
+efc_nport_shutdown(struct efc_nport *nport)
+{
+	struct efc *efc = nport->efc;
+	struct efc_node *node;
+	struct efc_node *node_next;
+
+	list_for_each_entry_safe(node, node_next,
+					&nport->node_list, list_entry) {
+		if (!(node->rnode.fc_id == FC_FID_FLOGI && nport->is_vport)) {
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
+			continue;
+		}
+
+		efc_log_debug(efc, "[%s] nport shutdown vport, send logo\n",
+					node->display_name);
+
+		if (!efc_send_logo(node)) {
+			/* sent LOGO, wait for response */
+			efc_node_transition(node, __efc_d_wait_logo_rsp, NULL);
+			continue;
+		}
+
+		/*
+		 * failed to send LOGO,
+		 * go ahead and cleanup node anyways
+		 */
+		node_printf(node, "Failed to send LOGO\n");
+		efc_node_post_event(node, EFC_EVT_SHUTDOWN_EXPLICIT_LOGO, NULL);
+	}
+}
+
+static void
+efc_vport_link_down(struct efc_nport *nport)
+{
+	struct efc *efc = nport->efc;
+	struct efc_vport_spec *vport;
+
+	/* Clear the nport reference in the vport specification */
+	list_for_each_entry(vport, &efc->vport_list, list_entry) {
+		if (vport->nport == nport) {
+			kref_put(&nport->ref, nport->release);
+			vport->nport = NULL;
+			break;
+		}
+	}
+}
+
+static void
+__efc_nport_common(const char *funcname, struct efc_sm_ctx *ctx,
+		   enum efc_sm_event evt, void *arg)
+{
+	struct efc_nport *nport = ctx->app;
+	struct efc_domain *domain = nport->domain;
+	struct efc *efc = nport->efc;
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+	case EFC_EVT_REENTER:
+	case EFC_EVT_EXIT:
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		break;
+	case EFC_EVT_SPORT_ATTACH_OK:
+			efc_sm_transition(ctx, __efc_nport_attached, NULL);
+		break;
+	case EFC_EVT_SHUTDOWN: {
+		int node_list_empty;
+
+		/* Flag this nport as shutting down */
+		nport->shutting_down = true;
+
+		if (nport->is_vport)
+			efc_vport_link_down(nport);
+
+		node_list_empty = list_empty(&nport->node_list);
+
+		if (node_list_empty) {
+			/* Remove the nport from the domain's lookup table */
+			xa_erase(&domain->lookup, nport->fc_id);
+			efc_sm_transition(ctx, __efc_nport_wait_port_free,
+					  NULL);
+			if (efc_cmd_nport_free(efc, nport)) {
+				efc_log_test(nport->efc,
+					     "efc_hw_port_free failed\n");
+				/* Not much we can do, free the nport anyways */
+				efc_nport_free(nport);
+			}
+		} else {
+			/* sm: node list is not empty / shutdown nodes */
+			efc_sm_transition(ctx,
+					  __efc_nport_wait_shutdown, NULL);
+			efc_nport_shutdown(nport);
+		}
+		break;
+	}
+	default:
+		efc_log_test(nport->efc, "[%s] %-20s %-20s not handled\n",
+			     nport->display_name, funcname,
+			     efc_sm_event_name(evt));
+	}
+}
+
+void
+__efc_nport_allocated(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg)
+{
+	struct efc_nport *nport = ctx->app;
+	struct efc_domain *domain = nport->domain;
+
+	nport_sm_trace(nport);
+
+	switch (evt) {
+	/* the physical nport is attached */
+	case EFC_EVT_SPORT_ATTACH_OK:
+		WARN_ON(nport != domain->nport);
+		efc_sm_transition(ctx, __efc_nport_attached, NULL);
+		break;
+
+	case EFC_EVT_SPORT_ALLOC_OK:
+		/* ignore */
+		break;
+	default:
+		__efc_nport_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_nport_vport_init(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg)
+{
+	struct efc_nport *nport = ctx->app;
+	struct efc *efc = nport->efc;
+
+	nport_sm_trace(nport);
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		__be64 be_wwpn = cpu_to_be64(nport->wwpn);
+
+		if (nport->wwpn == 0)
+			efc_log_debug(efc, "vport: letting f/w select WWN\n");
+
+		if (nport->fc_id != U32_MAX) {
+			efc_log_debug(efc, "vport: hard coding port id: %x\n",
+				      nport->fc_id);
+		}
+
+		efc_sm_transition(ctx, __efc_nport_vport_wait_alloc, NULL);
+		/* If wwpn is zero, then we'll let the f/w */
+		if (efc_cmd_nport_alloc(efc, nport, nport->domain,
+					  nport->wwpn == 0 ? NULL :
+					  (uint8_t *)&be_wwpn)) {
+			efc_log_err(efc, "Can't allocate port\n");
+			break;
+		}
+
+		break;
+	}
+	default:
+		__efc_nport_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_nport_vport_wait_alloc(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg)
+{
+	struct efc_nport *nport = ctx->app;
+	struct efc *efc = nport->efc;
+
+	nport_sm_trace(nport);
+
+	switch (evt) {
+	case EFC_EVT_SPORT_ALLOC_OK: {
+		struct fc_els_flogi *sp;
+
+		sp = (struct fc_els_flogi *)nport->service_params;
+		/*
+		 * If we let f/w assign wwn's,
+		 * then nport wwn's with those returned by hw
+		 */
+		if (nport->wwnn == 0) {
+			nport->wwnn = be64_to_cpu(nport->sli_wwnn);
+			nport->wwpn = be64_to_cpu(nport->sli_wwpn);
+			snprintf(nport->wwnn_str, sizeof(nport->wwnn_str),
+				 "%016llX", nport->wwpn);
+		}
+
+		/* Update the nport's service parameters */
+		sp->fl_wwpn = cpu_to_be64(nport->wwpn);
+		sp->fl_wwnn = cpu_to_be64(nport->wwnn);
+
+		/*
+		 * if nport->fc_id is uninitialized,
+		 * then request that the fabric node use FDISC
+		 * to find an fc_id.
+		 * Otherwise we're restoring vports, or we're in
+		 * fabric emulation mode, so attach the fc_id
+		 */
+		if (nport->fc_id == U32_MAX) {
+			struct efc_node *fabric;
+
+			fabric = efc_node_alloc(nport, FC_FID_FLOGI, false,
+						false);
+			if (!fabric) {
+				efc_log_err(efc, "efc_node_alloc() failed\n");
+				return;
+			}
+			efc_node_transition(fabric, __efc_vport_fabric_init,
+					    NULL);
+		} else {
+			snprintf(nport->wwnn_str, sizeof(nport->wwnn_str),
+				 "%016llX", nport->wwpn);
+			efc_nport_attach(nport, nport->fc_id);
+		}
+		efc_sm_transition(ctx, __efc_nport_vport_allocated, NULL);
+		break;
+	}
+	default:
+		__efc_nport_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_nport_vport_allocated(struct efc_sm_ctx *ctx,
+			    enum efc_sm_event evt, void *arg)
+{
+	struct efc_nport *nport = ctx->app;
+	struct efc *efc = nport->efc;
+
+	nport_sm_trace(nport);
+
+	/*
+	 * This state is entered after the nport is allocated;
+	 * it then waits for a fabric node
+	 * FDISC to complete, which requests a nport attach.
+	 * The nport attach complete is handled in this state.
+	 */
+	switch (evt) {
+	case EFC_EVT_SPORT_ATTACH_OK: {
+		struct efc_node *node;
+
+		/* Find our fabric node, and forward this event */
+		node = efc_node_find(nport, FC_FID_FLOGI);
+		if (!node) {
+			efc_log_test(efc, "can't find node %06x\n",
+				     FC_FID_FLOGI);
+			break;
+		}
+		/* sm: / forward nport attach to fabric node */
+		efc_node_post_event(node, evt, NULL);
+		efc_sm_transition(ctx, __efc_nport_attached, NULL);
+		break;
+	}
+	default:
+		__efc_nport_common(__func__, ctx, evt, arg);
+	}
+}
+
+static void
+efc_vport_update_spec(struct efc_nport *nport)
+{
+	struct efc *efc = nport->efc;
+	struct efc_vport_spec *vport;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->vport_lock, flags);
+	list_for_each_entry(vport, &efc->vport_list, list_entry) {
+		if (vport->nport == nport) {
+			vport->wwnn = nport->wwnn;
+			vport->wwpn = nport->wwpn;
+			vport->tgt_data = nport->tgt_data;
+			vport->ini_data = nport->ini_data;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&efc->vport_lock, flags);
+}
+
+void
+__efc_nport_attached(struct efc_sm_ctx *ctx,
+		     enum efc_sm_event evt, void *arg)
+{
+	struct efc_nport *nport = ctx->app;
+	struct efc *efc = nport->efc;
+
+	nport_sm_trace(nport);
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		struct efc_node *node;
+
+		efc_log_debug(efc,
+			      "[%s] SPORT attached WWPN %016llX WWNN %016llX\n",
+			      nport->display_name,
+			      nport->wwpn, nport->wwnn);
+
+		list_for_each_entry(node, &nport->node_list, list_entry) {
+			efc_node_update_display_name(node);
+		}
+
+		nport->tgt_id = nport->fc_id;
+
+		efc->tt.new_nport(efc, nport);
+
+		/*
+		 * Update the vport (if its not the physical nport)
+		 * parameters
+		 */
+		if (nport->is_vport)
+			efc_vport_update_spec(nport);
+		break;
+	}
+
+	case EFC_EVT_EXIT:
+		efc_log_debug(efc,
+			      "[%s] SPORT deattached WWPN %016llX WWNN %016llX\n",
+			      nport->display_name,
+			      nport->wwpn, nport->wwnn);
+
+		efc->tt.del_nport(efc, nport);
+		break;
+	default:
+		__efc_nport_common(__func__, ctx, evt, arg);
+	}
+}
+
+
+void
+__efc_nport_wait_shutdown(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg)
+{
+	struct efc_nport *nport = ctx->app;
+	struct efc_domain *domain = nport->domain;
+	struct efc *efc = nport->efc;
+
+	nport_sm_trace(nport);
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
+		 * Remove the nport from the domain's
+		 * sparse vector lookup table
+		 */
+		xa_erase(&domain->lookup, nport->fc_id);
+		efc_sm_transition(ctx, __efc_nport_wait_port_free, NULL);
+		if (efc_cmd_nport_free(efc, nport)) {
+			efc_log_err(nport->efc, "efc_hw_port_free failed\n");
+			/* Not much we can do, free the nport anyways */
+			efc_nport_free(nport);
+		}
+		break;
+	}
+	default:
+		__efc_nport_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_nport_wait_port_free(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg)
+{
+	struct efc_nport *nport = ctx->app;
+
+	nport_sm_trace(nport);
+
+	switch (evt) {
+	case EFC_EVT_SPORT_ATTACH_OK:
+		/* Ignore as we are waiting for the free CB */
+		break;
+	case EFC_EVT_SPORT_FREE_OK: {
+		/* All done, free myself */
+		efc_nport_free(nport);
+		break;
+	}
+	default:
+		__efc_nport_common(__func__, ctx, evt, arg);
+	}
+}
+
+static int
+efc_vport_nport_alloc(struct efc_domain *domain, struct efc_vport_spec *vport)
+{
+	struct efc_nport *nport;
+
+	lockdep_assert_held(&domain->efc->lock);
+
+	nport = efc_nport_alloc(domain, vport->wwpn, vport->wwnn, vport->fc_id,
+				vport->enable_ini, vport->enable_tgt);
+	vport->nport = nport;
+	if (!nport)
+		return EFC_FAIL;
+
+	kref_get(&nport->ref);
+	nport->is_vport = true;
+	nport->tgt_data = vport->tgt_data;
+	nport->ini_data = vport->ini_data;
+
+	efc_sm_transition(&nport->sm, __efc_nport_vport_init, NULL);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_vport_start(struct efc_domain *domain)
+{
+	struct efc *efc = domain->efc;
+	struct efc_vport_spec *vport;
+	struct efc_vport_spec *next;
+	int rc = EFC_SUCCESS;
+	unsigned long flags = 0;
+
+	/* Use the vport spec to find the associated vports and start them */
+	spin_lock_irqsave(&efc->vport_lock, flags);
+	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
+		if (!vport->nport) {
+			if (efc_vport_nport_alloc(domain, vport))
+				rc = EFC_FAIL;
+		}
+	}
+	spin_unlock_irqrestore(&efc->vport_lock, flags);
+
+	return rc;
+}
+
+int
+efc_nport_vport_new(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
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
+	rc = efc_vport_nport_alloc(domain, vport);
+	spin_unlock_irqrestore(&efc->lock, flags);
+
+	return rc;
+}
+
+int
+efc_nport_vport_del(struct efc *efc, struct efc_domain *domain,
+		    u64 wwpn, uint64_t wwnn)
+{
+	struct efc_nport *nport;
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
+		/* No domain means no nport to look for */
+		return EFC_SUCCESS;
+	}
+
+	spin_lock_irqsave(&efc->lock, flags);
+	list_for_each_entry(nport, &domain->nport_list, list_entry) {
+		if (nport->wwpn == wwpn && nport->wwnn == wwnn) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		kref_put(&nport->ref, nport->release);
+		/* Shutdown this SPORT */
+		efc_sm_post_event(&nport->sm, EFC_EVT_SHUTDOWN, NULL);
+	}
+	spin_unlock_irqrestore(&efc->lock, flags);
+	return EFC_SUCCESS;
+}
+
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
diff --git a/drivers/scsi/elx/libefc/efc_nport.h b/drivers/scsi/elx/libefc/efc_nport.h
new file mode 100644
index 000000000000..7201e2778855
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_nport.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/**
+ * EFC FC port (NPORT) exported declarations
+ *
+ */
+
+#ifndef __EFC_NPORT_H__
+#define __EFC_NPORT_H__
+
+struct efc_nport *
+efc_nport_find(struct efc_domain *domain, u32 d_id);
+struct efc_nport *
+efc_nport_alloc(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
+		u32 fc_id, bool enable_ini, bool enable_tgt);
+void
+efc_nport_free(struct efc_nport *nport);
+int
+efc_nport_attach(struct efc_nport *nport, u32 fc_id);
+
+void
+__efc_nport_allocated(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg);
+void
+__efc_nport_wait_shutdown(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg);
+void
+__efc_nport_wait_port_free(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg);
+void
+__efc_nport_vport_init(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg);
+void
+__efc_nport_vport_wait_alloc(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg);
+void
+__efc_nport_vport_allocated(struct efc_sm_ctx *ctx,
+			    enum efc_sm_event evt, void *arg);
+void
+__efc_nport_attached(struct efc_sm_ctx *ctx,
+		     enum efc_sm_event evt, void *arg);
+
+int
+efc_vport_start(struct efc_domain *domain);
+
+#endif /* __EFC_NPORT_H__ */
-- 
2.26.2


--0000000000001dc6cb05b1812693
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgtP0AYMLktuj0e+Ff
Gq3rjet20druHwb3hm5C1qbCZIowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjExWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAEeHCzzSJB9+ngQzhOh6V6dwQUHUt1I+vuQY
Gr4EYmhxNHvr9AHg7fviDGAjSY00TbB/aDQZM802obFW8MonedLft8OxkMvyXKyFPbR8Fu/SqrrA
NT3ELt5nisfDyYVXmY8WiSRtLak12RpvSuP9jdIvNl0hsH0ikIAwu6EpNrh1F2s/az2sNiEIvtyQ
WZ/R03pMu3F36fNGhpn1w3Xb4Y+C7LkgHsBUbnDqyTgKr3otcJWyIUetnlr7RKHLhawT/ZXrgnyC
iMSEnXmaN3QZI7zmGBhTb2wPC3h/bIW35d59kJ7OkmgxkY3h+8yW4OqUFxcV3RqOXUTe7sBgqlRL
wNQ=
--0000000000001dc6cb05b1812693--
