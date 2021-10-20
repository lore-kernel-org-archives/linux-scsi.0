Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC409C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1FF361130
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhJTVop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbhJTVoo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:44:44 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23F6C061749
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:42:29 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l19-20020a637c53000000b00299c1f17664so6665149pgn.7
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=euzjJ+MpNFQ/1QYkiwkYepO0Kk+4STlAQZDVNgrOHbk=;
        b=rWLswHA8W0gK2CiXoFEUshxzRJbLApvWUGqr8RVX6S9slipHV87SMkVfmK7Nw+GJ1J
         CmLWRq98xpr3NWQH2xvr0u3Uz0jrhhiv9FNl3whR7ZGWAGL7etZ9WNEIkhOVeOFxEttD
         XSuSF0PvzhG9F3P2cOQkQ623RdXs+g9JSUXTBm/wAHzVCYF1vNnJKiR64IkxRUNTXbyj
         R0NPi1RCbBoYRouC9DJFHrHGxWBZSB11AIvNqCSK+Nhq97Wd+h2vnigN49rdyVFCBtGC
         JwYClI98XtVKVaevsxgtw3uWcMj6zOqOrncxOUXu+ywOD/y4N3i4ddR7sYg7LyveY4sw
         5OCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=euzjJ+MpNFQ/1QYkiwkYepO0Kk+4STlAQZDVNgrOHbk=;
        b=bXq1+Xlu/8+BsBV5d810+KUGv35re/jy+2OVzuXvywGR4jMz7hSx6mFdPQrRqB1SWa
         2P2kPBTHUQiOWWd2q2/ojVKMlSwvuAdoG2g5EpNCOANmWKPYj3H7GQSpREjd6lvSX2nI
         IDfGevGaaprpjnCBaM242fRQvWFSRkIIhzdEnELF1QCUxI2mksDJ23d4ZaFdnRC8wNuu
         ZlIza2ntu0pLXd96FmrfO5FdhE3cODINoxN3BhkZL0ssGqoHTYbd82Dv4saY0T+EWtxK
         nez/Zy03JdE83xvaRtl4BvXXWx0cNnz83/oKWat6GIp9hVdRBMM6WmBu3TRu5SAS2j8h
         Zw2g==
X-Gm-Message-State: AOAM531K7FG87rtrA4+uk9fKRVCzWkoXa4z1nGbqCqTcpNu+AZG94niH
        Uk9N5UJtFthmd+aKezJeLGNVNvUvsNH1C4pr
X-Google-Smtp-Source: ABdhPJwhHbWJT/0Vyr3DPSw0fBhx7PjKlQvAuHMXL3gZbvhkk2X/qoslkAsPl0b9Czwzp1gLU6oLWQ+R+eeFcVXQ
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2c5:13:a1d4:87fc:d5c6:fa8f])
 (user=changyuanl job=sendgmr) by 2002:a63:ed4f:: with SMTP id
 m15mr1334523pgk.471.1634766149094; Wed, 20 Oct 2021 14:42:29 -0700 (PDT)
Date:   Wed, 20 Oct 2021 14:42:06 -0700
In-Reply-To: <20211020214207.1248986-1-changyuanl@google.com>
Message-Id: <20211020214207.1248986-2-changyuanl@google.com>
Mime-Version: 1.0
References: <20211020214207.1248986-1-changyuanl@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v1 1/2] scsi: pm80xx: Add tracepoints
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

Tracepoints for tracking controller and ATA commands issued and
completed.

Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 drivers/scsi/pm8001/Makefile             |  7 +-
 drivers/scsi/pm8001/pm8001_sas.c         | 16 +++++
 drivers/scsi/pm8001/pm80xx_hwi.c         |  7 ++
 drivers/scsi/pm8001/pm80xx_tracepoints.c | 10 +++
 drivers/scsi/pm8001/pm80xx_tracepoints.h | 85 ++++++++++++++++++++++++
 5 files changed, 123 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/pm8001/pm80xx_tracepoints.c
 create mode 100644 drivers/scsi/pm8001/pm80xx_tracepoints.h

diff --git a/drivers/scsi/pm8001/Makefile b/drivers/scsi/pm8001/Makefile
index 02b7338999cc..bbb51b7312f1 100644
--- a/drivers/scsi/pm8001/Makefile
+++ b/drivers/scsi/pm8001/Makefile
@@ -6,9 +6,12 @@
 
 
 obj-$(CONFIG_SCSI_PM8001) += pm80xx.o
+
+CFLAGS_pm80xx_tracepoints.o := -I$(src)
+
 pm80xx-y += pm8001_init.o \
 		pm8001_sas.o  \
 		pm8001_ctl.o  \
 		pm8001_hwi.o  \
-		pm80xx_hwi.o
-
+		pm80xx_hwi.o  \
+		pm80xx_tracepoints.o
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 32e60f0c3b14..fcd12da1125c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -40,6 +40,7 @@
 
 #include <linux/slab.h>
 #include "pm8001_sas.h"
+#include "pm80xx_tracepoints.h"
 
 /**
  * pm8001_find_tag - from sas task to find out  tag that belongs to this task
@@ -527,6 +528,9 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx)
 {
+	struct ata_queued_cmd *qc;
+	struct pm8001_device *pm8001_dev;
+
 	if (!ccb->task)
 		return;
 	if (!sas_protocol_ata(task->task_proto))
@@ -549,6 +553,18 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 		/* do nothing */
 		break;
 	}
+
+	if (sas_protocol_ata(task->task_proto)) {
+		// For SCSI/ATA commands uldd_task points to ata_queued_cmd
+		qc = task->uldd_task;
+		pm8001_dev = ccb->device;
+		trace_pm80xx_request_complete(pm8001_ha->id,
+			pm8001_dev ? pm8001_dev->attached_phy : PM8001_MAX_PHYS,
+			ccb_idx, 0 /* ctlr_opcode not known */,
+			qc ? qc->tf.command : 0, // ata opcode
+			pm8001_dev ? atomic_read(&pm8001_dev->running_req) : -1);
+	}
+
 	task->lldd_task = NULL;
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6ffe17b849ae..015244e0227b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -42,6 +42,7 @@
  #include "pm80xx_hwi.h"
  #include "pm8001_chips.h"
  #include "pm8001_ctl.h"
+#include "pm80xx_tracepoints.h"
 
 #define SMP_DIRECT 1
 #define SMP_INDIRECT 2
@@ -4504,6 +4505,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task = ccb->task;
 	struct domain_device *dev = task->dev;
 	struct pm8001_device *pm8001_ha_dev = dev->lldd_dev;
+	struct ata_queued_cmd *qc = task->uldd_task;
 	u32 tag = ccb->ccb_tag;
 	int ret;
 	u32 q_index, cpu_id;
@@ -4723,6 +4725,11 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			}
 		}
 	}
+	trace_pm80xx_request_issue(pm8001_ha->id,
+				ccb->device ? ccb->device->attached_phy : PM8001_MAX_PHYS,
+				ccb->ccb_tag, opc,
+				qc ? qc->tf.command : 0, // ata opcode
+				ccb->device ? atomic_read(&ccb->device->running_req) : 0);
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
 			&sata_cmd, sizeof(sata_cmd), q_index);
 	return ret;
diff --git a/drivers/scsi/pm8001/pm80xx_tracepoints.c b/drivers/scsi/pm8001/pm80xx_tracepoints.c
new file mode 100644
index 000000000000..344aface9cdb
--- /dev/null
+++ b/drivers/scsi/pm8001/pm80xx_tracepoints.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Trace events in pm8001 driver.
+ *
+ * Copyright 2020 Google LLC
+ * Author: Akshat Jain <akshatzen@google.com>
+ */
+
+#define CREATE_TRACE_POINTS
+#include "pm80xx_tracepoints.h"
diff --git a/drivers/scsi/pm8001/pm80xx_tracepoints.h b/drivers/scsi/pm8001/pm80xx_tracepoints.h
new file mode 100644
index 000000000000..84fcfecfd624
--- /dev/null
+++ b/drivers/scsi/pm8001/pm80xx_tracepoints.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Trace events in pm8001 driver.
+ *
+ * Copyright 2020 Google LLC
+ * Author: Akshat Jain <akshatzen@google.com>
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM pm80xx
+
+#if !defined(_TRACE_PM80XX_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PM80XX_H
+
+#include <linux/tracepoint.h>
+#include "pm8001_sas.h"
+
+TRACE_EVENT(pm80xx_request_issue,
+	    TP_PROTO(u32 id, u32 phy_id, u32 htag, u32 ctlr_opcode,
+		     u16 ata_opcode, int running_req),
+
+	    TP_ARGS(id, phy_id, htag, ctlr_opcode, ata_opcode, running_req),
+
+	    TP_STRUCT__entry(
+		    __field(u32, id)
+		    __field(u32, phy_id)
+		    __field(u32, htag)
+		    __field(u32, ctlr_opcode)
+		    __field(u16,  ata_opcode)
+		    __field(int, running_req)
+		    ),
+
+	    TP_fast_assign(
+		    __entry->id = id;
+		    __entry->phy_id = phy_id;
+		    __entry->htag = htag;
+		    __entry->ctlr_opcode = ctlr_opcode;
+		    __entry->ata_opcode = ata_opcode;
+		    __entry->running_req = running_req;
+		    ),
+
+	    TP_printk("ctlr_id = %u phy_id = %u htag = %#x, ctlr_opcode = %#x ata_opcode = %#x running_req = %d",
+		    __entry->id, __entry->phy_id, __entry->htag,
+		    __entry->ctlr_opcode, __entry->ata_opcode,
+		    __entry->running_req)
+);
+
+TRACE_EVENT(pm80xx_request_complete,
+	    TP_PROTO(u32 id, u32 phy_id, u32 htag, u32 ctlr_opcode,
+		     u16 ata_opcode, int running_req),
+
+	    TP_ARGS(id, phy_id, htag, ctlr_opcode, ata_opcode, running_req),
+
+	    TP_STRUCT__entry(
+		    __field(u32, id)
+		    __field(u32, phy_id)
+		    __field(u32, htag)
+		    __field(u32, ctlr_opcode)
+		    __field(u16,  ata_opcode)
+		    __field(int, running_req)
+		    ),
+
+	    TP_fast_assign(
+		    __entry->id = id;
+		    __entry->phy_id = phy_id;
+		    __entry->htag = htag;
+		    __entry->ctlr_opcode = ctlr_opcode;
+		    __entry->ata_opcode = ata_opcode;
+		    __entry->running_req = running_req;
+		    ),
+
+	    TP_printk("ctlr_id = %u phy_id = %u htag = %#x, ctlr_opcode = %#x ata_opcode = %#x running_req = %d",
+		    __entry->id, __entry->phy_id, __entry->htag,
+		    __entry->ctlr_opcode, __entry->ata_opcode,
+		    __entry->running_req)
+);
+
+#endif /* _TRACE_PM80XX_H_ */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE pm80xx_tracepoints
+
+#include <trace/define_trace.h>
-- 
2.33.0.1079.g6e70778dc9-goog

