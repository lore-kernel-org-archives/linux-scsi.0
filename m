Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501FEC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 08:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F57322C7E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 08:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgLUIk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 03:40:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16919 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbgLUIk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 03:40:26 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201221083935epoutp034e015d1393c8ed1bbd3d08a858f26d8d~SrpXhSMfv2941429414epoutp03C
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 08:39:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201221083935epoutp034e015d1393c8ed1bbd3d08a858f26d8d~SrpXhSMfv2941429414epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608539975;
        bh=dpuP2yRjl/Yt0baqVjHSVubhaDwczk9NJp7rFYOGxFA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=hD3ggTOGeLhGdibgkz4qMbYLjjXCVTxm6cYTQq6MaIjnlt5P3pqTa1TO/YSNMjfC3
         DvO3+K4FSuRj2e32AlQinLvZszBOLNbZlubfydrDiiI4+7YA63LxC9GRLY5wG6c4uQ
         8A/UruYgqICfqj+oiJ0RWv3KGzsK5t3HZznhgebw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201221083933epcas2p1b38ed12a8befc8265cdae8aa4265d68e~SrpV4qUxD1221812218epcas2p1j;
        Mon, 21 Dec 2020 08:39:33 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CztDz2H0Jz4x9Q1; Mon, 21 Dec
        2020 08:39:31 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-84-5fe05f438576
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        DA.5B.52511.34F50EF5; Mon, 21 Dec 2020 17:39:31 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v17 1/3] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20201221083837epcms2p4989308d3a20500027482279d92668839@epcms2p4>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201221083930epcms2p2c2c0b9b1863a4e41bcfb95f308345fba@epcms2p2>
Date:   Mon, 21 Dec 2020 17:39:30 +0900
X-CMS-MailID: 20201221083930epcms2p2c2c0b9b1863a4e41bcfb95f308345fba
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA51Ta0xTZxjOudBTSLodC8oH7tIc5yYgpS1t9+FEMYzlZGzqD3bTsHosJ6UR
        WnJaENmMTRSEAo4pG1rRCToUhhQIhQLhssKA/WAJY3NcxsQJYzBABiOxQ3D0wjT7uX/P93zP
        +z7P+134mLCFCOZrdUaW0zEpFM8Pb+wKgeGxqnGVpPYWH9aNzfjA8auNPNiW00fAaeePPNg1
        Ok/AzxecGFy0VvjAaUcIrBp/D56+buXB0n4TCgs/sfFg+VAjCgdbSnkw/yc7D97sXUPhaIMf
        /NI2jMC8kmoclpe14jEB9OAP8fTguUKUbraMEXRReSdCd1ypJugz33bg9J+TIzh9rqEKoZfq
        X6DPduajB/0OmZDdDKdO1mawIlan1idpdZpo6p2EN8IhJUrWG4zR1GEplImlUQqxPEosezVx
        l1QikSkokY5JZaOpzHBvNSXi1GnraiNrMHKsml2nuBiDkdGwYgOTakjXacRqfSolymBS0tfr
        qIg9u5NZJonlREcmkOSegRwizWZDM2du7zUhDx8jZsSXD0g5mF0+j5kRP76QtCNgtdbpY0b4
        fAG5Caza/V0afzIKdFW2YS4sJClgHbAQHl4MRu5Vu/vwyJ2gpO8u4eoTQGbjoGD+L8S1wMhl
        FCxOXUY9bgJw8ewk7sFbQdNNm7val9wP1mxmnoffAR5WFGIevBkMfzVHbOAHPV94UweA7F/6
        vZpNYNzZ6uWDQE/rgtfrFLD9/Lc7BCALENDVPOLj2YgAd3Lr3CEE5NugaXAUd02Mk9tBRfdO
        j+R18Gut2d0TI18ETXOlmEuCkSHA2hLhgoDcBrpH8I2pTHUrxH8xRj4DcrtW/+XtVye8yV4G
        NU4rWoRsszw5actTXpYnXtcQrArZwqYZUjWsQZYmf/qm6xH3+w+l7cjluQWxA0H5iAMBfIwK
        ECiD76qEgiTmRBbL6VVcegprcCBZ60N+igVvVuvXP5DOqJIqJTKlIlIeGamQK/43rZAplZIo
        BVQoZZAKFHCScZWQ1DBG9hjLprHchjnK9w02ob20OOtZxXeJp+rlR+euxDQHApRXQzxee6ky
        M3xf4HOhQe/eOY53j2XfP7CWkV8ZdKIjuOBWWc6W9uYix/atj4ofGWM5oPdXR8VcyKFGv249
        uW/sWPvaH9FQalq4oJoUOc6fbipu2HGvVk2/eTCTFlU0H4Z9zxMPbmhHzbLeoaX3T9YlfnPj
        Q/5r5MrMwFK7Jvt+pPBQYe9KnP3AdJW2rCIwdRbsz8qOm/+seDFP8UqeadgSFt8YD7RBdmnM
        grVmas9yRv3RWK3yrWu3f7veuKufuTS0uDfMGFttHIzr/AD5/ndyTCJPMB7/mEoYmMidcLa2
        fdQvK5gizxzBSuIls2EUbkhmpKEYZ2D+AaDgfNDNBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201221083837epcms2p4989308d3a20500027482279d92668839
References: <20201221083837epcms2p4989308d3a20500027482279d92668839@epcms2p4>
        <CGME20201221083837epcms2p4989308d3a20500027482279d92668839@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a patch for the HPB initialization and adds HPB function calls to
UFS core driver.

NAND flash-based storage devices, including UFS, have mechanisms to
translate logical addresses of IO requests to the corresponding physical
addresses of the flash storage.
In UFS, Logical-address-to-Physical-address (L2P) map data, which is
required to identify the physical address for the requested IOs, can only
be partially stored in SRAM from NAND flash. Due to this partial loading,
accessing the flash address area where the L2P information for that address
is not loaded in the SRAM can result in serious performance degradation.

The basic concept of HPB is to cache L2P mapping entries in host system
memory so that both physical block address (PBA) and logical block address
(LBA) can be delivered in HPB read command.
The HPB READ command allows to read data faster than a read command in UFS
since it provides the physical address (HPB Entry) of the desired logical
block in addition to its logical address. The UFS device can access the
physical block in NAND directly without searching and uploading L2P mapping
table. This improves read performance because the NAND read operation for
uploading L2P mapping table is removed.

In HPB initialization, the host checks if the UFS device supports HPB
feature and retrieves related device capabilities. Then, some HPB
parameters are configured in the device.

We measured the total start-up time of popular applications and observed
the difference by enabling the HPB.
Popular applications are 12 game apps and 24 non-game apps. Each target
applications were launched in order. The cycle consists of running 36
applications in sequence. We repeated the cycle for observing performance
improvement by L2P mapping cache hit in HPB.

The Following is experiment environment:
 - kernel version: 4.4.0
 - RAM: 8GB
 - UFS 2.1 (64GB)

Result:
+-------+----------+----------+-------+
| cycle | baseline | with HPB | diff  |
+-------+----------+----------+-------+
| 1     | 272.4    | 264.9    | -7.5  |
| 2     | 250.4    | 248.2    | -2.2  |
| 3     | 226.2    | 215.6    | -10.6 |
| 4     | 230.6    | 214.8    | -15.8 |
| 5     | 232.0    | 218.1    | -13.9 |
| 6     | 231.9    | 212.6    | -19.3 |
+-------+----------+----------+-------+

We also measured HPB performance using iozone.
Here is my iozone script:
iozone -r 4k -+n -i2 -ecI -t 16 -l 16 -u 16
-s $IO_RANGE/16 -F mnt/tmp_1 mnt/tmp_2 mnt/tmp_3 mnt/tmp_4 mnt/tmp_5
mnt/tmp_6 mnt/tmp_7 mnt/tmp_8 mnt/tmp_9 mnt/tmp_10 mnt/tmp_11 mnt/tmp_12
mnt/tmp_13 mnt/tmp_14 mnt/tmp_15 mnt/tmp_16

Result:
+----------+--------+---------+
| IO range | HPB on | HPB off |
+----------+--------+---------+
|   1 GB   | 294.8  | 300.87  |
|   4 GB   | 293.51 | 179.35  |
|   8 GB   | 294.85 | 162.52  |
|  16 GB   | 293.45 | 156.26  |
|  32 GB   | 277.4  | 153.25  |
+----------+--------+---------+

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Can Guo <cang@codeaurora.org>
Acked-by: Avri Altman <Avri.Altman@wdc.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  71 +++
 drivers/scsi/ufs/Kconfig                   |   9 +
 drivers/scsi/ufs/Makefile                  |   1 +
 drivers/scsi/ufs/ufs-sysfs.c               |  18 +
 drivers/scsi/ufs/ufs.h                     |  13 +
 drivers/scsi/ufs/ufshcd.c                  |  48 ++
 drivers/scsi/ufs/ufshcd.h                  |  23 +-
 drivers/scsi/ufs/ufshpb.c                  | 559 +++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  | 166 ++++++
 9 files changed, 907 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d1a352194d2e..6e57e15ff3a8 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1019,3 +1019,74 @@ Contact:	Asutosh Das <asutoshd@codeaurora.org>
 Description:	This entry shows the configured size of WriteBooster buffer.
 		0400h corresponds to 4GB.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/hpb_version
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the HPB specification version.
+		The full information about the descriptor could be found at UFS
+		HPB (Host Performance Booster) Extension specifications.
+		Example: version 1.2.3 = 0123h
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/hpb_control
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows an indication of the HPB control mode.
+		00h: Host control mode
+		01h: Device control mode
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/hpb_region_size
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the bHPBRegionSize which can be calculated
+		as in the following (in bytes):
+		HPB Region size = 512B * 2^bHPBRegionSize
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/hpb_number_lu
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the maximum number of HPB LU supported	by
+		the device.
+		00h: HPB is not supported by the device.
+		01h ~ 20h: Maximum number of HPB LU supported by the device
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/hpb_subregion_size
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the bHPBSubRegionSize, which can be
+		calculated as in the following (in bytes) and shall be a multiple of
+		logical block size:
+		HPB Sub-Region size = 512B x 2^bHPBSubRegionSize
+		bHPBSubRegionSize shall not exceed bHPBRegionSize.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/hpb_max_active_regions
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the maximum number of active HPB regions that
+		is supported by the device.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/hpb_lu_max_active_regions
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the maximum number of HPB regions assigned to
+		the HPB logical unit.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/hpb_pinned_region_start_offset
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the start offset of HPB pinned region.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/hpb_number_pinned_regions
+Date:		December 2020
+Contact:	Daejun Park <daejun7.park@samsung.com>
+Description:	This entry shows the Number of HPB pinned regions assigned to
+		the HPB logical unit.
+		The file is read only.
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 3f6dfed4fe84..0dfaccec779d 100644
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
index 08e72b7eef6a..c36d59ea136e 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -291,6 +291,8 @@ UFS_DEVICE_DESC_PARAM(device_version, _DEV_VER, 2);
 UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, _NUM_SEC_WPA, 1);
 UFS_DEVICE_DESC_PARAM(psa_max_data_size, _PSA_MAX_DATA, 4);
 UFS_DEVICE_DESC_PARAM(psa_state_timeout, _PSA_TMT, 1);
+UFS_DEVICE_DESC_PARAM(hpb_version, _HPB_VER, 2);
+UFS_DEVICE_DESC_PARAM(hpb_control, _HPB_CONTROL, 1);
 UFS_DEVICE_DESC_PARAM(ext_feature_sup, _EXT_UFS_FEATURE_SUP, 4);
 UFS_DEVICE_DESC_PARAM(wb_presv_us_en, _WB_PRESRV_USRSPC_EN, 1);
 UFS_DEVICE_DESC_PARAM(wb_type, _WB_TYPE, 1);
@@ -323,6 +325,8 @@ static struct attribute *ufs_sysfs_device_descriptor[] = {
 	&dev_attr_number_of_secure_wpa.attr,
 	&dev_attr_psa_max_data_size.attr,
 	&dev_attr_psa_state_timeout.attr,
+	&dev_attr_hpb_version.attr,
+	&dev_attr_hpb_control.attr,
 	&dev_attr_ext_feature_sup.attr,
 	&dev_attr_wb_presv_us_en.attr,
 	&dev_attr_wb_type.attr,
@@ -396,6 +400,10 @@ UFS_GEOMETRY_DESC_PARAM(enh4_memory_max_alloc_units,
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
@@ -433,6 +441,10 @@ static struct attribute *ufs_sysfs_geometry_descriptor[] = {
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
@@ -815,6 +827,9 @@ UFS_UNIT_DESC_PARAM(provisioning_type, _PROVISIONING_TYPE, 1);
 UFS_UNIT_DESC_PARAM(physical_memory_resourse_count, _PHY_MEM_RSRC_CNT, 8);
 UFS_UNIT_DESC_PARAM(context_capabilities, _CTX_CAPABILITIES, 2);
 UFS_UNIT_DESC_PARAM(large_unit_granularity, _LARGE_UNIT_SIZE_M1, 1);
+UFS_UNIT_DESC_PARAM(hpb_lu_max_active_regions, _HPB_LU_MAX_ACTIVE_RGNS, 2);
+UFS_UNIT_DESC_PARAM(hpb_pinned_region_start_offset, _HPB_PIN_RGN_START_OFF, 2);
+UFS_UNIT_DESC_PARAM(hpb_number_pinned_regions, _HPB_NUM_PIN_RGNS, 2);
 UFS_UNIT_DESC_PARAM(wb_buf_alloc_units, _WB_BUF_ALLOC_UNITS, 4);
 
 
@@ -832,6 +847,9 @@ static struct attribute *ufs_sysfs_unit_descriptor[] = {
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
index 14dfda735adf..cbab6f54eb12 100644
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
 
 #define POWER_DESC_MAX_ACTV_ICC_LVLS		16
 
@@ -538,6 +550,7 @@ struct ufs_dev_info {
 	u8 *model;
 	u16 wspecversion;
 	u32 clk_gating_wait_us;
+	u8 b_ufs_feature_sup;
 	u32 d_ext_ufs_feature_sup;
 	u8 b_wb_buffer_type;
 	u32 d_wb_alloc_units;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add25a7e..d8eb45ca485a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -22,6 +22,7 @@
 #include "ufs-sysfs.h"
 #include "ufs_bsg.h"
 #include "ufshcd-crypto.h"
+#include "ufshpb.h"
 #include <asm/unaligned.h>
 #include <linux/blkdev.h>
 
@@ -4782,6 +4783,26 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
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
@@ -4791,6 +4812,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 
+	ufshcd_hpb_configure(hba, sdev);
+
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
@@ -4810,6 +4833,9 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 	struct ufs_hba *hba;
 
 	hba = shost_priv(sdev->host);
+
+	ufshcd_hpb_destroy(hba, sdev);
+
 	/* Drop the reference as it won't be needed anymore */
 	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN) {
 		unsigned long flags;
@@ -6896,6 +6922,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 * Stop the host controller and complete the requests
 	 * cleared by h/w
 	 */
+	ufshpb_reset_host(hba);
+
 	ufshcd_hba_stop(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -7332,9 +7360,14 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
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
@@ -7563,6 +7596,10 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 	else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
 		hba->dev_info.max_lu_supported = 8;
 
+	if (hba->desc_size[QUERY_DESC_IDN_GEOMETRY] >=
+		GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGS)
+		ufshpb_get_geo_info(hba, desc_buf);
+
 out:
 	kfree(desc_buf);
 	return err;
@@ -7702,6 +7739,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	}
 
 	ufs_bsg_probe(hba);
+	ufshpb_init(hba);
 	scsi_scan_host(hba->host);
 	pm_runtime_put_sync(hba->dev);
 
@@ -7845,6 +7883,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
+	ufshpb_reset(hba);
 out:
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ret)
@@ -7895,6 +7934,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
 	&ufs_sysfs_lun_attributes_group,
+#ifdef CONFIG_SCSI_UFS_HPB
+	&ufs_sysfs_hpb_stat_group,
+#endif
 	NULL,
 };
 
@@ -8608,6 +8650,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		req_link_state = UIC_LINK_OFF_STATE;
 	}
 
+	ufshpb_suspend(hba);
+
 	/*
 	 * If we can't transition into any of the low power modes
 	 * just gate the clocks.
@@ -8746,6 +8790,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
 	ufshcd_release(hba);
+	ufshpb_resume(hba);
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
@@ -8850,6 +8895,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
 
+	ufshpb_resume(hba);
+
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		hba->dev_info.b_rpm_dev_flush_capable = false;
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
@@ -9088,6 +9135,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
+	ufshpb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_cleanup_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9bb5f0ed4124..d46e9ddcb11e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -623,6 +623,25 @@ struct ufs_hba_variant_params {
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
@@ -808,7 +827,9 @@ struct ufs_hba {
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
index 000000000000..badb613ac281
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -0,0 +1,559 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Universal Flash Storage Host Performance Booster
+ *
+ * Copyright (C) 2017-2020 Samsung Electronics Co., Ltd.
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
+static struct ufshpb_lu *ufshpb_get_hpb_data(struct scsi_device *sdev)
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
+	return sysfs_emit(buf, "%llu\n", hpb->stats.__name);		\
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
+	hpb->stats.hit_cnt = 0;
+	hpb->stats.miss_cnt = 0;
+	hpb->stats.rb_noti_cnt = 0;
+	hpb->stats.rb_active_cnt = 0;
+	hpb->stats.rb_inactive_cnt = 0;
+	hpb->stats.map_req_cnt = 0;
+}
+
+static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
+{
+	int ret;
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
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
new file mode 100644
index 000000000000..74088ce16cac
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Universal Flash Storage Host Performance Booster
+ *
+ * Copyright (C) 2017-2020 Samsung Electronics Co., Ltd.
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
+#define HPB_RSP_REQ_REGION_UPDATE		0x1
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
+	u64 hit_cnt;
+	u64 miss_cnt;
+	u64 rb_noti_cnt;
+	u64 rb_active_cnt;
+	u64 rb_inactive_cnt;
+	u64 map_req_cnt;
+};
+
+struct ufshpb_lu {
+	int lun;
+	struct scsi_device *sdev_ufs_lu;
+	struct ufshpb_region *rgn_tbl;
+
+	atomic_t hpb_state;
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
+void ufshpb_remove(struct ufs_hba *hba) {}
+bool ufshpb_is_allowed(struct ufs_hba *hba);
+void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf);
+void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf);
+extern struct attribute_group ufs_sysfs_hpb_stat_group;
+#endif
+
+#endif /* End of Header */
-- 
2.25.1

