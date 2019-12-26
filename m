Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3ADC2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1842075E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ImwoPUCu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfLZLNw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:13:52 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:42515 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZLNw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:13:52 -0500
Received: by mail-wr1-f44.google.com with SMTP id q6so23356466wro.9
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uhHoCmia3GUXhRRQ8erl5AeLFRAsPlYDYhiAa1XsSQM=;
        b=ImwoPUCueFyz0XOkbUPquVBKfHXn1oUZjU975390ONq/fLphECW+nLVW73Xwh8xSki
         ehCQmRGt6NZmzPHl1/w6zTP3uVmjN+AH9vPxnPHOQDH9hyiAs04eWmZMfr5KMxobljF2
         2LKH28/VsySY6riBaG8ea4CXRyzIUkBT0aO+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uhHoCmia3GUXhRRQ8erl5AeLFRAsPlYDYhiAa1XsSQM=;
        b=MlpJ/raxUicCx4cflvYMPgr/XYww9BUUg4keEzjyio0ZTMTzHH6e63QDSTKT+KEDge
         3gWMvT99CsRwDT3q3JMMj9t63Y7eOKXvaBM5MIMlG/C/vLHJWM3tTyC7YTJvixFWR29Q
         bcJnHQM4f2diBpeRbEjKlVQgplGQHxtiHE2Z198HiO7k8pW2gFWSTua1jssRocdEO+U7
         AEQBhl0ceDksroDzG6KLSdRGEmOoH4PafSxM3EbQJYGrwgbhJSxEf6T9U0ZNq/t7Q4KR
         Z8g2i1h0wsZi5G8erE3/jc8MNDpoBzSPwW5zkz7fMiSFN37/LlOyozHYdPNq1AObfCIx
         NR+A==
X-Gm-Message-State: APjAAAWnzyanIqlOZLWvYVif6rZ/oQ4oRfv6aUJ/nqfOSTdDiSbi40IT
        rNpGwO9FAKwnd5TBLZp0GXEpLW7yo6AOknV+TJGTvrftof+agjrFmsCfZ7lEznwsOTRFN+NL633
        OvOf7Ny6Os7j4BSpsCQNhAJLA/C+aQkw+o2lwi6VagIYsFY/ya0Q2HYDQiCvAtGDNamNy23hzH6
        eIa2R37S4d
X-Google-Smtp-Source: APXvYqw9lJWpgDA3EptodCXc5pgdqcW18tY3gHifxCNNu+0lynQEDFlAA4T6hVlODZcL5zEzNlBFxw==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr45027526wrm.284.1577358829700;
        Thu, 26 Dec 2019 03:13:49 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:13:48 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 01/10] mpt3sas: Update MPI Headers to v02.00.57
Date:   Thu, 26 Dec 2019 06:13:24 -0500
Message-Id: <20191226111333.26131-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
References: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update MPI Headers to version 02.00.57.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2.h       |  6 +++++-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h  | 19 +++++++++++++++----
 drivers/scsi/mpt3sas/mpi/mpi2_image.h |  7 +++++++
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h   |  8 +++++++-
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/mpi/mpi2.h
index 18b1e31..ed3923f 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
@@ -122,6 +122,9 @@
  * 08-28-18  02.00.53  Bumped MPI2_HEADER_VERSION_UNIT.
  *                     Added MPI2_IOCSTATUS_FAILURE
  * 12-17-18  02.00.54  Bumped MPI2_HEADER_VERSION_UNIT
+ * 06-24-19  02.00.55  Bumped MPI2_HEADER_VERSION_UNIT
+ * 08-01-19  02.00.56  Bumped MPI2_HEADER_VERSION_UNIT
+ * 10-02-19  02.00.57  Bumped MPI2_HEADER_VERSION_UNIT
  *  --------------------------------------------------------------------------
  */
 
@@ -162,7 +165,7 @@
 
 
 /* Unit and Dev versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x36)
+#define MPI2_HEADER_VERSION_UNIT            (0x39)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
@@ -181,6 +184,7 @@
 #define MPI2_IOC_STATE_READY               (0x10000000)
 #define MPI2_IOC_STATE_OPERATIONAL         (0x20000000)
 #define MPI2_IOC_STATE_FAULT               (0x40000000)
+#define MPI2_IOC_STATE_COREDUMP            (0x50000000)
 
 #define MPI2_IOC_STATE_MASK                (0xF0000000)
 #define MPI2_IOC_STATE_SHIFT               (28)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 3a6871a..43a3bf8 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -249,6 +249,8 @@
  * 08-28-18  02.00.46  Added NVMs Write Cache flag to IOUnitPage1
  *                     Added DMDReport Delay Time defines to PCIeIOUnitPage1
  * 12-17-18  02.00.47  Swap locations of Slotx2 and Slotx4 in ManPage 7.
+ * 08-01-19  02.00.49  Add MPI26_MANPAGE7_FLAG_X2_X4_SLOT_INFO_VALID
+ *                     Add MPI26_IOUNITPAGE1_NVME_WRCACHE_SHIFT
  */
 
 #ifndef MPI2_CNFG_H
@@ -891,6 +893,8 @@ typedef struct _MPI2_CONFIG_PAGE_MAN_7 {
 #define MPI2_MANPAGE7_FLAG_EVENTREPLAY_SLOT_ORDER       (0x00000002)
 #define MPI2_MANPAGE7_FLAG_USE_SLOT_INFO                (0x00000001)
 
+#define MPI26_MANPAGE7_FLAG_CONN_LANE_USE_PINOUT        (0x00000020)
+#define MPI26_MANPAGE7_FLAG_X2_X4_SLOT_INFO_VALID       (0x00000010)
 
 /*
  *Generic structure to use for product-specific manufacturing pages
@@ -962,9 +966,10 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
 
 /* IO Unit Page 1 Flags defines */
 #define MPI26_IOUNITPAGE1_NVME_WRCACHE_MASK             (0x00030000)
-#define MPI26_IOUNITPAGE1_NVME_WRCACHE_ENABLE           (0x00000000)
-#define MPI26_IOUNITPAGE1_NVME_WRCACHE_DISABLE          (0x00010000)
-#define MPI26_IOUNITPAGE1_NVME_WRCACHE_NO_CHANGE        (0x00020000)
+#define MPI26_IOUNITPAGE1_NVME_WRCACHE_SHIFT            (16)
+#define MPI26_IOUNITPAGE1_NVME_WRCACHE_NO_CHANGE        (0x00000000)
+#define MPI26_IOUNITPAGE1_NVME_WRCACHE_ENABLE           (0x00010000)
+#define MPI26_IOUNITPAGE1_NVME_WRCACHE_DISABLE          (0x00020000)
 #define MPI2_IOUNITPAGE1_ATA_SECURITY_FREEZE_LOCK       (0x00004000)
 #define MPI25_IOUNITPAGE1_NEW_DEVICE_FAST_PATH_DISABLE  (0x00002000)
 #define MPI25_IOUNITPAGE1_DISABLE_FAST_PATH             (0x00001000)
@@ -3931,7 +3936,13 @@ typedef struct _MPI26_CONFIG_PAGE_PCIEDEV_2 {
 	U32	MaximumDataTransferSize;	/*0x0C */
 	U32	Capabilities;		/*0x10 */
 	U16	NOIOB;		/* 0x14 */
-	U16	Reserved2;		/* 0x16 */
+	U16     ShutdownLatency;        /* 0x16 */
+	U16     VendorID;               /* 0x18 */
+	U16     DeviceID;               /* 0x1A */
+	U16     SubsystemVendorID;      /* 0x1C */
+	U16     SubsystemID;            /* 0x1E */
+	U8      RevisionID;             /* 0x20 */
+	U8      Reserved21[3];          /* 0x21 */
 } MPI26_CONFIG_PAGE_PCIEDEV_2, *PTR_MPI26_CONFIG_PAGE_PCIEDEV_2,
 	Mpi26PCIeDevicePage2_t, *pMpi26PCIeDevicePage2_t;
 
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_image.h b/drivers/scsi/mpt3sas/mpi/mpi2_image.h
index a3f6778..33b9c3a 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_image.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_image.h
@@ -19,6 +19,10 @@
  * 09-07-18  02.06.03  Added MPI26_EVENT_PCIE_TOPO_PI_16_LANES
  * 12-17-18  02.06.04  Addd MPI2_EXT_IMAGE_TYPE_PBLP
  *			Shorten some defines to be compatible with DOS
+ * 06-24-19  02.06.05  Whitespace adjustments to help with identifier
+ *			checking tool.
+ * 10-02-19  02.06.06  Added MPI26_IMAGE_HEADER_SIG1_COREDUMP
+ *                     Added MPI2_FLASH_REGION_COREDUMP
  */
 #ifndef MPI2_IMAGE_H
 #define MPI2_IMAGE_H
@@ -213,6 +217,8 @@ typedef struct _MPI26_COMPONENT_IMAGE_HEADER {
 #define MPI26_IMAGE_HEADER_SIG1_NVDATA                   (0x5444564E)
 #define MPI26_IMAGE_HEADER_SIG1_GAS_GAUGE                (0x20534147)
 #define MPI26_IMAGE_HEADER_SIG1_PBLP                     (0x504C4250)
+/* little-endian "DUMP" */
+#define MPI26_IMAGE_HEADER_SIG1_COREDUMP                 (0x504D5544)
 
 /**** Definitions for Signature2 field ****/
 #define MPI26_IMAGE_HEADER_SIGNATURE2_VALUE                    (0x50584546)
@@ -359,6 +365,7 @@ typedef struct _MPI2_FLASH_LAYOUT_DATA {
 #define MPI2_FLASH_REGION_MR_NVDATA             (0x14)
 #define MPI2_FLASH_REGION_CPLD                  (0x15)
 #define MPI2_FLASH_REGION_PSOC                  (0x16)
+#define MPI2_FLASH_REGION_COREDUMP              (0x17)
 
 /*ImageRevision */
 #define MPI2_FLASH_LAYOUT_IMAGE_REVISION        (0x00)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
index 68ea408..e83c7c5 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
@@ -175,6 +175,10 @@
  *                     Moved FW image definitions ionto new mpi2_image,h
  * 08-14-18   02.00.36 Fixed definition of MPI2_FW_DOWNLOAD_ITYPE_PSOC (0x16)
  * 09-07-18   02.00.37 Added MPI26_EVENT_PCIE_TOPO_PI_16_LANES
+ * 10-02-19   02.00.38 Added MPI26_IOCINIT_CFGFLAGS_COREDUMP_ENABLE
+ *                     Added MPI26_IOCFACTS_CAPABILITY_COREDUMP_ENABLED
+ *                     Added MPI2_FW_DOWNLOAD_ITYPE_COREDUMP
+ *                     Added MPI2_FW_UPLOAD_ITYPE_COREDUMP
  * --------------------------------------------------------------------------
  */
 
@@ -248,6 +252,7 @@ typedef struct _MPI2_IOC_INIT_REQUEST {
 
 /*ConfigurationFlags */
 #define MPI26_IOCINIT_CFGFLAGS_NVME_SGL_FORMAT  (0x0001)
+#define MPI26_IOCINIT_CFGFLAGS_COREDUMP_ENABLE  (0x0002)
 
 /*minimum depth for a Reply Descriptor Post Queue */
 #define MPI2_RDPQ_DEPTH_MIN                     (16)
@@ -377,6 +382,7 @@ typedef struct _MPI2_IOC_FACTS_REPLY {
 /*ProductID field uses MPI2_FW_HEADER_PID_ */
 
 /*IOCCapabilities */
+#define MPI26_IOCFACTS_CAPABILITY_COREDUMP_ENABLED      (0x00200000)
 #define MPI26_IOCFACTS_CAPABILITY_PCIE_SRIOV            (0x00100000)
 #define MPI26_IOCFACTS_CAPABILITY_ATOMIC_REQ            (0x00080000)
 #define MPI2_IOCFACTS_CAPABILITY_RDPQ_ARRAY_CAPABLE     (0x00040000)
@@ -1458,8 +1464,8 @@ typedef struct _MPI2_FW_DOWNLOAD_REQUEST {
 /*MPI v2.6 and newer */
 #define MPI2_FW_DOWNLOAD_ITYPE_CPLD                 (0x15)
 #define MPI2_FW_DOWNLOAD_ITYPE_PSOC                 (0x16)
+#define MPI2_FW_DOWNLOAD_ITYPE_COREDUMP             (0x17)
 #define MPI2_FW_DOWNLOAD_ITYPE_MIN_PRODUCT_SPECIFIC (0xF0)
-#define MPI2_FW_DOWNLOAD_ITYPE_TERMINATE            (0xFF)
 
 /*MPI v2.0 FWDownload TransactionContext Element */
 typedef struct _MPI2_FW_DOWNLOAD_TCSGE {
-- 
2.18.1

