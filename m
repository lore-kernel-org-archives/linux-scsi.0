Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACC3C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A41A20838
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bwegIhl/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390587AbgJLWwK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390550AbgJLWwI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76890C0613D0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:08 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y14so15095403pfp.13
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=DFq2V8OHSEFSgjLIBpFcnnuxF6kFq7O9RsVJ0LfSxhQ=;
        b=bwegIhl/6o04vTCetc5pUOykX/W2FXottOn31ry6JeiNgKx7BDTZQRaAmDz/84eBSi
         CF5BlMD5OsqLkzMxx0QBk+0KgJgPb+uHjZpU0IjeRnbjLwf72B6I06+6B265ZBDZWsAS
         I5UO6m7xPEth3M9WkalN6LYfsbWCfcocpeQYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=DFq2V8OHSEFSgjLIBpFcnnuxF6kFq7O9RsVJ0LfSxhQ=;
        b=OChGB+wd3O1eOUNiqKPA2/ZeKnF637bH4JqPBATbj01ptK1ZsdWtYsrgvm1yxQIK1O
         bIHR/m3+bsF8wgJJG4sUU1bMvsNF3dy6Qffv+PqSaaNccjniouw75Sc20Ivc3gkmfhEf
         I5bIsGbHBmI6OEKYpf+DYtGgnEzUTmvwGizE3LCRFBMtPnW0fySb9lIFxqawA3IsupP/
         GjFQYyB9q6SSO1/G8ISydqvCHPgpbf3+9PMi2fSvg5e8wuqNPASI3aRUP7Z5RtOiVoK4
         TzyrHERKUuC2bZ6/4Iw2O0PIqEpta7i4TJkmefY7v0sqhzNSyFFA8D51eyhkP4H+PrRO
         NJVQ==
X-Gm-Message-State: AOAM533erTPCdCpnNevug6zCiy0J9vn7XNIImEqk7CSWAtzjVw+aGPKt
        5A8PeM9y+5dmGc5OU9IQDXiGOEXOdWuSA+1W4zLHnf9wVWpd28V9LiPeB28azO1QoDDClGVFFuT
        gLRlf4AzoCLtBc69CT6JaYBNFrn/IR4O8fOdRkkopnfSty4OeOW89TLMX1dow6iwTgvG/7YWxV1
        9tc8g=
X-Google-Smtp-Source: ABdhPJxITnp0u3yZJSip8EWFfhEdGpuzppbQ5SwkPChCbRjlUYnJiuUoESKWO97/X0byhxXGtu6HpQ==
X-Received: by 2002:a65:62ca:: with SMTP id m10mr14670435pgv.407.1602543127131;
        Mon, 12 Oct 2020 15:52:07 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:06 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 08/31] elx: libefc: Generic state machine framework
Date:   Mon, 12 Oct 2020 15:51:24 -0700
Message-Id: <20201012225147.54404-9-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000dea7f905b1812549"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000dea7f905b1812549
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch starts the population of the libefc library.
The library will contain common tasks usable by a target or initiator
driver. The library will also contain a FC discovery state machine
interface.

This patch creates the library directory and adds definitions
for the discovery state machine interface.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Remove the " EFC_SM_EVENT_START" id and define SM events serially.
---
 drivers/scsi/elx/libefc/efc_sm.c |  54 +++++++++
 drivers/scsi/elx/libefc/efc_sm.h | 197 +++++++++++++++++++++++++++++++
 2 files changed, 251 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h

diff --git a/drivers/scsi/elx/libefc/efc_sm.c b/drivers/scsi/elx/libefc/efc_sm.c
new file mode 100644
index 000000000000..b1f0978c9b87
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
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
index 000000000000..11f43b0d8296
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.h
@@ -0,0 +1,197 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
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
+	EFC_EVT_SPORT_ALLOC_OK,
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
+		  void (*state)(struct efc_sm_ctx *ctx,
+				 enum efc_sm_event evt, void *arg),
+		  void *data);
+void efc_sm_disable(struct efc_sm_ctx *ctx);
+const char *efc_sm_event_name(enum efc_sm_event evt);
+
+#endif /* ! _EFC_SM_H */
-- 
2.26.2


--000000000000dea7f905b1812549
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgayPFMz1s7X0fuv5j
zArjL+bQ+gYsccul/fBq3baMd/UwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjA3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJXL43aHROiN5cyHEWjDouFHbJG2FlG9rzyw
O02q9WpaSQZadYJ6Ob9Q1dZiQj9zNqtyFnrxGs7dgRnaprJvWfQEEiRu+XzjccRk5XmyszfeIYNi
oXCi/6i/mP9Ss+oPcYB49uL3KhIxZL39wthg1Fxdr92Pi3yNmuQNDogrn/sAHrqr8R/27p/KA4Xt
S1c+uQaw6+pZWgNdK9yoeqw8a6qOuuBLhPuKAg0KvN5bifdCOgijwUGfFjVPBhuzxX3TYaeog0ay
hDMLPjdp+/fJvObj+42KknCB30ZIL6s1ZYbfOzd9BX7XaD3bMysmMREccR1O52M4np9719eDMaj5
J18=
--000000000000dea7f905b1812549--
