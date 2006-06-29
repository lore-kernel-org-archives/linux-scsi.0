From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] 53c700: fix breakage caused by the autosense update
Date: Thu, 29 Jun 2006 13:02:11 -0400
Message-ID: <1151600532.6186.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:13458 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750990AbWF2RCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 13:02:12 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k5TH2CY23628
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2006 13:02:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

A bit of a brown paper bag issue.  The previous patch to remove the soon
to be ripped out fields that were used in autosense actually broke the
driver.  This patch fixes it and has been tested (honestly).

James

Index: BUILD-2.6/drivers/scsi/53c700.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/53c700.c	2006-06-29 10:38:39.000000000 -0400
+++ BUILD-2.6/drivers/scsi/53c700.c	2006-06-29 12:43:24.000000000 -0400
@@ -174,6 +174,7 @@
 STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
+STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
@@ -183,10 +184,6 @@
 
 STATIC struct scsi_transport_template *NCR_700_transport_template = NULL;
 
-struct NCR_700_sense {
-	unsigned char cmnd[MAX_COMMAND_SIZE];
-};
-
 static char *NCR_700_phase[] = {
 	"",
 	"after selection",
@@ -334,6 +331,7 @@
 	tpnt->use_clustering = ENABLE_CLUSTERING;
 	tpnt->slave_configure = NCR_700_slave_configure;
 	tpnt->slave_destroy = NCR_700_slave_destroy;
+	tpnt->slave_alloc = NCR_700_slave_alloc;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
 	tpnt->change_queue_type = NCR_700_change_queue_type;
 
@@ -612,9 +610,10 @@
 		struct NCR_700_command_slot *slot = 
 			(struct NCR_700_command_slot *)SCp->host_scribble;
 		
-		NCR_700_unmap(hostdata, SCp, slot);
+		dma_unmap_single(hostdata->dev, slot->pCmd,
+				 sizeof(SCp->cmnd), DMA_TO_DEVICE);
 		if (slot->flags == NCR_700_FLAG_AUTOSENSE) {
-			struct NCR_700_sense *sense = SCp->device->hostdata;
+			char *cmnd = NCR_700_get_sense_cmnd(SCp->device);
 #ifdef NCR_700_DEBUG
 			printk(" ORIGINAL CMD %p RETURNED %d, new return is %d sense is\n",
 			       SCp, SCp->cmnd[7], result);
@@ -625,10 +624,9 @@
 			/* restore the old result if the request sense was
 			 * successful */
 			if(result == 0)
-				result = sense->cmnd[7];
+				result = cmnd[7];
 		} else
-			dma_unmap_single(hostdata->dev, slot->pCmd,
-					 sizeof(SCp->cmnd), DMA_TO_DEVICE);
+			NCR_700_unmap(hostdata, SCp, slot);
 
 		free_slot(slot, hostdata);
 #ifdef NCR_700_DEBUG
@@ -970,14 +968,15 @@
 		   status_byte(hostdata->status[0]) == COMMAND_TERMINATED) {
 			struct NCR_700_command_slot *slot =
 				(struct NCR_700_command_slot *)SCp->host_scribble;
-			if(SCp->cmnd[0] == REQUEST_SENSE) {
+			if(slot->flags == NCR_700_FLAG_AUTOSENSE) {
 				/* OOPS: bad device, returning another
 				 * contingent allegiance condition */
 				scmd_printk(KERN_ERR, SCp,
 					"broken device is looping in contingent allegiance: ignoring\n");
 				NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 			} else {
-				struct NCR_700_sense *sense = SCp->device->hostdata;
+				char *cmnd =
+					NCR_700_get_sense_cmnd(SCp->device);
 #ifdef NCR_DEBUG
 				scsi_print_command(SCp);
 				printk("  cmd %p has status %d, requesting sense\n",
@@ -995,21 +994,21 @@
 						 sizeof(SCp->cmnd),
 						 DMA_TO_DEVICE);
 
-				sense->cmnd[0] = REQUEST_SENSE;
-				sense->cmnd[1] = (SCp->device->lun & 0x7) << 5;
-				sense->cmnd[2] = 0;
-				sense->cmnd[3] = 0;
-				sense->cmnd[4] = sizeof(SCp->sense_buffer);
-				sense->cmnd[5] = 0;
+				cmnd[0] = REQUEST_SENSE;
+				cmnd[1] = (SCp->device->lun & 0x7) << 5;
+				cmnd[2] = 0;
+				cmnd[3] = 0;
+				cmnd[4] = sizeof(SCp->sense_buffer);
+				cmnd[5] = 0;
 				/* Here's a quiet hack: the
 				 * REQUEST_SENSE command is six bytes,
 				 * so store a flag indicating that
 				 * this was an internal sense request
 				 * and the original status at the end
 				 * of the command */
-				sense->cmnd[6] = NCR_700_INTERNAL_SENSE_MAGIC;
-				sense->cmnd[7] = hostdata->status[0];
-				slot->pCmd = dma_map_single(hostdata->dev, sense->cmnd, sizeof(sense->cmnd), DMA_TO_DEVICE);
+				cmnd[6] = NCR_700_INTERNAL_SENSE_MAGIC;
+				cmnd[7] = hostdata->status[0];
+				slot->pCmd = dma_map_single(hostdata->dev, cmnd, MAX_COMMAND_SIZE, DMA_TO_DEVICE);
 				slot->dma_handle = dma_map_single(hostdata->dev, SCp->sense_buffer, sizeof(SCp->sense_buffer), DMA_FROM_DEVICE);
 				slot->SG[0].ins = bS_to_host(SCRIPT_MOVE_DATA_IN | sizeof(SCp->sense_buffer));
 				slot->SG[0].pAddr = bS_to_host(slot->dma_handle);
@@ -1531,7 +1530,7 @@
 
 			/* clear all the negotiated parameters */
 			__shost_for_each_device(SDp, host)
-				SDp->hostdata = NULL;
+				NCR_700_clear_flag(SDp, ~0);
 			
 			/* clear all the slots and their pending commands */
 			for(i = 0; i < NCR_700_COMMAND_SLOTS_PER_HOST; i++) {
@@ -2036,7 +2035,17 @@
 	spi_flags(STp) |= NCR_700_DEV_PRINT_SYNC_NEGOTIATION;
 }
 
+STATIC int
+NCR_700_slave_alloc(struct scsi_device *SDp)
+{
+	SDp->hostdata = kzalloc(sizeof(struct NCR_700_Device_Parameters),
+				GFP_KERNEL);
 
+	if (!SDp->hostdata)
+		return -ENOMEM;
+
+	return 0;
+}
 
 STATIC int
 NCR_700_slave_configure(struct scsi_device *SDp)
@@ -2044,11 +2053,6 @@
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
 
-	SDp->hostdata = kmalloc(sizeof(struct NCR_700_sense), GFP_KERNEL);
-
-	if (!SDp->hostdata)
-		return -ENOMEM;
-
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
 		scsi_set_tag_type(SDp, MSG_ORDERED_TAG);
Index: BUILD-2.6/drivers/scsi/53c700.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/53c700.h	2006-06-29 12:00:27.000000000 -0400
+++ BUILD-2.6/drivers/scsi/53c700.h	2006-06-29 12:24:01.000000000 -0400
@@ -12,10 +12,11 @@
 #include <asm/io.h>
 
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
 
 
 /* Turn on for general debugging---too verbose for normal use */
-#define	NCR_700_DEBUG
+#undef	NCR_700_DEBUG
 /* Debug the tag queues, checking hash queue allocation and deallocation
  * and search for duplicate tags */
 #undef NCR_700_TAG_DEBUG
@@ -76,11 +77,16 @@
 	#define	SCRIPT_RETURN			0x90080000
 };
 
-/* We use device->hostdata to store negotiated parameters.  This is
- * supposed to be a pointer to a device private area, but we cannot
- * really use it as such since it will never be freed, so just use the
- * 32 bits to cram the information.  The SYNC negotiation sequence looks
- * like:
+struct NCR_700_Device_Parameters {
+	/* space for creating a request sense command. Really, except
+	 * for the annoying SCSI-2 requirement for LUN information in
+	 * cmnd[1], this could be in static storage */
+	unsigned char cmnd[MAX_COMMAND_SIZE];
+	__u8	depth;
+};
+
+
+/* The SYNC negotiation sequence looks like:
  * 
  * If DEV_NEGOTIATED_SYNC not set, tack and SDTR message on to the
  * initial identify for the device and set DEV_BEGIN_SYNC_NEGOTATION
@@ -98,19 +104,26 @@
 #define NCR_700_DEV_BEGIN_SYNC_NEGOTIATION	(1<<17)
 #define NCR_700_DEV_PRINT_SYNC_NEGOTIATION (1<<19)
 
+static inline char *NCR_700_get_sense_cmnd(struct scsi_device *SDp)
+{
+	struct NCR_700_Device_Parameters *hostdata = SDp->hostdata;
+
+	return hostdata->cmnd;
+}
+
 static inline void
 NCR_700_set_depth(struct scsi_device *SDp, __u8 depth)
 {
-	long l = (long)SDp->hostdata;
+	struct NCR_700_Device_Parameters *hostdata = SDp->hostdata;
 
-	l &= 0xffff00ff;
-	l |= 0xff00 & (depth << 8);
-	SDp->hostdata = (void *)l;
+	hostdata->depth = depth;
 }
 static inline __u8
 NCR_700_get_depth(struct scsi_device *SDp)
 {
-	return ((((unsigned long)SDp->hostdata) & 0xff00)>>8);
+	struct NCR_700_Device_Parameters *hostdata = SDp->hostdata;
+
+	return hostdata->depth;
 }
 static inline int
 NCR_700_is_flag_set(struct scsi_device *SDp, __u32 flag)


