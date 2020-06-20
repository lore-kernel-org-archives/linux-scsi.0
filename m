Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F55BC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D7C522464
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Qw+hqBbO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgFTHBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:01:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34466 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgFTHAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 03:00:55 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200620070050epoutp03258b389d8607658b45caec2795b8d33c~aLmnNhldV0663806638epoutp03C
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 07:00:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200620070050epoutp03258b389d8607658b45caec2795b8d33c~aLmnNhldV0663806638epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592636450;
        bh=R2B8N76knPMfL2vDhI8B83Hls3z12y5K97ZpJQEXxnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qw+hqBbOY5peLv5eIsWCU3nWiHcp+KVN+6qR4aIKNnMVdJEAJ7SdsxxXI+fwP0qFg
         gwLifb2hmbHBd0rmiWigC0YSdKLUElaxCCDBkiMrtlt8L8iAW4uDy0roP2umilvDd7
         ZEydaMzbS15CXO49D6GsUeA5bJFsOXivSksG1J7Q=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200620070049epcas2p3117478f099320507b39606ff90544516~aLmmmPfPM0859408594epcas2p3L;
        Sat, 20 Jun 2020 07:00:49 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49pmlz56HPzMqYkb; Sat, 20 Jun
        2020 07:00:47 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.AF.27013.F14BDEE5; Sat, 20 Jun 2020 16:00:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200620070047epcas2p37229d52d479df9f64ee4fc14f469acf9~aLmkj0HYE1099010990epcas2p3k;
        Sat, 20 Jun 2020 07:00:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200620070047epsmtrp2d11dd0ed13e1107f0c2624e9ef268062~aLmkjGNiX0123701237epsmtrp2O;
        Sat, 20 Jun 2020 07:00:47 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-fe-5eedb41f65a4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.06.08303.F14BDEE5; Sat, 20 Jun 2020 16:00:47 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200620070047epsmtip288e78a329ab3b9f48d73239cb9ed2f49~aLmkW_5Wl0454504545epsmtip2R;
        Sat, 20 Jun 2020 07:00:47 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 2/2] exynos-ufs: support command history
Date:   Sat, 20 Jun 2020 15:53:12 +0900
Message-Id: <1592635992-35619-2-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmha78lrdxBqdvqFk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3J4uaWoywW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjKscmIzUxJbVIITUvOT8lMy/dVsk7
        ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hGJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+
        cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsbeJQIFUyIqfv7YydbAOMuzi5GT
        Q0LAROJV8yPmLkYuDiGBHYwS+/e9Y4VwPjFKXJu7ig3C+cwosfRKMzNMy+qm61BVuxglurac
        Z4dwfjBKLFu3iRWkik1AU+LpzalMIAkRgRuMEnOaD4MlmAXUJXZNOMEEYgsL2Eu0/LkAZrMI
        qEqcPn+DDcTmFXCVWPn6NTvEOjmJm+c6wVZzCrhJXJ/3kwUi/pVd4sxcGwjbReLOyj6o84Ql
        Xh3fAtUrJfH53V42CLteYt/UBrCzJQR6GCWe7vvHCJEwlpj1rB3I5gA6TlNi/S59EFNCQFni
        yC0WiJP5JDoO/2WHCPNKdLQJQTQqS/yaNBlqiKTEzJt3oEo8JD7vg4bPTEaJHS9amScwys1C
        mL+AkXEVo1hqQXFuemqxUYEJcoRtYgSnQS2PHYyz337QO8TIxMF4iFGCg1lJhPfw+zdxQrwp
        iZVVqUX58UWlOanFhxhNgUE3kVlKNDkfmIjzSuINTY3MzAwsTS1MzYwslMR531ldiBMSSE8s
        Sc1OTS1ILYLpY+LglGpgCj1fo/3pm/WK2SwzQ1UybxUbcLH67To74xyLEsuxb9s2uV0tEpym
        xZew9Nexs/t+ZvTfU3se7ByZ/9Nb+mqugNixg68e9SZ6Os6S/87Xfpwluk6mbfvSrTenHW3q
        X/Lp0+ek6krps523jkvF7NOu8z590POfdty/K/l1SSdOWO9Y8na+dtDyqWxMv/ivRotdFa5u
        uZeYYV+ubrXlfG37kt9b0358erP0jkXK2i9m0nL9b44dL8/YUfDX5Nckx8Ll3esDjjN1iPyv
        eSxoXMuw295NKOLEVO0yRfuSp8GnhXyTts7fHf/lmOC8lQe+bmdecmXKmm1NWycbP1gg7Ldy
        zeHNjGcjddn2n+E7U8B5ME2JpTgj0VCLuag4EQAY+UHeDAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSvK78lrdxBt1veS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJWxd4lAwZSI
        ip8/drI1MM7y7GLk5JAQMJFY3XSdtYuRi0NIYAejxN5DG1khEpISJ3Y+Z4SwhSXutxyBKvrG
        KPF16l2wIjYBTYmnN6cygSREBB4xSvye2ckOkmAWUJfYNeEEE4gtLGAv0fLnApjNIqAqcfr8
        DTYQm1fAVWLl69fsEBvkJG6e62QGsTkF3CSuz/vJ0sXIAbTNVeLFBJ8JjHwLGBlWMUqmFhTn
        pucWGxYY5aWW6xUn5haX5qXrJefnbmIEh6uW1g7GPas+6B1iZOJgPMQowcGsJMJ7+P2bOCHe
        lMTKqtSi/Pii0pzU4kOM0hwsSuK8X2ctjBMSSE8sSc1OTS1ILYLJMnFwSjUwadnN1hZ/wGNz
        Iydwz6kN1iuvvT5l5tfMc0NSOTUvdierRJ7DHIasG/mv5h/c96QtLq637L7BwqB593+FbZTL
        c2fcyajr3eysvvpkT/+PN79XHWM75f1bb46dbMvt07Ncv//5+GvKDJOrM3u5/xuUnV4ScZ9t
        V+8UVyH27Y4chU45aoanWmMf96g6NH/hFZaUWLRX0Tf8fFDHpxUV7OKe3TvzKudLSe313bh6
        3czepJ1JWQ3OqR+0Z8zxlzn3Rjr51/v7wfmlxk+e3PVUnb8msHRbS/+b2ldxe1n6vBldri25
        erPTvoLr1sqLv96wzZ96juFFcJhQyESuamFhlSuFDqXFPOdUH5ivnOqcYn5KiaU4I9FQi7mo
        OBEAQmbBDsYCAAA=
X-CMS-MailID: 20200620070047epcas2p37229d52d479df9f64ee4fc14f469acf9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620070047epcas2p37229d52d479df9f64ee4fc14f469acf9
References: <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
        <CGME20200620070047epcas2p37229d52d479df9f64ee4fc14f469acf9@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is to record contexts of incoming commands
in a circular queue. ufshcd.c has already some function
tracer calls to get command history but ftrace would be
gone when system dies before you get the information,
such as panic cases.

Setting EN_PRINT_UFS_LOG to one enables to print
information in the circular queue whenever ufshcd.c
invokes a dbg_register_dump callback.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/Makefile         |   2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 208 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  19 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  43 ++++++++
 drivers/scsi/ufs/ufs-exynos.h     |  13 +++
 5 files changed, 284 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index f0c5b95..d9e4da7 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
-obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
+obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o ufs-exynos-dbg.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
diff --git a/drivers/scsi/ufs/ufs-exynos-dbg.c b/drivers/scsi/ufs/ufs-exynos-dbg.c
new file mode 100644
index 0000000..2265af7
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * UFS Exynos debugging functions
+ *
+ * Copyright (C) 2020 Samsung Electronics Co., Ltd.
+ * Author: Kiwoong Kim <kwmad.kim@samsung.com>
+ *
+ */
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include "ufshcd.h"
+#include "ufs-exynos.h"
+#include "ufs-exynos-if.h"
+
+#define EN_PRINT_UFS_LOG 1
+
+/* Structure for ufs cmd logging */
+#define MAX_CMD_LOGS    32
+
+struct cmd_data {
+	unsigned int tag;
+	unsigned int sct;
+	unsigned long lba;
+	u64 start_time;
+	u64 end_time;
+	u64 outstanding_reqs;
+	int retries;
+	unsigned char op;
+};
+
+struct ufs_cmd_info {
+	u32 total;
+	u32 last;
+	struct cmd_data data[MAX_CMD_LOGS];
+	struct cmd_data *pdata[32];	/* Currently, 32 slots */
+};
+
+#define DBG_NUM_OF_HOSTS	1
+struct ufs_s_dbg_mgr {
+	struct ufs_exynos_handle *handle;
+	int active;
+	u64 first_time;
+	u64 time;
+
+	/* cmd log */
+	struct ufs_cmd_info cmd_info;
+	struct cmd_data cmd_log;		/* temp buffer to put */
+	spinlock_t cmd_lock;
+};
+static struct ufs_s_dbg_mgr ufs_s_dbg[DBG_NUM_OF_HOSTS];
+static int ufs_s_dbg_mgr_idx;
+
+static void ufs_s_print_cmd_log(struct ufs_s_dbg_mgr *mgr, struct device *dev)
+{
+	struct ufs_cmd_info *cmd_info = &mgr->cmd_info;
+	struct cmd_data *data = cmd_info->data;
+	u32 i;
+	u32 last;
+	u32 max = MAX_CMD_LOGS;
+	unsigned long flags;
+	u32 total;
+
+	spin_lock_irqsave(&mgr->cmd_lock, flags);
+	total = cmd_info->total;
+	if (cmd_info->total < max)
+		max = cmd_info->total;
+	last = (cmd_info->last + MAX_CMD_LOGS - 1) % MAX_CMD_LOGS;
+	spin_unlock_irqrestore(&mgr->cmd_lock, flags);
+
+	dev_err(dev, ":---------------------------------------------------\n");
+	dev_err(dev, ":\t\tSCSI CMD(%u)\n", total - 1);
+	dev_err(dev, ":---------------------------------------------------\n");
+	dev_err(dev, ":OP, TAG, LBA, SCT, RETRIES, STIME, ETIME, REQS\n\n");
+
+	for (i = 0 ; i < max ; i++, data++) {
+		dev_err(dev, ": 0x%02x, %02d, 0x%08lx, 0x%04x, %d, %llu, %llu, 0x%llx %s",
+				data->op,
+				data->tag,
+				data->lba,
+				data->sct,
+				data->retries,
+				data->start_time,
+				data->end_time,
+				data->outstanding_reqs,
+				((last == i) ? "<--" : " "));
+		if (last == i)
+			dev_err(dev, "\n");
+	}
+}
+
+static void ufs_s_put_cmd_log(struct ufs_s_dbg_mgr *mgr,
+			      struct cmd_data *cmd_data)
+{
+	struct ufs_cmd_info *cmd_info = &mgr->cmd_info;
+	unsigned long flags;
+	struct cmd_data *pdata;
+
+	spin_lock_irqsave(&mgr->cmd_lock, flags);
+	pdata = &cmd_info->data[cmd_info->last];
+	++cmd_info->total;
+	++cmd_info->last;
+	cmd_info->last = cmd_info->last % MAX_CMD_LOGS;
+	spin_unlock_irqrestore(&mgr->cmd_lock, flags);
+
+	pdata->op = cmd_data->op;
+	pdata->tag = cmd_data->tag;
+	pdata->lba = cmd_data->lba;
+	pdata->sct = cmd_data->sct;
+	pdata->retries = cmd_data->retries;
+	pdata->start_time = cmd_data->start_time;
+	pdata->end_time = 0;
+	pdata->outstanding_reqs = cmd_data->outstanding_reqs;
+	cmd_info->pdata[cmd_data->tag] = pdata;
+}
+
+/*
+ * EXTERNAL FUNCTIONS
+ *
+ * There are two classes that are to initialize data structures for debug
+ * and to define actual behavior.
+ */
+void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
+{
+	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
+
+	if (mgr->active == 0)
+		goto out;
+
+	mgr->time = cpu_clock(raw_smp_processor_id());
+
+#if EN_PRINT_UFS_LOG
+	ufs_s_print_cmd_log(mgr, dev);
+#endif
+
+	if (mgr->first_time == 0ULL)
+		mgr->first_time = mgr->time;
+out:
+	return;
+}
+
+void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
+			      struct ufs_hba *hba, struct scsi_cmnd *cmd)
+{
+	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
+	int cpu = raw_smp_processor_id();
+	struct cmd_data *cmd_log = &mgr->cmd_log;	/* temp buffer to put */
+	unsigned long lba = (cmd->cmnd[2] << 24) |
+					(cmd->cmnd[3] << 16) |
+					(cmd->cmnd[4] << 8) |
+					(cmd->cmnd[5] << 0);
+	unsigned int sct = (cmd->cmnd[7] << 8) |
+					(cmd->cmnd[8] << 0);
+
+	if (mgr->active == 0)
+		return;
+
+	cmd_log->start_time = cpu_clock(cpu);
+	cmd_log->op = cmd->cmnd[0];
+	cmd_log->tag = cmd->request->tag;
+
+	/* This function runtime is protected by spinlock from outside */
+	cmd_log->outstanding_reqs = hba->outstanding_reqs;
+
+	/* unmap */
+	if (cmd->cmnd[0] != UNMAP)
+		cmd_log->lba = lba;
+
+	cmd_log->sct = sct;
+	cmd_log->retries = cmd->allowed;
+
+	ufs_s_put_cmd_log(mgr, cmd_log);
+}
+
+void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
+			    struct ufs_hba *hba, struct scsi_cmnd *cmd)
+{
+	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
+	struct ufs_cmd_info *cmd_info = &mgr->cmd_info;
+	int cpu = raw_smp_processor_id();
+	int tag = cmd->request->tag;
+
+	if (mgr->active == 0)
+		return;
+
+	cmd_info->pdata[tag]->end_time = cpu_clock(cpu);
+}
+
+int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle)
+{
+	struct ufs_s_dbg_mgr *mgr;
+
+	if (ufs_s_dbg_mgr_idx >= DBG_NUM_OF_HOSTS)
+		return -1;
+
+	mgr = &ufs_s_dbg[ufs_s_dbg_mgr_idx++];
+	handle->private = (void *)mgr;
+	mgr->handle = handle;
+	mgr->active = 1;
+
+	/* cmd log */
+	spin_lock_init(&mgr->cmd_lock);
+
+	return 0;
+}
+MODULE_AUTHOR("Kiwoong Kim <kwmad.kim@samsung.com>");
+MODULE_DESCRIPTION("Exynos UFS debug information");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.1");
diff --git a/drivers/scsi/ufs/ufs-exynos-if.h b/drivers/scsi/ufs/ufs-exynos-if.h
new file mode 100644
index 0000000..33f7187
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-if.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * UFS Exynos debugging functions
+ *
+ * Copyright (C) 2020 Samsung Electronics Co., Ltd.
+ * Author: Kiwoong Kim <kwmad.kim@samsung.com>
+ *
+ */
+#ifndef _UFS_EXYNOS_IF_H_
+#define _UFS_EXYNOS_IF_H_
+
+#define UFS_VS_MMIO_VER 1
+
+/* more members would be added in the future */
+struct ufs_exynos_handle {
+	void *private;
+};
+
+#endif /* _UFS_EXYNOS_IF_H_ */
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 440f2af..50437db 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1008,6 +1008,12 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
 	exynos_ufs_config_smu(ufs);
+
+	/* init dbg */
+	ret = exynos_ufs_init_dbg(ufs->handle);
+	if (ret)
+		return ret;
+	spin_lock_init(&ufs->dbg_lock);
 	return 0;
 
 phy_off:
@@ -1210,6 +1216,41 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static void exynos_ufs_dbg_register_dump(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ufs->dbg_lock, flags);
+	if (ufs->under_dump == 0)
+		ufs->under_dump = 1;
+	else {
+		spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+		goto out;
+	}
+	spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+
+	exynos_ufs_dump_info(ufs->handle, hba->dev);
+
+	spin_lock_irqsave(&ufs->dbg_lock, flags);
+	ufs->under_dump = 0;
+	spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+out:
+	return;
+}
+
+static void exynos_ufs_cmd_log(struct ufs_hba *hba,
+					 struct scsi_cmnd *cmd, int enter)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	struct ufs_exynos_handle *handle = ufs->handle;
+
+	if (enter == 1)
+		exynos_ufs_cmd_log_start(handle, hba, cmd);
+	else if (enter == 2)
+		exynos_ufs_cmd_log_end(handle, hba, cmd);
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1221,6 +1262,8 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.dbg_register_dump		= exynos_ufs_dbg_register_dump,
+	.cmd_log			= exynos_ufs_cmd_log,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 76d6e39..14347fb 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -8,6 +8,7 @@
 
 #ifndef _UFS_EXYNOS_H_
 #define _UFS_EXYNOS_H_
+#include "ufs-exynos-if.h"
 
 /*
  * UNIPRO registers
@@ -212,6 +213,10 @@ struct exynos_ufs {
 #define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
 #define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
 #define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
+
+	struct ufs_exynos_handle *handle;
+	spinlock_t dbg_lock;
+	int under_dump;
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
@@ -284,4 +289,12 @@ struct exynos_ufs_uic_attr exynos7_uic_attr = {
 	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
 	.pa_dbg_option_suite		= 0x30103,
 };
+
+/* public function declarations */
+void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev);
+void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
+			      struct ufs_hba *hba, struct scsi_cmnd *cmd);
+void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
+			    struct ufs_hba *hba, struct scsi_cmnd *cmd);
+int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle);
 #endif /* _UFS_EXYNOS_H_ */
-- 
2.7.4

