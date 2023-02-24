Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBF7C61DA3
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 14:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjBXOoU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 09:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjBXOoJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 09:44:09 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5FA12065
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 06:44:07 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id q11so17278455plx.5
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 06:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NKkrGsbYCvNs0c/bnPeLCvqjXHumYwrHodSLpITsLDA=;
        b=fRn/dXwepwpfiZbUeCwsDdS6RqoRyAeAz5x/7JMT//d0FsG+SLHScJgdk2BcdA0uBO
         wv6zgrGyTPESxUKmklnG2mjN7ncaFSicis2KfHdKxALnmY3bWnlPZX+9M+bbE6u1bsoM
         K0HWBJfgjmPA0pzetdPqkLJSTpWJNQPrDioVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NKkrGsbYCvNs0c/bnPeLCvqjXHumYwrHodSLpITsLDA=;
        b=JPGTARgtmQSEDMBPgTWeDF+s5HSOknNMo8rw0mAREU60ySFDq2lk3flXLU02EKF6Rw
         Zx3KS74ZqjnJSBrPDYXCIvCHplr2tej4bZmvp+e30YCMrseXf+bztW9VfpVLiJx+KnIB
         UkPGZmnIGmKKzqzVp8JZVHVp+7U//iX5YgjHS0oA7P0/vAN1oVMk0r0Ul1qDMGKHmWa8
         MDjDjfl3BCbE06e9m+5+xz5rsmyQUhEU7D6PVpm9PofQDz7HW5CL4VehTDFr9A3pgOy+
         7lPmWuS51gZVDBVhVaMBEJMDY9BGuShTcmOI93bDSWDspK8qV8N+ysjHuLNn3KfVWHMq
         wZ9A==
X-Gm-Message-State: AO0yUKVO/oJc6D5WjmwbETwXloSrRzGYizlt6oBpC5qvylzopLdeLVgw
        BBa9EnyE+fCzbXWSlkFTaoZKzbCkregUhQRmSNF+RGrndqWXqYie3xJTpxqgFQor78QJSwbJToy
        HBMCHn4IqNOTa3kAjIJBVZ5l/yCCOyikXLfQogfOREYbnur9T/HVlC5+msgThk662P2HXrQy1iW
        4iGDowhCY=
X-Google-Smtp-Source: AK7set/YwKAmo3tYZFTYrhgfBY4VznXJpSD5ipaC0QnF78Y0f3Scq5XJgbPot8evyP55cJ/4PtRbcQ==
X-Received: by 2002:a17:90b:4b86:b0:234:19a1:8690 with SMTP id lr6-20020a17090b4b8600b0023419a18690mr19441462pjb.26.1677249846901;
        Fri, 24 Feb 2023 06:44:06 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902a9c500b00186748fe6ccsm8911549plr.214.2023.02.24.06.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:44:06 -0800 (PST)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 04/15] mpi3mr: Updated MPI Headers to revision 27
Date:   Fri, 24 Feb 2023 06:43:09 -0800
Message-Id: <20230224144320.10601-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230224144320.10601-1-ranjan.kumar@broadcom.com>
References: <20230224144320.10601-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005b4b1b05f573296e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000005b4b1b05f573296e
Content-Transfer-Encoding: 8bit

Updated MPI Headers to revision 27

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 110 +++++++++++++++++++---
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      |  21 +++++
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       |   4 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   2 +-
 4 files changed, 123 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 0a2af48915a5..1adccd2d5c77 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -63,8 +63,9 @@
 #define MPI3_PCIE_LINK_PGAD_LINKNUM_MASK                (0x000000ff)
 #define MPI3_SECURITY_PGAD_FORM_MASK                    (0xf0000000)
 #define MPI3_SECURITY_PGAD_FORM_GET_NEXT_SLOT           (0x00000000)
-#define MPI3_SECURITY_PGAD_FORM_SOT_NUM                 (0x10000000)
+#define MPI3_SECURITY_PGAD_FORM_SLOT_NUM		(0x10000000)
 #define MPI3_SECURITY_PGAD_SLOT_GROUP_MASK              (0x0000ff00)
+#define MPI3_SECURITY_PGAD_SLOT_GROUP_SHIFT		(8)
 #define MPI3_SECURITY_PGAD_SLOT_MASK                    (0x000000ff)
 struct mpi3_config_request {
 	__le16             host_tag;
@@ -135,7 +136,6 @@ struct mpi3_config_page_header {
 #define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_ACTIVE     (0x00000000)
 #define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_PARTIAL    (0x08000000)
 #define MPI3_SAS_PHYINFO_PHY_POWER_CONDITION_SLUMBER    (0x10000000)
-#define MPI3_SAS_NEG_LINK_RATE_PHYSICAL_SHIFT                 (0)
 #define MPI3_SAS_PHYINFO_REQUESTED_INSIDE_ZPSDS_CHANGED_MASK  (0x04000000)
 #define MPI3_SAS_PHYINFO_REQUESTED_INSIDE_ZPSDS_CHANGED_SHIFT (26)
 #define MPI3_SAS_PHYINFO_INSIDE_ZPSDS_PERSISTENT_MASK         (0x02000000)
@@ -201,6 +201,11 @@ struct mpi3_config_page_header {
 #define MPI3_TEMP_SENSOR_LOCATION_DRAM                  (0x3)
 #define MPI3_MFGPAGE_VENDORID_BROADCOM                  (0x1000)
 #define MPI3_MFGPAGE_DEVID_SAS4116                      (0x00a5)
+#define MPI3_MFGPAGE_DEVID_SAS5116_MPI			(0x00b3)
+#define MPI3_MFGPAGE_DEVID_SAS5116_NVME			(0x00b4)
+#define MPI3_MFGPAGE_DEVID_SAS5116_MPI_MGMT		(0x00b5)
+#define MPI3_MFGPAGE_DEVID_SAS5116_NVME_MGMT		(0x00b6)
+#define MPI3_MFGPAGE_DEVID_SAS5116_PCIE_SWITCH		(0x00b8)
 struct mpi3_man_page0 {
 	struct mpi3_config_page_header         header;
 	u8                                 chip_revision[8];
@@ -466,7 +471,7 @@ struct mpi3_man_page9 {
 
 #define MPI3_MAN9_PAGEVERSION                   (0x00)
 struct mpi3_man10_istwi_ctrlr_entry {
-	__le16     slave_address;
+	__le16     target_address;
 	__le16     flags;
 	u8         scl_low_override;
 	u8         scl_high_override;
@@ -476,8 +481,8 @@ struct mpi3_man10_istwi_ctrlr_entry {
 #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_MASK         (0x000c)
 #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_100K         (0x0000)
 #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_400K         (0x0004)
-#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_SLAVE_ENABLED          (0x0002)
-#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_MASTER_ENABLED         (0x0001)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_TARGET_ENABLED          (0x0002)
+#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_INITIATOR_ENABLED         (0x0001)
 #ifndef MPI3_MAN10_ISTWI_CTRLR_MAX
 #define MPI3_MAN10_ISTWI_CTRLR_MAX          (1)
 #endif
@@ -1160,7 +1165,7 @@ struct mpi3_io_unit_page12 {
 struct mpi3_iounit13_allowed_function {
 	__le16                             sub_function;
 	u8                                 function_code;
-	u8                                 fuction_flags;
+	u8                                 function_flags;
 };
 #define MPI3_IOUNIT13_FUNCTION_FLAGS_ADMIN_BLOCKED                 (0x04)
 #define MPI3_IOUNIT13_FUNCTION_FLAGS_OOB_BLOCKED                   (0x02)
@@ -1176,6 +1181,48 @@ struct mpi3_io_unit_page13 {
 #define MPI3_IOUNIT13_PAGEVERSION                                  (0x00)
 #define MPI3_IOUNIT13_FLAGS_ADMIN_BLOCKED                          (0x0002)
 #define MPI3_IOUNIT13_FLAGS_OOB_BLOCKED                            (0x0001)
+#ifndef MPI3_IOUNIT14_MD_MAX
+#define MPI3_IOUNIT14_MD_MAX                                       (1)
+#endif
+struct mpi3_iounit14_pagemetadata {
+	u8                                 page_type;
+	u8                                 page_number;
+	u8                                 reserved02;
+	u8                                 page_flags;
+};
+#define MPI3_IOUNIT14_PAGEMETADATA_PAGEFLAGS_OOBWRITE_ALLOWED      (0x02)
+#define MPI3_IOUNIT14_PAGEMETADATA_PAGEFLAGS_HOSTWRITE_ALLOWED     (0x01)
+struct mpi3_io_unit_page14 {
+	struct mpi3_config_page_header         header;
+	u8                                 flags;
+	u8                                 reserved09[3];
+	u8                                 num_pages;
+	u8                                 reserved0d[3];
+	struct mpi3_iounit14_pagemetadata      page_metadata[MPI3_IOUNIT14_MD_MAX];
+};
+#define MPI3_IOUNIT14_PAGEVERSION                                  (0x00)
+#define MPI3_IOUNIT14_FLAGS_READONLY                               (0x01)
+#ifndef MPI3_IOUNIT15_PBD_MAX
+#define MPI3_IOUNIT15_PBD_MAX                                       (1)
+#endif
+struct mpi3_io_unit_page15 {
+	struct mpi3_config_page_header         header;
+	u8                                 flags;
+	u8                                 reserved09[3];
+	__le32                             reserved0c;
+	u8                                 power_budgeting_capability;
+	u8                                 reserved11[3];
+	u8                                 num_power_budget_data;
+	u8                                 reserved15[3];
+	__le32                             power_budget_data[MPI3_IOUNIT15_PBD_MAX];
+};
+#define MPI3_IOUNIT15_PAGEVERSION                                   (0x00)
+#define MPI3_IOUNIT15_FLAGS_EPRINIT_INITREQUIRED                    (0x04)
+#define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_MASK                         (0x03)
+#define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_NOT_SUPPORTED                (0x00)
+#define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_WITHOUT_POWER_BRAKE_GPIO     (0x01)
+#define MPI3_IOUNIT15_FLAGS_EPRSUPPORT_WITH_POWER_BRAKE_GPIO        (0x02)
+#define MPI3_IOUNIT15_NUMPOWERBUDGETDATA_POWER_BUDGETING_DISABLED   (0x00)
 struct mpi3_ioc_page0 {
 	struct mpi3_config_page_header         header;
 	__le32                             reserved08;
@@ -1273,6 +1320,7 @@ struct mpi3_driver_page0 {
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_MASK              (0x00000003)
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_IOC_AND_DEVS      (0x00000000)
 #define MPI3_DRIVER0_BSDOPTS_REGISTRATION_IOC_ONLY          (0x00000001)
+#define MPI3_DRIVER0_BSDOPTS_REGISTRATION_IOC_AND_INTERNAL_DEVS		(0x00000002)
 struct mpi3_driver_page1 {
 	struct mpi3_config_page_header         header;
 	__le32                             flags;
@@ -1340,7 +1388,7 @@ union mpi3_driver2_trigger_element {
 #define MPI3_DRIVER2_TRIGGER_FLAGS_DIAG_FW_RELEASE                            (0x01)
 struct mpi3_driver_page2 {
 	struct mpi3_config_page_header         header;
-	__le64                             master_trigger;
+	__le64                             global_trigger;
 	__le32                             reserved10[3];
 	u8                                 num_triggers;
 	u8                                 reserved1d[3];
@@ -1348,11 +1396,13 @@ struct mpi3_driver_page2 {
 };
 
 #define MPI3_DRIVER2_PAGEVERSION               (0x00)
-#define MPI3_DRIVER2_MASTERTRIGGER_DIAG_TRACE_RELEASE                       (0x8000000000000000ULL)
-#define MPI3_DRIVER2_MASTERTRIGGER_DIAG_FW_RELEASE                          (0x4000000000000000ULL)
-#define MPI3_DRIVER2_MASTERTRIGGER_SNAPDUMP                                 (0x2000000000000000ULL)
-#define MPI3_DRIVER2_MASTERTRIGGER_DEVICE_REMOVAL_ENABLED                   (0x0000000000000004ULL)
-#define MPI3_DRIVER2_MASTERTRIGGER_TASK_MANAGEMENT_ENABLED                  (0x0000000000000002ULL)
+#define MPI3_DRIVER2_GLOBALTRIGGER_DIAG_TRACE_RELEASE                       (0x8000000000000000ULL)
+#define MPI3_DRIVER2_GLOBALTRIGGER_DIAG_FW_RELEASE                          (0x4000000000000000ULL)
+#define MPI3_DRIVER2_GLOBALTRIGGER_SNAPDUMP_ENABLED			    (0x2000000000000000ULL)
+#define MPI3_DRIVER2_GLOBALTRIGGER_POST_DIAG_TRACE_DISABLED                 (0x1000000000000000ULL)
+#define MPI3_DRIVER2_GLOBALTRIGGER_POST_DIAG_FW_DISABLED                    (0x0800000000000000ULL)
+#define MPI3_DRIVER2_GLOBALTRIGGER_DEVICE_REMOVAL_ENABLED                   (0x0000000000000004ULL)
+#define MPI3_DRIVER2_GLOBALTRIGGER_TASK_MANAGEMENT_ENABLED                  (0x0000000000000002ULL)
 struct mpi3_driver_page10 {
 	struct mpi3_config_page_header         header;
 	__le16                             flags;
@@ -1395,6 +1445,12 @@ union mpi3_security_nonce {
 	u8                                 byte[64];
 };
 
+union mpi3_security_root_digest {
+	__le32                             dword[16];
+	__le16                             word[32];
+	u8                                 byte[64];
+};
+
 union mpi3_security0_cert_chain {
 	__le32                             dword[1024];
 	__le16                             word[2048];
@@ -1467,6 +1523,32 @@ struct mpi3_security_page1 {
 };
 
 #define MPI3_SECURITY1_PAGEVERSION               (0x00)
+#ifndef MPI3_SECURITY2_TRUSTED_ROOT_MAX
+#define MPI3_SECURITY2_TRUSTED_ROOT_MAX      1
+#endif
+struct mpi3_security2_trusted_root {
+	u8                                 level;
+	u8                                 hash_algorithm;
+	__le16                             trusted_root_flags;
+	__le32                             reserved04[3];
+	union mpi3_security_root_digest       root_digest;
+};
+#define MPI3_SECURITY2_TRUSTEDROOT_TRUSTEDROOTFLAGS_HASHALGOSOURCE_MASK            (0x0006)
+#define MPI3_SECURITY2_TRUSTEDROOT_TRUSTEDROOTFLAGS_HASHALGOSOURCE_SHIFT           (1)
+#define MPI3_SECURITY2_TRUSTEDROOT_TRUSTEDROOTFLAGS_HASHALGOSOURCE_HA_FIELD        (0x0000)
+#define MPI3_SECURITY2_TRUSTEDROOT_TRUSTEDROOTFLAGS_HASHALGOSOURCE_AKI             (0x0002)
+#define MPI3_SECURITY2_TRUSTEDROOT_TRUSTEDROOTFLAGS_USERPROVISIONED_YES            (0x0001)
+struct mpi3_security_page2 {
+	struct mpi3_config_page_header         header;
+	__le32                             reserved08[2];
+	union mpi3_security_mac               mac;
+	union mpi3_security_nonce             nonce;
+	__le32                             reserved90[3];
+	u8                                 num_roots;
+	u8                                 reserved9d[3];
+	struct mpi3_security2_trusted_root     trusted_root[MPI3_SECURITY2_TRUSTED_ROOT_MAX];
+};
+#define MPI3_SECURITY2_PAGEVERSION               (0x00)
 struct mpi3_sas_io_unit0_phy_data {
 	u8                 io_unit_port;
 	u8                 port_flags;
@@ -2351,6 +2433,10 @@ struct mpi3_device_page0 {
 #define MPI3_DEVICE0_ASTATUS_NVME_MAX                               (0x5f)
 #define MPI3_DEVICE0_ASTATUS_VD_UNKNOWN                             (0x80)
 #define MPI3_DEVICE0_ASTATUS_VD_MAX                                 (0x8f)
+#define MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_MASK          (0xe000)
+#define MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_NO_LIMIT      (0x0000)
+#define MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_256_LB        (0x2000)
+#define MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_2048_LB       (0x4000)
 #define MPI3_DEVICE0_FLAGS_CONTROLLER_DEV_HANDLE        (0x0080)
 #define MPI3_DEVICE0_FLAGS_IO_THROTTLING_REQUIRED       (0x0010)
 #define MPI3_DEVICE0_FLAGS_HIDDEN                       (0x0008)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
index 3c03610ecfa6..9efd4c6de813 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -56,6 +56,7 @@ struct mpi3_scsi_io_request {
 #define MPI3_SCSIIO_FLAGS_DMAOPERATION_HOST_PI              (0x00010000)
 #define MPI3_SCSIIO_FLAGS_DIVERT_REASON_MASK                (0x000000f0)
 #define MPI3_SCSIIO_FLAGS_DIVERT_REASON_IO_THROTTLING       (0x00000010)
+#define MPI3_SCSIIO_FLAGS_DIVERT_REASON_WRITE_SAME_TOO_LARGE (0x00000020)
 #define MPI3_SCSIIO_FLAGS_DIVERT_REASON_PROD_SPECIFIC       (0x00000080)
 #define MPI3_SCSIIO_METASGL_INDEX                           (3)
 struct mpi3_scsi_io_reply {
@@ -114,4 +115,24 @@ struct mpi3_scsi_io_reply {
 #define MPI3_SCSI_RSP_ARI0_MASK                 (0xff000000)
 #define MPI3_SCSI_RSP_ARI0_SHIFT                (24)
 #define MPI3_SCSI_TASKTAG_UNKNOWN               (0xffff)
+#define MPI3_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU      (0x08)
+#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK               (0x01)
+#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK_SET           (0x02)
+#define MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET             (0x03)
+#define MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET       (0x05)
+#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET           (0x06)
+#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK               (0x07)
+#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_ACA                (0x08)
+#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK_SET           (0x09)
+#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_ASYNC_EVENT        (0x0a)
+#define MPI3_SCSITASKMGMT_TASKTYPE_I_T_NEXUS_RESET          (0x0b)
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
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
index b7a5df01120d..1b2a96325d21 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -5,7 +5,9 @@
  */
 #ifndef MPI30_PCI_H
 #define MPI30_PCI_H     1
-
+#ifndef MPI3_NVME_ENCAP_CMD_MAX
+#define MPI3_NVME_ENCAP_CMD_MAX               (1)
+#endif
 #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_MASK      (0x0002)
 #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_FAIL_ONLY (0x0000)
 #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_ALL       (0x0002)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index 9b76b9632751..f0cd203d78fb 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -18,7 +18,7 @@ union mpi3_version_union {
 
 #define MPI3_VERSION_MAJOR                                              (3)
 #define MPI3_VERSION_MINOR                                              (0)
-#define MPI3_VERSION_UNIT                                               (26)
+#define MPI3_VERSION_UNIT                                               (27)
 #define MPI3_VERSION_DEV                                                (0)
 #define MPI3_DEVHANDLE_INVALID                                          (0xffff)
 struct mpi3_sysif_oper_queue_indexes {
-- 
2.31.1


--0000000000005b4b1b05f573296e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIL5dnzhZHx5jbDKHkMxAnD0/kDVZk3Lf
z3eD6UlVMi9IMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDIy
NDE0NDQwN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCJDsuK34A+Ptoaki1MfYf6OiaDuFCe2+wxyUwFWx0277QjWT4D
psHMvkRWrS3GRHpYQXos74eDaYFN+YUo3uU2ia50qwKZnfP4X53EEHmGW6dwGt6PpFrxBpsaeAWx
ir1Pp0vi8p7gQswH4D4w+6DHBALOtFnvtr7xLykJkBjwBKZXW9g/mdf9tueH/HxPD9W+FbMQ940q
+745GnXmmhMA14iDYqmgvBJxYy4OcBssv7sG752PrWk/Z3Y036WKLyLE4b8HEweUFeM8ciDyWTxa
6Gaaa45TeB6wQ6xB0IHr/3P2yUlc3OsS5d691byjeuzvFZJ/qV6yKueUJE3YIxkm
--0000000000005b4b1b05f573296e--
