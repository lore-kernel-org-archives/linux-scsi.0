Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCBCC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 055302247F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405019AbhAZMOD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:14:03 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11597 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404899AbhAZLJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 06:09:18 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DQ3pw1yM6z15yMc;
        Tue, 26 Jan 2021 19:07:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 19:08:25 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 3/5] scsi: hisi_sas: Enable debugfs support by default
Date:   Tue, 26 Jan 2021 19:04:26 +0800
Message-ID: <1611659068-131975-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1611659068-131975-1-git-send-email-john.garry@huawei.com>
References: <1611659068-131975-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Add a config option to enable debugfs support by default. And if debugfs
support is enabled by default, dump count default value is increased to 50
as generally users want something bigger than the current default in that
situation.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/Kconfig         |  6 ++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 13 +++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index b8148b1733f8..4ba3a8eadb77 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -18,3 +18,9 @@ config SCSI_HISI_SAS_PCI
 	depends on ACPI
 	help
 		This driver supports HiSilicon's SAS HBA based on PCI device
+
+config SCSI_HISI_SAS_DEBUGFS_DEFAULT_ENABLE
+	bool "HiSilicon SAS debugging default enable"
+	depends on SCSI_HISI_SAS
+	help
+		Set Y to default enable DEBUGFS for SCSI_HISI_SAS
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d469ffda9008..a979edfd9a78 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2722,12 +2722,21 @@ int hisi_sas_remove(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_remove);
 
+#if IS_ENABLED(CONFIG_SCSI_HISI_SAS_DEBUGFS_DEFAULT_ENABLE)
+#define DEBUGFS_ENABLE_DEFAULT  "enabled"
+bool hisi_sas_debugfs_enable = true;
+u32 hisi_sas_debugfs_dump_count = 50;
+#else
+#define DEBUGFS_ENABLE_DEFAULT "disabled"
 bool hisi_sas_debugfs_enable;
+u32 hisi_sas_debugfs_dump_count = 1;
+#endif
+
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_enable);
 module_param_named(debugfs_enable, hisi_sas_debugfs_enable, bool, 0444);
-MODULE_PARM_DESC(hisi_sas_debugfs_enable, "Enable driver debugfs (default disabled)");
+MODULE_PARM_DESC(hisi_sas_debugfs_enable,
+		 "Enable driver debugfs (default "DEBUGFS_ENABLE_DEFAULT")");
 
-u32 hisi_sas_debugfs_dump_count = 1;
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_dump_count);
 module_param_named(debugfs_dump_count, hisi_sas_debugfs_dump_count, uint, 0444);
 MODULE_PARM_DESC(hisi_sas_debugfs_dump_count, "Number of debugfs dumps to allow");
-- 
2.26.2

