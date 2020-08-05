Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E782FC433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 05:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894382245C
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 05:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N4KMZBnt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgHEFaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 01:30:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59057 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgHEFaK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 01:30:10 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200805053002epoutp0394735eae2278f90325ee32887f36d786~oSCedQ1Go2468024680epoutp03H
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 05:30:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200805053002epoutp0394735eae2278f90325ee32887f36d786~oSCedQ1Go2468024680epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596605402;
        bh=5nHtKBzUhVjjJWTUpXEYKifCRlUJdq3x2e0GxooyEQU=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=N4KMZBntJzepJwsHOpQfg8kEv1lhHBFzFS+NpS6U1t07p9Xcn6c3mEXWenvd8od8w
         OCLysC8lPPpeUJ6hnPoN7CaPWQ8gMRDC1P7G5/XvK0nxai1i4etFA8NajI8hB8R/v8
         l4/phKVG+5/yqCoOZMnB2dwFBgdgU/l9B3z68Mro=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200805053002epcas1p1df1aec1ff317898e5348106414281b9e~oSCd0Ym2f0646206462epcas1p1S;
        Wed,  5 Aug 2020 05:30:02 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH v7 2/4] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <231786897.01596604981993.JavaMail.epsvc@epcpadp2>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21596605402187.JavaMail.epsvc@epcpadp1>
Date:   Wed, 05 Aug 2020 14:25:24 +0900
X-CMS-MailID: 20200805052524epcms2p5ae9a7922e6dee2ca488489bced803a9d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200805033750epcms2p3fd74b94500593df38d50e1bf426c2347
References: <231786897.01596604981993.JavaMail.epsvc@epcpadp2>
        <231786897.01596600181895.JavaMail.epsvc@epcpadp2>
        <CGME20200805033750epcms2p3fd74b94500593df38d50e1bf426c2347@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a patch for the HPB feature.
This patch adds HPB function calls to UFS core driver.

The mininum size of the memory pool used in the HPB is implemented as a
Kconfig parameter (SCSI_UFS_HPB_HOST_MEM), so that it can be configurable.

Reviewed-by: Can Guo <cang@codeaurora.org>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/Kconfig  |  18 +
 drivers/scsi/ufs/Makefile |   1 +
 drivers/scsi/ufs/ufshcd.c |  42 +++
 drivers/scsi/ufs/ufshcd.h |   9 +
 drivers/scsi/ufs/ufshpb.c | 738 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h | 169 +++++++++
 6 files changed, 977 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index f6394999b98c..33296478f411 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -182,3 +182,21 @@ config SCSI_UFS_CRYPTO
 	  Enabling this makes it possible for the kernel to use the crypto
 	  capabilities of the UFS device (if present) to perform crypto
 	  operations on data being transferred to/from the device.
+
+config SCSI_UFS_HPB
+	bool "Support UFS Host Performance Booster"
+	depends on SCSI_UFSHCD
+	help
+	  A UFS HPB Feature improves random read performance. It caches
+	  L2P map of UFS to host DRAM. The driver uses HPB read command
+	  by piggybacking physical page number for bypassing FTL's L2P address
+	  translation.
+
+config SCSI_UFS_HPB_HOST_MEM
+	int "Host-side cached memory size (KB) for HPB support"
+	default 32
+	depends on SCSI_UFS_HPB
+	help
+	  The mininum size of the memory pool used in the HPB module. It can
+	  be configurable by the user. If this value is larger than required
+	  memory size, kernel resizes cached memory size.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 4679af1b564e..663e17cee359 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) += ufshcd-crypto.o
+ufshcd-core-$(CONFIG_SCSI_UFS_HPB) += ufshpb.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cdff7e5ee588..a99afdcf8dc0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -234,6 +234,17 @@ static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 
+#ifndef CONFIG_SCSI_UFS_HPB
+static void ufshpb_resume(struct ufs_hba *hba) {}
+static void ufshpb_suspend(struct ufs_hba *hba) {}
+static void ufshpb_reset(struct ufs_hba *hba) {}
+static void ufshpb_reset_host(struct ufs_hba *hba) {}
+static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
+static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
+static void ufshpb_remove(struct ufs_hba *hba) {}
+static void ufshpb_scan_feature(struct ufs_hba *hba) {}
+#endif
+
 static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
 {
 	return tag >= 0 && tag < hba->nutrs;
@@ -2559,6 +2570,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
+	ufshpb_prep(hba, lrbp);
+
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
@@ -4681,6 +4694,19 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 	return scsi_change_queue_depth(sdev, depth);
 }
 
+static void ufshcd_hpb_configure(struct ufs_hba *hba, struct scsi_device *sdev)
+{
+	/* skip well-known LU */
+	if (sdev->lun >= UFS_UPIU_MAX_UNIT_NUM_ID)
+		return;
+
+	if (!(hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT))
+		return;
+
+	atomic_inc(&hba->ufsf.slave_conf_cnt);
+	wake_up(&hba->ufsf.sdev_wait);
+}
+
 /**
  * ufshcd_slave_configure - adjust SCSI device configurations
  * @sdev: pointer to SCSI device
@@ -4690,6 +4716,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 
+	ufshcd_hpb_configure(hba, sdev);
+
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
@@ -4818,6 +4846,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 				 */
 				pm_runtime_get_noresume(hba->dev);
 			}
+
+			if (scsi_status == SAM_STAT_GOOD)
+				ufshpb_rsp_upiu(hba, lrbp);
 			break;
 		case UPIU_TRANSACTION_REJECT_UPIU:
 			/* TODO: handle Reject UPIU Response */
@@ -6569,6 +6600,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 * Stop the host controller and complete the requests
 	 * cleared by h/w
 	 */
+	ufshpb_reset_host(hba);
+
 	ufshcd_hba_stop(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -7003,6 +7036,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	/* getting Specification Version in big endian format */
 	dev_info->wspecversion = desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
 				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
+	dev_info->b_ufs_feature_sup = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
 
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
@@ -7373,6 +7407,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	}
 
 	ufs_bsg_probe(hba);
+	ufshpb_scan_feature(hba);
 	scsi_scan_host(hba->host);
 	pm_runtime_put_sync(hba->dev);
 
@@ -7461,6 +7496,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
+	ufshpb_reset(hba);
 out:
 
 	trace_ufshcd_init(dev_name(hba->dev), ret,
@@ -8218,6 +8254,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		req_link_state = UIC_LINK_OFF_STATE;
 	}
 
+	ufshpb_suspend(hba);
+
 	/*
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
@@ -8339,6 +8377,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
 	ufshcd_release(hba);
+	ufshpb_resume(hba);
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
@@ -8435,6 +8474,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
+	ufshpb_resume(hba);
+
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		hba->dev_info.b_rpm_dev_flush_capable = false;
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
@@ -8659,6 +8700,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
+	ufshpb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_cleanup_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b2ef18f1b746..904c19796e09 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -47,6 +47,9 @@
 #include "ufs.h"
 #include "ufs_quirks.h"
 #include "ufshci.h"
+#ifdef CONFIG_SCSI_UFS_HPB
+#include "ufshpb.h"
+#endif
 
 #define UFSHCD "ufshcd"
 #define UFSHCD_DRIVER_VERSION "0.2"
@@ -579,6 +582,11 @@ struct ufs_hba_variant_params {
 	u32 wb_flush_threshold;
 };
 
+struct ufsf_feature_info {
+	atomic_t slave_conf_cnt;
+	wait_queue_head_t sdev_wait;
+};
+
 /**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
@@ -757,6 +765,7 @@ struct ufs_hba {
 	bool wb_enabled;
 	struct delayed_work rpm_dev_flush_recheck_work;
 
+	struct ufsf_feature_info ufsf;
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 	union ufs_crypto_capabilities crypto_capabilities;
 	union ufs_crypto_cap_entry *crypto_cap_array;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
new file mode 100644
index 000000000000..e1f9c68ae415
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -0,0 +1,738 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
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
+#include <asm/unaligned.h>
+#include <linux/async.h>
+
+#include "ufshcd.h"
+#include "ufshpb.h"
+
+/* SYSFS functions */
+#define ufshpb_sysfs_attr_show_func(__name)				\
+static ssize_t __name##_show(struct ufshpb_lu *hpb, char *buf)		\
+{									\
+	return snprintf(buf, PAGE_SIZE, "%d\n",			\
+			atomic_read(&hpb->stats.__name));		\
+}
+
+#define HPB_ATTR_RO(_name) \
+	struct ufshpb_sysfs_entry hpb_attr_##_name = __ATTR_RO(_name)
+
+/* HPB enabled lu list */
+static LIST_HEAD(lh_hpb_lu);
+
+static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb);
+
+static inline int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
+			     struct ufshpb_subregion *srgn)
+{
+	return rgn->rgn_state != HPB_RGN_INACTIVE &&
+		srgn->srgn_state == HPB_SRGN_VALID;
+}
+
+static inline int ufshpb_get_state(struct ufshpb_lu *hpb)
+{
+	return atomic_read(&hpb->hpb_state);
+}
+
+static inline void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
+{
+	atomic_set(&hpb->hpb_state, state);
+}
+
+void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+}
+
+void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+}
+
+static void ufshpb_init_subregion_tbl(struct ufshpb_lu *hpb,
+				      struct ufshpb_region *rgn)
+{
+	int srgn_idx;
+
+	for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt; srgn_idx++) {
+		struct ufshpb_subregion *srgn = rgn->srgn_tbl + srgn_idx;
+
+		srgn->rgn_idx = rgn->rgn_idx;
+		srgn->srgn_idx = srgn_idx;
+		srgn->srgn_state = HPB_SRGN_UNUSED;
+	}
+}
+
+static inline int ufshpb_alloc_subregion_tbl(struct ufshpb_lu *hpb,
+					     struct ufshpb_region *rgn,
+					     int srgn_cnt)
+{
+	rgn->srgn_tbl = kvcalloc(srgn_cnt, sizeof(struct ufshpb_subregion),
+				 GFP_KERNEL);
+	if (!rgn->srgn_tbl)
+		return -ENOMEM;
+
+	rgn->srgn_cnt = srgn_cnt;
+	return 0;
+}
+
+static void ufshpb_init_lu_parameter(struct ufs_hba *hba,
+				     struct ufshpb_lu *hpb,
+				     struct ufshpb_dev_info *hpb_dev_info,
+				     struct ufshpb_lu_info *hpb_lu_info)
+{
+	u32 entries_per_rgn;
+	u64 rgn_mem_size;
+
+	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
+	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
+		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
+		: PINNED_NOT_SET;
+
+	rgn_mem_size = (1ULL << hpb_dev_info->rgn_size) * HPB_RGN_SIZE_UNIT
+		/ HPB_ENTRY_BLOCK_SIZE * HPB_ENTRY_SIZE;
+	hpb->srgn_mem_size = (1ULL << hpb_dev_info->srgn_size)
+		* HPB_RGN_SIZE_UNIT / HPB_ENTRY_BLOCK_SIZE * HPB_ENTRY_SIZE;
+
+	entries_per_rgn = rgn_mem_size / HPB_ENTRY_SIZE;
+	hpb->entries_per_rgn_shift = ilog2(entries_per_rgn);
+	hpb->entries_per_rgn_mask = entries_per_rgn - 1;
+
+	hpb->entries_per_srgn = hpb->srgn_mem_size /  HPB_ENTRY_SIZE;
+	hpb->entries_per_srgn_shift = ilog2(hpb->entries_per_srgn);
+	hpb->entries_per_srgn_mask = hpb->entries_per_srgn - 1;
+
+	hpb->srgns_per_rgn = rgn_mem_size / hpb->srgn_mem_size;
+
+	hpb->rgns_per_lu = DIV_ROUND_UP(hpb_lu_info->num_blocks,
+				(rgn_mem_size / HPB_ENTRY_SIZE));
+	hpb->srgns_per_lu = DIV_ROUND_UP(hpb_lu_info->num_blocks,
+				(hpb->srgn_mem_size / HPB_ENTRY_SIZE));
+
+	hpb->pages_per_srgn = hpb->srgn_mem_size / PAGE_SIZE;
+
+	dev_info(hba->dev, "ufshpb(%d): region memory size - %llu (bytes)\n",
+		 hpb->lun, rgn_mem_size);
+	dev_info(hba->dev, "ufshpb(%d): subregion memory size - %u (bytes)\n",
+		 hpb->lun, hpb->srgn_mem_size);
+	dev_info(hba->dev, "ufshpb(%d): total blocks per lu - %d\n",
+		 hpb->lun, hpb_lu_info->num_blocks);
+	dev_info(hba->dev, "ufshpb(%d): subregions per region - %d, regions per lu - %u",
+		 hpb->lun, hpb->srgns_per_rgn, hpb->rgns_per_lu);
+}
+
+static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
+{
+	struct ufshpb_region *rgn_table, *rgn;
+	int rgn_idx, i;
+	int ret = 0;
+
+	rgn_table = kvcalloc(hpb->rgns_per_lu, sizeof(struct ufshpb_region),
+			    GFP_KERNEL);
+	if (!rgn_table)
+		return -ENOMEM;
+
+	hpb->rgn_tbl = rgn_table;
+
+	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
+		int srgn_cnt = hpb->srgns_per_rgn;
+
+		rgn = rgn_table + rgn_idx;
+		rgn->rgn_idx = rgn_idx;
+
+		if (rgn_idx == hpb->rgns_per_lu - 1)
+			srgn_cnt = ((hpb->srgns_per_lu - 1) %
+				    hpb->srgns_per_rgn) + 1;
+
+		ret = ufshpb_alloc_subregion_tbl(hpb, rgn, srgn_cnt);
+		if (ret)
+			goto release_srgn_table;
+		ufshpb_init_subregion_tbl(hpb, rgn);
+
+		rgn->rgn_state = HPB_RGN_INACTIVE;
+	}
+
+	return 0;
+
+release_srgn_table:
+	for (i = 0; i < rgn_idx; i++) {
+		rgn = rgn_table + i;
+		if (rgn->srgn_tbl)
+			kvfree(rgn->srgn_tbl);
+	}
+	kvfree(rgn_table);
+	return ret;
+}
+
+static void ufshpb_destroy_subregion_tbl(struct ufshpb_lu *hpb,
+					 struct ufshpb_region *rgn)
+{
+	int srgn_idx;
+
+	for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt; srgn_idx++) {
+		struct ufshpb_subregion *srgn;
+
+		srgn = rgn->srgn_tbl + srgn_idx;
+		srgn->srgn_state = HPB_SRGN_UNUSED;
+	}
+}
+
+static void ufshpb_destroy_region_tbl(struct ufshpb_lu *hpb)
+{
+	int rgn_idx;
+
+	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
+		struct ufshpb_region *rgn;
+
+		rgn = hpb->rgn_tbl + rgn_idx;
+		if (rgn->rgn_state != HPB_RGN_INACTIVE) {
+			rgn->rgn_state = HPB_RGN_INACTIVE;
+
+			ufshpb_destroy_subregion_tbl(hpb, rgn);
+		}
+
+		kvfree(rgn->srgn_tbl);
+	}
+
+	kvfree(hpb->rgn_tbl);
+}
+
+static void ufshpb_stat_init(struct ufshpb_lu *hpb)
+{
+	atomic_set(&hpb->stats.hit_cnt, 0);
+	atomic_set(&hpb->stats.miss_cnt, 0);
+	atomic_set(&hpb->stats.rb_noti_cnt, 0);
+	atomic_set(&hpb->stats.rb_active_cnt, 0);
+	atomic_set(&hpb->stats.rb_inactive_cnt, 0);
+	atomic_set(&hpb->stats.map_req_cnt, 0);
+}
+
+struct ufshpb_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct ufshpb_lu *hpb, char *page);
+	ssize_t (*store)(struct ufshpb_lu *hpb, const char *page, size_t len);
+};
+
+ufshpb_sysfs_attr_show_func(hit_cnt);
+ufshpb_sysfs_attr_show_func(miss_cnt);
+ufshpb_sysfs_attr_show_func(rb_noti_cnt);
+ufshpb_sysfs_attr_show_func(rb_active_cnt);
+ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
+ufshpb_sysfs_attr_show_func(map_req_cnt);
+
+static HPB_ATTR_RO(hit_cnt);
+static HPB_ATTR_RO(miss_cnt);
+static HPB_ATTR_RO(rb_noti_cnt);
+static HPB_ATTR_RO(rb_active_cnt);
+static HPB_ATTR_RO(rb_inactive_cnt);
+static HPB_ATTR_RO(map_req_cnt);
+
+static struct attribute *hpb_dev_attrs[] = {
+	&hpb_attr_hit_cnt.attr,
+	&hpb_attr_miss_cnt.attr,
+	&hpb_attr_rb_noti_cnt.attr,
+	&hpb_attr_rb_active_cnt.attr,
+	&hpb_attr_rb_inactive_cnt.attr,
+	&hpb_attr_map_req_cnt.attr,
+	NULL,
+};
+
+static struct attribute_group ufshpb_sysfs_group = {
+	.attrs = hpb_dev_attrs,
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
+				 const char *page, size_t len)
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
+	error = entry->store(hpb, page, len);
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
+	int ret;
+
+	ufshpb_stat_init(hpb);
+
+	kobject_init(&hpb->kobj, &ufshpb_ktype);
+	mutex_init(&hpb->sysfs_lock);
+
+	ret = kobject_add(&hpb->kobj, kobject_get(&hba->dev->kobj),
+			  "ufshpb_lu%d", hpb->lun);
+
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&hpb->kobj, &ufshpb_sysfs_group);
+
+	if (ret) {
+		dev_err(hba->dev, "ufshpb_lu%d create file error\n", hpb->lun);
+		return ret;
+	}
+
+	dev_info(hba->dev, "ufshpb_lu%d sysfs adds uevent", hpb->lun);
+	kobject_uevent(&hpb->kobj, KOBJ_ADD);
+
+	return 0;
+}
+
+static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb,
+			      struct ufshpb_dev_info *hpb_dev_info)
+{
+	int ret;
+
+	spin_lock_init(&hpb->hpb_state_lock);
+
+	ret = ufshpb_alloc_region_tbl(hba, hpb);
+	if (ret)
+		return ret;
+
+	ret = ufshpb_create_sysfs(hba, hpb);
+	if (ret)
+		goto release_rgn_table;
+
+	return 0;
+
+release_rgn_table:
+	ufshpb_destroy_region_tbl(hpb);
+	return ret;
+}
+
+static struct ufshpb_lu *ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
+				     struct ufshpb_dev_info *hpb_dev_info,
+				     struct ufshpb_lu_info *hpb_lu_info)
+{
+	struct ufshpb_lu *hpb;
+	int ret;
+
+	hpb = kzalloc(sizeof(struct ufshpb_lu), GFP_KERNEL);
+	if (!hpb)
+		return NULL;
+
+	hpb->ufsf = &hba->ufsf;
+	hpb->lun = lun;
+
+	ufshpb_init_lu_parameter(hba, hpb, hpb_dev_info, hpb_lu_info);
+
+	ret = ufshpb_lu_hpb_init(hba, hpb, hpb_dev_info);
+	if (ret) {
+		dev_err(hba->dev, "hpb lu init failed. ret %d", ret);
+		goto release_hpb;
+	}
+
+	return hpb;
+
+release_hpb:
+	kfree(hpb);
+	return NULL;
+}
+
+static void ufshpb_issue_hpb_reset_query(struct ufs_hba *hba)
+{
+	int err;
+	int retries;
+
+	for (retries = 0; retries < HPB_RESET_REQ_RETRIES; retries++) {
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+				QUERY_FLAG_IDN_HPB_RESET, 0, NULL);
+		if (err)
+			dev_dbg(hba->dev,
+				"%s: failed with error %d, retries %d\n",
+				__func__, err, retries);
+		else
+			break;
+	}
+
+	if (err) {
+		dev_err(hba->dev,
+			"%s setting fHpbReset flag failed with error %d\n",
+			__func__, err);
+		return;
+	}
+}
+
+static void ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
+{
+	int err;
+	bool flag_res = true;
+	int try = 0;
+
+	/* wait for the device to complete HPB reset query */
+	do {
+		if (++try == HPB_RESET_REQ_RETRIES)
+			break;
+
+		dev_info(hba->dev,
+			"%s start flag reset polling %d times\n",
+			__func__, try);
+
+		/* Poll fHpbReset flag to be cleared */
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+				QUERY_FLAG_IDN_HPB_RESET, 0, &flag_res);
+		usleep_range(1000, 1100);
+	} while (flag_res);
+
+	if (err) {
+		dev_err(hba->dev,
+			"%s reading fHpbReset flag failed with error %d\n",
+			__func__, err);
+		return;
+	}
+
+	if (flag_res) {
+		dev_err(hba->dev,
+			"%s fHpbReset was not cleared by the device\n",
+			__func__);
+	}
+}
+
+void ufshpb_reset(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+
+	list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu)
+		ufshpb_set_state(hpb, HPB_PRESENT);
+}
+
+void ufshpb_reset_host(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+
+	dev_info(hba->dev, "ufshpb run reset_host");
+
+	list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu)
+		ufshpb_set_state(hpb, HPB_RESET);
+}
+
+void ufshpb_suspend(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+
+	dev_info(hba->dev, "ufshpb goto suspend");
+
+	list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu)
+		ufshpb_set_state(hpb, HPB_SUSPEND);
+}
+
+void ufshpb_resume(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+
+	dev_info(hba->dev, "ufshpb resume");
+
+	list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu)
+		ufshpb_set_state(hpb, HPB_PRESENT);
+}
+
+static int ufshpb_read_desc(struct ufs_hba *hba, u8 desc_id, u8 desc_index,
+			    u8 selector, u8 *desc_buf)
+{
+	int err = 0;
+	int size;
+
+	ufshcd_map_desc_id_to_length(hba, desc_id, &size);
+
+	pm_runtime_get_sync(hba->dev);
+
+	err = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+					    desc_id, desc_index,
+					    selector,
+					    desc_buf, &size);
+	if (err)
+		dev_err(hba->dev, "read desc failed: %d, id %d, idx %d\n",
+			err, desc_id, desc_index);
+
+	pm_runtime_put_sync(hba->dev);
+
+	return err;
+}
+
+static int ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf,
+			       struct ufshpb_dev_info *hpb_dev_info)
+{
+	int hpb_device_max_active_rgns = 0;
+	int hpb_num_lu;
+
+	hpb_num_lu = geo_buf[GEOMETRY_DESC_HPB_NUMBER_LU];
+	if (hpb_num_lu == 0) {
+		dev_err(hba->dev, "No HPB LU supported\n");
+		return -ENODEV;
+	}
+
+	hpb_dev_info->rgn_size = geo_buf[GEOMETRY_DESC_HPB_REGION_SIZE];
+	hpb_dev_info->srgn_size = geo_buf[GEOMETRY_DESC_HPB_SUBREGION_SIZE];
+	hpb_device_max_active_rgns =
+		get_unaligned_be16(geo_buf +
+			GEOMETRY_DESC_HPB_DEVICE_MAX_ACTIVE_REGIONS);
+
+	if (hpb_dev_info->rgn_size == 0 || hpb_dev_info->srgn_size == 0 ||
+	    hpb_device_max_active_rgns == 0) {
+		dev_err(hba->dev, "No HPB supported device\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int ufshpb_get_dev_info(struct ufs_hba *hba,
+			       struct ufshpb_dev_info *hpb_dev_info,
+			       u8 *desc_buf)
+{
+	int ret;
+	int version;
+	u8 hpb_mode;
+
+	ret = ufshpb_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf);
+	if (ret) {
+		dev_err(hba->dev, "%s: idn: %d query request failed\n",
+			__func__, QUERY_DESC_IDN_DEVICE);
+		return -ENODEV;
+	}
+
+	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
+	if (hpb_mode == HPB_HOST_CONTROL) {
+		dev_err(hba->dev, "%s: host control mode is not supported.\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
+	if (version != HPB_SUPPORT_VERSION) {
+		dev_err(hba->dev, "%s: HPB %x version is not supported.\n",
+			__func__, version);
+		return -ENODEV;
+	}
+
+	/*
+	 * Get the number of user logical unit to check whether all
+	 * scsi_device finish initialization
+	 */
+	hpb_dev_info->num_lu = desc_buf[DEVICE_DESC_PARAM_NUM_LU];
+
+	ret = ufshpb_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0, 0, desc_buf);
+	if (ret) {
+		dev_err(hba->dev, "%s: idn: %d query request failed\n",
+			__func__, QUERY_DESC_IDN_DEVICE);
+		return ret;
+	}
+
+	ret = ufshpb_get_geo_info(hba, desc_buf, hpb_dev_info);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ufshpb_get_lu_info(struct ufs_hba *hba, int lun,
+				    struct ufshpb_lu_info *hpb_lu_info,
+				    u8 *desc_buf)
+{
+	u16 max_active_rgns;
+	u8 lu_enable;
+	int ret;
+
+	ret = ufshpb_read_desc(hba, QUERY_DESC_IDN_UNIT, lun, 0, desc_buf);
+	if (ret) {
+		dev_err(hba->dev,
+			"%s: idn: %d lun: %d  query request failed",
+			__func__, QUERY_DESC_IDN_UNIT, lun);
+		return ret;
+	}
+
+	lu_enable = desc_buf[UNIT_DESC_PARAM_LU_ENABLE];
+	if (lu_enable != LU_ENABLED_HPB_FUNC)
+		return -ENODEV;
+
+	max_active_rgns = get_unaligned_be16(
+			desc_buf + UNIT_DESC_HPB_LU_MAX_ACTIVE_REGIONS);
+	if (!max_active_rgns) {
+		dev_err(hba->dev,
+			"lun %d wrong number of max active regions\n", lun);
+		return -ENODEV;
+	}
+
+	hpb_lu_info->num_blocks = get_unaligned_be64(
+			desc_buf + UNIT_DESC_PARAM_LOGICAL_BLK_COUNT);
+	hpb_lu_info->pinned_start = get_unaligned_be16(
+			desc_buf + UNIT_DESC_HPB_LU_PIN_REGION_START_OFFSET);
+	hpb_lu_info->num_pinned = get_unaligned_be16(
+			desc_buf + UNIT_DESC_HPB_LU_NUM_PIN_REGIONS);
+	hpb_lu_info->max_active_rgns = max_active_rgns;
+
+	return 0;
+}
+
+static void ufshpb_scan_hpb_lu(struct ufs_hba *hba,
+			       struct ufshpb_dev_info *hpb_dev_info,
+			       u8 *desc_buf)
+{
+	struct scsi_device *sdev;
+	struct ufshpb_lu *hpb;
+	int find_hpb_lu = 0;
+	int ret;
+
+	shost_for_each_device(sdev, hba->host) {
+		struct ufshpb_lu_info hpb_lu_info = { 0 };
+		int lun = sdev->lun;
+
+		if (lun >= hba->dev_info.max_lu_supported)
+			continue;
+
+		ret = ufshpb_get_lu_info(hba, lun, &hpb_lu_info, desc_buf);
+		if (ret)
+			continue;
+
+		hpb = ufshpb_alloc_hpb_lu(hba, lun, hpb_dev_info,
+					  &hpb_lu_info);
+		if (!hpb)
+			continue;
+
+		hpb->sdev_ufs_lu = sdev;
+		sdev->hostdata = hpb;
+
+		list_add_tail(&hpb->list_hpb_lu, &lh_hpb_lu);
+		find_hpb_lu++;
+	}
+
+	if (!find_hpb_lu)
+		return;
+
+	ufshpb_check_hpb_reset_query(hba);
+
+	list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu) {
+		dev_info(hba->dev, "set state to present\n");
+		ufshpb_set_state(hpb, HPB_PRESENT);
+	}
+}
+
+static void ufshpb_init(void *data, async_cookie_t cookie)
+{
+	struct ufsf_feature_info *ufsf = (struct ufsf_feature_info *)data;
+	struct ufs_hba *hba;
+	struct ufshpb_dev_info hpb_dev_info = { 0 };
+	char *desc_buf;
+	int ret;
+
+	hba = container_of(ufsf, struct ufs_hba, ufsf);
+
+	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
+	if (!desc_buf)
+		goto release_desc_buf;
+
+	ret = ufshpb_get_dev_info(hba, &hpb_dev_info, desc_buf);
+	if (ret)
+		goto release_desc_buf;
+
+	/*
+	 * Because HPB driver uses scsi_device data structure,
+	 * we should wait at this point until finishing initialization of all
+	 * scsi devices. Even if timeout occurs, HPB driver will search
+	 * the scsi_device list on struct scsi_host (shost->__host list_head)
+	 * and can find out HPB logical units in all scsi_devices
+	 */
+	wait_event_timeout(hba->ufsf.sdev_wait,
+			   (atomic_read(&hba->ufsf.slave_conf_cnt)
+				== hpb_dev_info.num_lu),
+			   SDEV_WAIT_TIMEOUT);
+
+	ufshpb_issue_hpb_reset_query(hba);
+
+	dev_dbg(hba->dev, "ufshpb: slave count %d, lu count %d\n",
+		atomic_read(&hba->ufsf.slave_conf_cnt), hpb_dev_info.num_lu);
+
+	ufshpb_scan_hpb_lu(hba, &hpb_dev_info, desc_buf);
+
+release_desc_buf:
+	kfree(desc_buf);
+}
+
+static inline void ufshpb_remove_sysfs(struct ufshpb_lu *hpb)
+{
+	kobject_uevent(&hpb->kobj, KOBJ_REMOVE);
+	dev_info(&hpb->sdev_ufs_lu->sdev_dev,
+		 "ufshpb removes sysfs lu %d %p", hpb->lun, &hpb->kobj);
+	kobject_del(&hpb->kobj);
+}
+
+void ufshpb_remove(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb, *n_hpb;
+	struct ufsf_feature_info *ufsf;
+	struct scsi_device *sdev;
+
+	ufsf = &hba->ufsf;
+
+	list_for_each_entry_safe(hpb, n_hpb, &lh_hpb_lu, list_hpb_lu) {
+		ufshpb_set_state(hpb, HPB_FAILED);
+
+		sdev = hpb->sdev_ufs_lu;
+		sdev->hostdata = NULL;
+
+		ufshpb_destroy_region_tbl(hpb);
+
+		list_del_init(&hpb->list_hpb_lu);
+		ufshpb_remove_sysfs(hpb);
+
+		kfree(hpb);
+	}
+
+	dev_info(hba->dev, "ufshpb: remove success\n");
+}
+
+void ufshpb_scan_feature(struct ufs_hba *hba)
+{
+	init_waitqueue_head(&hba->ufsf.sdev_wait);
+	atomic_set(&hba->ufsf.slave_conf_cnt, 0);
+
+	if (hba->dev_info.wspecversion >= HPB_SUPPORT_VERSION &&
+	    (hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT))
+		async_schedule(ufshpb_init, &hba->ufsf);
+}
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
new file mode 100644
index 000000000000..b91b447ed0c8
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -0,0 +1,169 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
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
+/* hpb response UPIU macro */
+#define MAX_ACTIVE_NUM				2
+#define MAX_INACTIVE_NUM			2
+#define HPB_RSP_NONE				0x00
+#define HPB_RSP_REQ_REGION_UPDATE		0x01
+#define HPB_RSP_DEV_RESET			0x02
+#define DEV_DATA_SEG_LEN			0x14
+#define DEV_SENSE_SEG_LEN			0x12
+#define DEV_DES_TYPE				0x80
+#define DEV_ADDITIONAL_LEN			0x10
+
+/* hpb map & entries macro */
+#define HPB_RGN_SIZE_UNIT			512
+#define HPB_ENTRY_BLOCK_SIZE			4096
+#define HPB_ENTRY_SIZE				0x8
+#define PINNED_NOT_SET				U32_MAX
+
+/* hpb support chunk size */
+#define HPB_MULTI_CHUNK_HIGH			1
+
+/* hpb vender defined opcode */
+#define UFSHPB_READ				0xF8
+#define UFSHPB_READ_BUFFER			0xF9
+#define UFSHPB_READ_BUFFER_ID			0x01
+#define HPB_READ_BUFFER_CMD_LENGTH		10
+#define LU_ENABLED_HPB_FUNC			0x02
+
+#define SDEV_WAIT_TIMEOUT			(10 * HZ)
+#define MAP_REQ_TIMEOUT			(30 * HZ)
+#define HPB_RESET_REQ_RETRIES			10
+#define HPB_RESET_REQ_MSLEEP			2
+
+#define HPB_SUPPORT_VERSION			0x100
+
+enum UFSHPB_MODE {
+	HPB_HOST_CONTROL,
+	HPB_DEVICE_CONTROL,
+};
+
+enum UFSHPB_STATE {
+	HPB_PRESENT = 1,
+	HPB_SUSPEND,
+	HPB_FAILED,
+	HPB_RESET,
+};
+
+enum HPB_RGN_STATE {
+	HPB_RGN_INACTIVE,
+	HPB_RGN_ACTIVE,
+	/* pinned regions are always active */
+	HPB_RGN_PINNED,
+};
+
+enum HPB_SRGN_STATE {
+	HPB_SRGN_UNUSED,
+	HPB_SRGN_INVALID,
+	HPB_SRGN_VALID,
+	HPB_SRGN_ISSUED,
+};
+
+/**
+ * struct ufshpb_dev_info - UFSHPB device related info
+ * @num_lu: the number of user logical unit to check whether all lu finished
+ *          initialization
+ * @rgn_size: device reported HPB region size
+ * @srgn_size: device reported HPB sub-region size
+ */
+struct ufshpb_dev_info {
+	int num_lu;
+	int rgn_size;
+	int srgn_size;
+};
+
+/**
+ * struct ufshpb_lu_info - UFSHPB logical unit related info
+ * @num_blocks: the number of logical block
+ * @pinned_start: the start region number of pinned region
+ * @num_pinned: the number of pinned regions
+ * @max_active_rgns: maximum number of active regions
+ */
+struct ufshpb_lu_info {
+	int num_blocks;
+	int pinned_start;
+	int num_pinned;
+	int max_active_rgns;
+};
+
+struct ufshpb_subregion {
+	enum HPB_SRGN_STATE srgn_state;
+	int rgn_idx;
+	int srgn_idx;
+};
+
+struct ufshpb_region {
+	struct ufshpb_subregion *srgn_tbl;
+	enum HPB_RGN_STATE rgn_state;
+	int rgn_idx;
+	int srgn_cnt;
+};
+
+struct ufshpb_stats {
+	atomic_t hit_cnt;
+	atomic_t miss_cnt;
+	atomic_t rb_noti_cnt;
+	atomic_t rb_active_cnt;
+	atomic_t rb_inactive_cnt;
+	atomic_t map_req_cnt;
+};
+
+struct ufshpb_lu {
+	int lun;
+	struct scsi_device *sdev_ufs_lu;
+	struct ufshpb_region *rgn_tbl;
+
+	struct kobject kobj;
+	struct mutex sysfs_lock;
+
+	spinlock_t hpb_state_lock;
+	atomic_t hpb_state; /* hpb_state_lock */
+
+	/* pinned region information */
+	u32 lu_pinned_start;
+	u32 lu_pinned_end;
+
+	/* HPB related configuration */
+	u32 rgns_per_lu;
+	u32 srgns_per_lu;
+	int srgns_per_rgn;
+	u32 srgn_mem_size;
+	u32 entries_per_rgn_mask;
+	u32 entries_per_rgn_shift;
+	u32 entries_per_srgn;
+	u32 entries_per_srgn_mask;
+	u32 entries_per_srgn_shift;
+	u32 pages_per_srgn;
+
+	struct ufshpb_stats stats;
+
+	struct ufsf_feature_info *ufsf;
+	struct list_head list_hpb_lu;
+};
+
+struct ufs_hba;
+struct ufshcd_lrb;
+
+void ufshpb_resume(struct ufs_hba *hba);
+void ufshpb_suspend(struct ufs_hba *hba);
+void ufshpb_reset(struct ufs_hba *hba);
+void ufshpb_reset_host(struct ufs_hba *hba);
+void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufshpb_scan_feature(struct ufs_hba *hba);
+void ufshpb_remove(struct ufs_hba *hba);
+
+#endif /* End of Header */
-- 
2.17.1


