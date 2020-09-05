Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D24EC2BBD0
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 05:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C9A820FC3
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 05:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="o7OohghZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgIEF4a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 01:56:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46097 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgIEF40 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 01:56:26 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200905055622epoutp037015f793d9f5345c8cbf13391e5f856d~xzZUZc2wr1266612666epoutp03b
        for <linux-scsi@vger.kernel.org>; Sat,  5 Sep 2020 05:56:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200905055622epoutp037015f793d9f5345c8cbf13391e5f856d~xzZUZc2wr1266612666epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599285382;
        bh=JqY6ZQArEjb2BkZu16PfcrbEkcppvEaFwnKhgEzveMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=o7OohghZLvABd/MZ6iPmxorws9r/pDDPuWWCKyenqlrfYaQG9RHq3xqKF+3coDUA3
         baccPElNC23GJoil5rbowoJ4Dbu0hWv8Qpu/9C9WObyBFgpON+zR8/aLzfZH6Gv52H
         FmMpKB8gU6wCwFR+uuj+8WYESU6chGh5Ri82O3Ic=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200905055622epcas2p43431020488a81ca28fc7f8beafc7d5f8~xzZTqOPiM1604616046epcas2p45;
        Sat,  5 Sep 2020 05:56:22 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Bk3h31yqjzMqYkV; Sat,  5 Sep
        2020 05:56:19 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.17.19322.388235F5; Sat,  5 Sep 2020 14:56:19 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200905055618epcas2p3216a11a97948f3605f1f2a0622927850~xzZQiZ8bO0172701727epcas2p3P;
        Sat,  5 Sep 2020 05:56:18 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200905055618epsmtrp15919c19a46bd5ce8ae4eb9ca9bd9e5d8~xzZQe5EHP0632406324epsmtrp1J;
        Sat,  5 Sep 2020 05:56:18 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-11-5f532883dbaf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.6E.08303.288235F5; Sat,  5 Sep 2020 14:56:18 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200905055618epsmtip12537cac7e88bafabff507528c8732ba0~xzZQLoqEm2747227472epsmtip1C;
        Sat,  5 Sep 2020 05:56:18 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v7 2/2] ufs: exynos: introduce command history
Date:   Sat,  5 Sep 2020 14:47:20 +0900
Message-Id: <369148aae7680f558ab1f603a225e99416340b84.1599284713.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1599284713.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1599284713.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmhW6zRnC8wfNOLosH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        KscmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+huJYWy
        xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVC
        TsbvhgaWgtuZFddudrA1MJ4P72Lk5JAQMJFo613J3MXIxSEksINR4uiWG2wQzidGif4Ha6Ay
        nxklVr14xgrT8mvvb3aIxC5GiYuPdkBV/WCUeHTiGBtIFZuApsTTm1OZQBIiApuZJF4tuM8M
        kmAWUJfYNeEEE4gtLGAn0XRvAQuIzSKgKtH9+jRYDa9AtMSeR0fYINbJSdw81wkW5xSwlLg1
        ey8rKpsLqGYqh8TGl9cZIRpcJO7Nm8wOYQtLvDq+BcqWknjZ3wZl10vsm9oA1dzDKPF03z+o
        ZmOJWc/agWwOoEs1Jdbv0gcxJQSUJY7cYoG4n0+i4/Bfdogwr0RHmxBEo7LEr0mToYZISsy8
        eQdqk4fEg1MzoWEKtGnf/1NMExjlZyEsWMDIuIpRLLWgODc9tdiowBA5/jYxgpOplusOxslv
        P+gdYmTiYDzEKMHBrCTC63EuMF6INyWxsiq1KD++qDQntfgQoykwICcyS4km5wPTeV5JvKGp
        kZmZgaWphamZkYWSOG+u4oU4IYH0xJLU7NTUgtQimD4mDk6pBiYpHefrakt/35ixrE4vYlLe
        2dbfcz5ybqzZyzvJVcT8LEfJpvzQRepPzvNvZFrG7mtyq6e+8M/Kf5k24ScUXfxEZxxRbG6U
        dZbZmDrhb57YxBvsEhlF9+yfP5nprfPOeFl33t/nO03Edk94nby6Jv2wCe/8BkuJ63/4PR3l
        CtZK6T2+VsFrnSywe9Km5wycASUnZ/OozE660BKQvT9xQ27J89I/93dOLu89GBWtJ2YW+7N4
        g/TrLcoba5bwNlx55WGUsrPgoM+Xac/e5hedKs6M4FwdPj2/8mDS9Lb0OKb4nXem/J136Wfw
        36OFmSGNSu2vQ3M3qK4sy4kvDQt26GI1E74y9/Y25/VR0/4YuSixFGckGmoxFxUnAgAWuY8V
        LwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnG6TRnC8weNLKhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG74YGloLbmRXXbnawNTCeD+9i5OSQEDCR+LX3N3sXIxeHkMAORom1
        R78zQSQkJU7sfM4IYQtL3G85wgpR9I1RYuOujcwgCTYBTYmnN6cygSREBA4zSfzf+pwdJMEs
        oC6xa8IJsEnCAnYSTfcWsIDYLAKqEt2vT4M18wpES+x5dIQNYoOcxM1znWBxTgFLiVuz97KC
        2EICFhJHNkxkwyU+gVFgASPDKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4FjQ0trB
        uGfVB71DjEwcjIcYJTiYlUR4Pc4FxgvxpiRWVqUW5ccXleakFh9ilOZgURLn/TprYZyQQHpi
        SWp2ampBahFMlomDU6qBKSnKJsH80hMXac9PyUpZqfUiKh+UuveKVs0ufvuJN4pTpj9Rdfou
        0Yf72u1W9rK9uXFO4c1BYDxXXSjZsd6f5eiO3xbNSS+5djbrT0+IEnC+75ZbOddv6/fMlW1b
        lr9v5Dp+YE3b0f/rkrLOhOhp3djGLy+5yPDunH0T3qaYre046/l4hduS1C5dj4+a5196Zc46
        FLggI+fxxsblPqYnIqZuW/fxItOS1sksHGKfOrjlL/ed5Z1uILzj+8yqvp9z7UN7mWc8nB0Y
        lSrWPnX10YNsVu2hhx3O3c1i0hQLyz53OGf5Y/YVKQU+2re2sJ4LPnd22abJLz39c5ZI3Va5
        471435RtpQumvxOJfL6XWYmlOCPRUIu5qDgRAGs+VdP0AgAA
X-CMS-MailID: 20200905055618epcas2p3216a11a97948f3605f1f2a0622927850
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200905055618epcas2p3216a11a97948f3605f1f2a0622927850
References: <cover.1599284713.git.kwmad.kim@samsung.com>
        <CGME20200905055618epcas2p3216a11a97948f3605f1f2a0622927850@epcas2p3.samsung.com>
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
---
 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   4 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 200 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  38 ++++++++
 drivers/scsi/ufs/ufs-exynos.h     |  35 +++++++
 6 files changed, 307 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-if.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index f639499..29aa4d2 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -174,6 +174,20 @@ config SCSI_UFS_EXYNOS
 	  Select this if you have UFS host controller on EXYNOS chipset.
 	  If unsure, say N.
 
+config SCSI_UFS_EXYNOS_DBG
+	bool "EXYNOS specific debug functions"
+	default n
+	depends on SCSI_UFS_EXYNOS
+	help
+	  This selects EXYNOS specific functions to get and even print
+	  some information to see what's happening at both command
+	  issue time completion time.
+	  The information may contain general things as well as
+	  EXYNOS specific, such as vendor specific hardware contexts.
+
+	  Select this if you want to get and print the information.
+	  If unsure, say N.
+
 config SCSI_UFS_CRYPTO
 	bool "UFS Crypto Engine Support"
 	depends on SCSI_UFSHCD && BLK_INLINE_ENCRYPTION
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 4679af1..8d425a4 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -6,7 +6,9 @@ obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs_qcom.o
 ufs_qcom-y += ufs-qcom.o
 ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) += ufs-qcom-ice.o
-obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
+obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos-core.o
+ufs-exynos-core-y += ufs-exynos.o
+ufs-exynos-core-$(CONFIG_SCSI_UFS_EXYNOS_DBG) += ufs-exynos-dbg.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
diff --git a/drivers/scsi/ufs/ufs-exynos-dbg.c b/drivers/scsi/ufs/ufs-exynos-dbg.c
new file mode 100644
index 0000000..89ce3c2
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -0,0 +1,200 @@
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
+#ifdef CONFIG_SCSI_UFS_EXYNOS_DBG
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
+	data = &cmd_info->data[idx];
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
+	ufs_s_print_cmd_log(mgr, dev);
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
+	u64 lba;
+	u32 sct;
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
+	lba = get_unaligned_be32(&cmd->cmnd[2]);
+	sct = get_unaligned_be32(&cmd->cmnd[7]);
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
+#endif
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
index 8f1b6f6..7d383e3 100644
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
@@ -1008,6 +1028,11 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
 	exynos_ufs_config_smu(ufs);
+
+	/* init dbg */
+	ret = exynos_ufs_init_dbg(&ufs->handle, dev);
+	if (ret)
+		return ret;
 	return 0;
 
 phy_off:
@@ -1210,6 +1235,17 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static void exynos_ufs_dbg_register_dump(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!test_and_set_bit(EXYNOS_UFS_DBG_DUMP_CXT, &ufs->dbg_flag)) {
+		exynos_ufs_dump_info(&ufs->handle, hba->dev);
+		clear_bit(EXYNOS_UFS_DBG_DUMP_CXT, &ufs->dbg_flag);
+	}
+	return;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1217,10 +1253,12 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.link_startup_notify		= exynos_ufs_link_startup_notify,
 	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
 	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
+	.compl_xfer_req			= exynos_ufs_compl_xfer_req,
 	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.dbg_register_dump		= exynos_ufs_dbg_register_dump,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 76d6e39..eed8728 100644
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
+	unsigned long dbg_flag;
+#define EXYNOS_UFS_DBG_DUMP_CXT			0
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
@@ -284,4 +289,34 @@ struct exynos_ufs_uic_attr exynos7_uic_attr = {
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
+void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev);
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
+
+void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
+{
+	return;
+}
+#endif
 #endif /* _UFS_EXYNOS_H_ */
-- 
2.7.4

