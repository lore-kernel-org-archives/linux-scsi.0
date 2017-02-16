From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 01/15] aacraid: Fix camel case
Date: Thu, 16 Feb 2017 12:51:10 -0800
Message-ID: <20170216205124.20271-2-RaghavaAditya.Renukunta@microsemi.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0078.outbound.protection.outlook.com ([104.47.32.78]:8980
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755206AbdBQD2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 22:28:11 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

Replaced camel case with snake case for init supported options.

Suggested-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes in V2:
None

 drivers/scsi/aacraid/aachba.c  | 53 ++++++++++++-----------
 drivers/scsi/aacraid/aacraid.h | 98 +++++++++++++++++++++---------------------
 drivers/scsi/aacraid/commsup.c |  6 +--
 drivers/scsi/aacraid/linit.c   | 32 +++++++-------
 drivers/scsi/aacraid/rx.c      |  2 +-
 drivers/scsi/aacraid/src.c     |  2 +-
 6 files changed, 100 insertions(+), 93 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 907f1e8..98d4ffd 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -483,7 +483,7 @@ int aac_get_containers(struct aac_dev *dev)
 	if (status >= 0) {
 		dresp = (struct aac_get_container_count_resp *)fib_data(fibptr);
 		maximum_num_containers = le32_to_cpu(dresp->ContainerSwitchEntries);
-		if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+		if (fibptr->dev->supplement_adapter_info.supported_options2 &
 		    AAC_OPTION_SUPPORTED_240_VOLUMES) {
 			maximum_num_containers =
 				le32_to_cpu(dresp->MaxSimpleVolumes);
@@ -639,13 +639,16 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 	fsa_dev_ptr = fibptr->dev->fsa_dev;
 	if (fsa_dev_ptr) {
 		struct aac_mount * dresp = (struct aac_mount *) fib_data(fibptr);
+		__le32 sup_options2;
+
 		fsa_dev_ptr += scmd_id(scsicmd);
+		sup_options2 =
+			fibptr->dev->supplement_adapter_info.supported_options2;
 
 		if ((le32_to_cpu(dresp->status) == ST_OK) &&
 		    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
 		    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
-			if (!(fibptr->dev->supplement_adapter_info.SupportedOptions2 &
-			    AAC_OPTION_VARIABLE_BLOCK_SIZE)) {
+			if (!(sup_options2 & AAC_OPTION_VARIABLE_BLOCK_SIZE)) {
 				dresp->mnt[0].fileinfo.bdevinfo.block_size = 0x200;
 				fsa_dev_ptr->block_size = 0x200;
 			} else {
@@ -688,7 +691,7 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	int status;
 
 	dresp = (struct aac_mount *) fib_data(fibptr);
-	if (!(fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+	if (!(fibptr->dev->supplement_adapter_info.supported_options2 &
 	    AAC_OPTION_VARIABLE_BLOCK_SIZE))
 		dresp->mnt[0].capacityhigh = 0;
 	if ((le32_to_cpu(dresp->status) != ST_OK) ||
@@ -705,7 +708,7 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 
 	dinfo = (struct aac_query_mount *)fib_data(fibptr);
 
-	if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+	if (fibptr->dev->supplement_adapter_info.supported_options2 &
 	    AAC_OPTION_VARIABLE_BLOCK_SIZE)
 		dinfo->command = cpu_to_le32(VM_NameServeAllBlk);
 	else
@@ -745,7 +748,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
 
 		dinfo = (struct aac_query_mount *)fib_data(fibptr);
 
-		if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+		if (fibptr->dev->supplement_adapter_info.supported_options2 &
 		    AAC_OPTION_VARIABLE_BLOCK_SIZE)
 			dinfo->command = cpu_to_le32(VM_NameServeAllBlk);
 		else
@@ -896,12 +899,14 @@ char * get_container_type(unsigned tindex)
 static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 {
 	struct scsi_inq *str;
+	struct aac_supplement_adapter_info *sup_adap_info;
 
+	sup_adap_info = &dev->supplement_adapter_info;
 	str = (struct scsi_inq *)(data); /* cast data to scsi inq block */
 	memset(str, ' ', sizeof(*str));
 
-	if (dev->supplement_adapter_info.AdapterTypeText[0]) {
-		char * cp = dev->supplement_adapter_info.AdapterTypeText;
+	if (sup_adap_info->adapter_type_text[0]) {
+		char *cp = sup_adap_info->adapter_type_text;
 		int c;
 		if ((cp[0] == 'A') && (cp[1] == 'O') && (cp[2] == 'C'))
 			inqstrcpy("SMC", str->vid);
@@ -911,8 +916,7 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 				++cp;
 			c = *cp;
 			*cp = '\0';
-			inqstrcpy (dev->supplement_adapter_info.AdapterTypeText,
-				   str->vid);
+			inqstrcpy(sup_adap_info->adapter_type_text, str->vid);
 			*cp = c;
 			while (*cp && *cp != ' ')
 				++cp;
@@ -1675,8 +1679,8 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 	if (!identify_resp)
 		goto fib_free_ptr;
 
-	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.VirtDeviceBus);
-	vid = (u32)le16_to_cpu(dev->supplement_adapter_info.VirtDeviceTarget);
+	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_bus);
+	vid = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_target);
 
 	aac_fib_init(fibptr);
 
@@ -1815,9 +1819,9 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 	}
 
 	vbus = (u32) le16_to_cpu(
-			dev->supplement_adapter_info.VirtDeviceBus);
+			dev->supplement_adapter_info.virt_device_bus);
 	vid = (u32) le16_to_cpu(
-			dev->supplement_adapter_info.VirtDeviceTarget);
+			dev->supplement_adapter_info.virt_device_target);
 
 	aac_fib_init(fibptr);
 
@@ -1893,7 +1897,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	}
 	memcpy(&dev->adapter_info, info, sizeof(*info));
 
-	dev->supplement_adapter_info.VirtDeviceBus = 0xffff;
+	dev->supplement_adapter_info.virt_device_bus = 0xffff;
 	if (dev->adapter_info.options & AAC_OPT_SUPPLEMENT_ADAPTER_INFO) {
 		struct aac_supplement_adapter_info * sinfo;
 
@@ -1961,7 +1965,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	}
 
 	if (!dev->sync_mode && dev->sa_firmware &&
-			dev->supplement_adapter_info.VirtDeviceBus != 0xffff) {
+		dev->supplement_adapter_info.virt_device_bus != 0xffff) {
 		/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
 		rcode = aac_report_phys_luns(dev, fibptr, AAC_INIT);
 	}
@@ -1976,8 +1980,8 @@ int aac_get_adapter_info(struct aac_dev* dev)
 			(tmp>>16)&0xff,
 			tmp&0xff,
 			le32_to_cpu(dev->adapter_info.kernelbuild),
-			(int)sizeof(dev->supplement_adapter_info.BuildDate),
-			dev->supplement_adapter_info.BuildDate);
+			(int)sizeof(dev->supplement_adapter_info.build_date),
+			dev->supplement_adapter_info.build_date);
 		tmp = le32_to_cpu(dev->adapter_info.monitorrev);
 		printk(KERN_INFO "%s%d: monitor %d.%d-%d[%d]\n",
 			dev->name, dev->id,
@@ -1993,14 +1997,15 @@ int aac_get_adapter_info(struct aac_dev* dev)
 		  shost_to_class(dev->scsi_host_ptr), buffer))
 			printk(KERN_INFO "%s%d: serial %s",
 			  dev->name, dev->id, buffer);
-		if (dev->supplement_adapter_info.VpdInfo.Tsid[0]) {
+		if (dev->supplement_adapter_info.vpd_info.tsid[0]) {
 			printk(KERN_INFO "%s%d: TSID %.*s\n",
 			  dev->name, dev->id,
-			  (int)sizeof(dev->supplement_adapter_info.VpdInfo.Tsid),
-			  dev->supplement_adapter_info.VpdInfo.Tsid);
+			  (int)sizeof(dev->supplement_adapter_info
+							.vpd_info.tsid),
+				dev->supplement_adapter_info.vpd_info.tsid);
 		}
 		if (!aac_check_reset || ((aac_check_reset == 1) &&
-		  (dev->supplement_adapter_info.SupportedOptions2 &
+		  (dev->supplement_adapter_info.supported_options2 &
 		  AAC_OPTION_IGNORE_RESET))) {
 			printk(KERN_INFO "%s%d: Reset Adapter Ignored\n",
 			  dev->name, dev->id);
@@ -2008,7 +2013,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	}
 
 	dev->cache_protected = 0;
-	dev->jbod = ((dev->supplement_adapter_info.FeatureBits &
+	dev->jbod = ((dev->supplement_adapter_info.feature_bits &
 		AAC_FEATURE_JBOD) != 0);
 	dev->nondasd_support = 0;
 	dev->raid_scsi_mode = 0;
@@ -2631,7 +2636,7 @@ static int aac_start_stop(struct scsi_cmnd *scsicmd)
 	struct scsi_device *sdev = scsicmd->device;
 	struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
 
-	if (!(aac->supplement_adapter_info.SupportedOptions2 &
+	if (!(aac->supplement_adapter_info.supported_options2 &
 	      AAC_OPTION_POWER_MANAGEMENT)) {
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
 				  SAM_STAT_GOOD;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index f234497..b5a2c87 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1380,57 +1380,57 @@ struct aac_adapter_info
 
 struct aac_supplement_adapter_info
 {
-	u8	AdapterTypeText[17+1];
-	u8	Pad[2];
-	__le32	FlashMemoryByteSize;
-	__le32	FlashImageId;
-	__le32	MaxNumberPorts;
-	__le32	Version;
-	__le32	FeatureBits;
-	u8	SlotNumber;
-	u8	ReservedPad0[3];
-	u8	BuildDate[12];
-	__le32	CurrentNumberPorts;
+	u8	adapter_type_text[17+1];
+	u8	pad[2];
+	__le32	flash_memory_byte_size;
+	__le32	flash_image_id;
+	__le32	max_number_ports;
+	__le32	version;
+	__le32	feature_bits;
+	u8	slot_number;
+	u8	reserved_pad0[3];
+	u8	build_date[12];
+	__le32	current_number_ports;
 	struct {
-		u8	AssemblyPn[8];
-		u8	FruPn[8];
-		u8	BatteryFruPn[8];
-		u8	EcVersionString[8];
-		u8	Tsid[12];
-	}	VpdInfo;
-	__le32	FlashFirmwareRevision;
-	__le32	FlashFirmwareBuild;
-	__le32	RaidTypeMorphOptions;
-	__le32	FlashFirmwareBootRevision;
-	__le32	FlashFirmwareBootBuild;
-	u8	MfgPcbaSerialNo[12];
-	u8	MfgWWNName[8];
-	__le32	SupportedOptions2;
-	__le32	StructExpansion;
+		u8	assembly_pn[8];
+		u8	fru_pn[8];
+		u8	battery_fru_pn[8];
+		u8	ec_version_string[8];
+		u8	tsid[12];
+	}	vpd_info;
+	__le32	flash_firmware_revision;
+	__le32	flash_firmware_build;
+	__le32	raid_type_morph_options;
+	__le32	flash_firmware_boot_revision;
+	__le32	flash_firmware_boot_build;
+	u8	mfg_pcba_serial_no[12];
+	u8	mfg_wwn_name[8];
+	__le32	supported_options2;
+	__le32	struct_expansion;
 	/* StructExpansion == 1 */
-	__le32	FeatureBits3;
-	__le32	SupportedPerformanceModes;
-	u8	HostBusType;		/* uses HOST_BUS_TYPE_xxx defines */
-	u8	HostBusWidth;		/* actual width in bits or links */
-	u16	HostBusSpeed;		/* actual bus speed/link rate in MHz */
-	u8	MaxRRCDrives;		/* max. number of ITP-RRC drives/pool */
-	u8	MaxDiskXtasks;		/* max. possible num of DiskX Tasks */
-
-	u8	CpldVerLoaded;
-	u8	CpldVerInFlash;
-
-	__le64	MaxRRCCapacity;
-	__le32	CompiledMaxHistLogLevel;
-	u8	CustomBoardName[12];
-	u16	SupportedCntlrMode;	/* identify supported controller mode */
-	u16	ReservedForFuture16;
-	__le32	SupportedOptions3;	/* reserved for future options */
-
-	__le16	VirtDeviceBus;		/* virt. SCSI device for Thor */
-	__le16	VirtDeviceTarget;
-	__le16	VirtDeviceLUN;
-	__le16	Unused;
-	__le32	ReservedForFutureGrowth[68];
+	__le32	feature_bits3;
+	__le32	supported_performance_modes;
+	u8	host_bus_type;		/* uses HOST_BUS_TYPE_xxx defines */
+	u8	host_bus_width;		/* actual width in bits or links */
+	u16	host_bus_speed;		/* actual bus speed/link rate in MHz */
+	u8	max_rrc_drives;		/* max. number of ITP-RRC drives/pool */
+	u8	max_disk_xtasks;	/* max. possible num of DiskX Tasks */
+
+	u8	cpld_ver_loaded;
+	u8	cpld_ver_in_flash;
+
+	__le64	max_rrc_capacity;
+	__le32	compiled_max_hist_log_level;
+	u8	custom_board_name[12];
+	u16	supported_cntlr_mode;	/* identify supported controller mode */
+	u16	reserved_for_future16;
+	__le32	supported_options3;	/* reserved for future options */
+
+	__le16	virt_device_bus;		/* virt. SCSI device for Thor */
+	__le16	virt_device_target;
+	__le16	virt_device_lun;
+	__le16	unused;
+	__le32	reserved_for_future_growth[68];
 
 };
 #define AAC_FEATURE_FALCON	cpu_to_le32(0x00000010)
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 969727b..56090f5 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1815,7 +1815,7 @@ int aac_check_health(struct aac_dev * aac)
 	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
 
 	if (!aac_check_reset || ((aac_check_reset == 1) &&
-		(aac->supplement_adapter_info.SupportedOptions2 &
+		(aac->supplement_adapter_info.supported_options2 &
 			AAC_OPTION_IGNORE_RESET)))
 		goto out;
 	host = aac->scsi_host_ptr;
@@ -2264,8 +2264,8 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 
 	aac_fib_init(fibptr);
 
-	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.VirtDeviceBus);
-	vid = (u32)le16_to_cpu(dev->supplement_adapter_info.VirtDeviceTarget);
+	vbus = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_bus);
+	vid = (u32)le16_to_cpu(dev->supplement_adapter_info.virt_device_target);
 
 	srbcmd = (struct aac_srb *)fib_data(fibptr);
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 137d22d..ab4f1e7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -891,13 +891,13 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 		 * Adapters that support a register, instead of a commanded,
 		 * reset.
 		 */
-		if (((aac->supplement_adapter_info.SupportedOptions2 &
+		if (((aac->supplement_adapter_info.supported_options2 &
 			  AAC_OPTION_MU_RESET) ||
-			  (aac->supplement_adapter_info.SupportedOptions2 &
+			  (aac->supplement_adapter_info.supported_options2 &
 			  AAC_OPTION_DOORBELL_RESET)) &&
 			  aac_check_reset &&
 			  ((aac_check_reset != 1) ||
-			   !(aac->supplement_adapter_info.SupportedOptions2 &
+			   !(aac->supplement_adapter_info.supported_options2 &
 			    AAC_OPTION_IGNORE_RESET))) {
 			/* Bypass wait for command quiesce */
 			aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET);
@@ -1029,8 +1029,8 @@ static ssize_t aac_show_model(struct device *device,
 	struct aac_dev *dev = (struct aac_dev*)class_to_shost(device)->hostdata;
 	int len;
 
-	if (dev->supplement_adapter_info.AdapterTypeText[0]) {
-		char * cp = dev->supplement_adapter_info.AdapterTypeText;
+	if (dev->supplement_adapter_info.adapter_type_text[0]) {
+		char *cp = dev->supplement_adapter_info.adapter_type_text;
 		while (*cp && *cp != ' ')
 			++cp;
 		while (*cp == ' ')
@@ -1046,18 +1046,20 @@ static ssize_t aac_show_vendor(struct device *device,
 			       struct device_attribute *attr, char *buf)
 {
 	struct aac_dev *dev = (struct aac_dev*)class_to_shost(device)->hostdata;
+	struct aac_supplement_adapter_info *sup_adap_info;
 	int len;
 
-	if (dev->supplement_adapter_info.AdapterTypeText[0]) {
-		char * cp = dev->supplement_adapter_info.AdapterTypeText;
+	sup_adap_info = &dev->supplement_adapter_info;
+	if (sup_adap_info->adapter_type_text[0]) {
+		char *cp = sup_adap_info->adapter_type_text;
 		while (*cp && *cp != ' ')
 			++cp;
 		len = snprintf(buf, PAGE_SIZE, "%.*s\n",
-		  (int)(cp - (char *)dev->supplement_adapter_info.AdapterTypeText),
-		  dev->supplement_adapter_info.AdapterTypeText);
+			(int)(cp - (char *)sup_adap_info->adapter_type_text),
+					sup_adap_info->adapter_type_text);
 	} else
 		len = snprintf(buf, PAGE_SIZE, "%s\n",
-		  aac_drivers[dev->cardtype].vname);
+			aac_drivers[dev->cardtype].vname);
 	return len;
 }
 
@@ -1078,7 +1080,7 @@ static ssize_t aac_show_flags(struct device *cdev,
 				"SAI_READ_CAPACITY_16\n");
 	if (dev->jbod)
 		len += snprintf(buf + len, PAGE_SIZE - len, "SUPPORTED_JBOD\n");
-	if (dev->supplement_adapter_info.SupportedOptions2 &
+	if (dev->supplement_adapter_info.supported_options2 &
 		AAC_OPTION_POWER_MANAGEMENT)
 		len += snprintf(buf + len, PAGE_SIZE - len,
 				"SUPPORTED_POWER_MANAGEMENT\n");
@@ -1139,12 +1141,12 @@ static ssize_t aac_show_serial_number(struct device *device,
 		len = snprintf(buf, 16, "%06X\n",
 		  le32_to_cpu(dev->adapter_info.serial[0]));
 	if (len &&
-	  !memcmp(&dev->supplement_adapter_info.MfgPcbaSerialNo[
-	    sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo)-len],
+	  !memcmp(&dev->supplement_adapter_info.mfg_pcba_serial_no[
+	    sizeof(dev->supplement_adapter_info.mfg_pcba_serial_no)-len],
 	  buf, len-1))
 		len = snprintf(buf, 16, "%.*s\n",
-		  (int)sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo),
-		  dev->supplement_adapter_info.MfgPcbaSerialNo);
+		  (int)sizeof(dev->supplement_adapter_info.mfg_pcba_serial_no),
+		  dev->supplement_adapter_info.mfg_pcba_serial_no);
 
 	return min(len, 16);
 }
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 0e69a80..5d19c31 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -475,7 +475,7 @@ static int aac_rx_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 {
 	u32 var = 0;
 
-	if (!(dev->supplement_adapter_info.SupportedOptions2 &
+	if (!(dev->supplement_adapter_info.supported_options2 &
 	  AAC_OPTION_MU_RESET) || (bled >= 0) || (bled == -2)) {
 		if (bled)
 			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 8e4e2dd..c17b060 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -684,7 +684,7 @@ static void aac_send_iop_reset(struct aac_dev *dev, int bled)
 
 	aac_set_intx_mode(dev);
 
-	if (!bled && (dev->supplement_adapter_info.SupportedOptions2 &
+	if (!bled && (dev->supplement_adapter_info.supported_options2 &
 	    AAC_OPTION_DOORBELL_RESET)) {
 		src_writel(dev, MUnit.IDR, reset_mask);
 	} else {
-- 
2.7.4
