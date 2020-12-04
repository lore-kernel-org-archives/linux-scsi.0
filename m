Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D2CC1B087
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 09:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA18B229C4
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 09:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbgLDJu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 04:50:56 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34563 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726136AbgLDJu4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 04:50:56 -0500
X-UUID: 6bb079f1f1dd46edb44ba9b6d7a7ff1e-20201204
X-UUID: 6bb079f1f1dd46edb44ba9b6d7a7ff1e-20201204
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 375920986; Fri, 04 Dec 2020 17:50:10 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Dec 2020 17:50:07 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Dec 2020 17:50:07 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, <huadian.liu@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 8/8] scsi: ufs-mediatek: Introduce event_notify implementation
Date:   Fri, 4 Dec 2020 17:50:07 +0800
Message-ID: <20201204095007.20639-9-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201204095007.20639-1-stanley.chu@mediatek.com>
References: <20201204095007.20639-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce event_notify implementation on MediaTek UFS platform.

A vendor-specific tracepoint is added that could be used
for debugging purpose.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek-trace.h | 37 +++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-mediatek.c       | 10 ++++++++
 2 files changed, 47 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-mediatek-trace.h

diff --git a/drivers/scsi/ufs/ufs-mediatek-trace.h b/drivers/scsi/ufs/ufs-mediatek-trace.h
new file mode 100644
index 000000000000..c36ca6de9636
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-mediatek-trace.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 MediaTek Inc.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ufs_mtk
+
+#if !defined(_TRACE_EVENT_UFS_MEDIATEK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EVENT_UFS_MEDIATEK_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(ufs_mtk_event,
+	TP_PROTO(unsigned int type, int data),
+	TP_ARGS(type, data),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, type)
+		__field(int, data)
+	),
+
+	TP_fast_assign(
+		__entry->type = type;
+		__entry->data = data;
+	),
+
+	TP_printk("ufs:event=%u data=%u",
+		  __entry->type, __entry->data)
+	);
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE ufs-mediatek-trace
+#include <trace/define_trace.h>
+
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 1d3c5cd4592e..b6755aab9a7b 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -24,6 +24,9 @@
 #include "unipro.h"
 #include "ufs-mediatek.h"
 
+#define CREATE_TRACE_POINTS
+#include "ufs-mediatek-trace.h"
+
 #define ufs_mtk_smc(cmd, val, res) \
 	arm_smccc_smc(MTK_SIP_UFS_CONTROL, \
 		      cmd, val, 0, 0, 0, 0, 0, &(res))
@@ -1002,6 +1005,12 @@ static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 	ufshcd_fixup_dev_quirks(hba, ufs_mtk_dev_fixups);
 }
 
+static void ufs_mtk_event_notify(struct ufs_hba *hba,
+				 enum ufs_event_type evt, void *data)
+{
+	trace_ufs_mtk_event(evt, (int)data);
+}
+
 /*
  * struct ufs_hba_mtk_vops - UFS MTK specific variant operations
  *
@@ -1021,6 +1030,7 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.resume              = ufs_mtk_resume,
 	.dbg_register_dump   = ufs_mtk_dbg_register_dump,
 	.device_reset        = ufs_mtk_device_reset,
+	.event_notify        = ufs_mtk_event_notify,
 };
 
 /**
-- 
2.18.0

