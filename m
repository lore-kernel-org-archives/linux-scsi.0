Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22F1C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8824220771
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 05:39:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jzTzTpS3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgGCFjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 01:39:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19820 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGCFjB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 01:39:01 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200703053858epoutp04790efe15ba22e1da6fcad5e757cee561~eJ32fYqt_0800008000epoutp04L
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 05:38:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200703053858epoutp04790efe15ba22e1da6fcad5e757cee561~eJ32fYqt_0800008000epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593754738;
        bh=x9YkgfGafDzolT8ccGGYgEgV7J+7k9qbu0xk3SsUflw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=jzTzTpS3S/6wNNf3Qz6o9DUWVEA37/b/yuBRvPZknh8ViagaAw6o59a2rQDDNc0g6
         p/az17UmYu8vmTbWbn6Qqti3fc5MexmXstefLO4AGstOR+Bohv4WIOPDnugA6lhdef
         +NQmigKAr/o5ApF5uYX4WEGqYwCY7mHRtEzUmJ1E=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200703053857epcas2p1fd5e81a89da1ee70a2678d60b4d6dbc3~eJ31qN7VI2169721697epcas2p1W;
        Fri,  3 Jul 2020 05:38:57 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49ykKW5XWVzMqYkf; Fri,  3 Jul
        2020 05:38:55 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.0D.27441.F64CEFE5; Fri,  3 Jul 2020 14:38:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053855epcas2p17dc1463fae3cfb0f8db0adb5e1c5a328~eJ3zexcBr0912809128epcas2p1e;
        Fri,  3 Jul 2020 05:38:55 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200703053855epsmtrp12f4af64251f48c16dda2101462f17e57~eJ3zd5foe0498904989epsmtrp1Y;
        Fri,  3 Jul 2020 05:38:55 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-4a-5efec46fd5d2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.AA.08382.F64CEFE5; Fri,  3 Jul 2020 14:38:55 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200703053855epsmtip1d7787c4b735fab2935cc60ba2a1c73dc~eJ3zJT4rI2379023790epsmtip1a;
        Fri,  3 Jul 2020 05:38:55 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v3 2/2] exynos-ufs: implement dbg_register_dump and
 compl_xfer_req
Date:   Fri,  3 Jul 2020 14:31:05 +0900
Message-Id: <9a3f8f8fed39aa7e07e20cf1ff25c708919ff2ea.1593752220.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593752220.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593752220.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmhW7+kX9xBt0f1C0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORmfZzxjKZiQWbF16y72BsYJ4V2MnBwSAiYS+94+YOli5OIQEtjBKHHp6yZGCOcTo8Sqq9+Z
        QKqEBL4xSlxuEIbpWHRiGzNE0V5Gib5919ghnB+MElP7H7OBVLEJaEo8vTmVCSQhIrCZSeLV
        gvvMIAlmAXWJXRNOgI0VFoiQuH+sjRHEZhFQlbi6bjoriM0rEC2x81wTK8Q6OYmb5zrBejkF
        LCVam++zo7K5gGomckj0PtzGAtHgIvGz6Qc7hC0s8er4FihbSuJlfxuUXS+xb2oDK0RzD6PE
        033/GCESxhKznrUD2RxAl2pKrN+lD2JKCChLHLnFAnE/n0TH4b/sEGFeiY42IYhGZYlfkyZD
        DZGUmHnzDtQmD4mvD+5AQwto06o/rSwTGOVnISxYwMi4ilEstaA4Nz212KjAGDn6NjGCU6mW
        +w7GGW8/6B1iZOJgPMQowcGsJMKboPovTog3JbGyKrUoP76oNCe1+BCjKTAgJzJLiSbnA5N5
        Xkm8oamRmZmBpamFqZmRhZI4b7HVhTghgfTEktTs1NSC1CKYPiYOTqkGJv23Jan/TrD1XmTY
        2Oq7tG7+zyvejznDHto370yX4DjHNbVE7cCntaUbi77Y90+t7Lia4dRzVa556+6XbfVLpK1b
        lDUcZpzova9h4Hrj/v+jfcenbv7DHmXamuDgXi5n80yNi0FN4k+xWW3fLO/I6+U2r0ziucpn
        7BfrPjmDfUpHTqaZZaAsq/SzbZudazLmX9N+KnVlkYYWl4t8vbKl8bXzr5UKHk1x5hDl3x9y
        yNX50Gup17zVgVKzT76eyLdpprgk2+Y5e0M73m6PjPDlFriRwnDWTX3Hk2XTbvEo6pxZGLZS
        dmHsG0X/Wi9Np8w3p5wFfv0r/H85+HXFB/0FOxI9vkq77i6MLjoWvOObEktxRqKhFnNRcSIA
        dD1YXy4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnG7+kX9xBqvn8Vo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZn2c8YymYkFmxdesu9gbGCeFdjJwcEgImEotObGPuYuTiEBLYzSjx
        59hHZoiEpMSJnc8ZIWxhifstR1hBbCGBb4wSCzeC2WwCmhJPb05lAmkWETjMJPF/63N2kASz
        gLrErgknmEBsYYEwiV27L4ANZRFQlbi6bjpYM69AtMTOc02sEAvkJG6e6wSr4RSwlGhtvs8O
        scxC4u7uuTjFJzAKLGBkWMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERwJWpo7GLev
        +qB3iJGJg/EQowQHs5IIb4Lqvzgh3pTEyqrUovz4otKc1OJDjNIcLErivDcKF8YJCaQnlqRm
        p6YWpBbBZJk4OKUamGqXXIxMllYVWz6l8UCfkBtHRcemLcpTP/lKMnT/DmWKj284w5igXT6h
        OaCXSepCvVxe5qWP/a8PNxnf414/87/S7JXLEhZ94A1u5z/VJtfEnscxufmF9MG5gt9qnmbO
        PXjnSvCToLM3e3ryiuuve33n+yNlFBK4K27miTyf5N2pJxyOlB1nWdwpcOxW4VwpLmmlWacO
        XXI5whruNpXnzBo5bb1/ZvdX/g6Ys4t3vZTVx7LJBxz3sUS+a1v0SmXn7dK8dcscDm+fc1v7
        mgrf+W2ftnnYz9L7/0nmROkvV0ejDR2n31hs7nApX3Fo/vOc7hXhGi/cfGYff61QVWPhfTA2
        ttPtC0+TVeoMh43SnUosxRmJhlrMRcWJAHx5oN7zAgAA
X-CMS-MailID: 20200703053855epcas2p17dc1463fae3cfb0f8db0adb5e1c5a328
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053855epcas2p17dc1463fae3cfb0f8db0adb5e1c5a328
References: <cover.1593752220.git.kwmad.kim@samsung.com>
        <CGME20200703053855epcas2p17dc1463fae3cfb0f8db0adb5e1c5a328@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch implements callbacks dbg_register_dump and
compl_xfer_req to store IO contexts or print them.

This includes functions to record contexts of incoming commands
in a circular queue. ufshcd.c has already some function
tracer calls to get command history but ftrace would be
gone when system dies before you get the information,
such as panic cases.

When you turn on CONFIG_SCSI_UFS_EXYNOS_CMD_LOG,
information in the circular queue whenever ufshcd.c
invokes a dbg_register_dump callback.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 202 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  63 +++++++++++-
 drivers/scsi/ufs/ufs-exynos.h     |  13 +++
 6 files changed, 308 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8cd9026..ebab446 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -172,3 +172,17 @@ config SCSI_UFS_EXYNOS
 
 	  Select this if you have UFS host controller on EXYNOS chipset.
 	  If unsure, say N.
+
+config SCSI_UFS_EXYNOS_CMD_LOG
+	bool "EXYNOS specific command log"
+	default n
+	depends on SCSI_UFS_EXYNOS
+	help
+	  This selects EXYNOS specific functions to get and even print
+	  some information to see what's happening at both command
+	  issue time completion time.
+	  The information may contain gerernal things as well as
+	  EXYNOS specific, such as vendor specific hardware contexts.
+
+	  Select this if you want to get and print the information.
+	  If unsure, say N.
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
index 0000000..39a79b6
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -0,0 +1,202 @@
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
+#define MAX_CMD_LOGS    32
+
+struct cmd_data {
+	unsigned int tag;
+	unsigned int sct;
+	u64 lba;
+	u64 start_time;
+	u64 end_time;
+	u64 outstanding_reqs;
+	int retries;
+	u8 op;
+};
+
+struct ufs_cmd_info {
+	u32 total;
+	u32 last;
+	struct cmd_data data[MAX_CMD_LOGS];
+	struct cmd_data *pdata[MAX_CMD_LOGS];
+};
+
+/*
+ * This structure points out several contexts on debugging
+ * per one host instant.
+ * Now command history exists in here but later handle may
+ * contains some mmio base addresses including vendor specific
+ * regions to get hardware contexts.
+ */
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
+		dev_err(dev, ": 0x%02x, %02d, 0x%08llx, 0x%04x, %d, %llu, %llu, 0x%llx %s",
+			data->op, data->tag, data->lba, data->sct, data->retries,
+			data->start_time, data->end_time, data->outstanding_reqs,
+			((last == i) ? "<--" : " "));
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
+#ifdef CONFIG_SCSI_UFS_EXYNOS_CMD_LOG
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
+	u64 lba = (cmd->cmnd[2] << 24) |
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
+int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev)
+{
+	struct ufs_s_dbg_mgr *mgr;
+
+	mgr = devm_kzalloc(dev, sizeof(struct ufs_s_dbg_mgr), GFP_KERNEL);
+	if (!mgr)
+		return -ENOMEM;
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
index 0000000..c746f59
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-if.h
@@ -0,0 +1,17 @@
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
+/* more members would be added in the future */
+struct ufs_exynos_handle {
+	void *private;
+};
+
+#endif /* _UFS_EXYNOS_IF_H_ */
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 440f2af..e7df18c 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -700,12 +700,31 @@ static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_UFS_EXYNOS_CMD_LOG
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
+#endif
+
 static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
 						int tag, bool op)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	u32 type;
+#ifdef CONFIG_SCSI_UFS_EXYNOS_CMD_LOG
+	struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
 
+	if (op)
+		exynos_ufs_cmd_log(hba, cmd, 1);
+#endif
 	type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
 
 	if (op)
@@ -714,8 +733,7 @@ static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
 		hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
 }
 
-static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
-						int tag, u8 func)
+static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba, int tag, u8 func)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	u32 type;
@@ -1008,6 +1026,12 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
 	exynos_ufs_config_smu(ufs);
+
+	/* init dbg */
+	ret = exynos_ufs_init_dbg(ufs->handle, dev);
+	if (ret)
+		return ret;
+	spin_lock_init(&ufs->dbg_lock);
 	return 0;
 
 phy_off:
@@ -1210,6 +1234,39 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
+static void exynos_ufs_compl_xfer_req(struct ufs_hba *hba, int tag, bool op)
+{
+#ifdef CONFIG_SCSI_UFS_EXYNOS_CMD_LOG
+	struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
+
+	if (op)
+		exynos_ufs_cmd_log(hba, cmd, 2);
+#endif
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1221,6 +1278,8 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.dbg_register_dump		= exynos_ufs_dbg_register_dump,
+	.compl_xfer_req			= exynos_ufs_compl_xfer_req,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 76d6e39..0c79a30 100644
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
+int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev);
 #endif /* _UFS_EXYNOS_H_ */
-- 
2.7.4

