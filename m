Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77485C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4869020759
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oElNEjmI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgEOKbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:31:09 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1804 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgEOKbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538668; x=1621074668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f1c1c5JUcG5O93fD/l2mbYYehlAdtSDeOjx4W/YEC0Y=;
  b=oElNEjmISmQlDWQ2wTbVqizzDa4t62D1IQB2P8wWFqMgEuYXhEk+B52g
   N7kVaEr06e/wDzB6SKQeKp7kZwOA67kERPTYMT2YseL0gdKhYNUudfIlZ
   oNPntslc9VKHWEPR6uXk2gk24IOokbr4QdbbZyOV0kBnaOGIqBmXjiv02
   ujjFudOG+c4GIzH/gNwse+oS77g+nfaYarOkbAbOdvbAwmoH8TIZTK/oT
   33qijpVILDZpqb8V1Bt2L2wrjzofrub7XDqNK25UtR2ehPk190eRcFb36
   urnAOfadLWplUqTedZpoC9bXoucgNBGsQ8R4MyIzYEUvTEwWvt8iRWkmF
   w==;
IronPort-SDR: fh0RXXIPbMhwPqndV1AQYtQWK+piFqIlyaELGJ5EJnd+2MMWVMfJzYobDH43IS5yX0VV/rqaQt
 oHl045AXASODN/rKLNRbiB6rBPzJXXtyqt/Tza1/BPVoYHTBwBISVcSnItPJnv0qsvOJhx+mvv
 aOldNbc4SgpJOsSVfQXoubjcjptJn4LiuYXY1LBlEB7YFOi4sY9tT4N7HelGUKB+3AZSVYfznn
 fiOLwecUmCze1Fle4CpcMNksRfKHLZQ4pkOvUW6cztgLIkgGl0Mvbf09AW1PTp5qBQ8MYD1JCc
 pO0=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="142113554"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:31:08 +0800
IronPort-SDR: dfG0dJREGfJTi75iFROIAtxogJ4tEiFsgq4Q9QF2kri5f70uShfONWduB45PBlxJFL7Bu+FASP
 iA9Tven+xZzlIzQPLvZv66lxIGXlAfvh8=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:20:45 -0700
IronPort-SDR: hzC2PWDZY+SBTwzRVetqJFBcnCnUsU4vtw7MqpEDUIk6SXqqxRhrBIzuwUpxm0L25CmW3shDu9
 fCdEyyP+gGWg==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:31:03 -0700
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
Subject: [RFC PATCH 02/13] scsi: ufshpb: Init part I - Read HPB config
Date:   Fri, 15 May 2020 13:30:03 +0300
Message-Id: <1589538614-24048-3-git-send-email-avri.altman@wdc.com>
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

The ufshpb module bear 2 main duties.  During initialization, it reads
the hpb configuration from the device.  Later on, during the scan host
phase, it attaches the scsi device and activates the scsi hpb device
handler.

The second duty mainly concern the HPB cache management and will be
dealt with in future patches.

This patch introduce an API to carry the first part of the
initialization: reading the HPB configuration.

At this point we introduce the key data structure of the ufshpb module -
ufshpb_lun.  It will bear some more duties in the future, so we will
elaborate it as we go.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/Kconfig  |  12 ++
 drivers/scsi/ufs/Makefile |   1 +
 drivers/scsi/ufs/ufshcd.c |   5 +
 drivers/scsi/ufs/ufshcd.h |  10 ++
 drivers/scsi/ufs/ufshpb.c | 318 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  22 ++++
 6 files changed, 368 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e2005ae..a540919 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -160,3 +160,15 @@ config SCSI_UFS_BSG
 
 	  Select this if you need a bsg device node for your UFS controller.
 	  If unsure, say N.
+
+config SCSI_UFS_HPB
+	bool "Support UFS Host Performance Booster (HPB)"
+        depends on SCSI_UFSHCD
+        help
+	  A UFS feature targeted to improve random read performance.  It uses
+	  the host’s system memory as a cache for L2P map data, so that both
+	  physical block address (PBA) and logical block address (LBA) can be
+	  delivered in HPB read command.
+
+          Select this to enable this feature.
+          If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 94c6c5d..c38788a 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
 obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
 obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
+obj-$(CONFIG_SCSI_UFS_HPB) += ufshpb.o
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 426073a..bffe699 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -50,6 +50,7 @@
 #include "ufs_bsg.h"
 #include <asm/unaligned.h>
 #include <linux/blkdev.h>
+#include "ufshpb.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ufs.h>
@@ -7341,6 +7342,9 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 		hba->clk_scaling.is_allowed = true;
 	}
 
+	if (ufshcd_is_hpb_supported(hba))
+		ufshpb_probe(hba);
+
 	ufs_bsg_probe(hba);
 	scsi_scan_host(hba->host);
 	pm_runtime_put_sync(hba->dev);
@@ -8608,6 +8612,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
+	ufshpb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_cleanup_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 23a434c..e7014a3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -564,6 +564,11 @@ enum ufshcd_caps {
 	 * provisioned to be used. This would increase the write performance.
 	 */
 	UFSHCD_CAP_WB_EN				= 1 << 7,
+
+	/*
+	 * This capability indicates that the platform supports HPB
+	 */
+	UFSHCD_CAP_HPB 					= 1 << 8,
 };
 
 /**
@@ -791,6 +796,11 @@ static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_WB_EN;
 }
 
+static inline bool ufshcd_is_hpb_supported(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_HPB;
+}
+
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
new file mode 100644
index 0000000..181917f
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Host Performance Booster(HPB)
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ * Copyright (C) 2018, Google, Inc.
+ * Copyright (C) 2020 Western Digital Corporation or its affiliates.
+ */
+
+#include <asm/unaligned.h>
+#include "ufshcd.h"
+#include "ufs.h"
+#include "ufshpb.h"
+
+#define UFSHPB_SPEC_VER (0x310)
+#define UFSHPB_MAX_LUNS (0x20)
+#define DEV_DESC_HPB_SIZE (0x53)
+#define GEO_DESC_HPB_SIZE (0x4D)
+#define UNIT_DESC_HPB_SIZE (0x29)
+
+enum ufshpb_control_modes {
+	UFSHPB_HOST_CONTROL,
+	UFSHPB_DEVICE_CONTROL
+};
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
+
+struct ufshpb_lun {
+	u8 lun;
+};
+
+
+struct ufshpb_config *ufshpb_conf;
+struct ufshpb_lun_config *ufshpb_luns_conf;
+struct ufshpb_lun *ufshpb_luns;
+static unsigned long ufshpb_lun_map[BITS_TO_LONGS(UFSHPB_MAX_LUNS)];
+static u8 ufshpb_lun_lookup[UFSHPB_MAX_LUNS];
+
+/**
+ * ufshpb_remove - ufshpb cleanup
+ *
+ * Should be called when unloading the driver.
+ */
+void ufshpb_remove(struct ufs_hba *hba)
+{
+	kfree(ufshpb_conf);
+	kfree(ufshpb_luns_conf);
+	kfree(ufshpb_luns);
+	ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+			  QUERY_FLAG_IDN_HPB_RESET, 0, NULL);
+}
+
+static int ufshpb_hpb_init(void)
+{
+	u8 num_hpb_luns = ufshpb_conf->num_hpb_luns;
+	int i;
+
+	ufshpb_luns = kcalloc(num_hpb_luns, sizeof(*ufshpb_luns), GFP_KERNEL);
+	if (!ufshpb_luns)
+		return -ENOMEM;
+
+	for (i = 0; i < num_hpb_luns; i++) {
+		struct ufshpb_lun *hpb = ufshpb_luns + i;
+
+		hpb->lun = (ufshpb_luns_conf + i)->lun;
+	}
+
+	return 0;
+}
+
+static inline bool ufshpb_desc_proper_sizes(struct ufs_hba *hba)
+{
+	return hba->desc_size.dev_desc >= DEV_DESC_HPB_SIZE &&
+		hba->desc_size.geom_desc >= GEO_DESC_HPB_SIZE &&
+		hba->desc_size.unit_desc >= UNIT_DESC_HPB_SIZE;
+}
+
+static int ufshpb_get_geo_config(struct ufs_hba *hba)
+{
+	int ret;
+	u8 *desc_buf;
+
+	desc_buf = kzalloc(GEO_DESC_HPB_SIZE, GFP_KERNEL);
+	if (!desc_buf)
+		return -ENOMEM;
+
+	ret = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_GEOMETRY, 0, 0,
+				     desc_buf, GEO_DESC_HPB_SIZE);
+	if (ret)
+		goto free;
+
+	ufshpb_conf->region_size =
+			desc_buf[GEOMETRY_DESC_PARAM_HPB_REGION_SIZE];
+	ufshpb_conf->subregion_size =
+			desc_buf[GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE];
+	ufshpb_conf->max_luns = desc_buf[GEOMETRY_DESC_PARAM_MAX_HPB_LUNS];
+
+	/* None of HPB geometrical parameters should be 0 */
+	if (!ufshpb_conf->max_luns || !ufshpb_conf->region_size ||
+	    !ufshpb_conf->subregion_size) {
+		ret = -EINVAL;
+		goto free;
+	}
+
+	ret = 0;
+
+free:
+	kfree(desc_buf);
+	return ret;
+}
+
+static int ufshpb_get_unit_config(struct ufs_hba *hba, u8 dev_num_luns)
+{
+	int ret;
+	struct ufshpb_lun_config *luns_conf;
+	u8 *desc_buf;
+	u8 num_hpb_luns = 0;
+	u16 max_active_regions = 0;
+	int i;
+
+	luns_conf = kcalloc(ufshpb_conf->max_luns, sizeof(*luns_conf),
+			    GFP_KERNEL);
+	if (!luns_conf)
+		return -ENOMEM;
+
+	desc_buf = kzalloc(UNIT_DESC_HPB_SIZE, GFP_KERNEL);
+	if (!desc_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* iterate over all unit descriptors, look for hpb luns */
+	for (i = 0; i < dev_num_luns; i++) {
+		struct ufshpb_lun_config *lun_conf;
+		u64 block_count;
+		u8 block_size;
+
+		memset(desc_buf, 0x0, UNIT_DESC_HPB_SIZE);
+
+		ret = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, i, 0,
+					     desc_buf, UNIT_DESC_HPB_SIZE);
+		if (ret)
+			goto out;
+
+		if (desc_buf[UNIT_DESC_PARAM_LU_ENABLE] != UFS_LUN_HPB)
+			continue;
+
+		lun_conf = luns_conf + num_hpb_luns;
+
+		/* mark the hpb lun for future lookup */
+		ufshpb_lun_lookup[i] = num_hpb_luns;
+		lun_conf->lun = i;
+		lun_conf->hpb_lun_idx = num_hpb_luns;
+		set_bit(i, ufshpb_lun_map);
+		num_hpb_luns++;
+
+		block_count = get_unaligned_be64(
+			&desc_buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT]);
+		block_size = desc_buf[UNIT_DESC_PARAM_LOGICAL_BLK_SIZE];
+		lun_conf->size = BIT(block_size) * block_count;
+
+		/* get ufshpb params */
+		lun_conf->max_active_regions = get_unaligned_be16(
+			&desc_buf[UNIT_DESC_PARAM_MAX_ACTIVE_HPBREGIONS]);
+
+		/*
+		 * wDeviceMaxActiveHPBRegions is redundant. Suffices to keep
+		 * track of sum of wLUMaxActiveHPBRegions over the luns.
+		 */
+		max_active_regions += lun_conf->max_active_regions;
+
+		lun_conf->pinned_count = get_unaligned_be16(
+			&desc_buf[UNIT_DESC_PARAM_HPB_PINNED_COUNT]);
+		if (lun_conf->pinned_count)
+			lun_conf->pinned_starting_idx = get_unaligned_be16(
+				&desc_buf[UNIT_DESC_PARAM_HPB_PINNED_OFFSET]);
+
+		/* there can be up to bHPBNumberLU HPB luns */
+		if (num_hpb_luns == ufshpb_conf->max_luns)
+			break;
+	}
+
+	if (!num_hpb_luns || !max_active_regions) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ufshpb_conf->num_hpb_luns = num_hpb_luns;
+	ufshpb_conf->max_active_regions = max_active_regions;
+	ufshpb_luns_conf = luns_conf;
+
+	ret = 0;
+
+out:
+	kfree(desc_buf);
+	if (ret)
+		kfree(luns_conf);
+	return ret;
+}
+
+/**
+ * ufshpb_probe - read hpb config from the device
+ * @hba: per adapter object
+ *
+ * Called during initial loading of the driver, and before scsi_scan_host.
+ */
+int ufshpb_probe(struct ufs_hba *hba)
+{
+	int ret = -EINVAL;
+	u16 spec_ver = 0;
+	u8 dev_num_luns = 0;
+	u8 *dev_desc = NULL;
+
+	/*
+	 * if the HPB database already exist, that's fine, leave it.
+	 * The device will signal should it needs to be reset.
+	 */
+	if (ufshpb_luns)
+		return 0;
+
+	if (!ufshpb_desc_proper_sizes(hba))
+		goto out;
+
+	dev_desc = kzalloc(DEV_DESC_HPB_SIZE, GFP_KERNEL);
+	if (!dev_desc) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, dev_desc,
+				   DEV_DESC_HPB_SIZE))
+		goto out;
+
+	spec_ver = get_unaligned_be16(&dev_desc[DEVICE_DESC_PARAM_SPEC_VER]);
+	if (spec_ver < UFSHPB_SPEC_VER)
+		goto out;
+
+	if (!(dev_desc[DEVICE_DESC_PARAM_UFS_FEAT] & UFS_FEATURE_HPB))
+		goto out;
+
+	ufshpb_conf = kzalloc(sizeof(*ufshpb_conf), GFP_KERNEL);
+	if (!ufshpb_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ufshpb_conf->version =
+		get_unaligned_be16(&dev_desc[DEVICE_DESC_PARAM_HPBVER]);
+	ufshpb_conf->mode = dev_desc[DEVICE_DESC_PARAM_HPBCONTROL];
+
+	/* this driver supports only host control mode */
+	if (ufshpb_conf->mode != UFSHPB_HOST_CONTROL)
+		goto out;
+
+	/* bNumberLU does not include wluns which can't be hpb luns */
+	dev_num_luns = dev_desc[DEVICE_DESC_PARAM_NUM_LU];
+
+	ret = ufshpb_get_geo_config(hba);
+	if (ret)
+		goto out;
+
+	ret = ufshpb_get_unit_config(hba, dev_num_luns);
+	if (ret)
+		goto out;
+
+	ret = ufshpb_hpb_init();
+	if (ret)
+		goto out;
+
+out:
+	kfree(dev_desc);
+	if (ret) {
+		dev_err(hba->dev, "err %d while probing HPB\n", ret);
+		hba->caps &= ~UFSHCD_CAP_HPB;
+		ufshpb_remove(hba);
+	}
+
+	return ret;
+}
+
+MODULE_AUTHOR("Avri Altman <avri.altman@wdc.com>");
+MODULE_DESCRIPTION("UFS Host Performance Booster Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
new file mode 100644
index 0000000..ee990f4
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ * Copyright (C) 2018, Google, Inc.
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ */
+#ifndef _UFSHPB_H
+#define _UFSHPB_H
+
+#include <linux/types.h>
+
+struct ufs_hba;
+
+#ifdef CONFIG_SCSI_UFS_HPB
+void ufshpb_remove(struct ufs_hba *hba);
+int ufshpb_probe(struct ufs_hba *hba);
+#else
+static inline void ufshpb_remove(struct ufs_hba *hba) {}
+static inline int ufshpb_probe(struct ufs_hba *hba) { return 0; }
+#endif
+
+#endif /* _UFSHPB_H */
-- 
2.7.4

