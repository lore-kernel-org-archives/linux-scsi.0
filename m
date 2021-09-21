Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A751C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70ADA6127B
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhIUSsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbhIUSrm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 14:47:42 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7939C061575
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w8so1624pgf.5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NeFfzIlGsI0tUNukOCOJuiDmGBBBU526qFyPvHybGFU=;
        b=ZuqV7RFI34rOfYO65CvltYBDt2ncubT1F5nU4Z8DHTg2B5OeQ01S+kt4uURnKRirOb
         2cJ9yNZjal5pjxlQiZ2Vy04LHxLp8M75/Hl9cgiliPouaSwnKCWqzhvDEvIBcZjnUCLn
         CM+V6pPRe5ewOOblTplxYGqvEfwr+j6tocGOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NeFfzIlGsI0tUNukOCOJuiDmGBBBU526qFyPvHybGFU=;
        b=4uUhUOy58++WARq7BWCU+UOiRK6CCOG4RQxmkXzo4Oq4gbBGQynIh2cdmDh26frH6l
         7zOS57sRYoHMM2Gskr8SQboLg83OkcBiJ2Ij/+HMhj9syw000AjBl8uldhPDJNaZVtrz
         n3EhVTsGZYnJXnZ972q5w/VuhC3FXeeU+MEMvsYXEave5i6um8tjEXOYrTygD+7XvNQz
         pkCbKXKXptQzrgGrprHBhcByPOw0VKMyHMVfHZ5gsmWVnevFdpFTTvb99NmAaDIlaR4y
         yQwK0FXs/tdDUh9HWrTiLmKt3s4k3g6XFmPEPRFu0LLd4mFfsaa9IUPhOCaQmMagfrx6
         4+PQ==
X-Gm-Message-State: AOAM533sBc02Q1wnB1UnYzAV42q+d+F17mGjT1ymlwAgBH48onjAA7od
        dlYgjt8rxCzYMStg5O18atwf23K7JzGeKyWbWBo3IWpR9/j0aB+S+C4v0kudA5gU70KFYVUmDLL
        a+LCusfhJajJ0H7RWHn6u6O4xpDX55lRezdk1XN+j9wOSd5o9NCeYmI9RdD9c39HAH24yv15Yl6
        5aYDILO/iB
X-Google-Smtp-Source: ABdhPJxShKJ/9C2ZK2Utmyodl+TJxxgz3lOOmHCiR3VqqLnOPelSqY7/lehwjZfO5looQwxDSicKBg==
X-Received: by 2002:a63:3607:: with SMTP id d7mr29605156pga.438.1632249971139;
        Tue, 21 Sep 2021 11:46:11 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f144sm18258897pfa.24.2021.09.21.11.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:46:10 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 1/7] mpi3mr: upgrade mpi30 Rev-V
Date:   Wed, 22 Sep 2021 00:15:54 +0530
Message-Id: <20210921184600.64427-2-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210921184600.64427-1-kashyap.desai@broadcom.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ca513c05cc85cf34"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ca513c05cc85cf34

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 603 ++++++++++++++++++----
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  59 ++-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  15 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 128 +++--
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |  44 ++
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       |  14 +
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h      | 303 +++++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  31 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           |   9 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |   2 +-
 10 files changed, 1052 insertions(+), 156 deletions(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_pci.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_tool.h

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index d43bbecef651..5e1f6ced0e71 100644
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
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
index 169e4f9b7b7c..c29b87de8e18 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_image.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
@@ -61,6 +61,8 @@ struct mpi3_component_image_header {
 #define MPI3_IMAGE_HEADER_SIGNATURE1_SPD                      (0x20445053)
 #define MPI3_IMAGE_HEADER_SIGNATURE1_GAS_GAUGE                (0x20534147)
 #define MPI3_IMAGE_HEADER_SIGNATURE1_PBLP                     (0x504c4250)
+#define MPI3_IMAGE_HEADER_SIGNATURE1_MANIFEST                 (0x464e414d)
+#define MPI3_IMAGE_HEADER_SIGNATURE1_OEM                      (0x204d454f)
 #define MPI3_IMAGE_HEADER_SIGNATURE2_VALUE                    (0x50584546)
 #define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_MASK         (0x00000030)
 #define MPI3_IMAGE_HEADER_FLAGS_DEVICE_KEY_BASIS_CDI          (0x00000000)
@@ -94,6 +96,61 @@ struct mpi3_component_image_header {
 #define MPI3_IMAGE_HEADER_HASH_EXCLUSION_OFFSET               (0x5c)
 #define MPI3_IMAGE_HEADER_NEXT_IMAGE_HEADER_OFFSET_OFFSET     (0x7c)
 #define MPI3_IMAGE_HEADER_SIZE                                (0x100)
+#ifndef MPI3_CI_MANIFEST_MPI_MAX
+#define MPI3_CI_MANIFEST_MPI_MAX                               (1)
+#endif
+struct mpi3_ci_manifest_mpi_comp_image_ref {
+	__le32                                signature1;
+	__le32                                reserved04[3];
+	struct mpi3_comp_image_version            component_image_version;
+	__le32                                component_image_version_string_offset;
+	__le32                                crc;
+};
+
+struct mpi3_ci_manifest_mpi {
+	u8                                       manifest_type;
+	u8                                       reserved01[3];
+	__le32                                   reserved04[3];
+	u8                                       num_image_references;
+	u8                                       release_level;
+	__le16                                   reserved12;
+	__le16                                   reserved14;
+	__le16                                   flags;
+	__le32                                   reserved18[2];
+	__le16                                   vendor_id;
+	__le16                                   device_id;
+	__le16                                   subsystem_vendor_id;
+	__le16                                   subsystem_id;
+	__le32                                   reserved28[2];
+	union mpi3_version_union                    package_security_version;
+	__le32                                   reserved34;
+	struct mpi3_comp_image_version               package_version;
+	__le32                                   package_version_string_offset;
+	__le32                                   package_build_date_string_offset;
+	__le32                                   package_build_time_string_offset;
+	__le32                                   reserved4c;
+	__le32                                   diag_authorization_identifier[16];
+	struct mpi3_ci_manifest_mpi_comp_image_ref   component_image_ref[MPI3_CI_MANIFEST_MPI_MAX];
+};
+
+#define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_DEV                        (0x00)
+#define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_PREALPHA                   (0x10)
+#define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_ALPHA                      (0x20)
+#define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_BETA                       (0x30)
+#define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_RC                         (0x40)
+#define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_GCA                        (0x50)
+#define MPI3_CI_MANIFEST_MPI_RELEASE_LEVEL_POINT                      (0x60)
+#define MPI3_CI_MANIFEST_MPI_FLAGS_DIAG_AUTHORIZATION                 (0x01)
+#define MPI3_CI_MANIFEST_MPI_SUBSYSTEMID_IGNORED                   (0xffff)
+#define MPI3_CI_MANIFEST_MPI_PKG_VER_STR_OFF_UNSPECIFIED           (0x00000000)
+#define MPI3_CI_MANIFEST_MPI_PKG_BUILD_DATE_STR_OFF_UNSPECIFIED    (0x00000000)
+#define MPI3_CI_MANIFEST_MPI_PKG_BUILD_TIME_STR_OFF_UNSPECIFIED    (0x00000000)
+union mpi3_ci_manifest {
+	struct mpi3_ci_manifest_mpi               mpi;
+	__le32                                dword[1];
+};
+
+#define MPI3_CI_MANIFEST_TYPE_MPI                                  (0x00)
 struct mpi3_extended_image_header {
 	u8                                image_type;
 	u8                                reserved01[3];
@@ -161,6 +218,7 @@ struct mpi3_encrypted_hash_entry {
 #define MPI3_HASH_ALGORITHM_SIZE_UNUSED              (0x00)
 #define MPI3_HASH_ALGORITHM_SIZE_SHA256              (0x01)
 #define MPI3_HASH_ALGORITHM_SIZE_SHA512              (0x02)
+#define MPI3_HASH_ALGORITHM_SIZE_SHA384              (0x03)
 #define MPI3_ENCRYPTION_ALGORITHM_UNUSED             (0x00)
 #define MPI3_ENCRYPTION_ALGORITHM_RSA256             (0x01)
 #define MPI3_ENCRYPTION_ALGORITHM_RSA512             (0x02)
@@ -178,7 +236,6 @@ struct mpi3_encrypted_key_with_hash_entry {
 	u8                         reserved03;
 	__le32                     reserved04;
 	__le32                     public_key[MPI3_PUBLIC_KEY_MAX];
-	__le32                     encrypted_hash[MPI3_ENCRYPTED_HASH_MAX];
 };
 
 #ifndef MPI3_ENCRYPTED_HASH_ENTRY_MAX
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
index e02b6d3cfba2..7a208dc81d49 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -13,7 +13,7 @@ struct mpi3_scsi_io_cdb_eedp32 {
 	__le32             transfer_length;
 };
 
-union mpi3_scso_io_cdb_union {
+union mpi3_scsi_io_cdb_union {
 	u8                         cdb32[32];
 	struct mpi3_scsi_io_cdb_eedp32 eedp32;
 	struct mpi3_sge_common         sge;
@@ -32,11 +32,12 @@ struct mpi3_scsi_io_request {
 	__le32                     skip_count;
 	__le32                     data_length;
 	u8                         lun[8];
-	union mpi3_scso_io_cdb_union  cdb;
+	union mpi3_scsi_io_cdb_union  cdb;
 	union mpi3_sge_union          sgl[4];
 };
 
 #define MPI3_SCSIIO_MSGFLAGS_METASGL_VALID                  (0x80)
+#define MPI3_SCSIIO_MSGFLAGS_DIVERT_TO_FIRMWARE             (0x40)
 #define MPI3_SCSIIO_FLAGS_LARGE_CDB                         (0x60000000)
 #define MPI3_SCSIIO_FLAGS_CDB_16_OR_LESS                    (0x00000000)
 #define MPI3_SCSIIO_FLAGS_CDB_GREATER_THAN_16               (0x20000000)
@@ -155,5 +156,13 @@ struct mpi3_scsi_task_mgmt_reply {
 	__le32                     reserved18;
 };
 
-#define MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC      (0x80)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE                (0x00)
+#define MPI3_SCSITASKMGMT_RSPCODE_INVALID_FRAME              (0x02)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_FUNCTION_NOT_SUPPORTED  (0x04)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_FAILED                  (0x05)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED               (0x08)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_INVALID_LUN             (0x09)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_OVERLAPPED_TAG          (0x0a)
+#define MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC           (0x80)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_NVME_DENIED             (0x81)
 #endif
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index 1af99a5382d5..bc56273778d3 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -29,10 +29,15 @@ struct mpi3_ioc_init_request {
 	__le64                   driver_information_address;
 };
 
-#define MPI3_WHOINIT_NOT_INITIALIZED            (0x00)
-#define MPI3_WHOINIT_ROM_BIOS                   (0x02)
-#define MPI3_WHOINIT_HOST_DRIVER                (0x03)
-#define MPI3_WHOINIT_MANUFACTURER               (0x04)
+#define MPI3_IOCINIT_MSGFLAGS_HOSTMETADATA_MASK          (0x03)
+#define MPI3_IOCINIT_MSGFLAGS_HOSTMETADATA_NOT_USED      (0x00)
+#define MPI3_IOCINIT_MSGFLAGS_HOSTMETADATA_SEPARATED     (0x01)
+#define MPI3_IOCINIT_MSGFLAGS_HOSTMETADATA_INLINE        (0x02)
+#define MPI3_IOCINIT_MSGFLAGS_HOSTMETADATA_BOTH          (0x03)
+#define MPI3_WHOINIT_NOT_INITIALIZED                     (0x00)
+#define MPI3_WHOINIT_ROM_BIOS                            (0x02)
+#define MPI3_WHOINIT_HOST_DRIVER                         (0x03)
+#define MPI3_WHOINIT_MANUFACTURER                        (0x04)
 struct mpi3_driver_info_layout {
 	__le32             information_length;
 	u8                 driver_signature[12];
@@ -77,17 +82,17 @@ struct mpi3_ioc_facts_data {
 	u8                         sge_modifier_shift;
 	u8                         protocol_flags;
 	__le16                     max_sas_initiators;
-	__le16                     max_sas_targets;
+	__le16                     reserved2a;
 	__le16                     max_sas_expanders;
 	__le16                     max_enclosures;
 	__le16                     min_dev_handle;
 	__le16                     max_dev_handle;
-	__le16                     max_pc_ie_switches;
+	__le16                     max_pcie_switches;
 	__le16                     max_nvme;
-	__le16                     max_pds;
+	__le16                     reserved38;
 	__le16                     max_vds;
 	__le16                     max_host_pds;
-	__le16                     max_advanced_host_pds;
+	__le16                     max_adv_host_pds;
 	__le16                     max_raid_pds;
 	__le16                     max_posted_cmd_buffers;
 	__le32                     flags;
@@ -97,26 +102,41 @@ struct mpi3_ioc_facts_data {
 	__le16                     reserved4e;
 	__le32                     diag_trace_size;
 	__le32                     diag_fw_size;
+	__le32                     diag_driver_size;
+	u8                         max_host_pd_ns_count;
+	u8                         max_adv_host_pd_ns_count;
+	u8                         max_raidpd_ns_count;
+	u8                         reserved5f;
 };
 
-#define MPI3_IOCFACTS_CAPABILITY_ADVANCED_HOST_PD             (0x00000010)
+#define MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_MASK          (0x80000000)
+#define MPI3_IOCFACTS_CAPABILITY_SUPERVISOR_IOC               (0x00000000)
+#define MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC           (0x10000000)
+#define MPI3_IOCFACTS_CAPABILITY_COMPLETE_RESET_CAPABLE       (0x00000100)
+#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_TRACE_ENABLED       (0x00000080)
+#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_FW_ENABLED          (0x00000040)
+#define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_DRIVER_ENABLED      (0x00000020)
+#define MPI3_IOCFACTS_CAPABILITY_ADVANCED_HOST_PD_ENABLED     (0x00000010)
 #define MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE                 (0x00000008)
-#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_GRAN_MASK      (0x00000001)
-#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_IOC_GRAN       (0x00000000)
-#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_REPLY_Q_GRAN   (0x00000001)
+#define MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED            (0x00000002)
+#define MPI3_IOCFACTS_CAPABILITY_COALESCE_CTRL_SUPPORTED      (0x00000001)
 #define MPI3_IOCFACTS_PID_TYPE_MASK                           (0xf000)
 #define MPI3_IOCFACTS_PID_TYPE_SHIFT                          (12)
 #define MPI3_IOCFACTS_PID_PRODUCT_MASK                        (0x0f00)
 #define MPI3_IOCFACTS_PID_PRODUCT_SHIFT                       (8)
 #define MPI3_IOCFACTS_PID_FAMILY_MASK                         (0x00ff)
 #define MPI3_IOCFACTS_PID_FAMILY_SHIFT                        (0)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_REKEY                   (0x2000)
+#define MPI3_IOCFACTS_EXCEPT_SAS_DISABLED                     (0x1000)
 #define MPI3_IOCFACTS_EXCEPT_SAFE_MODE                        (0x0800)
 #define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_MASK                (0x0700)
 #define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_NONE                (0x0000)
-#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_LOCAL_VIA_RAID      (0x0100)
-#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_LOCAL_VIA_OOB       (0x0200)
-#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_EXT_VIA_RAID        (0x0300)
-#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_EXT_VIA_OOB         (0x0400)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_LOCAL_VIA_MGMT      (0x0100)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_EXT_VIA_MGMT        (0x0200)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_DRIVE_EXT_VIA_MGMT  (0x0300)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_LOCAL_VIA_OOB       (0x0400)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_EXT_VIA_OOB         (0x0500)
+#define MPI3_IOCFACTS_EXCEPT_SECURITY_KEY_DRIVE_EXT_VIA_OOB   (0x0600)
 #define MPI3_IOCFACTS_EXCEPT_PCIE_DISABLED                    (0x0080)
 #define MPI3_IOCFACTS_EXCEPT_PARTIAL_MEMORY_FAILURE           (0x0040)
 #define MPI3_IOCFACTS_EXCEPT_MANUFACT_CHECKSUM_FAIL           (0x0020)
@@ -175,6 +195,7 @@ struct mpi3_create_request_queue_request {
 #define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_MASK          (0x80)
 #define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_SEGMENTED     (0x80)
 #define MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_CONTIGUOUS    (0x00)
+#define MPI3_CREATE_REQUEST_QUEUE_SIZE_MINIMUM                  (2)
 struct mpi3_delete_request_queue_request {
 	__le16             host_tag;
 	u8                 ioc_use_only02;
@@ -210,6 +231,7 @@ struct mpi3_create_reply_queue_request {
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_MASK           (0x01)
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_DISABLE        (0x00)
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_ENABLE         (0x01)
+#define MPI3_CREATE_REPLY_QUEUE_SIZE_MINIMUM                    (2)
 struct mpi3_delete_reply_queue_request {
 	__le16             host_tag;
 	u8                 ioc_use_only02;
@@ -255,7 +277,9 @@ struct mpi3_port_enable_request {
 #define MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR       (0x19)
 #define MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST        (0x20)
 #define MPI3_EVENT_PCIE_ENUMERATION                 (0x22)
+#define MPI3_EVENT_PCIE_ERROR_THRESHOLD             (0x23)
 #define MPI3_EVENT_HARD_RESET_RECEIVED              (0x40)
+#define MPI3_EVENT_DIAGNOSTIC_BUFFER_STATUS_CHANGE  (0x50)
 #define MPI3_EVENT_MIN_PRODUCT_SPECIFIC             (0x60)
 #define MPI3_EVENT_MAX_PRODUCT_SPECIFIC             (0x7f)
 #define MPI3_EVENT_NOTIFY_EVENTMASK_WORDS           (4)
@@ -311,10 +335,9 @@ struct mpi3_event_data_temp_threshold {
 	__le32             reserved0c;
 };
 
-#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD3_EXCEEDED         (0x0008)
-#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD2_EXCEEDED         (0x0004)
-#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD1_EXCEEDED         (0x0002)
-#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_THRESHOLD0_EXCEEDED         (0x0001)
+#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_FATAL_THRESHOLD_EXCEEDED     (0x0004)
+#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_CRITICAL_THRESHOLD_EXCEEDED  (0x0002)
+#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_WARNING_THRESHOLD_EXCEEDED   (0x0001)
 struct mpi3_event_data_cable_management {
 	__le32             active_cable_power_requirement;
 	u8                 status;
@@ -398,8 +421,10 @@ struct mpi3_event_data_sas_discovery {
 #define MPI3_SAS_DISC_STATUS_MAX_EXPANDERS_EXCEED             (0x40000000)
 #define MPI3_SAS_DISC_STATUS_MAX_DEVICES_EXCEED               (0x20000000)
 #define MPI3_SAS_DISC_STATUS_MAX_TOPO_PHYS_EXCEED             (0x10000000)
+#define MPI3_SAS_DISC_STATUS_INVALID_CEI                      (0x00010000)
+#define MPI3_SAS_DISC_STATUS_FECEI_MISMATCH                   (0x00008000)
 #define MPI3_SAS_DISC_STATUS_MULTIPLE_DEVICES_IN_SLOT         (0x00004000)
-#define MPI3_SAS_DISC_STATUS_SLOT_COUNT_MISMATCH              (0x00002000)
+#define MPI3_SAS_DISC_STATUS_NECEI_MISMATCH                   (0x00002000)
 #define MPI3_SAS_DISC_STATUS_TOO_MANY_SLOTS                   (0x00001000)
 #define MPI3_SAS_DISC_STATUS_EXP_MULTI_SUBTRACTIVE            (0x00000800)
 #define MPI3_SAS_DISC_STATUS_MULTI_PORT_DOMAIN                (0x00000400)
@@ -581,6 +606,20 @@ struct mpi3_event_data_pcie_topology_change_list {
 #define MPI3_EVENT_PCIE_TOPO_SS_NOT_RESPONDING          (0x02)
 #define MPI3_EVENT_PCIE_TOPO_SS_RESPONDING              (0x03)
 #define MPI3_EVENT_PCIE_TOPO_SS_DELAY_NOT_RESPONDING    (0x04)
+struct mpi3_event_data_pcie_error_threshold {
+	__le64                                 timestamp;
+	u8                                     reason_code;
+	u8                                     port;
+	__le16                                 switch_dev_handle;
+	u8                                     error;
+	u8                                     action;
+	__le16                                 threshold_count;
+	__le16                                 attached_dev_handle;
+	__le16                                 reserved12;
+};
+
+#define MPI3_EVENT_PCI_ERROR_RC_THRESHOLD_EXCEEDED          (0x00)
+#define MPI3_EVENT_PCI_ERROR_RC_ESCALATION                  (0x01)
 struct mpi3_event_data_sas_init_dev_status_change {
 	u8                 reason_code;
 	u8                 io_unit_port;
@@ -604,6 +643,16 @@ struct mpi3_event_data_hard_reset_received {
 	__le16             reserved02;
 };
 
+struct mpi3_event_data_diag_buffer_status_change {
+	u8                 type;
+	u8                 reason_code;
+	__le16             reserved02;
+	__le32             reserved04;
+};
+
+#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RELEASED             (0x01)
+#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_PAUSED               (0x02)
+#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RESUMED              (0x03)
 #define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
 #define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
 #define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)
@@ -645,21 +694,23 @@ struct mpi3_pel_seq {
 };
 
 struct mpi3_pel_entry {
+	__le64                             time_stamp;
 	__le32                             sequence_number;
-	__le32                             time_stamp[2];
 	__le16                             log_code;
 	__le16                             arg_type;
 	__le16                             locale;
 	u8                                 class;
-	u8                                 reserved13;
+	u8                                 flags;
 	u8                                 ext_num;
 	u8                                 num_exts;
 	u8                                 arg_data_size;
-	u8                                 fixed_format_size;
+	u8                                 fixed_format_strings_size;
 	__le32                             reserved18[2];
 	__le32                             pel_info[24];
 };
 
+#define MPI3_PEL_FLAGS_COMPLETE_RESET_NEEDED                  (0x02)
+#define MPI3_PEL_FLAGS_ACK_NEEDED                             (0x01)
 struct mpi3_pel_list {
 	__le32                             log_count;
 	__le32                             reserved04;
@@ -837,7 +888,10 @@ struct mpi3_pel_req_action_acknowledge {
 	__le32                             reserved10;
 };
 
-#define MPI3_PELACKNOWLEDGE_MSGFLAGS_SAFE_MODE_EXIT            (0x01)
+#define MPI3_PELACKNOWLEDGE_MSGFLAGS_SAFE_MODE_EXIT_MASK                     (0x03)
+#define MPI3_PELACKNOWLEDGE_MSGFLAGS_SAFE_MODE_EXIT_NO_GUIDANCE              (0x00)
+#define MPI3_PELACKNOWLEDGE_MSGFLAGS_SAFE_MODE_EXIT_CONTINUE_OP              (0x01)
+#define MPI3_PELACKNOWLEDGE_MSGFLAGS_SAFE_MODE_EXIT_TRANSITION_TO_FAULT      (0x02)
 struct mpi3_pel_reply {
 	__le16                             host_tag;
 	u8                                 ioc_use_only02;
@@ -885,6 +939,7 @@ struct mpi3_ci_download_request {
 #define MPI3_CI_DOWNLOAD_ACTION_ONLINE_ACTIVATION              (0x02)
 #define MPI3_CI_DOWNLOAD_ACTION_OFFLINE_ACTIVATION             (0x03)
 #define MPI3_CI_DOWNLOAD_ACTION_GET_STATUS                     (0x04)
+#define MPI3_CI_DOWNLOAD_ACTION_CANCEL_OFFLINE_ACTIVATION      (0x05)
 struct mpi3_ci_download_reply {
 	__le16                             host_tag;
 	u8                                 ioc_use_only02;
@@ -902,6 +957,7 @@ struct mpi3_ci_download_reply {
 };
 
 #define MPI3_CI_DOWNLOAD_FLAGS_DOWNLOAD_IN_PROGRESS                  (0x80)
+#define MPI3_CI_DOWNLOAD_FLAGS_OFFLINE_ACTIVATION_REQUIRED           (0x20)
 #define MPI3_CI_DOWNLOAD_FLAGS_KEY_UPDATE_PENDING                    (0x10)
 #define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_MASK                (0x0e)
 #define MPI3_CI_DOWNLOAD_FLAGS_ACTIVATION_STATUS_NOT_NEEDED          (0x00)
@@ -939,19 +995,28 @@ struct mpi3_ci_upload_request {
 #define MPI3_CTRL_OP_REMOVE_DEVICE                                   (0x10)
 #define MPI3_CTRL_OP_CLOSE_PERSISTENT_CONNECTION                     (0x11)
 #define MPI3_CTRL_OP_HIDDEN_ACK                                      (0x12)
+#define MPI3_CTRL_OP_CLEAR_DEVICE_COUNTERS                           (0x13)
 #define MPI3_CTRL_OP_SAS_SEND_PRIMITIVE                              (0x20)
-#define MPI3_CTRL_OP_SAS_CLEAR_ERROR_LOG                             (0x21)
-#define MPI3_CTRL_OP_PCIE_CLEAR_ERROR_LOG                            (0x22)
+#define MPI3_CTRL_OP_SAS_PHY_CONTROL                                 (0x21)
+#define MPI3_CTRL_OP_READ_INTERNAL_BUS                               (0x23)
+#define MPI3_CTRL_OP_WRITE_INTERNAL_BUS                              (0x24)
+#define MPI3_CTRL_OP_PCIE_LINK_CONTROL                               (0x30)
 #define MPI3_CTRL_OP_LOOKUP_MAPPING_PARAM8_LOOKUP_METHOD_INDEX       (0x00)
 #define MPI3_CTRL_OP_UPDATE_TIMESTAMP_PARAM64_TIMESTAMP_INDEX        (0x00)
 #define MPI3_CTRL_OP_REMOVE_DEVICE_PARAM16_DEVHANDLE_INDEX           (0x00)
 #define MPI3_CTRL_OP_CLOSE_PERSIST_CONN_PARAM16_DEVHANDLE_INDEX      (0x00)
 #define MPI3_CTRL_OP_HIDDEN_ACK_PARAM16_DEVHANDLE_INDEX              (0x00)
+#define MPI3_CTRL_OP_CLEAR_DEVICE_COUNTERS_PARAM16_DEVHANDLE_INDEX   (0x00)
 #define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM8_PHY_INDEX                  (0x00)
 #define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM8_PRIMSEQ_INDEX              (0x01)
 #define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM32_PRIMITIVE_INDEX           (0x00)
-#define MPI3_CTRL_OP_SAS_CLEAR_ERR_LOG_PARAM8_PHY_INDEX              (0x00)
-#define MPI3_CTRL_OP_PCIE_CLEAR_ERR_LOG_PARAM8_PHY_INDEX             (0x00)
+#define MPI3_CTRL_OP_SAS_PHY_CONTROL_PARAM8_ACTION_INDEX             (0x00)
+#define MPI3_CTRL_OP_SAS_PHY_CONTROL_PARAM8_PHY_INDEX                (0x01)
+#define MPI3_CTRL_OP_READ_INTERNAL_BUS_PARAM64_ADDRESS_INDEX         (0x00)
+#define MPI3_CTRL_OP_WRITE_INTERNAL_BUS_PARAM64_ADDRESS_INDEX        (0x00)
+#define MPI3_CTRL_OP_WRITE_INTERNAL_BUS_PARAM32_VALUE_INDEX          (0x00)
+#define MPI3_CTRL_OP_PCIE_LINK_CONTROL_PARAM8_ACTION_INDEX           (0x00)
+#define MPI3_CTRL_OP_PCIE_LINK_CONTROL_PARAM8_LINK_INDEX             (0x01)
 #define MPI3_CTRL_LOOKUP_METHOD_WWID_ADDRESS                         (0x01)
 #define MPI3_CTRL_LOOKUP_METHOD_ENCLOSURE_SLOT                       (0x02)
 #define MPI3_CTRL_LOOKUP_METHOD_SAS_DEVICE_NAME                      (0x03)
@@ -966,9 +1031,14 @@ struct mpi3_ci_upload_request {
 #define MPI3_CTRL_LOOKUP_METHOD_PERSISTID_PARAM16_PERSISTENT_ID_INDEX   (1)
 #define MPI3_CTRL_LOOKUP_METHOD_VALUE16_DEVH_INDEX                      (0)
 #define MPI3_CTRL_GET_TIMESTAMP_VALUE64_TIMESTAMP_INDEX                 (0)
+#define MPI3_CTRL_READ_INTERNAL_BUS_VALUE32_VALUE_INDEX                 (0)
 #define MPI3_CTRL_PRIMFLAGS_SINGLE                                   (0x01)
 #define MPI3_CTRL_PRIMFLAGS_TRIPLE                                   (0x03)
 #define MPI3_CTRL_PRIMFLAGS_REDUNDANT                                (0x06)
+#define MPI3_CTRL_ACTION_NOP                                         (0x00)
+#define MPI3_CTRL_ACTION_LINK_RESET                                  (0x01)
+#define MPI3_CTRL_ACTION_HARD_RESET                                  (0x02)
+#define MPI3_CTRL_ACTION_CLEAR_ERROR_LOG                             (0x05)
 struct mpi3_iounit_control_request {
 	__le16                             host_tag;
 	u8                                 ioc_use_only02;
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
new file mode 100644
index 000000000000..dbfaf4137560
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
+ *
+ */
+#ifndef MPI30_PCI_H
+#define MPI30_PCI_H     1
+#ifndef MPI3_NVME_ENCAP_CMD_MAX
+#define MPI3_NVME_ENCAP_CMD_MAX               (1)
+#endif
+struct mpi3_nvme_encapsulated_request {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     change_count;
+	__le16                     dev_handle;
+	__le16                     encapsulated_command_length;
+	__le16                     flags;
+	__le32                     reserved10[4];
+	__le32                     command[MPI3_NVME_ENCAP_CMD_MAX];
+};
+
+#define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_MASK      (0x0002)
+#define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_FAIL_ONLY (0x0000)
+#define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_ALL       (0x0002)
+#define MPI3_NVME_FLAGS_SUBMISSIONQ_MASK                (0x0001)
+#define MPI3_NVME_FLAGS_SUBMISSIONQ_IO                  (0x0000)
+#define MPI3_NVME_FLAGS_SUBMISSIONQ_ADMIN               (0x0001)
+struct mpi3_nvme_encapsulated_error_reply {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     ioc_use_only08;
+	__le16                     ioc_status;
+	__le32                     ioc_log_info;
+	__le32                     nvme_completion_entry[4];
+};
+#endif
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
index ba5018702960..298d895e374b 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
@@ -30,4 +30,18 @@ struct mpi3_smp_passthrough_request {
 	struct mpi3_sge_common         request_sge;
 	struct mpi3_sge_common         response_sge;
 };
+
+struct mpi3_smp_passthrough_reply {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     ioc_use_only08;
+	__le16                     ioc_status;
+	__le32                     ioc_log_info;
+	__le16                     response_data_length;
+	__le16                     reserved12;
+};
 #endif
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_tool.h b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
new file mode 100644
index 000000000000..54164a248c21
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_tool.h
@@ -0,0 +1,303 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Copyright 2016-2021 Broadcom Inc. All rights reserved.
+ *
+ */
+#ifndef MPI30_TOOL_H
+#define MPI30_TOOL_H     1
+struct mpi3_tool_clean_request {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     change_count;
+	u8                         tool;
+	u8                         reserved0b;
+	__le32                     area;
+};
+
+#define MPI3_TOOLBOX_TOOL_CLEAN                             (0x01)
+#define MPI3_TOOLBOX_TOOL_ISTWI_READ_WRITE                  (0x02)
+#define MPI3_TOOLBOX_TOOL_DIAGNOSTIC_CLI                    (0x03)
+#define MPI3_TOOLBOX_TOOL_LANE_MARGINING                    (0x04)
+#define MPI3_TOOLBOX_TOOL_RECOVER_DEVICE                    (0x05)
+#define MPI3_TOOLBOX_TOOL_LOOPBACK                          (0x06)
+#define MPI3_TOOLBOX_CLEAN_AREA_BIOS_BOOT_SERVICES          (0x00000008)
+#define MPI3_TOOLBOX_CLEAN_AREA_ALL_BUT_MFG                 (0x00000002)
+#define MPI3_TOOLBOX_CLEAN_AREA_NVSTORE                     (0x00000001)
+struct mpi3_tool_istwi_read_write_request {
+	__le16                               host_tag;
+	u8                                   ioc_use_only02;
+	u8                                   function;
+	__le16                               ioc_use_only04;
+	u8                                   ioc_use_only06;
+	u8                                   msg_flags;
+	__le16                               change_count;
+	u8                                   tool;
+	u8                                   flags;
+	u8                                   dev_index;
+	u8                                   action;
+	__le16                               reserved0e;
+	__le16                               tx_data_length;
+	__le16                               rx_data_length;
+	__le32                               reserved14[3];
+	struct mpi3_man11_istwi_device_format    istwi_device;
+	union mpi3_sge_union                    sgl;
+};
+
+#define MPI3_TOOLBOX_ISTWI_FLAGS_AUTO_RESERVE_RELEASE       (0x80)
+#define MPI3_TOOLBOX_ISTWI_FLAGS_ADDRESS_MODE_MASK          (0x04)
+#define MPI3_TOOLBOX_ISTWI_FLAGS_ADDRESS_MODE_DEVINDEX      (0x00)
+#define MPI3_TOOLBOX_ISTWI_FLAGS_ADDRESS_MODE_DEVICE_FIELD  (0x04)
+#define MPI3_TOOLBOX_ISTWI_FLAGS_PAGE_ADDRESS_MASK          (0x03)
+#define MPI3_TOOLBOX_ISTWI_ACTION_RESERVE_BUS               (0x00)
+#define MPI3_TOOLBOX_ISTWI_ACTION_RELEASE_BUS               (0x01)
+#define MPI3_TOOLBOX_ISTWI_ACTION_RESET                     (0x02)
+#define MPI3_TOOLBOX_ISTWI_ACTION_READ_DATA                 (0x03)
+#define MPI3_TOOLBOX_ISTWI_ACTION_WRITE_DATA                (0x04)
+#define MPI3_TOOLBOX_ISTWI_ACTION_SEQUENCE                  (0x05)
+struct mpi3_tool_istwi_read_write_reply {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     ioc_use_only08;
+	__le16                     ioc_status;
+	__le32                     ioc_log_info;
+	__le16                     istwi_status;
+	__le16                     reserved12;
+	__le16                     tx_data_count;
+	__le16                     rx_data_count;
+};
+
+struct mpi3_tool_diagnostic_cli_request {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     change_count;
+	u8                         tool;
+	u8                         reserved0b;
+	__le32                     command_data_length;
+	__le32                     response_data_length;
+	__le32                     reserved14[3];
+	union mpi3_sge_union          sgl;
+};
+
+struct mpi3_tool_diagnostic_cli_reply {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     ioc_use_only08;
+	__le16                     ioc_status;
+	__le32                     ioc_log_info;
+	__le32                     returned_data_length;
+};
+
+struct mpi3_tool_lane_margin_request {
+	__le16                               host_tag;
+	u8                                   ioc_use_only02;
+	u8                                   function;
+	__le16                               ioc_use_only04;
+	u8                                   ioc_use_only06;
+	u8                                   msg_flags;
+	__le16                               change_count;
+	u8                                   tool;
+	u8                                   reserved0b;
+	u8                                   action;
+	u8                                   switch_port;
+	__le16                               dev_handle;
+	u8                                   start_lane;
+	u8                                   num_lanes;
+	__le16                               reserved12;
+	__le32                               reserved14[3];
+	union mpi3_sge_union                    sgl;
+};
+
+#define MPI3_TOOLBOX_LM_ACTION_ENTER                         (0x00)
+#define MPI3_TOOLBOX_LM_ACTION_EXIT                          (0x01)
+#define MPI3_TOOLBOX_LM_ACTION_READ                          (0x02)
+#define MPI3_TOOLBOX_LM_ACTION_WRITE                         (0x03)
+struct mpi3_lane_margin_element {
+	__le16                               control;
+	__le16                               status;
+};
+
+struct mpi3_tool_lane_margin_reply {
+	__le16                               host_tag;
+	u8                                   ioc_use_only02;
+	u8                                   function;
+	__le16                               ioc_use_only04;
+	u8                                   ioc_use_only06;
+	u8                                   msg_flags;
+	__le16                               ioc_use_only08;
+	__le16                               ioc_status;
+	__le32                               ioc_log_info;
+	__le32                               returned_data_length;
+};
+
+struct mpi3_tool_recover_device_request {
+	__le16                               host_tag;
+	u8                                   ioc_use_only02;
+	u8                                   function;
+	__le16                               ioc_use_only04;
+	u8                                   ioc_use_only06;
+	u8                                   msg_flags;
+	__le16                               change_count;
+	u8                                   tool;
+	u8                                   reserved0b;
+	u8                                   action;
+	u8                                   reserved0d;
+	__le16                               dev_handle;
+};
+
+#define MPI3_TOOLBOX_RD_ACTION_START                        (0x01)
+#define MPI3_TOOLBOX_RD_ACTION_GET_STATUS                   (0x02)
+#define MPI3_TOOLBOX_RD_ACTION_ABORT                        (0x03)
+struct mpi3_tool_recover_device_reply {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     ioc_use_only08;
+	__le16                     ioc_status;
+	__le32                     ioc_log_info;
+	u8                         status;
+	u8                         reserved11;
+	__le16                     reserved1c;
+};
+
+#define MPI3_TOOLBOX_RD_STATUS_NOT_NEEDED                   (0x01)
+#define MPI3_TOOLBOX_RD_STATUS_NEEDED                       (0x02)
+#define MPI3_TOOLBOX_RD_STATUS_IN_PROGRESS                  (0x03)
+#define MPI3_TOOLBOX_RD_STATUS_ABORTING                     (0x04)
+struct mpi3_tool_loopback_request {
+	__le16                               host_tag;
+	u8                                   ioc_use_only02;
+	u8                                   function;
+	__le16                               ioc_use_only04;
+	u8                                   ioc_use_only06;
+	u8                                   msg_flags;
+	__le16                               change_count;
+	u8                                   tool;
+	u8                                   reserved0b;
+	__le32                               reserved0c;
+	__le64                               phys;
+};
+
+struct mpi3_tool_loopback_reply {
+	__le16                               host_tag;
+	u8                                   ioc_use_only02;
+	u8                                   function;
+	__le16                               ioc_use_only04;
+	u8                                   ioc_use_only06;
+	u8                                   msg_flags;
+	__le16                               ioc_use_only08;
+	__le16                               ioc_status;
+	__le32                               reserved0c;
+	__le64                               tested_phys;
+	__le64                               failed_phys;
+};
+
+struct mpi3_diag_buffer_post_request {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     change_count;
+	__le16                     reserved0a;
+	u8                         type;
+	u8                         reserved0d;
+	__le16                     reserved0e;
+	__le64                     address;
+	__le32                     length;
+	__le32                     reserved1c;
+};
+
+#define MPI3_DIAG_BUFFER_POST_MSGFLAGS_SEGMENTED            (0x01)
+#define MPI3_DIAG_BUFFER_TYPE_TRACE                         (0x01)
+#define MPI3_DIAG_BUFFER_TYPE_FW                            (0x02)
+#define MPI3_DIAG_BUFFER_TYPE_DRIVER                        (0x10)
+struct mpi3_driver_buffer_header {
+	__le32                     signature;
+	__le16                     header_size;
+	__le16                     rtt_file_header_offset;
+	__le32                     flags;
+	__le32                     circular_buffer_size;
+	__le32                     logical_buffer_end;
+	__le32                     logical_buffer_start;
+	__le32                     ioc_use_only18[2];
+	__le32                     reserved20[760];
+	__le32                     reserved_rttrace[256];
+};
+
+#define MPI3_DRIVER_DIAG_BUFFER_HEADER_SIGNATURE_CIRCULAR                (0x43495243)
+#define MPI3_DRIVER_DIAG_BUFFER_HEADER_FLAGS_CIRCULAR_BUF_FORMAT_MASK    (0x00000003)
+#define MPI3_DRIVER_DIAG_BUFFER_HEADER_FLAGS_CIRCULAR_BUF_FORMAT_ASCII   (0x00000000)
+#define MPI3_DRIVER_DIAG_BUFFER_HEADER_FLAGS_CIRCULAR_BUF_FORMAT_RTTRACE (0x00000001)
+struct mpi3_diag_buffer_manage_request {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     change_count;
+	__le16                     reserved0a;
+	u8                         type;
+	u8                         action;
+	__le16                     reserved0e;
+};
+
+#define MPI3_DIAG_BUFFER_ACTION_RELEASE                     (0x01)
+#define MPI3_DIAG_BUFFER_ACTION_PAUSE                       (0x02)
+#define MPI3_DIAG_BUFFER_ACTION_RESUME                      (0x03)
+struct mpi3_diag_buffer_upload_request {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     change_count;
+	__le16                     reserved0a;
+	u8                         type;
+	u8                         flags;
+	__le16                     reserved0e;
+	__le64                     context;
+	__le32                     reserved18;
+	__le32                     reserved1c;
+	union mpi3_sge_union          sgl;
+};
+
+#define MPI3_DIAG_BUFFER_UPLOAD_FLAGS_FORMAT_MASK           (0x01)
+#define MPI3_DIAG_BUFFER_UPLOAD_FLAGS_FORMAT_DECODED        (0x00)
+#define MPI3_DIAG_BUFFER_UPLOAD_FLAGS_FORMAT_ENCODED        (0x01)
+struct mpi3_diag_buffer_upload_reply {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     ioc_use_only08;
+	__le16                     ioc_status;
+	__le32                     ioc_log_info;
+	__le64                     context;
+	__le32                     returned_data_length;
+	__le32                     reserved1c;
+};
+#endif
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index 63e4e81d5397..6d550117ec2e 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -19,8 +19,8 @@ union mpi3_version_union {
 
 #define MPI3_VERSION_MAJOR                                              (3)
 #define MPI3_VERSION_MINOR                                              (0)
-#define MPI3_VERSION_UNIT                                               (0)
-#define MPI3_VERSION_DEV                                                (18)
+#define MPI3_VERSION_UNIT                                               (22)
+#define MPI3_VERSION_DEV                                                (0)
 struct mpi3_sysif_oper_queue_indexes {
 	__le16         producer_index;
 	__le16         reserved02;
@@ -74,6 +74,7 @@ struct mpi3_sysif_registers {
 #define MPI3_SYSIF_IOC_INFO_HIGH_OFFSET                                 (0x00000004)
 #define MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK                            (0xff000000)
 #define MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_SHIFT                           (24)
+#define MPI3_SYSIF_IOC_INFO_LOW_HCB_DISABLED                            (0x00000001)
 #define MPI3_SYSIF_IOC_CONFIG_OFFSET                                    (0x00000014)
 #define MPI3_SYSIF_IOC_CONFIG_OPER_RPY_ENT_SZ                           (0x00f00000)
 #define MPI3_SYSIF_IOC_CONFIG_OPER_RPY_ENT_SZ_SHIFT                     (20)
@@ -82,12 +83,13 @@ struct mpi3_sysif_registers {
 #define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_MASK                             (0x0000c000)
 #define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NO                               (0x00000000)
 #define MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL                           (0x00004000)
-#define MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN                           (0x00002000)
+#define MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN_SEND_REQ                  (0x00002000)
 #define MPI3_SYSIF_IOC_CONFIG_DIAG_SAVE                                 (0x00000010)
 #define MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC                                (0x00000001)
 #define MPI3_SYSIF_IOC_STATUS_OFFSET                                    (0x0000001c)
 #define MPI3_SYSIF_IOC_STATUS_RESET_HISTORY                             (0x00000010)
 #define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_MASK                             (0x0000000c)
+#define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_SHIFT                            (0x00000002)
 #define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_NONE                             (0x00000000)
 #define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_IN_PROGRESS                      (0x00000004)
 #define MPI3_SYSIF_IOC_STATUS_SHUTDOWN_COMPLETE                         (0x00000008)
@@ -107,9 +109,9 @@ struct mpi3_sysif_registers {
 #define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_NO_CHANGE                    (0x00000000)
 #define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_DISABLE                      (0x40000000)
 #define MPI3_SYSIF_COALESCE_CONTROL_ENABLE_ENABLE                       (0xc0000000)
-#define MPI3_SYSIF_COALESCE_CONTROL_VALID                               (0x30000000)
-#define MPI3_SYSIF_COALESCE_CONTROL_QUEUE_ID_MASK                       (0x00ff0000)
-#define MPI3_SYSIF_COALESCE_CONTROL_QUEUE_ID_SHIFT                      (16)
+#define MPI3_SYSIF_COALESCE_CONTROL_VALID                               (0x20000000)
+#define MPI3_SYSIF_COALESCE_CONTROL_MSIX_IDX_MASK                       (0x01ff0000)
+#define MPI3_SYSIF_COALESCE_CONTROL_MSIX_IDX_SHIFT                      (16)
 #define MPI3_SYSIF_COALESCE_CONTROL_TIMEOUT_MASK                        (0x0000ff00)
 #define MPI3_SYSIF_COALESCE_CONTROL_TIMEOUT_SHIFT                       (8)
 #define MPI3_SYSIF_COALESCE_CONTROL_DEPTH_MASK                          (0x000000ff)
@@ -117,9 +119,9 @@ struct mpi3_sysif_registers {
 #define MPI3_SYSIF_ADMIN_REQ_Q_PI_OFFSET                                (0x00001000)
 #define MPI3_SYSIF_ADMIN_REPLY_Q_CI_OFFSET                              (0x00001004)
 #define MPI3_SYSIF_OPER_REQ_Q_PI_OFFSET                                 (0x00001008)
-#define MPI3_SYSIF_OPER_REQ_Q_N_PI_OFFSET(n)                            (MPI3_SYSIF_OPER_REQ_Q_PI_OFFSET + (((n) - 1) * 8))
+#define MPI3_SYSIF_OPER_REQ_Q_N_PI_OFFSET(N)                            (MPI3_SYSIF_OPER_REQ_Q_PI_OFFSET + (((N) - 1) * 8))
 #define MPI3_SYSIF_OPER_REPLY_Q_CI_OFFSET                               (0x0000100c)
-#define MPI3_SYSIF_OPER_REPLY_Q_N_CI_OFFSET(n)                          (MPI3_SYSIF_OPER_REPLY_Q_CI_OFFSET + (((n) - 1) * 8))
+#define MPI3_SYSIF_OPER_REPLY_Q_N_CI_OFFSET(N)                          (MPI3_SYSIF_OPER_REPLY_Q_CI_OFFSET + (((N) - 1) * 8))
 #define MPI3_SYSIF_WRITE_SEQUENCE_OFFSET                                (0x00001c04)
 #define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_MASK                        (0x0000000f)
 #define MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_FLUSH                       (0x0)
@@ -133,7 +135,7 @@ struct mpi3_sysif_registers {
 #define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_MASK                          (0x00000700)
 #define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_NO_RESET                      (0x00000000)
 #define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET                    (0x00000100)
-#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_FLASH_RCVRY_RESET             (0x00000200)
+#define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_HOST_CONTROL_BOOT_RESET       (0x00000200)
 #define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_COMPLETE_RESET                (0x00000300)
 #define MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT                    (0x00000700)
 #define MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS                           (0x00000080)
@@ -153,8 +155,9 @@ struct mpi3_sysif_registers {
 #define MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET                       (0x0000f001)
 #define MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS                    (0x0000f002)
 #define MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED                     (0x0000f003)
-#define MPI3_SYSIF_FAULT_CODE_SAFE_MODE_EXIT                            (0x0000f004)
-#define MPI3_SYSIF_FAULT_CODE_FACTORY_RESET                             (0x0000f005)
+#define MPI3_SYSIF_FAULT_CODE_SOFT_RESET_NEEDED                         (0x0000f004)
+#define MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED                      (0x0000f005)
+#define MPI3_SYSIF_FAULT_CODE_TEMP_THRESHOLD_EXCEEDED                   (0x0000f006)
 #define MPI3_SYSIF_FAULT_INFO0_OFFSET                                   (0x00001c14)
 #define MPI3_SYSIF_FAULT_INFO1_OFFSET                                   (0x00001c18)
 #define MPI3_SYSIF_FAULT_INFO2_OFFSET                                   (0x00001c1c)
@@ -409,6 +412,8 @@ struct mpi3_default_reply {
 #define MPI3_IOCSTATUS_INVALID_STATE                (0x0008)
 #define MPI3_IOCSTATUS_INSUFFICIENT_POWER           (0x000a)
 #define MPI3_IOCSTATUS_INVALID_CHANGE_COUNT         (0x000b)
+#define MPI3_IOCSTATUS_ALLOWED_CMD_BLOCK            (0x000c)
+#define MPI3_IOCSTATUS_SUPERVISOR_ONLY              (0x000d)
 #define MPI3_IOCSTATUS_FAILURE                      (0x001f)
 #define MPI3_IOCSTATUS_CONFIG_INVALID_ACTION        (0x0020)
 #define MPI3_IOCSTATUS_CONFIG_INVALID_TYPE          (0x0021)
@@ -448,8 +453,10 @@ struct mpi3_default_reply {
 #define MPI3_IOCSTATUS_CI_UNSUPPORTED               (0x00b0)
 #define MPI3_IOCSTATUS_CI_UPDATE_SEQUENCE           (0x00b1)
 #define MPI3_IOCSTATUS_CI_VALIDATION_FAILED         (0x00b2)
-#define MPI3_IOCSTATUS_CI_UPDATE_PENDING            (0x00b3)
+#define MPI3_IOCSTATUS_CI_KEY_UPDATE_PENDING        (0x00b3)
+#define MPI3_IOCSTATUS_CI_KEY_UPDATE_NOT_POSSIBLE   (0x00b4)
 #define MPI3_IOCSTATUS_SECURITY_KEY_REQUIRED        (0x00c0)
+#define MPI3_IOCSTATUS_SECURITY_VIOLATION           (0x00c1)
 #define MPI3_IOCSTATUS_INVALID_QUEUE_ID             (0x0f00)
 #define MPI3_IOCSTATUS_INVALID_QUEUE_SIZE           (0x0f01)
 #define MPI3_IOCSTATUS_INVALID_MSIX_VECTOR          (0x0f02)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4a8316c6bd41..878a4963e2ad 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2009,7 +2009,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 			mpi3mr_print_fault_info(mrioc);
 		mrioc->diagsave_timeout = 0;
 
-		if (fault == MPI3_SYSIF_FAULT_CODE_FACTORY_RESET) {
+		if (fault == MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED) {
 			ioc_info(mrioc,
 			    "Factory Reset fault occurred marking controller as unrecoverable"
 			    );
@@ -2374,14 +2374,13 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.reply_sz = le16_to_cpu(facts_data->reply_frame_size) * 4;
 	mrioc->facts.exceptions = le16_to_cpu(facts_data->ioc_exceptions);
 	mrioc->facts.max_perids = le16_to_cpu(facts_data->max_persistent_id);
-	mrioc->facts.max_pds = le16_to_cpu(facts_data->max_pds);
 	mrioc->facts.max_vds = le16_to_cpu(facts_data->max_vds);
 	mrioc->facts.max_hpds = le16_to_cpu(facts_data->max_host_pds);
-	mrioc->facts.max_advhpds = le16_to_cpu(facts_data->max_advanced_host_pds);
+	mrioc->facts.max_advhpds = le16_to_cpu(facts_data->max_adv_host_pds);
 	mrioc->facts.max_raidpds = le16_to_cpu(facts_data->max_raid_pds);
 	mrioc->facts.max_nvme = le16_to_cpu(facts_data->max_nvme);
 	mrioc->facts.max_pcie_switches =
-	    le16_to_cpu(facts_data->max_pc_ie_switches);
+	    le16_to_cpu(facts_data->max_pcie_switches);
 	mrioc->facts.max_sasexpanders =
 	    le16_to_cpu(facts_data->max_sas_expanders);
 	mrioc->facts.max_sasinitiators =
@@ -3677,7 +3676,7 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
 	ioc_config |= MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL;
-	ioc_config |= MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN;
+	ioc_config |= MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN_SEND_REQ;
 
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2197988333fe..a17d2172bddf 100644
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
2.18.1


--000000000000ca513c05cc85cf34
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQcAYJKoZIhvcNAQcCoIIQYTCCEF0CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3HMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBU8wggQ3oAMCAQICDHA7TgNc55htm2viYDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjU2MDJaFw0yMjA5MTUxMTQ1MTZaMIGQ
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFjAUBgNVBAMTDUthc2h5YXAgRGVzYWkxKTAnBgkqhkiG9w0B
CQEWGmthc2h5YXAuZGVzYWlAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAzPAzyHBqFL/1u7ttl86wZrWK3vYcqFH+GBe0laKvAGOuEkaHijHa8iH+9GA8FUv1cdWF
WY3c3BGA+omJGYc4eHLEyKowuLRWvjV3MEjGBG7NIVoIaTkH4R+6Xs1P4/9EmUA0WI881B3pTv5W
nHG54/aqGUDSRDyWVhK7TLqJQkkiYKB0kH0GkB/UfmU/pmCaV68w5J6l4vz/TG23hWJmTg1lW5mu
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGf8+GwBbQZkUligCQ1hTzNEhkgZ
yhLX4yY7b1QTTu1ZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDkyMTE4NDYxMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBluPzeSqgTqYUZOI9lmdJVmBixHuYd0zqiU2UVEUlyHJ/F
8O53YPy2w6Lu33JyeefvJBTvnb8amFJk43tBuvyTmvIKaHConxzFiNugPw7Q+raKUNkfNlTcMUyi
fB/93jJyahclMunVzKzGCLeozwczw/gXngpcsfLxyiwuv7dDiJ0m9zaYqOzk5l5d73zJqIqiEcZT
c7tnM31e1T8+79NDWuiupcf40JBxT8903LdpV16FowVs8+jx4VbXbgB/J2+RhgygbZS8ySmexHIi
HrrHz4zjm5Q4um74LUz893/eVKpoYXSv/i7QnM9Zf0R8HM8srPAeOmIpHgykF8+jWNBT
--000000000000ca513c05cc85cf34--
