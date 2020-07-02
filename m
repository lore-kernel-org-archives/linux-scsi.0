Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D909C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D0D2083E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:46:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="D6af5jBG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgGBCqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:46:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39383 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgGBCqJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:46:09 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200702024605epoutp01918fd8ed96c7e5e46cc497957b1957aa~dz3ndcfry2975929759epoutp01d
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:46:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200702024605epoutp01918fd8ed96c7e5e46cc497957b1957aa~dz3ndcfry2975929759epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593657965;
        bh=sh6/i6u1vpyWSwKpgVVW9UfWYH9rMCKPo/npvmi2pFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=D6af5jBGeiZqoAV0w2p9FxwBYijaJf6+mGRUtuRKJieq+V82Vy251Q1a8n2B/Cx62
         Ew1uYDpwX1Vk25cdmyjCXXKPtEx7eVttlImZoEH3h44AVgAjqx/g8CqfZ0dOD8Uvz4
         13uRntc5DtfBW6yybwf6isVKs+OSC3tKoWQODKuw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200702024604epcas2p38c09d5eeb10662d16956cff2d81b584a~dz3mliwI60243402434epcas2p3d;
        Thu,  2 Jul 2020 02:46:04 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49y2XV3RRrzMqYls; Thu,  2 Jul
        2020 02:46:02 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.9F.19322.76A4DFE5; Thu,  2 Jul 2020 11:45:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200702024559epcas2p37b3f2f6c2cafd1f033d129032339ca16~dz3h7pCQK0930709307epcas2p3s;
        Thu,  2 Jul 2020 02:45:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200702024559epsmtrp1fb1833048a8054771db1b0c25df8a8a1~dz3h2lAGP2619526195epsmtrp1b;
        Thu,  2 Jul 2020 02:45:59 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-0f-5efd4a6706cc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.B2.08303.76A4DFE5; Thu,  2 Jul 2020 11:45:59 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200702024559epsmtip21de8747dbecd94eaac4bd6ae12966d9d~dz3hpXNGk0257502575epsmtip2p;
        Thu,  2 Jul 2020 02:45:59 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v2 2/2] exynos-ufs: implement dbg_register_dump and
 compl_xfer_req
Date:   Thu,  2 Jul 2020 11:38:10 +0900
Message-Id: <3ff2f6a72282116a8b33d1bdd10cc89d6118aad8.1593657314.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593657314.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593657314.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdljTQjfd62+cwda/BhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFotubGOyuLnlKItF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpRSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk3Fk9SWWgv7Miju/G5kbGPvDuxg5
        OSQETCRm75jM2MXIxSEksINRYkLHRGYI5xOjxOT+9WwQzmcg5/48VpiWFwdmsoDYQgK7GCVe
        zcmFKPrBKPHkyQpGkASbgKbE05tTmUASIgI3GCXmNB8G62YWUJfYNeEEE4gtLBAh0TH3LVgD
        i4CqxI8t38HivALRErM6d0Ftk5O4ea6TGcTmFLCUWH+nlRGVzQVU85Vd4u2el0DNHECOi0TX
        9wSIXmGJV8e3sEPYUhIv+9ug7HqJfVMbWCF6exglnu77xwiRMJaY9aydEWQOM9AH63fpQ4xU
        ljhyiwXifD6JjsN/2SHCvBIdbUIQjcoSvyZNhhoiKTHz5h2oTR4Ssz5fgwYi0KaLbxYyTmCU
        n4WwYAEj4ypGsdSC4tz01GKjAkPk2NvECE6QWq47GCe//aB3iJGJg/EQowQHs5II72mDX3FC
        vCmJlVWpRfnxRaU5qcWHGE2B4TiRWUo0OR+YovNK4g1NjczMDCxNLUzNjCyUxHlzFS/ECQmk
        J5akZqemFqQWwfQxcXBKNTA5Vd9OO7+286zdfK+b99bz7Xo/y2B9V66hzxtzToujrQVv1O8u
        YRLd/lFJVTvG/P4c42k/Ckxy7RIOHuMy7tbLtJE1cq0riTojMmG+5c9diZz3wrIKQnxU1rKt
        TFPNmrIxLaa4xlurr9vuncTT4/0S01dE/N7zO/Bm6pq/6gEFk967H5QrCPCV2/fug7K+eNTp
        8NsfTNPXcEjWyWt8va5xbFl1aMnj2yvmvV2j6KB2d8mZMtt7P19u0/wk+L1/bZOF/LkT7KKr
        bPQaFfWC11mrymn5zWuWSXylz6c6Q/DgpEUKBqkTY43enRCL09+ptCJuIifPr+lTop99UuM4
        a+KwpimrKvKy0xQ5yQXMDkosxRmJhlrMRcWJAP75AFsZBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSvG661984g2m7xC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJVxZPUlloL+
        zIo7vxuZGxj7w7sYOTkkBEwkXhyYydLFyMUhJLCDUWLXinmsEAlJiRM7nzNC2MIS91uOsEIU
        fWOUeHP2MjNIgk1AU+LpzalMIAkRgUeMEr9ndrKDJJgF1CV2TTjBBGILC4RJfJr7GsxmEVCV
        +LHlO5jNKxAtMatzF9Q2OYmb5zrBhnIKWEqsv9MKtllIwEJiR9MlNlziExgFFjAyrGKUTC0o
        zk3PLTYsMMpLLdcrTswtLs1L10vOz93ECA5xLa0djHtWfdA7xMjEwXiIUYKDWUmE97TBrzgh
        3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1ME3d2bLrlWjn
        wq5HbgwM2xtlrnUEeHst68u/qr3zX0xmNJvgfwcF758yEbfnRUy4PSF4e8kq0XPvExvNb2R6
        ru1PjOa6aejJrVi0b2VKcoQu+/xKqTUW2rc/5Km0Nj47nPItrmdTvNSmzzO+TPv9Y4X/9l/L
        PnVH//FuybnrErr3kwTjlsOvFX88+z/F8UF5ZT3jGYFX1Ub6Gh63/P1vzzIJXuJbte383jKB
        a+whp+4EdauZz+ixaFqUq7SS/Ybv5cr+3Zf2yOiY5PGGnuyfWTtzzvbE8/KnhAwa/ey/8r97
        +/ZcqXzY7v6SF09k1uu/ma749rJP0d+Nh5NfOO+4oHM0s1Rap+KH9+KfphZ19UosxRmJhlrM
        RcWJAKldvqDgAgAA
X-CMS-MailID: 20200702024559epcas2p37b3f2f6c2cafd1f033d129032339ca16
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702024559epcas2p37b3f2f6c2cafd1f033d129032339ca16
References: <cover.1593657314.git.kwmad.kim@samsung.com>
        <CGME20200702024559epcas2p37b3f2f6c2cafd1f033d129032339ca16@epcas2p3.samsung.com>
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
index 0000000..062fb03
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
+		dev_err(dev, ": 0x%02x, %02d, 0x%08lx, 0x%04x, %d, %llu, %llu, 0x%llx %s",
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
+	if (!ufs)
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
index 440f2af..7f5142e 100644
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
+	struct scsi_cmnd *cmd = &hba->lrb[tag].cmd
 
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
+	struct scsi_cmnd *cmd = &hba->lrb[tag].cmd
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

