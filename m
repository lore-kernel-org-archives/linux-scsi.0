Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A20C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C7E1206F4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FW1+6jbn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgGOHsI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:48:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31379 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgGOHsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 03:48:07 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200715074803epoutp03666b8b4e7091f00009d08239bedefcbe~h3X_wkoXq1563615636epoutp03B
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 07:48:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200715074803epoutp03666b8b4e7091f00009d08239bedefcbe~h3X_wkoXq1563615636epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594799283;
        bh=WzinotoHMl+6qWjtls4Q749DNmSppu/jolSUz7lm4x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=FW1+6jbnvitzNv6+YpxRx7x1TcW9jOS2X0w8euYzIGSzbAQ+0D9/We2yBwx6/g3H5
         g1guC1GssIq4D9GSiruwBF9JGi1IIkGamozX7udj5CxsTAOrxX3NNmTq7iFsjwRhPo
         NIz5PwtH+pF4+GCK8+6KmBSNSIcCYKOtEv/dkLjE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200715074802epcas2p21a1dd13be1d39c7fb7ef650353e1e6b7~h3X9-fqpU0609106091epcas2p2p;
        Wed, 15 Jul 2020 07:48:02 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B68cw4kk7zMqYks; Wed, 15 Jul
        2020 07:48:00 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.54.27441.FA4BE0F5; Wed, 15 Jul 2020 16:47:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200715074758epcas2p117bed09c65271199ac0008a5a1564570~h3X6YLak12828628286epcas2p1m;
        Wed, 15 Jul 2020 07:47:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200715074758epsmtrp20488cd24a0a4f05abf5f44ff69b5d145~h3X6XTe6Z3059830598epsmtrp2f;
        Wed, 15 Jul 2020 07:47:58 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-66-5f0eb4af562b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B2.00.08382.EA4BE0F5; Wed, 15 Jul 2020 16:47:58 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200715074758epsmtip24299d7d3fd2b5ea6dd7f2030ad8a8c36~h3X6GTK_72959329593epsmtip2W;
        Wed, 15 Jul 2020 07:47:58 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v6 2/3] ufs: exynos: introduce command history
Date:   Wed, 15 Jul 2020 16:39:56 +0900
Message-Id: <f7052ccb43695b21fca28eb846bf2ee9d5bc7809.1594798514.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594798514.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594798514.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmqe76LXzxBkfPsVs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjJ2Hn/BWrA1sWLxww62BsbrAV2MnBwSAiYSr9omMnUxcnEICexglOjd0g3lfGKU+DS/jxWk
        SkjgG6PEyqmxMB1TXs9khijayyjx6/1SqKIfjBLr18qA2GwCmhJPb04FmyQisJlJ4tWC+8wg
        CWYBdYldE04wgdjCAnYSD4/fAmtmEVCVmHJ7CWMXIwcHr0C0RPMsZohlchI3z3WC2ZwClhLr
        Jp1nR2VzAdVM5ZDoO36CFaLBReLl/09MELawxKvjW9ghbCmJz+/2skHY9RL7pjawQjT3MEo8
        3fePESJhLDHrWTvYEcxAH6zfpQ9iSggoSxy5xQJxPp9Ex+G/7BBhXomONiGIRmWJX5MmQw2R
        lJh58w7UVg+J+zvnQAMUaNPOK8eZJzDKz0JYsICRcRWjWGpBcW56arFRgTFy5G1iBKdRLfcd
        jDPeftA7xMjEwXiIUYKDWUmEl4eLN16INyWxsiq1KD++qDQntfgQoykwHCcyS4km5wMTeV5J
        vKGpkZmZgaWphamZkYWSOG+x1YU4IYH0xJLU7NTUgtQimD4mDk6pBiY7afNv8u84kxW99ZK/
        Kn0s+mnWoPI44fKhYu9ZG1Sm6cfxa9ZKJofuact/eKmupOjY605z3jcpz9Wuvv/e92lSa7fM
        JVXZr8UOR9a4nw54UF0h8Ku8tZT5///NzmeelV7lnPq+aeZqFxafG3csnDh1VtvkH9qUtsfx
        1xGzW/0Xjpk7hv6p3N709LvM87pZajnnL3mdLD9WG1Xgzv0347vnOpZcxfiPNZJ3j3NlfOyL
        vG/+SqTeN/6K/5qH8efuC8uce9tQx1nIytt237ivZNljle7HfzKOTTOW2eL4/77BLr9TeVqu
        2XuvTdXXMTq00PfP4SfepWUHlyhein4VuXRHgvkOH2vVA1ddFh3UzVViKc5INNRiLipOBAA6
        zB0FLAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSvO66LXzxBku+als8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7K4ueUoi0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAEc
        UVw2Kak5mWWpRfp2CVwZO4+/YC3Ymlix+GEHWwPj9YAuRk4OCQETiSmvZzKD2EICuxklrlyv
        hYhLSpzY+ZwRwhaWuN9yhLWLkQuo5hujxMG3C8ESbAKaEk9vTmUCSYgIHGaS+L/1OTtIgllA
        XWLXhBNMILawgJ3Ew+O3WEFsFgFViSm3lwA1c3DwCkRLNM9ihlggJ3HzXCeYzSlgKbFu0nl2
        iIMsJDa9e8+IS3wCo8ACRoZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBcaCluYNx
        +6oPeocYmTgYDzFKcDArifDycPHGC/GmJFZWpRblxxeV5qQWH2KU5mBREue9UbgwTkggPbEk
        NTs1tSC1CCbLxMEp1cCkbL0qe3bHK8MPnpK77OQUJjbc/GqirF3Ww8X5m6lx/hFnCxmHq6xJ
        UWtNLytFPmqTLGbXCTtjebnp5tXWa2aSi9kfRx3az//i7ILs66bLdzBM3zbd8edr8dI5c+cf
        CTUtktjP9GjPYYu17Kc0/JNMT3x6JtbssvZZ/ryPP+1tvfzURTk832w18FJmaXsdI2Zt++PT
        3D9TItZEtTUK9U3Ut+XxLW1w/vzd6P6EbzWB7MfzPvEVT07ePCl/Tol38t1t/fuPR/x3P7bb
        bm6rqo/jn1Q7H5k46bsP7r2bd1L03bmMVQbLSlJWbXvjtLvT6cPFmFqXr5XHXyy/KOa37sWC
        /lU1PuZPm9VmKD4+c2e6EktxRqKhFnNRcSIAEQTicPICAAA=
X-CMS-MailID: 20200715074758epcas2p117bed09c65271199ac0008a5a1564570
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200715074758epcas2p117bed09c65271199ac0008a5a1564570
References: <cover.1594798514.git.kwmad.kim@samsung.com>
        <CGME20200715074758epcas2p117bed09c65271199ac0008a5a1564570@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This includes functions to record contexts of incoming commands
in a circular queue. ufshcd.c has already some function
tracer calls to get command history but ftrace would be
gone when system dies before you get the information,
such as panic cases.

This patch also implements callbacks compl_xfer_req
to store IO contexts at completion times.

When you turn on CONFIG_SCSI_UFS_EXYNOS_CMD_LOG,
the driver collects the information from incoming commands
in the circular queue.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Tested-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   1 +
 drivers/scsi/ufs/ufs-exynos-dbg.c | 199 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  27 ++++++
 drivers/scsi/ufs/ufs-exynos.h     |  29 ++++++
 6 files changed, 287 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8cd9026..c946d8f 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -172,3 +172,17 @@ config SCSI_UFS_EXYNOS
 
 	  Select this if you have UFS host controller on EXYNOS chipset.
 	  If unsure, say N.
+
+config SCSI_UFS_EXYNOS_DBG
+	bool "EXYNOS specific debug functions"
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
index f0c5b95..ee09961 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
+obj-$(CONFIG_SCSI_UFS_EXYNOS_DBG) += ufs-exynos-dbg.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
diff --git a/drivers/scsi/ufs/ufs-exynos-dbg.c b/drivers/scsi/ufs/ufs-exynos-dbg.c
new file mode 100644
index 0000000..e1f1452
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -0,0 +1,199 @@
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
+#include <asm-generic/unaligned.h>
+#include "ufshcd.h"
+#include "ufs-exynos-if.h"
+
+#define MAX_CMD_LOGS    32
+
+struct cmd_data {
+	unsigned int tag;
+	u32 sct;
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
+	struct cmd_data *data;
+	u32 i, idx;
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
+	idx = (last == max - 1) ? 0 : last + 1;
+	for (i = 0 ; i < max ; i++, data = &cmd_info->data[idx]) {
+		dev_err(dev, ": 0x%02x, %02d, 0x%08llx, 0x%04x, %d, %llu, %llu, 0x%llx",
+			data->op, data->tag, data->lba, data->sct, data->retries,
+			data->start_time, data->end_time, data->outstanding_reqs);
+		idx = (idx == max - 1) ? 0 : idx + 1;
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
+			      struct ufs_hba *hba, int tag)
+{
+	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
+	struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
+	int cpu = raw_smp_processor_id();
+	struct cmd_data *cmd_log = &mgr->cmd_log;	/* temp buffer to put */
+	u64 lba = 0;
+	u32 sct = 0;
+
+	if (mgr->active == 0)
+		return;
+
+	cmd_log->start_time = cpu_clock(cpu);
+	cmd_log->op = cmd->cmnd[0];
+	cmd_log->tag = tag;
+
+	/* This function runtime is protected by spinlock from outside */
+	cmd_log->outstanding_reqs = hba->outstanding_reqs;
+
+	/* Now assume using WRITE_10 and READ_10 */
+	put_unaligned(cpu_to_le32(*(u32 *)cmd->cmnd[2]), &lba);
+	put_unaligned(cpu_to_le16(*(u16 *)cmd->cmnd[7]), &sct);
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
+			    struct ufs_hba *hba, int tag)
+{
+	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
+	struct ufs_cmd_info *cmd_info = &mgr->cmd_info;
+	int cpu = raw_smp_processor_id();
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
+MODULE_LICENSE("GPL v2");
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
index 440f2af..53b9d6e 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -700,12 +700,26 @@ static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
 	return 0;
 }
 
+static void exynos_ufs_cmd_log(struct ufs_hba *hba, int tag, int start)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	struct ufs_exynos_handle *handle = &ufs->handle;
+
+	if (start == 1)
+		exynos_ufs_cmd_log_start(handle, hba, tag);
+	else if (start == 2)
+		exynos_ufs_cmd_log_end(handle, hba, tag);
+}
+
 static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
 						int tag, bool op)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	u32 type;
 
+	if (op)
+		exynos_ufs_cmd_log(hba, tag, 1);
+
 	type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
 
 	if (op)
@@ -714,6 +728,12 @@ static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
 		hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
 }
 
+static void exynos_ufs_compl_xfer_req(struct ufs_hba *hba, int tag, bool op)
+{
+	if (op)
+		exynos_ufs_cmd_log(hba, tag, 0);
+}
+
 static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
 						int tag, u8 func)
 {
@@ -1008,6 +1028,12 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
 	exynos_ufs_config_smu(ufs);
+
+	/* init dbg */
+	ret = exynos_ufs_init_dbg(&ufs->handle, dev);
+	if (ret)
+		return ret;
+	spin_lock_init(&ufs->dbg_lock);
 	return 0;
 
 phy_off:
@@ -1217,6 +1243,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.link_startup_notify		= exynos_ufs_link_startup_notify,
 	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
 	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
+	.compl_xfer_req			= exynos_ufs_compl_xfer_req,
 	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 76d6e39..b9cb517 100644
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
+	struct ufs_exynos_handle handle;
+	spinlock_t dbg_lock;
+	int under_dump;
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
@@ -284,4 +289,28 @@ struct exynos_ufs_uic_attr exynos7_uic_attr = {
 	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
 	.pa_dbg_option_suite		= 0x30103,
 };
+
+/* public function declarations */
+#ifdef CONFIG_SCSI_UFS_EXYNOS_DBG
+void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
+			      struct ufs_hba *hba, int tag);
+void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
+			    struct ufs_hba *hba, int tag);
+int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev);
+#else
+void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
+			      struct ufs_hba *hba, int tag)
+{
+}
+
+void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
+			    struct ufs_hba *hba, int tag)
+{
+}
+
+int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev)
+{
+	return 0;
+}
+#endif
 #endif /* _UFS_EXYNOS_H_ */
-- 
2.7.4

