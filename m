Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8013C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D7B6113D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhJTVos (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhJTVoq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:44:46 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35898C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:42:32 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x123-20020a626381000000b0044da6d19df6so2567389pfb.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=esmIH5744cgQv95ezcRFuqCsC+7pCLMg68diJU8YDWQ=;
        b=h1fUC3pwCb1GV8I0MdtKM6n4NEaYOd2/UcMkDLBbDqA2B84KiYDU9+AZZgUwvTZktb
         608mg9RosXdDWPDmn/qOwLs6m7s1LCwnuAtDFvNrjGl2LmcEEAqALNApwM7dzAIFSDrb
         iDGbbN19x2x0sgbBZQ68vh+O8OO+XNgKZg9v8P7P+DycnYplMu0PpYA/3x/qi46fDAGj
         uaPahue3SWQg98NXgRHvuR5xKN8nERXjZXMw+dlEu+KTC5EUP2ryZGVJC5mu697g1HHa
         cqCc47dJlDMGp/sc6PhQOgkNU34Vc0JNS7aw/k6U8Pcu82Qe2zJD5BRosfZUjYW/V8pb
         astQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=esmIH5744cgQv95ezcRFuqCsC+7pCLMg68diJU8YDWQ=;
        b=x0Xh3QtGtEM+yjGdNYfTGEcj0sw/wzC1bFg/wfggR0L4l1qome6Lqsab91sVn5paED
         eC+VUUQ6p0eUrgik9bKTLUBFxudQehP6LdulLvE6xTPq0yEsOdvc5htUjY2KqqsM7HI1
         RrptQofyM+H1oo3lJdKaSVrsJE2fYvZ2NDz1H5nJpKmGjylSFeQzxuEPm0I60Tym3SD4
         1wTt0yg51bzEwpM7GvgsleiAyGekHQOS144fQMSp1VZYdqD/+ZJ4y3bihxzA25J9Akby
         BIRc815vCIn27ubKswbs6uzXbvdK/jsyKvKw4L5IU1BJkBD6BkbXUhNuNcZGmwEEWNEg
         eMIg==
X-Gm-Message-State: AOAM530lZBFjC68hPSJb2aRpH5f1gtsRa1yjRuO8BFHqduJVy2NPe6pn
        Smri/rMQtyZ7QbKdOBmxm+OBrIq8sKj7CCFa
X-Google-Smtp-Source: ABdhPJwMldoYN3BJ+A8taVz+MFfTXwfPboECW/lmsDqPuBxZhHG/ZklVFiP1FG61zdjqznVoh4a51vbPU1y7p9No
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2c5:13:a1d4:87fc:d5c6:fa8f])
 (user=changyuanl job=sendgmr) by 2002:a17:90a:ec14:: with SMTP id
 l20mr154342pjy.0.1634766151280; Wed, 20 Oct 2021 14:42:31 -0700 (PDT)
Date:   Wed, 20 Oct 2021 14:42:07 -0700
In-Reply-To: <20211020214207.1248986-1-changyuanl@google.com>
Message-Id: <20211020214207.1248986-3-changyuanl@google.com>
Mime-Version: 1.0
References: <20211020214207.1248986-1-changyuanl@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v1 2/2] scsi: pm80xx: Add pm80xx_mpi_build_cmd tracepoint
From:   Changyuan Lyu <changyuanl@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Changyuan Lyu <changyuanl@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

pm8001_mpi_build_cmd() prepares and sends all commands to a controller.
Having pm80xx_mpi_build_cmd tracepoint can help us with latency issues.

this patch depends on patch "scsi: pm80xx: Add tracepoints".

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c         |  5 +++++
 drivers/scsi/pm8001/pm80xx_tracepoints.h | 28 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 63690508313b..a56ae05bb9d3 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -42,6 +42,7 @@
  #include "pm8001_hwi.h"
  #include "pm8001_chips.h"
  #include "pm8001_ctl.h"
+ #include "pm80xx_tracepoints.h"
 
 /**
  * read_main_config_table - read the configure table and save it.
@@ -1324,6 +1325,10 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 	unsigned long flags;
 	int q_index = circularQ - pm8001_ha->inbnd_q_tbl;
 	int rv;
+	u32 htag = le32_to_cpu(*(__le32 *)payload);
+
+	trace_pm80xx_mpi_build_cmd(pm8001_ha->id, opCode, htag, q_index,
+		circularQ->producer_idx, circularQ->consumer_index);
 
 	WARN_ON(q_index >= PM8001_MAX_INB_NUM);
 	spin_lock_irqsave(&circularQ->iq_lock, flags);
diff --git a/drivers/scsi/pm8001/pm80xx_tracepoints.h b/drivers/scsi/pm8001/pm80xx_tracepoints.h
index 84fcfecfd624..5e669a8a9344 100644
--- a/drivers/scsi/pm8001/pm80xx_tracepoints.h
+++ b/drivers/scsi/pm8001/pm80xx_tracepoints.h
@@ -75,6 +75,34 @@ TRACE_EVENT(pm80xx_request_complete,
 		    __entry->running_req)
 );
 
+TRACE_EVENT(pm80xx_mpi_build_cmd,
+	    TP_PROTO(u32 id, u32 opc, u32 htag, u32 qi, u32 pi, u32 ci),
+
+	    TP_ARGS(id, opc, htag, qi, pi, ci),
+
+	    TP_STRUCT__entry(
+		    __field(u32, id)
+		    __field(u32, opc)
+		    __field(u32, htag)
+		    __field(u32, qi)
+		    __field(u32, pi)
+		    __field(u32, ci)
+		    ),
+
+	    TP_fast_assign(
+		    __entry->id = id;
+		    __entry->opc = opc;
+		    __entry->htag = htag;
+		    __entry->qi = qi;
+		    __entry->pi = pi;
+		    __entry->ci = ci;
+		    ),
+
+	    TP_printk("ctlr_id = %u opc = %#x htag = %#x QI = %u PI = %u CI = %u",
+		    __entry->id, __entry->opc, __entry->htag, __entry->qi,
+		    __entry->pi, __entry->ci)
+);
+
 #endif /* _TRACE_PM80XX_H_ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.33.0.1079.g6e70778dc9-goog

