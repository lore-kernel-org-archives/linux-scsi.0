Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33E6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 09:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238982AbiBJJsq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 04:48:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbiBJJsj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 04:48:39 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFB4138
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 01:48:40 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id om7so4647100pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 01:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=hLKU4i6psE32Y5kT2dg71+KOU7rYGx0U5z0/jvD9cWk=;
        b=CmpfUJxkJisHcroiil/9S5fL0mmdF2sFnxI3G3N0OV4u0ejdIixiqPFn1Mcg7b8rI0
         D4hfBNL95TjQ6r6IbibdjzXpPcGY4eWwT+AVQNQBESl+TCDI9h2RLJRo/weODLpJ7wtr
         DjOEhzzTvJjpTVyc2uoX//u4bmuix/X8Qjwdk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=hLKU4i6psE32Y5kT2dg71+KOU7rYGx0U5z0/jvD9cWk=;
        b=Dt6O0+Oj0RambL3o/3SItp+2gAte7CgUKhSg+AffkYLa55nu7zhovtk+QaxQ7TX1LA
         JL5hZTpWHvxA04qQZM39TubVJXrZ8EYN7HOOtyKwk1z6LNw9O3QWQaRAyYy2mrtcXnh4
         sJp2mJJzB1eI0f3Bcu9GcZ9m9uHj87UdFPnTBfoXMDNQef2zmVqAZTDBipFljmBHbp1B
         uUOoBMNTqeIOeKotWllsq3xoamJiZ/LtASTi9wd5i1Xr79rD4T25S/2CdlJT5iLaT8mA
         w5wC6Rje4vLM8R6ZxZw5LVAxMEKeG8B7ID2zP40QD+J/hRvnlprCPjA4uBOoK0sup1rf
         ZdAA==
X-Gm-Message-State: AOAM5301uKIrMCRMFeqB1f/RhBfoyMRnr4FsGLTwzYq396ev/isITYT/
        BJFXvctalWvaANQj/44lyMUdvFIsDDSl/3tGDatNCASDP7NygARDsSsHdgcDLrxnce3X0BoXM7k
        ZrUqJHS6YmpH1l/DEsF/7cmrUfSW0iXAtkM4TTxGLKbpLUP4wHt3Rc1m+ZFHRAyFIyqEiJOL1rp
        wumEi5WDed6r4=
X-Google-Smtp-Source: ABdhPJyA9YtO0V0QOyLQQghEG6OaU85EBY1ezO+Tf+Ob6m8ygqls2cOmrLAI5hXS8oDml5PZJb9xXw==
X-Received: by 2002:a17:902:c406:: with SMTP id k6mr6713382plk.156.1644486519205;
        Thu, 10 Feb 2022 01:48:39 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o21sm23706698pfu.100.2022.02.10.01.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 01:48:38 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 3/9] mpi3mr: update MPI3 headers
Date:   Thu, 10 Feb 2022 15:28:11 +0530
Message-Id: <20220210095817.22828-4-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
References: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000db28c405d7a6daac"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000db28c405d7a6daac
Content-Transfer-Encoding: 8bit

Update MPI3 headers.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 122 +++++++++++++++-------
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |   3 +
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |  46 ++++----
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |   3 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   8 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           |   6 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  29 -----
 7 files changed, 116 insertions(+), 101 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 5e1f6ce..4cd9f24 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -191,7 +191,6 @@ struct mpi3_config_page_header {
 #define MPI3_TEMP_SENSOR_LOCATION_DRAM                  (0x3)
 #define MPI3_MFGPAGE_VENDORID_BROADCOM                  (0x1000)
 #define MPI3_MFGPAGE_DEVID_SAS4116                      (0x00a5)
-#define MPI3_MFGPAGE_DEVID_SAS4016                      (0x00a7)
 struct mpi3_man_page0 {
 	struct mpi3_config_page_header         header;
 	u8                                 chip_revision[8];
@@ -203,7 +202,7 @@ struct mpi3_man_page0 {
 	__le32                             reserved94;
 	__le32                             reserved98;
 	u8                                 oem;
-	u8                                 sub_oem;
+	u8                                 profile_identifier;
 	__le16                             flags;
 	u8                                 board_mfg_day;
 	u8                                 board_mfg_month;
@@ -267,13 +266,18 @@ struct mpi3_man6_gpio_entry {
 #define MPI3_MAN6_GPIO_FUNCTION_ISTWI_RESET                                   (0x0a)
 #define MPI3_MAN6_GPIO_FUNCTION_BACKEND_PCIE_RESET                            (0x0b)
 #define MPI3_MAN6_GPIO_FUNCTION_GLOBAL_FAULT                                  (0x0c)
-#define MPI3_MAN6_GPIO_FUNCTION_EPACK_ATTN                                    (0x0d)
+#define MPI3_MAN6_GPIO_FUNCTION_PBLP_STATUS_CHANGE                            (0x0d)
 #define MPI3_MAN6_GPIO_FUNCTION_EPACK_ONLINE                                  (0x0e)
 #define MPI3_MAN6_GPIO_FUNCTION_EPACK_FAULT                                   (0x0f)
 #define MPI3_MAN6_GPIO_FUNCTION_CTRL_TYPE                                     (0x10)
 #define MPI3_MAN6_GPIO_FUNCTION_LICENSE                                       (0x11)
 #define MPI3_MAN6_GPIO_FUNCTION_REFCLK_CONTROL                                (0x12)
 #define MPI3_MAN6_GPIO_FUNCTION_BACKEND_PCIE_RESET_CLAMP                      (0x13)
+#define MPI3_MAN6_GPIO_FUNCTION_AUXILIARY_POWER                               (0x14)
+#define MPI3_MAN6_GPIO_FUNCTION_RAID_DATA_CACHE_DIRTY                         (0x15)
+#define MPI3_MAN6_GPIO_FUNCTION_BOARD_FAN_CONTROL                             (0x16)
+#define MPI3_MAN6_GPIO_FUNCTION_BOARD_FAN_FAULT                               (0x17)
+#define MPI3_MAN6_GPIO_FUNCTION_POWER_BRAKE                                   (0x18)
 #define MPI3_MAN6_GPIO_ISTWI_RESET_FUNCTIONFLAGS_DEVSELECT_MASK               (0x01)
 #define MPI3_MAN6_GPIO_ISTWI_RESET_FUNCTIONFLAGS_DEVSELECT_ISTWI              (0x00)
 #define MPI3_MAN6_GPIO_ISTWI_RESET_FUNCTIONFLAGS_DEVSELECT_RECEPTACLEID       (0x01)
@@ -409,18 +413,22 @@ enum mpi3_man9_resources {
 #define MPI3_MAN9_MAX_OUTSTANDING_REQS      (65000)
 #define MPI3_MAN9_MIN_TARGET_CMDS           (0)
 #define MPI3_MAN9_MAX_TARGET_CMDS           (65535)
-#define MPI3_MAN9_MIN_SAS_TARGETS           (0)
-#define MPI3_MAN9_MAX_SAS_TARGETS           (65535)
-#define MPI3_MAN9_MIN_PCIE_TARGETS          (0)
+#define MPI3_MAN9_MIN_NVME_TARGETS          (0)
 #define MPI3_MAN9_MIN_INITIATORS            (0)
-#define MPI3_MAN9_MAX_INITIATORS            (65535)
-#define MPI3_MAN9_MIN_ENCLOSURES            (0)
+#define MPI3_MAN9_MIN_VDS                   (0)
+#define MPI3_MAN9_MIN_ENCLOSURES            (1)
 #define MPI3_MAN9_MAX_ENCLOSURES            (65535)
 #define MPI3_MAN9_MIN_ENCLOSURE_PHYS        (0)
-#define MPI3_MAN9_MIN_NAMESPACE_COUNT       (1)
 #define MPI3_MAN9_MIN_EXPANDERS             (0)
 #define MPI3_MAN9_MAX_EXPANDERS             (65535)
 #define MPI3_MAN9_MIN_PCIE_SWITCHES         (0)
+#define MPI3_MAN9_MIN_HOST_PD_DRIVES        (0)
+#define MPI3_MAN9_ADV_HOST_PD_DRIVES        (0)
+#define MPI3_MAN9_RAID_PD_DRIVES            (0)
+#define MPI3_MAN9_DRIVER_DIAG_BUFFER        (0)
+#define MPI3_MAN9_MIN_NAMESPACE_COUNT       (1)
+#define MPI3_MAN9_MIN_EXPANDERS             (0)
+#define MPI3_MAN9_MAX_EXPANDERS             (65535)
 struct mpi3_man_page9 {
 	struct mpi3_config_page_header         header;
 	u8                                 num_resources;
@@ -564,7 +572,15 @@ struct mpi3_man11_mgmt_ctrlr_device_format {
 	__le32     reserved00;
 	__le32     reserved04;
 };
-
+struct mpi3_man11_board_fan_device_format {
+	u8         flags;
+	u8         reserved01;
+	u8         min_fan_speed;
+	u8         max_fan_speed;
+	__le32     reserved04;
+};
+#define MPI3_MAN11_BOARD_FAN_FLAGS_FAN_CTRLR_TYPE_MASK        (0x07)
+#define MPI3_MAN11_BOARD_FAN_FLAGS_FAN_CTRLR_TYPE_AMC6821     (0x00)
 union mpi3_man11_device_specific_format {
 	struct mpi3_man11_mux_device_format            mux;
 	struct mpi3_man11_temp_sensor_device_format    temp_sensor;
@@ -574,9 +590,9 @@ union mpi3_man11_device_specific_format {
 	struct mpi3_man11_bkplane_mgmt_device_format   bkplane_mgmt;
 	struct mpi3_man11_gas_gauge_device_format      gas_gauge;
 	struct mpi3_man11_mgmt_ctrlr_device_format     mgmt_controller;
+	struct mpi3_man11_board_fan_device_format      board_fan;
 	__le32                                     words[2];
 };
-
 struct mpi3_man11_istwi_device_format {
 	u8                                     device_type;
 	u8                                     controller;
@@ -596,6 +612,7 @@ struct mpi3_man11_istwi_device_format {
 #define MPI3_MAN11_ISTWI_DEVTYPE_BACKPLANE_MGMT       (0x05)
 #define MPI3_MAN11_ISTWI_DEVTYPE_GAS_GAUGE            (0x06)
 #define MPI3_MAN11_ISTWI_DEVTYPE_MGMT_CONTROLLER      (0x07)
+#define MPI3_MAN11_ISTWI_DEVTYPE_BOARD_FAN            (0x08)
 #define MPI3_MAN11_ISTWI_FLAGS_MUX_PRESENT            (0x01)
 #ifndef MPI3_MAN11_ISTWI_DEVICE_MAX
 #define MPI3_MAN11_ISTWI_DEVICE_MAX             (1)
@@ -717,20 +734,16 @@ struct mpi3_man_page13 {
 #define MPI3_MAN13_PAGEVERSION                                       (0x00)
 struct mpi3_man_page14 {
 	struct mpi3_config_page_header         header;
-	__le16                             flags;
-	__le16                             reserved0a;
+	__le32                             reserved08;
 	u8                                 num_slot_groups;
 	u8                                 num_slots;
 	__le16                             max_cert_chain_length;
 	__le32                             sealed_slots;
+	__le32                             populated_slots;
+	__le32                             mgmt_pt_updatable_slots;
 };
-
 #define MPI3_MAN14_PAGEVERSION                                       (0x00)
-#define MPI3_MAN14_FLAGS_AUTH_SESSION_REQ                            (0x01)
-#define MPI3_MAN14_FLAGS_AUTH_API_MASK                               (0x0e)
-#define MPI3_MAN14_FLAGS_AUTH_API_NONE                               (0x00)
-#define MPI3_MAN14_FLAGS_AUTH_API_CERBERUS                           (0x02)
-#define MPI3_MAN14_FLAGS_AUTH_API_SPDM                               (0x04)
+#define MPI3_MAN14_NUMSLOTS_MAX                                      (32)
 #ifndef MPI3_MAN15_VERSION_RECORD_MAX
 #define MPI3_MAN15_VERSION_RECORD_MAX      1
 #endif
@@ -996,12 +1009,6 @@ struct mpi3_io_unit_page6 {
 
 #define MPI3_IOUNIT6_PAGEVERSION                (0x00)
 #define MPI3_IOUNIT6_FLAGS_ACT_CABLE_PWR_EXC    (0x01)
-struct mpi3_io_unit_page7 {
-	struct mpi3_config_page_header         header;
-	__le32                             reserved08;
-};
-
-#define MPI3_IOUNIT7_PAGEVERSION                (0x00)
 #ifndef MPI3_IOUNIT8_DIGEST_MAX
 #define MPI3_IOUNIT8_DIGEST_MAX                   (1)
 #endif
@@ -1041,6 +1048,48 @@ struct mpi3_io_unit_page9 {
 #define MPI3_IOUNIT9_PAGEVERSION                  (0x00)
 #define MPI3_IOUNIT9_FLAGS_VDFIRST_ENABLED         (0x01)
 #define MPI3_IOUNIT9_FIRSTDEVICE_UNKNOWN          (0xffff)
+struct mpi3_io_unit_page10 {
+	struct mpi3_config_page_header         header;
+	u8                                 flags;
+	u8                                 reserved09[3];
+	__le32                             silicon_id;
+	u8                                 fw_version_minor;
+	u8                                 fw_version_major;
+	u8                                 hw_version_minor;
+	u8                                 hw_version_major;
+	u8                                 part_number[16];
+};
+#define MPI3_IOUNIT10_PAGEVERSION                  (0x00)
+#define MPI3_IOUNIT10_FLAGS_VALID                  (0x01)
+#define MPI3_IOUNIT10_FLAGS_ACTIVEID_MASK          (0x02)
+#define MPI3_IOUNIT10_FLAGS_ACTIVEID_FIRST_REGION  (0x00)
+#define MPI3_IOUNIT10_FLAGS_ACTIVEID_SECOND_REGION (0x02)
+#define MPI3_IOUNIT10_FLAGS_PBLP_EXPECTED          (0x80)
+#ifndef MPI3_IOUNIT11_PROFILE_MAX
+#define MPI3_IOUNIT11_PROFILE_MAX                   (1)
+#endif
+struct mpi3_iounit11_profile {
+	u8                                 profile_identifier;
+	u8                                 reserved01[3];
+	__le16                             max_vds;
+	__le16                             max_host_pds;
+	__le16                             max_adv_host_pds;
+	__le16                             max_raid_pds;
+	__le16                             max_nvme;
+	__le16                             max_outstanding_requests;
+	__le16                             subsystem_id;
+	__le16                             reserved12;
+	__le32                             reserved14[2];
+};
+struct mpi3_io_unit_page11 {
+	struct mpi3_config_page_header         header;
+	__le32                             reserved08;
+	u8                                 num_profiles;
+	u8                                 current_profile_identifier;
+	__le16                             reserved0e;
+	struct mpi3_iounit11_profile           profile[MPI3_IOUNIT11_PROFILE_MAX];
+};
+#define MPI3_IOUNIT11_PAGEVERSION                  (0x00)
 struct mpi3_ioc_page0 {
 	struct mpi3_config_page_header         header;
 	__le32                             reserved08;
@@ -1058,12 +1107,10 @@ struct mpi3_ioc_page1 {
 	struct mpi3_config_page_header         header;
 	__le32                             coalescing_timeout;
 	u8                                 coalescing_depth;
-	u8                                 pci_slot_num;
+	u8                                 obsolete;
 	__le16                             reserved0e;
 };
-
 #define MPI3_IOC1_PAGEVERSION               (0x00)
-#define MPI3_IOC1_PCISLOTNUM_UNKNOWN        (0xff)
 #ifndef MPI3_IOC2_EVENTMASK_WORDS
 #define MPI3_IOC2_EVENTMASK_WORDS           (4)
 #endif
@@ -1134,13 +1181,11 @@ struct mpi3_driver_page0 {
 	__le32                             reserved14;
 	__le32                             reserved18;
 };
-
 #define MPI3_DRIVER0_PAGEVERSION               (0x00)
+#define MPI3_DRIVER0_BSDOPTS_DIS_HII_CONFIG_UTIL            (0x00000004)
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_MASK              (0x00000003)
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_IOC_AND_DEVS      (0x00000000)
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_IOC_ONLY          (0x00000001)
-#define MPI3_DRIVER0_BSDOPTS_DIS_HII_CONFIG_UTIL            (0x00000004)
-#define MPI3_DRIVER0_BSDOPTS_EN_ADV_ADAPTER_CONFIG          (0x00000008)
 struct mpi3_driver_page1 {
 	struct mpi3_config_page_header         header;
 	__le32                             flags;
@@ -2102,10 +2147,11 @@ struct mpi3_device0_vd_format {
 	u8         raid_level;
 	__le16     device_info;
 	__le16     flags;
-	__le16     reserved06;
-	__le32     reserved08[2];
+	__le16     io_throttle_group;
+	__le16     io_throttle_group_low;
+	__le16     io_throttle_group_high;
+	__le32     reserved0c;
 };
-
 #define MPI3_DEVICE0_VD_STATE_OFFLINE                       (0x00)
 #define MPI3_DEVICE0_VD_STATE_PARTIALLY_DEGRADED            (0x01)
 #define MPI3_DEVICE0_VD_STATE_DEGRADED                      (0x02)
@@ -2122,6 +2168,7 @@ struct mpi3_device0_vd_format {
 #define MPI3_DEVICE0_VD_DEVICE_INFO_NVME                    (0x0004)
 #define MPI3_DEVICE0_VD_DEVICE_INFO_SATA                    (0x0002)
 #define MPI3_DEVICE0_VD_DEVICE_INFO_SAS                     (0x0001)
+#define MPI3_DEVICE0_VD_FLAGS_IO_THROTTLE_GROUP_QD_MASK     (0xf000)
 #define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_MASK            (0x0003)
 #define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_NONE            (0x0000)
 #define MPI3_DEVICE0_VD_FLAGS_METADATA_MODE_HOST            (0x0001)
@@ -2205,21 +2252,20 @@ struct mpi3_device_page0 {
 #define MPI3_DEVICE0_ASTATUS_NVME_BAR                               (0x4f)
 #define MPI3_DEVICE0_ASTATUS_NVME_NS_DESCRIPTOR                     (0x50)
 #define MPI3_DEVICE0_ASTATUS_NVME_INCOMPATIBLE_SETTINGS             (0x51)
+#define MPI3_DEVICE0_ASTATUS_NVME_TOO_MANY_ERRORS                   (0x52)
 #define MPI3_DEVICE0_ASTATUS_NVME_MAX                               (0x5f)
 #define MPI3_DEVICE0_ASTATUS_VD_UNKNOWN                             (0x80)
 #define MPI3_DEVICE0_ASTATUS_VD_MAX                                 (0x8f)
 #define MPI3_DEVICE0_FLAGS_CONTROLLER_DEV_HANDLE        (0x0080)
+#define MPI3_DEVICE0_FLAGS_IO_THROTTLING_REQUIRED       (0x0010)
 #define MPI3_DEVICE0_FLAGS_HIDDEN                       (0x0008)
-#define MPI3_DEVICE0_FLAGS_ATT_METHOD_MASK              (0x0006)
-#define MPI3_DEVICE0_FLAGS_ATT_METHOD_NOT_DIR_ATTACHED  (0x0000)
-#define MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED      (0x0002)
 #define MPI3_DEVICE0_FLAGS_ATT_METHOD_VIRTUAL           (0x0004)
+#define MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED      (0x0002)
 #define MPI3_DEVICE0_FLAGS_DEVICE_PRESENT               (0x0001)
 #define MPI3_DEVICE0_QUEUE_DEPTH_NOT_APPLICABLE         (0x0000)
 struct mpi3_device1_sas_sata_format {
 	__le32                             reserved00;
 };
-
 struct mpi3_device1_pcie_format {
 	__le16                             vendor_id;
 	__le16                             device_id;
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
index 7a208dc..e2e8b22 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -55,6 +55,9 @@ struct mpi3_scsi_io_request {
 #define MPI3_SCSIIO_FLAGS_DATADIRECTION_READ                (0x00080000)
 #define MPI3_SCSIIO_FLAGS_DMAOPERATION_MASK                 (0x00030000)
 #define MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI              (0x00010000)
+#define MPI3_SCSIIO_FLAGS_DIVERT_REASON_MASK                (0x000000f0)
+#define MPI3_SCSIIO_FLAGS_DIVERT_REASON_IO_THROTTLING       (0x00000010)
+#define MPI3_SCSIIO_FLAGS_DIVERT_REASON_PROD_SPECIFIC       (0x00000080)
 #define MPI3_SCSIIO_METASGL_INDEX                           (3)
 struct mpi3_scsi_io_reply {
 	__le16                     host_tag;
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index bc56273..633037d 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -71,7 +71,7 @@ struct mpi3_ioc_facts_data {
 	u8                         ioc_number;
 	u8                         who_init;
 	__le16                     max_msix_vectors;
-	__le16                     max_outstanding_request;
+	__le16                     max_outstanding_requests;
 	__le16                     product_id;
 	__le16                     ioc_request_frame_size;
 	__le16                     reply_frame_size;
@@ -82,7 +82,7 @@ struct mpi3_ioc_facts_data {
 	u8                         sge_modifier_shift;
 	u8                         protocol_flags;
 	__le16                     max_sas_initiators;
-	__le16                     reserved2a;
+	__le16                     max_data_length;
 	__le16                     max_sas_expanders;
 	__le16                     max_enclosures;
 	__le16                     min_dev_handle;
@@ -106,12 +106,18 @@ struct mpi3_ioc_facts_data {
 	u8                         max_host_pd_ns_count;
 	u8                         max_adv_host_pd_ns_count;
 	u8                         max_raidpd_ns_count;
-	u8                         reserved5f;
+	u8                         max_devices_per_throttle_group;
+	__le16                     io_throttle_data_length;
+	__le16                     max_io_throttle_group;
+	__le16                     io_throttle_low;
+	__le16                     io_throttle_high;
 };
-
 #define MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_MASK          (0x80000000)
 #define MPI3_IOCFACTS_CAPABILITY_SUPERVISOR_IOC               (0x00000000)
-#define MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC           (0x10000000)
+#define MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC           (0x80000000)
+#define MPI3_IOCFACTS_CAPABILITY_INT_COALESCE_MASK            (0x00000600)
+#define MPI3_IOCFACTS_CAPABILITY_INT_COALESCE_FIXED_THRESHOLD (0x00000000)
+#define MPI3_IOCFACTS_CAPABILITY_INT_COALESCE_OUTSTANDING_IO  (0x00000200)
 #define MPI3_IOCFACTS_CAPABILITY_COMPLETE_RESET_CAPABLE       (0x00000100)
 #define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_TRACE_ENABLED       (0x00000080)
 #define MPI3_IOCFACTS_CAPABILITY_SEG_DIAG_FW_ENABLED          (0x00000040)
@@ -150,6 +156,7 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_PROTOCOL_NVME                           (0x0004)
 #define MPI3_IOCFACTS_PROTOCOL_SCSI_INITIATOR                 (0x0002)
 #define MPI3_IOCFACTS_PROTOCOL_SCSI_TARGET                    (0x0001)
+#define MPI3_IOCFACTS_MAX_DATA_LENGTH_NOT_REPORTED            (0x0000)
 #define MPI3_IOCFACTS_FLAGS_SIGNED_NVDATA_REQUIRED            (0x00010000)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK            (0x0000ff00)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT           (8)
@@ -160,6 +167,7 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_FLAGS_PERSONALITY_MASK                  (0x0000000f)
 #define MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA                  (0x00000000)
 #define MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR              (0x00000002)
+#define MPI3_IOCFACTS_IO_THROTTLE_DATA_LENGTH_NOT_REQUIRED    (0x0000)
 struct mpi3_mgmt_passthrough_request {
 	__le16                 host_tag;
 	u8                     ioc_use_only02;
@@ -228,6 +236,7 @@ struct mpi3_create_reply_queue_request {
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_MASK            (0x80)
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_SEGMENTED       (0x80)
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_SEGMENTED_CONTIGUOUS      (0x00)
+#define MPI3_CREATE_REPLY_QUEUE_FLAGS_COALESCE_DISABLE          (0x02)
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_MASK           (0x01)
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_DISABLE        (0x00)
 #define MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_ENABLE         (0x01)
@@ -257,7 +266,6 @@ struct mpi3_port_enable_request {
 #define MPI3_EVENT_LOG_DATA                         (0x01)
 #define MPI3_EVENT_CHANGE                           (0x02)
 #define MPI3_EVENT_GPIO_INTERRUPT                   (0x04)
-#define MPI3_EVENT_TEMP_THRESHOLD                   (0x05)
 #define MPI3_EVENT_CABLE_MGMT                       (0x06)
 #define MPI3_EVENT_DEVICE_ADDED                     (0x07)
 #define MPI3_EVENT_DEVICE_INFO_CHANGED              (0x08)
@@ -324,20 +332,6 @@ struct mpi3_event_data_gpio_interrupt {
 	u8                 gpio_num;
 	u8                 reserved01[3];
 };
-
-struct mpi3_event_data_temp_threshold {
-	__le16             status;
-	u8                 sensor_num;
-	u8                 reserved03;
-	__le16             current_temperature;
-	__le16             reserved06;
-	__le32             reserved08;
-	__le32             reserved0c;
-};
-
-#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_FATAL_THRESHOLD_EXCEEDED     (0x0004)
-#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_CRITICAL_THRESHOLD_EXCEEDED  (0x0002)
-#define MPI3_EVENT_TEMP_THRESHOLD_STATUS_WARNING_THRESHOLD_EXCEEDED   (0x0001)
 struct mpi3_event_data_cable_management {
 	__le32             active_cable_power_requirement;
 	u8                 status;
@@ -992,24 +986,27 @@ struct mpi3_ci_upload_request {
 #define MPI3_CTRL_OP_LOOKUP_MAPPING                                  (0x02)
 #define MPI3_CTRL_OP_UPDATE_TIMESTAMP                                (0x04)
 #define MPI3_CTRL_OP_GET_TIMESTAMP                                   (0x05)
+#define MPI3_CTRL_OP_GET_IOC_CHANGE_COUNT                            (0x06)
+#define MPI3_CTRL_OP_CHANGE_PROFILE                                  (0x07)
 #define MPI3_CTRL_OP_REMOVE_DEVICE                                   (0x10)
 #define MPI3_CTRL_OP_CLOSE_PERSISTENT_CONNECTION                     (0x11)
 #define MPI3_CTRL_OP_HIDDEN_ACK                                      (0x12)
 #define MPI3_CTRL_OP_CLEAR_DEVICE_COUNTERS                           (0x13)
-#define MPI3_CTRL_OP_SAS_SEND_PRIMITIVE                              (0x20)
+#define MPI3_CTRL_OP_SEND_SAS_PRIMITIVE                              (0x20)
 #define MPI3_CTRL_OP_SAS_PHY_CONTROL                                 (0x21)
 #define MPI3_CTRL_OP_READ_INTERNAL_BUS                               (0x23)
 #define MPI3_CTRL_OP_WRITE_INTERNAL_BUS                              (0x24)
 #define MPI3_CTRL_OP_PCIE_LINK_CONTROL                               (0x30)
 #define MPI3_CTRL_OP_LOOKUP_MAPPING_PARAM8_LOOKUP_METHOD_INDEX       (0x00)
 #define MPI3_CTRL_OP_UPDATE_TIMESTAMP_PARAM64_TIMESTAMP_INDEX        (0x00)
+#define MPI3_CTRL_OP_CHANGE_PROFILE_PARAM8_PROFILE_ID_INDEX          (0x00)
 #define MPI3_CTRL_OP_REMOVE_DEVICE_PARAM16_DEVHANDLE_INDEX           (0x00)
 #define MPI3_CTRL_OP_CLOSE_PERSIST_CONN_PARAM16_DEVHANDLE_INDEX      (0x00)
 #define MPI3_CTRL_OP_HIDDEN_ACK_PARAM16_DEVHANDLE_INDEX              (0x00)
 #define MPI3_CTRL_OP_CLEAR_DEVICE_COUNTERS_PARAM16_DEVHANDLE_INDEX   (0x00)
-#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM8_PHY_INDEX                  (0x00)
-#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM8_PRIMSEQ_INDEX              (0x01)
-#define MPI3_CTRL_OP_SAS_SEND_PRIM_PARAM32_PRIMITIVE_INDEX           (0x00)
+#define MPI3_CTRL_OP_SEND_SAS_PRIM_PARAM8_PHY_INDEX                  (0x00)
+#define MPI3_CTRL_OP_SEND_SAS_PRIM_PARAM8_PRIMSEQ_INDEX              (0x01)
+#define MPI3_CTRL_OP_SEND_SAS_PRIM_PARAM32_PRIMITIVE_INDEX           (0x00)
 #define MPI3_CTRL_OP_SAS_PHY_CONTROL_PARAM8_ACTION_INDEX             (0x00)
 #define MPI3_CTRL_OP_SAS_PHY_CONTROL_PARAM8_PHY_INDEX                (0x01)
 #define MPI3_CTRL_OP_READ_INTERNAL_BUS_PARAM64_ADDRESS_INDEX         (0x00)
@@ -1031,6 +1028,7 @@ struct mpi3_ci_upload_request {
 #define MPI3_CTRL_LOOKUP_METHOD_PERSISTID_PARAM16_PERSISTENT_ID_INDEX   (1)
 #define MPI3_CTRL_LOOKUP_METHOD_VALUE16_DEVH_INDEX                      (0)
 #define MPI3_CTRL_GET_TIMESTAMP_VALUE64_TIMESTAMP_INDEX                 (0)
+#define MPI3_CTRL_GET_IOC_CHANGE_COUNT_VALUE16_CHANGECOUNT_INDEX        (0)
 #define MPI3_CTRL_READ_INTERNAL_BUS_VALUE32_VALUE_INDEX                 (0)
 #define MPI3_CTRL_PRIMFLAGS_SINGLE                                   (0x01)
 #define MPI3_CTRL_PRIMFLAGS_TRIPLE                                   (0x03)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
index dbfaf41..77270f5 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -19,7 +19,8 @@ struct mpi3_nvme_encapsulated_request {
 	__le16                     dev_handle;
 	__le16                     encapsulated_command_length;
 	__le16                     flags;
-	__le32                     reserved10[4];
+	__le32                     data_length;
+	__le32                     reserved14[3];
 	__le32                     command[MPI3_NVME_ENCAP_CMD_MAX];
 };
 
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index 6d55011..ba05ea5 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -19,8 +19,9 @@ union mpi3_version_union {
 
 #define MPI3_VERSION_MAJOR                                              (3)
 #define MPI3_VERSION_MINOR                                              (0)
-#define MPI3_VERSION_UNIT                                               (22)
-#define MPI3_VERSION_DEV                                                (0)
+#define MPI3_VERSION_UNIT                                               (23)
+#define MPI3_VERSION_DEV                                                (1)
+#define MPI3_DEVHANDLE_INVALID                                          (0xffff)
 struct mpi3_sysif_oper_queue_indexes {
 	__le16         producer_index;
 	__le16         reserved02;
@@ -308,7 +309,7 @@ union mpi3_sge_union {
 #define MPI3_SGE_FLAGS_END_OF_BUFFER            (0x04)
 #define MPI3_SGE_FLAGS_DLAS_MASK                (0x03)
 #define MPI3_SGE_FLAGS_DLAS_SYSTEM              (0x00)
-#define MPI3_SGE_FLAGS_DLAS_IOC_DDR             (0x01)
+#define MPI3_SGE_FLAGS_DLAS_IOC_UDP             (0x01)
 #define MPI3_SGE_FLAGS_DLAS_IOC_CTL             (0x02)
 #define MPI3_SGE_EXT_OPER_EEDP                  (0x00)
 #define MPI3_EEDPFLAGS_INCR_PRI_REF_TAG             (0x8000)
@@ -329,7 +330,6 @@ union mpi3_sge_union {
 #define MPI3_EEDPFLAGS_HOST_GUARD_OEM_SPECIFIC      (0x0020)
 #define MPI3_EEDPFLAGS_PT_REF_TAG                   (0x0008)
 #define MPI3_EEDPFLAGS_EEDP_OP_MASK                 (0x0007)
-#define MPI3_EEDPFLAGS_EEDP_OP_NOOP                 (0x0000)
 #define MPI3_EEDPFLAGS_EEDP_OP_CHECK                (0x0001)
 #define MPI3_EEDPFLAGS_EEDP_OP_STRIP                (0x0002)
 #define MPI3_EEDPFLAGS_EEDP_OP_CHECK_REMOVE         (0x0003)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 7193b98..f7dc755 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -184,9 +184,6 @@ static void mpi3mr_print_event_data(struct mpi3mr_ioc *mrioc,
 	case MPI3_EVENT_GPIO_INTERRUPT:
 		desc = "GPIO Interrupt";
 		break;
-	case MPI3_EVENT_TEMP_THRESHOLD:
-		desc = "Temperature Threshold";
-		break;
 	case MPI3_EVENT_CABLE_MGMT:
 		desc = "Cable Management";
 		break;
@@ -2739,7 +2736,7 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
 	mrioc->facts.protocol_flags = facts_data->protocol_flags;
 	mrioc->facts.mpi_version = le32_to_cpu(facts_data->mpi_version.word);
-	mrioc->facts.max_reqs = le16_to_cpu(facts_data->max_outstanding_request);
+	mrioc->facts.max_reqs = le16_to_cpu(facts_data->max_outstanding_requests);
 	mrioc->facts.product_id = le16_to_cpu(facts_data->product_id);
 	mrioc->facts.reply_sz = le16_to_cpu(facts_data->reply_frame_size) * 4;
 	mrioc->facts.exceptions = le16_to_cpu(facts_data->ioc_exceptions);
@@ -3621,7 +3618,6 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PREPARE_FOR_RESET);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_TEMP_THRESHOLD);
 
 	retval = mpi3mr_issue_event_notification(mrioc);
 	if (retval)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index cfa7801..3eac18b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2185,30 +2185,6 @@ static void mpi3mr_energypackchg_evt_th(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.shutdown_timeout = shutdown_timeout;
 }
 
-/**
- * mpi3mr_tempthreshold_evt_th - Temp threshold event tophalf
- * @mrioc: Adapter instance reference
- * @event_reply: event data
- *
- * Displays temperature threshold event details and fault code
- * if any is hit due to temperature exceeding threshold.
- *
- * Return: Nothing
- */
-static void mpi3mr_tempthreshold_evt_th(struct mpi3mr_ioc *mrioc,
-	struct mpi3_event_notification_reply *event_reply)
-{
-	struct mpi3_event_data_temp_threshold *evtdata =
-	    (struct mpi3_event_data_temp_threshold *)event_reply->event_data;
-
-	ioc_err(mrioc, "Temperature threshold levels %s%s%s exceeded for sensor: %d !!! Current temperature in Celsius: %d\n",
-	    (le16_to_cpu(evtdata->status) & 0x1) ? "Warning " : " ",
-	    (le16_to_cpu(evtdata->status) & 0x2) ? "Critical " : " ",
-	    (le16_to_cpu(evtdata->status) & 0x4) ? "Fatal " : " ", evtdata->sensor_num,
-	    le16_to_cpu(evtdata->current_temperature));
-	mpi3mr_print_fault_info(mrioc);
-}
-
 /**
  * mpi3mr_cablemgmt_evt_th - Cable management event tophalf
  * @mrioc: Adapter instance reference
@@ -2319,11 +2295,6 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		mpi3mr_energypackchg_evt_th(mrioc, event_reply);
 		break;
 	}
-	case MPI3_EVENT_TEMP_THRESHOLD:
-	{
-		mpi3mr_tempthreshold_evt_th(mrioc, event_reply);
-		break;
-	}
 	case MPI3_EVENT_CABLE_MGMT:
 	{
 		mpi3mr_cablemgmt_evt_th(mrioc, event_reply);
-- 
2.27.0


--000000000000db28c405d7a6daac
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGd2SrYdKt7FrNsiavD8
PeI3Nvmi5bp4s1m5W3JNLRoEMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDIxMDA5NDgzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAstXmlc6iDKnWs+4x8GW4r8kgT2wWdHk5Uu10I
kEjNjDAlGFM8zIvaJfsUvoY8jnuYdIcgIU7y7oVeAJEVAMR+hzEC7dDG1SXrjk/WbGwJK+Wbcwa3
Nd5NbTgViR8AvhjeEN6pZOlJpzB9T7Zq/+qZmuWjE6xOxentvyaenPG3IPB73eOwyCsS9jQDpfJJ
2QjTF6Z6ibI00hGsov5M7U/e3RwWhah0OipcoUubUN/xb+eRqdUEE+FTUhIlsG1zkZeJFGSOvPJ2
e9olGMqUhvhTzfXyHwcoxMYmUiywLUX1SDzYSAoKz6SdIh9k99+tLELw6ZUbZSxd6lE63qAvEcip
--000000000000db28c405d7a6daac--
