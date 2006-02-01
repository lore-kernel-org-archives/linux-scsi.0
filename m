From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/3] aacraid: use no_uld_attach flag
Date: Wed, 01 Feb 2006 09:30:44 -0800
Message-ID: <1138815045.27662.14.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:23439 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1422676AbWBARar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 12:30:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received From Mark Salyzyn.

In order to support user tools accessing the array components (SMART,
Mode Page information, Cache page adjustments, WWN determination,
Firmware updates etc), we take advantage of the no_uld_attach flag and
deprecate the code that filters Inquiries to block the requests to array
components. The quirk prevents the sd layer from attaching to the
components.

We also took the opportunity to balance the queue depths based on the
total adapter queue depth to the array devices to reduce the chances of
starvation.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-01-31 09:35:28.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-02-01 09:02:10.000000000 -0800
@@ -1465,7 +1465,7 @@
 	 *	itself.
 	 */
 	if (scmd_id(scsicmd) != host->this_id) {
-		if ((scsicmd->device->channel == 0) ){
+		if ((scsicmd->device->channel == CONTAINER_CHANNEL)) {
 			if( (scsicmd->device->id >= dev->maximum_num_containers) || (scsicmd->device->lun != 0)){ 
 				scsicmd->result = DID_NO_CONNECT << 16;
 				scsicmd->scsi_done(scsicmd);
@@ -1935,33 +1935,7 @@
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
@@ -1981,28 +1955,7 @@
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
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-01-31 09:35:42.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-02-01 09:02:16.000000000 -0800
@@ -385,21 +385,45 @@
 
 static int aac_slave_configure(struct scsi_device *sdev)
 {
-	struct Scsi_Host *host = sdev->host;
 	if (sdev_channel(sdev) == CONTAINER_CHANNEL) {
 		sdev->skip_ms_page_8 = 1;
 		sdev->skip_ms_page_3f = 1;
 	}
+	if ((sdev->type == TYPE_DISK) &&
+			(sdev_channel(sdev) != CONTAINER_CHANNEL)) {
+		struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
+		if (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))
+			sdev->no_uld_attach = 1;
+	}
+	if (sdev->tagged_supported && (sdev->type == TYPE_DISK) &&
+			(sdev_channel(sdev) == CONTAINER_CHANNEL)) {
+		struct scsi_device * dev;
+		struct Scsi_Host *host = sdev->host;
+		unsigned num_lsu = 0;
+		unsigned num_one = 0;
+		unsigned depth;
 
-	if (sdev->tagged_supported)
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, 128);
-	else
+		__shost_for_each_device(dev, host) {
+			if (dev->tagged_supported && (dev->type == TYPE_DISK) &&
+				(sdev_channel(dev) == CONTAINER_CHANNEL))
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
+		if (!(((struct aac_dev *)host->hostdata)->adapter_info.options &
+				AAC_OPT_NEW_COMM))
+			blk_queue_max_segment_size(sdev->request_queue, 65536);
+	} else
 		scsi_adjust_queue_depth(sdev, 0, 1);
 
-	if (!(((struct aac_dev *)host->hostdata)->adapter_info.options
-	  & AAC_OPT_NEW_COMM))
-		blk_queue_max_segment_size(sdev->request_queue, 65536);
-
 	return 0;
 }
 
@@ -874,7 +898,7 @@
  
  	/*
 	 * max channel will be the physical channels plus 1 virtual channel
-	 * all containers are on the virtual channel 0
+	 * all containers are on the virtual channel 0 (CONTAINER_CHANNEL)
 	 * physical channels are address by their actual physical number+1
 	 */
 	if (aac->nondasd_support == 1)

-- 
Mark Haverkamp <markh@osdl.org>

