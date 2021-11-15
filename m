Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979BEC43217
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 22:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8766E6321B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 22:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349045AbhKOWyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 17:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353656AbhKOWpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 17:45:05 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3BCC034019
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 13:57:56 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y125-20020a25dc83000000b005c2326bf744so28697616ybe.21
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 13:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=26TLofh9ASMJc7rQ40zYDRaWCefjRktZ9jUN6/Ys1FU=;
        b=hnyaipfKKZOBYgbYJ/M8WGBmmYWbm30mKoKgL1Qsgf4WrwMs5qL2LqfUZr9jzbvKVd
         AVNmHLcmA5SUCN55if0h4Ohon6YyWdF0Fz/6QfmBtBVgTw8mZzY7Iy41bnno31HxcQI3
         EtvFpn4U1JcoCFKWXKwYQ3wGLt+7nksQ0lFNJgja66L2HkmXiAKoLzs9cWwze2OZsCbA
         5ZC7f/dEjAJclygJXxO8tCMtCQ9T9VJzqxv9j971AUpWDanzSGnqm4by9IgarOJCxsVz
         dhu7L7dmpU4+fDIqzP1wvYd5AU7MdVRSyXgBM61BTU3zTLHtX9MmmDkMWWYN1Sp+w83H
         5Myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=26TLofh9ASMJc7rQ40zYDRaWCefjRktZ9jUN6/Ys1FU=;
        b=5NTzTLpSs4xDMbS2XCEcvja7N/APFYcPqQGFrvmeWyn5cRMMdgyhFFkH4nbbhAdJq2
         j/SGFzGsDemw8sSikvRL4CskwkcuBMgo0R9vWVk13xr0aFYY78qi9CgR9YF1Gfk1lBVM
         r58RazRsdze8vodmMYgW2l3CKRI/+SyGNaiVreKir9eT8KPSvOnVMJmcVJupdRt0wq7I
         anJq2CzS4AEwtEKx+9IzZd/zb9uBVVLplaE//wC1iFt8ZCiTT3g1aj2FX7mKMkIILITx
         nyAOTcafWujwDPWDvNxCS/ITxcdxNvzTOjZLREZl8J4+WqoJx+LVvlTqarN84qHmXjH9
         NPxw==
X-Gm-Message-State: AOAM530FNYDxCqw7ppU94Yckt7/anKkdMpcIXXLD+h7ejl3ZN4R8U+z2
        rIuPb0ZxiW1jtNQ2ABdz+CNu/TFzerYDctOx
X-Google-Smtp-Source: ABdhPJzHjlUGO7IbvV0sUHQ/Q134OIyd6HFmGJtn43OiL5buJlkWtKK+nuwPSltg7Z1Fieg0mmAWyazz7pTqJbmv
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2c5:13:f30c:72b6:c6d5:9b63])
 (user=changyuanl job=sendgmr) by 2002:a25:dcc7:: with SMTP id
 y190mr2549448ybe.369.1637013475998; Mon, 15 Nov 2021 13:57:55 -0800 (PST)
Date:   Mon, 15 Nov 2021 13:57:49 -0800
In-Reply-To: <20211115215750.131696-1-changyuanl@google.com>
Message-Id: <20211115215750.131696-2-changyuanl@google.com>
Mime-Version: 1.0
References: <20211115215750.131696-1-changyuanl@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 1/2] scsi: pm80xx: Add tracepoints
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
index 83e73009db5c..c9a16eef38c1 100644
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
index b9f6d83ff380..5e6ab7a3b996 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -42,6 +42,7 @@
  #include "pm80xx_hwi.h"
  #include "pm8001_chips.h"
  #include "pm8001_ctl.h"
+#include "pm80xx_tracepoints.h"
 
 #define SMP_DIRECT 1
 #define SMP_INDIRECT 2
@@ -4543,6 +4544,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task = ccb->task;
 	struct domain_device *dev = task->dev;
 	struct pm8001_device *pm8001_ha_dev = dev->lldd_dev;
+	struct ata_queued_cmd *qc = task->uldd_task;
 	u32 tag = ccb->ccb_tag;
 	int ret;
 	u32 q_index, cpu_id;
@@ -4762,6 +4764,11 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
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
2.34.0.rc1.387.gb447b232ab-goog

