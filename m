Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420A8C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25EC92065F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgENVf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 17:35:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33569 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgENVf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 17:35:28 -0400
Received: by mail-pl1-f195.google.com with SMTP id t7so72397plr.0
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 14:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=63pNs68I/xD/4flIFYQY8xsHu4flsoym9FPsoghGBfE=;
        b=Nm3HRqnauXG3p+4E16YFcYKI2fhfvaaZAVJmZz5uiSMBRm1Qq74uN9ws6qc9oNsmew
         ARYeVqEmRoEyTXcxuEpClsWon/4aw8hyJKwj/lAoqE/i5uZG3eIEiigHLPQ6TkktkGLl
         NoyrB4FUlrFg28BPFozYYDS6tI/RU2Z3UETvzj/bbA9rOV7WrP1qNjEDqL16pnbJ25sO
         rL/qNlViFEJmLnWXtE+3EdI7mbCBfVgdNSqm4PTzpxK9ThbpGhxhlq8y5HivX8dWqUTk
         knW9CH8u3GZl5M6b5ulXdCmg0K5L6AJ5952CrNEkF5Aq0k00iRjScNgNiXenHkAvTj3p
         FLcQ==
X-Gm-Message-State: AOAM532j7MKOlRwk+Gag5v0KA29mIpd6UNbipaILUI5l91LDCh7XMUa5
        f30u6VBDCyCjf3KzB6sP01o=
X-Google-Smtp-Source: ABdhPJwXcerlAonf0gB2g3qVgrr+ZP3BB/MucZEkXQR1Papa+BwpszWRH+aPj9nzpMgHXTHU5vNqnw==
X-Received: by 2002:a17:902:c214:: with SMTP id 20mr559644pll.17.1589492127571;
        Thu, 14 May 2020 14:35:27 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:6c16:7f27:8c37:e02d])
        by smtp.gmail.com with ESMTPSA id a142sm145754pfa.6.2020.05.14.14.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 14:35:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 02/15] qla2xxx: Suppress two recently introduced compiler warnings
Date:   Thu, 14 May 2020 14:35:03 -0700
Message-Id: <20200514213516.25461-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514213516.25461-1-bvanassche@acm.org>
References: <20200514213516.25461-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Suppress the following two compiler warnings because these are not useful:

In file included from ./include/trace/define_trace.h:102,
                 from ./include/trace/events/qla.h:39,
                 from drivers/scsi/qla2xxx/qla_dbg.c:77:
./include/trace/events/qla.h: In function 'trace_event_raw_event_qla_log_event':
./include/trace/trace_events.h:691:9: warning: function 'trace_event_raw_event_qla_log_event' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
  691 |  struct trace_event_raw_##call *entry;    \
      |         ^~~~~~~~~~~~~~~~
./include/trace/events/qla.h:12:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   12 | DECLARE_EVENT_CLASS(qla_log_event,
      | ^~~~~~~~~~~~~~~~~~~
In file included from ./include/trace/define_trace.h:103,
                 from ./include/trace/events/qla.h:39,
                 from drivers/scsi/qla2xxx/qla_dbg.c:77:
./include/trace/events/qla.h: In function 'perf_trace_qla_log_event':
./include/trace/perf.h:41:9: warning: function 'perf_trace_qla_log_event' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
   41 |  struct hlist_head *head;     \
      |         ^~~~~~~~~~
./include/trace/events/qla.h:12:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Cc: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Fixes: 598a90f2002c ("scsi: qla2xxx: add ring buffer for tracing debug logs")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/trace/events/qla.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/trace/events/qla.h b/include/trace/events/qla.h
index b71f680968eb..5857cf682ee7 100644
--- a/include/trace/events/qla.h
+++ b/include/trace/events/qla.h
@@ -9,6 +9,11 @@
 
 #define QLA_MSG_MAX 256
 
+#pragma GCC diagnostic push
+#ifndef __clang__
+#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
+#endif
+
 DECLARE_EVENT_CLASS(qla_log_event,
 	TP_PROTO(const char *buf,
 		struct va_format *vaf),
@@ -27,6 +32,8 @@ DECLARE_EVENT_CLASS(qla_log_event,
 	TP_printk("%s %s", __get_str(buf), __get_str(msg))
 );
 
+#pragma GCC diagnostic pop
+
 DEFINE_EVENT(qla_log_event, ql_dbg_log,
 	TP_PROTO(const char *buf, struct va_format *vaf),
 	TP_ARGS(buf, vaf)
