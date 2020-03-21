Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A87DC4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0D682070A
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQQi5Vvp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgCUAmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:42:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36508 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgCUAmT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2020 20:42:19 -0400
Received: by mail-wm1-f67.google.com with SMTP id g62so8271477wme.1;
        Fri, 20 Mar 2020 17:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RYrAKpUA3sgXgFPC8H/gmaxHdmxDUd9uP6TML7dsi2s=;
        b=qQQi5VvppnVHrk006DLNv5X84gWlY6fl9HEQum/o08ePkdThmmCXILGV9kvy+3P1Bv
         IZdqn1nEodj35D3YHIrPPehFjldq+9Jr/VdH9ceGvKPnJ9Mg6A2Z+9I5ALKkQvHQbPr6
         httubuEyf6UIunnAleSlySowSHS4GQYFlVZAdLkwukhVgkY6VLFT3J2h4ZamOZYxUAn7
         6G91RhEATdkPAnCFTRBs9q6FWN5h255ZQjnFulVPfMOJdqbZ288rrdgdHRiDi/eH+ra8
         cMPYq88NgwsWHO8xgyVG3O4ykRRmSR684R0//utSMDSgJRfY4F3ySU8FVazoYqwA/wrs
         y7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RYrAKpUA3sgXgFPC8H/gmaxHdmxDUd9uP6TML7dsi2s=;
        b=P2EKwqUetNPohjSSq/rmEJrWS/CfyZPnGrciXVFCw6c7+JD4xodEmGaZD/vq5sLsC8
         Z7rwgvQeD9aUwHb7gIIQJVkIXklYMoFH9O9fp+HyvYMfLyc/HCqtHIx8G/ZWtDZ8TRU7
         Rg87SBW1aHu9mtCch1QR81P8y1acrG0lTkGKqUOCtxYj884kZM1NRwWEBTvhWHs0PdNc
         6e6wwNwmnXAR9XIP1z304TwqaTgmBovXJe+hk6HoUy0CCHMgLhASSDwwoVoQ4W5qlyv4
         ZzzbvxbMXYHgY9Z7eL1RuXs8dgQy1oIt8XwHEWpE/g1YlJE47ExHLIekGkSnMxeOpKTs
         PuLw==
X-Gm-Message-State: ANhLgQ0mGj6TpEmRKkZqKf7JHLOmQrCU5DlGJXmx749FHoqnyMTu1ZwE
        wb4jITKm3MCUFEWEMwSRHZ8=
X-Google-Smtp-Source: ADFU+vud2NhpS5IhQ+IXPNfCvQHucJOZSB/RxNHRoxq/8aSf8Z2TLk+yb7j2JDPTkyK5oBsJ4Pg49g==
X-Received: by 2002:a1c:2e4d:: with SMTP id u74mr13311175wmu.89.1584751333960;
        Fri, 20 Mar 2020 17:42:13 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id j6sm8194982wrb.4.2020.03.20.17.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:42:13 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ymhungry.lee@samsung.com, j-young.choi@samsung.com
Subject: [PATCH v1 5/5] scsi: ufs: UFS Host Performance Booster(HPB) driver
Date:   Sat, 21 Mar 2020 01:41:56 +0100
Message-Id: <20200321004156.23364-6-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200321004156.23364-1-beanhuo@micron.com>
References: <20200321004156.23364-1-beanhuo@micron.com>
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
logical addresses of IO requests to the corresponding physical addresses of the
flash storage. Traditionally this L2P mapping data is loaded to the internal SRAM
in the storage controller. When the capacity of storage is larger, a larger size
of SRAM for the L2P map data is required. Since increased SRAM size affects the
manufacturing cost significantly, it is not cost-effective to allocate all the
amount of SRAM needed to keep all the Logical-address to Physical-address (L2P)
map data. Therefore, L2P map data, which is required to identify the physical
address for the requested IOs, can only be partially stored in SRAM from NAND
flash. Due to this partial loading, accessing the flash address area where the L2P
information for that address is not loaded in the SRAM can result in serious
performance degradation.

The HPB is a software solution for the above issue, which uses the host’s system
memory as a cache for the FTL L2P mapping table. It does not need additional
hardware support from the host side. By using HPB, the L2P mapping table can be
read from host memory and stored in host-side memory. while reading the operation,
the corresponding L2P information will be sent to the UFS device along with the
reading request. Since the L2P entry is provided in the read request, UFS device
does not have to load L2P entry from flash memory. This will significantly improve
random read performance.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/Kconfig  |   34 +
 drivers/scsi/ufs/Makefile |    1 +
 drivers/scsi/ufs/ufshcd.c |   55 +-
 drivers/scsi/ufs/ufshcd.h |    9 +
 drivers/scsi/ufs/ufshpb.c | 3322 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  421 +++++
 6 files changed, 3836 insertions(+), 6 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e2005aeddc2d..9ad0d3ecf271 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -160,3 +160,37 @@ config SCSI_UFS_BSG
 
 	  Select this if you need a bsg device node for your UFS controller.
 	  If unsure, say N.
+
+config SCSI_UFSHPB
+	bool "UFS Host Performance Booster (EXPERIMENTAL)"
+	depends on SCSI_UFSHCD
+	help
+	  NAND flash-based storage devices, including UFS, have mechanisms
+	  to translate logical addresses of IO requests to the corresponding
+	  physical addresses of the flash storage. Traditionally this L2P
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
+	  entry from flash memory. This will significantly improve the read
+	  performance.
+
+	  Select this if you need HPB to random read performance improvement.
+	  If unsure, say N.
+
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
index 8c7a89c73188..0a599760b0fd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2341,6 +2341,12 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
 						lrbp->cmd->sc_data_direction);
 		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+
+#if defined(CONFIG_SCSI_UFSHPB)
+		/* If HPB works, retrieve L2P map entry from Host memory */
+		if (hba->ufshpb_state == HPB_PRESENT)
+			ufshpb_retrieve_l2p_entry(hba, lrbp);
+#endif
 	} else {
 		ret = -EINVAL;
 	}
@@ -4566,7 +4572,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
-
+#if defined(CONFIG_SCSI_UFSHPB)
+	if (sdev->lun < hba->dev_info.max_lu_supported)
+		hba->sdev_ufs_lu[sdev->lun] = sdev;
+#endif
 	return 0;
 }
 
@@ -4682,6 +4691,16 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -6025,6 +6044,11 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
 
@@ -6032,6 +6056,11 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
@@ -6559,16 +6588,16 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
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
@@ -7113,6 +7142,14 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
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
@@ -8241,6 +8278,9 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
+#if defined(CONFIG_SCSI_UFSHPB)
+	ufshpb_release(hba, HPB_NEED_INIT);
+#endif
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_cleanup_queue(hba->tmf_queue);
@@ -8512,6 +8552,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
 
+#if defined(CONFIG_SCSI_UFSHPB)
+	ufshpb_init(hba);
+#endif
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2fa9b880e228..a58bed94ea53 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -69,6 +69,7 @@
 
 #include "ufs.h"
 #include "ufshci.h"
+#include "ufshpb.h"
 
 #define UFSHCD "ufshcd"
 #define UFSHCD_DRIVER_VERSION "0.2"
@@ -711,6 +712,14 @@ struct ufs_hba {
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
+
+#if defined(CONFIG_SCSI_UFSHPB)
+	enum UFSHPB_STATE ufshpb_state;
+	struct ufshpb_lu *ufshpb_lup[32];
+	struct delayed_work ufshpb_init_work;
+	struct work_struct ufshpb_eh_work;
+	struct scsi_device *sdev_ufs_lu[32];
+#endif
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
new file mode 100644
index 000000000000..137d0e3cf726
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -0,0 +1,3322 @@
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
+
+#define hpb_trace(hpb, args...)						\
+	do { if (hpb->hba->sdev_ufs_lu[hpb->lun] &&			\
+		hpb->hba->sdev_ufs_lu[hpb->lun]->request_queue)		\
+		blk_add_trace_msg(					\
+			hpb->hba->sdev_ufs_lu[hpb->lun]->request_queue, \
+				##args);				\
+	} while (0)
+
+/*
+ * debug variables
+ */
+int alloc_mctx;
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
+static int ufshpb_evict_one_region(struct ufshpb_lu *hpb, int *region);
+static inline int ufshpb_region_mctx_evict(struct ufshpb_lu *hpb,
+					   struct ufshpb_region *cb);
+static int ufshpb_region_mctx_alloc(struct ufshpb_lu *hpb,
+				    struct ufshpb_region *cb);
+static void ufshpb_subregion_dirty(struct ufshpb_lu *hpb,
+				   struct ufshpb_subregion *cp);
+static inline void ufshpb_cleanup_lru_info(struct ufshpb_lu *hpb,
+					   struct ufshpb_region *cb);
+static int ufshpb_l2p_mapping_load(struct ufshpb_lu *hpb, int region,
+				   int subregion, struct ufshpb_map_ctx *mctx,
+				   __u64 start_t, __u64 workq_enter_t);
+static void ufshpb_destroy_subregion_tbl(struct ufshpb_lu *hpb,
+					 struct ufshpb_region *cb);
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
+static void ufshpb_prepare_ppn(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
+			       unsigned long long ppn, int blk_cnt)
+{
+	unsigned char cmd[16] = { 0 };
+	/*
+	 * cmd[14] = Transfer length
+	 */
+	cmd[0] = UFSHPB_READ;
+	cmd[2] = lrbp->cmd->cmnd[2];
+	cmd[3] = lrbp->cmd->cmnd[3];
+	cmd[4] = lrbp->cmd->cmnd[4];
+	cmd[5] = lrbp->cmd->cmnd[5];
+	cmd[6] = GET_BYTE_7(ppn);
+	cmd[7] = GET_BYTE_6(ppn);
+	cmd[8] = GET_BYTE_5(ppn);
+	cmd[9] = GET_BYTE_4(ppn);
+	cmd[10] = GET_BYTE_3(ppn);
+	cmd[11] = GET_BYTE_2(ppn);
+	cmd[12] = GET_BYTE_1(ppn);
+	cmd[13] = GET_BYTE_0(ppn);
+	cmd[14] = blk_cnt;
+	cmd[15] = 0x00;
+	memcpy(lrbp->cmd->cmnd, cmd, 16);
+	memcpy(lrbp->ucd_req_ptr->sc.cdb, cmd, 16);
+}
+
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
+	BUG_ON(!page);
+
+	ppn_table = page_address(page);
+	BUG_ON(!ppn_table);
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
+	const unsigned long mask = ((1UL << count) - 1) & 0xffffffff;
+
+	if (cb->region_state == REGION_INACTIVE ||
+	    cp->subregion_state == SUBREGION_DIRTY)
+		return;
+
+	BUG_ON(!cp->mctx);
+	cp->mctx->ppn_dirty[dword] |= (mask << offset);
+	cp->mctx->ppn_dirty_counter += count;
+
+	if (cp->mctx->ppn_dirty_counter >= hpb->entries_per_subregion)
+		ufshpb_subregion_dirty(hpb, cp);
+}
+
+/*
+ * Check if this entry/ppn is dirty or not in the L2P table cache,
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
+		   (1 << bit_offset) ? true : false;
+
+	return is_dirty;
+}
+
+static void ufshpb_l2p_entry_dirty_set(struct ufshpb_lu *hpb,
+				       struct ufshcd_lrb *lrbp,
+				       int region, int subregion,
+				       int subregion_offset)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	int bit_count, dword, bit_offset;
+	int count;
+
+	count = blk_rq_sectors(lrbp->cmd->request) >> sects_per_blk_shift;
+	ufshpb_get_bit_offset(hpb, subregion_offset,
+			      &dword, &bit_offset);
+
+	do {
+		bit_count = min(count, BITS_PER_DWORD - bit_offset);
+
+		cb = hpb->region_tbl + region;
+		cp = cb->subregion_tbl + subregion;
+
+		ufshpb_l2p_entry_dirty_bit_set(hpb, cb, cp,
+					       dword, bit_offset, bit_count);
+
+		bit_offset = 0;
+		dword++;
+
+		if (dword == hpb->dwords_per_subregion) {
+			dword = 0;
+			subregion++;
+
+			if (subregion == hpb->subregions_per_region) {
+				subregion = 0;
+				region++;
+			}
+		}
+
+		count -= bit_count;
+	} while (count);
+
+	BUG_ON(count < 0);
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
+		hpb_dbg(REGION_INFO, hpb,
+			"RSP UPIU: ACT[%d]: RG %d, SRG %d",
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
+		hpb_dbg(REGION_INFO, hpb,
+			"RSP UPIU: INACT[%d]: Region%d", num + 1,
+			rsp_info->inactive_list.region[num]);
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
+	if (lrbp->cmd->cmnd[0] == WRITE_10 || lrbp->cmd->cmnd[0] == WRITE_16
+	    || lrbp->cmd->cmnd[0] == UNMAP)
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
+
+	*region = lpn >> hpb->entries_per_region_shift;
+	region_offset = lpn & hpb->entries_per_region_mask;
+	*subregion = region_offset >> hpb->entries_per_subregion_shift;
+	*offset = region_offset & hpb->entries_per_subregion_mask;
+}
+
+static int ufshpb_subregion_dirty_bitmap_clean(struct ufshpb_lu *hpb,
+					       struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+
+	cb = hpb->region_tbl + cp->region;
+
+	/* if mctx is null, active block had been evicted out */
+	if (cb->region_state == REGION_INACTIVE || !cp->mctx) {
+		hpb_dbg(FAILURE_INFO, hpb, "RG_SRG(%d - %d) has been evicted",
+				cp->region, cp->subregion);
+		return -EINVAL;
+	}
+
+	memset(cp->mctx->ppn_dirty, 0x00,
+	       hpb->entries_per_subregion >> bits_per_byte_shift);
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
+		hpb_dbg(FAILURE_INFO, hpb, "RG_SRG %d - %d has been evicted\n",
+				cp->region, cp->subregion);
+		return;
+	}
+
+	cp->subregion_state = SUBREGION_CLEAN;
+}
+
+/*
+ * Change subregion_state to SUBREGION_DIRTY
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
+
+	}
+
+	return is_clean;
+}
+
+static int ufshpb_make_region_inactive(struct ufshpb_lu *hpb,
+					int *victim_region)
+{
+
+	int region, ret;
+	struct ufshpb_region *victim_cb;
+	struct ufshpb_req_info *req_info;
+
+	req_info = ufshpb_req_info_get(hpb);
+	if (!req_info) {
+		hpb_dbg(FAILURE_INFO, hpb, "No req_info in mempool\n");
+		return -ENOSPC;
+	}
+
+	ret = ufshpb_evict_one_region(hpb, &region);
+	if (ret)
+		goto out;
+
+	victim_cb = hpb->region_tbl + region;
+	if (victim_cb->region_state != REGION_INACTIVE) {
+		ret = -EINVAL;
+		goto out;
+	}
+	req_info->type = HPB_REGION_DEACTIVATE;
+	req_info->region = region;
+	req_info->req_start_t = ktime_to_ns(ktime_get());
+
+	spin_lock(&hpb->req_list_lock);
+	list_add_tail(&req_info->list_req_info, &hpb->lh_req_info);
+	spin_unlock(&hpb->req_list_lock);
+
+	*victim_region = region;
+	return 0;
+out:
+	ufshpb_req_info_put(hpb, req_info);
+	return ret;
+}
+
+static int ufshpb_subregion_register(struct ufshpb_lu *hpb,
+				     struct ufshpb_subregion *cp)
+{
+	struct ufshpb_req_info *req_info;
+	struct active_region_info *lru_info;
+	struct ufshpb_region *cb;
+	int deactivate_region_add;
+	int region;
+	int ret;
+
+	cb = hpb->region_tbl + cp->region;
+	lru_info = &hpb->lru_info;
+
+	if (cb->region_state == REGION_INACTIVE) {
+		if (atomic64_read(&lru_info->active_cnt) >=
+		    lru_info->max_active_cnt) {
+			/*
+			 * The number of active HPB Region is equal to the
+			 * maximum active regions supported by device, the
+			 * host is expected to issue a HPB WRITE BUFFER command
+			 * to inactivate a region before activating a new region
+			 */
+			ret = ufshpb_make_region_inactive(hpb, &region);
+			if (ret)
+				goto out;
+			hpb_dbg(REGION_INFO, hpb,
+				"Evict region %d, and activate region %d\n",
+				region, cp->region);
+			deactivate_region_add = 1;
+		}
+
+		if (ufshpb_region_mctx_alloc(hpb, cb))
+			goto out;
+	}
+
+	if (cp->subregion_state == SUBREGION_UNUSED ||
+	    cp->subregion_state == SUBREGION_DIRTY) {
+		req_info = ufshpb_req_info_get(hpb);
+		if (!req_info) {
+			hpb_dbg(FAILURE_INFO, hpb, "No req_info in mempool\n");
+			if (!deactivate_region_add)
+				ret = -ENOMEM;
+			goto out;
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
+		hpb_dbg(REGION_INFO, hpb,
+			"Add RG_SRG(%d - %d) to activate\n",
+			cp->region, cp->subregion);
+	}
+out:
+	return ret;
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
+	if (region >= hpb->regions_per_lu) {
+		hpb_err("Region exceeds regions_per_lu\n");
+		return;
+	}
+
+	ufshpb_prepare_write_buf_cmd(cmd, region);
+
+	if (hpb->force_map_req_disable) {
+		hpb_notice("map disable - return");
+		return;
+	}
+
+	ret = ufshpb_execute_cmd(hpb, cmd);
+	if (ret) {
+		hpb_err("ufshpb_execute_cmd failed with error %d\n",
+			ret);
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
+	if (region >= hpb->regions_per_lu) {
+		hpb_err("Region%d exceeds regions_per_lu\n",
+			region);
+		goto out;
+	}
+
+	cb = hpb->region_tbl + region;
+
+	if (subregion >= cb->subregion_count) {
+		hpb_err("Subregion%d exceeds its range %d - %d",
+			subregion, region, cb->subregion_count);
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
+			"HPB BUFFER READ of RG_SRG (%d_%d) has been issued",
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
+		hpb_notice("map disable - return");
+		goto out;
+	}
+	ret = ufshpb_l2p_mapping_load(hpb, region, subregion,
+				      cp->mctx, req_info->req_start_t,
+				      req_info->workq_enter_t);
+	if (ret)
+		hpb_err("ufshpb_l2p_mapping_load failed with error %d",
+			ret);
+out:
+	return;
+}
+
+static inline struct ufshpb_map_ctx *ufshpb_mctx_get(struct ufshpb_lu *hpb,
+						     int *err)
+{
+	struct ufshpb_map_ctx *mctx;
+
+	mctx = list_first_entry_or_null(&hpb->lh_map_ctx,
+					struct ufshpb_map_ctx, list_table);
+	if (mctx) {
+		list_del_init(&mctx->list_table);
+		hpb->free_mctx--;
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
+	hpb->free_mctx++;
+}
+
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
+/*
+ * add new active region to active region info lru_info
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
+	list_move_tail(&cb->list_region, &lru_info->lru);
+	if (cb->hit_count != 0xffffffff)
+		cb->hit_count++;
+}
+
+/*
+ * Remove one active region from active region info lru_info
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
+/*
+ * This function is only to change subregion_state to  SUBREGION_CLEAN
+ */
+static void ufshpb_l2p_mapping_load_compl(struct ufshpb_lu *hpb,
+		struct ufshpb_map_req *map_req)
+{
+	map_req->req_end_t = ktime_to_ns(ktime_get());
+
+	hpb_trace(hpb, "%s: C RB %d - %d", DRIVER_NAME, map_req->region,
+		  map_req->subregion);
+	hpb_dbg(SCHEDULE_INFO, hpb,
+		"LU%d HPB READ BUFFER COMPL RG_SRG (%d: %d), took %lldns\n",
+		hpb->lun, map_req->region, map_req->subregion,
+		map_req->req_end_t - map_req->req_start_t);
+	hpb_dbg(SCHEDULE_INFO, hpb,
+		"stage1 %lldns, stage2 %lldns, stage3 %lldns, stage4 %lldns",
+		map_req->workq_enter_t - map_req->req_start_t,
+		map_req->req_issue_t - map_req->workq_enter_t,
+		map_req->req_endio_t - map_req->req_issue_t,
+		map_req->req_end_t - map_req->req_endio_t);
+
+	spin_lock(&hpb->hpb_lock);
+	ufshpb_subregion_clean(hpb,
+			       hpb->region_tbl[map_req->region].subregion_tbl +
+			       map_req->subregion);
+	spin_unlock(&hpb->hpb_lock);
+}
+
+static void ufshpb_l2p_mapping_req_done(struct request *req,
+					blk_status_t status)
+{
+	struct ufs_hba *hba;
+	struct ufshpb_lu *hpb;
+	struct ufshpb_region *cb;
+	struct scsi_sense_hdr sshdr;
+	struct ufshpb_rsp_info *rsp_info;
+	struct ufshpb_map_req *map_req;
+	struct scsi_cmnd *scmd;
+	unsigned long flags;
+
+	map_req = (struct ufshpb_map_req *) req->end_io_data;
+
+	hpb = map_req->hpb;
+	hba = hpb->hba;
+	cb = hpb->region_tbl + map_req->region;
+	map_req->req_endio_t = ktime_to_ns(ktime_get());
+
+	if (hba->ufshpb_state != HPB_PRESENT)
+		goto free_map_req;
+
+	if (status) {
+		scmd = blk_mq_rq_to_pdu(req);
+		hpb_err("LU%d HPB READ BUFFER RG-SRG (%d: %d) failed\n",
+			map_req->lun, map_req->region, map_req->subregion);
+		hpb_err("SCSI Request result 0x%x, blk error status %d\n",
+			scsi_req(req)->result, status);
+
+		scsi_normalize_sense(scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+				     &sshdr);
+		hpb_err("RSP_code 0x%x sense_key 0x%x ASC 0x%x ASCQ 0x%x\n",
+			sshdr.response_code, sshdr.sense_key, sshdr.asc,
+			sshdr.ascq);
+		hpb_err("byte4 %x byte5 %x byte6 %x additional_len %x\n",
+			sshdr.byte4, sshdr.byte5,
+			sshdr.byte6, sshdr.additional_length);
+		atomic64_inc(&hpb->status.rb_fail);
+		if (sshdr.sense_key == ILLEGAL_REQUEST) {
+			spin_lock(&hpb->hpb_lock);
+			if (cb->region_state == REGION_PINNED) {
+				if (map_req->retry_cnt < 5) {
+					/*FIXME, need to check ACS and ASCQ*/
+					/*
+					 * If the HPB buffer Read request
+					 * meets the UFS deivce GC, the
+					 * device maybe returns ILLEGAL_REQUEST.
+					 * For the case, we should retry later.
+					 */
+					hpb_dbg(REGION_INFO, hpb,
+						"Retry pinned RG_SRG (%d - %d)",
+						map_req->region,
+						map_req->subregion);
+
+					INIT_LIST_HEAD(&map_req->list_map_req);
+					list_add_tail(&map_req->list_map_req,
+						      &hpb->lh_map_req_retry);
+					spin_unlock(&hpb->hpb_lock);
+
+					schedule_delayed_work(&hpb->retry_work,
+							msecs_to_jiffies(5000));
+					return;
+
+				} else {
+					hpb_dbg(REGION_INFO, hpb,
+						"Mark pinned SRG %d-%d(dirty)",
+						map_req->region,
+						map_req->subregion);
+
+					ufshpb_subregion_dirty(hpb,
+							cb->subregion_tbl +
+							map_req->subregion);
+					spin_unlock(&hpb->hpb_lock);
+				}
+			} else {
+				/*
+				 * If region which was read is not active
+				 * in UFS device, the UFS device likely return
+				 * ILLEGAL_REQUEST, for this case, we should
+				 * deactivate this region in local cache.
+				 */
+				spin_unlock(&hpb->hpb_lock);
+
+				rsp_info = ufshpb_rsp_info_get(hpb);
+				if (!rsp_info) {
+					hpb_warn("%s: %d No free rsp_info\n",
+						 __func__, __LINE__);
+					goto free_map_req;
+				}
+
+				rsp_info->type = HPB_REQ_REGION_UPDATE;
+				rsp_info->rsp_start = ktime_to_ns(ktime_get());
+				rsp_info->active_cnt = 0;
+				rsp_info->inactive_cnt = 1;
+				rsp_info->inactive_list.region[0] =
+					map_req->region;
+
+				hpb_dbg(REGION_INFO, hpb,
+					"Normal RG %d is to deactivate\n",
+					map_req->region);
+
+				spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+				list_add_tail(&rsp_info->list_rsp_info,
+					      &hpb->lh_rsp_info);
+				spin_unlock_irqrestore(&hpb->rsp_list_lock,
+						       flags);
+
+				schedule_work(&hpb->ufshpb_rsp_work);
+			}
+		} else {
+			/* FIXME, need to fix EIO error and timeout issue*/
+			;
+		}
+	} else {
+		ufshpb_l2p_mapping_load_compl(hpb, map_req);
+	}
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
+		hpb_warn("%s UFSHPB cannot find scsi_device\n",
+			 __func__);
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
+	struct page *page = NULL;
+	int i, ret = 0;
+
+	WARN_ON(!mctx);
+	WARN_ON(!bvec);
+	/*
+	 * FIXME, below bvec array depth is samller than mpages_per_subregion.
+	 */
+	bio_init(bio, bvec, hpb->mpages_per_subregion);
+
+	for (i = 0; i < hpb->mpages_per_subregion; i++) {
+		/* virt_to_page(p + (PAGE_SIZE * i)); */
+		page = mctx->m_page[i];
+		if (!page)
+			return -ENOMEM;
+
+		ret = bio_add_pc_page(q, bio, page, hpb->mpage_bytes, 0);
+
+		if (ret != hpb->mpage_bytes) {
+			hpb_err("Error ret %d", ret);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int ufshpb_l2p_mapping_load_req(struct ufshpb_lu *hpb,
+				       struct request_queue *q,
+				       struct ufshpb_map_req *map_req)
+{
+	struct request *req;
+	struct scsi_request *scsi_rq;
+	struct bio *bio;
+	unsigned char cmd[16] = { };
+	int alloc_len;
+	int ret;
+
+	bio = &map_req->bio;
+
+	ret = ufshpb_add_bio_page(hpb, q, bio, map_req->bvec, map_req->mctx);
+	if (ret) {
+		hpb_err("ufshpb_add_bio_page failed with error %d", ret);
+		return ret;
+	}
+
+	alloc_len = hpb->subregion_entry_size;
+	/*
+	 * HPB Sub-Regions are equally sized except for
+	 * the last one which is smaller if the last hpb
+	 * Region is not an interger multiple of bHPBSubRegionSize.
+	 */
+	if (map_req->region == (hpb->regions_per_lu - 1) &&
+	    map_req->subregion == (hpb->subregions_in_last_region - 1))
+		alloc_len = hpb->last_subregion_entry_size;
+
+	ufshpb_prepare_read_buf_cmd(cmd, map_req->region, map_req->subregion,
+				    alloc_len);
+	if (map_req->req == NULL) {
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
+	hpb_dbg(SCHEDULE_INFO, hpb,
+		"ISSUE READ_BUFFER : %d - %d  retry = %d",
+		map_req->region, map_req->subregion, map_req->retry_cnt);
+	hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME, map_req->region,
+		  map_req->subregion);
+
+	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_l2p_mapping_req_done);
+	map_req->req_issue_t = ktime_to_ns(ktime_get());
+
+	atomic64_inc(&hpb->status.map_req_cnt);
+
+	return 0;
+}
+
+static int ufshpb_l2p_mapping_load(struct ufshpb_lu *hpb, int region,
+				   int subregion, struct ufshpb_map_ctx *mctx,
+				   __u64 start_t, __u64 workq_enter_t)
+{
+	struct ufshpb_map_req *map_req;
+	struct request_queue *q;
+
+	spin_lock(&hpb->hpb_lock);
+	map_req = list_first_entry_or_null(&hpb->lh_map_req_free,
+					   struct ufshpb_map_req,
+					   list_map_req);
+	if (!map_req) {
+		hpb_dbg(FAILURE_INFO, hpb, "There is no free map_req");
+		spin_unlock(&hpb->hpb_lock);
+		return -ENOMEM;
+	}
+	list_del(&map_req->list_map_req);
+	memset(map_req, 0x00, sizeof(struct ufshpb_map_req));
+
+	spin_unlock(&hpb->hpb_lock);
+
+	map_req->hpb = hpb;
+	map_req->retry_cnt = 0;
+	map_req->region = region;
+	map_req->subregion = subregion;
+	map_req->mctx = mctx;
+	map_req->lun = hpb->lun;
+	map_req->req_start_t = start_t;
+	map_req->workq_enter_t = workq_enter_t;
+
+	q = hpb->hba->sdev_ufs_lu[hpb->lun]->request_queue;
+	return ufshpb_l2p_mapping_load_req(hpb, q, map_req);
+}
+
+static inline int ufshpb_region_mctx_evict(struct ufshpb_lu *hpb,
+					   struct ufshpb_region *cb)
+{
+	struct ufshpb_subregion *cp;
+	int subregion;
+
+	if (cb->region_state == REGION_PINNED) {
+		/*
+		 * Pinned active-block should not drop-out.
+		 * But if so, it would treat error as critical,
+		 * and it will run ufshpb_eh_work
+		 */
+		hpb_warn("Trying to evict HPB pinned region\n");
+		return -ENOMEDIUM;
+	}
+
+	if (list_empty(&cb->list_region)) {
+		/* The region being evicted has been inactive */
+		return 0;
+	}
+
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
+		 * Choose first active in list to evict
+		 */
+		victim_cb = list_first_entry(&lru_info->lru,
+					     struct ufshpb_region, list_region);
+		break;
+	case LFU:
+		/*
+		 * Choose active region with the lowest hit_count to evict
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
+static int ufshpb_evict_one_region(struct ufshpb_lu *hpb, int *region)
+{
+	struct ufshpb_region *victim_cb;
+	struct active_region_info *lru_info;
+
+	lru_info = &hpb->lru_info;
+
+	victim_cb = ufshpb_victim_region_select(lru_info);
+	if (!victim_cb) {
+		hpb_warn("UFSHPB victim_cb is NULL\n");
+		return -EIO;
+	}
+	hpb_trace(hpb, "%s: VT RG %d", DRIVER_NAME, victim_cb->region);
+	hpb_dbg(REGION_INFO, hpb, "LU%d HPB will release active region %d\n",
+		  hpb->lun,  victim_cb->region);
+	*region = victim_cb->region;
+
+	return ufshpb_region_mctx_evict(hpb, victim_cb);
+}
+
+static inline int __ufshpb_region_mctx_alloc(struct ufshpb_lu *hpb,
+					     struct ufshpb_region *cb)
+{
+	int subregion;
+	int err = 0;
+
+
+	hpb_dbg(REGION_INFO, hpb,
+		"\x1b[44m\x1b[32m Activate region: %d \x1b[0m",
+		cb->region);
+	hpb_trace(hpb, "%s: ACT RG: %d", DRIVER_NAME, cb->region);
+
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		struct ufshpb_subregion *cp;
+
+		cp = cb->subregion_tbl + subregion;
+
+		cp->mctx = ufshpb_mctx_get(hpb, &err);
+		if (err) {
+			hpb_dbg(FAILURE_INFO, hpb,
+				"Failed to get mctx for SRG %d, free mctxs %d",
+				subregion, hpb->free_mctx);
+			goto out;
+		}
+	}
+
+	atomic64_inc(&hpb->status.region_add);
+out:
+	return err;
+}
+
+static int ufshpb_region_mctx_alloc(struct ufshpb_lu *hpb,
+				    struct ufshpb_region *cb)
+{
+	struct active_region_info *lru_info;
+	int ret;
+
+	lru_info = &hpb->lru_info;
+	/*
+	 * if already region is added to lru_list,
+	 * just initiate the information of lru.
+	 * because the region already has the mapping ctx.
+	 * (!list_empty(&cb->list_region) equals to region->state=active...)
+	 */
+	if (!list_empty(&cb->list_region)) {
+		hpb_dbg(REGION_INFO, hpb,
+			  "LU%d Region %d already in lur_list",
+			  hpb->lun, cb->region);
+		ufshpb_hit_lru_info(lru_info, cb);
+		return 0;
+	}
+
+	if (cb->region_state == REGION_INACTIVE)
+		hpb_dbg(REGION_INFO, hpb, "Region%d is inactive", cb->region);
+
+	ret = __ufshpb_region_mctx_alloc(hpb, cb);
+	if (ret) {
+		hpb_warn("UFSHPB mctx allocation failed\n");
+		return -ENOMEM;
+	}
+
+	ufshpb_add_lru_info(lru_info, cb);
+
+	return 0;
+}
+
+static int ufshpb_region_mctx_evict_add(struct ufshpb_lu *hpb,
+					struct ufshpb_rsp_info *rsp_info)
+{
+	struct active_region_info *lru_info;
+	struct ufshpb_subregion *cp;
+	struct ufshpb_region *cb;
+	int region, subregion;
+	int active_cnt;
+	int iter;
+
+	lru_info = &hpb->lru_info;
+	hpb_dbg(REGION_INFO, hpb,
+		"LU%d now has  %lld active regions", hpb->lun,
+		atomic64_read(&lru_info->active_cnt));
+
+	for (iter = 0; iter < rsp_info->inactive_cnt; iter++) {
+		region = rsp_info->inactive_list.region[iter];
+		cb = hpb->region_tbl + region;
+
+		spin_lock(&hpb->hpb_lock);
+		if (ufshpb_region_mctx_evict(hpb, cb))
+			goto out;
+
+		spin_unlock(&hpb->hpb_lock);
+	}
+
+	active_cnt = rsp_info->active_cnt;
+	for (iter = 0; iter < active_cnt; iter++) {
+		region = rsp_info->active_list.region[iter];
+		cb = hpb->region_tbl + region;
+
+		spin_lock(&hpb->hpb_lock);
+		switch (hpb->hba->dev_info.hpb_control_mode) {
+		case HPB_HOST_CTRL_MODE:
+			/*
+			 * For the HPB host control mode, we just dirty
+			 * this subregion, and remove it from recommended
+			 * subregion array
+			 */
+			subregion = rsp_info->active_list.subregion[iter];
+			cp = cb->subregion_tbl + subregion;
+			ufshpb_subregion_dirty(hpb, cp);
+			rsp_info->active_cnt--;
+			break;
+		case HPB_DEV_CTRL_MODE:
+			if (atomic64_read(&lru_info->active_cnt) >=
+			    lru_info->max_active_cnt) {
+				int victim_region;
+
+				if (ufshpb_evict_one_region(hpb,
+							    &victim_region))
+					goto out;
+			}
+			if (ufshpb_region_mctx_alloc(hpb, cb))
+				goto out;
+			break;
+		default:
+			hpb_err("Unknown HPB control mode\n");
+			break;
+		}
+		spin_unlock(&hpb->hpb_lock);
+	}
+
+	return 0;
+out:
+	spin_unlock(&hpb->hpb_lock);
+	return -ENOMEM;
+}
+
+static void ufshpb_recommended_l2p_update(struct ufshpb_lu *hpb,
+					  struct ufshpb_rsp_info *rsp_info)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	int region, subregion;
+	int iter;
+	int ret;
+
+	/*
+	 *  Before HPB Read Buffer CMD for active region/subregion,
+	 *  prepare mctx for each subregion
+	 */
+	ret = ufshpb_region_mctx_evict_add(hpb, rsp_info);
+	if (ret) {
+		hpb_err("region mctx evict/load failed\n");
+		goto wakeup_ee_worker;
+	}
+
+	for (iter = 0; iter < rsp_info->active_cnt; iter++) {
+		region = rsp_info->active_list.region[iter];
+		subregion = rsp_info->active_list.subregion[iter];
+		cb = hpb->region_tbl + region;
+
+		if (region >= hpb->regions_per_lu ||
+		    subregion >= cb->subregion_count) {
+			hpb_err("ufshpb issue-map %d - %d range error",
+				region, subregion);
+			goto wakeup_ee_worker;
+		}
+
+		cp = cb->subregion_tbl + subregion;
+
+		/* if subregion_state set SUBREGION_ISSUED,
+		 * active_page has already been added to list,
+		 * so it just ends function.
+		 */
+
+		spin_lock(&hpb->hpb_lock);
+		if (cp->subregion_state == SUBREGION_ISSUED) {
+			hpb_dbg(SCHEDULE_INFO, hpb,
+				"HPB buffer Read for region %d has been issued",
+				 region);
+			spin_unlock(&hpb->hpb_lock);
+			continue;
+		}
+
+		cp->subregion_state = SUBREGION_ISSUED;
+
+		ret = ufshpb_subregion_dirty_bitmap_clean(hpb, cp);
+
+		spin_unlock(&hpb->hpb_lock);
+
+		if (ret)
+			continue;
+
+		if (hpb->force_map_req_disable) {
+			hpb_notice("map disable - return");
+			return;
+		}
+
+		ret = ufshpb_l2p_mapping_load(hpb, region, subregion,
+					      cp->mctx, rsp_info->rsp_start,
+					      rsp_info->rsp_tasklet_enter);
+		if (ret) {
+			hpb_err("ufshpb_l2p_mapping_load failed with error %d",
+				ret);
+			goto wakeup_ee_worker;
+		}
+	}
+	return;
+
+wakeup_ee_worker:
+	hpb->hba->ufshpb_state = HPB_FAILED;
+	schedule_work(&hpb->hba->ufshpb_eh_work);
+}
+
+static inline void ufshpb_add_subregion_to_req_list(struct ufshpb_lu *hpb,
+						    struct ufshpb_subregion *cp)
+{
+	list_add_tail(&cp->list_subregion, &hpb->lh_subregion_req);
+	cp->subregion_state = SUBREGION_ISSUED;
+}
+
+static int ufshpb_execute_req(struct ufshpb_lu *hpb, unsigned char *cmd,
+			      struct ufshpb_subregion *cp)
+{
+	struct request_queue *q;
+	struct request *req;
+	struct scsi_request *scsi_rq;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_device *sdp;
+	struct bio bio;
+	struct bio *bio_p = &bio;
+	struct bio_vec *bvec;
+	struct ufs_hba *hba;
+	char sense[SCSI_SENSE_BUFFERSIZE];
+	unsigned long flags;
+	int ret = 0;
+
+	hba = hpb->hba;
+	bvec = kmalloc_array(hpb->mpages_per_subregion, sizeof(struct bio_vec),
+		       GFP_KERNEL);
+	if (!bvec)
+		return -ENOMEM;
+
+	sdp = hba->sdev_ufs_lu[hpb->lun];
+	if (!sdp) {
+		hpb_warn("%s UFSHPB cannot find scsi_device\n",
+			 __func__);
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
+		hpb_err("code 0x%x sense_key 0x%x asc 0x%x ascq 0x%x",
+			sshdr.response_code, sshdr.sense_key, sshdr.asc,
+			sshdr.ascq);
+		hpb_err("byte4 0x%x byte5 0x%x byte6 0x%x additional_len 0x%x",
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
+	kfree(bvec);
+	return ret;
+}
+
+static int ufshpb_issue_map_req_from_list(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_subregion *cp, *next_cp;
+	int alloc_len;
+	int ret;
+
+	LIST_HEAD(req_list);
+
+	spin_lock_bh(&hpb->hpb_lock);
+	list_splice_init(&hpb->lh_subregion_req,
+			 &req_list);
+	spin_unlock_bh(&hpb->hpb_lock);
+
+	list_for_each_entry_safe(cp, next_cp, &req_list, list_subregion) {
+		unsigned char cmd[10] = { 0 };
+
+		alloc_len = hpb->subregion_entry_size;
+		/*
+		 * HPB Sub-Regions are equally sized except for
+		 * the last one which is smaller if the last hpb
+		 * Region is not an interger multiple of bHPBSubRegionSize.
+		 */
+		if (cp->region == (hpb->regions_per_lu - 1) &&
+		    cp->subregion == (hpb->subregions_in_last_region - 1))
+			alloc_len = hpb->last_subregion_entry_size;
+
+		ufshpb_prepare_read_buf_cmd(cmd, cp->region, cp->subregion,
+					    alloc_len);
+
+		hpb_dbg(SCHEDULE_INFO, hpb,
+			"RG_SRG(%d -%d) ISSUE READ_BUFFER",
+			cp->region, cp->subregion);
+
+		hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME,
+			  cp->region, cp->subregion);
+
+		ret = ufshpb_execute_req(hpb, cmd, cp);
+		if (ret < 0) {
+			hpb_err("RG_SRG(%d - %d) HPB READ BUFFER failed %d\n",
+				cp->region, cp->subregion, ret);
+			continue;
+		}
+
+
+		hpb_trace(hpb, "%s: C RB %d - %d", DRIVER_NAME,
+			  cp->region, cp->subregion);
+
+		hpb_dbg(REGION_INFO, hpb,
+			"RG_SRG(%d -%d) HPB READ_BUFFER COML",
+			cp->region, cp->subregion);
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
+	hpb_dbg(SCHEDULE_INFO, hpb, "sync worker start\n");
+
+	if (!list_empty(&hpb->lh_subregion_req)) {
+		ret = ufshpb_issue_map_req_from_list(hpb);
+		/*
+		 * If its function failed at init time,
+		 * ufshpb-device will request map-req,
+		 * so it is not critical-error, and just
+		 * finish work-handler
+		 */
+		if (ret)
+			hpb_err("Issue map_req failed with ret %d\n",
+				ret);
+	}
+
+	hpb_dbg(SCHEDULE_INFO, hpb, "sync worker end\n");
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
+				"Activate RG_SRG(%d - %d) done\n",
+				req_info->region, req_info->subregion);
+			break;
+		case HPB_REGION_DEACTIVATE:
+			ufshpb_region_deactivate(hpb, req_info);
+			hpb_dbg(SCHEDULE_INFO, hpb,
+				"Deactivate RG_SRG(%d - %d) done\n",
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
+		ret = ufshpb_l2p_mapping_load_req(hpb, q,
+						  map_req);
+		if (ret) {
+			hpb_err("ufshpb_l2p_mapping_load_req error %d",
+				ret);
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
+			break;
+		}
+		ufshpb_rsp_info_put(hpb, rsp_info);
+	}
+}
+
+static void ufshpb_init_constant(void)
+{
+	sects_per_blk_shift = ffs(UFS_LOGICAL_BLOCK_SIZE) - ffs(SECTOR_SIZE);
+	bits_per_dword_shift = ffs(BITS_PER_DWORD) - 1;
+	bits_per_dword_mask = BITS_PER_DWORD - 1;
+	bits_per_byte_shift = ffs(BITS_PER_BYTE) - 1;
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
+		ufshpb_add_subregion_to_req_list(hpb, cp);
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
+static void ufshpb_init_subregion_tbl(struct ufshpb_lu *hpb,
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
+static int ufshpb_alloc_subregion_tbl(struct ufshpb_lu *hpb,
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
+	int i;
+
+	list_for_each_entry_safe(mctx, next, &hpb->lh_map_ctx, list_table) {
+		for (i = 0; i < hpb->mpages_per_subregion; i++)
+			__free_page(mctx->m_page[i]);
+
+		vfree(mctx->ppn_dirty);
+		kfree(mctx->m_page);
+		kfree(mctx);
+		alloc_mctx--;
+	}
+}
+
+static int ufshpb_mctx_mempool_init(struct ufshpb_lu *hpb, int num_regions,
+				    int subregions_per_region, int entry_count,
+				    int entry_byte)
+{
+	int i, j, k;
+	struct ufshpb_map_ctx *mctx = NULL;
+
+	INIT_LIST_HEAD(&hpb->lh_map_ctx);
+
+	for (i = 0; i < num_regions * subregions_per_region; i++) {
+		mctx = kzalloc(sizeof(struct ufshpb_map_ctx), GFP_KERNEL);
+		if (!mctx)
+			goto release_mem;
+
+		mctx->m_page = kcalloc(hpb->mpages_per_subregion,
+				       sizeof(struct page *),
+				       GFP_KERNEL);
+		if (!mctx->m_page)
+			goto release_mem;
+
+		mctx->ppn_dirty = vzalloc(entry_count >> bits_per_byte_shift);
+		if (!mctx->ppn_dirty)
+			goto release_mem;
+
+		for (j = 0; j < hpb->mpages_per_subregion; j++) {
+			mctx->m_page[j] = alloc_page(GFP_KERNEL | __GFP_ZERO);
+			if (!mctx->m_page[j]) {
+				for (k = 0; k < j; k++)
+					kfree(mctx->m_page[k]);
+				goto release_mem;
+			}
+		}
+
+		INIT_LIST_HEAD(&mctx->list_table);
+		list_add(&mctx->list_table, &hpb->lh_map_ctx);
+		hpb->free_mctx++;
+	}
+
+	alloc_mctx = num_regions * subregions_per_region;
+	hpb_info("LU%d amount of mctx %d\n", hpb->lun, hpb->free_mctx);
+	return 0;
+
+release_mem:
+	/*
+	 * mctxs already added in lh_map_ctx will be removed
+	 * in the caller function.
+	 */
+	if (mctx) {
+		kfree(mctx->m_page);
+		vfree(mctx->ppn_dirty);
+		kfree(mctx);
+	}
+	return -ENOMEM;
+}
+
+static inline void ufshpb_req_mempool_remove(struct ufshpb_lu *hpb)
+{
+	kfree(hpb->rsp_info);
+	kfree(hpb->req_info);
+	kfree(hpb->map_req);
+}
+
+static int ufshpb_req_mempool_init(struct ufshpb_lu *hpb, int num_pinned_rgn,
+				   int queue_depth)
+{
+	struct ufs_hba *hba;
+	struct ufshpb_rsp_info *rsp_info = NULL;
+	struct ufshpb_req_info *req_info = NULL;
+	struct ufshpb_map_req *map_req = NULL;
+	int i, map_req_cnt = 0;
+
+	hba = hpb->hba;
+
+	if (!queue_depth) {
+		queue_depth = hba->nutrs;
+		hpb_info("LU%d private queue depth is 0\n", hpb->lun);
+		hpb_info("LU%d HPB Req uses Shared Queue depth %d\n",
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
+	map_req_cnt = max(hpb->subregions_per_lu, queue_depth);
+
+	hpb->map_req = kcalloc(map_req_cnt, sizeof(struct ufshpb_map_req),
+			       GFP_KERNEL);
+	if (!hpb->map_req)
+		goto out_free_req;
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
+static void ufshpb_lu_constant_init(struct ufshpb_lu *hpb,
+				    struct ufshpb_lu_desc *lu_desc,
+				    struct ufshpb_func_desc *func_desc)
+{
+	unsigned long long region_size, region_entry_size;
+	unsigned long long last_subregion_size, last_region_size;
+	int entries_per_region;
+
+	region_size = (unsigned long long)
+		      SECTOR_SIZE * (0x01 << func_desc->hpb_region_size);
+	region_entry_size =
+		region_size / UFS_LOGICAL_BLOCK_SIZE * HPB_ENTRY_SIZE;
+
+	hpb->subregion_size = (unsigned long long)
+			SECTOR_SIZE * (0x01 << func_desc->hpb_subregion_size);
+	hpb->subregion_entry_size =
+		hpb->subregion_size / UFS_LOGICAL_BLOCK_SIZE * HPB_ENTRY_SIZE;
+
+	hpb->lu_max_active_regions = lu_desc->lu_max_active_hpb_regions;
+	hpb->lru_info.max_active_cnt = lu_desc->lu_max_active_hpb_regions -
+					lu_desc->lu_num_hpb_pinned_regions;
+	/*
+	 * relationship across LU,region,subregion,L2P entry:
+	 * lu -> region -> sub region -> entry
+	 */
+	hpb->lu_num_blocks = lu_desc->lu_logblk_cnt;
+	entries_per_region = region_entry_size / HPB_ENTRY_SIZE;
+	hpb->entries_per_subregion = hpb->subregion_entry_size /
+						HPB_ENTRY_SIZE;
+	hpb->subregions_per_region = region_entry_size /
+				hpb->subregion_entry_size;
+
+	hpb->subregions_in_last_region = hpb->subregions_per_region;
+	hpb->last_subregion_entry_size = hpb->subregion_entry_size;
+	/*
+	 * HPB Sub-Regions are equally sized except for the last one which is
+	 * smaller if the last HPB Region is not an interger multiple of
+	 * bHPBSubRegionSize
+	 */
+	last_region_size = (unsigned long long)
+			   hpb->lu_num_blocks * UFS_LOGICAL_BLOCK_SIZE %
+			   region_size;
+	if (last_region_size) {
+		last_subregion_size = (unsigned long long)
+				      last_region_size % hpb->subregion_size;
+		if (last_subregion_size) {
+			hpb->subregions_in_last_region = last_region_size /
+				hpb->subregion_size + 1;
+			hpb->last_subregion_entry_size =
+				last_subregion_size / UFS_LOGICAL_BLOCK_SIZE *
+				HPB_ENTRY_SIZE;
+		} else
+			hpb->subregions_in_last_region = last_region_size /
+				hpb->subregion_size;
+	}
+	/*
+	 * 1. regions_per_lu = (lu_num_blocks * 4096) / region_size
+	 *		= (lu_num_blocks * HPB_ENTRY_SIZE) / region_entry_size
+	 *		= lu_num_blocks / (region_entry_size / HPB_ENTRY_SIZE)
+	 *
+	 * 2. regions_per_lu = lu_num_blocks / subregion_entry_size (is trik...)
+	 *    if HPB_ENTRY_SIZE != subregions_per_region, it is error.
+	 */
+	hpb->regions_per_lu =
+		((unsigned long long)hpb->lu_num_blocks
+		 + (region_entry_size / HPB_ENTRY_SIZE) - 1)
+		/ (region_entry_size / HPB_ENTRY_SIZE);
+	hpb->subregions_per_lu =
+		((unsigned long long)hpb->lu_num_blocks
+		 + (hpb->subregion_entry_size / HPB_ENTRY_SIZE) - 1)
+		/ (hpb->subregion_entry_size / HPB_ENTRY_SIZE);
+
+	/* mempool info */
+	hpb->mpage_bytes = PAGE_SIZE;
+	hpb->mpages_per_subregion = hpb->subregion_entry_size /
+						hpb->mpage_bytes;
+	/* Bitmask Info. */
+	hpb->dwords_per_subregion = hpb->entries_per_subregion / BITS_PER_DWORD;
+	hpb->entries_per_region_shift = ffs(entries_per_region) - 1;
+	hpb->entries_per_region_mask = entries_per_region - 1;
+	hpb->entries_per_subregion_shift = ffs(hpb->entries_per_subregion) - 1;
+	hpb->entries_per_subregion_mask = hpb->entries_per_subregion - 1;
+
+	hpb_info("LU%d Total logical Block Count %d, region count %d\n",
+		 hpb->lun, hpb->lu_num_blocks, hpb->regions_per_lu);
+	hpb_info("LU%d Subregions count per lun %d\n",
+		 hpb->lun, hpb->subregions_per_lu);
+	hpb_info("LU%d Region size 0x%llx, Region L2P entry size 0x%llx\n",
+		 hpb->lun, region_size, region_entry_size);
+	hpb_info("LU%d Subregion size 0x%llx, subregion L2P entry size 0x%x\n",
+		 hpb->lun, hpb->subregion_size, hpb->subregion_entry_size);
+	hpb_info("LU%d Last region size 0x%llx, last subregion L2P entry %d\n",
+		 hpb->lun, last_region_size, hpb->last_subregion_entry_size);
+
+	hpb_info("LU%d Subregions per region %d\n", hpb->lun,
+		 hpb->subregions_per_region);
+	hpb_info("LU%d L2P entries per region %u shift %u mask 0x%x\n",
+		 hpb->lun, entries_per_region,
+		 hpb->entries_per_region_shift,
+		 hpb->entries_per_region_mask);
+	hpb_info("LU%d L2P entries per subregion %u shift %u mask 0x%x\n",
+		 hpb->lun, hpb->entries_per_subregion,
+		 hpb->entries_per_subregion_shift,
+		 hpb->entries_per_subregion_mask);
+	hpb_info("LU%d Count of mpage per subregion %d\n",
+		 hpb->lun, hpb->mpages_per_subregion);
+}
+
+static int ufshpb_lu_init(struct ufs_hba *hba, struct ufshpb_lu *hpb,
+			  struct ufshpb_func_desc *func_desc,
+			  struct ufshpb_lu_desc *lu_desc, int lun)
+{
+	struct ufshpb_region *region_table, *cb;
+	int subregions, subregion_count;
+	int region;
+	bool do_work_handler;
+	int ret = 0;
+	int j;
+
+	hpb->hba = hba;
+	hpb->lun = lun;
+	hpb->debug = 0;
+	hpb->lu_hpb_enable = true;
+
+	ufshpb_lu_constant_init(hpb, lu_desc, func_desc);
+
+	region_table = kcalloc(hpb->regions_per_lu,
+			       sizeof(struct ufshpb_region),
+			       GFP_KERNEL);
+	if (!region_table)
+		goto out;
+
+	hpb_info("LU%d region table size: %lu bytes\n", lun,
+		 (sizeof(struct ufshpb_region) * hpb->regions_per_lu));
+
+	hpb->region_tbl = region_table;
+
+	spin_lock_init(&hpb->hpb_lock);
+	spin_lock_init(&hpb->rsp_list_lock);
+	spin_lock_init(&hpb->req_list_lock);
+
+	/* initialize loacl active region info lru */
+	INIT_LIST_HEAD(&hpb->lru_info.lru);
+	hpb->lru_info.selection_type = LRU;
+
+	INIT_LIST_HEAD(&hpb->lh_subregion_req);
+
+	ret = ufshpb_mctx_mempool_init(hpb, lu_desc->lu_max_active_hpb_regions,
+				       hpb->subregions_per_region,
+				       hpb->entries_per_subregion,
+				       HPB_ENTRY_SIZE);
+	if (ret) {
+		hpb_err("mapping ctx mempool init fail!\n");
+		goto release_mempool;
+	}
+
+	ret = ufshpb_req_mempool_init(hpb, lu_desc->lu_num_hpb_pinned_regions,
+				      lu_desc->lu_queue_depth);
+	if (ret) {
+		hpb_err("req&rsp mempool init fail!\n");
+		goto release_mempool;
+	}
+
+	subregions = hpb->subregions_per_lu;
+
+	ufshpb_init_jobs(hpb);
+
+	subregion_count = 0;
+	subregions = hpb->subregions_per_lu;
+	for (region = 0; region < hpb->regions_per_lu; region++) {
+		cb = region_table + region;
+
+		/* Initialize logic unit region information */
+		INIT_LIST_HEAD(&cb->list_region);
+		cb->hit_count = 0;
+		cb->region = region;
+
+		subregion_count = min(subregions,
+				      hpb->subregions_per_region);
+
+		ret = ufshpb_alloc_subregion_tbl(hpb, cb, subregion_count);
+		if (ret) {
+			hpb_err("Error while allocating subregion_tbl\n");
+			goto release_subregion_tbl;
+		}
+		ufshpb_init_subregion_tbl(hpb, cb);
+
+		if (ufshpb_is_pinned_region(lu_desc, region)) {
+			hpb_info("Region %d PINNED(%d ~ %d)\n", region,
+				 lu_desc->hpb_pinned_region_startidx,
+				 lu_desc->lu_hpb_pinned_end_offset);
+			ret = ufshpb_init_pinned_region(hpb, cb);
+			if (ret)
+				goto release_subregion_tbl;
+
+			do_work_handler = true;
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
+	hpb_info("LU%d subregions info table takes memory %lu bytes\n", lun,
+		 sizeof(struct ufshpb_subregion) * hpb->subregions_per_lu);
+
+	if (do_work_handler)
+		schedule_work(&hpb->ufshpb_sync_work);
+
+	/*
+	 * Even if creating sysfs failed, ufshpb could run normally.
+	 * so we don't deal with error handling
+	 */
+	ufshpb_create_sysfs(hba, hpb);
+	return 0;
+
+release_subregion_tbl:
+	for (j = 0; j < region; j++) {
+		cb = region_table + j;
+		ufshpb_destroy_subregion_tbl(hpb, cb);
+	}
+release_mempool:
+	ufshpb_req_mempool_remove(hpb);
+	ufshpb_mctx_mempool_remove(hpb);
+	kfree(region_table);
+out:
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
+	hpb_info("LU%d bLuQueueDepth %d\n", lun, lu_desc->lu_queue_depth);
+	hpb_info("LU%d bLogicalBlockSize %d\n", lun, lu_desc->lu_logblk_size);
+	hpb_info("LU%d qLogicalBlockCount %llu\n", lun, lu_desc->lu_logblk_cnt);
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
+	} else
+		lu_desc->lu_hpb_pinned_end_offset = -1;
+
+	return 0;
+}
+
+static int ufshpb_read_geo_desc_support(struct ufs_hba *hba,
+					struct ufshpb_func_desc *desc)
+{
+	int err;
+	u8 *geo_buf;
+	size_t buff_len;
+
+	buff_len = max_t(size_t, hba->desc_size.geom_desc,
+			 QUERY_DESC_MAX_SIZE);
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
+	desc->hpb_device_max_active_regions =
+		(u16) SHIFT_BYTE_1(geo_buf[GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS]) |
+		(u16) SHIFT_BYTE_0(geo_buf[GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS + 1]);
+
+	if (desc->hpb_number_lu == 0) {
+		hpb_warn("There is no LU which supports HPB\n");
+		err = -ENODEV;
+	}
+	dev_dbg(hba->dev, "bHPBRegionSize: %u\n", desc->hpb_region_size);
+	dev_dbg(hba->dev, "bHPBNumberLU: %u\n", desc->hpb_number_lu);
+	dev_dbg(hba->dev, "bHPBSubRegionSize: %u\n", desc->hpb_subregion_size);
+	dev_dbg(hba->dev, "wDeviceMaxActiveHPBRegions: %u\n",
+		desc->hpb_device_max_active_regions);
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
+	 * FIXME, so far, we don't have a optimal restoring solution，
+	 * in case of fatal error happenningn. current soltion is that
+	 * simply kills HPB, in order to not impact normal read.
+	 */
+
+	hpb_warn("UFSHPB driver has failed, UFSHCD will run without HPB\n");
+
+	ufshpb_release(hba, HPB_FAILED);
+}
+
+static int ufshpb_exec_init(struct ufs_hba *hba)
+{
+	struct ufshpb_func_desc func_desc;
+	int lun, ret = 1, i;
+	int hpb_dev = 0;
+
+	if (!(hba->dev_info.ufs_features & UFS_FEATURE_SUPPORT_HPB_BIT))
+		goto out;
+
+	ret = ufshpb_read_geo_desc_support(hba, &func_desc);
+	if (ret)
+		goto out;
+
+	ufshpb_init_constant();
+
+	for (lun = 0; lun < hba->dev_info.max_lu_supported; lun++) {
+		struct ufshpb_lu_desc lu_desc;
+
+		hba->ufshpb_lup[lun] = NULL;
+
+		ret = ufshpb_get_hpb_lu_desc(hba, &lu_desc, lun);
+		if (ret)
+			goto out;
+
+		if (lu_desc.lu_hpb_enable == false) {
+			hpb_info("LU%d HPB is disabled\n", lun);
+			continue;
+		}
+
+		hba->ufshpb_lup[lun] =
+			kzalloc(sizeof(struct ufshpb_lu), GFP_KERNEL);
+		if (!hba->ufshpb_lup[lun])
+			goto out_free_mem;
+
+		ret = ufshpb_lu_init(hba, hba->ufshpb_lup[lun],
+				     &func_desc, &lu_desc, lun);
+		if (ret) {
+			if (ret == -ENODEV)
+				continue;
+			else
+				goto out_free_mem;
+		}
+		hpb_dev++;
+		hpb_info("LU%d HPB is working now\n", lun);
+	}
+
+	if (hpb_dev == 0) {
+		hpb_warn("No UFSHPB LU to init\n");
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
+	for (i = 0; i < hba->dev_info.max_lu_supported; i++)
+		kfree(hba->ufshpb_lup[i]);
+out:
+	hba->ufshpb_state = HPB_NOT_SUPPORTED;
+	return ret;
+}
+
+static void ufshpb_map_loading_trigger(struct ufshpb_lu *hpb,
+				       bool dirty, bool only_pinned)
+{
+	int region, subregion;
+	bool do_sync_work = false;
+
+	for (region = 0; region < hpb->regions_per_lu; region++) {
+		struct ufshpb_region *cb;
+		struct ufshpb_subregion *cp;
+
+		cb = hpb->region_tbl + region;
+		if (cb->region_state == REGION_ACTIVE ||
+		    cb->region_state == REGION_PINNED) {
+			if ((only_pinned &&
+			     cb->region_state == REGION_PINNED) ||
+			    !only_pinned) {
+				hpb_dbg(REGION_INFO, hpb,
+					"Add active region %d state %d\n",
+					region, cb->region_state);
+				spin_lock_bh(&hpb->hpb_lock);
+				for (subregion = 0;
+				     subregion < cb->subregion_count;
+				     subregion++) {
+					cp = cb->subregion_tbl + subregion;
+					ufshpb_add_subregion_to_req_list(hpb,
+									 cp);
+				}
+				spin_unlock_bh(&hpb->hpb_lock);
+				do_sync_work = true;
+			}
+
+			if (dirty) {
+				for (subregion = 0;
+				     subregion < cb->subregion_count;
+				     subregion++) {
+					cp = cb->subregion_tbl + subregion;
+					cp->subregion_state = SUBREGION_DIRTY;
+				}
+			}
+
+		}
+	}
+
+	if (do_sync_work)
+		schedule_work(&hpb->ufshpb_sync_work);
+}
+
+static void ufshpb_purge_active_region(struct ufshpb_lu *hpb)
+{
+	int region, subregion;
+	int state;
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+
+	spin_lock_bh(&hpb->hpb_lock);
+	for (region = 0; region < hpb->regions_per_lu; region++) {
+		cb = hpb->region_tbl + region;
+
+		if (cb->region_state == REGION_INACTIVE) {
+			hpb_dbg(REGION_INFO, hpb,
+					"region %d is inactive\n", region);
+			continue;
+		}
+		if (cb->region_state == REGION_PINNED) {
+			state = SUBREGION_DIRTY;
+		} else if (cb->region_state == REGION_ACTIVE) {
+			state = SUBREGION_UNUSED;
+			ufshpb_cleanup_lru_info(hpb, cb);
+		} else {
+			hpb_notice("Unsupported region state %d\n",
+					cb->region_state);
+			continue;
+		}
+
+		for (subregion = 0; subregion < cb->subregion_count;
+				subregion++) {
+			cp = cb->subregion_tbl + subregion;
+			ufshpb_subregion_mctx_purge(hpb, cp, state);
+		}
+		hpb_dbg(REGION_INFO, hpb, "region %d state %d free_mctx %d",
+				region, state, hpb->free_mctx);
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
+	for (region = 0; region < hpb->regions_per_lu; region++) {
+		struct ufshpb_region *cb;
+
+		cb = hpb->region_tbl + region;
+		hpb_info("Region %d state %d\n", region,
+			 cb->region_state);
+
+		if (cb->region_state == REGION_PINNED ||
+		    cb->region_state == REGION_ACTIVE) {
+			cb->region_state = REGION_INACTIVE;
+
+			ufshpb_destroy_subregion_tbl(hpb, cb);
+		}
+	}
+
+	ufshpb_mctx_mempool_remove(hpb);
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
+		hpb_err("Descriptor Type: 0x%x\n",
+			sense_data->desc_type);
+		hpb_err("Additional Length: 0x%x\n",
+			sense_data->additional_len);
+		hpb_err("HPB Operation: 0x%x\n",
+			sense_data->hpb_op);
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
+	struct ufs_hba *hba;
+	struct delayed_work *dwork = to_delayed_work(work);
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
+	if (hba->ufshpb_state == HPB_NEED_INIT) {
+		err = ufshpb_exec_init(hba);
+		if (err) {
+			hpb_warn("%s failed, err %d, UFS runs without HPB\n",
+				 __func__, err);
+		}
+	} else if (hba->ufshpb_state == HPB_NEED_RESET) {
+		ufshpb_reset(hba);
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
+		kobject_uevent(&hpb->kobj, KOBJ_REMOVE);
+		kobject_del(&hpb->kobj);
+
+		kfree(hpb);
+	}
+
+	if (alloc_mctx != 0)
+		hpb_warn("Warning: mctx not released thoroughly %d",
+			 alloc_mctx);
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
+	BUG_ON(!lrbp);
+	BUG_ON(!lrbp->ucd_rsp_ptr);
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
+	BUG_ON(!sense_data);
+
+	if (!ufshpb_sense_data_checkup(hba, sense_data))
+		return;
+
+	hpb = hba->ufshpb_lup[lrbp->lun];
+	if (!hpb) {
+		hpb_warn("%s LU%d didn't allocated HPB\n", __func__,
+			 lrbp->lun);
+		return;
+	}
+
+	hpb_dbg(REGION_INFO, hpb,
+			"RSP UPIU for LU%d: HPB OP %d, Data Len 0x%x\n",
+			sense_data->lun,  sense_data->hpb_op, data_seg_len);
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
+		hpb_warn("%s:%d There is no free rsp_info\n",
+			 __func__, __LINE__);
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
+void ufshpb_retrieve_l2p_entry(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
+	int do_req_workq = 0;
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
+	 * Convert sector address(in 512B unit) to block
+	 * address (in 4KB unit), since minimum Logical
+	 * block size supported by HPB is 4KB.
+	 */
+	rq = lrbp->cmd->request;
+	rq_pos = blk_rq_pos(rq);
+	rq_sectors = blk_rq_sectors(rq);
+	lpn = rq_pos / SECTORS_PER_BLOCK;
+
+	/* Get region, subregion and offset according to page address */
+	ufshpb_get_pos_from_lpn(hpb, lpn, &region,
+				&subregion, &subregion_offset);
+	cb = hpb->region_tbl + region;
+
+	/*
+	 * For the host control mode, we need to watch out
+	 * for the write/discard requst.
+	 */
+	if (hba->dev_info.hpb_control_mode == HPB_HOST_CTRL_MODE &&
+	    ufshpb_is_write_discard_lrbp(lrbp)) {
+		spin_lock_bh(&hpb->hpb_lock);
+
+		if (cb->region_state == REGION_INACTIVE) {
+			spin_unlock_bh(&hpb->hpb_lock);
+			return;
+		}
+		ufshpb_l2p_entry_dirty_set(hpb, lrbp, region,
+					   subregion, subregion_offset);
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
+			 * read_counter and wake up req_workq
+			 */
+			if (atomic_read(&cp->read_counter) < 0xffffffff)
+				atomic_inc(&cp->read_counter);
+
+			if (atomic_read(&cp->read_counter) >=
+			    HPB_READ_THREASHOLD) {
+				if (!ufshpb_subregion_register(hpb, cp))
+					do_req_workq = 1;
+			}
+		}
+		spin_unlock_bh(&hpb->hpb_lock);
+		if (do_req_workq) {
+			hpb_dbg(SCHEDULE_INFO, hpb,
+				"Schedule req_workq to activate RG_SRG %d:%d\n",
+				cp->region, cp->subregion);
+			schedule_work(&hpb->ufshpb_req_work);
+		}
+		return;
+	}
+
+	if (rq_sectors >  SECTORS_PER_BLOCK) {
+		/*
+		 * This version (HPB 1.0) only supports 4KB logical
+		 * block size storage devices.
+		 */
+		spin_unlock_bh(&hpb->hpb_lock);
+		return;
+	}
+
+	if (ufshpb_l2p_entry_dirty_check(hpb, cp, subregion_offset)) {
+		atomic64_inc(&hpb->status.entry_dirty_miss);
+		hpb_dbg(REGION_INFO, hpb,
+			"0x%llx + %u HPB PPN Dirty %d - %d\n",
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
+	ufshpb_prepare_ppn(hpb, lrbp, ppn, blk_cnt);
+	hpb_trace(hpb, "%s: %llu + %u HPB READ %d - %d", DRIVER_NAME, rq_pos,
+		  rq_sectors, region, subregion);
+	hpb_dbg(NORMAL_INFO, hpb,
+		"PPN:0x%llx, LA:0x%llx + %u HPB READ from RG %d - SRG %d",
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
+static ssize_t ufshpb_sysfs_debug_release_store(struct ufshpb_lu *hpb,
+		const char *buf, size_t count)
+{
+	unsigned long value;
+
+	hpb_info("Start HPB Release FUNC");
+
+	if (kstrtoul(buf, 0, &value)) {
+		hpb_err("kstrtoul error");
+		return -EINVAL;
+	}
+
+	if (value == 0) {
+		hpb_info("LU%d HPB will be killed manually", hpb->lun);
+		goto kill_hpb;
+	} else {
+		hpb_info("Unrecognize value inputted %lu", value);
+	}
+
+	return count;
+kill_hpb:
+	hpb->hba->ufshpb_state = HPB_FAILED;
+	schedule_work(&hpb->hba->ufshpb_eh_work);
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_info_lba_store(struct ufshpb_lu *hpb,
+		const char *buf, size_t count)
+{
+	unsigned long long ppn;
+	unsigned long value;
+	unsigned int lpn;
+	int region, subregion, subregion_offset;
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	int dirty;
+
+	if (kstrtoul(buf, 0, &value)) {
+		hpb_err("kstrtoul error\n");
+		return -EINVAL;
+	}
+
+	if (value > hpb->lu_num_blocks * SECTORS_PER_BLOCK) {
+		hpb_err("Error: value %lu > lu_num_blocks %d\n",
+			value, hpb->lu_num_blocks);
+		return -EINVAL;
+	}
+	lpn = value / SECTORS_PER_BLOCK;
+
+	ufshpb_get_pos_from_lpn(hpb, lpn, &region, &subregion,
+				&subregion_offset);
+
+	cb = hpb->region_tbl + region;
+	cp = cb->subregion_tbl + subregion;
+
+	if (cb->region_state != REGION_INACTIVE) {
+		ppn = ufshpb_get_ppn(cp->mctx, subregion_offset);
+		spin_lock_bh(&hpb->hpb_lock);
+		dirty = ufshpb_l2p_entry_dirty_check(hpb, cp, subregion_offset);
+		spin_unlock_bh(&hpb->hpb_lock);
+	} else {
+		ppn = 0;
+		dirty = -1;
+	}
+
+	hpb_info("sector %lu region %d state %d subregion %d state %d",
+		   value, region, cb->region_state, subregion,
+		   cp->subregion_state);
+	hpb_info("sector %lu lpn %u ppn %llx dirty %d",
+		   value, lpn, ppn, dirty);
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_map_req_show(struct ufshpb_lu *hpb, char *buf)
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
+		const char *buf, size_t count)
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
+	int ret = 0, count = 0, region;
+
+	ret = sprintf(buf, " ACTIVE Region List:\n");
+	count = ret;
+
+	for (region = 0; region < hpb->regions_per_lu; region++) {
+		if (hpb->region_tbl[region].region_state == REGION_ACTIVE ||
+		    hpb->region_tbl[region].region_state == REGION_PINNED) {
+			ret = sprintf(buf + count, "%d ", region);
+			count += ret;
+		}
+	}
+
+	ret = sprintf(buf + count, "\n");
+	count += ret;
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_subregion_status_show(struct ufshpb_lu *hpb,
+						  char *buf)
+{
+	int ret = 0, count = 0, region, sub;
+	struct ufshpb_region *cb;
+	int state;
+
+	ret = sprintf(buf, "Clean Subregion List:\n");
+	count = ret;
+
+	for (region = 0; region < hpb->regions_per_lu; region++) {
+		cb = hpb->region_tbl + region;
+		for (sub = 0;
+		     sub < cb->subregion_count;
+		     sub++) {
+			state = cb->subregion_tbl[sub].subregion_state;
+			if (state == SUBREGION_CLEAN) {
+				ret = sprintf(buf + count, "%d:%d ",
+					      region, sub);
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
+	if (debug >= 0)
+		hpb->debug = debug;
+	else
+		hpb->debug = 0;
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_debug_show(struct ufshpb_lu *hpb, char *buf)
+{
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",	hpb->debug);
+}
+
+static ssize_t ufshpb_sysfs_map_loading_store(struct ufshpb_lu *hpb,
+		const char *buf, size_t count)
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
+		ufshpb_map_loading_trigger(hpb, false, false);
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_map_disable_show(struct ufshpb_lu *hpb, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE,
+			">> force_map_req_disable: %d\n",
+			hpb->force_map_req_disable);
+}
+
+static ssize_t ufshpb_sysfs_map_disable_store(struct ufshpb_lu *hpb,
+		const char *buf, size_t count)
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
+		hpb_err("Error value: %lu", value);
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_disable_show(struct ufshpb_lu *hpb, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE,
+			"LU%d  HPB force_disable: %d\n",
+			hpb->lun, hpb->force_disable);
+}
+
+static ssize_t ufshpb_sysfs_disable_store(struct ufshpb_lu *hpb,
+		const char *buf, size_t count)
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
+static int global_region;
+
+static inline bool is_region_active(struct ufshpb_lu *hpb, int region)
+{
+	if (hpb->region_tbl[region].region_state == REGION_ACTIVE ||
+	    hpb->region_tbl[region].region_state == REGION_PINNED)
+		return true;
+
+	return false;
+}
+
+static ssize_t ufshpb_sysfs_active_group_store(struct ufshpb_lu *hpb,
+		const char *buf, size_t count)
+{
+	unsigned long block;
+	int region;
+
+	if (kstrtoul(buf, 0, &block))
+		return -EINVAL;
+
+	region = block >> hpb->entries_per_region_shift;
+	if (region >= hpb->regions_per_lu) {
+		hpb_err("Region %d exceeds max %d", region,
+			hpb->regions_per_lu);
+		region = hpb->regions_per_lu - 1;
+	}
+
+	global_region = region;
+
+	hpb_info("block %lu region %d active %d",
+		   block, region, is_region_active(hpb, region));
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_active_group_show(struct ufshpb_lu *hpb, char *buf)
+{
+
+	return snprintf(buf, PAGE_SIZE,
+			"Region %d: %d\n", global_region,
+			is_region_active(hpb, global_region));
+}
+
+static struct ufshpb_sysfs_entry ufshpb_sysfs_entries[] = {
+	__ATTR(is_active_group, 0644,
+	       ufshpb_sysfs_active_group_show, ufshpb_sysfs_active_group_store),
+	__ATTR(bypass_hpb, 0644,
+	       ufshpb_sysfs_disable_show, ufshpb_sysfs_disable_store),
+	__ATTR(map_cmd_disable, 0644,
+	       ufshpb_sysfs_map_disable_show, ufshpb_sysfs_map_disable_store),
+	__ATTR(sync_active_region, 0200, NULL, ufshpb_sysfs_map_loading_store),
+	__ATTR(debug, 0644, ufshpb_sysfs_debug_show,
+	       ufshpb_sysfs_debug_store),
+	__ATTR(active_subregion, 0444, ufshpb_sysfs_subregion_status_show,
+	       NULL),
+	__ATTR(total_hit_count, 0444, ufshpb_sysfs_hit_show, NULL),
+	__ATTR(miss_count, 0444, ufshpb_sysfs_miss_show, NULL),
+	__ATTR(active_region, 0444, ufshpb_sysfs_active_region_show, NULL),
+	__ATTR(region_add_evict_count, 0444, ufshpb_sysfs_add_evict_show, NULL),
+	__ATTR(count_reset, 0200, NULL, ufshpb_sysfs_count_reset_store),
+	__ATTR(rsq_req_count, 0444, ufshpb_sysfs_map_req_show, NULL),
+	__ATTR(get_info_from_lba, 0200, NULL, ufshpb_sysfs_info_lba_store),
+	__ATTR(kill_hpb, 0200, NULL, ufshpb_sysfs_debug_release_store),
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
+	err = kobject_add(&hpb->kobj, kobject_get(&dev->kobj),
+			  "ufshpb_lu%d", hpb->lun);
+	if (!err) {
+		for (entry = hpb->sysfs_entries; entry->attr.name != NULL;
+		     entry++) {
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
index 000000000000..56f14bc89218
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -0,0 +1,421 @@
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
+#define hpb_dbg(level, hpb, fmt, ...)				\
+do {								\
+	if (hpb == NULL)					\
+		break;						\
+	if (hpb->debug >= HPB_DBG_MAX || hpb->debug == level)	\
+		pr_notice("%s: %s():" fmt,			\
+			DRIVER_NAME, __func__, ##__VA_ARGS__);	\
+} while (0)
+
+/* HPB control mode */
+#define HPB_HOST_CTRL_MODE		0x00
+#define HPB_DEV_CTRL_MODE		0x01
+
+/*
+ * The default read count threashold before activating subregion.
+ * Used in HPB host control mode.
+ */
+#define HPB_READ_THREASHOLD		10
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
+//#define REGION_UNIT_SIZE(bit_offset)	(0x01 << (bit_offset))
+#define MAX_BVEC_SIZE 128
+
+enum UFSHPB_STATE {
+	HPB_PRESENT = 1,
+	HPB_NOT_SUPPORTED,
+	HPB_FAILED,
+	HPB_NEED_INIT,
+	HPB_NEED_RESET,
+};
+
+enum HPBREGION_STATE {
+	REGION_INACTIVE,
+	REGION_ACTIVE,
+	REGION_PINNED,
+};
+
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
+struct ufshpb_func_desc {
+	/*** Geometry Descriptor ***/
+	/* 48h bHPBRegionSize (UNIT: 512B) */
+	u8 hpb_region_size;
+	/* 49h bHPBNumberLU */
+	u8 hpb_number_lu;
+	/* 4Ah bHPBSubRegionSize */
+	u8 hpb_subregion_size;
+	/* 4B:4Ch wDeviceMaxActiveHPBRegions */
+	u16 hpb_device_max_active_regions;
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
+ * HPB response information
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
+ * HPB request info to activate/deactivate subregion/region
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
+struct ufshpb_map_req {
+	struct ufshpb_lu *hpb;
+	struct ufshpb_map_ctx *mctx;
+	struct request *req;
+	struct bio bio;
+	struct bio_vec bvec[MAX_BVEC_SIZE];/* FIXME */
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
+	__u64 req_endio_t;
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
+	/* Maximum active regions supported, doesn't include pinned regions */
+	int max_active_cnt;
+	/* Current Active region count */
+	atomic64_t active_cnt;
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
+	/* HPB L2P mapping request memory, the count = subregions_per_lu */
+	struct ufshpb_map_req *map_req;
+	struct list_head lh_map_req_free;
+
+	/* The map_req list for map_req needed to retry */
+	struct list_head lh_map_req_retry;
+
+	/* mapping memory context = num_regions * subregions_per_region */
+	struct list_head lh_map_ctx;
+	int free_mctx;
+
+	struct list_head lh_subregion_req;
+
+	/* Active regions info list */
+	struct active_region_info lru_info;
+
+	struct work_struct ufshpb_sync_work;
+	struct work_struct ufshpb_req_work;
+	struct delayed_work retry_work;
+	struct work_struct ufshpb_rsp_work;
+
+	int subregions_per_lu;
+	int regions_per_lu;
+	/* entry size in byte per subregion */
+	int subregion_entry_size;
+	int last_subregion_entry_size;
+	int lu_max_active_regions;
+	int entries_per_subregion;
+	int entries_per_subregion_shift;
+	int entries_per_subregion_mask;
+	int entries_per_region_shift;
+	int entries_per_region_mask;
+	int subregions_per_region;
+	int subregions_in_last_region;
+	int dwords_per_subregion;
+	unsigned long long subregion_size;
+	int mpage_bytes;
+	int mpages_per_subregion;
+	/* Total number of addressable logical blocks in the logical unit */
+	int lu_num_blocks;
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
+void ufshpb_retrieve_l2p_entry(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufshpb_rsp_handler(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufshpb_release(struct ufs_hba *hba, enum UFSHPB_STATE state);
+void ufshpb_init(struct ufs_hba *hba);
+
+#endif /* End of Header */
-- 
2.17.1

