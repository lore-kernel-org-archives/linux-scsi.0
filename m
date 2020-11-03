Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ADCFC55179
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 04:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95FCC22277
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 04:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="X/uAMm/Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKCEuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 23:50:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33394 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCEuM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 23:50:12 -0500
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201103045004epoutp011042888c4c88e5735553bed8b8b4c747~D5jRNiOXW0755907559epoutp01R
        for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2020 04:50:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201103045004epoutp011042888c4c88e5735553bed8b8b4c747~D5jRNiOXW0755907559epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604379004;
        bh=Sl451u3Sp9l3qNYj8Tpo2XkU4WStvIVB+bDIzf5jOLM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=X/uAMm/YNQ6PVFkiwqvBzi2+awhGKr0OSckp1QWfR7JvEAVq/kg7V4aMrD+O/HuLa
         /72ipccdgPeUITP976ocpbHQp1RgOM5YOZ3XeS554E5Ur1n1tyIZvWdX9Boei5Kibn
         JoIUrt+0xA+x2exqTkh72uZO7AAKM9WCMS0gWk/4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20201103045003epcas3p3c6ca4f4ccbbadc7e8e9d48162b8b9482~D5jQnfcdX0767807678epcas3p3C;
        Tue,  3 Nov 2020 04:50:03 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4CQHQM6Q9QzMqYlp; Tue,  3 Nov 2020 04:50:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH v13 1/3] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
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
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "gregkh@google.com" <gregkh@google.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1796371666.41604379003890.JavaMail.epsvc@epcpadp3>
Date:   Tue, 03 Nov 2020 13:46:23 +0900
X-CMS-MailID: 20201103044623epcms2p25b83de8ac8ecb00d57b25e78d4a195d1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20201103044021epcms2p8f1556853fc23414442b9e958f20781ce
References: <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
        <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a patch for the HPB feature.
This patch adds HPB function calls to UFS core driver.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Avri Altman <Avri.Altman@wdc.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/Kconfig     |   9 +
 drivers/scsi/ufs/Makefile    |   1 +
 drivers/scsi/ufs/ufs-sysfs.c |  18 ++
 drivers/scsi/ufs/ufs.h       |  13 +
 drivers/scsi/ufs/ufshcd.c    |  48 +++
 drivers/scsi/ufs/ufshcd.h    |  23 +-
 drivers/scsi/ufs/ufshpb.c    | 583 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h    | 167 ++++++++++
 8 files changed, 861 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index dcdb4eb1f90b..fd1cf7bc0eca 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -181,3 +181,12 @@ config SCSI_UFS_CRYPTO
 	  Enabling this makes it possible for the kernel to use the crypto
 	  capabilities of the UFS device (if present) to perform crypto
 	  operations on data being transferred to/from the device.
+
+config SCSI_UFS_HPB
+	bool "Support UFS Host Performance Booster"
+	depends on SCSI_UFSHCD
+	help
+	  The UFS HPB feature improves random read performance. It caches
+	  L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB
+	  read command by piggybacking physical page number for bypassing FTL (flash
+	  translation layer)'s L2P address translation.
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
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index bdcd27faa054..6ccda6e57c7f 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -284,6 +284,8 @@ UFS_DEVICE_DESC_PARAM(device_version, _DEV_VER, 2);
 UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, _NUM_SEC_WPA, 1);
 UFS_DEVICE_DESC_PARAM(psa_max_data_size, _PSA_MAX_DATA, 4);
 UFS_DEVICE_DESC_PARAM(psa_state_timeout, _PSA_TMT, 1);
+UFS_DEVICE_DESC_PARAM(hpb_version, _HPB_VER, 2);
+UFS_DEVICE_DESC_PARAM(hpb_control, _HPB_CONTROL, 1);
 UFS_DEVICE_DESC_PARAM(ext_feature_sup, _EXT_UFS_FEATURE_SUP, 4);
 UFS_DEVICE_DESC_PARAM(wb_presv_us_en, _WB_PRESRV_USRSPC_EN, 1);
 UFS_DEVICE_DESC_PARAM(wb_type, _WB_TYPE, 1);
@@ -316,6 +318,8 @@ static struct attribute *ufs_sysfs_device_descriptor[] = {
 	&dev_attr_number_of_secure_wpa.attr,
 	&dev_attr_psa_max_data_size.attr,
 	&dev_attr_psa_state_timeout.attr,
+	&dev_attr_hpb_version.attr,
+	&dev_attr_hpb_control.attr,
 	&dev_attr_ext_feature_sup.attr,
 	&dev_attr_wb_presv_us_en.attr,
 	&dev_attr_wb_type.attr,
@@ -389,6 +393,10 @@ UFS_GEOMETRY_DESC_PARAM(enh4_memory_max_alloc_units,
 	_ENM4_MAX_NUM_UNITS, 4);
 UFS_GEOMETRY_DESC_PARAM(enh4_memory_capacity_adjustment_factor,
 	_ENM4_CAP_ADJ_FCTR, 2);
+UFS_GEOMETRY_DESC_PARAM(hpb_region_size, _HPB_REGION_SIZE, 1);
+UFS_GEOMETRY_DESC_PARAM(hpb_number_lu, _HPB_NUMBER_LU, 1);
+UFS_GEOMETRY_DESC_PARAM(hpb_subregion_size, _HPB_SUBREGION_SIZE, 1);
+UFS_GEOMETRY_DESC_PARAM(hpb_max_active_regions, _HPB_MAX_ACTIVE_REGS, 2);
 UFS_GEOMETRY_DESC_PARAM(wb_max_alloc_units, _WB_MAX_ALLOC_UNITS, 4);
 UFS_GEOMETRY_DESC_PARAM(wb_max_wb_luns, _WB_MAX_WB_LUNS, 1);
 UFS_GEOMETRY_DESC_PARAM(wb_buff_cap_adj, _WB_BUFF_CAP_ADJ, 1);
@@ -426,6 +434,10 @@ static struct attribute *ufs_sysfs_geometry_descriptor[] = {
 	&dev_attr_enh3_memory_capacity_adjustment_factor.attr,
 	&dev_attr_enh4_memory_max_alloc_units.attr,
 	&dev_attr_enh4_memory_capacity_adjustment_factor.attr,
+	&dev_attr_hpb_region_size.attr,
+	&dev_attr_hpb_number_lu.attr,
+	&dev_attr_hpb_subregion_size.attr,
+	&dev_attr_hpb_max_active_regions.attr,
 	&dev_attr_wb_max_alloc_units.attr,
 	&dev_attr_wb_max_wb_luns.attr,
 	&dev_attr_wb_buff_cap_adj.attr,
@@ -808,6 +820,9 @@ UFS_UNIT_DESC_PARAM(provisioning_type, _PROVISIONING_TYPE, 1);
 UFS_UNIT_DESC_PARAM(physical_memory_resourse_count, _PHY_MEM_RSRC_CNT, 8);
 UFS_UNIT_DESC_PARAM(context_capabilities, _CTX_CAPABILITIES, 2);
 UFS_UNIT_DESC_PARAM(large_unit_granularity, _LARGE_UNIT_SIZE_M1, 1);
+UFS_UNIT_DESC_PARAM(hpb_lu_max_active_regions, _HPB_LU_MAX_ACTIVE_RGNS, 2);
+UFS_UNIT_DESC_PARAM(hpb_pinned_region_start_offset, _HPB_PIN_RGN_START_OFF, 2);
+UFS_UNIT_DESC_PARAM(hpb_number_pinned_regions, _HPB_NUM_PIN_RGNS, 2);
 UFS_UNIT_DESC_PARAM(wb_buf_alloc_units, _WB_BUF_ALLOC_UNITS, 4);
 
 
@@ -825,6 +840,9 @@ static struct attribute *ufs_sysfs_unit_descriptor[] = {
 	&dev_attr_physical_memory_resourse_count.attr,
 	&dev_attr_context_capabilities.attr,
 	&dev_attr_large_unit_granularity.attr,
+	&dev_attr_hpb_lu_max_active_regions.attr,
+	&dev_attr_hpb_pinned_region_start_offset.attr,
+	&dev_attr_hpb_number_pinned_regions.attr,
 	&dev_attr_wb_buf_alloc_units.attr,
 	NULL,
 };
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index f8ab16f30fdc..94deabb0ad36 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -122,6 +122,7 @@ enum flag_idn {
 	QUERY_FLAG_IDN_WB_EN                            = 0x0E,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN                 = 0x0F,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
+	QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
 };
 
 /* Attribute idn for Query requests */
@@ -195,6 +196,9 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
 	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
 	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
+	UNIT_DESC_PARAM_HPB_LU_MAX_ACTIVE_RGNS	= 0x23,
+	UNIT_DESC_PARAM_HPB_PIN_RGN_START_OFF	= 0x25,
+	UNIT_DESC_PARAM_HPB_NUM_PIN_RGNS	= 0x27,
 	UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS	= 0x29,
 };
 
@@ -235,6 +239,8 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PSA_MAX_DATA		= 0x25,
 	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
+	DEVICE_DESC_PARAM_HPB_VER		= 0x40,
+	DEVICE_DESC_PARAM_HPB_CONTROL		= 0x42,
 	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	= 0x4F,
 	DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN	= 0x53,
 	DEVICE_DESC_PARAM_WB_TYPE		= 0x54,
@@ -283,6 +289,10 @@ enum geometry_desc_param {
 	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
 	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
 	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
+	GEOMETRY_DESC_PARAM_HPB_REGION_SIZE	= 0x48,
+	GEOMETRY_DESC_PARAM_HPB_NUMBER_LU	= 0x49,
+	GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE	= 0x4A,
+	GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGS	= 0x4B,
 	GEOMETRY_DESC_PARAM_WB_MAX_ALLOC_UNITS	= 0x4F,
 	GEOMETRY_DESC_PARAM_WB_MAX_WB_LUNS	= 0x53,
 	GEOMETRY_DESC_PARAM_WB_BUFF_CAP_ADJ	= 0x54,
@@ -327,8 +337,10 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
+	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
+#define UFS_DEV_HPB_SUPPORT_VERSION		0x310
 
 #define POWER_DESC_MAX_SIZE			0x62
 #define POWER_DESC_MAX_ACTV_ICC_LVLS		16
@@ -537,6 +549,7 @@ struct ufs_dev_info {
 	u8 *model;
 	u16 wspecversion;
 	u32 clk_gating_wait_us;
+	u8 b_ufs_feature_sup;
 	u32 d_ext_ufs_feature_sup;
 	u8 b_wb_buffer_type;
 	u32 d_wb_alloc_units;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8f573a02713..77a970522e24 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -22,6 +22,7 @@
 #include "ufs-sysfs.h"
 #include "ufs_bsg.h"
 #include "ufshcd-crypto.h"
+#include "ufshpb.h"
 #include <asm/unaligned.h>
 #include <linux/blkdev.h>
 
@@ -4702,6 +4703,26 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 	return scsi_change_queue_depth(sdev, depth);
 }
 
+static void ufshcd_hpb_destroy(struct ufs_hba *hba, struct scsi_device *sdev)
+{
+	/* skip well-known LU */
+	if ((sdev->lun >= UFS_UPIU_MAX_UNIT_NUM_ID) || !ufshpb_is_allowed(hba))
+		return;
+
+	ufshpb_destroy_lu(hba, sdev);
+}
+
+static void ufshcd_hpb_configure(struct ufs_hba *hba, struct scsi_device *sdev)
+{
+	/* skip well-known LU */
+	if ((sdev->lun >= UFS_UPIU_MAX_UNIT_NUM_ID) ||
+	    !(hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT) ||
+	    !ufshpb_is_allowed(hba))
+		return;
+
+	ufshpb_init_hpb_lu(hba, sdev);
+}
+
 /**
  * ufshcd_slave_configure - adjust SCSI device configurations
  * @sdev: pointer to SCSI device
@@ -4711,6 +4732,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 
+	ufshcd_hpb_configure(hba, sdev);
+
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
@@ -4730,6 +4753,9 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 	struct ufs_hba *hba;
 
 	hba = shost_priv(sdev->host);
+
+	ufshcd_hpb_destroy(hba, sdev);
+
 	/* Drop the reference as it won't be needed anymore */
 	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN) {
 		unsigned long flags;
@@ -6789,6 +6815,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 * Stop the host controller and complete the requests
 	 * cleared by h/w
 	 */
+	ufshpb_reset_host(hba);
+
 	ufshcd_hba_stop(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -7224,9 +7252,14 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	/* getting Specification Version in big endian format */
 	dev_info->wspecversion = desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
 				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
+	dev_info->b_ufs_feature_sup = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
 
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
+	if (dev_info->wspecversion >= UFS_DEV_HPB_SUPPORT_VERSION &&
+	    (dev_info->b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT))
+		ufshpb_get_dev_info(hba, desc_buf);
+
 	err = ufshcd_read_string_desc(hba, model_index,
 				      &dev_info->model, SD_ASCII_STD);
 	if (err < 0) {
@@ -7455,6 +7488,10 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 	else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
 		hba->dev_info.max_lu_supported = 8;
 
+	if (hba->desc_size[QUERY_DESC_IDN_GEOMETRY] >=
+		GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGS)
+		ufshpb_get_geo_info(hba, desc_buf);
+
 out:
 	kfree(desc_buf);
 	return err;
@@ -7594,6 +7631,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	}
 
 	ufs_bsg_probe(hba);
+	ufshpb_init(hba);
 	scsi_scan_host(hba->host);
 	pm_runtime_put_sync(hba->dev);
 
@@ -7680,6 +7718,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
+	ufshpb_reset(hba);
 out:
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ret)
@@ -7726,6 +7765,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
 	&ufs_sysfs_lun_attributes_group,
+#ifdef CONFIG_SCSI_UFS_HPB
+	&ufs_sysfs_hpb_stat_group,
+#endif
 	NULL,
 };
 
@@ -8449,6 +8491,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		req_link_state = UIC_LINK_OFF_STATE;
 	}
 
+	ufshpb_suspend(hba);
+
 	/*
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
@@ -8573,6 +8617,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
 	ufshcd_release(hba);
+	ufshpb_resume(hba);
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
@@ -8672,6 +8717,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
+	ufshpb_resume(hba);
+
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		hba->dev_info.b_rpm_dev_flush_capable = false;
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
@@ -8901,6 +8948,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
+	ufshpb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_cleanup_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 47eb1430274c..ed5fbe0fa121 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -601,6 +601,25 @@ struct ufs_hba_variant_params {
 	u32 wb_flush_threshold;
 };
 
+#ifdef CONFIG_SCSI_UFS_HPB
+/**
+ * struct ufshpb_dev_info - UFSHPB device related info
+ * @num_lu: the number of user logical unit to check whether all lu finished
+ *          initialization
+ * @rgn_size: device reported HPB region size
+ * @srgn_size: device reported HPB sub-region size
+ * @slave_conf_cnt: counter to check all lu finished initialization
+ * @hpb_disabled: flag to check if HPB is disabled
+ */
+struct ufshpb_dev_info {
+	int num_lu;
+	int rgn_size;
+	int srgn_size;
+	atomic_t slave_conf_cnt;
+	bool hpb_disabled;
+};
+#endif
+
 /**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
@@ -784,7 +803,9 @@ struct ufs_hba {
 	bool wb_buf_flush_enabled;
 	bool wb_enabled;
 	struct delayed_work rpm_dev_flush_recheck_work;
-
+#ifdef CONFIG_SCSI_UFS_HPB
+	struct ufshpb_dev_info ufshpb_dev;
+#endif
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 	union ufs_crypto_capabilities crypto_capabilities;
 	union ufs_crypto_cap_entry *crypto_cap_array;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
new file mode 100644
index 000000000000..f3b2eef41b19
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -0,0 +1,583 @@
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
+#include "../sd.h"
+
+bool ufshpb_is_allowed(struct ufs_hba *hba)
+{
+	return !(hba->ufshpb_dev.hpb_disabled);
+}
+
+static struct ufshpb_lu *ufshpb_get_hpb_data(struct scsi_device * sdev)
+{
+	return sdev->hostdata;
+}
+
+static int ufshpb_get_state(struct ufshpb_lu *hpb)
+{
+	return atomic_read(&hpb->hpb_state);
+}
+
+static void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
+{
+	atomic_set(&hpb->hpb_state, state);
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
+static int ufshpb_alloc_subregion_tbl(struct ufshpb_lu *hpb,
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
+static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
+				     struct ufshpb_lu *hpb,
+				     struct ufshpb_dev_info *hpb_dev_info,
+				     struct ufshpb_lu_info *hpb_lu_info)
+{
+	u32 entries_per_rgn;
+	u64 rgn_mem_size, tmp;
+
+	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
+	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
+		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
+		: PINNED_NOT_SET;
+
+	rgn_mem_size = (1ULL << hpb_dev_info->rgn_size) * HPB_RGN_SIZE_UNIT
+			* HPB_ENTRY_SIZE;
+	do_div(rgn_mem_size, HPB_ENTRY_BLOCK_SIZE);
+	hpb->srgn_mem_size = (1ULL << hpb_dev_info->srgn_size)
+		* HPB_RGN_SIZE_UNIT / HPB_ENTRY_BLOCK_SIZE * HPB_ENTRY_SIZE;
+
+	tmp = rgn_mem_size;
+	do_div(tmp, HPB_ENTRY_SIZE);
+	entries_per_rgn = (u32)tmp;
+	hpb->entries_per_rgn_shift = ilog2(entries_per_rgn);
+	hpb->entries_per_rgn_mask = entries_per_rgn - 1;
+
+	hpb->entries_per_srgn = hpb->srgn_mem_size / HPB_ENTRY_SIZE;
+	hpb->entries_per_srgn_shift = ilog2(hpb->entries_per_srgn);
+	hpb->entries_per_srgn_mask = hpb->entries_per_srgn - 1;
+
+	tmp = rgn_mem_size;
+	do_div(tmp, hpb->srgn_mem_size);
+	hpb->srgns_per_rgn = (int)tmp;
+
+	hpb->rgns_per_lu = DIV_ROUND_UP(hpb_lu_info->num_blocks,
+				entries_per_rgn);
+	hpb->srgns_per_lu = DIV_ROUND_UP(hpb_lu_info->num_blocks,
+				(hpb->srgn_mem_size / HPB_ENTRY_SIZE));
+
+	hpb->pages_per_srgn = DIV_ROUND_UP(hpb->srgn_mem_size, PAGE_SIZE);
+
+	dev_info(hba->dev, "ufshpb(%d): region memory size - %llu (bytes)\n",
+		 hpb->lun, rgn_mem_size);
+	dev_info(hba->dev, "ufshpb(%d): subregion memory size - %u (bytes)\n",
+		 hpb->lun, hpb->srgn_mem_size);
+	dev_info(hba->dev, "ufshpb(%d): total blocks per lu - %d\n",
+		 hpb->lun, hpb_lu_info->num_blocks);
+	dev_info(hba->dev, "ufshpb(%d): subregions per region - %d, regions per lu - %u\n",
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
+/* SYSFS functions */
+#define ufshpb_sysfs_attr_show_func(__name)				\
+static ssize_t __name##_show(struct device *dev,			\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);		\
+									\
+	if (!hpb)							\
+		return -ENOENT;						\
+	return snprintf(buf, PAGE_SIZE, "%d\n",				\
+			atomic_read(&hpb->stats.__name));		\
+}									\
+\
+static DEVICE_ATTR_RO(__name)
+
+ufshpb_sysfs_attr_show_func(hit_cnt);
+ufshpb_sysfs_attr_show_func(miss_cnt);
+ufshpb_sysfs_attr_show_func(rb_noti_cnt);
+ufshpb_sysfs_attr_show_func(rb_active_cnt);
+ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
+ufshpb_sysfs_attr_show_func(map_req_cnt);
+
+static struct attribute *hpb_dev_attrs[] = {
+	&dev_attr_hit_cnt.attr,
+	&dev_attr_miss_cnt.attr,
+	&dev_attr_rb_noti_cnt.attr,
+	&dev_attr_rb_active_cnt.attr,
+	&dev_attr_rb_inactive_cnt.attr,
+	&dev_attr_map_req_cnt.attr,
+	NULL,
+};
+
+struct attribute_group ufs_sysfs_hpb_stat_group = {
+	.name = "hpb_sysfs",
+	.attrs = hpb_dev_attrs,
+};
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
+static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
+{
+	int ret;
+
+	spin_lock_init(&hpb->hpb_state_lock);
+
+	ret = ufshpb_alloc_region_tbl(hba, hpb);
+
+	ufshpb_stat_init(hpb);
+
+	return 0;
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
+	hpb->lun = lun;
+
+	ufshpb_lu_parameter_init(hba, hpb, hpb_dev_info, hpb_lu_info);
+
+	ret = ufshpb_lu_hpb_init(hba, hpb);
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
+static bool ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
+{
+	int err = 0;
+	bool flag_res = true;
+	int try;
+
+	/* wait for the device to complete HPB reset query */
+	for (try = 0; try < HPB_RESET_REQ_RETRIES; try++) {
+		dev_dbg(hba->dev,
+			"%s start flag reset polling %d times\n",
+			__func__, try);
+
+		/* Poll fHpbReset flag to be cleared */
+		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+				QUERY_FLAG_IDN_HPB_RESET, 0, &flag_res);
+
+		if (err) {
+			dev_err(hba->dev,
+				"%s reading fHpbReset flag failed with error %d\n",
+				__func__, err);
+			return flag_res;
+		}
+
+		if (!flag_res)
+			goto out;
+
+		usleep_range(1000, 1100);
+	}
+	if (flag_res) {
+		dev_err(hba->dev,
+			"%s fHpbReset was not cleared by the device\n",
+			__func__);
+	}
+out:
+	return flag_res;
+}
+
+void ufshpb_reset(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host) {
+		hpb = sdev->hostdata;
+		if (!hpb)
+			continue;
+
+		if (ufshpb_get_state(hpb) != HPB_RESET)
+			continue;
+
+		ufshpb_set_state(hpb, HPB_PRESENT);
+	}
+}
+
+void ufshpb_reset_host(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+	struct scsi_device *sdev;
+
+	dev_dbg(hba->dev, "ufshpb run reset_host\n");
+	shost_for_each_device(sdev, hba->host) {
+		hpb = sdev->hostdata;
+		if (!hpb)
+			continue;
+
+		if (ufshpb_get_state(hpb) != HPB_PRESENT)
+			continue;
+		ufshpb_set_state(hpb, HPB_RESET);
+	}
+}
+
+void ufshpb_suspend(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+	struct scsi_device *sdev;
+
+	dev_dbg(hba->dev, "ufshpb goto suspend\n");
+
+	shost_for_each_device(sdev, hba->host) {
+		hpb = sdev->hostdata;
+		if (!hpb)
+			continue;
+
+		if (ufshpb_get_state(hpb) != HPB_PRESENT)
+			continue;
+		ufshpb_set_state(hpb, HPB_SUSPEND);
+	}
+}
+
+void ufshpb_resume(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+	struct scsi_device *sdev;
+
+	dev_dbg(hba->dev, "ufshpb resume\n");
+
+	shost_for_each_device(sdev, hba->host) {
+		hpb = sdev->hostdata;
+		if (!hpb)
+			continue;
+
+		if ((ufshpb_get_state(hpb) != HPB_PRESENT) &&
+		    (ufshpb_get_state(hpb) != HPB_SUSPEND))
+			continue;
+		ufshpb_set_state(hpb, HPB_PRESENT);
+	}
+}
+
+static int ufshpb_get_lu_info(struct ufs_hba *hba, int lun,
+				    struct ufshpb_lu_info *hpb_lu_info)
+{
+	u16 max_active_rgns;
+	u8 lu_enable;
+	int size;
+	int ret;
+	char desc_buf[QUERY_DESC_MAX_SIZE];
+
+	ufshcd_map_desc_id_to_length(hba, QUERY_DESC_IDN_UNIT, &size);
+
+	pm_runtime_get_sync(hba->dev);
+	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+					    QUERY_DESC_IDN_UNIT, lun, 0,
+					    desc_buf, &size);
+	pm_runtime_put_sync(hba->dev);
+
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
+			desc_buf + UNIT_DESC_PARAM_HPB_LU_MAX_ACTIVE_RGNS);
+	if (!max_active_rgns) {
+		dev_err(hba->dev,
+			"lun %d wrong number of max active regions\n", lun);
+		return -ENODEV;
+	}
+
+	hpb_lu_info->num_blocks = get_unaligned_be64(
+			desc_buf + UNIT_DESC_PARAM_LOGICAL_BLK_COUNT);
+	hpb_lu_info->pinned_start = get_unaligned_be16(
+			desc_buf + UNIT_DESC_PARAM_HPB_PIN_RGN_START_OFF);
+	hpb_lu_info->num_pinned = get_unaligned_be16(
+			desc_buf + UNIT_DESC_PARAM_HPB_NUM_PIN_RGNS);
+	hpb_lu_info->max_active_rgns = max_active_rgns;
+
+	return 0;
+}
+
+void ufshpb_destroy_lu(struct ufs_hba *hba, struct scsi_device *sdev)
+{
+	struct ufshpb_lu *hpb = sdev->hostdata;
+
+	if (!hpb)
+		return;
+
+	ufshpb_set_state(hpb, HPB_FAILED);
+
+	sdev = hpb->sdev_ufs_lu;
+	sdev->hostdata = NULL;
+
+	ufshpb_destroy_region_tbl(hpb);
+
+	list_del_init(&hpb->list_hpb_lu);
+
+	kfree(hpb);
+}
+
+static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+	struct scsi_device *sdev;
+	bool init_success;
+
+	init_success = !ufshpb_check_hpb_reset_query(hba);
+
+	shost_for_each_device(sdev, hba->host) {
+		hpb = sdev->hostdata;
+		if (!hpb)
+			continue;
+
+		if (init_success) {
+			dev_info(hba->dev, "set state to present\n");
+			ufshpb_set_state(hpb, HPB_PRESENT);
+		} else {
+			dev_err(hba->dev, "destroy HPB lu %d\n", hpb->lun);
+			ufshpb_destroy_lu(hba, sdev);
+		}
+	}
+}
+
+void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev)
+{
+	struct ufshpb_lu *hpb;
+	int ret;
+	struct ufshpb_lu_info hpb_lu_info = { 0 };
+	int lun = sdev->lun;
+
+	if (lun >= hba->dev_info.max_lu_supported)
+		goto out;
+
+	ret = ufshpb_get_lu_info(hba, lun, &hpb_lu_info);
+	if (ret)
+		goto out;
+
+	hpb = ufshpb_alloc_hpb_lu(hba, lun, &hba->ufshpb_dev,
+				  &hpb_lu_info);
+	if (!hpb)
+		goto out;
+
+	hpb->sdev_ufs_lu = sdev;
+	sdev->hostdata = hpb;
+
+out:
+	/* All LUs are initialized */
+	if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
+		ufshpb_hpb_lu_prepared(hba);
+}
+
+void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf)
+{
+	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
+	int hpb_device_max_active_rgns = 0;
+	int hpb_num_lu;
+
+	hpb_num_lu = geo_buf[GEOMETRY_DESC_PARAM_HPB_NUMBER_LU];
+	if (hpb_num_lu == 0) {
+		dev_err(hba->dev, "No HPB LU supported\n");
+		hpb_dev_info->hpb_disabled = true;
+		return;
+	}
+
+	hpb_dev_info->rgn_size = geo_buf[GEOMETRY_DESC_PARAM_HPB_REGION_SIZE];
+	hpb_dev_info->srgn_size = geo_buf[GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE];
+	hpb_device_max_active_rgns =
+		get_unaligned_be16(geo_buf +
+			GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGS);
+
+	if (hpb_dev_info->rgn_size == 0 || hpb_dev_info->srgn_size == 0 ||
+	    hpb_device_max_active_rgns == 0) {
+		dev_err(hba->dev, "No HPB supported device\n");
+		hpb_dev_info->hpb_disabled = true;
+		return;
+	}
+}
+
+void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
+{
+	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
+	int version;
+	u8 hpb_mode;
+
+	hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
+	if (hpb_mode == HPB_HOST_CONTROL) {
+		dev_err(hba->dev, "%s: host control mode is not supported.\n",
+			__func__);
+		hpb_dev_info->hpb_disabled = true;
+		return;
+	}
+
+	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
+	if (version != HPB_SUPPORT_VERSION) {
+		dev_err(hba->dev, "%s: HPB %x version is not supported.\n",
+			__func__, version);
+		hpb_dev_info->hpb_disabled = true;
+		return;
+	}
+
+	/*
+	 * Get the number of user logical unit to check whether all
+	 * scsi_device finish initialization
+	 */
+	hpb_dev_info->num_lu = desc_buf[DEVICE_DESC_PARAM_NUM_LU];
+}
+
+void ufshpb_init(struct ufs_hba *hba)
+{
+	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
+	int try;
+	int ret;
+
+	if (!ufshpb_is_allowed(hba))
+		return;
+
+	atomic_set(&hpb_dev_info->slave_conf_cnt, hpb_dev_info->num_lu);
+	/* issue HPB reset query */
+	for (try = 0; try < HPB_RESET_REQ_RETRIES; try++) {
+		ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+					QUERY_FLAG_IDN_HPB_RESET, 0, NULL);
+		if (!ret)
+			break;
+	}
+}
+
+void ufshpb_remove(struct ufs_hba *hba)
+{
+}
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
new file mode 100644
index 000000000000..6fa5db94bcae
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -0,0 +1,167 @@
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
+#define HPB_RSP_NONE				0x0
+#define	HPB_RSP_REQ_REGION_UPDATE		0x1
+#define HPB_RSP_DEV_RESET			0x2
+#define MAX_ACTIVE_NUM				2
+#define MAX_INACTIVE_NUM			2
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
+#define HPB_RESET_REQ_RETRIES			10
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
+	spinlock_t hpb_state_lock;
+	atomic_t hpb_state; /* hold hpb_state_lock */
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
+	struct list_head list_hpb_lu;
+};
+
+struct ufs_hba;
+struct ufshcd_lrb;
+
+#ifndef CONFIG_SCSI_UFS_HPB
+static void ufshpb_resume(struct ufs_hba *hba) {}
+static void ufshpb_suspend(struct ufs_hba *hba) {}
+static void ufshpb_reset(struct ufs_hba *hba) {}
+static void ufshpb_reset_host(struct ufs_hba *hba) {}
+static void ufshpb_remove(struct ufs_hba *hba) {}
+static void ufshpb_init(struct ufs_hba *hba) {}
+static void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev) {}
+static void ufshpb_destroy_lu(struct ufs_hba *hba, struct scsi_device *sdev) {}
+static bool ufshpb_is_allowed(struct ufs_hba *hba) { return false; }
+static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
+static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
+#else
+void ufshpb_resume(struct ufs_hba *hba);
+void ufshpb_suspend(struct ufs_hba *hba);
+void ufshpb_reset(struct ufs_hba *hba);
+void ufshpb_reset_host(struct ufs_hba *hba);
+void ufshpb_init(struct ufs_hba *hba);
+void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device *sdev);
+void ufshpb_destroy_lu(struct ufs_hba *hba, struct scsi_device *sdev);
+void ufshpb_remove(struct ufs_hba *hba);
+bool ufshpb_is_allowed(struct ufs_hba *hba);
+void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf);
+void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf);
+extern struct attribute_group ufs_sysfs_hpb_stat_group;
+#endif
+
+#endif /* End of Header */
-- 
2.25.1


