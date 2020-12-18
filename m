Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4C0C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 12:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 779002395C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 12:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgLRMVU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 07:21:20 -0500
Received: from mga03.intel.com ([134.134.136.65]:6657 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgLRMVU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Dec 2020 07:21:20 -0500
IronPort-SDR: UeQGSF7nEcKrlI9sDNKCsgG6+rYN3SBXPsQQ5j1EFlP5nlNpc5C1iIm5CHZojCnpvPTP3LVjeR
 IHooU/jEvrWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="175528804"
X-IronPort-AV: E=Sophos;i="5.78,430,1599548400"; 
   d="scan'208";a="175528804"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 04:20:38 -0800
IronPort-SDR: 7dsoXXhv+Gu3iJwp1d85NjwUw2JhsYLWoZHFwLQgspXJe2wzOhoEgENVcdIumiXBfHJoXQabrU
 k3WPV3VvM98Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,430,1599548400"; 
   d="scan'208";a="370549471"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.94])
  by orsmga008.jf.intel.com with ESMTP; 18 Dec 2020 04:20:36 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH V3] scsi: ufs-debugfs: Add error counters
Date:   Fri, 18 Dec 2020 14:20:27 +0200
Message-Id: <20201218122027.27472-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

People testing have a need to know how many errors might be occurring
over time. Add error counters and expose them via debugfs.

A module initcall is used to create a debugfs root directory for
ufshcd-related items. In the case that modules are built-in, then
initialization is done in link order, so move ufshcd-core to the top of
the Makefile.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---


Changes in V3:
	Fixed link order to ensure correct initcall ordering when
	modules are built-in.
	Amended commit message accordingly.

Changes in V2:
	Add missing '#include "ufs-debugfs.h"' in ufs-debugfs.c
	Reported-by: kernel test robot <lkp@intel.com>


 drivers/scsi/ufs/Makefile      | 13 +++++---
 drivers/scsi/ufs/ufs-debugfs.c | 56 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-debugfs.h | 22 +++++++++++++
 drivers/scsi/ufs/ufshcd.c      | 19 ++++++++++++
 drivers/scsi/ufs/ufshcd.h      |  5 +++
 5 files changed, 111 insertions(+), 4 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-debugfs.c
 create mode 100644 drivers/scsi/ufs/ufs-debugfs.h

diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 4679af1b564e..06f3a3fe4a44 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,5 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0
 # UFSHCD makefile
+
+# The link order is important here. ufshcd-core must initialize
+# before vendor drivers.
+obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
+ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
+ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
+ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
+ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
+
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
@@ -7,10 +16,6 @@ obj-$(CONFIG_SCSI_UFS_QCOM) += ufs_qcom.o
 ufs_qcom-y += ufs-qcom.o
 ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) += ufs-qcom-ice.o
 obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
-obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
-ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
-ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
-ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) += ufshcd-crypto.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
new file mode 100644
index 000000000000..dee98dc72d29
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2020 Intel Corporation
+
+#include <linux/debugfs.h>
+
+#include "ufs-debugfs.h"
+#include "ufshcd.h"
+
+static struct dentry *ufs_debugfs_root;
+
+void __init ufs_debugfs_init(void)
+{
+	ufs_debugfs_root = debugfs_create_dir("ufshcd", NULL);
+}
+
+void __exit ufs_debugfs_exit(void)
+{
+	debugfs_remove_recursive(ufs_debugfs_root);
+}
+
+static int ufs_debugfs_stats_show(struct seq_file *s, void *data)
+{
+	struct ufs_hba *hba = s->private;
+	struct ufs_event_hist *e = hba->ufs_stats.event;
+
+#define PRT(fmt, typ) \
+	seq_printf(s, fmt, e[UFS_EVT_ ## typ].cnt)
+
+	PRT("PHY Adapter Layer errors (except LINERESET): %llu\n", PA_ERR);
+	PRT("Data Link Layer errors: %llu\n", DL_ERR);
+	PRT("Network Layer errors: %llu\n", NL_ERR);
+	PRT("Transport Layer errors: %llu\n", TL_ERR);
+	PRT("Generic DME errors: %llu\n", DME_ERR);
+	PRT("Auto-hibernate errors: %llu\n", AUTO_HIBERN8_ERR);
+	PRT("IS Fatal errors (CEFES, SBFES, HCFES, DFES): %llu\n", FATAL_ERR);
+	PRT("DME Link Startup errors: %llu\n", LINK_STARTUP_FAIL);
+	PRT("PM Resume errors: %llu\n", RESUME_ERR);
+	PRT("PM Suspend errors : %llu\n", SUSPEND_ERR);
+	PRT("Logical Unit Resets: %llu\n", DEV_RESET);
+	PRT("Host Resets: %llu\n", HOST_RESET);
+	PRT("SCSI command aborts: %llu\n", ABORT);
+#undef PRT
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(ufs_debugfs_stats);
+
+void ufs_debugfs_hba_init(struct ufs_hba *hba)
+{
+	hba->debugfs_root = debugfs_create_dir(dev_name(hba->dev), ufs_debugfs_root);
+	debugfs_create_file("stats", 0400, hba->debugfs_root, hba, &ufs_debugfs_stats_fops);
+}
+
+void ufs_debugfs_hba_exit(struct ufs_hba *hba)
+{
+	debugfs_remove_recursive(hba->debugfs_root);
+}
diff --git a/drivers/scsi/ufs/ufs-debugfs.h b/drivers/scsi/ufs/ufs-debugfs.h
new file mode 100644
index 000000000000..f35b39c4b4f5
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-debugfs.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2020 Intel Corporation
+ */
+
+#ifndef __UFS_DEBUGFS_H__
+#define __UFS_DEBUGFS_H__
+
+struct ufs_hba;
+
+#ifdef CONFIG_DEBUG_FS
+void __init ufs_debugfs_init(void);
+void __exit ufs_debugfs_exit(void);
+void ufs_debugfs_hba_init(struct ufs_hba *hba);
+void ufs_debugfs_hba_exit(struct ufs_hba *hba);
+#else
+static inline void ufs_debugfs_init(void) {}
+static inline void ufs_debugfs_exit(void) {}
+static inline void ufs_debugfs_hba_init(struct ufs_hba *hba) {}
+static inline void ufs_debugfs_hba_exit(struct ufs_hba *hba) {}
+#endif
+
+#endif
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 82ad31781bc9..d8a3cf0cd6d5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -20,6 +20,7 @@
 #include "ufs_quirks.h"
 #include "unipro.h"
 #include "ufs-sysfs.h"
+#include "ufs-debugfs.h"
 #include "ufs_bsg.h"
 #include "ufshcd-crypto.h"
 #include <asm/unaligned.h>
@@ -4540,6 +4541,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 	e = &hba->ufs_stats.event[id];
 	e->val[e->pos] = val;
 	e->tstamp[e->pos] = ktime_get();
+	e->cnt += 1;
 	e->pos = (e->pos + 1) % UFS_EVENT_HIST_LENGTH;
 
 	ufshcd_vops_event_notify(hba, id, &val);
@@ -8334,6 +8336,8 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_vreg;
 
+	ufs_debugfs_hba_init(hba);
+
 	hba->is_powered = true;
 	goto out;
 
@@ -8350,6 +8354,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 static void ufshcd_hba_exit(struct ufs_hba *hba)
 {
 	if (hba->is_powered) {
+		ufs_debugfs_hba_exit(hba);
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_suspend_clkscaling(hba);
@@ -9436,6 +9441,20 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(ufshcd_init);
 
+static int __init ufshcd_core_init(void)
+{
+	ufs_debugfs_init();
+	return 0;
+}
+
+static void __exit ufshcd_core_exit(void)
+{
+	ufs_debugfs_exit();
+}
+
+module_init(ufshcd_core_init);
+module_exit(ufshcd_core_exit);
+
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index aa9ea3552323..8c51ce01517e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -445,11 +445,13 @@ struct ufs_clk_scaling {
  * @pos: index to indicate cyclic buffer position
  * @reg: cyclic buffer for registers value
  * @tstamp: cyclic buffer for time stamp
+ * @cnt: error counter
  */
 struct ufs_event_hist {
 	int pos;
 	u32 val[UFS_EVENT_HIST_LENGTH];
 	ktime_t tstamp[UFS_EVENT_HIST_LENGTH];
+	unsigned long long cnt;
 };
 
 /**
@@ -817,6 +819,9 @@ struct ufs_hba {
 	u32 crypto_cfg_register;
 	struct blk_keyslot_manager ksm;
 #endif
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs_root;
+#endif
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
-- 
2.17.1

