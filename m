From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/5] aacraid: simplify non-dasd support
Date: Wed, 30 Nov 2005 10:35:51 -0800
Message-ID: <1133375752.2288.21.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6286 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751490AbVK3Sfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 13:35:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

This no_uld_attach patch allows us to simplify the code surrounding the
'non-dasd' support options for aacraid and add a new feature.

The physical dasd components will now be exported by the driver write
protected, but the sd layer will not attach to them. The sg layer will
attach, and permit the various SCSI tools to perform operations on the
components.

This patch does not filter out Format or other destructive component
actions.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.


Index: scsi-misc-aac/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2005-11-28 14:56:46.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2005-11-28 15:15:02.000000000 -0800
@@ -61,6 +61,7 @@
 #define SENCODE_END_OF_DATA                     0x00
 #define SENCODE_BECOMING_READY                  0x04
 #define SENCODE_INIT_CMD_REQUIRED               0x04
+#define SENCODE_DATA_PROTECT                    0x0E
 #define SENCODE_PARAM_LIST_LENGTH_ERROR         0x1A
 #define SENCODE_INVALID_COMMAND                 0x20
 #define SENCODE_LBA_OUT_OF_RANGE                0x21
@@ -1511,7 +1512,32 @@
 				return 0;
 			}
 		} else {  /* check for physical non-dasd devices */
-			if(dev->nondasd_support == 1){
+			if(dev->nondasd_support == 1) {
+				if (scsicmd->device->no_uld_attach)
+					switch (scsicmd->cmnd[0]) {
+					/* Filter Format? SMART Verify/Fix? */
+					case WRITE_6:
+					case WRITE_10:
+					case WRITE_12:
+					case WRITE_16:
+						scsicmd->result = DID_OK << 16
+					  	| COMMAND_COMPLETE << 8
+					  	| SAM_STAT_CHECK_CONDITION;
+						set_sense((u8 *)
+					  	&dev->fsa_dev[cid].sense_data,
+					  	DATA_PROTECT,
+						SENCODE_DATA_PROTECT,
+					  	ASENCODE_END_OF_DATA,
+						0, 0, 0, 0);
+						memcpy(scsicmd->sense_buffer,
+					  	&dev->fsa_dev[cid].sense_data,
+					  	(sizeof(dev->fsa_dev[cid].sense_data)
+					      	> sizeof(scsicmd->sense_buffer))
+					    	? sizeof(scsicmd->sense_buffer)
+					    	: sizeof(dev->fsa_dev[cid].sense_data));
+						scsicmd->scsi_done(scsicmd);
+						return 0;
+					}
 				return aac_send_srb_fib(scsicmd);
 			} else {
 				scsicmd->result = DID_NO_CONNECT << 16;
@@ -1935,33 +1961,7 @@
 	case SRB_STATUS_ERROR_RECOVERY:
 	case SRB_STATUS_PENDING:
 	case SRB_STATUS_SUCCESS:
-		if(scsicmd->cmnd[0] == INQUIRY ){
-			u8 b;
-			u8 b1;
-			/* We can't expose disk devices because we can't tell whether they
-			 * are the raw container drives or stand alone drives.  If they have
-			 * the removable bit set then we should expose them though.
-			 */
-			b = (*(u8*)scsicmd->buffer)&0x1f;
-			b1 = ((u8*)scsicmd->buffer)[1];
-			if( b==TYPE_TAPE || b==TYPE_WORM || b==TYPE_ROM || b==TYPE_MOD|| b==TYPE_MEDIUM_CHANGER 
-					|| (b==TYPE_DISK && (b1&0x80)) ){
-				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
-			/*
-			 * We will allow disk devices if in RAID/SCSI mode and
-			 * the channel is 2
-			 */
-			} else if ((dev->raid_scsi_mode) &&
-					(scmd_channel(scsicmd) == 2)) {
-				scsicmd->result = DID_OK << 16 | 
-						COMMAND_COMPLETE << 8;
-			} else {
-				scsicmd->result = DID_NO_CONNECT << 16 | 
-						COMMAND_COMPLETE << 8;
-			}
-		} else {
-			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
-		}
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 		break;
 	case SRB_STATUS_DATA_OVERRUN:
 		switch(scsicmd->cmnd[0]){
@@ -1981,28 +1981,7 @@
 			scsicmd->result = DID_ERROR << 16 | COMMAND_COMPLETE << 8;
 			break;
 		case INQUIRY: {
-			u8 b;
-			u8 b1;
-			/* We can't expose disk devices because we can't tell whether they
-			* are the raw container drives or stand alone drives
-			*/
-			b = (*(u8*)scsicmd->buffer)&0x0f;
-			b1 = ((u8*)scsicmd->buffer)[1];
-			if( b==TYPE_TAPE || b==TYPE_WORM || b==TYPE_ROM || b==TYPE_MOD|| b==TYPE_MEDIUM_CHANGER
-					|| (b==TYPE_DISK && (b1&0x80)) ){
-				scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
-			/*
-			 * We will allow disk devices if in RAID/SCSI mode and
-			 * the channel is 2
-			 */
-			} else if ((dev->raid_scsi_mode) &&
-					(scmd_channel(scsicmd) == 2)) {
-				scsicmd->result = DID_OK << 16 | 
-						COMMAND_COMPLETE << 8;
-			} else {
-				scsicmd->result = DID_NO_CONNECT << 16 | 
-						COMMAND_COMPLETE << 8;
-			}
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 			break;
 		}
 		default:
Index: scsi-misc-aac/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2005-11-28 14:56:46.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2005-11-28 15:15:02.000000000 -0800
@@ -384,17 +384,42 @@
 
 static int aac_slave_configure(struct scsi_device *sdev)
 {
-	struct Scsi_Host *host = sdev->host;
+	if ((sdev->type == TYPE_DISK) && (sdev->channel != 0)) {
+		struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
+		if (!aac->raid_scsi_mode || (sdev->channel != 2))
+			sdev->no_uld_attach = 1;
+	}
+	if (sdev->tagged_supported && (sdev->type == TYPE_DISK)
+	 && (sdev->no_uld_attach == 0)
+	 && (sdev->channel == 0)) {
+		struct scsi_device * dev;
+		struct Scsi_Host *host = sdev->host;
+		unsigned num_lsu = 0;
+		unsigned num_one = 0;
+		unsigned depth;
 
-	if (sdev->tagged_supported)
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, 128);
-	else
+		__shost_for_each_device(dev, host) {
+			if (dev->tagged_supported && (dev->type == TYPE_DISK)
+			 && (dev->no_uld_attach == 0)
+			 && (dev->channel == 0))
+				++num_lsu;
+			else
+				++num_one;
+		}
+		if (num_lsu == 0)
+			++num_lsu;
+		depth = (host->can_queue - num_one) / num_lsu;
+		if (depth > 256)
+			depth = 256;
+		else if (depth < 2)
+			depth = 2;
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
+		if (!(((struct aac_dev *)host->hostdata)->adapter_info.options
+		  & AAC_OPT_NEW_COMM))
+			blk_queue_max_segment_size(sdev->request_queue, 65536);
+	} else
 		scsi_adjust_queue_depth(sdev, 0, 1);
 
-	if (!(((struct aac_dev *)host->hostdata)->adapter_info.options
-	  & AAC_OPT_NEW_COMM))
-		blk_queue_max_segment_size(sdev->request_queue, 65536);
-
 	return 0;
 }
 

-- 
Mark Haverkamp <markh@osdl.org>

