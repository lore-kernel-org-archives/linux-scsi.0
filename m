From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V4 06/24] aacraid: Reworked scsi command submission path
Date: Thu, 2 Feb 2017 15:53:20 -0800
Message-ID: <20170202235338.14724-7-RaghavaAditya.Renukunta@microsemi.com>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr730056.outbound.protection.outlook.com ([40.107.73.56]:13080
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752556AbdBCGat (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 01:30:49 -0500
In-Reply-To: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de

Moved the READ and WRITE switch cases to the top. Added a  default
case to the switch case and replaced duplicate scsi result value with a
macro.

The idea is that since most of scsi commands we care about performance
wise are read or write, we need to process them first.

Internally the compiler (GCC) converts a switch case into either a jump
table or a bunch of if else conditions, so placing the often used read,
write cases at the top is an effort in optimization.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---

Changes in  V2:
None

Changes in  V3:
None

Changes in  V4:
None

 drivers/scsi/aacraid/aachba.c | 172 +++++++++++++++++-------------------------
 1 file changed, 70 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index f2ec795..e7456a0 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -106,6 +106,8 @@
 #define ASENCODE_LUN_FAILED_SELF_CONFIG		0x00
 #define ASENCODE_OVERLAPPED_COMMAND		0x00
 
+#define AAC_STAT_GOOD (DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD)
+
 #define BYTE0(x) (unsigned char)(x)
 #define BYTE1(x) (unsigned char)((x) >> 8)
 #define BYTE2(x) (unsigned char)((x) >> 16)
@@ -2476,8 +2478,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			if((cid >= dev->maximum_num_containers) ||
 					(scsicmd->device->lun != 0)) {
 				scsicmd->result = DID_NO_CONNECT << 16;
-				scsicmd->scsi_done(scsicmd);
-				return 0;
+				goto scsi_done_ret;
 			}
 
 			/*
@@ -2512,8 +2513,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				return aac_send_srb_fib(scsicmd);
 			} else {
 				scsicmd->result = DID_NO_CONNECT << 16;
-				scsicmd->scsi_done(scsicmd);
-				return 0;
+				goto scsi_done_ret;
 			}
 		}
 	}
@@ -2531,13 +2531,34 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
-		scsicmd->scsi_done(scsicmd);
-		return 0;
+		goto scsi_done_ret;
 	}
 
-
-	/* Handle commands here that don't really require going out to the adapter */
 	switch (scsicmd->cmnd[0]) {
+	case READ_6:
+	case READ_10:
+	case READ_12:
+	case READ_16:
+		if (dev->in_reset)
+			return -1;
+		return aac_read(scsicmd);
+
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+		if (dev->in_reset)
+			return -1;
+		return aac_write(scsicmd);
+
+	case SYNCHRONIZE_CACHE:
+		if (((aac_cache & 6) == 6) && dev->cache_protected) {
+			scsicmd->result = AAC_STAT_GOOD;
+			break;
+		}
+		/* Issue FIB to tell Firmware to flush it's cache */
+		if ((aac_cache & 6) != 2)
+			return aac_synchronize(scsicmd);
 	case INQUIRY:
 	{
 		struct inquiry_data inq_data;
@@ -2560,8 +2581,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				arr[1] = scsicmd->cmnd[2];
 				scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 							 sizeof(inq_data));
-				scsicmd->result = DID_OK << 16 |
-				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+				scsicmd->result = AAC_STAT_GOOD;
 			} else if (scsicmd->cmnd[2] == 0x80) {
 				/* unit serial number page */
 				arr[3] = setinqserial(dev, &arr[4],
@@ -2572,8 +2592,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				scsicmd->result = DID_OK << 16 |
-				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+				scsicmd->result = AAC_STAT_GOOD;
 			} else if (scsicmd->cmnd[2] == 0x83) {
 				/* vpd page 0x83 - Device Identification Page */
 				char *sno = (char *)&inq_data;
@@ -2582,8 +2601,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				if (aac_wwn != 2)
 					return aac_get_container_serial(
 						scsicmd);
-				scsicmd->result = DID_OK << 16 |
-				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+				scsicmd->result = AAC_STAT_GOOD;
 			} else {
 				/* vpd page not implemented */
 				scsicmd->result = DID_OK << 16 |
@@ -2598,8 +2616,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 					sizeof(dev->fsa_dev[cid].sense_data),
 					SCSI_SENSE_BUFFERSIZE));
 			}
-			scsicmd->scsi_done(scsicmd);
-			return 0;
+			break;
 		}
 		inq_data.inqd_ver = 2;	/* claim compliance to SCSI-2 */
 		inq_data.inqd_rdf = 2;	/* A response data format value of two indicates that the data shall be in the format specified in SCSI-2 */
@@ -2615,9 +2632,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 						 sizeof(inq_data));
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-			scsicmd->scsi_done(scsicmd);
-			return 0;
+			scsicmd->result = AAC_STAT_GOOD;
+			break;
 		}
 		if (dev->in_reset)
 			return -1;
@@ -2665,10 +2681,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		scsicmd->scsi_done(scsicmd);
-
-		return 0;
+		scsicmd->result = AAC_STAT_GOOD;
+		break;
 	}
 
 	case READ_CAPACITY:
@@ -2693,11 +2707,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
-		  SAM_STAT_GOOD;
-		scsicmd->scsi_done(scsicmd);
-
-		return 0;
+		scsicmd->result = AAC_STAT_GOOD;
+		break;
 	}
 
 	case MODE_SENSE:
@@ -2775,10 +2786,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		scsi_sg_copy_from_buffer(scsicmd,
 					 (char *)&mpd,
 					 mode_buf_length);
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		scsicmd->scsi_done(scsicmd);
-
-		return 0;
+		scsicmd->result = AAC_STAT_GOOD;
+		break;
 	}
 	case MODE_SENSE_10:
 	{
@@ -2854,18 +2863,17 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 					 (char *)&mpd10,
 					 mode_buf_length);
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		scsicmd->scsi_done(scsicmd);
-
-		return 0;
+		scsicmd->result = AAC_STAT_GOOD;
+		break;
 	}
 	case REQUEST_SENSE:
 		dprintk((KERN_DEBUG "REQUEST SENSE command.\n"));
-		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data, sizeof (struct sense_data));
-		memset(&dev->fsa_dev[cid].sense_data, 0, sizeof (struct sense_data));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		scsicmd->scsi_done(scsicmd);
-		return 0;
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+				sizeof(struct sense_data));
+		memset(&dev->fsa_dev[cid].sense_data, 0,
+				sizeof(struct sense_data));
+		scsicmd->result = AAC_STAT_GOOD;
+		break;
 
 	case ALLOW_MEDIUM_REMOVAL:
 		dprintk((KERN_DEBUG "LOCK command.\n"));
@@ -2874,9 +2882,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		else
 			fsa_dev_ptr[cid].locked = 0;
 
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		scsicmd->scsi_done(scsicmd);
-		return 0;
+		scsicmd->result = AAC_STAT_GOOD;
+		break;
 	/*
 	 *	These commands are all No-Ops
 	 */
@@ -2892,80 +2899,41 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			       min_t(size_t,
 				     sizeof(dev->fsa_dev[cid].sense_data),
 				     SCSI_SENSE_BUFFERSIZE));
-			scsicmd->scsi_done(scsicmd);
-			return 0;
+		break;
 		}
-		/* FALLTHRU */
 	case RESERVE:
 	case RELEASE:
 	case REZERO_UNIT:
 	case REASSIGN_BLOCKS:
 	case SEEK_10:
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		scsicmd->scsi_done(scsicmd);
-		return 0;
+		scsicmd->result = AAC_STAT_GOOD;
+		break;
 
 	case START_STOP:
 		return aac_start_stop(scsicmd);
-	}
 
-	switch (scsicmd->cmnd[0])
-	{
-		case READ_6:
-		case READ_10:
-		case READ_12:
-		case READ_16:
-			if (dev->in_reset)
-				return -1;
-			/*
-			 *	Hack to keep track of ordinal number of the device that
-			 *	corresponds to a container. Needed to convert
-			 *	containers to /dev/sd device names
-			 */
-
-			if (scsicmd->request->rq_disk)
-				strlcpy(fsa_dev_ptr[cid].devname,
-				scsicmd->request->rq_disk->disk_name,
-				min(sizeof(fsa_dev_ptr[cid].devname),
-				sizeof(scsicmd->request->rq_disk->disk_name) + 1));
-
-			return aac_read(scsicmd);
-
-		case WRITE_6:
-		case WRITE_10:
-		case WRITE_12:
-		case WRITE_16:
-			if (dev->in_reset)
-				return -1;
-			return aac_write(scsicmd);
-
-		case SYNCHRONIZE_CACHE:
-			if (((aac_cache & 6) == 6) && dev->cache_protected) {
-				scsicmd->result = DID_OK << 16 |
-					COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-				scsicmd->scsi_done(scsicmd);
-				return 0;
-			}
-			/* Issue FIB to tell Firmware to flush it's cache */
-			if ((aac_cache & 6) != 2)
-				return aac_synchronize(scsicmd);
-			/* FALLTHRU */
-		default:
-			/*
-			 *	Unhandled commands
-			 */
-			dprintk((KERN_WARNING "Unhandled SCSI Command: 0x%x.\n", scsicmd->cmnd[0]));
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-			set_sense(&dev->fsa_dev[cid].sense_data,
+	/* FALLTHRU */
+	default:
+	/*
+	 *	Unhandled commands
+	 */
+		dprintk((KERN_WARNING "Unhandled SCSI Command: 0x%x.\n",
+				scsicmd->cmnd[0]));
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				SAM_STAT_CHECK_CONDITION;
+		set_sense(&dev->fsa_dev[cid].sense_data,
 			  ILLEGAL_REQUEST, SENCODE_INVALID_COMMAND,
 			  ASENCODE_INVALID_COMMAND, 0, 0);
-			memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 				min_t(size_t,
 				      sizeof(dev->fsa_dev[cid].sense_data),
 				      SCSI_SENSE_BUFFERSIZE));
-			scsicmd->scsi_done(scsicmd);
-			return 0;
 	}
+
+scsi_done_ret:
+
+	scsicmd->scsi_done(scsicmd);
+	return 0;
 }
 
 static int query_disk(struct aac_dev *dev, void __user *arg)
-- 
2.7.4
