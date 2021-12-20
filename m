Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49BDC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhLTOEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbhLTOEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:11 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99381C061574
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:11 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 205so4631382pfu.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=k4mrgciCtR41sqxBxehDYp5rfizWXvoMs9R/4PAZxKw=;
        b=Mr6GrFOuhwWEOI7wnm8UVRvhUhCmWoctU4hTvFkM9A7UiznTKBNo14KOxlsq+HdzTC
         75tn1KVi+ep9qYvfm6qWfng7ATiqqvv8uJzcR8dBbFq4FhUZQPedC1K2dcgrzkcOajGh
         3GaOLi4ZYN7vhOVVTryWQBrTwHzB5X7pwLhvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=k4mrgciCtR41sqxBxehDYp5rfizWXvoMs9R/4PAZxKw=;
        b=CJVTPWNcyG7lzSULHwsCZua/ioJZXKxJ9lW7fnkZWENbYZtaeDJcSBhqryAZvIdsPq
         yD/IlaZ7km2pz5B3icZ85L/JR8jBhRyClJQsMIrRo7zy7EA6zRUXcmOQfJUEWxfxWhEj
         V7DgaOlE8T/wdYiEAbGKp/5Qe/nINRMos1wS6Wtk+PjqogFa4720cnqTyQ9TMzhTIUmO
         0oDUtW8bGU41J5Y7ityQbPq4Y6ZdgsCU6772sjJm/nHznMEaA7AnbpCfaPWHc01xVdnr
         yhn1K2W1lJEvyvDkETLNh2gzlvn8TosLQ35hp3kKQNr5a1iByzLV8x+uL17ElYvlYmdK
         un4g==
X-Gm-Message-State: AOAM530FlIIwASTWZUy++qjSj8A9SNyuYnGvqi2UVDl7CuLmSMH4plRe
        gy1Oax6FydcwAXVgl/6zXVCjQJvf23QwH2N1fAaPgUHs1n4OMkBOoxIjSOmi40wH4mghWJ+p03I
        Cn5BwOjD0vUN0n5jIW8X24eoXXxt9D1uim/wVut2+mBo4Ch0cARrfluamS3fPYyqJJeG30DyDlN
        hRFgk90YcN
X-Google-Smtp-Source: ABdhPJyuBubKO/rziOfAJA/u5fXGbka9zK7Qm+VylgV7CHqB07cbbkIb07dlafXiTShBz8D640PMzw==
X-Received: by 2002:a63:69c7:: with SMTP id e190mr15185449pgc.440.1640009050227;
        Mon, 20 Dec 2021 06:04:10 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:09 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 04/25] mpi3mr: Update MPI3 headers - part1
Date:   Mon, 20 Dec 2021 19:41:38 +0530
Message-Id: <20211220141159.16117-5-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000eb36e305d3945cd5"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000eb36e305d3945cd5
Content-Transfer-Encoding: 8bit

Update MPI3 headers.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 603 ++++++++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_os.c      |   2 +-
 2 files changed, 499 insertions(+), 106 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index d43bbec..5e1f6ce 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -8,7 +8,7 @@
 #define MPI3_CONFIG_PAGETYPE_IO_UNIT                    (0x00)
 #define MPI3_CONFIG_PAGETYPE_MANUFACTURING              (0x01)
 #define MPI3_CONFIG_PAGETYPE_IOC                        (0x02)
-#define MPI3_CONFIG_PAGETYPE_UEFI_BSD                   (0x03)
+#define MPI3_CONFIG_PAGETYPE_DRIVER                     (0x03)
 #define MPI3_CONFIG_PAGETYPE_SECURITY                   (0x04)
 #define MPI3_CONFIG_PAGETYPE_ENCLOSURE                  (0x11)
 #define MPI3_CONFIG_PAGETYPE_DEVICE                     (0x12)
@@ -181,8 +181,17 @@ struct mpi3_config_page_header {
 #define MPI3_SAS_HWRATE_MIN_RATE_6_0                    (0x0a)
 #define MPI3_SAS_HWRATE_MIN_RATE_12_0                   (0x0b)
 #define MPI3_SAS_HWRATE_MIN_RATE_22_5                   (0x0c)
-#define MPI3_SLOT_INVALID                           (0xffff)
-#define MPI3_SLOT_INDEX_INVALID                     (0xffff)
+#define MPI3_SLOT_INVALID                               (0xffff)
+#define MPI3_SLOT_INDEX_INVALID                         (0xffff)
+#define MPI3_LINK_CHANGE_COUNT_INVALID                   (0xffff)
+#define MPI3_RATE_CHANGE_COUNT_INVALID                   (0xffff)
+#define MPI3_TEMP_SENSOR_LOCATION_INTERNAL              (0x0)
+#define MPI3_TEMP_SENSOR_LOCATION_INLET                 (0x1)
+#define MPI3_TEMP_SENSOR_LOCATION_OUTLET                (0x2)
+#define MPI3_TEMP_SENSOR_LOCATION_DRAM                  (0x3)
+#define MPI3_MFGPAGE_VENDORID_BROADCOM                  (0x1000)
+#define MPI3_MFGPAGE_DEVID_SAS4116                      (0x00a5)
+#define MPI3_MFGPAGE_DEVID_SAS4016                      (0x00a7)
 struct mpi3_man_page0 {
 	struct mpi3_config_page_header         header;
 	u8                                 chip_revision[8];
@@ -195,7 +204,7 @@ struct mpi3_man_page0 {
 	__le32                             reserved98;
 	u8                                 oem;
 	u8                                 sub_oem;
-	__le16                             reserved9e;
+	__le16                             flags;
 	u8                                 board_mfg_day;
 	u8                                 board_mfg_month;
 	__le16                             board_mfg_year;
@@ -208,6 +217,8 @@ struct mpi3_man_page0 {
 };
 
 #define MPI3_MAN0_PAGEVERSION       (0x00)
+#define MPI3_MAN0_FLAGS_SWITCH_PRESENT                       (0x0002)
+#define MPI3_MAN0_FLAGS_EXPANDER_PRESENT                     (0x0001)
 #define MPI3_MAN1_VPD_SIZE                                   (512)
 struct mpi3_man_page1 {
 	struct mpi3_config_page_header         header;
@@ -236,7 +247,7 @@ struct mpi3_man_page5 {
 #define MPI3_MAN5_PAGEVERSION                                (0x00)
 struct mpi3_man6_gpio_entry {
 	u8         function_code;
-	u8         reserved01;
+	u8         function_flags;
 	__le16     flags;
 	u8         param1;
 	u8         param2;
@@ -253,7 +264,6 @@ struct mpi3_man6_gpio_entry {
 #define MPI3_MAN6_GPIO_FUNCTION_PORT_STATUS_YELLOW                            (0x06)
 #define MPI3_MAN6_GPIO_FUNCTION_CABLE_MANAGEMENT                              (0x07)
 #define MPI3_MAN6_GPIO_FUNCTION_BKPLANE_MGMT_TYPE                             (0x08)
-#define MPI3_MAN6_GPIO_FUNCTION_ISTWI_MUX_RESET                               (0x09)
 #define MPI3_MAN6_GPIO_FUNCTION_ISTWI_RESET                                   (0x0a)
 #define MPI3_MAN6_GPIO_FUNCTION_BACKEND_PCIE_RESET                            (0x0b)
 #define MPI3_MAN6_GPIO_FUNCTION_GLOBAL_FAULT                                  (0x0c)
@@ -263,6 +273,10 @@ struct mpi3_man6_gpio_entry {
 #define MPI3_MAN6_GPIO_FUNCTION_CTRL_TYPE                                     (0x10)
 #define MPI3_MAN6_GPIO_FUNCTION_LICENSE                                       (0x11)
 #define MPI3_MAN6_GPIO_FUNCTION_REFCLK_CONTROL                                (0x12)
+#define MPI3_MAN6_GPIO_FUNCTION_BACKEND_PCIE_RESET_CLAMP                      (0x13)
+#define MPI3_MAN6_GPIO_ISTWI_RESET_FUNCTIONFLAGS_DEVSELECT_MASK               (0x01)
+#define MPI3_MAN6_GPIO_ISTWI_RESET_FUNCTIONFLAGS_DEVSELECT_ISTWI              (0x00)
+#define MPI3_MAN6_GPIO_ISTWI_RESET_FUNCTIONFLAGS_DEVSELECT_RECEPTACLEID       (0x01)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_MASK                        (0xf0)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_GENERIC                     (0x00)
 #define MPI3_MAN6_GPIO_EXTINT_PARAM1_FLAGS_SOURCE_CABLE_MGMT                  (0x10)
@@ -275,8 +289,6 @@ struct mpi3_man6_gpio_entry {
 #define MPI3_MAN6_GPIO_CABLE_MGMT_PARAM1_INTERFACE_MODULE_PRESENT             (0x00)
 #define MPI3_MAN6_GPIO_CABLE_MGMT_PARAM1_INTERFACE_ACTIVE_CABLE_ENABLE        (0x01)
 #define MPI3_MAN6_GPIO_CABLE_MGMT_PARAM1_INTERFACE_CABLE_MGMT_ENABLE          (0x02)
-#define MPI3_MAN6_GPIO_ISTWI_MUX_RESET_PARAM2_SPEC_MUX                        (0x00)
-#define MPI3_MAN6_GPIO_ISTWI_MUX_RESET_PARAM2_ALL_MUXES                       (0x01)
 #define MPI3_MAN6_GPIO_LICENSE_PARAM1_TYPE_IBUTTON                            (0x00)
 #define MPI3_MAN6_GPIO_FLAGS_SLEW_RATE_MASK                                   (0x0100)
 #define MPI3_MAN6_GPIO_FLAGS_SLEW_RATE_FAST_EDGE                              (0x0100)
@@ -353,6 +365,7 @@ struct mpi3_man8_phy_info {
 	__le32                             reserved0c;
 };
 
+#define MPI3_MAN8_PHY_INFO_RECEPTACLE_ID_HOST_PHY          (0xff)
 #ifndef MPI3_MAN8_PHY_INFO_MAX
 #define MPI3_MAN8_PHY_INFO_MAX                      (1)
 #endif
@@ -373,20 +386,22 @@ struct mpi3_man9_rsrc_entry {
 };
 
 enum mpi3_man9_resources {
-	MPI3_MAN9_RSRC_OUTSTANDING_REQS = 0,
-	MPI3_MAN9_RSRC_TARGET_CMDS      = 1,
-	MPI3_MAN9_RSRC_SAS_TARGETS      = 2,
-	MPI3_MAN9_RSRC_PCIE_TARGETS     = 3,
-	MPI3_MAN9_RSRC_INITIATORS       = 4,
-	MPI3_MAN9_RSRC_VDS              = 5,
-	MPI3_MAN9_RSRC_ENCLOSURES       = 6,
-	MPI3_MAN9_RSRC_ENCLOSURE_PHYS   = 7,
-	MPI3_MAN9_RSRC_EXPANDERS        = 8,
-	MPI3_MAN9_RSRC_PCIE_SWITCHES    = 9,
-	MPI3_MAN9_RSRC_PDS              = 10,
-	MPI3_MAN9_RSRC_HOST_PDS         = 11,
-	MPI3_MAN9_RSRC_ADV_HOST_PDS     = 12,
-	MPI3_MAN9_RSRC_RAID_PDS         = 13,
+	MPI3_MAN9_RSRC_OUTSTANDING_REQS    = 0,
+	MPI3_MAN9_RSRC_TARGET_CMDS         = 1,
+	MPI3_MAN9_RSRC_RESERVED02          = 2,
+	MPI3_MAN9_RSRC_NVME                = 3,
+	MPI3_MAN9_RSRC_INITIATORS          = 4,
+	MPI3_MAN9_RSRC_VDS                 = 5,
+	MPI3_MAN9_RSRC_ENCLOSURES          = 6,
+	MPI3_MAN9_RSRC_ENCLOSURE_PHYS      = 7,
+	MPI3_MAN9_RSRC_EXPANDERS           = 8,
+	MPI3_MAN9_RSRC_PCIE_SWITCHES       = 9,
+	MPI3_MAN9_RSRC_RESERVED10          = 10,
+	MPI3_MAN9_RSRC_HOST_PD_DRIVES      = 11,
+	MPI3_MAN9_RSRC_ADV_HOST_PD_DRIVES  = 12,
+	MPI3_MAN9_RSRC_RAID_PD_DRIVES      = 13,
+	MPI3_MAN9_RSRC_DRV_DIAG_BUF        = 14,
+	MPI3_MAN9_RSRC_NAMESPACE_COUNT     = 15,
 	MPI3_MAN9_RSRC_NUM_RESOURCES
 };
 
@@ -402,6 +417,7 @@ enum mpi3_man9_resources {
 #define MPI3_MAN9_MIN_ENCLOSURES            (0)
 #define MPI3_MAN9_MAX_ENCLOSURES            (65535)
 #define MPI3_MAN9_MIN_ENCLOSURE_PHYS        (0)
+#define MPI3_MAN9_MIN_NAMESPACE_COUNT       (1)
 #define MPI3_MAN9_MIN_EXPANDERS             (0)
 #define MPI3_MAN9_MAX_EXPANDERS             (65535)
 #define MPI3_MAN9_MIN_PCIE_SWITCHES         (0)
@@ -422,9 +438,14 @@ struct mpi3_man_page9 {
 struct mpi3_man10_istwi_ctrlr_entry {
 	__le16     slave_address;
 	__le16     flags;
-	__le32     reserved04;
+	u8         scl_low_override;
+	u8         scl_high_override;
+	__le16     reserved06;
 };
 
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_MASK         (0x000c)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_100K         (0x0000)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_400K         (0x0004)
 #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_SLAVE_ENABLED          (0x0002)
 #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_MASTER_ENABLED         (0x0001)
 #ifndef MPI3_MAN10_ISTWI_CTRLR_MAX
@@ -451,10 +472,13 @@ struct mpi3_man11_temp_sensor_device_format {
 	u8         temp_channel[4];
 };
 
-#define MPI3_MAN11_TEMP_SENSOR_TYPE_MAX6654         (0x00)
-#define MPI3_MAN11_TEMP_SENSOR_TYPE_EMC1442         (0x01)
-#define MPI3_MAN11_TEMP_SENSOR_TYPE_ADT7476         (0x02)
-#define MPI3_MAN11_TEMP_SENSOR_CHANNEL_ENABLED      (0x01)
+#define MPI3_MAN11_TEMP_SENSOR_TYPE_MAX6654                (0x00)
+#define MPI3_MAN11_TEMP_SENSOR_TYPE_EMC1442                (0x01)
+#define MPI3_MAN11_TEMP_SENSOR_TYPE_ADT7476                (0x02)
+#define MPI3_MAN11_TEMP_SENSOR_TYPE_SE97B                  (0x03)
+#define MPI3_MAN11_TEMP_SENSOR_CHANNEL_LOCATION_MASK       (0xe0)
+#define MPI3_MAN11_TEMP_SENSOR_CHANNEL_LOCATION_SHIFT      (5)
+#define MPI3_MAN11_TEMP_SENSOR_CHANNEL_ENABLED             (0x01)
 struct mpi3_man11_seeprom_device_format {
 	u8         size;
 	u8         page_write_size;
@@ -495,31 +519,40 @@ struct mpi3_man11_bkplane_spec_ubm_format {
 #define MPI3_MAN11_BKPLANE_UBM_FLAGS_MAX_FRU_SHIFT                 (4)
 #define MPI3_MAN11_BKPLANE_UBM_FLAGS_POLL_INTERVAL_MASK            (0x000f)
 #define MPI3_MAN11_BKPLANE_UBM_FLAGS_POLL_INTERVAL_SHIFT           (0)
-struct mpi3_man11_bkplane_spec_vpp_format {
+struct mpi3_man11_bkplane_spec_non_ubm_format {
 	__le16     flags;
-	__le16     reserved02;
+	u8         reserved02;
+	u8         type;
 };
 
-#define MPI3_MAN11_BKPLANE_VPP_FLAGS_REFCLK_POLICY_ALWAYS_ENABLED  (0x0040)
-#define MPI3_MAN11_BKPLANE_VPP_FLAGS_PRESENCE_DETECT_MASK          (0x0030)
-#define MPI3_MAN11_BKPLANE_VPP_FLAGS_PRESENCE_DETECT_GPIO          (0x0000)
-#define MPI3_MAN11_BKPLANE_VPP_FLAGS_PRESENCE_DETECT_REG           (0x0010)
-#define MPI3_MAN11_BKPLANE_VPP_FLAGS_POLL_INTERVAL_MASK            (0x000f)
-#define MPI3_MAN11_BKPLANE_VPP_FLAGS_POLL_INTERVAL_SHIFT           (0)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_GROUP_MASK                    (0xf000)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_GROUP_SHIFT                   (12)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_REFCLK_POLICY_ALWAYS_ENABLED  (0x0200)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_PRESENCE_DETECT_MASK          (0x0030)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_PRESENCE_DETECT_GPIO          (0x0000)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_PRESENCE_DETECT_REG           (0x0010)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_POLL_INTERVAL_MASK            (0x000f)
+#define MPI3_MAN11_BKPLANE_NON_UBM_FLAGS_POLL_INTERVAL_SHIFT           (0)
+#define MPI3_MAN11_BKPLANE_NON_UBM_TYPE_VPP                            (0x00)
 union mpi3_man11_bkplane_spec_format {
-	struct mpi3_man11_bkplane_spec_ubm_format     ubm;
-	struct mpi3_man11_bkplane_spec_vpp_format     vpp;
+	struct mpi3_man11_bkplane_spec_ubm_format         ubm;
+	struct mpi3_man11_bkplane_spec_non_ubm_format     non_ubm;
 };
 
 struct mpi3_man11_bkplane_mgmt_device_format {
 	u8                                        type;
 	u8                                        receptacle_id;
-	__le16                                    reserved02;
+	u8                                        reset_info;
+	u8                                        reserved03;
 	union mpi3_man11_bkplane_spec_format         backplane_mgmt_specific;
 };
 
 #define MPI3_MAN11_BKPLANE_MGMT_TYPE_UBM            (0x00)
-#define MPI3_MAN11_BKPLANE_MGMT_TYPE_VPP            (0x01)
+#define MPI3_MAN11_BKPLANE_MGMT_TYPE_NON_UBM        (0x01)
+#define MPI3_MAN11_BACKPLANE_RESETINFO_ASSERT_TIME_MASK       (0xf0)
+#define MPI3_MAN11_BACKPLANE_RESETINFO_ASSERT_TIME_SHIFT      (4)
+#define MPI3_MAN11_BACKPLANE_RESETINFO_READY_TIME_MASK        (0x0f)
+#define MPI3_MAN11_BACKPLANE_RESETINFO_READY_TIME_SHIFT       (0)
 struct mpi3_man11_gas_gauge_device_format {
 	u8         type;
 	u8         reserved01[3];
@@ -527,6 +560,11 @@ struct mpi3_man11_gas_gauge_device_format {
 };
 
 #define MPI3_MAN11_GAS_GAUGE_TYPE_STANDARD          (0x00)
+struct mpi3_man11_mgmt_ctrlr_device_format {
+	__le32     reserved00;
+	__le32     reserved04;
+};
+
 union mpi3_man11_device_specific_format {
 	struct mpi3_man11_mux_device_format            mux;
 	struct mpi3_man11_temp_sensor_device_format    temp_sensor;
@@ -535,6 +573,7 @@ union mpi3_man11_device_specific_format {
 	struct mpi3_man11_cable_mgmt_device_format     cable_mgmt;
 	struct mpi3_man11_bkplane_mgmt_device_format   bkplane_mgmt;
 	struct mpi3_man11_gas_gauge_device_format      gas_gauge;
+	struct mpi3_man11_mgmt_ctrlr_device_format     mgmt_controller;
 	__le32                                     words[2];
 };
 
@@ -556,10 +595,8 @@ struct mpi3_man11_istwi_device_format {
 #define MPI3_MAN11_ISTWI_DEVTYPE_CABLE_MGMT           (0x04)
 #define MPI3_MAN11_ISTWI_DEVTYPE_BACKPLANE_MGMT       (0x05)
 #define MPI3_MAN11_ISTWI_DEVTYPE_GAS_GAUGE            (0x06)
+#define MPI3_MAN11_ISTWI_DEVTYPE_MGMT_CONTROLLER      (0x07)
 #define MPI3_MAN11_ISTWI_FLAGS_MUX_PRESENT            (0x01)
-#define MPI3_MAN11_ISTWI_FLAGS_BUS_SPEED_MASK         (0x06)
-#define MPI3_MAN11_ISTWI_FLAGS_BUS_SPEED_100KHZ       (0x00)
-#define MPI3_MAN11_ISTWI_FLAGS_BUS_SPEED_400KHZ       (0x02)
 #ifndef MPI3_MAN11_ISTWI_DEVICE_MAX
 #define MPI3_MAN11_ISTWI_DEVICE_MAX             (1)
 #endif
@@ -692,8 +729,8 @@ struct mpi3_man_page14 {
 #define MPI3_MAN14_FLAGS_AUTH_SESSION_REQ                            (0x01)
 #define MPI3_MAN14_FLAGS_AUTH_API_MASK                               (0x0e)
 #define MPI3_MAN14_FLAGS_AUTH_API_NONE                               (0x00)
-#define MPI3_MAN14_FLAGS_AUTH_API_CEREBUS                            (0x02)
-#define MPI3_MAN14_FLAGS_AUTH_API_DMTF_PMCI                          (0x04)
+#define MPI3_MAN14_FLAGS_AUTH_API_CERBERUS                           (0x02)
+#define MPI3_MAN14_FLAGS_AUTH_API_SPDM                               (0x04)
 #ifndef MPI3_MAN15_VERSION_RECORD_MAX
 #define MPI3_MAN15_VERSION_RECORD_MAX      1
 #endif
@@ -808,7 +845,7 @@ struct mpi3_io_unit_page1 {
 	struct mpi3_config_page_header         header;
 	__le32                             flags;
 	u8                                 dmd_io_delay;
-	u8                                 dmd_report_pc_ie;
+	u8                                 dmd_report_pcie;
 	u8                                 dmd_report_sata;
 	u8                                 dmd_report_sas;
 };
@@ -844,26 +881,30 @@ struct mpi3_io_unit_page2 {
 #define MPI3_IOUNIT2_GPIO_SETTING_ON            (0x0001)
 struct mpi3_io_unit3_sensor {
 	__le16             flags;
-	__le16             reserved02;
-	__le16             threshold[4];
+	u8                 threshold_margin;
+	u8                 reserved03;
+	__le16             threshold[3];
+	__le16             reserved0a;
 	__le32             reserved0c;
 	__le32             reserved10;
 	__le32             reserved14;
 };
 
-#define MPI3_IOUNIT3_SENSOR_FLAGS_T3_ENABLE         (0x0008)
-#define MPI3_IOUNIT3_SENSOR_FLAGS_T2_ENABLE         (0x0004)
-#define MPI3_IOUNIT3_SENSOR_FLAGS_T1_ENABLE         (0x0002)
-#define MPI3_IOUNIT3_SENSOR_FLAGS_T0_ENABLE         (0x0001)
+#define MPI3_IOUNIT3_SENSOR_FLAGS_FATAL_EVENT_ENABLED           (0x0010)
+#define MPI3_IOUNIT3_SENSOR_FLAGS_FATAL_ACTION_ENABLED          (0x0008)
+#define MPI3_IOUNIT3_SENSOR_FLAGS_CRITICAL_EVENT_ENABLED        (0x0004)
+#define MPI3_IOUNIT3_SENSOR_FLAGS_CRITICAL_ACTION_ENABLED       (0x0002)
+#define MPI3_IOUNIT3_SENSOR_FLAGS_WARNING_EVENT_ENABLED         (0x0001)
 #ifndef MPI3_IO_UNIT3_SENSOR_MAX
-#define MPI3_IO_UNIT3_SENSOR_MAX        (1)
+#define MPI3_IO_UNIT3_SENSOR_MAX                                (1)
 #endif
 struct mpi3_io_unit_page3 {
 	struct mpi3_config_page_header         header;
 	__le32                             reserved08;
 	u8                                 num_sensors;
-	u8                                 polling_interval;
-	__le16                             reserved0e;
+	u8                                 nominal_poll_interval;
+	u8                                 warning_poll_interval;
+	u8                                 reserved0f;
 	struct mpi3_io_unit3_sensor            sensor[MPI3_IO_UNIT3_SENSOR_MAX];
 };
 
@@ -873,13 +914,19 @@ struct mpi3_io_unit4_sensor {
 	__le16             reserved02;
 	u8                 flags;
 	u8                 reserved05[3];
-	__le32             reserved08;
+	__le16             istwi_index;
+	u8                 channel;
+	u8                 reserved0b;
 	__le32             reserved0c;
 };
 
+#define MPI3_IOUNIT4_SENSOR_FLAGS_LOC_MASK          (0xe0)
+#define MPI3_IOUNIT4_SENSOR_FLAGS_LOC_SHIFT         (5)
 #define MPI3_IOUNIT4_SENSOR_FLAGS_TEMP_VALID        (0x01)
+#define MPI3_IOUNIT4_SENSOR_ISTWI_INDEX_INTERNAL    (0xffff)
+#define MPI3_IOUNIT4_SENSOR_CHANNEL_RESERVED        (0xff)
 #ifndef MPI3_IO_UNIT4_SENSOR_MAX
-#define MPI3_IO_UNIT4_SENSOR_MAX        (1)
+#define MPI3_IO_UNIT4_SENSOR_MAX                                (1)
 #endif
 struct mpi3_io_unit_page4 {
 	struct mpi3_config_page_header         header;
@@ -906,8 +953,9 @@ struct mpi3_io_unit_page5 {
 	struct mpi3_io_unit5_spinup_group      spinup_group_parameters[4];
 	__le32                             reserved18;
 	__le32                             reserved1c;
-	__le32                             reserved20;
-	u8                                 reserved24;
+	__le16                             device_shutdown;
+	__le16                             reserved22;
+	u8                                 pcie_device_wait_time;
 	u8                                 sata_device_wait_time;
 	u8                                 spinup_encl_drive_count;
 	u8                                 spinup_encl_delay;
@@ -919,6 +967,22 @@ struct mpi3_io_unit_page5 {
 };
 
 #define MPI3_IOUNIT5_PAGEVERSION                           (0x00)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_NO_ACTION             (0x00)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_DIRECT_ATTACHED       (0x01)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_EXPANDER_ATTACHED     (0x02)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SWITCH_ATTACHED       (0x02)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_DIRECT_AND_EXPANDER   (0x03)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_DIRECT_AND_SWITCH     (0x03)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_HDD_MASK         (0x0300)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_HDD_SHIFT        (8)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAS_HDD_MASK          (0x00c0)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAS_HDD_SHIFT         (6)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_NVME_SSD_MASK         (0x0030)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_NVME_SSD_SHIFT        (4)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_SSD_MASK         (0x000c)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SATA_SSD_SHIFT        (2)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAS_SSD_MASK          (0x0003)
+#define MPI3_IOUNIT5_DEVICE_SHUTDOWN_SAA_SSD_SHIFT         (0)
 #define MPI3_IOUNIT5_FLAGS_POWER_CAPABLE_SPINUP            (0x02)
 #define MPI3_IOUNIT5_FLAGS_AUTO_PORT_ENABLE                (0x01)
 #define MPI3_IOUNIT5_PHY_SPINUP_GROUP_MASK                 (0x03)
@@ -1012,7 +1076,52 @@ struct mpi3_ioc_page2 {
 };
 
 #define MPI3_IOC2_PAGEVERSION               (0x00)
-struct mpi3_uefibsd_page0 {
+#define MPI3_DRIVER_FLAGS_ADMINRAIDPD_BLOCKED               (0x0010)
+#define MPI3_DRIVER_FLAGS_OOBRAIDPD_BLOCKED                 (0x0008)
+#define MPI3_DRIVER_FLAGS_OOBRAIDVD_BLOCKED                 (0x0004)
+#define MPI3_DRIVER_FLAGS_OOBADVHOSTPD_BLOCKED              (0x0002)
+#define MPI3_DRIVER_FLAGS_OOBHOSTPD_BLOCKED                 (0x0001)
+struct mpi3_allowed_cmd_scsi {
+	__le16                             service_action;
+	u8                                 operation_code;
+	u8                                 command_flags;
+};
+
+struct mpi3_allowed_cmd_ata {
+	u8                                 subcommand;
+	u8                                 reserved01;
+	u8                                 command;
+	u8                                 command_flags;
+};
+
+struct mpi3_allowed_cmd_nvme {
+	u8                                 reserved00;
+	u8                                 nvme_cmd_flags;
+	u8                                 op_code;
+	u8                                 command_flags;
+};
+
+#define MPI3_DRIVER_ALLOWEDCMD_NVMECMDFLAGS_SUBQ_TYPE_MASK     (0x80)
+#define MPI3_DRIVER_ALLOWEDCMD_NVMECMDFLAGS_SUBQ_TYPE_IO       (0x00)
+#define MPI3_DRIVER_ALLOWEDCMD_NVMECMDFLAGS_SUBQ_TYPE_ADMIN    (0x80)
+#define MPI3_DRIVER_ALLOWEDCMD_NVMECMDFLAGS_CMDSET_MASK        (0x3f)
+#define MPI3_DRIVER_ALLOWEDCMD_NVMECMDFLAGS_CMDSET_NVM         (0x00)
+union mpi3_allowed_cmd {
+	struct mpi3_allowed_cmd_scsi           scsi;
+	struct mpi3_allowed_cmd_ata            ata;
+	struct mpi3_allowed_cmd_nvme           nvme;
+};
+
+#define MPI3_DRIVER_ALLOWEDCMD_CMDFLAGS_ADMINRAIDPD_BLOCKED    (0x20)
+#define MPI3_DRIVER_ALLOWEDCMD_CMDFLAGS_OOBRAIDPD_BLOCKED      (0x10)
+#define MPI3_DRIVER_ALLOWEDCMD_CMDFLAGS_OOBRAIDVD_BLOCKED      (0x08)
+#define MPI3_DRIVER_ALLOWEDCMD_CMDFLAGS_OOBADVHOSTPD_BLOCKED   (0x04)
+#define MPI3_DRIVER_ALLOWEDCMD_CMDFLAGS_OOBHOSTPD_BLOCKED      (0x02)
+#define MPI3_DRIVER_ALLOWEDCMD_CMDFLAGS_CHECKSUBCMD_ENABLED    (0x01)
+#ifndef MPI3_ALLOWED_CMDS_MAX
+#define MPI3_ALLOWED_CMDS_MAX           (1)
+#endif
+struct mpi3_driver_page0 {
 	struct mpi3_config_page_header         header;
 	__le32                             bsd_options;
 	u8                                 ssu_timeout;
@@ -1026,13 +1135,122 @@ struct mpi3_uefibsd_page0 {
 	__le32                             reserved18;
 };
 
-#define MPI3_UEFIBSD_PAGEVERSION               (0x00)
-#define MPI3_UEFIBSD_BSDOPTS_REGISTRATION_MASK              (0x00000003)
-#define MPI3_UEFIBSD_BSDOPTS_REGISTRATION_IOC_AND_DEVS      (0x00000000)
-#define MPI3_UEFIBSD_BSDOPTS_REGISTRATION_IOC_ONLY          (0x00000001)
-#define MPI3_UEFIBSD_BSDOPTS_REGISTRATION_NONE              (0x00000002)
-#define MPI3_UEFIBSD_BSDOPTS_DIS_HII_CONFIG_UTIL            (0x00000004)
-#define MPI3_UEFIBSD_BSDOPTS_EN_ADV_ADAPTER_CONFIG          (0x00000008)
+#define MPI3_DRIVER0_PAGEVERSION               (0x00)
+#define MPI3_DRIVER0_BSDOPTS_REGISTRATION_MASK              (0x00000003)
+#define MPI3_DRIVER0_BSDOPTS_REGISTRATION_IOC_AND_DEVS      (0x00000000)
+#define MPI3_DRIVER0_BSDOPTS_REGISTRATION_IOC_ONLY          (0x00000001)
+#define MPI3_DRIVER0_BSDOPTS_DIS_HII_CONFIG_UTIL            (0x00000004)
+#define MPI3_DRIVER0_BSDOPTS_EN_ADV_ADAPTER_CONFIG          (0x00000008)
+struct mpi3_driver_page1 {
+	struct mpi3_config_page_header         header;
+	__le32                             flags;
+	__le32                             reserved0c;
+	__le16                             host_diag_trace_max_size;
+	__le16                             host_diag_trace_min_size;
+	__le16                             host_diag_trace_decrement_size;
+	__le16                             reserved16;
+	__le16                             host_diag_fw_max_size;
+	__le16                             host_diag_fw_min_size;
+	__le16                             host_diag_fw_decrement_size;
+	__le16                             reserved1e;
+	__le16                             host_diag_driver_max_size;
+	__le16                             host_diag_driver_min_size;
+	__le16                             host_diag_driver_decrement_size;
+	__le16                             reserved26;
+};
+
+#define MPI3_DRIVER1_PAGEVERSION               (0x00)
+#ifndef MPI3_DRIVER2_TRIGGER_MAX
+#define MPI3_DRIVER2_TRIGGER_MAX           (1)
+#endif
+struct mpi3_driver2_trigger_event {
+	u8                                 type;
+	u8                                 flags;
+	u8                                 reserved02;
+	u8                                 event;
+	__le32                             reserved04[3];
+};
+
+struct mpi3_driver2_trigger_scsi_sense {
+	u8                                 type;
+	u8                                 flags;
+	__le16                             reserved02;
+	u8                                 ascq;
+	u8                                 asc;
+	u8                                 sense_key;
+	u8                                 reserved07;
+	__le32                             reserved08[2];
+};
+
+#define MPI3_DRIVER2_TRIGGER_SCSI_SENSE_ASCQ_MATCH_ALL                        (0xff)
+#define MPI3_DRIVER2_TRIGGER_SCSI_SENSE_ASC_MATCH_ALL                         (0xff)
+#define MPI3_DRIVER2_TRIGGER_SCSI_SENSE_SENSE_KEY_MATCH_ALL                   (0xff)
+struct mpi3_driver2_trigger_reply {
+	u8                                 type;
+	u8                                 flags;
+	__le16                             ioc_status;
+	__le32                             ioc_log_info;
+	__le32                             ioc_log_info_mask;
+	__le32                             reserved0c;
+};
+
+#define MPI3_DRIVER2_TRIGGER_REPLY_IOCSTATUS_MATCH_ALL                        (0xffff)
+union mpi3_driver2_trigger_element {
+	struct mpi3_driver2_trigger_event             event;
+	struct mpi3_driver2_trigger_scsi_sense        scsi_sense;
+	struct mpi3_driver2_trigger_reply             reply;
+};
+
+#define MPI3_DRIVER2_TRIGGER_TYPE_EVENT                                       (0x00)
+#define MPI3_DRIVER2_TRIGGER_TYPE_SCSI_SENSE                                  (0x01)
+#define MPI3_DRIVER2_TRIGGER_TYPE_REPLY                                       (0x02)
+#define MPI3_DRIVER2_TRIGGER_FLAGS_DIAG_TRACE_RELEASE                         (0x02)
+#define MPI3_DRIVER2_TRIGGER_FLAGS_DIAG_FW_RELEASE                            (0x01)
+struct mpi3_driver_page2 {
+	struct mpi3_config_page_header         header;
+	__le64                             master_trigger;
+	__le32                             reserved10[3];
+	u8                                 num_triggers;
+	u8                                 reserved1d[3];
+	union mpi3_driver2_trigger_element    trigger[MPI3_DRIVER2_TRIGGER_MAX];
+};
+
+#define MPI3_DRIVER2_PAGEVERSION               (0x00)
+#define MPI3_DRIVER2_MASTERTRIGGER_DIAG_TRACE_RELEASE                       (0x8000000000000000ULL)
+#define MPI3_DRIVER2_MASTERTRIGGER_DIAG_FW_RELEASE                          (0x4000000000000000ULL)
+#define MPI3_DRIVER2_MASTERTRIGGER_SNAPDUMP                                 (0x2000000000000000ULL)
+#define MPI3_DRIVER2_MASTERTRIGGER_DEVICE_REMOVAL_ENABLED                   (0x0000000000000004ULL)
+#define MPI3_DRIVER2_MASTERTRIGGER_TASK_MANAGEMENT_ENABLED                  (0x0000000000000002ULL)
+struct mpi3_driver_page10 {
+	struct mpi3_config_page_header         header;
+	__le16                             flags;
+	__le16                             reserved0a;
+	u8                                 num_allowed_commands;
+	u8                                 reserved0d[3];
+	union mpi3_allowed_cmd                allowed_command[MPI3_ALLOWED_CMDS_MAX];
+};
+
+#define MPI3_DRIVER10_PAGEVERSION               (0x00)
+struct mpi3_driver_page20 {
+	struct mpi3_config_page_header         header;
+	__le16                             flags;
+	__le16                             reserved0a;
+	u8                                 num_allowed_commands;
+	u8                                 reserved0d[3];
+	union mpi3_allowed_cmd                allowed_command[MPI3_ALLOWED_CMDS_MAX];
+};
+
+#define MPI3_DRIVER20_PAGEVERSION               (0x00)
+struct mpi3_driver_page30 {
+	struct mpi3_config_page_header         header;
+	__le16                             flags;
+	__le16                             reserved0a;
+	u8                                 num_allowed_commands;
+	u8                                 reserved0d[3];
+	union mpi3_allowed_cmd                allowed_command[MPI3_ALLOWED_CMDS_MAX];
+};
+
+#define MPI3_DRIVER30_PAGEVERSION               (0x00)
 union mpi3_security_mac {
 	__le32                             dword[16];
 	__le16                             word[32];
@@ -1102,7 +1320,7 @@ struct mpi3_security1_key_record {
 #define MPI3_SECURITY1_KEY_RECORD_CONSUMER_NOT_VALID         (0x00)
 #define MPI3_SECURITY1_KEY_RECORD_CONSUMER_SAFESTORE         (0x01)
 #define MPI3_SECURITY1_KEY_RECORD_CONSUMER_CERT_CHAIN        (0x02)
-#define MPI3_SECURITY1_KEY_RECORD_CONSUMER_AUTH_DEV_KEY      (0x03)
+#define MPI3_SECURITY1_KEY_RECORD_CONSUMER_DEVICE_KEY        (0x03)
 #define MPI3_SECURITY1_KEY_RECORD_CONSUMER_CACHE_OFFLOAD     (0x04)
 struct mpi3_security_page1 {
 	struct mpi3_config_page_header         header;
@@ -1137,16 +1355,30 @@ struct mpi3_sas_io_unit_page0 {
 	struct mpi3_config_page_header         header;
 	__le32                             reserved08;
 	u8                                 num_phys;
-	u8                                 reserved0d[3];
+	u8                                 init_status;
+	__le16                             reserved0e;
 	struct mpi3_sas_io_unit0_phy_data      phy_data[MPI3_SAS_IO_UNIT0_PHY_MAX];
 };
 
-#define MPI3_SASIOUNIT0_PAGEVERSION                         (0x00)
-#define MPI3_SASIOUNIT0_PORTFLAGS_DISC_IN_PROGRESS          (0x08)
-#define MPI3_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG          (0x01)
-#define MPI3_SASIOUNIT0_PHYFLAGS_INIT_PERSIST_CONNECT       (0x40)
-#define MPI3_SASIOUNIT0_PHYFLAGS_TARG_PERSIST_CONNECT       (0x20)
-#define MPI3_SASIOUNIT0_PHYFLAGS_PHY_DISABLED               (0x08)
+#define MPI3_SASIOUNIT0_PAGEVERSION                          (0x00)
+#define MPI3_SASIOUNIT0_INITSTATUS_NO_ERRORS                 (0x00)
+#define MPI3_SASIOUNIT0_INITSTATUS_NEEDS_INITIALIZATION      (0x01)
+#define MPI3_SASIOUNIT0_INITSTATUS_NO_TARGETS_ALLOCATED      (0x02)
+#define MPI3_SASIOUNIT0_INITSTATUS_BAD_NUM_PHYS              (0x04)
+#define MPI3_SASIOUNIT0_INITSTATUS_UNSUPPORTED_CONFIG        (0x05)
+#define MPI3_SASIOUNIT0_INITSTATUS_HOST_PHYS_ENABLED         (0x06)
+#define MPI3_SASIOUNIT0_INITSTATUS_PRODUCT_SPECIFIC_MIN      (0xf0)
+#define MPI3_SASIOUNIT0_INITSTATUS_PRODUCT_SPECIFIC_MAX      (0xff)
+#define MPI3_SASIOUNIT0_PORTFLAGS_DISC_IN_PROGRESS           (0x08)
+#define MPI3_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG_MASK      (0x03)
+#define MPI3_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG_IOUNIT1   (0x00)
+#define MPI3_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG_DYNAMIC   (0x01)
+#define MPI3_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG_BACKPLANE (0x02)
+#define MPI3_SASIOUNIT0_PHYFLAGS_INIT_PERSIST_CONNECT        (0x40)
+#define MPI3_SASIOUNIT0_PHYFLAGS_TARG_PERSIST_CONNECT        (0x20)
+#define MPI3_SASIOUNIT0_PHYFLAGS_PHY_DISABLED                (0x08)
+#define MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY                 (0x02)
+#define MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY                    (0x01)
 struct mpi3_sas_io_unit1_phy_data {
 	u8                 io_unit_port;
 	u8                 port_flags;
@@ -1343,6 +1575,26 @@ struct mpi3_sas_expander_page1 {
 #define MPI3_SASEXPANDER1_DISCINFO_BAD_PHY_DISABLED     (0x04)
 #define MPI3_SASEXPANDER1_DISCINFO_LINK_STATUS_CHANGE   (0x02)
 #define MPI3_SASEXPANDER1_DISCINFO_NO_ROUTING_ENTRIES   (0x01)
+#ifndef MPI3_SASEXPANDER2_MAX_NUM_PHYS
+#define MPI3_SASEXPANDER2_MAX_NUM_PHYS                               (1)
+#endif
+struct mpi3_sasexpander2_phy_element {
+	u8                                 link_change_count;
+	u8                                 reserved01;
+	__le16                             rate_change_count;
+	__le32                             reserved04;
+};
+
+struct mpi3_sas_expander_page2 {
+	struct mpi3_config_page_header         header;
+	u8                                 num_phys;
+	u8                                 reserved09;
+	__le16                             dev_handle;
+	__le32                             reserved0c;
+	struct mpi3_sasexpander2_phy_element   phy[MPI3_SASEXPANDER2_MAX_NUM_PHYS];
+};
+
+#define MPI3_SASEXPANDER2_PAGEVERSION                   (0x00)
 struct mpi3_sas_port_page0 {
 	struct mpi3_config_page_header         header;
 	u8                                 port_number;
@@ -1510,6 +1762,14 @@ struct mpi3_sas_phy_page4 {
 #define MPI3_PCIE_NEG_LINK_RATE_8_0                     (0x04)
 #define MPI3_PCIE_NEG_LINK_RATE_16_0                    (0x05)
 #define MPI3_PCIE_NEG_LINK_RATE_32_0                    (0x06)
+#define MPI3_PCIE_ASPM_ENABLE_NONE                      (0x0)
+#define MPI3_PCIE_ASPM_ENABLE_L0S                       (0x1)
+#define MPI3_PCIE_ASPM_ENABLE_L1                        (0x2)
+#define MPI3_PCIE_ASPM_ENABLE_L0S_L1                    (0x3)
+#define MPI3_PCIE_ASPM_SUPPORT_NONE                     (0x0)
+#define MPI3_PCIE_ASPM_SUPPORT_L0S                      (0x1)
+#define MPI3_PCIE_ASPM_SUPPORT_L1                       (0x2)
+#define MPI3_PCIE_ASPM_SUPPORT_L0S_L1                   (0x3)
 struct mpi3_pcie_io_unit0_phy_data {
 	u8         link;
 	u8         link_flags;
@@ -1540,7 +1800,8 @@ struct mpi3_pcie_io_unit_page0 {
 	__le32                             reserved08;
 	u8                                 num_phys;
 	u8                                 init_status;
-	__le16                             reserved0e;
+	u8                                 aspm;
+	u8                                 reserved0f;
 	struct mpi3_pcie_io_unit0_phy_data     phy_data[MPI3_PCIE_IO_UNIT0_PHY_MAX];
 };
 
@@ -1556,6 +1817,14 @@ struct mpi3_pcie_io_unit_page0 {
 #define MPI3_PCIEIOUNIT0_INITSTATUS_BAD_CLOCKING_MODE       (0x08)
 #define MPI3_PCIEIOUNIT0_INITSTATUS_PROD_SPEC_START         (0xf0)
 #define MPI3_PCIEIOUNIT0_INITSTATUS_PROD_SPEC_END           (0xff)
+#define MPI3_PCIEIOUNIT0_ASPM_SWITCH_STATES_MASK            (0xc0)
+#define MPI3_PCIEIOUNIT0_ASPM_SWITCH_STATES_SHIFT              (6)
+#define MPI3_PCIEIOUNIT0_ASPM_DIRECT_STATES_MASK            (0x30)
+#define MPI3_PCIEIOUNIT0_ASPM_DIRECT_STATES_SHIFT              (4)
+#define MPI3_PCIEIOUNIT0_ASPM_SWITCH_SUPPORT_MASK           (0x0c)
+#define MPI3_PCIEIOUNIT0_ASPM_SWITCH_SUPPORT_SHIFT             (2)
+#define MPI3_PCIEIOUNIT0_ASPM_DIRECT_SUPPORT_MASK           (0x03)
+#define MPI3_PCIEIOUNIT0_ASPM_DIRECT_SUPPORT_SHIFT             (0)
 struct mpi3_pcie_io_unit1_phy_data {
 	u8         link;
 	u8         link_flags;
@@ -1569,16 +1838,16 @@ struct mpi3_pcie_io_unit1_phy_data {
 #define MPI3_PCIEIOUNIT1_LINKFLAGS_PCIE_CLK_MODE_DIS_SEPARATE_REFCLK      (0x00)
 #define MPI3_PCIEIOUNIT1_LINKFLAGS_PCIE_CLK_MODE_EN_SRIS                  (0x01)
 #define MPI3_PCIEIOUNIT1_LINKFLAGS_PCIE_CLK_MODE_EN_SRNS                  (0x02)
-#define MPI3_PCIEIOUNIT1_PHYFLAGS_PHY_DISABLE               (0x08)
-#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_MASK                      (0xf0)
-#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_SHIFT                     (4)
-#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_2_5                       (0x20)
-#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_5_0                       (0x30)
-#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_8_0                       (0x40)
-#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_16_0                      (0x50)
-#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_32_0                      (0x60)
+#define MPI3_PCIEIOUNIT1_PHYFLAGS_PHY_DISABLE                             (0x08)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_MASK                               (0xf0)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_SHIFT                                 (4)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_2_5                                (0x20)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_5_0                                (0x30)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_8_0                                (0x40)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_16_0                               (0x50)
+#define MPI3_PCIEIOUNIT1_MMLR_MAX_RATE_32_0                               (0x60)
 #ifndef MPI3_PCIE_IO_UNIT1_PHY_MAX
-#define MPI3_PCIE_IO_UNIT1_PHY_MAX          (1)
+#define MPI3_PCIE_IO_UNIT1_PHY_MAX                                           (1)
 #endif
 struct mpi3_pcie_io_unit_page1 {
 	struct mpi3_config_page_header         header;
@@ -1586,21 +1855,66 @@ struct mpi3_pcie_io_unit_page1 {
 	__le32                             reserved0c;
 	u8                                 num_phys;
 	u8                                 reserved11;
-	__le16                             reserved12;
+	u8                                 aspm;
+	u8                                 reserved13;
 	struct mpi3_pcie_io_unit1_phy_data     phy_data[MPI3_PCIE_IO_UNIT1_PHY_MAX];
 };
 
-#define MPI3_PCIEIOUNIT1_PAGEVERSION                        (0x00)
+#define MPI3_PCIEIOUNIT1_PAGEVERSION                                           (0x00)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_OVERRIDE_DISABLE                   (0x80)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_DISABLE                  (0x40)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_MASK                (0x30)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SHIFT               (4)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRIS_SRNS_DISABLED  (0x00)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRIS_ENABLED        (0x10)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_CLOCK_OVERRIDE_MODE_SRNS_ENABLED        (0x20)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MASK                 (0x0f)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_2_5              (0x02)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_5_0              (0x03)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_8_0              (0x04)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_16_0             (0x05)
+#define MPI3_PCIEIOUNIT1_CONTROL_FLAGS_LINK_RATE_OVERRIDE_MAX_32_0             (0x06)
+#define MPI3_PCIEIOUNIT1_ASPM_SWITCH_MASK                                 (0x0c)
+#define MPI3_PCIEIOUNIT1_ASPM_SWITCH_SHIFT                                   (2)
+#define MPI3_PCIEIOUNIT1_ASPM_DIRECT_MASK                                 (0x03)
+#define MPI3_PCIEIOUNIT1_ASPM_DIRECT_SHIFT                                   (0)
 struct mpi3_pcie_io_unit_page2 {
 	struct mpi3_config_page_header         header;
-	__le16                             nv_me_max_queue_depth;
-	__le16                             reserved0a;
-	u8                                 nv_me_abort_to;
+	__le16                             nvme_max_q_dx1;
+	__le16                             nvme_max_q_dx2;
+	u8                                 nvme_abort_to;
 	u8                                 reserved0d;
-	__le16                             reserved0e;
+	__le16                             nvme_max_q_dx4;
 };
 
 #define MPI3_PCIEIOUNIT2_PAGEVERSION                        (0x00)
+#define MPI3_PCIEIOUNIT3_ERROR_RECEIVER_ERROR               (0)
+#define MPI3_PCIEIOUNIT3_ERROR_RECOVERY                     (1)
+#define MPI3_PCIEIOUNIT3_ERROR_CORRECTABLE_ERROR_MSG        (2)
+#define MPI3_PCIEIOUNIT3_ERROR_BAD_DLLP                     (3)
+#define MPI3_PCIEIOUNIT3_ERROR_BAD_TLP                      (4)
+#define MPI3_PCIEIOUNIT3_NUM_ERROR_INDEX                    (5)
+struct mpi3_pcie_io_unit3_error {
+	__le16                             threshold_count;
+	__le16                             reserved02;
+};
+
+struct mpi3_pcie_io_unit_page3 {
+	struct mpi3_config_page_header         header;
+	u8                                 threshold_window;
+	u8                                 threshold_action;
+	u8                                 escalation_count;
+	u8                                 escalation_action;
+	u8                                 num_errors;
+	u8                                 reserved0d[3];
+	struct mpi3_pcie_io_unit3_error        error[MPI3_PCIEIOUNIT3_NUM_ERROR_INDEX];
+};
+
+#define MPI3_PCIEIOUNIT3_PAGEVERSION                        (0x00)
+#define MPI3_PCIEIOUNIT3_ACTION_NO_ACTION                   (0x00)
+#define MPI3_PCIEIOUNIT3_ACTION_HOT_RESET                   (0x01)
+#define MPI3_PCIEIOUNIT3_ACTION_REDUCE_LINK_RATE_ONLY       (0x02)
+#define MPI3_PCIEIOUNIT3_ACTION_REDUCE_LINK_RATE_NO_ACCESS  (0x03)
 struct mpi3_pcie_switch_page0 {
 	struct mpi3_config_page_header     header;
 	u8                             io_unit_port;
@@ -1609,7 +1923,7 @@ struct mpi3_pcie_switch_page0 {
 	__le16                         dev_handle;
 	__le16                         parent_dev_handle;
 	u8                             num_ports;
-	u8                             pc_ie_level;
+	u8                             pcie_level;
 	__le16                         reserved12;
 	__le32                         reserved14;
 	__le32                         reserved18;
@@ -1623,7 +1937,8 @@ struct mpi3_pcie_switch_page0 {
 struct mpi3_pcie_switch_page1 {
 	struct mpi3_config_page_header     header;
 	u8                             io_unit_port;
-	u8                             reserved09[3];
+	u8                             flags;
+	__le16                         reserved0a;
 	u8                             num_ports;
 	u8                             port_num;
 	__le16                         attached_dev_handle;
@@ -1636,15 +1951,43 @@ struct mpi3_pcie_switch_page1 {
 };
 
 #define MPI3_PCIESWITCH1_PAGEVERSION        (0x00)
+#define MPI3_PCIESWITCH1_FLAGS_ASPMSTATE_MASK     (0x0c)
+#define MPI3_PCIESWITCH1_FLAGS_ASPMSTATE_SHIFT    (2)
+#define MPI3_PCIESWITCH1_FLAGS_ASPMSUPPORT_MASK     (0x03)
+#define MPI3_PCIESWITCH1_FLAGS_ASPMSUPPORT_SHIFT    (0)
+#ifndef MPI3_PCIESWITCH2_MAX_NUM_PORTS
+#define MPI3_PCIESWITCH2_MAX_NUM_PORTS                               (1)
+#endif
+struct mpi3_pcieswitch2_port_element {
+	__le16                             link_change_count;
+	__le16                             rate_change_count;
+	__le32                             reserved04;
+};
+
+struct mpi3_pcie_switch_page2 {
+	struct mpi3_config_page_header         header;
+	u8                                 num_ports;
+	u8                                 reserved09;
+	__le16                             dev_handle;
+	__le32                             reserved0c;
+	struct mpi3_pcieswitch2_port_element   port[MPI3_PCIESWITCH2_MAX_NUM_PORTS];
+};
+
+#define MPI3_PCIESWITCH2_PAGEVERSION        (0x00)
 struct mpi3_pcie_link_page0 {
 	struct mpi3_config_page_header     header;
 	u8                             link;
 	u8                             reserved09[3];
-	__le32                         correctable_error_count;
-	__le16                         n_fatal_error_count;
-	__le16                         reserved12;
-	__le16                         fatal_error_count;
-	__le16                         reserved16;
+	__le32                         reserved0c;
+	__le32                         receiver_error_count;
+	__le32                         recovery_count;
+	__le32                         corr_error_msg_count;
+	__le32                         non_fatal_error_msg_count;
+	__le32                         fatal_error_msg_count;
+	__le32                         non_fatal_error_count;
+	__le32                         fatal_error_count;
+	__le32                         bad_dllp_count;
+	__le32                         bad_tlp_count;
 };
 
 #define MPI3_PCIELINK0_PAGEVERSION          (0x00)
@@ -1654,11 +1997,12 @@ struct mpi3_enclosure_page0 {
 	__le16                             flags;
 	__le16                             enclosure_handle;
 	__le16                             num_slots;
-	__le16                             start_slot;
+	__le16                             reserved16;
 	u8                                 io_unit_port;
 	u8                                 enclosure_level;
 	__le16                             sep_dev_handle;
-	__le32                             reserved1c;
+	u8                                 chassis_slot;
+	u8                                 reserved1d[3];
 };
 
 #define MPI3_ENCLOSURE0_PAGEVERSION                     (0x00)
@@ -1666,6 +2010,7 @@ struct mpi3_enclosure_page0 {
 #define MPI3_ENCLS0_FLAGS_ENCL_TYPE_VIRTUAL             (0x0000)
 #define MPI3_ENCLS0_FLAGS_ENCL_TYPE_SAS                 (0x4000)
 #define MPI3_ENCLS0_FLAGS_ENCL_TYPE_PCIE                (0x8000)
+#define MPI3_ENCLS0_FLAGS_CHASSIS_SLOT_VALID            (0x0020)
 #define MPI3_ENCLS0_FLAGS_ENCL_DEV_PRESENT_MASK         (0x0010)
 #define MPI3_ENCLS0_FLAGS_ENCL_DEV_NOT_FOUND            (0x0000)
 #define MPI3_ENCLS0_FLAGS_ENCL_DEV_PRESENT              (0x0010)
@@ -1686,6 +2031,7 @@ struct mpi3_device0_sas_sata_format {
 	u8         zone_group;
 };
 
+#define MPI3_DEVICE0_SASSATA_FLAGS_WRITE_SAME_UNMAP_NCQ (0x0400)
 #define MPI3_DEVICE0_SASSATA_FLAGS_SLUMBER_CAP          (0x0200)
 #define MPI3_DEVICE0_SASSATA_FLAGS_PARTIAL_CAP          (0x0100)
 #define MPI3_DEVICE0_SASSATA_FLAGS_ASYNC_NOTIFY         (0x0080)
@@ -1707,10 +2053,11 @@ struct mpi3_device0_pcie_format {
 	__le32     maximum_data_transfer_size;
 	__le32     capabilities;
 	__le16     noiob;
-	u8         nv_me_abort_to;
+	u8         nvme_abort_to;
 	u8         page_size;
 	__le16     shutdown_latency;
-	__le16     reserved16;
+	u8         recovery_info;
+	u8         reserved17;
 };
 
 #define MPI3_DEVICE0_PCIE_LINK_RATE_32_0_SUPP           (0x10)
@@ -1718,16 +2065,38 @@ struct mpi3_device0_pcie_format {
 #define MPI3_DEVICE0_PCIE_LINK_RATE_8_0_SUPP            (0x04)
 #define MPI3_DEVICE0_PCIE_LINK_RATE_5_0_SUPP            (0x02)
 #define MPI3_DEVICE0_PCIE_LINK_RATE_2_5_SUPP            (0x01)
-#define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK             (0x0003)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK             (0x0007)
 #define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NO_DEVICE        (0x0000)
 #define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE      (0x0001)
 #define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_SWITCH_DEVICE    (0x0002)
 #define MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_SCSI_DEVICE      (0x0003)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_ASPM_MASK             (0x0030)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_ASPM_SHIFT            (4)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_MASK           (0x00c0)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_SHIFT          (6)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_0              (0x0000)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_1              (0x0040)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_2              (0x0080)
+#define MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_3              (0x00c0)
+#define MPI3_DEVICE0_PCIE_CAP_SGL_EXTRA_LENGTH_SUPPORTED    (0x00000020)
 #define MPI3_DEVICE0_PCIE_CAP_METADATA_SEPARATED            (0x00000010)
 #define MPI3_DEVICE0_PCIE_CAP_SGL_DWORD_ALIGN_REQUIRED      (0x00000008)
-#define MPI3_DEVICE0_PCIE_CAP_NVME_SGL_ENABLED              (0x00000004)
+#define MPI3_DEVICE0_PCIE_CAP_SGL_FORMAT_SGL                (0x00000004)
+#define MPI3_DEVICE0_PCIE_CAP_SGL_FORMAT_PRP                (0x00000000)
 #define MPI3_DEVICE0_PCIE_CAP_BIT_BUCKET_SGL_SUPP           (0x00000002)
 #define MPI3_DEVICE0_PCIE_CAP_SGL_SUPP                      (0x00000001)
+#define MPI3_DEVICE0_PCIE_CAP_ASPM_MASK                     (0x000000c0)
+#define MPI3_DEVICE0_PCIE_CAP_ASPM_SHIFT                    (6)
+#define MPI3_DEVICE0_PCIE_RECOVER_METHOD_MASK               (0xe0)
+#define MPI3_DEVICE0_PCIE_RECOVER_METHOD_NS_MGMT            (0x00)
+#define MPI3_DEVICE0_PCIE_RECOVER_METHOD_FORMAT             (0x20)
+#define MPI3_DEVICE0_PCIE_RECOVER_REASON_MASK               (0x1f)
+#define MPI3_DEVICE0_PCIE_RECOVER_REASON_NO_NS              (0x00)
+#define MPI3_DEVICE0_PCIE_RECOVER_REASON_NO_NSID_1          (0x01)
+#define MPI3_DEVICE0_PCIE_RECOVER_REASON_TOO_MANY_NS        (0x02)
+#define MPI3_DEVICE0_PCIE_RECOVER_REASON_PROTECTION         (0x03)
+#define MPI3_DEVICE0_PCIE_RECOVER_REASON_METADATA_SZ        (0x04)
+#define MPI3_DEVICE0_PCIE_RECOVER_REASON_LBA_DATA_SZ        (0x05)
 struct mpi3_device0_vd_format {
 	u8         vd_state;
 	u8         raid_level;
@@ -1783,6 +2152,8 @@ struct mpi3_device_page0 {
 };
 
 #define MPI3_DEVICE0_PAGEVERSION                        (0x00)
+#define MPI3_DEVICE0_PARENT_INVALID                     (0xffff)
+#define MPI3_DEVICE0_ENCLOSURE_HANDLE_NO_ENCLOSURE      (0x0000)
 #define MPI3_DEVICE0_WWID_INVALID                       (0xffffffffffffffff)
 #define MPI3_DEVICE0_PERSISTENTID_INVALID               (0xffff)
 #define MPI3_DEVICE0_IOUNITPORT_INVALID                 (0xff)
@@ -1792,9 +2163,13 @@ struct mpi3_device_page0 {
 #define MPI3_DEVICE0_ASTATUS_DEVICE_BLOCKED                         (0x03)
 #define MPI3_DEVICE0_ASTATUS_UNAUTHORIZED                           (0x04)
 #define MPI3_DEVICE0_ASTATUS_DEVICE_MISSING_DELAY                   (0x05)
+#define MPI3_DEVICE0_ASTATUS_PREPARE                                (0x06)
+#define MPI3_DEVICE0_ASTATUS_SAFE_MODE                              (0x07)
+#define MPI3_DEVICE0_ASTATUS_GENERIC_MAX                            (0x0f)
 #define MPI3_DEVICE0_ASTATUS_SAS_UNKNOWN                            (0x10)
 #define MPI3_DEVICE0_ASTATUS_ROUTE_NOT_ADDRESSABLE                  (0x11)
 #define MPI3_DEVICE0_ASTATUS_SMP_ERROR_NOT_ADDRESSABLE              (0x12)
+#define MPI3_DEVICE0_ASTATUS_SAS_MAX                                (0x1f)
 #define MPI3_DEVICE0_ASTATUS_SIF_UNKNOWN                            (0x20)
 #define MPI3_DEVICE0_ASTATUS_SIF_AFFILIATION_CONFLICT               (0x21)
 #define MPI3_DEVICE0_ASTATUS_SIF_DIAG                               (0x22)
@@ -1810,6 +2185,8 @@ struct mpi3_device_page0 {
 #define MPI3_DEVICE0_ASTATUS_PCIE_MEM_SPACE_ACCESS                  (0x31)
 #define MPI3_DEVICE0_ASTATUS_PCIE_UNSUPPORTED                       (0x32)
 #define MPI3_DEVICE0_ASTATUS_PCIE_MSIX_REQUIRED                     (0x33)
+#define MPI3_DEVICE0_ASTATUS_PCIE_ECRC_REQUIRED                     (0x34)
+#define MPI3_DEVICE0_ASTATUS_PCIE_MAX                               (0x3f)
 #define MPI3_DEVICE0_ASTATUS_NVME_UNKNOWN                           (0x40)
 #define MPI3_DEVICE0_ASTATUS_NVME_READY_TIMEOUT                     (0x41)
 #define MPI3_DEVICE0_ASTATUS_NVME_DEVCFG_UNSUPPORTED                (0x42)
@@ -1820,7 +2197,17 @@ struct mpi3_device_page0 {
 #define MPI3_DEVICE0_ASTATUS_NVME_GET_FEATURE_STAT_FAILED           (0x47)
 #define MPI3_DEVICE0_ASTATUS_NVME_IDLE_TIMEOUT                      (0x48)
 #define MPI3_DEVICE0_ASTATUS_NVME_CTRL_FAILURE_STATUS               (0x49)
-#define MPI3_DEVICE0_ASTATUS_VD_UNKNOWN                             (0x50)
+#define MPI3_DEVICE0_ASTATUS_NVME_INSUFFICIENT_POWER                (0x4a)
+#define MPI3_DEVICE0_ASTATUS_NVME_DOORBELL_STRIDE                   (0x4b)
+#define MPI3_DEVICE0_ASTATUS_NVME_MEM_PAGE_MIN_SIZE                 (0x4c)
+#define MPI3_DEVICE0_ASTATUS_NVME_MEMORY_ALLOCATION                 (0x4d)
+#define MPI3_DEVICE0_ASTATUS_NVME_COMPLETION_TIME                   (0x4e)
+#define MPI3_DEVICE0_ASTATUS_NVME_BAR                               (0x4f)
+#define MPI3_DEVICE0_ASTATUS_NVME_NS_DESCRIPTOR                     (0x50)
+#define MPI3_DEVICE0_ASTATUS_NVME_INCOMPATIBLE_SETTINGS             (0x51)
+#define MPI3_DEVICE0_ASTATUS_NVME_MAX                               (0x5f)
+#define MPI3_DEVICE0_ASTATUS_VD_UNKNOWN                             (0x80)
+#define MPI3_DEVICE0_ASTATUS_VD_MAX                                 (0x8f)
 #define MPI3_DEVICE0_FLAGS_CONTROLLER_DEV_HANDLE        (0x0080)
 #define MPI3_DEVICE0_FLAGS_HIDDEN                       (0x0008)
 #define MPI3_DEVICE0_FLAGS_ATT_METHOD_MASK              (0x0006)
@@ -1870,11 +2257,17 @@ struct mpi3_device_page1 {
 	struct mpi3_config_page_header         header;
 	__le16                             dev_handle;
 	__le16                             reserved0a;
-	__le32                             reserved0c[12];
+	__le16                             link_change_count;
+	__le16                             rate_change_count;
+	__le16                             tm_count;
+	__le16                             reserved12;
+	__le32                             reserved14[10];
 	u8                                 reserved3c[3];
 	u8                                 device_form;
 	union mpi3_device1_dev_spec_format    device_specific;
 };
 
 #define MPI3_DEVICE1_PAGEVERSION                            (0x00)
+#define MPI3_DEVICE1_COUNTER_MAX                            (0xfffe)
+#define MPI3_DEVICE1_COUNTER_INVALID                        (0xffff)
 #endif
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ce75503..e887d31 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -860,7 +860,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 			tgtdev->dev_spec.pcie_inf.reset_to =
 			    pcieinf->controller_reset_to;
 			tgtdev->dev_spec.pcie_inf.abort_to =
-			    pcieinf->nv_me_abort_to;
+			    pcieinf->nvme_abort_to;
 		}
 		if (tgtdev->dev_spec.pcie_inf.mdts > (1024 * 1024))
 			tgtdev->dev_spec.pcie_inf.mdts = (1024 * 1024);
-- 
2.27.0


--000000000000eb36e305d3945cd5
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIP42MmTOP8ys5zQrrwkD
kEI+HtYmQrUjDkCrDhAZ7EXAMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDJJd9UH7Ac6TDi+5VQBOz2rDr86CUFvCX3R5Se
mI/D9kWtdP8PzoMZFxn8ESGr6USbJBf5bpkU8vMDCSyLL7bbFZRy3RH4qSfl3pnF+4Rfi2NHBhvV
N3733/zvsFmJIf3VG9j/jRPhQR5Tcnuat28qaysFJK7wYK0t+tBBiailW+QRvjGmSiFcnQtgZjj+
I8y6hLpbNgyyxh5dqofKdgeHcIQkgcp2rWJCi0pxylaYBU7OpEOAwwhgQzyZcQdkX5XLRvEP4nVY
ceo7brmh4kdLEiYL3dsw8N5ipT9H5siO5Ol8JOmSVFg7BEPatEPvk2Cy9FyD9T9UoYcsjnTeha1x
--000000000000eb36e305d3945cd5--
