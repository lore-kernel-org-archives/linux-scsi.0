Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE3BC54E4B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D21B20720
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbgEKUJ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:09:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32923 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUJ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:09:57 -0400
Received: by mail-pg1-f195.google.com with SMTP id a4so5065422pgc.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=db2RFVP7WluXdWVKOJ9L/lZcYxrkpV6VdpPisw/9H/A=;
        b=QDLajm/5fdMoDFPjCz/vBtVx2lTRchZZsYN8havsr1ur6h2WAI295L6MJ/5IKmP5k9
         udqp7IEFFTUGiWYEy5OcFiCS0l3+AQLc1VOWy8TwxEiwiH6J7AHbVMj+dVl0OkAKCi1O
         OdY1eP3vw6QCI+TLLU9zmE4kK9YMUznTlA9kpakMF3Xek6ODXjg5G0ckigxPeQ6PnQTr
         xKTRAJQvX7AQXUEfQBsmhLNKBXZBYiTR9IdgL+sdI3dYd84y/u7P5/b/+uCQdkrFX66j
         q5FT1Nd1uwlJ3s6Vlab8mtIB661WxZlZe36gU9quNpCOUdkUfwS3vviMUJFVx6OzhG96
         xXuA==
X-Gm-Message-State: AGi0PuaWNk/mHphUGdhwecuAiFyASjuECzx9YuslzENNWAdA1GOh+6v/
        GCBbCZbr45GiYI8u+o6fiQw=
X-Google-Smtp-Source: APiQypLO/JCx0siYonLc01nPmvEppo2MGoXGHSvikL+kpEMHv5xhTlkajcTL8EIyaI11TTvXMAlb4w==
X-Received: by 2002:a63:5250:: with SMTP id s16mr10901872pgl.115.1589227795826;
        Mon, 11 May 2020 13:09:55 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:09:55 -0700 (PDT)
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
Subject: [PATCH v5 02/15] qla2xxx: Suppress two recently introduced compiler warnings
Date:   Mon, 11 May 2020 13:09:33 -0700
Message-Id: <20200511200946.7675-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org>
References: <20200511200946.7675-1-bvanassche@acm.org>
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
