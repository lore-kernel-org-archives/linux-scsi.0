Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3382C54E49
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC95A20838
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgEGE2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 00:28:47 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37957 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEGE2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 00:28:47 -0400
Received: by mail-pj1-f66.google.com with SMTP id t40so2052831pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2020 21:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ucXGJ9yyMv1xABD3x3O2Y8mePcrgbQrAylD8j76MSo0=;
        b=EGYpe4UyfukWDGPvQw1Zjb/uHxPBjtFRkg5NLPIwUeICtuQAoqB6cAbBOORjDtfv3W
         DX+ovvzQB5QUOstIZqegImR1I0/4dnWe+sGKhXyUH41LosgwELe89y6K0ZEKW5jxJejR
         oVDzXhwFJQ+ckvsbQUeTpcMj+J8+O1VLoCmeyDg2kh+cwT02zXJJ/r/QaQesdR4Fo5/n
         NFeUF/YdCQWP3OBZZJ0joxNMJXTsxmjDd2cNA/2UIGH8FmU3vM6gIEhaN4Oe+dzrzN4q
         6pzPMXjqksm2ZpjV5ybqudKM8x7ql6Fdaxtt4zLIBzwWqLpPQB24JMsQb3Y7L7RsMVKa
         9ryA==
X-Gm-Message-State: AGi0PuZDpHp2Tv0ZtS5XO/KkL3tPue6nFP8zK/RZ0D4tuIYKvRo5vYVy
        uG8q5kSByJMggL1bxxkR5pw=
X-Google-Smtp-Source: APiQypJwXpFHftjqxibupsjYsi5vQsEU4wGa61ybK98n9GKsGIQvm+gM+xwV4ZhWNHUNWIMJrMqJxw==
X-Received: by 2002:a17:90b:8c8:: with SMTP id ds8mr13060942pjb.164.1588825725941;
        Wed, 06 May 2020 21:28:45 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:246f:3453:e672:e40c])
        by smtp.gmail.com with ESMTPSA id z28sm3471028pfr.3.2020.05.06.21.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 21:28:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 02/11] qla2xxx: Suppress two recently introduced compiler warnings
Date:   Wed,  6 May 2020 21:28:26 -0700
Message-Id: <20200507042835.9135-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507042835.9135-1-bvanassche@acm.org>
References: <20200507042835.9135-1-bvanassche@acm.org>
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
Cc: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Fixes: 598a90f2002c ("scsi: qla2xxx: add ring buffer for tracing debug logs")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/trace/events/qla.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/trace/events/qla.h b/include/trace/events/qla.h
index b71f680968eb..737a667ab98f 100644
--- a/include/trace/events/qla.h
+++ b/include/trace/events/qla.h
@@ -9,6 +9,9 @@
 
 #define QLA_MSG_MAX 256
 
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
+
 DECLARE_EVENT_CLASS(qla_log_event,
 	TP_PROTO(const char *buf,
 		struct va_format *vaf),
@@ -32,6 +35,8 @@ DEFINE_EVENT(qla_log_event, ql_dbg_log,
 	TP_ARGS(buf, vaf)
 );
 
+#pragma GCC diagnostic pop
+
 #endif /* _TRACE_QLA_H */
 
 #define TRACE_INCLUDE_FILE qla
