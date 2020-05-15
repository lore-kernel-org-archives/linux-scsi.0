Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC26C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 627A020759
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QIwLN4Hv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgEOKbW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:31:22 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:40588 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgEOKbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538681; x=1621074681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E/L/gJCrCw5I2I+FfznK0OJjRKMbf7TBG4YTFEXKFAA=;
  b=QIwLN4HvHC7Q0rd9Vbh5uQgSytm6uzU8UK36Wu0Nwo3xdOLa6RDJhY4u
   1Y6D+XdpnWnDxcdB4N2utevG0JmtOTZ1I426cB495C5zYc5LSOngrsRyV
   NIvIAPZGS+JFyz55ppXXEVI5PTGOBCFVpHRFXpRhrZiz1oVqCWs2wO9oj
   ZwxnP8quzSs4Se/3srYKXnphTyfFU9AYMqUAUJlt08Q0yJmDcxkas1/eN
   XqUglv7/83balN+bSsL72DDFcmUSsT8EDZsryf3N5e07HCRZHQh0nfl+F
   gWTNE22sgF5xB4mLfPXzf47CjPMFjwLUEHEMBuiIXTgQ70N5QG99XTgc9
   Q==;
IronPort-SDR: SzZHeHvi0KRkUhGNnt2e8bWIFuYOrOBWe0gasUve3XX2w/+RbdfwysL9agzJJO/H0wTtgr/DNP
 6rxTZKmoPF9ODOZo5dyRoIefgVhsYjwL95TOAMm6xyjgLZWrm7usW++DHSP4enN6qJnbv5wSHM
 ZCUEf2X9afzBdnxlerLa6lFojXN6xZoEkbljKmtLWtOZ0PpTaOXLWmQVT8mN0CIwFyYnm0a/Rc
 KLIkw2yHnWQkJAZEb/KW5hI64J0fLLgyGFhy0Fe49RKGZQXbMcCxl1GJjRt7DPV+8iu4xyjCwp
 B7Q=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="246735741"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:31:21 +0800
IronPort-SDR: q1US7twFjlbuMfmjYPdzb1VVMi/iKEwbC9NxzZDGdeIuxMcNghBQMFXuzUsqoKR45ZxCjiMuWN
 TJLaQTe+IywVsXfK+IkIEPUlvm2JSDATo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:20:59 -0700
IronPort-SDR: a+FGku3Obmvi3vnIRrkWz2K3KWdhxy6Sb3JhTEV6ElgTCee/xm23JSR6EXkMKTg9CEMWEg6yhV
 Vcq3rzrjHu6w==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:31:17 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 03/13] scsi: scsi_dh: Introduce scsi_dh_ufshpb
Date:   Fri, 15 May 2020 13:30:04 +0300
Message-Id: <1589538614-24048-4-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a scsi device handler companion to support ufs hpb.

The scsi-device-handler infrastructure was added to the kernel mainly to
facilitate multiple paths for storage devices.  The HPB framework,
although far from the original intention of the authors, might as well
fit in.  In that sense, using READs and HPB_READs intermittently, can be
perceived as a multi-path.

Device handlers are meant to be called as part of the device mapper
multi-path code.  We can’t do that – we need to attach & activate the
device handler manually, only after the ufs driver verified that HPB is
supported by both the platform and the device.

At this point just add the bare minimum to allow the ufs driver to
complete its second phase of initialization: attaching and activating
the device handler.  This module however, will store the L2P cache,
perform the cache-management functionality, and will setup the HPB_READ
command instead of READ. So it is about to grow extensively.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/device_handler/Makefile         |  1 +
 drivers/scsi/device_handler/scsi_dh_ufshpb.c | 73 ++++++++++++++++++++++++++++
 drivers/scsi/ufs/Kconfig                     |  1 +
 drivers/scsi/ufs/ufshpb.c                    | 39 +--------------
 include/scsi/scsi_dh_ufshpb.h                | 50 +++++++++++++++++++
 5 files changed, 126 insertions(+), 38 deletions(-)
 create mode 100644 drivers/scsi/device_handler/scsi_dh_ufshpb.c
 create mode 100644 include/scsi/scsi_dh_ufshpb.h

diff --git a/drivers/scsi/device_handler/Makefile b/drivers/scsi/device_handler/Makefile
index 0a603ae..6587622 100644
--- a/drivers/scsi/device_handler/Makefile
+++ b/drivers/scsi/device_handler/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_SCSI_DH_RDAC)	+= scsi_dh_rdac.o
 obj-$(CONFIG_SCSI_DH_HP_SW)	+= scsi_dh_hp_sw.o
 obj-$(CONFIG_SCSI_DH_EMC)	+= scsi_dh_emc.o
 obj-$(CONFIG_SCSI_DH_ALUA)	+= scsi_dh_alua.o
+obj-$(CONFIG_SCSI_UFS_HPB)	+= scsi_dh_ufshpb.o
diff --git a/drivers/scsi/device_handler/scsi_dh_ufshpb.c b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
new file mode 100644
index 0000000..f26208c
--- /dev/null
+++ b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Host Performance Booster(HPB) for UFS devices
+ *
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ * Copyright (C) 2018, Google, Inc.
+ * Copyright (C) 2020 Western Digital Corporation or its affiliates.
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_dh.h>
+#include <scsi/scsi_dh_ufshpb.h>
+
+#define UFSHPB_NAME	"ufshpb"
+
+struct ufshpb_dh_data {
+	const struct ufshpb_config *ufshpb_conf;
+	const struct ufshpb_lun_config *ufshpb_lun_conf;
+};
+
+static int ufshpb_attach(struct scsi_device *sdev)
+{
+	struct ufshpb_dh_data *h;
+
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return SCSI_DH_NOMEM;
+
+	sdev_printk(KERN_INFO, sdev, "%s: attached to sdev (lun) %llu\n",
+		    UFSHPB_NAME, sdev->lun);
+
+	sdev->handler_data = h;
+
+	return SCSI_DH_OK;
+}
+
+/*
+ * scsi_dh_detach will be called from the ufs driver upon failuire and on
+ * remove.
+ */
+static void ufshpb_detach(struct scsi_device *sdev)
+{
+	kfree(sdev->handler_data);
+	sdev->handler_data = NULL;
+}
+
+static struct scsi_device_handler ufshpb_dh = {
+	.name		= UFSHPB_NAME,
+	.module		= THIS_MODULE,
+	.attach		= ufshpb_attach,
+	.detach		= ufshpb_detach,
+};
+
+static int __init ufshpb_init(void)
+{
+	return scsi_register_device_handler(&ufshpb_dh);
+}
+
+static void __exit ufshpb_exit(void)
+{
+	scsi_unregister_device_handler(&ufshpb_dh);
+}
+
+module_init(ufshpb_init);
+module_exit(ufshpb_exit);
+
+MODULE_DESCRIPTION("ufshpb scsi device handler driver");
+MODULE_AUTHOR("Avri Altman <avri.altman@wdc.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index a540919..0868d53 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -164,6 +164,7 @@ config SCSI_UFS_BSG
 config SCSI_UFS_HPB
 	bool "Support UFS Host Performance Booster (HPB)"
         depends on SCSI_UFSHCD
+	select SCSI_DH
         help
 	  A UFS feature targeted to improve random read performance.  It uses
 	  the host’s system memory as a cache for L2P map data, so that both
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 181917f..e94e699 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -7,6 +7,7 @@
  */
 
 #include <asm/unaligned.h>
+#include <scsi/scsi_dh_ufshpb.h>
 #include "ufshcd.h"
 #include "ufs.h"
 #include "ufshpb.h"
@@ -22,44 +23,6 @@ enum ufshpb_control_modes {
 	UFSHPB_DEVICE_CONTROL
 };
 
-/**
- * struct ufshpb_lun_conf - to hold hpb lun config from unit descriptor
- * @lun - lun id
- * @size - lun size = 2^bLogicalBlockSize x qLogicalBlockCount
- * @max_active_regions - Maximum Number of Active HPB Regions for that LU
- * @pinned_starting_idx - HPB Pinned Region Start Offset
- * @pinned_count - Number of HPB Pinned Regions
- */
-struct ufshpb_lun_config {
-	u8 lun;
-	u64 size;
-	u8 hpb_lun_idx;
-	u16 max_active_regions;
-	u16 pinned_starting_idx;
-	u16 pinned_count;
-};
-
-/**
- * struct ufshpb_config - to hold hpb config supported by the device
- * @version - HPB Specification Version
- * @mode - hpb control mode
- * @region_size - HPB Region size[B] = 512B x 2^bHPBRegionSize
- * @max_luns - Maximum number of HPB LU supported by the device <= 0x20
- * @subregion_size - HPB Sub-Region size[B] = 512B x 2^bHPBSubRegionSize
- * @max_active_regions - Maximum number of Active HPB Regions
- * @num_hpb_luns - hpb luns that are configured in the device
- * @hpb_luns - to hold hpb lun config from unit descriptor
- */
-struct ufshpb_config {
-	u16 version;
-	u8 mode;
-	u8 region_size;
-	u8 max_luns;
-	u8 subregion_size;
-	u16 max_active_regions;
-	u8 num_hpb_luns;
-};
-
 struct ufshpb_lun {
 	u8 lun;
 };
diff --git a/include/scsi/scsi_dh_ufshpb.h b/include/scsi/scsi_dh_ufshpb.h
new file mode 100644
index 0000000..3dcb442
--- /dev/null
+++ b/include/scsi/scsi_dh_ufshpb.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Header file for UFS HPB device handler
+ *
+ * Copyright (C) 2020 Western Digital Corporation or its affiliates.
+ */
+#ifndef _SCSI_DH_UFSHPB_H
+#define _SCSI_DH_UFSHPB_H
+
+#include <scsi/scsi_device.h>
+
+/**
+ * struct ufshpb_lun_conf - to hold hpb lun config from unit descriptor
+ * @lun - lun id
+ * @size - lun size = 2^bLogicalBlockSize x qLogicalBlockCount
+ * @max_active_regions - Maximum Number of Active HPB Regions for that LU
+ * @pinned_starting_idx - HPB Pinned Region Start Offset
+ * @pinned_count - Number of HPB Pinned Regions
+ */
+struct ufshpb_lun_config {
+	u8 lun;
+	u64 size;
+	u8 hpb_lun_idx;
+	u16 max_active_regions;
+	u16 pinned_starting_idx;
+	u16 pinned_count;
+};
+
+/**
+ * struct ufshpb_config - to hold hpb config supported by the device
+ * @version - HPB Specification Version
+ * @mode - hpb control mode
+ * @region_size - HPB Region size[B] = 512B x 2^bHPBRegionSize
+ * @max_luns - Maximum number of HPB LU supported by the device <= 0x20
+ * @subregion_size - HPB Sub-Region size[B] = 512B x 2^bHPBSubRegionSize
+ * @max_active_regions - Maximum number of Active HPB Regions
+ * @num_hpb_luns - hpb luns that are configured in the device
+ * @hpb_luns - to hold hpb lun config from unit descriptor
+ */
+struct ufshpb_config {
+	u16 version;
+	u8 mode;
+	u8 region_size;
+	u8 max_luns;
+	u8 subregion_size;
+	u16 max_active_regions;
+	u8 num_hpb_luns;
+};
+#endif /* _SCSI_DH_UFSHPB_H */
+
-- 
2.7.4

