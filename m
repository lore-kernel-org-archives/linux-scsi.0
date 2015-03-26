From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 05/11] aacraid: vpd page code 0x83 support
Date: Thu, 26 Mar 2015 10:41:26 -0400
Message-ID: <1427380892-1978-6-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37891 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbbCZOrq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:47:46 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add vpd page code 0x83 support

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c |  165 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 153 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index aee3eaa..09027e9 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -163,6 +163,48 @@ struct inquiry_data {
 	u8 inqd_prl[4];	/* Product Revision Level */
 };
 
+/* Added for VPD 0x83 */
+typedef struct {
+	u8 CodeSet:4;	/* VPD_CODE_SET */
+	u8 Reserved:4;
+	u8 IdentifierType:4;	/* VPD_IDENTIFIER_TYPE */
+	u8 Reserved2:4;
+	u8 Reserved3;
+	u8 IdentifierLength;
+	u8 VendId[8];
+	u8 ProductId[16];
+	u8 SerialNumber[8];	/* SN in ASCII */
+
+} TVPD_ID_Descriptor_Type_1;
+
+typedef struct {
+	u8 CodeSet:4;	/* VPD_CODE_SET */
+	u8 Reserved:4;
+	u8 IdentifierType:4;	/* VPD_IDENTIFIER_TYPE */
+	u8 Reserved2:4;
+	u8 Reserved3;
+	u8 IdentifierLength;
+	struct TEU64Id {
+		u32 Serial;
+		 /* The serial number supposed to be 40 bits,
+		  * bit we only support 32, so make the last byte zero. */
+		u8 Reserved;
+		u8 VendId[3];
+	} EU64Id;
+
+} TVPD_ID_Descriptor_Type_2;
+
+typedef struct {
+	u8 DeviceType:5;
+	u8 DeviceTypeQualifier:3;
+	u8 PageCode;
+	u8 Reserved;
+	u8 PageLength;
+	TVPD_ID_Descriptor_Type_1 IdDescriptorType1;
+	TVPD_ID_Descriptor_Type_2 IdDescriptorType2;
+
+} TVPD_Page83;
+
 /*
  *              M O D U L E   G L O B A L S
  */
@@ -890,14 +932,88 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 	get_serial_reply = (struct aac_get_serial_resp *) fib_data(fibptr);
 	/* Failure is irrelevant, using default value instead */
 	if (le32_to_cpu(get_serial_reply->status) == CT_OK) {
-		char sp[13];
-		/* EVPD bit set */
-		sp[0] = INQD_PDT_DA;
-		sp[1] = scsicmd->cmnd[2];
-		sp[2] = 0;
-		sp[3] = snprintf(sp+4, sizeof(sp)-4, "%08X",
-		  le32_to_cpu(get_serial_reply->uid));
-		scsi_sg_copy_from_buffer(scsicmd, sp, sizeof(sp));
+		/*Check to see if it's for VPD 0x83 or 0x80 */
+		if (scsicmd->cmnd[2] == 0x83) {
+			/* vpd page 0x83 - Device Identification Page */
+			int i;
+			TVPD_Page83 VPDPage83Data;
+
+			memset(((u8 *)&VPDPage83Data), 0,
+			       sizeof(VPDPage83Data));
+
+			/* DIRECT_ACCESS_DEVIC */
+			VPDPage83Data.DeviceType = 0;
+			/* DEVICE_CONNECTED */
+			VPDPage83Data.DeviceTypeQualifier = 0;
+			/* VPD_DEVICE_IDENTIFIERS */
+			VPDPage83Data.PageCode = 0x83;
+			VPDPage83Data.Reserved = 0;
+			VPDPage83Data.PageLength =
+				sizeof(VPDPage83Data.IdDescriptorType1) +
+				sizeof(VPDPage83Data.IdDescriptorType2);
+
+			/* T10 Vendor Identifier Field Format */
+			/* VpdCodeSetAscii */
+			VPDPage83Data.IdDescriptorType1.CodeSet = 2;
+			/* VpdIdentifierTypeVendorId */
+			VPDPage83Data.IdDescriptorType1.IdentifierType = 1;
+			VPDPage83Data.IdDescriptorType1.IdentifierLength =
+				sizeof(VPDPage83Data.IdDescriptorType1) - 4;
+
+			/* "ADAPTEC " for adaptec */
+			memcpy(VPDPage83Data.IdDescriptorType1.VendId,
+				"ADAPTEC ",
+				sizeof(VPDPage83Data.IdDescriptorType1.VendId));
+			memcpy(VPDPage83Data.IdDescriptorType1.ProductId,
+				"ARRAY           ",
+				sizeof(
+				VPDPage83Data.IdDescriptorType1.ProductId));
+
+			/* Convert to ascii based serial number.
+			 * The LSB is the the end.
+			 */
+			for (i = 0; i < 8; i++) {
+				u8 temp =
+					(u8)((get_serial_reply->uid >> ((7 - i) * 4)) & 0xF);
+				if (temp  > 0x9) {
+					VPDPage83Data.IdDescriptorType1.SerialNumber[i] =
+							'A' + (temp - 0xA);
+				} else {
+					VPDPage83Data.IdDescriptorType1.SerialNumber[i] =
+							'0' + temp;
+				}
+			}
+
+			/* VpdCodeSetBinary */
+			VPDPage83Data.IdDescriptorType2.CodeSet = 1;
+			/* VpdIdentifierTypeEUI64 */
+			VPDPage83Data.IdDescriptorType2.IdentifierType = 2;
+			VPDPage83Data.IdDescriptorType2.IdentifierLength =
+				sizeof(VPDPage83Data.IdDescriptorType2) - 4;
+
+			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[0] = 0xD0;
+			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[1] = 0;
+			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[2] = 0;
+
+			VPDPage83Data.IdDescriptorType2.EU64Id.Serial =
+							get_serial_reply->uid;
+			VPDPage83Data.IdDescriptorType2.EU64Id.Reserved = 0;
+
+			/* Move the inquiry data to the response buffer. */
+			scsi_sg_copy_from_buffer(scsicmd, &VPDPage83Data,
+						 sizeof(VPDPage83Data));
+		} else {
+			/* It must be for VPD 0x80 */
+			char sp[13];
+			/* EVPD bit set */
+			sp[0] = INQD_PDT_DA;
+			sp[1] = scsicmd->cmnd[2];
+			sp[2] = 0;
+			sp[3] = snprintf(sp+4, sizeof(sp)-4, "%08X",
+				le32_to_cpu(get_serial_reply->uid));
+			scsi_sg_copy_from_buffer(scsicmd, sp,
+						 sizeof(sp));
+		}
 	}
 
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
@@ -2309,9 +2425,10 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			  INQD_PDT_PROC : INQD_PDT_DA;
 			if (scsicmd->cmnd[2] == 0) {
 				/* supported vital product data pages */
-				arr[3] = 2;
+				arr[3] = 3;
 				arr[4] = 0x0;
 				arr[5] = 0x80;
+				arr[6] = 0x83;
 				arr[1] = scsicmd->cmnd[2];
 				scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 							 sizeof(inq_data));
@@ -2327,7 +2444,16 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				/* SLES 10 SP1 special */
+				scsicmd->result = DID_OK << 16 |
+				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+			} else if (scsicmd->cmnd[2] == 0x83) {
+				/* vpd page 0x83 - Device Identification Page */
+				char *sno = (char *)&inq_data;
+				sno[3] = setinqserial(dev, &sno[4],
+						      scmd_id(scsicmd));
+				if (aac_wwn != 2)
+					return aac_get_container_serial(
+						scsicmd);
 				scsicmd->result = DID_OK << 16 |
 				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 			} else {
@@ -2482,6 +2608,18 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				(fsa_dev_ptr[cid].block_size >> 8) &  0xff;
 			mpd.bd.block_length[2] =
 				fsa_dev_ptr[cid].block_size  & 0xff;
+
+			mpd.mpc_buf[0] = scsicmd->cmnd[2];
+			if (scsicmd->cmnd[2] == 0x1C) {
+				/* page length */
+				mpd.mpc_buf[1] = 0xa;
+				/* Mode data length */
+				mpd.hd.data_length = 23;
+			} else {
+				/* Mode data length */
+				mpd.hd.data_length = 15;
+			}
+
 			if (capacity > 0xffffff) {
 				mpd.bd.block_count[0] = 0xff;
 				mpd.bd.block_count[1] = 0xff;
@@ -2500,9 +2638,12 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			mpd.mpc_buf[2] = ((aac_cache & 6) == 2)
 				? 0 : 0x04; /* WCE */
 			mode_buf_length = sizeof(mpd);
-			if (mode_buf_length > scsicmd->cmnd[4])
-				mode_buf_length = scsicmd->cmnd[4];
 		}
+
+		if (mode_buf_length > scsicmd->cmnd[4])
+			mode_buf_length = scsicmd->cmnd[4];
+		else
+			mode_buf_length = sizeof(mpd);
 		scsi_sg_copy_from_buffer(scsicmd,
 					 (char *)&mpd,
 					 mode_buf_length);
-- 
1.7.7.3

