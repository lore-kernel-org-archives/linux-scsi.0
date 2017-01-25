From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 12/24] aacraid: Retrieve Queue Depth from Adapter FW
Date: Wed, 25 Jan 2017 10:00:59 -0800
Message-ID: <20170125180111.25401-13-RaghavaAditya.Renukunta@microsemi.com>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:53927
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752099AbdAZAiR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 19:38:17 -0500
In-Reply-To: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Benesh@microsemi.com

Retrieved queue depth from fw and saved it for future use.
Only applicable for HBA1000 drives.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
 Changes in  V2:
  None

 drivers/scsi/aacraid/aachba.c  | 84 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/aacraid/aacraid.h | 85 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 167 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 42baca9..69f53e6 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1516,6 +1516,83 @@ static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
 	return aac_scsi_32(fib, cmd);
 }
 
+int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
+{
+	struct fib *fibptr;
+	int rcode = -1;
+	u16 fibsize, datasize;
+	struct aac_srb *srbcmd;
+	struct sgmap64 *sg64;
+	struct aac_ciss_identify_pd *identify_resp;
+	dma_addr_t addr;
+	u32 vbus, vid;
+	u16 temp;
+
+	fibptr = aac_fib_alloc(dev);
+	if (!fibptr)
+		return -ENOMEM;
+
+	temp = AAC_MAX_LUN + target;
+
+	fibsize = sizeof(struct aac_srb) -
+		sizeof(struct sgentry) + sizeof(struct sgentry64);
+	datasize = sizeof(struct aac_ciss_identify_pd);
+
+	identify_resp = (struct aac_ciss_identify_pd *)
+		pci_alloc_consistent(dev->pdev, datasize, &addr);
+
+	if (identify_resp != NULL) {
+		vbus = (u32)le16_to_cpu(
+			dev->supplement_adapter_info.VirtDeviceBus);
+		vid = (u32)le16_to_cpu(
+			dev->supplement_adapter_info.VirtDeviceTarget);
+
+		aac_fib_init(fibptr);
+		srbcmd = (struct aac_srb *) fib_data(fibptr);
+
+		srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
+		srbcmd->channel  = cpu_to_le32(vbus);
+		srbcmd->id       = cpu_to_le32(vid);
+		srbcmd->lun      = 0;
+		srbcmd->flags    = cpu_to_le32(SRB_DataIn);
+		srbcmd->timeout  = cpu_to_le32(10);
+		srbcmd->retry_limit = 0;
+		srbcmd->cdb_size = cpu_to_le32(12);
+		srbcmd->count = cpu_to_le32(datasize);
+
+		memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
+		srbcmd->cdb[0] = 0x26;
+		srbcmd->cdb[2] = (u8)(temp & 0x00FF);
+
+		srbcmd->cdb[6] = CISS_IDENTIFY_PHYSICAL_DEVICE;
+
+		sg64 = (struct sgmap64 *)&srbcmd->sg;
+		sg64->count = cpu_to_le32(1);
+		sg64->sg[0].addr[1] = cpu_to_le32((u32)(((addr) >> 16) >> 16));
+		sg64->sg[0].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
+		sg64->sg[0].count = cpu_to_le32(datasize);
+
+		rcode = aac_fib_send(ScsiPortCommand64,
+			fibptr, fibsize, FsaNormal, 1, 1, NULL, NULL);
+
+		if (identify_resp->current_queue_depth_limit <= 0 ||
+			identify_resp->current_queue_depth_limit > 32)
+			dev->hba_map[bus][target].qd_limit = 32;
+		else
+			dev->hba_map[bus][target].qd_limit =
+				identify_resp->current_queue_depth_limit;
+
+		pci_free_consistent(dev->pdev, datasize,
+					(void *)identify_resp, addr);
+
+		aac_fib_complete(fibptr);
+	}
+
+	aac_fib_free(fibptr);
+
+	return rcode;
+}
+
 /**
  *	aac_update hba_map()-	update current hba map with data from FW
  *	@dev:	aac_dev structure
@@ -1565,6 +1642,9 @@ void aac_update_hba_map(struct aac_dev *dev,
 		if (devtype != AAC_DEVTYPE_NATIVE_RAW)
 			goto update_devtype;
 
+		if (aac_issue_bmic_identify(dev, bus, target) < 0)
+			dev->hba_map[bus][target].qd_limit = 32;
+
 update_devtype:
 		dev->hba_map[bus][target].devtype = devtype;
 	}
@@ -1711,8 +1791,10 @@ int aac_get_adapter_info(struct aac_dev* dev)
 
 	/* reset all previous mapped devices (i.e. for init. after IOP_RESET) */
 	for (bus = 0; bus < AAC_MAX_BUSES; bus++) {
-		for (target = 0; target < AAC_MAX_TARGETS; target++)
+		for (target = 0; target < AAC_MAX_TARGETS; target++) {
 			dev->hba_map[bus][target].devtype = 0;
+			dev->hba_map[bus][target].qd_limit = 0;
+		}
 	}
 
 	/*
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 03250b5..23c00ab 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -74,7 +74,7 @@ enum {
 #define AAC_NUM_IO_FIB		(1024 - AAC_NUM_MGT_FIB)
 #define AAC_NUM_FIB		(AAC_NUM_IO_FIB + AAC_NUM_MGT_FIB)
 
-#define AAC_MAX_LUN		(8)
+#define AAC_MAX_LUN		(256)
 
 #define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
 #define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)256)
@@ -89,6 +89,7 @@ enum {
 
 #define CISS_REPORT_PHYSICAL_LUNS	0xc3
 #define WRITE_HOST_WELLNESS		0xa5
+#define CISS_IDENTIFY_PHYSICAL_DEVICE	0x15
 #define BMIC_IN			0x26
 #define BMIC_OUT			0x27
 
@@ -110,6 +111,86 @@ struct aac_ciss_phys_luns_resp {
  */
 #define AAC_MAX_HRRQ		64
 
+#pragma pack(1)
+
+struct aac_ciss_identify_pd {
+	u8 scsi_bus;			/* SCSI Bus number on controller */
+	u8 scsi_id;			/* SCSI ID on this bus */
+	u16 block_size;			/* sector size in bytes */
+	u32 total_blocks;		/* number for sectors on drive */
+	u32 reserved_blocks;		/* controller reserved (RIS) */
+	u8 model[40];			/* Physical Drive Model */
+	u8 serial_number[40];		/* Drive Serial Number */
+	u8 firmware_revision[8];	/* drive firmware revision */
+	u8 scsi_inquiry_bits;		/* inquiry byte 7 bits */
+	u8 compaq_drive_stamp;		/* 0 means drive not stamped */
+	u8 last_failure_reason;
+
+	u8  flags;
+	u8  more_flags;
+	u8  scsi_lun;			/* SCSI LUN for phys drive */
+	u8  yet_more_flags;
+	u8  even_more_flags;
+	u32 spi_speed_rules;		/* SPI Speed :Ultra disable diagnose */
+	u8  phys_connector[2];		/* connector number on controller */
+	u8  phys_box_on_bus;		/* phys enclosure this drive resides */
+	u8  phys_bay_in_box;		/* phys drv bay this drive resides */
+	u32 rpm;			/* Drive rotational speed in rpm */
+	u8  device_type;		/* type of drive */
+	u8  sata_version;		/* only valid when drive_type is SATA */
+	u64 big_total_block_count;
+	u64 ris_starting_lba;
+	u32 ris_size;
+	u8  wwid[20];
+	u8  controller_phy_map[32];
+	u16 phy_count;
+	u8  phy_connected_dev_type[256];
+	u8  phy_to_drive_bay_num[256];
+	u16 phy_to_attached_dev_index[256];
+	u8  box_index;
+	u8  spitfire_support;
+	u16 extra_physical_drive_flags;
+	u8  negotiated_link_rate[256];
+	u8  phy_to_phy_map[256];
+	u8  redundant_path_present_map;
+	u8  redundant_path_failure_map;
+	u8  active_path_number;
+	u16 alternate_paths_phys_connector[8];
+	u8  alternate_paths_phys_box_on_port[8];
+	u8  multi_lun_device_lun_count;
+	u8  minimum_good_fw_revision[8];
+	u8  unique_inquiry_bytes[20];
+	u8  current_temperature_degreesC;
+	u8  temperature_threshold_degreesC;
+	u8  max_temperature_degreesC;
+	u8  logical_blocks_per_phys_block_exp;	/* phyblocksize = 512 * 2^exp */
+	u16 current_queue_depth_limit;
+	u8  switch_name[10];
+	u16 switch_port;
+	u8  alternate_paths_switch_name[40];
+	u8  alternate_paths_switch_port[8];
+	u16 power_on_hours;		/* valid only if gas gauge supported */
+	u16 percent_endurance_used;	/* valid only if gas gauge supported. */
+	u8  drive_authentication;
+	u8  smart_carrier_authentication;
+	u8  smart_carrier_app_fw_version;
+	u8  smart_carrier_bootloader_fw_version;
+	u8  SanitizeSecureEraseSupport;
+	u8  DriveKeyFlags;
+	u8  encryption_key_name[64];
+	u32 misc_drive_flags;
+	u16 dek_index;
+	u16 drive_encryption_flags;
+	u8  sanitize_maximum_time[6];
+	u8  connector_info_mode;
+	u8  connector_info_number[4];
+	u8  long_connector_name[64];
+	u8  device_unique_identifier[16];
+	u8  padto_2K[17];
+};
+
+#pragma pack()
+
 /*
  * These macros convert from physical channels to virtual channels
  */
@@ -1032,6 +1113,7 @@ struct aac_hba_map_info {
 	u8		devtype;	/* device type */
 	u8		reset_state;	/* 0 - no reset, 1..x - */
 					/* after xth TM LUN reset */
+	u16		qd_limit;
 	u8		expose;		/*checks if to expose or not*/
 };
 
@@ -2240,6 +2322,7 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
 int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr);
+int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
-- 
2.7.4

