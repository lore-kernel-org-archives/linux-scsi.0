Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12ECC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0D6420774
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="u2b/E+/i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgGHCcF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:32:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58712 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbgGHCcE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 22:32:04 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200708023159epoutp02eccd74b041faa6241fa48d517a05d8a5~fpjBoit8L2329523295epoutp02D
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 02:31:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200708023159epoutp02eccd74b041faa6241fa48d517a05d8a5~fpjBoit8L2329523295epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594175519;
        bh=MUy/Sd11tehdFdGFXPjtZ4KPXKHhYYxmUvSHJuj/Vx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=u2b/E+/iccem+wgmOGxNnohFR4QsQIRVjsa3QYxPOtiCNSNOhoKYKVO/vwSIYQuMG
         7zgsE20lb+OF2aKWI8UGJjpC9zVyTgUhIyqHohHkW0sfmzCg69P4f+gxAGY+JMpgxc
         tpiOvqGbXtH0sq4IXNVLQ/4btErY2/lgCL6Gc7po=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200708023159epcas2p4b8e7cb5f1f8a7573f69825caccfdc331~fpjBFkSiT0831308313epcas2p4v;
        Wed,  8 Jul 2020 02:31:59 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B1jxT27wpzMqYkc; Wed,  8 Jul
        2020 02:31:57 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.FD.27441.C10350F5; Wed,  8 Jul 2020 11:31:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200708023156epcas2p416ac7979ed0a0a7a71de1636defb0ec7~fpi_AYo-g1542115421epcas2p4T;
        Wed,  8 Jul 2020 02:31:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200708023156epsmtrp1ba79f4fe2e5c9849a495026600bfdee3~fpi9-h-oZ1232012320epsmtrp1T;
        Wed,  8 Jul 2020 02:31:56 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-1c-5f05301c0aa4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.82.08303.B10350F5; Wed,  8 Jul 2020 11:31:55 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200708023155epsmtip229a01aeb4fff4bbf071c0770e4092b63~fpi9z9RdO0365703657epsmtip2E;
        Wed,  8 Jul 2020 02:31:55 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND RFC PATCH v4 2/3] ufs: exynos: introduce command history
Date:   Wed,  8 Jul 2020 11:24:00 +0900
Message-Id: <da700e31d9a8598c247269746aef3c09a92e71e8.1594174981.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594174981.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594174981.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmua6MAWu8wdWPKhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIz3ExuZCiYkVszd9ZG5gXFnQBcjJ4eEgInEga6zLF2MXBxCAjsYJW7OecgO4XxilDjb2cEE
        4XxmlLhw4wRrFyMHWMuGi9wQ8V2MEhv+3ITq+MEoce3He1aQuWwCmhJPb04F6xYR2Mwk8WrB
        fWaQBLOAusSuCSeYQGxhAU+JZ/++gNksAqoSt/b/YQGxeQWiJVbc2s8EcaCcxM1znWC9nAKW
        Ei9/dLGjsrmAamZySJxYcZoRosFFYkb3LmYIW1ji1fEt7BC2lMTL/jYou15i39QGVojmHkaJ
        p/v+QTUbS8x61s4I8icz0Avrd+lDvKwsceQWC8T9fBIdh/+yQ4R5JTrahCAalSV+TZoMNURS
        YubNO1CbPCROTdrKBgkgoE23D7SxTmCUn4WwYAEj4ypGsdSC4tz01GKjAmPk6NvECE6lWu47
        GGe8/aB3iJGJg/EQowQHs5IIr4Eia7wQb0piZVVqUX58UWlOavEhRlNgQE5klhJNzgcm87yS
        eENTIzMzA0tTC1MzIwslcd5iqwtxQgLpiSWp2ampBalFMH1MHJxSDUwq3ReLpPc7ZMRELS3X
        uneMj+P6y5wjfxZVJxdfPm1w3+1kzyExd86DNdvljvFPW/h+6YuVkvXefVfLjs5ONbXq3+Lf
        fecqS+vSFRt9r72ZdZfTo0TPLdIhQfH261PHXzv92H7/XVH25D01zcvXHLxcfeqivckiqUX3
        /z3qVvr99Rxrllh2veyF1edb4vN2q54r/M4V0ah36YC1+ZTtW9w6GrOili8TWdr4ZZaXZsAc
        M1+t7RHr3/a80X419ZuY576a3y91qtl8k2O/714QYKql/qm/n/uofQOD/F4Bu10KGk5t68Km
        c4lndum/CHr07b7a70lunoEs7n53rE035rBtm6iy4W/TpcxtehYfJ8gosRRnJBpqMRcVJwIA
        jPeE9S4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSvK60AWu8wYwX1hYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG+4mNTAUTEivm7vrI3MC4M6CLkYNDQsBEYsNF7i5GLg4hgR2MElca
        LrN1MXICxSUlTux8zghhC0vcbznCClH0jVFi5fPzzCAJNgFNiac3pzKBJEQEDjNJ/N/6nB0k
        wSygLrFrwgkmEFtYwFPi2b8vYDaLgKrErf1/WEBsXoFoiRW39jNBbJCTuHmuE2wop4ClxMsf
        XWBzhAQsJO7t72fCJT6BUWABI8MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgSNDS
        2sG4Z9UHvUOMTByMhxglOJiVRHgNFFnjhXhTEiurUovy44tKc1KLDzFKc7AoifN+nbUwTkgg
        PbEkNTs1tSC1CCbLxMEp1cCk827uqQQWcVHZqy113du9Zr9J6pricm/H7aS1DQ/zG89sfmKp
        9Fg5UFgtZ/P7Ff5yC46yJ6+9tiH74Ocpxh/YLj42jV93p9444UnJU5WF26/HNG73nN99v9py
        +/SFYRNDVHYeWm1sGXdFtPoMn2l+ceosa75izYXPFLIE1qYsZtu9U/vG9Xbj/B9m77IT44QY
        3klPYr7z/vHxSX46SRMnTUj8tvyImn3hJEdWQ+324ndzhK9Ptnat23Ti6l/7B9uCa7ky+G6X
        CpbmhDAbWyyry/rlV/OC9ZmBOafua5aIstObZgerGhRI395yYOK3Cs2z11KjBRc87BBPsI/9
        saU409wt8pzMjmsl3lGzmAKVWIozEg21mIuKEwHuoVbu8wIAAA==
X-CMS-MailID: 20200708023156epcas2p416ac7979ed0a0a7a71de1636defb0ec7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708023156epcas2p416ac7979ed0a0a7a71de1636defb0ec7
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023156epcas2p416ac7979ed0a0a7a71de1636defb0ec7@epcas2p4.samsung.com>
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
 drivers/scsi/ufs/Makefile         |   2 +-
 drivers/scsi/ufs/ufs-exynos-dbg.c | 201 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos-if.h  |  17 ++++
 drivers/scsi/ufs/ufs-exynos.c     |  37 +++++++
 drivers/scsi/ufs/ufs-exynos.h     |  12 +++
 6 files changed, 282 insertions(+), 1 deletion(-)
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
index 0000000..0663026
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-exynos-dbg.c
@@ -0,0 +1,201 @@
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
index 440f2af..8c60f7d 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -700,11 +700,31 @@ static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_UFS_EXYNOS_CMD_LOG
+static void exynos_ufs_cmd_log(struct ufs_hba *hba,
+			       struct scsi_cmnd *cmd, int enter)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	struct ufs_exynos_handle *handle = &ufs->handle;
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
+
+	if (op)
+		exynos_ufs_cmd_log(hba, cmd, 1);
+#endif
 
 	type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
 
@@ -714,6 +734,16 @@ static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
 		hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
 }
 
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
 static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
 						int tag, u8 func)
 {
@@ -1008,6 +1038,12 @@ static int exynos_ufs_init(struct ufs_hba *hba)
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
@@ -1217,6 +1253,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.link_startup_notify		= exynos_ufs_link_startup_notify,
 	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
 	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
+	.compl_xfer_req			= exynos_ufs_compl_xfer_req,
 	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 76d6e39..c947fd8 100644
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
@@ -284,4 +289,11 @@ struct exynos_ufs_uic_attr exynos7_uic_attr = {
 	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),
 	.pa_dbg_option_suite		= 0x30103,
 };
+
+/* public function declarations */
+void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
+			      struct ufs_hba *hba, struct scsi_cmnd *cmd);
+void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
+			    struct ufs_hba *hba, struct scsi_cmnd *cmd);
+int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev);
 #endif /* _UFS_EXYNOS_H_ */
-- 
2.7.4

