Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AEDC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 06:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF71222B3F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 06:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389115AbhAZGsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 01:48:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30298 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729775AbhAZGqL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 01:46:11 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210126064514epoutp04bfdf392e656d282e6d8657d0c65a59cd~dtTzjNch-2431024310epoutp04w
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2021 06:45:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210126064514epoutp04bfdf392e656d282e6d8657d0c65a59cd~dtTzjNch-2431024310epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611643514;
        bh=E3Ltw1sjJNE1MT3rj27EJQgjfV1RqAHwmEn0wOc0Gmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=F37HPBuptHTFa9GCFxwORbWvI9CNqmm2Vjk0Yw45i1I3hT7TNZFuV9/pmUSsuq7Kz
         nBrfw690DslL9pdNcaK6LO1zZykskxXyOMX3URgKneAh8lxOxr1HGckcPubvZ2B5uv
         5kf6sDT5iRbo+WuKgLPDDLgHQ0RdUmvWXqOoSvzA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210126064513epcas2p36312bd39cb62667a8ac148244110f579~dtTyi9hUu2911229112epcas2p3a;
        Tue, 26 Jan 2021 06:45:13 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.190]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DPy0Q37B8z4x9QG; Tue, 26 Jan
        2021 06:45:10 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.5F.05262.47ABF006; Tue, 26 Jan 2021 15:45:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210126064508epcas2p3c1132f7b6895d344784629a0d2e74c12~dtTtqR_5A2298922989epcas2p3-;
        Tue, 26 Jan 2021 06:45:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210126064508epsmtrp1567b8293f2a5b34651963cdce5cd986a~dtTtpAacp0312103121epsmtrp16;
        Tue, 26 Jan 2021 06:45:08 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-ef-600fba744536
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.DB.08745.47ABF006; Tue, 26 Jan 2021 15:45:08 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210126064508epsmtip2390db18e985fba006c959607d11e5929~dtTtX6dFr0935309353epsmtip2X;
        Tue, 26 Jan 2021 06:45:08 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v8 2/2] ufs: exynos: introduce command history
Date:   Tue, 26 Jan 2021 15:33:35 +0900
Message-Id: <d2e077fc8e8cd49ada614a08bb3dda85e8222c8f.1611642467.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611642467.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1611642467.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmmW7JLv4Eg2+zzS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyZhyYwFLwdesiqvf7rA3MB6L6GLk5JAQMJFoebqetYuRi0NIYAejxI0dzcwQzidG
        idnzN0NlPjNKLHv4gAWmZe+lD1BVuxglPq26xgLh/GCU+P3vB1gVm4CmxNObU5lAEiICZ5gk
        rrWeZQVJMAuoS+yacIIJxBYWsJM4vXo2O4jNIqAqMfHtGUYQm1cgWuLSq8PsEOvkJG6e62QG
        sTkFLCWmHN/PiMrmAqqZySGx6tcKoAYOIMdFYuOpGIheYYlXx7dAzZGSeNnfBmXXS+yb2sAK
        0dvDKPF03z9GiISxxKxn7Ywgc5iBPli/Sx9ipLLEkVssEOfzSXQc/gu1iVeio00IolFZ4tek
        yVBDJCVm3rwDtclD4s+aR+yQ8AHa9G32ceYJjPKzEBYsYGRcxSiWWlCcm55abFRgjBx9mxjB
        SVXLfQfjjLcf9A4xMnEwHmKU4GBWEuHdrceTIMSbklhZlVqUH19UmpNafIjRFBiOE5mlRJPz
        gWk9ryTe0NTIzMzA0tTC1MzIQkmct9jgQbyQQHpiSWp2ampBahFMHxMHp1QDU2xSvG+A2D7T
        m/bK61+WrdLoeCXilnAzy7Nt43etMPWwNVEPlA93JV+1CFuqek7hll+Hd7lHMSPXWr+Ehxf0
        uRkXRXh483/x9H9sfNBz5XKfqxevhVw5UrrlkUZtZjXXOt0p/ZOStxyoSjykzf+PYbt/YbxB
        qF2I377J37d/LjZTduYTTTZInx5z1+eB7NKkluJbhS9v6v28GebQULnh4p21jZta3sz9IfiG
        WY1Be7Hsdk0J1bnZZssebVoq/S9m3fKG9n9tDsV/01M+Bs3PfV98QWf1GtvHj2qTeZ4dS2Vd
        /txLg9Vnb+G1Nc82l2R1q8sofWhUfr7r0eO2ung5nVk2LywCeo56p143nDNfiaU4I9FQi7mo
        OBEAjyMY/zMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvG7JLv4Eg5WzhS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGVMubGApeBrVsXVb3fYGxiPRXQxcnJICJhI7L30gbmLkYtD
        SGAHo8Serk1MEAlJiRM7nzNC2MIS91uOsEIUfWOUeNO0lg0kwSagKfH05lQmkISIwD0miUsT
        5jKDJJgF1CV2TTgBNklYwE7i9OrZ7CA2i4CqxMS3Z8Cm8gpES1x6dZgdYoOcxM1znWC9nAKW
        ElOO7werERKwkOjc9o8dl/gERoEFjAyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGC
        o0JLawfjnlUf9A4xMnEwHmKU4GBWEuHdrceTIMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJ
        eCGB9MSS1OzU1ILUIpgsEwenVAPTYauKjDU/+jOqN5dyFfNZ/Ju8krlLvGLZr9MGPEZlZzI4
        nQJa27suys79KSBgtEOuXlruyeqUjUmun2/YGxc8vSUZI1T3/HzWy7/ry/a9zMur8Q3oV7Tf
        ECxb48fdq/btdf7XSanWC4wmh1/mKuhaFK+suXzN+jBxgQztvxufdDVFRKkslTATe3VV2vFW
        +sZa3XNLBNQ33mcSOmXr5nR0ZquQ5gzV8or7bx0bXNiWahjNMF9jxjjR+dL+yDaVjoogPY3v
        k88G6ghp/GP6/r5kazyD23WBjF+JGje4jI5lL1z2N8HsJQ9/+ib1kPDSbU1ZHkzyD8KZVIPz
        LeUUwvfHvOn8pn3yyNmfMcu+KrEUZyQaajEXFScCAFuyTQr5AgAA
X-CMS-MailID: 20210126064508epcas2p3c1132f7b6895d344784629a0d2e74c12
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210126064508epcas2p3c1132f7b6895d344784629a0d2e74c12
References: <cover.1611642467.git.kwmad.kim@samsung.com>
        <CGME20210126064508epcas2p3c1132f7b6895d344784629a0d2e74c12@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch includes functions to record
contexts of incoming commands in a circular queue.
ufshcd.c has already some function tracer calls to get
command history. However ftrace would be pointless
when system dies before you get the information,
such as panic cases. This patch implements callbacks
compl_xfer_req to store IO contexts at completion times.

When you turn on CONFIG_SCSI_UFS_EXYNOS_DBG,
the driver collects the information from incoming commands
in the circular queue.

I also implemented dbg_register_dump callback to print
command history for abnormal cases. Currenty, I just add
command history print and you can add various vendor regions.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/Kconfig          |  14 +++
 drivers/scsi/ufs/Makefile         |   4 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 206 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-dbg.h |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  37 +++++++
 drivers/scsi/ufs/ufs-exynos.h     |  34 +++++++
 6 files changed, 311 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-dbg.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index d0d7ead..0ac5e41 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -173,6 +173,20 @@ config SCSI_UFS_EXYNOS
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
index 06f3a3f..606dbb1 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -15,7 +15,9 @@ obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs_qcom.o
 ufs_qcom-y += ufs-qcom.o
 ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) += ufs-qcom-ice.o
-obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
+obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos-core.o
+ufs-exynos-core-y += ufs-exynos.o
+ufs-exynos-core-$(CONFIG_SCSI_UFS_EXYNOS_DBG) += ufs-exynos-dbg.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
diff --git a/drivers/scsi/ufs/ufs-exynos-dbg.c b/drivers/scsi/ufs/ufs-exynos-dbg.c
new file mode 100644
index 0000000..64a3e09
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -0,0 +1,206 @@
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
+#include "ufs-exynos-dbg.h"
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
+	u32 tail;
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
+	u32 tail, count;
+	unsigned long flags;
+	u32 total;
+
+	spin_lock_irqsave(&mgr->cmd_lock, flags);
+	total = cmd_info->total;
+	tail = cmd_info->tail;
+	spin_unlock_irqrestore(&mgr->cmd_lock, flags);
+
+	if (total == 0)
+		return;
+
+	dev_err(dev, ":---------------------------------------------------\n");
+	dev_err(dev, ":\t\tSCSI CMD(%u)\n", total - 1);
+	dev_err(dev, ":---------------------------------------------------\n");
+	dev_err(dev, ":OP, TAG, LBA, SCT, RETRIES, STIME, ETIME, REQS\n\n");
+
+	/* set start index */
+	if (total < MAX_CMD_LOGS) {
+		idx = 0;
+		count = total;
+	} else {
+		idx = tail;
+		count = MAX_CMD_LOGS;
+	}
+	data = &cmd_info->data[idx];
+
+	for (i = 0 ; i < count ; i++, data++) {
+		dev_err(dev, ": 0x%02x, %02d, 0x%08llx, 0x%04x, %d, %llu, %llu, 0x%llx",
+				data->op, data->tag, data->lba, data->sct, data->retries,
+				data->start_time, data->end_time, data->outstanding_reqs);
+		idx = (idx == MAX_CMD_LOGS - 1) ? 0 : idx + 1;
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
+	pdata = &cmd_info->data[cmd_info->tail];
+	++cmd_info->total;
+	++cmd_info->tail;
+	cmd_info->tail = cmd_info->tail % MAX_CMD_LOGS;
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
+MODULE_AUTHOR("Kiwoong Kim <kwmad.kim@samsung.com>");
+MODULE_DESCRIPTION("Exynos UFS debug information");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION("0.1");
diff --git a/drivers/scsi/ufs/ufs-exynos-dbg.h b/drivers/scsi/ufs/ufs-exynos-dbg.h
new file mode 100644
index 0000000..c746f59
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.h
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
index 267943a1..319bca1 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -692,12 +692,26 @@ static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
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
@@ -706,6 +720,12 @@ static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
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
@@ -996,6 +1016,11 @@ static int exynos_ufs_init(struct ufs_hba *hba)
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
@@ -1198,6 +1223,16 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1205,10 +1240,12 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
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
index 06ee565..758138b 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -8,6 +8,7 @@
 
 #ifndef _UFS_EXYNOS_H_
 #define _UFS_EXYNOS_H_
+#include "ufs-exynos-dbg.h"
 
 /*
  * UNIPRO registers
@@ -199,6 +200,10 @@ struct exynos_ufs {
 #define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
 #define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
 #define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
+
+	struct ufs_exynos_handle handle;
+	unsigned long dbg_flag;
+#define EXYNOS_UFS_DBG_DUMP_CXT			0
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
@@ -271,4 +276,33 @@ struct exynos_ufs_uic_attr exynos7_uic_attr = {
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
+}
+#endif
 #endif /* _UFS_EXYNOS_H_ */
-- 
2.7.4

