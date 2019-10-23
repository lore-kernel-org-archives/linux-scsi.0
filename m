Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4BCCA9EBE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6443B20679
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxfER6oZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406229AbfJWV4Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40660 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406008AbfJWV4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id o28so23697903wro.7
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=049hx9dPxSNNF5lkywJWZB1N/Cg8nmFLzeFlN0HDUf8=;
        b=NxfER6oZCQnRtQAfnvr2KW7bE8SnaD9QKLZ+aSaVTCGmj6VCSRQlinlJqye65E7Ov5
         Bd/6ZOkJWLRh6PRePYA85BUiykwt0pOPWhnMBi1Ilo0mmGE8E7eCU/6vx+Rw5G4n3pIV
         SC3FN7/WvWpj42ZakT4emQHfYgpcDvHhS2r+SGRAnQ+GyKM8dG/g7rmXPGdosNuR8QZb
         Drz+6Il1CnS82DBFTXwhAE4MfWDp/puKgnMuwePPQ4HQmY3ErHuOIQK8/hL994Zo1blE
         os/iZqminHNr2T+UHD/QYkj8wbth+5OFGdjWkJQrA1vGA5ojZTVk+nex5QtIryicU18y
         69PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=049hx9dPxSNNF5lkywJWZB1N/Cg8nmFLzeFlN0HDUf8=;
        b=a32BIB9/DQhu/hiVWrIdb6R8RMc2L9pu9KgOqFVj4mK5R0d9XLj6pNyFObUTaXHUPU
         OYsaB0nDzbip6cZnCIofJFJejt7dylWMaOLH9O2TwWT01DPp+h6V49QbaODAiTxb9OZc
         VNLlnrPp3ngK/GZCkyLadLR25NrAOck1+w80N8khn5pibPWBpD2rMkawzxhH/vPTEVrY
         Qzr8Bj4ukvUdhpwYyLlELy/NfVyd2fRER1Xvoop5T3GDMPMOztONQFWvhPfOHx4ONQDB
         8w7/OTpamCmQQCJUvTxbcfxFFaubSldO1ye0acKXchKyXGpsyjb5aqP4C+9X0IIdv0mA
         u2RA==
X-Gm-Message-State: APjAAAVxHSniD9tIxkfYKmkgmZkBaRd+rKOvbf/tri7jFNlSYkUCijJO
        PqzsogoTXENp0UqjT5GLoevYfX/J
X-Google-Smtp-Source: APXvYqxYcmc0w6Yy4R/j1fwMggokvX/yTgaDXrzYoRQIW7oLoPefZIZnoHl911UCnFVq3rVde+yUIQ==
X-Received: by 2002:a5d:44c6:: with SMTP id z6mr707607wrr.313.1571867780369;
        Wed, 23 Oct 2019 14:56:20 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:20 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 08/32] elx: libefc: Generic state machine framework
Date:   Wed, 23 Oct 2019 14:55:33 -0700
Message-Id: <20191023215557.12581-9-jsmart2021@gmail.com>
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

This patch starts the population of the libefc library.
The library will contain common tasks usable by a target or initiator
driver. The library will also contain a FC discovery state machine
interface.

This patch creates the library directory and adds definitions
for the discovery state machine interface.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc/efc_sm.c | 275 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_sm.h | 171 ++++++++++++++++++++++++
 2 files changed, 446 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h

diff --git a/drivers/scsi/elx/libefc/efc_sm.c b/drivers/scsi/elx/libefc/efc_sm.c
new file mode 100644
index 000000000000..4c2b844a23df
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * Generic state machine framework.
+ */
+#include "efc.h"
+#include "efc_sm.h"
+
+const char *efc_sm_id[] = {
+	"common",
+	"domain",
+	"login"
+};
+
+/**
+ * @brief Post an event to a context.
+ *
+ * @param ctx State machine context
+ * @param evt Event to post
+ * @param data Event-specific data (if any)
+ *
+ * @return 0 if successfully posted event; -1 if state machine
+ *         is disabled
+ */
+int
+efc_sm_post_event(struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *data)
+{
+	if (ctx->current_state) {
+		ctx->current_state(ctx, evt, data);
+		return 0;
+	} else {
+		return -1;
+	}
+}
+
+/**
+ * @brief Transition to a new state.
+ */
+void
+efc_sm_transition(struct efc_sm_ctx_s *ctx,
+		  void *(*state)(struct efc_sm_ctx_s *,
+				 enum efc_sm_event_e, void *), void *data)
+
+{
+	if (ctx->current_state == state) {
+		efc_sm_post_event(ctx, EFC_EVT_REENTER, data);
+	} else {
+		efc_sm_post_event(ctx, EFC_EVT_EXIT, data);
+		ctx->current_state = state;
+		efc_sm_post_event(ctx, EFC_EVT_ENTER, data);
+	}
+}
+
+/**
+ * @brief Disable further state machine processing.
+ */
+void
+efc_sm_disable(struct efc_sm_ctx_s *ctx)
+{
+	ctx->current_state = NULL;
+}
+
+const char *efc_sm_event_name(enum efc_sm_event_e evt)
+{
+	switch (evt) {
+	case EFC_EVT_ENTER:
+		return "EFC_EVT_ENTER";
+	case EFC_EVT_REENTER:
+		return "EFC_EVT_REENTER";
+	case EFC_EVT_EXIT:
+		return "EFC_EVT_EXIT";
+	case EFC_EVT_SHUTDOWN:
+		return "EFC_EVT_SHUTDOWN";
+	case EFC_EVT_RESPONSE:
+		return "EFC_EVT_RESPONSE";
+	case EFC_EVT_RESUME:
+		return "EFC_EVT_RESUME";
+	case EFC_EVT_TIMER_EXPIRED:
+		return "EFC_EVT_TIMER_EXPIRED";
+	case EFC_EVT_ERROR:
+		return "EFC_EVT_ERROR";
+	case EFC_EVT_SRRS_ELS_REQ_OK:
+		return "EFC_EVT_SRRS_ELS_REQ_OK";
+	case EFC_EVT_SRRS_ELS_CMPL_OK:
+		return "EFC_EVT_SRRS_ELS_CMPL_OK";
+	case EFC_EVT_SRRS_ELS_REQ_FAIL:
+		return "EFC_EVT_SRRS_ELS_REQ_FAIL";
+	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
+		return "EFC_EVT_SRRS_ELS_CMPL_FAIL";
+	case EFC_EVT_SRRS_ELS_REQ_RJT:
+		return "EFC_EVT_SRRS_ELS_REQ_RJT";
+	case EFC_EVT_NODE_ATTACH_OK:
+		return "EFC_EVT_NODE_ATTACH_OK";
+	case EFC_EVT_NODE_ATTACH_FAIL:
+		return "EFC_EVT_NODE_ATTACH_FAIL";
+	case EFC_EVT_NODE_FREE_OK:
+		return "EFC_EVT_NODE_FREE_OK";
+	case EFC_EVT_ELS_REQ_TIMEOUT:
+		return "EFC_EVT_ELS_REQ_TIMEOUT";
+	case EFC_EVT_ELS_REQ_ABORTED:
+		return "EFC_EVT_ELS_REQ_ABORTED";
+	case EFC_EVT_ABORT_ELS:
+		return "EFC_EVT_ABORT_ELS";
+	case EFC_EVT_ELS_ABORT_CMPL:
+		return "EFC_EVT_ELS_ABORT_CMPL";
+
+	case EFC_EVT_DOMAIN_FOUND:
+		return "EFC_EVT_DOMAIN_FOUND";
+	case EFC_EVT_DOMAIN_ALLOC_OK:
+		return "EFC_EVT_DOMAIN_ALLOC_OK";
+	case EFC_EVT_DOMAIN_ALLOC_FAIL:
+		return "EFC_EVT_DOMAIN_ALLOC_FAIL";
+	case EFC_EVT_DOMAIN_REQ_ATTACH:
+		return "EFC_EVT_DOMAIN_REQ_ATTACH";
+	case EFC_EVT_DOMAIN_ATTACH_OK:
+		return "EFC_EVT_DOMAIN_ATTACH_OK";
+	case EFC_EVT_DOMAIN_ATTACH_FAIL:
+		return "EFC_EVT_DOMAIN_ATTACH_FAIL";
+	case EFC_EVT_DOMAIN_LOST:
+		return "EFC_EVT_DOMAIN_LOST";
+	case EFC_EVT_DOMAIN_FREE_OK:
+		return "EFC_EVT_DOMAIN_FREE_OK";
+	case EFC_EVT_DOMAIN_FREE_FAIL:
+		return "EFC_EVT_DOMAIN_FREE_FAIL";
+	case EFC_EVT_HW_DOMAIN_REQ_ATTACH:
+		return "EFC_EVT_HW_DOMAIN_REQ_ATTACH";
+	case EFC_EVT_HW_DOMAIN_REQ_FREE:
+		return "EFC_EVT_HW_DOMAIN_REQ_FREE";
+	case EFC_EVT_ALL_CHILD_NODES_FREE:
+		return "EFC_EVT_ALL_CHILD_NODES_FREE";
+
+	case EFC_EVT_SPORT_ALLOC_OK:
+		return "EFC_EVT_SPORT_ALLOC_OK";
+	case EFC_EVT_SPORT_ALLOC_FAIL:
+		return "EFC_EVT_SPORT_ALLOC_FAIL";
+	case EFC_EVT_SPORT_ATTACH_OK:
+		return "EFC_EVT_SPORT_ATTACH_OK";
+	case EFC_EVT_SPORT_ATTACH_FAIL:
+		return "EFC_EVT_SPORT_ATTACH_FAIL";
+	case EFC_EVT_SPORT_FREE_OK:
+		return "EFC_EVT_SPORT_FREE_OK";
+	case EFC_EVT_SPORT_FREE_FAIL:
+		return "EFC_EVT_SPORT_FREE_FAIL";
+	case EFC_EVT_SPORT_TOPOLOGY_NOTIFY:
+		return "EFC_EVT_SPORT_TOPOLOGY_NOTIFY";
+	case EFC_EVT_HW_PORT_ALLOC_OK:
+		return "EFC_EVT_HW_PORT_ALLOC_OK";
+	case EFC_EVT_HW_PORT_ALLOC_FAIL:
+		return "EFC_EVT_HW_PORT_ALLOC_FAIL";
+	case EFC_EVT_HW_PORT_ATTACH_OK:
+		return "EFC_EVT_HW_PORT_ATTACH_OK";
+	case EFC_EVT_HW_PORT_REQ_ATTACH:
+		return "EFC_EVT_HW_PORT_REQ_ATTACH";
+	case EFC_EVT_HW_PORT_REQ_FREE:
+		return "EFC_EVT_HW_PORT_REQ_FREE";
+	case EFC_EVT_HW_PORT_FREE_OK:
+		return "EFC_EVT_HW_PORT_FREE_OK";
+
+	case EFC_EVT_NODE_FREE_FAIL:
+		return "EFC_EVT_NODE_FREE_FAIL";
+
+	case EFC_EVT_ABTS_RCVD:
+		return "EFC_EVT_ABTS_RCVD";
+
+	case EFC_EVT_NODE_MISSING:
+		return "EFC_EVT_NODE_MISSING";
+	case EFC_EVT_NODE_REFOUND:
+		return "EFC_EVT_NODE_REFOUND";
+	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
+		return "EFC_EVT_SHUTDOWN_IMPLICIT_LOGO";
+	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
+		return "EFC_EVT_SHUTDOWN_EXPLICIT_LOGO";
+
+	case EFC_EVT_ELS_FRAME:
+		return "EFC_EVT_ELS_FRAME";
+	case EFC_EVT_PLOGI_RCVD:
+		return "EFC_EVT_PLOGI_RCVD";
+	case EFC_EVT_FLOGI_RCVD:
+		return "EFC_EVT_FLOGI_RCVD";
+	case EFC_EVT_LOGO_RCVD:
+		return "EFC_EVT_LOGO_RCVD";
+	case EFC_EVT_PRLI_RCVD:
+		return "EFC_EVT_PRLI_RCVD";
+	case EFC_EVT_PRLO_RCVD:
+		return "EFC_EVT_PRLO_RCVD";
+	case EFC_EVT_PDISC_RCVD:
+		return "EFC_EVT_PDISC_RCVD";
+	case EFC_EVT_FDISC_RCVD:
+		return "EFC_EVT_FDISC_RCVD";
+	case EFC_EVT_ADISC_RCVD:
+		return "EFC_EVT_ADISC_RCVD";
+	case EFC_EVT_RSCN_RCVD:
+		return "EFC_EVT_RSCN_RCVD";
+	case EFC_EVT_SCR_RCVD:
+		return "EFC_EVT_SCR_RCVD";
+	case EFC_EVT_ELS_RCVD:
+		return "EFC_EVT_ELS_RCVD";
+	case EFC_EVT_LAST:
+		return "EFC_EVT_LAST";
+	case EFC_EVT_FCP_CMD_RCVD:
+		return "EFC_EVT_FCP_CMD_RCVD";
+
+	case EFC_EVT_RFT_ID_RCVD:
+		return "EFC_EVT_RFT_ID_RCVD";
+	case EFC_EVT_RFF_ID_RCVD:
+		return "EFC_EVT_RFF_ID_RCVD";
+	case EFC_EVT_GNN_ID_RCVD:
+		return "EFC_EVT_GNN_ID_RCVD";
+	case EFC_EVT_GPN_ID_RCVD:
+		return "EFC_EVT_GPN_ID_RCVD";
+	case EFC_EVT_GFPN_ID_RCVD:
+		return "EFC_EVT_GFPN_ID_RCVD";
+	case EFC_EVT_GFF_ID_RCVD:
+		return "EFC_EVT_GFF_ID_RCVD";
+	case EFC_EVT_GID_FT_RCVD:
+		return "EFC_EVT_GID_FT_RCVD";
+	case EFC_EVT_GID_PT_RCVD:
+		return "EFC_EVT_GID_PT_RCVD";
+	case EFC_EVT_RPN_ID_RCVD:
+		return "EFC_EVT_RPN_ID_RCVD";
+	case EFC_EVT_RNN_ID_RCVD:
+		return "EFC_EVT_RNN_ID_RCVD";
+	case EFC_EVT_RCS_ID_RCVD:
+		return "EFC_EVT_RCS_ID_RCVD";
+	case EFC_EVT_RSNN_NN_RCVD:
+		return "EFC_EVT_RSNN_NN_RCVD";
+	case EFC_EVT_RSPN_ID_RCVD:
+		return "EFC_EVT_RSPN_ID_RCVD";
+	case EFC_EVT_RHBA_RCVD:
+		return "EFC_EVT_RHBA_RCVD";
+	case EFC_EVT_RPA_RCVD:
+		return "EFC_EVT_RPA_RCVD";
+
+	case EFC_EVT_GIDPT_DELAY_EXPIRED:
+		return "EFC_EVT_GIDPT_DELAY_EXPIRED";
+
+	case EFC_EVT_ABORT_IO:
+		return "EFC_EVT_ABORT_IO";
+	case EFC_EVT_ABORT_IO_NO_RESP:
+		return "EFC_EVT_ABORT_IO_NO_RESP";
+	case EFC_EVT_IO_CMPL:
+		return "EFC_EVT_IO_CMPL";
+	case EFC_EVT_IO_CMPL_ERRORS:
+		return "EFC_EVT_IO_CMPL_ERRORS";
+	case EFC_EVT_RESP_CMPL:
+		return "EFC_EVT_RESP_CMPL";
+	case EFC_EVT_ABORT_CMPL:
+		return "EFC_EVT_ABORT_CMPL";
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+		return "EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY";
+	case EFC_EVT_NODE_DEL_INI_COMPLETE:
+		return "EFC_EVT_NODE_DEL_INI_COMPLETE";
+	case EFC_EVT_NODE_DEL_TGT_COMPLETE:
+		return "EFC_EVT_NODE_DEL_TGT_COMPLETE";
+	case EFC_EVT_IO_ABORTED_BY_TMF:
+		return "EFC_EVT_IO_ABORTED_BY_TMF";
+	case EFC_EVT_IO_ABORT_IGNORED:
+		return "EFC_EVT_IO_ABORT_IGNORED";
+	case EFC_EVT_IO_FIRST_BURST:
+		return "EFC_EVT_IO_FIRST_BURST";
+	case EFC_EVT_IO_FIRST_BURST_ERR:
+		return "EFC_EVT_IO_FIRST_BURST_ERR";
+	case EFC_EVT_IO_FIRST_BURST_ABORTED:
+		return "EFC_EVT_IO_FIRST_BURST_ABORTED";
+
+	default:
+		break;
+	}
+	return "unknown";
+}
diff --git a/drivers/scsi/elx/libefc/efc_sm.h b/drivers/scsi/elx/libefc/efc_sm.h
new file mode 100644
index 000000000000..4e9370a8e362
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.h
@@ -0,0 +1,171 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ *
+ */
+
+/**
+ * Generic state machine framework declarations.
+ */
+
+#ifndef _EFC_SM_H
+#define _EFC_SM_H
+
+/**
+ * State Machine (SM) IDs.
+ */
+enum {
+	EFC_SM_COMMON = 0,
+	EFC_SM_DOMAIN,
+	EFC_SM_PORT,
+	EFC_SM_LOGIN,
+	EFC_SM_LAST
+};
+
+#define EFC_SM_EVENT_SHIFT		24
+#define EFC_SM_EVENT_START(id)		((id) << EFC_SM_EVENT_SHIFT)
+
+/* String format of the above enums. */
+extern const char *efc_sm_id[];
+
+struct efc_sm_ctx_s;
+
+/*
+ * State Machine events.
+ */
+enum efc_sm_event_e {
+	/* Common Events */
+	EFC_EVT_ENTER = EFC_SM_EVENT_START(EFC_SM_COMMON),
+	EFC_EVT_REENTER,
+	EFC_EVT_EXIT,
+	EFC_EVT_SHUTDOWN,
+	EFC_EVT_ALL_CHILD_NODES_FREE,
+	EFC_EVT_RESUME,
+	EFC_EVT_TIMER_EXPIRED,
+
+	/* Domain Events */
+	EFC_EVT_RESPONSE = EFC_SM_EVENT_START(EFC_SM_DOMAIN),
+	EFC_EVT_ERROR,
+
+	EFC_EVT_DOMAIN_FOUND,
+	EFC_EVT_DOMAIN_ALLOC_OK,
+	EFC_EVT_DOMAIN_ALLOC_FAIL,
+	EFC_EVT_DOMAIN_REQ_ATTACH,
+	EFC_EVT_DOMAIN_ATTACH_OK,
+	EFC_EVT_DOMAIN_ATTACH_FAIL,
+	EFC_EVT_DOMAIN_LOST,
+	EFC_EVT_DOMAIN_FREE_OK,
+	EFC_EVT_DOMAIN_FREE_FAIL,
+	EFC_EVT_HW_DOMAIN_REQ_ATTACH,
+	EFC_EVT_HW_DOMAIN_REQ_FREE,
+
+	/* Sport Events */
+	EFC_EVT_SPORT_ALLOC_OK = EFC_SM_EVENT_START(EFC_SM_PORT),
+	EFC_EVT_SPORT_ALLOC_FAIL,
+	EFC_EVT_SPORT_ATTACH_OK,
+	EFC_EVT_SPORT_ATTACH_FAIL,
+	EFC_EVT_SPORT_FREE_OK,
+	EFC_EVT_SPORT_FREE_FAIL,
+	EFC_EVT_SPORT_TOPOLOGY_NOTIFY,
+	EFC_EVT_HW_PORT_ALLOC_OK,
+	EFC_EVT_HW_PORT_ALLOC_FAIL,
+	EFC_EVT_HW_PORT_ATTACH_OK,
+	EFC_EVT_HW_PORT_REQ_ATTACH,
+	EFC_EVT_HW_PORT_REQ_FREE,
+	EFC_EVT_HW_PORT_FREE_OK,
+
+	/* Login Events */
+	EFC_EVT_SRRS_ELS_REQ_OK = EFC_SM_EVENT_START(EFC_SM_LOGIN),
+	EFC_EVT_SRRS_ELS_CMPL_OK,
+	EFC_EVT_SRRS_ELS_REQ_FAIL,
+	EFC_EVT_SRRS_ELS_CMPL_FAIL,
+	EFC_EVT_SRRS_ELS_REQ_RJT,
+	EFC_EVT_NODE_ATTACH_OK,
+	EFC_EVT_NODE_ATTACH_FAIL,
+	EFC_EVT_NODE_FREE_OK,
+	EFC_EVT_NODE_FREE_FAIL,
+	EFC_EVT_ELS_FRAME,
+	EFC_EVT_ELS_REQ_TIMEOUT,
+	EFC_EVT_ELS_REQ_ABORTED,
+	/* request an ELS IO be aborted */
+	EFC_EVT_ABORT_ELS,
+	/* ELS abort process complete */
+	EFC_EVT_ELS_ABORT_CMPL,
+
+	EFC_EVT_ABTS_RCVD,
+
+	/* node is not in the GID_PT payload */
+	EFC_EVT_NODE_MISSING,
+	/* node is allocated and in the GID_PT payload */
+	EFC_EVT_NODE_REFOUND,
+	/* node shutting down due to PLOGI recvd (implicit logo) */
+	EFC_EVT_SHUTDOWN_IMPLICIT_LOGO,
+	/* node shutting down due to LOGO recvd/sent (explicit logo) */
+	EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
+
+	EFC_EVT_PLOGI_RCVD,
+	EFC_EVT_FLOGI_RCVD,
+	EFC_EVT_LOGO_RCVD,
+	EFC_EVT_PRLI_RCVD,
+	EFC_EVT_PRLO_RCVD,
+	EFC_EVT_PDISC_RCVD,
+	EFC_EVT_FDISC_RCVD,
+	EFC_EVT_ADISC_RCVD,
+	EFC_EVT_RSCN_RCVD,
+	EFC_EVT_SCR_RCVD,
+	EFC_EVT_ELS_RCVD,
+
+	EFC_EVT_FCP_CMD_RCVD,
+
+	/* Used by fabric emulation */
+	EFC_EVT_RFT_ID_RCVD,
+	EFC_EVT_RFF_ID_RCVD,
+	EFC_EVT_GNN_ID_RCVD,
+	EFC_EVT_GPN_ID_RCVD,
+	EFC_EVT_GFPN_ID_RCVD,
+	EFC_EVT_GFF_ID_RCVD,
+	EFC_EVT_GID_FT_RCVD,
+	EFC_EVT_GID_PT_RCVD,
+	EFC_EVT_RPN_ID_RCVD,
+	EFC_EVT_RNN_ID_RCVD,
+	EFC_EVT_RCS_ID_RCVD,
+	EFC_EVT_RSNN_NN_RCVD,
+	EFC_EVT_RSPN_ID_RCVD,
+	EFC_EVT_RHBA_RCVD,
+	EFC_EVT_RPA_RCVD,
+
+	EFC_EVT_GIDPT_DELAY_EXPIRED,
+
+	/* SCSI Target Server events */
+	EFC_EVT_ABORT_IO,
+	EFC_EVT_ABORT_IO_NO_RESP,
+	EFC_EVT_IO_CMPL,
+	EFC_EVT_IO_CMPL_ERRORS,
+	EFC_EVT_RESP_CMPL,
+	EFC_EVT_ABORT_CMPL,
+	EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY,
+	EFC_EVT_NODE_DEL_INI_COMPLETE,
+	EFC_EVT_NODE_DEL_TGT_COMPLETE,
+	EFC_EVT_IO_ABORTED_BY_TMF,
+	EFC_EVT_IO_ABORT_IGNORED,
+	EFC_EVT_IO_FIRST_BURST,
+	EFC_EVT_IO_FIRST_BURST_ERR,
+	EFC_EVT_IO_FIRST_BURST_ABORTED,
+
+	/* Must be last */
+	EFC_EVT_LAST
+};
+
+int
+efc_sm_post_event(struct efc_sm_ctx_s *ctx,
+		  enum efc_sm_event_e evt, void *data);
+void
+efc_sm_transition(struct efc_sm_ctx_s *ctx,
+		  void *(*state)(struct efc_sm_ctx_s *ctx,
+				 enum efc_sm_event_e evt, void *arg),
+		  void *data);
+void efc_sm_disable(struct efc_sm_ctx_s *ctx);
+const char *efc_sm_event_name(enum efc_sm_event_e evt);
+
+#endif /* ! _EFC_SM_H */
-- 
2.13.7

