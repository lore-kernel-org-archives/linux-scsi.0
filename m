Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3397C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbiCaWsI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240258AbiCaWsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:48:07 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FFA231932
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:46:17 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id l129so919582pga.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nwl1sXrd2imTewIBnDwZZvwrapN0YOzGtinEJR5dxkE=;
        b=YXAxkRaY+atajNUAeNLHms64pRTkH6W/UyNItDDMb4nu3QQB8JvlWLqaq/v8uNzHgn
         BO0ZaC+tXcbb+LNCmqkA41ZXlHQQTfjGJBLUXQeBUB1JRrrMhWnrxlOO/Lb8o04EcBFK
         lUaWl43biRcBPXxWPH9d6x2+TKesl0OPuaecC4n8GM5mrTf/ymTfIwkxp/kh2bCTQT2i
         uPJEFOXTtliegX/GwA7a+35Pci/D6Wa618jOK4yj7Cahl8yf1AImzP1ANrV2l7xfKQpy
         b4Un23mU9ZT9OnPK48kGCp2idezCpXBtUOGKcmPnrzMiSXWTE0SYdPyVJU9jkOPX2Juk
         AvQA==
X-Gm-Message-State: AOAM5309MnDaut7EUWHDnUsg9R1/in9SexBp8JsktDUzvni3LBxfrdi1
        qGYpFh1pgmBNp69dpiGO4TE=
X-Google-Smtp-Source: ABdhPJwyVv9/H5OZLrRwEVirBlewkMpzdXYwQXXDX7opQE3IJ+v2Q5BFk6cZNZDZwpquDN9UT46kJg==
X-Received: by 2002:a65:62d0:0:b0:381:d38:c7b0 with SMTP id m16-20020a6562d0000000b003810d38c7b0mr12528549pgv.186.1648766777094;
        Thu, 31 Mar 2022 15:46:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:46:16 -0700 (PDT)
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
        Avri Altman <Avri.Altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ye Bin <yebin10@huawei.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Date:   Thu, 31 Mar 2022 15:34:24 -0700
Message-Id: <20220331223424.1054715-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Kconfig                          |  3 +-
 drivers/scsi/Makefile                         |  4 +-
 drivers/scsi/ufs-core/Kconfig                 | 82 +++++++++++++++++++
 drivers/scsi/ufs-core/Makefile                | 10 +++
 drivers/scsi/{ufs => ufs-core}/ufs-debugfs.c  |  3 +-
 drivers/scsi/{ufs => ufs-core}/ufs-debugfs.h  |  0
 .../{ufs => ufs-core}/ufs-fault-injection.c   |  0
 .../{ufs => ufs-core}/ufs-fault-injection.h   |  0
 drivers/scsi/{ufs => ufs-core}/ufs-hwmon.c    |  3 +-
 drivers/scsi/{ufs => ufs-core}/ufs-sysfs.c    |  1 +
 drivers/scsi/{ufs => ufs-core}/ufs-sysfs.h    |  0
 drivers/scsi/{ufs => ufs-core}/ufs_bsg.c      |  2 +-
 drivers/scsi/{ufs => ufs-core}/ufs_bsg.h      |  0
 .../scsi/{ufs => ufs-core}/ufshcd-crypto.c    |  2 +-
 .../scsi/{ufs => ufs-core}/ufshcd-crypto.h    |  4 +-
 drivers/scsi/{ufs => ufs-core}/ufshcd-priv.h  |  2 +-
 drivers/scsi/{ufs => ufs-core}/ufshcd.c       |  6 +-
 drivers/scsi/{ufs => ufs-core}/ufshpb.c       |  4 +-
 drivers/scsi/{ufs => ufs-core}/ufshpb.h       |  0
 drivers/scsi/{ufs => ufs-drivers}/Kconfig     | 71 +---------------
 drivers/scsi/{ufs => ufs-drivers}/Makefile    | 12 ---
 .../scsi/{ufs => ufs-drivers}/cdns-pltfrm.c   |  0
 .../{ufs => ufs-drivers}/tc-dwc-g210-pci.c    |  2 +-
 .../{ufs => ufs-drivers}/tc-dwc-g210-pltfrm.c |  0
 .../scsi/{ufs => ufs-drivers}/tc-dwc-g210.c   |  4 +-
 .../scsi/{ufs => ufs-drivers}/tc-dwc-g210.h   |  0
 .../scsi/{ufs => ufs-drivers}/ti-j721e-ufs.c  |  0
 .../scsi/{ufs => ufs-drivers}/ufs-exynos.c    | 12 ++-
 .../scsi/{ufs => ufs-drivers}/ufs-exynos.h    |  0
 drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.c  |  8 +-
 drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.h  |  0
 .../{ufs => ufs-drivers}/ufs-mediatek-trace.h |  2 +-
 .../scsi/{ufs => ufs-drivers}/ufs-mediatek.c  |  8 +-
 .../scsi/{ufs => ufs-drivers}/ufs-mediatek.h  |  0
 .../scsi/{ufs => ufs-drivers}/ufs-qcom-ice.c  |  0
 drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.c  |  8 +-
 drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.h  |  2 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-dwc.c    |  4 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-dwc.h    |  2 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-pci.c    |  2 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.c |  4 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.h |  2 +-
 .../scsi/{ufs => ufs-drivers}/ufshci-dwc.h    |  0
 {drivers/scsi/ufs => include/scsi}/ufs.h      |  0
 .../scsi/ufs => include/scsi}/ufs_quirks.h    |  0
 {drivers/scsi/ufs => include/scsi}/ufshcd.h   |  8 +-
 {drivers/scsi/ufs => include/scsi}/ufshci.h   |  0
 {drivers/scsi/ufs => include/scsi}/unipro.h   |  0
 48 files changed, 144 insertions(+), 133 deletions(-)
 create mode 100644 drivers/scsi/ufs-core/Kconfig
 create mode 100644 drivers/scsi/ufs-core/Makefile
 rename drivers/scsi/{ufs => ufs-core}/ufs-debugfs.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-debugfs.h (100%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-fault-injection.c (100%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-fault-injection.h (100%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-hwmon.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-sysfs.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-sysfs.h (100%)
 rename drivers/scsi/{ufs => ufs-core}/ufs_bsg.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufs_bsg.h (100%)
 rename drivers/scsi/{ufs => ufs-core}/ufshcd-crypto.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufshcd-crypto.h (97%)
 rename drivers/scsi/{ufs => ufs-core}/ufshcd-priv.h (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufshcd.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufshpb.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufshpb.h (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/Kconfig (56%)
 rename drivers/scsi/{ufs => ufs-drivers}/Makefile (56%)
 rename drivers/scsi/{ufs => ufs-drivers}/cdns-pltfrm.c (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210-pci.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210-pltfrm.c (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210.h (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ti-j721e-ufs.c (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-exynos.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-exynos.h (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.h (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek-trace.h (92%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek.h (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom-ice.c (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.h (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-dwc.c (98%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-dwc.h (95%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pci.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.h (98%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshci-dwc.h (100%)
 rename {drivers/scsi/ufs => include/scsi}/ufs.h (100%)
 rename {drivers/scsi/ufs => include/scsi}/ufs_quirks.h (100%)
 rename {drivers/scsi/ufs => include/scsi}/ufshcd.h (99%)
 rename {drivers/scsi/ufs => include/scsi}/ufshci.h (100%)
 rename {drivers/scsi/ufs => include/scsi}/unipro.h (100%)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6e3a04107bb6..40d493dcbcd4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -500,7 +500,8 @@ source "drivers/scsi/megaraid/Kconfig.megaraid"
 source "drivers/scsi/mpt3sas/Kconfig"
 source "drivers/scsi/mpi3mr/Kconfig"
 source "drivers/scsi/smartpqi/Kconfig"
-source "drivers/scsi/ufs/Kconfig"
+source "drivers/scsi/ufs-core/Kconfig"
+source "drivers/scsi/ufs-drivers/Kconfig"
 
 config SCSI_HPTIOP
 	tristate "HighPoint RocketRAID 3xxx/4xxx Controller support"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 19814c26c908..b6319b6598d1 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -101,7 +101,9 @@ obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
 obj-$(CONFIG_SCSI_MPT3SAS)	+= mpt3sas/
 obj-$(CONFIG_SCSI_MPI3MR)	+= mpi3mr/
-obj-$(CONFIG_SCSI_UFSHCD)	+= ufs/
+# The link order is important here. ufshcd-core must initialize
+# before vendor drivers.
+obj-$(CONFIG_SCSI_UFSHCD)	+= ufs-core/ ufs-drivers/
 obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
 obj-$(CONFIG_SCSI_SUNESP)	+= esp_scsi.o	sun_esp.o
 obj-$(CONFIG_SCSI_INITIO)	+= initio.o
diff --git a/drivers/scsi/ufs-core/Kconfig b/drivers/scsi/ufs-core/Kconfig
new file mode 100644
index 000000000000..1226f339f281
--- /dev/null
+++ b/drivers/scsi/ufs-core/Kconfig
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: GPL-2.0+
+#
+# Kernel configuration file for the UFS Host Controller
+#
+# Copyright (C) 2011-2013 Samsung India Software Operations
+#
+# Authors:
+#	Santosh Yaraganavi <santosh.sy@samsung.com>
+#	Vinayak Holikatti <h.vinayak@samsung.com>
+
+config SCSI_UFSHCD
+	tristate "Universal Flash Storage Controller Driver Core"
+	depends on SCSI && SCSI_DMA
+	select PM_DEVFREQ
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	select NLS
+	help
+	  This selects the support for UFS devices in Linux, say Y and make
+	  sure that you know the name of your UFS host adapter (the card
+	  inside your computer that "speaks" the UFS protocol, also
+	  called UFS Host Controller), because you will be asked for it.
+	  The module will be called ufshcd.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/scsi/ufs.rst>.
+	  However, do not compile this as a module if your root file system
+	  (the one containing the directory /) is located on a UFS device.
+
+if SCSI_UFSHCD
+
+config SCSI_UFS_BSG
+	bool "Universal Flash Storage BSG device node"
+	select BLK_DEV_BSGLIB
+	help
+	  Universal Flash Storage (UFS) is SCSI transport specification for
+	  accessing flash storage on digital cameras, mobile phones and
+	  consumer electronic devices.
+	  A UFS controller communicates with a UFS device by exchanging
+	  UFS Protocol Information Units (UPIUs).
+	  UPIUs can not only be used as a transport layer for the SCSI protocol
+	  but are also used by the UFS native command set.
+	  This transport driver supports exchanging UFS protocol information units
+	  with a UFS device. See also the ufshcd driver, which is a SCSI driver
+	  that supports UFS devices.
+
+	  Select this if you need a bsg device node for your UFS controller.
+	  If unsure, say N.
+
+config SCSI_UFS_CRYPTO
+	bool "UFS Crypto Engine Support"
+	depends on BLK_INLINE_ENCRYPTION
+	help
+	  Enable Crypto Engine Support in UFS.
+	  Enabling this makes it possible for the kernel to use the crypto
+	  capabilities of the UFS device (if present) to perform crypto
+	  operations on data being transferred to/from the device.
+
+config SCSI_UFS_HPB
+	bool "Support UFS Host Performance Booster"
+	help
+	  The UFS HPB feature improves random read performance. It caches
+	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
+	  read command by piggybacking physical page number for bypassing FTL (flash
+	  translation layer)'s L2P address translation.
+
+config SCSI_UFS_FAULT_INJECTION
+	bool "UFS Fault Injection Support"
+	depends on FAULT_INJECTION
+	help
+	  Enable fault injection support in the UFS driver. This makes it easier
+	  to test the UFS error handler and abort handler.
+
+config SCSI_UFS_HWMON
+	bool "UFS Temperature Notification"
+	depends on SCSI_UFSHCD=HWMON || HWMON=y
+	help
+	  This provides support for UFS hardware monitoring. If enabled,
+	  a hardware monitoring device will be created for the UFS device.
+
+	  If unsure, say N.
+
+endif
diff --git a/drivers/scsi/ufs-core/Makefile b/drivers/scsi/ufs-core/Makefile
new file mode 100644
index 000000000000..740d22440a07
--- /dev/null
+++ b/drivers/scsi/ufs-core/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
+ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
+ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
+ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
+ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
+ufshcd-core-$(CONFIG_SCSI_UFS_HPB)	+= ufshpb.o
+ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
+ufshcd-core-$(CONFIG_SCSI_UFS_HWMON) += ufs-hwmon.o
diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs-core/ufs-debugfs.c
similarity index 99%
rename from drivers/scsi/ufs/ufs-debugfs.c
rename to drivers/scsi/ufs-core/ufs-debugfs.c
index c10a8f09682b..2f0d30b1bed6 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs-core/ufs-debugfs.c
@@ -2,9 +2,8 @@
 // Copyright (C) 2020 Intel Corporation
 
 #include <linux/debugfs.h>
-
+#include <scsi/ufshcd.h>
 #include "ufs-debugfs.h"
-#include "ufshcd.h"
 #include "ufshcd-priv.h"
 
 static struct dentry *ufs_debugfs_root;
diff --git a/drivers/scsi/ufs/ufs-debugfs.h b/drivers/scsi/ufs-core/ufs-debugfs.h
similarity index 100%
rename from drivers/scsi/ufs/ufs-debugfs.h
rename to drivers/scsi/ufs-core/ufs-debugfs.h
diff --git a/drivers/scsi/ufs/ufs-fault-injection.c b/drivers/scsi/ufs-core/ufs-fault-injection.c
similarity index 100%
rename from drivers/scsi/ufs/ufs-fault-injection.c
rename to drivers/scsi/ufs-core/ufs-fault-injection.c
diff --git a/drivers/scsi/ufs/ufs-fault-injection.h b/drivers/scsi/ufs-core/ufs-fault-injection.h
similarity index 100%
rename from drivers/scsi/ufs/ufs-fault-injection.h
rename to drivers/scsi/ufs-core/ufs-fault-injection.h
diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs-core/ufs-hwmon.c
similarity index 99%
rename from drivers/scsi/ufs/ufs-hwmon.c
rename to drivers/scsi/ufs-core/ufs-hwmon.c
index c38d9d98a86d..fe3e48d3df76 100644
--- a/drivers/scsi/ufs/ufs-hwmon.c
+++ b/drivers/scsi/ufs-core/ufs-hwmon.c
@@ -6,8 +6,7 @@
 
 #include <linux/hwmon.h>
 #include <linux/units.h>
-
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
 #include "ufshcd-priv.h"
 
 struct ufs_hwmon_data {
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs-core/ufs-sysfs.c
similarity index 99%
rename from drivers/scsi/ufs/ufs-sysfs.c
rename to drivers/scsi/ufs-core/ufs-sysfs.c
index 97ab1a75e3b8..4630419f326c 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs-core/ufs-sysfs.c
@@ -5,6 +5,7 @@
 #include <linux/bitfield.h>
 #include <linux/err.h>
 #include <linux/string.h>
+#include <scsi/ufs.h>
 #include "ufs-sysfs.h"
 #include "ufshcd-priv.h"
 
diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs-core/ufs-sysfs.h
similarity index 100%
rename from drivers/scsi/ufs/ufs-sysfs.h
rename to drivers/scsi/ufs-core/ufs-sysfs.h
diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs-core/ufs_bsg.c
similarity index 99%
rename from drivers/scsi/ufs/ufs_bsg.c
rename to drivers/scsi/ufs-core/ufs_bsg.c
index 9e9b93867cab..283dcdf7fceb 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs-core/ufs_bsg.c
@@ -8,8 +8,8 @@
 #include <linux/bsg-lib.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
+#include <scsi/ufshcd.h>
 #include "ufs_bsg.h"
-#include "ufshcd.h"
 #include "ufshcd-priv.h"
 
 static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
diff --git a/drivers/scsi/ufs/ufs_bsg.h b/drivers/scsi/ufs-core/ufs_bsg.h
similarity index 100%
rename from drivers/scsi/ufs/ufs_bsg.h
rename to drivers/scsi/ufs-core/ufs_bsg.h
diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs-core/ufshcd-crypto.c
similarity index 99%
rename from drivers/scsi/ufs/ufshcd-crypto.c
rename to drivers/scsi/ufs-core/ufshcd-crypto.c
index 67402baf6fae..f8f19d8cf4d4 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs-core/ufshcd-crypto.c
@@ -3,7 +3,7 @@
  * Copyright 2019 Google LLC
  */
 
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
 #include "ufshcd-crypto.h"
 
 /* Blk-crypto modes supported by UFS crypto */
diff --git a/drivers/scsi/ufs/ufshcd-crypto.h b/drivers/scsi/ufs-core/ufshcd-crypto.h
similarity index 97%
rename from drivers/scsi/ufs/ufshcd-crypto.h
rename to drivers/scsi/ufs-core/ufshcd-crypto.h
index 9f98f18f9646..0875d53728d1 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.h
+++ b/drivers/scsi/ufs-core/ufshcd-crypto.h
@@ -7,9 +7,9 @@
 #define _UFSHCD_CRYPTO_H
 
 #include <scsi/scsi_cmnd.h>
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
+#include <scsi/ufshci.h>
 #include "ufshcd-priv.h"
-#include "ufshci.h"
 
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 
diff --git a/drivers/scsi/ufs/ufshcd-priv.h b/drivers/scsi/ufs-core/ufshcd-priv.h
similarity index 99%
rename from drivers/scsi/ufs/ufshcd-priv.h
rename to drivers/scsi/ufs-core/ufshcd-priv.h
index de699b969aa6..0e094709ec98 100644
--- a/drivers/scsi/ufs/ufshcd-priv.h
+++ b/drivers/scsi/ufs-core/ufshcd-priv.h
@@ -2,7 +2,7 @@
 #define _UFSHCD_PRIV_H_
 
 #include <linux/pm_runtime.h>
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
 
 static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs-core/ufshcd.c
similarity index 99%
rename from drivers/scsi/ufs/ufshcd.c
rename to drivers/scsi/ufs-core/ufshcd.c
index 27738f24c4a8..870d285d3685 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs-core/ufshcd.c
@@ -26,16 +26,16 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/ufs_quirks.h>
+#include <scsi/ufshcd.h>
+#include <scsi/unipro.h>
 #include "ufs-debugfs.h"
 #include "ufs-fault-injection.h"
 #include "ufs-sysfs.h"
 #include "ufs_bsg.h"
-#include "ufs_quirks.h"
 #include "ufshcd-crypto.h"
 #include "ufshcd-priv.h"
-#include "ufshcd.h"
 #include "ufshpb.h"
-#include "unipro.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ufs.h>
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs-core/ufshpb.c
similarity index 99%
rename from drivers/scsi/ufs/ufshpb.c
rename to drivers/scsi/ufs-core/ufshpb.c
index daac81290f50..7fc0a89e8d8f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs-core/ufshpb.c
@@ -14,10 +14,10 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/ufshcd.h>
 #include "../sd.h"
-#include "ufshcd.h"
-#include "ufshpb.h"
 #include "ufshcd-priv.h"
+#include "ufshpb.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
 #define READ_TO_MS 1000
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs-core/ufshpb.h
similarity index 100%
rename from drivers/scsi/ufs/ufshpb.h
rename to drivers/scsi/ufs-core/ufshpb.h
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs-drivers/Kconfig
similarity index 56%
rename from drivers/scsi/ufs/Kconfig
rename to drivers/scsi/ufs-drivers/Kconfig
index 393b9a01da36..aa53c0e90c8e 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs-drivers/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0+
 #
-# Kernel configuration file for the UFS Host Controller
+# Kernel configuration file for the UFS drivers
 #
 # Copyright (C) 2011-2013 Samsung India Software Operations
 #
@@ -8,24 +8,6 @@
 #	Santosh Yaraganavi <santosh.sy@samsung.com>
 #	Vinayak Holikatti <h.vinayak@samsung.com>
 
-config SCSI_UFSHCD
-	tristate "Universal Flash Storage Controller Driver Core"
-	depends on SCSI && SCSI_DMA
-	select PM_DEVFREQ
-	select DEVFREQ_GOV_SIMPLE_ONDEMAND
-	select NLS
-	help
-	  This selects the support for UFS devices in Linux, say Y and make
-	  sure that you know the name of your UFS host adapter (the card
-	  inside your computer that "speaks" the UFS protocol, also
-	  called UFS Host Controller), because you will be asked for it.
-	  The module will be called ufshcd.
-
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/ufs.rst>.
-	  However, do not compile this as a module if your root file system
-	  (the one containing the directory /) is located on a UFS device.
-
 if SCSI_UFSHCD
 
 config SCSI_UFSHCD_PCI
@@ -122,24 +104,6 @@ config SCSI_UFS_TI_J721E
 	  Selects this if you have TI platform with UFS controller.
 	  If unsure, say N.
 
-config SCSI_UFS_BSG
-	bool "Universal Flash Storage BSG device node"
-	select BLK_DEV_BSGLIB
-	help
-	  Universal Flash Storage (UFS) is SCSI transport specification for
-	  accessing flash storage on digital cameras, mobile phones and
-	  consumer electronic devices.
-	  A UFS controller communicates with a UFS device by exchanging
-	  UFS Protocol Information Units (UPIUs).
-	  UPIUs can not only be used as a transport layer for the SCSI protocol
-	  but are also used by the UFS native command set.
-	  This transport driver supports exchanging UFS protocol information units
-	  with a UFS device. See also the ufshcd driver, which is a SCSI driver
-	  that supports UFS devices.
-
-	  Select this if you need a bsg device node for your UFS controller.
-	  If unsure, say N.
-
 config SCSI_UFS_EXYNOS
 	tristate "Exynos specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
@@ -151,37 +115,4 @@ config SCSI_UFS_EXYNOS
 	  Select this if you have UFS host controller on Samsung Exynos SoC.
 	  If unsure, say N.
 
-config SCSI_UFS_CRYPTO
-	bool "UFS Crypto Engine Support"
-	depends on BLK_INLINE_ENCRYPTION
-	help
-	  Enable Crypto Engine Support in UFS.
-	  Enabling this makes it possible for the kernel to use the crypto
-	  capabilities of the UFS device (if present) to perform crypto
-	  operations on data being transferred to/from the device.
-
-config SCSI_UFS_HPB
-	bool "Support UFS Host Performance Booster"
-	help
-	  The UFS HPB feature improves random read performance. It caches
-	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
-	  read command by piggybacking physical page number for bypassing FTL (flash
-	  translation layer)'s L2P address translation.
-
-config SCSI_UFS_FAULT_INJECTION
-	bool "UFS Fault Injection Support"
-	depends on FAULT_INJECTION
-	help
-	  Enable fault injection support in the UFS driver. This makes it easier
-	  to test the UFS error handler and abort handler.
-
-config SCSI_UFS_HWMON
-	bool "UFS Temperature Notification"
-	depends on SCSI_UFSHCD=HWMON || HWMON=y
-	help
-	  This provides support for UFS hardware monitoring. If enabled,
-	  a hardware monitoring device will be created for the UFS device.
-
-	  If unsure, say N.
-
 endif
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs-drivers/Makefile
similarity index 56%
rename from drivers/scsi/ufs/Makefile
rename to drivers/scsi/ufs-drivers/Makefile
index 966048875b50..e4be54273c98 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs-drivers/Makefile
@@ -1,16 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-# UFSHCD makefile
-
-# The link order is important here. ufshcd-core must initialize
-# before vendor drivers.
-obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
-ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
-ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
-ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
-ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
-ufshcd-core-$(CONFIG_SCSI_UFS_HPB)	+= ufshpb.o
-ufshcd-core-$(CONFIG_SCSI_UFS_FAULT_INJECTION) += ufs-fault-injection.o
-ufshcd-core-$(CONFIG_SCSI_UFS_HWMON) += ufs-hwmon.o
 
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs-drivers/cdns-pltfrm.c
similarity index 100%
rename from drivers/scsi/ufs/cdns-pltfrm.c
rename to drivers/scsi/ufs-drivers/cdns-pltfrm.c
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs-drivers/tc-dwc-g210-pci.c
similarity index 99%
rename from drivers/scsi/ufs/tc-dwc-g210-pci.c
rename to drivers/scsi/ufs-drivers/tc-dwc-g210-pci.c
index d679eff3f2f0..68c40e5b61e4 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs-drivers/tc-dwc-g210-pci.c
@@ -10,9 +10,9 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
+#include <scsi/ufshcd.h>
 #include "tc-dwc-g210.h"
 #include "ufshcd-dwc.h"
-#include "ufshcd.h"
 
 /* Test Chip type expected values */
 #define TC_G210_20BIT 20
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs-drivers/tc-dwc-g210-pltfrm.c
similarity index 100%
rename from drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
rename to drivers/scsi/ufs-drivers/tc-dwc-g210-pltfrm.c
diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs-drivers/tc-dwc-g210.c
similarity index 99%
rename from drivers/scsi/ufs/tc-dwc-g210.c
rename to drivers/scsi/ufs-drivers/tc-dwc-g210.c
index c1b236f09601..14486afc42f1 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs-drivers/tc-dwc-g210.c
@@ -8,11 +8,11 @@
  */
 
 #include <linux/module.h>
+#include <scsi/ufshcd.h>
+#include <scsi/unipro.h>
 #include "tc-dwc-g210.h"
 #include "ufshcd-dwc.h"
-#include "ufshcd.h"
 #include "ufshci-dwc.h"
-#include "unipro.h"
 
 /**
  * tc_dwc_g210_setup_40bit_rmmi()
diff --git a/drivers/scsi/ufs/tc-dwc-g210.h b/drivers/scsi/ufs-drivers/tc-dwc-g210.h
similarity index 100%
rename from drivers/scsi/ufs/tc-dwc-g210.h
rename to drivers/scsi/ufs-drivers/tc-dwc-g210.h
diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs-drivers/ti-j721e-ufs.c
similarity index 100%
rename from drivers/scsi/ufs/ti-j721e-ufs.c
rename to drivers/scsi/ufs-drivers/ti-j721e-ufs.c
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs-drivers/ufs-exynos.c
similarity index 99%
rename from drivers/scsi/ufs/ufs-exynos.c
rename to drivers/scsi/ufs-drivers/ufs-exynos.c
index ddb2d42605c5..64f4ed3639b0 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs-drivers/ufs-exynos.c
@@ -10,20 +10,18 @@
 
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/mfd/syscon.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
-
-#include "ufshcd.h"
-#include "ufshcd-pltfrm.h"
-#include "ufshci.h"
-#include "unipro.h"
-
+#include <scsi/ufshcd.h>
+#include <scsi/ufshci.h>
+#include <scsi/unipro.h>
 #include "ufs-exynos.h"
+#include "ufshcd-pltfrm.h"
 
 /*
  * Exynos's Vendor specific registers for UFSHCI
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs-drivers/ufs-exynos.h
similarity index 100%
rename from drivers/scsi/ufs/ufs-exynos.h
rename to drivers/scsi/ufs-drivers/ufs-exynos.h
diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs-drivers/ufs-hisi.c
similarity index 99%
rename from drivers/scsi/ufs/ufs-hisi.c
rename to drivers/scsi/ufs-drivers/ufs-hisi.c
index 8f6168471464..09ac3280a73e 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs-drivers/ufs-hisi.c
@@ -14,12 +14,12 @@
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/time.h>
+#include <scsi/ufs_quirks.h>
+#include <scsi/ufshcd.h>
+#include <scsi/ufshci.h>
+#include <scsi/unipro.h>
 #include "ufs-hisi.h"
-#include "ufs_quirks.h"
 #include "ufshcd-pltfrm.h"
-#include "ufshcd.h"
-#include "ufshci.h"
-#include "unipro.h"
 
 static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufs-hisi.h b/drivers/scsi/ufs-drivers/ufs-hisi.h
similarity index 100%
rename from drivers/scsi/ufs/ufs-hisi.h
rename to drivers/scsi/ufs-drivers/ufs-hisi.h
diff --git a/drivers/scsi/ufs/ufs-mediatek-trace.h b/drivers/scsi/ufs-drivers/ufs-mediatek-trace.h
similarity index 92%
rename from drivers/scsi/ufs/ufs-mediatek-trace.h
rename to drivers/scsi/ufs-drivers/ufs-mediatek-trace.h
index 895e82ea6ece..d33ffce9d01f 100644
--- a/drivers/scsi/ufs/ufs-mediatek-trace.h
+++ b/drivers/scsi/ufs-drivers/ufs-mediatek-trace.h
@@ -31,6 +31,6 @@ TRACE_EVENT(ufs_mtk_event,
 
 #undef TRACE_INCLUDE_PATH
 #undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_PATH ../../drivers/scsi/ufs/
+#define TRACE_INCLUDE_PATH ../../drivers/scsi/ufs-drivers
 #define TRACE_INCLUDE_FILE ufs-mediatek-trace
 #include <trace/define_trace.h>
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs-drivers/ufs-mediatek.c
similarity index 99%
rename from drivers/scsi/ufs/ufs-mediatek.c
rename to drivers/scsi/ufs-drivers/ufs-mediatek.c
index b804e969915b..3207a19b900a 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs-drivers/ufs-mediatek.c
@@ -20,11 +20,11 @@
 #include <linux/reset.h>
 #include <linux/sched/clock.h>
 #include <linux/soc/mediatek/mtk_sip_svc.h>
-#include "ufshcd.h"
-#include "ufshcd-pltfrm.h"
-#include "ufs_quirks.h"
-#include "unipro.h"
+#include <scsi/ufs_quirks.h>
+#include <scsi/ufshcd.h>
+#include <scsi/unipro.h>
 #include "ufs-mediatek.h"
+#include "ufshcd-pltfrm.h"
 
 #define CREATE_TRACE_POINTS
 #include "ufs-mediatek-trace.h"
diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs-drivers/ufs-mediatek.h
similarity index 100%
rename from drivers/scsi/ufs/ufs-mediatek.h
rename to drivers/scsi/ufs-drivers/ufs-mediatek.h
diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs-drivers/ufs-qcom-ice.c
similarity index 100%
rename from drivers/scsi/ufs/ufs-qcom-ice.c
rename to drivers/scsi/ufs-drivers/ufs-qcom-ice.c
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs-drivers/ufs-qcom.c
similarity index 99%
rename from drivers/scsi/ufs/ufs-qcom.c
rename to drivers/scsi/ufs-drivers/ufs-qcom.c
index 9a390cd516bd..dbfaa7ead11a 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs-drivers/ufs-qcom.c
@@ -14,12 +14,12 @@
 #include <linux/platform_device.h>
 #include <linux/reset-controller.h>
 #include <linux/time.h>
+#include <scsi/ufs_quirks.h>
+#include <scsi/ufshcd.h>
+#include <scsi/ufshci.h>
+#include <scsi/unipro.h>
 #include "ufs-qcom.h"
-#include "ufs_quirks.h"
 #include "ufshcd-pltfrm.h"
-#include "ufshcd.h"
-#include "ufshci.h"
-#include "unipro.h"
 
 #define UFS_QCOM_DEFAULT_DBG_PRINT_EN					\
 	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs-drivers/ufs-qcom.h
similarity index 99%
rename from drivers/scsi/ufs/ufs-qcom.h
rename to drivers/scsi/ufs-drivers/ufs-qcom.h
index 771bc95d02c7..ad70d425c544 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs-drivers/ufs-qcom.h
@@ -7,7 +7,7 @@
 
 #include <linux/reset-controller.h>
 #include <linux/reset.h>
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
 
 #define MAX_UFS_QCOM_HOSTS	1
 #define MAX_U32                 (~(u32)0)
diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/scsi/ufs-drivers/ufshcd-dwc.c
similarity index 98%
rename from drivers/scsi/ufs/ufshcd-dwc.c
rename to drivers/scsi/ufs-drivers/ufshcd-dwc.c
index 8f1786be3556..a4066373d994 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.c
+++ b/drivers/scsi/ufs-drivers/ufshcd-dwc.c
@@ -8,10 +8,10 @@
  */
 
 #include <linux/module.h>
+#include <scsi/ufshcd.h>
+#include <scsi/unipro.h>
 #include "ufshcd-dwc.h"
-#include "ufshcd.h"
 #include "ufshci-dwc.h"
-#include "unipro.h"
 
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n)
diff --git a/drivers/scsi/ufs/ufshcd-dwc.h b/drivers/scsi/ufs-drivers/ufshcd-dwc.h
similarity index 95%
rename from drivers/scsi/ufs/ufshcd-dwc.h
rename to drivers/scsi/ufs-drivers/ufshcd-dwc.h
index 43b70794e24f..3195002f6692 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.h
+++ b/drivers/scsi/ufs-drivers/ufshcd-dwc.h
@@ -10,7 +10,7 @@
 #ifndef _UFSHCD_DWC_H
 #define _UFSHCD_DWC_H
 
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
 
 struct ufshcd_dme_attr_val {
 	u32 attr_sel;
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs-drivers/ufshcd-pci.c
similarity index 99%
rename from drivers/scsi/ufs/ufshcd-pci.c
rename to drivers/scsi/ufs-drivers/ufshcd-pci.c
index 45df431c720c..c82972fd4ece 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs-drivers/ufshcd-pci.c
@@ -18,7 +18,7 @@
 #include <linux/pm_qos.h>
 #include <linux/pm_runtime.h>
 #include <linux/uuid.h>
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
 
 struct ufs_host {
 	void (*late_init)(struct ufs_hba *hba);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs-drivers/ufshcd-pltfrm.c
similarity index 99%
rename from drivers/scsi/ufs/ufshcd-pltfrm.c
rename to drivers/scsi/ufs-drivers/ufshcd-pltfrm.c
index a1ff5bfd4f71..a6191e21dbbd 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs-drivers/ufshcd-pltfrm.c
@@ -12,9 +12,9 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
+#include <scsi/unipro.h>
 #include "ufshcd-pltfrm.h"
-#include "unipro.h"
 
 #define UFSHCD_DEFAULT_LANES_PER_DIRECTION		2
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.h b/drivers/scsi/ufs-drivers/ufshcd-pltfrm.h
similarity index 98%
rename from drivers/scsi/ufs/ufshcd-pltfrm.h
rename to drivers/scsi/ufs-drivers/ufshcd-pltfrm.h
index c33e28ac6ef6..63cb306ed0ac 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.h
+++ b/drivers/scsi/ufs-drivers/ufshcd-pltfrm.h
@@ -5,7 +5,7 @@
 #ifndef UFSHCD_PLTFRM_H_
 #define UFSHCD_PLTFRM_H_
 
-#include "ufshcd.h"
+#include <scsi/ufshcd.h>
 
 #define UFS_PWM_MODE 1
 #define UFS_HS_MODE  2
diff --git a/drivers/scsi/ufs/ufshci-dwc.h b/drivers/scsi/ufs-drivers/ufshci-dwc.h
similarity index 100%
rename from drivers/scsi/ufs/ufshci-dwc.h
rename to drivers/scsi/ufs-drivers/ufshci-dwc.h
diff --git a/drivers/scsi/ufs/ufs.h b/include/scsi/ufs.h
similarity index 100%
rename from drivers/scsi/ufs/ufs.h
rename to include/scsi/ufs.h
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/include/scsi/ufs_quirks.h
similarity index 100%
rename from drivers/scsi/ufs/ufs_quirks.h
rename to include/scsi/ufs_quirks.h
diff --git a/drivers/scsi/ufs/ufshcd.h b/include/scsi/ufshcd.h
similarity index 99%
rename from drivers/scsi/ufs/ufshcd.h
rename to include/scsi/ufshcd.h
index b13469fb1e15..946d915f5a42 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/include/scsi/ufshcd.h
@@ -18,10 +18,10 @@
 #include <linux/devfreq.h>
 #include <linux/pm_runtime.h>
 #include <scsi/scsi_device.h>
-#include "unipro.h"
-#include "ufs.h"
-#include "ufs_quirks.h"
-#include "ufshci.h"
+#include <scsi/ufs.h>
+#include <scsi/ufs_quirks.h>
+#include <scsi/ufshci.h>
+#include <scsi/unipro.h>
 
 #define UFSHCD "ufshcd"
 
diff --git a/drivers/scsi/ufs/ufshci.h b/include/scsi/ufshci.h
similarity index 100%
rename from drivers/scsi/ufs/ufshci.h
rename to include/scsi/ufshci.h
diff --git a/drivers/scsi/ufs/unipro.h b/include/scsi/unipro.h
similarity index 100%
rename from drivers/scsi/ufs/unipro.h
rename to include/scsi/unipro.h
