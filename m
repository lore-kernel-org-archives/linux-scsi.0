From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] update 53c700 to use the change_queue_type API
Date: Thu, 23 Dec 2004 12:29:12 -0600
Message-ID: <1103826552.5290.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21468 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261223AbULWS3T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 13:29:19 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id iBNITIF23739
	for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2004 13:29:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

I'm afraid this isn't necessarily a good one to copy.  Because of its
need to try to limit interrupts, the 53c700 has to distinguish tagged or
untagged based on the initial selection (i.e. it doesn't know the LUN
when it decides whether to accept M_IDENTIFY or M_IDENTIFY + TAG), so
all TCQ is controlled in this driver at the target level.

Thus, all the target quiesces and the tag bitmap probably wouldn't be
present on a modern SCSI processor.

James

===== drivers/scsi/53c700.c 1.59 vs edited =====
--- 1.59/drivers/scsi/53c700.c	2004-12-19 13:21:53 -06:00
+++ edited/drivers/scsi/53c700.c	2004-12-23 11:52:37 -06:00
@@ -177,6 +177,7 @@
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
+static int NCR_700_change_queue_type(struct scsi_device *SDpnt, int depth);
 
 STATIC struct device_attribute *NCR_700_dev_attrs[];
 
@@ -340,6 +341,7 @@
 	tpnt->slave_configure = NCR_700_slave_configure;
 	tpnt->slave_destroy = NCR_700_slave_destroy;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
+	tpnt->change_queue_type = NCR_700_change_queue_type;
 	
 	if(tpnt->name == NULL)
 		tpnt->name = "53c700";
@@ -926,10 +928,11 @@
 				spi_offset(SCp->device->sdev_target) = 0;
 			NCR_700_set_flag(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC);
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
-		} else if(SCp != NULL && NCR_700_is_flag_set(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING)) {
+		} else if(SCp != NULL && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_DURING_TAG_NEGOTIATION) {
 			/* rejected our first simple tag message */
 			printk(KERN_WARNING "scsi%d (%d:%d) Rejected first tag queue attempt, turning off tag queueing\n", host->host_no, pun, lun);
-			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
+			/* we're done negotiating */
+			NCR_700_set_tag_neg_state(SCp->device, NCR_700_FINISHED_TAG_NEGOTIATION);
 			hostdata->tag_negotiated &= ~(1<<SCp->device->id);
 			SCp->device->tagged_supported = 0;
 			scsi_deactivate_tcq(SCp->device, host->cmd_per_lun);
@@ -991,8 +994,11 @@
 	if(dsps == A_GOOD_STATUS_AFTER_STATUS) {
 		DEBUG(("  COMMAND COMPLETE, status=%02x\n",
 		       hostdata->status[0]));
-		/* OK, if TCQ still on, we know it works */
-		NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
+		/* OK, if TCQ still under negotiation, we now know it works */
+		if (NCR_700_get_tag_neg_state(SCp->device) == NCR_700_DURING_TAG_NEGOTIATION)
+			NCR_700_set_tag_neg_state(SCp->device,
+						  NCR_700_FINISHED_TAG_NEGOTIATION);
+			
 		/* check for contingent allegiance contitions */
 		if(status_byte(hostdata->status[0]) == CHECK_CONDITION ||
 		   status_byte(hostdata->status[0]) == COMMAND_TERMINATED) {
@@ -1813,23 +1819,12 @@
 	printk("53c700: scsi%d, command ", SCp->device->host->host_no);
 	scsi_print_command(SCp);
 #endif
-	if(SCp->device->tagged_supported && !SCp->device->simple_tags
-	   && (hostdata->tag_negotiated &(1<<SCp->device->id)) == 0
-	   && NCR_700_is_flag_clear(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING)) {
-		/* upper layer has indicated tags are supported.  We don't
-		 * necessarily believe it yet.
-		 *
-		 * NOTE: There is a danger here: the mid layer supports
-		 * tag queuing per LUN.  We only support it per PUN because
-		 * of potential reselection issues */
-		scsi_activate_tcq(SCp->device, NCR_700_DEFAULT_TAGS);
-	}
-
 	if(blk_rq_tagged(SCp->request)
-	   && (hostdata->tag_negotiated &(1<<SCp->device->id)) == 0) {
-		printk(KERN_INFO "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
+	   && (hostdata->tag_negotiated &(1<<SCp->device->id)) == 0
+	   && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_START_TAG_NEGOTIATION) {
+		printk(KERN_ERR "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
 		hostdata->tag_negotiated |= (1<<SCp->device->id);
-		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
+		NCR_700_set_tag_neg_state(SCp->device, NCR_700_DURING_TAG_NEGOTIATION);
 	}
 
 	/* here we may have to process an untagged command.  The gate
@@ -1844,7 +1839,8 @@
 		hostdata->tag_negotiated &= ~(1<<SCp->device->id);
 	}
 
-	if((hostdata->tag_negotiated &(1<<SCp->device->id))) {
+	if((hostdata->tag_negotiated &(1<<SCp->device->id))
+	   && scsi_get_tag_type(SCp->device)) {
 		slot->tag = SCp->request->tag;
 		DEBUG(("53c700 %d:%d:%d, sending out tag %d, slot %p\n",
 		       SCp->device->host->host_no, SCp->device->id, SCp->device->lun, slot->tag,
@@ -2082,7 +2078,9 @@
 
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
-		/* do TCQ stuff here */
+		scsi_set_tag_type(SDp, MSG_ORDERED_TAG);
+		scsi_activate_tcq(SDp, NCR_700_DEFAULT_TAGS);
+		NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
 	} else {
 		/* initialise to default depth */
 		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
@@ -2107,11 +2105,45 @@
 static int
 NCR_700_change_queue_depth(struct scsi_device *SDp, int depth)
 {
-	if(depth > NCR_700_MAX_TAGS)
+	if (depth > NCR_700_MAX_TAGS)
 		depth = NCR_700_MAX_TAGS;
-	scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, depth);
 
+	scsi_adjust_queue_depth(SDp, scsi_get_tag_type(SDp), depth);
 	return depth;
+}
+
+static int NCR_700_change_queue_type(struct scsi_device *SDp, int tag_type)
+{
+	int change_tag = ((tag_type ==0 &&  scsi_get_tag_type(SDp) != 0)
+			  || (tag_type != 0 && scsi_get_tag_type(SDp) == 0));
+	struct NCR_700_Host_Parameters *hostdata = 
+		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
+
+	scsi_set_tag_type(SDp, tag_type);
+
+	/* We have a global (per target) flag to track whether TCQ is
+	 * enabled, so we'll be turning it off for the entire target here.
+	 * our tag algorithm will fail if we mix tagged and untagged commands,
+	 * so quiesce the device before doing this */
+	if (change_tag)
+		scsi_target_quiesce(SDp->sdev_target);
+
+	if (!tag_type) {
+		/* shift back to the default unqueued number of commands
+		 * (the user can still raise this) */
+		scsi_deactivate_tcq(SDp, SDp->host->cmd_per_lun);
+		hostdata->tag_negotiated &= ~(1 << SDp->id);
+	} else {
+		/* Here, we cleared the negotiation flag above, so this
+		 * will force the driver to renegotiate */
+		scsi_activate_tcq(SDp, SDp->queue_depth);
+		if (change_tag)
+			NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
+	}
+	if (change_tag)
+		scsi_target_resume(SDp->sdev_target);
+
+	return tag_type;
 }
 
 static ssize_t
===== drivers/scsi/53c700.h 1.19 vs edited =====
--- 1.19/drivers/scsi/53c700.h	2004-10-11 15:26:54 -05:00
+++ edited/drivers/scsi/53c700.h	2004-12-23 10:04:50 -06:00
@@ -102,7 +102,6 @@
  * 18 device supports tag queueing */
 #define NCR_700_DEV_NEGOTIATED_SYNC	(1<<16)
 #define NCR_700_DEV_BEGIN_SYNC_NEGOTIATION	(1<<17)
-#define NCR_700_DEV_BEGIN_TAG_QUEUEING	(1<<18)
 #define NCR_700_DEV_PRINT_SYNC_NEGOTIATION (1<<19)
 
 static inline void
@@ -138,6 +137,27 @@
 NCR_700_clear_flag(struct scsi_device *SDp, __u32 flag)
 {
 	spi_flags(SDp->sdev_target) &= ~flag;
+}
+
+enum NCR_700_tag_neg_state {
+	NCR_700_START_TAG_NEGOTIATION = 0,
+	NCR_700_DURING_TAG_NEGOTIATION = 1,
+	NCR_700_FINISHED_TAG_NEGOTIATION = 2,
+};
+
+static inline enum NCR_700_tag_neg_state
+NCR_700_get_tag_neg_state(struct scsi_device *SDp)
+{
+	return (enum NCR_700_tag_neg_state)((spi_flags(SDp->sdev_target)>>20) & 0x3);
+}
+
+static inline void
+NCR_700_set_tag_neg_state(struct scsi_device *SDp,
+			  enum NCR_700_tag_neg_state state)
+{
+	/* clear the slot */
+	spi_flags(SDp->sdev_target) &= ~(0x3 << 20);
+	spi_flags(SDp->sdev_target) |= ((__u32)state) << 20;
 }
 
 struct NCR_700_command_slot {


