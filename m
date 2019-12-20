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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E703EC2D0D5
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 982E32082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWP/0jKC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfLTWhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:43 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:38295 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfLTWhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:43 -0500
Received: by mail-pf1-f176.google.com with SMTP id x185so5999319pfc.5
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nXm0N8Y+6BbHLQFPuAgUlpE9ZPwZDXqZdwCtAngt7Mo=;
        b=jWP/0jKCURbBrDvUsiunoDNYqrzVuXirgIXuUHj6sDy+m7g8qVqQYzHKjimOUxWDq/
         C/fQ6diDQvyxgx0Rqbr9RlzIHkYhbaaOHceS+bAfnmeYFxHElOHVMSC2E6kD4bEwse9a
         AuOit6Fznby7H2BwxBc1B5NlvqHTcn0ieEUxoOEkPSxQqNqmAnlYTzsFgXh42uw8sk5W
         b4iVYiVyD3S+EcRSJfOUeGcqWch8dZHG9pH3suNnMdj6tMaSrIcKlCkSzw5OAzEB0yl5
         TNzQgcJwphQr9HFQ9M6N59Q8itBpTihXqCn3cxuPcKMlg2nnWsHIUJzysPTDae8usaq2
         72Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nXm0N8Y+6BbHLQFPuAgUlpE9ZPwZDXqZdwCtAngt7Mo=;
        b=Q1WhoFM5NMekbNocEfRKLXdLH+P41RMUvP8/SwuQWF+StLqRX8ost0jhbi/U3j9oeG
         S7cphzxAGXvfxzr85Rec3rBBatnhKm9erKZMDagMyBJE0g9UYnnIP6FG1X1OjtI+ECFp
         qcevoIkX6Z3p/qLbMpDYUtZwFh9uvO9Ny6IYMceIIfF6zcsb3Gpeq+TjBfpC06NtRpZR
         KZYWxBtMzp+QOuXPKxVlmBTKhRlRzDS8o/mNIxujcGw2UHR0YxByAoMuOZ8Rug14gldJ
         6q1AahFQ7mTJWuQReGyV7srp/h4GRFj10stlJ4vmCvcD9BbDJ0HsErRSZZS6PyeC7Lx0
         0tjw==
X-Gm-Message-State: APjAAAXrUyRZnyHtQ5YAXppbhDS9AdECsrrY7evEDgQwasFKst7eHP2Y
        PQI5JsfHCkjQro53D1JnKtNtNck2
X-Google-Smtp-Source: APXvYqz9ebJWZj005mKcbBfa58chQu+vwfGIdLfmOSAggwJeR6+5xl0Iqlz12Df9OnSdWfT22bU0Xw==
X-Received: by 2002:a62:ee11:: with SMTP id e17mr415119pfi.48.1576881461450;
        Fri, 20 Dec 2019 14:37:41 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:40 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 09/32] elx: libefc: Emulex FC discovery library APIs and definitions
Date:   Fri, 20 Dec 2019 14:37:00 -0800
Message-Id: <20191220223723.26563-10-jsmart2021@gmail.com>
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
- SLI/Local FC port objects
- efc_domain_s: FC domain (aka fabric) objects
- efc_node_s: FC node (aka remote ports) objects
- A sparse vector interface that manages lookup tables
  for the objects.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc/efc.h     |  99 ++++++
 drivers/scsi/elx/libefc/efc_lib.c | 131 ++++++++
 drivers/scsi/elx/libefc/efclib.h  | 637 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 867 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc.h
 create mode 100644 drivers/scsi/elx/libefc/efc_lib.c
 create mode 100644 drivers/scsi/elx/libefc/efclib.h

diff --git a/drivers/scsi/elx/libefc/efc.h b/drivers/scsi/elx/libefc/efc.h
new file mode 100644
index 000000000000..ef7c83e44167
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFC_H__
+#define __EFC_H__
+
+#include "../include/efc_common.h"
+#include "efclib.h"
+#include "efc_sm.h"
+#include "efc_domain.h"
+#include "efc_sport.h"
+#include "efc_node.h"
+#include "efc_fabric.h"
+#include "efc_device.h"
+
+#define EFC_MAX_REMOTE_NODES			2048
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
+/* Timeouts */
+#define EFC_FC_ELS_SEND_DEFAULT_TIMEOUT		0
+#define EFC_FC_FLOGI_TIMEOUT_SEC		5
+#define EFC_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC	30000000
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
+	efc_log_debug(node->efc, \
+		"[%s] %-20s\n", node->display_name, efc_sm_event_name(evt)) \
+
+#define sport_sm_trace(sport) \
+	efc_log_debug(sport->efc, \
+		"[%s] %-20s\n", sport->display_name, efc_sm_event_name(evt)) \
+
+/**
+ * Sparse Vector API
+ *
+ * This is a trimmed down sparse vector implementation tuned to the problem of
+ * 24-bit FC_IDs. In this case, the 24-bit index value is broken down in three
+ * 8-bit values. These values are used to index up to three 256 element arrays.
+ * Arrays are allocated, only when needed. @n @n
+ * The lookup can complete in constant time (3 indexed array references). @n @n
+ * A typical use case would be that the fabric/directory FC_IDs would cause two
+ * rows to be allocated, and the fabric assigned remote nodes would cause two
+ * rows to be allocated, with the root row always allocated. This gives five
+ * rows of 256 x sizeof(void*), resulting in 10k.
+ */
+
+struct sparse_vector {
+	struct efc *efc;
+	u32 max_idx;
+	void **array;
+};
+
+#define SPV_ROWLEN	256
+#define SPV_DIM		3
+
+void efc_spv_del(struct sparse_vector *spv);
+struct sparse_vector *efc_spv_new(struct efc *efc);
+void efc_spv_set(struct sparse_vector *sv, u32 idx, void *value);
+void *efc_spv_get(struct sparse_vector *sv, u32 idx);
+
+#endif /* __EFC_H__ */
diff --git a/drivers/scsi/elx/libefc/efc_lib.c b/drivers/scsi/elx/libefc/efc_lib.c
new file mode 100644
index 000000000000..9ab8538d6e1f
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_lib.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "efc.h"
+
+int efcport_init(struct efc *efc)
+{
+	u32 rc = 0;
+
+	spin_lock_init(&efc->lock);
+	INIT_LIST_HEAD(&efc->vport_list);
+
+	/* Create Node pool */
+	rc = efc_node_create_pool(efc, EFC_MAX_REMOTE_NODES);
+	if (rc)
+		efc_log_err(efc, "Can't allocate node pool\n");
+
+	return rc;
+}
+
+void efcport_destroy(struct efc *efc)
+{
+	efc_node_free_pool(efc);
+}
+
+static void **efc_spv_new_row(u32 rowcount)
+{
+	return kzalloc(sizeof(void *) * rowcount, GFP_ATOMIC);
+}
+
+/* Recursively delete the rows in this sparse vector */
+static void
+_efc_spv_del(struct efc *efc, void **a, u32 n, u32 depth)
+{
+	if (a) {
+		if (depth) {
+			u32 i;
+
+			for (i = 0; i < n; i++)
+				_efc_spv_del(efc, a[i], n, depth - 1);
+
+			kfree(a);
+		}
+	}
+}
+
+void
+efc_spv_del(struct sparse_vector *spv)
+{
+	if (spv) {
+		_efc_spv_del(spv->efc, spv->array, SPV_ROWLEN, SPV_DIM);
+		kfree(spv);
+	}
+}
+
+struct sparse_vector
+*efc_spv_new(struct efc *efc)
+{
+	struct sparse_vector *spv;
+	u32 i;
+
+	spv = kzalloc(sizeof(*spv), GFP_ATOMIC);
+	if (!spv)
+		return NULL;
+
+	spv->efc = efc;
+	spv->max_idx = 1;
+	for (i = 0; i < SPV_DIM; i++)
+		spv->max_idx *= SPV_ROWLEN;
+
+	return spv;
+}
+
+static void
+*efc_spv_new_cell(struct sparse_vector *sv, u32 idx, bool alloc_new_rows)
+{
+	void **p;
+	u32 a = (idx >> 16) & 0xff;
+	u32 b = (idx >>  8) & 0xff;
+	u32 c = (idx >>  0) & 0xff;
+
+	if (idx >= sv->max_idx)
+		return NULL;
+
+	if (!sv->array) {
+		sv->array = (alloc_new_rows ?
+			     efc_spv_new_row(SPV_ROWLEN) : NULL);
+		if (!sv->array)
+			return NULL;
+	}
+	p = sv->array;
+	if (!p[a]) {
+		p[a] = (alloc_new_rows ? efc_spv_new_row(SPV_ROWLEN) : NULL);
+		if (!p[a])
+			return NULL;
+	}
+	p = p[a];
+	if (!p[b]) {
+		p[b] = (alloc_new_rows ? efc_spv_new_row(SPV_ROWLEN) : NULL);
+		if (!p[b])
+			return NULL;
+	}
+	p = p[b];
+
+	return &p[c];
+}
+
+void
+efc_spv_set(struct sparse_vector *sv, u32 idx, void *value)
+{
+	void **ref = efc_spv_new_cell(sv, idx, true);
+
+	if (ref)
+		*ref = value;
+}
+
+void
+*efc_spv_get(struct sparse_vector *sv, u32 idx)
+{
+	void **ref = efc_spv_new_cell(sv, idx, false);
+
+	if (ref)
+		return *ref;
+
+	return NULL;
+}
diff --git a/drivers/scsi/elx/libefc/efclib.h b/drivers/scsi/elx/libefc/efclib.h
new file mode 100644
index 000000000000..56f6e4afca65
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efclib.h
@@ -0,0 +1,637 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
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
+
+#define EFC_SERVICE_PARMS_LENGTH	0x74
+#define EFC_DISPLAY_NAME_LENGTH		32
+#define EFC_DISPLAY_BUS_INFO_LENGTH	16
+
+#define EFC_WWN_LENGTH			32
+
+/* Local port topology */
+enum efc_sport_topology {
+	EFC_SPORT_TOPOLOGY_UNKNOWN = 0,
+	EFC_SPORT_TOPOLOGY_FABRIC,
+	EFC_SPORT_TOPOLOGY_P2P,
+	EFC_SPORT_TOPOLOGY_LOOP,
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
+	void *(*current_state)(struct efc_sm_ctx *ctx,
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
+/* Fabric/Domain events */
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
+enum efc_hw_port_event {
+	EFC_HW_PORT_ALLOC_OK,
+	EFC_HW_PORT_ALLOC_FAIL,
+	EFC_HW_PORT_ATTACH_OK,
+	EFC_HW_PORT_ATTACH_FAIL,
+	EFC_HW_PORT_FREE_OK,
+	EFC_HW_PORT_FREE_FAIL,
+};
+
+enum efc_hw_remote_node_event {
+	EFC_HW_NODE_ATTACH_OK,
+	EFC_HW_NODE_ATTACH_FAIL,
+	EFC_HW_NODE_FREE_OK,
+	EFC_HW_NODE_FREE_FAIL,
+	EFC_HW_NODE_FREE_ALL_OK,
+	EFC_HW_NODE_FREE_ALL_FAIL,
+};
+
+enum efc_hw_node_els_event {
+	EFC_HW_SRRS_ELS_REQ_OK,
+	EFC_HW_SRRS_ELS_CMPL_OK,
+	EFC_HW_SRRS_ELS_REQ_FAIL,
+	EFC_HW_SRRS_ELS_CMPL_FAIL,
+	EFC_HW_SRRS_ELS_REQ_RJT,
+	EFC_HW_ELS_REQ_ABORTED,
+};
+
+struct efc_sli_port {
+	struct list_head	list_entry;
+	struct efc		*efc;
+	u32			tgt_id;
+	u32			index;
+	u32			instance_index;
+	char			display_name[EFC_DISPLAY_NAME_LENGTH];
+	struct efc_domain	*domain;
+	bool			is_vport;
+	u64			wwpn;
+	u64			wwnn;
+	struct list_head	node_list;
+	void			*ini_sport;
+	void			*tgt_sport;
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
+	bool			free_req_pending;
+	bool			attached;
+
+	struct efc_sm_ctx	sm;
+	struct sparse_vector	*lookup;
+	bool			enable_ini;
+	bool			enable_tgt;
+	bool			enable_rscn;
+	bool			shutting_down;
+	bool			p2p_winner;
+	enum efc_sport_topology topology;
+	u8			service_params[EFC_SERVICE_PARMS_LENGTH];
+	u32			p2p_remote_port_id;
+	u32			p2p_port_id;
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
+ * @sport_list:		linked list of SLI ports
+ * @ini_domain:		initiator backend private domain data
+ * @tgt_domain:		target backend private domain data
+ * @hw:			pointer to HW
+ * @sm:			state machine context
+ * @fcf:		FC Forwarder table index
+ * @fcf_indicator:	FCFI
+ * @indicator:		VFI
+ * @dma:		memory for Service Parameters
+ * @fcf_wwn:		WWN for FCF/switch
+ * @drvsm:		driver domain sm context
+ * @drvsm_lock:		driver domain sm lock
+ * @attached:		set true after attach completes
+ * @is_fc:		is FC
+ * @is_loop:		is loop topology
+ * @is_nlport:		is public loop
+ * @domain_found_pending:A domain found is pending, drec is updated
+ * @req_domain_free:	True if domain object should be free'd
+ * @req_accept_frames:	set in domain state machine to enable frames
+ * @domain_notify_pend:	Set in domain SM to avoid duplicate node event post
+ * @pending_drec:	Pending drec if a domain found is pending
+ * @service_params:	any sports service parameters
+ * @flogi_service_params:Fabric/P2p service parameters from FLOGI
+ * @lookup:		d_id to node lookup object
+ * @sport:		Pointer to first (physical) SLI port
+ */
+struct efc_domain {
+	struct efc		*efc;
+	char			display_name[EFC_DISPLAY_NAME_LENGTH];
+	struct list_head	sport_list;
+	void			*ini_domain;
+	void			*tgt_domain;
+
+	/* Declarations private to HW/SLI */
+	void			*hw;
+	u32			fcf;
+	u32			fcf_indicator;
+	u32			indicator;
+	struct efc_dma		dma;
+
+	/* Declarations private to FC transport */
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
+	struct sparse_vector	*lookup;
+
+	struct efc_sli_port	*sport;
+	u32			sport_instance_count;
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
+ * @node_group:		true if in node group
+ * @free_group:		true if the node group should be free'd
+ * @sport:		associated SLI port
+ * @node:		associated node
+ */
+struct efc_remote_node {
+	u32			indicator;
+	u32			index;
+	u32			fc_id;
+
+	bool			attached;
+	bool			node_group;
+	bool			free_group;
+
+	struct efc_sli_port	*sport;
+	void			*node;
+};
+
+/**
+ * FC Node object
+ * @efc:		pointer back to efc structure
+ * @instance_index:	unique instance index value
+ * @display_name:	Node display name
+ * @hold_frames:	hold incoming frames if true
+ * @lock:		node wide lock
+ * @active_ios:		active I/O's for this node
+ * @max_wr_xfer_size:	Max write IO size per phase for the transport
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
+ * @chained_io_count:	Statistics : count of IOs with chained SGL's
+ */
+struct efc_node {
+	struct list_head	list_entry;
+	struct efc		*efc;
+	u32			instance_index;
+	char			display_name[EFC_DISPLAY_NAME_LENGTH];
+	struct efc_sli_port	*sport;
+	bool			hold_frames;
+	spinlock_t		active_ios_lock;
+	struct list_head	active_ios;
+	u64			max_wr_xfer_size;
+	void			*ini_node;
+	void			*tgt_node;
+
+	struct efc_remote_node	rnode;
+	/* Declarations private to FC transport */
+	struct efc_sm_ctx	sm;
+	u32			evtdepth;
+
+	bool			req_free;
+	bool			attached;
+	bool			fcp_enabled;
+	bool			rscn_pending;
+	bool			send_plogi;
+	bool			send_plogi_acc;
+	bool			io_alloc_enabled;
+
+	enum efc_node_send_ls_acc send_ls_acc;
+	void			*ls_acc_io;
+	u32			ls_acc_oxid;
+	u32			ls_acc_did;
+	enum efc_node_shutd_rsn	shutdown_reason;
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
+	char			current_state_name[EFC_DISPLAY_NAME_LENGTH];
+	char			prev_state_name[EFC_DISPLAY_NAME_LENGTH];
+	int			current_evt;
+	int			prev_evt;
+	bool			targ;
+	bool			init;
+	bool			refound;
+	struct list_head	els_io_pend_list;
+	struct list_head	els_io_active_list;
+
+	void *(*nodedb_state)(struct efc_sm_ctx *ctx,
+			      u32 evt, void *arg);
+	struct timer_list	gidpt_delay_timer;
+	time_t			time_last_gidpt_msec;
+
+	char			wwnn[EFC_WWN_LENGTH];
+	char			wwpn[EFC_WWN_LENGTH];
+
+	u32			chained_io_count;
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
+ * @sport:		Used to match record after attaching for update
+ *
+ */
+
+struct efc_vport_spec {
+	struct list_head	list_entry;
+	u64			wwnn;
+	u64			wwpn;
+	u32			fc_id;
+	bool			enable_tgt;
+	bool			enable_ini;
+	void			*tgt_data;
+	void			*ini_data;
+	struct efc_sli_port	*sport;
+};
+
+#define node_printf(node, fmt, args...) \
+	pr_info("[%s] " fmt, node->display_name, ##args)
+
+/* Node SM IO Context Callback structure */
+struct efc_node_cb {
+	int			status;
+	int			ext_status;
+	struct efc_hw_rq_buffer *header;
+	struct efc_hw_rq_buffer *payload;
+	struct efc_dma		els_rsp;
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
+
+	struct efc_hw_rq_buffer *header;
+	struct efc_hw_rq_buffer *payload;
+
+	enum efc_hw_unsol_status status;
+	struct efct_hw_io	*hio;
+
+	void			*hw_priv;
+};
+
+struct libefc_function_template {
+	/*Domain*/
+	int (*hw_domain_alloc)(struct efc *efc, struct efc_domain *d, u32 fcf);
+	int (*hw_domain_attach)(struct efc *efc, struct efc_domain *d, u32 id);
+
+	int (*hw_domain_free)(struct efc *hw, struct efc_domain *d);
+	int (*hw_domain_force_free)(struct efc *efc, struct efc_domain *d);
+
+	int (*new_domain)(struct efc *efc, struct efc_domain *d);
+	void (*del_domain)(struct efc *efc, struct efc_domain *d);
+
+	void (*domain_hold_frames)(struct efc *efc, struct efc_domain *d);
+	void (*domain_accept_frames)(struct efc *efc, struct efc_domain *d);
+
+	/*Sport*/
+	int (*hw_port_alloc)(struct efc *hw, struct efc_sli_port *sp,
+			     struct efc_domain *d, u8 *val);
+	int (*hw_port_attach)(struct efc *hw, struct efc_sli_port *sp,
+			      u32 fc_id);
+
+	int (*hw_port_free)(struct efc *hw, struct efc_sli_port *sp);
+
+	int (*new_sport)(struct efc *efc, struct efc_sli_port *sp);
+	void (*del_sport)(struct efc *efc, struct efc_sli_port *sp);
+
+	/*Node*/
+	int (*hw_node_alloc)(struct efc *hw, struct efc_remote_node *n,
+			     u32 fc_addr, struct efc_sli_port *sport);
+
+	int (*hw_node_attach)(struct efc *hw, struct efc_remote_node *n,
+			      struct efc_dma *sparams);
+
+	int (*hw_node_detach)(struct efc *hw, struct efc_remote_node *r);
+
+	int (*hw_node_free_resources)(struct efc *efc,
+				      struct efc_remote_node *node);
+	int (*node_purge_pending)(struct efc *efc, struct efc_node *n);
+
+	void (*node_io_cleanup)(struct efc *efc, struct efc_node *n,
+				bool force);
+	void (*node_els_cleanup)(struct efc *efc, struct efc_node *n,
+				bool force);
+	void (*node_abort_all_els)(struct efc *efc, struct efc_node *n);
+
+	/*Scsi*/
+	void (*scsi_io_alloc_disable)(struct efc *efc, struct efc_node *node);
+	void (*scsi_io_alloc_enable)(struct efc *efc, struct efc_node *node);
+
+	int (*scsi_validate_node)(struct efc *efc, struct efc_node *n);
+	int (*scsi_new_node)(struct efc *efc, struct efc_node *n);
+
+	int (*scsi_del_node)(struct efc *efc, struct efc_node *n, int reason);
+
+	/*Send ELS*/
+	void *(*els_send)(struct efc *efc, struct efc_node *node,
+			  u32 cmd, u32 timeout_sec, u32 retries);
+
+	void *(*els_send_ct)(struct efc *efc, struct efc_node *node,
+			     u32 cmd, u32 timeout_sec, u32 retries);
+
+	void *(*els_send_resp)(struct efc *efc, struct efc_node *node,
+			       u32 cmd, u16 ox_id);
+
+	void *(*bls_send_acc_hdr)(struct efc *efc, struct efc_node *n,
+				  struct fc_frame_header *hdr);
+	void *(*send_flogi_p2p_acc)(struct efc *efc, struct efc_node *n,
+				    u32 ox_id, u32 s_id);
+
+	int (*send_ct_rsp)(struct efc *efc, struct efc_node *node,
+			   u16 ox_id, struct fc_ct_hdr *hdr,
+			   u32 rsp_code, u32 reason_code, u32 rsn_code_expl);
+
+	void *(*send_ls_rjt)(struct efc *efc, struct efc_node *node,
+			     u32 ox, u32 rcode, u32 rcode_expl, u32 vendor);
+
+	int (*dispatch_fcp_cmd)(struct efc_node *node,
+				struct efc_hw_sequence *seq);
+
+	int (*recv_abts_frame)(struct efc *efc, struct efc_node *node,
+			       struct efc_hw_sequence *seq);
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
+	struct pci_dev		*pcidev;
+	u64			req_wwpn;
+	u64			req_wwnn;
+
+	u64			def_wwpn;
+	u64			def_wwnn;
+	u64			max_xfer_size;
+	u32			nodes_count;
+	struct efc_node		**nodes;
+	struct list_head	nodes_free_list;
+
+	u32			link_status;
+
+	/* vport */
+	struct list_head	vport_list;
+
+	struct libefc_function_template tt;
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
+	time_t			tgt_rscn_delay_msec;
+	time_t			tgt_rscn_period_msec;
+
+	bool			external_loopback;
+	u32			nodedb_mask;
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
+void efc_domain_force_free(struct efc_domain *domain);
+void
+efc_register_domain_free_cb(struct efc *efc,
+			    void (*callback)(struct efc *efc, void *arg),
+			    void *arg);
+
+/*
+ * EFC Local port
+ * **********************************/
+int efc_lport_cb(void *arg, int event, void *data);
+int8_t efc_vport_create_spec(struct efc *efc, u64 wwnn,
+			     u64 wwpn, u32 fc_id, bool enable_ini,
+			     bool enable_tgt, void *tgt_data, void *ini_data);
+int efc_sport_vport_new(struct efc_domain *domain, u64 wwpn,
+			u64 wwnn, u32 fc_id, bool ini, bool tgt,
+			void *tgt_data, void *ini_data, bool restore_vport);
+int efc_sport_vport_del(struct efc *efc, struct efc_domain *domain,
+			u64 wwpn, u64 wwnn);
+
+void efc_vport_del_all(struct efc *efc);
+
+struct efc_sli_port *efc_sport_find(struct efc_domain *domain, u32 d_id);
+
+/*
+ * EFC Node
+ * **********************************/
+int efc_remote_node_cb(void *arg, int event, void *data);
+u64 efc_node_get_wwnn(struct efc_node *node);
+u64 efc_node_get_wwpn(struct efc_node *node);
+struct efc_node *efc_node_find(struct efc_sli_port *sport, u32 id);
+void efc_node_fcid_display(u32 fc_id, char *buffer, u32 buf_len);
+
+void efc_node_post_els_resp(struct efc_node *node, u32 evt, void *arg);
+void efc_node_post_shutdown(struct efc_node *node, u32 evt, void *arg);
+/*
+ * EFC FCP/ELS/CT interface
+ * **********************************/
+int efc_node_recv_abts_frame(struct efc *efc,
+			     struct efc_node *node,
+			     struct efc_hw_sequence *seq);
+int efc_node_recv_els_frame(struct efc_node *node, struct efc_hw_sequence *s);
+int efc_domain_dispatch_frame(void *arg, struct efc_hw_sequence *seq);
+
+int efc_node_dispatch_frame(void *arg, struct efc_hw_sequence *seq);
+
+int efc_node_recv_ct_frame(struct efc_node *node, struct efc_hw_sequence *seq);
+int efc_node_recv_fcp_cmd(struct efc_node *node, struct efc_hw_sequence *seq);
+int efc_node_recv_bls_no_sit(struct efc_node *node, struct efc_hw_sequence *s);
+
+/*
+ * EFC SCSI INTERACTION LAYER
+ * **********************************/
+void efc_scsi_del_initiator_complete(struct efc *efc, struct efc_node *node);
+void efc_scsi_del_target_complete(struct efc *efc, struct efc_node *node);
+void efc_scsi_io_list_empty(struct efc *efc, struct efc_node *node);
+
+#endif /* __EFCLIB_H__ */
-- 
2.13.7

