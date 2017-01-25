From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 05/24] aacraid: Retrieve and update the device types
Date: Wed, 25 Jan 2017 10:00:52 -0800
Message-ID: <20170125180111.25401-6-RaghavaAditya.Renukunta@microsemi.com>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0077.outbound.protection.outlook.com ([104.47.32.77]:30160
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751861AbdAZAiG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 19:38:06 -0500
In-Reply-To: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Benesh@microsemi.com

This patch adds support to retrieve the type of each adapter connected
device. Applicable to HBA1000 and SmartIOC2000 products

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
 Changes in  V2:
  Fixed uninitialized return value

 drivers/scsi/aacraid/aachba.c  | 144 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/aacraid/aacraid.h |  60 ++++++++++++++++-
 2 files changed, 202 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 8a58b96..64cd4cb 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1509,11 +1509,141 @@ static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
 	return aac_scsi_32(fib, cmd);
 }
 
+/**
+ *	aac_update hba_map()-	update current hba map with data from FW
+ *	@dev:	aac_dev structure
+ *	@phys_luns: FW information from report phys luns
+ *
+ *	Update our hba map with the information gathered from the FW
+ */
+void aac_update_hba_map(struct aac_dev *dev,
+		struct aac_ciss_phys_luns_resp *phys_luns)
+{
+	/* ok and extended reporting */
+	u32 lun_count, nexus;
+	u32 i, bus, target;
+	u8 expose_flag, attribs;
+	u8 devtype;
+
+	lun_count = ((phys_luns->list_length[0] << 24)
+			+ (phys_luns->list_length[1] << 16)
+			+ (phys_luns->list_length[2] << 8)
+			+ (phys_luns->list_length[3])) / 24;
+
+	for (i = 0; i < lun_count; ++i) {
+
+		bus = phys_luns->lun[i].level2[1] & 0x3f;
+		target = phys_luns->lun[i].level2[0];
+		expose_flag = phys_luns->lun[i].bus >> 6;
+		attribs = phys_luns->lun[i].node_ident[9];
+		nexus = *((u32 *) &phys_luns->lun[i].node_ident[12]);
+
+		if (bus >= AAC_MAX_BUSES || target >= AAC_MAX_TARGETS)
+			continue;
+
+		dev->hba_map[bus][target].expose = expose_flag;
+
+		if (expose_flag != 0) {
+			devtype = AAC_DEVTYPE_RAID_MEMBER;
+			goto update_devtype;
+		}
+
+		if (nexus != 0 && (attribs & 8)) {
+			devtype = AAC_DEVTYPE_NATIVE_RAW;
+			dev->hba_map[bus][target].rmw_nexus =
+					nexus;
+		} else
+			devtype = AAC_DEVTYPE_ARC_RAW;
+
+		if (devtype != AAC_DEVTYPE_NATIVE_RAW)
+			goto update_devtype;
+
+update_devtype:
+		dev->hba_map[bus][target].devtype = devtype;
+	}
+}
+
+/**
+ *	aac_report_phys_luns()	Process topology change
+ *	@dev:		aac_dev structure
+ *	@fibptr:	fib pointer
+ *
+ *	Execute a CISS REPORT PHYS LUNS and process the results into
+ *	the current hba_map.
+ */
+int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr)
+{
+	int fibsize, datasize;
+	struct aac_ciss_phys_luns_resp *phys_luns;
+	struct aac_srb *srbcmd;
+	struct sgmap64 *sg64;
+	dma_addr_t addr;
+	u32 vbus, vid;
+	u32 rcode = 0;
+
+	/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
+	fibsize = sizeof(struct aac_srb) - sizeof(struct sgentry)
+			+ sizeof(struct sgentry64);
+	datasize = sizeof(struct aac_ciss_phys_luns_resp)
+			+ (AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
+
+	phys_luns = (struct aac_ciss_phys_luns_resp *) pci_alloc_consistent(
+			dev->pdev, datasize, &addr);
+
+	if (phys_luns == NULL) {
+		rcode = -ENOMEM;
+		goto err_out;
+	}
+
+	vbus = (u32) le16_to_cpu(
+			dev->supplement_adapter_info.VirtDeviceBus);
+	vid = (u32) le16_to_cpu(
+			dev->supplement_adapter_info.VirtDeviceTarget);
+
+	aac_fib_init(fibptr);
+
+	srbcmd = (struct aac_srb *) fib_data(fibptr);
+	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
+	srbcmd->channel = cpu_to_le32(vbus);
+	srbcmd->id = cpu_to_le32(vid);
+	srbcmd->lun = 0;
+	srbcmd->flags = cpu_to_le32(SRB_DataIn);
+	srbcmd->timeout = cpu_to_le32(10);
+	srbcmd->retry_limit = 0;
+	srbcmd->cdb_size = cpu_to_le32(12);
+	srbcmd->count = cpu_to_le32(datasize);
+
+	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
+	srbcmd->cdb[0] = CISS_REPORT_PHYSICAL_LUNS;
+	srbcmd->cdb[1] = 2; /* extended reporting */
+	srbcmd->cdb[8] = (u8)(datasize >> 8);
+	srbcmd->cdb[9] = (u8)(datasize);
+
+	sg64 = (struct sgmap64 *) &srbcmd->sg;
+	sg64->count = cpu_to_le32(1);
+	sg64->sg[0].addr[1] = cpu_to_le32(upper_32_bits(addr));
+	sg64->sg[0].addr[0] = cpu_to_le32(lower_32_bits(addr));
+	sg64->sg[0].count = cpu_to_le32(datasize);
+
+	rcode = aac_fib_send(ScsiPortCommand64, fibptr, fibsize,
+			FsaNormal, 1, 1, NULL, NULL);
+
+	/* analyse data */
+	if (rcode >= 0 && phys_luns->resp_flag == 2) {
+		/* ok and extended reporting */
+		aac_update_hba_map(dev, phys_luns);
+	}
+
+	pci_free_consistent(dev->pdev, datasize, (void *) phys_luns, addr);
+err_out:
+	return rcode;
+}
+
 int aac_get_adapter_info(struct aac_dev* dev)
 {
 	struct fib* fibptr;
 	int rcode;
-	u32 tmp;
+	u32 tmp, bus, target;
 	struct aac_adapter_info *info;
 	struct aac_bus_info *command;
 	struct aac_bus_info_response *bus_info;
@@ -1544,6 +1674,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	}
 	memcpy(&dev->adapter_info, info, sizeof(*info));
 
+	dev->supplement_adapter_info.VirtDeviceBus = 0xffff;
 	if (dev->adapter_info.options & AAC_OPT_SUPPLEMENT_ADAPTER_INFO) {
 		struct aac_supplement_adapter_info * sinfo;
 
@@ -1571,6 +1702,11 @@ int aac_get_adapter_info(struct aac_dev* dev)
 
 	}
 
+	/* reset all previous mapped devices (i.e. for init. after IOP_RESET) */
+	for (bus = 0; bus < AAC_MAX_BUSES; bus++) {
+		for (target = 0; target < AAC_MAX_TARGETS; target++)
+			dev->hba_map[bus][target].devtype = 0;
+	}
 
 	/*
 	 * GetBusInfo
@@ -1603,6 +1739,12 @@ int aac_get_adapter_info(struct aac_dev* dev)
 		dev->maximum_num_channels = le32_to_cpu(bus_info->BusCount);
 	}
 
+	if (!dev->sync_mode && dev->sa_firmware &&
+			dev->supplement_adapter_info.VirtDeviceBus != 0xffff) {
+		/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
+		rcode = aac_report_phys_luns(dev, fibptr);
+	}
+
 	if (!dev->in_reset) {
 		char buffer[16];
 		tmp = le32_to_cpu(dev->adapter_info.kernelrev);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 057ff78..8c6c4ac 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -81,6 +81,27 @@ enum {
 
 #define AAC_DEBUG_INSTRUMENT_AIF_DELETE
 
+#define AAC_MAX_NATIVE_TARGETS		1024
+/* Thor: 5 phys. buses: #0: empty, 1-4: 256 targets each */
+#define AAC_MAX_BUSES			5
+#define AAC_MAX_TARGETS		256
+#define AAC_MAX_NATIVE_SIZE		2048
+
+#define CISS_REPORT_PHYSICAL_LUNS	0xc3
+
+struct aac_ciss_phys_luns_resp {
+	u8	list_length[4];		/* LUN list length (N-7, big endian) */
+	u8	resp_flag;		/* extended response_flag */
+	u8	reserved[3];
+	struct _ciss_lun {
+		u8	tid[3];		/* Target ID */
+		u8	bus;		/* Bus, flag (bits 6,7) */
+		u8	level3[2];
+		u8	level2[2];
+		u8	node_ident[16];	/* phys. node identifier */
+	} lun[1];			/* List of phys. devices */
+};
+
 /*
  * Interrupts
  */
@@ -993,6 +1014,20 @@ struct fib {
 	dma_addr_t		hw_fib_pa;		/* physical address of hw_fib*/
 };
 
+#define AAC_DEVTYPE_RAID_MEMBER	1
+#define AAC_DEVTYPE_ARC_RAW		2
+#define AAC_DEVTYPE_NATIVE_RAW		3
+#define AAC_EXPOSE_DISK		0
+#define AAC_HIDE_DISK			3
+
+struct aac_hba_map_info {
+	__le32	rmw_nexus;		/* nexus for native HBA devices */
+	u8		devtype;	/* device type */
+	u8		reset_state;	/* 0 - no reset, 1..x - */
+					/* after xth TM LUN reset */
+	u8		expose;		/*checks if to expose or not*/
+};
+
 /*
  *	Adapter Information Block
  *
@@ -1056,7 +1091,28 @@ struct aac_supplement_adapter_info
 	/* StructExpansion == 1 */
 	__le32	FeatureBits3;
 	__le32	SupportedPerformanceModes;
-	__le32	ReservedForFutureGrowth[80];
+	u8	HostBusType;		/* uses HOST_BUS_TYPE_xxx defines */
+	u8	HostBusWidth;		/* actual width in bits or links */
+	u16	HostBusSpeed;		/* actual bus speed/link rate in MHz */
+	u8	MaxRRCDrives;		/* max. number of ITP-RRC drives/pool */
+	u8	MaxDiskXtasks;		/* max. possible num of DiskX Tasks */
+
+	u8	CpldVerLoaded;
+	u8	CpldVerInFlash;
+
+	__le64	MaxRRCCapacity;
+	__le32	CompiledMaxHistLogLevel;
+	u8	CustomBoardName[12];
+	u16	SupportedCntlrMode;	/* identify supported controller mode */
+	u16	ReservedForFuture16;
+	__le32	SupportedOptions3;	/* reserved for future options */
+
+	__le16	VirtDeviceBus;		/* virt. SCSI device for Thor */
+	__le16	VirtDeviceTarget;
+	__le16	VirtDeviceLUN;
+	__le16	Unused;
+	__le32	ReservedForFutureGrowth[68];
+
 };
 #define AAC_FEATURE_FALCON	cpu_to_le32(0x00000010)
 #define AAC_FEATURE_JBOD	cpu_to_le32(0x08000000)
@@ -1287,6 +1343,7 @@ struct aac_dev
 	u32			vector_cap;	/* MSI-X vector capab.*/
 	int			msi_enabled;	/* MSI/MSI-X enabled */
 	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
+	struct aac_hba_map_info	hba_map[AAC_MAX_BUSES][AAC_MAX_TARGETS];
 	u8			adapter_shutdown;
 	u32			handle_pci_error;
 };
@@ -2171,6 +2228,7 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
+int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
-- 
2.7.4

