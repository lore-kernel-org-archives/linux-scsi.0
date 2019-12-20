Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4225EC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C0092082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrhSmjT5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfLTWhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:41 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37795 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfLTWhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:41 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so5994877pfn.4
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dKmKT+b0bzWRWgqwFvRTQl11R6qEkLGxPu8JpeXUDSk=;
        b=WrhSmjT5f/0YFVHJeAsrW3QucbjB1vVld3mkAtqHnrf7OUbvKmtFG0wbGP4yFlTm7X
         Y5M867AIvp8MjuePkKIT/ZzAzTyTjp3N6NqwcqLk2yfdjuAgAcR0ynmHwpUUnV+ykQhK
         7xzrSp6Kf5EgpmrP8KnygPt5zVI7RGw3mQ3fPNLsL/NjT/Ja+yTLQ88w2Y+6cZqAAfKm
         CsEP6NlGTvnYqiujJ9V++ICeNh55e4+AF3ne/m6kJcNYxwupWSOrvp/SeaWSSqaIw6oB
         FZS5vR7/ZdyoR974fydt2bOH5dzBGI5dR/ceoTjjO0ORzPtLngq9Avt7TFgmfCEGTJ+k
         cgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dKmKT+b0bzWRWgqwFvRTQl11R6qEkLGxPu8JpeXUDSk=;
        b=D/PN0Z8goh4spdJE1UbJAn/Qf6E+FsphTpeMVEZtzvDmkRkxUHdBm9xNLTG+roQV+q
         oe9OE0TunWIUtpMmOthVGo1MmqsmjxFDmmhl/ur5spaV1qqtPlCO1nDz9H6Vm7AD5OR/
         jUrKFIJv65NI612mp0O3S0949epCeuwCaGweQkrVX8/ptv+cqZx6AH58dfAulnapR3bb
         En3ro6V3nsvyOe7XSO08iFFiJ5y28J1gkZ5GQzO/F5MSQ/up9V2NCpINl8m3s+OR5Wuz
         GKQeHMl1S7ngoNihPEkM8+o/naB7rrIc8lQewcZWUHZfcg4zNItaeTEeB2NR7T68zj/E
         pRMQ==
X-Gm-Message-State: APjAAAX8VKui9SqgaE8Nuhq1sLNEErYUU6I9scZQy3f7lV69vqfrAGSm
        euqO+7uU7DxiRfOEOOgnFWA7Oq0H
X-Google-Smtp-Source: APXvYqw1I88oMC6xEkDrA6v/sI0DudQ8f+YgrbYBX6bYTvxkjCY6zeXb/SIvnw+GYdczs0kjCnjsGA==
X-Received: by 2002:a62:5447:: with SMTP id i68mr8979883pfb.44.1576881460460;
        Fri, 20 Dec 2019 14:37:40 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:40 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 08/32] elx: libefc: Generic state machine framework
Date:   Fri, 20 Dec 2019 14:36:59 -0800
Message-Id: <20191220223723.26563-9-jsmart2021@gmail.com>
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

This patch starts the population of the libefc library.
The library will contain common tasks usable by a target or initiator
driver. The library will also contain a FC discovery state machine
interface.

This patch creates the library directory and adds definitions
for the discovery state machine interface.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc/efc_sm.c | 213 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_sm.h | 140 +++++++++++++++++++++++++
 2 files changed, 353 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h

diff --git a/drivers/scsi/elx/libefc/efc_sm.c b/drivers/scsi/elx/libefc/efc_sm.c
new file mode 100644
index 000000000000..90e60c0e6638
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.c
@@ -0,0 +1,213 @@
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
+		return 0;
+	} else {
+		return -1;
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
+const char *efc_sm_event_name(enum efc_sm_event evt)
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
+	case EFC_EVT_GIDPT_DELAY_EXPIRED:
+		return "EFC_EVT_GIDPT_DELAY_EXPIRED";
+
+	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
+		return "EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY";
+	case EFC_EVT_NODE_DEL_INI_COMPLETE:
+		return "EFC_EVT_NODE_DEL_INI_COMPLETE";
+	case EFC_EVT_NODE_DEL_TGT_COMPLETE:
+		return "EFC_EVT_NODE_DEL_TGT_COMPLETE";
+
+	default:
+		break;
+	}
+	return "unknown";
+}
diff --git a/drivers/scsi/elx/libefc/efc_sm.h b/drivers/scsi/elx/libefc/efc_sm.h
new file mode 100644
index 000000000000..c76352d1d527
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_sm.h
@@ -0,0 +1,140 @@
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
+extern const char *efc_sm_id[];
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
2.13.7

