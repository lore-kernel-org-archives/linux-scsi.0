Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055F0C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0A52207C4
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgERVRY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 17:17:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37712 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERVRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 17:17:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id y198so3957825pfb.4
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2020 14:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=63pNs68I/xD/4flIFYQY8xsHu4flsoym9FPsoghGBfE=;
        b=Dzz6MtzGJd+Sna9TyKmVFz6QD2wqENmJ9F1/p6R0zdgnXgNb0wDOiALUa8uLwM3SNf
         IzusZdVrGXdNf96RdpeovtkDe+SyMEIF9yC4w8kLT412z1fMRG1vtRzT4kYnwPegyyJU
         7MK++UjU0GRACQ0H4N4d7qAJaNQtYKjvFMhMRJ3YqfBdzGXSLYQ9YMLaev40S1N74Cjq
         KY9jyoqKgBWU1ftjSWOguJcjNDR151X6lisFqcRGhNgt8ccl5Fm88r+eCH+vRO7Yk3LT
         e4p87ketVSsfjy+3ZUQ2J4tbq6BEnsgBAt12I6Z0EjH7rckqkXaHwb+MSLdY8DDzRFq5
         JlgA==
X-Gm-Message-State: AOAM532NWtt9dQEvx+XG7XgfY8UyaL9ltoZtaUvjvFA0p3Vx5N6ReX4L
        EFcpMmTaDsVcGZgdzFUowTQ=
X-Google-Smtp-Source: ABdhPJwPx3QoJiXyYR1V6oA+UaJCAApbGfJTU/+1+bCnxu1tIev8vEAeF5AOQFtJDwOr0BQVTLko4w==
X-Received: by 2002:a62:1957:: with SMTP id 84mr15727686pfz.54.1589836642218;
        Mon, 18 May 2020 14:17:22 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id i184sm8813123pgc.36.2020.05.18.14.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:17:21 -0700 (PDT)
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
Subject: [PATCH v7 02/15] qla2xxx: Suppress two recently introduced compiler warnings
Date:   Mon, 18 May 2020 14:16:59 -0700
Message-Id: <20200518211712.11395-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518211712.11395-1-bvanassche@acm.org>
References: <20200518211712.11395-1-bvanassche@acm.org>
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
