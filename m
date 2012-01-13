From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/6] mpt2sas: Do not check DIF for unwritten blocks
Date: Fri, 13 Jan 2012 17:43:03 -0500
Message-ID: <1326494586-17360-4-git-send-email-martin.petersen@oracle.com>
References: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:40336 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab2AMWnd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2012 17:43:33 -0500
In-Reply-To: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nagalakshmi.Nandigama@lsi.com

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Blocks that have never been written contain all ones in the protection
information. When reading, a target device will disable checking for any
block whose application tag contains 0xFFFF.

Some MPT adapters, however, enable checking for all blocks by
default. This causes reads to previously unwritten sectors to fail.

Tweak the relevant bit in the MPT configuration page that causes the HBA
to disable PI checking when a received app tag contains 0xFFFF.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Nagalakshmi.Nandigama@lsi.com
---
 drivers/scsi/mpt2sas/mpt2sas_base.c   |   15 +++++++
 drivers/scsi/mpt2sas/mpt2sas_base.h   |   19 +++++++++
 drivers/scsi/mpt2sas/mpt2sas_config.c |   72 +++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 0b2c955..a7f90e9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2269,6 +2269,21 @@ _base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
 	if (ioc->ir_firmware)
 		mpt2sas_config_get_manufacturing_pg10(ioc, &mpi_reply,
 		    &ioc->manu_pg10);
+
+	/*
+	 * Ensure correct T10 PI operation if vendor left EEDPTagMode
+	 * flag unset in NVDATA.
+	 */
+	mpt2sas_config_get_manufacturing_pg11(ioc, &mpi_reply, &ioc->manu_pg11);
+	if (ioc->manu_pg11.EEDPTagMode == 0) {
+		printk(KERN_ERR "%s: overriding NVDATA EEDPTagMode setting\n",
+		       ioc->name);
+		ioc->manu_pg11.EEDPTagMode &= ~0x3;
+		ioc->manu_pg11.EEDPTagMode |= 0x1;
+		mpt2sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
+						      &ioc->manu_pg11);
+	}
+
 	mpt2sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
 	mpt2sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
 	mpt2sas_config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_pg8);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index c7459fd..f68195f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -296,6 +296,19 @@ typedef struct _MPI2_CONFIG_PAGE_MAN_10 {
 #define MFG_PAGE10_EXPOSE_ALL_DISKS	(0x01)
 #define MFG_PAGE10_HIDE_IF_VOL_PRESENT	(0x02)
 
+/* Miscellaneous options */
+typedef struct _MPI2_CONFIG_PAGE_MAN_11 {
+    MPI2_CONFIG_PAGE_HEADER Header;                                 /* 00h */
+    U32                     Reserved1;                              /* 04h */
+    U8                      Reserved2;                              /* 08h */
+    U8                      EEDPTagMode;                            /* 09h */
+    U8                      Reserved3;                              /* 0Ah */
+    U8                      Reserved4;                              /* 0Bh */
+    U32                     Reserved5[23];                          /* 0Ch-60h*/
+} MPI2_CONFIG_PAGE_MAN_11,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_11,
+  Mpi2ManufacturingPage11_t, MPI2_POINTER pMpi2ManufacturingPage11_t;
+
 
 struct MPT2SAS_DEVICE {
 	struct MPT2SAS_TARGET *sas_target;
@@ -706,6 +719,7 @@ typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(struct MPT2SAS_ADAPTER *ioc);
  * @pfacts: static port facts data
  * @manu_pg0: static manufacturing page 0
  * @manu_pg10: static manufacturing page 10
+ * @manu_pg11: static manufacturing page 11
  * @bios_pg2: static bios page 2
  * @bios_pg3: static bios page 3
  * @ioc_pg8: static ioc page 8
@@ -978,6 +992,7 @@ struct MPT2SAS_ADAPTER {
 	u8		diag_buffer_status[MPI2_DIAG_BUF_TYPE_COUNT];
 	u32		unique_id[MPI2_DIAG_BUF_TYPE_COUNT];
 	Mpi2ManufacturingPage10_t manu_pg10;
+	Mpi2ManufacturingPage11_t manu_pg11;
 	u32		product_specific[MPI2_DIAG_BUF_TYPE_COUNT][23];
 	u32		diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
 	u32		ring_buffer_offset;
@@ -1078,6 +1093,10 @@ int mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
     Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage0_t *config_page);
 int mpt2sas_config_get_manufacturing_pg10(struct MPT2SAS_ADAPTER *ioc,
     Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage10_t *config_page);
+int mpt2sas_config_get_manufacturing_pg11(struct MPT2SAS_ADAPTER *ioc,
+    Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage11_t *config_page);
+int mpt2sas_config_set_manufacturing_pg11(struct MPT2SAS_ADAPTER *ioc,
+    Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage11_t *config_page);
 int mpt2sas_config_get_bios_pg2(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
     *mpi_reply, Mpi2BiosPage2_t *config_page);
 int mpt2sas_config_get_bios_pg3(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigReply_t
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 36ea0b2..fb737bb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -503,6 +503,78 @@ mpt2sas_config_get_manufacturing_pg10(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
+ * mpt2sas_config_get_manufacturing_pg11 - obtain manufacturing page 11
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt2sas_config_get_manufacturing_pg11(struct MPT2SAS_ADAPTER *ioc,
+    Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage11_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_MANUFACTURING;
+	mpi_request.Header.PageNumber = 11;
+	mpi_request.Header.PageVersion = MPI2_MANUFACTURING0_PAGEVERSION;
+	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+ out:
+	return r;
+}
+
+/**
+ * mpt2sas_config_set_manufacturing_pg11 - set manufacturing page 11
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt2sas_config_set_manufacturing_pg11(struct MPT2SAS_ADAPTER *ioc,
+    Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage11_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_MANUFACTURING;
+	mpi_request.Header.PageNumber = 11;
+	mpi_request.Header.PageVersion = MPI2_MANUFACTURING0_PAGEVERSION;
+	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+ out:
+	return r;
+}
+
+/**
  * mpt2sas_config_get_bios_pg2 - obtain bios page 2
  * @ioc: per adapter object
  * @mpi_reply: reply mf payload returned from firmware
-- 
1.7.8.3.21.gab8a7

