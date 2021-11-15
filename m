Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92526C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 22:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7283A63219
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 22:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349136AbhKOWy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 17:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353659AbhKOWpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 17:45:05 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9B7C03401B
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 13:57:58 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 184-20020a6217c1000000b0049f9aad0040so10581772pfx.21
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 13:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=r70Pz9lioIxVhnNU6YD1L58xYA7ih1W06W7FJYXg4Y8=;
        b=Xb8MW+QMKDP2CxkTAhZrCK20KMq/cPIJzR82SwpENDht0vQwSH5qJCPoTPV5oOn5c2
         0osBZBIYTcjlHuEuoVon+REvTeLjbvbRyqZG2Wrnw13OpY3acXfOR0WeKdGqa1CACWle
         PluAaI2u1M0PQhjdxh+d4OAr2MST8FIeKy7ySit/m6COj0I2qB8HD1RLaygKwSq/RIQ3
         INlzNRmCCXywp+ePmD+9ER4vbXh/rL8Wjx/HvTnahKJ8ZFmW5N6LYKThRoheJkUsKTOO
         rd75cOSN/cN2bir8gK9k1edhupEfgCAf9VdskeDleKinlNA1rZSHZZtawpDGXxYxEDxa
         ABmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r70Pz9lioIxVhnNU6YD1L58xYA7ih1W06W7FJYXg4Y8=;
        b=f1Logubk1nzK9WdfbsIVE/UVKMZvGxUuZZlJK9NActemm1PLO4hs/XcPtsFzEZCn5+
         iFzZlDUM+wkR1XLD3kYEkZGy6js0V5Kyss7UNUMhfGPQ7pSVTeUsNyLZW5251a/dyK+U
         mgNI9iNZVQ8WEHuaaEaddkEb/QJmujk0bS1sNlg5vKYhx0gvZSbKYCUlXWwBvJtkoI0M
         m7DBbe5Xz8IpFqkb8eZu28kZhVSNvdrcWkMp4Nlbb1ppX46ejl/md/q5WihPxU/sR+6t
         pgsgFOfL6xK7KsQDABTrzGvKg85hWpL4I0DOGqUUvyFRL4/kxVMeVgRfjfzlPMhHm/LH
         YPOQ==
X-Gm-Message-State: AOAM530GG8Iix7g9Mxl/XGQdctGXSzo3jewEsSzNsKbQBxaPsvU2QTqn
        iv9/Zkb3MNwpPeHJRJ3apmd8OGmu72os8V77
X-Google-Smtp-Source: ABdhPJxiPKcN/Slfy9PuPFGb3Kgsf8+xcdlvaaO0EmJnP6ErRoZ/CEr+7sqYUuiZkFk1FA3iU5QvRdpYzloNR0ew
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2c5:13:f30c:72b6:c6d5:9b63])
 (user=changyuanl job=sendgmr) by 2002:aa7:8059:0:b0:47e:5de6:5bc7 with SMTP
 id y25-20020aa78059000000b0047e5de65bc7mr36172932pfm.78.1637013478010; Mon,
 15 Nov 2021 13:57:58 -0800 (PST)
Date:   Mon, 15 Nov 2021 13:57:50 -0800
In-Reply-To: <20211115215750.131696-1-changyuanl@google.com>
Message-Id: <20211115215750.131696-3-changyuanl@google.com>
Mime-Version: 1.0
References: <20211115215750.131696-1-changyuanl@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 2/2] scsi: pm80xx: Add pm80xx_mpi_build_cmd tracepoint
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
index 124cb69740c6..a63362bdd884 100644
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
+		circularQ->producer_idx, le32_to_cpu(circularQ->consumer_index));
 
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
2.34.0.rc1.387.gb447b232ab-goog

