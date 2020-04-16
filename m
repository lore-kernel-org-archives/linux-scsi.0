Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAA9C352BE
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A14E2222D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:32:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWhiScUR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgDPUcF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 16:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730281AbgDPUb4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 16:31:56 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F79C061A0C;
        Thu, 16 Apr 2020 13:31:56 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k1so85903wrx.4;
        Thu, 16 Apr 2020 13:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YCE+zSdxGjkQtYH+WfKYTZ+v4wKfLNerEmxT43Wx92U=;
        b=jWhiScURRU2LsI8QLFTT/O6Y5M0Ipy0vfxhomBxGkQTrrgy9PLcsV6AV/1TgoqR4ff
         /uyAU2vQZjjGXKR74y3RW86kxcVd87XTiwPXhIWdWV3jy8sfI0xsE8hAmhNwICTfQPSQ
         d0J3e34vip2NSCaZmqL/aGAppjzgeRwehrfLVgtn5Aym9uHwFOZbHkAxpmisDgb+v702
         huK1bWvHEWnpgGotOwoqMnu1zqaw8F3/Qo7jXRCuCJdQS68/ee5gWT6o07WWRj3W2Oqw
         Odp457ESWi2t6tCAmC9hBLA1N2MM9WCWFs0aAj3ZyGltNChhnMMYNIC6vMYV1G+Gd1hg
         fc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YCE+zSdxGjkQtYH+WfKYTZ+v4wKfLNerEmxT43Wx92U=;
        b=Xptx6s+drxay1VrZlEti3putC4rkcQjBlZBVUTK3nl8gVHldeK8EoYob1gnVhelpal
         kpTP50fHrA7TSZFbXM8FZ+5aMg/WpwJ1lDvj7zjpst/Gmjd+mUXiv+crzupKttOats9b
         UDHrlHlwtESv3/2ZQMzAKajFOB7UZwbn7PMZlQILBWzbiSYzSf7DEGKpwgpacPqt65Lu
         8e64+jYVjpYQ7J3dO/0z65cWyxhMhHFoKdbmEJNFwLMXmz1RkRLG+4no7fqTu8Fng+Xy
         JL2ZDTcy6qqJ9dWL/lzOk/UxdMYdC0ZxXugUFG1SVrQFlONFCUB4qmjLfym5ea4Q5Jty
         0GVQ==
X-Gm-Message-State: AGi0PubfnF5e045C3lrehqagmu4Cym8QbWYCn7suhB6GYOaX1JxI115h
        1YVCTKxuTXk+clJ59ZqdOQE=
X-Google-Smtp-Source: APiQypIWROBwA32x2nHq0P1qqH3SHd1AU5kLC9TdGGwKSdWff2vdojdydy8xHx0uAuOq68maaHZMrw==
X-Received: by 2002:adf:82f5:: with SMTP id 108mr9912wrc.43.1587069112920;
        Thu, 16 Apr 2020 13:31:52 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id s9sm17638864wrg.27.2020.04.16.13.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 13:31:52 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB) driver
Date:   Thu, 16 Apr 2020 22:31:26 +0200
Message-Id: <20200416203126.1210-6-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200416203126.1210-1-beanhuo@micron.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patch is to add support for the UFS Host Performance Booster (HPB v1.0),
which is used to improve UFS read performance, especially for the random read.

NAND flash-based storage devices, including UFS, have mechanisms to translate
logical addresses of requests to the corresponding physical addresses of the
flash storage. Traditionally this L2P mapping data is loaded to the internal
SRAM in the storage controller. When the capacity of storage is larger, a
larger size of SRAM for the L2P map data is required. Since increased SRAM
size affects the manufacturing cost significantly, it is not cost-effective
to allocate all the amount of SRAM needed to keep all the Logical-address to
Physical-address (L2P) map data. Therefore, L2P map data, which is required
to identify the physical address for the requested IOs, can only be partially
stored in SRAM from NAND flash. Due to this partial loading, accessing the
flash address area where the L2P information for that address is not loaded
in the SRAM can result in serious performance degradation.

The HPB is a software solution for the above problem, which uses the host’s
system memory as a cache for the FTL L2P mapping table. It does not need
additional hardware support from the host side. By using HPB, the L2P mapping
table can be read from host memory and stored in host-side memory. while
reading the operation, the corresponding L2P information will be sent to the
UFS device along with the reading request. Since the L2P entry is provided in
the read request, UFS device does not have to load L2P entry from flash memory.
This will significantly improve random read performance.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/Kconfig  |   62 +
 drivers/scsi/ufs/Makefile |    1 +
 drivers/scsi/ufs/ufshcd.c |   55 +-
 drivers/scsi/ufs/ufshcd.h |   10 +
 drivers/scsi/ufs/ufshpb.c | 3279 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  450 +++++
 6 files changed, 3851 insertions(+), 6 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e2005aeddc2d..48704062861a 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -160,3 +160,65 @@ config SCSI_UFS_BSG
 
 	  Select this if you need a bsg device node for your UFS controller.
 	  If unsure, say N.
+
+config SCSI_UFSHPB
+	bool "UFS Host Performance Booster (EXPERIMENTAL)"
+	depends on SCSI_UFSHCD
+	help
+	  NAND flash-based storage devices, including UFS, have mechanisms to
+	  translate logical addresses of the IO requests to the corresponding
+	  physical addresses of the flash storage. Traditionally, this L2P
+	  mapping data is loaded to the internal SRAM in the storage controller.
+	  When the capacity of storage is larger, a larger size of SRAM for the
+	  L2P map data is required. Since increased SRAM size affects the
+	  manufacturing cost significantly, it is not cost-effective to allocate
+	  all the amount of SRAM needed to keep all the Logical-address to
+	  Physical-address (L2P) map data. Therefore, L2P map data, which is
+	  required to identify the physical address for the requested IOs, can
+	  only be partially stored in SRAM from NAND flash. Due to this partial
+	  loading, accessing the flash address area where the L2P information
+	  for that address is not loaded in the SRAM can result in serious
+	  performance degradation.
+
+	  UFS Host Performance Booster (HPB) is a software solution for the
+	  above problem, which uses the host side system memory as a cache for
+	  the FTL L2P mapping table. It does not need additional hardware
+	  support from the host side. By using HPB, the L2P mapping table can be
+	  read from host memory and stored in host-side memory. while reading
+	  the operation, the corresponding L2P information will be sent to the
+	  UFS device along with the reading request. Since the L2P entry is
+	  provided in the read request, UFS device does not have to load L2P
+	  entry from flash memory to UFS internal SRAM. This will significantly
+	  improve the read performance.
+
+	  When selected, this feature will be built in the UFS driver.
+
+	  If in doubt, say N.
+
+config UFSHPB_MAX_MEM_SIZE
+	int "UFS HPB maximum memory size per controller (in MiB)"
+	depends on SCSI_UFSHPB
+	default 128
+	range 0 65536
+	help
+	  This parameter defines the maximum UFS HPB memory/cache size in the
+	  host system. The recommended HPB cache size by the UFS device can be
+	  calculated from bHPBRegionSize and wDeviceMaxActiveHPBRegions. The
+	  reference formula can be
+
+		(bHPBRegionSize(in KB) / 4KB) * 8 * wDeviceMaxActiveHPBRegions.
+
+	  The HPB cache in the host system is used to contain L2P mapping entry.
+	  If the allocated HPB cache size is lower than what calculated by the
+	  above formula, the use of HPB feature may provide lower performance
+	  advantage. But the system memory resource has the limitation, we can
+	  not let HPB driver allocate its cache at will according to the UFS
+	  device recommendation, so an appropriate size of the cache for HPB
+	  should be specified before you choose to use HPB, then please input a
+	  non-zero positive integer value.
+
+	  Nevertheless, if you want to leave this right to the HPB driver, and
+	  let the HPB driver allocate the HPB cache based on the recommendation
+	  of the UFS device. Just give 0 value to this parameter.
+
+	  Leave the default value if unsure.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 94c6c5d7334b..24d9b69eab0c 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
+ufshcd-core-$(CONFIG_SCSI_UFSHPB) += ufshpb.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1fe7ffc1a75a..3847beb51a3e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2391,6 +2391,12 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
 						lrbp->cmd->sc_data_direction);
 		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+
+#if defined(CONFIG_SCSI_UFSHPB)
+		/* If HPB works, prepare for the HPB READ */
+		if (hba->ufshpb_state == HPB_PRESENT)
+			ufshpb_prep_fn(hba, lrbp);
+#endif
 	} else {
 		ret = -EINVAL;
 	}
@@ -4622,7 +4628,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
-
+#if defined(CONFIG_SCSI_UFSHPB)
+	if (sdev->lun < hba->dev_info.max_lu_supported)
+		hba->sdev_ufs_lu[sdev->lun] = sdev;
+#endif
 	return 0;
 }
 
@@ -4738,6 +4747,16 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 				 */
 				pm_runtime_get_noresume(hba->dev);
 			}
+
+#if defined(CONFIG_SCSI_UFSHPB)
+			/*
+			 * HPB recommendations are provided in RESPONSE UPIU
+			 * packets of successfully completed commands, which
+			 * are commands terminated with GOOD status.
+			 */
+			if (scsi_status == SAM_STAT_GOOD)
+				ufshpb_rsp_handler(hba, lrbp);
+#endif
 			break;
 		case UPIU_TRANSACTION_REJECT_UPIU:
 			/* TODO: handle Reject UPIU Response */
@@ -6081,6 +6100,11 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 		}
 	}
 	spin_lock_irqsave(host->host_lock, flags);
+
+#if defined(CONFIG_SCSI_UFSHPB)
+	if (hba->ufshpb_state == HPB_PRESENT)
+		hba->ufshpb_state = HPB_NEED_RESET;
+#endif
 	ufshcd_transfer_req_compl(hba);
 	spin_unlock_irqrestore(host->host_lock, flags);
 
@@ -6088,6 +6112,11 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	hba->req_abort_count = 0;
 	ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, (u32)err);
 	if (!err) {
+#if defined(CONFIG_SCSI_UFSHPB)
+		if (hba->ufshpb_state == HPB_NEED_RESET)
+			schedule_delayed_work(&hba->ufshpb_init_work,
+					      msecs_to_jiffies(10));
+#endif
 		err = SUCCESS;
 	} else {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
@@ -6627,16 +6656,16 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	dev_info->ufs_features = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
 
-	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
-		hba->dev_info.hpb_control_mode =
+	if (dev_info->ufs_features & 0x80) {
+		dev_info->hpb_control_mode =
 			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
-		hba->dev_info.hpb_ver =
+		dev_info->hpb_ver =
 			(u16) (desc_buf[DEVICE_DESC_PARAM_HPB_VER] << 8) |
 			desc_buf[DEVICE_DESC_PARAM_HPB_VER + 1];
 		dev_info(hba->dev, "HPB Version: 0x%2x\n",
-			 hba->dev_info.hpb_ver);
+			 dev_info->hpb_ver);
 		dev_info(hba->dev, "HPB control mode: %d\n",
-			 hba->dev_info.hpb_control_mode);
+			 dev_info->hpb_control_mode);
 	}
 	/*
 	 * getting vendor (manufacturerID) and Bank Index in big endian
@@ -7188,6 +7217,14 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
 	/* Probe and add UFS logical units  */
 	ret = ufshcd_add_lus(hba);
+
+#if defined(CONFIG_SCSI_UFSHPB)
+	/* Initialize HPB  */
+	if (hba->ufshpb_state == HPB_NEED_INIT)
+		schedule_delayed_work(&hba->ufshpb_init_work,
+				      msecs_to_jiffies(10));
+#endif
+
 out:
 	/*
 	 * If we failed to initialize the device or the device is not
@@ -8316,6 +8353,9 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
+#if defined(CONFIG_SCSI_UFSHPB)
+	ufshpb_release(hba, HPB_NEED_INIT);
+#endif
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_cleanup_queue(hba->tmf_queue);
@@ -8588,6 +8628,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
 
+#if defined(CONFIG_SCSI_UFSHPB)
+	ufshpb_init(hba);
+#endif
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7ce9cc2f10fe..a78b7836b848 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -70,6 +70,7 @@
 
 #include "ufs.h"
 #include "ufshci.h"
+#include "ufshpb.h"
 
 #define UFSHCD "ufshcd"
 #define UFSHCD_DRIVER_VERSION "0.2"
@@ -727,6 +728,15 @@ struct ufs_hba {
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
+
+#if defined(CONFIG_SCSI_UFSHPB)
+	enum UFSHPB_STATE ufshpb_state;
+	struct ufshpb_geo hpb_geo;
+	struct ufshpb_lu *ufshpb_lup[32];
+	struct delayed_work ufshpb_init_work;
+	struct work_struct ufshpb_eh_work;
+	struct scsi_device *sdev_ufs_lu[32];
+#endif
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
new file mode 100644
index 000000000000..75d8d179ef7d
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -0,0 +1,3279 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Universal Flash Storage Host Performance Booster
+ *
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ *
+ * Authors:
+ *	Yongmyung Lee <ymhungry.lee@samsung.com>
+ *	Jinyoung Choi <j-young.choi@samsung.com>
+ */
+
+#include <linux/blkdev.h>
+#include <linux/blktrace_api.h>
+#include <linux/sysfs.h>
+#include <scsi/scsi.h>
+
+#include "ufs.h"
+#include "ufshcd.h"
+#include "ufshpb.h"
+#include "ufs_quirks.h"
+
+#define hpb_trace(hpb, args...)						\
+	do { if ((hpb)->hba->sdev_ufs_lu[(hpb)->lun] &&			\
+		(hpb)->hba->sdev_ufs_lu[(hpb)->lun]->request_queue)	\
+		blk_add_trace_msg(					\
+		(hpb)->hba->sdev_ufs_lu[(hpb)->lun]->request_queue,	\
+				##args);				\
+	} while (0)
+
+/*
+ * define global constants
+ */
+static int sects_per_blk_shift;
+static int bits_per_dword_shift;
+static int bits_per_dword_mask;
+static int bits_per_byte_shift;
+
+static int ufshpb_execute_cmd(struct ufshpb_lu *hpb, unsigned char *cmd);
+static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb);
+static inline int ufshpb_region_mctx_discard(struct ufshpb_lu *hpb,
+					     struct ufshpb_region *cb);
+static void ufshpb_destroy_subregion_tbl(struct ufshpb_lu *hpb,
+					 struct ufshpb_region *cb);
+static int ufshpb_subregion_mctx_reserve(struct ufshpb_lu *hpb,
+					 struct ufshpb_subregion *cp);
+static inline void ufshpb_cleanup_lru_info(struct ufshpb_lu *hpb,
+					   struct ufshpb_region *cb);
+static void ufshpb_subregion_dirty(struct ufshpb_lu *hpb,
+				   struct ufshpb_subregion *cp);
+static int ufshpb_subregion_l2p_load(struct ufshpb_lu *hpb,
+				     struct ufshpb_subregion *cp, __u64 start_t,
+				     __u64 workq_enter_t);
+
+static void ufshpb_init_constant(struct ufs_hba *hba,
+				 struct ufshpb_geo_desc *geo_desc)
+{
+	struct ufshpb_geo *geo = &hba->hpb_geo;
+	u64 region_entry_sz;
+	int entries_per_region;
+
+	sects_per_blk_shift = ffs(UFS_LOGICAL_BLOCK_SIZE) - ffs(SECTOR_SIZE);
+	bits_per_dword_shift = ffs(BITS_PER_DWORD) - 1;
+	bits_per_dword_mask = BITS_PER_DWORD - 1;
+	bits_per_byte_shift = ffs(BITS_PER_BYTE) - 1;
+
+	geo->region_size_bytes = (u64)
+			SECTOR_SIZE * (0x01 << geo_desc->hpb_region_size);
+	region_entry_sz = geo->region_size_bytes /
+					UFS_LOGICAL_BLOCK_SIZE * HPB_ENTRY_SIZE;
+
+	geo->subregion_size_bytes = (u64)
+			SECTOR_SIZE * (0x01 << geo_desc->hpb_subregion_size);
+	geo->subregion_entry_sz = geo->subregion_size_bytes /
+		UFS_LOGICAL_BLOCK_SIZE * HPB_ENTRY_SIZE;
+
+	geo->dev_max_active_regions = geo_desc->hpb_dev_max_active_regions;
+	geo->max_hpb_lu_cnt = geo_desc->hpb_number_lu;
+	/*
+	 * Relationship across LU, region, subregion, L2P entry:
+	 * lu -> region -> sub region -> entry
+	 */
+	entries_per_region = region_entry_sz / HPB_ENTRY_SIZE;
+	geo->entries_per_subregion = geo->subregion_entry_sz / HPB_ENTRY_SIZE;
+	geo->subregions_per_region = region_entry_sz / geo->subregion_entry_sz;
+
+	/* mempool info */
+	geo->mpage_bytes = PAGE_SIZE;
+	geo->mpages_per_subregion = geo->subregion_entry_sz / geo->mpage_bytes;
+	/* Bitmask Info. */
+	geo->dwords_per_subregion = geo->entries_per_subregion /
+								BITS_PER_DWORD;
+	geo->entries_per_region_shift = ffs(entries_per_region) - 1;
+	geo->entries_per_region_mask = entries_per_region - 1;
+	geo->entries_per_subregion_shift = ffs(geo->entries_per_subregion) - 1;
+	geo->entries_per_subregion_mask = geo->entries_per_subregion - 1;
+
+	hpb_info("Maximum device active regions %d, maximum HPB LUs %d\n",
+		 geo->dev_max_active_regions, geo->max_hpb_lu_cnt);
+	hpb_info("Region size 0x%llx, Region L2P entry size 0x%llx\n",
+		 geo->region_size_bytes, region_entry_sz);
+	hpb_info("Subregion size 0x%llx, subregion L2P entry size 0x%x\n",
+		 geo->subregion_size_bytes, geo->subregion_entry_sz);
+	hpb_info("Subregions per region %d\n", geo->subregions_per_region);
+	hpb_info("Cnt of mpage per subregion %d\n", geo->mpages_per_subregion);
+}
+
+static void ufshpb_init_lu_constant(struct ufshpb_lu *lu_hpb,
+				    struct ufshpb_lu_desc *lu_desc)
+{
+	u64 subregion_size, region_entry_size, subregion_entry_size;
+	u64 last_subregion_size, last_region_size;
+	struct ufs_hba *hba = lu_hpb->hba;
+	struct ufshpb_geo *geo = &hba->hpb_geo;
+	int lu_num_blocks;
+
+	lu_num_blocks = lu_desc->lu_logblk_cnt;
+
+	lu_hpb->lu_max_active_regions = lu_desc->lu_max_active_hpb_regions;
+	lu_hpb->lu_pinned_regions = lu_desc->lu_num_hpb_pinned_regions;
+
+	/*
+	 * HPB Sub-Regions are equally sized except for the last one which is
+	 * smaller if the last HPB Region is not an integer multiple of
+	 * bHPBSubRegionSize
+	 */
+	lu_hpb->subregions_in_last_region = geo->subregions_per_region;
+	lu_hpb->last_subregion_entry_size = geo->subregion_entry_sz;
+	last_region_size = (u64)lu_num_blocks * UFS_LOGICAL_BLOCK_SIZE %
+						geo->region_size_bytes;
+	if (last_region_size) {
+		subregion_size = geo->subregion_size_bytes;
+		last_subregion_size = (u64)last_region_size % subregion_size;
+		if (last_subregion_size) {
+			lu_hpb->subregions_in_last_region = last_region_size /
+				subregion_size + 1;
+			lu_hpb->last_subregion_entry_size =
+				last_subregion_size / UFS_LOGICAL_BLOCK_SIZE *
+				HPB_ENTRY_SIZE;
+		} else {
+			lu_hpb->subregions_in_last_region = last_region_size /
+								subregion_size;
+		}
+	}
+
+	/*
+	 * 1. regions_per_lu = (lu_num_blocks * 4096) / region_size
+	 *		= (lu_num_blocks * HPB_ENTRY_SIZE) / region_entry_size
+	 *		= lu_num_blocks / (region_entry_size / HPB_ENTRY_SIZE)
+	 *
+	 * 2. regions_per_lu = lu_num_blocks / subregion_entry_size (is trik...)
+	 *    if HPB_ENTRY_SIZE != subregions_per_region, it is error.
+	 */
+	subregion_entry_size = geo->subregion_entry_sz;
+	region_entry_size = geo->subregions_per_region * subregion_entry_size;
+	lu_hpb->lu_region_cnt = ((unsigned long long)lu_num_blocks
+			       + (region_entry_size / HPB_ENTRY_SIZE) - 1) /
+				(region_entry_size / HPB_ENTRY_SIZE);
+	lu_hpb->lu_subregion_cnt = ((unsigned long long)lu_num_blocks
+			+ (subregion_entry_size / HPB_ENTRY_SIZE) - 1) /
+			(subregion_entry_size / HPB_ENTRY_SIZE);
+
+	hpb_info("LU%d Maximum active regions %d, pinned regions %d\n",
+		 lu_hpb->lun, lu_hpb->lu_max_active_regions,
+		 lu_hpb->lu_pinned_regions);
+	hpb_info("LU%d Total logical Block Count %d, region count %d\n",
+		 lu_hpb->lun, lu_num_blocks, lu_hpb->lu_region_cnt);
+	hpb_info("LU%d Subregions count per lun %d\n", lu_hpb->lun,
+		 lu_hpb->lu_subregion_cnt);
+	hpb_info("LU%d Last region size 0x%llx, last subregion L2P entry %d\n",
+		 lu_hpb->lun, last_region_size,
+		 lu_hpb->last_subregion_entry_size);
+}
+
+static inline int ufshpb_blocksize_is_supported(struct ufshpb_lu *hpb,
+						int sectors)
+{
+	int ret = true;
+
+	if (sectors > SECTORS_PER_BLOCK)
+		ret = false;
+		/* HPB 1.0 only supports 4KB TRANSFER LENGTH */
+
+	return ret;
+}
+
+static struct
+ufshpb_region *ufshpb_victim_region_select(struct active_region_info *lru_info)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_region *victim_cb = NULL;
+	u32 hit_count = 0xffffffff;
+
+	switch (lru_info->selection_type) {
+	case LRU:
+		/*
+		 * Choose first region from the active region list
+		 */
+		victim_cb = list_first_entry(&lru_info->lru,
+					     struct ufshpb_region, list_region);
+		break;
+	case LFU:
+		/*
+		 * Choose active region with the lowest hit_count
+		 */
+		list_for_each_entry(cb, &lru_info->lru, list_region) {
+			if (hit_count > cb->hit_count) {
+				hit_count = cb->hit_count;
+				victim_cb = cb;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+
+	return victim_cb;
+}
+
+static inline void ufshpb_get_bit_offset(struct ufshpb_lu *hpb,
+					 int subregion_offset,
+					 int *dword, int *offset)
+{
+	*dword = subregion_offset >> bits_per_dword_shift;
+	*offset = subregion_offset & bits_per_dword_mask;
+}
+
+static inline struct
+hpb_sense_data *ufshpb_get_sense_data(struct ufshcd_lrb *lrbp)
+{
+	return (struct hpb_sense_data *)&lrbp->ucd_rsp_ptr->sr.sense_data_len;
+}
+
+static inline void ufshpb_prepare_read_buf_cmd(unsigned char *cmd, int region,
+					       int subregion, int alloc_len)
+{
+	cmd[0] = UFSHPB_READ_BUFFER;
+	cmd[1] = 0x01;
+	cmd[2] = GET_BYTE_1(region);
+	cmd[3] = GET_BYTE_0(region);
+	cmd[4] = GET_BYTE_1(subregion);
+	cmd[5] = GET_BYTE_0(subregion);
+	cmd[6] = GET_BYTE_2(alloc_len);
+	cmd[7] = GET_BYTE_1(alloc_len);
+	cmd[8] = GET_BYTE_0(alloc_len);
+	cmd[9] = 0x00;
+}
+
+static inline void ufshpb_prepare_write_buf_cmd(unsigned char *cmd, int region)
+{
+	cmd[0] = UFSHPB_WRITE_BUFFER;
+	cmd[1] = 0x01;
+	cmd[2] = GET_BYTE_1(region);
+	cmd[3] = GET_BYTE_0(region);
+	cmd[9] = 0x00;
+}
+
+static void ufshpb_prepare_hpb_read(struct ufshpb_lu *hpb,
+				    struct ufshcd_lrb *lrbp,
+				    unsigned long long entry, int blk_cnt)
+{
+	unsigned char cmd[16] = { };
+	/*
+	 * cmd[14] = Transfer length
+	 */
+	cmd[0] = UFSHPB_READ;
+	cmd[2] = lrbp->cmd->cmnd[2];
+	cmd[3] = lrbp->cmd->cmnd[3];
+	cmd[4] = lrbp->cmd->cmnd[4];
+	cmd[5] = lrbp->cmd->cmnd[5];
+	cmd[6] = GET_BYTE_7(entry);
+	cmd[7] = GET_BYTE_6(entry);
+	cmd[8] = GET_BYTE_5(entry);
+	cmd[9] = GET_BYTE_4(entry);
+	cmd[10] = GET_BYTE_3(entry);
+	cmd[11] = GET_BYTE_2(entry);
+	cmd[12] = GET_BYTE_1(entry);
+	cmd[13] = GET_BYTE_0(entry);
+	cmd[14] = blk_cnt;
+	cmd[15] = 0x00;
+	memcpy(lrbp->cmd->cmnd, cmd, 16);
+	memcpy(lrbp->ucd_req_ptr->sc.cdb, cmd, 16);
+}
+
+/* Get L2P entry(8 bytes) from HPB host side memory */
+static inline unsigned long long ufshpb_get_ppn(struct ufshpb_map_ctx *mctx,
+						int pos)
+{
+	unsigned long long *ppn_table;
+	struct page *page;
+	int index, offset;
+
+	index = pos / HPB_ENTREIS_PER_OS_PAGE;
+	offset = pos % HPB_ENTREIS_PER_OS_PAGE;
+
+	page = mctx->m_page[index];
+	WARN_ON(!page);
+
+	ppn_table = page_address(page);
+	WARN_ON(!ppn_table);
+
+	return ppn_table[offset];
+}
+
+/*
+ * Note: hpb->hpb_lock (irq) should be held before calling this function
+ */
+static inline void ufshpb_l2p_entry_dirty_bit_set(struct ufshpb_lu *hpb,
+						  struct ufshpb_region *cb,
+						  struct ufshpb_subregion *cp,
+						  int dword, int offset,
+						  unsigned int count)
+{
+	struct ufshpb_geo *geo;
+	const unsigned long mask = ((1UL << count) - 1) & 0xffffffff;
+
+	if (cb->region_state == REGION_INACTIVE ||
+	    cp->subregion_state == SUBREGION_DIRTY)
+		return;
+
+	geo = &hpb->hba->hpb_geo;
+
+	WARN_ON(!cp->mctx);
+	cp->mctx->ppn_dirty[dword] |= (mask << offset);
+	cp->mctx->ppn_dirty_counter += count;
+
+	if (cp->mctx->ppn_dirty_counter >= geo->entries_per_subregion)
+		ufshpb_subregion_dirty(hpb, cp);
+}
+
+/*
+ * Check if this entry/ppn is dirty or not in the L2P entry cache,
+ * Note: hpb->hpb_lock (irq) should be held before calling this function
+ */
+static bool ufshpb_l2p_entry_dirty_check(struct ufshpb_lu *hpb,
+					 struct ufshpb_subregion *cp,
+					 int subregion_offset)
+{
+	bool is_dirty;
+	unsigned int bit_dword, bit_offset;
+
+	if (!cp->mctx->ppn_dirty || cp->subregion_state == SUBREGION_DIRTY)
+		return false;
+
+	ufshpb_get_bit_offset(hpb, subregion_offset,
+			      &bit_dword, &bit_offset);
+
+	is_dirty = cp->mctx->ppn_dirty[bit_dword] &
+			(1 << bit_offset) ? true : false;
+
+	return is_dirty;
+}
+
+static void ufshpb_l2p_entry_dirty_set(struct ufshpb_lu *hpb,
+				       unsigned int rq_sectors, int region,
+				       int subregion, int subregion_offset)
+{
+	struct ufshpb_geo *geo;
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	int bit_count, dword, bit_offset, blk_cnt;
+
+	geo = &hpb->hba->hpb_geo;
+	blk_cnt = rq_sectors >> sects_per_blk_shift;
+	ufshpb_get_bit_offset(hpb, subregion_offset, &dword, &bit_offset);
+
+	do {
+		bit_count = min(blk_cnt, BITS_PER_DWORD - bit_offset);
+
+		cb = hpb->region_tbl + region;
+		cp = cb->subregion_tbl + subregion;
+
+		ufshpb_l2p_entry_dirty_bit_set(hpb, cb, cp, dword, bit_offset,
+					       bit_count);
+
+		bit_offset = 0;
+		dword++;
+
+		if (dword == geo->dwords_per_subregion) {
+			dword = 0;
+			subregion++;
+
+			if (subregion == geo->subregions_per_region) {
+				subregion = 0;
+				region++;
+			}
+		}
+		blk_cnt -= bit_count;
+	} while (blk_cnt);
+
+	WARN_ON(blk_cnt < 0);
+}
+
+static struct ufshpb_rsp_info *ufshpb_rsp_info_get(struct ufshpb_lu *hpb)
+{
+	unsigned long flags;
+	struct ufshpb_rsp_info *rsp_info;
+
+	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	rsp_info = list_first_entry_or_null(&hpb->lh_rsp_info_free,
+					    struct ufshpb_rsp_info,
+					    list_rsp_info);
+	if (!rsp_info) {
+		hpb_dbg(FAILURE_INFO, hpb, "No free rsp_info\n");
+		goto out;
+	}
+	list_del(&rsp_info->list_rsp_info);
+	memset(rsp_info, 0x00, sizeof(struct ufshpb_rsp_info));
+
+	INIT_LIST_HEAD(&rsp_info->list_rsp_info);
+out:
+
+	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+	return rsp_info;
+}
+
+static void ufshpb_rsp_info_put(struct ufshpb_lu *hpb,
+				struct ufshpb_rsp_info *rsp_info)
+{
+	unsigned long flags;
+
+	WARN_ON(!rsp_info);
+
+	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	list_add_tail(&rsp_info->list_rsp_info, &hpb->lh_rsp_info_free);
+	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+}
+
+static void ufshpb_rsp_info_fill(struct ufshpb_lu *hpb,
+				 struct ufshpb_rsp_info *rsp_info,
+				 struct hpb_sense_data *sense_data)
+{
+	int num, idx;
+
+	rsp_info->type = HPB_REQ_REGION_UPDATE;
+	rsp_info->rsp_start = ktime_to_ns(ktime_get());
+
+	for (num = 0; num < sense_data->active_region_cnt; num++) {
+		idx = num * PER_ACTIVE_INFO_BYTES;
+		rsp_info->active_list.region[num] =
+			SHIFT_BYTE_1(sense_data->active_field[idx + 0]) |
+			SHIFT_BYTE_0(sense_data->active_field[idx + 1]);
+		rsp_info->active_list.subregion[num] =
+			SHIFT_BYTE_1(sense_data->active_field[idx + 2]) |
+			SHIFT_BYTE_0(sense_data->active_field[idx + 3]);
+		hpb_dbg(REGION_INFO, hpb, "RSP UPIU: ACT[%d]: RG %d, SRG %d",
+			num + 1, rsp_info->active_list.region[num],
+			rsp_info->active_list.subregion[num]);
+	}
+	rsp_info->active_cnt = num;
+
+	for (num = 0; num < sense_data->inactive_region_cnt; num++) {
+		idx = num * PER_INACTIVE_INFO_BYTES;
+		rsp_info->inactive_list.region[num] =
+			SHIFT_BYTE_1(sense_data->inactive_field[idx + 0]) |
+			SHIFT_BYTE_0(sense_data->inactive_field[idx + 1]);
+		hpb_dbg(REGION_INFO, hpb, "RSP UPIU: INACT[%d]: Region%d",
+			num + 1, rsp_info->inactive_list.region[num]);
+	}
+	rsp_info->inactive_cnt = num;
+}
+
+static struct ufshpb_req_info *ufshpb_req_info_get(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req_info *req_info;
+
+	spin_lock(&hpb->req_list_lock);
+	req_info = list_first_entry_or_null(&hpb->lh_req_info_free,
+					    struct ufshpb_req_info,
+					    list_req_info);
+	if (!req_info) {
+		hpb_dbg(FAILURE_INFO, hpb, "No free req_info\n");
+		goto out;
+	}
+
+	list_del(&req_info->list_req_info);
+	memset(req_info, 0x00, sizeof(struct ufshpb_req_info));
+
+	INIT_LIST_HEAD(&req_info->list_req_info);
+out:
+	spin_unlock(&hpb->req_list_lock);
+	return req_info;
+}
+
+static void ufshpb_req_info_put(struct ufshpb_lu *hpb,
+				struct ufshpb_req_info *req_info)
+{
+	WARN_ON(!req_info);
+
+	spin_lock(&hpb->req_list_lock);
+	list_add_tail(&req_info->list_req_info, &hpb->lh_req_info_free);
+	spin_unlock(&hpb->req_list_lock);
+}
+
+static inline bool ufshpb_is_read_lrbp(struct ufshcd_lrb *lrbp)
+{
+	if (lrbp->cmd->cmnd[0] == READ_10 || lrbp->cmd->cmnd[0] == READ_16)
+		return true;
+
+	return false;
+}
+
+static inline bool ufshpb_is_write_discard_lrbp(struct ufshcd_lrb *lrbp)
+{
+	if (lrbp->cmd->cmnd[0] == WRITE_10 || lrbp->cmd->cmnd[0] == WRITE_16 ||
+	    lrbp->cmd->cmnd[0] == UNMAP)
+		return true;
+
+	return false;
+}
+
+static inline void ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb,
+					   unsigned int lpn, int *region,
+					   int *subregion, int *offset)
+{
+	int region_offset;
+	struct ufshpb_geo *geo;
+
+	geo = &hpb->hba->hpb_geo;
+
+	*region = lpn >> geo->entries_per_region_shift;
+	region_offset = lpn & geo->entries_per_region_mask;
+	*subregion = region_offset >> geo->entries_per_subregion_shift;
+	*offset = region_offset & geo->entries_per_subregion_mask;
+}
+
+static int ufshpb_subregion_dirty_bitmap_clean(struct ufshpb_lu *hpb,
+					       struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_geo *geo;
+
+	geo = &hpb->hba->hpb_geo;
+
+	cb = hpb->region_tbl + cp->region;
+
+	/* if mctx is null, active block had been evicted out */
+	if (cb->region_state == REGION_INACTIVE || !cp->mctx) {
+		hpb_dbg(FAILURE_INFO, hpb, "RG_SRG (%d-%d) has been evicted\n",
+			cp->region, cp->subregion);
+		return -EINVAL;
+	}
+
+	memset(cp->mctx->ppn_dirty, 0x00,
+	       geo->entries_per_subregion >> bits_per_byte_shift);
+
+	return 0;
+}
+
+/*
+ * Change subregion_state to SUBREGION_CLEAN
+ */
+static void ufshpb_subregion_clean(struct ufshpb_lu *hpb,
+				   struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+
+	cb = hpb->region_tbl + cp->region;
+
+	/*
+	 * If mctx is null or the state of region is not active,
+	 * that means relavent region had been evicted out.
+	 */
+	if (cb->region_state == REGION_INACTIVE || !cp->mctx) {
+		hpb_dbg(FAILURE_INFO, hpb, "RG_SRG (%d-%d) has been evicted\n",
+			cp->region, cp->subregion);
+		return;
+	}
+
+	cp->subregion_state = SUBREGION_CLEAN;
+}
+
+/*
+ * Change subregion_state to SUBREGION_DIRTY, and remain its mctx
+ */
+static void ufshpb_subregion_dirty(struct ufshpb_lu *hpb,
+				   struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+
+	cb = hpb->region_tbl + cp->region;
+
+	/* if mctx is null, active region had been evicted out */
+	if (cb->region_state == REGION_INACTIVE || !cp->mctx ||
+	    cp->subregion_state == SUBREGION_DIRTY) {
+		return;
+	}
+	cp->subregion_state = SUBREGION_DIRTY;
+	cb->subregion_dirty_count++;
+}
+
+static int ufshpb_subregion_is_clean(struct ufshpb_lu *hpb,
+				     struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+	int is_clean;
+
+	cb = hpb->region_tbl + cp->region;
+	is_clean = true;
+
+	if (cb->region_state == REGION_INACTIVE) {
+		is_clean = false;
+		atomic64_inc(&hpb->status.region_miss);
+	} else if (cp->subregion_state != SUBREGION_CLEAN) {
+		is_clean = false;
+		atomic64_inc(&hpb->status.subregion_miss);
+	}
+
+	return is_clean;
+}
+
+/*
+ * Select one victim region from active regions, and discard its mctx. If one
+ * HPB BUFFER WRITE command needed, add a req_info to hpb->lh_req_info
+ */
+static int ufshpb_evict_one_region(struct ufshpb_lu *hpb, int *victim_region,
+				   bool hpb_wb_needed)
+{
+	struct ufshpb_region *victim_cb;
+	struct active_region_info *lru_info;
+	struct ufshpb_req_info *req_info = NULL;
+	int ret;
+
+	if (hpb_wb_needed) {
+		req_info = ufshpb_req_info_get(hpb);
+		if (!req_info) {
+			hpb_dbg(FAILURE_INFO, hpb, "No req_info in mempool\n");
+			return -ENOSPC;
+		}
+	}
+
+	lru_info = &hpb->lru_info;
+
+	victim_cb = ufshpb_victim_region_select(lru_info);
+	if (!victim_cb) {
+		hpb_warn("UFSHPB victim_cb is NULL\n");
+		ret = -EIO;
+		goto out;
+	}
+	hpb_trace(hpb, "%s: VT RG %d", DRIVER_NAME, victim_cb->region);
+	hpb_dbg(REGION_INFO, hpb, "LU%d HPB will discard active region %d\n",
+		hpb->lun,  victim_cb->region);
+
+	ret = ufshpb_region_mctx_discard(hpb, victim_cb);
+	if (ret)
+		goto out;
+
+	if (victim_cb->region_state != REGION_INACTIVE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (req_info) {
+		req_info->type = HPB_REGION_DEACTIVATE;
+		req_info->region = victim_cb->region;
+		req_info->req_start_t = ktime_to_ns(ktime_get());
+
+		spin_lock(&hpb->req_list_lock);
+		list_add_tail(&req_info->list_req_info, &hpb->lh_req_info);
+		spin_unlock(&hpb->req_list_lock);
+	}
+
+	*victim_region = victim_cb->region;
+	return 0;
+out:
+	if (req_info)
+		ufshpb_req_info_put(hpb, req_info);
+	return ret;
+}
+
+/*
+ * Submit one subregion to req_info list which is for activating subregion
+ */
+static int
+ufshpb_subregion_register(struct ufshpb_lu *hpb, struct ufshpb_subregion *cp)
+{
+	struct ufshpb_req_info *req_info;
+	struct active_region_info *lru_info;
+	struct ufshpb_region *cb;
+	int ret;
+
+	cb = hpb->region_tbl + cp->region;
+	lru_info = &hpb->lru_info;
+
+	ret = ufshpb_subregion_mctx_reserve(hpb, cp);
+	if (ret)
+		return ret;
+
+	if (cp->subregion_state == SUBREGION_UNUSED ||
+	    cp->subregion_state == SUBREGION_DIRTY) {
+		req_info = ufshpb_req_info_get(hpb);
+		if (!req_info) {
+			hpb_dbg(FAILURE_INFO, hpb, "No req_info in mempool\n");
+			return -ENOMEM;
+		}
+
+		req_info->type = HPB_SUBREGION_ACTIVATE;
+		req_info->region = cp->region;
+		req_info->subregion = cp->subregion;
+		req_info->req_start_t = ktime_to_ns(ktime_get());
+
+		spin_lock(&hpb->req_list_lock);
+		list_add_tail(&req_info->list_req_info, &hpb->lh_req_info);
+		spin_unlock(&hpb->req_list_lock);
+
+		cp->subregion_state = SUBREGION_REGISTERED;
+		hpb_dbg(REGION_INFO, hpb, "Add RG_SRG (%d-%d) to activate\n",
+			cp->region, cp->subregion);
+	}
+
+	return 0;
+}
+
+static void ufshpb_region_deactivate(struct ufshpb_lu *hpb,
+				     struct ufshpb_req_info *req_info)
+{
+	struct ufshpb_region *cb;
+	unsigned char cmd[10];
+	int region;
+	int ret;
+
+	region = req_info->region;
+	cb = hpb->region_tbl + region;
+
+	if (region >= hpb->lu_region_cnt) {
+		hpb_err("Region exceeds lu_region_cnt\n");
+		return;
+	}
+
+	ufshpb_prepare_write_buf_cmd(cmd, region);
+
+	if (hpb->force_map_req_disable) {
+		hpb_notice("LU%d HPB map_req disabled - return\n", hpb->lun);
+		return;
+	}
+
+	ret = ufshpb_execute_cmd(hpb, cmd);
+	if (ret) {
+		hpb_err("ufshpb_execute_cmd failed with error %d\n", ret);
+		hpb->hba->ufshpb_state = HPB_FAILED;
+		schedule_work(&hpb->hba->ufshpb_eh_work);
+	}
+}
+
+static void ufshpb_subregion_activate(struct ufshpb_lu *hpb,
+				      struct ufshpb_req_info *req_info)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	int region, subregion;
+	int ret;
+
+	region = req_info->region;
+	subregion = req_info->subregion;
+
+	if (region >= hpb->lu_region_cnt) {
+		hpb_err("Region%d exceeds lu_region_cnt\n", region);
+		goto out;
+	}
+
+	cb = hpb->region_tbl + region;
+
+	if (subregion >= cb->subregion_count) {
+		hpb_err("Subregion%d exceeds subregion_count %d", subregion,
+			cb->subregion_count);
+		goto out;
+	}
+
+	cp = cb->subregion_tbl + subregion;
+
+	spin_lock(&hpb->hpb_lock);
+
+	if (list_empty(&cb->list_region)) {
+		spin_unlock(&hpb->hpb_lock);
+		hpb_warn("mctx wasn't assinged in Region%d\n", region);
+		goto out;
+	}
+
+	if (cp->subregion_state == SUBREGION_ISSUED ||
+	    cp->subregion_state == SUBREGION_CLEAN) {
+		hpb_dbg(SCHEDULE_INFO, hpb,
+			"HPB BUFFER READ of RG_SRG (%d-%d) has been issued",
+			region, subregion);
+		spin_unlock(&hpb->hpb_lock);
+		goto out;
+	}
+
+	cp->subregion_state = SUBREGION_ISSUED;
+	ret = ufshpb_subregion_dirty_bitmap_clean(hpb, cp);
+	spin_unlock(&hpb->hpb_lock);
+	if (ret)
+		goto out;
+
+	if (hpb->force_map_req_disable) {
+		hpb_notice("LU%d HPB map_req disabled - return\n", hpb->lun);
+		goto out;
+	}
+	ret = ufshpb_subregion_l2p_load(hpb, cp, req_info->req_start_t,
+					req_info->workq_enter_t);
+	if (ret)
+		hpb_err("ufshpb_subregion_l2p_load failed with ret %d\n", ret);
+out:
+	return;
+}
+
+static inline struct ufshpb_map_ctx *ufshpb_mctx_get(struct ufshpb_lu *hpb,
+						     int *err)
+{
+	struct ufshpb_map_ctx *mctx;
+
+	mctx = list_first_entry_or_null(&hpb->lh_map_ctx, struct ufshpb_map_ctx,
+					list_table);
+	if (mctx) {
+		list_del_init(&mctx->list_table);
+		hpb->free_mctx_count--;
+		*err = 0;
+		return mctx;
+	}
+	*err = -ENOMEM;
+
+	return NULL;
+}
+
+static inline void ufshpb_mctx_put(struct ufshpb_lu *hpb,
+				   struct ufshpb_map_ctx *mctx)
+{
+	list_add(&mctx->list_table, &hpb->lh_map_ctx);
+	hpb->free_mctx_count++;
+}
+
+/*
+ * Discard the active subregion mctx, and clear its read_counter
+ */
+static inline void ufshpb_subregion_mctx_purge(struct ufshpb_lu *hpb,
+					       struct ufshpb_subregion *cp,
+					       int state)
+{
+	if (state == SUBREGION_UNUSED) {
+		ufshpb_mctx_put(hpb, cp->mctx);
+		cp->mctx = NULL;
+	}
+
+	cp->subregion_state = state;
+	atomic_set(&cp->read_counter, 0);
+}
+
+struct ufshpb_map_ctx *ufshpb_subregion_mctx_alloc(struct ufshpb_lu *hpb)
+{
+	int i, j;
+	int entries;
+	struct ufshpb_map_ctx *mctx;
+	struct ufshpb_geo *geo;
+
+	geo = &hpb->hba->hpb_geo;
+	entries = geo->entries_per_subregion;
+
+	mctx = kzalloc(sizeof(*mctx), GFP_KERNEL);
+	if (!mctx)
+		return NULL;
+
+	mctx->m_page = kcalloc(geo->mpages_per_subregion, sizeof(struct page *),
+			       GFP_KERNEL);
+	if (!mctx->m_page)
+		goto release_mem;
+
+	mctx->ppn_dirty = kvzalloc(entries >> bits_per_byte_shift, GFP_KERNEL);
+	if (!mctx->ppn_dirty)
+		goto release_mem;
+
+	for (i = 0; i < geo->mpages_per_subregion; i++) {
+		mctx->m_page[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!mctx->m_page[i]) {
+			for (j = 0; j < i; j++)
+				kfree(mctx->m_page[j]);
+			goto release_mem;
+		}
+	}
+	return mctx;
+
+release_mem:
+	kfree(mctx->m_page);
+	kvfree(mctx->ppn_dirty);
+	kfree(mctx);
+	return NULL;
+}
+
+/*
+ * Add new region to active region info lru_info
+ */
+static inline void ufshpb_add_lru_info(struct active_region_info *lru_info,
+				       struct ufshpb_region *cb)
+{
+	cb->region_state = REGION_ACTIVE;
+	cb->hit_count = 1;
+	list_add_tail(&cb->list_region, &lru_info->lru);
+	atomic64_inc(&lru_info->active_cnt);
+}
+
+static inline void ufshpb_hit_lru_info(struct active_region_info *lru_info,
+				       struct ufshpb_region *cb)
+{
+	if (list_empty(&cb->list_region)) {
+		hpb_err("RG %d hasn't been added in lru_info\n", cb->region);
+		return;
+	}
+
+	list_move_tail(&cb->list_region, &lru_info->lru);
+	if (cb->hit_count != 0xffffffff)
+		cb->hit_count++;
+}
+
+/*
+ * Remove active region from active region info lru_info
+ */
+static inline void ufshpb_cleanup_lru_info(struct ufshpb_lu *hpb,
+					   struct ufshpb_region *cb)
+{
+	struct active_region_info *lru_info;
+
+	lru_info = &hpb->lru_info;
+
+	list_del_init(&cb->list_region);
+	cb->region_state = REGION_INACTIVE;
+	cb->hit_count = 0;
+	atomic64_dec(&lru_info->active_cnt);
+}
+
+static void  ufshpb_l2p_load_req_error_handler(struct ufshpb_lu *hpb,
+					       struct request *req,
+					       int *retried)
+{
+	struct ufshpb_region *cb;
+	struct scsi_sense_hdr sshdr;
+	struct ufshpb_map_req *map_req;
+	struct scsi_cmnd *scmd;
+
+	map_req = (struct ufshpb_map_req *)req->end_io_data;
+	cb = hpb->region_tbl + map_req->region;
+
+	scmd = blk_mq_rq_to_pdu(req);
+	scsi_normalize_sense(scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE, &sshdr);
+
+	hpb_err("LU%d HPB READ BUFFER RG_SRG (%d-%d) failed\n", map_req->lun,
+		map_req->region, map_req->subregion);
+	hpb_err("RSP_code 0x%x sense_key 0x%x ASC 0x%x ASCQ 0x%x\n",
+		sshdr.response_code, sshdr.sense_key, sshdr.asc, sshdr.ascq);
+	hpb_err("byte4 %x byte5 %x byte6 %x additional_len %x\n", sshdr.byte4,
+		sshdr.byte5, sshdr.byte6, sshdr.additional_length);
+
+	atomic64_inc(&hpb->status.rb_fail);
+
+	switch (sshdr.sense_key) {
+	case ILLEGAL_REQUEST:
+		spin_lock(&hpb->hpb_lock);
+		if (cb->region_state == REGION_PINNED &&
+		    map_req->retry_cnt < HPB_MAP_REQ_RETRIES) {
+			/*
+			 * If the HPB buffer Read request for the Pinned region
+			 * meets the UFS device GC, the device will return
+			 * ILLEGAL_REQUEST. For this case, we should retry this
+			 * request later.
+			 */
+			hpb_dbg(REGION_INFO, hpb,
+				"Retry pinned RG_SRG (%d-%d) L2P load",
+				map_req->region, map_req->subregion);
+
+			INIT_LIST_HEAD(&map_req->list_map_req);
+			list_add_tail(&map_req->list_map_req,
+				      &hpb->lh_map_req_retry);
+			spin_unlock(&hpb->hpb_lock);
+
+			schedule_delayed_work(&hpb->retry_work,
+					      msecs_to_jiffies(5000));
+			*retried = 1;
+			return;
+		}
+		hpb_dbg(REGION_INFO, hpb, "Mark RG_SRG (%d-%d) dirty",
+			map_req->region, map_req->subregion);
+		ufshpb_subregion_dirty(hpb, cb->subregion_tbl +
+				       map_req->subregion);
+		spin_unlock(&hpb->hpb_lock);
+		break;
+	default:
+		/* FIXME, need to fix EIO error and timeout issue*/
+		break;
+	}
+	*retried = 0;
+}
+
+/*
+ * This function is only to change subregion_state to  SUBREGION_CLEAN
+ */
+static void ufshpb_l2p_load_req_compl(struct ufshpb_lu *hpb,
+				      struct ufshpb_map_req *map_req)
+{
+	map_req->req_end_t = ktime_to_ns(ktime_get());
+
+	hpb_trace(hpb, "%s: C RB %d - %d", DRIVER_NAME, map_req->region,
+		  map_req->subregion);
+	hpb_dbg(SCHEDULE_INFO, hpb,
+		"LU%d HPB READ BUFFER COMPL RG_SRG (%d-%d), took %lldns\n",
+		hpb->lun, map_req->region, map_req->subregion,
+		map_req->req_end_t - map_req->req_start_t);
+	hpb_dbg(SCHEDULE_INFO, hpb,
+		"stage1 %lldns, stage2 %lldns, stage3 %lldns",
+		map_req->workq_enter_t - map_req->req_start_t,
+		map_req->req_issue_t - map_req->workq_enter_t,
+		map_req->req_end_t - map_req->req_issue_t);
+
+	spin_lock(&hpb->hpb_lock);
+	ufshpb_subregion_clean(hpb,
+			       hpb->region_tbl[map_req->region].subregion_tbl +
+			       map_req->subregion);
+	spin_unlock(&hpb->hpb_lock);
+}
+
+static void ufshpb_l2p_load_req_done(struct request *req, blk_status_t status)
+{
+	struct ufs_hba *hba;
+	struct ufshpb_lu *hpb;
+	struct ufshpb_map_req *map_req;
+	int retried = 0;
+
+	map_req = (struct ufshpb_map_req *)req->end_io_data;
+
+	hpb = map_req->hpb;
+	hba = hpb->hba;
+
+	if (hba->ufshpb_state != HPB_PRESENT)
+		goto free_map_req;
+
+	if (status) {
+		hpb_err("SCSI Request result 0x%x, blk error status %d\n",
+			scsi_req(req)->result, status);
+		ufshpb_l2p_load_req_error_handler(hpb, req, &retried);
+	} else {
+		ufshpb_l2p_load_req_compl(hpb, map_req);
+	}
+
+	if (retried)
+		return;
+free_map_req:
+	INIT_LIST_HEAD(&map_req->list_map_req);
+	spin_lock(&hpb->hpb_lock);
+	map_req->req = NULL;
+	scsi_req_free_cmd(scsi_req(req));
+	blk_put_request(req);
+	list_add_tail(&map_req->list_map_req, &hpb->lh_map_req_free);
+	spin_unlock(&hpb->hpb_lock);
+}
+
+static int ufshpb_execute_cmd(struct ufshpb_lu *hpb, unsigned char *cmd)
+{
+	struct scsi_sense_hdr sshdr;
+	struct scsi_device *sdp;
+	struct ufs_hba *hba;
+	int retries;
+	int ret = 0;
+
+	hba = hpb->hba;
+
+	sdp = hba->sdev_ufs_lu[hpb->lun];
+	if (!sdp) {
+		hpb_warn("%s UFSHPB cannot find scsi_device\n",  __func__);
+		return -ENODEV;
+	}
+
+	ret = scsi_device_get(sdp);
+	if (!ret && !scsi_device_online(sdp)) {
+		ret = -ENODEV;
+		scsi_device_put(sdp);
+		return ret;
+	}
+
+	for (retries = 3; retries > 0; --retries) {
+		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+				   msecs_to_jiffies(30000), 3, 0, RQF_PM, NULL);
+		if (ret == 0)
+			break;
+	}
+
+	if (ret) {
+		if (driver_byte(ret) == DRIVER_SENSE &&
+		    scsi_sense_valid(&sshdr)) {
+			switch (sshdr.sense_key) {
+			case ILLEGAL_REQUEST:
+				hpb_err("ILLEGAL REQUEST asc=0x%x ascq=0x%x\n",
+					sshdr.asc, sshdr.ascq);
+				break;
+			default:
+				hpb_err("Unknown return code = %x\n", ret);
+				break;
+			}
+		}
+	}
+	scsi_device_put(sdp);
+
+	return ret;
+}
+
+static int ufshpb_add_bio_page(struct ufshpb_lu *hpb, struct request_queue *q,
+			       struct bio *bio, struct bio_vec *bvec,
+			       struct ufshpb_map_ctx *mctx)
+{
+	struct ufshpb_geo *geo;
+	struct page *page = NULL;
+	int i, ret = 0;
+
+	WARN_ON(!mctx);
+	WARN_ON(!bvec);
+
+	geo = &hpb->hba->hpb_geo;
+	bio_init(bio, bvec, geo->mpages_per_subregion);
+
+	for (i = 0; i < geo->mpages_per_subregion; i++) {
+		page = mctx->m_page[i];
+		if (!page)
+			return -ENOMEM;
+
+		ret = bio_add_pc_page(q, bio, page, geo->mpage_bytes, 0);
+
+		if (ret != geo->mpage_bytes) {
+			hpb_err("bio_add_pc_page() error with ret %d\n", ret);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static void ufshpb_req_init(struct ufshpb_lu *hpb,
+			    struct ufshpb_map_req *map_req,
+			    struct ufshpb_subregion *cp,
+			    __u64 start_t, __u64 workq_enter_t)
+{
+	map_req->hpb = hpb;
+	map_req->retry_cnt = 0;
+	map_req->region = cp->region;
+	map_req->subregion = cp->subregion;
+	map_req->mctx = cp->mctx;
+	map_req->lun = hpb->lun;
+	map_req->req = NULL;
+	memset(&map_req->bio, 0x00, sizeof(struct bio));
+
+	/* Follow parameters used by debug/profile */
+	map_req->req_start_t = start_t;
+	map_req->workq_enter_t = workq_enter_t;
+	map_req->req_issue_t = 0;
+}
+
+static int ufshpb_l2p_load_req(struct ufshpb_lu *hpb, struct request_queue *q,
+			       struct ufshpb_map_req *map_req)
+{
+	struct scsi_request *scsi_rq;
+	unsigned char cmd[16] = { };
+	struct request *req;
+	struct bio *bio;
+	int alloc_len;
+	int ret;
+
+	bio = &map_req->bio;
+
+	ret = ufshpb_add_bio_page(hpb, q, bio, map_req->bvec, map_req->mctx);
+	if (ret) {
+		hpb_err("ufshpb_add_bio_page() failed with ret %d\n", ret);
+		return ret;
+	}
+
+	alloc_len = hpb->hba->hpb_geo.subregion_entry_sz;
+	/*
+	 * HPB Sub-Regions are equally sized except for the last one which is
+	 * smaller if the last hpb Region is not an integer multiple of
+	 * bHPBSubRegionSize.
+	 */
+	if (map_req->region == (hpb->lu_region_cnt - 1) &&
+	    map_req->subregion == (hpb->subregions_in_last_region - 1))
+		alloc_len = hpb->last_subregion_entry_size;
+
+	ufshpb_prepare_read_buf_cmd(cmd, map_req->region, map_req->subregion,
+				    alloc_len);
+	if (!map_req->req) {
+		map_req->req = blk_get_request(q, REQ_OP_SCSI_IN, 0);
+		if (IS_ERR(map_req->req))
+			return PTR_ERR(map_req->req);
+	}
+	req = map_req->req;
+	scsi_rq = scsi_req(req);
+
+	blk_rq_append_bio(req, &bio);
+
+	scsi_req_init(scsi_rq);
+
+	scsi_rq->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(scsi_rq->cmd, cmd, scsi_rq->cmd_len);
+	req->timeout = msecs_to_jiffies(30000);
+	req->end_io_data = (void *)map_req;
+
+	hpb_dbg(SCHEDULE_INFO, hpb, "ISSUE READ_BUFFER : (%d-%d) retry = %d\n",
+		map_req->region, map_req->subregion, map_req->retry_cnt);
+	hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME, map_req->region,
+		  map_req->subregion);
+
+	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_l2p_load_req_done);
+	map_req->req_issue_t = ktime_to_ns(ktime_get());
+
+	atomic64_inc(&hpb->status.map_req_cnt);
+
+	return 0;
+}
+
+static int ufshpb_subregion_l2p_load(struct ufshpb_lu *hpb,
+				     struct ufshpb_subregion *cp,
+				     __u64 start_t, __u64 workq_enter_t)
+{
+	struct ufshpb_map_req *map_req;
+	struct request_queue *q;
+
+	spin_lock(&hpb->hpb_lock);
+	map_req = list_first_entry_or_null(&hpb->lh_map_req_free,
+					   struct ufshpb_map_req, list_map_req);
+	if (!map_req) {
+		hpb_dbg(FAILURE_INFO, hpb, "There is no free map_req\n");
+		spin_unlock(&hpb->hpb_lock);
+		return -ENOMEM;
+	}
+	list_del(&map_req->list_map_req);
+	spin_unlock(&hpb->hpb_lock);
+
+	ufshpb_req_init(hpb, map_req, cp, start_t, workq_enter_t);
+	q = hpb->hba->sdev_ufs_lu[hpb->lun]->request_queue;
+	return ufshpb_l2p_load_req(hpb, q, map_req);
+}
+
+/*
+ * Discard the active region mctx, return 0 on success.
+ * Note: hpb->hpb_lock (irq) should be held before calling this function
+ */
+static inline int ufshpb_region_mctx_discard(struct ufshpb_lu *hpb,
+					     struct ufshpb_region *cb)
+{
+	struct ufshpb_subregion *cp;
+	int subregion;
+
+	if (cb->region_state == REGION_PINNED) {
+		/*
+		 * The pinned active regions should not drop-out. But if so, it
+		 * would treat error as critical, and it will run ufshpb_eh_work
+		 */
+		hpb_warn("Trying to evict HPB pinned region\n");
+		return -ENOMEDIUM;
+	}
+
+	if (list_empty(&cb->list_region))
+		/* The region being evicted has been evicted */
+		return 0;
+
+	hpb_dbg(REGION_INFO, hpb,
+		"\x1b[41m\x1b[33m EVICT region: %d \x1b[0m", cb->region);
+	hpb_trace(hpb, "%s: EVIC RG: %d", DRIVER_NAME, cb->region);
+
+	ufshpb_cleanup_lru_info(hpb, cb);
+
+	atomic64_inc(&hpb->status.region_evict);
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		cp = cb->subregion_tbl + subregion;
+		ufshpb_subregion_mctx_purge(hpb, cp, SUBREGION_UNUSED);
+	}
+	return 0;
+}
+
+static int ufshpb_subregion_mctx_reserve(struct ufshpb_lu *hpb,
+					 struct ufshpb_subregion *cp)
+{
+	struct active_region_info *lru_info;
+	struct ufshpb_region *cb;
+	int victim_reg;
+	int ret;
+
+	lru_info = &hpb->lru_info;
+	cb = hpb->region_tbl + cp->region;
+
+	if (cp->mctx) {
+		ufshpb_hit_lru_info(lru_info, cb);
+		return 0;
+	}
+
+	if (cb->region_state == REGION_INACTIVE &&
+	    atomic64_read(&lru_info->active_cnt) >=
+	    lru_info->max_active_nor_regions) {
+		bool wb_cmnd_needed = false;
+
+		/*
+		 * if the number of active HPB Region is equal to the maximum
+		 * active regions supported by device, the host is expected to
+		 * issue a HPB WRITE BUFFER command to inactivate a region
+		 * before activating a new region
+		 */
+		if (hpb->hba->dev_info.hpb_control_mode == HPB_HOST_CTRL_MODE)
+			/*
+			 * For the HPB host control mode, discard HPB Entries of
+			 * active regions, in the meantime, we should deactivate
+			 * this reigon in UFS devive by issuing HPB WRITE BUFFER
+			 */
+			wb_cmnd_needed = true;
+
+		ret = ufshpb_evict_one_region(hpb, &victim_reg, wb_cmnd_needed);
+		if (ret)
+			return ret;
+	}
+
+	cp->mctx = ufshpb_mctx_get(hpb, &ret);
+	if (ret || !cp->mctx) {
+		hpb_dbg(FAILURE_INFO, hpb,
+			"Failed to get mctx for SRG %d, free mctxs %d",
+			cp->subregion, hpb->free_mctx_count);
+		return -ENOMEM;
+	}
+
+	if (list_empty(&cb->list_region)) {
+		ufshpb_add_lru_info(lru_info, cb);
+		atomic64_inc(&hpb->status.region_add);
+		hpb_dbg(REGION_INFO, hpb,
+			"\x1b[44m\x1b[32m Activate region: %d \x1b[0m",
+			cb->region);
+		hpb_trace(hpb, "%s: ACT RG: %d", DRIVER_NAME, cb->region);
+	} else {
+		ufshpb_hit_lru_info(lru_info, cb);
+	}
+
+	return 0;
+}
+
+/*
+ * Only in the device HPB control mode, the device shall send recommendations
+ * for inactivating active HPB Regions, which means that the related HPB entries
+ * in host side HPB memory are no longer valid. This funciton is just to discard
+ * all HPB entries of the regions indicated in HPB RSP from host side HPB memory
+ */
+static int ufshpb_inactive_rsp_handler(struct ufshpb_lu *hpb,
+				       struct ufshpb_rsp_info *rsp_info)
+{
+	struct ufshpb_region *cb;
+	int region;
+	int ret, i;
+
+	if (!rsp_info->inactive_cnt)
+		return 0;
+
+	spin_lock(&hpb->hpb_lock);
+	for (i = 0; i < rsp_info->inactive_cnt; i++) {
+		region = rsp_info->inactive_list.region[i];
+		cb = hpb->region_tbl + region;
+		ret = ufshpb_region_mctx_discard(hpb, cb);
+		if (ret)
+			break;
+	}
+	spin_unlock(&hpb->hpb_lock);
+	return ret;
+}
+
+static int ufshpb_active_rsp_handler(struct ufshpb_lu *hpb,
+				     struct ufshpb_rsp_info *rsp_info)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	int region, subregion;
+	int iter;
+	int ret;
+
+	for (iter = 0; iter < rsp_info->active_cnt; iter++) {
+		region = rsp_info->active_list.region[iter];
+		subregion = rsp_info->active_list.subregion[iter];
+		cb = hpb->region_tbl + region;
+
+		if (region >= hpb->lu_region_cnt ||
+		    subregion >= cb->subregion_count) {
+			hpb_err("RG_SRG (%d-%d) is wrong\n", region, subregion);
+			return -EINVAL;
+		}
+
+		cp = cb->subregion_tbl + subregion;
+
+		spin_lock(&hpb->hpb_lock);
+		if (cp->subregion_state == SUBREGION_ISSUED) {
+			hpb_dbg(SCHEDULE_INFO, hpb,
+				"RG_SRG (%d-%d) HPB BUFFER READ issued\n",
+				region, subregion);
+			spin_unlock(&hpb->hpb_lock);
+			continue;
+		}
+
+		switch (hpb->hba->dev_info.hpb_control_mode) {
+		case HPB_HOST_CTRL_MODE:
+			/*
+			 * In the HPB host control mode, we just dirty this
+			 * subregion
+			 */
+			ufshpb_subregion_dirty(hpb, cp);
+			spin_unlock(&hpb->hpb_lock);
+			continue;
+		case HPB_DEV_CTRL_MODE:
+			ret = ufshpb_subregion_mctx_reserve(hpb, cp);
+			if (ret)
+				goto out;
+			break;
+		default:
+			hpb_err("Unknown HPB control mode\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		cp->subregion_state = SUBREGION_ISSUED;
+
+		ret = ufshpb_subregion_dirty_bitmap_clean(hpb, cp);
+		spin_unlock(&hpb->hpb_lock);
+
+		if (ret)
+			continue;
+
+		if (hpb->force_map_req_disable) {
+			hpb_notice("map disable - return\n");
+			return 0;
+		}
+
+		ret = ufshpb_subregion_l2p_load(hpb, cp, rsp_info->rsp_start,
+						rsp_info->rsp_tasklet_enter);
+		if (ret) {
+			hpb_err("ufshpb_subregion_l2p_load failed ret %d\n",
+				ret);
+			return ret;
+		}
+	}
+	return 0;
+out:
+	spin_unlock(&hpb->hpb_lock);
+	return ret;
+}
+
+static void ufshpb_recommended_l2p_update(struct ufshpb_lu *hpb,
+					  struct ufshpb_rsp_info *rsp_info)
+{
+	int ret;
+
+	ret = ufshpb_inactive_rsp_handler(hpb, rsp_info);
+	if (ret) {
+		hpb_err("ufshpb_inactive_rsp_handler failed ret %d\n", ret);
+		goto wakeup_ee_worker;
+	}
+
+	ret = ufshpb_active_rsp_handler(hpb, rsp_info);
+	if (ret) {
+		hpb_err("ufshpb_active_rsp_handler failed\n");
+		goto wakeup_ee_worker;
+	}
+
+	return;
+wakeup_ee_worker:
+	hpb->hba->ufshpb_state = HPB_FAILED;
+	schedule_work(&hpb->hba->ufshpb_eh_work);
+}
+
+/*
+ * Note: hpb->hpb_lock (irq) should be held before calling this function
+ */
+static inline int ufshpb_subregion_sync_add(struct ufshpb_lu *hpb,
+					    struct ufshpb_subregion *cp)
+{
+	if (!cp->mctx)
+		return false;
+
+	hpb_dbg(REGION_INFO, hpb, "Add active RG %d, SRG %d state %d to sync\n",
+		cp->region, cp->subregion, cp->subregion_state);
+	list_add_tail(&cp->list_subregion, &hpb->lh_subregion_req);
+	cp->subregion_state = SUBREGION_ISSUED;
+
+	return true;
+}
+
+static int ufshpb_execute_req(struct ufshpb_lu *hpb, unsigned char *cmd,
+			      struct ufshpb_subregion *cp)
+{
+	struct ufs_hba *hba;
+	struct ufshpb_geo *geo;
+	struct request_queue *q;
+	struct request *req;
+	struct scsi_request *scsi_rq;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_device *sdp;
+	struct bio bio;
+	struct bio *bio_p = &bio;
+	struct bio_vec *bvec;
+	char sense[SCSI_SENSE_BUFFERSIZE];
+	unsigned long flags;
+	int ret = 0;
+
+	hba = hpb->hba;
+	geo = &hba->hpb_geo;
+
+	bvec = kvmalloc_array(geo->mpages_per_subregion, sizeof(struct bio_vec),
+			      GFP_KERNEL);
+	if (!bvec)
+		return -ENOMEM;
+
+	sdp = hba->sdev_ufs_lu[hpb->lun];
+	if (!sdp) {
+		hpb_warn("%s UFSHPB cannot find scsi_device\n", __func__);
+		ret = -ENODEV;
+		goto mem_free_out;
+	}
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ret = scsi_device_get(sdp);
+	if (!ret && !scsi_device_online(sdp)) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		ret = -ENODEV;
+		scsi_device_put(sdp);
+		goto mem_free_out;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	q = sdp->request_queue;
+
+	ret = ufshpb_add_bio_page(hpb, q, &bio, bvec, cp->mctx);
+	if (ret) {
+		scsi_device_put(sdp);
+		goto mem_free_out;
+	}
+
+	req = blk_get_request(q, REQ_OP_SCSI_IN, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	blk_rq_append_bio(req, &bio_p);
+
+	scsi_rq = scsi_req(req);
+	scsi_req_init(scsi_rq);
+
+	scsi_rq->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(scsi_rq->cmd, cmd, scsi_rq->cmd_len);
+
+	scsi_rq->sense = sense;
+	scsi_rq->sense_len = SCSI_SENSE_BUFFERSIZE;
+
+	scsi_rq->retries = 3;
+	req->timeout = msecs_to_jiffies(10000);
+
+	blk_execute_rq(q, NULL, req, 1);
+	if (scsi_rq->result) {
+		ret = scsi_rq->result;
+		scsi_normalize_sense(scsi_rq->sense, SCSI_SENSE_BUFFERSIZE,
+				     &sshdr);
+		hpb_err("code 0x%x sense_key 0x%x asc 0x%x ascq 0x%x\n",
+			sshdr.response_code, sshdr.sense_key, sshdr.asc,
+			sshdr.ascq);
+		hpb_err("byte4 0x%x byte5 0x%x byte6 0x%x att_len 0x%x\n",
+			sshdr.byte4, sshdr.byte5, sshdr.byte6,
+			sshdr.additional_length);
+		spin_lock_bh(&hpb->hpb_lock);
+		ufshpb_subregion_dirty(hpb, cp);
+		spin_unlock_bh(&hpb->hpb_lock);
+	} else {
+		ret = 0;
+		spin_lock_bh(&hpb->hpb_lock);
+		ufshpb_subregion_dirty_bitmap_clean(hpb, cp);
+		spin_unlock_bh(&hpb->hpb_lock);
+	}
+	scsi_device_put(sdp);
+	blk_put_request(req);
+mem_free_out:
+	kvfree(bvec);
+	return ret;
+}
+
+static int ufshpb_issue_map_req_from_list(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_subregion *cp, *next_cp;
+	struct ufshpb_geo *geo = &hpb->hba->hpb_geo;
+	int alloc_len;
+	int ret;
+
+	LIST_HEAD(req_list);
+
+	spin_lock_bh(&hpb->hpb_lock);
+	list_splice_init(&hpb->lh_subregion_req, &req_list);
+	spin_unlock_bh(&hpb->hpb_lock);
+
+	list_for_each_entry_safe(cp, next_cp, &req_list, list_subregion) {
+		unsigned char cmd[10] = { };
+
+		alloc_len = geo->subregion_entry_sz;
+		/*
+		 * HPB subregions are equally sized except for the last one
+		 * which is smaller if the last hpb region is not an integer
+		 * multiple of bHPBSubRegionSize.
+		 */
+		if (cp->region == (hpb->lu_region_cnt - 1) &&
+		    cp->subregion == (hpb->subregions_in_last_region - 1))
+			alloc_len = hpb->last_subregion_entry_size;
+
+		ufshpb_prepare_read_buf_cmd(cmd, cp->region, cp->subregion,
+					    alloc_len);
+
+		hpb_dbg(SCHEDULE_INFO, hpb,
+			"RG_SRG (%d-%d) HPB READ BUFFER issued\n", cp->region,
+			cp->subregion);
+
+		hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME, cp->region,
+			  cp->subregion);
+
+		ret = ufshpb_execute_req(hpb, cmd, cp);
+		if (ret < 0) {
+			hpb_err("RG_SRG (%d-%d) HPB READ BUFFER failed %d\n",
+				cp->region, cp->subregion, ret);
+			list_del_init(&cp->list_subregion);
+			continue;
+		}
+
+		hpb_trace(hpb, "%s: C RB %d - %d", DRIVER_NAME, cp->region,
+			  cp->subregion);
+
+		hpb_dbg(REGION_INFO, hpb,
+			"RG_SRG (%d-%d) HPB READ BUFFER COML\n", cp->region,
+			cp->subregion);
+
+		spin_lock_bh(&hpb->hpb_lock);
+		ufshpb_subregion_clean(hpb, cp);
+		list_del_init(&cp->list_subregion);
+		spin_unlock_bh(&hpb->hpb_lock);
+	}
+
+	return 0;
+}
+
+static void ufshpb_sync_workq_fn(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	int ret;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_sync_work);
+
+	if (!list_empty(&hpb->lh_subregion_req)) {
+		ret = ufshpb_issue_map_req_from_list(hpb);
+		if (ret)
+			hpb_err("Issue map_req failed with ret %d\n", ret);
+	}
+}
+
+static void ufshpb_req_workq_fn(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	struct ufshpb_req_info *req_info;
+
+	LIST_HEAD(req_list);
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_req_work);
+	spin_lock(&hpb->req_list_lock);
+	if (list_empty(&hpb->lh_req_info)) {
+		spin_unlock(&hpb->req_list_lock);
+		return;
+	}
+	list_splice_init(&hpb->lh_req_info, &req_list);
+	spin_unlock(&hpb->req_list_lock);
+
+	while (1) {
+		req_info = list_first_entry_or_null(&req_list,
+						    struct ufshpb_req_info,
+						    list_req_info);
+		if (!req_info) {
+			hpb_dbg(FAILURE_INFO, hpb, "req_info list is NULL\n");
+			break;
+		}
+
+		list_del(&req_info->list_req_info);
+
+		req_info->workq_enter_t = ktime_to_ns(ktime_get());
+
+		switch (req_info->type) {
+		case HPB_SUBREGION_ACTIVATE:
+			ufshpb_subregion_activate(hpb, req_info);
+			hpb_dbg(SCHEDULE_INFO, hpb,
+				"Activate RG_SRG (%d-%d) REQ issued\n",
+				req_info->region, req_info->subregion);
+			break;
+		case HPB_REGION_DEACTIVATE:
+			ufshpb_region_deactivate(hpb, req_info);
+			hpb_dbg(SCHEDULE_INFO, hpb,
+				"Deactivate RG_SRG (%d-%d) REQ done\n",
+				req_info->region, req_info->subregion);
+			break;
+		default:
+			break;
+		}
+
+		ufshpb_req_info_put(hpb, req_info);
+	}
+}
+
+static void ufshpb_retry_workq_fn(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ufshpb_map_req *map_req;
+	struct request_queue *q;
+	int ret = 0;
+
+	LIST_HEAD(retry_list);
+
+	hpb = container_of(dwork, struct ufshpb_lu, retry_work);
+	hpb_dbg(SCHEDULE_INFO, hpb, "Retry workq start\n");
+
+	spin_lock_bh(&hpb->hpb_lock);
+	list_splice_init(&hpb->lh_map_req_retry, &retry_list);
+	spin_unlock_bh(&hpb->hpb_lock);
+
+	while (1) {
+		map_req = list_first_entry_or_null(&retry_list,
+						   struct ufshpb_map_req,
+						   list_map_req);
+		if (!map_req) {
+			hpb_dbg(SCHEDULE_INFO, hpb, "There is no map_req\n");
+			break;
+		}
+		list_del(&map_req->list_map_req);
+
+		map_req->retry_cnt++;
+
+		q = hpb->hba->sdev_ufs_lu[hpb->lun]->request_queue;
+		ret = ufshpb_l2p_load_req(hpb, q, map_req);
+		if (ret) {
+			hpb_err("ufshpb_l2p_load_req error %d\n", ret);
+			goto wakeup_ee_worker;
+		}
+	}
+	hpb_dbg(SCHEDULE_INFO, hpb, "Retry workq end\n");
+	return;
+
+wakeup_ee_worker:
+	hpb->hba->ufshpb_state = HPB_FAILED;
+	schedule_work(&hpb->hba->ufshpb_eh_work);
+}
+
+static void ufshpb_rsp_workq_fn(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	struct ufshpb_rsp_info *rsp_info;
+	unsigned long flags;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_rsp_work);
+
+	while (1) {
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		rsp_info = list_first_entry_or_null(&hpb->lh_rsp_info,
+						    struct ufshpb_rsp_info,
+						    list_rsp_info);
+		if (!rsp_info) {
+			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+			break;
+		}
+
+		list_del_init(&rsp_info->list_rsp_info);
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+
+		rsp_info->rsp_tasklet_enter = ktime_to_ns(ktime_get());
+		switch (rsp_info->type) {
+		case HPB_REQ_REGION_UPDATE:
+			ufshpb_recommended_l2p_update(hpb, rsp_info);
+			break;
+		default:
+			hpb_warn("Unknown rsp_info type\n");
+			break;
+		}
+		ufshpb_rsp_info_put(hpb, rsp_info);
+	}
+}
+
+static int ufshpb_init_pinned_region(struct ufshpb_lu *hpb,
+				     struct ufshpb_region *cb)
+{
+	struct ufshpb_subregion *cp;
+	int subregion, j;
+	int err = 0;
+
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		cp = cb->subregion_tbl + subregion;
+
+		cp->mctx = ufshpb_mctx_get(hpb, &err);
+		if (err) {
+			hpb_err("Failed to get mctx for pinned SRG %d\n",
+				subregion);
+			goto release;
+		}
+		spin_lock_bh(&hpb->hpb_lock);
+		ufshpb_subregion_sync_add(hpb, cp);
+		spin_unlock_bh(&hpb->hpb_lock);
+	}
+
+	cb->region_state = REGION_PINNED;
+	return 0;
+
+release:
+	for (j = 0; j < subregion; j++) {
+		cp = cb->subregion_tbl + j;
+		ufshpb_mctx_put(hpb, cp->mctx);
+	}
+
+	return err;
+}
+
+static inline bool ufshpb_is_pinned_region(struct ufshpb_lu_desc *lu_desc,
+					   int region)
+{
+	if (lu_desc->lu_hpb_pinned_end_offset != -1 &&
+	    region >= lu_desc->hpb_pinned_region_startidx &&
+	    region <= lu_desc->lu_hpb_pinned_end_offset)
+		return true;
+
+	return false;
+}
+
+static inline void ufshpb_init_jobs(struct ufshpb_lu *hpb)
+{
+	INIT_WORK(&hpb->ufshpb_sync_work, ufshpb_sync_workq_fn);
+	INIT_WORK(&hpb->ufshpb_req_work, ufshpb_req_workq_fn);
+	INIT_DELAYED_WORK(&hpb->retry_work, ufshpb_retry_workq_fn);
+	INIT_WORK(&hpb->ufshpb_rsp_work, ufshpb_rsp_workq_fn);
+}
+
+static inline void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
+{
+	cancel_work_sync(&hpb->ufshpb_sync_work);
+	cancel_work_sync(&hpb->ufshpb_req_work);
+	cancel_delayed_work_sync(&hpb->retry_work);
+	cancel_work_sync(&hpb->ufshpb_rsp_work);
+}
+
+static void ufshpb_subregion_tbl_init(struct ufshpb_lu *hpb,
+				      struct ufshpb_region *cb)
+{
+	int subregion;
+
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		struct ufshpb_subregion *cp = cb->subregion_tbl + subregion;
+
+		cp->region = cb->region;
+		cp->subregion = subregion;
+		cp->subregion_state = SUBREGION_UNUSED;
+	}
+}
+
+static int ufshpb_subregion_tbl_alloc(struct ufshpb_lu *hpb,
+				      struct ufshpb_region *cb,
+				      int subregion_count)
+{
+	cb->subregion_tbl =
+		kcalloc(subregion_count, sizeof(struct ufshpb_subregion),
+			GFP_KERNEL);
+	if (!cb->subregion_tbl)
+		return -ENOMEM;
+
+	cb->subregion_count = subregion_count;
+
+	return 0;
+}
+
+static void ufshpb_mctx_mempool_remove(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_map_ctx *mctx, *next;
+	struct ufshpb_geo *geo;
+	int i;
+
+	geo = &hpb->hba->hpb_geo;
+	list_for_each_entry_safe(mctx, next, &hpb->lh_map_ctx, list_table) {
+		for (i = 0; i < geo->mpages_per_subregion; i++)
+			__free_page(mctx->m_page[i]);
+
+		kvfree(mctx->ppn_dirty);
+		kfree(mctx->m_page);
+		kfree(mctx);
+		hpb->lu_max_mctx_cnt--;
+	}
+
+	if (hpb->lu_max_mctx_cnt != 0)
+		hpb_warn("LU%d still remains mctx %d\n", hpb->lun,
+			 hpb->lu_max_mctx_cnt);
+	else
+		hpb_info("LU%d mctx has been released\n", hpb->lun);
+}
+
+static int ufshpb_mctx_mempool_init(struct ufshpb_lu *hpb, int num_regions,
+				    int subregions_per_region)
+{
+	int i;
+	struct ufshpb_geo *geo;
+	struct ufshpb_map_ctx *mctx = NULL;
+
+	INIT_LIST_HEAD(&hpb->lh_map_ctx);
+
+	for (i = 0; i < num_regions * subregions_per_region; i++) {
+		mctx = ufshpb_subregion_mctx_alloc(hpb);
+		if (!mctx)
+			return -ENOMEM;
+		INIT_LIST_HEAD(&mctx->list_table);
+		list_add(&mctx->list_table, &hpb->lh_map_ctx);
+		hpb->free_mctx_count++;
+	}
+
+	geo = &hpb->hba->hpb_geo;
+
+	hpb->lu_max_mctx_cnt = hpb->free_mctx_count;
+	hpb_info("LU%d mctx cnt %d, %d MiB\n", hpb->lun, hpb->free_mctx_count,
+		 (hpb->lu_max_mctx_cnt * geo->mpages_per_subregion *
+		 geo->mpage_bytes) / SZ_1M);
+	return 0;
+}
+
+static inline void ufshpb_map_req_remove(struct ufshpb_lu *hpb)
+{
+	int i;
+	struct ufshpb_map_req *map_req;
+
+	if (!hpb->map_req)
+		return;
+
+	for (i = 0; i < hpb->map_req_cnt; i++) {
+		map_req = hpb->map_req + i;
+		if (!map_req)
+			break;
+		kfree(map_req->bvec);
+	}
+	kfree(hpb->map_req);
+}
+
+static inline void ufshpb_req_mempool_remove(struct ufshpb_lu *hpb)
+{
+	kfree(hpb->rsp_info);
+	kfree(hpb->req_info);
+	ufshpb_map_req_remove(hpb);
+}
+
+static int ufshpb_req_mempool_init(struct ufshpb_lu *hpb, int pinned_regions,
+				   int queue_depth)
+{
+	struct ufs_hba *hba;
+	struct ufshpb_geo *geo;
+	struct ufshpb_rsp_info *rsp_info = NULL;
+	struct ufshpb_req_info *req_info = NULL;
+	struct ufshpb_map_req *map_req = NULL;
+	int i, map_req_cnt = 0;
+
+	hba = hpb->hba;
+	geo = &hba->hpb_geo;
+
+	if (!queue_depth) {
+		queue_depth = hba->nutrs;
+		hpb_info("LU%d own queue depth is 0, use shared Q-depth %d\n",
+			 hpb->lun, queue_depth);
+	}
+
+	INIT_LIST_HEAD(&hpb->lh_rsp_info);
+	INIT_LIST_HEAD(&hpb->lh_req_info);
+	INIT_LIST_HEAD(&hpb->lh_rsp_info_free);
+	INIT_LIST_HEAD(&hpb->lh_map_req_free);
+	INIT_LIST_HEAD(&hpb->lh_map_req_retry);
+	INIT_LIST_HEAD(&hpb->lh_req_info_free);
+
+	hpb->rsp_info = kcalloc(queue_depth, sizeof(struct ufshpb_rsp_info),
+				GFP_KERNEL);
+	if (!hpb->rsp_info)
+		goto out;
+
+	hpb->req_info = kcalloc(queue_depth, sizeof(struct ufshpb_req_info),
+				GFP_KERNEL);
+	if (!hpb->req_info)
+		goto out_free_rsp;
+
+	map_req_cnt = pinned_regions * geo->subregions_per_region + queue_depth;
+
+	hpb->map_req = kcalloc(map_req_cnt, sizeof(struct ufshpb_map_req),
+			       GFP_KERNEL);
+	if (!hpb->map_req)
+		goto out_free_req;
+	hpb->map_req_cnt = map_req_cnt;
+
+	for (i = 0; i < queue_depth; i++) {
+		rsp_info = hpb->rsp_info + i;
+		req_info = hpb->req_info + i;
+		INIT_LIST_HEAD(&rsp_info->list_rsp_info);
+		INIT_LIST_HEAD(&req_info->list_req_info);
+		list_add_tail(&rsp_info->list_rsp_info, &hpb->lh_rsp_info_free);
+		list_add_tail(&req_info->list_req_info, &hpb->lh_req_info_free);
+	}
+
+	for (i = 0; i < map_req_cnt; i++) {
+		map_req = hpb->map_req + i;
+		map_req->bvec = kcalloc(geo->mpages_per_subregion,
+					sizeof(struct bio_vec), GFP_KERNEL);
+		if (!map_req->bvec) {
+			int j;
+
+			for (j = 0; j < i; j++) {
+				map_req = hpb->map_req + j;
+				kfree(map_req->bvec);
+			}
+			goto out_free_req;
+		}
+		INIT_LIST_HEAD(&map_req->list_map_req);
+		list_add_tail(&map_req->list_map_req, &hpb->lh_map_req_free);
+	}
+
+	return 0;
+out_free_req:
+	kfree(hpb->req_info);
+out_free_rsp:
+	kfree(hpb->rsp_info);
+out:
+	return -ENOMEM;
+}
+
+static int ufshpb_region_subregion_table_alloc(struct ufshpb_lu *hpb,
+					       struct ufshpb_lu_desc *lu_desc)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_geo *geo;
+	int subregions, subregion_count;
+	int region;
+	bool do_sync_work;
+	int ret = 0;
+	int j;
+
+	WARN_ON(!hpb->lu_region_cnt);
+	WARN_ON(!hpb->lu_subregion_cnt);
+
+	geo = &hpb->hba->hpb_geo;
+	hpb->region_tbl = kcalloc(hpb->lu_region_cnt,
+				  sizeof(struct ufshpb_region), GFP_KERNEL);
+	if (!hpb->region_tbl)
+		return -ENOMEM;
+
+	subregion_count = 0;
+	subregions = hpb->lu_subregion_cnt;
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		cb = hpb->region_tbl + region;
+
+		/* Initialize logic subregion information */
+		INIT_LIST_HEAD(&cb->list_region);
+		cb->hit_count = 0;
+		cb->region = region;
+
+		subregion_count = min(subregions, geo->subregions_per_region);
+
+		ret = ufshpb_subregion_tbl_alloc(hpb, cb, subregion_count);
+		if (ret) {
+			hpb_err("Error while allocating subregion_tbl\n");
+			goto release_subregion_tbl;
+		}
+		ufshpb_subregion_tbl_init(hpb, cb);
+
+		if (ufshpb_is_pinned_region(lu_desc, region)) {
+			hpb_info("Region %d PINNED (%d ~ %d)\n", region,
+				 lu_desc->hpb_pinned_region_startidx,
+				 lu_desc->lu_hpb_pinned_end_offset);
+			ret = ufshpb_init_pinned_region(hpb, cb);
+			if (ret)
+				goto release_subregion_tbl;
+
+			do_sync_work = true;
+		} else {
+			cb->region_state = REGION_INACTIVE;
+		}
+
+		subregions -= subregion_count;
+	}
+
+	if (subregions != 0) {
+		hpb_err("Error, remaining %d subregions aren't initializd\n",
+			subregions);
+		goto release_subregion_tbl;
+	}
+
+	hpb_info("LU%d region_tbl size: %lu bytes\n", hpb->lun,
+		 (unsigned long)(sizeof(struct ufshpb_region) *
+				 hpb->lu_region_cnt));
+	hpb_info("LU%d subregion_tbl size: %lu bytes\n", hpb->lun,
+		 (unsigned long)(sizeof(struct ufshpb_subregion) *
+				 hpb->lu_subregion_cnt));
+
+	if (do_sync_work)
+		schedule_work(&hpb->ufshpb_sync_work);
+
+	return 0;
+
+release_subregion_tbl:
+	for (j = 0; j < region; j++) {
+		cb = hpb->region_tbl + j;
+		ufshpb_destroy_subregion_tbl(hpb, cb);
+	}
+	kfree(hpb->region_tbl);
+	return -ENOMEM;
+}
+
+static int ufshpb_lu_init(struct ufs_hba *hba, struct ufshpb_lu *hpb,
+			  struct ufshpb_lu_desc *lu_desc, int lun)
+{
+	int ret = 0;
+	struct ufshpb_geo *geo = &hba->hpb_geo;
+
+	hpb->hba = hba;
+	hpb->lun = lun;
+	hpb->debug = 0;
+	hpb->lu_hpb_enable = true;
+
+	ufshpb_init_lu_constant(hpb, lu_desc);
+
+	if (hpb->lu_max_active_regions <= hpb->lu_pinned_regions) {
+		hpb_err("LU%d configuration is invalid\n", lun);
+		return -EINVAL;
+	}
+
+	spin_lock_init(&hpb->hpb_lock);
+	spin_lock_init(&hpb->rsp_list_lock);
+	spin_lock_init(&hpb->req_list_lock);
+
+	/* Initialize loacl active region info lru */
+	INIT_LIST_HEAD(&hpb->lru_info.lru);
+	hpb->lru_info.selection_type = LRU;
+	/* Set maximum active normal regions supported */
+	hpb->lru_info.max_active_nor_regions = hpb->lu_max_active_regions -
+						hpb->lu_pinned_regions;
+	INIT_LIST_HEAD(&hpb->lh_subregion_req);
+
+	/* Allocate HPB memory for L2P entries */
+	ret = ufshpb_mctx_mempool_init(hpb, hpb->lu_max_active_regions,
+				       geo->subregions_per_region);
+	if (ret) {
+		hpb_err("HPB mapping ctx mempool init failed!\n");
+		goto release_mempool;
+	}
+
+	ret = ufshpb_req_mempool_init(hpb, lu_desc->lu_num_hpb_pinned_regions,
+				      lu_desc->lu_queue_depth);
+	if (ret) {
+		hpb_err("req/rsp info mempool init failed!\n");
+		goto release_mempool;
+	}
+
+	ufshpb_init_jobs(hpb);
+
+	hpb->read_threshold = HPB_DEF_READ_THREASHOLD;
+
+	ret = ufshpb_region_subregion_table_alloc(hpb, lu_desc);
+	if (ret) {
+		hpb_err("region/subregion table alloc failed!\n");
+		goto release_mempool;
+	}
+
+	/*
+	 * Even if creating sysfs failed, ufshpb could run normally. so we don't
+	 * deal with error handling
+	 */
+	ufshpb_create_sysfs(hba, hpb);
+	return 0;
+
+release_mempool:
+	ufshpb_req_mempool_remove(hpb);
+	ufshpb_mctx_mempool_remove(hpb);
+	hpb->lu_hpb_enable = false;
+	return ret;
+}
+
+static int ufshpb_get_hpb_lu_desc(struct ufs_hba *hba,
+				  struct ufshpb_lu_desc *lu_desc, int lun)
+{
+	int ret;
+	u8 buf[QUERY_DESC_MAX_SIZE] = { };
+
+	ret = ufshcd_read_unit_desc_param(hba, lun, 0, buf,
+					  QUERY_DESC_MAX_SIZE);
+	if (ret) {
+		hpb_err("Read unit desc failed with ret %d\n", ret);
+		return ret;
+	}
+
+	if (buf[UNIT_DESC_PARAM_LU_ENABLE] == 0x02) {
+		lu_desc->lu_hpb_enable = true;
+		hpb_info("LU%d HPB is enabled\n", lun);
+	} else {
+		lu_desc->lu_hpb_enable = false;
+		return 0;
+	}
+
+	lu_desc->lu_queue_depth = buf[UNIT_DESC_PARAM_LU_Q_DEPTH];
+
+	lu_desc->lu_logblk_size = buf[UNIT_DESC_PARAM_LOGICAL_BLK_SIZE];
+	lu_desc->lu_logblk_cnt =
+		SHIFT_BYTE_7((u64)buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT]) |
+		SHIFT_BYTE_6((u64)buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT + 1]) |
+		SHIFT_BYTE_5((u64)buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT + 2]) |
+		SHIFT_BYTE_4((u64)buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT + 3]) |
+		SHIFT_BYTE_3(buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT + 4]) |
+		SHIFT_BYTE_2(buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT + 5]) |
+		SHIFT_BYTE_1(buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT + 6]) |
+		SHIFT_BYTE_0(buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT + 7]);
+
+	lu_desc->lu_max_active_hpb_regions =
+		SHIFT_BYTE_1(buf[UNIT_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS]) |
+		SHIFT_BYTE_0(buf[UNIT_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS + 1]);
+	lu_desc->hpb_pinned_region_startidx =
+		SHIFT_BYTE_1(buf[UNIT_DESC_PARAM_HPB_PIN_REGION_START_OFFSET]) |
+		SHIFT_BYTE_0(buf[UNIT_DESC_PARAM_HPB_PIN_REGION_START_OFFSET + 1]);
+	lu_desc->lu_num_hpb_pinned_regions =
+		SHIFT_BYTE_1(buf[UNIT_DESC_PARAM_HPB_NUM_PIN_REGIONS]) |
+		SHIFT_BYTE_0(buf[UNIT_DESC_PARAM_HPB_NUM_PIN_REGIONS + 1]);
+
+	hpb_info("LU%d bLogicalBlockSize %d\n", lun, lu_desc->lu_logblk_size);
+	hpb_info("LU%d wLUMaxActiveHPBRegions %d\n", lun,
+		 lu_desc->lu_max_active_hpb_regions);
+	hpb_info("LU%d wHPBPinnedRegionStartIdx %d\n", lun,
+		 lu_desc->hpb_pinned_region_startidx);
+	hpb_info("LU%d wNumHPBPinnedRegions %d\n", lun,
+		 lu_desc->lu_num_hpb_pinned_regions);
+
+	if (lu_desc->lu_num_hpb_pinned_regions > 0) {
+		lu_desc->lu_hpb_pinned_end_offset =
+			lu_desc->hpb_pinned_region_startidx +
+			lu_desc->lu_num_hpb_pinned_regions - 1;
+		hpb_info("LU%d PINNED regions:  %d -  %d\n", lun,
+			 lu_desc->hpb_pinned_region_startidx,
+			 lu_desc->lu_hpb_pinned_end_offset);
+	} else {
+		lu_desc->lu_hpb_pinned_end_offset = -1;
+	}
+
+	return 0;
+}
+
+static int ufshpb_read_geo_desc_support(struct ufs_hba *hba,
+					struct ufshpb_geo_desc *desc)
+{
+	int err;
+	u8 *geo_buf;
+	size_t buff_len;
+
+	buff_len = 0xff; //hba->desc_size.geom_desc;
+	geo_buf = kmalloc(buff_len, GFP_KERNEL);
+	if (!geo_buf) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_GEOMETRY, 0, 0,
+				     geo_buf, buff_len);
+	if (err) {
+		hpb_err("%s: Failed reading Device Geometry Desc. err = %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	desc->hpb_region_size = geo_buf[GEOMETRY_DESC_PARAM_HPB_REGION_SIZE];
+	desc->hpb_number_lu = geo_buf[GEOMETRY_DESC_PARAM_HPB_NUMBER_LU];
+	desc->hpb_subregion_size =
+		geo_buf[GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE];
+	desc->hpb_dev_max_active_regions =
+		(u16)SHIFT_BYTE_1(geo_buf[GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS]) |
+		(u16)SHIFT_BYTE_0(geo_buf[GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS + 1]);
+
+	if (desc->hpb_number_lu == 0) {
+		hpb_warn("There is no LU which supports HPB\n");
+		err = -ENODEV;
+	}
+out:
+	kfree(geo_buf);
+
+	return err;
+}
+
+static void ufshpb_error_handler(struct work_struct *work)
+{
+	struct ufs_hba *hba;
+
+	hba = container_of(work, struct ufs_hba, ufshpb_eh_work);
+	/*
+	 * So far, we don't have a optimal restoring solution，
+	 * in case of fatal error happenning, current soltion is that
+	 * simply kills HPB, in order to not impact normal read.
+	 */
+
+	ufshpb_release(hba, HPB_FAILED);
+	hpb_warn("UFSHPB driver has failed, UFSHCD will run without HPB\n");
+}
+
+static void ufshpb_max_mem_setup(struct ufs_hba *hba)
+{
+	struct ufshpb_geo *geo = &hba->hpb_geo;
+	int preferred_mem_mib = HPB_MAX_MEM_SIZE_MB;
+	u64 region_l2p_mem;
+	int max_regions, min_regions;
+
+	if (!preferred_mem_mib)
+		/* If there is no HPB maximum memory limitation, HPB driver will
+		 * allocate HPB memory for each HPB LU according to each HPB LU
+		 * wLUMaxActiveHPBRegions. The total HPB memory allocatd willn't
+		 * be higher than what calculated by this formula:
+		 *  (bHPBRegionSize(in KB)/4KB)*8*wDeviceMaxActiveHPBRegions
+		 */
+		return;
+
+	/* Calculate how many regions can be activated based on the
+	 * preferred_mem_mib
+	 */
+	region_l2p_mem = (u64)geo->mpages_per_subregion * geo->mpage_bytes *
+		geo->subregions_per_region;
+	max_regions = (u64)(preferred_mem_mib * SZ_1M) / region_l2p_mem;
+
+	min_regions = min(max_regions, geo->dev_max_active_regions);
+	geo->dev_max_active_regions = min_regions;
+
+	hpb_info("Maximum HPB memory %d MiB, Maximum dev active regions %d\n",
+		 preferred_mem_mib, geo->dev_max_active_regions);
+}
+
+static int ufshpb_exec_init(struct ufs_hba *hba)
+{
+	struct ufshpb_geo_desc geo_desc;
+	int lun, i, ret = 1, hpb_dev = 0;
+	int region_balance;
+
+	if (!(hba->dev_info.ufs_features & UFS_FEATURE_SUPPORT_HPB_BIT))
+		goto out;
+
+	ret = ufshpb_read_geo_desc_support(hba, &geo_desc);
+	if (ret)
+		goto out;
+
+	ufshpb_init_constant(hba, &geo_desc);
+
+	ufshpb_max_mem_setup(hba);
+	region_balance = hba->hpb_geo.dev_max_active_regions;
+
+	for (lun = 0; lun < hba->dev_info.max_lu_supported; lun++) {
+		struct ufshpb_lu_desc lu_desc;
+
+		if (!region_balance)
+			break;
+
+		hba->ufshpb_lup[lun] = NULL;
+
+		ret = ufshpb_get_hpb_lu_desc(hba, &lu_desc, lun);
+		if (ret)
+			break;
+
+		if (!lu_desc.lu_hpb_enable)
+			continue;
+
+		hba->ufshpb_lup[lun] =
+			kzalloc(sizeof(struct ufshpb_lu), GFP_KERNEL);
+		if (!hba->ufshpb_lup[lun])
+			break;
+
+		if (region_balance < lu_desc.lu_max_active_hpb_regions)
+			lu_desc.lu_max_active_hpb_regions = region_balance;
+
+		ret = ufshpb_lu_init(hba, hba->ufshpb_lup[lun], &lu_desc, lun);
+		if (ret) {
+			kfree(hba->ufshpb_lup[lun]);
+			break;
+		}
+		hpb_dev++;
+		region_balance -= lu_desc.lu_max_active_hpb_regions;
+
+		hpb_info("LU%d HPB is working now\n", lun);
+	}
+
+	if (hpb_dev == 0) {
+		hpb_info("No UFS HPB is present\n");
+		ret = -ENODEV;
+		goto out_free_mem;
+	}
+
+	INIT_WORK(&hba->ufshpb_eh_work, ufshpb_error_handler);
+	hba->ufshpb_state = HPB_PRESENT;
+
+	return 0;
+
+out_free_mem:
+	for (i = 0; i < lun; i++)
+		kfree(hba->ufshpb_lup[i]);
+out:
+	hba->ufshpb_state = HPB_NOT_SUPPORTED;
+	return ret;
+}
+
+/*
+ * Reload subregions of the active/pinned regions
+ */
+static void ufshpb_reload_active_region(struct ufshpb_lu *hpb, bool only_pinned)
+{
+	int region, subregion;
+	bool do_sync_work = false;
+
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		struct ufshpb_region *cb;
+		struct ufshpb_subregion *cp;
+
+		cb = hpb->region_tbl + region;
+
+		if (cb->region_state != REGION_ACTIVE &&
+		    cb->region_state != REGION_PINNED)
+			continue;
+
+		if ((only_pinned && cb->region_state == REGION_PINNED) ||
+		    !only_pinned) {
+			spin_lock_bh(&hpb->hpb_lock);
+			for (subregion = 0; subregion < cb->subregion_count;
+			     subregion++) {
+				cp = cb->subregion_tbl + subregion;
+				if (ufshpb_subregion_sync_add(hpb, cp))
+					do_sync_work = true;
+			}
+			spin_unlock_bh(&hpb->hpb_lock);
+		}
+	}
+
+	if (do_sync_work)
+		schedule_work(&hpb->ufshpb_sync_work);
+}
+
+static void ufshpb_purge_active_region(struct ufshpb_lu *hpb)
+{
+	int region, subregion, state;
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+
+	spin_lock_bh(&hpb->hpb_lock);
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		cb = hpb->region_tbl + region;
+
+		if (cb->region_state == REGION_INACTIVE) {
+			hpb_dbg(REGION_INFO, hpb, "region %d is inactive\n",
+				region);
+			continue;
+		}
+		if (cb->region_state == REGION_PINNED) {
+			state = SUBREGION_DIRTY;
+		} else if (cb->region_state == REGION_ACTIVE) {
+			state = SUBREGION_UNUSED;
+			ufshpb_cleanup_lru_info(hpb, cb);
+		} else {
+			hpb_notice("Unsupported region state %d\n",
+				   cb->region_state);
+			continue;
+		}
+
+		for (subregion = 0; subregion < cb->subregion_count;
+		     subregion++) {
+			cp = cb->subregion_tbl + subregion;
+			ufshpb_subregion_mctx_purge(hpb, cp, state);
+		}
+	}
+	spin_unlock_bh(&hpb->hpb_lock);
+}
+
+static void ufshpb_retrieve_rsp_info(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_rsp_info *rsp_info;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		rsp_info = list_first_entry_or_null(&hpb->lh_rsp_info,
+						    struct ufshpb_rsp_info,
+						    list_rsp_info);
+		if (!rsp_info) {
+			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+			break;
+		}
+
+		list_move_tail(&rsp_info->list_rsp_info,
+			       &hpb->lh_rsp_info_free);
+
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+	}
+}
+
+static void ufshpb_retrieve_req_info(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req_info *req_info;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&hpb->req_list_lock, flags);
+		req_info = list_first_entry_or_null(&hpb->lh_req_info,
+						    struct ufshpb_req_info,
+						    list_req_info);
+		if (!req_info) {
+			spin_unlock_irqrestore(&hpb->req_list_lock, flags);
+			break;
+		}
+
+		list_move_tail(&req_info->list_req_info,
+			       &hpb->lh_req_info_free);
+
+		spin_unlock_irqrestore(&hpb->req_list_lock, flags);
+	}
+}
+
+static void ufshpb_reset(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+	int lu;
+
+	for (lu = 0; lu < hba->dev_info.max_lu_supported; lu++) {
+		hpb = hba->ufshpb_lup[lu];
+
+		if (hpb && hpb->lu_hpb_enable) {
+			hpb_notice("LU%d HPB RESET\n", lu);
+
+			ufshpb_cancel_jobs(hpb);
+			ufshpb_retrieve_rsp_info(hpb);
+			ufshpb_retrieve_req_info(hpb);
+			ufshpb_purge_active_region(hpb);
+			/* FIXME add hpb reset */
+			ufshpb_init_jobs(hpb);
+		}
+	}
+
+	hba->ufshpb_state = HPB_PRESENT;
+}
+
+static void ufshpb_destroy_subregion_tbl(struct ufshpb_lu *hpb,
+					 struct ufshpb_region *cb)
+{
+	int subregion;
+
+	if (!cb->subregion_tbl)
+		return;
+
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		struct ufshpb_subregion *cp;
+
+		cp = cb->subregion_tbl + subregion;
+
+		hpb_info("Subregion %d-> %p state %d mctx-> %p released\n",
+			 subregion, cp, cp->subregion_state, cp->mctx);
+
+		cp->subregion_state = SUBREGION_UNUSED;
+		if (cp->mctx)
+			ufshpb_mctx_put(hpb, cp->mctx);
+	}
+
+	kfree(cb->subregion_tbl);
+}
+
+static void ufshpb_destroy_region_tbl(struct ufshpb_lu *hpb)
+{
+	int region;
+
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		struct ufshpb_region *cb;
+
+		cb = hpb->region_tbl + region;
+		hpb_info("LU%d free sub/region %d tbl, state %d\n", hpb->lun,
+			 region, cb->region_state);
+
+		if (cb->region_state == REGION_PINNED ||
+		    cb->region_state == REGION_ACTIVE) {
+			cb->region_state = REGION_INACTIVE;
+
+			ufshpb_destroy_subregion_tbl(hpb, cb);
+		}
+	}
+
+	kfree(hpb->region_tbl);
+}
+
+static int ufshpb_sense_data_checkup(struct ufs_hba *hba,
+				     struct hpb_sense_data *sense_data)
+{
+	if ((SHIFT_BYTE_1(sense_data->len[0]) |
+	     SHIFT_BYTE_0(sense_data->len[1])) != HPB_SENSE_DATA_LEN ||
+	    sense_data->desc_type != HPB_DESCRIPTOR_TYPE ||
+	    sense_data->additional_len != HPB_ADDITIONAL_LEN ||
+	    sense_data->hpb_op == HPB_RSP_NONE ||
+	    sense_data->active_region_cnt > MAX_ACTIVE_NUM ||
+	    sense_data->inactive_region_cnt > MAX_INACTIVE_NUM) {
+		hpb_err("HPB Sense Data Error\n");
+		hpb_err("Sense Data Length (12h): 0x%x\n",
+			SHIFT_BYTE_1(sense_data->len[0]) |
+			SHIFT_BYTE_0(sense_data->len[1]));
+		hpb_err("Descriptor Type: 0x%x\n", sense_data->desc_type);
+		hpb_err("Additional Len: 0x%x\n", sense_data->additional_len);
+		hpb_err("HPB Operation: 0x%x\n", sense_data->hpb_op);
+		hpb_err("Active HPB Count: 0x%x\n",
+			sense_data->active_region_cnt);
+		hpb_err("Inactive HPB Count: 0x%x\n",
+			sense_data->inactive_region_cnt);
+		return false;
+	}
+	return true;
+}
+
+static void ufshpb_init_workq_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ufs_hba *hba;
+	int err;
+#if defined(CONFIG_SCSI_SCAN_ASYNC)
+	unsigned long flags;
+#endif
+
+	hba = container_of(dwork, struct ufs_hba, ufshpb_init_work);
+
+#if defined(CONFIG_SCSI_SCAN_ASYNC)
+	mutex_lock(&hba->host->scan_mutex);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->host->async_scan == 1) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		mutex_unlock(&hba->host->scan_mutex);
+		hpb_info("Not set scsi-device-info, so re-sched.\n");
+		schedule_delayed_work(&hba->ufshpb_init_work,
+				      msecs_to_jiffies(100));
+		return;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	mutex_unlock(&hba->host->scan_mutex);
+#endif
+
+	switch (hba->ufshpb_state) {
+	case HPB_NEED_INIT:
+		err = ufshpb_exec_init(hba);
+		if (err)
+			hpb_warn("%s failed, err %d, UFS runs without HPB\n",
+				 __func__, err);
+		break;
+	case HPB_NEED_RESET:
+		ufshpb_reset(hba);
+		break;
+	default:
+		hpb_warn("Unkonwn HPB state\n");
+		break;
+	}
+}
+
+void ufshpb_init(struct ufs_hba *hba)
+{
+	hba->ufshpb_state = HPB_NEED_INIT;
+	INIT_DELAYED_WORK(&hba->ufshpb_init_work, ufshpb_init_workq_fn);
+}
+
+void ufshpb_release(struct ufs_hba *hba, enum UFSHPB_STATE state)
+{
+	int lun;
+	struct ufshpb_lu *hpb;
+
+	hba->ufshpb_state = HPB_FAILED;
+
+	for (lun = 0; lun < hba->dev_info.max_lu_supported; lun++) {
+		hpb = hba->ufshpb_lup[lun];
+
+		if (!hpb)
+			continue;
+
+		if (!hpb->lu_hpb_enable)
+			continue;
+
+		hpb_notice("LU%d HPB will be released\n", lun);
+
+		hba->ufshpb_lup[lun] = NULL;
+
+		hpb->lu_hpb_enable = false;
+
+		ufshpb_cancel_jobs(hpb);
+
+		ufshpb_destroy_region_tbl(hpb);
+
+		ufshpb_req_mempool_remove(hpb);
+
+		ufshpb_mctx_mempool_remove(hpb);
+
+		kobject_uevent(&hpb->kobj, KOBJ_REMOVE);
+		kobject_del(&hpb->kobj);
+
+		kfree(hpb);
+	}
+
+	hba->ufshpb_state = state;
+}
+
+void ufshpb_rsp_handler(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct ufshpb_lu *hpb;
+	struct hpb_sense_data *sense_data;
+	struct ufshpb_rsp_info *rsp_info;
+	int data_seg_len;
+
+	if (hba->ufshpb_state != HPB_PRESENT)
+		return;
+
+	if (!lrbp || !lrbp->ucd_rsp_ptr)
+		return;
+
+	/* Well Known LU doesn't support HPB */
+	if (lrbp->lun >= hba->dev_info.max_lu_supported)
+		return;
+
+	data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
+		       & MASK_RSP_UPIU_DATA_SEG_LEN;
+	/* FIXME Add Device informaiton checkup bit 1: HPB_UPDATE_ALERT = 1 */
+	if (!data_seg_len) {
+		bool do_tasklet = false;
+
+		hpb = hba->ufshpb_lup[lrbp->lun];
+		if (!hpb)
+			return;
+		/*
+		 * No recommmended region in response, but we still have
+		 * recommmended region to enactive in list lh_rsp_info.
+		 */
+		spin_lock(&hpb->rsp_list_lock);
+		do_tasklet = !list_empty(&hpb->lh_rsp_info);
+		spin_unlock(&hpb->rsp_list_lock);
+
+		if (do_tasklet)
+			schedule_work(&hpb->ufshpb_rsp_work);
+		return;
+	}
+
+	sense_data = ufshpb_get_sense_data(lrbp);
+
+	WARN_ON(!sense_data);
+
+	if (!ufshpb_sense_data_checkup(hba, sense_data))
+		return;
+
+	hpb = hba->ufshpb_lup[lrbp->lun];
+	if (!hpb) {
+		hpb_warn("%s LU%d didn't allocated HPB\n", __func__, lrbp->lun);
+		return;
+	}
+
+	hpb_dbg(REGION_INFO, hpb,
+		"RSP UPIU for LU%d: HPB OP %d, Data Len 0x%x\n",
+		sense_data->lun,  sense_data->hpb_op, data_seg_len);
+
+	atomic64_inc(&hpb->status.rb_noti_cnt);
+
+	if (!hpb->lu_hpb_enable) {
+		hpb_warn("LU%d HPB has been disabled.\n", lrbp->lun);
+		return;
+	}
+
+	rsp_info = ufshpb_rsp_info_get(hpb);
+	if (!rsp_info) {
+		hpb_warn("%s:%d There is no free rsp_info\n", __func__,
+			 __LINE__);
+		return;
+	}
+
+	switch (sense_data->hpb_op) {
+	case HPB_REQ_REGION_UPDATE:
+		WARN_ON(data_seg_len != HPB_DATA_SEG_LEN);
+		ufshpb_rsp_info_fill(hpb, rsp_info, sense_data);
+
+		hpb_trace(hpb, "%s: #ACT %d, #INACT %d", DRIVER_NAME,
+			  rsp_info->active_cnt, rsp_info->inactive_cnt);
+
+		spin_lock(&hpb->rsp_list_lock);
+		list_add_tail(&rsp_info->list_rsp_info, &hpb->lh_rsp_info);
+		spin_unlock(&hpb->rsp_list_lock);
+
+		schedule_work(&hpb->ufshpb_rsp_work);
+		break;
+
+	default:
+		hpb_warn("HPB Operation %d is not supported\n",
+			 sense_data->hpb_op);
+		break;
+	}
+}
+
+void ufshpb_prep_fn(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct request *rq;
+	struct ufshpb_lu *hpb;
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	unsigned long long ppn = 0;
+	unsigned long long rq_pos;
+	unsigned int rq_sectors;
+	unsigned int lpn;
+	int region, subregion, subregion_offset;
+	int blk_cnt = 1;
+
+	/* WKLU doesn't support HPB */
+	if (!lrbp || lrbp->lun >= hba->dev_info.max_lu_supported)
+		return;
+
+	hpb = hba->ufshpb_lup[lrbp->lun];
+	if (!hpb)
+		return;
+
+	/* If HPB has been disabled or not enabled yet */
+	if (!hpb->lu_hpb_enable || hpb->force_disable)
+		return;
+	/*
+	 * Convert sector address(in 512B unit) to block address (in 4KB unit),
+	 * since minimum Logical block size supported by HPB is 4KB.
+	 */
+	rq = lrbp->cmd->request;
+	rq_pos = blk_rq_pos(rq);
+	rq_sectors = blk_rq_sectors(rq);
+	lpn = rq_pos / SECTORS_PER_BLOCK;
+
+	/* Get region, subregion and offset according to page address */
+	ufshpb_get_pos_from_lpn(hpb, lpn, &region, &subregion,
+				&subregion_offset);
+	cb = hpb->region_tbl + region;
+
+	/*
+	 * For the host control mode, we need to watch out for the write/discard
+	 * request.
+	 */
+	if (hba->dev_info.hpb_control_mode == HPB_HOST_CTRL_MODE &&
+	    ufshpb_is_write_discard_lrbp(lrbp)) {
+		spin_lock_bh(&hpb->hpb_lock);
+
+		if (cb->region_state == REGION_INACTIVE) {
+			spin_unlock_bh(&hpb->hpb_lock);
+			return;
+		}
+		ufshpb_l2p_entry_dirty_set(hpb, rq_sectors, region, subregion,
+					   subregion_offset);
+		spin_unlock_bh(&hpb->hpb_lock);
+		return;
+	}
+
+	/* Check if it is the read cmd */
+	if (!ufshpb_is_read_lrbp(lrbp))
+		return;
+
+	cp = cb->subregion_tbl + subregion;
+
+	spin_lock_bh(&hpb->hpb_lock);
+
+	if (!ufshpb_subregion_is_clean(hpb, cp)) {
+		if (hba->dev_info.hpb_control_mode == HPB_HOST_CTRL_MODE &&
+		    cp->subregion_state != SUBREGION_REGISTERED &&
+		    cp->subregion_state != SUBREGION_ISSUED) {
+			/*
+			 * If this subregion is dirty or inactive, meanwhile,
+			 * it hasn't been added to activate_list, for the
+			 * host control mode, we need to increase its
+			 * read_counter and wake up req_workq in case of
+			 * read_counter reachs read_threshold
+			 */
+			if (atomic_read(&cp->read_counter) < 0xffffffff)
+				atomic_inc(&cp->read_counter);
+
+			if (atomic_read(&cp->read_counter) >=
+			    hpb->read_threshold)
+				ufshpb_subregion_register(hpb, cp);
+		}
+		spin_unlock_bh(&hpb->hpb_lock);
+
+		if (!list_empty(&hpb->lh_req_info)) {
+			hpb_dbg(SCHEDULE_INFO, hpb,
+				"Schedule req_workq to activate RG_SRG %d:%d\n",
+				cp->region, cp->subregion);
+			schedule_work(&hpb->ufshpb_req_work);
+		}
+		return;
+	}
+
+	if (ufshpb_blocksize_is_supported(hpb, rq_sectors) != true) {
+		spin_unlock_bh(&hpb->hpb_lock);
+		return;
+	}
+
+	if (ufshpb_l2p_entry_dirty_check(hpb, cp, subregion_offset)) {
+		atomic64_inc(&hpb->status.entry_dirty_miss);
+		hpb_dbg(REGION_INFO, hpb, "0x%llx + %u HPB PPN Dirty %d - %d\n",
+			rq_pos, rq_sectors, region, subregion);
+		spin_unlock_bh(&hpb->hpb_lock);
+		return;
+	}
+
+	ppn = ufshpb_get_ppn(cp->mctx, subregion_offset);
+
+	if (cb->subregion_count == 1)
+		ufshpb_hit_lru_info(&hpb->lru_info, cb);
+
+	spin_unlock_bh(&hpb->hpb_lock);
+
+	if (rq_sectors != SECTORS_PER_BLOCK) {
+		int remainder;
+
+		remainder = rq_sectors % SECTORS_PER_BLOCK;
+		blk_cnt = rq_sectors / SECTORS_PER_BLOCK;
+		if (remainder)
+			blk_cnt += 1;
+		hpb_dbg(NORMAL_INFO, hpb,
+			"Read %d blks (%d sects) from 0x%llx, %d: %d\n",
+			blk_cnt, rq_sectors, rq_pos, region, subregion);
+	}
+
+	ufshpb_prepare_hpb_read(hpb, lrbp, ppn, blk_cnt);
+	hpb_trace(hpb, "%s: %llu + %u HPB READ %d - %d", DRIVER_NAME, rq_pos,
+		  rq_sectors, region, subregion);
+	hpb_dbg(NORMAL_INFO, hpb,
+		"PPN: 0x%llx, LA: 0x%llx + %u HPB READ from RG %d - SRG %d",
+		ppn, rq_pos, rq_sectors, region, subregion);
+	atomic64_inc(&hpb->status.hit);
+}
+
+static void ufshpb_sysfs_stat_init(struct ufshpb_lu *hpb)
+{
+	atomic64_set(&hpb->status.hit, 0);
+	atomic64_set(&hpb->status.miss, 0);
+	atomic64_set(&hpb->status.region_miss, 0);
+	atomic64_set(&hpb->status.subregion_miss, 0);
+	atomic64_set(&hpb->status.entry_dirty_miss, 0);
+	atomic64_set(&hpb->status.rb_noti_cnt, 0);
+	atomic64_set(&hpb->status.map_req_cnt, 0);
+	atomic64_set(&hpb->status.region_evict, 0);
+	atomic64_set(&hpb->status.region_add, 0);
+	atomic64_set(&hpb->status.rb_fail, 0);
+}
+
+static ssize_t ufshpb_sysfs_kill_hpb_store(struct ufshpb_lu *hpb,
+					   const char *buf, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(buf, 0, &value)) {
+		hpb_err("kstrtoul error\n");
+		return -EINVAL;
+	}
+
+	if (value == 0) {
+		hpb_info("LU%d HPB will be killed manually\n", hpb->lun);
+		goto kill_hpb;
+	} else {
+		hpb_info("Unrecognize value inputted %lu\n", value);
+	}
+
+	return count;
+kill_hpb:
+	hpb->hba->ufshpb_state = HPB_FAILED;
+	schedule_work(&hpb->hba->ufshpb_eh_work);
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_rsp_req_show(struct ufshpb_lu *hpb, char *buf)
+{
+	long long rb_noti_cnt, map_req_cnt;
+
+	rb_noti_cnt = atomic64_read(&hpb->status.rb_noti_cnt);
+	map_req_cnt = atomic64_read(&hpb->status.map_req_cnt);
+
+	return snprintf(buf, PAGE_SIZE,
+			"Recommend RSP count %lld HPB Buffer Read count %lld\n",
+			rb_noti_cnt, map_req_cnt);
+}
+
+static ssize_t ufshpb_sysfs_count_reset_store(struct ufshpb_lu *hpb,
+					      const char *buf, size_t count)
+{
+	unsigned long debug;
+
+	if (kstrtoul(buf, 0, &debug))
+		return -EINVAL;
+
+	ufshpb_sysfs_stat_init(hpb);
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_add_evict_show(struct ufshpb_lu *hpb, char *buf)
+{
+	long long add, evict;
+
+	add = atomic64_read(&hpb->status.region_add);
+	evict = atomic64_read(&hpb->status.region_evict);
+
+	return snprintf(buf, PAGE_SIZE, "Add %lld, Evict %lld\n", add, evict);
+}
+
+static ssize_t ufshpb_sysfs_hit_show(struct ufshpb_lu *hpb, char *buf)
+{
+	long long hit;
+
+	hit = atomic64_read(&hpb->status.hit);
+
+	return snprintf(buf, PAGE_SIZE, "LU%d HPB Total hit: %lld\n",
+			hpb->lun, hit);
+}
+
+static ssize_t ufshpb_sysfs_miss_show(struct ufshpb_lu *hpb, char *buf)
+{
+	long long region_miss, subregion_miss, entry_dirty_miss, rb_fail;
+	int ret = 0, count = 0;
+
+	region_miss = atomic64_read(&hpb->status.region_miss);
+	subregion_miss = atomic64_read(&hpb->status.subregion_miss);
+	entry_dirty_miss = atomic64_read(&hpb->status.entry_dirty_miss);
+	rb_fail = atomic64_read(&hpb->status.rb_fail);
+
+	ret = sprintf(buf + count, "Total entries missed: %lld\n",
+		      region_miss + subregion_miss + entry_dirty_miss);
+	count += ret;
+
+	ret = sprintf(buf + count, "Region: %lld\n", region_miss);
+	count += ret;
+
+	ret = sprintf(buf + count, "subregion: %lld, entry dirty: %lld\n",
+		      subregion_miss, entry_dirty_miss);
+	count += ret;
+
+	ret = sprintf(buf + count, "HPB Read Buffer CMD failure: %lld\n",
+		      rb_fail);
+
+	return (count + ret);
+}
+
+static ssize_t ufshpb_sysfs_active_region_show(struct ufshpb_lu *hpb, char *buf)
+{
+	int ret = 0, count = 0, region, total = 0;
+
+	ret = sprintf(buf, " ACTIVE Region List:\n");
+	count = ret;
+
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		if (hpb->region_tbl[region].region_state == REGION_ACTIVE ||
+		    hpb->region_tbl[region].region_state == REGION_PINNED) {
+			ret = sprintf(buf + count, "%d,", region);
+			total++;
+			count += ret;
+		}
+	}
+
+	ret = sprintf(buf + count, "Total: %d\n", total);
+	count += ret;
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_act_subregion_show(struct ufshpb_lu *hpb, char *buf)
+{
+	int ret = 0, count = 0, region, sub;
+	struct ufshpb_region *cb;
+	int state;
+
+	ret = sprintf(buf, "Clean Subregion List:\n");
+	count = ret;
+
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		cb = hpb->region_tbl + region;
+		for (sub = 0; sub < cb->subregion_count; sub++) {
+			state = cb->subregion_tbl[sub].subregion_state;
+			if (state == SUBREGION_CLEAN) {
+				ret = sprintf(buf + count, "%d:%d ", region,
+					      sub);
+				count += ret;
+			}
+		}
+	}
+
+	ret = sprintf(buf + count, "\n");
+	count += ret;
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_debug_store(struct ufshpb_lu *hpb,
+					const char *buf, size_t count)
+{
+	unsigned long debug;
+
+	if (kstrtoul(buf, 0, &debug))
+		return -EINVAL;
+
+	if (debug > 0)
+		hpb->debug = debug;
+	else
+		hpb->debug = 0;
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_debug_show(struct ufshpb_lu *hpb, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n",	hpb->debug);
+}
+
+static ssize_t ufshpb_sysfs_sync_region_store(struct ufshpb_lu *hpb,
+					      const char *buf, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > 1)
+		return -EINVAL;
+
+	if (value == 1)
+		ufshpb_reload_active_region(hpb, false);
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_map_disable_show(struct ufshpb_lu *hpb, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, ">> Force_map_req_disable: %d\n",
+			hpb->force_map_req_disable);
+}
+
+static ssize_t ufshpb_sysfs_map_disable_store(struct ufshpb_lu *hpb,
+					      const char *buf, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > 1)
+		value = 1;
+
+	if (value == 1)
+		hpb->force_map_req_disable = true;
+	else if (value == 0)
+		hpb->force_map_req_disable = false;
+	else
+		hpb_err("Error value: %lu\n", value);
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_disable_show(struct ufshpb_lu *hpb, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "LU%d  HPB force_disable: %d\n",
+			hpb->lun, hpb->force_disable);
+}
+
+static ssize_t ufshpb_sysfs_disable_store(struct ufshpb_lu *hpb,
+					  const char *buf, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > 1)
+		value = 1;
+
+	if (value == 1)
+		hpb->force_disable = true;
+	else if (value == 0)
+		hpb->force_disable = false;
+	else
+		hpb_err("Error value: %lu\n", value);
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_read_threshold_show(struct ufshpb_lu *hpb,
+						char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "LU%d  HPB read_threshold: %d\n",
+			hpb->lun, hpb->read_threshold);
+}
+
+static ssize_t ufshpb_sysfs_read_threshold_store(struct ufshpb_lu *hpb,
+						 const char *buf, size_t count)
+{
+	s32 value;
+
+	if (kstrtos32(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > 0)
+		hpb->read_threshold = value;
+	else
+		hpb_err("Error read_threshold value: %d\n", value);
+
+	return count;
+}
+
+static struct ufshpb_sysfs_entry ufshpb_sysfs_entries[] = {
+	__ATTR(read_threshold, 0644, ufshpb_sysfs_read_threshold_show,
+	       ufshpb_sysfs_read_threshold_store),
+	__ATTR(bypass_hpb, 0644, ufshpb_sysfs_disable_show,
+	       ufshpb_sysfs_disable_store),
+	__ATTR(map_req_disable, 0644, ufshpb_sysfs_map_disable_show,
+	       ufshpb_sysfs_map_disable_store),
+	__ATTR(active_subregion, 0444, ufshpb_sysfs_act_subregion_show, NULL),
+	__ATTR(active_region, 0444, ufshpb_sysfs_active_region_show, NULL),
+	__ATTR(sync_active_region, 0200, NULL, ufshpb_sysfs_sync_region_store),
+	__ATTR(debug, 0644, ufshpb_sysfs_debug_show, ufshpb_sysfs_debug_store),
+	__ATTR(hit_count, 0444, ufshpb_sysfs_hit_show, NULL),
+	__ATTR(miss_count, 0444, ufshpb_sysfs_miss_show, NULL),
+	__ATTR(region_add_evict_count, 0444, ufshpb_sysfs_add_evict_show, NULL),
+	__ATTR(rsp_req_count, 0444, ufshpb_sysfs_rsp_req_show, NULL),
+	__ATTR(kill_hpb, 0200, NULL, ufshpb_sysfs_kill_hpb_store),
+	__ATTR(reset_counter, 0200, NULL, ufshpb_sysfs_count_reset_store),
+	__ATTR_NULL
+};
+
+static ssize_t ufshpb_attr_show(struct kobject *kobj, struct attribute *attr,
+				char *page)
+{
+	struct ufshpb_sysfs_entry *entry;
+	struct ufshpb_lu *hpb;
+	ssize_t error;
+
+	entry = container_of(attr, struct ufshpb_sysfs_entry, attr);
+	hpb = container_of(kobj, struct ufshpb_lu, kobj);
+
+	if (!entry->show)
+		return -EIO;
+
+	mutex_lock(&hpb->sysfs_lock);
+	error = entry->show(hpb, page);
+	mutex_unlock(&hpb->sysfs_lock);
+	return error;
+}
+
+static ssize_t ufshpb_attr_store(struct kobject *kobj, struct attribute *attr,
+				 const char *page, size_t length)
+{
+	struct ufshpb_sysfs_entry *entry;
+	struct ufshpb_lu *hpb;
+	ssize_t error;
+
+	entry = container_of(attr, struct ufshpb_sysfs_entry, attr);
+	hpb = container_of(kobj, struct ufshpb_lu, kobj);
+
+	if (!entry->store)
+		return -EIO;
+
+	mutex_lock(&hpb->sysfs_lock);
+	error = entry->store(hpb, page, length);
+	mutex_unlock(&hpb->sysfs_lock);
+	return error;
+}
+
+static const struct sysfs_ops ufshpb_sysfs_ops = {
+	.show = ufshpb_attr_show,
+	.store = ufshpb_attr_store,
+};
+
+static struct kobj_type ufshpb_ktype = {
+	.sysfs_ops = &ufshpb_sysfs_ops,
+	.release = NULL,
+};
+
+static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb)
+{
+	struct device *dev = hba->dev;
+	struct ufshpb_sysfs_entry *entry;
+	int err;
+
+	hpb->sysfs_entries = ufshpb_sysfs_entries;
+
+	ufshpb_sysfs_stat_init(hpb);
+
+	kobject_init(&hpb->kobj, &ufshpb_ktype);
+	mutex_init(&hpb->sysfs_lock);
+
+	err = kobject_add(&hpb->kobj, kobject_get(&dev->kobj), "ufshpb_lu%d",
+			  hpb->lun);
+	if (!err) {
+		for (entry = hpb->sysfs_entries; entry->attr.name; entry++) {
+			if (sysfs_create_file(&hpb->kobj, &entry->attr))
+				break;
+		}
+		kobject_uevent(&hpb->kobj, KOBJ_ADD);
+	}
+
+	return err;
+}
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
new file mode 100644
index 000000000000..4b606492c81f
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -0,0 +1,450 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Universal Flash Storage Host Performance Booster
+ *
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ *
+ * Authors:
+ *	Yongmyung Lee <ymhungry.lee@samsung.com>
+ *	Jinyoung Choi <j-young.choi@samsung.com>
+ */
+
+#ifndef _UFSHPB_H_
+#define _UFSHPB_H_
+
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/blkdev.h>
+
+#include "ufshcd.h"
+
+#define UFSHPB_VER			0x0100
+#define DRIVER_NAME			"UFSHPB"
+#define hpb_warn(fmt, ...)					\
+	pr_warn("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
+#define hpb_notice(fmt, ...)					\
+	pr_notice("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
+#define hpb_info(fmt, ...)					\
+	pr_info("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
+#define hpb_err(fmt, ...)					\
+	pr_err("%s: %s:" fmt, __func__, DRIVER_NAME,		\
+					##__VA_ARGS__)
+#define hpb_dbg(level, hpb, fmt, ...)					\
+do {									\
+	if (!(hpb))							\
+		break;							\
+	if ((hpb)->debug >= HPB_DBG_MAX || (hpb)->debug == (level))	\
+		pr_notice("%s: %s():" fmt,				\
+			DRIVER_NAME, __func__, ##__VA_ARGS__);		\
+} while (0)
+
+/*
+ * The maximum HPB cache size in system memory per controller (in MiB)
+ */
+#define HPB_MAX_MEM_SIZE_MB		CONFIG_UFSHPB_MAX_MEM_SIZE
+
+/* HPB control mode */
+#define HPB_HOST_CTRL_MODE		0x00
+#define HPB_DEV_CTRL_MODE		0x01
+
+#define HPB_MAP_REQ_RETRIES		5
+/*
+ * The default read count threashold before activating a subregion. Used in HPB
+ * host control mode.
+ */
+#define HPB_DEF_READ_THREASHOLD		10
+
+/* Constant value*/
+#define UFS_LOGICAL_BLOCK_SIZE		4096
+#define SECTORS_PER_BLOCK		(UFS_LOGICAL_BLOCK_SIZE / SECTOR_SIZE)
+#define BITS_PER_DWORD			32
+#define MAX_ACTIVE_NUM			2
+#define MAX_INACTIVE_NUM		2
+
+#define HPB_ENTRY_SIZE			0x08
+#define HPB_ENTREIS_PER_OS_PAGE		(PAGE_SIZE / HPB_ENTRY_SIZE)
+
+/* Description */
+#define UFS_FEATURE_SUPPORT_HPB_BIT	0x80
+
+#define PER_ACTIVE_INFO_BYTES		4
+#define PER_INACTIVE_INFO_BYTES		2
+
+/* UFS HPB OPCODE */
+#define UFSHPB_READ			0xF8
+#define UFSHPB_READ_BUFFER		0xF9
+#define UFSHPB_WRITE_BUFFER		0xFA
+
+#define HPB_DATA_SEG_LEN		0x14
+#define HPB_SENSE_DATA_LEN		0x12
+#define HPB_DESCRIPTOR_TYPE		0x80
+#define HPB_ADDITIONAL_LEN		0x10
+
+/* BYTE SHIFT */
+#define ZERO_BYTE_SHIFT			0
+#define ONE_BYTE_SHIFT			8
+#define TWO_BYTE_SHIFT			16
+#define THREE_BYTE_SHIFT		24
+#define FOUR_BYTE_SHIFT			32
+#define FIVE_BYTE_SHIFT			40
+#define SIX_BYTE_SHIFT			48
+#define SEVEN_BYTE_SHIFT		56
+
+#define SHIFT_BYTE_0(num)		((num) << ZERO_BYTE_SHIFT)
+#define SHIFT_BYTE_1(num)		((num) << ONE_BYTE_SHIFT)
+#define SHIFT_BYTE_2(num)		((num) << TWO_BYTE_SHIFT)
+#define SHIFT_BYTE_3(num)		((num) << THREE_BYTE_SHIFT)
+#define SHIFT_BYTE_4(num)		((num) << FOUR_BYTE_SHIFT)
+#define SHIFT_BYTE_5(num)		((num) << FIVE_BYTE_SHIFT)
+#define SHIFT_BYTE_6(num)		((num) << SIX_BYTE_SHIFT)
+#define SHIFT_BYTE_7(num)		((num) << SEVEN_BYTE_SHIFT)
+
+#define GET_BYTE_0(num)			(((num) >> ZERO_BYTE_SHIFT) & 0xff)
+#define GET_BYTE_1(num)			(((num) >> ONE_BYTE_SHIFT) & 0xff)
+#define GET_BYTE_2(num)			(((num) >> TWO_BYTE_SHIFT) & 0xff)
+#define GET_BYTE_3(num)			(((num) >> THREE_BYTE_SHIFT) & 0xff)
+#define GET_BYTE_4(num)			(((num) >> FOUR_BYTE_SHIFT) & 0xff)
+#define GET_BYTE_5(num)			(((num) >> FIVE_BYTE_SHIFT) & 0xff)
+#define GET_BYTE_6(num)			(((num) >> SIX_BYTE_SHIFT) & 0xff)
+#define GET_BYTE_7(num)			(((num) >> SEVEN_BYTE_SHIFT) & 0xff)
+
+/* UFS HPB states */
+enum UFSHPB_STATE {
+	HPB_PRESENT = 1,
+	HPB_NOT_SUPPORTED,
+	HPB_FAILED,
+	HPB_NEED_INIT,
+	HPB_NEED_RESET,
+};
+
+/* UFS HPB region states */
+enum HPBREGION_STATE {
+	REGION_INACTIVE,
+	REGION_ACTIVE,
+	REGION_PINNED,
+};
+
+/* UFS HPB subregion states */
+enum HPBSUBREGION_STATE {
+	SUBREGION_UNUSED = 1,
+	SUBREGION_DIRTY,
+	SUBREGION_REGISTERED,
+	SUBREGION_ISSUED,
+	SUBREGION_CLEAN,
+};
+
+enum HPB_REQUEST_TYPE {
+	HPB_REGION_DEACTIVATE = 1,
+	HPB_SUBREGION_ACTIVATE,
+};
+
+/* Response UPIU types */
+enum HPB_SEMSE_DATA_OPERATION {
+	HPB_RSP_NONE,
+	HPB_REQ_REGION_UPDATE,
+	HPB_RESET_REGION_INFO,
+};
+
+enum HPB_DEBUG_LEVEL {
+	FAILURE_INFO = 1,
+	REGION_INFO,
+	SCHEDULE_INFO,
+	NORMAL_INFO,
+	HPB_DBG_MAX,
+};
+
+struct ufshpb_geo_desc {
+	/*** Geometry Descriptor ***/
+	/* 48h bHPBRegionSize (UNIT: 512B) */
+	u8 hpb_region_size;
+	/* 49h bHPBNumberLU */
+	u8 hpb_number_lu;
+	/* 4Ah bHPBSubRegionSize */
+	u8 hpb_subregion_size;
+	/* 4B:4Ch wDeviceMaxActiveHPBRegions */
+	u16 hpb_dev_max_active_regions;
+};
+
+struct ufshpb_lu_desc {
+	/*** Unit Descriptor ****/
+	/* 03h bLUEnable */
+	int lu_enable;
+	/* 06h lu queue depth info*/
+	int lu_queue_depth;
+	/* 0Ah bLogicalBlockSize. default 0x0C = 4KB */
+	int lu_logblk_size;
+	/* 0Bh qLogicalBlockCount, total number of addressable logical blocks */
+	u64 lu_logblk_cnt;
+
+	/* 23h:24h wLUMaxActiveHPBRegions */
+	u16 lu_max_active_hpb_regions;
+	/* 25h:26h wHPBPinnedRegionStartIdx */
+	u16 hpb_pinned_region_startidx;
+	/* 27h:28h wNumHPBPinnedRegions */
+	u16 lu_num_hpb_pinned_regions;
+
+	/* if 03h value is 02h, hpb_enable is set. */
+	bool lu_hpb_enable;
+
+	int lu_hpb_pinned_end_offset;
+};
+
+struct ufshpb_rsp_active_list {
+	/* Active HPB Region 0/1 */
+	u16 region[MAX_ACTIVE_NUM];
+	/* HPB Sub-Region of Active HPB Region 0/1 */
+	u16 subregion[MAX_ACTIVE_NUM];
+};
+
+struct ufshpb_rsp_inactive_list {
+	/* Inactive HPB Region 0/1 */
+	u16 region[MAX_INACTIVE_NUM];
+};
+
+/*
+ * UPIU response info for HPB recommendations for activating new SubRegions
+ * and/or inactivating region
+ */
+struct ufshpb_rsp_info {
+	int type;
+	int active_cnt;
+	int inactive_cnt;
+	struct ufshpb_rsp_active_list active_list;
+	struct ufshpb_rsp_inactive_list inactive_list;
+
+	__u64 rsp_start;
+	__u64 rsp_tasklet_enter;
+
+	struct list_head list_rsp_info;
+};
+
+/*
+ * HPB request info for activating new subregion or deactivating a region
+ */
+struct ufshpb_req_info {
+	enum HPB_REQUEST_TYPE type;
+	int region;
+	int subregion;
+
+	__u64 req_start_t;
+	__u64 workq_enter_t;
+
+	struct list_head list_req_info;
+};
+
+/*
+ * HPB Sense Data frame in RESPONSE UPIU
+ */
+struct hpb_sense_data {
+	u8 len[2];
+	u8 desc_type;
+	u8 additional_len;
+	u8 hpb_op;
+	u8 lun;
+	u8 active_region_cnt;
+	u8 inactive_region_cnt;
+	u8 active_field[8];
+	u8 inactive_field[4];
+};
+
+struct ufshpb_map_ctx {
+	struct page **m_page;
+	unsigned int *ppn_dirty;
+	unsigned int ppn_dirty_counter;
+
+	struct list_head list_table;
+};
+
+struct ufshpb_subregion {
+	struct ufshpb_map_ctx *mctx;
+	enum HPBSUBREGION_STATE subregion_state;
+	int region;
+	int subregion;
+	/* Counter of read hit on this subregion */
+	atomic_t read_counter;
+
+	struct list_head list_subregion;
+};
+
+struct ufshpb_region {
+	struct ufshpb_subregion *subregion_tbl;
+	enum HPBREGION_STATE region_state;
+	/* Region number */
+	int region;
+	/* How many subregions in this region */
+	int subregion_count;
+	/* How many dirty subregions in this region */
+	int subregion_dirty_count;
+
+	/* Hit count by the read on this region */
+	unsigned int hit_count;
+	/* List head for active reion list*/
+	struct list_head list_region;
+};
+
+/*
+ * HPB deactivating/inactivating request structure
+ */
+struct ufshpb_map_req {
+	struct ufshpb_map_ctx *mctx;
+	struct ufshpb_lu *hpb;
+	struct request *req;
+	struct bio_vec *bvec;
+	struct bio bio;
+	int region;
+	int subregion;
+	int lun;
+	int retry_cnt;
+
+	struct list_head list_map_req;
+
+	/* Follow parameters used by debug/profile */
+	__u64 req_start_t;
+	__u64 workq_enter_t;
+	__u64 req_issue_t;
+	__u64 req_end_t;
+};
+
+enum victim_selection_type {
+	/* Select the first active region in list to evict */
+	LRU = 1,
+	/* Choose the active region with lowest hit count to evict */
+	LFU = 2,
+};
+
+/*
+ * local active region info list
+ */
+struct active_region_info {
+	enum victim_selection_type selection_type;
+	/* Active region list */
+	struct list_head lru;
+	/* Maximum active normal regions, doesn't include pinned regions */
+	int max_active_nor_regions;
+	/* Current Active region count */
+	atomic64_t active_cnt;
+};
+
+/* UFS device HPB constants associated with its geometry */
+struct ufshpb_geo {
+	u64 region_size_bytes;
+	u64 subregion_size_bytes;
+	/* total entry size in byte per subregion */
+	int subregion_entry_sz;
+	/* total active regions supported by the device */
+	int dev_max_active_regions;
+	/* maximum count of hpb lun supported by the device */
+	int max_hpb_lu_cnt;
+	int entries_per_subregion;
+	int entries_per_subregion_shift;
+	int entries_per_subregion_mask;
+	int entries_per_region_shift;
+	int entries_per_region_mask;
+	int subregions_per_region;
+	int dwords_per_subregion;
+	/* page size in byte */
+	int mpage_bytes;
+	/* how many pages needed for the L2P entries of one subregion */
+	int mpages_per_subregion;
+};
+
+struct ufshpb_running_status {
+	atomic64_t hit;
+	atomic64_t miss;
+	atomic64_t region_miss;
+	atomic64_t subregion_miss;
+	atomic64_t entry_dirty_miss;
+	atomic64_t rb_noti_cnt;
+	atomic64_t map_req_cnt;
+	atomic64_t region_add;
+	atomic64_t region_evict;
+	atomic64_t rb_fail;
+};
+
+struct ufshpb_lu {
+	/* The LU number associated with this HPB */
+	int lun;
+	struct ufs_hba *hba;
+	bool lu_hpb_enable;
+	spinlock_t hpb_lock;
+
+	/* HPB region info memory */
+	struct ufshpb_region *region_tbl;
+
+	/* HPB response info, the count = queue_depth */
+	struct ufshpb_rsp_info *rsp_info;
+	struct list_head lh_rsp_info_free;
+	struct list_head lh_rsp_info;
+	spinlock_t rsp_list_lock;
+
+	/* HPB request info, the count = queue_depth */
+	struct ufshpb_req_info *req_info;
+	struct list_head lh_req_info_free;
+	struct list_head lh_req_info;
+	spinlock_t req_list_lock;
+
+	/* HPB L2P mapping request memory */
+	struct ufshpb_map_req *map_req;
+	struct list_head lh_map_req_free;
+	int map_req_cnt;
+
+	/* The map_req list for map_req needed to retry */
+	struct list_head lh_map_req_retry;
+
+	/* Free mapping context structure (struct ufshpb_map_ctx) list */
+	struct list_head lh_map_ctx;
+	int free_mctx_count;
+	int lu_max_mctx_cnt;
+
+	struct list_head lh_subregion_req;
+	/*
+	 * The read_threshold is used to specify the maximum number of the read
+	 * operation hit on inactive subregion before considering this subregion
+	 * should be activated. It is used in the HPB host control mode.
+	 */
+	int read_threshold;
+	/* Active regions info list */
+	struct active_region_info lru_info;
+
+	struct work_struct ufshpb_sync_work;
+	struct work_struct ufshpb_req_work;
+	struct delayed_work retry_work;
+	struct work_struct ufshpb_rsp_work;
+
+	/* Entries size in byte of the last subregion of the LU */
+	int last_subregion_entry_size;
+	int subregions_in_last_region;
+	/* Total subregion count in the LU */
+	int lu_subregion_cnt;
+	/* Total region count in the LU */
+	int lu_region_cnt;
+	/* Max active region count supported by UFS. it includes Pinned region*/
+	int lu_max_active_regions;
+	int lu_pinned_regions;
+
+	/* UFS HPB sysfs */
+	struct kobject kobj;
+	struct mutex sysfs_lock;
+	struct ufshpb_sysfs_entry *sysfs_entries;
+
+	/* for debug */
+	bool force_disable;
+	bool force_map_req_disable;
+	int debug;
+	struct ufshpb_running_status status;
+};
+
+struct ufshpb_sysfs_entry {
+	struct attribute    attr;
+	ssize_t (*show)(struct ufshpb_lu *hpb, char *buf);
+	ssize_t (*store)(struct ufshpb_lu *hpb, const char *buf, size_t count);
+};
+
+struct ufshcd_lrb;
+
+void ufshpb_prep_fn(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufshpb_rsp_handler(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufshpb_release(struct ufs_hba *hba, enum UFSHPB_STATE state);
+void ufshpb_init(struct ufs_hba *hba);
+
+#endif /* End of Header */
-- 
2.17.1

