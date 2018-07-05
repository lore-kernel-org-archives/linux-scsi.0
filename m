From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/4] scsi: aacraid: remove AAC_STAT_GOOD define
Date: Thu,  5 Jul 2018 13:01:37 +0200
Message-ID: <20180705110140.19545-2-jthumshirn@suse.de>
References: <20180705110140.19545-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705110140.19545-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Dave Carroll <david.carroll@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

Remove the AAC_STAT_GOOD definition and open code it in the places it
was used.

This will make subsequent refactoring in this area easier.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dave Carroll <david.carroll@microsemi.com>
Cc: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index a9831bd37a73..0b34d275523d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -115,8 +115,6 @@
 #define ASENCODE_LUN_FAILED_SELF_CONFIG		0x00
 #define ASENCODE_OVERLAPPED_COMMAND		0x00
 
-#define AAC_STAT_GOOD (DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD)
-
 #define BYTE0(x) (unsigned char)(x)
 #define BYTE1(x) (unsigned char)((x) >> 8)
 #define BYTE2(x) (unsigned char)((x) >> 16)
@@ -2962,7 +2960,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 
 	case SYNCHRONIZE_CACHE:
 		if (((aac_cache & 6) == 6) && dev->cache_protected) {
-			scsicmd->result = AAC_STAT_GOOD;
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+					  SAM_STAT_GOOD;
 			break;
 		}
 		/* Issue FIB to tell Firmware to flush it's cache */
@@ -2990,7 +2989,9 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				arr[1] = scsicmd->cmnd[2];
 				scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 							 sizeof(inq_data));
-				scsicmd->result = AAC_STAT_GOOD;
+				scsicmd->result = DID_OK << 16 |
+						  COMMAND_COMPLETE << 8 |
+						  SAM_STAT_GOOD;
 			} else if (scsicmd->cmnd[2] == 0x80) {
 				/* unit serial number page */
 				arr[3] = setinqserial(dev, &arr[4],
@@ -3001,7 +3002,9 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				scsicmd->result = AAC_STAT_GOOD;
+				scsicmd->result = DID_OK << 16 |
+						  COMMAND_COMPLETE << 8 |
+						  SAM_STAT_GOOD;
 			} else if (scsicmd->cmnd[2] == 0x83) {
 				/* vpd page 0x83 - Device Identification Page */
 				char *sno = (char *)&inq_data;
@@ -3010,7 +3013,9 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				scsicmd->result = AAC_STAT_GOOD;
+				scsicmd->result = DID_OK << 16 |
+						  COMMAND_COMPLETE << 8 |
+						  SAM_STAT_GOOD;
 			} else {
 				/* vpd page not implemented */
 				scsicmd->result = DID_OK << 16 |
@@ -3041,7 +3046,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 						 sizeof(inq_data));
-			scsicmd->result = AAC_STAT_GOOD;
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+					  SAM_STAT_GOOD;
 			break;
 		}
 		if (dev->in_reset)
@@ -3090,7 +3096,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
 
-		scsicmd->result = AAC_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				  SAM_STAT_GOOD;
 		break;
 	}
 
@@ -3116,7 +3123,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
-		scsicmd->result = AAC_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				  SAM_STAT_GOOD;
 		break;
 	}
 
@@ -3195,7 +3203,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd,
 					 (char *)&mpd,
 					 mode_buf_length);
-		scsicmd->result = AAC_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				  SAM_STAT_GOOD;
 		break;
 	}
 	case MODE_SENSE_10:
@@ -3272,7 +3281,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 					 (char *)&mpd10,
 					 mode_buf_length);
 
-		scsicmd->result = AAC_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				  SAM_STAT_GOOD;
 		break;
 	}
 	case REQUEST_SENSE:
@@ -3281,7 +3291,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				sizeof(struct sense_data));
 		memset(&dev->fsa_dev[cid].sense_data, 0,
 				sizeof(struct sense_data));
-		scsicmd->result = AAC_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				  SAM_STAT_GOOD;
 		break;
 
 	case ALLOW_MEDIUM_REMOVAL:
@@ -3291,7 +3302,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		else
 			fsa_dev_ptr[cid].locked = 0;
 
-		scsicmd->result = AAC_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				  SAM_STAT_GOOD;
 		break;
 	/*
 	 *	These commands are all No-Ops
@@ -3315,7 +3327,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 	case REZERO_UNIT:
 	case REASSIGN_BLOCKS:
 	case SEEK_10:
-		scsicmd->result = AAC_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				  SAM_STAT_GOOD;
 		break;
 
 	case START_STOP:
-- 
2.16.4
