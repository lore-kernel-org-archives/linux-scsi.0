Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B85C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8BD020709
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbhA0EXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:23:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54965 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbhA0Duu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:50:50 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210127035005epoutp03ac2f41f95e79cb00e8e416f55dd703f8~d_kKRnAIi1057310573epoutp03G
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 03:50:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210127035005epoutp03ac2f41f95e79cb00e8e416f55dd703f8~d_kKRnAIi1057310573epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611719405;
        bh=a1VigZoOU8M0yvYu7cBTt1PaRBT8JR33Y+QFF0Clukk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=XOqob9cNY5W2pgpEUyx+63s+cBCpkkUzgNFPIInh25hYFmNDL9CpGC4IHjChxP2Eb
         1Crjflep9SDwXazFd3u7P5r5nKuklyv4gxOJPuOWDe/cbfDLbecTCbDKVZbNVnk86z
         mNpcJ3Po/JOtuGx0uoKHUXL1O5HeLY+90f9WtVVs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210127035002epcas2p480dec2af1e6b4b82d2de712fe31e8bce~d_kH2uJLz2101821018epcas2p4B;
        Wed, 27 Jan 2021 03:50:02 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DQV3q6Xztz4x9Q3; Wed, 27 Jan
        2021 03:49:59 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.6D.05262.7E2E0106; Wed, 27 Jan 2021 12:49:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210127034959epcas2p418a2278db8441cab04bca42dde177fc7~d_kEj21gS0475504755epcas2p4J;
        Wed, 27 Jan 2021 03:49:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210127034959epsmtrp2774370659332e3dabb46ea80b3ffac0a~d_kEi0kTS2007320073epsmtrp2d;
        Wed, 27 Jan 2021 03:49:59 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-37-6010e2e7ba9a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.6C.08745.7E2E0106; Wed, 27 Jan 2021 12:49:59 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127034959epsmtip2b0cf8d201b64c1ea5904be9cbc4b6a2b~d_kEPjdJL2507425074epsmtip2g;
        Wed, 27 Jan 2021 03:49:59 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v9 2/2] ufs: exynos: introduce command history
Date:   Wed, 27 Jan 2021 12:38:23 +0900
Message-Id: <dad0e24545595504bf075ab737256b7a41e3c1ec.1611718633.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611718633.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1611718633.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmhe7zRwIJBsfWGVo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQkzF9xi7Wgr7sim2H7zI2MN6K6GLk5JAQMJE49+4uWxcjF4eQwA5GiYNfDzJDOJ8Y
        JT63NrBCOJ8ZJW68O8IG03Lo2G9GiMQuRolvE/4xQTg/GCWOr33HAlLFJqAp8fTmVLCEiMAZ
        JolrrWdZQRLMAuoSuyacAEpwcAgL2EmcaCkGMVkEVCU2r3UEqeAViJbYs/0yO8QyOYmb5zqZ
        QUo4BSwlnu82QGFyAVXM5ZB43raGGaLcRWL5zuuMELawxKvjW6DGSEl8frcX6v56iX1TIR6T
        EOhhlHi67x9Ug7HErGftjCALmIHOX79LH8SUEFCWOHKLBeJ2PomOw3/ZIcK8Eh1tQhCNyhK/
        Jk2GGiIpMfPmHaitHhJb/+5ngQQO0KbvZ4+zTGCUn4WwYAEj4ypGsdSC4tz01GKjAmPkuNvE
        CE6nWu47GGe8/aB3iJGJg/EQowQHs5II73tlgQQh3pTEyqrUovz4otKc1OJDjKbAUJzILCWa
        nA9M6Hkl8YamRmZmBpamFqZmRhZK4rzFBg/ihQTSE0tSs1NTC1KLYPqYODilGph89ko+fPog
        S2GvWfWNu7sFKhewqayxSJfvefSA/9ZNXX22XQusTi/oZlG/125TkulwXnq2Z1PCjM5UDn3u
        WbLOa75c+Bu9VGuuTBGTnhHzFLtvelPXPUvc85xlk9fhe7db96x4LS3/W6qjuUvXwZ479+LF
        HUa/F8ZdaqgwjvHLStfSfNDPv332UWaNlV2Rl0UWL/ktvWuin0PjLpPnGybKPO8UelrJe1fx
        JaPkl5f3s06km8/jXDTnqbdoHVuJSvwksZvMs5/Y8l67P3cSW5vj7lmRswL/O9gx/7D82mFS
        y+QjHKL0kd9q992/Em+3t77P/JU9ceZ1/9KpwgHXYgJbs9x3+u3zmqeZFb+4tliJpTgj0VCL
        uag4EQAfCFVhMAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSvO7zRwIJBqeOcVs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4MqYPmMXa0FfdsW2w3cZGxhvRXQxcnJICJhIHDr2m7GLkYtD
        SGAHo8S6U49YIBKSEid2PmeEsIUl7rccYYUo+sYo0d70FqyITUBT4unNqUwgCRGBe0wSlybM
        ZQZJMAuoS+yacAIowcEhLGAncaKlGMRkEVCV2LzWEaSCVyBaYs/2y+wQ8+Ukbp7rZAYp4RSw
        lHi+2wAkLCRgIXHzykpWHMITGAUWMDKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQI
        jgYtrR2Me1Z90DvEyMTBeIhRgoNZSYT3vbJAghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n
        44UE0hNLUrNTUwtSi2CyTBycUg1MR7IK3k3p/eJoX/dwbXxJofD2ABvOl6KbipXvOTVceNZj
        XJn/r8Ut9laqZ4vw/u3zVmuv3MXw7wN3dnabXraVVOFjkQ7e7eUfdv01WbRr7b5tAfn79fWb
        GTuZRRYl7rV/MuF7iW6u8OFF6t3+FR+Pc0l7XO7afb27a6WrcDT3aUb3E3uO1cX7a/Huvf5J
        bEfG9QvWWvPjDKWWH0hN1Fi/klnx3LpXO+2/fHrCXSa5YbHpf5a0+INpp0o27NbZ/TtW+v3r
        xg+XXX3WeWgzTvmRJP7oYp3qp7gcl2VPTKYpCy2pUL7wOSl05h779HsP1qYLs9wQmjBHX3C3
        5JMpJzjv1HUqnZq3+ORbwenbRS81K7EUZyQaajEXFScCAFxbD/z1AgAA
X-CMS-MailID: 20210127034959epcas2p418a2278db8441cab04bca42dde177fc7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210127034959epcas2p418a2278db8441cab04bca42dde177fc7
References: <cover.1611718633.git.kwmad.kim@samsung.com>
        <CGME20210127034959epcas2p418a2278db8441cab04bca42dde177fc7@epcas2p4.samsung.com>
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
 drivers/scsi/ufs/ufs-exynos-dbg.c | 207 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-dbg.h |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  37 +++++++
 drivers/scsi/ufs/ufs-exynos.h     |  34 +++++++
 6 files changed, 312 insertions(+), 1 deletion(-)
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
index 0000000..325abc5
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -0,0 +1,207 @@
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
+	for (i = 0 ; i < count ; i++) {
+		dev_err(dev, ": 0x%02x, %02d, 0x%08llx, 0x%04x, %d, %llu, %llu, 0x%llx",
+				data->op, data->tag, data->lba, data->sct, data->retries,
+				data->start_time, data->end_time, data->outstanding_reqs);
+		idx = (idx == MAX_CMD_LOGS - 1) ? 0 : idx + 1;
+		data = &cmd_info->data[idx];
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

