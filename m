Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F369C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01BAF20936
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 17:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbhACRNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jan 2021 12:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbhACRNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2021 12:13:10 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD4FC06179F
        for <linux-scsi@vger.kernel.org>; Sun,  3 Jan 2021 09:12:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l23so8923327pjg.1
        for <linux-scsi@vger.kernel.org>; Sun, 03 Jan 2021 09:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K4Cf3PKgRRlNl8jh3XjcvB5sF7GWafxkwPQ91gY1DWw=;
        b=X3JIxRaCwLC9NVR+PfDnX0J2yd0D45x2QtO8E2vtcwdADN4OcRHM5HfvW8vGcbNUY2
         5Go3QJgE0NHLahDqFPI5Qbcx/Busqh0WF1CsuofXrHFtjC61jGsxdQsiuZCD9K5Mv96d
         Vpt3PKh2LYy1bnkITYeqIYN++nfTw1V/BB1TDZf+oPASMoGksMMSzs8C8yV0Or7I72uz
         XVfxVJjwDd+J3bKEAdU+u3B7EYEy29eytxKFwQfgWzNwbGDhdhvYWO7wpALShiuGm8cX
         Aemp1IXxODg3kVQSSPzWbl1iUJ481aee27+hVPVN8l3J6S+b4vVUxir/hsVgz7jo90Ss
         ds6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K4Cf3PKgRRlNl8jh3XjcvB5sF7GWafxkwPQ91gY1DWw=;
        b=gFvjeWrMFqiP6gF48WTsl6jdktYKvdbUpjwjc2cBVExPZVYrKGqLRpvqWea9K0RTbD
         Wm2rbCzDZgsASV7bJA5R9OKaWaf2EqBHrOKkHazlO2noAbEdEQ6z323OFcyAZLo47+7Y
         VUoaofWyu41JUDbGPR+jWrQPOa7/I+rZAGi9evO1Q026cbUYI2KL0Ni0xJmuFgV3akbO
         k123GN7sGY20/y6XjlYjXOUAvNBlgLd4Dr5tSuBF05ruJ5hE+PTXfBjAIijFj0wapYKL
         UDl6ChCwnjKr328TxJ2sTKKiUdSxuBsbVgseWR6xtVdNgMGvvNxuAhptOxStlTH/nK3k
         8MSA==
X-Gm-Message-State: AOAM531h3hDTAQX/jEmGRKnYVPtCNYJOcSjama64n1pHoT2BY5RLyYYH
        LKHplVByaroDlJRiT3E+Gr9uU9VwDps=
X-Google-Smtp-Source: ABdhPJxjMlYCNwGow8qcsGmsQbgat3B+eZAmgvbl5UWAikH6JhwJ/NlDe50BsCyq8B2yBBQwc6fCcQ==
X-Received: by 2002:a17:902:d385:b029:da:c6e4:5cab with SMTP id e5-20020a170902d385b02900dac6e45cabmr68725696pld.7.1609693932635;
        Sun, 03 Jan 2021 09:12:12 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m4sm33145151pgv.16.2021.01.03.09.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 09:12:12 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v5 08/31] elx: libefc: Generic state machine framework
Date:   Sun,  3 Jan 2021 09:11:11 -0800
Message-Id: <20210103171134.39878-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103171134.39878-1-jsmart2021@gmail.com>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
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

