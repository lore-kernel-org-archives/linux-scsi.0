Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461D7C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36962073A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bVEc6Cjm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390670AbgJLWwV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390640AbgJLWwR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:17 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE05C0613D0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h2so9519299pll.11
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Zzd4cX7RNFTxJS/ZBheWpaudjDrTqVP0Vu4Xc16oXIg=;
        b=bVEc6Cjmt6SHamNK1BF/J/eWVGn/TxC8Db0NF8sVARM3CcazfchxLTOyQULjfA3CCm
         +DEgKuXPrFUUqnQAQhiLFh0JNDr6QTJtt/A7gcQkAspVee6laRvwSohSV34FWc3eN87s
         VcP2ymC4MTiINvw+/IR2rlQm0Q9s/DdviS0o0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Zzd4cX7RNFTxJS/ZBheWpaudjDrTqVP0Vu4Xc16oXIg=;
        b=gW2XMiPQp/mJjTNHgSpDop+yYlFoLT/aH84Y3ogWAYc5j0leHiz8tMlpgeLtBBhhGM
         +vIi4UAbrTWmJlMmFp2xSHvlQ15pAe5KslGJ+lWrGTdGyMcSgdq512tywNvO2ibTosJ9
         rQ2DXBB+i+0OOSlskJs3NZpPwD+wcYPHxeB54G+6SSmQGvKOGCgZdbyHHqceNqw7t08d
         3XwT0e6Es/Y8Nofu9YafVxCqsMzVwF4uMd7+88y2EL3UCSCSDaxmiiJcJQ4fpYwTaz8b
         PKMnvP2tqHB/4aEjkYvdNf1zJWhVVlbD6Z+awDNawprbFKdT0m63NPMuv2voabUlDf0I
         nwPQ==
X-Gm-Message-State: AOAM533j/rWv93A/PQtrrTidwHbYugCUdBdxZ25JHfwx++FnGijTOzhh
        Z2ieLcOEZaoNK7RlNMatveRehXxrxTOAbFogSPu1Im9bMROHLff7o7qaAJt0ouXBUaiy58jxnl4
        5gcK5uwA3wyMYVqiaUTdpr0v4zcyoAtm5ByVNEebitWnbrfClfbPx0bHUT5ECUYCMXXckPeqGQw
        f9+mU=
X-Google-Smtp-Source: ABdhPJx9ZCc6d02PxnPSUqJIkTfJ3TUxSnBUa2fgXfeS/QBaqs+jecM+PNOYrB/oZHkhRT1xseWWCQ==
X-Received: by 2002:a17:902:fe86:b029:d4:d451:eb56 with SMTP id x6-20020a170902fe86b02900d4d451eb56mr9483846plm.79.1602543135512;
        Mon, 12 Oct 2020 15:52:15 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:14 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 14/31] elx: libefc: FC node ELS and state handling
Date:   Mon, 12 Oct 2020 15:51:30 -0700
Message-Id: <20201012225147.54404-15-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000066c24d05b18126aa"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000066c24d05b18126aa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the libefc library population.

This patch adds library interface definitions for:
- FC node PRLI handling and state management

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Replace fall through comment with fallthrough statement.
---
 drivers/scsi/elx/libefc/efc_device.c | 1600 ++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_device.h |   72 ++
 2 files changed, 1672 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_device.c
 create mode 100644 drivers/scsi/elx/libefc/efc_device.h

diff --git a/drivers/scsi/elx/libefc/efc_device.c b/drivers/scsi/elx/libefc/efc_device.c
new file mode 100644
index 000000000000..6ec87587923c
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_device.c
@@ -0,0 +1,1600 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * device_sm Node State Machine: Remote Device States
+ */
+
+#include "efc.h"
+#include "efc_device.h"
+#include "efc_fabric.h"
+
+void
+efc_d_send_prli_rsp(struct efc_node *node, uint16_t ox_id)
+{
+	u32 rc = EFC_SCSI_CALL_COMPLETE;
+	struct efc *efc = node->efc;
+
+	node->ls_acc_oxid = ox_id;
+	node->send_ls_acc = EFC_NODE_SEND_LS_ACC_PRLI;
+
+	/*
+	 * Wait for backend session registration
+	 * to complete before sending PRLI resp
+	 */
+
+	if (node->init) {
+		efc_log_info(efc, "[%s] found(initiator) WWPN:%s WWNN:%s\n",
+			node->display_name, node->wwpn, node->wwnn);
+		if (node->nport->enable_tgt)
+			rc = efc->tt.scsi_new_node(efc, node);
+	}
+
+	if (rc == EFC_SCSI_CALL_COMPLETE)
+		efc_node_post_event(node, EFC_EVT_NODE_SESS_REG_OK, NULL);
+}
+
+static void
+__efc_d_common(const char *funcname, struct efc_sm_ctx *ctx,
+	       enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = NULL;
+	struct efc *efc = NULL;
+
+	node = ctx->app;
+	efc = node->efc;
+
+	switch (evt) {
+	/* Handle shutdown events */
+	case EFC_EVT_SHUTDOWN:
+		efc_log_debug(efc, "[%s] %-20s %-20s\n", node->display_name,
+			      funcname, efc_sm_event_name(evt));
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
+		break;
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+		efc_log_debug(efc, "[%s] %-20s %-20s\n",
+			      node->display_name, funcname,
+				efc_sm_event_name(evt));
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_EXPLICIT_LOGO;
+		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
+		break;
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		efc_log_debug(efc, "[%s] %-20s %-20s\n", node->display_name,
+			      funcname, efc_sm_event_name(evt));
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_IMPLICIT_LOGO;
+		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
+		break;
+
+	default:
+		/* call default event handler common to all nodes */
+		__efc_node_common(funcname, ctx, evt, arg);
+	}
+}
+
+static void
+__efc_d_wait_del_node(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg)
+{
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	/*
+	 * State is entered when a node sends a delete initiator/target call
+	 * to the target-server/initiator-client and needs to wait for that
+	 * work to complete.
+	 */
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		efc_node_hold_frames(node);
+		fallthrough;
+
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		/* These are expected events. */
+		break;
+
+	case EFC_EVT_NODE_DEL_INI_COMPLETE:
+	case EFC_EVT_NODE_DEL_TGT_COMPLETE:
+		/*
+		 * node has either been detached or is in the process
+		 * of being detached,
+		 * call common node's initiate cleanup function
+		 */
+		efc_node_initiate_cleanup(node);
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:
+		/* Can happen as ELS IO IO's complete */
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		break;
+
+	/* ignore shutdown events as we're already in shutdown path */
+	case EFC_EVT_SHUTDOWN:
+		/* have default shutdown event take precedence */
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		fallthrough;
+
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		break;
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		/* don't care about domain_attach_ok */
+		break;
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+static void
+__efc_d_wait_del_ini_tgt(struct efc_sm_ctx *ctx,
+			 enum efc_sm_event evt, void *arg)
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
+		fallthrough;
+
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		/* These are expected events. */
+		break;
+
+	case EFC_EVT_NODE_DEL_INI_COMPLETE:
+	case EFC_EVT_NODE_DEL_TGT_COMPLETE:
+		efc_node_transition(node, __efc_d_wait_del_node, NULL);
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:
+		/* Can happen as ELS IO IO's complete */
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		break;
+
+	/* ignore shutdown events as we're already in shutdown path */
+	case EFC_EVT_SHUTDOWN:
+		/* have default shutdown event take precedence */
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		fallthrough;
+
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		break;
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		/* don't care about domain_attach_ok */
+		break;
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_initiate_shutdown(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg)
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
+		/* assume no wait needed */
+		int rc = EFC_SCSI_CALL_COMPLETE;
+
+		efc_io_alloc_disable(node);
+
+		/* make necessary delete upcall(s) */
+		if (node->init && !node->targ) {
+			efc_log_info(node->efc,
+				     "[%s] delete (initiator) WWPN %s WWNN %s\n",
+				node->display_name,
+				node->wwpn, node->wwnn);
+			efc_node_transition(node,
+					    __efc_d_wait_del_node,
+					     NULL);
+			if (node->nport->enable_tgt)
+				rc = efc->tt.scsi_del_node(efc, node,
+					EFC_SCSI_INITIATOR_DELETED);
+
+			if (rc == EFC_SCSI_CALL_COMPLETE)
+				efc_node_post_event(node,
+					EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);
+
+		} else if (node->targ && !node->init) {
+			efc_log_info(node->efc,
+				     "[%s] delete (target) WWPN %s WWNN %s\n",
+				node->display_name,
+				node->wwpn, node->wwnn);
+			efc_node_transition(node,
+					    __efc_d_wait_del_node,
+					     NULL);
+			if (node->nport->enable_ini)
+				rc = efc->tt.scsi_del_node(efc, node,
+					EFC_SCSI_TARGET_DELETED);
+
+			if (rc == EFC_SCSI_CALL_COMPLETE)
+				efc_node_post_event(node,
+					EFC_EVT_NODE_DEL_TGT_COMPLETE, NULL);
+
+		} else if (node->init && node->targ) {
+			efc_log_info(node->efc,
+				     "[%s] delete (I+T) WWPN %s WWNN %s\n",
+				node->display_name, node->wwpn, node->wwnn);
+			efc_node_transition(node, __efc_d_wait_del_ini_tgt,
+					    NULL);
+			if (node->nport->enable_tgt)
+				rc = efc->tt.scsi_del_node(efc, node,
+						EFC_SCSI_INITIATOR_DELETED);
+
+			if (rc == EFC_SCSI_CALL_COMPLETE)
+				efc_node_post_event(node,
+					EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);
+			/* assume no wait needed */
+			rc = EFC_SCSI_CALL_COMPLETE;
+			if (node->nport->enable_ini)
+				rc = efc->tt.scsi_del_node(efc, node,
+						EFC_SCSI_TARGET_DELETED);
+
+			if (rc == EFC_SCSI_CALL_COMPLETE)
+				efc_node_post_event(node,
+					EFC_EVT_NODE_DEL_TGT_COMPLETE, NULL);
+		}
+
+		/* we've initiated the upcalls as needed, now kick off the node
+		 * detach to precipitate the aborting of outstanding exchanges
+		 * associated with said node
+		 *
+		 * Beware: if we've made upcall(s), we've already transitioned
+		 * to a new state by the time we execute this.
+		 * consider doing this before the upcalls?
+		 */
+		if (node->attached) {
+			/* issue hw node free; don't care if succeeds right
+			 * away or sometime later, will check node->attached
+			 * later in shutdown process
+			 */
+			rc = efc_cmd_node_detach(efc, &node->rnode);
+			if (rc != EFC_HW_RTN_SUCCESS &&
+			    rc != EFC_HW_RTN_SUCCESS_SYNC)
+				node_printf(node,
+					    "Failed freeing HW node, rc=%d\n",
+					rc);
+		}
+
+		/* if neither initiator nor target, proceed to cleanup */
+		if (!node->init && !node->targ) {
+			/*
+			 * node has either been detached or is in
+			 * the process of being detached,
+			 * call common node's initiate cleanup function
+			 */
+			efc_node_initiate_cleanup(node);
+		}
+		break;
+	}
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		/* Ignore, this can happen if an ELS is
+		 * aborted while in a delay/retry state
+		 */
+		break;
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_loop(struct efc_sm_ctx *ctx,
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
+		efc_node_hold_frames(node);
+		break;
+
+	case EFC_EVT_EXIT:
+		efc_node_accept_frames(node);
+		break;
+
+	case EFC_EVT_DOMAIN_ATTACH_OK: {
+		/* send PLOGI automatically if initiator */
+		efc_node_init_device(node, true);
+		break;
+	}
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+efc_send_ls_acc_after_attach(struct efc_node *node,
+			     struct fc_frame_header *hdr,
+			     enum efc_node_send_ls_acc ls)
+{
+	u16 ox_id = be16_to_cpu(hdr->fh_ox_id);
+
+	/* Save the OX_ID for sending LS_ACC sometime later */
+	WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_NONE);
+
+	node->ls_acc_oxid = ox_id;
+	node->send_ls_acc = ls;
+	node->ls_acc_did = ntoh24(hdr->fh_d_id);
+}
+
+void
+efc_process_prli_payload(struct efc_node *node, void *prli)
+{
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp sp;
+	} *pp;
+
+	pp = prli;
+	node->init = (pp->sp.spp_flags & FCP_SPPF_INIT_FCN) != 0;
+	node->targ = (pp->sp.spp_flags & FCP_SPPF_TARG_FCN) != 0;
+}
+
+void
+__efc_d_wait_plogi_acc_cmpl(struct efc_sm_ctx *ctx,
+			    enum efc_sm_event evt, void *arg)
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
+	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
+		WARN_ON(!node->els_cmpl_cnt);
+		node->els_cmpl_cnt--;
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
+		break;
+
+	case EFC_EVT_SRRS_ELS_CMPL_OK:	/* PLOGI ACC completions */
+		WARN_ON(!node->els_cmpl_cnt);
+		node->els_cmpl_cnt--;
+		efc_node_transition(node, __efc_d_port_logged_in, NULL);
+		break;
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_logo_rsp(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg)
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
+	case EFC_EVT_SRRS_ELS_REQ_OK:
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:
+		/* LOGO response received, sent shutdown */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_LOGO,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		node_printf(node,
+			    "LOGO sent (evt=%s), shutdown node\n",
+			efc_sm_event_name(evt));
+		/* sm: / post explicit logout */
+		efc_node_post_event(node, EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
+				    NULL);
+		break;
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+efc_node_init_device(struct efc_node *node, bool send_plogi)
+{
+	node->send_plogi = send_plogi;
+	if ((node->efc->nodedb_mask & EFC_NODEDB_PAUSE_NEW_NODES) &&
+	    (node->rnode.fc_id != FC_FID_DOM_MGR)) {
+		node->nodedb_state = __efc_d_init;
+		efc_node_transition(node, __efc_node_paused, NULL);
+	} else {
+		efc_node_transition(node, __efc_d_init, NULL);
+	}
+}
+
+static void
+efc_d_check_plogi_topology(struct efc_node *node, u32 d_id)
+{
+	switch (node->nport->topology) {
+	case EFC_SPORT_TOPOLOGY_P2P:
+		/* we're not attached and nport is p2p,
+		 * need to attach
+		 */
+		efc_domain_attach(node->nport->domain, d_id);
+		efc_node_transition(node, __efc_d_wait_domain_attach, NULL);
+		break;
+	case EFC_SPORT_TOPOLOGY_FABRIC:
+		/* we're not attached and nport is fabric, domain
+		 * attach should have already been requested as part
+		 * of the fabric state machine, wait for it
+		 */
+		efc_node_transition(node, __efc_d_wait_domain_attach, NULL);
+		break;
+	case EFC_SPORT_TOPOLOGY_UNKNOWN:
+		/* Two possibilities:
+		 * 1. received a PLOGI before our FLOGI has completed
+		 *    (possible since completion comes in on another
+		 *    CQ), thus we don't know what we're connected to
+		 *    yet; transition to a state to wait for the
+		 *    fabric node to tell us;
+		 * 2. PLOGI received before link went down and we
+		 * haven't performed domain attach yet.
+		 * Note: we cannot distinguish between 1. and 2.
+		 * so have to assume PLOGI
+		 * was received after link back up.
+		 */
+		node_printf(node, "received PLOGI, unknown topology did=0x%x\n",
+				  d_id);
+		efc_node_transition(node, __efc_d_wait_topology_notify, NULL);
+		break;
+	default:
+		node_printf(node, "received PLOGI, unexpected topology %d\n",
+				  node->nport->topology);
+	}
+}
+
+void
+__efc_d_init(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg)
+{
+	struct efc_node_cb *cbdata = arg;
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	/*
+	 * This state is entered when a node is instantiated,
+	 * either having been discovered from a name services query,
+	 * or having received a PLOGI/FLOGI.
+	 */
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		if (!node->send_plogi)
+			break;
+		/* only send if we have initiator capability,
+		 * and domain is attached
+		 */
+		if (node->nport->enable_ini &&
+		    node->nport->domain->attached) {
+			efc_send_plogi(node);
+
+			efc_node_transition(node, __efc_d_wait_plogi_rsp, NULL);
+		} else {
+			node_printf(node, "not sending plogi nport.ini=%d,",
+				    node->nport->enable_ini);
+			node_printf(node, "domain attached=%d\n",
+				    node->nport->domain->attached);
+		}
+		break;
+	case EFC_EVT_PLOGI_RCVD: {
+		/* T, or I+T */
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+		int rc;
+
+		efc_node_save_sparms(node, cbdata->payload->dma.virt);
+		efc_send_ls_acc_after_attach(node,
+					     cbdata->header->dma.virt,
+					     EFC_NODE_SEND_LS_ACC_PLOGI);
+
+		/* domain not attached; several possibilities: */
+		if (!node->nport->domain->attached) {
+			efc_d_check_plogi_topology(node, ntoh24(hdr->fh_d_id));
+			break;
+		}
+
+		/* domain already attached */
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK, NULL);
+
+		break;
+	}
+
+	case EFC_EVT_FDISC_RCVD: {
+		__efc_d_common(__func__, ctx, evt, arg);
+		break;
+	}
+
+	case EFC_EVT_FLOGI_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+		u32 d_id = ntoh24(hdr->fh_d_id);
+
+		/* sm: / save sparams, send FLOGI acc */
+		memcpy(node->nport->domain->flogi_service_params,
+		       cbdata->payload->dma.virt,
+		       sizeof(struct fc_els_flogi));
+
+		/* send FC LS_ACC response, override s_id */
+		efc_fabric_set_topology(node, EFC_SPORT_TOPOLOGY_P2P);
+
+		efc_send_flogi_p2p_acc(node, be16_to_cpu(hdr->fh_ox_id), d_id);
+
+		if (efc_p2p_setup(node->nport)) {
+			node_printf(node, "p2p failed, shutting down node\n");
+			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
+			break;
+		}
+
+		efc_node_transition(node,  __efc_p2p_wait_flogi_acc_cmpl, NULL);
+		break;
+	}
+
+	case EFC_EVT_LOGO_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		if (!node->nport->domain->attached) {
+			/* most likely a frame left over from before a link
+			 * down; drop and
+			 * shut node down w/ "explicit logout" so pending
+			 * frames are processed
+			 */
+			node_printf(node, "%s domain not attached, dropping\n",
+				    efc_sm_event_name(evt));
+			efc_node_post_event(node,
+					EFC_EVT_SHUTDOWN_EXPLICIT_LOGO, NULL);
+			break;
+		}
+
+		efc_send_logo_acc(node, be16_to_cpu(hdr->fh_ox_id));
+		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
+		break;
+	}
+
+	case EFC_EVT_PRLI_RCVD:
+	case EFC_EVT_PRLO_RCVD:
+	case EFC_EVT_PDISC_RCVD:
+	case EFC_EVT_ADISC_RCVD:
+	case EFC_EVT_RSCN_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		if (!node->nport->domain->attached) {
+			/* most likely a frame left over from before a link
+			 * down; drop and shut node down w/ "explicit logout"
+			 * so pending frames are processed
+			 */
+			node_printf(node, "%s domain not attached, dropping\n",
+				    efc_sm_event_name(evt));
+
+			efc_node_post_event(node,
+					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
+					    NULL);
+			break;
+		}
+		node_printf(node, "%s received, sending reject\n",
+			    efc_sm_event_name(evt));
+
+		efc_send_ls_rjt(node, be16_to_cpu(hdr->fh_ox_id),
+				ELS_RJT_UNAB, ELS_EXPL_PLOGI_REQD, 0);
+
+		break;
+	}
+
+	case EFC_EVT_FCP_CMD_RCVD: {
+		/* note: problem, we're now expecting an ELS REQ completion
+		 * from both the LOGO and PLOGI
+		 */
+		if (!node->nport->domain->attached) {
+			/* most likely a frame left over from before a
+			 * link down; drop and
+			 * shut node down w/ "explicit logout" so pending
+			 * frames are processed
+			 */
+			node_printf(node, "%s domain not attached, dropping\n",
+				    efc_sm_event_name(evt));
+			efc_node_post_event(node,
+					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
+					    NULL);
+			break;
+		}
+
+		/* Send LOGO */
+		node_printf(node, "FCP_CMND received, send LOGO\n");
+		if (efc_send_logo(node)) {
+			/*
+			 * failed to send LOGO, go ahead and cleanup node
+			 * anyways
+			 */
+			node_printf(node, "Failed to send LOGO\n");
+			efc_node_post_event(node,
+					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
+					    NULL);
+		} else {
+			/* sent LOGO, wait for response */
+			efc_node_transition(node,
+					    __efc_d_wait_logo_rsp, NULL);
+		}
+		break;
+	}
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		/* don't care about domain_attach_ok */
+		break;
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_plogi_rsp(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg)
+{
+	int rc;
+	struct efc_node_cb *cbdata = arg;
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_PLOGI_RCVD: {
+		/* T, or I+T */
+		/* received PLOGI with svc parms, go ahead and attach node
+		 * when PLOGI that was sent ultimately completes, it'll be a
+		 * no-op
+		 *
+		 * If there is an outstanding PLOGI sent, can we set a flag
+		 * to indicate that we don't want to retry it if it times out?
+		 */
+		efc_node_save_sparms(node, cbdata->payload->dma.virt);
+		efc_send_ls_acc_after_attach(node,
+					     cbdata->header->dma.virt,
+				EFC_NODE_SEND_LS_ACC_PLOGI);
+		/* sm: domain->attached / efc_node_attach */
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node,
+					    EFC_EVT_NODE_ATTACH_OK, NULL);
+
+		break;
+	}
+
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
+				EFC_NODE_SEND_LS_ACC_PRLI);
+		efc_node_transition(node, __efc_d_wait_plogi_rsp_recvd_prli,
+				    NULL);
+		break;
+
+	case EFC_EVT_LOGO_RCVD: /* why don't we do a shutdown here?? */
+	case EFC_EVT_PRLO_RCVD:
+	case EFC_EVT_PDISC_RCVD:
+	case EFC_EVT_FDISC_RCVD:
+	case EFC_EVT_ADISC_RCVD:
+	case EFC_EVT_RSCN_RCVD:
+	case EFC_EVT_SCR_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		node_printf(node, "%s received, sending reject\n",
+			    efc_sm_event_name(evt));
+
+		efc_send_ls_rjt(node, be16_to_cpu(hdr->fh_ox_id),
+				ELS_RJT_UNAB, ELS_EXPL_PLOGI_REQD, 0);
+
+		break;
+	}
+
+	case EFC_EVT_SRRS_ELS_REQ_OK:	/* PLOGI response received */
+		/* Completion from PLOGI sent */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		/* sm: / save sparams, efc_node_attach */
+		efc_node_save_sparms(node, cbdata->els_rsp.virt);
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node,
+					    EFC_EVT_NODE_ATTACH_OK, NULL);
+
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:	/* PLOGI response received */
+		/* PLOGI failed, shutdown the node */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+		/* Our PLOGI was rejected, this is ok in some cases */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		break;
+
+	case EFC_EVT_FCP_CMD_RCVD: {
+		/* not logged in yet and outstanding PLOGI so don't send LOGO,
+		 * just drop
+		 */
+		node_printf(node, "FCP_CMND received, drop\n");
+		break;
+	}
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_plogi_rsp_recvd_prli(struct efc_sm_ctx *ctx,
+				  enum efc_sm_event evt, void *arg)
+{
+	int rc;
+	struct efc_node_cb *cbdata = arg;
+	struct efc_node *node = ctx->app;
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
+		 * accepted). At this time, we are not waiting on any other
+		 * unsolicited frames to continue with the login process. Thus,
+		 * it will not hurt to hold frames here.
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
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		/* sm: / save sparams, efc_node_attach */
+		efc_node_save_sparms(node, cbdata->els_rsp.virt);
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK,
+					    NULL);
+
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:	/* PLOGI response received */
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+		/* PLOGI failed, shutdown the node */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
+		break;
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_domain_attach(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg)
+{
+	int rc;
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
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		WARN_ON(!node->nport->domain->attached);
+		/* sm: / efc_node_attach */
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK,
+					    NULL);
+
+		break;
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_topology_notify(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg)
+{
+	int rc;
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
+	case EFC_EVT_SPORT_TOPOLOGY_NOTIFY: {
+		enum efc_nport_topology topology =
+					(enum efc_nport_topology)arg;
+
+		WARN_ON(node->nport->domain->attached);
+
+		WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_PLOGI);
+
+		node_printf(node, "topology notification, topology=%d\n",
+			    topology);
+
+		/* At the time the PLOGI was received, the topology was unknown,
+		 * so we didn't know which node would perform the domain attach:
+		 * 1. The node from which the PLOGI was sent (p2p) or
+		 * 2. The node to which the FLOGI was sent (fabric).
+		 */
+		if (topology == EFC_SPORT_TOPOLOGY_P2P) {
+			/* if this is p2p, need to attach to the domain using
+			 * the d_id from the PLOGI received
+			 */
+			efc_domain_attach(node->nport->domain,
+					  node->ls_acc_did);
+		}
+		/* else, if this is fabric, the domain attach
+		 * should be performed by the fabric node (node sending FLOGI);
+		 * just wait for attach to complete
+		 */
+
+		efc_node_transition(node, __efc_d_wait_domain_attach, NULL);
+		break;
+	}
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		WARN_ON(!node->nport->domain->attached);
+		node_printf(node, "domain attach ok\n");
+		/* sm: / efc_node_attach */
+		rc = efc_node_attach(node);
+		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
+		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
+			efc_node_post_event(node,
+					    EFC_EVT_NODE_ATTACH_OK, NULL);
+
+		break;
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_node_attach(struct efc_sm_ctx *ctx,
+			 enum efc_sm_event evt, void *arg)
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
+	case EFC_EVT_NODE_ATTACH_OK:
+		node->attached = true;
+		switch (node->send_ls_acc) {
+		case EFC_NODE_SEND_LS_ACC_PLOGI: {
+			/* sm: send_plogi_acc is set / send PLOGI acc */
+			/* Normal case for T, or I+T */
+			efc_send_plogi_acc(node, node->ls_acc_oxid);
+			efc_node_transition(node, __efc_d_wait_plogi_acc_cmpl,
+					    NULL);
+			node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
+			node->ls_acc_io = NULL;
+			break;
+		}
+		case EFC_NODE_SEND_LS_ACC_PRLI: {
+			efc_d_send_prli_rsp(node, node->ls_acc_oxid);
+			node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
+			node->ls_acc_io = NULL;
+			break;
+		}
+		case EFC_NODE_SEND_LS_ACC_NONE:
+		default:
+			/* Normal case for I */
+			/* sm: send_plogi_acc is not set / send PLOGI acc */
+			efc_node_transition(node,
+					    __efc_d_port_logged_in, NULL);
+			break;
+		}
+		break;
+
+	case EFC_EVT_NODE_ATTACH_FAIL:
+		/* node attach failed, shutdown the node */
+		node->attached = false;
+		node_printf(node, "node attach failed\n");
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
+		break;
+
+	/* Handle shutdown events */
+	case EFC_EVT_SHUTDOWN:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		efc_node_transition(node, __efc_d_wait_attach_evt_shutdown,
+				    NULL);
+		break;
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_EXPLICIT_LOGO;
+		efc_node_transition(node, __efc_d_wait_attach_evt_shutdown,
+				    NULL);
+		break;
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_IMPLICIT_LOGO;
+		efc_node_transition(node,
+				    __efc_d_wait_attach_evt_shutdown, NULL);
+		break;
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_attach_evt_shutdown(struct efc_sm_ctx *ctx,
+				 enum efc_sm_event evt, void *arg)
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
+	/* wait for any of these attach events and then shutdown */
+	case EFC_EVT_NODE_ATTACH_OK:
+		node->attached = true;
+		node_printf(node, "Attach evt=%s, proceed to shutdown\n",
+			    efc_sm_event_name(evt));
+		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
+		break;
+
+	case EFC_EVT_NODE_ATTACH_FAIL:
+		/* node attach failed, shutdown the node */
+		node->attached = false;
+		node_printf(node, "Attach evt=%s, proceed to shutdown\n",
+			    efc_sm_event_name(evt));
+		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
+		break;
+
+	/* ignore shutdown events as we're already in shutdown path */
+	case EFC_EVT_SHUTDOWN:
+		/* have default shutdown event take precedence */
+		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
+		fallthrough;
+
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		node_printf(node, "%s received\n", efc_sm_event_name(evt));
+		break;
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_port_logged_in(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg)
+{
+	struct efc_node_cb *cbdata = arg;
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		/* Normal case for I or I+T */
+		if (node->nport->enable_ini &&
+		    !(node->rnode.fc_id != FC_FID_DOM_MGR)) {
+			/* sm: if enable_ini / send PRLI */
+			efc_send_prli(node);
+			/* can now expect ELS_REQ_OK/FAIL/RJT */
+		}
+		break;
+
+	case EFC_EVT_FCP_CMD_RCVD: {
+		break;
+	}
+
+	case EFC_EVT_PRLI_RCVD: {
+		/* Normal case for T or I+T */
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+		struct {
+			struct fc_els_prli prli;
+			struct fc_els_spp sp;
+		} *pp;
+
+		pp = cbdata->payload->dma.virt;
+		if (pp->sp.spp_type != FC_TYPE_FCP) {
+			/*Only FCP is supported*/
+			efc_send_ls_rjt(node, be16_to_cpu(hdr->fh_ox_id),
+					ELS_RJT_UNAB, ELS_EXPL_UNSUPR, 0);
+			break;
+		}
+
+		efc_process_prli_payload(node, cbdata->payload->dma.virt);
+		efc_d_send_prli_rsp(node, be16_to_cpu(hdr->fh_ox_id));
+		break;
+	}
+
+	case EFC_EVT_NODE_SESS_REG_OK:
+		if (node->send_ls_acc == EFC_NODE_SEND_LS_ACC_PRLI)
+			efc_send_prli_acc(node, node->ls_acc_oxid);
+
+		node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
+		efc_node_transition(node, __efc_d_device_ready, NULL);
+		break;
+
+	case EFC_EVT_NODE_SESS_REG_FAIL:
+		efc_send_ls_rjt(node, node->ls_acc_oxid, ELS_RJT_UNAB,
+				ELS_EXPL_UNSUPR, 0);
+		node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_OK: {	/* PRLI response */
+		/* Normal case for I or I+T */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PRLI,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		/* sm: / process PRLI payload */
+		efc_process_prli_payload(node, cbdata->els_rsp.virt);
+		efc_node_transition(node, __efc_d_device_ready, NULL);
+		break;
+	}
+
+	case EFC_EVT_SRRS_ELS_REQ_FAIL: {	/* PRLI response failed */
+		/* I, I+T, assume some link failure, shutdown node */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PRLI,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
+		break;
+	}
+
+	case EFC_EVT_SRRS_ELS_REQ_RJT: {
+		/* PRLI rejected by remote
+		 * Normal for I, I+T (connected to an I)
+		 * Node doesn't want to be a target, stay here and wait for a
+		 * PRLI from the remote node
+		 * if it really wants to connect to us as target
+		 */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_PRLI,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		break;
+	}
+
+	case EFC_EVT_SRRS_ELS_CMPL_OK: {
+		/* Normal T, I+T, target-server rejected the process login */
+		/* This would be received only in the case where we sent
+		 * LS_RJT for the PRLI, so
+		 * do nothing.   (note: as T only we could shutdown the node)
+		 */
+		WARN_ON(!node->els_cmpl_cnt);
+		node->els_cmpl_cnt--;
+		break;
+	}
+
+	case EFC_EVT_PLOGI_RCVD: {
+		/*sm: / save sparams, set send_plogi_acc,
+		 *post implicit logout
+		 * Save plogi parameters
+		 */
+		efc_node_save_sparms(node, cbdata->payload->dma.virt);
+		efc_send_ls_acc_after_attach(node,
+					     cbdata->header->dma.virt,
+				EFC_NODE_SEND_LS_ACC_PLOGI);
+
+		/* Restart node attach with new service parameters,
+		 * and send ACC
+		 */
+		efc_node_post_event(node, EFC_EVT_SHUTDOWN_IMPLICIT_LOGO,
+				    NULL);
+		break;
+	}
+
+	case EFC_EVT_LOGO_RCVD: {
+		/* I, T, I+T */
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		node_printf(node, "%s received attached=%d\n",
+			    efc_sm_event_name(evt),
+					node->attached);
+		/* sm: / send LOGO acc */
+		efc_send_logo_acc(node, be16_to_cpu(hdr->fh_ox_id));
+		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
+		break;
+	}
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_logo_acc_cmpl(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg)
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
+	case EFC_EVT_SRRS_ELS_CMPL_OK:
+	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
+		/* sm: / post explicit logout */
+		WARN_ON(!node->els_cmpl_cnt);
+		node->els_cmpl_cnt--;
+		efc_node_post_event(node,
+				    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO, NULL);
+		break;
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_device_ready(struct efc_sm_ctx *ctx,
+		     enum efc_sm_event evt, void *arg)
+{
+	struct efc_node_cb *cbdata = arg;
+	struct efc_node *node = ctx->app;
+	struct efc *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	if (evt != EFC_EVT_FCP_CMD_RCVD)
+		node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		node->fcp_enabled = true;
+		if (node->targ) {
+			efc_log_info(efc,
+				     "[%s] found (target) WWPN %s WWNN %s\n",
+				node->display_name,
+				node->wwpn, node->wwnn);
+			if (node->nport->enable_ini)
+				efc->tt.scsi_new_node(efc, node);
+		}
+		break;
+
+	case EFC_EVT_EXIT:
+		node->fcp_enabled = false;
+		break;
+
+	case EFC_EVT_PLOGI_RCVD: {
+		/* sm: / save sparams, set send_plogi_acc, post implicit
+		 * logout
+		 * Save plogi parameters
+		 */
+		efc_node_save_sparms(node, cbdata->payload->dma.virt);
+		efc_send_ls_acc_after_attach(node,
+					     cbdata->header->dma.virt,
+				EFC_NODE_SEND_LS_ACC_PLOGI);
+
+		/*
+		 * Restart node attach with new service parameters,
+		 * and send ACC
+		 */
+		efc_node_post_event(node,
+				    EFC_EVT_SHUTDOWN_IMPLICIT_LOGO, NULL);
+		break;
+	}
+
+	case EFC_EVT_PRLI_RCVD: {
+		/* T, I+T: remote initiator is slow to get started */
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+		struct {
+			struct fc_els_prli prli;
+			struct fc_els_spp sp;
+		} *pp;
+
+		pp = cbdata->payload->dma.virt;
+		if (pp->sp.spp_type != FC_TYPE_FCP) {
+			/*Only FCP is supported*/
+			efc_send_ls_rjt(node, be16_to_cpu(hdr->fh_ox_id),
+					ELS_RJT_UNAB, ELS_EXPL_UNSUPR, 0);
+			break;
+		}
+
+		efc_process_prli_payload(node, cbdata->payload->dma.virt);
+		efc_send_prli_acc(node, be16_to_cpu(hdr->fh_ox_id));
+		break;
+	}
+
+	case EFC_EVT_PRLO_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+		/* sm: / send PRLO acc */
+		efc_send_prlo_acc(node, be16_to_cpu(hdr->fh_ox_id));
+		/* need implicit logout? */
+		break;
+	}
+
+	case EFC_EVT_LOGO_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		node_printf(node, "%s received attached=%d\n",
+			    efc_sm_event_name(evt), node->attached);
+		/* sm: / send LOGO acc */
+		efc_send_logo_acc(node, be16_to_cpu(hdr->fh_ox_id));
+		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
+		break;
+	}
+
+	case EFC_EVT_ADISC_RCVD: {
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+		/* sm: / send ADISC acc */
+		efc_send_adisc_acc(node, be16_to_cpu(hdr->fh_ox_id));
+		break;
+	}
+
+	case EFC_EVT_ABTS_RCVD:
+		/* sm: / process ABTS */
+		efc_log_err(efc, "Unexpected event:%s\n",
+					efc_sm_event_name(evt));
+		break;
+
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+		break;
+
+	case EFC_EVT_NODE_REFOUND:
+		break;
+
+	case EFC_EVT_NODE_MISSING:
+		if (node->nport->enable_rscn)
+			efc_node_transition(node, __efc_d_device_gone, NULL);
+
+		break;
+
+	case EFC_EVT_SRRS_ELS_CMPL_OK:
+		/* T, or I+T, PRLI accept completed ok */
+		WARN_ON(!node->els_cmpl_cnt);
+		node->els_cmpl_cnt--;
+		break;
+
+	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
+		/* T, or I+T, PRLI accept failed to complete */
+		WARN_ON(!node->els_cmpl_cnt);
+		node->els_cmpl_cnt--;
+		node_printf(node, "Failed to send PRLI LS_ACC\n");
+		break;
+
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_device_gone(struct efc_sm_ctx *ctx,
+		    enum efc_sm_event evt, void *arg)
+{
+	struct efc_node_cb *cbdata = arg;
+	struct efc_node *node = ctx->app;
+	struct efc *efc = node->efc;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_ENTER: {
+		int rc = EFC_SCSI_CALL_COMPLETE;
+		int rc_2 = EFC_SCSI_CALL_COMPLETE;
+		static char const *labels[] = {"none", "initiator", "target",
+							"initiator+target"};
+
+		efc_log_info(efc, "[%s] missing (%s)    WWPN %s WWNN %s\n",
+			     node->display_name,
+				labels[(node->targ << 1) | (node->init)],
+						node->wwpn, node->wwnn);
+
+		switch (efc_node_get_enable(node)) {
+		case EFC_NODE_ENABLE_T_TO_T:
+		case EFC_NODE_ENABLE_I_TO_T:
+		case EFC_NODE_ENABLE_IT_TO_T:
+			rc = efc->tt.scsi_del_node(efc, node,
+				EFC_SCSI_TARGET_MISSING);
+			break;
+
+		case EFC_NODE_ENABLE_T_TO_I:
+		case EFC_NODE_ENABLE_I_TO_I:
+		case EFC_NODE_ENABLE_IT_TO_I:
+			rc = efc->tt.scsi_del_node(efc, node,
+				EFC_SCSI_INITIATOR_MISSING);
+			break;
+
+		case EFC_NODE_ENABLE_T_TO_IT:
+			rc = efc->tt.scsi_del_node(efc, node,
+				EFC_SCSI_INITIATOR_MISSING);
+			break;
+
+		case EFC_NODE_ENABLE_I_TO_IT:
+			rc = efc->tt.scsi_del_node(efc, node,
+						  EFC_SCSI_TARGET_MISSING);
+			break;
+
+		case EFC_NODE_ENABLE_IT_TO_IT:
+			rc = efc->tt.scsi_del_node(efc, node,
+				EFC_SCSI_INITIATOR_MISSING);
+			rc_2 = efc->tt.scsi_del_node(efc, node,
+				EFC_SCSI_TARGET_MISSING);
+			break;
+
+		default:
+			rc = EFC_SCSI_CALL_COMPLETE;
+			break;
+		}
+
+		if (rc == EFC_SCSI_CALL_COMPLETE &&
+		    rc_2 == EFC_SCSI_CALL_COMPLETE)
+			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
+
+		break;
+	}
+	case EFC_EVT_NODE_REFOUND:
+		/* two approaches, reauthenticate with PLOGI/PRLI, or ADISC */
+
+		/* reauthenticate with PLOGI/PRLI */
+		/* efc_node_transition(node, __efc_d_discovered, NULL); */
+
+		/* reauthenticate with ADISC */
+		/* sm: / send ADISC */
+		efc_send_adisc(node);
+		efc_node_transition(node, __efc_d_wait_adisc_rsp, NULL);
+		break;
+
+	case EFC_EVT_PLOGI_RCVD: {
+		/* sm: / save sparams, set send_plogi_acc, post implicit
+		 * logout
+		 * Save plogi parameters
+		 */
+		efc_node_save_sparms(node, cbdata->payload->dma.virt);
+		efc_send_ls_acc_after_attach(node,
+					     cbdata->header->dma.virt,
+				EFC_NODE_SEND_LS_ACC_PLOGI);
+
+		/*
+		 * Restart node attach with new service parameters, and send
+		 * ACC
+		 */
+		efc_node_post_event(node, EFC_EVT_SHUTDOWN_IMPLICIT_LOGO,
+				    NULL);
+		break;
+	}
+
+	case EFC_EVT_FCP_CMD_RCVD: {
+		/* most likely a stale frame (received prior to link down),
+		 * if attempt to send LOGO, will probably timeout and eat
+		 * up 20s; thus, drop FCP_CMND
+		 */
+		node_printf(node, "FCP_CMND received, drop\n");
+		break;
+	}
+	case EFC_EVT_LOGO_RCVD: {
+		/* I, T, I+T */
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		node_printf(node, "%s received attached=%d\n",
+			    efc_sm_event_name(evt), node->attached);
+		/* sm: / send LOGO acc */
+		efc_send_logo_acc(node, be16_to_cpu(hdr->fh_ox_id));
+		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
+		break;
+	}
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
+
+void
+__efc_d_wait_adisc_rsp(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg)
+{
+	struct efc_node_cb *cbdata = arg;
+	struct efc_node *node = ctx->app;
+
+	efc_node_evt_set(ctx, evt, __func__);
+
+	node_sm_trace();
+
+	switch (evt) {
+	case EFC_EVT_SRRS_ELS_REQ_OK:
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_ADISC,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		efc_node_transition(node, __efc_d_device_ready, NULL);
+		break;
+
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+		/* received an LS_RJT, in this case, send shutdown
+		 * (explicit logo) event which will unregister the node,
+		 * and start over with PLOGI
+		 */
+		if (efc_node_check_els_req(ctx, evt, arg, ELS_ADISC,
+					   __efc_d_common, __func__))
+			return;
+
+		WARN_ON(!node->els_req_cnt);
+		node->els_req_cnt--;
+		/* sm: / post explicit logout */
+		efc_node_post_event(node,
+				    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
+				     NULL);
+		break;
+
+	case EFC_EVT_LOGO_RCVD: {
+		/* In this case, we have the equivalent of an LS_RJT for
+		 * the ADISC, so we need to abort the ADISC, and re-login
+		 * with PLOGI
+		 */
+		/* sm: / request abort, send LOGO acc */
+		struct fc_frame_header *hdr = cbdata->header->dma.virt;
+
+		node_printf(node, "%s received attached=%d\n",
+			    efc_sm_event_name(evt), node->attached);
+
+		efc_send_logo_acc(node, be16_to_cpu(hdr->fh_ox_id));
+		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
+		break;
+	}
+	default:
+		__efc_d_common(__func__, ctx, evt, arg);
+	}
+}
diff --git a/drivers/scsi/elx/libefc/efc_device.h b/drivers/scsi/elx/libefc/efc_device.h
new file mode 100644
index 000000000000..4c03ee566504
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_device.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * Node state machine functions for remote device node sm
+ */
+
+#ifndef __EFCT_DEVICE_H__
+#define __EFCT_DEVICE_H__
+void
+efc_node_init_device(struct efc_node *node, bool send_plogi);
+void
+efc_process_prli_payload(struct efc_node *node,
+			 void *prli);
+void
+efc_d_send_prli_rsp(struct efc_node *node, uint16_t ox_id);
+void
+efc_send_ls_acc_after_attach(struct efc_node *node,
+			     struct fc_frame_header *hdr,
+			     enum efc_node_send_ls_acc ls);
+void
+__efc_d_wait_loop(struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_plogi_acc_cmpl(struct efc_sm_ctx *ctx,
+			    enum efc_sm_event evt, void *arg);
+void
+__efc_d_init(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_plogi_rsp(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_plogi_rsp_recvd_prli(struct efc_sm_ctx *ctx,
+				  enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_domain_attach(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_topology_notify(struct efc_sm_ctx *ctx,
+			     enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_node_attach(struct efc_sm_ctx *ctx,
+			 enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_attach_evt_shutdown(struct efc_sm_ctx *ctx,
+				 enum efc_sm_event evt, void *arg);
+void
+__efc_d_initiate_shutdown(struct efc_sm_ctx *ctx,
+			  enum efc_sm_event evt, void *arg);
+void
+__efc_d_port_logged_in(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_logo_acc_cmpl(struct efc_sm_ctx *ctx,
+			   enum efc_sm_event evt, void *arg);
+void
+__efc_d_device_ready(struct efc_sm_ctx *ctx,
+		     enum efc_sm_event evt, void *arg);
+void
+__efc_d_device_gone(struct efc_sm_ctx *ctx,
+		    enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_adisc_rsp(struct efc_sm_ctx *ctx,
+		       enum efc_sm_event evt, void *arg);
+void
+__efc_d_wait_logo_rsp(struct efc_sm_ctx *ctx,
+		      enum efc_sm_event evt, void *arg);
+
+#endif /* __EFCT_DEVICE_H__ */
-- 
2.26.2


--00000000000066c24d05b18126aa
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgH7Q/pPb3gvDxL0ji
5fGKOJdRTkursg3+hu99cm2BrLQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjE2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIa249xILJh1PBzf2PZjCr8tif1niOw9zZZl
9GjI7dHQ7JmzmaUrsMPBBItauAsOYeDXcvoCZ4y/Ztnm6aessKqBk7EG4Ab+ngR72hrEC3gb/l8x
bdlOy1DxhVdlJEEI4cfMW5wJb5U8tov8nnF8G5mA7dTBg/kJnPTUsgxlhVXd2sEPnt3gkh0Zyr9I
RRsfcpk9gRBiPLsE3b9rPv602u2lxs4MqngSbvtVf+wOGPh+UVvi7jwq7SgD0J9NLn1wkGXdnjKz
MXg7GdTGP8yGsdrOr5c/YOfzTQuvWUTtXYtdh/z/g8LFKxgMJx3r7ddOvjlFZb9YUvyAM+5q6Obq
28Y=
--00000000000066c24d05b18126aa--
