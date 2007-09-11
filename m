From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 05/24] isd200.c: use one-element sg list in issuing commands
Date: Wed, 12 Sep 2007 02:53:36 +0300
Message-ID: <46E72A80.3090305@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27081 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755972AbXIKX5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 19:57:21 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


  - isd200_action() was still using direct linear pointers in issuing
    commands to the USB transport level. This is no longer supported,
    use one-element scatterlist instead.
  - Adjustment of command's length in the case of scsi-to-ata translation
    is now restored before return to queuecommand, since other wise it can
    leak BIOs.
  - isd200_action() return Error on unknown requests. Used to print an error
    but still try to send garbage cdb.
  - convert few places to scsi data accessors.
  - Todo: This file will need to be changed when scsi_cmnd changes to
    scsi_data_buffer or any other solution.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c |   66 +++++++++++++++++++++++++++++------------
 1 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 6831dca..a624b4e 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -49,6 +49,7 @@
 #include <linux/slab.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
+#include <linux/scatterlist.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -287,6 +288,7 @@ struct isd200_info {
 	/* maximum number of LUNs supported */
 	unsigned char MaxLUNs;
 	struct scsi_cmnd srb;
+	struct scatterlist sg;
 };
 
 
@@ -398,6 +400,31 @@ static void isd200_build_sense(struct us_data *us, struct scsi_cmnd *srb)
  * Transport routines
  ***********************************************************************/
 
+/**************************************************************************
+ *  isd200_set_srb(), isd200_srb_set_bufflen()
+ *
+ * Two helpers to facilitate in initialization of scsi_cmnd structure
+ * Will need to change when struct scsi_cmnd changes
+ */
+static void isd200_set_srb(struct isd200_info *info,
+	enum dma_data_direction dir, void* buff, unsigned bufflen)
+{
+	struct scsi_cmnd *srb = &info->srb;
+
+	if (buff)
+		sg_init_one(&info->sg, buff, bufflen);
+
+	srb->sc_data_direction = dir;
+	srb->request_buffer = buff ? &info->sg : NULL;
+	srb->request_bufflen = bufflen;
+	srb->use_sg = buff ? 1 : 0;
+}
+
+static void isd200_srb_set_bufflen(struct scsi_cmnd *srb, unsigned bufflen)
+{
+	srb->request_bufflen = bufflen;
+}
+
 
 /**************************************************************************
  *  isd200_action
@@ -432,9 +459,7 @@ static int isd200_action( struct us_data *us, int action,
 		ata.generic.RegisterSelect =
 		  REG_CYLINDER_LOW | REG_CYLINDER_HIGH |
 		  REG_STATUS | REG_ERROR;
-		srb->sc_data_direction = DMA_FROM_DEVICE;
-		srb->request_buffer = pointer;
-		srb->request_bufflen = value;
+		isd200_set_srb(info, DMA_FROM_DEVICE, pointer, value);
 		break;
 
 	case ACTION_ENUM:
@@ -444,7 +469,7 @@ static int isd200_action( struct us_data *us, int action,
 					   ACTION_SELECT_5;
 		ata.generic.RegisterSelect = REG_DEVICE_HEAD;
 		ata.write.DeviceHeadByte = value;
-		srb->sc_data_direction = DMA_NONE;
+		isd200_set_srb(info, DMA_NONE, NULL, 0);
 		break;
 
 	case ACTION_RESET:
@@ -453,7 +478,7 @@ static int isd200_action( struct us_data *us, int action,
 					   ACTION_SELECT_3|ACTION_SELECT_4;
 		ata.generic.RegisterSelect = REG_DEVICE_CONTROL;
 		ata.write.DeviceControlByte = ATA_DC_RESET_CONTROLLER;
-		srb->sc_data_direction = DMA_NONE;
+		isd200_set_srb(info, DMA_NONE, NULL, 0);
 		break;
 
 	case ACTION_REENABLE:
@@ -462,7 +487,7 @@ static int isd200_action( struct us_data *us, int action,
 					   ACTION_SELECT_3|ACTION_SELECT_4;
 		ata.generic.RegisterSelect = REG_DEVICE_CONTROL;
 		ata.write.DeviceControlByte = ATA_DC_REENABLE_CONTROLLER;
-		srb->sc_data_direction = DMA_NONE;
+		isd200_set_srb(info, DMA_NONE, NULL, 0);
 		break;
 
 	case ACTION_SOFT_RESET:
@@ -471,21 +496,20 @@ static int isd200_action( struct us_data *us, int action,
 		ata.generic.RegisterSelect = REG_DEVICE_HEAD | REG_COMMAND;
 		ata.write.DeviceHeadByte = info->DeviceHead;
 		ata.write.CommandByte = WIN_SRST;
-		srb->sc_data_direction = DMA_NONE;
+		isd200_set_srb(info, DMA_NONE, NULL, 0);
 		break;
 
 	case ACTION_IDENTIFY:
 		US_DEBUGP("   isd200_action(IDENTIFY)\n");
 		ata.generic.RegisterSelect = REG_COMMAND;
 		ata.write.CommandByte = WIN_IDENTIFY;
-		srb->sc_data_direction = DMA_FROM_DEVICE;
-		srb->request_buffer = (void *) info->id;
-		srb->request_bufflen = sizeof(struct hd_driveid);
+		isd200_set_srb(info, DMA_FROM_DEVICE, info->id,
+		                                sizeof(struct hd_driveid));
 		break;
 
 	default:
 		US_DEBUGP("Error: Undefined action %d\n",action);
-		break;
+		return ISD200_ERROR;
 	}
 
 	memcpy(srb->cmnd, &ata, sizeof(ata.generic));
@@ -590,7 +614,7 @@ static void isd200_invoke_transport( struct us_data *us,
 		return;
 	}
 
-	if ((srb->resid > 0) &&
+	if ((scsi_get_resid(srb) > 0) &&
 	    !((srb->cmnd[0] == REQUEST_SENSE) ||
 	      (srb->cmnd[0] == INQUIRY) ||
 	      (srb->cmnd[0] == MODE_SENSE) ||
@@ -1114,7 +1138,6 @@ static int isd200_get_inquiry_data( struct us_data *us )
 	return(retStatus);
 }
 
-
 /**************************************************************************
  * isd200_scsi_to_ata
  *									 
@@ -1163,7 +1186,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			ataCdb->generic.TransferBlockSize = 1;
 			ataCdb->generic.RegisterSelect = REG_COMMAND;
 			ataCdb->write.CommandByte = ATA_COMMAND_GET_MEDIA_STATUS;
-			srb->request_bufflen = 0;
+			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			US_DEBUGP("   Media Status not supported, just report okay\n");
 			srb->result = SAM_STAT_GOOD;
@@ -1181,7 +1204,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			ataCdb->generic.TransferBlockSize = 1;
 			ataCdb->generic.RegisterSelect = REG_COMMAND;
 			ataCdb->write.CommandByte = ATA_COMMAND_GET_MEDIA_STATUS;
-			srb->request_bufflen = 0;
+			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			US_DEBUGP("   Media Status not supported, just report okay\n");
 			srb->result = SAM_STAT_GOOD;
@@ -1287,7 +1310,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			ataCdb->generic.RegisterSelect = REG_COMMAND;
 			ataCdb->write.CommandByte = (srb->cmnd[4] & 0x1) ?
 				WIN_DOORLOCK : WIN_DOORUNLOCK;
-			srb->request_bufflen = 0;
+			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			US_DEBUGP("   Not removeable media, just report okay\n");
 			srb->result = SAM_STAT_GOOD;
@@ -1313,7 +1336,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			ataCdb->generic.TransferBlockSize = 1;
 			ataCdb->generic.RegisterSelect = REG_COMMAND;
 			ataCdb->write.CommandByte = ATA_COMMAND_GET_MEDIA_STATUS;
-			srb->request_bufflen = 0;
+			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			US_DEBUGP("   Nothing to do, just report okay\n");
 			srb->result = SAM_STAT_GOOD;
@@ -1422,7 +1445,7 @@ int isd200_Initialization(struct us_data *us)
 
 void isd200_ata_command(struct scsi_cmnd *srb, struct us_data *us)
 {
-	int sendToTransport = 1;
+	int sendToTransport = 1, orig_bufflen;
 	union ata_cdb ataCdb;
 
 	/* Make sure driver was initialized */
@@ -1430,11 +1453,14 @@ void isd200_ata_command(struct scsi_cmnd *srb, struct us_data *us)
 	if (us->extra == NULL)
 		US_DEBUGP("ERROR Driver not initialized\n");
 
-	/* Convert command */
-	srb->resid = 0;
+	scsi_set_resid(srb, 0);
+	/* scsi_bufflen might change in protocol translation to ata */
+	orig_bufflen = scsi_bufflen(srb);
 	sendToTransport = isd200_scsi_to_ata(srb, us, &ataCdb);
 
 	/* send the command to the transport layer */
 	if (sendToTransport)
 		isd200_invoke_transport(us, srb, &ataCdb);
+
+	isd200_srb_set_bufflen(srb, orig_bufflen);
 }
-- 
1.5.3.1


