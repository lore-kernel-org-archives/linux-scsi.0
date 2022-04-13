Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF02C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 14:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiDMPBW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 11:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiDMPBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 11:01:20 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5575564703
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 07:58:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso2506322pjj.2
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 07:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=6ApE28MFyJHEia5FCWLzAAXg30e7YyRoKizWNF1SnY8=;
        b=Vrteli6V8GNoIO7UWGBk1TM/qmRLv/YwflBLObyIv2nr18IHdO5BBppTWsRmPZvz9x
         q8TXWr7tMZq+Sf6HSMa/NCCmMmG1bNkCr5y6egGI5A5gQADLI+NcYPR9HGNIudygAxRo
         /Ry6BwTjheXO4wqQeBj2/HaN+TAYolPjRyqd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=6ApE28MFyJHEia5FCWLzAAXg30e7YyRoKizWNF1SnY8=;
        b=eF+r7Em7fc+vKW5oePHSIRTZ4rQTPSvpzMvGg7XvWZXQCn3s+E/eYhOYKcmSen+QjL
         3dz4SwiAn0SauLriVeivczl0iXv3YF+MoVtJRmK8E3gtXQUserTn8zCvPtdeI5aWY0tO
         pCs+s4GQHzbbfqExV0GOZW20KEhjGS+pkjciZ3W7EumVjAKNm96ANkFv/2W3/GDoqIzI
         VEKQPQufx656sq/8Bqu6wKhmQwkE43P2/72oNChYXGS6ri+NnD0Ec6IXaxxqiSa79uS0
         UiG5SXFmdcRTC4Y+VydMOXgUvBsECeNj1ae4x2ZUyHzVQpC4qjBrOzLnIj+aiSNoYlAI
         pOQg==
X-Gm-Message-State: AOAM531IKaUpWdY7nhWJzMQkhl8eS/4Fe6gRxZlyL9f63eWwzWdqWkj2
        2sQUvorvYMEopSiBVcYAWFHQtFeF6hiBlpfKULsFPt8SzwyyNnx47AQMwCdQxRhMUUo9UgcMQ7n
        b85aGBUOi9M0MzEtLBToy5PFjNYZAaTNXvWH1mRP9FrMpcP9zg65xq2FKuByxXHpVJ7NzZJAMhN
        d0srZ9lRc=
X-Google-Smtp-Source: ABdhPJzMGSoS5rP+5K+OGdPIhWaPSHXo9WM9wr+LmidgNB7t31B3lGKLhFk957Mj8DnRaBhwkSC2wA==
X-Received: by 2002:a17:90b:4a84:b0:1cb:29bd:db3e with SMTP id lp4-20020a17090b4a8400b001cb29bddb3emr11123450pjb.112.1649861938447;
        Wed, 13 Apr 2022 07:58:58 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e14-20020aa78c4e000000b00506475da4cesm2488379pfd.49.2022.04.13.07.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:58:44 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        hare@suse.de, himanshu.madhani@oracle.com,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v4 3/8] mpi3mr: move data structures/definitions from MPI headers to uapi header
Date:   Wed, 13 Apr 2022 10:56:47 -0400
Message-Id: <20220413145652.112271-4-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220413145652.112271-1-sumit.saxena@broadcom.com>
References: <20220413145652.112271-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000cd09d605dc8a6a46"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000cd09d605dc8a6a46
Content-Transfer-Encoding: 8bit

This patch moves the data structures/definitions which are used by
user space applications from MPI headers to uapi/scsi/scsi_bsg_mpi3mr.h

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_init.h |  53 ----------
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h  |  28 ------
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h  |  31 +-----
 drivers/scsi/mpi3mr/mpi3mr.h         |   1 +
 include/uapi/scsi/scsi_bsg_mpi3mr.h  | 139 +++++++++++++++++++++++++++
 5 files changed, 141 insertions(+), 111 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
index e2e8b22e9122..aac11c58cca9 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -115,57 +115,4 @@ struct mpi3_scsi_io_reply {
 #define MPI3_SCSI_RSP_ARI0_MASK                 (0xff000000)
 #define MPI3_SCSI_RSP_ARI0_SHIFT                (24)
 #define MPI3_SCSI_TASKTAG_UNKNOWN               (0xffff)
-struct mpi3_scsi_task_mgmt_request {
-	__le16                     host_tag;
-	u8                         ioc_use_only02;
-	u8                         function;
-	__le16                     ioc_use_only04;
-	u8                         ioc_use_only06;
-	u8                         msg_flags;
-	__le16                     change_count;
-	__le16                     dev_handle;
-	__le16                     task_host_tag;
-	u8                         task_type;
-	u8                         reserved0f;
-	__le16                     task_request_queue_id;
-	__le16                     reserved12;
-	__le32                     reserved14;
-	u8                         lun[8];
-};
-
-#define MPI3_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU      (0x08)
-#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK               (0x01)
-#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK_SET           (0x02)
-#define MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET             (0x03)
-#define MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET       (0x05)
-#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET           (0x06)
-#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK               (0x07)
-#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_ACA                (0x08)
-#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK_SET           (0x09)
-#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_ASYNC_EVENT        (0x0a)
-#define MPI3_SCSITASKMGMT_TASKTYPE_I_T_NEXUS_RESET          (0x0b)
-struct mpi3_scsi_task_mgmt_reply {
-	__le16                     host_tag;
-	u8                         ioc_use_only02;
-	u8                         function;
-	__le16                     ioc_use_only04;
-	u8                         ioc_use_only06;
-	u8                         msg_flags;
-	__le16                     ioc_use_only08;
-	__le16                     ioc_status;
-	__le32                     ioc_log_info;
-	__le32                     termination_count;
-	__le32                     response_data;
-	__le32                     reserved18;
-};
-
-#define MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE                (0x00)
-#define MPI3_SCSITASKMGMT_RSPCODE_INVALID_FRAME              (0x02)
-#define MPI3_SCSITASKMGMT_RSPCODE_TM_FUNCTION_NOT_SUPPORTED  (0x04)
-#define MPI3_SCSITASKMGMT_RSPCODE_TM_FAILED                  (0x05)
-#define MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED               (0x08)
-#define MPI3_SCSITASKMGMT_RSPCODE_TM_INVALID_LUN             (0x09)
-#define MPI3_SCSITASKMGMT_RSPCODE_TM_OVERLAPPED_TAG          (0x0a)
-#define MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC           (0x80)
-#define MPI3_SCSITASKMGMT_RSPCODE_TM_NVME_DENIED             (0x81)
 #endif
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index 633037dc7012..7b306580d30f 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -38,17 +38,6 @@ struct mpi3_ioc_init_request {
 #define MPI3_WHOINIT_ROM_BIOS                            (0x02)
 #define MPI3_WHOINIT_HOST_DRIVER                         (0x03)
 #define MPI3_WHOINIT_MANUFACTURER                        (0x04)
-struct mpi3_driver_info_layout {
-	__le32             information_length;
-	u8                 driver_signature[12];
-	u8                 os_name[16];
-	u8                 os_version[12];
-	u8                 driver_name[20];
-	u8                 driver_version[32];
-	u8                 driver_release_date[20];
-	__le32             driver_capabilities;
-};
-
 struct mpi3_ioc_facts_request {
 	__le16                 host_tag;
 	u8                     ioc_use_only02;
@@ -647,23 +636,6 @@ struct mpi3_event_data_diag_buffer_status_change {
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RELEASED             (0x01)
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_PAUSED               (0x02)
 #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RESUMED              (0x03)
-#define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
-#define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
-#define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)
-#define MPI3_PEL_LOCALE_FLAGS_CONFIGURATION             (0x0040)
-#define MPI3_PEL_LOCALE_FLAGS_CONTROLER                 (0x0020)
-#define MPI3_PEL_LOCALE_FLAGS_SAS                       (0x0010)
-#define MPI3_PEL_LOCALE_FLAGS_EPACK                     (0x0008)
-#define MPI3_PEL_LOCALE_FLAGS_ENCLOSURE                 (0x0004)
-#define MPI3_PEL_LOCALE_FLAGS_PD                        (0x0002)
-#define MPI3_PEL_LOCALE_FLAGS_VD                        (0x0001)
-#define MPI3_PEL_CLASS_DEBUG                            (0x00)
-#define MPI3_PEL_CLASS_PROGRESS                         (0x01)
-#define MPI3_PEL_CLASS_INFORMATIONAL                    (0x02)
-#define MPI3_PEL_CLASS_WARNING                          (0x03)
-#define MPI3_PEL_CLASS_CRITICAL                         (0x04)
-#define MPI3_PEL_CLASS_FATAL                            (0x05)
-#define MPI3_PEL_CLASS_FAULT                            (0x06)
 #define MPI3_PEL_CLEARTYPE_CLEAR                        (0x00)
 #define MPI3_PEL_WAITTIME_INFINITE_WAIT                 (0x00)
 #define MPI3_PEL_ACTION_GET_SEQNUM                      (0x01)
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
index 77270f577f90..901dbd788940 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -5,24 +5,6 @@
  */
 #ifndef MPI30_PCI_H
 #define MPI30_PCI_H     1
-#ifndef MPI3_NVME_ENCAP_CMD_MAX
-#define MPI3_NVME_ENCAP_CMD_MAX               (1)
-#endif
-struct mpi3_nvme_encapsulated_request {
-	__le16                     host_tag;
-	u8                         ioc_use_only02;
-	u8                         function;
-	__le16                     ioc_use_only04;
-	u8                         ioc_use_only06;
-	u8                         msg_flags;
-	__le16                     change_count;
-	__le16                     dev_handle;
-	__le16                     encapsulated_command_length;
-	__le16                     flags;
-	__le32                     data_length;
-	__le32                     reserved14[3];
-	__le32                     command[MPI3_NVME_ENCAP_CMD_MAX];
-};
 
 #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_MASK      (0x0002)
 #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_FAIL_ONLY (0x0000)
@@ -30,16 +12,5 @@ struct mpi3_nvme_encapsulated_request {
 #define MPI3_NVME_FLAGS_SUBMISSIONQ_MASK                (0x0001)
 #define MPI3_NVME_FLAGS_SUBMISSIONQ_IO                  (0x0000)
 #define MPI3_NVME_FLAGS_SUBMISSIONQ_ADMIN               (0x0001)
-struct mpi3_nvme_encapsulated_error_reply {
-	__le16                     host_tag;
-	u8                         ioc_use_only02;
-	u8                         function;
-	__le16                     ioc_use_only04;
-	u8                         ioc_use_only06;
-	u8                         msg_flags;
-	__le16                     ioc_use_only08;
-	__le16                     ioc_status;
-	__le32                     ioc_log_info;
-	__le32                     nvme_completion_entry[4];
-};
+
 #endif
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 877b0925dbc5..fb05aab48aa7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -38,6 +38,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <uapi/scsi/scsi_bsg_mpi3mr.h>
 
 #include "mpi/mpi30_transport.h"
 #include "mpi/mpi30_cnfg.h"
diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi_bsg_mpi3mr.h
index 2319fc48ed78..870e6d87dd03 100644
--- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
+++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
@@ -81,6 +81,28 @@ enum command {
 	MPI3MR_MPT_CMD = 2,
 };
 
+/**
+ * struct mpi3_driver_info_layout - Information about driver
+ *
+ * @information_length: Length of this structure in bytes
+ * @driver_signature: Driver Vendor name
+ * @os_name: Operating System Name
+ * @driver_name: Driver name
+ * @driver_version: Driver version
+ * @driver_release_date: Driver release date
+ * @driver_capabilities: Driver capabilities
+ */
+struct mpi3_driver_info_layout {
+	__le32             information_length;
+	u8                 driver_signature[12];
+	u8                 os_name[16];
+	u8                 os_version[12];
+	u8                 driver_name[20];
+	u8                 driver_version[32];
+	u8                 driver_release_date[20];
+	__le32             driver_capabilities;
+};
+
 /**
  * struct mpi3mr_bsg_in_adpinfo - Adapter information request
  * data returned by the driver.
@@ -430,4 +452,121 @@ struct mpi3mr_bsg_packet {
 		struct mpi3mr_bsg_mptcmd mptcmd;
 	} cmd;
 };
+
+
+/* MPI3: NVMe Encasulation related definitions */
+#ifndef MPI3_NVME_ENCAP_CMD_MAX
+#define MPI3_NVME_ENCAP_CMD_MAX               (1)
+#endif
+
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
+	__le32                     data_length;
+	__le32                     reserved14[3];
+	__le32                     command[MPI3_NVME_ENCAP_CMD_MAX];
+};
+
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
+
+/* MPI3: task management related definitions */
+struct mpi3_scsi_task_mgmt_request {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     change_count;
+	__le16                     dev_handle;
+	__le16                     task_host_tag;
+	u8                         task_type;
+	u8                         reserved0f;
+	__le16                     task_request_queue_id;
+	__le16                     reserved12;
+	__le32                     reserved14;
+	u8                         lun[8];
+};
+
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
+struct mpi3_scsi_task_mgmt_reply {
+	__le16                     host_tag;
+	u8                         ioc_use_only02;
+	u8                         function;
+	__le16                     ioc_use_only04;
+	u8                         ioc_use_only06;
+	u8                         msg_flags;
+	__le16                     ioc_use_only08;
+	__le16                     ioc_status;
+	__le32                     ioc_log_info;
+	__le32                     termination_count;
+	__le32                     response_data;
+	__le32                     reserved18;
+};
+
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE                (0x00)
+#define MPI3_SCSITASKMGMT_RSPCODE_INVALID_FRAME              (0x02)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_FUNCTION_NOT_SUPPORTED  (0x04)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_FAILED                  (0x05)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED               (0x08)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_INVALID_LUN             (0x09)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_OVERLAPPED_TAG          (0x0a)
+#define MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC           (0x80)
+#define MPI3_SCSITASKMGMT_RSPCODE_TM_NVME_DENIED             (0x81)
+
+/* MPI3: PEL related definitions */
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
+
+/* MPI3: Function definitions */
+#define MPI3_BSG_FUNCTION_MGMT_PASSTHROUGH              (0x0a)
+#define MPI3_BSG_FUNCTION_SCSI_IO                       (0x20)
+#define MPI3_BSG_FUNCTION_SCSI_TASK_MGMT                (0x21)
+#define MPI3_BSG_FUNCTION_SMP_PASSTHROUGH               (0x22)
+#define MPI3_BSG_FUNCTION_NVME_ENCAPSULATED             (0x24)
+
 #endif
-- 
2.27.0


--000000000000cd09d605dc8a6a46
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
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
XzCCBUwwggQ0oAMCAQICDChBOkGaEPGP0mg3WjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMzAxMzJaFw0yMjA5MTUxMTUxMTRaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFN1bWl0IFNheGVuYTEoMCYGCSqGSIb3DQEJ
ARYZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOF5aZbhKAGhO2KcMnxG7J5OqnrzKx30t4wT0WY/866w1NOgOCYXWCq6tm3cBUYkGV+47kUL
uSdVPhzDNe/yMoEuqDK9c7h2/xwLHYj8VInnXa5m9xvuldXZYQBiJx2goa6RRRmTNKesy+u5W/CN
hhy3/qf36UTobP4BfBsV7cnRZyGN2TYljb0nU60przTERky6gYtJ7LeUe00UNOduEeGcXFLAC+//
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIlpQQwjXvCvmWSVUOEE0poP40gnQNx3
9kAlT5xUtiyBMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQx
MzE0NTg1OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCxmvgVU3jQmKa47UlscOnF53a406ggKt6oUows+Noji3JlgIeP
uSyBDBYhZRRq3bmr0xXRuAeAASac6zRwfoUWq77IVDdLHmz/qaEnM6UI2jIkIBkboKg65hOPCVJt
tF1OKrUMNSeHw5JfzyogHh6peiImDNlzbaPl5kO63mIvS9p/wT2cvimzg/AgWlIPj19mJH51e3/3
lqrSgXxnVUPJjMHATeCEd6HF9wd12m5qbeDsbaMkzCi6g78qkWZiUPF3V6yRk/eAa00GWBye1yOj
uSxVzl9tT3fbFP2HR8V5rJEcUKq4NgDwKzBYTx4K6fnld6S1+OjqbLUxasSVUO6J
--000000000000cd09d605dc8a6a46--
