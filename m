Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D77C2BBC7
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79AE520739
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTiL3vZV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgDLDd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:28 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:40095 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgDLDd0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:26 -0400
Received: by mail-pg1-f169.google.com with SMTP id c5so2935138pgi.7
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/2xEM1AY9XxwvOtSYMCDCrqudpU9uTeXR5+CcF4jVvc=;
        b=XTiL3vZVWwfot+2dPa4mIqGZdQ7DtaWZzWcIr6UtxbR2KTNHiMKDRARFOeoWbnSAdm
         slcy/pMyuczXTwmkpjT7hBh7f/J+i4NrYHxszdiuTUsNkLNQq6WnCgaJCeo18cl59hbA
         Cjb8kwYd2xuz6AIgleOK+jzJ4vHAYiy/1J5lg9CP4IlqM38ouLmFPrN6cOJCe+1ZBD9t
         9UEYKrl/hFzoaMAd1bxjO0QCNqcfB5+5hOQ6XS7/oA810FmqYbgG7bHOs/rqdvDCN9xo
         oicQF0be7ztNE+RXoFCxpD//1sJ28ILJX5fUEUSgnP81lNU3znmG1KKuID+QMcLrq7gF
         QBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/2xEM1AY9XxwvOtSYMCDCrqudpU9uTeXR5+CcF4jVvc=;
        b=q3J/athuINtL9GIfWIph4eTfCHKh4ycBoo3r8YcRTVO6BSGTZF047GYydvamUSdwyO
         wo+lL4QS/9YqPHqrEyAZC2HtUpHtoHKXfUcLQp+zhpkynktrQ47ZAX3ClTPiww7rcQjT
         UqGrBIUWY1nUhQVi0IOVU27aAJ/IWrBYg8pdWBjjuOWIAoiNaXgoniNJ2g+WRkz0dM18
         +7TszYAZKHmRlVqjcsrlQvx/rXSRMTU5Y8raze6ycCptyQlSsOeS7bCMneEqvCdno2r+
         XV35gpl8w9dZJ6fi/xHTVl8N+Jn0Qkgiq3/8+7/IAa1a+TnTaWic0ekBuu1d4zG49W7c
         0gqg==
X-Gm-Message-State: AGi0Pua9nCuDs+SwdsJt6quVZyGGBRYLYkJD0Bpg+VSN1HsvHqWQXTRh
        lC9cJRcFO7XYl2moPQLEsJ/5r38r
X-Google-Smtp-Source: APiQypIPj0k72ohmWJTukjMMH9xp+jf7whiZo7v/+/BaNC7bSQ0koMmx7FR96NAnoKt3dZLdhGL94w==
X-Received: by 2002:a63:c7:: with SMTP id 190mr11131540pga.185.1586662403796;
        Sat, 11 Apr 2020 20:33:23 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 08/31] elx: libefc: Generic state machine framework
Date:   Sat, 11 Apr 2020 20:32:40 -0700
Message-Id: <20200412033303.29574-9-jsmart2021@gmail.com>
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

This patch starts the population of the libefc library.
The library will contain common tasks usable by a target or initiator
driver. The library will also contain a FC discovery state machine
interface.

This patch creates the library directory and adds definitions
for the discovery state machine interface.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  Removed efc_sm_id array which is not used.
  Added State Machine event name lookup array.
---
 drivers/scsi/elx/libefc/efc_sm.c |  61 ++++++++++++
 drivers/scsi/elx/libefc/efc_sm.h | 209 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 270 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h

diff --git a/drivers/scsi/elx/libefc/efc_sm.c b/drivers/scsi/elx/libefc/efc_sm.c
new file mode 100644
index 000000000000..aba9d542f22e
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.c
@@ -0,0 +1,61 @@
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
+	if (ctx->current_state) {
+		ctx->current_state(ctx, evt, data);
+		return EFC_SUCCESS;
+	} else {
+		return EFC_FAIL;
+	}
+}
+
+void
+efc_sm_transition(struct efc_sm_ctx *ctx,
+		  void *(*state)(struct efc_sm_ctx *,
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
+void
+efc_sm_disable(struct efc_sm_ctx *ctx)
+{
+	ctx->current_state = NULL;
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
index 000000000000..9cb534a1b86e
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.h
@@ -0,0 +1,209 @@
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
+#define EFC_SM_EVENT_SHIFT		8
+#define EFC_SM_EVENT_START(id)		((id) << EFC_SM_EVENT_SHIFT)
+
+struct efc_sm_ctx;
+
+/* State Machine events */
+enum efc_sm_event {
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
+	EFC_EVT_GIDPT_DELAY_EXPIRED,
+
+	/* SCSI Target Server events */
+	EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY,
+	EFC_EVT_NODE_DEL_INI_COMPLETE,
+	EFC_EVT_NODE_DEL_TGT_COMPLETE,
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
+	[EFC_EVT_SPORT_ALLOC_OK]	= "EFC_EVT_SPORT_ALLOC_OK",	\
+	[EFC_EVT_SPORT_ALLOC_FAIL]	= "EFC_EVT_SPORT_ALLOC_FAIL",	\
+	[EFC_EVT_SPORT_ATTACH_OK]	= "EFC_EVT_SPORT_ATTACH_OK",	\
+	[EFC_EVT_SPORT_ATTACH_FAIL]	= "EFC_EVT_SPORT_ATTACH_FAIL",	\
+	[EFC_EVT_SPORT_FREE_OK]		= "EFC_EVT_SPORT_FREE_OK",	\
+	[EFC_EVT_SPORT_FREE_FAIL]	= "EFC_EVT_SPORT_FREE_FAIL",	\
+	[EFC_EVT_SPORT_TOPOLOGY_NOTIFY]	= "EFC_EVT_SPORT_TOPOLOGY_NOTIFY",\
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
+		  void *(*state)(struct efc_sm_ctx *ctx,
+				 enum efc_sm_event evt, void *arg),
+		  void *data);
+void efc_sm_disable(struct efc_sm_ctx *ctx);
+const char *efc_sm_event_name(enum efc_sm_event evt);
+
+#endif /* ! _EFC_SM_H */
-- 
2.16.4

