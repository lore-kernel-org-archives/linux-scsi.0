Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276F7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352247AbiDLS0z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245485AbiDLS0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:26:54 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547D51D0E7
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:24:35 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id t4so18023396pgc.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0O12rwtgqsHEmh9lUh1HTTmix4Cj2OTFSsOdoZF0Vc0=;
        b=mnmL7d0+sJ38/WKOPa0u/3jUn/hvJbKF1qtWLgACZTEeGwl9Ol8zhiFany0hHMfbQ4
         B0sK0f7nEgyioTzGLzo6KwauxOR9ajbarG9nGC1N9DY1OaWM3esY6a6LQ0yN5QhVI3dF
         Xx3EpTxg9BOKeNmZabXCaT0wQvQHSHyLJL4v70TQpvuURFqGmNuP6cuy3k8WRkz8cOJI
         sUsJ8qbQEVhNayf9NoLRz8X2nLqyC+HY4QPtzDbOliG7nH/u+0JsewnhWoWJiTIi0Caw
         hnPaoHzgop6inyPYxpGJzZnclFgyISZYoOdNjwmNBZRlMBvJ08mrawiPYJUwRaBUraQd
         lqJg==
X-Gm-Message-State: AOAM533TYqG5bRweGWXmqtg8uWx+AgW2PykfZTZr0ndnpMoq3VSxMAWG
        yaFNai5cHTQCA6TfV6KcL9wANvR8IIQBVFyR
X-Google-Smtp-Source: ABdhPJxfSLWiu8Q+PXwtwdvai2jFmwaauYpPS63c4/mQ5AijW+/3YK60CRjpVpM1LX3lzdBjl9n7PQ==
X-Received: by 2002:a63:ad45:0:b0:382:2459:5bc6 with SMTP id y5-20020a63ad45000000b0038224595bc6mr32498462pgo.474.1649787874688;
        Tue, 12 Apr 2022 11:24:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:24:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Ye Bin <yebin10@huawei.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 25/29] scsi: ufs: Minimize #include directives
Date:   Tue, 12 Apr 2022 11:18:49 -0700
Message-Id: <20220412181853.3715080-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only include those headers of which the declarations are used directly.

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
