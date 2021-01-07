Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C71EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA303235FF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbhAGXAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbhAGXAc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 18:00:32 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACADAC0612FD
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2021 14:59:18 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id w6so5007485pfu.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 14:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K4Cf3PKgRRlNl8jh3XjcvB5sF7GWafxkwPQ91gY1DWw=;
        b=Rui+B4atJ0b1RcU3W4uNxWiODLi+FBAlsF1VIMjhaKwhLBTxhsDdgpcO00qekz5yrt
         7RL5s2tBHNucUTPHccedVhXKhhtiA5r5B1m0L9XWKFu5jjvUqZlNPsKRkxxo8whRE7WL
         EvphhntqNytjvb+Et7m23RyQmKg/RGUTKfBb0xBRuME14SUUxR+OsO5J0KmabzJNCbqk
         j4pu+ry95qsxB1/f9ss7nzmCWWfeKhwg00w92zHBes+pQ7Tpom/YW69hDZeV62SgXpzf
         4V6kcMT4Xcl7FKupohj8tbciQ66M6BlGxCLZcC0rTpuK5eqogmTY8Ee/XV4xN+7ZdSPw
         aklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K4Cf3PKgRRlNl8jh3XjcvB5sF7GWafxkwPQ91gY1DWw=;
        b=WVp0NNTWqVYHx0ESyOpCQhheLywNXMgn7Mp8Rn+gLEXHT9VYijoYSvGgPB2K+zYH0H
         oqNkipHiEh6FStMJoR3mwN/klDtu8W6byRoY9rs3V2FqIatDsPzAmouSA75LZNWKHDRd
         6lFMwrFtS+PZeJ2wHX0J/TgGbCVvRAMR0glQu9u9cv7ajlLPHr50NMvNCl6eCavriXmA
         SA081vp/YAHuFFhrlpAF1W4poUw1BHKiCKLK6vt1u0X9PSuv5TiZeCErWvR4A/6MDH2d
         vs2l9hO3MuYdDSc0G8V+it6/PFEH3t06e2tjSDbee41MNwjJOPtHk0b+WSw76s5EBZtJ
         0M1Q==
X-Gm-Message-State: AOAM532VTCYJuTqqopTfK9mJT4jwetwU1q8C8c+SBmdI48hB5UGqOTVh
        1amLHb/9c6DZ4prlBtJk/ndh0qPqyMr3gw==
X-Google-Smtp-Source: ABdhPJzWnHYpu1sv9quAoLqC6s/v+FSk1Vuc5d0ytDsRzLPzIP0c28/3fmCy7YoKvaJNK7o2mCaeSg==
X-Received: by 2002:a63:2347:: with SMTP id u7mr3958888pgm.189.1610060357980;
        Thu, 07 Jan 2021 14:59:17 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l197sm6881405pfd.97.2021.01.07.14.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:59:17 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v7 08/31] elx: libefc: Generic state machine framework
Date:   Thu,  7 Jan 2021 14:58:42 -0800
Message-Id: <20210107225905.18186-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107225905.18186-1-jsmart2021@gmail.com>
References: <20210107225905.18186-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch starts the population of the libefc library.
The library will contain common tasks usable by a target or initiator
driver. The library will also contain a FC discovery state machine
interface.

This patch creates the library directory and adds definitions
for the discovery state machine interface.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/elx/libefc/efc_sm.c |  54 +++++++++
 drivers/scsi/elx/libefc/efc_sm.h | 197 +++++++++++++++++++++++++++++++
 2 files changed, 251 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h

diff --git a/drivers/scsi/elx/libefc/efc_sm.c b/drivers/scsi/elx/libefc/efc_sm.c
new file mode 100644
index 000000000000..252399c19293
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * Generic state machine framework.
+ */
+#include "efc.h"
+#include "efc_sm.h"
+
+/**
+ * efc_sm_post_event() - Post an event to a context.
+ *
+ * @ctx: State machine context
+ * @evt: Event to post
+ * @data: Event-specific data (if any)
+ */
+int
+efc_sm_post_event(struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *data)
+{
+	if (!ctx->current_state)
+		return EFC_FAIL;
+
+	ctx->current_state(ctx, evt, data);
+	return EFC_SUCCESS;
+}
+
+void
+efc_sm_transition(struct efc_sm_ctx *ctx,
+		  void (*state)(struct efc_sm_ctx *,
+				 enum efc_sm_event, void *), void *data)
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
+static char *event_name[] = EFC_SM_EVENT_NAME;
+
+const char *efc_sm_event_name(enum efc_sm_event evt)
+{
+	if (evt > EFC_EVT_LAST)
+		return "unknown";
+
+	return event_name[evt];
+}
diff --git a/drivers/scsi/elx/libefc/efc_sm.h b/drivers/scsi/elx/libefc/efc_sm.h
new file mode 100644
index 000000000000..e28835e7717d
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.h
@@ -0,0 +1,197 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
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
+struct efc_sm_ctx;
+
+/* State Machine events */
+enum efc_sm_event {
+	/* Common Events */
+	EFC_EVT_ENTER,
+	EFC_EVT_REENTER,
+	EFC_EVT_EXIT,
+	EFC_EVT_SHUTDOWN,
+	EFC_EVT_ALL_CHILD_NODES_FREE,
+	EFC_EVT_RESUME,
+	EFC_EVT_TIMER_EXPIRED,
+
+	/* Domain Events */
+	EFC_EVT_RESPONSE,
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
+	EFC_EVT_NPORT_ALLOC_OK,
+	EFC_EVT_NPORT_ALLOC_FAIL,
+	EFC_EVT_NPORT_ATTACH_OK,
+	EFC_EVT_NPORT_ATTACH_FAIL,
+	EFC_EVT_NPORT_FREE_OK,
+	EFC_EVT_NPORT_FREE_FAIL,
+	EFC_EVT_NPORT_TOPOLOGY_NOTIFY,
+	EFC_EVT_HW_PORT_ALLOC_OK,
+	EFC_EVT_HW_PORT_ALLOC_FAIL,
+	EFC_EVT_HW_PORT_ATTACH_OK,
+	EFC_EVT_HW_PORT_REQ_ATTACH,
+	EFC_EVT_HW_PORT_REQ_FREE,
+	EFC_EVT_HW_PORT_FREE_OK,
+
+	/* Login Events */
+	EFC_EVT_SRRS_ELS_REQ_OK,
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
+	EFC_EVT_GIDPT_DELAY_EXPIRED,
+
+	/* SCSI Target Server events */
+	EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY,
+	EFC_EVT_NODE_DEL_INI_COMPLETE,
+	EFC_EVT_NODE_DEL_TGT_COMPLETE,
+	EFC_EVT_NODE_SESS_REG_OK,
+	EFC_EVT_NODE_SESS_REG_FAIL,
+
+	/* Must be last */
+	EFC_EVT_LAST
+};
+
+/* State Machine event name lookup array */
+#define EFC_SM_EVENT_NAME {						\
+	[EFC_EVT_ENTER]			= "EFC_EVT_ENTER",		\
+	[EFC_EVT_REENTER]		= "EFC_EVT_REENTER",		\
+	[EFC_EVT_EXIT]			= "EFC_EVT_EXIT",		\
+	[EFC_EVT_SHUTDOWN]		= "EFC_EVT_SHUTDOWN",		\
+	[EFC_EVT_ALL_CHILD_NODES_FREE]	= "EFC_EVT_ALL_CHILD_NODES_FREE",\
+	[EFC_EVT_RESUME]		= "EFC_EVT_RESUME",		\
+	[EFC_EVT_TIMER_EXPIRED]		= "EFC_EVT_TIMER_EXPIRED",	\
+	[EFC_EVT_RESPONSE]		= "EFC_EVT_RESPONSE",		\
+	[EFC_EVT_ERROR]			= "EFC_EVT_ERROR",		\
+	[EFC_EVT_DOMAIN_FOUND]		= "EFC_EVT_DOMAIN_FOUND",	\
+	[EFC_EVT_DOMAIN_ALLOC_OK]	= "EFC_EVT_DOMAIN_ALLOC_OK",	\
+	[EFC_EVT_DOMAIN_ALLOC_FAIL]	= "EFC_EVT_DOMAIN_ALLOC_FAIL",	\
+	[EFC_EVT_DOMAIN_REQ_ATTACH]	= "EFC_EVT_DOMAIN_REQ_ATTACH",	\
+	[EFC_EVT_DOMAIN_ATTACH_OK]	= "EFC_EVT_DOMAIN_ATTACH_OK",	\
+	[EFC_EVT_DOMAIN_ATTACH_FAIL]	= "EFC_EVT_DOMAIN_ATTACH_FAIL",	\
+	[EFC_EVT_DOMAIN_LOST]		= "EFC_EVT_DOMAIN_LOST",	\
+	[EFC_EVT_DOMAIN_FREE_OK]	= "EFC_EVT_DOMAIN_FREE_OK",	\
+	[EFC_EVT_DOMAIN_FREE_FAIL]	= "EFC_EVT_DOMAIN_FREE_FAIL",	\
+	[EFC_EVT_HW_DOMAIN_REQ_ATTACH]	= "EFC_EVT_HW_DOMAIN_REQ_ATTACH",\
+	[EFC_EVT_HW_DOMAIN_REQ_FREE]	= "EFC_EVT_HW_DOMAIN_REQ_FREE",	\
+	[EFC_EVT_NPORT_ALLOC_OK]	= "EFC_EVT_NPORT_ALLOC_OK",	\
+	[EFC_EVT_NPORT_ALLOC_FAIL]	= "EFC_EVT_NPORT_ALLOC_FAIL",	\
+	[EFC_EVT_NPORT_ATTACH_OK]	= "EFC_EVT_NPORT_ATTACH_OK",	\
+	[EFC_EVT_NPORT_ATTACH_FAIL]	= "EFC_EVT_NPORT_ATTACH_FAIL",	\
+	[EFC_EVT_NPORT_FREE_OK]		= "EFC_EVT_NPORT_FREE_OK",	\
+	[EFC_EVT_NPORT_FREE_FAIL]	= "EFC_EVT_NPORT_FREE_FAIL",	\
+	[EFC_EVT_NPORT_TOPOLOGY_NOTIFY]	= "EFC_EVT_NPORT_TOPOLOGY_NOTIFY",\
+	[EFC_EVT_HW_PORT_ALLOC_OK]	= "EFC_EVT_HW_PORT_ALLOC_OK",	\
+	[EFC_EVT_HW_PORT_ALLOC_FAIL]	= "EFC_EVT_HW_PORT_ALLOC_FAIL",	\
+	[EFC_EVT_HW_PORT_ATTACH_OK]	= "EFC_EVT_HW_PORT_ATTACH_OK",	\
+	[EFC_EVT_HW_PORT_REQ_ATTACH]	= "EFC_EVT_HW_PORT_REQ_ATTACH",	\
+	[EFC_EVT_HW_PORT_REQ_FREE]	= "EFC_EVT_HW_PORT_REQ_FREE",	\
+	[EFC_EVT_HW_PORT_FREE_OK]	= "EFC_EVT_HW_PORT_FREE_OK",	\
+	[EFC_EVT_SRRS_ELS_REQ_OK]	= "EFC_EVT_SRRS_ELS_REQ_OK",	\
+	[EFC_EVT_SRRS_ELS_CMPL_OK]	= "EFC_EVT_SRRS_ELS_CMPL_OK",	\
+	[EFC_EVT_SRRS_ELS_REQ_FAIL]	= "EFC_EVT_SRRS_ELS_REQ_FAIL",	\
+	[EFC_EVT_SRRS_ELS_CMPL_FAIL]	= "EFC_EVT_SRRS_ELS_CMPL_FAIL",	\
+	[EFC_EVT_SRRS_ELS_REQ_RJT]	= "EFC_EVT_SRRS_ELS_REQ_RJT",	\
+	[EFC_EVT_NODE_ATTACH_OK]	= "EFC_EVT_NODE_ATTACH_OK",	\
+	[EFC_EVT_NODE_ATTACH_FAIL]	= "EFC_EVT_NODE_ATTACH_FAIL",	\
+	[EFC_EVT_NODE_FREE_OK]		= "EFC_EVT_NODE_FREE_OK",	\
+	[EFC_EVT_NODE_FREE_FAIL]	= "EFC_EVT_NODE_FREE_FAIL",	\
+	[EFC_EVT_ELS_FRAME]		= "EFC_EVT_ELS_FRAME",		\
+	[EFC_EVT_ELS_REQ_TIMEOUT]	= "EFC_EVT_ELS_REQ_TIMEOUT",	\
+	[EFC_EVT_ELS_REQ_ABORTED]	= "EFC_EVT_ELS_REQ_ABORTED",	\
+	[EFC_EVT_ABORT_ELS]		= "EFC_EVT_ABORT_ELS",		\
+	[EFC_EVT_ELS_ABORT_CMPL]	= "EFC_EVT_ELS_ABORT_CMPL",	\
+	[EFC_EVT_ABTS_RCVD]		= "EFC_EVT_ABTS_RCVD",		\
+	[EFC_EVT_NODE_MISSING]		= "EFC_EVT_NODE_MISSING",	\
+	[EFC_EVT_NODE_REFOUND]		= "EFC_EVT_NODE_REFOUND",	\
+	[EFC_EVT_SHUTDOWN_IMPLICIT_LOGO] = "EFC_EVT_SHUTDOWN_IMPLICIT_LOGO",\
+	[EFC_EVT_SHUTDOWN_EXPLICIT_LOGO] = "EFC_EVT_SHUTDOWN_EXPLICIT_LOGO",\
+	[EFC_EVT_PLOGI_RCVD]		= "EFC_EVT_PLOGI_RCVD",		\
+	[EFC_EVT_FLOGI_RCVD]		= "EFC_EVT_FLOGI_RCVD",		\
+	[EFC_EVT_LOGO_RCVD]		= "EFC_EVT_LOGO_RCVD",		\
+	[EFC_EVT_PRLI_RCVD]		= "EFC_EVT_PRLI_RCVD",		\
+	[EFC_EVT_PRLO_RCVD]		= "EFC_EVT_PRLO_RCVD",		\
+	[EFC_EVT_PDISC_RCVD]		= "EFC_EVT_PDISC_RCVD",		\
+	[EFC_EVT_FDISC_RCVD]		= "EFC_EVT_FDISC_RCVD",		\
+	[EFC_EVT_ADISC_RCVD]		= "EFC_EVT_ADISC_RCVD",		\
+	[EFC_EVT_RSCN_RCVD]		= "EFC_EVT_RSCN_RCVD",		\
+	[EFC_EVT_SCR_RCVD]		= "EFC_EVT_SCR_RCVD",		\
+	[EFC_EVT_ELS_RCVD]		= "EFC_EVT_ELS_RCVD",		\
+	[EFC_EVT_FCP_CMD_RCVD]		= "EFC_EVT_FCP_CMD_RCVD",	\
+	[EFC_EVT_NODE_DEL_INI_COMPLETE]	= "EFC_EVT_NODE_DEL_INI_COMPLETE",\
+	[EFC_EVT_NODE_DEL_TGT_COMPLETE]	= "EFC_EVT_NODE_DEL_TGT_COMPLETE",\
+	[EFC_EVT_LAST]			= "EFC_EVT_LAST",		\
+}
+
+int
+efc_sm_post_event(struct efc_sm_ctx *ctx,
+		  enum efc_sm_event evt, void *data);
+void
+efc_sm_transition(struct efc_sm_ctx *ctx,
+		  void (*state)(struct efc_sm_ctx *ctx,
+				 enum efc_sm_event evt, void *arg),
+		  void *data);
+void efc_sm_disable(struct efc_sm_ctx *ctx);
+const char *efc_sm_event_name(enum efc_sm_event evt);
+
+#endif /* ! _EFC_SM_H */
-- 
2.26.2

