Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFF9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358411AbiDSXCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358400AbiDSXB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:57 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF0C38BF0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:08 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id n22so236598pfa.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1vcSv+MVLdh1Wfw67TIbF/fd+t7Zg8wj9NqjsvB59t0=;
        b=Rs/jpMXKo6fCnalk08gncHlcYYzrOhr5onoqUfvuwiwJ5mYJCtlU7J/sjgZK60rYLb
         pK4lB6GjQc0H6mDEd+KkENSPlB/fq7vkSOVhXTJUyICucQG2NGHpuhED1NLLnL765Jqy
         1AP4yxFJenX5eFOvyxGQtuSp4V7k0+61/diSb7zDX5X6emRzcl1of3uobd+y3dSrnBtA
         HR4II1pVZssnYIw0R39V7JdNvKwNCxEvYbwOuuRDujbDfj2RqoRIZec1jOBcNxfsKclv
         BUy3lI7GTPe/DFOaXpMC4CXe/RrcC/VUnlrJejEG4SXk2+MC97oHa548dsHcNoW2K3St
         Iydw==
X-Gm-Message-State: AOAM532kdVd0s1GGR92ast8ohSIk9J1pkLSUAoCkKCHWdJT9wD+/J09a
        /BGx8WX8BkZCrqjzbT2dH80=
X-Google-Smtp-Source: ABdhPJyJ8K62ABOmAN0B65Iz7brB0VqwNzKSjIQ9vVqeT6xaqHJPSjier+l3w5M/GV1OOjKF40YZNg==
X-Received: by 2002:a05:6a00:e0b:b0:4fa:a167:5b35 with SMTP id bq11-20020a056a000e0b00b004faa1675b35mr20337166pfb.69.1650409148320;
        Tue, 19 Apr 2022 15:59:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:59:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 25/28] scsi: ufs: Minimize #include directives
Date:   Tue, 19 Apr 2022 15:58:08 -0700
Message-Id: <20220419225811.4127248-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Follow the convention that is used elsewhere in the Linux kernel source code
and only include those headers of which the declarations are used directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/cdns-pltfrm.c        |  1 +
 drivers/scsi/ufs/tc-dwc-g210-pci.c    |  1 +
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c |  1 +
 drivers/scsi/ufs/tc-dwc-g210.c        |  2 ++
 drivers/scsi/ufs/tc-dwc-g210.h        |  2 ++
 drivers/scsi/ufs/ufs-exynos.c         |  1 +
 drivers/scsi/ufs/ufs-hisi.c           |  2 ++
 drivers/scsi/ufs/ufs-mediatek.c       |  3 +++
 drivers/scsi/ufs/ufs-qcom-ice.c       |  1 +
 drivers/scsi/ufs/ufs-qcom.c           |  4 ++++
 drivers/scsi/ufs/ufs-sysfs.c          |  1 +
 drivers/scsi/ufs/ufs-sysfs.h          |  3 ++-
 drivers/scsi/ufs/ufs_bsg.c            |  5 ++++
 drivers/scsi/ufs/ufs_bsg.h            |  7 +-----
 drivers/scsi/ufs/ufshcd-crypto.h      |  5 ++--
 drivers/scsi/ufs/ufshcd-dwc.c         |  2 ++
 drivers/scsi/ufs/ufshcd-dwc.h         |  2 ++
 drivers/scsi/ufs/ufshcd-pci.c         |  2 ++
 drivers/scsi/ufs/ufshcd-pltfrm.c      |  1 +
 drivers/scsi/ufs/ufshcd.c             |  9 ++++++++
 drivers/scsi/ufs/ufshcd.h             | 33 ++++-----------------------
 drivers/scsi/ufs/ufshci.h             |  2 ++
 drivers/scsi/ufs/ufshpb.c             |  4 ++++
 23 files changed, 56 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index e91cf9fd5a95..e05c0ae64eea 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 7b08e2e07cc5..e635c211c783 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -11,6 +11,7 @@
 #include "ufshcd-dwc.h"
 #include "tc-dwc-g210.h"
 
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
index 783ec43efa78..f15a84d0c176 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 
 #include "ufshcd-pltfrm.h"
 #include "ufshcd-dwc.h"
diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
index f954a68f6b4c..7ef67c9fc5b8 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs/tc-dwc-g210.c
@@ -7,6 +7,8 @@
  * Authors: Joao Pinto <jpinto@synopsys.com>
  */
 
+#include <linux/module.h>
+
 #include "ufshcd.h"
 #include "unipro.h"
 
diff --git a/drivers/scsi/ufs/tc-dwc-g210.h b/drivers/scsi/ufs/tc-dwc-g210.h
index 5a506da03f4a..f7154012f5c7 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.h
+++ b/drivers/scsi/ufs/tc-dwc-g210.h
@@ -10,6 +10,8 @@
 #ifndef _TC_DWC_G210_H
 #define _TC_DWC_G210_H
 
+struct ufs_hba;
+
 int tc_dwc_g210_config_40_bit(struct ufs_hba *hba);
 int tc_dwc_g210_config_20_bit(struct ufs_hba *hba);
 
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 0b99c74955ef..ddb2d42605c5 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index ab1a7ebd89b1..7046143063ee 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -7,6 +7,8 @@
  */
 
 #include <linux/time.h>
+#include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 84ccb5258736..083d6bd4d561 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -8,6 +8,9 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/bitfield.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index 921d6a93b653..745e48ec598f 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -6,6 +6,7 @@
  * Copyright 2019 Google LLC
  */
 
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/qcom_scm.h>
 
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 98ed9e9f7e2e..a63844961222 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -5,6 +5,9 @@
 
 #include <linux/acpi.h>
 #include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
@@ -18,6 +21,7 @@
 #include "ufs-qcom.h"
 #include "ufshci.h"
 #include "ufs_quirks.h"
+
 #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
 	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
 
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 5c405ff7b6ea..95a4e64ce401 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -8,6 +8,7 @@
 
 #include "ufs.h"
 #include "ufs-sysfs.h"
+#include "ufshcd.h"
 
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs/ufs-sysfs.h
index 0f4e750a6748..8d94af3b8077 100644
--- a/drivers/scsi/ufs/ufs-sysfs.h
+++ b/drivers/scsi/ufs/ufs-sysfs.h
@@ -7,11 +7,12 @@
 
 #include <linux/sysfs.h>
 
-#include "ufshcd.h"
+struct device;
 
 void ufs_sysfs_add_nodes(struct device *dev);
 void ufs_sysfs_remove_nodes(struct device *dev);
 
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
 extern const struct attribute_group ufs_sysfs_lun_attributes_group;
+
 #endif
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 39bf204c6ec3..fbcdfb713542 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -4,7 +4,12 @@
  *
  * Copyright (C) 2018 Western Digital Corporation
  */
+
+#include <linux/bsg-lib.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
 #include "ufs_bsg.h"
+#include "ufshcd.h"
 
 static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
 				       struct utp_upiu_query *qr)
diff --git a/drivers/scsi/ufs/ufs_bsg.h b/drivers/scsi/ufs/ufs_bsg.h
index d09918758631..57712d2656d2 100644
--- a/drivers/scsi/ufs/ufs_bsg.h
+++ b/drivers/scsi/ufs/ufs_bsg.h
@@ -5,12 +5,7 @@
 #ifndef UFS_BSG_H
 #define UFS_BSG_H
 
-#include <linux/bsg-lib.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-
-#include "ufshcd.h"
-#include "ufs.h"
+struct ufs_hba;
 
 #ifdef CONFIG_SCSI_UFS_BSG
 void ufs_bsg_remove(struct ufs_hba *hba);
diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/scsi/ufs/ufshcd-crypto.h
index e18c01276873..57dd51256b57 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.h
+++ b/drivers/scsi/ufs/ufshcd-crypto.h
@@ -6,9 +6,10 @@
 #ifndef _UFSHCD_CRYPTO_H
 #define _UFSHCD_CRYPTO_H
 
-#ifdef CONFIG_SCSI_UFS_CRYPTO
+#include <scsi/scsi_cmnd.h>
 #include "ufshcd.h"
-#include "ufshci.h"
+
+#ifdef CONFIG_SCSI_UFS_CRYPTO
 
 static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
 					      struct ufshcd_lrb *lrbp)
diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/scsi/ufs/ufshcd-dwc.c
index 5bb9d3a88795..a57973c8d2a1 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.c
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -7,6 +7,8 @@
  * Authors: Joao Pinto <jpinto@synopsys.com>
  */
 
+#include <linux/module.h>
+
 #include "ufshcd.h"
 #include "unipro.h"
 
diff --git a/drivers/scsi/ufs/ufshcd-dwc.h b/drivers/scsi/ufs/ufshcd-dwc.h
index 4268ca2eb64c..43b70794e24f 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.h
+++ b/drivers/scsi/ufs/ufshcd-dwc.h
@@ -10,6 +10,8 @@
 #ifndef _UFSHCD_DWC_H
 #define _UFSHCD_DWC_H
 
+#include "ufshcd.h"
+
 struct ufshcd_dme_attr_val {
 	u32 attr_sel;
 	u32 mib_val;
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index d36873bc44fe..5fe30dcf98b4 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -10,6 +10,8 @@
  */
 
 #include "ufshcd.h"
+#include <linux/delay.h>
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index fc5191101192..f5313f407617 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -8,6 +8,7 @@
  *	Vinayak Holikatti <h.vinayak@samsung.com>
  */
 
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cb74a9eeee70..5308f43bda6e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -16,7 +16,16 @@
 #include <linux/bitfield.h>
 #include <linux/blk-pm.h>
 #include <linux/blkdev.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/nls.h>
+#include <linux/regulator/consumer.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 412fe43cd763..ab0c643296c0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -12,38 +12,13 @@
 #ifndef _UFSHCD_H
 #define _UFSHCD_H
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
-#include <linux/workqueue.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-#include <linux/wait.h>
-#include <linux/bitops.h>
-#include <linux/pm_runtime.h>
-#include <linux/clk.h>
-#include <linux/completion.h>
-#include <linux/regulator/consumer.h>
 #include <linux/bitfield.h>
-#include <linux/devfreq.h>
 #include <linux/blk-crypto-profile.h>
+#include <linux/blk-mq.h>
+#include <linux/devfreq.h>
+#include <linux/pm_runtime.h>
+#include <scsi/scsi_device.h>
 #include "unipro.h"
-
-#include <asm/irq.h>
-#include <asm/byteorder.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi_dbg.h>
-#include <scsi/scsi_eh.h>
-
 #include "ufs.h"
 #include "ufs_quirks.h"
 #include "ufshci.h"
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index a7ff0e5b5494..f81aa95ffbc4 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -11,6 +11,8 @@
 #ifndef _UFSHCI_H
 #define _UFSHCI_H
 
+#include <scsi/scsi_host.h>
+
 enum {
 	TASK_REQ_UPIU_SIZE_DWORDS	= 8,
 	TASK_RSP_UPIU_SIZE_DWORDS	= 8,
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index ebd8fc8fc109..5a974642779f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -10,6 +10,10 @@
  */
 
 #include <asm/unaligned.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <scsi/scsi_cmnd.h>
 
 #include "ufshcd.h"
 #include "ufshpb.h"
