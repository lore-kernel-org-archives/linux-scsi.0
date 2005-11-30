From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] aacraid: simplify non-dasd support
Date: Wed, 30 Nov 2005 19:12:24 +0000
Message-ID: <20051130191224.GA19001@infradead.org>
References: <1133375752.2288.21.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10690 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751530AbVK3TM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:12:26 -0500
Content-Disposition: inline
In-Reply-To: <1133375752.2288.21.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, Nov 30, 2005 at 10:35:51AM -0800, Mark Haverkamp wrote:
> Received from Mark Salyzyn.
> 
> This no_uld_attach patch allows us to simplify the code surrounding the
> 'non-dasd' support options for aacraid and add a new feature.
> 
> The physical dasd components will now be exported by the driver write
> protected, but the sd layer will not attach to them. The sg layer will
> attach, and permit the various SCSI tools to perform operations on the
> components.
> 
> This patch does not filter out Format or other destructive component
> actions.

NACK on the write filter.  If we can agree on it beeing useful (and I must
admit I tend to the contrary opinion) it should be done in higher layers.

The slave_configure code is not coding style conformant and hard to
understand.  The version below tries to make it a little more understandable
but it's seriously lacking comments.

Also why do we need the !sdev->no_uld_attach && !sdev->channel checks?
We only ever no_uld_attach if we have a non-zero non-two channel number.


Index: linux-2.6/drivers/scsi/aacraid/aachba.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/aachba.c	2005-11-11 23:56:56.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/aachba.c	2005-11-30 19:55:04.000000000 +0100
@@ -61,6 +61,7 @@
 #define SENCODE_END_OF_DATA                     0x00
 #define SENCODE_BECOMING_READY                  0x04
 #define SENCODE_INIT_CMD_REQUIRED               0x04
+#define SENCODE_DATA_PROTECT                    0x0E
 #define SENCODE_PARAM_LIST_LENGTH_ERROR         0x1A
 #define SENCODE_INVALID_COMMAND                 0x20
 #define SENCODE_LBA_OUT_OF_RANGE                0x21
@@ -1935,33 +1936,7 @@
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
@@ -1981,28 +1956,7 @@
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
Index: linux-2.6/drivers/scsi/aacraid/linit.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/linit.c	2005-11-06 20:09:10.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/linit.c	2005-11-30 20:07:56.000000000 +0100
@@ -382,18 +382,48 @@
  *	A queue depth of one automatically disables tagged queueing.
  */
 
+static inline int is_raid_disk(struct scsi_device *sdev)
+{
+	return sdev->type == TYPE_DISK && sdev->tagged_supported &&
+		!sdev->no_uld_attach && !sdev->channel;
+}
+
 static int aac_slave_configure(struct scsi_device *sdev)
 {
-	struct Scsi_Host *host = sdev->host;
+	struct Scsi_Host *shost = sdev->host;
+	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
-	if (sdev->tagged_supported)
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, 128);
-	else
-		scsi_adjust_queue_depth(sdev, 0, 1);
+	if (sdev->type == TYPE_DISK && sdev->channel) {
+		if (!aac->raid_scsi_mode || sdev->channel != 2)
+			sdev->no_uld_attach = 1;
+	}
+
+	if (is_raid_disk(sdev)) {
+		struct scsi_device *sdev_iter;
+		unsigned num_lsu = 0, num_one = 0, depth;
+
+		__shost_for_each_device(sdev_iter, shost) {
+			if (is_raid_disk(sdev_iter))
+				num_lsu++;
+			else
+				num_one++;
+		}
 
-	if (!(((struct aac_dev *)host->hostdata)->adapter_info.options
-	  & AAC_OPT_NEW_COMM))
-		blk_queue_max_segment_size(sdev->request_queue, 65536);
+		if (num_lsu == 0)
+			++num_lsu;
+
+		depth = (shost->can_queue - num_one) / num_lsu;
+		if (depth > 256)
+			depth = 256;
+		else if (depth < 2)
+			depth = 2;
+
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
+		if (!(aac->adapter_info.options & AAC_OPT_NEW_COMM))
+			blk_queue_max_segment_size(sdev->request_queue, 65536);
+	} else {
+		scsi_adjust_queue_depth(sdev, 0, 1);
+	}
 
 	return 0;
 }
