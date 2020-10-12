Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76D9C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB0020878
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="W2F5rl81"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390620AbgJLWwP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390550AbgJLWwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:11 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF9CC0613D1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:11 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b26so15128177pff.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=1W001AZG8oYuvxKfgDMfSLX77x3VJIfABfpYHEF9vVM=;
        b=W2F5rl81X8XTLRPnjwK6cz87NyeInKqCGUj+kghQgmkVx1PjSfSYXLSyL1slO01vg5
         TPAwmqX0aXpR29+Z9BzM3cTonOqEx1urrWaFTOqrfJdQwNR1P6kCXuWabJv/7f0lrC3r
         j7Z5wIhsl0uFvM3M824Tw9dmaJ6SAKzWui7CE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=1W001AZG8oYuvxKfgDMfSLX77x3VJIfABfpYHEF9vVM=;
        b=HxqTohlJ3SPL9qkarIdG20YYOnu6PXnoEVCBa1S6nZ2dw4xcDbDObe3PMxioLdbaIE
         oZGlzE2OXRQk7K7KLh32FgQiafVQDEZ6nWBX1WIUObxsXglNomJe3OewjbGF/RahKLUB
         BTPgkv2mb/RpZgcViLVXKL30VCASaHfENXOxfkyLeBIUGhJu+dJwisFhc57//++ztCFC
         kS6FPGL3Az1C8wnd+uLiVhUCGoHArwDEwKRD2cpc+igrS0xOEXM4Q6x19Gial38YSioq
         HgNY5v8hM7FaGkjkLRs/K9c/oxt3uVwg4LuN1BI+ELGTPktUk6DJUtbRcx9hfAm/KB00
         hp2w==
X-Gm-Message-State: AOAM5307KYTH5AVGmA5CLZ9z/6EcMl2rd33XAuzW2JPU/Mq3Ty/pjSdz
        vhejG413g5T/Ekgb11Pn4um6ryRF13sCTZzNO1A8qp1sfneCWbzCNNLwv8Fn9lS3J3S7omMn9Pg
        hkV5SJeaRaqG80ygApIAoQvUxESLcy/JRrG9gONRz7ornA6aHMnqYqc5xNJKwutkMJuhXrCLBBd
        Yga+8=
X-Google-Smtp-Source: ABdhPJwtvjhLKFE0CDsRy7uk5AJ/OxjjpuOoR/2WkyJY3iADjdp8drH0/0UfMP46y0KOiG6laHbPgA==
X-Received: by 2002:a63:e041:: with SMTP id n1mr14625824pgj.443.1602543129778;
        Mon, 12 Oct 2020 15:52:09 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:09 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 10/31] elx: libefc: FC Domain state machine interfaces
Date:   Mon, 12 Oct 2020 15:51:26 -0700
Message-Id: <20201012225147.54404-11-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000009057605b1812632"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000009057605b1812632
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the libefc library population.

This patch adds library interface definitions for:
- FC Domain registration, allocation and deallocation sequence

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Changes to use new function template
  Get Domain Ref count when a new nport is added. Release domain ref when
     nport is freed.
---
 drivers/scsi/elx/libefc/efc_domain.c | 1095 ++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_domain.h |   54 ++
 2 files changed, 1149 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.c
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.h

diff --git a/drivers/scsi/elx/libefc/efc_domain.c b/drivers/scsi/elx/libefc/efc_domain.c
new file mode 100644
index 000000000000..371b9c5d3553
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_domain.c
@@ -0,0 +1,1095 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * domain_sm Domain State Machine: States
+ */
+
+#include "efc.h"
+
+int
+efc_domain_cb(void *arg, int event, void *data)
+{
+	struct efc *efc = arg;
+	struct efc_domain *domain = NULL;
+	int rc = 0;
+	unsigned long flags = 0;
+
+	if (event != EFC_HW_DOMAIN_FOUND)
+		domain = data;
+
+	/* Accept domain callback events from the user driver */
+	spin_lock_irqsave(&efc->lock, flags);
+	switch (event) {
+	case EFC_HW_DOMAIN_FOUND: {
+		u64 fcf_wwn = 0;
+		struct efc_domain_record *drec = data;
+
+		/* extract the fcf_wwn */
+		fcf_wwn = be64_to_cpu(*((__be64 *)drec->wwn));
+
+		efc_log_debug(efc, "Domain found: wwn %016llX\n", fcf_wwn);
+
+		/* lookup domain, or allocate a new one */
+		domain = efc->domain;
+		if (!domain) {
+			domain = efc_domain_alloc(efc, fcf_wwn);
+			if (!domain) {
+				efc_log_err(efc, "efc_domain_alloc() failed\n");
+				rc = -1;
+				break;
+			}
+			efc_sm_transition(&domain->drvsm, __efc_domain_init,
+					  NULL);
+		}
+		efc_domain_post_event(domain, EFC_EVT_DOMAIN_FOUND, drec);
+		break;
+	}
+
+	case EFC_HW_DOMAIN_LOST:
+		domain_trace(domain, "EFC_HW_DOMAIN_LOST:\n");
+		efc->hold_frames = true;
+		efc_domain_post_event(domain, EFC_EVT_DOMAIN_LOST, NULL);
+		break;
+
+	case EFC_HW_DOMAIN_ALLOC_OK:
+		domain_trace(domain, "EFC_HW_DOMAIN_ALLOC_OK:\n");
+		efc_domain_post_event(domain, EFC_EVT_DOMAIN_ALLOC_OK, NULL);
+		break;
+
+	case EFC_HW_DOMAIN_ALLOC_FAIL:
+		domain_trace(domain, "EFC_HW_DOMAIN_ALLOC_FAIL:\n");
+		efc_domain_post_event(domain, EFC_EVT_DOMAIN_ALLOC_FAIL,
+				      NULL);
+		break;
+
+	case EFC_HW_DOMAIN_ATTACH_OK:
+		domain_trace(domain, "EFC_HW_DOMAIN_ATTACH_OK:\n");
+		efc_domain_post_event(domain, EFC_EVT_DOMAIN_ATTACH_OK, NULL);
+		break;
+
+	case EFC_HW_DOMAIN_ATTACH_FAIL:
+		domain_trace(domain, "EFC_HW_DOMAIN_ATTACH_FAIL:\n");
+		efc_domain_post_event(domain,
+				      EFC_EVT_DOMAIN_ATTACH_FAIL, NULL);
+		break;
+
+	case EFC_HW_DOMAIN_FREE_OK:
+		domain_trace(domain, "EFC_HW_DOMAIN_FREE_OK:\n");
+		efc_domain_post_event(domain, EFC_EVT_DOMAIN_FREE_OK, NULL);
+		break;
+
+	case EFC_HW_DOMAIN_FREE_FAIL:
+		domain_trace(domain, "EFC_HW_DOMAIN_FREE_FAIL:\n");
+		efc_domain_post_event(domain, EFC_EVT_DOMAIN_FREE_FAIL, NULL);
+		break;
+
+	default:
+		efc_log_warn(efc, "unsupported event %#x\n", event);
+	}
+	spin_unlock_irqrestore(&efc->lock, flags);
+
+	if (efc->domain && domain->req_accept_frames) {
+		domain->req_accept_frames = false;
+		efc->hold_frames = false;
+	}
+
+	return rc;
+}
+
+static void
+_efc_domain_free(struct kref *arg)
+{
+	struct efc_domain *domain = container_of(arg, struct efc_domain, ref);
+	struct efc *efc = domain->efc;
+
+	if (efc->domain_free_cb)
+		(*efc->domain_free_cb)(efc, efc->domain_free_cb_arg);
+
+	kfree(domain);
+}
+
+void
+efc_domain_free(struct efc_domain *domain)
+{
+	struct efc *efc;
+
+	efc = domain->efc;
+
+	/* Hold frames to clear the domain pointer from the xport lookup */
+	efc->hold_frames = false;
+
+	efc_log_debug(efc, "Domain free: wwn %016llX\n", domain->fcf_wwn);
+
+	xa_destroy(&domain->lookup);
+	efc->domain = NULL;
+	kref_put(&domain->ref, domain->release);
+}
+
+struct efc_domain *
+efc_domain_alloc(struct efc *efc, uint64_t fcf_wwn)
+{
+	struct efc_domain *domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_ATOMIC);
+	if (!domain)
+		return NULL;
+
+	domain->efc = efc;
+	domain->drvsm.app = domain;
+
+	/* initialize refcount */
+	kref_init(&domain->ref);
+	domain->release = _efc_domain_free;
+
+	xa_init(&domain->lookup);
+
+	INIT_LIST_HEAD(&domain->nport_list);
+	efc->domain = domain;
+	domain->fcf_wwn = fcf_wwn;
+	efc_log_debug(efc, "Domain allocated: wwn %016llX\n", domain->fcf_wwn);
+
+	return domain;
+}
+
+void
+efc_register_domain_free_cb(struct efc *efc,
+			    void (*callback)(struct efc *efc, void *arg),
+			    void *arg)
+{
+	/* Register a callback to be called when the domain is freed */
+	efc->domain_free_cb = callback;
+	efc->domain_free_cb_arg = arg;
+	if (!efc->domain && callback)
+		(*callback)(efc, arg);
+}
+
+static void
+__efc_domain_common(const char *funcname, struct efc_sm_ctx *ctx,
+		    enum efc_sm_event evt, void *arg)
+{
+	struct efc_domain *domain = ctx->app;
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+	case EFC_EVT_REENTER:
+	case EFC_EVT_EXIT:
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		/*
+		 * this can arise if an FLOGI fails on the SPORT,
+		 * and the SPORT is shutdown
+		 */
+		break;
+	default:
+		efc_log_warn(domain->efc, "%-20s %-20s not handled\n",
+			     funcname, efc_sm_event_name(evt));
+	}
+}
+
+static void
+__efc_domain_common_shutdown(const char *funcname, struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg)
+{
+	struct efc_domain *domain = ctx->app;
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+	case EFC_EVT_REENTER:
+	case EFC_EVT_EXIT:
+		break;
+	case EFC_EVT_DOMAIN_FOUND:
+		/* save drec, mark domain_found_pending */
+		memcpy(&domain->pending_drec, arg,
+		       sizeof(domain->pending_drec));
+		domain->domain_found_pending = true;
+		break;
+	case EFC_EVT_DOMAIN_LOST:
+		/* unmark domain_found_pending */
+		domain->domain_found_pending = false;
+		break;
+
+	default:
+		efc_log_warn(domain->efc, "%-20s %-20s not handled\n",
+			     funcname, efc_sm_event_name(evt));
+	}
+}
+
+#define std_domain_state_decl(...)\
+	struct efc_domain *domain = NULL;\
+	struct efc *efc = NULL;\
+	\
+	WARN_ON(!ctx || !ctx->app);\
+	domain = ctx->app;\
+	WARN_ON(!domain->efc);\
+	efc = domain->efc
+
+void
+__efc_domain_init(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+		  void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		domain->attached = false;
+		break;
+
+	case EFC_EVT_DOMAIN_FOUND: {
+		u32	i;
+		struct efc_domain_record *drec = arg;
+		struct efc_nport *nport;
+
+		u64 my_wwnn = efc->req_wwnn;
+		u64 my_wwpn = efc->req_wwpn;
+		__be64 bewwpn;
+
+		if (my_wwpn == 0 || my_wwnn == 0) {
+			efc_log_debug(efc,
+				"using default hardware WWN configuration\n");
+			my_wwpn = efc->def_wwpn;
+			my_wwnn = efc->def_wwnn;
+		}
+
+		efc_log_debug(efc,
+			"Creating base nport using WWPN %016llX WWNN %016llX\n",
+			my_wwpn, my_wwnn);
+
+		/* Allocate a nport and transition to __efc_nport_allocated */
+		nport = efc_nport_alloc(domain, my_wwpn, my_wwnn, U32_MAX,
+					efc->enable_ini, efc->enable_tgt);
+
+		if (!nport) {
+			efc_log_err(efc, "efc_nport_alloc() failed\n");
+			break;
+		}
+		efc_sm_transition(&nport->sm, __efc_nport_allocated, NULL);
+
+		bewwpn = cpu_to_be64(nport->wwpn);
+
+		/* allocate struct efc_nport object for local port
+		 * Note: drec->fc_id is ALPA from read_topology only if loop
+		 */
+		if (efc_cmd_nport_alloc(efc, nport, NULL, (uint8_t *)&bewwpn)) {
+			efc_log_err(efc, "Can't allocate port\n");
+			efc_nport_free(nport);
+			break;
+		}
+
+		domain->is_loop = drec->is_loop;
+
+		/*
+		 * If the loop position map includes ALPA == 0,
+		 * then we are in a public loop (NL_PORT)
+		 * Note that the first element of the loopmap[]
+		 * contains the count of elements, and if
+		 * ALPA == 0 is present, it will occupy the first
+		 * location after the count.
+		 */
+		domain->is_nlport = drec->map.loop[1] == 0x00;
+
+		if (!domain->is_loop) {
+			/* Initiate HW domain alloc */
+			if (efc_cmd_domain_alloc(efc, domain, drec->index)) {
+				efc_log_err(efc,
+					    "Failed to initiate HW domain allocation\n");
+				break;
+			}
+			efc_sm_transition(ctx, __efc_domain_wait_alloc, arg);
+			break;
+		}
+
+		efc_log_debug(efc, "%s fc_id=%#x speed=%d\n",
+			      drec->is_loop ?
+			      (domain->is_nlport ?
+			      "public-loop" : "loop") : "other",
+			      drec->fc_id, drec->speed);
+
+		nport->fc_id = drec->fc_id;
+		nport->topology = EFC_SPORT_TOPOLOGY_LOOP;
+		snprintf(nport->display_name, sizeof(nport->display_name),
+			 "s%06x", drec->fc_id);
+
+		if (efc->enable_ini) {
+			u32 count = drec->map.loop[0];
+
+			efc_log_debug(efc, "%d position map entries\n",
+				      count);
+			for (i = 1; i <= count; i++) {
+				if (drec->map.loop[i] != drec->fc_id) {
+					struct efc_node *node;
+
+					efc_log_debug(efc, "%#x -> %#x\n",
+						      drec->fc_id,
+						      drec->map.loop[i]);
+					node = efc_node_alloc(nport,
+							      drec->map.loop[i],
+							      false, true);
+					if (!node) {
+						efc_log_err(efc,
+							    "efc_node_alloc() failed\n");
+						break;
+					}
+					efc_node_transition(node,
+							    __efc_d_wait_loop,
+							    NULL);
+				}
+			}
+		}
+
+		/* Initiate HW domain alloc */
+		if (efc_cmd_domain_alloc(efc, domain, drec->index)) {
+			efc_log_err(efc,
+				    "Failed to initiate HW domain allocation\n");
+			break;
+		}
+		efc_sm_transition(ctx, __efc_domain_wait_alloc, arg);
+		break;
+	}
+	default:
+		__efc_domain_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_domain_wait_alloc(struct efc_sm_ctx *ctx,
+			enum efc_sm_event evt, void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_ALLOC_OK: {
+		struct fc_els_flogi  *sp;
+		struct efc_nport *nport;
+
+		nport = domain->nport;
+		if (WARN_ON(!nport))
+			return;
+
+		sp = (struct fc_els_flogi  *)nport->service_params;
+
+		/* Save the domain service parameters */
+		memcpy(domain->service_params + 4, domain->dma.virt,
+		       sizeof(struct fc_els_flogi) - 4);
+		memcpy(nport->service_params + 4, domain->dma.virt,
+		       sizeof(struct fc_els_flogi) - 4);
+
+		/*
+		 * Update the nport's service parameters,
+		 * user might have specified non-default names
+		 */
+		sp->fl_wwpn = cpu_to_be64(nport->wwpn);
+		sp->fl_wwnn = cpu_to_be64(nport->wwnn);
+
+		/*
+		 * Take the loop topology path,
+		 * unless we are an NL_PORT (public loop)
+		 */
+		if (domain->is_loop && !domain->is_nlport) {
+			/*
+			 * For loop, we already have our FC ID
+			 * and don't need fabric login.
+			 * Transition to the allocated state and
+			 * post an event to attach to
+			 * the domain. Note that this breaks the
+			 * normal action/transition
+			 * pattern here to avoid a race with the
+			 * domain attach callback.
+			 */
+			/* sm: is_loop / domain_attach */
+			efc_sm_transition(ctx, __efc_domain_allocated, NULL);
+			__efc_domain_attach_internal(domain, nport->fc_id);
+			break;
+		}
+		{
+			struct efc_node *node;
+
+			/* alloc fabric node, send FLOGI */
+			node = efc_node_find(nport, FC_FID_FLOGI);
+			if (node) {
+				efc_log_err(efc,
+					    "Fabric Controller node already exists\n");
+				break;
+			}
+			node = efc_node_alloc(nport, FC_FID_FLOGI,
+					      false, false);
+			if (!node) {
+				efc_log_err(efc,
+					    "Error: efc_node_alloc() failed\n");
+			} else {
+				efc_node_transition(node,
+						    __efc_fabric_init, NULL);
+			}
+			/* Accept frames */
+			domain->req_accept_frames = true;
+		}
+		/* sm: / start fabric logins */
+		efc_sm_transition(ctx, __efc_domain_allocated, NULL);
+		break;
+	}
+
+	case EFC_EVT_DOMAIN_ALLOC_FAIL:
+		efc_log_err(efc, "%s recv'd waiting for DOMAIN_ALLOC_OK;",
+			    efc_sm_event_name(evt));
+		efc_log_err(efc, "shutting down domain\n");
+		domain->req_domain_free = true;
+		break;
+
+	case EFC_EVT_DOMAIN_FOUND:
+		/* Should not happen */
+		break;
+
+	case EFC_EVT_DOMAIN_LOST:
+		efc_log_debug(efc,
+			      "%s received while waiting for hw_domain_alloc()\n",
+			efc_sm_event_name(evt));
+		efc_sm_transition(ctx, __efc_domain_wait_domain_lost, NULL);
+		break;
+
+	default:
+		__efc_domain_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_domain_allocated(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_REQ_ATTACH: {
+		int rc = 0;
+		u32 fc_id;
+
+		if (WARN_ON(!arg))
+			return;
+
+		fc_id = *((u32 *)arg);
+		efc_log_debug(efc, "Requesting hw domain attach fc_id x%x\n",
+			      fc_id);
+		/* Update nport lookup */
+		rc = xa_err(xa_store(&domain->lookup, fc_id, domain->nport,
+				     GFP_ATOMIC));
+		if (rc) {
+			efc_log_err(efc, "Sport lookup store failed: %d\n", rc);
+			return;
+		}
+
+		/* Update display name for the nport */
+		efc_node_fcid_display(fc_id, domain->nport->display_name,
+				      sizeof(domain->nport->display_name));
+
+		/* Issue domain attach call */
+		rc = efc_cmd_domain_attach(efc, domain, fc_id);
+		if (rc) {
+			efc_log_err(efc, "efc_hw_domain_attach failed: %d\n",
+				    rc);
+			return;
+		}
+		/* sm: / domain_attach */
+		efc_sm_transition(ctx, __efc_domain_wait_attach, NULL);
+		break;
+	}
+
+	case EFC_EVT_DOMAIN_FOUND:
+		/* Should not happen */
+		efc_log_err(efc, "%s: evt: %d should not happen\n",
+			    __func__, evt);
+		break;
+
+	case EFC_EVT_DOMAIN_LOST: {
+		efc_log_debug(efc,
+			      "%s received while in EFC_EVT_DOMAIN_REQ_ATTACH\n",
+			efc_sm_event_name(evt));
+		if (!list_empty(&domain->nport_list)) {
+			/*
+			 * if there are nports, transition to
+			 * wait state and send shutdown to each
+			 * nport
+			 */
+			struct efc_nport *nport = NULL, *nport_next = NULL;
+
+			efc_sm_transition(ctx, __efc_domain_wait_nports_free,
+					  NULL);
+			list_for_each_entry_safe(nport, nport_next,
+						 &domain->nport_list,
+						 list_entry) {
+				efc_sm_post_event(&nport->sm,
+						  EFC_EVT_SHUTDOWN, NULL);
+			}
+		} else {
+			/* no nports exist, free domain */
+			efc_sm_transition(ctx, __efc_domain_wait_shutdown,
+					  NULL);
+			if (efc_cmd_domain_free(efc, domain))
+				efc_log_err(efc, "hw_domain_free failed\n");
+		}
+
+		break;
+	}
+
+	default:
+		__efc_domain_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_domain_wait_attach(struct efc_sm_ctx *ctx,
+			 enum efc_sm_event evt, void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_ATTACH_OK: {
+		struct efc_node *node = NULL;
+		struct efc_node *next_node = NULL;
+		struct efc_nport *nport, *next_nport;
+
+		/*
+		 * Set domain notify pending state to avoid
+		 * duplicate domain event post
+		 */
+		domain->domain_notify_pend = true;
+
+		/* Mark as attached */
+		domain->attached = true;
+
+		/* Transition to ready */
+		/* sm: / forward event to all nports and nodes */
+		efc_sm_transition(ctx, __efc_domain_ready, NULL);
+
+		/* We have an FCFI, so we can accept frames */
+		domain->req_accept_frames = true;
+
+		/*
+		 * Notify all nodes that the domain attach request
+		 * has completed
+		 * Note: nport will have already received notification
+		 * of nport attached as a result of the HW's port attach.
+		 */
+		list_for_each_entry_safe(nport, next_nport,
+					 &domain->nport_list, list_entry) {
+			list_for_each_entry_safe(node, next_node,
+						 &nport->node_list,
+						 list_entry) {
+				efc_node_post_event(node,
+						    EFC_EVT_DOMAIN_ATTACH_OK,
+						    NULL);
+			}
+		}
+		domain->domain_notify_pend = false;
+		break;
+	}
+
+	case EFC_EVT_DOMAIN_ATTACH_FAIL:
+		efc_log_debug(efc,
+			      "%s received while waiting for hw attach\n",
+			      efc_sm_event_name(evt));
+		break;
+
+	case EFC_EVT_DOMAIN_FOUND:
+		/* Should not happen */
+		efc_log_err(efc, "%s: evt: %d should not happen\n",
+			    __func__, evt);
+		break;
+
+	case EFC_EVT_DOMAIN_LOST:
+		/*
+		 * Domain lost while waiting for an attach to complete,
+		 * go to a state that waits for  the domain attach to
+		 * complete, then handle domain lost
+		 */
+		efc_sm_transition(ctx, __efc_domain_wait_domain_lost, NULL);
+		break;
+
+	case EFC_EVT_DOMAIN_REQ_ATTACH:
+		/*
+		 * In P2P we can get an attach request from
+		 * the other FLOGI path, so drop this one
+		 */
+		break;
+
+	default:
+		__efc_domain_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_domain_ready(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		/* start any pending vports */
+		if (efc_vport_start(domain)) {
+			efc_log_debug(domain->efc,
+				      "efc_vport_start didn't start vports\n");
+		}
+		break;
+	}
+	case EFC_EVT_DOMAIN_LOST: {
+		if (!list_empty(&domain->nport_list)) {
+			/*
+			 * if there are nports, transition to wait state
+			 * and send shutdown to each nport
+			 */
+			struct efc_nport *nport = NULL, *nport_next = NULL;
+
+			efc_sm_transition(ctx, __efc_domain_wait_nports_free,
+					  NULL);
+			list_for_each_entry_safe(nport, nport_next,
+						 &domain->nport_list,
+						 list_entry) {
+				efc_sm_post_event(&nport->sm,
+						  EFC_EVT_SHUTDOWN, NULL);
+			}
+		} else {
+			/* no nports exist, free domain */
+			efc_sm_transition(ctx, __efc_domain_wait_shutdown,
+					  NULL);
+			if (efc_cmd_domain_free(efc, domain))
+				efc_log_err(efc, "hw_domain_free failed\n");
+		}
+		break;
+	}
+
+	case EFC_EVT_DOMAIN_FOUND:
+		/* Should not happen */
+		efc_log_err(efc, "%s: evt: %d should not happen\n",
+			    __func__, evt);
+		break;
+
+	case EFC_EVT_DOMAIN_REQ_ATTACH: {
+		/* can happen during p2p */
+		u32 fc_id;
+
+		fc_id = *((u32 *)arg);
+
+		/* Assume that the domain is attached */
+		WARN_ON(!domain->attached);
+
+		/*
+		 * Verify that the requested FC_ID
+		 * is the same as the one we're working with
+		 */
+		WARN_ON(domain->nport->fc_id != fc_id);
+		break;
+	}
+
+	default:
+		__efc_domain_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_domain_wait_nports_free(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+			      void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	/* Wait for nodes to free prior to the domain shutdown */
+	switch (evt) {
+	case EFC_EVT_ALL_CHILD_NODES_FREE: {
+		int rc;
+
+		/* sm: / efc_hw_domain_free */
+		efc_sm_transition(ctx, __efc_domain_wait_shutdown, NULL);
+
+		/* Request efc_hw_domain_free and wait for completion */
+		rc = efc_cmd_domain_free(efc, domain);
+		if (rc) {
+			efc_log_err(efc, "efc_hw_domain_free() failed: %d\n",
+				    rc);
+		}
+		break;
+	}
+	default:
+		__efc_domain_common_shutdown(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_domain_wait_shutdown(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_FREE_OK:
+		/* sm: / domain_free */
+		if (domain->domain_found_pending) {
+			/*
+			 * save fcf_wwn and drec from this domain,
+			 * free current domain and allocate
+			 * a new one with the same fcf_wwn
+			 * could use a SLI-4 "re-register VPI"
+			 * operation here?
+			 */
+			u64 fcf_wwn = domain->fcf_wwn;
+			struct efc_domain_record drec = domain->pending_drec;
+
+			efc_log_debug(efc, "Reallocating domain\n");
+			domain->req_domain_free = true;
+			domain = efc_domain_alloc(efc, fcf_wwn);
+
+			if (!domain) {
+				efc_log_err(efc,
+					    "efc_domain_alloc() failed\n");
+				return;
+			}
+			/*
+			 * got a new domain; at this point,
+			 * there are at least two domains
+			 * once the req_domain_free flag is processed,
+			 * the associated domain will be removed.
+			 */
+			efc_sm_transition(&domain->drvsm, __efc_domain_init,
+					  NULL);
+			efc_sm_post_event(&domain->drvsm,
+					  EFC_EVT_DOMAIN_FOUND, &drec);
+		} else {
+			domain->req_domain_free = true;
+		}
+		break;
+	default:
+		__efc_domain_common_shutdown(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_domain_wait_domain_lost(struct efc_sm_ctx *ctx,
+			      enum efc_sm_event evt, void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	/*
+	 * Wait for the domain alloc/attach completion
+	 * after receiving a domain lost.
+	 */
+	switch (evt) {
+	case EFC_EVT_DOMAIN_ALLOC_OK:
+	case EFC_EVT_DOMAIN_ATTACH_OK: {
+		if (!list_empty(&domain->nport_list)) {
+			/*
+			 * if there are nports, transition to
+			 * wait state and send shutdown to each nport
+			 */
+			struct efc_nport *nport = NULL, *nport_next = NULL;
+
+			efc_sm_transition(ctx, __efc_domain_wait_nports_free,
+					  NULL);
+			list_for_each_entry_safe(nport, nport_next,
+						 &domain->nport_list,
+						 list_entry) {
+				efc_sm_post_event(&nport->sm,
+						  EFC_EVT_SHUTDOWN, NULL);
+			}
+		} else {
+			/* no nports exist, free domain */
+			efc_sm_transition(ctx, __efc_domain_wait_shutdown,
+					  NULL);
+			if (efc_cmd_domain_free(efc, domain))
+				efc_log_err(efc, "hw_domain_free() failed\n");
+		}
+		break;
+	}
+	case EFC_EVT_DOMAIN_ALLOC_FAIL:
+	case EFC_EVT_DOMAIN_ATTACH_FAIL:
+		efc_log_err(efc, "[domain] %-20s: failed\n",
+			    efc_sm_event_name(evt));
+		break;
+
+	default:
+		__efc_domain_common_shutdown(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_domain_attach_internal(struct efc_domain *domain, u32 s_id)
+{
+	memcpy(domain->dma.virt,
+	       ((uint8_t *)domain->flogi_service_params) + 4,
+		   sizeof(struct fc_els_flogi) - 4);
+	(void)efc_sm_post_event(&domain->drvsm, EFC_EVT_DOMAIN_REQ_ATTACH,
+				 &s_id);
+}
+
+void
+efc_domain_attach(struct efc_domain *domain, u32 s_id)
+{
+	__efc_domain_attach_internal(domain, s_id);
+}
+
+int
+efc_domain_post_event(struct efc_domain *domain,
+		      enum efc_sm_event event, void *arg)
+{
+	int rc;
+	bool req_domain_free;
+
+	rc = efc_sm_post_event(&domain->drvsm, event, arg);
+
+	req_domain_free = domain->req_domain_free;
+	domain->req_domain_free = false;
+
+	if (req_domain_free)
+		efc_domain_free(domain);
+
+	return rc;
+}
+
+static void
+efct_domain_process_pending(struct efc_domain *domain)
+{
+	struct efc *efc = domain->efc;
+	struct efc_hw_sequence *seq = NULL;
+	u32 processed = 0;
+	unsigned long flags = 0;
+
+	for (;;) {
+		/* need to check for hold frames condition after each frame
+		 * processed because any given frame could cause a transition
+		 * to a state that holds frames
+		 */
+		if (efc->hold_frames)
+			break;
+
+		/* Get next frame/sequence */
+		spin_lock_irqsave(&efc->pend_frames_lock, flags);
+
+		if (!list_empty(&efc->pend_frames)) {
+			seq = list_first_entry(&efc->pend_frames,
+					struct efc_hw_sequence, list_entry);
+			list_del(&seq->list_entry);
+		}
+
+		if (!seq) {
+			processed = efc->pend_frames_processed;
+			efc->pend_frames_processed = 0;
+			spin_unlock_irqrestore(&efc->pend_frames_lock, flags);
+			break;
+		}
+		efc->pend_frames_processed++;
+
+		spin_unlock_irqrestore(&efc->pend_frames_lock, flags);
+
+		/* now dispatch frame(s) to dispatch function */
+		if (efc_domain_dispatch_frame(domain, seq))
+			efc->tt.hw_seq_free(efc, seq);
+
+		seq = NULL;
+	}
+
+	if (processed != 0)
+		efc_log_debug(efc, "%u domain frames held and processed\n",
+					processed);
+}
+
+void
+efc_dispatch_frame(struct efc *efc, struct efc_hw_sequence *seq)
+{
+	struct efc_domain *domain = efc->domain;
+
+	/*
+	 * If we are holding frames or the domain is not yet registered or
+	 * there's already frames on the pending list,
+	 * then add the new frame to pending list
+	 */
+	if (!domain || efc->hold_frames || !list_empty(&efc->pend_frames)) {
+		unsigned long flags = 0;
+
+		spin_lock_irqsave(&efc->pend_frames_lock, flags);
+		INIT_LIST_HEAD(&seq->list_entry);
+		list_add_tail(&seq->list_entry, &efc->pend_frames);
+		spin_unlock_irqrestore(&efc->pend_frames_lock, flags);
+
+		if (domain) {
+			/* immediately process pending frames */
+			efct_domain_process_pending(domain);
+		}
+	} else {
+		/*
+		 * We are not holding frames and pending list is empty,
+		 * just process frame. A non-zero return means the frame
+		 * was not handled - so cleanup
+		 */
+		if (efc_domain_dispatch_frame(domain, seq))
+			efc->tt.hw_seq_free(efc, seq);
+	}
+}
+
+int
+efc_domain_dispatch_frame(void *arg, struct efc_hw_sequence *seq)
+{
+	struct efc_domain *domain = (struct efc_domain *)arg;
+	struct efc *efc = domain->efc;
+	struct fc_frame_header *hdr;
+	struct efc_node *node = NULL;
+	struct efc_nport *nport = NULL;
+	unsigned long flags = 0;
+	u32 s_id, d_id, rc = EFC_HW_SEQ_FREE;
+
+	if (!seq->header || !seq->header->dma.virt || !seq->payload->dma.virt) {
+		efc_log_err(efc, "Sequence header or payload is null\n");
+		return rc;
+	}
+
+	hdr = seq->header->dma.virt;
+
+	/* extract the s_id and d_id */
+	s_id = ntoh24(hdr->fh_s_id);
+	d_id = ntoh24(hdr->fh_d_id);
+
+	spin_lock_irqsave(&efc->lock, flags);
+
+	nport = efc_nport_find(domain, d_id);
+	if (!nport) {
+		if (hdr->fh_type == FC_TYPE_FCP) {
+			/* Drop frame */
+			efc_log_warn(efc, "FCP frame with invalid d_id x%x\n",
+				     d_id);
+			goto out;
+		}
+
+		/* p2p will use this case */
+		nport = domain->nport;
+		if (!nport || !kref_get_unless_zero(&nport->ref)) {
+			efc_log_err(efc, "Physical nport is NULL\n");
+			goto out;
+		}
+	}
+
+	/* Lookup the node given the remote s_id */
+	node = efc_node_find(nport, s_id);
+
+	/* If not found, then create a new node */
+	if (!node) {
+		/*
+		 * If this is solicited data or control based on R_CTL and
+		 * there is no node context, then we can drop the frame
+		 */
+		if ((hdr->fh_r_ctl == FC_RCTL_DD_SOL_DATA) ||
+			(hdr->fh_r_ctl == FC_RCTL_DD_SOL_CTL)) {
+			efc_log_debug(efc,
+				"solicited data/ctrl frame without node,drop\n");
+			goto out_release;
+		}
+
+		node = efc_node_alloc(nport, s_id, false, false);
+		if (!node) {
+			efc_log_err(efc, "efc_node_alloc() failed\n");
+			goto out_release;
+		}
+		/* don't send PLOGI on efc_d_init entry */
+		efc_node_init_device(node, false);
+	}
+
+	if (node->hold_frames || !list_empty(&node->pend_frames)) {
+
+		/* add frame to node's pending list */
+		spin_lock_irqsave(&node->pend_frames_lock, flags);
+		INIT_LIST_HEAD(&seq->list_entry);
+		list_add_tail(&seq->list_entry, &node->pend_frames);
+		spin_unlock_irqrestore(&node->pend_frames_lock, flags);
+		rc = EFC_HW_SEQ_HOLD;
+		goto out_release;
+	}
+
+	/* now dispatch frame to the node frame handler */
+	efc_node_dispatch_frame(node, seq);
+
+out_release:
+	kref_put(&nport->ref, nport->release);
+out:
+	spin_unlock_irqrestore(&efc->lock, flags);
+	return rc;
+}
+
+void
+efc_node_dispatch_frame(void *arg, struct efc_hw_sequence *seq)
+{
+	struct fc_frame_header *hdr = seq->header->dma.virt;
+	u32 port_id;
+	struct efc_node *node = (struct efc_node *)arg;
+	struct efc *efc = node->efc;
+
+	port_id = ntoh24(hdr->fh_s_id);
+
+	if (WARN_ON(port_id != node->rnode.fc_id))
+		return;
+
+	if ((!(ntoh24(hdr->fh_f_ctl) & FC_FC_END_SEQ)) ||
+	    !(ntoh24(hdr->fh_f_ctl) & FC_FC_SEQ_INIT)) {
+		node_printf(node,
+		    "Dropping frame hdr = %08x %08x %08x %08x %08x %08x\n",
+		    cpu_to_be32(((u32 *)hdr)[0]),
+		    cpu_to_be32(((u32 *)hdr)[1]),
+		    cpu_to_be32(((u32 *)hdr)[2]),
+		    cpu_to_be32(((u32 *)hdr)[3]),
+		    cpu_to_be32(((u32 *)hdr)[4]),
+		    cpu_to_be32(((u32 *)hdr)[5]));
+		return;
+	}
+
+	switch (hdr->fh_r_ctl) {
+	case FC_RCTL_ELS_REQ:
+	case FC_RCTL_ELS_REP:
+		efc_node_recv_els_frame(node, seq);
+		break;
+
+	case FC_RCTL_BA_ABTS:
+	case FC_RCTL_BA_ACC:
+	case FC_RCTL_BA_RJT:
+	case FC_RCTL_BA_NOP:
+		efc_log_err(efc, "Received ABTS:\n");
+		break;
+
+	case FC_RCTL_DD_UNSOL_CMD:
+	case FC_RCTL_DD_UNSOL_CTL:
+		switch (hdr->fh_type) {
+		case FC_TYPE_FCP:
+			if ((hdr->fh_r_ctl & 0xf) == FC_RCTL_DD_UNSOL_CMD) {
+				if (!node->fcp_enabled) {
+					efc_node_recv_fcp_cmd(node, seq);
+					break;
+				}
+				efc_log_err(efc,
+					"Received FCP CMD. Dropping IO\n");
+			} else if ((hdr->fh_r_ctl & 0xf) ==
+							FC_RCTL_DD_SOL_DATA) {
+				node_printf(node,
+				    "solicited data received.Dropping IO\n");
+			}
+			break;
+
+		case FC_TYPE_CT:
+			efc_node_recv_ct_frame(node, seq);
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		efc_log_err(efc, "Unhandled frame rctl: %02x\n", hdr->fh_r_ctl);
+	}
+}
diff --git a/drivers/scsi/elx/libefc/efc_domain.h b/drivers/scsi/elx/libefc/efc_domain.h
new file mode 100644
index 000000000000..b5bcf1de4fc0
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_domain.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * Declare driver's domain handler exported interface
+ */
+
+#ifndef __EFCT_DOMAIN_H__
+#define __EFCT_DOMAIN_H__
+
+struct efc_domain *
+efc_domain_alloc(struct efc *efc, uint64_t fcf_wwn);
+void
+efc_domain_free(struct efc_domain *domain);
+
+void
+__efc_domain_init(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg);
+void
+__efc_domain_wait_alloc(struct efc_sm_ctx *ctx,	enum efc_sm_event evt,
+			void *arg);
+void
+__efc_domain_allocated(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+		       void *arg);
+void
+__efc_domain_wait_attach(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+			 void *arg);
+void
+__efc_domain_ready(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg);
+void
+__efc_domain_wait_nports_free(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+			      void *arg);
+void
+__efc_domain_wait_shutdown(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+			   void *arg);
+void
+__efc_domain_wait_domain_lost(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+			      void *arg);
+void
+efc_domain_attach(struct efc_domain *domain, u32 s_id);
+int
+efc_domain_post_event(struct efc_domain *domain, enum efc_sm_event event,
+		      void *arg);
+void
+__efc_domain_attach_internal(struct efc_domain *domain, u32 s_id);
+
+int
+efc_domain_dispatch_frame(void *arg, struct efc_hw_sequence *seq);
+void
+efc_node_dispatch_frame(void *arg, struct efc_hw_sequence *seq);
+
+#endif /* __EFCT_DOMAIN_H__ */
-- 
2.26.2


--00000000000009057605b1812632
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg29wLlcY1NsXpDHjI
6kH0/kn9/w6ZyaKVJcvis7ffh3kwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjEwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHmplxoyLWmi1Wz+lB0wzjCLR09OOWDeTm2s
UPCm9nvr/grp8YLzmgTH2vYO9iNxek/r3/nx2fpmhdrRSa1s838D3ws32mh3g3YjAvcbk70C2MW2
3hFim5TiB03/G5QcwC6QEk/zgvoLFzE9aJHNS5KvClLy2lZFEWYEUM54CADVZGu/JhMTqz0cFhQb
a0+3MnA54zrjfFV0VYttNMApBQ2+j7KSv4eu7ko0oknhcNZzKqajZaoUN1HfThjOCawKoAStl0aj
LYof4ha5/RDmZ9AqCWdF+9Pk6Dft3kREn0o6m8h3t/V0wEA920n3ILhfAkdJs1FrJ5eWZGNj3ys1
faw=
--00000000000009057605b1812632--
