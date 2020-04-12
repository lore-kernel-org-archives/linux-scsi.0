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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781C0C3815B
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 492E52073E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FyrMuOJK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgDLDdb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:31 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37384 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgDLDda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id r4so2939506pgg.4
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MFbo1CSrGG0ha9qJnmXBpHjo3QCH78fEh4g6Y1stGZg=;
        b=FyrMuOJKytYIq89VgLb8c/ZNyFAsZbKq9zQnlHC1UBiKUPnWak8bGIwSbAAyjwqSsR
         IGKsopT3WVxA/ZrWoa4F/NSPFMBC1nXIVE8T1qCpM/waYxeROZyq7wsnEVBrWRuZO+HK
         KW4VTxQFFk9+EzuBxIB7CZJEOdpq0y3a/FT/hvZn9Q2zChvpd1nQeC1t1XH5NY794hvI
         rgNnZQ3P8MmvulvVIxrhkcc7z8hI790E8H6J44NQcIws0tkrxHUnwmCdhDWyzXVM+7F1
         iSTdWQ3NvHDXi6bV0yrJPOVS6ClwPs8jAFDyBZGmC9h271/nP8nEqdCTEai6XlsrA6qL
         SieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFbo1CSrGG0ha9qJnmXBpHjo3QCH78fEh4g6Y1stGZg=;
        b=Z3IUkepwYSaoxKVUQcQMeMNCgaqdT3GYEJrblkdBry+5gZRuuSJGu6LwMH/zT37fhK
         YdXELvuNVMbEZynAewaNCQ9epwDpGSCVCD2FcCZZ8L3Jc6ycHj4UetqCs4kHB+8GcLTm
         U9VtCXg0q3VeSsg4ddKvJq/8XISV3DtaHFSx6yR8M6r2oCBlqoJd9hXGFxChZf7ErCmf
         9htsjb99cD9yXxO94Hl+JrFo4mEe/nusGRIrvFO8OXrMpuQsRIoMeXKMc2ifrhG7LZrN
         1hVqH5zTzQoil0Tmmd1VBSBso66ppqVrLtAwFY15QJkoxanVwkYLMigg24qdQNqrQ2kS
         ZMFg==
X-Gm-Message-State: AGi0PuYMKzQTTiCswZcXwJ0KIpguAgor8WqSsmu8LrbTakJm7ILUB+E/
        XC5Hc25XGCsCmQARb4wdL6V22JxA
X-Google-Smtp-Source: APiQypIUChvYF8F5164kOncoAgitnEdr/LNaHr0ghXgFvMnfkiw4W8dgJ2Mijq9EvcdB8s9O3w5AFA==
X-Received: by 2002:a62:e515:: with SMTP id n21mr12094940pff.103.1586662407191;
        Sat, 11 Apr 2020 20:33:27 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 10/31] elx: libefc: FC Domain state machine interfaces
Date:   Sat, 11 Apr 2020 20:32:42 -0700
Message-Id: <20200412033303.29574-11-jsmart2021@gmail.com>
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
- FC Domain registration, allocation and deallocation sequence

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  Acquire efc->lock in efc_domain_cb to protect all the domain state
    transitions.
  Removed efc_assert and used WARN_ON.
  Note: Re: Locking:
    efc->lock is a global per port lock which is used to synchronize and
    serialize all the state machine event processing. As there is a
    single EQ all the events are serialized. This lock will protect the
    sport list, sport, node list, node, and vport list. All the libefc
    APIs called by the driver will take this lock internally.
 Note: Re: "It would even simplify the code, as several cases can be
      collapsed into one ..."
    The Hardware events cannot be collapsed as each events is different
    from State Machine events. The code present looks more readable than
    a mapping array in this case.
---
 drivers/scsi/elx/libefc/efc_domain.c | 1109 ++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_domain.h |   52 ++
 2 files changed, 1161 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.c
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.h

diff --git a/drivers/scsi/elx/libefc/efc_domain.c b/drivers/scsi/elx/libefc/efc_domain.c
new file mode 100644
index 000000000000..4d16e9742e86
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_domain.c
@@ -0,0 +1,1109 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * domain_sm Domain State Machine: States
+ */
+
+#include "efc.h"
+
+/* Accept domain callback events from the user driver */
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
+	spin_lock_irqsave(&efc->lock, flags);
+	switch (event) {
+	case EFC_HW_DOMAIN_FOUND: {
+		u64 fcf_wwn = 0;
+		struct efc_domain_record *drec = data;
+
+		/* extract the fcf_wwn */
+		fcf_wwn = be64_to_cpu(*((__be64 *)drec->wwn));
+
+		efc_log_debug(efc, "Domain allocated: wwn %016llX\n", fcf_wwn);
+		/*
+		 * lookup domain, or allocate a new one
+		 * if one doesn't exist already
+		 */
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
+
+		if (fcf_wwn != domain->fcf_wwn) {
+			efc_log_err(efc, "evt: FOUND for existing domain\n");
+			efc_log_err(efc, "wwn:%016llX domain wwn:%016llX\n",
+				    fcf_wwn, domain->fcf_wwn);
+		}
+
+		efc_domain_post_event(domain, EFC_EVT_DOMAIN_FOUND, drec);
+		break;
+	}
+
+	case EFC_HW_DOMAIN_LOST:
+		domain_trace(domain, "EFC_HW_DOMAIN_LOST:\n");
+		efc->tt.domain_hold_frames(efc, domain);
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
+		efc->tt.domain_accept_frames(efc, domain);
+	}
+
+	return rc;
+}
+
+struct efc_domain *
+efc_domain_alloc(struct efc *efc, uint64_t fcf_wwn)
+{
+	struct efc_domain *domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_ATOMIC);
+	if (domain) {
+		domain->efc = efc;
+		domain->drvsm.app = domain;
+
+		xa_init(&domain->lookup);
+
+		INIT_LIST_HEAD(&domain->sport_list);
+		domain->fcf_wwn = fcf_wwn;
+		efc_log_debug(efc, "Domain allocated: wwn %016llX\n",
+			      domain->fcf_wwn);
+		efc->domain = domain;
+	} else {
+		efc_log_err(efc, "domain allocation failed\n");
+	}
+
+	return domain;
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
+	efc->tt.domain_hold_frames(efc, domain);
+
+	efc_log_debug(efc, "Domain free: wwn %016llX\n",
+		      domain->fcf_wwn);
+
+	xa_destroy(&domain->lookup);
+	efc->domain = NULL;
+
+	if (efc->domain_free_cb)
+		(*efc->domain_free_cb)(efc, efc->domain_free_cb_arg);
+
+	kfree(domain);
+}
+
+/* Free memory resources of a domain object */
+void
+efc_domain_force_free(struct efc_domain *domain)
+{
+	struct efc_sli_port *sport;
+	struct efc_sli_port *next;
+	struct efc *efc = domain->efc;
+
+	/* Shutdown domain sm */
+	efc_sm_disable(&domain->drvsm);
+
+	list_for_each_entry_safe(sport, next, &domain->sport_list, list_entry) {
+		efc_sport_force_free(sport);
+	}
+
+	efc->tt.hw_domain_force_free(efc, domain);
+	efc_domain_free(domain);
+}
+
+/* Register a callback to be called when the domain is freed */
+void
+efc_register_domain_free_cb(struct efc *efc,
+			    void (*callback)(struct efc *efc, void *arg),
+			    void *arg)
+{
+	efc->domain_free_cb = callback;
+	efc->domain_free_cb_arg = arg;
+	if (!efc->domain && callback)
+		(*callback)(efc, arg);
+}
+
+static void *
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
+		break;
+	}
+
+	return NULL;
+}
+
+static void *
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
+		break;
+	}
+
+	return NULL;
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
+void *
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
+		struct efc_sli_port *sport;
+
+		u64	my_wwnn = efc->req_wwnn;
+		u64	my_wwpn = efc->req_wwpn;
+		__be64		be_wwpn;
+
+		if (my_wwpn == 0 || my_wwnn == 0) {
+			efc_log_debug(efc,
+				"using default hardware WWN configuration\n");
+			my_wwpn = efc->def_wwpn;
+			my_wwnn = efc->def_wwnn;
+		}
+
+		efc_log_debug(efc,
+			"Creating base sport using WWPN %016llX WWNN %016llX\n",
+			my_wwpn, my_wwnn);
+
+		/* Allocate a sport and transition to __efc_sport_allocated */
+		sport = efc_sport_alloc(domain, my_wwpn, my_wwnn, U32_MAX,
+					efc->enable_ini, efc->enable_tgt);
+
+		if (!sport) {
+			efc_log_err(efc, "efc_sport_alloc() failed\n");
+			break;
+		}
+		efc_sm_transition(&sport->sm, __efc_sport_allocated, NULL);
+
+		be_wwpn = cpu_to_be64(sport->wwpn);
+
+		/* allocate struct efc_sli_port object for local port
+		 * Note: drec->fc_id is ALPA from read_topology only if loop
+		 */
+		if (efc->tt.hw_port_alloc(efc, sport, NULL,
+					  (uint8_t *)&be_wwpn)) {
+			efc_log_err(efc, "Can't allocate port\n");
+			efc_sport_free(sport);
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
+			if (efc->tt.hw_domain_alloc(efc, domain, drec->index)) {
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
+		sport->fc_id = drec->fc_id;
+		sport->topology = EFC_SPORT_TOPOLOGY_LOOP;
+		snprintf(sport->display_name, sizeof(sport->display_name),
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
+					node = efc_node_alloc(sport,
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
+		if (efc->tt.hw_domain_alloc(efc, domain, drec->index)) {
+			efc_log_err(efc,
+				    "Failed to initiate HW domain allocation\n");
+			break;
+		}
+		efc_sm_transition(ctx, __efc_domain_wait_alloc, arg);
+		break;
+	}
+	default:
+		__efc_domain_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/* Domain state machine: Wait for the domain allocation to complete */
+void *
+__efc_domain_wait_alloc(struct efc_sm_ctx *ctx,
+			enum efc_sm_event evt, void *arg)
+{
+	struct efc_sli_port *sport;
+
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_ALLOC_OK: {
+		struct fc_els_flogi  *sp;
+
+		sport = domain->sport;
+		if (WARN_ON(!sport))
+			return NULL;
+
+		sp = (struct fc_els_flogi  *)sport->service_params;
+
+		/* Save the domain service parameters */
+		memcpy(domain->service_params + 4, domain->dma.virt,
+		       sizeof(struct fc_els_flogi) - 4);
+		memcpy(sport->service_params + 4, domain->dma.virt,
+		       sizeof(struct fc_els_flogi) - 4);
+
+		/*
+		 * Update the sport's service parameters,
+		 * user might have specified non-default names
+		 */
+		sp->fl_wwpn = cpu_to_be64(sport->wwpn);
+		sp->fl_wwnn = cpu_to_be64(sport->wwnn);
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
+			__efc_domain_attach_internal(domain, sport->fc_id);
+			break;
+		}
+		{
+			struct efc_node *node;
+
+			/* alloc fabric node, send FLOGI */
+			node = efc_node_find(sport, FC_FID_FLOGI);
+			if (node) {
+				efc_log_err(efc,
+					    "Fabric Controller node already exists\n");
+				break;
+			}
+			node = efc_node_alloc(sport, FC_FID_FLOGI,
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
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/* Domain state machine: Wait for the domain attach request */
+void *
+__efc_domain_allocated(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg)
+{
+	int rc = 0;
+
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_REQ_ATTACH: {
+		u32 fc_id;
+
+		if (WARN_ON(!arg))
+			return NULL;
+
+		fc_id = *((u32 *)arg);
+		efc_log_debug(efc, "Requesting hw domain attach fc_id x%x\n",
+			      fc_id);
+		/* Update sport lookup */
+		rc = xa_err(xa_store(&domain->lookup, fc_id, domain->sport,
+				     GFP_ATOMIC));
+		if (rc) {
+			efc_log_err(efc, "Sport lookup store failed: %d\n", rc);
+			return NULL;
+		}
+
+		/* Update display name for the sport */
+		efc_node_fcid_display(fc_id, domain->sport->display_name,
+				      sizeof(domain->sport->display_name));
+
+		/* Issue domain attach call */
+		rc = efc->tt.hw_domain_attach(efc, domain, fc_id);
+		if (rc) {
+			efc_log_err(efc, "efc_hw_domain_attach failed: %d\n",
+				    rc);
+			return NULL;
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
+		int rc;
+
+		efc_log_debug(efc,
+			      "%s received while in EFC_EVT_DOMAIN_REQ_ATTACH\n",
+			efc_sm_event_name(evt));
+		if (!list_empty(&domain->sport_list)) {
+			/*
+			 * if there are sports, transition to
+			 * wait state and send shutdown to each
+			 * sport
+			 */
+			struct efc_sli_port	*sport = NULL;
+			struct efc_sli_port	*sport_next = NULL;
+
+			efc_sm_transition(ctx, __efc_domain_wait_sports_free,
+					  NULL);
+			list_for_each_entry_safe(sport, sport_next,
+						 &domain->sport_list,
+						 list_entry) {
+				efc_sm_post_event(&sport->sm,
+						  EFC_EVT_SHUTDOWN, NULL);
+			}
+		} else {
+			/* no sports exist, free domain */
+			efc_sm_transition(ctx, __efc_domain_wait_shutdown,
+					  NULL);
+			rc = efc->tt.hw_domain_free(efc, domain);
+			if (rc) {
+				efc_log_err(efc,
+					    "hw_domain_free failed: %d\n", rc);
+			}
+		}
+
+		break;
+	}
+
+	default:
+		__efc_domain_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/* Domain state machine: Wait for the HW domain attach to complete */
+void *
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
+		struct efc_sli_port *sport;
+		struct efc_sli_port *next_sport;
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
+		/* Register with SCSI API */
+		efc->tt.new_domain(efc, domain);
+
+		/* Transition to ready */
+		/* sm: / forward event to all sports and nodes */
+		efc_sm_transition(ctx, __efc_domain_ready, NULL);
+
+		/* We have an FCFI, so we can accept frames */
+		domain->req_accept_frames = true;
+
+		/*
+		 * Notify all nodes that the domain attach request
+		 * has completed
+		 * Note: sport will have already received notification
+		 * of sport attached as a result of the HW's port attach.
+		 */
+		list_for_each_entry_safe(sport, next_sport,
+					 &domain->sport_list, list_entry) {
+			list_for_each_entry_safe(node, next_node,
+						 &sport->node_list,
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
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/* Domain state machine: Ready state */
+void *
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
+		int rc;
+
+		if (!list_empty(&domain->sport_list)) {
+			/*
+			 * if there are sports, transition to wait state
+			 * and send shutdown to each sport
+			 */
+			struct efc_sli_port	*sport = NULL;
+			struct efc_sli_port	*sport_next = NULL;
+
+			efc_sm_transition(ctx, __efc_domain_wait_sports_free,
+					  NULL);
+			list_for_each_entry_safe(sport, sport_next,
+						 &domain->sport_list,
+						 list_entry) {
+				efc_sm_post_event(&sport->sm,
+						  EFC_EVT_SHUTDOWN, NULL);
+			}
+		} else {
+			/* no sports exist, free domain */
+			efc_sm_transition(ctx, __efc_domain_wait_shutdown,
+					  NULL);
+			rc = efc->tt.hw_domain_free(efc, domain);
+			if (rc) {
+				efc_log_err(efc,
+					    "hw_domain_free failed: %d\n", rc);
+			}
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
+		WARN_ON(domain->sport->fc_id != fc_id);
+		break;
+	}
+
+	default:
+		__efc_domain_common(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/* Domain state machine: Wait for nodes to free prior to the domain shutdown */
+void *
+__efc_domain_wait_sports_free(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
+			      void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_ALL_CHILD_NODES_FREE: {
+		int rc;
+
+		/* sm: / efc_hw_domain_free */
+		efc_sm_transition(ctx, __efc_domain_wait_shutdown, NULL);
+
+		/* Request efc_hw_domain_free and wait for completion */
+		rc = efc->tt.hw_domain_free(efc, domain);
+		if (rc) {
+			efc_log_err(efc, "efc_hw_domain_free() failed: %d\n",
+				    rc);
+		}
+		break;
+	}
+	default:
+		__efc_domain_common_shutdown(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+ /* Domain state machine: Complete the domain shutdown */
+void *
+__efc_domain_wait_shutdown(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_FREE_OK: {
+		efc->tt.del_domain(efc, domain);
+
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
+				return NULL;
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
+	}
+
+	default:
+		__efc_domain_common_shutdown(__func__, ctx, evt, arg);
+		return NULL;
+	}
+
+	return NULL;
+}
+
+/*
+ * Domain state machine: Wait for the domain alloc/attach completion
+ * after receiving a domain lost.
+ */
+void *
+__efc_domain_wait_domain_lost(struct efc_sm_ctx *ctx,
+			      enum efc_sm_event evt, void *arg)
+{
+	std_domain_state_decl();
+
+	domain_sm_trace(domain);
+
+	switch (evt) {
+	case EFC_EVT_DOMAIN_ALLOC_OK:
+	case EFC_EVT_DOMAIN_ATTACH_OK: {
+		int rc;
+
+		if (!list_empty(&domain->sport_list)) {
+			/*
+			 * if there are sports, transition to
+			 * wait state and send shutdown to each sport
+			 */
+			struct efc_sli_port	*sport = NULL;
+			struct efc_sli_port	*sport_next = NULL;
+
+			efc_sm_transition(ctx, __efc_domain_wait_sports_free,
+					  NULL);
+			list_for_each_entry_safe(sport, sport_next,
+						 &domain->sport_list,
+						 list_entry) {
+				efc_sm_post_event(&sport->sm,
+						  EFC_EVT_SHUTDOWN, NULL);
+			}
+		} else {
+			/* no sports exist, free domain */
+			efc_sm_transition(ctx, __efc_domain_wait_shutdown,
+					  NULL);
+			rc = efc->tt.hw_domain_free(efc, domain);
+			if (rc) {
+				efc_log_err(efc,
+					    "efc_hw_domain_free() failed: %d\n",
+									rc);
+			}
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
+		return NULL;
+	}
+
+	return NULL;
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
+/* Dispatch unsolicited FC frame */
+int
+efc_domain_dispatch_frame(void *arg, struct efc_hw_sequence *seq)
+{
+	struct efc_domain *domain = (struct efc_domain *)arg;
+	struct efc *efc = domain->efc;
+	struct fc_frame_header *hdr;
+	u32 s_id;
+	u32 d_id;
+	struct efc_node *node = NULL;
+	struct efc_sli_port *sport = NULL;
+	unsigned long flags = 0;
+
+	if (!seq->header || !seq->header->dma.virt || !seq->payload->dma.virt) {
+		efc_log_err(efc, "Sequence header or payload is null\n");
+		return EFC_HW_SEQ_FREE;
+	}
+
+	hdr = seq->header->dma.virt;
+
+	/* extract the s_id and d_id */
+	s_id = ntoh24(hdr->fh_s_id);
+	d_id = ntoh24(hdr->fh_d_id);
+
+	spin_lock_irqsave(&efc->lock, flags);
+	sport = domain->sport;
+	if (!sport) {
+		efc_log_err(efc,
+			    "Drop frame, sport for FC ID 0x%06x is NULL", d_id);
+		spin_unlock_irqrestore(&efc->lock, flags);
+		return EFC_HW_SEQ_FREE;
+	}
+
+	if (sport->fc_id != d_id) {
+		/* Not a physical port IO lookup sport associated with the
+		 * npiv port
+		 */
+		/* Look up without lock */
+		sport = efc_sport_find(domain, d_id);
+		if (!sport) {
+			if (hdr->fh_type == FC_TYPE_FCP) {
+				/* Drop frame */
+				efc_log_warn(efc,
+					     "unsolicited FCP frame with invalid d_id x%x\n",
+					d_id);
+				spin_unlock_irqrestore(&efc->lock, flags);
+				return EFC_HW_SEQ_FREE;
+			}
+			/* p2p will use this case */
+			sport = domain->sport;
+		}
+	}
+
+	/* Lookup the node given the remote s_id */
+	node = efc_node_find(sport, s_id);
+
+	/* If not found, then create a new node */
+	if (!node) {
+		/* If this is solicited data or control based on R_CTL and
+		 * there is no node context,
+		 * then we can drop the frame
+		 */
+		if ((hdr->fh_r_ctl == FC_RCTL_DD_SOL_DATA) ||
+			(hdr->fh_r_ctl == FC_RCTL_DD_SOL_CTL)) {
+			efc_log_debug(efc,
+				      "solicited data/ctrl frame without node,drop\n");
+			spin_unlock_irqrestore(&efc->lock, flags);
+			return EFC_HW_SEQ_FREE;
+		}
+
+		node = efc_node_alloc(sport, s_id, false, false);
+		if (!node) {
+			efc_log_err(efc, "efc_node_alloc() failed\n");
+			spin_unlock_irqrestore(&efc->lock, flags);
+			return EFC_HW_SEQ_FREE;
+		}
+		/* don't send PLOGI on efc_d_init entry */
+		efc_node_init_device(node, false);
+	}
+	spin_unlock_irqrestore(&efc->lock, flags);
+
+	if (node->hold_frames || !list_empty(&node->pend_frames)) {
+
+		/* add frame to node's pending list */
+		spin_lock_irqsave(&node->pend_frames_lock, flags);
+			INIT_LIST_HEAD(&seq->list_entry);
+			list_add_tail(&seq->list_entry, &node->pend_frames);
+		spin_unlock_irqrestore(&node->pend_frames_lock, flags);
+
+		return EFC_HW_SEQ_HOLD;
+	}
+
+	/* now dispatch frame to the node frame handler */
+	efc_node_dispatch_frame(node, seq);
+	return EFC_HW_SEQ_FREE;
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
+		efc->tt.recv_abts_frame(efc, node, seq);
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
+				/* Dispatch FCP command*/
+				efc->tt.dispatch_fcp_cmd(node, seq);
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
index 000000000000..d318dda5935c
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_domain.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
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
+extern struct efc_domain *
+efc_domain_alloc(struct efc *efc, uint64_t fcf_wwn);
+extern void
+efc_domain_free(struct efc_domain *domain);
+
+extern void *
+__efc_domain_init(struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg);
+extern void *
+__efc_domain_wait_alloc(struct efc_sm_ctx *ctx,
+			enum efc_sm_event evt, void *arg);
+extern void *
+__efc_domain_allocated(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg);
+extern void *
+__efc_domain_wait_attach(struct efc_sm_ctx *ctx,
+			 enum efc_sm_event evt, void *arg);
+extern void *
+__efc_domain_ready(struct efc_sm_ctx *ctx,
+		   enum efc_sm_event evt, void *arg);
+extern void *
+__efc_domain_wait_sports_free(struct efc_sm_ctx *ctx,
+			      enum efc_sm_event evt, void *arg);
+extern void *
+__efc_domain_wait_shutdown(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg);
+extern void *
+__efc_domain_wait_domain_lost(struct efc_sm_ctx *ctx,
+			      enum efc_sm_event evt, void *arg);
+
+extern void
+efc_domain_attach(struct efc_domain *domain, u32 s_id);
+extern int
+efc_domain_post_event(struct efc_domain *domain,
+		      enum efc_sm_event event, void *arg);
+extern void
+__efc_domain_attach_internal(struct efc_domain *domain, u32 s_id);
+
+#endif /* __EFCT_DOMAIN_H__ */
-- 
2.16.4

