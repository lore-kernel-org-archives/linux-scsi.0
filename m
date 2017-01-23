From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 18/24] aacraid: VPD 83 type3 support
Date: Mon, 23 Jan 2017 10:09:02 -0800
Message-ID: <20170123180908.3465-19-RaghavaAditya.Renukunta@microsemi.com>
References: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0073.outbound.protection.outlook.com ([104.47.36.73]:2657
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751866AbdAXArG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 19:47:06 -0500
In-Reply-To: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Banesh@microsemi.com

This patch adds support to retrieve the unique identifier data (VPD page
83 type3) for Logical drives created on SmartIOC 2000 products. In
addition  added a sysfs device structure to expose the id information.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  | 180 ++++++++++++++++++++++++++---------------
 drivers/scsi/aacraid/aacraid.h |   2 +
 drivers/scsi/aacraid/linit.c   |  31 +++++++
 3 files changed, 150 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 0cb4dab..a89e2a5 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -167,46 +167,56 @@ struct inquiry_data {
 };
 
 /* Added for VPD 0x83 */
-typedef struct {
-	u8 CodeSet:4;	/* VPD_CODE_SET */
-	u8 Reserved:4;
-	u8 IdentifierType:4;	/* VPD_IDENTIFIER_TYPE */
-	u8 Reserved2:4;
-	u8 Reserved3;
-	u8 IdentifierLength;
-	u8 VendId[8];
-	u8 ProductId[16];
-	u8 SerialNumber[8];	/* SN in ASCII */
-
-} TVPD_ID_Descriptor_Type_1;
+struct  tvpd_id_descriptor_type_1 {
+	u8 codeset:4;		/* VPD_CODE_SET */
+	u8 reserved:4;
+	u8 identifiertype:4;	/* VPD_IDENTIFIER_TYPE */
+	u8 reserved2:4;
+	u8 reserved3;
+	u8 identifierlength;
+	u8 venid[8];
+	u8 productid[16];
+	u8 serialnumber[8];	/* SN in ASCII */
 
-typedef struct {
-	u8 CodeSet:4;	/* VPD_CODE_SET */
-	u8 Reserved:4;
-	u8 IdentifierType:4;	/* VPD_IDENTIFIER_TYPE */
-	u8 Reserved2:4;
-	u8 Reserved3;
-	u8 IdentifierLength;
-	struct TEU64Id {
+};
+
+struct tvpd_id_descriptor_type_2 {
+	u8 codeset:4;		/* VPD_CODE_SET */
+	u8 reserved:4;
+	u8 identifiertype:4;	/* VPD_IDENTIFIER_TYPE */
+	u8 reserved2:4;
+	u8 reserved3;
+	u8 identifierlength;
+	struct teu64id {
 		u32 Serial;
 		 /* The serial number supposed to be 40 bits,
 		  * bit we only support 32, so make the last byte zero. */
-		u8 Reserved;
-		u8 VendId[3];
-	} EU64Id;
+		u8 reserved;
+		u8 venid[3];
+	} eu64id;
 
-} TVPD_ID_Descriptor_Type_2;
+};
 
-typedef struct {
+struct tvpd_id_descriptor_type_3 {
+	u8 codeset : 4;          /* VPD_CODE_SET */
+	u8 reserved : 4;
+	u8 identifiertype : 4;   /* VPD_IDENTIFIER_TYPE */
+	u8 reserved2 : 4;
+	u8 reserved3;
+	u8 identifierlength;
+	u8 Identifier[16];
+};
+
+struct tvpd_page83 {
 	u8 DeviceType:5;
 	u8 DeviceTypeQualifier:3;
 	u8 PageCode;
-	u8 Reserved;
+	u8 reserved;
 	u8 PageLength;
-	TVPD_ID_Descriptor_Type_1 IdDescriptorType1;
-	TVPD_ID_Descriptor_Type_2 IdDescriptorType2;
-
-} TVPD_Page83;
+	struct tvpd_id_descriptor_type_1 type1;
+	struct tvpd_id_descriptor_type_2 type2;
+	struct tvpd_id_descriptor_type_3 type3;
+};
 
 /*
  *              M O D U L E   G L O B A L S
@@ -613,6 +623,7 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 	struct fsa_dev_info *fsa_dev_ptr;
 	int (*callback)(struct scsi_cmnd *);
 	struct scsi_cmnd * scsicmd = (struct scsi_cmnd *)context;
+	int i;
 
 
 	if (!aac_valid_context(scsicmd, fibptr))
@@ -635,6 +646,10 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 				fsa_dev_ptr->block_size =
 					le32_to_cpu(dresp->mnt[0].fileinfo.bdevinfo.block_size);
 			}
+			for (i = 0; i < 16; i++)
+				fsa_dev_ptr->identifier[i] =
+					dresp->mnt[0].fileinfo.bdevinfo
+								.identifier[i];
 			fsa_dev_ptr->valid = 1;
 			/* sense_key holds the current state of the spin-up */
 			if (dresp->mnt[0].state & cpu_to_le32(FSCS_NOT_READY))
@@ -929,6 +944,28 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 	inqstrcpy ("V1.0", str->prl);
 }
 
+static void build_vpd83_type3(struct tvpd_page83 *vpdpage83data,
+		struct aac_dev *dev, struct scsi_cmnd *scsicmd)
+{
+	int container;
+
+	vpdpage83data->type3.codeset = 1;
+	vpdpage83data->type3.identifiertype = 3;
+	vpdpage83data->type3.identifierlength = sizeof(vpdpage83data->type3)
+			- 4;
+
+	for (container = 0; container < dev->maximum_num_containers;
+			container++) {
+
+		if (scmd_id(scsicmd) == container) {
+			memcpy(vpdpage83data->type3.Identifier,
+					dev->fsa_dev[container].identifier,
+					16);
+			break;
+		}
+	}
+}
+
 static void get_container_serial_callback(void *context, struct fib * fibptr)
 {
 	struct aac_get_serial_resp * get_serial_reply;
@@ -946,39 +983,47 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 		/*Check to see if it's for VPD 0x83 or 0x80 */
 		if (scsicmd->cmnd[2] == 0x83) {
 			/* vpd page 0x83 - Device Identification Page */
+			struct aac_dev *dev;
 			int i;
-			TVPD_Page83 VPDPage83Data;
+			struct tvpd_page83 vpdpage83data;
 
-			memset(((u8 *)&VPDPage83Data), 0,
-			       sizeof(VPDPage83Data));
+			dev = (struct aac_dev *)scsicmd->device->host->hostdata;
+
+			memset(((u8 *)&vpdpage83data), 0,
+			       sizeof(vpdpage83data));
 
 			/* DIRECT_ACCESS_DEVIC */
-			VPDPage83Data.DeviceType = 0;
+			vpdpage83data.DeviceType = 0;
 			/* DEVICE_CONNECTED */
-			VPDPage83Data.DeviceTypeQualifier = 0;
+			vpdpage83data.DeviceTypeQualifier = 0;
 			/* VPD_DEVICE_IDENTIFIERS */
-			VPDPage83Data.PageCode = 0x83;
-			VPDPage83Data.Reserved = 0;
-			VPDPage83Data.PageLength =
-				sizeof(VPDPage83Data.IdDescriptorType1) +
-				sizeof(VPDPage83Data.IdDescriptorType2);
+			vpdpage83data.PageCode = 0x83;
+			vpdpage83data.reserved = 0;
+			vpdpage83data.PageLength =
+				sizeof(vpdpage83data.type1) +
+				sizeof(vpdpage83data.type2);
+
+			/* VPD 83 Type 3 is not supported for ARC */
+			if (dev->sa_firmware)
+				vpdpage83data.PageLength +=
+				sizeof(vpdpage83data.type3);
 
 			/* T10 Vendor Identifier Field Format */
-			/* VpdCodeSetAscii */
-			VPDPage83Data.IdDescriptorType1.CodeSet = 2;
+			/* VpdcodesetAscii */
+			vpdpage83data.type1.codeset = 2;
 			/* VpdIdentifierTypeVendorId */
-			VPDPage83Data.IdDescriptorType1.IdentifierType = 1;
-			VPDPage83Data.IdDescriptorType1.IdentifierLength =
-				sizeof(VPDPage83Data.IdDescriptorType1) - 4;
+			vpdpage83data.type1.identifiertype = 1;
+			vpdpage83data.type1.identifierlength =
+				sizeof(vpdpage83data.type1) - 4;
 
 			/* "ADAPTEC " for adaptec */
-			memcpy(VPDPage83Data.IdDescriptorType1.VendId,
+			memcpy(vpdpage83data.type1.venid,
 				"ADAPTEC ",
-				sizeof(VPDPage83Data.IdDescriptorType1.VendId));
-			memcpy(VPDPage83Data.IdDescriptorType1.ProductId,
+				sizeof(vpdpage83data.type1.venid));
+			memcpy(vpdpage83data.type1.productid,
 				"ARRAY           ",
 				sizeof(
-				VPDPage83Data.IdDescriptorType1.ProductId));
+				vpdpage83data.type1.productid));
 
 			/* Convert to ascii based serial number.
 			 * The LSB is the the end.
@@ -987,32 +1032,41 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 				u8 temp =
 					(u8)((get_serial_reply->uid >> ((7 - i) * 4)) & 0xF);
 				if (temp  > 0x9) {
-					VPDPage83Data.IdDescriptorType1.SerialNumber[i] =
+					vpdpage83data.type1.serialnumber[i] =
 							'A' + (temp - 0xA);
 				} else {
-					VPDPage83Data.IdDescriptorType1.SerialNumber[i] =
+					vpdpage83data.type1.serialnumber[i] =
 							'0' + temp;
 				}
 			}
 
 			/* VpdCodeSetBinary */
-			VPDPage83Data.IdDescriptorType2.CodeSet = 1;
-			/* VpdIdentifierTypeEUI64 */
-			VPDPage83Data.IdDescriptorType2.IdentifierType = 2;
-			VPDPage83Data.IdDescriptorType2.IdentifierLength =
-				sizeof(VPDPage83Data.IdDescriptorType2) - 4;
+			vpdpage83data.type2.codeset = 1;
+			/* VpdidentifiertypeEUI64 */
+			vpdpage83data.type2.identifiertype = 2;
+			vpdpage83data.type2.identifierlength =
+				sizeof(vpdpage83data.type2) - 4;
 
-			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[0] = 0xD0;
-			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[1] = 0;
-			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[2] = 0;
+			vpdpage83data.type2.eu64id.venid[0] = 0xD0;
+			vpdpage83data.type2.eu64id.venid[1] = 0;
+			vpdpage83data.type2.eu64id.venid[2] = 0;
 
-			VPDPage83Data.IdDescriptorType2.EU64Id.Serial =
+			vpdpage83data.type2.eu64id.Serial =
 							get_serial_reply->uid;
-			VPDPage83Data.IdDescriptorType2.EU64Id.Reserved = 0;
+			vpdpage83data.type2.eu64id.reserved = 0;
+
+			/*
+			 * VpdIdentifierTypeFCPHName
+			 * VPD 0x83 Type 3 not supported for ARC
+			 */
+			if (dev->sa_firmware) {
+				build_vpd83_type3(&vpdpage83data,
+						dev, scsicmd);
+			}
 
 			/* Move the inquiry data to the response buffer. */
-			scsi_sg_copy_from_buffer(scsicmd, &VPDPage83Data,
-						 sizeof(VPDPage83Data));
+			scsi_sg_copy_from_buffer(scsicmd, &vpdpage83data,
+						 sizeof(vpdpage83data));
 		} else {
 			/* It must be for VPD 0x80 */
 			char sp[13];
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 814310a..58bb7a6 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2110,6 +2110,8 @@ struct aac_fsinfo {
 
 struct  aac_blockdevinfo {
 	__le32	block_size;
+	__le32  logical_phys_map;
+	u8	identifier[16];
 };
 
 union aac_contentinfo {
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0b06d1d..d86c178 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -548,8 +548,39 @@ static struct device_attribute aac_raid_level_attr = {
 	.show = aac_show_raid_level
 };
 
+static ssize_t aac_show_unique_id(struct device *dev,
+	     struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct aac_dev *aac = (struct aac_dev *)(sdev->host->hostdata);
+	unsigned char sn[16];
+
+	memset(sn, 0, sizeof(sn));
+
+	if (sdev_channel(sdev) == CONTAINER_CHANNEL)
+		memcpy(sn, aac->fsa_dev[sdev_id(sdev)].identifier, sizeof(sn));
+
+	return snprintf(buf, 16 * 2 + 2,
+		"%02X%02X%02X%02X%02X%02X%02X%02X %02X%02X%02X%02X%02X%02X%02X%02X\n",
+		sn[0], sn[1], sn[2], sn[3],
+		sn[4], sn[5], sn[6], sn[7],
+		sn[8], sn[9], sn[10], sn[11],
+		sn[12], sn[13], sn[14], sn[15]);
+}
+
+static struct device_attribute aac_unique_id_attr = {
+	.attr = {
+		.name = "unique_id",
+		.mode = 0444,
+	},
+	.show = aac_show_unique_id
+};
+
+
+
 static struct device_attribute *aac_dev_attrs[] = {
 	&aac_raid_level_attr,
+	&aac_unique_id_attr,
 	NULL,
 };
 
-- 
2.7.4

