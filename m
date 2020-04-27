Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C137C5519A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB36206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgD0DDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 23:03:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38114 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgD0DDU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 23:03:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id p8so8020016pgi.5
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 20:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PiQKJtXkK91EAzXv1PvtB9UER3Afe92wbfNuHeDpwJM=;
        b=T6tclEaDg893JRwP+7D4XCibi4sfzpD8BOTUmuVqIuKiRlujyNbm0wtai8aoNY50qo
         eAjeB0flY3l4pB2D9izLRIl2KShiY1nNCJebMJO5455vBySWQSkZ4kKteciQTZwzrno8
         U+nVL76byU3WZr+p93XiuYJY4aV6pJbEEa0PCO1Oj4QjpYiU+ugYxdTaYu4aR6ETrX3M
         sOfgeSnLl4hb2oXHl6183/mZMA19dkNssce5YMy3k26C79rpLjLxGBkWKI272IhqQnPy
         yGtbScE08zyH2iipZFqDCgd3S0Bq0DkteeD+4T/WZ2rvSOK/4O1eNK8lk5sbCRmBswE7
         VznQ==
X-Gm-Message-State: AGi0PuaC/NQ4AUvGf76dpkbY5g9ia0RAo1vixns5D7P2rjg3LYyL/tli
        i5DMeEzAVKzl1dtKqz8lPl8=
X-Google-Smtp-Source: APiQypKaEweHfWs+Q+K48Pa6aK9ApI/NVmFyI9KeKielf7b0bUOSKr5bL3Z4hnDK+B8vR7GFYyev4w==
X-Received: by 2002:a63:7f5d:: with SMTP id p29mr20174716pgn.96.1587956599694;
        Sun, 26 Apr 2020 20:03:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id v94sm9982617pjb.39.2020.04.26.20.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 20:03:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v4 02/11] qla2xxx: Suppress two recently introduced compiler warnings
Date:   Sun, 26 Apr 2020 20:03:01 -0700
Message-Id: <20200427030310.19687-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427030310.19687-1-bvanassche@acm.org>
References: <20200427030310.19687-1-bvanassche@acm.org>
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

Cc: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
