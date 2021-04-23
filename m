Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4265FC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2C761476
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbhDWXgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbhDWXfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 19:35:47 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF1FC06138F
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:08 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id p2so20755110pgh.4
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uLh6lGfwomaLtfpTnB278h4bMEiskU994m6TMrqratU=;
        b=gudGahVBPaMoK0dWD4+m9QjONS4N0pODaJMUaTYnHyMvR0oOO4SB7EVFzIa+3bVHcA
         3I0QeyMYBgBxFGrRZ1jSLOi0SvXyAffG4tWBkvLxRpzBJLy7rbJgAw7GV2o7LAhW9nOP
         i+mMs7f6rlM0jcXKyhz0M494mHxql0nYYFoa4BRInwViAydU7R2NDjHcaUbWvRNw3C8B
         +DcqsLD5GLpqty/1tvL4Up5Tk3S/WLB09/BaUUwncznIWyyIX9E2hVgevbjZs31L5hHp
         +TdwVBiLVtl3Nt5VxLOZ31bcl/G3/IqHp9Pnn+8ZnO9n03hn6vynXZlo3621u6ljyJph
         jodw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uLh6lGfwomaLtfpTnB278h4bMEiskU994m6TMrqratU=;
        b=aXutxsepyMIjRmehLlEqIjUxF6CmCYOEjPY855aSQIa1Nv/pgYl5DRJcij39n8YRnR
         BEAirsGhoX9CdxxTIJJ8ecI5ybljQiobKW2gcgQQh3Nr0XMhPTpBg6YfpoLztctYMzmQ
         VjX656uad5/3ffihm0YSePn5nV/7OvyfO+tiN1hgrUHwIKqWfuIBqdoiNtQ0hRj8nU0a
         H0xDBYL30HnJgAnteZAyr+yoGU1cc+ftcV58Bt5tNE7wfvpiVnx90KBAZBnii3O141t+
         LyqbCga4UiMd7l/qpI27Y7fanUv3bAbneCC8WEpMiWDX6K0blxN8MRhww0G3aVS7eBMT
         sjIg==
X-Gm-Message-State: AOAM532E037JLXUmrK1fKDYFZywOUDEDHp98WGQ6nM+PLiZHqlBTjerb
        26yXGInBplaUbyCUw4pXVTtECOh7Pcc=
X-Google-Smtp-Source: ABdhPJziZCwf8zpLEEKCet8JHdmaO/XD+mZdOg1zWYMJp/7H3GuPm4XhmOwqSfX2p7Adw2o9FY4grA==
X-Received: by 2002:a05:6a00:1a4a:b029:261:d9ed:fd80 with SMTP id h10-20020a056a001a4ab0290261d9edfd80mr6089113pfv.20.1619220907230;
        Fri, 23 Apr 2021 16:35:07 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v123sm5346892pfb.80.2021.04.23.16.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 16:35:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v8 09/31] elx: libefc: Emulex FC discovery library APIs and definitions
Date:   Fri, 23 Apr 2021 16:34:33 -0700
Message-Id: <20210423233455.27243-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423233455.27243-1-jsmart2021@gmail.com>
References: <20210423233455.27243-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc library population.

This patch adds library interface definitions for:
- SLI/Local FC port objects
- efc_domain_s: FC domain (aka fabric) objects
- efc_node_s: FC node (aka remote ports) objects

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>

---
v8:
Rename struct efc_vport_spec to efc_vport.
---
 drivers/scsi/elx/libefc/efc.h    |  69 ++++
 drivers/scsi/elx/libefc/efclib.c |  81 +++++
 drivers/scsi/elx/libefc/efclib.h | 601 +++++++++++++++++++++++++++++++
 3 files changed, 751 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc.h
 create mode 100644 drivers/scsi/elx/libefc/efclib.c
 create mode 100644 drivers/scsi/elx/libefc/efclib.h

diff --git a/drivers/scsi/elx/libefc/efc.h b/drivers/scsi/elx/libefc/efc.h
new file mode 100644
index 000000000000..19b98c2153f6
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFC_H__
+#define __EFC_H__
+
+#include "../include/efc_common.h"
+#include "efclib.h"
+#include "efc_sm.h"
+#include "efc_cmds.h"
+#include "efc_domain.h"
+#include "efc_nport.h"
+#include "efc_node.h"
+#include "efc_fabric.h"
+#include "efc_device.h"
+#include "efc_els.h"
+
+#define EFC_MAX_REMOTE_NODES			2048
+#define NODE_SPARAMS_SIZE			256
+
+enum efc_hw_rtn {
+	EFC_HW_RTN_SUCCESS = 0,
+	EFC_HW_RTN_SUCCESS_SYNC = 1,
+	EFC_HW_RTN_ERROR = -1,
+	EFC_HW_RTN_NO_RESOURCES = -2,
+	EFC_HW_RTN_NO_MEMORY = -3,
+	EFC_HW_RTN_IO_NOT_ACTIVE = -4,
+	EFC_HW_RTN_IO_ABORT_IN_PROGRESS = -5,
+	EFC_HW_RTN_IO_PORT_OWNED_ALREADY_ABORTED = -6,
+	EFC_HW_RTN_INVALID_ARG = -7,
+};
+
+#define EFC_HW_RTN_IS_ERROR(e) ((e) < 0)
+
+enum efc_scsi_del_initiator_reason {
+	EFC_SCSI_INITIATOR_DELETED,
+	EFC_SCSI_INITIATOR_MISSING,
+};
+
+enum efc_scsi_del_target_reason {
+	EFC_SCSI_TARGET_DELETED,
+	EFC_SCSI_TARGET_MISSING,
+};
+
+#define EFC_SCSI_CALL_COMPLETE			0
+#define EFC_SCSI_CALL_ASYNC			1
+
+#define EFC_FC_ELS_DEFAULT_RETRIES		3
+
+#define domain_sm_trace(domain) \
+	efc_log_debug(domain->efc, "[domain:%s] %-20s %-20s\n", \
+		      domain->display_name, __func__, efc_sm_event_name(evt)) \
+
+#define domain_trace(domain, fmt, ...) \
+	efc_log_debug(domain->efc, \
+		      "[%s]" fmt, domain->display_name, ##__VA_ARGS__) \
+
+#define node_sm_trace() \
+	efc_log_debug(node->efc, "[%s] %-20s %-20s\n", \
+		      node->display_name, __func__, efc_sm_event_name(evt)) \
+
+#define nport_sm_trace(nport) \
+	efc_log_debug(nport->efc, \
+		"[%s] %-20s\n", nport->display_name, efc_sm_event_name(evt)) \
+
+#endif /* __EFC_H__ */
diff --git a/drivers/scsi/elx/libefc/efclib.c b/drivers/scsi/elx/libefc/efclib.c
new file mode 100644
index 000000000000..786266a5aeaf
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efclib.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * LIBEFC LOCKING
+ *
+ * The critical sections protected by the efc's spinlock are quite broad and
+ * may be improved upon in the future. The libefc code and its locking doesn't
+ * influence the I/O path, so excessive locking doesn't impact I/O performance.
+ *
+ * The strategy is to lock whenever processing a request from user driver. This
+ * means that the entry points into the libefc library are protected by efc
+ * lock. So all the state machine transitions are protected.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "efc.h"
+
+int efcport_init(struct efc *efc)
+{
+	u32 rc = EFC_SUCCESS;
+
+	spin_lock_init(&efc->lock);
+	INIT_LIST_HEAD(&efc->vport_list);
+	efc->hold_frames = false;
+	spin_lock_init(&efc->pend_frames_lock);
+	INIT_LIST_HEAD(&efc->pend_frames);
+
+	/* Create Node pool */
+	efc->node_pool = mempool_create_kmalloc_pool(EFC_MAX_REMOTE_NODES,
+						sizeof(struct efc_node));
+	if (!efc->node_pool) {
+		efc_log_err(efc, "Can't allocate node pool\n");
+		return EFC_FAIL;
+	}
+
+	efc->node_dma_pool = dma_pool_create("node_dma_pool", &efc->pci->dev,
+						NODE_SPARAMS_SIZE, 0, 0);
+	if (!efc->node_dma_pool) {
+		efc_log_err(efc, "Can't allocate node dma pool\n");
+		mempool_destroy(efc->node_pool);
+		return EFC_FAIL;
+	}
+
+	efc->els_io_pool = mempool_create_kmalloc_pool(EFC_ELS_IO_POOL_SZ,
+						sizeof(struct efc_els_io_req));
+	if (!efc->els_io_pool) {
+		efc_log_err(efc, "Can't allocate els io pool\n");
+		return EFC_FAIL;
+	}
+
+	return rc;
+}
+
+static void
+efc_purge_pending(struct efc *efc)
+{
+	struct efc_hw_sequence *frame, *next;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efc->pend_frames_lock, flags);
+
+	list_for_each_entry_safe(frame, next, &efc->pend_frames, list_entry) {
+		list_del(&frame->list_entry);
+		efc->tt.hw_seq_free(efc, frame);
+	}
+
+	spin_unlock_irqrestore(&efc->pend_frames_lock, flags);
+}
+
+void efcport_destroy(struct efc *efc)
+{
+	efc_purge_pending(efc);
+	mempool_destroy(efc->els_io_pool);
+	mempool_destroy(efc->node_pool);
+	dma_pool_destroy(efc->node_dma_pool);
+}
diff --git a/drivers/scsi/elx/libefc/efclib.h b/drivers/scsi/elx/libefc/efclib.h
new file mode 100644
index 000000000000..d4d0037cc7ae
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efclib.h
@@ -0,0 +1,601 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFCLIB_H__
+#define __EFCLIB_H__
+
+#include "scsi/fc/fc_els.h"
+#include "scsi/fc/fc_fs.h"
+#include "scsi/fc/fc_ns.h"
+#include "scsi/fc/fc_gs.h"
+#include "scsi/fc_frame.h"
+#include "../include/efc_common.h"
+#include "../libefc_sli/sli4.h"
+
+#define EFC_SERVICE_PARMS_LENGTH	120
+#define EFC_NAME_LENGTH			32
+#define EFC_SM_NAME_LENGTH		64
+#define EFC_DISPLAY_BUS_INFO_LENGTH	16
+
+#define EFC_WWN_LENGTH			32
+
+#define EFC_FC_ELS_DEFAULT_RETRIES	3
+
+/* Timeouts */
+#define EFC_FC_ELS_SEND_DEFAULT_TIMEOUT	0
+#define EFC_FC_FLOGI_TIMEOUT_SEC	5
+#define EFC_SHUTDOWN_TIMEOUT_USEC	30000000
+
+/* Local port topology */
+enum efc_nport_topology {
+	EFC_NPORT_TOPO_UNKNOWN = 0,
+	EFC_NPORT_TOPO_FABRIC,
+	EFC_NPORT_TOPO_P2P,
+	EFC_NPORT_TOPO_FC_AL,
+};
+
+#define enable_target_rscn(efc)		1
+
+enum efc_node_shutd_rsn {
+	EFC_NODE_SHUTDOWN_DEFAULT = 0,
+	EFC_NODE_SHUTDOWN_EXPLICIT_LOGO,
+	EFC_NODE_SHUTDOWN_IMPLICIT_LOGO,
+};
+
+enum efc_node_send_ls_acc {
+	EFC_NODE_SEND_LS_ACC_NONE = 0,
+	EFC_NODE_SEND_LS_ACC_PLOGI,
+	EFC_NODE_SEND_LS_ACC_PRLI,
+};
+
+#define EFC_LINK_STATUS_UP		0
+#define EFC_LINK_STATUS_DOWN		1
+
+/* State machine context header  */
+struct efc_sm_ctx {
+	void (*current_state)(struct efc_sm_ctx *ctx,
+			       u32 evt, void *arg);
+
+	const char	*description;
+	void		*app;
+};
+
+/* Description of discovered Fabric Domain */
+struct efc_domain_record {
+	u32		index;
+	u32		priority;
+	u8		address[6];
+	u8		wwn[8];
+	union {
+		u8	vlan[512];
+		u8	loop[128];
+	} map;
+	u32		speed;
+	u32		fc_id;
+	bool		is_loop;
+	bool		is_nport;
+};
+
+/* Domain events */
+enum efc_hw_domain_event {
+	EFC_HW_DOMAIN_ALLOC_OK,
+	EFC_HW_DOMAIN_ALLOC_FAIL,
+	EFC_HW_DOMAIN_ATTACH_OK,
+	EFC_HW_DOMAIN_ATTACH_FAIL,
+	EFC_HW_DOMAIN_FREE_OK,
+	EFC_HW_DOMAIN_FREE_FAIL,
+	EFC_HW_DOMAIN_LOST,
+	EFC_HW_DOMAIN_FOUND,
+	EFC_HW_DOMAIN_CHANGED,
+};
+
+struct efc_nport {
+	struct list_head	list_entry;
+	struct kref		ref;
+	void			(*release)(struct kref *arg);
+	struct efc		*efc;
+	u32			tgt_id;
+	u32			index;
+	u32			instance_index;
+	char			display_name[EFC_NAME_LENGTH];
+	bool			is_vport;
+	bool			free_req_pending;
+	bool			attached;
+	bool			p2p_winner;
+	struct efc_domain	*domain;
+	u64			wwpn;
+	u64			wwnn;
+	void			*ini_nport;
+	void			*tgt_nport;
+	void			*tgt_data;
+	void			*ini_data;
+
+	/* Members private to HW/SLI */
+	void			*hw;
+	u32			indicator;
+	u32			fc_id;
+	struct efc_dma		dma;
+
+	u8			wwnn_str[EFC_WWN_LENGTH];
+	__be64			sli_wwpn;
+	__be64			sli_wwnn;
+
+	struct efc_sm_ctx	sm;
+	struct xarray		lookup;
+	bool			enable_ini;
+	bool			enable_tgt;
+	bool			enable_rscn;
+	bool			shutting_down;
+	u32			p2p_port_id;
+	enum efc_nport_topology topology;
+	u8			service_params[EFC_SERVICE_PARMS_LENGTH];
+	u32			p2p_remote_port_id;
+};
+
+/**
+ * Fibre Channel domain object
+ *
+ * This object is a container for the various SLI components needed
+ * to connect to the domain of a FC or FCoE switch
+ * @efc:		pointer back to efc
+ * @instance_index:	unique instance index value
+ * @display_name:	Node display name
+ * @nport_list:		linked list of nports associated with this domain
+ * @ref:		Reference count, each nport takes a reference
+ * @release:		Function to free domain object
+ * @ini_domain:		initiator backend private domain data
+ * @tgt_domain:		target backend private domain data
+ * @hw:			pointer to HW
+ * @sm:			state machine context
+ * @fcf:		FC Forwarder table index
+ * @fcf_indicator:	FCFI
+ * @indicator:		VFI
+ * @nport_count:	Number of nports allocated
+ * @dma:		memory for Service Parameters
+ * @fcf_wwn:		WWN for FCF/switch
+ * @drvsm:		driver domain sm context
+ * @attached:		set true after attach completes
+ * @is_fc:		is FC
+ * @is_loop:		is loop topology
+ * @is_nlport:		is public loop
+ * @domain_found_pending:A domain found is pending, drec is updated
+ * @req_domain_free:	True if domain object should be free'd
+ * @req_accept_frames:	set in domain state machine to enable frames
+ * @domain_notify_pend:	Set in domain SM to avoid duplicate node event post
+ * @pending_drec:	Pending drec if a domain found is pending
+ * @service_params:	any nports service parameters
+ * @flogi_service_params:Fabric/P2p service parameters from FLOGI
+ * @lookup:		d_id to node lookup object
+ * @nport:		Pointer to first (physical) SLI port
+ */
+struct efc_domain {
+	struct efc		*efc;
+	char			display_name[EFC_NAME_LENGTH];
+	struct list_head	nport_list;
+	struct kref		ref;
+	void			(*release)(struct kref *arg);
+	void			*ini_domain;
+	void			*tgt_domain;
+
+	/* Declarations private to HW/SLI */
+	void			*hw;
+	u32			fcf;
+	u32			fcf_indicator;
+	u32			indicator;
+	u32			nport_count;
+	struct efc_dma		dma;
+
+	/* Declarations private to FC trannport */
+	u64			fcf_wwn;
+	struct efc_sm_ctx	drvsm;
+	bool			attached;
+	bool			is_fc;
+	bool			is_loop;
+	bool			is_nlport;
+	bool			domain_found_pending;
+	bool			req_domain_free;
+	bool			req_accept_frames;
+	bool			domain_notify_pend;
+
+	struct efc_domain_record pending_drec;
+	u8			service_params[EFC_SERVICE_PARMS_LENGTH];
+	u8			flogi_service_params[EFC_SERVICE_PARMS_LENGTH];
+
+	struct xarray		lookup;
+
+	struct efc_nport	*nport;
+};
+
+/**
+ * Remote Node object
+ *
+ * This object represents a connection between the SLI port and another
+ * Nx_Port on the fabric. Note this can be either a well known port such
+ * as a F_Port (i.e. ff:ff:fe) or another N_Port.
+ * @indicator:		RPI
+ * @fc_id:		FC address
+ * @attached:		true if attached
+ * @nport:		associated SLI port
+ * @node:		associated node
+ */
+struct efc_remote_node {
+	u32			indicator;
+	u32			index;
+	u32			fc_id;
+
+	bool			attached;
+
+	struct efc_nport	*nport;
+	void			*node;
+};
+
+/**
+ * FC Node object
+ * @efc:		pointer back to efc structure
+ * @display_name:	Node display name
+ * @nort:		Assosiated nport pointer.
+ * @hold_frames:	hold incoming frames if true
+ * @els_io_enabled:	Enable allocating els ios for this node
+ * @els_ios_lock:	lock to protect the els ios list
+ * @els_ios_list:	ELS I/O's for this node
+ * @ini_node:		backend initiator private node data
+ * @tgt_node:		backend target private node data
+ * @rnode:		Remote node
+ * @sm:			state machine context
+ * @evtdepth:		current event posting nesting depth
+ * @req_free:		this node is to be free'd
+ * @attached:		node is attached (REGLOGIN complete)
+ * @fcp_enabled:	node is enabled to handle FCP
+ * @rscn_pending:	for name server node RSCN is pending
+ * @send_plogi:		send PLOGI accept, upon completion of node attach
+ * @send_plogi_acc:	TRUE if io_alloc() is enabled.
+ * @send_ls_acc:	type of LS acc to send
+ * @ls_acc_io:		SCSI IO for LS acc
+ * @ls_acc_oxid:	OX_ID for pending accept
+ * @ls_acc_did:		D_ID for pending accept
+ * @shutdown_reason:	reason for node shutdown
+ * @sparm_dma_buf:	service parameters buffer
+ * @service_params:	plogi/acc frame from remote device
+ * @pend_frames_lock:	lock for inbound pending frames list
+ * @pend_frames:	inbound pending frames list
+ * @pend_frames_processed:count of frames processed in hold frames interval
+ * @ox_id_in_use:	used to verify one at a time us of ox_id
+ * @els_retries_remaining:for ELS, number of retries remaining
+ * @els_req_cnt:	number of outstanding ELS requests
+ * @els_cmpl_cnt:	number of outstanding ELS completions
+ * @abort_cnt:		Abort counter for debugging purpos
+ * @current_state_name:	current node state
+ * @prev_state_name:	previous node state
+ * @current_evt:	current event
+ * @prev_evt:		previous event
+ * @targ:		node is target capable
+ * @init:		node is init capable
+ * @refound:		Handle node refound case when node is being deleted
+ * @els_io_pend_list:	list of pending (not yet processed) ELS IOs
+ * @els_io_active_list:	list of active (processed) ELS IOs
+ * @nodedb_state:	Node debugging, saved state
+ * @gidpt_delay_timer:	GIDPT delay timer
+ * @time_last_gidpt_msec:Start time of last target RSCN GIDPT
+ * @wwnn:		remote port WWNN
+ * @wwpn:		remote port WWPN
+ */
+struct efc_node {
+	struct efc		*efc;
+	char			display_name[EFC_NAME_LENGTH];
+	struct efc_nport	*nport;
+	struct kref		ref;
+	void			(*release)(struct kref *arg);
+	bool			hold_frames;
+	bool			els_io_enabled;
+	bool			send_plogi_acc;
+	bool			send_plogi;
+	bool			rscn_pending;
+	bool			fcp_enabled;
+	bool			attached;
+	bool			req_free;
+
+	spinlock_t		els_ios_lock;
+	struct list_head	els_ios_list;
+	void			*ini_node;
+	void			*tgt_node;
+
+	struct efc_remote_node	rnode;
+	/* Declarations private to FC trannport */
+	struct efc_sm_ctx	sm;
+	u32			evtdepth;
+
+	enum efc_node_send_ls_acc send_ls_acc;
+	void			*ls_acc_io;
+	u32			ls_acc_oxid;
+	u32			ls_acc_did;
+	enum efc_node_shutd_rsn	shutdown_reason;
+	bool			targ;
+	bool			init;
+	bool			refound;
+	struct efc_dma		sparm_dma_buf;
+	u8			service_params[EFC_SERVICE_PARMS_LENGTH];
+	spinlock_t		pend_frames_lock;
+	struct list_head	pend_frames;
+	u32			pend_frames_processed;
+	u32			ox_id_in_use;
+	u32			els_retries_remaining;
+	u32			els_req_cnt;
+	u32			els_cmpl_cnt;
+	u32			abort_cnt;
+
+	char			current_state_name[EFC_SM_NAME_LENGTH];
+	char			prev_state_name[EFC_SM_NAME_LENGTH];
+	int			current_evt;
+	int			prev_evt;
+
+	void (*nodedb_state)(struct efc_sm_ctx *ctx,
+			      u32 evt, void *arg);
+	struct timer_list	gidpt_delay_timer;
+	u64			time_last_gidpt_msec;
+
+	char			wwnn[EFC_WWN_LENGTH];
+	char			wwpn[EFC_WWN_LENGTH];
+};
+
+/**
+ * NPIV port
+ *
+ * Collection of the information required to restore a virtual port across
+ * link events
+ * @wwnn:		node name
+ * @wwpn:		port name
+ * @fc_id:		port id
+ * @tgt_data:		target backend pointer
+ * @ini_data:		initiator backend pointe
+ * @nport:		Used to match record after attaching for update
+ *
+ */
+
+struct efc_vport {
+	struct list_head	list_entry;
+	u64			wwnn;
+	u64			wwpn;
+	u32			fc_id;
+	bool			enable_tgt;
+	bool			enable_ini;
+	void			*tgt_data;
+	void			*ini_data;
+	struct efc_nport	*nport;
+};
+
+#define node_printf(node, fmt, args...) \
+	efc_log_info(node->efc, "[%s] " fmt, node->display_name, ##args)
+
+/* Node SM IO Context Callback structure */
+struct efc_node_cb {
+	int			status;
+	int			ext_status;
+	struct efc_hw_rq_buffer *header;
+	struct efc_hw_rq_buffer *payload;
+	struct efc_dma		els_rsp;
+
+	/* Actual length of data received */
+	int			rsp_len;
+};
+
+/* HW unsolicited callback status */
+enum efc_hw_unsol_status {
+	EFC_HW_UNSOL_SUCCESS,
+	EFC_HW_UNSOL_ERROR,
+	EFC_HW_UNSOL_ABTS_RCVD,
+	EFC_HW_UNSOL_MAX,	/**< must be last */
+};
+
+enum efc_hw_rq_buffer_type {
+	EFC_HW_RQ_BUFFER_TYPE_HDR,
+	EFC_HW_RQ_BUFFER_TYPE_PAYLOAD,
+	EFC_HW_RQ_BUFFER_TYPE_MAX,
+};
+
+struct efc_hw_rq_buffer {
+	u16			rqindex;
+	struct efc_dma		dma;
+};
+
+/*
+ * Defines a general FC sequence object,
+ * consisting of a header, payload buffers
+ * and a HW IO in the case of port owned XRI
+ */
+struct efc_hw_sequence {
+	struct list_head	list_entry;
+	void			*hw;
+	u8			fcfi;
+	u8			auto_xrdy;
+	u8			out_of_xris;
+	enum efc_hw_unsol_status status;
+
+	struct efc_hw_rq_buffer *header;
+	struct efc_hw_rq_buffer *payload;
+
+	void			*hw_priv;
+};
+
+enum efc_disc_io_type {
+	EFC_DISC_IO_ELS_REQ,
+	EFC_DISC_IO_ELS_RESP,
+	EFC_DISC_IO_CT_REQ,
+	EFC_DISC_IO_CT_RESP
+};
+
+struct efc_io_els_params {
+	u32             s_id;
+	u16             ox_id;
+	u8              timeout;
+};
+
+struct efc_io_ct_params {
+	u8              r_ctl;
+	u8              type;
+	u8              df_ctl;
+	u8              timeout;
+	u16             ox_id;
+};
+
+union efc_disc_io_param {
+	struct efc_io_els_params els;
+	struct efc_io_ct_params ct;
+};
+
+struct efc_disc_io {
+	struct efc_dma		req;         /* send buffer */
+	struct efc_dma		rsp;         /* receive buffer */
+	enum efc_disc_io_type	io_type;     /* EFC_DISC_IO_TYPE enum*/
+	u16			xmit_len;    /* Length of els request*/
+	u16			rsp_len;     /* Max length of rsps to be rcvd */
+	u32			rpi;         /* Registered RPI */
+	u32			vpi;         /* VPI for this nport */
+	u32			s_id;
+	u32			d_id;
+	bool			rpi_registered; /* if false, use tmp RPI */
+	union efc_disc_io_param iparam;
+};
+
+/* Return value indiacating the sequence can not be freed */
+#define EFC_HW_SEQ_HOLD		0
+/* Return value indiacating the sequence can be freed */
+#define EFC_HW_SEQ_FREE		1
+
+struct libefc_function_template {
+	/*Sport*/
+	int (*new_nport)(struct efc *efc, struct efc_nport *sp);
+	void (*del_nport)(struct efc *efc, struct efc_nport *sp);
+
+	/*Scsi Node*/
+	int (*scsi_new_node)(struct efc *efc, struct efc_node *n);
+	int (*scsi_del_node)(struct efc *efc, struct efc_node *n, int reason);
+
+	int (*issue_mbox_rqst)(void *efct, void *buf, void *cb, void *arg);
+	/*Send ELS IO*/
+	int (*send_els)(struct efc *efc, struct efc_disc_io *io);
+	/*Send BLS IO*/
+	int (*send_bls)(struct efc *efc, u32 type, struct sli_bls_params *bls);
+	/*Free HW frame*/
+	int (*hw_seq_free)(struct efc *efc, struct efc_hw_sequence *seq);
+};
+
+#define EFC_LOG_LIB		0x01
+#define EFC_LOG_NODE		0x02
+#define EFC_LOG_PORT		0x04
+#define EFC_LOG_DOMAIN		0x08
+#define EFC_LOG_ELS		0x10
+#define EFC_LOG_DOMAIN_SM	0x20
+#define EFC_LOG_SM		0x40
+
+/* efc library port structure */
+struct efc {
+	void			*base;
+	struct pci_dev		*pci;
+	struct sli4		*sli;
+	u32			fcfi;
+	u64			req_wwpn;
+	u64			req_wwnn;
+
+	u64			def_wwpn;
+	u64			def_wwnn;
+	u64			max_xfer_size;
+	mempool_t		*node_pool;
+	struct dma_pool		*node_dma_pool;
+	u32			nodes_count;
+
+	u32			link_status;
+
+	struct list_head	vport_list;
+	/* lock to protect the vport list */
+	spinlock_t		vport_lock;
+
+	struct libefc_function_template tt;
+	/* lock to protect the discovery library.
+	 * Refer to efclib.c for more details.
+	 */
+	spinlock_t		lock;
+
+	bool			enable_ini;
+	bool			enable_tgt;
+
+	u32			log_level;
+
+	struct efc_domain	*domain;
+	void (*domain_free_cb)(struct efc *efc, void *arg);
+	void			*domain_free_cb_arg;
+
+	u64			tgt_rscn_delay_msec;
+	u64			tgt_rscn_period_msec;
+
+	bool			external_loopback;
+	u32			nodedb_mask;
+	u32			logmask;
+	mempool_t		*els_io_pool;
+	atomic_t		els_io_alloc_failed_count;
+
+	/* hold pending frames */
+	bool			hold_frames;
+	/* lock to protect pending frames list access */
+	spinlock_t		pend_frames_lock;
+	struct list_head	pend_frames;
+	/* count of pending frames that were processed */
+	u32			pend_frames_processed;
+
+};
+
+/*
+ * EFC library registration
+ * **********************************/
+int efcport_init(struct efc *efc);
+void efcport_destroy(struct efc *efc);
+/*
+ * EFC Domain
+ * **********************************/
+int efc_domain_cb(void *arg, int event, void *data);
+void
+efc_register_domain_free_cb(struct efc *efc,
+			void (*callback)(struct efc *efc, void *arg),
+			void *arg);
+
+/*
+ * EFC nport
+ * **********************************/
+void efc_nport_cb(void *arg, int event, void *data);
+struct efc_vport *efc_vport_create_spec(struct efc *efc, u64 wwnn,
+			u64 wwpn, u32 fc_id, bool enable_ini, bool enable_tgt,
+			void *tgt_data, void *ini_data);
+int efc_nport_vport_new(struct efc_domain *domain, u64 wwpn,
+			u64 wwnn, u32 fc_id, bool ini, bool tgt,
+			void *tgt_data, void *ini_data);
+int efc_nport_vport_del(struct efc *efc, struct efc_domain *domain,
+			u64 wwpn, u64 wwnn);
+
+void efc_vport_del_all(struct efc *efc);
+
+/*
+ * EFC Node
+ * **********************************/
+int efc_remote_node_cb(void *arg, int event, void *data);
+void efc_node_fcid_display(u32 fc_id, char *buffer, u32 buf_len);
+void efc_node_post_shutdown(struct efc_node *node, u32 evt, void *arg);
+u64 efc_node_get_wwpn(struct efc_node *node);
+
+/*
+ * EFC FCP/ELS/CT interface
+ * **********************************/
+void efc_dispatch_frame(struct efc *efc, struct efc_hw_sequence *seq);
+void efc_disc_io_complete(struct efc_disc_io *io, u32 len, u32 status,
+			  u32 ext_status);
+
+/*
+ * EFC SCSI INTERACTION LAYER
+ * **********************************/
+void efc_scsi_sess_reg_complete(struct efc_node *node, u32 status);
+void efc_scsi_del_initiator_complete(struct efc *efc, struct efc_node *node);
+void efc_scsi_del_target_complete(struct efc *efc, struct efc_node *node);
+void efc_scsi_io_list_empty(struct efc *efc, struct efc_node *node);
+
+#endif /* __EFCLIB_H__ */
-- 
2.26.2

