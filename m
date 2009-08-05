From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 7/11] mpt2sas: [Resend] Raid 10 Value is showing as Raid 1E in /va/log/messages
Date: Wed, 5 Aug 2009 11:44:21 +0530
Message-ID: <20090805061421.GH13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:51806 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbZHEGfZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 02:35:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Add support to obtain manufacturing page 10 at driver load time. The driver will display RAID10 string when the volume type is RAID1E,
when there is a even drive count, and the manufacturing page 10 GenericFlags0 field has bit 2 is set.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index f0ffbf6..86b737c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1482,6 +1482,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 	   (ioc->bios_pg3.BiosVersion & 0x0000FF00) >> 8,
 	    ioc->bios_pg3.BiosVersion & 0x000000FF);
 
+	_base_display_dell_branding(ioc);
+
 	printk(MPT2SAS_INFO_FMT "Protocol=(", ioc->name);
 
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
@@ -1494,8 +1496,6 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 		i++;
 	}
 
-	_base_display_dell_branding(ioc);
-
 	i = 0;
 	printk("), ");
 	printk("Capabilities=(");
@@ -1567,6 +1567,9 @@ _base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
 	u32 iounit_pg1_flags;
 
 	mpt2sas_config_get_manufacturing_pg0(ioc, &mpi_reply, &ioc->manu_pg0);
+	if (ioc->ir_firmware)
+		mpt2sas_config_get_manufacturing_pg10(ioc, &mpi_reply,
+		    &ioc->manu_pg10);
 	mpt2sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
 	mpt2sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
 	mpt2sas_config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_pg8);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 51962bd..a10c37b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -197,6 +197,38 @@ struct MPT2SAS_TARGET {
  * @block: device is in SDEV_BLOCK state
  * @tlr_snoop_check: flag used in determining whether to disable TLR
  */
+
+/* OEM Identifiers */
+#define MFG10_OEM_ID_INVALID                   (0x00000000)
+#define MFG10_OEM_ID_DELL                      (0x00000001)
+#define MFG10_OEM_ID_FSC                       (0x00000002)
+#define MFG10_OEM_ID_SUN                       (0x00000003)
+#define MFG10_OEM_ID_IBM                       (0x00000004)
+
+/* GENERIC Flags 0*/
+#define MFG10_GF0_OCE_DISABLED                 (0x00000001)
+#define MFG10_GF0_R1E_DRIVE_COUNT              (0x00000002)
+#define MFG10_GF0_R10_DISPLAY                  (0x00000004)
+#define MFG10_GF0_SSD_DATA_SCRUB_DISABLE       (0x00000008)
+#define MFG10_GF0_SINGLE_DRIVE_R0              (0x00000010)
+
+/* OEM Specific Flags will come from OEM specific header files */
+typedef struct _MPI2_CONFIG_PAGE_MAN_10 {
+    MPI2_CONFIG_PAGE_HEADER Header;                                 /* 00h */
+    U8                      OEMIdentifier;                          /* 04h */
+    U8                      Reserved1;                              /* 05h */
+    U16                     Reserved2;                              /* 08h */
+    U32                     Reserved3;                              /* 0Ch */
+    U32                     GenericFlags0;                          /* 10h */
+    U32                     GenericFlags1;                          /* 14h */
+    U32                     Reserved4;                              /* 18h */
+    U32                     OEMSpecificFlags0;                      /* 1Ch */
+    U32                     OEMSpecificFlags1;                      /* 20h */
+    U32                     Reserved5[18];                          /* 24h-60h*/
+} MPI2_CONFIG_PAGE_MAN_10,
+  MPI2_POINTER PTR_MPI2_CONFIG_PAGE_MAN_10,
+  Mpi2ManufacturingPage10_t, MPI2_POINTER pMpi2ManufacturingPage10_t;
+
 struct MPT2SAS_DEVICE {
 	struct MPT2SAS_TARGET *sas_target;
 	unsigned int	lun;
@@ -461,6 +493,7 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @facts: static facts data
  * @pfacts: static port facts data
  * @manu_pg0: static manufacturing page 0
+ * @manu_pg10: static manufacturing page 10
  * @bios_pg2: static bios page 2
  * @bios_pg3: static bios page 3
  * @ioc_pg8: static ioc page 8
@@ -663,6 +696,7 @@ struct MPT2SAS_ADAPTER {
 	dma_addr_t	diag_buffer_dma[MPI2_DIAG_BUF_TYPE_COUNT];
 	u8		diag_buffer_status[MPI2_DIAG_BUF_TYPE_COUNT];
 	u32		unique_id[MPI2_DIAG_BUF_TYPE_COUNT];
+	Mpi2ManufacturingPage10_t manu_pg10;
 	u32		product_specific[MPI2_DIAG_BUF_TYPE_COUNT][23];
 	u32		diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
 };
@@ -774,7 +808,6 @@ int mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
     u16 *volume_handle);
 int mpt2sas_config_get_volume_wwid(struct MPT2SAS_ADAPTER *ioc, u16 volume_handle,
     u64 *wwid);
-
 /* ctl shared API */
 extern struct device_attribute *mpt2sas_host_attrs[];
 extern struct device_attribute *mpt2sas_dev_attrs[];
@@ -802,3 +835,5 @@ extern struct sas_function_template mpt2sas_transport_functions;
 extern struct scsi_transport_template *mpt2sas_transport_template;
 
 #endif /* MPT2SAS_BASE_H_INCLUDED */
+int mpt2sas_config_get_manufacturing_pg10(struct MPT2SAS_ADAPTER *ioc,
+    Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage10_t *config_page);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 3a03fec..e9665ef 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -419,6 +419,69 @@ mpt2sas_config_get_manufacturing_pg0(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
+ * mpt2sas_config_get_manufacturing_pg10 - obtain manufacturing page 10
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt2sas_config_get_manufacturing_pg10(struct MPT2SAS_ADAPTER *ioc,
+    Mpi2ConfigReply_t *mpi_reply, Mpi2ManufacturingPage10_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+	struct config_request mem;
+
+	mutex_lock(&ioc->config_cmds.mutex);
+	memset(config_page, 0, sizeof(Mpi2ManufacturingPage10_t));
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_MANUFACTURING;
+	mpi_request.Header.PageNumber = 10;
+	mpi_request.Header.PageVersion = MPI2_MANUFACTURING0_PAGEVERSION;
+	mpt2sas_base_build_zero_len_sge(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	mpi_request.Header.PageVersion = mpi_reply->Header.PageVersion;
+	mpi_request.Header.PageNumber = mpi_reply->Header.PageNumber;
+	mpi_request.Header.PageType = mpi_reply->Header.PageType;
+	mpi_request.Header.PageLength = mpi_reply->Header.PageLength;
+	mem.config_page_sz = le16_to_cpu(mpi_reply->Header.PageLength) * 4;
+	if (mem.config_page_sz > ioc->config_page_sz) {
+		r = _config_alloc_config_dma_memory(ioc, &mem);
+		if (r)
+			goto out;
+	} else {
+		mem.config_page_dma = ioc->config_page_dma;
+		mem.config_page = ioc->config_page;
+	}
+	ioc->base_add_sg_single(&mpi_request.PageBufferSGE,
+	    MPT2_CONFIG_COMMON_SGLFLAGS | mem.config_page_sz,
+	    mem.config_page_dma);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	if (!r)
+		memcpy(config_page, mem.config_page,
+		    min_t(u16, mem.config_page_sz,
+		    sizeof(Mpi2ManufacturingPage10_t)));
+
+	if (mem.config_page_sz > ioc->config_page_sz)
+		_config_free_config_dma_memory(ioc, &mem);
+
+ out:
+	mutex_unlock(&ioc->config_cmds.mutex);
+	return r;
+}
+
+/**
  * mpt2sas_config_get_bios_pg2 - obtain bios page 2
  * @ioc: per adapter object
  * @mpi_reply: reply mf payload returned from firmware
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index fba2e71..cf58d69 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1501,7 +1501,13 @@ _scsih_slave_configure(struct scsi_device *sdev)
 			break;
 		case MPI2_RAID_VOL_TYPE_RAID1E:
 			qdepth = MPT2SAS_RAID_QUEUE_DEPTH;
-			r_level = "RAID1E";
+			if (ioc->manu_pg10.OEMIdentifier &&
+			    (ioc->manu_pg10.GenericFlags0 &
+			    MFG10_GF0_R10_DISPLAY) &&
+			    !(raid_device->num_pds % 2))
+				r_level = "RAID10";
+			else
+				r_level = "RAID1E";
 			break;
 		case MPI2_RAID_VOL_TYPE_RAID1:
 			qdepth = MPT2SAS_RAID_QUEUE_DEPTH;
