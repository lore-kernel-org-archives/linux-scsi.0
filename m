Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6983BECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 13:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiILNpb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiILNpa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 09:45:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A848E1C934
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2022 06:45:28 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r17so8314502pgr.7
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2022 06:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date;
        bh=hZrBVshfPAwr7jz6xR3dBr5tYEl2WR0JTZpXqflYeZs=;
        b=dXlVwE+YQM25IcEQqLF5mM7UkhmaJ3zMAr/PGA08bJRuO8x5JkAp4/212833CSistA
         4K9VctSvAMsIjKpQsR2TTIaDHgiDjPPHJnoTAUSF/w61OWPSZsF4QjO6kRKcbnRj9Qeg
         TlkMvWCrHnP6LwitOejTlXeykms/sug6iGMY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=hZrBVshfPAwr7jz6xR3dBr5tYEl2WR0JTZpXqflYeZs=;
        b=251Pgy8VygSrrK9DjGHL/PL24wCs4JCsbTgoKNtfzEbu8OgmG+cUGFYaAYGmObSz2K
         RZZbCK/4/wBx5XB3ISAESb/WAhXBbPWgF19cjTpAzAhQV8ngMewz0oJ8HlmaH7YNX40G
         yBlDfd9C3Juk+g5fBepoza2x543csyiDy0cXTQXdmToruILWbAhxqZIwz+7z2XcLOW6L
         Fd37w06W6mF31xlLvreSX/uwrTQatXsF2oa6ngX8QVCDKtOu+lE8u3z8KzhBOB7WRrjQ
         7/aziWCSPcLZDGI8WSLUFRzjI4KU9oF0Xt59b5nv/Tr52VGWvC6jCg3ydFmbU3oGcWjP
         eWWg==
X-Gm-Message-State: ACgBeo09berrbWp8HW0lZ/318xfsgQgbr5arEPF/ZZI8Pj8dsL6hh11y
        /EgipFMxjNOzsEHDarMDwM6v+JHiNbYzhyHW7lTOPEKVvc7rLP5PpMrS1YMjP51FmKodAgfV9R0
        s8282s5kmVIkxY3m74z9vWwvQvAojAWmKjFNnxZMlPshOBrG6m4Xte6Dwp7QBbv1/VkPQ4zKNLl
        L2uRd5R9s+
X-Google-Smtp-Source: AA6agR5AvlY591lbmtsrHnCelX8BwhEj5aecIE+xdAq6zQeFi6TQGEr8FRWUxuXt+bZa5et+gjnJ7g==
X-Received: by 2002:aa7:8704:0:b0:542:5288:5e32 with SMTP id b4-20020aa78704000000b0054252885e32mr8704908pfo.84.1662990327561;
        Mon, 12 Sep 2022 06:45:27 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u7-20020a170903124700b00176e8f85146sm6112900plh.185.2022.09.12.06.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 06:45:26 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v2 1/9] mpi3mr: Update mpi3 header files
Date:   Mon, 12 Sep 2022 19:27:34 +0530
Message-Id: <20220912135742.11764-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220912135742.11764-1-sreekanth.reddy@broadcom.com>
References: <20220912135742.11764-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c7c36105e87b1b48"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c7c36105e87b1b48
Content-Transfer-Encoding: 8bit

Update the mpi3 header files.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 171 +++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |   6 +-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |   5 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |  22 ++-
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |   3 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   8 +-
 7 files changed, 165 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 4cd9f24..0a2af48 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2017-2021 Broadcom Inc. All rights reserved.
- *
+ *  Copyright 2017-2022 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_CNFG_H
 #define MPI30_CNFG_H     1
@@ -100,6 +99,7 @@ struct mpi3_config_page_header {
 #define MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK             (0xf0)
 #define MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT            (4)
 #define MPI3_SAS_NEG_LINK_RATE_PHYSICAL_MASK            (0x0f)
+#define MPI3_SAS_NEG_LINK_RATE_PHYSICAL_SHIFT           (0)
 #define MPI3_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE        (0x00)
 #define MPI3_SAS_NEG_LINK_RATE_PHY_DISABLED             (0x01)
 #define MPI3_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED       (0x02)
@@ -135,6 +135,16 @@ struct mpi3_config_page_header {
 #define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_ACTIVE     (0x00000000)
 #define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_PARTIAL    (0x08000000)
 #define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_SLUMBER    (0x10000000)
+#define MPI3_SAS_NEG_LINK_RATE_PHYSICAL_SHIFT                 (0)
+#define MPI3_SAS_PHYINFO_REQUESTED_INSIDE_ZPSDS_CHANGED_MASK  (0x04000000)
+#define MPI3_SAS_PHYINFO_REQUESTED_INSIDE_ZPSDS_CHANGED_SHIFT (26)
+#define MPI3_SAS_PHYINFO_INSIDE_ZPSDS_PERSISTENT_MASK         (0x02000000)
+#define MPI3_SAS_PHYINFO_INSIDE_ZPSDS_PERSISTENT_SHIFT        (25)
+#define MPI3_SAS_PHYINFO_REQUESTED_INSIDE_ZPSDS_MASK          (0x01000000)
+#define MPI3_SAS_PHYINFO_REQUESTED_INSIDE_ZPSDS_SHIFT         (24)
+#define MPI3_SAS_PHYINFO_ZONE_GROUP_PERSISTENT                (0x00400000)
+#define MPI3_SAS_PHYINFO_INSIDE_ZPSDS_WITHIN                  (0x00200000)
+#define MPI3_SAS_PHYINFO_ZONING_ENABLED                       (0x00100000)
 #define MPI3_SAS_PHYINFO_REASON_MASK                    (0x000f0000)
 #define MPI3_SAS_PHYINFO_REASON_UNKNOWN                 (0x00000000)
 #define MPI3_SAS_PHYINFO_REASON_POWER_ON                (0x00010000)
@@ -210,7 +220,7 @@ struct mpi3_man_page0 {
 	u8                                 board_rework_day;
 	u8                                 board_rework_month;
 	__le16                             board_rework_year;
-	__le64                             board_revision;
+	u8                                 board_revision[8];
 	u8                                 e_pack_fru[16];
 	u8                                 product_name[256];
 };
@@ -226,6 +236,15 @@ struct mpi3_man_page1 {
 };
 
 #define MPI3_MAN1_PAGEVERSION                                 (0x00)
+struct mpi3_man_page2 {
+	struct mpi3_config_page_header         header;
+	u8                                 flags;
+	u8                                 reserved09[3];
+	__le32                             reserved0c[3];
+	u8                                 oem_board_tracer_number[32];
+};
+#define MPI3_MAN2_PAGEVERSION                                 (0x00)
+#define MPI3_MAN2_FLAGS_TRACER_PRESENT                        (0x01)
 struct mpi3_man5_phy_entry {
 	__le64     ioc_wwid;
 	__le64     device_name;
@@ -338,6 +357,8 @@ struct mpi3_man7_receptacle_info {
 #define MPI3_MAN7_LOCATION_INTERNAL                        (0x01)
 #define MPI3_MAN7_LOCATION_EXTERNAL                        (0x02)
 #define MPI3_MAN7_LOCATION_VIRTUAL                         (0x03)
+#define MPI3_MAN7_LOCATION_HOST                            (0x04)
+#define MPI3_MAN7_CONNECTOR_TYPE_NO_INFO                   (0x00)
 #define MPI3_MAN7_PEDCLK_ROUTING_MASK                      (0x10)
 #define MPI3_MAN7_PEDCLK_ROUTING_DIRECT                    (0x00)
 #define MPI3_MAN7_PEDCLK_ROUTING_CLOCK_BUFFER              (0x10)
@@ -369,7 +390,8 @@ struct mpi3_man8_phy_info {
 	__le32                             reserved0c;
 };
 
-#define MPI3_MAN8_PHY_INFO_RECEPTACLE_ID_HOST_PHY          (0xff)
+#define MPI3_MAN8_PHY_INFO_RECEPTACLE_ID_NOT_ASSOCIATED    (0xff)
+#define MPI3_MAN8_PHY_INFO_CONNECTOR_LANE_NOT_ASSOCIATED   (0xff)
 #ifndef MPI3_MAN8_PHY_INFO_MAX
 #define MPI3_MAN8_PHY_INFO_MAX                      (1)
 #endif
@@ -536,6 +558,10 @@ struct mpi3_man11_bkplane_spec_non_ubm_format {
 #define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_GROUP_MASK                    (0xf000)
 #define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_GROUP_SHIFT                   (12)
 #define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_REFCLK_POLICY_ALWAYS_ENABLED  (0x0200)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_LINKWIDTH_MASK                (0x00c0)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_LINKWIDTH_4                   (0x0000)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_LINKWIDTH_2                   (0x0040)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_LINKWIDTH_1                   (0x0080)
 #define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_PRESENCE_DETECT_MASK          (0x0030)
 #define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_PRESENCE_DETECT_GPIO          (0x0000)
 #define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_PRESENCE_DETECT_REG           (0x0010)
@@ -825,19 +851,16 @@ struct mpi3_man_page21 {
 };
 
 #define MPI3_MAN21_PAGEVERSION                                       (0x00)
-#define MPI3_MAN21_FLAGS_HOST_METADATA_CAPABILITY_MASK               (0x80)
-#define MPI3_MAN21_FLAGS_HOST_METADATA_CAPABILITY_ENABLED            (0x80)
-#define MPI3_MAN21_FLAGS_HOST_METADATA_CAPABILITY_DISABLED           (0x00)
-#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_MASK                     (0x60)
-#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_BLOCK                    (0x00)
-#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_ALLOW                    (0x20)
-#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_WARN                     (0x40)
-#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_MASK              (0x08)
-#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_ALLOW             (0x00)
-#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_PREVENT           (0x08)
-#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_MASK                          (0x01)
-#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_DEFAULT                       (0x00)
-#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_OEM_SPECIFIC                  (0x01)
+#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_MASK                     (0x00000060)
+#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_BLOCK                    (0x00000000)
+#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_ALLOW                    (0x00000020)
+#define MPI3_MAN21_FLAGS_UNCERTIFIED_DRIVES_WARN                     (0x00000040)
+#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_MASK              (0x00000008)
+#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_ALLOW             (0x00000000)
+#define MPI3_MAN21_FLAGS_BLOCK_SSD_WR_CACHE_CHANGE_PREVENT           (0x00000008)
+#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_MASK                          (0x00000001)
+#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_DEFAULT                       (0x00000000)
+#define MPI3_MAN21_FLAGS_SES_VPD_ASSOC_OEM_SPECIFIC                  (0x00000001)
 #ifndef MPI3_MAN_PROD_SPECIFIC_MAX
 #define MPI3_MAN_PROD_SPECIFIC_MAX                      (1)
 #endif
@@ -995,7 +1018,12 @@ struct mpi3_io_unit_page5 {
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_SSD_MASK         (0x000c)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_SSD_SHIFT        (2)
 #define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAS_SSD_MASK          (0x0003)
-#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAA_SSD_SHIFT         (0)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAS_SSD_SHIFT         (0)
+#define MPI3_IOUNIT5_FLAGS_SATAPUIS_MASK                   (0x0c)
+#define MPI3_IOUNIT5_FLAGS_SATAPUIS_NOT_SUPPORTED          (0x00)
+#define MPI3_IOUNIT5_FLAGS_SATAPUIS_OS_CONTROLLED          (0x04)
+#define MPI3_IOUNIT5_FLAGS_SATAPUIS_APP_CONTROLLED         (0x08)
+#define MPI3_IOUNIT5_FLAGS_SATAPUIS_BLOCKED                (0x0c)
 #define MPI3_IOUNIT5_FLAGS_POWER_CAPABLE_SPINUP            (0x02)
 #define MPI3_IOUNIT5_FLAGS_AUTO_PORT_ENABLE                (0x01)
 #define MPI3_IOUNIT5_PHY_SPINUP_GROUP_MASK                 (0x03)
@@ -1027,7 +1055,8 @@ struct mpi3_io_unit_page8 {
 	u8                                 slots_available;
 	u8                                 current_key_encryption_algo;
 	u8                                 key_digest_hash_algo;
-	__le32                             reserved10[2];
+	union mpi3_version_union              current_svn;
+	__le32                             reserved14;
 	__le32                             current_key[128];
 	union mpi3_iounit8_digest             digest[MPI3_IOUNIT8_DIGEST_MAX];
 };
@@ -1036,6 +1065,7 @@ struct mpi3_io_unit_page8 {
 #define MPI3_IOUNIT8_SBMODE_SECURE_DEBUG          (0x04)
 #define MPI3_IOUNIT8_SBMODE_HARD_SECURE           (0x02)
 #define MPI3_IOUNIT8_SBMODE_CONFIG_SECURE         (0x01)
+#define MPI3_IOUNIT8_SBSTATE_SVN_UPDATE_PENDING   (0x04)
 #define MPI3_IOUNIT8_SBSTATE_KEY_UPDATE_PENDING   (0x02)
 #define MPI3_IOUNIT8_SBSTATE_SECURE_BOOT_ENABLED  (0x01)
 struct mpi3_io_unit_page9 {
@@ -1045,9 +1075,14 @@ struct mpi3_io_unit_page9 {
 	__le16                             reserved0e;
 };
 
-#define MPI3_IOUNIT9_PAGEVERSION                  (0x00)
-#define MPI3_IOUNIT9_FLAGS_VDFIRST_ENABLED         (0x01)
-#define MPI3_IOUNIT9_FIRSTDEVICE_UNKNOWN          (0xffff)
+#define MPI3_IOUNIT9_PAGEVERSION                                  (0x00)
+#define MPI3_IOUNIT9_FLAGS_UBM_ENCLOSURE_ORDER_MASK               (0x00000006)
+#define MPI3_IOUNIT9_FLAGS_UBM_ENCLOSURE_ORDER_SHIFT              (1)
+#define MPI3_IOUNIT9_FLAGS_UBM_ENCLOSURE_ORDER_NONE               (0x00000000)
+#define MPI3_IOUNIT9_FLAGS_UBM_ENCLOSURE_ORDER_RECEPTACLE         (0x00000002)
+#define MPI3_IOUNIT9_FLAGS_UBM_ENCLOSURE_ORDER_BACKPLANE_TYPE     (0x00000004)
+#define MPI3_IOUNIT9_FLAGS_VDFIRST_ENABLED                        (0x00000001)
+#define MPI3_IOUNIT9_FIRSTDEVICE_UNKNOWN                          (0xffff)
 struct mpi3_io_unit_page10 {
 	struct mpi3_config_page_header         header;
 	u8                                 flags;
@@ -1090,6 +1125,57 @@ struct mpi3_io_unit_page11 {
 	struct mpi3_iounit11_profile           profile[MPI3_IOUNIT11_PROFILE_MAX];
 };
 #define MPI3_IOUNIT11_PAGEVERSION                  (0x00)
+#ifndef MPI3_IOUNIT12_BUCKET_MAX
+#define MPI3_IOUNIT12_BUCKET_MAX                   (1)
+#endif
+struct mpi3_iounit12_bucket {
+	u8                                 coalescing_depth;
+	u8                                 coalescing_timeout;
+	__le16                             io_count_low_boundary;
+	__le32                             reserved04;
+};
+struct mpi3_io_unit_page12 {
+	struct mpi3_config_page_header         header;
+	__le32                             flags;
+	__le32                             reserved0c[4];
+	u8                                 num_buckets;
+	u8                                 reserved1d[3];
+	struct mpi3_iounit12_bucket            bucket[MPI3_IOUNIT12_BUCKET_MAX];
+};
+#define MPI3_IOUNIT12_PAGEVERSION                  (0x00)
+#define MPI3_IOUNIT12_FLAGS_NUMPASSES_MASK         (0x00000300)
+#define MPI3_IOUNIT12_FLAGS_NUMPASSES_SHIFT        (8)
+#define MPI3_IOUNIT12_FLAGS_NUMPASSES_8            (0x00000000)
+#define MPI3_IOUNIT12_FLAGS_NUMPASSES_16           (0x00000100)
+#define MPI3_IOUNIT12_FLAGS_NUMPASSES_32           (0x00000200)
+#define MPI3_IOUNIT12_FLAGS_NUMPASSES_64           (0x00000300)
+#define MPI3_IOUNIT12_FLAGS_PASSPERIOD_MASK        (0x00000003)
+#define MPI3_IOUNIT12_FLAGS_PASSPERIOD_DISABLED    (0x00000000)
+#define MPI3_IOUNIT12_FLAGS_PASSPERIOD_500US       (0x00000001)
+#define MPI3_IOUNIT12_FLAGS_PASSPERIOD_1MS         (0x00000002)
+#define MPI3_IOUNIT12_FLAGS_PASSPERIOD_2MS         (0x00000003)
+#ifndef MPI3_IOUNIT13_FUNC_MAX
+#define MPI3_IOUNIT13_FUNC_MAX                                     (1)
+#endif
+struct mpi3_iounit13_allowed_function {
+	__le16                             sub_function;
+	u8                                 function_code;
+	u8                                 fuction_flags;
+};
+#define MPI3_IOUNIT13_FUNCTION_FLAGS_ADMIN_BLOCKED                 (0x04)
+#define MPI3_IOUNIT13_FUNCTION_FLAGS_OOB_BLOCKED                   (0x02)
+#define MPI3_IOUNIT13_FUNCTION_FLAGS_CHECK_SUBFUNCTION_ENABLED     (0x01)
+struct mpi3_io_unit_page13 {
+	struct mpi3_config_page_header         header;
+	__le16                             flags;
+	__le16                             reserved0a;
+	u8                                 num_allowed_functions;
+	u8                                 reserved0d[3];
+	struct mpi3_iounit13_allowed_function  allowed_function[MPI3_IOUNIT13_FUNC_MAX];
+};
+#define MPI3_IOUNIT13_PAGEVERSION                                  (0x00)
+#define MPI3_IOUNIT13_FLAGS_ADMIN_BLOCKED                          (0x0002)
+#define MPI3_IOUNIT13_FLAGS_OOB_BLOCKED                            (0x0001)
 struct mpi3_ioc_page0 {
 	struct mpi3_config_page_header         header;
 	__le32                             reserved08;
@@ -1182,6 +1268,7 @@ struct mpi3_driver_page0 {
 	__le32                             reserved18;
 };
 #define MPI3_DRIVER0_PAGEVERSION               (0x00)
+#define MPI3_DRIVER0_BSDOPTS_HEADLESS_MODE_ENABLE           (0x00000008)
 #define MPI3_DRIVER0_BSDOPTS_DIS_HII_CONFIG_UTIL            (0x00000004)
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_MASK              (0x00000003)
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_IOC_AND_DEVS      (0x00000000)
@@ -1906,19 +1993,30 @@ struct mpi3_pcie_io_unit_page1 {
 };
 
 #define MPI3_PCIEIOUNIT1_PAGEVERSION                                           (0x00)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_OVERRIDE_DISABLE                   (0x80)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_DISABLE                  (0x40)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_MASK                (0x30)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_PERST_OVERRIDE_MASK                     (0xe0000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_PERST_OVERRIDE_NONE                     (0x00000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_PERST_OVERRIDE_DEASSERT                 (0x20000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_PERST_OVERRIDE_ASSERT                   (0x40000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_PERST_OVERRIDE_BACKPLANE_ERROR          (0x60000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_REFCLK_OVERRIDE_MASK                    (0x1c000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_REFCLK_OVERRIDE_NONE                    (0x00000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_REFCLK_OVERRIDE_DEASSERT                (0x04000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_REFCLK_OVERRIDE_ASSERT                  (0x08000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_REFCLK_OVERRIDE_BACKPLANE_ERROR         (0x0c000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_OVERRIDE_DISABLE                   (0x00000080)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_DISABLE                  (0x00000040)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_MASK                (0x00000030)
 #define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SHIFT               (4)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRIS_SRNS_DISABLED  (0x00)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRIS_ENABLED        (0x10)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRNS_ENABLED        (0x20)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MASK                 (0x0f)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_2_5              (0x02)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_5_0              (0x03)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_8_0              (0x04)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_16_0             (0x05)
-#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_32_0             (0x06)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRIS_SRNS_DISABLED  (0x00000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRIS_ENABLED        (0x00000010)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRNS_ENABLED        (0x00000020)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MASK                 (0x0000000f)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_USE_BACKPLANE        (0x00000000)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_2_5              (0x00000002)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_5_0              (0x00000003)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_8_0              (0x00000004)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_16_0             (0x00000005)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_32_0             (0x00000006)
 #define MPI3_PCIEIOUNIT1_ASPM_SWITCH_MASK                                 (0x0c)
 #define MPI3_PCIEIOUNIT1_ASPM_SWITCH_SHIFT                                   (2)
 #define MPI3_PCIEIOUNIT1_ASPM_DIRECT_MASK                                 (0x03)
@@ -2169,10 +2267,7 @@ struct mpi3_device0_vd_format {
 #define MPI3_DEVICE0_VD_DEVICE_INFO_SATA                    (0x0002)
 #define MPI3_DEVICE0_VD_DEVICE_INFO_SAS                     (0x0001)
 #define MPI3_DEVICE0_VD_FLAGS_IO_THROTTLE_GROUP_QD_MASK     (0xf000)
-#define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_MASK            (0x0003)
-#define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_NONE            (0x0000)
-#define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_HOST            (0x0001)
-#define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_IOC             (0x0002)
+#define MPI3_DEVICE0_VD_FLAGS_IO_THROTTLE_GROUP_QD_SHIFT    (12)
 union mpi3_device0_dev_spec_format {
 	struct mpi3_device0_sas_sata_format        sas_sata_format;
 	struct mpi3_device0_pcie_format            pcie_format;
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
index c29b87d..64c5881 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_image.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2018-2021 Broadcom Inc. All rights reserved.
- *
+ *  Copyright 2018-2022 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_IMAGE_H
 #define MPI30_IMAGE_H     1
@@ -63,6 +62,9 @@ struct mpi3_component_image_header {
 #define MPI3_IMAGE_HEADER_SIGNATURE1_PBLP                     (0x504c4250)
 #define MPI3_IMAGE_HEADER_SIGNATURE1_MANIFEST                 (0x464e414d)
 #define MPI3_IMAGE_HEADER_SIGNATURE1_OEM                      (0x204d454f)
+#define MPI3_IMAGE_HEADER_SIGNATURE1_RMC                      (0x20434d52)
+#define MPI3_IMAGE_HEADER_SIGNATURE1_SMM                      (0x204d4d53)
+#define MPI3_IMAGE_HEADER_SIGNATURE1_PSW                      (0x20575350)
 #define MPI3_IMAGE_HEADER_SIGNATURE2_VALUE                    (0x50584546)
 #define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_MASK         (0x00000030)
 #define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_CDI          (0x00000000)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
index aac11c5..3c03610 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -1,13 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
- *
+ *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_INIT_H
 #define MPI30_INIT_H     1
 struct mpi3_scsi_io_cdb_eedp32 {
 	u8                 cdb[20];
-	__be32          primary_reference_tag;
+	__be32             primary_reference_tag;
 	__le16             primary_application_tag;
 	__le16             primary_application_tag_mask;
 	__le32             transfer_length;
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index 214e4c6..1c6c673 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
- *
+ *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_IOC_H
 #define MPI30_IOC_H     1
@@ -158,6 +157,7 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA                  (0x00000000)
 #define MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR              (0x00000002)
 #define MPI3_IOCFACTS_IO_THROTTLE_DATA_LENGTH_NOT_REQUIRED    (0x0000)
+#define MPI3_IOCFACTS_MAX_IO_THROTTLE_GROUP_NOT_REQUIRED      (0x0000)
 struct mpi3_mgmt_passthrough_request {
 	__le16                 host_tag;
 	u8                     ioc_use_only02;
@@ -637,6 +637,23 @@ struct mpi3_event_data_diag_buffer_status_change {
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RELEASED             (0x01)
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_PAUSED               (0x02)
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RESUMED              (0x03)
+#define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
+#define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
+#define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)
+#define MPI3_PEL_LOCALE_FLAGS_CONFIGURATION             (0x0040)
+#define MPI3_PEL_LOCALE_FLAGS_CONTROLER                 (0x0020)
+#define MPI3_PEL_LOCALE_FLAGS_SAS                       (0x0010)
+#define MPI3_PEL_LOCALE_FLAGS_EPACK                     (0x0008)
+#define MPI3_PEL_LOCALE_FLAGS_ENCLOSURE                 (0x0004)
+#define MPI3_PEL_LOCALE_FLAGS_PD                        (0x0002)
+#define MPI3_PEL_LOCALE_FLAGS_VD                        (0x0001)
+#define MPI3_PEL_CLASS_DEBUG                            (0x00)
+#define MPI3_PEL_CLASS_PROGRESS                         (0x01)
+#define MPI3_PEL_CLASS_INFORMATIONAL                    (0x02)
+#define MPI3_PEL_CLASS_WARNING                          (0x03)
+#define MPI3_PEL_CLASS_CRITICAL                         (0x04)
+#define MPI3_PEL_CLASS_FATAL                            (0x05)
+#define MPI3_PEL_CLASS_FAULT                            (0x06)
 #define MPI3_PEL_CLEARTYPE_CLEAR                        (0x00)
 #define MPI3_PEL_WAITTIME_INFINITE_WAIT                 (0x00)
 #define MPI3_PEL_ACTION_GET_SEQNUM                      (0x01)
@@ -924,6 +941,7 @@ struct mpi3_ci_download_reply {
 };
 
 #define MPI3_CI_DOWNLOAD_FLAGS_DOWNLOAD_IN_PROGRESS                  (0x80)
+#define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_FAILURE                    (0x40)
 #define MPI3_CI_DOWNLOAD_FLAGS_OFFLINE_ACTIVATION_REQUIRED           (0x20)
 #define MPI3_CI_DOWNLOAD_FLAGS_KEY_UPDATE_PENDING                    (0x10)
 #define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_MASK                (0x0e)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
index 901dbd7..b7a5df0 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
  *
  */
 #ifndef MPI30_PCI_H
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
index 298d895..e587f77 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
- *
+ *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_SAS_H
 #define MPI30_SAS_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index ba05ea5..9b76b96 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
- *
+ *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_TRANSPORT_H
 #define MPI30_TRANSPORT_H     1
@@ -19,8 +18,8 @@ union mpi3_version_union {
 
 #define MPI3_VERSION_MAJOR                                              (3)
 #define MPI3_VERSION_MINOR                                              (0)
-#define MPI3_VERSION_UNIT                                               (23)
-#define MPI3_VERSION_DEV                                                (1)
+#define MPI3_VERSION_UNIT                                               (26)
+#define MPI3_VERSION_DEV                                                (0)
 #define MPI3_DEVHANDLE_INVALID                                          (0xffff)
 struct mpi3_sysif_oper_queue_indexes {
 	__le16         producer_index;
@@ -212,6 +211,7 @@ struct mpi3_default_reply_descriptor {
 #define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_SUCCESS                     (0x1000)
 #define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_TARGET_COMMAND_BUFFER       (0x2000)
 #define MPI3_REPLY_DESCRIPT_FLAGS_TYPE_STATUS                      (0x3000)
+#define MPI3_REPLY_DESCRIPT_REQUEST_QUEUE_ID_INVALID               (0xffff)
 struct mpi3_address_reply_descriptor {
 	__le64             reply_frame_address;
 	__le16             request_queue_ci;
-- 
2.27.0


--000000000000c7c36105e87b1b48
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAKPGRYIydb9yjBmQIr3
VO7kAcEsD5w9w+R9w1iDUVyFMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDkxMjEzNDUyOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDA3axUHPU9x+gMhpMYb/wPfKH4X02Eu9OTWwi3
meS80CGDa/mezKgjkVdCI6aLuCeO5NkbBZEdjjhA0HpCa9UuY7wo8UzHLr1+vGM05hzj+ak7CFPD
SA5OnMo7cIs4SocNJEQZxE1UYVGjLQh5CUpYJYaFwMEXmklqHft4cLnwXagVs3fz80T55okyxK4z
0hr53qcoQoxThmgvdh2JxSoddk4dPOZAb0KWK82OgdhXua1yflwZurPKFTCBV6XDnlgL+rKKMk1L
rVofsQglYh6u42VVJRwALpK2YH82z7V2vS9FijiII1JeuW0ijbp7ooIJVKlA19lRjU+IVsi/sadj
--000000000000c7c36105e87b1b48--
