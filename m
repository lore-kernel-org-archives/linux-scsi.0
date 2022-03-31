Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21601C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbiCaWlG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbiCaWlF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:41:05 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC7A1B2C4B
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:39:17 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id bo5so943345pfb.4
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f2bgAbeJl2udB5y6HivRFljaDQS1jziVt2qOdGm9W6c=;
        b=lrhLUtDXCltg/KiT5o7b3BrrUBpqxFrS+4hA0YhHGcLC9R5QopULsL0ZLpUJvp+iQg
         WN3+CKbH6eqDWLJPWznAOuoBoQlwFtmaD4lqPngtigCnPL72cx++drK11oxGixsxemSf
         GwuPHcKDmc/BmiIpbkWvwMmzTpj/Ccyojpm9o5z2iG2N0lBb/lMswb6rKuWTIOdxFhDZ
         nxtWMczmyxlwVbntAkHTMsYcmLW5GxtF7LuRCUCHoNz42jg+ECiRRoy4hSbu49drbFOb
         R+R2qdPIu+Sw/BYZA5l8VpIzy9Zost8aZyb4LSaJHwHk1YAfUAkrsufF64jBJueUu4v3
         w66A==
X-Gm-Message-State: AOAM533UsMSTNX1JMkyCf32D/noa4qLxRRIdxt27uaHp2m9vy6eSoY6q
        AhRH5g3hTJVvmGO67RhRi2c=
X-Google-Smtp-Source: ABdhPJzldrSnoaPy16qkvC4LYfh6wnv5fBrUpXi3pQoPvxbYC8hYRG8RIh7xIwLyG9QJ4xOIc2uAmQ==
X-Received: by 2002:aa7:8385:0:b0:4f6:ef47:e943 with SMTP id u5-20020aa78385000000b004f6ef47e943mr7875002pfm.38.1648766356808;
        Thu, 31 Mar 2022 15:39:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:39:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Can Guo <cang@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 25/29] scsi: ufs: Minimize #include directives
Date:   Thu, 31 Mar 2022 15:34:20 -0700
Message-Id: <20220331223424.1054715-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only include those headers of which the declarations are used directly.
Sort #include directives alphabetically.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/cdns-pltfrm.c         |  4 ++--
 drivers/scsi/ufs/tc-dwc-g210-pci.c     |  8 +++----
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c  | 10 ++++----
 drivers/scsi/ufs/tc-dwc-g210.c         |  8 +++----
 drivers/scsi/ufs/tc-dwc-g210.h         |  2 ++
 drivers/scsi/ufs/ufs-exynos.c          |  1 +
 drivers/scsi/ufs/ufs-fault-injection.c |  4 ++--
 drivers/scsi/ufs/ufs-hisi.c            | 15 ++++++------
 drivers/scsi/ufs/ufs-mediatek.c        |  4 +++-
 drivers/scsi/ufs/ufs-qcom-ice.c        |  2 +-
 drivers/scsi/ufs/ufs-qcom.c            | 23 ++++++++++--------
 drivers/scsi/ufs/ufs-sysfs.c           |  8 +++----
 drivers/scsi/ufs/ufs-sysfs.h           |  3 ++-
 drivers/scsi/ufs/ufs_bsg.c             |  5 ++++
 drivers/scsi/ufs/ufs_bsg.h             |  7 +-----
 drivers/scsi/ufs/ufshcd-crypto.h       |  5 ++--
 drivers/scsi/ufs/ufshcd-dwc.c          |  6 ++---
 drivers/scsi/ufs/ufshcd-dwc.h          |  2 ++
 drivers/scsi/ufs/ufshcd-pci.c          | 12 ++++++----
 drivers/scsi/ufs/ufshcd-pltfrm.c       |  4 ++--
 drivers/scsi/ufs/ufshcd.c              | 24 ++++++++++++-------
 drivers/scsi/ufs/ufshcd.h              | 33 ++++----------------------
 drivers/scsi/ufs/ufshci.h              |  2 ++
 drivers/scsi/ufs/ufshpb.c              |  7 ++++--
 24 files changed, 101 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index e91cf9fd5a95..4d05a3b1e4eb 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -9,12 +9,12 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/of.h>
+#include <linux/platform_device.h>
 #include <linux/time.h>
-
 #include "ufshcd-pltfrm.h"
 
 #define CDNS_UFS_REG_HCLKDIV	0xFC
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 7b08e2e07cc5..d679eff3f2f0 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -7,12 +7,12 @@
  * Authors: Joao Pinto <jpinto@synopsys.com>
  */
 
-#include "ufshcd.h"
-#include "ufshcd-dwc.h"
-#include "tc-dwc-g210.h"
-
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
+#include "tc-dwc-g210.h"
+#include "ufshcd-dwc.h"
+#include "ufshcd.h"
 
 /* Test Chip type expected values */
 #define TC_G210_20BIT 20
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
index 783ec43efa78..56468268deb8 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
@@ -7,15 +7,15 @@
  * Authors: Joao Pinto <jpinto@synopsys.com>
  */
 
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/of.h>
-#include <linux/delay.h>
-
-#include "ufshcd-pltfrm.h"
-#include "ufshcd-dwc.h"
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include "tc-dwc-g210.h"
+#include "ufshcd-dwc.h"
+#include "ufshcd-pltfrm.h"
 
 /*
  * UFS DWC specific variant operations
diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
index f954a68f6b4c..c1b236f09601 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs/tc-dwc-g210.c
@@ -7,12 +7,12 @@
  * Authors: Joao Pinto <jpinto@synopsys.com>
  */
 
-#include "ufshcd.h"
-#include "unipro.h"
-
+#include <linux/module.h>
+#include "tc-dwc-g210.h"
 #include "ufshcd-dwc.h"
+#include "ufshcd.h"
 #include "ufshci-dwc.h"
-#include "tc-dwc-g210.h"
+#include "unipro.h"
 
 /**
  * tc_dwc_g210_setup_40bit_rmmi()
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
diff --git a/drivers/scsi/ufs/ufs-fault-injection.c b/drivers/scsi/ufs/ufs-fault-injection.c
index 7ac7c4e7ff83..2453ea8ff265 100644
--- a/drivers/scsi/ufs/ufs-fault-injection.c
+++ b/drivers/scsi/ufs/ufs-fault-injection.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#include <linux/kconfig.h>
-#include <linux/types.h>
 #include <linux/fault-inject.h>
+#include <linux/kconfig.h>
 #include <linux/module.h>
+#include <linux/types.h>
 #include "ufs-fault-injection.h"
 
 static int ufs_fault_get(char *buffer, const struct kernel_param *kp);
diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index ab1a7ebd89b1..8f6168471464 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -6,19 +6,20 @@
  * Copyright (c) 2016-2017 HiSilicon Technologies Co., Ltd.
  */
 
-#include <linux/time.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
-
-#include "ufshcd.h"
-#include "ufshcd-pltfrm.h"
-#include "unipro.h"
+#include <linux/time.h>
 #include "ufs-hisi.h"
-#include "ufshci.h"
 #include "ufs_quirks.h"
+#include "ufshcd-pltfrm.h"
+#include "ufshcd.h"
+#include "ufshci.h"
+#include "unipro.h"
 
 static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 84ccb5258736..b804e969915b 100644
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
@@ -17,7 +20,6 @@
 #include <linux/reset.h>
 #include <linux/sched/clock.h>
 #include <linux/soc/mediatek/mtk_sip_svc.h>
-
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
 #include "ufs_quirks.h"
diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index 921d6a93b653..ee73c1b0d96b 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -6,9 +6,9 @@
  * Copyright 2019 Google LLC
  */
 
+#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/qcom_scm.h>
-
 #include "ufs-qcom.h"
 
 #define AES_256_XTS_KEY_SIZE			64
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 808dae751527..9a390cd516bd 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -4,21 +4,24 @@
  */
 
 #include <linux/acpi.h>
-#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/devfreq.h>
+#include <linux/gpio/consumer.h>
+#include <linux/module.h>
 #include <linux/of.h>
-#include <linux/platform_device.h>
 #include <linux/phy/phy.h>
-#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
 #include <linux/reset-controller.h>
-#include <linux/devfreq.h>
-
-#include "ufshcd.h"
-#include "ufshcd-pltfrm.h"
-#include "unipro.h"
+#include <linux/time.h>
 #include "ufs-qcom.h"
-#include "ufshci.h"
 #include "ufs_quirks.h"
-#define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
+#include "ufshcd-pltfrm.h"
+#include "ufshcd.h"
+#include "ufshci.h"
+#include "unipro.h"
+
+#define UFS_QCOM_DEFAULT_DBG_PRINT_EN					\
 	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
 
 enum {
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 5c405ff7b6ea..2bf128e4b613 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -1,13 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2018 Western Digital Corporation
 
+#include <asm/unaligned.h>
+#include <linux/bitfield.h>
 #include <linux/err.h>
 #include <linux/string.h>
-#include <linux/bitfield.h>
-#include <asm/unaligned.h>
-
-#include "ufs.h"
 #include "ufs-sysfs.h"
+#include "ufs.h"
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
index 5bb9d3a88795..8f1786be3556 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.c
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -7,11 +7,11 @@
  * Authors: Joao Pinto <jpinto@synopsys.com>
  */
 
-#include "ufshcd.h"
-#include "unipro.h"
-
+#include <linux/module.h>
 #include "ufshcd-dwc.h"
+#include "ufshcd.h"
 #include "ufshci-dwc.h"
+#include "unipro.h"
 
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n)
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
index d36873bc44fe..45df431c720c 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -9,14 +9,16 @@
  *	Vinayak Holikatti <h.vinayak@samsung.com>
  */
 
-#include "ufshcd.h"
+#include <linux/acpi.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/gpio/consumer.h>
+#include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
-#include <linux/debugfs.h>
+#include <linux/pm_runtime.h>
 #include <linux/uuid.h>
-#include <linux/acpi.h>
-#include <linux/gpio/consumer.h>
+#include "ufshcd.h"
 
 struct ufs_host {
 	void (*late_init)(struct ufs_hba *hba);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 81e458d31222..a1ff5bfd4f71 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -8,10 +8,10 @@
  *	Vinayak Holikatti <h.vinayak@samsung.com>
  */
 
+#include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/of.h>
-
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
 #include "unipro.h"
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7d04cf8d75ef..de366247628b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9,24 +9,32 @@
  *	Vinayak Holikatti <h.vinayak@samsung.com>
  */
 
+#include <asm/unaligned.h>
 #include <linux/async.h>
-#include <linux/devfreq.h>
-#include <linux/nls.h>
-#include <linux/of.h>
 #include <linux/bitfield.h>
 #include <linux/blk-pm.h>
 #include <linux/blkdev.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/devfreq.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/nls.h>
+#include <linux/of.h>
+#include <linux/regulator/consumer.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_driver.h>
-#include "ufshcd.h"
-#include "ufs_quirks.h"
-#include "unipro.h"
-#include "ufs-sysfs.h"
+#include <scsi/scsi_eh.h>
 #include "ufs-debugfs.h"
 #include "ufs-fault-injection.h"
+#include "ufs-sysfs.h"
 #include "ufs_bsg.h"
+#include "ufs_quirks.h"
 #include "ufshcd-crypto.h"
+#include "ufshcd.h"
 #include "ufshpb.h"
-#include <asm/unaligned.h>
+#include "unipro.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ufs.h>
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
index b2bec19022cd..d456404e5c49 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -10,10 +10,13 @@
  */
 
 #include <asm/unaligned.h>
-
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <scsi/scsi_cmnd.h>
+#include "../sd.h"
 #include "ufshcd.h"
 #include "ufshpb.h"
-#include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
 #define READ_TO_MS 1000
